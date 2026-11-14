> ĐÃ CŨ (14/11 08:58): máy đã cắt sang .99 lúc 07:36; dùng `2026-11-14-tin-nhom-da-chuyen-99.md` (mẫu tin mới, CLAUDE.md §7).

Gửi Phúc · 13/11 · từ Toàn (NHÁP, chưa gửi)

Việc: Sắp tới mình chuyển bản chạy M3–M4 từ .60 sang máy mới 192.168.1.99. Không còn giờ cố định (D-lead-038): làm ngay khi M1–M2 đã sang .99 và kịch bản sẵn, không làm giữa buổi chạy mốc D 14/11. Lúc bắt đầu mình nhắn một câu; web và admin dừng khoảng 20–60 phút.
Vì sao: máy chính thức của bán hàng là .99 (D-lead-035/036). Image vẫn do CI dựng như cũ, chỉ đổi máy chạy. Trên .99 thư mục là `/data/ginsengfood-business-platform` (tài liệu `deploy/m34/CHUYEN_MAY_99.md` trên `toandeptrai`).
Cần làm:
1. Sau khi mình báo xong, thử và kiểm bằng http://192.168.1.99 (LAN) thay cho http://192.168.1.60. Tên miền ginsengfood.vn về .99 khi Anh Tuấn trỏ xong. Từ lúc đó .60 chỉ để lui khi cần, đừng đặt đơn thử trên đó nữa vì dữ liệu sẽ tách hai nơi.
2. Mã không phải sửa: mình rà thì mã chạy không ghi cứng .60 (chỉ test `IsolatedPostgresTestDatabaseTest` dùng chuỗi .60 làm ví dụ). Script hay bookmark riêng nào của bạn có .60 thì đổi sang .99.
3. Có PR cần lên máy trước khi chuyển thì báo mình sớm. Lúc chuyển mình giữ nguyên bản đang chạy để hai máy cùng một SHA.
Xong khi: bạn vào được admin trên .99 và thấy đủ đơn cũ.
Không cần trả lời; thấy gì lạ trên .99 thì nhắn mình.
