// Independent review probes; synthetic data only. Pass the isolated 650f8a5 worktree as argv[2].
// Run in the repo runner's childEnv; no shared DB, no external partner calls, no production flags.
const fs = require('node:fs');
const path = require('node:path');
const root = path.resolve(process.argv[2]);
const from = (p) => require(path.join(root, p));
from('node_modules/ts-node').register({ transpileOnly: true, project: path.join(root, 'tsconfig.json') });
from('node_modules/reflect-metadata');
const { Logger } = from('node_modules/@nestjs/common');
const observations = [];

async function main() {
  const { JsonLogger } = from('src/observability/json-logger.ts');
  const marker = ['review', 'synthetic', 'value'].join('-');
  const capture = (fn) => {
    const previous = process.stdout.write;
    let output = '';
    process.stdout.write = (chunk) => { output += String(chunk); return true; };
    try { fn(); } finally { process.stdout.write = previous; }
    return output;
  };
  const logger = new JsonLogger();
  const objectLine = capture(() => logger.log({ password: marker, nested: { api_key: marker } }));
  const textLine = capture(() => logger.log('password=' + marker));
  observations.push({ case: 'json_logger_secret_key', objectValueLeaked: objectLine.includes(marker), stringControlMasked: !textLine.includes(marker) });

  const { PrismaRollbackFlagStore } = from('src/suppression/adapters/real/prisma-rollback-flag-store.ts');
  const { RollbackFlag } = from('src/suppression/domain/rollback-flags.ts');
  let reads = 0, releaseReads, releaseA;
  const bothRead = new Promise((resolve) => { releaseReads = resolve; });
  const aCommitted = new Promise((resolve) => { releaseA = resolve; });
  let value = false;
  const audits = [];
  const fake = { $transaction: async (fn) => {
    let wroteOn = false;
    const result = await fn({ featureFlag: {
      findUnique: async () => { const before = value; if (++reads === 2) releaseReads(); await bothRead; return { enabled: before }; },
      upsert: async ({ update }) => { wroteOn = update.enabled; if (!wroteOn) await aCommitted; value = update.enabled; },
    }, auditLog: { create: async ({ data }) => { audits.push({ actor: data.actorRole, decision: data.decision }); } } });
    if (wroteOn) releaseA();
    return result;
  } };
  const flags = new PrismaRollbackFlagStore(fake);
  await Promise.all([flags.set(RollbackFlag.DISABLE_GATEWAY_OUTBOUND, true, 'review-a'), flags.set(RollbackFlag.DISABLE_GATEWAY_OUTBOUND, false, 'review-b')]);
  observations.push({ case: 'rollback_audit_concurrency_fake_db', finalEnabled: value, audits, secondAuditCorrect: audits[1].decision === 'ON->OFF', limitation: 'Deterministic fake transaction interleaving; no PostgreSQL run.' });

  const doc = fs.readFileSync(path.join(root, 'docs/05-reference/text-set-v1.md'), 'utf8');
  const publicRows = doc.split(/\r?\n/).filter((line) => /^\| `(ACK_|FALLBACK_)/.test(line));
  const publicBodies = publicRows.map((line) => ({ name: line.split('|')[1].trim().replaceAll('`', ''), body: [...line.split('|')[3].matchAll(/`([^`]+)`/g)].map((m) => m[1]).join('\n'), public: true }));
  const label = 'Bạn đang trò chuyện với trợ lý AI của GinsengFood.';
  const privateBodies = [...doc.matchAll(/^- Chữ: `([^`]+)`/gm)].filter((m) => m[1] !== label).map((m, i) => ({ name: 'PRIVATE_' + (i + 1), body: m[1], public: false }));
  if (publicBodies.length !== 4 || privateBodies.length !== 3) throw new Error('TEXT_EXTRACTION_COUNT');
  const variants = [...publicBodies, ...privateBodies, ...privateBodies.map((v) => ({ ...v, name: v.name + '_FIRST', body: label + '\n' + v.body }))];
  const ownerLexicon = JSON.parse(doc.match(/```json\s*([\s\S]*?)```/)[1]);
  const { MockFinalGuard } = from('src/outbound-guard/adapters/mock/mock-final-guard.ts');
  const { containsSensitiveOutbound } = from('src/foundation/evidence/masking.ts');
  const { OutboundClass, PaymentState } = from('src/outbound-guard/domain/enums.ts');
  const wordingResults = [];
  for (const mode of ['SEED', 'V1']) {
    delete process.env.M5_META_SAFE_LEXICON_FILE;
    if (mode === 'V1') process.env.M5_META_SAFE_LEXICON_JSON = JSON.stringify(ownerLexicon);
    else delete process.env.M5_META_SAFE_LEXICON_JSON;
    const guard = new MockFinalGuard();
    for (const variant of variants) {
      const verdict = guard.verify({ candidateBody: variant.body, outboundClass: variant.public ? OutboundClass.PUBLIC_ACK : OutboundClass.PRIVATE_CONSULT, paymentState: PaymentState.WAITING });
      wordingResults.push({ mode, name: variant.name, status: verdict.status, publicSafe: verdict.publicSafe, sensitive: containsSensitiveOutbound(variant.body) });
    }
  }
  delete process.env.M5_META_SAFE_LEXICON_JSON;
  observations.push({ case: 'text_set_current_guard', total: wordingResults.length, pass: wordingResults.filter((v) => v.status === 'PASS' && !v.sensitive && v.publicSafe).length, results: wordingResults, limitation: 'Current MockFinalGuard and outbound masker only; not owner approval, full send pipeline, Meta, or future real guard.' });

  process.env.RBAC_MODE = 'dev-header';
  const { NestFactory } = from('node_modules/@nestjs/core');
  const { AppModule } = from('src/app.module.ts');
  const { PAGE_REGISTRY } = from('src/channel-identity/tokens.ts');
  const { Permission } = from('src/foundation/rbac/rbac.types.ts');
  const app = await NestFactory.create(AppModule, { logger: false });
  try {
    await app.listen(0, '127.0.0.1');
    const port = app.getHttpServer().address().port;
    const pageId = 'REVIEW-PAGE-ENUM';
    const response = await fetch('http://127.0.0.1:' + port + '/api/admin/facebook/pages', { method: 'POST', headers: { 'Content-Type': 'application/json', 'x-m5-permissions': Permission.ADMIN_PAGE_WRITE }, body: JSON.stringify({ sourcePageId: pageId, pageRole: 'COMMERCE_HUB', channelCode: 'MESSENGER', appMode: 'TYPO', hasMessagingCapability: true, tokenRef: 'secret_ref://mock/review-page' }) });
    const body = await response.json();
    const resolved = app.get(PAGE_REGISTRY).resolve(pageId);
    observations.push({ case: 'admin_page_invalid_enum_http', httpStatus: response.status, returnedInvalidMode: body.appMode === 'TYPO', registryResolved: resolved !== null, expectation: '400 INVALID_ENUM before mutation' });
  } finally { await app.close(); }
  const out = path.join(__dirname, '2026-11-02-tai-repro.json');
  const report = { sourceSha: '650f8a55204b29faf108fd63e1d4fcfcd56c3e44', observations };
  fs.writeFileSync(out, JSON.stringify(report, null, 2) + '\n');
  console.log(JSON.stringify({ sourceSha: report.sourceSha, results: observations.map(({ results, ...item }) => item), output: out }, null, 2));
}
main().catch((error) => { console.error('REVIEW_REPRO_FAILED', JSON.stringify({ name: error && error.name, code: String(error && error.message).replace(/\b\d{10,}\b/g, '<digits>').replace(/(?:https?|postgresql|redis):\/\/\S+/g, '<url>').slice(0, 300), completed: observations.map((v) => v.case) })); process.exitCode = 1; });
