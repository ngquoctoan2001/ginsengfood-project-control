# Trạng thái — m6

Mốc dữ liệu: 13/11/2026 09:37 · module5 `main` `2f733b21` = `origin/main` (M6 ở `m6/`, DL-096) · M4-PLAN `main` `80c5f0c9` · Sheet đọc 08:34.
Lịch (D-m6-013): Go/No-go 2 ngày làm việc sau khi `mkt.` .60 có HTTPS, chậm nhất 20/11; release theo Go/No-go; chạy thật 30/11 (D-lead-025).
Sẵn sàng: chưa chấm lại theo trọng số (cần `/ke-hoach`). Bằng chứng: phần lớn P0 ở bậc Xong mã; chưa hạng mục nào Chạy thử trên .60.

## Rà soát 13/11 (lượt 3) — `ra-soat/2026-11-13-tai.md`

- 47 task cần rà: **37 Đạt, 10 Cần sửa** (015, 024, 038, 052, 100, 120, 125, 131, 133, 137); 6 chờ sửa (042, 044, 051, 063, 134, 136).
- Sheet: `sheet_lead.mjs ghi` 47/47, đọc lại khớp 47/47 (`evidence/2026-11-13-tai/ghi-sheet.json`); M6-045 ghi lại Đạt sau D-m6-014, đọc lại khớp.
- Test Lead chạy lại ở `2f733b21` (container): pytest 3413 passed + 2 ca `test_pepper_check_tools` chỉ đỏ khi thiếu lịch sử git (đủ lịch sử 3/3);
  CI_LOCAL 9/10 vì 2 ca đó; smoke 318; docs 0 lỗi; trace khớp; quét bí mật đạt; BLOCKED/OFF/OFF. `test_worker` 5/5 lượt xanh.
  Web: typecheck, lint, build đạt, vitest 401/401, fixtures-m6 khớp contract.
- Tin nháp (chưa gửi, gộp cả quyết định 05/11): `ra-soat/2026-11-13-tai-tin-nhan-nhap.md`, kèm `ra-soat/2026-11-05-m6-114-de-xuat.md`.
  Tin 05/11 (`2026-11-05-tai-tin-nhan-gop.md`) và 09/11 (`2026-11-09-tai-tin-ui-quan-tri.md`) chưa ghi nhận đã gửi; DL theo D-m6-007/009/010/011 chưa vào sổ M6.

## Việc chặn

| Việc | Chặn gì | Ai gỡ | Hạn |
|---|---|---|---|
| Tag `m6-l1-done` ở `d7fe04e` (M6-024) | `deploy.py:111-112` dừng mã 11 → không dựng được .60 | Tài | ngay |
| DL-O09 đăng nhập admin (auth chỉ NONE/FAKE) | Mọi `/api/admin/ads/*` 401 ngoài dev; 8 màn UI, nhập chi phí M9, M6-154 | Tài + Anh Tuấn | quá hạn 06/11 |
| Route `/api/admin/ads/` trên proxy .60 | UI cùng origin không tới m6-api (`127.0.0.1:6600`) | Tài khai (M6-100) → Anh Tuấn | trước staging |
| Compose (TRK-89, TRK-81), docker build chưa chạy | Staging .60 | Tài | trước Go/No-go |
| Smoke thiếu ADS-P0-016 (`smoke_report.py:88`) | Smoke Go/No-go luôn thoát 1 | Tài | trước Go/No-go |
| Chưa producer DQ; DL-O28 mở | KPI HOLD hết; recall mở UNVERIFIED mọi SKU | Tài | trước chạy thật |

## Cần bạn quyết

Không có câu mở. m6.12 đã chốt (D-m6-014, 09:38): bạn xác nhận nguyên DL-083; Tài ghi người chốt Toàn vào DL-083.

## Đề xuất tiếp

1. Bạn gửi Tài tin `ra-soat/2026-11-13-tai-tin-nhan-nhap.md` (kèm tệp M6-114), thay hai tin cũ chưa gửi.
2. Lượt rà kế khi Tài gắn tag và cập nhật các task Cần sửa; `/ke-hoach` chấm lại trọng số.

Không có WP code/agent đang chạy. Worktree `C:\Projects\_wt\m6\review-1311` đã xoá; container test đã dọn. Không sửa/commit repo Tài.
