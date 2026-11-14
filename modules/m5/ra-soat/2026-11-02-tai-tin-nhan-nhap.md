# Tin nhắn nháp cho Tài — rà M5 ngày 02/11/2026

Đã soạn theo lệnh Lead; chưa gửi. Nguồn: [bảng 29 task](2026-11-02-tai-toan-bo-task.md), bản rà chốt 12:01, main b6e3ca4. Nhận xét đã ghi đủ 29 ô ở cột X/Ghi chú Lead trên [Sheet M5](https://docs.google.com/spreadsheets/d/1Fxftz_B9zQXCREcmDvvGjxqRwqI_ux1klOhoaCbIJnY/edit#gid=1008350356).

---

@Nguyễn Phát Tài ơi, anh mới review đủ 29 task Module 5 đang Hoàn thành/Chờ review tại mốc commit b6e3ca4, có ghi ở cột X - Ghi chú Lead trên Sheet. Có 21 task đạt phạm vi, 5 cần sửa và 3 cần bổ sung bằng chứng. Em coi lại dùm anh:

- **M5-015:** API cập nhật Page vẫn nhận enum sai. Em chặn trước khi lưu rồi bổ sung test.
- **M5-040:** Còn câu hỏi dùng sản phẩm cho trẻ ôn thi bị xếp BUY_SIGNAL, chưa chuyển người. Em bổ sung nhận diện và test ca này.
- **M5-060:** Còn 2 mẫu địa chỉ chữ thường chưa được che. Em sửa và thêm vào bộ test.
- **M5-061:** Khi cập nhật cờ đồng thời, audit có thể ghi sai giá trị trước/sau. Hiện mới tái hiện bằng fake DB; em sửa rồi kiểm thêm trên Postgres riêng.
- **M5-082:** Log JSON còn lọt giá trị password/api_key trong object lồng nhau. Em bổ sung che theo khóa và test.

Thêm 3 task cần làm rõ: **M5-002** xác nhận bàn giao trong WT-002; **M5-010** ghi rõ ngoại lệ probe cho thay dependency và bằng chứng test thay thế; **M5-030** chốt tiêu chí fixture thật so với bộ giả lập đã được duyệt.

**M5-105:** Anh đã duyệt cả 7 mẫu và giờ CSKH **8:00–20:00 hằng ngày**. Em cập nhật DL-170, tài liệu và Sheet, không cần xin duyệt chữ lại; phần triển khai và kiểm gửi vẫn làm tiếp.

CI main đang xanh, nhưng các ca kiểm bổ sung vẫn tái hiện được những chỗ trên.

Xong em cập nhật commit/PR, kết quả test rồi phản hồi từng ý trên Sheet dùm anh nghen.
