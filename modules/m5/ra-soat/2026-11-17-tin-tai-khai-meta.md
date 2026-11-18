# Tin cho Tài · 17/11/2026 chiều · `mkt.` đã có HTTPS → khai Meta (ĐÃ GỬI — Toàn báo 17/11 19:40)

Nguồn: phiên lead báo tên miền public chạy thật 17/11 ~16:3x (proxy Caddy .98, chứng chỉ Sectigo wildcard hết hạn 03/06/2027).
Phiên m5 kiểm lại từ máy Toàn 16:38: `https://mkt.ginsengfood.vn/` 301 → `/admin/`; `/api/admin/ads/dashboard` 401; `/health` 404;
`/api/admin/gateway/evidence` 404; `GET /api/channel/meta/webhook` không token 403 (đường webhook tới được M5 qua HTTPS).
Không cần tệp kèm mới: chi tiết nằm ở tệp đã gửi sáng nay (`2026-11-17_lead_m5-https-mkt.md`, mục 3 và 5).

## Tin Zalo

```text
Tài ơi, mkt. có HTTPS rồi nha, từ chiều nay khoảng 4 giờ rưỡi. Em khai với Meta liền giúp anh: webhook, đường xoá dữ liệu, với link chính sách riêng tư, như file anh gửi sáng nay. Khai xong Meta gọi thử đạt thì em chụp màn hình đã che gửi anh nghen.
Chỗ M5 gọi qua bên .99 vẫn giữ địa chỉ nội bộ như cũ nha, đừng đổi sang tên miền.
Họp Go/No-go tính từ mốc HTTPS này, chậm nhất thứ Sáu 20/11, em gom bằng chứng chạy thật trên .98 cho kịp hen.
```
