
## 7. Cập nhật 06/11 trưa: bản đổi số `df1f82e6c`

| Hạng mục | Kết quả |
|---|---|
| Thay đổi so với `b89b1d6e7` | Chỉ đổi tên ba migration thành V308, V309, V310 và tham chiếu trong 4 lớp test; SQL không đổi |
| Ghép thử với `dev` mới nhất `0c7df0c85` | Không xung đột; thang migration liền V306 → V307 (M3/M8) → V308–V310 |
| Bộ test M9 trên bản ghép, thứ tự lớp đảo, thêm `M6AdSpendClientTest` và 3 lớp CI hay đỏ | 62 lớp, 428 ca, 1 đỏ (`RbacDataSeederTest`, đỏ sẵn trên `dev`), 1 bỏ qua. `CarrierShipmentConcurrencyTest`, `GuestOrderLookup…`, `CollaboratorRealE2e…` đều đạt |
| CI GitHub của `df1f82e6c` | Vẫn đúng 9 lớp như trước: 6 đỏ sẵn, 3 lớp còn lại chạy ở máy em đạt nên không chặn |

Lưu ý:
- DB nào đã chạy bản PR cũ (V307 là chỉ mục M9), ví dụ `stg_m9` hay máy anh, sẽ không khởi động được với bản mới vì V307 giờ là tệp M3/M8 khác nội dung. Dựng lại các DB đó. Máy local chạy `mvn clean` trước, kẻo thư mục build còn sót tệp V307 cũ (em gặp đúng lỗi này).
- `docs/m9/HOP_DONG_M9.md` mục 5 và mục 10 vẫn ghi chỉ mục V307, cột cảnh báo V308; sửa trong PR sửa 2.
- PR sửa 2 không giữ chỗ trước V311–V314; số chốt lúc gộp, vì Phúc hoặc em có thể lấy V311 trước.
- Tin anh gửi còn trống chỗ kết quả test (`__KET_QUA__`) và câu P2.1 bị cụt sau "đã hỏi kế toán".
