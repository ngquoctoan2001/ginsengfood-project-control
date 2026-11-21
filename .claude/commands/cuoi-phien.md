---
description: Chốt phiên - cập nhật trạng thái, sẵn sàng, nhật ký, tracker theo luật repo; liệt kê việc dở
---

1. Agent còn chạy? Còn → liệt kê, hỏi Lead đợi hay dừng. Tác vụ nền của phiên (server dev, test nền, `tail -f`, vòng chờ)
   không còn cần → tắt; rồi chạy `pwsh -NoProfile -File "C:\Projects\Project Control\tools\don_may.ps1" -Dung` (D-lead-031).
2. Repo: khoá tệp còn giữ (`tools/khoa_tep.py xem`), tệp dirty do phiên này, commit chưa push, nhánh chưa ghép — liệt kê, không tự dọn.
   Phiếu `wp/` của WP còn dở: trạng thái + "Bước kế tiếp chính xác" phải đúng, để phiên mai làm tiếp được.
3. Đọc dòng mới trong `QUYET_DINH.md` của luồng (phiên `lead` có thể đã thêm trong ngày) và áp vào sổ trước khi ghi đè.
4. Chạy `date`. Ghi đè `TRANG_THAI.md` (≤ 60 dòng): mốc dữ liệu (giờ từ `date` + SHA đầu các nhánh chính) · % sẵn sàng ·
   WP theo trạng thái · việc chặn · cần Lead quyết (đánh số `<mã>.<n>`) · việc chờ người khác · đề xuất cho phiên sau.
5. `SAN_SANG.md`: bậc hạng mục + bằng chứng mới, bảng WP theo phiếu.
6. `modules/<mã>/nhat-ky/<yyyy-mm-dd>.md`: 3–8 dòng: đã làm gì, quyết định, bài học đáng nhớ.
7. Tracker: repo bắt ghi `sheet-sync` mà phiên đã chạm repo và chưa ghi → phiên chính ghi một lần theo luật repo.
8. Lưu mốc git: `python "C:\Projects\Project Control\tools\git_tong_quan.py" <mã> --luu`.
9. Trả Lead ≤ 10 dòng.
