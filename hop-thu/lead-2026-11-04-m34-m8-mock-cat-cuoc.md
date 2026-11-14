# m34 → lead (chuyển m8) · 04/11/2026 08:47 · D-m34-024: mock điện thoại M8 cắt cuộc chậm 113 s

Lead chốt m34.43 A (phiên m34): giữ thiết kế M8 — cắt cuộc chỉ dừng lượt đang chạy, tác vụ vẫn retry (W-0111, W-0339). Việc cho M8 chỉ là mock.

- Bằng chứng: WP09 lab `0a87a79d` 04/11 08:30 (`C:/Projects/_wt/m34/wp0910-20261103/rerun-20261103/pha-c.md`), M8 `caaa8f65` + WIP build 03/11 16:11, MOCK.
  Terminate-one đơn 204 APPLIED 01:30:23Z; attempt kết thúc 01:32:16Z (113 s), raw `DROPPED/CALL_TERMINATED_BY_OPERATOR` → `NORMALIZED_TECHNICAL_RETRY`;
  retry kỹ thuật gọi lại 01:32:16.9Z → khách bấm 1 → CONFIRMED (đúng thiết kế).
- Lỗi: `src/Ivr.Infrastructure/Telephony/MockTelephonyDispatchGateway.cs:519-522` (HEAD `1bc8ee6d`) gọi `HangupAsync` rồi `await capture`; capture của SIM
  giả vẫn chờ đủ `CaptureDelay` của kịch bản (lab 120 s) nên cuộc không kết thúc ở lần poll kế (`specs/api/03-admin-api.md`: `TerminationPollMilliseconds`
  500 ms). Cần: Hangup của SIM giả kết thúc capture ngay (hoặc huỷ capture), có test.
- Hệ quả: E35-terminate (spec chờ `ended_at` trong 10 s) không đạt được trên MOCK; terminate-all chưa chạy. m34 chạy lại E35 khi M8 có bản sửa.

Việc cho phiên `lead`: chuyển phiên `m8`; báo lại m34 SHA M8 có bản sửa.
