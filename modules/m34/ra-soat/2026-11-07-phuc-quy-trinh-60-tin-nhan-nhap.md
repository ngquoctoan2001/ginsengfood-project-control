# Tin nháp gửi Phúc — cách đưa code lên .60 từ 07/11 · CHƯA GỬI

Người nhận: Trương Công Phúc. Toàn xem, sửa rồi tự gửi. Gửi kèm (hoặc thay) tin nháp 06/11 `2026-11-06-phuc-gop-dev-tin-nhan-nhap.md`.

---

Phúc ơi, máy .60 giờ đổi cách triển khai rồi, em đừng dùng cách cũ trong `/opt/ginsengfood` nữa nhé.

**Hiện trạng:** bản LAN cũ (`/opt/ginsengfood`, `deploy/compose.lan.yml`) anh đã `stop` từ 05/11, dữ liệu vẫn giữ. Bản đang chạy là `~/m34`, chiếm cổng 80, đang chạy `dev` `9a4690574`.
Nếu em vào `/opt/ginsengfood` pull rồi `docker compose up --build` như trước thì nginx cũ sẽ đụng cổng 80, và nó lên một CSDL khác hẳn bản đang chạy.

**Cách mới (không build trên máy chủ nữa):**
1. Gộp code vào `dev` như bình thường (PR). Push `dev` mà có đổi `back-end/`, `front-end/` hoặc `deploy/m34/` thì GitHub Actions `m34-images` tự build 2 image lên GHCR, tag là mã commit.
2. Chờ run `m34-images` của commit đó có job `build-images` xanh (job `quet-images` đỏ thì kệ, nó chỉ báo cáo).
3. SSH vào .60 rồi chạy:
   ```bash
   ~/m34/trien-khai.sh <mã commit đủ 40 ký tự>
   ```
   Script tự sao lưu CSDL, kéo image, đổi container, kiểm health; lỗi thì tự quay về bản cũ. Bản đang chạy xem ở `head -3 ~/m34/PHIEN_BAN`.

Vài lưu ý:
- Commit chỉ đổi tài liệu thì không có image, cứ lấy mã commit gần nhất có run xanh.
- Thêm biến `NEXT_PUBLIC_*` mới vào `front-end/Dockerfile` thì nhớ thêm khoá vào `deploy/m34/build-args.60.json`, thiếu là CI dừng.
- Thêm biến môi trường BE cần cho .60 thì thêm vào `deploy/m34/compose.yml` (giá trị bí mật để trong `~/m34/.env` trên máy, không commit). Mail OTP hiện chưa cấu hình trên .60, anh đang làm.
- Migration mới đánh số tiếp từ V319.
- Sửa thẳng CSDL trên .60 thì báo anh trước nhé.

Em cứ làm vậy, không cần chờ anh. Chi tiết ở `deploy/m34/README.md`.
