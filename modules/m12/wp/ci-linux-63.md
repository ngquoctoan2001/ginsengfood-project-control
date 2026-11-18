# ci-linux-63 — Chuyển CI ops-core từ runner Windows sang container Linux trên may-63 (D-lead-040)

Trạng thái: XONG 16/11 17:24 (pipeline main #3072542878 xanh trọn trên may-63, `668b29e0d`; deploy-99 chờ Toàn bấm) · Rủi ro: R2 (CI/CD, không đụng mã app) · Chế độ: S (phiên phụ, sửa trên `main`) · Mốc: gỡ chặn deploy-99 / 15/11
Hạng mục nâng: H9 Cổng phát hành (CI chạy được, không phụ thuộc máy Lead) · Sheet: CHƯA TẠO · Ước lượng: 1–1,5 ngày
Chỗ làm: checkout chung `C:\Projects\ginsengfood-ops-core` `main` (thử trên .63 `/home/ssv/dev/`) · Base SHA: `77cd91d93` (origin/main 14/11)

## Brief
1. Repo `C:\Projects\ginsengfood-ops-core`, nhánh `main` (PHIEN.md: không nhánh/worktree làm mã). Phiên chính đang làm cùng checkout → chỉ `git add` đúng đường dẫn.
2. Khi xong: một pipeline `main` của ops-core xanh trọn trên runner `may-63` (tag `ops-core-linux`), gồm `build-images` (5 image lên GitLab Registry);
   `deploy-99` vẫn chạy được; thời gian chạy so với Windows ghi ở đây. **D-m12-060 (14/11 13:09): không chạy CI trên máy Windows của Lead nữa,
   không còn đường lui `ops-core-win`**; pipeline đầu cho `deploy-99` cũng chạy trên `.63`; phiên lead được nhắc tạm dừng `ops-core-win` ngay.
   Không push `main` khi `.gitlab-ci.yml` trên remote còn tag Windows mà runner chưa tạm dừng (push sẽ đẩy job về máy Lead).
3. Phạm vi ghi: `.gitlab-ci.yml`, `tools/ci/**`, tài liệu CI, test ghim CI (`tests/security/*CI*`, M12CD01/02, OPS10…). Không sửa mã app, không đụng tệp dở của phiên chính.
   **Trừ tệp WP20 (phiên chính, D-m12-061):** `tools/ci/verify_historical_jwt_source_disposition.py`, `tests/security/test_historical_jwt_source_disposition.py`,
   hồ sơ ngoại lệ JWT. Dòng nào của job `historical-jwt-source-receipt-preview` trong `.gitlab-ci.yml` WP20 cần đổi, phiên chính gửi đoạn sửa để phiên phụ gộp vào đợt push.
4. Đọc trước: `.gitlab-ci.yml`; CI M8 mẫu trên cùng runner `C:\Projects\ginsengfood-ivr\deploy\ci\ci.gitlab-ci.yml` (sdk + `docker:29.6.2-dind`, `DOCKER_HOST=tcp://docker:2375`, `TESTCONTAINERS_HOST_OVERRIDE=docker`);
   kế hoạch máy dev `modules/lead/may-chu/2026-11-14-ke-hoach-may-dev-63.md`.
5. Thử: từng job bằng đúng image trên .63 (`docker run … pwsh tools/ci/…`) trong `/home/ssv/dev/`; không thử bằng push liên tục. Trên .63 cấm `docker … prune`, cấm đụng `stg_*`.
6. Push: gom một đợt, hỏi Toàn một câu kèm tóm tắt. Không tự chạy lại pipeline khi Toàn chưa cho (tin lead 14/11 ~10:30).

## Dữ kiện (14/11)
- Runner `may-63` (#59199848): docker executor, privileged, 1 job/lúc, dùng chung với CI ivr. Máy .63: 10 nhân, 38 GB, Docker 29.1.3, đĩa trống 397G.
- Image có sẵn trên .63 (digest): `mcr.microsoft.com/dotnet/sdk:10.0.201@sha256:127d7d4d601ae26b8e04c54efb37e9ce8766931bded0ee59fcd799afd21d6850`
  (Ubuntu 24.04, pwsh 7.6.0-preview.4, git, curl; KHÔNG có node, pnpm, docker CLI, psql, python3) · `docker:29.6.2-dind@sha256:bfec1f5159c63a81ca6fdedbd81404d2c0e16378ed0feec3bb3fbf3998847659`
  · `node:22-bookworm-slim@sha256:c3de60bf2f9dd0ac6370e6117950ff62d6e339527e7472301c9c78a017978392`.
- Repo: `global.json` SDK 10.0.201 (latestPatch); `packageManager` pnpm 11.3.0.
- CI Windows hiện tại: 1122 dòng, 24 job, 35 lần `powershell -File`, 31 tệp `tools/ci/*.ps1`. Job `historical-jwt-source-receipt-preview` đã chạy Linux SaaS.
- Gốc đỏ CI cũ (chẩn đoán 14/11 sáng, xem `chuyen-may-99.md`): Docker Desktop máy Lead tắt; job JWT chỉ xanh ở pipeline chạy tay có `OPS10_JWT_SELECTED_SOURCE_SHA`; ngoại lệ JWT hết 15/11 16:59Z (WP20).

## Khảo sát (subagent Explore, 14/11; điểm then chốt phiên đã tự kiểm)
- Mọi script inline là PowerShell; docker executor chạy sh/bash → mỗi dòng phải thành `pwsh -NoProfile -File …` (khối inline dài chuyển vào `.ps1`). Không cần sửa config runner.
- CSDL test: `Initialize-CiDatabase.ps1` publish `127.0.0.1::5432` và ép regex `127.0.0.1` (L26, L41); `tools/db/LocalDb.Common.ps1` L56/L186 chỉ nhận host `127.0.0.1`/`localhost`
  → dưới dind phải publish trong dind và nối host `docker`, nới chốt chặn có điều kiện CI. Lane Integration luôn cần Docker API (Testcontainers Redis/Postgres riêng).
- `Initialize-CiToolchain.ps1` L23 PATH dùng `;`; cần `psql`. `Invoke-OpenApiContractGate.ps1` L26 gọi `powershell`; `export-openapi.ps1` `Start-Process -WindowStyle`.
- `Publish-M12ReleaseImages.ps1` L348-358, `Invoke-M12Deploy61.ps1` L104-120 dùng ACL Windows (thay `chmod`); ssh mặc định `System32\OpenSSH\ssh.exe`.
- Khâu bảo mật: semgrep/trivy/syft/cosign/zap do runner Windows cấp qua `OPS_CI_TOOLCHAIN_ENV` (bản Windows, ghim sha256) → cần bản Linux + ghim mới; `security-powershell-scan` dùng `C:\Windows\System32\curl.exe`;
  DAST chỉ chạy Windows (kernel32 Job Objects).
- Pester tầng static (job `build-images` cần): ~9 spec phụ thuộc Windows (CI04, CI05, CBH, DB17, M12CD01, M12CD02, OPS10.Opengrep/SourceScanner/HistoricalSecret: PS 5.1, `csc.exe`, `bash.exe`, `taskkill.exe`, npipe).
  Test ghim nội dung CI: M12CD01/02, OPS10.*, CI05, DEV01, OPS0212, OPS009, 3 test .NET Governance; `CI01` đòi mọi `.ps1` vẫn parse dưới PS 5.1.
- `preflight-summary` cần MỌI job test + bảo mật xanh → `build-images` chỉ chạy khi toàn bộ xanh.

## Diễn biến (mỗi vòng một dòng, mới nhất ở cuối)
- 14/11 11:0x Nhận việc (tin phiên Lead fork). Khảo sát CI (subagent đọc), kiểm .63 + image. Trình Toàn phạm vi + m12.c6/c7.
- 14/11 11:42 Toàn chọn c6 B (chuyển hết một lần), c7 A (cài công cụ ghim sha256). Nền CI Linux đã sửa; 9 job đầu ĐẠT trên .63.
- 14/11 13:00 Phiên mở lại (đổi tài khoản). Engine + luật SAST đọc được ở bộ cũ (không cần admin) → trình lại c8. Sửa 4 gốc đỏ nhỏ; 2 subagent làm 14 suite Pester static + launcher Opengrep Linux.

## Bước kế tiếp chính xác
16/11 17:24: XONG. Pipeline tay #3072542878 (web, `668b29e0d`, có OPS10_JWT_SELECTED_SOURCE_SHA) xanh trọn 13/13 job (12 trên may-63 + JWT trên SaaS), 2 giờ 29 phút tới build-images (Windows/cấu hình cũ ~4 giờ 20). Đã báo Phien M12 (M12-103/104 → Hoàn thành) và phiên lead. Việc còn lại: Toàn bấm `deploy-99` khi muốn. Sửa CI về sau: producer/verifier JWT và .gitleaksignore ghim chéo, đổi một tệp phải đổi pin.

## Còn lại / CẦN QUYẾT
- **m12.c11 ĐÃ CHỌN (D-m12-078, 16/11):** giữ pipeline một tầng, 23 job .63 còn 12 (source-boundary, backend-core, frontend gộp; preflight/runtime-summary giữ riêng), push mới huỷ pipeline push cũ, runner 2 job/lần (5 CPU/12 GB, lead-nen-99 đổi) → ~2h10–2h30 thay ~4h20. `f1eb28bfc` (verifier ĐẠT) + `668b29e0d` theo dõi (m12) ĐÃ PUSH 16/11 14:06 (Toàn duyệt); pipeline push #3072410182 chạy cấu hình mới; SHA pipeline tay JWT = 668b29e0d (m12 tạo sau khi hỏi Toàn). #3072410182 bị huỷ (Toàn lệnh), pipeline tay #3072542878 XANH TRỌN 16/11 17:23, 2 giờ 29 phút. Chi tiết `wp/ci-rut-gon.md`.
- m12.c10 ĐÃ CHỌN A (D-m12-066): ApiContract 75 phút, Integration 150, job 180 — commit d29552824 đã push. Chia lane + runner nhiều job để sau 15/11 nếu cần.
- m12.c8 ĐÃ CHỌN A (D-m12-059): engine + luật ở .63 `/home/ssv/dev/gitlab-runner/tools/opengrep-1.30.0-gf17/` (đã đặt, chỉ đọc), runner gắn `:/opt/gfops-sast:ro` — runner đã gắn (lead-nen-99, 13:10, kiểm chỉ đọc).
- `pwsh` trong image SDK là bản preview 7.6.0-preview.4 (mặc định: dùng luôn, ghi chú; đổi nếu gặp lỗi).
- Job JWT: WP20 gia hạn tới 30/11 đã vào main, nhưng verifier đỏ `RECEIPT_BINDING` trên pipeline tay 14/11 — Phien M12 sửa.
- Gỡ deploy-61 XONG (D-m12-069, `c3e22f752`); bỏ mặc định `.61` trong Invoke-M12Deploy61.ps1 để sau.
