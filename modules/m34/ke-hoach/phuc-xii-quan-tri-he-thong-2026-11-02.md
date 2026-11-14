# Phúc — đóng mảng XII "Quản trị hệ thống" (M3, business-platform)

Bản 2 · 02/11/2026 16:05 (+07) · lập theo lệnh Lead · nguồn: báo cáo hiện trạng nghiệp vụ 31/10 (mục XII) đối chiếu mã bằng 4 scout,
kiểm chéo bằng 2 reviewer độc lập (mã thật; độ phủ/ước lượng) — đã sửa 5 lỗi CHẶN và các mục NÊN SỬA.
Người làm: **Trương Công Phúc** · nền: `origin/PhucApu` `09304d56a` (đã có M3-024 dọn menu, V259 bảng hạng) · Sheet tab M3, giai đoạn
`XII Quản trị hệ thống`. Đường dẫn: `BE` = `back-end/src/main/java/com/ginsengfood/project`, `FE` = `front-end/src`,
`TDL` = `docs/docs-ginsengfood-project/to-do-list`.

## 1. Đích đến

Xong 21 task thì mọi dòng "Còn thiếu"/"Đang chờ" của XII.1–XII.7 hoặc có mã + test + phiếu UAT, hoặc có quyết định ghi rõ "ngoài phạm
vi". Mốc: phần lõi BE (xác thực, phân quyền, duyệt, break-glass, legal hold) xong **06/11**; màn hình xong **09/11**; nghiệm thu kỹ thuật
+ phiếu UAT **10/11**; chủ dự án nghiệm thu trước **12/11** (mốc C). Không kịp đóng cả mảng ở mốc A 07/11 — nói thẳng ở đây.

## 2. Bảng phủ "Còn thiếu" → task

| Mục | Còn thiếu (đã kiểm trong mã) | Task |
|---|---|---|
| XII.1 | không tự khoá sau 5 lần sai (`AuthServiceImpl.java:304-365` ghi lần sai, không đếm/khoá) | XII-01 |
| XII.1 | không giới hạn tần suất theo IP/thiết bị (D32); mã thiết bị lấy từ header client, IP sau proxy chưa tin cậy | XII-01B (chờ hạ tầng) |
| XII.1 | nhân viên không tự đổi mật khẩu (`/api/v1/me/password` chỉ cho khách); `forcePasswordChange` đặt khi tạo nhân viên nhưng không ai đọc | XII-02 |
| XII.1 | không có quên mật khẩu nhân viên (reset chỉ nhận `CUSTOMER`, `AuthServiceImpl.java:1006-1031`); spec `TDL/p0-39-…` | XII-03 |
| XII.1 | không có "Thiết bị đang đăng nhập" (spec `TDL/p0-41-…`, OD-01..04) | XII-04 |
| XII.1 | 2FA | ngoài phạm vi tới 15/11 — D-m34-010 (2) |
| XII.1–2 | P0-39/40/41 chờ "Flow 4 đóng": UAT P0-38 còn 27 ô; trạng thái spec còn `PENDING_OWNER_…` | XII-00 |
| XII.2 | tạo/khoá/mở khoá không audit, không sự kiện; gán vai trò không phát `ROLE_*`; mở khoá chính mình không bị chặn (D31); khoá không thu hồi phiên | XII-05 |
| XII.2 | SUPER_ADMIN không bắt duyệt hai người (`approvalRequestId` không qua `requireApproved`); chưa chặn tự gán; sửa quyền của vai trò SUPER_ADMIN cũng là đường nâng quyền | XII-06 |
| XII.2 | menu không lọc theo quyền (spec `TDL/p0-40-…`, AAH-D63 đã chốt) | XII-07 |
| XII.3 | không có hộp duyệt (không API liệt kê `approval_requests`; M3-024 đã gỡ màn chờ) | XII-08 |
| XII.3 | màn nhật ký thao tác: API danh sách **đã có** (`/api/v1/admin/governance/evidence`), FE chưa nối | XII-09 |
| XII.3 | không có màn chính sách dùng chung; BE **không chặn tự duyệt** (`PolicyAdminServiceImpl.review` `:488-545`) | XII-10 |
| XII.4 | break-glass không có API danh sách/chi tiết, không màn (M3-024 đã gỡ màn chờ); hạn hậu kiểm tính ngày lịch thay vì ngày làm việc; thiếu test nhánh chặn khi quá hạn | XII-11A, XII-11B |
| XII.3 | legal hold chỉ có bảng `legal_audit_holds` (V33); retention khách không tôn trọng hold | XII-12A, XII-12B |
| XII.5 | đường upload chung gán cứng `SKIPPED` (`UploadFileServiceImpl.java:205`) | XII-13 (+ clamd production: phiên `lead`) |
| XII.5 | chỉ lưu đĩa | XII-14 (adapter; chạy thật vẫn lưu đĩa tới 15/11 — m34.13) |
| XII.7 | không có màn sổ sự kiện/nhật ký sự kiện/outbox (M3-024 đã gỡ mục menu); outbox CRM dùng mã quyền `crm.outbox.view` sai mẫu → luôn 403 | XII-15 |
| XII.6 + tài liệu | TTL cache cứng 7 mảng, chưa có bảng chính sách; INDEX lệch mã; câu "máy chủ chưa có danh sách nhật ký" trong báo cáo sai | XII-16 |
| Nghiệm thu | phiếu H03/H04 upload `OWNER_UAT_PENDING`; task mới chưa phiếu; chưa gộp `dev`/lên môi trường UAT | XII-17 |
| Màn chờ IAM khác | tài khoản hệ thống, chính sách bảo mật IAM, phiên toàn hệ thống: M3-024 đã gỡ khỏi menu | ngoài phạm vi tới 15/11 |

## 3. Cách chạy: song song nhiều agent, kiểm chéo

**Một phiên điều phối của Phúc cho mỗi sóng** trên checkout `PhucApu` (sạch, đã push, gồm M3-025 UI-kit v2 nếu giữ):
- giao 2–3 subagent mỗi task cùng lúc: `coder-BE`, `coder-FE`, `tester` độc lập (R3: viết test trước, đỏ đúng chỗ thiếu);
  `verifier` chạy **sau** coder: chạy lại từ đầu, đối chiếu tiêu chí, thử đột biến, rà diff. Tối đa **6 agent nặng cùng lúc** mỗi sóng.
- coder sửa tệp tách nhau trên checkout chung, **không** chạy Maven/npm build ở đó khi coder khác còn sửa; tester/verifier chạy trong
  worktree tách rời `git worktree add --detach ../_wt/xii-<task> <SHA>`, mỗi worktree thư mục build riêng, xoá sau khi xong.
- **tệp nóng chỉ phiên điều phối sửa:** đầu sóng — seed mã quyền mới (`BE/seed/RbacDataSeeder.java`), `permitAll`/cổng route mới
  (`BE/security/SecurityConfig.java`), mã sự kiện (`EventRegistryDataSeeder.java`), `back-end/pom.xml`, `application*.yml`;
  cuối sóng — sinh lại `contracts/openapi/latest.json` + `contracts/api-snapshots/*` (P0-39/P0-41 theo khuôn promotion P0-31R),
  thêm dòng `leaf` vào `FE/app/admin/components/AdminSidebar.tsx` (+ test), commit theo đường dẫn từng task, push `PhucApu`, ghi Sheet `--id`.
- **migration:** hạn chế; cần thì đặt số **ngay trước khi gộp `dev`** = số lớn nhất trên mọi nhánh origin + 1, chạy `uniq -d`. Hiện: `dev`
  V258, `PhucApu` V259 (bảng hạng), M3→M8 giữ V260–V261 chưa commit (đã đổi số khỏi V259).
- **cổng gộp:** task R3 chỉ gộp `dev` khi Sheet "Lead duyệt" = Đạt (Lead rà theo SHA đã push). Mã chưa push thì không rà.
- **429:** bỏ theo thứ tự XII-14 → XII-12B → XII-04 phần cửa hàng → XII-15 phần outbox.

**Luồng ghi (cột "Luồng"):** cùng luồng chạy nối tiếp. AUTH = `AuthServiceImpl`/`AdminAuthController` (01 → 03 → 04) · ME (02) ·
RBAC (05 → 06; 01 dùng bộ phát sự kiện của 05) · GOV = `policy/` (08 → 12A → 12B; 10 sửa nhỏ `PolicyAdminServiceImpl`) · BG (11A → 11B) ·
FE (09) · NAV (07) · EVT (15) · UPL (13 → 14) · DOC (16) · UAT (00, 17).

### Lịch sóng

| Sóng | Ngày | Task | Giờ máy (task dài nhất) |
|---|---|---|---|
| 1 | T3 03/11 | XII-00 · XII-05 · XII-09 · XII-16 (tài liệu) | 4,5 |
| 2 | T4 04/11 | XII-01 · XII-02 · XII-15 | 6,5 |
| 3 | T5 05/11 | XII-03 · XII-06 · XII-08 | 6,5 |
| 4 | T6 06/11 | XII-04 · XII-11A · XII-12A | 6 |
| 5 | T7 07/11 | XII-07 · XII-10 · XII-11B | 5,5 |
| 6 | T2 09/11 | XII-12B · XII-13 | 5 |
| 7 | T3 10/11 | XII-17 · XII-14 (P2, không chặn XII-17) | 6 |
| khi gỡ chặn | — | XII-01B | 3,5 |

### Cách ước lượng (tính đến AI đa luồng)

- **Người:** giờ công viết tay, theo cỡ scout đo trên mã (S ≤ 4h, M 4–8h, L > 8h).
- **Giờ máy** (cột ước lượng trên Sheet): giờ đồng hồ của task khi chạy song song = làn coder dài nhất (nhanh khoảng 2,5–3 lần người với
  việc có mẫu sẵn, khoảng 2 lần với bảo mật/nhiều trạng thái) + tester + verifier + **một vòng sửa** + Phúc rà diff.
- **Phúc trực tiếp:** giờ Phúc phải ngồi (viết brief từ phiếu, rà diff, thử tay, commit/push, Sheet) — nguồn khan nhất.
- Tổng 21 task: **người ≈ 214h (~27 ngày công)** · **giờ máy cộng dồn ≈ 100h** · chạy theo sóng **≈ 40h + ghép tệp nóng/OpenAPI ~5h
  = 45h ≈ 6,5 ngày làm việc (03–10/11)** → nhanh khoảng 4,8 lần so với một người viết tay · **Phúc trực tiếp ≈ 33h** (gồm ~5h ghép).
- Chưa gồm: **Lead duyệt 11 diff R3 (~8h, 04–10/11)**, chủ dự án UAT (~5h: P0-38, H03/H04, phiếu mới), vòng sửa thứ hai của R3.
- Sức Phúc 03–10/11 khoảng 36h nếu dành ~6h/ngày → dùng ~90%, **không còn đệm**; phải dừng lô giao diện M3-022/M3-026 (m34.14).

## 4. Phiếu từng task

Chung: owner Trương Công Phúc · nhánh `PhucApu` · nguồn "Kế hoạch". Lệnh: BE `./mvnw -B -fae test -P ci-unit`, Postgres `-P ci-integration`
(Docker); FE `npm run lint`, `npm run test:run`, `npm run build`; E2E thật `npm run test:e2e:real`. Màn mới: tự khai báo quyền theo khuôn của
XII-07 (`AccessDeniedState`, dòng menu có mã quyền).

**XII-00 · Đóng Flow 4, mở khoá P0-39/40/41** · UAT · R1 · P0 · 03/11 · người 4h / máy 2h / Phúc 1h (+ chủ dự án ~1h)
- Đích: (a) bằng chứng E2E mới cho 27 ô `TDL/uat/p0-38-auth-surface-coverage-uat-closure.md` + buổi UAT 30 phút đã hẹn với người tick
  (m34.14); (b) xác nhận "Flow 4 bước 6" xong và bàn giao `AuthServiceImpl`/`AdminAuthController`; (c) sửa Status p0-39/40/41 thành đã duyệt,
  ghi OD-01..04 = A và phần sửa AAH-D58 theo D-m34-010 (thêm dòng AAH-D68 soạn sẵn ở §5) — để coder không dừng theo stop rule (`p0-41:255`, `p0-39:230`).
- Song song: agent A rà INDEX/evidence Flow 4 · agent B chạy `test:e2e:real:doctor` + E2E hai phiên · verifier đối chiếu 27 ô.

**XII-01 · Khoá tài khoản sau 5 lần sai mật khẩu** · AUTH · R3 · P0 · 04/11 · 10h / 6,5h / 1,5h · phụ thuộc XII-00, XII-05
- Đích: đếm theo `user_id` (index sẵn `idx_auth_login_attempts_user_created`), 5 lần sai/15 phút → khoá 15 phút (D13); báo trung tính
  (D33) và **gửi báo riêng khi khoá** (mail công việc theo D-m34-010 (3)); sai bề mặt **không** đếm (D30) nhưng giữ thứ tự phản hồi D67 — sai
  mật khẩu ở trang khách không khoá được tài khoản INTERNAL; ghi lần thử/khoá không bị rollback (thêm `noRollbackFor` hoặc `REQUIRES_NEW`,
  hiện chỉ có cho `SurfaceUnauthorizedException`, `AuthServiceImpl.java:275`); phát `USER_LOCKED` nguồn SYSTEM qua bộ phát của XII-05.
  Chọn một nguồn ngưỡng (`AUTH_LOCK_POLICY` hiện có ở `:107` hoặc `auth.lockout.*`).
- Song song: tester viết test Postgres trước (5 sai → khoá; 4 sai + đúng → mở; hết 15 phút → vào lại; sai ở trang khách không khoá; 5 yêu cầu
  đồng thời) · coder-BE · verifier đột biến (5→6, bỏ cửa sổ 15 phút → đỏ).

**XII-01B · Giới hạn tần suất đăng nhập theo IP/thiết bị (D32)** · AUTH · R3 · P1 · **Bị chặn** · 6h / 3,5h / 1h
- Chặn bởi: IP thật sau proxy (`forward-headers-strategy` chưa đặt, sau proxy mọi người chung IP) và mã thiết bị do máy chủ cấp (hiện lấy
  header `X-Device-Id` của client) — quyết hạ tầng ở phiên `lead`/`deploy` (m34.15). Cổng cũ `/api/v1/auth/login` vẫn tin `X-Forwarded-For`.
- Đích khi gỡ chặn: 10 lần/thiết bị, 30 lần/IP tin cậy trong 15 phút, chặn nguồn 15 phút, 429, cấu hình được; migration index nếu cần.

**XII-02 · Nhân viên tự đổi mật khẩu + bắt đổi mật khẩu tạm** · ME · R3 · P0 · 04/11 · 14h / 6h / 1,5h
- Đích: `PUT /api/v1/admin/me/password` (dưới `/api/v1/admin/**`, **không** mở `/me/password` cho ADMIN — trái `SecurityConfig.java:313-318`);
  tái dùng `ChangeMyPasswordService`; mật khẩu admin theo D46 (độ dài tối thiểu riêng, hiện `@Size(min=8)` của khách); sai mật khẩu cũ
  5 lần/15 phút → 429; đổi xong thu hồi **mọi phiên ADMIN khác, giữ phiên hiện tại** — viết hàm mới trong `SessionRevocationService`
  (thu hồi theo user + bề mặt, trừ phiên có `accessTokenJti` hiện tại; XII-04 dùng lại); mail báo cho INTERNAL theo D-m34-010 (3); đăng nhập
  với `forcePasswordChange=true` bị dẫn tới màn đổi mật khẩu. FE: khu "Tài khoản của tôi" `app/admin/account/…`.
- Song song: tester (Postgres + Vitest, khách vẫn chạy như cũ, `DualBrowserSurfaceGuardTest` xanh) · coder-BE · coder-FE · verifier.

**XII-03 · Quên mật khẩu nhân viên (P0-39, AAH-D58)** · AUTH · R3 · P0 · 05/11 · 14h / 6,5h / 2h · phụ thuộc XII-00, XII-01
- Đích: làm đủ P0-39 cả hai nhánh (Storefront mở cho `PARTNER` theo D43; Admin cho `INTERNAL` chỉ qua email công việc, không SMS — D45,
  D58); cơ chế OTP qua email công việc (D-m34-010 (4)); mật khẩu mới theo D46 (phần "đã rò rỉ" ngoài phạm vi vì cấm nhà cung cấp mới); đặt lại xong thu hồi mọi
  phiên; phản hồi trung tính; liên kết "Quên mật khẩu" ở `/admin/login` (nhận nửa FE từ P0-34). Route `/api/v1/auth/admin/reset-password/*`
  được phiên điều phối thêm `permitAll` **đầu sóng 3**; OpenAPI theo khuôn P0-31R, chứng minh mục ngoài nhánh Admin không đổi.
- Song song: tester · coder-BE · coder-FE (sau khi route vào hợp đồng, có thể trượt cuối sóng) · verifier.

**XII-04 · Màn "Thiết bị đang đăng nhập" tự phục vụ (P0-41)** · AUTH · R3 · P1 · 06/11 · 14h / 6h / 2h · phụ thuộc XII-02, XII-03
- Đích: trong "Tài khoản của tôi" (admin) và tài khoản khách: xem phiên của chính mình, IP che một phần, "Thiết bị này" không thu hồi được,
  thu hồi từng phiên, "Đăng xuất khỏi tất cả thiết bị khác"; mỗi bề mặt chỉ thấy phiên của nó (D64). Không làm màn xem phiên người khác.
- Song song: coder-BE (API list/revoke/revoke-others, dùng hàm của XII-02) · coder-FE (hai bề mặt) · tester (không thu hồi chéo bề mặt) · verifier.

**XII-05 · Audit + sự kiện cho tài khoản nhân viên và vai trò** · RBAC · R3 · P0 · 03/11 · 8h / 4,5h / 1,5h
- Đích: tạo/khoá/mở khoá ghi `config_audit_logs` (`RbacRuntimeAuditWriter`) + security event; viết **một bộ phát sự kiện identity có tham số
  nguồn** (ADMIN/SYSTEM; mẫu `BreakGlassEventPublisher` gán cứng ADMIN) phát `USER_LOCKED`/`USER_UNLOCKED`; `ROLE_ASSIGNED`/`ROLE_REVOKED`
  tính theo **chênh lệch trước/sau** của `assignUserRoles` (xoá hết rồi tạo lại, `:172-182`); chặn tự mở khoá (D31); khoá thì thu hồi phiên
  đang mở; tạo nhân viên chỉ audit (D-m34-010 (6)). Luồng 01 dòng 611, 643-646, 671, 791.
- Song song: tester (`ci-integration`: rollback thì không audit/sự kiện; gán lại đúng tập cũ thì không phát) · coder-BE · verifier.

**XII-06 · Duyệt hai người cho SUPER_ADMIN** · RBAC · R3 · P0 · 05/11 · 12h / 6,5h / 1,5h · phụ thuộc XII-05
- Đích: thay đổi vai trò có SUPER_ADMIN (cấp/gỡ) và sửa quyền của vai trò SUPER_ADMIN (`PUT /roles/{id}/permissions`) tạo `approval_request`;
  phiếu **ràng với loại + người đích + tập vai trò** (hiện `requireApproved` chỉ kiểm trạng thái/hạn, `DualApprovalServiceImpl.java:110-120`);
  người yêu cầu không tự duyệt; duyệt xong **thực thi ngay trong cùng giao dịch** (như break-glass); tự gán SUPER_ADMIN → 403 + audit
  (luồng 01 dòng 749, 762, 860); mã quyền duyệt mới seed đầu sóng. FE: màn nhân viên hiện "Chờ duyệt" + link sang hộp duyệt (XII-08).
- Song song: tester (phiếu khác loại/người → 409; từ chối thì không đổi) · coder-BE · verifier.

**XII-07 · Lọc menu và màn quản trị theo quyền (P0-40, AAH-D63)** · NAV · R2 · P1 · 07/11 · 14h / 5,5h / 1,5h · phụ thuộc XII-00, M3-024
- Đích: đầu ra bắt buộc là **bảng ánh xạ mọi ô menu → mã quyền** và **danh sách màn thiếu `AccessDeniedState`** (spec đếm 41 trên `dev`,
  đếm lại trên `PhucApu` sau M3-024); menu lọc theo `effectivePermissionCodes` của `GET /api/v1/me/access`, nhóm rỗng ẩn, trạng thái rỗng rõ;
  Vitest theo từng vai trò mẫu. API thiếu kiểm quyền máy chủ → dừng, báo Lead. Màn mới của sóng 5–6 tự khai báo theo khuôn này.
- Song song: coder-FE menu · coder-FE quét màn từ chối · tester · verifier.

**XII-08 · Hộp duyệt chung** · GOV · R3 · P1 · 05/11 · 12h / 5h / 1,5h
- Đích: `GET /api/v1/admin/governance/approvals` (phân trang, lọc trạng thái/loại/người yêu cầu, che dữ liệu, mã quyền xem mới); màn
  `app/admin/iam/approvals` + dòng menu; **một thành phần duyệt dùng chung**, gọi đúng endpoint theo bảng: `BREAK_GLASS` →
  `PUT /admin/break-glass/requests/{id}/approve|reject` (mở phiên khi duyệt) · `SENSITIVE_EXPORT` → `PUT /admin/governance/evidence/export/{id}/…` ·
  `MEMBERSHIP_BENEFIT_COMMAND` → `POST /admin/membership/members/benefit-approval-requests/{id}/…` · `POLICY_CHANGE` → `PUT /admin/policy/versions/{id}/…`
  · SUPER_ADMIN (XII-06) · `LEGAL_HOLD` (XII-12A thêm). Duyệt định danh khách (`CustomerIdentityReviewServiceImpl`) ngoài phạm vi.
- Song song: coder-BE · coder-FE · tester · verifier.

**XII-09 · Màn nhật ký thao tác** · FE · R2 · P1 · 03/11 · 7h / 3h / 1h
- Đích: `app/admin/governance/audit-logs` nối `GET /api/v1/admin/governance/evidence` (gộp `audit_logs`, `config_audit_logs`, `system_events`,
  `event_packages`) + chi tiết `/audit-logs/{id}`; lọc đối tượng/mã sự kiện/người làm/thời gian/correlationId; xem dữ liệu gốc cần quyền
  `CONTENT_VIEW` + hộp nhập lý do và `ticketRef`/`incidentId`. Không sửa BE.
- Song song: coder-FE · tester Vitest + E2E giả lập · verifier.

**XII-10 · Màn chính sách dùng chung + chặn tự duyệt** · GOV · R3 · P1 · 07/11 · 14h / 5,5h / 1,5h · phụ thuộc XII-08
- Đích: BE `PolicyAdminServiceImpl.review` từ chối khi người duyệt = `requestedBy`/`submittedBy` (test); màn danh sách/chi tiết/tạo cho
  `/api/v1/admin/policy/versions` đủ vòng đời (submit/approve/reject/publish/cancel/supersede/expire), xử lý loại bị `rejectOwnerScopedWrite`
  chặn (`AdminPolicyController.java:149`); dòng menu.
- Song song: coder-BE nhỏ + tester · coder-FE danh sách · coder-FE vòng đời · verifier.

**XII-11A · Break-glass máy chủ: danh sách, chi tiết, hạn hậu kiểm** · BG · R3 · P1 · 06/11 · 9h / 4,5h / 1,5h
- Đích: `GET` danh sách/chi tiết yêu cầu và phiên (kèm duyệt, thao tác), mã quyền xem mới; hạn hậu kiểm "1 ngày làm việc" T2–T6, chưa trừ lễ (D-m34-010 (7))
  (hiện `plus(1, DAYS)`, `BreakGlassServiceImpl.java:152, 494`); test nhánh chặn mở phiên mới khi quá hạn (`ensureNoOverdueBlocker` `:903`),
  xin quyền, chặn tự duyệt, tự hết hạn, kết thúc, rà soát (luồng 09 dòng 293-306, 416).
- Song song: tester · coder-BE · verifier.

**XII-11B · Break-glass màn hình** · BG · R2 · P1 · 07/11 · 10h / 4h / 1h · phụ thuộc XII-11A, XII-08
- Đích: `app/admin/iam/break-glass` + dòng menu: danh sách, xin quyền, phiên, kết thúc, rà soát sau sự cố; duyệt dùng thành phần của XII-08.
- Song song: coder-FE · tester · verifier.

**XII-12A · Legal hold máy chủ** · GOV · R3 · P1 · 06/11 · 12h / 6h / 1,5h · phụ thuộc XII-08
- Đích: entity/repo/service tạo → duyệt (`approval_requests` loại `LEGAL_HOLD`) → rà định kỳ → nhả; job đánh dấu quá hạn rà; endpoint + quyền +
  audit; `ConsentPrivacyRetentionService.scrubExpiredGuestRawPii` và `GuestContact` **bỏ qua bản ghi đang bị hold**; hold không cấp quyền xem
  dữ liệu gốc (luồng 09 dòng 237-241, 397). Lịch chạy tự xoá dữ liệu khách là việc của I.4, không thuộc XII.
- Song song: tester (scrub bỏ qua hold, nhả thì scrub chạy) · coder-BE · verifier.

**XII-12B · Legal hold màn hình** · GOV · R2 · P2 · 09/11 · 6h / 2,5h / 0,5h · phụ thuộc XII-12A
- Đích: danh sách, tạo, nhả hold; duyệt qua hộp duyệt.

**XII-13 · Quét virus cho đường upload chung** · UPL · R2 · P1 · 09/11 · 7h / 5h / 1h
- Đích: liệt kê mọi nơi gọi `UploadFileServiceImpl`; bỏ gán cứng `SKIPPED` (`:205`), đi qua `ContentMediaScannerPort` (ClamAV) cho loại tệp
  phải quét; tệp nhiễm bị từ chối + audit; staging bật `require-clean` (clamd có ở `deploy/compose.lan.yml`), tệp EICAR bị chặn trên staging.
  **Bật ở production là việc deploy** (phiên `lead`, đã báo qua hộp thư), không nằm trong task.
- Song song: tester (EICAR; scanner hỏng + require-clean → chặn) · coder-BE · verifier.

**XII-14 · Adapter lưu tệp kiểu S3** · UPL · R2 · P2 · 10/11 · 14h / 6h / 1,5h · phụ thuộc XII-13, m34.13
- Đích: adapter S3-compatible cho `FileStoragePort`, `ContentMediaStoragePort`, `GeneratedArtifactStoragePort`; cờ chọn adapter, mặc định đĩa;
  link tải có hạn cắm vào `POST /api/v1/admin/files/{id}/download-url` sẵn có; test MinIO Testcontainers; thêm thư viện vào `pom.xml` (phiên
  điều phối). Chạy thật vẫn lưu đĩa tới 15/11; không cắm khoá thật. Task bỏ đầu tiên khi thiếu lượt AI.

**XII-15 · Màn sổ đăng ký sự kiện, nhật ký sự kiện, giám sát outbox** · EVT · R2 · P1 · 04/11 · 12h / 4,5h / 1h
- Đích: màn + dòng menu cho `GET/POST/PUT /api/v1/admin/event/registry` (bật/tắt, sửa; mã không đổi sau tạo; tester kiểm quyền bật/tắt vì ảnh
  hưởng hoa hồng), `GET /api/v1/admin/event/audit`, `GET /api/v1/admin/outbox/crm`; BE thêm 5 trường vào response (`externalSendPolicy`,
  `dataSensitivity`, `attributionChannel`, `payloadContractVersion`, `requiredFieldsJson`) và đổi mã quyền outbox `crm.outbox.view` →
  `GOVERNANCE.OUTBOX.VIEW` (đã seed); E2E dùng mã sự kiện ngoài baseline (seeder ghi đè baseline mỗi lần khởi động).
- Song song: coder-BE nhỏ · coder-FE · tester · verifier.

**XII-16 · Chính sách cache + sửa tài liệu theo dõi XII** · DOC · R1 · P2 · 03/11 · 5h / 2h / 0,5h
- Đích: bảng chính sách cache 7 mảng (policy, TTL, evict, failureMode — B2 `redis-cache`); cập nhật trạng thái (không thêm mục) ở INDEX
  `platform-foundation` (P0-39/40/41, Flow 4), `upload` (H03/H04), `life-sse` (gắn nhãn lịch sử các dòng BLOCKED/DEFERRED cũ); ghi chú sửa câu
  báo cáo "máy chủ chưa có danh sách nhật ký".
- Song song: 3 agent tài liệu theo từng INDEX · verifier đối chiếu mã.

**XII-17 · Nghiệm thu kỹ thuật XII, gộp, lên môi trường UAT** · UAT · R1 · P0 · 10/11 · 10h / 5h / 2,5h · phụ thuộc XII-00..16 trừ XII-14
- Đích: chạy lại BE ci-unit + ci-integration, FE lint/test/build, E2E thật các màn mới trên `PhucApu`; mọi task R3 có "Lead duyệt" = Đạt;
  gộp `dev` (theo quy ước Lead chốt ở m34.2); nhờ phiên `lead` đưa lên staging; phiếu UAT XII-01..15 + H03/H04 sẵn; báo cáo hiện trạng XII
  cập nhật đúng mã; chủ dự án tick trước 12/11.
- Song song: agent chạy BE · agent chạy FE/E2E · agent soạn phiếu · verifier.

## 5. Cần Lead quyết (tiếp số `TRANG_THAI.md`)

- **m34.12 — đã chốt D-m34-010 (02/11 17:32, "ok 12, cả gói"):** (1) Lead duyệt task P0-39/40/41 thay chủ dự án; (2) 2FA ngoài
  phạm vi tới 15/11, quên mật khẩu nhân viên tạm **không** bắt Authenticator sau đặt lại (sửa tạm AAH-D58), bù bằng thu hồi mọi phiên + mail báo;
  (3) email do admin nhập khi tạo nhân viên = email công việc đã xác minh; (4) quên mật khẩu dùng **mã OTP qua email công việc** như luồng
  khách, thay "liên kết" của D58; (5) OD-01..04 = A; (6) tạo nhân viên chỉ ghi audit, không thêm mã sự kiện; (7) hạn hậu kiểm break-glass =
  1 ngày làm việc T2–T6, chưa trừ lễ; (8) legal hold máy chủ trước 15/11, màn hình 09/11; (9) task R3 của Phúc chỉ gộp `dev` khi Sheet
  "Lead duyệt" = Đạt.
  Dòng soạn sẵn cho sổ `TDL/admin-authentication-hardening-decision-log.md` (bảng `| ID | Quyết định / định hướng | Trạng thái |`, số kế tiếp
  AAH-D68), ghi trong XII-00 trên `PhucApu`:
  `| AAH-D68 | Tạm thời tới khi có MFA (AAH-D08): đặt lại mật khẩu quản trị theo AAH-D58 dùng mã OTP gửi **chỉ** qua email công việc, không
  bắt xác minh Authenticator sau đặt lại; bù bằng thu hồi mọi phiên và mail báo. Email do quản trị nhập khi tạo tài khoản `INTERNAL` được coi là
  email công việc đã xác minh. Sửa một phần AAH-D58. Nguồn: Lead Nguyễn Quốc Toàn, 02/11/2026 (D-m34-010). | `OWNER_CONFIRMED` |`
- **m34.13** Lưu đám mây: A viết adapter S3, chạy thật vẫn lưu đĩa tới 15/11, chọn nhà cung cấp sau qua `deploy` · B hoãn, huỷ XII-14.
  Đề xuất: A. Hạn 06/11.
- **m34.14** Phúc 03–10/11: A ưu tiên XII, dừng lô giao diện M3-022/M3-026 tới 11/11, giữ M3-010 hạn 03/11 · B chia đôi (XII xong
  khoảng 13/11, nghiệm thu sau mốc C). Đề xuất: A. Kèm: ai tick UAT P0-38 (27 ô) — bạn hay Chú. Hạn 03/11.
- **m34.15** Giới hạn đăng nhập theo IP/thiết bị (XII-01B) cần IP thật qua proxy + mã thiết bị do máy chủ cấp: A phiên `lead`/Tuấn chốt trong
  `deploy` trước 07/11 · B hoãn sau 15/11, chỉ khoá theo tài khoản. Đề xuất: A. Hạn 05/11.

## 6. Mã Sheet

Đưa lên 02/11 ~16:00 bằng `sheet-sync.mjs upsert` (không ghi nhật ký tuần của Phúc), người cập nhật "Nguyễn Quốc Toàn (Claude Code)";
đọc lại đủ 21 thẻ, 0 ô lệch so với dữ liệu gửi, không trùng mã/tiêu đề. Dữ liệu gửi: bản sao trong scratchpad phiên (`xii/tasks.json`).

| Task | Sheet | Task | Sheet | Task | Sheet |
|---|---|---|---|---|---|
| XII-00 | M3-039 | XII-03 | M3-047 | XII-11B | M3-055 |
| XII-05 | M3-040 | XII-06 | M3-048 | XII-12B | M3-056 |
| XII-09 | M3-041 | XII-08 | M3-049 | XII-13 | M3-057 |
| XII-16 | M3-042 | XII-04 | M3-050 | XII-14 | M3-058 |
| XII-01 | M3-043 | XII-11A | M3-051 | XII-17 | M3-059 |
| XII-01B | M3-044 (Bị chặn) | XII-12A | M3-052 | | |
| XII-02 | M3-045 | XII-07 | M3-053 | | |
| XII-15 | M3-046 | XII-10 | M3-054 | | |

D-m34-010 (m34.12) đã sửa vào ghi chú/đích các thẻ liên quan 02/11 17:3x; m34.13–m34.15 Lead chốt thì sửa tiếp các thẻ (M3-039, 043, 044, 045, 047, 050,
051, 052, 058, 059).
