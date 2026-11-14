# M9 — phản hồi PR #149 (bản đổi số) và PR #150

Người rà: Nguyễn Quốc Toàn · 06/11/2026
- PR #149 `df1f82e6c`, PR #150 `4e284edc6` (sau đó thêm `01d255cf1`: chỉ tệp chụp OpenAPI và test của nó).
- Cách rà: ghép thử từng PR với `dev` mới nhất; chạy bộ test M9 có DB (thứ tự lớp đảo, `clean` trước); thử đột biến; đọc diff #149 → #150 (146 tệp). Cả hai PR ghép sạch với `dev 4f8a49bd0`.

## 1. Kết luận

Cả hai PR **gộp được**, gộp #149 trước rồi #150. Không có lỗi P0, P1 mới. Hai việc ở mục 3 anh làm trước khi bật M9 cho kế toán dùng, không chặn việc gộp.

Từ giờ anh không cần chờ em rà từng PR. PR M9 nào đạt đủ điều kiện ở mục 4 thì anh tự gộp. Em rà gộp một lần trước nghiệm thu 09/11.

## 2. Đã kiểm

| Hạng mục | Kết quả |
|---|---|
| #149 ghép `dev` | 62 lớp, 428 ca, 1 đỏ sẵn trên `dev` (`RbacDataSeederTest`), 1 bỏ qua. Ba lớp CI hay đỏ (`CarrierShipmentConcurrencyTest`, `GuestOrderLookup…`, `CollaboratorRealE2e…`) chạy máy em đều đạt |
| #150 ghép `dev` | 81 lớp, 582 ca, 575 đạt, 3 đỏ sẵn trên `dev` (`RbacDataSeederTest`, `SkuTwoState…`, thang số migration chỉ báo lỗ cũ, không trùng số), 4 bỏ qua. FE tài chính 78/78 |
| Đột biến #150 | Huỷ bảng kê, CTV tạm ngưng, người duyệt khác người soát thuế, `Idempotency-Key`, thứ tự khoá «Đã chi», đơn tự giới thiệu → `DIRECT`: bỏ từng chỗ thì đều có test đỏ |
| Đọc mã #150 | Huỷ bảng kê, soát thuế, thứ tự khoá ở các lệnh tay, chặn `TRUNCATE`, nhật ký, các mục theo phản hồi #149 đều đúng. Endpoint mới đều kiểm quyền, chỉ trả mã CTV, không có tên, SĐT, số tài khoản |

## 3. Làm trước khi bật cho kế toán dùng

1. **Hai màn mới chưa có trong menu.** «Nhật ký thao tác» (`/admin/finance/audit`) và «Ứng viên hoa hồng» (`/admin/finance/candidates`) chưa có ở `adminNavigation.ts`, kế toán phải gõ tay đường dẫn.
2. **Bước soát thuế đang khoá cứng việc duyệt.** `V313` chưa gán quyền `FINANCE.PAYOUT_TAX_REVIEW` cho vai trò nào, và `finance.payout.tax-review.require-different-preparer` mặc định `true`. Nếu công ty chỉ có một kế toán vừa lập vừa soát thuế thì không bảng kê nào duyệt được. Công ty có hai kế toán nên **giữ mặc định `true`**. Ai lập bảng kê, ai soát thuế anh chốt với kế toán và chú Dũng, rồi gán `FINANCE.PAYOUT_TAX_REVIEW` theo đó khi triển khai.

## 4. Điều kiện anh tự gộp PR M9

- Bộ test M9 có DB xanh trên bản ghép với `dev` mới nhất, chạy sau `mvn clean`. Được phép đỏ đúng các lớp đã đỏ sẵn trên `dev`.
- Migration lấy số kế tiếp trên `dev` lúc gộp, không sửa migration đã commit.
- Phần mã M3 (order, report, collaborator) có Phúc review.
- Ca test mới chạy đỏ trước khi sửa (anh đang làm đúng cách này).
- Mô tả PR ghi đủ tệp ngoài `finance`.

Câu trả lời của kế toán về ngưỡng thuế (P2.1) anh tự áp vào mã và ghi vào `HOP_DONG_M9.md`, không cần gửi lại em. P3.8 em không gặp lại nữa thì bỏ.

## 5. Gợi ý, làm khi tiện, không chặn

1. DB nào đã chạy bản #149 cũ (V307 là chỉ mục M9), như `stg_m9` hay máy anh, phải dựng lại vì V307 giờ là tệp M3/M8. Máy local chạy `mvn clean`, không thì thư mục build còn sót tệp V307 cũ.
2. `HOP_DONG_M9.md`: mục 5 và mục 10 vẫn ghi chỉ mục V307 và cột cảnh báo V308. Hợp đồng chưa có `/commission-candidates`. Dòng 451, 734 ghi quyền soát thuế ở V312, thực tế ở V313.
3. Test còn hở: chưa có ca DB chạy «Đã chi» cùng lúc với lượt kéo trên cùng bảng kê (ca 20 lần hiện chỉ thử duyệt + lượt kéo); ràng buộc người duyệt khác người soát thuế mới có test ở tầng unit.
4. Lượt kéo còn kẽ khoá ngược: đọc khoản không khoá trước (`FinanceCommissionIntakeService.java:167,252`), nếu khoản vừa vào bảng kê và có người huỷ cùng lúc thì có thể khoá chết. Cửa sổ rất hẹp.
5. `SYNC_SCHEDULED` ghi mỗi 15 phút kể cả lượt không làm gì, khoảng 96 dòng/ngày, che các thao tác tay ở màn nhật ký. Chỉ ghi khi lượt có thay đổi, hoặc cho bộ lọc loại trừ.
6. Hoa hồng của CTV tự nghỉ bị bỏ qua trước PR này (`COLLABORATOR_INACTIVE`) không được xét lại. Chỉ ảnh hưởng DB thử.
7. M3 còn chỗ đổi `payment_status` chưa xoá đệm: `CodReconciliationServiceImpl.java:137,239`, `OrderStateMachineImpl.java:150,177,407`, `GoldenHourPaymentOrderPortImpl.java:41,56`.
8. `FinanceCandidateServiceImpl.java:69`: `page * size` có thể tràn số khi `page` rất lớn; màn nhật ký đã chặn, màn ứng viên chưa.
9. OpenAPI khai `Idempotency-Key` dài tối đa 128, mã và DB nhận 160.

## 6. Tới 09/11

Còn lại theo lịch: MISA (xuất tệp đúng mẫu, kế toán nhập thử thành công một kỳ), ngân hàng (xuất lệnh chuyển tiền, nhập sao kê, khớp), đối soát với trang doanh thu M3, sổ TNCN, thu hồi, KPI năm, `06-tracking`. Nghiệm thu 09/11 chạy song song với cách tính tay của kế toán.

## Giải thích từ

| Từ | Nghĩa |
|---|---|
| gộp (merge) | đưa mã của PR vào nhánh chung `dev` |
| migration | tệp tạo hoặc sửa bảng dữ liệu, đánh số V…; hai tệp cùng số thì ứng dụng không chạy |
| đột biến | cố ý bỏ một chỗ sửa để xem test có phát hiện không |
| soát thuế | bước kế toán kiểm phần thuế TNCN của bảng kê trước khi chú duyệt |
| khoá chết | hai việc chạy cùng lúc chờ nhau mãi; Postgres huỷ một bên, phải chạy lại |
| đệm | bản lưu tạm số liệu 10 phút cho trang chạy nhanh |
