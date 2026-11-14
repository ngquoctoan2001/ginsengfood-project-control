# chuyen-may-99 — Chuyển app M8 từ .61 sang 192.168.1.99 (D-lead-035)

Trạng thái: ĐANG LÀM — **đã cắt xong 14/11 08:50**: M8 chạy trên .99 (bản `10f335de`), M3 ↔ M8 trọn vòng đơn MOCK 577
ACCEPTED, sao lưu cron chạy, .61 dừng hẳn giữ dữ liệu làm lối lui. Còn: CD `deploy_m8_99` chưa chạy lần nào (biến CI + khoá
.99 do Toàn đặt), Retry pipeline `eca6670f`. Trước đó: pha a, `mo-64`, kiểm ARI ĐẠT 13/11 16:31; cả chuỗi
commit **đã lên `origin/main` = `eca6670f`** (reflog: `c80528db` 16:31, `eca6670f` 19:11, không do phiên này push) ·
Rủi ro: R3 (cắt chuyển máy chủ, bí mật, CSDL) · Chế độ: A (bản sao `git archive`) · Phiên: phụ "m8 phụ · chuyển app M8"
Mã: **W-0533** `7f12ddaf` (kịch bản + CD), **W-0535** `c80528db` (sửa `anh` sau lần pha a thật đầu), **W-0537**
`be16a692` + `eca6670f` (khoá gói hệ điều hành) · Sheet **M8-011** (Đang làm). Chuỗi trên `af93ca42`: 7f12ddaf,
eb5156ff (W-0534, phiên chính), c80528db, 855a57c2 + 1ec9e911 (W-0536, phiên chính), be16a692, eca6670f.
Quét trước push D-m8-055 trên `eca6670f` **PASS** (9 image dựng, 8 trivy, `refresh-locks --check`, PII, gate-sweep) ·
gitleaks `eca6670f` toàn lịch sử 0, `af93ca42..eca6670f` 0.
Giờ cắt (D-lead-038, 13/11 15:51, thay khung 21:15–22:00 của D-lead-036): **không chờ giờ cố định**, cắt ngay khi Anh
Tuấn cho .99 vào cầu ARI .64; thứ tự m12 → m34 → m8 giữ. Scheduler gọi đang tắt; nếu lúc cắt đã bật thì cắt ngoài
08:00–21:08 (pha b tự từ chối khi lịch gọi .61 bật). **.64 đã mở cầu ARI 18089 cho .99 lúc 13/11 16:08** (Toàn tự
chạy sudo theo `may-99/README.md` mục 5, phiên `lead`; từ .99 TCP mở, HTTPS không chứng thư trả 400). Không còn chặn từ
.64; pha b chờ m12 → m34 cắt xong theo thứ tự.
Chỗ làm: bản sao `C:\Projects\_wt\m8\chuyen-may-99\` (gốc `af93ca42`); bản vá 29 tệp đưa vào `main` bằng `GIT_INDEX_FILE`
riêng, không đụng tệp dở của phiên khác (`docs/weekly-tracking/nguyen-quoc-toan.md`, `deploy/operations/m34_mock_agent*.py`).

## Mục tiêu (khối text trong `modules/lead/may-chu/2026-11-13-chuyen-may-99/4-m8.md`)

App M8 chạy trên .99 đúng SHA, nối được Asterisk .64 và M3, CD lên .99, sao lưu chạy, .61 giữ làm lối lui.
Chỉ chuyển bộ đang chạy thật (project `m8` của `~/m8`, theo dòng M8 của `KIEM_KE_MAY_CHU.md`); Asterisk .64 giữ nguyên.

## Đã làm (commit `7f12ddaf`)

| Phần | Tệp | Ghi chú |
| --- | --- | --- |
| Khuôn chạy được trên cả hai máy | `deploy/m8/compose.yml`, `env.mau`, `trien-khai.sh`, `noi-m3/dat-cau-hinh.sh`, `noi-m3/lan-thu.sh` | `M8_DIA_CHI` (cổng 8443 + kiểm health; lượt CI đọc từ `.env`); Asterisk lab vào profile `s5-lab`; `lan-thu.sh` tìm `m8-noi-m3/` trong khuôn trên .99 |
| Kịch bản cắt theo pha | `deploy/m8/may-99/{chuyen.sh, tren-61.sh, tren-99.sh, sao-luu.sh, README.md}` | `kiem`, `a`, `mo-64`, `b`, `allow --ip`, `d`, `quay-lui`, `sao-luu` |
| CD | `deploy/ci/cd.gitlab-ci.yml`, `ci.gitlab-ci.yml`, `scripts/{cd,ci-config,docs}-selftest.mjs`, `deploy/ci/README.md`, `.gitlab-ci.yml` | job mới `deploy_m8_99` (bấm tay; tự động khi `M8_AUTO_DEPLOY=YES`), `deploy_m8_61` chỉ bấm tay (lối lui); `git` thêm vào container test `deploy/m8/tests` |
| Đường trên .99 (D-lead-037) | `/data/ginsengfood-ivr`, sao lưu `/data/sao-luu/ginsengfood-ivr` | không `~/m8`, không liên kết trong nhà `ssv`; project compose giữ `m8` |
| Tài liệu, sổ | `deploy/m8/README.md` (mục 13 mới, mục 3–4), `may-99/README.md`, `noi-m3/{cau-hinh,viec-m34}.md`; `docs/evidence/W-0533/README.md`; register + `gate-status.yaml` + `readiness-board.md` (sinh lại bằng `gate-status.mjs --write`) | |

Điểm thiết kế: bí mật đi .61 → ống ssh trên máy Lead → .99 trong container phụ, không in, không lưu ở máy Lead; chứng thư
8443 mới sinh tại .99 (SAN `IP:192.168.1.99`), Issuer → `https://192.168.1.99:8443`; mạng sandbox .99 cùng subnet/gateway
.61 (`172.29`, dải nền .99 chừa cho M8); pha b không dừng gì trên .61 trước khi image bản đang chạy có trên .99, so số
dòng đúng từng bảng trước khi lên .99; mọi bước hỏng sau khi dừng .61 in `chuyen.sh quay-lui`.

## Bằng chứng (13/11, máy Lead + container Linux)

- `deploy/m8/tests/test_may_99.py` 30/30 OK trên Windows Git Bash (143 s) và trong `docker:29.6.2-cli` + `bash python3
  coreutils git` như CI (5,9 s). ssh/curl/docker/flock giả, máy `*.invalid`, có test `type -P ssh` là bản giả.
- Đột biến 5/5 bị bắt: so số dòng sau `len`, bỏ chặn lịch gọi ở `dung-app`, xoay vòng trước khi kiểm dump, dừng .61
  trước khi so image, đường .99 trong `deploy_m8_99` về `~/m8` (cd-selftest).
- `deploy/m8/tests` từng tệp: `test_trien_khai` 68 (1 skip), `test_noi_m3_dat` 50 (11 skip), `test_noi_m3_kiem` 31,
  `test_noi_m3_lan_thu` 45 (1 skip), `test_noi_m3_tron` 12, `test_noi_m3_ghim_la` 6, `test_tat_khan_tinh` 7,
  `test_tat_khan_dien_tap` 27, `test_compose` 20, `test_khuon` 11, `test_noi_m3_tai_lieu` 24, `test_loi_vao_do` 24 (1 skip),
  `test_loi_vao_kiem_doc_lap` 17, `test_nghiem_thu_m3_doi_soat` 39, `test_nghiem_thu_m3_tai_lieu` 23 OK. `test_dia_ban_m3`
  đỏ 2 ca chỉ trong bản sao (CSV bị CRLF khi `git archive`), trên `main` có bản vá 20/20 OK.
- `CD_SELFTEST_PASS`, `CI_CONFIG_SELFTEST_PASS`, `API_DOCS_SELFTEST_PASS`, `DOCUMENT_LINKS_PASS`, `GATE_STATUS_PASS`;
  `scan-pii.sh docs/evidence/W-0533` PASS; `detect_changes` rủi ro thấp, 0 luồng bị ảnh hưởng.
- gitleaks 8.30.0 (container `dotnet/sdk:10.0.201`, clone `main`): toàn lịch sử 0, `af93ca42..7f12ddaf` 0.
- Quét trước push D-m8-055: `7f12ddaf` ĐỎ (kho gói lệch, sửa ở W-0537); `eca6670f` PASS 13/11 19:3x.
- CHƯA CHẠY: mọi pha trên máy thật; verifier độc lập (phiên phụ chỉ được 1 subagent, đã dùng cho CI).

## Toàn cần làm trước lượt duyệt

1. ~~.64 cho .99 vào cầu ARI~~: xong 16:08 (Toàn tự chạy, không cần Anh Tuấn).
2. `sudo mv` để có `/data/ginsengfood-ivr` và `/data/sao-luu/ginsengfood-ivr` (D-lead-037); `kiem` báo thiếu thì dừng.
3. Không gấp, không chặn cắt: biến CI `M8_99_DEPLOY_SSH_KEY`, `M8_99_DEPLOY_KNOWN_HOSTS` (File, Protected, `main`),
   environment `m8-99`, dòng `authorized_keys` trên .99 (`may-99/README.md` mục 4) cho các bản sau. Pha a/b chuyển image
   bằng `docker save | ssh | docker load`, không cần CD.

## Lượt duyệt liền (D-lead-038)

Chạy trên máy Lead, Git Bash, trong `C:\Projects\ginsengfood-ivr`; mỗi dòng một lần duyệt, liền nhau. Bước nào báo `LỖI`
thì dừng, làm theo dòng `Làm gì:` nó in (sau khi dừng .61 thì đó là `chuyen.sh quay-lui`). Bước 1–4 không dừng gì, làm
được ngay; bước 5 trở đi sau khi m34 cắt xong (thứ tự m12 → m34 → m8).
**Đã chạy ĐẠT 13/11 16:13–16:33** (Toàn "tiếp tục đi"): 2, 3 (với `c80528db`), 3b, 4 — mục "Chạy trên máy". Bước 1 xong
theo cách khác: cả chuỗi tới `eca6670f` đã lên `origin/main` (19:11), quét trước push + gitleaks trên `eca6670f` xanh.
Còn lại bước 5–8.
**Toàn chốt 13/11 22:0x: M8 cắt ngay sau pha B của m34, không chờ pha C/D** (cổng vào tên miền không dính M8). Vì thế bỏ
việc thêm nguồn .99 vào 8443 trên .61 (khoảng giữa B6 và pha b M3 không gửi được đơn sang M8, đã báo nhóm); gốc callback
đổi trên .61 bằng bước 4b rồi pha b mang sang .99. m34 bắt đầu pha B 21:50, dừng ở B0 21:54 (lỗi kịch bản m34, .60 chưa
đổi), chạy lại sau; dấu "B6 XONG" ghi cuối `hop-thu/m8-2026-11-13-m34-cat-khong-gio-co-dinh.md`.

**Chuỗi đêm 13/11** (phiên lead 22:17 truyền lời Toàn: làm xong tối nay; đã ngoài 08:00–21:08). Chạy trong Git Bash ở
`C:\Projects\ginsengfood-ivr`, `K=/c/Projects/_wt/m8/chuyen-may-99`, `S="ssh -i ~/.ssh/id_ed25519 -o IdentitiesOnly=yes -o BatchMode=yes"`:

| # | Khi | Lệnh | Đạt |
| --- | --- | --- | --- |
| n1 | có "B6 XONG" | `$S ssv@192.168.1.61 bash -s < $K/doi-callback-99.sh` | `cb_dat_thoat 0`, `cb_goc_sau https://192.168.1.99:8445` |
| n2 | sau n1 | Toàn gửi câu nhắn nhóm (dưới) | |
| n3 | sau n2 | `bash deploy/m8/may-99/chuyen.sh b --khuon c80528db` | dòng cuối báo xong, không `LỖI` |
| n4 | m34 đã đổi `M8_ORIGIN`/Issuer/`ca-m8.pem` và gọi `/health/live` từ be | `$S ssv@192.168.1.99 bash -s < $K/doc-nguon-403.sh` | in `nguon <IP> … 403` |
| n5 | sau n4 | `bash deploy/m8/may-99/chuyen.sh allow --ip <IP n4>` (IP là IP container be thì dùng dải mạng của be do m34 báo, vì IP container đổi khi tạo lại) | `allow=dat`, m34 gọi lại được 200 |
| n6 | m34 đặt `M8_ALLOW_IP`, một đơn MOCK trọn vòng ACCEPTED | — | |
| n7 | sau n6 | `bash deploy/m8/may-99/chuyen.sh sao-luu` | cron .99 + một lần chạy đạt |
| n8 | sau n7 | `bash deploy/m8/may-99/chuyen.sh d` | M8 .61 dừng, dữ liệu giữ |

CI `eca6670f`: lượt Retry 21:29–21:45 hỏng "system failure: getting docker info 500" (Docker treo), chưa có job ivr nào chạy
sau khi Docker lên lại 22:16. Retry lại `governance` + `dotnet` sau chuỗi trên (không chạy nặng trên Docker khi m34 cắt).

| # | Lệnh | Làm gì | Dừng gì |
| --- | --- | --- | --- |
| 1 | ~~push~~ | xong: `origin/main` = `eca6670f` (cả chuỗi) | không |
| 2 | `bash deploy/m8/may-99/chuyen.sh kiem` | chỉ đọc .61/.99/.64: điều kiện trước | không |
| 3 | `bash deploy/m8/may-99/chuyen.sh a --khuon 7f12ddaf` | dựng .99: khuôn, image, du-lieu + bí mật qua ống ssh, CSDL bản sao, 8443 mới; in `chung_thu_8443=` | không, .61 chỉ đọc |
| 3b | `ssh -i ~/.ssh/id_ed25519 -o IdentitiesOnly=yes -o BatchMode=yes ssv@192.168.1.99 bash -s < /c/Projects/_wt/m8/chuyen-may-99/kiem-ari-99.sh` | kiểm cầu ARI bằng chứng thư khách thật: bật riêng `ari` trên .99, gọi `asterisk:8088/ari/asterisk/info` như worker, in mã HTTP rồi dừng `ari`. Đạt: `ari_http 401` (hoặc 200) | không |
| 4 | `bash deploy/m8/may-99/chuyen.sh mo-64` | .64: thêm .99 vào `from=` của khoá ops (giữ .61, có bản cũ) | không |
| 4b | ngay khi m34 ghi "B6 XONG": `ssh -i ~/.ssh/id_ed25519 -o IdentitiesOnly=yes -o BatchMode=yes ssv@192.168.1.61 bash -s < /c/Projects/_wt/m8/chuyen-may-99/doi-callback-99.sh` | worker .61: gốc callback → `https://192.168.1.99:8445` (thử cầu trước, chỉ đổi đúng một khoá, `dat-cau-hinh.sh` sao lưu + tự trả bản cũ). Đạt: `cb_dat_thoat 0`, `cb_goc_sau https://192.168.1.99:8445` | worker .61 tạo lại (vài giây) |
| 5 | Toàn nhắn nhóm câu dưới, rồi `bash deploy/m8/may-99/chuyen.sh b --khuon c80528db` (khuôn pha a đã cài; `deploy/m8` không đổi tới `eca6670f`) | dừng app .61 → chép du-lieu (gồm gốc callback mới)/cụm từ → dump cuối → khôi phục .99 → so số dòng từng bảng → lên .99 → kiểm | app M8 .61, chừng 20 phút |
| 6 | m34 đổi M3 sang `https://192.168.1.99:8443`, Issuer, `ca-m8.pem` = `~/m8-chuyen-99/ca-m8-99.pem` (tin `hop-thu/m34-2026-11-13-m8-sang-99-dia-chi.md`); m34 gọi `/health/live` từ be → đọc IP dòng 403 trong `docker compose logs https` trên .99 → `chuyen.sh allow --ip <IP>`; m34 đo nguồn callback M8 ở cầu 8445 rồi đặt `M8_ALLOW_IP`; một đơn MOCK trọn vòng | | |
| 7 | `bash deploy/m8/may-99/chuyen.sh sao-luu` | cron sao lưu .99 + chạy thử một lần | không |
| 8 | sau khi chạy ổn: `bash deploy/m8/may-99/chuyen.sh d` | dừng nốt M8 trên .61, giữ dữ liệu làm lối lui | M8 .61 |

**Chụp CSDL máy cũ:** bước b7 `dump-giu` chạy ngay lúc dừng ghi (app .61 vừa dừng, postgres còn chạy), giữ một bản trên
.61 ở `~/m8/sao-luu/chuyen-99-<UTC>.dump`; đây là bản đủ mọi dòng tới giờ cắt, volume CSDL .61 không bị đụng. Không thêm
bản chụp trước lúc dừng app vì bản đó thiếu những đơn ghi giữa hai lần chụp.

**Câu nhắn nhóm (Phúc, Tài) trước bước 5:**
> Mình chuyển IVR (M8) sang máy .99 bây giờ, chừng 20 phút M8 không nhận đơn từ M3, đơn gửi trong lúc này sẽ báo lỗi nhận. Xong mình báo lại.

## Bước kế tiếp

- Bước 5 (nhắn nhóm + `chuyen.sh b --khuon c80528db`) khi m34 báo M3 cắt xong; rồi 6–8.
- 14/11 Retry `eca6670f` (08:54, máy đã rảnh Docker): `dotnet` job 18026517215 đỏ 09:22 vì 1/842 ca
  `M3AdminReasonKestrelTests…(bare-cr, 400)`: `Connection reset by peer` khi ghi — test ghi yêu cầu thành 4 lần, Kestrel trả
  400 và đóng ngay khi thấy CR lẻ, lần ghi sau bị RST (đua thời gian, test chưa đổi từ 06/11 W-0507, không do W-0536). Đề
  xuất phiên riêng sửa test (thẻ "M8: sửa test chập chờn bare-cr"); trước mắt Retry lại `dotnet`.
- Pipeline GitLab của `eca6670f` (Toàn dán log 20:2x): **2 job đỏ, không do mã**. `governance` dừng ở bước
  `deploy/m8/tests`: dind kéo `docker:29.6.2-cli` từ Docker Hub bị `TLS handshake timeout` (exit 125, test chưa chạy).
  `dotnet`: mọi test và cổng đạt (JUnit 2542 + 1654 + 25 ca, `JUNIT_SUBSET_GATE_PASS` 6/6), job chạm hạn 1h lúc tải
  artifact. Runner chạy trên máy Lead, chung Docker Desktop với quét trước push của phiên phụ (18:3x–19:40); pipeline bắt
  đầu 19:11 nên chừng 30 phút đầu tranh mạng/CPU với bản dựng `--no-cache` + tải CSDL trivy — nguyên nhân khả dĩ, chưa
  chứng minh. 20:29: không job CI nào chạy, Docker Hub trả 401 (TLS 1,6 s). Việc: Toàn bấm Retry `governance` và
  `dotnet` trên web, không chạy dựng/quét nặng trên máy lúc đó. `dotnet` vẫn quá 1h khi máy rảnh → commit CI riêng đặt
  `timeout:` cho job này.
- Việc nhỏ cho commit M8 sau: `docs/evidence/W-0533/README.md:40` còn ghi khung giờ của D-lead-036 (`may-99/README.md`
  đã sửa ở W-0535).

## Khoá gói hệ điều hành — W-0537 `be16a692` + `eca6670f` (phiên chính giao 13/11)

`eca6670f` chỉ trả lại đường bằng chứng W-0536 trong `gate-status.yaml` mà lần sinh lại ở `be16a692` làm mất (bản sao
thiếu `docs/evidence/W-0536` của phiên chính); `GATE_STATUS_PASS`, `DOCUMENT_LINKS_PASS` trên `main` sau đó.

Quét trước push `7f12ddaf` đỏ vì kho gói đã bỏ bản đang ghim (6 image dựng hỏng, `refresh-locks --check` 10 lệch), không do
W-0533. Chỉ đầu ra của `deploy/ci/tools/refresh-locks.mjs`, không sửa tay, không đổi Dockerfile:

| Tệp khoá | Gói | Cũ → mới |
| --- | --- | --- |
| `deploy/docker/runtime-packages.lock` (chisel, ivr-api/worker/migrate/ops) | libc6 | 2.39-0ubuntu8.9 → 2.39-0ubuntu8.12 |
| `deploy/docker/asterisk-build-deb.lock` | libc-dev-bin, libc6-dev | 2.39-0ubuntu8.9 → 2.39-0ubuntu8.12 |
| | libperl5.38t64, perl, perl-modules-5.38 | 5.38.2-3.2ubuntu0.6 → 5.38.2-3.2ubuntu0.7 |
| | libc6, libc-bin (mới, tập khoá cần) | — → 2.39-0ubuntu8.12 |
| | perl-base (mới, tập khoá cần) | — → 5.38.2-3.2ubuntu0.7 |
| `deploy/docker/ops-agent-apk.lock` | docker-cli | 29.9.3-r0 → 29.9.3-r1 (`--write --upgrade --only`: kho đã thay r0 bằng r1, CDN lúc còn lúc mất r0) |

`--check` sau khi ghi: CLEAN (8 dòng INFO có bản mới hơn, để trivy quyết). Quét trước push đầy đủ trên `eca6670f`:
`PRE_PUSH_SCAN PASS` — dựng 9/9 image (`--no-cache`; ivr-api, worker, migrate, ops, ops-agent, tts, asterisk-base, asterisk-s5,
prometheus), trivy 8/8, `refresh-locks --check`, PII (3397 tệp), gate-sweep; gitleaks toàn lịch sử 0, `af93ca42..eca6670f` 0.

## Chạy trên máy (13/11)

| Giờ (+07) | Bước | Kết quả |
| --- | --- | --- |
| 16:13 | `chuyen.sh kiem` | ĐẠT: .61 bản `10f335de`, lịch gọi tắt, gọi thật NO, khoá rảnh, mạng `172.29.0.0/16`; .99 Docker 29.9.3, `/data` ghi được, 261G trống, khuôn chưa có |
| 16:13 | `chuyen.sh mo-64` | ĐẠT: dòng khoá ops trên .64 `from="192.168.1.61,192.168.1.99"`, bản cũ giữ `authorized_keys.cu-*` |
| 16:14 | `chuyen.sh a --khuon 7f12ddaf` | HỎNG ở a5 `image id của https lạ`: `config --images <dv>` in cả image phụ thuộc. .61 chỉ đọc; .99 đã có khuôn, mạng, volume → sửa thành W-0535 `c80528db` (33 test, đột biến 3/3) |
| 16:27–16:31 | `chuyen.sh a --khuon c80528db` | ĐẠT: 5 image ghim id chuyển bằng save/load; du-lieu + bí mật qua ống; api/worker kéo từ kho cùng image id .61; cụm từ; CSDL bản sao 335 mục; postgres+api+https healthy; máy Lead → `https://192.168.1.99:8443/health/live` ĐẠT có ghim. Chứng thư 8443 mới SHA-256 `01:39:29:F5:…:08:FD:86:E1` (`~/m8-chuyen-99/ca-m8-99.pem` trên máy Lead) |
| 16:33 | `kiem-ari-99.sh` | ĐẠT: `ari_http 401` từ mạng sandbox .99 qua cầu `ari` → .64:18089 (mTLS + IP .99 được nhận, Asterisk đòi xác thực); `ari` dừng lại sau kiểm |
| 14/11 07:42 | n1 `doi-callback-99.sh` (.61), sau "B6 XONG" 07:36:36 của m34 | ĐẠT: gốc callback `https://192.168.1.60:8445` → `https://192.168.1.99:8445`; thử cầu .99 trả 404 (TLS + nguồn .61 qua); chỉ đổi `Ivr:CallbackDelivery:TargetBaseUrl`; `dat-cau-hinh.sh` [5/5] worker + phrase-tts ổn; bản cũ `~/m8/sao-luu/cau-hinh-20261114T004155Z-8BLD` |
| 14/11 07:43–07:46 | n3 `chuyen.sh b --khuon c80528db` (Toàn đã nhắn nhóm) | ĐẠT: image bản `10f335de` cùng id .61; .61 dừng app 07:44:10; du-lieu + bí mật + cụm từ qua ống; dump cuối giữ `.61 ~/m8/sao-luu/chuyen-99-20261114T004519Z.dump`, khôi phục .99 335 mục, **37 bảng khớp**; .99 lên đủ 9 dịch vụ healthy 07:45:50; gọi thật NO, lịch gọi tắt; 8443 ghim ĐẠT từ máy Lead (chứng thư như pha a). Gián đoạn ~2 phút. Gốc callback .99 = `https://192.168.1.99:8445` |
| 14/11 07:58 | m34 (Toàn duyệt): M3 .99 → `M8_ORIGIN`/Issuer `.99:8443`, `ca-m8.pem` mới, be `tls=PINNED`; gọi thử `/health/live` từ be | 403 như dự kiến (dải be `m34_app` 172.24.2.0/24) |
| 14/11 08:04 | n4 `doc-nguon-403.sh` + n5 `chuyen.sh allow --ip 172.29.0.1` | nguồn dòng 403 lúc 00:58:36 UTC = `172.29.0.1` (cổng mạng M8, NAT Docker, như README dự đoán); allow đặt, `nginx -t` đạt, nạp lại |
| 14/11 08:23 | m34: be → `https://192.168.1.99:8443/health/live` | **200** (JWKS 200): M3 → M8 thông qua allow `172.29.0.1`. Callback M8 → cầu `.99:8445` dự kiến nguồn `172.24.2.1` (gateway `m34_app`, docker-proxy), m34 chờ Toàn duyệt `M8_ALLOW_IP` |
| 14/11 08:27 | m34 (Toàn duyệt): cầu `.99:8445` `M8_ALLOW_IP=172.24.2.1` | đặt |
| 14/11 08:33 | `thu-cau-callback-99.sh` (.99, chỉ đọc): container tạm trong mạng worker `ivr-m3-s5_sandbox` → `https://192.168.1.99:8445/` bằng CA cầu worker tin | **404** = TLS + kiểm tên IP qua, cầu nhận nguồn (không 403). Chưa gửi callback thật: chờ đơn MOCK trọn vòng (Toàn có tệp số thử) |
| 14/11 08:36 | m34 (Toàn duyệt): đơn MOCK id 576, mã `C880C01A…D4CA037`, task `m3-ivr-576-12` | M8 .99 nhận: intake ACCEPTED, job `JOB-e28f3b95…`; chưa callback vì lịch gọi tắt |
| 14/11 08:40–08:41 | lượt thử trên .99 (Toàn "Chạy ở đây"): `lan-thu.sh hien-trang` rồi `bat-lich --m3-goc https://192.168.1.99:8445` | hien-trang DAT (mock-lab-v4, 3 số tồn = 0); bat-lich DAT 01:41:17Z. Job 576: 2 attempt 08:41:20/08:41:29 hỏng `IVR_TECHNICAL_EXCEPTION`/`TTS_PHRASE_NOT_READY` ngay sau khi worker tạo lại → `HELD_ADMIN_REVIEW`, không callback; worker đang đồng bộ cụm từ sang Asterisk .64 qua cầu `ari` (PUT 200). **Giao lượt thử cho phiên m8 chính** (đang chạy E02 lặp theo Toàn "Duyệt, chạy"): nó giữ lịch, đặt đơn mới qua m34 khi đồng bộ lắng, tắt lịch trước 09:10. Phiên phụ không đụng worker .99 nữa; `d` chờ callback ACCEPTED |
| 14/11 08:49 | phiên m8 chính giữ lịch (bật 08:41:17, đồng bộ cụm từ sang .64 lắng 08:46:06); m34 đặt đơn MOCK 577 (`m3-ivr-577-13`) | **ĐẠT trọn vòng**: callback M8 qua cầu `.99:8445` (nguồn `172.24.2.1`) → 200 ACCEPTED 08:49:32, đơn CONFIRMED, áp đúng một lần (m34 ghi cuối `hop-thu/m34-2026-11-13-m8-sang-99-dia-chi.md`); phiên m8 chính: 0 retry, `doi_soat_m3` KHỚP, **lịch tắt 08:50:52** (cửa sổ ~9 phút), gọi thật NO. `kiem-sau` báo `kenh_asterisk` hỏng vì tìm container Asterisk cục bộ (trên .99 Asterisk ở .64) — lỗi công cụ, phiên chính ghi cho E10 |
| 14/11 08:50 | n8 `chuyen.sh d` (Toàn "Duyệt cả hai", sau đơn MOCK đạt) | ĐẠT: .61 dừng hết 10 dịch vụ M8 (api, ari, asterisk lab, https, ops-agent, ops-metrics, phrase-tts, postgres, prometheus, worker); volume, du-lieu, image giữ; lui bằng `chuyen.sh quay-lui` |
| 14/11 08:10 | n7 `chuyen.sh sao-luu` (Toàn "Duyệt cả hai": sao-luu ngay, `d` sau đơn MOCK) | ĐẠT: cron `30 19 * * *` UTC (02:30 giờ VN) chạy `/data/ginsengfood-ivr/may-99/sao-luu.sh`; lần thử `ivr-20261114T011009Z-10f335deb611.dump` 938943 byte, 335 mục |

## Diễn biến

- 13/11 15:30 +07 · soạn bản sao, kịch bản 4 pha + CD .99 (subagent CI), test host giả 30 ca; theo D-lead-037 đổi đường
  .99 sang `/data/ginsengfood-ivr`; thêm `allow --ip` vì M3 lên .99 trước M8.
- 13/11 · phiên chính cấp W-0533; Sheet M8-011 tạo mới (upsert, "Phát sinh"); commit local `7f12ddaf` (29 tệp, chỉ tệp
  của phiên này); gitleaks 0/0; Sheet M8-011 ghi SHA + bằng chứng, vẫn Đang làm vì pha máy chưa chạy.
- 13/11 16:13–16:33 · `kiem`, `mo-64`, pha a (sau W-0535), kiểm ARI ĐẠT trên máy thật (mục "Chạy trên máy").
- 13/11 · W-0537 khoá gói (`be16a692`) + sửa `gate-status.yaml` (`eca6670f`). 19:11 `origin/main` lên `eca6670f` (không do
  phiên này push). 19:3x quét trước push `eca6670f` PASS, gitleaks 0/0.
