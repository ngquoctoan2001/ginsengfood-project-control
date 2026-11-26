# M1–M2 · Bàn giao góp ý UAT đã duyệt ngày 26/11

Đối chiếu tĩnh ops-core `d4163331ce9804f625c81bc448a23a2298f757b4` với D-m12-140 và kết quả UAT 25/11. Ba mục **232, 234, 235 còn cần sửa**. Dùng chung checkout `main`. Thực hiện sau khi phiên UAT kết thúc lượt trên bản hiện tại. Phiên này chưa sửa mã, chưa chạy test và chưa xác nhận trạng thái `.99`.

## m12.232 · Cột Chặn mua

- `apps/admin-web/src/features/demand-mrp-stock-alert/components/columns.tsx:272,302–318` có `netRequirementQuantity` nhưng ô Chặn mua chỉ dùng `suppressionStatus`. Sửa tại ô này. Khi nhu cầu ròng là số hữu hạn ≤ 0, hiện badge trung tính **Chưa cần mua**. Trường hợp ròng dương hoặc thiếu dữ liệu dùng nhãn và màu theo trạng thái hiện hành. Giữ cổng nghiệp vụ, bộ lọc và bản đồ trạng thái dùng chung.
- Kiểm lọc bảng MRP và chạy lại bước hiển thị của **C05-F02-T10** với ròng 0. Thêm đối chứng ròng âm, ròng dương, thiếu giá trị và trạng thái đang chặn/đòi duyệt ở dòng dương. Hồ sơ 25/11 ghi sáu ca C05-F02-T07…T12 đã đạt phần mở ngữ cảnh sau `466245762`, riêng nhãn T10 vẫn là góp ý mở.

## m12.234 · Chi tiết nhật ký giữ hàng ngoài

- `services/operational-api/src/Ginsengfood.Operational.Application/Commands/WarehouseInventory/ReserveExternalInventoryAllocation/ReserveExternalInventoryAllocationHandler.cs:508–529` đã ghi `requestedExpiresAt`, `totalHoldDeadline`, `expiresAt` và `cappedAtTotalHold` trong snapshot `INVENTORY_ALLOCATION_HOLD_EXTENDED`. `AuditMappings.cs:19–47` chỉ đẩy metadata sang `AuditLogDto.cs` và `apps/admin-web/src/features/system/screens/AuditLogPage.tsx:264–299` chỉ có metadata để hiển thị.
- Thêm phép chiếu có kiểu vào DTO (`packages/api-contracts/src/Ginsengfood.Operational.Contracts/Audit/AuditLogDto.cs`) cho đúng sự kiện gia hạn và đối tượng `op_inventory_allocation`. Trả các mốc giờ và cờ theo danh sách trường cho phép. Snapshot cũ, thiếu trường hoặc lỗi dữ liệu vẫn mở được nhật ký, với giá trị thiếu hiện `—`. Phân biệt `false` (**Không**) và chưa có dữ liệu. Giữ `AUDIT_VIEW`, giữ snapshot gốc ở máy chủ và đồng bộ OpenAPI/client được sinh theo quy trình repo.
- Trong ngăn chi tiết, dùng **Tự nhả do hết hạn** cho đúng sự kiện nhả giữ hàng, actor worker `system.allocation-expiry` và lý do chính xác `ALLOCATION_EXPIRED`. Dùng formatter thời gian hiện có. Giữ nguyên nội dung lý do nhập tay và định dạng xuất CSV. Nguồn worker `ExpiredInventoryAllocationReleaseService.cs:42,49,88–99`.
- Kiểm mapping và mở rộng `tests/frontend/admin-web/component/ui/audit-log-ui.test.tsx` theo một lượt. **O07-F06-T99** đối chiếu gia hạn trong trần và gia hạn bị cắt, đủ ba mốc, cờ đúng. **O07-F06-T100** và bước xem nhật ký trong **H05-F04-T02** đối chiếu lý do khi worker nhả. Kiểm thêm record cũ, snapshot lỗi, sự kiện ngoài phạm vi và lý do nhập tay trùng chuỗi. Khi mô tả cấu hình, giữ rõ mặc định backend khi bỏ hạn là **30 phút**, trần mỗi lượt **26 giờ**, trần tổng **48 giờ**. M3 gửi hạn 26 giờ theo chính sách phía M3.

## m12.235 · Dấu vết phát hành khi tem còn chờ in

- `EfBatchReleaseReadinessGate.cs:191–208` đã trả `PrintDeferredByReleaseScope` từ điều kiện `PRINTER_DEFERRED` đủ cổng in và có job `QUEUED`. `ApproveBatchReleaseHandler.cs:144–185` hiện gọi `BuildReleasePayload` và ghi `BATCH_RELEASED` nhưng không hề lưu cờ ở thời điểm duyệt. Hai đường duyệt trực tiếp và xác nhận FRM-21 kết luận `RELEASED` đều qua handler này. Dấu hiệu động của tem đã in không đủ để tra lịch sử.
- Lấy cờ từ lần `CheckAsync` duyệt thành công. Khi cờ đúng, ghi `printDeferredByReleaseScope: true` vào `releasePayload` và audit `afterSnapshot` trong cùng lượt lưu hiện có. Sửa hẹp tại handler và `QcReleaseCommandSupport.cs:73–79,122–161`. Giữ ghi chú của lần tạo yêu cầu và các trường payload cũ nếu lần duyệt không có ghi chú mới, theo `OpBatchRelease.cs:77–84`. Khi có ghi chú mới, giữ hành vi hiện tại. Giữ trạng thái, lý do, số bản ghi audit và outbox. `QcReleaseScreens.tsx:183–212,250` có sẵn mục đã duyệt trong Lịch sử phát hành. Đọc boolean `true` từ `releasePayload` đang có trên DTO và hiện **Phát hành khi tem chưa in** ở mục đó, với fallback an toàn cho payload cũ. Nếu cần hiện ngay ở màn Nhật ký kiểm toán chung, dùng phép chiếu boolean riêng cho `BATCH_RELEASED` cùng lượt đồng bộ DTO với m12.234. Tránh nối chuỗi vào lý do vì ghi chú đã có giới hạn độ dài.
- Kiểm lọc `QcReleaseBehaviorTests.cs` và luồng FRM-21 trong `QcBatchReleaseWorkflowIntegrationTests.cs`. Theo **G02-F02-T04**: `FULL` với tem chờ in vẫn bị chặn, không ghi sự kiện phát hành. `PRINTER_DEFERRED` với tem chờ in ghi dấu đúng một lần, in bù xong vẫn thấy dấu lịch sử. `PRINTER_DEFERRED` với đủ tem đã in không phát sinh dấu. Kiểm duyệt qua FRM-21, replay và giữ ghi chú cũ khi duyệt không gửi ghi chú. Hồ sơ G02-F02-T04 đã đạt ở cả hai profile trên lab 25/11, phần còn mở là dấu vết audit.

## Những việc giữ quyết định hiện hành

| Việc | Bằng chứng và phần còn lại |
|---|---|
| **m12.109** | D-m12-135 chốt đường FRM-21: kết luận `HOLD` rồi duyệt trên màn với yêu cầu còn chờ, hoặc kết luận `RELEASED` và hệ thống tự duyệt. Giữ luồng, sửa sổ tay/catalog nơi lệch; ca G02-F02-T01/T05/T06/T07 đã đạt đường HOLD trên lab 25/11. |
| **m12.115** | `4226499b9` đã trả cấp đóng gói trên QR nên R-QA-REL mở được truy xuất BOX với quyền hiện có. Commit nằm trong `d4163331c`. F03-F02-T01/T04/T05 có bằng chứng lab; không cấp thêm `TRADE_ITEM_VIEW`. |
| **m12.116** | `85d56310f` tự điền thời gian, nhiệt độ thực tế và dòng lô cho FRM-28/29 mới. Commit nằm trong `d4163331c`; E04-F04/F05/F09-T01 có bằng chứng lab. Phiếu đã sinh từ trước không tự cập nhật. Theo D-m12-140, giữ quy ước hiện hành, chờ chú Dũng xác nhận trường bổ sung nếu đổi mẫu. |
| **WP28 / M12-115** | Còn cổng bố cục sau WP33. Chuẩn bị danh sách 95 màn admin, 18 màn xưởng, trang công khai và các màn mới của WP29/30/33. Ghi coverage tab, dialog, dòng và trạng thái; lấy ảnh độc lập rồi Toàn thao tác mẫu 20 màn. Dùng `tools/ui-audit/` và đọc `coverage.json`, tránh suy coverage toàn nhóm từ một lần lọc. Xếp sau lượt UAT ưu tiên. |
| **WP33 / M12-123** | Hồ sơ WP33 ghi 25/25 gói và gói dọn đã vào mã, gồm `3142ef9a1` và `417f15d53`. Phần cần tiếp tục theo hồ sơ là kiểm trên bản phát hành, vai trò hiển thị ở app xưởng (`shopfloor-account-model.ts:12–36`) và kiểm theo vai cứng về CRITICAL của DemandBoard ghi để sau. Hai ca FE `permission-openapi-coverage` và `material-request-frm-binding-ui-static` từng bị ghi đỏ ngày 25/11; dùng đúng bản và kiểm hẹp nếu cần chốt. Phần Nguy hiểm giữ điều kiện duyệt theo hồ sơ riêng. |
| **m12.230/231/233** | 230 siết tạo phiếu bao bì và 233 thống nhất số có thể bán để sau chạy thật. 231 giữ hiển thị thuế suất theo quyết định đã duyệt. |

## Thứ tự thực hiện và kiểm

1. Phiên UAT hoàn thành lượt ưu tiên trên `d4163331c` rồi xác nhận dừng runner trước khi cập nhật mã dùng chung. Sau đó khai khoá theo đường dẫn. Có thể làm phần 232 độc lập với hai phần audit, và ghép các đổi DTO/ảnh hiển thị 234–235 trong một lượt.
2. Phiên chính đọc diff và chốt bản cần kiểm. **Chỉ phiên UAT** chạy kiểm lọc, lần lượt FE 232, audit 234, phát hành 235, rồi UI UAT theo ca nêu trên. Dùng fixture lab và bằng chứng đã có khi đúng phạm vi. WP28 xếp thành lượt riêng trong cùng phiên sau kiểm nghiệp vụ. Nếu có kiểm vùng Nguy hiểm, giao người kiểm độc lập trong lượt tuần tự của phiên UAT.
3. Ghi SHA, profile, ca và kết quả vào hồ sơ cục bộ. Giữ trạng thái các mục mở cho tới khi có chứng cứ phù hợp và Toàn duyệt các cổng thuộc phạm vi của mình.

Nguồn Project Control: [Quyết định D-m12-135 và D-m12-140](../QUYET_DINH.md) · [Rà 63 ca](2026-11-25-63-ca-ket-qua.md) · [Nhật ký 25/11](../nhat-ky/2026-11-25.md) · [WP28](../wp/M12-WP28-ui-bo-cuc-dong-bo.md) · [WP30–33](../wp/M12-WP30-33-gop-y-20-11.md).
