# Cách làm: gói việc, sóng song song, kiểm độc lập

## 1. Nhịp ngày

Sáng `/phien` → Lead trả lời ngắn → phiên chạy `/song` hoặc `/ra-soat` → tối `/cuoi-phien`; thứ Bảy `/bao-cao-tuan`, `/tong-hop-tuan`.
Phiên chỉ hỏi Lead bằng câu hỏi đánh số `<mã>.<n>` (ví dụ `m12.2`); trong phiên của luồng, Lead trả "ok 2" = `m12.2`.

## 2. Gói việc (WP)

Một WP = một kết quả nhìn thấy được, nâng một hoặc vài năng lực trong `SAN_SANG.md` lên bậc kế tiếp,
làm trong 0,5–1,5 ngày công AI, ra một nhánh/PR hoặc một bộ commit.

Mỗi WP có phiếu `modules/<mã>/wp/<WP>.md` (`chung/MAU.md` §1): mã (`M8-WP03`) · mục tiêu · tiêu chí đạt (kiểm được bằng lệnh hoặc
kịch bản) · phạm vi ghi · tệp nóng · rủi ro R1–R3 · phụ thuộc · hạn theo mốc A–D · ước lượng · trạng thái · bằng chứng · id Sheet.
**Phiếu là nguồn gốc trạng thái WP**; bảng WP trong `SAN_SANG.md` chép lại cùng lúc, lệch thì theo phiếu.

Không mở WP cho việc dưới 1 giờ: gộp vào WP cùng vùng.
Trạng thái: `CHỜ` · `SẴN SÀNG` · `ĐANG LÀM` · `CHỜ KIỂM` · `ĐẠT` · `CẦN SỬA` · `CHẶN` · `HUỶ`.

## 3. Sóng song song

Sóng = 2–3 WP code (hoặc tới 4 nếu có WP chỉ tài liệu) chạy cùng lúc, chọn sao cho:

- phạm vi ghi không chồng nhau; mỗi tệp nóng (migration, tệp đăng ký module, tệp sinh tự động, solution/lockfile) chỉ một WP chạm;
- phụ thuộc đã xong;
- ưu tiên: đường găng tới mốc gần nhất → việc mở khoá người/module khác → phần còn lại.

**Một chế độ duy nhất: sửa thẳng trong checkout chính của repo (D-lead-063, thay chế độ W/S/A cũ).** Không `git worktree add`, không
`git archive`/clone vào `C:\Projects\_wt`, không ngoại lệ, kể cả ivr, golden-hour-video, ops-core, repo bán hàng. Lead có thể fork nhiều phiên cho một luồng
và mỗi phiên spawn nhiều agent: tất cả cùng một cây, nên các luật dưới đây là bắt buộc. Nhánh theo luật repo (ops-core, ivr, golden-hour-video: `main`;
repo bán hàng: nhánh của luồng `toandeptrai`); module5 do Tài làm theo luật repo đó trên máy Tài (`D:/M5-worktrees`), phiên m5/m6 ở máy này chỉ đọc.

1. **Khai phạm vi ghi trước khi sửa.** `python tools/khoa_tep.py khai --repo <repo> --chu <phiên>/<gói> --tep <đường dẫn…>` (tệp hoặc thư mục tương đối
   so với gốc repo; `<repo>` viết đúng một trong: `ops-core`, `business-platform`, `ivr`, `golden-hour-video`, `module5`, `deploy`, `contracts`; `<phiên>/<gói>`
   ví dụ `m12/WP30`, phiên fork thì `m12-fork2/WP35`). Mã thoát 2 = chồng khoá: in ai giữ gì từ lúc nào. Lúc đó nhắn chủ khoá bằng `SendMessage` (tên phiên lấy từ `list_sessions`) hoặc
   làm gói khác; không sửa tệp đang bị khoá. Xong gói thì `giai`. `xem` liệt kê khoá, `gio --tuoi 12` liệt kê khoá cũ (người dọn khoá của người khác
   phải nhắn họ trước, dùng `giai --ep`). Tệp nóng (migration, tệp đăng ký module, tệp sinh tự động, solution/lockfile) chỉ một chủ giữ tại một thời điểm.
   Phiên chính khai khoá cho cả phần subagent của mình; subagent chỉ sửa trong phạm vi brief đã khai.
2. **Commit: chỉ phiên chính, theo đường dẫn.** `git commit -m "<mã gói> …" -- <đường dẫn của mình>` (chưa push). Subagent không commit, không đổi index/ref.
   Cấm `git add -A`, `git add .`, `git commit -a`, `git stash`, `git reset`, `git clean`, `git checkout -- .`, `git restore .`, `git rebase`: những lệnh này
   đụng việc của phiên khác. `index.lock` đang bị giữ thì thử lại 5 lần cách 5 giây; không xoá khoá (chỉ xoá khi không còn tiến trình git nào và khoá cũ hơn 10 phút).
   Mỗi gói xong là một commit trên máy: Lead xem tiến độ bằng `git log`, `git diff` ngay trong checkout.
3. **Khoá đặc biệt**, mỗi repo một lúc một chủ giữ MỘT trong ba, khai bằng `--tep @tên` (không chồng với khoá tệp thường):
   - `@bo-kiem-du`: chạy bộ đủ, integration, e2e, test chạm DB/cổng. Tránh cạn cổng TCP và cây đổi giữa chừng. Chạy nền, chờ thông báo, giải khoá khi xong.
   - `@dot-bien` (chỉ ở cổng Nguy hiểm, §4; mặc định không dùng): verifier sửa tạm mã để thử đột biến. Trong lúc giữ, không ai khác build/test repo đó. Chỉ sửa tệp đã khoá cho gói đang kiểm và đang sạch
     (`git diff --quiet -- <tệp>` đúng), tối đa 10 phút, trả lại bằng `git restore -- <tệp>` rồi kiểm lại `git diff --quiet -- <tệp>`.
   - `@dong-bo`: merge/pull nhánh gốc vào cây, kèm `--tep` các tệp sẽ đổi (`git diff --name-only HEAD..origin/<nhánh gốc>`). Chỉ làm khi các tệp đó không bị khoá
     bởi phiên khác (hoặc chủ khoá đã commit và giải); nếu không, nhắn họ chờ. Đây là việc của phiên chính, không phải của subagent.
4. **Kiểm độc lập (chỉ cổng Nguy hiểm, §4) chấm đúng một commit.** Verifier/tester đọc diff bằng `git show <SHA>` hoặc `git diff <base>..<SHA> -- <đường dẫn gói>`, chỉ chạy lệnh kiểm
   khi coder không còn sửa tệp của gói (coder đã giải khoá, hoặc phiên chính đã commit). Kết quả chỉ có giá trị nếu `git diff HEAD -- <tệp của gói>` rỗng và
   `git rev-parse HEAD` không đổi từ đầu tới cuối lượt chạy; không thì chạy lại. Thấy đỏ ở tệp ngoài phạm vi của gói: đó là việc đang dở của phiên khác, báo chủ
   khoá (không tự sửa, không quy lỗi cho gói mình). Build/test nặng: mỗi agent thư mục build riêng (`PHIEN.md`), không hai lệnh cùng thư mục build.
5. **Đồng bộ nhánh.** Đầu mỗi lượt `git fetch`. Nhánh luồng trễ nhánh gốc thì phiên chính tự gộp (m34: `toandeptrai` ← `dev`) dưới khoá `@dong-bo`, ghi một dòng
   vào nhật ký; không chờ Lead. Tệp dở không phải của mình: ghi tên, làm né, không stash, không revert. Push, PR, merge vào nhánh chung vẫn chỉ khi Lead nói.
6. **Dọn.** Không để thư mục tạm ngoài `C:\Projects\_wt\_luu`. Thư mục `_wt` cũ: `python tools/don_wt.py` (chỉ đọc) rồi `--xoa`; công cụ xoá bản sạch,
   lưu bản vá nhỏ cho phần dở vào `_wt/_luu/<mã>/`, giữ mục sửa trong 24 giờ qua.

Phiên `m34`, `m5`, `m6` đồng bộ nguồn an toàn trước khi rà theo §8. Phần rà chỉ đọc (`git show`, `git diff`, đọc tệp trong checkout); nếu phải chạy test thì
khai `@bo-kiem-du` rồi chạy ngay trong checkout, kết quả theo mục 4.

Repo dùng chung **`ginsengfood-contracts` và `deploy` thuộc phiên `lead`.** Luồng khác cần sửa → thả `hop-thu/lead-<ngày>-<việc>.md`;
Lead cho một luồng ghi cho một WP cụ thể bằng `/quyet`.

## 4. Kiểm theo rủi ro, nhẹ vì đang dev/test (D-lead-064, thay R1/R2/R3, tầng 2 và tầng 3 cũ của D-lead-030)

Hai mức. Phần lớn gói là Thường; chỉ vùng Nguy hiểm mới có verifier, và chỉ ở cổng bật cờ/go-live, không từng task.

| Mức | Gồm | Quy trình |
|---|---|---|
| **Thường** (mặc định, khoảng 80%) | giao diện, chữ, màn quản trị, tài liệu, thêm test, dọn mã đã có test, tính năng thường | `coder` viết và chạy test lọc của gói (tầng 1) → phiên chính đọc diff đối chiếu tiêu chí (khoảng 10 phút) → commit trên máy theo đường dẫn. Không verifier, không đột biến, không bộ đủ ở máy. |
| **Nguy hiểm** | tiền và thanh toán · đăng nhập và phân quyền · xoá hoặc migration dữ liệu thật · gọi/nhắn khách thật hay đối tác thật · câu trả lời công khai của chat AI nói về công dụng sản phẩm | như Thường để gộp vào nhánh làm việc (chức năng đang tắt cờ, ví dụ luật gọi M8 ở MOCK, gộp được ngay), rồi qua **cổng Nguy hiểm** dưới đây **trước khi bật cờ thật**. Lead duyệt diff trước khi bật. |

**Cổng Nguy hiểm** (trước go-live 30/11; chỗ sẵn 25–27/11, đệm 28–29/11): mỗi vùng một `verifier` đọc **trạng thái cuối** của mã (`git diff <mốc cũ>..HEAD -- <đường dẫn vùng>`),
tối đa 2 giờ mỗi vùng, một vòng. Đối chiếu từng tiêu chí; thử tối đa 5 đột biến nhắm đúng dòng quan trọng, chỉ khi đã giữ khoá `@dot-bien` (§3 mục 3) và không ai khác đang build/test repo đó.
Lỗi nặng và lỗi trung bình: sửa ngay, phiên chính chạy lại test liên quan để xác nhận (không vòng 2 của verifier trừ khi có lỗi nặng). Lỗi nhẹ: ghi vào "Nợ" của `TRANG_THAI.md`/phiếu, làm sau.
Bật cờ thật sớm hơn 25/11 thì cổng của vùng đó chạy ngay trước khi bật.

### Test: coder chạy lọc, CI chạy bộ đủ lâu lâu (D-lead-064)

| Tầng | Ai | Chạy gì | Khi nào |
|---|---|---|---|
| 1 | `coder` | build/typecheck project bị đổi + test của gói (có lọc: `--filter`, `pytest <tệp>`, `vitest run <tệp>`); chạy lại chỉ khi mã đổi | từng gói |
| CI | pipeline GitLab | bộ đủ + quét bảo mật/PII + dựng ảnh | **không chạy khi push.** Chạy theo lịch đêm (m12 01:30, m8 03:30; repo bán hàng giữ như Phúc đang có) và bấm tay trước mốc 25/11, 28/11, 30/11 |

- Bỏ: verifier chạy lại lệnh của coder; bộ đủ chạy ở máy (CI làm một lần là đủ). Repo mà CI không chạy test khi push (repo bán hàng) thì phiên chính chạy bộ đủ ở máy dưới khoá `@bo-kiem-du` trước mỗi lần lên .99 cho gói chạm vùng Nguy hiểm.
- CI đêm đỏ: không chặn việc lên .99, trừ khi đỏ ở vùng Nguy hiểm. Phiên chính quy lỗi về gói theo tệp/vùng và sửa trong ngày.
- **Lên .99:** pipeline rút gọn bấm tay, chỉ gồm `build-images` + `deploy-99` (m12) hoặc `publish_images` các ảnh có đổi + `deploy_m8_99` (m8); `trien-khai.sh` vẫn sao lưu DB, kiểm sức khoẻ, tự lùi. Chỉ làm khi Lead nói "deploy" (trừ phạm vi đã có lời duyệt sẵn, như m12.181: gói đã commit + kiểm nhanh xanh thì lên .99; bật cờ production hay sửa `.env` vẫn hỏi riêng). Sau mỗi lần lên: bài kiểm nhanh (`/health`, đăng nhập, một đơn thử MOCK), phiên chính chạy và ghi kết quả vào phiếu.
- Giữ nguyên: quét gitleaks trước push (sổ và repo công khai), cờ production tắt mặc định, push/deploy chỉ khi Lead nói.
- Brief tách hai dòng: "lệnh kiểm nhanh" (tầng 1) và "vùng Nguy hiểm? có/không" (`chung/MAU.md` §1 mục 5). Bộ đủ không nằm trong brief của coder.

## 5. Ngân sách song song

- Mỗi phiên tối đa **3 agent nặng cùng lúc** (`coder`, `verifier`, tester); agent chỉ đọc (`scout`, `auditor`) tối đa 4.
- Toàn máy khoảng **10 agent** → chỉ **2 phiên chạy sóng code cùng lúc**. Gặp lỗi 429: hạ cỡ sóng, chạy lại agent hỏng, không mở thêm phiên.
- `scout` dùng model nhẹ; `coder`, `verifier`, `auditor` dùng model mạnh.
- Build/test nặng (.NET, Maven): không chạy hai lệnh trên cùng thư mục build; mỗi agent thư mục build riêng (xem `PHIEN.md`).
- Mỗi repo cùng lúc tối đa **một bộ kiểm đủ chạy ở máy** (khoá `@bo-kiem-du`, §3 mục 3), chỉ khi §4 cho phép; coder/verifier không chạy bộ đủ.
- **Dọn máy (D-lead-031):** ai bật tiến trình thì người đó tắt (`LUAT_SUBAGENT.md` mục 9). Phiên chính chạy
  `pwsh -NoProfile -File "C:\Projects\Project Control\tools\don_may.ps1" -Dung` ở đầu phiên (`/phien`), sau mỗi sóng (`/song` bước 8)
  và khi chốt phiên (`/cuoi-phien`). Công cụ chỉ dừng: tiến trình dự án có cha đã chết (mồ côi) và đứng yên; tiến trình nặng
  (dotnet, node, testhost, python…) của phiên còn sống đã chạy ≥ 120 phút, đứng yên và phiên chủ không nhắc tới cổng/thư mục/PID của nó
  trong 60 phút; container Testcontainers không còn ryuk. Không đụng tiến trình đang dùng CPU, MCP server, app/terminal người dùng
  tự mở, `ginsengfood-postgres-local`. Dừng tiến trình của phiên khác thì nhắn phiên đó một dòng (PID, lệnh, cổng).
  **Tự chạy mỗi 30 phút** (Lead duyệt 10/11): `tools/don_may_lap.ps1` chạy ẩn, tự bật khi đăng nhập (lối tắt
  `Startup\Ginsengfood-DonMay.lnk`; máy này chặn Task Scheduler khi không nâng quyền). Chế độ lịch chỉ dừng thứ đã đứng yên hai lượt liền
  và không có kết nối mạng. Log: `%LOCALAPPDATA%\don_may\don_may.log`. Tắt: `pwsh -File "C:\Projects\Project Control\tools\don_may_lap.ps1" -Tat`;
  bật lại: `… -Cai`.

## 6. Brief cho subagent

Subagent chỉ biết những gì brief ghi. Brief = phần "Brief" của phiếu WP (`chung/MAU.md` §1, đủ 8 mục), viết một lần;
giao lại vòng 2 hay phiên mới làm tiếp đều dùng lại phiếu.

## 7. Giữ sổ

| Tệp | Ai sửa | Kiểu |
|---|---|---|
| `modules/<mã>/TRANG_THAI.md` | phiên của luồng | ghi đè, ≤ 60 dòng; mốc = giờ từ `date` + SHA |
| `modules/<mã>/SAN_SANG.md` | phiên của luồng | sửa tại chỗ: bậc năng lực, bằng chứng, bảng WP |
| `modules/<mã>/QUYET_DINH.md` | phiên của luồng; phiên `lead` được **thêm dòng** khi Lead quyết việc của luồng đó | thêm một dòng |
| `modules/<mã>/wp/<WP>.md` | phiên của luồng | phiếu gói việc, bắt buộc |
| `modules/<mã>/ra-soat/` | phiên của luồng | bản rà soát, tin nhắn soạn sẵn |
| `modules/<mã>/nhat-ky/<yyyy-mm-dd>.md` | phiên của luồng | thêm cuối, mỗi việc một dòng |
| `modules/<mã>/git_moc.json` | script `tools/git_tong_quan.py --luu` | mốc SHA cho lần so sau |
| `hop-thu/<mã>-*` | ai cũng thả; phiên của luồng chuyển sang `xong/`; phiên `lead` đổi tiền tố `lead-` | — |
| `C:\Projects\bao-cao-tuan\<kỳ>\` | phiên của luồng (báo cáo/rà soát của mình); `lead` (tổng hợp, bản rà M12/M7/M8) | tạo tệp mới |
| `TONG_QUAN.md`, `chung/`, `CLAUDE.md`, `.claude/`, `tools/` | chỉ phiên `lead` | sửa tại chỗ |

Phiên `lead` **không** ghi đè `TRANG_THAI.md`/`SAN_SANG.md` của luồng khác (phiên đó đang mở sẽ ghi đè lại). Lead quyết việc của
luồng khác → thêm dòng vào `QUYET_DINH.md` của luồng đó; `/phien` và `/cuoi-phien` của luồng đọc dòng mới trước khi ghi sổ.

Dòng quyết định: `D-<mã>-NNN · <dd/mm hh:mm> · "<lời Lead, ngắn>" · hệ quả · đã sửa ở <tệp>` (NNN = số lớn nhất trong tệp + 1).
Quyết định mới thay quyết định cũ → **sửa thẳng câu luật cũ** và ghi "thay D-…" trong dòng mới.
Không để luật dạng "A, trừ khi B, nhưng từ ngày X thì C".

## 8. Tracker và báo cáo

- Khi triển khai WP/code, repo có `tools/task-tracker/sheet-sync.mjs` và luật bắt ghi: **chỉ phiên chính** chạy; subagent không chạy.
  WP mới: `node tools/task-tracker/sheet-sync.mjs log --module <M12|M5|M8…> --title "<WP> <tên>" …` lần đầu, ghi id Sheet trả về
  vào phiếu; các lần sau dùng `--id`.
- **Ghi Sheet theo từng WP, ngay khi việc đổi, không gộp cuối sóng (D-lead-032):**
  - lúc giao (`/song` bước 4): `log --id <id> --status IN_PROGRESS`;
  - ngay khi WP có verifier ĐẠT và đã commit/ghép: `log --id <id> --status DONE --commit <SHA> --evidence "<verifier ĐẠT + lệnh + phiếu>"`
    (R3: `--status REVIEW`, chờ Lead duyệt diff); WP mới xong một phần: giữ `IN_PROGRESS`, thêm `--progress`;
  - bộ kiểm đủ cuối sóng xanh: **task của Lead R1/R2** → phiên chính ghi luôn `sheet_lead.mjs ghi` verdict `Đạt`, note dẫn verifier +
    SHA bộ đủ (W = Đạt, J = Hoàn thành). Bộ đủ đỏ quy về WP nào → `log --id <id> --status IN_PROGRESS` + lý do; sửa xong ghi lại.
  - Còn để `Chờ review` cho Lead: R3, báo cáo tuần, task cần người ngoài xác nhận (nghiệm thu, Chú duyệt, Anh Tuấn làm máy).
- Trước mọi lượt `/ra-soat` (kể cả `bao-cao`, `lien-module`), phiên chính kiểm nhánh/upstream, checkout sạch và không có phiên đang dùng,
  chạy `git pull --ff-only --no-rebase` từng repo nguồn rồi ghim SHA; ghi kết quả và SHA trước/sau. Repo dirty, phân kỳ hoặc pull lỗi:
  giữ checkout, báo lý do chưa pull; chỉ rà SHA remote bằng `git show origin/<nhánh>:<đường dẫn>` hoặc `git diff` khi fetch được và luật repo cho phép (không dựng worktree, D-lead-063).
  Không tự checkout/tạo nhánh, stash/reset hay tạo merge commit. M3 chỉ pull `toandeptrai` từ `origin/toandeptrai`; sai nhánh dừng hỏi Lead.
- Rà task của người khác không ghi `sheet-sync log` lên task coder. Mặc định `/ra-soat <người/module>` thực hiện đủ quy trình
  ở [lệnh rà soát](../.claude/commands/ra-soat.md) (D-lead-020): `tools/sheet_lead.mjs can-ra` lấy tập task Hoàn thành/Chờ review
  chưa Đạt, ghim ID + SHA, chia auditor kiểm từng tiêu chí/code/PR/DoD/test. Không suy báo cáo tự khai thành test đã kiểm.
- **Rà xong chỉ có hai kết quả: Đạt hoặc Cần sửa.** Thiếu bằng chứng cũng là Cần sửa, ghi rõ việc phải làm. Task đã Đạt không rà lại;
  task Cần sửa chưa được người làm cập nhật sau lượt rà thì chờ, không rà lại. `Chưa duyệt` chỉ còn nghĩa là chưa ai rà.
- **DL do PM của Tài chốt (D-m5-027, D-lead-033), áp cho `m34` phần Tài, `m5`, `m6`:** PM được chốt lựa chọn kỹ thuật đã có đề xuất
  trong docs, ghi nguồn + người uỷ quyền. Phạm vi pilot, điều kiện Go/No-go, dữ liệu khách, bảo mật do Tài hoặc Lead chốt.
  Khi rà: không bắt lỗi DL kỹ thuật PM chốt có nguồn; DL PM chốt chạm bốn vùng trên → Cần sửa, ghi "cần Tài hoặc Lead chốt".
- Ghi Sheet **bằng code, ngay trong lượt rà**: `node tools/sheet_lead.mjs ghi <ket-qua.json>` (web app ≥ 1.5.0, khoá Lead ở máy Lead).
  Task của Lead (cột Người phụ trách là Nguyễn Quốc Toàn): W + nối X + J (Đạt → Hoàn thành, Cần sửa → Đang làm), H tự tính.
  Task Phúc/Tài: chỉ W/X, các cột khác giữ nguyên. Công cụ đọc lại và đối chiếu; không mở trình duyệt, không sửa tay.
  Kết luận rà task không thay quyền merge/deploy, nghiệm thu production hoặc mở cờ an toàn.
- Mặc định soạn tin nhắn nháp kèm bản rà, mỗi người phụ trách một tin để Lead gửi; task Lead ghi kết quả cho Lead.
  **Không gửi** nếu chưa có lệnh gửi rõ. Sau đồng bộ, phần rà không sửa mã/commit; test dùng
  môi trường tách biệt. Hai chế độ `/ra-soat bao-cao` và `lien-module` giữ khuôn riêng, không tự áp ghi Sheet/soạn tin của rà task.
- Báo cáo cho Chú theo `chung/VAN_BAO_CAO.md`.
