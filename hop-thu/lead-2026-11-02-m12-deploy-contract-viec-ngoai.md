# Từ phiên m12 · 02/11 09:05 · ngoại lệ deploy contract M1–M2 + việc ngoài code (D-m12-005)

Lead duyệt 02/11 09:03 (`modules/m12/QUYET_DINH.md` D-m12-005): m12.18 A, m12.21 A. Hai việc thuộc tệp của phiên `lead`.

## 1. `C:\Projects\deploy\MODULE_DEPLOY_CONTRACT.md` — ghi ngoại lệ M1–M2 (m12.18 A)

Contract đòi một container, cổng 8000, `GET /health` (`MODULE_DEPLOY_CONTRACT.md:6-8`). M1–M2 thực tế:
- stack riêng `docker-compose.prod.yml` (ops-core): `db`, `migrate`, `seed`, `api`, `admin-web`, `public-trace`, `shopfloor-pwa`, `caddy` (80/443);
- API cổng 8080, health `/health/live`, `/health/ready`, `/health/startup` (`Health/OperationalHealthEndpoints.cs:12,37,55`);
- non-root (`USER appuser`/`nextjs`, `read_only: true`), cấu hình qua biến môi trường — hai điều này đã đúng contract;
- máy chạy thật = .61 (m12.4 A, D-m12-003), không đi qua bộ triển khai chung.

Phía m12 làm (WP09): thêm `GET /health` trần trả trạng thái tổng. Nhờ phiên `lead` ghi vào contract: M1–M2 là ngoại lệ "stack riêng
trên .61, nhiều dịch vụ, cổng API 8080 sau caddy", điều kiện giữ: `GET /health`, non-root, env, runbook lên bản/quay lui riêng
(`docs/runbooks/release/01-11-15-06-len-61-ban-152-migration-runbook.md`).

## 2. `modules/lead/VIEC_NGOAI.md` — thêm dòng m12 (m12.21 A)

| Việc | Ai gỡ | Cần trước | Ghi chú |
|---|---|---|---|
| Runner GitLab Linux cho ops-core + OIDC/khoá ký (cosign) cho job image/SBOM/ký | Tuấn | 07/11 | quá 10/11 → ngoại lệ có hạn, ghi như JWT |
| Tên miền + DNS + chứng chỉ HTTPS cho admin, trang truy xuất công khai, PWA xưởng trên .61 | Tuấn | 07/11 | DAST và kiểm rate limit công khai chờ việc này |
| Kênh cảnh báo thật + người nhận P1/P2 (`monitoring-alerting-runbook.md:53` đang `BLOCKED_EXTERNAL`) | Tuấn | 07/11 | quá 10/11 → ngoại lệ có hạn |
| Tài khoản máy `availability-v1` cho M6 (`module6/app/measurement/scale/recall_risk_mapper.py`), M7 (DL-060) trên .61 | Lead tạo khi luồng báo cần | 14/11 | m12 gộp vào WP02c/WP11 |

Tin soạn sẵn cho Tuấn: `modules/m12/ra-soat/2026-11-02-tin-nhan.md` §1 (Lead gửi).

## 3. Nhắc lại việc đang chờ phiên `lead`

`hop-thu/lead-2026-10-31-m12-c37-issued-schema.md` (hợp đồng `ISSUED` + operation tự nhả). Dữ kiện mới 02/11: repo contracts local
`08585c1` đang dở merge xung đột (`UU README.md`, `AA asyncapi/README.md`, `AA compatibility/README.md`, `AA contract-tests/README.md`);
`origin/main` = `a7832a4` = pin ops-core và có `schemas/ops/x03b/`. m12 cần trước 08/11 để kịp WP07b (mốc B 10/11).
