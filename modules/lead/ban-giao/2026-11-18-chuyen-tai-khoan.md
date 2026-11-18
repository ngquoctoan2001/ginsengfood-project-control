# Bàn giao khi đổi tài khoản Claude · 18/11/2026 07:4x

Thay `2026-11-17-chuyen-tai-khoan.md`. Toàn chuyển sang tài khoản khác. Phiên `lead` bên tài khoản mới đọc tệp này, **tạo phiên cho từng luồng**
(cùng cấp với lead, không fork, thư mục `C:\Projects\Project Control`, không worktree): m12, m34, m5, m6, m7, m8, m9; gửi mỗi phiên đúng khối của nó ở mục 3;
xong báo Toàn mục 2. Phiên ở tài khoản cũ dừng hẳn (tránh hai phiên cùng ghi một tệp). Nguồn đúng vẫn là `modules/<mã>/TRANG_THAI.md`,
`QUYET_DINH.md`, `nhat-ky/` của từng luồng; số liệu dưới đây lấy từ sổ lúc 18/11 07:4x.

## 1. Trạng thái chung

- **Tên miền public CHẠY THẬT từ 17/11 ~16:3x** (D-lead-057/058; kế hoạch + checklist `modules/lead/may-chu/2026-11-17-ke-hoach-ten-mien-public.md`):
  router chuyển 443 của `14.224.139.101` về proxy Caddy trên .98 (compose `edge`, `/data/deploy/edge-98`), chứng chỉ Sectigo wildcard `*.ginsengfood.vn` + tên gốc
  (Mắt Bão), hạn **03/06/2027**, cấp lại trước ~04/05/2027. Kiểm có xác thực chứng chỉ 19/19 đạt, từ ngoài vào đúng, LAN gõ tên miền vào được.
  Còn: cổng 80 công khai chuyển nhầm vào 443 của .98 (gõ `http://` ra 400, nhắc Anh Tuấn khi tiện) · pha 3 (SSL Labs, `KIEM_KE_MAY_CHU.md` thêm proxy, báo Chú)
  · pha 4 ~26/11 (HSTS 1 năm, khối bắt-tất-cả `https://` trả 404 cho tên có dấu chấm cuối, tường lửa .99 cổng 80/8012 chỉ cho .98, XFF chỉ tin `.98/32`,
  theo dõi từ ngoài + cảnh báo hạn chứng chỉ, diễn tập lui). Cấu hình ở `C:\Projects\deploy\edge-98\` (chưa commit).
- **Máy .99:** M1–M2 `565272e01` (17/11 18:18) · M3/M4/M9 image `afb6d404c` (OTP giả hiện mã, nối IVR bật) · M8 `0f1a9eb5` (MOCK, lịch tắt).
  **.98:** M5 + M6 bản 14/11 + proxy `edge`. **.63:** máy dev + runner `may-63`.
- **Rủi ro mở (gấp):** trang bán hàng đã ra Internet mà OTP giả và nối IVR vẫn bật → đơn COD thật có thể bị watchdog huỷ oan (`IVR_WATCHDOG_EXPIRED`).
  m34.128 (tắt OTP giả) + m34.130 (tắt nối IVR) chờ Toàn, một lần tạo lại `be` (~40 giây).
- **CI GitHub repo bán hàng KẸT** (Billing tài khoản PhucApu) → không image mới cho deploy .99 buổi sếp test M4 18–19/11.
- **Nối M12 ↔ M3 trên .99:** token v5 + link 19 SKU + kho đã nạp; M3 còn tắt, quan sát từ 20/11. M3 → `.99:5000` đo 200.
- **Luồng `m9`** (D-lead-059) đã mở: M9 Tài chính + MISA; tài liệu MISA của chú đã rà, tin giao Tài + Phúc chưa gửi.
- Quyết định lead tới **D-lead-059**. Sổ Project Control ~226 mục chưa commit từ `ccb5bb7` (14/11): repo công khai, quét bí mật trước, push khi Toàn bảo.

## 2. Việc đang chờ Toàn

| # | Việc | Phiên |
|---|---|---|
| 1 | **Duyệt m34.128 + m34.130** (tắt OTP giả + nối IVR trên .99) — gấp vì trang bán hàng đã public | m34 |
| 2 | Phúc sửa Billing GitHub để CI repo bán hàng chạy lại | m34 |
| 3 | Gửi tin còn treo (nếu chưa gửi): nhóm chung + Tài báo HTTPS (`modules/lead/tin/2026-11-17_nhom-tai_https-chay-that.md`) · Phúc: OTP vào Spam (`modules/lead/tin/2026-11-17_phuc_otp-email-spam.md`), m34 (`modules/m34/ra-soat/2026-11-17-phuc-tin-nhan-nhap.md`), m9 (`modules/m9/ra-soat/2026-11-17-tin-phuc.md`), mật khẩu M12 thử (`C:\Projects\_wt\m12\tin-gui-phuc.txt`, gửi xong xoá) · Tài: m9 (`modules/m9/ra-soat/2026-11-17-tin-tai.md` + tệp kèm), khoá M6 (`modules/m12/ra-soat/2026-11-17-tin-tai-khoa-m6.md`), CA cổng 8446 · chú: `modules/m12/ra-soat/2026-11-16-tin-chudung.md` | Toàn tự gửi |
| 4 | Cất khoá riêng + zip chứng chỉ Mắt Bão khỏi thư mục Downloads vào chỗ cất riêng, xoá bản ở Downloads (không dán khoá vào chat/Zalo) | Toàn |
| 5 | Thử đăng nhập thật qua https (nếu chưa): `ops.`, `pwa.` (cài PWA trên điện thoại), `ginsengfood.vn/admin`, `mkt.` — từ 4G và trong công ty | lead |
| 6 | Mở tường lửa Windows máy Lead cho IP máy Phúc → cổng 5310 (M12 thử) | m12 |
| 7 | m12.115, m12.116, m12.109 (đề xuất A); duyệt diff R3 M12-106 | m12 |
| 8 | m7: chép 5 ảnh sản phẩm vào .63, `codex login --device-auth` trên .63; tài khoản mới phải đăng nhập Claude trên .63 thì làm một lần | m7 |
| 9 | m5: danh sách kênh YouTube + người giữ đăng nhập | m5 |
| 10 | Commit sổ Project Control + `deploy/edge-98` (nói "commit") | lead |

## 3. Khối tin gửi từng phiên

### 3.1 Phiên `lead` (chính phiên nhận tệp này)
Đọc `modules/lead/QUYET_DINH.md` (tới D-lead-059), `nhat-ky/2026-11-17.md`, kế hoạch tên miền §7 (pha 3–4) và §10. `TRANG_THAI.md` lead còn bảng 16/11 → ghi đè.
- Hộp thư chưa xử lý: `hop-thu/lead-2026-11-17-m9-misa-cham-m12.md` (m9.4 A = D-m9-005 → ghi D-lead, chuyển phần M12 cho m12; hợp đồng M6 → M9 thiếu trường nền tảng),
  `hop-thu/lead-2026-11-17-m5-youtube.md` (contracts, M4 `/advise` 403 ở production).
- Pha 3 tên miền: SSL Labs `ginsengfood.vn` + `mkt.`; `KIEM_KE_MAY_CHU.md` thêm proxy .98; đưa vào báo cáo tuần. Pha 4 ~26/11 (không làm trước khi Toàn bảo).
- Đổi gì trên .98 phải Toàn duyệt từng lượt; sửa `Caddyfile` theo README `deploy/edge-98` (sao lưu → validate → reload).

### 3.2 Phiên `m12` (vận hành + theo dõi rà release)
Đọc `modules/m12/TRANG_THAI.md`, `QUYET_DINH.md` (tới D-m12-109), `nhat-ky/2026-11-17.md`.
- .99 chạy `565272e01` từ 17/11 18:18 (`deploy-99` đạt, không migration mới; có bản sửa lỗi kg app quét phiếu — xem nhật ký 18:21 phần còn phải thử).
- M12 thử cho Phúc `http://192.168.0.64:5310` (DB lab 2) chờ Toàn mở tường lửa; thử xong tắt + vô hiệu credential.
- WP21 xong (M3 token v5 + link 19 SKU), quan sát từ 20/11; IP nguồn M3 → API đo ở WP17b. Câu chờ Toàn m12.115/116/109; UAT còn 531 ca; WP12g đợt 2.
- Rà release: `ra-soat/2026-11-17-release/00-TONG-HOP.md` (RS-1…10, luồng sửa L1–L9) — theo dõi luôn trong phiên này.

### 3.3 Phiên `m34` (M3, M4)
Đọc `modules/m34/TRANG_THAI.md`, `QUYET_DINH.md` (tới D-m34-104), `nhat-ky/2026-11-17.md`.
- `dev` = `toandeptrai` = `9c71e37ce` (PR #164). .99 image `afb6d404c`.
- **m34.128 + m34.130 chờ Toàn** (tắt OTP giả + nối IVR, một lần tạo lại `be`); m34.129 khung chat khi tên miền mở (phiếu `wp/deploy-m4-99-sep-test.md`).
- CI kẹt Billing → deploy buổi sếp test M4 chờ image. Lượt deploy kế tiếp làm luôn việc "sau HTTPS": `.env` .99 `CORS_ALLOWED_ORIGINS` thêm `https://ginsengfood.vn` + `www`
  (giữ `http://192.168.1.99` tới pha 4), `AUTH_COOKIE_SECURE=true`; tạo lại mạng `m34_app`; `nginx -t` trước.
- Tin Phúc `ra-soat/2026-11-17-phuc-tin-nhan-nhap.md` chưa gửi. M9 đã sang luồng `m9`.

### 3.4 Phiên `m5`
Đọc `modules/m5/TRANG_THAI.md`, `QUYET_DINH.md` (tới D-m5-057). Tin HTTPS `mkt.` (10:42) và tin nhắc khai Meta (19:40) đã gửi Tài.
Chờ Tài: Meta xác minh webhook đạt qua https, URL chính sách riêng tư, Sheet M5-150…161 (YouTube), đề xuất chỗ sinh khoá JWT (D-m5-052). Go/No-go chậm nhất 20/11.

### 3.5 Phiên `m6`
Đọc `modules/m6/TRANG_THAI.md`, `QUYET_DINH.md` (tới D-m6-027). Chờ Tài sửa 12 task + ghi DL theo D-m6-021…025 (hạn 18/11) → `/ra-soat tai` lượt 5;
hồ sơ Go/No-go M6-125 trước họp ≤ 20/11. Hộp thư `hop-thu/m6-2026-11-16-m5-jwt-t6.md` chưa xử lý.

### 3.6 Phiên `m7` máy Lead (điều khiển .63)
Đọc `modules/m7/TRANG_THAI.md`, `QUYET_DINH.md` (tới D-m7-117). Lượt 03 trên .63 (PID 2023197, sóng 1 WP31) — kiểm `~/m7-drive/` và tiến trình trên .63 trước khi giao lượt mới;
`b2dab53`, `02b1330` chưa push. Tài khoản mới phải đăng nhập Claude trên .63 thì Toàn làm một lần (`ssh -t ssv@192.168.1.63 "bash -lc claude"` rồi `/login`).

### 3.7 Phiên `m8`
Đọc `modules/m8/TRANG_THAI.md`, `QUYET_DINH.md` (tới D-m8-129). `main` local `aeb486eb` (W-0548) chưa push; .99 `0f1a9eb5` MOCK, lịch tắt.
E02/E03 nay đã có tên miền; chờ m34.130 (tắt nối IVR) rồi mới hẹn đặt đơn thử với m34. Nợ mới: `krb5-libs` của ảnh gốc `postgres:16-alpine` (19 HIGH) trước khi dựng bản phát hành.

### 3.8 Phiên `m9`
Đọc `modules/m9/PHIEN.md`, `TRANG_THAI.md`, `QUYET_DINH.md` (tới D-m9-006). Tin Phúc + Tài chưa gửi (Toàn gửi, Phúc trước). Theo dõi: Phúc gộp nhánh gộp vào `dev`
trước 19/11 (`hop-thu/m34-2026-11-17-m9-gop-nhanh-gop.md`), Tài MISA-00 (18/11), PR MISA-01 (20/11) → `/ra-soat tai-misa`.

## 4. Tin mở đầu ở tài khoản mới (Toàn dán vào phiên lead)

Gõ `/phien lead`, rồi gửi:

```text
Mình vừa chuyển từ tài khoản cũ sang. Đọc modules/lead/ban-giao/2026-11-18-chuyen-tai-khoan.md rồi làm theo: tạo các phiên cùng cấp với phiên lead (không fork) cho m12, m34, m5, m6, m7, m8, m9, gửi mỗi phiên đúng khối của nó ở mục 3, xong báo mình mục 2.
```
