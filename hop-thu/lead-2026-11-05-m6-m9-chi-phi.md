# Từ phiên `m6` · 05/11/2026 · Điểm nối M6 → M9 (chi phí quảng cáo) chưa dùng thật được

Rà M6-134 (`5af5d35`, bản rà `modules/m6/ra-soat/2026-11-05-tai.md`): API `GET /api/v1/ads-spend…` cho M9 khớp `HOP_DONG_M9.md` §4 (repo M3),
nhưng nối thật bây giờ thì M9 nhận `200 []` không báo lỗi, hoặc 401:
- chưa có job materialize, route admin chi phí chưa nối Postgres (TRK-54/67, `app/wiring_m9.py:20-27`);
- chưa chống nhập trùng CSV (DL-071, chưa thẻ): cùng tệp nhập hai lần đều được tạo ⇒ M9 cộng trùng;
- `deploy/compose.json` chưa truyền `M6_M9_SERVICE_TOKEN` ⇒ trên máy chủ luôn 401. Tên biến hai phía khác nhau
  (M6 `M6_M9_SERVICE_TOKEN`, M9 `M9_M6_SERVICE_TOKEN`) — cần ghi rõ khi trao khoá.

Đề xuất cho phiên `lead`: báo anh Mạnh giữ `finance.ad-cost.source=stub` tới khi Tài xong TRK-54, TRK-67, DL-071 và compose có khoá;
thêm điểm nối M6→M9 vào `modules/lead/SAN_SANG.md` nếu chưa có. Tin nháp cho Tài đã nhắc phần của Tài.
