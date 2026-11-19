# M12-WP25 — Giao diện admin-web: tên trên mã dưới (StackedCell) + phông mã đồng bộ

Trạng thái: ĐANG LÀM · Rủi ro: R1 (giao diện) / R2 (đợt 2 thêm trường API chỉ đọc) · Chế độ: S · Quyết định: D-m12-117 (m12.140–143 A) · Sheet: M12-113
Nguồn: lệnh Toàn 18/11 + bản rà [ra-soat/2026-11-18-ui-ten-ma-phong.md](../ra-soat/2026-11-18-ui-ten-ma-phong.md) (số # theo bản rà).

## Mục tiêu · tiêu chí đạt
Mọi cột bảng hiển thị thực thể có cả tên và mã dùng `StackedCell` (tên đậm trên, mã nhỏ mờ dưới, KHÔNG còn dấu "- "); mã nghiệp vụ trong ô bảng
cùng phông với chữ còn lại. Đạt khi: vitest màn đổi + test mới (2 dòng tên/mã, không `<code>`/monospace) xanh, typecheck + eslint sạch, verifier đọc nhanh ĐẠT,
bộ đủ admin-web (vitest + static guards) xanh một lần cuối gói.

## Chia việc (tệp tách nhau)
| Phần | Ai | Phạm vi | Ghi chú |
|---|---|---|---|
| A1 | coder A | RawLotsPage (Nguồn gốc, + 3 trường mã API lô), InventoryAllocationsPage (Kho), ReasonConfigRegistryPage.parts (codeCell), TradeItemsPage.components (GTIN + 4 `<code>` còn lại) | vòng 1 xong (Kho, lý do, GTIN), vòng 2 API lô đang làm, vòng 3 `<code>` thương phẩm |
| B | coder B | `StackedCell` bỏ "- " (143 A); CAO không cần API #14–17, #25, #34–37; VỪA không cần API #1–3, #5–10, #19 (phần Kho/vị trí), #20, #21, #26, #27, #38–40; phông bỏ: catalog/components/shared.tsx:378/463/489, packaging-job-columns.tsx:48, QrRegistryPage.tsx:591, QrRegistryPage.dialogs.tsx:185-186, 3 tệp cổng NCC, AlertsPage.parts.tsx:234, OverridesPage.tsx:321, MisaSyncJobsPage.tsx:141/239, MisaIntegrationPanels.tsx:688-702, evidence-gallery.css:374, FormInstancesListPage.tsx:87-90 | KHÔNG chạm tệp của A và C, không chạm tệp sinh |
| C | coder C (sau khi A commit) | 5 trường API chỉ đọc + ô: #18 tên mặt hàng (InventoryAllocations "Mặt hàng/lô" + #19 phần mặt hàng), #28 skuName (BatchReleaseQueueScreen), #29 tên NL dòng phiếu xuất (MaterialIssuesPage), #30 packagingMaterialName (PackagingLotsPage), #31 operatorName (WorkOrder) | chạm `openapi.json` + 2 `types.ts`: chỉ một gói một lúc |

Không làm trong gói: mục THẤP, tiêu đề/ô chi tiết ghép "MÃ - Tên" (mục C bản rà), Việt hoá chữ (fork m12, D-m12-118 — xếp lượt sau gói này).

## Lệnh kiểm nhanh (tầng 1–2)
`vitest run` tệp test của màn đổi + `tests/frontend/admin-web/static-guards/**` liên quan · `pnpm run typecheck` · eslint tệp đổi · (C, A2) build project API + Unit/ApiContract lọc + OpenAPI gate.
## Bộ kiểm đủ — chỉ phiên chính, cuối gói
vitest admin-web đủ + shopfloor-pwa (StackedCell không dùng ở PWA — xác nhận) + typecheck + (vì A2/C đổi API) Unit/ApiContract/Integration lọc vùng đổi + OpenAPI gate.

## Diễn biến
- 18/11 15:4x coder A vòng 1 ĐẠT tự kiểm (Kho, codeCell, GTIN); mục Nguồn gốc dừng vì DTO thiếu mã ⇒ vòng 2.
- 18/11 16:xx Toàn "oke hết" (D-m12-117) ⇒ mở WP25, giao coder B; coder C chờ A commit.

- 18/11 16:20 phần A `a77e0f43e`; verifier R2: tiêu chí 4/4, Governance đỏ (tệp guard 817 dòng) + đột biến mã sống ⇒ sửa `d30fc8337`.
- 18/11 16:51 phần B `dc85cf96f` (53 tệp). 17:13 verifier phần B + A sau sửa ĐẠT (chờ bộ đủ); đột biến phông sống ⇒ thêm guard ở phần C.

## Bước kế tiếp chính xác
Phần C (5 trường API + static guard phông 16 chỗ + test thứ tự các ô VỪA) giao SAU khi WP26 backend xong (một gói sinh openapi một lúc) → verifier → commit. Cuối gói: bộ đủ admin-web + PWA, Sheet M12-113 Đạt, báo fork/WP24 (Việt hoá admin-web chờ gói này).
