# script-99 — gói 7 (gộp gói 3 `ton-sua`): 3 script M12↔M3 chạy được trên bố cục .99, làm tròn xuống tồn lẻ, runbook sang .99

Trạng thái: XONG `95ebd81dd` (chưa push) · verifier ĐẠT · bộ đủ sóng ĐẠT 18:4x, gộp dev `d3d91686d` · base `9a1970240` · Rủi ro: R2 · Chế độ: A (worktree tách rời → patch → phiên chính áp + commit `toandeptrai`) · Mốc: 18/11
Hạng mục nâng: script nạp link / đồng bộ tồn / gỡ SKU demo từ "chỉ chạy được bố cục .60" → "chạy được .99, chặn sai máy, có test bố cục .99" · Sheet: M3-129, M3-122, M3-157 · Ước lượng: 2 giờ
Chỗ làm: `C:\Projects\_wt\m34\script-99` · Base SHA: `9a1970240` · Patch: `C:\Projects\_wt\m34\script-99.patch`
Nguồn: phiếu `SUA-SAU-RA-SOAT-NKB.md` gói 3 + 7; note Cần sửa M3-129 (`ra-soat/evidence/2026-11-14-nkb/ket-qua.json`), M3-122, M3-157 (`…/2026-11-14-nm3-26/ket-qua.json`); D-m34-074 (đính chính 20:26), D-m34-063 (6).

## Brief
1. Repo `C:\Projects\ginsengfood-business-platform` (chỉ đọc) · làm trong `C:\Projects\_wt\m34\script-99` (HEAD tách `9a1970240`) · luật chung `C:\Projects\_wt\m34\_tools\BRIEF_CHUNG_SUA_NKB.md` (đọc trước; thay base = `9a1970240`).
2. Mục tiêu và tiêu chí đạt:
   (a) `deploy/m34/ops-core/dong-bo-ton.py` (M3-129, D-m34-074 đính chính): tồn M12 lẻ (không nguyên theo hộp/thùng) **làm tròn xuống** số nguyên, KHÔNG bỏ qua cặp, KHÔNG đếm là dòng xấu
       (hiện `test_17` giữ 40 khi M12 = 3,5 và đếm dòng xấu, >3 dòng xấu dừng cả lượt). Sửa `test_17`; thêm ca 0,5 → 0 và 3,5 → 3; ghi số dòng đã làm tròn vào tổng kết (không in dữ liệu khách).
       Sửa bảng mã dừng trong `DONG_BO_TON.md` cho khớp.
   (b) Guard chung cho bố cục .99 ở cả `dong-bo-ton.py`, `nap-link.sh` (M3-122), `go-sku-demo.sh` (M3-157): thư mục `/data/ginsengfood-business-platform`, project compose `m34`
       (container `m34-*`), người chạy `ssv` (home `/home/ssv`), CHẶN `root`. Hiện guard đòi HOME là thư mục cha của `M34_HOME` và project = tên thư mục → chạy trên .99 bị chặn.
       Giữ chặn sai máy/sai thư mục (đường lui .60 chỉ khi đặt rõ biến); ghi lý do mỗi điều kiện ngay trong mã. Dùng chung một cách kiểm cho 3 script nếu gọn (không bắt buộc cùng tệp).
       Test bố cục .99 cho cả 3 script: ca đúng .99 chạy qua guard; ca `root`, sai thư mục, sai project bị chặn đúng mã thoát/thông điệp.
   (c) `DONG_BO_TON.md`, `NAP_LINK.md`, `GO_SKU_DEMO.md` sang .99: đường dẫn, dòng cron mẫu .99 (dong-bo-ton), project `m34`; .60/.61 chỉ còn là đường lui; ghi m34.1/m34.2 đã chốt theo D-m34-063 (6)
       (grep `C:\Projects\Project Control\modules\m34\QUYET_DINH.md` dòng D-m34-063). Không ghi bí mật, số điện thoại, dữ liệu khách.
   (d) KHÔNG chạy trên .99 (chạy khô .99 là bước riêng Toàn duyệt sau khi M12 bản mới lên — gói 11). Ghi `CHƯA CHẠY` trong đầu ra.
3. Phạm vi ghi: `deploy/m34/ops-core/dong-bo-ton.py`, `nap-link.sh`, `go-sku-demo.sh`, `DONG_BO_TON.md`, `NAP_LINK.md`, `GO_SKU_DEMO.md`, `deploy/m34/tests/test_dong_bo_ton.py`,
   `test_nap_link.py`, `test_go_sku_demo.py` (+ tệp test/helper mới trong `deploy/m34/tests/` nếu cần). CẤM: mọi tệp ngoài danh sách (đặc biệt `compose*.yml`, `env.mau`, `m8-that/**`,
   `back-end/**`, `front-end/**`, `NOI_M12.md`, `SKU_MOI.md`), ssh/scp thật, docker trên máy thật.
4. Đọc trước: 3 script + 3 runbook + 3 tệp test hiện có; `C:\Projects\Project Control\chung\MAY_CHU.md` (chỉ đọc, mục .99); hợp đồng M12 chỉ đọc theo luật chung (đơn vị tồn, số lẻ).
5. Lệnh kiểm nhanh: theo luật chung — chép `deploy/` sang thư mục tạm mới rồi `python -m unittest deploy.m34.tests.test_dong_bo_ton deploy.m34.tests.test_nap_link deploy.m34.tests.test_go_sku_demo`
   (ca Postgres thật dùng Testcontainers một-lần nếu test sẵn có làm vậy; không đụng container sẵn có). Script có ssh/scp: stub qua PATH giả, kiểm `type -P ssh` trỏ stub.
6. Bằng chứng: patch; số ca từng tệp test (trước/sau); lần đỏ trước khi sửa cho (a) và (b); đột biến ≤ 3 (bỏ làm tròn xuống → ca 3,5 đỏ; bỏ chặn root → ca root đỏ; bỏ kiểm project → ca sai project đỏ).
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`.
8. Đầu ra ≤ 25 dòng theo brief chung; báo cáo dài `C:/Projects/_wt/m34/script-99-bao-cao.md`.

## Diễn biến
- 16/11 10:04 tạo worktree `_wt/m34/script-99` (`74de1cd0b`), giao coder (song song `test-bo-sung`).

- 16/11 10:0x Toàn đổi việc (D-lead-051 → D-m34-088): dừng coder ở điểm sạch; coder chưa sửa tệp nào, patch rỗng → xoá; worktree sạch → gỡ. Báo cáo cho Phúc làm tiếp: `C:/Projects/_wt/m34/script-99-bao-cao.md` (thiết kế, tệp:dòng). 10:4x Toàn đính chính (D-m34-091): gói vẫn của Toàn, không chuyển Phúc.

- 16/11 12:36 Toàn "Chạy lại": tạo lại worktree `_wt/m34/script-99` (`9a1970240`, đã gộp dev), giao coder kèm báo cáo thiết kế `_wt/m34/script-99-bao-cao.md`; chốt thay 4 điểm CẦN QUYẾT theo đề xuất (làm tròn xuống trên tổng cặp SKU+kho; project cố định `m34`; HOME `/home/<user>`; mặc định bố cục .99, .60 chỉ khi đặt rõ `M34_HOST_IP` + `M34_HOME`); cho sửa dòng gọi 3 script trong `CHUYEN_MAY_99.md`, `NOI_M12.md`, `SKU_MOI.md`.
- 16/11 12:57 coder lượt 2: ĐẠT · patch 11 tệp +489/−169: 3 script + 3 runbook + `CHUYEN_MAY_99.md:56-58` + 3 test + `deploy/m34/tests/ca_guard_99.py` (16 ca guard chung) · (a) làm tròn xuống trên tổng cặp, `TONG_KET` thêm `lam_tron=N` · (b) guard .99 mặc định, .60 cần đủ `M34_HOST_IP` + `M34_HOME`, project `m34`, HOME `/home/<user>`, chặn root (tên/uid 0/`M34_USER`), khối guard bash giống byte ở 2 script có test so · test: dong_bo_ton 52→56 (1 bỏ qua uid trên Windows), nap_link 47→48, go_sku_demo 26→28, test_compose 54, test_khuon 28 OK · đỏ trước đúng lý do (a)(b) · đột biến 3/3 · `NOI_M12.md`/`SKU_MOI.md` không có dòng phải sửa · CHƯA CHẠY .99. Giao verifier.
- 16/11 13:1x verifier: ĐẠT (chờ bộ đủ) · tự so khối guard 2 script giống nhau, thử 17 cách đi vòng đều bị chặn · số chạy lại khớp coder · đột biến riêng 3/3 đỏ · patch trùng byte · nit không chặn: `test_32` nên đặt thêm `M34_HOME`; bảng mã dừng `DONG_BO_TON.md` thiếu `TEP_BI_MAT` (có từ trước) · áp patch → commit `95ebd81dd` trên `toandeptrai` (chưa push).

- 16/11 18:4x bộ đủ sóng (`kiem-song3` @ `d8960e9b0`): test khuôn 755 OK (bỏ qua 9) · vitest 9302/9355, chạy riêng lại chỉ còn `proxy.test.ts` (đỏ sẵn trên dev) và `legal-hold-real-spec-guard` (CRLF máy này); 2 tệp quá giờ chạy riêng 183/183 · ci-unit 36912 ca, đỏ 88 = 39 đỏ sẵn (`do-san-afb6d404c.txt`) + `StagingTestDataFlowPostgresTest:211` (đỏ cả trên `9a1970240`, trước sóng) + 48 ca của 35 lớp Postgres hỏng vì Docker Desktop bị dừng từ ngoài lúc 16:31 (mã 0x40010004, không phải phiên này) → bật lại Docker, chạy riêng 36 lớp: 35 xanh, chỉ còn `StagingTestDataFlow` · KẾT LUẬN: sóng không thêm ca đỏ. Gộp `origin/dev` `b2568a319` (19 commit Phúc) vào `toandeptrai` → `b4d4b1368` (xung đột 1 tệp `GO_SKU_DEMO.md` mục 1: giữ câu mới của dev + đường dẫn .99) + `d3d91686d` sửa `env.mau` khối `MAIL_*` (CI dev 43840925341 đỏ 2 ca khuôn) · bản gộp: khuôn 757 OK, `docker_tests.py --check` 459, vitest inventory/gold_hour/api 416/416, tsc 4 lỗi đỏ sẵn ngoài sóng, Maven vùng sóng 1668 ca chỉ đỏ `StagingTestDataFlow` (sẵn) + 2 ca `SkuMasterSeederWriteContractTest` từ M3-117 của Phúc (tệp trùng byte dev; ghi mục 7 bàn giao Phúc). Chưa push.

## Bước kế tiếp chính xác
Bộ đủ sóng ĐẠT 16/11 18:4x; gộp dev → `d3d91686d` (chưa push) · chờ Toàn duyệt push + PR vào `dev` → chạy khô 3 script trên .99 (Toàn duyệt ssh)

## Còn lại / CẦN QUYẾT
- (trống)
