# Tin nhắn nháp cho Tài — rà task M5 03/11/2026

Người nhận: Tài (người phụ trách cả 36 task). Chưa gửi; bạn gửi khi đồng ý.
Bản rà: `modules/m5/ra-soat/2026-11-03-tai.md`. Đã áp D-m5-006/007/008 (bạn trả "theo đề xuất" 13:47).
**Cũ một phần (04/11):** sau mốc rà Tài gộp PR #44–#48 (có #47 sửa M5-060) và cập nhật Sheet 8 task (001, 022, 023, 031, 037,
050, 060, 070); mục M5-060 và "Dọn Sheet" có thể đã xong. Làm mới cùng lượt rà 5 task (m5.13) trước khi gửi.

---

Tài ơi, anh rà lại toàn bộ 36 task M5 đang Hoàn thành/Chờ review trên main `3d410ff` (PR #43), có test lại độc lập.
Kết quả: **32 Đạt, 4 Cần sửa** (002, 007 thiếu bằng chứng cũng tính Cần sửa). PR #29–#43 đều có test đỏ trước, 15 đột biến anh thử đều bị bắt. Tốt lắm.

**Mới đạt:** 034, 035, 041, 062, 080, và 040, 082 (bản sửa đã gộp, kiểm trên main). 17 task nền cũ vẫn giữ nguyên hành vi.
**M5-061**: anh chấp nhận DL-184, chuyển tiêu chí RBAC sang M5-016 → Đạt. M5-016 hạn 05/11 phải cho CLI cờ dừng lấy actor
đã xác thực, bỏ `--actor` tự khai; em ghi thêm vào DL-184 là anh chấp nhận ngày 03/11.

**Cần sửa:**
- **M5-060**: C-1 đã khép, corpus 722 ca không lọt. Nhưng anh thử 50 địa chỉ giả mới thì lọt 5, cùng lớp tên phố chứa từ đo
  ("10 phạm văn đồng, cầu giấy", "15 hàng chuối, hai bà trưng", "5 đồng khởi, quận 1", "9 mã mây, hoàn kiếm", "19 ba tháng hai, quận 10").
  Anh không chấp nhận tạm tới pilot (DL-124): em thêm các ca này vào corpus rồi sửa, hoặc mở task riêng có hạn trước khi có
  dữ liệu khách thật. Sửa luôn TRK-22.
- **M5-101**: 4 trang nháp ổn về khung. Anh chốt đăng 3 trang trên **GitHub Pages** (DL-072), không mở thêm đường ngoài nginx .60.
  Tên pháp nhân và người đại diện (P01, P03) anh gửi sau. Còn 23 chỗ trống P01–P23 (có P05 nhà cung cấp AI), chưa có URL công khai.
  Sửa 2 câu: `privacy-policy.md:70` "xoá tự động" (job xoá đang tắt, chỉ xoá bản thô và khoá) và `tester-consent.md:40`
  "xoá toàn bộ dữ liệu thử" (giờ chỉ còn một môi trường trên .60). `data-deletion.md:44` đánh dấu phần xoá ở M4 là chờ.

**Cần sửa vì thiếu bằng chứng:**
- **M5-002**: 11 ô "Tài xác nhận" ở `WORK_TRACKING.md` mục 3 vẫn trống. Em tự điền từng ô; cập nhật dòng quyền Page/Meta và dòng
  staging/production theo quyết định chạy trên .60.
- **M5-007**: lỗi lượt trước em sửa đủ rồi; anh đang duyệt toàn văn §5.

**Trước pilot (không chặn task):** M5-062 cho production từ chối kho đếm trong bộ nhớ và chốt chuyện bên gọi tự khai `CONSULT_REPLY`;
M5-016 (hạn 05/11) cấp quyền đọc metric và bỏ `--actor` tự khai; M5-081 nối kênh AL-07 và đặt hạn chờ cho cảnh báo.

**Dọn Sheet/tài liệu:**
- Cột Commit còn "chưa commit" ở 022, 023, 031, 037; 050 ghi `c108909`, đúng là `c798b48`; 070 ghi `568f2ec`, đúng là `b57778c`/`80c8d92`.
- 030 cột Kết quả cần đạt còn "fixture thật", sửa theo DL-183. 001 đã Đạt, em chuyển sang Hoàn thành.
- Còn ghi staging .63: kế hoạch (thẻ M5-090, M5-004, §6), DL-162/O52, hợp đồng M4 mục M4-7. Chữ "chưa gộp" còn ở DL-181, DL-185, runbook.
- 040 thêm cụm "thang cu" (không dấu) và "bạn nhỏ"; 041 sửa docs còn tả chuỗi mã (BRD, TRK-62, BL-04, G-13).
- `npm test` toàn bộ trên máy anh có 2 probe quá hạn khi máy tải (probe-verdict quá 120 s, main-process); em đo lại trên máy dev.

**Ghi vào `docs/00-overview/DECISION_LOG.md`** (em tự ghi):
- DL-184, cột ghi chú: "03/11/2026: anh Toàn chấp nhận chuyển tiêu chí RBAC sang M5-016 (rà Lead 03/11, main 3d410ff)."
- Dòng DL mới cho M5-101: "Ba trang chính sách, điều khoản, hướng dẫn xoá dữ liệu đăng trên GitHub Pages (DL-072), không mở đường
  ngoài trên nginx .60; tên pháp nhân/người đại diện chờ anh Toàn. Người quyết: anh Toàn, 03/11/2026."

Chi tiết từng task anh ghi ở cột Ghi chú trên Sheet.
