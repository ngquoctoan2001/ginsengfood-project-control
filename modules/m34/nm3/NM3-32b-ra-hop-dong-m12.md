# NM3-32b — rà hợp đồng M12 (nhánh `m12-noi-m3`) phía consumer M3 — 13/11/2026 (chỉ đọc)

Phạm vi: nền ghim M3 `a7832a49` (= `origin/main` của `ginsengfood-contracts`); nhánh có 10 commit (`af0a5bf`, `5b078ae`, `3fc2c18`, `64db84e`, `8110cfa`, `b22bb5d`, `6a270eb`, `1350e1d`, `360a076`, `e60df94`); `origin/m12-noi-m3` mới tới `5b078ae`, 8 commit sau chưa push. Chưa chạy: test node của hợp đồng, Maven của M3. Đã tính lại bằng Python: 4 vector UUIDv5 và HMAC vector công lập: KHỚP.

**Kết luận: không có điểm BREAKING-cho-M3 trong delta.** Mã reserve/release, webhook, UUIDv5, enum không cần đổi. Có nhiều điểm KHÔNG-ĐỦ-RÕ ở hợp đồng cần m12 chốt trước khi đóng băng.

## Việc M3 khi nâng ghim (NM3-34)
a. Đợi 8 commit được push, chốt SHA ghim thay `a7832a49`. b. NM3-15b: nhập `contract-tests/x03b/fixtures/allocation-*.fixture.json` (6 tệp) + `examples/api/x03b/inventory-allocations.issued.response.json`, thêm test list allocations với meta đầy đủ (hiện `OpsCoreReservationHttpAdapterTest.java:152-190` tự dựng thân rút gọn thiếu `allocation_no, item_id, lot_code, requested_at, resolved_at`). c. Bỏ `"DEFAULT"` của `warehouse_scope` ở fixture/test (`OpsCoreUnknownValueToleranceTest.java:68`; hợp đồng chỉ ALL|WAREHOUSE). d. `dong-bo-ton.py`: chờ 429 hiện ≤3 lần × ≤60 s, hợp đồng `ExternalBulkReadRetry` 2 lần/tổng 30 s: sửa khi m12 chốt. e. Đưa 55'/1000 thành cấu hình nếu m12 công bố số hạn mức. f. Xác nhận bằng văn bản với m12 điều kiện allowlist webhook (CHANGELOG `:17`; M3 dùng allowlist trường nên thoả).

## Điểm KHÔNG-ĐỦ-RÕ (hỏi m12 trước đóng băng; đã gửi 13/11)
1. Hạn mức provider cấu hình không nằm trên dây và không công bố số: cửa sổ giữ (M3 cứng 54:30 theo trần 55'), trần số lượng/dòng (M3 tự đặt 1000), số giữ chỗ/principal và tỉ lệ tồn: công bố số tối thiểu bảo đảm cho M3 hay không.
2. `recall_case_open` luôn có trong `/check`? Hợp đồng chỉ bắt buộc `sellable_status_id`; ví dụ/fixture của hợp đồng thiếu `recall_case_open`; M3 coi thiếu là `UNKNOWN_BLOCKED` ⇒ provider tuân hợp đồng mà bỏ trường này sẽ chặn mọi SKU.
3. `decision` của `/check`: M3 chỉ nhận SELLABLE/NOT_SELLABLE; `enums/ops/sellable-status.yaml:9-33` có 8 giá trị (BLOCKED_*, REVIEW_REQUIRED), `CHANGELOG.md:88` nói hai: chốt và sửa enum.
4. `x-retry-policy` reserve/release (`inventory.v1.yaml:88-92` `ExternalManualReplayOnly` max_retries 0) mâu thuẫn notes (gửi lại cùng khoá ≤5 lần).
5. Bảng `details[].reason` chỉ nằm trong lời văn (`inventory.v1.yaml:369,526-547`); `IDEMPOTENCY_KEY_REUSED` chỉ có trong test hợp đồng; schema reserve-error `details` là object tự do; release-error nói "chỉ trên 422": công bố bảng đóng và mã nào có `details`.
6. Principal M3 cần 3 audience (availability-v1, allocation-v1, bulk-read-v1) + quyền `INVENTORY_ALLOCATION_CREATE`/`INVENTORY_ALLOCATION_VIEW`; token request không có tham số audience/scope; mỗi môi trường một principal.
7. `service-auth.v1.yaml:37-38` ghi token "không được log hoặc cache" mà M3 phải cache (10 lần/phút/IP): cho phép cache; ghi quy tắc `X-Correlation-Id` (≤128, `[A-Za-z0-9:_.-]`) vào hợp đồng (hiện chỉ trong tài liệu webhook).
8. Khi nào WP07b phase A và SEC-12/13/14 của provider thật sự live (hợp đồng nói "NOT live": hôm nay tranh chấp tạm có thể vẫn là 409 INSUFFICIENT_STOCK và M3 ghi REFUSED cuối cùng dù kho còn hàng).
Nhỏ: `TooManyRequests` ghi `X-RateLimit-Limit` const 2 trong khi chính sách đọc là 5 rps (`inventory.v1.yaml:812` vs `:28-31`); body webhook có `eventType` sai mẫu M3 trả 400, hợp đồng nói loại không quan tâm thì 2xx (`OpsCoreWebhookEnvelope.java:73-75`, `webhook-security.md:81`); M3 từ chối `sellable_quantity` lẻ (`OpsCoreVerdictMapper.java:189`) trong khi hợp đồng cho 3 số lẻ.

## Rủi ro lớn nhất
Hạn mức do provider cấu hình biến mọi lần giữ hàng thành 422/409 nếu m12 đổi cấu hình hoặc principal chạm trần; M3 cứng 55'/1000 và fail-closed (khách thấy "Giao dich khach hang hien khong kha dung."; `CustomerTransactionUnavailableException`). Mỗi dòng đơn giữ 54:30 nên giữ chỗ tích tụ vào giờ cao điểm. Hiện giữ hàng TẮT (không ảnh hưởng quan sát).

## Khớp (không cần làm gì)
Allocation status (RESERVED/CONFIRMED/ISSUED/RELEASED; lạ → UNKNOWN; `EXPIRED` chỉ là trạng thái nội bộ M3, hết hạn trên dây đọc là RELEASED); `block_reasons` 11 token; `lifecycle_status` 8 giá trị; 13 loại sự kiện webhook (loại lạ → IGNORE 2xx); 409/422/429 và `HOLD_LIMIT_REACHED`/`HOLD_SHARE_LIMIT_REACHED`; `GET allocations` luôn kèm `sourceObjectId`; chữ ký webhook `v1=<hex>` + 64 KiB + 300 s + dedupe; token `POST /v1/service-tokens`; UUIDv5.
