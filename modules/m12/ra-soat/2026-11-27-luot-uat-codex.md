# M1–M2 · Chạy lại ca bị chặn trên lab demo ngày 27/11/2026

Lượt này giữ khóa `@bo-kiem-du` và dùng một checkout `main` của ops-core tại `d4163331ce9804f625c81bc448a23a2298f757b4`. Hai sub-agent chỉ đọc catalog, mã và mẫu dữ liệu. Phiên UAT chạy lần lượt. Sổ đầu lượt có 2.326 ca: 2.225 Đạt, 0 Không đạt, 68 Không áp dụng và 33 Bị chặn. Danh sách vào lượt lấy từ mục 9 của biên bản Sheet ngày 26/11.

Postgres lab riêng chỉ mở loopback. Khôi phục 149 migration từ mẫu demo 22/10 rồi nâng lên 160 bằng gói có cùng cây migration. Volume có tên và container không tự xóa. Bản sao đầu lượt 22.960.367 byte nằm ngoài repo công khai, đã dùng để khôi phục lab. API trả 200. Các app web dùng bản sao tệp chạy được phép ngoài checkout, giữ mã đang có và không nạp tệp môi trường. Dữ liệu nguồn và môi trường .99 không bị ghi. Các vai demo cần dùng giữ nguyên. Thông tin đăng nhập tạm chỉ được tạo cho các dòng đã đối chiếu trong DB clone.

## L10 · B09-F06-T01, T02, T04

Tạo hai SKU demo riêng, cờ truy xuất công khai tắt, không đưa vào chạy mẻ. Form tạo công thức không giữ được tỷ lệ dòng cuối trong lần thử. Dùng API tạo bản nháp thường với đủ bốn nhóm để chuẩn bị đầu vào, rồi đúng vai Quản trị gửi phê duyệt cả hai trên UI. Sau khi xác nhận hai công thức Chờ phê duyệt, dùng fixture đã rà độc lập với đích DB clone được khóa theo tên chính xác. Fixture chỉ hủy hai đề nghị mới, ghi lịch sử hủy và giữ công thức Chờ phê duyệt như trạng thái lịch sử cần kiểm.

| Mã | Kết quả | Bằng chứng |
| --- | --- | --- |
| B09-F06-T02 | Đạt | Trên mẫu `UAT27F06-CL2711-01`, mở Phục hồi về nháp và để trống Lý do phục hồi. Nút Xác nhận phục hồi bất hoạt. |
| B09-F06-T01 | Đạt | Trên mẫu 01, điền lý do và xác nhận. UI báo Đã phục hồi công thức về nháp. Danh sách là Bản nháp, đề nghị cũ vẫn CANCELLED. |
| B09-F06-T04 | Đạt | Mẫu `UAT27F06-CL2711-02` còn Chờ phê duyệt sau khi nhập lý do. Bấm kép Xác nhận phục hồi rồi tải lại, chỉ còn một bản nháp. Nhật ký kiểm toán lúc 08:13 đúng mã đối tượng, người và lý do. Cơ sở dữ liệu xác nhận đúng một chuyển trạng thái và một sự kiện audit cho mỗi mẫu. |

## L16 · G03-F01-T04

- Chuẩn bị mẻ demo mới `BATCH-27112026-000001` qua chuỗi nghiệp vụ, bổ sung 25 lô nguyên liệu demo đã nhập/KCS/sẵn sàng. Mẻ có sự kiện sấy DONE, trạng thái `QC_PENDING`, không có tạm giữ thu hồi đang hoạt động. FRM-29 là `AUTO_GENERATED_DRAFT` và chưa ký.
- Vai KCS ghép thiết bị lab và nhận diện đúng mã qua PWA. Nhập 3 mẫu, thử Giữ lại ở 3,5% và Loại ở 4,5%. Cả hai lần, để trống hai ô lý do và ghi chú chung thì PWA nêu lỗi thiếu lý do. Nhập riêng lý do làm dòng lỗi biến mất. Xóa lý do làm lỗi trở lại. Khi trống lý do, nút Còn 2 mục cần làm bất hoạt.
- **Bị chặn, đã kiểm đối chứng cổng lý do.** Chrome không cho extension nạp ảnh demo từ đĩa. PWA còn thiếu ảnh độc lập, nên chưa chốt được bước chỉ còn thiếu lý do sau khi nạp ảnh. Không gửi lệnh hoặc ký phiếu. Mẻ và phiếu còn đúng trạng thái để kiểm tiếp.

- **Đạt sau khi chuyển sang trình duyệt tích hợp.** Ghép cùng vai KCS, cùng mẻ và dùng nút Chọn tệp để thêm đúng 1 ảnh minh họa. Cả Giữ lại (3,5%) và Loại (4,5%) chỉ còn đúng mục bắt buộc là lý do. Nút bị vô hiệu hóa khi lý do trống, mở Lưu và gửi khi điền lý do, rồi lại vô hiệu hóa khi xóa. Không bấm Lưu và gửi. Đối chiếu cuối ca mẻ vẫn `QC_PENDING`, FRM-29 nháp chưa ký, chưa sinh hồ sơ KCS sau sấy.

## L17 · H05-F04-T01

- Vai kho thành phẩm đã mở màn Giữ hàng theo tham chiếu, chọn đúng lô và nguồn thử `UAT-DAY27-H05-EXPIRY`. Lần đầu lô demo trả `INVENTORY_NOT_SELLABLE`. API đánh giá cho thấy `TRACE_NOT_READY` vì tem của chính lô đang ở `GENERATED`.
- Trong clone, đặt đúng QR thử của lô thành đã in để chuẩn bị tiền điều kiện. Cờ công khai vẫn tắt. API đánh giá lại cùng SKU/mẻ/kho trả `SELLABLE`. Thao tác này mô phỏng tem đã in làm dữ liệu đầu vào, không phải bằng chứng nghiệm thu in vật lý.
- Tạo phiếu `ALLOC-27112026-000001` qua giao diện, giữ 2 hộp, hạn 07:50 giờ Việt Nam. Trước hạn, danh sách ghi Đã giữ hàng. Chi tiết có Tồn theo lô liên quan, khả dụng 998, giữ 2, tạm giữ 0. Chỉ bật tác vụ tự nhả của lab để chờ hết hạn.

- Sau hạn, chính tác vụ nền nhả lúc 07:50:06 giờ Việt Nam. Tải lại và lọc trạng thái Đã nhả giữ, loại Tham chiếu giao hàng và đúng mã lô. Giao diện hiển thị 1.000 khả dụng, 0 giữ và 0 tạm giữ. Nhật ký đối chiếu trực tiếp trong clone có một dòng `INVENTORY_ALLOCATION_RELEASED`, actor `system.allocation-expiry`, nguồn `SYSTEM`, lý do `ALLOCATION_EXPIRED`, tiền tố đối soát `allocation-expiry`. Dừng host tác vụ sau ca.
- **Kết quả Đạt.** Đã có bằng chứng giao diện và đối chiếu nhật ký cho đúng phiếu. Màn cũ cần tải lại để xem trạng thái do tác vụ nền cập nhật.

## L18 · J03-F04-T01

Chrome mở được trang công khai ở loopback và hiển thị hướng dẫn dùng menu trình duyệt. Điều khiển cửa sổ Chrome gốc đã dừng vì không xác minh được URL của cửa sổ cần thao tác. Khâu cài và mở từ biểu tượng còn Bị chặn. Quay lại ca này khi có người kiểm bằng Chrome hỗ trợ cài.

## L18 · J03-F03-T01

- Snapshot cũ thiếu seed `PUBLIC_TRACE_MANAGE`. Sau rà độc lập đã bổ sung đúng định nghĩa quyền và hai grant canonical cho hai vai demo cần dùng trên clone. Việc này không đổi gán vai hay môi trường .99.
- Dùng tài khoản điều hành nhập và tài khoản QA duyệt hai video minh họa bằng API chuẩn, cùng vùng demo `SRC_ZONE_SMOKE_001`. QR fixture P11A dùng mã thương phẩm thử nên cổng kích hoạt trả `GTIN_MAPPING_MISSING`. Chọn QR khác trong clone có mã hộp chuẩn và cùng vùng, tạo và duyệt nội dung sản phẩm minh họa, rồi kích hoạt và làm mới qua đúng quy trình. Trang chỉ được phục vụ qua loopback.
- **Đạt.** Tra đúng QR và mẻ thử. Tên video nguồn gốc khớp sổ vùng. Trình phát nhận media HTTPS `video/mp4` và bắt đầu phát sau một lần bấm. Bản chiếu máy chủ có hai bằng chứng APPROVED. Trang chỉ hiển thị video từ origin HTTPS đã cho phép. Trình duyệt hỗ trợ phát video nhúng. Liên kết mở thẻ mới nằm trong nội dung dự phòng của thẻ video.

## L22 · N07-F10-T01

- Ghép thiết bị demo mới cho đúng vai vận hành. Hàng đợi trước ca trống. Dựng lệnh công việc `WO-27112026-000002` đúng trạng thái cho Check-in. Trước thử không có ghi nhận nguồn.
- Giữ trình duyệt online. Proxy loopback ngắt riêng POST đồng bộ trước khi tiếp nhận ở máy chủ. Một lệnh Check-in lưu lúc 08:25 nhận `NETWORK_ERROR` năm lần và sang Cần xem lại (`DEAD_LETTER`). Khi nối lại, thẻ vẫn chờ thao tác tay, máy chủ chưa có lệnh.
- **Đạt.** Bấm Thử lại đúng thẻ. Cùng loại, mã lệnh công việc và giờ lưu chuyển Đã gửi. Quay lại hồ sơ nguồn thấy Check-in mới. Máy chủ có đúng một `APPLIED`, một mã sự kiện, một khóa chống trùng, một audit `APPLIED` và một sự kiện `WORKFORCE_CHECK/DONE`. Đã gỡ ngắt mô phỏng ở proxy.

## L10 · B09-F07-T04, B09-F08-T05

Tạo hai công thức thử trên hai SKU riêng chưa có công thức đang vận hành. Dùng fixture đã rà độc lập để dựng đúng trạng thái lịch sử `APPROVED_SEED_BASELINE` trong clone, với gác đích theo tên DB chính xác. Giữ hai SKU chỉ trong lab.

- **B09-F07-T04 Đạt.** Mẫu 01 kích hoạt qua Quản trị với lý do và tham chiếu thử. UI báo Đã kích hoạt công thức, hiện Đang vận hành và còn lịch sử chuyển từ Đã duyệt (bản gốc). Một sự kiện audit từ `APPROVED_SEED_BASELINE` sang `ACTIVE_OPERATIONAL`.
- **B09-F08-T05 Đạt.** Dùng mẫu 02 riêng, ngừng qua Quản trị với lý do thử. UI hiện Đã ngừng dùng và lịch sử giữ lý do. Một sự kiện audit từ `APPROVED_SEED_BASELINE` sang `RETIRED`. Hai mẫu không có lệnh sản xuất.

## L23 · O03-F01-T06

- Sao lưu lab chính sau L10 rồi phục hồi thử sang một DB demo riêng. Áp fixture chính sách đã rà cho công thức ở DB riêng. Chính sách cần đúng hai người và tách người gửi. API duy nhất trỏ DB riêng trong ca. DB lab chính không có chính sách hay công thức của ca.
- **Đạt.** Vai điều hành gửi yêu cầu thử. QA duyệt lần đầu với phiếu căn cứ. UI báo đã ghi nhận và chờ người tiếp theo. DB có 1 quyết định, trạng thái vẫn `PENDING` / `PENDING_APPROVAL`. Quản trị dùng phiếu căn cứ riêng cho lần duyệt thứ hai. Tài khoản này khác người gửi và người duyệt lần đầu. Mở lại chi tiết thấy Đã phê duyệt. DB có đúng 2 quyết định `APPROVED` của 2 người khác người gửi, công thức `APPROVED`.

## Chốt lượt

Đã chuyển **10 ca** từ Bị chặn sang Đạt. Toàn bộ 2.326 ca có **2.235 Đạt, 0 Không đạt, 68 Không áp dụng, 23 Bị chặn và 0 chưa chạy**. Đối chiếu từng mã catalog với dòng cuối của mã trong sổ. Dòng 3.372 là mốc chốt. Phiên UAT không chạy lại ca đã Đạt.

| Số ca | Mã | Điều kiện chốt |
| --- | --- | --- |
| 1 | A04-F04-T01 | Toàn chốt tên và định nghĩa các chuỗi trên biểu đồ. Catalog đang đòi sản lượng và lượng nhập/xuất, còn màn hình hiển thị tồn việc. Sau khi chốt cần dữ liệu theo ngày đúng chỉ số. |
| 5 | D06-F03-T05, H07-F01-T05, J04-F01-T04, K03-F01-T04, K03-F02-T05 | Toàn chốt có chấp nhận kiểm phát lại cùng mã trên lab với tình huống mất phản hồi sau khi máy chủ đã áp dụng hay cần thao tác phát lại mục đã gửi trên UI. Hàng đợi hiện khóa khả năng gửi mục đã xong. |
| 4 | J03-F02-T01/T02/T03, N07-F02-T01 | Cần điện thoại hoặc camera hoạt động, trang demo qua HTTPS tin cậy và tem thử. Mỗi ca dùng camera thật cho bước quét, từ chối và dừng quét theo catalog. |
| 1 | J03-F04-T01 | Cần Chrome hỗ trợ cài ứng dụng và người kiểm mở lại từ biểu tượng. Máy lab hiện chỉ chứng minh được hướng dẫn cài trên trang. |
| 5 | N01-F01-T01, N01-F02-T01, N01-F03-T01/T02/T04 | Toàn xác nhận vai có quyền Mobile đúng catalog hoặc duyệt sửa vai trong catalog. R-OPS-MGR thiếu quyền Mobile trong seed đã kiểm. N01-F03-T01 còn cần người kiểm nhập và xác nhận đổi mật khẩu demo trực tiếp. |
| 1 | N07-F06-T05 | Toàn chốt vai kho có quyền xuất vật tư hay yêu cầu giữ nguyên vai sản xuất trong catalog. Cần xếp lệnh xuất/nhập/đóng gói trước khi giữ hoặc thu hồi chính nguồn đó. |
| 6 | N07-F07-T01/T02/T03, N07-F08-T01/T02/T03 | Toàn chốt cập nhật catalog theo Gửi tất cả hay giữ yêu cầu sản phẩm cho chọn nhiều mục, chỉ gửi mục chọn và chỉ tự gửi mục chọn. |

Cả DB demo chính và bản sao thử duyệt hai người đã có bản sao lưu riêng ngoài repo công khai. Bản sao DB chính 24.355.905 byte đã được phục hồi thử đủ 160 migration. Bản sao DB duyệt hai người 24.363.566 byte đã qua đọc bảng mục lục và giải mã toàn bộ luồng restore. Container lab đã dừng, giữ volume có tên và chế độ không tự xóa. Đã xác minh các cổng riêng của lab không còn tiến trình lắng nghe.

## Lượt hai · Tiêu chí Toàn duyệt ngày 27/11

Mở lại đúng volume đã giữ, đối chiếu băm hai bản sao lưu và mốc 160 migration. Cổng DB chỉ loopback. Giữ duy nhất lượt test này. Sổ lúc vào có 2.235 Đạt, 0 Không đạt, 68 Không áp dụng và 23 Bị chặn.

| Mã | Tiêu chí cũ | Tiêu chí đã duyệt cho lượt hai |
| --- | --- | --- |
| N01-F01-T01, N01-F02-T01, N01-F03-T01/T02/T04 | Vai R-OPS-MGR | Vai R-PROD-OP có quyền Mobile. Giữ yêu cầu hành vi đăng nhập, đăng xuất hoặc mật khẩu của từng ca. Người kiểm trực tiếp nhập thông tin khi thử đổi mật khẩu. |
| N07-F06-T05 | Vai sản xuất xếp lệnh nguồn | Kho nguyên liệu xếp đúng lệnh xuất, quản lý sản xuất tạm dừng chính phiếu đó, rồi gửi thử và xác minh không xuất. |
| N07-F07-T01/T02/T03 | Gửi mục đã chọn và cổng theo quyền | Gửi tất cả cho hai lệnh đủ điều kiện. Nút khóa khi không có lệnh gửi được. Vai bị loại không vào hoặc không thực hiện được. |
| N07-F08-T01/T02/T03 | Tự gửi mục đã chọn khi có lại mạng | Tự gửi các lệnh đủ điều kiện trong đúng phiên khi đường gửi phục hồi. Không phát lại mục đã gửi. Vai bị loại không thấy hoặc không gửi lệnh của người khác. |
| D06-F03-T05, H07-F01-T05, J04-F01-T04, K03-F01-T04, K03-F02-T05 | Phát lại mục đã đồng bộ từ giao diện | Kiểm cùng mã khi mất phản hồi sau khi máy chủ đã áp dụng và chỉ ghi một lần. |
| A04-F04-T01 | Sản lượng và lượng nhập/xuất | Hai biểu đồ 14 ngày Việt Nam. Thành phẩm đã nhập kho tính bằng hộp, nguyên liệu nhập và xuất tính bằng kg. So với chứng từ đã ghi sổ, độc lập bộ lọc tổng quan. |

### L21 · Đăng nhập và thiếu giá trị hiện tại

- **N01-F01-T01 Đạt.** Đăng nhập PWA bằng tài khoản demo R-PROD-OP, vào Việc của tôi. Thấy nhóm Sản xuất và công việc đúng phạm vi. Công việc KCS của mẻ thử đã xác minh ở lượt đầu vắng trong hộp việc của vai sản xuất.
- **N01-F03-T02 Đạt.** Mở Đổi mật khẩu, giữ toàn bộ ô trống và bấm kiểm tra. Form hiện Vui lòng nhập mật khẩu hiện tại và giữ trang cũ. Không nhập giá trị xác thực hoặc thực hiện đổi.

- **N01-F02-T01 Đạt.** Thiết bị của vai sản xuất giữ lệnh Check-in `WO-27112026-000003` và ảnh demo chờ đồng bộ. Đăng xuất chuyển về đăng nhập với trạng thái giữ việc. Vai sản xuất thứ hai đăng nhập cùng trình duyệt và ghép máy hợp lệ, không thấy lệnh hay ảnh của chủ cũ và Gửi tất cả bị khóa. Đăng nhập lại chủ cũ thấy đúng mã và tệp như trước. Máy chủ chưa nhận lệnh trong toàn bộ bước đối chứng.

### L22 · Rỗng và vai không có quyền đồng bộ

- **N07-F07-T02 Đạt.** Người vận hành thứ hai có phiên ghép hợp lệ, hàng đợi rỗng và nút Gửi tất cả bị khóa. Không xuất hiện lệnh của người trước.
- **N07-F07-T03 và N07-F08-T03 Đạt.** Dùng cùng trình duyệt với lệnh và ảnh của vai sản xuất còn chờ. Tài khoản R-AUDITOR xác thực thành công nhưng PWA không cho vào Hàng đợi ngay cả khi mở đường dẫn trực tiếp. Khôi phục riêng đường gửi trong thời gian vai này bị chặn, máy chủ vẫn chưa nhận lệnh. Sau khi đưa đường gửi trở lại trạng thái thử và đăng nhập chủ cũ, đúng lệnh và ảnh vẫn còn chờ.

- **N07-F07-T01 Đạt.** Hai thẻ Check-in `WO-27112026-000003` và `WO-27112026-000004` cùng chủ và thiết bị, đều Chờ gửi và chưa có trên máy chủ. Nối lại đường gửi và kiểm cả hai vẫn chờ ngay trước khi bấm Gửi tất cả. Sau thao tác tay, hai thẻ chuyển Đã gửi. Mỗi hồ sơ nguồn có đúng một lệnh APPLIED và một lần ghi nhận.

- **N07-F08-T01 Đạt.** Hai lệnh mới `WO-27112026-000005` và `WO-27112026-000006` lỗi `NETWORK_ERROR` khi ngắt riêng proxy. Máy chủ chưa nhận trước khi khôi phục. Giữ Hàng đợi mở và nối lại đường gửi. Bộ tự gửi xử lý cả hai, không có thao tác gửi tay. Mỗi hồ sơ ghi đúng một lần.
- **N07-F08-T02 Đạt.** Sau ca trên, hàng đợi chỉ có năm mục Đã gửi. Mô phỏng ngắt và nối lại đường gửi rồi tải lại màn để bộ tự gửi kiểm hàng đợi. Năm mã và trạng thái giữ nguyên, nút vẫn khóa, số mục máy chủ và toàn bộ dấu vết audit không đổi. Ca dùng lỗi đường gửi cục bộ, không đổi kết nối mạng của cả máy.

### L21 · N07-F06-T05

**Đạt.** Ký FRM-12 và FRM-13 cho phiếu `MI-27112026-000003`, duyệt một dòng 0,305 kg gạo ở đúng lô FEFO `RLOT-27112026-000033`. Kho nguyên liệu nhận diện lô, đính kèm ảnh và xếp lệnh khi đường gửi ngắt. Hàng đợi hiện đúng mã phiếu và 0 lần gửi. Quản lý sản xuất tạm dừng chính phiếu trên Quản trị. Trước khi nối lại, phiếu `ON_HOLD` và máy chủ chưa có lệnh. Gửi lệnh cũ trả một `CONFLICT / MOBILE_STALE_TASK_STATE`. So cùng lô/vị trí, khả dụng vẫn 0,305 kg và không đổi giữ. Có đúng một audit tạm dừng của quản lý, không có audit xuất và không có bút toán giảm.

### L17 · H07-F01-T05

**Đạt.** Lập phiếu demo `WR-27112026-000001` cho 6 hộp từ mẻ đã xuất xưởng với FRM-21 đủ chữ ký. FRM-22 có bằng chứng đã duyệt và Trưởng ngày, KCS ký trước. Khi Kế toán kho xác nhận, bộ mô phỏng bỏ phản hồi sau khi máy chủ đã ghi nhận. Hộp xác nhận giữ mở và báo Xác nhận phiếu thất bại. Gửi lại trong đúng hộp, bộ mô phỏng xác nhận cùng khóa và cùng nội dung. Giao diện hiển thị đủ ba chữ ký. DB có đúng một chữ ký Kế toán kho, một lần xác nhận nhập và một dòng CREDIT 6 hộp cho nguồn này.

### L19 · J04-F01-T04

**Đạt.** KCS nhận diện `P11A-DEV-QR-BOX-001` và mở việc truy xuất. Sau khi máy chủ áp dụng, bộ mô phỏng để đầu phản hồi đến ứng dụng rồi ngắt phần thân. PWA tự phát lại trong lô mới. Mã lệnh, khóa chống trùng của mục và mã băm đều trùng. Hàng đợi hiện một thẻ Đã gửi. DB có một hàng sự kiện đúng nguồn với một APPLIED và một REPLAYED.

### L20 · K03-F01-T04 và K03-F02-T05

- **K03-F01-T04 Đạt.** KCS xếp một ảnh demo mới cho `P11-DEV-CAPA-001`. PWA nhận phản hồi bị ngắt phần thân rồi gửi lại bằng lô mới, với mã lệnh, khóa của mục và mã băm trùng. Hàng đợi báo Đã gửi, DB có một APPLIED, một REPLAYED và đúng một ảnh mới, tổng ảnh từ 4 lên 5.
- **K03-F02-T05 Đạt.** KCS nhận diện `M3-SKULOCK-RECALL-C9` và xác nhận cách ly đúng lệnh khóa SKU. Mất phần thân phản hồi sau APPLIED và lần tự gửi lại giữ nguyên định danh mục trong lô mới. Hàng đợi báo Đã gửi. DB có một APPLIED, một REPLAYED và khóa vẫn ACTIVE.

### L13 · D06-F03-T05

**Đạt.** Lần đầu với lô cũ chỉ chứng minh đã áp dụng và giao diện phục hồi, chưa có dấu vết phát lại ở tầng mục. Giữ nguyên lô đó và dùng lô demo mới `RLOT-27112026-000082` để chạy lại ca chưa Đạt. Lô mới đã KCS đạt, có 2 kg và chưa có lệnh. Đính kèm tệp ảnh demo, ngắt phần thân phản hồi sau APPLIED và ghi nhận PWA tự gửi lại cùng mã lệnh, khóa mục và mã băm trong lô mới. Hàng đợi hiện Đã gửi, nút gửi khóa, Quản trị hiện Sẵn sàng sản xuất. Danh sách lô của `MI-27112026-000002` xếp FEFO 1, đủ 2 kg. DB có một APPLIED, một REPLAYED và một audit chuyển sẵn sàng.

### L02 · A04-F04-T01

**Đạt.** Tác vụ chiếu số liệu trên lab đã tạo bản tổng hợp từ 14/11 đến 27/11 giờ Việt Nam. Mỗi biểu đồ có 14 điểm. Ngày 26/11 ba chỉ số bằng 0. Điểm 27/11 có 6 hộp thành phẩm đã nhập kho, 1.740,334 kg nguyên liệu nhập và 1.241,080 kg nguyên liệu xuất. Sổ kho hiển thị phiếu `WR-27112026-000001` và các dòng tăng/giảm đúng ngày. Tổng theo từng đơn vị khớp truy vấn sổ cái. Chọn phân hệ Thu hồi giữ nguyên số và dải ngày.

Hai ca .NET tích hợp Đạt trên DB test riêng và bốn ca giao diện lọc Đạt. Lượt .NET đầu thiếu đường dẫn gốc repo khi chạy ngoài checkout nên bộ kiểm hợp đồng OpenAPI dừng một ca. Đã chạy lại riêng ca đó với biến gốc repo và đạt. Tám tệp thuộc thay đổi A04 giữ cùng dấu băm trước và sau kiểm. Ca này kiểm bản làm việc A04 trên lab demo.

### Chốt lượt hai

Đối chiếu 2.326 mã catalog với dòng gần nhất của từng mã. Có 16 ca chuyển sang Đạt trong lượt này và các ca đã Đạt trước đó giữ nguyên kết quả. Sổ hiện 2.251 Đạt, 0 Không đạt, 68 Không áp dụng, 7 Bị chặn và 0 Chưa chạy.

| Còn lại | Điều kiện tiếp tục |
| --- | --- |
| N01-F03-T01, N01-F03-T04 | Toàn để sang lượt sau. Trước khi trả tab, PWA còn đúng lệnh Check-in `WO-27112026-000007` và ảnh demo chờ đồng bộ. Hai ca cần người kiểm trực tiếp nhập và xác nhận trong biểu mẫu mật khẩu. |
| J03-F02-T01/T02/T03, N07-F02-T01 | Cần camera hoạt động, HTTPS demo tin cậy và tem thử. |
| J03-F04-T01 | Cần Chrome hỗ trợ cài PWA và mở lại ứng dụng từ biểu tượng. |

Đã sao lưu DB demo ngoài repo công khai, 24.400.878 byte. Bản sao qua kiểm mục lục và giải mã hết luồng phục hồi. Dừng máy thử và xác minh các cổng lab đã đóng. Volume PostgreSQL có tên vẫn được giữ để tiếp tục.

## Lượt ba · Hai ca mật khẩu và năm ca thiết bị

Mở lại volume demo 27/11 trong một phiên giữ khóa kiểm thử, cùng hồ sơ trình duyệt với lệnh Check-in `WO-27112026-000007` và ảnh demo đã giữ ở lượt trước. Đường gửi lệnh và ảnh được ngắt riêng để đối chiếu hàng đợi trước và sau. Ở đầu lượt, DB chưa nhận lệnh này và chưa có audit tự đổi mật khẩu của tài khoản thử. Toàn tự nhập và xác nhận trên tab Xưởng. Bằng chứng chỉ ghi thông báo, số lần đổi và trạng thái lệnh chờ.

Năm ca thiết bị giữ Bị chặn cho đến khi có phần chuẩn bị dưới đây.

| Ca | Chuẩn bị và đối chiếu |
| --- | --- |
| J03-F02-T01 | Điện thoại có camera và trình duyệt hỗ trợ quét. Mở trang tra cứu công khai của lab qua HTTPS được thiết bị tin cậy. Chuẩn bị tem QR demo đã in, còn hiển thị công khai, có mã đối chiếu. Cấp quyền camera, quét và so mã với tem và hồ sơ demo. |
| J03-F02-T02 | Dùng cùng tem và mẻ demo. Ghi trước trạng thái xuất xưởng, số dư tồn kho và số bản ghi xác nhận. Quét trên điện thoại, rồi đối chiếu ba giá trị sau quét. |
| J03-F02-T03 | Thiết bị và trang HTTPS như trên. Chuẩn bị quyền camera ở trạng thái có thể hỏi lại. Từ chối, thử nhập mã tay, sau đó cấp quyền lại và bấm Dừng quét trước khi camera đọc mã. Xác nhận camera đóng và trang không tự chuyển mã. |
| J03-F04-T01 | Chrome trên thiết bị hỗ trợ cài PWA, mở trang tra cứu demo qua HTTPS. Dùng cài đặt thật của trình duyệt rồi mở từ biểu tượng trên thiết bị. Đối chiếu cùng mã tem demo trong chế độ ứng dụng. |
| N07-F02-T01 | Điện thoại có camera, PWA Xưởng của lab mở qua HTTPS tin cậy. Đăng nhập vai R-PROD-OP, ghép thiết bị demo và chuẩn bị hồ sơ đang thao tác được cùng QR/mã vạch in khớp. Xác nhận mã nhận diện, camera tắt khi đọc hoặc đóng, trạng thái nguồn không thay đổi chỉ vì quét. |

### L21 · N01-F03-T04

**Đạt.** Toàn tự nhập thử hai trường hợp trên biểu mẫu Đổi mật khẩu. Màn hình hiện “Mật khẩu mới tối thiểu 12 ký tự.” và “Mật khẩu xác nhận không khớp”. Biểu mẫu vẫn mở. Cùng phiên sau đó mở được Hàng đợi, thấy đúng lệnh Check-in và một ảnh ở trạng thái Chờ gửi. Audit không tăng số lần đổi trong hai lần thử này.

### L21 · N01-F03-T01

**Đạt.** Toàn tự thực hiện trên tài khoản demo R-PROD-OP. Audit ghi một lần đổi lúc 10:23:40 và xác nhận đã tăng phiên bản phiên đăng nhập để hết hiệu lực phiên cũ. Đăng nhập mới thành công lúc 10:23:48. Hàng đợi vẫn có đúng lệnh Check-in `WO-27112026-000007` và một ảnh Chờ gửi. DB chưa nhận lệnh. Toàn xác nhận mật khẩu trước khi đổi bị từ chối ở lượt đăng nhập đối chứng riêng. Audit ghi nhận từ chối sau lúc đổi. Các lần thử liên tiếp cũng làm tài khoản demo bị khóa tạm. Lần đăng nhập thành công đã xác minh diễn ra trước lượt khóa.

Sổ L21 có 25 Đạt. Toàn sổ có 2.253 Đạt, 0 Không đạt, 68 Không áp dụng, 5 Bị chặn và 0 Chưa chạy trên 2.326 mã. Năm ca Bị chặn còn lại là các ca thiết bị ở bảng trên.

Đã dừng các tiến trình lab của lượt ba và giữ volume demo cùng hồ sơ trình duyệt. Đường gửi thử vẫn được ngắt trong suốt hai ca nên lệnh chờ chưa vào máy chủ.
