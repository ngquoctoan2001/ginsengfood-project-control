# Rà giao diện admin-web: tên/mã (StackedCell) + phông khác — 18/11/2026

Lệnh Toàn 18/11: cột Nguồn gốc `/admin/raw-material/lots` dùng `StackedCell` (tên trên, mã dưới), rà mọi cột tương tự + phông chữ mã khác,
liệt kê và đề xuất. Rà CHỈ ĐỌC trên `ee99e9fd6` (agent Explore). Đường dẫn tính từ `apps/admin-web/src/features/` (riêng `components/…` từ `src/`).
Quy ước: thực thể có cả tên và mã ⇒ `StackedCell` (`components/ui/StackedCell.tsx`): tên đậm trên, mã nhỏ mờ dưới; mọi chữ trong bảng cùng một phông.

## Đang sửa (gói UI 18/11, chưa commit)
Cột Kho `/admin/inventory/allocations` (StackedCell) · Mã lý do + Mã cấu hình `/admin/master-data/reason-config` (bỏ `<code>`) · GTIN hộp/thùng `/admin/packaging/trade-items`
(bỏ `<code>`) · Nguồn gốc `/admin/raw-material/lots` (vòng 2: thêm `supplierCode`/`sourceOriginCode`/`sourceZoneCode` vào API lô rồi StackedCell).

## A. Tên/mã
A1 = tên và mã 2 cột riêng · A2 = ghép một dòng · A3 = chỉ có mã (hoặc chỉ tên) · A4 = StackedCell/tự dựng NGƯỢC (mã trên).

| # | Trang | Tệp:dòng | Cột | Hiện | Đề xuất | Trường tên / mã | Mức |
|---|---|---|---|---|---|---|---|
| 14 | /admin/production/orders/[id] | production/screens/production-orders/ProductionOrderSnapshotPanel.tsx:49-53 | Nguyên liệu | A2 `mã - tên` | StackedCell | ingredientDisplayName / ingredientCode | CAO |
| 15 | /admin/finished-goods-warehouse/stock/[skuId] | finished-goods-warehouse/FinishedGoodsWarehouseStockPage.helpers.tsx:441-448 | Đơn vị thương mại | A2 | StackedCell | tradeItemDisplayName / tradeItemCode | CAO |
| 16 | như #15 | …helpers.tsx:461-470 (`referenceLabel` :46-58) | Kho; Vị trí | A2 | StackedCell | .name / .code | CAO |
| 17 | /admin/inventory/adjustments | warehouse-inventory/InventoryAdjustmentsPage.columns.tsx:71-81 | Kho | A2 (`label` API ghép) | StackedCell | warehouse.name / code | CAO |
| 18 | /admin/inventory/allocations | warehouse-inventory/InventoryAllocationsPage.tsx:311-315 | Mặt hàng / lô | A2 "LÔ - MÃ NL - Tên" | StackedCell | **cần thêm trường tên** (tạm `itemNameFromLabel`) | CAO |
| 25 | /admin/packaging/jobs | packaging-printing/screens/packaging-jobs/packaging-job-columns.tsx:41-49 | Thương phẩm | A3 chỉ GTIN `<code>` | StackedCell | tradeItemDisplayName / tradeItemCode | CAO |
| 34 | /admin/raw-material/packaging-intakes/[id] | raw-material/screens/PackagingIntakeDetailPage.parts.tsx:283-286 | Vật tư | A4 primary = mã | Đảo | materialName / materialCode | CAO |
| 35 | /admin/demand-mrp-stock-alert (MRP) | demand-mrp-stock-alert/components/columns.tsx:223-232 | Nguyên liệu | A4 tự dựng | StackedCell | materialName / materialCode | CAO |
| 36 | /admin/sellable | sellable/SellablePage.components.tsx:133-140 | SKU | A4 tự dựng | Đảo | displayName / skuCode | CAO |
| 37 | /admin/raw-warehouse/stock | raw-warehouse/RawWarehouseStockPage.tsx:301-309 | Nguyên liệu | dòng phụ là mã LÔ | secondary = mã NL | ingredientName / ingredientCode | CAO |
| 1 | /admin/master-data/b3-stock-policy | master-data/screens/B3StockPolicyPage.tsx:133-134 | Mã + Tên vật tư | A1 | Gộp "Vật tư" | materialName / materialCode | VỪA |
| 2 | /admin/master-data/material-warning-thresholds | master-data/screens/MaterialWarningThresholdPage.tsx:130-131 | như #1 | A1 | Gộp | như #1 | VỪA |
| 3 | /admin/production/equipment | production/screens/equipment/EquipmentListPage.tsx:182-186 | Mã + Tên thiết bị | A1 | Gộp | equipmentName / equipmentCode | VỪA |
| 5 | /admin/production/shifts | production/screens/production-shifts/ProductionShiftsListPage.tsx:191-195 | Mã + Tên ca | A1 | Gộp | shiftName / shiftCode | VỪA |
| 6 | /admin/material/requests (chi tiết) | production/screens/material-requests/MaterialRequestDetail.tsx:21-30 | Mã NL + NL | A1 | Gộp | displayName / displayCode | VỪA |
| 7 | /admin/qc-release/inspections/[id] | qc-release/QcReleaseScreens.parts.tsx:249-256 | Hạng mục | A1 | Gộp | itemName / itemCode | VỪA |
| 8 | /admin/system/users-roles | system/screens/UsersRolesPage.RolesTab.tsx:153-160 | Mã + Tên vai trò | A1 | Gộp | roleName / roleCode | VỪA |
| 9 | như #8 | system/screens/UsersRolesPage.UserColumns.tsx:27-28 | Tên đăng nhập + Họ tên | A1 | Gộp "Người dùng" | displayName / username | VỪA |
| 10 | /admin/master-data/suppliers/[id]/users | suppliers/screens/SupplierUsersTable.tsx:20-21 | như #9 | A1 | Gộp | như #9 | VỪA |
| 19 | /admin/inventory/adjustments (xuất bán) | warehouse-inventory/InventoryAdjustmentsPage.sales-issue.tsx:221; 225-226 | Mặt hàng; Kho/vị trí | A2 | StackedCell | như #17/#18 | VỪA |
| 20 | /admin/warehouse/receipts/[id] | warehouse-inventory/screens/WarehouseReceiptDetailPage.tsx:77-88 | Mã trade item | A2 | StackedCell, tiêu đề "Thương phẩm" | skuDisplayName / tradeItemCode | VỪA |
| 21 | /admin/demand-mrp-stock-alert (cảnh báo) | demand-mrp-stock-alert/components/columns.tsx:359-366 | Phạm vi | A2 | StackedCell SKU, kho tách | skuName/skuCode; warehouseName/Code | VỪA |
| 26 | /admin/printing/qr-registry | packaging-printing/screens/QrRegistryPage.tsx:585-593 | Thương phẩm | A3 chỉ GTIN `<code>` | StackedCell | displayName (tradeItemsQuery) / tradeItemCode | VỪA |
| 27 | /admin/traceability/search, /genealogy | traceability/TraceabilityScreens.components.tsx:446-449, 545-558 | Mã/tên; Từ; Đến | A3 `code ?? displayName` | StackedCell | TraceNodeDto.displayName / code | VỪA |
| 28 | /admin/qc-release/batches | qc-release/screens/BatchReleaseQueueScreen.tsx:200-203 | SKU | A3 chỉ mã | StackedCell | **cần thêm skuName** | VỪA |
| 29 | /admin/material/issues | production/screens/material-issues/MaterialIssuesPage.tsx:96-98 | Nguyên liệu | A3 chỉ mã | StackedCell | **cần thêm tên NL** | VỪA |
| 30 | /admin/raw-material/packaging-lots | raw-material/screens/PackagingLotsPage.tsx:160-166 | Vật tư | A3 mã ở dòng chính | Tên trên, mã dưới | **cần thêm packagingMaterialName** | VỪA |
| 38 | /admin/catalog/skus/[skuId] | catalog/components/shared.tsx:470-482 | Thương phẩm | A4 | Đảo | tradeItemDisplayName / tradeItemCode | VỪA |
| 39 | /admin/source-origin/zones | source-origin/screens/SourceZoneCapacityReconciliationSection.tsx:80-86 | Vùng trồng | A4 | Đảo | sourceZoneName / Code | VỪA |
| 40 | /admin/printing/queue | packaging-printing/screens/PrinterRuntimePanel.tsx:128-148 | Máy in | A4 | Đảo | displayName / deviceCode | VỪA |
| 4, 11–13, 22–24, 31–33, 41 | thiết bị/bước sơ chế, màn hình hệ thống, tài khoản dịch vụ, phiếu thành phẩm, kho NL nguồn, ký phiếu, người vận hành (**cần operatorName**), các cột chỉ có tên | xem bản rà gốc trong nhật ký | | | | | THẤP |

Chỗ tự dựng 2 dòng ĐÚNG thứ tự, nên đổi sang StackedCell cho đồng nhất (THẤP): EquipmentUsageDialog.tsx:72-82, MobileDevicesPage.tsx:86-87,
UsersRolesPage.FormSigningTab.tsx:128-142, PackagingIntakeFormGenerateAction.tsx:31-38, AuditLogPage.tsx:353-368, catalog/components/shared.tsx:374-381.

## B. Phông khác
Gốc: `<code>`/`<kbd>` mặc định trình duyệt là monospace, `design/global.css` không đặt lại.

| Chỗ | Tệp:dòng | Số | Bỏ/Giữ | Lý do |
|---|---|---|---|---|
| `<code>` mã điều kiện, cấp đóng gói, GTIN_13 (chi tiết SKU) | catalog/components/shared.tsx:378, 463, 489 | 3 | Bỏ | mã nghiệp vụ trong ô bảng |
| `<code>` GTIN cột Thương phẩm | packaging-job-columns.tsx:48; QrRegistryPage.tsx:591 | 2 | Bỏ | đi cùng #25–26 |
| `<code>` QR/Mẻ hộp thoại chi tiết | QrRegistryPage.dialogs.tsx:185-186 | 2 | Bỏ | mã nghiệp vụ |
| `fontFamily: monospace` số phiếu, mã vật tư (cổng NCC) | supplier-portal/screens/SupplierIntakesPage.tsx:110; SupplierPackagingIntakesPage.tsx:62; PackagingIntakeLinesSection.tsx:57 | 3 | Bỏ | NCC đọc trực tiếp |
| `<code>` objectCode cột Phân hệ/nguồn | reporting/AlertsPage.parts.tsx:234 | 1 | Bỏ | mã nghiệp vụ |
| `<code>` cột Hành động | system/screens/OverridesPage.tsx:321 | 1 | Bỏ | nên hiện nhãn tiếng Việt, mã dòng phụ |
| `monoStyle` MISA ở số đếm / câu "Bàn giao…" | MisaSyncJobsPage.tsx:141, 239; MisaIntegrationPanels.tsx:688-702 | ~5 | Bỏ | số và câu chữ |
| `.evg-sub` ngày tải bằng chứng | components/evidence/evidence-gallery.css:374 | 1 | Bỏ | ngày giờ người dùng đọc |
| `<code>` còn lại màn thương phẩm | TradeItemsPage.components.tsx:205, 399, 444, 460 | 4 | Bỏ | cùng gói GTIN |
| tabular-nums + giãn chữ "Số phiếu" | operational-forms/forms-admin/FormInstancesListPage.tsx:87-90 | 1 | Bỏ (thấp) | |
| UUID, hash, correlation id, mã lỗi, JSON, phím tắt, endpoint MISA, mã quyền kỹ thuật, `.mono`/`.num` biểu mẫu (chỉ tabular-nums) | AlertsPage P16, Override drawer, AuditIntegrity, Outbox, AuditLog, MISA id, JsonEditor/Viewer, CommandDialog, ConfirmDialog… | ~60 | Giữ | khoá kỹ thuật/khối code thật |

## C. Tiêu đề/ô chi tiết ghép "MÃ - Tên"
`skuLabel` FinishedGoodsWarehouseStockPage.helpers.tsx:237-243 · `ingredientTitle` RawWarehouseStockPage.helpers.tsx:194-201 · WarehouseReceiptDetailPage.tsx:181-187 (ô Kho, :265).

## Lưu ý StackedCell
`components/ui/StackedCell.tsx:44` tự thêm "- " trước dòng phụ ⇒ chỗ dòng phụ không phải mã cũng hiện "- …" (PackagingLotsPage.tsx:173 "Nhận …",
demand columns.tsx:66, RawWarehouseStockPage.tabs.tsx:371, ô Kho/Vị trí ở Ledger, LotBalance, RawLots, WarehouseReceipts).

## Đếm
A1 13 · A2 11 · A3 9 · A4 8 · B bỏ ~26, giữ ~60. Cần thêm trường API: tên mặt hàng (#18), skuName (#28), tên NL dòng phiếu xuất (#29), packagingMaterialName (#30), operatorName (#31).
