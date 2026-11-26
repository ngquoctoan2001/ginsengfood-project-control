# M1–M2 · Rà 10 hồ sơ và cập nhật Sheet ngày 26/11/2026

Toàn duyệt rà theo m12.245, gộp việc theo m12.246, giữ đường qua IP máy theo m12.240 A và cắt sự kiện vòng đời SKU theo m12.241 A. Hai agent chia nhau rà 10 hồ sơ. Phiên Sheet đối chiếu kết quả với nhật ký, lịch sử Git và tab M1-M2. `main`, `origin/main`, `gitlab/main` cùng ghi `d4163331c` khi rà. Bản `.99` ghi nhận gần nhất là `7c7d07234` Development. Phiên này dùng hồ sơ kiểm đã có. Lượt chạy test thuộc phiên UAT duy nhất.

## 1. Năm dòng Sheet đã ghi và đọc lại

| Mã | Dòng | Trạng thái trước → sau | Ghi chú nối thêm |
|---|---:|---|---|
| M12-038 | 39 | Chưa bắt đầu → Hủy | Gộp WP06 từ `.60`/`.61` vào M12-054 (NM3-45b trên `.99`). Bằng chứng nghiệm thu ở M12-054. |
| M12-025 | 26 | Đang làm → Hủy | Gộp phạm vi WP16 bốn tên miền cũ vào gói chuyển Production `.99`, WP17b/M12-030. |
| M12-056 | 57 | Đang làm → Hủy | Giữ kết nối qua IP máy `.99` đến sau 30/11, tạm gác mạng Docker chung. Allowlist và kiểm đường hiện hành theo gói Production. |
| M12-063 | 64 | Đang làm → Hủy | Tạm gác thiết kế mạng Docker chung. Đo IP nguồn và kiểm đường hiện hành ở P7. |
| M12-093 | 94 | Chưa bắt đầu → Hủy | Cắt sự kiện vòng đời SKU qua outbox. M3 tiếp tục kéo danh mục và trạng thái qua API SKU. |

CLI xác nhận cập nhật các dòng 26, 39, 57 lúc 08:31 và các dòng 64, 94 lúc 08:32. Đã đọc lại từng ID bằng `get`: trạng thái J = Hủy, H = Đã hủy, ghi chú mới được nối sau ghi chú cũ. Các trường còn lại khớp trước và sau khi ghi, gồm người phụ trách, tiến độ, nhánh, commit, bằng chứng và W/X. Đọc lại toàn tab: **123 việc, 60 Hoàn thành, 5 Hủy, 58 còn mở** (27 Đang làm, 18 Chưa bắt đầu, 11 Chờ review, 2 Bị chặn).

## 2. Kết quả rà m12.245 theo từng mã

Mười dòng dưới vẫn có J = Chờ review trên Sheet. `node tools/task-tracker/sheet-sync.mjs` hỗ trợ đọc W/X qua `get` và `list`, còn `upsert` thiếu cả trường `leadReview` và `leadNote`. Bảng ghi kết luận để đồng bộ khi CLI có thao tác cho hai cột này. H/J của mười dòng giữ theo Sheet hiện tại để tránh cập nhật rời phần duyệt Lead.

| Mã | W hiện tại | Kết luận rà | Bằng chứng và việc còn thiếu |
|---|---|---|---|
| M12-001 | Cần sửa | **Đạt** | D-lead-043 và nhật ký Lead 14/11 ghi Apps Script 1.5.1 đã sửa tiêu đề tuần. Chín dòng đã ghi và đọc lại khớp. Lượt rà đọc lại bằng `weekly-list` cho kỳ 26–31/10, nhận một dòng M12. [Nhật ký Lead](../../lead/nhat-ky/2026-11-14.md) |
| M12-031 | Chưa duyệt | **Chưa duyệt toàn phạm vi** | WP02c `.61` đạt phần migration 152, sáu container khỏe, dead-letter 55→0, smoke LAN đạt. m12.7 dừng sau dry-run theo quyết định. Thiếu bằng chứng bốn tên miền HTTPS trên `.61`. Phần hiện hành theo WP17b Production `.99`. [Nhật ký 11/11](../nhat-ky/2026-11-11.md) |
| M12-106 | Chưa duyệt | **Chờ Toàn duyệt diff R3** | Gộp nhánh chú lần 3 `9f0e40b60` và sửa sau rà `1e1580878` qua verifier. Lượt nâng `.99` ngày 17/11 ghi tại D-m12-094. Cả hai commit nằm trong lịch sử `7c7d07234`. [Hồ sơ lần 3](2026-11-16-chudung-m12-lan3.md) |
| M12-110 | Chưa duyệt | **Chờ Toàn duyệt diff R3** | Verifier vòng 2 đạt 5/5, bộ kiểm trên `faf6a7452` xanh, commit có trong lịch sử bản `.99` ghi nhận. D-m12-112/113 là quyết định cho lượt vận hành, phần duyệt diff R3 còn mở. [Hồ sơ lần 4](2026-11-18-chudung-m12-lan4.md) |
| M12-111 | Đạt | **Giữ Đạt** | Phần 1–2 đã được duyệt. Phần 3 `d8b76b015` và sửa `588528f12` có verifier R2 đạt. Hồ sơ dựng DB sạch ghi seed hai lượt và E07 đạt, với seed 43/48 trong manifest sau phần sửa. [WP23](../wp/M12-WP23-menu-quan-tri.md) · [Hồ sơ DB sạch](../wp/deploy-99-db-sach-1911.md) |
| M12-114 | Chưa duyệt | **Chờ Toàn duyệt R3** | WP26 qua verifier. Nhật ký ghi Toàn đã dùng mã mail thật ở localhost. P0 ngày 25/11 ghi cờ đăng nhập mail `.99` bật. Còn bằng chứng đăng nhập đầu-cuối tại ops./pwa. trên `.99` và chữ ký duyệt diff. [WP26](../wp/M12-WP26-dang-nhap-mail.md) · [Nhật ký 25/11](../nhat-ky/2026-11-25.md) |
| M12-117 | Chưa duyệt | **Đạt** | `006d181af` nâng Shopfloor PWA lên Next 16.4.6. Đã đối chiếu package và lockfile tại `7c7d07234`. Bản tổ tiên `3e84ab68b` qua pipeline 13/13 và triển khai `.99` ngày 20/11. [Nhật ký 20/11](../nhat-ky/2026-11-20.md) |
| M12-119 | Chưa duyệt | **Chờ Toàn duyệt R3** | WP29 đã triển khai. Bộ kiểm độc lập 31/31 sau sửa test U02 `738d91808`. Còn Toàn bấm trang chi tiết người dùng và bằng chứng bố cục phù hợp ở WP28. [WP29](../wp/M12-WP29-chi-tiet-nguoi-dung.md) · [Nhật ký 25/11](../nhat-ky/2026-11-25.md) |
| M12-120 | Chưa duyệt | **Chưa duyệt, cần bổ sung bằng chứng** | Phần sửa WP30 `62f6b7cec` qua verifier và nằm trong bản triển khai đã ghi nhận. Tiêu chí WP30 yêu cầu không còn lỗi L1–L4 ở 1366/1920 và có ảnh trước/sau cho phiếu nhận, thương phẩm và màn lọc. Chuyển phần kiểm bố cục cho phiên UAT duy nhất, dùng lại kết quả verifier sẵn có. [Tiêu chí WP30](../wp/M12-WP30-33-gop-y-20-11.md) |
| M12-121 | Chưa duyệt | **Chờ Toàn duyệt R3** | Gia hạn trượt đã bật theo hồ sơ ngày 23/11. Verifier `4907f1cd0` và lượt cổng Nguy hiểm ngày 25/11 đều ghi Đạt. Hai điểm S3 về đăng xuất đồng thời và seed quyền đã được ghi nợ. [Cổng Nguy hiểm](2026-11-25-cong-nguy-hiem-tong-hop-cho-toan.md) |

M12-122 giữ Chờ review/Chưa duyệt. Cờ quên mật khẩu ghi nhận gần nhất là tắt.

## 3. Đồng bộ hai dòng UAT lúc 08:47–08:48

Đã đọc sổ và đếm kết quả mới nhất theo 2.326 mã catalog. Bốn dòng cuối đều Đạt trên `d4163331c`, gồm A01-F03-T03, A02-F03-T03, J03-F01-T02 và J03-F01-T04. Kết quả **1.814 Đạt, 0 Không đạt, 59 Không áp dụng, 453 chưa chạy** khớp biên bản lượt UAT. [Biên bản lượt UAT](2026-11-26-luot-uat-codex.md)

Đã ghi tựa và ghi chú **453 ca** vào M12-009 (dòng 10) và M12-105 (dòng 106). M12-105 ghi còn 106/108 ca trong các lô ưu tiên. Đọc lại cả hai dòng khớp nội dung, vẫn H = Đang chạy, J = Đang làm, W = Chưa duyệt. Ghi chú Lead X và các trường ngoài phạm vi khớp trước và sau khi ghi.
