# Từ phiên `m7` · 03/11/2026 · M7 lệch bộ triển khai chung, cần chốt ngoại lệ

Nguồn: `/ke-hoach` m7 ngày 03/11/2026 (scout chỉ đọc); `modules/m7/SAN_SANG.md` cổng G5.
Thiết kế M7: `ginsengfood-golden-hour-video/docs/03-design/SAD.md` §13 (docs v2 đã duyệt 01/11/2026).
Bộ chung: `C:\Projects\deploy\MODULE_DEPLOY_CONTRACT.md` (deploy @`225c586`).

## Việc

Phiên `lead` (cùng anh Tuấn) chốt cho từng điểm dưới đây: sửa contract, thêm phụ lục ngoại lệ cho M7, hay M7 đổi theo contract.
- Cần trước khi thiết kế T015 (Dockerfile, compose). Theo nhịp đo hiện tại, T015 rơi vào khoảng 10/11/2026.
- Bắt buộc trước T103 (lên .61). Chưa có lịch T103; lên .61 chỉ khi Lead cho.

## 9 điểm lệch

| Điểm | M7 (SAD) | Contract |
|---|---|---|
| Số container | 7: `m7-edge`, `m7-web`, `m7-api`, `m7-worker`, `m7-migrate`, `m7-db`, `m7-objstore` (SAD:1638-1646); thêm worker trên máy để bàn | 1 container (`:7`) |
| Health | `/health/live`, `/health/ready`; web `/web-health` (SAD:1726-1729) | `GET /health` (`:7`, `:22`) |
| Cổng | `m7-edge` publish 6700; api 8080, web 3000 nội bộ | 8000 nội bộ (`:7`, `:21`) |
| Proxy | Caddy riêng `m7-edge` (DL-085) | nginx chung, `location` theo prefix (`:46`); `nginx/conf.d/module7.conf:16-20` còn trỏ `m7-mc-ai-live:8000` |
| Worker ngoài máy chủ | `m7-studio-worker` trên máy để bàn, gọi vào `m7-edge:6700` | Không có khái niệm này |
| Kho S3 | `m7-objstore` SeaweedFS (DL-086) | Chỉ có postgres/redis chung |
| DB | PostgreSQL riêng `m7-db` | Postgres chung, schema riêng (`:24`) |
| Migration | Container `m7-migrate` riêng | `alembic upgrade head` lúc khởi động (`:25`); ops-core đã có tiền lệ migrate riêng |
| Worker nền | `m7-worker` tách, chạy được nhiều bản | Worker in-process, 1 instance (`:26`) |

Khớp sẵn: chạy non-root, cấu hình bằng biến môi trường, không bake bí mật.

## Kèm theo
- `deploy/module7/Dockerfile` còn là bản Python MC AI Live cũ. `MODULE_DEPLOY_CONTRACT.md:47` đang trỏ nó làm mẫu cho 9 module.
- Tiền lệ nhiều container: `deploy/reference/docker-compose.ops-core.yml` và `Caddyfile.ops-core`.
- `deploy/docker-compose.yml:57,60,78` còn mật khẩu mặc định dạng `${VAR:-…}` (DL-O63, DL-O64). Phiên m7 không chép giá trị.
- `ginsengfood-contracts` @`08585c1` chưa có hợp đồng M7 Giờ Vàng. `openapi/business-platform/mc-ai-live.v1.yaml` là hợp đồng MC AI Live cũ, chờ khai tử (DL-074).
