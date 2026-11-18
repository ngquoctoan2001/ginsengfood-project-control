# kien-truc — `ModuleBoundaryArchitectureTest` xanh 15/15 (D-m34-079)

Trạng thái: TẠM DỪNG 15/11 (nhánh chú Dũng `0f1162b9e` đã làm cùng mục tiêu, nằm trong nhánh gộp `4a8e2d1e3`; chờ phiên lead chốt gộp; tin nháp Phúc/Tài không gửi) · Rủi ro: R2 · Chế độ: A (worktree → patch → phiên chính áp + commit `toandeptrai`)
Mốc: trước bật cờ giữ hàng NK-b (≥ 20/11), hạn 18/11 · Hạng mục nâng: cổng kiến trúc đỏ 3/15 → xanh, không nới luật · Sheet: tạo task mới khi giao · Ước lượng: 3 giờ
Chỗ làm: `C:\Projects\_wt\m34\kien-truc` · Base SHA: commit cuối `toandeptrai` lúc giao · Patch: `C:\Projects\_wt\m34\kien-truc.patch` · Chỗ kiểm: `kiem-kien-truc`
Nguồn: rà 14/11 (`ra-soat/evidence/2026-11-14-nkb/auditor-a.md` mục 3 "Giới hạn"), D-m34-079.

## Brief
1. Repo `C:\Projects\ginsengfood-business-platform` (chỉ đọc) · làm trong `C:\Projects\_wt\m34\kien-truc` · luật chung `C:\Projects\_wt\m34\_tools\BRIEF_CHUNG_SUA_NKB.md`.
2. Mục tiêu: `ModuleBoundaryArchitectureTest` xanh 15/15 ở chế độ thường (`allowStoreCreation=false`, `allowStoreUpdate=false`), không nới luật, không thêm ngoại lệ mới.
   Đỏ hiện tại (rà 14/11, SHA `e8e3e5e13`): 51 vi phạm ở test VNPAY/Giờ Vàng (`OldUrlTesterT1PostgresTest`, `OldUrlTesterT1Test`, `GoldenHourPaymentGateServiceImplTest`),
   2 ở test catalog (`SkuLifecycleAuditLogPostgresTest`, `SkuLifecycleRealEventPipelinePostgresTest`), và kho đóng băng Flow→Flow có dòng cũ
   (`promotion.GoldenHourReservationServiceImpl`, sau `08def7a14`) làm cổng văng `StoreUpdateFailedException`.
   Tiêu chí: (a) vi phạm MỚI ở test → sửa test cho đúng ranh giới (dùng `port.in`/lớp công khai, hoặc chuyển test chéo module sang gói `opscorecontract`/fixture được duyệt),
   KHÔNG đổi hành vi được kiểm, số ca mỗi lớp giữ nguyên; (b) dòng đóng băng đã hết vi phạm thật → co kho theo đúng quy trình re-baseline trong
   `back-end/src/test/resources/archunit.properties` (bật tạm `allowStoreUpdate=true` + `-Dfnd005.archunit.rebaseline.confirmed=true`, xem diff kho chỉ XOÁ dòng, trả cấu hình
   về false); kho KHÔNG được thêm dòng; (c) mã chạy (`src/main`) không đổi, trừ khi một vi phạm chỉ sửa được ở main → dừng, `CẦN QUYẾT`.
3. Phạm vi ghi: các tệp test ở mục 2 (thuộc phần Tài và Phúc: đã báo trước), `src/test/resources/architecture/boundary-violation-store/**` (chỉ co), fixture test mới nếu cần.
   CẤM: `src/main/**`, `archunit.properties` (chỉ bật tạm khi re-baseline, trả lại nguyên văn), `ModuleBoundaryArchitectureTest.java` (luật), test của gói khác trong sóng.
4. Đọc trước: javadoc `ModuleBoundaryArchitectureTest.java` (dòng 1–140, quy trình FND-005), `archunit.properties`, các test ở mục 2; `git log -3` từng tệp test.
5. Lệnh kiểm nhanh: Maven qua khoá `-P ci-unit -Dtest='ModuleBoundaryArchitectureTest,OpsCoreModuleBoundaryTest'` + các lớp test đã sửa (Postgres: `-P ci-integration -Dtest=<lớp>` chỉ cho
   lớp `*PostgresTest` đã sửa, Testcontainers dùng một lần, dọn sạch). Bộ kiểm đủ: chỉ phiên chính cuối sóng.
6. Bằng chứng: patch; đỏ trước (số vi phạm từng luật) / xanh sau 15/15; số ca từng lớp test đã sửa trước = sau; diff kho chỉ có dòng xoá; 1 đột biến: thêm tạm một phụ thuộc Flow→Flow
   mới trong một test → cổng đỏ; trả lại.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`.
8. Đầu ra ≤ 25 dòng theo brief chung.

## Diễn biến
- 14/11 22:27 soạn phiếu + tin báo Phúc/Tài; chờ Toàn gửi.
- 15/11 07:2x rà chỉ đọc nhánh chú Dũng (`ra-soat/2026-11-15-chudung.md`): `sua-loi-kiem-tra-cau-truc` `0f1162b9e` sửa đúng 4 nhóm lỗi, co kho đóng băng 42 dòng, không nới luật; nhưng sửa `src/main` (`GoldenHourPaymentGatePort.java:42` + 2 service thanh toán của Tài) và dời test sang gói gốc. Đề xuất phiên lead: dừng giao coder; sau khi nhánh gộp vào dev chỉ kiểm 15/15 trên dev + `toandeptrai`.

## Bước kế tiếp chính xác
Phiên lead chốt gộp nhánh gộp chú Dũng → kiểm `ModuleBoundaryArchitectureTest` 15/15 trên dev + `toandeptrai`; còn đỏ thì mới giao coder phần sót. Nhánh không gộp → quay lại phiếu này (giao coder như cũ).

## Còn lại / CẦN QUYẾT
- (trống)
