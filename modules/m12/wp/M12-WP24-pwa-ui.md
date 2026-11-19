# M12-WP24 — App xưởng dùng được cho công nhân (làm lại UI theo admin-web)

Trạng thái: **ĐANG LÀM** (D-m12-116: m12.130 B, 131 A, 132 A, 133 B; Sheet M12-112) · Rủi ro: R2 (đợt 2 ghép máy: R3) · Chế độ: S · Mốc: xong đợt 1–3 trước nghiệm thu sáng 27/11 (D-m12-091)
Lệnh: Toàn 18/11 "test lại toàn bộ UI app xưởng … phân tích rà soát và lên kế hoạch"; 16:0x "làm từ đợt 0 đến đợt 4 … làm đến khi xong" (D-m12-116). Luật chung coder: [M12-WP24-luat-chung.md](M12-WP24-luat-chung.md); nội dung: [M12-WP24-noi-dung.md](M12-WP24-noi-dung.md). Bản rà + kế hoạch: [../ra-soat/2026-11-18-pwa-ui-ra-soat-ke-hoach.md](../ra-soat/2026-11-18-pwa-ui-ra-soat-ke-hoach.md).

## Mục tiêu
Công nhân cầm máy là biết làm gì: đăng nhập giống admin, ghép máy một lần bằng QR, menu gọn theo vai, mỗi màn có tiêu đề + breadcrumb + mô tả + cách làm,
xem được tài khoản, chữ tiếng Việt dễ hiểu, cỡ chữ/chạm hợp xưởng; dùng chung component với admin-web.

## Đợt (chi tiết ở bản kế hoạch)
0 nội dung + menu theo vai (m12.133 B: không làm mẫu) · 1a nền: token + `packages/ui` + phông · 2 ghép máy (m12.130 B: giữ mô hình phiên máy chủ, QR + giữ qua đăng xuất) ·
1b đăng nhập + khung + tài khoản + màn Ghép máy + QR ở admin · 3 từng màn (21) + Việt hoá · 4 bộ đủ + UAT PWA sóng 4 + ảnh trước/sau (thiết bị thật: lượt riêng sau khi lên .99).

## Phạm vi ghi / tệp nóng
`apps/shopfloor-pwa/**`, `packages/ui` (mới), `packages/design-tokens`, `pnpm-workspace.yaml`, `package.json` gốc, 2 `next.config.ts`, 2 Dockerfile,
re-export ở `apps/admin-web/src/components/**`, màn admin "Thiết bị di động", guard `tests/frontend/shopfloor-pwa/static-guards/**`;
đợt 2: chỉ `apps/shopfloor-pwa/src/lib/**` + màn admin cấp phiên thiết bị (hiện QR) — KHÔNG `services/**` (m12.130 B).

## Gộp vào
PWA-01/02/03/04/08/09/14/16 (bản rà release 17/11); phần PWA của WP12g đợt 2 (nháp sessionStorage app quét phiếu, rà nhánh chú lần 4 mục 6).

## Diễn biến
- 18/11 15:xx rà UI: 2 agent đọc mã (`ee99e9fd6`) + 16 ảnh lab `565272e01` (`../ra-soat/2026-11-18-pwa-ui/`); trình m12.130–133.
- 18/11 16:29 Đợt 0 XONG: đặc tả nội dung 22 màn (21 route + màn Tài khoản) `M12-WP24-noi-dung.md` (thuật ngữ D-m12-118 + 29 mục Việt hoá app xưởng nhận từ fork).
  Mặc định phiên chọn cho 12 điểm CHƯA RÕ (không đổi luật chú, Toàn đổi được): (1) ô Việc chưa có huy hiệu số · (2) giữ một mã 403, câu báo nêu các khả năng (130 B: không API mới) ·
  (3) QR thêm trường tuỳ chọn `u` (tài khoản) + `e` (hạn) để app tự phân biệt 'hết hạn' / 'máy của người khác' · (4)(5) hiện mục theo QUYỀN thật trong seed (R-QA-REL thấy Kiểm tem QR; Lô cũ chờ kiểm theo quyền) ·
  (6) R-ACC-INT/R-PLAN: ô Việc mở 'Việc của tôi', trang chủ có lối tắt Nhập NL bằng phiếu quét · (7) đổi nhãn vai 'QC…' → 'KCS…' chỉ trong app xưởng (admin do Việt hoá của fork) ·
  (8)(9) giữ nguồn danh sách ca/vai/tổ và cách ghi nguồn quét như hiện tại · (10) báo mã phiên sắp hết hạn trước 3 ngày · (11) làm tự gửi khi có mạng (PWA-03) ở đợt 3 ⇒ nút 'Lưu và gửi' · (12) lối đăng nhập mail chờ WP26.
- 18/11 16:29 Đợt 2 (lib) coder ĐẠT tự kiểm ⇒ commit cục bộ `37994c194` (14 tệp): kho liên kết thiết bị IndexedDB theo người + máy, giữ qua đăng xuất/hết phiên, 403 giữ đăng nhập + `lyDo`, QR `GFDEV1`, vector chung, hook quét; 2 điểm coder hỏi (403 gộp lý do; cookie khác người lưu) ⇒ chấp nhận. Verifier R2 đang kiểm ở `_wt/m12/kiem-WP24-2`.
- 18/11 22:3x Đợt 4: verifier cuối A (r3) chức năng ĐẠT 5/5 + 5 đột biến đỏ; bộ đủ `47044dabb`: build 0, Unit 9167/9168, Integration 2048/2048, vitest admin 5218/5218 · app xưởng 1325/1328 (3 ca sót r3, đã sửa `ea0f77848`), seed ×2 79/79, next build đạt; Governance P17 đỏ (2 chuỗi cũ) ⇒ sửa `3ffa7d4c5` + `cbefa98b3`, lớp PerformanceTooling 12/12. CHƯA CHẠY: ApiContract 189 ca (Docker Desktop sập 21:58) — chạy lại bằng `bodu/14d-apicontract-filter-chay-lai.txt` khi Docker lên. Thêm `07abba8d4` (Mail liên hệ, D-m12-120), `e5077ea0f` (QA phát hành mẻ, D-m12-122). Còn: lối mail màn đăng nhập (chờ WP26 R3), push + .99 (hỏi riêng), UAT PWA, máy thật với Sang.
- 19/11 02:0x ApiContract 189 ca chạy lại (Docker lên lại 22:2x) trên `cbefa98b3`: 199/220 đạt; 20 ca RecallSaleLock đỏ vì worktree thiếu submodule hợp đồng ⇒ nhân bản tạm contracts `1e73bc17be` chạy lại 20/20 đạt; 1 ca WP07b (fixture xin token dịch vụ bị 429) đỏ cả ở `e5077ea0f` và `565272e01` (.99) ⇒ lỗi có từ trước, không do WP24/WP26 — chuyển rà release. Kết luận bộ đủ WP24: XANH trừ 1 ca có sẵn từ trước. Log `bodu/14e`–`14h`. Còn: lối mail đăng nhập (chờ WP26 R3), push + .99 (hỏi riêng), UAT PWA.

- 19/11 09:38 Codex tiếp theo xác nhận trực tiếp Toàn: nhận contract mail từ WP26; thêm client OTP + form mail/OTP và nối đường login PWA, giữ username fallback, 202 dùng câu UI, không lưu mail/OTP, chặn gửi trùng và response trễ khi huỷ. Năm tệp source/test còn WIP, chưa stage/commit phần R3. Test độc lập viết trước: 47 ca mới + 13 hồi quy login đã kiểm theo các lượt 57 + 3, typecheck/lint xanh; tester R3 frontend chấm ĐẠT phạm vi đọc/kiểm. Patch review: `C:\Users\Administrator\AppData\Local\Temp\codex-tiep-quan-m12-20261119\WP24-mail-r3-review.patch`.
- Build PWA lần đầu hoàn tất compile/TS/routes nhưng exit1 do Next16.4.1 security reminder; retry nguyên lệnh theo cơ chế native `allowNudgeRetry` exit0, không tắt guard/đổi deps. Cảnh báo security CHƯA giải quyết (bản phát hành chính thức https://github.com/vercel/next.js/releases/tag/v16.4.5 có security fixes). Visual đang kiểm bằng API giả trên local; chưa OTP/SMTP thật, UAT máy thật hay nghiệm thu production.

- Visual mail PWA hoàn tất:5trạng thái ×2khổ =10ảnh, không tràn,control tối thiểu46px,không raw202/401. R3 frontend/build/UI giả lập ĐẠT. Báo cáo `ra-soat/2026-11-19-codex-wp28-wp24.md`.
- 19/11 Toàn duyệt m12.173 “Duyệt, commit cục bộ”: đã commit `120b2ea7e` trên main,5tệp mailPWA +2mục nhật ký M12-112 Codex; index trống, WIP WP26/WP27 giữ nguyên. Đối chiếu hash bản đã kiểm trước commit; chỉ bỏ1dòng trống cuối test, không đổi hành vi. Sheet M12-112 giữ IN_PROGRESS vì còn kiểm đủ SHA cuối, OTP/SMTP/UAT thật và các phần WP24 khác. Không push/deploy/bật cờ.
