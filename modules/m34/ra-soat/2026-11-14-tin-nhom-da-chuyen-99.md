# Tin Toàn gửi nhóm (Phúc, Tài) — đã chuyển xong sang .99 (14/11/2026) · CHƯA GỬI

Mẫu `chung/MAU.md` §3. Thay các tin nháp cũ báo TRƯỚC giờ cắt (`2026-11-13-tin-{phuc,tai}-chuyen-may-99.md`, nay đã cũ vì cắt xong
14/11 07:36). Anh Mạnh đã nghỉ (Toàn báo 14/11): không gửi, không nhắc trong tin. Phần kỹ thuật ở mục (b) gửi kèm cho ai cần.

## (a) Tin Zalo nhóm

Phúc, Tài ơi, sáng nay 7g36 web bán hàng với trang admin chạy trên máy mới .99 rồi nha, dữ liệu chuyển đủ hết, máy .60 anh tắt rồi.
Giờ trong công ty tụi em vô bằng 192.168.1.99 (admin cũng vậy) hen. Tên miền ginsengfood.vn chờ anh Tuấn trỏ xong anh báo tiếp.
Gọi tổng đài xác nhận đơn cũng nối với máy mới rồi, anh thử một đơn chạy trọn vòng ngon lành.
Có chỗ nào lạ, lỗi gì nhắn anh liền nghen.

## (b) Kèm (phần kỹ thuật)

- M3/M4/M9 chạy trên `192.168.1.99:80` từ 14/11 07:36 (bản `f9e179a45`, giống .60). Dữ liệu khớp .60: 335 bảng / 13.591 dòng, 104 tệp tải lên.
- `.60` dừng web/admin/API và cầu callback; CSDL .60 giữ nguyên làm đường lui, không ghi thêm.
- M3 gọi M8 ở `.99:8443`; đơn thử 577 (MOCK) callback về ACCEPTED, đơn CONFIRMED 08:49; E01 (ba yêu cầu sai bị từ chối đúng mã) đạt 09:36.
- Tên miền: CORS .99 đã có `https://ginsengfood.vn` và `www`; chờ nginx cổng vào trỏ về .99.
- Log be có cảnh báo Giờ Vàng `POLICY_VERSION_MISSING: GOLDEN_HOUR_POLICY/GLOBAL` (thiếu phiên bản chính sách); đã có trên .60 từ 13/11 12:40,
  không do chuyển máy — Phúc coi giúp phần dữ liệu chính sách Giờ Vàng.
- Cờ đối tác (VNPAY/GHN/Viettel Post) giữ như trên .60, không đổi.
