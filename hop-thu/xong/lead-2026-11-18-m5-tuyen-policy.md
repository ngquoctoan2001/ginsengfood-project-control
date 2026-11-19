# Từ phiên m5 · 18/11/2026 08:4x · thêm tuyến `/policy/` trên Caddy edge-98 + kiểm đường ra của .98

Toàn chốt 18/11 08:41 "ok 56 B" (D-m5-064, thay phần GitHub Pages của D-m5-058/D-m5-007): trang chính sách riêng tư + các trang công khai M5
(điều khoản, hướng dẫn xoá dữ liệu) đặt ở `https://mkt.ginsengfood.vn/policy/`. Đây là việc chặn: Meta chỉ còn thiếu URL chính sách để phát hành app
(Tài báo sáng 18/11: webhook `mkt.` đã xác minh đạt, M5 trên .98 lên `aa6d55d4` 07:54). Toàn đã duyệt chữ phần của mình (D-m5-062).

Việc cần phiên `lead` (sửa máy chủ .98 cho đúng việc này đã có lời Toàn ở D-m5-064):
1. Caddy edge-98 (`/data/deploy/edge-98`), host `mkt.ginsengfood.vn`: thêm tuyến tĩnh `/policy/*` trả tệp từ một thư mục trên .98, mount **chỉ đọc** vào container edge,
   không chuyển vào app M5 (cùng kiểu `trace.ginsengfood.vn/media/*` đã có). Gợi ý của Tài: `/data/ginsengfood-marketing/public/policy/` (`index.html` + vài trang).
   Phiên lead chọn đường dẫn cuối cùng. Mong muốn: `/policy` → 301 `/policy/`; chỉ GET/HEAD; tắt liệt kê thư mục; tệp không có → 404; header giữ như các tuyến khác.
   Các đường khác của `mkt.` giữ nguyên D-m5-048 (còn lại 404).
2. Xong thì thả `hop-thu/m5-2026-11-18-tuyen-policy-xong.md` ghi: đường dẫn thư mục, chủ sở hữu/quyền để Tài ghi tệp, giờ chạy, kết quả kiểm `curl -I /policy/`.
   Phiên m5 báo Tài đặt HTML (Tài xuất từ `docs/05-reference/public/*.md`, HTML tĩnh không script).
3. Kiểm giúp đường ra Internet của .98 (chỉ kiểm, có gì chặn thì báo Toàn/Anh Tuấn):
   - `api.telegram.org:443` — kênh CSKH + cảnh báo thật của M5 là Telegram (D-m5-066), M5 không khởi động chế độ phạm vi khi thiếu.
   - SMTP tới máy chủ mail công ty (MX `ssavigroup.com` = `pro56.emailserver.vn`, cổng 465 hoặc 587) — đăng nhập màn quản trị `mkt.` bằng mã gửi về mail @ssavigroup.com (D-m5-065).
4. Không gấp, để phiên lead quyết: TRK-85 của Tài (giới hạn tốc độ POST vào `/api/channel/meta/webhook` ở proxy). Mã M5 đã không ghi DB khi chữ ký sai (C6, đã lên .98).
