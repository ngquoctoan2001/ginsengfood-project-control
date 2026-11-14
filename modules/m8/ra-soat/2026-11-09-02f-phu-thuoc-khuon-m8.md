# WP02F sau khi chuyển .61 sang khuôn m8

Đối chiếu nguồn140bcb48 ngày09/11; chỉ đọc source và receipt deploy18:47, chưa kiểm .64 hoặc thay host. Scout độc lập và phiên chính cùng xác nhận các phụ thuộc sau.

| Phần đã quyết | Nguồn hiện tại | Hệ quả cho lượt tiếp |
|---|---|---|
| D-m8-020: rollback theo pre khi thiếu post | `window.py:1741` luôn lỗi nếu không có media-epoch-post | Có thể làm độc lập ở bộ chấm, cần lựa chọn tường minh, baseline media/container đầy đủ; không tự fallback khi mất chứng cứ. Lượt09/11 làm phần này. |
| D-m8-021: F5/R5 qua authorized_handoff | `window.py:1291` và1379 gọi engine trực tiếp; CLI1911 chỉ nhận profile | Chưa đủ inventory/approval và các pin; phải nối sau khi hợp đồng topology mới được chốt. |
| D-m8-024/025: project m8, bỏ systemd cũ | `host_profile.py:58` bắt source_project ivr-operations-prometheus; host_handoff đòi unit active và rollback khởi động lại unit | Không thể đổi tên executable là xong. .61 hiện có ops-agent/ops-metrics/Prometheus trong project m8,2unit đã disabled. Phải có adapter/profile cho m8, giữ engine legacy bất biến. |
| Quyền chạy wrapper | `authorized_handoff.py:27` đòi mọi thư mục cha root-owned, không group/world writable; `window.py:922` stage dưới HOME | Cần thiết kế staging root-owned cho đường được cấp quyền; không chép payload dưới HOME rồi tự coi đã đủ authority. |
| Candidate release | `window.py`/candidate cũ giữ9443/project ivr-production, deployment hiện8443/project m8 | Bản kiểm D020 không phải nghiệm thu công cụ cửa sổ đầy đủ cho topology mới. Candidate07B-L phải đóng lại theo D024. |

Thứ tự: D020 kiểm rollback → hợp đồng/profile/adapter nâng cấp tại chỗ m8 theo D024 (DB/bí mật mới, giữ volume LAB lưu trữ) → authority/staging F5/R5 → LAB lifecycle/rollback/recover → candidate07B-L → cửa sổ02F có quyền. Không sửa bundle đã niêm phong hoặc tạo inventory systemd giả.

Đầu vào cho bước topology: inventory mới ba container giám sát/mount/state/TSDB, image/container IDs, UID/quyền và data scope; candidate/controller/tool pins; approval ngoài băng có hành động và thời hạn. Có thể chuẩn bị contract/LAB bằng fixture; quyền production và custody vẫn chốt trước chạy thật.

[Brief phần D020](2026-11-09-02f-rollback-pre-brief.md) · [Kết quả .61 LAB](2026-11-09-deploy-m8-61-ket-qua.md).
