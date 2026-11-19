# Rà soát bố cục + đồng bộ giao diện — admin-web và app xưởng (18/11)

Phiên m12 [f1e7c3] · Toàn yêu cầu 18/11 21:0x (3 ảnh: badge "Không đối chiếu được" giãn ô, badge "Sẵn sàng" tràn khung, nút "Chạy kiểm tra"
lạc hàng + badge "Chưa có kết quả" giãn). Kế hoạch sửa: `wp/M12-WP28-ui-bo-cuc-dong-bo.md`. Bằng chứng (ảnh, số đo, ghi chép từng ô) ở thư mục
`ra-soat/2026-11-18-ui-bo-cuc/` (đã loại khỏi git): `gom-admin.md`, `gom-pwa.md`, `xem-anh-A.md`, `xem-anh-B.md`, `xem-anh-P.md`, `hop-theo-man.md`.

## 0. Tóm tắt

- Rà **95/95 màn admin** (69 danh sách + 26 chi tiết; 3 màn chỉ là đường dẫn cũ chuyển hướng), 3 màn công khai, **18/18 màn app xưởng**, kèm
  tab, 2–3 hộp thoại "Tạo/Thêm" mỗi màn và 44 hộp thoại mở từ nút trong dòng bảng; mỗi màn 2 khổ (admin 1366 + 1920, app xưởng 390 + 1024).
- Hai cách rà chồng nhau: **máy đo DOM** (16 loại lỗi đo được, ~1.100 mục sau khử trùng) và **3 agent xem ảnh độc lập** (273 + 51 ảnh bù):
  **976 mục — Cao 84 · Vừa 453 · Thấp 439**; không màn nào sạch.
- Lỗi nằm phần lớn ở **component dùng chung** chứ không ở từng màn: 3 ví dụ của Toàn chung gốc với hàng trăm chỗ khác. Sửa 16 gốc ở
  `packages/ui` + `components/{ui,form,layout}` (đợt 0 WP28) là hết phần lớn; phần còn lại theo danh sách từng màn (§6).
- Tab trang chi tiết đã kiểm lại 19/11 01:4x sau khi Docker chạy lại: chuyển bình thường (§7). Chưa kiểm: từng vai riêng ở app xưởng,
  khổ 1280 admin, khổ 768 app xưởng (§7).

## 1. Phạm vi và cách rà

| Mục | Giá trị |
|---|---|
| Mã | giao diện `main` cục bộ `8b1d4cbde` (đã gồm WP24 r4, WP25); API lab `565272e01` (= bản đang chạy trên .99); DB lab `uat2710_lab` |
| Tài khoản | admin: Quản trị (toàn quyền); app xưởng: công nhân sản xuất (5/18 màn được dùng) + quản trị đã ghép máy (18/18) |
| An toàn | trình duyệt chặn MỌI yêu cầu ghi (POST/PUT/PATCH/DELETE) trừ đăng nhập ⇒ mở hộp thoại, bấm nút trong dòng không đổi dữ liệu; thêm 1 phiên thiết bị lab cho tài khoản quản trị để mở app xưởng |
| Máy đo DOM | tràn viền, lấn lề, badge giãn, chữ tràn ô / bị cắt, chồng lấn, nút lệch hàng / lệch vị trí, ô cao lệch, tiêu đề cột và ô bảng chật, cuộn lồng, chữ < 12px, nút không nhãn, vùng chạm < 40px (điện thoại), ô bắt buộc bị khoá, chữ Anh, mã kỹ thuật lộ trong câu; + đo đồng bộ: chiều cao nút/ô, cỡ chữ, lề thẻ, bo góc, tiêu đề trang, breadcrumb, mô tả |
| Xem ảnh | 3 agent (nhóm A sản xuất/kho/nguyên liệu/in/biểu mẫu; nhóm B SKU/công thức/dữ liệu chính/xuất xứ/truy vết/thu hồi/phát hành/hệ thống/MISA/đăng nhập; app xưởng), mỗi mục có mã loại L1–L15 + mức |
| Đo thêm | bảng rộng hơn khung: **17 màn ở 1366px** (+13 → +770px), 2 màn ở 1920px |

Mã loại: L1 tràn/vượt viền · L2 lệch hàng/canh lề · L3 giãn sai · L4 bảng chật/cột vỡ chữ · L5 khoảng trắng/nhịp · L6 nút thao tác ·
L7 bộ lọc · L8 khung trang · L9 trạng thái trống/tải/lỗi · L10 chữ · L11 mã kỹ thuật/tiếng Anh · L12 khung lồng · L13 ô nhập như bị khoá ·
L14 nội dung khó hiểu · L15 khác (vùng chạm, hộp thoại…).

## 2. Kết quả tổng

| Mã | Xem ảnh Cao | Vừa | Thấp | Máy đo (mục) | Ghi chú |
|---|---|---|---|---|---|
| L1 tràn | 29 | 22 | 11 | ~165 | mã dài `ING_…`/`BATCH-…` đè cột bên; bảng rộng hơn khung 17 màn |
| L2 lệch | 1 | 23 | 23 | 12 | tiêu đề cột canh giữa, nội dung canh trái; nút lạc hàng |
| L3 giãn | 3 | 16 | 4 | 21 | badge giãn hết ô (2/3 ví dụ của Toàn) |
| L4 bảng chật | 14 | 27 | 18 | ~520 ô | cột chính 55–120px, chữ gãy 3–11 dòng, dòng cao 100–280px |
| L5 khoảng trắng | 3 | 14 | 37 | 1 | bố cục 2 cột lệch chiều cao, chỗ trống chết |
| L6 nút thao tác | 3 | 64 | 50 | — | nút nguy hiểm 5 màu; nút biểu tượng mỗi màn một màu |
| L7 bộ lọc | 1 | 21 | 20 | — | ô lẻ hàng, Tải lại/Xóa lọc xa bộ lọc |
| L8 khung trang | 0 | 18 | 31 | — | mô tả bị bóp, breadcrumb ≠ menu, màn tắt mất tiêu đề |
| L9 trạng thái | 0 | 16 | 19 | 6 | 4 kiểu trạng thái trống, "Chưa có…" dạng badge |
| L10 chữ | 2 | 10 | 51 | ~100 | chữ 10–11px, ngày giờ 3 kiểu |
| L11 mã/tiếng Anh | 21 | 73 | 39 | 35 | ⇒ chuyển WP27 (Việt hoá) |
| L12 khung lồng | 0 | 5 | 18 | — | bảng có viền trong thẻ có viền |
| L13 ô như khoá | 3 | 62 | 16 | 6 | ô sửa được nền xám đậm hơn ô chỉ đọc |
| L14 khó hiểu | 4 | 57 | 73 | — | ⇒ phần chữ chuyển WP27; phần bố cục ở WP28 |
| L15 khác | 0 | 25 | 29 | ~25 | hộp thoại thiếu "×", "×" nhận focus; vùng chạm nhỏ |
| **Cộng** | **84** | **453** | **439** | | app xưởng: 3 Cao · 79 Vừa · 57 Thấp (đã gồm) |

## 3. Ba ví dụ của Toàn — gốc

| Ví dụ | Màn | Gốc trong mã | Cùng gốc ở đâu nữa |
|---|---|---|---|
| Badge "Không đối chiếu được"/"Chưa khai hạn mức" giãn hết ô (đo: 221px ở 1366, 351px ở 1920, chữ chỉ 125–140px) | Vùng xuất xứ › Đối soát sản lượng | `packages/ui/src/Badge.tsx` chỉ `inline-flex`, KHÔNG `width: fit-content`/`flex-shrink: 0`; đặt trong ô `flex-direction: column` ⇒ bị kéo giãn | 21 chỗ đo được + 20 mục xem ảnh: Phiếu xuất NL, tài khoản "Thu hồi phiên này", ngăn kéo phát hành, MRP, app xưởng (Quét mã, Truy vết, chi tiết việc 4 badge) |
| Badge "Sẵn sàng" bị bóp, chữ tràn khỏi viền badge 3–11px, chạm viền thẻ | SKU / Điều kiện bán › Chuỗi sẵn sàng kích hoạt | cùng `Badge` (thiếu `flex-shrink: 0`) + `ReadinessPill` (`SellablePage.helpers.tsx:38`) đặt nhãn `<span>` không `flex:1; min-width:0` | mọi hàng "nhãn + badge" trong lưới thẻ |
| Nút "Chạy kiểm tra" lạc hàng (lệch 126px so với lề trái, 523px lề phải ở 1920), badge "Chưa có kết quả" giãn 500–772px | SKU / Điều kiện bán › Kiểm tra khả dụng | nút đặt làm một ô của `FieldGrid` (`SellablePage.dialog-components.tsx:370–405`) nên nhảy theo số cột lưới; "Chưa có kết quả" là trạng thái trống mà vẽ bằng badge | 9 nút lệch vị trí + 3 nút lệch hàng đo được (truy vết, xem trước công khai…); 6 trạng thái trống dạng badge |

## 4. Gốc chung (sửa một chỗ, hết nhiều màn) → đợt 0 WP28

| Gốc | Bằng chứng | Ảnh hưởng | Việc WP28 |
|---|---|---|---|
| G1 Badge không co theo chữ | `Badge.tsx` | L3 + chữ tràn badge | C1 |
| G2 Không có thang chiều cao điều khiển | `Button.tsx` chỉ padding; đo 7 chiều cao nút (21–51px) trên một màn; app xưởng nút 48px ở 390 nhưng 38px ở 1024 | nút lệch ô nhập, vùng chạm nhỏ | C2 |
| G3 Màu nền ô nhập ngược | token `--surface-inset` (94%) cho ô SỬA ĐƯỢC, ô chỉ đọc `--surface-overlay` (96%, nhạt hơn); ô chọn lại nền trắng | ~80 mục "ô nào cũng như bị khoá", mọi form/bộ lọc, cả app xưởng | C3 |
| G4 `DataTable` không có cỡ cột/kiểu cột | `DataTable.tsx:356` tiêu đề `textAlign: center`; không `minWidth`/kiểu `code`/`date`/`number`; cột thao tác không ghim | ~520 ô chật, mã tràn đè cột, 17 màn phải cuộn ngang mới thấy cột cuối ở 1366, ngày giờ gãy | C4 |
| G5 Thao tác dòng tự ráp | `IconButton` màu riêng từng màn | nút biểu tượng 6+ màu, thiếu nhãn | C5 |
| G6 Không có nút nguy hiểm thống nhất | `ConfirmDialog.tsx:36` loại "warning" ⇒ nút chính xanh lá | Ngừng/Từ chối/Tạm ngưng màu xanh lá; nút nguy hiểm 5 màu | C6 |
| G7 Bộ lọc tự ráp | không có `FilterBar` | ô lẻ hàng ("Đến ngày" một mình), Tải lại/Xóa lọc ở đầu trang xa bộ lọc | C7 |
| G8 Nút form tự đặt | nút làm ô của `FieldGrid` | nút lạc hàng | C8 |
| G9 `PageHeader` bóp mô tả; breadcrumb ≠ menu; trang xác thực mỗi trang một kiểu | ảnh 4 màn mô tả bóp ½ | khung trang lệch | C9 |
| G10 Hộp thoại tự ráp | cỡ 440/560/640/720 lẫn lộn | thiếu "×", "×" nhận focus, nút chốt khác động từ | C10 |
| G11 Trạng thái trống/lỗi không chuẩn | 4 kiểu trống; 5 màn bị tắt chỉ còn hộp lỗi đỏ, mất tiêu đề | L9 | C11 |
| G12 Tab/thẻ số/phân trang nhiều kiểu | 4 kiểu tab, 4 kiểu thẻ số, phân trang thiếu phần | lệch đồng bộ | C12 |
| G13 Bảng có viền trong thẻ có viền | | khung lồng | C13 |
| G14 Thanh bên cắt tên | "Tồn tối thiểu/tối đ…" | | C14 |
| G15 Chính–chi tiết chia đôi 50/50 | `SellablePage` | bảng SKU bị ép, cột "Nhóm" mỗi chữ một dòng | C15 |
| G16 Không có cổng chặn tái phát | 42 `<table>`, 56 `<input>`, 18 `<select>`, 22 `<button>` tự viết trong `features/**` | lỗi mới sinh lại | C16 |

## 5. Lệch đồng bộ giữa các màn (cùng một khối, mỗi màn một kiểu)

| Khối | Đang có | Chuẩn đề xuất |
|---|---|---|
| Khung trang | breadcrumb + tiêu đề + mô tả + nút phải (đa số) · mô tả bóp ½ · không mô tả · "Trở về" hàng riêng + 7 nút gãy 2 hàng · chỉ hộp lỗi (màn tắt) | `PageHeader` một khuôn; nút đầu trang `[Trở về] … [phụ] [chính]`, một nút chính/màn |
| Nút tạo mới | "+ Tạo SKU" có icon · "+ Thêm" gõ dấu + · không icon · "Tạo service account" (Anh); mở hộp thoại / ngăn kéo / trang riêng | "+ Tạo <đối tượng>"; form ngắn = hộp thoại, form dài = ngăn kéo; nút chốt cùng động từ |
| Bộ lọc | thẻ có nhãn 2–3 ô · 4 ô kín hàng · 5–6 ô gãy hàng · thẻ riêng có tiêu đề (MISA) · không có · đặt giữa trang | `FilterBar` một hàng/nhiều hàng đều, nút lọc trong thanh |
| Bảng | tiêu đề cột canh giữa/trái; cột thao tác có/không tiêu đề; rỗng "—"/"-"/"Không có"; ngày giờ 1/2 dòng; chữ tràn/ellipsis | `DataTable` + `meta.kind` (§4 G4) |
| Thao tác dòng | nút chữ (ít) / biểu tượng nhiều màu / menu | 1 nút chữ + menu "…", màu trung tính |
| Phân trang | đủ 3 phần · thiếu ô dòng/trang · không có (bảng 120 dòng) · có cả khi rỗng | `Pagination` một kiểu, ẩn khi rỗng |
| Thẻ số | 4 kiểu (dashboard, cảnh báo, toàn vẹn nhật ký, điều kiện bán) | `StatCard` một kiểu |
| Tab | gạch chân có/không số đếm · nút viên · thẻ to | `Tabs` gạch chân + số đếm |
| Hộp thoại | 4 cỡ, có/không "×", mô tả 3 chỗ, focus 3 chỗ, nút nguy hiểm 5 màu | `Dialog` 3 cỡ chuẩn (§4 G10) |
| Trạng thái trống/lỗi | biểu tượng + tiêu đề + mô tả (tốt) · chữ xám trơn · hộp đỏ toàn trang · badge "Chưa có…" | `EmptyState`/`ErrorState`/`UnavailableState` |
| Chính–chi tiết | 2 cột · xếp dọc · ngăn kéo phải | bấm dòng → ngăn kéo phải, tô dòng |
| Trang xác thực | 3 kiểu (tiêu đề đen/xanh, có/không khung trên) | `AuthLayout` |
| App xưởng ↔ admin | "Tải lại" 2 kiểu, tab gạch chân vs chip, nhãn chữ HOA vs thường, nút màn Tài khoản khác, "Xóa"/"Khoá" 2 kiểu bỏ dấu | dùng chung component; khác chỉ ở cỡ chạm |

App xưởng riêng (3 Cao): Khoá bán chỉ ghi "BATCH/QR/SKU" không rõ khoá hàng nào · "Việc của tôi" (quản trị) 19 chip lọc 11 dòng, việc đầu tiên ở y≈970 ·
ô "Số lượng nhận" nền xám như mọi ô. Vừa nổi bật: thẻ việc cao ~237px (danh sách 7.000px), tên màn lệch giữa thanh trên/menu/breadcrumb/tiêu đề
(8 màn), breadcrumb ăn ~110px đầu màn điện thoại, "Tải lại" gãy 2 dòng, "Thêm chi tiết" trông như ô nhập, việc quá hạn không nổi bật,
nút 38px ở khổ 1024, thanh bên không dính.

## 6. Danh sách theo màn

Bảng đầy đủ (114 dòng màn/khổ, sắp theo độ nặng; cột "Đo được" = số mục máy đo theo mã loại; cột "Xem ảnh" = Cao/Vừa/Thấp; cột cuối = lỗi Cao
tiêu biểu) — chép từ `hop-theo-man.md`, đã che tên người:

| App | Màn | Đo được (theo mã) | Xem ảnh Cao/Vừa/Thấp | Lỗi Cao tiêu biểu |
|---|---|---|---|---|
| admin | /admin/demand-mrp-stock-alert | L1:15 L11:6 L3:8 L4:31 L9:2 | 5/15/12 | Bảng thứ hai "Bảng nhu cầu", cột "Ghi chú người lập kế hoạch": hiện chuỗi máy "Phiếu bảng nhu cầu sản xuất 7ab · Bảng "Bảng nhu cầu nguyên liệu", cột "Trạng thái dòng": badge chữ HOA tiếng Anh "CALCULATED", "SUPPRESSED_COMP · Cột "Nhóm" chỉ rộng ~70px nhưng chứa badge "A1" + mô tả "A1 - Nguyên liệu chính theo SKU" → mô tả gãy mỗi chữ  |
| admin | /admin/master-data/reason-config | L10:2 L2:2 L4:13 | 5/11/8 | Bảng "Lý do" rộng hơn khung, phải cuộn ngang mới thấy hết cột "Phê duyệt" và cột Thao tác (Sửa, Ngừng) — cột T · Cột "Tên lý do" (thông tin chính) chỉ ~70px, tên tiếng Việt gãy 3–6 dòng ("Hủy — / quyết / định của / chủ sở / · Bảng toàn mã: INV_ADJ_COUNT_CORRECTION, INVENTORY_ADJUSTMENT, M11/M02/M07, INVENTORY_ADJUSTMENT_CREATE… → cột  |
| admin | /admin/production/orders/[id] | L10:2 | 5/11/19 | Thao tác chia 2 cụm khác nhau: cụm trên canh trái 6 nút (Trở về, Xem chứng từ lệnh sản xuất, Xem chứng từ kiểm · Hộp cảnh báo "Hồ sơ thiếu: PERSONNEL_ATTENDANCE" + 12 chip mã enum (EQUIPMENT_READINESS_CHECK, MATERIAL_ISSUE_ · Mã nguyên liệu dài tràn đè sang cột "Số lượng đã chụp": "ING_CU_CAI_TRANG_THAI_KHUC" đè "49,2 kg", "ING_NUOC_D |
| admin | /admin/integrations/misa/mapping | L1:2 L5:1 | 4/14/7 | Khối "Ranh giới chế độ MISA", thẻ thứ 4: mã "MISA_PRODUCTION_CONFIG_INCOMPLETE" (chữ đơn cách) dài hơn thẻ, tr · Mã kỹ thuật dày đặc: chip "MisaSyncOptions.Mode", "MATERIAL_ISSUE_ACCOUNTING", 4 mã ACCOUNTING_CHECKPOINT_MISS · Bảng: cột "Ánh xạ" hiện mã băm cắt "7a212a01…972d" + "ACCOUNTINGHANDOFF / ebae2d70…f47e"; cột "Đối tượng MISA" |
| admin | /admin/sellable | L1:1 L11:6 L2:1 L3:1 L4:3 L9:1 | 5/6/6 | Thẻ "Kiểm tra khả dụng / điều kiện bán" (cuối cột phải): badge kết quả "Chưa có kết quả" kéo hết bề ngang thẻ  · Cùng thẻ: nút "Chạy kiểm tra" nhỏ, mờ, nằm lạc ở cột phải hàng thứ 2 cạnh ô "Đơn vị tính" (vì dòng gợi ý "Để t · Khối "Chuỗi sẵn sàng kích hoạt": lưới 2 cột, chữ dài ("Công thức chế biến G1 đã duyệt", "Nguyên liệu đúng chuẩ |
| admin | /admin/system/audit-integrity | L1:27 L11:4 | 4/8/3 | Hộp thông tin đầu trang toàn mã: "P14_AUDIT_INTEGRITY_METADATA_ONLY…, P14_OUTBOX_FAILURE_LINK_ONLY…, STRICT_AP · Bảng "Trạng thái chuỗi": cột "Bảng chuẩn" cắt mất chữ không có "…" ("op_batch_genealo", "op_form_action_l") và · Cột "Bảng": chữ "audit_log" tràn đè sang cột "Phân vùng" ("audit_logdefault") → nới cột/ellipsis; khi đã chọn  |
| pwa | /pwa/tasks/[taskId] | L3:7 | 1/16/7 | Khối "Dòng nhận 1": ô "Số lượng nhận" (giá trị "2,5"), "Mã lý do chênh lệch", "Lý do chênh lệch" đều nền xám đ |
| pwa | /pwa/tasks | — | 1/12/3 | 19 chip lọc loại việc xuống 11 dòng, cao ~610px; thẻ việc đầu tiên bắt đầu ở y≈970, tức mở màn chính chỉ thấy  |
| admin | /admin/raw-warehouse/stock/[ingredientId] | L10:2 L11:1 | 2/8/5 | Chữ tràn đè cột bên: "SRC_ZONE_SMOKE_001" (cột "HSD / nguồn") đè lên chữ cột "Bút toán gần nhất" ("…1,8 kg / 1 · Cột "Kho / vị trí" và "Số lượng" chỉ ~90px: kho gãy 4 dòng, "Đã giữ 0 kg / Tạm giữ 0 kg" 4 dòng; cột "HSD / ng |
| admin | /admin/qc-release/batches | L4:18 | 2/7/12 | Bảng rộng hơn khung, phải cuộn ngang mới thấy hết cột "Điều kiện chặn" (badge "Lô chưa có kết qu…", "Mẻ chạy t · Cột "Lô sản xuất" hẹp, mã lô "BATCH-17112026-000006" gãy 3 dòng làm mỗi hàng cao ~75px → cột mã `nowrap` + min |
| admin | /admin/inventory/allocations | L4:6 | 3/4/4 | Bảng rộng hơn khung, phải cuộn ngang mới thấy cột "Thời điểm…" ("Thời đ", "11:", "05/11/" bị che) và các cột s · Mã "ALLOC-05112026-000005" gãy 3 dòng; cột "Mặt hàng / lô" dồn tên SKU + "BOX" + mã PKG + mã lô thành 6 dòng;  · Ngăn "Chi tiết giữ hàng": "Trạng thái tồn: AVAILABLE" (enum tiếng Anh), mô tả "…và projection tồn liên quan",  |
| admin | /admin/system/users-roles | L1:2 | 2/7/14 | Bảng rộng hơn khung, phải cuộn ngang mới thấy hết cột thao tác (nút thứ 2 viền hồng chỉ lộ nửa, các nút sau kh · Tab "Vai trò ký phiếu": cột "Áp dụng cho phiếu" là danh sách mã phiếu thô PRODUCTION_DEMAND_PLAN, MATERIAL_INT |
| admin | /admin/system/alerts | L1:6 | 3/3/3 | Bảng rộng hơn khung, phải cuộn ngang mới thấy cột "Mã…" (chỉ lộ nửa tiêu đề) và cột Thao tác (nút "Ghi nhận")  · Cột "Phân hệ/nguồn": chữ "OP_FORM_INSTANCE", "OUTBOX_MONITOR", "OP_MISA_SYNC_EVENT" tràn sang cột "Trạng thái" · Cột "Nội dung" là câu tiếng Anh/kỹ thuật kèm giờ ISO thô: "Batch release pending: FINISHED_GOODS_QC đã ký lúc  |
| admin | /admin/recall/cases/[id] | — | 0/13/6 |  |
| admin | /admin/raw-warehouse/stock | L1:6 L10:2 L4:13 | 2/5/3 | Mã "ING_CU_CAI_TRANG_THAI_KHUC", "ING_CAN_TAY_THAI_NHUYEN" tràn sang cột "Lô", đè chữ "2 lô"/"000031". · Cột "Khả dụng"/"Net cần bù" in "11,976 kg", "18,999 kg", "124,999 kg", "67,751 kg" (3 số lẻ dấu phẩy) đứng cạn |
| admin | /admin/integrations/misa/reconcile | L1:2 | 2/5/4 | Khối "Ranh giới chế độ MISA" (lặp nguyên khối của màn Ánh xạ): thẻ 4 mã "MISA_PRODUCTION_CONFIG_INCOMPLETE" ch · Mã kỹ thuật: "P12.07", "MisaSyncOptions.Mode", "Đường dẫn chuẩn P12: /admin/integrations/misa/reconcile"; bảng |
| admin | /admin/account | L11:1 | 2/5/3 | Khối "Ô ký trên phiếu vận hành": tràn mã kỹ thuật — DAY_LEADER, QC, WH_ACCOUNTANT, QA_RELEASE và danh sách 32  · Khối "Thiết bị đang đăng nhập": liệt kê hết ~35 phiên kể cả phiên "Đã hết hạn"/"Đã thu hồi", làm trang dài 700 |
| admin | /admin/finished-goods-warehouse/stock | L1:6 L11:1 L4:3 | 1/8/3 | Cột "Mẻ" chỉ rộng ~55px: "7 batch / 11 đơn vị / 2 vị trí" gãy mỗi chữ một dòng (6 dòng), cột "Thu hồi" lại rộn |
| admin | /admin/system/screens | L10:2 L11:1 L4:1 | 1/8/6 | Cột "Tên màn hình" toàn tiếng Anh ("Audit Integrity", "Users And Roles", "Reason & Config Registry", "Product  |
| admin | /admin/printing/qr-registry | L1:6 L10:1 L4:40 | 2/3/9 | Bảng 9+ cột: bảng rộng hơn khung, phải cuộn ngang mới thấy cột Thao tác ("In lại", "Hủy", "Bật truy xuất công  · Mã QR "QR-20261117…-97392ebf7f" (mã đủ 30 ký tự) gãy 3 dòng, mã đơn vị "PKG-17112026-000008-UNIT-001" gãy 4 dò |
| admin | /admin/inventory/adjustments | L10:1 L13:1 L4:12 | 2/4/4 | Bảng 11 cột: bảng rộng hơn khung, phải cuộn ngang mới thấy cột "Thao tác" (tiêu đề chỉ lộ "Thao", nút ▶/✓ lộ m · Cột hẹp gãy chữ nặng: "Loại" ("Ghi / giảm / hủy tồn" 3 dòng), "Lô" ("M3-SANDBOX-LOT-RESERVED-001" 5 dòng), "Lý |
| admin | /admin/recipes/[recipeId] | L1:7 L11:1 L3:1 L4:2 | 2/4/5 | Cột "Cách sơ chế", "Quy trình sơ chế" chỉ ~120px, chữ gãy 5–8 dòng, mỗi hàng cao 140–220px; trong khi cột "SL  · "Lịch sử vòng đời" toàn mã: RECIPE_ACTIVATE, "APPROVED → ACTIVE_OPERATIONAL", "UNCREATED → DRAFT"…; tiêu đề cộ |
| admin | /admin/finished-goods-warehouse/stock/[skuId] | L10:1 | 2/4/5 | Bảng rộng hơn khung, phải cuộn ngang mới thấy các cột sau "Kho" (vị trí, số lượng, thao tác); cột "Kho" lộ "Fi · Mỗi dòng cao ~250px trong khi nội dung thấy được chỉ ~3 dòng chữ → có cột ẩn bên phải chứa chữ dài làm dòng ca |
| admin | /admin/qc-release/inspections | L4:32 | 1/6/2 | Bảng rộng hơn khung, phải cuộn ngang mới thấy cột sau "Ngày ký" (cột thao tác) — ở 1366px không thấy nếu không |
| admin | /admin/dashboard | — | 0/10/9 |  |
| admin | /admin/production/equipment | L11:1 | 1/6/7 | Mục thứ hai tiêu đề "Bước sơ chế & bản đồ prep_note"; bảng "Bước sơ chế chuẩn" cột "Trạng thái" in chữ "ACTIVE |
| admin | /admin/master-data/suppliers/[id] | L2:1 | 1/6/6 | Trạng thái trống bảng "Nguyên liệu" in nguyên thực thể HTML: "Nhấn &laquo;Thêm nguyên liệu&raquo; để đăng ký…" |
| admin | /admin/system/service-accounts | — | 1/6/3 | Ô "Phạm vi" (khoá thật, giá trị SERVICE) nền xám NHẠT hơn các ô nhập được (xám đậm) → người dùng thấy ngược: ô |
| admin | /admin/material/receipts | L4:40 L9:2 | 1/4/2 | Bố cục 2 cột: thẻ trái "Xác nhận nhận hàng" chỉ có 2 ô + nút (cao ~400px) nhưng khung thẻ kéo dài theo bảng bê |
| admin | /admin/raw-warehouse/ledger | L1:12 L4:21 | 1/4/0 | Mã "ING_NAM_KIM_CHAM_CAT_KHUC_20_30_MM", "ING_RONG_BIEN_KOMBU_WAKAME" tràn đè lên số lô ở cột bên. |
| admin | /admin/forms/[formKey] | L4:23 | 2/1/4 | Tiêu đề trang và breadcrumb mở đầu bằng mã enum "PRODUCTION_DEMAND_PLAN · Phiếu kế hoạch / nhu cầu sản xuất" → · Cột "Kết luận" ~95px: "Đưa lên bảng nhu cầu sản xuất" gãy 4 dòng; cột "Người lập" "<tên người> gãy 3 dòn |
| admin | /admin/raw-material/master | — | 1/5/7 | Hộp xác nhận in "Trạng thái master không đồng nghĩa với tồn kho hoặc READY_FOR_PRODUCTION" (enum + "master") → |
| admin | /admin/master-data/material-warning-thresholds | — | 1/5/2 | Bảng ~120 dòng (Sâm Savigin… Thùng carton…) đổ hết một trang, ảnh bị cắt ở 7000px, không có phân trang → thêm  |
| admin | /admin/raw-material/intakes | L10:1 L2:1 L4:23 | 1/4/4 | Cột "NCC" chỉ ~65px: tên "Công ty TNHH Lương thực & Nông sản Đồng Bằng Xanh" gãy mỗi chữ một dòng (11 dòng) →  |
| admin | /admin/finished-goods-warehouse/ledger | L4:23 | 1/4/2 | Hàng loạt mã gãy 2–3 dòng: "BATCH-17112026-000006" (3 dòng), "WR-17112026-000003" (3 dòng), mã PKG trong cột S |
| admin | /admin/catalog/skus | L11:2 | 0/8/7 |  |
| admin | /admin/raw-material/intakes/[id] | L10:2 | 0/8/7 |  |
| admin | /admin/printing/queue | L10:1 L4:20 | 0/7/5 |  |
| admin | /admin/system/audit-log | L1:6 | 1/4/6 | Cột "Loại sự kiện": dòng mã phụ "AUTH_LOGIN_SUCCESS", "MOBILE_DEVICE_SESSION_ISSUED" dài hơn ô, tràn đè lên cộ |
| admin | /admin/source-origin/zones | L11:1 L13:1 L3:2 | 1/4/4 | Bảng "Đối soát sản lượng tự trồng", cột "Kết luận": badge "Không đối chiếu được", "Chưa khai hạn mức" kéo hết  |
| admin | /admin/inventory/ledger | L1:10 L4:22 | 1/3/2 | Cột "Mặt hàng": mã "ING_NAM_KIM_CHAM_CAT_KHUC_20_30_MM", "ING_RE_CAN_TAY_THAI_NHUYEN" tràn sang cột "Lô", đè l |
| admin | /admin/system/mobile-devices | L4:1 | 1/4/7 | Bảng rộng hơn khung, phải cuộn ngang mới thấy cột Thao tác (Cấp lại / Thu hồi phiên) nằm sau "Lý do thu hồi" → |
| admin | /admin/raw-material/packaging-intakes/[id] | L10:1 | 1/4/6 | Bảng "Dòng vật tư": bảng rộng hơn khung, phải cuộn ngang mới thấy cột thứ 9 sau "Lô NCC / Hạn dùng" (cột thao  |
| admin | /admin/source-origin/origins | — | 1/4/8 | Cột "Thao tác": 4–5 nút chỉ có biểu tượng, mỗi nút một màu (xanh ngọc tải lên, xanh lá tick, tím bút, hồng tam |
| admin | /admin/production/work-orders/[id] | — | 1/3/2 | "Mã điều kiện chặn: WORK_ORDER_COMPLETED" và cảnh báo "Work order đã COMPLETED." → "Lệnh công việc đã hoàn thà |
| admin | /admin/catalog/skus/[skuId] | L11:1 | 0/6/9 |  |
| admin | /admin/master-data/suppliers | — | 0/6/5 |  |
| admin | /admin/production/work-orders | L4:41 | 1/1/5 | Bảng rộng hơn khung, phải cuộn ngang mới thấy cột "Thao tác" (tiêu đề lộ "Thac", nút "giao người" lộ một nửa,  |
| admin | /admin/warehouse/receipts/[id] | L10:1 L11:1 | 1/2/5 | Nội dung chỉ là một UUID trơn ("67a3185c-…") dạng gạch đầu dòng, không nhãn, không liên kết → hiện lô, vị trí, |
| admin | /admin/raw-material/intakes/545e…/lines/0bba…/qc | — | 1/2/1 | Phụ đề "Táo tàu - PENDING" (enum); thẻ "Lỗi xác thực" liệt kê mã "RECEIPT_QUANTITY_INVARIANT_FAILED, REASON_RE |
| admin | /admin/forms | L1:29 | 1/1/4 | Góc phải mỗi thẻ loại phiếu: con số lớn (90, 72, 59, 51, 42, 29, 32, 30, 39, 16, 120, 117, 106, 58, 61, 60, 6… |
| admin | /admin/recipes | L11:2 L3:1 | 0/5/4 |  |
| admin | /admin/production/process-execution | L2:1 | 0/5/3 |  |
| admin | /admin/recall/incidents | — | 0/5/1 |  |
| pwa | /pwa/account | — | 0/5/6 |  |
| pwa | /pwa/settings/device | — | 0/5/2 |  |
| admin | /admin/packaging/jobs | L10:1 L4:25 | 0/4/5 |  |
| admin | /admin/forms/[formKey]/[formInstanceId] | L10:3 | 1/1/3 | Hàng 9 nút trạng thái (Trở về, Cập nhật trường nhập/chọn, Gửi xác nhận, Xác nhận phiếu, Trả về nháp, Chặn phiế |
| admin | /admin/material/issues | L3:2 | 1/1/2 | Cột "Phiếu kế toán xuất nguyên liệu": badge "Đã xác nhận" / "Nháp tự sinh" giãn hết bề ngang ô (~315px) như th |
| pwa | /pwa/sale-lock-ack | — | 1/1/2 | Sáu thẻ đều "Xác nhận khoá bán" và dòng phân biệt chỉ là loại đối tượng "BATCH" / "QR" / "SKU", không có mã lô |
| pwa | /pwa/change-password | L15:2 | 0/4/2 |  |
| admin | /admin/packaging/trade-items | L2:1 | 0/4/4 |  |
| admin | /admin/packaging/trade-items/[skuKey] | — | 0/4/3 |  |
| admin | /admin/master-data/b3-stock-policy | — | 0/4/3 |  |
| admin | /admin/recall/cases | — | 0/4/6 |  |
| pwa | /pwa/packaging | — | 0/4/1 |  |
| pwa | /pwa/qr-scan | — | 0/4/1 |  |
| pwa | /pwa/raw-intake-capture | — | 0/4/4 |  |
| admin | /admin/raw-material/lots | L11:1 L4:21 | 0/3/3 |  |
| admin | /admin/warehouse/receipts/new | L10:2 L11:1 L13:1 L2:1 | 0/3/1 |  |
| admin | /admin/production/orders | L2:1 | 0/3/4 |  |
| admin | /admin/raw-material/packaging-intakes | L2:1 | 0/3/4 |  |
| admin | /admin/master-data/suppliers/[id]/ingredients | L2:1 | 0/3/2 |  |
| admin | /admin/source-origin/origins/[id] | L2:1 | 0/3/4 |  |
| admin | /admin/traceability | — | 0/3/2 |  |
| admin | /admin/master-data/suppliers/[id]/users | — | 0/3/1 |  |
| pwa | /pwa/lot-mark-ready | — | 0/3/3 |  |
| pwa | /pwa/offline-queue | — | 0/3/4 |  |
| pwa | /pwa/raw-lot-scan | — | 0/3/1 |  |
| pwa | /pwa/recall-evidence | — | 0/3/3 |  |
| pwa | /pwa/workforce-check | — | 0/3/2 |  |
| admin | /admin/raw-material/packaging-lots | L4:2 | 0/2/3 |  |
| admin | /admin/qc-release/inspections/[id] | L10:2 | 0/2/8 |  |
| admin | /admin/qc-release/batches/[id] | L10:1 L9:1 | 0/2/3 |  |
| admin | /admin/raw-material/packaging-intakes/[id]/lines/[lineId] | L11:1 | 0/2/2 |  |
| admin | /admin/recall/incidents/[id] | L11:1 | 0/2/1 |  |
| pwa | /pwa/scan | L3:1 | 0/2/5 |  |
| admin | /admin/inventory/lot-balance | — | 0/2/3 |  |
| admin | /admin/master-data/warehouses | — | 0/2/9 |  |
| admin | /admin/master-data/uom | — | 0/2/0 |  |
| admin | /admin/system/approvals | — | 0/2/0 |  |
| admin | /admin/traceability/public-preview | — | 0/2/0 |  |
| pwa | /pwa/production-execution | — | 0/2/1 |  |
| pwa | /pwa/warehouse-receipt | — | 0/2/1 |  |
| admin | /admin/warehouse/receipts | L10:2 L11:2 L13:1 | 0/1/2 |  |
| admin | /admin/qc/inspections | L4:32 | 0/0/0 |  |
| admin | /admin/warehouse/inventory/ledger | L1:10 L4:22 | 0/0/0 |  |
| admin | /admin/material/requests | L13:1 | 0/1/4 |  |
| admin | /admin/inventory/adjustments/[id] | L11:1 | 0/1/4 |  |
| admin | /admin/production/shifts | — | 0/1/5 |  |
| admin | /admin/warehouse/inventory/lot-balance | — | 0/1/0 |  |
| admin | /login | — | 0/1/3 |  |
| admin | /supplier/login | — | 0/1/2 |  |
| admin | /supplier/reset-password | — | 0/1/1 |  |
| admin | /admin/integrations/misa/sync-jobs | — | 0/1/2 |  |
| admin | /admin/integrations/outbox | — | 0/1/0 |  |
| admin | /admin/system/overrides | — | 0/1/0 |  |
| admin | /admin/traceability/genealogy | — | 0/1/2 |  |
| admin | /change-password | — | 0/1/3 |  |
| pwa | /pwa/qc-checklist | — | 0/1/2 |  |
| pwa | /pwa/raw-lot-qc-reset | — | 0/1/3 |  |
| admin | /admin/release/batches | L4:18 | 0/0/1 |  |
| admin | /admin/warehouse/inventory/adjustments | L10:1 L13:1 L4:12 | 0/0/0 |  |
| pwa | /pwa/trace-scan | L3:1 | 0/0/1 |  |

## 7. Chưa kiểm (ghi thật)

- Tab ở trang chi tiết: lượt chụp lại 18/11 rơi đúng lúc Docker Desktop sập (21:58, ổ C hết chỗ) nên lab mất DB; **19/11 01:4x chụp lại khi DB
  chạy: tab chuyển bình thường** (đã xem tay tab "Nguyên liệu" của Lệnh sản xuất; 12 ảnh tab còn lại do agent xem, ghi vào `xem-anh-A.md`).
  4 thẻ tab màn Tổng quan và 2 nút viên màn Toàn vẹn nhật ký dùng `onClick` thường, lượt đầu bấm bằng `click()` đổi nội dung đúng ⇒ không phải lỗi.
- Màn app xưởng chỉ dùng được với vai khác (KCS, kho, đóng gói) đã xem bằng tài khoản quản trị; chưa xem riêng từng vai.
- Chưa xem ở khổ < 1366 cho admin (laptop 1280) và khổ 768 (máy tính bảng dọc) cho app xưởng.
- Máy đo có 2 loại báo nhầm đã loại khỏi số: thanh tab chi tiết cố ý kéo ra sát mép (+24px) và ký tự "›" của breadcrumb (11px).

## 8. Kế hoạch (tóm tắt — chi tiết ở `wp/M12-WP28-ui-bo-cuc-dong-bo.md`)

| Đợt | Làm gì | Khi nào | Đụng phiên khác |
|---|---|---|---|
| 0 | 16 việc gốc C1–C16 ở component chung + cổng chặn tái phát (bộ dò bố cục vào `tools/ui-audit`, static guard đếm lùi) | 19/11 | không |
| 1 | admin từng màn theo §6 (2 coder chia nhóm A/B) | 20–21/11, sau khi WP27 commit `features/**` | WP27 |
| 2 | app xưởng (tiếp WP24) | 19/11 song song đợt 0 | không |
| 3 | dò lại đủ phạm vi (0 mục L1–L4), agent xem ảnh độc lập, bộ kiểm đủ, Toàn bấm thử 20 màn | 22/11 | — |

Đích: 0 mục máy đo L1–L4, 0 mục xem ảnh Cao/Vừa (trừ L11/L14 thuộc WP27), mỗi khối một component. Push/.99 hỏi riêng.

## 9. Cần Toàn quyết (đề xuất in đậm)

- **m12.170** màu ô nhập: **A** ô sửa được nền trắng viền rõ, ô chỉ đọc xám nhạt không viền đậm, ô khoá xám + chữ mờ (cả admin + app xưởng) ·
  B giữ nền xám, chỉ làm ô khoá đậm hơn. A sửa ~80 mục "trông như bị khoá"; B rẻ hơn nhưng vẫn khó phân biệt.
- **m12.171** bảng rộng ở laptop 1366: **A** ghim cột Thao tác bên phải + bóng mép báo còn cuộn + gộp cột phụ vào dòng phụ để 17 màn vừa khung ·
  B chỉ gộp cột, không ghim. A: thao tác luôn thấy; B: ít thay đổi hơn nhưng bảng nhiều cột vẫn phải cuộn tìm nút.
- **m12.172** xem chi tiết từ danh sách (SKU/Điều kiện bán, Toàn vẹn nhật ký, Tài khoản dịch vụ): **A** bấm dòng mở ngăn kéo phải, bảng giữ
  đủ bề ngang · B mở trang chi tiết riêng · C giữ chia đôi. A khớp phần lớn admin đang dùng (ngăn kéo phát hành, nhật ký).
- Mặc định đã chọn (không hỏi): đợt 1 chạy sau WP27; chữ/mã lộ (L11/L14) chuyển WP27; cổng chặn tái phát vào repo.
