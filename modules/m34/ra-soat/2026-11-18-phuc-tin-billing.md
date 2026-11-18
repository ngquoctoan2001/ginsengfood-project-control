# Tin nháp gửi Phúc — 18/11 (m34.131 A, D-m34-107) · CHƯA GỬI

## Tin (Zalo)

Phúc ơi, GitHub Actions repo bán hàng bị khoá vì lỗi thanh toán từ chiều qua, CI với build image đều hông chạy, nên anh chưa đưa bản mới lên .99 cho buổi sếp test được. Em vô phần Billing tài khoản em sửa giùm anh trong sáng nay nha, xong nhắn anh một tiếng.

Thêm hai việc nữa nghen:
- Nhánh gộp của chú Dũng em gộp vô dev sớm giùm anh, đừng để tới 19/11. Dev giờ có migration số lớn hơn của chú rồi, chú chưa vô mà bản dev lên .99 trước là máy chạy thật kẹt, hông gộp tiếp được.
- Sáng nay em đẩy thẳng mấy commit vô dev, hông qua PR. Từ giờ vô dev em đi PR hết nha.

Chi tiết anh để trong file.

## Chi tiết kỹ thuật (gửi kèm)

1. **CI kẹt Billing:** mọi lượt `m34-images` từ 17/11 15:42 (`9c71e37ce`, `5b92e6618`, `103036c8b`, `88d5fe01e`) hỏng ở bước bắt đầu job, 0 bước chạy ("recent account payments have failed or your spending limit needs to be increased"). Image mới nhất trên GHCR: `3627ce4f0`. Sửa xong: chạy lại workflow `m34-images` trên `dev` hoặc đẩy một commit.
2. **Thứ tự migration:** `dev` `a48db1dc0` có V355–V360 rồi nhảy lên **V392–V395** (`V392__special_days_calendar`, `V393__special_days_recurrence`, `V394__iam_role_user_status_change_history`, `V395__iam_creator_status_history_backfill`).
   Nhánh `chudung/m3-14112026-gop-cac-nhanh-sua-ngay-14-11` (`3c6d3ce2e`) có **V361–V391**, chưa vào dev. .99 đang ở V357, Flyway `out-of-order=false`.
   Nếu bản dev hiện tại lên .99 trước khi nhánh chú vào dev → .99 chạy tới V395 → về sau V361–V391 bị Flyway coi là chạy sai thứ tự, be không khởi động. Nên: gộp nhánh chú vào dev TRƯỚC lượt deploy .99 kế tiếp (m34 giữ deploy tới khi có).
3. **Vào dev không qua PR:** 14 commit first-parent của PhucApu trên `dev` 18/11 08:30–09:01 (`aa64b77a2` … `a48db1dc0`), không có "Merge pull request" (D-m34-019). Gồm cả `deploy/m34/env.mau`, `deploy/m34/tests/test_compose.py`, `deploy/m34/ops-core/NOI_M12.md` (ba cờ `OPS_CORE_*_ENABLED`, M3-025) — vùng bộ triển khai của Toàn, báo trước khi sửa.
