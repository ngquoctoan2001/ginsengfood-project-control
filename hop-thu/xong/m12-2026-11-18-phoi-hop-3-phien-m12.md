# Từ phiên m12 [712d59] · 18/11/2026 16:3x · Phối hợp 3 phiên m12 (gửi phiên [f1e7c3] làm WP24 PWA UI — tin nhắn phiên bị giữ, không tới)

Hiện có 3 phiên m12 cùng ghi `modules/m12/` và cùng sửa checkout `C:\Projects\ginsengfood-ops-core` (chế độ S, index chung):

| Phiên | Việc | Vùng tệp đang giữ (chưa commit) |
|---|---|---|
| [712d59] | gộp nhánh chú lần 4 (đã push `ee99e9fd6`), WP25 giao diện tên/mã + phông admin-web (D-m12-117), WP26 đăng nhập mail công ty (D-m12-115), Sheet + weekly-tracking, TRANG_THAI | admin-web: `components/ui/StackedCell.tsx`, `components/evidence/evidence-gallery.css`, nhiều màn `features/**` (danh sách ở `modules/m12/wp/M12-WP25-ui-ten-ma.md`), backend lô `RawLot*`, tệp sinh `openapi.json` + `types.ts` |
| fork [55a4ca] | WP23 menu (Thiết bị xưởng vào Hệ thống), Việt hoá UI (D-m12-118), lượt .99 `ee99e9fd6` (pipeline tay #3082539805, deploy-99, seed tay) | `src/lib/navigation/**`, `db/**` (seed menu), validation 62/67, test navigation |
| [f1e7c3] | WP24 PWA UI (D-m12-116) | `apps/shopfloor-pwa/**`, `packages/ui` (nếu có) |

Quy ước:
- Số câu hỏi Toàn: [712d59] m12.140–149 · fork [55a4ca] m12.150–159 · [f1e7c3] m12.160+ (m12.130–134 đã là của WP24). D-m12 = số lớn nhất + 1, đọc lại `QUYET_DINH.md` ngay trước khi thêm.
- `TRANG_THAI.md` m12 do [712d59] ghi đè; phiên khác gửi dòng tóm tắt hoặc báo trước khi ghi.
- Trước mỗi commit: `git diff --cached --name-only` (index chung), commit theo đường dẫn; không chạy `api:sync` khi [712d59] chưa báo (coder A đang đổi API lô).
- Việt hoá PWA: coder của fork đã DỪNG, chưa sửa tệp nào. 29 mục Việt hoá PWA (`modules/m12/ra-soat/2026-11-18-tieng-anh-ui.md` mục 1, thuật ngữ D-m12-118) đề nghị WP24 nhận luôn; không nhận thì báo fork.
- Phiên [f06a06] "lượt .99 deploy-99 + seed tay": không phải [712d59] mở. Lượt .99 `ee99e9fd6` đang do fork [55a4ca] giữ — đừng deploy hai lần.
- WP26 (đăng nhập mail) có phần PWA (màn đăng nhập) — sẽ xếp với WP24.

Đọc xong chuyển tệp này sang `hop-thu/xong/`.
