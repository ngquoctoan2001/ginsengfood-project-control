# Rà chữ tiếng Anh trên giao diện M1–M2 — 18/11/2026

Lệnh Toàn 18/11: "rà soát 1 lượt xem còn chỗ nào trên ui còn sử dụng tiếng anh không? có thì liệt kê hết và đề xuất sửa nhé."
Rà CHỈ ĐỌC mã ops-core @ `ee99e9fd6` (2 agent: admin-web; PWA xưởng + trang truy xuất công khai + chữ từ backend/seed). Không chạy app, không vào DB.
Đường dẫn: `ADM` = `apps/admin-web/src/`, `PWA` = `apps/shopfloor-pwa/`, `c-` = `PWA/src/components/shopfloor-`, `APP` = `services/operational-api/src/Ginsengfood.Operational.Application/`,
`APIV` = `services/operational-api/src/Ginsengfood.Operational.Api/Validation/`, `SEED` = `db/seeds/`. ★ = người dùng gặp hằng ngày.

## 0. Tóm tắt

| Vùng | Người dùng thấy | Ghi chú |
|---|---|---|
| admin-web | ~30 câu tiếng Anh thuần · ~20 chỗ mã trạng thái thô (+ ~80 hàm tra nhãn có thể rơi về mã thô) · ~350 câu Việt lẫn từ Anh · ~70 câu lộ chữ kỹ thuật (endpoint, "Backend", mã enum, mã quyền) | Thành phần dùng chung (bảng, phân trang, tìm kiếm, chọn ngày, thông báo, 404 của trang con) đã Việt hoá; thiếu trang 404 chung |
| App xưởng (PWA) | ~109 chỗ (28 mục) | Nặng nhất cho công nhân: thanh trạng thái "API kết nối", tiền tố mã lỗi, mã lệnh/mã chặn thô, nhãn Check-in/lot/sale-lock |
| Trang truy xuất công khai | 0 | 3 chỗ ẩn (không hiện), ưu tiên thấp |
| Chữ từ backend | 6 câu chặn "Batch … sale lock active" (PWA quét mã) · ~30 câu kiểm dữ liệu tạo NCC (PWA) · ~140 câu chặn phiếu có mã đầu câu (admin) · nhãn phê duyệt/ghi đè · nội dung cảnh báo | admin-web đã chặn câu thô của backend, trừ danh sách tiền tố được phép |
| Dữ liệu seed | ★ 2 tên kho + 4 tên vị trí tiếng Anh · 90 tên màn hình · 287 tên thao tác · ~13 mô tả vai trò | Tên kho/vị trí hiện ở PWA hằng ngày; còn lại chỉ quản trị thấy |

## 1. App xưởng (PWA) — sửa ở FE trừ khi ghi khác

| # | tệp:dòng | Hiện tại | Đề xuất |
|---|---|---|---|
| 1★ | `c-shell.tsx:441-444` | "API kết nối" / "API không phản hồi" / "Đang kiểm tra API" (thanh trạng thái mọi màn) | "Đã kết nối máy chủ" / "Mất kết nối máy chủ" / "Đang kiểm tra kết nối" |
| 2★ | `c-shell.tsx:343-347` | "PWA đang xác thực cookie phiên với server…", "…truy cập Shopfloor PWA." | "Đang kiểm tra phiên đăng nhập…", "Bạn cần đăng nhập trước khi dùng app xưởng." |
| 3 | `c-shell.tsx:465-466` | "…effective permissions do server trả về. Backend vẫn là lớp authorization…" / "PWA đang offline…" | "Tài khoản chưa được cấp quyền mở màn hình này, liên hệ quản lý." / "Chưa kiểm tra được quyền vì mất mạng; dữ liệu chờ gửi vẫn được giữ." |
| 4★ | `c-auth-clients.tsx:58` | "Phiên trình duyệt dùng cookie bảo mật; PWA không lưu token." | bỏ, hoặc "Đăng nhập bằng tài khoản vận hành được cấp." |
| 5★ | `c-pwa-display.ts:209,245` | tiền tố "UNAUTHORIZED: …", "FORBIDDEN: …", "UNKNOWN_ERROR: …" | bỏ `${code}: `, chỉ hiện câu (mã để cuối nếu cần) |
| 6★ | `src/lib/api/mobile-client.ts:195,200,205,206`; `mobile-bootstrap-client.ts:61-62`; `mobile-auth-client.ts:101,104-105` | "Lệnh mobile chưa được hỗ trợ.", "Idempotency key không khớp payload.", "Mobile API phản hồi quá thời gian…", "…Shopfloor PWA", "API đăng nhập…" | "Thao tác này chưa hỗ trợ trên app.", "Lệnh gửi trước có nội dung khác, tải lại công việc rồi làm lại.", "Máy chủ phản hồi quá lâu, thử lại.", "…app xưởng", "Máy chủ đăng nhập…" |
| 7★ | `src/lib/pwa/offline-sync-controller.ts:363,393,429,436,639,646,707` | "Thiếu file bằng chứng local…", "Không upload được bằng chứng offline lên mobile API", "Batch đồng bộ có xung đột…" | "Thiếu tệp bằng chứng trên máy", "Chưa tải được bằng chứng lên máy chủ", "Lượt đồng bộ có mục xung đột…" (dòng 171-172 là chuỗi chết) |
| 8 | `src/lib/offline-queue/index.ts:408,711` | "…lệnh mobile này", "Mobile API không trả kết quả…" | "…lệnh này", "Máy chủ chưa trả kết quả…" |
| 9★ | `c-offline-queue-client.tsx:334`; `c-task-detail-client.tsx:498`; `src/lib/offline-queue/command-identity.ts:59` | mã lệnh thô: "Đã đưa PACKAGING_L1_CONFIRM vào hàng đợi…" | dùng `formatActionLabel` (nhãn đã có ở `display.ts:134-155`) |
| 10★ | `c-pwa-display.ts:160` (`formatStatus` trả mã khi thiếu nhãn) | DRAFT, COMPLETED, CLOSED, FAILED, HOLD, EXPIRED, DEPLETED, GENERATED, VOID, CREATED, INSPECTED, IN_PROCESS, RAW_LOT_QC_SIGNED, REVOKED | Nháp, Hoàn thành, Đã đóng, Lỗi, Tạm giữ, Hết hạn, Đã hết tồn, Đã sinh mã, Đã huỷ, Mới tạo, Đã kiểm, Đang xử lý, Đã ký KCS, Đã thu hồi; mặc định "Trạng thái khác" |
| 11 | `c-pwa-display.ts:24,31,33,34,71,83,84,92,101` | "Work order sẵn sàng", "Sale-lock đang hiệu lực", "Đang xử lý disposition", "Disposition", "Đang CAPA", "Chỉ online", "Đã release", "Đã duyệt release" | "Lệnh công việc sẵn sàng", "Đang khoá bán", "Đang xử lý hàng thu hồi", "Xử lý hàng thu hồi", "Đang khắc phục (CAPA)", "Chỉ dùng khi có mạng", "Đã duyệt xuất xưởng" |
| 12★ | `c-pwa-display.ts:137-154` | "Đánh dấu lot sẵn sàng", "Ký QC lot nguyên liệu", "Check-in", "Check-out", "Xác nhận đóng gói L1/L2", "Xác minh QR/barcode", "Ghi nhận quét trace", "Ghi nhận bằng chứng recall", "Xác nhận đã thấy sale-lock" | "Đánh dấu lô sẵn sàng", "Ký KCS lô nguyên liệu", "Vào ca", "Ra ca", "…cấp 1/cấp 2", "Kiểm QR/mã vạch", "Ghi nhận quét truy xuất", "Ghi bằng chứng thu hồi", "Xác nhận đã thấy khoá bán" |
| 13★ | `app/pwa/(app)/workforce-check/page.tsx:5,14`; `sale-lock-ack/page.tsx:5,14`; `packaging/page.tsx:14`; `offline-queue/page.tsx:5` | "Check-in/out nhân sự", "Xác nhận sale-lock", "Đóng gói L1/L2", "Hàng đợi offline" | "Vào/ra ca nhân sự", "Xác nhận khoá bán", "Đóng gói cấp 1/cấp 2", "Hàng đợi chờ gửi" |
| 14 | `app/manifest.ts:7`; `app/layout.tsx:15` | "PWA quét trước cho công việc vận hành tại xưởng." (hộp thoại cài app) | "Ứng dụng quét mã và ghi nhận công việc tại xưởng." |
| 15 | `c-task-inbox.tsx:218,220,221,478,484` | "Đã tải N task…", "N task khớp", "Mở task khớp" | "…công việc…", "Mở công việc khớp" |
| 16 | `c-task-detail-field-quality-fields.tsx:52,135,294,402,326` | "Được capture evidence", "Lock đang hiệu lực", "Lý do HOLD/REJECT", "chưa PASS" | "Được ghi bằng chứng", "Khoá bán đang hiệu lực", "Lý do giữ lại/loại", "chưa Đạt" |
| 17★ | `field-quality-fields.tsx:123,187,304,412`; `packaging-fields.tsx:142,274,331,400`; `production-fields.tsx:211` | "Chặn QC sau sấy: MOBILE_TASK_CONTEXT_INCOMPLETE." (mã thô, 9 chỗ); "Chặn check-in/out", "Chặn xác nhận sale-lock" | dùng `formatTaskBlockingReason()` như `production-fields.tsx:592`; "Chặn vào/ra ca", "Chặn xác nhận khoá bán" |
| 18 | `field-quality-fields.tsx:133,152` | scopeType thô (BATCH, SKU) | "Mẻ", "Sản phẩm" |
| 19★ | `c-task-detail-material-fields.tsx:53,79,83` | "Đủ/Thiếu lot/vị trí", "Đã có lot mặc định", "Thiếu rawMaterialLotId", "Thiếu sourceLocationId" | "Đủ/Thiếu lô/vị trí", "Đã có lô mặc định", "Chưa chọn lô", "Chưa chọn vị trí lấy hàng" |
| 20 | `c-task-detail-production-fields.tsx:121,139-140` | "Lần check gần nhất" + mã CHECK_IN; "…theo work order" | "Lần vào/ra ca gần nhất" + "Vào ca/Ra ca"; "…theo lệnh công việc" |
| 21 | `c-task-detail-packaging-fields.tsx:135,175,199,360` | "Đã có ledger/Chờ ledger", "Mode áp mã", "Artwork đã duyệt" | "Đã ghi sổ kho/Chờ ghi sổ kho", "Cách áp mã", "Mẫu in đã duyệt" |
| 22 | `src/lib/pwa/packaging-defect-policy.ts:25,57,60,87,100`; `c-task-detail-client.tsx:273,410` | "Artwork in sẵn…", "HOLD/RETURN", "báo Print Exception… Retry/Reprint", "Chưa có policy snapshot/profile snapshot" | "Mẫu in sẵn…", "tạm giữ/trả nhà cung cấp", "báo sự cố in tem… in lại", "Chưa có cấu hình áp mã/mẫu tem" |
| 23 | `src/lib/pwa/shopfloor-task-view-model.ts:435,457` | "Target đang có hold/sale-lock/recall/not-sellable blocker. PWA không được queue…"; scanStatus thô | "Đối tượng đang bị tạm giữ, khoá bán, thu hồi hoặc không được bán, không thể đưa vào hàng đợi."; "Đã nhận diện mã" |
| 24 | `c-scan-client.tsx:181`; `c-task-inbox.tsx:471` | objectType thô (RAW_MATERIAL_LOT…) | dùng `formatTaskType()` |
| 25 | `c-task-detail-scan-gate-panel.tsx:18` | "Máy quét HID" | "Máy quét cầm tay" |
| 26★ | `c-raw-lot-qc-reset-client.tsx:109`; `c-raw-intake-capture-supplier-create.tsx:90` | lỗi 422 "quantity: …", "request.displayName: displayName là bắt buộc." | dùng `describeServerField()` như `raw-intake-capture-client.tsx:336` |
| 27 | `src/lib/pwa/shopfloor-command-labels.ts:111` | khoá trường lạ "lines[0].qty" | "một trường dữ liệu" |
| 28 | `public/shopfloor-sw.js:38` | "Shopfloor is offline. Retry this navigation when the network returns." | "Đang mất mạng. Mở lại khi có mạng." |
| 29 | metadata `description` 11 trang; `c-shell.tsx:401` "Điều hướng Shopfloor"; `public/icon.svg:1` | "Workbench Shopfloor PWA cho…" (chỉ thẻ meta/trình đọc màn hình) | "Màn hình tại xưởng: …" — ưu tiên thấp |

## 2. admin-web

### 2.1 Tiếng Anh thuần — sửa ngay
| tệp:dòng | Hiện tại | Đề xuất |
|---|---|---|
| `app/` thiếu `not-found.tsx` | "404 · This page could not be found." (mọi URL sai; `FormInstanceDetailPage.tsx:200,291`, `FormInstancesListPage.tsx:188`) | trang "Không tìm thấy trang" + nút về Tổng quan |
| `ADM features/supplier-portal/screens/supplier-intake-detail/DeclineIntakeDialog.tsx:36` | "Reason is required." | "Vui lòng nhập lý do." |
| `…/supplier-intake-detail/UpdateIntakeDialog.tsx:139` | "Every line must use the current supplier allowlist." | "Mọi dòng phải là nguyên liệu nằm trong danh sách được phép hiện hành của nhà cung cấp." |
| `…/supplier-portal/screens/SupplierIntakesPage.parts.tsx:199` | toast "Receipt submitted." | "Đã gửi phiếu nhập." |
| `…/supplier-portal/screens/SupplierPortalHeader.tsx:63` | "Supplier Portal" | "Cổng nhà cung cấp" |
| `ADM features/suppliers/screens/SupplierIngredientsPage.tsx:65` | "Lab report" | "Phiếu kết quả kiểm nghiệm" |
| `ADM features/production/screens/work-orders/WorkOrdersPage.tsx:270` | nhãn `MATERIAL_RELEASE_APPROVAL` | "Phiếu chấp thuận nguyên liệu đưa vào sản xuất" (`formCatalog.ts:41`) |
| `ADM features/system/screens/ServiceAccountsPage.parts.tsx:67-68,243,251,267,274,281`; `ServiceAccountsPage.tsx:453` | secret_ref, public_key_ref, valid_from, expires_at, rotation_due_at | "Tham chiếu bí mật", "Tham chiếu khoá công khai", "Hiệu lực từ", "Hết hạn lúc", "Hạn xoay khoá" |
| `ADM features/master-data/screens/ReasonConfigRegistryPage.parts.tsx:71-77,409` | BOOLEAN, INTEGER, DECIMAL, STRING, STRING_ARRAY, JSON, SECRET_REF | "Đúng/Sai", "Số nguyên", "Số thập phân", "Chuỗi", "Danh sách chuỗi", "JSON", "Tham chiếu bí mật" |
| `ADM features/misa-integration/MisaIntegrationScreens.constants.ts:9` → `MisaIntegrationResultPanels.tsx:108` | badge "DryRun" | "Chạy nháp" |
| `ADM features/integrations/screens/OutboxEventsPage.tsx:97,209` | "Loại aggregate" | "Loại đối tượng" |

### 2.2 Mã trạng thái/kỹ thuật hiện thô (thiếu bảng nhãn)
| tệp:dòng | Hiện ra | Đề xuất |
|---|---|---|
| `features/account/AccountIdentityHeader.tsx:80` | INTERNAL_USER / SUPPLIER_USER | "Người dùng nội bộ" / "Người dùng nhà cung cấp" |
| `features/recall/screens/RecallContactTasksPanel.tsx:164-168,226` | OPEN, IN_PROGRESS, DONE, CANCELLED, "UNKNOWN", targetType, contactChannel, mã vai trò | "Đang mở / Đang làm / Đã xong / Đã huỷ"; vai trò qua `roleDisplayName` |
| `features/recall/screens/RecoveryCapaPanel.tsx:396,497` | capaStatus / "UNKNOWN" | nhãn trạng thái CAPA, "Không rõ" |
| `features/production/screens/equipment/PrepStepManagementPanel.tsx:140` | ACTIVE/INACTIVE | StateBadge "Đang dùng / Ngừng dùng" |
| `OutboxEventsPage.tsx:205,209` | eventType, aggregateType | bảng nhãn sự kiện |
| `features/operational-forms/packaging-level2-log/PackagingLevel2FormPayloadPanel.tsx:278` | ONLINE/OFFLINE/FAULTED… | "Trực tuyến / Mất kết nối / Lỗi / Bảo trì" |
| `features/production/screens/production-orders/ProductionOrderSnapshotPanel.tsx:123-129` | unitPolicy, roundingPolicy, densityPolicy | bảng nhãn chính sách |
| `features/raw-material/screens/PackagingIntakeDetailPage.tsx:214`; `RawIntakeLineQcPage.tsx:265` | status, lineStatus thô | `statusLabel(...)` |
| `MisaIntegrationResultPanels.tsx:112,133`; `MisaIntegrationPanels.tsx:677`; `MisaMappingTable.tsx:43,53` | MATERIAL_ISSUE_ACCOUNTING, handoffStatus, dryRunBuildStatus, loại đối tượng | "Hạch toán xuất nguyên liệu" + bảng nhãn |
| `features/finished-goods-warehouse/FinishedGoodsWarehouseStockPage.constants.ts:48` | thiếu LOCATION_TRANSFER | "Gán vị trí kho"; gộp 3 bảng nhãn nguồn sổ kho (`raw-warehouse`, `warehouse-inventory/shared.tsx:69`) về `status-maps` |
| `features/dashboard/components/ObservabilityReadinessPanel.tsx:57-107` | "UNKNOWN" + mã hạng mục | "Không rõ" + nhãn hạng mục |
| `features/audit-integrity/AuditIntegrityPage.parts.tsx:135,138` | tên bảng thô (`audit_log`…) | kèm nhãn Việt |
| `features/system/screens/AuditLogPage.tsx:252`; `UsersRolesPage.shared.ts:107` | từ chưa có nhãn in nguyên ("Ghi nhận override request") | bổ sung `EVENT_TOKEN_LABELS` / `ACTION_TOKEN_LABELS` |
| `ApprovalsPage.tsx:148-155`; `OverridesPage.shared.tsx:131`; `OverrideDetailDrawer.tsx:67`; `features/reporting/AlertsPage.parts.tsx:235` | mã module/entity/action/command thô | bảng nhãn |
| ~80 hàm `LABELS[x] ?? x` (vd `src/lib/utils/reference.ts:47`, `select-options.ts:43`) | thiếu nhãn ⇒ mã thô | dự phòng bằng `unknownStatusLabel` như StateBadge ("Không rõ: <mã>") |

### 2.3 Từ tiếng Anh lẫn câu Việt (~320 chuỗi + ~30 dòng JSX) — thay theo bảng thuật ngữ
| Thuật ngữ | Chỗ tiêu biểu | Đề xuất | ~chỗ |
|---|---|---|---|
| owner | `status-maps/system.ts:20` "Cần owner quyết", `demand-mrp.ts:88`, `B3StockPolicyPage.tsx:247,319,325`, `MaterialWarningThresholdPage.tsx:212,265`, `recall/screens/shared.tsx:105`, `MisaHandoffFormBlock.tsx:96`, `harvestRequestForm.config.ts:59,92` | chủ hệ thống / người duyệt cấp chủ | 17 |
| batch | `entity-select/shared.tsx:27`, `warehouse-inventory/shared.tsx:102`, `FinishedGoodsWarehouseStockPage.tsx:546`, `WarehouseReceiptCreateForm.tsx:237,335,340`, `TraceabilityScreens.helpers.tsx:124,136`, `RecipesPage.constants.ts:12` | mẻ (sản xuất) / lô thành phẩm | 18 |
| audit, audit trail, audit log, entry | `AuditIntegrityPage.tsx:104,134,310,312,535,598,605,641,671,692`, `SkuDetailPage.tsx:214`, `AlertsPage.tsx:317`, `ApprovalsPage.tsx:733`, `OverrideDetailDrawer.tsx:139,144` | kiểm toán / nhật ký kiểm toán / bản ghi | 20 |
| override, break-glass, hard-lock, scope, command | `OverridesPage.tsx:103,111,142-220,521-616`, `OverridesPage.shared.tsx:194,201`, `AuditLogPage.tsx:72-78`, `accountPermissions.ts:17,31` | ghi đè / mở khẩn cấp / khoá cứng / phạm vi / lệnh | 25 |
| service account, credential, metadata, principal, work factor | `ServiceAccountsPage.tsx:149-334,524-729`, `.parts.tsx:75-83,186` | tài khoản dịch vụ / thông tin xác thực / thông tin mô tả / chủ thể / hệ số băm | 30 |
| user, admin, role, module/action | `UsersRolesPage.UserDialogs.tsx:93-561`, `UsersTab.tsx:149`, `UsersRolesPage.tsx:82` "Tạo user", `RolesTab.tsx:251,256`, `UserSessionsDialog.tsx:49` | người dùng / quản trị / vai trò / phân hệ–thao tác | 25 |
| supplier portal, portal, account | `SupplierCreatePage.tsx:181-198`, `SupplierDetailPage.tsx:53-69,486`, `SupplierListPage.tsx:257-296,551,563`, `SupplierUsersPage.tsx:81-314` | cổng nhà cung cấp / tài khoản | 22 |
| artwork, checksum, checklist, spec, scan, click-confirm, evidence, upload, file | `PackagingPreprintVerificationWorkbench.tsx:160-363`, `PackagingIntakeBlock.tsx:119-211`, `TradeItemsPage.*:54,69,80,83,453`, `PackagingPacketChecklist.tsx:18,68,84`, `src/lib/utils/api-error.ts:29`, `SourceOriginListPage.tsx:215,256,284`, `SourceOriginDetailPage.tsx:445-535`, `FileUpload.tsx:344` | mẫu thiết kế nhãn / mã kiểm tra / danh mục kiểm / quy cách / quét / bấm xác nhận / bằng chứng / tải lên / tệp | 45 |
| baseline, anchor, pilot, display field, profile, line, master, cockpit, buffer, output, mapping, checkpoint, sale lock, release, recall | `readiness-labels.ts:28-187`, `SkuCatalogPage.tsx:70,474-716`, `ManufacturingProfileForm.tsx:100,134,148,190`, `catalog/components/shared.tsx:86-310,547`, `RecipesPage.helpers.ts:188-275`, `RecipesPage.draft-form.tsx:116,123,344`, `PrepStepManagementPanel.tsx:34,35,131,151`, `status-maps/sku.ts:16`, `production.ts:102`, `FinishedGoodsWarehouseStockPage.tsx:518` | bản gốc đã duyệt / nguyên liệu neo / chạy thử / trường hiển thị / hồ sơ / dây chuyền / danh mục gốc / dự phòng / đầu ra / ánh xạ / điểm kiểm / khoá bán / phát hành / thu hồi | 60 |
| readiness, lot, trace, link, export, genealogy, scan code | `RawLotsPage.dialogs.tsx:207,212`, `RawLotsPage.panels.tsx:296,298`, `TraceabilityScreens.tsx:171,341,589`, `TraceabilityScreens.genealogy.tsx:133,145`, `TraceabilityScreens.components.tsx:570,589,640`, `TraceabilityScreens.constants.ts:4` | mức sẵn sàng / lô / truy xuất / liên kết / xuất tệp / phả hệ / mã quét | 15 |
| outbox, log, registry, menu, seed | `accountPermissions.ts:20`, `AuditLogPage.labels.ts:40-45,150`, `MisaSyncEventDetail.tsx:13,52-56`, `AuditLogPage.tsx:637,730`, `ScreenRegistryPage.tsx:183-665`, `UsersRolesPage.RolesTab.tsx:26,210`, `UsersRolesPage.FormSigningTab.tsx:223` | hàng đợi sự kiện / nhật ký / sổ đăng ký / trình đơn / "sau khi khởi tạo dữ liệu" | 25 |
| khác (dùng chung) | `src/components/ui/specialized/EventTimeline.tsx:96` "Xem/Ẩn metadata" (mọi dòng thời gian); `app/admin/packaging/trade-items/page.tsx:7` "Mã vạch trade item"; `WarehouseReceiptDetailPage.tsx:77`; `InventoryAllocationsPage.tsx:703` "Confirm … allocation … reserved"; `WarehouseReceiptCreateForm.tsx:414,435,459` "Scan … prefill"; `PackagingPurchaseFormPackagingBlock.tsx:403,442` "Lead time"; `MrpRunFormMrpBoardBlock.tsx:82` "Cơ sở output"; `PackagingLevel1FormPackagingLinesEditor.tsx:545` "Log in cấp 1"; `smokeRunForm.config.ts:49` "smoke đạt"; `AuditLogPage.tsx:412-434` "Correlation ID" | "Xem/Ẩn chi tiết kỹ thuật"; "thương phẩm"; "Xác nhận chỉ đổi trạng thái giữ hàng…"; "Quét … điền sẵn"; "thời gian chờ hàng"; "Cơ sở đầu ra"; "Nhật ký in cấp 1"; "kiểm thử nhanh đạt"; "Mã đối soát" | 20 |

### 2.4 Câu lộ chữ kỹ thuật
- **Endpoint/tham số API:** `DashboardPage.tsx:223`, `OverridesPage.tsx:484`, `TraceabilityScreens.genealogy.tsx:128`, `FinishedGoodsWarehouseStockPage.tsx:588` (`includeZeroStock=true`), `RawWarehouseStockPage.tabs.tsx:168,250`, `misaIntegrationText.ts:149,182,236,341`, `AuditIntegrityPage.tsx:764,772`, `HoldSaleLockPanel.tsx:378` ⇒ viết lại theo nghiệp vụ.
- **"Backend…":** `ReceiveIntakeDialog.tsx:161`, `SourceOriginListPage.tsx:553,595`, `SupplierListPage.tsx:294`, `UomListPage.tsx:349`, `B3StockPolicyPage.tsx:273`, `MaterialWarningThresholdPage.tsx:236`, `PackagingPreprintVerificationWorkbench.tsx:172`, `SupplierUsersPage.tsx:216` ⇒ "Hệ thống".
- **Mã enum trong câu (~35):** `RecipesPage.helpers.ts:188-275` (PILOT_PERCENT_BASED…), `RecipesPage.dialogs.tsx:107`, `SourceZoneListPage.tsx:630`, `UsersRolesPage.UserDialogs.tsx:389`, `ScreenRegistryPage.tsx:620`, `IngredientsListPage.tsx:643`, `PackagingIntakeDetailPage.tsx:154` (READY_FOR_PACKAGING), `RawLotsPage.panels.tsx:227`, `RawIntakeLineQcPage.tsx:383`, `MaterialRequestsPage.tsx:473`, `ProductionOrderDetailPage.tsx:273`, `TraceabilityScreens.components.tsx:335,355`, `WarehouseReceiptCreateForm.errors.ts:38`, `misaIntegrationText.ts:292`, `src/lib/api/hooks/printing/index.ts:185`, `AuditIntegrityPage.tsx:513`, `B3StockPolicyPage.tsx:259` ⇒ nhãn Việt, mã trong ngoặc nếu cần.
- **Báo thiếu quyền chỉ ghi mã (~12):** `AuditIntegrityPage.tsx:100,104`, `AuditLogPage.tsx:770,774`, `DashboardPage.tsx:62`, `OutboxEventsPage.tsx:392,396`, `SellablePage.tsx:26,30`, `RecipeDimensionTab.tsx:27`, `qc-release/shared.tsx:386`, `AlertsPage.tsx:88` ⇒ "Bạn chưa có quyền Xem nhật ký kiểm toán (AUDIT_VIEW)."
- **Mã lỗi đầu câu:** `mutationMessage` (94 chỗ gọi, `src/lib/utils/api-error.ts:201-204`) ra "STATE_CONFLICT: …" ⇒ "… (mã: STATE_CONFLICT)".

## 3. Chữ từ backend (sửa ở backend, hoặc FE che)

| Nguồn | Hiện tại | Đề xuất | Người dùng thấy |
|---|---|---|---|
| ★ `APP Commands/Mobile/MobileOperationalHandlers/ResolveMobileOperationalScanHandler.cs:228,239,250,378`; `MobileOperationalTaskMapper.Contexts1.cs:121`; `…TaskScans.RawRecall.cs:176` | "Batch đang có recall hold active.", "Batch đang bị sale lock active.", "Batch đang có recall impact active.", "Batch không đủ điều kiện bán cho field action. Lý do: {mã}", "Đối tượng đang bị sale lock active." | "Mẻ đang bị tạm giữ do thu hồi.", "Mẻ đang bị khoá bán.", "Mẻ nằm trong phạm vi thu hồi.", "Mẻ chưa đủ điều kiện bán. Lý do: {lý do Việt}", "Đối tượng đang bị khoá bán." | PWA Quét mã / truy xuất hiện trường |
| ★ `APIV SupplierCreateRequestValidator.cs:23-93`; `RawIntakeFieldSupplierRequestValidators.cs:23,29,33-34`; `SupplierIngredientCreateRequestValidator.cs:16-23` | ~30 câu "displayName là bắt buộc.", "contactEmail phải là địa chỉ email hợp lệ."… | "Tên nhà cung cấp là bắt buộc.", "Thư điện tử liên hệ không hợp lệ."… | PWA tạo nhà cung cấp tại hiện trường |
| `ADM src/lib/api/hooks/operational-forms/operator-message-prefixes.ts` + `client-errors.ts:154-182` | ~140 câu chặn phiếu có mã đầu: "G04 LINES_COMPLETE: …", "G21-02 RELEASE_REQUIRES_5_OF_5: …", "PACKAGING_LEVEL1_MOISTURE_GATE: …" | cắt mã như đã làm với G23/FRM23, hoặc đuôi "(mã G04)" — sửa ở FE | admin: ký phiếu sơ chế, QC, đóng gói, xuất NL |
| `APP Mappings/ApprovalMappings.cs:149-176` | "Recall case", "Inventory adjustment", "Production order", "Batch release", mã thao tác thô, ngày `yyyy-MM-dd` | nhãn Việt, ngày dd/MM/yyyy | `ApprovalsPage.tsx:162`, `OverridesPage.tsx:268,304`, `OverrideDetailDrawer.tsx:48` |
| `…/Infrastructure/Integrations/Printing/EfDeviceIncidentBridgeWriter.cs:93`; `…/Persistence/Writers/Reporting/EfReportingDashboardProjectionWriter.cs:745` | "Printer device failure: deviceCode=…", "{alertCode} alert for {module}/{objectType}…" | câu cảnh báo Việt | `AlertsPage.tsx:419` |
| Thông điệp máy in | hiện nguyên văn (FE mới dịch 2 câu, `PrintQueuePage.helpers.ts:15-18`) | bảng dịch theo mã | Hàng đợi in |
| "Business reference unavailable" | FE đã lọc ở `warehouse-inventory/item-display.ts:54,87` | kiểm nơi khác | — |
| FluentValidation chưa đặt LanguageManager | quy tắc thiếu `WithMessage` ra câu tiếng Anh mặc định | đặt `vi` toàn cục | — |
| Trang truy xuất công khai: `APP Mappings/Trace/PublicTraceMapper.cs:217,231` | "Public trace QR is invalid." (FE không hiện) | "Mã QR không hợp lệ." | không hiện — thấp |

Đã kiểm: admin-web KHÔNG hiện câu thô của backend (`ApiClientError` cất message, `errorMessageOrFallback` trả câu FE), trừ danh sách tiền tố ở trên.
Câu tiếng Anh có trong backend nhưng không tới người dùng: validator lý do & cấu hình (34), tạo kho (20), `LinkTraceShipmentReferenceHandler.cs:73`, Title việc trong `MobileOperationalTaskMapper*.cs` (~30), Detail dashboard (FE thay bằng "Hạng mục này chưa có mô tả tiếng Việt.").

## 4. Dữ liệu seed hiện trên giao diện (sửa ở seed, rồi chạy trên `.99`)

| tệp:dòng | Hiện tại | Đề xuất | Hiện ở |
|---|---|---|---|
| ★ `SEED 05a_warehouse_minimum.sql:22,31` | "Raw Material Main Warehouse", "Finished Goods Main Warehouse" | "Kho nguyên liệu chính", "Kho thành phẩm chính" | PWA chọn kho khi nhập NL, đưa lô về chờ kiểm, nhập kho TP; admin |
| ★ `05a:55,62,69,76` | "Raw material receiving/staging", "Raw material QC hold", "Released finished goods", "Finished goods hold/recall lock" | "Khu nhận – tập kết nguyên liệu", "Khu giữ chờ KCS nguyên liệu", "Khu thành phẩm đã duyệt xuất", "Khu thành phẩm tạm giữ/khoá thu hồi" | PWA chọn vị trí; admin |
| `05_ui_screen_registry.sql` + seed 14–29, 42, 43 | 90/105 `screen_name` tiếng Anh ("Audit Log", "Users And Roles"…) | "Nhật ký kiểm toán", "Người dùng và vai trò"… | màn Màn hình (chỉ quản trị) |
| `06_ui_action_registry.sql` + seed trên | 287/304 `action_name` tiếng Anh ("View Audit Log", "Retry Outbox Event"…) | "Xem nhật ký kiểm toán", "Gửi lại sự kiện"… | màn Màn hình (chỉ quản trị) |
| `02_roles_permissions.sql:23-41` (description) | ~13/19 mô tả trộn Anh ("Quản trị user/role/screen/config hệ thống."…) | thuần Việt | Người dùng & Vai trò → cột Mô tả |
| `12_public_trace_policy.sql:48-50` | "Ngay san xuat"… không dấu | có dấu | không màn nào hiện — thấp |

05a dùng `ON CONFLICT DO UPDATE` ⇒ chạy lại ghi đè tên trên DB: đọc `.99` trước xem đã có ai đổi tên bằng tay chưa.
Đã là tiếng Việt: lý do điều chỉnh, đơn vị tính, ca, thiết bị, bước chế biến, tên SKU. FE đã che: `role_name`, `auth_permission.description`, nhãn menu "Override Governance", `field_label` phiếu 21, `op_config.description`.

## 5. Bảng thuật ngữ — Toàn chốt 18/11 (D-m12-116)

Toàn trả lời: "1. oke 2. oke 3 offline online giữ 4. chekcin checout giữ 5. Cấp 1 Cấp 2 6 oke 7. oke. 8. oke. rồi kiểm tra thêm trong database nữa."
⇒ (1) KCS · (2) ĐVT · (3) **GIỮ offline/online** · (4) **GIỮ Check-in/Check-out** · (5) Cấp 1/Cấp 2 · (6) mẻ / lô · (7) mã lỗi cuối câu · (8) giữ viết tắt ngành (bỏ "PWA" khỏi câu cho công nhân).

## 5a. Bản đề xuất ban đầu (giữ để đối chiếu)

1. QC hay KCS khi nói kiểm chất lượng: hiện lẫn "Qua KCS" / "QC đạt" ⇒ **KCS** (menu đã dùng "KCS & Phát hành", "Kiểm nghiệm KCS").
2. UOM ⇒ **ĐVT** (6 chỗ nhãn/cột).
3. offline/online/đồng bộ offline (~25 chỗ PWA) ⇒ **"mất mạng / có mạng", "Hàng đợi chờ gửi"** (dễ hiểu cho công nhân hơn "ngoại tuyến").
4. Check-in/check-out ⇒ **"Vào ca / Ra ca"**.
5. L1/L2 ⇒ **"cấp 1 / cấp 2"** (nhãn loại việc đã dùng).
6. batch ⇒ **"mẻ"** cho mẻ sản xuất, **"lô"** cho lô nguyên liệu/thành phẩm.
7. Mã lỗi trong thông báo ⇒ **để cuối câu "(mã: …)"**, không để đầu câu.
8. Menu/tab trong câu cho quản trị ⇒ **giữ "menu", "tab"** (quen dùng) hay đổi "trình đơn", "thẻ".
9. Giữ nguyên các viết tắt ngành: QR, SKU, GTIN/EAN-13, MRP, FEFO, MISA/AMIS, CAPA, COA, NSX/HSD/NCC, JSON, PDF; "PWA" chỉ giữ ở tên app.

## 6. Đề xuất cách sửa (3 đợt, mỗi đợt một gói việc có verifier độc lập)

| Đợt | Phạm vi | Vì sao trước | Ước lượng | Rủi ro |
|---|---|---|---|---|
| **1 — công nhân và luồng hằng ngày** | PWA mục 1–13, 17, 19, 26; tên kho/vị trí seed 05a (đọc `.99` trước); câu chặn "Batch … sale lock" + ~30 câu kiểm tạo NCC ở backend; admin-web 2.1 (11 chỗ) + trang 404 + mã lỗi về cuối câu + cắt mã đầu câu chặn phiếu | người dùng thật gặp mỗi ngày, trước nghiệm thu 27/11 | ~1 ngày-agent | R2 (đổi chữ + test; seed 05a đổi tên trên DB) |
| **2 — bảng thuật ngữ admin-web** | 2.2 nhãn trạng thái + dự phòng "Không rõ: <mã>" cho ~80 hàm tra nhãn; 2.3 thay ~350 chuỗi theo bảng thuật ngữ mục 5; 2.4 câu kỹ thuật; PWA mục còn lại | cần Toàn chốt mục 5 trước | ~1,5 ngày-agent | R1–R2 (nhiều test giao diện so chữ phải sửa theo) |
| **3 — quản trị/backend còn lại** | `ApprovalMappings.cs`, nội dung cảnh báo, thông điệp máy in, FluentValidation `vi`; seed tên màn hình (90), tên thao tác (287), mô tả vai trò (13) | chỉ quản trị thấy | ~1 ngày-agent | R2 (seed registry lớn: chạy lại chuỗi seed tay như lần 4) |

Lưu ý khi làm:
- Test giao diện (vitest) và sổ tay UAT có so đúng chữ hiện tại ⇒ sửa test + báo WP-UAT các ca đổi kỳ vọng.
- 4 màn phiên m12 chính đang sửa (RawLotsPage, InventoryAllocationsPage, ReasonConfigRegistryPage, TradeItemsPage) ⇒ đợt 1–2 chạm các tệp đó sau khi phiên kia commit.
- Lên `.99` theo lượt deploy kế tiếp (gộp với phần Thiết bị xưởng vào Hệ thống), seed 05a/registry chạy theo script seed tay.

## 7. Quét dữ liệu DB `.99` (18/11 ~16:2x, giao dịch READ ONLY, không ghi)

Quét mọi cột chữ (bỏ cột mã/khoá/đường dẫn/bảng nhật ký): **49 cột** có giá trị dạng tiếng Anh/không dấu. Agent chỉ đọc lần từng cột qua entity → mapping/DTO → FE.

### 7.1 Cột DB thật sự hiện lên giao diện — cần sửa
| bảng.cột | số | hiện ở (vai thấy) | nguồn | cách sửa | ưu tiên |
|---|---|---|---|---|---|
| `op_warehouse.warehouse_name`, `op_warehouse_location.location_name` | 2 + 4 | PWA chọn kho/vị trí; admin Danh mục kho (công nhân, kho) | seed 05a — **bị loại khỏi DB sạch** (`deploy/seed/production-seed-exclusions.txt`) | đổi trên `.99` qua giao diện Danh mục kho hoặc UPDATE riêng 6 dòng; KHÔNG chạy lại 05a; DB sạch 30/11 kho thật nhập qua giao diện (D-m12-092) | ★ |
| `ui_screen_registry.screen_name`, `ui_action_registry.action_name` | 82 + 283 | màn Màn hình `ScreenRegistryPage.tsx:369,435` (quản trị) | seed 05/06 + seed module | dịch trong seed + chạy lại chuỗi seed tay (đợt 3) | thường |
| `op_smoke_step_template.step_name` | 14 | phiếu SMOKE_RUN `SmokeRunFormSmokeStepBlock.tsx:389,261` (người chạy kiểm trước phát hành) | seed 21:2679-2706 | dịch seed 21 + chạy lại 21 trên `.99` (đọc trước: 21 `DO UPDATE` nhiều bảng); phiếu đã tạo giữ tên cũ | thường |
| `op_stock_alert_policy.config_source` | ~19 dòng | Nhu cầu/MRP → chính sách, cột "Nguồn" `columns.tsx:496-498`, ngăn kéo `deferred-panels.tsx:236` (kế hoạch) | seed 20:458 (đường dẫn repo không dấu) | FE hiện "Tài liệu mức cảnh báo tồn kho (PACK-03)" hoặc bỏ cột; KHÔNG chạy lại seed 20 (ghi đè ngưỡng) | thường |
| `op_audit_integrity_verification.notes` | mỗi lần xác minh | Toàn vẹn kiểm toán, "Ghi chú" `AuditIntegrityPage.parts.tsx:226` (quản trị, kiểm toán) | backend sinh: `EfAuditIntegrityRepository.cs:231,285,402` + `Domain/AuditIntegrity/AuditIntegrityHashChain.cs:149-429` | sửa mã sinh chuỗi; dòng cũ giữ làm lịch sử | thường |
| `op_config.description` | 6 | hộp "Sửa cấu hình" `ReasonConfigRegistryPage.tsx:641` (quản trị) | seed 05c:92-97 | dịch seed + UPDATE riêng cột trên `.99` (05c ghi đè giá trị) | thấp |
| `auth_role.description` | 1 (+13 lẫn Anh ở mục 4) | Người dùng & Vai trò, cột Mô tả (quản trị) | seed 02:37 (`DO NOTHING`) | sửa seed + UPDATE riêng trên `.99` | thấp |
| `auth_service_principal.display_name` | 2 (M3, M6) | Tài khoản dịch vụ (quản trị) | seed 38/44 (dev); DB sạch dùng `deploy/seed/tao-db-production-sach.sh:282-285` (mô tả lẫn Anh, không dấu) | sửa `tao-db-production-sach.sh` trước 29/11; trên `.99` sửa qua nút "Sửa metadata"; KHÔNG chạy lại 38/44 | thấp |
| `ref_ingredient.notes` | 56 dòng | hộp "Sửa nguyên liệu" (quản trị) | seed 09 | KHÔNG dịch seed (validation 04 đếm tiền tố); nếu cần FE hiện nhãn | bỏ qua |

### 7.2 Dữ liệu thử còn trên DB thật (mất khi đổi DB sạch 29–30/11, D-m12-093)
- ★ **Máy in "DEV TEST ONLY HTTP ZPL Printer"** (seed 23:41): hiện ở Hàng đợi in (bảng máy in, ô chọn máy in, nhật ký in) — thợ in/đóng gói thấy ⇒ tắt hoặc đổi tên qua giao diện trước nghiệm thu 27/11.
- Ghi chú `DEV_TEST_ONLY` ở chi tiết phiếu nhập kho TP (`WarehouseReceiptDetailPage.tsx:320`), phiếu nhận NL (`MaterialReceiptDetailDrawer.tsx:167`), phiếu nhập NL (`IntakeSummary.tsx:77`) — từ fixture p06/p07/p07b.
- 3 tài khoản dịch vụ "N21 temporary acceptance" (tạo tay) + mô tả DEV_TEST_ONLY; vai thử "Temporary pilot UI test…" (tạo tay).
- `op_config misa.client_secret_ref` mô tả "DEV_TEST_ONLY…" — **còn cả sau khi đổi DB sạch** (05c nằm trong bộ seed production) ⇒ dịch ở seed 05c.
- Không hiện: lệnh SX notes, lý do KCS, hồ sơ thu hồi thử, ghi chú duyệt NCC–NL (117), disabled_reason/grant_reason.
- Câu không dấu do công cụ: `tools/ops/cutover-principal-m3.sh:437,448` ("Xoay N21… thay bang phien ban…").

### 7.3 Có tiếng Anh nhưng KHÔNG tới người dùng (bỏ qua)
`auth_permission.description` (290, API không trả), `auth_role.role_name` (FE thay nhãn Việt đủ 19 vai), `event_schema_registry.schema_name`, `op_alert_rule.alert_name`, `op_public_trace_policy.notes`/`display_label_vi`, `op_form_template.owner_module` (API trả, FE không đọc), `op_form_template_field.field_label` (31 nhãn "… Generated source snapshot" bị ẩn; "Cost center" FE đổi "Trung tâm chi phí"), `op_material_planning_policy.suppression_rule`, `ui_menu_item.label` (dòng `/pwa/*` INACTIVE).
Không phải lỗi: `ref_ward.ward_name` (101 tên chính thức, vd "Ba Dinh" là xã Ba Dinh, Quảng Ngãi), "An Giang", "Da heo"; `ref_sku.sku_name_en` (tên tiếng Anh SKU, đúng thiết kế, hiện ở ô "Tên tiếng Anh").

### 7.4 Phân loại sơ bộ lúc quét (giữ để đối chiếu)
- **Tiếng Anh, có thể hiện trên UI:** `ui_action_registry.action_name` (283), `auth_permission.description` (290), `ui_screen_registry.screen_name` (82), `auth_role.role_name` (19; FE đang thay nhãn), `op_alert_rule.alert_name` (12), `op_form_template.owner_module` (23), `op_form_template_field.field_label` (34), `op_smoke_step_template.step_name` (14), `event_schema_registry.schema_name` (20), `op_public_trace_policy.notes` (20), `op_material_planning_policy.suppression_rule` (7), `op_config.description` (6), `auth_service_principal.display_name` (5), ★ `op_warehouse.warehouse_name` (2), ★ `op_warehouse_location.location_name` (4), `ui_menu_item.label` (14, dòng `/pwa/*` đã INACTIVE).
- **Tiếng Việt thiếu dấu:** `ref_ward.ward_name` (101 phường/xã, vd "Ba Dinh"), `op_public_trace_policy.display_label_vi` (19, lẫn cả tiếng Anh "Cost amount"), `ref_province.province_name` (1).
- **Đúng thiết kế:** `ref_sku.sku_name_en` (19 tên tiếng Anh của SKU); "Da heo" (đúng chính tả, không dấu).
- **Dữ liệu thử còn trên DB thật** (`DEV_TEST_ONLY…`, N21, "Ho so THU…"): ~12 dòng ở phiếu nhập/lệnh SX/KCS/thu hồi/máy in/cấu hình — mất khi đổi DB sạch 29–30/11 (D-m12-093).
- **Chuỗi do backend sinh:** `op_audit_integrity_verification.notes` ("Audit chain entries match…").
