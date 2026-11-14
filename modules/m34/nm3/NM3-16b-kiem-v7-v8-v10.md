# NM3-16b (Sheet M3-125) — kiểm phía M3: V7, V8, V10 · 11/11/2026 15:10

Nguồn: đọc mã BP `toandeptrai` = `b15c6b0f1` + sổ m34. **Chưa chạy gì mới trên .60/.61**; không có test hành vi mới (xem "CHƯA CHẠY").

## V7 — .60 đang chạy bản BP nào, ops-core bật hay tắt
- `.60` chạy image CI `276e2f951` (be + fe, từ GHCR) từ LEN60 10/11 17:42; `origin/dev` hiện `b15c6b0f1` (có thêm 5 commit Phúc `57cb1d2fa`, V331, chưa lên .60).
- Cờ trong **env container `be` đang chạy**: `OPS_CORE_ENABLED=false`. Bằng chứng: `50-kiem-sau-60.sh` (danh sách 16 cờ đối tác có `OPS_CORE_ENABLED`) chạy lại 11/11 06:10, rc=0, "16/16 tắt". Compose chỉ truyền `OPS_CORE_ENABLED` (`deploy/m34/compose.yml:181`); các biến `OPS_CORE_*` khác không có trong compose nên lấy mặc định `application.yml:204-242` (`gate.enforce=false`, `poll.interval=PT4M`).
- Kết luận V7: tắt hẳn, chưa client, chưa poller (không tạo bean khi `enabled=false`). Mã ops-core (V254 và các lớp `opscore`) đã có trong `276e2f951`, không cần lên bản mới để bật quan sát.

## V8 — hành vi khi `ENABLED=true`, `GATE_ENFORCE=false` (chế độ quan sát)
Đọc mã; không đổi gì cho khách đặt hàng/hiển thị:
- Hiển thị/cổng bán: phần ops-core chỉ dùng khi `enforce` (`SellableGateAdminServiceImpl.java:483` `opsCoreEnforced() ? snapshot() : null`; `:670`). Bean cổng chốt đơn `SellableGateCommitCheckServiceImpl` chỉ tồn tại khi `gate.enforce=true` (`@ConditionalOnProperty`, dòng 55). Các điểm chốt khác đọc `gate.enforce` rồi bỏ qua khi tắt (`OrderCreateServiceImpl:363`, `CachedOrderCreateService:69`, `AdminShipmentDeliveryStockCheck:59`, `GoldenHourSessionServiceImpl:155`...).
- Poller (`OpsCoreSellableVerdictPoller`) chạy khi `enabled`, **chỉ quét link dùng được** (`findUsableLinks`): SKU không có link (kể cả SKU demo `DEMO/P3/SALE/BASELINE`) không bị gọi M12. Mỗi SKU có link: gọi `/v1/availability/check`, ghi bản chiếu vào `sellable_gate_ops_core_verdicts`; chỉ khi `enforce` mới phát `publishAvailability`.
- **Không hoàn toàn thụ động ở thu hồi:** khi M12 trả `recall_case_open=true`, `OpsCoreRecallStopWriter.apply` (poller gọi cả khi quan sát) ghi `recall_stop_active=true`, log WARN `OPS_CORE_RECALL_STOP_OPENED`, và `OrderRecallStopNotifier` (layer 2) ghi log ERROR `OPS_CORE_RECALL_STOP_ORDER_NOT_SHIPPED` cho đơn chưa xuất kho. Không đổi trạng thái đơn/SKU trong catalog; trạng thái dừng chỉ có hiệu lực bán khi `enforce`. Vì vậy trong quan sát phải có người đọc log/ghi nhận các dòng này (runbook `docs/.../ops-core-recall-stop/ops-core-recall-stop-runbook.md`).
- Cấu hình sai không làm `be` chết: `OpsCoreConfigRules` chỉ ghi log ERROR `OPS_CORE_CONFIG_INVALID` rồi không tạo client/job (`OpsCoreConfigValidator.java:34-38`). Dùng `http://` mà thiếu `OPS_CORE_ALLOW_PLAIN_HTTP=true` ⇒ `base-url` không hợp lệ ⇒ client không lên (đúng chỗ NM3-13 phải bật).
- Profile `production` + quan sát ⇒ ERROR `OPS_CORE_OBSERVATION_MODE_IN_PRODUCTION` (chỉ log). .60 chạy profile `demo` ⇒ không dính.
- Poll 60 s hợp lệ với luật `poll.interval + round-margin ≤ max-interval` (60 s + 20 s ≤ 5 phút).

## V10 — lớp 1 thu hồi của Tài (`OPS_CORE_RECALL_STOP_SKU_BEFORE_PICKUP`, "C36", OD-01..11)
- **Chưa có trong `dev`/`toandeptrai` (`b15c6b0f1`):** không có chuỗi này trong `back-end/src/main`/`resources`; runbook `ops-core-recall-stop-runbook.md:23` ghi "lớp 1 của Tài, chưa có trên nhánh này". Lớp 2 (`OrderRecallStopNotifier`) và mốc 2 (`ShipmentRecallStopNotifier`) đã có.
- Còn mở (cần Tài): lớp 1 nằm ở nhánh/PR nào, hạn vào `dev`; OD-01..11 là danh sách điểm treo nào (mình chưa tìm thấy tệp "OD-01..11" trong repo BP; `OD-02` nhắc ở kế hoạch ops-core §4.4 và `OD-12` trong `OpsCoreRecallStopWriter.java:100`).

## CHƯA CHẠY
- Không có test hành vi mới cho V8 (kết luận dựa trên đọc mã); không đọc DB .60 (cần Toàn duyệt) nên chưa xác nhận bảng link rỗng và 19 mã SKU trong `sku_master_codes`.
- Chưa kiểm V7 bằng lệnh mới sau 06:10 11/11.
