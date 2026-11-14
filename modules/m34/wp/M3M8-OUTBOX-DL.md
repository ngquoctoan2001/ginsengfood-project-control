# M3M8-OUTBOX-DL — sự kiện IVR của đơn không tới module khác (outbox `DEAD_LETTER`)

Trạng thái: R3 ĐẠT, commit `896227694` (chưa push) · Rủi ro: R3 (sự kiện đơn xác nhận/huỷ sang module khác) · Chế độ: worktree tách rời `C:\Projects\_wt\m34\outbox-dl` (detached `3c9993b36`)
· Mốc: B (hạn 07/11, D-m34-030) · Ước lượng 0,5–1 ngày · Sheet: tạo cuối sóng (con của M3-023) · Phụ thuộc: — · Tệp nóng: migration (nếu cần dùng **V268**)

## Brief
1. **Mục tiêu.** Lab `6e798cfa` 05/11: cả 74 sự kiện `ORDER_CONFIRMED`/`ORDER_CANCELLED` từ IVR nằm `DEAD_LETTER` trong `order_ivr_business_event_outbox`,
   `last_error`/mã `CANONICAL_EVENT_PERSIST_FAILED`, attempts 12; registry `event_packages` không có dòng `M3_IVR`. Lỗi bị nuốt không log trong
   `OrderIvrBusinessEventDispatchService.dispatchOne`. Tìm nguyên nhân gốc bằng bằng chứng (test đỏ tái hiện), sửa để sự kiện ghi được vào kho sự kiện
   chuẩn, thêm log lỗi có mã + id sự kiện (không in payload/PII), và cho bộ đối soát thấy được (đề xuất, không bắt buộc sửa harness).
2. **Tiêu chí đạt.** (a) Test đỏ trước tái hiện đúng `CANONICAL_EVENT_PERSIST_FAILED` (Postgres/Testcontainers hoặc DB bản sao), xanh sau sửa;
   (b) sự kiện IVR → `PUBLISHED`/đã ghi kho chuẩn, idempotent (gửi lại không nhân đôi); (c) lỗi kho chuẩn → log WARN/ERROR một dòng có `eventId`, `eventType`,
   mã lỗi, lớp ngoại lệ, không payload; (d) `DEAD_LETTER` cũ có đường xử lý lại an toàn hoặc ghi rõ runbook (không tự sửa DB lab); (e) ArchUnit + test order/ivr liên quan xanh;
   (f) ghi rõ lab 03–04/11 (thư mục `*-archived`, dump) có cùng hiện tượng không, nếu đọc được từ bằng chứng sẵn có.
3. **Phạm vi ghi.** Chỉ worktree `C:\Projects\_wt\m34\outbox-dl` (back-end `order/`, `ivr/`, sự kiện chuẩn nếu đúng gốc ở đó, test) + ghi chép `C:\Projects\_wt\m34\outbox-dl-notes\`.
   Migration mới nếu bắt buộc: `V268__…` (V265 của U13, V266/V267 giữ cho Phúc).
4. **Cấm.** Không commit/push; không ghi DB lab đang chạy (`wp09-*-6e798cfa`, Lead đang UAT) — chỉ `pg_dump` đọc rồi khôi phục vào container riêng tên `outbox-dl-pg`;
   không sửa migration đã có (V001…V264); không chạm checkout chính, `u13-retry`, `may-60`; không gọi đối tác; không in bí mật.
5. **Lệnh.** `cd back-end && JAVA_TOOL_OPTIONS=-XX:MaxRAMPercentage=40 ./mvnw -B -q -Dtest=<lớp> test` (Lead cho chạy test, m34.5); Testcontainers được nếu RAM trống ≥ 4 GiB
   (kiểm trước mỗi lần, lab + UAT đang chạy); không build cả repo song song với agent khác quá 1 lần.
6. **Bằng chứng.** `outbox-dl-notes/ket-qua.md`: nguyên nhân (file:dòng), test đỏ→xanh (lệnh + số), diff tóm tắt, đột biến thử (≥ 2), rủi ro còn lại.
7. **Dừng khi.** Gốc nằm ở module/contract khác (ops-core, `ginsengfood-contracts`) hoặc cần đổi hợp đồng sự kiện → dừng, báo phiên chính.
8. **Báo về** ≤ 20 dòng: nguyên nhân, sửa gì, test, đột biến, có migration không, CHƯA CHẠY gì.

## Diễn biến
- 05/11 12:4x tạo worktree `outbox-dl` (`3c9993b36`, sạch), giao coder (D-m34-030).
- 05/11 14:3x coder xong (`outbox-dl-notes/ket-qua.md`): gốc = `CanonicalEventPublishCommand` thiếu `orderId` → `CanonicalEventPublisherAdapter.java:52` gửi null → `JdbcEventAuditLogService.java:198-200` 422 'orderId is required' cho mọi `ORDER_*` → rollback `event_packages`, `dispatchOne` nuốt lỗi; test cũ xanh vì `realPublisher()` không gắn audit như production · sửa 6 tệp main + 3 test, không migration · đỏ trước 3/4, đột biến bỏ orderId tái hiện `CANONICAL_EVENT_PERSIST_FAILED`; xanh 110/110 + 51/51 (Postgres 6/6, lifecycle 40/40); 3/3 đột biến · lab `d2f06ecb` 81/81, `0a87a79d` 81/81, `5d10b0e6` 80/80 cùng lỗi · runbook requeue SQL mục 6 · CHƯA CHẠY: cả bộ test, OrderIvr*Postgres khác, khôi phục dump · giao tester độc lập R3
- 05/11 13:42 tester R3 bị ngắt khi phiên dừng (2 tệp `*IndependentTest` dở, worktree `kiem-outbox-goc`) · 14:0x giao tester làm tiếp
- 05/11 16:5x tester R3 xong (`outbox-dl-notes/tester.md`): tiêu chí 1–6 ĐẠT; gốc: unit 1/2 hỏng, Store 8/10 hỏng; bản sửa: 2/2, 10/10, hồi quy + ArchUnit 70/70; không lỗi; rủi ro: chữ trong `AppException` vào log (số ≥7 chữ số bị che), registry/policy giả trong ca runbook, `order_events.customer_id` NULL · CHƯA CHẠY: cả bộ test, OrderIvr*Postgres khác, đột biến của tester · giao verifier
- 05/11 17:5x verifier R3 ĐẠT: 6/6 tiêu chí; 140 test 17 lớp 0 hỏng (gồm Postgres 6, Store độc lập 10, lifecycle 40, P247 Postgres 24); 5/5 đột biến bắt; 4 nơi gọi khác giữ constructor 16 tham số (orderId null như cũ), không migration, không đổi contracts; log 1 dòng có eventId/eventType/orderId/attempt/mã/lớp, không payload · lưu ý: `outcome` trong log tính từ bộ nhớ (Dispatch.java:61); runbook đưa lại cả dòng lệch hash (thử thêm 12 lần vô ích); SQL runbook chép tay 3 chỗ · CHƯA CHẠY: `PolicyVersionResolver`/`EventRegistryRepository` thật (có thể còn lỗi thứ hai bị che), bản sửa + runbook trên bản sao DB lab · chờ Lead duyệt diff
- 05/11 18:xx Lead "ok 57, 58, 59" (D-m34-037): patch từ worktree `git apply --index` lên `toandeptrai` (tệp gói không khác giữa `3c9993b36` và `fcb3bcd9e`) · `sheet-sync log` tạo M3-104 Chờ review 90% · commit `896227694` (11 tệp + sổ tuần) · chưa push · worktree `outbox-dl` còn giữ
- 06/11 07:44 bản sửa lên .60 cùng `7fbdef0c3` (D-m34-040); ở .60 cờ IVR tắt nên chưa phát sinh sự kiện IVR — kiểm thật vẫn ở lab (m34.52)
