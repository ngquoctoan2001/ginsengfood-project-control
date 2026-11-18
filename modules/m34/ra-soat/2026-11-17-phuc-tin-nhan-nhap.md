# Tin nháp gửi Phúc · 17/11/2026 (chưa gửi — Toàn gửi; sửa theo D-m34-098 13:1x)

Gửi kèm: `ra-soat/2026-11-17-phuc.md` (bản rà) và 3 phụ lục nhóm A, B, C trong `ra-soat/evidence/2026-11-17-phuc/` (từng task, việc phải làm). Ghi chú cũng đã nằm trên Sheet cột Ghi chú Lead.

## Phúc

Phúc ơi, anh mới rà xong 39 task của em trên Sheet. Đạt 3 cái thôi (giao diện đăng nhập bằng mã, chọn phương thức đăng nhập bên IAM, gỡ page.route ở mấy spec quản trị), còn lại 36 cái anh để Cần sửa, việc phải làm anh ghi từng task trong file với trên Sheet nha.

Phần đọc M12 em làm chắc tay đó, khớp hợp đồng với bản M2 mới trên máy 99, test chạy xanh hết. Nhưng lên máy chưa bật được vì thiếu 3 cờ bật màn đọc, em khai thêm 3 cờ đó giùm anh, anh đưa vô bộ triển khai. Phần bộ ngắt mạch dùng chung với lệnh kiểm bán hàng anh tự tách bên anh.

Chuyện lớn nhất là em vẫn đẩy thẳng PhucApu lên dev, từ đầu tháng tới giờ chưa có PR nào, CI không chạy lần nào. Bữa 16 đẩy lên làm dev đỏ, máy không ra được bản mới gần nguyên ngày. Từ giờ em vô dev chỉ qua PR thôi nghen, chờ CI chạy rồi anh coi, không đẩy thẳng nữa.

Mấy cái gấp em làm trước giùm anh:
- Sửa 2 test rào mã SKU gốc đang đỏ trên dev, đừng hạ ngưỡng test.
- Gỡ đoạn "Branch Rule" em thêm vô AGENTS.md với CLAUDE.md, nó bắt mọi người làm trên PhucApu, sai với nhánh của anh, của Tài, của chú.
- Đăng nhập bằng mã email đang báo "không có tài khoản" khi gõ email lạ, vậy người ngoài dò được email nào có tài khoản. Anh chốt rồi: quay lại trả lời giống nhau cho mọi email như đã thống nhất, em sửa lại giùm anh nghen.
- Mấy chỗ em tự chọn phương án rồi bỏ bớt tiêu chí bên quản trị hệ thống (6 chỗ, anh ghi trong file), em gom lại thành một bảng gửi anh chốt một lần.
- Phần em làm hôm nay (ngày lễ, IAM, quy luật 24/7, tồn kho) chưa push lên, nhớ push qua PR rồi ghi mã commit vô Sheet. Ngày lễ em coi nhánh của chú trước, chú làm màn đó rồi, đừng làm trùng.

Thêm chuyện này nha: chiều nay anh nối M3 với M12 trên máy 99, 18 sản phẩm bên mình đang ghi đơn vị "suất" mà kho M12 ghi "hộp", anh đổi hết qua "hộp" rồi. Em sửa luôn chỗ gói dữ liệu sản phẩm cho thành "hộp" giùm anh, kẻo máy mới dựng lại ra "suất" là nạp liên kết không được.

Chi tiết từng task anh để trong file với trên Sheet hết rồi, có gì chưa rõ thì hỏi anh.
