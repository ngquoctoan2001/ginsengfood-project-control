# ivr-client-f1f2 — M3 gọi M8: đọc đúng `retry_after_seconds` dạng chuỗi (F1), 403 lối Order Core xoá cache token và thử lại (F2)

Trạng thái: ĐẠT, đã vào `dev` `3627ce4f0` (PR #163, 17/11 08:12) · commit `b6f0a056e` · Rủi ro: R2 (thử lại gửi task gọi xác nhận; không đụng tiền, không đổi trạng thái đơn) · Chế độ: A (worktree tách rời → patch → phiên chính áp + commit `toandeptrai`) · Mốc: trước khi M3 bản mới lên .99
Hạng mục nâng: M3 → M8 không treo đơn ở TERMINAL_ERROR khi M8 xoay khoá/token, giãn thử lại đúng hẹn M8 khi bị giới hạn tần suất · Sheet: M3-023 · Ước lượng: 1–2 giờ
Chỗ làm: `C:\Projects\_wt\m34\ivr-client-f1f2` · Base SHA: `d3d91686d` (= `origin/toandeptrai`, PR #163) · Patch: `C:\Projects\_wt\m34\ivr-client-f1f2.patch`
Nguồn: m34.109 (verifier ghim draft.46, 15/11 07:33), Toàn duyệt 16/11 20:4x (D-m34-092). Hợp đồng M8 draft.47 (`C:\Projects\ginsengfood-ivr`, `specs/api/openapi/ivr-order-confirmation.v1.yaml`, `specs/api/06-error-codes.md`).

## Lỗi
- **F1:** `IvrTaskHttpClient.retryAfter()` chỉ nhận `error.details.retry_after_seconds` dạng số. Hợp đồng M8: `ErrorEnvelope.error.details` là `additionalProperties: { type: string }`
  (draft.47 dòng ~1614) và 429 không có header `Retry-After` (`06-error-codes.md:14`) → M8 gửi `"30"` (chuỗi) → M3 bỏ qua, thử lại theo backoff của mình, sớm hơn hẹn.
- **F2:** lối Order Core của M8 trả **403** `IVR_FORBIDDEN_CALLER` cả khi token có mặt nhưng không hợp lệ (hết hạn, xoay khoá) (`06-error-codes.md:10,37`), không phải 401.
  M3 chỉ xoá cache token và thử lại ở 401; 403 rơi vào `status!=200` → `TERMINAL_ERROR`, không `tokens.invalidate` → lệnh gửi task/thu hồi chết luôn, token hỏng còn trong cache.
  Áp cho cả `submit` (`/tasks`) và `revoke` (`/tasks/{id}:revoke`; nhánh chú dùng lại cho hàng thu hồi gọi lại).

## Brief
1. Repo `C:\Projects\ginsengfood-business-platform` (chỉ đọc) · làm trong `C:\Projects\_wt\m34\ivr-client-f1f2` (HEAD tách `d3d91686d`) · luật chung `C:\Projects\_wt\m34\_tools\BRIEF_CHUNG_SUA_NKB.md`
   (đọc trước; thay base = `d3d91686d`, tên gói = `ivr-client-f1f2`). Repo M8 `C:\Projects\ginsengfood-ivr` CHỈ ĐỌC (đọc tệp, không checkout/fetch).
2. Mục tiêu và tiêu chí đạt:
   (a) F1: `retryAfter()` nhận `retry_after_seconds` là số nguyên dương HOẶC chuỗi chỉ gồm chữ số `[0-9]{1,9}` (giá trị > 0); chuỗi khác (âm, thập phân, chữ, rỗng, quá 9 chữ số) bỏ qua như cũ.
       Giữ: lấy max với header `Retry-After` nếu có; kẹp [1, 300] giây; body hỏng không làm lỗi. Áp cho cả submit (429/5xx) và revoke (429/5xx) vì dùng chung hàm.
   (b) F2: `submit` gặp 403 → `tokens.invalidate(token)` + `Kind.RETRYABLE`; `revoke` gặp 403 → `tokens.invalidate(token)` + `RevokeKind.RETRYABLE`. Mã lỗi phân biệt được với 401
       (đề xuất `IVR_FORBIDDEN_CALLER` cho submit, cùng mã cho revoke — đọc `error.code` của body KHÔNG bắt buộc; nếu chọn tên khác thì nêu lý do). Giữ body như nhánh 401.
       Thử lại có trần: xác nhận bằng mã (tệp:dòng) rằng outbox gửi task (`OrderIvrProducerProperties.maxAttempts`, mặc định 5) và hàng thu hồi có trần số lần → cấu hình sai allowlist không thử lại vô hạn.
       Không đổi hành vi 400/404/409/422/429/5xx/200, không đổi token provider.
   (c) Mọi chỗ khác dùng mã `IVR_HTTP_403`/`IVR_REVOKE_HTTP_403` hoặc liệt kê mã lỗi IVR (grep `back-end/src/main`, `front-end/src`, `contracts/`, `docs/integration/m3-m8/`): sửa nếu thuộc phạm vi ghi, còn lại ghi `CẦN QUYẾT`.
       Các adapter khác trong `ivr/adapter/out` gọi lối Order Core/nội bộ của M8 mà cũng chỉ xử lý 401: KHÔNG sửa, liệt kê tệp:dòng trong báo cáo.
   (d) Test (R2, đỏ trước): trong `IvrTaskHttpClientTest` (và `IvrTaskRevocationHttpClientTest` cho revoke) thêm ca: 429 body `"retry_after_seconds":"30"` không header → 30 s;
       chuỗi `"abc"`/`"-5"`/`"1.5"` → bỏ qua; chuỗi + header lấy max; chuỗi `"999999"` kẹp 300; 403 submit → RETRYABLE + invalidate đúng token (1 lần); 403 revoke → như trên;
       401 giữ nguyên. Chạy thấy đỏ trên mã cũ một lần rồi xanh.
3. Phạm vi ghi: `back-end/src/main/java/com/ginsengfood/project/ivr/adapter/out/IvrTaskHttpClient.java`, `back-end/src/test/java/com/ginsengfood/project/ivr/adapter/out/IvrTaskHttpClientTest.java`,
   `IvrTaskRevocationHttpClientTest.java`, `docs/integration/m3-m8/**` (chỉ dòng nói cách M3 xử lý 401/403/429 khi gọi M8). CẤM: mọi tệp khác (`IvrAdminService`, token provider, outbox, `deploy/**`, `front-end/**`), repo M8.
4. Đọc trước: `IvrTaskHttpClient.java` (140 dòng), hai lớp test trên, `ginsengfood-ivr/specs/api/06-error-codes.md` dòng 1–60, draft.47 `ErrorEnvelope` (grep `ErrorEnvelope:`), `OrderIvrProducerProperties.java`.
5. Lệnh kiểm nhanh (tầng 1–2): `bash C:/Projects/_wt/m34/_tools/mvn-lock.sh C:/Projects/_wt/m34/ivr-client-f1f2/back-end test -P ci-unit -Dtest='IvrTaskHttpClientTest,IvrTaskRevocationHttpClientTest,IvrTaskStatusQueryAdapterTest,OrderIvr*Test,!*PostgresTest' -DfailIfNoTests=false -Dsurefire.failIfNoSpecifiedTests=false` (timeout 600000 ms).
   Bộ kiểm đủ — chỉ phiên chính, sau khi áp: lớp `ivr`/`order` ci-unit + `ModuleBoundaryArchitectureTest` trên SHA commit (D-m34-080 g).
6. Bằng chứng: patch; số ca đỏ trước/xanh sau; đột biến ≤ 3 (bỏ nhánh chuỗi ở F1; bỏ `invalidate` ở 403; đổi 403 về TERMINAL) đều bị bắt; tệp:dòng trần thử lại; danh sách adapter khác chỉ xử lý 401.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`.
8. Đầu ra ≤ 25 dòng theo brief chung; báo cáo dài `C:/Projects/_wt/m34/ivr-client-f1f2-bao-cao.md`.

## Diễn biến
- 16/11 20:5x tạo worktree `_wt/m34/ivr-client-f1f2` (`d3d91686d`), giao coder.
- 16/11 21:4x coder: ĐẠT · patch 5 tệp (`IvrTaskHttpClient.java` +13/−3, 2 lớp test +104/−10, docs m3-m8 01:132 + 05:99–100) · F1 `retryAfter()` nhận chuỗi `[0-9]{1,9}` > 0; F2 403 submit/revoke → invalidate + RETRYABLE `IVR_FORBIDDEN_CALLER`
  · lệnh mục 5: mã cũ 120/6 hỏng (đúng 6 ca mới) → sau sửa 120/0 · đổi 2 assertion cũ theo đặc tả (403 → TERMINAL bỏ; chuỗi `"20"` nay được nhận) · đột biến 3/3 bị bắt
  · trần thử lại: `OrderIvrDispatchService.java:110–111`, `OrderIvrRevokeDispatchService.java:69–70`, `maxAttempts` 5 (1..20) · không adapter khác gọi lối Order Core/nội bộ M8
  · CẦN QUYẾT (nhánh chú, chưa gộp): `OrderIvrRecallService` dùng lại `revoke()` chỉ có trần thời gian 1 giờ, không trần số lần → coder đề xuất A giữ nguyên. Giao verifier.
- 16/11 22:0x verifier: ĐẠT (chờ bộ đủ) · phạm vi đúng 5 tệp, diff khớp patch · đối chiếu hợp đồng M8 (yaml:1614, `06-error-codes.md:10,14,37`) · lệnh mục 5 chạy lại 120/0/0/0
  · đột biến khác coder 3/3 bị bắt (chuỗi `"0"` → 1 s; submit 403 xoá token lấy lại; revoke 403 không xoá) · 3 assertion cũ đổi (không phải 2), đều theo đặc tả · đồng ý A cho `OrderIvrRecallService`
  · góp ý: docs 01:132 tách mã M3/M8 cho 401 (phiên chính sửa khi áp); mock token cùng giá trị; revoke chưa test "không xoá token" cho 404/409/200 (không chặn).
- 16/11 22:1x phiên chính áp patch + sửa câu 01:132 → commit `b6f0a056e` + tracking `4b257b7e9` trên `toandeptrai` (chưa push); Sheet M3-023 log (Đang làm, commit `b6f0a056e`).
  Bộ đủ vùng: `_wt/m34/kiem-f1f2` @ `b6f0a056e`, `ivr.**`, `order.**`, `ModuleBoundaryArchitectureTest` (ci-unit, có Postgres) — log `C:\Projects\_wt\m34\kiem-f1f2-bodu.log`.

- 16/11 22:1x bộ đủ vùng @ `b6f0a056e`: 2798 ca, đỏ 6 = 4 đỏ sẵn (`ModuleBoundaryArchitectureTest` ×3, `CommissionTemporaryRuleTripwireTest`) + 2 `CommissionFloorReferrerCheckoutPostgresTest` (chạy riêng trên gốc `d3d91686d`: đỏ y hệt → đỏ sẵn từ dev, ghi bàn giao Phúc mục 7). Không thêm ca đỏ → ĐẠT. Worktree `ivr-client-f1f2`, `kiem-f1f2` gỡ.

- 17/11 08:12 vào `dev` qua PR #163 (`3627ce4f0`); CI trên `4b257b7e9` và `d1039f46f`: 22 ca đỏ sẵn, không thêm. Đã báo M8.

## Bước kế tiếp chính xác
Xong. Lên .99 cùng lượt deploy chiều 17/11 (`wp/deploy-m4-99-sep-test.md`).

## Còn lại / CẦN QUYẾT
- (trống)
