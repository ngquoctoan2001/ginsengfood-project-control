# Từ phiên `m12` · 03/11/2026 13:3x · Health check ops-core: `GET /health`, Caddy và header Host

Liên quan: D-m12-005 (m12.18 A), D-m12-013 (m12.33 A, m12.34 A). Phiếu `modules/m12/wp/M12-WP09.md`. Verifier R2 độc lập ĐẠT cả 3 vòng.

## Đã có trong repo ops-core

- `GET /health` (`25fb975bf`, đã push): ngữ nghĩa giống `/health/ready`, ẩn danh, 200/503. Dùng được làm health check của compose chung.
- Caddy (`12897cdf7`, chưa push): `/health*`, `/metrics*` chỉ mở cho allowlist, chỉ `/health/live` mở ngoài.
  Đã chặn các đường vòng `/health/`, `/health/ready/`, `/%68ealth/` (lỗ có từ CONT-002).
- Healthcheck container gửi `Host` (`6a5e40814`, chưa push).
  - Production đặt `AllowedHosts` = đúng `API_DOMAIN`, nên `curl localhost` nhận 400 và container mãi `unhealthy`.
  - Compose prod nay gửi `Host: ${API_DOMAIN}`; HEALTHCHECK của image lấy host đầu của `AllowedHosts`.
- Smoke trong `tools/deploy/Deploy-Stack.ps1`, `Rollback-Stack.ps1` gửi `Host` (`911305a7f`, chưa push).
  `API_DOMAIN` thiếu hoặc sai dạng thì dừng hẳn (`API_SMOKE_HOST_REQUIRED`/`_MISMATCH`), không lùi về localhost.

## Việc cho phiên `lead` (deploy contract, compose chung)

- Compose chung đang chạy ops-core ở Development, `AllowedHosts=*`, cổng 5000. Khi chuyển Production, healthcheck phải gửi `Host` như trên.
  Nếu không, container báo `unhealthy` dù app chạy đúng.
- Có thể đổi health check của ops-core trong deploy contract sang `GET /health`.
- Đợt dựng lại .61 ngày 05/11 (D-m12-009, D-m12-012): phiên m12 sẽ chốt ở bước chuẩn bị 04/11.
  Compose mới ở `~/ginsengfood/ops-core-deploy` dùng compose prod + `Deploy-Stack.ps1` của repo, hay compose tự viết?
  Nếu tự viết, phải chép khối healthcheck có `Host`.
- Env file trên .61 phải ghi `API_DOMAIN=<host>` trên một dòng trơn: không `export`, không chú thích cuối dòng.
  Compose và script đọc hai dạng này khác nhau, khi đó deploy dừng ở smoke sau `up`.

**Cập nhật 03/11 14:1x (sau D-lead-018):** câu hỏi compose ở trên hết hiệu lực. .61 nay dùng `~/m12/compose.yml` do phiên `lead`
dựng (chỉ `image:`), phiên m12 giữ thư mục này. Khi API .61 chuyển Production, phiên m12 tự chép khối healthcheck có `Host` vào
compose đó (gói M12-WP13/WP02c). Phiên `lead` chỉ còn hai việc: deploy contract (`GET /health`) và compose chung.

Đọc xong thì chuyển tệp sang `hop-thu/xong/`.
