# C — Hợp đồng (contracts) và sổ điều phối: nối M12 (ops-core) ↔ M3 (bán hàng)

Mốc đọc: 11/11/2026 ~13:05 (+07). Chỉ đọc; không fetch/pull/ghi repo nào. Contracts `origin/main` = `a7832a49f49c430128f5013a6ddce773b138b7df`
(21/09/2026; FETCH_HEAD cục bộ 10/11 10:19, chưa fetch lại hôm nay).
Quy ước nguồn: `CTR:<path>` = `git -C C:/Projects/ginsengfood-contracts show a7832a49:<path>`; `PC` = `C:/Projects/Project Control`;
`OPS` = `C:/Projects/ginsengfood-ops-core`; `TB-xx`/`§n` = `OPS/docs/integration/module-3/09-09-09-55-chot-ket-noi-module-3.md` (gói chốt M3, số dòng kèm theo).

## 0. Mười phát hiện chính

1. **Hợp đồng ghim `a7832a49` có: token, kiểm bán được, kéo tồn, GIỮ hàng (reserve), hết hạn tự nhả (30 phút mặc định, tối đa 24 giờ). KHÔNG có: lệnh nhả
   `POST /v1/inventory/allocations/release`, mã `ALLOCATION_NOT_HELD`, trạng thái `ISSUED`** (enum phân bổ chỉ `RESERVED|CONFIRMED|RELEASED`).
   Nguồn: `CTR:openapi/ops-core/inventory.v1.yaml:283-` (chỉ GET + POST ở `/allocations`), `CTR:schemas/ops/x03b/external-inventory-allocation.schema.json`, `…-reserve-line.schema.json:34-36`.
2. **ops-core đã có mã cho cả `ISSUED` (migration 152, đã LÊN `.61` 11/11 12:33) và lệnh nhả (cờ `ExternalApi:AllocationSelfRelease:Enabled` TẮT, route không map)** →
   `.61` có thể trả `status=ISSUED` ngoài enum đã ghim. Nguồn: `PC/modules/m12/TRANG_THAI.md:9` (`C37AllocationIssuedSalesIssueLink`, 152), `OPS/docs/runbooks/release/02-11-13-37-wp09-tu-nha-phan-bo-va-tat-khan-runbook.md` §1.
3. **Việc publish contracts chưa có người làm: `LEAD-WP04` chưa được lập** (`PC/modules/lead/wp/` chỉ có LEAD-WP01..03); đề xuất lead.1/lead.45 "A" (worktree mới từ `origin/main`, Phúc review)
   không có dòng duyệt trong `PC/modules/lead/QUYET_DINH.md`. Hạn đã cam kết 08/11 → quá hạn 3 ngày (`PC/modules/m12/SAN_SANG.md:101`).
4. **M3 ghim contracts RẤT CŨ: gitlink `a3b4bbf84` (08/06/2026, "save"), ở cả 5 nhánh BP** (`toandeptrai`, `dev`, `PhucApu`, `dev015`, origin/…); bản đó KHÔNG có `x03b/`, `service-auth`, reserve
   (`git ls-tree -r a3b4bbf84` → x03b=0, service-auth=0) và submodule chưa khởi tạo trong checkout (0 tệp). ops-core ghim đúng `a7832a49`. Thông báo ops-core 06/10 nói M3 đang ghim `a413f1f` — không khớp gitlink.
5. **Local `C:/Projects/ginsengfood-contracts` (`08585c13a` 21/05) đang dở merge với `e5b25069` (20/05)** — bản MAY, không chứa `x03b/`, `service-auth`, reserve, `uom_code` (0 khớp) và không có `ISSUED`/release/tự nhả
   cho phân bổ. 403 đường dẫn dirty = 359 A + 40 AA + 1 UU + 3 D; 40 tệp có dấu xung đột. Không phải nơi sửa tiếp; cần worktree mới từ `origin/main`.
6. **"11 ca M3" = §6 gói chốt (13 dòng: 11 bắt buộc + 2 khuyến nghị) + 4 ca C37 của bộ chạy WP06a.** Bộ WP06a (`OPS/tools/integration/m3-acceptance/`) PASS 17/17 CỤC BỘ; **chưa chạy trên `.61` lần nào sau bản 152**
   (WP06 = CHỜ, hạn dời tới 12/11). Phía M3 hôm nay chỉ có token + `availability/check` → theo sổ chỉ ca 1, 4, 5, 11 (+12, 13) có đối tác phía M3; ca 2, 3, 6, 7, 8, 9 "Bị chặn" vì thiếu client `stock-balances`/`allocations`.
7. **Owner/hạn của adapter M3 lệch nhau giữa các sổ:** m12 sổ vẫn ghi Phúc, 08/11 (quá hạn); m34 D-m34-056/m34.73 A (10/11) giao Toàn làm WMS + M3-111, hạn 24/11; D-lead-026 (07/11) ghi M3 "giữ/nhả hàng 27/11"
   và 15/11 chỉ kiểm tồn; m12 sổ lại có WP07b hạn 30/11. Tin nháp hỏi Phúc (10/11) vẫn "CHƯA GỬI".
8. **Webhook ops-core → M3: ops-core có mã (HMAC, gửi lại), CHƯA bật trên `.61`** (compose WP16 không có `OutboxDispatcher__*`); M3 chưa có bên nhận; production bắt buộc `https://`. Lead nợ câu trả lời "URL https + khoá ký" (cần Phúc) trước 12/11.
9. **Lệch bên trong contracts ghim:** (a) `ExternalAllocationWrite` được `reserveInventoryAllocationV1` tham chiếu nhưng KHÔNG được định nghĩa trong `x-rate-limit-policies` của `inventory.v1.yaml` (chỉ `ExternalWarehouseRead`, `ExternalBulkRead`);
   (b) reserve không có contract-test/fixture (x03b, x04d đều không liệt kê); (c) `availability-consumer.v1.yaml` + ví dụ `availability-check.request.json` dùng shape khác provider (`channel_context_id`, `customer_id`, `requested_quantity{value,unit:"pack"}`) trong khi provider đóng (`additionalProperties:false`, `uom_code` enum `hộp|thùng|lọ|hũ`);
   (d) `X-Idempotency-Key` ≤100 ký tự theo OpenAPI nhưng ≤200 + bộ ký tự theo TB-08.
10. **Hạ tầng liên quan đang mở:** contracts repo đã chuyển CÔNG KHAI 11/11 ~08:xx (runner GitLab không clone được khi riêng tư) — `PC/modules/m12/nhat-ky/2026-11-11.md:5-6`; token M3 cũ sẽ 401 sau mỗi lần API `.61` khởi động
    (đã khởi động 11/11); seed production LOẠI `SVC-M3-SELLABLE` → phải tạo lại principal + secret mới ở cutover 13–14/11; URL cơ sở sẽ đổi từ `http://192.168.1.61:5000` sang tên miền (`api-ops.`), và `client_secret` thử bị huỷ khi lên thật (TB-01 dòng 226).

---

## 1. Hợp đồng (repo `ginsengfood-contracts`)

### 1.1 Ai ghim bản nào

| Bên | Ghim | Nguồn |
|---|---|---|
| ops-core `main` (`87acc810d`, 11/11) | `a7832a49` (= origin/main) | `git -C OPS ls-tree HEAD ginsengfood-contracts` → `160000 commit a7832a49…`; `submodule status` ` a7832a49 (heads/main)` |
| M3 / business-platform (`toandeptrai b15c6b0f1`; cũng origin `dev`, `PhucApu`, `dev015`) | **`a3b4bbf84`** (08/06/2026, "save"), chậm 50 commit so với `a7832a49` | `git -C business-platform ls-tree <nhánh> ginsengfood-contracts`; `submodule status` có dấu `-` (chưa init); thư mục `ginsengfood-contracts/` rỗng |
| BP `master` | `6632c043a…` (không phải nhánh làm việc) | cùng lệnh |
| Local contracts `main` | `08585c13a` (ahead 1 / behind 81 so với `a7832a49`), dở merge `MERGE_HEAD=e5b25069` (20/05, tổ tiên của `a7832a49`, 66 commit trước) | `git rev-list --left-right --count 08585c13a...a7832a49` = `1 81`; `.git/MERGE_HEAD` |

Chuỗi pin ops-core công bố cho M3/M6: `7487846 → 43bd886 (09/09) → a413f1f (10/09) → a7832a49 (06/10)`; từ `a413f1f` đến `a7832a49` chỉ mô tả + CHANGELOG, không đổi shape
(`OPS/docs/integration/06-10-13-12-thong-bao-ghim-hop-dong-a7832a49-module-3-6.md` §2). Không có tag/release nào (`git tag` = 0); mọi `info.version` 1.0.0; "phiên bản" = SHA gitlink.

### 1.2 Tệp liên quan (tại `a7832a49`)

| Nhóm | Tệp |
|---|---|
| OpenAPI ops-core | `openapi/ops-core/service-auth.v1.yaml` · `availability-sellable.v1.yaml` · `inventory.v1.yaml` · `warehouse.v1.yaml` · `sku.v1.yaml` · `recall-sale-lock.v1.yaml` · `product-master.v1.yaml` · `traceability.v1.yaml` · `batch-qc-release.v1.yaml` |
| OpenAPI consumer (BP) | `openapi/business-platform/availability-consumer.v1.yaml` · `catalog-consumer.v1.yaml` · `order.v1.yaml` |
| Schema (phân bổ/tồn/bán được) | `schemas/ops/x03b/` 18 tệp: `external-allocation-reserve-{request,result,line,error}`, `external-inventory-allocation`, `external-stock-balance`, `external-snapshot-meta`, `external-quantity`, `external-warehouse*`, `external-bulk-read-error*`…; `schemas/ops/sellable-status.schema.json` (14 trường + khối số lượng 8 trường); `schemas/ops/stock-balance|inventory-ledger|stock-alert.schema.json`; `schemas/commerce/availability-check.schema.json` |
| Enum | `enums/ops/sellable-status.yaml`, `sale-lock-status.yaml`, `recall-status.yaml`, `inventory-movement-type.yaml`, `enums/commerce/availability-status.yaml`. **Không có enum trạng thái phân bổ** (RESERVED/CONFIRMED/RELEASED chỉ nằm trong schema); `ISSUED` ở `enums/ops/material-issue-status.yaml` và `ORDER_CODE_ISSUED` là việc khác |
| Event (ops-core) | `events/ops-core/{inventory,sellable,recall,product,evidence,misa}/*.v1.json` (19 sự kiện); `asyncapi/ops-core-events.v1.yaml` (17 kênh, broker placeholder) |
| Event (BP) | `events/business-platform/order/*` (6), `demand/*` (3), `payment/*`, `shipping/*`; `asyncapi/business-platform-events.v1.yaml`, `integration-events.v1.yaml` |
| State machine | `state-machines/ops/sale-lock-state.md`, `recall-state.md`, `warehouse-receipt-state.md`, `batch-state.md`, `qc-state.md`; `state-machines/commerce/order-state.md`. **Không có state machine phân bổ** |
| Mã lỗi | `error-codes/{common,idempotency,integration,permission,validation}-errors.yaml` — không có `INSUFFICIENT_STOCK`, `ALLOCATION_CONFLICT` (nằm trong `schemas/ops/x03b/external-allocation-reserve-error.schema.json`) và không có `ALLOCATION_NOT_HELD` |
| Ví dụ | `examples/api/availability-check.{request,response}.json`; `examples/api/x03b/allocation-reserve.{request,response}.json`, `inventory-allocations|stock-balances|…response.json`; `examples/errors/sale-lock-blocked.example.json`; `examples/events/{sku-became-sellable,sale-lock-activated,recall-case-opened,order-confirmed}.v1.example.json` |
| Contract test | `contract-tests/x03b/external-bulk-read-v1.contract.test.mjs` (GET kho/tồn/phân bổ; **không có reserve**), `x03b/public-product-v1…`, `x04d/external-runtime-v1-security.contract.test.mjs` (liệt kê `checkAvailabilityV1`, `getSellableStatusV1`, `issueServiceTokenV1`, `getRecallCaseV1`, `getSaleLockV1`, `getSkuV1`…; **không có `reserveInventoryAllocationV1`**), `c6/recall-sale-lock-events-v1.contract.test.mjs`; fixture `availability-check.v1`, `sale-lock-activated.v1`; Pact/Postman chỉ là kế hoạch (`pact-readiness-notes.v1.md`: "not ready") |
| Quy tắc | `VERSIONING.md` (25 dòng), `GOVERNANCE.md`, `CHANGELOG.md` (mục `Unreleased`), `compatibility/*.md`, `.github/workflows/contract-validation.yml`, `scripts/validate-contracts.mjs` |

### 1.3 Bảng endpoint theo hợp đồng ghim

| operationId · route | Quyền · audience (`ginsengfood-ops-core-external-…`) | Nhịp | Schema/ví dụ/test | Ghi chú quan trọng |
|---|---|---|---|---|
| `issueServiceTokenV1` `POST /v1/service-tokens` (`service-auth.v1.yaml`) | không · `NONE` (ANONYMOUS_BOOTSTRAP) | 10 / 60 giây theo IP | schema inline (request `client_id`,`client_secret`; response `access_token`,`token_type=Bearer`,`expires_in`,`expires_at`); không ví dụ; x04d có | 401 chung `INVALID_CLIENT`; không refresh token; không cache; 415 nếu không JSON |
| `checkAvailabilityV1` `POST /v1/availability/check` (`availability-sellable.v1.yaml`) | `SELLABLE_CHECK` · `availability-v1` | 10 rps/principal, burst 20, fleet 50 | request inline (`sku_id` bắt buộc, `warehouse_id`, `batch_id`, `requested_quantity`, `uom_code`∈{hộp,thùng,lọ,hũ}, `channel_context`, `correlation`); response `sellable-status.schema.json` (+ ví dụ; fixture cũ chưa có khối số lượng) | Không ghi; `sellable_status_id` tạm thời (GET trả 404); 11 mã `block_reasons`; `recall_case_open` ngoài `decision` |
| `getSellableStatusV1` `GET /v1/sellable-statuses/{id}` | `SELLABLE_STATUS_VIEW` (token M3 có "quyền di sản" này) · `availability-v1` | bulk 2 rps | `sellable-status.schema.json` | Chỉ id lấy từ event `ops-core.sellable.*` |
| `listStockBalancesV1` `GET /v1/inventory/stock-balances` | `INVENTORY_BALANCE_VIEW` · `bulk-read-v1` | `ExternalWarehouseRead` 5 rps, burst 10 | `external-stock-balance`, `external-snapshot-meta`; ví dụ + fixture + contract test | phân trang con trỏ 30 phút; 6 ô: `on_hand = available + reserved + quality + recall + sale_lock` |
| `listWarehousesV1`, `listWarehouseLocationsV1`, `listWarehouseReceiptsV1` `GET /v1/warehouses`, `/warehouse-locations`, `/warehouse-receipts` (`warehouse.v1.yaml`) | `WAREHOUSE_VIEW` / `WAREHOUSE_RECEIPT_VIEW` · `bulk-read-v1` | như trên (`/warehouses` dùng `ExternalBulkRead` 2 rps) | schema x03b + fixture + test | status phiếu nhập: DRAFT\|PENDING_CONFIRMATION\|CONFIRMED\|CANCELLED\|CORRECTED |
| `listInventoryLedgerV1`, `listStockAlertsV1` `GET /v1/inventory/ledger`, `/stock-alerts` | `INVENTORY_LEDGER_VIEW`, `STOCK_ALERT_VIEW` | như trên | x03b | không nằm trong 7 lệnh cam kết cho M3 (TB-03) |
| `listInventoryAllocationsV1` `GET /v1/inventory/allocations?sourceObjectId=` | `INVENTORY_ALLOCATION_VIEW` · `bulk-read-v1` | như trên | `external-inventory-allocation.schema.json` (status `RESERVED\|CONFIRMED\|RELEASED`); fixture + test | filter `sourceObjectId` (QĐ-6 C, 07/09); không có header Location |
| **`reserveInventoryAllocationV1` `POST /v1/inventory/allocations`** | `INVENTORY_ALLOCATION_CREATE` · `allocation-v1` | `ExternalAllocationWrite` (5 rps/burst 10/fleet 25 theo CHANGELOG; **không định nghĩa trong OpenAPI**) | request/result/line/error (x03b) + ví dụ; **không fixture, không contract test** | `X-Idempotency-Key` bắt buộc (1–100); full-fill; 201 `RESERVED`, 200 `ALREADY_RESERVED`, 409 `INSUFFICIENT_STOCK`/`ALLOCATION_CONFLICT`, 422; `expires_at` ≤ 24 giờ, mặc định 30 phút, **hết hạn tự `RELEASED`** (OD-ALLOC-LIFECYCLE-01) |
| **`releaseInventoryAllocationV1` `POST /v1/inventory/allocations/release`** | (ops-core dùng `INVENTORY_ALLOCATION_CREATE`, `allocation-v1`) | `ExternalAllocationWrite` chung | **KHÔNG CÓ trong hợp đồng ghim** | cần thêm 9 hạng mục: `C:/Projects/_wt/m12/WP07-bao-cao.md` §4 |
| `getSkuV1` `GET /v1/skus/{skuId}`; `getPublicSkuV1` `…/public`; `getSkuOperationalStatusV1` `…/operational-status` (`sku.v1.yaml`) | `SKU_CATALOG_VIEW`; `PRODUCT_PUBLIC_VIEW`; `SELLABLE_STATUS_VIEW` · `bulk-read-v1` | bulk 2 rps | `sku.schema.json`, public-sku fixture + test | `getSkuV1` là "lệnh chính thức thứ 7" (OD-M3-REPLY-01 1A); chỉ phát 3/8 `lifecycle_status` |
| `getRecallCaseV1` `GET /v1/recall-cases/{id}`; `getSaleLockV1` `GET /v1/sale-locks/{id}` | `RECALL_CASE_VIEW`; `RECALL_HOLD_VIEW` · `bulk-read-v1` | bulk | schema recall/sale-lock; test C6 (event) | token M3 mang 2 quyền này nhưng TB-03 gọi là "di sản, thu hồi lúc nào cũng được" — không xây tính năng dựa vào chúng |
| `createRecallCaseV1`, `createSaleLockV1` `POST /v1/recall-cases`, `/sale-locks` | `RECALL_CASE_CREATE`, `RECALL_SALE_LOCK_APPLY` · `operator-v1` | — | — | **Chỉ vận hành viên; M3 KHÔNG được gọi** |

### 1.4 Bảng sự kiện ops-core → (M3) theo hợp đồng ghim

| Nhóm | Event (`ops-core.<nhóm>.<tên>.v1`) | Schema | Trong 13 loại webhook TB-14? | Ghi chú |
|---|---|---|---|---|
| inventory | `inventory-available-changed`, `stock-below-threshold`, `stockout-risk-detected`, `warehouse-receipt-confirmed` | `events/ops-core/inventory/*.v1.json` | có (4) | tín hiệu "kéo lại", không phải nguồn sự thật (OD-C18) |
| sellable | `sku-became-sellable`, `sku-became-not-sellable`, `sellable-status-changed` | `events/ops-core/sellable/*` | có (3) | + ví dụ `sku-became-sellable` |
| recall/khoá bán | `recall-case-opened`, `sale-lock-activated`, `sale-lock-released`, `stop-sale-required` | `events/ops-core/recall/*` + test C6 | có (4) | `TRACE_CHAIN.scope_id = recall_case_id` (đổi nghĩa, CHANGELOG mục Changed); nhả khoá ≠ "bán lại được" (OD-C20) |
| product | `product-activated`, `formula-version-approved` (có); `product-suspended` (có trong asyncapi, KHÔNG nằm trong danh sách 13) | `events/ops-core/product/*` | 2/3 | — |
| misa/evidence | 3 misa + 2 evidence | có schema | không | ngoài phạm vi M3 |
| **allocation** | **`INVENTORY_ALLOCATION_RELEASED` (outbox nội bộ) — KHÔNG có event/schema ngoài nào cho phân bổ** | — | không | WP07-bao-cao §4 mục 7 ghi "asyncapi không đổi, dùng lại" nhưng contract hiện không có kênh cho nó; M3 phải **kéo** `GET allocations` để biết `RELEASED` |
| Transport | asyncapi chỉ là **placeholder** (broker/retry/outbox "không định"; `asyncapi/README.md`); chữ ký HMAC, header, retry của webhook chỉ có trong TB-14 (`OPS/docs/integration/module-3/09-09-09-55-chot-ket-noi-module-3.md:605-686`), KHÔNG có trong contracts | | | cần quyết có đưa đặc tả webhook vào contracts không |

Sự kiện M3 → ops-core (`order-created|confirmed|cancelled|ready-for-fulfillment|delivered`, `sales-demand-created`…) có schema (`events/business-platform/…`, README bảng "Ops-core consume") nhưng **không có đường truyền nào**:
TB-01 "Chiều gọi: M3 → ops-core" (dòng 220); OD-ALLOC-CONSUME-01 chọn B + 2B (không inbox `order-cancelled`; M3 huỷ đơn thì gọi lệnh nhả) — `OPS/docs/decisions/hop-dong-module-ngoai.md` (OD-M3-REPLY-01 §2, dòng ~1886-2000).

### 1.5 Phần dirty/merge dở ở local (`C:/Projects/ginsengfood-contracts`)

- `git status --short`: 403 mục = **359 `A`** (đã stage, từ `e5b25069`), **40 `AA`** + **1 `UU`** (`README.md`), **3 `D`** (`openapi/cc.md`, `schemas/business-platform/cc.md`, `schemas/ops-core/cc.md`). `git diff --stat | tail` = 40 tệp, +766.
- 40 tệp chứa dấu xung đột (`<<<<<<<`): toàn bộ README.md theo thư mục + `docs/api-design-standard.md`. `MERGE_MSG` đầu "Merge branch 'main' of …sasamviet-ai/ginsengfood-contracts"; `MERGE_HEAD` mtime 21/05, index 17/07.
- Nội dung: bản **tháng 5/2026** — có `asyncapi/*`, `compatibility/*` (5 tệp), `contract-tests` (fixture + pact + postman), `openapi/ops-core` (16 tệp, **không có `service-auth.v1.yaml`**), `docs/documents` (133 tệp). **Không có `schemas/ops/x03b/`**; `inventory.v1.yaml` local không có `reserveInventoryAllocationV1`/`listInventoryAllocationsV1`; `availability-sellable.v1.yaml` local không có `uom_code`; CHANGELOG 29 dòng.
- Có `ISSUED`/release/tự nhả chưa? **Không** với phân bổ. `ISSUED` chỉ xuất hiện ở `enums/ops/material-issue-status.yaml`, `order-status.yaml` (`ORDER_CODE_ISSUED`) và schema order/material-issue (nghĩa khác). Grep `allocation` ngoài `docs/documents` chỉ còn README/boundary.
- Quan hệ: `a3b4bbf84` (pin của M3) KHÔNG phải tổ tiên của local `main`; `MERGE_HEAD e5b25069` là tổ tiên của cả `a3b4bbf84` và `a7832a49`. Local này không dùng được làm nền để thêm `ISSUED`/release; hộp thư `PC/hop-thu/lead-2026-10-31-m12-c37-issued-schema.md` cũng ghi như vậy.

### 1.6 Quy tắc phiên bản / pin / tương thích

- `VERSIONING.md`: REST `v1`/`v2` trong đường dẫn/tên tệp; event có `eventVersion`; breaking = xoá field, đổi type, **đổi enum value đã publish**, đổi semantic status, đổi required, đổi tên event, đổi error contract → tăng major; **"review bởi provider và consumer owner trước khi merge"** (dòng 25 — ops-core dẫn đúng dòng này làm cơ sở để Phúc review `ISSUED`).
- `GOVERNANCE.md`: thay đổi contract phải qua PR; tối thiểu owner provider + consumer duyệt; breaking cần migration note; contract cần example trước production.
- `compatibility/breaking-change-policy.md`: thêm required request field = breaking; **thêm enum value = KHÔNG breaking nếu consumer đã bắt buộc chịu giá trị lạ**. Mâu thuẫn mềm: ops-core §14.3 + lead SAN_SANG gọi `ISSUED` là "phá vỡ phía M3" (cần Phúc review + parser chịu `ISSUED`); chính sách cho phép nếu M3 chịu được giá trị lạ. Đề xuất: ghi `ISSUED` + release thành một mục CHANGELOG "additive, coordinated", Phúc xác nhận parser.
- `compatibility/consumer-compatibility-matrix.md`: consumer **fail-closed** với sale lock, recall, stock unavailable, quality hold, trace-not-ready; M3 "must not mutate product, batch, inventory ledger, recall, or sale lock truth" — mâu thuẫn mềm với reserve (một "ghi" ra ngoài); lý do: OWNER-DIRECTIVE-2026-09-05-EXT-ALLOC-RESERVE là "bề mặt ghi ngoài duy nhất" (`CTR:schemas/ops/x03b/external-allocation-reserve-request.schema.json` `$comment`); ma trận chưa cập nhật. `api-version-matrix.md` dòng Inventory cũng còn "consumers read stock balance; must not mutate ledger".
- Quy tắc ghim phía ops-core: "từ nay ops-core chỉ dời ghim sau khi commit hợp đồng đã có trên remote" (`OPS/docs/integration/06-10-13-12-thong-bao-ghim-hop-dong-a7832a49-module-3-6.md` §3.3). Khi publish `ISSUED` + release ops-core còn phải: sửa `OPS_CORE_EXTERNAL_CONTRACT_TRUTH_MATRIX.json` (32→33 operation), thêm `ExternalAllocationReleaseV1*` vào guard parity, bật cờ — cùng commit dời pin (`WP07-bao-cao.md` §4 mục 9). Cổng parity TC-X04-RUNTIME-PARITY-02 chặn route ngoài ma trận → **không bật cờ trước khi pin dời**.
- Không có Pact/broker; không có "consumer ownership registry/SLA báo thay đổi" (`consumer-compatibility-matrix.md` TODO).
- CI: `.github/workflows/contract-validation.yml` chạy `scripts/validate-contracts.mjs` (scope x03b, sku-lifecycle, operational-form-v2, recipe-formula-v2…); CHƯA CHẠY hôm nay.

### 1.7 Lệch/khoảng trống BÊN TRONG hợp đồng ghim (Lead quyết có sửa trong vòng publish không)

| # | Lệch | Nguồn |
|---|---|---|
| a | `ExternalAllocationWrite` dùng ở `inventory.v1.yaml:373` nhưng không có trong `x-rate-limit-policies` (dòng 13-45 chỉ hai policy); chú thích dòng 370-372 còn nói "tạm dùng bucket hot" (cũ, trái CHANGELOG C25 08/09) | `CTR:openapi/ops-core/inventory.v1.yaml`, `CTR:CHANGELOG.md:30` |
| b | Reserve: không fixture, không contract test, không trong x04d | `CTR:contract-tests/**` (grep 0) |
| c | `availability-consumer.v1.yaml` (BP) mô tả request khác provider; CHANGELOG nói phần ánh xạ block_reason "đã chuyển vào availability-consumer.v1.yaml" nhưng tệp đó không có; fixture `availability-check.v1` chưa có `recall_case_open`/khối số lượng | `CTR:openapi/business-platform/availability-consumer.v1.yaml`, `CTR:compatibility/README.md`, `CTR:contract-tests/fixtures/availability-check.v1.fixture.json` |
| d | `X-Idempotency-Key` ≤100 (OpenAPI) vs ≤200 + `[A-Za-z0-9:_.-]` (TB-08 dòng 448) | `CTR:openapi/ops-core/inventory.v1.yaml:384`; TB-08 |
| e | Không có enum/state machine phân bổ; `ISSUED` sẽ chỉ nằm ở 2 schema (`external-inventory-allocation`, `external-allocation-reserve-line`) | `CTR:schemas/ops/x03b/…` |
| f | Webhook (HMAC/header/retry) không có trong contracts; asyncapi là placeholder | `CTR:asyncapi/README.md` |
| g | `getSellableStatusV1`, `getRecallCaseV1`, `getSaleLockV1` dùng quyền mà TB-03 gọi "di sản" | TB-03 dòng 285-287 |

---

## 2. Bảng ĐIỂM NỐI M12 ↔ M3

Mã `N8.x` thuộc điểm nối N8 "Giữ/trừ hàng kho, nhà máy" của `PC/modules/lead/SAN_SANG.md:18` (N12 = ảnh WMS, hộp thư lead.53). Lead SAN_SANG vẫn là BẢN NHÁP 31/10, cập nhật 02/11, chỉ có N1–N11 (chưa có N12), ghi "0/11 điểm có bằng chứng đầu-cuối" (dòng 5). Mọi cột "theo sổ" = chưa tự kiểm bằng mã. Viết tắt sổ: `m12/` = `PC/modules/m12/`, `m34/` = `PC/modules/m34/`, `lead/` = `PC/modules/lead/`.

**N8.1 Token dịch vụ** — M3→M12, REST `POST /v1/service-tokens`, client `SVC-M3-SELLABLE`, token 15 phút.
- Hợp đồng ghim: CÓ (`service-auth.v1.yaml`).
- ops-core: CÓ, chạy `.61` (TB-02). 11/11 12:33 API khởi động lại → token cũ 401 (`m12/TRANG_THAI.md:9`). Seed production loại `SVC-M3-SELLABLE`; tạo lại ở WP17b (phần a coder xong `9716c515d`, chưa chạy trên `.61`) (`m12/SAN_SANG.md:66`).
- M3: CÓ (token + cache) — `m12/SAN_SANG.md:24` H8 (@`67f358ed9`, nay `b15c6b0f1`: CHƯA XÁC MINH có đổi).
- Phụ trách/hạn: Toàn (cấp) + Phúc (dùng) + Tài (M6) — principal máy trên DB sạch + token mới **14/11** (`m12/SAN_SANG.md:112`); Phúc lấy token mới sau CD 11/11 (`m12/TRANG_THAI.md:9`).
- Trạng thái: chạy trên `.61` dev; production CHƯA (cutover 13–14/11).

**N8.2 Kiểm bán được** — M3→M12, REST `POST /v1/availability/check` (cổng bán tại điểm chốt đơn; `valid_until` = +5 giây).
- Hợp đồng ghim: CÓ (`availability-sellable.v1.yaml`; mirror BP lệch, §1.7c).
- ops-core: CÓ, `.61` (TB §1; bản 152 lên 11/11).
- M3: CÓ adapter `OpsCoreAvailabilityHttpAdapter`, nhưng cờ `OPS_CORE_GATE_ENFORCE:false` (`m34/SAN_SANG.md:25`); `.60` KHÔNG gọi `.61`: SKU demo dùng cron `lam-moi-ton-thu.sh`/`ORDER_MOVEMENT`, "không có nguồn WMS M2" (D-m34-047/048, `m34/QUYET_DINH.md:57,59`); 19 SKU thật `WMS_UNCONFIRMED` (`m34/SAN_SANG.md:37`).
- Phụ trách/hạn: Phúc (adapter)/Toàn; **15/11: "M3 chỉ kiểm tồn"** (D-lead-026, `lead/QUYET_DINH.md:31`; `m12/SAN_SANG.md:119`).
- Trạng thái: hai bên có mã; chưa nối đầu-cuối `.60`→`.61`.

**N8.3 Kéo tồn / ảnh WMS (= N12)** — M3→M12, REST `GET /v1/inventory/stock-balances` (+ `/warehouses`, `/warehouse-locations`, `/warehouse-receipts`) → nạp bảng M3 `inventory_wms_stock_snapshots`.
- Hợp đồng ghim: CÓ (`inventory.v1.yaml`, `warehouse.v1.yaml`, schema x03b + fixture + test).
- ops-core: CÓ, `.61`; nhịp 5 rps (TB-01, TB-03).
- M3: **CHƯA** — không có đường production nạp bảng; chỉ seeder gọi `WmsInventoryIngestionService.ingest` (`PC/hop-thu/lead-2026-11-04-m34-anh-ton-kho-wms.md`; D-m34-023 `m34/QUYET_DINH.md:33`).
- Phụ trách/hạn: cũ Phúc 08/11 (quá hạn). **Hiện Toàn/m34 — M3M8-WMS hạn 24/11** (D-m34-056 m34.73 A, `m34/QUYET_DINH.md:75`; `m34/SAN_SANG.md:64`); là điều kiện bật cờ IVR production.
- Trạng thái: M3 chưa có; sổ m12 vẫn ghi "N12 chưa owner, hạn 12/11" (`m12/SAN_SANG.md:102`).

**N8.4 Giữ hàng + tra phân bổ** — M3→M12, REST `POST /v1/inventory/allocations` (full-fill, 30 phút), `GET …?sourceObjectId=`.
- Hợp đồng ghim: CÓ nhưng thiếu test/fixture/policy rate (§1.7a-b).
- ops-core: CÓ, `.61` (đo 09/09 → 201; TB §1).
- M3: CHƯA — "giữ hàng theo kho 0 mã (M3-111, 27/11, Chưa bắt đầu)" (`m34/SAN_SANG.md:25`); `m12/SAN_SANG.md:24` thiếu phân bổ.
- Phụ trách/hạn: Phúc 08/11 (quá hạn, `m12/SAN_SANG.md:100`) → Toàn (m34.73, M3M8-WMS gộp M3-111); **D-lead-026: giữ/nhả 27/11**; m34 mốc 24/11 chạy toàn luồng, 27/11 nghiệm thu (`m34/SAN_SANG.md:99-102`).
- Trạng thái: M12 xong; M3 CHƯA.

**N8.5 Nhả hàng khi huỷ đơn (QĐ 2B)** — M3→M12, REST `POST /v1/inventory/allocations/release` (`releaseInventoryAllocationV1`), chỉ nhả RESERVED của chính principal; 409 `ALLOCATION_CONFLICT`/`ALLOCATION_NOT_HELD`, 404, 422.
- Hợp đồng ghim: **CHƯA** (cần 9 hạng mục, `WP07-bao-cao.md` §4).
- ops-core: mã + test xong (WP07 ĐẠT R3, `d370852e7`, đã push); cờ TẮT, route không map; WP06a C37 PASS cục bộ; **không có trên `.61`**.
- M3: CHƯA (luồng huỷ đơn chưa gọi; P-HUY-DON M3-110).
- Phụ trách/hạn: hợp đồng — phiên `lead` + Phúc review, **08/11 (quá hạn)**; ops-core WP07b **30/11 nếu contracts chưa có trước 12/11** (`m12/SAN_SANG.md:61`).
- Trạng thái: CHẶN bởi contracts.

**N8.6 `ISSUED` (C37)** — M12 nội bộ, thấy qua `GET allocations`; `POST` cho nguồn đã xuất → 409 `ALLOCATION_CONFLICT` "đã xuất".
- Hợp đồng ghim: **CHƯA** (enum 3 giá trị).
- ops-core: mã xong (WP04c ĐẠT `b164260cb`), **migration 152 đã lên `.61` 11/11**.
- M3: CHƯA (parser `status` phải chịu `ISSUED`; không sinh khoá mới cho ca "đã xuất": §14.3 dòng 1141-1146).
- Phụ trách/hạn: phiên `lead` publish; Phúc review; hạn **08/11 quá hạn**.
- Trạng thái: CHẶN bởi contracts.

**N8.7 Webhook** — M12→M3, HTTP `POST` ký HMAC-SHA256 (`X-Webhook-Signature`, `X-Webhook-Timestamp`, `X-Outbox-Event-Id`), 13 loại, ≥1 lần, retry 5 lượt ~5 phút.
- Hợp đồng ghim: event CÓ; transport KHÔNG (§1.4).
- ops-core: mã CÓ; **CHƯA bật** trên `.61` (compose WP16 không có `OutboxDispatcher__*`, E10 `C:/Projects/_wt/m12/WP02c-checklist.md:79`; D-m12-051). Production bắt buộc `https://` (TB-14 dòng 682). Khi bật, outbox <24 giờ gửi cả loạt sang M3 (`m12/SAN_SANG.md:66`).
- M3: CHƯA có bên nhận ("bên nhận webhook" — `m12/SAN_SANG.md:24,100`; `lead/VIEC_NGOAI.md:31` #23).
- Phụ trách/hạn: Phúc (URL https + bên nhận + khoá ký) **trước 12/11** (D-m12-051; hạn gốc 08/11); Toàn bật ở WP17b cutover 13–14/11.
- Trạng thái: CHẶN bởi M3 (cờ tắt, M3 kéo).

**N8.8 Thu hồi / khoá bán** — M3→M12, pull `availability/check` (`recall_case_open`, `SALE_LOCK`) là gate; webhook chỉ tín hiệu (OD-C20); đọc `GET /v1/recall-cases/{id}`, `/sale-locks/{id}` tuỳ chọn.
- Hợp đồng ghim: CÓ. ops-core: CÓ (`recall_case_open` luôn có, TB-06/07; 4 sự kiện).
- M3: CHƯA XÁC MINH có dùng `recall_case_open`/`scope_id`; CHANGELOG yêu cầu M3, M6, M8 soát `scope_id` không dereference như QR.
- Phụ trách/hạn: Phúc (soát); không có hạn ghi. Trạng thái: KHÔNG CÓ BẰNG CHỨNG.

**N8.9 SKU / danh mục** — M3→M12, `GET /v1/skus/{id}` (+ `/public`) (lệnh 7). Hợp đồng CÓ; ops-core CÓ (`.61` từ trước); M3 CHƯA XÁC MINH (BP có snapshot `catalog-sku-phase-02` riêng, không kiểm). Ngoài đường găng.

**N8.10 Sự kiện M3→M12 (order/demand)** — **KHÔNG có đường truyền**: schema CÓ, transport KHÔNG; ops-core không có inbox (OD-M3-REPLY-01: M3 gọi `release`, không phát `order-cancelled` cho ops-core). Không thuộc kế hoạch; ghi rõ để khỏi lập task.

**N8.11 Mạng / URL / IP / secret production** — `http://192.168.1.61:5000` → tên miền `api-ops.` (D-lead-028/029, `lead/QUYET_DINH.md:33-34`); `/v1/*` chỉ nhận từ `192.168.1.60` (TB-01 dòng 222).
- ops-core: m12.78 **A** (D-m12-050): giữ cổng LAN 5000 tới 11/11; thu 3 cổng web về loopback (B1) cùng WP17b; **thu cổng 5000 (B2) chỉ khi M3 chuyển sang tên miền**; IP nginx /32 chưa có (`m12/SAN_SANG.md:97`).
- M3: gọi `.61:5000` theo TB-01; chuyển tên miền: CHƯA.
- Phụ trách/hạn: Toàn; Anh Tuấn (nginx + DNS + https 4 tên, hạn 12/11, "quá hạn từ 07/11", `m12/SAN_SANG.md:109`). Trạng thái: mở.

---

## 3. "11 ca M3" của WP06

Định nghĩa: `m12/SAN_SANG.md:60` — "WP06 — 11 ca M3 + webhook trên `.61`: ca M3 có thì chạy thật, thiếu phía M3 ghi Bị chặn kèm tên chỗ nối"; R3; chờ WP02c + Phúc; hạn B (trễ) → **12/11**; trạng thái **CHỜ**.
Nguồn ca: TB §6 (`OPS/docs/integration/module-3/09-09-09-55-chot-ket-noi-module-3.md:817-848`), chạy "từ `.60`", giãn ≥1 giây, token ≤10 lần/60 giây theo IP.

| # | Ca | Kỳ vọng | Cần gì ở M3 | WP06a cục bộ |
|---:|---|---|---|---|
| 1 | Lấy token + giải mã | 200; 3 audience (không `availability-v2`); 7 quyền; không `iat` | token (CÓ) | PASS |
| 2 | `stock-balances` không tham số | 200; ≥19 dòng; `unit=hộp`; bất biến 6 ô từng dòng | client stock-balances (CHƯA) | PASS (33 dòng) |
| 3 | `stock-balances?skuId=A3/CS/LUON` | chỉ SKU đó; `available=1000` | stock-balances (CHƯA) | PASS |
| 4 | `availability/check` A3, 10 hộp | SELLABLE, `block_reasons=[]` | availability (CÓ) | PASS |
| 5 | `availability/check` A3, 2000 hộp | NOT_SELLABLE + `STOCK_NOT_AVAILABLE` | availability (CÓ) | PASS |
| 6 | phân trang `limit=1` | cùng `snapshot_id`; trang cuối `complete=true`, `next_cursor=null` | stock-balances (CHƯA) | PASS (33 trang) |
| 7 | đổi `limit` giữa chừng | 400 `CURSOR_INVALID` | stock-balances (CHƯA) | PASS |
| 8 | `?materialId=` | 422 `VALIDATION_FAILED` | stock-balances (CHƯA) | PASS |
| 9 | giữ 10 hộp + gọi lại cùng khoá <30 phút | 201 `RESERVED` → 200 `ALREADY_RESERVED`; chỉ 1 bản ghi | allocations (CHƯA) | PASS |
| 10 | token thiếu quyền | 403 envelope đủ | token đặc biệt do ops-core cấp (không cần mã M3, phải tạo principal trên `.61`) | PASS |
| 11 | `availability/check` C9/CS/THITBO (khoá bán) | NOT_SELLABLE + `SALE_LOCK`; `stock-balances`: available 0, `sale_lock_quantity` 1000 | availability (CÓ) + stock-balances (CHƯA) | PASS |
| 12, 13 (khuyến nghị) | `availability/check` kèm `uom_code` (A3; C9) | EXISTENCE/`sellable_quantity`; C9 `available=1000`, `sellable=0` | availability (CÓ) | PASS |
| C37-1..4 (WP06a thêm, ngoài §6) | cờ tắt → 404; tự nhả; nhả lại → 409 `ALLOCATION_NOT_HELD` + 422 khoá; ISSUED → nhả 409, giữ lại 409 | — (cờ + hợp đồng) | PASS cục bộ (17/17) |

Nguồn WP06a: `C:/Projects/_wt/m12/WP06a-bao-cao.md` bảng dòng 11-29; phiếu `PC/modules/m12/wp/M12-WP06a.md` (commit `8b13ffb96`, verifier R2 ĐẠT 02/11; lệnh `node tools/integration/m3-acceptance/run-m3-acceptance.mjs --profile 61`, `WP02c-checklist.md` C11).

**Chạy được hôm nay (11/11), theo sổ:**
- Phía ops-core qua bộ WP06a trên `.61`: về nguyên tắc cả 13 dòng §6 + C37-1 (cờ tắt ⇒ 404 đúng kỳ vọng). **Chưa chạy lần nào trên `.61` sau bản 152** (WP06 = CHỜ). Điều kiện còn thiếu: `client_secret` của `SVC-M3-SELLABLE`, nguồn gọi được `/v1/*` (TB-01: chỉ `192.168.1.60`), dữ liệu khớp `profiles/61.json`. Rủi ro đã nêu: ca 4, 12 có thể FAIL trên `.61` vì HEAD đòi QR hộp `PRINTED` mà QR lô bán thử `GENERATED` (`M12-WP06a.md:54`). Lô sandbox `M3-SANDBOX-*` chưa gỡ (m12.7 BLOCKED chờ chữ Lan + chú Dũng).
- Phía M3 (suy ra từ H8): ca 1, 4, 5, 11 (+12, 13) chạy được bằng adapter hiện có; **ca 2, 3, 6, 7, 8, 9 (và phần stock-balances của ca 11) "Bị chặn"** vì M3 chưa có client `stock-balances`/`allocations`; ca 10 không cần mã M3.
- C37-2/3/4 không chạy được trên `.61` (cờ tắt, hợp đồng chưa đổi) — chỉ cục bộ.
- Lần chạm thật gần nhất của M3 với `.61`: đo 09/09 (TB §1: 6 lệnh `v1` gọi được; `A3/CS/LUON` SELLABLE) — trước deploy 11/09, không còn là bằng chứng hiện tại.

---

## 4. Quyết định / câu hỏi đang mở (chủ sở hữu, hạn)

| Mã · việc | Trạng thái thật (nguồn) | Chủ | Hạn |
|---|---|---|---|
| m12.78 (cổng LAN 5000 vs loopback) | **ĐÃ CHỐT A 10/11** (D-m12-050, `m12/QUYET_DINH.md:57`); nhưng `m12/TRANG_THAI.md:15` và `SAN_SANG.md:97` còn ghi "chưa chốt" (lỗi thời) | Toàn | B1 cùng WP17b; B2 khi M3 sang tên miền |
| m12.79 (cookie `Secure`) | Sổ liệt kê mở (`SAN_SANG.md:97`) nhưng WP17 đã giải ("`AdminAuthCookies` bật `Secure` khi không phải Development", `SAN_SANG.md:51`); còn phụ thuộc https của Anh Tuấn | Toàn / Anh Tuấn | https 12/11 |
| m12.87 (Production + attestation) | **ĐÃ CHỐT A 10/11** (D-m12-051; `TRANG_THAI.md:40`) nhưng `TRANG_THAI.md:11` còn ghi "cần bạn quyết 6 mục (m12.87)". Còn nợ **3 mục Lead trả lời trước 12/11:** URL https + khoá ký webhook M3 (cần Phúc), đối chiếu tên biến `.env`/`ops-pilot-session.env`, chấp nhận nhãn `vault://` | Toàn (+ Phúc) | **12/11** |
| IP nginx /32 (`M12_FRONT_PROXY_CIDR`) | chưa có giá trị; phụ thuộc Anh Tuấn trả lời đường vào (`SAN_SANG.md:97,109`; D-lead-029) | Toàn hỏi Anh Tuấn | 11–12/11 (nginx https quá hạn từ 07/11) |
| m12.7 gỡ lô sandbox | BLOCKED chờ xác nhận chữ Lan + chú Dũng (sha256 `94db8291…914edd`); làm sau, dừng API ~2 phút; ảnh hưởng dữ liệu `M3-SANDBOX` trong ca 3/9/11 | Lan, chú Dũng; Toàn | 11/11 trở đi |
| m12.90 DB sạch P1 vs P2 · m12.91 smoke Day-1 · m12.93 | mở (`TRANG_THAI.md:43-46`). P1 làm mất `SVC-M3-SELLABLE` → cấp lại secret, M3 phải đổi cấu hình | Toàn | trước cutover 13/11 |
| Adapter giữ hàng/phân bổ/kéo tồn + bên nhận webhook của Phúc | sổ m12 + `VIEC_NGOAI #23` ghi Phúc 08/11 quá hạn; m34 đã giao Toàn (m34.73 A, 24/11); tin hỏi Phúc "adapter đang ở đâu" (10/11) **CHƯA GỬI** (`m34/ra-soat/2026-11-10-tin-phuc.md` §5, dòng đầu "CHƯA GỬI"); tin nháp m12 mục 2 hỏi cùng việc | Toàn (gửi tin); Phúc (trả lời); Toàn (làm) | tin: ngay; làm: 24–27/11 |
| Publish contracts (`ISSUED` + release + 8 mã `COMMON.*` M7), gỡ merge dở | lead.1/lead.45 "đề xuất A" từ 03/11, **không thấy duyệt**, `LEAD-WP04` chưa lập; ops-core + Phúc đều đang chờ (`m12/SAN_SANG.md:101`) | Lead (phiên `lead`) + Phúc review | cam kết 08/11 (quá hạn); m12 cần trước 12/11 để WP07b vào 15/11, không thì 30/11 |
| M34-LIEN (hợp đồng M3↔M7, M3→M6 `ORDER_VERIFIED`, M5→M4, M3↔M8 đường thật) | CHỜ phiên `lead` gỡ merge (`m34/SAN_SANG.md:66`) | phiên `lead` | 20/11 |
| lead.53 / N12 owner | `lead/TRANG_THAI.md:31` (05/11) còn mở; m34 D-m34-056 m34.73 A thực chất chọn B (Toàn làm cả hai phía); lead QUYET_DINH chưa ghi | Lead | m12 ghi hạn 12/11 |
| Đưa N12 vào `lead/SAN_SANG.md` | đề xuất 05/11 (`lead/TRANG_THAI.md:56`), chưa làm | phiên `lead` | — |
| Pin phía M3 `a3b4bbf84` → `a7832a49` hoặc pin mới | chưa ai giao; BP `toandeptrai` chỉ Lead được ghi (D-m34-003) | Toàn (m34) / Phúc | cùng vòng publish |
| Gia hạn ngoại lệ JWT (WP20) | hết 15/11 16:59Z; đóng bằng khoá ký mới ở cutover (D-m12-052) | Toàn | 15/11 |
| nginx/DNS/https 4 tên miền (.60 → .61) | Anh Tuấn quá hạn 07/11 | Anh Tuấn / Toàn | 12/11 |

---

## 5. Mâu thuẫn giữa các tài liệu

1. **Pin của M3:** thông báo ops-core 06/10 + gói chốt §14.1 coi M3 ghim `a413f1f`→`a7832a49`; gitlink thật của BP = `a3b4bbf84` (08/06). `m34/SAN_SANG.md:37` thì nhìn local contracts ("commit cuối 21/05; mọi `info.version` 1.0.0").
2. **Owner + hạn adapter M3:** `m12/SAN_SANG.md:100` Phúc 08/11 · `m34/QUYET_DINH.md:75` (m34.73 A) Toàn 24/11 · `m34/SAN_SANG.md:25` M3-111 27/11 (Phúc, "Chưa bắt đầu") · D-lead-026 (`lead/QUYET_DINH.md:31`) giữ/nhả 27/11 · `m12/SAN_SANG.md:61` WP07b 30/11 · `m34/SAN_SANG.md:64` bảng M3M8-WMS vẫn "CHỜ quyết" (đã quyết 10/11 13:50, sau mốc 11:00 của bảng).
3. **N12 owner:** `m12/SAN_SANG.md:102` "chọn owner — phiên lead, 12/11, chưa" vs m34.73 A (10/11). `lead/SAN_SANG.md` không có N12.
4. **Phạm vi 15/11:** `lead/SAN_SANG.md:18` N8 "11 ca hợp đồng chưa xong" ngầm đòi nối N8 sớm; D-lead-026 và `m12/SAN_SANG.md:119` chốt 15/11 M3 chỉ `availability/check`, giữ/nhả 27–30/11.
5. **m12.78/79/87:** đã chốt ở D-m12-050/051 nhưng `TRANG_THAI.md:11,15` và `SAN_SANG.md:97` còn ghi chưa chốt (§4).
6. **WP02c "bật webhook":** `m12/SAN_SANG.md:50` mô tả phạm vi "bật webhook"; `WP02c-checklist.md:65,79` + D-m12-051: compose WP16 không có `OutboxDispatcher__*` → webhook KHÔNG bật; kết quả 11/11 (`TRANG_THAI.md:9`) không nhắc bật webhook.
7. **Ngày chạy 11 ca:** gói chốt gốc 15/09 (§6); `m12/TRANG_THAI.md:59` "10/11: 11 ca M3"; `SAN_SANG.md:60` 12/11 CHỜ.
8. **`ISSUED` breaking hay không:** policy hợp đồng (thêm enum = không breaking nếu consumer chịu giá trị lạ) vs coi là breaking cần Phúc review (§1.6).
9. **Ma trận tương thích** nói M3 "must not mutate inventory" nhưng reserve là bề mặt ghi ngoài duy nhất (§1.6).
10. **"Có route release":** `m34/SAN_SANG.md:37` nói M2 có `stock-balances/allocations/release` ở `ExternalAllocationCommandV1Endpoints.cs:38,53,58`; route release chỉ map khi cờ bật (`WP07-bao-cao.md` §1) — "có" ở mã, không có trên `.61`, không có trong hợp đồng.
11. **Giới hạn khoá idempotency** 100 (OpenAPI) vs 200 (TB-08).
12. **Token:** TB-02 token 15 phút (`expires_in` 899/900); API ops-core khởi động đổi khoá JWT (token cũ 401) — mỗi CD/restart làm đứt token M3 (`WP02c-checklist.md:65`); M3 cần cache có xử lý 401 → xin lại (TB-15). CHƯA XÁC MINH M3 xử lý.

---

## 6. CHƯA XÁC MINH

- `origin/main` của contracts có đổi sau 10/11 10:19 hay không (không fetch). GitHub đang công khai (m12 nhật ký 11/11 ~08:xx) — chưa tự kiểm.
- Trạng thái thật của `.61` (migration 152, route `ISSUED`, dòng `ISSUED` trong `GET allocations`, cờ `AllocationSelfRelease`) — chỉ theo sổ m12 11/11; không ssh/không gọi API.
- M3 hiện gọi `.61` ở đâu và cấu hình nào (đọc mã M3 do scout khác); commit `67f358ed9` trong sổ m12 vs HEAD BP `b15c6b0f1`.
- Chạy `validate-contracts.mjs` / x03b / x04d trên `a7832a49` (CHƯA CHẠY; không chạy dịch vụ/test).
- WP06 trên `.61`: chưa có log; `profiles/61.json` vs dữ liệu `.61` hiện tại; nguồn IP được phép; secret.
- Phúc đã nhận tin khung giờ `.61` 11/11 chưa (m12 nhật ký 10:5x: "Chưa có tin đã báo"; API đã dừng 11:17–12:33 nên có thể đã báo — không thấy bằng chứng gửi).
- Hạn/nguồn "27/11" của giữ/nhả hàng chỉ có ở D-lead-026 + M3-111; không thấy phiếu WP riêng cho M3M8-WMS ngoài dòng bảng `m34/SAN_SANG.md:64`.
- Webhook có đẩy `INVENTORY_ALLOCATION_RELEASED`/`LOT_BALANCE_UPDATED` cho M3 không (danh sách 13 loại không có; E10 nói "bốn loại no-adapter" sinh dead-letter) — chưa đối chiếu mã.
- Quyền hiện cấp cho `SVC-M3-SELLABLE` sau cutover (hiện 10 quyền, TB-03 dòng 285) — seed production chưa có principal.
- Bảng "chạy được hôm nay" ở §3 phần M3 là SUY RA từ H8 ("chỉ có token + `availability/check`"), không đọc mã M3.

## 7. Lệnh đã chạy (chỉ đọc)

`git -C C:/Projects/ginsengfood-contracts` (`status --short`, `diff --stat`, `ls-tree -r a7832a49`, `show a7832a49:<path>`, `grep`, `rev-list`, `merge-base`, `cat-file`, `log`, `tag`);
`git -C <ops-core|business-platform> ls-tree <rev> ginsengfood-contracts`, `submodule status`, `log -1`; Grep/Read trên `C:/Projects/Project Control/**`, `C:/Projects/_wt/m12/*.md`, `C:/Projects/ginsengfood-ops-core/docs/**`.
Tệp trung gian (bản `git show` của contracts ghim, không bí mật) ở scratchpad phiên: `C:/Users/ADMINI~1/AppData/Local/Temp/claude/0d8e0f0b7c910113/6b4be261-c086-4b8d-b8a0-d709823e1a2e/scratchpad/pin/`. Không đọc `.env*`/`sheet.json`; không ssh; không để lại tiến trình.
