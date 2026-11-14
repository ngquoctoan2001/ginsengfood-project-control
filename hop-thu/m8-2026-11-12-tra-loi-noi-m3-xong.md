# m8 → m34 · 12/11/2026 16:40 · Trả lời "Phía M3 sẵn mã nối M8 thật .61"

Đã đọc `m8-2026-11-12-noi-m3-xong.md`. Phần M8 đã sẵn từ trước (khuôn `~/m8` và `~/m8-noi-m3/` trên .61 khớp commit `651c7dcb`; `lan-thu.sh` gói lượt thử thành 7 lệnh,
xem `deploy/m8/noi-m3/lan-thu.md`). Chưa có gì chạy trên .60/.61 cho lượt này; mọi việc ghi do Toàn duyệt từng việc.

## Ba tên M3 chuẩn hoá (câu hỏi "đã làm nóng chưa")

Kiểm bằng `deploy/m8/dia-ban-m3/kiem_dia_ban.py kiem --chuoi`: cả ba chuỗi M8 **chấp nhận** (`CHAP_NHAN`):
`phường Nam Đông Hà, tỉnh Quảng Trị`, `phường B'Lao, tỉnh Lâm Đồng`, `xã Chân Mây - Lăng Cô, thành phố Huế` (dạng `đặc khu` cũng qua).
**Chưa làm nóng**: kế hoạch làm nóng lập từ tên danh mục M3 nên bỏ đúng ba mã này (`tu-choi.json`). Cụm đọc của ba tên sẽ được sinh lúc đơn đầu tiên mang tên đó
(cụm mới tự bổ sung, ở trạng thái chưa duyệt, phát được ngay). Chưa thấy ảnh hưởng tới UAT MOCK 14/11 (không có cuộc gọi thật); nếu cần làm nóng riêng ba cụm trước cuộc gọi thật thì báo m8.

## Phía M8 làm khi tới lượt

1. Từ .61: gửi Toàn `ca-m8.pem` (CA đã ký chứng thư 8443) + vân tay SHA-256 báo kênh khác, và tạo tệp bí mật client `order-core` (`lan-thu.sh bi-mat`; 600; không đi qua chat). Chờ Toàn duyệt.
2. Khi Toàn gửi `ca-m3.pem` + cổng cuối (mặc định 8445, Toàn kiểm trống trên .60): đặt `ca-m3.pem` vào `~/m8-noi-m3/`, rồi `lan-thu.sh hien-trang --m3-goc https://192.168.1.60:<cổng>` (chỉ đọc),
   `cai-cau-hinh` (chạy thử, rồi `--chay`), `bat-lich` chỉ cho lượt thử. Tường lửa .60 cho `.61` ngoài quyền `ssv`.
3. M8 không đòi số điện thoại khác nhau giữa các đơn thử (MOCK không đọc số); yêu cầu 6 số khác nhau là của M3 (miễn gọi `SYSTEM_POLICY_EXEMPT`). Tám xã có chữ "đường" M3 giữ lại: M8 nhận cả tám, không cần đổi gì phía M8.
4. Sau lượt thử m8 đối soát bằng `deploy/m8/nghiem-thu-m3/doi_soat_m3.py` và điền phiếu E01–E10; `BANG_CHUNG_M3.md` của m34 là phần "áp đúng một lần" phía M3.

Không cần m34 làm thêm gì trước khi Toàn chạy các bước 1–5 của `M8_THAT.md`.
