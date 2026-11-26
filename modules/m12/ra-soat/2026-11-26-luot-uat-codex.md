# M1–M2 · Lượt UAT cục bộ 26/11/2026

- Bản kiểm `d4163331ce9804f625c81bc448a23a2298f757b4`. Phiên này giữ `@bo-kiem-du`. Hai sub-agent chỉ đọc hồ sơ fixture và sổ; phiên chính điều khiển trình duyệt và chạy lần lượt.
- Sổ lúc vào lượt có 2.870 dòng kết quả. Hai kết quả dưới được nối ở dòng 2.871–2.872, vòng `UAT468-L01-Codex-26/11`. Đã đối chiếu 2.870 dòng trước bằng byte.

| Mã | Kết quả | Quan sát trên trình duyệt tích hợp |
|---|---|---|
| A01-F03-T03 | Đạt | Cửa sổ chưa đăng nhập mở `/admin/dashboard`, chuyển về `/login`, hiển thị tiêu đề Đăng nhập. Mở lại cho cùng kết quả. |
| A02-F03-T03 | Đạt | Cửa sổ chưa đăng nhập mở `/admin/account`, chuyển về `/login`, hiển thị tiêu đề Đăng nhập. Mở lại cho cùng kết quả. |

Phạm vi hai ca là chuyển hướng ẩn danh trên admin-web `127.0.0.1:3204`. Các ca không cần phiên người dùng, dữ liệu nghiệp vụ hoặc API. Next dùng bộ nạp loại trừ tệp `.env*`; đã dừng tiến trình và trả lại hai tệp cấu hình Next tự ghi đúng byte Git. Quan sát thêm một cảnh báo tên truy cập của Input ở chế độ phát triển; chưa kết luận lỗi ca nào từ cảnh báo này.

## Kiểm truy xuất công khai, lô L18

API build đúng commit với 0 cảnh báo, 0 lỗi. DB dùng một lần tái tạo từ template demo UAT; bản migrate có cùng cây migration với commit API, nâng từ 149 lên 160. API và trang truy xuất chỉ bind loopback. Kiểm thấy `/health/live` trả 200. Thông tin kết nối và ký của lab sinh riêng trong tiến trình, không ghi vào hồ sơ. Dòng 2.873–2.874 có vòng `UAT468-L18-Codex-26/11`.

| Mã | Kết quả | Bằng chứng và đối chiếu |
|---|---|---|
| J03-F01-T02 | Đạt, cập nhật catalog | Bỏ trống bị chặn. Mã không tồn tại và QR `QUEUED` chưa in cùng hiển thị “Không tìm thấy thông tin”, đúng quy tắc che sự tồn tại của mã chưa in. Kiểm thêm QR `PRINTED` tắt công khai, hiện “Chưa có thông tin công khai”. Đối chiếu các trạng thái trong DB lab chỉ đọc. |
| J03-F01-T04 | Đạt, cập nhật catalog | Dán URL QR thử đã in và công khai, chuyển đúng đường dẫn mã. Mã lô và trạng thái “Đã xuất xưởng” khớp lần nhập trực tiếp và bản ghi mẻ `RELEASED` trong DB lab. Catalog đang mô tả hành vi URL cũ. |
| J03-F01-T01 | Đã quan sát một phần, chưa vào sổ | Tra mã trực tiếp hiện đúng lô thử và “Đã xuất xưởng”, QR hiện “Mã truy xuất hợp lệ”. Còn đối chiếu nhãn catalog và màn nội bộ J02 theo vai. |

## Điểm dừng và bàn giao máy

- Đã đọc lại sổ sau ghi: **2.326 ca = 1.814 Đạt, 0 Không đạt, 59 Không áp dụng, 453 chưa chạy**. Tăng 4 ca Đạt (2 L01 và 2 L18). Còn 106/108 ca trong sáu lô ưu tiên. Phiên này chưa thay Sheet.
- Tạm nhường lượt duy nhất cho phiên Production thực hiện m12.243b. Đã dừng Next admin/truy xuất và API, tháo container/network dùng một lần của lab. Cổng 3203, 3204, 5200 và 55439 không còn listener. Giữ template demo và artifact build để tạo lại lab sau bàn giao. Đã trả đúng byte các tệp cấu hình mà Next tự ghi. Cây ops-core còn các tệp supplier-portal dở của phiên khác.
- Sau khi nhận lại lượt, tạo lại DB demo, cấp tài khoản thử theo vai và ghép phiên thiết bị PWA. Ưu tiên tiếp L12, L14–L18. Ca quét QR, cài trang và media còn cần capability hoặc fixture tương ứng.

## Lượt kế tiếp, 106 ca theo danh sách Toàn giao

Đọc lại sổ rồi đối chiếu từng mã catalog. J03-F01-T02 và J03-F01-T04 đã Đạt, loại khỏi hàng đợi. Các số dưới đây là danh sách vào lượt, trước khi có kết quả mới.

| Lô | Ca còn | Dữ liệu và vai dùng để gom lượt |
|---|---:|---|
| L12 | 23 | 11 admin, 2 NCC, 10 PWA. Gom cặp lô 10 kg trước/sau QC, chứng từ nhập và sổ kho. Hai thao tác gán vị trí cần hai dòng tồn riêng chưa có vị trí. |
| L14 | 14 | Công việc xưởng trong phiên thiết bị ghép. Tách dữ liệu xuất và nhận vật tư theo trạng thái, kiểm nhánh ngoại tuyến sau khi có công việc tải sẵn. |
| L15 | 24 | Công việc đóng gói L1/L2, QR đúng và khác công việc, báo sự cố và yêu cầu in lại mô phỏng. Giữ mỗi ca ghi trên công việc có trạng thái phù hợp. |
| L16 | 10 | Phiên thiết bị QC, mẻ sau sấy và thành phẩm. Tách ký đạt, thiếu lý do HOLD/REJECT và gửi lại. |
| L17 | 13 | 8 admin, 5 PWA. So phiếu thành phẩm xác nhận/chờ ký; cần số dư theo lô, bản ghi giữ và lịch sử nhả hết hạn. |
| L18 | 22 | 14 admin, 8 công khai. Dùng một chuỗi demo cho tìm kiếm/phả hệ và QR công khai; hồ sơ thu hồi, mã vận đơn, media, quét camera và cài ứng dụng cần đúng tiền điều kiện. |

Phiên Production giữ `@bo-kiem-du` lúc chuẩn bị danh sách. Trong thời gian chờ, hai sub-agent chỉ đối chiếu catalog và fixture. Không có kết quả mới trong thời gian nhường máy.
