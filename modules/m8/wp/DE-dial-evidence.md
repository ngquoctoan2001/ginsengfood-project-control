# DE (W-0596) — Bằng chứng đã quay số cho M3 (`dial_evidence`)

Trạng thái: ĐANG LÀM · Mức: Nguy hiểm (migration + hợp đồng; cổng một vòng trước khi báo bật) · Mốc: 29/11 (D-m8-164)
Hạng mục nâng: "Nối với M3" (mở rộng `dial_evidence` 0 → 50) · Sheet: M8 (ghi khi commit) · Ước lượng: 10 giờ + 2 giờ cổng
Chỗ làm: checkout chính `C:\Projects\ginsengfood-ivr`, nhánh `main` · Base SHA: `169a6859` · Khoá tệp: `m8/W-0596` (15 đường dẫn, `tools/khoa_tep.py xem --repo ivr`) · Kiểm: <SHA commit chấm>

## Brief
1. Repo `C:\Projects\ginsengfood-ivr`, nhánh `main` (chỉ `main`; cấm tạo nhánh, cấm `git worktree add`), base `169a6859`. Sửa thẳng trong checkout, KHÔNG commit, KHÔNG đổi index/ref.
2. Mục tiêu: khi xong, hai tuyến `GET /v1/ivr/order-confirmation/tasks/{taskId}/result` và `GET /v1/ivr/order-confirmation/call-jobs/{ivrCallJobId}/result` trả thêm trường tuỳ chọn `dial_evidence` đúng yêu cầu M3 ([hộp thư](../../../hop-thu/m8-2026-11-27-m3-dial-evidence.md)):
   - `state` = `DIALED`: có `attempt_id`, `started_at` (ISO 8601), `execution_mode` lúc bắt đầu quay (`MOCK`, `LAB_REAL_SIM`, `PRODUCTION_REAL`); giữ khi đọc lại, kể cả không bắt máy hoặc lỗi sau khi đã quay. Nhiều lượt đã quay: lấy lượt quay đầu tiên (ghi rõ trong YAML).
   - `NO_DIAL_FINAL`: task đã kết thúc và không lượt nào quay (bỏ ba trường).
   - `UNKNOWN`: task còn chạy, kết quả nhà cung cấp chưa rõ, hoặc lượt đã quay nhưng thiếu chế độ lúc quay (dữ liệu cũ).
   - Chế độ phải được lưu tại lượt gọi lúc bắt đầu quay (cột mới cho phép rỗng trên `ivr_call_attempts`), KHÔNG đọc chế độ hiện tại của kênh (`CallUsageAggregationJob.cs:166` đang làm vậy, không được dùng cho trường này). Giữ `task_id`, `ivr_call_job_id`, `order_id`, `order_version` như cũ. Quyền đọc như hiện tại (Order Core).
   - Hợp đồng `specs/api/openapi/ivr-order-confirmation.v1.yaml` lên `1.0.0-draft.52`: schema `DialEvidence` + ví dụ, baseline `specs/api/openapi/baselines/ivr-order-confirmation.v1.0.0-draft.52.yaml`, `contract-manifest.json` (hash mới), NSwag sinh lại bằng đúng lệnh CI, docs portal + changelog sinh lại, test hợp đồng `Draft52ContractTests`. Callback contract và các baseline cũ không đổi byte.
   - Test phủ: quay rồi không bắt máy; lỗi trước khi quay (không `started_at`); lỗi sau khi quay; task bị thu hồi; gọi lại cùng đơn (task gọi lại có bằng chứng riêng); dữ liệu cũ thiếu chế độ ⇒ `UNKNOWN`; đổi chế độ kênh sau khi quay ⇒ vẫn trả chế độ lúc quay; task còn chạy ⇒ `UNKNOWN`.
3. Phạm vi ghi (đã khai khoá): `src/Ivr.Infrastructure/Persistence/Migrations/` (một migration mới tên `W0596DialEvidence` + snapshot), `IvrPersistenceEntities.cs`, `PostgresSchedulerStore.cs` (đóng dấu chế độ cạnh chỗ gán `SimChannelId`, khoảng `:529-553`), `TaskResultReadService.cs`, `specs/api/openapi/`, `src/Ivr.Contracts/Generated/`, `tests/Ivr.ContractTests/`, `tests/Ivr.IntegrationTests/TaskResultReadApiTests.cs` + thư mục mới `tests/Ivr.IntegrationTests/DialEvidence/`, `tests/Ivr.UnitTests/DialEvidence/`, `docs/api/`, `docs/api-changelog.md`, `docs/contracts/`, `docs/evidence/W-0596/`, `deploy/ci/governance/` (chỉ nếu danh sách đóng băng hợp đồng bắt buộc). Cần sửa tệp ngoài danh sách (ví dụ đăng ký DI, ghim số dòng migration trong tài liệu/test khác) thì DỪNG, ghi tên tệp + lý do vào tin cuối, không sửa.
   **Tệp cấm:** `src/Ivr.Domain/Ports/ProviderPorts.cs` (ghim hash; chỉ đọc tham số `ExecutionMode` có sẵn), baseline OpenAPI draft.44…draft.51, ZIP r1/r2, IR-06, `order-core-ivr-callback.target-v1.yaml`, `.gitattributes`, `docs/release/work-register.md`, `docs/release/gate-status.yaml`, `docs/traceability-tests.md`, `specs/database/02-tables.md` (phiên chính sinh lại các tệp này), mọi `.env*`, `tools/task-tracker/sheet.json`.
4. Đọc trước: `C:\Projects\ginsengfood-ivr\CLAUDE.md` (luật repo); hộp thư M3 ở trên; mẫu nâng draft: `git show --stat 646f333f` (W-0590, draft.51) và `git show 74c4b9b0 --stat` (W-0595 chốt chữ) — làm theo cùng chuỗi bước; `docs/evidence/W-0590/README.md`; mẫu migration cộng thêm: `20261125152453_W0565VoiceProfilesPreviewsCostCeilings.cs`; `TaskResultReadService.cs:28,30` (`revoked`, `is_final` có sẵn); `PostgresCallRuleJobStore.cs:195-207` (`started_at` rỗng = chưa quay). GitNexus: `impact` trước khi sửa symbol (chỉ đọc, không `analyze`).
5. Lệnh kiểm nhanh (coder): `dotnet build Ivr.sln --configuration Release --no-restore` (0 cảnh báo mới); `dotnet test tests/Ivr.ContractTests --configuration Release --no-build`; test unit + integration có lọc cho phần mới và `TaskResultReadApiTests` (`--filter`), cộng một lần lọc theo các lớp chạm `PostgresSchedulerStore`; kiểm đóng băng hợp đồng như W-0590 đã chạy (`node` script freeze/selftest trong `deploy/ci`), `docs-selftest`. Cần Docker cho Testcontainers; cổng cố định API 5005, Postgres 55433: chỉ một lệnh compose một lúc. Bộ đủ KHÔNG chạy (phiên chính chạy dưới `@bo-kiem-du`). Vùng Nguy hiểm: có (verifier một vòng sau commit). KHÔNG chạy: push, ssh/.99/.64, `s5v4_host.py`, `run_lab.py`, đổi `REAL_CUSTOMER_CALL_ALLOWED`, `gitnexus analyze`, `git add/commit/stash/reset/restore/clean/checkout --`.
6. Bằng chứng nộp: `docs/evidence/W-0596/README.md` (mục tiêu, tệp đổi, lệnh kiểm + số, hash draft.52 cũ→mới, migration SQL trích bằng `dotnet ef migrations script` cho riêng migration mới nếu làm được, ca test theo từng tổ hợp, việc CHƯA CHẠY). Không dữ liệu khách, không số điện thoại trong bằng chứng.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`.
8. Đầu ra: tin nhắn cuối ≤ 25 dòng theo LUAT_SUBAGENT mục 10 (gồm danh sách tệp đổi, hash draft.52, lệnh kiểm + số, tệp ngoài phạm vi cần sửa nếu có).

## Diễn biến (mỗi vòng một dòng, mới nhất ở cuối)
- 27/11 19:5x phiên chính: lập phiếu, khai khoá `m8/W-0596`, giao coder v1.

## Bước kế tiếp chính xác
Coder v1 làm theo Brief; xong thì phiên chính đọc diff, chạy lại test lọc, cấp hàng W-0596 trong `work-register.md`, sinh lại traceability/gate-status, commit theo đường dẫn, rồi verifier một vòng (cổng Nguy hiểm) và báo m34 hash draft.52 qua hộp thư.

## Còn lại / CẦN QUYẾT
- Push và lên .99 bản có `dial_evidence`: lượt riêng Toàn nói (D-m8-164).
