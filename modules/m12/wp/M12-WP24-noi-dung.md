# M12-WP24 · Đặc tả nội dung app xưởng (đợt 0) · 18/11/2026

Gói: [M12-WP24-pwa-ui.md](M12-WP24-pwa-ui.md) · luật coder: [M12-WP24-luat-chung.md](M12-WP24-luat-chung.md) · bản rà: [../ra-soat/2026-11-18-pwa-ui-ra-soat-ke-hoach.md](../ra-soat/2026-11-18-pwa-ui-ra-soat-ke-hoach.md).
**Nguồn thuật ngữ = D-m12-118** ([../QUYET_DINH.md](../QUYET_DINH.md), [../ra-soat/2026-11-18-tieng-anh-ui.md](../ra-soat/2026-11-18-tieng-anh-ui.md) §5): KCS thay QC · ĐVT thay UOM ·
GIỮ "offline/online" · GIỮ "Check-in/Check-out" · Cấp 1/Cấp 2 thay L1/L2 · "mẻ" (mẻ sản xuất), "lô" (lô nguyên liệu/thành phẩm) thay batch · mã lỗi cuối câu "(mã: …)" ·
giữ viết tắt QR, SKU, GTIN, MRP, FEFO, MISA, CAPA, NSX/HSD/NCC · bỏ chữ "PWA" khỏi câu cho công nhân. §5 gộp đủ 29 mục app xưởng ở `tieng-anh-ui.md` §1 (ghi "TA#n"; lệch đề xuất cũ thì theo D-m12-118).
Quyết định khác: **D-m12-116** (m12.130 B: phiên theo người + máy, quản trị cấp mã kèm QR, app quét thay gõ, mã giữ qua đăng xuất, không API mới · m12.131 A: thanh
trên + ngăn kéo nhóm theo công đoạn lọc theo vai + thanh đáy 4 ô) · **D-m12-119** (phiên đăng nhập xưởng = 1 ca; lối đăng nhập mail OTP theo WP26).
Nguồn nội dung: mã `ginsengfood-ops-core` @ `ee99e9fd6` (chỉ đọc; mã là gốc đúng), seed `02` + `25`, `MobileOperationalCommandRegistry.cs`, HDSD chương 37–45, catalog UAT
(D06, E07, E08, F05, G03, H07, J04, K03, N01, N07), `docs/chudung/2026-11-17-app-hien-truong-phan-con-lai.md`. Tệp công khai: chỉ mã vai. "CHƯA RÕ" tổng hợp ở §8.

## 0. Quy ước chữ chung

- Tên app: **Ginsengfood Xưởng** (tab, manifest `name`; `short_name` "GF Xưởng"); dòng phụ: **Ứng dụng vận hành tại xưởng**.
- Gọi người dùng là "bạn"; câu ngắn, bắt đầu bằng động từ ("Quét…", "Bấm…", "Chụp…"); nút ghi đúng việc nút làm.
- Không hiện mã thô (RAW_LOT_QC_SIGN, BATCH, mã băm, mã định danh); lỗi: câu tiếng Việt trước, mã cuối câu dạng "(mã: STATE_CONFLICT)" (D-m12-118).
- Từ cố định: **việc / công việc** (không "task") · **lệnh chờ gửi** (không "phong bì") · **Hàng đợi** · **ghép máy**, **mã ghép** (không "phiên thiết bị" với công nhân)
  · **KCS** (không "QC") · **ĐVT** (không "UOM") · **Cấp 1 / Cấp 2** · **mẻ**, **lô** · **offline / online**, **Check-in / Check-out** giữ nguyên · **khoá bán** · ngày giờ `dd/MM/yyyy HH:mm`.
- Mỗi màn: tiêu đề · breadcrumb `Xưởng › Nhóm › Trang` (mục cuối không bấm) · mô tả 1 câu · khối **Cách làm** (gập được; lần đầu mở, nhớ trạng thái
  gập theo từng màn trên máy) · nội dung · trạng thái rỗng = icon + câu + việc nên làm tiếp (+ nút nếu có).
- Thanh trên: `☰` · tên trang (ngắn) · avatar chữ cái đầu (bấm → Tài khoản). Màn chi tiết: `☰` thay bằng `‹` quay lại. Offline: dải mỏng dưới thanh trên
  "Đang offline — việc vẫn lưu trên máy, có mạng sẽ gửi". Không còn chip "API kết nối" (TA#1): chỉ hiện dải khi offline hoặc "Không liên lạc được máy chủ".

## 1. Ngăn kéo menu

Đầu ngăn kéo: avatar + họ tên + vai chính (tên tiếng Việt, §4.4). Cuối: "Phiên bản app <v>". Nhóm không có việc nào cho vai ⇒ ẩn cả nhóm.
Đăng xuất **không** nằm trong menu (chỉ ở Tài khoản, có hộp xác nhận). Quyền viết đúng mã seed; mọi thao tác ghi còn cần `MOBILE_OPERATIONAL_SYNC`.

| # | Nhóm | Route | Nhãn (≤16) | Icon | Quyền hiện — đề xuất (hiện nay) | Vai thấy (seed) |
|---|---|---|---|---|---|---|
| 1 | Việc của tôi | `/pwa/tasks` | Danh sách việc | ClipboardList | `MOBILE_TASK_VIEW` ∧ ≥1 quyền thao tác ở §1b (nay: `MOBILE_TASK_VIEW`) | R-PROD-OP, R-PACK-OP, R-WH-RAW, R-WH-FG, R-QC-RAW, R-QC-PROD, R-QA-REL |
| 2 | Việc của tôi | `/pwa/scan` | Quét mã | ScanLine | `MOBILE_SCAN_RESOLVE` (giữ) | 7 vai trên (R-ACC-INT, R-PLAN không có) |
| 3 | Nguyên liệu | `/pwa/raw-intake-capture` | Nhập theo phiếu | FileInput | `RAW_INTAKE_FIELD_CAPTURE` (giữ) | R-ACC-INT, R-PLAN |
| 4 | Nguyên liệu | `/pwa/raw-lot-scan` | Lô nguyên liệu | Sprout | `RAW_INTAKE_RECEIVE` ∨ `RAW_QC_SIGN` ∨ `MATERIAL_ISSUE_EXECUTE` (nay: `MOBILE_TASK_VIEW`) | R-WH-RAW, R-QC-RAW |
| 5 | Nguyên liệu | `/pwa/raw-lot-qc-reset` | Lô cũ chờ kiểm | ArchiveRestore | `INVENTORY_ADJUSTMENT_CREATE` ∧ `RAW_INTAKE_RECEIVE` (nay: chỉ quyền đầu) — CHƯA RÕ §8.5 | R-WH-RAW (R-WH-FG ẩn) |
| 6 | Sản xuất | `/pwa/workforce-check` | Vào/ra ca | Clock | `WORK_ORDER_EXECUTE` (nay: `MOBILE_TASK_VIEW`) | R-PROD-OP |
| 7 | Sản xuất | `/pwa/production-execution` | Ghi sản xuất | Factory | `PROCESS_EVENT_RECORD` ∨ `MATERIAL_RECEIPT_CONFIRM` (nay: `MOBILE_TASK_VIEW`) | R-PROD-OP |
| 8 | Kiểm (KCS/QA) | `/pwa/lot-mark-ready` | Lô sẵn sàng | BadgeCheck | `RAW_LOT_MARK_READY` (nay: `MOBILE_TASK_VIEW`) | R-QA-REL |
| 9 | Kiểm (KCS/QA) | `/pwa/qc-checklist` | Phiếu kiểm KCS | Microscope | `QC_INSPECTION_SIGN` (nay: `MOBILE_TASK_VIEW`) | R-QC-PROD, R-QC-RAW |
| 10 | Kho & đóng gói | `/pwa/packaging` | Đóng gói | Package | `PACKAGING_JOB_COMPLETE` ∨ `PRINT_JOB_MARK_FAILED` ∨ `QR_REPRINT` (nay: `MOBILE_TASK_VIEW`) | R-PACK-OP |
| 11 | Kho & đóng gói | `/pwa/qr-scan` | Kiểm tem QR | QrCode | `QR_VIEW` ∧ `MOBILE_SCAN_RESOLVE` (nay: `MOBILE_TASK_VIEW`) — CHƯA RÕ §8.4 | R-PACK-OP, R-QA-REL |
| 12 | Kho & đóng gói | `/pwa/warehouse-receipt` | Nhập thành phẩm | Warehouse | `WAREHOUSE_RECEIPT_CONFIRM` (nay: `MOBILE_TASK_VIEW`) | R-WH-FG |
| 13 | Truy xuất & thu hồi | `/pwa/trace-scan` | Truy xuất | Network | `MOBILE_TASK_VIEW` ∧ `MOBILE_SCAN_RESOLVE` ∧ `TRACE_INTERNAL_VIEW` (giữ) | R-QA-REL |
| 14 | Truy xuất & thu hồi | `/pwa/recall-evidence` | Ảnh thu hồi | FileWarning | `RECALL_CAPA_EVIDENCE_ADD` (nay: `MOBILE_TASK_VIEW`) | R-QA-REL |
| 15 | Truy xuất & thu hồi | `/pwa/sale-lock-ack` | Khoá bán | Lock | `RECALL_CASE_VIEW` (nay: `MOBILE_TASK_VIEW`) | R-QA-REL, R-WH-FG |
| 16 | Máy & tài khoản | `/pwa/offline-queue` | Hàng đợi | CloudUpload | `MOBILE_OPERATIONAL_SYNC` (giữ) | 9 vai có quyền app |
| 17 | Máy & tài khoản | `/pwa/settings/device` | Ghép máy | TabletSmartphone | `MOBILE_TASK_VIEW` (giữ) | 9 vai có quyền app |
| 18 | Máy & tài khoản | `/pwa/account` (mới) | Tài khoản | CircleUser | đã đăng nhập | mọi vai đăng nhập được |

R-ADMIN thấy hết (bỏ qua quyền bằng `ADMIN_FULL` ở `shopfloor-navigation-policy.ts`). Số mục mỗi vai thấy (ngoài nhóm Máy & tài khoản): R-PROD-OP 4 ·
R-PACK-OP 4 · R-WH-RAW 4 · R-WH-FG 4 · R-QC-RAW 4 · R-QC-PROD 3 · R-QA-REL 7 · R-ACC-INT/R-PLAN 1 (nay ai có `MOBILE_TASK_VIEW` thấy 12/17 mục).
Ghi chú hiện trạng: 6 loại việc (tiếp nhận hàng giao, xuất NL, nhận NL, biên bản sơ chế, KCS thành phẩm, Cấp 2/tem in lỗi/in lại) **không có mục menu nào lọc sẵn** — chỉ tìm được bằng ô "Loại công việc" ở Danh sách việc ⇒ thêm hàng **chip loại việc** (§1b) trên các màn danh sách.

### 1b. Loại việc → chip, màn, quyền (dùng cho chip, tiêu đề thẻ, tiêu đề chi tiết việc)

Chip chỉ hiện khi người dùng có quyền thao tác loại đó; màn chỉ có 1 chip thì ẩn hàng chip. Không có chip "Tất cả" trên màn công đoạn (API lọc 1 loại/lần).

| Mã loại (`taskType`) | Tên việc (tiêu đề) | Chip | Màn | Quyền thao tác | Vai | Mô tả 1 câu (chi tiết việc) |
|---|---|---|---|---|---|---|
| RAW_INTAKE_CAPTURE | Tiếp nhận hàng giao | Tiếp nhận | raw-lot-scan | RAW_INTAKE_RECEIVE | R-WH-RAW | Ghi số thực nhận, mã lô, hạn dùng, vị trí và ảnh phiếu giao; hệ thống tạo lô chờ KCS. |
| RAW_LOT_QC | KCS lô nguyên liệu | KCS lô | raw-lot-scan | RAW_QC_SIGN | R-QC-RAW | Kiểm lô vừa nhận và ký kết quả Đạt, Giữ lại hoặc Loại kèm ảnh mẫu. |
| MATERIAL_ISSUE_EXECUTION | Xuất nguyên liệu | Xuất cho xưởng | raw-lot-scan | MATERIAL_ISSUE_EXECUTE | R-WH-RAW | Xuất đúng lô, đúng số lượng theo phiếu xuất đã duyệt; lúc này tồn kho mới bị trừ. |
| RAW_LOT_READINESS | Duyệt lô sẵn sàng | — | lot-mark-ready | RAW_LOT_MARK_READY | R-QA-REL | Chuyển lô đã KCS đạt sang "Sẵn sàng sản xuất" để kho được cấp cho xưởng. |
| MATERIAL_RECEIPT_CONFIRMATION | Nhận nguyên liệu | Nhận NL | production-execution | MATERIAL_RECEIPT_CONFIRM | R-PROD-OP | Xác nhận đã nhận nguyên liệu kho xuất xuống, ghi chênh lệch nếu có. |
| PRODUCTION_STAGE_EXECUTION | Ghi công đoạn | Công đoạn | production-execution | PROCESS_EVENT_RECORD | R-PROD-OP | Ghi bắt đầu, hoàn tất, tạm dừng hoặc không đạt của từng công đoạn trong mẻ. |
| PREPROCESSING_RECORD | Biên bản sơ chế | Sơ chế | production-execution | PROCESS_EVENT_RECORD | R-PROD-OP | Ghi đầu vào, đầu ra, hao hụt, người phụ trách, thiết bị và ảnh khi sơ chế xong. |
| WORKFORCE_CHECK | Vào/ra ca | — | workforce-check | WORK_ORDER_EXECUTE | R-PROD-OP | Check-in đầu ca, Check-out cuối ca trên lệnh công việc đang làm. |
| QC_AFTER_DRYING | KCS sau sấy | Sau sấy | qc-checklist | QC_INSPECTION_SIGN | R-QC-PROD, R-QC-RAW | Kiểm mẫu sau sấy thăng hoa (độ ẩm, cảm quan) rồi ký kết quả. |
| FINISHED_GOODS_QC | KCS thành phẩm | Thành phẩm | qc-checklist | QC_INSPECTION_SIGN | R-QC-PROD, R-QC-RAW | Ghi số thành phẩm đạt và không đạt của mẻ rồi ký kết quả. |
| PACKAGING_L1_EXECUTION | Đóng gói Cấp 1 | Cấp 1 | packaging | PACKAGING_JOB_COMPLETE | R-PACK-OP | Xác nhận số gói đạt và lỗi của lệnh đóng gói Cấp 1. |
| PACKAGING_L2_EXECUTION | Đóng gói Cấp 2 | Cấp 2 | packaging | PACKAGING_JOB_COMPLETE | R-PACK-OP | Xác nhận số hộp, thùng đạt của lệnh đóng gói Cấp 2. |
| PACKAGING_PRINT_EXCEPTION | Báo tem in lỗi | Tem in lỗi | packaging | PRINT_JOB_MARK_FAILED | R-PACK-OP | Báo tem QR hoặc tem biến đổi in lỗi để làm cơ sở in lại. |
| PACKAGING_REPRINT_REQUEST | Xin in lại tem | In lại tem | packaging | QR_REPRINT | R-PACK-OP | Xin in lại tem đã in nhưng sai hoặc nhoè; hệ thống tạo lệnh in và QR thay thế. |
| QR_CODE_VERIFY | Kiểm tem QR | — | qr-scan | QR_VIEW | R-PACK-OP, R-QA-REL | Quét tem đã dán để đối chiếu với đơn vị đóng gói; chỉ ghi lượt kiểm. |
| WAREHOUSE_FG_RECEIPT | Nhập kho thành phẩm | — | warehouse-receipt | WAREHOUSE_RECEIPT_CONFIRM | R-WH-FG | Xác nhận phiếu nhập kho của mẻ đã phát hành; tồn thành phẩm tăng. |
| TRACE_FIELD_SCAN | Truy xuất tại chỗ | — | trace-scan | TRACE_INTERNAL_VIEW | R-QA-REL | Ghi nhận bạn đã kiểm mã này tại kho, đại lý hoặc nơi có khiếu nại. |
| RECALL_FIELD_EVIDENCE | Bằng chứng thu hồi | — | recall-evidence | RECALL_CAPA_EVIDENCE_ADD | R-QA-REL | Thêm ảnh, video hiện trường vào CAPA của hồ sơ thu hồi đang mở. |
| SALE_LOCK_FIELD_ACK | Xác nhận khoá bán | — | sale-lock-ack | RECALL_CASE_VIEW | R-QA-REL, R-WH-FG | Xác nhận đã thấy lệnh khoá bán, đã cách ly hàng và dán biển; không mở khoá. |

## 2. Thanh đáy 4 ô (cố định, mọi màn trừ đăng nhập/đổi mật khẩu/Ghép máy chặn)

| Ô | Nhãn | Icon | Route | Huy hiệu |
|---|---|---|---|---|
| 1 | Việc | ClipboardList | trang chủ theo vai: `/pwa/tasks`; vai chỉ có `RAW_INTAKE_FIELD_CAPTURE` (R-ACC-INT, R-PLAN) → `/pwa/raw-intake-capture` | không số (CHƯA RÕ §8.1) |
| 2 | Quét | ScanLine | `/pwa/scan`; vai thiếu `MOBILE_SCAN_RESOLVE` → `/pwa/raw-intake-capture` bước quét phiếu (CHƯA RÕ §8.6) | — |
| 3 | Hàng đợi | CloudUpload | `/pwa/offline-queue` | số lệnh chờ gửi (Chờ gửi + Lỗi thử lại + Đang gửi, gồm phiếu nhập theo phiếu); chấm đỏ nếu có lệnh "Cần xem lại"; ẩn khi 0 |
| 4 | Tài khoản | CircleUser | `/pwa/account` | chấm vàng: máy chưa ghép hoặc mã ghép còn < 3 ngày (CHƯA RÕ §8.10); chấm đỏ: mã ghép hết hạn/không dùng được |

Ô đang mở tô màu; màn chi tiết việc tô ô "Việc". Nhãn không cắt; chạm ≥ 48px.

## 3. Từng màn (17 route + màn lỗi; đăng nhập, đổi mật khẩu, Ghép máy, Tài khoản ở §4)

Cột "Máy" = cần ghép máy hay không · "Offline" = dùng được khi mất mạng không. Các màn danh sách (#5–#16) dùng chung bố cục:
hàng chip (§1b) → danh sách thẻ (tên việc · mã đối tượng · trạng thái · hạn · nhãn "Cần quét"/"Cần ảnh") → bấm thẻ mở chi tiết; nút "Tải lại" ở thanh trên.

| # | Route | Tiêu đề | Breadcrumb | Mô tả 1 câu | Cách làm | Trạng thái rỗng | Máy · Offline |
|---|---|---|---|---|---|---|---|
| 1 | `/pwa/tasks` | Việc của tôi | Xưởng › Việc của tôi › Danh sách việc | Các việc đang chờ bạn làm ở xưởng; bấm một việc để mở và làm. | 1) Chọn loại việc ở hàng chip nếu cần. 2) Bấm thẻ việc. 3) Làm theo các bước trong việc. 4) Bấm Tải lại để xem việc mới. | "Chưa có việc nào cho bạn. Khi có việc mới, bấm Tải lại để xem." · lọc: "Không có việc loại này — chọn chip khác." | Cần · Được: hiện bản lưu, ghi "Đang xem bản lưu lúc hh:mm" |
| 2 | `/pwa/tasks/[taskId]` | Động: "<Tên việc>" (§1b) + dòng phụ mã đối tượng | Xưởng › <Nhóm> › <Màn danh sách> › <mã> | Mô tả theo loại việc (§1b cột cuối). | 1) Chọn thao tác nếu việc có nhiều (vd Check-in / Check-out). 2) Bấm "Quét bằng camera", đưa mã trên lô/phiếu/tem vào khung (hoặc bấm máy quét cầm tay). 3) Điền các ô có dấu *. 4) Chụp ảnh nếu việc cần. 5) Tick "Tôi đã kiểm…" rồi bấm "Lưu và gửi". | Không tìm thấy: "Việc này không còn — có thể đã xong hoặc bị huỷ. Quay lại danh sách và bấm Tải lại." | Cần · Được nếu đã mở việc khi online (lệnh vào Hàng đợi) |
| 3 | `/pwa/scan` | Quét mã | Xưởng › Việc của tôi › Quét mã | Quét một mã bất kỳ (lô, mẻ, phiếu, tem QR) để biết đó là gì và mở việc liên quan. | 1) Bấm "Quét bằng camera" hoặc dùng máy quét cầm tay. 2) Bấm "Xem mã này". 3) Đọc kết quả: là gì, có đang bị giữ hay khoá bán. 4) Bấm "Mở việc liên quan". | Chưa quét: "Chưa quét mã nào. Bấm Quét bằng camera để bắt đầu." · không có việc: "Mã này không có việc nào cần làm." | Cần · Không: "Cần có mạng để nhận ra mã." |
| 4 | `/pwa/raw-intake-capture` | Nhập nguyên liệu theo phiếu | Xưởng › Nguyên liệu › Nhập theo phiếu | Ghi nhận nguyên liệu NCC giao theo phiếu giao quét được để lập phiếu nhập. | 1) Chọn NCC (chưa có thì "Tạo nhanh"). 2) Chọn kho, đánh giá chất lượng: Đạt mới làm tiếp. 3) Bấm "Nhập", quét QR trên phiếu giao. 4) Kiểm 9 ô điền sẵn; sửa ô nào ghi lý do. 5) Bấm "Đồng ý nhập" rồi chụp ảnh xác nhận. | "Chưa có phiếu nào đang làm. Bắt đầu ở Bước 1: chọn NCC." · NCC trống: "Chưa có danh sách NCC trên máy — mở app khi online một lần để tải." | Gửi thẳng: không cần; lưu offline: cần · Được (NCC/kho từ bản lưu, phiếu + ảnh giữ trên máy) |
| 5 | `/pwa/raw-lot-scan` | Lô nguyên liệu | Xưởng › Nguyên liệu › Lô nguyên liệu | Việc với lô nguyên liệu: tiếp nhận hàng giao, KCS lô, xuất cho xưởng. | 1) Chọn chip: Tiếp nhận · KCS lô · Xuất cho xưởng. 2) Bấm thẻ lô/phiếu. 3) Quét mã trên lô hoặc phiếu. 4) Điền số lượng hoặc kết quả KCS, chụp ảnh. 5) Tick xác nhận, bấm "Lưu và gửi". | Tiếp nhận: "Chưa có hàng giao chờ tiếp nhận." · KCS lô: "Không có lô nào chờ KCS." · Xuất: "Chưa có phiếu xuất đã duyệt." + "Bấm Tải lại khi có hàng/phiếu mới." | Cần · Được |
| 6 | `/pwa/raw-lot-qc-reset` | Đưa lô cũ về chờ kiểm | Xưởng › Nguyên liệu › Lô cũ chờ kiểm | Lập phiếu điều chỉnh có duyệt để đưa lô nhập trước luật kiểm mà chưa ký KCS về chờ kiểm. | 1) Quét hoặc nhập mã lô, bấm "Tìm lô". 2) Chọn dòng tồn (vị trí), nhập số lượng. 3) Ghi lý do, quét mã trên phiếu điều chỉnh giấy. 4) Chụp ảnh xác nhận. 5) Bấm "Lập phiếu điều chỉnh" — chờ quản lý vận hành duyệt. | "Quét mã lô để bắt đầu." · "Lô này không còn dòng tồn nào." | Không cần · Không |
| 7 | `/pwa/lot-mark-ready` | Duyệt lô sẵn sàng | Xưởng › Kiểm (KCS/QA) › Lô sẵn sàng | Chuyển lô nguyên liệu đã KCS đạt sang Sẵn sàng sản xuất để kho được cấp cho xưởng. | 1) Bấm thẻ lô đã KCS đạt. 2) Quét mã trên lô. 3) Xem điều kiện; thiếu gì app ghi rõ. 4) Chụp ảnh, tick xác nhận, bấm "Lưu và gửi". | "Không có lô KCS đạt nào chờ duyệt sẵn sàng." | Cần · Được |
| 8 | `/pwa/workforce-check` | Vào/ra ca | Xưởng › Sản xuất › Vào/ra ca | Check-in đầu ca, Check-out cuối ca trên lệnh công việc bạn đang làm. | 1) Bấm thẻ lệnh công việc của ca. 2) Chọn Check-in hoặc Check-out. 3) Quét mã trên phiếu lệnh công việc. 4) Kiểm công đoạn, ca, giờ ghi nhận. 5) Tick xác nhận, bấm "Lưu và gửi". | "Chưa có lệnh công việc nào đang chạy. Hỏi tổ trưởng lệnh của ca này." | Cần · Được — đừng lưu Check-in và Check-out cùng lúc khi chưa gửi (sẽ xung đột, HDSD 11.1) |
| 9 | `/pwa/production-execution` | Ghi sản xuất | Xưởng › Sản xuất › Ghi sản xuất | Nhận nguyên liệu từ kho và ghi từng công đoạn của mẻ: sơ chế, chế biến, cấp đông, sấy thăng hoa. | 1) Chọn chip: Nhận NL · Công đoạn · Sơ chế. 2) Bấm thẻ mẻ/phiếu. 3) Quét mã trên phiếu. 4) Chọn công đoạn theo thứ tự Sơ chế → Chế biến → Cấp đông → Sấy thăng hoa, chọn trạng thái, điền thông số, chụp ảnh. 5) Tick xác nhận, bấm "Lưu và gửi". | Công đoạn/Sơ chế: "Không có mẻ nào chờ ghi." · Nhận NL: "Kho chưa xuất nguyên liệu nào cho bạn nhận." | Cần · Được |
| 10 | `/pwa/qc-checklist` | Phiếu kiểm KCS | Xưởng › Kiểm (KCS/QA) › Phiếu kiểm KCS | Kiểm mẫu sau sấy và kiểm thành phẩm của mẻ, rồi ký kết quả. | 1) Chọn chip Sau sấy hoặc Thành phẩm. 2) Bấm thẻ mẻ. 3) Quét mã mẻ. 4) Nhập độ ẩm, cảm quan (sau sấy) hoặc số đạt/không đạt (thành phẩm); chọn Đạt / Giữ lại / Loại, Giữ lại hoặc Loại thì ghi lý do. 5) Chụp ảnh mẫu, tick xác nhận, bấm "Lưu và gửi". | "Không có mẻ nào chờ KCS." | Cần · Được |
| 11 | `/pwa/packaging` | Đóng gói | Xưởng › Kho & đóng gói › Đóng gói | Xác nhận số gói, hộp đạt và lỗi của lệnh đóng gói; báo tem in lỗi hoặc xin in lại tem. | 1) Chọn chip: Cấp 1 · Cấp 2 · Tem in lỗi · In lại tem. 2) Bấm thẻ lệnh đóng gói. 3) Quét mã lệnh hoặc tem. 4) Nhập số đầu vào, đạt, lỗi (lỗi thì ghi lý do), chụp ảnh. 5) Tick xác nhận, bấm "Lưu và gửi". | "Không có lệnh đóng gói nào đang chờ." | Cần · Được (trừ lỗi bao bì in sẵn của NCC: báo kho tạm giữ/trả NCC) |
| 12 | `/pwa/qr-scan` | Kiểm tem QR | Xưởng › Kho & đóng gói › Kiểm tem QR | Quét tem QR đã dán để đối chiếu với đơn vị đóng gói; chỉ ghi lượt kiểm, không đổi tem. | 1) Bấm thẻ việc kiểm tem. 2) Quét tem QR hoặc mã vạch trên hộp. 3) Xem Khớp / Không khớp. 4) Bấm "Lưu và gửi". | "Không có tem nào chờ kiểm." | Cần · Được |
| 13 | `/pwa/warehouse-receipt` | Nhập kho thành phẩm | Xưởng › Kho & đóng gói › Nhập thành phẩm | Xác nhận phiếu nhập kho của mẻ đã phát hành khi hàng về tới kho. | 1) Bấm thẻ phiếu nhập kho. 2) Quét mã trên phiếu hoặc thùng. 3) Kiểm từng dòng số lượng, ghi chú nếu chênh. 4) Chụp ảnh hàng nhập. 5) Tick xác nhận, bấm "Lưu và gửi". | "Không có phiếu nhập kho nào chờ xác nhận." | Cần · Được |
| 14 | `/pwa/trace-scan` | Truy xuất tại chỗ | Xưởng › Truy xuất & thu hồi › Truy xuất | Quét mã sản phẩm ở kho hay đại lý để xem nguồn gốc và ghi nhận đã kiểm tại chỗ. | 1) Bấm "Quét bằng camera", đưa tem QR hoặc mã mẻ vào khung. 2) Bấm "Xem mã này". 3) Đọc tóm tắt: sản phẩm, mẻ, lô NL chính, tồn. 4) Bấm "Mở việc truy xuất" để ghi nhận. | "Chưa quét mã nào." · "Mã này chưa gắn với mẻ nào nên chưa có gì để xem." | Cần · Không |
| 15 | `/pwa/recall-evidence` | Bằng chứng thu hồi | Xưởng › Truy xuất & thu hồi › Ảnh thu hồi | Chụp ảnh, quay video tại hiện trường gửi vào CAPA của hồ sơ thu hồi đang mở. | 1) Bấm thẻ hồ sơ thu hồi. 2) Quét mã hàng tại hiện trường. 3) Chụp ảnh hoặc quay video, ghi chú. 4) Tick xác nhận, bấm "Lưu và gửi". | "Không có hồ sơ thu hồi nào cần ảnh hiện trường." | Cần · Được (ảnh giữ trên máy) |
| 16 | `/pwa/sale-lock-ack` | Xác nhận khoá bán | Xưởng › Truy xuất & thu hồi › Khoá bán | Xác nhận bạn đã thấy lệnh khoá bán, đã cách ly hàng và dán biển; việc này không mở khoá. | 1) Bấm thẻ lệnh khoá bán. 2) Tới chỗ hàng, quét mã trên hàng. 3) Cách ly hàng, dán biển, ghi chú. 4) Tick xác nhận, bấm "Lưu và gửi". | "Không có lệnh khoá bán nào chờ xác nhận." | Cần · Được |
| 17 | `/pwa/offline-queue` | Hàng đợi | Xưởng › Máy & tài khoản › Hàng đợi | Các lệnh bạn đã lưu trên máy này và kết quả gửi lên hệ thống. | 1) Xem số Chờ gửi · Lỗi thử lại · Cần xem lại · Đã gửi. 2) Online: bấm "Gửi tất cả" (đợt 3: app tự gửi khi có mạng, PWA-03). 3) Lệnh "Cần xem lại": đọc lý do, sửa ở việc gốc rồi lưu lệnh mới. 4) Bấm "Dọn mục đã gửi". | "Không có lệnh nào chờ gửi. Mọi việc đã lên hệ thống." | Xem: không cần, gửi: cần · Xem được |
| 18 | `error.tsx` | Có lỗi xảy ra | giữ breadcrumb màn đang mở | Màn này gặp sự cố; các lệnh chưa gửi vẫn còn trên máy. | 1) Bấm "Thử lại". 2) Vẫn lỗi: bấm "Về danh sách việc". 3) Báo quản trị kèm mã lỗi bên dưới. | — | — |

Chi tiết việc — nút quay lại `‹ <tên màn>`: về đúng màn danh sách đã mở (giữ chip); mở thẳng từ quét/đường dẫn → màn theo loại việc (cột "Màn" §1b);
không xác định → Danh sách việc. Form chi tiết (đợt 3): ẩn ô "Loại bằng chứng" (14 lựa chọn), "Tham chiếu bằng chứng", "Công đoạn / dòng phiếu", "Nguồn quét",
"Trạng thái đích", "Mã hành động" — app tự điền theo việc; chỉ hỏi người dùng thứ họ thật sự biết (số lượng, kết quả, ảnh, lý do).

## 4. Đăng nhập · Đổi mật khẩu · Ghép máy · Tài khoản

### 4.1 Đăng nhập `/pwa/login` — bố cục và chữ y như `admin-web/src/features/auth/LoginPage.tsx`, chỉ đổi 2 dòng đầu
| Phần | Chữ |
|---|---|
| Dòng phụ (trên) / tiêu đề | "Ứng dụng vận hành tại xưởng" / **"Ginsengfood Xưởng"** (admin: "Hệ thống quản lý vận hành" / "Ginsengfood Quản trị") |
| Ô 1 | "Tên đăng nhập *" · gợi ý "Nhập tên đăng nhập" · bỏ trống: "Vui lòng nhập tên đăng nhập" |
| Ô 2 | "Mật khẩu *" · gợi ý "Nhập mật khẩu" · bỏ trống: "Vui lòng nhập mật khẩu" |
| Nút | "Đăng nhập" (đang gửi: nút quay) · bỏ dòng "cookie bảo mật; PWA không lưu token" (TA#4) |
| Báo sau đổi mật khẩu | "Đã đổi mật khẩu. Đăng nhập lại bằng mật khẩu mới." |
| Báo sau hết phiên | "Các lệnh chưa gửi vẫn còn trên máy. Đăng nhập lại để gửi tiếp." |
| Lỗi | sai tài khoản/mật khẩu (401, `AUTH_INVALID_CREDENTIALS`): "Sai tên đăng nhập hoặc mật khẩu." · `FORBIDDEN`: "Tài khoản đang bị khóa hoặc không được phép đăng nhập." · `RATE_LIMITED`: "Bạn đã thử đăng nhập quá nhiều lần. Vui lòng đợi ít phút rồi thử lại." · mạng: "Không kết nối được máy chủ. Kiểm tra wifi rồi thử lại." · thiếu `MOBILE_TASK_VIEW` (PWA-02, nay đá về đăng nhập lặp): "Tài khoản của bạn chưa được dùng app xưởng. Nhờ quản trị gán vai phù hợp." |
| Sau đăng nhập | về trang chủ theo vai (ô "Việc" §2); máy chưa ghép cho người này → màn Ghép máy (chặn). Chừa chỗ lối "Đăng nhập bằng mail công ty" — chữ theo admin khi WP26 làm. |

### 4.2 Đổi mật khẩu `/pwa/change-password` — y như `admin-web/.../ChangePasswordPage.tsx`
Đầu thẻ: "Ginsengfood Xưởng" · tiêu đề "Đổi mật khẩu" · "Tài khoản: <họ tên>". Bắt buộc đổi: "Tài khoản này bắt buộc đổi mật khẩu ở lần đăng nhập đầu tiên. Hãy đặt
mật khẩu mới để vào app." Ô: "Mật khẩu hiện tại *" ("Nhập mật khẩu hiện tại") · "Mật khẩu mới *" ("Nhập mật khẩu mới", dòng gợi ý = luật mật khẩu
`password-policy.ts:17`) · "Xác nhận mật khẩu mới *" ("Nhập lại mật khẩu mới"; lệch: "Mật khẩu xác nhận không khớp"). Nút "Đổi mật khẩu" + "Quay lại"
(bắt buộc đổi: "Đăng xuất"). Thành công: "Đổi mật khẩu thành công. Đang chuyển về trang đăng nhập…". Lỗi giữ `shopfloor-change-password-client.tsx:22-25`.

### 4.3 Ghép máy `/pwa/settings/device` (màn chặn duy nhất; bỏ khung "Thiết bị · Cần thiết lập" ở 15 màn)
- Tiêu đề **Ghép máy** · breadcrumb `Xưởng › Máy & tài khoản › Ghép máy` · mô tả: "Ghép máy này với tài khoản của bạn để tải việc và gửi kết quả lên hệ thống."
- Cách làm: 1) Nhờ quản trị mở **Hệ thống › Thiết bị xưởng** trên máy tính, bấm "Cấp phiên thiết bị" đúng tên bạn và máy này — màn hiện mã QR.
  2) Bấm **"Quét mã ghép"**, đưa QR vào khung. 3) Kiểm thẻ hiện ra: "Máy: <tên máy> · Tài khoản: <họ tên> · Dùng đến: dd/MM/yyyy". 4) Đúng thì bấm **"Xong"**
  (app mở trang chủ); sai thì bấm "Không phải máy này" và quét lại. (Admin thật ghi "Thiết bị xưởng", không phải "Thiết bị di động" như bản rà; hộp "Mã phiên vừa cấp" đợt 2 đổi thành "Mã ghép máy" + QR + câu "Đưa người dùng quét bằng app xưởng: Ghép máy › Quét mã ghép.")
- Dự phòng (gập, nhãn "Nhập tay nếu không quét được"): "Mã thiết bị *" (gợi ý "Ví dụ XUONG_01") · "Mã ghép *" (ô mật khẩu, có nút hiện/ẩn) · nút "Ghép máy".
  Bỏ ô "Nhãn thiết bị" (lấy từ QR/máy chủ).
- Đã ghép: thẻ "Máy này đã ghép" + tên máy, mã thiết bị, hạn dùng + nút "Ghép lại bằng mã mới". Mục "Nâng cao" (gập): nút đỏ "Xóa dữ liệu chưa gửi trên máy"
  → hộp xác nhận (giữ luồng `shopfloor-pwa-dialogs.tsx`, chữ §5).
- Mã giữ qua đăng xuất cho đúng (người, máy) (D-m12-101): cùng người đăng nhập lại → vào thẳng, không hiện màn này; người khác → màn này với câu "chưa ghép".

| Tình huống | App biết bằng cách nào | Câu báo |
|---|---|---|
| Chưa ghép | máy chưa lưu mã cho tài khoản này | "Máy này chưa ghép với tài khoản của bạn. Nhờ quản trị cấp mã ghép rồi bấm Quét mã ghép." |
| Mã sai | QR không đúng khuôn mã ghép; hoặc gõ tay sai | "Đây không phải mã ghép máy hoặc mã bị gõ sai. Quét lại đúng mã quản trị đưa." |
| Mã hết hạn | hạn trong QR < hôm nay (cần khuôn QR §8.3) | "Mã ghép đã hết hạn ngày dd/MM/yyyy. Nhờ quản trị cấp mã mới." |
| Mã bị thu hồi | máy chủ chưa nói lý do (§8.2) | "Quản trị đã thu hồi mã ghép của máy này. Nhờ quản trị cấp mã mới nếu vẫn dùng máy." |
| Máy/mã của người khác | tên đăng nhập trong QR ≠ người đang đăng nhập (§8.3) | "Mã này cấp cho tài khoản khác. Nhờ quản trị cấp mã đúng tên bạn trên máy này." |
| Máy chủ từ chối, không rõ lý do | 403 `MOBILE_DEVICE_SESSION_INVALID` (mọi lý do trên đều ra mã này) | "Mã ghép không dùng được nữa (sai, hết hạn, bị thu hồi hoặc của người khác). Nhờ quản trị cấp mã mới rồi quét lại. Lệnh chưa gửi vẫn còn trên máy. (mã: MOBILE_DEVICE_SESSION_INVALID)" |
| Offline khi ghép | không gọi được máy chủ | "Cần online để kiểm mã ghép. Kết nối wifi rồi bấm Thử lại." |
| Camera bị chặn | trình duyệt từ chối camera | "App chưa được dùng camera. Cho phép camera trong trình duyệt, hoặc mở Nhập tay." |

### 4.4 Tài khoản `/pwa/account` (mới, theo `admin-web/src/features/account/AccountProfilePage.tsx`)
- Tiêu đề **Tài khoản** · breadcrumb `Xưởng › Máy & tài khoản › Tài khoản` · mô tả: "Thông tin của bạn, máy đang dùng, đổi mật khẩu và đăng xuất."
- Cách làm: 1) Kiểm tên và vai của bạn. 2) Xem máy đang ghép và hạn dùng; sắp hết hạn thì nhờ quản trị cấp mã mới. 3) Đổi mật khẩu khi cần. 4) Hết ca: bấm Đăng xuất.

| Khối | Nội dung (nguồn) |
|---|---|
| Thông tin | avatar chữ cái đầu · Họ tên · "Tên đăng nhập: <…>" (`/auth/me`: `displayName`, `username`) |
| Vai trò | huy hiệu tên vai tiếng Việt theo `admin-web/src/lib/utils/role-identity.ts` (vd R-PROD-OP "Nhân viên sản xuất", R-QC-RAW "QC nguyên liệu" → hiển thị "KCS nguyên liệu" theo D-m12-118); không vai: "Chưa được gán vai nào — nhờ quản trị gán." · dòng "Việc bạn làm được": các nhãn menu §1 mà vai thấy |
| Máy này | Tên máy · Mã thiết bị · Trạng thái: "Đã ghép" / "Chưa ghép" / "Hết hạn" · "Dùng đến: dd/MM/yyyy HH:mm" (bootstrap `deviceSessionExpiresAt`) · "Lệnh chờ gửi: N" · nút "Ghép máy" |
| Bảo mật | nút "Đổi mật khẩu" (KeyRound) → `/pwa/change-password` · "Phiên đăng nhập hết sau 1 ca" (D-m12-119) |
| Đăng xuất | nút "Đăng xuất" (LogOut, viền đỏ) → hộp xác nhận bên dưới |
| Chân | "Phiên bản app: <v>" · offline: "Đang offline — thông tin lần tải gần nhất." |

Hộp xác nhận đăng xuất: tiêu đề **"Đăng xuất khỏi app xưởng?"** · nội dung "Máy vẫn giữ ghép máy và các lệnh chưa gửi của bạn. Lần sau đăng nhập lại là làm tiếp
được." · có lệnh chờ: thêm "Còn N lệnh chưa gửi — chúng nằm trên máy và chỉ gửi được khi bạn đăng nhập lại." · nút "Ở lại" (mặc định) / "Đăng xuất".

## 5. Bảng thay chữ kỹ thuật → chữ cho công nhân (tệp trong `apps/shopfloor-pwa/`; dòng @ `ee99e9fd6`)

| Tệp:dòng | Chữ cũ | Chữ mới |
|---|---|---|
| `src/components/shopfloor-shell.tsx:36-54` | 17 nhãn menu, 3 nghĩa dùng chung icon `package-check`/`shield-alert`/`qr` | theo §1 + §7 |
| `shopfloor-shell.tsx:343-347` (TA#2) | "PWA đang xác thực cookie phiên với server…", "…truy cập Shopfloor PWA." | "Đang kiểm tra đăng nhập…" · "Bạn cần đăng nhập để dùng app xưởng." |
| `shopfloor-shell.tsx:365` | "Hiệu chỉnh thiết bị" | bỏ — dẫn sang Ghép máy |
| `shopfloor-shell.tsx:401,405,433-434` | "Điều hướng Shopfloor", "Xưởng vận hành", "Xưởng vận hành Ginsengfood" / "Ứng dụng vận hành tại xưởng" | "Menu app xưởng" · thanh trên chỉ còn tên trang (§0) |
| `shopfloor-shell.tsx:441-444` (TA#1) | "API kết nối" / "API không phản hồi" / "Đang kiểm tra API" | ẩn khi ổn · "Không liên lạc được máy chủ" · dải "Đang offline — …" |
| `shopfloor-shell.tsx:460,465` (TA#3) | "Không có quyền mở màn hình" + "…lọc theo effective permissions do server trả về. Backend vẫn là lớp authorization cuối cùng." | "Bạn không dùng được màn này" + "Tài khoản của bạn chưa có quyền làm việc ở màn này. Chọn việc khác trong menu hoặc nhờ quản trị kiểm tra vai." |
| `shopfloor-shell.tsx:466` (TA#3) | "PWA đang offline hoặc chưa nhận được effective permissions từ server…" | "Chưa kiểm tra được quyền vì đang offline. Có mạng lại app tự kiểm tra; lệnh chưa gửi vẫn còn trên máy." |
| `shopfloor-auth-clients.tsx:56-58,68,77` (TA#4) | "Xưởng vận hành" / "Đăng nhập vận hành" / "cookie…token" / "tài khoản vận hành" / "mật khẩu" | theo §4.1 |
| `shopfloor-auth-clients.tsx:97` | "Hàng đợi và bằng chứng offline đã được giữ nguyên. … bấm Đồng bộ…" | "Các lệnh chưa gửi vẫn còn trên máy. Đăng nhập lại để gửi tiếp." |
| `shopfloor-pwa-display.ts:209,245` (TA#5) | "UNAUTHORIZED: …" (mã đầu câu) | câu trước, "(mã: …)" cuối câu (§6) |
| `shopfloor-pwa-display.ts:24,31,33,34,71,83,84,92,101,102` (TA#11) | "Work order sẵn sàng", "Sale-lock đang hiệu lực", "Đang xử lý disposition", "Đang CAPA", "Chỉ online", "Đã release", "Đã duyệt release", "Disposition", "CAPA" | "Lệnh công việc sẵn sàng", "Đang khoá bán", "Đang xử lý hàng thu hồi", "Đang khắc phục (CAPA)", "Chỉ online" (giữ, D-m12-118), "Đã phát hành", "Đã duyệt phát hành", "Xử lý hàng thu hồi", "CAPA" |
| `shopfloor-pwa-display.ts:22,65,66,76,94,100` + `field-quality-fields.tsx:246-248` | "Đã KCS, chờ…", "Dừng thử lại - cần rà soát", "Cho phép" (cột Ngoại tuyến), "QC giữ lại", "Cũ dữ liệu", "Đã QC", "QC đạt/QC giữ lại/QC loại" | giữ / "Cần xem lại" / "Làm được offline" / "KCS giữ lại" / "Dữ liệu cũ — bấm Tải lại" / "Đã KCS"; ô kết quả "Đạt / Giữ lại / Loại" (nhãn ô "Kết quả KCS") |
| `shopfloor-pwa-display.ts:160` (TA#10) | `formatStatus` trả mã thô khi thiếu nhãn: DRAFT, COMPLETED, CLOSED, FAILED, HOLD, EXPIRED, DEPLETED, GENERATED, VOID, CREATED, INSPECTED, IN_PROCESS, RAW_LOT_QC_SIGNED, REVOKED | "Nháp", "Hoàn thành", "Đã đóng", "Lỗi", "Tạm giữ", "Hết hạn", "Đã hết tồn", "Đã sinh mã", "Đã huỷ", "Mới tạo", "Đã kiểm", "Đang xử lý", "Đã ký KCS", "Đã thu hồi"; mã lạ: "Trạng thái khác" |
| `shopfloor-pwa-display.ts:137-155` (TA#12) | "Đánh dấu lot sẵn sàng", "Ký QC lot nguyên liệu", "Xác nhận đóng gói L1/L2", "Xác minh QR/barcode", "Ghi nhận quét trace", "Ghi nhận bằng chứng recall", "Xác nhận đã thấy sale-lock", "Nhập nguyên liệu quét phiếu (app hiện trường)" | "Duyệt lô sẵn sàng", "Ký KCS lô nguyên liệu", "Xác nhận đóng gói Cấp 1/Cấp 2", "Kiểm tem QR/mã vạch", "Ghi nhận truy xuất tại chỗ", "Gửi bằng chứng thu hồi", "Xác nhận đã thấy khoá bán", "Nhập nguyên liệu theo phiếu"; dòng 140-141 "Check-in"/"Check-out" GIỮ (D-m12-118, không theo "Vào ca/Ra ca" của TA#12) |
| `src/lib/pwa/shopfloor-labels.ts:9-24` | "KCS lô nguyên liệu thô", "QC sau sấy", "QC thành phẩm", "Kiểm QR / mã vạch", "Bằng chứng thu hồi / CAPA"… | theo cột "Tên việc" §1b |
| `shopfloor-task-inbox.tsx:113,121` | "Ngoại tuyến" (Cho phép/Chỉ online) · nhãn "v <mã phiên bản>" | "Offline" (Làm được offline/Chỉ online) · bỏ nhãn phiên bản |
| `shopfloor-task-inbox.tsx:218-221,478,484` (TA#15) | "Đã tải N task…", "N task khớp", "Mở task khớp" | "Đã tải N công việc…", "N công việc khớp", "Mở công việc khớp" |
| `shopfloor-task-inbox.tsx:471` (TA#24) · `shopfloor-scan-client.tsx:181` | mã loại đối tượng thô (RAW_MATERIAL_LOT, BATCH…) | nhãn qua `formatRequiredScanLabel`/`scanObjectLabels` ("lô nguyên liệu", "mẻ sản xuất"…) |
| `shopfloor-task-inbox.tsx:474` | "…Quét chỉ nhận diện đối tượng, không xác nhận nghiệp vụ và không ghi thẳng vào dữ liệu vận hành gốc." | "Đây là các công việc liên quan tới mã bạn vừa quét." |
| `shopfloor-task-inbox.tsx:522` · `shopfloor-task-detail-client.tsx:539` | "Cần thiết lập thiết bị trước khi tải công việc." / "Cần thiết lập thiết bị." | bỏ — màn Ghép máy chặn trước |
| `shopfloor-task-detail-client.tsx:273,410` (TA#22) | "…sang HOLD/RETURN; không được xác nhận đóng gói offline." | "…báo kho tạm giữ hoặc trả NCC; không xác nhận đóng gói offline được." |
| `src/lib/pwa/packaging-defect-policy.ts:25,57,60,87,100` (TA#22) | "Artwork in sẵn…", "…HOLD/RETURN…", "báo Print Exception… Retry/Reprint", "Chưa có policy snapshot", "Chưa có profile snapshot" | "Mẫu in sẵn không đúng bản đã duyệt", "…báo kho tạm giữ hoặc trả NCC…", "báo sự cố in tem; đối soát xong mới in lại", "Chưa có cấu hình áp mã", "Chưa có mẫu tem" |
| `shopfloor-task-detail-client.tsx:415` | "Scan resolve chưa khớp công việc." (hoặc mã chặn thô) | "Mã vừa quét không khớp công việc này. Quét lại đúng mã." |
| `shopfloor-task-detail-client.tsx:562-567` | "Phiên bản" + "Quy tắc xung đột: Dừng đồng bộ và yêu cầu nhân sự rà soát…" | bỏ cả hai |
| `shopfloor-task-detail-client.tsx:585-586,599,602` | "Lệnh thao tác"/"Xác nhận thao tác", "…không đủ điều kiện đưa vào hàng đợi offline.", "Giá trị quét" | bỏ dòng nhỏ/"Làm việc này", "Thao tác này cần online, không lưu offline được.", "Mã vừa quét" |
| `shopfloor-task-detail-queue-panel.tsx:78,86,95,102,116` | "Tham chiếu bằng chứng", "Mã tham chiếu bằng chứng", "Máy ảnh hoặc tệp theo nguồn/phiếu/công đoạn", "Loại bằng chứng", "Công đoạn / dòng phiếu" | ẩn ô tự điền · tiêu đề khối "Ảnh bằng chứng" · nút "Chụp ảnh" / "Chọn tệp" |
| `shopfloor-task-detail-queue-panel.tsx:151` · `shopfloor-offline-queue-client.tsx:348,373` | mã băm / mã tham chiếu tệp (`<code>`), "Mã băm nội dung" | bỏ |
| `shopfloor-task-detail-queue-panel.tsx:192` | "Nhân sự vận hành xác nhận rõ ràng" | "Tôi đã kiểm và xác nhận thông tin trên là đúng" |
| `shopfloor-task-detail-queue-panel.tsx:212-214` | "Đưa vào hàng đợi" / "Còn N điều kiện cần hoàn tất" | "Lưu và gửi" (đợt 3 tự gửi; trước đó "Lưu vào hàng đợi") / "Còn N mục cần làm" |
| `shopfloor-task-detail-scan-gate-panel.tsx:17-19` (TA#25) | "Nguồn quét: Nhập thủ công / Máy quét HID / Camera (tự ghi nhận khi quét)" | bỏ ô; app tự ghi nguồn (CHƯA RÕ §8.9) |
| `shopfloor-task-detail-material-fields.tsx:53,79,83` (TA#19) | "Đủ/Thiếu lot/vị trí", "Thiếu rawMaterialLotId", "Thiếu sourceLocationId" | "Đủ lô và vị trí"/"Thiếu lô hoặc vị trí", "Chưa có lô — báo kho", "Chưa có vị trí lấy hàng — báo kho" |
| `shopfloor-task-detail-material-fields.tsx:300-317` | ô gõ tự do "Trạng thái đích" = "READY_FOR_PRODUCTION", "Mã hành động" = "RAW_LOT_MARK_READY" | ẩn cả hai (giá trị cố định) |
| `shopfloor-task-detail-production-fields.tsx:158,166,174,201` | "Mã ca" (gõ "DAY"), "Mã vai trò", "Mã bộ phận", "Mã xác nhận giám sát" | "Ca", "Vai trò trong ca", "Tổ / bộ phận", "Người giám sát xác nhận" — nên là ô chọn (CHƯA RÕ §8.8) |
| `shopfloor-task-detail-production-fields.tsx:121,139-140` (TA#20) | "…theo work order", "Lần check gần nhất" + mã thô CHECK_IN/CHECK_OUT | "…theo lệnh công việc", "Lần Check-in/Check-out gần nhất" + nhãn "Check-in"/"Check-out" (giữ chữ, D-m12-118) |
| `shopfloor-task-detail-field-quality-fields.tsx:52,68,105,135,326` (TA#16) | "Được capture evidence", "CAPA", "Thời điểm capture", "Lock đang hiệu lực", "chưa PASS" | "Được ghi bằng chứng", "CAPA" (giữ), "Thời điểm chụp", "Khoá bán đang hiệu lực", "chưa Đạt" |
| `field-quality-fields.tsx:123,187,304,412` · `packaging-fields.tsx:142,274,331,400` · `production-fields.tsx:211` (TA#17) | "Chặn QC sau sấy: <mã thô>.", "Chặn xác nhận sale-lock: …", "Chặn check-in/out: …" (9 chỗ in `blockingReasonCode`) | dùng `formatTaskBlockingReason()` như `production-fields.tsx:592`; tiền tố "Chặn KCS sau sấy", "Chặn xác nhận khoá bán", "Chặn Check-in/Check-out"; mã cuối câu |
| `field-quality-fields.tsx:133,152` (TA#18) · `:294,402` (TA#16) | scopeType thô (BATCH, SKU) · "Lý do HOLD/REJECT" | "Mẻ", "SKU" · "Lý do giữ lại hoặc loại" |
| `shopfloor-task-detail-packaging-fields.tsx:135,175,199,267,360` (TA#21) | "Đã có ledger"/"Chờ ledger", "Mode áp mã", "Artwork đã duyệt", "chưa gắn QR" | "Đã ghi sổ kho"/"Chờ ghi sổ kho", "Cách áp mã", "Mẫu in đã duyệt", "Chưa gắn tem QR" |
| `shopfloor-pwa-primitives.tsx:37,54` | "Bản chụp sản xuất", "Loại bản chụp" | "Công thức của mẻ", "Cách tính định lượng" |
| `shopfloor-pwa-primitives.tsx:372` | link "Hàng đợi" trong dải đồng bộ | "Xem lệnh chờ gửi" |
| `shopfloor-pwa-primitives.tsx:435,445,452,463` | "PWA-FLOOR-01", "mã phiên", "Nhãn thiết bị", "Kích hoạt phiên" | "Ví dụ XUONG_01", "Mã ghép", bỏ, "Ghép máy" (§4.3) |
| `shopfloor-pwa-primitives.tsx:479-480,491-494` | "Thiết bị · Cần thiết lập" (15 màn) · "Xác thực · Cần đăng nhập · Đăng nhập trước khi tải dữ liệu công việc xưởng." | bỏ khung · "Phiên đăng nhập đã hết. Đăng nhập lại để làm tiếp." |
| `shopfloor-offline-queue-client.tsx:209-210,246` | "Ngoại tuyến" / "Hàng đợi" / "Phong bì lệnh" | breadcrumb §3 / "Hàng đợi" / "Lệnh trên máy" |
| `shopfloor-offline-queue-client.tsx:237,287` · `shopfloor-task-view-model.ts:253-254` | "Rà soát", "…cần nhân sự vận hành rà soát" | "Cần xem lại", "…cần người xem lại" |
| `shopfloor-offline-queue-client.tsx:275` | "Chỉ tự đồng bộ các mục đã chọn khi mạng kết nối lại" | bỏ khi làm PWA-03 (tự gửi mọi lệnh khi online) |
| `shopfloor-offline-queue-client.tsx:334` (TA#9) | `item.commandType` thô (RAW_LOT_QC_SIGN…) | tên việc qua `formatActionLabel` |
| `shopfloor-offline-queue-client.tsx:130` · `offline-sync-controller.ts:332,774` · `client-error.ts:2` | "Đồng bộ offline gặp lỗi ngoài dự kiến… báo IT vận hành", "liên hệ IT vận hành" | "Gửi lệnh bị lỗi. Thử lại; vẫn lỗi thì báo quản trị." |
| `shopfloor-pwa-dialogs.tsx:84,90,106` | "Xóa toàn bộ dữ liệu cục bộ?", "Lệnh chờ gửi (pending)", "Bằng chứng cục bộ" | "Xóa hết dữ liệu chưa gửi trên máy?", "Lệnh chờ gửi", "Ảnh, tệp chưa gửi" |
| `shopfloor-device-settings-client.tsx:61,70,92` | "…bằng chứng offline. Biên nhận: <mã>", "Thiết lập phiên", "Xóa phiên cục bộ và hàng đợi" | "Đã xóa N lệnh và M ảnh/tệp chưa gửi.", "Ghép máy", "Xóa dữ liệu chưa gửi trên máy" |
| `shopfloor-scan-client.tsx:110-120,131,144-149` | "Quét trước"/"Dữ liệu đầu vào", "Giá trị quét", ô "Kiểu quét" (Thủ công/Mã vạch/QR/Lô) | bỏ, "Mã", bỏ ô (máy chủ chỉ dùng kiểu TRACE: `ResolveMobileOperationalScanHandler.Trace.cs:13`) |
| `shopfloor-scan-client.tsx:62,171,199` | "Nhận diện mã", mã chặn thô khi thiếu câu, "Mở nguồn/công việc" | "Xem mã này", câu chung "Hàng đang bị giữ hoặc khoá" (mã cuối câu), "Mở việc liên quan" |
| `shopfloor-raw-lot-qc-reset-client.tsx:109` · `shopfloor-raw-intake-capture-supplier-create.tsx:90` (TA#26) | lỗi 422 in "quantity: …", "request.displayName: displayName là bắt buộc." | dùng `describeServerField()` như `raw-intake-capture-client.tsx:336` ("Số lượng: …", "Tên NCC: bắt buộc") |
| `src/lib/pwa/shopfloor-command-labels.ts:111` (TA#27) | khoá trường lạ in thô ("lines[0].qty") | "một trường dữ liệu" |
| `public/shopfloor-sw.js:38` (TA#28) | "Shopfloor is offline. Retry this navigation when the network returns." | "Đang offline. Mở lại màn này khi có mạng." |
| `src/lib/pwa/shopfloor-task-view-model.ts:432-435` (TA#23) | nhãn = mã chặn thô; "Target đang có hold/sale-lock/recall/not-sellable blocker. PWA không được queue…" | "Hàng đang bị giữ, khoá bán hoặc thu hồi" / "Không làm tiếp được với hàng này. Báo QA." |
| `shopfloor-task-view-model.ts:441,450-451,457-458` | nhãn = mã lỗi thô; "Phản hồi quét không hợp lệ…"; nhãn scanStatus thô, "Chỉ là kết quả nhận diện. Lệnh nghiệp vụ vẫn cần xác nhận riêng." | "Không nhận ra mã này"; "Không đọc được kết quả quét. Quét lại."; "Đã nhận ra mã" / "Mở việc để làm tiếp." |
| `shopfloor-task-view-model.ts:333-334` | "…chưa đủ điều kiện đưa vào hàng đợi ngoại tuyến", "Cần đánh dấu xác nhận vận hành" | "Thao tác này cần online", "Tick ô xác nhận" |
| `src/lib/api/mobile-client.ts:194-206` · `mobile-bootstrap-client.ts:61-62` · `mobile-auth-client.ts:101-105` (TA#6) | "Lệnh mobile…", "Idempotency key không khớp payload.", "Mobile API…", "…Shopfloor PWA.", "API đăng nhập…" | theo §6 |
| `src/lib/pwa/offline-sync-controller.ts:429,436,639,646,670` (TA#7) | "…lên mobile API", "…lệnh offline đến mobile API" | "Chưa gửi được ảnh/lệnh lên máy chủ. Kiểm tra mạng rồi thử lại." |
| `offline-sync-controller.ts:363,393,707` (TA#7) · `src/lib/offline-queue/index.ts:408,711` (TA#8) | "Thiếu file bằng chứng local <mã>.", "Batch đồng bộ có xung đột…", "…cho lệnh mobile này", "Mobile API không trả kết quả…" | "Thiếu ảnh/tệp bằng chứng trên máy — chụp lại.", "Lượt gửi có lệnh xung đột; mở Hàng đợi xem mục Cần xem lại.", "…cho lệnh này", "Máy chủ chưa trả kết quả; lệnh đã về Hàng đợi để gửi lại." |
| `raw-intake-field-capture-queue.ts:138,145` · `offline-queue/storage.ts:121` · `offline-evidence/index.ts:399,504` | "Hàng đợi offline", "kho bằng chứng offline… tab khác" | "Hàng đợi", "…đóng bớt tab app xưởng rồi thử lại" |
| `src/lib/crypto/random-uuid.ts:47` · `offline-queue/sync-result-policy.ts:41` | "Không thể sinh UUID cho phiên/lệnh offline.", "Trạng thái sync chưa được ánh xạ" | "Máy không tạo được mã lệnh. Tải lại app rồi thử lại." · "Gửi lệnh gặp lỗi lạ. Báo quản trị." |
| `app/layout.tsx:12-20` · `app/manifest.ts:5-7` (TA#14) | "Xưởng vận hành Ginsengfood", "PWA quét trước cho công việc vận hành tại xưởng." | "Ginsengfood Xưởng", "Ứng dụng vận hành tại xưởng" |
| `app/pwa/**/page.tsx` metadata (TA#13, #29) · `public/icon.svg:1` aria-label "Ginsengfood Shopfloor" (TA#29) | "Workbench Shopfloor PWA cho…", "Check-in/out nhân sự", "Xác nhận sale-lock", "Đóng gói L1/L2", "Hàng đợi offline" | tiêu đề + mô tả §3 ("Hàng đợi offline" giữ được vì GIỮ offline) · icon: "Ginsengfood Xưởng" |

## 6. Mã lỗi API → câu cho `mapErrorCode` (`src/lib/api/mobile-client.ts:239-256`)

Hiện `mapErrorCode` chỉ biết 12 mã, mọi mã khác (STATE_CONFLICT, RATE_LIMITED, NOT_FOUND…) thành UNKNOWN_ERROR và hiện "UNKNOWN_ERROR: Không thể hoàn tất yêu cầu.".
Sửa: thêm các mã dưới; không có mã thì suy theo HTTP (401→UNAUTHORIZED, 403→FORBIDDEN, 404→NOT_FOUND, 409→CONFLICT, 429→RATE_LIMITED, 5xx→INTERNAL_ERROR).
Hiển thị = câu + " (mã: <MÃ>)"; màn lỗi và lỗi lạ thêm "Mã tham chiếu: <correlationId>". Câu sync đã có ở `src/lib/security/client-error.ts` giữ, rút gọn theo bảng.

| Mã | HTTP | Câu mới |
|---|---|---|
| UNAUTHORIZED | 401 | Phiên đăng nhập đã hết. Đăng nhập lại để làm tiếp — lệnh chưa gửi vẫn còn trên máy. |
| (tài khoản phải đổi mật khẩu) | 401 mobile | Tài khoản phải đổi mật khẩu trước khi dùng. Đổi mật khẩu rồi đăng nhập lại. |
| FORBIDDEN | 403 | Tài khoản của bạn không có quyền làm việc này. Nhờ quản trị kiểm tra vai. |
| MOBILE_DEVICE_SESSION_REQUIRED | 403 | Máy chưa được ghép. Vào Ghép máy và quét mã quản trị đưa. |
| MOBILE_DEVICE_SESSION_INVALID | 403 | Mã ghép máy không dùng được nữa. Nhờ quản trị cấp mã mới rồi quét lại; lệnh chưa gửi vẫn còn trên máy. (→ mở Ghép máy) |
| RATE_LIMITED | 429 | Thao tác quá nhanh. Đợi khoảng một phút rồi thử lại. |
| VALIDATION_FAILED / VALIDATION_ERROR | 400/422 | Thông tin chưa đúng. Xem ô báo đỏ, sửa rồi gửi lại. (ô lỗi dùng `formatPayloadField`) |
| REASON_REQUIRED | 422 | Cần ghi lý do. Nhập lý do rồi gửi lại. |
| NOT_FOUND / MOBILE_TASK_NOT_FOUND | 404 | Không còn công việc này (đã xong hoặc bị huỷ). Quay lại danh sách và bấm Tải lại. |
| MOBILE_TASK_CONTEXT_INCOMPLETE | 409/422 | Công việc chưa đủ điều kiện hoặc thiếu thông tin. Xem các mục bên dưới, tải lại sau khi cập nhật hoặc nhờ tổ trưởng kiểm tra. |
| STATE_CONFLICT | 409 | Công việc đã đổi trạng thái (vd người khác vừa làm). Tải lại, xem trạng thái rồi làm lại nếu vẫn cần. |
| MOBILE_STALE_TASK_STATE / CONCURRENCY_CONFLICT / 409 không mã | 409 | Công việc vừa thay đổi từ lúc bạn mở. Tải lại rồi làm lại. |
| MOBILE_SYNC_CONFLICT | 409 | Lệnh trùng hoặc vướng dữ liệu trên máy chủ. Báo tổ trưởng xem trước khi gửi lại. |
| MOBILE_OFFLINE_PAYLOAD_MISMATCH | 409 | Nội dung lệnh khác lần gửi trước. Không gửi lại; báo tổ trưởng xem. |
| IDEMPOTENCY_CONFLICT | 409 | Lệnh này đã gửi trước đó với nội dung khác. Mở Hàng đợi xem lệnh cũ trước khi gửi lại. |
| MOBILE_COMMAND_UNSUPPORTED | 400/422 | App chưa làm được thao tác này. Làm trên máy quản trị hoặc báo quản trị. |
| MOBILE_SCAN_NOT_CONFIRM | 422 | Quét chỉ để nhận ra mã. Mở công việc và bấm xác nhận để ghi nhận. |
| HOLD_ACTIVE / QUALITY_HOLD / SALE_LOCK_ACTIVE / RECALL_IMPACT_ACTIVE / INVENTORY_NOT_SELLABLE | 409/422 | Hàng đang bị giữ, khoá bán hoặc thu hồi nên không làm tiếp được. Báo QA. |
| QC_NOT_PASS / RAW_MATERIAL_LOT_QC_NOT_PASSED / RAW_MATERIAL_LOT_NOT_READY / LOT_NOT_READY_FOR_PRODUCTION / LOT_QUARANTINED | 409/422 | Lô chưa KCS đạt hoặc chưa sẵn sàng. Báo KCS/QA. |
| INSUFFICIENT_BALANCE / LOT_QUANTITY_EXCEEDS_RECEIVED | 409/422 | Số lượng vượt tồn hoặc vượt số đã nhận. Kiểm lại số lượng. |
| PROCESS_EVENT_OUT_OF_ORDER / PROCESS_STEP_ORDER_INVALID | 409/422 | Sai thứ tự công đoạn. Hoàn tất công đoạn trước rồi làm lại. |
| FORM_CHECKPOINT_REQUIRED / FORM_EVIDENCE_REQUIRED / EVIDENCE_NOT_ACCEPTED / COMPLETION_PREREQUISITE_NOT_MET | 409/422 | Công đoạn trước chưa được KCS xác nhận trên máy quản trị. Chờ hoàn tất, tải lại công việc rồi làm lại. |
| EVIDENCE_REQUIRED | 422 | Cần chụp ảnh hoặc chọn tệp bằng chứng trước khi gửi. |
| EVIDENCE_MIME_NOT_ALLOWED / EVIDENCE_FILE_TOO_LARGE | 415/413/422 | Chỉ nhận ảnh JPG/PNG/WebP, video MP4/MOV hoặc PDF, tối đa 25 MB. Chụp lại hoặc chọn tệp khác. |
| EVIDENCE_STORAGE_UNAVAILABLE | 503 | Máy chủ chưa nhận được ảnh. Lệnh vẫn ở Hàng đợi; thử gửi lại sau. |
| QR_INVALID / QR_NOT_FOUND / QR_INVALID_STATE / PACKAGING_UNIT_INVALID | 404/409/422 | Tem QR không đúng hoặc không ở trạng thái dùng được. Quét lại đúng tem; vẫn lỗi báo tổ trưởng. |
| MOBILE_SYNC_SESSION_CHANGED / MOBILE_EVIDENCE_COMMAND_MISMATCH · MOBILE_SYNC_RESULT_MISSING / MOBILE_SYNC_LEASE_EXPIRED (mã phía app, `client-error.ts`) | — | Cặp đầu: "Lệnh gửi bằng mã ghép cũ hoặc ảnh gắn nhầm lệnh. Báo quản lý đối soát; dữ liệu vẫn giữ trên máy." · cặp sau: "Chưa nhận được kết quả lần gửi trước. Lệnh vẫn giữ để gửi lại an toàn." |
| REQUEST_TIMEOUT / NETWORK_ERROR (mã phía app) | — | Mất kết nối hoặc máy chủ trả lời chậm. Lệnh vẫn lưu trên máy; online lại sẽ gửi. |
| INTERNAL_ERROR / 5xx | 500 | Hệ thống đang gặp sự cố. Thử lại sau ít phút; vẫn lỗi thì báo quản trị kèm mã tham chiếu. |
| UNKNOWN_ERROR (mã lạ) | — | Không làm được thao tác này. Tải lại; vẫn lỗi thì báo quản trị kèm mã tham chiếu. |

## 7. Danh mục icon dùng chung (lucide-react, PWA đang dùng 1.16.0) — một nghĩa một icon; bỏ bộ icon tự vẽ `shopfloor-icon.tsx`

| Nghĩa | Icon | Nghĩa | Icon | Nghĩa | Icon | Nghĩa | Icon |
|---|---|---|---|---|---|---|---|
| Mở menu | Menu | Quay lại | ArrowLeft | Tách breadcrumb | ChevronRight | Việc / danh sách việc | ClipboardList |
| Quét (mọi kiểu quét) | ScanLine | Hàng đợi / lệnh chờ gửi | CloudUpload | Tài khoản / avatar rỗng | CircleUser | Ghép máy | TabletSmartphone |
| Đăng xuất | LogOut | Đổi mật khẩu | KeyRound | Nhập theo phiếu | FileInput | Lô nguyên liệu | Sprout |
| Lô cũ chờ kiểm | ArchiveRestore | Lô sẵn sàng | BadgeCheck | Vào/ra ca | Clock | Ghi sản xuất | Factory |
| Phiếu kiểm KCS | Microscope | Đóng gói | Package | Kiểm tem QR | QrCode | Nhập thành phẩm | Warehouse |
| Truy xuất | Network | Bằng chứng thu hồi | FileWarning | Khoá bán | Lock | Cách làm (gập/mở) | ListOrdered + ChevronDown/Up |
| Tải lại | RefreshCw | Lưu và gửi / Gửi tất cả | SendHorizontal | Chụp ảnh / cần ảnh | Camera | Chọn tệp | Paperclip |
| Gỡ / xóa | Trash2 | Làm phiếu mới | RotateCcw | Thêm (NCC mới) | Plus | Tìm | Search |
| Sao chép mã | Copy | Mở việc liên quan | ExternalLink | Đóng hộp | X | Hạn xử lý | CalendarClock |
| Thành công | CircleCheck | Cảnh báo | TriangleAlert | Lỗi | CircleX | Thông tin | Info |
| Offline | WifiOff | Đang tải | LoaderCircle | Trạng thái rỗng | Inbox | Lý do / ghi chú | MessageSquareText |
| Hiện/ẩn mã | Eye / EyeOff |  |  |  |  |  |  |

Icon nhóm trong ngăn kéo: không dùng (nhóm chỉ có chữ) để không trùng icon mục. Cỡ: 20px trong menu/thanh đáy, 16px trong nút.

## 8. CHƯA RÕ — cần chủ hệ thống chốt

1. **Danh sách việc không lọc theo vai/người được giao** (`ListMobileOperationalTasksHandler.cs`; HDSD 38.1): app tự lọc theo §1b thì trang 25 việc bị thưa — máy chủ nhận nhiều `taskType` hoặc tự lọc? Chưa chốt ⇒ ô "Việc" không có số.
2. **Lý do mã ghép hỏng:** máy chủ trả chung 403 `MOBILE_DEVICE_SESSION_INVALID` (`EfMobileOfflineQueuePort.cs:24-33`); D-m12-116 "không API mới" — được thêm `details.reason` vào lỗi sẵn có không? Không ⇒ "thu hồi"/"mã sai" chỉ báo câu chung.
3. **Khuôn QR ghép máy** (đợt 2): đề xuất tiền tố `GFDEV1:` + JSON (mã thiết bị, mã ghép, tên máy, tên đăng nhập, hạn) để app tự báo "người khác"/"hết hạn".
4. R-QA-REL có thấy **Kiểm tem QR** không: seed cho `QR_VIEW`, catalog F05-F03 chỉ ghi R-PACK-OP.
5. R-WH-FG có dùng **Lô cũ chờ kiểm** không: có `INVENTORY_ADJUSTMENT_CREATE` nhưng màn chỉ cho lô nguyên liệu (đề xuất ẩn).
6. R-ACC-INT, R-PLAN (không có `MOBILE_SCAN_RESOLVE`, không có quyền loại việc nào): ô "Việc" và "Quét" mở "Nhập theo phiếu" (đề xuất) hay ẩn ô Quét.
7. Tên vai "QC nguyên liệu", "QC sản xuất/thành phẩm" (admin `role-identity.ts`) đổi "KCS …" theo D-m12-118 cho cả admin hay chỉ app xưởng.
8. Check-in/Check-out: ô "Ca", "Vai trò trong ca", "Tổ / bộ phận", "Người giám sát xác nhận" lấy danh mục ở đâu (ca có seed `05d`; vai trò/bộ phận chưa thấy).
9. "Nguồn quét" (gõ tay / máy quét cầm tay / camera) có cần lưu phân biệt cho kiểm toán không; đề xuất app tự ghi, bỏ ô chọn.
10. Ngưỡng nhắc "mã ghép sắp hết hạn" (đề xuất 3 ngày; quản trị cấp 1–180 ngày).
11. Nút "Lưu và gửi" phụ thuộc PWA-03 (tự gửi khi online, đợt 3); chưa có tự gửi thì giữ "Lưu vào hàng đợi".
12. Chữ lối đăng nhập bằng mail OTP (WP26) — lấy y chữ admin khi WP26 làm xong.
