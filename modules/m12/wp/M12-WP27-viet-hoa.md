# M12-WP27 — Việt hoá giao diện M1–M2: admin-web, chữ từ backend, dữ liệu seed, giá trị ô bảng



Trạng thái: ĐANG LÀM · Rủi ro: R2 (đổi chữ + test; seed registry/seed 21/05c chạy lại trên `.99`) · Chế độ: S · Mốc: trước nghiệm thu 27/11

Quyết định: D-m12-118 (bảng thuật ngữ) · D-m12-120 (sửa hết + rà giá trị ô bảng) · Sheet: **M12-116** (Codex tạo 19/11; Đang làm)

Chỗ làm: checkout chung `C:\Projects\ginsengfood-ops-core` (main; WP27 không stage/commit, WP28 điều phối index + commit tuần tự theo allowlist) · Chỗ kiểm: `C:\Projects\_wt\m12\kiem-WP27<phần>`

Nguồn: [bản rà chữ tiếng Anh](../ra-soat/2026-11-18-tieng-anh-ui.md) §2–§4, §7 · bản rà giá trị ô bảng (phần R, `../ra-soat/2026-11-18-gia-tri-o-bang.md`).

Phần app xưởng (§1, 29 mục) đã nằm trong WP24 (D-m12-116) — WP27 KHÔNG sửa `apps/shopfloor-pwa/**`.



## Luật chữ (áp cho mọi phần)

- Người đọc là nhân viên kho, kế toán, quản đốc, công nhân: câu ngắn, tự nhiên, đọc là hiểu việc phải làm. Không dịch từng chữ; không để từ dev

  (API, endpoint, backend, payload, token, cookie, idempotency, outbox, aggregate, metadata, enum, seed, registry, request…).

- Thuật ngữ D-m12-118: **KCS** (không QC) · **ĐVT** (không UOM) · giữ **offline/online** · giữ **Check-in/Check-out** · **Cấp 1/Cấp 2** (không L1/L2) ·

  **mẻ** (mẻ sản xuất) / **lô** (lô nguyên liệu, lô thành phẩm) · mã lỗi để **cuối câu "(mã: …)"** · giữ viết tắt ngành QR, SKU, GTIN/EAN-13, MRP, FEFO,

  MISA/AMIS, CAPA, COA, NSX/HSD/NCC, JSON, PDF, OTP; bỏ chữ "PWA" khỏi câu (nói "app xưởng").

- D-m12-120: giữ từ đặc thù đã quen, dịch ra thấy kì thì giữ — **"mail"** (không "thư điện tử"), "menu", "tab", "Excel", "QR". Bản rà cũ ghi "thư điện tử" ⇒ đổi "mail".

- Mã trạng thái/loại/enum KHÔNG hiện thô: mọi giá trị có nhãn Việt; thiếu nhãn ⇒ "Khác (<mã>)" chứ không in mã trần. Nhãn trạng thái ngắn (2–4 chữ).

- Dữ liệu người dùng tự nhập (tên, ghi chú) không đụng. Tên riêng (SKU tiếng Anh `sku_name_en`, tên phường/xã) không đổi.



## Phần

| Phần | Ai | Phạm vi ghi | Trạng thái |

|---|---|---|---|

| R | agent chỉ đọc | rà mọi cột bảng/ô chi tiết admin-web hiện mã/enum/tiếng Anh + giá trị thật trong DB (lab, `.99` chỉ đọc nếu được) → `ra-soat/2026-11-18-gia-tri-o-bang.md` | ĐANG LÀM |

| A | coder A | backend + seed: bản rà §3 (câu chặn quét, validator tạo NCC, `ApprovalMappings`, câu cảnh báo, máy in, FluentValidation `vi`, câu toàn vẹn kiểm toán, truy xuất công khai) + §4/§7.1 seed (tên màn hình, tên thao tác, mô tả vai, bước kiểm thử nhanh seed 21, mô tả cấu hình 05c, `tao-db-production-sach.sh`) + manifest/profile/allowlist | ĐANG LÀM |

| B, C | 2 coder admin-web (chia theo thư mục `features/**`, `src/lib/**` chỉ một coder) | bản rà §2.1–2.4 + toàn bộ giá trị ô bảng phần R | chờ R |

| D | Toàn duyệt riêng | `.99`: tên 2 kho + 4 vị trí (sửa qua giao diện Danh mục kho hoặc UPDATE 6 dòng), máy in thử "DEV TEST ONLY…" tắt/đổi tên | chờ quyết |



Vùng KHÔNG chạm (phiên khác): `apps/shopfloor-pwa/**`, `packages/ui/**`, `packages/design-tokens/**`, `apps/admin-web/src/components/{ui,form,layout}/**`,

`apps/admin-web/src/design/**`, `apps/admin-web/app/layout.tsx`, `features/system/screens/MobileDevices*`, `tests/frontend/shopfloor-pwa/**`,

`tests/frontend/admin-web/**/components/**` (WP24); phần đăng nhập mail WP26 (`features/auth/**`, `features/account/**` nếu WP26 đang sửa — hỏi phiên m12 chính trước);

`docs/weekly-tracking/**`, `tools/task-tracker/**`.



## Kiểm

- Kiểm nhanh (coder/verifier): test của tệp đổi + `tests/frontend/admin-web/static-guards/**` liên quan (`vietnamese-ui-text-static` nếu có) · typecheck · eslint tệp đổi ·

  phần A: build API + Unit/ApiContract/Integration lọc vùng đổi + seed ×2 + validation liên quan + Pester E07 + collision.

- Test so chữ cũ phải sửa theo chữ mới (không xoá ca); sổ tay UAT có so chữ ⇒ báo WP-UAT danh sách ca đổi kỳ vọng.

- Bộ đủ: phiên m12 chính gộp vào lần bộ đủ kế tiếp.



## Diễn biến

- 18/11 20:3x Toàn D-m12-120 ⇒ mở WP27; giao phần R (rà giá trị ô bảng) + phần A (backend + seed) song song; B/C sau R.

- 18/11 20:4x vùng: WP24 [f1e7c3] chỉ còn `apps/shopfloor-pwa/**` + test PWA (Việt hoá app xưởng đã trong WP24). WP26 backend đã commit hết; giao diện WP26 CHƯA ai làm,

  sẽ chạm `features/auth/LoginPage.tsx`, `/admin/account` (thẻ Mail công ty), `UsersRolesPage*` (cột + hộp gắn/gỡ mail), `openapi.json`/`types.ts` ⇒ WP27 sửa chữ mấy tệp đó

  SỚM, commit riêng một lượt rồi báo chủ WP26, hoặc để sau nếu WP26 đã bắt đầu. Tin cho phiên [712d59] bị giữ ⇒ thả `hop-thu/m12-2026-11-18-wp27-viet-hoa-vung-tep.md`.

- 18/11 20:5x phiên [9199d3] nhận WP26 (D-m12-121), chưa commit; vùng WP27 phải NÉ: services Auth/*, WorkEmail*, `AuthEndpoints.cs`, `UserEndpoints.cs`, `RateLimiting*`,

  `Program.cs`, `appsettings*.json`, migration `20261118100000_EAuthWorkEmailLogin*` + snapshot + inventory, `Validate-P01Schema.ps1`, `packages/**`, 2 `generated/types.ts`

  (không `api:sync`), admin-web `features/auth/**`, `features/account/**`, `UsersRolesPage.User*.tsx`, `UsersRolesPage.tsx`, `UsersRolesPage.WorkEmail*`, `lib/api/hooks/auth*`,

  `*work-email*`, `lib/ui/status-maps/system.ts`, test login/account/users-roles. Chữ cần Việt hoá trong các tệp đó ⇒ gửi danh sách cho [9199d3] gộp vào WP26. Đã báo coder A.

  WP26 nhận làm: `AccountIdentityHeader.tsx:80`, `status-maps/system.ts:20`, `UsersRolesPage.UserDialogs.tsx` (§2.3 + §2.4:389), `UsersTab.tsx:149`, `UsersRolesPage.tsx:82`.

  WP27 tự sửa: `UsersRolesPage.RolesTab.tsx:251,256`, `UserSessionsDialog.tsx:49`. Thêm vùng WP26 (né tới khi WP26 báo commit): `apps/admin-web/src/lib/api/client.ts`,

  `apps/admin-web/src/components/app/AuthProvider.tsx`.

- 18/11 21:xx phần R XONG: `ra-soat/2026-11-18-gia-tri-o-bang.md` (317 dòng; DB `.99` đọc được, READ ONLY, 554 cột mã/enum): 59 màn + ~25 trang chi tiết + 7 màn cổng NCC,

  ~280 cột/ô còn mã thô/tiếng Anh; nhật ký kiểm toán: 30 loại đối tượng thiếu nhãn (15 có trên `.99`), 68/104 loại sự kiện ra câu lẫn Anh, 25 cặp trạng thái "Không rõ";

  SKU 19/22 "Baseline đang hoạt động", tab Công thức "Không rõ: ACTIVE_OPERATIONAL" (bảng nhãn nhầm); Lý do & cấu hình gần như mọi cột mã thô; 4 lỗi nặng: MISA khoá

  lệch, MRP 2 bảng nhãn sai bộ mã, tồn NL cột Nhóm, Tổng quan "API_PROCESS". Chia: B giữ `src/lib/**` + bước 0 nền (`lib/ui/value-labels/`, dự phòng "Khác (<mã>)",

  status-maps, mã lỗi cuối câu) rồi màn hệ thống/dữ liệu chính/SKU/tích hợp/MISA/cảnh báo/tổng quan/toàn vẹn/NCC/cổng NCC; C (sau bước 0) phiếu vận hành, MRP, điều kiện

  bán, công thức, nguồn NL, NVL, tồn NL, SX, đóng gói, KCS, kho TP, tồn kho, truy vết, thu hồi. Giao coder B bước 0. Hỏi Toàn m12.161 (Lô sản xuất → Mẻ sản xuất,

  Phát hành lô → Phát hành mẻ, cả menu), m12.162 (SKU gốc: "Đang hoạt động (SKU gốc)" — làm theo đề xuất, Toàn đổi được).

- 18/11 21:xx WP26 chuyển 2 việc: guard `tools/audit/ui-language-rules.mjs` chặn "Mail" đứng một mình + mẫu "ten@…" ⇒ thêm vào bước 0 của B (cho phép mail + từ giữ nguyên);

  `UsersRolesPage.shared.ts` `ACTION_TOKEN_LABELS` (module/action, admin, audit, batch, lot…) ⇒ B bước màn hệ thống. "Thư điện tử" còn ở màn NCC (WP27) và app xưởng (đã báo WP24).

- 18/11 21:xx WP24 đổi "thư điện tử" → "mail" ở app xưởng (`07abba8d4`). Toàn "Đổi sang mẻ" ⇒ **D-m12-122**: batch sản xuất = "mẻ" kể cả menu ("Phát hành mẻ");

  m12.162 làm theo đề xuất ("Đang hoạt động (SKU gốc)"). Menu "Phát hành lô" → "Phát hành mẻ" giao coder A một lượt (admin-menu.tsx:315 + seed 48 + JSON + validation/test);

  coder B đổi trong `lib/**` (không đụng admin-menu.tsx); B/C đổi trong `features/**` ở bước màn.

- 18/11 22:0x coder A CHƯA XONG (chưa commit): mã + seed + manifest xong — backend 6 validator + câu chặn quét (tệp mới `MobileScanBlockerText.cs`) + ApprovalMappings

  (ngày dd/MM/yyyy) + PublicTrace + toàn vẹn kiểm toán 13 câu + máy in/cảnh báo + FluentValidation vi ở `AddApplicationPipelineServices` (tệp mới

  `Behaviors/VietnameseValidationMessages.cs`, không đụng Program.cs); seed 02,05,05a,05c,06,14–22,25,27–29,42,48 (tên màn hình 92/106, thao tác 287/304, mô tả vai 16,

  cấu hình 6, bước smoke 14, kho 2 + vị trí 4) + "Phát hành mẻ" ở menu (admin-menu.tsx + JSON + 42/48); manifest `c1c1b826…`, sourceSet `bd30f8c5…`; test mới 4 lớp

  (22 ca đỏ trên mã cũ). Kiểm: build 0/0, Unit lọc 117/117, schema-smoke seed 122/122, vitest navigation 59/59, Gov 1105/1108 (3 đỏ ngoài A: WP24 P17/D2, WP26

  `AuthEndpoints.Map`), seed 61×2 + bộ production 42×2 + validation 54/54, Pester E07 5/5, collision PASS 124. **CHƯA CHẠY lại:** Integration (15/15 trước khi đổi "mẻ")

  + ApiContract PublicTrace (4 đỏ đúng lúc ổ C: đầy 0 MB + Docker Desktop hỏng). Chuyển WP26: `SupplierAuthRequestValidators.cs:21,26,46,50,53`,

  `InternalUserRequestValidators.cs:45,56`. Chuyển WP-UAT: catalog ~360 tên màn/thao tác cũ, 68+17 dòng tên kho/vị trí, 822 dòng "Phát hành lô". Chưa đổi tên phiếu

  "Phiếu phát hành lô" (seed 21, `FormNameBatchRelease`, validation 21) — để coder A vòng 2. Rủi ro `.99`: 05c ghi đè `config_value` + `status` 6 khoá; mô tả vai cần

  UPDATE riêng (02 `DO NOTHING`); 05a không thuộc bộ production ⇒ phần D.

- 18/11 22:1x WP24 [f1e7c3] mở WP28 rà bố cục (chờ Toàn duyệt); đợt 1 WP28 sửa `features/**` admin SAU khi WP27 commit phần `features/**` ⇒ báo [f1e7c3] khi xong.

  Thêm đầu vào cho B/C: lỗi chữ/mã lộ (L11) + câu khó hiểu (L14) theo màn ở `ra-soat/2026-11-18-ui-bo-cuc/xem-anh-A.md`, `xem-anh-B.md` (grep `[L11|`, `[L14|`;

  ~115 + ~117 mục), máy đo `gom-admin.md` mục CHU_LAI_TIENG_ANH / MA_KY_THUAT_LO: tên kho/vị trí tiếng Anh (dữ liệu, >15 màn — phần D), enum lộ (ACTIVE, PASS,

  PENDING, CALCULATED, *_LOG), "Không rõ: <MÃ>", JSON thô có `\u00..`, `&laquo;` ở trạng thái trống NCC, cột "Tên màn hình" (seed phần A). Số câu hỏi fork: m12.163–169.

- 18/11 22:09 ổ C: còn 20 GB (96%), Docker Desktop "unable to start", có tiến trình Docker Desktop mới mở 22:02 (không do phiên này) ⇒ chờ Docker lên rồi chạy lại phần A. Giá trị ô bảng mới trong vùng WP26 ⇒ gửi [9199d3] (đã commit thì trả vùng cho WP27).



- 18/11 22:4x coder B bước 0 CHƯA XONG hẳn (mã xong, chưa commit): `lib/ui/other-label.ts`, `lib/ui/value-labels/**` (85 kind: audit_event_type 501, audit_object_type 118+33,

  module_code 20…), `status-maps/reporting.ts` mới + 11 status-maps, api-error mã cuối câu, client-errors cổng phiếu, `tools/audit/ui-language-rules.mjs` (cho phép mail…),

  `docs/standards/ui-vietnamese-glossary.md`; 4 test gác mới (đỏ trên mã cũ); sửa 32 test so chữ. Kiểm: 194 tệp 1822 đạt / 4 đỏ (TopNavigation.test vùng WP24 chờ

  "QA phát hành mẻ"; users-roles-create-user-dialog.test vùng WP26 chờ "KCS nguyên liệu"; form-sheet-data-codes + QcReleaseScreens do `formCatalog.ts` đang đổi "Phiếu phát

  hành mẻ"), tsc 0, eslint 0. Gửi WP26: `status-maps/system.ts:134` "Đã tắt", `:135` "Đến hạn đổi khoá", `:79` RECOVERED "Đã thu về". Coder C còn thiếu: tên trường nháp nhập

  SKU, 5 câu lý do cảnh báo tồn, mã vai/bộ phận FRM-15/16, `scopeAction` lý do (lấy từ seed 06).

- 18/11 22:4x HẾT HẠN MỨC phiên ⇒ dừng giao việc mới. Coder A vòng 2 (chạy lại test DB + "Phiếu phát hành mẻ" + 2 validator mật khẩu) có thể còn đang chạy.



- 18/11 23:xx coder A vòng 2 XONG tự kiểm (chưa commit): "Phiếu phát hành mẻ" (`OperationalFormFlowCatalog.cs` `FormNameBatchRelease`, seed 21:439, validation 21:221,

  fixture `QcBatchReleaseWorkflowIntegrationTests.cs:2885`, 3 câu backend "phát hành lô", `formCatalog.ts:53` + 7 test admin-web vì `FormFlowMapParitySmokeTests`);

  `SupplierAuthRequestValidators.cs` 6 câu + `InternalUserRequestValidators.cs` 2 câu (luật giữ nguyên). Kiểm: build 0/0, Unit lọc 276/276, schema-smoke lọc 148/148,

  Integration lọc 189/189, ApiContract lọc 107/107 (DB thật, không skip), vitest tên phiếu 240/241 (đỏ `form-sheet-data-codes.test.tsx:485` — tệp đang dở của coder B),

  Gov 1107/1109 (2 đỏ ngoài A: WP26 `AuthEndpoints.Map`, WP24 chú thích FRM-15). Manifest `d9b1fbf4…`, sourceSet `c9c7c3b5…`. CHƯA CHẠY: validation 21 trên Postgres

  thật, chuỗi seed đủ sau vòng 2, Pester E07. Đã xoá `.artifacts/dotnet/WP27A` + `wp27a-pg`. Còn "lô" cho B/C: `FinishedGoodsQcReleaseAction.tsx`,

  `FinishedGoodsQcLinesEditor.tsx`, `BatchReleaseDrawer.tsx`. Docker: phiên [9199d3] `docker desktop restart` 22:2x; ổ C: ~18 GB.



- 19/11 06:5x phiên chính sửa 4 kỳ vọng test (TopNavigation "QA phát hành mẻ", form-sheet-data-codes "Phiếu phát hành mẻ", users-roles-create-user-dialog "KCS nguyên liệu",

  status-label-single-source) + 3 nhãn `status-maps/system.ts` (79 "Đã thu về", 134 "Đã tắt", 135 "Đến hạn đổi khoá"; WP26 đã commit `2c292fb82` nên vùng trả lại).

  Áp A + bước 0 B (135 mục) vào `_wt/m12/kiem-WP27AB` @ `cbefa98b3`, giao verifier (gồm seed đủ ×2, validation 21, Pester E07 còn thiếu). Song song: B bước màn nhóm B

  (gồm UsersRolesPage*, auth/account chỉ chữ, not-found.tsx), C bước màn nhóm C (cấm tạm formCatalog.ts + 8 test phần A tới khi A commit). Kế hoạch commit: A commit theo

  đường dẫn ngay khi verifier ĐẠT (services/db/deploy/test backend + admin-menu.tsx + nav test + formCatalog.ts + 8 test); B (bước 0 + màn) và C commit sau verifier của chúng.



- 19/11 07:0x WP26 trả vùng (đợt 2 đã commit); sáng nay WP26 chỉ giữ `Api/Endpoints/AuthEndpoints.cs`, migration mới + snapshot + `20261118100000_EAuthWorkEmailLogin.cs`

  + inventory, `Validate-P01Schema.ps1`, `features/auth/EmailLoginForm.tsx`, `features/auth/workEmail.errors.ts`, `client-email-login-401.test.ts`, test `*WorkEmail*` ⇒ đã báo B né.

  Docker dừng lại ~06:41, WP26 restart 06:5x.

- 19/11 07:2x WP26 commit `a07ade986` (vòng sửa 2) ⇒ trả HẾT vùng. Không trùng tệp nào với bộ A/B đang kiểm (so `git diff --name-only cbefa98b3 HEAD`).

  Đã giao B rà 2 tệp `features/auth/*` + 3 test auth; backend `AuthEndpoints.cs`/`WorkEmail/*` không đụng (đã tiếng Việt). WP26 còn verifier R3 cuối, sẽ báo trước nếu chạm lại.

- 19/11 08:0x verifier A + bước 0 B: **CẦN SỬA**. Đạt: seed (đủ 61 ×2, production 42 ×2, validation 79/79, profile 53/53 + boundary, `sha256sum -c` 48/48,

  manifest `d9b1fbf4…`/sourceSet `c9c7c3b5…` tự tính khớp, Pester E07 5/5, LOW 124), không đổi hành vi (0 chuỗi mã đổi; ApprovalMappings giờ +7), build 0,

  Integration lọc 184/184, static-guards 835/835, tsc app 0. Đột biến 9/10 đỏ; SỐNG: seed 05 'Nhật ký kiểm toán' → 'Audit Log' chỉ đỏ checksum.

  Sửa: 2 test backend so chữ cũ (RawIntake unit :159/162, ApiContract :56), gác tên màn/thao tác có dấu Việt, ApprovalMappings :174/187 "Phát hành mẻ"/"Thu hồi phát hành mẻ",

  BatchReleaseConfirmGuards :181 mã cuối câu, Recorder :56 lộ `op_batch_release`, seed 25:87 "bảng kiểm KCS", FRM-20 "Phiếu KCS thành phẩm" ⇒ **coder A2** (seed + backend).

  Test QcReleaseScreens/smokeRun/pilot-gate: checkout đã sửa (C + phiên chính). TS7016 test guard `.mjs` ⇒ B. FE FRM-20 + "owner" ⇒ C (formCatalog + 8 test sau khi A commit).

  Chữ "owner": chọn **"Ban giám đốc"** (bỏ "chủ hệ thống" vì dễ hiểu là người quản trị máy) — status-maps/value-labels/sellable ⇒ B, màn ⇒ C, glossary ⇒ B.

  Rủi ro chạy lại seed trên .99 (cho phần D): bộ production ghi lại MỌI upsert 42 tệp; 05c ghi đè `config_value`+`status` 6 khoá (`misa.test_mode`, `public_trace.enabled_fields`…)

  ⇒ đọc giá trị .99 trước; mô tả vai seed 02 `DO NOTHING` ⇒ cần UPDATE riêng; 05a ngoài bộ production; phiếu FRM-21 đã lập giữ tên cũ. Đề xuất: phát lại trên bản sao .99, so vân tay từng cột rồi mới chạy thật.

- 19/11 08:1x WP28 [f1e7c3] commit `f9662ad23` (component chung + guard ratchet `wp28-component-ratchet-static` đếm table/input/select/button/fontSize theo tệp, chỉ giảm), `cff9ac58d`, `bb7f52267`; không đụng tệp WP27. Đã báo B/C chạy guard.

  Hẹn WP28: `a11y/` lấy ngay; nhóm B commit ~11:00–11:30, nhóm C ~12:00–13:00 (ước tính), commit xong nhắn SHA.

- 19/11 09:2x coder B xong bước màn nhóm B (~28 màn, 78 tệp features + lib: kind `sku_import_field`, `permission_action`, HTTP_xxx outbox, `actionCodeLabel`,

  `menuLabelForRoute`, hook `useActionNameLabels`, `lib/utils/json-display.ts`, trang 404). Test mới `wp27-group-b-cell-labels` 24 ca + 8 ca audit-log; vitest 257 tệp 2304 đạt / 16 đỏ

  (đều nhóm C đang dở), tsc 0, eslint 0, ratchet WP28 11/11, máy quét chữ REVIEW 0. TS7016 sửa bằng `tools/audit/ui-language-rules.d.mts`. Auth: đã tiếng Việt, không sửa.

  Luật ô bảng (chốt theo D-m12-117): **thực thể có bản ghi** (vai, SKU, NL, mẻ, NCC, kho) ⇒ tên trên mã dưới; **giá trị liệt kê** (trạng thái, loại sự kiện/đối tượng,

  lý do, điều kiện sẵn sàng) ⇒ chỉ chữ Việt, mã ở `title`/CSV. B sửa thêm mã điều kiện sẵn sàng SKU + ghi danh sách tệp B. Ghi chú: cột cấu hình "Chủ sở hữu" ⇒ "Phân hệ phụ trách";

  tên thao tác/màn ngoài menu chỉ ra tiếng Việt khi seed 05/06 lên .99; 4 hạng mục TC-PF04 tên do coder đặt (cần xem khi UAT).

- 19/11 09:4x **Kế hoạch commit chốt lại (3 lượt):** A = services/db/deploy/test backend + `admin-menu.tsx` + 3 test navigation/TopNavigation (sau A2 + verifier vòng 2);

  B = 174 tệp (`scratchpad/b.commit`: lib, màn nhóm B, `app/not-found.tsx`, tools/audit, glossary, 52 test B + users-roles test); C = màn nhóm C + `formCatalog.ts`

  + 19 test chung (đã hết cấm, C làm nốt FRM-20 KCS). Verifier B chạy ở `_wt/m12/kiem-WP27B` @ `bb7f52267` (178 tệp = B + 4 tệp giao diện A).

- 19/11 10:0x A2 lượt 1 xong: 2 test backend so theo trường, gác mới `UiRegistrySeedVietnameseNameStaticGuardTests` (đột biến "Audit Log" đỏ), ApprovalMappings/Guards/Recorder,

  seed 25 + seed 21 FRM-20 KCS (5 nhãn); manifest `67dc3a54…`, sourceSet giữ `c9c7c3b5…`; build 0, Unit lọc 157/157, ApiContract 5/5, Gov 1116/1120 (4 đỏ ngoài WP27: 3 WP26

  `WorkEmailIndependentR3Wave2Tests.DataAudit`, 1 WP24 FRM-15), seed 61 ×2, Pester E07 + DB13 19/19, LOW 124. Còn 2 đỏ SchemaSmoke vì `OperationalFormFlowCatalog.cs:130`

  vẫn "Phiếu QC thành phẩm" ⇒ A2 lượt 2: đổi hằng + dọn nhãn trường tiếng Anh seed 21 (FRM-14/16/19/20/22/28/29: Ledger, Lot, Log, scan inbound, hold/reject) + câu G21/G-20/G-22 mã cuối + `BatchReleaseForm.cs:129,198`.

- 19/11 08:5x cả 3 agent (A2 lượt 2, C, verifier B) dừng vì hết hạn mức tài khoản; Toàn đổi tài khoản ⇒ gọi tiếp từ chỗ dừng. Worktree `kiem-WP27B` vẫn khớp `b.verify.sha`.

- 19/11 09:0x coder C xong nhóm C (243 tệp = 175 nguồn + ~50 test + 19 test chung; `scratchpad/wp27-c-files.txt`): codemod 300 chỗ (lô→mẻ, QC→KCS, UOM→ĐVT),

  ~120 câu dev sửa tay, owner→"Ban giám đốc", FRM-20 KCS, ~65 chỗ `?? mã`→`otherLabel`, bảng nhãn MRP sai bộ mã gom về lib, mã lỗi cuối câu. Test mới

  `wp27-group-c-value-labels` (34/35 đỏ trên mã cũ) + `wp27-group-c-text-static` (433 vi phạm trên mã cũ). tsc 0/0, eslint 1 lỗi có sẵn HEAD

  (`WarehouseReceiptCreateForm.tsx:70`), vitest nhóm C 2929/2930 (1 quá giờ, chạy riêng đạt), static-guards 849/849, ratchet WP28 11/11.

  Chốt chữ SMOKE_RUN: **"kiểm tra thông chuỗi"** ("chạy thử" trùng PILOT, bỏ "kiểm thử khói") ⇒ C đổi giao diện, A2 đổi backend + seed + tên phiếu.

  A2 thêm: câu cảnh báo tồn `FinishedGoodsStockAlertEvaluator`, `OperationalFormDemandMrpBoundaryService.cs:177`, `PackagingLotFefo.cs:106,114`.

  Để sau (không chặn): gom kind `incident_type`/`form_signing_role`/`material_alert_item_type`/`operational_form_status` vào lib; `PROCESS_STEP`/`FORMULA_KIND`;

  ô gõ tay loại đối tượng/kênh liên hệ thu hồi; nút "JSONL"; L11/L14 ⇒ WP28.

- 19/11 09:1x verifier B: **CẦN SỬA (ít)**. Đạt: chữ (33 nhãn loại đối tượng + §1.1–1.4), luật ô bảng, bộ lọc gửi mã, CSV đủ mã, `useActionNameLabels` không N+1,

  tsc 0/0, quét chữ REVIEW 0/9479, static-guards 845/846 (1 đỏ do JSON phần A chưa vào worktree), B một mình không hỏng biên dịch nhóm C. Đột biến 6/10.

  Sửa: MISA thiếu 3 loại chứng từ (thu hẹp hành vi), ô chọn đóng ở MISA/Lý do & cấu hình ⇒ thêm "Mã khác…" nhập tự do; 4 test cho đột biến sống

  (nhãn value-labels qua `classifyUiText`, lọc kiểm toán gửi mã, cột mã CSV, lọc trạng thái SKU); eslint quote B3; + mức thấp (câu cảnh báo giữ ở title,

  nhãn trùng ở lọc loại sự kiện, JSON MISA gửi chuỗi gốc, "Cách lấy mẫu KCS", 404 cổng NCC). `recall-raw-code-labels` + `recipe-pilot-helpers` chuyển sang lượt B

  (`b.commit` 176). `production-admin-ui` lẫn C ⇒ lượt C ngay sau B. Giao lại B vòng 2.

- 19/11 09:3x C xong SMOKE_RUN "kiểm tra thông chuỗi" (formCatalog:60, tờ phiếu, nhãn SMOKE_PASS/FAIL/BLOCKED "Thông chuỗi đạt/không đạt/bị chặn", guard nhóm C chặn

  "kiểm thử khói"/"chạy thử toàn chuỗi"); 8 test sửa, fixture `GUARD_IMMUTABLE_RUN` đã theo câu mới (A2 phải đổi backend y hệt). Có sửa 4 tệp lib + glossary vùng B

  (đi lượt B; đã báo B đọc lại). tsc 0/0, vitest 22 tệp 321/321, static-guards 936/936, eslint 0 lỗi. `wp27-c-files.txt` 254 dòng.

  Kế tiếp: B vòng 2 + A2 lượt 2 xong ⇒ dựng worktree đủ A+B+C ⇒ verifier (A2 delta) + verifier (B vòng 2 + C) ⇒ commit A, B, C liền nhau ⇒ bộ đủ.

- 19/11 09:5x B vòng 2 xong: MISA đủ 8 loại chứng từ; ô `VocabularyCodeField` ("Mã khác…" gõ mã tự do) ở 9 chỗ Lý do & cấu hình + 3 ô MISA; 4 test đột biến sống

  (M4 bắt thêm "Thùng carton"→"Thùng", "Video" vào từ giữ); 404 tách `not-found-home-link.tsx`; tsc 0/0, vitest 160 tệp 1253/1253, ratchet 11/11.

  Danh sách chốt: lượt B `scratchpad/b.commit2` 179 tệp (gồm `value-labels/catalog.ts` + glossary C có sửa), lượt C `c.commit` 250 tệp (gồm `formCatalog.ts`).

  Không tệp nào bị 4 commit mới của WP26/WP28 (`ba6f50273`, `5ddf06a01`, `6354ab1c0`, `136a64713`) đụng. Verifier (B vòng 2 + C) ở `_wt/m12/kiem-WP27BC` @ `136a64713` (434 tệp).



## Tiếp quản Codex 19/11 — đã ghép commit, chờ gate đủ

- Toàn xác nhận dừng cả ba Claude và agent con tại chat WP28; tiếp tục trực tiếp tại chat WP27. Điểm dừng Claude: A2 và verifier B2+C bị rate-limit 09:17, không có kết luận cuối.
- Bản nguồn kiểm riêng không phải worktree/nhánh: `C:/Projects/_wt/m12/wp27-codex-1911`, chụp main `937cbd989` + WIP, manifest 8.879 tệp; loại tệp môi trường/bí mật/Sheet. Mọi số dưới là Codex chạy mới trên bản WIP này, không phải CI/exact-SHA hay nghiệm thu production.
- Unit backend A/A2 + cảnh báo/kiểm toán/máy in: 525/525 đạt. SchemaSmoke lọc: 87 đạt, 1 chặn vì snapshot không mang `.env.example` (đã kiểm riêng phần marker nhạy cảm seed MISA, không nhận toàn ca đạt). Governance lọc: 36 đạt/1 đỏ D2 do comment PWA FRM-15; WP28 đã sửa (1a0641dbc), WP26 kiểm lại D2 đạt 1/1; raw TRX đã đối chiếu.
- Migration DB tạm 156; full seed 61×2 + validation79/79; production subset42×2 + profile53/53 + boundary; manifest48/48; Pester E07+DB13 30/30; collision gate đạt. Bộ production fingerprint 1799/1799 ổn định (loại timestamp/UUID/date). Full-chain chỉ lệch `misa_mapping.mapping_payload`; fixture13/27a không đổi HEAD và có retiredAt=NOW — không gọi raw equality toàn DB. Container DB riêng đã dọn.
- Audit seed độc lập: 27 tệp/603 literal chỉ chữ, không đổi enum/khóa/điều kiện SQL. Frontend 231 tệp/2391 test đạt; typecheck app/tests (gồm test SKU mới) đạt. M4/M5/M7/M9 đều bị bắt; M9 cần bổ sung test render Select thật vì test constant cũ không bắt được. ESLint còn một lỗi đã có trên HEAD ở WarehouseReceiptCreateForm.tsx:70, chưa coi toàn lint xanh.
- Bằng chứng đang ghi: `C:/Users/Administrator/AppData/Local/Temp/codex-tiep-quan-m12-20261119/WP27-evidence/`. Allowlist: A88/B181/C250 đều READY. API56/56 và integration4/4 đã đạt, không skip; đã chuyển WP28 ghép A→B→C. B thêm comment-only misa-mapping-validation.test.ts và test SKU mới. Đủ 519 hash khớp main 120b2ea7e, không trùng danh sách; WP28 giữ index.

## Bước kế tiếp chính xác

1. API56, Integration4, D2 peer1, frontend2391, typecheck và đột biến M4/M5/M7/M9+seed05 đã hoàn tất. Bằng chứng bền vững tại `modules/m12/ra-soat/evidence/2026-11-19-codex-wp27/`, báo cáo `modules/m12/ra-soat/2026-11-19-wp27-codex-tiep-quan.md`.
2. WP28 đã commit local A `5acb6b121` → B `cdc72cb64` → C `084b0d406`. Root kiểm đủ nội dung 519 tệp khớp snapshot tại từng commit, khác biệt CRLF/LF ghi riêng trong evidence; index trống lúc đối chiếu. WP27 không stage/commit. Bộ đủ theo SHA cuối vẫn do điều phối; chỉ đóng khi có bằng chứng tương ứng.
3. Đã ghi ba SHA và trả toàn bộ features/lib cho WP28; M12-116 vẫn Đang làm, báo cáo giữ rõ giới hạn kiểm. Dữ liệu `.99`, push/deploy/cờ production vẫn cần quyền riêng.

## Còn lại / CẦN QUYẾT

- Phần D (dữ liệu `.99`) — hỏi Toàn khi tới.



## 19/11/2026 11:02 — đã áp dụng nhãn seed Việt hóa lên localhost

- Lead duyệt trực tiếp tại chat WP27: áp dụng seed Việt hóa localhost, chưa đụng `.99`. Đích đã kiểm: `ginsengfood-postgres-local`, `localhost:55432`, DB `ginsengfood_operational_local`; nhánh main.
- Áp dụng riêng 535 cặp câu chữ từ 20 seed đã commit WP27, không phát lại toàn chuỗi seed. Một giao dịch đổi 544 ô trên 10 bảng: 87 tên màn, 282 tên thao tác, 129 nhãn trường (31 nhãn dữ liệu nguồn), 3 tên phiếu mẫu, 14 tên bước kiểm tra, 16 mô tả vai, 6 mô tả cấu hình, 2 tên kho, 4 tên vị trí và 1 nhãn menu.
- Chạy thử rồi ROLLBACK: đạt; áp dụng COMMIT: đạt; chạy kiểm lại rồi ROLLBACK: 0 thay đổi. Dấu vân tay của mọi cột ngoài cột nhãn trên 10 bảng giữ nguyên; không còn nhãn cũ trong ánh xạ đã duyệt. Giữ nguyên giá trị cấu hình, quyền, dữ liệu/snapshot phiếu lịch sử; không sửa credential/principal hoặc chạy script triển khai.
- Đã sao lưu DB trực tuyến trước cập nhật: 5572313 byte; SHA256 `af80d28b3cdce98a733e64020ee9805a509d5edb002d2a79743cd3db6e50e818`; pg_dump và pg_restore --list mã thoát 0, chưa thử khôi phục. Bản dump giữ riêng tại thư mục Temp `WP27-local-vietnamese`, không sao chép vào Git/bộ bằng chứng.
- Lệnh: `python .../WP27-local-vietnamese/run.py preflight`, `apply`, `verify`; các lệnh SQL thực hiện qua psql với ON_ERROR_STOP, khóa hữu hạn và kiểm dữ liệu ngoài nhãn ngay trong giao dịch. Bằng chứng bền vững: `modules/m12/ra-soat/evidence/2026-11-19-codex-wp27/local-vietnamese/` (SQL, scope/hash nguồn, kết quả và nhật ký).
- Ví dụ đọc lại DB: SCR-AUDIT-LOG = Nhật ký kiểm toán; SCR-USERS-ROLES = Người dùng & Vai trò; SCR-DASHBOARD = Tổng quan vận hành (bản cũ). Cần tải lại trang localhost:3000 để bỏ cache menu phía trình duyệt; WP28 tiếp tục kiểm giao diện sau seed. Không mở server mới, không còn tiến trình cập nhật của WP27. Không thao tác `.99`. Task M12-116 vẫn Đang làm trong khi chờ kiểm tổng thể giao diện theo SHA cuối.

- 19/11 12:4x fork WP27 nhận lại việc từ phiên điều phối (Toàn giao: WP28 đuôi + đuôi WP27). Kiểm git: A/B/C đã commit cục bộ `5acb6b121`, `cdc72cb64`, `084b0d406` (do Codex/WP28 ghép, 519 tệp khớp hash); main `932b727bb`, index trống.
  3 tệp supplier-portal dirty (`FeedbackDialog.tsx`, `IntakeActivitySection.tsx`, `FeedbackPackagingDialog.tsx`): **không có thay đổi nội dung** (`git diff --numstat` rỗng, working = index LF; chỉ vết stat/EOL từ 10:26) ⇒ không có gì để commit, không revert (không phải tệp của fork).
  Dirty còn lại KHÔNG phải của fork: 2 tệp mail WP26 (`UsersRolesPage.WorkEmailDialog.tsx` + test), backend mail WP26 (csproj, SmtpWorkEmailSender, template, test), WIP nâng Next PWA (`next.config.ts`, `package.json`, `pnpm-lock.yaml`), weekly.
  Cổng exact-SHA `932b727bb` (typecheck/lint/vitest admin+public+PWA+UI/3 build/ratchet) giao verifier ở `_wt/m12/kiem-WP28-932b`; kết quả ghi `ra-soat/evidence/2026-11-19-wp28-gate-932b/GATE.md`. Phần D (.99) vẫn chờ Toàn.
- 19/11 13:1x cổng exact-SHA `932b727bb` (worktree sạch `_wt/m12/kiem-WP28-932b`, chạy mới): **CẦN SỬA nhẹ**. Đạt: typecheck 5/5 0 lỗi, eslint admin 0 lỗi/149 cảnh báo (lỗi cũ WarehouseReceiptCreateForm:70 hết),
  vitest admin 642 tệp 5.661 ca, public 359, PWA 1.455, packages/ui 39, ui-audit 83, build admin 112 route, ratchet 12/12 + 3 đột biến đỏ. Đỏ: build public-trace + PWA (Next 16.4.1, WIP nâng Next của chat khác — public-trace cũng cần nâng),
  bundle-budget admin 8 route > 1100 KiB (max 1135,0), 3 sửa hình học chưa có test (DateTimeInput, ServiceAccounts minWidth/marker, QR span; "Cấp quyền" thiếu marker). Giao coder ở worktree riêng `_wt/m12/wp28-bundle` (patch, không đụng checkout/.next của localhost). Hai lỗi Medium chưa đóng bằng ảnh Chrome.
- 19/11 14:1x coder bundle xong (patch 15 tệp, `scratchpad/wp28-bundle.patch`): nguyên nhân WP28 cho `DataTableRowActions` import thẳng menu Radix (~20 KiB × 54 màn) + `DataTable` luôn dựng `useVirtualizer` (~23 KiB, có từ trước); sửa nạp lười hai thứ bằng `lib/utils/lazy-module-loader.ts`.
  Route cao nhất 1135,0 → 1092,2 KiB (ngưỡng 1100 giữ nguyên), 0 route vượt; test hình học DateTimeInput/ServiceAccounts/QR + 14 đột biến đỏ; coder chạy vitest admin 648 tệp 5.693 ca, build admin OK. Nút "Cấp quyền" thiếu marker là CÓ CHỦ Ý (tool dò theo tên "Cấp…").
  Blast radius cao (DataTable ~83 route) ⇒ R2: verifier độc lập ở `_wt/m12/kiem-WP28-bundle` @ `0a038b508` + patch trước khi áp/commit. Patch không đụng vùng WP29 (`UsersRolesPage.*`, `user-detail`, users-roles hooks/route/test).
- 19/11 14:5x verifier độc lập patch bundle: **CẦN SỬA nhỏ**. Đạt: hook/bảng ảo hoá (không màn nào bật `virtualization`), hydration 0 lỗi, lỗi nạp thử lại được, bàn phím, ngân sách tự đo max 1092,2 KiB/0 route FAIL (baseline gỡ patch 1134,9/8 route vượt),
  typecheck 0, vitest admin 648/648 tệp 5.693 ca, ratchet 12/12, 27 đột biến 18 đỏ. Sửa: **L1** `DataTableRowActionsMenu.tsx:38,50` `openRequested` không về false ⇒ menu tự mở lại khi `actions` rỗng→có; **L2** static guard lazy chỉ khớp `"./…"` ⇒ import `@/components/…`/`../layout/…` lọt (M6a/b/d sống);
  **L3** test thiếu 4 ca (nạp lỗi thử lại, preventDefault, spacer/overscan bảng ảo hoá, effect nạp khi không preload). Đã giao coder sửa → patch v2 (`wp28-bundle.patch`, bản cũ `-v1`), sau đó verifier xem delta.
- 19/11 15:0x **Đã commit cục bộ `3be14c8e5`** (16 tệp, chưa push): patch bundle v2 — nạp lười menu "…" + bộ cuộn ảo của `DataTable`; route cao nhất 1135,0 → 1092,2 KiB, 0 route vượt 1100; test DateTimeInput/ServiceAccounts/QR + guard biên import. Verifier độc lập v2 ĐẠT
  (typecheck 0, 189 tệp 1.619 ca, ratchet 12/12, build 110 route 0 FAIL, 33+15 đột biến); hash 16 tệp commit khớp bản đã kiểm; coder chạy đủ admin 649 tệp 5.713 ca đạt. Còn thấp/không chặn: Enter lúc chờ vào khung menu, nút chờ cướp focus ở cửa sổ nạp, guard lách 4 cách phi chuẩn (`import{A}from`, `require(`, đổi hoa/thường, template literal).
  Chưa chạy: full admin v2 bởi người ngoài, Chrome pha chờ, budget public-trace/PWA (Next 16.4.1 chờ gói nâng của chat khác), audit 95 màn + ảnh 2 lỗi Medium (cần localhost đúng SHA), phần còn dư PWA.
