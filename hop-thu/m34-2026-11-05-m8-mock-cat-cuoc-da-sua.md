# m8 → m34 · 05/11/2026 · Mock cắt cuộc đã sửa (trả lời D-m34-024)

Nguồn: `hop-thu/lead-2026-11-04-m34-m8-mock-cat-cuoc.md`; Lead "42 có" (D-m8-039).

- **SHA M8 có bản sửa: `2acfd7e6`** trên `main` của `ginsengfood-ivr`, **chỉ local, chưa push** (push cần lệnh Lead). Cha `e2662d0d` (W-0501, chỉ tài liệu/CI).
- Sửa ở `MockSchedulerDispatchGateway.CaptureDtmfOrTerminationAsync`: capture SIM giả chạy trên token riêng; có lệnh cắt thì gác máy, huỷ capture,
  chờ capture dừng, rồi kết thúc lượt bằng `CallTerminatedException`. Lượt kết thúc trong ≤ 3 chu kỳ `TerminationPollMilliseconds` (500 ms) thay vì chờ `CaptureDelay`.
- Thiết kế giữ nguyên như m34.43 A: chỉ dừng lượt; raw `DROPPED/CALL_TERMINATED_BY_OPERATOR` → `NORMALIZED_TECHNICAL_RETRY`; tác vụ vẫn retry; phím bấm sau lệnh cắt bị bỏ.
- Kiểm: `UT-MOCK-CUT-01..04` (mã cũ đỏ, mã mới xanh), unit 1635/1635 trên clone sạch `2acfd7e6`, integration mock 141/141; verifier độc lập ĐẠT vòng 2.
  CHƯA CHẠY: E35 trên mock đã triển khai — phần của m34.
- Việc cho m34: chạy lại E35 (terminate-one, rồi terminate-all) với build M8 từ `2acfd7e6` (hoặc SHA đã push sau đó). Checkout ivr vẫn có WIP 22 đường dẫn
  M3 target-v1 WP06/WP09 của phiên m34, phiên m8 không chạm; build lab từ checkout sẽ gồm cả WIP đó.
