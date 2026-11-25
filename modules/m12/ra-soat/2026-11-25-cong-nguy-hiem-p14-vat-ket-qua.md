# Cổng Nguy hiểm: kết quả kiểm độc lập vùng P14 (migration 160) + VAT P1b (25/11, HEAD `03158964c`)

Người kiểm: verifier độc lập thứ ba, chạy 01:02 → 01:48 với khoá `@bo-kiem-du` + `@dot-bien`. HEAD đầu = cuối = `03158964c`; cây chỉ còn 3 tệp supplier-portal dirty (không phải của m12); `git diff HEAD` trên services/tests/db/packages rỗng; mọi tệp đột biến `cmp` giống bản gốc; `.artifacts` và scratch đã xoá. Không kiểm: số dòng nội dung công khai trên `.99`; tương thích app cũ (`NOT_PROVEN`); test giao diện P14; phía M3/M4 có chịu mã nhóm/loại lạ không; lệnh sản xuất thật cho SKU loại mới.

**Kết luận: P14 CẦN SỬA (không có lỗi S1/S2; hai điểm S3). VAT P1b ĐẠT (chờ bộ đủ).**

Để tránh nhầm số với F1–F4 của lượt #17/P13, các điểm lượt này ghi là **P14-1, P14-2, P14-Q1, P14-Q2**.

| Lệnh | Đạt / đỏ / bỏ qua |
|---|---|
| Unit, 5 lọc của brief | 56 / 0 / 0 (5 lọc bỏ sót nhiều lớp vì khớp theo tên lớp) |
| Unit, mở rộng thêm các lớp bị sót | 279 / 0 / 0 |
| Integration `SkuClassificationP14` + `OperationalConfigP1b` (PG 18 thật) | 19 / 0 / 0 |

Đột biến: P14 5 lần (guard nhận mã đã ngừng; ngừng mã bỏ kiểm còn SKU dùng; bỏ khoá loại hệ thống; đổi tên không ghi; **đếm "SKU đang dùng" bỏ `ACTIVE_BASELINE` ⇒ XANH**) · VAT 5 lần (bộ đọc cấu hình `null`; bao bì cho 7 và 12; tắt kiểm khi tạo phiếu nguyên liệu; chấp nhận tập rỗng; bỏ kiểm tập con) ⇒ cả 5 đỏ.

## P14

- **Migration 160 trên dữ liệu mô phỏng: đạt.** Lùi về 159, chèn 12 SKU đủ 3 nhóm × 2 loại × ACTIVE/INACTIVE + 3 nội dung công khai, áp 160 ⇒ dữ liệu cũ nguyên vẹn, 3 khoá ngoại validated RESTRICT không dòng mồ côi, 3 CHECK cũ biến mất, danh mục đúng 5 dòng gốc; chạy migration và seed hai lần không lỗi. Down khi chưa sửa danh mục: lùi được, dữ liệu nguyên. Down bị từ chối khi đã thêm mã mới, ngừng nhóm gốc, đổi tên loại hệ thống, hoặc ngừng rồi bật lại nhóm gốc (ba ca sau ngoài danh sách test của coder).
- **Đua: đạt.** 24 vòng PATCH SKU ACTIVE sang nhóm X trong lúc ngừng nhóm X: luôn 200/409 hoặc 422/200, không SKU ACTIVE treo nhóm đã ngừng (nhờ SERIALIZABLE). Tạo trùng mã 12 vòng: luôn 201/409.
- **P14-1 · S3 · nợ test (chặn "ĐẠT" theo luật đột biến):** guard "ngừng mã còn SKU đang dùng ⇒ 409" chưa có test cho SKU `ACTIVE_BASELINE` (20 SKU thật đều ở trạng thái này); đột biến bỏ `ACTIVE_BASELINE` khỏi câu đếm (`EfSkuClassificationRepository.cs:13-17`) vẫn xanh 70 unit + 18 integration; mã đúng (test scratch cho 409). **Đang thêm test (coder `m12/fix-P14`).**
- **P14-2 · S3 · lỗi:** `ActivateSkuHandler.cs:20-26` không kiểm nhóm/loại còn ACTIVE: SKU INACTIVE ở nhóm G ⇒ ngừng G (hợp lệ) ⇒ kích hoạt SKU ⇒ 200, SKU ACTIVE nằm trong nhóm INACTIVE. `ApplySkuImportDraftHandler` cũng chưa thấy kiểm lại mã ACTIVE lúc áp (chỉ đọc mã). **Đang sửa (coder `m12/fix-P14`): gọi `SkuClassificationGuard.CheckAsync` trước khi kích hoạt.**
- **P14-Q1 · S3 · Toàn quyết (= m12.210):** loại SKU mới thêm qua API không có cờ "cấm nguyên liệu động vật": đi nhánh "không phải VEGAN" nên công thức cho nguyên liệu gốc động vật (`RecipeIngredientPolicyGuard.cs:65-67`, `EfRecipeDietaryReferenceReader.cs:36`, `RecipeVeganGuardRecheck.cs:79`). Giảm nhẹ: `dietaryFlags` công khai là tập đóng VEGAN/SAVORY và phải bằng loại của SKU (`ProductPublicContentSkuAlignment.cs`) nên loại tự đặt không công bố được "VEGAN". Khối A lệnh sản xuất in mã thô (`ProductionOrderFormSourceResolver.cs:452-459`, màn FE hiện "khác"); API ngoài `/v1` phát `dietaryType` thô (`ExternalSkuCatalogProjection.cs:97`) trong khi hợp đồng chỉ khai VEGAN/SAVORY (phiên lead nếu thêm mã loại). Chưa chạy lệnh sản xuất thật cho loại mới.
- **P14-Q2 · S3 · Toàn quyết:** đổi tên nhóm không cập nhật tên đã lưu trên SKU cũ (`ref_sku.sku_group_name` là chuỗi do client gửi): lệch ở tìm SKU theo tên nhóm (`EfSkuCatalogRepository.cs:133`), tồn kho thành phẩm (`ListFinishedGoodsWarehouseStockHandler.cs:54`, `GetFinishedGoodsWarehouseStockDetailHandler.cs:66`), độ sẵn sàng SKU.

## VAT P1b: ĐẠT

- DI: `IOperationalConfigReader` đăng ký singleton không điều kiện (`ModuleInfrastructureServiceCollectionExtensions.cs:145`); lấy từng handler qua DI thật: cả 10 handler có tham số `IOperationalConfigReader? = null` nhận bộ đọc thật (gồm 5 handler VAT). Bản chạy thật chỉ rơi về mặc định 0/5/8/10 khi dòng cấu hình thiếu/INACTIVE/sai kiểu/lỗi DB; mặc định chính là tập trần nên không lọt ra ngoài (S4).
- Đường nhập thuế suất truy vết đủ: chỉ có 5 chỗ ghi (`CreateIntakeHandler.cs:48-52`, `AcceptLineHandler.cs:38-42`, `UpdateLinePriceHandler.cs:47-49`, `UpdatePackagingIntakeLinePriceHandler.cs:46-50`, `DemandMrpCommands.cs:441-445`), cả 5 gọi `AllowedVatRatePolicy`. App hiện trường không có ô giá/thuế; không có đường import giá; phiếu nhà cung cấp gửi không mang thuế.
- HTTP trên 3 endpoint theo dòng: 7, 9, 10.5, 12, 100 ⇒ 422 `VAT_RATE_NOT_ALLOWED`; −1 ⇒ 422; `""`, `"abc"` ⇒ 400; 0/5/8/10/8.00 qua. Bỏ một mức khi phiếu cũ còn mang mức đó: phiếu cũ không bị chặn khi đóng, đẩy MISA hay chấp nhận dòng không gửi thuế; chỉ gửi lại đúng mức đã bỏ mới 422. Bộ đệm 30 giây: cùng tiến trình làm mới ngay; chỉ nhiều bản API mới trễ (mặc định 1 bản). S4.
- **Nợ S3 (có từ trước P1b):** `LinePriceRequest.TaxRate` (`RawMaterialIntakeRequests.cs:84`) và `PackagingIntakeLinePriceRequest.TaxRate` (`OperationalSourceContracts.cs:772`) là `decimal` không nullable ⇒ body bỏ `taxRate` thì ra thuế 0 và qua kiểm (thử qua HTTP). Bảng dòng phiếu bao bì không có CHECK thuế suất (migration `20260818163000_OD10AAddPackagingIntakeMoneyBlock.cs:23-34` cố ý bỏ); chỉ dựa vào 2 chỗ ghi đã có kiểm.
- Nợ S4: tên loại VEGAN đổi được (khoá chỉ chặn ngừng); không có test khẳng định handler nhận bộ đọc từ DI.

## Cần Toàn quyết

1. P14-Q1 (m12.210): thêm cột cờ "cấm nguyên liệu động vật" cho `ref_sku_type`, hay chấp nhận loại mới là "không phải VEGAN" và cấm đặt tên kiểu "chay". Đề xuất: chấp nhận (làm khi có loại chay thứ hai), như đã chốt.
2. P14-Q2: đổi tên nhóm có cập nhật tên trên SKU cũ không (cập nhật theo mã, hay đọc tên qua nối bảng), hay chấp nhận. Đề xuất: đọc tên qua nối bảng khi có thời gian; nay chấp nhận và nhắc chỉ đổi tên khi cần (nhóm gốc chưa cần đổi tên).
3. Nợ VAT: bắt buộc `taxRate` khi gửi giá dòng (đổi kiểu nullable + 422 khi thiếu)? Đề xuất: làm sau chạy thật (S3, tập thuế mặc định còn 0 nên không chặn được).
