# m8 → m34 · 12/11/2026 · Bảng chuẩn `delivery_area_short` cho 3.321 phường/xã M3 (việc A của lượt nối M8 thật)

Để sửa `OrderIvrCheckoutBridge.java:102` (đang gửi tên tỉnh trơn, M8 trả 422) và biết đúng sai bằng test, không chờ lượt thử. Commit local `a3e18502` trên `main` của
`ginsengfood-ivr` (W-0527, chưa push); tệp đã có sẵn ở `C:\Projects\ginsengfood-ivr`.

| Tệp | Việc |
| --- | --- |
| `C:\Projects\ginsengfood-ivr\deploy\m8\dia-ban-m3\README.md` | Đọc trước: dạng chuỗi, cách dùng, 8 trạng thái, ba tên bị từ chối |
| `C:\Projects\ginsengfood-ivr\deploy\reference-data\dia-ban-m3\dia-ban-m3.csv` | Bảng chuẩn: `ma_m3, ma_tinh, ten_phuong_xa_m3, ten_tinh_m3, delivery_area_short, mien, ket_qua, ly_do` (3.318 chấp nhận, 3 từ chối) |
| `C:\Projects\ginsengfood-ivr\deploy\m8\dia-ban-m3\kiem_dia_ban.py` | `doi-chieu`, `kiem`, `sinh --check`; Python 3.13 chỉ thư viện chuẩn |

## Dùng thế nào (hai cách)

1. Test đơn vị trong BP: đọc CSV làm bảng chuẩn, cho builder của M3 chạy từng `ma_m3`, so chuỗi. 3.318 ca phải khớp từng ký tự; ba mã bị từ chối builder phải trả rỗng (giữ đơn).
2. Xuất rồi so: builder ghi `ma_m3,delivery_area_short` cho mọi phường/xã ra CSV rồi `python kiem_dia_ban.py doi-chieu --tep <tệp>`; mỗi dòng in là một mã có vấn đề, thoát 0 khi sạch.

## Nhớ

- Dạng đúng: `<đơn vị> <tên phường/xã>, <đơn vị> <tên tỉnh/thành>`, đơn vị viết thường (`phường`/`xã`/`đặc khu`, `tỉnh`/`thành phố`), ví dụ `phường Cửa Nam, thành phố Hà Nội`.
- Đơn thiếu phường/xã: giữ ở M3, không gửi tên tỉnh trơn. `Order.java` hiện chỉ có snapshot tỉnh; `wardCode` đã có ở `OrderController.java:210`.
- Ba tên danh mục M3 M8 từ chối: `00378` (dấu chấm cuối), `00533` (nháy đơn đứng rời), `00555` (gạch dài). Sửa tên trong danh mục M3, chuẩn hoá khi dựng chuỗi, hoặc giữ đơn; sửa danh mục thì báo m8 để làm nóng lại cụm đó và sinh lại bảng.
- Bảng chưa được gọi thật tới M8 .61 (lượt thử một đơn mới là phép thử thật). Danh mục M3 đổi thì báo m8.

Phần còn lại phía M3 (cầu TLS callback, cấu hình be, mạng/NTP, tắt lớp giả lập) vẫn theo `deploy/m8/noi-m3/viec-m34.md`.
