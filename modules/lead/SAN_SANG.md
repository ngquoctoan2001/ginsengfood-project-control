# Sẵn sàng — liên module (mốc B 10/11)

> **BẢN NHÁP 31/10.** Mỗi điểm nối có hai phía; chỉ chấm "đã nối" khi chạy thử đầu-cuối trên máy chủ chạy thử (bậc 75).
> `/ke-hoach` ở phiên này giao scout đối chiếu hợp đồng hai phía và cập nhật bảng.
> Cập nhật dữ kiện 02/11 09:47: giữ bảng ở BẢN NHÁP, 0/11 điểm có bằng chứng chạy thử đầu-cuối; không nâng bậc từ test local.

## Điểm nối

| # | Điểm nối | Bên gửi → bên nhận | Hợp đồng ở đâu | Tình hình 31/10 | Chặn bởi |
|---|---|---|---|---|---|
| N1 | Mở phiên Giờ Vàng, ảnh chụp sản phẩm | M3 → M7 | tài liệu M7 (chưa có hợp đồng chung) | cổng code đã mở; T002 khung local chờ commit | chưa có hiện thực/tích hợp tương ứng |
| N2 | Kiểm còn hàng | M7 → M2 | `POST /v1/availability/check` (tài liệu M7) | chưa đối chiếu | — |
| N3 | Tin nhắn/bình luận → tư vấn | M5 → M4 | hợp đồng M5–M4 v1 (module5 DL-167…172, PR #11 31/10) | endpoint trên `dev015` `960adc14b`, chưa vào `dev`; PR #146 mở, 0 review, backend CI FAILURE. M4-003: Tester PASS a1 nhưng IN_CODER attempt 2 vì cổng production lọt với profile `prod`/`Production` (sổ Tài `66abb34b`, chưa kiểm độc lập) | rà R3, sửa cổng, máy chạy thử và API credit |
| N4 | Tư vấn → đặt hàng | M4 → M3 | trong business-platform | chưa kiểm | — |
| N5 | Đơn mới → gọi xác nhận → kết quả | M3 ↔ M8 | `ginsengfood-ivr/specs/api/openapi` draft.44 + IR-06/07/08 | M8 có bằng chứng giả lập; D-m34-003: Lead nhận phía M3, task M3-023 trên `toandeptrai` (`547dd59a0` mới sửa tracker, chưa có mã nối) | chốt lịch mới, API/callback và E01–E10 trước 06/11 |
| N6 | Thanh toán VNPAY | M3 ↔ VNPAY | business-platform | SIT đạt 6/6 | VNPAY cấp thông số thật |
| N7 | Vận đơn GHN/VTP | M3 ↔ hãng | business-platform | tắt mặc định | test khoá đơn, tài khoản hãng |
| N8 | Giữ/trừ hàng kho, nhà máy | M3 ↔ M1–M2 | `ginsengfood-contracts` (submodule ở ops-core và business-platform) | 11 ca hợp đồng chưa xong (M12-WP06) | **contracts kẹt merge từ tháng 5** |
| N9 | Băm định danh khách chung (CH21) | M5 ↔ M6 | tài liệu M6 L1 | chờ Lead soát | Lead |
| N10 | Doanh thu đơn đã xác minh | M3 → M6 | chưa có | sau 15/11 (L3/L4 của M6) | — |
| N11 | Xuất lịch phát | M7 → M6 | `MetaSchedulePackage` (tài liệu M7) | chưa có mã cho điểm nối; M7 mới có T002 khung local | chưa có hiện thực/tích hợp tương ứng |
| N13 | Đọc trạng thái đơn trước khi gửi tin (D-m5-036; N12 giữ cho ảnh tồn kho WMS, lead.53) | M5 gọi M3 | `ginsengfood-contracts` `openapi/business-platform/order-channel-state.v1.yaml` DRAFT, PR #2 (`lead/order-channel-state-v1` `2d6807d`, mở 13/11, Phúc review) | 13/11: chưa có mã hai phía. M3 chưa có endpoint cho dịch vụ khác gọi; M5 reader còn mock nên production M5 từ chối khởi động (M5-115). Task M3-181 Phúc hạn 21/11, M5-144 Tài hạn 24/11 (chờ M3-181), nối .60 trước 26/11. Pilot không chờ (chế độ phạm vi) | Phúc + Tài chốt PR #2 trước 17/11 (Tài có quyền ghi repo contracts, kiểm 14/11), token dịch vụ trên .60 |

## Việc chung chưa có chủ

| Việc | Vì sao quan trọng | Đề xuất |
|---|---|---|
| Gỡ merge kẹt của `ginsengfood-contracts` (local `08585c1` 21/05 đang merge `e5b2506` 20/05; 41 xung đột; `origin/main` nay `a7832a4` 21/09, local sau 81 commit; 104/142 tệp của `08585c1` đã có trên origin) | N8 và mọi hợp đồng chung dựa vào repo này | lead.1 B (chưa duyệt): lưu bản vá, xử lý merge cũ trước; đề xuất hiện tại là A ở dòng C37 dưới, giữ nguyên checkout kẹt |
| Hợp đồng C37: `ISSUED` trong 2 schema `schemas/ops/x03b/` + operation `POST /v1/inventory/allocations/release` (`releaseInventoryAllocationV1`, mã `ALLOCATION_NOT_HELD`), một bản CHANGELOG, Phúc review (phá vỡ phía M3) | m12 WP07b cần trước 08/11 (mốc B); chi tiết `hop-thu/lead-2026-10-31-m12-c37-issued-schema.md`, `C:\Projects\_wt\m12\WP07-bao-cao.md` §4 | đề xuất lead.1 A (02/11): làm trên worktree mới từ `origin/main`, không đụng checkout kẹt |
| M7 DL-074: khai tử `mc-ai-live.v1.yaml` + `schemas/live/*` ở contracts | thay bằng hợp đồng M7 mới | khi M7 có hợp đồng mới |
| Deploy contract: M1–M2 ngoại lệ stack riêng trên .61 (8 dịch vụ, API 8080 sau caddy; giữ `GET /health`, non-root, env, runbook riêng) — m12.18 A; M7 nhiều container + worker ngoài .61 | cổng G5 | lead.16 đã được D-m12-005 duyệt, còn ghi contract trong lượt làm việc repo chung; M7 quyết khi có Dockerfile (M7-T015, sau 15/11) |
| Bộ triển khai `C:\Projects\deploy` cũ (tháng 7, còn M7 Python, không remote, mật khẩu Redis trong lịch sử) | cổng G5; mốc D | cập nhật theo module thực tế, đẩy lên remote riêng tư, đổi mật khẩu |
| M7 DL-076: repo `spotlight-tool` sang lưu trữ chỉ đọc, đóng ODR-002 ("M7 đổi vai 22/09/2026") | dọn | Lead trên GitHub, không gấp |
| Điểm nối M7 GĐ3 (01–02/2027): số bán M3 (DL-056, DL-046), chỉ số + kênh M6 (DL-046, DL-O17, chờ `DL-O21` M6), Kho Media (DL-061), danh mục claim M1 (DL-064) | sau 15/11 | `/ke-hoach` lead đợt sau |
| Token Google Sheet commit trong `sheet.json` (ops-core, IVR, business-platform; M6 TRK-38) | cổng G3 | Lead thay token, chuyển sang biến môi trường, mỗi repo một commit gỡ tệp |
| Runbook chạy thật toàn hệ thống + thứ tự bật (M3, M5 trước; M6 sau cùng) | mốc D | phiên `lead` soạn sau mốc B |
