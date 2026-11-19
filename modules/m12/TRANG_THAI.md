# Trạng thái — m12

Mốc 18/11 19:4x (T4) · ops-core `origin` = `gitlab` = `ee99e9fd6` · `main` cục bộ = **`8b1d4cbde`** (+18 commit CHƯA push: WP23 phần 3, WP24 app xưởng [phiên f1e7c3], WP25, WP26) ·
`.99` chạy `565272e01` + seed 48 menu; lượt `.99` bản `ee99e9fd6` (deploy-99 + seed tay) do phiên [f06a06] giữ, script `C:\Projects\_wt\m12\seed-99-lan4\` ĐẠT (điểm dừng: gửi phiên này kết quả `thu` trước `that`).
Sẵn sàng **47%** (`SAN_SANG.md` 17/11, chưa tính lại). Kịp 30/11 **VÀNG**. Mốc (D-m12-088): M-b 20/11 M3 quan sát · M-c ≤ 25/11 Production · M-d 28/11 · 30/11.
**Ba phiên m12** cùng sổ + checkout: [712d59] phiên này (gộp chú lần 4, WP25, WP26, Sheet, TRANG_THAI) · fork [55a4ca] (WP23 menu, Việt hoá) · [f1e7c3] (WP24 app xưởng, D-m12-116); quy ước ở `hop-thu/m12-2026-11-18-phoi-hop-3-phien-m12.md` (câu: [712d59] m12.140–149 · fork 150–159 · [f1e7c3] 160+).

## Tình hình

- **Gộp nhánh chú lần 4** (M12-110, D-m12-110/112/113): đã push `ee99e9fd6`; bộ đủ XANH; R3 — Toàn duyệt diff SAU (như M12-106 lần 3).
- **WP23 menu** (M12-111 Đạt): phần 1–2 đã push; phần 3 (Thiết bị xưởng vào Hệ thống, D-m12-114) `d8b76b015` + `588528f12` cục bộ.
- **WP25 giao diện tên trên mã dưới + phông** (M12-113, D-m12-117 = m12.140–143 A): A `a77e0f43e` + `d30fc8337`, B `dc85cf96f`, C `7370b01b2` + `8b1d4cbde`; 3 verifier ĐẠT
  (sửa sau rà: tệp guard 800 dòng, test DB 3 mã lô, test tên người vận hành qua GET lệnh/mẻ, test sắp theo tên); bản rà `ra-soat/2026-11-18-ui-ten-ma-phong.md`. Chưa làm: mục THẤP, tiêu đề ghép "MÃ - Tên".
- **WP26 đăng nhập mail công ty + OTP** (M12-114 Chờ review, D-m12-115/119, R3, cờ mặc định TẮT): backend `58103be18`, bộ test tấn công độc lập `0399296ce` (32 ca), sửa `373d41f89`
  (chiếm mail, phiên xưởng chỉ qua proxy tin cậy); verifier R3 cuối ĐẠT. Phiên app xưởng 600 phút có hiệu lực ngay khi deploy (kể cả cờ tắt). Chưa: giao diện admin-web, PWA (WP24 gắn), bật cờ .99.
- **Bộ kiểm đủ chung** @ `8b1d4cbde` đang chạy (`_wt/m12/kiem-bodu-1811`). Đã biết Governance P17 shopfloor đỏ do WP24 `6266e155e`.
- **WP21** M3 token + link 19 SKU trên .99; M3 tắt, quan sát từ 20/11. **WP12g** đợt 2 + nháp sessionStorage (rà lần 4 mục 6) còn. **WP-UAT** còn 531 ca + ca lần 4.
- **Rà release** L1–L9 chưa mở; L4 thêm gốc lỗi idempotency (`EfIdempotencyCoordinator`) lệnh thêm cha + con rồi lỗi ⇒ 500.

## Cần bạn quyết

- **m12.148** giới hạn gửi mã theo IP (10/15 phút) + giới hạn chung route đăng nhập (10/phút) có thể chặn cả xưởng dùng chung IP lúc đổi ca: A nới cho route gửi mã (60/15 phút, burst rộng hơn), giữ 3/mail · B giữ. Đề xuất A.
- **m12.149** thêm trần theo ngày cho mỗi mail (vd ≤ 10 mã/ngày, khoá đăng nhập mail 24 giờ sau 15 lần sai/ngày) để chặn dò mã kéo dài: A có · B theo M5 (không trần ngày). Đề xuất A.
- Duyệt diff R3: M12-110 (gộp chú lần 4), M12-114 (WP26), M12-106 (lần 3). Push `main` (18 commit) khi bộ đủ xanh — chờ lời bạn.
- m12.109/115/116/125/126 (sáng) vẫn mở; m12.130–134 là câu WP24 ở phiên [f1e7c3].

## Việc chặn

- M3 quan sát 20/11: Phúc gộp nhánh chú BP vào `dev`; CI repo bán hàng kẹt Billing. WP17b (OPS-01 + cổng JWT) chưa giao ⇒ diễn tập 20–21/11 trượt nếu không giao sớm.

## Kế tiếp

1. Bộ đủ xanh ⇒ Sheet M12-113 Đạt, trình push. 2. WP26 giao diện admin-web (đăng nhập + hồ sơ + màn Người dùng) sau m12.148/149. 3. Sóng WP17b-mã (OPS-01, cổng JWT) — đường găng M-c.
