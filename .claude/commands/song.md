---
description: Chạy một sóng gói việc song song - subagent coder cho từng WP, subagent verifier kiểm độc lập, rồi ghép theo luật repo
argument-hint: [mã WP ...]  (trống = sóng vừa đề xuất)
---

Gói việc: `$ARGUMENTS` (trống = sóng trong bảng đầu phiên gần nhất mà Lead đã duyệt).

1. **Chọn và kiểm sóng** (`chung/CACH_LAM.md` §3): phụ thuộc xong; phạm vi ghi tách nhau; mỗi tệp nóng chỉ một WP; ≤ 3 WP code;
   tổng agent nặng chạy cùng lúc ≤ 3 (§5). Không đủ điều kiện → nói lý do, đề xuất sóng sửa lại, dừng.
   Phiên `m34`/`m5`/`m6` chỉ chạy sóng code khi Lead đã lệnh rõ.
2. **Chuẩn bị** (phiên chính tự làm, tuần tự) theo mục "Chạy song song" của `PHIEN.md` và `CACH_LAM.md` §3 (D-lead-063: sửa thẳng trong
   checkout chính, không worktree, không bản sao):
   - `git fetch`; nhánh luồng trễ nhánh gốc thì gộp dưới khoá `@dong-bo`; ghi SHA nền vào phiếu.
   - Kiểm vùng sẽ sửa sạch (tệp dở của người khác thì làm né, không stash); ghi danh sách tệp/thư mục mỗi WP được ghi.
   - Khai khoá mỗi WP: `python tools/khoa_tep.py khai --repo <repo> --chu <phiên>/<WP> --tep <đường dẫn…>`. Chồng khoá (mã thoát 2) → chọn WP
     khác cho sóng, hoặc nhắn chủ khoá; không giao coder vào tệp đang bị khoá. Dặn thư mục build riêng mỗi agent.
3. **Phiếu gói việc:** mỗi WP một tệp `modules/<mã>/wp/<WP>.md` theo `chung/MAU.md` §1 (brief đủ 8 mục, lấy mục tiêu, tiêu chí,
   phạm vi từ `SAN_SANG.md`). Phiếu đã có (WP làm tiếp) → cập nhật, không tạo tệp mới. WP chưa có id Sheet → tạo (§8).
4. **Giao:** MỘT message, mỗi WP một Agent `coder`, `run_in_background: true`; prompt = nội dung phần Brief của phiếu (subagent
   không cần tự đọc phiếu). Đánh dấu WP `ĐANG LÀM` trong phiếu và `SAN_SANG.md`. Mỗi kết quả coder/verifier về → thêm một dòng
   "Diễn biến" vào phiếu ngay, để phiên hỏng giữa chừng vẫn làm tiếp được.
   Ghi Sheet ngay từng WP `sheet-sync log --id <id> --status IN_PROGRESS` (D-lead-032, `CACH_LAM.md` §8).
   Báo Lead một dòng: sóng đã chạy gồm gì, dự kiến bao lâu.
5. **Khi từng coder xong** (không chờ cả sóng), chuẩn bị chỗ kiểm rồi giao:
   - Phiên chính commit WP theo đường dẫn (`git commit -m "<mã WP> …" -- <đường dẫn>`, chưa push) rồi giải khoá của coder; verifier/tester chấm
     đúng SHA đó (`git show <SHA>`), chỉ chạy lệnh kiểm khi không ai còn sửa tệp của WP (`CACH_LAM.md` §3 mục 4). Đột biến chỉ dưới khoá `@dot-bien`.
   - Mức Thường (D-lead-064): không giao verifier; phiên chính đọc diff đối chiếu tiêu chí rồi commit. Mức Nguy hiểm: gộp vào nhánh làm việc như Thường,
     ghi vào danh sách cổng Nguy hiểm của luồng; verifier chấm một lần ở cổng (`CACH_LAM.md` §4), không từng WP. Coder chỉ chạy lệnh kiểm nhanh của WP (tầng 1).
   - Verifier ĐẠT và WP đã commit/ghép → ghi Sheet **ngay**, không đợi cuối sóng: `log --id <id> --status DONE --commit <SHA>
     --evidence "…"` (R3: `--status REVIEW`) (D-lead-032).
   - `CẦN SỬA` → giao lại `coder` vòng 2 kèm danh sách lỗi (khai lại khoá, sửa trên checkout chính, phiên chính commit thêm, kiểm lại ở SHA mới);
     vẫn chưa đạt sau vòng 2 → dừng WP, báo Lead.
6. **Ghép, rồi chạy bộ kiểm đủ một lần cho cả sóng** (tầng 3, `CACH_LAM.md` §4, D-lead-030), theo luật repo (`PHIEN.md`):
   - Mọi WP đã commit theo đường dẫn ở bước 5. Không chạy bộ đủ ở máy (D-lead-064): CI chạy theo lịch đêm hoặc bấm tay. Lên .99 bằng pipeline rút gọn, chỉ khi Lead nói "deploy"; sau đó bài kiểm nhanh (`CACH_LAM.md` §4). Push, PR, merge chỉ khi luật repo + Lead cho phép trong phiên này.
   - Bộ đủ chạy nền, chờ thông báo, không thăm dò. Xanh → ghi SHA + số vào phiếu mọi WP; task của Lead R1/R2 ghi luôn
     `node "C:\Projects\Project Control\tools\sheet_lead.mjs" ghi <ket-qua.json>` verdict Đạt (D-lead-032). Đỏ → WP bị quy lỗi ghi
     Sheet `--status IN_PROGRESS`; quy test hỏng về WP (chưa rõ thì
     chạy riêng test hỏng trên từng commit WP), giao lại đúng coder; sửa xong chạy test đã hỏng + tầng 2 của WP đó, rồi bộ đủ thêm một lần.
   - R3: dừng trước khi gộp/push, gửi Lead diff tóm tắt + kết luận verifier, chờ "ok gộp".
7. **Giữ sổ:** phiếu (trạng thái, diễn biến, commit), `SAN_SANG.md` (bảng WP, bậc hạng mục mới + bằng chứng), `TRANG_THAI.md`,
   nhật ký; tracker: soát lại mọi WP của sóng đã ghi Sheet đúng trạng thái ở bước 4–6 (`--id` lấy từ phiếu), không để dồn tới đây. Việc repo bắt "mọi agent" làm
   (`dotnet build-server shutdown`, seed, sinh tệp chung) → phiên chính làm một lần cuối sóng.
8. **Báo Lead (≤ 20 dòng):** bảng WP · kết quả · commit/nhánh/PR · bằng chứng; việc bạn cần làm (push, duyệt R3, quyết);
   đề xuất sóng kế. Giải mọi khoá đã khai (`khoa_tep.py giai`); không có thư mục tạm nào cần dọn (D-lead-063).
   Rồi dọn máy: `pwsh -NoProfile -File "C:\Projects\Project Control\tools\don_may.ps1" -Dung` (D-lead-031); tiến trình của phiên khác
   bị dừng thì nhắn phiên đó một dòng.
