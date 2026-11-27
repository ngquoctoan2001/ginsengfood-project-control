# M12-010 · Toàn tự đóng các vai cho một mẻ demo

Dùng lab demo tách biệt và gắn ghi chú **THỬ DEMO 27/11** trên các phiếu có ô ghi chú. Một người làm tuần tự, mỗi vai đăng nhập bằng tài khoản demo riêng. Kết quả ghi **diễn tập một người**. Biên bản mẻ thật và kết quả đầu-cuối M3 cần bằng chứng của lượt tương ứng. [Hồ sơ M12-054 và các việc đang chờ](../ra-soat/2026-11-27-noi-m3-thuc-hien.md)

## Làm ngay nếu chỉ muốn thử phần Lan

- Chọn một mẻ demo **Đã phát hành** còn đơn vị đóng gói chưa nhập. Bắt đầu ở [bước 7 nhập kho thành phẩm](#7-lan--nhập-kho-thành-phẩm-và-ghi-sổ), rồi đóng vai chú Dũng, Khánh và Lan theo thứ tự ký.
- Nếu muốn kiểm luôn kho nguyên liệu và kế toán, làm [bước 2](#2-lan--tạo-phiếu-và-tiếp-nhận-nguyên-liệu) và [bước 3](#3-khánh-rồi-lan--kcs-chấp-nhận-nhập-giá-và-đóng-phiếu). Khi muốn đi từ đầu đến cuối trên cùng một mẻ, thực hiện đủ các bước dưới đây.

## 1. Toàn · Chọn đúng lab, tài khoản và bộ dữ liệu

Lab cục bộ của lượt trước đã dừng, volume demo vẫn được giữ. Mở lại lab và xác nhận trước khi ghi phiếu. Có thể dùng một hồ sơ trình duyệt cho mỗi vai để giữ riêng phiên đăng nhập và hàng đợi PWA. Chỉ thao tác một vai tại mỗi thời điểm. Kiểm tên tài khoản ở góc màn hình mỗi lần đổi vai.

| Đóng vai | Tài khoản demo cần có quyền | Màn bắt đầu |
| --- | --- | --- |
| Toàn | Quản trị demo để xem vai và chuẩn bị danh mục | Quản trị › Hệ thống › Người dùng & Vai trò |
| Lan | Kho nguyên liệu, Kho thành phẩm và Kế toán tích hợp. Nếu lab tách tài khoản theo vai thì đổi giữa các tài khoản demo tương ứng. | Quản trị › Nguyên vật liệu hoặc Kho thành phẩm |
| Khánh | QC nguyên liệu, QC sản xuất, QA phát hành hoặc Truy xuất theo việc được giao | Quản trị › Lô nguyên liệu, Kiểm nghiệm KCS, Sổ QR |
| chú Dũng | Quản lý vận hành, Quản lý sản xuất và QA phát hành theo cấu hình lab | Quản trị › Lệnh sản xuất, Phiếu vận hành |
| Sang | Vận hành sản xuất và Đóng gói | PWA xưởng › Việc của tôi. Có thể dùng Quản trị › Lệnh đóng gói nếu vai demo có quyền. |

Xem **Hệ thống › Người dùng & Vai trò › Vai trò ký phiếu** trước khi bắt đầu để biết tài khoản demo nào được ký ô Trưởng ngày, QC, QA phát hành và Kế toán kho. Giữ riêng tài khoản tạo yêu cầu, tải bằng chứng và duyệt khi luồng yêu cầu tách người. Nếu một tài khoản đã ký một ô và form yêu cầu người khác, chuyển sang tài khoản demo đủ quyền cho ô kế tiếp. Dùng vai quản trị cho chuẩn bị, kiểm danh mục và ghi biên bản.

| Ô hoặc dữ liệu cần chuẩn bị | Điền hoặc chọn trong lab |
| --- | --- |
| Mã theo dõi | Ghi chú **THỬ DEMO 27/11**. Dùng cùng ghi chú để nhận diện xuyên suốt. Mã phiếu, lô và mẻ lấy từ màn hình sau khi lưu. |
| SKU và công thức | Chọn một SKU demo có G1/BOM đã duyệt, MRP hoàn tất và có bao bì phù hợp. **A2/CS/BASA** là ví dụ nếu lab có lượt MRP hoàn tất của SKU này. Giữ một SKU xuyên suốt. |
| Ca sản xuất | Chọn ca đang hoạt động. Khi lab chưa có ca, vào **Sản xuất › Ca sản xuất › Thêm ca**. Mẫu mã **DEMO_SANG**, tên **Ca sáng demo**, 07:00–11:00, thứ tự 1. Thêm **DEMO_CHIEU**, **Ca chiều demo**, 13:00–17:00, thứ tự 2 nếu muốn kiểm chọn ca. |
| Kho và vị trí | Chọn kho demo đúng loại **Nguyên liệu** và **Thành phẩm**. So loại và mã, vì tên hiển thị có thể giống nhau. Nếu thiếu vị trí, mở **Dữ liệu chính › Kho hàng › Vị trí kho › Thêm vị trí**. Mẫu tên **Kệ NL Demo A01** và **Kệ TP Demo B01**. |
| Nhà cung cấp và nguyên liệu | Chọn NCC demo đang hoạt động có thể cung ứng nguyên liệu đã chọn. Chọn nguyên liệu trong BOM của SKU nếu sẽ đi tiếp chuỗi. **Mì chính (ING_MI_CHINH)** là ví dụ khi có trong BOM và đơn vị là kg. Kiểm các nguyên liệu khác trong BOM đã có tồn sẵn sàng nếu muốn chạy đủ lệnh. |
| Vùng nguồn | Chọn vùng **demo đang hoạt động** phù hợp nguyên liệu từ danh sách, nhất là khi nhập trên PWA hoặc form yêu cầu. Mở lại lô để đối chiếu vùng nguồn sau lưu. |
| Phiếu nhập nguyên liệu mẫu | Tab **Mua ngoài**. Số chứng từ **DEMO-PN-2711-01**, mã lô nhà cung cấp **DEMO-NVL-2711-01**, đề xuất và thực nhận **10 kg**. Ngày giao là ngày tập. Hạn dùng lấy theo mẫu demo, ví dụ 27/12/2026 nếu ngày nhận là 27/11/2026 và mẫu cho phép. |
| QC và giá mẫu | Với bài loại một phần, **10 kg nhận = 8 kg đạt + 2 kg loại**, tạm giữ 0 sau khi xử lý xong. Đơn giá demo **10000 đồng/kg**, thuế mẫu **8%** nếu có trong danh mục demo. Chỉ dùng các giá trị này khi đơn vị trên dòng là kg. |
| Bằng chứng và thành phẩm | Chuẩn bị một ảnh và một video demo cho cổng QC, ảnh hàng nhận và ảnh kiện thành phẩm cho các phiếu có yêu cầu. Mục tiêu thử **6 hộp** nếu mẻ có 6 hộp thương mại hợp lệ. Mọi số lượng sản xuất và đóng gói khác theo kết quả của lệnh, không suy từ 10 kg mẫu. |

Nếu thiếu NCC demo, Toàn mở **Dữ liệu chính › Nhà cung cấp › Tạo nhà cung cấp**. Dùng tên **Nhà cung cấp Demo 27-11**, thư điện tử **ncc-demo-2711@example.invalid** và tên đăng nhập demo riêng nếu form yêu cầu. Tự đặt mật khẩu demo trực tiếp tại ô nhập. Trường liên hệ không bắt buộc để trống. Nếu chưa có liên kết cung ứng, thêm đúng nguyên liệu demo trong chi tiết NCC. Nếu thiếu dữ liệu nền khác hoặc tài khoản ký, ghi lại mục còn thiếu và chuẩn bị trong lab trước khi đi tiếp.

## 2. Lan · Tạo phiếu và tiếp nhận nguyên liệu

1. Mở **Nguyên vật liệu › Phiếu nhập nguyên liệu › Tạo phiếu nhận**. Chọn **Mua ngoài**, kho nguyên liệu, NCC demo, ngày giao và số chứng từ mẫu. Ở dòng hàng chọn nguyên liệu và kiểm ĐVT, nhập **Số lượng đề xuất = 10**, **Mã lô nhà cung cấp = DEMO-NVL-2711-01**, hạn dùng demo. Bấm **Tạo phiếu nhận** rồi ghi số phiếu hiển thị.
2. Nếu phiếu mới cần NCC xác nhận trước khi tiếp nhận, dùng xác nhận của tài khoản NCC demo hoặc luồng **Xác nhận hộ NCC** trên cùng phiếu với đúng vai và bằng chứng demo. Mẫu lý do **Xác nhận phiếu giao trong lượt diễn tập demo**. Lưu ảnh phiếu giao demo nếu màn yêu cầu. Chờ trạng thái **Chờ giao hàng**.
3. Trên phiếu chọn **Tiếp nhận**. Chọn **Vị trí nhận** nằm trong kho nguyên liệu. Nhập **Số lượng thực nhận = 10**, tổng **Số lượng lô = 10**, hạn dùng đã chọn. Kiểm mã lô NCC và chọn đúng vùng nguồn khi form hiển thị. Bấm **Xác nhận tiếp nhận**.
4. Ghi lại số lô vừa sinh. Ở **Lô nguyên liệu**, lô phải **Chờ QC**, tồn khả dụng của lô bằng 0 và phần nhận nằm ở chờ kiểm trong sổ. Nếu thử loại một phần, trên dòng phiếu chọn **Từ chối** 2 kg, chọn lý do chất lượng, ví dụ **DEMO loại 2 kg do lỗi cảm quan**. Chuyển vai Khánh.

Muốn tập riêng đường PWA, dùng một phiếu demo khác. Ở **Quét lô nguyên liệu**, mở đúng công việc, điền mã lô NCC và vùng nguồn, gửi hàng đợi rồi đối chiếu trạng thái đã gửi và lô mới. Trước khi dùng nút Tiếp nhận của Quản trị, kiểm xem phiếu đã được PWA áp dụng hay chưa.

## 3. Khánh rồi Lan · KCS, chấp nhận, nhập giá và đóng phiếu

1. **Khánh** mở **Nguyên vật liệu › Lô nguyên liệu**, lọc **Chờ QC**, chọn đúng lô của phiếu. Bấm **Ký QC**. Với mẫu loại một phần, đối chiếu lượng đã từ chối rồi điền **Số lượng nhận kiểm tra = 10**, **Số lượng đạt = 8**, **Số lượng tạm giữ = 0** và kiểm mục **Số lượng loại/thu hồi** khớp 2 kg theo form. Dùng kết quả **QC đạt** cho phần đạt. Nếu form đã tách lượng hoặc lô, đối chiếu theo từng bản ghi để tổng hai phần vẫn là 10 kg. Ghi **DEMO kiểm cảm quan, 8 kg đạt**. Kiểm thông báo **Đã ký KCS theo lô**.
2. **Lan** quay lại đúng phiếu, chọn **Chấp nhận** 8 kg còn lại và kiểm 2 kg loại không vào tồn khả dụng. Nếu muốn cấp vào sản xuất, **Khánh** hoặc vai demo được phép mở lô đã QC đạt, bấm **Đánh dấu sẵn sàng**. Kiểm **Có thể cấp = Có** và còn lượng khả dụng.
3. Với tài khoản **Lan có quyền kế toán**, chọn **Nhập giá** cho dòng chấp nhận, điền giá mẫu ở bảng trên. Với mẫu 8 kg × 10000 đồng/kg và thuế 8%, đối chiếu tạm tính 80000 đồng, thuế 6400 đồng, tổng 86400 đồng rồi lưu. Khi phiếu có lệnh hoặc biểu mẫu ký, hoàn thành các ô còn chờ theo ma trận. **chú Dũng** ký Trưởng ngày, **Khánh** ký QC, **Lan** ký Kế toán kho theo cấu hình demo.
4. **Lan** bấm **Đóng phiếu** nếu phiếu đủ điều kiện. Mở lại và kiểm trạng thái đóng, dòng 8 kg đạt, 2 kg loại, đúng kho/vị trí. Nếu còn báo thiếu giá, mở lại từng dòng chấp nhận. Nếu chưa thấy nút, kiểm đang ở tài khoản demo kế toán.

Dấu bàn giao cho sản xuất gồm số phiếu, số lô, kho/vị trí, lượng khả dụng và trạng thái **Sẵn sàng sản xuất**. Ghi lại trong ghi chú test nội bộ.

## 4. Chú Dũng và Sang · Tạo lệnh sản xuất, ca và thiết bị

1. Đóng vai **chú Dũng**, mở **Sản xuất › Lệnh sản xuất › Tạo lệnh sản xuất**. Chọn **MRP đã hoàn tất** của SKU demo đã chọn. Kiểm **Phiên bản công thức = G1**, loại công thức theo hồ sơ đã duyệt, **Lượng gạo neo** theo MRP. Nhập ngày kế hoạch và ghi chú **THỬ DEMO 27/11**. Lưu rồi ghi mã lệnh.
2. Nếu danh sách MRP trống, dùng lượt MRP đã hoàn tất trong fixture khác hoặc mở **Vận hành › Nhu cầu / MRP › Tạo nhu cầu**, chọn SKU, nguồn **Kế hoạch chủ quản**, đơn vị **hộp**, ưu tiên **Bình thường**, ngày cần và lượng kế hoạch demo đã chuẩn bị. Chốt FRM-01 với **Đưa lên bảng nhu cầu sản xuất**, hoàn thành phiếu nguồn, chốt công thức/bản chụp định mức và chạy MRP theo hồ sơ. Chọn lượng neo đã chốt trong chuỗi. Quay lại tạo lệnh khi lượt MRP đã hoàn tất. [Chuỗi thực hành trong giáo án](M12-010-bo-sang-27-11.md)
3. Trong lệnh kiểm **Bản chụp công thức** và nguyên liệu. **Gửi duyệt**, mở **Phiếu Lệnh sản xuất (FRM-11)**, chọn **Mở lệnh sản xuất** và ký ô **Trưởng ngày** bằng vai demo phù hợp. Mở lại lệnh, kỳ vọng **Đã duyệt**.
4. Đóng vai **Sang**, mở việc của lệnh, chọn đúng ca demo. Hoàn tất kiểm tra thiết bị của lệnh ở **Vận hành › Phiếu vận hành** theo hiện trạng mẫu. Nếu PWA hỏi ghép máy, quay sang tài khoản Toàn, vào **Hệ thống › Thiết bị xưởng › Cấp phiên thiết bị** cho tài khoản demo của Sang, rồi quay lại PWA ghép. Với bài đang thử trên máy tính, dùng nhập mã tay ở màn hỗ trợ và ghi rõ cách nhập.

## 5. Sang → chú Dũng và Khánh → Lan → Sang · Cấp nguyên liệu và công đoạn

1. **Sang** mở việc của đúng lệnh, tạo **Yêu cầu cấp**. Ở **Phiếu đề nghị cấp nguyên liệu**, kiểm bảng lượng dẫn từ lệnh, chọn kho nguyên liệu, kết luận **Đồng ý cấp** nếu đủ. Ghi **THỬ DEMO 27/11 – cấp theo lệnh**.
2. **chú Dũng** mở yêu cầu và duyệt ô Trưởng ngày. Trong **Phiếu chấp thuận nguyên liệu đưa vào sản xuất**, chọn đúng lô sẵn sàng, ưu tiên hạn dùng gần. Nhập **Số lượng duyệt** theo đề nghị và tồn từng lô. **Khánh** ký ô QC. Ghi trước lượng khả dụng để so.
3. **Lan** mở **Nguyên vật liệu › Xuất kho**, chọn phiếu xuất sinh từ yêu cầu đã duyệt. Kiểm lệnh, kho, lô, đơn vị và lượng. Bấm **Xuất kho** khi đã đủ chữ ký yêu cầu. So sổ kho giảm đúng lượng đã xuất.
4. **Sang** mở **Việc của tôi / Ghi sản xuất**, quét hoặc nhập mã lô hỗ trợ, kiểm đúng lệnh/mẻ và nhập số đo, lượng, giờ theo dữ liệu thử của công đoạn. Tại cổng QC, **chú Dũng** tải ít nhất **1 ảnh + 1 video demo**, gửi duyệt. **Khánh** duyệt gói từ tài khoản khác người tải. Mở phiếu công đoạn, hoàn thành ô **Trưởng ngày** và **QC** rồi quay lại **Sang** kiểm bước kế đã mở.
5. Khi mẻ đã qua đủ công đoạn theo lệnh mẫu, ghi mã **mẻ/lô sản xuất** để dùng chung cho đóng gói, QC và nhập kho.

## 6. Sang → Khánh → chú Dũng/QA phát hành · Đóng gói, QC và phát hành

1. **Sang** mở **Đóng gói & in tem › Lệnh đóng gói › Tạo lệnh đóng gói**. Chọn đúng **Mẻ**, **Cấp đóng gói = Hộp**, thương phẩm GTIN được gợi ý, lô bao bì đã duyệt, và nhập kế hoạch **6** nếu mẻ đủ 6 hộp. Bắt đầu lệnh, ghi số thực đóng, hoàn tất các phiếu đóng gói và ký theo ma trận. Nếu đi tiếp cấp thùng thì chọn **hộp** làm nguồn đóng thùng. Mở **Sổ QR** và sinh/gán QR theo quy trình demo. Nếu thiết bị in đang hoãn, ghi trạng thái **Chờ in** thực tế.
2. **Khánh** mở **KCS & Phát hành › Kiểm nghiệm KCS** hoặc tạo phiếu từ chứng từ đóng gói theo đường trên màn. Chọn **Thành phẩm**, đúng mẻ và các tiêu chí QC hiện hành. Điền số đo/kết quả theo mẫu demo, đủ tài liệu và hai ô ký **Trưởng ngày + QC** nếu form yêu cầu. Kiểm phiếu QC thành phẩm đã đạt và đã ký.
3. Mở **KCS & Phát hành › Phát hành lô**. Tạo yêu cầu với ghi chú **Phát hành mẻ diễn tập 27/11**. Trong **FRM-21** kiểm các điều kiện, chọn **Phát hành lô**, tải bằng chứng demo, gửi một tài khoản demo khác duyệt, rồi **Gửi xác nhận**. Ký **Trưởng ngày** và **QA phát hành** theo ma trận. Dùng tài khoản QA được cấp hợp lệ khác với người tạo yêu cầu khi màn chặn. Vai demo của chú Dũng có thể làm QA phát hành khi được gán đúng.
4. Mở lại mẻ và đợi thấy **Đã phát hành** trước khi chuyển cho Lan. Nếu chưa đạt điều kiện tem, QC hay bằng chứng, quay về đúng màn xử lý mục còn thiếu.

## 7. Lan · Nhập kho thành phẩm và ghi sổ

1. Mở **Kho thành phẩm › Nhập kho › Tạo phiếu nhập**. Chọn **Mẻ đã xuất xưởng**, **Kho thành phẩm** đúng loại và vị trí thuộc kho đó nếu có ô nhập. Điền ghi chú **THỬ DEMO 27/11 – nhập kho thành phẩm**. Chọn các **Đơn vị đóng gói** của mẻ. Nếu tem đang **Chờ in**, dùng danh sách chọn tay theo quy trình hoãn in. Màn tự điền số lượng và UOM theo đơn vị đã chọn. Kiểm tổng, ví dụ 6 hộp khi đã chọn đúng 6 hộp. Bấm **Tạo phiếu nhập kho**, ghi số phiếu. Lúc này phiếu **Chờ xác nhận**.
2. Chụp hoặc ghi số **Tồn theo SKU** và tồn của chính lô **trước chữ ký cuối**. Từ phiếu nhập mở **Tiếp tục hoàn thiện lệnh nhập kho thành phẩm (FRM-22)**. Bấm **Cập nhật trường nhập/chọn**, so lượng đề xuất và điền **Số thực nhập** theo số thực nhận từng dòng, bấm **Lưu bảng nhập kho**. Chọn **Kết luận = Cho nhập kho** nếu đủ điều kiện, kiểm tham chiếu QC.
3. Tải ảnh kiện demo, lưu nháp, **Gửi duyệt bằng chứng**. Đổi sang tài khoản demo khác có quyền để **Duyệt bằng chứng**, rồi **Gửi xác nhận**. Mở cùng mã FRM-22 theo lượt **chú Dũng ký Trưởng ngày → Khánh ký QC → Lan ký Kế toán kho**. Trước khi ký cuối kiểm lần nữa đúng mẻ, kho, lượng và UOM.
4. Sau lần ký cuối, mở lại phiếu. Kỳ vọng FRM-22 và phiếu nhập **Đã xác nhận**, có **một dòng ghi tăng** đúng lượng vào lô và kho trong **Sổ cái tồn kho**. Nếu số trước là Q và nhập 6 hộp, tồn ghi sổ là Q + 6 hộp khi không có bút toán khác. Ghi riêng **tồn khả dụng**, vì số này phụ thuộc tạm giữ, giữ hàng và điều kiện lô. Nếu phiếu đã Đã xác nhận, kiểm sổ thay cho bấm xác nhận thêm.
5. Ghi vào biên bản **diễn tập** dòng 7 gồm số phiếu, mã mẻ, SKU, kho, số nhận, UOM, tồn trước/sau, giờ và người kiểm theo vai. Dòng tập huấn ghi rõ Toàn tự đóng vai Lan.

## 8. Khánh và Toàn · Truy xuất và kiểm bán được

1. **Khánh** mở **Truy vết › Tìm truy xuất / Phả hệ lô**, đối chiếu nguyên liệu → mẻ → hộp và chiều ngược lại. Trong lab, nếu cần kiểm trang truy xuất, **chú Dũng** chuẩn bị nội dung mẫu đã duyệt, **Khánh** dùng **Sổ QR** và thực hiện thao tác công khai trong môi trường thử theo quyền. Ghi mục thiếu nếu màn báo trạng thái QR, ngày sản xuất, hạn dùng, nội dung hoặc vùng nguồn.
2. **Toàn** mở **Vận hành › Sản phẩm / Điều kiện bán** và chọn SKU demo. Nếu đã có bản kích hoạt hợp lệ, dùng bản đó. Nếu cần tạo, điền phiên bản demo, mã phê duyệt của hồ sơ demo, mã bằng chứng **đã duyệt** và người kiểm toán demo. Chọn **Chờ sẵn sàng** khi chuỗi còn thiếu, chuyển **Đã kích hoạt** theo đúng điều kiện hiển thị. Sau đó kiểm riêng quyết định bán được và từng lý do chặn.
3. **Lan** cung cấp số tồn khả dụng trên đúng SKU và kho. Nếu lab M3 có kết nối quan sát, nhờ Phúc so hai lượt S02/S03 trên cùng SKU, kho, UOM. Ví dụ khi **tồn khả dụng cho cổng bán là 6 hộp**, hỏi **2 hộp** cho S02 và **7 hộp** cho S03. Nếu tồn khác, lấy lượng dương trong giới hạn và một lượng vượt tồn theo số vừa đo. Ghi thời điểm, bản hai bên, lượng hỏi, quyết định, lý do và chênh lệch. Lượt quan sát dùng để hỏi khả dụng, không tạo đơn.
4. Kỳ vọng S02 nhận **SELLABLE**, S03 nhận **NOT_SELLABLE / STOCK_NOT_AVAILABLE** nếu lý do duy nhất là thiếu tồn. Nếu M3 chưa có lab chung, ghi **kiểm demo M12** và để lượt đối chiếu M3 chờ Phúc. Bản M3 đang phục vụ chỉ thực hiện đối chiếu mẻ thật khi Toàn giao phạm vi riêng. [Bảng S01–S18](../ra-soat/2026-11-27-noi-m3-thuc-hien.md#bảng-nghiệm-thu-s01s18)

Nếu muốn tập thêm bài giữ hàng của Lan, dùng fixture giữ hàng riêng trong lab. Theo SOP kho, đọc bốn trạng thái **Đã giữ hàng, Đã xác nhận, Đã xuất bán, Đã nhả giữ**. Vai kho xem tồn và xác nhận khi có yêu cầu soạn. Khi thử xuất bán theo phân bổ demo, vai Lan lập và áp dụng, vai có quyền khác duyệt. Đây là bài riêng với mẻ trên.

## Các việc tiếp theo ngoài buổi tập

| Việc | Toàn hoặc Phúc cần làm |
| --- | --- |
| Biên bản mẻ thật và M12-054 | Khi chạy mẻ thật theo kế hoạch riêng, Lan xác nhận số nhập kho dòng 7, Phúc đối chiếu đủ/thiếu tồn ở dòng 9. Cùng S02/S03, ghi đúng mốc và phiên bản. Hồ sơ thực tế lưu nội bộ. |
| M12-094 và webhook | Phúc xác nhận kho thành phẩm đã nối, gửi CSV liên kết đang dùng qua kênh nội bộ, xác nhận bên nhận webhook và người trực. Dùng kết quả kiểm 19 mã và S16 khi đủ điều kiện. |
| Chuyển Production | Toàn chốt giờ, phạm vi kiểm P0 và lệnh P1–P7 riêng. Toàn xác nhận JWT mới khác lịch sử, cùng Anh Tuấn chốt TLS và báo Phúc gián đoạn dự kiến 1–2 phút. Nhật ký P0 cũ có một ảnh thử bản rõ, cần xác định phạm vi nếu ảnh còn. |
| Tự nhả và NK-b | Giữ chế độ quan sát. Sau kết quả mẻ thật và diễn tập, Toàn quyết riêng phạm vi bật tự nhả và quyết định GO cho giữ/nhả thật. |
| Lịch giám sát | Khi Toàn muốn tạo lịch, giao rõ **go m12.242**, phạm vi đọc và người trực. Kiểm thông báo thử đến trong 15 phút theo hồ sơ. |
| Phân loại chay | Toàn và chú Dũng xác nhận công thức thật từng mã A1, B1, C2, C3 rồi chốt hướng cho DIET-2. |
| Xoay token và ký | Toàn chốt thứ tự SEC-11 so với chữ ký M12-060. Lịch xoay đang dời sau 30/11, kế hoạch bảo mật đặt bước này trước chữ ký. |
| Các ca thiết bị | Năm ca thiết bị còn trong sổ UAT đã dừng. Ghi riêng nếu Toàn mở lại lượt camera và cài trang truy xuất. [Checklist thiết bị](../ra-soat/2026-11-27-chot-ca-uat-bi-chan.md) |

## Tin nhắn để Toàn gửi Phúc

> Phúc ơi, anh đang chạy thử luồng từ nhập kho tới kiểm bán được. Em coi dùm anh bên M3 đang chạy bản nào, có đang ở chế độ quan sát không. Khi anh báo đã có tồn trên lab chung, em hỏi dùm anh hai lượt cùng mặt hàng, kho và đơn vị, một lượt đủ tồn, một lượt vượt tồn. Gửi anh kết quả với giờ kiểm nghen. Em gửi thêm file liên kết mặt hàng và kho đang dùng, rồi báo anh ai trực và bên nào nhận thông báo từ M12 khi chuyển bản. Mình chỉ kiểm tồn, chưa tạo đơn hay giữ hàng.

## Nguồn thao tác

[Kịch bản và phân vai 27/11](M12-010-bo-sang-27-11.md) · [Biên bản mẻ thật và các dòng bàn giao](M12-010-bien-ban-27-11.md) · [Hồ sơ 28 việc và các cổng còn mở](../ra-soat/2026-11-27-noi-m3-thuc-hien.md). Trong ops-core, đối chiếu GA-2711, HDSD-OPS-01 mục 23.2, 23.5–23.16, 25.7, 25.12, 25.35, 26.5, 28.9, 29.2–29.5, và SOP kho giữ hàng M3 mục 5–6.
