# Phúc rà và gộp các nhánh của chú Dũng vào dev · 16/11/2026

Việc giao (Toàn, 16/11): "thay vì tôi review rồi tôi merge vào dev, thì tôi giao cho phúc làm" — Phúc **rà các nhánh của chú Dũng rồi gộp vào `dev`** trong repo
`ginsengfood-business-platform`. Lời Toàn: "bật lên hết đi để duyệt, đừng tắt nữa", "làm theo những gì chú đã làm, chú đã quyết thay đổi rồi".
M9 (hoa hồng, chi trả, kế toán) Toàn cũng giao Phúc ("Giao Phúc luôn", mục 4). Phần code của Toàn (nối M3 → M8, các gói sửa NK-b) Toàn tự gộp vào `dev`, không nằm trong việc này.
Tệp này là kết quả rà chỉ đọc của phiên m34 để Phúc đỡ rà lại từ đầu. Mốc: nhánh gộp `7859dc42b` (07:55 16/11).

## 1. Kết quả rà (VÀNG: gộp được, nhưng có việc phải làm trước khi lên .99)

- Nhánh gộp `chudung/m3-14112026-gop-cac-nhanh-sua-ngay-14-11` đỉnh `7859dc42b` chứa đủ 25 nhánh lá của chú. Migration mới V358–V381.
- **Chỉ gộp nhánh gộp, một lần.** Không gộp lẻ nhánh lá: V361, V366, V373 mỗi tệp có 2 bản khác nhau giữa các nhánh → Flyway báo lệch checksum.
- Không có test bị xoá; số `@Test` 18.833 → 19.237. Số "đạt" ghi trong commit của chú chưa ai chạy lại → chạy bộ đủ sau khi gộp.
- Xung đột khi gộp vào `dev`: code của Toàn đã vào `dev` (PR #161, `9a1970240`, 16/11 11:2x). Ghép nhánh gộp của chú với `dev` mới chỉ vướng **1 tệp**:
  `back-end/src/test/java/com/ginsengfood/project/seed/SkuMasterSeederWriteContractTest.java` — cùng 5 tên lớp ghi, lấy bản của Toàn (`7aeb07edd`, `KNOWN_INSERT_WRITERS`).
  README `deploy/m34`: hướng dẫn "Buổi sếp test M4" nay là **mục 15** (mục 13, 14 là cửa TLS M5 và tắt tài khoản mẫu).
- Chi tiết từng nhánh, từng rủi ro (tệp:dòng): bản rà `Project Control/modules/m34/ra-soat/2026-11-16-chudung.md`, phụ lục nhóm A, nhóm B (Toàn gửi kèm nếu cần).

### Phải làm trước khi lên .99 (không phải "tắt", là để be khởi động được và có đường lui)
1. Kiểm .99 còn chính sách giá PUBLISHED/PENDING dùng STACK không: `V367:215-219` sẽ RAISE → Flyway lỗi, be không lên.
2. Sao lưu DB .99 và chụp bảng chính sách hoa hồng, chính sách thuế, kỳ hoa hồng, khoản phải trả trước V365–V377 (đổi dữ liệu tiền, không lùi được).
3. Chốt dải số migration với Tài (mục 5).
4. Chủ hệ thống (V372) đang trống: chưa gán thì không đổi được 2%, điểm, CTKM và các worker chờ START không chạy. Duyệt nhà khởi nghiệp chỉ còn vai `SALES_MANAGER` (`V379:73-78`) → gán vai trước.
5. "Chạy thử" chốt lời lỗ tháng là khoá vĩnh viễn mọi tháng có dữ liệu (`MonthlyPnlService.java:121-131`, `V377:46-71`), kể cả dữ liệu thử trên .99.
6. Khi deploy .99 giữ dòng `COMPOSE_FILE` hiện có trong `.env` (có lớp `compose.m8-that.quan-tri.yml` bật quản trị IVR từ 15/11).

## 2. Thứ tự lên máy (mã của chú ở 3 repo gọi nhau)
1. **M12 (ops-core):** `main` đã có code giữ hàng của chú (`ea8f8d5d2`). Hợp đồng `m12-noi-m3` đã sửa khớp code chú và push (`5b90c0b`, 16/11 12:35). Bản M12 mới chưa lên .99 (CI cần máy .63 đang gác).
2. **M8 (IVR):** nhánh M8 của chú (hợp đồng IVR draft.47: `/tasks/{id}/result`, `/call-jobs/{id}/result`, trường `recall_of_task_id`) đã vào `main` M8 (`8ab726ddf`, 16/11 12:04); .99 còn M8 cũ, chờ Toàn triển khai. Ghim lại draft.47 phía M3 do Toàn làm (đang làm). **Phải lên .99 TRƯỚC M3**:
   M3 lên trước thì M8 từ chối `recall_of_task_id`, M3 gửi lại không kèm → lượt gọi lại thành cuộc gọi đầu, thoát luật khung giờ gọi lại.
3. **M3:** gộp nhánh gộp vào `dev`, chạy bộ đủ, rồi lên .99.
4. Giữ hàng 26 giờ (`OPS_CORE_ALLOCATION_MAX_HOLD=PT26H`, `RECONCILE_PENDING_AGE=PT27H`, `QUOTA_OPEN_WINDOW=PT26H`, đặt cùng lúc) chỉ đặt khi M12 rồi M3 bản mới đã ở .99 — sớm hơn thì mọi lệnh giữ bị 422 `EXPIRES_AT_LIMIT_EXCEEDED`.
   Luật giữ hàng theo code chú: mỗi lượt ≤ lúc M12 nhận + 26 giờ (trần cấu hình 48 giờ), gọi lại bằng khoá mới thì lùi hạn, không giới hạn số lần.

## 3. Điểm cần biết trong nhánh chú (không chặn gộp)
- Gọi lại khách (`ivr-recall`) và gửi `recall_of_task_id` bật sẵn; M8 `main` hiện coi mỗi lượt `-rN` là việc gọi mới. Trên .99 không gọi thật (MOCK, lịch tắt).
- Nhân viên xác nhận/huỷ đơn thay khách bật sẵn (`V373:24,32`); CCCD + số tài khoản nhà khởi nghiệp lưu dạng thô (`V380:28-45`); SKU nguồn nhập tay bỏ qua cổng M12 (`V380:60-70`).
- Nhánh M4 của chú (`431a7e523`) sửa 13 tệp M4 có sẵn của Tài (có `M4AdvisorTurnService`) + thêm 14 tệp; ngưỡng miễn ship bị số ở Khu Chính sách đè.

## 4. M9 — hoa hồng, chi trả, kế toán ("Giao Phúc luôn")
- M9 nằm trong be của M3 trên .99. Cờ/worker M9 nào đang bật trên .99 (vd `FINANCE_COMMISSION_PERIOD_CLOSE_WORKER_ENABLED` mặc định `true` trong `application.yml`): **CHƯA KIỂM**.
- Nhánh M9 của chú (đều trong nhánh gộp): báo cáo theo ngày, nhà phân phối + công nợ (V358), tích điểm đổi voucher (V359), kỳ tháng + bút toán (V366), hoa hồng làm tròn + tỷ lệ (V365),
  voucher Có 3388 + ẩn số theo vai (V375), lời lỗ tháng tự chốt (V377); thêm V372 (nút START/OFF, MISA khi chi), V376 (quyền nhà phân phối, điểm cho FINANCE_MANAGER, ADMIN).
- **Không lùi được:** V365 đưa về lưu trữ chính sách hoa hồng khác 15%/10% và đóng TNCN đang hiệu lực; V366, V377 tắt trigger bảo vệ để sửa kỳ/ghi bù; chốt lời lỗ tháng khoá vĩnh viễn.
- **14 luật tiền cần chị Giang duyệt trước khi bật thật:** (1) tỷ lệ 15%/10%, lưu trữ chính sách cũ; (2) TNCN 10% ngưỡng 0 từng đơn; (3) kỳ tháng, tự chốt, bút toán 6421/3388/3335/1121;
  (4) Có 3388_VOUCHER; (5) chi trả qua MISA + bút toán đảo; (6) kỳ đầu từ ngày vận hành thật; (7) lời lỗ chốt ngày 10, không mở lại; (8) loại đơn (a)/(b) suy ngược dữ liệu cũ;
  (9) hoá đơn nội bộ: 2% giảm căn cứ VAT, voucher chỉ trừ tiền hàng, ship công ty chịu không là doanh thu; (10) VAT dòng trước 2%, VAT đơn sau 2%; (11) đối soát COD, 6421_PHITHUHO/VANCHUYEN/QUANGCAO;
  (12) ai xem số tài chính; (13) ngưỡng bảo tồn vốn 25%; (14) VAT 8% nhà phân phối, nghĩa vụ điểm/voucher.

## 5. Tài
Sóng 1 M4 của Tài (M4-PLAN `c920f0ca`) đánh số migration "lớn nhất + 1" khi lên dev → ra V358, trùng V358–V381 của chú. Chốt: chú giữ V358–V381, Tài đánh từ V382.

## 6. Câu hỏi cho chú Dũng (hỏi khi rà)
a) Giữ đơn 24 giờ tính từ lúc đặt hay từ lúc IVR hết hạn? M12 cho lùi hạn giữ hàng không giới hạn: có cần giới hạn tổng thời gian giữ hàng không?
b) Công tắc nhân viên xác nhận/huỷ thay khách: ai được bấm, khi nào tắt? c) Ai là chủ hệ thống trên .99, khi nào bấm START?
d) Chốt lời lỗ tháng có cần mở lại được, hay chỉ chốt từ ngày vận hành thật? e) Nhà khởi nghiệp cũ chưa đủ 2 triệu thì mất giá Diamond ngay: đúng ý chú?
f) Mã link khách gõ trong chat M4 được thay link khách đang giữ: đúng ý chú? g) ADMIN ghi thu nhà phân phối, chỉnh điểm, nhập COD, xem giá vốn: có cần tách khỏi kế toán?
h) Đã hỏi chị Giang về 3388, MISA khi chi trả, VAT 8% nhà phân phối, TNCN ngưỡng 0 chưa? i) CCCD, số tài khoản có cần mã hoá?
j) Nhánh M4 sửa thẳng tệp M4 của Tài: đã báo Tài chưa? k) 35 số migration để trống trong `GoldenHourRulesPolicyGuardMigrationContractTest`: chú cần xác nhận gì?

## 7. `dev` đỏ sau lượt gộp `PhucApu` 15:34 16/11 (m34 thấy khi gộp `dev` `b2568a319` vào `toandeptrai`, 18:2x)
- **CI `m34-images` 43840925341 trên `dev` `b2568a319` đỏ ở `kiem-tra-khuon`** (không ra ảnh): khối `MAIL_*` (M3-192) trong `deploy/m34/env.mau` nằm giữa khối "Cửa TLS cho M5"
  và khối M8 thật → `test_compose test_env_mau_dung_danh_sach_thiet_ke` + `test_m5_cua test_env_mau_khoi_cua_chi_chu_thich` đỏ. Toàn đã sửa trên `toandeptrai` (`d3d91686d`,
  chuyển khối về sau `M5_ORDER_STATE_SERVICE_TOKEN`, không đổi nội dung); vào `dev` khi PR của Toàn được gộp. Phúc đừng sửa lại chỗ này để khỏi đụng.
- **Maven (CI không chạy) đỏ 2 ca `SkuMasterSeederWriteContractTest`** (rào M3-162 chỉ cho ghi `sku_master_codes` qua một đường chèn mã thiếu), do M3-117 đợt 8-10 (`7951e2fbe`):
  `E2eIvrOrderPackJdbcRepository.java:135-141` `insertSkuMasterIfAbsent` (có `ON CONFLICT DO NOTHING`) và `seed-packs/catalog-sku-master-products/sync.json` loại mục `sku-master-product-sync`.
  Việc của Phúc: hoặc đi qua đường chèn mã thiếu có sẵn, hoặc thêm vào danh sách được phép của test kèm lý do; `sync.json` phải chứng minh không ghi đè dòng master đã có.
- **`StagingTestDataFlowPostgresTest:211` đỏ cả trên `9a1970240`** (trước sóng của Toàn): đếm được 2 cấu hình giao nội bộ `SCHEDULED/ACTIVE` thay vì 1 (gói `staging-test`, M4-E2E-STAGING-DATA-001). Chưa rõ người phụ trách; cần người viết gói xem.
- **`CommissionFloorReferrerCheckoutPostgresTest` đỏ 2 ca `ctvApi11_mixedCartBeforeOpening_tierLinkLineOnly_noCommission`, `ctvApi12_linkSkuWithoutPolicyRow_staysFailClosedInAMixedCart`** (m34 thấy 16/11 22:1x, đỏ ngay trên `d3d91686d` = dev `b2568a319` + code Toàn, trước F1/F2; lớp Postgres nên CI nhanh không chạy). Vùng hoa hồng CTV / gói dữ liệu M3-117: Phúc xem.
- Gói 8 của Toàn sửa 1 dòng trong tệp catalog `PublicSellableAvailabilityDisplayServiceImpl.java`: thêm `RECALL_CASE_OPEN_STOP_SALE` vào `ACTIVE_INVENTORY_BLOCKERS` (thu hồi mở → hết hàng, không phải "chưa sẵn sàng giao").

## 8. Hai PR chờ Phúc review (thêm 16/11 20:5x, D-m34-092)
- **PR #162 `dev015 → dev` của Tài** (mở 16/11 12:34, đầu `d8202cc31`): Phúc là reviewer, chưa review. Tài cần trả lời **trước 09:00 17/11** vì buổi sếp test M4 18–19/11.
  CI đang đỏ 3 check (`Backend fast (ai)`, `Backend fast (platform)`, `Backend fast gate`); `dev015` lệch `dev` 15 trước / 19 sau. Luật D-m34-056: chỉ gộp khi CI nhanh xanh.
  PR có bản sửa `SEED_STAGING_TEST_ENABLED` (không nạp gói `demo-*`): chưa vào dev thì không bật cờ này trên .99.
- **Hợp đồng `order-channel-state` PR #2 ở `ginsengfood-contracts`** (Toàn mở 13/11, M3 cho M5 đọc trạng thái đơn): Phúc + Tài review và chốt, hạn cũ 17/11; M3-181 (Phúc) hạn 21/11 phụ thuộc hợp đồng này.

## 9. Hợp đồng giữ hàng X-03b đổi: trần tổng 48 giờ (thêm 16/11 22:1x, D-m34-093)
- M12 (`a57a11f`, chưa push; QT-CHUNG-016 của chú): lùi hạn hold không vượt `requested_at` + 48 giờ; vượt thì M12 CẮT về mốc, vẫn trả `200 ALREADY_RESERVED` với hạn đã cắt. Lượt tạo đầu không bị cắt.
- Nhánh gộp chú đã đọc hạn từ phản hồi nên **không phải sửa gì để gộp**. Khi bị cắt, `OpsCoreReservationServiceImpl.sendExtension` trả `UNKNOWN EXPIRY_NOT_EXTENDED` và `OrderIvrRecallService.keepStock` hỏi lại mỗi 1 phút
  tới khi hold hết rồi giữ lại thành hold mới: đúng trạng thái, chỉ ồn log WARN `OPS_CORE_RESERVATION_EXTEND_NOT_APPLIED` và 1 lời gọi/phút/đơn.
- Tuỳ chọn sau khi gộp (không chặn): nhận ra "cắt ở trần" (hạn trả về = `requested_at` của dòng + trần) để trả kết quả riêng, thôi hỏi lại mỗi phút.
- M8 (16/11 22:2x, `main` `0f1a9eb5`, QT-CHUNG-015, W-0544): khung gọi lại mặc định đổi thành 08:00–09:00, 13:00–14:00, 20:00–21:00 giờ VN. Task có `recall_of_task_id` mà cửa sổ xác nhận ra ngoài khung bị từ chối `TASK_BLOCKED_OPERATIONAL` / `RECALL_OUTSIDE_ALLOWED_HOURS`; giờ bắt đầu muộn nhất Giờ Vàng 08:53:30 / 13:53:30 / 20:53:30, 24/7 08:43:30 / 13:43:30 / 20:43:30. Hợp đồng không đổi byte (không ghim lại).
  Khi gộp nhánh chú đợt 6 (lên lịch gọi lại khách không nghe máy phía M3): kiểm M3 hẹn gọi lại trong khung mới, không còn dựa khung cũ 08:00–11:30 / 13:30–20:30.
