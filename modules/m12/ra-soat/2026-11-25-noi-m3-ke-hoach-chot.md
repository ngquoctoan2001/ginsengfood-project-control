# Nối M12 ↔ M3: kế hoạch chốt tới 30/11 (phiên m12, 25/11 12:4x)

Nguồn: Sheet (công cụ `sheet-sync list`, 67 việc nối: 33 "Rà soát kho/SKU/bảo mật nối M12↔M3" + 34 "Nối M12↔M3 P0–P7"), sổ m12/m34, kiểm chỉ đọc remote hợp đồng và ops-core. **Máy chủ .99 chưa đọc lại phiên này.** Sheet 25/11 12:3x: 28 hoàn thành (sau 3 việc cập nhật hôm nay), 19 đang làm, 20 chưa bắt đầu (số "23/66" trong sổ cũ là số trước khi rà lại).

## 1. Đã cập nhật Sheet hôm nay (có bằng chứng)

| Việc | Trạng thái mới | Bằng chứng |
|---|---|---|
| NM3-11 principal M3 | Hoàn thành | xoay secret 17/11 (D-m12-108), M3 lấy token 200; DB sạch 20/11 dùng lại secret (D-m12-128); 21/11 M3 gọi kiểm bán được, nhận "không bán được" đúng thiết kế |
| NM3-23 tên miền https | Hoàn thành | 17/11 proxy .98 + chứng chỉ; 25/11 10:31 kiểm từ ngoài ops. pwa. trace. đều 200 |
| NM3-72 chuyển stack sang .99 | 90 | chạy `a0ccc740e` từ 25/11 10:31; còn compose Production (WP17b), sao lưu ngoài máy chưa kiểm chứng, khoá CD .99 |

## 2. Chặn bởi ba thứ (phần lớn 39 việc còn lại)

| Chặn bởi | Việc bị giữ | Ai gỡ | Gỡ bằng gì |
|---|---|---|---|
| **G1. Hợp đồng `main` chậm nhánh nối 45 commit** (nhánh `m12-noi-m3` = `a57a11f`, `main` = `a7832a4`, không phân kỳ, đẩy fast-forward sạch được) | NM3-32 (xuất bản hợp đồng, 96), NM3-33/WP22 (dời ghim `1e73bc1` → bản mới + ma trận 35 chỗ, 85), NM3-35 (cổng go/no-go) | Toàn ra lệnh push; phiên lead (hợp đồng thuộc lead) | `git push origin a57a11f:main` ở repo hợp đồng; sau đó phiên m12 dời ghim + chạy parity |
| **G2. Chưa có mẻ bán được trên .99** (DB sạch, chưa phiếu thật) | NM3-45b (chạy S01–S18 trên .99), NM3-43/44 (bật tự nhả, SOP kho), NM3-60 (hypercare), NM3-62 (báo cáo cuối), NM3-99 (Toàn nghiệm thu nối) | Buổi 27/11 làm mẻ thật đầu tiên (m12.203 phương án A) | kịch bản `wp/M12-010-bo-sang-27-11.md`: kích hoạt bán 1 SKU, đi đủ chuỗi đến nhập kho thành phẩm; sau đó M3 thấy bán được |
| **G3. Phía M3 trên .99 (Phúc)** | quan sát M3→M12 (OPS_CORE_*), NM3-52/71 (đường M3→M12 nội bộ; theo D-lead-036 giữ cổng 5000 mở), NM3-74 (chạy lại trên máy gộp), SKU-M12-11 (kiểm link 19/19 cần CSV từ DB M3), SKU-M12-03 (M3 đọc `/v1/skus`) | Phúc (D-lead-060: chỉ Phúc làm trên .99; phiên m12 chỉ đọc) | tin nháp `2026-11-25-tin-phuc-noi-m3.md` (Toàn tự gửi) |

## 3. Việc của Toàn (làm tay hoặc quyết)

DIET-2 (xác nhận công thức 4 SKU chay với chú Dũng, mở từ 11/11; DIET-1 chờ) · QD-RS (quyết định rà soát KHO-C1…C4, SEC-03a, SEC-06, Q4) · SEC-25 (NTP lệch giờ ≤ 5 giây) · SEC-05 (khoá Production sinh mới; trùng hồ sơ đóng ngoại lệ JWT hạn 30/11 16:59Z, m12.xác nhận khoá mới) · SEC-11 (xoay token Sheet, đưa `sheet.json` khỏi repo) · SEC-18 (kênh gửi cảnh báo email/Zalo + người trực) · NM3-23b/51b (đặt URL webhook + khoá ký chung với M3: thuộc WP22, cần `.env` .99).

## 4. Đề xuất cắt hoặc hoãn (không chặn 30/11 ở mức quan sát)

SKU-M12-08 (sự kiện vòng đời SKU qua outbox: chỉ là tín hiệu kéo lại, M3 đã kéo `/v1/skus`) · NM3-51b (webhook thật, chỉ cần khi M3 vào giữ hàng thật) · NM3-43/44 nếu quyết giữ M3 ở chế độ quan sát tới sau 30/11 (Q10) · NM3-33 phần "bật cờ /release trên diễn tập" (đã có test 57/57; bật trên .99 là lệnh riêng).

## 5. Việc phiên m12 làm được ngay, không cần ai

- Chạy bộ nghiệm thu M3 cục bộ (đủ 18 ca: 13 ca §6 + 4 ca C37 + ca 14) trên bản HEAD với DB dùng một lần: thay NM3-14 (profile 61 không còn dùng). Kết quả: xem mục 6.
- Soạn kịch bản kiểm M3 sau mẻ 27/11 (thêm bước vào `M12-010-bo-sang-27-11.md`).

## 6. Kết quả 25/11 (sau lệnh duyệt D-m12-136)

- **Hợp đồng `main` = `a57a11f`** (fast-forward 45 commit, 12:41): G1 đã gỡ; đã giao coder dời ghim ops-core + ma trận truth (đang chạy).
- **Bộ nghiệm thu M3 cục bộ 18/18 PASS**, parser M3 0 lỗi (kèm giữ/nhả/`ISSUED` cờ BẬT cục bộ). Coder đang mở rộng để chạy thêm S08–S14.
- **Đọc `.99` chỉ đọc:** M3 ĐÃ bật quan sát (`OPS_CORE_ENABLED=true`; 627 lần hỏi bán được/24 giờ, tất cả 200, 0 lỗi xác thực); principal M3 ACTIVE 10 quyền; 19 SKU nhưng 0 kích hoạt bán, 0 mẻ, 0 giữ hàng; hai kho cùng tên "Kho Bình Phú". Chi tiết: `2026-11-25-doc-99-va-nghiem-thu-m3-cuc-bo.md`.
- **Sheet:** thêm NM3-32 (M12-048) và NM3-21a (M12-042) Hoàn thành; NM3-30b 70.
- **G3 hẹp lại:** quan sát M3 đã bật ⇒ việc của Phúc còn: bật `STOCK_BALANCES` sau khi có tồn, đẩy bản M3 lên kho chung, ghim hợp đồng mới, xác nhận kho `…002`.

## 7. Câu hỏi cho Toàn (đề xuất ở cuối mỗi dòng)

- ~~m12.220, 221, 222, 203~~ ĐÃ TRẢ (D-m12-136): đẩy hợp đồng `main` OK (đã làm), đọc `.99` chỉ đọc OK (đã đọc), tin Phúc OK (Toàn tự gửi, bản 2), mẻ 27/11 = mẻ THẬT đầu tiên (A).
- **m12.223 (ĐÃ SỬA, D-m12-137)** hai kho cùng tên hiển thị nhưng KHÁC LOẠI (`…001` nguyên liệu, `…002` thành phẩm): KHÔNG ngừng; đổi tên hiển thị + thêm vị trí kho.
- **m12.224 (mới)** vì mẻ 27/11 là THẬT (m12.203 = A): ai chốt nguyên liệu + nhà cung cấp thật và có mặt nguyên liệu tại kho trước 8:00 27/11 (gộp m12.206). Đề xuất: Lan + chú Dũng báo Toàn trước tối 26/11, Toàn nhập dữ liệu nền.
