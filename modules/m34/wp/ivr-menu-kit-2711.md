# ivr-menu-kit-2711 — Quản trị IVR thành menu cấp 0 + rà lại toàn bộ màn IVR theo ui-kit-v2

Trạng thái: ĐẠT phần mã (`425192fec`, `d996fdd70`, `ef296ce59`, `4e5d26aee` trên `toandeptrai`, CHƯA đẩy) · Sheet M3-221 Chờ review · Mức: Thường (giao diện; giữ nguyên hành vi, quyền, API của các thao tác nguy hiểm) · Mốc: trước 30/11
Hạng mục nâng: quản trị IVR (M3 → M8) — 12 màn đúng chuẩn ui-kit-v2, điều hướng bằng menu bên · Sheet: M3-197 (nối tiếp) · Ước lượng: 0,5 ngày AI
Chỗ làm: checkout chính `C:\Projects\ginsengfood-business-platform`, nhánh `toandeptrai` · Base SHA: `425192fec` (phần menu đã commit) · Khoá tệp: `m34/ivr-kit-a`, `m34/ivr-kit-b`
Nguồn: Toàn 27/11 16:2x "xem lại giao diện của admin/ivr, dùng component ui-kit-v2; chỗ phân trang chưa đúng mẫu ui-kit-v2 và nhiều cái khác;
đưa quản trị IVR ra menu cấp 0 (cùng cấp vận hành bán hàng), các tab (tổng quan, danh sách xác nhận, giám sát hệ thống…) làm menu; rà lại UI IVR phải dùng ui kit v2".

## Phần 1 — menu (phiên chính, XONG `425192fec`)
Nhóm cấp 0 "Quản trị IVR" (biểu tượng `phone_in_talk`) ngay sau "Vận hành bán hàng", 12 mục = 12 tab cũ ("Tổng quan" đổi thành "Tổng quan IVR"
vì trùng mục gốc "Tổng quan"); bỏ thanh điều hướng con trong trang (`IvrSubNav`, `IVR_NAV`); đường dẫn trang bắt đầu từ "Quản trị IVR";
12 đường dẫn đều cần `IVR.VIEW` để hiện. vitest `src/app/admin/components` + `src/features/ivr` 43 tệp 659/659.

## Phần 2 — rà và sửa theo kit (2 coder song song, phạm vi không chồng)
- A (`m34/ivr-kit-a`): `IvrAdminShared.tsx`, `ivrKitStyles.ts`, `IvrOverviewPage`, `IvrRequestsPage`, `IvrJobDetailPage`, `IvrOrderConfirmationPanel` (chỉ nhánh `kit`),
  `IvrOperationsScreen`, `IvrChannelsScreen`, `IvrReviewsPage`, `IvrReportsScreen`, `IvrCostCeilingCard`, `IvrConfigurationScreen`, `IvrAuditPanel`, `IvrWriteDialog`
  + test tương ứng trong `src/features/ivr/__tests__/` (admin-*, operations*, reports*, cost-ceiling*, call-usage*, configuration*, audit*, technical-retry*) + `e2e/admin-ivr-kit-a.spec.ts` (mới).
- B (`m34/ivr-kit-b`): `IvrCallRulesScreen`, `IvrCallRuleEditor`, `IvrCallRuleActionDialog`, `src/features/ivr/dispatch-rules/**`, `IvrVoicesScreen`, `IvrVoiceProfileEditor`,
  `IvrVoicePreviewPanel`, `IvrVoiceSetDialog`, `IvrAudioPlayer`, `IvrPhrasesScreen`, `IvrRegionsScreen`, `IvrRegionMoveDialog`
  + test call-rules*, voice*, phrase*, region*, ivr-audio*, `DispatchRulesPage.test.tsx` + `e2e/admin-ivr-kit-b.spec.ts` (mới).
- Chỉ đọc cả hai: `src/shared/components/**` (thiếu thì `CẦN QUYẾT`), `api.ts`, `hooks.ts`, `types.ts`, mọi `*Model.ts`. B cần đổi `IvrAdminShared`/`ivrKitStyles` → ghi `CẦN QUYẾT`, không sửa.

## Brief chung (A và B)
1. Repo `C:\Projects\ginsengfood-business-platform`, nhánh `toandeptrai` @ `425192fec`, sửa thẳng trong checkout (D-lead-063). Không commit, không đổi nhánh, không stash/reset/restore.
   Hai tệp dở của Toàn (`.gitignore`, `docs/weekly-tracking/nguyen-quoc-toan.md`) KHÔNG đụng. Coder kia đang sửa phạm vi còn lại cùng lúc: không chạm tệp của họ.
2. Mục tiêu: mọi màn trong phạm vi dùng đúng thành phần và mẫu ui-kit-v2 như màn mẫu `/admin/products/brands`. Tiêu chí:
   (a) Phân trang: danh sách dùng `DataTable appearance="kit"` + `pagination` (chân `PaginationBar` "Hiển thị a–z trên N" + dãy trang, hàng `RowsPerPageSelect` 10/20/50 mặc định 20 ngay dưới thẻ);
       API phân trang bằng con trỏ (`page_token`, vd Cụm tên địa bàn, Tỉnh–Vùng) hoặc cỡ trang cố định (Ngoại lệ) → dùng thành phần kit gần nhất (`Pagination`/`PaginationBar`),
       KHÔNG nút "Trang n" tự chế; không làm được đúng mẫu thì `CẦN QUYẾT` kèm phương án. Không đổi API.
   (b) Không markup tự chế khi kit có thành phần: `<h3>`/`<details>`/`<dl>`/nút tự vẽ → `SectionCard`/`Accordion`/`DetailList`/`Button`/`IconButton` kit; `InlineBanner`, `Tabs`, `FilterBar`,
       `StateBadge`, `EmptyState`/`ErrorState`/`LoadingState`/`AccessDeniedState`, `ConfirmDialog`, `FeedbackDialog`, `DetailDrawer` đúng kiểu kit; màu/chữ chỉ token kit (DESIGN §15).
   (c) Bố cục theo mẫu kit "Trang danh sách" (`public/ui-kit-v2/previews/ListPage.html`): header → FilterBar → thẻ bảng; không thẻ chen giữa (quy tắc 5); cột STT, cột Thao tác icon ghim phải.
   (d) GIỮ NGUYÊN hành vi: cùng lời gọi API/hook, quyền, điều kiện khoá nút, hộp xác nhận nguy hiểm (lý do 10–500, người duyệt, gửi lại cùng mã), chữ tiếng Việt (được sửa cho khớp kit, liệt kê), route.
   (e) Kit chưa có mẫu cho một chỗ → thành phần kit gần nhất + `CẦN QUYẾT`.
3. Đọc trước: `AGENTS.md` (mục admin), `front-end/DESIGN.md` §15 "Admin: ui-kit-v2 is the only standard", `front-end/src/shared/components/COMPONENT_MAP.md` (BẮT BUỘC, nhất là hàng
   DataTable/Pagination/PaginationBar/RowsPerPageSelect), mẫu `front-end/public/ui-kit-v2/previews/*.html` (xem bằng trình duyệt: `http://localhost:3107/ui-kit-v2/previews/<Tên>.html`),
   màn mẫu `front-end/src/features/catalog/admin/components/AdminCatalogBrandsPage.tsx`, phiếu cũ `C:\Projects\Project Control\modules\m34\wp\ivr-ui-kit-v2.md` (CẦN QUYẾT cũ).
4. Ảnh trước/sau (bắt buộc): spec Playwright mới của mình giả lập API như `front-end/e2e/admin-ivr-dispatch-rules.spec.ts` (đăng nhập giả, `IVR.VIEW` + quyền ghi, dữ liệu từ
   `src/features/ivr/__tests__/response-fixtures.json`, đủ dòng để thấy phân trang, vd 45 dòng), mở từng màn trong phạm vi + một hộp thoại chính, chụp `fullPage` vào
   `C:\Projects\_wt\_luu\m34\ivr-kit-2711\<a|b>\truoc\` (trước khi sửa) và `…\sau\` (sau khi sửa); chỉ chụp khi có biến `IVR_KIT_SHOTS`. Spec có assert khung kit (không chỉ chụp).
   Next dev ĐANG CHẠY sẵn ở `http://localhost:3107` (phiên chính giữ, KHÔNG tắt, không bật server khác). Lệnh chạy:
   `cd front-end && PLAYWRIGHT_BASE_URL=http://localhost:3107 IVR_KIT_SHOTS=1 npx playwright test -c test-results/ivr-kit.local.config.ts admin-ivr-kit-<a|b> --output=C:/Projects/_wt/_luu/m34/ivr-kit-2711/<a|b>/pw`
   (Chrome của máy; KHÔNG `npx playwright install`). Tự xem ảnh (đọc tệp PNG) đối chiếu với ảnh mẫu kit chụp cùng cách.
5. Lệnh kiểm nhanh: `npx vitest run <các tệp test trong phạm vi>` · `npx tsc --noEmit -p .` (chỉ được còn lỗi sẵn ngoài IVR; ghi số trước/sau) · `npx eslint <tệp đã đổi>` · spec Playwright của mình.
   Vùng Nguy hiểm: không (chỉ giao diện; hành vi nút nguy hiểm giữ nguyên, test hiện có phải xanh). KHÔNG chạy: vitest toàn bộ, `npm run build`, e2e khác, mọi thứ chạm .99/M8 thật.
6. Bằng chứng: bảng "Kit check" từng màn (thành phần kit đã theo, lệch còn lại hoặc `none`) · danh sách thay đổi chữ · test đổi (không xoá ý kiểm) · số vitest trước/sau · đường dẫn ảnh trước/sau ·
   grep chứng minh không còn phân trang tự chế/`<details>`/`<h3>` tự vẽ trong phạm vi · `CẦN QUYẾT`. Báo cáo dài: `C:\Projects\_wt\_luu\m34\ivr-kit-2711\<a|b>\bao-cao.md`.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`.
8. Đầu ra ≤ 25 dòng theo LUAT_SUBAGENT mục 10.

## Diễn biến
- 27/11 16:2x gộp `gitlab/dev` `662642874` vào `toandeptrai` (fast-forward, khoá `@dong-bo`, kiem_migration V416 0 lỗi); menu cấp 0 commit `425192fec`.
- 27/11 16:3x Next dev cổng 3107 (phiên chính) + cấu hình chụp ảnh `front-end/test-results/ivr-kit.local.config.ts` (Chrome máy; e2e dispatch-rules có sẵn 3/3 xanh). Giao coder A và B.

- 27/11 16:5x coder B: ĐẠT · 5 màn B theo mẫu Trang danh sách, phân trang kit (`IvrCursorPager` mới cho API con trỏ: chân kit + `Pagination`, không bịa tổng), bỏ `<details>`/`<h3>`/nút "Trang n", Tỉnh–Vùng lọc miền bằng Tabs kit · vitest B 197 → 204 · Playwright kit-b trên mã cũ 5/5 đỏ, mới 5 đạt.
- 27/11 17:0x coder A: ĐẠT · Kênh gọi 20/trang, Ngoại lệ 10/20/50 (trước cố định 25), Danh sách xác nhận gọn trong thẻ (trước cột Thao tác che 2 cột), thẻ chen giữa lọc–bảng dời lên đầu, chi tiết theo mẫu Chi tiết đơn hàng, `IvrUsageMeter`, panel trang đơn nhánh default giữ nguyên · vitest A 154 → 158 · Playwright kit-a trên mã cũ 2/10 đỏ, mới 10/10.
- 27/11 17:0x ghép (phiên chính): 4 `<progress>` của B → `IvrUsageMeter` của A · vitest ivr + admin components + order-ivr 45 tệp 686/686 · tsc 2 lỗi sẵn `.next/types` · eslint 0 · Playwright kit-a + kit-b + dispatch-rules 18 đạt 1 bỏ qua → commit `d996fdd70`; Sheet: dòng mới M3 "Quản trị IVR: menu cấp 0 + rà 12 màn theo ui-kit-v2" Chờ review (hàng 222).
- 27/11 17:1x phiên chính xem ảnh: Cụm tên địa bàn còn 2 cột (Lượt dùng, Thời lượng) nằm dưới cột Thao tác ghim, Giọng đọc cột "Bước gần nhất" tràn → gộp Miền/Giọng, cho xuống dòng → ảnh đủ cột · vitest ivr 439/439 → commit `ef296ce59`. Next dev 3107 đã tắt, cấu hình tạm đã xoá.

- 27/11 17:1x Toàn "138 139 ok" → D-m34-118 (Ngoại lệ 10/20/50, đã có) + D-m34-119: Luật gọi, Giọng đọc mở trình soạn thay chỗ danh sách, nút "Về danh sách" (`IvrBackToListButton`) hỏi khi còn thay đổi chưa lưu · vitest ivr + admin 672/672 (+2 ca) · Playwright 2/2, ảnh `…\ivr-kit-2711\d119\sau\` → commit `4e5d26aee`; Sheet M3-221 cập nhật.

- 27/11 17:2x Toàn "Đồng bộ dev": `gitlab/dev` `662642874` đã là tổ tiên (không gộp) · kiem_migration V416 0 lỗi, docker_tests --check đủ 531 · `npm run build` XANH (13 trang `/admin/ivr`) · quét dòng thêm: chỉ token giả trong e2e · `git push gitlab toandeptrai:dev` `662642874..4e5d26aee`, gương GitHub `dev` = `4e5d26aee`. CHƯA CHẠY: vitest toàn FE, bộ BE (không đổi BE).

- 27/11 19:0x Toàn "140 b" (D-m34-120, ngoại lệ một lần D-lead-060): `trien-khai.sh 12cae1799` dừng ở [1/5] (commit chỉ tài liệu, không có ảnh; chưa đổi gì) → `trien-khai.sh 4e5d26aee` (ảnh be+fe có; mã back-end/front-end giống hệt `12cae1799`): sao lưu `truoc-trien-khai-20261127T121501Z-4e5d26ae.dump`, xong 12:15:48Z; be/fe/nginx healthy, `compose.cong-khai.yml` giữ, `/admin/ivr`, `/call-jobs`, `/phrases` 200 qua LAN, `https://ginsengfood.vn/admin/ivr` 200, chunk JS có "Tổng quan IVR", be 0 lỗi 10 phút. Lùi: `trien-khai.sh 662642874614dff9b80a8d67557687d0c7252df9`.

## Bước kế tiếp chính xác
Toàn đăng nhập `/admin/ivr` trên .99 xem trên dữ liệu thật; báo Phúc .99 đang chạy `4e5d26aee` (lượt sau của Phúc lấy từ `dev`).

## Còn lại / CẦN QUYẾT
- Kiểm bằng mắt trên dữ liệu thật: CHƯA CHẠY (cần BE + đăng nhập; Toàn xem sau khi Phúc lên .99). Biểu tượng trong ảnh hiện thành chữ vì spec chặn font ngoài (không do gói).
- m34.138, m34.139: Toàn chốt 27/11 (D-m34-118, D-m34-119), đã làm.
- Đã chọn mặc định, không hỏi (ghi để biết): API con trỏ giữ cỡ trang 50 cố định, chân "Hiển thị a–b, còn trang sau"; tab Danh sách xác nhận đứng trên thanh lọc (mỗi tab lọc riêng);
  chi tiết xác nhận 2 thẻ một hàng + bảng rộng; thẻ "Điều khiển an toàn" ở dưới hai bảng Giám sát; Tỉnh–Vùng cột Chọn trước STT (mẫu kit); `IvrUsageMeter` tạm trong `IvrAdminShared` (kit chưa có thanh mức);
  `Accordion` chưa có kiểu kit → nút kit mở/đóng; ô `datetime-local` ở hai phần mô phỏng để lượt sau (đổi sang `TemporalPicker` thêm giây vào định dạng gửi API).
- Việc nhỏ lượt sau: thêm prop `actions` cho `IvrPageShell` để đưa "Đặt cả bộ" (Giọng đọc) và "Tạo bản nháp" (Luật gọi) lên đầu trang.
