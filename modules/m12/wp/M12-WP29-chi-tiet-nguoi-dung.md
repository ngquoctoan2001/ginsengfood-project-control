# M12-WP29 — Trang chi tiết người dùng (admin-web, Hệ thống › Người dùng & Vai trò)

Mở 19/11 13:xx · phiên m12 [f1e7c3] · nguồn: Toàn yêu cầu 19/11 (màn `/admin/system/users-roles` tab Người dùng quá nhiều nút
trên mỗi dòng ⇒ thêm trang chi tiết; nhân viên chỉ dùng **một** mail là mail công ty, bỏ "Mail liên hệ"; nhà cung cấp giữ như cũ;
chi tiết có lịch sử đăng nhập, nhật ký thao tác, thông tin; admin sửa được thông tin như họ tên, số điện thoại).
Rủi ro **R3** (bảng `auth_user` + migration, API quản trị tài khoản, dữ liệu cá nhân). Trạng thái: **ĐANG LÀM** (D-m12-125, 19/11 13:2x: m12.174 A, m12.175 **B**, m12.176 A, m12.177 **B** — phiên này làm).

## 0. Hiện trạng (đọc mã + DB local 19/11, HEAD `0a038b508`)

- Dòng người dùng có tới **9 nút** (Gán vai trò, Gỡ vai trò, Vô hiệu hóa, Đặt lại mật khẩu, Kích hoạt lại, Mở khóa, Thu hồi tất cả phiên,
  Đổi/Gắn mail, Gỡ mail) — `UsersRolesPage.UserColumns.tsx`. Không có trang chi tiết.
- Cột "Mail liên hệ" = `auth_user.email`; cột "Mail công ty" (khi cờ bật) ghép địa chỉ + nhãn trạng thái.
- API: chỉ `GET/POST /admin/users` (danh sách chỉ phân trang, không tìm/lọc) + các lệnh POST theo `userId`. **Chưa có** `GET /admin/users/{id}`,
  **chưa có** API sửa thông tin, admin **không** xem được phiên đăng nhập của người khác (chỉ có `/auth/sessions` tự xem).
- `auth_user` có: tên đăng nhập, họ tên, `email` (mail liên hệ), loại (INTERNAL_USER / SUPPLIER_USER), trạng thái, cần đổi mật khẩu,
  mail công ty + trạng thái + `verified_at`/`pending_since`, đăng nhập gần nhất, tạo/cập nhật lúc + bởi ai. **Không có số điện thoại,
  chức danh, bộ phận.** `auth_user_role` có `assigned_at`.
- Dữ liệu sẵn có cho lịch sử: `auth_login_session` (lúc vào, hết hạn, thu hồi lúc + bởi ai, thiết bị, trình duyệt, IP) và `audit_log`
  (`AUTH_LOGIN_SUCCESS` 1.074, `AUTH_LOGOUT` 173, `AUTH_LOGIN_FAILED` 24, `AUTH_LOGIN_LOCKED_OUT` 3, `AUTH_EMAIL_LOGIN_*`, `AUTH_WORK_EMAIL_*`
  — đều gắn `actor_user_id`/`object_id` = người dùng, trừ lượt sai tên đăng nhập không tồn tại). `GET /admin/audit/logs` đã lọc được
  theo `actorId`, `entityType`/`entityId`.
- DB local: 37 nhân viên (35 có mail liên hệ, 2 có mail công ty), 3 tài khoản nhà cung cấp (đều có mail liên hệ). Danh sách đang lẫn cả hai loại.
- Mail liên hệ còn được dùng: form tạo người dùng, claim `email` trong JWT, hồ sơ `/auth/me`.

## 1. Đích (đo được)

- Danh sách: **không còn nút trên từng dòng** (theo m12.176), bấm dòng mở trang chi tiết; cột "Mail" chỉ hiện địa chỉ (nhân viên: mail công ty;
  nhà cung cấp: mail liên hệ như cũ); có ô tìm (họ tên / tên đăng nhập / mail) + lọc loại, trạng thái, vai trò.
- Trang chi tiết `/admin/system/users-roles/[userId]` đủ các tab ở §2.2, mọi thao tác quản trị hiện có chuyển vào trang này, admin sửa được
  thông tin (§2.3) có ghi nhật ký kiểm toán trước/sau.
- Nhân viên không còn "Mail liên hệ" ở bất kỳ màn nào (tạo, danh sách, chi tiết, hồ sơ); nhà cung cấp giữ nguyên.
- Đạt bộ kiểm R3 (§5), bộ dò bố cục 0 mục L1–L4 trên danh sách + chi tiết ở 1366/1920, Toàn bấm thử trên localhost.

## 2. Phạm vi

### 2.1 Danh sách (tab Người dùng)

| Cột | Nội dung |
|---|---|
| Người dùng | họ tên trên, tên đăng nhập dưới (giữ D-m12-117) |
| Loại | Nhân viên / Nhà cung cấp (mới — vì danh sách lẫn hai loại) |
| Mail | chỉ địa chỉ: nhân viên = mail công ty (chưa gắn ⇒ "—"); nhà cung cấp = mail liên hệ. Trạng thái xác nhận chỉ ở trang chi tiết |
| Vai trò | nhãn vai trò như hiện tại |
| Trạng thái | Đang hoạt động / Vô hiệu / Khóa đăng nhập đến … / Cần đổi mật khẩu (như hiện tại) |
| Đăng nhập gần nhất | giờ ngày một dòng |

- Bấm dòng (hoặc Enter) ⇒ trang chi tiết; ô Người dùng có `title` "Xem chi tiết" (bảng dùng chung chưa có title theo dòng — làm rõ 19/11). Không còn cột Thao tác.
- Thanh lọc chuẩn `FilterBar` (WP28): ô tìm + Loại + Trạng thái + Vai trò; API danh sách thêm tham số lọc (server-side, giữ phân trang).
- "Tạo người dùng": bỏ ô "Mail liên hệ"; thêm "Số điện thoại" (+ trường m12.174); khi cờ mail bật có ô "Mail công ty (tùy chọn)"
  ⇒ tạo xong gắn PENDING, nhân viên tự xác nhận ở Hồ sơ (đúng luồng WP26).

### 2.2 Trang chi tiết `/admin/system/users-roles/[userId]`

Đầu trang (`PageHeader`): "Trở về" danh sách · họ tên + tên đăng nhập · nhãn trạng thái/khóa · nút chính **Sửa thông tin** · menu
**Thao tác khác**: Gán vai trò, Gỡ vai trò, Đặt lại mật khẩu, Mở khóa, Vô hiệu hóa / Kích hoạt lại, Thu hồi tất cả phiên, Đổi / Gỡ mail công ty
(dùng lại các hộp thoại sẵn có, chỉ đổi chỗ mở). Tài khoản nhà cung cấp: chỉ xem + liên kết "Quản lý ở trang nhà cung cấp" (giữ như cũ).

| Tab | Nội dung | Nguồn |
|---|---|---|
| Thông tin | họ tên, tên đăng nhập, loại, số điện thoại (+ trường m12.174), mail công ty + **trạng thái xác nhận** (đã xác nhận lúc… / đang chờ từ… / chưa gắn), tạo lúc · bởi ai, cập nhật lúc · bởi ai, đăng nhập gần nhất | `GET /admin/users/{id}` (mới) |
| Vai trò & quyền | vai trò + ngày gán; **quyền hiệu lực** gộp từ các vai trò (đề xuất — để biết người này làm được gì) | `auth_user_role`, `auth_role` |
| Lịch sử đăng nhập | dòng thời gian: đăng nhập thành công (cách vào: mật khẩu / mail), đăng xuất, đăng nhập sai, bị khóa; các phiên đang mở (thiết bị, trình duyệt, IP che bớt, hết hạn lúc) + thu hồi phiên | `GET /admin/users/{id}/login-history` (mới) gộp `auth_login_session` + `audit_log AUTH_*` |
| Nhật ký thao tác | hai phần: **người này đã làm gì** (audit `actorId` = người này) và **thay đổi trên tài khoản này** (gán/gỡ vai trò, đặt lại mật khẩu, khóa/mở, gắn mail, sửa thông tin) | `GET /admin/audit/logs` sẵn có; cần quyền `AUDIT_VIEW`, thiếu quyền ⇒ khung "không có quyền" giữ tiêu đề |
| Thiết bị xưởng (đề xuất) | máy app xưởng đã ghép / phiên thiết bị của người này | API thiết bị di động sẵn có, lọc theo người; quyền `MOBILE_DEVICE_SESSION_VIEW` |

Đề xuất thêm ở đầu tab Thông tin: **cảnh báo** khi có ≥ 3 lần đăng nhập sai trong 24 giờ, đang bị khóa, hoặc mail công ty chờ xác nhận quá 7 ngày.

### 2.3 Sửa thông tin (admin, quyền `USER_MANAGE`)

- Hộp "Sửa thông tin" (cỡ 600, WP28): họ tên, số điện thoại (+ trường m12.174). **Không** sửa tên đăng nhập (định danh của nhật ký,
  phiếu đã ký); không sửa mail công ty ở đây (đi luồng gắn mail + OTP của WP26).
- Lưu cần lý do ngắn? — mặc định **không bắt** lý do cho sửa thông tin (khác khóa/vô hiệu), nhưng ghi nhật ký `AUTH_USER_PROFILE_UPDATED`
  có giá trị trước/sau (số điện thoại ghi dạng che bớt trong nhật ký).
- Chống ghi đè: gửi kèm `updatedAt` đã đọc; khác ⇒ 409 "Thông tin vừa được người khác sửa, tải lại rồi sửa tiếp".
- Số điện thoại: chuẩn hoá VN (bỏ khoảng trắng/chấm/gạch), `0` + 9–10 số hoặc `+84` + 9–10 số (theo hợp đồng API, làm rõ 19/11), không bắt buộc. Chỉ người có `USER_VIEW` thấy.

### 2.4 Backend (API + DB)

- Migration (một WP/sóng chạm migration — kiểm sóng trước khi chạy): `auth_user` thêm `phone_number varchar(20) null`, `job_title varchar(100) null`,
  `department varchar(100) null` (D-m12-125 / m12.174 A); **xoá mail liên hệ của nhân viên** (`UPDATE … SET email = NULL WHERE user_type = 'INTERNAL_USER'`)
  + CHECK `user_type <> 'INTERNAL_USER' OR email IS NULL` (m12.175 B). Down chỉ gỡ cột/CHECK, **không** khôi phục mail đã xoá (Toàn chốt: dữ liệu thử).
  Seed ghi `auth_user` (03, 25a, 41, 45, 47 — kiểm từng tệp) bỏ mail cho nhân viên; manifest/profile seed cập nhật. Chạy dev local + chuỗi seed ×2; `.99` là lượt riêng.
- API mới: `GET /admin/users/{userId}` · `PATCH /admin/users/{userId}/profile` (idempotency key, `If-Match`/`updatedAt`) ·
  `GET /admin/users/{userId}/login-history?page&pageSize` · `POST /admin/users/{userId}/sessions/{sessionId}/revoke` (thu hồi một phiên, lý do) ·
  `GET /admin/users` thêm `q`, `userType`, `status`, `roleCode`.
- Mail liên hệ nhân viên: không nhận ở API tạo/sửa cho INTERNAL_USER (400 nếu gửi); claim `email` trong JWT + `/auth/me` dùng **mail công ty đã
  xác nhận** cho nhân viên (chưa có ⇒ bỏ claim); nhà cung cấp giữ `email`.
- `pnpm run api:sync` (openapi + generated types) — tệp nóng, một WP/sóng.

## 3. Cần Toàn quyết

- **m12.174** thông tin nhân viên thêm: **A** số điện thoại + chức danh + bộ phận (ví dụ "Xưởng sơ chế", "Kế toán") · B chỉ số điện thoại ·
  C A + mã nhân viên + ngày vào làm. A đủ để biết "người này là ai, gọi ai"; C cần nguồn dữ liệu nhân sự chưa có.
- **m12.175** mail liên hệ cũ của 35 nhân viên: **A** ẩn khỏi mọi màn, giữ trong DB không dùng nữa; khi admin gắn mail công ty, ô gợi ý sẵn địa chỉ cũ
  nếu cùng đuôi công ty (vẫn phải xác nhận bằng mã) · B xoá hẳn dữ liệu cũ (migration, không hoàn tác) · C tự chuyển địa chỉ cũ cùng đuôi công ty
  thành mail công ty "chờ xác nhận" cho tất cả. A an toàn và vẫn đỡ gõ; B mất dữ liệu; C tự gửi mã/đổi trạng thái hàng loạt.
- **m12.176** nút trên danh sách: **A** bỏ hết, bấm dòng mở chi tiết · B giữ một menu "…" với 2 thao tác hay dùng (Mở khóa, Đặt lại mật khẩu).
- **m12.177** ai làm: **A** phiên m12 WP26 [9199d3] (đã nắm `auth_user`, mail công ty, các hộp thoại người dùng) · B phiên này [f1e7c3].

Mặc định đã chọn (không hỏi): không sửa tên đăng nhập; trang chi tiết dùng chung cho nhà cung cấp nhưng chỉ xem; nhật ký thao tác dùng API audit sẵn có;
không đổi luồng OTP/mail của WP26; không lên `.99` trong WP này.

## 4. Vùng tệp và phối hợp

| Phần | Vùng | Phối hợp |
|---|---|---|
| Backend | `Domain/Auth/AuthUser.cs`, migration mới + snapshot + inventory, `Application/Commands|Queries/Auth/**` (mới: GetUserDetail, UpdateUserProfile, ListUserLoginHistory, RevokeUserSession), `Api/Endpoints` nhóm `/admin/users`, validators, `UserMappings.cs`, `JwtTokenGenerator.cs`, test Unit/Integration/ApiContract | WP26 đã commit hết (`0a038b508`); WP26 chỉ còn lượt `.99` ⇒ không trùng |
| Frontend | `features/system/screens/UsersRolesPage.*`, mới `features/system/screens/user-detail/**`, `app/admin/system/users-roles/[userId]/page.tsx`, `lib/api/hooks/users-roles/**`, `generated/types.ts` (api:sync), test `tests/frontend/admin-web/**/users-roles*` | WP28 (phiên fork) đang sửa cổng/bundle ⇒ hỏi fork trước khi chạm `UsersRolesPage.*`; dùng component WP28 (FilterBar, PageHeader, Dialog, DataTable `activeRowId`, PageStates) |

## 5. Kiểm (R3)

- Tester độc lập viết test trước cho: quyền (không `USER_MANAGE` ⇒ 403 sửa; không `AUDIT_VIEW` ⇒ tab nhật ký khóa), chống ghi đè 409,
  không nhận mail liên hệ cho nhân viên, nhà cung cấp giữ mail, che IP/số điện thoại trong nhật ký, lịch sử đăng nhập đúng người (không lẫn người khác),
  thu hồi một phiên chỉ phiên đó, JWT claim email theo mail công ty.
- Migration Up/Down/Up trên DB dùng một lần; seed ×2; build; Unit/Integration/ApiContract lọc + bộ đủ cuối; admin vitest đủ; typecheck; lint.
- Bộ dò bố cục `tools/ui-audit` cho danh sách + chi tiết (mọi tab, hộp thoại Sửa) ở 1366/1920; verifier độc lập; Toàn duyệt diff R3 rồi mới commit.

## 6. Lịch

Duyệt m12.174–177 ⇒ ngày 1 backend (migration + 4 API + test) song song frontend danh sách/chi tiết khung ⇒ ngày 2 tab lịch sử/nhật ký + sửa thông tin
+ tester R3 ⇒ ngày 3 verifier + bộ dò + Toàn thử. Đích trước M-c 25/11.

## 7. Tiến độ

- 19/11 13:xx: khảo sát xong, mở phiếu, chờ Toàn m12.174–177.
- 19/11 13:2x Toàn chốt D-m12-125 (174 A, 175 B, 176 A, 177 B) ⇒ phiên [f1e7c3] làm: soạn hợp đồng API + brief backend/frontend, chế độ S.
- 19/11 15:xx coder FE ĐẠT (vitest 170/170, typecheck 0) · coder BE ĐẠT phần đã chạy (Unit lọc 695, Integration lọc 109, ApiContract lọc 66, SchemaSmoke 250, Governance đủ 1.125; seed ×2 DB dùng một lần) + sửa patch `deploy/seed/patches/2026-11-03-tai-khoan-that-61.sql` (chạy lại sau migration không vướng CHECK, idempotent) · tester độc lập R3: BE 31/31, FE 11/12, 5/5 đột biến đỏ. Chốt: Down chặn khi đã có dữ liệu 3 cột (đúng luật repo); title ở ô Người dùng; số điện thoại theo hợp đồng; nhãn thiết bị "tren" → "trên" (đang sửa). Lệch hợp đồng chấp nhận: 422 thay 400, JWT nhân viên không claim email.
- 19/11 19:xx verifier R3 vòng 2 ĐẠT trên worktree sạch `_wt/m12/kiem-WP29` (HEAD `3be14c8e5` + 120 tệp ứng viên, khớp từng byte): build 0 cảnh báo; Unit 9.306/9.306 (DB dùng một lần); Integration đủ 2.126/2.128 (2 ca chập chờn không do WP29: E08 WP26, Sec23 thời gian); ApiContract 663 + 1 skip cũ; SchemaSmoke 451 + 1 skip cũ; Governance 1.125/1.125; typecheck toàn repo 0; admin typecheck:tests 0, lint:strict 0 lỗi; vitest admin 5.813/5.813, public 359, PWA 1.455, ui 39; contract:gate xanh; bundle `/admin/system/users-roles/[userId]` 842,6 KiB; tester độc lập BE 31/31 + FE 12/12; đột biến 15/15 đỏ. Vòng sửa: guard GSS ở test tester, nhãn trạng thái vai trò về nguồn chung (`role_status`), câu cảnh báo, chú thích 422. Không chặn: `ClosedStatusEnumSchemaFilter.ParameterEnums.cs` dồn 4 dòng → 1 cho vừa ngân sách kích thước kiểu. Bản vá + danh sách: `ra-soat/2026-11-19-wp29/` (git bỏ qua). CHỜ Toàn duyệt diff R3 ⇒ commit theo đường dẫn; chưa push (chờ WP26 deploy-99), chưa áp migration lên DB localhost 55432, chưa .99.
- 20/11 06:1x DEPLOY .99 XONG (D-m12-126): pipeline #3090968588 main `3e84ab68b` xanh 13/13 trước deploy; `deploy-99` job 18196901044 `M12_DEPLOY_PASS` 23:09:38Z (19/11 UTC); sao lưu trước migrate `/data/sao-luu/ginsengfood-ops-core/ops-pilot/daily/ops-pilot-daily-20261119T230902Z-b22649bb.dump` (16,6 MB); .99: 157 migration (154 → 157: 2 WP26 + 1 WP29), api/admin-web/shopfloor-pwa/public-trace = `3e84ab68b` healthy, cờ mail TẮT, log API 5 phút 0 lỗi 5xx. Phiên xưởng 600 phút có hiệu lực từ lượt này. Chuỗi tới deploy: `51f6fb1b8` WP29 → `006d181af` Next 16.4.6 → `836f76d61` nhật ký → `90e48a19d` FP thứ 3 (D-m12-127) → `3e84ab68b` pin E07. CHƯA: đổi .99 sang DB sạch (chờ Toàn duyệt `wp/deploy-99-db-sach-1911.md`), Toàn bấm thử trang chi tiết.
