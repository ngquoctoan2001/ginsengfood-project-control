# Kiểm M3 ↔ M8 trên .99

M3 và ứng dụng M8 chạy cùng .99. Truy cập quản trị qua [Điều kiện gửi đơn](https://ginsengfood.vn/admin/ivr/dispatch-rules). M3 gửi tới `https://192.168.1.99:8443`, M8 trả kết quả qua cầu M3 ở `https://192.168.1.99:8445`. Asterisk chạy riêng trên .64.

- M3: `/data/ginsengfood-business-platform`, project Compose `m34`. Phúc phụ trách cấu hình và thao tác trên máy (D-lead-060).
- M8: `/data/ginsengfood-ivr`, project Compose `m8`. Phiên M8 kiểm hợp đồng, TLS, hàng chờ và callback.
- Trong lúc chờ máy thử, thực hiện lượt kiểm trên .99 (D-lead-065).

## Điều kiện gửi đơn

1. Phúc kiểm quyền đọc và sửa luật. Soạn bản dùng trên .99, mô phỏng bằng các trường hợp mẫu rồi gửi duyệt. Toàn dùng tài khoản khác có quyền duyệt. Người có quyền **Áp dụng** kiểm đúng mã phiên bản trước khi chuyển sang active.
2. Có thể kiểm quy trình quản trị khi cờ checkout IVR đang tắt. Bản luật active là dữ liệu cấu hình thật của .99, nên chỉ áp dụng bản có nội dung đã chốt để dùng trên máy này. Đọc lại trạng thái và lịch sử thay đổi.
3. Lượt kiểm checkout cần kiểm riêng hai ca: khách mới COD chỉ xác thực email đi `CONFIRMING / STAFF_MANUAL` và không tạo task M8; khách mới COD đã xác thực đúng số điện thoại đi M8, callback được M3 áp đúng một lần. Chuẩn bị bằng chứng `dial_evidence` theo M3-023 trước khi bật chính sách đối soát của bộ luật mới.

## Kiểm trước khi chạy đơn

- Ghi SHA BE/FE, M8 API/worker, cờ M3, chế độ M8, trạng thái lịch và hàng chờ. Chốt một đơn nội bộ và cửa sổ thử trước khi đổi cờ. Giữ lớp Compose công khai và cấu hình OTP hiện tại.
- Dùng runbook `ginsengfood-ivr/deploy/m8/noi-m3/luot-thu.md` cho một lượt MOCK và đối soát bằng mã đơn. Ghi callback HTTP và số lần áp dụng tại M3.
- Gọi qua trunk thật theo [phiếu 01D](../../m8/ra-soat/2026-11-27-goi-van-hanh-64-01d-wp10-wp11.md#3-chuẩn-bị-01d-và-tiền-kiểm-phát-hành).
