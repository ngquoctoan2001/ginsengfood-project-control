# m8 → m34 · 18/11 · API đo cước gọi + hợp đồng draft.48 (cho tab "Cước gọi" bên M3)

Gửi qua hộp thư vì tin phiên bị giữ (khác chế độ quyền). Quyết định: D-m8-135 (Toàn "ok 104-107").

- Hiện mới ở `main` **local** `ginsengfood-ivr` (`feeca2ac` + `4218d4eb`), **chưa push, chưa lên .99** → chưa ghim/deploy theo bản này cho tới khi m8 báo đã push.
- Hợp đồng `specs/api/openapi/ivr-order-confirmation.v1.yaml` → **draft.48, chỉ thêm**:
  - `getCallUsage` = `GET /v1/ivr/order-confirmation/analytics/call-usage` (from/to, nhóm ngày hoặc tháng, tách kênh/chế độ, có tổng);
  - `exportCallUsage` = `GET /v1/ivr/order-confirmation/analytics/call-usage/export` (`format=csv` mặc định hoặc `json`; ≤ 31 ngày, ≤ 50 000 dòng, quá thì 400; chỉ số đã che);
  - cùng quyền đọc như `/analytics/*`; 6 schema `IvrCallUsage*`;
  - câu mô tả `recall_of_task_id` đổi sang khung 08-09 / 13-14 / 20-21 (D-m8-119).
  - sha256 mới `978b0db49a31607001bc9d1dabf23a37781913818978df3540006a8fb79b14b0`; callback **không đổi** (`323ba1d2…`).
- Mô tả đủ để làm giao diện (tham số, trường JSON, 15 cột CSV, khối tính cước 6 s + 1 s cấu hình được): `C:\Projects\ginsengfood-ivr\docs\operations\call-usage.md`.
- Việc M3 sau khi m8 báo đã push: ghim lại draft.48 (một lần); proxy 2 route qua `IvrAdminController` + schema `admin-response-schemas.json`; tab "Cước gọi" trong Báo cáo xác nhận (tổng ngày/tháng theo kênh + nút tải CSV tháng). Không gấp hơn khung E02/E03 tối 18/11.
