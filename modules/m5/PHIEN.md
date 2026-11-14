# Phiên `m5` — M5 Facebook Gateway (Tài làm, Lead giám sát)

Lead dùng phiên này để **giám sát tiến độ sprint, rà đủ task của Tài, gỡ việc chờ Lead quyết**. Đồng bộ nguồn an toàn trước khi rà;
phần rà không sửa mã/commit vào repo Tài.
`/ra-soat tai` bao gồm cập nhật Lead duyệt + Ghi chú Lead trên Sheet và soạn tin nháp theo quy trình chung, không tự gửi.
Lead muốn tự nhận một làn (ví dụ hạ tầng — làn I) → `/quyet` ghi rõ làn nào, báo Tài, rồi mới chạy `/song` (chế độ W).
Làn Lead đang nhận: **UI quản trị** (D-m5-024) — M5-137 API đọc quản trị, M5-138 UI Next.js `web/`; phiên này code, đứng tên Nguyễn Quốc Toàn.
Màn M6 trong `web/` chung do Tài code (D-m6-012, DL-220); phiên này không code phần `m6/`.

Quyết định đã áp từ phiên `lead` (31/10, D-m5-001; D-lead-005/006): Tài đã có quyền quản trị Page; nếu Sheet còn báo thiếu
thì ghi lệch cần Tài xác nhận, không hỏi cấp lại. CI không bắt buộc trong giai đoạn dev, không đưa quyền admin repo thành việc chặn.
Không đề xuất hoãn M6 vì quỹ giờ hoặc giữ AI tắt với khách theo đề xuất cũ. Việc mở khách thật vẫn cần cổng Go/No-go và duyệt riêng.
Báo cáo tuần chỉ đối chiếu số, không kết luận TRẢ LẠI và không tự soạn/gửi tin. Rà task thông thường mặc định soạn tin nháp;
chỉ gửi khi bạn ra lệnh rõ cho đúng người/nội dung.

D-m5-002 (02/11 11:14): bạn đã duyệt cả 7 mẫu M5-105 và xác nhận giờ CSKH 8:00–20:00 hằng ngày (m5.4 B).
D-m5-025–028 (10/11): M6 gộp vào repo này (`m6/`, DL-220), repo module6 lưu trữ; giữ tên `module5` tới sau 30/11; PM của Tài chốt được
lựa chọn kỹ thuật có đề xuất sẵn trong docs (phạm vi pilot, Go/No-go, dữ liệu khách, bảo mật vẫn do Tài/Lead); Go/No-go dời theo HTTPS `mkt.`.
D-m5-040 (13/11, D-lead-034/035/036): M5 + M6 chạy ở máy mkt 192.168.1.98 (`/data/m5`), không còn .60; M3 + M4 sang .99 (M5 gọi `http://192.168.1.99:80`
sau giờ cắt 14/11 22:45). `mkt.` do nginx 443 của Anh Tuấn trỏ về .98. Bảng máy: `chung/MAY_CHU.md`. Nhắc .60 chỉ khi nói đường lui hoặc M7.
D-m5-018 (05/11, DL-200/DL-194 module5): giữ pilot 14/11; App Review nộp khi đủ HTTPS `mkt.` trên .98 + token Page + M5-101; Meta chưa duyệt thì pilot
chỉ người có vai trò trên app; pilot chỉ chạy giờ có người trực.
D-m5-034–037 (13/11): trên Page pilot M4 dùng Claude API soạn câu trả lời tin riêng, qua cửa gửi chung + FinalGuard, người trực nhận chuyển tiếp;
bật chỉ khi có văn bản pháp chế đợt 2 (`AI_ADVISOR_MODE` trống trên .98 tới lúc đó), NCC A1–A6, P0 M4, chữ M5-101 khai AI được duyệt.
Báo giá/nháp đơn chặn suốt pilot (D-m5-015, D-m5-039). Chữ M5-101 do Tài chốt, bạn đối chiếu P01/P02 + đọc câu AI (D-m5-038). Go/No-go: No-go lượt 13/11, họp lại HTTPS + 2 ngày làm việc, chậm nhất 20/11.
Pilot chạy chế độ phạm vi; production cần `ORDER_STATE_READER` thật (M3 API đọc trạng thái đơn của Phúc + reader của Tài, trước 30/11).
D-m5-019–022 (05/11): chữ M5-101 theo bảng P01–P23 (bỏ câu "tư vấn sản phẩm"; Tài sửa 3 câu vượt mã; câu khai AI theo D-m5-034/038);
M5-074 tách phần chạy M4 thật thành task riêng; M5-104 kênh CSKH thật bắt buộc trước pilot; M5-060 sửa luật chung trước 10/11.
D-m5-015–017 (04/11): Page pilot không báo giá/nháp đơn (gộp vào D-m5-018); M5-123 dùng quyền Tiêu chuẩn của Meta,
chỉ nhân viên có vai trò trên app, chỉ Page Ssavigroup, không nhắn khách; bài đăng chỉ kèm link tên miền công ty, BR-040 giữ cho trả lời khách.
D-m5-011–014 (04/11): Page pilot là Quà Tặng Sức Khỏe (AI trả lời tin riêng theo D-m5-034), chạy thật về Page chính
Cháo Sâm Mỗi Ngày khi sếp chốt Haravan Funnel; M5-123 đăng bài nhiều Page thuộc M5, ngoài Go/No-go, làm sau App Review 06/11,
bản thật tắt; tài khoản "Sâm Biển Việt Nam" do Chú giữ, không đổi/gỡ; file mật khẩu Facebook do Tài làm tay, không qua Claude/Codex.
D-m5-006/007/008 (03/11 13:47): chấp nhận DL-184 (RBAC của M5-061 sang M5-016, hạn 05/11); trang M5-101 đăng GitHub Pages,
không mở thêm đường ngoài trên nginx 443 của Anh Tuấn. M5-060: luật chung (D-m5-022) cộng danh sách phụ đúng 11 tên phố (3 tĩnh + 8 họ Triệu); che thừa theo DL-225 (a)
thì chuyển người, đếm khi pilot; 2 khe lọt ở TRK-22; Đạt khi Tài ký DL-225 (D-m5-031). Chữ tin tự hại 3.4 đã duyệt (D-m5-030).
Không hỏi lại việc duyệt chữ/lịch này. Bản nguyên văn được duyệt: `ra-soat/2026-11-02-m5-105-duyet-chu.md`.
Tài còn đồng bộ DL-170/tài liệu/tracker và kiểm phần triển khai; quyết định này không chứng minh đã bố trí người trực hoặc nghiệm thu gửi thật.

## Repo

- `C:\Projects\module5` (GitHub `sasamviet-ai/module5`), nhánh `main`. NestJS 11, TypeScript strict, Prisma 6, Postgres 16, Redis 7, Node 24.
  Từ 10/11 (DL-220, D-m5-025): M5 ở gốc, M6 ở `m6/` (luồng `m6` rà ở đây), UI quản trị chung `web/`; bản build M5 loại `m6/`.
  `C:\Projects\module6` / `sasamviet-ai/module6` chỉ còn để đọc lịch sử, không commit. Giữ tên `module5` tới sau 30/11 (D-m5-026).
- Quy trình của Tài (sprint plan §2): mỗi task một phiên, worktree + nhánh `m5/M5-0xx-<tên>` từ `main` (worktree ở máy Tài `D:/M5-worktrees`),
  PR vào `main`, Tài tự gộp PR của mình (Lead soát cuối tuần). Tác giả commit `claude-subagent/m5-0xx`.
- Bản clone này của Lead: mỗi lượt rà kiểm sạch/nhánh/upstream rồi `git -C C:\Projects\module5 pull --ff-only --no-rebase`
  trên `main` theo dõi `origin/main`, theo bước đồng bộ của `.claude/commands/ra-soat.md`; ghim SHA dùng để kiểm.
  Không pull khi dirty hoặc có phiên đang dùng checkout; báo lý do, không tự đổi nhánh/stash/reset.
  Lead không commit "save" thẳng lên `main`. Riêng M5-137/138 (D-m5-024): làm trong `C:\Projects\_wt\m5\<gói>` trên nhánh `m5/M5-13x-…`,
  rebase lên `origin/main` mới nhất, đạt DoD §5.4 (CI_LOCAL 5/5), rồi push fast-forward lên `main`; không merge commit, không force.

## Luật repo phải nhớ

- `CLAUDE.md` và `AGENTS.md` phải giống hệt từng byte. `CLAUDE.md` §4 còn câu cũ "chỉ làm tài liệu" — sửa trong M5-007 (chờ Lead duyệt).
- Cấm: đổi `PRODUCTION_ENABLED` (`src/foundation/feature-flag/production-posture.ts`); đặt `M5_M7_DISPATCH_MODE=real`;
  tạo `.env` ở gốc hoặc `prisma/`; bí mật hoặc chuỗi số từ 10 chữ số; ghi vào `_archive/`; reset/stash việc người khác.
- **Phiên Claude không đọc, không sửa mọi `.env*`, kể cả `.env.example` và qua tiến trình con** (DL-080).
- Tracker khi triển khai task: mỗi task một dòng `WT-nnn`; sau prompt có đổi tệp/test/git, phiên chính chạy `sheet-sync.mjs log --id M5-0xx`.
  Riêng `/ra-soat tai`: không dùng `log` ghi đè trạng thái coder; cập nhật `Lead duyệt` theo kết luận và nối `Ghi chú Lead`, tìm ID/header và đọc lại.
- Sổ quyết định của repo: `docs/00-overview/DECISION_LOG.md` (DL-xxx); M6 giữ sổ riêng `m6/docs/00-overview/DECISION_LOG.md`.
  Người chốt (D-m5-027): PM của Tài được chốt lựa chọn kỹ thuật đã có đề xuất trong docs, ghi nguồn và người uỷ quyền; phạm vi pilot,
  điều kiện Go/No-go, dữ liệu khách, bảo mật phải do Tài hoặc Lead chốt. Khi rà chỉ bắt DL PM chốt chạm bốn vùng này.
- Chạy song song (chỉ khi Lead nhận làm một làn, ví dụ làn I hạ tầng): chế độ W như Tài; đọc trước luật chung phiên coder của Tài
  `M4-PLAN/02_PROJECT_CONTROL/04_REPORTS/M5/LUAT_CHUNG_PHIEN_CODER.md` (junction `node_modules`, cấm `npm ci` trong worktree,
  DB `module5` dùng chung qua ServBay).

## Lệnh

- `npm ci` rồi `npx prisma generate` (npm 11 chặn script cài của Prisma).
- `npm run typecheck` · `npm run typecheck:test` · `npm run build` · `npx prisma validate` · `npm test` (`-- --only <mẫu>`, `--jobs n`).
- DB mode: `M5_PROBE_DB=on npm test` — không chạy vào DB `module5` dùng chung khi rà. Chỉ chạy trong môi trường/schema và Redis
  đã xác minh tách biệt theo harness hiện hành; chưa đủ điều kiện thì dùng bằng chứng CI đúng SHA, ghi rõ chưa chạy local DB.
- Tài liệu: `node scripts/docs-check/check-links.cjs`, `node scripts/trace/run.cjs --check`.
- CI `.github/workflows/ci.yml`: typecheck/build, test không DB, test có Postgres 16 + Redis 7, kiểm tài liệu, docker build + khởi động thử.
  GitHub Actions dừng từ 06/11; bằng chứng CI là CI local theo phần chạm tới (DL-220): ngoài `m6/` `node scripts/ci-local/run.cjs` (`GATE=ĐẠT`),
  trong `m6/` `scripts/ci_local.py` (`CI_LOCAL n/N`), chạm cả hai thì cả hai. Kết quả Tài dán là tự khai; khi rà chạy lại trên SHA ghim.
  Điều kiện gộp PR M5 (D-m5-032): khối CI_LOCAL `GATE=ĐẠT` của commit cuối dán nguyên vào PR, chỉ gộp khi `GATE=ĐẠT`, chạm `web/` thì cổng chạy cả
  typecheck/lint/vitest `web/`; không cần commit status `ci-local`. Khi rà, PR thiếu khối hoặc gộp lúc KHÔNG ĐẠT là trượt DoD điều 4.

## Kế hoạch sprint (nguồn chính)

`docs/04-sdlc/SPRINT_PLAN_2026-11-15.md` v1.1 (DL-157): 75 task M5-002…M5-121, ~128 giờ phiên AI + 86 giờ của Tài.
Làn: ĐP 002–008 · A 010–017 · B 020–025 · C 030–037 · D 040–044 · E 050–056 · F 060–065 · G 070–074 · H 080–084 · I 090–094 ·
J 100–105 · K 110–115 · L 120–121. Mốc riêng M5: 31/10 nền + CI · 03/11 staging nhận webhook thật · 07/11 luồng P0 trên staging +
nộp Meta App Review · 10/11 SMK-001–016 đạt · 13/11 Go/No-go · 14/11 thí điểm 1 Page.
D-m5-028/035/040: Go/No-go họp 2 ngày làm việc sau khi `mkt.` trên máy mkt .98 có HTTPS, chậm nhất 20/11 (lượt 13/11 No-go);
pilot theo Go/No-go; hạn chạy thật 30/11 (D-lead-025). Khoá chạy thật (D-m5-005) tắt tới họp Go/No-go.
Go/No-go cần: SMK 16/16 trên .98, UAT nội bộ, soát bảo mật, diễn tập khôi phục sao lưu, kết luận pháp lý, kênh CSKH thật M5-104 và
khởi động từ chối kênh báo giả (D-m5-021), Meta Advanced Access (chưa có thì pilot chỉ người có vai trò trên app, D-m5-018), **Lead duyệt**; chỉ khi đó M5-115 mới bật `PRODUCTION_ENABLED`. Trễ thì cắt P1 theo thứ tự M5-065, 044, 025, 037, 120.

Trạng thái thật: đọc trực tiếp Sheet tab M5, đối chiếu `docs/weekly-tracking/nguyen-phat-tai.md` và `WORK_TRACKING.md` tại SHA đã ghim.

## Danh mục kiểm khi rà soát PR của Tài

- Mỗi PR: ghi kết quả CI trên đúng commit nếu có (CI không bắt buộc ở dev theo D-lead-006); probe đỏ trước rồi mới mã
  (xem thứ tự commit); không SKIP thay PASS. CI xanh không thay bằng chứng staging hay nghiệm thu.
- Không chạm cờ cấm; không `.env`; không bí mật/chuỗi số dài trong fixture.
- Tệp nóng (`src/app.module.ts`, `outbound-guard.module.ts`, `src/full-pipeline/**`, `prisma/schema.prisma` + migration,
  `.env.example` + 2 tài liệu env): gộp lần lượt, mỗi task tối đa một migration.
- `TRACEABILITY.md` chỉ sinh lại ở M5-005; DECISION_LOG có dòng cho mỗi quyết định kỹ thuật mới.
- Task code nói "Hoàn thành": đối chiếu PR/merge và từng tiêu chí DoD §2.4; áp quyết định mới hơn (gồm CI dev optional).
  Task tài liệu/quyết định kiểm theo deliverable được giao, không tự thêm điều kiện PR hoặc receipt thuộc task khác.

## Sổ của Tài để đối chiếu

`C:\Projects\M4-PLAN` (pull trước): `02_PROJECT_CONTROL/04_REPORTS/M5/` (báo cáo Coder từng task, ảnh chụp Sheet `sheet-m5-*.json`,
`LUAT_CHUNG_PHIEN_CODER.md`), báo cáo đầu ngày mới nhất trong `04_REPORTS/PERIODIC/` mục M5. Chỉ đọc đoạn.

## Kiểm đầu phiên

- fetch; PR mới gộp vào `main` từ mốc (`git log --merges --format='%h %ad %s' --date=short <mốc>..origin/main`); nhánh `m5/*` còn mở.
- Sheet: `node tools/task-tracker/sheet-sync.mjs list --module M5` → số Hoàn thành / Đang làm / Bị chặn / trễ hạn so mốc sprint.
- Báo cáo đầu ngày mới nhất của Tài (mục "Cần anh làm", "Vướng").

## Rà soát (`/ra-soat tai`)

Theo `.claude/commands/ra-soat.md`: pull an toàn repo code và M4-PLAN trước, ghi kết quả/SHA; lấy **toàn bộ task M5 của Tài đang DONE/REVIEW** từ Sheet trực tiếp, kể cả task cũ;
ghim tập ID và SHA, chia auditor theo ID để mỗi task được đối chiếu tiêu chí/code/PR/DoD/test. Ghép bảng một-một, kiểm không thiếu/lặp,
đọc lại Sheet/PR cuối lượt và rà bổ sung task mới vào tập. Ngày hoặc mốc commit không tự thu hẹp tập task.
Theo D-m5-010 (D-lead-020): chỉ rà task chưa Đạt, task Cần sửa chưa sửa thì chờ; kết luận chỉ Đạt hoặc Cần sửa (thiếu bằng chứng
= Cần sửa, ghi việc phải làm). Ghi W/X bằng `node "C:\Projects\Project Control\tools\sheet_lead.mjs" ghi <ket-qua.json>` (công cụ
tự đọc lại), không mở trình duyệt; nối nhận xét có ngày/giờ, SHA, bằng chứng vào `Ghi chú Lead`, giữ ghi chú cũ.
Task Tài: chỉ W/X, không đổi H/J/%, cột coder hoặc dùng `sheet-sync log` lên task coder.
Hàng rà lấy bằng `sheet_lead.mjs can-ra --module M5`: task Cần sửa chỉ vào hàng khi Tài cập nhật lại dòng Sheet sau lượt rà;
sửa rồi mà chưa cập nhật dòng thì nhắc Tài trong tin, không tự rà lại.
Task Lead/Nguyễn Quốc Toàn trong M5: cập nhật đủ H/J/W và nối X theo D-lead-011; đạt phạm vi → H=Đã xong, J=Hoàn thành, W=Đạt.
Kết luận task không thay quyền triển khai/mở cờ production.
Soạn tin nhắn nháp cho Tài kèm bản rà; không gửi khi chưa có lệnh rõ. Báo cáo tuần giữ quy trình riêng ở mục dưới.

## Báo cáo tuần

Bước 2 cho `M5-cong-facebook` (Tài gửi file bước 1 cho Lead; bản commit trong repo `docs/weekly-tracking/bao-cao/` là dự phòng) — `/bao-cao-tuan`.
