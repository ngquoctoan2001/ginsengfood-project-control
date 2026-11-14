# Bàn giao nối M12 ↔ M3 (phía M3) cho Phúc — 14/11/2026

Người viết: phiên m34 (Claude làm cho Toàn), từ 12/11 tới sáng 14/11. Từ nay Phúc làm tiếp phần M3 của việc nối; Toàn chỉ phụ trách M12. Mọi con số dưới đây lấy từ git, Sheet và hộp thư m12 ngày 13–14/11; chỗ chưa kiểm ghi rõ.

## 1. Tình hình trong 10 dòng
1. **Chế độ nối:** QUAN SÁT (M3 đọc M12, hỏi "bán được không", chưa chặn bán, chưa giữ hàng ở M12). Mọi công tắc nguy hiểm tắt mặc định.
2. **Nhánh (14/11 ~08:30):** `dev` = `toandeptrai` = `9bc855de8`, giống hệt nhau ở local và trên GitHub. Đây là bản gộp lần 4: `toandeptrai` (26 commit của m34) + `dev` sáng nay của Phúc (15 commit, 431 tệp: seed-packs, AEC-T1, M3-173…). Một xung đột ở `SkuUnitLockAndMasterAuditPostgresTest` đã giải quyết; `V349_1` của m34 đã BỎ vì `V357` của Phúc gỡ trigger ngược lại (để cả hai thì `config_audit_logs` mất chốt chặn TRUNCATE). **Bản gộp CHƯA chạy test** (Toàn bảo bỏ test để nhanh; 5 lớp Postgres/migration ở mục 6 nên chạy sau). CI `m34-images` đang chạy cho `9bc855de8` trên cả hai nhánh; lượt trước xanh cho `719574370` và `5f091e9d8`.
3. **M12:** chạy ở máy `.99` từ 19:15 13/11 (bản thử WP16, Development, dữ liệu chép từ `.61`); `.61` đã dừng hẳn. Cổng `.99:5000` chỉ mở cho `.60` và `.98`.
4. **M3:** `.60` đang chạy `f9e179a4` với ops-core TẮT. Gói M3 cắt sang `.99` tối 14/11 22:45–00:15 (phiên phụ "m34 phụ" làm; bàn giao: `nm3/BAN-GIAO-CHUYEN-99.md`).
5. **Hợp đồng M12 mới:** nhánh local của m12 `m12-final-draft` (`1e73bc1`, 13/11 20:02) CHƯA lên origin; `origin/main` của `ginsengfood-contracts` vẫn `a7832a4`, M3 đang ghim `a7832a49`. Rà phía M3: không có điểm nào phá M3 (`nm3/NM3-32b-…md`, `nm3/NM3-32c-…md`).
6. **Số gói:** 32/43 gói của luồng ở trạng thái REVIEW (Sheet), 1 huỷ (NM3-53), 9 chưa bắt đầu (đều chờ người khác hoặc mốc ngày, mục 5).
7. **Trần giữ hàng M12:** 200 hold/principal; M3 giữ theo DÒNG đơn nên 1 dòng = 1 hold; hold `CONFIRMED` vẫn chiếm trần tới khi xuất kho (D-m34-067). Chưa có số đơn cao điểm để đối chiếu.
8. **Đã đẩy `dev` và `toandeptrai` lên `9bc855de8`** (Toàn duyệt 14/11); Phúc chỉ cần `git pull`. Chưa chạm `.60`/`.99`, chưa đổi cờ nào.
9. **Không gọi được M12 thật từ máy Phúc:** cổng `.99:5000` chỉ mở cho `.60/.98`, và allowlist ứng dụng `/v1` ở `.99` hiện không giới hạn nên tường lửa là rào duy nhất; m12 dặn đừng mở rộng cho IP máy dev. Principal riêng cho máy dev chưa tạo được hôm nay (m12 trả lời 14/11).
10. **Có sẵn tin 13/11** gửi Phúc về gộp `dev` (`nm3/tin-nhap-phuc-sau-gop-dev.md`, Toàn đã gửi): các câu hỏi còn mở ở mục 6.

## 2. Đã làm (theo gói; commit trong `origin/toandeptrai`, xem `git log --oneline origin/dev..origin/toandeptrai`)
Kiểm độc lập (verifier) cho gói R2/R3; test theo từng gói, không chạy bộ đủ. Số V = migration (dải m34 `V340–V349`; Phúc dùng V350–V355; Flyway `out-of-order: true`).

| Gói (mã Sheet) | Việc | Commit | Migration | Ghi chú kiểm |
|---|---|---|---|---|
| KHO-M3-13, SKU-M3-06 | Tài liệu đặc tả quản lý kho ngoài / SKU | `44ac63978` | | tài liệu |
| NM3-13 | compose đọc `OPS_CORE_*` từ `.env`, `trien-khai.sh` kiểm trước, `lam-moi-ton-thu.sh` cho phép `ENABLED=true` khi `enforce=false` | `7e52fd671` | | test Python |
| KHO-M3-01/02/03 | Chế độ kho ngoài M12 (`INVENTORY_EXTERNAL_MANAGEMENT_ENABLED`, mặc định tắt) + `InventoryExternalManagementWiringTest` | `68b8d91a9` | | |
| (runbook) | `deploy/m34/ops-core/SKU_MOI.md`, `NOI_M12.md` | `0f29215d0` | | |
| NM3-51a | Webhook M12 → M3 `POST /internal/ops-core/events` (HMAC-SHA256, ≤64 KiB, lệch giờ ≤300 s, dedupe theo `X-Outbox-Event-Id`, khoá bằng tệp) | `4fdfbabc5` | V344 inbox | verifier; sửa thêm `c1c8ad279`, `719574370` (eventType sai/thiếu → 2xx bỏ qua) |
| KHO-M3-05, NM3-54 | FE màn quản trị kho / liên kết | `64d65e873` | | |
| SKU-M3-10 | `go-sku-demo.sh` + `GO_SKU_DEMO.md` (gỡ SKU/lớp phủ demo NGAY TRƯỚC ENFORCE) | `4949158a3` | | `test_go_sku_demo.py` |
| SKU-M3-02 | Chặn xoá/TRUNCATE + ghi audit bảng link SKU/kho | `11ba1e92d` | V340 | |
| NM3-40/41 | Giữ hàng NK-b: sổ `ops_core_reservations`, UUIDv5 (`order:<id>`, `order-item:<id>`, namespace `f13ae28e-…`), khoá `m3:rsv:<orderId>:<n>`, 429/409/422 theo hợp đồng | `6b19d621c` | V342 | cờ `app.inventory.ops-core.allocation.enabled` TẮT; cần `gate.enforce` |
| SEC-16, SKU-M3-04 | Gia cố + kiểm link | `a76433601` | | |
| NM3-31 | `deploy/m34/ops-core/dong-bo-ton.py` đồng bộ tồn M12 → M3 (`qty_available` = available của M12) + `DONG_BO_TON.md` | `95f73875c` | | chưa cài cron |
| (nginx, cảnh báo) | Location webhook, biến bí mật, luật `CONG_TON_M12` ở `canh-bao.sh` | `89c49086d` | | |
| KHO-M3-08/10 | CHECK số lượng | `807ef45d6` | V346 | |
| SKU-M3-11/12 | Khoá đơn vị, audit master SKU | `2db28d2a1` | V347, V348 | V348 có trigger chặn TRUNCATE trùng V355 → Phúc gỡ bản V355 bằng `V357` (giữ V348); `V349_1` của m34 đã bỏ |
| SKU-M3-03 | Vòng đời SKU từ M12 (8 giá trị), đối soát | `b2484b5d5`, `05127f44e` | V349 | cờ `APP_INVENTORY_OPSCORE_LIFECYCLE_ENABLED` TẮT |
| NM3-42 | Móc giữ hàng vào tạo đơn / máy trạng thái / giao hàng; bulkhead `hold-max-concurrent` 3, nhả `release-max-concurrent` 2; IVR: đơn M12 giữ còn sống ⇒ cho qua, không rõ ⇒ UNKNOWN, không BLOCK | `382d842ee`, `d789e53aa` | | cờ giữ hàng TẮT |
| SKU-M3-05 | Màn "Liên kết M12" | `1f725e173` | | Phúc đang gỡ menu (xem mục 6) |
| SEC-09 | Bí mật qua TỆP (`*_FILE`), không để trong `.env` | `8daaafe1c` | | thứ tự triển khai: README mục 12.2 |
| SEC-15 | Trần giữ hàng: 3 hold chưa trả/khách, 10/giờ/IP, 100 hộp/dòng (`ORDER_HOLD_LINE_QUANTITY_EXCEEDED`) | `bf3083f33` | | |
| QD-13-11/A, B | Quyền `INVENTORY.VIEW` cho màn Liên kết M12; cảnh báo `HOLD_HET_HAN` (log `OPS_CORE_HOLD_EXPIRED_BEFORE_FULFILLED`) | `cbc17826a`, `edf5bf57b` | | |
| AUDIT-FIX | actor SYSTEM khi khởi động, `productNameVi` trong audit | `6b5ce1a48` | | `InventoryAuditSubjectLabelPostgresTest` |
| NM3-50 (P2) | Chặn tạo/xuất bản phiên Giờ Vàng khi ENFORCE mà chưa có giữ hàng Giờ Vàng; log `GOLDEN_HOUR_OPS_CORE_HOLD_NOT_READY` | `c4ce67902` | | P1 chỉ làm nếu Giờ Vàng phải chạy ở ENFORCE |
| SEC-22/A | Spring Boot 4.0.5→4.0.9, httpcore5/httpclient5, next/axios/vite | `94e3abd0e` | | phần còn lại ở mục 5 |
| Gộp `dev` ×4 + sửa | `e5c07719d`, `f2b73c41c`, `c202f442b`, `128ed05c0` (lần 4); `f9e179a45` (CI khuôn), `2d35e96f1`, `d08273f71` (V349_1 + 2 test, V349_1 bỏ ở `9bc855de8`) | | | 3 lượt đầu có kiểm gộp A–E (biên dịch, backend, Flyway V1→V355, FE, Python trong Linux): không có đỏ mới do gộp; lượt 4 chỉ kiểm xung đột, chưa chạy test |
| NM3-32b/32c | Rà hợp đồng M12 phía M3 (chỉ đọc) + sửa lệch phía M3 (không replay HTTP 500, chờ 429 ≤2 lần/30 s, webhook eventType) | `c1c8ad279`, `719574370` | | Java 179/179, Python 52+71+15 đạt; CI xanh |

## 3. Cách chạy ở chế độ quan sát (đừng đổi cờ khác)
- Biến: `OPS_CORE_ENABLED=true`, `OPS_CORE_GATE_ENFORCE=false`, `OPS_CORE_CLIENT_ID=SVC-M3-SELLABLE`, `OPS_CORE_ALLOW_PLAIN_HTTP=true` (LAN dùng http), `OPS_CORE_BASE_URL=http://192.168.1.99:5000`. Bí mật chỉ qua tệp (`secrets/ops_core_client_secret`, webhook: `ops_core_webhook_secret` + `_previous`); image `be` phải có SEC-09 (SHA ≥ `8daaafe1c`) trước hoặc cùng lúc compose mới.
- **Không bật khi Toàn chưa nói đúng việc:** `OPS_CORE_GATE_ENFORCE`, `OPS_CORE_ALLOCATION_ENABLED`, `APP_INVENTORY_OPSCORE_LIFECYCLE_ENABLED`. ENFORCE chỉ từ 20/11, sau kết luận quan sát cổng Q1 (D-m34-063).
- Tài liệu: `deploy/m34/ops-core/NOI_M12.md` (sự cố, biến, webhook), `NAP_LINK.md` (nạp link SKU/kho, chạy khô rồi `--ap-dung`), `SKU_MOI.md`, `DONG_BO_TON.md`, `GO_SKU_DEMO.md`; README `deploy/m34` mục 12.
- **Thử trên máy dev:** không gọi được M12 thật (mục 1 dòng 9). Làm được: test đơn vị và hợp đồng, fixture, Flyway. Quan sát thật chỉ có sau khi M3 lên `.99` (nguồn đã được phép) và Toàn xoay secret dev của principal `SVC-M3-SELLABLE` (m12 gọi là N21).

## 4. Quyết định đã chốt (đã ghi `modules/m34/QUYET_DINH.md`)
- **D-m34-063 (10 việc):** giữ hàng ≤55 phút (M3 gửi 54:30); hằng UUIDv5; SEC-15 như bảng trên; IVR như dòng NM3-42; màn Liên kết dùng `INVENTORY.VIEW`; tồn đồng bộ = available của M12; gỡ lớp phủ demo ngay trước ENFORCE; webhook nginx `allow` chờ m12 xác nhận đường gọi; Trivy chưa chặn CI tới khi sạch; tách user Unix/role DB sau 30/11.
- **D-m34-066:** hợp đồng SKU-M12-03 theo phương án A (m12 viết vào `m12-noi-m3`, đóng băng khoảng 20/11); NM3-53 huỷ; KHO-M3-07 hoãn tới ENFORCE ≥ 20/11; NM3-73 do phiên phụ chuyển máy.
- **D-m34-067:** trần số hold: ưu tiên chỉ đếm `RESERVED` chưa hết hạn (CONFIRMED chịu trần tỷ lệ tồn 80%/sàn 50); nếu m12 chưa kịp thì tạm nâng trần của principal M3 lên 1000 bằng cấu hình.

## 5. Việc còn lại cho Phúc (theo thứ tự; cột "chờ" là điều kiện bắt đầu)
| # | Việc | Chờ |
|---|---|---|
| 1 | `git pull` (`dev` = `toandeptrai` = `9bc855de8`); chạy 5 lớp test đã nêu ở mục 6 trên bản gộp; tiếp tục commit trên nhánh của Phúc | — |
| 2 | **NM3-14 → NM3-21b:** nạp link SKU/kho cho `.99` (`NAP_LINK.md`; `skus.csv` 3 cột 19 SKU; `kho.csv` đúng một dòng `mac_dinh=true`) rồi `kiem-link-m3.sh` của m12 | M3 lên `.99`; m12 xuất CSV bằng lệnh chỉ đọc (`go-live-cutover-plan.md` mục C-M3-3 bước 3, Toàn chạy); mã kho thật chờ Lan nhập kho |
| 3 | **Đo IP nguồn M3 → M12 trên `.99`** trong cửa sổ cắt rồi báo m12 đặt `M12_SOURCE_ALLOWLIST_2` đúng /32 (không đoán; hiện giữ chỗ `192.168.1.60/32`) | cắt `.99` |
| 4 | **NM3-30:** quan sát 48–72 giờ, báo khớp/lệch mỗi ngày; kết luận cổng Q1 | sau 2, 3 |
| 5 | **NM3-34:** ghim hợp đồng mới (thay `a7832a49`) + **NM3-15b** làm tươi fixture (6 `allocation-*.fixture.json` + `inventory-allocations.issued.response.json`), thêm bộ đọc phân trang `GET /v1/skus` (kéo gia tăng 5', biên chồng 5', đọc đủ khi khởi động và ≥24 giờ), mở rộng `OpsCoreSkuLifecycleResponseParser` (`updated_at`, `revision`, `sellable_uoms`) | m12 đóng băng và push hợp đồng (Toàn nói lệnh push) |
| 6 | Thu hẹp `chk_ocsl_uom` còn hộp/thùng | m12 trả lời `/check` với `uom_code` ngoài trade item (C6) |
| 7 | **DIET-4** (nhãn "Thuần chay" 4 SKU, test đối chiếu `dietary_type`) | DIET-2 (Toàn + chú Dũng), DIET-1 (m12) |
| 8 | **KHO-M3-07** (IVR/M8 đọc verdict ops-core) | ENFORCE ≥ 20/11; không làm trước UAT M8 14/11 |
| 9 | Bật ENFORCE, giữ hàng, vòng đời, gỡ demo (`go-sku-demo.sh`) | ≥ 20/11, Toàn nói từng việc; trước đó chốt số hold cao điểm (D-m34-067) |
| 10 | SEC-22 phần còn lại (Dockerfile FE 35 lỗ hổng OS + npm 10, ghim digest/cosign, sao lưu; Trivy chặn khi sạch); NM3-50 P1 nếu Giờ Vàng phải chạy ở ENFORCE; test "thanh toán thành công sau khi hold M12 hết hạn" (chưa có) | |
| — | **Toàn tự làm (cần ssh):** SKU-M3-08 (giá thật trên `.60`, chỉ đọc), NM3-10 (kiểm mạng đích `.99:5000`) | |

## 6. Vấn đề mở / câu hỏi đã gửi Phúc (tin 13/11) nếu chưa trả lời
- **Chưa kiểm bản gộp `9bc855de8`:** nên chạy `SkuUnitLockAndMasterAuditPostgresTest`, `AuditLogAppendOnlyPostgresTest`, `OrderIvrMigrationPostgresTest`, `OpsCoreLinkAuditPostgresTest`, `OpsCoreMigrationContractTest` (Postgres/Docker; `-P ci-integration`) và xem `config_audit_logs` còn đúng một trigger BEFORE TRUNCATE (V348). Trước khi bỏ `V349_1`, `OrderIvrMigrationPostgresTest` đã được m34 sửa để đo quyền IVR ở mốc V263 (còn trong bản gộp).
- Test đỏ có sẵn trên `dev` (không do m34): `StandardPacks*`, `GoldenHourRulesPolicyGuardMigrationContractTest` (thang số migration), `proxy.test.ts`, `StorefrontHeader`, `M4DifferentialReadOnlyRunnerTest` (498 vs 480), test hoa hồng của Mạnh (T-857), ArchUnit `ModuleBoundaryArchitectureTest` (2/51/4 dòng). Chủ: Phúc/Tài.
- Overload `AuditLogPort` thiếu requestId/correlationId; đọc `X-Forwarded-For` thô ở vài chỗ.
- Giờ Vàng: giao hàng 422 "allocation is missing" với đơn Giờ Vàng; trạng thái VNPAY; ý nghĩa `chain-slack`; quota; đếm trùng với `dong-bo-ton.py`.
- Menu "Liên kết M12": Phúc đã báo gỡ menu, chuyển thông tin M12 vào Quản trị kho và Quản trị mã SKU chuẩn, đổi quyền FE sang `INVENTORY.VIEW` (khớp `cbc17826a`), giữ trang cũ tới khi `toandeptrai` vào `dev` (Sheet M3-151).
- Email admin: `application.yml` mặc định `auth.admin-email-domains=ssavigroup.com`, nhưng admin seed `admin@ginsengfood.local` và compose `deploy/m34` không truyền `ADMIN_ALLOWED_EMAIL_DOMAINS` ⇒ admin có thể không vào được trang quản trị (phiên phụ sửa lúc cắt, hoặc Phúc quyết).
- Số lượng lẻ: M12 cho tối đa 3 chữ số thập phân; M3 từ chối số lẻ (chặn bán) tới khi m12 báo có validator số nguyên.

## 7. Ai làm gì
- **Phúc:** phần M3 của việc nối (bảng mục 5), UI, `dev`. **Tài:** M3 vận chuyển + thanh toán, M4. **Toàn:** M12 (hợp đồng, principal, kho, `.99`), duyệt mọi lệnh `ssh/scp`, push, đổi cờ production.
- **m12 (Claude):** hợp đồng, nhánh `m12-final-draft`; đang kiểm bằng mã các câu C2–C10. Cần Toàn: push hợp đồng, xoay secret dev (N21), xuất CSV, mở cổng.
- **Phiên phụ chuyển máy `.99`:** cắt gói M3 (`deploy/m34`), đo nguồn IP, nginx webhook, email admin; đừng sửa `deploy/m34` song song.

## 8. Tệp tham chiếu (máy Toàn: `C:\Projects\Project Control\modules\m34\`)
`TRANG_THAI.md`, `QUYET_DINH.md`, `nhat-ky/2026-11-12.md`, `nhat-ky/2026-11-13.md`, `nm3/NM3-32b-ra-hop-dong-m12.md`, `nm3/NM3-32c-ra-lai-hop-dong-m12-final-draft.md` (mục F: trả lời C1–C11 của m12), `nm3/BAN-GIAO-CHUYEN-99.md`, `nm3/LEN60-M3-LENH-DUYET-MOT-LUOT.md` (lệnh viết cho `.60`, đọc đổi máy đích sang `.99`), `wp/SONG-NOI-M12-12-11.md`. Trong repo: `docs/integration/module-3/11-11-15-00-ke-hoach-noi-m12-m3.md` và `…17-45-ke-hoach-chi-tiet-2-repo-sau-ra-soat.md`.

## 9. Trả lời 5 câu Phúc hỏi sáng 14/11 (thử nối M3 ↔ M12 trên máy dev)
1. **Bảng 19 SKU và kho mặc định:** chưa có bản chính thức. `skus.csv` (3 cột `sku_code,ops_core_sku_id,uom_code`, 19 SKU hộp/thùng) xuất bằng lệnh chỉ đọc có sẵn của m12 (`go-live-cutover-plan.md` mục C-M3-3 bước 3) trên `.99` (cần ssh, Toàn duyệt); mã kho M12 chính thức chờ chị Lan nhập kho nên đợt đầu là bản thử. Kho nào ghép với kho M12 mặc định: kho bán chính của M3 ghép với kho thành phẩm mặc định (`FINISHED_GOODS` + `ACTIVE`) của M12, `mac_dinh=true`; mức quan sát không chặn bán nên ghép thử sai không ảnh hưởng, nạp lại bằng `--thay-the` (`NAP_LINK.md`).
2. **Gọi thẳng M12 từ máy dev:** không. M12 ở `192.168.1.99:5000` (WP16 Development, dữ liệu chép từ `.61`, `.61` dừng hẳn); cổng chỉ mở cho `.60` và `.98`, allowlist ứng dụng `/v1` ở `.99` hiện không giới hạn nên tường lửa là rào duy nhất; m12 dặn không mở cho IP máy dev. Bộ chạy M12 cục bộ cho máy dev: m12 sẽ làm (D-m34-069), chưa có ngày.
3. **Tài khoản riêng cho máy dev:** `.99` chưa có công cụ tạo principal; bộ chạy cục bộ của m12 sẽ kèm một principal thử chỉ dùng localhost. Bí mật chỉ qua tệp (`secrets/ops_core_client_secret`), không dán chat.
4. **http hay https:** M3 → M12 trong LAN chạy http với `OPS_CORE_ALLOW_PLAIN_HTTP=true`. M12 → M3 (webhook) khi chạy thật bắt buộc https, cổng 443, tên miền. Chuyển M3 → M12 sang https khi có tên miền thật: chưa chốt, chưa cần cho giai đoạn này.
5. **`.60` đang ở mức nào:** `f9e179a4`, ops-core TẮT (không quan sát, không chặn), theo sổ 13/11; tối 14/11 gói M3 sang `.99` với bản mới ở chế độ quan sát (`ENABLED=true`, `GATE_ENFORCE=false`).
