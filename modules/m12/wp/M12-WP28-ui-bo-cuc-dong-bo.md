# M12-WP28 — Giao diện: hết lỗi bố cục + đồng bộ khối giữa các màn (admin-web + app xưởng)

Mở 18/11 22:xx · phiên m12 [f1e7c3] · nguồn: bản rà `ra-soat/2026-11-18-ui-bo-cuc-bao-cao.md` (Toàn yêu cầu 18/11 21:0x:
"rà soát kĩ… liệt kê đầy đủ và lên kế hoạch khắc phục để ko bỏ sót và ko còn bất kì lỗi ui nào nữa").
Rủi ro **R2** (giao diện rộng, không đụng dữ liệu/bảo mật/hợp đồng API). Trạng thái: **ĐANG LÀM** (Toàn duyệt m12.170–172 A, D-m12-123, 19/11 06:5x).

## 1. Đích (đo được)

- Bộ dò bố cục (`tools/ui-audit`, đợt 0 đưa vào repo) chạy đủ 95 màn admin + 18 màn app xưởng, 2 khổ mỗi app, kèm tab, hộp thoại "Tạo/Thêm",
  hộp thoại theo dòng: **0 mục** loại tràn viền, lấn lề, badge giãn, chữ tràn ô, nút lệch, ô cao lệch, ô bảng chật (L1–L4).
- Xem ảnh lại (agent độc lập, không phải người sửa): **0 mục Cao, 0 mục Vừa** ở L1–L10, L12, L13, L15. L11/L14 (chữ, mã kỹ thuật) theo WP27.
- Mỗi loại khối (khung trang, bộ lọc, bảng, phân trang, nút tạo, thao tác dòng, hộp thoại, tab, thẻ số, trạng thái trống/lỗi, trang đăng nhập)
  có **một** component chuẩn; màn nào còn tự vẽ khối đó ⇒ guard đỏ (đếm lùi, không tăng).
- Toàn bấm thử trên lab bộ ảnh trước/sau của 20 màn nặng nhất và nói đạt.

## 2. Vùng tệp và phối hợp

| Đợt | Vùng tệp | Đụng phiên khác? |
|---|---|---|
| 0 Nền chung | `packages/ui/**`, `packages/design-tokens/**`, `apps/admin-web/src/components/{ui,form,layout}/**`, `apps/admin-web/src/design/**`, `tools/ui-audit/**` (mới), test `tests/frontend/**/components/**` + static guard mới | Không: WP27 đã chừa vùng này cho WP24 |
| 1 Admin từng màn | `apps/admin-web/src/features/**` (trừ `auth/**`, `account/**`, `UsersRolesPage.User*` tới khi WP26 commit) | **Có WP27** (Việt hoá chữ cùng thư mục) ⇒ chạy SAU khi WP27 commit phần `features/**`, hoặc chia theo thư mục với phiên fork |
| 2 App xưởng | `apps/shopfloor-pwa/**`, `tests/frontend/shopfloor-pwa/**` (trừ `src/lib/api/generated/types.ts` tới khi WP26 báo) | Không |
| 3 Kiểm | chỉ đọc + lab | — |

Chữ/mã kỹ thuật lộ ra (L11) và câu khó hiểu (L14) **không** sửa trong WP28: danh sách theo màn gửi phiên fork (WP27). WP28 chỉ đổi chữ khi đổi
component (vd. nhãn nút chuẩn "Tải lại", "Xóa lọc").

## 3. Đợt 0 — chuẩn và component chung (sửa một chỗ, hết ở mọi màn)

| Mã | Việc | Gốc đã thấy trong mã | Chữa các lỗi |
|---|---|---|---|
| C1 | `Badge`: `width: fit-content`, `max-width: 100%`, `flex-shrink: 0`, `align-self: flex-start`, cắt "…" + `title` khi dài; cấm badge chứa câu dài (cảnh báo dev) | `packages/ui/src/Badge.tsx` chỉ `inline-flex` + `nowrap` | badge giãn hết ngang (3 ví dụ của Toàn), chữ "Sẵn sàng" tràn badge, badge bị bảng cắt |
| C2 | Chiều cao điều khiển theo token: `--control-h-sm` 32px, `-md` 38px, `-lg` 44px; `Button`, ô nhập, ô chọn, ô ngày cùng thang; app xưởng ≥ 44px ở MỌI khổ | `Button.tsx` chỉ có padding, không chiều cao (đo được 7 chiều cao nút trên một màn: 21–51px); app xưởng 38px ở khổ 1024 | nút lệch hàng ô nhập, nút co nhỏ ở máy tính bảng |
| C3 | (D-m12-123) Trạng thái ô nhập: sửa được = nền trắng viền rõ; chỉ đọc = nền xám nhạt, không viền đậm; khoá = xám + chữ mờ + con trỏ cấm. Một nguồn cho `TextInput`, `Select`, `Textarea`, `Combobox`, ô ngày (admin + app xưởng) | `--surface-inset` 94% cho ô SỬA ĐƯỢC, ô chỉ đọc 96% (nhạt hơn) | "ô nào cũng như bị khoá" (≈ 80 mục, mọi form/bộ lọc) |
| C4 | `DataTable`: tiêu đề cột canh theo dữ liệu (chữ trái, số phải); `meta.kind` = `code` (một dòng, "…", tooltip), `date` (một dòng `HH:mm dd/MM/yyyy`), `number` (phải, `tabular-nums`), `status`, `actions` (ghim phải + bóng mép, D-m12-123), `text`; `meta.minWidth`; ô rỗng "—"; bóng mép báo còn cuộn ngang; thanh cuộn luôn thấy | `DataTable.tsx:356` tiêu đề `textAlign: "center"`, ô trái; không có độ rộng cột; cột thao tác không ghim | ≈ 520 ô bảng chật, mã `ING_…` tràn đè cột bên, cột Thao tác khuất ở 1366px, ngày giờ gãy 2 dòng |
| C5 | Thao tác dòng chuẩn: tối đa 1 nút chữ + menu "…"; nút biểu tượng luôn có nhãn/tooltip; màu trung tính, chỉ hành động huỷ/xoá đỏ | mỗi màn tự ráp `IconButton` màu riêng | nút thao tác mỗi màn một màu, thiếu nhãn |
| C6 | `Button` biến thể `destructive` thống nhất; `ConfirmDialog` loại "warning" không còn thành nút chính xanh lá; thứ tự nút đầu trang `[Trở về] … [phụ] [chính]`, một nút chính/màn | `ConfirmDialog.tsx:36` `warning → "primary"` | nút Ngừng/Từ chối màu xanh lá, nút nguy hiểm 5 màu |
| C7 | `FilterBar`: ô lọc + "Tải lại"/"Xóa lọc" trong cùng thanh, canh đáy ô; khoảng ngày là một điều khiển chiếm 2 cột; lưới không để ô lẻ hàng | bộ lọc mỗi màn tự ráp; nút lọc nằm ở đầu trang | "Đến ngày" rơi một mình, Tải lại/Xóa lọc xa bộ lọc |
| C8 | `FormActions`: hàng nút dưới các ô (canh phải) hoặc nút cùng hàng canh đáy ô; guard cấm `Button` làm ô của `FieldGrid` | `SellablePage.dialog-components.tsx` đặt nút trong `FieldGrid` | nút "Chạy kiểm tra" lạc hàng (ví dụ Toàn) |
| C9 | `PageHeader`: mô tả đủ bề ngang (nút đầu trang xuống hàng khi chật), tên breadcrumb = tên menu (một nguồn), "Trở về" một chỗ; `AuthLayout` chung cho đăng nhập/đổi mật khẩu/NCC | mô tả bị bóp nửa ngang khi nhiều nút; trang xác thực mỗi trang một kiểu | khung trang lệch giữa các màn |
| C10 | `Dialog` chuẩn: 3 cỡ (440 xác nhận / 600 form / 720 form rộng hoặc ngăn kéo), luôn có "×" + mô tả, focus ô đầu, nút chốt cùng động từ nút mở, chân phải | mỗi màn tự ráp | thiếu "×", "×" nhận focus, cỡ lẫn lộn |
| C11 | `EmptyState` / `ErrorState` / `ForbiddenState` / `UnavailableState` giữ nguyên khung trang; cấm "Chưa có…" trong badge | màn tắt chỉ còn hộp đỏ; trạng thái trống 4 kiểu | 5 màn tắt mất tiêu đề, "Chưa có kết quả" dạng badge |
| C12 | `Tabs` (gạch chân + số đếm, kiểm chuyển tab bằng chuột thật), `StatCard` một kiểu, `Pagination` một kiểu (3 phần, một hàng, ẩn khi rỗng) | 4 kiểu tab, 4 kiểu thẻ số, phân trang thiếu phần | lệch đồng bộ |
| C13 | Bảng trong thẻ: bỏ viền/bo góc ngoài của bảng khi nằm trong `SectionCard` | viền chồng viền | thẻ lồng thẻ |
| C14 | Thanh bên: tên menu dài xuống 2 dòng hoặc tooltip (tên ngắn do WP27/WP23 quyết) | cắt "…" không tooltip | "Tồn tối thiểu/tối đ…" |
| C15 | Chính–chi tiết: bấm dòng → ngăn kéo phải, tô dòng đang mở (D-m12-123) | `SellablePage` chia đôi 50/50 | bảng SKU bị ép, cột "Nhóm" mỗi chữ một dòng |
| C16 | **Cổng chặn tái phát**: (a) đưa bộ dò bố cục vào `tools/ui-audit/` (checker + chạy + gom, đọc mật khẩu lab như skill verify-change, chặn mọi yêu cầu ghi); (b) static guard vitest: hợp đồng style `Badge`, cấm `Button` trong `FieldGrid`, đếm lùi `<table>`/`<input>`/`<select>`/`<button>` tự viết trong `features/**` (hiện 42/56/18/22), cấm `fontSize` số cứng | chưa có | không tái phát |

## 4. Đợt 1 — admin từng màn (sau WP27)

Danh sách đầy đủ theo màn: `ra-soat/2026-11-18-ui-bo-cuc-bao-cao.md` §4 (114 màn/khổ, mỗi màn: số lỗi đo được theo mã + số lỗi xem ảnh Cao/Vừa/Thấp
+ lỗi Cao tiêu biểu); chi tiết từng ô ở thư mục bằng chứng `ra-soat/2026-11-18-ui-bo-cuc/` (`gom-admin.md`, `xem-anh-A.md`, `xem-anh-B.md`).
Chia 2 coder theo thư mục, mỗi màn: thay khối tự vẽ bằng component đợt 0, khai `meta` cột, bỏ thẻ lồng, sửa mục Cao/Vừa còn lại sau đợt 0.
- **1A** sản xuất · kho NL/TP · nguyên liệu · in · biểu mẫu · MRP · KCS kiểm nghiệm (nhóm A, 89 mục màn).
- **1B** SKU/điều kiện bán · công thức · dữ liệu chính · xuất xứ · truy vết · thu hồi · phát hành · hệ thống · MISA · tài khoản · đăng nhập (nhóm B, 99 mục màn).
- **Chia lại theo lịch trả vùng của WP27 (19/11 08:1x, phiên fork):** đợt **1-I** = thư mục nhóm B của WP27 (`system, master-data, catalog, integrations,
  misa-integration, reporting, dashboard, audit-integrity, account, suppliers, supplier-portal, auth` + `a11y/` lấy ngay), chạy sau khi WP27 commit nhóm B
  (ước 11:00–11:30); đợt **1-II** = thư mục nhóm C của WP27 (`operational-forms, demand-mrp-stock-alert, sellable, recipes, source-origin, raw-material,
  raw-warehouse, production, packaging-printing, qc-release, finished-goods-warehouse, warehouse-inventory, traceability, recall`), sau khi WP27 commit nhóm C (ước 12:00–13:00).

## 5. Đợt 2 — app xưởng (tiếp WP24)

Thẻ việc gọn (tiêu đề là việc cụ thể, không lặp tên trang; mã rút gọn), hàng chip lọc cuộn ngang thay vì 11 dòng, tên màn thống nhất giữa
thanh trên / menu / breadcrumb / tiêu đề (một nguồn `shopfloor-page-registry`), ẩn breadcrumb trên điện thoại (thanh trên đã có Trở về + tên),
"Thêm chi tiết" thành nút mở rộng (không giống ô nhập), "Tải lại" không gãy dòng, việc quá hạn tô đỏ + xếp đầu, thẻ khoá bán ghi rõ hàng bị khoá,
thanh bên dính ở khổ 1024, khoảng trắng thừa cuối trang. Danh sách: `xem-anh-P.md` (3 Cao, 86 Vừa, 61 Thấp).

## 6. Đợt 3 — kiểm

Chạy lại bộ dò đủ phạm vi §1 trên SHA cuối + agent xem ảnh độc lập (so trước/sau) + bộ kiểm đủ (build, vitest 3 app, typecheck, lint strict, guard)
+ Toàn bấm thử 20 màn trên lab. Push và lên .99: hỏi riêng từng việc.

## 7. Lịch

19/11 đợt 0 + đợt 2 (song song, 2 coder) · 20–21/11 đợt 1 (2 coder, sau WP27) · 22/11 đợt 3 · trước M-c (≤ 25/11).

## 8. Tiến độ

- 18/11 22:xx: rà xong, mở phiếu, chờ Toàn duyệt m12.170–172.
- 19/11 06:5x: Toàn duyệt m12.170–172 A (D-m12-123) ⇒ chạy đợt 0 (nền chung) + đợt 2 (app xưởng) song song, chế độ S; đợt 1 chờ WP27 commit `features/**`.
- 19/11 08:0x đợt 0 + đợt 2 XONG phía coder, commit cục bộ (chưa push): `f9662ad23` nền chung (49 tệp: Badge co theo chữ, token `--control-h-*` 32/38/44, ô nhập 3 trạng thái `--input-*` cả nền tối, DataTable `meta.kind` + tiêu đề canh theo dữ liệu + cột Thao tác ghim phải + bóng mép + `activeRowId`, thao tác dòng trung tính + menu "…" bật theo màn, `destructive`, FilterBar/FormActions/AuthLayout/PageStates, hộp thoại 440/600/720 có "Đóng", DetailTabs bỏ lề âm, guard ratchet theo tệp: table 42 · input 51 · select 12 · button 21 · fontSize 14 · nút trong FieldGrid 1); `cff9ac58d` app xưởng (33 tệp: tên màn một nguồn, chip một hàng, thẻ việc gọn + quá hạn lên đầu, chạm ≥ 44 mọi khổ, 1024 thanh bên dính; tự dò 0 mục L1–L4 20 màn × 2 khổ); `bb7f52267` `tools/ui-audit/` (bộ dò vào repo, route tự lấy từ App Router). Coder tự kiểm: ui 37/37, app xưởng 1.397/1.397, admin đủ 5.401 đạt/76 hỏng trong checkout chung (24 ca còn lại sau chạy riêng đều do tệp dở WP27/WP26). Đang chạy: verifier độc lập (worktree sạch `kiem-WP24-1b2b` @ `bb7f52267`) + bộ dò đủ 95 màn admin sau đợt 0. Đợt 1 chờ WP27 commit màn nhóm B + C (đã hỏi phiên fork giờ trả). Việc sau (ngoài WP28): thẻ "khoá bán" cần API trả mã hàng bị khoá (sửa `services/**`).
- 19/11 08:5x verifier đợt 0 + 2: CẦN SỬA (chỉ test + 3 lỗi nhỏ + combobox 39/36px); admin vitest worktree sạch 5.342/5.342, PWA 1.397/1.397; vòng sửa đang chạy.

- 19/11 09:38 Codex tiếp quản sau Toàn xác nhận dừng cả ba Claude và agent con: snapshot/hash WIP trong `C:\Users\Administrator\AppData\Local\Temp\codex-tiep-quan-m12-20261119\WP28-execution-baseline`. WP27 giữ features/lib/admin tests tới khi trả allowlist; WP26 giữ mail backend/admin. WP28 giữ nền UI, PWA và điều phối index tuần tự. Không push/deploy.
- Đã đối chiếu lịch sử vòng sửa: `5ddf06a01`/`6354ab1c0`/`136a64713`; verifier Claude bị limit, chưa có kết luận cuối. Codex tiếp admin Vitest trên detached sạch `136a64713`, không chạy lại bộ UI/PWA/typecheck đã có evidence xanh đúng SHA.
- Codex commit cục bộ `a9d8f80f5`: cổng UI không bỏ qua ô bảng chật/chữ cắt, thiếu màn/checker lỗi trả không đủ bằng chứng; đo chiều cao cả hàng chỉ có input/combobox; không nhận nhầm checkbox/date như nút hành động. Test Chrome trên HTML tổng hợp + policy 10/10, rà độc lập không lỗi chặn. Đây là kiểm công cụ, không phải xác nhận mọi màn đã sạch.

- 19/11 Codex verifier admin `136a64713`: 5350/5350 (620 tệp) đạt, worktree sạch. Follow-up `1a0641d` đã commit, D2 guard 1/1 đạt; live audit4màn/16lượt còn67mục bố cục chưa khử trùng (RawIntake/Sellable thuộc đợt1 đang chờ WP27). Báo cáo `ra-soat/2026-11-19-codex-wp28-wp24.md`.
- 19/11 Toàn giao tiếp tục ghép WP27 và hoàn thành admin theo yêu cầu gốc. Đã ghép A `5acb6b121`, B `cdc72cb64`, C `084b0d406`; hash519tệp đối chiếu snapshot (18tệp chỉ CRLF/LF), không gộp hai WIP mail WP26. WP27 trả features/lib; WP28 chia coder B/C, reviewer độc lập và root giữ shared UI/công cụ/ratchet.
- Đợt admin đang sửa toàn nhóm:3drawer, metadata cột, FilterBar, menu thao tác, bảng nhập liệu chuẩn và khung trạng thái. Checklist99route rows +317mục Cao/Vừa lịch sử đã lập; chưa coi danh sách cũ là lỗi runtime hiện tại. Tool bổ sung ledger tab/dialog/row/manifest và cổng thiếu evidence; root đang kiểm độc lập.
- Chỉ đạo localhost mới qua chat WP27: đã tắt lab cũ3200/3201/5200, các phiên dùng chung API `http://localhost:5000`, admin `http://localhost:3000`, PWA `http://localhost:4401` do Toàn tự chạy. Không tự mở preview/API/DB song song; DB55432 giữ nguyên, chưa áp seedWP27 lên DB đó. Kiểm UI cuối chờ runtime đúng candidate; các lượt kiểm hữu hạn xếp tuần tự với WP26.

- 19/11 10:46: admin candidate local `2209068ce` đãcommit bounded243files; 2WIP WP26+3WIP upgradePWA giữriêng. R2 durable10/10+5mutants, root43/43, tool36/36; đang fullchecks exactSHA vàruntime. Toàn duyệt4migrationlocalhost đểsửalỗi schema đăngnhập, WP27 chờAPIstop trướcapply; chưa seed. Chưa đủcổng95màn/ảnhđộclập/20mànLead, khôngđánhDONG.

- 19/11, sau 11:15: localhost đã đủ 156 migration và đăng nhập được sau Toàn chạy lại API. WP27 đã áp 544 ô nhãn tiếng Việt theo duyệt riêng của Toàn, không thay dữ liệu ngoài nhãn. Full admin exact `2209068ce`: 5.485 đạt/161 lỗi trong 30/639 tệp; đang sửa harness menu cùng lỗi source cuộn lồng và import dashboard, chưa đạt full gate. Audit toàn màn đang chạy chẩn đoán; phát hiện bố cục mới đang xử lý, chưa nghiệm thu exact SHA hay 20 màn Lead.

- 19/11 11:5x: commit followup local `f7bc4303f` (67 tệp bounded, giữ toàn bộ WIP WP26/PWA). Focused C329, reviewer117, fixture5, WP27 5 ca đều đạt; app/tests TS đạt, ESLint admin0lỗi/149cảnhbáo, tool67/67. Đang full test/build detached exact commit và audit R3 localhost; trạng thái vẫn ĐANG LÀM, chưa đủ coverage/ảnh/20 màn Lead.

- 19/11 12:30: candidate cục bộ `932b727bb` (20tệp+ownweekly17dòng): sửa Select thựcDOM, focus cheheader/StrictMode, DateTimeInput hẹp, ServiceAccounts và QR; focused9tệp123/123, tool83/83+probe12/12. Full77360 còn3lỗi đã sửa, chưa nhận fullPASS; verifier tiếp fulladmin/build candidate mới. R6 toàn trạng thái đang chạy, thay IDs404 bằng GET hiện tại; giữ hai Medium header/giờ chờ ảnh saufix và Lead20màn. Bảo toàn11WIP WP26/nângNext; chưapush/deploy.
- 19/11 12:4x bàn giao: Toàn giao phiên fork [4cc32cce] làm tiếp WP28 từ `932b727bb` (Codex làm 09:38–12:30; [f1e7c3] chỉ điều phối). Còn: cổng exact-SHA (full admin/public/PWA/UI + typecheck + lint + 3 build), coverage 95 màn + tab/dialog/row + trạng thái pending/budget/auth/network, ảnh độc lập, 2 lỗi Medium (focus landmark, DateTimeInput 275px), PWA phần còn lại, Toàn bấm thử 20 màn. Chưa DONE.
