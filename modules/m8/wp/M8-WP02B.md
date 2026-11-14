# M8-WP02B — Cấp và kiểm bí mật production hai máy, diễn tập trong container Linux

Trạng thái: ĐẠT — đã ghép `main` 408e1f6e (W-0487), đã có trên GitLab/GitHub tại c9f0cd18 (fetch + ls-remote 02/11 09:55) · Rủi ro: R3 (bí mật, xác thực, mTLS) · Chế độ: A · Mốc: A 07/11 (công cụ), D 14/11 (chạy thật)
Hạng mục nâng: Cài bản thật `.61`/`.64` từ 50 lên 50 (giữ bậc, thêm công cụ có kiểm lab) · Sheet: M8-002 · W: W-0487 · Ước lượng: 6–8 giờ
Chỗ làm: `C:\Projects\_wt\m8\wp02b-secret` (bản sao `git archive`, repo tạm, commit `goc` 4df4683) · Base SHA: `2aaacb35` · Chỗ kiểm: cùng bản sao

## Brief
1. Repo `ginsengfood-ivr` (.NET 10 + công cụ Python ở `deploy/`). Thư mục làm việc DUY NHẤT: `C:\Projects\_wt\m8\wp02b-secret`
   (bản sao, repo git tạm có commit `goc`). KHÔNG ghi vào `C:\Projects\ginsengfood-ivr` và `G:\ivr-lab\` (chỉ đọc). Không tạo nhánh.
2. Mục tiêu: khi xong, Lead có công cụ `deploy/production-window/secrets/secret_stage.py` (Python 3.10 + `cryptography` đã ghim trong
   `deploy/release-candidate/host-python.lock.json`, nếu không có thì `openssl` CLI) làm đủ bước 3, 5, 6 của
   `provisioning-sequence.md` cho các mục cần cho lần cấp đầu (bỏ mục trạng thái `PENDING_SEPARATE_BACKUP_RECOVERY_WORK` và
   `CONDITIONAL_…` trong register). Các bước `plan | generate | stage | verify | receipt`:
   - `plan --host 61|64`: từ register + bảng "File và người đọc" của `secrets-and-access.md` → danh sách tệp, consumer UID/GID, mode,
     thư mục cha; không chứa giá trị bí mật.
   - `generate`: sinh bí mật ngẫu nhiên và PKI (CA riêng; client mTLS **CN=ivr-production-app61**; server SAN `ivr-ari.internal`;
     cặp HTTPS 9443) với umask 077, ngoài Git/release; generation ID ngẫu nhiên, không suy từ bí mật. **Chế độ production từ chối
     chạy** khi `custody` trong register còn trống (người giữ chính, dự phòng, nơi lưu) — chỉ `--lab` chạy được lúc này.
     Khoá CA không bao giờ nằm trong cây stage của proxy.
   - `stage`: đặt đúng owner/mode từng tệp và thư mục cha theo bảng (`.61` cha root:1000 0710, `.64` root:root 0700…), không `chmod -R`.
   - `verify`: đọc được bằng đúng UID consumer, UID khác bị từ chối; không symlink; ACL mọi thư mục cha; key–cert khớp; chuỗi tin cậy;
     CN/SAN đúng; hạn còn ≥ N ngày; cert sai (CA khác, CN khác) bị từ chối; `media-token` và mật khẩu ARI khớp giữa `.61` và `.64`.
   - `receipt`: JSON theo câu cuối `secrets-and-access.md` (host, locator, consumer, UID/GID, mode, generation ID, thời điểm, kết quả
     đọc đúng/sai UID…), không chứa nội dung/hash bí mật; ghi ra tệp mới, KHÔNG sửa `provisioning-register.json` đã commit.
   Tiêu chí đạt: (a) `python -X utf8 -m unittest discover -s deploy/production-window/secrets/tests -v` đạt, test đỏ-trước cho từng quy
   tắc; (b) diễn tập lab trong container Linux (tên tiền tố `m8-wp02b-`): generate→stage→verify cho cả hai cây `.61` và `.64` đạt;
   (c) đột biến: đổi mode 0400→0444, đổi CN, tráo key, symlink, UID sai → `verify` đỏ; (d) quét: không giá trị bí mật nào lọt vào
   stdout/log/receipt (test kiểm bằng cách grep giá trị lab trong mọi đầu ra); (e) `README.md` trong thư mục công cụ: cách Lead chạy
   trên hai máy khi đã chốt người giữ, điểm dừng, xoay/thu hồi.
3. Ghi được: `deploy/production-window/secrets/**`, `docs/evidence/W-0487/**`. Cấm: mọi tệp khác, đặc biệt
   `deploy/rollouts/**` (register chỉ đọc), `deploy/release-candidate/**`, `deploy/telephony-vm/**`, `deploy/telephony-link/**`,
   `ProviderPorts.cs`, `docs/release/**`, `docs/traceability-tests.md`, `.gitattributes`, `tools/task-tracker/**`.
   Lệch tên CN `ivr-app61` trong inventory: chỉ ghi vào README/bằng chứng, không sửa inventory.
4. Đọc trước: `CLAUDE.md` của bản sao; `deploy/rollouts/production-window-20261027/{secrets-and-access.md,provisioning-sequence.md,
   provisioning-register.json}`; `deploy/release-candidate/{secrets.refs.json,host-python.lock.json}`;
   `G:/ivr-lab/release-final-20261026/candidate/config/{host61,host64}/{ari-nginx.conf,compose.json}` (mount, UID, đường dẫn);
   `deploy/telephony-link/link_bundle.py` (đã có cách sinh/kiểm mTLS lab — dùng lại, không viết trùng); `deploy/backup/secret_archive.py`.
5. Được chạy: Python unittest; `docker run --rm` tên tiền tố `m8-wp02b-` (ví dụ `ubuntu:22.04` hoặc image release có Python),
   không cổng mạng; dọn container/volume khi xong. KHÔNG: `docker compose` của repo, ssh/scp, mọi máy `.60/.61/.63/.64`,
   `s5v4_host.py`, `run_lab.py`, sheet-sync, `gitnexus analyze`, đọc `.env*`/khoá thật/`G:` thư mục secret, sinh bí mật production.
   Bí mật lab chỉ trong thư mục tạm, xoá sau test.
6. Bằng chứng: `docs/evidence/W-0487/README.md` (lệnh, số test, kết quả diễn tập, đột biến), không bí mật/PII;
   `sh deploy/ci/scripts/scan-pii.sh docs/evidence/W-0487` đạt.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`. Không commit trong bản sao (để thay đổi ở cây làm việc).
8. Đầu ra: tin nhắn cuối ≤ 25 dòng theo LUAT_SUBAGENT mục 10.

## Diễn biến (mỗi vòng một dòng, mới nhất ở cuối)
- 01/11 17:40 tạo bản sao + phiếu, giao coder v1
- 01/11 18:41 coder v1 bị ngắt do 429 khi mới đọc tài liệu, bản sao chưa đổi → tạm CHỜ (hạ sóng còn 2, CACH_LAM §5); chạy tiếp khi WP02A hoặc WP02C xong
- 01/11 19:16 WP02A xong → cho coder v1 chạy tiếp, kèm định dạng tệp mật khẩu DB của compose `.61` (từ WP02A)
- 01/11 20:05 coder v1: ĐẠT (lab) · 13 tệp mới `deploy/production-window/secrets/**` + `docs/evidence/W-0487/**` (có receipt lab mẫu), đã add · unittest 71/71 (Windows 49 skip; container Ubuntu 22.04 Py 3.10.12 + cryptography ghim: 0 skip); đỏ trước 26 test/29 lỗi · diễn tập `.61`/`.64` mỗi host 19/19 check, thăm dò quyền 60 + 23 lần 0 lệch · production bị từ chối `CUSTODY_NOT_DECIDED` · đột biến 12/12 · dò lộ 1146 mẫu/70 đầu ra 0 lộ · scan-pii PASS · CẦN QUYẾT: (a) `.64 ari-secret.json` root:root 0400 suy từ `vm_deploy.py`, lệch bảng tài liệu; (b) cấp CN `ivr-production-app61` theo nginx niêm phong, inventory còn ghi `ivr-app61`; (c) `vm-disk-known-hosts` 1000:1000 0400, `api.json` không chứa ARI, mọi thư mục cha thuộc root
- 01/11 23:54 giao coder vai tester độc lập (tiêu chí a–g, container `m8-wp02b-t-`)
- 02/11 00:26 tester độc lập: CÓ LỖI · 135 test, 129 đạt, 6 hỏng (container Py 3.10 + Windows) · VỪA: chặn đích `/srv/ivr-production` chỉ so chuỗi, đi qua symlink thì khoá CA rơi vào cây production (`:191-199`); NHẸ: custody dự phòng trùng chính, lab bỏ qua im lặng `--vm-host-key`, `--scratch` nhận thư mục 0777, bảng tài liệu thêm hàng không báo drift, thiếu `doc_discrepancy` cho `vm-disk-known-hosts` · 39 kiểu hỏng không cái nào lọt `verify`; dò lộ 330 mẫu/262 argv 0 lộ; register không đổi · ghi chú: lượt 1–2 test b03 làm công cụ sinh vật liệu chế độ production (ngẫu nhiên, lab) trong /tmp container, xoá ngay
- 02/11 00:26 giao coder v2 sửa 6 lỗi
- 02/11 00:47 coder v2: ĐẠT · sửa 6 lỗi (realpath vùng cấm + `.git`; `CUSTODY_BACKUP_EQUALS_PRIMARY`; lab dùng `--vm-host-key`; `--scratch` an toàn; `ACCESS_DOC_DRIFT:new-row`; `doc_discrepancy` known_hosts) · đỏ-trước đúng 6 hỏng · 215/215 trong container Py 3.10 (5 skip đạt trên Windows), Windows 215 OK · diễn tập 2 máy 19/19 · đột biến 12 cũ + 2 ca từ chối mới · dò lộ 1145 mẫu 0 lộ · scan-pii PASS
- 02/11 00:47 giao verifier (tiêu chí 1–9, container `m8-wp02b-v-`)
- 02/11 01:09 verifier lần 1: CẦN SỬA (không NẶNG) · 215/215 chạy lại (container Py 3.10 + Windows); diễn tập 2 máy 19/19; PKI đúng (CN, EKU, SAN, không khoá CA trong cây); custody từ chối 7 kiểu; `generate` chặn 10/10 đường cấm; audit hook 214 tiến trình con 0 `-pass*`, 325 mẫu 0 lộ; 3 lựa chọn lệch tài liệu hợp lý (`vm_deploy.py:126-131`, `ops_agent.py:188-190`, compose api ARI tắt) · VỪA: `stage` ghi được vào `/opt/ivr/releases` và cây Git (`:949-957`); đột biến 10/14 (M13 tệp lạ sống) · NHẸ: 3 check thiếu test riêng, thiếu `doc_discrepancy` `api.json`, README thiếu bước chép + sha256 · ghi nhận: `--register` trỏ bản sao đã điền custody vẫn mở cổng production, chỉ còn `register_sha256` để truy
- 02/11 01:09 giao coder v3 sửa 5 điểm
- 02/11 01:25 coder v3: ĐẠT · `stage` mọi mode từ chối `/opt/ivr/releases` + cây Git (kể cả symlink); 4 test một-lỗi-một-check; `reference_discrepancy` cho `.61 api.json` (khớp bảng, lệch `rehearsal.py`; phiên chính chấp nhận vì test a10); README thêm bước đưa công cụ lên máy (archive LF, sha256, Py 3.10 + cryptography) · đỏ-trước 3 test · M06/M07/M10/M13 đỏ · 222 OK container Py 3.10 + Windows · diễn tập 19/19 · dò lộ 0
- 02/11 01:25 giao verifier lần 2 (lần cuối)
- 02/11 01:48 verifier lần 2: ĐẠT (1 NHẸ không chặn) · 222 OK container Py 3.10 + Windows; diễn tập 15/15 bước, 19/19 mỗi máy; `stage` từ chối mọi ca releases/Git/symlink/`..`/worktree, không ghi gì; dò lộ 325 mẫu/144 đầu ra 0 lộ; README bước chuẩn bị chạy được (archive LF 0 CRLF, sha256 bắt tar sửa, host-tools 183/183, recovery_python READY) · đột biến 17/18 (N3: thiếu test symlink trỏ vào thư mục con cây Git, `secret_stage.py:478`; mã đúng) · tiêu chí 1–9 ĐẠT
- 02/11 01:48 phiên chính: bản vá `C:\Projects\_wt\m8\wp02b-secret.patch` (21 tệp, +7527, 0 CR, toàn trong phạm vi), `git apply --check` đạt trên `main` `2aaacb35` → chờ Lead duyệt diff (R3)

- 02/11 09:05 Lead `ok gộp 02A 02B 02C` → phiên chính ghép: commit `408e1f6e` W-0487 · test: Windows 222 OK (167 bỏ qua) + container Linux root Py 3.10 cryptography 50.0.2: 222 OK (5 bỏ qua), bộ độc lập 135 OK (5 bỏ qua); README bằng chứng ghi đã ghép · gate-sweep 47/51, 4 FAIL có sẵn từ trước (document-links, progressive-selftest, selftest-pii, tts-provenance), không do ghép · detect_changes LOW · Sheet M8-002 đã ghi
## Bước kế tiếp chính xác
Đã ghép. Việc tiếp theo thuộc sóng 2 M8-002 (phiếu mới): `vm_deploy.py` quản project 3 dịch vụ `.64`, nợ test NHẸ của 3 gói, chuyển giám sát thật; chạy thật chờ m8.6 + anh Tuấn.

## Còn lại / CẦN QUYẾT
- Chạy thật cần Lead chốt người giữ chính, dự phòng, nơi lưu khoá CA/bí mật (register `custody` đang trống).
