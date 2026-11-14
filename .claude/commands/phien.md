---
description: Nhận vai một luồng việc và lập bảng đầu phiên - thay đổi, % sẵn sàng, việc chặn, cần Lead quyết, đề xuất sóng việc song song
argument-hint: <m12|m34|m5|m6|m7|m8|lead>
---

Luồng: `$ARGUMENTS`. Trống hoặc không thuộc `m12 m34 m5 m6 m7 m8 lead` → hỏi Lead đúng một câu rồi dừng.

1. **Nhận vai.** Chạy `date`. Đọc `chung/CACH_LAM.md`, `modules/$ARGUMENTS/PHIEN.md`, `modules/$ARGUMENTS/SAN_SANG.md`,
   `modules/$ARGUMENTS/TRANG_THAI.md`. Phiên đã mở từ hôm trước (không phải phiên mới) → đọc lại cả `CLAUDE.md` (phiên `lead`
   có thể đã sửa luật). Từ giờ phiên này là phiên `$ARGUMENTS`: chỉ ghi trong phạm vi luồng (`CLAUDE.md` §3).
   `SAN_SANG.md` còn ghi "BẢN NHÁP" → đề xuất chạy `/ke-hoach` ở mục 5 của bảng.
2. **Gom dữ kiện** theo mục "Kiểm đầu phiên" của `PHIEN.md`:
   - Git luôn chạy trước bằng script (vài giây, không tốn agent), so với mốc SHA đã lưu lần trước:
     `python "C:\Projects\Project Control\tools\git_tong_quan.py" --fetch $ARGUMENTS` (`lead` = mọi repo).
   - Dọn máy cùng lúc (chạy nền, ~20 giây): `pwsh -NoProfile -File "C:\Projects\Project Control\tools\don_may.ps1" -Dung`
     (D-lead-031). Có dừng gì thì ghi một dòng vào bảng; tiến trình của phiên khác bị dừng thì nhắn phiên đó.
   - Nguồn ngoài git (Sheet, CI, sổ của Tài, báo cáo): ít thì tự đọc; nhiều thì giao 2–3 `scout` chạy nền trong **một** message.
   - Phiếu `modules/$ARGUMENTS/wp/*.md` đang `ĐANG LÀM`/`CHỜ KIỂM`/`CẦN SỬA` = việc dở của phiên trước → đưa vào mục 2 của bảng,
     đề xuất làm tiếp theo "Bước kế tiếp" của phiếu (kiểm worktree/bản sao/tệp dirty tương ứng).
   - Dòng mới trong `modules/$ARGUMENTS/QUYET_DINH.md` (phiên `lead` có thể đã thêm) → áp vào sổ trước khi ghi đè.
   - `hop-thu/$ARGUMENTS-*` (phiên `lead`: `hop-thu/lead-*`) có tệp mới không.
3. **Bảng đầu phiên** (≤ 40 dòng):

   **<Luồng> · <ngày giờ từ `date`>** · Sẵn sàng <X>% (bản nháp/đã kiểm) · Mốc kế: <mốc> còn <n> ngày · Kịp 15/11: XANH/VÀNG/ĐỎ

   1. Thay đổi từ lần trước — ≤ 5 dòng, có SHA/PR/người.
   2. Đang chạy hoặc dở — WP, agent, worktree, tệp dirty.
   3. Việc chặn — chặn gì, ai gỡ, cần trước ngày.
   4. Cần bạn quyết — đánh số `<mã>.<n>` (ví dụ `m12.1`; tiếp số trong `TRANG_THAI.md`); mỗi mục: câu hỏi trả lời được ngay
      (có/không, A/B) · đề xuất của phiên · hạn · trễ thì sao.
   5. Đề xuất — bảng: WP · mục tiêu · vì sao bây giờ · rủi ro R1–R3 · chế độ W/S/A. Tối đa 3 WP code + 1 WP tài liệu.
      Phiên `m34`/`m5`/`m6`: đề xuất đợt rà soát và việc cần nhắc người làm. Phiên `lead`: luồng nào mở phiên, chạy lệnh gì.
   6. Trả lời mẫu: ví dụ `ok 1 A, 2 có, chạy đi`.

4. **Ghi sổ:** ghi đè `TRANG_THAI.md` (≤ 60 dòng; mốc dữ liệu = giờ từ `date` + SHA đầu các nhánh chính), thêm một dòng vào
   `modules/$ARGUMENTS/nhat-ky/<yyyy-mm-dd>.md`, lưu mốc git mới:
   `python "C:\Projects\Project Control\tools\git_tong_quan.py" $ARGUMENTS --luu`. Rồi dừng chờ Lead.
