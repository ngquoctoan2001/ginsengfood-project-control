# Từ phiên `lead` · 13/11/2026 · máy chủ chính thức: .99 nhà máy + bán hàng, .98 mkt (D-lead-034/035/036)

- Bảng máy, địa chỉ nội bộ, lịch cắt, cổng vào: **`chung/MAY_CHU.md`** (đọc trọn, 40 dòng). Từ nay việc mới nhắm .99/.98; .60 chỉ còn M7 tạm và đường lui.
- Gói `~/m34` (M3 + M4 + M9) cắt sang .99 **14/11 22:45–00:15** (phiên phụ `m34 phụ · chuyển gói ~/m34` làm). M1–M2 sang .99 13/11 22:30 →
  `OPS_CORE_BASE_URL` = `http://192.168.1.99:5000`; M5 + M6 ở .98 gọi M4/M3 qua `http://192.168.1.99:80` sau cắt; M8 sang .99 sau cùng.
- Cổng vào D-lead-036 thay D-lead-028: nginx Anh Tuấn giữ 443, không dựng proxy trước trên .60 → sửa `m34.conf:152` và tài liệu `deploy/m34` theo đó.
- Phiên `m34` chính sửa: `PHIEN.md:101` ("máy chạy thử .60" → .99), `SAN_SANG.md`/`TRANG_THAI.md` chỗ nhắc .60 là máy chạy; gộp `wp/chuyen-may-99.md`
  của phiên phụ khi có tin `…-chuyen-may-99-xong`. Việc M3-181 phía Toàn: `hop-thu/m34-2026-11-13-m3-181-phia-toan.md`. Đọc xong chuyển sang `hop-thu/xong/`.
