# E05 / E06-B trên .99 — phần M8 và trình tự chung (m8 chính soạn 14/11 10:45) · CHƯA CHẠY

Chờ: Toàn duyệt riêng ở phiên m8 (bật lịch + replay bằng token quyền nguy hiểm). Phần M3 ở `modules/m34/wp/nghiem-thu-99-e05-e06b.md` (m34 phụ). Đã có E02 lặp, E01, E06-A, E03 trên .99 (`ra-soat/2026-11-14-*-99.md`).

## Số đo cạn thử lại (cấu hình .99 dùng mặc định)

`MaxRetries` 3 (tối đa 4 lần gửi), chờ giữa các lần 250 ms rồi tăng gấp đôi (trần 5 s) cộng nhiễu ≤ 100 ms, `RequestTimeoutSeconds` 5, mạch ngắt mở 30 s sau 5 lần hỏng liền (`CallbackDeliveryOptions.cs:31-47`; `appsettings.json` worker trên .99 chỉ đặt `RequestTimeoutSeconds`=5, `LeaseDurationSeconds`=30). Cầu dừng (cổng 8445 đóng): mỗi callback cạn sau vài giây, tới khoảng 40 giây nếu mạch ngắt mở. **Callback về `RETRY_EXHAUSTED` trong khoảng 1–2 phút kể từ lúc đơn được gọi**, không phải 10–12 phút: không cần chỉnh khoảng thử lại bằng cấu hình MOCK.

## Trình tự (T0 = giờ m34 phụ đặt đơn B)

| # | Giờ | Ai | Việc | Lịch gọi |
| --- | --- | --- | --- | --- |
| 1 | T−7 | m34 phụ | dừng cầu (`cau-m8-99.sh dung`), báo M8 giờ | tắt |
| 2 | T−6 | M8 | `lan-thu.sh bat-lich`; chờ đồng bộ media lắng (~5 phút, bài học 8) | bật |
| 3 | T−1 | M8 | báo m34 phụ "SẴN SÀNG ĐẶT ĐƠN B" | bật |
| 4 | T0 | m34 phụ | đặt đơn E06-B (đơn B); báo mã đơn, task_id | bật |
| 5 | T0+1…2 | M8 | B gọi MOCK, callback hỏng, `RETRY_EXHAUSTED`; M8 báo "B ĐÃ CẠN" | bật |
| 6 | T0+5 | m34 phụ | đặt đơn E05 chỉ sau tin "B ĐÃ CẠN"; báo mã đơn, task_id | bật |
| 7 | T0+6…7 | M8 | E05 `RETRY_EXHAUSTED`; đối soát trước replay (`so_lan_gui>=2`, ghi `callback_an`); `tat-lich`; báo "CẢ HAI ĐÃ CẠN, LỊCH TẮT" | tắt |
| 8 | T0+16,5 | watchdog M3 | huỷ B, REVOKE sang M8 (M8 dự kiến trả `TASK_ALREADY_CLOSED` vì job đã đóng); M8 kiểm B có `thu_hoi_luc` | tắt |
| 9 | T0+17…20 | m34 phụ | bật cầu (`cau-m8-99.sh bat`) CHỈ sau tin ở bước 7 và sau bước 8; báo giờ | tắt |
| 10 | +35 s | M8 | replay callback E05 trước, rồi B (token quyền nguy hiểm qua tệp 0600, xoá ngay, không in) | tắt |
| 11 | +1 phút | M8 | đối soát: E05 cùng `callback_an`, `DELIVERED_ACCEPTED`/`ACCEPTED`/200; B `REJECTED_STALE` hoặc `DELIVERED_BLOCKED`; báo m34 phụ | tắt |
| 12 | sau | m34 phụ | đọc M3: E05 áp một lần, B không áp kết quả cũ (KET_LUAN `KHONG_AP_DUNG_(CHAN)`) | tắt |

Lịch gọi bật khoảng 13 phút (T−6 → T0+7), dưới hạn 30 phút. Hạn cứng của E05: replay phải xong trước `T0+5 + 16,5 phút` ≈ T0+21,5; mục tiêu replay lúc T0+18.

## Điều kiện dừng

- `TTS_PHRASE_NOT_READY` hay lỗi gọi ở B hoặc E05: dừng, báo nguyên văn, không đặt thêm đơn.
- B hoặc E05 chưa `RETRY_EXHAUSTED` sau 5 phút kể từ lúc đặt: dừng, báo (callback còn đang thử hoặc cầu chưa dừng).
- Cầu bị bật trước tin ở bước 7: callback còn thử sẽ vào M3 và được áp, ca hỏng; làm lại với đơn mới.
- Qua T0+20 mà chưa replay E05: watchdog sắp huỷ E05, ca hỏng; làm lại E05 với đơn mới (cầu dừng lại).
- Replay trả khác 200 (409 không còn dead-letter, 403, 5xx): dừng, ghi nguyên văn, không replay thử lại với tiêu đề khác.

## Việc ghi trên .99 của M8 (cần Toàn duyệt rõ)

1. `lan-thu.sh bat-lich` rồi `tat-lich` (tạo lại worker và phrase-tts, như E03); không đổi cấu hình, không cần `tra-lai`.
2. Replay hai callback qua `POST /v1/ivr/order-confirmation/result-callbacks/<callback_id>:replay` (quyền nguy hiểm, `X-Service-Scope: ivr.admin.danger`) từ chính .99 tới `https://192.168.1.99:8443`: đổi trạng thái callback trong CSDL. Token `IVR_ADMIN_DANGER_TOKEN` đi qua tệp tạm 0600 trong `m8-noi-m3/nghiem-thu/`, xoá ngay, không in; `api.env` có đúng 1 dòng (kiểm 10:42, chỉ đếm). Tiêu đề `X-Actor-Id` đặt `toan-m8-uat`.
3. Đối soát `doi_soat_m3.py` và chụp log vào `m8-noi-m3/nghiem-thu/`. Không sudo, không đổi cờ gọi thật (`REAL_CUSTOMER_CALL_ALLOWED=NO`).

## Chưa kiểm (rủi ro)

- Callback B còn replay được sau khi M3 REVOKE B: trong mã, REVOKE chỉ đặt `RevokedAt` và đóng job (`TaskRevocation.cs:91-111`, `creates_callback=false`), không chạm dòng callback; chưa chạy thử. Nếu replay B trả 409, E06-B ghi `NOT_RUN` kèm lý do thay vì đạt.
- Một cầu cho cả hai đơn nên mọi callback khác M8 → M3 trong lúc cầu dừng cũng hỏng; chỉ có hai đơn thử vì lịch chỉ bật cho lượt này.
