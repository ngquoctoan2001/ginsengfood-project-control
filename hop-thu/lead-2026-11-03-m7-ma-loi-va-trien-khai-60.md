# Từ phiên `m7` · 03/11/2026 · Mã lỗi `COMMON.*` cần đăng ký CONTRACTS; chỗ trống bố trí M7 trên .60

Nguồn: M7-WP14 (sóng 2), repo `ginsengfood-golden-hour-video` DECISION_LOG v2.7 (DL-099…DL-103, chưa commit tới khi Lead lệnh).
Liên quan: `hop-thu/lead-2026-11-03-m7-deploy-contract.md` (9 điểm lệch, đã gửi 09:37), D-lead-013, D-m7-033…037.

## 1. Mã lỗi M7 chưa có trong `ginsengfood-contracts` (@`08585c1`)

M7 dùng các mã dưới đây làm tên nháp (DL-013: chief/hợp đồng chung giữ tên). Không mã nào có trong `error-codes/*.yaml`.
Phiên `lead` chốt: thêm vào `error-codes/common-errors.yaml`, đổi tên theo chuẩn chung, hay M7 dùng mã sẵn có.

| Mã nháp M7 | HTTP | Dùng ở | Ghi chú |
|---|---|---|---|
| `COMMON.UNAUTHENTICATED` | 401 | T006, T007 | Thiếu hoặc sai token |
| `COMMON.NOT_FOUND` | 404 | T006 | |
| `COMMON.METHOD_NOT_ALLOWED` | 405 | T007 (DL-103) | Kèm header `Allow` |
| `COMMON.PRECONDITION_FAILED` | 412 | T006 | `If-Match` lệch |
| `COMMON.PAYLOAD_TOO_LARGE` | 413 | T006 | Thân quá 1 MiB |
| `COMMON.UNSUPPORTED_MEDIA_TYPE` | 415 | T007 (DL-103) | |
| `COMMON.RATE_LIMITED` | 429 | T176 (sau) | |
| `COMMON.INTERNAL_ERROR` | 500 | T006 | Không lộ thông điệp nội bộ |
| `COMMON.SERVICE_UNAVAILABLE` | 503 | T007, T176 (DL-125, thêm 03/11/2026 15:34) | Kèm `Retry-After`; trước đây 503 không có mã |

Mã riêng M7 (`GH_*`: `GH_ROLE_NOT_ALLOWED`, `GH_GLOBAL_HALT_ACTIVE`, `GH_INVALID_TRANSITION`, `GH_IDP_UNAVAILABLE` 503 theo DL-122) giữ trong M7, không cần đăng ký.
Quy tắc M7 (DL-125): mã HTTP lỗi khung không thân ngoài bảng đổi về 400 `VALIDATION.INVALID_FIELD_VALUE` (4xx) hoặc 500 `COMMON.INTERNAL_ERROR` (5xx).
Nguồn: `docs/05-reference/api-schemas.md` §2.10, §2.11 (v2.1; DL-125 áp ở M7-WP16); DECISION_LOG v2.9 (D-m7-044).

## 2. Bố trí M7 trên .60 — chỗ còn trống

SAD v2.2 §13.3 đã viết lại cho .60 theo DL-099, có bảng 9 điểm lệch (contract ghi gì, M7 chọn gì, lý do). Còn chờ phiên `lead` và anh Tuấn:
- Thư mục dự án compose `m7` trên .60.
- Cổng của M5, M6 trên .60 để tránh trùng; M7 đề xuất dải 6700–6799, `m7-edge` publish 6700.
- Cổng vào chung của .60 (tên miền, HTTPS): M7 không bắt buộc ra Internet ở đợt 1.
- Đề xuất: health của `m7-edge` dùng `/health/ready` thay `GET /health` của contract.
- Sửa `MODULE_DEPLOY_CONTRACT.md` hay thêm phụ lục ngoại lệ cho M7 (đã nêu ở thư 09:37).

Cần trước M7-T015 (Dockerfile, compose; theo nhịp đo khoảng 10/11/2026) và bắt buộc trước M7-T103.

Xong thì chuyển tệp này sang `hop-thu/xong/`.
