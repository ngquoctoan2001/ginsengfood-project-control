# tach-ngat-mach-m12 — bộ ngắt mạch của client M12 tách theo ngăn (CHECK / READ)

Trạng thái: ĐẠT, đã vào `dev` `9c71e37ce` (PR #164) · Sheet M3-201 Hoàn thành + Lead Đạt · Rủi ro: R2 (hành vi cổng bán khi M12 lỗi; không đổi giữ hàng, không tiền) · Chế độ: A (worktree tách rời → patch → phiên chính áp + commit `toandeptrai`) · Mốc: trước ENFORCE 21–22/11
Hạng mục nâng: cổng bán M3 (`/check`, giữ hàng) không bị màn quản trị đọc M12 làm mở mạch · Sheet: M3-201 · Ước lượng: 2–3 giờ
Chỗ làm: `C:\Projects\_wt\m34\tach-ngat-mach` · Base SHA: `c95f083c8` (= `origin/toandeptrai`, PR #164) · Patch: `C:\Projects\_wt\m34\tach-ngat-mach.patch`
Nguồn: rà Phúc 17/11 nhóm D (`ra-soat/evidence/2026-11-17-phuc/nhom-d-m12.md`), D-m34-098 (122 "theo đề xuất").

## Lỗi
`OpsCoreHttpClient` (lớp của Toàn) có MỘT `OpsCoreCircuitBreaker` cho mọi lời gọi M12 (`OpsCoreHttpClient.java:82,126,161,179-219`). Ngăn hạn mức đã tách (`OpsCoreRateLimiter.Bucket.CHECK` / `READ`),
nhưng bộ ngắt mạch thì không: lỗi 5xx/408/hết giờ/mạng của lời gọi `READ` (màn quản trị đọc kho, tồn theo lô, `/v1/skus` của Phúc; đọc vòng đời SKU) cũng được đếm → mở mạch → `/check` và giữ hàng (`CHECK`)
nhận `CIRCUIT_OPEN` ngay. Khi ENFORCE bật, admin mở màn đọc lúc M12 chậm có thể làm chặn chốt đơn.

## Brief
1. Repo `C:\Projects\ginsengfood-business-platform` (CHỈ ĐỌC) · làm trong `C:\Projects\_wt\m34\tach-ngat-mach` (HEAD tách `c95f083c8`) · luật chung `C:\Projects\_wt\m34\_tools\BRIEF_CHUNG_SUA_NKB.md`
   (đọc trước; thay base = `c95f083c8`, tên gói = `tach-ngat-mach`).
2. Mục tiêu và tiêu chí đạt:
   (a) Mỗi `OpsCoreRateLimiter.Bucket` có bộ ngắt mạch RIÊNG (cùng ngưỡng/thời gian mở từ `OpsCoreClientLimits` hiện có — không thêm khoá cấu hình mới trừ khi buộc phải, nếu thêm thì có mặc định = giá trị cũ).
       Lời gọi chọn bộ ngắt theo `call.bucket()`. Ngữ nghĩa mỗi bộ giữ nguyên (đếm gì, không đếm 429 và 4xx nghiệp vụ, nửa mở/thăm dò, `abandon`).
   (b) Lỗi liên tiếp trên `READ` mở mạch `READ` nhưng `CHECK` vẫn gọi được (và ngược lại). Giữ hàng (`OpsCoreReservationHttpAdapter`, bucket nào thì theo bucket đó) không bị `READ` ảnh hưởng.
   (c) Log `CIRCUIT_OPEN` / chỉ số (nếu có metric/health về breaker) ghi rõ ngăn nào; mọi chỗ đọc trạng thái breaker hiện có (grep `isRejecting`, `breaker` trong `src/main`) vẫn đúng nghĩa — nếu có
       chỗ báo "M12 đang lỗi" dựa vào breaker chung thì nói rõ đổi thành ngăn nào (CHECK là ngăn quyết định cổng bán).
   (d) Không đổi chữ ký adapter của Phúc (`OpsCoreWarehouseHttpAdapter`, `OpsCoreStockBalanceHttpAdapter`, `OpsCoreSkuListHttpAdapter`) — chúng đã truyền `Bucket.READ`.
   (e) Test (R2, đỏ trước): trong `OpsCoreHttpClientTest` (và/hoặc `OpsCoreCircuitBreakerTest`): N lỗi 503 trên READ → READ trả `CIRCUIT_OPEN`, CHECK vẫn tới mạng và nhận kết quả;
       N lỗi trên CHECK → CHECK mở, READ vẫn gọi; nửa mở của từng ngăn độc lập; 429 không đếm (giữ). Chạy thấy đỏ trên mã cũ một lần rồi xanh.
   (f) Docs: `deploy/m34/ops-core/NOI_M12.md` (mục nói về bộ ngắt mạch/SEC-16 nếu có) + javadoc `OpsCoreHttpClient` ghi "bộ ngắt mạch theo ngăn".
3. Phạm vi ghi: `back-end/src/main/java/com/ginsengfood/project/inventory/adapter/out/client/opscore/{OpsCoreHttpClient,OpsCoreCircuitBreaker,OpsCoreClientLimits}.java` (+ tệp mới nhỏ trong cùng gói nếu cần),
   `back-end/src/main/java/com/ginsengfood/project/inventory/config/OpsCoreClientConfig.java` (chỉ khi cần nối), test trong `back-end/src/test/java/com/ginsengfood/project/inventory/adapter/out/client/opscore/`,
   `deploy/m34/ops-core/NOI_M12.md`. CẤM: adapter của Phúc, giữ hàng ngoài việc chọn breaker, front-end, migration, `deploy/**` khác.
4. Đọc trước: `OpsCoreHttpClient.java` (362 dòng), `OpsCoreCircuitBreaker.java` (161), `OpsCoreRateLimiter.java`, `OpsCoreClientLimits.java`, hai lớp test trên; grep người dùng `breaker`/`isRejecting`.
5. Lệnh kiểm nhanh (tầng 1–2): `bash C:/Projects/_wt/m34/_tools/mvn-lock.sh C:/Projects/_wt/m34/tach-ngat-mach/back-end test -P ci-unit -Dtest='OpsCore*Test,!*PostgresTest' -DfailIfNoTests=false -Dsurefire.failIfNoSpecifiedTests=false` (timeout 600000 ms).
   Bộ kiểm đủ — chỉ phiên chính, sau khi áp: lớp `inventory`/`order` ci-unit có Postgres + `ModuleBoundaryArchitectureTest`.
6. Bằng chứng: patch; số ca đỏ trước/xanh sau; đột biến ≤ 3 (dùng chung một breaker lại; READ chọn breaker CHECK; bỏ đếm ở một ngăn) đều bị bắt; danh sách chỗ đọc trạng thái breaker và cách xử lý.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`. Không ssh, không gọi M12 thật, không đọc `.env*`/`sheet.json`.
8. Đầu ra ≤ 20 dòng; báo cáo dài `C:/Projects/_wt/m34/tach-ngat-mach-bao-cao.md`.

## Diễn biến
- 17/11 13:2x tạo worktree `_wt/m34/tach-ngat-mach` (`c95f083c8`), giao coder.
- 17/11 ~14:3x coder ĐẠT: bộ ngắt mạch theo ngăn (`OpsCoreHttpClient` +21/−6, `OpsCoreCircuitBreaker` log có ngăn, `OpsCoreClientLimits` javadoc, `NOI_M12.md`), 7 ca test mới;
  lệnh mục 5: mã cũ 1079/6 hỏng (đúng 6 ca mới) → mới 1079/0; đột biến 3/3; giữ hàng (`OpsCoreAllocationExchange`) không qua breaker này; `/check` luôn CHECK; log `OPS_CORE_CIRCUIT_*`/`CALL_UNAVAILABLE` thêm `bucket=` (tiền tố giữ, canh-bao vẫn đếm).
  CẦN QUYẾT chú thích `OpsCoreLifecycleReconciler` → m34 chốt (a) sửa chữ: +11/−7 + đổi tên 1 test, không đổi assertion; chạy lại 1079/0. Giao verifier.

- 17/11 ~15:0x verifier ĐẠT (chờ bộ đủ): 8 tệp đúng phạm vi, patch khớp; breaker chọn 1 lần ở `OpsCoreHttpClient.java:168`, mọi isRejecting/acquire/failure/success/abandon dùng nó; 429/4xx không đếm; giữ hàng (`OpsCoreAllocationExchange`) không qua breaker này;
  lệnh mục 5 1079/0, `test_canh_bao.py` 71/71; đột biến khác coder: isRejecting→CHECK đỏ, success→CHECK đỏ, abandon→CHECK XANH (hở) → giao coder thêm 1 ca thăm dò READ bị huỷ.
  Rủi ro ngoài phạm vi (việc sau): token cache dùng chung CHECK/READ — lỗi lấy token của READ bật thời gian chờ làm `/check` nhận `TOKEN_UNAVAILABLE`; `CONG_TON_M12` (canh-bao) đếm cả CALL_UNAVAILABLE của READ; `test_canh_bao.py:375` dòng log mẫu chưa có `bucket=`.

- 17/11 ~15:1x coder thêm ca `aReadProbeCutShortFreesTheReadProbeSlotAndLeavesTheCheckProbeAlone` (đột biến abandon→CHECK nay đỏ), 1080/0 → áp → commit `75663cf47` + tracking `f70730af1` (Sheet M3-201 Đang làm). Bộ đủ inventory/order/sellablegate + ModuleBoundary @ `75663cf47` trong `_wt/m34/tach-ngat-mach`, log `tach-ngat-mach-bodu.log`.

- 17/11 15:50 bộ đủ @ `75663cf47` (inventory/order/sellablegate + ModuleBoundary, ci-unit có Postgres): 3883 ca, đỏ 6 = đúng bộ đỏ sẵn (ModuleBoundary ×3, CommissionFloorReferrerCheckoutPostgresTest ×2, CommissionTemporaryRuleTripwireTest) → ĐẠT. Sheet M3-201 DONE (upsert, không tạo commit để dev = toandeptrai) + Lead Đạt. Worktree gỡ.

## Bước kế tiếp chính xác
Xong. Việc sau (gói mới trước ENFORCE 21/11): token cache dùng chung CHECK/READ; `CONG_TON_M12` (canh-bao) lọc `bucket=CHECK`; dòng log mẫu `test_canh_bao.py:375`.
