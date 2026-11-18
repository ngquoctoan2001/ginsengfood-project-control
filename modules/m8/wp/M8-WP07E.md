# M8-WP07E — Ma trận lối vào 401/403/429 cho mọi endpoint, chạy được trên .61

Trạng thái: **ĐẠT trên .99 17/11** (D-m8-126, D-m8-127): 401/403 178/178 (184 yêu cầu); 429: lượt đầu 38/38 không đạt vì hạn mức tắt → bật `Ivr:ServiceQuota` (đo ở 20/60 s: 275 đạt, lối token đo riêng 6/6), để chạy 600/60 s, kiểm lại 178/178 · trước đó: ĐÃ GỘP W-0526 `d8e1050f` (đã lên GitLab + GitHub 12/11 11:09, không do phiên này; chưa chạy trên .61) · Rủi ro: R3 · Chế độ: A · Mốc: 13/11
Hạng mục nâng: Bảo mật G3 (lối vào đã có client_credentials + RS256 + 429 và test, chưa thử trên host) · Sheet: M8-002 · Ước lượng: 5 giờ
Chỗ làm: `C:\Projects\_wt\m8\M8-WP07E` (bản sao archive, repo tạm commit `goc` eb753e1) · Base SHA: `10f335de` · Chỗ kiểm: cùng bản sao
Quyết định: không gọi .61 khi chưa có lệnh Lead; xoay token Sheet là việc phiên lead (hộp thư), không thuộc gói này.

## Brief
1. Repo · thư mục: bản sao archive của `ginsengfood-ivr` @ `10f335de` tại `C:\Projects\_wt\m8\M8-WP07E` (repo tạm có commit `goc`; KHÔNG commit thêm).
   Repo gốc `C:\Projects\ginsengfood-ivr` chỉ đọc.
2. Mục tiêu: chứng minh mọi lối vào HTTP của M8 (API công khai `/v1/ivr/order-confirmation/*`, token `ServiceTokenEndpoints`, admin `/internal…`,
   feature flag, operations, health) trả đúng 401 (thiếu/sai token), 403 (đúng chữ ký nhưng sai scope/client/allowlist), 429 (vượt hạn mức
   `ServiceQuotaMiddleware`) theo hợp đồng draft.45, và có công cụ đo lại trên .61:
   a) Bảng kê lối vào sinh từ mã (route + policy + middleware áp dụng, `tệp:dòng`) — không viết tay danh sách rồi để lệch.
   b) Test tích hợp (mở rộng `tests/Ivr.IntegrationTests/ApiBehaviorMatrixTests.cs` hoặc tệp test mới cùng fixture) cho từng lối vào: ca 401, 403, 429 (nơi
      hợp đồng có), body lỗi đúng envelope, không lộ chi tiết nội bộ; lối vào nào không áp 401/403/429 phải có lý do ghi trong bảng (ví dụ health công khai).
   c) Công cụ đo hộp đen `deploy/m8/loi-vao/do_loi_vao.py` (python3 thư viện chuẩn): gọi HTTPS tới một gốc URL cho trước, chỉ dùng yêu cầu không token / token
      sai do công cụ tự ký bằng khoá giả / token đúng do người chạy đưa qua tệp (không in), gửi loạt ngắn có giới hạn để thấy 429 rồi dừng; in báo cáo JSON
      mỗi lối vào: mong đợi, thực tế, đạt/không; mã thoát 0/1/2. Mặc định từ chối chạy khi gốc URL không phải host trong danh sách cho phép do người chạy truyền.
   Tiêu chí đạt (SAN_SANG): mọi lối vào có ca 401/403/429 đạt (local), báo cáo lối vào; .61: CHƯA CHẠY (cần lệnh Lead). Test viết đỏ trước rồi xanh (đột biến:
   bỏ `RequireAuthorization`/allowlist/quota một lối vào thì test đỏ); `dotnet test --filter` vùng liên quan đạt (ghi số); unittest công cụ đạt.
3. Phạm vi ghi: `tests/Ivr.IntegrationTests/**` (tệp test mới hoặc mở rộng matrix), `src/Ivr.Api/Middleware/**`, `src/Ivr.Api/Auth/**` (chỉ khi test
   lộ lỗi thật — ghi rõ lỗi, sửa tối thiểu), `deploy/m8/loi-vao/**` (mới), `deploy/m8/tests/test_loi_vao_*.py` (mới), `docs/evidence/W-PENDING-07E/**`.
   Cấm: OpenAPI draft.44/45 và mọi tệp ghim hash, migration, `IvrDbContextModelSnapshot.cs`, `appsettings*` khối chung, `docs/traceability-tests.md`
   (tệp sinh — ghi đề xuất), `docs/release/*`, `deploy/m8/README.md`, `deploy/m8/compose.yml`, `deploy/m8/noi-m3/**`, `deploy/m8/nghiem-thu-m3/**`,
   `deploy/m8/tat-khan/**`, `deploy/operations/**`, `.gitleaks*`.
4. Đọc trước: `CLAUDE.md`, `AGENTS.md`; `src/Ivr.Api/Program.cs`, `Middleware/IvrApiApplicationBuilderExtensions.cs`, `ServiceQuotaMiddleware.cs`,
   `Auth/*.cs`, `Admin/*Endpoints.cs`, `Intake/`; `tests/Ivr.IntegrationTests/ApiBehaviorMatrixTests.cs`, `ApiMatrixFixture.cs`, `Auth/`;
   `specs/api/openapi/ivr-order-confirmation.v1.yaml` (mã lỗi từng operation); `docs/evidence/W-0494/e01-e10-mapping.md` dòng E01.
5. Được chạy: `dotnet build`/`dotnet test --filter` hẹp với thư mục build riêng của bản sao; Postgres test theo fixture sẵn có (chạy một mình, không song song
   nhiều lượt — cạn cổng TCP gây đỏ giả); không chạy khi có container nhãn `com.gitlab.gitlab-runner.type`; `dotnet build-server shutdown` khi xong.
   Test công cụ đo dùng máy chủ HTTPS giả local (cổng ngẫu nhiên, 127.0.0.1). KHÔNG: ssh/scp, gọi .60/.61/.64, sheet-sync, cấp W-ID, sửa repo gốc.
6. Bằng chứng: `docs/evidence/W-PENDING-07E/README.md` (bảng lối vào, lệnh + số, đỏ trước/xanh sau, đột biến, giới hạn, CHƯA CHẠY trên .61); không lập MANIFEST.
   Tránh chữ khớp mẫu địa chỉ của `deploy/ci/pii-patterns.txt` (dòng 2) trong mọi tệp mới; dùng "lối"/`loi`/path.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`.
8. Đầu ra: tin nhắn cuối ≤ 25 dòng theo LUAT_SUBAGENT mục 10.

## Diễn biến (mỗi vòng một dòng, mới nhất ở cuối)
- 11/11 11:10 dựng bản sao (`goc` eb753e1 @ `10f335de`); chờ chỗ (đang chạy verifier 02J + verifier 01C).
- 11/11 11:45 giao coder v1 (chỗ trống sau khi 01C dừng chờ Lead m8.76).
- 11/11 12:33 coder v1 xong (tự báo ĐẠT local): `deploy/m8/loi-vao/{bang-loi-vao.json (50 lối, 5 nhóm, dùng chung C# + công cụ),do_loi_vao.py,README.md}`, `deploy/m8/tests/test_loi_vao_do.py` (24 OK, 1 skip POSIX), `tests/Ivr.IntegrationTests/LoiVao/*.cs` (LoiVao 3/3, + Quota/Auth 41/41; từ chối 188 ca, hạn mức 236 ca, 0 hỏng); đỏ trước: 6 route chưa có dòng bảng; đột biến M1–M6 + T1–T4 đều đỏ; không sửa `src`. Lệch ghi lại: lối nội bộ đọc thân JSON trước xác thực (thân hỏng → 400 thay 401); enum `SourceSystem` OpenAPI có `sales-platform`, allowlist chỉ `order-core`; 6 lối nội bộ không bao giờ 429 (xác thực trong handler sau `ServiceQuotaMiddleware`) → m8.78. UT-TRACE-01 đỏ tới khi sinh lại `docs/traceability-tests.md` lúc ghép. Giao tester độc lập R3.

- 11/11 13:20 tester độc lập R3 xong: **ĐẠT**, không lỗi chặn. Bộ riêng: `tests/Ivr.IntegrationTests/LoiVaoKiemDocLap/` (7 tệp, KDL-01..53, 31/31 không DB), `deploy/m8/tests/test_loi_vao_kiem_doc_lap.py` (17 OK), `docs/evidence/W-PENDING-07E/kiem-doc-lap.md`; bộ coder `LoiVao` 3/3, python 23 OK + 1 skip; build 0 cảnh báo. 50/50 lối Ivr.Api khớp bảng; thiếu dòng MediaReceiver (7 lối loopback 18090) + worker `/healthz/`. Đột biến tester: C1, C2, C4, P1–P3 đỏ; C3 (bỏ `ThrowOnBadRequest`) bộ coder KHÔNG bắt, bộ tester bắt. Phát hiện sản phẩm (CẦN QUYẾT, không sửa `src` trong gói): (1) `ServiceQuotaMiddleware.cs:43,93-109` tính hạn mức theo mọi token quản trị trên mọi route → token quản trị cạn nhận 429 thay vì 403 ở lối nội bộ, 429 ở `/health/live`, 429 thay 404 ở route lạ (ghim hiện trạng bằng KDL-43); (2) `specs/api/06-error-codes.md:36` nói auth sai → 401 nhưng order-core + nội bộ trả 403; (3) enum `SourceSystem` OpenAPI có `sales-platform`, allowlist chỉ `order-core` → 403. Nhỏ: `LoiVaoHost.cs:101` chỉ chạy Development, `do_loi_vao.py:313-314` tắt `VERIFY_X509_STRICT` khi có `--ca-file`, README mô tả khoá ca chưa đúng, bearer chữ thường ra 401. Giao Lead: ok gộp + 3 quyết định (m8.78, m8.81). Mô hình mới D-m8-078: không verifier riêng nếu không đổi `src`.

- 12/11 10:20 Lead "oke gộp 07e" (D-m8-081): ghép A-mode, thư mục bằng chứng đổi thành `docs/evidence/W-0526`; sinh lại `docs/traceability-tests.md` (`--check` CURRENT); trên cây ghép, ưu tiên thấp: `LoiVao` + `LoiVaoKiemDocLap` 34/34, Quota + Auth 39/39, `FailGateTests` 10/10 (UT-TRACE-01 xanh), python 41 OK (1 bỏ qua); PII Linux PASS (đối chứng FAIL), gitleaks dir sạch, gate-status/cd/ci-config/docs selftest PASS. **`image-selftest` ĐỎ** ở trivy: 3 CVE HIGH của `Microsoft.AspNetCore.App.Runtime.linux-x64` 10.0.14 (CVE-2026-114146/147/149, sửa ở 10.0.15), 5 Dockerfile ghim `aspnet:10.0.14-noble-chiseled` — không do gói này; ghi trong bằng chứng, đề xuất W-0528 nâng runtime. **Commit local `d8e1050f`** (22 tệp +5605), gitleaks toàn lịch sử + khoảng sạch. Chưa push.

## Bước kế tiếp chính xác
Chờ Lead quyết m8.78 (hạn mức 429) và m8.81 (hợp đồng 401, `sales-platform`); đo trên .61 khi Lead cho lệnh. Push theo lệnh Lead.

## Còn lại / CẦN QUYẾT
- Đo trên .61: cần lệnh Lead (công cụ gửi loạt yêu cầu ngắn tới HTTPS 8443 để thấy 429).
