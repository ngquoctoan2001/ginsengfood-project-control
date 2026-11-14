# Sẵn sàng — M5 Facebook Gateway

> **BẢN NHÁP**, cập nhật sau rà 16 task 12/11 (`c8cdd47`) + 4 task 13/11 (`2f733b2`, ghi Sheet 13/11 08:06). Hạng mục/trọng số chấm lại khi `/ke-hoach`.
> Mốc rà tuần 31/10 ghi 11%; chưa phải mức sẵn sàng hiện tại. Không lấy số task Đạt hay DONE làm % sẵn sàng.
> D-m5-002: đã duyệt 7 mẫu M5-105, giờ CSKH 8:00–20:00. D-m5-005/DL-197 + D-m5-040: một môi trường trên máy mkt 192.168.1.98 (thay .60), khoá chạy thật tắt tới họp Go/No-go (HTTPS `mkt.` trên .98 + 2 ngày làm việc, chậm nhất 20/11). D-m5-025: M6 gộp vào repo `m6/`.
> M3 + M4 sang .99 sau giờ cắt 14/11 22:45: M5 gọi `M4_ADVISOR_BASE_URL`, `M3_ORDER_STATE_*` qua `http://192.168.1.99:80` (`chung/MAY_CHU.md`).
> D-m5-018 (DL-200/DL-194): giữ pilot 14/11; nộp App Review khi đủ HTTPS `mkt.` trên .98 + token Page + M5-101; Meta chưa duyệt → pilot chỉ
> người có vai trò; pilot chỉ chạy giờ có người trực. D-m5-021: M5-104 bắt buộc trước pilot.
> D-m5-034…037 (13/11 08:40): pilot M4 dùng Claude API trả lời tin riêng, bật khi có văn bản pháp chế đợt 2 + NCC A1–A6 + P0 M4 + chữ M5-101 khai AI; báo giá vẫn chặn (D-m5-015);
> No-go lượt 13/11, họp lại HTTPS + 2 ngày làm việc (≤ 20/11); production cần `ORDER_STATE_READER` thật (M3 Phúc + M5 Tài, trước 30/11).

## Kết luận nhanh

Rà 12/11: 16 task, **2 Đạt** (124, 136), **14 Cần sửa** ([bảng](ra-soat/2026-11-12-tai.md)). Rà 13/11: 017, 103, 114, 121 đều **Cần sửa** ([bảng](ra-soat/2026-11-13-tai.md)).
6 chờ Tài sửa từ trước (002, 043, 055, 074, 104, 133).
Rà 10/11: 2 Đạt (054, 064), 6 Cần sửa ([bảng](ra-soat/2026-11-10-tai.md)). Rà 07/11: 6 Đạt ([bảng](ra-soat/2026-11-07-tai.md)).
Mã: phần lớn năng lực ingest, gửi đi, an toàn nội dung, phân quyền, token ở **bậc 50 – Xong mã**. 8/14 task Cần sửa lượt này là "mã đạt, còn chạy trên máy hoặc chờ chốt".
Còn chặn: (1) gửi thử trên .98 của 042/043/051/053/056 bị cổng khởi động chặn khi sink CSKH/cảnh báo còn giả (D-m5-021) → M5-081B/M5-104 đi trước cả cụm;
(2) xoá dữ liệu theo người (135) sẽ quay lui trên máy chạy thật vì `db-setup.sql:29` thu UPDATE `audit_log` của `m5_app`; DL-217 chưa ký; probe DB E4/E5 đỏ 4 lượt trên máy Lead;
(3) mật khẩu/OTP gõ bằng lời còn lọt 9/9 mẫu (126, chưa sửa); (4) DL-222/224/225 còn chờ Tài ký (chữ 3.4 đã duyệt 13/11, D-m5-030).
Probe tự chạy 12–13/11 tại `c8cdd47`: không DB 179/28/3, DB 205/0/5, `web/` 386/15 (chạy lại riêng: xem bảng rà §4). Dockerfile: Tài build khi triển khai .98 (D-m5-029).
Chưa năng lực nào lên bậc 75: M5 chưa chạy trên .98, chưa gọi Meta thật, chưa SMK.
Đường găng: Tài dựng nền + app trên máy mkt .98 (CI → registry → CD) + Anh Tuấn trỏ HTTPS `mkt.` về .98 → sink CSKH thật (M5-081B/M5-104) → token Page thật (053) + khoá JWT (016) → trả lời thật (042/043/056) → App Review (102) cùng M5-101 + URL hướng dẫn xoá.
Kịp 15/11: **ĐỎ** (máy mkt .98 mới cấp 13/11, chưa nhận webhook). Go/No-go lượt 13/11: **No-go** (D-m5-035), họp lại 2 ngày làm việc sau HTTPS `mkt.` trên .98, chậm nhất 20/11.
Production không khởi động khi `ORDER_STATE_READER` còn giả (M5-017) → M5-115 chờ API đọc trạng thái đơn M3 (Phúc) + reader thật (Tài), trước 30/11 (D-m5-036;
gói task + sơ đồ: [giao-viec/2026-11-13-order-state-reader.md](giao-viec/2026-11-13-order-state-reader.md), phiên `lead` tạo trên Sheet).
Pilot có AI (Claude API, D-m5-034) thêm đường găng: pháp chế đợt 2 (M5-103, chưa gửi) → `AI_ADVISOR_MODE` trên .98; luật 10 chế độ phạm vi phải sửa. Báo giá chặn suốt pilot (D-m5-039).

## Gói việc theo làn (mỗi gói = nhiều task Sheet)

| Gói | Task | Tình trạng 12/11 | Phụ thuộc |
|---|---|---|---|
| Nhận tin (ingest) + xoá dữ liệu | C030–037, B022/023, M5-135 | 030–035/037, 022/023 Đạt; 036 Cần sửa (callback đạt, chờ 135); 135 Cần sửa (EVIDENCE_STORE + mẫu máy 11 kho xong; quyền `audit_log`, DL-217, E4/E5, purge, CLI trên .98) | dòng 13–14 CH21 + kiểm DB .98 trước bật đọc PSID (m5.20); Tài ký DL-217 |
| Gửi đi + bình luận | E050–056, D040–044, M5-042 | 040/041/044/050/052/054 Đạt; 042, 043, 056 Cần sửa (mã đạt, còn chạy trên .98); 051 Cần sửa (vault.env xong; gửi thử trên .98, hạn 48 giờ, PR #75); 055 chờ sửa | M5-081B/M5-104 mở cổng khởi động; .98 + token; DL-224 ý (2), (5) |
| An toàn nội dung | F060–065, 124, 126, 127–132 | 061–065/124/127–132 Đạt (124 Đạt 12/11); 126 Cần sửa (chưa sửa); 060 Cần sửa (corpus 0 lọt 0 che nhầm; D-m5-031 nhận che thừa + 11 tên phố phụ, chỉ còn Tài ký DL-225) | M5-104 kênh CSKH (bắt buộc trước pilot); chữ 3.4 đã duyệt (D-m5-030); opt-out chưa chặn tin riêng từ bình luận (TRK-44) |
| Chuyển người | M5-122 | Cần sửa (mã đạt; chữ 3.4 duyệt 13/11 D-m5-030; DL-222 chờ Tài; `text-set-v1.md` cũ) | Tài ký DL-222 |
| Phân quyền + token | A015–017, M5-053, 125 | 015/125 Đạt; 016, 053 Cần sửa (mã đạt, chưa khoá/token thật); 017 Cần sửa (mã đạt; DL-163 cho tin riêng chưa chốt; probe một cửa gửi lọt bí danh/lớp con) | Anh Tuấn: khoá JWT; Tài: token System User |
| AI + chuyển người thật | G070–074 | 070/071/072/073 Đạt; 074 chờ sửa (D-m5-020) | M4-004 (luồng `m34`); Page pilot bật AI tin riêng bằng Claude API khi có pháp chế đợt 2 (D-m5-034/037); DL thay DL-200 (4), sửa luật 10 `scoped-send-posture.ts:61` |
| Vận hành + bằng chứng | H080–084, B024, M5-112, 133, 136 | 024/080/082/084 Đạt; **136 Đạt 12/11** (D1 DB PASS, thoát 0); 112 Cần sửa (H1/H2, rà 3 PR sau, mục `audit_log` lên Cao); 133 chờ sửa | M5-081 sink thật; GitHub Actions dừng; điều kiện gộp: khối CI_LOCAL `GATE=ĐẠT` trong PR, không cần status (D-m5-032); Dockerfile: Tài build khi triển khai .98 (D-m5-029) |
| Quy tắc làm việc | M5-007 | Cần sửa: bạn duyệt §5 bản `f774f759` 13/11 (D-m5-033); chờ Tài sửa §5.4 điều 4 theo D-m5-032 | Tài |
| Hạ tầng | I090–094, M5-004 | 093 bộ triển khai/quay lui đã gộp (PR #61), chưa chạy; ghi chú/hạn trên Sheet (004, 090–094) còn ghi .60, Tài sửa theo .98 | Tài dựng máy mkt .98; Anh Tuấn trỏ HTTPS `mkt.` |
| Meta, pháp lý, thí điểm | J100–105 | 105 Đạt; 101 Cần sửa (D1 PA1/PA2; chữ Tài chốt, bạn đối chiếu P01/P02 + đọc câu AI D-m5-038; purge, P04/P22); 103 Cần sửa (nháp khớp mã; chưa gửi pháp chế; B1 Có, B3 Không, chia 2 đợt D-m5-037) | App Review sau HTTPS `mkt.` .98 + token + 101 (D-m5-018) |
| Đăng bài nhiều Page | M5-123 | phiếu 1 trang có, chờ bạn duyệt; ngoài Go/No-go (D-m5-012) | sau App Review; quyền Tiêu chuẩn (D-m5-016); link tên miền công ty (D-m5-017) |
| UI quản trị (làn Lead, D-m5-024) + UI-kit | M5-137, M5-138, M5-139 | 137/138 Đạt (`da306af` 09/11, [duyệt R3](ra-soat/2026-11-09-ui-quan-tri-duyet-r3.md)); 139 Cần sửa (bước 1–3 đạt; bước 4 AppShell chưa làm; PR #95 thiếu CI_LOCAL) | chạy trên .98 + JWT vai OPS/ADMIN (Anh Tuấn); Tài triển khai ([tin](ra-soat/2026-11-09-tin-tai-ui-quan-tri.md)) |
| QA + phát hành | K110–115, L121, B025 | 114 Cần sửa (hồ sơ 0.5 trung thực; Toàn chọn A No-go D-m5-035, chờ bản 0.6 + DL); 121 Cần sửa (khớp mã; 57 mục "Chưa chắc", RELEASE_NOTES) | tuần tự cuối; M5-115 cần `ORDER_STATE_READER` thật (D-m5-036) |

## Việc chờ Lead

| # | Việc | Nguồn | Hạn |
|---|---|---|---|
| — | Đưa prompt `ORDER_STATE_READER` sang phiên `lead` (tạo task Phúc/Tài trên Sheet + khung hợp đồng) | D-m5-036, `hop-thu/lead-2026-11-13-m5-order-state-reader.md` | sớm |
| m5.20 | M5-032 tiêu chí xong | D-m5-023 | trước bật đọc PSID |
| — | Đối chiếu P01/P02 M5-101 với giấy ĐKKD, đọc câu AI trước khi đăng (D-m5-038) | M5-101 | khi Tài gửi chữ |
| — | Hỏi pháp chế P07, P12, P13, P14, P19, P20; người giữ Haravan; tab người ngoài cho Chú | D-m5-011/013 | trước App Review |

Việc nhắc Tài (tin nháp 12/11): quyền `audit_log` + DL-217 (135); vá 126; H1/H2 (112); xếp M5-081B/M5-104 trước cụm chạy trên .98; DL-222, DL-224, DL-225;
D1 M5-101 với Anh Tuấn; bước 4 AppShell (139); cột commit Sheet 056/122/139; task riêng cho 16 probe `process.exit`;
DL-163 tin riêng + vá single-send-door (017); B1 Có/B3 Không + gửi pháp chế 2 đợt (103); Go/No-go 0.6 (114); "Chưa chắc" bảo mật + RELEASE_NOTES (121);
DL thay DL-200 (4) + luật 10 chế độ phạm vi + chữ chính sách khai AI (D-m5-034); `ORDER_STATE_READER` thật (D-m5-036).

## Bằng chứng rà 05/11

| Phần | Bằng chứng | Còn thiếu |
|---|---|---|
| FinalGuard, luật nội dung | real-final-guard 432/0, final-guard-link 82/0, 11 đột biến đỏ; 7 mẫu duyệt PASS | "bác sỹ", "phòng ngừa" lọt; `--pilot` 7 ca lọt |
| Chuyển người, tự hại | cskh-alert 41/41, self-harm 117/117, human-pause 32/32 | câu quá liều lọt; kênh CSKH giả |
| Phân quyền, token, gửi lại | rbac-real-matrix, page-token, retry-runner PASS; CI DB 182/0/0 | khoá JWT thật, token thật, DL-120 |
| Chạy thật | — | triển khai .98, SMK trên môi trường, UAT, App Review |
