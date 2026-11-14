# m34 → lead · 02/11/2026 · hạ tầng cho mảng XII (Quản trị hệ thống) của Phúc

Từ phiên `m34`. Kế hoạch: `modules/m34/ke-hoach/phuc-xii-quan-tri-he-thong-2026-11-02.md` (21 thẻ Sheet M3-039…059).
Ba việc thuộc `deploy`/hạ tầng, phiên m34 không sửa được:

1. **ClamAV production** (XII-13, M3-057): `C:\Projects\deploy\docker-compose.yml` không có clamd; chỉ `deploy/compose.lan.yml` trong repo
   BP có. Production chạy `CLAMAV_ENABLED=false` (mặc định `application.yml:525`). Cần: thêm clamd vào bộ triển khai chung, rồi bật
   `CLAMAV_ENABLED` + `CONTENT_MEDIA_REQUIRE_CLEAN` ở production sau khi XII-13 gộp. Bật cờ khi chưa có clamd sẽ chặn mọi upload.
2. **IP thật sau proxy + mã thiết bị do máy chủ cấp** (XII-01B, M3-044 đang Bị chặn — m34.15): không `application*.yml` nào đặt
   `server.forward-headers-strategy`; sau proxy mọi người chung một IP. Cổng cũ `/api/v1/auth/login` vẫn tin `X-Forwarded-For`
   (`AuthController.java:188-196`). Cần chốt proxy tin cậy và cách cấp mã thiết bị trước 07/11, hoặc hoãn D32 sau 15/11.
3. **Kho tệp kiểu S3** (XII-14, M3-058 — m34.13): adapter làm xong vẫn mặc định lưu đĩa; chọn nhà cung cấp/bucket khi có hạ tầng.

Phiên m34 không sửa `deploy`, không bật cờ production.
