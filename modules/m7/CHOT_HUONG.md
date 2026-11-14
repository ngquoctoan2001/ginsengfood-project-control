# Chốt hướng M7 — brainstorm 31/10/2026

Nguồn: phiên "Cải tiến module gen video" (repo golden-hour-video) và phiên `m7`. Điểm 5 đã ghi DL-030 (31/10, M7-WP01); các điểm khác
**chưa ghi vào repo**. Khi chốt xong cả hướng: một WP tài liệu ghi `DL-031` trở đi vào `docs/00-overview/DECISION_LOG.md`, sửa BRD/SRS/SAD theo cột cuối,
gỡ `BLOCKED-DEC`, đóng các `DL-O` liên quan, chạy `check_docs.py` và `gen_traceability.py --check`. Commit khi Lead bảo.

## Lead đã nói

| # | Nội dung | Thay / đóng | Docs phải sửa |
|---|---|---|---|
| 1 | Stack .NET + PostgreSQL + Next.js | bổ sung DL-020; ADR-13 (bỏ SPA Vite); DL-O31 (a) | SAD bảng container và cổng, ADR-13, env web, CI |
| 2 | M7 tự sản xuất video và điều phối chương trình Giờ Vàng, chung một repo. Công cụ tạo video có sẵn chỉ là cách làm tham khảo; repo đó để nguyên, mọi việc làm trong repo M7 | DL-008, DL-O07; BRD "M7 không sản xuất video" | BRD, SRS (VJB, AST), SAD phần CF |
| 3 | Khung hình cấu hình được (hồ sơ đầu ra); thiết kế linh hoạt để mở rộng | — | SRS F04: 1920×1080, 30 fps thành hồ sơ mặc định |
| 4 | 70 phút, master 4.200 giây (giữ như docs; "75 phút" là nhầm) | — | không |
| 5 | Kịch bản, prompt hình và Judge sinh bằng Claude: 2 tài khoản Max/Ultra của công ty, đổi được sang API key; M7 gọi Claude trực tiếp qua port AI, adapter đổi bằng cấu hình (m7.6) | **Đã ghi DL-030** (31/10): thay DL-007, một phần DL-024, vế (1) DL-014 cho AI sinh chữ; đóng DL-O08, DL-O68 | Đang sửa: `wp/M7-WP01.md` |
| 6 | Tạo clip bằng Muse tự động như hiện tại, chấp nhận rủi ro điều khoản. Để sẵn adapter: Seedance (API), Muse (API khi có), HeyGen (API) | DL-014 (1) phần video; DL-O12 | SAD phần nhà cung cấp video, FR-VJB |
| 7 | Duyệt: ai có quyền thì xem và duyệt, không bắt người thứ hai | DL-O10 (b); luật bốn mắt FR-QAR-006, FR-BRF-007/008, F07 §2; phần người duyệt AMBER của DL-O11 | SRS F02, F05, F07 |
| 8 | Worker nặng (dựng ffmpeg, giọng đọc, Chrome điều khiển Muse) chạy trên máy để bàn; API, điều phối, PostgreSQL, web trên .61 (hiểu là đồng ý theo trích dẫn 31/10) | — | SAD triển khai; deploy contract |

## Còn phải chốt

- **m7.7** Trong M7 chia hai phân hệ: Studio (sản xuất) không bao giờ ghi "đã duyệt"; Program (Giờ Vàng) không tự sinh hình, tiếng.
- **m7.8** Bố cục 70 phút: neo một mốc ở 1.500 giây, hero và SKU phát lại 3 vòng (một tệp đoạn dùng nhiều lần trong master) (DL-O41).
- **m7.1** phạm vi 15/11 · **m7.2** cổng code (DL-011) — từ bảng đầu phiên.
