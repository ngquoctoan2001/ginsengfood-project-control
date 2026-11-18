---
description: Báo cáo tuần - phiên lead lập báo cáo của Toàn (đối số "toan"; hỏi các phiên + 3 auditor rà commit), phiên m34/m5/m6 rà báo cáo Phúc/Tài gửi (prompt 2)
argument-hint: [toan] [kỳ yyyy-mm-dd_yyyy-mm-dd]
---

Đối số: `$ARGUMENTS`. Kỳ trống thì thứ Hai đến thứ Bảy của tuần chứa hôm nay (chạy `date`; Chủ Nhật thì lấy tuần vừa xong).
Thư mục tuần: `C:\Projects\bao-cao-tuan\<từ>_<đến>\` (tạo nếu chưa có). Quy định, bố cục, văn phong: `chung/VAN_BAO_CAO.md`.

**Phiên `lead`, đối số `toan` — báo cáo tuần của Toàn (D-lead-045):** một tệp `bao-cao-tuan-<từ>_<đến>-Toan.md`, ≤ 200 dòng, cho Chú đọc.
Mẫu: báo cáo kỳ trước cùng tên trong thư mục tuần trước (bản đầu tiên: kỳ `2026-11-09_2026-11-14`).
1. Cùng một message:
   - Tin nhắn phiên (SendMessage) tới các phiên luồng đang mở (`ListAgents`): phiên M1-2, M3-4 (chỉ phần Toàn), M8, M7, phiên hạ tầng máy chủ.
     Khung hỏi ≤ 30 dòng kèm SHA/tệp: đã làm · còn lại tới mốc gần nhất và 30/11 · kế hoạch tuần tới · khó khăn + cách giải quyết ·
     chưa chạy ghi "CHƯA CHẠY". Phiên không mở thì bỏ, phần đó do auditor đọc sổ.
   - 3 `auditor` chạy nền, chỉ đọc, rà commit trong kỳ đối chiếu sổ `modules/<mã>/`: (a) M1–M2 + nối M1–M2 ↔ M3 (ops-core `main`,
     worktree hợp đồng, commit của Toàn trên `toandeptrai` về kho/nhà máy); (b) nối M3 → M8 + M8 (`toandeptrai` phần gọi xác nhận, ivr `main`);
     (c) M7 (golden-hour-video; commit trên .63 chưa push thì ghi "theo sổ"). Mỗi auditor trả ≤ 70 dòng: số commit theo ngày, việc xong theo
     nghiệp vụ + SHA + có test không, việc chưa chạy, mốc và chỗ sổ lệch git, chất lượng + rủi ro khi chạy thật, khó khăn.
     Luật brief: không đọc/in `sheet.json`, `.env*`, khoá, token, số điện thoại; không fetch/pull/đổi nhánh; ivr cấm `worktree add`.
2. Phần máy chủ: phiên `lead` tự gom từ `chung/MAY_CHU.md`, `modules/lead/may-chu/`, nhật ký và tin phiên hạ tầng.
3. Viết theo bố cục ở `chung/VAN_BAO_CAO.md`. Số theo bản auditor; số nghiệm thu đếm lại từ sổ nghiệm thu (dòng cuối mỗi ca).
   Mọi con số chưa đạt (không đạt, bị chặn, chưa chạy, chưa xong) tách bảng nhóm: số lượng · vì sao · cách giải quyết · khi nào.
4. Tự kiểm: số dòng ≤ 200; quét `%`, mã commit (hex 7–40), mã task/quyết định, tên tệp, từ tiếng Anh kỹ thuật; bảng đủ cột.
5. Trả Toàn đường dẫn .md, chờ Toàn đọc và góp ý; sửa đến khi Toàn duyệt. Toàn duyệt → `python tools/md_sang_docx.py <tệp>.md --doc`,
   đếm trang bằng Word (`ComputeStatistics(2)`).
6. Chỗ sổ lệch git: báo phiên luồng tự sửa (không sửa sổ luồng khác). Ghi nhật ký `modules/lead/nhat-ky/<ngày>.md`.

Phiên `m12`, `m7`, `m8` không còn tự viết báo cáo tuần; khi phiên `lead` hỏi thì trả dữ kiện theo khung trên.

**Phiên `m34`, `m5`, `m6` — rà báo cáo Phúc/Tài gửi (prompt 2):** `<mã BC>` tra ở `chung/VAN_BAO_CAO.md` mục "Mã báo cáo Phúc, Tài".
1. Tìm báo cáo của người làm, theo thứ tự:
   (a) file họ gửi Toàn: `C:\Projects\bao-cao-tuan\<kỳ>\bao-cao-tuan-<kỳ>-<mã BC>.md`;
   (b) chưa có → bản họ commit: fetch, `git log --all --format="%h %D" -- docs/weekly-tracking/bao-cao/` để tìm nhánh, đọc bằng
   `git show origin/<nhánh>:docs/weekly-tracking/bao-cao/<tệp>` (không checkout), chép vào thư mục tuần, ghi "lấy từ repo, chưa nhận
   file gửi"; cả (a) và (b) đều có mà khác nhau → rà bản gửi, ghi chỗ khác vào bản rà soát;
   (c) không có → báo Toàn một dòng (không soạn tin nhắc), vẫn chạy `/ra-soat` để có số liệu.
2. Mỗi báo cáo một `auditor` chạy nền trong **một** message (`m34` có 3: `M3-ban-hang`, `M3-van-chuyen-thanh-toan`, `M4-tu-van-ai`).
   Brief: đọc và làm đúng `<repo>\tools\task-tracker\bao-cao-tuan\prompt-2-lead-ra-soat.md` với khung THÔNG TIN điền sẵn
   (đường dẫn báo cáo trong thư mục tuần, báo cáo kỳ trước, người + git, kỳ); dùng kèm bản `/ra-soat` gần nhất trong
   `modules/<mã luồng>/ra-soat/`. Prompt 2 bảo agent tự lưu tệp → bỏ qua: auditor trả nội dung, phiên chính ghi
   `…-<mã BC>-ra-soat.md` vào thư mục tuần. Bỏ phần kết luận ĐẠT/TRẢ LẠI và tin nhắn sửa của prompt 2: bản rà chỉ ghi số
   khớp/lệch với git và ý nhận xét để Toàn dùng khi tổng hợp (D-lead-005).
3. Không trả lại, không soạn tin cho người nộp. Người đó tự gửi bản mới thì chạy lại lệnh này cho đúng báo cáo, ghi đè bản rà.

**Cuối cùng:** cập nhật `TRANG_THAI.md`, nhật ký. Trả Toàn: đường dẫn tệp, màu, số chỗ lệch với git, mục cần đọc lại.
