Gửi Anh Tuấn · 14/11/2026 · từ Toàn

Việc: nginx cổng vào chuyển `ginsengfood.vn` và `www.ginsengfood.vn` (cả đường `/admin`) về máy mới `192.168.1.99` cổng 80,
thay cho `192.168.1.60` cổng 80. Web trên .60 đã tắt từ 07:36 sáng 14/11.

Vì sao: web bán hàng (M3/M4) đã chuyển hẳn sang .99; dữ liệu và tệp đã đối chiếu khớp. Phía .99 đã sẵn cho tên miền
(đăng nhập, đặt hàng qua `https://ginsengfood.vn` đã thử được từ 08:24).

Cần làm:
1. Trong khối đang chuyển hai tên miền đó, đổi IP đích `192.168.1.60` thành `192.168.1.99`; cổng 80 và đường dẫn giữ nguyên.
2. Trong cùng khối, đặt hai dòng:
   ```nginx
   proxy_set_header Host $host;
   proxy_set_header X-Forwarded-For $remote_addr;
   ```
   Dòng thứ hai phải ĐẶT bằng `$remote_addr`, không dùng `$proxy_add_x_forwarded_for` (nối). Nginx trên .99 tin header này từ
   máy trong LAN 192.168.0.0/23 để lấy IP khách cho giới hạn tần suất; nếu nối thì khách tự gửi header giả là qua được.
3. Trước khi nạp lại cấu hình, thử từ máy nginx:
   ```bash
   curl -s -o /dev/null -w '%{http_code}\n' -H 'Host: ginsengfood.vn' http://192.168.1.99/vi
   ```
   Ra `200` là đường thông.

Xong khi: vào `https://ginsengfood.vn/vi` và `https://ginsengfood.vn/admin` từ ngoài (4G) lên trang; phía .99 thấy lượt vào
mang IP khách thật.

Báo lại: nhắn Toàn một câu trên Zalo; Toàn cho chạy bước kiểm phía .99 (chỉ đọc).
