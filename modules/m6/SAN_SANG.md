# Sẵn sàng — M6 Đo quảng cáo / ROAS

> **BẢN NHÁP cập nhật 13/11/2026 09:37** · rà lượt 3 ở `2f733b21` (module5 `main` = `origin/main`, M6 ở `m6/`).
> Chưa dựng lại điểm/trọng số toàn module. Cần `/ke-hoach`.

## Kết luận nhanh

Hạn chạy thật **30/11** (D-lead-025). Go/No-go M6 không họp 13/11: họp 2 ngày làm việc sau khi `mkt.` trên .60 có HTTPS, **chậm nhất 20/11**;
release theo Go/No-go (D-m6-013, D-m5-028). Lịch phía Tài (OWN-342): chuẩn bị production 26–27/11. Không theo dõi quỹ giờ (D-m6-001).

Theo bằng chứng 13/11, phần lớn hạng mục P0 ở bậc **Xong mã** (kiểm tự động đạt, Lead chạy lại): pytest 3413 passed (2 ca chỉ đỏ khi thiếu
lịch sử git), web vitest 401/401 + build đạt. **Chưa hạng mục nào ở bậc Chạy thử** trên .60. Bốn việc chặn đường tới Go/No-go:
tag `m6-l1-done` chưa gắn (deploy dừng mã 11), chưa có đăng nhập admin thật (DL-O09), chưa định tuyến `/api/admin/ads/` tới m6-api trên proxy .60,
compose chưa đủ biến và docker build chưa chạy.

## Gói việc cần theo dõi

| Gói | Hiện trạng / bằng chứng (13/11, `2f733b21`) | Bước kế tiếp / người | Hạn |
|---|---|---|---|
| Nền repo, test (L0) | CI_LOCAL 9/10 (2 ca môi trường); quét bí mật đạt, 89 phát hiện đã biết; PR #56, #57 squash; M6-015 Cần sửa (sổ) | Tài sửa thẻ M6-015; ghi squash vào WT | trước Go/No-go |
| L1 CH21 | M6-020…023 Đạt; M6-024 Cần sửa: DL theo D-m6-010/009 chưa ghi, thư chưa gửi; **tag chưa gắn** | Tài ghi DL + gắn tag ở `d7fe04e` | ngay |
| API, xác thực | 043, 045, 142, 145, 147, 150, 152, 155 Đạt (DL-083 Lead xác nhận, D-m6-014); 042, 044 chờ sửa; auth chỉ NONE/FAKE (`settings/auth.py:14`) | Tài + Anh Tuấn chốt DL-O09 | trước staging |
| Nghiệp vụ đo, chi phí | 036, 046, 053, 060, 062, 064, 135, 138, 139 Đạt; 052, 133, 137 Cần sửa; 051, 063, 134, 136 chờ sửa; chưa producer DQ (mọi dòng HOLD); TRK-82; DL-098 lệch số commission | Tài | trước Go/No-go |
| Rủi ro, recall | 072, 073, 074, 075, 077, 081 Đạt; DL-O28 mở → recall mở UNVERIFIED mọi SKU; TRK-86/87 | Tài chốt DL-O28 trước khi nối ops-core thật | trước chạy thật |
| UI quản trị (lane N) | M6-141…153 Đạt (13); web typecheck/lint/build đạt, vitest 401/401; M6-154 E2E .60 chưa làm | Chờ DL-O09 + route proxy | Go/No-go |
| Hạ tầng, phát hành | 102, 156 Đạt; 100 (bản khai, TRK-89), 120 (thiếu ADS-P0-016), 125 (hồ sơ DRAFT, lịch cũ), 131 (docs .63, DL cũ) Cần sửa; docker build chưa chạy | Tài; Anh Tuấn nhận bản khai | trước Go/No-go |
| Nối M9 (chi phí) | Đường chi phí M6-137 chạy đầu-cuối trên PG (Cần sửa TRK-81); M6-134 chờ sửa | Tài | trước chạy thật |

## Phạm vi đã duyệt và cổng

- Nguồn kế hoạch: `module5/m6/docs/04-sdlc/SPRINT_PLAN_2026-11-15.md` v1.6 + `GO_NO_GO_2026-11-13.md`; 11 task P1 và L8 để sau.
- Chưa nối M3 thật: doanh thu/ROAS null kèm lý do; client ops-core thật tắt tới khi ba ca chấp nhận đạt (DL-052).
- GLOBAL_GATEWAY_STATE BLOCKED, PRODUCTION_FLAG OFF, gửi ngoài OFF (`m6/app/config.py:11-13`). Không có lệnh đổi cờ hay triển khai trong phiên này.
- Migration chỉ thêm (DL-076) áp từ bản production đầu tiên (OWN-325).
- Rà DL: DL kỹ thuật PM của Tài chốt có nguồn thì không bắt lỗi; chạm phạm vi pilot, Go/No-go, dữ liệu khách, bảo mật → Cần sửa (D-m6-013).

## Việc chờ quyết / đối chiếu

| Mã | Việc | Hạn |
|---|---|---|
| M6-114 T-5/6/7/10 | Chưa chốt, đang dùng mặc định trong bảng (T-5 cần Sếp + pháp chế) | quá hạn 09/11 |
| Đã đóng | m6.1–m6.12 (D-m6-006…011, D-m6-014 xác nhận DL-083), D-m6-012 (UI), D-m6-013 (lịch, luật PM chốt DL) | — |

Bản rà: [02/11](ra-soat/2026-11-02-tai.md) · [03/11 lượt 1](ra-soat/2026-11-03-tai.md) · [03/11 lượt 2](ra-soat/2026-11-03-tai-b.md) · [05/11 lượt 1](ra-soat/2026-11-05-tai.md) · [05/11 lượt 2](ra-soat/2026-11-05-tai-b.md) · [13/11 lượt 3](ra-soat/2026-11-13-tai.md).
