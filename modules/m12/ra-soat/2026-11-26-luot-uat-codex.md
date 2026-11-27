# M1–M2 · Lượt UAT cục bộ 26/11/2026

- Bản kiểm `d4163331ce9804f625c81bc448a23a2298f757b4`. Phiên này giữ `@bo-kiem-du`. Hai sub-agent chỉ đọc hồ sơ fixture và sổ; phiên chính điều khiển trình duyệt và chạy lần lượt.
- Sổ lúc vào lượt có 2.870 dòng kết quả. Hai kết quả dưới được nối ở dòng 2.871–2.872, vòng `UAT468-L01-Codex-26/11`. Đã đối chiếu 2.870 dòng trước bằng byte.

| Mã | Kết quả | Quan sát trên trình duyệt tích hợp |
|---|---|---|
| A01-F03-T03 | Đạt | Cửa sổ chưa đăng nhập mở `/admin/dashboard`, chuyển về `/login`, hiển thị tiêu đề Đăng nhập. Mở lại cho cùng kết quả. |
| A02-F03-T03 | Đạt | Cửa sổ chưa đăng nhập mở `/admin/account`, chuyển về `/login`, hiển thị tiêu đề Đăng nhập. Mở lại cho cùng kết quả. |

Phạm vi hai ca là chuyển hướng ẩn danh trên admin-web `127.0.0.1:3204`. Các ca không cần phiên người dùng, dữ liệu nghiệp vụ hoặc API. Next dùng bộ nạp loại trừ tệp `.env*`; đã dừng tiến trình và trả lại hai tệp cấu hình Next tự ghi đúng byte Git. Quan sát thêm một cảnh báo tên truy cập của Input ở chế độ phát triển; chưa kết luận lỗi ca nào từ cảnh báo này.

## Kiểm truy xuất công khai, lô L18

API build đúng commit với 0 cảnh báo, 0 lỗi. DB dùng một lần tái tạo từ template demo UAT; bản migrate có cùng cây migration với commit API, nâng từ 149 lên 160. API và trang truy xuất chỉ bind loopback. Kiểm thấy `/health/live` trả 200. Thông tin kết nối và ký của lab sinh riêng trong tiến trình, không ghi vào hồ sơ. Dòng 2.873–2.874 có vòng `UAT468-L18-Codex-26/11`.

| Mã | Kết quả | Bằng chứng và đối chiếu |
|---|---|---|
| J03-F01-T02 | Đạt, cập nhật catalog | Bỏ trống bị chặn. Mã không tồn tại và QR `QUEUED` chưa in cùng hiển thị “Không tìm thấy thông tin”, đúng quy tắc che sự tồn tại của mã chưa in. Kiểm thêm QR `PRINTED` tắt công khai, hiện “Chưa có thông tin công khai”. Đối chiếu các trạng thái trong DB lab chỉ đọc. |
| J03-F01-T04 | Đạt, cập nhật catalog | Dán URL QR thử đã in và công khai, chuyển đúng đường dẫn mã. Mã lô và trạng thái “Đã xuất xưởng” khớp lần nhập trực tiếp và bản ghi mẻ `RELEASED` trong DB lab. Catalog đang mô tả hành vi URL cũ. |
| J03-F01-T01 | Đã quan sát một phần, chưa vào sổ | Tra mã trực tiếp hiện đúng lô thử và “Đã xuất xưởng”, QR hiện “Mã truy xuất hợp lệ”. Còn đối chiếu nhãn catalog và màn nội bộ J02 theo vai. |

## Điểm dừng và bàn giao máy

- Đã đọc lại sổ sau ghi: **2.326 ca = 1.814 Đạt, 0 Không đạt, 59 Không áp dụng, 453 chưa chạy**. Tăng 4 ca Đạt (2 L01 và 2 L18). Còn 106/108 ca trong sáu lô ưu tiên. Phiên này chưa thay Sheet.
- Tạm nhường lượt duy nhất cho phiên Production thực hiện m12.243b. Đã dừng Next admin/truy xuất và API, tháo container/network dùng một lần của lab. Cổng 3203, 3204, 5200 và 55439 không còn listener. Giữ template demo và artifact build để tạo lại lab sau bàn giao. Đã trả đúng byte các tệp cấu hình mà Next tự ghi. Cây ops-core còn các tệp supplier-portal dở của phiên khác.
- Sau khi nhận lại lượt, tạo lại DB demo, cấp tài khoản thử theo vai và ghép phiên thiết bị PWA. Ưu tiên tiếp L12, L14–L18. Ca quét QR, cài trang và media còn cần capability hoặc fixture tương ứng.

## Lượt kế tiếp, 106 ca theo danh sách Toàn giao

Đọc lại sổ rồi đối chiếu từng mã catalog. J03-F01-T02 và J03-F01-T04 đã Đạt, loại khỏi hàng đợi. Các số dưới đây là danh sách vào lượt, trước khi có kết quả mới.

| Lô | Ca còn | Dữ liệu và vai dùng để gom lượt |
|---|---:|---|
| L12 | 23 | 11 admin, 2 NCC, 10 PWA. Gom cặp lô 10 kg trước/sau QC, chứng từ nhập và sổ kho. Hai thao tác gán vị trí cần hai dòng tồn riêng chưa có vị trí. |
| L14 | 14 | Công việc xưởng trong phiên thiết bị ghép. Tách dữ liệu xuất và nhận vật tư theo trạng thái, kiểm nhánh ngoại tuyến sau khi có công việc tải sẵn. |
| L15 | 24 | Công việc đóng gói L1/L2, QR đúng và khác công việc, báo sự cố và yêu cầu in lại mô phỏng. Giữ mỗi ca ghi trên công việc có trạng thái phù hợp. |
| L16 | 10 | Phiên thiết bị QC, mẻ sau sấy và thành phẩm. Tách ký đạt, thiếu lý do HOLD/REJECT và gửi lại. |
| L17 | 13 | 8 admin, 5 PWA. So phiếu thành phẩm xác nhận/chờ ký; cần số dư theo lô, bản ghi giữ và lịch sử nhả hết hạn. |
| L18 | 22 | 14 admin, 8 công khai. Dùng một chuỗi demo cho tìm kiếm/phả hệ và QR công khai; hồ sơ thu hồi, mã vận đơn, media, quét camera và cài ứng dụng cần đúng tiền điều kiện. |

Phiên Production giữ `@bo-kiem-du` lúc chuẩn bị danh sách. Trong thời gian chờ, hai sub-agent chỉ đối chiếu catalog và fixture. Không có kết quả mới trong thời gian nhường máy.

Đã nhận lại `@bo-kiem-du` sau m12.243b. Máy vừa khởi động lại và container nguồn template UAT đang dừng. Lúc nhận lượt có `testhost` của IVR đang hoạt động, nên hoãn dựng lab đến khi lần chạy đó kết thúc.

09:21 đã nhả `@bo-kiem-du` theo điều phối phiên chính để áp các sửa 232/234/235. Lượt này chưa khởi động runner, chưa có ca đang chạy và chưa nối dòng kết quả. Cổng lab đã kiểm tra không còn listener. Giữ nguyên container/template/dữ liệu sẵn có. Chờ phiên chính bàn giao đúng bản rồi chạy một lượt `api:sync` và kiểm lọc trước khi tiếp tục 106 ca.

## Đồng bộ API cho các bản vá 232/234/235

- Nhận cây cục bộ `d4163331c` kèm 11 tệp vá. Chạy một lượt tương đương `api:sync`: build API, lấy `/openapi/v2.json` qua loopback với thư mục cấu hình tạm ngoài repo, dùng script repo chuẩn hoá và lọc OpenAPI, sinh client, chạy `api:client:check` và typecheck. Dùng khóa thử sinh mới trong tiến trình. Tránh script xuất cũ vì chạy Development từ trong repo. API build 0 lỗi, 0 cảnh báo; cả ba client đồng bộ; typecheck `packages/ui` và ba app đạt.
- Phạm vi sinh có ba tệp tracked đổi: OpenAPI, kiểu admin-web, dấu băm nguồn trong kiểu shopfloor-pwa. OpenAPI chỉ đổi `AuditLogDto` và thêm `AuditAllocationHoldExtensionDto`, không đổi đường dẫn. `git diff --check` đạt. Ba tệp supplier-portal dở và phần sổ tay đang sửa của phiên khác được giữ.
- 09:28 một lượt `dotnet test` IVR đã bắt đầu trên máy trước bước gọi bộ kiểm backend M1–M2. Dừng theo điều phối tại ranh giới sau typecheck. **Chưa chạy** `AuditApprovalOutboxBehaviorTests`, ca `Approve_release_stamps_reason_code_and_default_channel_on_audit`, hai tệp FE `audit-log-ui`/`stacked-name-code-cells` và kiểm tích hợp. Giữ đầu ra codegen để tiếp theo từ bước kiểm lọc, tránh sinh lại. Chưa có ca UAT mới và chưa thay Sheet.

### Kiểm lọc sau bàn giao 09:34

- Backend, lần đầu 7/15 đạt. Tám biến thể mới của m12.234 dừng ở bước tạo fixture vì thiếu `objectId` bắt buộc. Thêm ID giả lập ở ba chỗ tạo `AuditLog` trong `AuditApprovalOutboxBehaviorTests.cs`, chạy lại đúng ba phương thức bị ảnh hưởng: **8/8 đạt**. Hai biến thể phát hành m12.235 đạt ở lượt đầu. Tính theo từng ca, **15/15 đạt**. Build test báo một cảnh báo nullable trong `QcCriterionP8aTests.cs` ngoài phần vá.
- FE, lượt đầu `stacked-name-code-cells` **17/17**, `audit-log-ui` **32/33**. Một kỳ vọng dùng sai ký tự chỗ trống của giao diện. Cập nhật kỳ vọng thành `-` trong test, chạy lại đúng ca: **1/1 đạt**. Tính theo từng ca, **50/50 đạt**.
- Hai sửa tại chỗ nằm trong tệp test đã khai khoá. Giữ kết quả codegen và typecheck từ lượt trước. Các kết quả trên là kiểm lọc bản vá cục bộ, không cộng vào sổ 106 ca giao diện.

### Bắt đầu UAT sau bộ lọc, lô L18

Tạo lại API và DB lab loopback từ bản demo đã dùng cho UAT. App dùng cây `d4163331c` kèm bản vá cục bộ 232/234/235 và client đã đồng bộ. Cổng quản trị dùng phiên đúng vai `R-OPS-MGR`. Không chạy lại hai mã J03 đã đạt. Dòng sổ mới 2.875–2.878.

| Mã | Kết quả | Đối chiếu |
|---|---|---|
| J01-F01-T01 | Đạt | Tra QR demo đã in, có mẻ, lô nguyên liệu và phiếu nhập kho đúng chuỗi. Cảnh báo dữ liệu một phần xuất hiện với chuỗi lớn. Hồ sơ mẻ và phiếu kho khớp mẻ demo và 12 hộp; DB lab xác nhận phiên bản G1. |
| J01-F01-T02 | Đạt | Xóa giá trị rồi gửi và thử nhánh chuỗi trắng. Giao diện báo thiếu mã, chưa tạo truy vấn mới. |
| J01-F01-T06 | Đạt | Độ sâu 1 báo kết quả một phần. Ẩn khoảng hở, tải lại, đổi số dòng giữ đủ 10 kết quả; nút trang sau tắt đúng. Xóa lọc đưa về chưa có truy vấn. Hai sổ kho demo giữ nguyên số dòng. |
| J01-F02-T02 | Đạt, chỉnh catalog | Chuyển độ sâu phả hệ xuống 1, thấy cờ Bị giới hạn và câu cảnh báo dữ liệu một phần. Mở phiếu nguồn từ phả hệ, khớp mẻ và 12 hộp. Catalog còn câu cảnh báo cũ. |

Đã quan sát một phần J01-F01-T04 (768 px, sáng/tối, trường tìm và nút gửi còn hiển thị, vùng bảng có cuộn ngang nhưng thao tác phím chưa di chuyển) và J01-F02-T01 (đủ khối ở độ sâu 10, còn đối chiếu các liên kết nguồn ở truy vấn đó). Chưa tính Đạt cho hai ca này. L18 còn 18 ca, tổng ưu tiên còn 102 ca; toàn sổ có **1.818 Đạt, 0 Không đạt, 59 Không áp dụng, 449 chưa chạy**.

Tiếp lô L18, dòng 2.879–2.881. Hai phiếu demo đầu trả `STATE_CONFLICT` vì không thỏa điều kiện gắn lô hàng. Chọn phiếu `M3-TRIAL-WR-B2` đủ điều kiện để thực hiện lượt kiểm.

| Mã | Kết quả | Đối chiếu |
|---|---|---|
| J01-F03-T01 | Đạt, chỉnh catalog | Gắn `SHP-UAT-1010-01`, hiện thông báo đã tạo liên kết từ nhập kho tới giao hàng và xóa ba ô. Tra ngược về đúng phiếu và mẻ B2. Câu thông báo hiện hành đã Việt hóa. |
| J01-F03-T02 | Đạt | Gửi thiếu mã lô hàng bị chặn với câu hướng dẫn; tham chiếu chuẩn tra được nguyên trạng. |
| J01-F03-T04 | Đạt | Dùng lần gửi trùng đã làm trong T01 để kiểm chống trùng. Thông báo giữ nguyên liên kết, DB lab xác nhận đúng một tham chiếu và một cạnh nối phiếu. |

J01-F03-T05 đã gắn một tham chiếu trên fixture B5 và quan sát gửi trực tiếp không qua modal. Trình duyệt không xác nhận hoàn tất lần bấm thứ hai. Vai đang dùng không mở được nhật ký, nên ca vẫn mở. Sau lượt này L18 còn 15 ca, tổng ưu tiên còn 99; toàn sổ **1.821 Đạt, 0 Không đạt, 59 Không áp dụng, 446 chưa chạy**.

### Lô L12, nhóm lô nguyên liệu và tồn kho

Vai kiểm toán đối chiếu hai lô demo 10 kg với phiếu `RMR-25112026-000003/000004`. Dòng mới 2.882–2.885. Cùng phiên kiểm toán này đã thấy sự kiện gắn chuyến giao hàng và sự kiện tạo cạnh của J01-F03-T05, đúng người thực hiện trên lab. T05 vẫn thiếu bằng chứng hoàn tất lần bấm thứ hai.

| Mã | Kết quả | Đối chiếu |
|---|---|---|
| D02-F13-T01 | Đạt, chỉnh catalog | Lọc nguyên liệu và trạng thái lô/KCS. Lô chờ KCS có tồn khả dụng 0, chưa thể cấp và hai lý do tiếng Việt. Lô KCS đạt khả dụng 10 kg. Hai phiếu gốc cùng nhận 10 kg. |
| D02-F14-T01 | Đạt, chỉnh catalog | Ngăn chi tiết đúng mã, đủ phần KCS và sẵn sàng. Số khớp tồn theo lô. Lô đã KCS đạt vẫn mang trạng thái lô Đang KCS, nên chưa đủ điều kiện cấp sản xuất. |
| D04-F02-T01 | Đạt | Lọc tồn theo nguyên liệu, kho, KCS và trạng thái lô. Mở chi tiết đơn vị kg, kho/vị trí và lô. Cặp chờ/đạt lần lượt có khả dụng 0/10 kg và tạm giữ 10/0 kg. |
| D04-F05-T01 | Đạt | Tổng và vị trí nhận cùng hiện tạm giữ 10 kg, khớp lô chờ KCS. Tab bút toán có ghi tăng 10 kg cho hai lô demo. Vai kiểm toán không có ô sửa trực tiếp tồn. |

Sau nhóm trên L12 còn 19 ca, L18 còn 15 ca. Tổng đã chốt 11 trong 106 ca của lượt, còn 95; sổ có **1.825 Đạt, 0 Không đạt, 59 Không áp dụng, 442 chưa chạy**.

### Mốc 10:04, rà tiếp L12

Dòng sổ 2.886–2.888. L12 có 23 ca, lũy kế **6 Đạt, 0 Không đạt, 0 Không áp dụng, 1 Bị chặn, 16 chưa chạy**. Tiếp nhóm kho/cổng nhà cung cấp và PWA của L12.

| Mã | Kết quả | Đối chiếu |
|---|---|---|
| D02-F14-T02 | Đạt | Cùng lô demo trên màn rộng và viewport tablet 768 px, nền sáng/tối. Mã, 10 kg, ngày nhận, trạng thái Chờ KCS, cảnh báo và nút Đóng đọc được, ngăn chi tiết không tràn ngang. |
| D04-F03-T01 | Đạt | Lọc `ING_MI_CHINH` và Chưa cần mua: cần 1,9 kg, khả dụng 26,606 kg, cần mua 0. Ngữ cảnh kết quả MRP có cùng mã, lượng và mức. |
| D04-F04-T01 | Bị chặn | Vai kiểm toán chỉ có Tất cả vị trí sau khi chọn kho nhận. Đã đối chiếu bút toán 10 kg, vị trí, vai ghi, liên kết Tồn kho và Truy xuất cùng lô. Còn thiếu lọc theo vị trí và so trước/sau ký KCS trên cùng lô. |

Toàn sổ **1.827 Đạt, 0 Không đạt, 59 Không áp dụng, 1 Bị chặn, 439 chưa chạy** trên 2.326 bước. Lượt ưu tiên đã thêm 13 Đạt, còn 92 chưa chạy và 1 bị chặn trong 106 ca.

### Mốc 10:09, chuẩn bị trong lúc IVR chạy test

Hai sub-agent chỉ đọc catalog và mã nguồn, không mở trình duyệt hay chạy kiểm thử. Lab có hai phiếu demo chờ nhận phù hợp xem bước đầu ở L12 và một phiếu nhập thành phẩm demo chờ xác nhận cho L17. Kiểm lại đúng số lượng và điều kiện ký trên giao diện trước khi dùng. Hai phiếu xuất `APPROVED` sẵn có không có dòng 10 kg đúng catalog L14. Một phiếu có dòng 2,5 kg với lô sẵn sàng, dùng được cho ca chỉ xem nếu đúng vai và công việc hiện trên PWA. Để dựng ca ghi L14, dừng chuỗi tạo dữ liệu sau khi ký FRM-12 và FRM-13, ngay lúc phiếu xuất ở `APPROVED`, trước bước thực hiện xuất.

L15 cần lệnh L1/L2 `IN_PROGRESS` và FRM-18/19 chưa ký. Lệnh hàng đợi in và lệnh đã in dùng fixture riêng cho báo lỗi/in lại. L16 cần mẻ `QC_PENDING`, FRM-29 còn mở sau khi sấy hoàn tất cho kiểm sau sấy, hoặc QC sau sấy đạt và FRM-30 đã xác nhận cho kiểm thành phẩm. L17 dùng phiếu có tăng kho và phiếu chờ để đối chiếu. Các ca PWA này dùng được nhập mã tay và tệp ảnh thử, vẫn cần ghép phiên thiết bị và thử ngoại tuyến đúng bước. Dùng vai chính để kiểm chặn nghiệp vụ, dùng vai kiểm toán để kiểm từ chối quyền.

Rà tĩnh D04-F04-T01 tìm thấy ứng viên lỗi sản phẩm. Thành phần chọn vị trí lọc `warehouseLocationId`, trong khi hợp đồng và mapper trả `locationId`. Log lab có phản hồi 200 cho API danh mục vị trí. Chờ đến lượt kiểm duy nhất để xác nhận số dòng và tên trường ở phản hồi trước khi đổi trạng thái trong sổ.

### Mốc 10:10, xác nhận lỗi bộ lọc ở L12

Dòng sổ 2.889 thay kết luận D04-F04-T01 thành **Không đạt**. Sau khi các tiến trình test IVR kết thúc, đọc API danh mục vị trí bằng đúng vai R-AUDITOR. HTTP 200, hai dòng, có đúng vị trí nhận của lô và chỉ trả `locationId`. `WarehouseLocationFilter` lọc theo `warehouseLocationId`, giải thích vì sao Chrome chỉ hiện Tất cả vị trí. Bằng chứng bút toán và hai liên kết đã lưu ở lượt trước. Cần sửa bộ lọc rồi kiểm tiếp chọn vị trí, lọc tổ hợp và đối chiếu tồn trước/sau ký KCS trên một lô.

L12: **6 Đạt, 1 Không đạt, 0 Không áp dụng, 0 Bị chặn, 16 chưa chạy** trên 23 ca. Toàn sổ **1.827 Đạt, 1 Không đạt, 59 Không áp dụng, 0 Bị chặn, 439 chưa chạy**. Tiếp nhóm kho/cổng nhà cung cấp và PWA của L12.

### Mốc 10:13, kiểm cổng nhà cung cấp L12

Dòng sổ 2.890–2.891. D05-F01-T02 **Đạt**. Bỏ trống hiện cảnh báo, giữ ở trang đăng nhập. Với tài khoản thử hợp lệ, danh sách có phiếu của mình và không có phiếu đã đối chiếu của nhà cung cấp thử thứ hai. D05-F02-T03 **Đạt**. Sau đăng xuất, trang đặt lại quay về đăng nhập và không hiện hộp đổi. Đăng nhập lại thành công. Nhật ký Quản trị theo loại sự kiện chỉ có bản cũ ngày 30/10, không có sự kiện đổi thành công ngày 26/11.

L12 **8 Đạt, 1 Không đạt, 0 Không áp dụng, 0 Bị chặn, 14 chưa chạy** trên 23 ca. Toàn sổ **1.829 Đạt, 1 Không đạt, 59 Không áp dụng, 0 Bị chặn, 437 chưa chạy**. Trong lượt ưu tiên, 15 Đạt, 1 Không đạt, 90 chưa chạy trên 106 ca. Tạm ngừng thao tác UAT khi IVR mở runner khác, giữ lab và tiếp theo nhóm tồn kho/PWA L12 khi máy rảnh.

### Mốc 10:25, chuẩn bị kiểm lại D04-F04-T01

Toàn đã giao sửa và kiểm lại đúng ca. Giữ nguyên lô demo `RLOT-25112026-000031` thuộc phiếu `RMR-25112026-000004`: hiện Chờ KCS, chưa có kết quả ký. Dùng vai kiểm toán lọc và mở tồn trước, vai KCS ký đạt 10 kg, rồi vai kiểm toán mở lại tồn của cùng lô và đối chiếu bút toán. Luồng PWA dùng địa chỉ loopback riêng để tránh ghi đè cookie của Quản trị, API/PWA sẽ khởi động khi test IVR dừng.

Khi kiểm lại cần xác nhận riêng bước tìm theo số phiếu. Repository hiện chỉ tra mã lô, người ghi và mã đối soát trong ô Tìm kiếm. Bút toán demo có nguồn là lô nguyên liệu, và cả ba trường hiện tại đều không chứa số phiếu của catalog. Đây là phát hiện rà tĩnh và đối chiếu DB lab, sẽ xác nhận kết quả trên Chrome.

### Mốc 10:33, kiểm hồi quy component vị trí

Trên nền `d4163331c` có bản sửa cục bộ `ledger-shared.tsx`, chạy riêng ca mới `filters the raw ledger using locationId from the warehouse API`: **1/1 đạt, 27 ca khác bỏ qua**. Ca xác nhận chọn vị trí từ phản hồi có `locationId` và hook sổ kho nhận cả mã kho lẫn mã vị trí. `git diff --check` qua trên hai tệp của bản sửa. Chưa thêm kết quả UAT từ kiểm component.

IVR đã mở runner mới trước khi chạy Chrome. API lab cần khởi động lại với chế độ giữ nguyên DB đã phục hồi để dùng lại lô nguyên liệu. Chuẩn bị cấu hình tái sử dụng trong thư mục tạm. Tiếp theo kiểm ca D04-F04-T01 trên Chrome sau khi không còn runner khác. Dòng sổ cuối vẫn là 2.891.

Mốc 10:38: đã đưa API lab trở lại trên cùng DB, xác nhận đăng nhập demo HTTP 200; chưa bắt đầu bước lọc. IVR tiếp tục các lượt test nối nhau. Phiên UAT giữ khóa, chỉ tiếp tục thao tác Chrome khi không thấy `dotnet test` hoặc `testhost` của phiên khác.

### Mốc 10:44, kiểm lại D04-F04-T01 trên Chrome

Dòng sổ 2.892, **Không đạt** do lỗi tìm theo số phiếu. Vai R-AUDITOR đã chọn được đúng vị trí Khu nhận – tập kết nguyên liệu. API nhận `locationId` đúng và HTTP 200. Giữ đủ lọc kho/vị trí/lô/chứng từ/hướng/khoảng ngày 25/11, nhập số phiếu `RMR-25112026-000004` thì không có dòng. Xóa riêng ô Tìm kiếm, giữ sáu lọc còn lại, thấy dòng nhập 10 kg đúng ngày, vị trí và người ghi của lab. Repository tìm ô này theo `lot_code`, `posted_by` và `correlation_id`. Nguồn của dòng là lô nguyên liệu, nối phiếu qua dòng phiếu nhập. Cần bổ sung tra số phiếu đúng nguồn, giữ bộ lọc vị trí đã sửa.

Liên kết Tồn kho mở đúng lô `RLOT-25112026-000031` với khả dụng 0 kg, tạm giữ 10 kg. Tái dùng bằng chứng liên kết Truy xuất ở cùng dòng, cùng lô của lượt trước. Đã mở hộp Ký KCS qua vai nghiệp vụ, thấy nhận và đạt cùng 10 kg. IVR mở test mới trước khi gửi nên chưa ký và chưa có số sau. Không tính Đạt cho ca. L12 **8 Đạt, 1 Không đạt, 0 Không áp dụng, 0 Bị chặn, 14 chưa chạy**. Tiếp đóng đối chiếu trước/sau KCS của ca này rồi các ca tồn kho/PWA L12.

### Mốc 10:47, hoàn tất đối chiếu KCS của D04-F04-T01

Toàn cho phép IVR và UAT M1–M2 chạy đồng thời. M1–M2 vẫn chỉ một phiên kiểm giữ `@bo-kiem-du`. Dòng sổ 2.893 nối kết quả bổ sung của ca D04-F04-T01. Vai KCS ký đạt 10 kg, giao diện xác nhận đã ký. Vai kiểm toán mở lại tồn ở cùng lô, cùng vị trí, từ khả dụng/tạm giữ **0/10 kg** thành **10/0 kg**. Giữ **Không đạt** do tìm theo số phiếu. Số ca L12 không đổi. Tiếp L12 trên PWA với dữ liệu thử.

### Mốc 10:56, hai ca chặn nhận nguyên liệu L12

Dòng sổ 2.894–2.895. **D06-F01-T04 Đạt**: vai kho trên Chrome, máy demo đã ghép, nhập `UAT-KHO-KHAC` báo không thuộc kho nhận, vị trí và trạng thái phiếu nguồn giữ nguyên. **D06-F01-T02 Đạt**: nhận diện đúng mã, điền hai lượng 10 kg, chọn vị trí, nguồn và một ảnh thử, bỏ tick. Giao diện chỉ báo cần đánh dấu xác nhận, nút chính khóa, Quản trị vẫn thấy phiếu Chờ giao hàng và dòng chờ xử lý. Catalog dùng nhãn cũ của nút và lời nhắc. Dùng Chromium tích hợp cho ca có tệp, tránh thay đổi quyền của tiện ích Chrome. Hai trình duyệt thao tác tuần tự trong một phiên UAT.

L12 **10 Đạt, 1 Không đạt, 0 Không áp dụng, 0 Bị chặn, 12 chưa chạy** trên 23 ca. Toàn sổ **1.831 Đạt, 1 Không đạt, 59 Không áp dụng, 0 Bị chặn, 435 chưa chạy**. Lượt ưu tiên 17 Đạt, 1 Không đạt, 88 chưa chạy. Tiếp vai bị chặn và luồng lưu/đồng bộ của L12.

### Mốc 11:04, đối chiếu phân quyền và đồng bộ nhận nguyên liệu L12

Dòng sổ 2.896–2.898. **D06-F01-T03 Đạt**. Vào PWA bằng vai kiểm toán, mở đường dẫn Quét lô nguyên liệu và bị đưa về đăng nhập, không hiện thao tác tiếp nhận. Nguồn vẫn chờ giao, 0 lô. Màn chặn trước bước chọn thao tác, catalog cần cập nhật.

**D06-F01-T01 Không đạt**. Ngắt riêng kết nối API PWA qua proxy loopback, nguồn Quản trị vẫn đọc được, hàng đợi hiện Chờ gửi và 0 lần. Nối lại và gửi, ghi đúng 10 kg, hạn 10/12, vị trí và lô mới `RLOT-26112026-000001` Chờ KCS, khả dụng 0 kg và tạm giữ 10 kg. Ô Mã lô nhà cung cấp đã nhập khác giá trị trước, nhưng phiếu vẫn giữ mã đã khai. Lô `PURCHASED` không lưu vùng nguồn nhập trong PWA; mã hiện hành chỉ lưu vùng/xuất xứ với `SELF_GROWN`. Cần chốt có cho sửa mã lô NCC khi nhận hàng và dùng ca tự trồng để kiểm vùng nguồn. Chưa sửa quy tắc nghiệp vụ.

**D06-F01-T05 Đạt**. Tải lại hàng đợi, nút gửi tắt vì hết lệnh chờ. Cùng mã lệnh cũ có một lần áp dụng, một thẻ đã gửi, đúng một lô và tổng 10 kg. Số lượng, hạn dùng và trạng thái đọc lại trên Quản trị. Chênh lệch mã NCC/vùng đã ghi ở T01.

L12 **12 Đạt, 2 Không đạt, 0 Không áp dụng, 0 Bị chặn, 9 chưa chạy** trên 23 ca. Toàn sổ **1.833 Đạt, 2 Không đạt, 59 Không áp dụng, 0 Bị chặn, 432 chưa chạy**. Lượt ưu tiên 19 Đạt, 2 Không đạt, 85 chưa chạy. Tiếp nhóm ký KCS PWA và tồn kho L12. Phiên chính đang sửa thêm tìm số phiếu D04-F04-T01. API lab đang dùng bản cũ cho tới khi nhận bản sửa.

### Mốc 11:15, chuẩn bị kiểm hồi quy tìm số phiếu

Phiên chính đã sửa tìm số phiếu đầy đủ theo quan hệ phiếu nhập → dòng phiếu → lô → bút toán RAW_RECEIPT. Chạy một ca mới `Ledger_search_finds_raw_material_receipt_number_with_location_filter` với `REQUIRE_DATABASE_BACKED_TESTS=1`. Lần đầu ca dừng tại kiểm hợp đồng vì seed cũ dùng loại đối tượng ngoài enum. Bộ chạy mặc định đã mở cổng tạm không giới hạn loopback; các container tạm của lần đó đã tự dọn. Những lần sau dùng PostgreSQL và Redis mới, cổng chỉ gắn 127.0.0.1. Một lần bị hàng rào fixture từ chối vì tên DB thử thiếu `test` và `local`, không xóa dữ liệu. Nay dùng tên DB thử hợp lệ, seed ghi đúng `RAW_MATERIAL_LOT` và mã lô ngay khi tạo bút toán, giữ seed mặc định cho ca khác và giữ trigger sổ append-only. `git diff --check` sạch trước lượt chạy. Chưa ghi thêm kết quả UAT, tiếp nạp API mới và kiểm Chrome khi tiến trình này kết thúc.

### Mốc 11:21, kiểm lại D04-F04-T01 đạt

Ca tích hợp lọc phiếu **1/1 Đạt, 0 bỏ qua** với PostgreSQL và Redis dùng một lần, chỉ bind loopback. Container test đã tự dọn. Nạp API từ đúng thư mục build ca tích hợp, giữ nguyên DB lab và bản sửa dropdown. Bản sửa backend tại checkout có blob `c3114589`. Trên Chrome, vai R-AUDITOR giữ số phiếu `RMR-25112026-000004`, kho nguyên liệu chính, vị trí nhận, lô `RLOT-25112026-000031`, chứng từ Nhập nguyên liệu, hướng Ghi tăng, hai ngày 25/11. Một bút toán hiện đúng 09:20, 10 kg, đúng vai kho thực hiện. Log API xác nhận HTTP 200 với các lọc cùng lúc. Mở liên kết chứng từ thấy số phiếu ở danh sách nguồn. Catalog nên ghi rõ số phiếu thấy ở màn nguồn, nhãn trên sổ là Nhập nguyên liệu.

Dòng sổ 2.899 chốt **D04-F04-T01 Đạt**. Giữ bằng chứng Tồn kho, Truy xuất và lượng khả dụng/tạm giữ 0/10 thành 10/0 kg cùng lô ở dòng 2.892–2.893. Đã đối chiếu lại cùng mã bút toán, số phiếu và vị trí trong DB sau khi đổi build. Không ký KCS lần hai. L12 **13 Đạt, 1 Không đạt, 0 Không áp dụng, 0 Bị chặn, 9 chưa chạy** trên 23 ca. Toàn sổ **1.834 Đạt, 1 Không đạt, 59 Không áp dụng, 0 Bị chặn, 432 chưa chạy**. Tiếp L12 nhóm tồn kho và ký KCS PWA.

### Mốc 11:28, ký KCS lô nguyên liệu trên PWA

Dòng sổ 2.900–2.902. **D06-F02-T02 Đạt**. Đúng lô, kết quả, ghi chú và một ảnh. Bỏ tick thì nút khóa, Quản trị thấy lô còn Chờ KCS. **D06-F02-T01 Đạt**. Lưu lệnh khi ngắt riêng đường API PWA, hàng đợi Chờ gửi 0 lần, nguồn chưa ký và tồn khả dụng/tạm giữ 0/10 kg. Kết nối lại, một lệnh Đã gửi, một ảnh gắn với lệnh. Quản trị thấy người và giờ ký, KCS đạt, lô Đang KCS, 10 kg khả dụng và chưa thể cấp. **D06-F02-T05 Đạt**. Tải lại hàng đợi và đối chiếu cùng mã lệnh, đúng một lần áp dụng, một chữ ký và một ảnh. Catalog chỉ nêu lô IN_QC và nhãn nút cũ, chức năng hiện hành cũng nhận lô CREATED đang chờ KCS.

L12 **16 Đạt, 1 Không đạt, 0 Không áp dụng, 0 Bị chặn, 6 chưa chạy**. Toàn sổ **1.837 Đạt, 1 Không đạt, 59 Không áp dụng, 0 Bị chặn, 429 chưa chạy**. Còn hai ca chặn ký KCS và bốn ca tồn kho L12.

### Mốc 11:36, đã rà đủ L12

Dòng sổ 2.903–2.908. **D06-F02-T04 Đạt**. Lô demo thứ hai chọn Giữ lại, đã nhận diện, có ảnh và tick nhưng để trống lý do. Nút khóa, chỉ báo còn thiếu lý do, lô vẫn Chờ KCS và 0 bản ký. **D06-F02-T03 Đạt**. Vai kiểm toán bị đưa về đăng nhập khi mở màn ký PWA, không có thao tác ký, lô nguồn không đổi.

**D04-F01-T01/T02/T04 Đạt**. Lô Bạch linh chưa có vị trí, khả dụng 9,45 kg, tạm giữ 0. Chọn vị trí và nhập ghi chú rồi hủy, lô và số lượng giữ nguyên. Mở lại, bấm kép xác nhận. Sổ chỉ có một bút toán giảm và một bút toán tăng, mỗi dòng 9,45 kg, cùng mã đối soát, tổng tồn nguyên liệu giữ 25,88 kg. Dòng đã gán không còn nút gán. Vai kiểm toán thấy đúng một nhật ký Gán vị trí kho, đúng người và thời điểm. Catalog dùng số mẫu 10 kg, lượt này dùng số của lô demo có sẵn.

**D04-F05-T02 Đạt**. Cùng hồ sơ Gạo trên màn rộng, tablet 768 px, nền sáng và nền tối giữ nguyên mã, số, ngày, nhãn và nút. Bàn phím cuộn bảng riêng từ 0 đến 916 px để tới cột cuối, trang không tràn. Mở bút toán đối chiếu 10 kg cùng lô. Đã trả cấu hình viewport và theme về mặc định.

L12 đã rà đủ **23 ca: 22 Đạt, 1 Không đạt (D06-F01-T01), 0 Không áp dụng, 0 Bị chặn, 0 chưa chạy**. Toàn sổ **1.843 Đạt, 1 Không đạt, 59 Không áp dụng, 0 Bị chặn, 423 chưa chạy**. Lượt ưu tiên 29 Đạt, 1 Không đạt, 76 chưa chạy trên 106 ca. Lô tiếp theo **L14**, công việc PWA và chuỗi xuất kho nguyên liệu → nhận ở xưởng.

### Mốc 11:51, nhánh xưởng nhận nguyên liệu L14

Dòng sổ 2.909–2.913. **E07-F04-T04 Không đạt**. Phiếu đã xuất 7,5 kg, nhập nhận 7 kg, để trống cả mã và nội dung lý do. PWA vẫn bật Lưu và gửi; máy chủ từ chối `VARIANCE_REASON_REQUIRED`, phiếu chờ xác nhận không có dòng mới. Sau tải lại, thẻ ở Hàng đợi còn Đang gửi dù máy chủ đã từ chối. Dùng cùng sai lệch 0,5 kg như catalog trên fixture có sẵn.

**E07-F04-T02 Đạt**. Phiếu demo khác đã xuất 2,5 kg, nhận diện đúng, nhập đủ và bỏ tick. Nút khóa, Quản trị vẫn Chờ xác nhận. **E07-F04-T01/T05 Đạt**. Lưu lệnh khi ngắt API xưởng, phiếu vẫn chờ và chưa có dòng. Nối lại, Quản trị xác nhận đúng một phiếu nhận 2,5 kg, chênh lệch 0, tồn nguồn giữ 0,429 kg. Hàng đợi có ba lần thử do ngắt mạng, máy chủ áp dụng đúng một lần cùng mã lệnh. Tải lại Hàng đợi không tạo phiếu thứ hai.

**E07-F02-T01 Đạt**. Công việc của phiếu 7,5 kg khớp Quản trị và giữ được bản lưu cùng mã, lượng khi ngắt API xưởng. Tải lại khi có mạng không ghi nghiệp vụ. Dùng phiếu 2,5 kg ở ca nhận đủ để kiểm thêm rằng sau xác nhận, tải lại thì công việc không còn thao tác nhận.

L14 **4 Đạt, 1 Không đạt, 0 Không áp dụng, 0 Bị chặn, 9 chưa chạy** trên 14 ca. Toàn sổ **1.847 Đạt, 2 Không đạt, 59 Không áp dụng, 0 Bị chặn, 418 chưa chạy**. Phiếu xuất phù hợp chưa có sẵn. Hai phiếu APPROVED cũ thiếu tồn khả dụng. MRP demo neo 10 kg có số lượng phù hợp nhưng còn chặn chứng từ trước (`FORM_PREVIOUS_REQUIRED`) nên chưa tạo được lệnh sản xuất. Tiếp phần phân quyền, thiết bị và danh sách công việc L14.

### Mốc 12:01, đã rà L14, còn bị chặn

Dòng sổ 2.914–2.922. **E07-F01-T01 Không đạt**. Lọc loại việc Xuất nguyên liệu, tải lại và mở đúng phiếu. Bản lưu giữ đúng mã và lượng 2,5 kg khi mất API. Giao diện chỉ có chip loại việc, không có bộ lọc trạng thái để làm bước lọc kép trong catalog. **E07-F01-T02/T03 Đạt**. Máy đóng gói vừa ghép, chưa tải việc, mở lúc mất API báo chưa có bản lưu. Nối lại lập được danh sách thật. Ở 360/768 px, cùng thẻ Kiểm tem QR mở được, mã/trạng thái hiện đúng. Thu chiều cao để mô phỏng vùng nhập, bàn phím đưa nút xác nhận vào khung nhìn và trang không tràn ngang.

**E07-F03-T03 và E07-F04-T03 Đạt**. Vai R-AUDITOR bị đưa về đăng nhập khi mở việc xuất/nhận, phiếu nguồn không đổi. **E07-F02-T02 Đạt**. Dùng R-PACK-OP có quyền xem việc nhưng thiếu quyền thực hiện xuất. Mở được đúng ngữ cảnh phiếu và nhận thông báo không có thao tác phù hợp, không thấy nút gửi. R-AUDITOR trong cấu hình hiện hành bị chặn cả trang, catalog nên đổi vai cho ca chỉ xem.

**E07-F03-T01/T02/T04 Bị chặn**. Không có phiếu APPROVED đủ tồn tại đúng lô/vị trí. Phiếu còn phù hợp ngữ cảnh chỉ có khả dụng 0,429 kg so với lượng duyệt 2,5 kg. MRP neo 10 kg đang thiếu chứng từ trước khi tạo lệnh, nên chưa có mẫu để kiểm xuất chính, bỏ tick trên hồ sơ hợp lệ và chống lặp cùng mã. Tiếp L15 trong khi rà cách dựng fixture đúng quy trình.

L14 **9 Đạt, 2 Không đạt, 0 Không áp dụng, 3 Bị chặn, 0 chưa chạy** trên 14 ca. Toàn sổ **1.852 Đạt, 3 Không đạt, 59 Không áp dụng, 3 Bị chặn, 409 chưa chạy**. Lượt ưu tiên đã thêm 38 Đạt, 3 Không đạt, 3 Bị chặn, 62 chưa chạy trên 106 ca. Lô tiếp theo **L15** (đóng gói và tem QR).

### Mốc 12:10, loại các ca in tem đã hoãn ở L15

Dòng sổ 2.923–2.931. Chín ca F05-F04/F05 Không áp dụng theo D-m12-103 và D-m12-140. L15 còn 15 ca cần rà ở ba nhóm đóng gói và kiểm QR. QR demo đã in và khớp lô được máy chủ nhận diện, nhưng quy tắc thu hồi đang áp dụng với lô đó, nên chưa đủ điều kiện để kiểm đường xác minh thành công. Đang tìm lô demo riêng đủ điều kiện.

Toàn sổ **1.852 Đạt, 3 Không đạt, 68 Không áp dụng, 3 Bị chặn, 400 chưa chạy** trên 2.326 ca.

### Mốc 12:18, kiểm tem QR trên mẻ demo sạch

Dòng sổ 2.932–2.935. **F05-F03-T01/T02/T04/T05 Đạt**. Chuẩn bị mẻ A2 demo riêng, tạo tem qua luồng đóng gói, ghi đã in mô phỏng và giữ truy xuất công khai tắt. Quét đúng tem rồi điền thêm ô Mã đã quét. Thiếu tick bị khóa. Quét tem của mẻ khác dù đã tick vẫn bị khóa. Sau khi ngắt API xưởng, Hàng đợi giữ lệnh, máy chủ có 0 sự kiện. Nối lại thì chỉ áp dụng một lần cùng mã lệnh, tải lại vẫn chỉ một thẻ Đã gửi. Lô vẫn Chờ QC, đóng gói vẫn hoàn tất và tem vẫn Đã in. Ca phân quyền kiểm tem và 10 ca xác nhận cấp 1/cấp 2 còn lại.

L15 có **4 Đạt, 9 Không áp dụng, 11 chưa chạy**. Toàn sổ **1.856 Đạt, 3 Không đạt, 68 Không áp dụng, 3 Bị chặn, 396 chưa chạy**.

### Mốc 12:26, đã rà đủ L15

Dòng sổ 2.936–2.946. **F05-F01 và F05-F02 đều 5/5 Đạt**. Cấp 1 ghi 24 gói, cấp 2 dùng 24 gói được 6 hộp. Có mã đúng và ảnh, thiếu tick thì khóa. Đã tick nhưng 100 đạt + 1 lỗi vượt 100 đầu vào thì khóa. Cả hai lệnh giữ tại máy và chưa đổi nguồn khi mất API. Nối lại, app tải ảnh và báo còn chờ phiếu. Trong lab, vai QA duyệt bằng chứng demo, Trưởng ngày và QC ký FRM-18 và FRM-19. Cấp 2 dùng in mô phỏng nội bộ và ghi nhận tiêu hao bao bì demo. Gửi lại hai mã cũ thì đúng một lần áp dụng mỗi lệnh, ảnh gắn đúng lệnh. Tải lại hàng đợi vẫn đúng một thẻ của mỗi lệnh. Vai kiểm toán bị đưa về đăng nhập khi mở ba đường dẫn thực của cấp 1, cấp 2, kiểm QR. Nguồn không đổi.

L15 **15 Đạt, 9 Không áp dụng, 0 Không đạt, 0 Bị chặn, 0 chưa chạy** trên 24 ca. Toàn sổ **1.867 Đạt, 3 Không đạt, 68 Không áp dụng, 3 Bị chặn, 385 chưa chạy**. Chuyển **L16**, đã xác định mẫu riêng cho KCS sau sấy và KCS thành phẩm.

### Mốc 12:37, đã rà L16, còn một ca cần mẻ riêng

Dòng sổ 2.947–2.956. **G03-F01 có 4 Đạt, 1 Bị chặn**. KCS sau sấy ghi 3 mẫu, ẩm 1,5%, bốn tiêu chí đạt. Thiếu tick bị khóa. Ngắt API, ảnh và lệnh lưu trên máy. Duyệt đúng gói ảnh của lệnh PWA, bấm Thử lại trên thẻ cũ và đối chiếu chỉ một lần áp dụng. FRM-29 ghi kết quả, lô vẫn Chờ KCS. Mẻ thử HOLD có cảnh báo thiếu lý do khi chọn Giữ lại, nhưng mã mẻ đồng thời bị chặn bởi thu hồi. Cần một mẻ chưa ký và ngoài thu hồi để kiểm riêng lý do. Giữ nguyên quy tắc thu hồi.

**G03-F02 5/5 Đạt**. KCS 24/24 gói, tỷ lệ 100%, thiếu tick khóa. Ngắt API giữ lệnh và ảnh ở máy. Nối lại có một kết quả, lô Đã kiểm và FRM-20 chờ ký. Duyệt bằng chứng, ký hai vai trong lab, thử lại cùng mã. Hàng đợi chỉ có một thẻ Đã gửi, một kết quả áp dụng, chưa phát hành và chưa tăng tồn. Vai kho đã ghép máy không có phiếu của mẻ. Quản trị tìm đúng mã trong danh sách mẻ đủ điều kiện nhập kho và báo không có mẻ phù hợp. Vai kiểm toán bị chặn ở hai đường dẫn ký KCS.

L16 **9 Đạt, 1 Bị chặn, 0 chưa chạy** trên 10 ca. Toàn sổ **1.876 Đạt, 3 Không đạt, 68 Không áp dụng, 4 Bị chặn, 375 chưa chạy**. Chuyển **L17**, vai kho thành phẩm đang có phiên máy lab.

### Mốc 12:45, lưu điểm dừng L17 để kiểm hồi quy nhập nguyên liệu

Dòng sổ 2.957. **H01-F07-T01 Đạt**. Vai kho lọc phiếu đã xác nhận, đúng kho, mẻ và khoảng ngày. Phiếu mẫu 12 hộp, có một dòng ghi tăng 12 hộp và tham chiếu tồn. Phiếu khác đang chờ chưa có dòng ghi tăng. Đã mở màn tồn SKU A2, lọc cấp Hộp và thu hồi, còn cần kiểm vị trí và chứng từ trước khi ghi kết quả. Giữ lab để kiểm lại D06-F01-T01 sau bản sửa, rồi tiếp từ ca còn mở.

L17 có **1 Đạt, 12 chưa chạy**. Toàn sổ có **1.877 Đạt, 3 Không đạt, 68 Không áp dụng, 4 Bị chặn, 374 chưa chạy**.

### Mốc 12:57, kiểm lại D06-F01-T01 đạt cả mua và tự trồng

Dòng sổ 2.958 giữ nguyên dòng Không đạt cũ trong lịch sử. Hai nhóm kiểm lọc chạy tuần tự, backend **13/13** và PWA **12/12**. Đối chiếu 10 tệp sửa giữa lúc build và sau lượt UI. Giữ cùng DB demo, chỉ nạp API và app xưởng mới.

Phiếu mua demo được vai nhà cung cấp tải ảnh và xác nhận trong cổng lab. Nhập 10 kg, mã lô NCC cũ đổi sang mã đã gõ khi nhận, tải lại cổng vẫn thấy mã mới và trạng thái Đã nhận, chờ KCS. Hệ thống sinh mã lô nội bộ riêng. Phiếu tự trồng mới cũng nhận 10 kg, lưu đúng cặp xuất xứ đã xác minh và vùng nguồn. Mỗi phiếu khi mất API có lệnh Chờ gửi, 0 lần gửi và chưa có lô. Nối lại, ảnh gắn đúng lệnh, đúng một lần áp dụng mỗi phiếu. Hai lô chờ KCS, tạm giữ 10 kg, khả dụng 0 kg, tại cùng vị trí giữ.

Phát hiện riêng ở phiếu demo có nhân viên xác nhận hộ. Chi tiết PWA khóa với lý do thiếu trạng thái xác nhận, dù phiếu có đủ ảnh và xử lý nhận ở máy chủ chấp nhận `CONFIRMED_BY_STAFF`. Nguồn phiếu này giữ nguyên. Ghi lệch để xử lý riêng, theo phạm vi kiểm lại chỉ kết luận nhánh nhà cung cấp tự xác nhận của catalog.

L12 hiện **23 Đạt**. Toàn sổ **1.878 Đạt, 2 Không đạt, 68 Không áp dụng, 4 Bị chặn, 374 chưa chạy**. Trở lại lô L17 từ nhóm tồn theo SKU.

### Mốc 13:07, gỡ đủ ba ca xuất kho đã bị chặn ở L14

Dòng sổ 2.959–2.961 ở L17. **H02-F02-T01 Đạt**. Từ tồn A2 mở đúng mẻ và phiếu nguồn, lượng vật lý 6 hộp, có thể bán 0 khi thu hồi. **H02-F01-T01 Không đạt**. Chọn đúng kho nhưng Vị trí chỉ có Tất cả, trong khi mẻ có vị trí hoạt động. Màn tồn đọc `warehouseLocationId`, còn DTO trả `locationId`. **H02-F03-T01 Không đạt**. Tìm theo số phiếu ở sổ kho thành phẩm trả rỗng. Bỏ riêng số phiếu thì hiện đúng chứng từ, một dòng tăng 12 hộp. L17 tạm **2 Đạt, 2 Không đạt, 9 chưa chạy**.

Dòng sổ 2.962–2.964. **E07-F03-T01/T02/T04 Đạt**. Tạo đề nghị demo trên mẻ chưa chạy, giữ BOM, ký FRM-12/13, duyệt riêng 10 kg gạo từ lô đứng đầu FEFO, các dòng còn lại giữ chờ. Phiếu APPROVED đủ tồn. Bỏ tick bị khóa. Quét mã lô, ngắt API xưởng, Hàng đợi Chờ gửi 0 lần, nguồn vẫn APPROVED và khả dụng 72,602 kg. Nối lại phiếu EXECUTED, tồn còn 62,602 kg, một dòng giảm 10 kg. Tải lại hàng đợi vẫn một mục Đã gửi và một lần áp dụng. Không bù tồn cho phiếu cũ.

L14 **12 Đạt, 2 Không đạt, 0 Bị chặn và 0 chưa chạy** trên 14 ca. Hai lỗi đã ghi ở lượt trước giữ nguyên. Toàn sổ **1.882 Đạt, 4 Không đạt, 68 Không áp dụng, 1 Bị chặn, 371 chưa chạy**. Dừng an toàn để kiểm riêng nhánh xác nhận hộ của D06 theo yêu cầu của Toàn.

### Mốc 13:17, kiểm bổ sung phiếu nhân viên xác nhận hộ

Dòng sổ 2.965 bổ sung bằng chứng cho **D06-F01-T01 Đạt**, giữ hai nhánh và lịch sử đã ghi. Ca hồi quy cổng xác nhận hộ **1/1 Đạt**, chỉ nạp lại API trên cùng DB demo. Trên Chrome, tải mới đúng phiếu demo đã xác nhận hộ và có ảnh. Nhận diện khớp, không còn chặn vì trạng thái xác nhận. Tiện ích Chrome chưa cấp quyền chọn tệp, nên dùng Chromium tích hợp cho bước ảnh, lưu và đồng bộ.

Khi ngắt API xưởng, phiếu chưa đổi, mã NCC cũ còn nguyên, chưa có lô và lệnh Chờ gửi 0 lần. Nối lại, ảnh gắn đúng lệnh và máy chủ áp dụng một lần. Trạng thái xác nhận hộ giữ nguyên, phiếu thành Đã nhận, chờ KCS. Mã NCC mới lưu trên dòng phiếu, một lô nội bộ riêng, hạn 10/12, khả dụng 0 kg và tạm giữ 10 kg tại vị trí chờ KCS. Không chạy lại hai nhánh đã đạt trước đó.

L12 giữ **23/23 Đạt**. Toàn sổ **1.882 Đạt, 4 Không đạt, 68 Không áp dụng, 1 Bị chặn, 371 chưa chạy**. Trở lại **L17**, tiếp tục sổ kho chung, tồn theo lô, giữ hàng và nhóm PWA nhập kho thành phẩm.

### Mốc 13:25, đã rà đủ L17

Dòng sổ 2.966–2.974. **H01-F08, H03-F01 và H03-F02 Đạt**. Vai quản lý mở dòng thành phẩm 12 hộp, một bút toán tăng và tham chiếu tồn. Sổ kho chung lọc đúng mẻ, vị trí, ngày, dòng tăng 6 hộp và mở đúng tồn 6 hộp. Mẫu lô giữ hàng tách 30 hộp khả dụng, 20 đã giữ, 0 tạm giữ, mở đúng lịch sử. **H05-F04 Bị chặn phần tự nhả**. Tra đúng phiếu, nguồn/lô/kho, các thời điểm và số dư liên quan. Các mẫu đã nhả đều trước hạn, chưa có mẫu tự nhả sau hạn và tác vụ nền ở lab đang tắt.

**H07-F01-T02/T03/T04 Đạt**. Thiếu tick thì nút khóa, vai kiểm toán không ghi được, phiếu thuộc mẻ đang thu hồi nhận diện được mã nhưng không xác nhận được việc và không tăng tồn. **H07-F01-T01 Không đạt theo luồng PWA trong catalog**. Phiếu demo sạch 6 hộp của mẻ đã phát hành có FRM-22 chờ ký và bằng chứng đã duyệt. PWA vẫn cho lưu/gửi, sau nối API máy chủ từ chối `EVIDENCE_NOT_ACCEPTED`. Đây là lần thử khi giấy chưa đủ chữ ký. Theo hướng dẫn hiện hành, phải ký đủ FRM-22 kết luận Cho nhập kho ở Quản trị mới xác nhận và tăng tồn. Máy chủ giữ đúng cổng này: phiếu vẫn chờ, 0 bút toán, 0 dòng tồn. Giao diện hiện cho gửi sớm và báo lỗi bằng chứng dù bằng chứng đã duyệt. Không ký thay ca chính để không làm sai nguồn của lần thử. **H07-F01-T05 Bị chặn** vì chưa có một lần nhập qua PWA áp dụng để kiểm gửi lại.

L17 **8 Đạt, 3 Không đạt, 2 Bị chặn, 0 chưa chạy** trên 13 ca. Toàn sổ **1.888 Đạt, 5 Không đạt, 68 Không áp dụng, 3 Bị chặn, 362 chưa chạy**. Tiếp tục **L18**, bỏ ca đã Đạt.

### Mốc 13:36, đã rà đủ L18 và sáu lô ưu tiên

Dòng sổ 2.975–2.982 ở cổng công khai. **J03-F01-T01/T03/T05 Đạt**. Mã demo hợp lệ mở đúng sản phẩm, lô và trạng thái xuất xưởng, không cần đăng nhập. Mã đang thu hồi chỉ trả Chưa có thông tin công khai, không thấy dữ liệu nội bộ. Cùng trang 1280/768 px giữ đủ ô, nút và trạng thái, không tràn. **J03-F02-T01/T02/T03, J03-F03-T01 và J03-F04-T01 Bị chặn**. Camera không đọc được tem trong runner, vẫn nhập tay được. Thiếu môi trường quét thật để kiểm mở/dừng và đối chiếu vận hành. Thiếu tệp nguồn gốc được duyệt và mở qua HTTPS. Có hướng dẫn thêm trang qua menu trình duyệt, chưa mở được từ biểu tượng.

Dòng sổ 2.983–2.989 ở Quản trị. Bảy ca còn mở **Đạt**. Tra đủ bảy loại mã, lô bao bì nối đúng mẻ, mã không tồn tại xóa kết quả cũ. Màn 768 px vẫn đọc và cuộn bảng bằng phím ở nền sáng/tối. Phả hệ hai chiều độ sâu 10 hiển thị đủ năm vùng đọc và cảnh báo giới hạn. Đã tìm đúng ba nhánh nguyên liệu, bao bì và phiếu kho trong phân trang. Trên mẻ demo riêng, bấm kép gắn tham chiếu giữ đúng một bản ghi, giao diện gửi trực tiếp và khóa nút khi đang tải. Nhật ký có một sự kiện gắn và một sự kiện tạo cạnh cùng mã đối soát. Vai truy xuất tải CSV và JSONL thật, cả hai mở được 15 bản ghi cùng truy vấn, mã mẻ/phiếu/tham chiếu khớp giao diện.

L18 **19 Đạt, 5 Bị chặn, 0 chưa chạy** trên 24 ca. Sáu lô ưu tiên L12, L14–L18 đã rà đủ ca. Toàn sổ **1.898 Đạt, 5 Không đạt, 68 Không áp dụng, 8 Bị chặn, 347 chưa chạy**. Tiếp lần lượt các lô còn mở L01–L11, L13, L19–L24.

### Mốc 13:45, đã rà đủ L01

Dòng sổ 2.990–3.013. Đăng nhập quản trị demo, chặn hai trang cần đăng nhập, kiểm hồ sơ, lịch sử phiên, hủy xác nhận đăng xuất toàn bộ, ma trận ô ký và lọc quyền đều Đạt. Dùng một lượt cho mỗi cấu hình giao diện, tái dùng kết quả chung cho các ca responsive trùng bước. Thanh bên, tìm nhanh theo quyền, Tab bỏ qua điều hướng, hai thẻ cảnh báo/phê duyệt và hủy bản nháp đạt. Trên Tổng quan, các bộ lọc và liên kết mở đúng màn, mức sẵn sàng vẫn bị chặn khi còn thiếu bằng chứng. Không thực hiện thu hồi, ký hay phê duyệt.

**A03-F01-T01 Không đạt ở bước breadcrumb**. Thanh bên tới đúng màn Người dùng & Vai trò, tiêu đề và phân cấp khớp, nhưng breadcrumb chỉ có văn bản và không có liên kết trở về. L01 **25 Đạt, 1 Không đạt, 0 chưa chạy**. Toàn sổ **1.921 Đạt, 6 Không đạt, 68 Không áp dụng, 8 Bị chặn, 323 chưa chạy**. Chuyển L02.

### Mốc 13:49, đã rà đủ L02

Dòng sổ 3.014–3.018. Bốn ca cảnh báo **Đạt**. Lọc mức, trạng thái, kho và ngày, đối chiếu tổng và đổi số dòng. Ở 768 px, sáng/tối vẫn đọc được và cuộn bảng bằng phím. Ghi nhận cảnh báo nghiêm trọng thiếu lý do bị chặn, trạng thái giữ Đang mở. Liên kết nguồn mở đúng hồ sơ thu hồi, cảnh báo thiếu đích không có nút nguồn.

**A04-F04-T01 Bị chặn**. Khung Xu hướng có 14 ngày, trả thông báo chưa có dữ liệu; đối chiếu API lab có 0 điểm ở mọi chuỗi nên chưa kiểm được thao tác trỏ điểm và độc lập bộ lọc. L02 **4 Đạt, 1 Bị chặn, 0 chưa chạy**. Toàn sổ **1.925 Đạt, 6 Không đạt, 68 Không áp dụng, 9 Bị chặn, 318 chưa chạy**. Chuyển L03, giữ phiếu L17 chờ bản sửa theo yêu cầu của Toàn.

### Mốc 13:56, đã rà đủ L03

Dòng sổ 3.019–3.044. **B01 11/11 Đạt**. Đọc và tải lại bảng giữ 11 dòng, mã kg đọc được ở 768 px và hai nền. Tạo, sửa, ngưng UOM demo bằng ba lần bấm kép, mỗi lần đúng một thay đổi và một audit cùng đối tượng. Kiểm chặn thiếu mã, tên, lý do trước lượt hợp lệ.

**B02 14 Đạt, 1 Bị chặn**. Hai kho gốc hiển thị và tải lại đủ, đọc được ở 768 px. Chưa chuyển trang được vì chỉ có một trang. Trên kho và vị trí demo mới, mỗi lần bấm kép tạo hoặc sửa chỉ ghi một thay đổi và một audit, mã kho và mã vị trí không đổi khi sửa. Ngăn vị trí đúng kho và đóng trở lại danh sách. Mẫu còn hoạt động để tiếp L04.

L03 **25 Đạt, 1 Bị chặn, 0 chưa chạy**. Toàn sổ **1.950 Đạt, 6 Không đạt, 68 Không áp dụng, 10 Bị chặn, 292 chưa chạy**. Dừng an toàn để kiểm lại ba mã L17 theo yêu cầu Toàn.

### Mốc 14:13, kiểm lại ba ca L17

Dòng sổ 3.045–3.047. Kiểm lọc chạy nối tiếp: Vitest 1/1, unit 2/2, tích hợp PostgreSQL 1/1. PostgreSQL và Redis tích hợp chỉ nghe trên loopback, đã dọn riêng hai container. Giao diện chạy lại trên bộ dữ liệu demo đã dùng từ đầu lượt.

**H02-F01-T01 Đạt**. Trang tồn gửi cặp kho/vị trí và cấp Hộp lên API. Tab Mẻ / vị trí của SKU A2 hiện đúng mẻ BATCH-25112026-000007 tại FG-RELEASED-01, 6 hộp vật lý, 6 khả dụng, 0 bán được. **H02-F03-T01 còn Không đạt ở thao tác chuột**. Tìm đúng số phiếu, kết hợp mẻ, kho, ngày 05/11 và Ghi tăng, còn đúng một dòng 12 hộp. Liên kết số phiếu đích đúng, nhấn Enter mở đúng phiếu với một dòng hàng và một dòng sổ cái. Bấm chính anchor ở 1280 px mở sang Tồn theo lô. Vùng neo có phần nằm ngoài màn hình, chưa kết luận nguyên nhân bố cục.

**H07-F01-T01 Đạt theo hướng dẫn đã sửa**. Phiếu demo chờ ký FRM-22 nhận ra mã trên PWA, chỉ rõ chỗ hoàn tất FRM-22, khóa gửi dù đã đính ảnh và tick. Phiếu chưa tăng tồn. Trưởng ngày, KCS và Kế toán kho ký đủ trên Quản trị. Ô Kế toán kho do vai thủ kho thành phẩm demo được cấp theo chính sách trên phiếu ký. Một chữ ký cuối xác nhận, ghi đúng một bút toán nhập 6 hộp và tồn khả dụng 6. Tải lại rồi nhận diện mã trên PWA cho thấy phiếu đã xác nhận, đã ghi sổ và vẫn khóa gửi.

L17 **10 Đạt, 1 Không đạt, 2 Bị chặn**. Toàn sổ **1.952 Đạt, 4 Không đạt, 68 Không áp dụng, 10 Bị chặn, 292 chưa chạy**. Tiếp L04.

### Mốc 14:20, điểm dừng L04

Đã ngừng kho và vị trí demo với kiểm lý do bắt buộc, mỗi đối tượng một sự kiện audit. Cấu hình UAT Boolean đã tạo, sửa, ngừng. Lý do RSN-26112026-000001 đã tạo, sửa, giữ hoạt động cho L05. Các thao tác bấm kép có đúng một sự kiện mỗi loại qua đối chiếu DB. Mẫu hiển thị INVENTORY chỉ mang tham chiếu giả, hàng xem ở kích thước mặc định đã che toàn chuỗi. Còn kiểm ở 768 px sáng/tối và đọc nhật ký Quản trị trước khi vào sổ L04. Dừng giao dịch an toàn, ưu tiên kiểm lại thao tác chuột H02-F03 theo yêu cầu Toàn.

Dòng sổ 3.048. **H02-F03-T01 Đạt** sau khi đưa cột Chứng từ lên sau Mẻ sản xuất. Trên màn 1280 px, điểm giữa số phiếu trỏ đúng anchor chi tiết. Bấm chuột mở đúng phiếu WR-05112026-000002, có một dòng hàng, một dòng sổ cái, 12 hộp. Dùng lại kết quả tìm số phiếu kết hợp bộ lọc ở lượt trước. API và DB demo giữ nguyên, không chạy lại các kiểm lọc.

L17 **11 Đạt, 0 Không đạt, 2 Bị chặn**. Toàn sổ **1.953 Đạt, 3 Không đạt, 68 Không áp dụng, 10 Bị chặn, 292 chưa chạy**. Nối L04 từ mốc đã lưu.

### Mốc 14:25, đã rà đủ L04

Dòng sổ 3.049–3.072. Hai đối tượng kho và vị trí demo ngừng đúng, nút xác nhận khóa khi thiếu lý do. Cấu hình Boolean thử chặn giá trị sai khi tạo và sửa, chuyển đúng false → true → ngừng. Tra nhóm Điều chỉnh tồn có 13 dòng trước khi thêm mẫu, bỏ trống tên bị khóa, tạo đúng một mã rồi sửa giữ mã đó. Bảy lượt bấm kép đều đối chiếu đúng một sự kiện ở nhật ký Quản trị và DB. Giữ lý do demo đang hoạt động để L05 kiểm ngừng.

Mẫu INVENTORY chỉ có tham chiếu giả. Cột Giá trị và tooltip che cả chuỗi. Ở 768 px, nền sáng và tối cùng mã, cùng nhãn có dấu, cuộn ngang được. Mẫu đã ngừng và giao diện về mặc định.

L04 **24/24 Đạt**. Toàn sổ **1.977 Đạt, 3 Không đạt, 68 Không áp dụng, 10 Bị chặn, 268 chưa chạy**. Tiếp L05.

### Mốc 14:35, đã rà đủ L05

Dòng sổ 3.073–3.098. Lý do thử ngừng đúng, thiếu lý do bị chặn, một audit. B3-001 chặn min lớn hơn max, lưu đúng 10,5/50,5 và một audit, đọc được ở 768 px sáng/tối. B3-002 xác nhận 10,5/20. Phiếu 04 sinh lượt MRP mới, ngưỡng thực dùng đổi từ 100/500 thành 10,5/20, tồn 550 gói giữ nguyên. Hai ca **B04-F01-T01 và B04-F02-T05 Bị chặn** ở mẫu chưa khai. Tám vật tư trong lab đều đã có ngưỡng mẫu hoặc đã xác nhận.

NCC demo SUP-26112026-000002 có một tài khoản cổng liên kết. Định danh mẫu trong catalog trùng từ trước, đã dùng một định danh riêng của lab. Mã chuẩn mì chính và sâm tra được; nguyên liệu thử tạo, đổi tên, thêm bí danh, ngừng, mỗi lần bấm kép có một audit. Tồn của nguyên liệu thử không đổi, giữ ngừng để L06 kích hoạt lại. **B06-F05-T05 Không đạt ở thông báo**. Cổng chặn đúng nguyên liệu còn trong công thức và giữ hoạt động, nhưng Quản trị bỏ phần phiên bản công thức trong lỗi máy chủ.

L05 **23 Đạt, 1 Không đạt, 2 Bị chặn**. Toàn sổ **2.000 Đạt, 4 Không đạt, 68 Không áp dụng, 12 Bị chặn, 242 chưa chạy**. Tiếp L06.

### Mốc 14:43, đã rà đủ L06

Dòng sổ 3.099–3.124. Nguyên liệu thử kích hoạt lại đúng, không đổi tồn. Vùng demo SZ-26112026-000001 tạo được, chặn hạn mức âm, lưu 1.000 kg rồi ngưng và kích hoạt lại có lý do. Nguồn ORG-26112026-000001 hiện đúng khi tìm theo tên và vùng. Tên âm riêng thiếu vùng bị khóa và không sinh bản ghi. Đổi tên giữ mã, nguồn đã xác minh không có nút sửa. Ảnh JPG demo còn đúng một bản, tệp văn bản bị từ chối. Tám sự kiện audit khớp số thao tác.

**B07-F09-T04 Không đạt ở snapshot trước**. Bấm kép chỉ một lần đổi tên và một audit, nhưng sự kiện chỉ có snapshot sau, thiếu trạng thái trước theo kịch bản kiểm lại 26/10. **B07-F07-T01 Bị chặn ở lý do từ chối**. Hai hồ sơ đã đối chiếu đủ ảnh, dòng thời gian, người và thời gian xác minh. Lab chưa có nguồn từ chối kèm lý do. L07 có thể bổ sung đúng bước đó bằng nguồn thử từ chối trước khi đưa lại Nháp.

L06 **24 Đạt, 1 Không đạt, 1 Bị chặn**. Toàn sổ **2.024 Đạt, 5 Không đạt, 68 Không áp dụng, 13 Bị chặn, 216 chưa chạy**. Dừng ở mốc an toàn để kiểm bốn bản sửa theo yêu cầu Toàn.

### Mốc 15:03, kiểm lại năm ca sau bản vá

Dòng sổ 3.125–3.129. Các kiểm lọc chạy nối tiếp: breadcrumb 2/2, hiển thị công thức 20/20, PWA 14/14 + 19/19 + 9/9, hai ca tích hợp PostgreSQL 1/1 mỗi ca và không bỏ qua. PostgreSQL và Redis cho từng ca chỉ nghe loopback, đã dọn. Dùng một lượt nạp lại API, Quản trị và PWA trên DB demo đã giữ. Từ lượt nạp này, tiến trình frontend lab chặn tự nạp dotenv và dùng cấu hình loopback.

**A03-F01-T01 Đạt**. Liên kết Tổng quan ở breadcrumb mở đúng dashboard. **B06-F05-T05 Đạt**. Cảnh báo chặn ngưng đọc được cả mã và phiên bản công thức, nguyên liệu vẫn hoạt động. **B07-F09-T04 Đạt**. Bấm kép sửa nguồn nháp đúng một thay đổi, tải lại giữ mã, audit khớp tên trước và sau, người thực hiện và tham chiếu ảnh.

**E07-F01-T01 Đạt**. Loại việc Xuất nguyên liệu và trạng thái Chờ xuất nguyên liệu kết hợp trả hai việc, mở đúng phiếu demo, ngắt riêng đường API PWA vẫn đọc lại bản lưu; đã nối lại API. **E07-F04-T04 Đạt**. Nhập 7 kg thay 7,5, nhận diện đúng phiếu, tick và để trống nội dung lý do thì gửi khóa, kể cả đã chọn mã lý do. Hàng đợi hiện lệnh cũ Bị từ chối với lý do chênh lệch, không có lệnh mới. Phiếu nhận còn chờ, chưa có dòng, sổ kho vẫn một bút toán xuất.

Toàn sổ **2.029 Đạt, 0 Không đạt, 68 Không áp dụng, 13 Bị chặn, 216 chưa chạy**. Tiếp ca phân trang có dữ liệu thử mới và lô L07.

Dòng sổ 3.130–3.131. **B02-F01-T01 Đạt**. Chạy khô rồi thêm đúng 18 kho đệm trên lab, tất cả đã Ngừng dùng. Giao diện có 21 kho, thấy hai loại kho chính còn hoạt động. Bấm Trang sau và Tải lại tại trang 2 giữ đúng mã kho nguyên liệu, số trang và tổng. **A04-F04-T01 tiếp tục Bị chặn**. Lab chưa có điểm theo ngày và ba chuỗi hiện là số việc tồn, trong khi catalog yêu cầu sản lượng và khối lượng nhập/xuất kho. Không gieo dữ liệu giả cho lệch phạm vi này.

Toàn sổ **2.030 Đạt, 0 Không đạt, 68 Không áp dụng, 12 Bị chặn, 216 chưa chạy**. Tiếp L07.

### Mốc 15:12, đã rà đủ L07

Dòng sổ 3.132–3.157. Hai nguồn demo riêng dùng cho xác minh hợp lệ và từ chối. Thiếu ảnh thì xác nhận hợp lệ bị chặn, thiếu lý do thì nút nghiệp vụ khóa ở các hộp thoại tương ứng. Đã xác minh vòng đời gửi, xác minh, từ chối, chỉnh sửa lại, tạm ngưng, khôi phục, hết hạn và gia hạn. Tám lần bấm kép có đúng một sự kiện tương ứng trong nhật ký Quản trị và DB. Nguồn tạm ngưng còn thấy menu Hết hạn, nhưng yêu cầu qua UI bị API từ chối 409, tải lại giữ Tạm ngưng và không có audit hết hạn. Đây là kết quả chặn theo kịch bản kiểm lại 26/10.

**B07-F07-T01 Đạt bổ sung**. Trước khi hồ sơ bị từ chối trở về Nháp, đã đọc được cùng mã, ảnh, lý do và sự kiện từ chối có người, ngày và giờ. Phần người và giờ xác minh đã chứng minh ở nguồn khác trong L06. L06 đủ 26/26.

L07 **25/25 Đạt**. Toàn sổ **2.056 Đạt, 0 Không đạt, 68 Không áp dụng, 11 Bị chặn, 191 chưa chạy**. Nhóm Quản trị dữ liệu gốc còn L08–L11, tiếp L08.

### Rà phụ thuộc hai nguồn thử L08 trước khi ngưng

- `UAT1010-L08-DEP-A` cho ORG-26112026-000001, đang Đã xác minh. Không có lô nguyên liệu, yêu cầu thu hoạch hay yêu cầu mua. Có một bản ghi nguồn và một ảnh, cần giữ lịch sử.
- `UAT1010-L08-DEP-B` cho ORG-26112026-000002, dữ liệu demo riêng. Không có lô nguyên liệu, yêu cầu thu hoạch hay yêu cầu mua. Có một bản ghi nguồn và hai ảnh demo, cần giữ lịch sử.

Đối chiếu qua truy vấn chỉ đọc trên đúng DB demo của lượt kiểm. Hai mã dùng trong hộp thoại ngưng hoạt động L08.

### Mốc 15:24, đã rà đủ L08

Dòng sổ 3.158–3.182. Hộp ngưng nguồn chặn thiếu lý do. Hai nguồn demo đi riêng nhánh Đã xác minh và Tạm ngưng, giữ mã, bằng chứng và bản ghi nguồn. Audit giữ mã rà phụ thuộc. Vùng hoạt động và ngừng đều hiện đúng trong danh mục. Tìm ảnh, đổi dạng danh sách, xem tệp sau và tải tệp demo thành công. Tệp tải mở được, tên và toàn bộ byte khớp ảnh gốc.

Tạo hai SKU demo mặn với mã dạng phân đoạn, cả hai INACTIVE và hai cờ tắt. Mã rỗng và gạch dưới bị chặn. Hồ sơ SKU chính đọc đúng bốn tab, các điều kiện và nguồn đánh giá. Danh mục 768 px đọc được ở nền sáng và tối. Chỉnh tên, cấu hình cỡ mẻ 1 và hồ sơ nhà máy 180 ngày, dải mẻ 1/2/3 đều đúng một giao dịch mỗi lượt bấm kép. Cỡ mẻ 0 và dải 3/2/1 bị chặn. SKU gốc chỉ đọc. Giữ hai SKU demo cho các ca tiếp, truy xuất công khai tắt và chưa có phát sinh mẻ.

L08 **25/25 Đạt**. Toàn sổ **2.081 Đạt, 0 Không đạt, 68 Không áp dụng, 11 Bị chặn, 166 chưa chạy**. Tiếp L09.

### Mốc 15:41, rà đủ L09 và năm ca gối L10

Dòng sổ 3.183–3.212. SKU demo chính đi đúng ACTIVE → INACTIVE, lý do bắt buộc, một audit mỗi lượt bấm kép. Ba SKU demo riêng kiểm ngừng hẳn từ INACTIVE, ACTIVE và bấm kép. Ca SKU gốc B08-F09-T05 giữ Bị chặn tới khi có bản sao demo riêng, giữ các SKU gốc trên lab hiện tại.

Luồng nhập chỉ đổi tên đúng SKU demo sau khi kiểm ra 0 lỗi, nhập lý do rồi áp dụng. Bản có cột điều kiện bán báo một lỗi chặn. Form mở có nội dung mẫu, lần thao tác đầu sinh thêm một bản nháp demo trạng thái DRAFT và chưa áp dụng. Sau đó đã xóa trắng nội dung để chứng minh ca chặn. Tệp JSON tải về mở được, 21 phần tử khớp rowCount và thông báo. **B08-F13-T01 Không đạt ở nhãn chọn SKU**. Liên kết đúng, URL/API đã giữ ID và bảng rỗng đúng phạm vi, ô chọn chỉ hiện nhãn chung sau khi tải. Ảnh lưu cục bộ, chờ bản vá cuối.

Ba ca đọc G1 của L09 dùng chung UAT_RECIPE_1010 G1 nháp, bốn nhóm 25%, đúng một neo gạo 1 kg ở 25%, đọc được ở 768 px sáng/tối. B09-F03 của L10 kiểm chặn G0, kiểu cố định và thiếu nhóm. Bấm kép tạo chỉ một G1 nháp. SKU demo chính đang ACTIVE để tiếp L10, công thức giữ DRAFT.

L09 **23 Đạt, 1 Không đạt, 1 Bị chặn**. L10 đã ghi **5 Đạt**, còn 20 ca. Toàn sổ **2.109 Đạt, 1 Không đạt, 68 Không áp dụng, 12 Bị chặn, 136 chưa chạy**. Nối L10 từ B09-F04 trong khi chờ bản vá nhãn cuối.

Dòng sổ 3.213. **B08-F13-T01 Đạt** sau một lượt nạp Quản trị. Từ điều kiện thiếu thương phẩm mở đúng GTIN, ô chọn hiển thị UAT1010/CS – Cháo thử nhập cùng ID đã lọc. Bảng rỗng đúng SKU, quay lại điều kiện giữ Không đạt. Ảnh trước/sau lưu cục bộ. Ba kiểm lọc Quản trị chạy nối tiếp đạt 6/6, 7/7 và 50/50.

L09 **24 Đạt, 1 Bị chặn**. Toàn sổ **2.110 Đạt, 0 Không đạt, 68 Không áp dụng, 12 Bị chặn, 136 chưa chạy**. L10 nối từ B09-F04.

### Mốc 16:00, đã rà đủ L10 và bốn ca gối L11

Dòng sổ 3.214–3.237. Trên G1 demo, bấm kép thay dòng, gửi duyệt, kích hoạt đều một giao dịch. Vai QA demo duyệt riêng với người gửi. Cổng nháp chặn kích hoạt, công thức đang chạy chặn thay dòng, đề nghị đang chờ chặn gửi trùng. G1 demo chính vẫn Đang vận hành, PILOT bản gốc để thực hiện L11.

G3 demo thay đúng G2 UAT trên SKU A2. G2 ngừng, G3 vận hành, G1 của A2 vẫn vận hành. Bảy dòng MRP có tham chiếu snapshot và tám bản phân giải giữ nguyên băm trước/sau. Hai audit thay và kích hoạt cùng một đối soát. Sau đó ngừng G3 bằng bấm kép, một audit. Công thức G4 UAT riêng từ Đã duyệt ngừng đúng. Các nhánh phục hồi yêu cầu đã hủy, nguồn APPROVED_SEED_BASELINE và lịch sử pilot hai phiên bản chưa có mẫu phù hợp trên lab dùng chung.

L11 đã đạt ca lý do sửa quá ngắn và ba ca quy trình sơ chế trên hai ghi chú riêng. Cảnh báo hiển thị đúng phạm vi của từng ghi chú, tỷ lệ không đổi, bấm kép chỉ có một audit.

L10 **19 Đạt, 6 Bị chặn**. L11 đã ghi **4 Đạt, 5 chưa chạy**. Toàn sổ **2.128 Đạt, 0 Không đạt, 68 Không áp dụng, 18 Bị chặn, 112 chưa chạy**. Tiếp hồ sơ chạy thử và phần còn lại L11.

## 16:10 ngày 26/11 — L11

- L11 chốt lượt đầu 7 Đạt, 2 Bị chặn. Phiếu chạy thử A2 mới KQCT-20261125-000015 ký đủ Trưởng ngày và KCS. Đề nghị chốt dùng duy nhất phiếu này, bấm kép sinh đúng một yêu cầu và một audit. Giữ yêu cầu demo chờ duyệt cho O03, G1 A2 vẫn chạy thử rev 0.
- B09-F10-T01/T04 chờ mẫu G1 độc lập có mẻ và snapshot cũ. G1 demo riêng chưa có lịch sử; giữ mẫu chuẩn lab chung.
- Sau dòng sổ 3242, lũy kế 2.131 Đạt, 0 Không đạt, 68 Không áp dụng, 20 Bị chặn và 107 chưa chạy trên 2.326 bước.

## 16:27 ngày 26/11 — L13, L19 và L20

- L13 chốt 4 Đạt, 1 Bị chặn. Lô 000039 chỉ sang Sẵn sàng sản xuất sau lần gửi được nhận và vẫn 10 kg với sổ gốc. Lô riêng bỏ xác nhận, lô giữ và lô loại không chuyển.
- L19 chốt 3 Đạt, 1 Bị chặn. Ghi nhận QR chỉ sau sync, giữ nguyên hạn chế. L20 lượt đầu 6 Đạt, 1 Không đạt, 2 Bị chặn. CAPA chính thay 0 bằng chứng thành 1 ảnh, không đóng hồ sơ. ACK cấp mẻ B4 không mở khóa, trang điều kiện bán giữ chặn.
- K03-F02-T01, vai QA phát hành: thẻ P11 ghi khóa tem QR, chi tiết lại hiện Phạm vi khác · Chưa có mã và trường Mã đã quét là QR. Máy chủ khớp đúng hồ sơ, khóa QR vẫn ACTIVE, chưa gửi ACK tem. Phiên chính đã bàn giao vá phạm vi, chờ retest giới hạn.
- Các ca gửi lại sau khi Đã gửi chưa đi tới máy chủ vì nút gửi đã vô hiệu. Các lần lỗi mạng trước khi hệ thống nhận chỉ chứng minh thử lại lệnh chưa áp dụng.
- Sau dòng sổ 3260, lũy kế 2.144 Đạt, 1 Không đạt, 68 Không áp dụng, 24 Bị chặn và 89 chưa chạy trên 2.326 bước.

## 16:31 ngày 26/11 — Mở L21/L22

- L22 phần quét mã có 2 Đạt, 1 Không đạt, 1 Bị chặn: mã rỗng bị khóa gửi, QR có khoảng trắng nhận đúng, mã không tồn tại không sinh việc nhưng hiện nhãn Đã nhận ra. Lô hợp lệ có ID/mã và liên kết đúng, phần đầu lại báo Không nhận ra mã này. Đã báo phiên chính. Camera không có thiết bị phù hợp, nhập tay làm tiếp được.
- Chờ bản vá nhãn N07 trước cùng lượt nạp PWA với bản vá K03; kiểm tra đơn vị K03 đang chạy tuần tự. Chưa gửi ACK QR.
- Sau dòng sổ 3264, lũy kế 2.146 Đạt, 2 Không đạt, 68 Không áp dụng, 25 Bị chặn và 85 chưa chạy.

## 16:39 ngày 26/11 — Kiểm lại bản vá quét mã

- N07-F01-T02 Đạt sau sửa. 14 test lọc giao diện đạt. Trên app, lô có khoảng trắng được nhận đúng loại/mã và liên kết đúng; mã lạ hiện nhãn Không nhận ra, không có liên kết. Giữ ca QR tay đã đạt.
- K03 đã qua 9 unit lọc bản phạm vi. Trên app thấy đúng Tem QR và mã, QR khác bị chặn, QR thật khớp. Ô Mã đã quét sau khi khớp còn hiện QR, nên chưa gửi ACK. Đã bàn giao thêm sửa mã hiển thị, chỉ chạy lại nhánh scan thay đổi.
- L21 đã kiểm cổng vào/ra quyền. Tài khoản R-OPS-MGR trong danh mục thiếu quyền Mobile trên lab; tài khoản R-AUDITOR bị chặn. Dựng địa chỉ localhost riêng trên cùng Next cho thiết bị demo để bảo toàn hàng đợi cũ.
- Sau dòng sổ 3276, lũy kế 2.157 Đạt, 1 Không đạt, 68 Không áp dụng, 26 Bị chặn và 74 chưa chạy trên 2.326 bước.

## 16:42 ngày 26/11 — Chốt lại L20

- K03-F02-T01 Đạt sau bản cuối. Tem QR hiển thị đúng phạm vi và mã, QR khác bị chặn, tem đúng giữ mã thật ở Mã đã quét. Unit bản phạm vi 9/9, lọc riêng phần scan thay đổi 6/6. Gửi ACK tem đúng một lần: ghi nhận APPLIED và khóa vẫn ACTIVE. Không lặp ACK cấp mẻ B4.
- L20 chốt 7 Đạt, 2 Bị chặn. Sau dòng sổ 3277, toàn sổ 2.158 Đạt, 0 Không đạt, 68 Không áp dụng, 26 Bị chặn và 74 chưa chạy.

## 16:57 ngày 26/11 — Thiết bị và hàng đợi

- A/B/A dùng hai tài khoản demo, giữ lệnh sơ chế và JPG của A, B không thấy và không có lệnh chờ gửi. Hai tab chủ A cùng bấm gửi, máy chủ chỉ ghi một lệnh, một sự kiện sơ chế và một bằng chứng.
- Tại origin lab riêng, ghép và thu hồi đúng thiết bị thử, lệnh chờ bị chặn và máy chủ chưa nhận. Dọn chỉ một mục đã gửi, giữ nguyên lệnh chờ và ảnh. Địa chỉ lab cũ và hàng đợi cũ vẫn giữ.
- L22 có sáu ca chọn/tự gửi mục chọn bị chặn do giao diện chỉ có Gửi tất cả. N07-F12-T01 không đạt: sau Tải lại danh sách vẫn còn bảng kết quả cũ. N07-F10-T01 bị chặn thao tác thủ công vì app tự gửi trước; máy chủ nhận đúng một kết quả.
- Sau dòng sổ 3305, L21 18 Đạt, 6 Bị chặn, 1 chưa chạy. L22 10 Đạt, 1 Không đạt, 8 Bị chặn, 2 chưa chạy. Toàn sổ 2.173 Đạt, 1 Không đạt, 68 Không áp dụng, 38 Bị chặn, 46 chưa chạy.

## 17:02 ngày 26/11 — Chốt lượt đầu L21

- N07-F12-T01 Đạt sau bản vá. Unit hàng đợi 15/15; thao tác tải lại giữ nội dung thẻ/lần thử và bỏ bảng kết quả cùng nút cũ. L22 còn hai ca cần trạng thái xung đột hoặc rà soát thực.
- N01-F05-T01 Không đạt phần thông báo. Chỉ trên hồ sơ dùng một lần UAT_L21_CLEAR_2611, xóa 2 lệnh demo và 1 ảnh chưa lên máy chủ. Đăng nhập lại, hộp kiểm cho thấy 0 lệnh, 0 ảnh, máy chưa ghép. Màn ngay sau xóa ghi lệnh chưa gửi vẫn còn và không hiện biên nhận. Kết quả máy chủ của ca trước còn nguyên. Đã báo phiên chính.
- Sau dòng sổ 3307, L21 18 Đạt, 6 Bị chặn, 1 Không đạt. Toàn sổ 2.174 Đạt, 1 Không đạt, 68 Không áp dụng, 38 Bị chặn, 45 chưa chạy. Chuyển kiểm các ca quản trị.

## 17:13 ngày 26/11 — Chốt L23

- L23 23 Đạt, 2 Bị chặn. Duyệt đúng đề nghị A2 demo với người khác người gửi sau khi kiểm đủ căn cứ. Một quyết định, một audit; A2 chính thức bản gốc với 7.150 gói, 715 hộp, 72 thùng.
- Màn và thao tác Tài khoản dịch vụ được trả ACTIVE. Menu từ 1304 sang 165 rồi về 1304, một audit mỗi chiều. Hai mã bảo vệ không thay đổi. Kiểm giao diện 768 điểm ảnh sáng/tối và tạo người dùng khi thiếu tên.
- O03-F01-T04 kẹt đăng nhập người gửi của mẫu thường. O03-F01-T06 thiếu mẫu hợp lệ có hai người duyệt từ đầu.
- Sau dòng sổ 3336, lũy kế 2.201 Đạt, 1 Không đạt, 68 Không áp dụng, 40 Bị chặn, 16 chưa chạy.

## 17:23 ngày 26/11 — Chốt L24

- L24 đạt 18/18. Duyệt demo A2 có đúng một quyết định và một audit. Nhật ký lọc, xem chi tiết, sao chép và xuất đúng một dòng demo. Mã băm sao chép đủ 64 ký tự.
- Xác minh thủ công audit_log/default kiểm 17.828 dòng, Hợp lệ, không có khóa lệch. Bấm kép chỉ một mã xác minh và một audit. Chỉ mở outbox, không gửi sự kiện. Mã ghép cấp cho Nam bị chặn trên thiết bị demo của Tuấn.
- Bộ lọc bản vá biên nhận xóa dữ liệu đạt 72/72. Sau dòng sổ 3350, 2.215 Đạt, 1 Không đạt, 68 Không áp dụng, 40 Bị chặn, 2 chưa chạy. Còn kiểm lại biên nhận và hai ca xung đột L22.

## 17:29 ngày 26/11 — Đủ kết quả lượt đầu

- N01-F05-T01 Đạt sau sửa. Hai lệnh mới và một ảnh chưa gửi được xóa riêng trên hồ sơ demo; tab vừa xóa có số lượng và biên nhận, tab kia trung tính. Hai URL không có metadata. Ghép lại cùng vai, 0 lệnh/ảnh. Bộ lọc 72/72, dữ liệu máy chủ giữ nguyên.
- L22 chốt 13 Đạt, 8 Bị chặn. Tạm dừng đúng lệnh công việc demo sau khi xếp lệnh check-in, tạo CONFLICT thật. Nút xem mục cần rà soát cuộn đúng thẻ. Thử lại giữ nguyên mã, một REPLAYED trả CONFLICT, không chấm công.
- Sau dòng sổ 3353: 2.218 Đạt, 0 Không đạt, 68 Không áp dụng, 40 Bị chặn và 0 chưa chạy trên 2.326 bước. Rà mẫu khả thi cho các ca bị chặn, vẫn chỉ một phiên kiểm.

## 17:36 ngày 26/11 — Gỡ B08-F09-T05

- Chỉ trên clone demo tách DB và cổng loopback, thao tác ngừng SKU B6/CS/GAAC đi đúng API clone. SKU thành RETIRED, không kích hoạt lại được, một audit. Tồn vẫn 1.000 hộp khả dụng, không giữ/đặt, bút toán và lịch sử giữ nguyên. Lab nguồn vẫn ACTIVE_BASELINE và không có audit ngừng SKU.
- Sau dòng sổ 3354, L09 25 Đạt. Toàn sổ 2.219 Đạt, 0 Không đạt, 68 Không áp dụng, 39 Bị chặn, 0 chưa chạy.

## 17:46 ngày 26/11 — Gỡ B04 và O03

- B04-F01-T01 và B04-F02-T05 Đạt trên clone. Dòng B3-003 mô phỏng đúng trạng thái seed chưa khai, hai ô hiện dấu gạch. Khai 10,5/20 gói qua UI, một audit. Chạy lại phiếu 04 demo một lần, B3-003 lấy đúng 10,5 và 20, tồn giữ 300 gói và bút toán gốc. Lab nguồn giữ số seed cũ.
- O03-F01-T04 Đạt bằng đề nghị duyệt thường của công thức demo mới. Chính người gửi nhập tham chiếu, app báo vi phạm chính sách, API trả 422, yêu cầu vẫn PENDING với 0 quyết định. O03-F01-T06 thiếu chính sách hai người duyệt đủ mẫu.
- Sau dòng sổ 3357, 2.222 Đạt, 0 Không đạt, 68 Không áp dụng, 36 Bị chặn, 0 chưa chạy.

## 17:49 ngày 26/11 — Gỡ ba ca lịch sử G1

- Clone có A1 G1 bản gốc và phiếu chạy thử đã ký. Bấm kép lưu bản sửa 1 chỉ tạo một revision và một audit. Gạo neo 195→197,5 kg, Sâm 9→12,5 kg. Mẻ đã chạy giữ đúng băm snapshot và phiếu bản gốc ghi 195 kg. G1 lab nguồn vẫn bản gốc.
- Phiếu cũ hiển thị không phải bản đang dùng, có kết luận Cần điều chỉnh – chạy lại. Hộp đề nghị mới báo chưa có phiếu đạt ở bản đang dùng; chưa gửi đề nghị.
- Sau dòng sổ 3360, 2.225 Đạt, 0 Không đạt, 68 Không áp dụng, 33 Bị chặn, 0 chưa chạy.

## 17:55 ngày 26/11 — Chốt lượt UAT duy nhất

Sau dòng sổ 3361, toàn bộ 2.326 bước có 2.225 Đạt, 0 Không đạt, 68 Không áp dụng, 33 Bị chặn, 0 chưa chạy. Gỡ thêm bảy bước sau lượt rà đủ ban đầu bằng clone demo tách DB và cổng loopback. Lượt cuối N07-F10-T01 vẫn bị chặn thao tác tay. App tự nhận cùng lệnh trước khi có thể bấm Gửi lại, máy chủ một APPLIED.

| Số bước | Điều kiện còn thiếu | Mã |
|---:|---|---|
| 1 | Chuỗi số liệu đúng đại lượng của danh mục biểu đồ | A04-F04-T01 |
| 5 | Không có mẫu đề nghị mồ côi hợp lệ hoặc công thức seed lịch sử đúng loại | B09-F06-T01/T02/T04, B09-F07-T04, B09-F08-T05 |
| 5 | Cần thao tác phát lại đúng mã đã áp dụng; hàng đợi hiện khóa gửi lại mục đã gửi | D06-F03-T05, H07-F01-T05, J04-F01-T04, K03-F01-T04, K03-F02-T05 |
| 4 | Cần mẻ sau sấy chưa ký, mẫu tự nhả hết hạn với worker phù hợp, nguồn bị giữ sau khi xếp lệnh hoặc mẫu duyệt hai người | G03-F01-T04, H05-F04-T01, N07-F06-T05, O03-F01-T06 |
| 4 | Cần camera hoặc thiết bị quét đúng tình huống | J03-F02-T01/T02/T03, N07-F02-T01 |
| 2 | Cần mẫu ảnh/video đã duyệt cho truy xuất công khai và phiên cài PWA đủ bằng chứng | J03-F03-T01, J03-F04-T01 |
| 5 | Cần vai R-OPS-MGR có Mobile như danh mục và người kiểm trực tiếp nhập/xác nhận đổi mật khẩu thử | N01-F01-T01, N01-F02-T01, N01-F03-T01/T02/T04 |
| 6 | Danh mục yêu cầu chọn từng mục gửi hoặc tự gửi các mục đã chọn; giao diện hiện dùng Gửi tất cả | N07-F07-T01/T02/T03, N07-F08-T01/T02/T03 |
| 1 | Cần thực hiện thao tác tay trước lần tự gửi lại | N07-F10-T01 |

Phiên test đã dừng các tiến trình lab do mình mở. Container PostgreSQL demo dùng chế độ tự xóa nên Docker xóa cả container và volume khi dừng. Chưa sao lưu riêng trạng thái DB lab/clone sau lượt test. Sổ ca, log API cục bộ và kết quả truy vấn đã ghi vẫn còn. Ảnh cắt biên nhận xóa bị trống, bằng chứng ca lấy từ nội dung giao diện đã quan sát, kiểm thử lọc và số đếm trước/sau. Tệp Next tự sinh đã trả đúng nội dung trước đó. Bằng chứng lượt này là UAT cục bộ.

Phiên Sheet đã đọc lại M12-009 và M12-105 tại mốc 17:55 ngày 26/11. Cả hai khớp số chốt 2.225 Đạt, 33 Bị chặn và 0 chưa chạy.

Hai ghi nhận vận hành của lượt kiểm: Next/Vitest lúc đầu có thể tự nạp cấu hình môi trường theo mặc định, chưa có bằng chứng xác định lần đó có nạp tệp. Từ khi phát hiện khả năng này, trình chạy đã chặn truy cập tệp môi trường và dùng cấu hình lab riêng. Ca CSV L09 phát sinh một phiếu nháp 0 dòng chưa áp dụng trước khi chạy mẫu đúng; số nghiệm thu dùng mẫu đúng và không ghi nhận tác động nghiệp vụ từ bản nháp.
