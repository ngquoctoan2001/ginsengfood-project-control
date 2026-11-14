# Từ phiên `lead` · 13/11/2026 · máy chủ chính thức: M5 + M6 ở .98, M1–M2 + M3 sang .99 (D-lead-034/035/036)

- Bảng máy, địa chỉ nội bộ, lịch cắt, cổng vào: **`chung/MAY_CHU.md`** (đọc trọn, 40 dòng). M6 chạy ở máy mkt **192.168.1.98** (D-m6-015), không còn ở .60.
- Sau giờ cắt: `M6_OPSCORE_BASE_URL` = `http://192.168.1.99:5000` (M1–M2, từ 13/11 22:30; cổng 5000 mở cho .98); `M6_M3_BASE_URL` = `http://192.168.1.99:80`
  (M3, từ 14/11 22:45). Go/No-go M6 tính theo HTTPS `mkt.` trên .98, chậm nhất 20/11.
- Phiên `m6` sửa: `PHIEN.md:32` ("Máy chủ M6: .60" → .98), `PHIEN.md:48`, `SAN_SANG.md`/`TRANG_THAI.md` chỗ nhắc .60. Đọc xong chuyển sang `hop-thu/xong/`.
