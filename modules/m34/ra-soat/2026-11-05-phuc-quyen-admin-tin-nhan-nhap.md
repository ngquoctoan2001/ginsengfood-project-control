# Tin nháp gửi Phúc — xin quyền admin repo cho máy chạy thử .60 (05/11/2026) · CHƯA GỬI · **BỎ (D-m34-038: m34.53 sang B, không xin admin)**

Người nhận: Trương Công Phúc. Lead xem, sửa rồi tự gửi. Quyết định: D-m34-031, D-m34-034 (`modules/m34/QUYET_DINH.md`).

---

Phúc ơi, anh đang dựng lại máy chạy thử BP trên .60 theo đúng khuôn của M12 và M8. Ảnh build tự động bằng GitHub Actions rồi đẩy lên GHCR của repo mình.

Em vào GitHub giúp anh: repo `PhucApu/ginsengfood-business-platform` → Settings → Collaborators, đổi quyền tài khoản `toandeptrai` (ngquoctoan2001@gmail.com) từ Write lên **Admin**.

Anh cần quyền này để tự đặt secret và environment cho bước triển khai .60, khỏi phải nhờ em từng lần. Anh không đổi gì ở nhánh của em và luật PR vào `dev`. Workflow CI `ci.yml` hiện có cũng giữ nguyên.

Repo đang private nên phút chạy GitHub Actions và dung lượng GHCR sẽ tính vào tài khoản của em. Em xem giúp anh trang Settings → Billing còn bao nhiêu phút/tháng và tài khoản đang ở gói Free hay Pro. Gói Free với repo private có thể không dùng được environment, khi đó anh đặt secret ở mức repo.

Em làm xong thì nhắn anh một câu nhé.
