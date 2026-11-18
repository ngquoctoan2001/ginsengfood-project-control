# Kết nối MISA AMIS Kế toán · việc nhờ chị Giang và chú Dũng · 17/11/2026

Gửi chị Giang (kế toán trưởng), chú Dũng · từ Tài (Toàn giao Tài làm đầu mối)

Hệ thống Ginsengfood sẽ tự đẩy chứng từ (bán hàng, xuất kho gửi bán, thu tiền, thu hộ COD, hoàn hàng, hoa hồng, voucher, quảng cáo, nhà phân phối) sang
AMIS Kế toán **một chiều**. Kế toán duyệt hai bước: duyệt trên Ginsengfood trước khi gửi, rồi vào AMIS bấm "Lập CT kế toán" từ đề nghị (chú chốt 17/11).
Tài làm chính. Mục tiêu 30/11: làm xong và chạy thử trên dữ liệu thử của AMIS. **Gửi lên sổ thật chỉ bật khi chị ký nghiệm thu.**

## 1. Việc em cần chị giúp sớm (chờ MISA duyệt nên làm ngay)

1. Chị cấp cho em một **tài khoản AMIS** để em làm việc với dữ liệu thử.
2. Em đăng ký ứng dụng kết nối trên trang nhà phát triển của MISA (`developer.misa.vn`, mục API AMIS Kế toán) để có **ClientID**, bật kết nối API trong
   AMIS, tạo một **dữ liệu thử** (bộ sổ riêng để thử, không đụng sổ thật) và lấy **mã kết nối** của dữ liệu thử. Bước nào cần quyền quản trị của công ty
   trên AMIS thì nhờ chị bấm giúp.
3. Trên dữ liệu thử, mở sẵn các tài khoản: 1555A–1555F, 6421_HOAHONG, 6421_VOUCHER, 6421_KHUYENMAI, 6421_VANCHUYEN, 6421_PHITHUHO, 6421_QUANGCAO,
   3388_VOUCHER. Em mở được thì em mở, chị coi lại giúp em là được.
4. Hai bên M1–M2 (sản xuất, kho) và M9 (bán hàng, tài chính) dùng **chung một ClientID**.

**Tài khoản AMIS, ClientID, mã kết nối là bí mật:** mình đừng gửi trong nhóm chat hay email nha chị, chị đưa riêng cho em. Mã của sổ thật sau này bên em
nhập thẳng vào máy chủ.

## 2. Câu hỏi kế toán (chị trả lời giúp em; câu nào chưa chắc thì cứ để mặc định, sau đổi được)

| # | Câu hỏi | Mặc định đang làm |
|---|---|---|
| 1 | Khoản giảm 2% khi khách chuyển khoản: ghi chiết khấu trên từng dòng hàng, hay một dòng chiết khấu thương mại riêng? | Chiết khấu trên từng dòng, giảm căn cứ tính VAT |
| 2 | Voucher điểm thưởng: có thể hiện trên hoá đơn không? Tất toán 3388_VOUCHER với 131 thế nào? Khách được trả lại voucher sau khi hoàn tiền thì ghi số âm hay đảo Nợ/Có? | Không lên hoá đơn; Nợ 3388_VOUCHER / Có 131 theo đơn; trả voucher thì đảo Nợ/Có |
| 3 | Hàng gửi đi bán (157): dùng kho riêng "Hàng gửi bán" (ĐVVC lấy hàng = chuyển kho; giao thành công = bán hàng kiêm xuất kho từ kho gửi bán), hay bỏ bước 157, xuất thẳng khi giao? | Kho riêng "Hàng gửi bán" |
| 4 | Hàng tặng khuyến mãi: dòng hàng tặng giá 0 trên chứng từ bán hàng có đủ thủ tục không? | Dòng giá 0, giá vốn vào 6421_KHUYENMAI |
| 5 | Nhà khởi nghiệp trên AMIS: dùng mã che (CTV-xxxxxx) hay tên thật + mã số thuế cá nhân (để quyết toán thuế TNCN)? | Mã che; kế toán tự bổ sung trên AMIS nếu cần |
| 6 | Khách chuyển dư tiền | Thu đủ số thực nhận, phần dư nằm Có 131; hoàn trả do kế toán ghi trên AMIS |
| 7 | Hoàn tiền một phần: phí vận chuyển, voucher xử lý thế nào? | Trả lại hàng bán theo dòng hoàn; phí vận chuyển không hoàn |
| 8 | Khách lẻ gộp theo kênh: đơn hàng hiện chưa ghi kênh bán (chỉ biết đơn 24/7 hay Giờ vàng). Chị cần chia đối tượng "Khách lẻ" theo gì? | Tạm hai đối tượng "Khách lẻ – 24/7", "Khách lẻ – Giờ vàng"; sau này có kênh thì tách thêm |
| 9 | Mã hàng dịch vụ và tài khoản doanh thu cho phí vận chuyển, phí thu hộ khách trả; đơn vị tính chuẩn | Kế toán tạo mã dịch vụ, chọn tài khoản |
| 10 | Chốt kỳ hoa hồng: một chứng từ mỗi kỳ hay mỗi người? | Một chứng từ mỗi kỳ, mỗi người hai dòng (phải trả sau thuế, thuế TNCN) |
| 11 | Phí ĐVVC cấn trừ vào tiền thu hộ: có hoá đơn GTGT không (để ghi 1331)? | Không ghi 1331 trừ khi có hoá đơn |
| 12 | Hoàn tiền cho khách: hệ thống có tự lập chứng từ chi hoàn tiền (Nợ 131 / Có 1121) và dòng đảo voucher không? | Có, tự lập; ngày = ngày chuyển tiền hoàn |
| 13 | Chứng từ về trễ (ví dụ hãng vận chuyển báo đối soát sau vài ngày): ngày chứng từ rơi vào kỳ chị đã khoá sổ trên AMIS thì xử lý sao? | Giữ ở trạng thái chờ, chị quyết; hệ thống không tự đổi ngày |
| 14 | ĐVVC lập hoá đơn phí vận chuyển riêng, không cấn trừ vào tiền thu hộ (phí công ty chịu, phí hai chiều đơn hoàn): hệ thống có cần tự lập chứng từ mua dịch vụ (Nợ 6421_VANCHUYEN, Nợ 1331 / Có 331) không? | Có, làm sau cùng; tới lúc đó chị tự lập trên AMIS |
| 15 | Đơn bán cho nhà phân phối (không qua ĐVVC): bán hàng kiêm xuất kho thẳng (Nợ 632 / Có 155x), không qua 157, được không? | Được |
| 16 | Quảng cáo: ghi Nợ 6421_QUANGCAO / Có 331 theo từng nhà cung cấp (Meta, Google), như chú chốt. Hiện số chi quảng cáo chưa ghi rõ nhà cung cấp | Hệ thống sẽ ghi thêm nhà cung cấp; số cũ chưa có thì tính là Meta |

## 3. Câu hỏi em gửi bên hỗ trợ MISA (chị biết sẵn câu nào thì trả lời giúp em luôn)

1. Đăng ký địa chỉ nhận kết quả (callback) ở đâu? Một ứng dụng đăng ký được mấy địa chỉ? MISA gửi lại mấy lần khi lỗi, gửi từ địa chỉ IP nào?
2. Xin một mẫu kết quả callback thật (để chốt tên các trường).
3. Callback báo thành công là "đã nhận đề nghị" hay "đã lập chứng từ"? Có cách nào lấy số chứng từ AMIS qua API không?
4. Gửi lại cùng một mã chứng từ gốc khi kế toán chưa lập chứng từ: AMIS cập nhật đề nghị cũ hay tạo trùng?
5. Giới hạn số chứng từ mỗi lần gửi, số danh mục mỗi lần, số bản ghi tối đa mỗi trang khi đọc, số lần gọi mỗi phút.
6. Token hết hạn sau 24 giờ hay 12 giờ?
7. Dòng hàng trên chứng từ bán hàng bắt buộc gửi mã nội bộ (GUID) của hàng hoá, hay gửi mã hàng là đủ?
8. Danh sách "nhóm hàng hoá dịch vụ" (`purchase_purpose_id`) cho dòng không có hàng (chứng từ khác, chi tiền gửi).
9. Một ClientID dùng chung cho dữ liệu thử và dữ liệu thật được không? Hai hệ thống (sản xuất và bán hàng) dùng chung một ClientID được không?
10. AMIS có tự tính giá xuất kho khi gửi phiếu xuất chỉ có số lượng, không có giá không? Chuyển kho sang kho "Hàng gửi bán" có tự tính giá không?
