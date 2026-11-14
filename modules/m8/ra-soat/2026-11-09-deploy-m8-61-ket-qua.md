# M8 .61 — deploy LAB qua GitLab đã đạt

Mốc kiểm host cuối: **09/11/2026 18:47:31 +07**. Nguồn `140bcb48a27e9dcda947243a965a85b29f41a519` (W-0517), project `m8`, thư mục `/home/ssv/m8`.
Phạm vi D-m8-065 và m8.68/D-m8-066: hoàn tất deploy LAB .61. Không nghiệm thu .64, candidate 02F hoặc production. M8-002 tiếp tục IN_PROGRESS; readiness giữ 47%, board 0/4 và 11 gate ngoài.

## Kết quả và bằng chứng

| Nội dung | Kết quả đã kiểm |
|---|---|
| Nguyên nhân job cũ hỏng | Thiếu hai GitLab File variables; job dừng trước SSH. Host còn cần chuyển từ các project S5 cũ sang khuôn `~/m8`. |
| Variables | Đã tạo `M8_DEPLOY_SSH_KEY`, `M8_DEPLOY_KNOWN_HOSTS`: File, Protected, scope `m8-61`, expansion tắt. Visibility Visible đã được Lead duyệt m8.68; không lưu giá trị vào chứng cứ. |
| SSH | Khóa riêng `gfivr_ci_m8_61_ed25519`; giữ key cũ, thêm `restrict` + forced command tới `trien-khai.sh`. Không shell tương tác. Đối số sai bị từ chối; mẫu chỉ giới hạn executable/tham số, không phải allowlist từng SHA. |
| CI đúng SHA | [Pipeline 3044094922](https://gitlab.com/nqt20102001/ginsengfood-ivr/-/pipelines/3044094922) có các job kiểm/publish đạt; bốn digest trong log `publish_images` khớp RepoDigests trên .61. |
| Deploy thật | [Job 17860367945 — Passed](https://gitlab.com/nqt20102001/ginsengfood-ivr/-/jobs/17860367945), retry đúng job deploy một lần sau cấu hình; đã chạy pull → backup → migrate → đổi container → health. Không phải no-op. |
| Định danh live | API, worker, ops-agent/ops-metrics đúng image CI140; migrate đúng image CI140. Postgres, phrase-tts, nginx, Asterisk, ARI, Prometheus giữ nguyên image ID S5 đã ghim. Chi tiết tại receipt, không suy aux mới từ job publish. |
| Dịch vụ | 10/10 running, restart count đều 0; API/Postgres/TTS/Asterisk có Docker healthcheck healthy. Các dịch vụ không khai healthcheck được ghi null, không tự suy healthy. HTTPS8443, metrics19091 và Prometheus19090 trả 200; snapshot ops mới 11,8 giây. |
| Dữ liệu | Giữ 3 volume external/network gateway172.29.0.1. 45 migration; cuối `20261020022600_CapacityRechecksAndGoldenHourTwoCalls`. Không restore/hạ schema. |
| An toàn gọi | `REAL_CUSTOMER_CALL_ALLOWED=NO`, worker scheduler false; Asterisk đọc sau kiểm: 0 active channels, 0 active calls. |
| Cụm cũ | Giữ nguyên 8 container cũ, đã dừng; hai systemd unit cũ inactive + disabled. Giữ dữ liệu, image baseline và bản sao lưu để phục hồi. |

## Chuẩn bị và chuyển dịch vụ

- Tệp public active `compose.yml`/`trien-khai.sh` khớp hash từ commit140. `.env` dựng trên host từ cấu hình hiệu lực, chỉ xuất kết quả đối chiếu; không đưa bí mật vào hồ sơ.
- Copy 21 nguồn vào staging qua sudo hợp lệ. Verifier chỉ đọc: 580 file thường khớp, 590 kiểm quyền, 19 root tĩnh; 2 root có writer được bỏ qua ở lần pre-copy rồi chép lại sau khi dừng writer. Không coi pre-copy đang sống là snapshot nhất quán.
- Đối chiếu effective env API/worker/TTS kể cả mặc định image: không lệch. Nginx bản sao thêm allow cho source192.168.1.61 trước deny-all; `nginx -t` đạt và health từ host chuyển403→200.
- Dump trước bootstrap: `/home/ssv/m8/sao-luu/prebootstrap-20261109T112507Z-s5v4.dump`, 925.815 byte, SHA256 `4731e0d4be34c028bdbf474d347feb599b848bd5af5ca2cc98386f9b72afbac9`; `pg_restore --list` đạt 335 TOC. Đây là kiểm cấu trúc dump, chưa phải restore drill.
- Bootstrap baseline `s5v4-66d9045d8be0` từ 18:28:32 đến18:29:52 +07 (~80 giây cho toàn thao tác). Không đặt trước target140 để tránh deploy no-op. Không có đo liên tục để khẳng định downtime chính xác.
- Job CI18:31:44–18:32:36 +07: backup335 TOC, migrate đạt, đổi container, kiểm health. Host và runner lệch khoảng6 giây; giữ timestamp nguồn trong receipt/log.
- Helper cấu hình đã được review hai vòng và phiên chính sửa các điểm còn lại, thử dotenv6vector/atomic-write; chưa có verdict độc lập cuối cho toàn helper. Đây không phải chứng cứ test lại toàn mã ứng dụng.

## Diễn tập quay lui trên .61

Tạo đúng bốn tag tạm `rollback-probe-20261109-140bcb48`: API/migrate/ops giữ image140, riêng worker trỏ image API thiếu `Ivr.Worker.dll`. Không build/push image hoặc thêm migration; trước thử không có cuộc gọi.

Watcher đã thấy worker probe và lỗi thiếu DLL; các assertion này qua trước khi lần hậu kiểm đầu bị lỗi. Log deploy tại bước `[4/5]` thực tế trả lỗi OCI network namespace đã mất khi khởi động container phụ thuộc, sau đó script in **“Đã về 140bcb48…”** và exit1 như dự kiến. Vì vậy chứng cứ là rollback sau lỗi bước đổi container; không mô tả thành timeout health của worker.

Giới hạn lưu vết: worker/DLL, exit1 và metrics curl7 là diễn biến phiên chính quan sát từ lần chạy đầu; raw stderr/transcript lần đầu không được lưu thành tệp trong bộ chứng cứ. Các trường tương ứng trong closeout receipt là bản thuật lại, không phải phép đo mới. Verifier độc lập chỉ xác nhận được log bước4/quay lui và receipt định danh/sức khỏe sau đó; không nhận đã độc lập đo lại ba sự kiện này.

Lần hậu kiểm ngay sau rollback thất bại `curl exit7` ở metrics19091. Không đổi assertion sức khỏe; tới18:47:31 +07, chạy lại đủ verifier đạt cả10 dịch vụ/3 endpoint, restart count0, `PHIEN_BAN` và `.env` không đổi. Bộ thu log ban đầu còn giả định dòng lỗi phải chứa tên worker; đã sửa để đối chiếu chính dòng OCI trong đoạn bước4. Giữ các thất bại này trong receipt.

Đã gỡ đúng4 tag probe sau khi kiểm image ID; không còn container migrate/probe, không prune. Dump của lượt thử: `sao-luu/ivr-20261109T113932Z-140bcb48a27e9dcda947243a965a85b29f41a519.dump`. Kết luận **ROLLBACK_DRILL_PASS_AFTER_READINESS_WAIT**; chưa diễn tập restore DB, reboot, timeout/flock trên host hoặc quay lại toàn bộ các project S5 cũ.

## Giới hạn còn giữ

- Branch main được bảo vệ; hai File variables Protected/scope m8-61 và SSH restricted đã kiểm. UI không có Protected environments; tính năng này thuộc Premium/Ultimate theo [tài liệu GitLab](https://docs.gitlab.com/ci/environments/protected_environments/). Chưa cấu hình quyền deploy theo Protected environment; giữ là việc trước production. LAB đã triển khai theo lệnh Lead với các kiểm soát nêu trên.
- `M8_AUTO_DEPLOY` chưa đặt: deploy vẫn bấm tay. Nhãn environment `production` của YAML không đồng nghĩa nghiệm thu production. Health HTTPS dùng curl `-k`, không là kiểm chuỗi chứng chỉ production.
- Chưa thay .64/M12/M9; chưa làm nóng lại3.321 phường/xã, chưa chạy gọi thực/đo carrier hoặc nghiệm thu UAT. Custody production, pháp lý/nội dung VieNeu và artifact vẫn chờ.
- Không sửa mã nguồn/commit/push trong lượt này. HEAD vẫn140; WIP tracker được nối thêm bằng công cụ, giữ phần cũ. Hai file mock m34 xuất hiện trong khi làm là WIP phiên khác, không chạm.

## Hồ sơ

[Bộ chứng cứ và SHA256](2026-11-09-deploy-m8-61-bang-chung/sha256.json) chứa ảnh UI, log job, source/digest, baseline/backup/configuration và receipt host. [Rollback receipt](2026-11-09-deploy-m8-61-bang-chung/rollback-drill-receipt.json), [kiểm sau rollback](2026-11-09-deploy-m8-61-bang-chung/post-rollback-verification.json), [log rollback](2026-11-09-deploy-m8-61-bang-chung/rollback-deploy.log).

`rollback_drill_performed:false` trong JSON của verifier chỉ đọc là trường cố định của helper (helper không thực hiện fault); kết quả diễn tập riêng nằm ở `rollback-drill-receipt.json`. Giữ nguyên receipt gốc, không sửa số liệu để khớp kết luận. Chứng cứ cho bootstrap trước chuyển ở [runbook chuẩn bị](2026-11-09-deploy-m8-61-chuan-bi.md); thông tin BLOCKED trong bảng lịch sử không còn là hiện trạng.

Kiểm độc lập hồ sơ R1: **ĐẠT sau hai sửa hồ sơ** (bổ sung hash các tệp rollback và phân biệt lịch sử quan sát/raw evidence); 21/21 hash khớp, không tự nhận kiểm host. Manifest SHA256 `704a366a911cdd77ecbb85f0200785fd8e3ec3d29a250c19d587f51821523806`.
Tracker M8-002 đã đồng bộ trạng thái Đang làm qua `sheet-sync log` một lần. Kiểm cuối: báo cáo liên kết hợp lệ, TRANG_THAI52 dòng, HEAD140/main không đổi; tracker nối1161 byte và giữ nguyên toàn bộ phần trước, hash hai file mock m34 không đổi.
