# Tin nháp Toàn gửi Tài — 21/11 · giữ số migration 405–409 cho luật gọi M8 · CHƯA GỬI

Gửi một mình tin này cho Tài (không cần kèm tệp).

## Tin (Zalo)

Tài ơi, phần luật gọi cấu hình được của M8 bên anh sắp vô nhánh dev, có mấy file cập nhật cơ sở dữ liệu (migration) đánh số từ 405 tới 409. Em đang làm CONV-STATE có lấy số nào từ 405 trở lên chưa? Nếu có rồi thì nói anh biết, anh đổi số bên anh cho khỏi đụng nhau nghen. Chưa lấy thì em chờ anh gộp vô dev rồi lấy số kế tiếp (từ 410) giùm anh.

## Ghi chú cho Toàn (không gửi)

- Kiểm 21/11 05:0x: `origin/dev` còn dừng ở V404, không nhánh nào trên origin có V405 trở lên (kể cả nhánh Tài/Phúc/chú Dũng), nên chưa thấy Tài giữ số.
- Số đã dùng trong chồng M3: V405–V406 (hold chờ nhân viên + ack/luật), V407 (quyền `IVR.RULE.*`, trang Luật gọi), V408 (dấu thu hồi không xếp được), V409 (lần gọi lại do nhân viên bấm). Sổ `application.yml:48` bật `out-of-order: true` nên số có thể lệch thứ tự vẫn chạy, nhưng hai người dùng cùng một số thì Flyway báo lỗi.
- Gửi trước khi Toàn nhờ Phúc đưa bản mới lên .99 (28/11).
