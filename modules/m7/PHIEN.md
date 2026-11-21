# Phiên `m7` — M7 Video Giờ Vàng (Lead tự làm)

## Repo

- **Nguồn chính:** `C:\Projects\ginsengfood-golden-hour-video` (GitHub `ngquoctoan2001/ginsengfood-golden-hour-video`), nhánh `main`.
  Tên module mới: "Golden Hour AI Video Program Orchestrator" — dựng chương trình 70 phút (master đúng 4.200 giây) cho mỗi phiên Giờ Vàng
  M3 mở (DL-001, DL-029 trong `docs/00-overview/DECISION_LOG.md`).
- Đã duyệt docs v2 và thiết kế L0; T001 commit `d82f8fd`. T002 khung solution .NET 10 đã commit `274bfd6` (D-m7-019),
  remote main đã ở mốc này theo kiểm chỉ đọc 02/11 11:26; phiên T003 không push, không suy tác nhân cập nhật remote. Chưa có nghiệp vụ.
  T003 CI: mã commit nguyên trạng `056639b` (D-m7-051), CI vẫn tạm dừng theo D-m7-023, chạy build/test thủ công.
  T004 đã commit `7db0c81`; T005 đã commit `e6f0bf8` theo lệnh Lead ngày 03/11/2026. Candidate sạch 219/219 và 278/278 test đạt.
  Mốc hiện tại 10/11/2026: main `2060a0a`; T025 `8b6fef7`, T013 `dcff00b` (48 tệp), T039 `2060a0a` (64 tệp) đã commit local theo m7.145/D-m7-069; Sheet cả ba DONE, chưa push. Chi tiết xem `TRANG_THAI.md`. Các số Sheet ở đoạn L0 là lịch sử ngày 03/11/2026.
  m7.25 A/DL-094 cho seed bootstrap hẹp; m7.26 A/DL-095 gắn quyết định SETTING_CHANGE với phiên bản kết quả.
  PostgreSQL và bố cục `src/Ginsengfood.M7.*` theo L0 (DL-020).
- **Lưu trữ, chỉ đọc:** `C:\Projects\module7` (MC AI Live Python cũ, đóng băng 17/09; không fork, không chép mã — DL-020, DL-029) và
  `C:\Projects\module7-qa`. **Không đọc `module7\_archive\`** (có bí mật).
- Bộ triển khai chung `C:\Projects\deploy` còn dựng M7 Python cũ — phải thay khi M7 mới có Dockerfile.

## Luật repo phải nhớ (`CLAUDE.md`, `AGENTS.md`; repo không có `.claude/`, chỉ `.codex/rules/`)

- Tài liệu tiếng Việt, không emoji, viết "đề xuất" thay "khuyến nghị".
- **Agent không tự chốt.** Quyết định chỉ ghi ở `docs/00-overview/DECISION_LOG.md`; agent soạn đề xuất và ghi lại quyết định Lead đã nói.
- M7 không chạm giá, tồn, đơn, bình luận hay Meta. AI sinh chữ gọi Claude (Max/Ultra hoặc API key) qua port AI của M7 (DL-030).
  Ngoài phần đó, ngân sách trống → không gọi API trả phí (DL-014); Muse tự động theo DL-035, tài khoản/người giữ còn chờ trước T064.
- Không bao giờ gọi hệ thống là "production-ready". Không chạy gì trên .61/.63 khi Lead chưa cho.
- Commit (D-m7-053): task/WP R1, R2 verifier ĐẠT thì phiên chính commit ngay theo đường dẫn; R3 chờ "ok gộp"; commit ngoài WP và push chờ lệnh Lead;
  không commit `_archive/`.
- Sổ (D-m7-053): mỗi bước chỉ ghi phiếu (Diễn biến) + Sheet; `SAN_SANG.md`, `TRANG_THAI.md`, nhật ký ghi một lần khi xong sóng hoặc khi Lead hỏi.
- Tracker: phiên chính chạy `node tools/task-tracker/sheet-sync.mjs log …` sau mỗi lệnh có chạm repo (subagent không chạy).
- ID Sheet: M7-T001…M7-T175 = M7-(006+n) (T007 = M7-013); M7-T176…M7-T181 = M7-186…M7-191 (tạo 03/11/2026); gói WP06 M7-182, WP14 M7-183,
  WP15 M7-184, WP16 M7-185, WP17 M7-192, WP18 M7-193, WP19 M7-194; M7-T183…T186 = M7-199…202, T188 = M7-203, T189…T192 = M7-207…210 (07/11). T220 = M7-242, T221 = M7-243 (tạo 15/11); T190a = M7-244, T190b = M7-245 (16/11), T190c = M7-246 (17/11). Task, gói mới: `log --module M7 --title …` lấy số kế tiếp, ghi lại ở đây; ở máy Lead ghi Sheet cho commit .63 bằng `upsert` (không ghi tệp tuần trong repo).
- Tracker local: giữ nguyên `tools/task-tracker/sheet.json` (ignore, đã bỏ khỏi git ở `056639b`, D-m7-051; máy khác pull sẽ mất tệp, phải tạo lại từ mẫu);
  mẫu `sheet.example.json` rỗng, hướng dẫn ở `tools/task-tracker/README.md`. Không đọc/chép/in cấu hình thật.
- **D-m7-024: giữ token hiện tại.** Không tiếp tục thu hồi/xử lý finding lịch sử hoặc nhắc lại nếu Lead chưa yêu cầu mới.
  Hướng dẫn thu hồi đã viết chỉ là tham khảo, không phải việc đang chờ Lead làm. Không tự sửa scanner hoặc đánh finding đã được xử lý.
- Sheet là trạng thái công việc, không phải trạng thái agent. Lượt đã bàn giao và không còn worker → ghi Chờ review/chờ bước tiếp phù hợp,
  không để IN_PROGRESS chỉ vì toàn gói chưa xong; IN_PROGRESS tự được Sheet hiển thị “Đang chạy”.
- Mục đánh dấu `GEN:` là tệp sinh: chạy bộ sinh một lần ở phiên chính.

## Lệnh

- Tài liệu: `python docs/_tools/check_docs.py` · `python docs/_tools/gen_traceability.py --check`.
- Khung T002 (theo README): `dotnet tool restore` → `dotnet restore --locked-mode` → `dotnet build -c Release --no-restore`
  → `dotnet test -c Release --no-build` → `dotnet format --verify-no-changes`. Không chạy build đồng thời trên checkout này.
- **Dev hiện tại: CI tạm dừng (D-m7-023 / DL-093).** Dùng các lệnh build/test/format thủ công phía trên; kiểm docs nếu sửa docs.
  D-m7-067 ngày 09/11/2026: m7.112 không được duyệt bật lại; tiếp tục tắt CI. Không tự gọi `run-ci.ps1`, kể cả `-Group test` (nhóm đó còn kéo scanner); không coi CI tạm dừng là PASS. Giữ engine/pins để bật lại khi Lead yêu cầu.
  Workflow bỏ push/schedule, khóa job bằng điều kiện false. GitHub kiểm 02/11 13:37 có 0 workflow; chưa push thay đổi local.
  Finding lịch sử tracker còn mở theo lượt kiểm trước; phần cấu hình đã ĐẠT 17 kiểm độc lập, không đồng nghĩa credential đã thu hồi.

## Chạy song song: chỉ nhánh `main`, sửa thẳng checkout chính (D-m7-013, D-lead-063)

Lead chốt 01/11/2026: M7 chỉ làm trên **một nhánh `main`** — không nhánh tính năng, không worktree `_wt`, không PR. Mọi subagent làm trong
checkout chính (trên .63: `~/dev/ginsengfood-golden-hour-video`), không commit; phiên chính commit theo đường dẫn sau khi coder chạy test lọc và phiên chính đọc diff (kiểm nhẹ D-lead-064, D-m7-148: không verifier từng gói; vùng Nguy hiểm ghi danh sách cổng, verifier một vòng 25–27/11); push khi Lead bảo (bộ đủ đêm xanh thì tự push, D-m7-145).
Task code (.NET, web) chạy **lần lượt**; song song chỉ khi tệp tách hẳn và không cùng build (ví dụ một task tài liệu ‖ một task code).
Nhiều làn code (D-m7-056; D-lead-063 thay cách cũ): các làn cùng sửa checkout chính, mỗi làn khai khoá riêng bằng `tools/khoa_tep.py`, phiên chính commit theo đường dẫn; không clone, không `_wt`. Hai làn không cùng giữ tệp nóng. D-m7-067/m7.117 duyệt kế hoạch Mốc 2 có 4 làn .NET + 1 web + 1 tài liệu, làm cả Chủ nhật; số tác nhân chạy thật phải theo tài nguyên máy và số suất công cụ. Trên máy đang thiếu RAM, giữ tối đa 3 tác nhân nặng tới khi đủ tài nguyên.
Tệp nóng `.sln`, `Directory.Packages.props`, DbContext + migration, `Contracts`, lockfile: một task tại một thời điểm.
Trên .63 (nơi duy nhất sửa mã M7, D-m7-147): khoá tệp bằng `python3 ~/m7-drive/khoa_tep.py` (kho `~/m7-drive/khoa-tep`, chép từ `tools/khoa_tep.py`); bộ kiểm đủ ("CI lâu lâu") chạy trong checkout chính bằng `~/m7-drive/bo-du-tai-cho.sh` dưới `@bo-kiem-du`, do `kiem-dem.sh` gọi mỗi đêm 01:30, không bắt phiên dừng sửa; đỏ ghi `~/m7-drive/bo-du-moi-nhat.txt`, sửa trong ngày (D-m7-148); `vong-lap.sh` nối lượt.

## Tài nguyên máy (D-m7-079, 13/11/2026)

Mọi brief coder, verifier dẫn `modules/m7/tools/LUAT_TAI_NGUYEN.md`: lệnh nặng (`dotnet build`, `dotnet test`, vitest, đột biến, công cụ thật) đi qua `tools/m7-heavy.ps1`, tối đa 2 lệnh nặng cùng lúc trong cả M7, ưu tiên BelowNormal, đợi khi TIME_WAIT từ 4000 hoặc RAM trống dưới 3 GB; coder chạy lớp của mình cộng một lô lân cận ≤ 150 ca, đột biến coder ≤ 8, verifier ≤ 20; `--no-incremental` chỉ ở lượt build đầu và cuối; việc ngoài đường găng Mốc 1 xếp sau. Số tác nhân chạy cùng lúc: tối đa 3, trong đó tối đa 2 đang chạy lệnh nặng.

## Cổng mở code (quan trọng)

Cổng code **đã mở 01/11/2026**: Lead duyệt docs v2 (DL-042, DL-052); điều kiện đơn khách thật đầu tiên của DL-011 không còn áp cho M7.
Còn **25 câu hỏi mở** theo `docs/06-tracking/PHIEU_CHOT_CAU_HOI_MO.md` và DECISION_LOG §5.6 ngày 02/11/2026.
L0 đang làm lần lượt T001–T005 (D-m7-016); mỗi task kiểm độc lập → trình diff → Lead bảo commit. T005 đã commit; bước kế tiếp đề xuất tính lại lịch một làn
(DL-051, DL-053, DL-054). Kế hoạch nay có 192 task (thêm T189–T192 ở M7-WP24) — xem `SAN_SANG.md`.
**Đích (D-m7-063, 07/11/2026, thay D-m7-020/D-m7-030, DL-092/DL-096):** 15/11 luồng video ngắn chạy bằng bộ máy thật + một video thật khoảng 95 giây nhiều clip AI;
30/11 chương trình 70 phút và mọi phần còn lại (xu hướng, phát, nối thật, .60, nghiệm thu). Bật chạy thật: Lead quyết riêng. Không còn mốc GĐ3/GĐ4 01/2027.

## Kiểm đầu phiên

- `git status`, `log -5`, đối chiếu mốc git; kiểm WP dở và Sheet M7-006, phân biệt bằng chứng phiên trước với kiểm vừa chạy.
- Số câu hỏi mở còn lại trong `docs/06-tracking/PHIEU_CHOT_CAU_HOI_MO.md`; DECISION_LOG 10 dòng cuối; `docs/06-tracking/TRACKING_REPORT.md`.
- Dọn .61 đã hoãn theo D-m7-012: dev local trước, cần xử lý trước T103. Từ 13/11 (D-lead-034/035/036) .61 là đường lui của M1–M2 và M8: chỉ dọn phần M7 cũ, KHÔNG đụng `~/m12`, `~/m8`. Không suy đoán trạng thái container hiện tại khi chưa kiểm. Bảng máy và địa chỉ nội bộ: `chung/MAY_CHU.md` (M7 tạm ở .60 tới khi Anh Tuấn giao máy video; `video.` không đổi).

## Mảng khảo sát cho `/ke-hoach`

1. Mốc 1 (15/11): tập task tối thiểu cho video ngắn thật; Mốc 2 (30/11): 70 phút, phát, nối thật (D-m7-063).
2. 25 câu hỏi còn mở: gom theo thời điểm cần quyết; không mở lại cổng code đã duyệt.
3. Khung L0 (.NET, xác thực, chuỗi audit HMAC, CI, Dockerfile) — ước lượng thật.
4. Phụ thuộc: M3 (mở phiên Giờ Vàng, ảnh chụp sản phẩm), M2 (`POST /v1/availability/check`), M6 (xuất lịch). M7 tự sản xuất video và
   gọi Claude trực tiếp (`CHOT_HUONG.md`).

## Báo cáo tuần

Phiên m7 không tự viết báo cáo tuần (D-m7-090, D-lead-045). Phiên lead hỏi bằng tin nhắn phiên thì trả dữ kiện ≤ 30 dòng kèm SHA, tệp: đã làm · còn lại tới mốc gần nhất và 30/11 · kế hoạch tuần tới · khó khăn và cách giải quyết · ghi `CHƯA CHẠY` cho phần chưa chạy.

## Quyết định phiên 09/11/2026

D-m7-067: 26 đề xuất m7.113–124, m7.127, m7.131–143 đã được Lead duyệt; không hỏi lại các phương án này. Danh sách đầy đủ ở `QUYET_DINH.md`, sổ kỹ thuật DL-294…DL-319 ở `docs/00-overview/DECISION_LOG.md` của repo. CI tiếp tục tắt. Dùng Claude thuê bao và Muse trả phí; đăng nhập/cấp tài khoản, CTA, hồ sơ sản phẩm vẫn là việc cần thực hiện. Việc ghi nhận quyết định chưa làm T013/T025/T039 hoàn tất. T013 phải có kết luận verifier R3 và diff cuối trước bước gộp theo D-m7-053.

D-m7-068/m7.144 A: Lead đã duyệt lưu dấu băm đầy đủ ngữ cảnh, triển khai DL-320 trong T039; không còn chờ lựa chọn này. Kiểm cuối đêm 09–10/11 đã đạt; T013 vẫn cần “ok gộp” m7.145 theo D-m7-053. CI giữ tắt, chưa push.

## Bàn giao sang .63 (14/11/2026, D-m7-083, D-lead-039/040)

- Máy Lead quá tải: M7 (mã và test) chạy trên .63 (`/home/ssv/dev/ginsengfood-golden-hour-video`). Từ sau lần push `9e8ad9f` chỉ phiên M7 chạy trên .63 được sửa mã M7; phiên m7 ở máy Lead giữ sổ `modules/m7/` (TRANG_THAI, SAN_SANG, QUYET_DINH, nhật ký, bằng chứng `ra-soat/`), KHÔNG sửa mã M7, KHÔNG chạy coder/agent M7, KHÔNG push.
- Việc dở: xem `TRANG_THAI.md`. Phiên .63 hiện tại: Claude CLI `9b228a48-18f2-4f89-a565-0d017ccdc4ab` (mở 16/11 20:5x, chế độ quyền `auto`), repo `~/dev/ginsengfood-golden-hour-video`. Từ 17/11 (D-m7-110) phiên m7 máy Lead điều khiển nó qua ssh `ssv@` địa chỉ .63: đọc bản ghi `~/.claude/projects/-home-ssv-dev-ginsengfood-golden-hour-video/<id>.jsonl`; giao lượt bằng tệp lệnh `~/m7-drive/p-NN.txt` rồi `cd` repo và `CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS=0 setsid -f bash -c "claude --resume <id> -p --permission-mode auto --output-format text < p-NN.txt > o-NN.log 2>&1"` (thiếu biến này thì 10 phút sau khi lượt kết thúc, trình chạy dừng mọi agent nền: 17/11 mất 4 coder sóng 1; dặn phiên .63 giữ lượt tới khi xong sóng) (đưa lệnh qua stdin; gửi tệp bằng `scp`, không `cat` qua ssh vì Git Bash làm rỗng tệp); chờ bằng một ssh nền `while kill -0 <pid>`. Mỗi lúc chỉ một tiến trình của phiên đó chạy; Toàn không gõ vào cửa sổ CLI cũ khi đang giao lượt. Kiểm tách rời trên .63 dùng clone `--no-local` ở SHA (D-m7-056), không `git worktree` (luật repo DL-054, D-m7-013; 17/11 máy Lead giao nhầm worktree cho bộ đủ `cf6a954`). `SendMessage` không tới được phiên này (khác chế độ quyền).
- T190 và mọi lượt chạy M7 (cả công cụ thật: VieNeu, faster-whisper, Chrome, Muse) ở .63 (D-m7-084); Toàn đăng nhập Muse lại trên .63 qua màn hình ảo, không chép hồ sơ từ máy Lead. Stack `m7-m7-*` và hồ sơ Muse ở máy Lead không còn dùng.
- Công cụ viết mã ở .63: subagent Claude và `codex exec` (D-m7-088, task ngoài đường găng, cùng luật kiểm độc lập). Ngưỡng ASR 0,90 chỉ máy dev, 0,95 cho Mốc 2 (D-m7-086). Toàn ký nghiệm thu Mốc 1, 2 (D-m7-087).
- Sheet: .63 không có `sheet.json`; phiên máy Lead ghi Sheet cho commit .63 khi nhận SHA.
- 16/11: .63 hỏng, mọi việc cần .63 GÁC tới khi Toàn báo (D-m7-098); không canh, không hỏi lại. Máy chạy thật M7 = máy ảo Ubuntu 22.04 không card Toàn xin 16/11, thay .60; DL-306 sửa khi .63 lên (D-m7-099).
