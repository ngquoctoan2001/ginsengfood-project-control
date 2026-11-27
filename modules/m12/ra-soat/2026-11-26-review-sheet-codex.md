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

## 4. Đồng bộ quyết định nối M3 lúc 09:37–09:39

| Mã | Dòng | Kết quả đọc lại |
|---|---:|---|
| M12-067 | 68 | Hoàn thành phạm vi chốt QD-RS theo D-m12-140. Ghi chính sách kho, SKU, audit và hạn giữ. Việc đổi cờ, quyền và hạ tầng tiếp tục theo mã triển khai riêng. Bộ đồng bộ tự đặt tiến độ 100% và ngày hoàn thành 26/11. |
| M12-050 | 51 | Đang làm. Đã rà hợp đồng và WP07b-B. Giữ NO-GO tạm cho đến khi có mẻ bán được, nghiệm thu đầu-cuối NM3-45b và Toàn quyết GO. Bộ đồng bộ tự đặt ngày bắt đầu 26/11. |
| M12-085 | 86 | Giữ Đang làm, 55%. Ghi đã chọn cảnh báo Windows 15 phút, chờ `go m12.242` để tạo lịch và duyệt phạm vi đọc `.99`. |

Đã đọc lại từng ghi chú, giữ nội dung cũ và W/X. Toàn tab có **123 việc, 61 Hoàn thành, 5 Hủy, 57 còn mở** gồm 28 Đang làm, 16 Chưa bắt đầu, 11 Chờ review và 2 Bị chặn. [Hồ sơ nối M3](2026-11-26-noi-m3-codex.md)

## 5. Đồng bộ mốc UAT lúc 09:46

Sổ đến dòng 2.878 có thêm bốn ca L18 Đạt: J01-F01-T01, J01-F01-T02, J01-F01-T06 và J01-F02-T02. Không có dòng chạy lại mã đã Đạt trong các lô ưu tiên. Tally mới nhất tại lần đọc là **2.326 ca = 1.818 Đạt + 0 Không đạt + 59 Không áp dụng + 449 chưa chạy**. Sáu lô ưu tiên còn 102 ca gồm L12 (23), L14 (14), L15 (24), L16 (10), L17 (13) và L18 (18). [Biên bản lượt UAT](2026-11-26-luot-uat-codex.md)

Đã cập nhật tựa và ghi chú M12-009 (dòng 10) và M12-105 (dòng 106) về 449 ca. M12-105 ghi còn 102/108 ca ưu tiên. Đọc lại bằng CLI khớp, hai dòng giữ Đang làm và W/X khớp trước/sau. Phiên UAT tiếp tục ghi kết quả các lô tuần tự trong sổ.

## 6. Theo dõi sáu lô ưu tiên sau mốc 09:46

Đếm theo kết quả mới nhất của từng mã catalog. Phiên UAT duy nhất sở hữu lượt chạy và ghi sổ. Phiên phụ trách Sheet đối chiếu sổ rồi cập nhật tựa và ghi chú tại M12-009/105, giữ trạng thái và W/X. [Biên bản lượt UAT](2026-11-26-luot-uat-codex.md)

| Mốc đọc lại Sheet | Lô và thay đổi từ mốc trước | Tổng Đạt | Tổng Không đạt | Tổng Không áp dụng | Tổng Bị chặn | Tổng chưa chạy | Ưu tiên chưa chạy |
|---|---|---:|---:|---:|---:|---:|---:|
| 09:55–09:56 | L18 thêm 3 Đạt, J01-F03-T01, J01-F03-T02, J01-F03-T04. Sổ đến dòng 2.881. | 1.821 | 0 | 59 | 0 | 446 | 99 |
| 09:58 | L12 thêm 4 Đạt, D02-F13-T01, D02-F14-T01, D04-F02-T01, D04-F05-T01. Sổ đến dòng 2.885. | 1.825 | 0 | 59 | 0 | 442 | 95 |
| 10:05–10:06 | L12 thêm 2 Đạt (D02-F14-T02, D04-F03-T01) và 1 Bị chặn (D04-F04-T01). Sổ đến dòng 2.888. | 1.827 | 0 | 59 | 1 | 439 | 92 |
| 10:10–10:11 | L12 xác nhận D04-F04-T01 **Không đạt** và nối kết luận mới ở dòng 2.889. | 1.827 | 1 | 59 | 0 | 439 | 92 |
| 10:18–10:19 | Mốc giữa L12 lúc 10:13. Thêm 2 Đạt ở cổng nhà cung cấp (D05-F01-T02, D05-F02-T03). Sổ đến dòng 2.891. L12 còn 14 ca chưa chạy và 1 ca Không đạt. | 1.829 | 1 | 59 | 0 | 437 | 90 |
| 10:45 | Kiểm lại D04-F04-T01 ở dòng 2.892: đã chọn được vị trí, còn lỗi tìm theo số phiếu. Kết quả toàn ca giữ Không đạt. | 1.829 | 1 | 59 | 0 | 437 | 90 |
| 10:47–10:48 | D04-F04-T01 ở dòng 2.893: đã đối chiếu số tồn trước/sau KCS. Còn lỗi tìm số phiếu, giữ Không đạt. | 1.829 | 1 | 59 | 0 | 437 | 90 |
| 11:03–11:04 | Giữa L12, thêm 3 Đạt ở PWA nhận nguyên liệu (D06-F01-T02, D06-F01-T03, D06-F01-T04). Sổ đến dòng 2.896. L12 còn 11 chưa chạy và 1 Không đạt. | 1.832 | 1 | 59 | 0 | 434 | 87 |
| 11:06 | Giữa L12, thêm 1 Đạt (D06-F01-T05) và 1 Không đạt (D06-F01-T01). Sổ đến dòng 2.898. L12 có 12 Đạt, 2 Không đạt và 9 chưa chạy. | 1.833 | 2 | 59 | 0 | 432 | 85 |
| 11:21–11:22 | Kiểm lại D04-F04-T01 trên Chrome Đạt ở dòng 2.899. L12 có 13 Đạt, 1 Không đạt và 9 chưa chạy. | 1.834 | 1 | 59 | 0 | 432 | 85 |
| 11:36 | L12 đã có kết quả đủ 23 ca: 22 Đạt, 1 Không đạt (D06-F01-T01), 0 Bị chặn và 0 chưa chạy. Dòng 2.900–2.908 thêm 9 Đạt về ký KCS PWA và tồn kho. | 1.843 | 1 | 59 | 0 | 423 | 76 |
| 12:02 | L14 đã rà 14 mã ở dòng 2.909–2.922: 9 Đạt, 2 Không đạt và 3 Bị chặn. Ba ca bị chặn còn cần kiểm khi có mẫu. | 1.852 | 3 | 59 | 3 | 409 | 62 |
| 12:25–12:26 | L15 đã rà 24 mã ở dòng 2.923–2.946: 15 Đạt, 9 Không áp dụng, 0 Không đạt, 0 Bị chặn. | 1.867 | 3 | 68 | 3 | 385 | 38 |
| 12:37 | L16 đã rà 10 mã ở dòng 2.947–2.956: 9 Đạt, 1 Bị chặn. | 1.876 | 3 | 68 | 4 | 375 | 28 |
| 12:57 | Dòng 2.957 thêm H01-F07-T01 Đạt ở L17. Dòng 2.958 chốt D06-F01-T01 Đạt sau kiểm lại. L12 đủ 23/23 Đạt. | 1.878 | 2 | 68 | 4 | 374 | 27 |
| 13:09 | L14 gỡ 3 ca Bị chặn ở dòng 2.962–2.964, chốt 12 Đạt và 2 Không đạt. L17 đang chạy, có 2 Đạt và 2 Không đạt. | 1.882 | 4 | 68 | 1 | 371 | 24 |
| 13:16–13:17 | Dòng 2.965 bổ sung nhánh nhân viên xác nhận hộ của D06-F01-T01. Ca vẫn Đạt, chỉ tính một mã. | 1.882 | 4 | 68 | 1 | 371 | 24 |
| 13:26 | L17 đã rà 13 mã đến dòng 2.974: 8 Đạt, 3 Không đạt, 2 Bị chặn. | 1.888 | 5 | 68 | 3 | 362 | 15 |
| 13:37 | L18 đã rà đủ 24 mã đến dòng 2.989: 19 Đạt, 5 Bị chặn. Sáu lô ưu tiên đều có kết quả theo mã. | 1.898 | 5 | 68 | 8 | 347 | 0 |

**D04-F04-T01:** Phiên vai kiểm toán chỉ chọn được “Tất cả vị trí” sau khi chọn kho nhận. Đã đối chiếu bút toán và liên kết nguồn. Còn thiếu thao tác lọc vị trí và đối chiếu cùng lô trước/sau ký KCS. L12 vẫn đang chạy, còn 16 ca chưa chạy và 1 ca bị chặn ở mốc 10:06.

**Xác nhận 10:10:** API trả đúng hai vị trí trong trường `locationId`. Giao diện lọc theo `warehouseLocationId` nên danh sách bỏ cả hai vị trí. D04-F04-T01 chuyển sang Không đạt. Cần sửa bộ lọc rồi kiểm lại vị trí và đối chiếu cùng lô trước/sau ký KCS. M12-009/105 đã đọc lại khớp kết luận mới và giữ W/X.

**Kiểm lại 10:44:** Trên Chrome đã chọn được vị trí sau sửa. Tìm số phiếu vẫn cho kết quả rỗng dù bút toán đúng xuất hiện khi xóa riêng ô tìm kiếm. Chưa đối chiếu được tồn của cùng lô sau ký KCS. Hai dòng Sheet đã cập nhật lý do và đọc lại khớp. Toàn duyệt để phiên UAT và IVR chạy đồng thời trên máy. M1–M2 tiếp tục dùng một phiên UAT chạy tuần tự.

**Bổ sung 10:47:** Vai nghiệp vụ ký KCS đạt 10 kg trên cùng lô demo. Vai kiểm toán đối chiếu tồn khả dụng/tạm giữ từ 0/10 kg sang 10/0 kg. Ca vẫn Không đạt vì tìm số phiếu trả rỗng. Đã cập nhật và đọc lại lý do trên cả hai dòng Sheet, giữ W/X.

**D06-F01-T01, mốc 11:04:** PWA đồng bộ đúng 10 kg và tạo một lô Chờ KCS. Phiếu giữ mã lô NCC cũ và lô mua không lưu vùng nguồn nhập. Phiên UAT ghi Không đạt theo catalog, cần chốt quy tắc nghiệp vụ cho phép thay mã lô NCC lúc nhận và xác minh vùng nguồn với lô tự trồng. D06-F01-T05 đạt kiểm chống tạo trùng. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**D04-F04-T01, mốc 11:21:** Lượt tích hợp tìm số phiếu đạt 1/1. Trên Chrome, vai kiểm toán tìm đúng số phiếu và thấy bút toán 10 kg khi dùng đồng thời các lọc kho, vị trí, lô, chứng từ, hướng và ngày. Phiên UAT đối chiếu cùng bút toán, số phiếu và vị trí sau đổi build, dùng lại bằng chứng cùng lô trước/sau ký KCS. Dòng 2.899 chốt Đạt. Đã đọc lại M12-009/105 khớp kết luận và giữ W/X. Số chưa chạy vẫn 432 vì đây là ca kiểm lại. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L12, mốc 11:36:** Đã đồng bộ và đọc lại M12-009/105 với 423 ca chưa chạy và 76 ca ưu tiên chưa chạy. M12-009/105 giữ Đang làm và W/X. Kết quả Không đạt còn ở D06-F01-T01, đã ghi nguyên nhân và chờ chốt quy tắc nghiệp vụ. Phiên UAT chuyển sang L14. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L14, mốc 12:01:** E07-F03-T01/T02/T04 bị chặn vì thiếu phiếu xuất `APPROVED` có tồn khả dụng đủ ở đúng lô/vị trí. Phiếu demo còn phù hợp chỉ có 0,429 kg khả dụng so với 2,5 kg đã duyệt. Mẫu MRP 10 kg còn thiếu chứng từ trước khi tạo lệnh. E07-F01-T01 Không đạt do thiếu bộ lọc trạng thái. E07-F04-T04 Không đạt do PWA cho gửi số nhận lệch mà thiếu lý do và hàng đợi tiếp tục báo Đang gửi sau khi máy chủ từ chối. Đã cập nhật và đọc lại M12-009/105, giữ W/X. Phiên UAT chuyển sang L15. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L15, mốc 12:26:** 15 ca đóng gói cấp 1/cấp 2 và kiểm QR đạt. Chín ca F05-F04/F05 Không áp dụng theo D-m12-103 và D-m12-140 về hoãn in tem. Không có ca bị chặn của L15. M12-009/105 đã cập nhật và đọc lại 385 ca chưa chạy, trong đó có 38 ưu tiên chưa chạy. Ba ca L14 bị chặn giữ riêng. Phiên UAT chuyển sang L16. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L16, mốc 12:37:** G03-F01-T04 Bị chặn. Mẻ demo hiện thuộc thu hồi. Cần mẻ đã sấy, chưa ký KCS và ngoài thu hồi để kiểm riêng nhánh Giữ lại thiếu lý do. Chín ca còn lại của L16 Đạt. M12-009/105 đọc lại khớp 375 ca chưa chạy, trong đó 28 ưu tiên. Tổng 4 ca Bị chặn vẫn ghi riêng. Phiên UAT chuyển sang L17. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L12 kiểm lại, mốc 12:57:** D06-F01-T01 Đạt trên Chrome lab cả phiếu mua do NCC tự xác nhận và phiếu tự trồng. Phiếu mua lưu mã lô NCC mới. Phiếu tự trồng lưu đúng xuất xứ và vùng nguồn. Mỗi lệnh tạo một lô Chờ KCS và tạm giữ 10 kg. Phiếu nhân viên xác nhận hộ đang lệch giữa PWA và API, ghi riêng trong biên bản và nằm ngoài kết luận hai nhánh đã kiểm ở ca này. Đã đọc lại M12-009/105 với W/X giữ nguyên. Số chưa chạy giảm một do ca mới của L17. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L14 kiểm lại, mốc 13:07:** E07-F03-T01/T02/T04 Đạt bằng phiếu xuất demo đã duyệt đủ 10 kg theo luồng FRM-12/13. Kiểm được cả xuất, chặn thiếu xác nhận và chống gửi trùng. Hai ca Không đạt trước giữ nguyên. L17 ở mốc này có H02-F01-T01 Không đạt do bộ lọc dùng sai tên trường vị trí và H02-F03-T01 Không đạt do tìm số phiếu trả rỗng, còn 9 ca chưa chạy. M12-009/105 đọc lại khớp 371 ca chưa chạy và chỉ còn 1 ca bị chặn ở L16. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L12 bổ sung, mốc 13:17:** D06-F01-T01 Đạt thêm nhánh phiếu nhân viên xác nhận hộ. Hồi quy đạt 1/1. Chrome kiểm trạng thái và Chromium tích hợp kiểm ảnh, lưu lệnh khi mất API, đồng bộ sau nối lại đúng một lần. Phiếu giữ trạng thái xác nhận hộ, lưu mã lô NCC mới và tạo một lô Chờ KCS tạm giữ 10 kg. Hai nhánh cũ dùng lại bằng chứng. Tổng theo mã và W/X giữ nguyên sau khi đọc lại Sheet. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L17, mốc 13:25:** H05-F04-T01 Bị chặn phần tự nhả vì lab tắt tác vụ nền và mẫu đã nhả đều trước hạn. H07-F01-T05 Bị chặn vì chưa có lần nhập qua PWA áp dụng để thử gửi lại. H07-F01-T01 Không đạt theo catalog vì PWA cho gửi trước khi FRM-22 đủ chữ ký. API từ chối, phiếu và tồn giữ nguyên theo hướng dẫn hiện hành. Hai ca Không đạt khác là H02-F01-T01 và H02-F03-T01 đã ghi ở mốc trước. M12-009/105 đã đọc lại khớp, giữ trạng thái và W/X. Chỉ còn L18 có 15 ca ưu tiên chưa chạy. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L18, mốc 13:36:** J03-F02-T01/T02/T03 Bị chặn do runner không quét được tem qua camera thật. J03-F03-T01 thiếu bằng chứng nguồn gốc đã duyệt và mở được qua HTTPS. J03-F04-T01 đã thấy hướng dẫn cài trong trình duyệt và chưa mở được trang từ biểu tượng. 19 ca còn lại Đạt. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

## 7. Kết quả 102 ca ưu tiên giao tiếp nối

Đối chiếu sổ từ mốc 2.878 dòng đến 2.989 dòng, có đúng **102 mã mới được kết luận** trong sáu lô, gồm **80 Đạt, 5 Không đạt, 9 Không áp dụng, 8 Bị chặn**. Không có dòng chạy lại mã đã Đạt trước mốc 2.878. Các lượt kiểm lại bản sửa và nhánh xác nhận hộ được nối vào lịch sử, mỗi mã chỉ tính một lần theo kết quả mới nhất.

Hai dòng M12-009/105 đọc lại lúc 13:37 khớp toàn sổ **1.898 Đạt, 5 Không đạt, 68 Không áp dụng, 8 Bị chặn và 347 chưa chạy**. Hai dòng giữ Đang làm và W/X. Ghi chú M12-105 còn 0 ca ưu tiên chưa chạy và liệt kê 8 ca bị chặn theo nhóm. Các lý do theo từng mã ở mốc L16, L17 và L18. 347 ca chưa chạy thuộc các lô khác. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

## 8. Đồng bộ các lô tiếp theo

| Mốc đọc lại Sheet | Lô và căn cứ | Tổng Đạt | Tổng Không đạt | Tổng Không áp dụng | Tổng Bị chặn | Tổng chưa chạy |
|---|---|---:|---:|---:|---:|---:|
| 13:45–13:46 | L01 đủ 26 mã, 25 Đạt và 1 Không đạt. Dòng 2.990–3.013 thêm 24 kết quả, giữ 2 ca Đạt từ lượt trước. | 1.921 | 6 | 68 | 8 | 323 |
| 13:49–13:50 | L02 rà đủ 5 mã ở dòng 3.014–3.018, 4 Đạt và 1 Bị chặn. | 1.925 | 6 | 68 | 9 | 318 |
| 13:58 | L03 rà đủ 26 mã ở dòng 3.019–3.044, 25 Đạt và 1 Bị chặn. | 1.950 | 6 | 68 | 10 | 292 |
| 14:14 | L17 kiểm lại ba ca ở dòng 3.045–3.047, hai ca chuyển Đạt, một ca giữ Không đạt. | 1.952 | 4 | 68 | 10 | 292 |
| 14:22 | Dòng 3.048 chốt H02-F03-T01 Đạt sau kiểm lại thao tác chuột. L17 có 11 Đạt, 2 Bị chặn. | 1.953 | 3 | 68 | 10 | 292 |
| 14:25 | L04 khép đủ 24 ca ở các dòng 3.049–3.072, tất cả Đạt. | 1.977 | 3 | 68 | 10 | 268 |
| 14:36 | L05 khép đủ 26 ca ở các dòng 3.073–3.098, gồm 23 Đạt, 1 Không đạt, 2 Bị chặn. | 2.000 | 4 | 68 | 12 | 242 |
| 14:44 | L06 khép đủ 26 ca ở các dòng 3.099–3.124, gồm 24 Đạt, 1 Không đạt, 1 Bị chặn. | 2.024 | 5 | 68 | 13 | 216 |
| 15:02 | Dòng 3.125–3.127 ghi ba ca trước đó Không đạt chuyển Đạt sau kiểm lại. | 2.027 | 2 | 68 | 13 | 216 |
| 15:04 | Mốc UAT 15:03 ở dòng 3.125–3.129 đủ năm ca kiểm lại Đạt. Hai dòng mới của L14 khép phần còn Không đạt. | 2.029 | 0 | 68 | 13 | 216 |
| 15:06 | Dòng 3.130–3.131 ghi phân trang kho chuyển Đạt, biểu đồ xu hướng vẫn Bị chặn. | 2.030 | 0 | 68 | 12 | 216 |
| 15:12 | L07 khép 25/25 Đạt, L06 gỡ ca Bị chặn cuối cùng ở các dòng 3.132–3.157. | 2.056 | 0 | 68 | 11 | 191 |
| 15:24–15:25 | L08 khép đủ 25 ca ở các dòng 3.158–3.182, tất cả Đạt. | 2.081 | 0 | 68 | 11 | 166 |
| 15:41 | Dòng 3.183–3.212 khép L09 với 23 Đạt, 1 Không đạt, 1 Bị chặn và ghi 5 Đạt ở L10. | 2.109 | 1 | 68 | 12 | 136 |
| 15:45 | Dòng 3.213 ghi kiểm lại nhãn SKU Đạt. L09 có 24 Đạt, 1 Bị chặn. | 2.110 | 0 | 68 | 12 | 136 |
| 16:00 | Dòng 3.214–3.237 khép L10 ở 19 Đạt, 6 Bị chặn, đồng thời ghi 4 Đạt ở L11. | 2.128 | 0 | 68 | 18 | 112 |
| 16:10–16:11 | Dòng 3.238–3.242 khép L11 với 7 Đạt, 2 Bị chặn. | 2.131 | 0 | 68 | 20 | 107 |
| 16:28 | Dòng 3.243–3.260 khép L13 (4 Đạt, 1 Bị chặn), L19 (3 Đạt, 1 Bị chặn) và L20 (6 Đạt, 1 Không đạt, 2 Bị chặn). | 2.144 | 1 | 68 | 24 | 89 |
| 16:43 | Dòng 3.277 khép lỗi cuối của L20. L20 có 7 Đạt, 2 Bị chặn. Kết quả mốc gồm phần đã kiểm của L21/L22. | 2.158 | 0 | 68 | 26 | 74 |
| 17:02–17:03 | Dòng 3.307 khép lượt đầu L21 với 18 Đạt, 1 Không đạt, 6 Bị chặn. L22 còn 2 chưa chạy. | 2.174 | 1 | 68 | 38 | 45 |
| 17:13 | Dòng 3.315–3.336 gồm phần khép L23 ở 23 Đạt, 2 Bị chặn. | 2.201 | 1 | 68 | 40 | 16 |
| 17:22–17:23 | Dòng 3.337–3.350 khép L24 với 18/18 Đạt. L22 còn 2 ca chưa chạy. | 2.215 | 1 | 68 | 40 | 2 |
| 17:26–17:27 | Dòng 3.351 ghi N01-F05-T01 Đạt sau khi kiểm lại biên nhận xóa dữ liệu demo. | 2.216 | 0 | 68 | 40 | 2 |
| 17:28–17:29 | Dòng 3.352–3.353 khép L22 ở 13 Đạt, 8 Bị chặn. Đã rà đủ các lô. | 2.218 | 0 | 68 | 40 | 0 |
| 17:37 | Dòng 3.354 ghi B08-F09-T05 Đạt trên bản sao demo riêng. L09 đạt 25/25. | 2.219 | 0 | 68 | 39 | 0 |
| 17:46–17:47 | Dòng 3.355–3.357 gỡ hai ca B3 ở L05 và một ca tự duyệt ở L23. | 2.222 | 0 | 68 | 36 | 0 |
| 17:50 | Dòng 3.358–3.360 gỡ ba ca lịch sử G1 ở L10 và L11. | 2.225 | 0 | 68 | 33 | 0 |
| 17:55 | Chốt lượt UAT duy nhất sau dòng 3.361. L22 kiểm lại thao tác Gửi lại thủ công vẫn Bị chặn. | 2.225 | 0 | 68 | 33 | 0 |

**L01:** A03-F01-T01 Không đạt vì breadcrumb ở màn Người dùng & Vai trò chỉ có văn bản và thiếu liên kết trở về. Đã đọc lại tựa và ghi chú M12-009/105 khớp 323 ca chưa chạy cùng kết quả L01. Trạng thái và W/X giữ nguyên. Phiên UAT chuyển sang L02. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L02, mốc 13:49:** A04-F04-T01 Bị chặn. API lab cho 0 điểm ở tất cả chuỗi trong khoảng 14 ngày, nên chưa kiểm được thao tác trỏ điểm và tính độc lập của bộ lọc. Bốn ca cảnh báo Đạt. M12-009/105 đọc lại khớp 318 ca chưa chạy và 9 bị chặn, trạng thái và W/X giữ nguyên. Phiên UAT chuyển L03. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L03, mốc 13:56:** B02-F01-T01 Bị chặn tại bước chuyển trang. Danh sách kho demo chỉ có một trang, cần dữ liệu đủ cho trang tiếp theo. Các ca đơn vị tính, kho, vị trí và chống thao tác trùng còn lại Đạt. M12-009/105 đọc lại khớp 292 ca chưa chạy và 10 bị chặn. Trạng thái và W/X giữ nguyên. Phiên UAT dừng ở ranh giới lô để kiểm lại ba ca L17 theo yêu cầu của Toàn. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L17 kiểm lại, mốc 14:13:** H02-F01-T01 Đạt lọc tồn đúng kho và vị trí. H07-F01-T01 Đạt theo luồng đã sửa: PWA khóa gửi khi thiếu chữ ký, ký đủ FRM-22 bên Quản trị mới ghi đúng một bút toán 6 hộp. H02-F03-T01 tìm được đúng số phiếu và Enter mở đúng, nhưng bấm chuột trên anchor vẫn mở Tồn theo lô. Giữ Không đạt ở thao tác chuột. Hai lý do Bị chặn của L17 giữ nguyên. Đã đọc lại M12-009/105, giữ W/X. Tổng chưa chạy vẫn là 292 vì chỉ kiểm lại. Phiên UAT tiếp L04. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L17 bổ sung, mốc 14:20:** H02-F03-T01 chuyển Đạt sau khi đưa cột Chứng từ lên sau Mẻ sản xuất. Kiểm bấm chuột ở 1280 px mở đúng phiếu, một dòng hàng và một dòng sổ cái 12 hộp. Kế thừa kết quả tìm số phiếu và lọc ở lượt trước. Hai ca bị chặn giữ nguyên. Đã đọc lại ghi chú M12-009/105, giữ trạng thái và W/X. Phiên UAT nối lại L04. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L04, mốc 14:25.** 24/24 ca Đạt. Đã kiểm lý do bắt buộc khi ngừng kho và vị trí, cấu hình Boolean, danh mục lý do và che giá trị mẫu. Bảy lượt bấm kép ghi đúng một sự kiện mỗi lượt. Đã đọc lại M12-009/105. Phiên UAT chuyển L05. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L05, mốc 14:35.** B04-F01-T01 và B04-F02-T05 Bị chặn vì cả tám vật tư lab đều đã có ngưỡng mẫu hoặc đã xác nhận, thiếu vật tư B3 chưa khai. B06-F05-T05 Không đạt ở thông báo do giao diện thiếu phiên bản công thức, dù máy chủ chặn đúng việc ngừng nguyên liệu đang dùng. Đã đọc lại M12-009/105. Phiên UAT chuyển L06. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L06, mốc 14:43.** B07-F07-T01 Bị chặn vì lab thiếu hồ sơ nguồn bị từ chối kèm lý do. Hai hồ sơ đã kiểm được ảnh, dòng thời gian, người và thời gian xác minh. B07-F09-T04 Không đạt vì nhật ký chỉ lưu trạng thái sau khi đổi tên nguồn. Đã đọc lại M12-009/105. Phiên UAT tạm ngắt trước L07 để kiểm lại bốn ca đã được Toàn yêu cầu. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**Kiểm lại ba ca L01, L05 và L06.** Sổ ghi A03-F01-T01, B06-F05-T05 và B07-F09-T04 chuyển Đạt. Đã đọc lại M12-009/105. Tổng chưa chạy vẫn là 216 vì đây là ba ca kiểm lại.

**Kiểm lại đủ năm ca, mốc 15:03.** Ngoài ba ca đã đồng bộ trước, E07-F01-T01 Đạt ở bộ lọc việc Xuất nguyên liệu và đọc lại bản lưu khi ngắt API PWA. E07-F04-T04 Đạt ở việc khóa gửi thiếu nội dung lý do khi nhận lệch 7 kg so với 7,5 kg. L14 có 14/14 Đạt. Đã đọc lại M12-009/105. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L02/L03 kiểm lại phân trang và biểu đồ.** B02-F01-T01 Đạt sau khi thêm 18 kho đã ngừng dùng trong lab, kiểm được nút Trang sau và tải lại tại trang 2. L03 đạt 26/26. A04-F04-T01 giữ Bị chặn vì không có điểm theo ngày và ba chuỗi hiện là số việc tồn, còn catalog yêu cầu sản lượng và khối lượng nhập/xuất. Đã đọc lại M12-009/105. Phiên UAT tiếp L07. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L07, mốc 15:12.** 25/25 Đạt qua vòng đời nguồn và tám lượt bấm kép có đúng một sự kiện mỗi lượt. Ca L06 B07-F07-T01 chuyển Đạt khi đọc được lý do, ảnh, người và giờ từ chối ở hồ sơ demo trước khi chuyển về Nháp. L06 đủ 26/26. Đã đọc lại M12-009/105. Phiên UAT tiếp L08. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L08, mốc 15:24.** 25/25 Đạt. Đã kiểm hai nhánh ngưng nguồn, tải ảnh khớp tệp mẫu, tạo và chỉnh SKU demo, quy tắc cỡ mẻ và hiển thị ở 768 px. Đã đọc lại M12-009/105. Phiên UAT tiếp L09. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L09, mốc 15:41.** B08-F09-T05 Bị chặn vì thiếu bản sao demo riêng để kiểm ngừng hẳn SKU gốc. B08-F13-T01 Không đạt vì ô chọn chỉ hiện nhãn chung dù đã mở đúng SKU và đúng phạm vi dữ liệu. L10 có 5 Đạt ở luồng tạo công thức G1, còn 20 chưa chạy. Đã đọc lại M12-009/105. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L09 kiểm lại, mốc 15:44.** B08-F13-T01 Đạt. Liên kết mở đúng GTIN và ô chọn hiển thị đúng mã, tên SKU demo. B08-F09-T05 giữ Bị chặn do thiếu bản sao demo riêng. Đã đọc lại M12-009/105. Phiên UAT nối L10 từ B09-F04. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L10, mốc 16:00.** B09-F06-T01/T02/T04 Bị chặn vì chưa có công thức còn chờ duyệt sau khi đề nghị gần nhất bị hủy, luồng hủy chuẩn của lab đưa công thức về Nháp. B09-F07-T04 và B09-F08-T05 thiếu công thức thử APPROVED_SEED_BASELINE. B09-F09-T01 thiếu công thức pilot đã điều chỉnh có mẻ cũ để đối chiếu hai phiên bản. L11 đã có 4 Đạt, còn 5 chưa chạy. Đã đọc lại M12-009/105. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L11, mốc 16:10.** B09-F10-T01 và B09-F10-T04 Bị chặn vì G1 demo độc lập chưa có mẻ chạy thử và snapshot trước điều chỉnh. Mẫu có lịch sử đang được dùng trong lab chung. Đề nghị chốt chạy thử tạo đúng một yêu cầu và một audit. Đã đọc lại M12-009/105. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L13, L19 và L20, mốc 16:27.** D06-F03-T05 (L13), J04-F01-T04 (L19), K03-F01-T04 và K03-F02-T05 (L20) Bị chặn vì PWA vô hiệu nút gửi với lệnh Đã gửi và thiếu thao tác phát lại cùng mã tới máy chủ. K03-F02-T01 Không đạt vì thẻ ghi khóa tem QR nhưng chi tiết hiện Phạm vi khác và thiếu mã. Chưa gửi ACK tem. Đã đọc lại M12-009/105. Phiên UAT kiểm lại đúng ca QR. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L20 kiểm lại, mốc 16:42.** K03-F02-T01 Đạt khi phạm vi và mã tem QR hiển thị đúng. ACK tem áp dụng một lần và khóa vẫn hoạt động. K03-F01-T04 và K03-F02-T05 vẫn Bị chặn vì thiếu thao tác phát lại lệnh đã gửi trên PWA. L22 đã ghi N07-F01-T02 Đạt sau sửa nhãn lô hợp lệ và mã lạ. L21 và L22 vẫn đang chạy. Đã đọc lại M12-009/105. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L21, mốc 17:02.** N01-F01-T01, N01-F02-T01 và N01-F03-T01/T02/T04 Bị chặn do vai R-OPS-MGR thiếu quyền Mobile trong lab. N01-F03-T01 còn cần người kiểm trực tiếp nhập và xác nhận thông tin thử. N07-F06-T05 thiếu tác vụ sạch của đúng vai để xếp lệnh trước rồi kích hoạt giữ hoặc thu hồi trên cùng nguồn demo. N01-F05-T01 Không đạt vì dữ liệu demo đã xóa nhưng thông báo vẫn bảo còn lệnh chưa gửi và thiếu biên nhận. Đã đọc lại M12-009/105. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L23, mốc 17:13.** O03-F01-T04 Bị chặn vì tài khoản demo của người gửi không vào được và thiếu yêu cầu thường do tài khoản hiện có gửi. O03-F01-T06 thiếu mẫu duyệt hai người có đủ đối tượng từ trước quyết định đầu. Đã duyệt A2 demo đúng một lần và trả cấu hình menu, màn demo về ban đầu. Đã đọc lại M12-009/105. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L24, mốc 17:22.** 18/18 Đạt. Kiểm được chuỗi nhật ký hợp lệ, một lượt xác minh 17.828 dòng và chặn mã ghép thiết bị của người khác. Hai ca cuối ở L22 cần trạng thái xung đột hoặc rà soát thực. Đã đọc lại M12-009/105. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L21 kiểm lại.** N01-F05-T01 Đạt. Tab thao tác hiện đúng số lệnh và ảnh demo đã xóa cùng biên nhận. Tab thứ hai về Đăng nhập và không hiện biên nhận của tab thao tác. L21 có 19 Đạt, 6 Bị chặn. Đã đọc lại M12-009/105. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L22, mốc kết lượt.** N07-F10-T02 và N07-F11-T01 Đạt khi thử lại và mở đúng lệnh xung đột, không tạo mã mới hay ghi chấm công. Sáu ca N07-F07-T01/T02/T03 và N07-F08-T01/T02/T03 Bị chặn do PWA thiếu chọn nhiều lệnh, gửi mục chọn và tự gửi mục chọn. N07-F10-T01 Bị chặn vì app tự gửi trước thao tác Gửi lại thủ công. N07-F02-T01 Bị chặn vì máy thử thiếu camera đọc mã. Đã đọc lại M12-009/105. Toàn sổ không còn ca chưa chạy. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L09 kiểm bổ sung, mốc 17:36.** B08-F09-T05 Đạt trên bản sao demo tách riêng. SKU ngừng hẳn, phát sinh đúng một sự kiện nhật ký. Tồn 1.000 hộp khả dụng, bút toán và lịch sử giữ nguyên. SKU trong lab nguồn vẫn ở trạng thái ban đầu. Đã đọc lại M12-009/105 lúc 17:37. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L05 và L23 kiểm bổ sung, mốc 17:46.** B04-F01-T01 và B04-F02-T05 Đạt trên bản sao demo. Đã kiểm vật tư B3 chưa khai rồi lưu ngưỡng 10,5 và 20 gói, có một sự kiện nhật ký. Phiếu 04 lấy đúng ngưỡng mới; tồn và bút toán giữ nguyên. O03-F01-T04 Đạt khi hệ thống chặn người gửi tự duyệt, giữ yêu cầu Chờ duyệt và 0 quyết định. L05 đạt 26/26, L23 còn O03-F01-T06 thiếu mẫu duyệt hai người. Đã đọc lại M12-009/105. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**L10 và L11 kiểm bổ sung, mốc 17:49.** B09-F10-T01, B09-F10-T04 và B09-F09-T01 Đạt trên bản sao demo. Bấm kép chỉ tạo một bản sửa G1 và một sự kiện nhật ký. Mẻ cũ giữ dữ liệu của bản gốc. Giao diện phân biệt đúng phiếu chạy thử cũ với công thức đang dùng và báo thiếu phiếu đạt cho bản đang dùng. L11 đạt 9/9, L10 đạt 20/25. Đã đọc lại M12-009/105. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

**Chốt lượt UAT lúc 17:55 ngày 26/11.** Dòng 3.361 giữ N07-F10-T01 Bị chặn vì ứng dụng tự gửi khi đường API hoạt động lại trước lúc người kiểm bấm Gửi lại. Lượt UAT cục bộ đã dừng ở mốc này. Đã đọc lại M12-009/105 lúc 17:55, hai dòng khớp sổ và giữ trạng thái đang làm. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

## 9. Các ca Bị chặn khi chốt lúc 17:55 ngày 26/11

M12-009 và M12-105 đã đọc lại theo số liệu trên 2.326 bước. Có 2.225 Đạt, 0 Không đạt, 68 Không áp dụng, 33 Bị chặn và 0 chưa chạy. Bảng ghi điều kiện còn thiếu cho từng mã. [Biên bản UAT](2026-11-26-luot-uat-codex.md)

| Lô | Mã ca | Lý do Bị chặn |
| --- | --- | --- |
| L02 | A04-F04-T01 | Lab thiếu điểm theo ngày. Ba chuỗi đang hiển thị số việc tồn, còn catalog yêu cầu sản lượng và khối lượng nhập/xuất. |
| L10 | B09-F06-T01, B09-F06-T02, B09-F06-T04 | Thiếu công thức vẫn Chờ duyệt sau khi đề nghị gần nhất bị hủy. Luồng hủy chuẩn trả công thức về Nháp. |
| L10 | B09-F07-T04, B09-F08-T05 | Thiếu công thức thử có trạng thái APPROVED_SEED_BASELINE. |
| L13 | D06-F03-T05 | PWA khóa nút gửi khi lệnh đã gửi thành công, chưa phát lại được cùng mã lệnh chuyển lô. |
| L16 | G03-F01-T04 | Mẻ thử đang thuộc đợt thu hồi. Cổng thu hồi chặn xác nhận, chưa kiểm riêng được cổng yêu cầu lý do khi chọn Giữ lại. |
| L17 | H05-F04-T01 | Các phiếu mẫu đều nhả trước hạn. Tác vụ nền đang tắt và chưa có mẫu tự nhả sau hạn. |
| L17 | H07-F01-T05 | Thiếu lần nhập kho thành phẩm thành công do PWA gửi. Chưa kiểm được phát lại cùng mã của lần gửi đã áp dụng. |
| L18 | J03-F02-T01, J03-F02-T02, J03-F02-T03 | Lab thiếu điện thoại và kết nối an toàn để quét tem, đối chiếu hồ sơ trước/sau và kiểm nút dừng khi camera đã mở. |
| L18 | J03-F03-T01 | Thiếu tệp bằng chứng nguồn gốc đã duyệt và mở được qua HTTPS. |
| L18 | J03-F04-T01 | Trình duyệt lab chưa mở được cổng công khai từ biểu tượng đã cài. |
| L19 | J04-F01-T04 | PWA khóa nút gửi khi lệnh đã gửi thành công, chưa phát lại được cùng mã ghi nhận tem. |
| L20 | K03-F01-T04, K03-F02-T05 | PWA khóa nút gửi khi lệnh đã gửi thành công, chưa phát lại được cùng mã của CAPA hoặc ACK. |
| L21 | N01-F01-T01, N01-F02-T01, N01-F03-T01, N01-F03-T02, N01-F03-T04 | Vai R-OPS-MGR thiếu quyền Mobile trên lab. N01-F03-T01 còn cần người kiểm trực tiếp nhập và xác nhận thông tin thử. |
| L21 | N07-F06-T05 | Thiếu tác vụ xuất, nhập hoặc đóng gói sạch, đúng vai để xếp lệnh trước khi giữ hoặc thu hồi cùng nguồn demo. |
| L22 | N07-F07-T01, N07-F07-T02, N07-F07-T03, N07-F08-T01, N07-F08-T02, N07-F08-T03 | Hàng đợi chưa có chọn nhiều lệnh, gửi mục chọn hoặc tự gửi mục chọn. |
| L22 | N07-F10-T01 | Đã kiểm lại ở dòng 3.361. Khi mở lại đường API, app tự đồng bộ và lệnh sang Đã gửi trước lúc người kiểm bấm Gửi lại. Chưa xác minh được thao tác thủ công. |
| L22 | N07-F02-T01 | Máy thử thiếu camera phù hợp để đọc và dừng quét mã thật. |
| L23 | O03-F01-T06 | Thiếu mẫu duyệt hai người có đủ đối tượng, ở trạng thái chưa có quyết định đầu. |
