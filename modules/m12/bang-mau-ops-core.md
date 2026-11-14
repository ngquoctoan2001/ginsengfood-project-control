# Bảng màu giao diện M1–M2 (ops-core) — gửi M3 đồng bộ

Nguồn: repo `ginsengfood-ops-core`, `main` @ `fcb37811f`, đọc ngày 02/11/2026. Ba ứng dụng:

| Ứng dụng | Tệp token | Ghi chú |
|---|---|---|
| Quản trị `admin-web` | `apps/admin-web/src/design/tokens.css` | bảng chính, có sáng + tối; **M3 nên theo bảng này** |
| PWA xưởng `shopfloor-pwa` | `apps/shopfloor-pwa/src/design/tokens.css` | bản sao rút gọn của bảng chính (cùng giá trị), chỉ nền sáng |
| Trang truy xuất công khai `public-trace` | `apps/public-trace/app/styles/tokens.css` | bảng riêng cho khách: xanh rừng + vàng, có sáng + tối (mục 8) |

Cách đọc: giá trị gốc trong mã là `oklch()`. Cột hex là quy đổi sang sRGB, làm tròn từng kênh (có thể lệch ±1). Màu nào nằm ngoài
gam sRGB thì bị cắt về mép gam, nên muốn khớp tuyệt đối thì chép giá trị `oklch()` ở mục 9. Chế độ tối bật bằng
`[data-theme="dark"]` trên `<html>` hoặc tự theo hệ điều hành; bản in luôn dùng bảng sáng.

Luật dùng trong mã ops-core: component chỉ dùng **token ngữ nghĩa** (`--brand-*`, `--surface-*`, `--text-*`, `--border-*`, `--status-*`);
thang màu gốc (`--color-green-500`…) chỉ để tham chiếu, không dùng thẳng.

## 1. Màu chủ đạo và nền

| Vai trò | Token | Sáng | Tối |
|---|---|---|---|
| Màu thương hiệu (nút chính, mục menu đang chọn) | `--brand-primary` | `#005c2b` | `#23ba7d` |
| Thương hiệu khi trỏ chuột | `--brand-primary-hover` | `#004b1b` | `#41ce90` |
| Thương hiệu khi bấm | `--brand-primary-active` | `#003d0e` | `#59e1a2` |
| Nền nhạt thương hiệu (chip, badge) | `--brand-primary-subtle` | `#d3f9e3` | `#0a3723` |
| Chữ trên nền thương hiệu | `--brand-primary-text` | `#fcfcfc` | `#021109` |
| Nền trang | `--surface-base` | `#fcfcfc` | `#181818` |
| Nền thanh bên, thẻ phụ | `--surface-subtle` | `#f7f7f7` | `#0f0f0f` |
| Nền dòng bảng khi trỏ | `--surface-overlay` | `#f2f2f2` | `#242424` |
| Nền hàng tiêu đề bảng | `--surface-header` | `#eeeeee` | `#141414` |
| Nền ô nhập | `--surface-inset` | `#ebebeb` | `#0b0b0b` |
| Nền hộp thoại | `--surface-dialog` | `#ffffff` | `#1f1f1f` |
| Màn che sau hộp thoại | `--overlay-backdrop` | `#000000 / 40%` | `#000000 / 60%` |

## 2. Chữ, liên kết, viền, focus

| Vai trò | Token | Sáng | Tối |
|---|---|---|---|
| Chữ chính | `--text-primary` | `#090909` | `#f2f2f2` |
| Chữ phụ | `--text-secondary` | `#4d4d4d` | `#b7b7b7` |
| Chữ mờ (ghi chú, thời gian) | `--text-tertiary` | `#808080` | `#868686` |
| Chữ bị khoá | `--text-disabled` | `#ababab` | `#585858` |
| Chữ trên nền đậm | `--text-inverse` | `#fcfcfc` | `#0d0d0d` |
| Liên kết | `--text-link` | `#004b83` | `#6bb9f8` |
| Liên kết khi trỏ | `--text-link-hover` | `#00376e` | `#84d3ff` |
| Viền mảnh (chia dòng) | `--border-subtle` | `#dedede` | `#2e2e2e` |
| Viền thường (ô nhập, thẻ) | `--border-default` | `#c4c4c4` | `#424242` |
| Viền đậm, thanh cuộn | `--border-strong` | `#868686` | `#6f6f6f` |
| Viền focus (vòng 2px khi dùng bàn phím) | `--border-focus` = `--brand-primary` | `#005c2b` | `#23ba7d` |

Focus: `outline: 2px solid var(--border-focus)` cho mọi phần tử `:focus-visible`. Thanh cuộn: thumb `--border-strong`, trỏ chuột `--text-tertiary`.

## 3. Nút (6 biến thể, `apps/admin-web/src/components/ui/Button.tsx`)

| Biến thể | Trạng thái | Nền | Chữ | Viền |
|---|---|---|---|---|
| **primary — nút chính** | thường | `--brand-primary` · `#005c2b` · tối `#23ba7d` | `--brand-primary-text` · `#fcfcfc` · tối `#021109` | trong suốt |
| | trỏ chuột (bóng shadow-sm) | `--brand-primary-hover` · `#004b1b` · tối `#41ce90` | `--brand-primary-text` · `#fcfcfc` · tối `#021109` | `--brand-primary-hover` · `#004b1b` · tối `#41ce90` |
| **secondary — nút phụ** | thường | `--surface-subtle` · `#f7f7f7` · tối `#0f0f0f` | `--text-primary` · `#090909` · tối `#f2f2f2` | `--border-default` · `#c4c4c4` · tối `#424242` |
| | trỏ chuột (bóng shadow-xs) | `--surface-inset` · `#ebebeb` · tối `#0b0b0b` | `--brand-primary` · `#005c2b` · tối `#23ba7d` | `--border-strong` · `#868686` · tối `#6f6f6f` |
| **ghost — nút trơn** | thường | trong suốt | `--text-primary` · `#090909` · tối `#f2f2f2` | trong suốt |
| | trỏ chuột (bóng —) | `--surface-overlay` · `#f2f2f2` · tối `#242424` | `--brand-primary` · `#005c2b` · tối `#23ba7d` | `--border-subtle` · `#dedede` · tối `#2e2e2e` |
| **danger — nút nguy hiểm (xoá, huỷ)** | thường | `--status-danger-fg` · `#6f000b` · tối `#ffa59c` | `--text-inverse` · `#fcfcfc` · tối `#0d0d0d` | trong suốt |
| | trỏ chuột (bóng shadow-xs) | `--status-danger-bg` · `#ffe8e4` · tối `#451816` | `--status-danger-fg` · `#6f000b` · tối `#ffa59c` | `--status-danger-border` · `#f8a49d` · tối `#8f3734` |
| **warning — nút cảnh báo** | thường | `--status-warning-bg` · `#ffeecd` · tối `#3f2903` | `--status-warning-fg` · `#602f00` · tối `#ffc76c` | `--status-warning-border` · `#e7af5c` · tối `#7e5403` |
| | trỏ chuột (bóng shadow-xs) | `--status-warning-fg` · `#602f00` · tối `#ffc76c` | `--text-inverse` · `#fcfcfc` · tối `#0d0d0d` | `--status-warning-fg` · `#602f00` · tối `#ffc76c` |
| **outline — nút viền** | thường | trong suốt | `--brand-primary` · `#005c2b` · tối `#23ba7d` | `--brand-primary` · `#005c2b` · tối `#23ba7d` |
| | trỏ chuột (bóng shadow-xs) | `--brand-primary` · `#005c2b` · tối `#23ba7d` | `--brand-primary-text` · `#fcfcfc` · tối `#021109` | `--brand-primary` · `#005c2b` · tối `#23ba7d` |

Chung cho mọi nút: khoá hoặc đang tải → `opacity: 0.5`, con trỏ `not-allowed`. Kích thước:

| Cỡ | Đệm ngang × dọc | Cỡ chữ | Bo góc |
|---|---|---|---|
| sm | 12px × 6px | 12px | 6px |
| md (mặc định) | 16px × 8px | 14px | 6px |
| lg | 20px × 10px | 16px | 8px |

Trên thiết bị cảm ứng (`pointer: coarse`) mọi điều khiển cao tối thiểu 44px, chữ ô nhập 16px.

## 4. Badge trạng thái (11 tông, `Badge.tsx` + `src/lib/ui/status-maps/*.ts`)

Mỗi tông có 4 màu: nền `-bg`, chữ `-fg`, viền `-border`, chấm/biểu tượng `-icon`. Badge bo tròn hẳn, chữ 12px đậm 600.

| Tông | Ý nghĩa | Nền (sáng / tối) | Chữ (sáng / tối) | Viền (sáng / tối) | Chấm (sáng / tối) | Ví dụ nhãn · số trạng thái dùng |
|---|---|---|---|---|---|---|
| **success** | xong / đạt (lô đã phát hành, QC đạt, QR đã in) | `#d5f9e0` / `#09311b` | `#003d0d` / `#83e7a8` | `#8ecfa4` / `#23643f` | `#006127` / `#43c07a` | Đã duyệt, Hoàn tất, Đang áp dụng, Tồn kho ổn · 108 |
| **warning** | chờ / cần làm (chờ duyệt, đang xem xét) | `#ffeecd` / `#3f2903` | `#602f00` / `#ffc76c` | `#e7af5c` / `#7e5403` | `#a65f00` / `#f2a618` | Chờ duyệt, Đang xem xét, Cần mua hàng, Cảnh báo vàng · 90 |
| **danger** | lỗi / chặn (từ chối, thất bại, thu hồi nghiêm trọng) | `#ffe8e4` / `#451816` | `#6f000b` / `#ffa59c` | `#f8a49d` / `#8f3734` | `#b01e25` / `#fa6863` | Từ chối, Thất bại, Bị chặn, Cảnh báo đỏ, Hết tồn · 96 |
| **info** | thông tin, chỉ đọc | `#e2f5ff` / `#092b44` | `#00376e` / `#8bd2ff` | `#92c4ee` / `#255c87` | `#0065a9` / `#46a6ef` | Đã tạo, Đang mở, Đã nhận, Sẵn sàng · 59 |
| **neutral** | nháp, không hoạt động, siêu dữ liệu | `#eeeeee` / `#292929` | `#4d4d4d` / `#bebebe` | `#c4c4c4` / `#4d4d4d` | `#808080` / `#8c8c8c` | Nháp, Đang chờ, Ngừng dùng, Đã đóng · 102 |
| **indigo** | đang chạy / đang xử lý | `#eaf1ff` / `#1d2746` | `#1f2d72` / `#aec7ff` | `#a9bcf2` / `#45558a` | `#4258af` / `#7d98f5` | Đang sản xuất, Đang đóng gói, Đang in, Đang đồng bộ · 22 |
| **orange** | cần chú ý, trả lại, rủi ro | `#ffe8d7` / `#462312` | `#6d2000` / `#ffb588` | `#faa178` / `#8b492a` | `#b94a00` / `#ff8c53` | Cần giám đốc duyệt, Rủi ro hết hàng, Đang thử lại · 38 |
| **pink** | huỷ / vô hiệu | `#ffe9ff` / `#3b1a39` | `#5c0e59` / `#faabf3` | `#e3a6dd` / `#7c3b77` | `#952c8f` / `#da6fd3` | Đã hủy, Ngưng dùng, Trả nhà cung cấp, Hết hạn · 26 |
| **teal** | xong một phần / có điều kiện | `#d6fbf3` / `#00322a` | `#004c3b` / `#51e6ce` | `#6dd3c0` / `#00695a` | `#007d64` / `#00c0a3` | MRP hoàn tất, Đã đối soát, Đã loại khỏi phiếu mua · 17 |
| **violet** | nhấn mạnh riêng | `#f1eeff` / `#2b244b` | `#402584` / `#cdbdff` | `#bdafff` / `#5e4da1` | `#6741ca` / `#a688ff` | Đã đảo bút toán, Xử lý sau thu hồi, Cần owner quyết · 4 |
| **cyan** | đang xử lý (ít dùng) | `#dcf8fa` / `#003134` | `#00454d` / `#65e0e7` | `#7cced2` / `#00666c` | `#00767f` / `#00b7c1` | Đã yêu cầu thông báo · 2 |

## 5. Biểu đồ (`src/components/ui/charts/chart-tokens.ts`)

| Biến thể | Nét vẽ | Vùng tô |
|---|---|---|
| default | `--brand-primary` · `#005c2b` · tối `#23ba7d` | `--brand-primary-subtle` · `#d3f9e3` · tối `#0a3723` |
| success | `--status-success-fg` · `#003d0d` · tối `#83e7a8` | `--status-success-bg` · `#d5f9e0` · tối `#09311b` |
| warning | `--status-warning-fg` · `#602f00` · tối `#ffc76c` | `--status-warning-bg` · `#ffeecd` · tối `#3f2903` |
| danger | `--status-danger-fg` · `#6f000b` · tối `#ffa59c` | `--status-danger-bg` · `#ffe8e4` · tối `#451816` |
| info | `--status-info-fg` · `#00376e` · tối `#8bd2ff` | `--status-info-bg` · `#e2f5ff` · tối `#092b44` |
| neutral | `--border-strong` · `#868686` · tối `#6f6f6f` | `--surface-subtle` · `#f7f7f7` · tối `#0f0f0f` |

## 6. Chữ, bo góc, bóng đổ

- Phông: `Inter` (400/500/600/700) cho chữ thường; `JetBrains Mono` (400/600) cho mã lô, mã phiếu.
- Cỡ chữ: 12 · 14 · 16 · 18px; tiêu đề 18→20 · 22→24 · 26→30px (co giãn theo màn).
- Bo góc: 4 · 6 · 8 · 12 · 16px, tròn hẳn 9999px.
- Bóng (nền sáng): xs `0 1px 2px` đen 5%; sm `0 1px 3px` 8% + `0 1px 2px` 6%; md `0 4px 6px` 7% + `0 2px 4px` 5%;
  lg `0 10px 15px` 8% + `0 4px 6px` 5%; hộp thoại `0 20px 25px` 12% + `0 8px 10px` 8%. Nền tối nâng độ đậm lên 40–60%.

## 7. Thang màu gốc (tham chiếu, không dùng thẳng trong component)

| Thang | 50 | 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900 | 950 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| green | `#e5fcee` | `#cff6e0` | `#a9e8c6` | `#77d0a2` | `#39ad79` | `#008954` | `#006e3b` | `#005c2b` | `#00461e` | `#003111` | `#001a06` |
| gray | `#fcfcfc` | `#f5f5f5` | `#ebebeb` | `#dedede` | `#c4c4c4` | `#9e9e9e` | `#808080` | `#636363` | `#4d4d4d` | `#292929` | `#090909` |
| red | `#ffeeeb` | `#ffdfda` | `#ffc0ba` | `#fb9890` | `#e76761` | `#d03739` | `#b31220` | `#940015` | `#72020e` | `#4f0a0d` | `#290102` |
| amber | `#fff6e3` | `#ffeecd` | `#ffd99e` | `#fcbe62` | `#ef9e00` | `#d78300` | `#b96c00` | `#995700` | `#754300` | `#4f2c00` | `#2a1500` |
| blue | `#e5f8ff` | `#d0f0ff` | `#abdeff` | `#82c2f7` | `#499fe3` | `#007dc9` | `#0065ae` | `#005093` | `#003d74` | `#00284f` | `#00132a` |
| emerald | `#e6fcec` | `#ccf8da` | `#a1ecbb` | `#6fd395` | `#2eaf6b` | `#008e48` | `#007434` | `#005d28` | `#004419` | `#002e11` | `#001506` |
| violet | `#f4f3ff` | `#eae6ff` | `#d6ceff` | `#b9acff` | `#9982f8` | `#7d5be6` | `#6741ca` | `#5431a9` | `#402584` | `#2b195a` | `#150b30` |

Xanh thương hiệu = green-700 (`oklch(40% 0.14 160)`).

## 8. Trang truy xuất công khai (khách quét QR) — bảng riêng

Phong cách khác hẳn trang quản trị: xanh rừng + vàng đồng, chữ tiêu đề có chân (`Iowan Old Style`, `Palatino`, `Georgia`). Màu thanh
trình duyệt `theme-color`: sáng `#0f2e22`, tối `#081a12`. Nếu M3 có trang cho khách (cửa hàng, đơn hàng) thì nên theo bảng này.

| Vai trò | Token | Sáng | Tối |
|---|---|---|---|
| Nền trang | `--bg` | `#f5efe2` | `#0b1711` |
| Nền thẻ | `--surface` | `#fffcf5` | `#11231a` |
| Nền thẻ phụ | `--surface-2` | `#f0e9d9` | `#173024` |
| Chữ chính | `--ink` | `#14261c` | `#efe7d3` |
| Chữ phụ | `--ink-2` | `#46564b` | `#c0cbbf` |
| Chữ mờ | `--ink-3` | `#586a5d` | `#a3b1a5` |
| Viền | `--line` | `#e2d8c0` | `#264236` |
| Viền đậm | `--line-strong` | `#8f8363` | `#6f8576` |
| Liên kết | `--link` | `#1b5640` | `#e3bd73` |
| Focus | `--focus` | `#1b5640` | `#e3bd73` |
| Chữ vàng | `--gold-text` | `#86601d` | `#e3bd73` |
| Nền chip vàng | `--gold-chip-bg` | `#f6ecd0` | `#2a2a17` |
| Nút: nền | `--btn-bg` | `#1b5640` | `#d0a050` |
| Nút: nền khi trỏ | `--btn-bg-hover` | `#14412f` | `#e0b565` |
| Nút: chữ | `--btn-ink` | `#ffffff` | `#1a1406` |
| Còn hạn: chữ | `--ok-ink` | `#1b633f` | `#86d8a7` |
| Còn hạn: nền | `--ok-bg` | `#e1f1e6` | `#143a28` |
| Còn hạn: viền | `--ok-line` | `#b9dcc6` | `#25583d` |
| Sắp hết hạn: chữ | `--soon-ink` | `#74460a` | `#f1c46d` |
| Sắp hết hạn: nền | `--soon-bg` | `#fbebcc` | `#3b2d10` |
| Sắp hết hạn: viền | `--soon-line` | `#ecd29a` | `#5c4818` |
| Hết hạn: chữ | `--expired-ink` | `#8c2a1c` | `#f5ab9e` |
| Hết hạn: nền | `--expired-bg` | `#fbe2dc` | `#41191a` |
| Hết hạn: viền | `--expired-line` | `#ecb7ad` | `#6a2b2a` |
| Thanh hạn dùng: còn hạn | `--meter-ok` | `#2d8a62` | `#4fbf8a` |
| Thanh hạn dùng: sắp hết | `--meter-soon` | `#c98a1c` | `#e0a93a` |
| Dải đầu trang: trên | `--hero-top` | `#0f2e22` | `#081a12` |
| Dải đầu trang: giữa | `--hero-mid` | `#14412f` | `#0f2e22` |
| Dải đầu trang: dưới | `--hero-bottom` | `#1b5640` | `#14412f` |
| Chữ trên dải đầu trang | `--hero-ink` | `#f6efdc` | `#f6efdc` |
| Vàng trên dải đầu trang | `--hero-gold` | `#e7c47e` | `#e7c47e` |
| Chân trang: nền | `--footer-bg` | `#0a2018` | `#07130d` |
| Chân trang: chữ | `--footer-ink` | `#d3ddd0` | `#cbd6c9` |

Thang gốc: forest 950 `#0a2018` · 900 `#0f2e22` · 800 `#14412f` · 700 `#1b5640` · 600 `#23694d`; gold 200 `#f2e3bd` · 300 `#e4c78b` ·
400 `#d0a050` · 500 `#b5832f`. Bo góc 10 · 16 · 24px.

## 9. Khối CSS chép thẳng (bảng chính, giá trị gốc `oklch`)

```css
:root {
  --brand-primary: oklch(40% 0.14 160);
  --brand-primary-hover: oklch(34% 0.14 160);
  --brand-primary-active: oklch(29% 0.14 160);
  --brand-primary-subtle: oklch(95% 0.05 160);
  --brand-primary-text: oklch(99% 0 0);
  --surface-base: oklch(99% 0 0);
  --surface-subtle: oklch(97.5% 0 0);
  --surface-overlay: oklch(96% 0 0);
  --surface-header: oklch(95% 0 0);
  --surface-inset: oklch(94% 0 0);
  --surface-dialog: oklch(100% 0 0);
  --overlay-backdrop: oklch(0% 0 0 / 0.4);
  --text-primary: oklch(14% 0 0);
  --text-secondary: oklch(42% 0 0);
  --text-tertiary: oklch(60% 0 0);
  --text-disabled: oklch(74% 0 0);
  --text-inverse: oklch(99% 0 0);
  --text-link: oklch(40% 0.12 245);
  --text-link-hover: oklch(33% 0.12 245);
  --border-subtle: oklch(90% 0 0);
  --border-default: oklch(82% 0 0);
  --border-strong: oklch(62% 0 0);
  --status-success-bg: oklch(95% 0.05 155);
  --status-success-fg: oklch(30% 0.12 155);
  --status-success-border: oklch(80% 0.09 155);
  --status-success-icon: oklch(42% 0.14 155);
  --status-warning-bg: oklch(96% 0.05 75);
  --status-warning-fg: oklch(36% 0.12 75);
  --status-warning-border: oklch(79% 0.12 75);
  --status-warning-icon: oklch(55% 0.16 75);
  --status-danger-bg: oklch(96% 0.04 25);
  --status-danger-fg: oklch(34% 0.14 25);
  --status-danger-border: oklch(80% 0.10 25);
  --status-danger-icon: oklch(49% 0.18 25);
  --status-info-bg: oklch(96% 0.03 245);
  --status-info-fg: oklch(33% 0.12 245);
  --status-info-border: oklch(80% 0.08 245);
  --status-info-icon: oklch(49% 0.14 245);
  --status-neutral-bg: oklch(95% 0 0);
  --status-neutral-fg: oklch(42% 0 0);
  --status-neutral-border: oklch(82% 0 0);
  --status-neutral-icon: oklch(60% 0 0);
  --status-violet-bg: oklch(96% 0.04 290);
  --status-violet-fg: oklch(36% 0.15 290);
  --status-violet-border: oklch(80% 0.13 290);
  --status-violet-icon: oklch(50% 0.20 290);
  --status-cyan-bg: oklch(96% 0.03 200);
  --status-cyan-fg: oklch(33% 0.12 200);
  --status-cyan-border: oklch(80% 0.08 200);
  --status-cyan-icon: oklch(49% 0.14 200);
  --status-pink-bg: oklch(96% 0.04 330);
  --status-pink-fg: oklch(34% 0.14 330);
  --status-pink-border: oklch(80% 0.10 330);
  --status-pink-icon: oklch(49% 0.18 330);
  --status-orange-bg: oklch(96% 0.05 45);
  --status-orange-fg: oklch(36% 0.12 45);
  --status-orange-border: oklch(79% 0.12 45);
  --status-orange-icon: oklch(55% 0.16 45);
  --status-teal-bg: oklch(96% 0.04 180);
  --status-teal-fg: oklch(34% 0.14 180);
  --status-teal-border: oklch(80% 0.10 180);
  --status-teal-icon: oklch(49% 0.18 180);
  --status-indigo-bg: oklch(96% 0.03 270);
  --status-indigo-fg: oklch(33% 0.12 270);
  --status-indigo-border: oklch(80% 0.08 270);
  --status-indigo-icon: oklch(49% 0.14 270);
  --border-focus: var(--brand-primary);
}

[data-theme="dark"] {
  color-scheme: dark;
  --brand-primary: oklch(70% 0.15 160);
  --brand-primary-hover: oklch(76% 0.15 160);
  --brand-primary-active: oklch(82% 0.15 160);
  --brand-primary-subtle: oklch(30% 0.06 160);
  --brand-primary-text: oklch(16% 0.03 160);
  --surface-base: oklch(21% 0 0);
  --surface-subtle: oklch(17% 0 0);
  --surface-overlay: oklch(26% 0 0);
  --surface-header: oklch(19% 0 0);
  --surface-inset: oklch(15% 0 0);
  --surface-dialog: oklch(24% 0 0);
  --overlay-backdrop: oklch(0% 0 0 / 0.6);
  --text-primary: oklch(96% 0 0);
  --text-secondary: oklch(78% 0 0);
  --text-tertiary: oklch(62% 0 0);
  --text-disabled: oklch(46% 0 0);
  --text-inverse: oklch(16% 0 0);
  --text-link: oklch(76% 0.12 245);
  --text-link-hover: oklch(84% 0.12 245);
  --border-subtle: oklch(30% 0 0);
  --border-default: oklch(38% 0 0);
  --border-strong: oklch(54% 0 0);
  --status-success-bg: oklch(28% 0.06 155);
  --status-success-fg: oklch(85% 0.13 155);
  --status-success-border: oklch(45% 0.09 155);
  --status-success-icon: oklch(72% 0.15 155);
  --status-warning-bg: oklch(30% 0.06 75);
  --status-warning-fg: oklch(87% 0.13 75);
  --status-warning-border: oklch(48% 0.10 75);
  --status-warning-icon: oklch(78% 0.16 75);
  --status-danger-bg: oklch(28% 0.07 25);
  --status-danger-fg: oklch(83% 0.13 25);
  --status-danger-border: oklch(46% 0.12 25);
  --status-danger-icon: oklch(70% 0.18 25);
  --status-info-bg: oklch(28% 0.06 245);
  --status-info-fg: oklch(84% 0.11 245);
  --status-info-border: oklch(46% 0.09 245);
  --status-info-icon: oklch(70% 0.14 245);
  --status-neutral-bg: oklch(28% 0 0);
  --status-neutral-fg: oklch(80% 0 0);
  --status-neutral-border: oklch(42% 0 0);
  --status-neutral-icon: oklch(64% 0 0);
  --status-violet-bg: oklch(29% 0.07 290);
  --status-violet-fg: oklch(85% 0.14 290);
  --status-violet-border: oklch(48% 0.13 290);
  --status-violet-icon: oklch(72% 0.20 290);
  --status-cyan-bg: oklch(28% 0.06 200);
  --status-cyan-fg: oklch(84% 0.11 200);
  --status-cyan-border: oklch(46% 0.09 200);
  --status-cyan-icon: oklch(70% 0.14 200);
  --status-pink-bg: oklch(28% 0.07 330);
  --status-pink-fg: oklch(84% 0.13 330);
  --status-pink-border: oklch(46% 0.12 330);
  --status-pink-icon: oklch(70% 0.18 330);
  --status-orange-bg: oklch(30% 0.06 45);
  --status-orange-fg: oklch(86% 0.13 45);
  --status-orange-border: oklch(48% 0.10 45);
  --status-orange-icon: oklch(76% 0.16 45);
  --status-teal-bg: oklch(28% 0.06 180);
  --status-teal-fg: oklch(84% 0.13 180);
  --status-teal-border: oklch(46% 0.10 180);
  --status-teal-icon: oklch(70% 0.18 180);
  --status-indigo-bg: oklch(28% 0.06 270);
  --status-indigo-fg: oklch(84% 0.11 270);
  --status-indigo-border: oklch(46% 0.09 270);
  --status-indigo-icon: oklch(70% 0.14 270);
}
```

Muốn tự theo hệ điều hành như ops-core: lặp khối tối trong `@media screen and (prefers-color-scheme: dark) { :root:not([data-theme="light"]) { … } }`.

## 10. Chỗ lệch nhỏ cần biết

- PWA xưởng khai `theme-color` `#1b5e20` (`apps/shopfloor-pwa/app/layout.tsx:33`), không trùng xanh thương hiệu `#005c2b`.
- Tờ phiếu vận hành (FRM, bản in) dùng bảng riêng trong `apps/admin-web/src/features/operational-forms/ui/forms-base.css`:
  nhấn `#14533c`, viền ô `#5ca180`, dấu đỏ `#9e2b25` / nền `#fbe9e7`, cảnh báo `#8a4b12` / nền `#fbeee0`. M3 không cần theo phần này.
- `apps/admin-web/app/globals.css` (nền `#f7f8fa`, chữ `#1f2933`) là tệp cũ, layout hiện không nạp; không dùng làm chuẩn.
