# R1 — Chuẩn bị chuyển M8 trên .61 sang ~/m8, 09/11/2026

Cập nhật09/11 18:47 +07: **đã deploy LAB .61 và diễn tập quay lui đạt**; xem [kết quả hiện hành](2026-11-09-deploy-m8-61-ket-qua.md). Các bảng kiểm kê/“chưa chạy” dưới đây giữ mốc chuẩn bị17:25, không phải hiện trạng. Nguồn `140bcb48a27e9dcda947243a965a85b29f41a519` trên main. Runbook không thay mã R3, không nghiệm thu candidate/production; `REAL_CUSTOMER_CALL_ALLOWED=NO`, scheduler tắt, .64 ngoài phạm vi.

Tác giả R1 chỉ đối chiếu nguồn công khai; tình trạng host/CI dưới đây là kết quả phiên chính cung cấp ngày 09/11, không phải một lượt kiểm host độc lập của tác giả. Không thực thi các lệnh trong tài liệu khi chưa qua đúng cổng và chưa có người thực hiện có quyền.

## 1. Bản kê đã biết và phần còn thiếu

| Đối tượng | Kết quả phiên chính | Ý nghĩa / việc còn lại |
| --- | --- | --- |
| Repo | `main` ở SHA trên; chỉ báo cáo tuần đang thay đổi | Giữ WIP; không dùng cây làm việc làm nguồn gói deploy |
| SSH `.61` | `ssv@192.168.1.61` hoạt động | Đây là quyền phiên chính, chưa chứng minh khóa CI mới hoạt động |
| Khuôn mới | Root `~/m8` chưa có `compose.yml`, `trien-khai.sh`, `.env`, `du-lieu` | Chưa bootstrap project `m8`; không bấm job deploy lúc này |
| Cụm cũ | Bốn project và hai unit systemd còn chạy | Phải lập receipt trạng thái/restart/enable trước khi dừng |
| Sudo | `sudo -n true` báo cần mật khẩu | **Phụ thuộc còn mở:** Lead/người quản trị .61 cấp phiên sudo thực hoặc trực tiếp chạy các lệnh đã duyệt; không dùng Docker/socket để vượt sudo |
| Nguồn dữ liệu | 22 đường dẫn nguồn theo README tồn tại; `api.json` UID1654 mode400, `ssv` không đọc được | Tồn tại chưa đủ: cần kiểm mọi file con, chủ/quyền, dung lượng và lỗi sao chép bằng quyền hợp lệ |
| Docker dành riêng | `~/m8/.docker/config.json` mode0600; đúng `DOCKER_CONFIG` kéo manifest target thành công; Compose5.3.1 | Lỗi403 của cấu hình Docker mặc định đã loại khỏi bằng chứng này |
| Image target | API, worker, migrate, ops-agent của SHA140 đã pull, linux/amd64 | Chưa khởi động container; còn đối chiếu digest với artifact CI và giữ ID image baseline |
| Volume/mạng | Ba volume external và gateway `172.29.0.1` đúng | Giữ nguyên; không tạo volume thay thế, không xóa mạng |
| HTTPS | Probe từ `.61` trả403; log xác nhận client `192.168.1.61` | Chỉ thêm `allow 192.168.1.61;` vào **bản sao nginx mới**, trước `deny all`; giữ nguyên bản cũ |
| PostgreSQL | Vai `ivr` là superuser | Giữ quyền hiện có trong lượt này; tuyệt đối không suy ra an toàn để tự restore hoặc hạ schema |
| GitLab | UI chưa đăng nhập, helper API401 | **Phụ thuộc còn mở:** Lead đăng nhập (m8.66); không giả có quyền tạo Variables/environment hoặc xem artifact |
| Khóa CI | Đã chuẩn bị cặp khóa riêng và known_hosts; chưa install/upload | Private chỉ ở Windows `.ssh`; không đưa nội dung vào tài liệu, Git hoặc chat |

Gói public đã stage ở `.61`: `~/m8/chuan-bi-20261109-140bcb48/{compose.yml,trien-khai.sh,env.mau,source.json}`; phiên chính đã so hash và kiểm cú pháp shell. Đây **chưa** là các tệp active tại root `~/m8`. Receipt public: `C:\Projects\_wt\m8\deploy-20261109\public-bundle\source.json`. Receipt chuẩn bị khóa: `C:\Projects\_wt\m8\deploy-20261109\ci-key-preparation.json`.

Parent đã chuẩn bị script public `sudo-copy-m8-data.sh`: chỉ `cp -a` 21 nguồn vào `~/m8/chuan-bi-20261109-140bcb48/du-lieu`, không copy `runtime.env`, không stop/disable/cutover. Parent đã SCP script public, kiểm `bash -n` và SHA256 trên .61 đạt; **chưa chạy sudo/script**. Đây là bước staging cần sudo hợp lệ, chưa có kết quả copy. Dữ liệu có writer ở staging vẫn phải được chép/đối chiếu lần cuối sau khi dừng writer trước khi dùng làm active; không lấy bản pre-copy còn sống làm snapshot nhất quán. Tài liệu không cấp quyền tự chạy script hoặc chuyển staging thành active.

## 2. Bốn cổng trước và trong lượt triển khai

| Cổng | Điều kiện phải có | Bằng chứng cần ghi; chưa đủ thì dừng ở đâu |
| --- | --- | --- |
| G1 — Quyền và đường CI | LAB đã kiểm: đăng nhập GitLab, main Protected, hai File variables Protected/scope m8-61/expansion off, restricted public key, fingerprint host và sudo hợp lệ. Protected environment chưa có trong UI, giữ gate trước production | m8.68 duyệt tạo biến/tiếp tục deploy LAB. Không nhận đã bảo vệ environment hoặc đã đạt quyền production. Chỉ ghi metadata/fingerprint, không giá trị biến |
| G2 — Nguồn và khả năng phục hồi trước cut | Pipeline/image/scan của đúng SHA đã đối chiếu; bốn image target có ID/digest; image baseline còn đủ; manifest public khớp; kiểm toàn bộ nguồn/bind/quyền; dump CSDL cũ đã kiểm; effective calling/scheduler cũ đang tắt, không còn cuộc gọi đang chạy | Receipt nguồn/ID/digest, kiểm dump không in dữ liệu, trạng thái writer/queue/call và kế hoạch rollback. Không dùng artifact SHA khác hoặc chỉ tên tag để cho qua |
| G3 — Bootstrap m8 giữ bản S5 | Có khung dừng và người rollback; dừng writer/cụm cũ, chép dữ liệu cuối đúng UID; nginx mới hợp lệ; lên `m8` với **nhãn baseline S5 riêng**; kiểm đủ dịch vụ và quay lại cũ nếu lỗi | Bắt đầu/kết thúc downtime, image/mount/network/UID/health/ARI/ops, flags tắt. `M8_BAN` không được điền SHA140 ở bước này. Qua G3 mới cho job CI chạy |
| G4 — Deploy exact SHA qua CI | G1–G3 đã có receipt; deploy job của pipeline đúng SHA có đủ needs xanh; chạy duy nhất một lượt; so kết quả host sau job và kiểm rollback có chủ đích trong khung đã cho | Exit/log trên host, PHIEN_BAN, effective image IDs/RepoDigests, dump trước migration, schema/health và gọi thật vẫn NO. Job xanh hoặc dòng “bản đang chạy rồi” riêng lẻ không đủ xác nhận |

`M8_AUTO_DEPLOY` giữ unset/khác `YES` trong chuẩn bị và bootstrap. `deployment_tier: production` trong YAML GitLab là nhãn môi trường của job, không phải nghiệm thu production.

## 3. G1 — Thiết lập CI và khóa chỉ được deploy

1. Lead đăng nhập GitLab đúng project `nqt20102001/ginsengfood-ivr`; quyền quản lý Variables và main Protected đã kiểm. Job chạy trên main140.
2. Environment tên `m8-61` đã có; UI hiện không có Protected environments. Đây là tính năng Premium/Ultimate theo [GitLab](https://docs.gitlab.com/ci/environments/protected_environments/). Trong phạm vi LAB được Lead cho triển khai, giữ main Protected + File variables Protected/scoped + restricted SSH. Không nhận đã cấu hình Protected environment; phải chốt quyền deploy theo môi trường trước production.
3. Settings → CI/CD → Variables: tạo **Type=File**, **Protected=true**, environment scope **`m8-61`** cho hai key:
   - `M8_DEPLOY_SSH_KEY`: lấy nội dung private key đã chuẩn bị ở `%USERPROFILE%\.ssh\gfivr_ci_m8_61_ed25519` qua kênh riêng của Lead. Không in, không dùng giá trị đường dẫn Windows làm nội dung variable.
   - `M8_DEPLOY_KNOWN_HOSTS`: lấy nội dung `%USERPROFILE%\.ssh\gfivr_ci_m8_61_known_hosts`; đối chiếu fingerprint với receipt host đã tin cậy. Không chấp nhận khóa mới chỉ dựa vào một lượt keyscan chưa đối chiếu.
   Giữ variable expansion tắt; không nới kiểu/protection chỉ để job nhận được biến. Ghi receipt **metadata**, không chụp hoặc log giá trị. Khóa OpenSSH nhiều dòng có thể không đáp ứng điều kiện masking; Type File và quyền/protection phải đúng, không ép masked bằng cách đổi dữ liệu khóa.
4. Cài **public key tương ứng** vào `~ssv/.ssh/authorized_keys` bằng quyền hợp lệ; giữ các key hiện có, không thay nguyên tệp. Dòng mới phải có `restrict` và forced command chỉ gọi `/home/ssv/m8/trien-khai.sh`; không cấp interactive shell, forwarding, PTY, agent/X11 forwarding hay user-rc.
5. Mẫu README mục4 chỉ lấy token cuối của `SSH_ORIGINAL_COMMAND`, nên giới hạn executable nhưng chưa kiểm nguyên lệnh hoặc bắt buộc SHA40. Bản public `authorized-key-proposed.txt` của parent đã đối chiếu escape theo mẫu này, **chưa cài**. Giữ tham số được quote, để script kiểm dạng; không `eval` hoặc chạy trực tiếp `SSH_ORIGINAL_COMMAND`. CI truyền SHA40 và receipt phải đối chiếu đúng SHA/digest, không mô tả mẫu hiện tại là allowlist từng commit. Nếu cần siết toàn bộ lệnh và SHA40, đó là thay đổi hẹp phải review riêng, không tự thêm wrapper trong lượt chuẩn bị. Nhãn S5 là thao tác của phiên chính. Cài forced command và kiểm hạn chế quyền thuộc phiên chính; chưa có kết quả thì G1 chưa đóng.
6. Chưa dùng một lệnh deploy thật để thử khóa khi G2/G3 chưa qua. `DEPLOY_NOT_CONFIGURED` hiện chỉ nói biến không trỏ tới file trong job; sau cấu hình vẫn cần xác minh job nhận biến đúng scope và SSH dùng đúng key. Không in nội dung file để chẩn đoán.

## 4. G2 — Đóng nguồn, baseline và dump trước bootstrap

### Nguồn image/public

- Pipeline phải gắn đúng `140bcb48a27e9dcda947243a965a85b29f41a519`, các needs của `deploy_m8_61` xanh: `publish_images`, `dotnet`, `pii_scan`, `governance`, `security_scan`, `api_contract_diff`, `observability_rules`, cùng `tts_candidate_selftest` nếu pipeline có job này. Registry có image không có nghĩa mọi test đã xanh.
- Lấy `ci-artifacts/cd/digests.txt` và artifact scan/image của **pipeline đó**. So bốn repository `ivr-api`, `ivr-worker`, `ivr-migrate`, `ivr-ops-agent`, tag SHA40, digest, OS/architecture với bốn image đã pull. Ghi actual image IDs và RepoDigests; không chép giá trị giả vào receipt. Những auxiliary image vẫn dùng pin S5 hiện có, không tự đổi TTS/Asterisk/Prometheus theo một job auxiliary mới.
- So lại hai tệp public active dự kiến với `source.json` đã stage và nguồn commit. CI chỉ đổi image, không tự cập nhật script/Compose trên host. Tệp `env.mau` là mẫu để phiên chính cấu hình private trên host, không phải cấu hình đủ để chạy.
- Kiểm Docker trong đúng `DOCKER_CONFIG=/home/ssv/m8/.docker`; giữ registry credential ngoài chứng cứ. Kiểm bash, curl, flock, GNU coreutils timeout với `--kill-after`, quyền Docker, dung lượng cho image + dump + dữ liệu chép và khả năng Compose `--wait`.

### Baseline thực tế và nguồn → đích

Chụp baseline từ container đang chạy: project/container ID, image ID/reference, command, mounts, cổng, restart policy, network/alias; hai unit ghi active/enabled trước thay đổi. Kiểm effective env bằng phương pháp không xuất secret. Các đường dẫn dưới đây là bản đồ từ README; 22 đường dẫn đã được phiên chính kiểm tồn tại, còn phải kiểm file con/quyền và nguồn đang được container dùng.

Đặt `S5=/home/ssv/m8/ivr-m3-s5/76d44d3faf72ae423a0abae4d3664052c4fd8e26`, `L34=/home/ssv/m8/ivr-l34-app-20261015-r1`; đích đều dưới `/home/ssv/m8/du-lieu/`.

| Nguồn | Đích | Lưu ý |
| --- | --- | --- |
| `$S5/bank` | `bank/` | api/worker/asterisk đọc |
| `$S5/private/api.json`, `$S5/private/api.env` | `api/appsettings.json`, `api/api.env` | giữ owner/mode; api.json UID1654 mode400 cần sudo để chép |
| `$S5/private/db.env` | `postgres/db.env` | dùng volume PG hiện có, không tạo DB mới |
| DB connection trong cấu hình runtime cũ | cấu hình private root `~/m8/.env` | xác minh DSN đúng DB hiện có; không in/copy vào receipt |
| `$L34/cutover-v1/worker.json`, `media-token` | `worker/appsettings.json`, `worker/media-token` | giữ mount và quyền đọc UID1654 |
| `$S5/private/worker.env` + override đang hiệu lực | `worker/worker.env` | effective scheduler/calling vẫn tắt; không chỉ chép base env rồi mất override |
| `/home/ssv/m8/w0402-20260929-render-01/models-readable` | `models/` | giữ model baseline, đủ dung lượng |
| `$S5/voice-acceptance-manifest.json` | `tts/voice-acceptance-manifest.json` | ghim đúng model/voice hiện hành, không tự nghiệm thu voice |
| `$S5/nginx.conf`, `$S5/private/tls` | `nginx.conf`, `tls/` | chỉ bản nginx mới thêm allow .61; TLS giữ private |
| `/home/ssv/m8/telephony-s5-20261012/private/asterisk` | `asterisk/` | giữ config/trunk, không mở gọi thật |
| `$L34/ari-link-v1/nginx.conf`, `tls` | `ari/nginx.conf`, `ari/tls/` | giữ alias asterisk và gateway ARI |
| `/home/ssv/m8/ivr-operations-prometheus/config`, `data` | `prometheus/config/`, `prometheus/data/` | final copy sau khi Prometheus dừng; UID1000 |
| `/home/ssv/m8/ivr-operations/settings.json` | `ivr-operations/settings.json` | sửa **bản mới** theo đường dẫn/container names phía dưới |
| `/home/ssv/m8/ivr-operations/state`, `private`, `input` | `ivr-operations/state/`, `private/`, `input/` | final copy state sau khi hai unit dừng; không ghi hash/nội dung private |
| `$L34/input` | `l34-input/` | giữ credential private và quyền đọc của ops-agent |

Volume giữ nguyên `ivr-m3-s5_pg`, `ivr-m3-s5_phrases`, `ivr-telephony-s5_state`; mạng external `ivr-m3-s5_sandbox`, gateway `172.29.0.1`. Không chép PGDATA bằng cp khi PG còn chạy, không tạo volume mới cùng mục đích. `M8_DOCKER_GID` phải khớp nhóm socket thực tế, không tin mặc định999. Quyền đọc theo UID1654/101/1000 như README, không `chmod -R` mở rộng quyền hoặc `chown -R` đồng loạt để né lỗi.

Bản mới `ivr-operations/settings.json`: `state_dir=/srv/ivr-operations/state`; các receipt/input trỏ `/srv/ivr-operations/input/...`; private SSH trỏ `/srv/ivr-operations/private/...`; TLS VM trỏ `/srv/l34-input/...`; container names `m8-api-1`, `m8-worker-1`, `m8-phrase-tts-1`, `m8-postgres-1`. Giữ nguyên settings cũ để rollback.

**Trước khi bắt đầu downtime:** dùng sudo hợp lệ pre-copy riêng cấu hình nginx/TLS bất biến sang khu mới, giữ owner/mode; sửa bản nginx mới thêm `allow 192.168.1.61;` trước `deny all` theo IP client đã được log xác nhận. Giữ hai allow cũ và nguồn cũ nguyên trạng. Phiên chính chạy `nginx -t` với đúng image, config và TLS mounts mới trong preflight không chiếm cổng. Chỉ metadata PASS/FAIL được ghi vào receipt. Chưa kiểm được hoặc lỗi thì chưa dừng cụm cũ. Khi chép dữ liệu cuối, không chép đè bản nginx mới đã kiểm bằng bản nguồn chưa thêm allow.

### Dump trước khi dừng S5

1. Xác nhận writer/scheduler/calling đang ở trạng thái dự kiến; không còn cuộc gọi đang chạy. Chốt container Postgres cũ, database/user thực tế từ kiểm kê; tên trong README là `ivr-m3-s5-postgres-1`, DB/user `ivr`, phải đối chiếu trước dùng.
2. Trong thư mục private backup riêng, umask077, tạo dump timestamp từ **Postgres cũ đang chạy** bằng `pg_dump -U ivr -d ivr -Fc --lock-wait-timeout=60s`; kiểm exit0, file không rỗng, `pg_restore --list` đọc được và có mục. Không dùng `trien-khai.sh` để tạo dump này vì postgres của project `m8` chưa chạy.
3. Giữ dump ngoài gói public/Git/evidence; receipt chỉ ghi kết quả kiểm, vị trí private đã quy ước, dung lượng/thời điểm và đối soát nghiệp vụ đã làm sạch. `pg_restore --list` là kiểm định dạng, **không** gọi là diễn tập restore thành công. Nếu cần đối soát ledger/watermark, ghi dữ liệu đã làm sạch; không đưa nội dung DB vào log.
4. Dump lỗi, hết dung lượng hoặc không đọc được: dừng trước cut. Nếu trong khoảng tới cut có writer chạy lại thì cần dump cuối sau khi dừng writer nhưng trước khi dừng Postgres. Không để hai Postgres cùng gắn volume khi bootstrap/rollback.

## 5. G3 — Bootstrap project m8, chưa đổi phiên bản ứng dụng

1. Chốt khung dừng và người có sudo; ghi giờ bắt đầu, ngưỡng hủy và người rollback. Mốc ≤10 phút trong WP là dự toán, không hứa thời lượng khi chưa đo TTS/bootstrap trên host.
2. Đặt nhãn baseline S5 riêng, ví dụ `s5-baseline-20261109`, sau khi chắc nhãn chưa tồn tại hoặc đã trỏ đúng ID đã chụp. Gắn các image API/worker đang chạy vào tên `${M8_KHO}/ivr-api:<baseline>` và `ivr-worker:<baseline>`. Baseline ops-agent là image đã duyệt để thay hai unit; ghi rõ ID đó có nguồn từ target140, không mô tả cả baseline là một release SHA thuần nhất. Auxiliary giữ ID/reference cũ. Migrate thuộc profile, không chạy ở bước bootstrap.
3. Tạo root `~/m8/compose.yml`, `trien-khai.sh` từ public stage đã kiểm, giữ hash đúng nguồn; mode script750. Tạo cấu hình private root mode600 bằng kênh trên host, **`M8_BAN=<baseline S5>`**, không phải SHA140. Chỉ lập PHIEN_BAN baseline sau khi baseline đã thật sự lên và kiểm xong; không dùng metadata để tự chứng minh runtime.
4. Dừng hai unit `ivr-operations.service`, `ivr-operations-metrics.service` bằng sudo và vô hiệu tự khởi động trong thời gian chuyển. Dừng các writer/application cũ; thực hiện dump cuối nếu cần; dừng bốn project `ivr-m3-s5`, `ivr-telephony-s5`, `ivr-ari-link-app`, `ivr-operations-prometheus` bằng Compose với **đúng file/project đã kiểm kê**. Không chỉ dùng `-p` từ thư mục mới rồi vô tình lấy compose mới. Không `down`, không `down -v`, không prune. Ghi/đổi restart policy cũ cần thiết để reboot không dựng hai cụm cùng lúc; giữ giá trị cũ cho rollback.
5. Sau khi writer/Prometheus/units đã dừng, chép dữ liệu bằng quyền sudo hợp lệ, `cp -a` từng nguồn → đích theo bảng; có thể đã pre-copy tệp bất biến nhưng dữ liệu có writer phải chép cuối ở thời điểm này. Đích là khu mới, không di chuyển/xóa nguồn. Đối chiếu số lượng tệp cần thiết, chủ/nhóm/mode và khả năng đọc theo UID; receipt không chứa secret hoặc hash secret. Kiểm đủ bind paths trước `up`.
6. Giữ bản `du-lieu/nginx.conf` đã qua `nginx -t` trước downtime ở G2: chỉ thêm `allow 192.168.1.61;` trước `deny all`, giữ allow `.60` và `192.168.0.64`. IP `.61` đã được log parent xác nhận; không thêm subnet hoặc `allow all`. Đối chiếu bản đã kiểm không bị bước copy cuối ghi đè; nếu config/mount đổi sau preflight thì kiểm lại trước `up`. Nginx cũ nguyên byte để rollback.
7. Kiểm Compose config trong đúng DOCKER_CONFIG bằng chế độ không xuất secret; xác nhận external volume/network và flags tắt. Từ `~/m8`, lên baseline bằng `DOCKER_CONFIG=$PWD/.docker docker compose up -d --no-build --wait --wait-timeout 600`. Không chạy profile migrate, không chạy targetSHA ở bước này. Điều chỉnh thời hạn TTS chỉ theo kết quả đo, không bỏ health.
8. Kiểm đủ 10 dịch vụ thường trực (11 dịch vụ trong cấu hình gồm migrate profile): image ID, command, mount, cổng/alias, PG, API, worker, phrase-tts readiness, Asterisk, ARI, HTTPS, Prometheus, ops-agent/metrics. HTTPS từ `.61` phải đúng200, không redirect/403; kiểm endpoint readiness/chức năng thích hợp ngoài liveness. Kiểm freshness snapshot ops và flags gọi thật/scheduler thực tế. Nếu thiếu bất kỳ điều kiện, rollback baseline theo mục7, chưa chạy CI deploy.

Lưu ý: script hiện trả0 ngay nếu đối số bằng dòng `M8_BAN`, trước Docker và health (`trien-khai.sh:51–56`; test cùng bản giữ hành vi đó). Vì vậy không dùng “deploy cùng baseline thành công” làm kiểm bootstrap, và tuyệt đối không điền targetSHA trước rồi dùng noop để nhận deploy hoàn tất.

## 6. G4 — Deploy target140 qua CI và lập receipt exact SHA

1. Khi G1–G3 đóng, đối chiếu lại pipeline target140, metadata biến và trusted host key. Chỉ bấm `deploy_m8_61` của đúng pipeline này; giữ một lượt trong resource_group `m8-61`. Pipeline web trên main chỉ hợp lệ khi tip đúng SHA cần deploy; không dùng pipeline SHA mới rồi gọi đó là target140.
2. Script sẽ: kiểm tag image/pull nếu thiếu → dump DB project m8 và `pg_restore --list` → migrate target → up/wait → HTTPS → cập nhật M8_BAN và PHIEN_BAN khi thành công. Nó không cập nhật script/Compose, không tự di chuyển S5, không tự lùi schema.
3. Script bỏ pull nếu tag đã có local; do đó receipt trước và sau phải đối chiếu **image ID/RepoDigest thực tế** với CI artifact đã chốt, không chỉ tag SHA. Nếu tag local sai hoặc registry digest lệch receipt: dừng và điều tra, không sửa receipt cho khớp trạng thái chưa duyệt.
4. Đối chiếu exit job với log host và trạng thái container. `allow_failure: true` khiến pipeline có thể vẫn xanh dù deploy lỗi; CI mất kết nối cũng không chứng minh deploy đã dừng vì script giữ chạy sau HUP/PIPE. Xem đúng log host, không bấm lặp khi còn khóa.
5. Tiêu chí đạt lượt triển khai: đủ target image IDs/digests cho API/worker/ops-agent, migrate dùng đúng target đã ghi; auxiliary giữ pin được duyệt; M8_BAN/PHIEN_BAN đúng sau runtime; dump trước migrate hợp lệ; schema/DB/readiness/8443/ARI/ops ổn; flags gọi thậtNO và schedulerfalse. Receipt ghi timestamp, source hash, pipeline/job IDs, artifact digest, image IDs, trạng thái/exit/downtime/rollback; không secret.
6. Health trong script là `curl -fsSk` tới liveness; bản thân nó không chứng minh TLS hợp lệ, đúng release, readiness toàn cụm hoặc loại mọi redirect. Kiểm bổ sung HTTP200, TLS theo trust đã định và identity/runtime trong receipt; không sửa runtime R3 ở lượt chuẩn bị này.
7. Diễn tập rollback ứng dụng chỉ khi có cửa sổ và kịch bản cụ thể đã cho. Mẫu cố ý làm hỏng health áp dụng cả kiểm bản cũ, nên không dùng chính lỗi health giả để kết luận bản cũ khỏe; kết thúc thử phải trả endpoint thật và kiểm độc lập. Không tự phát sinh cuộc gọi thật để thử.

## 7. Quay lui toàn cụm và giới hạn CSDL

### Lỗi ở bootstrap, chưa chạy migration target

- Ghi lỗi/giờ, dừng toàn bộ container project **m8** bằng đúng compose mới; kiểm postgres mới đã dừng trước khi bật postgres cũ. Không `down`/xóa network/volume và không xóa khu dữ liệu mới.
- Khôi phục restart policy từng container cũ từ receipt; từ đúng thư mục/file compose cũ, bật lại bốn project cũ theo dependency. Dùng nguồn bind/config cũ nguyên trạng; không copy dữ liệu/config mới ngược lên nguồn cũ theo phỏng đoán.
- Khôi phục enabled/active của `ivr-operations.service` và `ivr-operations-metrics.service` đúng trạng thái đã chụp bằng sudo; tránh hai metrics server cùng giữ19091. Kiểm đủ dịch vụ, cổng, ARI, snapshot ops, effective scheduler/calling tắt và đối soát DB. Ghi downtime thực tế và kết quả.
- Giữ cả nguồn cũ, dump và khu mới để điều tra; không xóa cho tới khi Lead cho riêng.

### Lỗi sau khi migration target đã bắt đầu

- Script tự quay về image baseline chỉ ở lỗi up/health. Lỗi migrate dừng lượt và giữ container cũ nhưng schema có thể đã thay đổi một phần. Kiểm migration còn chạy/khóa trước thao tác tiếp; runbook pg_dump quá hạn ở README mục10 vẫn áp dụng.
- **Không tự restore DB hoặc downgrade schema.** Việc quay về bốn project S5 cũ chỉ thực hiện khi đã xác nhận ứng dụng cũ tương thích schema hiện tại; nếu chưa, giữ gọi thật tắt, bảo toàn dump/log/trạng thái và để Lead quyết định forward-fix hay phục hồi DB có kế hoạch riêng.
- `pg_restore --list` không phải bằng chứng restore. Nếu Lead chọn phục hồi, phải chốt DB đích, điểm phục hồi, dữ liệu phát sinh có thể mất, quyền, downtime và kiểm sau phục hồi; không ghi lệnh restore tự động vào đường rollback này.

## 8. Chỗ nguồn để đối chiếu và phạm vi kết luận

- `deploy/ci/cd.gitlab-ci.yml:293–350`: job, needs, resource_group, File-variable guard và SSH; `:140–147`: digest artifact.
- `deploy/m8/trien-khai.sh:51–56`: same-version noop; `:150–164`: cache/pull; `:174–198`: backup; `:212–240`: migrate/up/rollback giữ schema; `:106–116`: health.
- `deploy/m8/compose.yml:9`: project m8; `:69,106–107,134`: flags tắt; `:346–360`: external network/volumes.
- `deploy/m8/README.md` mục2/4/8/10: mapping, CI, cắt đầu và pg_dump quá hạn. Gói stage phải được đối chiếu `source.json`, không coi tài liệu thay cho identity receipt.

R1 chưa chạy test, chưa SSH, chưa cài khóa, chưa tạo CI variables, chưa sửa host active, chưa mở gọi thật. Hai phụ thuộc hiện còn **đăng nhập/quyền GitLab** và **sudo hợp lệ**. Khi đóng bốn cổng chỉ kết luận được phạm vi triển khai LAB đã thực hiện; không tự nâng production acceptance, custody, carrier hoặc nghiệm thu voice/M3.


## 9. Review script copy staging và lệnh thủ công cho Lead

**ĐẠT về phạm vi copy staging qua đọc nguồn**, không phải kết quả đã copy. Script public `C:\Projects\_wt\m8\deploy-20261109\sudo-copy-m8-data.sh`, SHA256:

```text
00ba5413b591276cc7db8b4b6f16cb9c38215acca0f2193e44e117af2a4d9131
```

Căn cứ: dòng6–11 yêu cầu root, hostname `vps61`, stage có realpath đúng và target chưa tồn tại/kể cả symlink; dòng12–57 có21 cặp nguồn/đích cố định, không có `runtime.env`; dòng58–60 kiểm nguồn tồn tại và không phải symlink tại gốc; dòng61–71 chỉ tạo các thư mục dưới staging, `cp -a`, so UID:GID:mode gốc và in tên đích; không delete, stop, disable, migration, active config hoặc Docker. Không đọc/in nội dung secret vào chứng cứ. Parent xác nhận SCP + `bash -n` + SHA256 trên .61 PASS; reviewer không thực thi script.

Giới hạn: metadata assertion chỉ so21 gốc, không chứng minh mọi file con/quyền đọc runtime; `cp -a` giữ các symlink con nếu có, nên kiểm nguồn/bind cuối vẫn bắt buộc. Script không phải snapshot nhất quán cho Prometheus/state đang có writer. Copy hỏng để lại target một phần và lần chạy lại sẽ từ chối; không xóa target tự động hoặc tự sửa guard để chạy lại. Chưa đồng nghĩa G2/G3 đã qua.

Sau khi Lead/người quản trị .61 cho chạy copy-only và đã SSH vào đúng `.61`, đối chiếu script public rồi nhập sudo thủ công bằng lệnh sau (mật khẩu chỉ nhập vào prompt sudo trên host, không gửi qua chat):

```bash
printf '%s  %s\n' \
  '00ba5413b591276cc7db8b4b6f16cb9c38215acca0f2193e44e117af2a4d9131' \
  '/home/ssv/m8/chuan-bi-20261109-140bcb48/sudo-copy-m8-data.sh' \
  | sha256sum -c - && \
sudo -- /bin/bash /home/ssv/m8/chuan-bi-20261109-140bcb48/sudo-copy-m8-data.sh
```

Lệnh chỉ tạo `/home/ssv/m8/chuan-bi-20261109-140bcb48/du-lieu`; không tạo `~/m8/du-lieu` active. Đạt khi script exit0 và in `COPY_ONLY_COMPLETE: 21 paths. No active files installed, no services stopped.` Sau đó parent kiểm metadata/quyền các cấu hình cần thiết và chuẩn bị bản mới; chưa dựng privileged cutover script, chưa dừng writer hay bấm deploy. Nếu sudo chưa được cấp hoặc hash/hostname/source/target guard hỏng, giữ nguyên BLOCKED và báo lỗi cụ thể.
