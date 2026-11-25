# Cổng Nguy hiểm 25/11: tổng hợp cho Toàn duyệt (bảy vùng, bốn lượt kiểm độc lập)

Bốn người kiểm độc lập (không phải người viết) chạy tối 24/11 → rạng sáng 25/11 trên ops-core, mỗi lượt giữ khoá kiểm đủ + đột biến, HEAD đứng yên trong lúc chạy, chỉ test lọc, không vào `.99`. Chi tiết từng lượt: `2026-11-24-cong-nguy-hiem-17-p13-ket-qua.md`, `2026-11-25-cong-nguy-hiem-p10-f1-ket-qua.md`, `2026-11-25-cong-nguy-hiem-p14-vat-ket-qua.md`, mục WP31/WP32 ở dưới. **Mọi sửa trong cổng còn là commit cục bộ, CHƯA push, CHƯA lên `.99` (đang chạy `417f15d53`).**

## 1. Kết quả theo vùng

| Vùng | Lần kiểm | Lỗi tìm ra | Đã làm | Kết luận hiện tại |
|---|---|---|---|---|
| **#17** kiểm vai → kiểm quyền | 1 | F1 (S2): admin tự cấp 4 mã ngoại lệ (xem giá vốn, nhập giá, duyệt huỷ hai tầng) cho vai mình qua `POST /roles/R-ADMIN/actions` | Sửa `fdba2a1ad`; kiểm lại ở lượt 2: ĐẠT (probe gốc 422 mọi biến thể, đột biến 4/4 đỏ) | **ĐẠT** |
| **P13** tạo/sửa/ngừng vai | 1 | cùng F1 | như trên | **ĐẠT** (13 đột biến đỏ, 1 tương đương) |
| **P10** ma trận duyệt, ô ký phiếu | 2 | thiếu 1 test (đột biến bỏ nhánh `ownerEdited` của seed 21 vẫn xanh) | Thêm test `03158964c` (đỏ dưới đột biến) | **ĐẠT** |
| **P14** nhóm/loại SKU, migration 160 | 3 | P14-2 (S3): kích hoạt SKU không kiểm nhóm/loại còn ACTIVE; P14-1: thiếu test ngừng mã với SKU `ACTIVE_BASELINE` | Sửa `497019c07` (kích hoạt + áp import SKU gọi guard; test) | **ĐẠT sau sửa** (migration trên dữ liệu mô phỏng đạt) |
| **VAT P1b** thuế suất | 3 | không | 5 chỗ ghi thuế đều qua kiểm; DI thật nhận bộ đọc | **ĐẠT** |
| **WP31** phiên trượt (đang BẬT) | 4 | S3 ×2 (dưới) | không cần sửa trước chạy thật | **ĐẠT** |
| **WP32** quên mật khẩu (cờ TẮT) | 4 | S1 có điều kiện (e), S3 ×3 | chưa sửa, cờ giữ TẮT | **CẦN SỬA trước khi bật** |

Số kiểm: unit 49 + 78 + 206 + 279 + 278, integration 14 + 19 + 44 + 120 (2 đỏ ngoài phạm vi, xem mục 3), vitest 79 + 134; đột biến 11 + 13 + 5 + 4 + 5 + 5 + 5 + 5 (chỉ P13 có 1 tương đương, P14 M4 đã được vá bằng test); Governance 1128/1128 ở mỗi lần sửa.

## 2. WP31 / WP32 (lượt 4, HEAD `497019c07`)

- **WP31 ĐẠT:** unit 91, integration 41, vitest 134 (6 tệp); đột biến 5/5 đỏ (đổi mật khẩu bắt buộc, trần 12 giờ, header hoạt động, hàng phiên, không Authorization). S3: (1) đăng xuất trả 409 mà phiên vẫn sống khi 8 luồng gia hạn dồn dập (6/6 vòng); tải thực tế 0/75 lần, nguyên nhân gia hạn dùng `ExecuteUpdate` làm đổi xmin còn đăng xuất sửa có theo dõi (`AdminLogoutHandler.cs:33-34`, `EfAuthRepository.cs:203`); (2) seed gỡ quyền không xoay `token_version` (seed 02 dòng 436-438) ⇒ quyền cũ sống tới 12 giờ (đã biết). S4: thiếu ca biên `now == exp`; không kiểm khởi động khi phút phiên xưởng ≤ 62 (PWA xưởng không gửi header nên chưa gây hại).
- **WP32 CẦN SỬA trước khi bật:** unit 48, integration 44, đột biến 5 (W1, W2 chỉ integration bắt ⇒ cổng phải chạy integration); thời gian phản hồi hai nhánh không đủ phân biệt (120 lượt/nhánh, chênh p50 −0,44/−0,25 ms, AUC 0,455/0,513) ⇒ **không lộ tài khoản**. Điểm: **(e) S1 có điều kiện:** chiếm được hộp thư công ty ⇒ đặt lại được mật khẩu R-ADMIN và R-DEVOPS, phiên mới có ADMIN_FULL + USER_MANAGE, mật khẩu cũ chết, thư báo về chính hộp thư bị chiếm; thu hẹp nhỏ nhất: từ chối khi người dùng giữ ADMIN_FULL hoặc vai R-ADMIN/R-DEVOPS (`CompletePasswordReset.cs:181`, `WorkEmailCodeIssuer.cs:50`, cùng 422/NOT_ELIGIBLE nên không đổi thời gian hay thân). **(d) S3:** kẻ lạ sai 15 lần (không cần mã sống) khoá hộp thư nhân viên 24 giờ (không đường mở khoá admin; đăng nhập mật khẩu vẫn được). **(b) S3/S4:** hàng đợi 500 đầy vẫn 202 nhưng mã không phát (0 thư, bị trừ 1/3 lượt gửi); cần ~9–10 IP dội 60 yêu cầu/giây. **(c) S3 nếu cấu hình sai:** `M12_FRONT_PROXY_CIDR`/`M12_CADDY_IP` sai ⇒ cả Internet thành một IP, dùng chung hạn mức (từ chối dịch vụ, không rò dữ liệu); chưa kiểm được trên `.99`. (f) S4: hàng đợi không bền khi khởi động lại. (g) số thật: IP 60 gửi/120 xác nhận mỗi 15 phút (tài liệu ghi 10, **đã sửa tài liệu**), mail 3/15 phút + 10/24 giờ, 5 sai huỷ mã, 15 sai khoá 24 giờ.

## 3. Đỏ ngoài phạm vi phát hiện được

- `UserDetailWp29IndependentTests.U02_CreateInternalUser…` ĐỎ thật: test viết trước #17 nên nhận 422 `ROLE_ASSIGNMENT_EXCEEDS_ACTOR_PERMISSIONS` (hành vi sản phẩm đúng). **Đã sửa test (commit `738d91808`, lớp 31/0, hai đột biến đỏ).**
- `WorkEmailIndependentR3Tests.E08_ConcurrentVerify…` chập chờn khi chạy cả lớp, xanh riêng (4 giây).

## 4. Cần Toàn quyết (đề xuất ở cuối mỗi dòng; trả "theo đề xuất" là đủ)

| Mã | Nội dung | Phương án | Đề xuất |
|---|---|---|---|
| m12.214 | WP32 (e): đặt lại mật khẩu bằng hộp thư cho R-ADMIN/R-DEVOPS (gộp m12.209) | A thu hẹp (từ chối khi giữ ADMIN_FULL/R-ADMIN/R-DEVOPS; admin đặt lại bằng đường khác) · B chấp nhận rủi ro · giữ cờ TẮT tới khi chọn | **A, cờ TẮT tới sau nghiệm thu** |
| m12.215 | WP32 (d): kẻ lạ khoá hộp thư 24 giờ | A chỉ tính lần sai khi có mã sống + admin mở khoá được · B giữ | **A trước khi bật** |
| m12.212 | Đặt lại mật khẩu/gắn mail/gỡ vai: so quyền tài khoản đích (F2 lượt 1) | A guard "quyền đích ⊆ quyền mình" (ADMIN_FULL miễn) · B chỉ cấm đích R-ADMIN · C để vậy | **A** |
| m12.213 | `RemoveUserRole` thiếu guard (F3) | A chặn tự gỡ + vai ADMIN_FULL cuối + cấp bậc · B chỉ cấp bậc | **A** |
| m12.211 | Ba phiếu nhập kho giảm ô ký còn DAY_LEADER được (tự ký) | A đặt sàn QC + kế toán kho · B giữ D-m12-130 | **A** |
| m12.208 | Admin tạo/gán user mang R-BOD (vòng "quản trị không xem giá vốn", vết ở audit) | A chặn ADMIN_FULL gán/tạo người mang 4 mã · B giữ D-m12-099 | **B** |
| m12.210 | Loại SKU mới thiếu cờ "cấm nguyên liệu động vật" (P14-Q1) | A thêm cột cờ · B giữ như đã chốt, làm khi có loại chay thứ hai | **B** |
| m12.216 | Đổi tên nhóm SKU không cập nhật tên trên SKU cũ (P14-Q2) | A đọc tên qua nối bảng · B chấp nhận, hạn chế đổi tên | **B** (chưa cần đổi tên nhóm gốc) |
| m12.217 | Giá dòng bỏ `taxRate` ⇒ thuế 0 (có từ trước P1b; bao bì thiếu CHECK DB) | A bắt buộc `taxRate` (nullable + 422) · B làm sau chạy thật | **B** |

Nếu duyệt "theo đề xuất": mình giao coder sửa m12.212, m12.213, m12.211 (A) và chuẩn bị m12.214/215 (A, chỉ bật cờ sau nghiệm thu), rồi gộp một lượt kiểm lại ngắn phần đổi trước khi đưa lên `.99`.

## 5. Ghi vào hướng dẫn chạy thật

1. **Đăng nhập lại sau seed 02** (và mọi seed đổi quyền): 11 vai (kế toán, kiểm toán, kế hoạch, ban giám đốc, QA/QC, quản lý vận hành/sản xuất) chỉ thấy quyền mới sau khi đăng nhập lại (tối đa 12 giờ), hoặc xoay `token_version` của người thuộc các vai đó.
2. Seed THU HẸP quyền phải kèm xoay `token_version` (nếu không quyền cũ sống tới 12 giờ).
3. Nạp bản mới lên `.99` (cần lệnh Toàn): dựng 5 ảnh từ commit mới nhất, `docker save | ssh`, `trien-khai.sh`; phần sửa của cổng (F1, P14, RS-5, GTIN, compose chạy thật) CHƯA ở `.99`.
4. Cờ: `Auth:PasswordReset:Enabled` giữ TẮT; `Auth:Jwt:SlidingRenewalEnabled` đang BẬT (tắt khẩn `Auth__Jwt__SlidingRenewalEnabled=false`).
