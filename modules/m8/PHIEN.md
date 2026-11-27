# Phiên `m8` — M8 IVR gọi xác nhận đơn (Lead tự code)

## Repo

- `C:\Projects\ginsengfood-ivr`, **chỉ nhánh `main`**; `git push origin main` đẩy cùng lúc GitLab và GitHub (push chỉ khi Lead bảo).
- Dịch vụ .NET 10 độc lập (SDK 10.0.201): `src/Ivr.{Api,Worker,Infrastructure,Domain,Contracts,MediaReceiver}`; test
  `tests/{Unit,Integration,Contract,MediaReceiver}` + `tests/chaos`. Không có màn hình vận hành — M3 làm màn hình.
- Tổng đài: Asterisk trên máy `.64` (`deploy/telephony-s5`, `telephony-vm`) nối trunk SIP MobiFone; ứng dụng M8 chạy trên `192.168.1.99` (D-lead-035–038, [bảng máy](../../chung/MAY_CHU.md)). Khi chưa có máy thử, kiểm M3 ↔ M8 trên .99 (D-lead-065).
- Hợp đồng hiện hành với M3: `specs/api/openapi/ivr-order-confirmation.v1.yaml` draft.47 (`main` `680508c7`, 16/11; .99 còn chạy draft.45 tới khi `deploy_m8_99`) + `order-core-ivr-callback.target-v1.yaml` + IR-06/07/08. M8 **không** dùng `ginsengfood-contracts`; baseline draft.44 ghim hash vẫn giữ nguyên.
- Nhánh chú Dũng (`github/chudung/m8-*`, D-lead-051): rà, sửa cho xanh, gộp `main` (tua nhanh + một commit W của Toàn ở đầu để cổng `tts-provenance` thấy tác giả HEAD có trong `m8-builders.json`), giữ luật chú.
- Lead đang tự xử lý M3 → M8 ở phiên m34; phiên m8 chỉ đọc để biết, không chủ động soạn/gửi gói hợp đồng hoặc theo việc phía M3 (D-m8-008).
- D-m8-012: lấy JSON tỉnh/thành phố và phường/xã từ repo M3 chỉ đọc, ghim nguồn mới tại M8 và giữ namespace mã nội bộ M3 (không ghép mã hành chính trùng số); không sửa tích hợp M3 hoặc dùng nguồn mới để tự xác nhận audio L26 cũ.
- D-m8-010: dùng máy chạy app M8 (`.99`) tạm cho khóa/bí mật LAB; không dùng custody production làm việc chặn code/lab. Kho khóa/người giữ/khôi phục production chốt trước bước cấp production và release; không tự đổi register/cờ gọi thật.

- D-m8-011: m8.13 A đã chốt hướng ngoại lệ cụm hai host (.99/.64); WP07D khai chi tiết. Giữ cổng/health thật, file secret và migration job riêng; chưa đóng G5 hoặc cấp quyền deploy.

## Luật repo phải nhớ (`CLAUDE.md` = `AGENTS.md`)

- **Chỉ `main`.** Cấm mọi lệnh tạo nhánh và **mọi dạng `git worktree add`**. Git hook `.githooks/reference-transaction`, `pre-push`
  vẫn chạy; `.claude/settings.json` và hook `no-new-branch.sh` của repo **không** chạy khi phiên mở ở Project Control → tự giữ luật.
  Không tắt hook.
- GitNexus bắt buộc: `impact` trước khi sửa symbol, `detect_changes` trước mỗi commit.
- Tracker: phiên chính chạy `node tools/task-tracker/sheet-sync.mjs log --id M8-NNN …` sau mỗi lệnh có chạm repo (subagent không chạy).
  Mã việc nội bộ `W-NNNN` (số tiếp theo ở `docs/release/work-register.md` §2) — chỉ phiên chính cấp số.
- **Không chạy script máy thật** (`s5v4_host.py`, `run_lab.py`), không chạm trunk, `REAL_CUSTOMER_CALL_ALLOWED` luôn `NO`.
  Mọi việc trên `.99`/`.64` cần Lead (và anh Tuấn mở sudo/khung bảo trì).

## Lệnh

- Cài: `pnpm run setup` (không phải `pnpm setup` — đó là lệnh có sẵn của pnpm) · Build: `dotnet build Ivr.sln --configuration Release --no-restore`
- Test: `dotnet test Ivr.sln --configuration Release --no-build` (cần Docker cho Testcontainers)
- Cổng: `npm --prefix deploy/ci ci` rồi `node deploy/ci/scripts/gate-sweep.mjs` (Git Bash) · PII: `sh deploy/ci/scripts/scan-pii.sh docs/evidence`
- Chạy local: `pnpm local:prepare` → `pnpm dev:bootstrap` → `pnpm api:dev` / `pnpm worker`; `pnpm e2e:mock`; `pnpm sandbox:up`
- **Cổng cố định: API 5005, Postgres 55433**; tên container/compose project dùng chung → chỉ một agent chạy compose mỗi lúc.

## Chạy song song: sửa thẳng trong checkout `main` (D-lead-063)

- ivr chỉ có `main` (hook cấm nhánh và `git worktree add`): phiên và agent của m8 sửa thẳng trong `C:\Projects\ginsengfood-ivr`, khai khoá `tools/khoa_tep.py`, phiên chính commit theo đường dẫn vào `main` tuần tự (`CACH_LAM.md` §3); chạy `detect_changes` + test trước khi commit. Không còn bản sao `git archive`.
- **Bước gitleaks khi ghép (D-m8-037):** sau commit local, trước push: clone `main` trong container `dotnet/sdk:10.0.201`, chạy
  `gitleaks-linux git --config .gitleaks.toml --redact --log-opts="<cha>..HEAD"` và `--log-opts=HEAD` (như CI) — cả hai 0 mới được trình push.
  Nhị phân đã kiểm checksum 8.30.0: `C:\Projects\_wt\m8\ci-sec-job\_log\gitleaks-linux`; script mẫu `C:\Projects\_wt\m8\prep-w0501\gl\run.sh` (hai thư mục công cụ này GIỮ NGUYÊN, không phải bản sao, `tools/don_wt.py` không xoá).
  Có phát hiện thì sửa trước khi push (fingerprint chỉ cho giá trị đã chứng minh là sha256/giá trị giả, verifier kiểm).
- **Quét trước push (D-m8-055):** ngay trước mỗi lần trình push, chạy `deploy/ci/tools/pre-push-scan.sh` trên HEAD local
  (dựng image publish, trivy CSDL mới, `refresh-locks.sh --check`, PII trên `ci-artifacts`/`.artifacts/api-matrix` trong container Linux).
  Đỏ thì sửa trước (CVE mới → `refresh-locks.sh --write`), không trình push. Quét PII luôn trên cây commit/LF trong Linux: checkout Windows
  có `pii-patterns.txt` CRLF → PASS giả. Dựng lại lỗi CI thì `--no-cache` (cache Docker che lỗi kho gói).
  Runner GitLab dùng chung Docker máy này: không dựng image/chạy sweep nặng (phiên, verifier) khi còn container nhãn
  `com.gitlab.gitlab-runner.type` — 07/11 làm `governance` chậm gấp đôi và quá hạn gate (W-0512; công cụ nay tự chờ).
  Thêm tệp vào `deploy/ci/scripts/` thì khai trong `deploy/ci/gate-invocations.json` (W-0511); verifier chạy `gate-sweep`.
- Ba test chỉ đạt trên checkout chính (hai test `OpenApiDocument` cần `node_modules`, `ApiBehaviorMatrix` cần `.git`) → verifier chạy
  lại trên checkout chính sau khi đưa lô vào.
- Việc tài liệu/nhỏ: chế độ S, tệp tách nhau, không commit.
- **Tệp một người ghi (một WP/sóng):** tệp sinh `docs/traceability-tests.md`, `specs/database/02-tables.md`,
  `docs/release/gate-status.yaml`; bộ đếm `NEXT_WORK_ID`; migration + `IvrDbContextModelSnapshot.cs`; khối chung trong Helm
  `values.yaml`, `appsettings*`, `docker-compose.sandbox.yml`.
- **Tệp ghim hash — không sửa:** OpenAPI draft.44, ZIP r1/r2, IR-06 (ghim ở 9 chỗ), `ProviderPorts.cs`, bằng chứng bản ứng viên đã niêm
  phong, thiết lập LF trong `.gitattributes`.
- Chỉ mục GitNexus dùng chung: subagent chỉ đọc (`impact`, `context`), không `analyze`.

## Cách làm (D-m8-078, 11/11)

- Một mục tiêu đến 15/11: một đơn M3 → M8 → gọi MOCK → callback. Việc không chặn đường đó thì gác, không mở agent mới cho nó.
- Kiểm theo rủi ro: công cụ/tài liệu chưa chạy thật → coder viết, phiên chính chạy test một lần rồi ghép. Verifier độc lập chỉ khi chạm mã sản phẩm, cờ production hoặc bí mật.
- Sau vòng sửa thứ hai, còn lại chỉ là độ chặt của test hay việc không ảnh hưởng an toàn/sản phẩm → sửa tại chỗ hoặc ghép và ghi nợ; chỉ dừng báo Lead khi có lỗi an toàn/sản phẩm thật.
- Không push chỉ để bảo trì CI/CVE/gitleaks: gom theo ngày hoặc khi có thay đổi nhìn thấy được; bảo trì dồn sang lịch chạy đêm (m8.50).
- Báo cáo mở đầu bằng điều đã đổi trên .99 và nút thắt của lượt kiểm M3 ↔ M8 hoặc tổng đài .64. Tối đa 2 agent nền.

## Kiểm đầu phiên

- `git fetch --all --prune`; `status --short`; `log --oneline -10`; `worktree list` (worktree cũ `.claude/worktrees/hello-d01cf2` đã gỡ 02/11 theo D-m8-009; chỉ còn checkout `main`).
- `docs/release/readiness-board.md` (kiểm sau sóng2 ngày02/11 tại bản sao `055b9a9`: mức0/4;11cổng `BLOCKED_EXTERNAL`;482work items,121mục `EVIDENCE_SUBMITTED` chưa nghiệm thu).
- Báo cáo gần nhất trong `docs/reports/`; đối chiếu báo cáo tuần trong `C:\Projects\bao-cao-tuan\` và quyết định điều hành mới. D-m34-003 (02/11): Lead nhận M3 → M8, task M3-023 trên `toandeptrai`; lịch cũ 20–27/11 cần chốt lại, E01–E10 cần trước 06/11.

## Mảng khảo sát cho `/ke-hoach`

1. Chuyển sang chạy thật trên `.99`/`.64` (WP1) — `deploy/rollouts/production-window-20261027/` đang "PREPARED / NOT READY".
2. Tích hợp M3 (WP2) — callback, D-16, ca E01–E10, ký r2.
3. Nhà mạng + giọng đọc (WP3, WP4) — phần nào còn trong tay mình, phần nào chờ ngoài.
4. Sao lưu/DR (WP5) + nghiệm thu bằng chứng, `gate-status` (WP6).
Nguồn: `plan/ke-hoach-trien-khai-quy-trinh-goi-2026-09-30.md` §9–§11, `docs/release/readiness-board.md`, `docs/release/work-register.md`.

## Báo cáo tuần

D-m8-107 (D-lead-045, 14/11): phiên m8 **không** tự viết báo cáo tuần theo prompt 1 nữa (prompt `tools/task-tracker/bao-cao-tuan/prompt-1-Lead-M8-ivr.md` chỉ còn để tham khảo). Khi phiên `lead` hỏi qua tin nhắn phiên → trả dữ kiện ≤ 30 dòng kèm SHA/tệp: đã làm · còn lại tới mốc gần nhất và 30/11 · kế hoạch tuần tới · khó khăn + cách giải quyết · việc CHƯA CHẠY.
