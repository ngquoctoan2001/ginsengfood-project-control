# Bản khai triển khai M8 — cụm IVR hai máy

Trạng thái: ĐẠT PHẠM VI HỒ SƠ sau verifier R1 độc lập (WP07D); chưa nghiệm thu triển khai. Lead chọn m8.13 A tại D-m8-011 ngày 02/11/2026.
Nguồn mã khai: `C:\Projects\ginsengfood-ivr`, `main c9f0cd188f4966d07aafb3155039656b1b451034`.
Đây là bản khai từ mã và hồ sơ, không phải biên bản kiểm máy thật, bản candidate mới hay lệnh triển khai.
Ứng viên niêm phong đang được hồ sơ cửa sổ nhắc đến là `66d9045d`; không cộng bằng chứng hai SHA thành một nghiệm thu.
`REAL_CUSTOMER_CALL_ALLOWED=NO`, `production_accepted=false`, `deployable=false`; G5 vẫn CHƯA.

## 1. Đơn vị triển khai và trách nhiệm

| Trường | Khai báo M8 |
|---|---|
| module_id / chức năng | M8 — IVR xác nhận đơn, dịch vụ .NET 10; không có UI vận hành riêng |
| Build context | Repo IVR; Dockerfile riêng trong `deploy/docker/`, `deploy/media-sync/`, `deploy/tts/`; image cùng source commit, pin bằng image ID |
| App host | `.61`, Compose `ivr-production`, network `ivr-production_private` |
| Telephony host | `.64`, Compose `ivr-production-vm`; Asterisk, receiver, ari-link dùng host networking |
| Monitoring | `.61`: systemd collector + metrics; Compose `ivr-production-monitoring`, container tên `ivr-operations-prometheus-1` giữ nguyên; phải chuyển quyền quản lý có receipt |
| Chủ mã/cấu hình/đối soát | Lead Toàn / phiên M8; Tuấn cấp quyền máy/mạng và lịch bảo trì; phía M3 do phiên m34 tự xử lý theo D-m8-008 |
| Prefix sở hữu | `/v1/ivr/order-confirmation` theo OpenAPI draft.45; các endpoint identity/JWKS và health lấy từ ứng dụng, không dựng tuyến gateway mới trong WP07D |
| Inbound | Backend M3 qua HTTPS riêng, JWT/scopes theo hợp đồng hiện hành; management/ARI/media/DB không công khai Internet |
| Outbound | M3 revalidation/callback khi đầu vào được chốt và bật đúng gate; link nội bộ `.61 → .64`; carrier SIP/RTP chỉ sau quyền/ACL/định danh và kiểm được phép |
| Scale | Worker có scheduler/controller/channel/CPS và kho phrase; không tự nhân bản dựa riêng CPU. Công suất production chưa được chứng minh |
| Hạ tầng | Postgres riêng, bank/model/phrase/media và state bền vững; chưa khai Redis/queue chung làm dependency của bộ này |

Nguồn: `deploy/release-candidate/render_hosts.py:82–237`, `build_images.py:16–30`, `operations_payload.py:15–46,113–122`,
`specs/api/openapi/ivr-order-confirmation.v1.yaml:20–31`, `deploy/rollouts/production-window-20261027/README.md:3–24,69–83`.

## 2. Dịch vụ, cổng, health và tài nguyên đã khai trong mã

Các giới hạn dưới đây là cấu hình đóng gói/cài thử, **không phải sizing production đã nghiệm thu**.
`CPU chưa đặt` nghĩa service không có giới hạn CPU tường minh trong generator, không có nghĩa được phép dùng vô hạn ở production.

| Host / service | Network / listener | Kiểm tương đương health | UID runtime khai báo | RAM / CPU |
|---|---|---|---|---|
| .61 api | private, 8080 | GET `/health/live` phải 200; còn kiểm auth/JWKS riêng | 1654:1654 | 1g / chưa đặt |
| .61 worker | private, 8081 | GET `/healthz` phải 200; drain 180s, stop grace 210s | 1654:1654 | 1g / chưa đặt |
| .61 phrase-tts | chia namespace worker, loopback 8090 | GET `/health/ready` phải 200; model/voice approval kiểm riêng | 1654:1654 | 2g / chưa đặt; concurrency 1, ORT/OpenBLAS/OMP/MKL1 |
| .61 postgres | private 5432, không publish | pg_isready đúng user/DB; thêm kiểm từng role/ACL | entrypoint khởi đầu root, hạ về postgres; không khẳng định toàn service non-root | 2g / chưa đặt |
| .61 migrate / ops | profile tools, chạy một lần | exit code + migration/role/policy check, không HTTP | 1654:1654 | mỗi job512m / chưa đặt |
| .61 ari-link | private, alias `asterisk`, 8088 | `/healthz` chỉ chứng minh tiến trình proxy; phải kiểm ARI/media xác thực xuyên mTLS | 101:101 | 64m / 0.5CPU |
| .61 https | `.61:9443 → 8443` | JWKS qua TLS có CA hợp lệ + health API; không chỉ ping socket | 101:101 | 64m / chưa đặt |
| .61 backup-tools / observability-tools | private, profile tools, chạy theo job | exit/receipt và restore/probe riêng; chưa bật timer nhờ đóng gói | 1654:1654 | mỗi job512m / chưa đặt |
| .64 asterisk | host; SIP5060UDP, ARI127.0.0.1:18088; RTP 10000–10999/UDP; TLS5061 chỉ khi được bật | `core waitfullybooted`, transport đúng, ARI cóauth và không active call trước chuyển | 1654:1654 | 1024m / 1CPU; chỉ mức cài/kiểm LAN |
| .64 receiver | host, 127.0.0.1:18090 | `/media-sync/v1/state` có token phải 200, token sai phải 401; thêm pin/ACK/epoch | 1654:1654 | 256m / chưa đặt |
| .64 ari-link | host, `.64:18089` mTLS, allow `.61` | TLS/client identity, ARI/media xuyên link; `/healthz` không thay kiểm upstream | 101:101 | 64m / 0.5CPU |
| .61 collector systemd | host, không HTTP inbound | snapshot mới/provenance/độ tươi; lỗi phải UNKNOWN, không tái dùng mẫu cũ | ssv (host requirement UID1000), supplementary docker | 192M / CPUQuota 15% |
| .61 metrics systemd | host, loopback 19091 | scrape/metrics hữu hạn và trạng thái collector | ssv; chặn docker.sock và private | 64M / CPUQuota 5% |
| .61 prometheus | host, loopback 19090 | kiểm query/rules + scrape 19091, lịch sử TSDB sau chuyển/rollback | 1000:1000 | 512m / 0.5CPU |
| .61/.64 host `ivr-backup.service` | systemd oneshot, không HTTP | capture/offhost receipt và recover-writers; timer đóng gói, chưa bật | root mặc định (unit không khai User); khác backup-tools container UID1654 | không khai MemoryMax/CPUQuota; TimeoutStartSec2h, Nice10, I/O idle |
| .61/.64 host `ivr-media-ledger.service` | systemd oneshot, không HTTP | export tombstone journal và receipt; timer chỉ dành app61, chưa bật | root mặc định (unit không khai User) | không khai MemoryMax/CPUQuota; TimeoutStartSec5m, Nice10 |

Nguồn: `render_hosts.py:30–35,107–177,211–232`; `deploy/telephony-vm/vm_deploy.py:211–237`;
`deploy/telephony-link/link_bundle.py:101–149,167–177`; `src/Ivr.MediaReceiver/Program.cs:16,39`;
`deploy/release-candidate/tests/probe.py:33–49,100–106`; `deploy/operations/{ivr-operations.service,ivr-operations-metrics.service,prometheus.yml,prometheus/compose.json}`.
Bốn tệp `deploy/backup/{ivr-backup.service,ivr-media-ledger.service,ivr-backup.timer,ivr-media-ledger.timer}` được đóng gói bởi `operations_payload.py:51–73`. Đóng gói unit trên hai host không cho phép bật timer trên cả hai; media-ledger timer ghi rõ app61 only.
API Dockerfile có healthcheck; worker Dockerfile cố ý không có HEALTHCHECK. Không ghi rằng tất cả container đã có Docker healthcheck.

## 3. Dữ liệu, mạng và bí mật (chỉ tên tham chiếu)

| Vùng | Khai báo / ranh giới |
|---|---|
| DB production | `ivr_production`, volume `ivr-production-postgres`; owner/migration `ivr_migration`, runtime `ivr_api`, `ivr_worker`, `ivr_ops`, `ivr_backup`, `ivr_monitor`; không dùng role/DB/queue S5 |
| Migration | Job image `migrate` trước app, DSN file qua `IVR_MIGRATION_CONNECTION_FILE`, `IVR_MIGRATION_REQUIRE_CONNECTION_FILE`; ứng viên 66d9045d có 45 migration. Không chạy SQL ứng viên bằng psql: hồ sơDB đã ghi lỗi SQL; không sửa artifact niêm phong |
| Policy | Kiểm/apply/kiểm có version `gh-247-prod-v4`; không tự gọi lệnh thiếu version. Không replay task/approval từ lab vào production |
| App data | `/srv/ivr-production/banks/<pin>` RO; `phrases` worker RW / API RO; API mount operations state RO; models và voice-acceptance manifest RO |
| VM data | `/srv/ivr-production/media` receiver RW; Asterisk đọc bank/phrases RO và state volume `ivr-production-vm-state`; giữ SQLite/tombstone khi rollback |
| Operations/backup | State `/srv/ivr-production/operations`, journal SQLite + WAL và TSDB ngoài release; backups ngoài release; kho phục hồi độc lập/backup credentials còn thuộc WP03A |
| App secrets | `.61/private/api.json`, `worker.json`, `db-bootstrap`, `db-migrate`, `db-ops`, `media-token`, `ari-secret.json`, `ari-tls/`, `api-tls/`, `vm-disk-key`, `vm-disk-known-hosts` dưới `/srv/ivr-production` |
| Backup secret mounts | `.61/private/backup.pgpass` → `/run/secrets/pgpass`, `backup-key` → `/run/secrets/backup-key` cho backup-tools; cả hai host repository config trỏ `/srv/ivr-production/private/backup-recovery-key`. Đây là khai báo target, chưa chứng minh đã cấp các ref pending |
| VM secrets | `.64/private/media-token`, `ari.conf`, `ari-secret.json`, `ari-tls/`; mỗi consumer mount/quyền theo bảng công cụ secret, không cho API đọc ARI credential |
| Quyền file | app/worker/migrate/ops UID1654, proxies UID101, collector UID1000; bootstrappostgres root. `.64 ari-secret.json` root 0400 dùng bởi preflight. CA signing key ở kho custody ngoài release/image/proxy |
| Cấu hình env không bí mật | `ASPNETCORE_ENVIRONMENT`, `DOTNET_ENVIRONMENT`, `REAL_CUSTOMER_CALL_ALLOWED`, `IVR_PRODUCTION_TARGET_V1_FIELDS_APPROVED`, nhóm `Ivr__*`, `ServiceIdentity__*`, `Media__*`, `VIE_NEU_*`, `PGHOST/PGPORT/PGDATABASE/PGUSER`, tên biến file bên dưới |
| Biến trỏ file | `POSTGRES_PASSWORD_FILE`, `IVR_MIGRATION_CONNECTION_FILE`, `IVR_OPS_CONNECTION_STRING_FILE`, `PGPASSFILE`, `IVR_BACKUP_KEY_FILE`, `Media__TokenFile`; app/worker mount `appsettings.Production.json` |
| ACL | 9443 chỉ backend M3 `.60` + nguồn bảo trì đã cấp; 18089 chỉ `.61`; ARI 18088 / media 18090 / metrics 19091 / Prometheus 19090 loopback hoặc private theo profile; DB không publish |
| Carrier/NAT | Hồ sơ dự kiến public 7070/UDP→.64:5060, RTP 10000–10999/UDP; 7071/TCP→5061 dành TLS khi được phép. Chưa có bằng chứng WAN/carrier tương ứng; không mở NAT/SIP/RTP trong sóng 1 |

Nguồn: `render_hosts.py:52–79,106–177,211–232`; `deploy/production-window/db/README.md:7–28,50–55`;
`deploy/production-window/secrets/README.md:9–41,47–67`; `operations_payload.py:47–104`; rollout README:22–24,32–48,69–83.
Tên env ở đây là nhóm giao diện và biến kết nối, không thay full effective-config của candidate. Bộ render/profile niêm phong là danh mục đầy đủ khi đóng candidate.
Năm ref `db-backup`, `backup-master`, `backup-recovery-key`, `backup-ssh-key`, `ca-recovery-key` vẫn `PENDING_SEPARATE_BACKUP_RECOVERY_WORK`; công cụ secret hiện loại chúng khỏi phạm vi sinh/stage, không được suy thành đã cấp. D-m8-010 chỉ cho kho khóa LAB tạm trên `.61`; production custody phải chốt trước cấp/release.

## 4. Ngoại lệ đã chốt và cách nghiệm thu tương đương

| Chuẩn chung | D-m8-011 chốt hướng A | Chủ đóng phần còn lại / bằng chứng cần có |
|---|---|---|
| 1 container / 1 server | Cụm hai host, nhiều dịch vụ chuyên trách | M8 khai/kiểm; phiên lead giữ shared deploy contract. WP02D kiểm chuyển đúng bộ ba `.64`, không adopt ngầm |
| 8000, GET/health | Giữ cổng và endpoint thật theo bảng2 | M8/Tuấn kiểm allow/deny thật, health/auth/media từng dịch vụ trên exact candidate; gateway chung chỉ khi cấp scope riêng |
| Secret toàn env | File mount theo least privilege, env chỉ cấu hình và đường dẫnfile | M8 kiểm consumer UID/mode, negative access/mTLS; Lead chốt custody production. Không bake/log/đưa CA vào runtime |
| Migrate lúc app startup | Migration job một lần trước app, role riêng | Migration count + grants/negative role login + idempotency; rollback binary không `Down`/restore DB cũ |
| Toàn runtime non-root | App/telephony/proxy/collector theo UID; Postgres entrypoint bootstrap root và host job có quyền riêng được khai rõ | Kiểm image+effective runtime user/mounts; không dùng UID trong generator làm bằng chứng host đã an toàn |
| Sizing chung | Giữ giới hạn cài thử, sizing production chờ đo tải/carrier | WP08/Lead/carrier: kênh/CPS, tải và resource headroom; không cộng RAM limits làm cấu hình host đã chốt |

Không sửa `C:\Projects\deploy\MODULE_DEPLOY_CONTRACT.md` trong WP07D. Bản khai này ghi quyết định riêng của M8 để phiên lead dùng khi cập nhật hồ sơ chung được giao.

## 5. Điều kiện còn mở trước G5

1. WP02D hoàn thiện công cụ ba dịch vụ và R3 được kiểm/duyệt; WP02E xử lý chuyển giám sát từ cài cũ có provenance.
2. WP03A nối credential/backup/restore, kho ngoài máy và CA recovery; người giữ/khôi phục production được chốt.
3. Candidate mới đúng source/image/config/toolhash, scan freshness, model/voice/legal approval; không sửa hồi tố candidate66d9045d.
4. Tuấn/Lead chốt quyền/cửa sổ/ACL và preflight; drain không active call, chỉ một bộ điều khiển chiếm cổng; rollback giữ dữ liệu và đối soát.
5. Diễn tập/triển khai đúng identity + independent evidence + owner acceptance. Health xanh hoặc bản khai ĐẠT riêng không đóng G5.

Các lệch nguồn được giữ rõ: README release còn hàng 44 migration trong khi hồ sơ candidate hiện hành 45; CN cũ `ivr-app61` trong inventory khác CN binding `ivr-production-app61`; bảng secrets thiếu `.64 ari-secret.json` và chi tiết known_hosts. Dùng hồ sơ/công cụ mới có căn cứ cho bản khai, sửa metadata candidate ở gói đóng candidate sau; không sửa artifact niêm phong trong WP07D.

## 6. Kiểm WP07D

Parent đã đối chiếu source generator, systemd/compose, probe và hồ sơDB/secret/rollout tại c9f0cd18; chưa chạy host/render/build.
Verifier vòng 1 yêu cầu bổ sung hai host backup units (root mặc định), exact backup mounts và năm ref pending. Parent đã bổ sung; verifier kiểm lại hẹp và kết luận ĐẠT, 20/20 nguồn khớp. [Biên bản kiểm độc lập](2026-11-02-wp07d-verifier.md).
