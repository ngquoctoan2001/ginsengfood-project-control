# ivr-ui-kit-v2 — quản trị IVR `/admin/ivr/**` theo chuẩn ui-kit-v2

Trạng thái: ĐẠT (verifier 2 vòng + bộ đủ FE + Toàn xem bằng mắt "Ổn" 17/11 10:5x; PR #164 gộp sau deploy .99) · Rủi ro: R2 (đổi giao diện màn quản trị có thao tác nguy hiểm; giữ nguyên hành vi, quyền, API) · Chế độ: A (worktree tách rời → patch → phiên chính áp + commit `toandeptrai`) · Mốc: trước 30/11 (không chặn deploy .99 chiều 17/11)
Hạng mục nâng: quản trị IVR (M3 → M8) từ kiểu admin cũ → đúng chuẩn thiết kế duy nhất của admin (ui-kit-v2, chủ dự án chốt 03/11) · Sheet: M3-197 · Ước lượng: 0,5–1 ngày AI
Chỗ làm: `C:\Projects\_wt\m34\ivr-ui-kit` (HEAD tách `3627ce4f0` = `dev` = `toandeptrai`; `front-end/node_modules` là junction tới checkout chính — KHÔNG xoá, KHÔNG `npm install`) · Patch: `C:\Projects\_wt\m34\ivr-ui-kit.patch`
Nguồn: Toàn 17/11 08:3x "sửa giao diện của quản trị IVR /admin/ivr và các trang chi tiết bên trong nó theo chuẩn ui-kit-v2".

## Hiện trạng
- 8 trang: `front-end/src/app/admin/ivr/page.tsx`, `call-jobs/page.tsx`, `call-jobs/[ivrCallJobId]/page.tsx`, `operations`, `channels`, `reviews`, `reports`, `configuration` (mỗi trang chỉ gọi một component).
- Component ở `front-end/src/features/ivr/admin/components/` (~1.000 dòng): `IvrAdminShared.tsx` (khung trang, nav, nút/ô nhập tự viết `ivrButtonClassName`/`ivrInputClassName` màu cũ `primary`/`outline`/`surface-*`), `IvrOverviewPage`, `IvrRequestsPage`,
  `IvrJobDetailPage`, `IvrOperationsScreen`, `IvrChannelsScreen`, `IvrReviewsPage`, `IvrReportsScreen`, `IvrConfigurationScreen`, `IvrAuditPanel`. Không chỗ nào dùng `appearance="kit"`.
- `IvrOrderConfirmationPanel.tsx` nằm trên trang đơn M3, không thuộc `/admin/ivr/**` → NGOÀI phạm vi (chỉ sửa nếu bị kéo theo vì dùng chung `IvrAdminShared`, ghi rõ).
- Test: `front-end/src/features/ivr/__tests__/*` (14 tệp), `front-end/src/features/order/__tests__/order-ivr-*.test.ts(x)`.

## Brief
1. Repo `C:\Projects\ginsengfood-business-platform` (CHỈ ĐỌC) · làm trong `C:\Projects\_wt\m34\ivr-ui-kit` (HEAD tách `3627ce4f0`). Không commit, không push, không đổi nhánh.
   Luật repo: đọc `AGENTS.md` mục admin (dòng ~40–70), `front-end/DESIGN.md` §15 "Admin: ui-kit-v2 is the only standard" (quyết định chủ dự án (1)–(8) và tiếp theo),
   `front-end/src/shared/components/COMPONENT_MAP.md` (BẮT BUỘC đọc trước khi sửa UI; quy tắc 12), `.github/instructions/40-ui-consistency`, `45-design-system`, `50-state-feedback`.
   Kit sống: registry `front-end/src/app/admin/ui-kit-v2/uiKitV2Items.ts`, mẫu `front-end/public/ui-kit-v2/previews/*.html`, token `front-end/src/app/ui-kit-v2-tokens.css`.
   Màn mẫu đã theo kit để bắt chước: `/admin/products/brands` (`front-end/src/app/admin/products/brands/page.tsx` + `front-end/src/features/catalog/admin/**`).
2. Mục tiêu và tiêu chí đạt (mỗi trang trong `/admin/ivr/**`):
   (a) Khung: `AdminPageLayout` + `PageHeader` (breadcrumb bắt đầu từ nhóm sidebar, không có gốc "Admin"; nút tải lại ở header bằng `IconButton appearance="kit"` `md`), độ rộng theo AGENTS (danh sách full, chi tiết lý do rõ).
       Thanh điều hướng con IVR (`IVR_NAV`) dựng bằng thành phần kit tương ứng (tab/segmented theo kit); không markup tự chế.
   (b) Thành phần: chỉ dùng `@/shared/components` với kiểu kit — `Button`, `TextInput`, `SelectInput` (không `<select>` gốc), `FormField tone="kit"`, `StateBadge appearance="kit"`, `SectionCard appearance="kit"`,
       `StatSummaryStrip`/`StatList appearance="kit"`, `FilterBar appearance="kit" autoApply` + `DataTable appearance="kit"` + `PaginationBar`/`RowsPerPageSelect` cho trang danh sách (cột `STT` theo (8)),
       `DetailDrawer`/`DetailSection`/`DetailList`/`DetailRow` cho chi tiết, `ConfirmDialog appearance="kit"` cho thao tác nguy hiểm, `FeedbackDialog appearance="kit"` cho kết quả thao tác (không `useSnackbar`),
       `LoadingState`/`EmptyState`/`ErrorState appearance="kit"` (tách "chưa có bản ghi" với "lọc không khớp"), `AccessDeniedState appearance="kit"`, `InlineBanner`, `ActionBar`. Bỏ `ivrButtonClassName`, `ivrInputClassName`.
   (c) Màu và chữ: chỉ token kit (`bg-(--brand-primary)`, `text-(color:--text-primary)`…), không mã màu rời, không lớp màu cũ (`primary`, `on-surface`, `outline`, `surface-*`, `admin-*`, `text-error`); cỡ chữ theo kit
       (12px chỉ cho chú thích phụ). Bảng nhãn/giá trị (`<dl>` tự viết) chuyển sang `DetailList`/`DetailRow` hoặc `StatList`.
   (d) GIỮ NGUYÊN hành vi: cùng lời gọi API/hook (`ivrAdminApi`, `useIvrAdminRead`, `useIvrAdminAction`), cùng quyền và điều kiện bật/tắt nút, cùng hộp xác nhận nguy hiểm (lý do, người duyệt), cùng chữ tiếng Việt
       (được sửa câu cho khớp kit nếu cần, liệt kê), cùng route. Không sửa `api.ts`, `hooks.ts`, `types.ts`, `ivrOperationsModel.ts` trừ khi cần để hiển thị (ghi lý do).
   (e) Kit chưa có quy định cho một chỗ (ví dụ timeline sự kiện cuộc gọi, khối cấu hình đã biên dịch): KHÔNG tự chế kiểu mới — dùng thành phần kit gần nhất và ghi `CẦN QUYẾT` (chỗ, phương án đề xuất).
   (f) Test: test có sẵn trong `src/features/ivr/__tests__` và `src/features/order/__tests__/order-ivr-*` phải xanh. Test bám markup/lớp cũ thì sửa sang tương đương kit, KHÔNG xoá ý kiểm (liệt kê từng chỗ đổi).
       Thêm ít nhất 1 test mỗi trang kiểm khung kit (PageHeader + thành phần kit chính, ví dụ `DataTable` kiểu kit có cột STT ở danh sách xác nhận; `FeedbackDialog` sau thao tác ở màn giám sát).
3. Phạm vi ghi: `front-end/src/app/admin/ivr/**`, `front-end/src/features/ivr/admin/**`, `front-end/src/features/ivr/__tests__/**`. Chỉ đọc: `front-end/src/shared/components/**` (không sửa thành phần chung; thiếu thì `CẦN QUYẾT`),
   `api.ts`/`hooks.ts`/`types.ts`. CẤM: back-end, `deploy/**`, thành phần chung, trang ngoài `/admin/ivr/**`.
4. Đọc trước: `IvrAdminShared.tsx` (261 dòng) và từng màn IVR; màn mẫu brands; `COMPONENT_MAP.md` (234 dòng); DESIGN §15.
5. Lệnh kiểm nhanh (tầng 1–2, trong `C:\Projects\_wt\m34\ivr-ui-kit\front-end`):
   `npx vitest run src/features/ivr src/features/order/__tests__/order-ivr-presentation.test.ts src/features/order/__tests__/order-ivr-progress.test.tsx` ·
   `npx tsc --noEmit -p .` (gốc có 4 lỗi đỏ sẵn ngoài vùng IVR; không thêm lỗi) · `npx eslint src/app/admin/ivr src/features/ivr`.
   Bộ kiểm đủ — chỉ phiên chính, sau khi áp: vitest toàn FE + `npm run build` một lần.
6. Bằng chứng: patch; bảng `Kit check` từng trang (trang/thành phần kit đã theo, chỗ lệch hoặc `none`); số test trước/sau; danh sách test đã đổi; grep chứng minh không còn `ivrButtonClassName`/`ivrInputClassName`/lớp màu cũ trong `features/ivr/admin` và `app/admin/ivr`; CẦN QUYẾT.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`. Không ssh, không gọi mạng tới máy thật, không đọc `.env*`/`sheet.json`. Không chạy dev server dùng cổng 3000/3200/3202 (lab m12).
8. Đầu ra ≤ 25 dòng; báo cáo dài `C:/Projects/_wt/m34/ivr-ui-kit-bao-cao.md`.

## Diễn biến
- 17/11 08:4x tạo worktree `_wt/m34/ivr-ui-kit` (`3627ce4f0`) + junction `front-end/node_modules`, giao coder.
- 17/11 09:1x coder: ĐẠT · patch 20 tệp +695/−300 (11 component `features/ivr/admin` + `ivrOperationsModel.ts` `reportQuery` nhận giờ có giây + test; `app/admin/ivr/**` không đổi;
  `IvrOrderConfirmationPanel` bị kéo theo vì hiện trong ngăn/trang chi tiết, không trang nào khác gọi) · vitest 15 tệp 140/140 → 16 tệp 148/148 (`admin-kit-frames.test.tsx` 8 ca, đỏ trước) · tsc 4 lỗi sẵn, eslint 0
  · đổi có chủ đích: kết quả thao tác/xuất CSV vào `FeedbackDialog`; bỏ huy hiệu đếm + tiêu đề thẻ bảng; rỗng tách chưa có/lọc không khớp; Enter = Tìm kiếm
  · CẦN QUYẾT 5: (1) nav con 7 trang = liên kết kiểu nút kit (kit không có mẫu, COMPONENT_MAP cấm Tabs để chuyển trang); (2) biểu đồ đường → cột kit; (3) `autoApply` chỉ Kênh gọi (lọc máy chủ giữ nút Tìm kiếm);
  (4) cỡ trang 25 (ô 10/25/50, kit 10/20/50); (5) tiến trình lượt gọi = bảng kit, lời thoại dài = thẻ kit. Giao verifier.

- 17/11 09:4x verifier: CẦN SỬA (nhẹ) · vitest 148/148, tsc 4 sẵn, eslint 0; hành vi giữ (số lần gọi API/hook/quyền giống hệt; hộp nguy hiểm đủ lý do 10–500, khoá, gửi lại cùng mã); Kit check sạch; đột biến 3/3 bị bắt
  · LỖI: `IvrOrderConfirmationPanel` ĐANG dùng ở `/admin/orders/[orderId]` (`AdminOrderOperationsPage.tsx:3336`, trang Phúc, chưa kit) — coder ghi sai "không trang nào gọi"
  · lệch nhỏ: `IvrAdminShared.tsx:115` đè chiều cao huy hiệu kit; `IvrChannelsScreen.tsx:53` thẻ chen giữa PageHeader và FilterBar (quy tắc 5); `IvrRequestsPage.tsx:34` 10/25/50 (kit 10/20/50, chủ chốt 04/11);
    `IvrAuditPanel.tsx:43` lỗi xem nhật ký không qua FeedbackDialog (quy tắc 1); hằng `NOTE` lặp 3 tệp; chưa test STT trang 2 + tab "Cuộc gọi đã tiếp nhận".
- 17/11 09:4x m34 chốt (D-m34-066 "chốt thay"): panel trên trang đơn GIỮ KIỂU CŨ (thêm `appearance`, trang đơn không đổi — ngoài phạm vi Toàn giao, trang của Phúc, DESIGN §15 cấm chuyển kiểu kéo theo); IVR truyền kit ·
  cỡ trang danh sách xác nhận theo kit 10/20/50 mặc định 20 (Ngoại lệ giữ 25 cố định theo M8) · sửa đủ 4 lệch nhỏ + thêm 2 test · CẦN QUYẾT (1)(2)(3)(5) giữ như coder (verifier đồng ý), ghi vào câu hỏi chủ dự án. Giao lại coder.

- 17/11 10:0x coder vòng 2 sửa đủ 7 mục (panel `appearance` mặc định cũ; 10/20/50 mặc định 20; huy hiệu kit nguyên bản; Kênh gọi đúng quy tắc 5; lỗi nhật ký qua FeedbackDialog; `ivrKitStyles.ts`; test STT) → 153/153;
  verifier vòng 2 ĐẠT (so innerHTML panel cũ/mới 8 trạng thái giống hệt; đột biến mặc định panel bị bắt; hở: `IvrQueryState` mặc định) → coder vòng 2b thêm 2 ca panel đang tải/lỗi → 155/155, đột biến bị bắt.
- 17/11 10:1x phiên chính áp patch (21 tệp +833/−303) → commit `2b38de2d5` + tracking `92349290e` trên `toandeptrai` (chưa push); Sheet M3-197 Hoàn thành. Bộ đủ FE (vitest toàn bộ + `npm run build`) trong worktree `ivr-ui-kit` @ `2b38de2d5`.

- 17/11 09:5x bộ đủ FE @ `2b38de2d5`: vitest toàn bộ 9770 ca, đỏ 34 ở 6 tệp ngoài IVR → chạy riêng 4 tệp (StorefrontHeader, checkout-preview-rate-limit, collaborator-center-page, collaborator-resources) 241/241 xanh (quá giờ do tải),
  còn `proxy.test.ts` + `legal-hold-real-spec-guard` đỏ sẵn đã biết · `npm run build` trong worktree hỏng vì Turbopack từ chối junction `node_modules` (môi trường) → build trên checkout chính (cùng `92349290e`) XANH, đủ 8 route `/admin/ivr`. → ĐẠT. Worktree `ivr-ui-kit` gỡ (junction gỡ trước).

- 17/11 10:5x Toàn xem trên bản xem thử (Next dev `c95f083c8` + proxy tới BE .99, Toàn tự đăng nhập; m34 chỉ mở trang): "Ổn". Biểu tượng hiện thành chữ trên mọi trang admin ở bản dev (thiếu `@font-face` Material Symbols, không do gói) → kiểm lại trên .99. Sheet M3-197 Lead Đạt.

## Bước kế tiếp chính xác
PR #164 MỞ (D-m34-096) → gộp SAU lượt deploy .99 chiều 17/11 khi CI chỉ còn đỏ sẵn; khi bản lên .99 kiểm biểu tượng hiện đúng. Câu hỏi chủ dự án: CẦN QUYẾT (1)(2)(3)(5).

## Còn lại / CẦN QUYẾT
- Kiểm bằng mắt trên trình duyệt: CHƯA CHẠY (FE không có chế độ giả lập API; cần BE + đăng nhập) — Toàn xem trên máy sau khi lên.
- Không đưa vào lượt deploy .99 chiều 17/11 (buổi E07/E08 kiểm UI IVR trên ảnh hiện tại) trừ khi Toàn nói.
