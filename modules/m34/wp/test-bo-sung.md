# test-bo-sung — gói 8: test và FE còn thiếu sau rà NK-b (link đảo chéo, E2E thu hồi, externallyManaged, nút Giữ chỗ Giờ Vàng)

Trạng thái: XONG `d8960e9b0` (chưa push) · verifier ĐẠT · Sheet M3-150/159/152/135 Hoàn thành · bộ đủ sóng ĐẠT 18:4x, gộp dev `d3d91686d` · Rủi ro: R2 · Chế độ: A (worktree tách rời → patch → phiên chính áp + commit `toandeptrai`) · Mốc: 18/11
Hạng mục nâng: nối M12 → M3 có test qua HTTP/Spring/DB thật cho thu hồi và đối soát link, FE khoá đúng dòng tồn do M12 quản · Sheet: M3-150, M3-159, M3-152, M3-135 · Ước lượng: 3 giờ
Chỗ làm: `C:\Projects\_wt\m34\test-bo-sung` · Base SHA: `95ebd81dd` · Patch: `C:\Projects\_wt\m34\test-bo-sung.patch`
Nguồn: phiếu `SUA-SAU-RA-SOAT-NKB.md` gói 8; note Cần sửa M3-150/159/152/135 (`ra-soat/evidence/2026-11-14-nm3-26/ket-qua.json`); gói 6 `cau-hinh` (`2937d0cb9`) đã làm phần cấu hình của M3-135 (từ chối cờ Giờ Vàng khi chưa NK-c) và M3-159 (allowlist vào compose).

## Brief
1. Repo `C:\Projects\ginsengfood-business-platform` (chỉ đọc) · làm trong `C:\Projects\_wt\m34\test-bo-sung` (HEAD tách `95ebd81dd`) · luật chung `C:\Projects\_wt\m34\_tools\BRIEF_CHUNG_SUA_NKB.md` (đọc trước; thay base = `95ebd81dd`).
2. Mục tiêu và tiêu chí đạt (mỗi phần độc lập, nộp patch sau từng phần):
   (a) M3-150: test hai link đảo chéo (SKU A trỏ `sku_id` của B, B trỏ của A) đi qua vòng đối soát SKU-M3-03 → cả hai bị chặn `LINK_CODE_MISMATCH`. Cho `OpsCoreFixtureVerdictContractTest`
       truyền `sku_id` của link (ca khớp + ca lệch) trên 11 tệp chụp; nếu 13 JSON cần đổi hợp đồng thì KHÔNG sửa hợp đồng, ghi `CẦN QUYẾT` (đề xuất chuyển sang NM3-15b).
   (b) M3-159: E2E thu hồi qua endpoint công khai: SpringBootTest + M12 giả (HTTP cục bộ, không mạng ngoài) trả `recall_case_open=true` → poller chạy → bảng chiếu cập nhật →
       GET công khai của sản phẩm chỉ trả `INVENTORY_UNAVAILABLE` (không lộ lý do thu hồi). Test phải đỏ khi bỏ bước chiếu hoặc khi API công khai lộ mã khác.
   (c) M3-152: thêm `externallyManaged` vào `AdminInventoryStockResponse`: true khi cờ quản lý ngoài BẬT và (kho có link HOẶC SKU có link) — đúng luật BE đang chặn ở
       `InventoryExternalManagementServiceImpl.java:47`. FE dùng trường này cho từng dòng tồn và form nhập đầu trang (ẩn/khoá Nhập, Điều chỉnh, Sẵn sàng giao như với kho có link).
       Test BE (ca "SKU có link, kho chưa link" → true; cờ tắt → false) + vitest cùng ca.
   (d) M3-135 (3): FE ẩn (hoặc khoá kèm câu giải thích) nút "Giữ chỗ" Giờ Vàng khi BE báo bị chặn (409 `GOLDEN_HOUR_OPS_CORE_HOLD_NOT_READY`; tìm chỗ FE gọi giữ chỗ và chỗ đã ánh mã
       trong `front-end/src/shared/utils/opsCoreErrorMessages.ts`). Nếu BE chưa có tín hiệu đọc được trước khi bấm, chọn cách ít đụng nhất (vd ẩn sau lần 409 đầu, hoặc trường trạng thái sẵn có) và ghi lý do. Vitest.
   Mọi khẳng định về mã có tệp:dòng ở `95ebd81dd`; điều chưa chắc ghi `CHƯA KIỂM`.
3. Phạm vi ghi: `back-end/src/test/**` (test mới/sửa cho 4 phần), `back-end/src/main/java/com/ginsengfood/project/inventory/**` (chỉ DTO `AdminInventoryStockResponse` + chỗ dựng nó + truy vấn cần cho `externallyManaged`),
   `front-end/src/features/inventory/**` hoặc nơi có màn tồn kho quản trị, `front-end/src/features/gold_hour/**` + `front-end/src/app/(storefront)/me/golden-hour/**` cho phần (d) (+ test).
   CẤM: `back-end/src/main/resources/db/migration/**` (không thêm migration), hợp đồng M12 (`C:\Projects\_wt\m12\contracts-noi-m3`, `ginsengfood-contracts`), `deploy/**`,
   `docs/integration/**`, IVR (`com.ginsengfood.project.ivr`, `features/ivr`), `OrderCreateServiceImpl.java`, `application.yml`. Test chéo module đặt ở `opscorecontract` theo luật chung; không thêm vi phạm `ModuleBoundaryArchitectureTest`.
4. Đọc trước: 4 note ở mục Nguồn; `OpsCoreFixtureVerdictContractTest`, vòng đối soát SKU-M3-03 (grep `SKU-M3-03`, `LINK_CODE_MISMATCH`), poller thu hồi (grep `recall_case_open`), `InventoryExternalManagementServiceImpl`,
   `AdminInventoryStockResponse`, FE màn tồn kho quản trị, `opsCoreErrorMessages.ts`.
5. Lệnh kiểm nhanh: Maven qua khoá `bash C:/Projects/_wt/m34/_tools/mvn-lock.sh C:/Projects/_wt/m34/test-bo-sung/back-end test -P ci-unit -Dtest='<các lớp mới/sửa + lớp sẵn có cùng vùng>' …` (luật chung);
   Testcontainers một-lần nếu lớp cần Postgres; FE `npx vitest run <thư mục sửa>` trong `front-end` (tạo junction `node_modules` tới `C:\Projects\ginsengfood-business-platform\front-end\node_modules` nếu thiếu, xoá junction trước khi nộp patch; patch không được chứa `node_modules`).
6. Bằng chứng: patch; số ca từng lớp/tệp; lần đỏ trước khi sửa cho mỗi phần; đột biến ≤ 3 (bỏ so `sku_id` → ca đảo chéo đỏ; bỏ chiếu thu hồi → E2E đỏ; `externallyManaged` chỉ xét kho → ca SKU-link đỏ).
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`.
8. Đầu ra ≤ 25 dòng theo brief chung; báo cáo dài `C:/Projects/_wt/m34/test-bo-sung-bao-cao.md`.

## Diễn biến
- 16/11 10:04 tạo worktree `_wt/m34/test-bo-sung` (`74de1cd0b`), giao coder (song song `script-99`).

- 16/11 10:0x Toàn đổi việc (D-lead-051 → D-m34-088): dừng coder ở điểm sạch; coder chưa sửa tệp nào, patch rỗng → xoá; worktree sạch → gỡ. Báo cáo cho Phúc làm tiếp: `C:/Projects/_wt/m34/test-bo-sung-bao-cao.md` (thiết kế, tệp:dòng). 10:4x Toàn đính chính (D-m34-091): gói vẫn của Toàn, không chuyển Phúc.
- 16/11 13:1x Toàn "Chạy lại": tạo lại worktree `_wt/m34/test-bo-sung` (`95ebd81dd`), giao coder kèm báo cáo thiết kế `_wt/m34/test-bo-sung-bao-cao.md`.
- 16/11 13:5x coder lượt 2: CHƯA XONG · (a)(c)(d) đạt, patch 18 tệp +1297/−40 · test mới `OpsCoreCrossedLinkContractTest` (4), `OpsCoreRecallPublicEndpointPostgresTest` (E2E enforce), Fixture 50, ExternalMgmt 27…; vitest inventory 80, gold_hour + ops-core utils 277 · ModuleBoundary đúng 3 đỏ cũ · đột biến 3/3 (bỏ so `sku_code` thay cho `sku_id`) · (d) khoá nút Giữ chỗ cả trang sau 409 đầu (BE chưa có tín hiệu trước) · **(b) E2E bắt lỗi thật**: thu hồi → trang công khai trả `NOT_FULFILLMENT_READY` thay vì `INVENTORY_UNAVAILABLE` (poller ghi `fulfillmentReady` `OpsCoreSellableVerdictPoller.java:277-287`; `ACTIVE_INVENTORY_BLOCKERS` thiếu `RECALL_CASE_OPEN_STOP_SALE` `PublicSellableAvailabilityDisplayServiceImpl.java:28-31`, tệp catalog cũ của Phúc/Mạnh) · phiên chính chốt: thêm 1 dòng blocker (không sửa poller), giữ 3 dòng FE `src/api`, chạy `docker_tests.py --write` → coder vòng 2. Báo Phúc vì chạm tệp catalog của Phúc.
- 16/11 14:01 coder vòng 2: ĐẠT · patch 21 tệp +1327/−41 · thêm `RECALL_CASE_OPEN_STOP_SALE` vào `ACTIVE_INVENTORY_BLOCKERS` (`PublicSellableAvailabilityDisplayServiceImpl.java:31-32`; mã sinh ở `OpsCoreVerdictMapper.java:101-105`, `OpsCoreDisplaySource.java:70-72`, `SellableGateCommitCheckServiceImpl.java:197-199`) + ca đơn vị (đỏ trước) · `ci/docker-tests.txt` thêm 1 dòng, `--check` sạch 445 lớp · OpenAPI không áp dụng · Maven 20 lớp 334 chạy, chỉ 3 đỏ cũ ModuleBoundary · E2E thu hồi 2/2 xanh · vitest như vòng 1 · CHƯA CHẠY `ProductSellableAvailabilityRepositoryTest`, `WmsInventoryNullSafetyPostgresTest`. Giao verifier.
- 16/11 14:2x verifier: ĐẠT (chờ bộ đủ) · tự kiểm 6 tiêu chí tệp:dòng · Maven 20 lớp 334 (chỉ 3 đỏ cũ) · vitest inventory 80, gold_hour 277 · đột biến riêng 3/3 · `docker_tests.py --check` sạch · nit: ngăn nhập đầu trang có thể khoá thừa khi kho có link ngoài danh sách đã tải (máy chủ vẫn chặn đúng); `contracts/openapi/latest.json` chưa có `externallyManaged` · áp patch → commit `d8960e9b0`; Sheet 4 task Hoàn thành, tracking commit.

- 16/11 18:4x bộ đủ sóng (`kiem-song3` @ `d8960e9b0`): test khuôn 755 OK (bỏ qua 9) · vitest 9302/9355, chạy riêng lại chỉ còn `proxy.test.ts` (đỏ sẵn trên dev) và `legal-hold-real-spec-guard` (CRLF máy này); 2 tệp quá giờ chạy riêng 183/183 · ci-unit 36912 ca, đỏ 88 = 39 đỏ sẵn (`do-san-afb6d404c.txt`) + `StagingTestDataFlowPostgresTest:211` (đỏ cả trên `9a1970240`, trước sóng) + 48 ca của 35 lớp Postgres hỏng vì Docker Desktop bị dừng từ ngoài lúc 16:31 (mã 0x40010004, không phải phiên này) → bật lại Docker, chạy riêng 36 lớp: 35 xanh, chỉ còn `StagingTestDataFlow` · KẾT LUẬN: sóng không thêm ca đỏ. Gộp `origin/dev` `b2568a319` (19 commit Phúc) vào `toandeptrai` → `b4d4b1368` (xung đột 1 tệp `GO_SKU_DEMO.md` mục 1: giữ câu mới của dev + đường dẫn .99) + `d3d91686d` sửa `env.mau` khối `MAIL_*` (CI dev 43840925341 đỏ 2 ca khuôn) · bản gộp: khuôn 757 OK, `docker_tests.py --check` 459, vitest inventory/gold_hour/api 416/416, tsc 4 lỗi đỏ sẵn ngoài sóng, Maven vùng sóng 1668 ca chỉ đỏ `StagingTestDataFlow` (sẵn) + 2 ca `SkuMasterSeederWriteContractTest` từ M3-117 của Phúc (tệp trùng byte dev; ghi mục 7 bàn giao Phúc). Chưa push.

## Bước kế tiếp chính xác
Bộ đủ sóng ĐẠT 16/11 18:4x; Lead duyệt Đạt M3-150/159/152/135 (sheet_lead verified 4, 18:4x); gộp dev → `d3d91686d` (chưa push) · chờ Toàn duyệt push + PR vào `dev`

## Còn lại / CẦN QUYẾT
- (trống)
