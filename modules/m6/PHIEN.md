# Phiên `m6` — M6 Đo quảng cáo / ROAS (Tài làm, Lead giám sát)

Lead bàn giao M6 cho Tài ngày 31/10 (DL-048). Phiên này để **giám sát, rà soát, gỡ quyết định**. Đồng bộ nguồn an toàn trước khi rà;
phần rà không sửa mã/commit vào repo Tài.
Lead nhận một lát việc → `/quyet` ghi rõ, báo Tài, rồi mới `/song` (chế độ W, hoặc S nếu Tài đang không làm cùng vùng).

## Repo

- Từ 10/11 (DL-096 của M6, DL-220 của M5, D-m5-025): **`C:\Projects\module5` thư mục `m6/`**, GitHub `sasamviet-ai/module5`, nhánh `main`.
  `module6` (`master` `e5e8cca` 10/11) nằm trọn trong đó, ngừng nhận commit, Lead lưu trữ: chỉ đọc.
- Checkout `module5` dùng chung với phiên `m5` (worktree rà của m5 ở `C:\Projects\_wt\m5\`). Phiên `m6` chỉ đọc/rà phần M6.
- Mã M6 ở `m6/app/`, `m6/tests/`, `m6/migrations/` (0001–0029), `m6/pyproject.toml`, build bằng `m6/Dockerfile` (M5 build bỏ `m6/`).
  Pack cũ ở `m6/_archive/pack-v1/`. FastAPI + Postgres `m6` (DL-O05).
- UI quản trị chung ở `web/` gốc repo (Next.js, M5-138); màn M6 gọi `/api/admin/ads/*` cùng origin theo hợp đồng `m6/web/contract/`
  (M6-141, DL-096, DL-097). Tài code UI M6 (D-m6-012).
- Sổ M6 giữ riêng: `m6/docs/00-overview/DECISION_LOG.md`, `m6/docs/06-tracking/`, tab Sheet M6, mã task M6 không đổi.
- Nguyên tắc nghiệp vụ: chỉ đo, không hành động (DL-001); doanh thu chỉ từ `ORDER_VERIFIED` (DL-002); thiếu đồng ý thì đóng.

## Luật repo phải nhớ

- Luật chung repo: `module5/CLAUDE.md` §6 (repo gộp). Luật M6: `m6/CLAUDE.md` (= `m6/AGENTS.md`).
- Tài quyết việc kỹ thuật và ghi dòng DL (DL-043). **PM của Tài chốt được lựa chọn kỹ thuật đã có đề xuất trong docs**, ghi nguồn +
  người uỷ quyền (D-m5-027, D-m6-013, `chung/CACH_LAM.md` §8; Lead đã nhận DL-097). Phạm vi pilot, Go/No-go, dữ liệu khách, bảo mật
  do Tài hoặc Lead chốt.
- Mỗi task một worktree từ `origin/main` (`D:/M5-worktrees/M6-0xx`), nhánh `m6/M6-0xx-<tên>`. Phiên con commit, không push.
  **PM của Tài đẩy nhánh `m6/*`, mở PR và gộp vào `main` bằng merge commit** (OWN-293); phần M6 không squash (phần M5 thì squash).
  Không force push, không đẩy thẳng `main`. Phiên giám sát không nhận quyền push/gộp này.
- Cờ an toàn `m6/app/config.py:11-13`: `GLOBAL_GATEWAY_STATE` = BLOCKED, `PRODUCTION_FLAG` = OFF, `EXTERNAL_SEND` = OFF; cơ chế đọc cờ theo
  D-m6-007. Không chạm `m6/04-artifacts/state/`.
- CH21 (thư mục `M6/`) chỉ nằm ở `C:\Projects\module6\M6\` (lưu trữ, gitignore ở module6): để nguyên. `module5` **chưa** ignore `m6/M6/`
  → không được chép CH21 sang `module5`.
- Máy chủ M6: máy mkt **192.168.1.98**, thư mục `/data/ginsengfood-marketing` chung M5, Postgres riêng (D-m6-015, D-m6-016; thay .60 của D-m6-004).
  `mkt.` vào qua proxy Caddy trên chính .98 (compose `edge`, phiên `lead` dựng, ngoài compose M5/M6; HTTPS chạy thật từ 17/11 ~16:3x, D-m6-026),
  chia đường: `/api/admin/ads/` → `.98:6600` (M6); `/admin/`, `/api/admin/`, `/api/channel/meta/` → `.98:3000` (M5); `/` 301 → `/admin/`;
  còn lại 404; Tài không dựng gì ở 80/443 (D-m6-020). M6 nghe 6600 trên LAN, chỉ tin `X-Forwarded-*` từ proxy `.98/32` (D-lead-057).
  Bảng máy: `chung/MAY_CHU.md`.
- Đăng nhập UI quản trị: M6 dùng chung JWT của M5; bên mình tự sinh cặp khoá + tự phát token (D-m6-027; Tài đề xuất chỗ sinh + người phát,
  Toàn duyệt, D-m5-052); token có `iat`, vai, exp − iat ≤ 30 ngày (D-m6-021); mỗi người một `sub`, thu hồi khẩn = đổi khoá công khai → cả khu
  M5 lẫn Quảng cáo cùng đăng xuất (D-m5-050); M6 vẫn kiểm vai từng route (D-m6-018).
  .98 kéo mã bằng deploy key chỉ đọc, đóng image theo commit (D-m6-019, D-m5-046); 18/11 Tài báo khoá đang có quyền ghi (TRK-93) → Toàn gắn lại.
  Tag `m6-l1-done` đã gắn ở `d7fe04e` (14/11, OWN-368) → deploy không còn dừng mã 11.
- Phiên mở ở Project Control không nạp `.claude/settings.json` của repo: tự giữ rào bí mật và `04-artifacts/state/`.
- `TRACEABILITY.md` là tệp sinh, không sửa tay. Quy trình nhiều cửa sổ vai cũ là lịch sử (`_archive/pack-v1/`, DL-040).

## Lệnh (chạy trong `C:\Projects\module5\m6`)

- Test: `python -m pytest -p no:cacheprovider -q`; ca Postgres cần `M6_PG_TEST_REQUIRED=1` + DSN Postgres 16 tạm.
  Lead kiểm lại bằng container tạm python:3.12-slim + postgres:16.
- CI theo phần chạm tới (`module5/CLAUDE.md` §6): chạm `m6/` ⇒ trong `m6/` chạy `scripts/ci_local.py`, đạt `CI_LOCAL n/N` (n = N);
  chạm ngoài `m6/` (kể cả `web/`) ⇒ ở gốc chạy `node scripts/ci-local/run.cjs`, đạt `GATE=ĐẠT`; chạm cả hai ⇒ cả hai.
- Tài liệu: `python docs/_tools/check_docs.py --warn`, `python docs/_tools/gen_traceability.py --check`.

## Kế hoạch (nguồn chính)

`m6/docs/04-sdlc/SPRINT_PLAN_2026-11-15.md` v1.6 (UI quản trị §4.15); `m6/docs/04-sdlc/GO_NO_GO_2026-11-13.md`; `ROADMAP.md` giữ lát L0–L8.
- **Hạn chạy thật 30/11/2026** (D-lead-025). 15/11 là mốc giữa kỳ, không còn là đích release của M6.
- **Go/No-go** họp 2 ngày làm việc sau khi `mkt.` trên .98 có HTTPS (có từ 17/11 ~16:3x → 19/11), **chậm nhất 20/11**; release M6 theo Go/No-go (D-m6-013, D-m6-015).
  Lịch phía Tài (OWN-342, 12/11): Go/No-go 20/11, chuẩn bị production 26–27/11, chạy thật 30/11.
- Không theo dõi quỹ giờ trong sổ/báo cáo của phiên (D-m6-001).
- Chưa nối M3 thật: doanh thu/ROAS null kèm lý do; client ops-core thật tắt tới khi đủ ca chấp nhận (DL-052).
- Hiện trạng cho người mới: `m6/docs/07-hien-trang/README.md`.

## Danh mục kiểm khi rà soát

- PR phần M6 gộp bằng merge commit, không squash; commit báo xong phải có trên `origin/main`.
- Migration đánh số tuần tự trong `m6/migrations/`: hai nhánh song song cùng tạo một số — kiểm trùng.
- Cờ an toàn giữ nguyên; `m6/04-artifacts/state/` không đổi; không có `m6/M6/` hay nội dung CH21 trong `module5`.
- Mỗi quyết định kỹ thuật mới có dòng DL; DL do PM chốt chạm phạm vi pilot, Go/No-go, dữ liệu khách, bảo mật → Cần sửa
  ("cần Tài hoặc Lead chốt"); DL kỹ thuật PM chốt có nguồn thì không bắt lỗi.
- Task chạm `web/` có `GATE=ĐẠT`; task chạm `m6/` có `CI_LOCAL n/N` đủ.

## Kiểm đầu phiên

- `python "C:\Projects\Project Control\tools\git_tong_quan.py" --fetch m6` (module5 `main` so `origin/main`); PR M6 (`m6/M6-*`) và check run trên đúng SHA.
  Không lấy số task DONE làm % sẵn sàng.
- `m6/docs/06-tracking/` (WORK_TRACKING, TRACKING_REPORT), Sheet `node "C:\Projects\Project Control\tools\sheet_lead.mjs" can-ra --module M6`,
  `m6/docs/00-overview/DECISION_LOG.md` 10 dòng cuối.
- Sổ Tài `C:\Projects\M4-PLAN`: fetch, so HEAD/remote; đọc báo cáo đầu ngày và OWNER_DECISIONS mới.

## Rà soát (`/ra-soat tai`)

Theo bước đồng bộ của `.claude/commands/ra-soat.md`: kiểm checkout `C:\Projects\module5` sạch, nhánh `main` theo dõi `origin/main`, không phiên
nào (kể cả `m5`) đang dùng, rồi `git -C C:\Projects\module5 pull --ff-only --no-rebase`; pull an toàn M4-PLAN; ghi kết quả/SHA trước/sau.
Chưa pull được thì giữ checkout và báo lý do; không tự checkout/stash/reset. Lấy toàn bộ task M6 Hoàn thành/Chờ review chưa Đạt từ Sheet,
ghim ID/SHA; chia auditor theo ID, kiểm tiêu chí/code/PR/DoD/test trong `m6/` và màn M6 trong `web/`. Ghép bảng, so tập ID không thiếu/lặp.
Rà xong chỉ có **Đạt** hoặc **Cần sửa** (thiếu bằng chứng = Cần sửa, D-m6-005); task Đạt không rà lại, task Cần sửa chưa được Tài cập nhật thì chờ.
Ghi W/X bằng `node "C:\Projects\Project Control\tools\sheet_lead.mjs" ghi`, công cụ tự đọc lại; không mở trình duyệt.
Task Tài: chỉ W/X. Task Lead/Nguyễn Quốc Toàn trong M6: H/J/W và nối X theo D-lead-011.
Kết luận task không thay quyền triển khai/mở cờ production. Mặc định soạn tin nháp, không tự gửi.
Test trong worktree tách rời `C:\Projects\_wt\m6\review-<tên>` (detached), xoá sau khi xong.

## Báo cáo tuần

Bước 2 cho `M6-do-luong-quang-cao` — `/bao-cao-tuan`. D-m6-001: bản rà đối chiếu số liệu, không trả lại báo cáo và không soạn tin trừ khi bạn yêu cầu.
