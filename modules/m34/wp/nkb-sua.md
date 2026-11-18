# nkb-sua — giữ/nhả thử lại đúng 1 lần + trần 20 dòng/đơn (M3-132, NM3-40)

Trạng thái: ĐÃ GỘP (Toàn "Ok gộp" 15/11, `e5e5790e2`, chưa push) · Rủi ro: R3 (giữ hàng, đơn) · Chế độ: A (worktree tách rời → patch → phiên chính áp + commit trên `toandeptrai`) · Mốc: cổng NK-b 20/11
Hạng mục nâng: NK-b giữ/nhả ở M12, xong mã có lệch kế hoạch → xong mã đúng kế hoạch · Sheet: M3-132 · Ước lượng: 2–3 giờ
Chỗ làm: `C:\Projects\_wt\m34\nkb-sua` · Base SHA: `afb6d404c` · Patch: `C:\Projects\_wt\m34\nkb-sua.patch` · Chỗ kiểm: worktree `kiem-nkb-sua` (tạo khi coder xong)
Nguồn: rà 14/11 (`ra-soat/evidence/2026-11-14-nkb/auditor-a.md` mục 1), D-m34-077, D-m34-078, phiếu `SUA-SAU-RA-SOAT-NKB.md` gói 1.

## Brief
1. Repo `C:\Projects\ginsengfood-business-platform` (chỉ đọc) · làm trong `C:\Projects\_wt\m34\nkb-sua` (HEAD tách `afb6d404c`) · luật chung: `C:\Projects\_wt\m34\_tools\BRIEF_CHUNG_SUA_NKB.md` (đọc trước).
2. Mục tiêu và tiêu chí đạt:
   (a) D-m34-077: giữ/nhả hàng ở M12 khi gặp 408/502/503/504/timeout thử lại ĐÚNG MỘT lần cùng khoá idempotency + cùng thân (phụ lục B kế hoạch nối, dòng ~625).
       Hiện `OpsCoreReservationConfig.java:89-90` truyền `client.retry().maxAttempts()` (= `app…ops-core.retry.max-attempts`, `application.yml:248`, mặc định 2,
       là số lần gửi THÊM) → chạy thật tới 3 lần; test `…OneExtraTry` dựng adapter tay với 1 nên không kiểm cấu hình thật.
       Làm: khoá cấu hình RIÊNG cho giữ/nhả, đặt trong khối `allocation` của `application.yml`: `transient-retries: ${OPS_CORE_ALLOCATION_TRANSIENT_RETRIES:1}`
       (số lần gửi thêm, mặc định 1; giá trị hỏng/âm/quá 3 → dùng 1 kèm một ERROR nêu tên khoá, theo kiểu khoá mềm sẵn có; không dùng chung `retry.max-attempts`
       của client, khoá đó giữ nguyên cho /check, token…). Backoff giữ như hiện tại.
       Test DÂY NỐI (Spring context hoặc binder đọc `application.yml` thật, đặt ở `opscorecontract`, ví dụ mở rộng `OpsCoreReservationWiringTest`): ở cấu hình mặc định,
       một lần giữ gặp 503 rồi 503 → đúng 2 lần gửi (1 + 1), cùng `Idempotency-Key` + cùng thân; gặp 503 rồi 201 → thành công sau 2 lần. Ca nhả tương tự (1 ca đủ).
   (b) D-m34-078: trần số dòng mỗi đơn khi giữ ở M12, cấu hình được: khối `allocation` thêm `max-lines-per-order: ${OPS_CORE_ALLOCATION_MAX_LINES_PER_ORDER:20}`
       (1..100; hỏng → 20 kèm một ERROR). Đơn quá trần bị từ chối 422 với mã lỗi rõ (gợi ý `ORDER_HOLD_TOO_MANY_LINES`, cùng kiểu `ORDER_HOLD_LINE_QUANTITY_EXCEEDED`
       ở `OrderHoldQuotaServiceImpl`) **trước khi** gọi M12 và **trước khi ghi sổ giữ** (`ops_core_reservations`); áp cả khi `quota.enabled=false` (trần này bảo vệ
       ngân sách 7 s, không phải hạn ngạch). Chỉ áp khi giữ hàng ở M12 bật (`allocation.enabled`); cờ tắt thì hành vi tạo đơn cũ không đổi.
       Test: biên 20 dòng qua, 21 dòng bị 422 đúng mã và 0 lần gọi M12, 0 dòng sổ; đơn 20 dòng với M12 giả trả 201 ngay xong trong ngân sách
       `commit.max-total` 7 s với bộ hạn tốc thật mặc định (allocation 5/s, burst 10) — đo thời gian thật trong test, khẳng định < 7 s (và in số đo).
   (c) Ghi chú cấu hình: thêm 2 dòng env vào `deploy/m34/compose.yml` NGAY SAU dòng `OPS_CORE_ALLOCATION_QUOTA_MAX_LINE_QUANTITY` và 2 dòng vào
       `deploy/m34/env.mau` NGAY SAU dòng `OPS_CORE_ALLOCATION_QUOTA_MAX_LINE_QUANTITY=100` (kèm một dòng chú thích tiếng Việt). Test compose cho 2 khoá này đặt
       trong tệp MỚI `deploy/m34/tests/test_compose_giu_hang.py` (không sửa `test_compose.py`: gói khác đang sửa).
3. Phạm vi ghi: `OpsCoreReservationConfig.java`, `OpsCoreReservationHttpAdapter.java`, lớp properties của allocation (record `allocation()`), `OrderHoldQuotaServiceImpl.java`
   hoặc chỗ gọi giữ trong `OrderCreateServiceImpl.java` (chỉ đoạn kiểm trần, ít dòng nhất có thể — tệp lõi của Phúc), `application.yml` (CHỈ khối `allocation`),
   `compose.yml`/`env.mau` (chỉ chỗ neo ở 2c), test liên quan + tệp test mới. CẤM: `OpsCoreConfigRules.java`, `OpsCoreHttpClient.java`, `OpsCoreTokenCache.java`,
   `deploy/m34/tests/test_compose.py`, khối `lifecycle`/`base-url` của `application.yml` (gói `cau-hinh` đang sửa), migration (không cần migration).
   Nếu `OpsCoreConfigYamlTest`/`OpsCoreNoHardcodedValuesTest` đòi đăng ký khoá mới thì sửa đúng chỗ đó (được phép).
4. Đọc trước: `OpsCoreReservationConfig.java`, `OpsCoreReservationHttpAdapter.java` (javadoc dòng ~91), `OpsCoreReservationServiceImpl.java` (ghi sổ trước khi gửi, 187-255),
   `OrderHoldQuotaServiceImpl.java`, `OrderCreateServiceImpl.java:1337-1382`; kế hoạch nối phụ lục B (bảng lỗi) + §16.3; `auditor-a.md` mục 1 ở trên.
5. Lệnh kiểm nhanh: Maven qua khoá, `-P ci-unit -Dtest='OpsCoreReservationHttpAdapterTest,OpsCoreReservationServiceTest,OpsCoreReservationWiringTest,OrderHoldQuotaServiceImplTest,OpsCoreConfigYamlTest,OpsCoreNoHardcodedValuesTest,OpsCoreAllocationEnvNameTest,<lớp mới>'`
   + `OrderCreateServiceImplStockHoldTest` nếu sửa `OrderCreateServiceImpl`; Python `test_compose_giu_hang.py`; cuối cùng một lần `ModuleBoundaryArchitectureTest,OpsCoreModuleBoundaryTest`
   (ModuleBoundary đang đỏ 3/15 sẵn — chỉ so: không thêm vi phạm mới). Bộ kiểm đủ: chỉ phiên chính, cuối sóng. KHÔNG chạy `-P ci-integration` trừ `OpsCoreReservationLedgerPostgresTest` nếu đổi chỗ ghi sổ.
6. Bằng chứng: patch; số test từng lớp; lần đỏ trước khi sửa (tên ca); số đo thời gian đơn 20 dòng; đột biến ≤ 3 (vd. đổi mặc định 1→2, bỏ kiểm trần, kiểm trần sau ghi sổ) bị bắt.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`.
8. Đầu ra ≤ 25 dòng theo brief chung.

## Diễn biến
- 14/11 22:26 giao coder v1 (nền).
- 14/11 22:59 coder v1: ĐẠT · patch 14 tệp +722/−15 (main: `OpsCoreReservationConfig`, `OrderHoldQuotaService(Impl)`, `OrderCreateServiceImpl` +1 dòng, `application.yml` khối allocation; 2 javadoc) · khoá `allocation.transient-retries` (0..3, mặc định 1), `allocation.max-lines-per-order` (1..100, mặc định 20) → 422 `ORDER_HOLD_TOO_MANY_LINES` trước quota/giữ · đỏ trước 12 ca ("expected 2 but was 3") → 224 ca, 221 đạt, 3 hỏng = ModuleBoundary đỏ sẵn (51+2 cũ, không thêm) · đơn 20 dòng 2014 ms · Python `test_compose_giu_hang` 4/4; `test_compose.py` 45/47 sau patch (thiếu 2 tên trong `TEN_BIEN`) · đột biến 3/3.
- 14/11 23:00 chỗ kiểm `_wt/m34/kiem-nkb-sua` = `afb6d404c` + patch (commit tách rời `4f43dbb1e`, không nhánh); giao tester độc lập (R3).
- 14/11 23:23 tester độc lập: ĐẠT · patch `nkb-sua-tester.patch` 4 tệp test mới (+1334): `NkbSuaFakes`, `NkbSuaRetryIndependentTest` 40, `NkbSuaLineCapIndependentTest` 12, `OrderHoldLineCapIndependentTest` 14 → 66/66 xanh trên mã coder · đơn 20 dòng 2011 ms · đếm dòng theo `OrderItem` (trước gộp SKU) · trần kiểm trước hạn ngạch (21 dòng khi hết suất IP vẫn 422) · không đọc test của coder · ghi nhận: 429 không trả lại lượt thử lại; ERROR trần dòng mang tiền tố `ORDER_HOLD_QUOTA_CONFIG_INVALID`.
- giao verifier (chỗ kiểm `kiem-nkb-sua`, đã có test của tester chưa commit).
- 14/11 23:58 verifier: ĐẠT (chờ bộ đủ + Toàn duyệt diff) · 14 lớp 275/275 (coder + tester) · đơn 20 dòng 2008 ms · `test_compose_giu_hang` 4/4, `test_compose` 45/47 → 47/47 khi thêm 2 tên `TEN_BIEN` · `OrderStockHoldPort.hold` chỉ 1 chỗ gọi (`OrderCreateServiceImpl:1372`), mọi lối tạo đơn khách/admin qua `:415→:665`, Giờ Vàng `reserveInventory=false` · đột biến 4/4 (`>`→`>=`, khoá đọc nhầm `retry.max-attempts`, trần khi cờ tắt, giá trị hỏng về 100).
- 15/11 00:01 chỗ ghép thử `_wt/m34/kiem-song` = `toandeptrai` `24c84a409` + `nkb-sua.patch` (3-way sạch) + `nkb-sua-tester.patch` + 2 tên `TEN_BIEN` → commit tách rời `771667637`. Bộ đủ tầng 3: deploy/m34 Linux (python:3.12-slim, như CI) **584 ca OK, 97 bỏ qua**; Maven `ci-unit` đủ + 3 lớp Postgres giữ hàng đang chạy nền.
- 15/11 01:54 bộ đủ tầng 3 xong trên `771667637`: `ci-unit` 34301 ca, đỏ 39 ca / 21 lớp = **trùng đúng tên 39 ca đỏ sẵn trên `afb6d404c`** (chạy lại 21 lớp ở `_wt/m34/kiem-goc`, so tên từng ca: 0 ca mới, 0 ca mất); mọi lớp OpsCore/giữ hàng/NkbSua/OrderHold xanh (vd `NkbSuaRetryIndependentTest` 40, `NkbSuaLineCapIndependentTest` 12, `OrderHoldLineCapIndependentTest` 14, `OrderHoldQuotaServiceImplTest` 42, `OpsCoreReservationHttpAdapterTest` 55); `ci-integration` `OrderHoldQuotaPostgresTest` 4 + `OpsCoreReservationLedgerPostgresTest` 10 + `OpsCoreOrderHoldRollbackPostgresTest` 4 = 18/18 xanh. Chờ Toàn "ok gộp".

- 15/11 06:38 Toàn "Ok gộp": áp diff `24c84a409..771667637` lên checkout `toandeptrai` (index khớp `771667637` từng byte, 19 tệp), commit `e5e5790e2` + nhật ký tuần `676df3209`; Sheet `sheet-sync log` M3-132 Chờ review (đã đồng bộ). Chưa push.

## Bước kế tiếp chính xác
Xong phần mã. Push khi Toàn lệnh; image mới lên .99 trước khi bật giữ hàng NK-b (gói 11). Gỡ worktree `nkb-sua`, `kiem-nkb-sua`, `kiem-song` lúc dọn.

## Còn lại / CẦN QUYẾT
- Phiên chính thêm 2 tên `OPS_CORE_ALLOCATION_TRANSIENT_RETRIES`, `OPS_CORE_ALLOCATION_MAX_LINES_PER_ORDER` vào `TEN_BIEN` của `deploy/m34/tests/test_compose.py` (sau `…QUOTA_MAX_LINE_QUANTITY`) lúc gộp gói này; tầng 3 kiểm.
- Khoá mới cũng áp cho đọc danh sách của job đối soát (cùng adapter): 2 → 1 lần gửi lại. Chấp nhận (cùng phụ lục B).
- Tài liệu `README.md` 12.3, `NOI_M12.md`, `THIET_KE.md`: gói `tai-lieu` (9). Câu chữ FE mã 422 mới: gói sau.
- Câu chữ FE cho mã 422 mới (`opsCoreErrorMessages.ts`) chưa trong gói này: đơn 21 dòng hiện câu lỗi chung. Thêm ở gói `test-bo-sung` hoặc gói FE sau.
