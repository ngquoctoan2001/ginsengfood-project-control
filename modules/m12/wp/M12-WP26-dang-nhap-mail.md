# M12-WP26 — Đăng nhập bằng mail công ty @ssavigroup.com + mã OTP (ops. + pwa.)

Trạng thái: CHỜ DUYỆT DIFF R3 đợt 2; Codex đã chốt các lane kiểm còn thiếu 19/11, hai tệp sửa hướng dẫn chưa stage/commit (D-m12-119: m12.144–147 A · D-m12-121: m12.148–149 A) · Rủi ro: **R3** (xác thực, công khai Internet) · Chế độ: S · Quyết định: D-m12-115 · Mốc: song song release, cờ mặc định TẮT
Phiên giữ: đợt 1 phiên m12 `local_cf1de578` (backend `58103be18` + test R3 `0399296ce` + sửa `373d41f89`, verifier R3 ĐẠT 19:40) · đợt 2 phiên m12 phụ [9199d3] (Toàn giao 20:4x, D-m12-121) · Sheet M12-114
Yêu cầu gốc: `hop-thu/m12-2026-11-18-dang-nhap-mail-cong-ty.md` (10 điểm). Khảo sát 18/11 (scout, chỉ đọc `ee99e9fd6`) tóm ở dưới.

## Hiện trạng (khảo sát)
- Một endpoint đăng nhập chung cho admin-web và PWA: `POST /api/v1/admin/auth/login` (`AuthEndpoints.cs:30-72`, `AllowAnonymous`, rate limit `AuthSensitive` 10/60 s theo IP, bộ nhớ một nút).
  Handler `AdminLoginHandler.cs` (354 dòng) đã chống dò (cùng lỗi + cùng một lần BCrypt), ghi thất bại ngoài giao dịch (`LogStateOutOfBandAsync`).
- Phiên = JWT HS256 trong cookie host-only `gf_admin_session` (+ `gf_admin_csrf`), hàng `auth_login_session`, `token_version`; JWT 60 phút, không refresh.
  `password_change_required` ⇒ chỉ cho `change-password` (đòi mật khẩu cũ), `me`, `logout`.
- Khoá: đếm `AUTH_LOGIN_FAILED` trong `audit_log` theo user, 5 lần/15 phút (`InternalAuthPolicy.cs`, `AuthLoginAuditReadService.cs`); D-m12-100 (theo IP + tài khoản) CHƯA làm.
- `auth_user.email` đã có nhưng không unique, không xác nhận, dùng chung với tài khoản NCC (đăng nhập email + mật khẩu, OD-SUP-AUTH-001), seed đã điền mail dev.
- Chưa có gửi mail (không MailKit/SmtpClient); bí mật dạng tệp có sẵn (`/run/gfops-secrets`, `ProtectedSecretFileConfiguration`), compose bị ghim nhiều test, `deploy/m12/**` là tệp nóng WP17b.
- PWA: phiên thiết bị là việc riêng (admin cấp), đăng nhập không gắn thiết bị; WP24 (phiên m12 khác) đang làm lại màn đăng nhập PWA.
- M5 (D-m5-065, M5-162): OTP 6 số, băm HMAC, hạn 600 s, dùng một lần, sai 5 lần huỷ mã; `start` luôn 202 cùng thân, `verify` sai/hết hạn/không có cùng 401;
  mỗi mail ≤ 3 gửi/15 phút, mỗi IP ≤ 10 gửi + ≤ 20 xác nhận/15 phút; chỉ OTP, thư văn bản tiếng Việt; cờ mặc định tắt; log chỉ băm mail.

## Thiết kế đề xuất (phiên m12 chốt phần kỹ thuật; phần cần Toàn ở mục Câu hỏi)
- **Dữ liệu (migration 155, ADDITIVE_SAFE):** cột mới trên `auth_user`: `work_email` (citext/lower, NULL), `work_email_status` (NONE/PENDING/VERIFIED), `work_email_verified_at`;
  unique từng phần `lower(work_email) WHERE work_email_status='VERIFIED' AND user_type='INTERNAL_USER'`. KHÔNG dùng lại cột `email` cũ (rác dev + NCC).
  Bảng `auth_email_otp` (mục đích LOGIN/LINK, băm mã HMAC, hạn, số lần thử, đã dùng, IP băm) — bộ đếm/giới hạn trong Postgres (không Redis), ghi ngoài giao dịch khi thất bại.
- **API** (dưới `/api/v1/admin/auth/login/...` để CSRF miễn như login; route vẫn map giữ hợp đồng, cờ tắt ⇒ feature filter trả 404): `login/email/start` (luôn 202 khi cờ bật), `login/email/verify` (trả đúng hình `AuthTokenResponse`, cùng cookie/phiên);
  liên kết: `profile/work-email` (tự làm, đang đăng nhập) + `users/{id}/work-email` (admin, quyền `UserManage`) ⇒ PENDING ⇒ `work-email/confirm` bằng OTP; gỡ: admin + chính mình.
- **Bảo mật:** chỉ đuôi trong danh sách cấu hình (mặc định `ssavigroup.com`); gửi mail bất đồng bộ (không lộ qua thời gian phản hồi); tài khoản không ACTIVE/INTERNAL ⇒ cùng 401;
  audit `AUTH_EMAIL_OTP_SENT`, `AUTH_EMAIL_LOGIN_SUCCESS`/`_FAILED` (mã riêng, không xoá bộ đếm sai mật khẩu), `AUTH_WORK_EMAIL_LINK_*`; log chỉ băm mail; gỡ/đổi mail ⇒ thu hồi mọi phiên (tăng `token_version`).
- **Gửi mail:** MailKit (465 TLS ngầm định + 587 STARTTLS, kiểm chứng chỉ theo tên host), `From: no-reply@ssavigroup.com`; theo yêu cầu mới 19/11 dùng mẫu C M3/M5 gồm HTML + văn bản tiếng Việt, logo CID nhúng; mật khẩu SMTP qua tệp bí mật,
  CHỈ bắt buộc khi cờ bật (cờ tắt thì compose không cần tệp ⇒ không đụng `deploy/m12/**` trong gói này; thêm mục secret ở lượt bật trên .99, sau WP17b).
- **Giao diện:** admin-web trang đăng nhập thêm "Đăng nhập bằng mail công ty" (2 bước), `/admin/account` thêm thẻ "Mail công ty" (liên kết/xác nhận/gỡ), màn Người dùng thêm cột + hộp gắn/gỡ;
  PWA thêm lối đăng nhập bằng mail (xếp với WP24 vì cùng màn đăng nhập).
- **Không đổi:** đăng nhập NCC, tài khoản dịch vụ, luồng mật khẩu, cookie host-only, CSRF hiện có.

## Câu hỏi cho Toàn
- m12.144 Chỉ OTP (cả đăng nhập lẫn xác nhận liên kết), không link? A có (như M5) · B thêm link cho bước liên kết. Đề xuất A.
- m12.145 Tham số theo M5: mã 6 số, hạn 10 phút, sai 5 lần huỷ mã; mỗi mail ≤ 3 lần gửi/15 phút, mỗi IP ≤ 10 gửi/15 phút. A theo M5 · B chỉnh. Đề xuất A.
- m12.146 Tài khoản đang bị buộc đổi mật khẩu (mới tạo) vào bằng mail: A cho vào bình thường, chỉ nhắc đổi mật khẩu khi dùng tên đăng nhập · B bắt đổi mật khẩu trước. Đề xuất A.
- m12.147 PWA phiên 60 phút ⇒ công nhân nhập mã lại mỗi giờ. Làm luôn D-m12-101 (phiên xưởng = 1 ca) trong gói này? A có · B để WP12g. Đề xuất A.

## Phân rủi ro R3
coder backend (migration + API + mail) · coder giao diện (admin-web; PWA sau khi phối hợp WP24) · tester độc lập viết bộ test chống dò/giới hạn/khoá/thu hồi trên Postgres thật · verifier · Toàn duyệt diff.
Việc tay Toàn: tạo hộp `no-reply@ssavigroup.com` (chung M5), tự dán mật khẩu SMTP lên .99 khi bật cờ.

## Đợt 2 (D-m12-121, phiên [9199d3])
- **B2 backend (R3):** m12.148 A — IP ≤ 60 gửi + ≤ 120 xác nhận / 15 phút, chính sách tốc độ riêng cho `login/email/start|verify` rộng hơn `AuthSensitive`, mail giữ ≤ 3/15 phút ·
  m12.149 A — mail ≤ 10 mã / 24 giờ, 15 lần sai / 24 giờ ⇒ khoá mail 24 giờ (start vẫn 202 cùng thân, verify cùng 401, liên kết cùng 422) · lưu giữ sự kiện ≥ 48 giờ ·
  mục thấp verifier: thư liên kết ghi tên tài khoản, sai mã liên kết có audit, test khoá chặt phép so thời gian hằng (đột biến b) ·
  API công khai `GET /api/v1/admin/auth/login/options` (luôn map, không qua cờ) báo cờ + đuôi mail cho màn đăng nhập admin và app xưởng. Migration 155 giữ nguyên bản đã push; đổi scope ở migration mới `20261119010000_EAuthEmailThrottleScopesWave2`.
- **B2 giao diện admin-web (R2 trong gói R3):** trang đăng nhập thêm lối "Đăng nhập bằng mail công ty" (2 bước, chỉ hiện khi cờ bật) · `/admin/account` thẻ "Mail công ty" (gắn → nhập mã → xong, gỡ) ·
  màn Người dùng: cột mail + trạng thái, hộp gắn/gỡ mail cho quản trị. Không đụng `components/{ui,form,layout}`, `packages/**`, app xưởng.
- **App xưởng:** chat WP28/WP24 nhận gắn lối mail vào màn đăng nhập PWA theo hợp đồng API ở mục dưới, giữ `apps/shopfloor-pwa/**`; đã xác nhận phối hợp với WP26 ngày 19/11.
- Kiểm: coder tự kiểm → tester độc lập R3 cho 148/149 → verifier R3 cả đợt → bộ kiểm đủ một lần → trình Toàn duyệt diff. Tại lúc Codex tiếp nhận 19/11, hai remote đã có `ba6f50273`; không còn đúng khi ghi "chưa push" cho bốn commit đợt 2. Bản sửa hướng dẫn UI của Codex chưa stage/commit theo lệnh mới; chưa bật cờ .99.
- Rủi ro còn lại đã biết (giữ): kẻ xấu biết mail người khác có thể đốt lượt gửi của họ (3/15 phút, 10/ngày) — chỉ làm phiền, không vào được.

## Hợp đồng API cho app xưởng (WP24 gắn lối mail; từ `4d0bc4c72`, kiểu đã sinh trong `apps/shopfloor-pwa/src/lib/api/generated/types.ts`)
- `GET /api/v1/admin/auth/login/options` — ẩn danh, luôn có (cờ tắt vẫn 200), no-store ⇒ `ApiResponse<AuthLoginOptionsResponse>` `{ data: { emailLoginEnabled, allowedEmailDomains[], codeLength, codeTtlSeconds } }`.
  Gọi khi mở màn đăng nhập; `emailLoginEnabled=false` hoặc lỗi ⇒ ẩn hẳn lối mail.
- `POST /api/v1/admin/auth/login/email/start` `{ email }` ⇒ **202** `ApiResponse<EmailLoginStartResponse>` `{ data: { message, codeLength, codeTtlSeconds } }` — thân LUÔN giống nhau
  (mail có/không có tài khoản, đang khoá, chạm trần); app tự giữ câu báo (vd "Nếu mail này đã gắn với tài khoản, mã {codeLength} số đã được gửi…"), chỉ lấy `codeLength`/`codeTtlSeconds` từ thân — KHÔNG in nguyên `message` máy chủ (luật PH-154). 400 thân sai dạng · 404 cờ tắt · 429 quá nhanh (`Retry-After`). Kiểm đuôi mail phía app trước khi gọi.
- `POST /api/v1/admin/auth/login/email/verify` `{ email, code }` ⇒ **200** `ApiResponse<AuthTokenResponse>` + cookie `gf_admin_session` + `gf_admin_csrf` y hệt `POST /login` (dùng lại đúng đường xử lý đăng nhập thành công hiện có).
  Mọi thất bại (sai mã, hết hạn, đã dùng, khoá, tài khoản khoá/vô hiệu) = cùng **401** ⇒ một câu chung "Mã không đúng hoặc đã hết hạn…"; 429 ⇒ "đợi vài phút".
  **401 của start/verify KHÔNG phải hết phiên** — bộ xử lý 401 toàn cục của app phải miễn đúng 2 đường này (admin-web làm ở `client.ts`, so khớp chính xác).
- Không cần CSRF cho 3 route trên (cùng nhóm `/login`). Phiên app xưởng qua proxy tin cậy với host `pwa.` = 600 phút (một ca, D-m12-101), gọi thẳng = 60 phút.
- Tham số: mã 6 số, hạn 600 giây, dùng một lần; mail ≤ 3 lần gửi/15 phút, ≤ 10 mã/24 giờ; 15 lần sai/24 giờ khoá mail 24 giờ; IP ≤ 60 gửi + 120 xác nhận/15 phút (D-m12-119/121).
- Liên kết mail làm ở admin-web (Hồ sơ); app xưởng chỉ cần lối đăng nhập. Không lưu mail/mã vào bộ nhớ máy, không ghi log.

## Bật trên .99 (sau khi Toàn duyệt diff + push; lượt lên .99 riêng, không trộn lượt khác)
Việc tay của Toàn (phiên không đọc, không in bí mật):
1. Tạo hộp `no-reply@ssavigroup.com` ở Mắt Bão (dùng chung M12 + M5), bật SMTP.
2. Trên .99 tự tạo 2 tệp bí mật trong thư mục bí mật của ops-core (cùng chỗ các tệp bí mật hiện có, quyền 600):
   `Auth__EmailLogin__Smtp__Password` (mật khẩu hộp no-reply) và `Auth__EmailLogin__OtpHmacKey` (chuỗi ngẫu nhiên ≥ 32 byte, KHÔNG dùng lại khoá JWT;
   vd `openssl rand -base64 48`). Phiên lên .99 chỉ kiểm tệp tồn tại + quyền, không đọc nội dung.
3. Sau khi bật: gửi thử mã tới mail của mình, kiểm thư không vào Spam (M3 từng bị với `noreply@`); vào Spam thì nhờ Mắt Bão kiểm SPF/DKIM/DMARC cho `ssavigroup.com`.
Phiên lên .99 làm (khi Toàn nói rõ cho lượt đó):
- compose `deploy/m12/**` (tệp nóng WP17b): thêm 2 mục secrets trên + biến thường `Auth__EmailLogin__Smtp__Host=pro56.emailserver.vn`, `Auth__EmailLogin__Smtp__Port=465`,
  `Auth__EmailLogin__Smtp__Security=SslOnConnect` (hoặc 587 + `StartTls`), `Auth__EmailLogin__Smtp__Username=no-reply@ssavigroup.com`.
- Migration `20261118100000_EAuthWorkEmailLogin` + `20261119010000_EAuthEmailThrottleScopesWave2` (sao lưu trước như mọi lượt có migration).
- Cờ `Auth__EmailLogin__Enabled=true` CHỈ sau khi 2 tệp bí mật có: thiếu khoá/mật khẩu thì API từ chối khởi động khi cờ bật (validator).
- Lưu ý ngay khi deploy (kể cả cờ tắt): phiên app xưởng qua proxy tin cậy với host trong `Auth:ShopfloorHosts` = 600 phút (một ca, D-m12-101);
  muốn hoãn thì đặt `Auth__Jwt__ShopfloorAccessTokenMinutes=60` (khoá `Auth:Jwt:ShopfloorAccessTokenMinutes`, host trong `Auth:ShopfloorHosts` = `pwa.ginsengfood.vn`).
- Kiểm sau bật: `GET /api/v1/admin/auth/login/options` ⇒ `emailLoginEnabled=true`; gắn mail cho một tài khoản thử ở Hồ sơ; đăng nhập bằng mã ở ops. và pwa.

## Diễn biến
- 18/11 15:5x nhận việc từ phiên lead; scout khảo sát chỉ đọc; 16:2x lập phiếu, trình m12.144–147.
- 18/11 16:19 Toàn "144-147 theo đề xuất" ⇒ D-m12-119; giao coder backend (đợt 1: migration 155 + OTP + mail + API + phiên xưởng 1 ca). Giao diện admin-web đợt 2 sau khi WP25 coder B commit (trùng UsersRolesPage); PWA xếp với WP24.
- 18/11 20:02 phiên đợt 1 chạm giới hạn tuần ⇒ agent bộ kiểm đủ chung @ `8b1d4cbde` chết giữa chừng (tiến trình test mồ côi ở `_wt/m12/kiem-bodu-1811`), không có kết quả.
- 18/11 20:4x Toàn giao phiên [9199d3] làm tiếp phần dở + "148 149 chốt theo đề xuất" ⇒ D-m12-121; mở đợt 2.
- 18/11 21:5x đợt 2: coder backend + coder giao diện ĐẠT tự kiểm ⇒ commit cục bộ `4d0bc4c72` (backend, 32 tệp) + `2c292fb82` (admin-web, 33 tệp), quét bí mật 0; Sheet M12-114 85%. Tester độc lập R3 (`_wt/m12/kiem-WP26c`) + verifier R3 (`_wt/m12/kiem-WP26d`) chạy trên `2c292fb82`.
- 18/11 22:2x Verifier R3 đợt 2 (`kiem-WP26d` @ `2c292fb82`) CẦN SỬA: Unit 260/260, SchemaSmoke 207/207, vitest 1197/1197, typecheck 0, contract:gate qua; Gov 176/177 đỏ `MethodLengthBudget` (hàm `Map` của `AuthEndpoints.cs` 262 > 250 dòng do khối `login/options`). Phần cần Postgres CHƯA CHẠY: 21:56 ổ C: về 0 MB ⇒ Docker Desktop dừng; 22:2x phiên [9199d3] `docker desktop restart`, bật lại `ginsengfood-postgres-local`. Tester độc lập đợt 2 bị dừng (hết hạn mức dùng của phiên), chưa có kết quả.
- Phát hiện quan trọng: `origin/main` = `gitlab/main` = `8b1d4cbde` (ai đó đã push, gồm migration 155 bản `373d41f89`) ⇒ KHÔNG sửa migration 155 tại chỗ nữa.

## Bước kế tiếp chính xác (Codex nhận tiếp 19/11)
1. Vòng sửa migration/route/giới hạn/UI và verifier R3 đã hoàn tất theo diễn biến bên dưới; không làm lại từ đầu. Codex đã đối chiếu migration 155 không diff so với `8b1d4cbde` và nguồn/test hiện tại. Cờ mặc định vẫn tắt.
2. Các lane kiểm còn thiếu trên `ba6f50273` đã chốt: Integration 2.088/2.088 (WorkEmail 89/89, gồm Up/Down/Up); API 650 PASS + 1 SKIP X01 cần fixture riêng; Unit 9.192 và Schema 452 đã kiểm đủ qua lượt chính + kiểm bù DB; admin Vitest 5.342/5.342, PWA 1.397/1.397, contract gate và typecheck:tests đạt. Governance đủ cũ 1.104/1.105, D2 kiểm bù đạt trên snapshot đã sửa comment của WP28. Build solution/workspace typecheck dùng raw Claude cùng SHA. Không suy thành toàn bộ HEAD ghép đã xanh.
3. WP26 chỉ sửa hai tệp sạch dialog mail Người dùng + test tương ứng để hướng dẫn nhân viên vào Hồ sơ bấm Gửi mã; kiểm snapshot riêng 10/10 xanh. WP27 giữ 7 tệp dirty giao nhau; WP28 nhận PWA mail login. **Toàn yêu cầu chưa stage/commit**; trình diff và allowlist sau khi chốt kiểm.
4. M12-114 đã đồng bộ và đọc lại 11:18 ngày 19/11: Chờ review 95%, Lead review Chưa duyệt; nhật ký thêm đúng một entry Codex. Chờ Toàn duyệt diff R3. Hai remote đã có `ba6f50273` tại lúc tiếp nhận; không ghi lại "4 commit chưa push". Deploy/SMTP thật/bật cờ/DB .99 vẫn là lượt cần quyền riêng.
5. Rủi ro còn lại ghi nhận: ai biết mail người khác có thể khoá đăng nhập bằng mail của họ 24 giờ bằng 15 lần nhập sai (mật khẩu vẫn vào được) — cùng loại "đốt lượt gửi" đã chấp nhận. Manifest rollout/rollback vẫn PARTIAL/NOT_PROVEN, chưa kiểm DB đích.

Bản rà và kết quả tiếp quản: [2026-11-19-wp26-codex-tiep-quan.md](../ra-soat/2026-11-19-wp26-codex-tiep-quan.md).
- 19/11 07:5x vòng sửa ĐẠT tự kiểm (Unit 114/114, Integration WorkEmail 62/62 gồm Up/Down/Up, Gov 103/103, SchemaSmoke 258/258, ExpandContract PASS base `8b1d4cbde`, api:sync không diff, contract:gate 0, vitest 66/66) + tester độc lập R3 đợt 2 (27 ca PG18: 25 đạt, 2 lỗi thấp `+tag` vượt trần + U+2028 trong thư ⇒ đã sửa) ⇒ commit cục bộ `a07ade986` (23 tệp: migration 155 trả về bản `8b1d4cbde` + migration mới `20261119010000_EAuthEmailThrottleScopesWave2`, tách `MapWorkEmailLoginRoutes`/`MapOwnWorkEmailRoutes`, bộ đếm theo hộp thư bỏ `+tag`, câu UI tự giữ, bộ test tester `WorkEmailIndependentR3Wave2Tests*`). Verifier R3 vòng cuối chạy ở `kiem-WP26d`.
- 19/11 09:1x verifier R3 vòng cuối ĐẠT trên `ba6f50273` (đột biến 5/5 bị giết, Integration WorkEmail 89/89, migration 155 khớp bản đã push); Sheet M12-114 Chờ review 95%; báo phiên app xưởng gắn lối mail. Bộ kiểm đủ chạy ở `kiem-WP26d`.
- 19/11 11:15 Codex hoàn tất các lane còn thiếu theo số liệu mục trên, không còn tiến trình kiểm WP26 chạy. Hai tệp dialog mail Người dùng + test sửa hướng dẫn vào Hồ sơ bấm Gửi mã, kiểm riêng 10/10 và build webpack đạt trên snapshot; chưa stage/commit theo lệnh Toàn. Dọn PostgreSQL/volume và Redis/Ryuk đúng lượt kiểm, giữ DB dùng chung. WP27/WP28 nhận các vùng khác và cổng kiểm HEAD mới; kết quả WP26 này không thay kiểm bản ghép. Phiếu và bản rà đã cập nhật, chờ Toàn duyệt diff R3; chưa có nghiệm thu SMTP/.99.
- 19/11, yêu cầu tiếp theo của Toàn: trình diff R3, đối chiếu M3/M5, lấy mẫu mail của hai module và gửi thử hộp Lead chỉ định. Đã áp mẫu C navy/vàng, HTML + plaintext, logo CID, mã liền một text node; giữ riêng chính sách OTP M12, tên tài khoản LINK được lọc rồi HTML encode. Sáu tệp backend/resource/unit mới cộng hai tệp UI cũ vẫn chưa stage/commit. Focused WorkEmail **unit 89/89**, API build **0 warning/0 error**, review MIME độc lập không blocker. 11:39 SMTP nhận **một thư thử mẫu được ghi rõ mã minh họa không dùng đăng nhập**, gửi bằng MailKit từ artifacts M12; chưa xác nhận inbox và chưa chứng minh login OTP end-to-end. Cấu hình local lưu riêng có ACL ngoài Git, không ghi bí mật vào sổ. Restart API chung bị automatic approval review chặn trước thực thi; API cũ vẫn cờ mail tắt. Đã nhờ Lead dừng riêng API5000 và chỉ tên tài khoản local để tiếp tục luồng LINK → LOGIN thật. Không đổi DB hoặc production.
- 19/11 12:5x [0e8719] tiếp quản từ Codex (dừng hẳn): Toàn "duyệt, commit 8 tệp đó đi" ⇒ 2 commit cục bộ (chưa push): `ce862d0ef` (hướng dẫn hộp gắn mail đúng thực tế: nhân viên đăng nhập → Hồ sơ → Gửi mã → nhập mã; vitest 10/10, typecheck:tests admin exit 0) và `0a038b508` (mẫu thư OTP HTML + văn bản theo mẫu M3/M5, logo CID nhúng, thư LINK ghi tên tài khoản đã lọc + mã hoá HTML, LOGIN không ghi; không đổi OTP/hạn mức/API; Unit lọc WorkEmail 89/89 trên worktree sạch ở HEAD `932b727bb` + 6 tệp; index rỗng trước commit, 8 tệp khớp hash Codex). Bốn commit đợt 2 (`4d0bc4c72`, `2c292fb82`, `a07ade986`, `ba6f50273`) đã ở `origin`/`gitlab` main. Sheet M12-114 Chờ review 95%.
- Còn mở: (1) thử luồng thật gắn mail → mã LINK → LOGIN bằng mail — cần Toàn đưa tên tài khoản gắn với hộp thử và tự bật lại API localhost; mỗi thư thật gửi tới hộp thử là một lần Toàn cho riêng; thư thử mẫu 11:39 SMTP chấp nhận, chưa xác nhận vào inbox (kiểm Spam); (2) lượt .99 riêng (mục "Bật trên .99"); (3) chữ "10 phút" trong thư viết cứng (cùng kiểu bản văn bản thuần từ đợt 1), chưa nối với hằng số `AuthWorkEmail.CodeTtlSeconds` — đổi hạn mã thì phải sửa cả hai chỗ; (4) manifest rollout PARTIAL/NOT_PROVEN, chưa kiểm DB đích .99; phiên app xưởng 600 phút có hiệu lực khi deploy kể cả cờ mail tắt.
