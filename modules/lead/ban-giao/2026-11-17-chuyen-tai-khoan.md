# Bàn giao khi đổi tài khoản Claude · 17/11/2026 15:5x (cập nhật 16:4x)

> **Đã thay bằng `2026-11-18-chuyen-tai-khoan.md` (18/11 07:4x).**

> **16:3x tên miền public CHẠY THẬT:** chứng chỉ Sectigo wildcard (khoá Mắt Bão) đã cài trên proxy .98, 19/19 tiêu chí đạt có xác thực chứng chỉ, từ ngoài vào đúng, LAN gõ tên miền vào được. Việc 2.1, 2.2 dưới đây coi như xong; còn cổng 80 công khai (http ra 400) và HSTS 1 năm sau 7 ngày. Đã báo m5, m34, m8, m12.

Toàn chuyển sang tài khoản khác. Phiên `lead` bên tài khoản mới đọc tệp này, **tạo phiên cho từng luồng** (như 16/11: cùng cấp, thư mục
`C:\Projects\Project Control`, không worktree) và gửi mỗi phiên đúng khối của nó ở mục 3; xong báo Toàn mục 2.
Phiên ở tài khoản cũ dừng hẳn, không chạy tiếp (tránh hai phiên cùng ghi một tệp). Số liệu lấy từ sổ lúc 15:46; nguồn đúng vẫn là
`modules/<mã>/TRANG_THAI.md`, `QUYET_DINH.md`, `nhat-ky/2026-11-17.md` của từng luồng.

## 1. Trạng thái chung

- **Máy .99:** M1–M2 `ac5bc00d4` (10:26) + cấu hình proxy .98 (D-m12-105); M3/M4/M9 `afb6d404c` + quản trị IVR; M8 `0f1a9eb5` (08:58, hạn mức 600/60 s).
  **.98:** M5 + M6 bản 14/11 + **proxy Caddy cổng vào** (`/data/deploy/edge-98`, chứng chỉ nội bộ). .63 máy dev + runner `may-63` (2 job).
- **Nối M12 ↔ M3 trên .99:** M3 lấy token M12 bằng secret v5 (15:23), nạp 19 link SKU + kho `GF-VN-HCM-01` ↔ `WH_FG_MAIN` (15:31); `OPS_CORE_ENABLED=false`, bật quan sát từ 20/11.
  M3 → `192.168.1.99:5000` đo 200 (không cần tường lửa).
- **Tên miền public** (kế hoạch + checklist `modules/lead/may-chu/2026-11-17-ke-hoach-ten-mien-public.md`; D-lead-057/058):
  proxy Caddy .98 chạy, kiểm từ LAN 17/17 đạt; **đã mua Wildcard SSL-DV Mắt Bão** (kích hoạt, chờ kỹ thuật Mắt Bão hướng dẫn khai báo `*.ginsengfood.vn`;
  CSR sẵn ở `modules/lead/ra-soat/may-chu-anh-tuan/wildcard.csr`, khoá riêng nằm trên .98). **Router DrayTek Vigor2915 đang giữ cổng 443/80** của IP
  `14.224.139.101` (trang đăng nhập router lộ ra Internet); chỉ IP `113.161.59.x` vào được .98 → đã nhắn Anh Tuấn, chờ sửa. Đường `/media` ảnh truy xuất
  đã viết, chưa áp lên .98 (áp cùng lượt cài chứng chỉ). Cấu hình ở `C:\Projects\deploy\edge-98\` (chưa commit).
- **Luồng mới `m9`** (D-lead-059): M9 Tài chính + MISA, tách khỏi `m34`. Tài liệu MISA của chú đã rà, giao Tài (tin chưa gửi).
- **CI GitHub repo bán hàng KẸT:** tài khoản PhucApu lỗi thanh toán Actions → không image mới cho deploy .99 buổi sếp test M4 18–19/11. Phúc sửa Billing.
- Quyết định lead hôm nay: D-lead-057 (cổng vào trên .98), D-lead-058 (Mắt Bão, bớt hỏi Anh Tuấn), D-lead-059 (luồng m9).
- Sổ Project Control: 225 mục chưa commit từ `ccb5bb7` (14/11) — repo công khai, quét bí mật trước, push khi Toàn bảo.

## 2. Việc đang chờ Toàn

| # | Việc | Phiên |
|---|---|---|
| 1 | Mắt Bão liên hệ khai báo SSL: dán CSR của mình (không để Mắt Bão sinh khoá), xác thực bằng bản ghi DNS, xin tệp PEM (.crt + .ca-bundle) → gửi phiên lead cài | lead |
| 2 | Anh Tuấn sửa router (443/80 → .98); xong kiểm bằng 4G hoặc check-host.net | lead |
| 3 | Phúc sửa Billing GitHub để CI BP chạy lại | m34 |
| 4 | Gửi tin: Phúc — OTP vào Spam (`modules/lead/tin/2026-11-17_phuc_otp-email-spam.md`), m9 (`modules/m9/ra-soat/2026-11-17-tin-phuc.md`), mật khẩu M12 thử (`C:\Projects\_wt\m12\tin-gui-phuc.txt`, gửi xong xoá) · Tài — m9 (`modules/m9/ra-soat/2026-11-17-tin-tai.md` + 3 tệp), khoá M6 (`modules/m12/ra-soat/2026-11-17-tin-tai-khoa-m6.md`), CA cổng 8446 · chú — `modules/m12/ra-soat/2026-11-16-tin-chudung.md` | Toàn tự gửi |
| 5 | Mở tường lửa Windows máy Lead cho IP máy Phúc → cổng 5310 (M12 thử) | m12 |
| 6 | m12: `deploy-99` `565272e01` sau pipeline #3077854714 (~18:15); m12.115, m12.116, m12.109; duyệt diff R3 M12-106 | m12 |
| 7 | m7: chép 5 ảnh sản phẩm vào .63, `codex login --device-auth` trên .63 | m7 |
| 8 | m5: danh sách kênh YouTube + người giữ đăng nhập | m5 |
| 9 | Commit sổ Project Control + `deploy/edge-98` (nói "commit") | lead |

## 3. Khối tin gửi từng phiên

### 3.1 Phiên `lead` (chính phiên nhận tệp này)
Đọc `modules/lead/TRANG_THAI.md`, `QUYET_DINH.md` (tới D-lead-059), `nhat-ky/2026-11-17.md`, kế hoạch tên miền ở trên.
- Chờ tệp chứng chỉ Mắt Bão → chạy `cai-chung-chi.sh <crt> <ca-bundle>` trên .98 (Toàn duyệt), áp bản Caddyfile có `/media`, `kiem-cong-vao.sh --dich 192.168.1.98`
  (không `-k`) → khi Anh Tuấn sửa router: kiểm từ ngoài, báo phiên m5 nhắc Tài khai Meta.
- Hộp thư chưa xử lý: `hop-thu/lead-2026-11-17-m9-misa-cham-m12.md` (m9.4 A = D-m9-005 → ghi D-lead, chuyển phần M12 cho phiên m12; hợp đồng M6 → M9 thiếu trường nền tảng),
  `hop-thu/lead-2026-11-17-m5-youtube.md` (contracts, M4 `/advise` 403 ở production).
- Ghi TRANG_THAI lead (bảng đầu phiên 16/11 20:3x đã cũ: lead.92–98 phần lớn đã xử lý ở các luồng).

### 3.2 Phiên `m12` vận hành ("Phien M12 (fork)" cũ)
Đọc `modules/m12/TRANG_THAI.md`, `QUYET_DINH.md` (tới D-m12-109), `nhat-ky/2026-11-17.md`. Từ 17/11 08:4x m12 chia hai: phiên này giữ vận hành (deploy-99, `.env`/compose .99, seed, UAT, Sheet, sổ m12).
- Pipeline tay #3077854714 (`565272e01`) → đọc kết quả rồi `deploy-99` (Toàn duyệt; sửa lỗi kg của app quét phiếu). Remote nay `cef6861db`.
- WP21 xong (M3 token v5 + link 19 SKU); quan sát từ 20/11 chờ Phúc gộp nhánh chú `0c83bc4a5` vào `dev`. IP nguồn M3 API thấy chưa đo — đo ở WP17b.
- M12 thử cho Phúc `http://192.168.0.64:5310` (PID 18400, DB lab 2) đang chạy; thử xong tắt (`m3-thu-lan.ps1 -Action stop`) + vô hiệu credential v2.
- UAT còn 531 ca; WP12g đợt 2 (PUI mới); câu chờ Toàn m12.115/116/109.

### 3.3 Phiên `m12` rà release ("Phien M12" gốc cũ, chỉ đọc)
Đọc `modules/m12/ra-soat/2026-11-17-release/00-TONG-HOP.md` (RS-1…10 = D-m12-095…104, host media trace D-m12-106, 9 luồng sửa L1–L9).
Việc: theo dõi các luồng sửa sau rà, không ghi `.99`, không sửa sổ vận hành (gửi phiên vận hành).

### 3.4 Phiên `m34` (M3, M4)
Đọc `modules/m34/TRANG_THAI.md`, `QUYET_DINH.md` (tới D-m34-104), `nhat-ky/2026-11-17.md`.
- `dev` = `toandeptrai` = `9c71e37ce` (PR #164 gộp 15:42: proxy .98 nginx, ghim `m34_app` 172.24.2.0/24, IVR ui-kit-v2, bộ ngắt mạch `75663cf47`).
  Bộ kiểm đủ vùng inventory/order/cổng bán (M3-201) đang chạy nền lúc đổi tài khoản → kiểm lại kết quả, xanh thì ghi Đạt.
- CI GitHub kẹt (Billing PhucApu) → deploy .99 buổi sếp test M4 (phiếu `wp/deploy-m4-99-sep-test.md`) chờ image; lượt deploy kế tiếp tạo lại mạng `m34_app`, chạy đủ bộ, `nginx -t` trước.
- Nối M12 xong phía M3 trên .99 (D-m34-100…103); quan sát 20/11. M9 đã sang luồng `m9` (D-m34-098).

### 3.5 Phiên `m5`
Đọc `modules/m5/TRANG_THAI.md`, `QUYET_DINH.md` (tới D-m5-057). YouTube D-m5-053…057 (tin Tài đã gửi 10:12), tin HTTPS `mkt.` đã gửi 10:42.
Chờ: phiên lead báo giờ chuyển cổng → soạn tin nhắc Tài khai Meta; Tài tạo Sheet M5-150…161 + đề xuất chỗ sinh khoá JWT (D-m5-052); Go/No-go ≤ 20/11.

### 3.6 Phiên `m6`
Đọc `modules/m6/TRANG_THAI.md`, `QUYET_DINH.md` (tới D-m6-027). Chờ Tài sửa 12 task + ghi DL theo D-m6-021…025 (hạn 18/11) → lượt rà 5, hồ sơ Go/No-go M6-125 trước họp ≤ 20/11.
Hộp thư `hop-thu/m6-2026-11-16-m5-jwt-t6.md` chưa xử lý.

### 3.7 Phiên `m7` máy Lead (điều khiển .63)
Đọc `modules/m7/TRANG_THAI.md`, `QUYET_DINH.md` (tới D-m7-117). Phiên CLI .63 `9b228a48…` chạy lượt 03 (sóng 1 WP31, PID 2023197) — kiểm `~/m7-drive/` trên .63
trước khi giao lượt mới. Nếu tài khoản mới cũng phải đăng nhập Claude trên .63 thì Toàn làm một lần (`ssh -t ssv@192.168.1.63 "bash -lc claude"` rồi `/login`).

### 3.8 Phiên `m8`
Đọc `modules/m8/TRANG_THAI.md`, `QUYET_DINH.md` (tới D-m8-129). `main` local `aeb486eb` (W-0548 zlib) chưa push (gom lượt sau); remote `756ea09f`; .99 `0f1a9eb5`.
Buổi E: E07, E08 ĐẠT; E02/E03 chờ web .99 đặt được đơn (tên miền + chứng chỉ). Custody khoá M8 xong phía .99 (gói dự phòng ở máy Toàn); .64 bảo trì m8 tự làm (D-m8-122).

### 3.9 Phiên `m9` (mới)
Đọc `modules/m9/PHIEN.md`, `TRANG_THAI.md`, `QUYET_DINH.md` (tới D-m9-006). Tin Phúc + Tài chưa gửi (Toàn gửi). Theo dõi: Phúc gộp nhánh gộp vào `dev` (19/11),
Tài báo ngày từng gói + MISA-00 (18/11), PR MISA-01 (20/11) → `/ra-soat tai-misa`.
