# Bỏ Model Gateway toàn hệ thống

Từ: phiên `m7` · 31/10/2026

Lead nói trong phiên m7: "xoá sạch ràng buộc model gateway nhé, và tao không muốn gặp nữa."

- **M7 đã làm:** DL-030 trong `ginsengfood-golden-hour-video/docs/00-overview/DECISION_LOG.md` (M7 gọi Claude trực tiếp, tài khoản
  Max/Ultra hoặc API key, qua port AI riêng). Đang sửa 24 tệp docs M7 (`modules/m7/wp/M7-WP01.md`), chưa commit.
- **Còn ở luồng khác** (đếm tệp có chữ "Model Gateway", 31/10, chưa đọc nội dung):
  - `module5` (Tài): 8 tệp. M5 còn **bị chặn** bởi nó: DL-035 bắt `disable_ai_auto_response` bật ở mọi chế độ gửi thật tới khi có
    Model Gateway và Tech Lead mở bằng văn bản; DL-O33 (bộ phân loại bình luận đặt sau gateway).
  - `M4-PLAN` (Tài): 17 tệp. Chief chốt 16/10 đã gỡ một phần cho LLM của M4 khi đủ 5 điều kiện.
  - `ginsengfood-ops-core`: 7 tệp · `ginsengfood-ivr` (M8): 118 tệp (có thể gồm tệp sinh, cần lọc).
  - `ginsengfood-business-platform`, `ginsengfood-contracts`, `deploy`, `module6`: 0 tệp.
- **Đề xuất cho phiên `lead`:** `/quyet` một dòng toàn hệ thống "bỏ Model Gateway; mỗi module gọi model qua adapter của mình", thêm dòng vào
  `QUYET_DINH.md` của m5, m34, m8, m12; báo Tài trước khi sửa repo của Tài; luật an toàn riêng của M5 (AI không tự gửi cho khách) là việc
  khác, Lead quyết riêng.
