# Tin nhắn nháp — Nguyễn Phát Tài — 27/11/2026

Chưa gửi. Nội dung dưới đây theo lượt rà32 task tại `f9318df5`; đã ghi W/X trên Sheet và đọc lại khớp32/32.

---

@Nguyễn Phát Tài ơi, anh vừa pull và review M5 tại `f9318df5`. Phần đăng nhập mail, quản lý quyền, UI và nền YouTube đã có nhiều thay đổi. Anh rà32 task cần review, chấm10 Đạt và22 Cần sửa; đã ghi từng ý ở cột W/X trên Sheet.

Em ưu tiên giúp anh hai lỗi này:

- **M5-165:** hai người sửa vai cùng lúc thì audit ghi sai vai trước. Anh bắt được ca thực tế trong test là ADMIN→ADS_VIEWER nhưng audit lại ghi OPS→ADS_VIEWER. Em đưa đọc/khóa và ghi audit vào cùng transaction, thêm test đồng thời.
- **M5-168:** đang refresh mà bấm Đăng xuất, response về trễ vẫn lưu token và làm giao diện trở lại trạng thái đăng nhập. Em chặn kết quả refresh cũ sau logout, thêm test ca này và kiểm lại tắt tab/mở lại.

Phần cần khép trước nghiệm thu:

- **081/083/092:** còn luật cảnh báo AL-01/AL-23, diễn tập cờ dừng trên .98, backup ngoài máy và cảnh báo backup ngừng. Restore DB 10 giây chưa tính được mất cả máy; em chốt DL-255 và bổ sung biên bản đúng phạm vi.
- **016/141:** nộp bằng chứng phân quyền 200/403+CLI và lệnh xoá chạy trên .98. Nguồn JWT đã đổi sang M5 tự ký; DL-217 đã ký rồi, không chờ lại các đầu vào cũ.
- **101/169:** code đã đổi nhãn nhưng chính sách còn ghi nhãn cũ. Em chốt DL-257, cách trả lời trung thực khi khách hỏi người hay máy và đồng bộ bản công khai.
- **103/114/121/151:** hoàn tất hồ sơ pháp chế, cập nhật Go/No-go/release notes và nhập các quyết định 18/11, 25/11 đã chốt. Đừng để tiếp các dòng chờ HTTPS hoặc chờ anh quyết việc anh đã trả lời.
- **002/017/074/122/126/145/166:** xác nhận bàn giao, nhãn/hash bộ đánh giá, các phần DL/câu chữ còn treo theo từng ghi chú. **153:** chốt DL-251 và làm rõ gate bị ghép nhiều lượt. **162:** gắn receipt anh duyệt diff R3 đúng bản nếu đã có.

10 task Đạt: **007,133,134,139,143,146,152,163,164,167**. Sáu task **036,042,051,053,104,135** vẫn chờ em cập nhật sau lần trả lại trước.

Anh chạy lại 217 probe đạt, 34 probe DB/Redis bỏ qua; web 525/525 đạt. Hai test bổ sung vẫn bắt ra lỗi 165/168 nêu trên.

Ngoài tập review, em cập nhật giúp anh **M5-110**: Sheet còn lượt SMK 24/11 là 1 đạt / 14 lỗi / 1 chưa chạy; **M5-102** cần receipt hồ sơ Meta theo quyền đã giao 25/11. **M5-004** cũng còn ghi máy .60 dù đã triển khai .98. YouTube 154–161 vẫn Chưa bắt đầu, em chốt lại lịch thực tế giúp anh.

Xong em cập nhật commit, bằng chứng test và phản hồi từng ý trên Sheet dùm anh nghen.
