# Hậu kiểm gói XII của Phúc · 02/11 → 10/11 · màu VÀNG

Gói M34-RS2 (R3), phiên m34 10/11 (m34.69 A): auditor chỉ đọc, ghim `origin/dev` `e04620799` (`origin/PhucApu` `ce21d1f59` đã trong dev). Không chạy test (RAM trống 3,0–3,7 GiB, dưới ngưỡng 6 GiB).
Không ghi Sheet (chưa có lệnh Lead cho các task XII); chưa gửi tin.

Tóm tắt: phần đăng nhập, đặt lại mật khẩu, khoá tài khoản và phiên làm cẩn thận; kiểm quyền đọc DB mỗi request. Đường nâng quyền vẫn một người làm được, CI chưa từng gác mã này
và khoảng 507 ca test Postgres chưa chạy trên dev. Chưa thấy lối vào công khai mới nào gây hại cho .60.

## 1. Kết luận từng task XII (`*` = đạt phạm vi mã, còn điều kiện nhỏ; đa số `*` cùng thiếu một lượt `ci-integration` xanh trên dev)

| ID | Việc | Kết luận | Bằng chứng / việc phải làm |
|---|---|---|---|
| M3-039 | Đóng Flow 4, UAT | CẦN SỬA | Chỉ tài liệu và helper e2e; 27 ô UAT còn PENDING. rememberMe: BE mặc định 14 ngày (`application.yml:406`), e2e chờ > 13 ngày (`e2e-real/auth-pages.real.spec.ts:296`), không thấy chỗ ghi đè 7 ngày. Chưa có lượt Real E2E 37/37 |
| M3-040 | Audit/sự kiện tạo, khoá, mở khoá, gán vai trò | ĐẠT* | `AdminIamUserServiceImpl.java:164-308`, `RbacAdminServiceImpl.java:131-245`; CI `RbacAdminServiceImplTest` 28/28. Thiếu: 2 lớp Postgres, audit không có IP (2.9) |
| M3-041 | Màn nhật ký thao tác | CẦN SỬA | FE có, BE kiểm quyền đúng (`AdminAuditEvidenceController.java:73,102-104`); job FE của CI SKIPPED nên "Vitest 81" không kiểm lại được |
| M3-042 | Bảng chính sách cache (tài liệu) | ĐẠT* | `xii-m3-039-059-parallel-plan-2026-11-04.md:508-510`; chưa đọc từng dòng nội dung |
| M3-043 | Khoá sau 5 lần sai | ĐẠT* | `LoginLockoutService.java`; mở khoá đặt lại bộ đếm (`AdminIamUserServiceImpl.java:282`, V305); CI `LoginLockoutServiceTest` 23/23; chưa chạy `AdminLoginLockoutPostgresTest` |
| M3-044 | Giới hạn đăng nhập theo thiết bị/IP | ĐẠT* | `LoginSourceRateLimiter.java`, V314; IP tin cậy qua Tomcat RemoteIp (`deploy/m34/compose.yml:116-117`) và nginx ghi đè XFF (`m34.conf:46`); chưa chạy 2 lớp Postgres |
| M3-045 | Tự đổi mật khẩu, bắt đổi mật khẩu tạm | ĐẠT* | `AdminChangePasswordServiceImpl`, cổng `SecurityConfig.java:165-226` (fail-closed); mật khẩu tạm không theo chính sách 15 ký tự (2.8) |
| M3-046 | Sổ sự kiện, nhật ký sự kiện, outbox | ĐẠT* | Quyền `AdminGovernanceOutboxController.java:129`, `AdminEventRegistryController.java:172-180`; lỗi outbox được che (`OutboxMonitorServiceImpl.java:99-115`); FE chưa kiểm |
| M3-047 | Quên mật khẩu nhân viên | ĐẠT* | `AdminPasswordResetServiceImpl`: trả lời trung tính, một mã sống mỗi tài khoản, trần 10 lần sai/60 phút, giới hạn theo nguồn, thu hồi phiên ADMIN; FE chưa có; mail thật phụ thuộc SMTP trên .60 (chưa kiểm được) |
| M3-048 | Duyệt kép SUPER_ADMIN | CẦN SỬA | Thiếu nửa "sửa quyền vai trò SUPER_ADMIN" (2.1); FE chưa có; chưa chạy 9 đột biến; ODR-048-01/02/04/10 chưa ai trả lời |
| M3-049 | Hộp duyệt chung | ĐẠT* | `AdminApprovalInboxController.java:79,111`; loại SUPER_ADMIN chỉ đọc trong hộp; chưa chạy `AdminApprovalInboxPostgresTest` (55 ca) |
| M3-050 | Thiết bị đang đăng nhập | CẦN SỬA | BE tốt (`OwnSessionServiceImpl`); FE không có trên nhánh remote nào (`git ls-tree` 10 nhánh = 0) nhưng Sheet ghi "Chờ review, vitest 153/153" |
| M3-051 | Break-glass máy chủ | ĐẠT* | `BreakGlassServiceImpl.java:231,299,349,619` (người yêu cầu ≠ người duyệt), V301/V315; chưa chạy Postgres |
| M3-052 | Legal hold chạy thật | ĐẠT* | `LegalHoldServiceImpl.java:251-265`; `ConsentPrivacyRetentionService` có hỏi guard; V317 chỉ thêm cột; chưa chạy `LegalHoldScrubPostgresTest` |
| M3-053 | Lọc menu theo quyền | CẦN SỬA | Chưa làm: `front-end/src/app/admin/components/adminNavigation.ts` không lọc theo quyền; BE vẫn chặn đúng; Sheet "Chưa bắt đầu" khớp |
| M3-054 | Chặn tự duyệt chính sách | ĐẠT* | `PolicyAdminServiceImpl.java:611-650` (fail-closed, ghi audit); chưa chạy `PolicySelfApprovalPostgresTest`; FE chưa kiểm |
| M3-055, 056 | FE break-glass, legal hold | CẦN SỬA | FE có (`features/governance/break-glass`, `legal-holds`) nhưng thiếu lượt chạy FE (job CI SKIPPED) |
| M3-057 | Quét virus upload | ĐẠT* | `UploadFileServiceImpl.java:205-290`: tắt scanner mà bắt buộc sạch → 503, quá hạn mức → 413, nhiễm → 422; .60 bật CLAMAV và REQUIRE_CLEAN (`compose.yml:140`) |
| M3-058, 059 | Adapter S3; nghiệm thu XII | CẦN SỬA | Chưa làm: không có mã S3 trong `pom.xml` và `src/main`; Sheet "Chưa bắt đầu" khớp |
| M3-013 | Sửa Flyway V251 | CẦN SỬA | Không có bằng chứng mới; số migration đổi hai lần (`1446b1524`, `ce21d1f59`) nên nguy cơ lệch checksum tái diễn |
| M3-061 | Gộp dev vào PhucApu, đẩy dev | CẦN SỬA | Lỗi quy trình cũ (đẩy thẳng, không CI) lặp lại ở `88490ac79` |
| M3-022 | Đồng bộ giao diện lô 2 | không rà | Không thuộc quản trị XII |

## 2. Phát hiện (người sửa: Phúc)

| # | Mức | Tệp:dòng | Vấn đề → đề xuất |
|---|---|---|---|
| 1 | NẶNG | `AdminIamRoleServiceImpl.java:292-345,516-531`; `RbacAdminServiceImpl.java:249-309`; `RbacDataSeeder.java:507,531-584`; `IdentityPermissionPortImpl.java:47-72` | Duyệt kép chỉ chặn việc gán SUPER_ADMIN. SUPER_ADMIN không có quyền gì và không có nhánh bỏ qua kiểm quyền, nên duyệt kép bảo vệ một vai trò rỗng. SECURITY_ADMIN giữ cả quyền yêu cầu lẫn duyệt, cộng `RBAC.ROLE.CREATE`, `RBAC.ROLE_PERMISSION.MANAGE`, `RBAC.USER_PERMISSION.MANAGE`, `USER.CREATE`. Một người có thể tạo vai trò mới rồi gán mọi quyền (`blockSelfEscalation` chỉ chặn khi mình giữ vai trò đó), tạo tài khoản phụ biết mật khẩu tạm, gán vai trò cho tài khoản đó; hoặc cấp trực tiếp mọi quyền kể cả `*.APPROVE` mà không ai duyệt. Kế hoạch XII-06 có ghi vế "sửa quyền vai trò SUPER_ADMIN" nhưng mã chưa làm. → thêm cổng duyệt cho sửa quyền vai trò SUPER_ADMIN (và SECURITY_ADMIN); luật "không cấp thứ mình không có" cho 3 đường: role-permissions, user-permissions, gán vai trò |
| 2 | NẶNG (quy trình) | `.github/workflows/ci.yml:5-9`; `gh pr view 154`; `gh api …/branches/dev/protection` → 404 | CI chỉ chạy trên PR; PR #154 đỏ (11 fail + 20 error) vẫn merge; job integration SKIPPED; dev không có bảo vệ nhánh; XII vào dev bằng commit gộp "save"/"gộp thay đổi chưa lưu" (`3cbf857de` 705 tệp, `27df77e3a` 562, `88490ac79` 655), không truy vết theo task. → chạy `ci-integration` trên SHA dev, đính log; commit theo task, qua PR |
| 3 | VỪA-CAO | `AuthSession.java:25-26`; `IdentitySessionPortImpl.java:51` | Thiếu `@DynamicUpdate`: mỗi request ghi lại cả dòng phiên, một lần thu hồi đồng thời có thể bị ghi đè (đổi mật khẩu, đặt lại, "đăng xuất thiết bị khác"). Khoá tài khoản vẫn chặn nhờ kiểm status mỗi request (`IdentitySessionPortImpl.java:91-96`). Task A2 (D09, ưu tiên cao) chưa làm → làm A2 kèm test Postgres đỏ rồi xanh |
| 4 | VỪA | `RbacAdminServiceImpl.java:136-142,255-261,319-325` | `approvalRequestId`, `breakGlassSessionId` do client gửi được ghi thẳng vào audit/lịch sử/sự kiện không kiểm (chỉ nhánh SUPER_ADMIN `:174-187` có kiểm) → nhật ký có thể ghi "đã có phiếu duyệt N" sai. → kiểm phiếu APPROVED và khớp, hoặc bỏ hai trường |
| 5 | VỪA | `AdminIamUserServiceImpl.java:211-251` | `lockUser` chỉ chặn tự khoá, không kiểm cấp bậc: ai có `USER.LOCK` khoá được cả SECURITY_ADMIN; hai admin khoá nhau cùng lúc → không còn admin. → chặn khoá người giữ quyền cao hơn / người quản trị hoạt động cuối |
| 6 | VỪA | `AdminIamUserServiceImpl.java:220-221`; `AuthServiceImpl.java:1906-1911` | Khoá có `lockedUntil` nhưng status vẫn `LOCKED`, không job nào mở lại → "khoá đến X" thực chất vô hạn; FE không gửi `lockedUntil`. → bỏ trường hoặc làm job mở tự động |
| 7 | VỪA | `AdminIamRoleServiceImpl.java:292-345` vs `:253` | Gỡ quyền khỏi vai trò không có kiểm "tối thiểu admin" như `deactivateRole` → gỡ hết `RBAC.*` khỏi mọi vai trò thì mất khả năng quản trị, phải sửa DB. → thêm `assertNotLastMinimumAdminRole` cho nhánh gỡ quyền |
| 8 | VỪA | `CreateAdminIamUserRequest` (`@Size(min = 8)`); `RbacDataSeeder.java:1043-1072` | Mật khẩu tạm không qua `AdminPasswordPolicy` (15 ký tự), người tạo biết mật khẩu; mật khẩu admin seed không bắt đổi. → sinh mật khẩu tạm phía server hoặc áp chính sách |
| 9 | VỪA-NHẸ | `RbacRuntimeAuditWriter.java:28-130` | Audit IAM không ghi IP/UA (nhánh chính sách thì có); `requestId`/`correlationId` do client đặt. → ghi IP/UA, tự sinh id |
| 10 | VỪA | `LoginLockoutService.java:96-125`; `IdentitySessionPortImpl.java:91-96` | Người ngoài gõ sai 5 lần là khoá tài khoản admin và đá phiên đang chạy; chặn theo thiết bị né bằng xoá cookie, chặn IP 30 lần/15 phút. Thiết kế AAH-D13, ghi để biết → cân nhắc allow-list IP admin ở nginx |
| 11 | NHẸ | `AuthServiceImpl.java:~292-330` | Tài khoản không tồn tại hoặc đang khoá trả lời trước BCrypt → lệch thời gian, dò được tài khoản. → BCrypt giả cho các nhánh sớm |
| 12 | NHẸ | `V318…sql:11` vs `RbacDataSeeder.java` | Comment V318 nói seeder có mapping `RBAC.SUPER_ADMIN_ROLE.APPROVE`; `git grep` trên `src/main` cho thấy seeder không có (DB mới vẫn đủ nhờ Flyway chạy trước). → thêm vào catalog seeder hoặc sửa comment |
| 13 | NHẸ | `DualApprovalServiceImpl.java:138-179` | `decide` không tự kiểm người duyệt có `requiredPermissionCode`; hiện mọi nơi gọi tự kiểm. → kiểm tại lõi |

Điểm tốt đã xác minh: mọi controller XII có kiểm quyền thật qua `identityPermissionPort.hasPermission` (ở tầng service, không `@PreAuthorize`); không endpoint nào chỉ `authenticated` mà đổi tài khoản/vai trò/khoá · quyền đọc từ DB mỗi request, người khoá hoặc không ACTIVE bị từ chối ngay; phiên kiểm lại DB theo `jti` mỗi request nên thu hồi có hiệu lực tức thì ·
CSRF: refresh/logout kiểm origin + double-submit (`AuthCookieRequestGuard.java:52-70`), login kiểm origin · không thấy log hay audit chứa mật khẩu, token, OTP; khoá thử đăng nhập là SHA-256 (`AuthServiceImpl.java:1940-1942`) · bảng audit có trigger chỉ-thêm (`V32…sql:128-145`, `V34…sql:240`), không có API sửa/xoá audit.
Chưa kiểm: mail đặt lại mật khẩu trên .60 (`PasswordResetOtpSenderImpl.java:76-104` chỉ ghi tệp capture ở profile `e2e`, còn lại gửi SMTP thật; .60 có SMTP/Gmail chưa biết) · `flyway_schema_history` thật của .60 (không SSH).

Migration V300–V318 (không trùng số, dãy 300–330 liền; V296–V299 còn trống): V300, V301, V305, V306, V314, V317, V318 chỉ thêm quyền/cột/chỉ mục, `ON CONFLICT`/`IF NOT EXISTS`, chạy lại an toàn · V315 chỉ gỡ cặp `ADMIN` + `BREAK_GLASS.SESSION_USE` khỏi `role_permissions` (`WHERE` hẹp) ·
V302, V303, V304, V316 UPDATE dữ liệu catalog, `WHERE` chặt, không DELETE, `RAISE EXCEPTION` nếu trùng slug, tự hoàn tác trong giao dịch Flyway; V303/V304/V316 hiện lại bản `ARCHIVED` thành `INACTIVE` (bỏ `deleted_at`), V302 hồi sinh SKU lưu trữ thành `UNPUBLISHED`; không đếm/sao lưu trước, không chạy lại được bằng SQL thuần (`ADD CONSTRAINT` không `IF NOT EXISTS`) ·
nguy cơ với .63: BE nào trỏ .63 và `FLYWAY_ENABLED=true` sẽ tự áp ngay khi khởi động · 2 test hợp đồng migration đỏ trong CI: `SkuTwoStateLifecycleMigrationContractTest:103` (header V302) và `GoldenHourRulesPolicyGuardMigrationContractTest:130` (thang số).

## 3. Danh sách việc

**Sửa bắt buộc trước 30/11:** 2.1 đóng đường nâng quyền một người (hoặc Lead ghi chấp nhận có điều kiện) · 2.2 `ci-integration` xanh trên SHA dev · 2.3 A2 `@DynamicUpdate` · 2.4 kiểm/bỏ `approvalRequestId`/`breakGlassSessionId` do client gửi · 2.5 chặn khoá người quản trị cuối · 2.7 kiểm "tối thiểu admin" khi gỡ quyền · M3-050 FE đẩy lên hoặc đổi trạng thái về Đang làm · hai test hợp đồng migration đang đỏ.
**Nên sửa trước nghiệm thu 27/11:** 2.6, 2.8, 2.9, 2.12, 2.13 · M3-053 lọc menu theo quyền · FE cho yêu cầu SUPER_ADMIN và quên mật khẩu admin · 9 đột biến của M3-048 · cập nhật cột Commit trên Sheet M3-040…057 · Real E2E 37/37 và UAT 27 ô.
**Cần chặn hoặc khoá NGAY trên .60:** không có endpoint nào phải đóng khẩn. Đã tìm ba thứ:
- Quyền thật: `SecurityConfig` từ `527204310` chỉ thêm `permitAll` cho `/auth/admin/reset-password/{request,confirm}` (trung tính, giới hạn tần suất) và 2 đường health; bảng webhook GET được siết còn `/VNPAY`.
- Seed: `deploy/m34/compose.yml:155` đặt cứng `SEED_ADMIN_FULL_PERMISSIONS: "true"` (chỉ có tác dụng khi `SEED_ENABLED=true`, mặc định `:149` là false). Admin seed giữ quyền cho phép trực tiếp trên mọi quyền đang hoạt động trừ `FINANCE.*` (`RbacDataSeeder.java:966-970`), đã lưu trong DB; mỗi lần bật lại seed lật quyền DENY thành ALLOW (`:1122-1140`) và đặt lại ACTIVE (`:999`). **Lưu ý của phiên chính (LEN60-PLAN):** `compose.override.yml` trên .60 đang bật `SEED_ENABLED=true` + profile `demo` từ 07/11, nên mỗi lần `be` khởi động lại (kể cả LEN60) seed chạy lại. Kiểm mã: seeder KHÔNG ghi đè mật khẩu đã đặt (`RbacDataSeeder.java:1038-1039`, chỉ đặt khi trống), nên đổi mật khẩu admin .60 lúc nào cũng được. Việc cần làm: tắt `SEED_ENABLED` sau khi tạo admin (gói M34-VH); Lead tự chạy SQL chỉ đọc kiểm danh sách tài khoản INTERNAL và các override trực tiếp.
- Truyền tải: `AUTH_COOKIE_SECURE=false` và HTTP không TLS (`compose.yml:131`) — mật khẩu admin và cookie refresh đi rõ trong LAN, cần TLS trước khi mở domain (D-lead-028).

## 4. Test

Đếm tĩnh: 93 lớp liên quan XII, ~1.291 `@Test`/`@ParameterizedTest`; 497 ca cần Docker (`@Testcontainers(disabledWithoutDocker = true)`), 794 ca không cần DB. Log CI có sẵn (run `42539725520`, 09/11, job unit FAILURE; 27.816 test, 11 fail, 20 error, 22 skip): ca XII xanh `SuperAdminRoleFlowPostgresTest` 4/4, `SuperAdminRoleRequestServiceImplTest` 26/26, `SuperAdminRoleChangeGuardTest` 15/15, `RbacAdminServiceImplTest` 28/28, `LoginLockoutServiceTest` 23/23, `AdminSurfaceGuardTest` 22/22; không lớp XII nào trong danh sách đỏ, ngoài 2 test hợp đồng migration.
Chưa chạy thật: job integration SKIPPED nên ~26 lớp Postgres XII (≈ 507 ca: `AdminLoginLockoutPostgresTest`, `OwnSessionDevicesPostgresTest`, `AdminApprovalInboxPostgresTest`, `LegalHoldScrubPostgresTest`, `BreakGlass*`, `PolicySelfApprovalPostgresTest`, `DualApprovalPortPostgresTest`) chưa chạy trên dev. `SuperAdminRoleFlowPostgresTest` mock `IdentityPermissionPort` nên không kiểm ma trận quyền thật và không có trong include của `ci-integration`; 20 lớp `*PostgresTest` dùng mock.
"41/41" của M3-049 là 41 đột biến thủ công (Sheet), không phải số ca; người viết và người đột biến cùng trong quy trình của Phúc, không tái chạy được. M3-043 khai "17 Postgres PASS" mà `AdminLoginLockoutPostgresTest` đếm tĩnh 10 `@Test` (chưa chạy nên không kết luận lệch). CHƯA CHẠY do auditor: không chạy test nào.

## 5. Lệch lời kể và git

Phúc báo "đã merge dev" ngày 04/11 là sai lúc đó; mã đến dev theo 3 đợt: `LoginLockoutService` 02/11 (`7c5f5db6a`); `AdminChangePasswordServiceImpl`, `ApprovalInboxQueryServiceImpl`, `OutboxMonitorServiceImpl` 04/11 (`27df77e3a`); `SuperAdmin*`, `LoginSourceRateLimiter`, `OwnSessionServiceImpl`, `LegalHoldServiceImpl`, `AdminPasswordResetServiceImpl` 07/11 (`88490ac79`) ·
ô Commit trên Sheet ghi "chưa commit (HEAD 169d99fb2)" cho ~15 task đã nằm trong dev · M3-048 Sheet "Đang làm, chưa chạy Maven" nhưng BE đã vào dev và 69 ca xanh trong CI (Sheet ghi thấp hơn thực tế) · M3-050 Sheet "Chờ review" cho FE không có trên remote.

## 6. Tin nháp gửi Phúc

Đã hợp nhất vào `2026-11-10-tin-phuc.md` mục 2 (một tin duy nhất).

## 7. Lead cần quyết (mới, sau m34.69 A)

- **m34.88** SUPER_ADMIN đang là vai trò rỗng (ODR-048-10), SECURITY_ADMIN là quyền lực thật không qua duyệt. Đề xuất: mở rộng duyệt kép sang sửa quyền SUPER_ADMIN và SECURITY_ADMIN + luật "không cấp thứ mình không có", làm trước 27/11; trả lời/ghi chấp nhận ODR-XII-048-01/02/04/10.
- **m34.89** Bảo vệ nhánh `dev` (PR bắt buộc, CI xanh mới merge; repo hiện 404 — cần quyền admin repo, do chủ repo bật) và không build image .60 khi CI đỏ. Đề xuất: bật; khớp m34.81 đã chốt.
- **m34.90** `.60`: tắt `SEED_ENABLED` + gỡ `SEED_ADMIN_FULL_PERMISSIONS` cứng (`compose.yml:155`) sau khi tạo admin; chuyển quyền admin seed từ override trực tiếp sang vai trò (thu hồi/audit được); bật TLS + `AUTH_COOKIE_SECURE` trước khi mở domain (D-lead-028). Đề xuất: làm trong M34-VH (tắt seed + gỡ cờ), TLS theo lịch domain.
- m34.41 rememberMe: mã đã 14 ngày, không thấy ghi đè 7 ngày. Đề xuất đóng m34.41 sau Real E2E 37/37.
