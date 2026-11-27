# Ngày 27/11 — Đối chiếu sổ UAT và Sheet M1–M2

Toàn giao xử lý các ca Bị chặn từ mốc 17:55 ngày 26/11. Sổ chốt ngày 26/11 gồm 2.225 Đạt, 0 Không đạt, 68 Không áp dụng, 33 Bị chặn và 0 chưa chạy trên 2.326 bước. [Bảng ca Bị chặn ngày 26/11](2026-11-26-review-sheet-codex.md)

| Mốc biên bản | Lô và căn cứ | Đạt | Không đạt | Không áp dụng | Bị chặn | Chưa chạy |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| 07:50 | L17 · H05-F04-T01, dòng 3.362 | 2.226 | 0 | 68 | 32 | 0 |
| 08:01 | L16 · G03-F01-T04, dòng 3.363 | 2.226 | 0 | 68 | 32 | 0 |
| 08:04 | L16 · G03-F01-T04 kiểm bổ sung, dòng 3.364 | 2.227 | 0 | 68 | 31 | 0 |
| 08:15 | L10 · B09-F06-T01/T02/T04, dòng 3.365–3.367 | 2.230 | 0 | 68 | 28 | 0 |
| 08:20 | L18 · J03-F03-T01, dòng 3.368 | 2.231 | 0 | 68 | 27 | 0 |
| 08:28 | L22 · N07-F10-T01, dòng 3.369 | 2.232 | 0 | 68 | 26 | 0 |
| 08:29 | L10 · B09-F07-T04 và B09-F08-T05, dòng 3.370–3.371 | 2.234 | 0 | 68 | 24 | 0 |
| 08:34 | L23 · O03-F01-T06, dòng 3.372 | 2.235 | 0 | 68 | 23 | 0 |
| 08:37 | Đọc lại Sheet sau khi chốt tại dòng 3.372 | 2.235 | 0 | 68 | 23 | 0 |
| 08:48 | L21 · N01-F01-T01 và N01-F03-T02, dòng 3.373–3.374 | 2.237 | 0 | 68 | 21 | 0 |
| 08:52 | L21 · N01-F02-T01, dòng 3.375 | 2.238 | 0 | 68 | 20 | 0 |
| 08:54 | L22 · N07-F07-T02/T03 và N07-F08-T03, dòng 3.376–3.378 | 2.241 | 0 | 68 | 17 | 0 |
| 08:55 | L22 · N07-F07-T01, dòng 3.379 | 2.242 | 0 | 68 | 16 | 0 |
| 08:56 | L22 · N07-F08-T01/T02, dòng 3.380–3.381 | 2.244 | 0 | 68 | 14 | 0 |
| 09:00 | L21 · N07-F06-T05, dòng 3.382 | 2.245 | 0 | 68 | 13 | 0 |
| 09:29 | L17 · H07-F01-T05, dòng 3.383 | 2.246 | 0 | 68 | 12 | 0 |
| 09:30 | L19 · J04-F01-T04, dòng 3.384 | 2.247 | 0 | 68 | 11 | 0 |
| 09:33 | L20 · K03-F01-T04 và K03-F02-T05, dòng 3.385–3.386 | 2.249 | 0 | 68 | 9 | 0 |
| 09:36 | L13 · D06-F03-T05, dòng 3.387 | 2.250 | 0 | 68 | 8 | 0 |
| 09:46 | L02 · A04-F04-T01, dòng 3.388 | 2.251 | 0 | 68 | 7 | 0 |
| 10:28 | L21 · N01-F03-T04 và N01-F03-T01, dòng 3.389–3.390 | 2.253 | 0 | 68 | 5 | 0 |


### 07:50 — L17 · H05-F04-T01, dòng 3.362

**H05-F04-T01 Đạt.** Phiếu demo giữ 2 hộp rồi tác vụ nền của lab tự nhả lúc 07:50:06, sáu giây sau hạn. Tồn khả dụng từ 998 trở lại 1.000 hộp, còn 0 giữ và 0 tạm giữ. Nhật ký có một lần tự nhả đúng lý do hết hạn. Tác vụ riêng đã dừng sau ca.
QR mẫu được đặt ở trạng thái Đã in để chuẩn bị tiền điều kiện thử giữ hàng, chưa có bằng chứng in tem vật lý. L17 vẫn còn H07-F01-T05 cần Toàn chốt cách kiểm chống lặp ở bước ký cuối FRM-22. [Các quyết định cần chốt](2026-11-27-chot-ca-uat-bi-chan.md)

M12-009 và M12-105 đã đọc lại. M12-009 2026-11-27 07:51, M12-105 2026-11-27 07:52. [Biên bản UAT](2026-11-27-luot-uat-codex.md)


### 08:01 — L16 · G03-F01-T04, dòng 3.363

**G03-F01-T04 vẫn Bị chặn.** Trên mẻ demo đã sấy, chưa ký và không bị giữ do thu hồi, vai KCS kiểm Giữ lại và Loại. Cả hai báo thiếu lý do, hết lỗi khi nhập và báo lại khi xóa. Chrome chưa cho nạp ảnh demo từ đĩa, nên chưa tách được điều kiện thiếu lý do khỏi điều kiện thiếu ảnh. Phiếu còn chưa ký.

M12-009 và M12-105 đã đọc lại. M12-009 2026-11-27 08:02, M12-105 2026-11-27 08:02. [Biên bản UAT](2026-11-27-luot-uat-codex.md)


### 08:04 — L16 · G03-F01-T04 kiểm bổ sung, dòng 3.364

**G03-F01-T04 Đạt.** Trên trình duyệt tích hợp, vai KCS nạp đúng một ảnh demo cho cùng mẻ. Ở cả Giữ lại và Loại, nút chỉ còn bị khóa khi thiếu lý do, mở khi nhập và khóa lại khi xóa. Phiên UAT dừng trước thao tác gửi. Mẻ vẫn chờ KCS và FRM-29 vẫn nháp chưa ký.

M12-009 và M12-105 đã đọc lại. M12-009 2026-11-27 08:05, M12-105 2026-11-27 08:05. [Biên bản UAT](2026-11-27-luot-uat-codex.md)


### 08:15 — L10 · B09-F06-T01/T02/T04, dòng 3.365–3.367

**B09-F06-T01, B09-F06-T02 và B09-F06-T04 Đạt.** Mẫu trống lý do bị khóa; mẫu đủ lý do phục hồi từ Chờ phê duyệt về Nháp. Bấm kép và tải lại chỉ có một chuyển trạng thái và một sự kiện nhật ký cho mỗi mẫu. L10 còn B09-F07-T04 và B09-F08-T05 cần mẫu công thức ở trạng thái APPROVED_SEED_BASELINE.

M12-009 và M12-105 đã đọc lại. M12-009 2026-11-27 08:15, M12-105 2026-11-27 08:15. [Biên bản UAT](2026-11-27-luot-uat-codex.md)


### 08:20 — L18 · J03-F03-T01, dòng 3.368

**J03-F03-T01 Đạt trên lab cục bộ.** Trang truy xuất mở đúng QR demo, phát video HTTPS đã duyệt và chỉ hiển thị nguồn trong danh sách cho phép. Ba ca camera J03-F02-T01/T02/T03 còn thiếu thiết bị phù hợp. J03-F04-T01 vẫn Bị chặn ở bước mở trang từ biểu tượng đã cài, vì chưa có bằng chứng mở từ Chrome hỗ trợ cài.

M12-009 và M12-105 đã đọc lại. M12-009 2026-11-27 08:21, M12-105 2026-11-27 08:21. [Biên bản UAT](2026-11-27-luot-uat-codex.md)


### 08:28 — L22 · N07-F10-T01, dòng 3.369

**N07-F10-T01 Đạt.** Sau năm lần lỗi mạng trước khi máy chủ nhận, thẻ sang Cần xem lại. Khi nối lại vẫn chờ thao tác tay. Bấm Thử lại đúng thẻ và kiểm lại hồ sơ nguồn, máy chủ chỉ có một lần áp dụng và một ghi nhận check-in.
Kết quả này chứng minh gửi lại thủ công sau lỗi mạng. Sáu ca chọn mục gửi hoặc tự gửi mục chọn của L22 tiếp tục chờ Toàn chốt tiêu chí theo WP24. [Các quyết định cần chốt](2026-11-27-chot-ca-uat-bi-chan.md)

M12-009 và M12-105 đã đọc lại. M12-009 2026-11-27 08:28, M12-105 2026-11-27 08:28. [Biên bản UAT](2026-11-27-luot-uat-codex.md)


### 08:29 — L10 · B09-F07-T04 và B09-F08-T05, dòng 3.370–3.371

**B09-F07-T04 và B09-F08-T05 Đạt.** Hai mẫu riêng có công thức lịch sử ở trạng thái APPROVED_SEED_BASELINE. Giao diện đưa mẫu thứ nhất sang Đang vận hành và mẫu thứ hai sang Đã ngừng dùng. Mỗi mẫu có đúng một sự kiện nhật ký và chưa phát sinh lệnh sản xuất. L10 đạt đủ 25/25.

M12-009 và M12-105 đã đọc lại. M12-009 2026-11-27 08:30, M12-105 2026-11-27 08:30. [Biên bản UAT](2026-11-27-luot-uat-codex.md)


### 08:34 — L23 · O03-F01-T06, dòng 3.372

**O03-F01-T06 Đạt.** Trên DB demo riêng, người gửi thuộc vai điều hành. Sau quyết định của QA, yêu cầu vẫn Chờ phê duyệt và có một quyết định. Quản trị duyệt lần hai mới chuyển Đã phê duyệt. Đối chiếu có đúng hai quyết định của hai người khác nhau, cả hai đều khác người gửi. L23 đạt đủ 25/25.

M12-009 và M12-105 đã đọc lại. M12-009 2026-11-27 08:34, M12-105 2026-11-27 08:35. [Biên bản UAT](2026-11-27-luot-uat-codex.md)


### 08:37 — Đọc lại Sheet sau khi chốt tại dòng 3.372

10 ca chuyển từ Bị chặn sang Đạt, đối chiếu đến dòng sổ 3.372. Phiên UAT chạy trên lab demo riêng. Biên bản xác nhận đã sao lưu hai DB demo, phục hồi thử bản chính và dừng lab với volume có tên.
## 23 ca còn Bị chặn

| Mã ca | Lý do và việc cần chốt |
| --- | --- |
| A04-F04-T01 | Biểu đồ đang dùng số việc tồn. Cần Toàn chốt giữ tiêu chí 14 ngày theo sản lượng và khối lượng nhập/xuất hay dùng các chuỗi hiện có. |
| D06-F03-T05, J04-F01-T04, K03-F01-T04, K03-F02-T05 | PWA khóa gửi lại lệnh đã gửi. Cần Toàn chốt cách chứng minh phát lại cùng mã khi máy chủ đã nhận nhưng PWA mất phản hồi, hoặc giữ yêu cầu thao tác trực tiếp trên giao diện. |
| H07-F01-T05 | Ca yêu cầu gửi lại lệnh nhập kho qua PWA, còn xác nhận nhập kho thực hiện ở bước ký cuối FRM-22. Cần Toàn chốt chuyển ca sang kiểm chống lặp ở bước ký cuối hay giữ luồng PWA trong tiêu chí. |
| J03-F02-T01, J03-F02-T02, J03-F02-T03, N07-F02-T01 | Cần thiết bị đọc được tem demo để kiểm mở camera, nhận mã và dừng quét. Nếu dùng điện thoại, cần địa chỉ HTTPS demo mà điện thoại truy cập được. |
| J03-F04-T01 | Chrome đã mở trang demo nhưng chưa xác định đúng cửa sổ để cài. Cần kiểm bằng Chrome hỗ trợ cài và mở được trang từ biểu tượng. |
| N01-F01-T01, N01-F02-T01, N01-F03-T01, N01-F03-T02, N01-F03-T04 | R-OPS-MGR trong lab thiếu quyền Mobile. Cần Toàn chốt vai R-PROD-OP hoặc bố trí đúng vai R-OPS-MGR có quyền Mobile trên lab. Ca đổi mật khẩu thử cần người kiểm trực tiếp. |
| N07-F06-T05 | Catalog chỉ định R-PROD-OP, còn luồng hiện hành dùng vai kho nguyên liệu để xếp lệnh xuất và vai quản lý sản xuất để giữ phiếu. Cần Toàn chốt cặp vai kiểm. |
| N07-F07-T01, N07-F07-T02, N07-F07-T03, N07-F08-T01, N07-F08-T02, N07-F08-T03 | Hàng đợi đang dùng Gửi tất cả và tự gửi khi có mạng. Cần Toàn chốt sửa sáu tiêu chí theo WP24 hoặc giữ yêu cầu gửi theo từng mục được chọn. |

[Đề xuất để Toàn chốt](2026-11-27-chot-ca-uat-bi-chan.md)

M12-009 và M12-105 đã đọc lại. M12-009 2026-11-27 08:37, M12-105 2026-11-27 08:37. [Biên bản UAT](2026-11-27-luot-uat-codex.md)


## Lượt hai · Tiêu chí Toàn duyệt ngày 27/11


### 08:48 — L21 · N01-F01-T01 và N01-F03-T02, dòng 3.373–3.374

**N01-F01-T01 và N01-F03-T02 Đạt theo vai R-PROD-OP có quyền Mobile.** Vai sản xuất vào được Việc của tôi, thấy công việc đúng phạm vi. Form Đổi mật khẩu báo thiếu mật khẩu hiện tại khi gửi trống toàn bộ, giữ nguyên trang và phiên đăng nhập.
Lượt này bắt đầu với 18 ca đã duyệt phương án và 5 ca chờ thiết bị. Mốc chốt lượt đầu và lý do cũ được giữ trong mục trên.

M12-009 và M12-105 đã đọc lại. M12-009 2026-11-27 08:49, M12-105 2026-11-27 08:49. [Biên bản UAT](2026-11-27-luot-uat-codex.md)


### 08:52 — L21 · N01-F02-T01, dòng 3.375

**N01-F02-T01 Đạt theo vai R-PROD-OP.** Đăng xuất giữ lệnh Check-in và ảnh demo chờ đồng bộ. Người vận hành thứ hai đăng nhập trên cùng trình duyệt không thấy lệnh hoặc ảnh của chủ cũ và nút Gửi tất cả bị khóa. Chủ cũ đăng nhập lại thấy đúng lệnh và tệp đang chờ. Máy chủ chưa nhận lệnh trong bước đối chứng.

M12-009 và M12-105 đã đọc lại. M12-009 2026-11-27 08:52, M12-105 2026-11-27 08:53. [Biên bản UAT](2026-11-27-luot-uat-codex.md)


### 08:54 — L22 · N07-F07-T02/T03 và N07-F08-T03, dòng 3.376–3.378

**N07-F07-T02, N07-F07-T03 và N07-F08-T03 Đạt theo WP24.** Người vận hành có hàng đợi rỗng thấy nút Gửi tất cả bị khóa. Vai R-AUDITOR bị chặn mở Hàng đợi. Khi khôi phục đường gửi cho đối chứng, lệnh và ảnh của người vận hành vẫn chờ, máy chủ chưa nhận lệnh.

M12-009 và M12-105 đã đọc lại. M12-009 2026-11-27 08:54, M12-105 2026-11-27 08:54. [Biên bản UAT](2026-11-27-luot-uat-codex.md)


### 08:55 — L22 · N07-F07-T01, dòng 3.379

**N07-F07-T01 Đạt theo WP24.** Hai lệnh Check-in của cùng chủ và thiết bị vẫn Chờ gửi sau khi nối lại đường gửi, ngay trước khi người kiểm bấm Gửi tất cả. Sau đó mỗi lệnh chuyển Đã gửi, có đúng một lần áp dụng và một ghi nhận ở hồ sơ nguồn.

M12-009 và M12-105 đã đọc lại. M12-009 2026-11-27 08:56, M12-105 2026-11-27 08:56. [Biên bản UAT](2026-11-27-luot-uat-codex.md)


### 08:56 — L22 · N07-F08-T01/T02, dòng 3.380–3.381

**N07-F08-T01 và N07-F08-T02 Đạt theo WP24.** Hai lệnh mới chờ khi đường gửi không hoạt động. Khi đường gửi khôi phục, cả hai tự đồng bộ, mỗi hồ sơ ghi một lần. Sau đó hàng đợi chỉ còn năm mục Đã gửi, kiểm nối lại và tải màn vẫn giữ nguyên mã, trạng thái và số lần ghi. Sáu ca gửi theo WP24 của lượt này đã Đạt.

M12-009 và M12-105 đã đọc lại. M12-009 2026-11-27 08:58, M12-105 2026-11-27 08:58. [Biên bản UAT](2026-11-27-luot-uat-codex.md)


### 09:00 — L21 · N07-F06-T05, dòng 3.382

**N07-F06-T05 Đạt theo cặp vai đã duyệt.** Kho nguyên liệu xếp lệnh xuất, sau đó quản lý sản xuất tạm dừng đúng phiếu trên Quản trị. Khi nối lại và gửi lệnh cũ, máy chủ trả xung đột do trạng thái đã đổi. Tồn và số lượng giữ như trước, có một sự kiện tạm dừng, không có bút toán xuất.

M12-009 và M12-105 đã đọc lại. M12-009 2026-11-27 09:00, M12-105 2026-11-27 09:00. [Biên bản UAT](2026-11-27-luot-uat-codex.md)

### Điểm bàn giao ở dòng sổ 3.382

Lượt hai có 10/18 ca Đạt. N01-F03-T01 và N01-F03-T04 chờ Toàn kiểm trực tiếp trên tab demo đã bàn giao. Sổ chưa có kết quả mới cho hai ca này. Sau khi phiên UAT nhận lại tab, sáu mã đã duyệt còn chờ kiểm là A04-F04-T01 và nhóm phát lại D06-F03-T05, H07-F01-T05, J04-F01-T04, K03-F01-T04, K03-F02-T05.

J03-F02-T01, J03-F02-T02, J03-F02-T03 và N07-F02-T01 còn thiếu điều kiện camera. J03-F04-T01 còn thiếu bằng chứng Chrome cài và mở app từ biểu tượng. Năm mã này nằm ngoài lượt duyệt 18 ca.


## Tiếp lượt hai sau khi Toàn trả tab demo


### 09:29 — L17 · H07-F01-T05, dòng 3.383

**H07-F01-T05 Đạt theo tiêu chí ký cuối FRM-22.** Mất phản hồi sau khi máy chủ xác nhận chữ ký. Gửi lại cùng khóa và nội dung trên lab demo. Sổ có đúng một chữ ký cuối, một lần xác nhận nhập và một bút toán tăng 6 hộp.
Toàn đã trả tab demo. Hai ca mật khẩu N01-F03-T01 và N01-F03-T04 chuyển sang lượt sau.

M12-009 và M12-105 đã đọc lại. M12-009 2026-11-27 09:29, M12-105 2026-11-27 09:29. [Biên bản UAT](2026-11-27-luot-uat-codex.md)


### 09:30 — L19 · J04-F01-T04, dòng 3.384

**J04-F01-T04 Đạt theo tiêu chí phát lại đã duyệt.** Máy chủ áp dụng lệnh ghi nhận tem demo, phản hồi bị ngắt ở phần thân. PWA tự phát lại bằng lô khác với cùng mã lệnh, khóa chống trùng và nội dung. Hàng đợi hiện một thẻ Đã gửi; đối chiếu có một lần áp dụng và một lần phát lại cho cùng sự kiện.

M12-009 và M12-105 đã đọc lại. M12-009 2026-11-27 09:31, M12-105 2026-11-27 09:31. [Biên bản UAT](2026-11-27-luot-uat-codex.md)


### 09:33 — L20 · K03-F01-T04 và K03-F02-T05, dòng 3.385–3.386

**K03-F01-T04 và K03-F02-T05 Đạt theo tiêu chí phát lại đã duyệt.** PWA phát lại hai lệnh demo trong lô mới sau khi mất thân phản hồi. Mỗi lệnh có đúng một lần áp dụng và một lần phát lại. Hồ sơ CAPA chỉ thêm một ảnh, từ 4 lên 5. Lệnh xác nhận cách ly không làm mất hiệu lực khóa SKU.

M12-009 và M12-105 đã đọc lại. M12-009 2026-11-27 09:34, M12-105 2026-11-27 09:34. [Biên bản UAT](2026-11-27-luot-uat-codex.md)


### 09:36 — L13 · D06-F03-T05, dòng 3.387

**D06-F03-T05 Đạt theo tiêu chí phát lại đã duyệt.** Mẫu đầu chỉ chứng minh đã áp dụng và giao diện phục hồi. Trên lô demo mới, PWA tự gửi lại sau khi mất phần thân phản hồi, giữ cùng mã lệnh, khóa và nội dung. Quản trị hiện Sẵn sàng sản xuất, lô vẫn 2 kg. Có một lần áp dụng, một lần phát lại và một sự kiện chuyển trạng thái.

M12-009 và M12-105 đã đọc lại. M12-009 2026-11-27 09:36, M12-105 2026-11-27 09:36. [Biên bản UAT](2026-11-27-luot-uat-codex.md)


### 09:46 — L02 · A04-F04-T01, dòng 3.388

**A04-F04-T01 Đạt trên bản làm việc A04 của lab demo.** Hai biểu đồ có đủ 14 điểm theo ngày từ 14/11 đến 27/11. Điểm 27/11 khớp 6 hộp thành phẩm nhập kho, 1.740,334 kg nguyên liệu nhập và 1.241,080 kg nguyên liệu xuất. Chọn bộ lọc phân hệ Thu hồi giữ nguyên số và dải ngày. Hai ca tích hợp và bốn ca giao diện lọc đều Đạt; một ca tích hợp cần chạy lại sau khi bổ sung đường dẫn gốc repo.
**Chốt 6/6 ca đã duyệt sau khi Toàn trả lượt.** Toàn sổ còn N01-F03-T01 và N01-F03-T04 đã hoãn. J03-F02-T01, J03-F02-T02, J03-F02-T03 và N07-F02-T01 chờ camera đọc được tem demo. J03-F04-T01 chờ Chrome hỗ trợ cài và mở app từ biểu tượng.

M12-009 và M12-105 đã đọc lại. M12-009 2026-11-27 09:46, M12-105 2026-11-27 09:46. [Biên bản UAT](2026-11-27-luot-uat-codex.md)


## Lượt ba · Kiểm tra trực tiếp trên tài khoản demo


### 10:28 — L21 · N01-F03-T04 và N01-F03-T01, dòng 3.389–3.390

**N01-F03-T04 Đạt.** Toàn kiểm trực tiếp trên biểu mẫu demo. Hai thông báo hiện đúng khi mật khẩu mới dưới 12 ký tự hoặc xác nhận không khớp. Nhật ký không phát sinh lần đổi trong hai lần kiểm này.
**N01-F03-T01 Đạt.** Tài khoản demo ghi đúng một lần đổi. Đăng nhập mới thành công, phiên cũ hết hiệu lực và mật khẩu cũ bị từ chối ở lượt đối chứng. Hàng đợi giữ đúng một lệnh Check-in và một ảnh Chờ gửi, máy chủ chưa nhận lệnh. Các lần thử liên tiếp sau đó làm tài khoản demo bị khóa tạm. L21 đạt 25/25.
**Năm ca còn Bị chặn.** J03-F02-T01, J03-F02-T02, J03-F02-T03 và N07-F02-T01 cần camera đọc tem demo qua HTTPS tin cậy. J03-F04-T01 cần Chrome hỗ trợ cài và mở PWA từ biểu tượng. Biên bản ghi điều kiện và tiêu chí cho từng mã.

M12-009 và M12-105 đã đọc lại. M12-009 2026-11-27 10:29, M12-105 2026-11-27 10:29. [Biên bản UAT](2026-11-27-luot-uat-codex.md)
