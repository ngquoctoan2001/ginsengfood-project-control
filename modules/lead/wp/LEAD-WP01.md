# LEAD-WP01 — Ghi báo cáo tuần lên tab "Báo cáo tuần" của Sheet

Trạng thái: ĐẠT (chờ Lead triển khai web app + push) · Rủi ro: R2 · Chế độ: W · Mốc: trước kỳ 02–07/11 (07/11)
Hạng mục nâng: báo cáo tuần (công cụ chung) · Sheet: M12-001 (công cụ tracker) · Ước lượng: 2–3 giờ AI
Chỗ làm: `C:\Projects\_wt\lead\bp-task-tracker-1.4` (nhánh `lead/task-tracker-1.4.0`) · Base SHA: `f29bf2667` (`origin/dev`)
Chỗ kiểm: cùng worktree sau khi coder xong (verifier không sửa mã)

## Brief
1. Repo `ginsengfood-business-platform` (bản gốc của bộ tracker; `install.mjs` chép sang repo khác) · thư mục làm việc tuyệt đối
   `C:\Projects\_wt\lead\bp-task-tracker-1.4` · nhánh `lead/task-tracker-1.4.0` từ `origin/dev` `f29bf2667`.
2. Mục tiêu: Lead (và lệnh `/tong-hop-tuan`) ghi được mỗi kỳ một dòng/module vào tab `Báo cáo tuần` bằng một lệnh, chạy lại không tạo dòng trùng.
   - `apps-script/Code.gs`: `VERSION` 1.3.1 → 1.4.0; `doPost` thêm `case 'weekly'` (ghi) và `case 'weeklyList'` (đọc theo kỳ).
     Ghi nhận `rows: [...]` (1–20 dòng). Khoá dòng = (Từ ngày, Đến ngày, Module, Người phụ trách). Có thì cập nhật đúng các cột được gửi,
     cột không gửi giữ nguyên (đặc biệt "Đánh giá của Lead", "Gửi sếp" khi Lead đã điền tay); chưa có thì thêm dòng cuối.
     Ô ngày trên Sheet có thể là Date (người dán tay, locale vi) hoặc chuỗi `dd/mm/yyyy`/`yyyy-mm-dd` → chuẩn hoá trước khi so khoá; ghi ngày
     dạng Date. Module phải thuộc danh sách tab (`M1-M2`, `M3`…`M9`; nhận cả khoá `M12`). "Gửi sếp" chỉ nhận `Chưa gửi`/`Đã gửi`.
     Kiểm đầu vào sai → `{ok:false, error}` rõ ràng, không ghi một phần. Ghi một dòng vào tab Nhật ký như upsert task nếu hàm sẵn có cho phép
     (không bắt buộc). Không đổi hành vi `ping/get/list/upsert`.
   - `sheet-sync.mjs`: lệnh `weekly` — một dòng bằng cờ (`--from YYYY-MM-DD --to YYYY-MM-DD --module --owner --done --doing --blocked --next
     --file --review --sent --week`) hoặc nhiều dòng bằng `--rows <tệp.json>` (mảng đối tượng cùng tên trường); `--dry-run` chỉ in payload;
     lệnh `weekly-list --from --to`. Thêm vào `help`. Không ghi nhật ký tuần `docs/weekly-tracking/` cho lệnh này.
   - `README.md` (task-tracker) và `bao-cao-tuan/README.md`: mục ngắn "Ghi tab Báo cáo tuần" + ví dụ JSON; nói rõ Lead phải dán `Code.gs` mới
     vào Apps Script và **triển khai lại web app** (Deploy → Manage deployments → New version) thì lệnh mới chạy được.
   - Tiêu chí đạt: (a) bộ test Node chạy được bằng một lệnh, nạp `Code.gs` qua `vm` với bảng giả (mock `SpreadsheetApp`, `Utilities`,
     `ContentService`, `PropertiesService`… đủ cho các hàm dùng), phủ: thêm mới, chạy lại cùng khoá → không trùng, cập nhật giữ cột không gửi,
     ô ngày Date vs chuỗi, module/`sent` sai → lỗi và không ghi gì, `weeklyList` lọc đúng kỳ, `upsert` task cũ vẫn chạy; (b) test CLI:
     `weekly --dry-run` một dòng và `--rows` in đúng payload, thiếu trường bắt buộc → mã thoát ≠ 0; (c) `node --check` hai tệp .mjs, `Code.gs`
     parse được bằng `vm.Script`.
3. Phạm vi ghi: `tools/task-tracker/apps-script/Code.gs`, `tools/task-tracker/sheet-sync.mjs`, `tools/task-tracker/README.md`,
   `tools/task-tracker/bao-cao-tuan/README.md`, bộ test đặt ở `C:\Projects\_wt\lead\test-weekly\` (ngoài repo). Tệp cấm: `sheet.json`,
   `team.json`, `install.mjs`, mọi tệp ngoài `tools/task-tracker/`. Không có tệp nóng khác.
4. Đọc trước: `tools/task-tracker/apps-script/Code.gs` (`setupWeeklyTab_` ~dòng 366: 12 cột của tab; `doPost` ~433; `upsertTask_` để theo
   cách khoá/ghi nhật ký), `sheet-sync.mjs` (`COMMAND_FLAGS`, cách gửi payload, `--dry-run`), `tools/task-tracker/README.md`.
5. Được chạy: `node`, bộ test của mình, `git status/diff` (luôn thêm `-- . ':!**/sheet.json' ':!**/.env*'`). KHÔNG: gọi web app thật
   (`ping/list/upsert/weekly` không có `--dry-run`), đọc hay in `sheet.json`, `install.mjs`, commit, push, sửa repo khác.
6. Bằng chứng: lệnh test + số ca đạt/tổng; `node --check`; diff stat; mẫu JSON `--rows`.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`.
8. Đầu ra: tin nhắn cuối ≤ 25 dòng theo LUAT_SUBAGENT mục 10.

## Diễn biến (mỗi vòng một dòng, mới nhất ở cuối)
- 02/11 09:51 phiên lead: tạo worktree, giao coder v1.
- 02/11 10:07 coder v1: ĐẠT · Code.gs 1.4.0 (`weekly`, `weeklyList`), sheet-sync `weekly`/`weekly-list`, 2 README · `node --test` 70/70
  (đỏ trước 62/67), 12/12 lỗi cố ý bị bắt · tự quyết: thiếu `week` → tuần ISO `2026-W44`, thiếu `sent` → "Chưa gửi", tiêu đề lệch →
  `WEEKLY_HEADER_MISMATCH`, ô văn bản định dạng `@` (CHƯA CHẠY trên Sheet thật).
- 02/11 10:1x ghép: commit `21286531d` + cherry-pick `547dd59a0` (bản 1.3.1 của Lead, `origin/toandeptrai`) → `02cd09e10`, xung đột
  `VERSION` giải thành 1.4.0; test lại 70/70, `node --check`, parse `Code.gs` đạt. GitNexus chưa index repo này → `detect_changes` không chạy được.
- 02/11 10:3x verifier: ĐẠT · 70/70 · đột biến 18/23 (5 ca sống do test yếu: thứ tự `setValues`/`setNumberFormats`, tab có sẵn 2 dòng trùng
  khoá, `refreshBoards_`, mã thoát CLI, `--rows` không phải mảng) · cherry-pick không mất dòng 1.3.1 · `--dry-run` kỳ 26–31/10: 8 dòng, không gọi mạng.
- 02/11 10:4x sửa theo verifier: README (tên người thống nhất `Nguyễn Quốc Toàn`, chuỗi rỗng, chạy lại bỏ `review`/`sent`) → `4e8e3de16`;
  JSON kỳ 26–31/10 bỏ `sent`, `week` = `2026-W44`; `/tong-hop-tuan` bước 9 không gửi `sent`. Sheet M12-001 → REVIEW (`log` ok).
  Trạng thái: ĐẠT, chưa push. CHƯA CHẠY trên Apps Script thật (định dạng `@`, locale ngày).
- 02/11 14:27 phiên lead: theo D-m34-004 (chỉ nhánh `toandeptrai`) bỏ nhánh `lead/task-tracker-1.4.0`; WP01 lên `toandeptrai` thành
  `ed087632e`, `c418a793b` (cùng WP02 `d145849d7`), test 70/70 trên checkout chính, chưa push. Nhánh cũ còn đó, Lead xoá.

## Bước kế tiếp chính xác
Làm chung với LEAD-WP02: Lead dán `C:\Projects\ginsengfood-business-platform\tools\task-tracker\apps-script\Code.gs` (nhánh
`toandeptrai`) vào Apps Script → Lưu → Triển khai → Quản lý các bản triển khai → Chỉnh sửa → Phiên bản mới → `sheet-sync.mjs ping` thấy
1.4.0 → phiên lead chạy `weekly --rows` kỳ 26–31/10 (nếu Lead chưa dán tay TSV) và `weekly-list` kiểm. Push `toandeptrai` khi Lead cho.

## Còn lại / CẦN QUYẾT
- Push `toandeptrai` (Lead quyết); `install.mjs` sang repo khác sau đó. Test yếu 5 chỗ (verifier) — thêm khi sửa tracker lần sau.
