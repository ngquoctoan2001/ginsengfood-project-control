# Cổng Nguy hiểm — m8 (D-lead-064)

Vùng Nguy hiểm của M8 = **gọi khách thật** (tiền cước, quấy rối, dữ liệu cá nhân). Gói chạm vùng này được gộp như gói Thường rồi ghi vào đây.
Cổng chạy một lần cho mỗi vùng, dự kiến 25–27/11 (đệm 28–29/11), **trước khi bật cờ thật** (`REAL_CUSTOMER_CALL_ALLOWED` vẫn NO):
một verifier đọc trạng thái cuối `git diff <mốc cũ>..HEAD -- <vùng>`, ≤ 2 giờ, một vòng, ≤ 5 đột biến (giữ `@dot-bien`, nhắm đúng dòng quan trọng), Lead duyệt diff trước khi bật.
Mốc cũ: `da306952` (bản đang chạy trên .99, MOCK).

## Vùng 1 — Lịch gọi và claim của job chế độ luật

Đường dẫn: `src/Ivr.Infrastructure/Scheduling/**`, `src/Ivr.Infrastructure/CallRules/**`, `src/Ivr.Domain/CallRules/**`.
Gói: W-0552 (bộ máy luật), W-0553 (dữ liệu luật), W-0554 (lịch gọi dùng bộ máy luật), W-0556 (claim kiểm lại, commit `f3a13a41`, `a94c1dc7`). Gói sau cùng vùng: L-05 (intake chế độ luật), L-07 (gọi lại thủ công).

| Điều phải đúng | Chỗ đọc | Đột biến gợi ý (chọn ≤ 5) |
| --- | --- | --- |
| Không quay ngoài khung giờ luật; `[từ, đến)`, giờ Việt Nam, qua nửa đêm, `days` | `PostgresSchedulerStore.cs` (câu claim), `CallRuleClaimGate.EvaluateTime` | đổi `<` thành `<=` ở cuối khung; bỏ lọc thứ |
| Không quay sau mốc dừng của phiên (đúng mốc vẫn được gọi) | claim, `CloseMissedDeadlinesAsync`, `SessionLimit` | `<=` thành `<`; bỏ truyền mốc phiên ở **gương ước lượng năng lực** (`SchedulerCapacity.cs` ~dòng 556; VX-23 phải đỏ, phần gương kích hoạt đơn giữ đã thử: đỏ) |
| Hai đơn cùng số không vượt trần cuộc/số/ngày dù đến hạn cùng lúc | khoá `pg_advisory_xact_lock` + `PhoneCallsForClaimSql` trong `PostgresCallRuleJobStore.cs` | bỏ khoá; bỏ nhánh cuộc đã cấp chưa quay; đếm lại thành nhiều câu (VX-03, VX-04 đỏ ở bản kiểm vòng 1) |
| Trần cuộc/đơn/ngày không lệch một | claim + `CountOtherOrderCallsOnDayAsync` | `>=` thành `>` |
| Job v4 (chính sách cũ) không đổi | câu claim, quét hết hạn | không đột biến; so từng ký tự với `da306952` |

Đã có bằng chứng: verifier R3 vòng 1 (W-0554: 36 đột biến; W-0556: 46 đột biến, 43 đỏ), vòng 2 đọc nốt W-0556 ĐẠT (16 đột biến, 14 đỏ + 2 tương đương). Chưa có: bộ đủ (CI đêm), đua trên 8 claim, hiệu năng VM thật, chi phí câu claim khi nhiều job đến hạn trong khung (ngoại suy), mức cô lập `READ COMMITTED` chưa có test ghim.

## Vùng 2 — Quay số thật, cước, đích gọi (đã có, chưa vào cổng)

Gói: W-0550 (chỉ quay di động VN, trần 120 s/cuộc, trần lượt/giây theo ngày và `QUEUE_PAUSE`), W-0551 (đo cước). Đường dẫn: bộ lọc đích, `DispatchGate`, `AsteriskSchedulerDispatchGateway`. Đột biến gợi ý: bỏ kiểm đầu số `+84[35789]`, bỏ trần 120 s, bỏ `ADMIN_QUEUE_PAUSE` khỏi claim.

## Cách thêm vào

Gói mới chạm vùng nào thì thêm một dòng "Gói, commit, điều phải đúng" vào đúng vùng; vùng mới thì thêm mục mới. Không chạy đột biến ở từng gói.
