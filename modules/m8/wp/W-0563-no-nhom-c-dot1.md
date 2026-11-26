# W-0563 — Nợ nhóm C đợt 1: số dòng ghim, mẫu 120 giây, tạm dừng nhiều hàng OPEN (KE_HOACH N-01, N-02, N-03 phần mã)

Trạng thái: ĐANG LÀM (25/11 21:4x) · Mức: Thường (N-03 chạm đường tạm dừng hàng đợi nhưng không đổi hành vi khi chỉ có một hàng OPEN) · Mốc: trước 28/11
Hạng mục nâng: Hồ sơ phát hành / vận hành · Sheet: (cấp khi xong) · Ước lượng: 2 giờ
Chỗ làm: checkout chính `C:\Projects\ginsengfood-ivr`, nhánh `main` · Base SHA: `f375bfaf` · Khoá tệp: coder tự khai `m8/W-0563`

## Brief
1. Repo `C:\Projects\ginsengfood-ivr`, chỉ `main`. Không commit, không push, không đụng máy chủ.
2. Mục tiêu và tiêu chí:
   - **N-01:** 5 ca đỏ `deploy/m8/tests` (`test_noi_m3_tai_lieu` 3 ca, `test_e_tai_lieu` 2 ca) và các ghim số dòng lệch: `deploy/m8/noi-m3/cau-hinh.md:73` và `viec-m34.md:41` ghim `deploy/m8/README.md:266` nhưng câu nginx thật ở `:262`; `test_e_tai_lieu.py:45` ghim `deploy/m8/README.md:254`; `SchedulerCapacity.cs:28` (dòng trống) phải thành `:29`; nghi thêm `test_tat_khan_tinh.py:27-29` ghim `PostgresSchedulerStore.cs:427,428,431` nay là `:431,432,435`. Chạy lọc `pytest deploy/m8/tests` để xác định đủ ca đỏ, sửa bằng cách cập nhật chỗ ghim (KHÔNG nới assertion, không skip). Ca đỏ thứ ba của `test_noi_m3_tai_lieu` chưa xác minh: tìm ra và sửa.
   - **N-02:** `closed-profile.example.json` thêm `"PlaybackCallLimitSeconds": 120` vào khối Asterisk (:10-16), cập nhật `bytes` + `git_blob_sha256` ở `deploy/release-candidate/components.lock.json:194-196`; không thêm `DailyBudget`; không sửa `deploy/production-dial/evidence/l33-checks.json` (lịch sử); chạy test/validator đọc mẫu này (`render_hosts.py:53` và các test liên quan).
   - **N-03 (phần mã):** `src/Ivr.Infrastructure/.../InternalAdminApiService.cs:320-323,373-376` dùng `SingleOrDefaultAsync` cho sự cố `ADMIN_QUEUE_PAUSE` đang OPEN: hai hàng OPEN làm cả pause lẫn resume lỗi. Sửa để xử lý MỌI hàng OPEN (pause: nếu đã có ≥ 1 hàng OPEN thì trả như đã tạm dừng, không tạo thêm; resume: đóng/resolve tất cả hàng OPEN trong một giao dịch, audit đúng như cũ). Test đỏ trước/xanh sau (tích hợp PostgreSQL: seed hai hàng OPEN rồi pause/resume). Chỉ mục duy nhất KHÔNG làm ở gói này (vào migration G-03).
3. Phạm vi ghi: `deploy/m8/**` (chỉ ghim/tài liệu/test của chính nợ này), `closed-profile.example.json` (tìm đường dẫn thật), `deploy/release-candidate/components.lock.json`, `src/Ivr.Infrastructure/**/InternalAdminApiService.cs` + test mới/sửa nhỏ, `docs/release/work-register.md` (dòng W-0563, NEXT_WORK_ID → W-0564), `gate-status.yaml`, `readiness-board.md`, `docs/traceability-tests.md`, `docs/evidence/W-0563/README.md` (mới). Tệp cấm: hợp đồng OpenAPI/baseline/manifest, migration, `TaskIntakeService.cs`, `.env*`.
4. Đọc trước: `CLAUDE.md`/`AGENTS.md` repo, `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`, `docs/evidence/W-0562/README.md` (mẫu bằng chứng và chuỗi đăng ký gói), `docs/evidence/W-0561/README.md`.
5. Lệnh kiểm nhanh: build `Ivr.sln` 0/0; `pytest deploy/m8/tests` (lọc các tệp nói trên rồi cả thư mục một lần); unit/tích hợp lọc tới lớp tạm dừng hàng đợi (`FullyQualifiedName~InternalAdmin|FullyQualifiedName~QueuePause|FullyQualifiedName~DailyBudget`); `node deploy/ci/scripts/gate-status.mjs --write`, traceability `generate-test-traceability.mjs --write` + selftest. Không bộ đủ, không CI. Vùng Nguy hiểm: không (không đổi hành vi một hàng OPEN). Docker có container của phiên khác (`ginsengfood-postgres-local`): không dừng/xoá/prune; test PostgreSQL một lệnh một lúc.
6. Bằng chứng: số ca thật từng lệnh, đỏ trước/xanh sau, mô tả từng ghim đã sửa (tệp:dòng cũ → mới).
7. Tuân thủ `chung/LUAT_SUBAGENT.md`. 8. Đầu ra ≤ 40 dòng.

## Diễn biến
- 25/11 21:4x phiên chính: tạo phiếu, giao coder.

## Bước kế tiếp chính xác
Phiên chính đọc diff, chạy lại test lọc, commit theo đường dẫn, ghi Sheet, cập nhật KE_HOACH §3 (N-01, N-02, N-03).
