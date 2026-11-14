# Từ phiên `m5` · 10/11/2026 13:59 · gộp M6 vào module5 và luật dời Go/No-go (D-m5-025…028)

Lead trả "gửi ghi /quyet và cập nhật lại cách làm việc của chúng ta" cho tin trả lời Tài 10/11 (`modules/m5/ra-soat/2026-11-10-tin-tai.md`).
Phiên `m5` đã ghi D-m5-025…028 và sửa `modules/m5/PHIEN.md`. Phần chỉ phiên `lead` được sửa:

1. **`CLAUDE.md` §2 bảng luồng** (D-m5-025, DL-220 của module5, PR #86 gộp `10097be`): dòng `m6` đổi repo chính thành
   `module5` (thư mục `m6/`); `module6` = lưu trữ, chỉ đọc. Dòng `m5` có thể thêm "UI quản trị chung `web/` với M6".
   Kèm `tools/git_tong_quan.py` (đường dẫn/nhánh m6: từ `module6` `master` sang `module5` `main`) và mọi chỗ trong `chung/` nhắc `module6`.
   Đã kiểm: `master` module6 `e5e8cca` nằm trọn trong `main` module5 `33ec962`; module6 không còn PR mở.
2. **Luật dời Go/No-go** (D-m5-028, m5.25): tới 17:00 11/11 tên miền `mkt.` trên .60 chưa có HTTPS thì Go/No-go **M4/M5/M6** dời sang
   2 ngày làm việc sau khi có HTTPS, chậm nhất 20/11; hạn 30/11 (D-lead-025) giữ. Phiên `m5` chỉ ghi phần M5; phiên `lead` ghi
   cho M4 (luồng `m34`) và M6, rồi báo `m34`, `m6`.
3. **Luật người chốt DL** (D-m5-027, m5.24): PM của Tài được chốt lựa chọn kỹ thuật đã có đề xuất trong docs, ghi nguồn và người uỷ quyền;
   phạm vi pilot, Go/No-go, dữ liệu khách, bảo mật do Tài hoặc Lead chốt. Tài uỷ quyền chung cho M4/M5/M6 (OWN-336), nên phiên `lead`
   cân nhắc đưa vào `chung/CACH_LAM.md` §8 cho mọi luồng Tài (m34 phần Tài, m6).
4. Việc của Lead (không phải phiên): lưu trữ `sasamviet-ai/module6` bằng tài khoản sasamviet-ai (ngquoctoan2001 chỉ có quyền ghi);
   làm với Anh Tuấn HTTPS `mkt.` trong 10/11.

· 13/11 07:55 phiên lead: mục 1 xong (CLAUDE.md §2, git_tong_quan, chung/, quyet.md). Mục 2 (dời Go/No-go M4, M6) và 3 (luật PM chốt DL) chưa làm.
· 13/11 08:08 phiên lead: mục 2, 3 xong (D-lead-033, D-m34-062, D-m6-013, `chung/CACH_LAM.md` §8; tin `hop-thu/m34-2026-11-13-…`, `hop-thu/m6-2026-11-13-…`). Mục 4 là việc của Toàn (lưu trữ module6, HTTPS `mkt.` với Anh Tuấn), không thuộc phiên.
