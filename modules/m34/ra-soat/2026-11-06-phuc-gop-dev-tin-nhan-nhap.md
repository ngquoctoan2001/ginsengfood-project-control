# Tin nháp gửi Phúc — gộp toandeptrai vào dev (06/11/2026) · CHƯA GỬI

Người nhận: Trương Công Phúc. Toàn xem, sửa rồi tự gửi. Quyết định: D-m34-041.

---

Phúc ơi, sáng nay anh đã gộp `dev` mới nhất (`1446b1524`) vào `toandeptrai` rồi đẩy thẳng lên `dev`, giờ `dev` đang ở `0c7df0c85`.
Lần này anh không đi qua PR vì cần `dev` có ngay phần M3 → M8 để chạy máy .60, mấy lần sau anh vẫn đi PR như cũ.

Em pull `dev` về giúp anh nhé. Có mấy chỗ em để ý:

1. **Migration:** migration sửa đơn của anh đổi từ V265 sang **V307**, theo đúng luật M3 đánh số từ V300 như em ghi ở `1446b1524`.
   Lần sau em thêm migration mới thì lấy từ **V308**.
2. **`front-end/Dockerfile`:** chỗ xung đột duy nhất. Anh giữ cả hai bên: ARG của anh và 2 cờ `NEXT_PUBLIC_DESIGN_PREVIEW`, `NEXT_PUBLIC_DESIGN_PREVIEW_RUNTIME` của em.
   Trên máy .60 anh để 2 cờ này rỗng (tắt) trong `deploy/m34/build-args.60.json`. Nếu muốn bật chế độ xem thiết kế trên .60 thì em báo anh.
3. **Test đỏ có sẵn trên `dev` (không do lần gộp):** em xem giúp anh khi rảnh.
   - `RbacDataSeederTest.catalog_matchesCanonicalFlowPermissionCodes`: catalog có thêm `GOVERNANCE.APPROVAL.VIEW` (V300) nhưng danh sách mong đợi trong test chưa có.
   - `tsc` báo 3 lỗi trong `front-end/src/test/finance/finance-acceptance-dashboard.test.tsx` (thiếu kiểu `vite/client`, `import.meta.glob`). Tệp này thuộc phần M9 (nhánh `feat/m9-finance`), em chuyển giúp người làm M9.

Máy chạy thử .60 ở `http://192.168.1.60/` (cổng 80). Anh sẽ đưa bản `dev` mới lên đó sau khi CI build xong image.
