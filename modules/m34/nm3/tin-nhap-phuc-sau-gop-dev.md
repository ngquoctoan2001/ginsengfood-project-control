# Tin nháp gửi Phúc: sau khi gộp `dev` vào `toandeptrai` (12/11 ~22:00) — CHƯA GỬI

Gộp một tin, thay tin nháp cũ `tin-nhap-phuc-so-migration.md` (dải migration nằm trong đây). Giọng bạn bè, ngắn; Toàn đọc và gửi (hoặc dặn mình gửi).

---

Phúc ơi, Toàn gộp `dev` vào `toandeptrai` rồi chạy thử cả bộ, có vài thứ để bạn biết, cái nào bạn tiện thì xử, không gấp:

**1. Dải số migration.** Phía nối M12↔M3 đang dùng V340–V349 (V340 audit link, V342 sổ giữ hàng, V344 inbox webhook, V346 CHECK tồn ≥ 0, V347 khoá đơn vị, V348 audit master, V349 vòng đời SKU). Migration mới của bạn xin dùng số khác dải này (hoặc V350 trở lên). V332–V335 của bạn và của phiên M3→M8 xen kẽ bình thường, Flyway nạp sạch V1→V349 trên Postgres thật.

**2. Ba chỗ đỏ có sẵn ở `dev`, không phải do bên mình** (mình chạy trên cây đã gộp, đối chiếu từng dòng):
- `StandardPacksStrictChainPostgresTest` và `StandardPacksNonStrictChainPostgresTest`: sau commit `4035b3b45` (chuyển seed sang gói JSON) báo cáo nạp có thêm 3 gói `e2e-catalog`, `e2e-pricing`, `e2e-storefront-cart` mà `PACK_ORDER` trong `StandardPacksChainSupport.java:56` chỉ có 7 gói. Cách sửa gợi ý: lọc `SKIPPED_ENVIRONMENT` khỏi so sánh hoặc nới `PACK_ORDER`.
- `ModuleBoundaryArchitectureTest` 3 ca đỏ (số vi phạm 2/51/4, đúng mốc): `OldUrlTesterT1Test`/`OldUrlTesterT1PostgresTest`, `GoldenHourPaymentGateServiceImpl(Test)` (promotion gọi `order.domain.PaymentTransaction`), `SkuLifecycleAuditLogPostgresTest`/`SkuLifecycleRealEventPipelinePostgresTest` (catalog test chạm repo content). Tất cả có từ trước, không dòng nào của bên mình. Theo mình thấy cần tái chốt kho đóng băng một lần có duyệt hoặc sửa các lớp đó; bạn là người viết nên bạn quyết cách nào.

**3. `CanonicalSkuMasterDataSeeder` bị xoá** (seed sang JSON): bên mình có thêm vào đó một chốt "dừng nếu mã SKU đã có nhưng khác nghĩa" và test; khi gộp mình nhận việc xoá của bạn, chốt đó mất. 19 mã chuẩn do V116 tạo nên rủi ro thấp; nếu gói JSON có thể thêm kiểm "mã trùng mà khác nghĩa thì báo lỗi" (hiện `CatalogE2ePackJdbcRepository` chỉ `ON CONFLICT DO NOTHING`) thì tốt.

**4. Hai việc bên module `policy`/chung nhờ bạn khi tiện:**
- `AuditLogPort` chưa có tham số `requestId`/`correlationId`, nên audit kho đang nhét hai mã đó vào `after_json`; nếu thêm overload có hai mã thì mình sửa `InventoryAuditRecorder` một chỗ.
- Vài chỗ còn đọc `X-Forwarded-For` thô (`ApiErrorSupport`, `AuthController`, `AdminCustomerConsentController`, `AdminSkuMasterController`): IP nên lấy qua trusted-proxy như `getRemoteAddr()` với `SERVER_FORWARD_HEADERS_STRATEGY=native` (compose `deploy/m34` đã đặt).

**5. Seed trên .60/.61:** `deploy/m34/compose.yml` đặt cứng `SEED_DATA_PACKS_DIR=/app/seed-packs`; bật `SEED_ENABLED` giờ nạp cả chuỗi 7 gói. Mình đã ghi vào runbook cutover.

Cảm ơn bạn!
