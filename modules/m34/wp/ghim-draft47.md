# ghim-draft47 — M3 ghim lại hợp đồng IVR M8 1.0.0-draft.47 + callback 1.1.0-draft, sửa tài liệu theo gửi lại callback 24 giờ

Trạng thái: XONG `76ef7d060` (chưa push) · verifier ĐẠT · bộ đủ sóng ĐẠT 18:4x, gộp dev `d3d91686d` · Rủi ro: R2 · Chế độ: A (worktree tách rời → patch → phiên chính áp + commit `toandeptrai`) · Mốc: 17/11
Hạng mục nâng: M3 → M8 ghim đúng hợp đồng M8 đang ở `main` (draft.47) và tài liệu M3 không còn giả định callback cạn nhanh · Sheet: M3-023 · Ước lượng: 2 giờ
Chỗ làm: `C:\Projects\_wt\m34\ghim-draft47` · Base SHA: `9a1970240` (= `origin/dev`) · Patch: `C:\Projects\_wt\m34\ghim-draft47.patch`
Nguồn: M8 `main` `8ab726ddf` (push 12:04 16/11; D-m8-112/113/114, W-0543); lần ghim trước `dd70094b0` + `09c13eefb` (draft.46, sha256 `67674591…`); D-m34-091 (việc của m34).

## Brief
1. Repo `C:\Projects\ginsengfood-business-platform` (chỉ đọc) · làm trong `C:\Projects\_wt\m34\ghim-draft47` (HEAD tách `9a1970240`) · luật chung `C:\Projects\_wt\m34\_tools\BRIEF_CHUNG_SUA_NKB.md`
   (đọc trước; thay base = `9a1970240`). Repo M8 `C:\Projects\ginsengfood-ivr` CHỈ ĐỌC bằng `git show 8ab726ddf:<đường dẫn>` (không checkout, không fetch).
2. Mục tiêu và tiêu chí đạt:
   (a) Ghim lại như cách `dd70094b0` + `09c13eefb` đã làm cho draft.46 (đọc hai commit đó trước), nay theo M8 `8ab726ddf`:
       `specs/api/openapi/ivr-order-confirmation.v1.yaml` (1.0.0-draft.47; hash Git blob bytes, so với `specs/api/openapi/contract-manifest.json`),
       callback `specs/api/openapi/order-core-ivr-callback.target-v1.yaml` / baseline `order-core-ivr-callback.v1.1.0-draft.yaml` (1.1.0-draft), IR-06 `integration-requirements/06-module-3-api-handover.md` nếu M3 có ghim hash.
       Cập nhật `back-end/src/main/resources/ivr/admin-response-schemas.json` (`source_sha256` VÀ nội dung schema nếu các response quản trị M3 dùng đã đổi giữa draft.46 và draft.47 — so bằng diff, đừng đoán),
       javadoc `IvrAdminDtos.java`, `OrderIvrTaskAssembler.java`, docs `docs/integration/m3-m8/01`, `04`, `08`, `README.md` (mọi dấu ghim draft.46 → draft.47, SHA M8 `8ab726ddf`).
       Nếu draft.47 đổi wire mà M3 ĐANG dùng (intake, revoke, callback, các operation quản trị trong `IvrAdminOperation`) theo cách làm M3 hỏng: KHÔNG tự sửa logic, ghi `CẦN QUYẾT` kèm tệp:dòng hai phía.
       Phần MỚI của draft.47 (`/tasks/{id}/result`, `/call-jobs/{id}/result`, trường `recall_of_task_id`, callback `customer_input_at`) M3 trên base này CHƯA dùng: chỉ ghi rõ trong docs
       "chưa dùng; mã dùng nằm ở nhánh gộp của chú Dũng do Phúc gộp". KHÔNG sửa `OrderIvrCallbackParser` (M3 vẫn từ chối trường lạ; M8 giữ cờ `IncludeCustomerInputAt` TẮT — ghi điều này vào docs).
   (b) Tài liệu theo gửi lại callback mới của M8 (mặc định BẬT: gửi lại tới hạn xác nhận + 24 giờ, giãn dần tới 5 phút/lần; thay "3 retry, 250–5000 ms"):
       sửa `docs/integration/m3-m8/01-nguon-hien-hanh-va-hop-dong.md:190` và mọi chỗ trong `docs/integration/m3-m8/**` giả định callback cạn nhanh (grep "3 retry", "250", "cạn", "RETRY_EXHAUSTED", "replay").
       Ghi ảnh hưởng tới M3 bằng mã (tệp:dòng): callback tới sau khi watchdog đã huỷ đơn → M3 trả gì (409 `REJECTED_STALE`?), callback lặp nhiều lần trong 24 giờ có idempotent không. CHƯA KIỂM thì ghi vậy.
   (c) Test: chạy lớp test kiểm hash/ghim hợp đồng IVR (grep `67674591`, `source_sha256`, `draft.46` trong `back-end/src/test`) + `IvrAdmin*Test` + `OrderIvr*Test` + test hợp đồng IVR; đỏ trước khi đổi hash (nếu có test hash) rồi xanh.
3. Phạm vi ghi: `back-end/src/main/resources/ivr/admin-response-schemas.json`, javadoc/chú thích trong `IvrAdminDtos.java`, `OrderIvrTaskAssembler.java` (không đổi logic), test ghim hợp đồng IVR trong `back-end/src/test/**`,
   `docs/integration/m3-m8/**`. CẤM: `OrderIvrCallbackParser*`, `IvrTaskHttpClient.java`, mọi logic Java khác, `deploy/**`, `front-end/**`, ops-core, repo M8.
4. Đọc trước: `git show dd70094b0` và `09c13eefb` (khuôn ghim), `git -C C:/Projects/ginsengfood-ivr diff e1a554518 8ab726ddf -- specs/api/openapi integration-requirements/06-module-3-api-handover.md`, `docs/integration/m3-m8/01` mục hợp đồng + dòng 190.
5. Lệnh kiểm nhanh: Maven qua khoá `bash C:/Projects/_wt/m34/_tools/mvn-lock.sh C:/Projects/_wt/m34/ghim-draft47/back-end test -P ci-unit -Dtest='IvrAdmin*Test,OrderIvr*Test,<lớp ghim hash>' -DfailIfNoTests=false -Dsurefire.failIfNoSpecifiedTests=false` (timeout 600000 ms); link nội bộ docs đã sửa còn trỏ đúng.
6. Bằng chứng: patch; bảng hash cũ → mới (tệp M8, sha256 Git blob, tệp M3 ghi); danh sách khác biệt draft.46 → draft.47 ảnh hưởng M3 (đang dùng / chưa dùng); số test; đột biến ≤ 2 (đổi 1 ký tự hash → test ghim đỏ).
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`.
8. Đầu ra ≤ 25 dòng theo brief chung; báo cáo dài `C:/Projects/_wt/m34/ghim-draft47-bao-cao.md`.

## Diễn biến
- 16/11 12:36 tạo worktree `_wt/m34/ghim-draft47` (`9a1970240`), giao coder (song song `script-99`).

- 16/11 12:5x coder: ĐẠT · patch 8 tệp +99/−17: `admin-response-schemas.json` `source_sha256` → `c0b81180…` + `omitted_fields.IvrCallAttemptDetail=[customer_input_at]` (schema giữ, BFF lọc); javadoc `IvrAdminDtos`, `OrderIvrTaskAssembler`; test mới `IvrContractPinTest` (đỏ 3/3 trước, xanh sau); docs m3-m8 01/04/08/README (draft.47, callback 1.1.0-draft `323ba1d2…`, IR-06 `2e07281a…` tham khảo; §5.2 gửi lại tới hạn + 24 giờ; callback sau watchdog → 409 `REJECTED_STALE`; lặp cùng key → 200 `DUPLICATE_ACCEPTED`) · draft.47 không đổi wire M3 đang dùng · Maven `IvrAdmin*Test,OrderIvr*Test,IvrContractPinTest,!*PostgresTest` 158/0/0/0 (24 lớp) ×2 · đột biến 2/2 · link 53 OK · CHƯA CHẠY ca Postgres, liên thông M3–M8 · không đổi `contracts/api-snapshots/m3-ivr-result-callback-wp03.json` (nhánh chú đổi). Giao verifier.
- 16/11 13:1x verifier: ĐẠT (chờ bộ đủ) · tự tính hash Git blob draft.47 `c0b81180…`, callback `323ba1d2…` khớp manifest M8 + mọi chỗ ghim · tự diff YAML: 44 operation cũ, intake, revoke, 27 operation quản trị không đổi; chỉ thêm 2 operation internal + 2 trường tuỳ chọn · tệp:dòng M3 cho 409 `REJECTED_STALE`/200 `DUPLICATE_ACCEPTED` đúng · Maven 158/0/0/0 · đột biến 2/2 · link 53 + 37 OK · góp ý câu `omitted_fields` ở doc 04:27 → phiên chính sửa khi áp · lưu ý `contracts/api-snapshots/m3-ivr-result-callback-wp03.json` vẫn callback 1.0.0 (đúng với parser hiện tại; nhánh chú đổi) · áp patch + sửa câu → commit `76ef7d060` (chưa push).

- 16/11 18:4x bộ đủ sóng (`kiem-song3` @ `d8960e9b0`): test khuôn 755 OK (bỏ qua 9) · vitest 9302/9355, chạy riêng lại chỉ còn `proxy.test.ts` (đỏ sẵn trên dev) và `legal-hold-real-spec-guard` (CRLF máy này); 2 tệp quá giờ chạy riêng 183/183 · ci-unit 36912 ca, đỏ 88 = 39 đỏ sẵn (`do-san-afb6d404c.txt`) + `StagingTestDataFlowPostgresTest:211` (đỏ cả trên `9a1970240`, trước sóng) + 48 ca của 35 lớp Postgres hỏng vì Docker Desktop bị dừng từ ngoài lúc 16:31 (mã 0x40010004, không phải phiên này) → bật lại Docker, chạy riêng 36 lớp: 35 xanh, chỉ còn `StagingTestDataFlow` · KẾT LUẬN: sóng không thêm ca đỏ. Gộp `origin/dev` `b2568a319` (19 commit Phúc) vào `toandeptrai` → `b4d4b1368` (xung đột 1 tệp `GO_SKU_DEMO.md` mục 1: giữ câu mới của dev + đường dẫn .99) + `d3d91686d` sửa `env.mau` khối `MAIL_*` (CI dev 43840925341 đỏ 2 ca khuôn) · bản gộp: khuôn 757 OK, `docker_tests.py --check` 459, vitest inventory/gold_hour/api 416/416, tsc 4 lỗi đỏ sẵn ngoài sóng, Maven vùng sóng 1668 ca chỉ đỏ `StagingTestDataFlow` (sẵn) + 2 ca `SkuMasterSeederWriteContractTest` từ M3-117 của Phúc (tệp trùng byte dev; ghi mục 7 bàn giao Phúc). Chưa push.

## Bước kế tiếp chính xác
Bộ đủ sóng ĐẠT 16/11 18:4x; gộp dev → `d3d91686d` (chưa push) · chờ Toàn duyệt push + PR vào `dev` → báo M8 SHA đã ghim draft.47

## Còn lại / CẦN QUYẾT
- (trống)
