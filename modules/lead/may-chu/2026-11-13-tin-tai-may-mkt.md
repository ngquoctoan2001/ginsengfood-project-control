# Tin Zalo cho Tài · 13/11/2026 · dựng máy mkt cho M5 + M6 (D-lead-034)

**Đã gửi 13/11** (Toàn báo). Tài khoản đăng nhập máy (Anh Tuấn gửi) Toàn nhắn riêng cho Tài, không dán vào nhóm, không ghi vào tệp này.
Gửi trong nhóm 3 người thì gõ lại `@` và chọn tên Tài để Zalo tag thật.

```text
@Tài máy mkt Anh Tuấn cấp rồi em: 192.168.1.98, cùng mạng LAN với .60, .61. Anh chốt M5 với M6 chuyển hẳn qua máy này luôn, không chạy trên .60 nữa. Em dựng giúp anh từ đầu, cả nền lẫn app.

- Máy mới chỉ có hệ điều hành với SSH. Tài khoản đăng nhập anh nhắn riêng em. Anh Tuấn dặn để hết dữ liệu trong /data cho dễ sao lưu và mở rộng, nên em để CSDL, file, log vào /data/m5 với /data/m6 nha.
- Cách chạy giữ như trên .60: CI đóng image, máy chỉ kéo image theo commit về chạy, kiểm /health, lỗi thì tự quay lui.
- Giờ M5, M6 nằm khác máy với .60 nên mấy đường gọi qua lại (như M5 gọi M4 /advise, M5 gọi M3 đọc trạng thái đơn, M7 gọi M5, M3 gửi sự kiện cho M6) đều đi qua LAN. Em ghi đủ vào phần gọi ra, gọi vào trong deploy/MODULE_DEPLOY_CONTRACT.md, mở cổng nội bộ chỉ cho đúng IP bên kia, không mở ra ngoài.
- Token M3_ORDER_STATE_SERVICE_TOKEN phía em đặt trên máy mkt, cùng giá trị với phía Phúc trên .60. Các biến trước giờ ghi "trên .60" của M5 (như AI_ADVISOR_MODE) giờ hiểu là trên máy mkt.
- HTTPS cho mkt.ginsengfood.vn anh đang hỏi Anh Tuấn, có tin anh báo em. Họp Go/No-go M4/M5/M6 giờ tính từ lúc mkt. trên máy này có HTTPS, chậm nhất vẫn 20/11.

Xong khi: M5, M6 chạy trên máy mkt, /health xanh, dữ liệu nằm trong /data, gọi qua lại với .60 được. Dựng xong em nhắn anh. Vướng gì nhắn anh.
```

## 13/11 15:10 · Tin nháp bổ sung (D-lead-037, Toàn gửi)

Tài ơi, anh đổi chút chỗ để dữ liệu trên máy mkt nha: thư mục đặt theo tên repo cho dễ nhận, không dùng m5, m6 nữa. Em để hết M5 + M6 vào /data/ginsengfood-marketing, sao lưu vào /data/sao-luu/ginsengfood-marketing. Nếu đã lỡ tạo /data/m5, /data/m6 thì em đổi tên sang luôn giúp anh. Docker em cũng để trong /data luôn nha (data-root với thư mục của containerd, bản Docker mới mặc định cất image ở /var/lib/containerd), log, bí mật, sao lưu cũng vậy, để Anh Tuấn sao lưu một chỗ. Cảm ơn em.
