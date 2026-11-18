# Tin nháp Toàn gửi Tài · khoá máy M6 gọi M1–M2 trên `.99` · 17/11/2026 (CHƯA GỬI)

Theo D-m12-108 (m12.123 A): principal `SVC-M6-ADS-RISK` trên `.99` đã xoay; khoá cũ (seed dev) hết hiệu lực từ 17/11 ~14:2x.
Gửi kèm: TỆP khoá `m6.secret` (Toàn chép từ `.99` `/data/ginsengfood-ops-core/m6.secret` qua kênh an toàn, KHÔNG dán nội dung vào Zalo/chat)
và phần kỹ thuật dưới đây (gửi dạng tệp .md).

## Kỹ thuật (tệp kèm)
- client_id: `SVC-M6-ADS-RISK`; khoá mới: nội dung tệp `m6.secret` (44 ký tự base64), credential phiên bản 2, hạn 180 ngày, nên xoay lại trước ~150 ngày.
- Lấy token: `POST http://192.168.1.99:5000/v1/service-tokens` (client credentials), quyền duy nhất `SELLABLE_CHECK`. Cổng 5000 của `.99` đang mở cho `.98`.
- Khoá cũ trả 401 `INVALID_CLIENT` từ giờ. Cấu hình M6 (biến khoá M1–M2 trong `.env` của M6 trên `.98`) cần thay bằng khoá mới; không ghi khoá vào git, log, chat.
- Kiểm: gọi lấy token bằng khoá mới ra 200 có `access_token`, rồi gọi kiểm điều kiện bán như M6 đang dùng.

---

Tài ơi, anh vừa đổi khoá máy để M6 gọi M1–M2 trên máy .99 rồi nha, khoá cũ hết xài được. Anh gửi em tệp khoá mới, em thay vô cấu hình M6 rồi thử lấy token, chạy được thì báo anh một tiếng nghen.

Khoá này chỉ để trong tệp cấu hình thôi, đừng dán vô Zalo hay commit lên git nha em. Chi tiết anh để trong file.
