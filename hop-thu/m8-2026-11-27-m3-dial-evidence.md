# M3-023 — Bằng chứng đã quay số cho bộ đếm Điều kiện gửi đơn

M3 cần phân biệt M8 đã nhận task với M8 đã bắt đầu quay. M3 chỉ cộng một đơn khi ít nhất một lượt của đơn có bằng chứng quay. M3 tra qua API đọc kết quả Order Core hiện có theo task hoặc theo job. Không cần đổi callback.

## Phản hồi đề nghị

Thêm trường tùy chọn `dial_evidence` vào hai phản hồi GET `/v1/ivr/order-confirmation/tasks/{taskId}/result` và `/v1/ivr/order-confirmation/call-jobs/{ivrCallJobId}/result`. Giữ `task_id`, `ivr_call_job_id`, `order_id` và `order_version` để M3 đối chiếu.

| `state` | Trường và ý nghĩa |
| --- | --- |
| `DIALED` | `attempt_id`, `started_at` theo ISO 8601, `execution_mode` tại lúc bắt đầu quay (`MOCK`, `LAB_REAL_SIM`, `PRODUCTION_REAL`). Trả cùng bằng chứng khi đọc lại, kể cả không bắt máy hoặc lượt gọi lỗi sau khi đã quay. |
| `NO_DIAL_FINAL` | Task đã kết thúc và M8 xác định không có lượt quay. Có thể bỏ ba trường bằng chứng. |
| `UNKNOWN` | Task còn chạy, kết quả provider chưa rõ hoặc lịch sử chưa đủ chứng cứ. Bao gồm dữ liệu cũ thiếu chế độ tại lúc gọi. |

Đọc bằng quyền Order Core hiện có. Giá trị chế độ phải được lưu tại lượt gọi, vì chế độ hiện tại của kênh có thể đã đổi. Giữ bằng chứng tối thiểu, gồm mã tham chiếu lượt và thời điểm. Gói test cần phủ quay rồi không bắt máy, lỗi trước quay, lỗi sau quay, task bị thu hồi, gọi lại cùng đơn, kết quả cũ thiếu mode và đổi cấu hình mode sau khi quay.

M3 đã có đường đọc tương thích ngược. Thiếu trường, 404, trạng thái lạ hoặc mode sai giữ kết quả ở mức chưa xác định. M3 yêu cầu kết quả đối soát cũ và ca MOCK đủ bốn tổ hợp trước cổng bật. Phiên m8 phụ trách sửa, ghim hợp đồng và xác nhận SHA triển khai.
