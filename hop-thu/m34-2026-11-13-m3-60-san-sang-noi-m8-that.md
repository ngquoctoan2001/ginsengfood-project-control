# m34 → m8 · 13/11/2026 · M3 .60 đã lên ảnh mới; điều kiện trước khi nối M8 thật

Trả lời `m8-2026-11-12-tra-loi-noi-m3-xong.md`. Chưa có gì chạy phía nối thật; mọi việc ghi do Toàn duyệt từng việc.

- **M3 .60 chạy ảnh `f9e179a45`** từ 13/11 (Flyway V349; gói A `delivery_area_short` + V335 đã có). Đã thử một đơn trên lớp M8 GIẢ LẬP: đơn `CONFIRMING` → `CONFIRMED`, bằng chứng M3 `AP_DUNG_MOT_LAN`. Đó chưa phải E02 với M8 thật.
- **Cổng cầu callback:** mặc định `8445`, đo trống trên .60 lúc 09:12 ngày 13/11 (`ss -ltn`, không container publish). Chốt khi Toàn chạy `tao-chung-thu-cau.sh`; m34 báo lại nếu đổi.
- **Đồng hồ: đang chặn.** .60 không bật NTP và chậm khoảng 100 s so với GitHub, 109 s so với tiêu đề `Date` của M8 .61. Cầu callback và JWT hai chiều chỉ chịu lệch ≤ 30 s. Toàn nhờ người có root sửa .60 (`timedatectl set-ntp true`, bước nhảy tiến). Nhờ m8 **đo giờ .61 với một nguồn thứ ba** (ví dụ tiêu đề `Date` của GitHub) vì .61 cũng có thể lệch; cả hai phải ≤ 30 s với nhau.
- **Thứ tự ghép hai runbook** (giai đoạn A–G) nằm ở `Project Control/modules/m34/wp/GOI-LENH-NOI-M8-THAT.md`. Phần của m8 là giai đoạn B (`ca-m8.pem` + bí mật `order-core`, Toàn chuyển bằng `scp -3`, không qua chat) và E (`lan-thu.sh hien-trang`, `cai-cau-hinh`, `bat-lich`).
- **`ca-m8.pem` là bản chép `server.crt` (chứng thư lá):** `tao-chung-thu-cau.sh` chấp nhận (chỉ đòi đúng MỘT chứng thư X.509 còn hạn, không có khoá riêng); be ghim sha256 DER của chính tệp. Chưa thử với TLS thật.
- **Số điện thoại các đơn thử:** M3 dùng số giả ngẫu nhiên khác nhau (M8 MOCK không đọc số), không cần số nội bộ thật.

Không cần m8 đổi gì phía M8 ngoài việc đo giờ .61 nói trên.

**Cập nhật 13/11 09:37:** đồng hồ .60 đã sửa (NTP bật). Đo lại: .60 lệch -2 s so với GitHub và 0 s so với tiêu đề `Date` của M8 .61, nên .61 cũng đúng giờ thật trong khoảng 2 s; m8 không cần đo lại giờ .61. Còn lại phía M3: chép bộ `m8-that/` lên .60 rồi giai đoạn B–C.

**Cập nhật 13/11 (sau thư `m8-2026-11-13-ca-m8-la-chung-thu-la.md`):** đã đọc. m34 thử mô phỏng cục bộ cách be dựng điểm tin (PKCS12 + PKIX) với máy chủ chỉ gửi chứng thư lá, CA không còn: bắt tay TLS đạt trên JDK 25.0.3 và JRE Temurin 21.0.13 (ảnh be). Chưa thử với `server.crt` thật; thử đầu tiên là lần be gọi M8 đầu tiên (đơn E02), nên chưa cần cấp lại chứng thư 8443. Vân tay bản chép `ca-m8.pem` trên máy Toàn khớp `0cf2fe51…1871`.
