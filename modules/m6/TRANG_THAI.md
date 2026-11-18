# Trạng thái — m6

Mốc dữ liệu: 18/11/2026 07:53 · module5 `main` `aa6d55d4` = `origin/main`, checkout sạch (257 commit từ `6ee2bedc`, 34 chạm `m6/`) · tag `m6-l1-done` → `d7fe04e`
· Sheet đọc 07:53 · sổ Tài M4-PLAN local `fdc7e78b`, remote `3ff48a75` (chưa pull, sau 93; pull ở bước đầu `/ra-soat`). Phiên mở ở tài khoản Claude mới
(bàn giao `modules/lead/ban-giao/2026-11-18-chuyen-tai-khoan.md` §3.5).
Lịch: HTTPS `mkt.` chạy thật 17/11 ~16:3x (Caddy trên .98, D-m6-026) → Go/No-go 19/11, chậm nhất 20/11 (D-m6-013); lịch Tài 20/11; chạy thật 30/11.
Sẵn sàng: chưa chấm lại theo trọng số (`/ke-hoach`). Phần lớn P0 ở bậc Xong mã; chưa hạng mục nào Chạy thử.

## Từ lượt rà 4 (16/11, [bản rà](ra-soat/2026-11-16-tai.md)) tới nay

- Tài sửa cả 12 task Cần sửa 17/11 07:56–10:21 (Sheet "Chờ review", cập nhật sau lượt rà) + 2 task mới chờ rà: M6-039 (cờ an toàn đọc từ biến, #130),
  M6-054 (hộp nhận `m6_inbound_event` migration 0029 + consumer `ORDER_VERIFIED`, #146) → **14 task cần rà lượt 5**.
- PR gộp `main`: #130 (M6-039, M6-042 mã lý do từ chối JWT), #132 (sổ rà lượt 4), #134 (M6-100 bản khai khuôn A–D), #146 (M6-054). Hồ sơ Go/No-go M6-125 v0.3.
- Sổ DL M6: DL-105…109 = D-m6-021…025 (người chốt Toàn); DL-110…113 "CẦN XÁC NHẬN, chờ Tài ký" (110 map tên v1, 111 smoke Go/No-go S1–S4,
  112 nhãn STAGED + commit ứng viên — ghi "Tài và anh Toàn chờ chốt", 113 ba điểm lệch hợp đồng triển khai chung).
- Báo cáo đầu ngày Tài 18/11 07:38: .98 chạy `43d96da4` (deploy 17/11 15:37); M6-159 (`deploy.py` thư mục 700) Tester FAIL, phải gộp trước deploy M6 kế;
  M6-055 chờ Tester lượt 2; deploy .98 đợt 2 dự kiến chiều 18/11; báo cáo còn ghi "HTTPS .98 chưa có giờ" (lỗi thời).
- Hộp thư `m6-2026-11-16-m5-jwt-t6.md` (D-m5-050: mỗi người một `sub`, thu hồi khẩn = đổi khoá → khu Quảng cáo đăng xuất cùng M5) đã áp vào `PHIEN.md`, chuyển `xong/`.
- D-m6-026 (Caddy .98), D-m6-027 (bên mình tự sinh khoá JWT + phát token) đã áp vào `PHIEN.md`, `SAN_SANG.md`. Dọn máy: không dừng gì.

## Việc chặn

| Việc | Chặn gì | Ai gỡ | Hạn |
|---|---|---|---|
| Bật JWT trên .98: cặp khoá bên mình sinh, token có `iat` + `sub` riêng; Tài đề xuất chỗ sinh + người phát, Toàn duyệt (D-m5-052) | Khu Quảng cáo 401; nhập/duyệt chi phí cho M9 | Tài → Toàn | 19/11 |
| Deploy .98 đợt 2 (M6 có M6-159) + dời dữ liệu B2–B11 | Chạy thử M6 bản mới trên máy | Tài | 19/11 |
| Deploy key .98 có quyền ghi (TRK-93, trái D-m6-019) | An toàn repo | Toàn gắn lại khoá chỉ đọc | trước deploy đợt 2 |
| Tài chưa biết HTTPS `mkt.` đã chạy (báo cáo 18/11) | Khai Meta, trang chính sách (phía M5) | Toàn gửi tin HTTPS còn treo (bàn giao §2 mục 3, phiên `lead`) | 18/11 |
| M6 chưa nhận event ngoài test: route track/conversions chưa gắn (DL-O10 Tài + Phúc), DQ không có nguồn → KPI HOLD | ROAS null; chỉ đường chi phí dùng được ở Go/No-go | Tài, Phúc | trước chạy thật |

## Cần bạn quyết

- **m6.20** Họp Go/No-go M6 ngày nào? A = 20/11 cùng M5 theo lịch Tài · B = 19/11 đúng 2 ngày làm việc sau HTTPS. Đề xuất **A**: .98 chưa có JWT
  và M6-159, 14 task chưa Đạt; 20/11 vẫn trong hạn D-m6-013. Hạn trả lời 18/11; trễ quá 20/11 là phạm D-m6-013.
- **m6.21** Chốt DL-112 như Tài đề xuất? `STAGED` = có trong `main` + test Postgres thật nhưng chưa kiểm trên .98, `DONE` chỉ khi đã kiểm trên .98;
  commit ứng viên Go/No-go = `main` sau khi PR sửa lượt 4 gộp, có `CI_LOCAL` N/N, hồ sơ M6-125 ghi đúng SHA. Đề xuất **có**. Hạn trước họp; trễ thì hồ sơ không chốt được SHA.

## Đề xuất tiếp

1. `/ra-soat tai` lượt 5 ngay: 14 task, gồm DL-105…113, hồ sơ M6-125 v0.3, migration 0029 (M6-054 chạm doanh thu `ORDER_VERIFIED`), mã M6-039.
2. Tin Tài sau lượt 5: kết quả + JWT (đề xuất chỗ sinh khoá/người phát), M6-159 trước deploy đợt 2, ký DL-110/111/113, sửa "HTTPS chưa có giờ".
3. `/ke-hoach` chấm lại % sau lượt 5, trước họp Go/No-go.

Không có WP code/agent đang chạy; không worktree rà còn lại. Không sửa/commit repo Tài.
