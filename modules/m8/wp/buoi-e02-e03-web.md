# Buổi E02/E03 đặt đơn qua web + chạy lại các ca sau deploy (bậc 90 "Nối với M3")

Trạng thái: SOẠN (18/11) · Rủi ro: R3 (bật lại nối IVR + OTP giả trên web công khai, ghi .99) · Quyết định: D-m8-130 (m8.99 A); giờ = m8.102 (đề xuất A: tối 18/11 19:45–21:15, m34 đề xuất cùng giờ; Toàn nói "tiếp tục luôn đi" 18/11 ~08:51 — phiên chuẩn bị theo A, **mỗi bước ghi .99 vẫn chờ Toàn nói "chạy" lúc vào khung**).
Bên M3: m34 (`_wt/m34/_tools/cong-khai-99.sh lui|tat`, D-m34-105). Phiếu trước: [buổi 17/11](buoi-e07-e02-e03-e08.md), [E05/E06-B](nghiem-thu-99-e05-e06b-m8.md), [hướng dẫn bậc 90](huong-dan-bac-90-noi-m3.md).

## Rủi ro chính và cách chặn

- Trong khung, web công khai hiện mã OTP giả và đơn COD khách mới sang M8. Worker .99 có MOCK mặc định `*` = nghe máy bấm 1 (đọc 18/11) → đơn lạ bị **tự xác nhận**.
- **Không** đổi `*` thành không nghe máy: m34 đọc mã M3 (`OrderIvrResultServiceImpl.cancellationReason`, `afb6d404c` = `dev` `88d5fe01e`): chỉ `IVR_CONFIRMED` xác nhận; `IVR_NO_ANSWER_FINAL`, `IVR_CUSTOMER_CANCELLED`, `IVR_INVALID_PHONE_FINAL`, `IVR_CAPACITY_EXCEPTION`, `IVR_CONFIRMATION_WINDOW_EXPIRED` đều HUỶ + yêu cầu hoàn tiền + nhả giữ hàng, không hoàn tác; không có nhánh chuyển nhân viên cho kết quả IVR; watchdog huỷ khi quá `result_deadline` (PT55M). Đơn tự xác nhận thì nhân viên còn gọi lại/huỷ tay được → câu **m8.103** (đề xuất giữ `*` bấm 1; m34 thấy đơn lạ báo Toàn để nhân viên gọi khách).
- Đơn thử: `m3-ivr-N-` bấm 1 (E02), `m3-ivr-N+1-` bấm 0 (E03, huỷ đúng mong đợi); ca "không nghe" của E05/E06 chỉ gắn tiền tố đơn `dat-don-uat.py`.
- Trước `tat` phải còn **0 xác nhận active ở M3**: sau `tat` watchdog không chạy nhưng lần bật sau huỷ ngay đơn quá hạn; callback M8 vẫn được M3 áp khi cờ tắt; thu hồi task phía M8 không đóng xác nhận phía M3. m34 đã chặn trong `cong-khai-99.sh tat` (còn active thì dừng). → mọi task trong khung phải có kết quả cuối trước ~21:10; ca gọi lại phải xếp để lượt 2 rơi trong 20:00–21:00.
- m34 đọc đơn mới mỗi phút (chỉ đọc); M8 kiểm hàng đợi mỗi 5 phút.

## Thứ tự (chốt với m34 18/11 ~09:05, phiếu M3: `modules/m34/wp/khung-e-1811.md`; N do m34 đọc 19:30)

| Giờ | Ai | Việc | Ghi | Đạt khi |
|---|---|---|---|---|
| trước 19:30 | M8 | `kiem_hang`, `lan-thu.sh hien-trang` | không | lịch TẮT, 0 cuộc dở, 0 callback đang gửi |
| 19:40 | m34 | `cong-khai-99.sh lui` (Toàn duyệt ở m34), kiểm cờ | M3 | nối IVR + OTP giả bật |
| 19:41 | M8 | `N=<N> GOI_LAI=<N+2> THEM="<N+3>:Answered:1 <N+4>:Answered:1" CHAY=1 e_chuan_bi_1811.sh` (giữ `*` bấm 1) rồi `lan-thu.sh bat-lich --m3-goc https://192.168.1.99:8445` | .99 | kịch bản đúng, lịch BẬT |
| 19:45 / 19:48 | Toàn | web: E02 = N bấm 1, E03 = N+1 bấm 0 | — | M3 N xác nhận, N+1 huỷ (khách huỷ) |
| 19:52 | m34 | thử lại trong task N+2 (lượt 1 RingTimeout, lượt 2 ~+7,5 phút bấm 1) | — | CONFIRMED ~20:00 |
| 20:05–20:25 | m34 + M8 | m34 dừng cầu `m8that-cb`; E06-B N+3, E05 N+4 bấm 1 → callback cạn; ~20:10 bật cầu; M8 phát lại E05 trước ~20:25 (áp 1 lần); watchdog huỷ B ~20:24; M8 phát lại B sau đó → 409 | .99 (phát lại: tầng nguy hiểm) | E05 CONFIRMED đúng 1 lần, B 409 không áp |
| 20:30 | M8 | `tra-lai --chay` (lịch TẮT, cấu hình cũ) | .99 | sha worker = bản sao lưu |
| 20:32–20:49 | m34 + M8 | E06-A N+5 (lịch tắt, 0 lượt) → watchdog ~20:49 → REVOKE → M8 thấy `TASK_REVOKED`, 0 lượt | — | `TASK_REVOKED`, 0 attempt |
| ~20:50 | m34 | `cong-khai-99.sh tat` (tự chặn nếu còn xác nhận active) | M3 | nối IVR + OTP giả tắt |
| 20:50–21:05 | M8 + m34 | E10 + `/result` (M8, chỉ đọc, không cần nối/lịch); `doi_soat_m3.py`; `kiem-m3-chi-doc.sh` | không | đối soát KHỚP |

- **Rủi ro còn lại:** 20:30–20:50 nối IVR bật mà lịch TẮT → đơn COD lạ đặt trong khoảng này không được gọi, watchdog M3 huỷ (+hoàn tiền) — m34 canh, báo Toàn. 19:40–19:42 tương tự (2 phút).
- "Gọi lại khung mới" (task `recall_of_task_id`, QT-CHUNG-011/015): **NOT_RUN** trên .99 — M3 `afb6d404c` chưa gửi gọi lại; `OrderIvrRecallService` chỉ có ở nhánh gộp của chú, chưa vào `dev`, chưa lên .99. Bằng chứng M8: integration gọi lại 14/14 (W-0544).

## Đường lui

Bất kỳ bước nào hỏng hoặc thấy đơn lạ bị gọi: M8 `tra-lai --chay` ngay (lịch TẮT), m34 `tat`; đơn lạ đã vào IVR → nhân viên xử lý tay, M8 thu hồi task nếu M3 cần (lượt riêng Toàn duyệt).

## Diễn biến
- 18/11 ~08:52 phiên chính: soạn phiếu; phát hiện MOCK mặc định `*` bấm 1, đã báo m34 và hỏi 2 câu.
- 18/11 ~08:54 m34 trả lời: không nghe máy tới hết lượt = HUỶ ở M3 (không chuyển nhân viên); sau `tat` callback vẫn áp, lần bật sau watchdog huỷ đơn quá hạn; `tat` nay tự chặn khi còn xác nhận active. Bỏ ý `*` RingTimeout; câu m8.103.
- 18/11 08:56 Toàn "103 A, giữ bấm 1" → D-m8-134.
- 18/11 ~09:05 thứ tự chốt với m34 (bảng trên): E06-A cuối khung khi lịch tắt (M3 không huỷ tay được đơn route IVR, chỉ watchdog 17 phút); gọi lại khung mới NOT_RUN.

## Bước kế tiếp chính xác
19:30 m34 báo N → M8 `kiem_hang` + hiện trạng; chờ Toàn "chạy" → 19:41 đặt kịch bản + bật lịch theo bảng.
