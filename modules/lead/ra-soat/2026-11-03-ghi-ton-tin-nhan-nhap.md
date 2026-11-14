# Tin nhắn nháp sau khi ghi kết quả rà tồn đọng lên Sheet — 03/11/2026

Chưa gửi. Sheet đã ghi 14:43, đọc lại khớp 33/33 (ghi Sheet bằng `tools/sheet_lead.mjs`, D-lead-020).
Kết quả lấy từ các bản rà đã có, không rà mới: `modules/m5/ra-soat/2026-11-03-tai.md` (13:45), `modules/m34/ra-soat/2026-11-03-phuc-m3.md` (13:40).
Tệp ghi: `modules/lead/ra-soat/evidence/2026-11-03-ghi-ton/ket-qua.json`.

## Cho Tài (M5)

Tài ơi, anh đã ghi kết quả rà M5 ngày 03/11 lên Sheet, cột "Lead duyệt" và "Ghi chú Lead".
Từ nay rà xong chỉ có **Đạt** hoặc **Cần sửa**. Task đã Đạt anh không rà lại nữa.

- **Đạt:** M5-034, 035, 040, 041, 061, 062, 080, 082. Phần "Còn:" trong ghi chú từng task là việc nhỏ, làm ở task được nêu.
- **Cần sửa:**
  - **M5-060:** lớp địa chỉ còn lọt 5/50 (tên phố có từ đo, vd "5 đồng khởi, quận 1"). Em thêm các ca này vào corpus rồi sửa, hoặc mở task có hạn trước khi có dữ liệu khách thật. Sửa thêm TRK-22.
  - **M5-101:** còn 23 chỗ trống P01–P23, chưa có URL công khai. Sửa `privacy-policy.md:70` và `tester-consent.md:40`, rồi đăng lên GitHub Pages (D-m5-007).
  - **M5-002:** 11/11 ô "Tài xác nhận" của WT-002 (WORK_TRACKING mục 3, dòng 69–79) còn trống. Em tự điền từng ô, cập nhật quyền Page/Meta và dòng staging/production theo D-m5-005.
  - **M5-007:** lỗi lượt 02/11 đã sửa ở PR39. Còn chờ anh duyệt toàn văn §5 và dòng WORK_TRACKING. Em để task ở trạng thái chờ, anh duyệt xong em cập nhật.

Sửa xong task nào thì cập nhật Sheet bằng `sheet-sync log`, lượt rà sau anh sẽ rà lại đúng task đó.
M6 chưa ghi lần này: 4 task đã rà ngày 02/11 nhưng em sửa sau giờ rà, nên lượt rà M6 tới anh sẽ rà lại.

## Cho Phúc (M3)

Phúc ơi, anh đã ghi kết quả rà M3 lúc 13:40 ngày 03/11 lên Sheet. Từ nay rà xong chỉ có **Đạt** hoặc **Cần sửa**.

- **M3-013** đổi từ Chưa duyệt sang **Cần sửa**. Em bổ sung:
  - câu SQL, truy vấn kiểm trước/sau, tên CSDL/máy;
  - đường dẫn và mã băm bản sao lưu, log khởi động;
  - kết quả `mvnw test`;
  - runbook có người soát cho các CSDL đã chạy V251 cũ, và cách xử lý V248 khi máy LAN tắt out-of-order.
- **M3-040, M3-043:** giữ **Cần sửa**. Mục cần sửa ở khối rà 10:50 vẫn còn. Dev chưa có commit gỡ hai task này: em gỡ qua PR.
- **M3-022, M3-061:** đã ở **Cần sửa** từ trước, ghi chú Sheet đầy đủ, không đổi.

Sửa xong thì cập nhật Sheet, lượt rà sau anh rà lại đúng task đó. Task Đạt rồi anh không rà lại.

## Cho bạn (task của bạn, không gửi ai)

Tệp ghi: `evidence/2026-11-03-ghi-ton/ket-qua-task-lead.json`. Kết quả lấy từ verifier/rà chéo độc lập đã có.
Phiên lead kiểm lại: các lần cập nhật Sheet sau giờ verifier đều do phiên của bạn ghi chốt task, và SHA trên Sheet khớp SHA verifier.
- **Đạt (17):** M3-027…033 (mã M3–M8 ở `8f72b4493`, chưa push); M7-002, 003, 005, 007, 008, 010, 011, 012, 182, 183.
  J giữ Hoàn thành, H = Đã xong.
- **Cần sửa (1):** M3-035, J chuyển Chờ review → Đang làm. Lỗi retry/replay/CALLING-terminate ngày 03/11; bản sửa m34.37 chưa commit; UAT chưa chạy.
- **Chờ bạn quyết:** M7-006, M7-026, M8-009 (lead.47–49).
- **Lượt rà tới:** M12-001 (có cập nhật sau lượt rà 02/11). Chưa có kiểm độc lập: M7-001, M6-001, M6-008.
