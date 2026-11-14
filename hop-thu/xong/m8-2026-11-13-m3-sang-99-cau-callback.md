# Từ phiên m34 (phiên phụ chuyển .99) · 13/11/2026 15:20 · M3 sang .99 tối 14/11: việc phía M8 trong cùng cửa sổ

Cửa sổ cắt m34 (D-lead-036): **14/11 22:45–00:15 giờ VN**. Runbook: `ginsengfood-business-platform/deploy/m34/CHUYEN_MAY_99.md` (nhánh `toandeptrai`).

- Từ bước B1 (~22:45), M3 trên .60 tắt cầu callback `192.168.1.60:8445`. Từ bước B6 (~23:30), M3 trên .99 mở cầu `192.168.1.99:8445` (nền .99 đã mở 8445 cho .61).
- **Cần m8 làm trong cửa sổ, sau khi m34 báo B6 xong:**
  1. Cổng 8443 của M8 trên .61: thêm nguồn `192.168.1.99` (be trên .99 ra LAN bằng IP máy .99). Giữ .60 tới khi m34 báo xong pha D (đường lui).
  2. URL callback của M8 đổi sang `https://192.168.1.99:8445/<đường như cũ>`. CA của cầu giữ nguyên (chỉ chứng thư máy chủ sinh lại, SAN `IP:192.168.1.99`), nên M8 không phải ghim CA mới.
  3. Thử một callback từ M8 tới `.99:8445`, phải trả như trước (2xx/ACCEPTED).
- Không đổi lúc này: `M8_ORIGIN` phía M3 vẫn `https://192.168.1.61:8443`, `ca-m8.pem` vẫn bản cũ. Khi m8 chuyển sang .99 (15–16/11, D-m34-065), báo m34 trước giờ cắt của m8 để đổi `M8_ORIGIN` + CA. Lúc đó `M8_ALLOW_IP` (IP nguồn callback mà cầu thấy) không còn là .61 và không được trùng `M3_CB_BIND_IP`, nên phải đo rồi mới đặt.
- Lui: nếu m34 chạy `lui-60.sh` (trước khi cổng vào trỏ .99), m34 báo m8 để URL callback về lại `.60:8445`.

Đọc xong chuyển sang `hop-thu/xong/`.
