---
description: Báo cáo tuần của luồng theo quy trình 3 bước của Lead - luồng Lead code tự báo cáo (prompt 1), luồng Phúc/Tài rà file họ gửi (prompt 2) song song
argument-hint: [kỳ yyyy-mm-dd_yyyy-mm-dd]
---

Kỳ: `$ARGUMENTS`, trống thì thứ Hai đến thứ Bảy của tuần chứa hôm nay (chạy `date`; Chủ Nhật thì lấy tuần vừa xong).
Thư mục tuần: `C:\Projects\bao-cao-tuan\<từ>_<đến>\` (tạo nếu chưa có). Quy trình và lịch: `chung/VAN_BAO_CAO.md`.
Trong lệnh này `<mã BC>` = **mã báo cáo** tra ở `chung/VAN_BAO_CAO.md` (ví dụ `M12-van-hanh-nha-may`), khác mã luồng (`m12`).

**Luồng Lead tự code (`m12`, `m7`, `m8`, và phần M3 của Lead trong `m34`) — bước 1, tự báo cáo:**
1. Đọc `<repo>\tools\task-tracker\bao-cao-tuan\prompt-1-Lead-<mã BC>.md` và hướng dẫn chung `prompt-1-bao-cao-module.md` cùng thư mục.
2. Làm đúng theo đó (repo đích là thư mục gốc). Phần gom bằng chứng giao 2–3 `scout` song song: (a) git trong kỳ, đọc tệp đổi
   từng commit (luôn loại `sheet.json`, `.env*` khỏi diff); (b) Sheet + nhật ký + `modules/<mã luồng>/nhat-ky/` + phiếu `wp/` tuần này;
   (c) mã nguồn hiện tại để chấm bậc từng hạng mục. Phiên chính viết báo cáo, lưu vào thư mục tuần; phần "đưa việc lên Sheet"
   của prompt do phiên chính chạy.
3. Lấy hạng mục, trọng số, WP từ `SAN_SANG.md` để báo cáo khớp kế hoạch phiên.
4. Không tự rà báo cáo vừa viết: phiên `lead` rà ở bước kiểm chéo của `/tong-hop-tuan` và dùng số đã đối chiếu khi tổng hợp.
   Không có vòng trả lại (D-lead-005): báo cáo nộp xong là xong, chỉ sửa khi Lead tự yêu cầu.

**Phiên `m34` — M3 có ba người (D-lead-024):** cùng một lượt làm hai việc song song: (i) bước 1 cho báo cáo `M3-ket-noi-trien-khai`
của Toàn theo khối trên; phạm vi chỉ các task tab M3 trên Sheet có người phụ trách là Nguyễn Quốc Toàn (`sheet-sync.mjs list --module M3`
rồi lọc theo người) và commit của Toàn trên `toandeptrai` cùng lượt gộp vào `dev`; mỗi task đó ghi trạng thái, bằng chứng, việc còn lại;
(ii) bước 2 rà 3 báo cáo của Phúc/Tài bên dưới. Phần của Phúc (giao diện + backend bán hàng) và Tài (vận chuyển, thanh toán) không
tính vào báo cáo của Toàn và ngược lại; commit chung thư mục thì chia theo người và mã task.

**Luồng Phúc/Tài làm (`m34`, `m5`, `m6`) — bước 2, Lead rà file họ gửi:**
1. Tìm báo cáo bước 1 của người làm, theo thứ tự:
   (a) file họ gửi Lead: `C:\Projects\bao-cao-tuan\<kỳ>\bao-cao-tuan-<kỳ>-<mã BC>.md`;
   (b) chưa có → bản họ commit: fetch, `git log --all --format="%h %D" -- docs/weekly-tracking/bao-cao/` để tìm nhánh, đọc bằng
   `git show origin/<nhánh>:docs/weekly-tracking/bao-cao/<tệp>` (không checkout), chép vào thư mục tuần, ghi "lấy từ repo, chưa nhận
   file gửi"; cả (a) và (b) đều có mà khác nhau → rà bản gửi, ghi chỗ khác vào bản rà soát;
   (c) không có → báo Lead một dòng (không soạn tin nhắc), vẫn chạy `/ra-soat` để có số liệu.
2. Mỗi báo cáo một `auditor` chạy nền trong **một** message (`m34` có 3: `M3-ban-hang`, `M3-van-chuyen-thanh-toan`, `M4-tu-van-ai`).
   Brief: đọc và làm đúng `<repo>\tools\task-tracker\bao-cao-tuan\prompt-2-lead-ra-soat.md` với khung THÔNG TIN điền sẵn
   (đường dẫn báo cáo trong thư mục tuần, báo cáo kỳ trước, người + git, kỳ); dùng kèm bản `/ra-soat` gần nhất trong
   `modules/<mã luồng>/ra-soat/`. Prompt 2 bảo agent tự lưu tệp → bỏ qua: auditor trả nội dung, phiên chính ghi
   `…-<mã BC>-ra-soat.md` vào thư mục tuần. Bỏ phần kết luận ĐẠT/TRẢ LẠI và tin nhắn sửa của prompt 2: bản rà chỉ ghi số
   khớp/lệch với git và ý nhận xét để Lead dùng khi tổng hợp (D-lead-005).
3. Không trả lại, không soạn tin cho người nộp. Người đó tự gửi bản mới thì chạy lại lệnh này cho đúng báo cáo, ghi đè bản rà.

**Cuối cùng:** cập nhật `TRANG_THAI.md`, nhật ký. Trả Lead: đường dẫn tệp, màu, số chỗ lệch với git, mục cần Lead đọc lại.
