# Trạng thái — m5

Cập nhật 18/11/2026 08:55 (Asia/Bangkok; phiên m5 ở tài khoản Claude mới, `/phien` 07:58). module5 `main` `aa6d55d4`
(17/11 22:06, PR #152; 08:33 lên `f6887c64` PR #153 M6; checkout sạch, bằng origin); M4-PLAN `origin/main` `3ff48a75` (18/11 07:46; checkout `fdc7e78b`, chưa pull).
Máy .98: **M5 lên `aa6d55d4` 18/11 07:54** (Tài báo 08:2x, có C6; M6 vẫn `43d96da4`, chờ M6-159), dữ liệu ở `/data/ginsengfood-marketing` (bản cũ `/data/m5` còn).
`mkt.ginsengfood.vn` HTTPS chạy từ 17/11 ~16:3x; webhook Meta xác minh đạt 18/11 sáng. Quyết định tới D-m5-066.
Sẵn sàng: **25% theo rà báo cáo tuần** (`SAN_SANG.md` BẢN NHÁP, chưa chấm lại). Go/No-go chậm nhất **20/11** (còn 2 ngày); chạy thật 30/11.

## 1. Thay đổi từ 16/11 20:34 (mốc git)

- module5: 26 PR gộp (#127…#152, 4 PR M6). Mã đã vào main: gỡ 2 route admin cũ (#131), JWT bắt `iat` (#142), tuổi token 8 giờ + `jti` + thu hồi (#150, C7),
  webhook chữ ký sai không ghi DB (#149, C6), sink cảnh báo thật Telegram (#145, M5-081B), che mật khẩu/OTP gõ bằng lời (#140, #148), role `m5_erasure` (#141),
  reader đơn M3 (#144), tự quay lui (#143), runbook dời dữ liệu (#133), sổ YouTube (#151, chỉ tài liệu; `src/` chưa có YouTube).
- Hồ sơ Go/No-go `GO_NO_GO_2026-11-13.md` bản 0.15: Done Gate 0/11 ĐẠT (3 CHƯA ĐẠT, 8 NOT_RUN); C1/C3/C4/C5 còn ghi "chưa gộp main", lệch git.
- Sheet M5 (07:53): 114 task · Hoàn thành 46 · Chờ review 30 · Đang làm 14 · Chưa bắt đầu 23 · Huỷ 1; 32 task quá hạn; 12 dòng YouTube M5-150…161 đã tạo.
- `can-ra`: 16 cần rà (002, 007, 016, 017, 074, 101, 103, 114, 121, 122, 126, 133, 141, 145, 146, 151); 6 chờ Tài sửa (036, 042, 051, 053, 104, 135).

## 2. Việc chặn

- **Meta (Tài báo 18/11 sáng):** webhook `mkt.` xác minh đạt (chỉ `feed`), sự kiện thử qua kiểm chữ ký, URL xoá dữ liệu đã lưu; 7 quyền mức chuẩn. Chặn: **thiếu URL
  chính sách** → app chưa phát hành (chỉ sự kiện thử) → chưa gắn Page pilot/token thật, chưa App Review (M5-102). Webhook bản cũ đã hết (3 tin rác không thêm dòng DB, Tài tự kiểm).
- **Sink CSKH + cảnh báo thật** (D-m5-021): Toàn chọn Telegram một bot hai nhóm (D-m5-066); mã có (#145), chưa có bot/nhóm, DL-234 chưa ký. Thiếu thì không SMK, không pilot.
- **URL chính sách:** chờ phiên lead thêm tuyến `/policy/` trên Caddy edge-98 — phiên lead đã trình Toàn **lead.101** (duyệt lượt ghi .98); xong thì có `hop-thu/m5-2026-11-18-tuyen-policy-xong.md`, rồi Tài đặt HTML.
  .98 ra ngoài đã thông (phiên lead thử TCP 10:4x): `api.telegram.org:443`, `pro56.emailserver.vn:465/587`, `graph.facebook.com:443`.
- Khoá deploy .98 đang có quyền ghi (TRK-93, Cao, trái DL-227) → Toàn gắn lại khoá chỉ đọc. CA cổng 8446 .99: Toàn gửi Tài (chờ từ 14/11).
- Tài chưa ký: DL-217, 222, 225, 227–231, 233, 234, 235, 237, 242, 243…247. M5-060 a3 đang chạy (2 lỗi Cao: treo chuỗi lặp, che nhầm "tiểu đường").

## 3. Quyết định 18/11 + việc của bạn

- 08:0x m5.48–51 → D-m5-058…061. 08:41 "ok 56 B, 54, 55, 47 A, 53 có" → **D-m5-062** chữ trang chính sách (phần Toàn) duyệt · **D-m5-063** hướng pilot
  (phát hành app, Page pilot + token thật, App Review song song, trước họp chỉ người có vai trò) · **D-m5-064** trang ở `mkt.ginsengfood.vn/policy/` (thay GitHub Pages)
  · **D-m5-065** đăng nhập bằng mã gửi mail @ssavigroup.com, M5 tự ký JWT, phiên m5 code M5-162 (thay D-m5-052) · **D-m5-066** Telegram. m5.52 đóng theo sự việc.
- Tin Tài bản cuối `ra-soat/2026-11-18-tin-tai-meta-youtube.md` (gộp mọi chốt 18/11 + YouTube) **chưa gửi**; kèm lại tệp DL-230 ngày 16/11.
- Việc tay của bạn: gửi tin Tài; tạo hộp mail gửi đi cho M5-162 (vd `noreply@ssavigroup.com`) + danh sách mail/vai được vào; gắn lại deploy key chỉ đọc; gửi CA 8446;
  M5-150 (danh sách kênh YouTube, người giữ đăng nhập, Owner Google Cloud, TXT DNS Mắt Bão).
- Không còn câu hỏi mở. Đã đóng: m5.40–56 (trừ số không dùng); m5.20 giữ như cũ.

## 4. Đang chạy + đề xuất kế

- **M5-162** (R3, `wp/M5-162.md`): coder v1 chạy nền từ 08:5x ở `_wt\m5\M5-162-dang-nhap-mail` (nhánh `m5/M5-162-dang-nhap-mail`, base `f6887c64`);
  18/11 11:30: v1–v4 + tester độc lập (≈340 ca, M6 thật 16/16) xong, nhánh @ `91a86495` chưa push; verifier CẦN SỬA (probe Redis store) — **chặn: máy Lead không có `redis-server`**.
  Tiếp: chạy probe Redis + M16/M17 ở máy có Redis → verifier vòng 2 → Toàn duyệt diff → CI_LOCAL → hỏi push. Sheet M5-162 Đang làm 60%.
- `/ra-soat tai`: 16 task `can-ra` (145, 146, 141, 126 chạm bảo mật — rà kỹ), cập nhật bảng Go/No-go.
- Dự báo Go/No-go 20/11: SMK, UAT, diễn tập khôi phục, pháp chế đợt 1, App Review chưa chạy → khả năng No-go lượt 2. `/ke-hoach` sau Go/No-go.

## 5. Bàn giao

- `_wt\m5\M5-162-dang-nhap-mail` đang dùng (junction `node_modules` → checkout chính; `web/node_modules` riêng). Hộp thư `hop-thu/m5-*` không có tệp mới. `hop-thu/m6-2026-11-16-m5-jwt-t6.md` là của phiên `m6`.
- Nguồn câu hỏi Tài: M4-PLAN `02_PROJECT_CONTROL/04_REPORTS/M5/M5-151/CAU_HOI_LEAD.md`, `bao-cao-dau-ngay-2026-11-18.md`, `_MEMORY/NHAT_KY.md` (đều ở `origin/main`).
