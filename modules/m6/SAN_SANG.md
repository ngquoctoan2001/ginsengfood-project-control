# Sẵn sàng — M6 Đo quảng cáo / ROAS

> **BẢN NHÁP cập nhật 18/11/2026 07:5x** · rà lượt 4 ở `6ee2bedc`: 6 Đạt, 12 Cần sửa; 18/11 `main` `aa6d55d4`, Sheet 14 task chờ rà lượt 5.
> Chưa dựng lại điểm/trọng số toàn module. Cần `/ke-hoach`.

## Kết luận nhanh

Hạn chạy thật **30/11** (D-lead-025). Go/No-go họp 2 ngày làm việc sau khi `mkt.` trên máy mkt **.98** có HTTPS, **chậm nhất 20/11**;
release theo Go/No-go (D-m6-013, D-m6-015). Lịch phía Tài (OWN-342): chuẩn bị production 26–27/11. Không theo dõi quỹ giờ (D-m6-001).

Bằng chứng 16/11 (Lead chạy lại ở `6ee2bedc`): CI_LOCAL 10/10, pytest 3700 passed có Postgres 16, smoke 318, build image M6 đạt (uid 10001);
web không đổi từ lượt 3 (vitest 401/401). Phần lớn hạng mục P0 ở bậc **Xong mã**; M6 api/worker/pg chạy trên .98 nhưng **chưa hạng mục nào ở bậc Chạy thử**.
HTTPS `mkt.` chạy thật từ 17/11 ~16:3x (Caddy trên .98, D-m6-026) → Go/No-go 19/11, chậm nhất 20/11 (lịch Tài: 20/11).
Còn chặn tới Go/No-go: bật JWT trên .98 (mã đã gộp #125, #130; bên mình tự sinh khoá + phát token có `iat`, D-m6-027; Tài đề xuất chỗ sinh + người phát),
deploy .98 đợt 2 (cần M6-159), dời dữ liệu B2–B11, deploy key .98 còn quyền ghi (TRK-93), hồ sơ Go/No-go M6-125 v0.3, DL-110…113 chờ ký.
Chưa nhận event ngoài test (route track/conversions chưa gắn, DL-O10; DQ không có nguồn) → ROAS null, KPI HOLD; M6-054 đã gộp hộp nhận `ORDER_VERIFIED` (0029).

## Gói việc cần theo dõi

| Gói | Hiện trạng / bằng chứng (16/11, `6ee2bedc`) | Bước kế tiếp / người | Hạn |
|---|---|---|---|
| Nền repo, test (L0) | M6-015 Đạt (CI_LOCAL theo DL-089); CI_LOCAL 10/10; quét bí mật 89/89 đã biết; GitHub Actions không chạy (thanh toán) | Bom giờ CI 01/12 (ADS-P0-016, M6-055) | trước 30/11 |
| L1 CH21 | M6-020…023 Đạt; tag `m6-l1-done` ở `d7fe04e`; M6-024 Cần sửa (bảng WT mục 4, thẻ M6-025; thư xin soát bỏ theo D-m6-024) | Tài ghi DL + sửa sổ | trước Go/No-go |
| API, xác thực | 043, 044, 045, 142, 145, 147, 150, 152, 155 Đạt; M6-042 JWT thật gộp #125 + mã lý do từ chối #130, DL-105 đã ghi, chờ rà lượt 5; M6-039 cờ an toàn đọc từ biến gộp #130 (DL-101), chờ rà | Tài; bên mình sinh khoá + phát token (D-m6-027) | 19/11 |
| Nghiệp vụ đo, DQ | 036, 046, 053, 060, 062, 063, 064, 135, 138, 139 Đạt; 051, 052, 082, 133 Cần sửa (sổ/DL; mã 082, 133 đạt); DQ ngữ cảnh rỗng → mọi dòng HOLD; route track/conversions chưa gắn (DL-O10) | Tài (DL theo D-m6-022), Phúc (DL-O10) | trước chạy thật |
| Rủi ro, recall | 072, 073, 074, 075, 077, 081 Đạt; DL-O28 mở (còn trỏ .63) → recall UNVERIFIED mọi SKU | Tài chốt DL-O28 trước khi nối ops-core thật | trước chạy thật |
| UI quản trị (lane N) | M6-141…153 Đạt; web không đổi từ lượt 3; khu Quảng cáo 401 tới khi bật JWT; M6-154 E2E chưa làm | Chờ JWT + HTTPS `mkt.` | Go/No-go |
| Hạ tầng, phát hành | 102, 156 Đạt; 100, 120, 125, 131, 157, 038 Tài sửa 17/11, chờ rà lượt 5; bản khai khuôn A–D gộp #134 (DL-113 lệch hợp đồng chung, chờ ký); hồ sơ Go/No-go v0.3; .98 chạy `43d96da4` (deploy 17/11 15:37, theo báo cáo Tài 18/11); M6-159 (`deploy.py` thư mục 700) Tester FAIL, phải gộp trước deploy M6 kế | Tài: M6-159, deploy .98 đợt 2, B2–B11, ký DL-110…113; Toàn: gắn lại deploy key chỉ đọc (TRK-93) | 19–20/11 |
| Nối M9 (chi phí) | 134, 137 Đạt (API + job materialize + PG đầu-cuối) | Chạy M6 trên .98, bật JWT, Toàn cấp token dịch vụ hai phía, Phúc đặt nguồn M9 = `m6` | trước chạy thật |

## Phạm vi đã duyệt và cổng

- Nguồn kế hoạch: `module5/m6/docs/04-sdlc/SPRINT_PLAN_2026-11-15.md` v1.6 + `GO_NO_GO_2026-11-13.md`; 11 task P1 và L8 để sau.
- Chưa nối M3 thật: doanh thu/ROAS null kèm lý do; client ops-core thật tắt tới khi ba ca chấp nhận đạt (DL-052).
- GLOBAL_GATEWAY_STATE BLOCKED, PRODUCTION_FLAG OFF, gửi ngoài OFF (`m6/app/config.py:11-13`). Không có lệnh đổi cờ hay triển khai trong phiên này.
- Migration chỉ thêm (DL-076) áp từ bản production đầu tiên (OWN-325); 0001–0029 (0029 `m6_inbound_event`, M6-054 #146, 17/11).
- Rà DL: DL kỹ thuật PM của Tài chốt có nguồn thì không bắt lỗi; chạm phạm vi pilot, Go/No-go, dữ liệu khách, bảo mật → Cần sửa (D-m6-013).

## Việc chờ quyết / đối chiếu

| Mã | Việc | Hạn |
|---|---|---|
| M6-114 T-5/6/7/10 | Chưa chốt, đang dùng mặc định trong bảng (T-5 cần Sếp + pháp chế) | quá hạn 09/11 |
| Đã đóng | m6.1–m6.19 (D-m6-006…025); 16/11: JWT exp − iat (021), chặn PSID (a) (022), bước 1 docker trên máy dev (023), bỏ thư xin soát L1 (024), nhãn khoá V1–V3 + cổng khoá↔principal (025) — Tài ghi DL | — |

Bản rà: [02/11](ra-soat/2026-11-02-tai.md) · [03/11 lượt 1](ra-soat/2026-11-03-tai.md) · [03/11 lượt 2](ra-soat/2026-11-03-tai-b.md) · [05/11 lượt 1](ra-soat/2026-11-05-tai.md) · [05/11 lượt 2](ra-soat/2026-11-05-tai-b.md) · [13/11 lượt 3](ra-soat/2026-11-13-tai.md) · [16/11 lượt 4](ra-soat/2026-11-16-tai.md).
