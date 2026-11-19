# Tin nháp gửi Phúc — 18/11 15:2x · đưa `dev` mới nhất lên .99 (D-m34-108, D-m34-109) · CHƯA GỬI

## Tin (Zalo)

Phúc ơi, anh mới gộp code mới nhất của anh vô dev rồi đó, có thêm tab Cước gọi bên báo cáo IVR. Em đưa bản dev mới nhất lên .99 giùm anh trong chiều nay nha.

Lượt này có đổi mạng của mấy container M3 nên toàn bộ M3 sẽ dừng chừng một hai phút, em chạy lên đủ bộ một lần là được. Nhớ giữ lớp tắt OTP giả với nối IVR như lượt trưa nay nghen. Phần nhánh chú Dũng thì để sau, anh chịu.

CI trên GitHub vẫn kẹt thanh toán nên em build bằng runner của em. Xong em nhắn anh mã commit với kết quả kiểm, anh vô coi lại liền.

Chi tiết anh để trong file.

## Chi tiết kỹ thuật (gửi kèm)

**Bản cần lên:** `dev` = `826aee599` (PR #170, 18/11 15:2x). So với bản đang chạy trên .99 (`d1039f46f`, Phúc lên 12:34) có thêm:
- Tab "Cước gọi" (PR #170 `7c3910714`): ghim hợp đồng IVR M8 draft.48, route quản trị `GET /analytics/call-usage` (IVR.VIEW) + `/analytics/call-usage/export` (IVR.EXPORT). Tab chỉ có số khi M8 trên .99 đã có API draft.48 (phiên m8 đang lên); M8 chưa lên thì tab báo lỗi, phần khác không ảnh hưởng.
- PR #164: giao diện quản trị IVR theo ui-kit-v2; nginx tin `X-Forwarded-Proto` / cổng 443 chỉ từ proxy .98 (`4cfd37b32`, `c95f083c8`); **ghim mạng `m34_app` 172.24.2.0/24** (`95dbab13f`); bộ ngắt mạch M12 tách CHECK / READ (`75663cf47`).
- PR #165–#169 của Tài (M4 chat) và các commit của em (ngày lễ, IAM, Giờ vàng…).

**Thứ tự migration (Toàn chấp nhận, D-m34-109):** .99 đang ở V360. Bản này chạy thêm **V392–V395** (của em). Nhánh gộp chú (V361–V391) chưa vào dev; khi gộp chú về sau, trước lượt lên .99 đó phải xử lý thứ tự Flyway (đổi số migration của chú lên sau số lớn nhất, hoặc bật out-of-order một lần). Sao lưu CSDL trước khi lên.

**Các bước cần lưu ý:**
1. Image: GitHub Actions vẫn lỗi Billing (mọi `m34-images` từ 17/11 hỏng ở bước bắt đầu job; `826aee599` cũng vậy) → dùng runner .63 của em, ghi SHA image.
2. nginx: conf mới — chạy `nginx -t` với conf mới trên .99 TRƯỚC khi tạo lại `nginx` (lỗi thì giữ conf cũ):
   `docker run --rm --entrypoint nginx --add-host be:127.0.0.1 --add-host fe:127.0.0.1 -v <conf>:/etc/nginx/conf.d/default.conf:ro nginx:stable-alpine -t`.
3. Mạng: lần `up` đầu sau khi ghim subnet, Compose TỰ tạo lại `m34_app` và dừng mọi container M3 → chạy ĐỦ BỘ `docker compose up -d --no-build --wait` một lần (không mở đầu bằng `up be` riêng: lỗi và `be` nằm dừng). Trước: `docker network inspect m34_app` không có container lạ. Sau: cầu M8 (`m8that-cb`, allow 172.24.2.1) chạy, `be` → M12 `:5000` token OK.
4. `COMPOSE_FILE` giữ `:compose.cong-khai.yml` ở CUỐI. Sau khi lên, trong `be` phải là `OTP_SMS_EXPOSE_MOCK_CODE=false`, `APP_IVR_INTEGRATION_ENABLED=false`.
5. Giữ quan sát M12 như hiện tại: `OPS_CORE_ENABLED=true`, `OPS_CORE_GATE_ENFORCE=false`, `APP_INVENTORY_OPS_CORE_ALLOCATION_ENABLED=false`; log có `OPS_CORE_TOKEN_OK`.
6. Việc "sau HTTPS" làm luôn lượt này nếu em thấy ổn (kế hoạch đã duyệt): `.env` `CORS_ALLOWED_ORIGINS` thêm `https://ginsengfood.vn,https://www.ginsengfood.vn` (giữ `http://192.168.1.99`), `AUTH_COOKIE_SECURE=true` — sau đó vào quản trị bằng `https://ginsengfood.vn/admin` (LAN cũng được), `http://192.168.1.99/admin` sẽ mất đăng nhập. Chưa chắc thì để lượt sau, báo anh.
7. Kiểm sau: `/api/health/ready` 200 qua nginx và qua `https://ginsengfood.vn`; trang `/admin/ivr` mở được; `select max(version) from flyway_schema_history` = 395.
8. Gửi anh: SHA image `be`/`fe`, giờ bắt đầu / xong, kết quả 7 bước kiểm. Phiên m34 sẽ đọc lại .99 (chỉ đọc) để đối chiếu.
