# Cổng Nguy hiểm: kết quả kiểm độc lập vùng #17 + P13 (24/11, HEAD `2508575d7`)

Người kiểm: verifier độc lập (không phải người viết), chạy 22:56 → 23:54 với khoá `@bo-kiem-du` + `@dot-bien`. HEAD đầu = cuối = `2508575d7`; cây chỉ còn 3 tệp supplier-portal dirty (không phải của m12). Mọi đột biến đã chép nguyên bản lại (so SHA-256), probe tạm và thư mục `.artifacts` đã xoá. Bộ đủ KHÔNG chạy theo luật. Chưa thử: ca đua đồng thời thật, đăng nhập lại sau F1, đường gắn mail công ty, giao diện trên trình duyệt, `.99`.

**Kết luận: cả hai vùng CẦN SỬA, cùng một lỗi mức cao F1.** Mọi guard khác đều có đột biến làm đỏ.

| Lệnh | Kết quả |
|---|---|
| Unit `Wp33No17` | 193 đạt (số lệch brief 21 vì lọc đếm cả hàng của ca nhiều dữ liệu) |
| Unit `UserRoleSelfAssignment` | 13 đạt |
| Unit `Wp33P13` | 51 đạt |
| Integration `Wp33No17` + `Wp33P13` (Docker) | 7 đạt (2 + 5) |
| Vitest 9 tệp quyền/vai | 79 đạt |
| Đột biến | #17 + RS-5: 11/11 đỏ · P13: 13 đỏ, 1 xanh tương đương (bỏ quyền chỉ ở lớp endpoint, lớp `PermissionBehavior` vẫn chặn) |

## Lỗi phải sửa

| Mã | Mức | Chỗ | Nội dung | Xử lý |
|---|---|---|---|---|
| F1 | S2 | `RolePermissionEscalationGuard.cs:15` | Người giữ `ADMIN_FULL` cấp được MỌI mã cho một vai, kể cả 4 mã `ADMIN_FULL` cố ý không hàm ý (xem giá vốn, nhập giá, duyệt huỷ hai tầng). Tái hiện: một lệnh `POST /roles/R-ADMIN/actions` trả 200, DB có đủ 4 mã ⇒ admin tự cấp cho vai mình, đường lách RS-5 chưa đóng | **Đang sửa** (coder `m12/fix-F1`): đường gán quyền cho vai chỉ cho cấp 4 mã khi giữ trực tiếp trong token; đường gán vai cho người dùng giữ nguyên (admin khác gán R-BOD vẫn được, D-m12-099) |
| F2 | S2 (có điều kiện), ngoài diff | `ResetInternalUserPasswordHandler.cs:31` | Chỉ chặn tự đặt lại, không so quyền tài khoản đích: người chỉ có `USER_MANAGE` đặt lại được mật khẩu tài khoản `R-ADMIN` (probe 200) = chiếm quyền admin. Hôm nay chỉ `R-ADMIN` giữ `USER_MANAGE` (seed 02 dòng 482), nhưng P13 cho cấp mã này cho vai mới. Đường gắn mail công ty (`UserEndpoints.cs:232`) chưa thử | **Chờ Toàn quyết (m12.212)** |
| F3 | S3 | `RemoveUserRoleHandler.cs:35` | Chỉ chặn gỡ vai CUỐI. Không chặn tự gỡ, không guard admin cuối, không guard cấp bậc: người chỉ giữ `USER_MANAGE` gỡ được `R-ADMIN` khỏi admin có 2 vai (probe 200). Hai guard đầu có ở `DeactivateInternalUserHandler.cs:27-39` | **Chờ Toàn quyết (m12.213)** |
| F4 | S3 | `EfDemandPlanToPackagingPurchasePlanningProcurementFamilyRepository.cs:41-47` (+ `...DemandBoardFormGuards.cs:179-185`), `EfOperationalFormWriteRepository.RoleConfirmationRules.cs:101-103`; ba hàm đọc vai không lọc vai ACTIVE (`OperationalFormActorRoleLookupService.cs:15`, `EfApprovalRepository.cs:94`, `EfGovernanceRepository.cs:77`) | Còn kiểm theo TÊN vai ở bảng nhu cầu sản xuất mức CRITICAL và ký phiếu `R-ADMIN`; vai đã ngừng vẫn tính trong các kiểm theo mã vai | Ghi nợ, chưa sửa (cần chọn mã quyền thay cho tên vai) |
| S4 | S4 | — | Chưa có test pin từng lớp quyền của tạo vai; không có test cho F1/F3; bình luận seed 02 dòng 1114 lỗi thời | F1 kèm test; còn lại ghi nợ |

## Rủi ro đã thử, kết quả

- Tự gán R-ADMIN / vai rộng hơn quyền mình: bị chặn (unit + integration, đột biến đỏ). Admin tự gán R-BOD qua HTTP: 403 `FORBIDDEN`, DB không ghi; gán cho người khác vẫn được (đúng quyết định).
- Mọi đường gán vai khác an toàn: tạo nhân viên (có guard), nhà cung cấp (cố định `R-SUPPLIER`), khởi tạo quản trị (không guard nhưng bị chặn ngoài Dev/Test/E2E bởi `ProductionSecurityConfigurationValidator.cs:442`), import (không có đường).
- Token cũ thiếu 4 mã mới: đúng thiết kế, an toàn theo hướng từ chối; gia hạn phiên chỉ chép claim cũ, trần 12 giờ. Seed 02 không xoay `token_version` ⇒ 11 vai (kế toán, kiểm toán, kế hoạch, ban giám đốc, QA/QC, quản lý vận hành/sản xuất) tạm mất xem giá/nhập giá/duyệt huỷ tới khi đăng nhập lại (S4) ⇒ **ghi vào runbook chạy thật: "đăng nhập lại sau seed 02"**.
- Đua P13/P10: ghi SERIALIZABLE tự thử lại 6 lần (`TransactionBehavior.cs:65`, `EfUnitOfWork.cs:51`); chưa thấy kịch bản "luật không ai duyệt"; `ADMIN_FULL` luôn qua cổng duyệt. S4.

Câu hỏi mở: m12.212 (F2), m12.213 (F3); F4 ghi nợ. Log đột biến: scratchpad phiên (không đưa git).
