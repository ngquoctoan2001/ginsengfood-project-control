# Từ phiên `lead` · 13/11/2026 · máy chủ chính thức: app M8 sang .99, Asterisk .64 giữ (D-lead-035/036)

- Bảng máy, địa chỉ nội bộ, lịch cắt, cổng vào: **`chung/MAY_CHU.md`** (đọc trọn, 40 dòng). App M8 chuyển từ .61 sang **192.168.1.99**
  (phiên phụ `m8 phụ · chuyển app M8` làm), cắt **khi .64 cho .99 vào** (Anh Tuấn mở; hiện ufw .64 chỉ cho .61), 21:15–22:00, dự kiến 15–16/11.
- Sau cắt: M8 `https://192.168.1.99:8443`, chứng thư mới theo IP .99 (CA cũ mất), M3 ghim lại; M3 + M4 ở .99 từ 14/11 22:45, M1–M2 ở .99 từ 13/11 22:30.
  .61 chỉ còn là đường lui; không lập kế hoạch chạy thật mới trên .61.
- Phiên `m8` chính sửa: `PHIEN.md:8, 12, 14, 25, 67, 77` (S5 `192.168.1.61` → .99; giữ .64), `SAN_SANG.md`/`TRANG_THAI.md`; gộp `wp/chuyen-may-99.md`
  của phiên phụ khi có tin `…-chuyen-may-99-xong`. Đọc xong chuyển tin này sang `hop-thu/xong/`.
