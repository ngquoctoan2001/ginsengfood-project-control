# cau-hinh — chặn cờ Giờ Vàng NK-c, nối cờ vòng đời + allowlist host, id tương quan ở log lỗi (M3-135, M3-149, M3-159, M3-126)

Trạng thái: XONG PHẦN MÃ (bộ đủ xanh 15/11; 4 task còn phần .99/tài liệu/E2E ở gói 8/9/11) · Rủi ro: R2 · Chế độ: A (worktree tách rời → patch → phiên chính áp + commit `toandeptrai`) · Mốc: 17/11
Hạng mục nâng: cấu hình nối M12 trên .99 bật được đúng cách, không có cờ mở nhầm chặn Giờ Vàng · Sheet: M3-135, M3-149, M3-159, M3-126 · Ước lượng: 2 giờ
Chỗ làm: `C:\Projects\_wt\m34\cau-hinh` · Base SHA: `afb6d404c` · Patch: `C:\Projects\_wt\m34\cau-hinh.patch` · Chỗ kiểm: `kiem-cau-hinh`
Nguồn: rà 26 task 14/11 (`ra-soat/evidence/2026-11-14-nm3-26/auditor-*.md`, `ket-qua.json`), D-m34-066(c), D-m34-080(d), phiếu `SUA-SAU-RA-SOAT-NKB.md` gói 6.

## Brief
1. Repo `C:\Projects\ginsengfood-business-platform` (chỉ đọc) · làm trong `C:\Projects\_wt\m34\cau-hinh` (HEAD tách `afb6d404c`) · luật chung `C:\Projects\_wt\m34\_tools\BRIEF_CHUNG_SUA_NKB.md`.
2. Mục tiêu và tiêu chí đạt:
   (a) M3-135: hiện bật `app.inventory.ops-core.golden-hour-allocation.enabled=true` là mở chặn Giờ Vàng khi ENFORCE (`GoldenHourReservationServiceImpl.java` ~dòng 205:
       `if (opsCoreGateEnforced && !opsCoreGoldenHourAllocationEnabled)`), dù mã giữ hàng Giờ Vàng ở M12 (NK-c, P1) chưa có → chỉ giữ ở sổ M3. Theo P2 đã chốt (D-m34-066 c):
       - `OpsCoreConfigRules`: `golden-hour-allocation.enabled=true` là vi phạm (như tiền lệ `allocation.release.enabled` bị từ chối khi adapter chưa có, T-831 §3.8.9), thông điệp nêu
         "NK-c chưa có"; cập nhật javadoc lớp.
       - `GoldenHourReservationServiceImpl`: khi gate ENFORCE thì luôn chặn 409 `GOLDEN_HOUR_OPS_CORE_HOLD_NOT_READY` bất kể cờ golden-hour-allocation (sửa ít dòng nhất; giữ setter
         để NK-c sau này dùng lại; ghi chú vì sao). Cờ ENFORCE tắt → hành vi cũ.
       - Test: rules từ chối cờ bật (và cho qua khi tắt); service ENFORCE + cờ bật vẫn 409, không ghi gì (dùng test sẵn có của M3-135, tìm `GOLDEN_HOUR_OPS_CORE_HOLD_NOT_READY` trong src/test).
   (b) M3-149 + M3-159: nối cấu hình để bật được trên .99, mặc định TẮT/giữ hành vi:
       - `application.yml`: khối `lifecycle` (enabled/enforce/interval… đúng tên Java đang đọc, xem `OpsCoreConfigRules`, `OpsCoreSkuLifecycleHttpAdapter`, poller vòng đời) với env
         `OPS_CORE_LIFECYCLE_ENABLED` (false), `OPS_CORE_LIFECYCLE_ENFORCE` (false), `OPS_CORE_LIFECYCLE_INTERVAL` (mặc định đang dùng trong mã); `base-url-allowed-hosts: ${OPS_CORE_BASE_URL_ALLOWED_HOSTS:}`
         (chuỗi phân cách dấu phẩy, rỗng = như hiện tại). KHÔNG sửa khối `allocation` (gói `nkb-sua` đang sửa).
       - `deploy/m34/compose.yml`: thêm các dòng env trên NGAY SAU dòng `OPS_CORE_CLIENT_ID: …` (không chèn quanh khối `OPS_CORE_ALLOCATION_*`).
       - `deploy/m34/env.mau`: thêm NGAY SAU dòng `OPS_CORE_CLIENT_ID=SVC-M3-SELLABLE`, có chú thích tiếng Việt: vòng đời mặc định tắt, bật an toàn = `ENABLED=true`, `ENFORCE=false`
         một vòng đối soát trước; allowlist trên .99 = `192.168.1.99`.
       - `deploy/m34/tests/test_compose.py`: ca khẳng định compose đưa đủ các biến này vào be với mặc định tắt/rỗng.
       - Test Java khẳng định binder đọc được các khoá từ `application.yml` (mở rộng `OpsCoreConfigYamlTest` hoặc tương đương) và allowlist "192.168.1.99" bind thành danh sách 1 phần tử.
   (c) M3-126: thêm `m3CorrelationId={}` (đúng id `m3-<UUID>` đã gửi trong header `X-Correlation-Id` của lần gọi đó) vào `OPS_CORE_CALL_RETRY` (`OpsCoreHttpClient.java:262`),
       `OPS_CORE_CALL_UNAVAILABLE` (`:291`), `OPS_CORE_TOKEN_FAILED reason=NETWORK` (`OpsCoreTokenCache.java:166`); test bắt log (theo cách các test log sẵn có trong gói opscore) khẳng định id
       trong log = id trong header.
3. Phạm vi ghi: `OpsCoreConfigRules.java`, `GoldenHourReservationServiceImpl.java` (chỉ đoạn chặn), `OpsCoreHttpClient.java`, `OpsCoreTokenCache.java`, `OpsCoreClientProperties.java` nếu cần bind,
   `application.yml` (khối lifecycle + base-url-allowed-hosts), `compose.yml`, `env.mau` (chỉ chỗ neo ở 2b), `test_compose.py`, test liên quan.
   CẤM: khối `allocation` của `application.yml`, `OpsCoreReservationConfig.java`, `OpsCoreReservationHttpAdapter.java`, `OrderHoldQuotaServiceImpl.java`, `OrderCreateServiceImpl.java`,
   `deploy/m34/tests/test_compose_giu_hang.py`, `opscorecontract/OpsCoreHoldYamlDefaultsTest.java` (gói `nkb-sua`); kho đóng băng ArchUnit (gói `kien-truc`); FE.
   Tệp chung với gói `nkb-sua` (phiên chính gộp tay nếu va): `OpsCoreConfigYamlTest.java` (gói 1 đã đăng ký 2 khoá allocation → bạn thêm khoá lifecycle/allowlist
   ở chỗ khác trong tệp, không sửa dòng allocation); `test_compose.py`: tên biến mới của bạn trong `TEN_BIEN` đặt ngay sau `"OPS_CORE_CLIENT_ID"` (phiên chính tự thêm
   2 tên của gói 1 khi gộp).
4. Đọc trước: các tệp ở mục 3; `deploy/m34/README.md` mục 12 (bí mật tệp); `docs` NOI_M12 không sửa (gói tài liệu sau).
5. Lệnh kiểm nhanh: Maven qua khoá `-P ci-unit -Dtest='OpsCoreConfigValidatorTest,OpsCoreConfigYamlTest,OpsCoreNoHardcodedValuesTest,OpsCoreCorrelationIdTest,OpsCoreHttpClientTest,OpsCoreTokenCacheTest,<test Giờ Vàng chặn>,<lớp mới>'`
   (tên lớp có thể khác: tìm đúng lớp), Python `test_compose.py`; cuối cùng một lần `ModuleBoundaryArchitectureTest,OpsCoreModuleBoundaryTest` (đang đỏ 3/15 sẵn — chỉ so: không thêm vi phạm).
   Bộ kiểm đủ: chỉ phiên chính cuối sóng. Không Testcontainers.
6. Bằng chứng: patch; số test từng lớp; lần đỏ trước khi sửa; đột biến ≤ 3 (bỏ luật từ chối cờ; bỏ id ở một dòng log; đổi mặc định lifecycle sang true) bị bắt.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`.
8. Đầu ra ≤ 25 dòng theo brief chung.

## Diễn biến
- 14/11 23:07 tạo worktree `_wt/m34/cau-hinh` (`afb6d404c`), giao coder v1 (nền).
- 14/11 23:29 coder v1: ĐẠT · patch 16 tệp +422/−39 (main: `OpsCoreConfigRules`, `GoldenHourReservationServiceImpl` đoạn chặn, `OpsCoreHttpClient`, `OpsCoreTokenCache`, `application.yml` lifecycle + allowlist, compose, env.mau) · đỏ trước Java 9+1, Python 4 → 218 Java + 50 Python xanh; ModuleBoundary đỏ sẵn 3/15 không thêm · đột biến 3/3 · ca cũ "ENFORCE + cờ bật cho qua" đổi thành 409 theo P2 · áp sạch sau `nkb-sua.patch` (thử index tạm).
- 14/11 23:45 verifier: ĐẠT, chờ bộ đủ · 13 lớp 224/224 · test_compose 50 OK (3 bỏ qua do cây tạm thiếu yml; 2 ca so yml chạy riêng OK) · fail-closed khi cờ bật: không tạo client, `OPS_CORE_CONFIG_INVALID`, đơn 503, app vẫn khởi động · đột biến 3/3 khác của coder bắt.
- 14/11 23:47 ghép: áp patch lên `toandeptrai`, commit `2937d0cb9` (chưa push) + nhật ký tuần `24c84a409`. Sheet: lỡ ghi `log` DONE cho 4 task rồi sửa ngay về Đang làm (M3-135 80%, M3-149 75%, M3-159 75%, M3-126 85%) vì mỗi task còn phần .99/tài liệu/E2E ở gói 8/9/11; nhật ký tuần chỉ giữ bản đúng. Gỡ `kiem-cau-hinh`.
- 15/11 01:54 bộ đủ tầng 3 (`kiem-song` `771667637` = gói 6 + gói 1, `ci-unit` 34301 ca): `OpsCoreConfigValidatorTest` 33, `OpsCoreConfigYamlTest` 6, `OpsCoreLifecycleConfigTest` 17, `OpsCoreLifecycleAllowlistYamlTest` 3, `OpsCoreCorrelationIdTest` 11, `OpsCoreHttpClientTest` 25, `GoldenHourOpsCoreEnforceBlockTest` 12, `GoldenHourReservationServiceImplTest` 23 xanh; 39 ca đỏ của bộ trùng đúng tên 39 ca đỏ sẵn trên `afb6d404c` → không đỏ mới. Deploy Linux 584 OK.

## Bước kế tiếp chính xác
Phần mã xong. 4 task giữ Đang làm; Đạt khi xong gói 8/9/11 (không ghi `sheet_lead` Đạt ở sóng này). Gỡ worktree `cau-hinh` lúc dọn cuối sóng.

## Còn lại / CẦN QUYẾT
- Nút "Giữ chỗ" FE khi Giờ Vàng bị chặn: ở gói `test-bo-sung` (8), không ở đây.
- `GoldenHourSessionServiceImpl` vẫn cho tạo/publish phiên khi ENFORCE + cờ bật (vô hại: cờ bật = cấu hình hỏng, không có client) → gói `test-bo-sung` (8).
- Mặc định `lifecycle.enforce` trong mã `OpsCoreLifecycleProperties` = true, yml = false (dùng trên .99) → gói `tai-lieu` (9) ghi rõ ở `NOI_M12`.
- `env.mau` mẫu allowlist = `192.168.1.99` (compose/yml mặc định rỗng): giữ, đúng phiếu.
