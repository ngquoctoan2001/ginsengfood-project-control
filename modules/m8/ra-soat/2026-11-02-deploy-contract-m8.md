# Đối chiếu hợp đồng triển khai M8 · 02/11/2026

Trạng thái: HƯỚNG NGOẠI LỆ A ĐÃ ĐƯỢC LEAD CHỐT · D-m8-011 ngày 02/11; WP07D hoàn thiện bản khai và kiểm độc lập.
Đối chiếu `C:\Projects\deploy\MODULE_DEPLOY_CONTRACT.md` với repo IVR `c9f0cd18`.
Mục tiêu: chốt cách ghép M8 vào hệ thống; bản này không thay đổi kiến trúc, credential hoặc quyền release.

| Điểm | Chuẩn chung | Nguồn M8 hiện có | Hướng A đã chốt; chi tiết phải kiểm |
|---|---|---|---|
| Đơn vị triển khai | Một container, một server (contract:5-10) | Hai host .61/.64, nhiều dịch vụ; bộ .64 Asterisk/receiver/proxy (release-candidate/README:118-135; cutover/README:140-146) | Giữ M8 là cụm chuyên biệt hai host, khai rõ owner/dịch vụ/health và kết nối qua API đã bảo vệ; không tự gộp vào 1 container. |
| HTTP/health | Nội bộ 8000, GET/health | API 8080, worker health 8081, ingress HTTPS 9443; probes /health/live và /healthz (release-candidate/README:124-135; tests/probe.py:35; rollout README:ACL9443) | Bản khai giữ endpoint thật và kiểm từng health; nếu gateway chung cần adapter/route thì phiên lead chốt và cấp scope riêng. |
| Bí mật/cấu hình | Toàn bộ env, không bake vào image | File mount riêng owner/mode, migration đọc IVR_MIGRATION_CONNECTION_FILE (release-candidate/README:83; secrets README:28-41) | Giữ file secret theo consumer và không bake/log; liệt kê tên ref/đường mount, không giá trị. Không chuyển CA vào env/runtime để khớp mẫu. |
| DB/migration | Postgres service/schema riêng; prompt chung nói migrate lúc startup | DB production riêng, migration job một lần trước app (release-candidate/README:50); policy v4 pin riêng (rollout README) | Giữ DB role/migration job riêng, nhận hạ tầng theo bản khai và isolation đã kiểm; không để API tự migrate mỗi lần start. |
| UID/root | Non-root | UID 1654/101/1000 theo consumer; provisioning/host maintenance dùng root có scope (secrets README:28-41) | Đối chiếu runtime image User từng service, tách quyền bootstrap/host job; không kết luận mọi service non-root khi chưa có manifest. |
| Nghiệm thu | Không tự production-ready | deployable=false, production_accepted=false, gọi thật NO (rollout README:3-5) | Giữ cùng nguyên tắc, dùng G1–G8 + release gate riêng của M8, exact candidate và quyết định mở cửa sổ cụ thể. |

Lead đã chọn **A** (D-m8-011): chốt hướng M8 dùng ngoại lệ cụm hai host như bảng, giao WP07D hoàn thiện bản khai chi tiết rồi phiên lead cập nhật chuẩn/hồ sơ chung khi được phép.
Phương án B không được chọn. G5 vẫn CHƯA cho đến khi đủ bản khai và bằng chứng triển khai đúng candidate.
A không phải phê duyệt deploy/mở gọi hay tự thay tiêu chí bảo mật; B không chặn hai sóng code/lab.
Không có yêu cầu ghi repo M3 hay gửi hợp đồng cho M3; D-m8-008 vẫn giữ.
