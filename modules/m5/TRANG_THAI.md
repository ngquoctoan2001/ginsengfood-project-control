# Trạng thái — m5

Cập nhật 13/11/2026 15:10 (Asia/Bangkok; rà 16 + 4 task của Tài; Lead chốt m5.21, m5.30–34; máy chủ D-m5-040). module5 ghim `2f733b2` (13/11 07:47); M4-PLAN `a56d077`.
Máy: M5 + M6 ở máy mkt 192.168.1.98 (`/data/m5`), M3 + M4 sang .99 sau 14/11 22:45 (`chung/MAY_CHU.md`). M5 chưa chạy trên máy chủ nào; `PRODUCTION_ENABLED=false`. Sẵn sàng: **25% theo rà báo cáo tuần** (`SAN_SANG.md` BẢN NHÁP, chấm lại ở `/ke-hoach`).
Kịp 15/11: **ĐỎ** (máy mkt .98 mới cấp 13/11, chưa HTTPS `mkt.`, chưa nhận webhook). Go/No-go lượt 13/11: **No-go** (D-m5-035), họp lại HTTPS `mkt.` trên .98 + 2 ngày làm việc, chậm nhất 20/11.

## 1. Rà task

- **12/11** (`c8cdd47`, 16 task): **2 Đạt (124, 136) · 14 Cần sửa**. [Bảng](ra-soat/2026-11-12-tai.md). Sheet 13/11 07:08, 16/16 khớp.
- **13/11** (`2f733b2`, 4 task Tài gộp tối 12/11): **017, 103, 114, 121 Cần sửa**. [Bảng](ra-soat/2026-11-13-tai.md). Sheet 08:06, 4/4 khớp.
- Chờ Tài sửa: 20 task (18 trên + 002, 043, 055, 074, 104, 133 từ trước). Sheet: kết quả ở cột W/X; cột Trạng thái (J) là của Tài, công cụ không đổi.
- Tin nháp cho Tài (một tin cho 20 task): [2026-11-12-tai-tin-nhan-nhap.md](ra-soat/2026-11-12-tai-tin-nhan-nhap.md), chưa gửi.
- Test 13/11 @`2f733b2`: typecheck sạch; không DB 182/28/3 (ngoài 4 task; `main-process` chạy riêng PASS); DB tạm 209/0/4 (chạy riêng: 2 PASS; còn E4/E5 của 135 và `prisma-m4-conversation` ngoài phạm vi).
  12/11 @`c8cdd47`: `prisma-data-deletion-erasure-db` E4/E5 đỏ 5 lượt (135).

## 2. Phát hiện chính

- **Xoá dữ liệu theo người (135) sẽ quay lui trên máy chạy thật** (`db-setup.sql:29` thu UPDATE `audit_log` của `m5_app`); gói pháp chế, FR-OPS-022, TRACKING, Go/No-go chưa xếp đúng mức.
- **Gửi thử trên .98 của 042/043/051/053/056 bị cổng khởi động chặn** khi sink CSKH/cảnh báo còn giả → M5-081B/M5-104 là đường găng.
- **Production không khởi động khi `ORDER_STATE_READER` còn giả** (M5-017, đúng thiết kế); lớp thật + hợp đồng M3→M5 chưa có → D-m5-036: Phúc làm API M3,
  Tài viết reader, trước 30/11; gói task + sơ đồ [giao-viec/2026-11-13-order-state-reader.md](giao-viec/2026-11-13-order-state-reader.md). Phiên `lead` đã tạo
  **M3-181** (Phúc) và **M5-144** (Tài, deps M3-181); cột "Xong khi" của cả hai còn ghi ".60", cần sửa thành .98 → .99.
- **Pilot có AI (D-m5-034):** Claude API soạn câu tin riêng; bật khi có pháp chế đợt 2 (D-m5-037) + NCC A1–A6 + P0 M4 + chữ M5-101 khai AI. Luật 10
  `scoped-send-posture.ts:61` hiện từ chối khởi động khi AI tự trả lời bật → Tài sửa + DL thay DL-200 (4). Báo giá chặn suốt pilot (D-m5-039).
- 126 chưa sửa (mật khẩu/OTP lọt 9/9); 112 chưa đạt lỗi Cao; pháp chế chưa gửi; probe một cửa gửi (017) hở với bí danh/lớp con.

## 3. Việc chặn

- Tài dựng máy mkt .98 (nền + app, CI → registry → CD; D-m5-040). Anh Tuấn: trỏ HTTPS `mkt.` về .98, lối ra graph.facebook.com, khoá JWT → chặn 016/042/043/053/056/093 chạy thật, App Review.
- Tài: quyền `audit_log` + DL-217 + E4/E5 (135); vá 126/H2; M5-081B/M5-104; token System User; DL-163 tin riêng (017); B1–B5 + gửi pháp chế 2 đợt; Go/No-go 0.6;
  DL thay DL-200 (4) + luật 10 + chữ khai AI (D-m5-034); reader thật (D-m5-036).
- Phúc (M3-181): API đọc trạng thái đơn + review hợp đồng M3→M5 trong `ginsengfood-contracts` (D-m5-036), hạn 21/11.
- Bạn: các câu dưới; lưu trữ module6; HTTPS `mkt.` với Anh Tuấn; P22 M5-101.

## 4. Cần bạn quyết

- **m5.20** D-m5-023: M5-032 xong khi qua V1–V9, P1–P8, dòng 1–12; dòng 13–14 + kiểm DB .98 thành điều kiện bật `M5_PSID_READ_MODE=on`.
- Việc của bạn: gửi tin nháp cho Tài (sẵn gửi, không còn câu đề xuất); đối chiếu P01/P02 + đọc câu AI khi Tài gửi chữ M5-101 (D-m5-038); hỏi pháp chế;
  người giữ Haravan; tab người ngoài cho Chú; phiếu M5-123.
- Đã đóng: m5.21, m5.34 (D-m5-038, D-m5-039, 13/11 09:11); m5.30–33 (D-m5-034…037, 13/11 08:40); m5.27–29, m5.6 (D-m5-030…033, 13/11 07:39); m5.26 (D-m5-029); m5.22–25 (D-m5-025…028); m5.13–19; m5.7; m5.1, 3, 4, 5, 8–12.

## 5. Bàn giao

- Worktree rà 12/11, 13/11 (`C:\Projects\_wt\m5\rv1211-*`, `rv1311-*`) đã gỡ (junction gỡ trước, không `--force`); container tạm đã dừng; `_wt\m5` trống.
  Bằng chứng: `ra-soat/evidence/2026-11-12-tai/`, `ra-soat/evidence/2026-11-13-tai/`.
- Rà task: không sửa code của Tài, không gửi tin. Nhánh cục bộ làn Lead `m5/M5-137-*`, `m5/M5-138-*` còn (không xoá nhánh).
- Lượt rà sau: task Tài cập nhật → `can-ra --module M5 --owner Tài`; ưu tiên 135, 126, 104, 114 bản 0.6.
