# Từ phiên `m7` · 07/11/2026 · Hạn M7 mới: 15/11 video ngắn thật, 30/11 xong hết

Nguồn: D-m7-063, Toàn chốt 07/11/2026 08:16. Nội dung thay đích cũ: không còn "demo local bằng tệp mẫu 15/11, nối thật GĐ3 01/2027".
- **15/11:** luồng tự động tạo video ngắn chạy bằng bộ máy thật, ra một video ngắn thật khoảng 95 giây.
- **30/11:** chương trình 70 phút, xu hướng, phát, nối thật M3/M2/M1/Kho Media/M6/IdP, lên .60, nghiệm thu.
Chi tiết ở `modules/m7/SAN_SANG.md`.

## Hạn của các việc chờ bên khác đều kéo sớm lại

| Việc | Ai | Hạn cũ | Hạn mới |
|---|---|---|---|
| Phụ lục 9 điểm deploy contract; thư mục, cổng `m7` trên .60 (`lead-2026-11-03-m7-deploy-contract.md`) | phiên `lead`, Anh Tuấn | sau 15/11 | 18/11 |
| Chứng chỉ bền `m7-edge` .60 (`lead-2026-11-06-m7-chung-chi-edge-60.md`); khoá audit `M7_AUDIT__*` .60 | phiên `lead`, Anh Tuấn | trước UAT .60 | 18/11 |
| Ổ đĩa kho tệp .60 (còn ~500 GB, cần ~630 GB) hoặc NAS | Anh Tuấn | trước dựng video thật | 18/11 |
| IdP cho .60 (bộ phát JWT dev bị cấm trên .60, SRS IR-IDP-01) | phiên `lead`, chưa có chủ | GĐ3 | 17/11 |
| Hợp đồng M7 trong `ginsengfood-contracts` | phiên `lead` | GĐ3 | 20/11 |
| M6: tín hiệu lần phát, DL-O17 (luật `source` ở contracts), DL-O21 | phiên `m6` (Tài), `lead` | 01/2027 | 20/11 |
| M3: snapshot phiên Giờ Vàng, số bán SKU | phiên `m34` (Phúc) | 01/2027 | 20/11, 24/11 |
| M2/M1: tài khoản `availability-v1`, `SVC-M7`, claim M1; Kho Media | Toàn (phiên `m12`) | 01/2027 | 20–22/11 |
| Danh sách giấy phép thư viện cho CI | phiên `lead` | 11/11 | 11/11 (giữ) |

## Phiên `lead` cần sửa sổ của mình

Các chỗ còn ghi lịch M7 cũ (scout m7 tìm 07/11):
- `modules/lead/VIEC_NGOAI.md:19` và `:38` ("GĐ4", "bản tối thiểu 15/11 là demo local");
- `modules/lead/SAN_SANG.md:33` ("Điểm nối M7 GĐ3 (01–02/2027)");
- `TONG_QUAN.md:19`, `:27`, `:45` (M7 "demo local 15/11").

Không cần trả lời từng dòng. Nếu một hạn trên không kịp, ghi ngày được vào cột "Hạn mới" của tệp này. Nếu trễ, phiên `m7` sẽ đẩy nối thật và nghiệm thu đợt 2 sang 03–05/12.
