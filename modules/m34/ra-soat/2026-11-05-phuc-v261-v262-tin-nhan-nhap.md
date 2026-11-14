# Tin nháp gửi Phúc — số migration V261/V262 trùng (05/11/2026) · CHƯA GỬI

Người nhận: Trương Công Phúc. Lead xem, sửa rồi tự gửi. Quyết định: D-m34-029 (`modules/m34/QUYET_DINH.md`).

---

Phúc ơi, anh kiểm nhánh `PhucApu` sáng nay. Có hai migration bị trùng số với `dev`, em sửa giúp anh trước khi gộp nhé.

**Anh thấy gì:**
- Commit `3cbf857de` ("save", 04/11 09:52) trên `PhucApu` thêm hai tệp:
  - `back-end/src/main/resources/db/migration/V261__brand_two_state_lifecycle.sql`
  - `back-end/src/main/resources/db/migration/V262__product_group_two_state_lifecycle.sql`
- `dev` đã có V260–V264 của phần gọi xác nhận đơn M3 → M8 (vào `dev` từ 04/11, `3c9993b36`), trong đó có
  `V261__m3_m8_producer_context_and_callback_review.sql` và `V262__m3_m8_lifecycle_watchdog_and_edit_guard.sql`.
- Gộp `PhucApu` với `dev` thì Flyway thấy hai tệp cùng số V261, hai tệp cùng số V262, nên BP không khởi động được.

**Em làm giúp anh:**
1. Đổi tên hai tệp của em thành `V266__brand_two_state_lifecycle.sql` và `V267__product_group_two_state_lifecycle.sql`.
   Số V265 anh giữ cho phần sửa đơn của M3 → M8. Nội dung tệp giữ nguyên, chỉ đổi số.
2. Trước khi đổi, em báo anh: hai tệp V261/V262 bản của em **đã chạy lên CSDL nào chưa** (CSDL máy em, máy LAN .60, CSDL dùng chung).
   Nếu đã chạy thì CSDL đó cần sửa `flyway_schema_history`. Mình làm bằng script có người soát, không sửa tay (như vụ M3-013).
3. Merge `dev` mới nhất vào `PhucApu`, chạy lại để kiểm thang số: `MigrationVersionLockContractTest`, và khởi động BP từ CSDL rỗng.
4. Đưa vào `dev` qua PR `PhucApu → dev` (D-m34-019), không đẩy thẳng.

Sau này trước khi tạo migration mới, em lấy số lớn nhất trên `origin/dev` rồi cộng 1, đồng thời nhắn anh để anh giữ số.
