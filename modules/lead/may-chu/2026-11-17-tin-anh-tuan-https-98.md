# Tin gửi Anh Tuấn · 17/11/2026 · cổng vào HTTPS trên .98 + việc máy còn treo (Toàn tự gửi)

> **KHÔNG GỬI — đã thay bằng mục 9 của [kế hoạch tên miền public](2026-11-17-ke-hoach-ten-mien-public.md)** (Toàn 17/11: làm chuẩn một lần).

Nguồn: Anh Tuấn gọi Toàn tối 16/11 sau khi nhận tệp Excel máy chủ (5 ý: HTTPS hết; bên mình mua SSL Mắt Bão, cài lên .98, IP public 443 trỏ về .98,
Caddy chia đường; chỉ phân giải tên làm việc với bên ngoài, trỏ IP tĩnh; ít tên miền con, phần còn lại làm thư mục con; một chứng chỉ, proxy
không bị ảnh hưởng khi cập nhật app). Toàn chốt 17/11 (D-lead-057): giữ danh sách tên như cũ, public hết vì app nào cũng có đăng nhập; proxy đặt ở .98.
Anh Tuấn: chỉ tin nhắn, không tệp kèm. Gộp luôn việc treo: máy video M7 + máy thử (m7), .64 + sao lưu ngoài máy + chỗ cất khoá (tin m8 14/11
chưa gửi), khoá công khai JWT quản trị marketing (m5/m6, D-m6-018/021). Bỏ câu IP nginx (m12.100): proxy là .98.

## Tin Zalo

```text
Dạ anh Tuấn, em tính lại theo mấy ý anh nói hôm qua rồi nha anh. Bên em chốt vầy:
- Cổng vào bên em lo: em mua SSL bên Mắt Bão, dựng proxy trên máy .98, proxy chia về từng máy theo IP nội bộ cố định. Proxy chạy riêng, cập nhật app nào thì mấy app khác vẫn chạy bình thường.
- Tên miền em xin giữ như cũ: ginsengfood.vn (với www), ops, pwa, trace, mkt, video. Trang cho khách thì phải mở sẵn rồi, còn trang quản lý cái nào cũng có đăng nhập, mà anh em về nhà cũng cần vô coi, nên em để chạy ngoài Internet luôn, không gói vô mạng nội bộ.
- Phía ngoài chạy https hết, ai gõ http thì tự chuyển qua https.

Em hỏi anh mấy chuyện cho khớp nha:
1. Anh chuyển giúp em cổng 443 với cổng 80 của IP công ty về .98 được hông anh? Cổng 80 để tự chuyển qua https.
2. IP đó giờ còn chạy cái gì khác của công ty hông anh (như tên staging)? Chuyển hết về .98 thì em có cần chừa đường cho mấy cái đó không?
3. Anh nói https hết là phía ngoài thôi, hay đoạn từ proxy vô các máy trong mạng cũng phải https? Bên em tính ngoài https, trong mạng giữ như giờ vì đã khoá tường lửa từng máy, anh thấy được hông.
4. Chứng chỉ em tính mua loại wildcard bên Mắt Bão, một cái xài chung cho hết các tên. Anh thấy được hông, hay anh muốn loại khác?
5. Ngồi trong công ty gõ tên miền là không vô được, vì router không quay vòng vô trong. Anh bật quay vòng trên router, hoặc trỏ DNS nội bộ mấy tên đó về .98 giúp em được hông? Không thì anh em ở công ty phải vô bằng 4G.
6. Proxy nằm trên .98 thì máy này gánh hết đường vô, mà RAM .98 giờ chỉ hơn 3 GB, hơi chật. Anh nâng RAM .98 giúp em được hông anh?

Tiện em hỏi luôn mấy việc còn treo nha anh:
7. Máy ảo cho Video Giờ Vàng (Ubuntu 22.04 server, không cần card, khoảng 8 nhân, RAM 16 GB trở lên, ổ 1 TB, ra được Internet) với máy thử giống .99, anh tính khi nào có?
8. Máy tổng đài .64: em xin một khung giờ bảo trì có quyền sudo khoảng 2 tiếng để nâng tổng đài lên bản mới, trước 18/11 nếu được, anh chọn giờ ít gọi nhất giúp em.
9. Chỗ cất sao lưu ở máy hoặc ổ khác hẳn .99, cho các phần mềm ghi bản sao lưu vô. Giờ sao lưu còn nằm chung máy, hư máy là mất luôn. Anh cho em biết chỗ đó được bao nhiêu GB nha.
10. Chỗ cất khoá của tổng đài với người giữ dự phòng ngoài em, anh với em chốt giúp nha.
11. Khoá công khai để kiểm đăng nhập trang quản trị marketing anh gửi em trước 18/11 nha; token anh phát nhớ có giờ phát, vai người dùng, hạn tối đa 30 ngày.

Anh trả lời theo từng số giúp em là được. Em cảm ơn anh nhiều nha.
```

## Sau khi Anh Tuấn trả lời

- Câu 1–6 → phiên `lead` dựng proxy trên .98 (Caddy, thư mục riêng dưới `/data`, ngoài compose M5/M6), báo Tài trước; Toàn mua chứng chỉ.
- Câu 7 → báo phiên m7; câu 8–10 → phiên m8 (`modules/m8/ra-soat/2026-11-14-tin-anh-tuan.md` coi như đã gửi gộp ở tin này); câu 11 → phiên m5, m6.
