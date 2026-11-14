# Tin nháp gửi Tài · rà lượt 2 M6 · 05/11/2026 (CHƯA GỬI)

> **ĐÃ GỘP 05/11 20:05 vào `2026-11-05-tai-tin-nhan-gop.md`. Không gửi bản này.**

Tài ơi, anh rà tiếp 5 task M6 ở master `4c75f88`. Toàn bộ test chạy lại Python 3.12 + PG16: 2317 passed, 0 failed. Phần mã chạy ổn.
Cả 5 task đều để **Cần sửa** trên Sheet, chi tiết ở cột Ghi chú Lead. Tóm tắt:

**Chưa lên GitHub nên anh chưa rà được**
- M6-052 (`90a6860`) và M6-135 (`47be8fd`): em đẩy nhánh, mở PR, có biên bản rà độc lập rồi gộp. M6-135 nhớ kèm test cho ba ca: nhập trùng CSV, lô sửa thay lô cũ (dashboard + API M9), hai người duyệt song song.

**Mã đạt, còn thiếu sổ sách**
- M6-051: data-catalog §4.1 cho khớp schema 0020; bỏ `M6_REGISTRY_STATIC_PATH` khỏi env-reference (mã đang cố định đường tệp); WT-058; nhãn BLOCKED-DEC (DL-O18) trên Sheet; thẻ còn ghi 0019.
- M6-136: thêm thẻ trong SPRINT_PLAN và outcome trên Sheet; TRACKING_REPORT:275-276 sửa TRK-68/69 thành đã gộp; thêm biên bản rà độc lập.

**Cần sửa mã**
- M6-063 (cùng lỗi M6-062): có chi phí mà không có doanh thu verified thì ROAS đang ra 0.0, Revenue 0, không kèm lý do (`kpi_metrics.py:20-24,40-42`, `data_mart.py:70-71`). Theo DL-052/DL-073 phải trả null kèm `REVENUE_SOURCE_UNAVAILABLE`. Lỗi này nay nằm trên route PG thật, em ưu tiên sửa trước. Cập nhật thêm api-catalog §3.3, SRS FR-KPI-003/FR-DQ-013, TRK-17.

**Gộp PR**
- PR #49 tới #54 đều gộp squash, trái OWN-293 (`CLAUDE.md:85`). Em chọn một: ghi DL chấp nhận squash (sửa OWN-293), hoặc từ PR sau quay lại merge commit. Không cần viết lại lịch sử.

**Anh đã chốt (em ghi DL giúp anh)**
- M6-039: duyệt cơ chế đọc 3 cờ từ biến, chỉ nhận BLOCKED/OFF/OFF, khác thì app không khởi động. Bắt buộc 2 test: "ON hoặc rỗng bị từ chối" và "không lane nào export tên cờ".
- DL-O25: tới 14/11 M6 chỉ nhận mã CH21 thử; mã khách thật để sau khi có pháp chế (M6-117).
- Tag `m6-l1-done`: gắn ở `d7fe04e`. Tiêu chí 7 chỉ xét `app/` và diff L1, phần `_archive` để L0, nhưng em dọn 2 phát hiện mới. ĐK 4/5/9/10 hoãn. Xong M6-024 thì báo anh soát rồi em gắn tag.
- M6-114: anh duyệt 6 câu dưới đây, em ghi 6 dòng DL sau DL-078 (người chốt: anh Toàn) và gỡ BLOCKED-DEC các câu đó. T-5, T-6, T-7, T-10 anh giữ tới 09/11, tạm dùng mặc định: consent không khớp → không hợp lệ; không mở route nội bộ nào; mã `attr_` M6 chỉ là khoá nội bộ; giữ API riêng M6.
  - T-9: contracts chuẩn là `origin/main` ginsengfood-contracts; M6 ghim `a7832a4`; docs còn dẫn `08585c1`/`54eb5f5` (api-catalog:390,440, SAD:1090, SOURCES:66) đổi sang `a7832a4`.
  - T-2: M3 giữ BLOCKED/ALLOWED; M6 map ở biên theo (policy, sensitivity): SENSITIVE → `BLOCKED_PII`; INTERNAL+BLOCKED → `INTERNAL_ONLY`; INTERNAL+ALLOWED → `ALLOW_EXTERNAL`; thiếu/lạ → `BLOCKED_DEFAULT`. Gửi ngoài vẫn OFF. Kèm test 5 ca.
  - T-1: doanh thu M3→M6 chỉ đi `business-platform.ads.verified-revenue-created.v1`, phát ở checkpoint ORDER_VERIFIED, `idempotencyKey` = `ORDER_VERIFIED:<order_id>`, `status` `REVENUE_VERIFIED`. Chưa nối thì doanh thu/ROAS null + `REVENUE_SOURCE_UNAVAILABLE`. Công thức số tiền (VAT/ship/giảm giá) anh chốt với Phúc.
  - T-3: giữ `event-registry-feed.v1`, `GET /api/v1/internal/event-registry?since_version={n}`; `owner` = `owner_service`; `registration_state` suy từ `is_active`/`deprecated_at`; M3 dựng sau 15/11, tới đó dùng registry tĩnh. Đóng DL-O60.
  - T-4: bỏ `ORDER_REVERSED`; trừ lùi đi kênh T-1 với `status` `REVENUE_REVERSED`, `exclusion_reason` ∈ {`REFUND_SUCCEEDED`, `ORDER_VERIFICATION_REVOKED`}; chưa rõ thì `REVENUE_REVERSAL_PENDING`, loại khỏi ROAS. Sửa DL-021.
  - T-8: chốt RULE-005 theo công thức code hiện có (`idempotency.py`, `enqueue.py`); `source_event_id` giữ nguyên chữ khoá của bên phát. Đóng DL-O38, TRK-25.
  - Chỗ lệch cần em xử lý phía M5: tín hiệu M5 gửi `orderRef` = `orderCode` (`m6-signal-builder.ts:30`) nhưng M3 chỉ có `order_id`; em cho M5 gửi kèm `order_id`. signalType cho M6-052 theo T-2/T-3.

Lưu ý cho hồ sơ Go/No-go: registry chưa có bản v1 và `PgEventRegistryReader` chưa nối runtime, nên bật nhận event thật lúc này thì mọi event đều bị từ chối. Thêm nữa, chưa có worker DQ (M6-064) nên mọi dòng đang HOLD.
Xong việc nào em đưa về Chờ review, anh rà tiếp.
