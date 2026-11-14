---
description: Chạy một sóng gói việc song song - subagent coder cho từng WP, subagent verifier kiểm độc lập, rồi ghép theo luật repo
argument-hint: [mã WP ...]  (trống = sóng vừa đề xuất)
---

Gói việc: `$ARGUMENTS` (trống = sóng trong bảng đầu phiên gần nhất mà Lead đã duyệt).

1. **Chọn và kiểm sóng** (`chung/CACH_LAM.md` §3): phụ thuộc xong; phạm vi ghi tách nhau; mỗi tệp nóng chỉ một WP; ≤ 3 WP code;
   tổng agent nặng chạy cùng lúc ≤ 3 (§5). Không đủ điều kiện → nói lý do, đề xuất sóng sửa lại, dừng.
   Phiên `m34`/`m5`/`m6` chỉ chạy sóng code khi Lead đã lệnh rõ.
2. **Chuẩn bị** (phiên chính tự làm, tuần tự) theo mục "Chạy song song" của `PHIEN.md` và `CACH_LAM.md` §3:
   - W: `git fetch`; mỗi WP `git -C <repo> worktree add C:/Projects/_wt/<mã>/<WP> -b <nhánh theo luật repo> <base mới nhất>`;
     bước chuẩn bị riêng (junction `node_modules`, restore…).
   - S: kiểm vùng sẽ sửa sạch; ghi danh sách tệp/thư mục mỗi WP được ghi; dặn thư mục build riêng mỗi agent.
   - A: tạo `C:/Projects/_wt/<mã>/<WP>`, `git -C <repo> archive HEAD | tar -x -C <đó>`, rồi tạo repo tạm có commit `goc`
     trong bản sao (lệnh ở §3); ghi SHA gốc vào phiếu.
3. **Phiếu gói việc:** mỗi WP một tệp `modules/<mã>/wp/<WP>.md` theo `chung/MAU.md` §1 (brief đủ 8 mục, lấy mục tiêu, tiêu chí,
   phạm vi từ `SAN_SANG.md`). Phiếu đã có (WP làm tiếp) → cập nhật, không tạo tệp mới. WP chưa có id Sheet → tạo (§8).
4. **Giao:** MỘT message, mỗi WP một Agent `coder`, `run_in_background: true`; prompt = nội dung phần Brief của phiếu (subagent
   không cần tự đọc phiếu). Đánh dấu WP `ĐANG LÀM` trong phiếu và `SAN_SANG.md`. Mỗi kết quả coder/verifier về → thêm một dòng
   "Diễn biến" vào phiếu ngay, để phiên hỏng giữa chừng vẫn làm tiếp được.
   Ghi Sheet ngay từng WP `sheet-sync log --id <id> --status IN_PROGRESS` (D-lead-032, `CACH_LAM.md` §8).
   Báo Lead một dòng: sóng đã chạy gồm gì, dự kiến bao lâu.
5. **Khi từng coder xong** (không chờ cả sóng), chuẩn bị chỗ kiểm rồi giao:
   - W: verifier làm ngay trong worktree của WP. A: trong bản sao của WP.
   - S: phiên chính commit WP theo đường dẫn (chưa push), tạo `git -C <repo> worktree add --detach C:/Projects/_wt/<mã>/kiem-<WP> <SHA>`;
     verifier/tester chỉ làm ở đó, **không** trên checkout chung.
   - R1: `verifier` (có thể đặt `model: sonnet`). R2: `verifier`. R3: một `coder` vai tester độc lập viết bộ test từ tiêu chí
     (cùng chỗ kiểm) → rồi `verifier`. Coder và verifier chỉ chạy lệnh kiểm nhanh của WP (tầng 1–2, `CACH_LAM.md` §4).
   - Verifier ĐẠT và WP đã commit/ghép → ghi Sheet **ngay**, không đợi cuối sóng: `log --id <id> --status DONE --commit <SHA>
     --evidence "…"` (R3: `--status REVIEW`) (D-lead-032).
   - `CẦN SỬA` → giao lại `coder` vòng 2 kèm danh sách lỗi (S: sửa trên checkout chung, commit thêm, kiểm lại ở SHA mới);
     vẫn chưa đạt sau vòng 2 → dừng WP, báo Lead.
6. **Ghép, rồi chạy bộ kiểm đủ một lần cho cả sóng** (tầng 3, `CACH_LAM.md` §4, D-lead-030), theo luật repo (`PHIEN.md`):
   - W: khi mọi WP ĐẠT tầng 2, kiểm từng nhánh ghép sạch lên base mới (`git merge-tree`); worktree kiểm tách rời ở base,
     `git merge --no-edit` lần lượt các nhánh WP (chỉ trong worktree kiểm, không đẩy), chạy bộ đủ một lần. Push, PR, merge chỉ
     khi luật repo + Lead cho phép trong phiên này (máy sẽ hỏi bạn trước mỗi lệnh push/merge).
   - S: đã commit ở bước 5; test của tester độc lập (R3) đạt → chép về, commit theo đường dẫn. Worktree kiểm tách rời ở commit
     cuối của sóng, chạy bộ đủ một lần.
   - A: `git -C <bản sao> diff --binary HEAD > C:/Projects/_wt/<mã>/<WP>.patch` → `git -C <repo> apply --3way <patch>`
     (hoặc cách `GIT_INDEX_FILE` trong `PHIEN.md`); không chép đè nguyên tệp; commit theo đường dẫn; áp hết patch của sóng
     rồi chạy bộ đủ một lần trên checkout chính.
   - Bộ đủ chạy nền, chờ thông báo, không thăm dò. Xanh → ghi SHA + số vào phiếu mọi WP; task của Lead R1/R2 ghi luôn
     `node "C:\Projects\Project Control\tools\sheet_lead.mjs" ghi <ket-qua.json>` verdict Đạt (D-lead-032). Đỏ → WP bị quy lỗi ghi
     Sheet `--status IN_PROGRESS`; quy test hỏng về WP (chưa rõ thì
     chạy riêng test hỏng trên từng commit WP), giao lại đúng coder; sửa xong chạy test đã hỏng + tầng 2 của WP đó, rồi bộ đủ thêm một lần.
   - R3: dừng trước khi gộp/push, gửi Lead diff tóm tắt + kết luận verifier, chờ "ok gộp".
7. **Giữ sổ:** phiếu (trạng thái, diễn biến, commit), `SAN_SANG.md` (bảng WP, bậc hạng mục mới + bằng chứng), `TRANG_THAI.md`,
   nhật ký; tracker: soát lại mọi WP của sóng đã ghi Sheet đúng trạng thái ở bước 4–6 (`--id` lấy từ phiếu), không để dồn tới đây. Việc repo bắt "mọi agent" làm
   (`dotnet build-server shutdown`, seed, sinh tệp chung) → phiên chính làm một lần cuối sóng.
8. **Báo Lead (≤ 20 dòng):** bảng WP · kết quả · commit/nhánh/PR · bằng chứng; việc bạn cần làm (push, duyệt R3, quyết);
   đề xuất sóng kế. Dọn worktree kiểm / worktree / bản sao của WP đã ghép xong (hỏi trước nếu còn thay đổi chưa ghép).
   Rồi dọn máy: `pwsh -NoProfile -File "C:\Projects\Project Control\tools\don_may.ps1" -Dung` (D-lead-031); tiến trình của phiên khác
   bị dừng thì nhắn phiên đó một dòng.
