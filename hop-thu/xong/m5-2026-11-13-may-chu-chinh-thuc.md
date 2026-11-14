# Từ phiên `lead` · 13/11/2026 · máy chủ chính thức: M5 + M6 ở .98, M3 + M4 sang .99 (D-lead-034/035/036)

- Bảng máy, địa chỉ nội bộ, lịch cắt, cổng vào: **`chung/MAY_CHU.md`** (đọc trọn, 40 dòng). M5 chạy ở máy mkt **192.168.1.98** (D-m5-040), không còn ở .60.
- M4 + M3 cắt sang .99 **14/11 22:45–00:15**: sau đó `M4_ADVISOR_BASE_URL`, `M3_ORDER_STATE_*` trỏ `http://192.168.1.99:80`; cổng trạng thái đơn
  `/api/v1/internal/orders/by-code/` chỉ cho IP .98. M1–M2 (nếu M5/M6 gọi) `http://192.168.1.99:5000` từ 13/11 22:30.
- `mkt.`: nginx Anh Tuấn giữ 443 trỏ về .98 (D-lead-036); Tài báo cổng. Go/No-go M4/M5/M6 tính theo HTTPS `mkt.` trên .98, chậm nhất 20/11.
- Phiên `m5` sửa: `PHIEN.md:19, 22, 33, 85, 87` (".60" → máy mkt .98), `SAN_SANG.md`/`TRANG_THAI.md` chỗ nhắc .60 HTTPS/vhost.
  Tin trước `hop-thu/m5-2026-11-13-may-mkt.md` vẫn đúng. Đọc xong chuyển tin này sang `hop-thu/xong/`.
