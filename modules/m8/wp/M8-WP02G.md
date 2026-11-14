# M8-WP02G — Đưa M8 trên .61 về khuôn `~/m8` (CI → kho image → `trien-khai.sh`)

Trạng thái 09/11 18:47 +07: **ĐẠT deploy LAB .61 và diễn tập quay lui đổi container**. Source `140bcb48a27e9dcda947243a965a85b29f41a519` (W-0517), pipeline3044094922/job17860367945 PASS; 10 dịch vụ đúng image, 3 endpoint200. Rollback thử đã về140, hậu kiểm đầu metrics curl7 rồi kiểm lại đầy đủ đạt;4 tag thử đã gỡ. [Kết quả](../ra-soat/2026-11-09-deploy-m8-61-ket-qua.md), D-m8-065/066 · Rủi ro R3 · Chế độ A. .64/candidate02F/production còn ngoài phạm vi; giữ readiness47%, M8-002 IN_PROGRESS.
Hạng mục nâng: Cài bản thật .61/.64 — điều kiện cho 02F; tự nó không nâng % cho tới khi chạy trên .61 và quay lui thử đạt · Sheet: M8-002
Ước lượng: 10 giờ công AI (5 coder + 2 tester độc lập + 2 verifier + 1 parent kiểm kê/ghép) + dừng ngắn .61 ≤ 10 phút; dự toán.
Chỗ làm: `C:\Projects\_wt\m8\m8-wp02g` (goc `8eb33a5`), tester `m8-wp02g-tester` — đã dọn 21:14, patch/log ở `prep-w02g\` · Base: `caaa8f65` · Kiểm kê: `C:\Projects\_wt\m8\prep-w02g\kiem-ke-61.txt` · Nguồn: D-m8-023 / D-lead-019, `hop-thu/m8-2026-11-03-cung-khuon-m12.md`.

## Hiện trạng (3 scout chỉ đọc, 03/11)

- Runner: máy Lead **có** `ivr-docker-winhost` (docker, privileged, limit 1, tag `ginsengfood-docker`) cạnh `ops-core-win` (shell Windows, không chạy được dind) → không cần bật `ops-core-win` cho ivr. Online trên GitLab: CHƯA KIỂM (repo riêng tư, máy không có `glab`).
- CI: chỉ `publish_images` đẩy kho (api/worker/migrate, nhãn `0.1.0-<sha ngắn>`, `CI_JOB_TOKEN`, trivy). Helm/k8s: `k8s`, `cd` (deploy_dev/staging), `promote`, `observability_helm`, `tts-helm` + selftest tương ứng.
- .61 chạy 4 project: `ivr-m3-s5` = `docker-compose.sandbox-m3.yml` (8 dịch vụ, `pull_policy: never`, env/bind ở `./private`, `./bank`); `ivr-telephony-s5` sinh bởi `prepare-s5.py` (build tại chỗ); `ivr-ari-link-app` **không có trong repo**; prometheus `deploy/operations/prometheus/compose.json`. `ops_agent.py` chạy systemd (cần docker.sock cho `run`).
- Mẫu `~/m12/trien-khai.sh`/`compose.yml` chỉ có trên .61, CI ops-core chưa có build/push/CD → M8 tự dựng theo mô tả D-lead-018.
- `window.py` (02F) đang coi production là **project riêng** 9443, `/srv/ivr-production`, `$HOME/ivr-window-<c12>` cạnh S5 → lệch khuôn một `~/m8` (m8.23).
- Tên cũ ghi cứng: `operations/settings.example.json`, `readiness/host61.current.json`, `backup/capture-app61.example.json`, `telephony-s5/verify-s5.py`, `telephony-vm/l34/*.py`, `operations/migration/host_profile.py:58` (thuộc toolset 07B đã niêm phong).

## Brief

1. Repo `C:\Projects\ginsengfood-ivr`, chỉ `main`; coder làm trên bản sao `git archive` ở chỗ làm, phiên chính tạo commit `goc`. Không worktree/nhánh.
2. Khi xong: merge main → CI test → image `:<commit 40 hex>` lên `registry.gitlab.com/nqt20102001/ginsengfood-ivr/*` → job bấm tay
   `ssh ssv@192.168.1.61 ~/m8/trien-khai.sh <commit>` → kéo → sao lưu CSDL → migrate → `up --wait` → kiểm sức khoẻ → lỗi thì về bản trước. Tiêu chí:
   - a. `publish_images` nhãn `$CI_COMMIT_SHA`, đủ image `~/m8` có Dockerfile (api, worker, migrate, phrase-tts, asterisk S5, prometheus, ops-agent mới theo D-m8-025); giữ trivy + digest.
   - b. Bỏ include/job helm/k8s và sửa selftest liên quan; thư mục helm/k8s/rollouts chỉ xoá khi gate-sweep/test không cần, không thì ghi LỖI THỜI.
   - c. Job `deploy_m8_61`: manual, chỉ main, ghim `known_hosts`, khoá SSH qua biến CI có tên (Lead tạo), không in biến.
   - d. `deploy/m8/`: `compose.yml` project `m8` chỉ `image:` (volume `ivr-m3-s5_pg`, `ivr-m3-s5_phrases`, `ivr-telephony-s5_state` external; 8443 trên 192.168.1.61; asterisk `network_mode: host`; migrate ở profile), `.env.example` (chỉ tên), `trien-khai.sh`, `README` (bảng cũ → mới, cách cập nhật .64 hiện tại bằng `vm_deploy.py`).
   - e. `trien-khai.sh` từ chối commit sai dạng, ghi `PHIEN_BAN` (dòng đầu = đang chạy), `pg_dump -Fc` + `pg_restore --list` trước migrate, không lùi CSDL; lỗi bất kỳ bước nào → về dòng 2.
   - f. Test: unittest Python với `docker` giả (đạt/lỗi kéo/lỗi migrate/lỗi sức khoẻ/quay lui/commit sai), `bash -n` + `docker compose config` trong container Linux; đỏ trước khi sửa.
3. Ghi: `.gitlab-ci.yml`, `deploy/ci/**`, `deploy/m8/**` (mới), Dockerfile ops-agent (D-m8-025), tài liệu vận hành liên quan, `docs/evidence/W-NNNN/`.
   Cấm: `.env*`, `sheet.json`, OpenAPI/IR-06/baseline ghim hash, bằng chứng 07B/W-0495 đã niêm phong (kể cả `host_profile.py` → ghi danh sách cho 07B-L),
   `window.py` (thuộc 02F), WIP phiên khác trong checkout chính. Tệp nóng (work-register, gate-status, readiness-board): chỉ phiên chính.
4. Đọc trước: `hop-thu/m8-2026-11-03-cung-khuon-m12.md`, `hop-thu/m12-2026-11-03-dung-lai-61.md`, `docs/operations/gitlab-runner-winhost.md`,
   `deploy/ci/{cd,registry,images}.gitlab-ci.yml`, `docker-compose.sandbox-m3.yml`, `deploy/telephony-s5/prepare-s5.py`, `deploy/operations/{ops_agent.py,README.md}`,
   `deploy/operations/evidence/20261027/s5-v4/s5v4_host.py` (chỉ đọc để học bước sao lưu/quay lui), kết quả kiểm kê .61 của phiên chính (m8.25).
5. Được chạy: unittest/selftest CI cục bộ, `docker build` trong context Linux cô lập, `docker compose config`. KHÔNG: SSH/scp, push, chạy job CI thật, `s5v4_host.py`, `run_lab.py`, compose `up` trên cổng chung.
6. Bằng chứng: SHA nguồn, lệnh, số pass/fail/skip, đỏ trước, đột biến (bỏ sao lưu, bỏ quay lui, nhận commit sai), PII; không giá trị bí mật.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`. Parent giữ W-ID/tracker/GitNexus `analyze` (index stale `f14a6a2`) + `impact`/`detect_changes`.
8. Đầu ra ≤ 25 dòng: đạt/chưa xong/chặn, tệp đổi, bằng chứng, việc còn lại.

## Phần trên .61 (phiên chính; D-m8-065 cho hoàn tất chuẩn bị/deploy .61, còn thiếu quyền thực tế)

1. Kiểm kê chỉ đọc (D-m8-026): `docker compose ls`, `docker ps`/`inspect` (Env chỉ tên + sha256), compose ari-link, `IVR_*_IMAGE`, `IVR_MODELS_DIRECTORY`, bind mount, `systemctl cat ivr-operations*`, `crontab -l`, `df -h`.
2. Lead: deploy token chỉ đọc + `docker login` trên .61; khoá SSH cho CI (khuyên `authorized_keys` có `command=` chỉ gọi `~/m8/trien-khai.sh`); kiểm runner online.
3. Cắt (dừng ngắn, báo giờ trước): gắn nhãn image đang chạy → dựng `~/m8` cạnh → so hash env từng container cũ/mới → dừng 4 project + 2 unit → `up` project `m8`
   → so image/lệnh/env hash/mount/cổng, health, alias ARI, ops agent → `trien-khai.sh` cùng bản + quay lui thử → giữ thư mục cũ tới khi Lead cho xoá.
4. .64 không áp khuôn này (cần sudo); README ghi cách cập nhật hiện tại.

## Diễn biến

- 03/11 13:20 · Nhận `hop-thu/m8-2026-11-03-cung-khuon-m12.md`; 3 scout chỉ đọc; chọn gói riêng (khác phạm vi 02F, 02F phụ thuộc). Chưa tạo bản sao, chưa code, chưa SSH.

- 03/11 13:28 · Lead "ok 23A 24A 25" → D-m8-024 (một project `m8`, production nâng cấp tại chỗ), D-m8-025 (ops-agent vào compose), D-m8-026 (SSH chỉ đọc kiểm kê).

- 03/11 13:37 · Kiểm kê .61 chỉ đọc (D-m8-026), 1 lượt SSH, không ghi/sudo: 4 project + 2 unit như hộp thư; ARI asterisk nghe `172.29.0.1:18088` = gateway mạng `ivr-m3-s5_sandbox` → mạng phải giữ external; .61 chưa `docker login` kho nào; mẫu `~/m12/trien-khai.sh` đã chép. Thấy thêm: `.git-credentials` trong home ssv, cổng microk8s (16443/10250/25000) — ngoài phạm vi, báo Lead.
- 03/11 13:42 · Tạo bản sao (goc `8eb33a5`) + bản tester riêng; giao coder (A compose/env.mau/trien-khai.sh/README, B image ops-agent, C CI, D test) và tester độc lập (test hộp đen theo hợp đồng chung) chạy song song. W-0497 tạm.

- 03/11 14:26 · Phiên M8 khác (c46818) đã chạy coder/tester riêng trong cùng `m8-wp02g` và `m8-wp02g-tester` ~13:55–14:23 (commit `01d7745`, `2d0bef6`, có thể `d9764d7`) rồi dừng hẳn; D-m8-027 giao 02G cho phiên này. Đã báo coder/tester của phiên này nhận trách nhiệm toàn bộ diff từ goc, đổi biến `M8_DUONG_KIEM` → `M8_KIEM_TRANG` (scan-pii), ghi rủi ro allow-list nginx 8443 chỉ .60/.64 (kiểm từ .61 có thể 403 → thử trên máy lúc cắt).

- 03/11 · tester độc lập: 75 ca (47 trien-khai + 28 compose), tham chiếu xanh Windows/Linux, 29/29 bản hỏng đỏ; sửa regex `-Fc` hỏng của tester phiên kia (`ca55a0a`, `d682452`). Chạy trên coder `8ff9760`: 75 OK skip 4 (Windows).
- 03/11 · coder ĐẠT phần máy này, HEAD `8de74f03`: đỏ trước 35 (1F/34E) → 51/51 Windows/Linux/docker-cli; đột biến tay 7/7; cd-selftest IT-CD-01…09 PASS; build ops-agent OK; PII PASS. Xoá `k8s`/`promote` CI + `promotion-runtime*`. Cần quyết: 9 mã IT-CD đổi nghĩa; docker-cli Alpine thay bản Go có 12 HIGH; nginx 8443 allow-list; gọi thật NO/scheduler tắt ghi cứng compose.
- 03/11 · Đóng băng `8de74f03` (bản chụp `prep-w02g/snap-final`); giao verifier độc lập; phiên chính chạy bộ tester trên bản chụp Windows + Linux.
- 03/11 · Bộ tester trên `8de74f03`: Windows 75 OK skip 4, Linux 75/75. Verifier v1 CẦN SỬA: L1 VỪA (job CD `interruptible` + không trap → huỷ/đứt SSH giữa `up` không quay lui), L2 đọc `M8_BAN` trước flock, L3 thiếu test `create_host_path`, L4 README cắt chuyển; 19/20 đột biến bắt; cần quyết (a) ghim gói Alpine có thể 404, (b) IT-CD đổi nghĩa, (c) NO/lịch gọi ghi cứng. Giao coder vòng 2 hẹp L1–L4.

- 03/11 · Coder v2 `b171827` (L1 `13b7d65`, L2 `56f0848`, L3 `28c02a8`, L4 `41cee01`): 64 OK Windows/Linux. Tester độc lập trên `b171827`: Windows 75 OK skip 4, Linux 75/75. Verifier v2 **ĐẠT** (29/31 đột biến; nợ NHẸ N03 `exec </dev/null`, N10 giữ 30 nhật ký, không thời hạn tổng). **CHỜ KIỂM — chờ Lead** m8.28–m8.31 ở [diff R3](../ra-soat/2026-11-03-02g-diff-r3.md).

- 03/11 21:01 · Lead "ok 28 29A 30A 31A" → D-m8-030 (ghép, không push), D-m8-031 (nợ nhẹ làm lượt R2 sau ghép, trước cắt), D-m8-032 (giữ ghim docker-cli Alpine + runbook sửa lock), D-m8-033 (IT-CD giữ số, nghĩa mới).
- 03/11 21:14 · Ghép local `1bc8ee6d` (cha `caaa8f65`): 261 tệp trùng byte `e728d55` (10 tệp chỉ khác CRLF→LF theo autocrlf main), 4 tệp xoá; private index đúng allowlist 268 đường dẫn; W-0497 vào work-register (NEXT W-0498), gate-status/readiness-board 485 work items PASS. Kiểm trên main: `bash -n` OK, `deploy/m8` 64 OK skip 1, bộ độc lập 75 OK skip 4, cd/ci-config/docs selftest PASS, PII PASS, MANIFEST 236/236. `k8s-selftest` lỗi do máy thiếu image `ivr-api:p7-1` (W-0497 chỉ sửa chú thích); traceability lệch trên main do test chưa track của phiên khác, bản sạch 1369 khớp. WIP 23 mục phiên khác giữ nguyên. Tracker M8-002 một lần ok. Bản sao đã dọn. Chưa push.
- 03/11 21:17 · Lượt nợ nhẹ R2 (D-m8-031/032, W-0498 tạm): bản sao `C:\Projects\_wt\m8\m8-wp02g-no` (goc `6eafdbe` = `1bc8ee6d`, LF); giao coder N03, N10, thời hạn tổng, runbook lock. GitNexus analyze chạy nền. Verifier sau coder.
- 03/11 21:40 · Lead "Push main" (m8.32) → push `caaa8f65..1bc8ee6d` lên GitLab và GitHub, `ls-remote` cả hai = `1bc8ee6d`. Pipeline GitLab chưa xem được từ máy này (repo riêng tư, không `glab`).
- 03/11 22:23 · Coder lượt nợ ĐẠT phần máy này, HEAD `5b32d3b` (6 tệp, +408 −11): test N03/N10; hạn theo bước `M8_HAN_KEO`/`M8_HAN_SAO_LUU`/`M8_HAN_MIGRATE` = 1800 s, `M8_GIET_SAU` = 30 s, `timeout --kill-after … nohup …`; quá hạn migrate xoá container theo nhãn compose; runbook lock apk; `m8_selftest` thêm `coreutils`. Windows 79 OK skip 1, Linux 79/79, bộ độc lập W-0497 75; 16/16 đột biến; PII PASS. Coder tự ghi giới hạn: `pg_dump` kẹt trong container không bị giết; HUP thẳng vào `timeout` → SIGKILL bước đó. Giao verifier độc lập.
- 03/11 23:07 · Verifier lượt nợ **ĐẠT** (79/79 + 75/75 Windows/Linux, 29/33 đột biến, kịch bản pty/HUP/client chết đều đúng, khoá nhả); 6 nợ NHẸ, đáng kể nhất: test HUP ca migrate nay tới `timeout` không tới script, migrate chết vì tín hiệu không dọn container. Trình m8.33 ở [diff R2](../ra-soat/2026-11-03-02g-no-diff-r2.md).
- 04/11 06:25 · Lead "oke m8.33 b" → D-m8-034: coder vòng 2 hẹp sửa nợ 1–5 + câu runbook mục 6 trên `m8-wp02g-no` (từ `5b32d3b`), verifier kiểm hẹp, rồi ghép một lần, không push. Coder đang chạy.
- 04/11 07:12 · Lead "Phiên này giữ" (m8.34) → D-m8-035: phiên [80c277] giữ W-0498; 07:11 `m8-wp02g-no` vẫn `5b32d3b`, không tệp nào đổi (coder phiên kia không ghi). Clone sang `C:\Projects\_wt\m8\m8-wp02g-no2` (5b32d3b, goc `6eafdbe`, LF); giao coder vòng 1 (còn ngữ cảnh) sửa nợ 1–6 ở bản clone. `m8-wp02g-no` để nguyên.
- 04/11 08:20 · Coder vòng 2 ĐẠT `1ec4f01` (4 tệp +188 −16; 87 OK Windows/Linux, bộ độc lập 75, đột biến 9/9 + 16/16; dọn container migrate mọi nhánh hỏng; `pg_dump --lock-wait-timeout=60s` + runbook pg_dump kẹt). Giao verifier kiểm hẹp.
- 04/11 09:01 · Verifier vòng 2 ĐẠT (18/18 đột biến, `--lock-wait-timeout` thử trên postgres 16.14 thật, 12 kịch bản pty/HUP đúng; 2 ghi chú NHẸ runbook mục 10). Ghép local `e79fec71` (cha `1bc8ee6d`): 54/54 tệp và blob trùng `1ec4f01`, private index đúng allowlist 57; W-0498 EVIDENCE_SUBMITTED, NEXT W-0499, gate-status 486 PASS. Kiểm trên main: 87 OK skip 1, bộ độc lập 75 OK skip 4, selftest + gate-status PASS, MANIFEST 47/47, PII PASS. WIP 23 mục phiên khác giữ nguyên. Tracker M8-002 một lần ok. Dọn `m8-wp02g-no*`; biên bản verifier ở `prep-w0498\`. Chưa push. [Kết quả](../ra-soat/2026-11-04-02g-no-ket-qua.md).
- 04/11 09:06 · Lead "Push main" (m8.35) → push `1bc8ee6d..e79fec71` lên GitLab và GitHub, `ls-remote` cả hai = `e79fec71`. Pipeline chưa xem được từ máy này.
- 04/11 11:10 · Lead báo đỏ `gate_sweep`, `image_selftest`, `tts_candidate_selftest`. Ba subagent dựng lại job trên runner local: `.npm` thiếu trong `tts-repository-paths.json` (có sẵn từ W-0380), `tts-container-selftest` quá 180 s trong sweep, trivy HIGH GHSA-p3jp-9v83-76w9 ở .NET 10.0.13 (advisory 03/11 17:33Z). [Chẩn đoán](../ra-soat/2026-11-04-ci-do-chan-doan.md).
- 04/11 11:28 · Lead "oke tiếp tục theo đề xuất" (m8.36 B) → D-m8-036, W-0499 R2. Bản sao `C:\Projects\_wt\m8\m8-w0499` (goc `b15f5f0` = `e79fec71`, LF); giao coder. Verifier sau coder.
- 04/11 12:24 · Coder xong `a3f95fb`: 3 job dựng lại xanh local. Verifier vòng 1 ĐẠT 7/7 (tự chạy lại 3 job, 3 đột biến); 2 ghi chú nhẹ → coder vòng 2 `634389e` (`extended` cho gate container, script bằng chứng đọc `W0499_WORK`); verifier vòng 2 ĐẠT. Phiên chính sửa câu runner trong README cho đúng nguồn (`bdc24ff`), quét `ops-agent` trivy 0 HIGH/CRITICAL.
- 04/11 13:26 · Ghép local `4791030a` (cha `e79fec71`): 49/49 tệp và blob trùng `bdc24ff`, private index đúng allowlist 52; W-0499 EVIDENCE_SUBMITTED, NEXT W-0500, gate-status 487 PASS. Kiểm trên main: test 11/11, `--list` 50/40, cd/ci-config/docs selftest + gate-status PASS, MANIFEST 39/39, PII PASS. WIP 24 đường dẫn phiên khác giữ nguyên. Tracker M8-002 một lần ok. Chưa push. [Kết quả](../ra-soat/2026-11-04-ci-w0499-ket-qua.md).
- 04/11 13:39 · Lead "tiếp tục đi" (m8.37) → push `e79fec71..4791030a` lên GitLab và GitHub, `ls-remote` cả hai = `4791030a`. Pipeline chưa xem được từ máy này.
- 04/11 13:45 · Lead "tiếp tục nhé" → sửa 2 ghi chú NHẸ runbook mục 10 (W-0500, R1). Bản sao `m8-w0500` (goc `97352c2` = `4791030a`).
- 04/11 18:40 · W-0500 ba vòng (vòng 2 CẦN SỬA: nới khẳng định test lọt đột biến dừng sớm, thiếu lọc vai) → verifier ĐẠT vòng 3. Ghép local `e5d5aa8c` (cha `4791030a`): 29/29 tệp và blob trùng `9bb05a7`, allowlist 32; W-0500 EVIDENCE_SUBMITTED, NEXT W-0501, gate-status 488 PASS. Kiểm trên main: `deploy/m8/tests` 88 OK skip 1, selftest + gate-status PASS, MANIFEST 25/25, PII PASS. Tracker M8-002 một lần ok. Dọn `m8-w0500`, `kiem-w0500`. Chưa push. [Kết quả](../ra-soat/2026-11-04-runbook10-w0500-ket-qua.md).

## Bước kế tiếp chính xác

Đã hoàn tất cắt/deploy .61 LAB trên140 ngày09/11 theo D-m8-065/066. Giữ deploy bấm tay; chuyển phần candidate/02F và các gate production sang gói tương ứng, không tiếp tục xin lại quyền cắt đã thực hiện.

## Còn lại / CẦN QUYẾT

Không xoá container/dữ liệu S5 cũ khi chưa có lệnh. Chưa diễn tập restore DB/reboot/timeout/flock trên host, chưa cấu hình Protected environment; ghi riêng trong báo cáo kết quả. WIP phiên khác được giữ nguyên.

## W-0501 — `security_scan` xanh + `sheet.json` (D-m8-037, D-m8-038) · R2 · A · Sheet M8-002

- Trạng thái: **ĐẠT, ghép local `e2662d0d`** (cha `e5d5aa8c`, 05/11), chưa push. Nguồn bản sao `m8-w0501` HEAD `a67ff76` (goc 6100862), verifier ĐẠT vòng 1.
  Trên main: gitleaks toàn lịch sử 0 và khoảng `e5d5aa8c..e2662d0d` 0; MANIFEST 30/30, PII 31 PASS; gate-status 489 PASS; WIP 22 đường dẫn phiên khác giữ nguyên.
  Bước gitleaks khi ghép đã vào `PHIEN.md`.
- Tiêu chí đạt: (1) `gitleaks git --log-opts=<HEAD mới>` với `.gitleaksignore` mới trên bản clone đủ lịch sử: 0 phát hiện; (2) mỗi fingerprint mới khớp đúng một
  phát hiện của báo cáo `e5d5aa8c`, phân nhóm manifest-sha256 / fixture / README / `sheet.json`; verifier lấy mẫu ≥ 30 dòng + toàn bộ nhóm không phải manifest,
  đọc giá trị đã che ở tệp gốc để xác nhận là sha256/giá trị giả; (3) `sheet.json` không còn bị theo dõi trên `main` (phiên chính `git rm --cached`), `.gitignore`
  có dòng, `sheet.example.json` mẫu rỗng, `sheet-sync.mjs` báo NOT_CONNECTED đúng khi thiếu tệp; (4) các gate có sẵn liên quan (`allowlist-selftest.mjs`, gate-sweep
  mặc định) không đỏ thêm; PII bằng chứng PASS.
- Ngoài phạm vi: `pii_scan` (chờ m8.39), xoay token (phiên lead), sửa lịch sử git.
- Bước gitleaks khi ghép (phòng tái phát): ghi vào `PHIEN.md` mục chạy song song sau khi W-0501 đạt.

## W-0503 — gộp và tối ưu pipeline CI (D-m8-041…044) · R2 · A · Sheet M8-002

- Trạng thái: **ĐẠT, đã push** `1bed1ad4` + `203cfe02` (cha `2acfd7e6`, D-m8-046); pipeline thật CHƯA KIỂM. Bản sao goc 9a5f7c3 → coder `bcb2e3d`. [Phân tích](../ra-soat/2026-11-05-ci-pipeline-toi-uu.md).
- Kết quả: 34 job khai báo → 12; push main có mã 32 → 8 job, chỉ tài liệu 5, MR 8/5, lịch 9, web 10. Đối chiếu 172 dòng lệnh LOST 0. Giả lập Docker: governance 302 s,
  dotnet 1525 s (2463 ca, tập con 6/6 khớp `--list-tests`), publish_images 860 s → ước ~40 phút push mã (chưa đo trên runner), 6–7 phút chỉ tài liệu.
- Kiểm: verifier 3 vòng — vòng 1 CẦN SỬA (publish không chờ đủ job kiểm; aux đẩy khi security/dotnet đỏ; interruptible + changes làm mất test commit mã),
  vòng 2 ĐẠT (30/32 đột biến đỏ, 2 sống có lý do), vòng 3 nhỏ (selftest qua `run()`, phiên chính tự chạy 2 đột biến đỏ). gitleaks: 3 thẻ image giả `ivr-api:<40 hex>`
  trong log giả lập → miễn fingerprint `203cfe02` (D-m8-037); toàn lịch sử và khoảng 0. Tracker M8-002.
- Còn: push (lệnh riêng) → pipeline thật đo thời gian; Lead tạo lịch đêm; `M8_AUTO_DEPLOY=YES` sau cắt .61. Khoảng hở: hai push sát nhau trước khi runner
  nhận `dotnet` vẫn huỷ pipeline đầu (chạy lại web). Mất artifact `validation-summary.txt`, `dr-selftest.log`, `policy-selftest` (gate vẫn chạy).
- Đề xuất sau (coder): `publish_images` chạy song song `dotnet` (~14 phút); runner limit 3.
- Đích: 32 → ~10 job, không bớt bước kiểm: `governance`, `api_contract_diff`, `observability_rules`, `dotnet`, `security_scan`, `images`, `pii_scan`,
  `publish_aux_images` + `tts_candidate_selftest` tự động theo `changes` + schedule, `deploy_m8_61` tự động khi `M8_AUTO_DEPLOY=YES` sau cắt .61 (D-m8-045), mặc định bấm tay; bỏ `registry_push_pull_smoke`.
  `rules: changes` cho `dotnet`/`images`; lượt schedule đầy đủ (Lead tạo lịch trong GitLab UI). Runner `limit` 2 đã đổi (D-m8-041).
- Tiêu chí: script đối chiếu 0 dòng lệnh mất; selftest CI/docs/traceability + gate-sweep không đỏ thêm; chạy thật từng job mới trong image của nó, đo thời gian;
  không còn tên job cũ trong mã/test hiện hành; bằng chứng + PII PASS. Pipeline thật sau push.

## W-0504 — publish song song dotnet (D-m8-047) · R2 · A · Sheet M8-002

- Trạng thái: **ĐẠT, đã push** `39e05cd2` (cha `203cfe02`; có trên remote trước lệnh push, D-m8-049). Bản sao `m8-w0504` goc 63cc57f → `3bbb7dc`.
- publish/aux không chờ dotnet/pii; deploy chờ dotnet + pii + publish (không optional); aux ghi trivy vào artifact trước khi đỏ; assert `--exit-code 1`.
- Verifier vòng 1 CẦN SỬA (từ địa chỉ trong README bằng chứng → governance đỏ; PII PASS giả do CRLF trên Windows), vòng 2 ĐẠT; vòng 3 nhỏ (assert exit-code).
- Runner limit 3 (ngoài repo). Ước push mã ~32 phút, chưa đo.

## W-0505 — bản ghi duyệt filelock 4.2.1 cho `ivr-tts` (D-m8-048) · R3 · A · Sheet M8-002

- Trạng thái: **ĐẠT, Lead duyệt diff, đã push** `a0aff19b` (D-m8-049). Coder `6e1808c`; tester độc lập 80 ca ĐẠT; verifier ĐẠT (JS 4/4, Python 5/5 đột biến).
- Lock 3 dòng filelock 3.32.4 → 4.2.1 (hash PyPI, tester tự dựng trùng byte); `filelock-4.2.1.json` nối sau certifi; shim + binding JS kiểm chuỗi, sha bản ghi ghim.
- Image `ivr-tts:w0505` trivy HIGH/CRITICAL 0; tệp giọng/model bất biến. CHƯA CHẠY: backend với model thật.

## W-0506 — làm mới khoá deb Ubuntu sau cập nhật kho (D-m8-050) · R2 · A · Sheet M8-002

- Trạng thái: **ĐẠT, ghép local `798a6b0b`, CHƯA PUSH.** Coder `ae02841`; verifier độc lập ĐẠT.
- Nguyên nhân pipeline `a0aff19b` đỏ: `publish_images` vấp diff `runtime-packages.lock` (Ubuntu ra ca-certificates .2); `publish_aux_images` 3 HIGH trong `ivr-asterisk-s5` (apt/libapt-pkg 2.8.3, libbrotli1); ca-certificates .1 đã bị gỡ khỏi kho.
- Sửa: 3 khoá `deploy/docker/*.lock`; `--no-cache` 5 image rc 0, trivy 0 HIGH. CHƯA CHẠY: pipeline GitLab, `image-selftest` đầy đủ.

## W-0508 — hạn regex 2 s dùng chung, sửa `dotnet` chập chờn (D-m8-053) · R2 · A · Sheet M8-002

- Trạng thái: **ĐẠT, trên remote `b484de6e`** (D-m8-054). Coder `8b06670`; verifier độc lập 3 vòng (vòng 1: lý do 2 s sai + test rào hở; vòng 2: "Đường gọi" trong README làm PII đỏ + 2 lỗ rào; vòng 3 ĐẠT).
- `RegexLimits.MatchTimeout` 2 s cho 14 regex `src`; test rào UT-REGEX-TIMEOUT-01/02 + IT-REGEX-TIMEOUT-01. Rủi ro chấp nhận: mẫu `delivery_area_short` bậc hai, intake khớp trước kiểm độ dài → chi phí xấu nhất ×8 (chỉ Order Core). Kiểm độ dài trước = gói riêng (đề xuất).
- Không tái hiện được lỗi dưới tải CPU cục bộ. CHƯA CHẠY: pipeline GitLab xanh trọn.
- W-0507 `c31688e7` (cùng lượt, D-m8-052): WIP M3 → M8 của m34 vào `main`; xem `hop-thu/m8-2026-11-06-wip-m34-da-vao-main.md`.

## W-0509 — docker-cli 29.9.3 + công cụ làm mới khoá + quét trước push (D-m8-055) · R2 · A · Sheet M8-002

- Trạng thái: **ĐẠT, trên remote `cac0dd92`** (D-m8-056). Coder `1813164` + `9e0aa60`; verifier độc lập 2 vòng ĐẠT.
- Nguyên nhân pipeline `b484de6e` đỏ `publish_images`: trivy 2 HIGH docker-cli 29.9.2-r0 trong `ivr-ops-agent`. Lần đỏ thứ tư cùng loại (khoá ghim + CSDL CVE mới + kho gỡ bản cũ).
- Khoá: ops-agent (docker-cli, openssh), asterisk build/runtime (libsqlite3, linux-libc-dev), backup/postgres (tzdata 2026f), TTS OS 12 gói; pip TTS giữ nguyên.
- `deploy/ci/tools/refresh-locks.mjs`: FAIL chỉ khi bản ghim bị gỡ/sai sha/thiếu phụ thuộc/chisel lệch/pip mất; bản mới = INFO; `--write` sửa dòng FAIL, `--write --upgrade` nâng hết.
- `deploy/ci/tools/pre-push-scan.sh`: dựng mọi image publish `--no-cache`, trivy CSDL mới, refresh-locks, PII Linux. Lối đỏ còn lại là lỗi dựng thật (chisel slice Ubuntu mới, pocket Ubuntu chỉ giữ bản mới nhất, CDN Alpine không đều) và CVE mới (chủ ý).

## W-0510 — mã hoá id ngẫu nhiên trong báo cáo api-matrix (D-m8-055) · R2 · A · Sheet M8-002

- Trạng thái: **ĐẠT, trên remote `fdd16e73`** (D-m8-056). Coder `f84d1fb` + `be9dfb5`; verifier 2 vòng (vòng 1: rào xác suất; vòng 2 ĐẠT).
- Nguyên nhân `pii_scan` đỏ: id ADMIN-/JOB- 32 hex trùng mẫu số điện thoại. Sửa bộ ghi (`report-id-encoding-lib.mjs`, `~` mỗi 8 hex), không nới bộ quét; IT-API-MATRIX-38 khẳng định tất định + IT-API-MATRIX-PII-01; traceability 1400.
- Còn mở: test đỏ đưa thân phản hồi thô vào junit XML có thể chạm `pii_scan` (chỉ khi có test đỏ).
- Trước push (cả hai): pre-push-scan PASS 17/17, gitleaks 0, Unit 1654/0. CHƯA CHẠY: pipeline `3038953576` (đang chạy), integration/chaos/contract đầy đủ.
