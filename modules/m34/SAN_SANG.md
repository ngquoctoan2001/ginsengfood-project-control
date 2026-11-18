# Sẵn sàng — m34 (M3 bán hàng, M3 vận chuyển + thanh toán, M4 AI tư vấn, M3 → M8)

Mốc: 10/11 11:00 · % sẵn sàng: **40** (trung bình trọng số; 03/11: 36) · Kịp 15/11: **ĐỎ** đủ phạm vi, **VÀNG** bản tối thiểu trên .60 —
M3 + M8 giả lập đã chạy trên .60 nhưng phần đang chạy chưa commit; chưa ai mua qua giao diện, chưa chạy phí ship/vận đơn tay, M4 chưa lên .60;
Phúc 0 task đóng từ 03/11. Chạy thật 30/11: **ĐỎ** — máy chạy thật đã chốt .99 (D-lead-035; gói `~/m34` cắt từ .60 ngày 14/11 22:45), tên miền + HTTPS chưa chạy thật, chưa nạp ảnh tồn WMS M2 → M3, CI trên PR đỏ.

Ref đã chấm (fetch 10:18): `origin/dev` = `origin/dev015` = `e04620799` (PR #154 09/11; 156 commit sau `9a4690574`, phần lớn M9 của manhth197, không chạm
`order/`, `payment/`, `ivr/`) · `origin/PhucApu` `ce21d1f59` (đã trong dev) · `origin/toandeptrai` `67f358ed9` (4 commit M3-112 chưa vào dev) + 35 tệp chưa commit
trong checkout BP và 3 tệp trong `ginsengfood-ivr` `main` (overlay FE M3-112 đang chạy trên .60) · .60 chạy `9a4690574` (Flyway V318) + FE `m3112-narrow` · M4-PLAN `f7345f66`.
Nguồn: 4 scout + 1 auditor 10/11, chỉ đọc, không chạy test; số test tự khai chưa chạy lại không dùng để nâng bậc. Tự khai: Phúc 35%, Tài M3 43%, M4 37%.
Hạn (D-lead-025, D-m34-044): 30/11 M3 chạy thật, xong hết; 15/11 mốc giữa kỳ = bản tối thiểu, chạy thử trên .60 tới giờ cắt 14/11 22:45 rồi trên .99 (D-lead-036); .60 chỉ còn đường lui. M4: 15/11 pilot nội bộ, khách thật chưa có ngày (m34.75).

Bổ sung bằng chứng 17/11 (rà Phúc, `ra-soat/2026-11-17-phuc.md`, không chấm lại %): hạng mục 4 (quản trị XII) 0/16 task Đạt — mã không đổi từ 10/11, R3 vào dev không PR; đăng nhập/IAM 2/10 Đạt; nối M12 phía Phúc = màn quản trị ĐỌC kho/tồn theo lô/SKU khớp hợp đồng `a57a11f` (306/306 test) nhưng chưa bật .99 (thiếu 3 cờ); G3 Bảo mật thêm: 404 dò email ở mã đăng nhập, tài khoản mẫu vào được .99.

## Hạng mục lõi (tổng trọng số 100)

| # | Hạng mục (người ngoài hiểu được) | Người | Trọng số | Bậc 03/11 → 10/11 | Bằng chứng |
|---|---|---|---|---|---|
| 1 | Cửa hàng web: xem sản phẩm, giỏ hàng | Phúc | 15 | 35 → 40 | storefront lô 1/1B (`aca7f75b2`, `c4501ddee`) nay trong dev qua `ce21d1f59`; `cart/api/CustomerCartController.java`; M3-010 (74 Vitest + 8 Playwright đỏ) Chưa bắt đầu, hạn 03/11; Playwright 117/124 tự khai (M3-026); .60 chỉ kiểm khói M3-093 (`nhat-ky/2026-11-06.md:3`), chưa ai mua qua giao diện |
| 2 | Đặt hàng lõi: tạo đơn, vòng đời, huỷ | Phúc | 10 | 30 → 40 | đơn khách vãng lai tạo qua API chạy trên .60 (193–195, 198/199, `nhat-ky/2026-11-09.md:12`); khách tự huỷ: không có endpoint trong `order/api/`, M3-110 Chưa bắt đầu; `ORDER.CANCEL` chưa gán vai (`V252:137-138`), chỉ `ORDER.CANCEL_ADMIN` cho ADMIN (`:168`); job hết hạn đơn tắt (`application.yml:258`); chưa phát ORDER_CANCELLED/EXPIRED (`OrderStateMachineImpl.java:444` TODO) |
| 3 | Khách hàng, khuyến mãi, thành viên/hạng, cộng tác viên | Phúc | 10 | 35 → 35 | V259 hạng trong dev; M3-022 Cần sửa; M3-109 chạy khách mới/Silver/Gold trên .60 Chưa bắt đầu (13/11); CTV thiếu chi trả + thuế TNCN; E2E CTV M3-066/068 không chạy được (tự khai) |
| 4 | Quản trị M3 + quản trị hệ thống XII | Phúc | 10 | 25 → 30 | XII vào dev bằng đẩy thẳng, không PR (V300–V301, V305, V314–V318; gộp `00870da0c` 1.359 tệp) và đang chạy trên .60; M3-040…057 Cần sửa (24 task), M3-053/058/059 Chưa bắt đầu; M3-050 chưa có giao diện trên dev |
| 5 | Thanh toán: VNPAY, COD, an toàn trước tiền thật | Tài | 15 | 40 → 40 | M3-015/016/063–065 vào dev qua PR #146 `4f8a49bd0` (chưa ai soát); VNPAY tắt mặc định, URL/khoá rỗng (`application.yml:493-500`); IPN lọc IP (`PaymentWebhookController.java:77,100,153,188`), chống lặp + lệch tiền (`PaymentWebhookServiceImpl.java:295-322,690-708`); COD chạy trên .60 qua API; VNPAY chưa lên .60 (`deploy/m34/compose.yml:165`), M3-017 Chưa bắt đầu (hạn 10/11); M3-019 đối soát 0; lỗi B1 link VNPAY cũ huỷ đơn (OWN-334 A8) chưa sửa. Lên 50 khi kiểm tự động được chạy lại |
| 6 | Vận chuyển: phí nội bộ + vận đơn tay, GHN, Viettel Post | Tài | 10 | 40 → 40 | GHN/VTP trong dev, tắt (`application.yml:594,603`), base-url sandbox; webhook sai xác thực trả 401 (`CarrierWebhookService.java:89,119`); khoá đơn khi tạo vận đơn (`CarrierShipmentStore.java:61`); phí nội bộ/vận đơn tay chưa chạy trên .60; M3-006 Chờ review; dựng lại vận đơn sau huỷ chưa có mã; SPX 0 |
| 7 | Gọi xác nhận đơn tự động M3 → M8 | Toàn | 15 | 40 → 50 | trong dev: WP00–06 `3c9993b36`, U13 `3386c1b7b` (verifier 270/270, 7/7 đột biến), OUTBOX-DL `896227694` (140/140), OpenAPI `7fbdef0c3`; cờ IVR tắt mặc định (`IvrTaskClientConfiguration.java:16`); .60 + M8 giả lập: 193–195 CONFIRMED, 198 không nghe 3 lượt, 199 bấm 0 huỷ, review197 RESOLVED ([M3-112](wp/M3M8-M3-112.md)). Chưa 75: M8 giả lập + overlay FE chưa vào dev, đơn tạo qua API, chưa UAT, banner giám sát + trang đơn tràn 635/325 px, JWKS 197 chưa rõ gốc |
| 8 | AI tư vấn M4: M5 gọi M4, hạn 6,5 s, an toàn sức khoẻ, chuyển người thật | Tài | 10 | 40 → 40 | M4-005/008/011–015 vào dev (PR #146/#151/#152, Tài tự gộp, chưa soát); `ChannelAdviseController.java` hạn mềm 6.500 ms, trả 403 khi PRODUCTION (`:104-105`) + khoá cứng `application-production.yml:51`; kill-switch mặc định bật; M4 chưa chạy trên .60 (`compose.yml:171-178`), M4-004 trễ từ 05/11, M4-007 trễ từ 09/11; người duyệt an toàn sức khoẻ chưa có |
| 9 | Phiên Giờ Vàng phía M3 (mở phiên cho M7, giữ suất) | Phúc | 5 | 35 → 35 | `front-end/src/features/gold_hour`; `OPS_CORE_GATE_ENFORCE:false` (`application.yml:213`); giữ hàng theo kho 0 mã (M3-111, 27/11, Chưa bắt đầu); Giờ Vàng cấm COD (`CheckoutValidationServiceImpl.java:56-60`) mà VNPAY tắt → không bán được đơn Giờ Vàng (m34.71) |

Tính: (15·40 + 10·40 + 10·35 + 10·30 + 15·40 + 10·40 + 15·50 + 10·40 + 5·35) / 100 = 39,75 ≈ **40**. Trọng số giữ từ 03/11.

**Hạng mục mở rộng (không tính %, không chặn 15/11):** SPX (chờ hợp đồng) · GHN/VTP tự động cho khách thật (M3-020) · thai sản đầy đủ ·
chat web công khai M4 (`src/app/chatbot`, bậc 0) · 2FA nhân viên (D-m34-010: ngoài phạm vi) · kho S3 (m34.13) · VAT/hoá đơn, Price/Benefit Resolver, QuoteSnapshot.

## Cổng G1–G8 (`chung/CONG_PRODUCTION.md` §3)

| Cổng | Kết quả | Thiếu gì (bằng chứng) |
|---|---|---|
| G1 Chức năng lõi | chưa | cao nhất 50 (M3 → M8), cần ≥ 90 |
| G2 Liên module | chưa | `ginsengfood-contracts` dở merge (`README.md` UU), mọi `info.version` 1.0.0, commit cuối 21/05; M3↔M8: hợp đồng repo chung lệch đường thật `/api/v1/admin/ivr…` + TARGET_V1; M5→M4 chỉ có ở `module5/docs/05-reference/m4-channel-advise-contract.md`, chưa chạy M5 thật gọi M4; M2→M3: M2 có `stock-balances`/`allocations`/`release` (`ExternalAllocationCommandV1Endpoints.cs:38,53,58`), M3 chỉ gọi kiểm bán được → 19 SKU thật `WMS_UNCONFIRMED`; M3↔M7, M3→M6 `ORDER_VERIFIED`: chưa có hợp đồng, M3 chưa phát; M9: không chạm đơn/thanh toán |
| G3 Bảo mật | chưa | đăng nhập, OTP, `POST /orders`, chat AI `permitAll` không giới hạn tần suất (`SecurityConfig.java:347-371`); VNPAY nay tắt mặc định (đã sửa); webhook GHN/VTP trả 401 nhưng chưa kiểm cách ký; `SEED_ADMIN_PASSWORD` bắt buộc trong env container `be` (`deploy/m34/compose.yml:151`); mật khẩu admin .60 đã lộ (chat Codex 09/11 18:05) |
| G4 Dữ liệu | chưa | không trùng số migration, cao nhất V330, `MigrationVersionLockContractTest` có; .60 V318 0 lỗi; sao lưu 22:30 + khôi phục thử ĐẠT (M3-092). Thiếu: chạy sạch từ rỗng tới V330 và từ V318 lên V330 (M9 V319–V330 chưa thử); runbook khôi phục dạng tài liệu |
| G5 Triển khai | chưa (đạt trên .60) | `/api/health/live\|ready`, healthcheck compose, `USER app`, CI → GHCR → `trien-khai.sh` đạt; lệch: FE M3-112 nạp bằng save/load từ mã chưa commit; cổng 8080/3000 so với 8000 của contract chưa ghi lệch; máy chạy thật chưa chốt |
| G6 Vận hành | chưa | correlation-id chỉ trong header lỗi (`ApiErrorSupport.java:26-45`), chưa vào log; chưa cảnh báo; quay lui có trong `trien-khai.sh`, chưa runbook bật/tắt/sự cố; công tắc khẩn chỉ AI; giám sát IVR 8 nhóm OK / 10 UNKNOWN (M3-112) |
| G7 Kiểm thử | chưa | PR #151/#152/#154 CI job unit FAILURE vẫn gộp, 0 review; job front-end `if: false` (`ci.yml:141`); phiếu nghiệm thu M34-NT chưa viết (hạn 09/11); thử tải chỉ WP10 M3 → M8 PARTIAL |
| G8 Ngoài code | chưa | bảng "Việc ngoài code" |

## Gói việc

Đã xong: M3M8-WP00…06, CHOT, FIX-LIFECYCLE, GOP-DEV, PR-DEV, OUTBOX-DL, U13, MAY60 ([phiếu](wp/)); M3-112 Chờ review 90% (Codex, D-m34-045…053).
Làn: **L1** Toàn — phiên m34 code bằng subagent, mỗi WP một worktree `C:\Projects\_wt\m34\<gói>` (trừ CHOT112 làm ở checkout chính); **L2** Phúc; **L3** Tài (thẻ Sheet, Lead theo dõi/rà).

| WP | Mục tiêu → tiêu chí đạt | Làn | Tệp nóng | Rủi ro | Phụ thuộc | Hạn | Ước (ngày) | Trạng thái |
|---|---|---|---|---|---|---|---|---|
| CHOT112 | commit 35 tệp BP theo cụm + 3 tệp M8 (`main`, tách khỏi việc phiên m8), PR `toandeptrai` → dev (D-m34-019) → CI `m34-images` xanh, `/ra-soat` M3-112 Đạt, dev có M8 giả lập + OTP giả + làm mới tồn | L1 | `deploy/m34/{README.md,compose.m8-gia-lap.yml,m8-gia-lap/,tests/}`, `front-end/src/features/ivr/**`, `tools/m3-m8-wp09\|10/**`, `docs/integration/m3-m8/**` | R2 | Lead duyệt commit + PR (m34.74) | 11/11 | 0,5 | XONG 10/11: 9 commit M3-112 trên `toandeptrai`, PR #155 → dev mở (chưa gộp); kiểm độc lập R2 ĐẠT; mã trên .60 ≡ commit `5bfd23cee` (8/8 tệp FE); phần M8 (3 tệp) chưa commit vì repo M8 đòi W-0519 |
| M34-NT | phiếu nghiệm thu M3/M4 theo khách mới/Silver/Gold: đặt hàng web → M8 gọi → COD/VNPAY sandbox → vận đơn tay → M5/M4 → có bước, dữ liệu thử, kết quả mong đợi, ô ký | L1 | `modules/m34/nghiem-thu/` (mới) | R1 | — | 11/11 (trễ từ 09/11) | 0,5 | XONG 10/11 ([phiếu](nghiem-thu/M34-NT.md): B 19 bước × 3 khách, C 9 tình huống, D 11 mục M4, 12 mục CẦN XÁC NHẬN); chưa ai chạy thử phiếu; xin quyết C3 (m34.78) |
| M34-RS1 | hậu kiểm PR #146/#151/#152: chạm tiền (M3-015/016), an toàn sức khoẻ (M4-005/008/012), `SecurityConfig`, M5 → M4; `-P ci-unit` ở worktree → Đạt/Cần sửa trên Sheet | L1 (rà) | chỉ đọc | R3 | — | 12/11 | 1 | XONG 10/11: VÀNG; 20 task Tài = 12 Đạt phạm vi / 8 Cần sửa; chưa ghi Sheet (m34.80) ([bản rà](ra-soat/2026-11-10-tai-pr146-151-152.md), [tin nháp](ra-soat/2026-11-10-tin-tai.md)) |
| M34-AN | giới hạn tần suất đăng nhập, OTP, `POST /orders`, chat AI, IPN tại nginx .60 → test cấu hình + thử 429 trên .60 | L1 | `deploy/m34/nginx/m34.conf` + tệp test mới | R2 | m34.6 (IPN VNPAY phía `lead`) | 12/11 | 0,75 | XONG 10/11: kiểm độc lập R2 ĐẠT (≈ 30 kỹ thuật lách không qua được; 29 đột biến chết sau khi bịt 5 chỗ test); commit `c413987b5` trong PR #155; chưa chép lên .60 (LEN60: `docker compose restart nginx`, thêm `set_real_ip_from` khi có proxy phía trước); đề xuất vùng thứ năm cho `consultation-leads`/`public/leads`/`orders/preview`/`shipping-fee/resolve` chưa làm |
| M34-DB | Flyway sạch từ rỗng tới V330 và từ V318 (bản .60) lên V330 trong Postgres tách biệt; runbook khôi phục → 0 lỗi, ghi thời gian | L1 | `deploy/m34/KHOI_PHUC.md` (mới) | R2 | — | 12/11 | 0,5 | XONG 10/11, coder ĐẠT (A/B/C đạt, Postgres 17.11 cô lập); kiểm độc lập R2 ĐẠT 2 lượt (lượt 1 bắt 7 lỗi runbook, đã sửa và chạy lại 6 kịch bản); commit `72d65bb2e` trong PR #155 (`KHOI_PHUC.md` + README mục 6, 7); chưa thử BE thật + Hibernate validate, chưa trên .60 |
| M34-CI | `ci-unit` về xanh: 21 test đỏ (15 do PR của Tài: `M4DifferentialReadOnlyRunnerTest` ×11, `CustomerFacingAnswerDiacriticsTest`, probe LLM local, 2 test ModuleBoundary; 6 phía seed/migration: SkuTwoState…, GoldenHourRulesPolicyGuard…, CommissionTemporaryRuleTripwire…, P5F03c…, SkuMasterSeederWriteContract…, 1 ModuleBoundary Core) + tách bộ nhanh bắt buộc (không Testcontainers) / bộ đầy đủ chạy riêng + bật lại job FE + quy tắc gộp dev (m34.81) → CI xanh trên PR vào dev | L3 (15 test của Tài) + L2 (6 test seed/migration) | `.github/workflows/ci.yml`, `M4DifferentialReadOnlyRunner.java:244-247`, `FinalResponseGuardService.java`, `GoldenHourPaymentGateServiceImpl` | R2 | m34.81 | 13/11 | 2–3 | GĐ1 XONG 10–11/11: PR #157 gộp `fc7f40298` (CI nhanh 2 shard + `ci-full.yml` + danh sách Docker 409 lớp + seeder e2e + test bịt + banner IVR); bộ nhanh 12–14 phút/shard (thật), 9 lớp đỏ (7 cũ + 2 mới của Phúc); CÒN: áp bản vá test của Tài/Phúc/Mạnh (Lead gửi tin), `ClaudeRealProviderClientTest` + V7 Tài quyết, nhãn `ci-full` + `ci-full.yml` lên `master`, rồi mới bật ruleset + required check |
| LEN60 | .60 lên dev mới nhất bằng image CI (`trien-khai.sh <sha40>`), bỏ overlay save/load → health 200, Flyway 0 lỗi, kiểm khói M3-093, M3 → M8 giả lập 3 ca | L1 | máy .60 | R2 | CHOT112 vào dev, M34-DB, Lead duyệt deploy | 12/11 | 0,5 | XONG 10/11 17:42 bước 1–7 + 10 (kế hoạch kiểm độc lập 2 lượt ĐẠT; ~45 s gián đoạn; `trien-khai.sh 276e2f95` thoát 0; Flyway V330 áp 12 migration 0 lỗi; 16/16 cờ đối tác tắt; nginx 4 vùng giới hạn, thử 429 đạt). **Bước 9 ĐẠT 11/11 08:05** (3 đơn API khách vãng lai 253–255: CONFIRMED, M8 MOCK `IVR_CONFIRMED`, callback 200 `ACCEPTED` retry 0, `be` 0 cảnh báo JWKS). Phát hiện + sửa sự cố: SKU demo không bán được từ ~18:00 10/11 (seeder đặt lại nguồn tồn khi `be` start, cron làm tươi chặn); sửa bằng 1 UPDATE (D-m34-060), gốc ở M34-VH. **Bước 8 ĐẠT 11/11** (Toàn tự kiểm tay admin, xác nhận chat) → **LEN60 XONG trọn gói**. Lệnh `ssh` lên .60: trong lượt kiểm kế hoạch coder LEN60 vô tình gọi ssh/scp thật (ghi 3 tệp chờ chép), đã tự khai và được ghi lại đúng bằng bước 2 (sự cố ghi ở `nhat-ky/2026-11-10.md`, mục 17:05) |
| WP09-DONG (M3-036) | chạy lại cohort/functional với harness đơn 104 đã sửa, đủ E01–E42 | L1 | `tools/m3-m8-wp09/**` | R3 | CHOT112 | 12/11 | 1 | CHỜ |
| UI-DONG (M3-034/035) | banner giám sát nói "thiếu nguồn" thay "mất dữ liệu"; `/admin/orders/[id]` hết tràn ở 325 px; Playwright thật U13; sửa phần Cần sửa M3-035 | L1 | `front-end/src/features/ivr/**`, trang đơn quản trị (vùng Phúc → báo trước) | R2 | CHOT112 | 12/11 | 0,75 | CHỜ |
| WP10-TAI (M3-037) | bài tải đủ thời lượng + thử Pause/stop-new-calls trên .60 | L1 | `tools/m3-m8-wp10/**` | R2 | LEN60 | 13/11 | 1 | CHỜ |
| M34-VH | runbook bật/tắt/sự cố/quay lui; công tắc khẩn VNPAY/GHN/VTP; correlation-id vào log; cảnh báo cơ bản (BE lỗi, IVR `REVIEW_REQUIRED` sắp tới hạn, D-m34-021); bỏ `SEED_ADMIN_PASSWORD` khỏi env khi không seed | L1 | `deploy/m34/compose.yml`, `application.yml`, `ApiErrorSupport.java`, `logback-spring.xml` | R3 | báo Tài (cờ VNPAY/GHN/VTP) | 13/11 | 2,5 | ĐANG LÀM 11/11 10:05 (Sheet M3-120): tách `wp/M34-VH-OPS.md` (R2: sửa gốc guard tồn demo, công tắc khẩn, runbook, cảnh báo) + `wp/M34-VH-LOG.md` (R3: mã truy vết vào log); tắt seed/đổi mật khẩu admin để runbook, làm trước 30/11 không phải 15/11 |
| M34-RS2 | hậu kiểm R3 gói XII đã vào dev + .60 (V314–V318, 24 task Cần sửa) → danh sách sửa bắt buộc trước 30/11 | L1 (rà) | chỉ đọc | R3 | m34.69 | 13/11 | 1 | CHỜ quyết |
| M3M8-WMS | M3 nạp ảnh tồn M2 (`GET /v1/inventory/stock-balances`) + giữ/trả hàng (`allocations`/`release`), cổng kho Giờ Vàng NK-b/c (gộp M3-111) → điều kiện bật cờ IVR production (D-m34-023) | L1 | `inventory/**`, `OpsCoreAvailabilityHttpAdapter`, `OrderCreateServiceImpl` (vùng Phúc) | R3 | m34.73; M2 `ExternalAllocationCommandV1Endpoints.cs` | 24/11 | 2–3 | CHỜ quyết |
| M3M8-WP11 (M3-038) | lô 10 → 25 → 50 với M8 nhà mạng thật, Toàn trực | L1 | `docs/integration/m3-m8/22-…` | R3 | WMS, M8 nhà mạng, máy thật | 28/11 | 1,5 | CHỜ |
| M34-LIEN | hợp đồng M3↔M7, M3→M6 `ORDER_VERIFIED`, M5→M4 vào `ginsengfood-contracts`; khớp đường M3↔M8 | `lead` (hộp thư) | `ginsengfood-contracts` | R2 | phiên `lead` gỡ dở merge | 20/11 | 1 | CHỜ |
| P-LUONG-KHACH | M3-010 test giao diện xanh, M3-108 `mvnw test` toàn bộ + CI unit xanh, M3-109 khách mới/Silver/Gold mua qua giao diện trên .60 | L2 | `front-end/src/features/{cart,checkout}`, test hỏng | R2 | m34.76; LEN60 | 13/11 | 3–4 | trễ (M3-010 hạn 03/11) |
| P-HUY-DON | M3-110 khách/quản trị huỷ + hoàn tay, gán `ORDER.CANCEL` (migration mới), bật job hết hạn đơn, phát ORDER_CANCELLED | L2 | `OrderStateMachineImpl`, `AdminRefundController`, migration mới | R3 | m34.68 | 20/11 | 3–4 | chờ quy tắc từ 31/10 |
| P-XII-SUA | sửa 24 task Cần sửa + M3-053/058/059, vào dev qua PR | L2 | `admin/**`, `security/**` | R3 | M34-RS2 | 20/11 | 3–5 | Cần sửa |
| P-CTV | chi trả CTV + thuế TNCN, 2 ca `CommissionFloorReferrerCheckoutPostgresTest` đỏ | L2 | `collaborator/**` | R3 | — | 24/11 | 2 | CHƯA |
| T-THANH-TOAN-60 | M3-017 VNPAY sandbox + COD qua giao diện trên .60 (sửa compose qua PR, báo Toàn) | L3 | `deploy/m34/compose.yml` (của Toàn), trang kết quả thanh toán | R3 | thông số sandbox; m34.71 | 12/11 | 2–3 | trễ (hạn 10/11) |
| T-M4-60 | M4-004/007: bật M4 trong `~/m34` bằng cờ (không dựng bản BP thứ hai), 5 câu đầu–cuối, M5 thật gọi M4 | L3 | `deploy/m34/compose.yml` (cờ AI) | R3 | Anh Tuấn mở .60 11/11; m34.74 | 13/11 Go/No-go | 2 | trễ |
| T-VAN-CHUYEN | phí nội bộ + vận đơn tay trên .60, M3-006, chuẩn bị M3-020 (cân 18/19 SKU) | L3 | `CheckoutShippingFeeController`, `shipping/carrier/**` | R2 | LEN60 | 14/11 | 2–3 | CHƯA |
| T-B1 | thẻ `M3-VNPAY-OLD-URL-CANCEL-KILLS-ORDER-001`: link VNPAY cũ không huỷ đơn, không nhả suất Giờ Vàng | L3 | `PaymentWebhookServiceImpl`, `VnpayGatewayAdapter` | R3 | m34.83 | 12/11 (đề xuất), tối đa 28/11 | 1–2 | NẶNG (N1 của RS1): retry tạo link mới rồi huỷ link cũ → đơn FAILED, nhả suất; khách trả link mới → tiền đã thu, đơn FAILED; `OldUrlTesterT1PostgresTest.java:1441` đang khẳng định hành vi sai |
| T-WH + M3-018/019 | kiểm chữ ký webhook GHN/VTP + test; bật VNPAY thật + đối soát treo khi có thông số | L3 | `CarrierWebhookService`, `order/` VNPAY | R3 | m34.70; VNPAY | 28/11 | 2–3 | CHƯA |

**Kiểm chéo:**
- Mọi hạng mục lõi dưới 90 có WP: 1 (P-LUONG-KHACH, M34-NT) · 2 (P-HUY-DON) · 3 (M3-109, P-CTV) · 4 (P-XII-SUA, M34-RS2) · 5 (T-THANH-TOAN-60, T-B1, M34-RS1) · 6 (T-VAN-CHUYEN, T-WH) · 7 (CHOT112, WP09, UI, WP10, WMS, WP11) · 8 (T-M4-60, M34-RS1) · 9 (M3M8-WMS gộp M3-111; m34.71).
- Tệp nóng không chồng: sóng 1 (CHOT112 · NT · RS1 · AN · DB) và sóng 2 (WP09 · UI · WP10 · VH · RS2 · LEN60). `deploy/m34/README.md` chỉ CHOT112 sửa ở sóng 1. `deploy/m34/compose.yml` có ba gói cần sửa: VH (L1), T-THANH-TOAN-60 và T-M4-60 (L3) → Tài gửi PR, Toàn gộp sau VH. M3M8-WMS chung `OrderCreateServiceImpl` với P-HUY-DON → WMS làm sau 20/11.
- Ước lượng so với ngày còn lại (tới 15/11 còn ~4,5 ngày làm việc; tới 30/11 ~20 ngày):
  - **L1:** khoảng 10 ngày-subagent tới 15/11, dồn vào 3 sóng 10–14/11. Được, nếu Toàn duyệt commit, PR, deploy và UAT ngay trong ngày.
  - **L2:** cần khoảng 7 ngày-người tới 15/11, trong khi tốc độ thật là 0 task/ngày từ 03/11 → không thực tế. Bản tối thiểu chỉ trông vào M3-109; nếu Phúc không kịp thì phiên m34 tự chạy luồng khách theo M34-NT. Tới 30/11 cần khoảng 14 ngày-người.
  - **L3:** cần khoảng 7 ngày tới 15/11, Tài còn gộp repo M5/M6 (OWN-335) → không thực tế. Nếu thiếu thời gian thì cắt VNPAY sandbox, giữ COD.

## Đường găng tới mốc A–D

Mốc A 07/11 và B 10/11 **trượt**. B chưa đạt vì chưa có lượt chạy đầu–cuối qua giao diện trên .60, và M4 chưa lên .60.

**Tới 15/11 (bản tối thiểu trên .60):**
1. 11/11 CHOT112 → PR vào dev → 12/11 LEN60 (sau M34-DB). Mọi kiểm bậc 75 phải chạy trên bản build từ commit.
2. 11/11 M34-NT → 13/11 chạy đầu–cuối trên .60 (mốc B dời sang 13/11): khách mới/Silver/Gold đặt qua giao diện, M8 giả lập gọi, COD, vận đơn tay.
3. 11/11 Anh Tuấn mở .60 (SSH, vhost, HTTPS; OWN-334 A1) → 13/11 Go/No-go M4 (T-M4-60).
4. 13/11 M34-VH xong (công tắc khẩn + runbook) → 14/11 Toàn + Chú nghiệm thu theo phiếu (mốc C dời sang 14/11).
5. 15/11 bản tối thiểu chạy trên .60: MOCK, không gọi đối tác thật, không khách thật.

**Tới 30/11 (chạy thật; các mốc theo đề xuất E–H của Phúc, m34.77):**
- 17/11: chốt máy chạy thật, tên miền, HTTPS (m34.72, phiên `lead`).
- 20/11: đóng băng tính năng (XII sửa, huỷ đơn, B1).
- 24/11: M3M8-WMS vào; chạy toàn luồng trên máy chạy thử (bậc 75).
- 27/11: nghiệm thu (bậc 90).
- 28/11: WP11, lô gọi nhà mạng thật.
- 29/11: chuẩn bị release (VNPAY thật nếu có thông số).
- 30/11: chạy thật.

## Đổi DB M2 sang DB sạch 29–30/11 (D-m12-092/093, kế hoạch phía M3: D-m34-095)
- Tới 29/11: M2 chạy Production trên DB hiện tại của .99 (bản sao .61, dữ liệu thử); M3 quan sát → ENFORCE 21–22/11, S01–S18 như kế hoạch.
- **Trước giờ đổi DB (M2 báo giờ T, trước ≥ 1 ngày):** lượt .99 của M3 (Toàn duyệt) tắt giữ hàng (`app.inventory.ops-core.allocation.enabled=false`), `OPS_CORE_GATE_ENFORCE=false`, rồi `OPS_CORE_ENABLED=false` trước T.
  Lý do (mã nhánh chú): hold cũ mất cùng DB cũ; nếu giữ hàng còn bật, `OrderIvrRecallService.keepStock` sẽ giữ lại trên DB mới tồn 0 → `OUT_OF_STOCK` → huỷ đơn đang chờ IVR.
- **Sau khi M2 đổi DB:** đặt tệp secret mới cho principal `SVC-M3-SELLABLE` (tệp, không qua chat) → `OPS_CORE_ENABLED=true` QUAN SÁT (không ENFORCE, không giữ hàng) khi M2 có kho.
- **Khi M2 đã có kho (Toàn nhập qua giao diện):** M2 giao CSV 19 SKU (`sku_code,ops_core_sku_id,uom_code`) + kho mặc định (`ops_core_warehouse_id`, `ops_core_warehouse_code`) → `ops-core/nap-link.sh --thay-the` chạy khô rồi ghi (Toàn duyệt), kiểm `ket_luan=DAT`.
- **Khi có tồn đầu kỳ:** kiểm bán được cho 19 SKU ở chế độ quan sát → dọn dòng `ops_core_reservations` còn mở trỏ hold DB cũ (cách xử lý 404 của bộ đối soát: CHƯA KIỂM) → bật lại giữ hàng + ENFORCE (Toàn duyệt). Trước đó M3 bán như chưa nối M12.
- Cần M2: giữ nguyên 19 `sku_code` và đơn vị (khoá đơn vị V347) để nạp lại chỉ đổi UUID; báo giờ T trước ≥ 1 ngày; báo nếu secret ký webhook M12 → M3 đổi theo DB mới.

## Việc ngoài code (phiên `lead` gom về `modules/lead/VIEC_NGOAI.md`)

| Việc | Ai gỡ | Cần trước ngày | Trạng thái |
|---|---|---|---|
| Mở .60 cho M5/M4: khoá SSH, vhost, HTTPS, tên miền con | Anh Tuấn; Toàn duyệt | 11/11 | OWN-334 A1 đồng ý, chưa xác nhận xong |
| Máy chạy thật M3/M4 + tên miền `ginsengfood.vn`/`admin.` + IP tĩnh (D-lead-028/029) | Toàn (`lead`), Anh Tuấn DNS | 17/11 | chờ Anh Tuấn trả lời đường vào |
| Đổi mật khẩu admin .60 (lộ trong chat Codex 09/11; nằm trong env `be`) | Toàn | 11/11 | chưa |
| Thông số VNPAY chạy thật + danh sách IP | VNPAY; Tài theo dõi | 28/11 (m34.70 A) | đã gửi biên bản SIT #988, chờ |
| Báo giá GHN, quyết triển khai | chị Lan; Tài | 21/11 | chờ |
| Viettel Post cần web trên tên miền chính thức | Toàn/bên web | sau khi có tên miền | chờ |
| Hợp đồng SPX | chị Lan | sau 30/11 | chờ |
| Cân + kích thước 18/19 SKU | xưởng; Tài | 21/11 | thiếu (M3-020) |
| Người duyệt an toàn sức khoẻ M4; bác sĩ duyệt thai sản | Toàn (m34.7) | 13/11 | chưa có người |
| Credit Claude M4 | Tài | — | XONG: khoá gọi được từ 10/11 08:33 (OWN-334) |
| M8 nhà mạng thật (SIM, giấy định danh tên công ty) | phiên `m8`/`lead` | 25/11 | theo sổ m8 |

## Không kịp 15/11 + bản tối thiểu chạy được 15/11

**Không kịp 15/11 (dời 16–30/11, vẫn xong trước 30/11):** khách tự huỷ + hoàn tiền (P-HUY-DON) · sửa XII (P-XII-SUA) · CTV chi trả/thuế ·
ảnh tồn WMS + cổng kho Giờ Vàng (M3M8-WMS) · VNPAY thật + đối soát · GHN/VTP cho khách thật · gọi nhà mạng thật (WP11) · hợp đồng liên module (M34-LIEN) ·
M4 cho khách thật · CI front-end. Sau 30/11: SPX, thai sản đầy đủ, chat web công khai M4.

**Bản tối thiểu 15/11** (trên .60, MOCK, không khách thật; theo m34.8 A, m34.9 A, m34.10, m34.13 A, m34.14 — D-m34-033):
- Web: xem sản phẩm, giỏ, khách vãng lai đặt hàng với OTP giả trên .60 (SKU demo, cron làm mới tồn), quản trị đơn thủ công. **Huỷ đơn: chưa có** — không có nút "Hủy đơn" cho quản trị (chỉ huỷ vận đơn ở hãng và "Từ chối IVR", nút này ẩn với đơn do M8 quản lý và gửi thiếu lý do mà máy chủ bắt buộc; phiếu `nghiem-thu/M34-NT.md` bước C3); khách tự huỷ cũng chưa có. Cả hai thuộc P-HUY-DON (M3-110) — thử kéo vào trước 15/11 nếu m34.68 chốt sớm (m34.78).
- Thanh toán: COD; VNPAY sandbox nếu T-THANH-TOAN-60 xong; Giờ Vàng theo m34.71.
- Vận chuyển: phí nội bộ + vận đơn nhập tay.
- Gọi xác nhận: M8 giả lập gọi mọi đơn, công tắc Pause/stop-new-calls, Toàn trực.
- M4: M5 gọi M4 trên .60 sau cờ nếu Go/No-go 13/11 đạt; câu không chắc, hỏi giá, đặt hàng, thai sản → chuyển nhân viên.
- Điều kiện: CHOT112 + LEN60 trước 12/11 · phiếu M34-NT 11/11 · .60 mở cho M5/M4 11/11 · M34-VH 13/11.
