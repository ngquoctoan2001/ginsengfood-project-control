# Tin nhắn nháp — m12, 10/11/2026 (chưa gửi; Lead sửa rồi tự gửi)

Giọng của Toàn, ngắn, một tin đủ để người nhận làm tiếp một mình. Chỗ `<…>` là điền tay.

## 1. Anh Tuấn — https 4 tên miền (quá hạn từ 07/11; chặn buổi M12-010 12/11 và diễn tập 13/11)
Anh Tuấn ơi, em nhờ anh chốt giúp phần nginx/DNS cho M1–M2 trước tối 11/11 hoặc chậm nhất sáng 12/11 nhé. Cụ thể: 4 tên miền của M1–M2 (ops, api-ops, pwa và trang truy xuất công khai) trỏ qua nginx ở `.60` vào Caddy trên `.61` cổng 80 (HTTP, Caddy không cần chứng chỉ), có chứng chỉ https hợp lệ, nginx truyền `X-Forwarded-For` và `X-Forwarded-Proto`. Khi xong anh cho em địa chỉ IP của nginx (dạng `/32`) để em khai vào cấu hình. Bản web mới gọi API bằng https, nên chưa có https thì mọi người chưa đăng nhập được, kể cả buổi thử với người thật 12/11. Anh cần gì từ em thì nói, em chuẩn bị luôn.

## 2. Phúc (cc Tài nếu M6 dùng) — khung giờ nâng `.61` (khoảng 11/11) và token M3
Phúc ơi, em nâng bản M1–M2 trên `.61` khoảng `11/11 lúc 14:00 (kéo dài khoảng 25–30 phút)`; API M1–M2 dừng khoảng 25 phút. Sau khi nâng, token M3 cũ sẽ bị 401 (khoá ký JWT đổi mỗi lần khởi động), anh lấy token mới giúp em và gọi lại `GET /v1/inventory/allocations` để chắc là thông. Hai việc em cần anh báo lại: (1) URL https nhận webhook outbox từ M1–M2 và khoá ký để em khai cấu hình (cần trước 12/11), (2) lịch anh làm adapter giữ hàng/tra phân bổ (đã quá 08/11, em cần biết để quyết cờ tắt hay bật). Anh Tài: M6 sẽ cần tài khoản máy `availability-v1` trên `.61`, em tạo lúc cutover, anh đừng gọi trước.

## 3. Chú Dũng — một câu hỏi + việc sắp tới
Chú Dũng ơi, cho con hỏi một câu để khoá sổ nghiệm thu: phiếu hủy hàng (FRM-23) duyệt chỉ cần Trưởng ngày + QC thôi, hay còn thêm tầng chủ sở hữu duyệt nữa? Tài liệu cũ ghi hai kiểu khác nhau (18/08 không có tầng chủ, 22/08 có), con đang theo kiểu không có tầng chủ. Ngoài ra khoảng `11/11 lúc 14:00 (kéo dài khoảng 25–30 phút)` khi nâng `.61`, con sẽ nhờ chú xác nhận bằng chữ một lần việc gỡ lô thử (m12.7, con gửi mã kiểm trước), mất chừng 10 phút. Và chú cho con xin trước 11/11 số ca và hạn dùng (`shelf_life_days`) của 19 sản phẩm để nhập khi chạy thật.

## 4. Lan — nâng `.61` và dữ liệu thật
Lan ơi, khoảng `11/11 lúc 14:00 (kéo dài khoảng 25–30 phút)` con nâng bản trên `.61`, Lan ở máy khoảng 25 phút giúp con. Lan sẽ nhận một xác nhận bằng chữ về việc gỡ lô thử (m12.7) cùng chú Dũng, con gửi chi tiết lúc đó. Trước 11/11 Lan gửi con giúp: danh sách kho + vị trí kho, ngưỡng tối thiểu/tối đa của 8 vật tư, tồn đầu kỳ, để nhập khi chạy thật 14/11.
