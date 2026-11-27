# M3-023 · Điều kiện gửi đơn

Ngày 27/11/2026, nhánh `toandeptrai`, nền `51c9f5275`. Gói đang làm cục bộ. Điều kiện mới mặc định chưa tham gia checkout.

## Phạm vi đã làm ở M3

- Thêm mục **Quản trị IVR → Điều kiện gửi đơn**. Admin sắp xếp dòng luật, đặt N và trần riêng cho COD và online, gộp hoặc tách 24/7 và Giờ Vàng, sửa số phút sau phiên. Mô phỏng minh họa cả bốn tổ hợp, COD đơn thứ tư và hai đơn online thanh toán đảo thứ tự. `3 COD / 2 online` chỉ là mẫu. Các trường hợp chưa xác định được nhóm khách hoặc loại mua chuyển nhân viên.
- Lưu lịch sử soạn, mô phỏng, gửi duyệt, duyệt, áp dụng và hoàn nguyên. Quyền xem, soạn, duyệt và áp dụng tách riêng. Người tạo, sửa hoặc gửi duyệt cùng bản bị chặn tự duyệt. API trả `409` khi phiên bản đã đổi.
- M3 chốt luật khi đặt, COD giữ suất khi ghi đơn và online giữ suất khi ghi nhận thanh toán thành công. Sổ kiểm theo người đặt chuẩn, một dòng mỗi đơn, kèm trạng thái chờ. Đơn đang chờ vẫn ở cửa xác nhận trước giao hàng. Khách thanh toán thành công rồi được chuyển nhân viên vẫn giữ nguyên trạng thái đã thu tiền và có thể được xác nhận thủ công.
- Bổ sung V414–V416 cho cấu hình, sổ suất và quyết định trên từng đơn. Tầng IVR M3 nhận Giờ Vàng COD, với thời điểm sớm nhất là hết phiên cộng số phút đã chốt. Online vẫn cần biên nhận thanh toán để gửi. Chi tiết đơn hiển thị dòng luật, phiên bản, lý do và thời điểm dự kiến.
- M3 đọc chứng cứ lượt quay qua API kết quả M8. Chỉ cộng khi khớp đơn, phiên bản, task, job và chế độ. M3 có API nhập lịch sử theo trang, gồm chạy thử và ghi lặp an toàn. Tệp bàn giao M8 mô tả trường `dial_evidence` và các ca kiểm cần bổ sung.

## Kiểm cục bộ

- Maven 136/136 ca theo phạm vi, gồm hợp đồng OpenAPI, luật, sổ suất, thứ tự thanh toán, đối soát và trạng thái đơn đã thu tiền. PostgreSQL 16 kiểm riêng V414–V416, gồm quyền, duy nhất một bản ACTIVE, phạm vi bộ đếm, gộp hồ sơ, Giờ Vàng COD, giữ biên nhận online và lưu được dữ liệu cũ sau khi đóng.
- Hai bộ kiểm IVR persistence và Luật gọi chạy Flyway đầy đủ trên PostgreSQL dùng riêng, đạt 52/52 ca. Đã kiểm luồng cũ, callback lặp, luồng gọi lại và điều kiện mở giao hàng.
- Vitest 24/24, TypeScript và ESLint đạt. Playwright dùng trình duyệt Edge và dữ liệu giả lập đạt 3/3 ca gồm mô phỏng rồi gửi duyệt, bản nháp xung đột và tài khoản chỉ xem.
- Kiểm số migration và danh sách bộ chạy Docker đạt. Compose kiểm cú pháp bằng giá trị mẫu cục bộ. Gói này chưa có SHA ứng viên và chưa chạy tích hợp trên `.99`.

## Đưa lên máy chạy thử

1. Phúc hoàn tất checkout Giờ Vàng COD. Kiểm ràng buộc checkout cùng V412–V413 trước khi chọn SHA ứng viên. Phiên M8 bổ sung và ghim `dial_evidence` trên bản M8, kèm bằng chứng quay ở chế độ MOCK.
2. Chạy bộ kiểm BE và FE đầy đủ của ứng viên, kèm verifier độc lập. Thử đủ bốn tổ hợp qua checkout M3 → intake M8 → quay MOCK → M3 đối soát. Chạy thêm chặn giao lúc chờ suất, hủy trước quay, gộp khách, gọi lại và cài hai lần lịch sử. Tham chiếu kết quả đối chiếu luật nháp với hành vi hiện tại trên mẫu đã lọc thông tin cá nhân.
3. Khi có SHA hai phía, chạy nhập lịch sử với `dryRun=true` theo con trỏ trang. Xác nhận số có chứng cứ, số còn mở và số thiếu trước lượt ghi. Thống kê theo đúng `execution_mode` và kiểm cả job cũ còn mở. Bật đối soát trước chính sách checkout.
4. Sau khi Toàn duyệt cửa sổ, Phúc áp M3 tại `.99`, phiên M8 phụ trách bản M8. Theo dõi số đơn chờ, tuổi yêu cầu, lượt quay đã cộng và lỗi đối soát. Khi cần lùi, dùng bản luật đã duyệt trước đó cho đơn mới và tiếp tục đối soát các yêu cầu đã gửi.
