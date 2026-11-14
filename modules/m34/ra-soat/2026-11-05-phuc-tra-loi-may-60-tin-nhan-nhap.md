# Tin nháp trả lời Phúc — máy chạy thử BP .60 (05/11/2026) · CHƯA GỬI

Người nhận: Trương Công Phúc (trả lời tin hỏi 5 điểm). Lead xem, sửa rồi tự gửi. Quyết định: D-m34-027, D-m34-031, D-m34-035/036.

---

Phúc ơi, phần dựng máy .60 anh đã làm xong ở phía repo. Em không phải viết gì thêm, chỉ cần xem lại giúp anh vài chỗ thuộc tài khoản của em.
Toàn bộ việc anh đã chia thành task M3-071 tới M3-100 trên Sheet (tab M3), em mở ra là thấy từng bước và ai làm.

**1. Deploy kiểu nào:** máy .60 tự kéo ảnh về. Không dùng runner trong LAN, không VPN.
- GitHub Actions build ảnh rồi đẩy lên GHCR.
- Anh SSH vào .60 chạy `~/m34/trien-khai.sh <mã commit 40 ký tự>`. Script tự sao lưu CSDL, kéo đúng ảnh của commit đó, kiểm health, lỗi thì tự quay về bản cũ.
- Máy .60 đăng nhập GHCR bằng token của anh, token chỉ có quyền `read:packages`.
- Workflow có sẵn bước deploy-60 (cần runner LAN), nhưng đang **tắt** và chưa dùng.

**2. Khuôn:** anh đã làm theo khuôn M12 và M8 rồi đưa sẵn vào repo, ở nhánh `toandeptrai`, commit `fcb3bcd9e`:
- `.github/workflows/m34-images.yml`: workflow build và đẩy ảnh.
- `back-end/Dockerfile`, `front-end/Dockerfile`.
- `deploy/m34/compose.yml`: chỉ dùng `image:`, không build trên máy.
- `deploy/m34/README.md`: runbook triển khai, quay lui, sao lưu.
- `deploy/m34/trien-khai.sh`.
Khuôn gốc của M12/M8 nằm trong repo GitLab riêng nên anh không gửi; bản BP ở trên đã chép đủ cách làm.

**3. Secret:** cách đang dùng **không cần secret nào**. Workflow chỉ dùng `GITHUB_TOKEN` có sẵn. Vì vậy **chưa cần nâng quyền admin cho anh.**
Em chỉ cần kiểm giúp anh hai chỗ:
- GitHub → Your profile → Packages: hai gói `bp-backend` và `bp-frontend` → Package settings. Mục "Inherit access from source repository" phải đang bật. Có mục này thì token của anh mới kéo ảnh về .60 được.
- Settings → Billing: phút Actions và dung lượng Packages còn bao nhiêu, tài khoản đang ở gói Free hay Pro.
Sau này nếu bật deploy tự động từ CI thì cần thêm: secret `M34_60_SSH_KEY` (khoá SSH chỉ chạy được lệnh triển khai) và `M34_60_KNOWN_HOSTS` (vân tay máy .60), environment `m34-60`, biến `M34_DEPLOY_60`, và một runner trong LAN. Lúc đó anh nhờ em đặt một lần.

**4. Ảnh:** có 2 ảnh:
- `ghcr.io/phucapu/ginsengfood-business-platform/bp-backend`
- `ghcr.io/phucapu/ginsengfood-business-platform/bp-frontend`
- Thẻ là mã commit đủ 40 ký tự, **không có `latest`**.
- Ảnh được build khi push lên `dev` hoặc `toandeptrai`, chỉ khi commit có đổi `back-end/`, `front-end/`, `deploy/m34/` hoặc chính workflow. Commit chỉ đổi tài liệu thì không build.
- Không gắn tag. Bấm tay được khi workflow đã lên `master`.

**5. Số lần build và phút Actions:**
- Lượt đầu hôm nay (13:22) mất khoảng 10 phút: kiểm khuôn 40 giây, build 2 ảnh 8 phút, quét lỗ hổng 1,5 phút.
- Ước khoảng 4–6 lượt mỗi ngày, tức 40–60 phút/ngày. Nếu Billing không đủ, anh sẽ đổi lại: chỉ build khi push `toandeptrai` hoặc bấm tay.
- Kho: anh giữ 5 bản gần nhất của mỗi ảnh, bản cũ hơn anh xoá hằng tuần. Dung lượng mỗi ảnh anh sẽ đo rồi báo em.

**Anh xác nhận:** anh **không đổi `ci.yml`**, đã so với `dev`, tệp y nguyên. **Luật PR vào `dev` cũng giữ nguyên**: phần của anh vào `dev` vẫn qua PR `toandeptrai → dev`.
