# WP07D — kiểm độc lập R1, 02/11/2026
KẾT LUẬN: ĐẠT — phạm vi hồ sơ WP07D R1; hai thiếu sót danh mục đã được author sửa và kiểm lại hẹp. Không đóng G5 hoặc cấp quyền production.
Base kiểm: repo IVR `main c9f0cd188f4966d07aafb3155039656b1b451034`, sạch trước/sau; chỉ đọc source, không render/test/build/Docker/host/tracker.
Phạm vi ghi duy nhất: báo cáo này. Các tệp bản khai/ma trận/source manifest giữ nguyên.

| Tiêu chí | Kết quả → bằng chứng |
|---|---|
| 1. Đủ service/host/port/health/DB/UID/secret/network/owner | ĐẠT sau sửa F1–F2. Các hàng khớp `render_hosts.py:30–237`, `vm_deploy.py:211–237`, `link_bundle.py:101–177`, `tests/probe.py:33–106`, systemd/Prometheus và backup units/timers thực tế. |
| 2. Ngoại lệ có lý do, owner và cách kiểm tương đương | ĐẠT về hồ sơ: bản khai:82–93; ma trận:3–21; `QUYET_DINH.md:18` D-m8-011 chốt A, không cấp deploy/mở gọi. |
| 3. Đối chiếu source/profile và định danh | ĐẠT: đọc actual generator/probes/units/compose/README DB-secret-rollout; lần đầu 16/16 và sau bổ sung 4 backup unit/timer là 20/20 working SHA256 và Git blob khớp c9f0cd18, 0 lệch. Không suy số dòng thành bằng chứng runtime. |
| 4. G5 chỉ đóng sau đúng candidate và nghiệm thu | ĐẠT: bản khai:3–7,95–103 tách candidate66d9045d/sourcec9f0cd18; G5 CHƯA, không claim toàn runtime non-root hoặc production sizing. `.61` chỉ kho LAB; production custody còn mở; không giao việc M3. |

F1 ĐÃ SỬA — bản khai:49–50 thêm hai host oneshot `ivr-backup.service`/`ivr-media-ledger.service` riêng container UID1654: root mặc định, không RAM/CPU limit, receipt và timer chưa bật; dòng55 phân biệt đóng gói hai host với media-ledger timer chỉ app61. Khớp `operations_payload.py:50–73,93,96`, `deploy/backup/ivr-backup.service:5–12`, `ivr-media-ledger.service:5–10`, `ivr-media-ledger.timer:2`. Owner backup vẫn WP03A/Lead.
F2 ĐÃ SỬA — bản khai:69 khai `private/backup.pgpass` → `/run/secrets/pgpass`, `private/backup-key` → `/run/secrets/backup-key` cho backup-tools và `private/backup-recovery-key` repository cả hai host; dòng80 liệt kê đủ 5 ref pending và bị loại khỏi provisioner. Khớp `render_hosts.py:168–172`, `operations_payload.py:50,67–70`, `deploy/production-window/secrets/README.md:14–16`; không tự khai ref đã cấp hoặc mount cho ref chưa được render.

Lệnh kiểm: Python stdlib đối chiếu SHA256 từng working file và `git rev-parse <source_commit>:<path>` (cuối 20/20); `git rev-parse HEAD`, branch/status; đọc file/rg có giới hạn. Không mở `.env*`, sheet.json hoặc giá trị secret.
Kiểm âm/đột biến: không áp dụng R1 tài liệu chỉ đọc; không thay source để tạo kết quả giả. Kiểm máy thật, credentials, migration và release acceptance CHƯA CHẠY, ngoài scope.
Đã đọc lại đúng phần sửa F1–F2 và 4 unit/timer; source manifest khớp, main còn sạch. Không có finding còn mở trong scope hồ sơ; host/credential/production acceptance vẫn ngoài scope. Tracker/generated files để phiên chính.
