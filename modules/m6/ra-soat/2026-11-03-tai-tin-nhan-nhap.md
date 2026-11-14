# Tin nhắn nháp cho Tài — rà M6 ngày 03/11/2026

Chưa gửi. Gộp hai lượt rà: lượt 1 ghi Sheet ~15:30, đọc lại 21/21 (`modules/m6/ra-soat/2026-11-03-tai.md`);
lượt 2 ghi 15:59, đọc lại 5/5 (`modules/m6/ra-soat/2026-11-03-tai-b.md`).

## Cho Tài (M6)

Tài ơi, anh đã rà 19 task M6 của em ở `master 460e2d2` và ghi kết quả lên Sheet, cột "Lead duyệt" và "Ghi chú Lead".
Anh chạy lại toàn bộ test trên Linux Python 3.12 + Postgres 16 (bắt buộc DB): 1552 passed, 0 skip. Docs 0 lỗi, trace PASS.
Từ nay rà xong chỉ có **Đạt** hoặc **Cần sửa**. Task Đạt anh không rà lại.

- **Đạt (14):** M6-010, 011, 012, 013, 016, 020, 021, 022, 030, 031, 032, 050, 070, 080.
  Ba lỗi lượt 02/11 (bộ quét miễn regex, float tiền, outbox alias) đã hết. Phần "Nên/Việc tiếp" trong ghi chú từng task không chặn task.
- **Cần sửa (5):**
  - **M6-007:** anh đã duyệt nội dung PR #15 (D-m6-006), gồm PM AI đẩy/gộp và PM cấp số WT/DL/TRK theo DL-060. Em đổi "PM Codex" thành "phiên PM" (từ 03/11 PM M6 là Claude CLI), ghi gọn ô phiên bản 1.5 và dòng Hiệu lực, thêm dòng lịch sử ghi duyệt dẫn D-m6-006, rồi gộp PR và sửa ô nhánh/commit trên Sheet.
  - **M6-110:** O15, O57, O56, O46, O59 còn OPEN, múi giờ tài khoản Meta chưa xác nhận. Ghi 5 dòng DL (người chốt, lý do, cách kiểm); câu chưa chốt ghi BLOCKED-DEC; dựng CSV giả lập nếu chưa có bản xuất thật.
  - **M6-111:** gửi bản hỏi anh Tuấn và Phúc. Trong lúc chờ, ghi BLOCKED-DEC kèm mặc định chặn (admin từ chối, `/api/ads/conversions` không gắn route, track từ chối ORDER_VERIFIED) và test chặn; lập danh sách người giữ vai.
  - **M6-112:** điền hợp đồng v0 nguyên văn từ code M3 (dùng 24 khoá ORDER_VERIFIED trong fixture M6-050, ghi SHA M3 đã đọc), hỏi luôn định dạng 4 trường thời gian; gửi Phúc. Chưa có trả lời thì ghi BLOCKED-DEC: registry `BLOCKED_DEFAULT`, doanh thu null kèm `REVENUE_SOURCE_UNAVAILABLE`.
  - **M6-116:** gửi phiếu hỏi Sếp cho anh để anh chuyển (Sếp cần trả lời trước 06/11); ghi BLOCKED-DEC từng dòng với mặc định của thẻ.
  - Bốn task quyết định 110–116 chưa gửi gì thì để Đang làm, đừng để Chờ review.
- **Cần làm sớm (không làm lại task Đạt):**
  - Phần down của 0017 luôn từ chối khi đã có `m6.schema_migrations` và không gỡ dòng 0017 khỏi sổ: sửa trước M6-102.
  - `python -m app.migrate --dir` sai hoặc rỗng đang thoát 0; ghi DL quy ước sha256 sau CRLF→LF.
  - M6-040/060: parse số tiền JSON/CSV thành Decimal (float `1234567.89` đang bị TOO_MANY_PLACES); không gắn route conversions/track trước M6-044/045.
  - FR-IDN-001: track chưa chặn khoá `psid`, từ chối psid thô chưa ghi audit, chưa có thẻ nào phủ — em mở thẻ.
  - PR #14 (M6-015) thêm tệp miễn lịch sử cho bộ quét: anh sẽ rà theo FR-SEC-009/DL-016.
  - Sổ: ô commit trên Sheet M6-012/032/050 còn "chưa commit"; WT-023/028/030/032 chưa cập nhật sau khi gộp.

**Lượt 2 (15:40, `master ca78c61`):** anh rà thêm 5 task em đóng chiều nay. Chạy lại trên Linux Python 3.12 + Postgres 16: 1628 passed, 0 skip.

- **Đạt (2):** M6-035 (store Postgres), M6-040 (FastAPI, health, log).
- **Cần sửa (3):**
  - **M6-023:** đỏ/xanh tái hiện được, nhưng thẻ đòi lưu cả hai đầu ra (đỏ trên `7fab009`, xanh trên L1) vào repo: em lưu lệnh, SHA, phiên bản Python, danh sách ca, exit, dẫn từ WT-031 và WORK_TRACKING mục 4 dòng 1; sửa TEST_STRATEGY:374, :874.
  - **M6-024:** chép thư vào `M6\trao đổi\từ dev\<ngày>\`, sửa dòng 24 (`393e307` đã gộp ở `165fd5a`), gửi anh trước 05/11; sửa đường dẫn `check_c7_c10.py` (TRK-51) rồi lưu đầu ra so `8632607`; tiêu chí 7 quét bí mật còn FAIL (86 phát hiện): dọn, hoặc chờ anh chốt phạm vi ở buổi soát, không tự miễn.
  - **M6-037:** nhịp tim chưa tới `/health/ready` nào (`heartbeats` không ai đọc, worker không có cổng health theo api-catalog 4.3): thêm `/health/ready` cho worker, 503 khi job trễ quá 2 nhịp, test HTTP; thêm test SIGTERM → 0; đặt `connect_timeout` cho DSN worker (DB chết đang treo 135 s).
- **Cần làm sớm:**
  - T3: thiếu `M6_DB_DSN` ở staging/production phải từ chối khởi động, hiện API lặng lẽ chạy bộ nhớ (ready 200 `not_used`). Làm trước M6-041/M6-100.
  - Log của worker phải là JSON theo SAD 10.1 (FR-OBS-001). Lỗi 500 ở API nên ghi tên lớp exception.
  - Ghi điều kiện TRK-52 (route bọc unit, gọi `save` trong unit) vào thẻ M6-054 và M6-081; `due_items` nên có LIMIT lô.
  - Hai email giả ở `tests/http/test_health.py:252,272` làm bộ quét thêm 2 EMAIL: sinh lúc chạy như các test khác.
  - Sửa TRK-47 (test quét chập chờn) trước khi bật CI; PR #24–#29 chưa có check nào.
  - Sổ: WT-033/034 còn số test cũ và "CHỜ RÀ ĐỘC LẬP"; "rà độc lập" nên có biên bản, không chỉ ở mô tả PR.

Sửa xong task nào thì cập nhật Sheet bằng `sheet-sync log`, lượt rà sau anh rà lại đúng task đó.

## Cho bạn (task của bạn, không gửi ai)

- **M6-001, M6-008: Đạt** — J giữ Hoàn thành, H = Đã xong. M6-001 có câu ghi chú cũ "Tài xác nhận nhận bàn giao (WT-002)" không đúng (WT-002 chưa xác nhận); khối Ghi chú Lead mới đã nêu rõ.
- **lead.50:** bạn đã duyệt 03/11 15:35 (D-m6-006); Ghi chú Lead M6-007 trên Sheet đã nối khối bổ sung, đọc lại khớp.
- Lượt 2 đã rà M6-023, 024, 035, 037, 040 (Tài đóng sau 14:54): 2 Đạt, 3 Cần sửa.
- Khi Tài gửi phiếu M6-116, bạn chuyển Sếp.
- Soát L1 ngày 05/11 (M6-025): soát theo từng merge `fbd0f24`, `15a7a24`, `65392e0`, `d7fe04e` (`git diff <m>^1 <m>`), không soát gộp
  `c7e56d1..d7fe04e` (lẫn 5 PR ngoài L1). Bạn chốt lead.51 (phạm vi tiêu chí 7, chỗ gắn tag) và ghi kết quả vào WT-007, TRK-28.
  Điều kiện 6 (kiểm đường build) chờ bạn ở đầu M6-105 ngày 06/11.
