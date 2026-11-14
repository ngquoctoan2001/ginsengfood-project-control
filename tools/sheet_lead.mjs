#!/usr/bin/env node
// Ghi kết quả rà soát của Lead lên Sheet "Theo dõi task - GINSENGFOOD" bằng code, không qua trình duyệt.
// Cột "Lead duyệt" (W) và "Ghi chú Lead" (X) bị API chung chặn (leadOnly); lệnh leadReview của web app (Code.gs ≥ 1.5.0,
// bản ở tools/sheet-lead/Code.gs) chỉ nhận khi có khoá riêng của Lead, lưu ngoài mọi repo, không in ra.
//
//   node tools/sheet_lead.mjs tao-khoa                      tạo khoá Lead (nếu chưa có), in mã băm SHA-256 để đặt vào Code.gs
//   node tools/sheet_lead.mjs kiem                          phiên bản web app + khoá Lead có được nhận không
//   node tools/sheet_lead.mjs can-ra [--module M5] [--owner Tài] [--json tệp]
//                                                           task cần rà: Hoàn thành/Chờ review, Lead duyệt chưa "Đạt"
//   node tools/sheet_lead.mjs ghi <ket-qua.json> [--dry-run]
//                                                           ghi W/X (task của Lead: thêm J, H tự tính), rồi đọc lại đối chiếu
//
// ket-qua.json: [{ "id": "M5-034", "verdict": "Đạt" | "Cần sửa", "sha": "77f66d5", "note": "…",
//                  "reviewedAt": "2026-11-03 14:30", "status": "Đang làm" (tuỳ chọn, chỉ task của Lead khi Cần sửa) }]
// reviewedAt = giờ đọc Sheet lúc bắt đầu rà (giờ VN). Task có "Cập nhật lúc" muộn hơn thì web app từ chối mục đó:
// người làm đã đổi task sau lúc rà, phải rà lại phần mới.

import { createHash, randomBytes } from 'node:crypto';
import { existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { homedir } from 'node:os';
import { dirname, join } from 'node:path';

const SHEET_CONFIG = process.env.GF_TASK_SHEET_CONFIG || 'C:/Projects/ginsengfood-ops-core/tools/task-tracker/sheet.json';
const KEY_FILE = process.env.GF_LEAD_KEY_FILE || join(homedir(), '.ginsengfood', 'lead-sheet-key');
const NEED_VERSION = '1.5.0';
const BATCH = 25;
const IN_SCOPE = ['Hoàn thành', 'Chờ review'];
const VERDICTS = { 'đạt': 'Đạt', 'đạt phạm vi': 'Đạt', 'cần sửa': 'Cần sửa' };
const LEAD_NAME = 'Nguyễn Quốc Toàn';
// Cột web app được phép đổi khi ghi kết quả rà; mọi cột khác phải giữ nguyên sau khi ghi.
const LEAD_TASK_COLS = ['leadReview', 'leadNote', 'status', 'statusCode', 'ready', 'progress', 'startDate', 'doneDate', 'updatedAt', 'updatedBy'];
const OTHER_TASK_COLS = ['leadReview', 'leadNote'];

function out(obj) {
  process.stdout.write(JSON.stringify(obj, null, 2) + '\n');
}

function fail(message, code = 1) {
  out({ ok: false, error: message });
  process.exit(code);
}

function parseArgs(argv) {
  const [command, ...rest] = argv;
  const opts = {};
  const positional = [];
  for (let i = 0; i < rest.length; i++) {
    const a = rest[i];
    if (!a.startsWith('--')) positional.push(a);
    else if (a === '--dry-run') opts['dry-run'] = true;
    else opts[a.slice(2)] = rest[++i];
  }
  return { command, opts, positional };
}

function readJson(file) {
  const text = readFileSync(file, 'utf8');
  return JSON.parse(text.charCodeAt(0) === 0xfeff ? text.slice(1) : text);
}

function connection() {
  if (!existsSync(SHEET_CONFIG)) fail(`Không thấy ${SHEET_CONFIG} (đặt GF_TASK_SHEET_CONFIG nếu để chỗ khác)`, 2);
  const c = readJson(SHEET_CONFIG);
  if (!c.webAppUrl || !c.token) fail(`${SHEET_CONFIG} thiếu webAppUrl hoặc token`, 2);
  return { url: c.webAppUrl, token: c.token };
}

function leadKey() {
  if (!existsSync(KEY_FILE)) fail(`Chưa có khoá Lead ở ${KEY_FILE}: chạy "tao-khoa" rồi đặt mã băm vào Code.gs`, 2);
  return readFileSync(KEY_FILE, 'utf8').trim();
}

const sha256 = (s) => createHash('sha256').update(s, 'utf8').digest('hex');

async function call(conn, payload) {
  const res = await fetch(conn.url, {
    method: 'POST',
    headers: { 'Content-Type': 'text/plain;charset=utf-8' },
    body: JSON.stringify({ ...payload, token: conn.token }),
    redirect: 'follow',
    signal: AbortSignal.timeout(120000),
  });
  const text = await res.text();
  try {
    return JSON.parse(text);
  } catch {
    throw new Error(`Web app không trả JSON (HTTP ${res.status})`);
  }
}

async function listAll(conn, module) {
  const r = await call(conn, { action: 'list', module });
  if (!r.ok) fail('Đọc Sheet lỗi: ' + r.error, 3);
  return r.tasks;
}

const norm = (s) => String(s ?? '').normalize('NFC').replace(/\s+/g, ' ').trim();
const isLeadOwner = (owner) => norm(owner).replace(/\s*\(.*\)$/, '') === LEAD_NAME;

// Giờ rà gần nhất trong "Ghi chú Lead": mọi dạng "dd/mm/yyyy … HH:mm" các lượt trước đã ghi, lấy mốc muộn nhất.
function lastReviewAt(note) {
  let best = '';
  for (const m of String(note || '').matchAll(/(\d{2})\/(\d{2})\/(\d{4})\D{0,24}?(\d{2}):(\d{2})/g)) {
    const s = `${m[3]}-${m[2]}-${m[1]} ${m[4]}:${m[5]}`;
    if (s > best) best = s;
  }
  return best;
}

function nowVn() {
  const p = Object.fromEntries(new Intl.DateTimeFormat('en-GB', {
    timeZone: 'Asia/Ho_Chi_Minh', year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', hourCycle: 'h23',
  }).formatToParts(new Date()).map((x) => [x.type, x.value]));
  return `${p.year}-${p.month}-${p.day} ${p.hour}:${p.minute}`;
}

/* ───────── Lệnh ───────── */

function taoKhoa() {
  if (!existsSync(KEY_FILE)) {
    mkdirSync(dirname(KEY_FILE), { recursive: true });
    writeFileSync(KEY_FILE, randomBytes(32).toString('hex') + '\n', { mode: 0o600, flag: 'wx' });
    out({ ok: true, created: true, file: KEY_FILE, sha256: sha256(leadKey()) });
  } else {
    out({ ok: true, created: false, file: KEY_FILE, sha256: sha256(leadKey()) });
  }
}

async function kiem() {
  const conn = connection();
  const ping = await call(conn, { action: 'ping' });
  if (!ping.ok) fail('ping lỗi: ' + ping.error, 3);
  const lp = existsSync(KEY_FILE) ? await call(conn, { action: 'leadPing', leadKey: leadKey() }) : { ok: false, error: 'chưa có khoá' };
  out({
    ok: Boolean(lp.ok), version: ping.version, need: NEED_VERSION, leadKeyAccepted: Boolean(lp.ok),
    note: lp.ok ? 'Ghi được cột Lead bằng code.' : (lp.error === 'UNKNOWN_ACTION: leadPing'
      ? `Web app còn bản ${ping.version}: dán tools/sheet-lead/Code.gs vào Apps Script rồi triển khai phiên bản mới.`
      : 'Khoá Lead chưa được nhận: ' + lp.error),
  });
}

async function canRa(opts) {
  const conn = connection();
  const tasks = (await listAll(conn, opts.module)).filter((t) => IN_SCOPE.includes(t.status) && t.leadReview !== 'Đạt')
    .filter((t) => !opts.owner || norm(t.owner).toLowerCase().includes(norm(opts.owner).toLowerCase()));
  const rows = tasks.map((t) => {
    const last = lastReviewAt(t.leadNote);
    const waiting = t.leadReview === 'Cần sửa' && last && !(String(t.updatedAt || '') > last);
    return {
      id: t.id, owner: t.owner, lead: isLeadOwner(t.owner), status: t.status, leadReview: t.leadReview || '',
      updatedAt: t.updatedAt || '', lastReviewAt: last, group: waiting ? 'chờ sửa' : 'cần rà', title: t.title,
    };
  });
  const snapshot = { readAt: nowVn(), module: opts.module || 'tất cả', owner: opts.owner || 'tất cả', tasks: rows };
  if (opts.json) writeFileSync(opts.json, JSON.stringify({ ...snapshot, raw: tasks }, null, 1));
  const lines = rows.map((r) => [r.id, r.group, r.status, r.leadReview || '-', r.owner, r.updatedAt, r.lastReviewAt || '-'].join(' | '));
  process.stdout.write(`Đọc lúc ${snapshot.readAt} · ${rows.filter((r) => r.group === 'cần rà').length} cần rà, `
    + `${rows.filter((r) => r.group === 'chờ sửa').length} chờ người làm sửa (Cần sửa, chưa cập nhật sau lượt rà)\n`
    + 'id | nhóm | trạng thái | Lead duyệt | người phụ trách | cập nhật lúc | rà lần cuối\n' + lines.join('\n') + '\n');
}

function checkItems(items) {
  if (!Array.isArray(items) || !items.length) fail('Tệp kết quả phải là mảng JSON có ít nhất 1 mục');
  const seen = new Set();
  const errors = [];
  const clean = items.map((x, i) => {
    const where = `Mục ${i + 1}${x && x.id ? ' (' + x.id + ')' : ''}: `;
    const id = norm(x && x.id).toUpperCase();
    const verdict = VERDICTS[norm(x && x.verdict).toLowerCase()];
    if (!id) errors.push(where + 'thiếu id');
    else if (seen.has(id)) errors.push(where + 'trùng id');
    seen.add(id);
    if (!verdict) errors.push(where + `verdict "${x && x.verdict}" không hợp lệ. Rà xong chỉ có "Đạt" hoặc "Cần sửa"; thiếu bằng chứng là "Cần sửa", ghi rõ cần bổ sung gì`);
    if (!norm(x && x.note)) errors.push(where + 'thiếu note (bằng chứng; nếu Cần sửa thì việc phải sửa)');
    if (!/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}$/.test(norm(x && x.reviewedAt))) errors.push(where + 'reviewedAt phải dạng "yyyy-MM-dd HH:mm" (giờ đọc Sheet lúc bắt đầu rà)');
    return { id, verdict, sha: norm(x && x.sha), note: String(x.note || '').replace(/\r\n/g, '\n').trim(), reviewedAt: norm(x && x.reviewedAt),
      ...(x && x.status ? { status: norm(x.status) } : {}), ...(x && x.force ? { force: true } : {}) };
  });
  if (errors.length) fail(errors.join('\n'));
  return clean;
}

function diffCols(before, after, allowed) {
  return Object.keys({ ...before, ...after }).filter((k) => !allowed.includes(k) && k !== 'row'
    && JSON.stringify(before[k] ?? null) !== JSON.stringify(after[k] ?? null));
}

async function ghi(file, opts) {
  const items = checkItems(readJson(file));
  const conn = connection();
  const before = new Map((await listAll(conn)).map((t) => [t.id, t]));
  const plan = items.map((x) => {
    const t = before.get(x.id);
    if (!t) fail(`${x.id}: không thấy trên Sheet`, 3);
    const lead = isLeadOwner(t.owner);
    if (!lead && x.status) fail(`${x.id}: task của ${t.owner}, không đổi Trạng thái; chỉ ghi Lead duyệt và Ghi chú Lead`);
    return { ...x, owner: t.owner, lead, from: { W: t.leadReview || '', J: t.status, updatedAt: t.updatedAt || '' } };
  });
  if (opts['dry-run']) {
    return out({ ok: true, dryRun: true, items: plan.map((p) => ({ id: p.id, owner: p.owner, lead: p.lead,
      W: `${p.from.W || '-'} → ${p.verdict}`, J: p.lead ? `${p.from.J} → ${p.verdict === 'Đạt' ? 'Hoàn thành' : (p.status || 'Đang làm')}` : 'giữ nguyên',
      changedAfterReview: String(p.from.updatedAt) > p.reviewedAt, noteChars: p.note.length })) });
  }

  const key = leadKey();
  const results = [];
  for (let i = 0; i < items.length; i += BATCH) {
    const r = await call(conn, { action: 'leadReview', leadKey: key, actor: LEAD_NAME + ' (rà soát)', items: items.slice(i, i + BATCH) });
    if (!r.ok) {
      results.push({ batch: i / BATCH + 1, ok: false, error: r.error });
      break;
    }
    results.push(...r.results);
  }

  const after = new Map((await listAll(conn)).map((t) => [t.id, t]));
  const check = plan.map((p) => {
    const b = before.get(p.id);
    const a = after.get(p.id);
    const written = results.find((r) => r.id === p.id);
    const problems = [];
    if (!written) problems.push('chưa ghi');
    if (a.leadReview !== p.verdict) problems.push(`W = ${a.leadReview}`);
    const tail = `${p.sha ? '| SHA ' + p.sha : ''}] ${p.verdict}. ${p.note}`;
    if (!String(a.leadNote || '').includes(tail)) problems.push('X chưa có khối rà');
    if (!String(a.leadNote || '').startsWith(String(b.leadNote || ''))) problems.push('X mất ghi chú cũ');
    if (p.lead) {
      const wantJ = p.verdict === 'Đạt' ? 'Hoàn thành' : (p.status || 'Đang làm');
      if (a.status !== wantJ) problems.push(`J = ${a.status}, cần ${wantJ}`);
      const wantH = { 'Hoàn thành': 'Đã xong', 'Đang làm': 'Đang chạy', 'Bị chặn': 'Bị chặn' }[wantJ];
      if (wantH && a.ready !== wantH) problems.push(`H = ${a.ready}, cần ${wantH}`);
    }
    const moved = diffCols(b, a, p.lead ? LEAD_TASK_COLS : OTHER_TASK_COLS);
    if (moved.length) problems.push('cột ngoài phạm vi đổi: ' + moved.join(', '));
    return { id: p.id, owner: p.owner, lead: p.lead, W: a.leadReview, J: a.status, H: a.ready, ok: !problems.length, problems };
  });
  const base = file.replace(/\.json$/i, '');
  writeFileSync(base + '.truoc.json', JSON.stringify(plan.map((p) => before.get(p.id)), null, 1));
  writeFileSync(base + '.sau.json', JSON.stringify(plan.map((p) => after.get(p.id)), null, 1));
  const failed = results.filter((r) => r.ok === false);
  const bad = check.filter((c) => !c.ok);
  out({ ok: !failed.length && !bad.length, written: results.filter((r) => r.ok !== false).length, verified: check.length - bad.length,
    of: items.length, errors: failed, problems: bad, readback: base + '.sau.json' });
  if (failed.length || bad.length) process.exitCode = 3;
}

async function main() {
  const { command, opts, positional } = parseArgs(process.argv.slice(2));
  if (command === 'tao-khoa') return taoKhoa();
  if (command === 'kiem') return kiem();
  if (command === 'can-ra') return canRa(opts);
  if (command === 'ghi' && positional[0]) return ghi(positional[0], opts);
  process.stdout.write(readFileSync(new URL(import.meta.url), 'utf8').split('\n').slice(1, 18).map((l) => l.replace(/^\/\/ ?/, '')).join('\n') + '\n');
  process.exitCode = command ? 1 : 0;
}

main().catch((err) => fail(err.message, 3));
