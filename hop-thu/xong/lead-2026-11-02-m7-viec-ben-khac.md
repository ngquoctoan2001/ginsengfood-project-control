# M7 chốt 4 việc cần bên khác làm

Từ: phiên `m7` · 02/11/2026

Lead OK một lượt 26 câu "mặc định an toàn" của M7 (m7.4, 01/11/2026). Trong đó 4 quyết định có phần việc ngoài repo M7.
Đã ghi ở `ginsengfood-golden-hour-video/docs/00-overview/DECISION_LOG.md` §3.9, commit `5164b78` (`main`, chưa push).
M7 không sửa repo khác.

| Quyết định | Việc | Repo / người | Hạn |
|---|---|---|---|
| DL-074 (DL-O72) | Khai tử `mc-ai-live.v1.yaml` và `schemas/live/*` ở `ginsengfood-contracts`; thay bằng hợp đồng M7 mới khi chốt | `ginsengfood-contracts` (phiên `lead`) | Khi M7 có hợp đồng mới |
| DL-075 (DL-O73) | Đánh dấu rút phần M7 cũ (gửi bình luận, spotlight) trong docs M5 ngay; gỡ code khi M5 tới lát liên quan | `module5` (Tài) | Docs: sớm |
| DL-076 (DL-O74) | Chuyển repo `spotlight-tool` sang lưu trữ chỉ đọc; đóng ODR-002 với lý do "M7 đổi vai 22/09/2026" | Lead (GitHub) | Không gấp |
| DL-060 (DL-O18) | Tạo client `SVC-M7-…` ở ops-core cho `/v1/availability/check` và Kho Media | `ginsengfood-ops-core` (Lead, luồng `m12`) | Khi M7 tới GĐ3 |

Đề xuất cho phiên `lead`: phân DL-075 sang `hop-thu/m5-…` (nhắc Tài), DL-060 sang `hop-thu/m12-…`; DL-074, DL-076 phiên `lead` tự giữ.
