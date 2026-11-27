# Phiên `m34` — rà soát M3 và M4 trong business-platform

Lead dùng phiên này để **đọc, kiểm tra, rà soát, báo cáo** ba mảng việc chạy song song, và để **code phần kết nối đơn hàng
M3 → M8** (D-m34-003). Từ 16/11 (D-m34-091): Phúc rà + gộp các nhánh chú Dũng vào `dev`; code của Toàn trên `toandeptrai` Toàn tự gộp vào `dev` (đẩy thẳng lên GitLab, mục "Git của repo bán hàng" bên dưới). Khi rà việc Phúc/Tài: đồng bộ checkout an toàn theo quy trình rồi đọc/kiểm; không sửa mã, commit, push hay tạo merge commit trừ khi Lead lệnh rõ
(và báo người làm trước). Phần M3 → M8: commit trên nhánh `toandeptrai`; push/PR/merge khác vẫn hỏi Lead từng lần.
**Đẩy ở đâu và "đồng bộ dev" làm thế nào: xem mục "Git của repo bán hàng" bên dưới (D-m34-112, 116, 117). Tóm tắt: chỉ đẩy lên GitLab; GitHub nhận qua gương; lệnh đẩy chỉ chạy khi Toàn nói đúng việc đó.**

**Máy .99 (D-m34-108, D-lead-060, thay phần "m34 deploy .99" của D-m34-092): phiên này CHỈ ĐỌC .99.** Mọi thay đổi trên .99 của repo bán hàng
(đưa bản mới, `.env`, compose, cờ, `cong-khai-99.sh lui|tat`, tạo lại container, sửa dữ liệu) chỉ Phúc làm, bằng image CI + `trien-khai.sh`, giữ lớp
`compose.cong-khai.yml`. Phiên m34: đọc .99, chuẩn bị (SHA, bảng cờ, kịch bản kiểm, giờ), soạn yêu cầu để Toàn nhắn Phúc, đọc kết quả sau lượt của Phúc.

**Trên máy này, mọi việc ghi vào repo (Claude, Codex, mọi phiên) chỉ trên nhánh `toandeptrai`** (D-m34-004): trước khi sửa/commit
chạy `git branch --show-current`, khác `toandeptrai` thì dừng hỏi Lead; không tạo nhánh mới; không worktree (D-lead-063): sửa và rà thẳng trong checkout, theo `chung/CACH_LAM.md` §3.
Luật này cũng nằm ở `CLAUDE.local.md` (gốc repo, loại khỏi git) và `~/.codex/AGENTS.md` cho phiên mở thẳng trong repo.

## Git của repo bán hàng — đẩy ở đâu, đồng bộ dev thế nào (D-m34-112, D-m34-116, D-m34-117; cập nhật 26/11)

**Đẩy ở đâu: CHỈ GitLab** (`gitlab` = `https://gitlab.com/PhucApu/ginsengfood-business-platform`, nơi Phúc chạy CI và deploy trên nhánh `dev`).
GitHub (`origin`) chỉ để lấy về; GitHub nhận code qua **gương GitLab → GitHub** (gương giữ "Keep divergent refs": KHÔNG tắt, tắt là gương ghi đè ép và mất commit).
Hai lệnh đẩy hợp lệ: `git push gitlab toandeptrai:dev` (vào `dev`) và `git push gitlab toandeptrai` (nhánh của Toàn). Mọi lệnh đẩy: chỉ khi Toàn nói đúng việc đó (cụm "đồng bộ dev" cho phép đúng `toandeptrai:dev`); chạy riêng, không nối với lệnh khác; không force; không đẩy nhánh khác; không mở PR; không `git push origin`.
Tài và Toàn cùng đẩy thẳng vào `dev` trên GitLab (không còn PR; D-m34-019/056 cũ hết hiệu lực). Lên .99 vẫn chỉ Phúc.

Cấu hình trong checkout (đã đặt 26/11): `remote.pushDefault=gitlab`; `origin` có địa chỉ đẩy đặt sai cố ý nên lỡ `git push origin` báo lỗi; `toandeptrai` theo dõi `gitlab/toandeptrai`. Nếu `git remote -v` thiếu `gitlab` hoặc `origin` đẩy được thật (checkout mới, cấu hình mất) thì dựng lại:

```
git remote add gitlab https://gitlab.com/PhucApu/ginsengfood-business-platform.git
git config remote.pushDefault gitlab
git config remote.origin.pushurl KHONG_DAY_LEN_GITHUB__chi_day_len_gitlab_github_nhan_qua_guong
git branch --set-upstream-to=gitlab/toandeptrai toandeptrai
```

(GitLab là kho riêng tư: `git fetch/push` dùng thông tin đăng nhập đã lưu của Toàn trên máy; API và pipeline không đọc được nếu không có token, không dùng cách khác để đọc.)

**"Đồng bộ dev" (Toàn nói đúng cụm này) làm theo thứ tự:**

1. `git branch --show-current` phải là `toandeptrai`; `git status` chỉ được dở hai tệp của Toàn (`.gitignore`, `docs/weekly-tracking/nguyen-quoc-toan.md`): không commit, không stash.
2. Khai khoá: `python tools/khoa_tep.py khai --repo ginsengfood-business-platform --chu m34/dong-bo-<ngày> --tep @dong-bo <thư mục sẽ đổi>`; thoát mã 2 (chồng khoá) thì dừng. Rồi `git fetch gitlab` và `git fetch origin`.
3. Đọc lệch trước khi gộp: `git rev-list --left-right --count gitlab/dev...origin/dev` và `git log toandeptrai..gitlab/dev`. GitLab `dev` là nguồn thật. GitHub `dev` có commit mà GitLab không có thì báo Lead (gương đang lệch), không tự xử bằng force.
4. Gộp `gitlab/dev` vào `toandeptrai`: `git merge --ff-only gitlab/dev` khi toandeptrai không có commit riêng, nếu không `git merge --no-ff gitlab/dev -m "merge: gộp gitlab/dev (<sha>) vào toandeptrai"`. Xung đột thì tự giải như coder; không chắc cách giải thì dừng và hỏi.
5. **Git gộp sạch về chữ chưa đủ** (bài học 26/11: hai nhánh cùng đặt V410, git không báo, `be` không khởi động): chạy `python back-end/scripts/ci/kiem_migration.py` (trùng/thiếu số Flyway) và `python back-end/scripts/ci/docker_tests.py --check`; xem số migration cao nhất bằng `git ls-tree -r --name-only HEAD -- back-end/src/main/resources/db/migration`. Máy này dùng `python`, KHÔNG dùng `python3` (là bản giả của Windows). Rồi kiểm nhanh biên dịch + test hợp đồng lọc dưới khoá `@bo-kiem-du`; Toàn có thể dặn "khỏi test" từng lần: khi đó ghi CHƯA CHẠY vào nhật ký và vào tin cho Phúc. Bộ đủ BE/FE chạy MỘT lần trước khi báo Phúc lên .99 (D-lead-064), không bắt buộc trước khi đẩy `dev` (đẩy chỉ làm GitLab dựng ảnh, Phúc deploy tay).
6. Quét bí mật các dòng mình thêm (khoá, token, số từ 10 chữ số trở lên; số điện thoại giả trong test bộ lọc lý do là chấp nhận được).
7. Ngay trước khi đẩy: `git fetch gitlab` lần nữa; `gitlab/dev` phải là tổ tiên của HEAD. Nếu có người đẩy xen (Phúc/Tài) hoặc lệnh đẩy báo "fetch first" thì fetch, gộp tiếp, chạy lại bước 5, rồi đẩy lại; không force.
8. `git push gitlab toandeptrai:dev` (và `git push gitlab toandeptrai` khi Toàn cho). Kiểm `git ls-remote gitlab` và `git ls-remote origin`: gương cập nhật GitHub sau ít phút; bốn ref (`dev` và `toandeptrai` ở hai nơi) phải trùng nhau.
9. Giải khoá, ghi `nhat-ky` (SHA trước và sau, gì đã kiểm, gì CHƯA CHẠY), nhắn Toàn để báo Phúc nếu có migration mới hoặc đổi số.

**Số migration:** trước khi viết migration mới kiểm cả `origin/*` và `gitlab/*` (`git ls-tree -r --name-only <ref> -- back-end/src/main/resources/db/migration`); cao nhất V411 ngày 26/11, lần sau lấy từ V412; hỏi Tài/Phúc nếu họ có nhánh đang dở. .99 Flyway `out-of-order=false`, nên số mới luôn phải lớn hơn mọi số đã có ở cả hai nhánh.

**Phúc hay gộp tay nhánh của Toàn vào `PhucApu`:** sau khi đẩy lên GitLab `dev`, báo Phúc là đã đẩy và đừng gộp thêm; nếu Phúc đã gộp (như 26/11 10:47) thì lấy `gitlab/dev` về gộp tiếp trước khi đẩy.

## Repo và nguồn

- Repo: `C:\Projects\ginsengfood-business-platform` (GitLab `PhucApu/ginsengfood-business-platform` là nơi đẩy, CI và deploy; GitHub cùng tên chỉ nhận qua gương). Spring Boot `back-end/` + Next.js `front-end/`.
- Nhánh: `dev` (chung) · `dev015` (Tài, PR `dev015 → dev`, Tài tự gộp PR của mình, Lead soát cuối tuần) · `PhucApu` (Phúc) ·
  `toandeptrai` (Lead, M3 → M8, tạo 02/11, checkout chính đang ở nhánh này; theo dõi `gitlab/toandeptrai`) ·
  `master` (cũ, sau `dev` hơn 1.600 commit, không dùng). CI: GitLab chạy `kiem-tra-khuon` + `build-images` khi đẩy `dev`; test BE/FE không chạy tự động (D-lead-064); CI GitHub kẹt Billing từ 17/11, không dùng.
- (Lịch sử, HẾT HIỆU LỰC từ 21–26/11, thay bằng mục "Git của repo bán hàng":) D-m34-019 (03/11): mọi lần vào `dev` qua PR (Phúc `PhucApu → dev`, Tài `dev015 → dev`, Toàn `toandeptrai → dev`, cả sổ tracker); trước đó
  từ PR #145 (30/10) Phúc và sổ tracker đẩy thẳng `dev` → CI không chạy. Rà: lần vào `dev` không có "Merge pull request #" là vi phạm.
- (Lịch sử, hết hiệu lực như dòng trên) D-m34-056 (10/11, m34.81 A): PR vào `dev` cần **CI bộ nhanh xanh + 1 người soát (Toàn)**; không tự gộp PR của mình khi CI đỏ. Hiện `dev` đỏ sẵn 21 test (hậu kiểm RS1 10/11)
  nên bộ nhanh chưa có: gói M34-CI đang dựng (tách `ci-unit` nhanh bắt buộc / đầy đủ chạy riêng). PR #155 (M3-112) gộp ngoại lệ một lần khi không có test đỏ ngoài 21 test đã biết.
- Sổ điều hành của Tài: `C:\Projects\M4-PLAN` (bản clone, Tài tự push). Trước khi dùng: `git -C C:\Projects\M4-PLAN pull --ff-only`.
  **Chỉ đọc đoạn:** báo cáo đầu ngày mới nhất `02_PROJECT_CONTROL/04_REPORTS/PERIODIC/bao-cao-dau-ngay-<ngày>.md`;
  60 dòng đầu `PROJECT_STATUS.md`; grep `OWN-2[89][0-9]` trong `02_PROJECT_CONTROL/00_GOVERNANCE/OWNER_DECISIONS.md`.
  **Không** đọc trọn `_MEMORY/NHAT_KY.md` (1,8 MB), `REGISTRY.json` (1,4 MB), `PROJECT_STATUS.md` (220 KB).

## Ba mảng và phạm vi mã

| Đối tượng | Người · git | Phạm vi |
|---|---|---|
| `phuc` — M3 bán hàng | Trương Công Phúc · `PhucApu`, truongphuc056@gmail.com | front-end `src/features/*` trừ phần M4 và checkout/kết quả thanh toán/cài đặt vận chuyển; back-end M3 lõi (order, cart, customer, promotion, membership, collaborator…) trừ `shipping/` và lớp VNPAY/SePay. Phần máy chủ nhận lại từ Nguyễn Đức Mạnh (BÀN GIAO) |
| `tai-m3` — M3 vận chuyển + thanh toán | Nguyễn Phát Tài · `Nguyenphattai020904`, tác giả `claude-subagent/*` trên `dev015` | back-end `shipping/` (carrier/ghn, carrier/viettelpost, carrier/shipment, webhook); lớp VNPAY/SePay trong `order/` (`VnpayGatewayAdapter`, `VnpayPaymentWebhookVerifier`, `VnpayReturnLogController`, `config/VnpayIpnProxyTrustGuard`, `Sepay*`); front-end checkout, trang kết quả thanh toán, cài đặt vận chuyển |
| `tai-m4` — M4 AI tư vấn | Nguyễn Phát Tài | back-end `ai/`, `advisorsales/`; front-end `src/features/ai_operation_brain`, `m4-testing`, `src/app/chatbot` |
| `toan` — M3 kết nối M8 (Lead code) | Nguyễn Quốc Toàn · `toandeptrai`, ngquoctoan2001@gmail.com | đẩy đơn M3 sang M8 (gọi xác nhận đơn tự động) và nhận kết quả về đơn. Chạm tệp order lõi của Phúc → báo Phúc trước; hợp đồng API/sự kiện ở `ginsengfood-contracts` (phiên `lead`); phía M8 ở `ginsengfood-ivr` (phiên `m8`). Sheet M3-023, người phụ trách "Nguyễn Quốc Toàn" |

Bảng phân phạm vi gốc: `tools/task-tracker/bao-cao-tuan/bao-cao.json`.

## Lệnh (chạy trong checkout chính dưới khoá `@bo-kiem-du` khi rà soát cần — m34.5 có, D-m34-033; rà không chạy `sheet-sync log` lên task coder — m34.1, D-m34-033)

- Back-end nhanh: `cd back-end && ./mvnw -B -fae test -P ci-unit` (không cần Docker, 2–4 phút; đặt `JAVA_TOOL_OPTIONS=-XX:MaxRAMPercentage=40`).
  `-P ci-integration` cần Docker. Repo yêu cầu **hỏi trước** khi chạy `mvnw test`.
- Front-end: `npm run lint`, `npm run build`, `npm run test:run` (≈1.861 test vitest, 2 lỗi có sẵn). `npm run test` là chế độ theo dõi — không dùng.
- Rà soát: `git show <SHA>`/`git diff`; không dựng worktree (D-lead-063); chỉ chạy test khi mã đã nằm trên `toandeptrai`, còn lại dựa CI.

## Danh mục kiểm khi rà soát

Chung ba mảng:
- Đếm lại số test người làm khai (ví dụ "300/300"); tách E2E giả lập với E2E chạy backend thật.
- Commit đã vào `dev` chưa (`git branch -r --contains`); việc chỉ nằm trên nhánh riêng.
- Migration `back-end/src/main/resources/db/migration/V###__*.sql`: trùng số (`uniq -d`), sửa migration đã gộp, khoá V221–V247
  (`MigrationVersionLockContractTest`), số bỏ trống (V249, V253, V256 — test thang số đỏ trên dev vì thiếu V256).
- `security/SecurityConfig.java`: `permitAll`, đường webhook bỏ qua xác thực; endpoint chat AI đang công khai.
- `contracts/openapi/latest.json`, `contracts/api-snapshots/*` khớp mã; front-end `src/api` cập nhật theo.

`phuc`: đọc diff trực tiếp (commit "save", không CI); hai tệp V251 từ gộp `cfc8eea85`, một tệp đổi thành V258 thẳng trên `dev` —
DB dùng chung đã chạy V251 cũ chưa; tiến độ nhận phần máy chủ từ Mạnh.

`tai-m3`: đúng một bộ kiểm chữ ký VNPAY; lọc IP IPN + tin proxy; xử lý tin báo idempotent, kiểm số tiền; không lộ bí mật trong log;
URL thanh toán còn mặc định sandbox; 11 IP production; giới hạn tần suất lớp vào (chưa có chủ); GHN/VTP tắt mặc định, trỏ URL dev;
`CarrierShipmentOrderLockPostgresTest` phải đạt trước khi bật GHN/VTP; khoá đơn khi tạo vận đơn, webhook trả 401 khi sai xác thực,
dữ liệu tham chiếu đóng khi lỗi; dựng lại vận đơn sau huỷ (`M3-SHIP-CARRIER-RECREATE-001`) còn mở.

`tai-m4`: kiểm khởi động production còn nguyên (`AiRuntimeEnvironmentPolicyValidator`), cờ AI trong `application-production.yml` đều tắt;
không có audit NoOp im lặng; lớp chặn câu trả lời cuối; test ranh giới module. So sánh khối lượng: 107 commit gần đây chủ yếu là
luật chữ an toàn chat — hỏi: đường tới chạy thật của M4 (REL-001, chủ dự án ký) đang ở đâu.

Liên ngành (auditor thứ tư khi `all`): xung đột migration giữa `dev015` và `dev`; trạng thái CI các PR gần nhất; `dev` build/test có xanh.

## Rà soát (`/ra-soat`)

Mặc định `all` = 3 auditor (`phuc`, `tai-m3`, `tai-m4`) + 1 liên ngành, chạy nền cùng lúc. Nguồn đối chiếu mỗi người:
báo cáo tuần trong `docs/weekly-tracking/bao-cao/`, nhật ký `docs/weekly-tracking/<người>.md`,
Sheet `node tools/task-tracker/sheet-sync.mjs list --module M3|M4`, và (Tài) sổ `C:\Projects\M4-PLAN` theo đoạn ở trên.
Áp bước đồng bộ của `.claude/commands/ra-soat.md`: kiểm checkout sạch, không có phiên đang dùng; pull `--ff-only --no-rebase`
trên `toandeptrai` từ `gitlab/toandeptrai` và pull an toàn M4-PLAN. Sai nhánh dừng hỏi Lead; không checkout sang dev/dev015/PhucApu.
Rà từng SHA của task/PR trên nhánh nguồn/đích tương ứng, không dùng HEAD toandeptrai thay cho mọi task của Phúc/Tài.
Rà toàn bộ DONE/REVIEW theo từng ID/tiêu chí/code/PR/test, ghim SHA;
kiểm không thiếu/lặp và đọc lại cuối lượt. Phiên chính cập nhật Lead duyệt: ĐẠT PHẠM VI → Đạt; CẦN SỬA → Cần sửa;
CHƯA ĐỦ BẰNG CHỨNG → Chưa duyệt; nối Ghi chú Lead theo ID/header/dropdown, giữ ghi chú cũ, đọc lại hai cột Lead và cột khác.
Task Phúc/Tài: chỉ W/X, giữ H/J/%, cột coder; soạn tin nháp đúng người, không tự gửi.
Task Lead/Nguyễn Quốc Toàn (kể cả M3-023) cập nhật đủ H/J/W và nối X theo D-lead-011: đạt phạm vi → H=Đã xong, J=Hoàn thành, W=Đạt.
Kết luận task không thay quyền merge/deploy. `bao-cao`/`lien-module` giữ khuôn riêng.

## Kiểm đầu phiên

- `git -C <repo> fetch --all --prune`; đầu `gitlab/dev`, `gitlab/dev015`, `gitlab/PhucApu` (và `origin/*` để so gương); commit mới mỗi nhánh từ mốc trong
  `TRANG_THAI.md` (`git log --format='%h %an %ad %s' --date=short <mốc>..origin/<nhánh>`); PR mới (dòng "Merge pull request #").
- Sổ Tài: pull, đọc báo cáo đầu ngày mới nhất (mục "Cần anh làm", "Vướng").
- Sheet M3/M4: việc trễ hạn, bị chặn.

## Tracker

Repo bắt ghi `sheet-sync log` khi triển khai task. Riêng rà task Phúc/Tài: không dùng `log` lên task coder;
chỉ cập nhật Lead duyệt và Ghi chú Lead theo quy trình chung, đọc lại và giữ sổ audit trong Project Control. Sau đồng bộ, phần rà không sửa mã/commit.
Phần M3 → M8: phiên chính chạy `node tools/task-tracker/sheet-sync.mjs log --id M3-023 …` (hoặc `--module M3 --title …` cho việc mới)
trên nhánh `toandeptrai`; từ `547dd59a0` task tự ghi người phụ trách "Nguyễn Quốc Toàn", chỉ cập nhật Sheet, không ghi vào nhật ký của Phúc.
Repo đòi GitNexus `impact`/`detect_changes` trước khi sửa/commit, nhưng máy chưa index repo này → dùng grep người gọi, ghi rõ trong commit.

## Báo cáo tuần

`/bao-cao-tuan` làm một lượt hai việc (D-lead-024): bước 1 tự viết `M3-ket-noi-trien-khai` của Toàn (task tab M3 trên Sheet có người
phụ trách Nguyễn Quốc Toàn: nối M3 → M8, kiểm trên .99 trong lúc chờ máy thử (D-lead-065), CI lên máy chủ; lưu thẳng vào thư mục tuần) và bước 2 rà `M3-ban-hang`,
`M3-van-chuyen-thanh-toan`, `M4-tu-van-ai`. M3 có ba người, không lẫn việc người này vào báo cáo người kia.
