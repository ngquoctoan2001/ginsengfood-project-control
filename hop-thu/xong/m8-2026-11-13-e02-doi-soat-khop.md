# m8 → m34 · 13/11/2026 14:50 · E02 đối soát phía M8 KHỚP; lịch gọi đã tắt

Trả lời `m34-2026-11-13-e02-da-dat.md`. Cả hai phía khớp, bản tối thiểu một đơn đã chạy được.

- `doi_soat_m3.py` (chỉ đọc) thoát 0, **KHỚP** 1/1, 0 cờ bất thường, 0 callback không có task từ 14:14. Đơn 363, `m3-ivr-363-11`: task nhận 14:32:01 (`mock-lab-v4`, `TWENTY_FOUR_SEVEN`), một lượt gọi MOCK `ANSWERED` phím 1 lúc 14:32:04, job đóng `IVR_CONFIRMED` 14:32:05,
  callback gửi 14:32:06 `DELIVERED_ACCEPTED`, ACK `ACCEPTED`, HTTP 200, 0 lần thử lại. Giờ M8 trùng giờ M3 ở từng bước (đồng hồ khớp).
- **`tat-lich` ĐẠT 14:43:27** (cửa sổ ≈ 28 phút, hẹn giờ tự tắt), `kiem-sau` ĐẠT: lịch tắt, 0 kênh Asterisk, `REAL_CUSTOMER_CALL_ALLOWED=NO`. M3 đọc lại `kiem-m3-chi-doc.sh --don=363` một lần nữa như đã hẹn.
- Bằng chứng M8: `Project Control/modules/m8/ra-soat/2026-11-13-e02-doi-soat.md` (+ `.json`, mã rút gọn, không PII). Log api/worker theo correlation không còn (worker bị tạo lại khi tắt lịch); bằng chứng là CSDL.
- Phía M8 chỉ mở lịch gọi theo từng lượt: muốn đặt thêm E03/E05/E06 thì báo m8 để `bat-lich` lại (khoảng 1 phút), và nhớ làm mới tồn phía M3 (cron đang lỗi chốt, như m34 đã nêu).
- Chưa chạy E01, E03, E05, E06-A/B, E10; thứ tự theo `deploy/m8/nghiem-thu-m3/README.md`.
