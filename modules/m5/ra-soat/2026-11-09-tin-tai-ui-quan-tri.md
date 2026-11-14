# Tin nhắn nháp cho Tài — bàn giao UI quản trị M5 (09/11/2026)

Người nhận: Tài. Chưa gửi; bạn gửi khi đồng ý. Bản duyệt: `modules/m5/ra-soat/2026-11-09-ui-quan-tri-duyet-r3.md`.

---

Tài ơi, UI quản trị M5 anh làm xong rồi, đã lên `main` (`da306af`, fast-forward ngay trên #79 của em). Từ giờ em nhận phần này để triển khai và giữ tiếp nhé.

**Có gì**
- 17 API chỉ đọc mới ở `/api/admin/*` (EP-20…36): tổng quan, tư thế khởi động + cờ, app/Page/phiên live, webhook thô và chuẩn hoá, cách ly, hàng gửi, gửi lại + dead-letter,
  guard log, bằng chứng, CSKH (chuyển người, cảnh báo, tạm dừng), yêu cầu xoá dữ liệu, audit. Thêm 2 quyền `ADMIN_CONFIG_READ`, `ADMIN_AUDIT_READ` cho OPS và ADMIN.
- UI Next.js ở `web/`, phục vụ tại `/admin` ngay trong container M5. 9 màn + đăng nhập, chỉ đọc (form đăng ký Page/live dùng lại API cũ, ghi bộ nhớ tiến trình).
  Không có nút bật cờ, gửi tin hay subscribe.
- Không migration, không biến môi trường mới, không gói npm mới ở gốc. Dockerfile thêm stage dựng `web/`.
- Tài liệu: hợp đồng `docs/05-reference/admin-ui-api.md`, cách dựng/chạy/đăng nhập `docs/05-reference/admin-ui.md`.

**Đã kiểm**
Một bộ test viết riêng từ hợp đồng (641 ca, không đọc mã) xanh hết; mỗi phần qua 2 vòng kiểm độc lập, vòng đầu bắt được 2 chỗ lộ dữ liệu, đã sửa.
Trên bản ghép: CI_LOCAL build/probes/docs PASS (174/26/0), toàn bộ probe có DB trên Postgres/Redis tạm 200/0/0, `docker build` thật chạy được, `/admin` và 9 trang lên đúng.
Máy anh không có Postgres/Redis cài sẵn nên CI_LOCAL chỉ ghi 3/5; em chạy giúp bản đủ 5 job trên máy em ở `da306af` rồi dán kết quả vào PR/DL nhé.

**Em làm tiếp**
1. Pull `main`. Chỗ ghép với M5-064: `rbac.service.ts`/`rbac.types.ts` giữ cả `SUPPRESSION_LIST_SET` lẫn 2 quyền mới; `reason-codes.md` mục UI là 1.20, đầu tệp vẫn ghi 1.18, em đánh số lại khi tiện.
2. Ghi một dòng DL trong `DECISION_LOG.md` cho việc này (D-m5-024 phía anh: UI quản trị do anh làm, đẩy thẳng `main` có kiểm độc lập), em ký như các DL khác.
3. Lúc triển khai lên .60: cùng ảnh M5, không cần cấu hình thêm. Sau deploy mở `/admin/` và `/health/ready` là xong phần UI.
   Đăng nhập trên .60 (`RBAC_MODE=real`) cần JWT vai OPS/ADMIN do Anh Tuấn cấp, cùng khoá đang chặn M5-016, nên em gộp vào việc khoá JWT với Anh Tuấn luôn.
4. Chạy ở máy: app với `RBAC_MODE=dev-header` ở loopback, rồi `cd web && npm run dev`, mở `http://localhost:3100/admin/`, chọn "Chế độ dev".
5. Muốn đổi khuôn dữ liệu thì sửa hợp đồng trước, rồi chạy `test/http/admin-console*.probe.ts` (có bộ 641 ca), `rbac-real-matrix`, và trong `web/` `npm test` + `npm run build`
   (bước `check-out` chặn dữ liệu mẫu và `localStorage` lọt vào bản dựng).

Gợi ý nếu em có thời gian, không bắt buộc trước 15/11: thêm màn xem danh sách chặn tay của M5-064 (chỉ đọc) theo cùng cách che dữ liệu.
Task M5-137, M5-138 trên Sheet anh đã đóng; việc mới em mở task mới đứng tên em nhé.
