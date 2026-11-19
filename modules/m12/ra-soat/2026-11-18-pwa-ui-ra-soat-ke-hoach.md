# App xưởng (PWA) — rà soát UI và kế hoạch làm lại · 18/11/2026

Lệnh Toàn 18/11: "test lại toàn bộ UI app xưởng … không thể vận hành được … phân tích rà soát và lên kế hoạch".
Cách rà: (1) 2 agent đọc mã chỉ đọc ở `ee99e9fd6` (app xưởng `apps/shopfloor-pwa`, admin-web `apps/admin-web`);
(2) chụp 16 màn trên lab localhost bản `565272e01` (= bản đang chạy `.99`), khổ điện thoại 390×844 và máy tính bảng 1024×768,
đăng nhập tài khoản thử của lab. Ảnh: `ra-soat/2026-11-18-pwa-ui/` (ngoài git). Đồng thời đối chiếu bản rà release
`ra-soat/2026-11-17-release/06-pwa-xuong.md` (PWA-01…17).

## Kết luận

Toàn nói đúng: app xưởng hiện **không vận hành được với công nhân**. Lỗi gốc không nằm ở từng màn mà ở 3 chỗ:
1. **Ghép máy (Mã thiết bị + Mã phiên) sai mô hình:** công nhân phải gõ mù mã phiên 46 ký tự mà quản trị chỉ cho xem một lần;
   mã mất mỗi lần đăng xuất / hết phiên / đổi người; khung "Thiết bị · Cần thiết lập" chen vào 15 màn. Gõ sai thì bị đá ra đăng nhập
   mà không nói lý do.
2. **Khung điều hướng sai cho điện thoại:** 17 mục + nút Đăng xuất dồn vào thanh đáy cuộn ngang (thấy 4–5 ô, nhãn bị cắt),
   không thanh trên, không tên trang, không breadcrumb, không nút quay lại, không biết ai đang đăng nhập.
3. **Hệ giao diện riêng, lệch admin-web:** CSS tự viết 1.610 dòng, token chép tay đã lệch (thiếu ~50 token), không nạp phông Inter,
   ô nhập/nút viết thô (110 `<input>`, 46 `<button>`), 2 hệ icon; chỉ 2/21 màn có mô tả; nhiều chữ kỹ thuật/tiếng Anh.

## Phát hiện theo từng ý của Toàn

| # | Ý Toàn | Thực tế (ảnh / mã) | Hướng sửa |
|---|---|---|---|
| 1 | Đăng nhập không giống admin | Ảnh 01 vs 02: PWA có ô chữ "G", tiêu đề "Đăng nhập vận hành", câu "cookie bảo mật; PWA không lưu token", nút nhạt; admin: thẻ giữa, "Ginsengfood Quản trị", `FormField`+`Input`+`Button`, dấu * bắt buộc, lỗi từng ô (`shopfloor-auth-clients.tsx:50-104` vs `admin-web/src/features/auth/LoginPage.tsx`) | Dùng đúng component + bố cục admin; chỉ đổi chữ: "Ginsengfood Xưởng" / "Ứng dụng vận hành tại xưởng". Lỗi không kèm mã thô. Màn đổi mật khẩu làm y vậy |
| 2 | Quá nhiều menu, để ở đáy | Ảnh 05/06: 17 mục cuộn ngang, nhãn "…"; thanh trên chỉ có "API kết nối · Hàng đợi chưa xác minh" (`shopfloor-shell.tsx:36-54,438-447`, `globals.css:1463-1512`). Menu lọc theo quyền nhưng `MOBILE_TASK_VIEW` mở 12/17 mục cho mọi người | Thanh trên kiểu admin điện thoại (ảnh 23: ☰ + tên + avatar); ngăn kéo menu chia nhóm theo công đoạn, lọc theo vai; thanh đáy tối đa 4 ô (m12.131) |
| 3 | "Thiết bị cần thiết lập" ở đâu cũng có | `SetupRequiredPanel` hiện ở 15 màn khi máy chưa lưu đủ 2 mã (`shopfloor-device-setup-state.ts:7-29`, `shopfloor-task-inbox.tsx:504`, `scan-client.tsx:115`…); ảnh 05/07/08 | Một màn "Ghép máy" duy nhất, chặn trước khi vào app, chỉ khi thật sự thiếu; các màn còn lại không hiện khung này |
| 4 | Không đồng bộ admin, không dùng component bên đó | Không import chéo, không gói UI chung; guard còn cấm chuỗi "admin-web" trong PWA (`mobile-boundary-static.test.ts:37-38`); token PWA 170 vs admin 219 | Tách `packages/ui` dùng chung (m12.132); toàn bộ token về `packages/design-tokens` |
| 5 | Không breadcrumb, không mô tả trang, không biết thao tác | Chỉ eyebrow "Xưởng vận hành /" không bấm được; 19/21 màn không mô tả; chi tiết việc không có nút quay lại (`task-detail-client.tsx:526-535`) | `PageHeader` của admin (tiêu đề + breadcrumb + mô tả) cho mọi màn; khối "Cách làm" 3–5 bước gập được; trạng thái rỗng nói việc cần làm |
| 6 | Không xem được thông tin tài khoản | Không màn/menu tài khoản; `/auth/me` có tên + vai nhưng PWA chỉ lấy quyền (`shopfloor-shell.tsx:221,297`) | Màn "Tài khoản" theo `AccountProfilePage` admin: tên, tài khoản, vai, máy đang ghép + hạn, đổi mật khẩu, đăng xuất có xác nhận |
| 7 | Cỡ chữ, phông, phần tử lộn xộn | Chữ nền 14px, nhãn 12px, h1 24px; Inter khai nhưng không nạp ⇒ phông hệ thống; nút 38–44px; icon trùng nghĩa | Phông Inter như admin; chữ nền xưởng 16px; nút/ô chạm ≥ 48px; một hệ icon (lucide như admin) |
| 8 | Mã thiết bị nhập hay quét? Mã phiên ở đâu? | Cả hai **gõ tay**; mã phiên là ô mật khẩu 46 ký tự; quản trị cấp ở admin "Thiết bị di động" (`MobileDevicesPage.tsx:102-147`), chỉ hiện một lần, không QR; phiên gắn (người, máy) ⇒ máy dùng chung cần một mã cho mỗi người; cấp lại khi còn hạn bị 409 | **Quét QR** một lần (máy ảnh đã có sẵn trong app); dự phòng: ô chọn máy vừa gõ vừa tìm như bộ lọc admin. Mô hình phiên: m12.130 |

Thêm (từ mã, Toàn chưa nêu): đăng xuất 1 chạm không hỏi, nằm ngay trong dải menu; tài khoản thiếu `MOBILE_TASK_VIEW` bị đá về đăng nhập lặp
lại không giải thích (PWA-02); lệnh "Đưa vào hàng đợi" không tự gửi khi có mạng (PWA-03); chữ kỹ thuật/tiếng Anh: "Phong bì lệnh", "Mã băm nội dung",
"sale-lock", "Work order", "effective permissions", "API kết nối" trên mọi trang, lỗi "UNAUTHORIZED: …"
(`shopfloor-offline-queue-client.tsx:246,348`, `shopfloor-pwa-display.ts:24,31,245`, `shopfloor-shell.tsx:440-466`, `mobile-client.ts:200`);
form chi tiết việc bắt công nhân chọn 1 trong 14 loại bằng chứng và tự gõ "Tham chiếu".

## Cần bạn quyết

- **m12.130 — Mô hình ghép máy.**
  A (đề xuất): **ghép máy một lần** — quản trị đăng ký máy, in/hiện QR, quét một lần trên máy; sau đó ai có quyền app đăng nhập trên máy đó là dùng
  được ngay, máy chủ tự cấp phiên theo (người, máy), hết ca tự hết hạn (D-m12-101). Cần API mới + đổi luồng đăng nhập (R3, ~2 ngày).
  B: giữ phiên theo (người, máy) như nay; quản trị cấp mã kèm QR, PWA quét thay gõ, mã giữ qua đăng xuất (~1 ngày) — mỗi công nhân mỗi máy vẫn phải
  xin quản trị một mã, hết hạn lại xin. Trễ: không ghép máy dễ thì nghiệm thu 27/11 trên thiết bị không chạy nổi.
- **m12.131 — Điều hướng.** A (đề xuất): thanh trên (☰, tên trang, avatar) + ngăn kéo menu nhóm theo công đoạn (lọc theo vai) + thanh đáy 4 ô
  cố định: Việc · Quét · Hàng đợi · Tài khoản. B: chỉ ngăn kéo như admin trên điện thoại (ảnh 23), không thanh đáy.
- **m12.132 — Dùng chung component.** A (đề xuất): tách `packages/ui` — chuyển component lá (Button, FormField, ô nhập, Combobox, Badge,
  Notice, EmptyState, PageHeader + breadcrumb, SectionCard, Stepper, hộp xác nhận) từ admin sang gói chung; admin giữ đường import cũ bằng tệp
  re-export (không sửa màn admin); PWA dùng gói. B: chép sang PWA — nhanh hơn ~0,5 ngày nhưng lại lệch như token hiện nay.
- **m12.133 — Duyệt mẫu trước khi code.** A (đề xuất): làm mẫu bấm thử được 5 màn (đăng nhập, ghép máy, trang chủ + menu, một màn việc,
  tài khoản) cho bạn duyệt trong nửa ngày rồi mới code. B: code thẳng theo bản này.

## Kế hoạch — gói M12-WP24 "App xưởng dùng được cho công nhân"

| Đợt | Việc | Rủi ro | Ước lượng | Tiêu chí đạt |
|---|---|---|---|---|
| 0 | Mẫu 5 màn (nếu m12.133 A) + nội dung "mô tả + cách làm" từng màn lấy từ HDSD/catalog UAT | R1 | 0,5 ngày | Toàn duyệt mẫu |
| 1 Nền | Token đủ về `packages/design-tokens`; `packages/ui` + re-export admin; phông Inter; đăng nhập + đổi mật khẩu giống admin; khung mới (thanh trên, ngăn kéo theo vai, thanh đáy 4 ô, breadcrumb, nút quay lại); màn Tài khoản; đăng xuất có xác nhận | R2 | 2 ngày | Ảnh so khớp admin; guard `pwa-ui-static`/bundle sửa theo; vitest admin + PWA đủ xanh; Dockerfile 2 app build được |
| 2 Ghép máy | Theo m12.130: QR ở admin "Thiết bị di động" + quét trong PWA; (A) API đăng ký máy + tự cấp phiên theo người; giữ ghép qua đăng xuất (D-m12-101); một màn chặn duy nhất, báo đúng lý do khi mã sai/hết hạn; bỏ khung ở 15 màn | R3 | 1–2 ngày | Tester độc lập: ghép 1 lần, 3 người lần lượt đăng nhập cùng máy không xin mã; thu hồi máy ⇒ chặn; Toàn duyệt diff |
| 3 Từng màn | 21 màn: tiêu đề + mô tả + cách làm + trạng thái rỗng; bỏ chữ kỹ thuật/tiếng Anh (guard `vietnamese-ui-text-static` mở rộng); menu nhóm theo vai; chữ 16px, chạm ≥ 48px; chi tiết việc tự điền bằng chứng/tham chiếu; hàng đợi tự gửi khi có mạng (PWA-03/04); bảng mã lỗi (PWA-09) | R2 | 2 ngày | Mỗi màn có ảnh trước/sau; 0 chữ kỹ thuật theo guard |
| 4 Thiết bị thật | Thử trên máy tính bảng xưởng + điện thoại (camera, HTTPS `pwa.ginsengfood.vn`), cùng Sang; UAT PWA sóng 4 (127 ca, WP-UAT) chạy trên bản mới; HDSD ảnh mới | R2 | 1 ngày | Biên bản thử thiết bị; UAT PWA chạy hết |

Tổng ~6–7 ngày-agent, chạy làn song song với WP17b (Production) — phạm vi tách nhau (`apps/shopfloor-pwa/**`, `packages/ui`,
`packages/design-tokens`, màn admin "Thiết bị di động" vs `deploy/**`, CI). Phải xong đợt 1–3 trước buổi nghiệm thu sáng 27/11 (D-m12-091).
Gộp vào WP24: PWA-01/02/03/04/08/09/14/16 của bản rà release và phần PWA của WP12g đợt 2 (nháp sessionStorage app quét phiếu). Lên `.99` mỗi đợt là
lượt riêng chờ bạn.

Rủi ro: (1) `packages/ui` đụng nhiều test/guard của admin — dùng re-export để màn admin không đổi; (2) bundle + cache ngoại tuyến PWA phình khi thêm
Radix — giữ nạp động, đo kích thước ở đợt 1; (3) nội dung hướng dẫn từng màn cần người hiểu nghiệp vụ (chú Dũng, HDSD) duyệt; (4) m12.130 A chạm
xác thực (R3) — tester độc lập + bạn duyệt diff.

## Phụ: lab dùng cho lượt rà này

Lab 1 (`_wt/m12/uat-WP03c` @ `565272e01`): API 5200, admin 3200, app xưởng 3201, DB `ginsengfood_uat2710_lab` trong `ginsengfood-postgres-local`.
Ảnh chụp bằng Chrome không giao diện qua giao thức DevTools (khung trình duyệt của app không mở được localhost lần này). Nhãn "1 Insight" góc
dưới trái trên ảnh là lớp phủ của chế độ dev Next, không có trên `.99`.
