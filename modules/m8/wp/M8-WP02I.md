# M8-WP02I — Tổng đài .64 lên bản mới, secret media-sync .99 → .64

Trạng thái: ĐANG LÀM (soạn kịch bản; chưa ghi gì lên .64) · Rủi ro: R3 (máy tổng đài, bí mật, gián đoạn) · Chế độ: A (kịch bản trên bản sao; chạy trên máy do phiên chính, Toàn gõ sudo) · Mốc: 18–19/11
Hạng mục nâng: Cài lên máy chủ (đích .99 + .64) 50 → 75; mở đường cho 01D, 05 (MobiFone ~24/11) · Sheet: M8-015 · Ước lượng: 14 giờ
Chỗ làm: phiên chính (không subagent vào máy) · Base SHA: `aeb486eb` · Quyết định: D-m8-122 (m8 tự làm, Toàn gõ sudo), D-m8-131 (chạy chiều 18/11 khi Toàn duyệt kịch bản), D-m8-010/124 (custody).

## Kiểm kê .64 chỉ đọc (18/11 08:3x, ssh `ssv@192.168.1.64` bằng khoá, không sudo)

- Ubuntu 22.04.4, 2 CPU, 19 GB RAM, đĩa 439 GB trống; chạy liên tục 33 ngày (từ ~15/10). Có microk8s (cụm chung .61/.63/.64, không phải của mình).
- `ssv` thuộc nhóm `sudo` nhưng không thuộc `docker` → mọi lệnh docker cần sudo. Không có crontab của `ssv`.
- Tiến trình (đọc `ps`): container `Ivr.MediaReceiver.dll` (uid 1654, chạy từ ~15/10); container nginx (chạy từ ~15/10, worker nạp lại ~13/11 16:08 = lúc mở ARI cho .99); container `asterisk -f` (uid 1654, chạy từ ~23/10).
- Cổng nghe: `192.168.1.64:18089/tcp` (cầu ARI), `192.168.1.64:5060/udp` (SIP).
- `/opt/ivr` (700): `input/` của `ssv` (15/10: `media-token`, `ari-tls/`, `ari-secret.json`, `settings.json`, `link-settings.json`, `media-settings.json` — không đọc nội dung); thư mục root: `ari-link-v1` (13/11), `telephony-vm` (15/10), `media-v1`, `l34-*`, `l35-*` (bằng chứng lab 15–23/10), `private-services-evidence.json`.
- Không đọc được tên/ảnh container, compose project, tường lửa khi không sudo → bước 0 của kịch bản (Toàn gõ sudo) đọc trước.

## "Bản mới" và cách làm (scout 18/11, nguồn trong repo `aeb486eb`)

- .64 cài L34 15/10 (release `8c8ee050…`, `vm_deploy.py` từ `43000556`); 27/10 chỉ là ngày kiểm kê. 3 project: `ivr-telephony-vm` (Asterisk 22.10.1, ảnh `84a2e183…`), `ivr-media` (MediaReceiver), `ivr-ari-link-vm` (nginx cầu 18089, `/ari/` + `/media-sync/v1/`).
- Khác biệt tới `aeb486eb`: config Asterisk, dialplan, `link_bundle.py`, `media_bundle.py`, mã `Ivr.MediaReceiver` KHÔNG đổi. Đổi: Asterisk **22.10.1 → 22.11.0** (`deploy/docker/Dockerfile.asterisk`, khoá gói W-0506/W-0537; lab nâng + quay lui 17/10 `deploy/release-candidate/evidence/20261017/lab.json`), `vm_deploy.py` (+ hợp đồng stack `m8-wp02d-stack-v1`), ảnh nền receiver (.NET 10.0.15). Chưa có bằng chứng `vm_deploy` mới nâng từ release cũ.
- Secret: `du-lieu` .99 chép nguyên từ .61 → giá trị đã khớp .64 (ARI 401 qua cầu 13/11, đồng bộ cụm từ PUT 200 14/11). Việc "secret media-sync .99 → .64" còn lại = xác minh KHỚP (bước 0), không chép mới. Chứng thư lá ARI hết hạn 13/01/2027 (thay trước ~14/12, nợ).
- Phạm vi 02I hôm nay: **Asterisk 22.11.0 qua `vm_deploy.py`** (listener đóng, `carrier_configured:false`; trunk MobiFone là runbook L35 riêng). Receiver giữ ảnh cũ (mã không đổi) — nâng ảnh nền receiver ghi nợ.

## Kịch bản (mỗi bước Toàn gõ sudo; dừng giữa các bước để xem kết quả)

- **Bước 0 — chỉ đọc** ([`ra-soat/kich-ban-64-1811/buoc0.sh`](../ra-soat/kich-ban-64-1811/buoc0.sh), đã chép `/tmp/kiem64`, sha256 `7f14ab88…`): container/ảnh/compose, phiên bản + số kênh + endpoint Asterisk, `state.json`/release, tham số `settings.json` (ẩn bí mật), quyền tệp bí mật, hạn chứng thư, so sha256 với .99 chỉ in KHỚP/LỆCH, ufw/nginx allow/cổng, chỗ trống. Tự xoá `/tmp/kiem64`.
- **Bước 1 — chuẩn bị, không đổi dịch vụ:** dựng ảnh `Dockerfile.asterisk` (22.11.0) trên máy Lead (cùng lượt quét trước push của W-0549, `--keep-images`), `docker save | ssh .64 sudo docker load`, ghi image ID; chép `deploy/telephony-vm/` của `aeb486eb` sang `/opt/ivr/telephony-vm-src-aeb486eb`; tạo `settings-2211.json` = bản sao `settings.json` đổi `asterisk_image_id` + `asterisk_version`; chạy `vm_deploy.py plan` + `preflight` (không ghi).
- **Bước 2 — đổi dịch vụ (chỉ khi bước 1 sạch, Toàn duyệt riêng):** sao lưu media + SQLite (`l34/media_snapshot.py`), `prepare` → `apply` (từ chối nếu còn cuộc gọi/endpoint) → `verify` (0 kênh, ARI 401/200, version 22.11.0); đo thời gian Asterisk gián đoạn; từ .99 kiểm cầu ARI 401 + đồng bộ cụm từ. Hỏng → `vm_deploy.py rollback` (về `previous`). Không có cuộc gọi nào (gọi thật NO, worker .99 chỉ MOCK) nên giờ nào cũng là giờ ít gọi; tránh khung E02/E03 tối nay.

## Kết quả bước 0 (18/11 08:47, Toàn gõ sudo; chỉ đọc, đã xoá `/tmp/kiem64`)

- Asterisk **22.10.1**, container `ivr-telephony-vm-asterisk-1` tạo 23/10 08:53, healthy, restart 0, ảnh `84a2e183…`; **0 kênh, 0 cuộc, không endpoint** (đủ điều kiện `apply`). `ivr-ari-link-vm-ari-1` + `ivr-media-receiver-1` từ 15/10. Compose: `ivr-telephony-vm` (release `8c8ee050…`), `ivr-media`, `ivr-ari-link-vm`; Docker Compose v5.6.0, Python 3.10.12.
- `state.json`: `current=8c8ee050…`, `previous=None`, không `pending.json`. `settings.json`: dedicated-vm, bind `192.168.1.64`, `192.168.0.0/23`, 1 CPU, 1024 MB, bank `0a427c7e…`, SIP TLS tắt.
- Bí mật (chỉ so sha256): `input/media-token` = .99 KHỚP; `input/ari-secret.json` = .99 KHỚP; CA chéo đúng cặp (.99 own-ca = .64 peer-ca "IVR-ARI-Client-CA", .99 peer-ca = .64 own-ca "IVR-ARI-Server-CA"). `media-v1/token` LỆCH chỉ vì `media_bundle.py` lưu bản `strip()` (bỏ xuống dòng; trên .99 token có xuống dòng, bản strip bằng nhau) → khớp nội dung. Quyền đúng (`media-v1` root 700, tệp 444; `input` ssv 700/600). Chứng thư lá `ivr-ari.internal` hết hạn **13/01/2027**; 2 CA tới 15/10/2027.
- Mạng: ufw 18089 cho .61 và .99, nginx `allow .61; allow .99; deny all`; **ufw 5060 ALLOW Anywhere** (cả v6) — dialplan carrier đóng (Hangup) nhưng cổng mở cho mọi nguồn → nợ: thu hẹp về dải MobiFone khi làm 05. Cổng: 5060/udp .64, 18088/18090 loopback, 18089 .64. Đĩa trống 439 GB; `/srv/ivr-media` 170 MB.
- `docker image ls` không in gì (định dạng lệnh), không ảnh hưởng.

## Kết quả bước 1 (18/11 10:26 giờ máy .64, Toàn gõ sudo; không đổi dịch vụ)

- sha256 gói khớp; `docker load` ảnh `sha256:10625b95…` (= ID máy Lead), user 1654, `Asterisk 22.11.0`; mã `vm_deploy.py` `aeb486eb` ở `/opt/ivr/telephony-vm-src-aeb486eb` (root 700, sha256 `f9711766…`); `settings-2211.json` chỉ đổi `asterisk_image_id` + `asterisk_version`.
- `vm_deploy plan` → `CONFIG_VALID_NO_MUTATION`; `preflight` → `PREFLIGHT_PASS`. Dịch vụ đang chạy y nguyên (Asterisk 22.10.1, `current=8c8ee050…`). `/tmp/kiem64b` đã xoá.

## Bước 2 (soạn, chờ Toàn duyệt) — [`buoc2.sh`](../ra-soat/kich-ban-64-1811/buoc2.sh), đã chép `/tmp/kiem64c` (sha256 `03043e61…`)

1. Dừng nếu còn cuộc gọi. 2. Sao lưu `/opt/ivr/telephony-vm` + volume `ivr-telephony-vm-state` + luật ufw vào `/opt/ivr/sao-luu-02i/<giờ>` (root 700). 3. `vm_deploy apply` với `settings-2211.json` (chỉ tạo lại container Asterisk, chờ healthy ≤ 60 s; đo thời gian). 4. `verify`. 5. `settings.json` → bản 22.11.0 (giữ `settings-22101-truoc-02i.json`). 6. ufw: thêm `5060/udp` từ `42.1.66.131` → `192.168.1.64`, xoá `5060 ALLOW Anywhere` (v4+v6) (D-m8-137 a). Lỗi ở 3/4 → dừng, Toàn quyết `lui` (`vm_deploy rollback` + trả luật ufw). Sau đó phiên chính từ .99 kiểm cầu ARI (401 không xác thực) + đồng bộ cụm từ (chỉ đọc).
- Không đụng receiver/cầu ARI. Nguồn SIP thật của MobiFone sau NAT router chưa kiểm (nếu router đổi IP nguồn thì sửa luật ở 05); RTP 10000–10999 chưa có luật ufw riêng — kiểm `ufw status verbose` (chính sách mặc định) trong bước 2, xử lý ở 05.

## Diễn biến (mỗi vòng một dòng, mới nhất ở cuối)
- 18/11 08:3x phiên chính: kiểm kê chỉ đọc như trên; scout gom dữ kiện repo (bản mới gồm gì, công cụ cài, secret, quay lui) chạy nền.
- 18/11 ~08:46 scout xong (tóm ở mục trên); phiên chính soạn bước 0, lấy sha256 tệp bí mật .99 (không in), chép `buoc0.sh` + `mong-doi.sha256` (600) vào `/tmp/kiem64` trên .64; mở tab terminal "02I buoc 0 .64" chờ Toàn gõ sudo.
- 18/11 08:47 bước 0 chạy (Toàn gõ sudo; giờ máy .64 01:47Z): kết quả ở mục trên, không đổi gì. Soạn `buoc1.sh` (nạp ảnh 22.11.0, mã `vm_deploy` `aeb486eb`, `settings-2211.json`, `plan` + `preflight`); ảnh lấy từ lượt quét trước push W-0549 `--keep-images` đang chạy.
- 18/11 10:26 (giờ .64) bước 1 ĐẠT: nạp ảnh 22.11.0, `plan` + `preflight` PASS, dịch vụ không đổi. Soạn + chép `buoc2.sh`; chờ Toàn duyệt bước 2.

## Bước kế tiếp chính xác
Toàn duyệt bước 2 → mở tab `ssh -t ssv@192.168.1.64 "sudo bash /tmp/kiem64c/buoc2.sh"` → đọc kết quả → kiểm từ .99 (cầu ARI, đồng bộ cụm từ) → ghi W bằng chứng + Sheet M8-015. Tránh khung E02/E03 19:40–21:05.

## Còn lại / CẦN QUYẾT
