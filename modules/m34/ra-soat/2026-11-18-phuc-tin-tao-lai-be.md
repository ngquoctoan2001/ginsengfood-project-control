# Tin nháp gửi Phúc — 18/11 13:5x (D-m34-108) · CHƯA GỬI · gấp

## Tin (Zalo)

Phúc ơi, trên .99 em tạo lại container be giùm anh liền nha. File cấu hình đã có lại lớp tắt OTP giả với tắt nối IVR rồi, mà be chưa khởi động lại nên trang bán hàng ngoài Internet vẫn đang hiện mã OTP. Tạo lại xong em nhắn anh, anh kiểm lại liền.

Thêm một chuyện: trong file cấu hình mới có mấy dòng bật nối kho M12. Cái đó anh tính bật từ 20/11, mà nếu em bật luôn hôm nay thì nhớ giữ tắt phần chặn bán và giữ hàng nghen. Em xác nhận giùm anh là em cố ý thêm hay không.

Chi tiết anh để trong file.

## Chi tiết kỹ thuật (gửi kèm)

Đọc .99 lúc 13:48 (chỉ đọc, phiên m34):
- `/data/ginsengfood-business-platform/.env` sửa 13:43 (bản chụp `.env.tu-20261118-0639` lúc 13:39): `COMPOSE_FILE` cuối có `:compose.cong-khai.yml`; thêm 5 khoá `OPS_CORE_ALLOW_PLAIN_HTTP`, `OPS_CORE_BASE_URL`, `OPS_CORE_BASE_URL_ALLOWED_HOSTS`, `OPS_CORE_CLIENT_ID`, `OPS_CORE_ENABLED`.
- Container `m34-be-1` (image `bp-backend:d1039f46f…`) chạy từ 12:36:41, CHƯA tạo lại sau lần sửa `.env` → trong container vẫn `OTP_SMS_EXPOSE_MOCK_CODE=true`, `APP_IVR_INTEGRATION_ENABLED=true`, `OPS_CORE_ENABLED=false`.
- Cần: tạo lại riêng `be` (`docker compose up -d --no-build --no-deps --wait be` hoặc bước tương ứng của `trien-khai.sh`), rồi kiểm trong `be`:
  `OTP_SMS_EXPOSE_MOCK_CODE=false`, `APP_IVR_INTEGRATION_ENABLED=false`, `/api/health/ready` 200 qua nginx.
- Kiểm trước khi tạo lại: `select count(*) from order_ivr_confirmations where is_active` = 0. Lúc 13:48 là 0. Còn > 0 thì báo anh trước, vì lần bật sau watchdog sẽ huỷ đơn đó.
- Nếu `OPS_CORE_ENABLED=true` là cố ý: theo kế hoạch m34.124, giữ `OPS_CORE_GATE_ENFORCE` (chặn bán theo tồn M12) và giữ hàng TẮT; sau khi `be` lên, kiểm log có `OPS_CORE_TOKEN_OK`. Link 19 SKU + kho `WH_FG_MAIN` đã nạp 17/11.
- Ghi chú: lớp công khai bị bỏ lúc 12:36:50 là do phiên m34 chạy `cong-khai-99.sh lui` để mở khung đặt đơn thử (Toàn duyệt), không phải lượt lên bản của em. Lượt đó đụng lượt lên bản `d1039f46f` của em lúc 12:34–12:35. Từ nay phiên m34 không ghi .99 nữa.
