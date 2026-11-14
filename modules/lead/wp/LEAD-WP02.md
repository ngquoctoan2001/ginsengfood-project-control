# LEAD-WP02 — Sheet hiện "Nguyễn Quốc Toàn" thay chữ "Lead"

Trạng thái: ĐẠT (chờ Lead triển khai web app + push) · Rủi ro: R2 · Chế độ: W (worktree tách rời, ghép vào `toandeptrai` bằng cherry-pick) · Mốc: cùng lần triển khai 1.4.0
Hạng mục nâng: công cụ theo dõi (Sheet) · Sheet: M12-001 · Ước lượng: 1–2 giờ AI
Chỗ làm: `C:\Projects\_wt\lead\bp-task-tracker-1.4` (HEAD tách rời, trên `origin/toandeptrai` `547dd59a0` + WP01 `ed087632e`, `c418a793b`)
Lời Lead 02/11: "chỗ mấy cột người phụ trách - ghi tên tôi thay vì Lead… nhật ký này kia cũng vậy… muốn hiển thị tên tôi thay vì hiện chữ Lead".

## Brief
1. Repo `ginsengfood-business-platform`, thư mục làm việc `C:\Projects\_wt\lead\bp-task-tracker-1.4` (HEAD tách rời, KHÔNG tạo nhánh,
   không switch, không commit — phiên chính commit). Base `c418a793b`.
2. Mục tiêu: chỗ nào Sheet hiện Lead như **một người** (giá trị ô) thì hiện `Nguyễn Quốc Toàn`, cả dữ liệu ghi mới lẫn dữ liệu đã có.
   - `team.json`: member `displayName` "Lead" → "Nguyễn Quốc Toàn" (giữ `role: "lead"`, thêm "Nguyễn Quốc Toàn" vào `gitNames`);
     `moduleOwners` M12, M7, M8 → "Nguyễn Quốc Toàn"; `moduleCoOwners.M3` mục kết nối M8 bỏ `member: "Lead"` nếu không còn cần
     (đọc `coOwnerFor`, `sheet-sync.mjs:174`, và mọi chỗ so `displayName`; hành vi "Lead làm M3 kết nối M8 chỉ ghi Sheet" giữ nguyên).
   - `apps-script/Code.gs`: `MODULES` owner M12/M7/M8; danh sách thả xuống owner bỏ 'Lead'; câu Hướng dẫn mục 1 "(Lead)" → tên.
     **Bí danh phía server:** giá trị người = `Lead` (hoặc `Lead (<agent>)`) gửi tới `upsert`/`weekly`/nhật ký → ghi `Nguyễn Quốc Toàn`
     (`Nguyễn Quốc Toàn (<agent>)`), vì các repo khác còn `team.json` cũ tới khi chạy `install.mjs`; khoá `weekly` so theo tên đã quy đổi.
     **Đổi dữ liệu cũ:** hàm chạy lại được nhiều lần (idempotent, `LockService`), gọi trong `setupTracker()` và có mục menu riêng
     "Đổi chữ Lead thành Nguyễn Quốc Toàn": chỉ ở **các cột người** (tìm theo tiêu đề, không theo số cột) — cột Người phụ trách và cột
     người làm/cập nhật của mọi tab module, cột người của tab Nhật ký, cột Người phụ trách của tab Báo cáo tuần — ô trim = `Lead` hoặc
     `Lead (…)` thì đổi; trả số ô đổi theo tab (thông báo bằng `notify_`). Không đụng tiêu đề ("Lead duyệt", "Ghi chú Lead",
     "Đánh giá của Lead" giữ nguyên), không đụng cột chữ/ghi chú, không đụng tab khác. Tab Tổng quan, Luồng song song tự dựng lại theo
     `MODULES` (kiểm M3 vẫn ba dòng Phúc, Tài, Toàn; M1-M2/M7/M8 đếm đúng task sau khi đổi). `VERSION` giữ 1.4.0 (chưa triển khai lần nào).
   - `sheet-sync.mjs`: ví dụ help `--owner Lead` → `--owner "Nguyễn Quốc Toàn"`; chỗ nào phụ thuộc chuỗi "Lead" làm tên người thì đổi
     theo `team.json`. Câu chữ nói về vai trò ("Lead điền webAppUrl…", "hỏi Lead") giữ nguyên.
   - `CLAUDE.md`, `AGENTS.md` của repo này: chỉ dòng `Modules: …` trong mục `## Weekly Tracking & Task Sheet Rule (MANDATORY)` sửa đúng như
     `install.mjs` `ruleSection()` sẽ sinh từ `team.json` mới (gộp M1–M2, M7, M8 và M3 kết nối M8 vào cùng tên nếu hàm gộp như vậy;
     chạy thử hàm trong bộ test để lấy chuỗi đúng, không chạy `install.mjs` lên repo).
   - README (`tools/task-tracker/README.md`): câu nào nói owner/tên hiển thị là "Lead" thì sửa; thêm một dòng về menu đổi dữ liệu cũ.
   - Tiêu chí đạt: bộ test mới ở `C:\Projects\_wt\lead\test-lead-name\` (dùng lại `C:\Projects\_wt\lead\test-weekly\gas-mock.mjs` bằng import,
     không sửa tệp đó) viết đỏ trước: đổi dữ liệu cũ đúng cột/đúng ô, chạy lần 2 đổi 0 ô, tiêu đề và cột chữ không đổi, ô "Lead (Codex)"
     đổi đúng, bí danh ở `upsert` và `weekly` (gửi owner "Lead" → ô ghi tên; chạy `weekly` lại với "Lead" không sinh dòng trùng với dòng
     đã ghi tên), Tổng quan đếm đúng; CLI `whoami` với git name "Nguyen Quoc Toan" trả `person` = "Nguyễn Quốc Toàn", `log` Lead làm M3
     kết nối M8 vẫn chỉ ghi Sheet (dry-run). Bộ cũ `node --test C:/Projects/_wt/lead/test-weekly/*.test.mjs` vẫn 70/70 (ca nào giả định
     chữ "Lead" làm tên thì báo, không sửa bộ cũ — phiên chính quyết).
3. Phạm vi ghi: `tools/task-tracker/team.json`, `apps-script/Code.gs`, `sheet-sync.mjs`, `README.md`, `bao-cao-tuan/README.md` (nếu cần),
   `CLAUDE.md`, `AGENTS.md` (chỉ dòng `Modules:`), bộ test ở `C:\Projects\_wt\lead\test-lead-name\`. Cấm: `sheet.json`, `install.mjs`
   (trừ đọc), mọi tệp khác.
4. Đọc trước: `team.json`; `Code.gs` (`MODULES` ~28, cột/owner dropdown ~57, `COLUMNS`/tiêu đề tab module, `setupTracker`, menu, tab Nhật ký,
   `upsertTask_`, `upsertWeekly_`, `refreshBoards_`); `sheet-sync.mjs` (~150–200, 430–540); `install.mjs` `ruleSection()`.
5. Được chạy: `node`, test, `git status/diff` (luôn thêm `-- . ':!**/sheet.json' ':!**/.env*'`). KHÔNG: gọi web app thật (chỉ `--dry-run`),
   đọc/in `sheet.json`, `install.mjs` lên repo, commit, push, switch, tạo nhánh, sửa repo khác.
6. Bằng chứng: lệnh test + số ca đạt/tổng (đỏ trước), `node --check`, parse `Code.gs`, diff stat, chuỗi `Modules:` mới.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`.
8. Đầu ra: tin nhắn cuối ≤ 25 dòng theo LUAT_SUBAGENT mục 10.

## Diễn biến (mỗi vòng một dòng, mới nhất ở cuối)
- 02/11 phiên lead: theo D-m34-004 (chỉ nhánh `toandeptrai`) đưa worktree về `origin/toandeptrai` tách rời, cherry-pick WP01 → `ed087632e`,
  `c418a793b` (cây giống hệt `4e8e3de16` đã kiểm, test 70/70); giao coder v1.
- 02/11 coder v1: xong 7 tệp · bộ mới 38/38 (đỏ trước), bộ cũ 70/70 (2 chỗ bộ cũ giả định chữ "Lead" làm tên → phiên lead sửa kỳ vọng)
  · chuỗi `Modules:` lấy từ `ruleSection()` · bí danh server `Lead`/`Lead (<agent>)` → tên ở upsert/weekly/nhật ký.
- 02/11 verifier: ĐẠT · chạy lại 38/38 + 70/70 · đột biến 24/25 · điểm phụ: menu riêng không dựng lại Tổng quan/Luồng song song
  (chú thích Code.gs sai); ghi từng đoạn ô ở `renameLeadData_` có thể chậm 1–3 phút với nhật ký dài (dưới giới hạn 6 phút).
- 02/11 14:27 phiên lead: sửa điểm phụ 1 (ca test đỏ trước → `renameLeadData()` gọi `setupOverviewTab_` + `refreshBoards_`; README) ·
  commit `d145849d7` · `git cherry-pick --ff` `ed087632e` `c418a793b` `d145849d7` lên `toandeptrai` (SHA giữ nguyên, chưa push) ·
  test trên checkout chính 70/70 + 39/39, `node --check` · Sheet M12-001 Chờ review. CHƯA CHẠY trên Apps Script thật.

## Bước kế tiếp chính xác
Lead dán `C:\Projects\ginsengfood-business-platform\tools\task-tracker\apps-script\Code.gs` (nhánh `toandeptrai`) vào Apps Script → Lưu →
Triển khai → Quản lý các bản triển khai → Chỉnh sửa → Phiên bản mới → menu Task Tracker → "Khởi tạo / cập nhật cấu trúc" (tự đổi ô "Lead"
cũ, báo số ô) → `sheet-sync.mjs ping` thấy 1.4.0. Push `toandeptrai` khi Lead cho; `install.mjs` sang 5 repo khác sau đó.

## Còn lại / CẦN QUYẾT
- Tiêu đề cột vai trò ("Lead duyệt", "Ghi chú Lead", "Đánh giá của Lead") giữ nguyên — hỏi Lead có đổi không.
- Repo khác (ops-core, ivr, golden-hour-video, module5, module6) còn `team.json` cũ tới khi chạy `install.mjs`; bí danh server che phần hiển thị.
