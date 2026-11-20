# Trạng thái: m12

Mốc 20/11 10:xx (T6).

- **ops-core:** `main` = `origin` = `gitlab` = `3e84ab68b`.
- **.99:** chạy `3e84ab68b` trên **DB sạch** `ginsengfood_ops_production` (157 migration, D-m12-126/128). DB cũ giữ làm lưu trữ.
- **Sẵn sàng:** 47% (`SAN_SANG.md` 17/11, chưa tính lại). Kịp 30/11: **VÀNG**.
- **Mốc** (D-m12-088): M-b 20/11 M3 quan sát · M-c ≤ 25/11 Production · M-d 28/11 · 30/11.

## Tình hình

- **WP29 trang chi tiết người dùng** (D-m12-125, R3): đã lên .99 (`51f6fb1b8`). Còn chờ Toàn bấm thử.
- **WP26 đăng nhập mail:**
  - code đã lên .99;
  - cờ `Auth__EmailLogin__Enabled` trong `.env` đã đổi `true` (20/11 sáng, Toàn tự làm), nhưng **chưa tạo lại API** ⇒ chưa có hiệu lực;
  - kiểm `login/options` phải gọi kèm `Host: ops-core-api`.
- **DB sạch .99:**
  - còn 5 tài khoản: toan.nq, khanh.nk, sang.pv, dung.ptn, lan.vnm (giữ mật khẩu cũ);
  - principal M3 có 10 quyền, M6 có 1 quyền;
  - còn: 5 người đăng nhập thật, M3/M6 `kiem-token` + M3 nối lại SKU/kho (Phúc), nhập master data thật.
- **11 góp ý 20/11** ⇒ phiếu `wp/M12-WP30-33-gop-y-20-11.md`:
  - WP30 giao diện (R2);
  - WP31 phiên không văng (R3);
  - WP32 quên mật khẩu (R3);
  - WP33 màn cấu hình 3 đợt.
  - Nguyên nhân văng đăng nhập: JWT quản trị 60 phút cố định, không gia hạn.
- **WP28 bố cục:** còn cổng (dò 95 màn, 20 màn Lead thử). Hiện không phiên nào làm; chạy sau WP30.
- **CI:** xanh ở `3e84ab68b`. Báo nhầm JWT lịch sử thứ 3 đã ghi (D-m12-127).

## Cần bạn quyết

- **m12.178–185** (phiếu WP30–33):
  - phiên trượt;
  - chữa tạm 480 phút trên .99;
  - quên mật khẩu;
  - thứ tự;
  - tên 2 menu;
  - bố cục receipts;
  - trade items Toàn thấy lỗi gì;
  - phạm vi WP33.
- **Kiểm chỉ đọc .99:** đếm dòng `op_stock_alert_policy` và `op_material_planning_policy` (nghi 0 dòng trên DB sạch).

## Việc chặn

- Mail login cần Toàn: tạo lại API trên .99, gắn mail công ty cho 5 người, từng người xác nhận bằng mã.
- M3 quan sát cần Phúc chạy `kiem-token` và nối lại SKU/kho trên DB sạch.

## Kế tiếp

1. Toàn trả lời m12.178–185 ⇒ chạy WP31 + WP30 song song (chế độ S, 2 coder, verifier).
2. WP32 + WP33 đợt 1.
3. WP33 đợt 2 + cổng WP28.
4. Mỗi lần lên .99 hỏi riêng.
