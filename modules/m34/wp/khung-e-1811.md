# khung-e-1811 — khung đặt đơn thử M3 → M8 trên .99 tối 18/11 (E02/E03 qua web + thử lại trong task, E05/E06-B, E06-A, E10)

Trạng thái: DỪNG 18/11 13:4x (Toàn "tắt"; chạy sớm từ 12:37 theo D-m8-140, tới 13:48 chưa đơn nào) · làm lại hôm khác: bước `lui`/`tat` + tạo lại container do PHÚC chạy (D-m34-108), m34 báo giờ + canh đơn + đọc kết quả · Rủi ro: R3 (ghi máy chạy thật, trang đã public) · Mốc: 18/11 19:40–21:05
Nguồn: D-m8-130 (E02/E03 qua web sau m34.130), D-m8-134 + D-m34-106 (đơn lạ: MOCK "*" = nghe máy bấm 1, m34 canh, báo Toàn), D-lead-056 (chạy lại E05, E06-A/B, gọi lại, `/result`, E10).
Phía M8 do phiên m8 làm; phiếu này chỉ phần M3 và giờ chung.

## Ràng buộc
- M3 (đo trên .99 18/11 09:2x, 8 xác nhận gần nhất, mã `afb6d404c`): lượt gọi CUỐI bắt đầu ≤ tạo đơn + 15 phút, kết quả cuối ≤ + 17 phút; quá hạn watchdog huỷ `IVR_WATCHDOG_EXPIRED` + REVOKE sang M8.
  Bản M3 mới lên .99 trước khung thì m34 đo lại và gửi lại giờ.
- M8 `0f1a9eb5` (`ivr_attempt_policies` `mock-lab-v4` 24/7): 3 lượt ở +0, +450 s, +870 s, cửa sổ kết quả 990 s → khớp đồng hồ M3. MOCK gọi ngay khi lịch bật (trễ quay số ≤ 120 s), không có kịch bản "không gọi".
- Mọi kết quả cuối khác `IVR_CONFIRMED` = huỷ + yêu cầu hoàn tiền + nhả hàng. Không nhánh nhân viên. Admin M3 không huỷ tay được đơn route IVR (`CONFIRMATION_ROUTE_NOT_ALLOWED`) → E06-A chỉ chờ watchdog.
- IVR chỉ áp đơn COD khách MỚI (0 đơn DELIVERED + PAID + VERIFIED/TRUSTED) đã xác minh SĐT bằng OTP SMS, địa chỉ có phường/xã hợp lệ (thiếu → nhân viên xác nhận, không có task M8).
  Đơn thử 14/11 chưa giao → mọi số trong tệp số thử vẫn là khách mới.
- `lui` bật lại cả OTP giả (cần cho web + `dat-don-uat.py`); trong khung người ngoài cũng thấy mã OTP.
- Cầu `m8that-cb` dừng = mọi callback M8 → M3 lỗi, kể cả đơn lạ → giữ đoạn dừng cầu ngắn; sau khi bật cầu M8 phát lại callback cạn của đơn lạ ngay.
- Khi nối IVR bật mà lịch TẮT (đoạn E06-A), đơn lạ không được gọi và bị watchdog huỷ sau 17 phút → giữ đoạn này ngắn, đặt cuối khung, tắt nối ngay khi E06-A xong.
- `tat` tự dừng nếu còn xác nhận IVR active.
- **Ca "gọi lại khung mới" (task mới có `recall_of_task_id`): NOT_RUN trên .99.** M3 `afb6d404c` không có; `dev` chỉ có trường trong `OrderIvrTaskAssembler`; dịch vụ `OrderIvrRecallService` chỉ nằm trên nhánh gộp của chú (chưa vào dev, chưa lên .99).

## Lịch (giờ VN; N = id đơn kế tiếp, m34 đọc lúc 19:30 bằng `_wt/m34/_tools/doc-id-don-99.sh`)
| Giờ | Ai | Việc | Kịch bản M8 | Kết quả mong đợi |
|---|---|---|---|---|
| 19:30 | m34 | đọc N, báo M8; tạo thư mục receipt `_wt/m34/len60-notes/receipt-99-1811-<ca>` | — | — |
| 19:40 | m34 (Toàn "chạy") | `bash _wt/m34/_tools/cong-khai-99.sh lui` | — | be: IVR + OTP giả bật |
| 19:42 | M8 (Toàn "chạy") | bat-lich + kịch bản theo id | "*" bấm 1 | — |
| 19:45 | Toàn, web | E02: đặt COD trên https://ginsengfood.vn, số chưa giao đơn nào, chọn phường/xã | N bấm 1 | CONFIRMED |
| 19:48 | Toàn, web | E03: như trên, số khác | N+1 bấm 0 | CANCELLED `IVR_CUSTOMER_REQUEST` |
| 19:52 | m34 (Toàn "chạy") | thử lại trong task: `--ca khac --bo-qua-dong 6` | N+2: lượt 1 RingTimeout, lượt 2 (~+7,5 phút) bấm 1 | CONFIRMED ~20:00 |
| 20:05 | m34 (Toàn "chạy") | dừng cầu: `bash modules/m34/wp/chuyen-may-99/cau-m8-99.sh dung` | — | — |
| 20:07 | m34 | E06-B: `--ca e06b --bo-qua-dong 7` | N+3 bấm 1 | callback cạn `RETRY_EXHAUSTED` |
| 20:08 | m34 | E05: `--ca e05 --bo-qua-dong 0` | N+4 bấm 1 | callback cạn |
| ~20:10 | m34 (Toàn "chạy") | bật cầu: `cau-m8-99.sh bat` (sau khi M8 báo cả hai cạn) | — | — |
| 20:10–20:23 | M8 | phát lại E05 (trước +17 phút của E05 ≈ 20:25) | — | E05 `AP_DUNG_MOT_LAN`, CONFIRMED |
| ≥ 20:25 | M8 | phát lại E06-B SAU khi watchdog huỷ B (~20:24) | — | M3 409, `KHONG_AP_DUNG_(CHAN)`, đơn giữ CANCELLED |
| 20:30 | M8 (Toàn "chạy") | `tra-lai --chay` (lịch TẮT) | — | — |
| 20:32 | m34 (Toàn "chạy") | E06-A (lịch tắt): `--ca e06a --bo-qua-dong 1` | N+5 (không gọi vì lịch tắt) | watchdog huỷ ~20:49 → REVOKE → M8 `TASK_REVOKED`, 0 lượt gọi |
| ~20:50 | m34 (Toàn "chạy") | `cong-khai-99.sh tat` (sau khi M8 báo `TASK_REVOKED`; chặn nếu còn xác nhận active) | — | be: IVR + OTP giả tắt |
| 20:50–21:05 | M8 + m34 | E10, `/result` (chỉ đọc); m34 `kiem-m3-chi-doc.sh --don=<id>` từng đơn | — | khớp |

Lệnh đặt đơn chạy trong `C:\Projects\ginsengfood-business-platform\deploy\m34\m8-that`, đủ cờ:
`python dat-don-uat.py create --base http://192.168.1.99 --ca <ca> --phones-file C:/Projects/_wt/m34/len60-notes/so-thu-99.txt --bo-qua-dong <n> --receipt-dir C:/Projects/_wt/m34/len60-notes/receipt-99-1811-<ca>`
(dòng 6, 7 chưa dùng; dòng 0, 1 dùng 14/11 cho đơn chưa giao → vẫn khách mới). Một đơn lỗi thì dừng, không tự thử lại; id lệch so với kịch bản M8 → báo M8 đặt lại kịch bản trước khi đặt đơn kế.

## Canh đơn lạ (D-m34-106)
Từ `lui` tới `tat`: m34 đọc đơn mới mỗi phút (chỉ đọc). Đơn không nằm trong bảng trên → báo Toàn ngay (id, giờ, trạng thái), để nhân viên gọi lại khách.
Đơn lạ rơi vào đoạn lịch tắt (20:30–20:50) sẽ bị watchdog huỷ sau 17 phút, không cứu được ở M3 → báo Toàn ngay để nhân viên liên hệ khách đặt lại.

## Diễn biến
- 18/11 12:34 D-m8-140 chạy ngay: N = 598; 12:36:50 m34 `lui` (Toàn "chạy"), be 12:37:17, M8 lịch bật 12:37:21. Tới 13:48 0 đơn mới. 13:4x Toàn "tắt"; `tat` của m34 dừng ở bước kiểm vì `.env` đã có lại lớp (ai đó sửa 13:39–13:43) và D-m34-108 cấm m34 ghi .99 → nhờ Phúc tạo lại `be` (tin `ra-soat/2026-11-18-phuc-tin-tao-lai-be.md`). Lượt `lui` 12:36 đụng lượt lên bản `d1039f46f` của Phúc 12:34–12:35.
- 18/11 09:3x soạn phiếu theo nhờ của M8 (gửi kế hoạch trước 19:30).
- 18/11 09:4x M8 trả lời: chính sách thử lại 3 lượt +0/+450/+870 s; không có kịch bản "không gọi"; ca gọi lại khung mới cần task `recall_of_task_id`. m34 chốt: E06-A dời CUỐI khung khi lịch đã tắt (giữ các ca có gọi sớm, xa giờ chặn gọi 21:08), `tat` ngay sau `TASK_REVOKED`, E10 chỉ đọc sau `tat`; ca gọi lại khung mới NOT_RUN.
