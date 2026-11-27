# Phương án UAT được Toàn duyệt ngày 27/11

Phiên UAT duy nhất đã gỡ 10 trong 33 ca bị chặn theo mốc chốt 17:55 ngày 26/11. Toàn đã duyệt phương án cho 18 ca tiêu chí và phân vai theo D-m12-143. Năm ca còn lại chờ thiết bị. Kết quả từng ca ghi trong sổ UAT và Sheet M12-009/105.

| Nhóm | Ca | Toàn chốt | Đề xuất |
| --- | --- | --- | --- |
| Xu hướng tổng quan | A04-F04-T01 | Giữ yêu cầu sản lượng và khối lượng nhập/xuất theo ngày trong 14 ngày, hoặc đổi tiêu chí sang ba chuỗi việc tồn đang có. | Giữ yêu cầu catalog. Chốt đại lượng, đơn vị và nguồn đối chiếu cho mỗi chuỗi trước khi sửa dashboard. |
| Chọn lệnh trong hàng đợi | N07-F07-T01, N07-F07-T02, N07-F07-T03, N07-F08-T01, N07-F08-T02, N07-F08-T03 | Duyệt cập nhật sáu ca theo WP24, hoặc yêu cầu mở lại tính năng chọn từng lệnh. | Theo WP24, dùng Gửi tất cả và tự gửi khi có mạng. Ghi rõ phần kiểm thay thế khi đổi tiêu chí. |
| Phát lại lệnh PWA | D06-F03-T05, J04-F01-T04, K03-F01-T04, K03-F02-T05 | Duyệt cách chứng minh chống lặp khi lệnh đã gửi, hoặc giữ yêu cầu phát lại trực tiếp từ giao diện. | Kiểm mở lại hàng đợi sau khi gửi và đối chiếu đúng một lần áp dụng. Kiểm phát lại cùng mã riêng trên lab bằng tình huống máy chủ đã nhận nhưng PWA mất phản hồi. |
| Phát lại nhập kho thành phẩm | H07-F01-T05 | Duyệt chuyển ca chống lặp sang luồng kết thúc FRM-22, hoặc yêu cầu thiết kế lại bước gửi PWA. | Giữ FRM-22 làm bước xác nhận nhập kho. Kiểm gửi lại cùng yêu cầu ở bước ký cuối và đối chiếu một bút toán. |
| Vai vào PWA | N01-F01-T01, N01-F02-T01, N01-F03-T01, N01-F03-T02, N01-F03-T04 | Duyệt dùng vai R-PROD-OP cho nhóm kiểm PWA, hoặc yêu cầu mẫu R-OPS-MGR có quyền Mobile trong lab riêng. Riêng N01-F03-T01 cần người kiểm trực tiếp nhập và xác nhận mật khẩu thử. | Dùng R-PROD-OP để kiểm các thao tác của người vận hành. Ghi nhận riêng nếu cần cấp Mobile cho R-OPS-MGR theo nghiệp vụ. |
| Giữ phiếu sau khi xếp lệnh | N07-F06-T05 | Duyệt R-WH-RAW gửi lệnh xuất trên PWA và R-PROD-MGR giữ đúng phiếu demo trong lúc lệnh đang chờ. Catalog hiện chỉ định R-PROD-OP. | Dùng cặp vai có quyền hiện hành để kiểm máy chủ từ chối lệnh cũ khi phiếu đã bị giữ. |
| Quét tem thật | J03-F02-T01, J03-F02-T02, J03-F02-T03, N07-F02-T01 | Bố trí camera đọc tem demo. Nếu dùng điện thoại, chốt endpoint HTTPS demo mà điện thoại truy cập được. | Ưu tiên camera thật trên máy lab để giữ kết nối loopback và chạy bốn ca trong cùng lượt. |
| Cài trang truy xuất | J03-F04-T01 | Bố trí một phiên Chrome trên thiết bị demo có thể xác nhận hộp cài và mở ứng dụng từ biểu tượng hệ điều hành. | Kiểm trạng thái chạy độc lập và tra lại cùng mã demo. Trong lượt 27/11, công cụ xác minh được tab tra cứu, còn cửa sổ cài đặt cần người kiểm trực tiếp. |

[Biên bản UAT 27/11](2026-11-27-luot-uat-codex.md) · [Đối chiếu Sheet 27/11](2026-11-27-review-sheet-codex.md) · [Bảng 33 ca đầu lượt](2026-11-26-review-sheet-codex.md) · [Luồng hàng đợi WP24](../wp/M12-WP24-noi-dung.md)

## Kết quả theo D-m12-143 lúc 09:46

Đã xác nhận 16 Đạt trong 18 ca Toàn duyệt. Toàn để N01-F03-T01 và N01-F03-T04 sang lượt trực tiếp sau. Còn năm ca camera và cài ứng dụng chờ thiết bị theo bảng. A04 đối chiếu đủ 14 ngày Việt Nam từ bản tổng hợp BG-08, hiển thị riêng sản lượng thành phẩm đã nhập kho theo hộp và khối lượng nguyên liệu nhập/xuất theo kg. Đã đọc lại M12-009/105 theo dòng sổ 3.388. [Biên bản UAT 27/11](2026-11-27-luot-uat-codex.md) · [Đối chiếu Sheet 27/11](2026-11-27-review-sheet-codex.md)

## Vì sao sổ có 68 ca Không áp dụng

Đối chiếu theo kết quả mới nhất của từng mã trong sổ 2.326 bước:

- **44 ca in tem hoặc hàng đợi in** thuộc phần đang hoãn theo D-m12-002, D-m12-006, D-m12-103 và D-m12-140, gồm cả ca in lệnh sản xuất dùng hàng đợi in.
- **10 ca hủy FRM-23** dùng tuyến duyệt hai tầng của phiếu lịch sử. Phiếu mới dùng chính sách ký theo vai theo D-m12-050.
- **14 ca di sản** được Toàn duyệt đưa ra khỏi phạm vi nghiệm thu ngày 30/10. Ví dụ, catalog còn mô tả trạng thái HOLD/QC_CHECKED trên phiếu nhập bao bì và nhánh kéo từ điển MISA thật.

Sổ giữ 68 mã để truy vết catalog. Phạm vi áp dụng gồm 2.258 bước, trong đó ca Bị chặn có tiêu chí đang áp dụng và chờ đủ điều kiện kiểm.

## Bàn giao hai ca mật khẩu L21

Phiên UAT đã khôi phục lab riêng và mở tab Ginsengfood Xưởng để Toàn nhập trực tiếp. Làm N01-F03-T04 trước để kiểm hai lỗi nhập, sau đó làm N01-F03-T01 để đổi, kiểm đăng nhập và đối chiếu hàng đợi Check-in cùng ảnh chờ. Chỉ ghi thông báo, kết quả xác thực và trạng thái hàng đợi sau bàn giao.

Đã chốt 2/2 ca Đạt ngày 27/11. T04 hiện đủ hai lỗi và không đổi mật khẩu. T01 ghi một lần đổi, xác nhận mật khẩu cũ bị từ chối và đăng nhập mới thành công. Lệnh Check-in và ảnh vẫn Chờ gửi. L21 đủ 25 Đạt. Tài khoản demo bị khóa tạm sau lượt đối chứng liên tiếp, sau mốc đăng nhập mới thành công. [Biên bản L21](2026-11-27-luot-uat-codex.md#l21--n01-f03-t04)

## Chuẩn bị 5 ca thiết bị

Toàn chuẩn bị một điện thoại Android có camera sau hoạt động và Chrome hỗ trợ cài ứng dụng web. Dùng một màn hình khác để mở QR demo, hoặc giấy nếu muốn in QR. Toàn sẽ trực tiếp cho phép hoặc từ chối camera và xác nhận cài khi Chrome hỏi. Phiên UAT chuẩn bị hai mẫu QR trên dữ liệu demo, một mã truy xuất công khai và một mã nguồn được PWA xưởng nhận diện, cùng tài khoản demo vai R-PROD-OP và phiên ghép thiết bị demo nếu PWA yêu cầu. Để kiểm trên điện thoại, trang truy xuất và PWA cần địa chỉ HTTPS demo mà thiết bị mở được và trình duyệt tin cậy.

| Ca | Chuẩn bị và thao tác trên thiết bị |
| --- | --- |
| J03-F02-T01 | Mở trang truy xuất demo trên điện thoại, cho phép camera, đưa tem QR truy xuất vào khung và kiểm trang mở đúng mã. |
| J03-F02-T02 | Dùng cùng tem truy xuất. Phiên UAT đối chiếu mẻ, phát hành và tồn kho demo trước và sau khi quét. |
| J03-F02-T03 | Trình duyệt cần cho đổi quyền camera của trang. Từ chối để kiểm nhập mã tay, sau đó cho phép và bấm Dừng quét trước khi đọc mã. |
| J03-F04-T01 | Dùng Chrome hỗ trợ cài trang truy xuất. Chọn hồ sơ hoặc thiết bị chưa cài trang demo. Xác nhận hộp cài, mở trang từ biểu tượng hệ điều hành và tra lại cùng mã demo. |
| N07-F02-T01 | Mở PWA xưởng demo với vai R-PROD-OP, cho phép camera và dùng mẫu QR riêng của PWA. Kiểm mã, nguồn nhận diện và trạng thái nghiệp vụ sau quét. |

Một phiên UAT thực hiện tuần tự. Giữ năm ca ở Bị chặn đến khi có bằng chứng từng bước, cập nhật sổ và đọc lại M12-009, M12-105 sau từng lô.

## Lượt giao lại m12.248 · 27/11

Toàn giao Codex thao tác qua ChatGPT Extension trên Chrome. Máy Windows không nhận diện camera vật lý ở lượt rà thiết bị. Bốn ca quét chờ máy có camera và lab HTTPS/loopback phù hợp. Ca J03-F04-T01 đã xác định bản làm việc có manifest khai icon và route icon, còn chờ bàn giao lượt UAT để xác minh Chrome cài được ứng dụng, mở từ biểu tượng và tra lại mã demo. Khóa `@bo-kiem-du` còn thuộc `m12/uat-codex`. Chưa ghi kết quả thiết bị mới.
