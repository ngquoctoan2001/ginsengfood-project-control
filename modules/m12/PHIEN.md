# Phiên `m12` — M1–M2 Operational Core (Lead tự code)

## Repo

- `C:\Projects\ginsengfood-ops-core`, **chỉ nhánh `main`** (remote `origin` GitHub + `gitlab`, cùng SHA).
- .NET 10 (SDK 10.0.201, một API kèm Worker), Postgres 18 (151 migration EF), Redis 8.8, 3 app Next.js 16, pnpm 11.3, GitLab CI.
- Phạm vi: dữ liệu gốc, công thức G1/G2+, lệnh sản xuất, xuất nguyên liệu, QC và phát hành, kho, truy xuất và thu hồi, QR/GS1,
  biểu mẫu vận hành FRM-01…30, cầu nối MISA.
- Repo có sẵn hệ agent riêng: `.claude/agents/` (16 vai: `operational-implementer`, `operational-reviewer`, `judge-gate`,
  `database-integrity`, `security-compliance`, `release-readiness`, `qa-testing`…), `.claude/commands/` (`verify-change`,
  `database-migration`, `flow-fix`…), `.claude/rules/`. Khi giao việc chuyên sâu, dặn subagent đọc tệp vai tương ứng trong repo
  làm hướng dẫn nghề (ví dụ migration → `.claude/agents/database-integrity.md`).

## Luật repo phải nhớ (đọc lại `CLAUDE.md`, `AGENTS.md` khi lệch)

- **Cấm tạo nhánh, cấm worktree có nhánh** (OWNER-DIRECTIVE-2026-09-05-SINGLE-MAIN). Git hook `.githooks/reference-transaction`,
  `pre-commit`, `pre-push` vẫn chạy (`core.hooksPath=.githooks`); còn `.claude/settings.json` và `tools/git/block-branch-commands.mjs`
  của repo **không** chạy khi phiên mở ở Project Control → tự giữ luật. Checkout tách rời chỉ để đọc/build/test một SHA của `main`.
- Stage bằng `tools/git/Stage-BoundedPaths.ps1` hoặc `git commit -- <paths>`; cấm `git add -A`. Index dùng chung: commit không kèm
  đường dẫn sẽ cuốn cả tệp phiên khác đã stage.
- Conventional Commits. GitNexus `impact` trước khi sửa symbol; không chạy `gitnexus analyze`.
- Không tự tạo plan/handoff trong repo. Migration lên DB dev local + chuỗi seed hai lần: luật repo bắt agent tự làm; ở chế độ S
  chỉ **phiên chính** làm, một lần cuối sóng (subagent dùng Testcontainers riêng).
- Tắt tiến trình mình bật; `dotnet build-server shutdown` chỉ phiên chính chạy, cuối sóng.
- Tracker: phiên chính chạy `node tools/task-tracker/sheet-sync.mjs log --id M12-NNN …` một lần sau mỗi lệnh Lead có chạm repo.
  Từ `d70b3cc95` (02/11) lệnh này còn ghi thêm vào `docs/weekly-tracking/nguyen-quoc-toan.md` → commit tệp đó cùng mã (theo đường dẫn).

## Lệnh

- Cài: `corepack pnpm install --frozen-lockfile` · `pnpm run restore`
- DB local: `pnpm run docker:postgres:up` → `pnpm run db:init` → `pnpm run db:update` → `pnpm run db:seed:clean-ops`
  (Postgres 55432, Redis 56379)
- Build/test: `pnpm run dotnet:build` · `pnpm run test:backend:unit|integration|api-contract|schema-smoke|governance` ·
  `pnpm run typecheck` · `pnpm -r --if-present run test` · cổng đủ: `pnpm run check`
- Đổi route/DTO → `pnpm run api:sync`.
- Cỡ bộ test: Unit ~7.500, Integration ~1.560, admin Vitest ~4.900.
- **Cổng Lead đang dùng: API 5100, admin-web 3000 — không đụng.** Lab UAT: 5200/3200/5299 và 5202/3202.

## Chạy song song: chế độ S (chung checkout)

- Subagent sửa tệp tách nhau trên checkout `main`, **không commit**. Phiên chính commit tuần tự từng WP theo đường dẫn, chạy kiểm
  sau mỗi commit có rủi ro. Mẫu brief đã dùng: `.artifacts/agent-briefs/00-shared-rules-and-contract.md` (4 agent, 27/10).
- **Không sửa mã trong worktree tách rời** (`AGENTS.md:12` "không tự tạo worktree để implementation"; sóng 31/10 đã làm sai ở WP01/02/05,
  kết quả đã về `main` theo đường dẫn). Worktree tách rời chỉ để verifier/tester chạy build/test một SHA đã commit.
  Worktree kiểm mới có submodule `ginsengfood-contracts` **rỗng** (thiếu → ~110 test hỏng giả): brief verifier dặn clone tạm từ
  `C:\Projects\ginsengfood-contracts` đúng commit ghim (`git submodule status`), xoá sau khi kiểm; `pnpm install --frozen-lockfile --prefer-offline`.
- Lane script CI (`Run-TestSuiteLane.ps1`/`Run-DotNetTests.ps1`) đòi `docker info` < 3 giây, máy này 3–6 giây → test DB dùng đường
  `.database-env` của CI (`tools/ci/Initialize-CiDatabase.ps1`/`Stop-CiDatabase.ps1`, postgres dùng một lần, cổng ngẫu nhiên).
- Build .NET song song: mỗi agent `--artifacts-path .artifacts/dotnet/<WP>` + `--disable-build-servers`; không chạy lane script.
- Test có DB: mỗi agent Testcontainers riêng (`REQUIRE_DATABASE_BACKED_TESTS=1`, bỏ `TEST_PG_*`); không chạy Integration lên DB dev 55432.
- Next.js: mỗi agent `NEXT_DIST_DIR` riêng.
- **Mỗi sóng tối đa một WP chạm migration** (`AppDbContextModelSnapshot.cs`, `db/migration-contracts/live-migration-inventory.json`,
  allowlist `Validate-P01Schema.ps1`, ratchet baseline).
- Tệp nóng khác (một WP/sóng): `ApiErrorCodes.cs`, `OperationalPermissionCatalog.cs`, `AppDbContext*`, `IdempotencyKeyTransformer`,
  `StateTransitionRegistry`, `db/seeds/02_roles_permissions.sql`; tệp sinh `packages/api-contracts/openapi.json`,
  `apps/admin-web/src/lib/api/generated/types.ts`, `tests/contracts/*.fixture.json`, `deploy/seed/production-seed-manifest.sha256`,
  `db/validation/profiles/*.json`. Governance giới hạn tệp < 800 dòng và đếm số tệp.

## Kiểm đầu phiên

- `git fetch --all --prune`; `status --short`; `log --oneline -15`; `worktree list` (có vài worktree tách rời cũ dưới `.artifacts/` và ổ `G:`).
- Index dùng chung: `git diff --cached --name-only` trước mọi commit; có tệp stage lạ → hỏi Lead (31/10 10:59: 0 tệp stage).
- Hạn các ngoại lệ bảo mật trong `tools/ci/*-decision.json`, `*-renewal-*.json` (`expires_at_utc`).
- Nhật ký UAT `docs/evidence/27-10-14-30-uat-chay-nhanh/RESUME.md` (gitignored) — chỉ đọc phần cuối.
- Sheet `node tools/task-tracker/sheet-sync.mjs list --module M12`.

## Mảng khảo sát cho `/ke-hoach`

1. Cổng phát hành + bảo mật: CI trên đúng SHA, SAST, HTTPS/DAST, nguồn gốc bản build; ngoại lệ JWT hết hạn 31/10 08:15.
2. Đưa bản ứng viên lên **.99** (máy chủ chính thức từ 13/11, D-lead-035/036; `.61` chỉ còn đường lui; phiên phụ `m12 phụ · chuyển M1–M2` cắt 13/11 22:30–23:00): migration trên bản sao trước, sao lưu/khôi phục, chạy thử nhanh; 55 sự kiện outbox chết; sửa reserved-20.
3. UAT còn lại (~944 ca) + tính năng trước khi bán (C37 giữ → tiêu hao, in thật, hợp đồng enum chết, MISA HTTP client).
4. Tích hợp M3 (11 ca hợp đồng, biên nhận phía tiêu thụ, thay khoá) + dữ liệu thật cho thí điểm + tài liệu đào tạo.
Nguồn: `docs/reviews/19-10-11-37-pilot-g1-local-readiness-review.md` §23.64, `docs/reports/24-10-06-06-bao-cao-tien-do-module-1-2.md`,
`docs/runbooks/release/go-live-cutover-plan.md`, `13-08-21-04-production-manual-acceptance-checklist.md`, `docs/plans/27-10-14-45-uat-chay-nhanh-1987-ca-plan.md`.

## Báo cáo tuần

D-m12-064 (D-lead-045): phiên m12 KHÔNG tự viết báo cáo tuần nữa. Phiên `lead` lập báo cáo của Toàn (`/bao-cao-tuan toan`); khi phiên lead
hỏi qua tin nhắn phiên, trả dữ kiện ≤ 30 dòng kèm SHA/tệp: đã làm · còn lại tới mốc gần nhất và 30/11 · kế hoạch tuần tới · khó khăn + cách giải quyết · CHƯA CHẠY.
