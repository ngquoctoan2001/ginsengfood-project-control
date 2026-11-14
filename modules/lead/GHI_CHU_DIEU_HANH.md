# Ghi chú điều hành

Những điều không có trong repo nào: phân công, thay đổi người, việc chờ bên ngoài. `/tong-hop-tuan` lấy tệp này điền mục
"Ghi chú điều hành của Lead" của prompt 3. Mỗi tuần một mục, mới nhất ở trên; Lead sửa thoải mái.

## Tuần 02/11 – 07/11/2026

- 07/11, D-lead-025: hạn dự án đổi thành **30/11/2026** (chạy thật, xong hết); 15/11 là mốc giữa kỳ: bản tối thiểu từng module.
  M7 chốt riêng D-m7-063: 15/11 luồng video ngắn thật + một video khoảng 90 giây; 30/11 chương trình 70 phút và phần còn lại.
- M3 có ba người, ba báo cáo (D-lead-024): Phúc giao diện + backend bán hàng; Tài vận chuyển, thanh toán; Toàn nối M3 → M8 gọi xác
  nhận, máy chạy thử business-platform trên .60, máy tự kiểm và đưa lên máy chủ.
- M9 (hoa hồng, chi trả, MISA, ngân hàng) do anh Mạnh làm trong business-platform, hạn 09/11, chậm nhất trước 10/11; Toàn rà từng lần
  gửi duyệt, từ 06/11 anh Mạnh tự gộp khi đạt điều kiện. Vai trò tài chính do chú Dũng chốt; MISA làm cùng kế toán.
- 03/11 bố trí máy chủ: .60 chạy business-platform (M3, M4, M9) và M5, M6, M7; .61 chạy M1–M2 và M8; .64 tổng đài. Anh Tuấn nhắn
  bản chạy chính thức dựng trên .60.

- 02/11 09:44, D-m34-003: Toàn nhận code kết nối đơn hàng M3 → M8 trong phiên `m34`, nhánh `toandeptrai`, task M3-023.
  Phần bán hàng còn lại của Phúc, vận chuyển/thanh toán và M4 của Tài giữ nguyên; chạm lõi đơn cần báo Phúc trước.
  Commit `547dd59a0` mới là cập nhật tracker, chưa phải mã tích hợp; lịch E01–E10 cần chốt lại.

## Tuần 26/10 – 31/10/2026

- Toàn nhận vai trò Lead, vẫn tự làm M1–M2 và M8, nhận thêm M7.
- Phúc nhận trọn M3, gồm cả phần máy chủ trước đây do lead cũ làm, để làm một mạch không phải chờ nhau. Mới nhận vài ngày nên Phúc
  vẫn đang làm giao diện, chưa bắt đầu phần máy chủ.
- Tài làm M4 và vận chuyển, thanh toán của M3; nhận thêm M5 và M6 vì liên quan trực tiếp tới M4. M5 đã bàn giao tài liệu, Tài đã bắt
  đầu làm. M6 Lead dọn tài liệu và bàn giao cho Tài ngày 31/10.
- M7: mã cũ là chương trình MC AI live, không còn hợp yêu cầu. Lead thay bằng repo mới `ginsengfood-golden-hour-video`, tận dụng phần
  tạo video Lead đã làm trước đó.
- M8 gần xong, đang chờ M3 và giấy chứng nhận định danh tên công ty.
- Từ 30/10 có Google Sheet theo dõi việc: AI tự ghi sau mỗi lần làm việc. Từ tuần này báo cáo theo một quy trình và bố cục chung.
- Tuần này M3 máy chủ, M5, M6, M7 báo cáo hiện trạng khi bàn giao và kế hoạch, không báo việc đã làm.
- 31/10: Lead dựng Project Control — mỗi luồng một phiên AI, mỗi lệnh chạy nhiều agent song song, Lead kiểm hằng ngày.
