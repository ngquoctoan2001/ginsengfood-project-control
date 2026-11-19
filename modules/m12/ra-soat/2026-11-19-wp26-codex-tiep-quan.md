# WP26 — Codex tiếp tục kiểm và trình diff đợt 2

Mốc nhận: 19/11/2026 · Repo `C:\Projects\ginsengfood-ops-core`, nhánh `main`, HEAD nhận thực thi `937cbd989123e938938419d3d01c046dcf49295b`.
Toàn xác nhận Claude cùng agent con đã dừng, cho tiếp tục WP26; **chưa stage/commit**. Task M12-114, R3.

## Phạm vi và vùng tệp

- WP26 chỉ sửa hai tệp sạch: `apps/admin-web/src/features/system/screens/UsersRolesPage.WorkEmailDialog.tsx` và `tests/frontend/admin-web/component/src-features/system/users-roles-work-email.test.tsx`.
- Lỗi: UI hướng dẫn như mã đã được gửi ngay khi admin gắn mail. Hợp đồng thực tế trong `OwnWorkEmailLink.cs` và test tích hợp yêu cầu nhân viên đăng nhập bằng mật khẩu, vào Hồ sơ, bấm Gửi mã rồi nhập mã. Đã sửa hướng dẫn, không đổi backend/OTP/API.
- Trước sửa đã kiểm main/HEAD, hash khớp bản tiếp nhận thực thi và sao lưu hai tệp. GitNexus hiện không có MCP tool, index chỉ đến `42a6984484` ngày 26/09; không reindex. Impact trực tiếp: `UsersRolesPage.UsersTab` gọi dialog, thông báo toast và test hiện hữu; không tác động luồng xác thực.
- Tại mốc nhận, WP27 xác nhận giữ 7 dirty files giao nhau: `UsersRolesPage.UserDialogs.tsx`, `status-maps/system.ts`, `account-profile-ui.test.tsx`, `account-work-email-card.test.tsx`, `system/users-roles-create-user-dialog.test.tsx`, `hook-return-type-ratchet-static.test.ts`, `work-email-helpers.test.ts`. Giữ cả WIP auth validators của WP27. Sau khi WP27 được ghép và giao tiếp cho WP28, WP26 vẫn chỉ giữ đúng hai tệp mail nêu trên; các tệp còn lại do WP28 điều phối.
- WP28 nhận PWA mail login/UI/client/test, không sửa generated types; giữ nền UI. WP26 không sửa PWA hay components/ui/form/layout. Hai chat đã xác nhận không chạy trùng bộ .NET đủ.
- Allowlist/hash: `C:\Users\Administrator\AppData\Local\Temp\codex-tiep-quan-m12-20261119\WP26-write-scope.json`; snapshot trước sửa và evidence ở `wp26-execution\` cùng thư mục.

## Diff 4 commit cần Toàn duyệt R3

Đã kiểm trực tiếp hai remote tại lượt tiếp nhận: cả `origin/main` và `gitlab/main` trả `ba6f50273f2f1bd6b31546da0d870094bcb4f192`. Thông tin lịch sử “4 commit chưa push” đã cũ; Codex không push/fetch trong lượt này. Duyệt nội dung không thay quyền deploy/bật cờ.

| Commit | Nội dung cuối cần duyệt |
|---|---|
| `4d0bc4c72` | D-m12-121: giới hạn IP cho xưởng, trần gửi mã/ngày và khóa mail 24 giờ; `login/options`; lưu bộ đếm sai ngoài transaction, thư liên kết nêu tài khoản và audit sai mã. |
| `2c292fb82` | Admin đăng nhập mail hai bước, thẻ mail ở Hồ sơ, gắn/đổi/gỡ mail ở Người dùng; dùng cùng xác minh phiên `/auth/me`, miễn middleware hết phiên đúng hai route start/verify. |
| `a07ade986` | Trả migration 155 về bản đã push; thêm migration 156 mở rộng scope CHECK; tách hàm route; tính giới hạn theo hộp thư bỏ `+tag`; lọc ngắt dòng Unicode; câu thông báo do UI giữ; bộ test độc lập. |
| `ba6f50273` | Chỉ sửa test: tắt GSS cho kết nối Npgsql tự mở, đổi một ca thành DatabaseBackedFact. Không đổi logic OTP hay điều kiện kiểm. |

Migration 155 `20261118100000_EAuthWorkEmailLogin.cs` đã so với `8b1d4cbde`: không diff. Migration mới `20261119010000_EAuthEmailThrottleScopesWave2.cs` thêm `EMAIL_VERIFY_FAIL`, `EMAIL_LOCK`; không backfill dữ liệu nghiệp vụ. `Down` xóa dòng hai scope này rồi thu CHECK về cũ.

Thông số cuối: mail 3 mã/15 phút, 10 mã/24 giờ; 15 lần sai/24 giờ khóa mail 24 giờ; IP 60 gửi/120 xác nhận/15 phút; policy `AuthEmailOtp` 120 request/60 giây, tách password login. Cờ `Auth:EmailLogin:Enabled=false`. Route đăng ký giữ OpenAPI ổn định, feature filter trả 404 khi cờ tắt; `login/options` luôn hoạt động và báo false/đuôi rỗng. Thư văn bản thuần; `+tag` chỉ gộp khóa giới hạn, danh tính mail/tra OTP vẫn theo địa chỉ đầy đủ.

## Bằng chứng lịch sử và bằng chứng lượt mới

Nguồn Claude: JSONL phiên `b184a4f8-2539-49ef-996e-6ab78049cf63`, báo cáo verifier cuối dòng 1566. R3 lịch sử: WorkEmail 89/89, Wave2 kiểm lại 27/27, ApiContract lọc 95/95, Unit lọc 269/269, SchemaSmoke lọc 259/259; 5/5 đột biến bị bắt. Không gọi đây là test Codex chạy lại.

Bộ đủ Claude chỉ hoàn tất build 0 warning/0 error và workspace typecheck tại `ba6f50273`; agent hết hạn mức 09:17, hai lệnh đã chạy kết thúc sau đó. Raw logs `...\Temp\claude\0d8e0f0b7c910113\b184a4f8-2539-49ef-996e-6ab78049cf63\scratchpad\bodu\01-build.log` và `40-fe-typecheck.log` đều exit 0. Những số Unit 9167/Integration2048/API461+189 trong log agent là đọc lại WP24 tại `47044dabb`, không tính cho WP26.

Codex nối tiếp các suite còn thiếu trên worktree sạch `C:\Projects\_wt\m12\kiem-WP26d` tại `ba6f50273`, submodule ghim đúng `1e73bc17be767604835badfe9dbc3d3db2eda628`, dùng build artifacts cùng SHA. Các suite DB chạy tuần tự trên PostgreSQL 18 riêng, bind loopback/cổng ngẫu nhiên; không dùng DB dev/shared/production, không SMTP thật.

Bản sửa UI được kiểm trên plain snapshot của `937cbd989` + đúng hai overlay, workspace packages cũng trỏ vào snapshot: **10/10 PASS**, exit 0. Hash dialog `3c1391c7b0321f1d8fd68c6499a78f4034c7ad78f4c939bc8b516b3ef7cdf280`; test `a0a3aa62af217e778c4b28627de698e60fb2b54e5ad758ba28c28fb600499e74`. Evidence `wp26-execution\ui-check\verification.md`, manifest, log và JUnit; hash snapshot không drift.

## Cổng còn phải phân biệt

- Các kết quả candidate `ba6f50273` không đại diện cho WIP WP27/WP28 hoặc PWA mail mới. Lượt này không nghiệm thu end-to-end PWA/SMTP/production.
- PWA session 600 phút có từ đợt 1, có hiệu lực khi deploy kể cả cờ mail tắt; muốn hoãn dùng cấu hình riêng.
- Migration scope phải có trước khi chạy app đợt 2. Manifest rollout vẫn PARTIAL/NOT_PROVEN; chưa kiểm DB đích .99. N-1 dọn sau 24 giờ trong khi bản mới giữ 48 giờ; không suy chạy lẫn hai bản đã tương thích.
- Biết địa chỉ mail có thể đốt lượt/khóa lối mail người khác; password login vẫn dùng được. Rủi ro đã ghi trong phiếu.
- Toàn còn duyệt diff R3. Chưa stage/commit; push/merge/deploy/bật cờ/SMTP thật là quyền riêng từng lượt.

## Kết quả bộ kiểm đủ Codex

Chốt 11:15 ngày 19/11: các lane đã kết thúc. Không gọi toàn bộ một SHA là xanh: Unit/Schema có lượt kiểm bù DB; Governance D2 kiểm bù trên snapshot đã sửa; API còn một ca X01 bỏ qua. Raw evidence ở `C:\Users\Administrator\AppData\Local\Temp\codex-tiep-quan-m12-20261119\wp26-execution`. Bản tổng hợp bền vững gồm số đếm, SHA256 log/TRX, phạm vi và diff hai tệp: [results.json](evidence/2026-11-19-wp26-codex/results.json), [write-scope.json](evidence/2026-11-19-wp26-codex/write-scope.json), [ui-guidance.patch](evidence/2026-11-19-wp26-codex/ui-guidance.patch).

| Bộ | Nguồn kiểm | Kết quả |
|---|---|---|
| Unit | ba6f50273 | Lượt đủ 9.191 PASS + 1 FAIL do thiếu chuỗi DB; cấp DB dùng một lần rồi chạy lại riêng ca đó PASS 1/1. Đã kiểm đủ 9.192 ca qua hai lượt; không sửa source/test để bỏ lỗi. |
| SchemaSmoke | ba6f50273 | 451 PASS + 1 SKIP; sau migrate DB thử, ca catalog DB kiểm bù PASS 1/1. Đã kiểm đủ 452 ca. |
| Governance | ba6f50273 | 1.104 PASS + 1 FAIL D2 (comment FRM-15). |
| D2 sau sửa | source937 + overlay đúng 1 file PWA test, binary ba6 không đổi | PASS 1/1. Hash overlay D5775C2711D177BB77EC1840A813FCD07E7A8EF110F0A68266C4EE1CA3084F00. WP28 đã nhận evidence và đưa comment vào commit riêng; không quy toàn bộ main/WIP thành xanh. |
| Contract gate | ba6f50273 | Exit 0. |
| Admin typecheck:tests | ba6f50273 | Exit 0. Workspace typecheck/build solution có raw Claude cùng SHA xanh, không chạy trùng. |
| Admin Vitest đủ | ba6f50273 | 619 tệp, 5.342/5.342 PASS, exit 0. |
| PWA Vitest đủ | ba6f50273 | 1.397/1.397 PASS, exit 0; không phải kết quả PWA mail mới của WP28. |
| UI hướng dẫn mail | snapshot937 + hai patch WP26 | PASS 10/10; build webpack native retry exit 0, giữ cảnh báo dependency. |
| API contract đủ | ba6f50273, DB dùng một lần | **650 PASS, 0 FAIL, 1 SKIP, tổng 651**, exit 0 lúc 10:10:20; 37 phút 49 giây. Ca X01 yêu cầu fixture preseed/attestation riêng được khai báo SKIP; không tính PASS. |
| Integration đủ | ba6f50273, DB dùng một lần | **2.088/2.088 PASS, 0 FAIL, 0 SKIP**, exit 0 lúc 11:14:59; khoảng 1 giờ 4 phút. Riêng WorkEmail **89/89 PASS**, gồm CHECK scope và hai ca Down/Up, Up/Down/Up. |

Lệnh tái lập nằm trong `wp26-execution/run-nondb.ps1`, `run-db.ps1`, `run-frontend.ps1`; bản chép không chứa mật khẩu. Các lane backend dùng `dotnet test <project> --no-build --no-restore --artifacts-path .artifacts/dotnet/bodu-WP26 --disable-build-servers --settings <runsettings> --logger trx`; kết nối DB do tiến trình tạo ngẫu nhiên, giữ trong biến môi trường và dọn container có nhãn sở hữu sau khi kết thúc. `tests/database-backed.runsettings` quy định API chạy tuần tự với timeout 75 phút; `tests/integration.runsettings` quy định Integration timeout 150 phút. Không tăng giới hạn hay đổi phép kiểm.

Migration/seed: Codex không sửa schema hoặc seed trong lượt tiếp tục này. Ca DB kiểm bù đã migrate DB thử bằng fixture thật; Integration đủ cũng chạy và đạt `DT02_ScopeCheckConstraint_AcceptsTheTwoNewScopes_RejectsUnknownScopes`, `DT03_ScopeCheckMigration_DownWithNewScopeRows_ThenUp_RestoresSameSchema_KeepsUsers` và `WorkEmailThrottleScopeMigrationIntegrationTests.Up_down_up_widens_then_restores_the_scope_check_and_keeps_the_original_rows`. Đây là bằng chứng Codex chạy lại trên DB dùng một lần. Kết quả 5/5 đột biến vẫn là lịch sử Claude, không chạy lại. Không có seed mới nên không chạy lại chuỗi seed; chưa kiểm migration/seed trên DB đích .99.
## Cảnh báo build dependency (19/11)

Build snapshot admin qua compile/TypeScript/generate pages nhưng Next.js 16.4.1 dừng cuối lượt với `SecurityFatalError` từ cơ chế upgrade reminder. Retry native cùng lệnh được công cụ hỗ trợ; không tắt guard, sửa thư viện hay nâng dependency/lockfile. Kết quả retry chỉ xác nhận build, không đóng vấn đề bảo mật.

Đã đối chiếu nguồn chính thức: [Next.js 16.4.5](https://github.com/vercel/next.js/releases/tag/v16.4.5) phát hành 03/11/2026 sửa 7 advisory mức moderate. [GHSA-f3mh-rxg3-f5g2](https://github.com/vercel/next.js/security/advisories/GHSA-f3mh-rxg3-f5g2) liệt kê 16.0.0–16.4.4 bị ảnh hưởng trong điều kiện Edge route dùng NextResponse đặt cookie; patched 16.4.5. [GHSA-pc58-hwjq-p385](https://github.com/vercel/next.js/security/advisories/GHSA-pc58-hwjq-p385) liên quan app tự host chuyển tiếp fetched responses. Chưa kiểm mức áp dụng từng điều kiện lên hệ thống đang phục vụ; không kết luận có thể khai thác ở .99.

Tại mốc build này cần một lượt phối hợp dependency chung để nâng bản vá và kiểm hồi quy; không thực hiện trong allowlist WP26 hai tệp. Các phiên khác đã nhận việc nâng bản sau đó (mục tiếp theo). Không coi đây là lỗi được sửa bằng retry build.
- Build admin của bản sửa hai câu: `node node_modules/next/dist/bin/next build --webpack`, API origin HTTPS giả, dist riêng trong snapshot; lượt native retry **exit 0 lúc 09:46:52**. Lượt đầu compile/TS/routes xong rồi dừng upgrade reminder. Cảnh báo dependency phía trên vẫn mở.
- Giới hạn môi trường: lệnh pnpm trong snapshot thiếu patch file nên dừng trước compile; direct Turbopack không chấp nhận dependency junction ngoài root. Đã dùng tùy chọn webpack hỗ trợ chính thức, không đổi source/config/lockfile chung. Không ghi thành default Turbopack build đã đạt.
- Worktree kiểm riêng `kiem-WP26-codex-937` do Codex tạo đã được kiểm sạch/đúng SHA và gỡ sau D2; bằng chứng source snapshot + TRX giữ trong thư mục temp. Worktree gốc `kiem-WP26d` đã chạy xong, kiểm lại vẫn sạch tại ba6; giữ nguyên vì đây là checkout/bằng chứng có từ phiên trước.
- Rà độc lập hẹp hai advisory: chưa thấy route Edge đặt cookie qua NextResponse trong admin/PWA; cookie WP26 do `.NET AdminAuthCookies.cs` đặt HttpOnly, Caddy chuyển `/api/v1/admin/*` tới API. Chưa có bằng chứng đường lỗi Edge áp vào cookie WP26.
- Có pattern cần kiểm tiếp cho GHSA-pc58-hwjq-p385 ở hai route proxy bằng chứng admin/supplier: `fetch` upstream, giữ content-length, trả `new Response(upstream.body, ...)`. Chưa xác minh điều kiện framing sai/upstream bị điều khiển hoặc HTTP/1.1 pipelining của proxy đang phục vụ; không kết luận exploit thực tế. Giữ warning dependency UNRESOLVED, không sửa ngoài allowlist.

### Thay đổi đồng thời được ghi nhận sau lượt build

- Khoảng 10:36, main đã tới `ce78f770d85b213593b151fe4b9e9828ce9fafcc`, tiêu đề commit nâng Next admin từ 16.4.1 lên 16.4.6. Đây không phải commit của phiên WP26. WP26 không sửa package/lock/config hoặc stage/commit; hash hai tệp UI vẫn khớp bản đã kiểm. Cảnh báo và kết quả webpack ở trên thuộc snapshot cũ, không kết luận bản nâng dependency mới đã đạt hay chưa đạt. WP28 chịu trách nhiệm ghim và kiểm lại candidate ghép.
- WP27/WP28 báo localhost dùng chung có 152/156 migration, đăng nhập lỗi thiếu `auth_user.work_email`; đây là bằng chứng do hai chat runtime cung cấp, không phải kết quả DB thử WP26. Lúc nhận báo, WP26 chưa có bằng chứng quyền apply bốn migration vào `ginsengfood_operational_local`/55432. Sau đó WP27 báo Toàn đã duyệt phạm vi bốn migration và WP27 nhận lượt backup/apply riêng; kết quả cần theo bằng chứng của WP27. Phiên WP26 không migrate/seed/restart DB hay API dùng chung; bộ kiểm ba6 vẫn chạy trên PostgreSQL riêng.
- Sau đó WP27 báo migration localhost đã đủ 156/156, pending 0, còn chờ bật API/thử đăng nhập lại; không suy thành SMTP hoặc production đã đạt. WP28 đã chốt candidate riêng `2209068ce59c01aee541cf0cae7f807f9f66765e` và tự nhận cổng kiểm bản ghép. Candidate đó vẫn loại hai WIP WP26; kết quả ba6 và snapshot937 của báo cáo này không thay cổng kiểm của candidate mới.

## Chốt lượt thực thi

- Phần tiếp tục đã hoàn tất: đối chiếu bộ đủ cũ, chạy các lane còn thiếu, sửa đúng hướng dẫn mail và chốt vùng hai tệp không chồng lấn. WP26 tổng thể vẫn **PARTIAL / Chờ review 95%** vì còn Toàn duyệt diff R3 và lượt bật cờ/SMTP/triển khai riêng.
- Lúc kiểm cuối, main là `2209068ce59c01aee541cf0cae7f807f9f66765e`; hai tệp WP26 giữ đúng hash đã kiểm, `git diff --check` đạt, không có hai đường dẫn trong index. Phiên WP26 chưa stage/commit/push.
- Đã xác nhận testhost kết thúc, PostgreSQL thử và đúng anonymous volume sở hữu đã gỡ. Redis/Ryuk do fixture tạo trong session `acd7eaea-d5c1-421a-a6eb-33fa4c58ce90` tự dọn hết. `cleanup.json` lưu bằng chứng; giữ `ginsengfood-postgres-local`, `wp27a2-pg`, WIP các phiên khác và các snapshot bằng chứng.
- Đã chạy `node tools/task-tracker/sheet-sync.mjs log --id M12-114 --agent Codex ...` đúng một lần; Sheet đồng bộ và đọc lại lúc 11:18: **Chờ review 95%, Lead review Chưa duyệt**, giữ danh sách bốn commit. [Dòng M12-114](https://docs.google.com/spreadsheets/d/1Fxftz_B9zQXCREcmDvvGjxqRwqI_ux1klOhoaCbIJnY/edit#gid=447650749&range=A115). Nhật ký tuần thêm đúng một entry; toàn bộ nội dung trước lượt ghi còn nguyên. Đã trả slot nhật ký cho WP27/WP28, chưa stage nhật ký.
- Bước tiếp theo: Toàn rà bốn commit cùng patch hướng dẫn; cổng của HEAD ghép do WP28 kiểm theo **TEST_ONLY**. Không tự chạy thêm bộ đủ hoặc stage/commit khi chưa có chỉ đạo mới.

## Lượt mẫu mail M3/M5 và gửi thử thật — sau 11:20

Toàn yêu cầu trình diff R3, đối chiếu M3/M5, dùng mẫu mail của họ và thử hộp Lead chỉ định. Đây là quyền gửi thử đúng đích đó; không phải quyền deploy hoặc xác nhận R3 thay Lead. Chỉ đạo lấy mẫu mới thay lựa chọn plaintext-only trước đó.

- M3: `identity/adapter/out/mail/AdminLoginCodeMailAdapter.java`, `common/mail/BrandedEmail.java`, `BrandedEmailContent.java` và `mail/ginsengfood-logo-ivory.png` trong `ginsengfood-business-platform/back-end`. M5: `module5/src/admin-login/login-code-mail.ts`, `login-mail-logo.ts`, `foundation/mail/smtp-mail-sender.ts`. Cả hai dùng mẫu C navy/vàng, HTML + plaintext, logo CID, mã liền để sao chép, không hidden preheader. Không lấy phản hồi dò tài khoản của M3 hay chính sách khóa 5 lần/15 phút của M5 vào M12.
- Thêm `WorkEmailMailTemplate.cs`, PNG resource và unit test; sửa `SmtpWorkEmailSender.cs`, `.csproj` (chỉ EmbeddedResource), unit test MIME hiện có. Các đường đầy đủ + hash ở [mail-template-final-hashes.json](evidence/2026-11-19-wp26-codex/mail-template-final-hashes.json). WP28 đã nhận allowlist sáu tệp để loại khỏi commit của họ; hai tệp UI WP26 cũ vẫn riêng.
- LINK giữ thông tin tài khoản, lọc ký tự ngắt dòng/định dạng rồi HTML encode; LOGIN không đưa tên tài khoản vào thư. Không đổi OTP policy, transaction, API, quota, TLS hoặc cấu trúc dữ liệu. Không tự tính giờ hết hạn từ thời điểm gửi vì message chưa có thời điểm phát mã; giữ lời hạn 10 phút/một lần.
- Coder: focused `dotnet test ... --filter FullyQualifiedName~WorkEmail --artifacts-path .artifacts/dotnet/WP26-mail-template --disable-build-servers -m:1` **unit 89/89 PASS, skip 0**. API build cùng artifacts **0 warning/0 error**. Đây là 89 ca **unit của bản mail mới**, khác 89 ca **Integration** của ba6 ở trên. Verifier độc lập rà escaping, MIME round-trip, CID/logo, subject và policy: không blocker; không tự nhận chạy lại test coder.
- SMTP TLS/auth thật đạt. Lúc **11:39:31 +07**, MailKit từ artifacts M12 gửi một thư có tiêu đề `[THỬ MẪU M12] Mã đăng nhập Ginsengfood`; SMTP chấp nhận. Thư dùng `Compose` thực và thêm thông báo rõ `000000` chỉ là mã minh họa, không dùng đăng nhập. Chưa có xác nhận inbox, chưa gọi đây là luồng OTP đăng nhập thành công. Receipt gốc giữ trong thư mục riêng ngoài Git; [bằng chứng đã lược dữ liệu riêng](evidence/2026-11-19-wp26-codex/mail-template-delivery.json).
- Cấu hình SMTP/HMAC local đã lưu riêng với ACL hạn chế ngoài Git; không chép credential vào mã, báo cáo, tracker hay ảnh. API cũ vẫn chạy với `emailLoginEnabled=false`: automatic approval review chặn lệnh dừng/restart trước thực thi, chỉ báo `blocked by policy`, không lý do chi tiết. Không tìm cách vượt chặn; đã nhờ Lead Ctrl+C đúng API5000. Launcher riêng đã sẵn, kiểm cú pháp đạt và chặn mở trùng cổng.
- Hộp Lead thử chưa gắn với tài khoản local nào theo truy vấn chỉ đọc đúng địa chỉ đã chỉ định. Đang chờ tên tài khoản để thực hiện qua API/UI thật, không sửa thẳng bảng auth hay bỏ qua OTP xác nhận. Còn lại: bật lại API với cấu hình đã kiểm, gắn mail đúng tài khoản, người dùng nhận/nhập mã LINK rồi LOGIN, xác nhận màn thành công. Chưa stage/commit/push, không thay production.
