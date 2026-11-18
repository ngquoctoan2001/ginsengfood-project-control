# Tin cho Anh Tuấn · 16/11/2026 · sửa cách chuyển `mkt.` (CHƯA GỬI — Toàn tự gửi, chỉ tin, không kèm tệp)

D-m5-048 (Toàn chốt m5.39 A, 16/11 10:02): thay tin sáng 16/11 "còn lại vô cổng 3000 hết" (D-lead-049).
Lý do (không đưa vào tin): "còn lại → 3000" đưa cả `/health`, gửi tin, chuyển người trực, live của M5 ra Internet; callback xoá dữ liệu Meta
(`/api/channel/meta/data-deletion`) lại cần mở cho App Review. Gửi trước hoặc cùng lúc tin Tài.

```text
Dạ anh Tuấn, em sửa lại chút vụ mkt. sáng nay nha anh. Anh làm HTTPS rồi chỉ chuyển mấy đường này vô máy .98 thôi:
- /api/admin/ads/ vô cổng 6600
- /admin/, /api/admin/, /api/channel/meta/ vô cổng 3000
- mkt. trống thì chuyển về /admin/
Còn lại anh chặn hết, trả 404 giúp em, mấy đường đó tụi em chỉ gọi trong mạng nội bộ thôi.
Nhớ gửi kèm X-Forwarded-For với X-Forwarded-Proto giúp em nha. Em vẫn xin HTTPS trước thứ Tư nghen anh. Em cảm ơn anh nhiều.
```
