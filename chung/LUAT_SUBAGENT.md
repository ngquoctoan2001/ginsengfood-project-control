# Luật cho mọi subagent

Phiên điều phối dẫn tệp này trong mọi brief. Brief cho phạm vi; tệp này cho luật chung.

1. **Đúng việc, đúng chỗ.** Chỉ làm gói việc trong brief. Thư mục làm việc là đường dẫn tuyệt đối trong brief
   (dùng `git -C <dir>` hoặc làm trong thư mục đó). Không chạm repo hay thư mục khác.
2. **Luật repo trước.** Đọc `CLAUDE.md`, `AGENTS.md`, `.claude/rules/` (nếu có) của repo đích trước khi sửa.
   Luật repo trái brief → dừng phần đó, ghi `XUNG ĐỘT LUẬT: …`.
   **Ngoại lệ — phiên chính làm thay, không phải xung đột:** luật repo bắt "mọi agent" ghi `sheet-sync`, chạy
   `dotnet build-server shutdown`, chạy migration/seed DB dev, sinh tệp dùng chung (OpenAPI, traceability, `gitnexus analyze`),
   cấp số việc (`NEXT_WORK_ID`, `W-NNNN`) → subagent bỏ qua và ghi "để phiên chính" trong đầu ra.
   Luật repo về hook: hook trong `.claude/settings.json` của repo đích **không** chạy khi phiên mở ở Project Control —
   subagent tự giữ luật đó (không tạo nhánh ở repo cấm nhánh, không `worktree add` ở ivr).
3. **Phạm vi ghi.** Chỉ sửa tệp/thư mục brief cho. Cần sửa ngoài phạm vi → dừng, báo; không tự mở rộng.
   Tệp nóng (migration, tệp đăng ký module, tệp sinh tự động, lockfile, solution) chỉ sửa khi brief nói rõ.
4. **Cấm:** push, merge, mở PR; đổi nhánh của checkout dùng chung; rebase, reset, stash, clean, xoá nhánh;
   cài/đổi dependency (`npm install/ci`, `dotnet add package`, `pip install`, sửa lockfile) trừ khi brief cho;
   chạy migration lên DB dùng chung; gọi đối tác thật, `ssh`/`scp` hoặc chạy script máy thật (.60/.61/.63/.64/.98/.99, `s5v4_host.py`,
   `run_lab.py`); đổi cờ production; chạy `sheet-sync`; `--no-verify`; đổi `core.hooksPath`.
5. **Bí mật.** Không đọc `.env*` (kể cả `.env.example`), khoá, token, `tools/task-tracker/sheet.json` (có token, đã commit ở
   6 repo); không in chuỗi giống bí mật; dữ liệu test giả và ngắn. Mọi `git show`, `git diff`, `git log -p` thêm đuôi
   `-- . ':!**/sheet.json' ':!**/.env*'` để token không lọt vào ngữ cảnh.
6. **Test.** R2/R3: viết test đỏ trước, chạy thấy đỏ, rồi viết mã. Chỉ chạy **lệnh kiểm nhanh** trong brief (build project
   bị đổi + test của WP, có lọc), chạy lại chỉ khi mã đổi; trước khi báo xong chạy lệnh nhanh một lần. **Không** chạy bộ kiểm đủ
   của repo/solution, integration/DB/e2e ngoài ca của WP: phiên chính chạy bộ đủ một lần cuối sóng (`CACH_LAM.md` §4, D-lead-030).
   Ghi số thật (đạt/hỏng/bỏ qua). Không nới assertion, không skip test để xanh.
   Chưa chạy được → ghi `CHƯA CHẠY` + lý do.
7. **Commit.** Chế độ W: commit nhỏ, theo quy ước thông điệp của repo, có mã WP; repo không quy định tác giả thì dùng
   `git -c user.name="claude-subagent/<WP>" -c user.email="noreply@anthropic.com" commit …`.
   Chế độ S và A: **không commit** (A không có `.git`), chỉ liệt kê tệp đã sửa.
8. **Mơ hồ hoặc mâu thuẫn** giữa brief, tài liệu, mã → dừng phần đó, ghi `CẦN QUYẾT: <câu hỏi> · phương án · đề xuất`;
   làm tiếp phần không phụ thuộc.
9. **Để lại sạch.** Tắt tiến trình mình bật trước khi báo xong: server dev (`next dev`, `dotnet run`, vite, uvicorn), watcher,
   `tail -f`/vòng chờ, test chạy nền, container test tự bật (D-lead-031). Không bật tiến trình tách rời (`Start-Process`,
   `nohup … &`, `setsid`) trừ khi brief cho, và khi đó ghi PID vào đầu ra. Đột biến thử phải trả lại; `git status` cuối cùng
   chỉ còn thay đổi thuộc WP. Đầu ra liệt kê tiến trình còn để lại (PID, vì sao) hoặc ghi "không để lại tiến trình".
10. **Đầu ra.** Tin nhắn cuối ≤ 25 dòng:
    `KẾT QUẢ: ĐẠT | CHƯA XONG | CHẶN` · tệp đã đổi · commit SHA · lệnh kiểm + số · việc còn lại · `CẦN QUYẾT` · tệp dễ xung đột.
    Báo cáo dài (nếu brief yêu cầu) ghi vào đường dẫn brief chỉ định.
