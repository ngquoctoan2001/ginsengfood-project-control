# Kế hoạch triển khai chi tiết sau rà soát — repo ops-core (M12) và business-platform (M3)

Trạng thái: **KẾ HOẠCH CHUẨN, SẴN SÀNG LÀM SONG SONG HAI PHIÊN** (11/11/2026 ~17:45) · Soạn: phiên `m12` · **Toàn chịu trách nhiệm cả hai repo** · Phiên `m12` làm repo `ginsengfood-ops-core`; phiên `m34` làm repo `ginsengfood-business-platform` (nhánh `toandeptrai`); hai phiên nhắn nhau (`SendMessage`, hộp thư `hop-thu/m12-m34-*`).
Mục tiêu: sau khi xong các task trong danh sách này thì **M3 gọi M12 thành công và an toàn** (kiểm bán được, kéo tồn, giữ/nhả hàng, thu hồi; dữ liệu SKU/kho nhất quán; bảo mật đạt các điều kiện cổng ở mục 6).
Kế hoạch gốc nối M12–M3: `11-11-15-00-ke-hoach-noi-m12-m3.md` (gói `NM3-*`). Tài liệu này bổ sung kết quả rà soát màn hình quản trị kho, quản trị SKU chuẩn và bảo mật (phụ lục `noi-m3-phu-luc/PL-F` SKU, `PL-G` kho, `PL-H` bảo mật) và quyết định `D-m12-055` (nhãn chay). Mọi task nằm trên Sheet, người phụ trách **Nguyễn Quốc Toàn**; mã task Sheet ở cột "Sheet" (`M12-xxx` phía m12, `M3-xxx` phía m34).

## 1. Kết quả rà soát (tóm tắt)

| Mảng | Điều quan trọng nhất | Việc chính |
|---|---|---|
| Kho (PL-G) | M3 đã có khoá "kho do hệ thống ngoài quản" nhưng chỉ theo từng hàng `WMS_API` và chỉ có hiệu lực khi `gate.enforce=true`; chế độ quan sát 15/11 vẫn cho nhập/điều chỉnh tay; bật/tắt kho ghi đè bản chiếu ops-core; M8/IVR đọc bảng chưa ai nạp; không có màn hình/audit cho liên kết | `KHO-M3-01..08, 10, 13`; `KHO-M12-02, 03` |
| SKU chuẩn (PL-F) | Mã chuẩn 19/19 giống từng byte nhưng bảng link không kiểm được đúng SKU (link đảo chéo vẫn qua, `verified_at` không ai ghi, nạp bằng script không dấu vết); M3 không biết SKU bị `INACTIVE/RETIRED` ở M12; hai bên cùng tự coi là nơi sinh mã; sau cutover DB sạch mọi `/check` ra `SKU_ACTIVATION_NOT_ACTIVE` | `SKU-M3-*`, `SKU-M12-*`, `NM3-12b` |
| Nhãn chay | Nhãn "Thuần chay" của M3 cho 4 SKU **đúng theo chủ** (`D-m12-055`); nhưng công thức M12 của 4 SKU còn lòng trắng trứng nên `VeganGuard` chặn đổi `sku_type` | `DIET-1..4` (chờ `DIET-2`) |
| Bảo mật (PL-H) | 3 lỗ **Cao**: Caddy `.61` tin `X-Forwarded-For` của cả `/24` (vô hiệu hạn mức và allowlist); gắn `ops-core-api` thẳng vào mạng chung cho M3 chạm cả bề mặt ẩn danh của M12; giữ hàng không có trần theo principal trong khi M3 cho đặt đơn ẩn danh. 26 khoảng trống, 25 việc `SEC-*` | `SEC-01..25` |

## 2. Quyết định

Đã chốt: **`D-m12-054`** (Q1–Q10 của kế hoạch nối) và **`D-m12-055`** (4 SKU chay; thực thi chờ `DIET-2`). Các quyết định dưới đây là **đề xuất của người rà soát**; phiên m12 và m34 **áp dụng mặc định theo đề xuất** cho việc không đổi hướng, Toàn sửa nếu muốn khác (task `QD-RS`, `M12-067`).

| Mã | Quyết định | Đề xuất (mặc định) | Ảnh hưởng nếu khác |
|---|---|---|---|
| KHO-C1 | Giai đoạn 15–27/11 khi M12 là nguồn tồn: có cho nhập/điều chỉnh tồn tay ở M3 không | **Khoá** (cờ `KHO-M3-01`), ngoại lệ khẩn cần quyền riêng + lý do + audit | Cho nhập tay ⇒ ghi đôi/lệch sổ với script đồng bộ (Q2) |
| KHO-C2 | Kế hoạch M12–M3 (UUIDv5, webhook + inbox, giữ hàng M12) so với ghi chú chủ M3 29/08 (mapping, Kafka, shadow/canary) | Giữ kế hoạch; coi 48–72 giờ quan sát (Q1) là "shadow"; ghi chính thức vào decision log M3 (`KHO-M3-13`) | Theo ghi chú cũ ⇒ làm lại Q8, §4.8 của kế hoạch nối |
| KHO-C3 | Cờ khoá tồn dùng `gate.enforce` hay cờ riêng | **Cờ riêng** | Dùng `enforce` ⇒ không thể khoá tồn trước khi bật chặn bán |
| KHO-C4 | IVR/M8 đọc nguồn nào | Verdict ops-core (đã có poller) | Snapshot N12 cần client chưa có |
| rs2.2 | SKU `INACTIVE/RETIRED` hoặc lệch mã ở M12 có chặn bán ở M3 khi `ENFORCE=false` | **Có** (ngoại lệ của Q1: quyết định vĩnh viễn, rủi ro chặn oan thấp) | Không ⇒ bán SKU đã ngừng trong chế độ quan sát |
| rs2.3 | Ai sinh mã SKU mới | **M12 sinh**, M3 nhận bằng quy trình hai bước (`SKU-M3-13`) | M3 sinh trước ⇒ trái hợp đồng chung PACK-02 §11.5 |
| rs2.4 | Duyệt spec `P2-44` (vòng đời SKU do ops-core cung cấp, M3 kéo `GET /v1/skus/{id}`, chặn tại cổng, không cascade) | Duyệt | Treo `M3-025` và OD-06 |
| rs2.5 | Vai DB riêng cho script nạp link + trigger audit | Duyệt | Ai có quyền DB sửa link không để lại dấu vết |
| SEC-03a | Cách nối mạng khi gộp máy | **Cổng `/v1`-only** (Caddy listener riêng trên `ops-internal`); không gắn `ops-core-api` trực tiếp; subnet ghim; chỉ hai container | Gắn thẳng ⇒ `be` (nhìn ra Internet) chạm cả đăng nhập admin và trace |
| SEC-06 | Quyền thừa của `SVC-M3-SELLABLE` | Bỏ `WAREHOUSE_RECEIPT_VIEW`, `SELLABLE_STATUS_VIEW` khỏi principal Production | Giữ ⇒ mặt tấn công thừa |
| Q4′ | Hạn giữ hàng khi đơn chưa thanh toán | **30–60 phút** rồi gia hạn theo bước xác nhận/thanh toán (sửa Q4 "24 giờ") | 24 giờ ⇒ đơn rác khoá cạn kho (GAP-03) |
| DIET-2 | Công thức thật 4 SKU chay | Toàn + chú Dũng chọn A/B/C | Chưa chọn ⇒ không sửa dữ liệu, không dán nhãn chay |

## 3. Cách chạy song song hai phiên

- **Ranh giới:** mỗi phiên chỉ ghi repo của mình. Phiên `m12`: `ginsengfood-ops-core`, worktree hợp đồng `_wt/m12/contracts-noi-m3`, vận hành `.61`. Phiên `m34`: `ginsengfood-business-platform` nhánh `toandeptrai`, cấu hình `.60`. Việc "m12+m34" chia theo repo: mỗi bên làm phần của mình, chung một mã Sheet.
- **Chế độ làm:** mỗi phiên dùng sub-agent cho việc độc lập (tối đa ~3 agent nặng cùng lúc, chạy test nặng đơn lẻ vì cạn cổng TCP); phiên chính commit theo đường dẫn, giữ sổ, cập nhật Sheet ngay sau mỗi gói; mức R1/R2/R3 theo luật repo đích, người viết không tự chấm; không `SKIP/NOT_RUN` tính đạt.
- **An toàn chung:** lệnh vào `.60`/`.61`, bật cờ, đổi secret/khoá, push, đổi principal đều cần Toàn duyệt từng lần; không đưa bí mật vào tin nhắn/repo/nhật ký; không dùng dữ liệu khách thật khi thử.
- **Điểm hẹn giữa hai phiên (ai chờ ai):**

| Phiên m34 cần từ m12 | Gói | Phiên m12 cần từ m34 | Gói |
|---|---|---|---|
| Bảng ánh xạ SKU/kho (đã giao) | NM3-12a | Compose `.60` quan sát đã deploy | NM3-13 → NM3-14 |
| Định nghĩa `available/sellable`, số nguyên cho hộp | KHO-M12-03 → NM3-31 | Fixture làm tươi + test hợp đồng | NM3-15b |
| Hợp đồng publish (release, `ISSUED`, webhook, UUID) | NM3-32 → NM3-34, NM3-51a | Bên nhận webhook thật | NM3-51a → NM3-51b |
| `GET /v1/skus` + `updated_at` | SKU-M12-03 → SKU-M3-03, SKU-M3-13 | NK-b xong để chạy E2E | NM3-40..42 → NM3-45b |
| WP07b + trần giữ hàng (`SEC-14`) | NM3-33 → NM3-40 | Trả lời quyết định `SEC-15` (hạn giữ) | SEC-15 → SEC-14 |
| Phân loại chay sau `DIET-1` | DIET-1 → DIET-4 | Link nạp xong (m12 chạy công cụ kiểm link) | NM3-12b → SKU-M12-11 → NM3-21b |

## 4. Repo `ginsengfood-ops-core` (phiên m12): 54 task, khoảng 189 giờ

**G0 · trước và quanh cutover (12–15/11)**

| Mã | Sheet | Phiên | Việc | Hạn | Phụ thuộc | Mức | Đạt khi | Trạng thái |
|---|---|---|---|---|---|---|---|---|
| NM3-00 | M12-032 | m12 | Chốt Q1–Q10 kế hoạch nối M12↔M3 (D-m12-054) | 11/11 | — | — | Toàn chốt cả 10 quyết định theo đề xuất; ghi QUYET_DINH m12 (D-m12-054) | Xong |
| NM3-02 | M12-034 | m12 | Đưa kế hoạch nối M3 lên repo ops-core (docs/integration/module-3) + báo phiên lead cập nhật N8.x/N12 | 11/11 | NM3-00 | — | Commit + push kế hoạch và phụ lục lên GitHub/GitLab; hộp thư lead đã thả | Xong |
| NM3-03 | M12-035 | m12 | Giao thức phối hợp hai phiên m12 ↔ m34 (SendMessage, hop-thu/m12-m34-*, nhật ký, cập nhật Sheet) | 11/11 | NM3-00 | — | Phiên m34 xác nhận nhận việc, hai bên có quy ước báo trạng thái | Xong |
| NM3-11 | M12-036 | m12 | Principal SVC-M3-SELLABLE trên .61: kiểm hiệu lực + quyền (chỉ đọc), xoay secret theo runbook 17-09-07-40; Toàn đặt secret vào .env của .60 | 12/11 | NM3-10 | — | Token cấp được bằng secret mới, 10 quyền, secret không lộ ở log/chat/repo | — |
| NM3-12a | M12-037 | m12 | Xuất bảng ánh xạ 19 SKU ↔ sku_id và kho ↔ warehouse_id từ DB .61 (chỉ đọc) giao phiên m34 | 12/11 | — | — | Tệp ánh xạ (CSV/JSON) đủ 19 SKU + kho mặc định, không chứa bí mật | Xong |
| NM3-15a | M12-039 | m12 | WP06a: thêm kiểm '5 điều kiện khung' của parser M3 vào bộ chạy nghiệm thu | 12/11 | — | — | Mọi phản hồi /check được kiểm 5 điều kiện; test đơn vị đạt + hỏng cho từng điều kiện | Xong |
| NM3-16 | M12-040 | m12 | Điều tra V3 (UseHttpsRedirection Production), V4 (202 in-flight giữ hàng), V9 (tắt worker outbox/URL đệm), V11 (hạn idempotency), V14 (SourceAllowlist), V15 (khung /check) + brief WP07b | 12/11 | — | — | Mỗi điểm có kết luận + tệp:dòng hoặc việc cần thử; brief WP07b nháp | Xong |
| DIET-3 | M12-079 | m12 | Tài liệu/thông báo OD-B12-04: ghi chú gói chốt 09/09 §5, dọn source_document 20 SKU của skus.csv, tin cho m34/Phúc/M4 về dietary_type | 13/11 | — | Tài liệu | OD-B12-04 trong repo; gói chốt có ghi chú; tin đã gửi | — |
| KHO-M12-02 | M12-075 | m12 | Cố định id kho thành phẩm: checklist cutover nạp lại ops_core_warehouse_links sau khi Lan nhập kho; cấm xoá/tạo lại kho FG đã link | 13/11 | NM3-20 | Tài liệu | Checklist cutover có bước và điều cấm | — |
| KHO-M12-03 | M12-076 | m12 | Xác nhận định nghĩa available_quantity/sellable_quantity của stock-balances và /check (có trừ giữ/hold/phân bổ của M3 chưa) và giá trị nguyên cho HỘP (cột numeric(18,3)); ghi vào hợp đồng + test | 13/11 | — | R2 | Định nghĩa ghi rõ; test hợp đồng khẳng định số nguyên cho hộp | — |
| NM3-14 | M12-038 | m12 | Chạy bộ WP06a --profile 61 từ .60: 13 ca §6 + C37-1; xử lý ca 4/12 nếu FAIL do QR GENERATED/PRINTED; ghi bằng chứng (WP06) | 13/11 | NM3-10, NM3-11, NM3-13 | — | Bảng ca PASS/FAIL/BLOCKED có lý do, bằng chứng trong docs/evidence; không còn FAIL chưa giải thích | — |
| NM3-20 | M12-041 | m12 | Chèn các bước nối M3 (C-M3-1..7) vào runbook cutover/hypercare WP19 | 13/11 | NM3-16 | — | Runbook cutover có bước nối M3 với lệnh kiểm, điểm lùi, người làm | — |
| NM3-23c | M12-061 | m12 | Đệm webhook bằng Caddy: đường /hooks/m3-sink trên ops.ginsengfood.vn trả 204; thử container gọi được https ops.; đặt M12_OUTBOX_WEBHOOK_URL | 13/11 | NM3-23 | — | Production dựng được với URL https hợp lệ; đệm nhận 204, không dead-letter | — |
| SEC-01 | M12-071 | m12 | Caddy .61: trả 404 cho /v1/* trên MỌI vhost công khai; M12_FRONT_PROXY_CIDR = IP nginx /32; test tĩnh; thử gửi X-Forwarded-For giả từ máy LAN khác | 13/11 | NM3-20 | R2 | XFF giả không đổi IP thấy ở API; /v1/* qua Caddy = 404; bucket AuthSensitive bị 429 sau 10 lần | — |
| SEC-08 | M12-074 | m12 | Bề mặt Development trên .61 đến cutover: chặn /scalar và /openapi ở :5000 hoặc ghi chấp nhận rủi ro; diễn tập Production 13/11 chạy bộ kiểm (scalar 404, lỗi 500 chung, khoá cursor không phải DEV_TEST_ONLY, không admin-bootstrap) | 13/11 | — | R2 | Biên bản diễn tập có bốn kết quả kiểm | — |
| SKU-M12-02 | M12-077 | m12 | Kích hoạt 19 SKU trước khi bật M3: đưa Invoke-SkuActivation.ps1 vào checklist cutover; kiểm /check không còn SKU_ACTIVATION_NOT_ACTIVE cho 3 SKU mẫu | 13/11 | NM3-20 | Tài liệu | Sau cutover 3 SKU mẫu /check không còn SKU_ACTIVATION_NOT_ACTIVE | — |
| SKU-M12-11 | M12-094 | m12 | Công cụ kiểm link chỉ đọc cho cutover: nhận CSV link xuất từ DB M3 (không bí mật), gọi GET /v1/skus/{id} và GET /v1/warehouses, so sku_code từng byte, lifecycle, uom_code, kho; báo lệch (Toàn chạy từ .60 trước khi bật OPS_CORE_ENABLED) | 13/11 | NM3-12b, NM3-11 | R2 | 19/19 link khớp M12 hoặc có danh sách lệch; không ghi gì vào M3/M12 | — |
| DIET-1 | M12-078 | m12 | Sửa phân loại 4 SKU chay trong dữ liệu M12 (skus.csv, seed 11a, ref_sku, test ghim SAVORY, [P05-SKU-003]) — CHỈ sau khi DIET-2 chọn A hoặc B | 14/11 | DIET-2 | R2 | 4 SKU VEGAN, VeganGuard không vi phạm, test và validation xanh | — |
| NM3-21a | M12-042 | m12 | Cutover: tạo principal Production bằng script DB sạch, cấp secret mới cho M3 (Toàn đặt vào .env .60) | 14/11 | NM3-20 | — | Principal đúng 10 quyền; token cấp được từ .60 bằng secret mới | — |
| NM3-22 | M12-043 | m12 | ExternalApi__SourceAllowlist=192.168.1.60/32 vào compose Production, thử từ .60 và qua đường vào mới | 14/11 | NM3-10, NM3-16 | — | M3 qua, IP khác bị 403; có cờ lùi | — |
| NM3-23b | M12-045 | m12 | Đặt M12_OUTBOX_WEBHOOK_URL + khoá ký webhook cho cutover Production | 14/11 | NM3-23 | — | docker compose config dựng được; webhook đệm nhận 2xx; không dead-letter mới | — |
| NM3-24 | M12-046 | m12 | Thử token lại sau khoá ký JWT mới và sau khởi động lại M12 (S17): M3 xin lại đúng một lần, không vòng 401 | 14/11 | NM3-21b | — | Log hai phía: 1 lần 401 rồi hồi phục; không vượt 10 lần/60 s/IP | — |
| SEC-02 | M12-072 | m12 | Compose Production: không publish 5000 và 3000–3002 ra 0.0.0.0 (loopback hoặc mạng nội bộ), giữ healthcheck/kiểm() đúng Host; allowlist cho M3 (phối hợp NM3-22) | 14/11 | SEC-01, NM3-22 | R2 | IP khác .60 nhận 403/401; ss -ltn chỉ còn cổng cần thiết | — |
| SEC-07 | M12-073 | m12 | /v1/service-tokens: client_id ≤64 ký tự [A-Za-z0-9_-], secret ≤72 byte, thân ≤4 KB; thất bại luôn ghi audit (cắt 100) và trả 401 không 500; source_object_no ≤200 ký tự charset hiển thị ⇒ 422; test đỏ trước | 14/11 | — | R2 | Test: client_id 500 ký tự ⇒ 401 có dòng audit; source_object_no dài ⇒ 422 | — |
| SEC-10 | M12-080 | m12 | Chốt nhánh WP20 cho ngoại lệ JWT trước 15/11 16:59Z (đóng bằng khoá mới hoặc gia hạn 30/11); kiểm candidate-gate không chặn deploy WP07b | 15/11 | SEC-05 | R3 | Job historical-jwt-source-receipt-preview xanh sau 15/11 16:59Z hoặc có hồ sơ gia hạn đã ký | — |

**G1 · tới cổng 20/11 (16–20/11)**

| Mã | Sheet | Phiên | Việc | Hạn | Phụ thuộc | Mức | Đạt khi | Trạng thái |
|---|---|---|---|---|---|---|---|---|
| NM3-32 | M12-048 | m12 | Soạn + publish contracts: release, ISSUED, ALLOCATION_NOT_HELD, policy ExternalAllocationWrite, fixture/test reserve+release, idempotency 200, mirror availability, đặc tả webhook, namespace UUID (chỉ push khi Toàn duyệt) | 18/11 | NM3-00 | — | Commit trên origin/main; validate-contracts + contract test xanh; Phúc đã rà | Đang làm 85% |
| NM3-30b | M12-047 | m12 | Theo dõi phía M12 hằng ngày 15–20/11: 401/429, dead-letter, OUTBOX_QUEUE, phân bổ sắp hết hạn | 20/11 | NM3-21b | — | Nhật ký mỗi ngày có số liệu; sự cố được xử lý | — |
| NM3-33 | M12-049 | m12 | WP07b (R3): TRK-07, 202 in-flight giữ hàng, dời pin hợp đồng, ma trận 32→33, cổng parity, bật cờ /release ở môi trường diễn tập | 20/11 | NM3-16, NM3-32 | — | Verifier R3 ĐẠT; /release 200 trên diễn tập; bộ test + governance xanh | Đang làm (pha A) |
| NM3-71 | M12-063 | m12+m34 | Thiết kế + chuẩn bị đường M3→M12 nội bộ cùng máy: mạng ops-internal 172.31.62.0/24, BASE_URL, AllowedHosts, SourceAllowlist, đệm webhook, runbook | 20/11 | NM3-70 | — | Hai compose + runbook có lệnh dựng/kiểm/lùi; thử trên máy thử | — |
| SEC-06 | M12-081 | m12 | Trần quyền theo principal: kiểm chỉ đọc hằng ngày 'đúng N quyền, không có RECIPE/ledger'; bỏ WAREHOUSE_RECEIPT_VIEW và SELLABLE_STATUS_VIEW nếu Toàn đồng ý; mã chặn grant ngoài tập đã duyệt | 20/11 | NM3-21a | R3 | Cấp thử RECIPE_PRODUCTION_VIEW cho M3 ⇒ token không mang quyền đó; kiểm hằng ngày xanh | — |
| SEC-07b | M12-095 | m12 | Cùng lớp lỗi với SEC-07: AdminLoginHandler ghi username không giới hạn vào audit varchar(100) (cắt/giới hạn); hạ validator principalCode của admin xuống ≤64 (khớp client_id); sửa schema hợp đồng source_object_no maxLength 100 → 200 (nhánh m12-noi-m3); quyết KHO-Q1 thập phân cho hộp (đề xuất: chặn ở validator đầu vào) | 20/11 | SEC-07 | R2 | Test: username 500 ký tự không làm hỏng đăng nhập thất bại và có audit; principalCode ≤64; schema khớp mã; hộp thập phân bị 422 ở đầu vào | — |
| SEC-12 | M12-082 | m12 | Webhook tồn kho: danh sách trường tường minh (bỏ RiskCalculation, LeadTimeDays, CoverageDays, RecommendedAction, GuardBlockReasons, EvidenceRefs); reason khoá bán theo từ điển/≤200 ký tự; sửa chú thích; cập nhật hợp đồng | 20/11 | NM3-32 | R2 | Test chứng minh payload tồn kho chỉ có trường đã khai | — |
| SEC-13 | M12-083 | m12 | Đặc tả bảo mật webhook vào hợp đồng (header, chuỗi ký, cửa sổ 300 s, dedupe, trần thân 64 KB); client webhook AllowAutoRedirect=false; tách version khoá; cảnh báo dead-letter>0 | 20/11 | NM3-32 | R2 | Hợp đồng có mục webhook-security; test client không theo 307 | — |
| SEC-14 | M12-084 | m12 | Trần giữ hàng theo principal: số hold hoạt động, % on_hand mỗi SKU, số lượng mỗi dòng, hạn cấu hình được; GET allocations bắt buộc sourceObjectId; snapshot không đọc cả bảng mỗi trang (cùng WP07b) | 20/11 | NM3-33 | R3 | Vượt trần ⇒ 409/422 mã riêng; một principal không khoá quá X% tồn | — |
| SEC-18 | M12-085 | m12 | Cảnh báo tự động thay kiểm tay: SERVICE_TOKEN_ISSUE_FAILED, 401/403/429, dead-letter>0, RESERVED sắp hết hạn, reserved/on_hand; gửi người trực | 20/11 | NM3-30b | R2 | Gây lỗi thử ⇒ nhận cảnh báo trong 15 phút | — |
| SEC-19 | M12-086 | m12 | Compose M12: cap_drop ALL, no-new-privileges, read_only + tmpfs, mem_limit/cpus/pids_limit, log rotation cho api/web/pg; ghim digest postgres | 20/11 | NM3-71 | R2 | docker inspect thấy giới hạn; API vẫn khoẻ | — |
| SEC-21 | M12-087 | m12 | Chọn đường TLS webhook trên máy gộp (hairpin tên miền công hoặc tên nội bộ + CA nội bộ), cấm callback tắt kiểm chứng chỉ; thử hairpin ở NM3-23c | 20/11 | NM3-23c | R2 | Container M12 POST được tới đệm 204 qua https với chứng chỉ hợp lệ, không tắt kiểm chứng chỉ | — |

**G2 · tới 27/11 (21–27/11)**

| Mã | Sheet | Phiên | Việc | Hạn | Phụ thuộc | Mức | Đạt khi | Trạng thái |
|---|---|---|---|---|---|---|---|---|
| NM3-45a | M12-053 | m12 | Mở rộng bộ chạy nghiệm thu: reserve/release/ISSUED + kịch bản S08–S14 | 24/11 | NM3-33 | — | Bộ chạy tự động có S08–S14, chạy được từ .60 | — |
| SKU-M12-03 | M12-088 | m12 | GET /v1/skus (cursor, limit ≤100, lọc lifecycle_status và updated_since) + updated_at/revision trong SkuV1Response; sellable_uoms[]; hợp đồng + fixture + test | 24/11 | NM3-32 | R2 | Route có trong hợp đồng và test; M3 liệt kê được SKU mới | — |
| SKU-M12-05 | M12-089 | m12 | Siết mã SKU khi tạo/nhập: ≤64 ký tự và đúng regex ^[A-Z0-9Đ]+(/[A-Z0-9Đ]+)*$ ở CreateSku và ApplySkuImportDraft | 24/11 | — | R2 | 19 mã hiện có qua; mã dài/sai regex bị 422 | — |
| NM3-43 | M12-051 | m12 | Bật ExternalApi__AllocationSelfRelease__Enabled trên diễn tập rồi .61 (R3, Toàn duyệt từng lệnh) | 25/11 | NM3-33 | — | Ca release 200, ALLOCATION_NOT_HELD, ISSUED 409 chạy trên .61; cờ tắt khẩn thử được | — |
| NM3-44 | M12-052 | m12 | SOP kho: xác nhận CONFIRMED trong hạn, danh sách phân bổ sắp hết hạn, ai trực + tập huấn Lan/kho | 26/11 | NM3-43 | — | SOP ban hành; một buổi tập huấn có ghi chép | — |
| NM3-45b | M12-054 | m12 | Chạy E2E S01–S18 trên .61 từ .60, thu bằng chứng (phối hợp phiên m34) | 27/11 | NM3-42, NM3-43, NM3-45a | — | Bảng S-case PASS có lệnh + kết quả + SHA hai bên; không SKIP/NOT_RUN tính đạt | — |
| NM3-72 | M12-064 | m12 | Chuyển stack M12 sang máy gộp: sao lưu/khôi phục, CD đổi đích, tên miền, cutover lại | 27/11 | NM3-70, NM3-71 | — | M12 chạy ổn trên máy gộp, health xanh, dữ liệu khớp, sao lưu ngoài máy chạy | — |
| SEC-23 | M12-091 | m12 | /metrics cần audience/quyền riêng; TTL + dọn idempotency_registry; Production fail-fast khi ExternalApi:SourceAllowlist rỗng; ràng buộc nguồn theo principal | 27/11 | SEC-02 | R2 | Test tĩnh + test API cho từng mục | — |
| SKU-M12-06 | M12-090 | m12 | Quy trình đổi/ngừng mã SKU có bước báo M3: thêm ops_core_sku_links vào consumer của migration contract (sku19-catalog-renumber.json) và runbook retire | 27/11 | — | Tài liệu | Migration contract và runbook nêu M3 là consumer | — |

**G3 · hoàn thiện, bàn giao (28–30/11)**

| Mã | Sheet | Phiên | Việc | Hạn | Phụ thuộc | Mức | Đạt khi | Trạng thái |
|---|---|---|---|---|---|---|---|---|
| NM3-51b | M12-055 | m12 | Đổi URL đệm → bên nhận thật, đặt khoá ký chung với M3, thử S16 | 28/11 | NM3-51a, NM3-23b | — | Webhook thật 2xx, chữ ký M3 kiểm đạt, 0 dead-letter mới | — |
| NM3-52 | M12-056 | m12 | Chuyển M3 sang https://api-ops…, kiểm lại allowlist, đóng cổng 5000 (m12.78 B2) — phụ thuộc Anh Tuấn https (phiên m34 đổi BASE_URL) | 28/11 | NM3-23, NM3-45b | — | M3 gọi qua https; :5000 đóng; /v1 chỉ từ IP đúng; smoke đạt | — |
| NM3-61a | M12-058 | m12 | Runbook nối M3 phía M12: xoay secret, cờ tắt khẩn, sự cố thường gặp, bảng lỗi M12→M3 | 29/11 | NM3-45b | — | Runbook ≤200 dòng có lệnh kiểm + điểm lùi | — |
| NM3-74 | M12-065 | m12+m34 | Chạy lại WP06 + S01–S18 trên máy gộp với profile mới | 29/11 | NM3-72, NM3-73 | — | Bảng ca PASS trên máy gộp có bằng chứng | — |
| SEC-24 | M12-092 | m12 | Cập nhật chuẩn/tài liệu: SEC-CD-BP-002 (ngoại lệ giữ hàng), mục bảo mật tích hợp M3–M12, runbook lộ secret và thu hồi khẩn (cùng NM3-61a/b), sửa chú thích dispatcher | 29/11 | NM3-61a | Tài liệu | Runbook có lệnh kiểm + điểm lùi cho kịch bản lộ secret | — |
| NM3-60 | M12-057 | m12 | Hypercare 28–30/11 nối M3: đối soát phân bổ M3↔M12, dead-letter, 401, độ trễ (hai phiên cùng trực) | 30/11 | NM3-45b | — | Nhật ký hằng ngày có số liệu; sự cố có xử lý | — |
| NM3-62 | M12-059 | m12 | Báo cáo cuối kết nối + cập nhật lead/SAN_SANG (N8.x có bằng chứng đầu-cuối) | 30/11 | NM3-45b | — | Bảng N8.1–N8.9, N8.11 có bằng chứng; sổ lead/m12/m34 khớp | — |
| SKU-M12-08 | M12-093 | m12 | Sự kiện vòng đời SKU qua outbox (ops-core.product.sku-lifecycle-changed.v1) từ Activate/Deactivate/Retire; additive; chỉ là tín hiệu kéo lại — ưu tiên thấp, cắt được | 30/11 | NM3-32, NM3-51a | R2 | Sự kiện có schema + test; M3 xử lý ở NM3-51a | — |

## 5. Repo `ginsengfood-business-platform` (phiên m34): 43 task, khoảng 279 giờ

**G0 · trước và quanh cutover (12–15/11)**

| Mã | Sheet | Phiên | Việc | Hạn | Phụ thuộc | Mức | Đạt khi | Trạng thái |
|---|---|---|---|---|---|---|---|---|
| NM3-12b | M3-122 | m34 | Script nạp ops_core_sku_links / ops_core_warehouse_links + runbook (chạy lại không trùng, có kiểm) | 12/11 | NM3-12a | — | Bảng liên kết đủ 19 SKU + kho; chạy lại không đổi; runbook có lệnh kiểm | Đang làm |
| NM3-16b | M3-125 | m34 | Kiểm phía M3: V7 (.60 chạy bản BP nào, ops-core bật/tắt), V8 (hiển thị khi ENABLED=true/ENFORCE=false), V10 (lớp 1 thu hồi của Tài, nghĩa 'C36', OD-01..11) | 12/11 | — | — | Ba điểm có kết luận + bằng chứng, báo lại phiên m12 | Chờ review |
| NM3-13 | M3-123 | m34 | Compose .60 bật chế độ quan sát: ENABLED=true, GATE_ENFORCE=false, BASE_URL, ALLOW_PLAIN_HTTP, CLIENT_ID/SECRET, POLL_INTERVAL; sửa compose, env.mau, test_compose, test_m8_gia_lap, test_lam_moi_ton_thu, lam-moi-ton-thu.sh, README; deploy .60 | 13/11 | NM3-11, NM3-12b | — | Test deploy xanh; container be lên; log OpsCore không lỗi cấu hình; chưa chặn đơn nào | — |
| NM3-15b | M3-124 | m34 | Làm tươi 13 JSON fixture M3 từ phản hồi thật của .61 + chạy OpsCoreFixtureVerdictContractTest | 13/11 | NM3-14 | — | 0 lệch khung; test M3 xanh trên fixture mới | — |
| NM3-17 | M3-126 | m34 | M3 gửi X-Correlation-Id ở mọi lời gọi M12; parser chịu giá trị enum lạ (ISSUED) không thành UNKNOWN_BLOCKED sai; test | 13/11 | — | — | Test chứng minh parser chịu enum lạ; log hai phía cùng correlation id | Đang làm |
| NM3-21b | M3-127 | m34 | Cutover: nạp lại bảng liên kết theo mã kho mới (script NM3-12b), khởi động lại be, đặt ENFORCE=false trong cửa sổ | 14/11 | NM3-12b, NM3-21a | — | /check 200 đủ 5 điều kiện khung cho 3 SKU mẫu; poller xanh | — |
| DIET-4 | M3-148 | m34 | Giữ nhãn 'Thuần chay' 4 SKU (không đổi mã); thêm test đối chiếu dietary_type theo M12 sau khi DIET-1 xong | 15/11 | DIET-2 | R1 | Test đối chiếu có mặt; không đổi hành vi hiển thị | — |
| SKU-M3-02 | M3-143 | m34 | Dấu vết cho hai bảng link: trigger audit INSERT/UPDATE/DELETE + chặn DELETE (chỉ is_active=false) trong migration V332+ (hiệu lực mọi role; ghi người thực hiện qua application_name/biến phiên do script đặt); tách role DB để SEC-09/22 khi gộp máy | 15/11 | NM3-12b | R2 | Sửa link không còn im lặng: có bản ghi ai/khi nào/trước-sau | — |

**G1 · tới cổng 20/11 (16–20/11)**

| Mã | Sheet | Phiên | Việc | Hạn | Phụ thuộc | Mức | Đạt khi | Trạng thái |
|---|---|---|---|---|---|---|---|---|
| KHO-M3-01 | M3-144 | m34 | Cờ riêng 'tồn do M12 quản' (tách khỏi gate.enforce) + mã 409 INVENTORY_MANAGED_EXTERNALLY ở importStock, adjustStock, createLot, updateLot/updateLotStatus, updateFulfillmentReady, updateWarehouse | 16/11 | — | R2 | Cờ bật ⇒ ghi tay bị 409 có mã máy đọc được; test | — |
| KHO-M3-02 | M3-145 | m34 | Vá: bật/tắt/sửa kho không ghi đè product_sellable_availability của ops-core (publisher ưu tiên nguồn hoặc bỏ publish khi enforce) + test; test có ca SKU demo (cron lam-moi-ton-thu không bị chặn) | 16/11 | — | R2 | Test: tắt kho đã link không đổi hàng nguồn ops-core | — |
| KHO-M3-03 | M3-146 | m34 | Chặn đổi warehouse_code/market/ngưng kho đã có ops_core_warehouse_links active; PUT /warehouses bắt buộc 'active' (không mặc định bật lại) | 16/11 | — | R2 | Test: sửa/ngưng kho đã link bị chặn; PUT thiếu active bị 400 | — |
| NM3-31 | M3-129 | m34 | Script đồng bộ tồn một chiều M12→M3 (stock-balances → sổ M3), chạy tay/cron (Q2) | 17/11 | NM3-21b | — | Sau mỗi lần chạy sổ M3 = available của M12; chạy lại không đổi | — |
| NM3-32b | M3-130 | m34 | Rà hợp đồng mới phía consumer M3 (parser ISSUED, mirror availability, namespace UUID) cùng Phúc | 17/11 | NM3-32 | — | Ghi nhận rà: không phát hiện breaking với M3 hoặc danh sách sửa | — |
| NM3-30 | M3-128 | m34 | Theo dõi 48–72 giờ chế độ quan sát; báo khớp/lệch mỗi ngày; kết luận cổng Q1 | 18/11 | NM3-21b | — | ≥99% quyết định khớp, 0 UNKNOWN_BLOCKED do lệch khung, p95 /check <500 ms, hoặc danh sách lệch + nguyên nhân | — |
| NM3-34 | M3-131 | m34 | Nâng ghim hợp đồng M3 (a3b4bbf84 → bản mới) + test đọc hợp đồng (availability, service-auth, inventory) | 19/11 | NM3-32 | — | Gitlink mới, submodule init được trong CI; test đối chiếu hợp đồng xanh | — |
| KHO-M3-05 | M3-152 | m34 | Front-end ẩn/khoá theo cờ (externallyManaged) cho Nhập/Điều chỉnh/Sẵn sàng giao/Tạo-Sửa-Ngưng kho đã link; banner 'Tồn do hệ thống nhà máy (M12) quản lý' | 20/11 | KHO-M3-01 | R1 | Nút ẩn khi cờ bật; không còn lệ thuộc chỉ sourceService | — |
| KHO-M3-07 | M3-153 | m34 | IVR/M8 nguồn an toàn: OrderIvrInventoryServiceImpl đọc verdict ops-core (hoặc snapshot N12) thay inventory_wms_stock_snapshots chưa ai nạp (việc M3→M8 của Toàn) | 20/11 | QD-RS | R2 | M8 không còn UNKNOWN vô cớ khi ops-core bật | — |
| KHO-M3-08 | M3-154 | m34 | Siết kho: PUT /lots/{id} bỏ status (hoặc đòi ADJUST); @Max + Math.addExact cho quantity; @Size cho note/location; CHECK qty>=0 ở DB (migration) | 20/11 | — | R2 | Test: tràn số, đổi status lách quyền, note quá dài bị chặn | — |
| KHO-M3-13 | M3-155 | m34 | Đồng bộ tài liệu chủ M3: ghi chính thức WMS-PRE-OD-04/09/10 và WMS-OD-19 theo kế hoạch nối (UUIDv5, webhook + inbox, giữ hàng M12); hạ 'Can cutover start: NO' khi đủ điều kiện | 20/11 | QD-RS | Tài liệu | Decision log M3 khớp kế hoạch; NK-b không còn ngược quyết định chủ | — |
| NM3-71 | M12-063 | m12+m34 | Thiết kế + chuẩn bị đường M3→M12 nội bộ cùng máy: mạng ops-internal 172.31.62.0/24, BASE_URL, AllowedHosts, SourceAllowlist, đệm webhook, runbook | 20/11 | NM3-70 | — | Hai compose + runbook có lệnh dựng/kiểm/lùi; thử trên máy thử | — |
| SEC-15 | M3-158 | m34 | Chống đơn rác khi bật NK-b: hạn giữ ngắn khi chưa thanh toán (30–60 phút) rồi gia hạn theo bước; trần hold theo khách/IP/thiết bị; xác minh POST /api/v1/orders đòi OTP/đăng nhập gì; cập nhật Q4 | 20/11 | NM3-35 | R2 | Kịch bản 200 đơn rác từ 1 IP không khoá quá trần; ghi vào quyết định Q4 | — |
| SEC-16 | M3-159 | m34 | Client M3: trần thân phản hồi (1 MiB /check, 4 MiB trang tồn), trần Retry-After 60 s và expires_in, allowlist host cho BASE_URL, parser chặt allocations/stock-balances, ngắt mạch nhẹ, test API công khai không lộ blocker thu hồi (X-Correlation-Id ở NM3-17) | 20/11 | NM3-17 | R2 | Test đơn vị từng trần; E2E verdict thu hồi ⇒ API công khai chỉ trả INVENTORY_UNAVAILABLE | — |
| SKU-M3-03 | M3-149 | m34 | Đối soát vòng đời qua GET /v1/skus/{id} (khởi động + 15–60 phút): lệch sku_code ⇒ chặn SKU, OPS_CORE_LINK_CODE_MISMATCH; INACTIVE/RETIRED/lệch mã là blocker kể cả enforce=false (cờ lifecycle.enforce); không cascade sang Product (OD-06) | 20/11 | QD-RS, SKU-M12-03 | R2 | Test: RETIRED ở M12 ⇒ M3 chặn bán trong chu kỳ kéo; không tự Ngưng products | — |
| SKU-M3-04 | M3-150 | m34 | Đối chiếu sku_id M12 trả lại trong /check với link; lệch ⇒ UNKNOWN_BLOCKED + log; thêm vào 13 JSON chụp và test hợp đồng | 20/11 | NM3-15b | R2 | Link đảo chéo bị phát hiện trong test | — |
| SKU-M3-05 | M3-151 | m34 | Màn hình CHỈ ĐỌC 'Liên kết M12': SKU↔M12 (id che 8 ký tự cuối), kho mặc định, đơn vị, verified_at, trạng thái M12, lần kiểm cuối, blockers, số SKU bị chặn; quyền PRODUCT.VIEW hoặc quyền mới | 20/11 | NM3-12b | R2 | Vận hành thấy vì sao một SKU bị chặn; không có thao tác ghi | — |
| SKU-M3-06 | M3-156 | m34 | Gỡ M3-025 ON_HOLD đúng nghĩa: spec P2-44 (nhà cung cấp = ops-core GET /v1/skus/{id}, kéo, chặn tại cổng, không cascade), cập nhật OD-06, contract-diff, m34 QUYET_DINH, đóng M3-025 | 20/11 | QD-RS | Tài liệu | P2-44 có spec; M3-025 đóng; hai phiên hiểu giống nhau | — |
| SKU-M3-10 | M3-157 | m34 | Gỡ SKU DEMO/* NGAY TRƯỚC ENFORCE (≥20/11; trong chế độ quan sát demo vẫn bán, guard cron lam-moi-ton-thu sửa ở NM3-13); kiểm không còn mã ngoài 19 mã chuẩn có products Hoạt động | 20/11 | NM3-13 | Vận hành | Không còn mã demo Hoạt động khi bật ENFORCE | — |

**G2 · tới 27/11 (21–27/11)**

| Mã | Sheet | Phiên | Việc | Hạn | Phụ thuộc | Mức | Đạt khi | Trạng thái |
|---|---|---|---|---|---|---|---|---|
| NM3-40 | M3-132 | m34 | NK-b: adapter + parser + cổng + dịch vụ giữ/nhả (khoá idempotency m3:rsv:<orderId>:<n>, fail-closed, bù trừ nhả) | 24/11 | NM3-35 | — | Test đơn vị + Postgres xanh; idempotent; lỗi map đúng bảng phụ lục B kế hoạch | — |
| NM3-41 | M3-133 | m34 | NK-b: bảng sổ giữ hàng + migration + job đối soát GET allocations?sourceObjectId + UUIDv5 | 24/11 | NM3-35 | — | Đối soát phát hiện hết hạn/CONFIRMED/ISSUED; UUID tất định tính lại được | — |
| NM3-42 | M3-134 | m34 | NK-b: tắt đường giữ cục bộ khi M12 giữ; móc OrderCreate, OrderStateMachine, ShipmentService; gỡ luật cấm cấu hình allocation.release | 24/11 | NM3-40, NM3-41 | — | Không còn 422 do sổ M3 khi M12 đã giữ; huỷ đơn gọi nhả | — |
| KHO-M3-10 | M3-160 | m34 | Audit kho: truyền IP/correlation, ghi audit sau commit, một dòng audit khi khởi động ghi giá trị cờ OPS_CORE_* (không bí mật) | 27/11 | — | R2 | Không còn dòng audit 'ma'; IP có giá trị | — |
| NM3-50 | M3-135 | m34 | NK-c: giữ hàng Giờ Vàng, gỡ chốt GOLDEN_HOUR_OPS_CORE_HOLD_NOT_READY (bắt buộc nếu bật ENFORCE mà Giờ Vàng vẫn chạy) | 27/11 | NM3-40 | — | Đặt chỗ Giờ Vàng giữ/nhả ở M12; test xanh | — |
| NM3-73 | M3-142 | m34 | Chuyển stack M3 sang máy gộp: compose, DB, nginx/tên miền, tham số hoá M34_HOME/M34_HOST_IP/M34_BIND_* | 27/11 | NM3-70, NM3-71 | — | M3 chạy ổn trên máy gộp, gọi M12 nội bộ | — |
| SEC-09 | M3-163 | m34 | OPS_CORE_CLIENT_SECRET qua tệp bí mật (configtree/_FILE) thay biến môi trường; tách user Unix hoặc CD key cho ~/m12 và ~/m34 (.env 600 ở NM3-13) | 27/11 | NM3-13 | R2 | docker inspect be không còn secret | — |
| SEC-22 | M3-164 | m34 | Chuỗi cung ứng + máy gộp: kéo image theo digest từ artifact CI, cosign khi pipeline xanh, trivy chặn HIGH/CRITICAL (bỏ continue-on-error ở M3), tách user Unix, sao lưu máy gộp mã hoá + escrow khoá (cùng m12, Toàn, Anh Tuấn) | 27/11 | NM3-72 | R2 | trien-khai từ chối image sai digest; có bản sao lưu mã hoá khôi phục thử được | — |
| SKU-M3-11 | M3-161 | m34 | Khoá đơn vị: khi SKU có link, products.unit_name chỉ nhận giá trị khớp uom_code (Hộp ↔ hộp); script nạp kiểm sale_unit_code=BOX ↔ uom_code=hộp | 27/11 | NM3-12b | R2 | Không thể lệch đơn vị giữa M3 và link | — |
| SKU-M3-12 | M3-162 | m34 | Củng cố master: quyền trước khi trả 410 ở PATCH status; test kiến trúc 'không writer nào của SkuMasterCode status'; trigger audit UPDATE sku_master_codes; sửa test đỏ SkuMasterSeederWriteContractTest; cấm UPSERT ghi đè nghĩa mã; IP qua trusted-proxy; trigger chống sửa/xoá config_audit_logs | 27/11 | — | R2 | Các test và trigger có mặt, test đỏ cũ được sửa | — |

**G3 · hoàn thiện, bàn giao (28–30/11)**

| Mã | Sheet | Phiên | Việc | Hạn | Phụ thuộc | Mức | Đạt khi | Trạng thái |
|---|---|---|---|---|---|---|---|---|
| NM3-51a | M3-136 | m34 | Bên nhận webhook M3: route /internal/ops-core/events, HMAC, lệch giờ ≤300 s, inbox + idempotency theo X-Outbox-Event-Id, xử lý nền, test | 28/11 | NM3-32 | — | S16 PASS: chữ ký sai/trễ/trùng/4xx xử lý đúng; recall → recheck SKU | — |
| NM3-54 | M3-138 | m34 | Câu chữ FE cho OPS_CORE_UNAVAILABLE, SHIPMENT_STOCK_GATE_BLOCKED, GOLDEN_HOUR_OPS_CORE_HOLD_NOT_READY + đường đưa log cảnh báo tới người trực | 28/11 | NM3-13 | — | FE hiển thị thông điệp đúng; cảnh báo có người nhận | — |
| NM3-61b | M3-139 | m34 | Runbook nối M12 phía M3: cấu hình OPS_CORE_*, bật/tắt, cảnh báo, sự cố | 29/11 | NM3-45b | — | Runbook có lệnh kiểm + điểm lùi, link từ README deploy/m34 | — |
| NM3-74 | M12-065 | m12+m34 | Chạy lại WP06 + S01–S18 trên máy gộp với profile mới | 29/11 | NM3-72, NM3-73 | — | Bảng ca PASS trên máy gộp có bằng chứng | — |
| SKU-M3-13 | M3-165 | m34 | Runbook 'SKU mới' hai bước: M12 tạo + kích hoạt → m12 xuất ánh xạ → migration M3 thêm mã (khuôn V116, không UPSERT ghi đè) → runner tạo SKU Ngưng → nhập giá → nạp link → Bật | 29/11 | SKU-M12-03 | Tài liệu | Runbook có lệnh kiểm + điểm lùi | — |
| NM3-53 | M3-137 | m34 | Client Java đọc hàng loạt (stock-balances, opening-gate, lifecycle) thay script đồng bộ — ưu tiên thấp, cắt nếu thiếu thời gian | 30/11 | NM3-31 | — | Client có test; script đồng bộ thôi dùng | — |

## 6. Việc của Toàn và bên ngoài (không thuộc hai phiên)

**G0 · trước và quanh cutover (12–15/11)**

| Mã | Sheet | Phiên | Việc | Hạn | Phụ thuộc | Mức | Đạt khi | Trạng thái |
|---|---|---|---|---|---|---|---|---|
| NM3-01 | M12-033 | Toàn | Gửi tin cho Phúc, Anh Tuấn (+ Tài, Lan, chú Dũng): adapter M3 ở đâu, rà hợp đồng, tên miền https + đệm nginx cho webhook, SOP kho | 11/11 | NM3-00 | — | Tin đã gửi, mỗi người có hạn trả lời; Anh Tuấn trả ngày chắc chắn xong tên miền https cho webhook trước chiều 13/11 | — |
| DIET-2 | M12-066 | Toàn | Xác nhận công thức thật của 4 SKU chay (A1, B1, C2, C3) với chú Dũng: lòng trắng trứng 8,09–8,25% có thật không; chọn A (sửa dữ liệu) / B (tái lập công thức hoặc đổi định nghĩa) / C (giữ SAVORY, không dán nhãn chay) | 12/11 | — | Quyết định | Có quyết định A/B/C bằng văn bản; ghi vào OD-B12-04 | — |
| NM3-10 | M3-121 | Toàn | Kiểm mạng .60→.61:5000: /health/live 200 từ .60, lấy được một token, ghi IP nguồn M12 thấy (phiên m34 soạn lệnh, Toàn chạy) | 12/11 | NM3-00 | — | 200 + token cấp được từ .60; IP nguồn ghi vào nhật ký | Đang làm |
| NM3-23 | M12-044 | Toàn | Anh Tuấn: tên miền https cho webhook + đệm nginx .60 trả 200 (đường /internal/ops-core/events) | 13/11 | NM3-01 | — | https://<tên-miền>/internal/ops-core/events trả 200 với chứng chỉ hợp lệ, cổng 443 | — |
| NM3-70 | M12-062 | Toàn | Chốt với Anh Tuấn: ngày giao máy gộp nhà máy+bán hàng, cấu hình, nginx, DNS; cutover 14/11 ở .61 hay máy mới | 13/11 | — | — | Có ngày giao máy + quyết định nơi cutover | — |
| QD-RS | M12-067 | Toàn | Chốt các quyết định rà soát (mục 2 kế hoạch chi tiết): KHO-C1..C4, rs2.2..rs2.5, SEC-03a, SEC-06, Q4 hạn giữ ngắn khi chưa thanh toán | 13/11 | — | Quyết định | Mỗi quyết định có dòng ghi sổ; mặc định theo đề xuất nếu không phản đối | — |
| SEC-05 | M12-069 | Toàn | Khoá Production sinh MỚI trên .61 (JWT 48 byte; ký webhook, cursor, mã hoá bằng chứng 32 byte; năm giá trị khác nhau), không sao chép từ máy dev; escrow niêm phong; tách biến version khoá webhook (m12 soạn lệnh) | 14/11 | NM3-23b | R3 | Validator Production qua; nhật ký ghi ngày sinh khoá + người xác nhận khác khoá lịch sử (D-m12-052); có bản escrow | — |
| SEC-25 | M12-068 | Toàn | Xác nhận NTP trên .60 và .61 (hoặc máy gộp): lệch giờ tối đa 5 giây, ghi bằng chứng | 14/11 | NM3-10 | Vận hành | Số đo lệch giờ ghi vào nhật ký NM3-10 | — |
| SEC-11 | M12-070 | Toàn | Xoay token Sheet ở 6 repo và đưa tools/task-tracker/sheet.json ra ngoài repo (phiên lead sửa công cụ chung) | 15/11 | — | Bảo mật | Token cũ bị thu hồi; git ls-files không còn sheet.json | — |
| SKU-M3-08 | M3-147 | Toàn | Xác minh giá thật trên .60 (chỉ đọc): sku_prices ACTIVE của 19 SKU có phải giá vốn mẫu 16.000–34.000 đ của gói catalog-pricing; chốt giá thật trước ENFORCE/công khai | 15/11 | — | Dữ liệu | Biết giá đang dùng là thật hay mẫu; nếu mẫu thì có kế hoạch nhập giá thật | — |

**G1 · tới cổng 20/11 (16–20/11)**

| Mã | Sheet | Phiên | Việc | Hạn | Phụ thuộc | Mức | Đạt khi | Trạng thái |
|---|---|---|---|---|---|---|---|---|
| NM3-35 | M12-050 | Toàn | Cổng 20/11: go/no-go NK-b (đủ hợp đồng publish + WP07b ĐẠT) | 20/11 | NM3-32, NM3-33 | — | Quyết định ghi sổ: vào P4 hoặc giữ check-only + script đồng bộ (Q10) | — |

**G3 · hoàn thiện, bàn giao (28–30/11)**

| Mã | Sheet | Phiên | Việc | Hạn | Phụ thuộc | Mức | Đạt khi | Trạng thái |
|---|---|---|---|---|---|---|---|---|
| NM3-99 | M12-060 | Toàn | Nghiệm thu kết nối M12↔M3 (Toàn ký): mọi điểm nối PASS đầu-cuối trên .61, cờ tắt khẩn hai phía đã thử | 30/11 | NM3-45b, NM3-62 | — | Biên bản nghiệm thu: M3 gọi M12 thành công cho token, kiểm bán được, kéo tồn, giữ/nhả, thu hồi; webhook nhận | — |

Việc ngoài code khác: Anh Tuấn (tên miền https, nginx, IP nginx `/32` cho `SEC-01`, ngày giao máy gộp), Phúc (rà hợp đồng `NM3-32b`, trả lời adapter M3, OD-02/07), chú Dũng (`DIET-2`, `m12.7`), Lan (kho, SOP, nhập kho thật).

## 7. Cổng nghiệm thu

| Cổng | Điều kiện (thiếu thì không qua) |
|---|---|
| **Cutover 14/11** | `SEC-01`, `SEC-02`, `NM3-11` (xoay secret, `SEC-04`), `SEC-05`, `SEC-07`, `SEC-08`, `SEC-25`, `NM3-23b/23c` (URL webhook), `KHO-M12-02`, `SKU-M12-02`; phía M3: `NM3-12b` (link có kiểm), `NM3-13`, `NM3-17`; `DIET-2` ghi nhận (không chặn cutover nhưng chặn in tem) |
| **15/11** | `SEC-10` (WP20), `SEC-11`, `SKU-M3-02` (dấu vết link), `SKU-M3-08` (giá thật), quan sát bắt đầu (`NM3-30`) |
| **20/11 (NK-b go/no-go, `NM3-35`)** | Thêm: hợp đồng publish (`NM3-32`) + `NM3-33` + `SEC-14` + `SEC-15`; `KHO-M3-01..03`, `KHO-M3-07`, `SKU-M3-03/04`, `SEC-16`; không có thì không bật `ENFORCE` hay NK-b (GAP-03) |
| **27/11** | Giữ/nhả 24/7 chạy đầu-cuối (S08–S14); `SEC-03`, `SEC-19`, `SEC-21`, `SEC-22` trước khi gộp máy; SOP kho đã tập huấn |
| **30/11** | `NM3-99` Toàn ký; mọi `SEC-*` Cao/Trung bình đã xong hoặc có chấp nhận rủi ro bằng văn bản |

Kiểm thử bảo mật chấp nhận (chạy ở diễn tập và lại sau thay đổi): (1) gửi `X-Forwarded-For` giả từ máy LAN khác vào Caddy không đổi IP thấy ở API, `/v1/*` qua Caddy = 404; (2) IP khác `.60` nhận 403/401; (3) từ `be`: `/v1/service-tokens` đạt, `/api/v1/auth/login` và `/health/ready` = 404; (4) `client_id` 500 ký tự ⇒ 401 có audit; (5) cấp thử `RECIPE_PRODUCTION_VIEW` cho M3 ⇒ token không mang quyền đó; (6) 200 đơn rác từ 1 IP không khoá quá trần; (7) chữ ký webhook sai/trễ/trùng/thân lớn xử lý đúng; (8) `docker inspect be` không còn secret; (9) 19/19 link có `verified_at` và bản ghi ai/khi nào; (10) RETIRED ở M12 ⇒ M3 chặn bán trong một chu kỳ kéo.

## 8. Tải việc và đường cắt

Tổng ≈ 484 giờ cho cả hai repo trong 19 ngày lịch, cộng cutover, WP11 và M3→M8 của Toàn: **không đủ nếu làm hết**. Thứ tự cắt khi thiếu (cắt từ trên xuống, mỗi mục cắt phải ghi rủi ro): `SKU-M12-08`, `SKU-M3-12`, `SKU-M3-11`, `KHO-M3-10`, `NM3-53`, `NM3-50` (chỉ nếu Giờ Vàng không chạy khi bật chặn), `SEC-23`, `SKU-M3-13`. **Không cắt:** mọi gói chặn cutover, cổng 20/11, `SEC-01/02/07/14/15`, `SKU-M3-02/03/04`, `KHO-M3-01..03`.

## 9. Đợt 1 làm ngay (song song)

- **Phiên m12:** (a) coder Caddy/compose: `SEC-01`, `SEC-08`, `NM3-23c`, phần bind cổng của `SEC-02`; (b) coder dịch vụ token: `SEC-07` (+ `KHO-M12-03` test hợp đồng); (c) WP07b pha A đang chạy (`NM3-33`/`SEC-14` một phần); (d) hợp đồng `NM3-32` chờ Toàn duyệt hằng UUID và Phúc rà; (e) `NM3-11` chờ Toàn duyệt lệnh xoay secret; (f) `DIET-3` tài liệu; (g) `SKU-M12-11` công cụ kiểm link chỉ đọc cho cutover.
- **Phiên m34:** (a) `NM3-12b` (`nap-link.sh` chỉ chạm DB: dry-run, UTF-8, chạy lại không đổi) + `SKU-M3-02` (trigger audit + chặn DELETE trong migration V332+, hiệu lực mọi role); (b) `NM3-13` + `NM3-17` + `SKU-M3-10`; (c) `KHO-M3-01..03` (khoá tồn do M12 quản, vá bật/tắt kho, chặn sửa kho đã link); (d) `NM3-16b` đã xong, chuyển `NM3-10` cho Toàn chạy.
- **Toàn:** `DIET-2`, `QD-RS`, `NM3-01` (tin cho Anh Tuấn/Phúc), `NM3-70`, `SEC-25`, `SEC-05`, `SEC-11`, `SKU-M3-08`; duyệt lệnh `.60`/`.61` khi hai phiên xin.

## 10. Điều chỉnh sau phản hồi của phiên m34 (11/11 ~18:30)

Phiên m34 đọc mã BP `b15c6b0f1` và nêu 5 điểm lệch; đã chấp nhận và chỉnh task:

1. **Script nạp link chỉ chạm DB** (`nap-link.sh`); gọi M12 cần token + secret + mạng nên không nằm trong script. Hiện không có mã nào ghi `verified_at`/`verified_correlation_id`. Kiểm đúng SKU: công cụ chỉ đọc **`SKU-M12-11`** (`M12-094`, phiên m12, 13/11: CSV link từ DB M3 → `GET /v1/skus/{id}` + `GET /v1/warehouses`, so mã từng byte, lifecycle, đơn vị) chạy trước khi bật `OPS_CORE_ENABLED`; ghi `verified_at` lâu dài bằng job Java `SKU-M3-03/04`.
2. **`SKU-M3-02`**: `be` và Flyway dùng chung user DB nên không ép được "ứng dụng chỉ SELECT". Làm **trigger audit + chặn DELETE trong migration V332+** (hiệu lực mọi role; người thực hiện qua `application_name`/biến phiên do script đặt); tách role DB để `SEC-09/22` khi gộp máy. Số migration: dev tới V331 (Phúc), m34 dùng V332+ và báo Phúc để không trùng.
3. **`SKU-M3-10`**: SKU `DEMO/P3/SALE/BASELINE` còn phục vụ pilot M4/M5 và nghiệm thu 13–14/11 ⇒ chỉ gỡ **ngay trước ENFORCE (≥20/11)**; `NM3-13` sửa guard cron để demo vẫn bán trong chế độ quan sát.
4. **`KHO-M3-02`**: cron `lam-moi-ton-thu.sh` làm tươi hàng theo `source_service`; đổi ưu tiên nguồn ở publisher có thể làm cron chặn lại như sự cố 10–11/11 ⇒ test `KHO-M3-02` bắt buộc có ca SKU demo.
5. **Năng lực phía M3**: một máy chạy Maven tuần tự, mỗi gói R2 (coder + verifier) ≈ 3–5 giờ khi máy tải ⇒ G1 (16–20/11, ~17 task) rất sát. **Thứ tự ưu tiên trong G1:** (1) `KHO-M3-01..03`, `SKU-M3-02`; (2) `SKU-M3-03/04`, `SEC-15`, `SEC-16`, `KHO-M3-07`; (3) `SKU-M3-05`, `KHO-M3-05`, `KHO-M3-08`, `KHO-M3-13`, `SKU-M3-06`. Trượt thì cắt theo mục 8 (màn hình chỉ đọc `SKU-M3-05` có thể thay bằng truy vấn SQL chỉ đọc tới 27/11).
6. **Migration phía M3 cho phần nối M12:** `flyway.out-of-order: true` nên m34 giữ dải **V340–V349** (dev đang tới V331 của Phúc); gồm trigger audit link (`SKU-M3-02`), bảng sổ giữ hàng (`NM3-41`), cột/bảng kiểm vòng đời. **Toàn báo Phúc** dải này để không trùng số. Lệnh xuất CSV link cho `SKU-M12-11`: `modules/m34/nm3/NM3-12-xuat-link-60.sh` (chỉ SELECT qua ssh, in CSV giữa `== CSV BAT DAU ==` và `== CSV HET ==`; chỉ có dữ liệu sau khi `NM3-12b` nạp link; cần Toàn duyệt lệnh).

## 11. Ánh xạ mã

`NM3-*` = kế hoạch nối gốc · `SEC-*` = `PL-H` mục 5 · `KHO-M3-nn` = `PL-G` mục 5.1 `M3-n`; `KHO-M12-nn` = `PL-G` mục 5.2 `M12-n` · `SKU-M3-nn` / `SKU-M12-nn` = `PL-F` mục 5.1/5.2 `RS2-M3-nn` / `RS2-M12-nn` · `DIET-*` = `D-m12-055` · `QD-RS` = các quyết định mục 2. Trùng lặp đã gộp: `SEC-17` = `NM3-12b`; `SEC-20` = `NM3-51a`; `SEC-04` = `NM3-11`; `SEC-03` = `NM3-71`; `SEC-13` + `SEC-14` làm cùng `NM3-32`/`NM3-33`; `KHO-M3-04` = `NM3-31`; `KHO-M3-06` = `SKU-M3-05`; `KHO-M3-09`, `KHO-M3-11`, `KHO-M3-12` nằm trong `NM3-41/42` hoặc để sau 30/11.
