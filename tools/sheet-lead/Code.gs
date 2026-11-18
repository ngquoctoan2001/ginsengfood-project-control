/**
 * Ginsengfood · Bảng quản lý task M1–M9 (Google Apps Script gắn với Google Sheet).
 *
 * - setupTracker(): dựng / cập nhật cấu trúc mọi tab. Chạy lại bao nhiêu lần cũng không mất dữ liệu task.
 * - doPost(e): web app để AI agent cập nhật task qua tools/task-tracker/sheet-sync.mjs.
 * - leadReview: Lead ghi kết quả rà soát (cột "Lead duyệt", "Ghi chú Lead") qua tools/sheet_lead.mjs của Project Control,
 *   cần khoá riêng của Lead (chỉ mã băm nằm ở LEAD_KEY_SHA256); token chung của AI agent không ghi được hai cột này.
 *
 * Cài đặt và cập nhật: xem tools/task-tracker/README.md.
 */

const VERSION = '1.5.2';
const TZ = 'Asia/Ho_Chi_Minh';
// Tên Lead hiện trên Sheet ở mọi ô người (người phụ trách, người làm, Nhật ký, Báo cáo tuần) và ở tiêu đề cột đánh giá
// của tab "Báo cáo tuần" ("Đánh giá của <LEAD_NAME>", lead.87 14/11; tiêu đề cũ "Đánh giá của Lead" vẫn được nhận).
// Chữ "Lead" còn ở tiêu đề cột vai trò của tab task ("Lead duyệt", "Ghi chú Lead"); giá trị người "Lead" đổi bằng personName_.
const LEAD_NAME = 'Nguyễn Quốc Toàn';

const TAB_OVERVIEW = 'Tổng quan';
const TAB_PARALLEL = 'Luồng song song';
const TAB_WEEKLY = 'Báo cáo tuần';
const TAB_LOG = 'Nhật ký';
const TAB_GUIDE = 'Hướng dẫn';
const TAB_DROPDOWN = 'Mẫu thả xuống';

const HEADER_BG = '#1f4e3d';
const HEADER_FG = '#ffffff';
const AUTO_BG = '#f3f3f3';
const TASK_ROWS = 500;

// Mã task = <key>-<3 chữ số>, ví dụ M3-001. Tab M1-M2 dùng tiền tố M12.
// coOwners: người làm chung module; "Tổng quan" tách mỗi người một dòng theo cột "Người phụ trách".
const MODULES = [
  { key: 'M12', tab: 'M1-M2', name: 'M1–M2 · Nền tảng chung', owner: LEAD_NAME },
  { key: 'M3', tab: 'M3', name: 'M3 · Hệ thống bán hàng', owner: 'Trương Công Phúc',
    coOwners: [{ owner: 'Nguyễn Phát Tài', name: 'M3 · Vận chuyển, thanh toán' },
      { owner: LEAD_NAME, name: 'M3 · Kết nối đơn hàng với M8' }] },
  { key: 'M4', tab: 'M4', name: 'M4 · AI tư vấn', owner: 'Nguyễn Phát Tài' },
  { key: 'M5', tab: 'M5', name: 'M5', owner: 'Nguyễn Phát Tài' },
  { key: 'M6', tab: 'M6', name: 'M6', owner: 'Nguyễn Phát Tài' },
  { key: 'M7', tab: 'M7', name: 'M7', owner: LEAD_NAME },
  { key: 'M8', tab: 'M8', name: 'M8', owner: LEAD_NAME },
  { key: 'M9', tab: 'M9', name: 'M9', owner: 'Trương Công Phúc' }, // D-lead-052 16/11: M9 giao Phúc (thay lead.88)
];

const STATUS = {
  TODO: 'Chưa bắt đầu',
  IN_PROGRESS: 'Đang làm',
  REVIEW: 'Chờ review',
  BLOCKED: 'Bị chặn',
  DONE: 'Hoàn thành',
  CANCELLED: 'Hủy',
};
const PRIORITIES = ['P0', 'P1', 'P2', 'P3'];
const SOURCES = ['Kế hoạch', 'Phát sinh'];
const LEAD_REVIEW = ['Chưa duyệt', 'Đạt', 'Cần sửa'];
const READY = 'Sẵn sàng';
// SHA-256 của khoá Lead (khoá nằm ở máy Lead, ngoài mọi repo). Đổi khoá: chạy "node tools/sheet_lead.mjs tao-khoa"
// với tệp khoá mới rồi thay mã băm này và triển khai lại.
const LEAD_KEY_SHA256 = '3529416993b96cf48a6321b34a50b84e342afa5934d1236c87a9b27965c2c36c';
const LEAD_REVIEW_MAX = 50;

// Cột dùng trình đơn thả xuống, mỗi cột một ô mẫu trên tab TAB_DROPDOWN. Apps Script không đặt được màu chip:
// Lead tô màu từng giá trị ở ô mẫu, applyColumnRules_ chép quy tắc kèm màu sang các tab module.
// "Sẵn sàng chạy" chỉ liệt kê giá trị cố định; "Chờ: …", "Thiếu: …" giữ màu mặc định.
const DROPDOWNS = [
  { key: 'owner', values: [LEAD_NAME, 'Trương Công Phúc', 'Nguyễn Phát Tài', 'Chưa phân công'], allowInvalid: true },
  { key: 'ready', values: [READY, 'Đang chạy', 'Chờ review', 'Bị chặn', 'Đã xong', 'Đã hủy'], allowInvalid: true },
  { key: 'priority', values: PRIORITIES },
  { key: 'status', values: Object.keys(STATUS).map(function (k) { return STATUS[k]; }) },
  { key: 'source', values: SOURCES },
  { key: 'leadReview', values: LEAD_REVIEW },
];

// Bảng tính locale dùng dấu phẩy thập phân (vi_VN…) tách đối số công thức bằng ";".
// setupTracker dò thực tế rồi lưu vào Script Properties; mọi công thức đi qua fx_().
const PROP_ARG_SEP = 'FORMULA_ARG_SEP';
let argSep_ = null;

// auto: hệ thống tự ghi. leadOnly: chỉ Lead ghi, API từ chối.
const COLUMNS = [
  { key: 'id', header: 'Mã task', width: 90, text: true },
  { key: 'phase', header: 'Hạng mục', width: 140, text: true },
  { key: 'title', header: 'Tên task', width: 280, text: true, wrap: true },
  { key: 'outcome', header: 'Kết quả cần đạt', width: 280, text: true, wrap: true },
  { key: 'owner', header: 'Người phụ trách', width: 180, text: true },
  { key: 'lane', header: 'Luồng', width: 70, text: true },
  { key: 'deps', header: 'Phụ thuộc', width: 130, text: true },
  { key: 'ready', header: 'Sẵn sàng chạy', width: 160, text: true, auto: true },
  { key: 'priority', header: 'Ưu tiên', width: 90 },
  { key: 'status', header: 'Trạng thái', width: 140 },
  { key: 'progress', header: 'Tiến độ (%)', width: 90 },
  { key: 'estimateHours', header: 'Ước lượng (giờ)', width: 105 },
  { key: 'startDate', header: 'Bắt đầu', width: 95, date: true },
  { key: 'dueDate', header: 'Hạn chót', width: 95, date: true },
  { key: 'doneDate', header: 'Hoàn thành', width: 95, date: true },
  { key: 'branch', header: 'Nhánh / PR', width: 160, text: true },
  { key: 'commit', header: 'Commit', width: 90, text: true },
  { key: 'evidence', header: 'Bằng chứng / Kiểm thử', width: 240, text: true, wrap: true },
  { key: 'note', header: 'Ghi chú / Vướng mắc', width: 240, text: true, wrap: true },
  { key: 'source', header: 'Nguồn', width: 100 },
  { key: 'updatedAt', header: 'Cập nhật lúc', width: 130, auto: true },
  { key: 'updatedBy', header: 'Cập nhật bởi', width: 180, text: true, auto: true },
  { key: 'leadReview', header: 'Lead duyệt', width: 110, leadOnly: true },
  { key: 'leadNote', header: 'Ghi chú Lead', width: 220, text: true, wrap: true, leadOnly: true },
];

const LOG_HEADERS = ['Thời gian', 'Tuần', 'Module', 'Mã task', 'Hành động', 'Trạng thái cũ', 'Trạng thái mới', 'Người / Agent', 'Nhánh', 'Commit', 'Tóm tắt'];

// Tab "Báo cáo tuần": mỗi kỳ một dòng cho mỗi (module, người phụ trách). key = tên trường JSON của action weekly/weeklyList.
// Khoá dòng = (Từ ngày, Đến ngày, Module, Người phụ trách). Thứ tự ở đây là thứ tự cột trên tab.
const WEEKLY_FIELDS = [
  { key: 'week', header: 'Tuần', width: 70, max: 50 },
  { key: 'from', header: 'Từ ngày', width: 90, date: true, required: true },
  { key: 'to', header: 'Đến ngày', width: 90, date: true, required: true },
  { key: 'module', header: 'Module', width: 80, required: true },
  { key: 'owner', header: 'Người phụ trách', width: 150, required: true, max: 120 },
  { key: 'done', header: 'Đã hoàn thành', width: 260 },
  { key: 'doing', header: 'Đang làm', width: 260 },
  { key: 'blocked', header: 'Bị chặn / Rủi ro', width: 240 },
  { key: 'next', header: 'Kế hoạch tuần tới', width: 260 },
  { key: 'file', header: 'Báo cáo của dev (file .md)', width: 220 },
  { key: 'review', header: 'Đánh giá của ' + LEAD_NAME, aliases: ['Đánh giá của Lead'], width: 260 },
  { key: 'sent', header: 'Gửi sếp', width: 90 },
];
const WEEKLY_SENT = ['Chưa gửi', 'Đã gửi'];
const WEEKLY_MAX_ROWS = 20;
const WEEKLY_TEXT_MAX = 20000;

/* ───────────────────────────── Menu & cài đặt ───────────────────────────── */

function onOpen() {
  SpreadsheetApp.getUi()
    .createMenu('Task Tracker')
    .addItem('Khởi tạo / cập nhật cấu trúc', 'setupTracker')
    .addItem('Làm mới "Sẵn sàng chạy" và "Luồng song song"', 'refreshBoards')
    .addItem('Áp trình đơn thả xuống và màu cho mọi tab', 'applyDropdownStyle')
    .addItem('Đổi chữ Lead thành ' + LEAD_NAME, 'renameLeadData')
    .addSeparator()
    .addItem('Xem token đồng bộ cho AI agent', 'showToken')
    .addItem('Tạo token mới (vô hiệu token cũ)', 'rotateToken')
    .addToUi();
}

function setupTracker() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  ss.setSpreadsheetTimeZone(TZ);
  const props = PropertiesService.getScriptProperties();
  props.setProperty('SPREADSHEET_ID', ss.getId());
  argSep_ = detectArgSeparator_(ss);
  props.setProperty(PROP_ARG_SEP, argSep_);
  ensureToken_();

  // Tab mẫu thả xuống phải có trước tab module (chép quy tắc từ đó); tab module phải có trước
  // để công thức ở "Tổng quan" tham chiếu được.
  setupDropdownTab_(ss);
  MODULES.forEach(function (mod) { setupModuleTab_(ss, mod); });
  setupOverviewTab_(ss);
  getOrCreateSheet_(ss, TAB_PARALLEL);
  setupWeeklyTab_(ss);
  setupLogTab_(ss);
  setupGuideTab_(ss);
  // Dữ liệu ghi trước khi đổi tên: ô người "Lead" → LEAD_NAME. Chạy lại không đổi thêm ô nào.
  const renamed = renameLeadData_(ss);

  const order = [TAB_OVERVIEW, TAB_PARALLEL].concat(MODULES.map(function (m) { return m.tab; }), [TAB_WEEKLY, TAB_LOG, TAB_GUIDE, TAB_DROPDOWN]);
  order.forEach(function (name, i) {
    ss.setActiveSheet(ss.getSheetByName(name));
    ss.moveActiveSheet(i + 1);
  });
  removeDefaultSheet_(ss, order);

  refreshBoards_(ss);
  ss.setActiveSheet(ss.getSheetByName(TAB_OVERVIEW));
  notify_('Đã dựng xong bảng quản lý task (v' + VERSION + '). Bước tiếp theo: triển khai ứng dụng web theo tools/task-tracker/README.md.'
    + (renamed.total ? ' ' + renameLeadMessage_(renamed) : ''));
}

function refreshBoards() {
  refreshBoards_(SpreadsheetApp.getActiveSpreadsheet());
  notify_('Đã làm mới cột "Sẵn sàng chạy" và tab "Luồng song song".');
}

// Sau khi tô màu ở tab "Mẫu thả xuống": chép sang mọi tab module. Chỉ đổi định dạng, không đổi giá trị ô.
// Dựng lại "Hướng dẫn" cùng lúc vì tab đó mô tả màu.
function applyDropdownStyle() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  setupDropdownTab_(ss);
  MODULES.forEach(function (mod) {
    const sh = ss.getSheetByName(mod.tab);
    if (!sh) return;
    applyColumnRules_(sh);
    // Chip cần rộng hơn chữ thường; chỉ đặt lại cột thả xuống, giữ cột Lead đã kéo tay.
    DROPDOWNS.forEach(function (d) { sh.setColumnWidth(col_(d.key), colDef_(d.key).width); });
  });
  setupGuideTab_(ss);
  notify_('Đã chép trình đơn thả xuống và màu từ tab "' + TAB_DROPDOWN + '" sang mọi tab module.');
}

// Đổi dữ liệu cũ: ô người ghi "Lead" / "Lead (<agent>)" thành LEAD_NAME. setupTracker cũng tự chạy bước này.
// Dựng lại "Tổng quan" (bản cũ ghi "Lead" ở cột Phụ trách, công thức đếm theo cột đó) và "Luồng song song" sau khi đổi.
function renameLeadData() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const res = renameLeadData_(ss);
  setupOverviewTab_(ss);
  refreshBoards_(ss);
  notify_(renameLeadMessage_(res));
}

function showToken() {
  const token = ensureToken_();
  try {
    SpreadsheetApp.getUi().alert('Token đồng bộ cho AI agent',
      token + '\n\nDán vào "token" trong tools/task-tracker/sheet.json rồi commit lên dev.',
      SpreadsheetApp.getUi().ButtonSet.OK);
  } catch (err) {
    Logger.log('TRACKER_TOKEN: ' + token);
  }
}

function rotateToken() {
  PropertiesService.getScriptProperties().deleteProperty('TRACKER_TOKEN');
  showToken();
}

function ensureToken_() {
  const props = PropertiesService.getScriptProperties();
  let token = props.getProperty('TRACKER_TOKEN');
  if (!token) {
    token = Utilities.getUuid().replace(/-/g, '') + Utilities.getUuid().replace(/-/g, '');
    props.setProperty('TRACKER_TOKEN', token);
  }
  return token;
}

function notify_(message) {
  Logger.log(message);
  try { SpreadsheetApp.getActiveSpreadsheet().toast(message, 'Task Tracker', 10); } catch (err) { /* chạy ngoài giao diện */ }
}

/* ───────────────────────────── Dựng các tab ───────────────────────────── */

function setupModuleTab_(ss, mod) {
  const sh = getOrCreateSheet_(ss, mod.tab);
  const n = COLUMNS.length;
  if (sh.getMaxColumns() < n) sh.insertColumnsAfter(sh.getMaxColumns(), n - sh.getMaxColumns());
  if (sh.getMaxRows() < TASK_ROWS + 1) sh.insertRowsAfter(sh.getMaxRows(), TASK_ROWS + 1 - sh.getMaxRows());

  styleHeader_(sh.getRange(1, 1, 1, n).setValues([COLUMNS.map(function (c) { return c.header; })]));
  sh.setRowHeight(1, 36);
  sh.setFrozenRows(1);
  sh.setFrozenColumns(3);
  COLUMNS.forEach(function (c, i) { sh.setColumnWidth(i + 1, c.width); });
  applyColumnRules_(sh);
  if (!sh.getFilter()) sh.getRange(1, 1, sh.getMaxRows(), n).createFilter();
}

function applyColumnRules_(sh) {
  const rows = sh.getMaxRows() - 1;
  const body = function (key) { return sh.getRange(2, col_(key), rows, 1); };

  COLUMNS.forEach(function (c) {
    const r = body(c.key);
    if (c.text) r.setNumberFormat('@');
    if (c.date) r.setNumberFormat('dd/mm/yyyy');
    if (c.wrap) r.setWrap(true);
    if (c.auto) r.setBackground(dropdownOf_(c.key) ? null : AUTO_BG);
  });
  body('updatedAt').setNumberFormat('dd/mm/yyyy hh:mm');
  body('progress').setNumberFormat('0');
  body('estimateHours').setNumberFormat('0.#');

  applyDropdowns_(sh, rows);
  body('progress').setDataValidation(SpreadsheetApp.newDataValidation()
    .requireNumberBetween(0, 100).setAllowInvalid(false)
    .setHelpText('Nhập số từ 0 đến 100').build());

  // Màu trạng thái nằm ở chip thả xuống; định dạng có điều kiện chỉ còn tô hạn chót quá hạn.
  const L = function (key) { return colLetter_(col_(key)); };
  sh.setConditionalFormatRules([SpreadsheetApp.newConditionalFormatRule()
    .whenFormulaSatisfied(fx_('=AND($' + L('dueDate') + '2<>"",$' + L('dueDate') + '2<TODAY(),$' + L('status') + '2<>"' + STATUS.DONE + '",$' + L('status') + '2<>"' + STATUS.CANCELLED + '")'))
    .setBackground('#f4cccc').setBold(true).setRanges([body('dueDate')]).build()]);
}

// Mỗi cột thả xuống một dòng: cột A tên cột, ô cột B mang quy tắc. Chỉ đặt lại quy tắc khi danh sách giá trị
// đổi, vì đặt lại sẽ xóa màu Lead đã tô.
function setupDropdownTab_(ss) {
  const sh = getOrCreateSheet_(ss, TAB_DROPDOWN);
  styleHeader_(sh.getRange(1, 1, 1, 2).setValues([['Cột', 'Mẫu: tô màu từng giá trị ở Dữ liệu → Xác thực dữ liệu']]));
  sh.setFrozenRows(1);
  sh.setColumnWidth(1, 150);
  sh.setColumnWidth(2, 340);
  DROPDOWNS.forEach(function (d, i) {
    sh.getRange(i + 2, 1).setValue(colDef_(d.key).header);
    const cell = sh.getRange(i + 2, 2);
    const rule = cell.getDataValidation();
    const same = rule && String(rule.getCriteriaValues()[0]) === String(d.values)
      && rule.getAllowInvalid() === Boolean(d.allowInvalid);
    if (!same) cell.setDataValidation(listRule_(d.values, d.allowInvalid));
  });
  return sh;
}

// Chép quy tắc kèm màu chip từ ô mẫu xuống cả cột: copyTo giữ màu, setDataValidation thì không.
function applyDropdowns_(sh, rows) {
  const ss = sh.getParent();
  const tpl = ss.getSheetByName(TAB_DROPDOWN) || setupDropdownTab_(ss);
  DROPDOWNS.forEach(function (d, i) {
    tpl.getRange(i + 2, 2).copyTo(sh.getRange(2, col_(d.key), rows, 1), SpreadsheetApp.CopyPasteType.PASTE_DATA_VALIDATION, false);
  });
}

function setupOverviewTab_(ss) {
  const sh = getOrCreateSheet_(ss, TAB_OVERVIEW);
  const headers = ['Module', 'Tên module', 'Phụ trách', 'Tổng task', 'Hoàn thành', 'Đang làm', 'Chờ review', 'Bị chặn',
    'Chưa bắt đầu', 'Hủy', 'Sẵn sàng chạy', 'Quá hạn', '% hoàn thành', 'Cập nhật gần nhất'];
  const first = 5;
  const rows = overviewRows_();
  const total = first + rows.length;
  // Giữ tên module / người phụ trách nếu Lead đã sửa tay (theo thứ tự dòng trong từng module),
  // rồi xóa vùng cũ vì số dòng có thể đã đổi.
  const kept = {};
  const lastRow = sh.getLastRow();
  if (lastRow >= first) {
    sh.getRange(first, 1, lastRow - first + 1, 3).getValues().forEach(function (v) {
      const tab = String(v[0]);
      (kept[tab] = kept[tab] || []).push([v[1], v[2]]);
    });
    sh.getRange(first, 1, lastRow - first + 1, headers.length).clear();
  }

  sh.getRange('A1').setValue('Ginsengfood · Tổng quan task M1–M9').setFontSize(14).setFontWeight('bold');
  sh.getRange('A2').setFormula(fx_('="Tuần ISO "&ISOWEEKNUM(TODAY())&" · hôm nay "&TEXT(TODAY(),"dd/mm/yyyy")'));
  styleHeader_(sh.getRange(4, 1, 1, headers.length).setValues([headers]));

  const L = function (key) { return colLetter_(col_(key)); };
  const seen = {};
  rows.forEach(function (x, i) {
    const r = first + i;
    const m = x.mod;
    const q = "'" + m.tab + "'!";
    const ids = q + 'A2:A';
    const st = q + L('status') + '2:' + L('status');
    const ready = q + L('ready') + '2:' + L('ready');
    const due = q + L('dueDate') + '2:' + L('dueDate');
    const upd = q + L('updatedAt') + '2:' + L('updatedAt');
    const own = q + L('owner') + '2:' + L('owner');
    seen[m.tab] = (seen[m.tab] || 0) + 1;
    const k = kept[m.tab] && kept[m.tab][seen[m.tab] - 1];
    const name = k && k[0] ? k[0] : x.name;
    // Ô "Lead" do bản cũ dựng không phải sửa tay: đổi sang tên, ô sửa tay khác giữ nguyên.
    const owner = k && k[1] ? personName_(k[1]) : x.owner;
    // Dòng người chính đếm mọi task không ghi tên người làm chung; dòng người làm chung
    // chỉ đếm task ghi đúng tên ở cột C của dòng đó.
    let by = '';
    if (x.main) for (let d = 1; d <= x.coCount; d++) by += ',' + own + ',"<>"&$C' + (r + d);
    else by = ',' + own + ',$C' + r;
    sh.getRange(r, 1, 1, 3).setValues([[m.tab, name, owner]]);
    sh.getRange(r, 4, 1, 11).setFormulas([[
      '=COUNTIFS(' + ids + ',"?*"' + by + ')',
      '=COUNTIFS(' + st + ',"' + STATUS.DONE + '"' + by + ')',
      '=COUNTIFS(' + st + ',"' + STATUS.IN_PROGRESS + '"' + by + ')',
      '=COUNTIFS(' + st + ',"' + STATUS.REVIEW + '"' + by + ')',
      '=COUNTIFS(' + st + ',"' + STATUS.BLOCKED + '"' + by + ')',
      '=D' + r + '-E' + r + '-F' + r + '-G' + r + '-H' + r + '-J' + r,
      '=COUNTIFS(' + st + ',"' + STATUS.CANCELLED + '"' + by + ')',
      '=COUNTIFS(' + ready + ',"' + READY + '"' + by + ')',
      '=COUNTIFS(' + due + ',"<"&TODAY(),' + st + ',"<>' + STATUS.DONE + '",' + st + ',"<>' + STATUS.CANCELLED + '",' + ids + ',"?*"' + by + ')',
      '=IFERROR(E' + r + '/(D' + r + '-J' + r + '),0)',
      '=IF(COUNTIFS(' + upd + ',">0"' + by + ')=0,"",MAXIFS(' + upd + ',' + upd + ',">0"' + by + '))',
    ].map(fx_)]);
  });

  const last = total - 1;
  sh.getRange(total, 1, 1, 3).setValues([['Tổng cộng', '', '']]);
  const sums = ['D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'].map(function (c) { return '=SUM(' + c + first + ':' + c + last + ')'; });
  sums.push('=IFERROR(E' + total + '/(D' + total + '-J' + total + '),0)');
  sums.push('=IF(COUNT(N' + first + ':N' + last + ')=0,"",MAX(N' + first + ':N' + last + '))');
  sh.getRange(total, 4, 1, 11).setFormulas([sums.map(fx_)]);
  sh.getRange(total, 1, 1, headers.length).setFontWeight('bold').setBackground('#e8f0ec');

  sh.getRange(first, 13, rows.length + 1, 1).setNumberFormat('0%');
  sh.getRange(first, 14, rows.length + 1, 1).setNumberFormat('dd/mm/yyyy hh:mm');
  sh.setColumnWidth(1, 80);
  sh.setColumnWidth(2, 220);
  sh.setColumnWidth(3, 160);
  for (let c = 4; c <= 13; c++) sh.setColumnWidth(c, 95);
  sh.setColumnWidth(14, 140);
  sh.setFrozenRows(4);

  const area = function (c) { return sh.getRange(first, c, rows.length + 1, 1); };
  sh.setConditionalFormatRules([
    SpreadsheetApp.newConditionalFormatRule().whenNumberGreaterThan(0).setBackground('#f4cccc').setFontColor('#990000').setRanges([area(8), area(12)]).build(),
    SpreadsheetApp.newConditionalFormatRule().whenNumberGreaterThan(0).setBackground('#d9ead3').setFontColor('#274e13').setRanges([area(11)]).build(),
  ]);

  sh.getRange(total + 2, 1).setValue('Đỏ ở "Bị chặn" / "Quá hạn" là việc Lead cần gỡ ngay. "Sẵn sàng chạy" là số task giao được ngay cho một luồng agent mới — xem tab "Luồng song song".')
    .setFontColor('#666666').setFontStyle('italic');
}

// Mỗi module một dòng cho người chính, thêm một dòng ngay dưới cho mỗi người làm chung.
function overviewRows_() {
  const rows = [];
  MODULES.forEach(function (m) {
    const co = m.coOwners || [];
    rows.push({ mod: m, name: m.name, owner: m.owner, main: true, coCount: co.length });
    co.forEach(function (c) { rows.push({ mod: m, name: c.name || m.name, owner: c.owner, main: false }); });
  });
  return rows;
}

function setupWeeklyTab_(ss) {
  const sh = getOrCreateSheet_(ss, TAB_WEEKLY);
  const headers = WEEKLY_FIELDS.map(function (f) { return f.header; });
  styleHeader_(sh.getRange(1, 1, 1, headers.length).setValues([headers]));
  sh.setFrozenRows(1);
  WEEKLY_FIELDS.forEach(function (f, i) { sh.setColumnWidth(i + 1, f.width); });
  const rows = sh.getMaxRows() - 1;
  sh.getRange(2, 2, rows, 2).setNumberFormat('dd/mm/yyyy');
  sh.getRange(2, 6, rows, 6).setWrap(true);
  sh.getRange(2, 4, rows, 1).setDataValidation(listRule_(MODULES.map(function (m) { return m.tab; })));
  sh.getRange(2, 12, rows, 1).setDataValidation(listRule_(WEEKLY_SENT));
}

function setupLogTab_(ss) {
  const sh = getOrCreateSheet_(ss, TAB_LOG);
  styleHeader_(sh.getRange(1, 1, 1, LOG_HEADERS.length).setValues([LOG_HEADERS]));
  sh.setFrozenRows(1);
  [130, 80, 70, 90, 90, 110, 110, 180, 150, 90, 420].forEach(function (w, i) { sh.setColumnWidth(i + 1, w); });
  sh.getRange(2, 1, sh.getMaxRows() - 1, 1).setNumberFormat('dd/mm/yyyy hh:mm');
  sh.getRange(2, 2, sh.getMaxRows() - 1, LOG_HEADERS.length - 1).setNumberFormat('@');
}

function setupGuideTab_(ss) {
  const sh = getOrCreateSheet_(ss, TAB_GUIDE);
  const lines = [
    ['GINSENGFOOD · HƯỚNG DẪN BẢNG QUẢN LÝ TASK M1–M9'],
    [''],
    ['1. Mỗi module một tab: M1-M2 (Nguyễn Quốc Toàn), M3 (Trương Công Phúc; vận chuyển, thanh toán: Nguyễn Phát Tài; kết nối đơn hàng với M8: Nguyễn Quốc Toàn), M4, M5, M6 (Nguyễn Phát Tài), M7, M8 (Nguyễn Quốc Toàn), M9 (Trương Công Phúc). "Tổng quan" tính task theo cột "Người phụ trách", nên M3 có ba dòng Phúc, Tài và Toàn.'],
    ['2. Mã task: <module>-<3 chữ số>, ví dụ M3-001. Tab M1-M2 dùng tiền tố M12-, ví dụ M12-001.'],
    ['3. Trạng thái: Chưa bắt đầu → Đang làm → Chờ review → Hoàn thành. "Bị chặn" = đang vướng, ghi lý do và người cần gỡ ở cột "Ghi chú / Vướng mắc". "Hủy" = không làm nữa.'],
    ['4. Ưu tiên: P0 khẩn (đang chặn việc khác) · P1 cao · P2 trung bình · P3 thấp.'],
    [''],
    ['5. ÉP TIẾN ĐỘ BẰNG CHẠY SONG SONG'],
    ['   • "Luồng" (L1, L2, …): task cùng luồng chạy nối tiếp; task khác luồng chạy song song, mỗi luồng là một phiên AI agent / worktree riêng.'],
    ['   • "Phụ thuộc": mã các task phải xong trước, cách nhau bằng dấu phẩy. Được tham chiếu task ở module khác (ví dụ M12-003).'],
    ['   • "Sẵn sàng chạy" do hệ thống tự tính: "Sẵn sàng" = mọi phụ thuộc đã Hoàn thành/Hủy; "Chờ: …" = còn phụ thuộc chưa xong; "Thiếu: …" = mã phụ thuộc không tồn tại.'],
    ['   • Tab "Luồng song song" liệt kê theo từng người các task đang chạy và task sẵn sàng chạy ngay. Không để một prompt chạy rồi ngồi chờ: còn task "Sẵn sàng" ở luồng khác thì mở thêm phiên agent.'],
    ['   • Hai luồng chạy song song không được sửa cùng một nhóm file. Nếu đụng nhau thì xếp chung luồng hoặc thêm phụ thuộc.'],
    [''],
    ['6. Cột Sẵn sàng chạy, Cập nhật lúc, Cập nhật bởi do hệ thống ghi — không sửa tay.'],
    ['7. Cột "Lead duyệt" và "Ghi chú Lead" chỉ Lead ghi (tay hoặc lệnh rà soát có khoá Lead). Token chung của AI agent không ghi được hai cột này.'],
    ['8. AI agent cập nhật sheet sau mỗi prompt bằng lệnh: node tools/task-tracker/sheet-sync.mjs log … (xem tools/task-tracker/README.md). Dev chỉ vào kiểm tra lại.'],
    ['9. Nhật ký tuần của từng dev nằm trong repo: docs/weekly-tracking/truong-cong-phuc.md và docs/weekly-tracking/nguyen-phat-tai.md. Tab "Nhật ký" lưu mọi lần đổi trạng thái.'],
    ['10. Cuối tuần: dev viết "Tổng kết tuần" trong file .md của mình; Lead rà soát cùng lịch sử commit, điền tab "Báo cáo tuần" rồi gửi sếp.'],
    ['11. Màu chip thả xuống: cùng nghĩa cùng màu ở mọi cột — xanh lá xong/đạt, xanh dương đang làm, vàng chờ review/chưa duyệt, đỏ bị chặn/cần sửa, xanh lá đậm sẵn sàng, xám chưa bắt đầu/hủy. "Chờ: …", "Thiếu: …" giữ màu mặc định. Đổi màu: sửa ô mẫu ở tab "Mẫu thả xuống" (Dữ liệu → Xác thực dữ liệu) rồi chạy menu Task Tracker → "Áp trình đơn thả xuống và màu cho mọi tab".'],
  ];
  sh.clear();
  sh.getRange(1, 1, lines.length, 1).setValues(lines).setWrap(true).setVerticalAlignment('top');
  sh.setColumnWidth(1, 1000);
  sh.getRange('A1').setFontSize(14).setFontWeight('bold');
  sh.getRange('A8').setFontWeight('bold');
}

function removeDefaultSheet_(ss, keep) {
  ss.getSheets().forEach(function (sh) {
    const isDefault = /^(Sheet|Trang tính)\s?\d+$/.test(sh.getName());
    if (isDefault && keep.indexOf(sh.getName()) === -1 && sh.getLastRow() === 0) ss.deleteSheet(sh);
  });
}

/* ───────────────────────────── Web app cho AI agent ───────────────────────────── */

function doGet() {
  return ContentService.createTextOutput('Ginsengfood task tracker v' + VERSION + ' đang chạy. Dùng POST kèm token.');
}

function doPost(e) {
  let body;
  try {
    body = JSON.parse((e && e.postData && e.postData.contents) || '{}');
  } catch (err) {
    return json_({ ok: false, error: 'INVALID_JSON' });
  }
  const expected = PropertiesService.getScriptProperties().getProperty('TRACKER_TOKEN');
  if (!expected || body.token !== expected) return json_({ ok: false, error: 'UNAUTHORIZED' });

  const lock = LockService.getScriptLock();
  try {
    lock.waitLock(30000);
    const ss = getSs_();
    switch (body.action) {
      case 'ping':
        return json_({ ok: true, version: VERSION, spreadsheet: ss.getName(), url: ss.getUrl(),
          modules: MODULES.map(function (m) { return { key: m.key, tab: m.tab, owner: m.owner }; }) });
      case 'get': return json_(getTask_(ss, body));
      case 'list': return json_(listTasks_(ss, body));
      case 'upsert': return json_(upsertTask_(ss, body));
      case 'weekly': return json_(upsertWeekly_(ss, body));
      case 'weeklyList': return json_(listWeekly_(ss, body));
      case 'leadPing':
        return json_(leadKeyOk_(body.leadKey) ? { ok: true, version: VERSION } : { ok: false, error: 'LEAD_KEY_INVALID' });
      case 'leadReview': return json_(leadReview_(ss, body));
      default: return json_({ ok: false, error: 'UNKNOWN_ACTION: ' + body.action });
    }
  } catch (err) {
    return json_({ ok: false, error: String((err && err.message) || err) });
  } finally {
    lock.releaseLock();
  }
}

function getTask_(ss, body) {
  const id = normalizeId_(body.id);
  const t = readAllTasks_(ss).filter(function (x) { return x.id === id; })[0];
  return t ? { ok: true, task: taskToJson_(t, ss) } : { ok: false, error: 'TASK_NOT_FOUND: ' + id };
}

function listTasks_(ss, body) {
  const mod = body.module ? moduleForKey_(body.module) : null;
  if (body.module && !mod) return { ok: false, error: 'UNKNOWN_MODULE: ' + body.module };
  const status = body.status ? normalizeStatus_(body.status) : null;
  if (body.status && !status) return { ok: false, error: 'UNKNOWN_STATUS: ' + body.status };
  const owner = body.owner ? personName_(String(body.owner)).toLowerCase() : null;
  const tasks = readAllTasks_(ss).filter(function (t) {
    if (mod && t.mod.key !== mod.key) return false;
    if (status && t.status !== status) return false;
    if (owner && String(t.owner).toLowerCase().indexOf(owner) === -1) return false;
    if (body.ready && !(t.status === STATUS.TODO && t.ready === READY)) return false;
    return true;
  });
  return { ok: true, count: tasks.length, tasks: tasks.map(function (t) { return taskToJson_(t, ss); }) };
}

function upsertTask_(ss, body) {
  const fields = body.fields || {};
  const actor = personName_(String(body.actor || 'AI agent')).slice(0, 120);
  const rejected = Object.keys(fields).filter(function (k) {
    const c = colDef_(k);
    return !c || c.auto || c.leadOnly || k === 'id';
  });
  if (rejected.length) return { ok: false, error: 'FIELD_NOT_ALLOWED: ' + rejected.join(', ') };

  let id = normalizeId_(body.id);
  const mod = id ? moduleForId_(id) : moduleForKey_(body.module);
  if (!mod) return { ok: false, error: id ? 'UNKNOWN_MODULE_PREFIX: ' + id : 'MODULE_REQUIRED' };
  if (id && !/^[A-Z0-9]+-\d{3,}$/.test(id)) return { ok: false, error: 'INVALID_TASK_ID: ' + id };
  const sh = ss.getSheetByName(mod.tab);
  if (!sh) return { ok: false, error: 'TAB_MISSING: ' + mod.tab + ' (chạy setupTracker)' };

  let rowIndex = id ? findRow_(sh, id) : -1;
  const created = rowIndex < 0;
  if (created) {
    if (id && !body.create) return { ok: false, error: 'TASK_NOT_FOUND: ' + id + ' (thêm --create để tạo mới với mã này)' };
    if (!fields.title) return { ok: false, error: 'TITLE_REQUIRED_FOR_NEW_TASK' };
    if (!id) id = nextId_(sh, mod);
    rowIndex = firstEmptyRow_(sh);
  }

  const range = sh.getRange(rowIndex, 1, 1, COLUMNS.length);
  const row = range.getValues()[0];
  const oldStatus = created ? '' : (String(row[col_('status') - 1]).trim() || STATUS.TODO);
  if (created) {
    row[col_('id') - 1] = id;
    row[col_('status') - 1] = STATUS.TODO;
    row[col_('owner') - 1] = mod.owner;
    row[col_('source') - 1] = 'Phát sinh';
    row[col_('leadReview') - 1] = LEAD_REVIEW[0];
  }

  const errors = [];
  Object.keys(fields).forEach(function (k) {
    const v = convertField_(k, fields[k]);
    if (v && v.error) errors.push(v.error); else row[col_(k) - 1] = v.value;
  });
  if (errors.length) return { ok: false, error: errors.join('; ') };

  const today = Utilities.formatDate(new Date(), TZ, 'yyyy-MM-dd');
  const newStatus = String(row[col_('status') - 1]).trim() || STATUS.TODO;
  if (newStatus === STATUS.IN_PROGRESS && !row[col_('startDate') - 1]) row[col_('startDate') - 1] = today;
  if (newStatus === STATUS.DONE) {
    row[col_('progress') - 1] = 100;
    if (!row[col_('doneDate') - 1]) row[col_('doneDate') - 1] = today;
  }
  row[col_('updatedAt') - 1] = new Date();
  row[col_('updatedBy') - 1] = actor;
  range.setValues([row]);

  appendLog_(ss, {
    module: mod.tab, id: id, action: created ? 'Tạo mới' : 'Cập nhật', oldStatus: oldStatus, newStatus: newStatus,
    actor: actor, branch: row[col_('branch') - 1], commit: row[col_('commit') - 1],
    summary: body.summary || fields.note || '',
  });
  refreshBoards_(ss);
  return {
    ok: true, id: id, module: mod.key, tab: mod.tab, created: created, oldStatus: oldStatus, newStatus: newStatus,
    row: rowIndex, url: ss.getUrl() + '#gid=' + sh.getSheetId() + '&range=A' + rowIndex,
  };
}

function convertField_(key, raw) {
  const s = raw === null || raw === undefined ? '' : String(raw).trim();
  switch (key) {
    case 'status': {
      if (!s) return { error: 'status rỗng' };
      const v = normalizeStatus_(s);
      return v ? { value: v } : { error: 'Trạng thái không hợp lệ: ' + s };
    }
    case 'priority': {
      const v = s.toUpperCase();
      return !s || PRIORITIES.indexOf(v) !== -1 ? { value: v } : { error: 'Ưu tiên phải là P0–P3: ' + s };
    }
    case 'progress': {
      if (!s) return { value: '' };
      const n = Number(s.replace('%', ''));
      return isFinite(n) && n >= 0 && n <= 100 ? { value: Math.round(n) } : { error: 'Tiến độ phải từ 0 đến 100: ' + s };
    }
    case 'estimateHours': {
      if (!s) return { value: '' };
      const n = Number(s);
      return isFinite(n) && n >= 0 ? { value: n } : { error: 'Ước lượng giờ không hợp lệ: ' + s };
    }
    case 'startDate': case 'dueDate': case 'doneDate':
      return !s || /^\d{4}-\d{2}-\d{2}$/.test(s) ? { value: s } : { error: key + ' phải có dạng YYYY-MM-DD: ' + s };
    case 'source':
      return !s || SOURCES.indexOf(s) !== -1 ? { value: s } : { error: 'Nguồn phải là "Kế hoạch" hoặc "Phát sinh": ' + s };
    case 'deps':
      return { value: parseIds_(s).join(', ') };
    case 'owner':
      return { value: personName_(s).slice(0, 2000) };
    default:
      return { value: s.slice(0, 2000) };
  }
}

/* ───────────────────────────── Lead ghi kết quả rà soát ───────────────────────────── */

// Rà xong chỉ có hai kết quả: "Đạt" hoặc "Cần sửa" (thiếu bằng chứng cũng là Cần sửa). Mỗi mục: ghi "Lead duyệt", nối khối
// "[Rà soát Lead dd/mm/yyyy HH:mm | SHA …] <kết quả>. <note>" vào "Ghi chú Lead" (giữ ghi chú cũ, khối giống hệt thì không nối lại).
// Task của Lead đổi luôn "Trạng thái": Đạt → Hoàn thành, Cần sửa → Đang làm (hoặc status gửi kèm); "Sẵn sàng chạy" tự tính lại.
// Task người khác chỉ đổi hai cột Lead. Kiểm hết các mục trước khi ghi: sai một mục là không ghi mục nào.
function leadReview_(ss, body) {
  if (!leadKeyOk_(body.leadKey)) return { ok: false, error: 'LEAD_KEY_INVALID' };
  const input = body.items;
  if (!Array.isArray(input) || input.length < 1 || input.length > LEAD_REVIEW_MAX) {
    return { ok: false, error: 'LEAD_REVIEW_ITEMS: items phải là mảng 1–' + LEAD_REVIEW_MAX + ' mục' };
  }
  const tz = ss.getSpreadsheetTimeZone() || TZ;
  const tasks = readAllTasks_(ss);
  const errors = [];
  const seen = {};
  const plan = input.map(function (raw, i) {
    const x = raw || {};
    const id = normalizeId_(x.id);
    const where = 'Mục ' + (i + 1) + (id ? ' (' + id + ')' : '') + ': ';
    const verdict = String(x.verdict || '').trim();
    const note = String(x.note || '').replace(/\r\n/g, '\n').trim();
    const sha = String(x.sha || '').trim();
    const reviewedAt = String(x.reviewedAt || '').trim();
    const found = tasks.filter(function (t) { return t.id === id; });
    if (!id) errors.push(where + 'thiếu id');
    else if (seen[id]) errors.push(where + 'trùng id trong items');
    seen[id] = true;
    if (verdict !== LEAD_REVIEW[1] && verdict !== LEAD_REVIEW[2]) errors.push(where + 'verdict chỉ nhận "Đạt" hoặc "Cần sửa"');
    if (!note || note.length > 4000) errors.push(where + 'note bắt buộc, tối đa 4000 ký tự');
    if (!/^[0-9A-Za-z._\/-]{0,64}$/.test(sha)) errors.push(where + 'sha không hợp lệ');
    if (!/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}$/.test(reviewedAt)) errors.push(where + 'reviewedAt phải dạng yyyy-MM-dd HH:mm');
    if (found.length !== 1) {
      errors.push(where + (found.length ? 'mã xuất hiện ' + found.length + ' lần trên Sheet' : 'TASK_NOT_FOUND'));
      return null;
    }
    const t = found[0];
    const lead = isLeadOwner_(t.owner);
    const oldReview = String(t.row[col_('leadReview') - 1]).trim();
    const oldNote = String(t.row[col_('leadNote') - 1]);
    const updated = t.row[col_('updatedAt') - 1];
    if (oldReview === LEAD_REVIEW[1] && !x.force) errors.push(where + 'đã Đạt, không rà lại');
    if (isDate_(updated) && Utilities.formatDate(updated, tz, 'yyyy-MM-dd HH:mm') > reviewedAt) {
      errors.push(where + 'task cập nhật lúc ' + Utilities.formatDate(updated, tz, 'yyyy-MM-dd HH:mm') + ', sau giờ rà ' + reviewedAt + ': rà lại phần mới');
    }
    let status = t.status;
    if (lead) {
      if (verdict === LEAD_REVIEW[1]) status = STATUS.DONE;
      else {
        status = x.status ? normalizeStatus_(x.status) : STATUS.IN_PROGRESS;
        if ([STATUS.IN_PROGRESS, STATUS.BLOCKED, STATUS.TODO].indexOf(status) === -1) {
          errors.push(where + 'task Cần sửa chỉ về Đang làm, Bị chặn hoặc Chưa bắt đầu');
        }
      }
    } else if (x.status) {
      errors.push(where + 'task của ' + t.owner + ': không đổi Trạng thái, chỉ ghi Lead duyệt và Ghi chú Lead');
    }
    const head = '[Rà soát Lead ' + Utilities.formatDate(new Date(), tz, 'dd/MM/yyyy HH:mm') + (sha ? ' | SHA ' + sha : '');
    const tail = (sha ? ' | SHA ' + sha : '') + '] ' + verdict + '. ' + note;
    const appended = oldNote.indexOf(tail) === -1;
    const newNote = appended ? (oldNote.trim() ? oldNote + '\n\n' : '') + head + '] ' + verdict + '. ' + note : oldNote;
    if (newNote.length > 45000) errors.push(where + 'Ghi chú Lead vượt 45000 ký tự');
    return { t: t, id: id, lead: lead, verdict: verdict, note: note, sha: sha, status: status, newNote: newNote, appended: appended };
  });
  if (errors.length) return { ok: false, error: errors.join('; ') };

  const now = new Date();
  const today = Utilities.formatDate(now, TZ, 'yyyy-MM-dd');
  const actor = personName_(String(body.actor || LEAD_NAME + ' (rà soát)')).slice(0, 120);
  plan.forEach(function (p) {
    const sh = p.t.sheet;
    const r = p.t.rowIndex;
    sh.getRange(r, col_('leadReview'), 1, 2).setValues([[p.verdict, p.newNote]]);
    if (p.lead && p.status !== p.t.status) {
      sh.getRange(r, col_('status')).setValue(p.status);
      if (p.status === STATUS.DONE) {
        sh.getRange(r, col_('progress')).setValue(100);
        if (!p.t.row[col_('doneDate') - 1]) sh.getRange(r, col_('doneDate')).setValue(today);
      }
      if (p.status === STATUS.IN_PROGRESS && !p.t.row[col_('startDate') - 1]) sh.getRange(r, col_('startDate')).setValue(today);
      sh.getRange(r, col_('updatedAt'), 1, 2).setValues([[now, actor]]);
    }
    appendLog_(ss, {
      module: p.t.mod.tab, id: p.id, action: 'Lead duyệt: ' + p.verdict, oldStatus: p.t.status, newStatus: p.status,
      actor: actor, branch: '', commit: p.sha, summary: p.note,
    });
  });
  refreshBoards_(ss);
  return {
    ok: true, count: plan.length,
    results: plan.map(function (p) {
      return { id: p.id, ok: true, lead: p.lead, leadReview: p.verdict, oldStatus: p.t.status, status: p.status, noteAppended: p.appended, row: p.t.rowIndex };
    }),
  };
}

function leadKeyOk_(key) {
  if (typeof key !== 'string' || key.length < 32) return false;
  const hex = Utilities.computeDigest(Utilities.DigestAlgorithm.SHA_256, key, Utilities.Charset.UTF_8)
    .map(function (b) { return ('0' + (b & 0xff).toString(16)).slice(-2); }).join('');
  return hex === LEAD_KEY_SHA256;
}

// Chỉ task một mình Lead phụ trách mới tính là task của Lead (bỏ phần "(agent)" ở cuối); ô nhiều người tính là task người khác.
function isLeadOwner_(owner) {
  return String(personName_(String(owner || ''))).normalize('NFC').replace(/\s+/g, ' ').trim().replace(/\s*\(.*\)$/, '') === LEAD_NAME;
}

/* ───────────────────────────── Báo cáo tuần ───────────────────────────── */

// Ghi 1–WEEKLY_MAX_ROWS dòng vào tab "Báo cáo tuần". Đã có dòng cùng khoá thì chỉ ghi các trường được gửi, cột khác
// giữ nguyên (kể cả cột đánh giá, "Gửi sếp" Lead điền tay); chưa có thì thêm vào cuối tab.
// Kiểm hết đầu vào trước khi ghi: sai một dòng là không ghi dòng nào.
function upsertWeekly_(ss, body) {
  const input = body.rows;
  if (!Array.isArray(input) || input.length < 1 || input.length > WEEKLY_MAX_ROWS) {
    return { ok: false, error: 'WEEKLY_ROWS: rows phải là mảng 1–' + WEEKLY_MAX_ROWS + ' dòng' };
  }
  const sh = ss.getSheetByName(TAB_WEEKLY);
  if (!sh) return { ok: false, error: 'TAB_MISSING: ' + TAB_WEEKLY + ' (chạy setupTracker)' };
  const headerError = checkWeeklyHeader_(sh);
  if (headerError) return { ok: false, error: headerError };

  const errors = [];
  const seen = {};
  const items = input.map(function (raw, i) {
    const x = parseWeeklyRow_(raw);
    if (x.error) errors.push('Dòng ' + (i + 1) + ': ' + x.error);
    else if (seen[x.key]) errors.push('Dòng ' + (i + 1) + ': trùng khoá (Từ ngày, Đến ngày, Module, Người phụ trách) với dòng ' + seen[x.key]);
    else seen[x.key] = i + 1;
    return x;
  });
  if (errors.length) return { ok: false, error: errors.join('; ') };

  const tz = ss.getSpreadsheetTimeZone() || TZ;
  const existing = {};
  readWeeklyRows_(sh, tz).forEach(function (r) { if (r.key && !existing[r.key]) existing[r.key] = r.row; });
  let next = Math.max(sh.getLastRow(), 1) + 1;
  const plan = items.map(function (x) {
    return existing[x.key] ? { x: x, row: existing[x.key], created: false } : { x: x, row: next++, created: true };
  });
  if (next - 1 > sh.getMaxRows()) sh.insertRowsAfter(sh.getMaxRows(), next - 1 - sh.getMaxRows());

  const actor = personName_(String(body.actor || 'AI agent')).slice(0, 120);
  plan.forEach(function (p) {
    const values = {};
    Object.keys(p.x.values).forEach(function (k) { values[k] = p.x.values[k]; });
    if (p.created) {
      if (!has_(values, 'week')) values.week = isoWeek_(Utilities.parseDate(p.x.from, TZ, 'yyyy-MM-dd'));
      if (!has_(values, 'sent')) values.sent = WEEKLY_SENT[0];
    }
    values.from = Utilities.parseDate(p.x.from, tz, 'yyyy-MM-dd');
    values.to = Utilities.parseDate(p.x.to, tz, 'yyyy-MM-dd');
    writeWeeklyCells_(sh, p.row, values);
    appendLog_(ss, {
      module: p.x.mod.tab, id: '', action: p.created ? 'Báo cáo tuần: tạo mới' : 'Báo cáo tuần: cập nhật',
      oldStatus: '', newStatus: '', actor: actor, branch: '', commit: '',
      summary: 'Dòng ' + p.row + ' · ' + dmy_(p.x.from) + '–' + dmy_(p.x.to) + ' · ' + p.x.owner + ' · ' + p.x.fields.join(', '),
    });
  });

  const created = plan.filter(function (p) { return p.created; }).length;
  return {
    ok: true, tab: TAB_WEEKLY, created: created, updated: plan.length - created,
    rows: plan.map(function (p) {
      return { row: p.row, created: p.created, from: p.x.from, to: p.x.to, module: p.x.mod.tab, owner: p.x.owner, fields: p.x.fields };
    }),
    url: ss.getUrl() + '#gid=' + sh.getSheetId(),
  };
}

// Đọc tab "Báo cáo tuần", lọc theo kỳ: dòng có Từ ngày >= from và Đến ngày <= to (bỏ trống = không lọc), thêm module nếu có.
function listWeekly_(ss, body) {
  const from = body.from ? parseDay_(body.from) : null;
  if (body.from && !from) return { ok: false, error: 'from phải có dạng YYYY-MM-DD hoặc dd/mm/yyyy: ' + body.from };
  const to = body.to ? parseDay_(body.to) : null;
  if (body.to && !to) return { ok: false, error: 'to phải có dạng YYYY-MM-DD hoặc dd/mm/yyyy: ' + body.to };
  const mod = body.module ? moduleForKey_(body.module) : null;
  if (body.module && !mod) return { ok: false, error: 'UNKNOWN_MODULE: ' + body.module };
  const sh = ss.getSheetByName(TAB_WEEKLY);
  if (!sh) return { ok: false, error: 'TAB_MISSING: ' + TAB_WEEKLY + ' (chạy setupTracker)' };
  const headerError = checkWeeklyHeader_(sh);
  if (headerError) return { ok: false, error: headerError };

  const tz = ss.getSpreadsheetTimeZone() || TZ;
  const rows = readWeeklyRows_(sh, tz).filter(function (r) {
    if (from && !(r.from && r.from >= from)) return false;
    if (to && !(r.to && r.to <= to)) return false;
    if (mod && r.tab !== mod.tab) return false;
    return true;
  }).map(function (r) {
    const out = { row: r.row };
    WEEKLY_FIELDS.forEach(function (f, i) {
      const v = r.values[i];
      if (f.date && r[f.key]) out[f.key] = r[f.key];
      else if (isDate_(v)) out[f.key] = Utilities.formatDate(v, tz, 'yyyy-MM-dd');
      else out[f.key] = v === '' ? null : v;
    });
    return out;
  });
  return { ok: true, tab: TAB_WEEKLY, count: rows.length, rows: rows };
}

// Kiểm một dòng đầu vào. Trả { key, from, to, mod, owner, values, fields } hoặc { error }.
// Trường vắng mặt hoặc null = không gửi (giữ nguyên ô); chuỗi rỗng = xoá ô.
function parseWeeklyRow_(raw) {
  if (!raw || typeof raw !== 'object' || Array.isArray(raw)) return { error: 'mỗi dòng phải là một đối tượng JSON' };
  const unknown = Object.keys(raw).filter(function (k) { return !weeklyField_(k); });
  if (unknown.length) {
    return { error: 'trường không hợp lệ: ' + unknown.join(', ') + ' (chỉ nhận ' + WEEKLY_FIELDS.map(function (f) { return f.key; }).join(', ') + ')' };
  }
  const values = {};
  const errors = [];
  WEEKLY_FIELDS.forEach(function (f) {
    const v = raw[f.key];
    if (v === undefined || v === null) return;
    if (typeof v !== 'string' && typeof v !== 'number') { errors.push(f.key + ' phải là chuỗi'); return; }
    const s = String(v).normalize('NFC').trim();
    const max = f.max || WEEKLY_TEXT_MAX;
    if (s.length > max) { errors.push(f.key + ' dài quá ' + max + ' ký tự'); return; }
    values[f.key] = s;
  });
  if (errors.length) return { error: errors.join('; ') };
  WEEKLY_FIELDS.forEach(function (f) { if (f.required && !values[f.key]) errors.push('thiếu ' + f.key); });

  const from = values.from ? parseDay_(values.from) : null;
  if (values.from && !from) errors.push('from phải có dạng YYYY-MM-DD hoặc dd/mm/yyyy: ' + values.from);
  const to = values.to ? parseDay_(values.to) : null;
  if (values.to && !to) errors.push('to phải có dạng YYYY-MM-DD hoặc dd/mm/yyyy: ' + values.to);
  if (from && to && from > to) errors.push('from (' + from + ') sau to (' + to + ')');
  const mod = values.module ? moduleForKey_(values.module) : null;
  if (values.module && !mod) {
    errors.push('module không thuộc danh sách tab (' + MODULES.map(function (m) { return m.tab; }).join(', ') + '; nhận cả M12): ' + values.module);
  }
  // Khoá so theo tên đã quy đổi: gửi "Lead" hay "Nguyễn Quốc Toàn" đều trúng cùng một dòng.
  if (values.owner) values.owner = personName_(values.owner.replace(/\s+/g, ' '));
  if (has_(values, 'sent')) {
    const hit = WEEKLY_SENT.filter(function (x) { return x.toLowerCase() === values.sent.toLowerCase(); })[0];
    if (hit) values.sent = hit;
    else errors.push('sent (Gửi sếp) chỉ nhận "' + WEEKLY_SENT.join('" hoặc "') + '": ' + values.sent);
  }
  if (errors.length) return { error: errors.join('; ') };

  values.from = from;
  values.to = to;
  values.module = mod.tab;
  return { key: weeklyKey_(from, to, mod.tab, values.owner), from: from, to: to, mod: mod, owner: values.owner,
    values: values, fields: Object.keys(values) };
}

// Mọi dòng có dữ liệu của tab, kèm ngày đã chuẩn hoá (yyyy-MM-dd) và khoá; ô ngày là Date hoặc chuỗi đều được.
function readWeeklyRows_(sh, tz) {
  const last = sh.getLastRow();
  if (last < 2) return [];
  const out = [];
  sh.getRange(2, 1, last - 1, WEEKLY_FIELDS.length).getValues().forEach(function (v, i) {
    if (v.every(function (c) { return String(c).trim() === ''; })) return;
    const from = weeklyDay_(v[1], tz);
    const to = weeklyDay_(v[2], tz);
    const mod = moduleForKey_(v[3]);
    const tab = mod ? mod.tab : String(v[3]).trim();
    const owner = personName_(String(v[4]).trim()); // dòng cũ ghi "Lead" chưa đổi vẫn khớp khoá
    out.push({ row: i + 2, values: v, from: from, to: to, tab: tab,
      key: from && to && tab && owner ? weeklyKey_(from, to, tab, owner) : '' });
  });
  return out;
}

// Ghi các trường có trong values; cột liền nhau gộp một lần ghi. Ô ngày định dạng dd/mm/yyyy, ô khác định dạng
// văn bản để chuỗi bắt đầu bằng "=", "+", "-" hay số tuần không bị Sheet đổi kiểu.
function writeWeeklyCells_(sh, row, values) {
  const cols = [];
  WEEKLY_FIELDS.forEach(function (f, i) { if (has_(values, f.key)) cols.push(i); });
  let s = 0;
  while (s < cols.length) {
    let e = s;
    while (e + 1 < cols.length && cols[e + 1] === cols[e] + 1) e++;
    const fields = WEEKLY_FIELDS.slice(cols[s], cols[e] + 1);
    const range = sh.getRange(row, cols[s] + 1, 1, fields.length);
    range.setNumberFormats([fields.map(function (f) { return f.date ? 'dd/mm/yyyy' : '@'; })]);
    range.setValues([fields.map(function (f) { return values[f.key]; })]);
    s = e + 1;
  }
}

function checkWeeklyHeader_(sh) {
  const n = WEEKLY_FIELDS.length;
  const got = sh.getMaxColumns() >= n ? sh.getRange(1, 1, 1, n).getValues()[0] : [];
  for (let i = 0; i < n; i++) {
    const h = String(got[i] === undefined ? '' : got[i]).normalize('NFC').trim();
    const ok = [WEEKLY_FIELDS[i].header].concat(WEEKLY_FIELDS[i].aliases || [])
      .map(function (a) { return a.normalize('NFC'); });
    if (ok.indexOf(h) < 0) {
      return 'WEEKLY_HEADER_MISMATCH: cột ' + colLetter_(i + 1) + ' của tab "' + TAB_WEEKLY + '" là "' + h + '", cần "'
        + WEEKLY_FIELDS[i].header + '". Trả cột về đúng chỗ rồi chạy Task Tracker → Khởi tạo / cập nhật cấu trúc.';
    }
  }
  return null;
}

function weeklyField_(key) {
  return WEEKLY_FIELDS.filter(function (f) { return f.key === key; })[0] || null;
}

function weeklyKey_(from, to, tab, owner) {
  return [from, to, tab, String(owner).normalize('NFC').replace(/\s+/g, ' ').trim().toLowerCase()].join('|');
}

function weeklyDay_(v, tz) {
  if (isDate_(v)) return isNaN(v.getTime()) ? '' : Utilities.formatDate(v, tz, 'yyyy-MM-dd');
  return parseDay_(v) || '';
}

// "yyyy-mm-dd" hoặc "dd/mm/yyyy" (ngày/tháng 1–2 chữ số, có thể kèm giờ phía sau) → "yyyy-MM-dd"; ngày không có thật → null.
function parseDay_(raw) {
  const t = String(raw === null || raw === undefined ? '' : raw).trim().replace(/\s+\d{1,2}:\d{2}(:\d{2})?$/, '');
  let m = /^(\d{4})-(\d{1,2})-(\d{1,2})$/.exec(t);
  let y, mo, d;
  if (m) { y = Number(m[1]); mo = Number(m[2]); d = Number(m[3]); }
  else if ((m = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/.exec(t))) { y = Number(m[3]); mo = Number(m[2]); d = Number(m[1]); }
  else return null;
  const dt = new Date(Date.UTC(y, mo - 1, d));
  if (dt.getUTCFullYear() !== y || dt.getUTCMonth() !== mo - 1 || dt.getUTCDate() !== d) return null;
  return y + '-' + String(mo).padStart(2, '0') + '-' + String(d).padStart(2, '0');
}

function dmy_(ymd) {
  return ymd.split('-').reverse().join('/');
}

// Không dùng instanceof để đúng cả khi Date đến từ ngữ cảnh JS khác (bộ test nạp Code.gs bằng node:vm).
function isDate_(v) {
  return Object.prototype.toString.call(v) === '[object Date]';
}

function has_(obj, key) {
  return Object.prototype.hasOwnProperty.call(obj, key);
}

/* ───────────────────────────── Tên Lead ───────────────────────────── */

// "Lead" / "Lead (<agent>)" (không phân biệt hoa thường, khoảng trắng thừa) → LEAD_NAME / "LEAD_NAME (<agent>)".
// Giá trị khác trả nguyên vẹn. Repo chưa chạy lại install.mjs còn team.json cũ nên agent vẫn gửi "Lead" làm tên người.
function personName_(v) {
  if (typeof v !== 'string') return v;
  const m = /^lead\s*(\(.*\))?$/i.exec(v.normalize('NFC').replace(/\s+/g, ' ').trim());
  return m ? LEAD_NAME + (m[1] ? ' ' + m[1] : '') : v;
}

// Cột người của từng tab, tìm theo tiêu đề dòng 1 (không theo số cột). Cột chữ, ghi chú và tiêu đề không nằm trong danh sách.
function leadRenameTargets_() {
  const task = [colDef_('owner').header, colDef_('updatedBy').header];
  return MODULES.map(function (m) { return { tab: m.tab, headers: task }; }).concat([
    { tab: TAB_WEEKLY, headers: [weeklyField_('owner').header] },
    { tab: TAB_LOG, headers: [LOG_HEADERS[7]] },
  ]);
}

// Đổi ô người "Lead" / "Lead (…)" thành LEAD_NAME ở các tab trong leadRenameTargets_. Chạy lại bao nhiêu lần cũng được:
// lần sau đổi 0 ô. Giữ khoá script để không chen với doPost đang ghi. Trả { total, byTab: { <tab>: <số ô đã đổi> } }.
function renameLeadData_(ss) {
  const lock = LockService.getScriptLock();
  lock.waitLock(30000);
  try {
    const byTab = {};
    let total = 0;
    leadRenameTargets_().forEach(function (t) {
      const sh = ss.getSheetByName(t.tab);
      if (!sh) return;
      const n = renameLeadInSheet_(sh, t.headers);
      if (n) { byTab[t.tab] = n; total += n; }
    });
    return { total: total, byTab: byTab };
  } finally {
    lock.releaseLock();
  }
}

// Chỉ ghi các đoạn ô liền nhau cần đổi; ô khác trong cột (kể cả công thức) không bị ghi lại.
function renameLeadInSheet_(sh, headers) {
  const lastRow = sh.getLastRow();
  const lastCol = sh.getLastColumn();
  if (lastRow < 2 || lastCol < 1) return 0;
  const head = sh.getRange(1, 1, 1, lastCol).getValues()[0].map(function (h) { return String(h).normalize('NFC').trim(); });
  let count = 0;
  headers.forEach(function (h) {
    const c = head.indexOf(h) + 1;
    if (!c) return;
    const values = sh.getRange(2, c, lastRow - 1, 1).getValues();
    let r = 0;
    while (r < values.length) {
      const run = [];
      while (r + run.length < values.length) {
        const v = values[r + run.length][0];
        const name = personName_(v);
        if (name === v) break;
        run.push([name]);
      }
      if (!run.length) { r++; continue; }
      sh.getRange(r + 2, c, run.length, 1).setValues(run);
      count += run.length;
      r += run.length;
    }
  });
  return count;
}

function renameLeadMessage_(res) {
  if (!res.total) return 'Không còn ô nào ghi "Lead" ở cột người: không đổi gì.';
  return 'Đã đổi "Lead" thành "' + LEAD_NAME + '" ở ' + res.total + ' ô: '
    + Object.keys(res.byTab).map(function (t) { return t + ' ' + res.byTab[t]; }).join(', ') + '.';
}

/* ───────────────────────────── Bảng tự tính ───────────────────────────── */

function refreshBoards_(ss) {
  const tasks = readAllTasks_(ss);
  const statusById = {};
  tasks.forEach(function (t) { statusById[t.id] = t.status; });

  const perSheet = {};
  tasks.forEach(function (t) {
    t.ready = computeReady_(t.status, t.deps, statusById);
    const key = t.mod.tab;
    if (!perSheet[key]) perSheet[key] = { sheet: t.sheet, rows: {} };
    perSheet[key].rows[t.rowIndex] = t.ready;
  });
  MODULES.forEach(function (mod) {
    const sh = ss.getSheetByName(mod.tab);
    if (!sh) return;
    const last = sh.getLastRow();
    if (last < 2) return;
    const rows = (perSheet[mod.tab] && perSheet[mod.tab].rows) || {};
    const values = [];
    for (let r = 2; r <= last; r++) values.push([rows[r] || '']);
    sh.getRange(2, col_('ready'), values.length, 1).setValues(values);
  });
  writeParallelBoard_(ss, tasks);
}

function computeReady_(status, depsRaw, statusById) {
  if (status === STATUS.DONE) return 'Đã xong';
  if (status === STATUS.CANCELLED) return 'Đã hủy';
  if (status === STATUS.IN_PROGRESS) return 'Đang chạy';
  if (status === STATUS.REVIEW) return 'Chờ review';
  if (status === STATUS.BLOCKED) return 'Bị chặn';
  const deps = parseIds_(depsRaw);
  const missing = deps.filter(function (d) { return !(d in statusById); });
  if (missing.length) return 'Thiếu: ' + missing.join(', ');
  const pending = deps.filter(function (d) { return statusById[d] !== STATUS.DONE && statusById[d] !== STATUS.CANCELLED; });
  return pending.length ? 'Chờ: ' + pending.join(', ') : READY;
}

function writeParallelBoard_(ss, tasks) {
  const sh = getOrCreateSheet_(ss, TAB_PARALLEL);
  sh.clear();
  const active = tasks.filter(function (t) {
    return t.status === STATUS.IN_PROGRESS || (t.status === STATUS.TODO && t.ready === READY);
  });
  const rank = function (p) { const i = PRIORITIES.indexOf(p); return i === -1 ? 9 : i; };
  active.sort(function (a, b) {
    return String(a.owner).localeCompare(String(b.owner))
      || (a.status === STATUS.IN_PROGRESS ? 0 : 1) - (b.status === STATUS.IN_PROGRESS ? 0 : 1)
      || rank(a.priority) - rank(b.priority)
      || dateKey_(a.dueDate) - dateKey_(b.dueDate)
      || a.id.localeCompare(b.id);
  });

  const now = Utilities.formatDate(new Date(), TZ, 'dd/MM/yyyy HH:mm');
  sh.getRange('A1').setValue('Luồng song song · task đang chạy và task sẵn sàng chạy ngay').setFontSize(14).setFontWeight('bold');
  sh.getRange('A2').setValue('Mỗi task "Sẵn sàng" ở một luồng khác có thể giao ngay cho một phiên AI agent / worktree riêng. Cập nhật lúc ' + now + '.')
    .setFontColor('#666666').setFontStyle('italic');

  const owners = {};
  active.forEach(function (t) {
    const o = t.owner || '(chưa giao)';
    if (!owners[o]) owners[o] = { running: 0, ready: 0, lanes: {}, p0: 0 };
    if (t.status === STATUS.IN_PROGRESS) { owners[o].running++; owners[o].lanes[t.lane || '?'] = true; } else owners[o].ready++;
    if (t.priority === 'P0') owners[o].p0++;
  });
  const summary = Object.keys(owners).sort().map(function (o) {
    return [o, owners[o].running, Object.keys(owners[o].lanes).length, owners[o].ready, owners[o].p0];
  });
  styleHeader_(sh.getRange(4, 1, 1, 5).setValues([['Người phụ trách', 'Task đang chạy', 'Số luồng đang chạy', 'Task sẵn sàng chạy', 'Trong đó P0']]));
  let r = 5;
  if (summary.length) {
    sh.getRange(r, 1, summary.length, 5).setValues(summary);
    r += summary.length;
  } else {
    sh.getRange(r, 1).setValue('Chưa có task nào đang chạy hoặc sẵn sàng chạy.');
    r += 1;
  }

  r += 1;
  const headers = ['Người phụ trách', 'Mã task', 'Module', 'Tên task', 'Luồng', 'Ưu tiên', 'Trạng thái', 'Hạn chót', 'Nhánh / PR'];
  styleHeader_(sh.getRange(r, 1, 1, headers.length).setValues([headers]));
  if (active.length) {
    const rows = active.map(function (t) {
      return [t.owner, t.id, t.mod.tab, t.title, t.lane, t.priority, t.status === STATUS.IN_PROGRESS ? 'Đang chạy' : READY, t.dueDate || '', t.branch];
    });
    sh.getRange(r + 1, 1, rows.length, headers.length).setValues(rows);
    sh.getRange(r + 1, 8, rows.length, 1).setNumberFormat('dd/mm/yyyy');
    sh.getRange(r + 1, 4, rows.length, 1).setWrap(true);
  }
  [160, 90, 70, 360, 70, 70, 110, 95, 160].forEach(function (w, i) { sh.setColumnWidth(i + 1, w); });
}

/* ───────────────────────────── Sửa tay trên sheet ───────────────────────────── */

function onEdit(e) {
  try {
    const sh = e.range.getSheet();
    const mod = MODULES.filter(function (m) { return m.tab === sh.getName(); })[0];
    if (!mod || e.range.getRow() < 2) return;
    const c1 = e.range.getColumn();
    const c2 = e.range.getLastColumn();
    const statusCol = col_('status');
    if (c1 <= statusCol && statusCol <= c2 && e.range.getNumRows() === 1 && e.range.getNumColumns() === 1) {
      const id = String(sh.getRange(e.range.getRow(), 1).getValue()).trim();
      if (id) {
        sh.getRange(e.range.getRow(), col_('updatedAt'), 1, 2).setValues([[new Date(), 'Sửa tay trên Sheet']]);
        appendLog_(e.source, { module: mod.tab, id: id, action: 'Sửa tay', oldStatus: e.oldValue || '', newStatus: e.value || '',
          actor: 'Sửa tay trên Sheet', branch: '', commit: '', summary: '' });
      }
    }
    const watched = ['id', 'deps', 'status', 'lane', 'priority', 'dueDate', 'owner', 'title'].map(col_);
    if (watched.some(function (c) { return c >= c1 && c <= c2; })) refreshBoards_(e.source);
  } catch (err) {
    console.warn(err);
  }
}

/* ───────────────────────────── Tiện ích ───────────────────────────── */

// Thử =SUM(1,2) rồi =SUM(1;2) trên một tab tạm; dấu nào cho ra 3 là dấu tách đối số của bảng tính này.
// (Ở vi_VN, "1,2" bị hiểu là số thập phân 1,2 nên phép thử bằng 3 vẫn phân biệt được.)
function detectArgSeparator_(ss) {
  const probe = ss.insertSheet('__do_cong_thuc_' + new Date().getTime());
  try {
    const cell = probe.getRange('A1');
    const seps = [',', ';'];
    for (let i = 0; i < seps.length; i++) {
      try {
        cell.setFormula('=SUM(1' + seps[i] + '2)');
        SpreadsheetApp.flush();
        if (cell.getValue() === 3) return seps[i];
      } catch (err) { /* thử dấu tiếp theo */ }
    }
    throw new Error('Không xác định được dấu tách đối số công thức của bảng tính này');
  } finally {
    ss.deleteSheet(probe);
  }
}

// Công thức trong code luôn viết bằng dấu phẩy; đổi sang dấu của bảng tính, giữ nguyên phần trong "…".
function fx_(formula) {
  if (argSep_ === null) argSep_ = PropertiesService.getScriptProperties().getProperty(PROP_ARG_SEP) || ',';
  if (argSep_ === ',') return formula;
  return formula.split('"').map(function (part, i) { return i % 2 ? part : part.replace(/,/g, argSep_); }).join('"');
}

function getSs_() {
  const active = SpreadsheetApp.getActiveSpreadsheet();
  if (active) return active;
  const id = PropertiesService.getScriptProperties().getProperty('SPREADSHEET_ID');
  if (!id) throw new Error('Chưa chạy setupTracker');
  return SpreadsheetApp.openById(id);
}

function readAllTasks_(ss) {
  const all = [];
  MODULES.forEach(function (mod) {
    const sh = ss.getSheetByName(mod.tab);
    if (!sh) return;
    const last = sh.getLastRow();
    if (last < 2) return;
    sh.getRange(2, 1, last - 1, COLUMNS.length).getValues().forEach(function (row, i) {
      const id = normalizeId_(row[0]);
      if (!id) return;
      const get = function (key) { return row[col_(key) - 1]; };
      all.push({
        mod: mod, sheet: sh, rowIndex: i + 2, row: row, id: id,
        status: normalizeStatus_(get('status')) || STATUS.TODO,
        deps: String(get('deps')), owner: personName_(String(get('owner') || mod.owner)), lane: String(get('lane')),
        priority: String(get('priority')).toUpperCase(), title: String(get('title')), branch: String(get('branch')),
        dueDate: get('dueDate'), ready: String(get('ready')),
      });
    });
  });
  return all;
}

function taskToJson_(t, ss) {
  const out = { module: t.mod.key, tab: t.mod.tab, row: t.rowIndex };
  const tz = ss.getSpreadsheetTimeZone() || TZ;
  COLUMNS.forEach(function (c, i) {
    const v = t.row[i];
    if (v instanceof Date) out[c.key] = Utilities.formatDate(v, tz, c.key === 'updatedAt' ? 'yyyy-MM-dd HH:mm' : 'yyyy-MM-dd');
    else out[c.key] = v === '' ? null : v;
  });
  out.id = t.id;
  out.status = t.status;
  out.statusCode = statusCode_(t.status);
  out.ready = t.ready;
  return out;
}

function appendLog_(ss, x) {
  const sh = ss.getSheetByName(TAB_LOG);
  if (!sh) return;
  const now = new Date();
  sh.appendRow([now, isoWeek_(now), x.module, x.id, x.action, x.oldStatus, x.newStatus, x.actor, String(x.branch || ''),
    String(x.commit || ''), String(x.summary || '').slice(0, 1000)]);
}

function nextId_(sh, mod) {
  const last = sh.getLastRow();
  const re = new RegExp('^' + mod.key + '-(\\d+)$');
  let max = 0;
  if (last >= 2) {
    sh.getRange(2, 1, last - 1, 1).getValues().forEach(function (r) {
      const m = re.exec(normalizeId_(r[0]));
      if (m) max = Math.max(max, Number(m[1]));
    });
  }
  return mod.key + '-' + String(max + 1).padStart(3, '0');
}

function findRow_(sh, id) {
  const last = sh.getLastRow();
  if (last < 2) return -1;
  const ids = sh.getRange(2, 1, last - 1, 1).getValues();
  for (let i = 0; i < ids.length; i++) if (normalizeId_(ids[i][0]) === id) return i + 2;
  return -1;
}

// Dòng trống hoàn toàn đầu tiên (không ghi đè dòng tiêu đề nhóm mà Lead tự gõ), nếu hết thì thêm dòng.
function firstEmptyRow_(sh) {
  const last = sh.getLastRow();
  if (last >= 2) {
    const rows = sh.getRange(2, 1, last - 1, COLUMNS.length).getValues();
    for (let i = 0; i < rows.length; i++) {
      if (rows[i].every(function (v) { return String(v).trim() === ''; })) return i + 2;
    }
  }
  const next = Math.max(last, 1) + 1;
  if (next > sh.getMaxRows()) {
    sh.insertRowsAfter(sh.getMaxRows(), 100);
    applyColumnRules_(sh);
    const filter = sh.getFilter();
    if (filter) filter.remove();
    sh.getRange(1, 1, sh.getMaxRows(), COLUMNS.length).createFilter();
  }
  return next;
}

function isoWeek_(d) {
  const p = Utilities.formatDate(d, TZ, 'yyyy-MM-dd').split('-').map(Number);
  const t = new Date(Date.UTC(p[0], p[1] - 1, p[2]));
  t.setUTCDate(t.getUTCDate() + 4 - (t.getUTCDay() || 7));
  const week = Math.ceil(((t - Date.UTC(t.getUTCFullYear(), 0, 1)) / 86400000 + 1) / 7);
  return t.getUTCFullYear() + '-W' + String(week).padStart(2, '0');
}

function moduleForId_(id) {
  const prefix = String(id).split('-')[0];
  return MODULES.filter(function (m) { return m.key === prefix; })[0] || null;
}

function moduleForKey_(key) {
  const k = String(key || '').trim().toUpperCase().replace(/\s+/g, '');
  if (!k) return null;
  const alias = { 'M1': 'M12', 'M2': 'M12', 'M1-M2': 'M12', 'M1M2': 'M12' };
  const target = alias[k] || k;
  return MODULES.filter(function (m) { return m.key === target || m.tab.toUpperCase() === target; })[0] || null;
}

function normalizeId_(v) {
  return String(v === null || v === undefined ? '' : v).trim().toUpperCase();
}

function parseIds_(raw) {
  return String(raw || '').split(/[,;\s]+/).map(normalizeId_).filter(function (x) { return x; });
}

function normalizeStatus_(v) {
  const s = String(v || '').trim();
  if (!s) return null;
  const code = s.toUpperCase().replace(/[\s-]+/g, '_');
  if (STATUS[code]) return STATUS[code];
  const labels = Object.keys(STATUS).map(function (k) { return STATUS[k]; });
  const hit = labels.filter(function (l) { return l.toLowerCase() === s.toLowerCase(); })[0];
  return hit || null;
}

function statusCode_(label) {
  return Object.keys(STATUS).filter(function (k) { return STATUS[k] === label; })[0] || 'TODO';
}

function dateKey_(d) {
  return d instanceof Date ? d.getTime() : Number.MAX_SAFE_INTEGER;
}

function colDef_(key) {
  return COLUMNS.filter(function (c) { return c.key === key; })[0] || null;
}

function col_(key) {
  for (let i = 0; i < COLUMNS.length; i++) if (COLUMNS[i].key === key) return i + 1;
  throw new Error('Không có cột ' + key);
}

function colLetter_(n) {
  let s = '';
  while (n > 0) { const m = (n - 1) % 26; s = String.fromCharCode(65 + m) + s; n = Math.floor((n - 1) / 26); }
  return s;
}

function listRule_(values, allowInvalid) {
  return SpreadsheetApp.newDataValidation().requireValueInList(values, true).setAllowInvalid(Boolean(allowInvalid)).build();
}

function dropdownOf_(key) {
  return DROPDOWNS.filter(function (d) { return d.key === key; })[0] || null;
}

function styleHeader_(range) {
  return range.setFontWeight('bold').setBackground(HEADER_BG).setFontColor(HEADER_FG).setWrap(true).setVerticalAlignment('middle');
}

function getOrCreateSheet_(ss, name) {
  return ss.getSheetByName(name) || ss.insertSheet(name);
}

function json_(obj) {
  return ContentService.createTextOutput(JSON.stringify(obj)).setMimeType(ContentService.MimeType.JSON);
}
