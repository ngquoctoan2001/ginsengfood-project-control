# Cổng production chung

Thang, mốc và luồng khách lấy đúng theo quy trình báo cáo tuần của Lead
(`tools/task-tracker/bao-cao-tuan/README.md` trong mọi repo module; bản gốc ở repo M3/M4). Hai nơi phải khớp nhau;
lệch thì README quy trình báo cáo thắng và tệp này được sửa theo.

## 1. Thang sẵn sàng

Mỗi hạng mục ghi đúng một bậc: bậc cao nhất đã có bằng chứng. Không ghi số ngoài thang.

| % | Bậc | Bằng chứng tối thiểu |
|---|---|---|
| 0 | Chưa làm | — |
| 10–40 | Đang làm | có commit; ước trong khoảng theo phần chức năng con đã xong, ghi cơ sở ước |
| 50 | Xong mã | kiểm tự động đạt (lớp 1): lệnh + kết quả |
| 75 | Chạy thử được | đã vào nhánh chung, chạy trên máy chủ chạy thử, thao tác như người dùng thật và đạt (lớp 2) |
| 90 | Nghiệm thu | Lead hoặc chủ dự án tự thao tác theo phiếu và ghi đạt (lớp 3) |
| 100 | Chạy thật | đang phục vụ khách hoặc xưởng thật |

- Chỉ gọi là "xong" khi đủ 3 lớp kiểm chứng.
- % module = trung bình theo trọng số các hạng mục, tổng trọng số 100; giữ trọng số giữa các tuần, đổi thì ghi lý do.
- Tiến độ quy trình (số task/WP xong) **không phải** % sẵn sàng. Nhắc tới thì ghi rõ "tiến độ quy trình".

## 2. Mốc chung

| Mốc | Ngày | Điều kiện đạt |
|---|---|---|
| A. Xong chức năng | T7 07/11 | mọi việc lớn ≥ 50%, đã gộp nhánh chung và lên máy chủ chạy thử |
| B. Nối liên module | T3 10/11 | chạy thử đầu-cuối các luồng khách trên máy chủ chạy thử (75%) |
| C. Nghiệm thu | T5 12/11 | Lead và Chú nghiệm thu theo phiếu, lỗi chặn đã sửa (90%) |
| D. Lên chạy thật | T7 14/11 | bản đã nghiệm thu lên máy chủ thật, chạy thử nhanh, có cách quay lui |
| Bàn giao | CN 15/11 | vận hành thật |

Không kịp một mốc → `SAN_SANG.md` phải có: phần không kịp, vì sao, ngày mới, **bản tối thiểu chạy được 15/11**.

## 3. Cổng trước khi chạy thật (dùng để tìm việc lớn bị sót)

| Cổng | Đạt khi |
|---|---|
| G1 Chức năng lõi | mọi hạng mục lõi ≥ 90 |
| G2 Liên module | hợp đồng API/sự kiện khớp với module láng giềng; chạy thử với module thật hoặc giả lập đúng hợp đồng |
| G3 Bảo mật | không bí mật trong repo; mọi đường vào có xác thực/phân quyền; tin báo từ đối tác có kiểm chữ ký; giới hạn tần suất đường công khai |
| G4 Dữ liệu | migration chạy sạch từ rỗng và từ bản đang chạy; sao lưu + khôi phục đã thử; môi trường thử không dùng dữ liệu khách thật |
| G5 Triển khai | đúng `C:\Projects\deploy\MODULE_DEPLOY_CONTRACT.md`: một container, `GET /health`, không chạy root, cấu hình qua biến môi trường; chạy được trên máy chủ chạy thử |
| G6 Vận hành | log có mã tương quan, cảnh báo lỗi, runbook (bật/tắt, sự cố, quay lui), công tắc tắt khẩn cho tính năng rủi ro |
| G7 Kiểm thử | CI xanh trên đúng bản sẽ lên; phiếu nghiệm thu viết sẵn và đã chạy; thử tải cơ bản |
| G8 Ngoài code | tài khoản, quyền, hợp đồng đối tác, pháp lý: mỗi việc có người đi gỡ + ngày cần có, xong trước mốc D |

Thứ tự bật module khi lên chạy thật (theo deploy contract): M3 và M5 trước, M6 sau cùng.

## 4. Luồng khách đầu-cuối

Chú yêu cầu thử từng loại khách (khách mới, Silver, Gold…).

| # | Bước | Module | Phụ thuộc chính |
|---|---|---|---|
| 1 | Xem video Giờ Vàng | M7 | M3 mở phiên Giờ Vàng; M2 kiểm còn hàng |
| 2 | Nhắn Messenger hoặc bình luận | M5 | Facebook duyệt ứng dụng, quyền Page |
| 3 | AI tư vấn | M4 | endpoint M4 cho M5; catalog M3 |
| 4 | Đặt hàng trên web | M3 | — |
| 5 | Gọi xác nhận | M8 | API đơn + tin báo của M3; nhà mạng; giấy chứng nhận định danh tên công ty |
| 6 | Thanh toán | M3 (VNPAY) | VNPAY cấp thông số chạy thật |
| 7 | Vận chuyển | M3 (GHN, Viettel Post) | tài khoản hãng |
| 8 | Chăm sóc sau mua | M4, M5 | — |
| + | Kho, nhà máy giữ và trừ hàng | M1–M2 | tích hợp M3 |
| + | Đo quảng cáo | M6 | chỉ tính doanh thu đơn đã xác minh từ M3 |

## 5. Không bao giờ

- Gọi module là "sẵn sàng chạy thật" khi chưa qua mốc C và G1–G8.
- Nâng bậc khi chưa có bằng chứng đúng bậc.
- Tính % bằng số task xong.
