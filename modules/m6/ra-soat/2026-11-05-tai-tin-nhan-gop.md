# Tin gửi Tài · rà M6 ngày 05/11/2026 · bản gộp lượt 1 + lượt 2 (CHƯA GỬI)

> Thay cho `2026-11-05-tai-tin-nhan-nhap.md` (lượt 1) và `2026-11-05-tai-b-tin-nhan-nhap.md` (lượt 2). Gửi đúng phần dưới vạch.

---

Tài ơi, hôm nay anh rà hai lượt, tổng 20 task M6. Lượt 1 ở `5af5d35`, lượt 2 ở master `4c75f88`. Kết quả đã ghi vào cột Lead duyệt và Ghi chú Lead trên Sheet.
Test anh chạy lại ở `4c75f88` (Python 3.12 + PG16, `M6_PG_TEST_REQUIRED=1`) cho 2317 passed, 0 failed.

**Đạt (5):** M6-007, 023, 041, 061, 071. M6-007 đủ điều kiện duyệt PR #15.
**Cần sửa (15):** 024, 037, 038, 042, 043, 044, 045, 062, 102, 134 (lượt 1); 051, 052, 063, 135, 136 (lượt 2).
**Còn treo từ 03/11:** M6-110, 111, 112, 116.

**1. Ưu tiên trước mốc A 07/11**
- M6-062 + M6-063 (cùng một lỗi): khi có chi phí mà chưa có doanh thu verified, ROAS đang ra 0.0 và Revenue ra 0, không kèm lý do (`kpi_metrics.py:20-24,40-42`, `data_mart.py:70-71`). Theo DL-052/DL-073 phải trả null kèm `REVENUE_SOURCE_UNAVAILABLE`. Viết test đỏ trước. Lỗi này nay nằm trên route PG thật. Cập nhật thêm api-catalog §3.3, SRS FR-KPI-003/FR-DQ-013, TRK-17.
- M6-024 (để gắn tag L1): dọn 2 phát hiện quét mới (`tests/http/test_m9_ads_spend_approved.py:39`, `tests/http/test_routes.py:129`); gửi thư xin soát vào `M6\trao đổi\từ dev\`; sửa WT-007, tiêu chí 8, ĐK9; lệnh tiêu chí 6 thêm `M6_ENVIRONMENT=dev`. Xong thì báo anh soát, rồi em gắn tag `m6-l1-done` ở `d7fe04e`.
- M6-045: sửa TRK-66 (rate limit đang dùng chung một bucket khi chạy sau Docker); thêm giới hạn kích thước body; sửa regex PII (40 KB mất 4,9 s); chốt DL-O11 (đã quá hạn 04/11).
- M6-052 (`90a6860`) và M6-135 (`47be8fd`): hai commit chưa lên GitHub nên anh chưa rà được. Em đẩy nhánh, mở PR, có biên bản rà độc lập rồi gộp. M6-135 cần test cho 3 ca: nhập trùng CSV; lô sửa thay lô cũ (cả dashboard và API M9); hai người duyệt song song. signalType của M6-052 theo T-2/T-3 ở mục 4.

**2. Cần sửa mã / cấu hình**
- M6-037: test sigterm đỏ chập chờn (`test_worker.py:373`, thêm SO_REUSEADDR). Chạy 5 lượt trên Linux phải ra 0 failed. Lượt 2 của anh vẫn gặp lỗi này 1/2 lần.
- M6-042: làm chế độ proxy/JWT sau khi chốt DL-O09 với anh Tuấn (hạn 06/11); thống nhất mã 401/403 với TC-ADM-001/002; TRK-57.
- M6-043: thêm `requested_by` cho scale request (TRK-65). Phần test PG thiếu `account_timezone` em sửa ở M6-136, anh đã kiểm, đạt.
- M6-102: ghi DL dời tiêu chí "dry-run chạy trong CI" sang M6-101 (CI đang tắt trong giai đoạn dev). Sửa TRK-62 trước staging: biến shell đang thắng tệp env, dòng `export` lọt qua cổng cờ.
- M6-134: lập thẻ + outcome; compose thêm `M6_M9_SERVICE_TOKEN`. Nguồn chi phí cho M9 giữ ở stub tới khi xong TRK-54/67 và chống nhập trùng DL-071 (anh báo anh Mạnh).

**3. Mã đạt, chỉ còn thiếu sổ sách**
- M6-038: đổi cổng Postgres trong RUNBOOK 2.2 (đang trùng cổng 6601 của worker); chạy lại trên master, ghi số đủ bộ 0 failed vào WT.
- M6-044: ghi vi phạm squash của PR #51 vào WT, giữ nhánh gốc. Trước khi cấp khoá máy cho M3/M5/M7, gắn mỗi khoá với một principal.
- M6-051: data-catalog §4.1 cho khớp schema 0020; bỏ `M6_REGISTRY_STATIC_PATH` khỏi env-reference (mã đang cố định đường tệp); cập nhật WT-058; thêm nhãn BLOCKED-DEC (DL-O18) trên Sheet; thẻ còn ghi 0019.
- M6-136: thêm thẻ trong SPRINT_PLAN và outcome trên Sheet; sửa TRACKING_REPORT:275-276 TRK-68/69 thành đã gộp; thêm biên bản rà độc lập.

**4. Anh đã chốt, em ghi DL giúp anh (người chốt: anh Toàn)**
- M6-039: duyệt cơ chế đọc 3 cờ từ biến môi trường, chỉ nhận BLOCKED/OFF/OFF, giá trị khác thì app không khởi động. Bắt buộc 2 test: "ON hoặc rỗng bị từ chối" và "không lane nào export tên cờ".
- DL-O25: tới 14/11 M6 chỉ nhận mã CH21 thử; mã khách thật để sau khi pháp chế duyệt (M6-117).
- Tag L1: gắn ở `d7fe04e`. Tiêu chí 7 chỉ xét `app/` và diff L1, phần `_archive`/`tools` để L0 (TRK-38). ĐK 4/5/9/10 hoãn sang L0. Em sửa thẻ M6-025 theo.
- M6-114: anh duyệt 6 câu dưới đây. Em ghi 6 dòng DL sau DL-078 và gỡ BLOCKED-DEC các câu đó. T-5, T-6, T-7, T-10 anh giữ tới 09/11; trong lúc chờ dùng mặc định: consent không khớp → không hợp lệ; không mở route nội bộ nào; mã `attr_` M6 chỉ là khoá nội bộ; giữ API riêng M6.
  - T-9: contracts chuẩn là `origin/main` ginsengfood-contracts; M6 ghim `a7832a4`. Docs còn dẫn `08585c1`/`54eb5f5` (api-catalog:390,440, SAD:1090, SOURCES:66), đổi sang `a7832a4`.
  - T-2: M3 giữ BLOCKED/ALLOWED. M6 map ở biên theo (policy, sensitivity): SENSITIVE → `BLOCKED_PII`; INTERNAL+BLOCKED → `INTERNAL_ONLY`; INTERNAL+ALLOWED → `ALLOW_EXTERNAL`; thiếu hoặc lạ → `BLOCKED_DEFAULT`. Gửi ngoài vẫn OFF. Kèm test 5 ca.
  - T-1: doanh thu M3→M6 chỉ đi qua `business-platform.ads.verified-revenue-created.v1`, phát ở checkpoint ORDER_VERIFIED, `idempotencyKey` = `ORDER_VERIFIED:<order_id>`, `status` `REVENUE_VERIFIED`. Chưa nối thì doanh thu/ROAS null + `REVENUE_SOURCE_UNAVAILABLE`. Công thức số tiền (VAT/ship/giảm giá) anh chốt với Phúc.
  - T-3: giữ `event-registry-feed.v1`, `GET /api/v1/internal/event-registry?since_version={n}`; `owner` = `owner_service`; `registration_state` suy từ `is_active`/`deprecated_at`. M3 dựng sau 15/11, tới đó M6 dùng registry tĩnh. Đóng DL-O60.
  - T-4: bỏ `ORDER_REVERSED`. Trừ lùi đi qua kênh T-1 với `status` `REVENUE_REVERSED`, `exclusion_reason` ∈ {`REFUND_SUCCEEDED`, `ORDER_VERIFICATION_REVOKED`}. Chưa rõ thì `REVENUE_REVERSAL_PENDING` và loại khỏi ROAS. Sửa DL-021.
  - T-8: chốt RULE-005 theo công thức code hiện có (`idempotency.py`, `enqueue.py`); `source_event_id` giữ nguyên chữ khoá của bên phát. Đóng DL-O38, TRK-25.
  - Chỗ lệch phía M5: tín hiệu M5 đang gửi `orderRef` = `orderCode` (`m6-signal-builder.ts:30`), trong khi M3 chỉ có `order_id`. Em cho M5 gửi kèm `order_id`.

**5. Nhắc chung**
1. Gộp PR: #49 tới #54 đều gộp squash, trái OWN-293 (`CLAUDE.md:85`). Em chọn một: ghi DL chấp nhận squash (sửa OWN-293), hoặc từ PR sau quay lại merge commit và tắt tuỳ chọn squash trong cài đặt repo. Không cần viết lại lịch sử.
2. Chỉ chuyển task trên Sheet khi commit đã lên GitHub (M6-052, 135 đang báo xong nhưng remote chưa có).
3. Lập thẻ cho TRK-54 (admin nối store), TRK-65, TRK-66, DL-071 (chống nhập trùng chi phí) và giới hạn body của track. Chưa xong mấy việc này thì chưa gắn route track.
4. `deploy/compose.json` chưa truyền khoá M9 và khoá HMAC kênh server, lên máy chủ sẽ luôn trả 401.
5. Máy chạy M6 là .60 (D-m6-004). SPRINT_PLAN:202/326, M6-103 và DL-O27 còn ghi .63, em sửa lại.
6. Sổ: `docs/weekly-tracking/nguyen-phat-tai.md` dừng ở 03/11 15:23; `06-tracking` vẫn v1.8; Sheet M6-038/042/071 còn trạng thái Chờ review hoặc nhánh cũ dù đã gộp; WT-056/057 trùng nhãn.
7. Mỗi lần gộp, chạy đủ pytest có Postgres (`M6_PG_TEST_REQUIRED=1`, host `localhost`).
8. Ghi vào hồ sơ Go/No-go: registry chưa có bản v1 và `PgEventRegistryReader` chưa nối runtime, nên bật nhận event thật lúc này thì mọi event đều bị từ chối. Chưa có worker DQ (M6-064), nên mọi dòng đang ở HOLD.

Xong việc nào em đưa về Chờ review, anh rà tiếp.
