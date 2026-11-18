# Hướng dẫn: Toàn tự thao tác để "Nối với M3" lên bậc 90

Trạng thái: CHỜ TOÀN CHẠY · soạn 14/11/2026 23:0x (phiên m8), mục 3 do m34 soạn (bước giao diện chưa ai bấm thử)

## 1. Vì sao cần

Hạng mục "Nối với M3" đang ở bậc 75 (`SAN_SANG.md`): mọi ca nghiệm thu trên .99 (W-0540) do phiên AI thao tác, Toàn duyệt từng lượt.
Bậc 90 cần **chính Toàn** (hoặc Chú) làm như người dùng thật theo phiếu `deploy/m8/nghiem-thu-m3/phieu-e01-e10.md`,
rồi ký ô "Người M3 xác nhận". Phiên AI chỉ làm phần máy (bật/tắt lịch gọi, đối soát) khi Toàn bảo.

## 2. Ca Toàn tự làm (khoảng 45 phút, MOCK, không gọi khách thật)

| Ca | Toàn làm | Phiên m8 làm khi Toàn bảo | Đạt khi |
| --- | --- | --- | --- |
| E02 | Đặt 1 đơn thử trên web bán hàng .99 (mục 3). Mở trang quản trị M3, thấy đơn ở trạng thái chờ xác nhận. | Bật lịch gọi M8; đợi cuộc gọi MOCK "bấm 1"; tắt lịch; đối soát `doi_soat_m3.py`. | Trên trang quản trị M3 đơn chuyển "đã xác nhận" đúng một lần; đối soát `KHOP`. |
| E03 | Đặt 2 đơn thử. | Đặt worker MOCK: đơn thứ nhất "bấm 1", đơn thứ hai "bấm 0"; bật lịch; đối soát. | Một đơn "đã xác nhận", một đơn "khách huỷ" trên trang quản trị M3; đối soát `KHOP` 2/2. |
| E07 (từ 16/11) | Đăng nhập trang quản trị M3 bằng ba tài khoản: chỉ xem, được duyệt, quản trị; mở mục IVR bằng từng tài khoản. | Không có việc trên máy; ghi lại kết quả. | Tài khoản chỉ xem thấy danh sách, không có nút thao tác; tài khoản được duyệt có nút duyệt; không ai có thao tác nguy hiểm (không đặt người quyền cao, D-m8-108). |
| E08 (từ 16/11) | Mở màn hình vận hành IVR trên trang quản trị M3, bấm làm mới. | Tạo một lỗi giả có kiểm soát theo phiếu (ví dụ dừng cầu callback 1 phút) rồi phục hồi. | Màn hình báo lỗi rõ khi có sự cố, tự trở lại bình thường sau khi phục hồi. |

E07, E08 chỉ làm được sau khi bật quản trị IVR trên .99 ngày 16/11 (D-m34-082, D-m8-108). E02, E03 làm được ngay.

## 3. Cách đặt đơn thử trên web (.99) — m34 soạn 14/11 23:1x

m34 soạn theo mã M3 đang chạy trên .99 (`toandeptrai` `afb6d404c`). Hôm nay các đơn thử đều đặt bằng script qua API, **chưa ai bấm tay
trên web .99**, nên các bước giao diện dưới đây CHƯA KIỂM. Lần đầu làm, Toàn ghi lại chỗ nào khác.

1. **Giờ:** 08:00–21:08. Trước khi đặt, bảo phiên m8 bật lịch gọi. Với E03 (đơn "bấm 0"), phiên m8 đặt kịch bản MOCK cho đơn đó trước.
2. **Web:** `http://192.168.1.99/` → trang sản phẩm → Thêm vào giỏ → Giỏ hàng → Đặt hàng. Không đăng nhập (khách vãng lai),
   chương trình 24/7 (không phải Giờ Vàng), số lượng 1. Sản phẩm: script dùng SKU lab `DEMO/P3/SALE/BASELINE`; nếu cửa hàng không
   hiện sản phẩm này thì chọn một sản phẩm đang "còn hàng" (đơn đó vào đợt dọn đơn thử trước 30/11).
3. **Số điện thoại:** số thử m34 đưa trực tiếp cho Toàn (không ghi vào tệp này). Mỗi đơn một số chưa từng đặt đơn: khách đã có đơn
   hợp lệ thì đơn COD được miễn gọi, không sang IVR.
4. **OTP:** .99 dùng SMS giả có bật hiện mã: ở bước nhập mã, mã 6 số hiện ngay trên màn hình. Xin lại mã cùng số phải chờ 60 giây.
5. **Địa chỉ giao:** Hà Nội / Hà Đông (mã xã `00013`, như script). Đừng chọn xã có chữ "đường" trong tên: 8 xã đó đi luồng nhân viên
   xác nhận, không sang IVR (D-m34-061/081).
6. **Thanh toán:** COD → Đặt hàng.
7. **Nhận biết đơn đã sang IVR:** trang quản trị M3 `/admin/orders` → mở đơn. Đơn ở trạng thái `CONFIRMING`, chi tiết đơn có khung
   xác nhận IVR với câu "Đơn đang thuộc luồng xác nhận tự động…", **không** có nút "Xác nhận IVR"/"Từ chối IVR" (hai nút này chỉ có ở
   đơn đi luồng nhân viên). Kết quả cuộc gọi về thì đơn đổi trạng thái đúng một lần (E02 xác nhận, E03 huỷ).
8. **Đơn treo:** admin không huỷ tay được đơn đi IVR (`CONFIRMATION_ROUTE_NOT_ALLOWED`); watchdog tự huỷ sau khoảng 16,5 phút từ lúc
   tạo đơn.

## 4. Ký nhận

| Ca | Ngày giờ | Kết quả | Toàn ký (người thao tác) | Người M3 xác nhận |
| --- | --- | --- | --- | --- |
| E02 | 17/11 | DỜI: web .99 chưa đặt được đơn (chưa tên miền, chưa VNPAY); lịch bật 07:38–08:15 không task, `tra-lai` DAT | — | — |
| E03 | 17/11 | DỜI (như E02) | — | — |
| E07 | 17/11 sáng | ĐẠT: chỉ xem không có nút thao tác, được duyệt có nút duyệt, quản trị không có thao tác nguy hiểm/kiểm toán/xuất | Toàn xác nhận trong phiên m8 17/11 08:3x ("Đúng cả") | — |
| E08 | 17/11 08:18:07–08:19:37 | ĐẠT: lúc dừng màn duyệt "Chưa tải được dữ liệu IVR", màn giám sát "Mất dữ liệu giám sát IVR"; sau bật "Tải lại" có dữ liệu, giám sát tự hồi (log: 200 sau 43 s); `capabilities` 200 suốt; hàng đợi M8 không đổi | Toàn xác nhận trong phiên m8 17/11 08:3x ("Đúng cả") | — |

Xong bốn ca và ký đủ thì phiên m8 ghi bằng chứng W mới, nâng "Nối với M3" lên 90 trong `SAN_SANG.md` và trình phiên `lead` đối chiếu.
Còn E04 (M3 chưa có thao tác gửi lại) và E09 (chưa có endpoint 9443) không chặn bậc 90 của bản hiện tại; ghi `NOT_RUN` có lý do.
