# Kiểm kê máy chủ Ginsengfood

Mốc: 03/11/2026 10:05 · phiên `lead` · chỉ đọc: không sudo, không mở `.env` hay tệp bí mật, không in bí mật.
Đăng nhập bằng khoá SSH của máy Lead (Lead tự cài khoá lên .60, .63, .64 sáng 03/11). User `ssv` không có quyền sudo
trong phiên này; phần cần sudo (snap, microk8s, Docker trên .64) chỉ thấy bên ngoài.

## 1. Mỗi IP đang chạy gì

| IP | Tên máy | Cấu hình | Đang chạy | Ghi chú |
|---|---|---|---|---|
| 192.168.1.60 | vps60 | 10 nhân · 47 GB RAM · đĩa 9% | **M3 + M4 bản "LAN"** (business-platform): web, máy chủ, Postgres, Redis, ClamAV, nginx cổng 80 | **bản build 17/08**, 2,5 tháng chưa cập nhật; 27 GB thử nghiệm của Mạnh |
| 192.168.1.61 | vps61 | 10 nhân · 13 GB RAM · đĩa 47% | **M1–M2 ops-core** (bản mã 19/10) · **M8 IVR trọn bộ** · **M7 cũ** (MC AI live 18/07) | nhiều rác Docker và bản cũ nhất |
| 192.168.1.62 | ? | ? | cổng 22 không trả lời | máy tắt hoặc chặn SSH |
| 192.168.1.63 (**máy dev** từ 14/11, D-lead-039: runner GitLab `may-63` cho ivr + ops-core trong `/home/ssv/dev/gitlab-runner`, runner duy nhất của 2 repo, D-lead-042; runner máy Lead đã gỡ hẳn 14/11 13:22: 3 runner unregister, dịch vụ gỡ, `C:\GitLab-Runner` xoá; bộ SAST đã duyệt giữ ở `C:\Projects\_luu\sast-opengrep-gf17-6b93ca\`) | VPS63 | 10 nhân · 38 GB RAM · đĩa 6% | **Staging M3 + M4** (`staging.ginsengfood.vn`, cổng 8080, chỉ LAN): máy chủ bản 16/10, web bản 13/10, `tri_thuc` (hỏi đáp tài liệu, sửa tới 31/10), kit giao diện của Phúc | phiên "chief" dựng 13/10, có luật vận hành riêng trong `~/staging/README.txt` |
| 192.168.1.64 | vps64asterisk | **2 nhân** · 19 GB RAM · đĩa 4% | **Asterisk của M8** (SIP 5060/UDP trên 192.168.1.64, ARI qua 18089), media ở `/srv/ivr-media`, cấu hình ở `/opt/ivr` | Docker cần sudo nên không xem được container |
| 192.168.1.98 | máy ảo **mkt** (mới, 13/11), Hyper-V, tên máy `mkt` | 4 nhân · **RAM động** (14/11 lúc rảnh 0,7–1,2 GB, đổi theo phút) · swap 10 GB · `/` 147 GB, `/data` 275 GB · chưa Docker; phiên vào bằng khoá `id_ed25519` máy Lead (Toàn thêm 14/11) | **Máy marketing M5 + M6**, chuyển từ .60 ngay (D-lead-034); Anh Tuấn cài hệ điều hành mặc định + SSH, chưa có gì khác; Tài dựng nền + app | dữ liệu đặt trong `/data` (`/data/ginsengfood-marketing`, D-lead-037; Anh Tuấn dặn, để sao lưu và mở rộng); tài khoản Anh Tuấn gửi qua Zalo 13/11, Toàn chuyển riêng cho Tài; **giữ mật khẩu đó, không đổi** (Toàn chấp nhận, D-lead-034), **mật khẩu không ghi ở đây**, phiên Claude không đăng nhập bằng mật khẩu; HTTPS `mkt.` chờ Anh Tuấn báo (nginx 443 của Anh Tuấn) |
| 192.168.1.99 | máy ảo **SRV Ginsengfood** (mới, 13/11), tên máy `ginsengfood` | 6 nhân · 28 GB RAM · đĩa 500 GB (`/data` 280 GB) | **Máy nhà máy + bán hàng** (D-lead-035: M1–M2, M3 + M4 + M9, app M8; `ginsengfood.vn`, `/admin`, `ops.`, `pwa.`, `trace.`); đang dựng nền, chi tiết §10 | tài khoản `ssv`, **mật khẩu không ghi ở đây**; phiên vào bằng khoá `id_ed25519` máy Lead (Toàn thêm 13/11 14:24); `ssv` có nhóm sudo nhưng sudo cần mật khẩu → phần cần root do Toàn hoặc Anh Tuấn chạy |

**Chung cho .61, .63, .64:** cùng chạy microk8s 1.35 (mạng calico), keepalived, Prometheus snap; .64 thêm Grafana Alloy
và node-exporter. Đây là một cụm máy (có thể do Anh Tuấn dựng); cổng 16443, 10250, 25000, 9090 (.64 thêm 9100) mở ra mọi
mạng. .60, .63, .64 cài bản Ubuntu có giao diện (gdm, máy in, firefox).

## 2. Máy .61 (vps61)

Ubuntu 22.04.4 · đĩa 482 GB, dùng 215 GB · bật lại lần cuối 14/10 · đăng nhập gần nhất từ 192.168.0.64 (02/11, 03/11).

### 2.1 Đang chạy (không được đụng)

Phần M1–M2 cập nhật 03/11 12:48 sau khi chuyển sang `~/m12` (D-lead-018); `~/ginsengfood` và M7 cũ đã xoá.

| Module | Thành phần | Cổng | Bản | Điều khiển từ |
|---|---|---|---|---|
| M1–M2 | `m12-ops-core-api-1` (máy chủ) | 5000 | `1cee9b11e-pui022` (mã 19/10 + bản vá 21/10) | compose `m12` ở `~/m12/`, đổi bản bằng `~/m12/trien-khai.sh` |
| M1–M2 | `m12-pg-ops-1` (**CSDL vận hành**, Postgres 18) | trong | dữ liệu từ 16/07 | như trên, volume `ginsengfood_pg-ops-data` (giữ tên cũ) |
| M1–M2 | `m12-admin-web-1` (quản trị) | 3000 | `1cee9b11e-pui022` | như trên |
| M1–M2 | `m12-public-trace-1` (truy xuất) | 3001 | `1cee9b11e-pui022` | như trên |
| M1–M2 | `m12-shopfloor-pwa-1` (xưởng) | 3002 | `1cee9b11e-pui022` | như trên |
| M1–M2 | sao lưu hằng ngày 15:00 UTC (cron) | — | chạy thử 03/11 PASS | script ở `~/m12/sao-luu/`, tệp ở `~/.local/share/ginsengfood/backups/` |
| M8 | `ivr-m3-s5` (api, worker, postgres, tts, https) | 8443 trên 192.168.1.61 | mã `66d9045d8` (26/10) | `~/m8/ivr-m3-s5/…` + `~/m8/ivr-m3-s5-v4-20261027/` |
| M8 | `ivr-telephony-s5-asterisk-1` (Asterisk trong container) | trong | 12/10 | `~/m8/telephony-s5-20261012/` |
| M8 | `ivr-ari-link-app-ari-1` | trong | 15/10 | `~/m8/ivr-l34-app-20261015-r1/` |
| M8 | `ivr-operations-prometheus-1` + dịch vụ `ivr-operations`, `ivr-operations-metrics` (systemd) | — | 17/10 | `~/m8/ivr-operations*` |

Nhà `ssv` trên .61 còn: `m12/`, `m8/`, `ivr-artifact-mirror`, `_luu-tru/`, `snap/`. Trước 03/11 12:45, M1–M2 và M7 cũ chạy chung
compose `ginsengfood` ở `~/ginsengfood/module7-workspace/deploy/`.

### 2.2 Rác và đồ cũ

| Nhóm | Gồm | Dung lượng |
|---|---|---|
| Docker: bộ nhớ đệm build | 2.039 mục, không mục nào đang dùng | 115 GB (Docker tính thu hồi được 51 GB) |
| Docker: container đã dừng | 84/99: chuỗi bản cũ `*-pre-n17…pre-sync`, `*-failed-*`, `*-rollback-*`, bộ audit `m1m2_*`, `m3_*`, `m5_*`, `m8_*` (tháng 9), `m5-dev-*`, `m3-test-pg`, `gf-m3-e2e-*`, `m8_asterisk_lab` | nhỏ |
| Docker: image | 292 image, 86 đang dùng; 16 image treo; zaproxy 3,8 GB | 37 GB (thu hồi được 18 GB) |
| Docker: volume | 114 volume, 29 đang dùng; CSDL audit tháng 9, `ivr-w0344-*`, `ivr-ari-l31-*`, `ivr-telephony-vm-l30-*` (lab M8) | 11 GB (thu hồi được 9 GB) |
| `~/ginsengfood` bản phát hành cũ | `d1`…`d9`, `f1`/`f3`/`f5`, `o03-*`, `pilot-sync-*`, `n21-*`, `n22-n23`, `c38`, `log2a`, `vh07`, `frontend-*` (5) | khoảng 14 GB |
| `~/ginsengfood` kiểm bảo mật | `security-gates-*`, `security-remediation-*` (4 thư mục "test-only", 23/10) | 8,4 GB |
| Thư mục nhà cũ | `_audit` (5,3 GB), `m3/audit-*`, `m3/back-end`, `m3/dev-be`, log/sql lẻ trong `m3`, `m1-m2/audit-*`, `m4/*` (27/08), `m5/audit-*`, `m6`, `m7` (rỗng), `gf-m3` (690 MB, 27/08), `ivr-artifact-mirror` (732 MB, 22/09), `m7ship.zip`, `seed_test_live_session.py`, `gfops-frontend-release-…-1610` | khoảng 10 GB |
| Log lẻ ở nhà | 40 tệp `gf-*.log` (08–10/09) | 30 MB |
| Bản sao CSDL cũ ở nhà | `ops-core-backup-20260813-0616.sql`, `opscore-backup-20260908-0308.dump`, `gf-m3-backup-20260908-073749.tar.gz` | 80 MB |
| Lab M8 | `~/m8/telephony-*-lab-*` (14), `w0399/w0402/w0436/w0446/w0449/w0457/w0469-*`, `k142-*`, `l31-preflight-*`, `ivr-operations-20261017-lab`, `ivr-prometheus-install-20261017`, `asterisk/`, `compose.m8-softphone.yml` | khoảng 200 MB (giữ `w0402-20260929-render-01`: tts đang gắn) |
| Của người khác | `m3/manh-test` (13/10, Mạnh) | 12 GB |
| Đã lưu trữ | `_luu-tru/m8-2026-09-10` (7,7 GB), `_luu-tru/m8-trong-2026-09-10` (2,3 GB), sửa 02/11 | giữ |

## 3. Máy .60 (vps60)

- Chạy compose `ginsengfood-lan` ở `/opt/ginsengfood/deploy/compose.lan.yml`: `backend` (8080 trong), `frontend` (3000 trong),
  `postgres` 17, `redis` 7.4, `clamav`, `nginx` (192.168.1.60:80). Image backend, frontend build **17/08**; container tạo 17/08.
  Mọi việc M3, M4 sau 17/08 (VNPAY, vận chuyển, AI) **chưa có trên .60**.
- `~/gf-manh` 27 GB: 21 bản sao mã của Mạnh (thử đột biến, 13–29/10), 2 thư mục còn sửa dở (`work`, `work2`). Đăng nhập gần nhất
  từ 192.168.0.85 (16/10).
- Rác: bộ nhớ đệm build 11 GB (thu hồi 9 GB); container `elastic_taussig` (Postgres thử, đã dừng). Không có cron.

## 4. Máy .63 (VPS63) — staging M3 + M4 (**ĐÃ DỌN 18/11 14:3x**, D-lead-061)

- 18/11: `docker compose -p stg|stg_kit|stg_m9 down` (không `-v`), `docker rm stg_m9_testpg`, xoá đích danh 14 image `stg/*`, `stg_tri_thuc:*`, mạng `stg_net`;
  cổng 8080/8090/8091 đóng. **Giữ** 9 volume `stg_*` (~0,7 GB) và thư mục `~/staging/` tới khi Toàn bảo xoá hẳn. Bảng dưới là lịch sử.

- Compose `stg` (`~/staging/edge`, `app`, `tri_thuc`): `stg_edge` nginx 8080 (chặn chỉ LAN), `stg_backend` bản `cay-0ab5e7d66`
  (16/10), `stg_frontend` bản `45549f063` (13/10), `stg_pg`, `stg_redis`, `stg_clamav`, `stg_tri_thuc` (đổi bản liên tục
  28–31/10, tối 31/10 đã tắt hỏi đáp). Compose `stg_kit`: nginx phục vụ kit giao diện của Phúc.
- Vận hành theo `~/staging/README.txt`: gọi qua `./dc.sh`, **cấm `docker prune` và `down -v`**, dọn thì xoá đích danh `stg_*`;
  có nhật ký `NHAT_KY.txt`, sổ bí mật chỉ ghi tên. Đĩa phụ 20 GB gắn ở `staging/khong-sao-luu`.
- Staging chưa có thay đổi M3 từ 17/10 trở đi (VNPAY 29–30/10 chưa lên).
- Rác ít: container `relaxed_ride` (đã dừng), 4 image treo, khoảng 13 bản `stg_tri_thuc` cũ (thu hồi 1,9 GB).
  Đăng nhập: `root` từ 192.168.1.240 ngày 24/10; tty2 có phiên giao diện đang mở từ 23/10.

## 5. Máy .64 (vps64asterisk) — Asterisk M8

- Asterisk chạy dưới uid 1654 (không phải dịch vụ hệ thống `asterisk`); SIP 192.168.1.64:5060/UDP; cổng 192.168.1.64:18089 và
  127.0.0.1:18088/18090 (ARI). Media `/srv/ivr-media`, bản sao trước khi khôi phục `/srv/ivr-media.l34-before-restore`.
  `/opt/ivr` (chủ yếu của root): `ari-link-v1`, `media-v1`, `telephony-vm`, các đợt `l34-*`, `l35-*` (15–23/10).
- Thư mục nhà: 20 thư mục làm việc M8 `ivr-l34-*`, `ivr-l35-*`, `ivr-operations-*`, `ivr-production-inspection-*`
  (15–27/10, 300 MB, phần lớn là `ivr-l34-images` 286 MB).
- **Lạ:** một thư mục ở nhà **mang tên đúng bằng mật khẩu `ssv`** (15/10), bên trong là bộ công cụ thử SIP kèm `client-secret.json`;
  và một tệp rỗng tên `ssh`. Có lẽ do gõ nhầm lệnh chép tệp.

## 6. Bảo mật

| Máy | Vấn đề |
|---|---|
| tất cả | mật khẩu `ssv` dùng chung 5 máy, đã dán vào khung chat 03/11; .64 còn có thư mục mang tên mật khẩu |
| .61 | `~/.git-credentials` (10/09): mã truy cập git dạng chữ; `~/m1-m2/audit-2509/secrets/`: khoá đăng nhập, chuỗi kết nối CSDL, mật khẩu seed |
| .64 | `client-secret.json` trong thư mục mang tên mật khẩu |
| .61, .63, .64 | microk8s, Prometheus (9090), node-exporter (9100 trên .64) mở ra mọi mạng |
| .63 | còn chỗ tạm theo README: cookie không bảo mật (LAN http), OTP giả lập hiện trong API; phải đổi trước khi mở NAT |

## 7. Đề xuất dọn

**Đã làm 03/11 (D-lead-014), dịch vụ trả lời giống hệt trước và sau:**
- lead.17–19 (.61): xoá 115 GB bộ nhớ đệm build, 78 container đã dừng, 248 tag image không dùng + image treo (giữ 14 tag `ivr-*` để M8
  quay lui; `testcontainers/ryuk:0.14.0` không xoá được). Đĩa 215 → 94 GB (21%). Vẫn 15 container chạy; 3000=307, 3001=200, 3002=307,
  5000=401, 80/health=200, 8443=403 như trước. Volume không xoá (lead.20 chưa duyệt): 10,5 GB thu hồi được.
- lead.29 (.60): xoá 11 GB bộ nhớ đệm build, container `elastic_taussig`. Đĩa 48 → 38 GB. Cổng 80 = 307 như trước, 6 container chạy.
- lead.30 (.63): xoá đích danh `relaxed_ride`, 22 tag `stg_tri_thuc` cũ (giữ 3 bản mới nhất gồm bản đang chạy), 25 image treo; không prune;
  đã ghi một dòng vào `~/staging/NHAT_KY.txt`. Image 9,5 → 5,7 GB; 8 container chạy, 8080 = 403 như trước.
- lead.21–23 (.61, D-lead-015, 10:45): xoá 47/47 bản phát hành cũ ở `~/ginsengfood` (tệp root xoá qua container tạm), 40 log, `gf-m3`,
  `m4`, `m6`, `m7`, mã/log cũ trong `m3`; chuyển audit tháng 9 (8,2 GB), 3 bản sao CSDL, 31 mục lab M8 vào `~/_luu-tru/`. Giữ
  `ivr-artifact-mirror` và `m8/ivr-operations-api-20261017` (mã M8 còn trỏ tới). Đĩa 94 → 70 GB (16%); sức khoẻ, cron, systemd như trước.
- lead.24 phần .61 (D-lead-016, 10:58): xoá `~/m3` (`manh-test` của Mạnh, 12 GB, không phải kho git, không tiến trình/container nào dùng,
  lần chạy cuối 13/10). Đĩa 70 → 59 GB (13%); sức khoẻ như trước. `gf-manh` trên .60 chưa đụng.
- lead.41 B, lead.28, lead.25 (.61, D-lead-018, 12:42–12:48): M1–M2 chuyển nguyên bản sang `~/m12`, dừng 37 giây, mọi thứ khớp bản cũ;
  tắt, xoá M7 cũ + nginx 80 (giữ volume `ginsengfood_m7-data`), 10 container `ginsengfood-*`, image bản d03 và M7 cũ; cron sao lưu trỏ
  `~/m12/sao-luu`; 6 bản dump cũ vào `~/_luu-tru/sao-luu-cu/`; xoá toàn bộ `~/ginsengfood` (gồm `module7-workspace`). Đĩa 59 → 56 GB.
  Nhà còn: `m12/`, `m8/` (8), `ivr-artifact-mirror`, `_luu-tru/`, `snap/`. 13 container chạy (5 `m12-*`, 8 `ivr-*`).
- lead.42 A (D-lead-019, 12:56): M8 trên .61 gom về một `~/m8` cùng khuôn `~/m12`; phiên m8 làm trước 09/11 (`hop-thu/m8-2026-11-03-cung-khuon-m12.md`).
- GitLab (03/11 chiều, Lead bảo làm): deploy token `may-61-keo-image` (chỉ `read_registry`, hạn 15/11/2027) cho ops-core và ivr, đăng nhập
  trên .61 ở `~/m12/.docker`, `~/m8/.docker`. Thu hồi token cũ `vps61` của ops-core (`read_repository`, không hạn; tìm trên .61, .60
  và repo máy Lead không còn chỗ dùng). Xoá runner #55111866 (tag `ivr`, chưa từng kết nối, 0 job). Ba runner máy Lead vẫn online.

| # | Máy | Việc | Ảnh hưởng | Lấy lại | Đề xuất |
|---|---|---|---|---|---|
| lead.17 | .61 | Xoá bộ nhớ đệm build Docker | không ảnh hưởng gì đang chạy; lần build sau chậm hơn | 51–115 GB | có |
| lead.18 | .61 | Xoá 78 container đã dừng; giữ cặp `*-rollback-pui022-*` và 4 job một lần của compose đang chạy (`ginsengfood-ops-core-migrate-1`, `ivr-m3-s5-migrate-1`, `ivr-m3-s5-media-init-1`, `ivr-telephony-s5-ari-1`) | không ảnh hưởng | ít | có |
| lead.19 | .61 | Sau lead.18: xoá image không còn container nào dùng + image treo | không ảnh hưởng | khoảng 18 GB | có |
| lead.20 | .61 | Xoá volume không còn container dùng (CSDL audit tháng 9, lab M8). Giữ chắc: `ginsengfood_pg-ops-data`, `ginsengfood_m7-data`, `ivr-m3-s5_*`, `ivr-telephony-s5_state` | mất dữ liệu thử cũ, không lấy lại được | khoảng 9 GB | A xoá · B giữ |
| lead.21 | .61 | Bản phát hành cũ trong `~/ginsengfood`; giữ `module7-workspace`, `n17-c2fdd2318…`, `d9-dc0d20319…`, `pui022-2110…`, `d03-2110…`, `pilot-sync-1cee9b11e…`, `ginsengfood-ops-core`, `backups` | không ảnh hưởng | 14 + 8,4 GB | A xoá hẳn · B chuyển vào `_luu-tru/ops-core-ban-cu/` |
| lead.22 | .61 | Thư mục nhà cũ + 40 log + 3 bản sao CSDL cũ (mục 2.2) | không ảnh hưởng | khoảng 10 GB | A xoá (bản sao CSDL chuyển vào `_luu-tru/sao-luu-cu/`) · B chuyển hết vào `_luu-tru/` |
| lead.23 | .61 | Lab M8 trong `~/m8` | không ảnh hưởng IVR | 200 MB | chuyển vào `_luu-tru/m8-lab-2026-10/` |
| lead.24 | .61, .60 | ~~`m3/manh-test` (12 GB, .61)~~ đã xoá 03/11 · `gf-manh` (27 GB, .60) | của Mạnh, còn thư mục sửa dở | 27 GB | .60: hỏi Mạnh, không tự xoá |
| lead.25 | .61 | ~~Tắt M7 cũ `ginsengfood-m7-mc-ai-live-1` (trùng m7.3)~~ đã tắt, xoá 03/11 (D-lead-018); nginx 80 chỉ trỏ M7 cũ nên tắt cùng | — | — | xong |
| lead.26 | .61, .63, .64 | microk8s, keepalived, Prometheus, Alloy, node-exporter (một cụm) | cần sudo; có thể đang dùng cho giám sát | RAM, cổng | hỏi Anh Tuấn; không dùng thì gỡ, dùng thì chặn cổng ra ngoài LAN |
| lead.27 | .61 | `~/.git-credentials` | mã git lộ trên máy chủ | — | bạn thu hồi mã trên GitHub rồi xoá tệp |
| lead.28 | .61 | ~~Đổi chỗ điều khiển M1–M2 sang `~/m12/`, ngang cấp `~/m8/`~~ xong 03/11 12:45 (D-lead-018) | dừng 37 giây | gọn, đúng tên | xong |
| lead.29 | .60 | Xoá bộ nhớ đệm build + container `elastic_taussig` | không ảnh hưởng | 9 GB | có |
| lead.30 | .63 | Xoá `relaxed_ride`, 4 image treo, các bản `stg_tri_thuc` cũ (giữ 3 bản mới nhất), đúng luật README (xoá đích danh, không prune) | không ảnh hưởng | 1,9 GB | có |
| lead.31 | .64 | Xoá thư mục mang tên mật khẩu (kèm `client-secret.json`) và tệp rỗng `ssh`; xoay `client-secret` nếu còn dùng | không ảnh hưởng | — | có |
| lead.32 | .64 | Gom 20 thư mục `ivr-l34/l35/operations-*` ở nhà vào `~/_luu-tru/m8-2026-10/` | không ảnh hưởng | gọn | có |
| lead.33 | .60, .63 | Chốt vai trò: .60 chạy M3 bản 17/08, .63 staging 13–16/10. Máy nào là máy chạy thử chính, máy nào chạy thật 14/11? | quyết kế hoạch triển khai M3 | — | hỏi Anh Tuấn, quyết trước 05/11 |
| lead.34 | tất cả | Đổi mật khẩu `ssv` trên 5 máy (khoá đã cài, không ảnh hưởng đăng nhập của phiên) | — | — | có, bạn tự làm |

Thứ tự làm nếu duyệt: 17 → 18 → 19, 29, 30, 31 (không rủi ro); rồi 21–23, 32; cuối cùng 20. Mỗi bước: in danh sách sẽ xoá →
chạy → `docker ps` + gọi thử các cổng đang chạy (.61: 3000/3001/3002/5000/8443; .60: 80; .63: 8080) để chắc mọi thứ còn sống.

## 8. Còn lại

- .62: xem máy có bật không, SSH có mở không; vào được thì kiểm cùng khuôn.
- Phần cần sudo (container trên .64, pod microk8s, cấu hình snap): cần Anh Tuấn hoặc Lead xem.
- Cổng vào Internet (kiểm 03/11 10:55 bằng 3 máy ngoài, check-host.net): `staging.ginsengfood.vn` → IP ngoài `14.224.139.101` → máy nginx
  của Anh Tuấn → .63:8080 (theo tin Mạnh gửi Anh Tuấn). Cổng 443 mở, trang chủ trả 302, `/api/channel/meta/webhook` trả 404 (M5 chưa từng
  chạy ở .63); cổng 80 đóng. Trong mạng công ty gọi IP ngoài bị treo (router không vòng ngược) → máy nội bộ dùng file hosts.
  Chưa kiểm được chứng chỉ và IP nội bộ của máy nginx.

## 9. Bố trí M5, M6, M7 (phân tích 03/11, chờ Lead quyết)

Lead chốt 03/11: .60 = business-platform (M3 + M4) · .61 = ops-core (M1–M2) + M8 IVR · .64 = Asterisk của IVR · .63 tạm không tính.

### 9.1 Tải hiện tại (đo 03/11 10:20)

| Máy | CPU | RAM dùng / tổng | Đĩa trống | Nhận xét |
|---|---|---|---|---|
| .60 | 10 nhân, tải 0,2 | 2,8 / 48 GB | 503 GB | gần như rảnh |
| .61 | 10 nhân, tải 0,6 | 2,1 / 14 GB | 243 GB (sau dọn thêm ~100 GB) | RAM nhỏ nhất; IVR có đợt 5.000 cuộc Giờ Vàng |
| .64 | **2 nhân**, tải 0,3 | 2,1 / 19 GB | 439 GB | Asterisk thời gian thực, không nên chạy thêm gì |

### 9.2 Ba module cần gì

| Module | Thành phần | Cỡ ước (chưa có số đo) | Nối với | Ra Internet |
|---|---|---|---|---|
| M5 cổng Facebook | 1 container Node 24 (cổng 3000) + Postgres 16 + Redis 7 riêng | 2 nhân, 4 GB (phiếu M5-004) | gọi M4 (.60) để lấy nội dung tư vấn; gọi Graph API; đẩy việc sang M7 | **bắt buộc**: Meta gọi webhook qua HTTPS có tên miền, chứng chỉ thật; URL production phải có trước 06/11 (nộp App Review) |
| M6 đo quảng cáo | 1 container FastAPI (cổng 66xx) + Postgres riêng | 1 nhân, 2 GB | đọc đơn từ M3 (.60), đọc ops-core (.61); chi phí quảng cáo nhập CSV, không gọi Meta | không cần (chỉ trang quản trị nội bộ) |
| M7 Giờ Vàng | 7 container (edge, web, api, worker, migrate, Postgres, kho tệp SeaweedFS); **dựng video chạy trên máy để bàn**, không trên máy chủ | 2–4 nhân, 4–6 GB; đĩa theo lượng video | M3, ops-core, M5, M6 | không bắt buộc (máy để bàn gọi vào qua LAN) |

### 9.3 Đề xuất

**Phương án A (đề xuất): gom theo vai trò.**

| Máy | Vai trò | Module |
|---|---|---|
| .60 | Kênh bán và tiếp thị, cổng ra Internet duy nhất | M3, M4, **M5**, **M6**, **M7** |
| .61 | Vận hành nội bộ | M1–M2 ops-core, M8 IVR (tắt M7 cũ) |
| .64 | Tổng đài | Asterisk, không thêm gì |
| .62 (nếu bật được) | Sao lưu ngoài máy + môi trường thử chung | bản sao CSDL của .60, .61; nơi thử trước khi lên máy thật |

Lý do:
- .60 rảnh 45 GB RAM, 500 GB đĩa; cả ba module mới cộng lại khoảng 10–12 GB, còn dư nhiều.
- M5 gọi M4, M6 đọc M3, M7 nối M3 và M5: đặt cùng máy thì nhanh và ít điểm hỏng mạng.
- .60 vốn phải ra Internet (web bán hàng cho khách, VNPAY gọi báo kết quả). Dùng chung một cổng vào (edge) với các tên miền hoặc
  đường dẫn riêng: bán hàng → M3; webhook Meta → M5. Chỉ một máy phải mở NAT, giữ .61 và .64 trong LAN
  (.61 chỉ cần mở trang truy xuất cho khách quét QR).
- .61 chỉ có 14 GB RAM và đang chạy hai việc quan trọng (nhà máy, gọi 5.000 cuộc). Thêm M7 bảy container ở đây là rủi ro không cần.
- Mỗi module một compose riêng, CSDL riêng, đặt giới hạn CPU/RAM từng container để module này lỗi không kéo sập module khác.

**Phương án B: giữ kế hoạch cũ của M7 (lên .61).** Đỡ sửa tài liệu M7, nhưng .61 gánh thêm trong lúc RAM ít nhất; M7 phải dùng chung
nginx của ops-core (hiện còn trỏ M7 cũ).

Điểm yếu của A: .60 hỏng là mất cả kênh bán lẫn tiếp thị. Bù lại bằng sao lưu ngoài máy (.62) và quy trình dựng lại.

### 9.4 Lead đã quyết 03/11 10:17 (D-lead-013)

lead.35 **A** · lead.36 + 37: M5 lên .60 do Tài làm theo M5-004, tin `modules/lead/ra-soat/2026-11-03-tin-tai-m5-60.md` ·
lead.39 **ok**, thư `hop-thu/m7-2026-11-03-trien-khai-60.md` · lead.38 (.62) chưa trả lời.

| # | Việc | Đề xuất | Hạn |
|---|---|---|---|
| lead.35 | Bố trí M5, M6, M7: A (tất cả lên .60) · B (M5, M6 lên .60; M7 lên .61 như kế hoạch cũ) | A | 04/11 |
| lead.36 | M5 bỏ staging riêng (phiếu M5-004 ghi .63): chạy một môi trường trên .60, khoá chạy thật tắt tới họp 13/11, thử bằng trang Facebook thử | có; nhắn Tài sửa phiếu | 03/11 |
| lead.37 | Mở Internet cho .60 (NAT, tên miền, HTTPS) cho web bán hàng, VNPAY và webhook M5; .61 chỉ mở trang truy xuất | có; nhờ Anh Tuấn, cần xong 05/11 vì M5 nộp Meta 06/11 | 05/11 |
| lead.38 | .62: bật lại, kiểm, dùng làm chỗ sao lưu ngoài máy + môi trường thử chung (hiện sao lưu ops-core nằm ngay trên .61) | có | 06/11 |
| lead.39 | Nếu chọn A: phiên `m7` sửa thiết kế (SAD §13, WP13) từ .61 sang .60 và chốt 9 điểm lệch bộ triển khai chung theo .60 | có | trước T015 (~10/11) |

Ghi chú: .60 hiện chạy bản M3 build 17/08; đưa bản mới lên .60 là việc của luồng `m34` (Phúc, Tài), cần làm trước khi gắn M5, M6 vào.
Cụm microk8s trên .61/.63/.64 (lead.26) nếu Anh Tuấn định dùng thì bố trí có thể khác; hỏi Anh Tuấn cùng lúc với lead.37.

## 10. Máy .99 (SRV Ginsengfood) — nhà máy + bán hàng (D-lead-035)

Kiểm kê chỉ đọc 13/11/2026 14:25 (+07), phiên `lead` vào bằng khoá (BatchMode, không mật khẩu), kịch bản
`2026-11-13-chuyen-may-99/kich-ban/pha1-kiem-ke-99.sh`.

| Mục | Kết quả |
|---|---|
| Máy | Ubuntu 22.04.4 LTS, nhân 5.15.0-94, máy ảo Hyper-V; tên `ginsengfood`; bật 22 giờ |
| CPU · RAM | 6 nhân Xeon Silver 4216 · 28 GB RAM (dùng 0,4 GB) · swap 10 GB |
| Đĩa | 500 GB, LVM `group0`: `/` 150 GB (dùng 3%), `/var/log` 30 GB riêng, **`/data` 280 GB ext4 riêng** (trống, chủ `root:root` 755), `/boot` 1 GB |
| Tài khoản | `ssv` uid 1000, nhóm `sudo`, `adm`, `lxd`; **sudo cần mật khẩu** (`sudo -n` = không) → phiên không tự cài được gói, không sửa `/etc`, `/data` |
| Docker | lúc kiểm kê chưa có; **nay có** (pha 2, dưới đây) |
| Giờ | múi **UTC** (giống .61: cron sao lưu M1–M2 15:00 UTC), NTP đồng bộ |
| Mạng | `eth0` 192.168.1.99/23, cổng 192.168.1.1, DNS 192.168.1.1; chỉ nghe cổng 22 |
| Tường lửa | `ufw` **tắt** (`Status: inactive`, đọc từ log pha 2; dịch vụ `ufw` chạy nhưng chưa bật luật); đã lưu sẵn một luật dải container → 18088 cho lúc bật |
| Ra ngoài | `ghcr.io` 401, `registry.gitlab.com` 401 (tới được, chờ đăng nhập), `gitlab.com`, `download.docker.com`, `archive.ubuntu.com` mở 443 |
| Nội bộ | .60: 22, 80 mở, 443 đóng · .61: 22, 5000, 8443 mở · .64: 22 mở, ping được, 18089 (ARI) **mở cho .99 13/11 16:08** (nginx cầu ARI `allow` + ufw, Toàn chạy `2026-11-13-chuyen-may-99/kich-ban/mo-64-cho-99.sh`; từ .99: TCP mở, HTTPS không chứng thư khách → 400 đúng) · .98: 22 mở |
| Đang chạy | dịch vụ mặc định Ubuntu (ssh, cron, snapd, lxd snap, unattended-upgrades); không cron của `ssv`; nhà `ssv` trống |

**Nền đã dựng 13/11 14:49** (lead.83 A: Toàn chạy `sudo bash ~/nen-99/pha2-nen-docker-99.sh`, log `~/nen-99/pha2.log`; phiên kiểm bằng khoá 14:51):

| Mục | Kết quả |
|---|---|
| Docker | Docker CE **29.9.3** (kho download.docker.com), **Compose v5.7.1** (≥ 2.23.1 gói m34 cần); `docker`, `containerd` bật cùng máy |
| containerd | kho image containerd (giống .60/.61 Docker 29.6.1) dời **`/data/containerd`** (pha 2c 15:20, `root =` trong `/etc/containerd/config.toml`); kéo thử image 70 MB: `/data` +71 MB, ổ gốc không đổi; `/var/lib/containerd` không còn |
| `daemon.json` | `data-root /data/docker`, log json 50 MB × 5, `live-restore`, dải tự cấp `172.24.0.0/14` (không đụng mạng ghim 172.31.61/24 m12, 172.31.251/28 m34, 172.29 m8) |
| `/data` | theo tên repo (D-lead-037): `/data/ginsengfood-ops-core`, `/data/ginsengfood-business-platform`, `/data/ginsengfood-ivr`, `/data/sao-luu/<repo>`, chủ `ssv` 750, thư mục thật; nhà `ssv` không còn liên kết hay `~/nen-99` (15:09). Pha 2 tạo tên `m12`/`m34`/`m8`, 15:09 phiên đổi `/data/sao-luu/*`; ba thư mục gốc chờ Toàn `sudo mv` |
| `ssv` | vào nhóm `docker` (dùng docker không sudo); sudo vẫn cần mật khẩu |
| Chặn cổng | dịch vụ `gf-tuong-lua` (chuỗi DOCKER-USER, bảng `/etc/ginsengfood/cong-noi-bo.conf`): 80, 8012 cho LAN 192.168.0.0/23 · 5000 cho .60, .98 · 8443 cho máy Lead 192.168.0.64 · 8446 cho .98 (M5 gọi cửa TLS m5cua) · hai dòng tạm .60 → 8443, .61 → 8445 **đã gỡ 16/11 11:02** (D-lead-046, kiểm `sau` = DAT; chi tiết ở `2026-11-11-ten-mien-may-chu-chinh-thuc.md` dưới bảng cổng LAN); còn lại chặn kết nối mới từ LAN |
| Thử chặn | container tạm `nginx:1.27-alpine` công bố 8012/8443/5000/18080: từ máy Lead 8012 = 200, 8443 = 200, 5000 hết giờ, 18080 hết giờ; container trên .99 gọi `192.168.1.99:5000` = 200. Đã xoá container và image, máy sạch |

Đổi bảng cổng: sửa `/etc/ginsengfood/cong-noi-bo.conf` rồi `sudo systemctl restart gf-tuong-lua` (cần mật khẩu: Toàn). Kịch bản gốc ở
`2026-11-13-chuyen-may-99/kich-ban/`.
