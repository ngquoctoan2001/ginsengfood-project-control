---
description: Pull an toàn, rà task Hoàn thành/Chờ review chưa Đạt, chấm Đạt hoặc Cần sửa, ghi Sheet bằng code (Lead W/X/J, người khác W/X), soạn tin nhắn nháp
argument-hint: [phuc|tai-m3|tai-m4|tai|all|lien-module|bao-cao] [từ ngày dd/mm]
---

Dùng trong mọi phiên module (`m12`, `m34`, `m5`, `m6`, `m7`, `m8`, `m9`) hoặc `lead`. Đối số: `$ARGUMENTS`.
Luật trong tệp này thắng mọi câu tóm tắt cũ về rà soát trong `PHIEN.md` của luồng (D-lead-020).
Phiên chính đồng bộ checkout bằng fast-forward trước khi rà; phần rà không sửa mã hoặc commit vào repo của người được rà.
Chỉ kiểm trong worktree/bản sao tách biệt theo luật repo, không dùng DB chung. Không tự push, tạo merge commit, rebase,
deploy, đổi cờ production hoặc gửi tin. Phiên chính pull và ghi Sheet; subagent chỉ giao bằng chứng.

## Đồng bộ nguồn — bắt buộc trước mọi lượt `/ra-soat`

Áp dụng cả rà người/module, `bao-cao` và `lien-module`, cho từng repo code và repo tài liệu thực sự dùng làm nguồn.
Phiên chính thực hiện một lần mỗi repo trước khi giao auditor; đây là phần đã được Lead giao, không hỏi lại quyền pull an toàn.

1. Đọc luật repo, kiểm `git branch --show-current`, `git status --porcelain=v1 --untracked-files=all`, upstream và SHA HEAD.
   Chỉ pull checkout sạch, đúng nhánh được phép, có upstream đã xác minh; không có merge/rebase dang dở hoặc phiên đang sửa/test
   trên checkout đó. `ginsengfood-business-platform` bắt buộc `toandeptrai` theo dõi `origin/toandeptrai`; khác nhánh thì dừng hỏi Lead
   theo D-m34-004, không tự checkout, tạo nhánh hoặc đổi upstream.
2. Với repo đủ điều kiện, chạy `git -C <repo> pull --ff-only --no-rebase` theo upstream hiện tại ở mỗi lượt, kể cả khi lần fetch
   trước báo đã đồng bộ. Không dùng pull thường, không stash/reset/clean, không tạo merge commit, không tự xử lý xung đột.
3. Dirty, thiếu upstream, lịch sử phân kỳ, đang có phiên dùng checkout hoặc pull lỗi: dừng cập nhật checkout đó, ghi lý do và báo Lead.
   Nếu luật repo cho phép, fetch rồi rà SHA remote đã xác minh trong detached worktree; ghi rõ `CHƯA PULL`, không báo đã đồng bộ.
   Fetch lỗi thì ghi nguồn chưa làm mới; không lấy dữ liệu cũ làm kết luận cho bản mới.
4. Ghi repo/nhánh/upstream, giờ chạy, kết quả pull, SHA trước/sau và SHA upstream; kiểm lại trạng thái checkout và ahead/behind.
   Local đi trước remote phải ghi rõ commit chưa push; không coi pull thành công là HEAD đã bằng remote. Ghim SHA thực sự được rà
   theo task/PR/nhánh đích hoặc mốc Lead chỉ định; không mặc định lấy nhánh vừa pull làm ứng viên cho mọi task (nhất là M3/M4).
   Chỉ đọc nội dung theo SHA đã chốt. Không đọc hoặc in `.env*`, `sheet.json` hay bí mật trong log đồng bộ.

## Rà người hoặc module — mặc định

1. **Chốt phạm vi bằng code:** theo người/module trong đối số hoặc `PHIEN.md` (`m34`: `phuc`, `tai-m3`, `tai-m4`), chạy
   `node "C:\Projects\Project Control\tools\sheet_lead.mjs" can-ra --module <M3|M5…> [--owner <tên>] --json modules/<mã>/ra-soat/evidence/<ngày>-<đối tượng>/can-ra.json`.
   Tập rà = nhóm **cần rà**: task `Hoàn thành`/`Chờ review` mà `Lead duyệt` chưa là `Đạt` (gồm task cũ và tài liệu).
   - Task đã `Đạt`: **không rà lại**, không đưa vào tập, trừ khi Lead chỉ đích danh.
   - Task `Cần sửa` mà người làm chưa cập nhật sau lượt rà gần nhất: nhóm **chờ sửa**, không rà lại, chỉ nhắc trong tin nhắn.
   Ngày trong đối số chỉ giới hạn phần lịch sử cần đối chiếu. Giờ đọc (`readAt`) là `reviewedAt` khi ghi ở bước 5.
2. **Chốt nguồn bất biến sau bước đồng bộ:** ghi chính xác SHA base/head/merge, kết quả pull từng repo và thời điểm đọc PR/CI.
   Giao auditor đúng SHA đã chốt; không để auditor tự pull hay đổi checkout. Không đọc `.env*`, `sheet.json` hoặc bí mật.
3. **Giao song song theo danh sách ID:** chia đủ tập task cho các auditor; mỗi ID có một người chịu trách nhiệm, có thể thêm
   auditor liên ngành. Brief ghi ID cụ thể, tiêu chí Sheet/sprint/DoD, quyết định owner, SHA, đường dẫn bằng chứng và quyền chạy test.
   Mỗi task phải đối chiếu code/tài liệu thật, PR/merge, từng tiêu chí, test và giới hạn; báo cáo tự khai không thay kiểm độc lập.
   Tách test local, CI đúng SHA, stub, staging và production; SKIP/NOT_RUN không phải PASS. Không ép task tài liệu thành task code.
   **Auditor chỉ chấm một trong hai: `ĐẠT` hoặc `CẦN SỬA`.** Không có kết luận thứ ba. Thiếu bằng chứng, chưa chạy được test,
   chờ người khác duyệt, mới được phép bắt đầu/cài công cụ → `CẦN SỬA`, ghi đúng việc người làm phải làm để thành Đạt.
   Chỉ chấm `ĐẠT` khi đủ mọi tiêu chí trong phạm vi task trên đúng SHA; không suy từ DONE, PR đã gộp hoặc test tự khai.
4. **Ghép bảng một-một:** mỗi task một dòng: ID/trạng thái, tiêu chí, code + SHA/file:dòng, PR, test đã kiểm, kết luận (Đạt/Cần sửa)
   và việc phải làm. So tập ID với `can-ra.json`: không thiếu, thừa hay lặp. Bản chính `modules/<mã>/ra-soat/<yyyy-mm-dd>-<đối tượng>.md`
   ≤ 80 dòng; bảng dài và evidence ở phụ lục có link, không cắt task. SHA đổi giữa chừng thì kiểm phần thay đổi, không chuyển kết quả SHA cũ sang mới.
5. **Ghi Sheet bằng code — bắt buộc, ngay trong lượt (D-lead-020, thay phần ghi tay/trình duyệt):**
   viết `modules/<mã>/ra-soat/evidence/<ngày>-<đối tượng>/ket-qua.json`, mỗi task đã rà một mục
   `{ "id", "verdict": "Đạt" | "Cần sửa", "sha", "note", "reviewedAt": "<readAt ở bước 1>" }`, rồi chạy
   `node "C:\Projects\Project Control\tools\sheet_lead.mjs" ghi <ket-qua.json> --dry-run` và `… ghi <ket-qua.json>`.
   Công cụ tự xác định người phụ trách theo cột `Người phụ trách` (chỉ "Nguyễn Quốc Toàn" một mình mới là task của Lead):
   - **Task của Lead:** ghi W, nối X, đổi J: Đạt → `Hoàn thành`, Cần sửa → `Đang làm` (thêm `"status": "Bị chặn"` nếu bị chặn);
     H tự tính theo J (`Đã xong` / `Đang chạy`).
   - **Task Phúc/Tài/người khác:** chỉ W/X; mọi cột khác giữ nguyên.
   `note` ≤ 600 ký tự, tiếng Việt: Đạt thì nêu bằng chứng chính; Cần sửa thì liệt kê việc phải làm. X giữ ghi chú cũ, nối khối
   `[Rà soát Lead dd/mm/yyyy HH:mm | SHA …] <kết quả>. <note>`. Công cụ đọc lại Sheet và báo `verified`; lượt rà **chỉ xong khi
   `ok: true` và verified = số task đã rà**. Web app từ chối mục nào (task đổi sau giờ rà, đã Đạt…) thì rà lại phần mới của task đó
   rồi ghi lại; không để task đã rà nằm ở `Chưa duyệt`. Không mở Chrome/trình duyệt, không sửa tay Sheet, không dùng `sheet-sync log`
   lên task của người khác. Kết luận rà task không thay quyền duyệt merge/deploy, nghiệm thu production hoặc mở cờ an toàn.
6. **Soạn tin nhắn nháp:** `modules/<mã>/ra-soat/<yyyy-mm-dd>-<đối tượng>-tin-nhan-nhap.md`, mỗi người phụ trách (Phúc, Tài) một tin:
   task Đạt, task Cần sửa kèm việc phải làm, task chờ sửa còn treo, dẫn ghi chú Sheet. Task của Lead ghi kết quả cho Lead.
   Không tự gửi qua bất kỳ kênh nào; chỉ gửi khi Lead ra lệnh rõ cho đúng người/nội dung.
7. **Chốt sổ và trả Lead:** cập nhật `SAN_SANG.md` theo bằng chứng, `TRANG_THAI.md` theo mốc mới; không tính readiness từ số task DONE.
   Trả ≤ 25 dòng: kết quả pull/SHA; số task Đạt / Cần sửa / chờ sửa; phát hiện chính; số mục `ghi` đã ghi và đọc lại khớp;
   link bảng đầy đủ và tin nhắn nháp. Dọn worktree đã tạo theo luật repo.

## Hai chế độ chuyên biệt giữ nguyên

- `lien-module`: chia điểm nối trong `modules/lead/SAN_SANG.md` thành 3–4 nhóm auditor, đối chiếu hợp đồng và mã hai phía;
  giữ khuôn báo cáo liên module, không tự áp phạm vi task/ghi Sheet/soạn tin mặc định ở trên nếu Lead không giao thêm.
- `bao-cao`: rà sớm báo cáo tuần M12, M7, M8 theo prompt 2, mỗi báo cáo một auditor; ghi `…-<mã BC>-ra-soat.md` vào thư mục tuần.
  `/tong-hop-tuan` dùng lại nếu đã có. Báo cáo tuần chỉ đối chiếu số, không kết luận TRẢ LẠI; không tự thêm tin nhắn hay ghi Sheet.
