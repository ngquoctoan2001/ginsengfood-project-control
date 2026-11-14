# B. Phía M3 (business-platform) — điểm nối với M12 (ops-core)

Nguồn: repo `C:\Projects\ginsengfood-business-platform`, nhánh `toandeptrai` = `origin/dev` = SHA ghim
`b15c6b0f14a9a973dbf060699bf0ac59f4682a92` (kiểm bằng `git rev-parse HEAD origin/dev toandeptrai`: cả ba trùng).
Chỉ đọc qua `git show b15c6b0f1:<tệp>` / `git grep ... b15c6b0f1`. Checkout có 1 dòng dirty
(`docs/weekly-tracking/nguyen-quoc-toan.md`), không đụng. Không đọc `.env*`, `sheet.json`. Không chạy build/test/ssh/fetch.

Ký hiệu đường dẫn rút gọn (trên SHA ghim):
`J/` = `back-end/src/main/java/com/ginsengfood/project/` · `T/` = `back-end/src/test/java/com/ginsengfood/project/` ·
`R/` = `back-end/src/main/resources/` ·
`BP-W` = `docs/weekly-tracking/bao-cao/bao-cao-tuan-2026-11-02_2026-11-07-M3-ban-hang.md` (tuần 02–07/11);
`BP-W0` = `docs/weekly-tracking/bao-cao/bao-cao-tuan-2026-10-26_2026-10-31-M3-ban-hang.md` (tuần 26–31/10).
Stack M3 backend = Java/Spring (JDK HttpClient, Flyway, Postgres), không phải .NET.
Lưu ý tên: trong tài liệu BP cũ, "M12" (`docs/docs-ginsengfood-project/system-overview-spec.md:141`) = IVR/Security (đánh số cũ),
KHÔNG phải ops-core. Phía M3 gọi ops-core theo tên "ops-core" / `OpsCore*` / `OPS_CORE_*`; grep chữ "M12" sẽ ra nhầm.

## 0. Kết luận ngắn

1. M3 đã có sẵn một client ops-core hoàn chỉnh cho đúng MỘT việc: kiểm tồn/sellable (`POST /v1/availability/check`) + lấy token
   (`POST /v1/service-tokens`). Gọi theo hai kiểu: (a) tại điểm chốt (đặt đơn 24/7, xuất vận đơn, tạo/publish phiên Giờ Vàng, báo giá M4) và
   (b) job kéo nền mỗi 4 phút cho mọi SKU có link. Mã đã gộp vào dev (NK-a; tác giả git: Nguyen Duc Manh, 4 commit C2–C5 ngày 18/10/2026).
2. Cờ mặc định TẮT. Trên `.60` `OPS_CORE_ENABLED` bị ghi cứng `"false"` trong `deploy/m34/compose.yml:181`; compose KHÔNG truyền
   `OPS_CORE_BASE_URL/CLIENT_ID/CLIENT_SECRET` cho `be`; `deploy/m34/tests/test_compose.py:69` khoá giá trị. Bật là một thay đổi compose có Lead duyệt
   (`deploy/m34/README.md:327-329`).
3. M3 CHƯA gọi M12 để GIỮ/XUẤT/NHẢ hàng, CHƯA kéo danh mục SKU/tồn/lô/truy xuất, CHƯA nhận sự kiện (không có webhook/inbox).
   NK-b (giữ hàng 24/7), NK-c (giữ hàng Giờ Vàng), opening-gate, lifecycle: 0 mã; chỉ có luật cấu hình giữ chỗ
   (`J/inventory/config/OpsCoreConfigRules.java:44-89`). Task theo dõi: M3-111, hạn 27/11 (Phúc, Toàn).
4. Tồn kho M3 là sổ riêng trong DB M3 (`product_warehouse_stock`, `inventory_ledgers`); M12 không được báo khi M3 giữ/xuất/nhả.
   Với `gate.enforce` bật, M12 chỉ là cổng kiểm; sổ M3 vẫn phải đủ hàng thì đơn mới qua (xem §5, R1).
5. Hợp đồng M3 ghim (`ginsengfood-contracts` gitlink `a3b4bbf84fa58d5ec8cc44af0ee07b5a4a126e3d`, 08/06/2026) cách `origin/main` hợp đồng
   (cục bộ, `a7832a49f`, 21/09/2026) 50 commit; `service-auth.v1.yaml` mới chỉ có SAU ghim. Không có CI/test nào của M3 đọc thư mục hợp đồng.
   Mã M3 viết theo "PKG" (gói của chief) + bản chụp phản hồi thật 17/10 (13 JSON trong test), không theo OpenAPI ghim.

## 1. M3 đang gọi / định gọi ops-core ở đâu

### 1.1 Client và endpoint (đã có mã)

| Thành phần | Tệp:dòng | Gọi gì (method + path) | Ghi chú |
|---|---|---|---|
| `OpsCoreAvailabilityHttpAdapter` | `J/inventory/adapter/out/client/opscore/OpsCoreAvailabilityHttpAdapter.java:25,33-54,56-68` | `POST /v1/availability/check` | body đúng 4 trường: `sku_id`, `warehouse_id`, `uom_code`, và (FULL_FILL) `requested_quantity{value,unit}` với value là chuỗi; M12 trả 422 nếu thừa trường. 404 = thiếu link, không retry |
| `OpsCoreTokenCache` | `.../opscore/OpsCoreTokenCache.java:34-196` + đường dẫn ở `J/inventory/config/OpsCoreClientConfig.java:30` | `POST /v1/service-tokens` body `{client_id, client_secret}` | client-credentials; không có refresh token |
| `OpsCoreHttpClient` | `.../opscore/OpsCoreHttpClient.java:48-277` | mọi lời gọi nghiệp vụ, thêm `Authorization: Bearer` (dòng 194-209) | hạn mức, 401/429, retry, deadline |
| `JdkOpsCoreHttpTransport` | `.../opscore/JdkOpsCoreHttpTransport.java:15-46` | JDK `HttpClient`, ép HTTP/1.1, `NO_PROXY` | nối thẳng LAN |
| `OpsCoreClientConfig` | `J/inventory/config/OpsCoreClientConfig.java:25-87` | dựng bean, chỉ khi `OpsCoreClientUsableCondition` đúng | cờ tắt/cấu hình sai: bean vắng, người dùng fail-closed, ứng dụng vẫn lên |
| Poller (nền) | `J/sellablegate/adapter/in/scheduler/OpsCoreSellableVerdictPoller.java:49-60,124-135` | `/check` EXISTENCE cho mọi link, ưu tiên nền, nhịp `poll.rate-per-second` | ghi bản chiếu `sellable_gate_ops_core_verdicts` (`R/db/migration/V254__owner_2026_10_07_ops_core_sku_link_and_verdict.sql:38-65`) |
| Commit check (điểm chốt) | `J/sellablegate/service/impl/SellableGateCommitCheckServiceImpl.java:54-56,108-183` | `/check` ưu tiên COMMIT, 1 lời/SKU, không cache, không retry | bean chỉ có khi `gate.enforce=true` (dòng 55) |

Các endpoint M12 khác M3 KHÔNG gọi: `/v1/inventory/allocations` (POST/GET/release), `/v1/inventory/stock-balances`, `/v1/inventory/ledger`,
`/v1/warehouses`, `/v1/skus/*`, `/v1/recall-cases`, `/v1/sale-locks`, `/v1/sellable-statuses/{id}`. (Danh sách route M12 lấy bằng `git grep`
nhanh ở `C:\Projects\ginsengfood-ops-core` nhánh `main` hiện tại, không phải SHA ghim; chi tiết thuộc scout phía M12.) Đã đối chiếu hai đường M3 gọi:
M12 có `MapPost("/v1/service-tokens")` (`services/operational-api/src/Ginsengfood.Operational.Api/Endpoints/ServiceTokenV1Endpoints.cs:17`) và
`MapPost("/v1/availability/check")` (`.../Endpoints/AvailabilitySellableV1Endpoints.cs:71`) → khớp đường M3 gọi. Bucket `READ` (đọc hàng loạt)
được cấu hình ở `OpsCoreClientConfig.java:69` nhưng chưa có lời gọi nào dùng (`git grep 'Bucket.READ'` chỉ ra đúng chỗ cấu hình).

### 1.2 Token

- Lấy: client credentials, `POST /v1/service-tokens` (`OpsCoreTokenCache.java:115-170`). Một lần lấy phục vụ mọi luồng (khoá `fetchLock`, dòng 52,92-107).
- Hạn: `sentAt + expires_in` theo đồng hồ đơn điệu, trừ `token.refresh-margin` (mặc định 60s) (dòng 143); không dùng 899/900 cứng, không dùng `iat`/`expires_at` (dòng 25-28).
- Làm mới khi 401: `OpsCoreHttpClient.java:154-158` bỏ token bị từ chối (chỉ nếu còn là token đang cache, `OpsCoreTokenCache.java:111-113`) rồi gửi lại ĐÚNG MỘT lần; 401 lần hai → `Rejected`.
- Lấy token lỗi: nhớ lỗi, lùi nhịp `failure-backoff` (5s) gấp đôi tới `failure-backoff-max` (60s) (`OpsCoreTokenCache.java:172-178`); trong lúc lùi mọi người gọi nhận "không token" ngay, không chạm mạng (bảo vệ hạn mức token 10/60s/IP của M12, ghi ở dòng 31). 429 chờ ít nhất `Retry-After`. 401 INVALID_CLIENT: log ERROR một lần/chu kỳ (dòng 161-163).
- Không log token/secret (test `OpsCoreHttpClientTest.java:389-410`).

### 1.3 Timeout, retry, hạn mức, cache, ngắt mạch

| Mục | Hành vi | Tệp:dòng |
|---|---|---|
| Timeout | connect 2s; mỗi lời gọi `min(read-timeout 5s, thời gian còn tới deadline của cả request)`; đáp muộn hơn deadline thì bỏ | `R/application.yml:210-211`; `OpsCoreHttpClient.java:123-127,148-150,194-196` |
| Giới hạn read-timeout | cấu hình chỉ cho phép 0,5s..10s | `OpsCoreConfigRules.java:27-28,103-105` |
| Retry điểm chốt | KHÔNG retry 408/502/503/504/mạng/timeout (§0.3 g) | `OpsCoreHttpClient.java:167-172,181-183` |
| Retry nền | 2 lần, cách 1s, chỉ 408/502/503/504/mạng/timeout; 500 không retry; 400/403/404/409/422 không retry | `R/application.yml:243-245`; `OpsCoreHttpClient.java:133-141,167-175,181-192` |
| 429 | chặn bucket tới `Retry-After`; điểm chốt chờ trong `commit.max-wait` (1s) và gửi lại một lần; nền bỏ lượt | `OpsCoreHttpClient.java:159-166` |
| Hạn mức cục bộ | check 5/s burst 10; read 2/s burst 5; nền để dành 3 token cho điểm chốt | `R/application.yml:219-222,235`; `OpsCoreClientConfig.java:65-74` |
| Ngắt mạch | KHÔNG có breaker kiểu Resilience4j. Có: vách ngăn `commit.max-concurrent`=3 khi gọi trong transaction (`OpsCoreCommitBulkhead`), backoff token, bucket cục bộ | `SellableGateCommitCheckServiceImpl.java:109-119` |
| Cache | điểm chốt: KHÔNG cache. Dùng lại kết quả trong cửa sổ `valid_until` (tối đa `verdict.reuse-cap` 5s) để kiểm lúc lưu đơn. Bản chiếu nền (tối đa `projection.max-age` 10 phút) cho hiển thị | `OrderCreateServiceImpl.java:1292-1300`; `R/application.yml:228,238`; `OpsCoreDisplaySource.java:56-84` |
| Ngân sách một request | `commit.max-total` 7s cho mọi SKU của một request | `R/application.yml:225`; `SellableGateCommitCheckServiceImpl.java:101-105` |
| Lệch giờ | chỉ ghi WARN nếu header `Date` của M12 lệch quá 10s; không ảnh hưởng token (dùng đồng hồ đơn điệu) | `OpsCoreHttpClient.java:238-250` |

Chưa thấy M3 gửi `X-Correlation-Id` hay `Idempotency-Key` cho `/check`: `OpsCoreAvailabilityHttpAdapter.java:35-44` truyền `Map.of()` cho header phụ
(client có chỗ cho header phụ ở `OpsCoreHttpCall.java:25`, dùng được cho NK-b).

### 1.4 Cờ bật tắt và tên biến cấu hình (chỉ tên, không giá trị)

Nguồn `R/application.yml:199-245` (khoá `app.inventory.ops-core.*`):
`OPS_CORE_ENABLED` (tắt mặc định) · `OPS_CORE_GATE_ENFORCE` (tắt mặc định; cần `enabled`) · `OPS_CORE_BASE_URL` · `OPS_CORE_CLIENT_ID` ·
`OPS_CORE_CLIENT_SECRET` (chỉ biến môi trường) · `OPS_CORE_ALLOW_PLAIN_HTTP` (tắt mặc định) · `OPS_CORE_MARKET_CODE` · `OPS_CORE_CONNECT_TIMEOUT` ·
`OPS_CORE_READ_TIMEOUT` · `OPS_CORE_TOKEN_REFRESH_MARGIN` · `OPS_CORE_TOKEN_FAILURE_BACKOFF` · `OPS_CORE_TOKEN_FAILURE_BACKOFF_MAX` ·
`OPS_CORE_RATE_CHECK_PER_SECOND` · `OPS_CORE_RATE_CHECK_BURST` · `OPS_CORE_RATE_READ_PER_SECOND` · `OPS_CORE_RATE_READ_BURST` ·
`OPS_CORE_COMMIT_MAX_WAIT` · `OPS_CORE_COMMIT_MAX_TOTAL` · `OPS_CORE_COMMIT_MAX_CONCURRENT` · `OPS_CORE_VERDICT_REUSE_CAP` ·
`OPS_CORE_POLL_ENABLED` (mặc định bật nhưng chỉ chạy khi `enabled`) · `OPS_CORE_POLL_INTERVAL` · `OPS_CORE_POLL_MAX_INTERVAL` · `OPS_CORE_POLL_INITIAL_DELAY` ·
`OPS_CORE_POLL_RATE_PER_SECOND` · `OPS_CORE_POLL_RESERVE_TOKENS` · `OPS_CORE_POLL_ROUND_MARGIN` · `OPS_CORE_PROJECTION_MAX_AGE` ·
`OPS_CORE_SCHEDULER_POOL_SIZE` · `OPS_CORE_CLOCK_SKEW_WARN_THRESHOLD` · `OPS_CORE_RETRY_MAX_ATTEMPTS` · `OPS_CORE_RETRY_BACKOFF`.
Dạng Spring relaxed còn thấy: `APP_INVENTORY_OPS_CORE_GATE_ENFORCE` (`deploy/m34/m8-gia-lap/lam-moi-ton-thu.sh:31`).

Khoá chỉ có trong luật cấu hình, KHÔNG có trong yml, chưa có mã đọc (`OpsCoreConfigRules.java:44-89,148-172`): `allocation.enabled`,
`allocation.max-hold/min-hold/clock-skew-margin/verify-window/claim-lease/reconcile.*/release-sweep-slack/release.enabled`, `rate.allocation-*`,
`golden-hour-allocation.enabled/chain-slack`, `opening-gate.enabled/interval/page-limit`,
`lifecycle.enabled/interval/status-path/sku-code-path/active-values/paused-values/retired-values`, `rate.catalog-*`.
Chuỗi phụ thuộc cờ (dòng 50-54): `gate.enforce` cần `enabled`; `allocation.enabled` cần `gate.enforce`; `golden-hour-allocation.enabled` cần `allocation.enabled`.

Ràng buộc đáng nhớ:
- `base-url` phải `https`; `http` chỉ khi `allow-plain-http=true` (`OpsCoreConfigRules.java:97-100,175-188`; test `OpsCoreHttpClientTest.java:474-475`).
  Địa chỉ LAN `http://192.168.1.61:5000` vì thế cần `OPS_CORE_ALLOW_PLAIN_HTTP` bật.
- `allocation.release.enabled=true` bị coi là sai cấu hình vì "bộ nhả chưa có" (dòng 55-58).
- Cấu hình sai: ứng dụng vẫn lên, client và job không tạo, mọi điểm chốt trả 503; chỉ log tên khoá (`J/inventory/config/OpsCoreConfigValidator.java:30-45`).

### 1.5 Test phủ (đều giả, loopback hoặc bản chụp; không có test nào gọi M12 thật)

- Client/token/hạn mức: `T/inventory/adapter/out/client/opscore/OpsCoreHttpClientTest.java` (server loopback `com.sun.net.httpserver`, dòng 53). Ca chính:
  8 luồng chung 1 token (dòng 86), 20 luồng bị 401 chung 1 token mới (111), 403 không retry (174), INVALID_CLIENT nhớ lỗi (203), 429 (235-285),
  retry nền (297-340), deadline (343-355), HTTP/1.1 + Bearer (368), log không lộ bí mật (390), body `/check` đúng trường (411), plain-HTTP (475).
  Cùng thư mục: `OpsCoreRateLimiterTest`, `OpsCoreAvailabilityResponseParserTest`, `OpsCoreTestSupport`.
- Luật 3a–3e + bản chụp: `T/opscorecontract/OpsCoreFixtureVerdictContractTest.java` dùng 13 JSON ở `back-end/src/test/resources/opscore/`
  (`pkg-ca04/05/11/12/13`, `pkg-check-quantity-object-seven-digits`, `e2-n1..n5`, `pkg-error-401`, `pkg-error-422`; đồng hồ cố định 2026-10-17);
  `T/sellablegate/domain/opscore/OpsCoreVerdictMapperTest`.
- Cấu hình: `T/inventory/OpsCoreConfigYamlTest`, `T/inventory/config/OpsCoreConfigValidatorTest`, `OpsCoreNoHardcodedValuesTest`,
  `OpsCoreMigrationContractTest`, `T/architecture/OpsCoreModuleBoundaryTest`.
- Điểm chốt: `T/sellablegate/service/impl/SellableGateCommitCheckServiceImplTest`, `T/opscorecontract/OpsCoreCommitCheckValidityTest`,
  `OpsCoreCommitPortWiringTest`, `T/order/service/OrderCreateServiceImplOpsCoreGateTest`, `T/order/service/cache/CachedOrderCreateServiceTest`,
  `T/order/service/support/AdminShipmentDeliveryStockCheckTest`, `T/promotion/service/GoldenHourReservationServiceImplTest` (dòng 482),
  `GoldenHourSessionServiceImplTest`, `T/advisorsales/service/impl/QuoteSnapshotServiceImplTest`, `QuoteRevalidationServiceImplTest`.
- Nền + dừng thu hồi: `OpsCoreSellableVerdictPollerTest`, `OpsCoreSellableGateSchedulerTest`, `OpsCoreRecallStopWriterTest`,
  `OpsCoreRecallStopWriterEventTest`, `OpsCoreRecallStopQueryServiceTest`, `T/order/service/support/OrderRecallStopNotifierTest`, `ShipmentRecallStopNotifierTest`.
- Postgres/Testcontainers (3 lớp): `T/order/OpsCoreGateEnforcePostgresTest`, `T/sellablegate/OpsCoreLinkAndVerdictPostgresTest`,
  `T/seed/OpsCoreVerdictRealE2eDataSeederPostgresTest`. Loại khỏi lớp nhanh (`back-end/pom.xml:343-346`, `back-end/ci/docker-tests.txt:241,390,397`),
  chạy ở job integration của `.github/workflows/ci-full.yml:79-108` (không chặn PR, dòng 3). Tổng 25 tệp test tên `OpsCore*` (đếm `git ls-tree` dưới `back-end/src/test/java`).
- Bằng chứng chưa chạy thật: `BP-W0` dòng 55 "chạy trong test; cờ tắt mặc định; chưa chạy với ops-core/IVR thật"; dòng 102 "script 11 ca ops-core:
  KHÔNG KIỂM ĐƯỢC: cần máy .60 và hồ sơ của Mạnh".

### 1.6 Nơi tiêu thụ kết quả ops-core trong M3 (điểm chốt)

| Điểm chốt | Tệp:dòng | Điều kiện | Lỗi trả khách |
|---|---|---|---|
| `POST /api/v1/orders` 24/7 | `J/order/service/cache/CachedOrderCreateService.java:111-134` (kiểm trước transaction) rồi `J/order/service/impl/OrderCreateServiceImpl.java:506-509,1261-1289,1292-1300` | `gate.enforce` | hạ tầng lỗi hoặc thiếu cổng: 503 `OPS_CORE_UNAVAILABLE`; verdict chặn: 409 `CUSTOMER_TRANSACTION_UNAVAILABLE` (`SELLABLE_GATE_NOT_SELLABLE`) |
| Xuất vận đơn `PUT /api/v1/admin/shipments/{id}/status` sang SHIPPING | `J/order/service/support/AdminShipmentDeliveryStockCheck.java:73-89,106-132` (gọi từ `J/order/api/AdminShipmentController.java`) | `gate.enforce`; mục đích `DELIVERY`, EXISTENCE | 409 `SHIPMENT_STOCK_GATE_BLOCKED` (cả khi hạ tầng lỗi, dòng 114,126) |
| `cod-delivered` | `AdminShipmentDeliveryStockCheck.java:95-104` (gọi từ `J/order/service/cache/CachedOrderStateMachine.java`) | như trên; nửa này sẽ gỡ ở NK-b (`contracts/contract-diff/ops-core-sellable-gate-nk-a-diff.md:35`) | 409 như trên |
| Tạo/sửa/publish phiên Giờ Vàng (admin) | `J/promotion/service/impl/GoldenHourSessionServiceImpl.java:961,993` | `gate.enforce` | 503 `OPS_CORE_UNAVAILABLE`, 409 `Session SKU is not sellable` |
| Đặt chỗ Giờ Vàng của khách | `J/promotion/service/impl/GoldenHourReservationServiceImpl.java:168-176,226-228` | `gate.enforce` và chưa có NK-c | LUÔN 409 `GOLDEN_HOUR_OPS_CORE_HOLD_NOT_READY` (bẫy: bật enforce là mọi đặt chỗ Giờ Vàng bị từ chối; `BP-W0` dòng 70) |
| Báo giá M4 nội bộ | `J/advisorsales/service/impl/QuoteSnapshotServiceImpl.java:582`, `QuoteRevalidationServiceImpl.java:319` | `gate.enforce` | 503 `OPS_CORE_UNAVAILABLE`; 422 `SKU_NOT_SELLABLE` |
| Hiển thị công khai + giỏ hàng | `J/catalog/service/impl/PublicSellableAvailabilityDisplayServiceImpl.java:55-60,93-106`; `J/sellablegate/service/impl/OpsCoreDisplaySource.java:56-84` (đọc bản chiếu, không gọi M12 trực tiếp) | F-1, không cờ (`contract-diff:18-23`) | `sellable=false`, lý do `INVENTORY_UNAVAILABLE` hoặc `WMS_UNCONFIRMED` |
| Ghi dừng bán khi thu hồi | `J/sellablegate/service/impl/OpsCoreRecallStopWriter.java`; cảnh báo lớp 2 ở `J/order/service/support/OrderRecallStopNotifier.java`, `ShipmentRecallStopNotifier.java` | `enabled` (poller) | chỉ log `OPS_CORE_RECALL_STOP_*`; runbook `docs/docs-ginsengfood-project/to-do-list/migration-readiness/ops-core-recall-stop/ops-core-recall-stop-runbook.md:14-23` |
| M8 gọi xác nhận lại đơn | `J/order/adapter/out/OrderIvrRevalidationAdapter.java:19-21` | đọc bản chiếu dừng thu hồi cục bộ, không gọi M12 | không |

Hợp đồng lỗi: `contracts/contract-diff/ops-core-sellable-gate-nk-a-diff.md:18-42`. Dòng 46 ghi "Pending for items 1–4: chờ anh xác nhận trước khi FE làm":
chưa ai xác nhận các thay đổi hành vi này với FE (không đổi OpenAPI). FE chưa có câu chữ cho `OPS_CORE_UNAVAILABLE`, `SHIPMENT_STOCK_GATE_BLOCKED`,
`GOLDEN_HOUR_OPS_CORE_HOLD_NOT_READY` (dòng 54-56). Số dòng trong contract-diff đo trên nhánh cũ `feat/m3-backend-manh`; số dòng mã ở bảng trên đã đo lại trên SHA ghim.

## 2. Luồng nghiệp vụ M3 cần từ M12

| Luồng | M3 hiện làm gì (nguồn dữ liệu) | Điểm cần gọi M12 / trạng thái nối |
|---|---|---|
| Kiểm tồn khi đặt hàng 24/7 | Cờ tắt: đọc bản chiếu WMS cục bộ + sổ tồn cục bộ. Cờ bật: `/check` FULL_FILL (`requested_quantity` = tổng số hộp theo SKU) tại `CachedOrderCreateService.java:111-134`, rồi vẫn `reserveForOrder` trên sổ cục bộ (`OrderCreateServiceImpl.java:636-643`; chỉ đơn 24/7 vì dòng 388 truyền `reserveInventory=true`, đơn Giờ Vàng dòng 421 truyền `false`) | ĐÃ CÓ mã `/check`. Cần: link SKU/kho nạp vào DB, cờ bật, kiểm với M12 thật |
| Giữ hàng (hold/reserve) | Chỉ sổ cục bộ: `J/inventory/service/impl/InventoryMovementServiceImpl.java:81-155`; thiếu tồn cục bộ ném 422 "Insufficient stock" (dòng 141-144). M12 KHÔNG được báo | CHƯA CÓ: NK-b (`POST /v1/inventory/allocations`). Có tên khoá cấu hình giữ chỗ nhưng không có mã (`OpsCoreConfigRules.java:148-172`) |
| Xác nhận / xuất kho | `J/order/service/impl/ShipmentServiceImpl.java:477` gọi `exportForShipment` (sổ cục bộ). Trước SHIPPING, M3 gọi `/check` mục đích DELIVERY (đã có), bỏ qua token `STOCK_NOT_AVAILABLE` vì hàng của đơn đã bị giữ (`SellableGateCommitCheckServiceImpl.java:60-64`, ghi TODO(T-831-OD-8): chief chưa xác nhận ngoại lệ này) | `/check` đã có; commit/xuất kho phía M12: CHƯA CÓ (cần NK-b) |
| Huỷ / nhả hàng | `J/order/service/impl/OrderStateMachineImpl.java:183,257,413` gọi `releaseForOrder` (sổ cục bộ) | CHƯA CÓ gọi `POST /v1/inventory/allocations/release`; cờ `allocation.release.enabled` đang bị cấm (`OpsCoreConfigRules.java:55-58`). Hệ thống chưa có đường huỷ đơn CONFIRMED/PACKED (runbook thu hồi dòng 40, QĐ 1610-23 "chưa làm") |
| Sellable / khoá bán / dừng bán khi thu hồi | ĐÃ CÓ qua kéo: `recall_case_open`, `quality_hold`, `recall_hold`, `sale_lock`, `block_reasons` (11 token) cho ra `NOT_SELLABLE` hoặc `UNKNOWN_BLOCKED` (`OpsCoreVerdictMapper.java:59-142`, `OpsCoreBlockers.java:12-23`); dừng bán và recheck (`OpsCoreRecallStopWriter`, cột `recall_stop_*` ở V254). Độ trễ phát hiện thu hồi tối đa khoảng 5 phút (poll 4 phút, tối đa 5 phút, `R/application.yml:231-232`; runbook dòng 29) vì không có sự kiện đẩy | Cần sự kiện đẩy nếu muốn rút độ trễ: CHƯA CÓ (§3) |
| Truy xuất lô | KHÔNG có trong luồng khách. Có `InventoryLot` và admin `AdminInventoryController` (cục bộ). Token `TRACE_NOT_READY`, `BATCH_NOT_RELEASED`, `HSD_NOT_VALID` chỉ là lý do chặn đến từ M12 | CHƯA CÓ lời gọi truy xuất M12 nào; không thấy tài liệu M3 yêu cầu truy xuất lô từ M12 |
| Danh mục SKU / vòng đời | SKU master là sổ riêng của M3. Đổi trạng thái từ cổng admin đã gỡ: `PATCH /api/v1/admin/catalog/sku-master/status` trả 410 `SKU_MASTER_STATUS_MANAGED_EXTERNALLY` (`J/catalog/api/CatalogAdminExceptionHandler.java:159`; `contracts/contract-diff/catalog-sku-phase-02-diff.md:29` ghi "External integration is the sole future owner of active, locked, deprecated"). Liên kết SKU với M12 là bảng `ops_core_sku_links` nạp tay | CHƯA CÓ kéo `GET /v1/skus` hay vòng đời (`lifecycle.*` không có mã). Task M3-025 của Phúc ON_HOLD từ 03/11 chờ hướng chủ (`docs/weekly-tracking/truong-cong-phuc.md:1848-1860`) |
| Giờ Vàng (suất giữ hàng theo kho) | Sổ Giờ Vàng cục bộ (`GoldenHourReservationServiceImpl`); đặt chỗ bị chặn hẳn khi enforce (dòng 226-228) | NK-c: CHƯA CÓ |
| Tồn hiển thị cho khách | Bảng `product_sellable_availability`; khi enforce, chỉ job ops-core ghi bảng này (`J/inventory/adapter/out/client/InventorySellableAvailabilityChangeAdapter.java:57-61`) | ĐÃ CÓ. Poller dùng lại nguồn `WMS_API` (`OpsCoreSellableVerdictPoller.java:275`, TODO(T-831-OD-22)) |

## 3. Bên nhận sự kiện từ M12 phía M3

- KHÔNG có endpoint webhook/inbox cho sự kiện ops-core. Kiểm: `git grep` các `@RequestMapping("/v1|/internal|/api/v1/internal|/api/v1/integrations|/api/v1/webhook")`
  chỉ ra `advisor-sales`, `ai/internal` và `esms` (`J/customer/api/EsmsOtpCallbackController.java:16`). Không có bảng hay dịch vụ "inbox" cho ops-core.
- Quyết định có chủ ý: "NK-a builds no endpoint; OD-2" (`J/sellablegate/port/in/OpsCoreRecallSignalPort.java:6-10`). Cổng nối sẵn:
  `OpsCoreRecallSignalPort.onRecallCaseOpened(Optional<UUID> opsCoreSkuId)` (dòng 14), cài ở `J/sellablegate/service/impl/OpsCoreRecallSignalService.java:41-55`:
  đánh dấu recheck mọi SKU trong tập quét, chuyển UNKNOWN_BLOCKED tới khi một lần kéo mới thành công, kéo SKU được báo trước. Hiện chỉ
  `OpsCoreSellableGateScheduler.java:176` và `SellableGateCommitCheckServiceImpl` (khi thấy `recall_case_open=true` ở lời gọi sống, dòng 153-157) dùng cổng này.
- Sự kiện phía hợp đồng: `ops-core.recall.recall-case-opened.v1` có trong `ginsengfood-contracts` `origin/main` cục bộ
  (`asyncapi/ops-core-events.v1.yaml:94`), CHƯA có trong bản ghim của M3 (commit thêm kênh là `79f73d2`, sau ghim). Cách chuyển tải (webhook/broker/poll) chưa chốt:
  `M3-WMS-ORD-OD-11` ghi `PENDING_OWNER_APPROVAL` (`docs/docs-ginsengfood-project/to-do-list/m3-wms-order-boundary-owner-decision-log.md:124`, bản 28/08,
  có thể đã lỗi thời; CHƯA XÁC MINH).
- M3 đang thiếu để nhận sự kiện: (1) route nhận (khuôn gợi ý: `EsmsOtpCallbackController`); (2) xác thực/chữ ký (cách M12 ký: CHƯA XÁC MINH, thuộc scout M12);
  (3) bảng hộp thư + khoá idempotency theo `event_id`; (4) bộ xử lý theo loại event (tối thiểu `recall-case-opened` gọi `onRecallCaseOpened`; thêm stock/sale-lock/quality-hold);
  (5) cờ cấu hình + test; (6) migration (số kế tiếp là V332 sau V331, từ `git ls-tree` dưới `R/db/migration`).

## 4. Tài liệu, kế hoạch, hạ tầng, hợp đồng, CI

### 4.1 Tài liệu và kế hoạch

- Đặc tả T-831/T-832 (NK-a) được dẫn khắp mã nhưng tệp đặc tả KHÔNG nằm trong repo BP (`git grep -l 'T-831'` ngoài kho lưu trữ chỉ ra
  `contracts/contract-diff/ops-core-sellable-gate-nk-a-diff.md` và runbook thu hồi). "PKG" (gói tài liệu của chief), "E2 v1.2", "script 11 ca" cũng không có trong repo. CHƯA XÁC MINH vị trí.
- Trong repo có:
  - `contracts/contract-diff/ops-core-sellable-gate-nk-a-diff.md` (24/10): thay đổi hành vi khi bật cờ (xem §1.6).
  - Runbook thu hồi (`docs/docs-ginsengfood-project/to-do-list/migration-readiness/ops-core-recall-stop/ops-core-recall-stop-runbook.md`): R0 ghi chưa có đường đưa log
    tới người trực, "điều kiện deploy riêng, chưa có" (dòng 7-12).
  - `docs/docs-ginsengfood-project/integration-reviews/external-wms-api-information-requirements.md` (13/08, làm tươi 28/08): "Can real WMS connector implementation start: NO" (dòng 11).
    Nay lỗi thời một phần vì NK-a đã thêm client HTTP; ý "chưa có webhook controller" vẫn đúng.
  - `docs/docs-ginsengfood-project/to-do-list/m3-wms-order-boundary-owner-decision-log.md` (28/08): 0/11 quyết định đã chốt (dòng 24). OD-02: ops-core đòi `sourceObjectId` kiểu UUID,
    đơn M3 là `BIGINT` (dòng 68,82-83,115). `git grep 'external_uuid|order_uuid'` trong `R/db/migration` không thấy cột UUID ngoài. Trạng thái hiện tại OD-01..11: CHƯA XÁC MINH.
- Kế hoạch/tracking và người làm:
  - NK-a xong mã, chưa bật (`BP-W0` dòng 23, 65).
  - Việc 9 "Xác nhận đơn tự động (IVR) và cổng kho NK-b, NK-c": người làm Phúc, Toàn; hạn 27/11 (dời từ 15/11); mã Sheet M3-023 (IVR, Toàn) và M3-111 (NK-b, NK-c)
    (`BP-W` dòng 103,171). "Mốc 15/11 giữ xác nhận tay 24 giờ".
  - M3-115 "chuẩn bị release 30/11: cấu hình thật (Gmail, VNPAY, ops-core)": Phúc, Toàn, Tài; hạn 29/11; chờ Lead cấp thông số thật trước 24/11 (`BP-W` dòng 104,115).
  - M3-071 (máy `.60`) và M3-100 (UAT máy): Toàn (`BP-W` dòng 97).
  - Tác giả mã NK-a: Nguyen Duc Manh (git log, commit `314df4f3f`, `fda99396f`, `a35872a1b`, `e84305564`, 2026-10-18). Phúc: tuần 02–07/11 "không có commit" (`BP-W` dòng 24).
  - Tài (vận chuyển/thanh toán): bật GHN/VTP "phụ thuộc ops-core C36 (C10)" (`bao-cao-tuan-2026-10-26_2026-10-31-M3-van-chuyen-thanh-toan.md:66`); nội dung C36: CHƯA XÁC MINH.
  - M3 đang chờ Lead: "thông số ops-core thật (địa chỉ, khoá kết nối, script 11 ca), đồng bộ giờ và HTTPS máy chủ" (`BP-W0` dòng 122; `BP-W` dòng 114-115). Phương án khi không có: "giữ cờ tắt; kiểm kho bằng tay".

### 4.2 Triển khai M3 trên `.60`

- `deploy/m34/compose.yml`: 6 dịch vụ (pg, redis, clamav, be, fe, nginx); `be` ở mạng `app` và `proxy`; cổng ra ngoài duy nhất `192.168.1.60:80` (`deploy/m34/README.md:28`).
- `be` KHÔNG có `env_file`, KHÔNG có `extra_hosts`; chỉ truyền cờ ghi cứng; `OPS_CORE_ENABLED: "false"` ở dòng 181; chú thích dòng 6-7: cờ ops-core "ghi cứng TẮT, `.env` và biến môi trường không mở được;
  mở là một thay đổi compose có duyệt của Lead". Không truyền `OPS_CORE_BASE_URL/CLIENT_ID/CLIENT_SECRET/ALLOW_PLAIN_HTTP/GATE_ENFORCE`.
- Không tài liệu BP nào ghi đường mạng hay cổng `.60` tới `.61` cho ops-core (`git grep` `\.61|api-ops|5000` trong `deploy/m34/README.md` chỉ ra `.61` của khuôn M8/M12 ở dòng 3, 364, 641).
  Đường `.60` tới `192.168.1.61:5000`: CHƯA XÁC MINH. `JdkOpsCoreHttpTransport` ép `NO_PROXY` (không đi qua proxy hệ thống).
- `be` chạy profile mặc định, không đặt `SPRING_PROFILES_ACTIVE` (README:35-37), nên cảnh báo `OPS_CORE_OBSERVATION_MODE_IN_PRODUCTION` (chỉ khi profile `production`, `OpsCoreConfigValidator.java:38-44`) không xuất hiện.
- Các chỗ khoá cứng "ops-core tắt" phải sửa đồng bộ khi bật: `compose.yml:6-7,181`; `deploy/m34/tests/test_compose.py:69`; `test_m8_gia_lap.py:303`; `test_lam_moi_ton_thu.py:44-46`;
  `deploy/m34/m8-gia-lap/lam-moi-ton-thu.sh:31-34` (từ chối chạy nếu `OPS_CORE_ENABLED` khác false hoặc có cờ enforce); `deploy/m34/README.md:338,589`;
  bằng chứng M3-112 (`docs/integration/m3-m8/evidence/m3-112-20261109/cross-review-independent.md:18`, `cross-review-stock.md:29`) ghi "ops-core tắt" là điều kiện môi trường.
- Máy `.60` thực tế đang chạy bản BP nào, ops-core bật hay tắt: không kiểm (cấm ssh). Tài liệu: tắt.

### 4.3 Pin hợp đồng

- Gitlink `ginsengfood-contracts` = `a3b4bbf84fa58d5ec8cc44af0ee07b5a4a126e3d` (`git ls-tree b15c6b0f1 ginsengfood-contracts`; `.gitmodules` có một submodule, url GitHub).
  Thư mục submodule trong checkout BP trống (`git submodule status` hiện ký tự `-`, chưa khởi tạo).
- Theo repo hợp đồng cục bộ `C:\Projects\ginsengfood-contracts` (chỉ đọc): commit ghim ngày 2026-06-08 ("save"), là tổ tiên của `origin/main`, cách 50 commit
  (`git rev-list --count a3b4bbf..origin/main`); `origin/main` cục bộ = `a7832a49f49c430128f5013a6ddce773b138b7df` (2026-09-21). Bản `origin/main` cục bộ có thể cũ hơn remote thật (không `fetch`).
- Khác biệt từ ghim tới `origin/main` cục bộ ở `openapi/ops-core`: `service-auth.v1.yaml` (+161, mới), `inventory.v1.yaml` (+510), `warehouse.v1.yaml` (+349), `sku.v1.yaml` (+168),
  `recall-sale-lock.v1.yaml` (+147), `availability-sellable.v1.yaml` (+103/-6: thêm chính sách hạn mức check 10 rps burst 20, đọc hàng loạt 2 rps burst 4,
  `server_timeout_seconds` 2 và 10, retry tối đa 1 và 2). So với M3: check 5/s burst 10 (thấp hơn, an toàn), read 2/s burst 5 (burst cao hơn 4 của M12; chưa dùng).
- Không mã/CI/test nào của M3 đọc thư mục hợp đồng (`git grep ginsengfood-contracts` ở `back-end`, `.github`, `deploy`, `docker-compose*`: chỉ hai tệp Java về ngoại lệ Giờ Vàng
  trùng chuỗi, và `tools/task-tracker/*`). Hợp đồng hai chiều (two-way contract test) "PENDING" theo decision log dòng 75-76.

### 4.4 CI

- `.github/workflows/ci.yml` chạy `./mvnw test -P ci-unit` theo hai nhóm (AI, nền tảng), loại `back-end/ci/docker-tests.txt`; test `OpsCore*` (trừ 3 lớp Postgres) nằm trong lớp nhanh.
- `.github/workflows/ci-full.yml` chạy cả lớp Docker/Testcontainers, không chặn PR. `.github/workflows/m34-images.yml` dựng image GHCR cho `.60`.
- Không job nào gọi ops-core thật.

## 5. Khoảng trống phía M3 so với "M3 gọi M12" và rủi ro

### 5.1 Việc cần viết hoặc cấu hình thêm (chỉ gợi ý, không viết mã)

| # | Việc | Gợi ý tệp/module | Ghi chú |
|---|---|---|---|
| G1 | Dữ liệu link: nạp `ops_core_sku_links` (UUID SKU của M12, đơn vị `hộp/thùng/lọ/hũ`, `ops_core_sku_code = sku_code`) và `ops_core_warehouse_links` (1 kho mặc định) | script nạp + runbook (KHÔNG có trong repo: V254 dòng 3-5 ghi "nạp theo từng môi trường bằng script runbook đã kiểm, không bằng migration"; `J/inventory/repository/jdbc/OpsCoreLinkJdbcRepository.java:11-13`) | Không có link thì mọi SKU là `OPS_CORE_SKU_LINK_MISSING`, bán bị chặn (`OpsCoreDisplaySource.java:58-61`; `SellableGateCommitCheckServiceImpl.java:130-133`). Lấy id từ `GET /v1/skus`, `GET /v1/warehouses` của M12 (M3 chưa có client cho hai route này) |
| G2 | Cấu hình `.60`: truyền `OPS_CORE_ENABLED`, `OPS_CORE_BASE_URL`, `OPS_CORE_CLIENT_ID`, `OPS_CORE_CLIENT_SECRET`, `OPS_CORE_ALLOW_PLAIN_HTTP` (nếu dùng `http://192.168.1.61:5000`) vào `be`; sửa test/script khoá "tắt" (§4.2); bật quan sát (enabled, chưa enforce) trước, enforce sau | `deploy/m34/compose.yml`, `env.mau`, `tests/test_compose.py`, `tests/test_m8_gia_lap.py`, `tests/test_lam_moi_ton_thu.py`, `m8-gia-lap/lam-moi-ton-thu.sh`, `README.md` mục 8 | Secret đi qua `.env` 600 bằng nội suy như `POSTGRES_PASSWORD`; cờ ghi cứng trong compose theo README:327-329, Lead duyệt |
| G3 | Header `Host`: JDK `HttpClient` hạn chế đặt header `Host` thủ công (hành vi JDK, suy từ hiểu biết, CHƯA XÁC MINH bằng chạy). Nếu M12 cần `Host: api-ops.ginsengfood.vn`, đặt `OPS_CORE_BASE_URL` theo tên miền rồi ánh xạ DNS/`extra_hosts` trong container `be`, hoặc gọi thẳng `IP:5000` (Host sẽ là IP:cổng) | `OpsCoreHttpCall.java:25` chỉ có `extraHeaders`; `JdkOpsCoreHttpTransport.java:19-25` không đặt Host | Cần biết M12 có kiểm Host không (scout M12). Nếu qua Caddy HTTPS: JDK trong image `be` phải tin chứng chỉ |
| G4 | NK-b: giữ hàng khi tạo đơn 24/7, nhả khi huỷ/hết hạn, commit khi xuất kho, đối soát | `OpsCoreAllocationHttpAdapter` cạnh `OpsCoreAvailabilityHttpAdapter`; cổng `OpsCoreAllocationPort`; dịch vụ trong `order`; bảng sổ giữ hàng + migration V332+; job đối soát; móc vào `OrderCreateServiceImpl.java:636-643`, `OrderStateMachineImpl.java:183,257,413`, `ShipmentServiceImpl.java:477`; gỡ luật cấm ở `OpsCoreConfigRules.java:55-58` | Phụ thuộc UUID đơn và dòng đơn (M3-WMS-ORD-OD-02/03), khoá idempotency, quy tắc lỗi (OD-07). M12 có `POST/GET /v1/inventory/allocations` và `.../release` (grep route M12) |
| G5 | NK-c: giữ hàng Giờ Vàng; gỡ chốt `GOLDEN_HOUR_OPS_CORE_HOLD_NOT_READY` | `GoldenHourReservationServiceImpl.java:168-176,226-228`, `GoldenHourSessionServiceImpl`, `GoldenHourReleaseService` | Bắt buộc nếu bật `gate.enforce` mà vẫn muốn Giờ Vàng chạy |
| G6 | Đọc hàng loạt: tồn/số dư (`opening-gate`), vòng đời SKU (`lifecycle`), danh mục SKU | adapter đọc dùng bucket `READ` (đã cấu hình), phân trang `limit` 1..100 (`OpsCoreConfigRules.java:29-30,70-79`) | Chưa có mã; chưa chắc cần cho bản 15/11 |
| G7 | Nhận sự kiện M12 (inbox + route + chữ ký + xử lý) | controller kiểu `EsmsOtpCallbackController`; bảng inbox; gọi `OpsCoreRecallSignalPort` | Cần chốt chuyển tải với M12 trước |
| G8 | Nâng ghim hợp đồng và kiểm hai chiều | cập nhật gitlink `ginsengfood-contracts`; test đối chiếu với `openapi/ops-core/availability-sellable.v1.yaml` và `service-auth.v1.yaml` | Ghim cũ 50 commit; M3 chưa tiêu thụ hợp đồng nên lệch im lặng |
| G9 | Làm tươi bản chụp phản hồi (13 JSON, chụp 17/10) bằng M12 hiện tại và chạy lại "11 ca" | `back-end/src/test/resources/opscore/*.json`, `OpsCoreFixtureVerdictContractTest` | M3 coi MỌI sai lệch là `UNKNOWN_BLOCKED`. Yêu cầu của M3 với `/check`: khung gốc có `schemaVersion="v1"`; `data.decision` thuộc {SELLABLE, NOT_SELLABLE}; `data.block_reasons` là mảng chuỗi chỉ gồm 11 token (`OpsCoreBlockers.java:12-23`); `data.recall_case_open` boolean BẮT BUỘC; khi gửi `uom_code` thì khối số lượng đủ (`sellable_quantity` nguyên >= 0, `available_quantity` >= sellable, `resolved_at`, `valid_until` > `resolved_at`, đơn vị trùng đơn vị đã gửi); `correlation.correlationId` để log (`OpsCoreVerdictMapper.java:59-142`, `OpsCoreAvailabilityResponseParser.java:30-80`). Thiếu một trường là bán bị chặn |
| G10 | Đường đưa log cảnh báo tới người trực + câu chữ FE cho `OPS_CORE_UNAVAILABLE` | runbook R0 (chưa có), FE | Điều kiện deploy riêng, chưa có (runbook dòng 7-12; contract-diff dòng 54-56) |

### 5.2 Rủi ro

- R1 (hai sổ tồn): với `gate.enforce`, `/check` chỉ kiểm; M3 vẫn gọi `reserveForOrder` trên sổ cục bộ và ném 422 nếu sổ cục bộ thiếu
  (`InventoryMovementServiceImpl.java:141-144`). Kịch bản sai: M12 nói còn hàng nhưng sổ M3 hết hoặc không được nạp thì khách bị 422 sau khi đã qua cổng.
  Ngược lại M12 hết hàng thật mà sổ M3 dư thì cổng M12 chặn (an toàn). Chưa có cơ chế đồng bộ tồn M12 vào sổ M3 (G6) hay thay sổ M3 bằng giữ hàng M12 (G4).
- R2 (đua dữ liệu, trùng giữ hàng): M12 chưa có hold từ M3 nên hai đơn đồng thời cùng cuối hàng đều qua `/check` (kiểm không giữ gì); chỉ sổ M3 làm chốt chặn
  (khoá hàng `findByProductIdForUpdate`, `InventoryMovementServiceImpl.java:97`; chống trùng theo đơn `existsByRefTypeAndRefIdAndMovementType`, dòng 87-90).
  Khi làm NK-b cần khoá idempotency theo đơn và quy tắc huỷ/hết hạn khi M12 chậm (`M3-WMS-ORD-OD-07` "fail-closed", chưa rõ đã chốt).
- R3 (token hết hạn): đã xử lý (làm mới trước hạn 60s, 401 thì lấy lại một lần, lùi nhịp khi INVALID_CLIENT). Còn lại: hạn mức lấy token 10/60s/IP của M12
  (`OpsCoreTokenCache.java:31`) chia chung cho mọi tiến trình M3 cùng IP (replica, công cụ khác).
- R4 (M12 chậm/hỏng): đặt đơn 24/7 trả 503 `OPS_CORE_UNAVAILABLE` và KHÔNG ghi đơn (đặt hàng ngừng khi M12 sập, nếu enforce bật); xuất vận đơn trả 409
  `SHIPMENT_STOCK_GATE_BLOCKED` cả khi hạ tầng lỗi; Giờ Vàng 503; hiển thị chuyển UNKNOWN_BLOCKED sau `projection.max-age` 10 phút (`OPS_CORE_VERDICT_STALE`,
  `OpsCoreDisplaySource.java:79-82`). Không có chế độ "mở khi M12 lỗi", không breaker; một request tốn tối đa `commit.max-total` 7s. Đề xuất: bản chạy thử/15/11 để `gate.enforce=false`.
- R5 (bẫy cấu hình, im lặng ở mức API): `enforce` bật mà thiếu NK-c thì mọi đặt chỗ Giờ Vàng 409; `enabled` bật mà thiếu link thì mọi SKU chặn bán;
  `base-url` dạng `http` mà thiếu `allow-plain-http` thì client không tạo, mọi điểm chốt 503 (chỉ log tên khoá).
- R6 (đồng hồ, hạ tầng): M3 chỉ ghi WARN lệch giờ; NTP/HTTPS của `.60` chưa xác nhận (`BP-W0` dòng 102).
- R7 (độ trễ thu hồi khoảng 5 phút do poll) và R8 (lớp 1 của Tài `OPS_CORE_RECALL_STOP_SKU_BEFORE_PICKUP` "chưa có trên nhánh này", runbook dòng 23; đã vào dev chưa: CHƯA XÁC MINH).
- R9 (định danh): `sourceObjectId` UUID của allocation M12 so với id `BIGINT` đơn M3 (`M3-WMS-ORD-OD-02`, `PENDING_OWNER_APPROVAL` theo bản 28/08).
  Chặn NK-b nếu M12 hiện vẫn đòi UUID (cần scout M12 xác nhận).

## 6. Ước lượng thô theo số tệp và người làm

| Gói | Tệp mới | Tệp sửa | Phụ thuộc | Người/phiên hợp lý |
|---|---|---|---|---|
| WP-1 Bật quan sát trên `.60` (G1 + G2 + G3 + G9; không code Java) | 2 (script nạp link, runbook) | 6–7 (`compose.yml`, `env.mau`, 3 test deploy, `lam-moi-ton-thu.sh`, README) + làm tươi tới 13 JSON | thông số M12 thật; Lead duyệt compose | Lead (m12 hoặc m34 trên `toandeptrai`): Lead đang giữ M3-071/M3-100 (máy `.60`) và là người cấp thông số |
| WP-2 Kiểm hợp đồng + nâng ghim (G8) | 0–3 test | 1 gitlink | scout M12 xác nhận phản hồi | Lead; Phúc rà |
| WP-3 NK-b giữ/nhả/commit 24/7 (G4) | khoảng 14–20 (adapter + parser 2, cổng 2–3, dịch vụ 2–3, repo/entity 1–2, migration 1, job đối soát 1, cấu hình 1–2, test 6–8) | 6–8 (`OrderCreateServiceImpl`, `OrderStateMachineImpl`, `ShipmentServiceImpl`, `OpsCoreConfigRules`, `OpsCoreClientConfig`, `application.yml`, test sẵn có) | UUID đơn (OD-02/03), hợp đồng allocation, WP-1 | M3-111 ghi "Phúc, Toàn"; Phúc không có commit tuần 02/11. Gợi ý: Lead làm trên `toandeptrai` (quen khuôn client, biết API M12), Phúc rà; hoặc nhờ Nguyen Duc Manh (tác giả NK-a) nếu còn tham gia |
| WP-4 NK-c Giờ Vàng (G5) | khoảng 6–10 | 3–4 | WP-3 (dùng chung adapter) | cùng người WP-3 |
| WP-5 Đọc hàng loạt: opening-gate, lifecycle, danh mục (G6) | khoảng 6–10 | 2–3 | hợp đồng M12 (`stock-balances`, `skus`) | sau 15/11; Lead hoặc Phúc |
| WP-6 Nhận sự kiện (G7) | khoảng 6–8 + 1 migration | 2–3 | chốt chuyển tải (OD-11) với M12 | Lead; chỉ khi muốn thay poll 5 phút |
| WP-7 Cảnh báo log + câu chữ FE (G10) | 1–2 | FE 2–4 | Lead/chủ duyệt câu chữ | Phúc (FE), Lead (cảnh báo) |

Ghi chú: số tệp là ước theo khuôn NK-a (đếm tên chứa `OpsCore` bằng `git ls-tree`: 51 tệp trong `back-end/src/main/java`, 25 tệp trong `back-end/src/test/java`, chưa tính migration và tài nguyên test), không phải cam kết.
Với mốc 15/11 (bản tối thiểu; `BP-W` giữ xác nhận tay 24 giờ và kiểm kho bằng tay): chỉ WP-1 và (tuỳ chọn) WP-2 có thể kịp; NK-b/NK-c M3 đã dời tới 27/11.
Nếu chỉ cần "M3 gọi M12 để kiểm tồn" thì mã đã có; việc là cấu hình, dữ liệu link, và chạy thử, không cần mã mới.

## 7. CHƯA XÁC MINH

- Phản hồi hiện tại của M12 `/v1/availability/check` có khớp khung/trường M3 đòi (G9) hay không: chỉ có bản chụp 17/10 trong test M3; chưa đối chiếu với M12 `main` (thuộc scout M12).
- Đường mạng `.60` tới `192.168.1.61:5000` / Host `api-ops.ginsengfood.vn`: không tài liệu BP nào nêu; chưa thử (cấm ssh).
- Hành vi header `Host` của JDK `HttpClient` (G3): suy từ hiểu biết, chưa chạy.
- Vị trí tệp đặc tả T-831, T-832, gói "PKG", "E2 v1.2", "script 11 ca", ý nghĩa mã "C36": không thấy trong repo BP (đã `git grep` trong `docs`, `contracts`, `tools`, `back-end`).
- Trạng thái hiện tại của OD-01..OD-11 (decision log WMS-order, bản 28/08) và các TODO chờ chief: OD-8 (`SellableGateCommitCheckServiceImpl.java:62`), OD-10 (`OpsCoreVerdictMapper.java:102`),
  OD-11 (dòng 127), OD-12 (`OpsCoreRecallStopWriter.java:86`), OD-22 (`OpsCoreSellableVerdictPoller.java:275`).
- Lớp 1 của Tài (`OPS_CORE_RECALL_STOP_SKU_BEFORE_PICKUP`) đã vào dev chưa.
- Máy `.60` đang chạy bản BP nào, ops-core bật hay tắt: chỉ có tài liệu `deploy/m34` và bằng chứng M3-112 ngày 09/11 ("ops-core tắt"); không kiểm máy.
- `origin/main` cục bộ của repo hợp đồng (`a7832a49f`) có phải mới nhất so với remote: không `fetch`.
- Ý định của Phúc/Tài về M12 ngoài những gì có trong tracking tuần: không thấy; Sheet (`sheet.json`) không đọc theo luật an toàn.
- Hành vi hiển thị khi `enabled` bật, `enforce` tắt (chế độ quan sát) với SKU thiếu link: chưa đọc hết `OpsCoreDisplaySource` và `SellableGateAdminServiceImpl` (tệp 341 lần khớp từ khoá); không kết luận.

## 8. Lệnh và nguồn đã dùng (để tái kiểm)

- `git -C C:\Projects\ginsengfood-business-platform rev-parse HEAD origin/dev toandeptrai`; `git ls-tree b15c6b0f1 ginsengfood-contracts`.
- `git grep -n -i -E 'ops-core|opscore|OPS_CORE|operational.?core|M12' b15c6b0f1 -- back-end contracts deploy tools .github ... ':!**/sheet.json' ':!**/.env*'`.
- `git show b15c6b0f1:<tệp>` cho từng tệp được trích ở trên (đều kèm `':!**/sheet.json'`).
- Trong repo hợp đồng cục bộ: `git cat-file -t`, `git merge-base --is-ancestor`, `git rev-list --count a3b4bbf..origin/main`, `git diff --stat a3b4bbf origin/main -- openapi/ops-core`.
- Trong ops-core: `git grep` route `/v1/*` (chỉ tên route, nhánh `main` hiện tại).
- Không chạy build, test, ssh, fetch, pull; không để lại tiến trình.
