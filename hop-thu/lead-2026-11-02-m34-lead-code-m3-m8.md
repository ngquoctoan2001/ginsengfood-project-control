# m34 → lead · Lead code phần kết nối M3 → M8 (D-m34-003, 02/11 09:44)

Phiên `m34` báo để phiên `lead` sửa phần thuộc quyền mình:

1. `CLAUDE.md` §2 dòng `m34`: cột "Lead dùng phiên để" thêm "code phần kết nối đơn hàng M3 → M8 (nhánh `toandeptrai`)".
   §4 câu "Phiên `m34`… mặc định chỉ đọc repo của Phúc/Tài" vẫn đúng với việc của Phúc/Tài; phần M3 → M8 là của Lead.
2. Tracker: `547dd59a0` trên `toandeptrai` (business-platform) sửa `team.json` (moduleCoOwners M3 thêm "Nguyễn Quốc Toàn — kết nối M8")
   và `sheet-sync.mjs`. Khi nhánh vào `dev`, chạy lại `install.mjs` ở các repo module khác để đồng bộ `team.json`/dòng Modules.
   `Code.gs` 1.3.1 cần dán vào Apps Script + chạy "Khởi tạo / cập nhật cấu trúc" (Lead làm tay, một lần).
3. Hợp đồng M3 → M8 (đẩy đơn sang gọi xác nhận, nhận kết quả về) nằm ở `ginsengfood-contracts` (phiên `lead`); phía M8 ở `ginsengfood-ivr`
   (phiên `m8`). Phiên `m34` sẽ thả yêu cầu cụ thể khi khảo sát xong.

## Thêm 02/11 09:59 — D-m34-004: trên máy này chỉ làm trên `toandeptrai`

Lead: "trên máy này (kể cả claude hay codex) chúng ta sẽ làm việc trên nhánh toandeptrai trên repo bp".

4. Mọi việc ghi vào business-platform trên máy Lead (Claude, Codex, mọi phiên Project Control) chỉ trên nhánh `toandeptrai`;
   không tạo nhánh mới; worktree tách rời để rà/test thì được. Phiên `m34` đã ghi luật vào `CLAUDE.local.md` (gốc repo, loại khỏi git
   qua `.git/info/exclude`) và `~/.codex/AGENTS.md` (trước đó rỗng). Đề nghị thêm vào `CLAUDE.md` §2/§4 cho mọi phiên.
5. **Đụng việc của phiên `lead`:** worktree `C:/Projects/_wt/lead/bp-task-tracker-1.4` đang ở nhánh `lead/task-tracker-1.4.0`
   (từ `f29bf2667`), `Code.gs` sửa dở. Theo D-m34-004 phần này phải về `toandeptrai`. `toandeptrai` đã có `547dd59a0` sửa `Code.gs`
   (VERSION 1.3.1, MODULES M3 thêm dòng Nguyễn Quốc Toàn, dòng hướng dẫn 1), `team.json`, `sheet-sync.mjs` → gộp 1.4.0 lên trên
   commit đó, giữ dòng M3 mới. Apps Script chỉ dán một lần bản cuối (1.4.0 đã gồm 1.3.1) cho đỡ hai lần.
