# Tin nháp gửi Tài · rà M6 05/11/2026 (chưa gửi)

> **ĐÃ GỘP 05/11 20:05 vào `2026-11-05-tai-tin-nhan-gop.md`. Không gửi bản này.**

Tài ơi, anh rà xong 15 task M6 ở `5af5d35` (Sheet đọc 13:52). Kết quả đã ghi cột Lead duyệt + Ghi chú Lead trên Sheet.

**Đạt (5):** M6-007, M6-023, M6-041, M6-061, M6-071. M6-007 đủ điều kiện duyệt PR #15. Phần L1 của M6-023 tốt, chạy lại khớp đỏ/xanh.

**Cần sửa (10)**, chi tiết từng việc trong Ghi chú Lead:
- M6-024: dọn hai phát hiện quét mới ngoài L1 (`tests/http/test_m9_ads_spend_approved.py:39`, `tests/http/test_routes.py:129`), gửi thư xin soát vào `M6\trao đổi\từ dev\`, sửa WT-007/tiêu chí 8/ĐK9; lệnh tiêu chí 6 thêm `M6_ENVIRONMENT=dev`.
- M6-037: test sigterm đỏ chập chờn (`test_worker.py:373`, thêm SO_REUSEADDR), chạy 5 lượt Linux 0 failed.
- M6-038: đổi cổng Postgres trong RUNBOOK 2.2 (đang trùng 6601 của worker), chạy lại trên master, ghi số đủ bộ 0 failed vào WT.
- M6-042: làm chế độ proxy/JWT sau khi chốt DL-O09 với anh Tuấn (hạn 06/11); thống nhất mã 401/403 với TC-ADM-001/002; TRK-57.
- M6-043: thêm `requested_by` cho scale request (TRK-65); test PG thiếu `account_timezone` em đã sửa ở M6-136, anh rà ở lượt sau.
- M6-044: mã đạt, nhưng PR #51 gộp squash. Ghi vi phạm vào WT, giữ nhánh gốc; gắn mỗi khoá máy với một principal trước khi cấp cho M3/M5/M7.
- M6-045: sửa TRK-66 (rate limit đang chung một bucket sau Docker), giới hạn kích thước body, sửa regex PII (40 KB mất 4,9 s), chốt DL-O11 (quá hạn 04/11).
- M6-062: có chi phí mà chưa có doanh thu verified thì ROAS phải null kèm lý do, không phải 0.0 (DL-052); viết test đỏ trước; chốt việc `M6_TIMEZONE` sang M6-063 và sửa hai thẻ.
- M6-102: ghi DL dời tiêu chí "dry-run chạy trong CI" sang M6-101 (CI đang tắt giai đoạn dev); sửa TRK-62 (biến shell thắng tệp env, dòng `export` lọt cổng cờ) trước staging.
- M6-134: lập thẻ + outcome; báo anh Mạnh giữ nguồn chi phí M9 ở stub tới khi xong TRK-54/67 và chống nhập trùng DL-071; compose thêm `M6_M9_SERVICE_TOKEN`.

**Còn treo từ 03/11:** M6-110, 111, 112, 116 vẫn Cần sửa (đang làm).

**Nhắc chung:**
1. Không gộp squash: #49, #50, #51 đều squash, trái OWN-293. Em tắt tuỳ chọn squash trong cài đặt repo cho chắc.
2. Lập thẻ cho TRK-54 (admin nối store), TRK-65, TRK-66, DL-071 (chống nhập trùng chi phí) và giới hạn body track. Đừng gắn route track trước khi xong mấy việc này.
3. `deploy/compose.json` chưa truyền khoá M9 và khoá HMAC kênh server, lên máy chủ sẽ luôn 401.
4. Máy chạy M6 là .60 (D-m6-004). Sửa SPRINT_PLAN:202/326, M6-103 và DL-O27, hiện còn ghi .63.
5. Sổ: `docs/weekly-tracking/nguyen-phat-tai.md` dừng ở 03/11 15:23; `06-tracking` vẫn v1.8; Sheet M6-038/042/071 còn Chờ review/nhánh cũ dù đã gộp; WT-056/057 trùng nhãn.
6. Mỗi lần gộp chạy đủ pytest có Postgres (`M6_PG_TEST_REQUIRED=1`, host `localhost`). Lượt của anh: 2218 passed, 2 failed.

Năm task em đóng sau 13:52 (M6-051, 052, 063, 135, 136) anh rà ở lượt tới.
