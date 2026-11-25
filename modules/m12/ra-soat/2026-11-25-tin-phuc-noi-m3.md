# Tin nháp cho Phúc: nối M3 ↔ nhà máy tuần cuối (Toàn tự gửi) — bản 2, 25/11 13:0x

Soạn bởi phiên m12 sau khi đọc `.99` chỉ đọc (m12.221). Giọng anh nhắn em, ngắn, không đường dẫn hay mã. Toàn duyệt gửi hôm nay (m12.222).

---

Phúc ơi, anh coi bên máy chủ .99 thấy M3 đang gọi nhà máy ngon lành rồi: một ngày hơn 600 lần hỏi bán được, không lỗi nào hết. Cảm ơn em nghen.

Mấy chuyện anh báo em:
1. Nhà máy trả "không bán được" là đúng, vì chưa có mẻ nào. Sáng thứ Sáu 27/11 xưởng làm mẻ thật đầu tiên, xong anh nhắn em, em coi M3 thấy số hộp có khớp với kho không nha.
2. Em giữ nguyên chuyện chưa bật giữ hàng thật, em cứ để chế độ quan sát tới khi anh nhắn.
3. Hợp đồng nối bên nhà máy anh vừa đưa lên kho chung bản mới nhất, em ghim lại giùm anh nha.
4. Bản M3 đang chạy trên máy chủ .99 chưa thấy trên kho chung, em đẩy lên giùm anh để anh đối chiếu.
5. Bên nhà máy có hai kho cùng tên "Kho Bình Phú", em đang nối cái thứ hai đúng không? Anh sẽ ngừng cái còn lại sau khi hỏi Lan.

Em trả lời giùm anh mục 4 và 5 là được. Cảm ơn em.

---

## Ghi chú cho Toàn (không gửi)

- M3 trên .99 (đọc 25/11, chỉ đọc): `OPS_CORE_ENABLED=true`, gọi `http://192.168.1.99:5000`, bật danh sách kho + danh sách SKU + hạn mức giữ hàng; **tắt** `STOCK_BALANCES` và `LIFECYCLE`; 24 giờ: 627 lần `availability/check`, 8 lần xin token, 1 lần `GET /v1/skus`, tất cả 200, 0 lỗi 401/403/429, 0 phân bổ giữ hàng.
- Hai kho cùng tên hiển thị nhưng KHÁC LOẠI: `WH-20112026-000001` = kho nguyên liệu, `WH-20112026-000002` = kho thành phẩm (M3 nối `…002`, đúng). Câu "sẽ ngừng cái còn lại" ở mục 5 của bản 2 là SAI (D-m12-137): không ngừng, chỉ đổi tên; dùng đoạn "Đính chính" ở cuối.
- Bản M3 trên .99 không có trên kho chung (auditor 25/11, `5b68a2162`), nên mục 4.
- `stock-balances` M3 đang tắt: bật sau khi có tồn thật (sau 27/11); lúc bật, đối chiếu với bộ chạy cục bộ 18/18 PASS (hôm nay).

---

## Đính chính gửi Phúc (13:1x; Toàn tự gửi vì tin bản 2 đã gửi có câu sai)

Phúc ơi anh nói sai một chuyện nè: hai cái kho "Kho Bình Phú" không phải kho trùng, một cái là kho nguyên liệu, một cái là kho thành phẩm, em đang nối đúng cái thành phẩm rồi. Anh không ngừng cái nào hết, chỉ đổi tên cho dễ phân biệt thôi nghen. Em cứ giữ nguyên như hiện tại.
