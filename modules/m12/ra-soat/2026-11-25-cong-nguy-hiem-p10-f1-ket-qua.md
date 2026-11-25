# Cổng Nguy hiểm: kết quả kiểm độc lập vùng P10 + kiểm lại F1 (25/11, HEAD `fdba2a1ad`)

Người kiểm: verifier độc lập thứ hai (không phải người viết, không phải người kiểm lượt 1), chạy 00:15 → 00:54 với khoá `@bo-kiem-du` + `@dot-bien`. HEAD đầu = cuối = `fdba2a1ad`; cây chỉ còn 3 tệp supplier-portal dirty (không phải của m12); `git diff HEAD` trên services/db/tests rỗng. Probe tạm đã xoá khỏi repo, `.artifacts` đã xoá, `ginsengfood-postgres-local` không đụng. Không kiểm: FE ngoài cổng quyền, bộ đủ/CI, `.99`, ca đua sửa vai × sửa luật duyệt (cần hai phiên), validation seed 21 đầy đủ.

**Kết luận: P10 CẦN SỬA mức nhẹ (mã đúng, thiếu một test; không có lỗi S1/S2). F1 ĐẠT.**

| Lệnh | Đạt / đỏ / bỏ qua |
|---|---|
| Unit `Wp33P10` + `SigningMatrixP10` | 49 / 0 / 0 |
| Unit `Wp33P13` | 78 / 0 / 0 |
| Unit `Wp33No17` + `UserRoleSelfAssignment` | 206 / 0 / 0 |
| Integration (5 lọc, Testcontainers) | 14 / 0 / 0 (4 ca P10, 10 ca P13/#17) |

## P10: đột biến và rủi ro

- Đột biến 5: bỏ 409 tắt luật bắt buộc (đỏ 6) · bỏ khoá 2 người luật mở khẩn cấp (đỏ 1) · DAY_LEADER không còn bị khoá (đỏ 3) · đồng bộ cả phiếu ký dở (đỏ 1) · **M4 bỏ nhánh `CASE ownerEdited` của seed 21 (dòng 865, 869): XANH với test của repo** ⇒ test không buộc seed chạm dòng; probe D3 của người kiểm bắt được (mã gốc qua, M4 đỏ). Đây là lý do duy nhất của "CẦN SỬA": thiếu test, đang bổ sung (coder `m12/fix-P10-test`).
- **Giảm ô ký ba phiếu nhập kho (nhập nguyên liệu, nhập bao bì, nhập kho thành phẩm) xuống chỉ DAY_LEADER: S3.** `PUT signing-roles` trả 200, audit có trước/sau và lý do. DAY_LEADER ký được bởi R-PROD-MGR, R-OPS-MGR, R-PROD-OP và seed cho phép tự ký (`selfReviewAllowed=true`) ⇒ một người sản xuất có thể tự lập và tự ký phiếu nhập kho không cần QC hay kế toán kho. Cổng "mẻ RELEASED" và luồng huỷ (DISPOSAL_REQUEST khoá cứng) vẫn giữ. D-m12-130 cho phép (`OperationalFormSigningMatrixRules.cs:91,132`). ⇒ **m12.211 cụ thể hoá, chờ Toàn.**
- Sửa ma trận khi phiếu ký dở: phiếu đã có chữ ký DAY_LEADER giữ bản chụp cũ, QC ký được, không kẹt, không bỏ qua duyệt; phiếu app sinh chưa ai ký theo ma trận mới. Phiếu có bản chụp không chứa ma trận rơi về ma trận sống của mẫu (`EfOperationalFormWriteRepository.ConfirmForm.cs:93`); test hiện có chỉ khẳng định DB không đổi, không khẳng định kết quả ký (S4, chỉ phiếu cũ).
- Cờ `ownerEdited` giả: seed 21 chạy 2 lượt vẫn giữ ma trận sai, chỉ validation bắt; cần quyền ghi DB (S4).
- Hai quyền riêng: `ROLE_VIEW` một mình ghi 403; `MASTER_DATA_WRITE` một mình chỉ PATCH metadata 200; `ROLE_PERMISSION_UPDATE` một mình chỉ PUT ô ký + PATCH luật duyệt 200; `ADMIN_FULL` cả ba 200; cùng khoá idempotency khác nội dung ⇒ 409.
- Tiền tố: 1 và 13 ký tự, gạch ngang, khoảng trắng 422; `QR`, `pl` 422 dành riêng; `SOCHE` 409 trùng; phiếu kế hoạch 422 khoá; `mrpx` 200 chuẩn `MRPX`; số phiếu cũ không đổi.
- Luật duyệt: request chỉ có vai, số người, bật/tắt, lý do; luật bắt buộc không tắt được; luật mở khẩn cấp không xuống 1 người.
- Đua: 12 vòng PUT song song có phiếu mở, 0 lệch. Hai PATCH song song cùng luật duyệt: cả hai 200, chỉ một bên thắng, bên kia mất âm thầm vì không có token phiên bản (S4).
- Replay seed 21/28/46 hai lượt trên DB sửa tay: giữ vai/số người duyệt, tên/thứ tự/tiền tố chủ đã sửa; khoá cứng bị ép lại; luật bắt buộc bị tắt tay thì seed chèn dòng ACTIVE mới.
- S4 nhỏ: PATCH metadata không bắt lý do; PUT ô ký không đổi gì vẫn ghi audit và gắn `ownerEdited` (`OperationalFormTemplateAdminCommands.cs:72-73`).

## F1 sau sửa: ĐẠT

- Probe gốc `POST /roles/R-ADMIN/actions` với token `ADMIN_FULL` và `admin.full`, 4 mã (gói và từng mã): 422 `ROLE_PERMISSION_NOT_HELD`, bảng quyền vai không đổi, audit +0. Biến thể: DENY rồi ALLOW hai bước, lẫn mã thường + mã ngoại lệ, chữ thường/khoảng trắng/ký tự rộng 0/Tab: đều 422, không ghi một phần.
- Vẫn cấp được: ADMIN_FULL cấp mã thường (200); token ADMIN_FULL + `COST_FIGURE_VIEW` cấp COST (200), cấp PURCHASE (422); người không ADMIN_FULL giữ COST trực tiếp cấp COST (200).
- Hồi quy gán vai cho người dùng: admin gán R-BOD cho người khác 200, tự gán 403.
- Đột biến 4 (bỏ nhánh loại 4 mã đỏ 12/284; `Contains` luôn đúng đỏ 15; bỏ `NotHeldDirectly` đỏ 18; bỏ pass-through ADMIN_FULL ở đường người dùng đỏ 11). Chỉ `SetRoleActionsHandler` ghi quyền vào vai (xác nhận).
- **S3 còn lại (D-m12-099, không phải lỗi mới):** `POST /users` bởi admin với vai `R-BOD` trả 201 ⇒ admin vẫn lập được tài khoản phụ có `COST_FIGURE_VIEW`, ý "quản trị không xem giá vốn" (16/11) bị vòng qua; vết còn trong audit `USER_CREATED`. Toàn đã duyệt D-m12-099 (admin KHÁC gán được); chờ xác nhận vẫn giữ hay chặn tạo/gán người dùng mang 4 mã ngoại lệ (**m12.208 cụ thể hoá**).

## Cần Toàn quyết

1. m12.211: đặt sàn ô ký (QC + kế toán kho) cho 3 phiếu nhập kho, hay giữ D-m12-130. Đề xuất: đặt sàn (thêm bất biến), vì tự lập tự ký phiếu nhập kho mất kiểm soát kho.
2. m12.208: chặn ADMIN_FULL tạo/gán người dùng mang 4 mã ngoại lệ, hay giữ D-m12-099 (vết ở audit). Đề xuất: giữ D-m12-099.
3. Đua hai PATCH luật duyệt (không có token phiên bản): chấp nhận hay thêm kiểm phiên bản. Đề xuất: chấp nhận (S4).
