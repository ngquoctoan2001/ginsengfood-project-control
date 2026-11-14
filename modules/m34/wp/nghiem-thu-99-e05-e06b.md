# E05 / E06-B trên .99 — phần M3 (m34 phụ soạn 14/11 10:35) · CHƯA CHẠY

Chờ: trình tự của M8 + Toàn duyệt riêng ở phiên phụ. Lịch gọi do M8 bật/tắt; m34 không bật lịch.

## Lệnh phía M3 (đã soạn, chưa chạy)

| Bước | Lệnh (thư mục `modules/m34/wp/chuyen-may-99/`, trừ đặt đơn) | Loại |
|---|---|---|
| Xem cầu | `bash cau-m8-99.sh trang-thai` (10:30: cầu chạy, 8445 nghe) | chỉ đọc |
| Dừng cầu | `bash cau-m8-99.sh dung` (chỉ dừng m8that-cb; web :80 không ảnh hưởng) | ghi .99 |
| Đơn E05 | `python dat-don-uat.py create --base http://192.168.1.99 --ca e05 --phones-file C:/Projects/_wt/m34/len60-notes/so-thu-99.txt --bo-qua-dong 4 --receipt-dir C:/Projects/_wt/m34/len60-notes/receipt-99-e05` (thư mục `deploy/m34/m8-that`) | ghi M3 |
| Đơn E06-B | như trên, `--ca e06b --bo-qua-dong 5 --receipt-dir …/receipt-99-e06b` | ghi M3 |
| Bật cầu | `bash cau-m8-99.sh bat` (kiểm cấu hình đang chạy còn `allow 172.24.2.1`) | ghi .99 |
| Đọc kết quả | `cat kiem-m3-chi-doc.sh \| ssh ssv@192.168.1.99 'cd /data/ginsengfood-business-platform && M34_DIR=$PWD bash -s -- --don=<id>'` (chạy bản đã sửa `0eeeb60e5` từ máy Toàn; bản trên .99 còn cũ tới pha D) | chỉ đọc |

## Điểm cần Toàn và M8 lưu ý trước khi chạy

1. **Không có thao tác "đổi/hủy tay" đơn B ở M3.** Sau khi lệnh SUBMIT đã gửi, admin không sửa được đơn (`LOCKED_AFTER_SENDING`, `AdminOrderIvrEditService.edit`) và không hủy được đơn route IVR (`cancelByStaff` → `CONFIRMATION_ROUTE_NOT_ALLOWED`). Cách duy nhất đơn B "đổi" là watchdog M3 tự hủy khi quá `result_deadline` (khoảng 16,5 phút sau khi tạo đơn: `last_call_start_deadline` +15 phút, `result_deadline` +16,5 phút) → `CANCELLED IVR_CONFIRMATION_INVALID` + REVOKE (như đơn 576, 578).
2. **Watchdog cũng áp cho đơn E05.** Nếu callback của E05 chưa vào M3 trước `result_deadline` của nó, watchdog hủy E05 và callback replay sau đó bị từ chối như E06-B → E05 hỏng. Nên: **replay E05 phải xong trước ~16 phút kể từ lúc tạo đơn E05**; **replay E06-B phải sau khi watchdog đã hủy đơn B** (sau `result_deadline` của B).
3. **Một cầu cho cả hai đơn.** Bật cầu là mọi callback M8 còn đang tự thử lại sẽ vào được. Vì vậy trước khi bật cầu để replay E05, đơn B phải đã `RETRY_EXHAUSTED` (M8 không tự gửi lại nữa), nếu không callback của B vào trước hạn và được áp như đơn thường. Trình tự gợi ý: dừng cầu → đặt E06-B rồi E05 (cách vài phút, để hạn của B đến trước) → M8 chờ cả hai `RETRY_EXHAUSTED` → bật cầu → replay E05 (trước hạn E05) → chờ watchdog hủy B (đọc M3 thấy CANCELLED) → replay E06-B. Cần biết thời gian M8 thử lại tới `RETRY_EXHAUSTED`: nếu dài hơn khoảng 10–12 phút thì không vừa hạn 16,5 phút của E05.
4. **Đọc KET_LUAN của E06-B cẩn thận.** Script đã sửa đếm `su_kien` là mọi `ORDER_CANCELLED/ORDER_CONFIRMED` của đơn, kể cả sự kiện watchdog `ivr:<id>:lifecycle:ORDER_CANCELLED`. Với đơn B bị watchdog hủy rồi replay bị chặn, dự kiến in `inbox 1, accepted 0, chuyen 0, su_kien 1` → `BAT_THUONG` dù đúng là "không áp". Khi đọc E06-B: tự xem inbox (`REJECTED_STALE`/`BLOCKED_BY_CORE`), không có dòng trạng thái `effect=ivr:<id>:final`, sự kiện chỉ có `…:lifecycle:…`. Muốn script in đúng thì lọc `su_kien` theo `event_key like '%:final:%'` (phiên m34 chính sửa nếu Toàn muốn).
5. Trong lúc cầu dừng, mọi callback M8 tới M3 đều thất bại (chỉ hai đơn thử này vì lịch chỉ bật cho lượt này). Web/admin M3 vẫn chạy bình thường.
