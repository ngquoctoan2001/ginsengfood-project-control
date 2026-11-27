# M12 ↔ M3 ngày 27/11 · 28 việc còn mở

Theo cột Pha trên Sheet M1–M2, 67 việc nối gồm 35 hoàn thành, 4 hủy và 28 còn mở. Phiên này xử lý bốn nhóm theo thứ tự mẻ thật, Production, theo dõi sau chuyển và các quyết định còn mở. UAT giao diện dừng tại L21. Bằng chứng của mẻ thật lưu nội bộ, sổ này chỉ giữ tình trạng và cách đối chiếu.

## 1. Mẻ thật và M12-054 · 5 việc

Biên bản 27/11 còn trống dòng 7 (nhập kho thành phẩm), dòng 9 (đối chiếu M3), mục tập huấn và chữ ký. Hồ sơ đã đọc chưa có bằng chứng bổ sung cho hai dòng 7 và 9. Giữ kết quả vật lý ở trạng thái chờ xác nhận. [Biên bản mẻ thật](../wp/M12-010-bien-ban-27-11.md)

| Mã | Phần đã làm | Phần cần đủ để đóng |
| --- | --- | --- |
| M12-054 | Rà phạm vi, lập bảng S01–S18 bên dưới và sửa đích Sheet sang `.99`. | Toàn xác nhận mẻ đã phát hành và nhập kho, SKU đã kích hoạt, kho và đơn vị. Phúc xác nhận bản M3 phục vụ và cho kết quả quan sát khớp với M12. Các ca còn lại cần diễn tập hoặc cửa sổ được duyệt. |
| M12-077 | Ghi rõ phạm vi một SKU cho mẻ đầu và tiêu chí đóng 19 SKU của task. | Toàn xác nhận SKU đã kích hoạt và tồn bán được trong biên bản riêng. Chốt đủ phạm vi kích hoạt trước khi đóng dòng. |
| M12-051 | Đối chiếu D-m12-140. Cờ tự nhả giữ tắt. | Sau một vòng đối chiếu mẻ thật và có bằng chứng diễn tập, trình Toàn quyết riêng cho từng môi trường. |
| M12-052 | SOP đã có tại commit `973225ac4`. Kịch bản tập vai có trong bộ 27/11. | Xác nhận buổi tập Lan và các mục vận hành §7, gồm trách nhiệm xác nhận khi soạn hàng, hết hạn, nhả tay và đầu mối trực. |
| M12-094 | Lấy đúng tập 19 mã từ Git blob `d4163331c`, chạy `--dry-run-csv` trên 19 dòng giả lập và xác nhận cú pháp đạt. `CODES_SHA256=95469fb627c5d20e1dae3ceb6b952949e25501c07911aca0fecdb406f4a07428`. | Phúc cung cấp CSV bốn cột `sku_code,ops_core_sku_id,uom_code,ops_core_warehouse_id` từ môi trường đang phục vụ. Khi có CSV, chạy kiểm cú pháp trước. Đối chiếu API thật qua nguồn được duyệt, so tập mã, kho thành phẩm, trạng thái và băm tập mã. |

### Bảng nghiệm thu S01–S18

Bảng theo [kế hoạch mục 8](../ke-hoach/noi-m12-m3-2026-11-11.md#8-kiểm-thử-và-nghiệm-thu). Runner hỗ trợ 18 mã hợp đồng/WP06a và 7 mã S08–S14. Ngày 25/11 lưu một lượt cục bộ 25/25 và lượt đối chứng tắt worker, S11 đỏ đúng kỳ vọng. Hai lượt có thư mục bằng chứng nội bộ riêng. Lượt 25/25 kiểm API M12, sáu ca kiểm thêm parser tương đương M3. Ngày 25/11 ghi nhận 627 lượt hỏi khả dụng HTTP 200 khi chưa có mẻ bán được. Đợt nâng Development ngày 26/11 ghi thêm 19/19 HTTP 200. Hai mốc này là bằng chứng kết nối đã quan sát. [Hồ sơ phạm vi cục bộ và cổng NK-b](2026-11-26-noi-m3-codex.md) · [Kết quả nâng Development](2026-11-26-chuan-bi-production-codex.md#kết-quả-m12243b-ngày-2611)

| Ca | Bằng chứng đang có | Cần ghi để đạt đầu-cuối |
| --- | --- | --- |
| S01 | Đã quan sát cấp token hoạt động. | Phúc ghi hết hạn, M3 xin lại đúng một lần, hồi phục và không lặp 401, phối hợp trong cửa sổ đã duyệt. |
| S02 | Ca hợp đồng 4 và 14 đạt cục bộ. | Cùng SKU, kho và đơn vị mẻ thật. Hỏi lượng nằm trong tồn khả dụng, quan sát M3 nhận SELLABLE, đối chiếu dữ liệu khung và lượng từ hai phía. |
| S03 | Ca hợp đồng 5 và 14 đạt cục bộ. | Hỏi vượt tồn trên cùng SKU, kho và đơn vị, nhận NOT_SELLABLE và STOCK_NOT_AVAILABLE. Bằng chứng UI hết hàng thu riêng nếu quan sát mới có phản hồi và log. |
| S04 | Ca hợp đồng khóa bán đạt cục bộ. | Kiểm M3 xử lý đúng trạng thái khóa hoặc thu hồi trong diễn tập. |
| S05 | Yêu cầu đã có trong kế hoạch. | Diễn tập thiếu liên kết SKU/kho, xác nhận phản hồi nghiệp vụ và log phía M3. |
| S06 | Có bộ kiểm parser tương đương ở phía M12. | Đối chiếu fixture lệch khung trong môi trường diễn tập M3 và kết quả ghi cảnh báo. |
| S07 | Yêu cầu đã có trong kế hoạch. | Diễn tập gián đoạn, chậm hoặc 429, đối chiếu xử lý và hồi phục phía M3. |
| S08 | M12 cục bộ đạt giữ và phát lại. | Diễn tập adapter M3, đối chiếu một bản ghi giữ theo cùng khóa. |
| S09 | M12 cục bộ đạt tranh chấp cuối hàng. | Diễn tập hai yêu cầu trên fixture riêng, đối chiếu một giữ thành công và một thiếu tồn. |
| S10 | M12 cục bộ đạt nhả và phát lại. | Diễn tập M3 hủy đơn, ghi kết quả nhả và trạng thái hai phía. |
| S11 | M12 cục bộ đạt khi worker bật. Đối chứng tắt worker thất bại như dự kiến. | Diễn tập giữ ngắn, ghi worker nhả và M3 phát hiện rồi xử lý qua đối soát. |
| S12 | M12 cục bộ đạt nhánh CONFIRMED. | Diễn tập kho đã xác nhận, M3 nhận xung đột đúng và chuyển cho kho xử lý. |
| S13 | M12 cục bộ đạt ISSUED. | Dùng DB diễn tập một lần cho bước xuất kho. Bổ sung bằng chứng parser và xử lý M3. |
| S14 | M12 cục bộ đạt mô phỏng bù trừ. | Diễn tập adapter M3 sau khi lỗi ghi đơn, đối chiếu tồn và giữ hàng trước/sau. |
| S15 | Có kịch bản thu hồi. | Diễn tập thu hồi riêng và quan sát M3 đổi trạng thái bán trong chu kỳ yêu cầu. |
| S16 | Bên nhận M3 đã có triển khai theo Sheet, đệm TLS có tiêu chí riêng. | Phúc xác nhận bên nhận thật và ghi bằng chứng kiểm chữ ký, trùng, độ trễ và dead-letter theo kế hoạch. |
| S17 | Sau nâng Development đã quan sát 19/19 HTTP 200. | Ghi chuỗi khởi động lại, xin token và hồi phục của M3 theo cửa sổ được duyệt. |
| S18 | Có kiểm đồng hồ lịch sử ngày 25/11. | Đối chiếu cảnh báo và dung sai bằng diễn tập lệch giờ. |

Lượt này ghi cả 18 ca NM3-45b ở `NOT_RUN` cho phạm vi mới. Khi có mẻ thật, S02 và S03 là hai lượt đối chiếu quan sát riêng, không tạo đơn. Kế hoạch dùng mẫu 10 và 2.000 hộp. Nếu lượng tồn thực tế đòi lượng hỏi khác thì ghi lượng và lý do. Mỗi ca ghi giờ, phiên bản hai bên, chế độ, nguồn, lượng khả dụng, lượng hỏi, đơn vị, quyết định hoặc blocker, dấu vết đối chiếu và người kiểm. Ngữ cảnh thiếu, ca SKIP và bằng chứng cục bộ được ghi rõ khi bàn giao. Hồ sơ `profiles/99.json` hiện mô tả DB sandbox cũ. Trước lượt thật cần điền kỳ vọng theo snapshot đã duyệt. Giữ S08–S10 và S12–S14 trong phần diễn tập khi cờ tự nhả ở môi trường thật đang tắt. S11 cũng tạo giữ trên fixture diễn tập.

## 2. Chuyển Production · 11 việc

Ứng viên đã được chọn theo D-m12-140. Đã tính lại SHA-256 từ byte Git `d4163331ce9804f625c81bc448a23a2298f757b4` và kiểm cú pháp 11 script gói bằng `bash -n`. Hai kết quả khớp phiếu chuyển.

| Blob | SHA-256 đã đối chiếu |
| --- | --- |
| Compose | `1df348da708da6831537a02b59e1de860c37fde70f3eebf8a3ff522481b1a550` |
| Caddyfile | `3639671f7118bfbb7a4624751a1a8c32912196794d3c333b06ce170c719f7a3c` |

P0 mới sau mẻ và P1–P7 chờ lệnh. P0 ngày 25/11 ghi nhận một ảnh thử bản rõ. Khi có lệnh kiểm, xác nhận dấu vết và phạm vi ảnh trước khi Toàn quyết việc cách ly. Phải giữ khả năng đọc kho chứng cứ cùng khóa đã đặt theo D-m12-139. [Phiếu thực thi, kiểm và quay lui](2026-11-26-chuan-bi-production-codex.md#2-production--m12244)

| Mã | Bước | Bằng chứng cần thu |
| --- | --- | --- |
| M12-043 | P3, P7 | Nguồn thực tế lời gọi M3 và allowlist đúng phạm vi. Nhánh tự sửa allowlist của P7 cần có trong lệnh Toàn. |
| M12-045, M12-061 | P3, P6, P7 | Tuyến đệm có TLS hợp lệ, 204 từ API mới. Phần bên nhận M3 thật tiếp tục ở M12-055. |
| M12-046 | P6, P7 | Phúc quan sát M3 xin lại token đúng một lần rồi gọi thành công, không lặp 401. |
| M12-064 | P1–P7 | Sao lưu PASS, SHA đúng, PostgreSQL giữ ID và dịch vụ khỏe, bàn giao cấu hình và đường lui. |
| M12-069 | P2, P7 | Xác nhận của Toàn về khóa JWT mới khác lịch sử và dấu vết đối chiếu, giữ khóa mã hóa bằng chứng. Ngoại lệ hết 30/11 16:59Z. |
| M12-071, M12-072, M12-074 | P5, P7 | Kiểm vhost, publish cổng, sức khỏe, chế độ Production và bề mặt công khai theo runbook. |
| M12-086 | P1, P6, sau chuyển | Sao lưu trước/sau, cùng ID PostgreSQL. Kiểm cổng SEC-19 trước thao tác toàn stack kế tiếp. |
| M12-087 | Trước chuyển, P6 | Toàn và Anh Tuấn xác nhận đường TLS. Phúc xác nhận bên nhận thật và đầu mối phối hợp khi gián đoạn. |

Toàn cần chốt cửa sổ sau khi xưởng ngừng ghi, lệnh P0 mới, việc cách ly chính xác nếu ảnh thử còn, phạm vi P1–P7, xác nhận JWT và thông báo Phúc gián đoạn dự kiến 1–2 phút. Lưu dấu vết theo pha ở nội bộ. Khi một pha lỗi thì ghi pha cuối, trạng thái và dùng đường lui của đúng lượt theo phiếu đã duyệt.

## 3. Theo dõi sau chuyển và ký · 6 việc

Mốc 25–26/11 dùng làm số gốc về kết nối. Đã kiểm khô monitor với cửa sổ 20 phút. Nó thoát 3 và ghi rõ chế độ chạy khô. Chưa có bộ số liệu sau chuyển. Chuẩn bị cùng một phiếu cho trực M12 và M3 để đối soát theo mốc giờ.

| Mã | Phần đã chuẩn bị | Chờ bằng chứng |
| --- | --- | --- |
| M12-047 | Mốc gốc 25/11 có 627 lượt availability, 8 lượt cấp token và 1 lượt danh mục đều 200. Mốc nâng Development 26/11 có 19/19 lượt availability 200. | Mỗi lượt thực ghi cửa sổ, trạng thái outbox, dead-letter, giữ sắp/quá hạn, 401/403/429, p95 và cách xử lý. |
| M12-055 | Tiêu chí S16 và cách phân biệt chặng đệm với bên nhận thật đã ghi. | Phúc xác nhận bên nhận và bàn giao khóa ký riêng. Sau lệnh Toàn, ghi 2xx ở bên nhận, kiểm chữ ký, chống trùng và số dead-letter mới. |
| M12-057 | Có mẫu phiếu trực dưới đây. | Trực hai bên 28–30/11 theo cửa sổ thực tế, nhật ký đối soát và xử lý sự cố từng ngày. |
| M12-059 | Đã lập khung bảng tổng kết N8.1–N8.9 và N8.11. | Đủ dấu vết đầu-cuối, nhật ký trực và đối chiếu sổ Lead, M12, M34. |
| M12-060 | Đã đổi đích nghiệm thu thành `.99` trong Sheet. | M12-054 và M12-059 đủ bằng chứng, cờ tắt khẩn hai bên đã kiểm, thứ tự SEC-11 được Toàn chốt và Toàn ký. |
| M12-065 | Đã ghép phạm vi WP06/C37 và S01–S18 vào kế hoạch sau chuyển. | Tách kết quả theo SHA và chế độ. Một bằng chứng đúng phiên bản, dữ liệu và tiêu chí có thể dùng cho hai mã việc. |

**Phiếu trực dùng mỗi ngày 28–30/11.** Ghi khoảng giờ, phiên bản M12/M3, môi trường, hai người trực, số và tỷ lệ khớp tồn/giữ, p95, số lỗi theo mã, outbox chờ/lỗi/quá hạn, phân bổ sắp hết hạn, sự cố/cách xử lý và tham chiếu riêng. Nếu thiếu một nguồn thì đánh dấu chưa đo tại cột đó.

| Ngày | Giờ và bản hai bên | Trực M12/M3 | Khớp tồn và giữ, p95 | Lỗi, outbox, hết hạn | Sự cố và tham chiếu nội bộ |
| --- | --- | --- | --- | --- | --- |
| 28/11 | Chờ ghi nhận | | | | |
| 29/11 | Chờ ghi nhận | | | | |
| 30/11 | Chờ ghi nhận | | | | |

| Điểm nối | Căn cứ để tổng kết M12-059 |
| --- | --- |
| N8.1 Token | S01/S17, số lượt xin lại, dấu vết hồi phục và mã lỗi. |
| N8.2 Kiểm bán được | S02–S07, đối chiếu lượng và phản hồi M3, kết quả diễn tập lỗi. |
| N8.3 Kéo tồn/danh mục | Đối chiếu tồn và liên kết SKU/kho theo M12-094, ghi cách đồng bộ nhất quán. |
| N8.4 Giữ, N8.5 nhả, N8.6 ISSUED | S08–S14 kèm các trạng thái giữ/hết hạn/xác nhận/xuất và bù trừ hai phía. |
| N8.7 Webhook, N8.8 thu hồi | S16/M12-055 và S04/S15 theo mốc và nơi nhận. |
| N8.9 SKU | Đồng bộ danh mục và đối chiếu liên kết theo D-m12-140. |
| N8.11 Mạng | Bằng chứng nguồn, TLS, allowlist, hồi phục sau chuyển và đối chiếu thời gian phù hợp. |

## 4. Các quyết định và phụ thuộc · 6 việc

| Mã | Phần đã làm | Cần ai chốt |
| --- | --- | --- |
| M12-050 | Hợp đồng đã publish/ghim `a57a11f`, WP07b-B đã duyệt và có kết quả lịch sử. Giữ NO-GO tạm cho giữ/nhả hàng thật và bật chặn bán. | Phúc xác nhận cổng P4 và bản M3 phục vụ. Toàn chốt sau khi có mẻ bán được, NM3-45b, diễn tập và cửa sổ quan sát 48–72 giờ, khớp ≥99%, p95 <500 ms và 0 lệch khung. |
| M12-085 | Windows là kênh đã chọn. Chạy khô monitor cửa sổ 20 phút exit 3 đúng quy ước. Chuẩn bị kiểm nhịp 15 phút, phân biệt cảnh báo nghiệp vụ, lỗi đọc và chống báo lặp trong phần chồng cửa sổ. | Toàn giao `go m12.242`, phạm vi đọc và người trực. Tiêu chí đạt là tín hiệu thử đến người trực trong 15 phút. |
| M12-066, M12-078 | Đối chiếu công thức và OD-B12-04 ở mức hồ sơ. | Toàn và chú Dũng xác nhận từng A1, B1, C2, C3, ghi A/B/C. Với A/B có công thức hợp lệ, cập nhật và kiểm VeganGuard/API. Với C, giữ SAVORY và chốt cách xử lý nhãn M3. |
| M12-079 | Có OD-B12-04 và chú giải API. Kiểm CSV tại ứng viên thấy 19/19 dòng giữ tên nguồn công thức lịch sử “20 SKU”. | Toàn/chú Dũng chốt nguồn thay thế hoặc cách ghi nguồn gốc. Phúc/M34/M4 nhận nội dung đã chốt qua kênh phù hợp. |
| M12-070 | D-m12-140 dời xoay token Sheet sau 30/11. Hồ sơ SEC-11 đặt việc này trước NM3-99. | Toàn chốt thứ tự xoay và ký, hoặc ghi rõ quyết định chấp nhận dời. Sau xoay xác nhận thu hồi token cũ và đồng bộ ở sáu repo, chỉ ghi kết quả. |

### Các việc cần Toàn và Phúc cung cấp

- **Toàn, mẻ thật.** Xác nhận mục 7/9 đã có kết quả hay chưa. Nếu đã có, dùng kênh nội bộ cho tham chiếu mẻ, SKU kích hoạt, kho, đơn vị và lượng khả dụng. Chốt buổi tập Lan.
- **Phúc, đối chiếu M3.** Xác nhận bản đang phục vụ và chế độ quan sát. Lấy hai kết quả S02/S03 cho cùng SKU–kho–đơn vị, xác nhận tập link CSV đang phục vụ, nêu người trực và bên nhận webhook thật. M3-131, M3-132 và M3-128 vẫn cần đối chiếu trước GO theo Sheet đã đọc.
- **Toàn, cửa sổ.** Chốt phạm vi kiểm `.99` và cửa sổ Production riêng. Xác nhận JWT, việc cách ly ảnh thử nếu cần, và phạm vi tự sửa của P7. Chốt TLS với Anh Tuấn và báo Phúc trước cửa sổ.
- **Toàn, điều kiện còn lại.** Lệnh riêng cho tự nhả, lịch giám sát, quyết định NK-b, DIET-2 và thứ tự SEC-11 so với chữ ký NM3-99.

## Đồng bộ sổ và Sheet

- 10:54 · Mẻ thật. Đã cập nhật và đọc lại 5/5 dòng M12-054/077/051/052/094. M12-054 chuyển Đang làm vì đã bắt đầu chuẩn bị nghiệm thu. Biên bản và bảng S01–S18 đã cập nhật.
- 10:57 · Production. Đã cập nhật và đọc lại 11/11 dòng, ghi rõ bằng chứng cần thu ở từng pha. Hai băm và cú pháp gói đã đối chiếu. Chờ lệnh P0 và P1–P7.
- 10:58 · Theo dõi và ký. Đã cập nhật và đọc lại 6/6 dòng. Mẫu trực ba ngày và bảng tổng kết đã sẵn sàng. Đã cập nhật đích M12-060/065 về .99.
- 10:59 · Quyết định và phụ thuộc. Đã cập nhật và đọc lại 6/6 dòng. Ghi rõ NO-GO tạm, điều kiện lịch, công thức và thứ tự SEC-11.
- Đọc tổng sau bốn nhóm đủ 28/28 dòng. Nhóm nối M3 có 35 hoàn thành, 4 hủy, 15 đang làm và 13 chưa bắt đầu. Toàn M12 có 61 hoàn thành, 5 hủy và 57 còn mở trên 123 việc.

## Phúc xác nhận ngày 27/11

- **M12-054.** Theo Phúc, M3 đang phục vụ bản `586a3e7b8` từ 26/11 lúc 20:29, hỏi M12 trên `.99` mỗi 4 phút ở chế độ quan sát. Tại thời điểm Phúc báo, cả 19 SKU chưa bán được, lượng tồn bằng 0 và các lý do trả về phù hợp với việc chưa nhập kho. S02/S03 còn chờ mẻ trên môi trường M3 đang quan sát.
- **M12-094.** Phúc đã gửi hai trích xuất SKU và kho. Kiểm cục bộ đủ 19/19 mã theo danh mục chuẩn tại `d4163331c`, 19 ID SKU duy nhất và 19/19 đơn vị `hộp`. Tệp kho có một kho mặc định `GF-VN-HCM-01` → `WH-20112026-000002`. Ghép tạm bốn cột theo kho mặc định để chạy `--dry-run-csv`, kết quả `CU PHAP OK`. Băm tập mã vẫn khớp mốc §1. Đối chiếu ID, mã, trạng thái SKU/kho qua API của môi trường đang phục vụ là phần còn mở. Tệp đính kèm và các ID lưu riêng nội bộ.
- **M12-055.** Phúc báo bộ nhận webhook phía M3 đang tắt. Vòng hỏi 4 phút hiện là cơ chế M3 biết thay đổi. Phúc sẽ báo sau về người trực và đầu nhận. S16 tiếp tục chờ bằng chứng webhook tới bên nhận thật.
- **Điền hai lượt hỏi.** Sau khi FRM-22 của mẻ đúng môi trường đã xác nhận, lấy đúng mã SKU, kho và đơn vị. Đọc lượng bán được Q tại thời điểm kiểm. Với Q là số hộp dương và SKU đã đủ điều kiện, hỏi 1 hộp cho S02 và Q + 1 hộp cho S03. Ví dụ Q = 6 hộp thì gửi 1 và 7. Ghi hai kết quả, giờ kiểm, bản hai bên và lý do trả về. Mẻ tập trên lab cục bộ có dấu vết riêng ở môi trường demo.
- **Sheet.** Đã cập nhật và đọc lại M12-094 lúc 12:36, M12-054 và M12-055 lúc 12:37.

## Đối chiếu trên giao diện lúc 15:21

Sau khi Toàn cấp quyền Chrome và đăng nhập, đã kiểm chỉ đọc `ops.ginsengfood.vn`. Danh sách Nhập kho thành phẩm và Lệnh sản xuất ở bộ lọc mặc định trống. Màn Tồn theo SKU hiển thị 19/19 dòng Chưa có tồn, 0 mẻ, 0 đơn vị và 0 vị trí. Chưa có mã phiếu/mẻ và lượng khả dụng dương để đối chiếu. M12-054 còn mở; S02/S03 giữ `NOT_RUN`. Dòng 7/9 đã bổ sung căn cứ trong [biên bản](../wp/M12-010-bien-ban-27-11.md).
