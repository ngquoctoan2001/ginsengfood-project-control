# Trạng thái: m12

Mốc 25/11 13:4x (T4). Phiên m12 `M1-2`. Chi tiết lịch sử: `nhat-ky/2026-11-24.md`, `nhat-ky/2026-11-25.md`; quyết định `QUYET_DINH.md` D-m12-130…137.

- **ops-core:** `origin` = `gitlab` = `a0ccc740e`; `main` cục bộ `1472c5a5a` hơn **12 commit CHƯA push** (`69a901434` lab UAT-63; `f6b2b5399` bộ nghiệm thu M3 cục bộ; `e98aa9458` dời ghim hợp đồng `a57a11f`; `6a104b28e` giáo án/HDSD 27/11; `ec942c357` OPS-01; `397fefb24` F2/F3; `f45a5ab77` chú thích; `ae147decf` m12.211; `007cea669` WP32+S3; `710b89a01` gói chuyển Production; `c4381dcbf` vá S3 vòng 2; `1472c5a5a` sửa gói Production sau verifier). Kiểm độc lập vòng 2 xong (`ra-soat/2026-11-25-kiem-doc-lap-vong2.md`): mã đăng nhập/phân quyền 4/4 ĐẠT; gói Production CẦN SỬA 6 S2 ⇒ đã sửa (`1472c5a5a`), verifier V2 lượt 2 ĐẠT; coder `m12/prod99-fix2` đang sửa P2/P3 (không được làm mất khoá bằng chứng) + 7 ghi chú S3 (chưa commit), vá S3 vai INACTIVE xong (`c4381dcbf`). Dirty không phải của ta: 3 tệp supplier-portal; `next-env.d.ts`/`tsconfig.json` do `next dev` của lab.
- **.99:** M1–M2 chạy **`a0ccc740e`** từ 25/11 10:31 (chưa có `466245762`, `4b3655cc3`) (`trien-khai.sh` 18 giây, sao lưu CSDL trước, migrate "không có gì áp"; bản trước `417f15d53` = đường lui). **`ops.ginsengfood.vn` phục vụ code mới** (đã kiểm: tệp JS chỉ có ở bản mới tải được qua tên miền, không có trong ảnh cũ). API vẫn `Development`, compose `.99` vẫn bản WP16 chỉnh tay (WP17b/Production chưa bật), cờ quên mật khẩu TẮT, đăng nhập mail BẬT. **Chưa ghi phiếu thật; 19 SKU nhưng 0 kích hoạt bán, 0 mẻ, 0 giữ hàng.** Kho: `WH-20112026-000001` = nguyên liệu, `…000002` = thành phẩm (cùng tên "Kho Bình Phú", chưa có vị trí kho nào).
- **Mốc** (D-m12-088): M-c ≤ 25/11 Production · nghiệm thu + tập huấn sáng **27/11** · M-d 28/11 · chạy thật 30/11; ngoại lệ JWT hết 30/11 16:59Z. Kịp 30/11: **VÀNG**.
- **Luật:** D-lead-063 (một checkout, khai khoá, chỉ phiên chính commit theo đường dẫn) · D-lead-064 (kiểm hai mức, lên .99 không qua CI). Push, ssh/.99, cờ production, `.env`: chỉ khi Toàn nói rõ cho đúng việc.

## Cổng Nguy hiểm (7 vùng, kiểm độc lập xong 25/11 rạng sáng)

#17, P13, P10, P14, VAT P1b, WP31: ĐẠT sau sửa (F1 `fdba2a1ad`, test P10, P14 `497019c07`, test U02) — tất cả đã trong `a0ccc740e` trên remote và trên .99. **WP32 (quên mật khẩu, cờ TẮT): đã sửa S1/S3 (`007cea669`), chờ verifier vòng 2 rồi mới được bật cờ.** Admin quên mật khẩu: nhờ admin khác đặt lại ở màn Người dùng. Tổng hợp + bảng quyết: `ra-soat/2026-11-25-cong-nguy-hiem-tong-hop-cho-toan.md`.

## 63 ca nghiệm thu chưa đạt (Toàn lệnh 25/11): XONG phần chạy lại, 25/11 14:3x (phiếu `wp/M12-UAT-63-ca.md`)

Sổ nghiệm thu 2.326 bước: **1.799 đạt · 0 không đạt · 0 bị chặn · 59 không áp dụng · 468 chưa chạy** (đầu ngày 1.737 · 10 · 53 · 58 · 468). 62 ca ĐẠT trên lab bản `a0ccc740e`, E01-F06-T01 (in lệnh SX) chuyển Không áp dụng (D-m12-002/006, tiền lệ D-m12-103). Lỗi thật đã sửa + commit: QR/trang công khai `4226499b9`, phiếu cấp đông/sấy `85d56310f`, Gán tôi + lý do QC `a0ccc740e`, liên kết MRP `466245762`, câu chặn rõ lý do `4b3655cc3` (+ test thu hồi `2f763f04c`). 39 ca gắn `catalog_correction_pending` (sửa sổ tay, không đổi code). Chi tiết + quyết m12.230–224: `ra-soat/2026-11-25-63-ca-ket-qua.md`. Lab đã dừng, tệp `next-env.d.ts` khôi phục, build lab xoá.

## Nối M12 ↔ M3 (Sheet 67 việc: ~30 hoàn thành; chi tiết `ra-soat/2026-11-25-noi-m3-ke-hoach-chot.md`)

- **Hợp đồng:** `main` = `a57a11f` (fast-forward 45 commit, D-m12-136). Dời ghim ops-core `1e73bc1` → `a57a11f` + ma trận truth: coder `m12/pin-hd` đang làm (Governance có 3 ca đỏ đúng vùng ghim cho tới khi xong).
- **Bằng chứng 25/11** (`ra-soat/2026-11-25-doc-99-va-nghiem-thu-m3-cuc-bo.md`): M3 trên .99 ĐÃ bật quan sát, 24 giờ 627 lần hỏi bán được + 8 token + 1 `/v1/skus` đều 200, 0 lỗi 401/403/429; principal `SVC-M3-SELLABLE` ACTIVE 10 quyền. Bộ nghiệm thu M3 cục bộ **25/25 PASS** (18 ca §6/ca 14/C37 + S08–S14 giữ/nhả/hết hạn/xác nhận/xuất bán), parser M3 0 lỗi; chưa chạy trên .99.
- **m12.203 = A:** buổi 27/11 làm MẺ THẬT đầu tiên, M3 giữ quan sát. Chưa làm trên .99: kích hoạt bán 1 SKU, nguyên liệu/nhà cung cấp thật, nội dung công khai đã duyệt, vị trí kho (Toàn chuẩn bị tối 26/11). Tin Phúc đã gửi (có câu sai về kho ⇒ cần đính chính, bản ở `ra-soat/2026-11-25-tin-phuc-noi-m3.md`).
- **Còn:** NM3-45b (S01–S18 trên .99) chờ mẻ bán được; NM3-43/44/51b/60/62/99 theo sau; phía Phúc: bật `STOCK_BALANCES` sau khi có tồn, đẩy bản M3 lên kho chung, ghim hợp đồng mới. Khi lên Production: đặt allowlist `/v1` gồm dải `172.24.2.0/24` và đo lại bằng lời gọi thật của M3.

## Còn nợ (không chặn 27/11)

WP17b: OPS-01 kho bằng chứng (chờ m12.207), hồ sơ đóng ngoại lệ JWT (cần Toàn xác nhận khoá mới ≠ khoá lịch sử; hạn 30/11 16:59Z), compose Production lên .99, 2 smoke Docker chưa chạy · WP28 cổng bố cục (1,5–2 ngày) chưa chạy · lịch CI đêm chưa tạo (cần token GitLab) · app xưởng còn bảng tên vai cũ; tên menu "Ngưỡng cảnh báo nguyên liệu" · WP26 chờ duyệt diff R3 đợt 2 · còn worktree phụ ở ops-core (`tools/don_wt.py`).

## Cần Toàn quyết / làm tay

- **m12.237 (mới):** cho chạy **P0 chỉ đọc** của gói Production trên `.99` TRƯỚC 27/11 (một lệnh ssh đọc, không ghi): cho biết `.env` có khoá mã hoá bằng chứng chưa, kho bằng chứng có bao nhiêu tệp rõ/mã hoá, ma trận ký 3 phiếu nhập kho, phiên bản Compose. Cần để biết bằng chứng tải ở buổi 27/11 có sang Production 28/11 được không. Mình đề xuất CÓ.
- **m12.238 (mới):** đưa ảnh mới (mọi code từ F1 đến vá S3) lên `.99` ở chế độ Development sớm sáng 26/11 (dựng 5 ảnh từ đúng commit, `trien-khai.sh`, có đường lui `417f15d53`→`a0ccc740e`) để nhập dữ liệu nền và buổi 27/11 chạy trên đúng mã đã kiểm; chuyển Production để 28/11. Cần bạn nói rõ push + lên `.99`; mình đề xuất CÓ (sau khi `prod99-fix2` xong).
- **m12.236 (mới, verifier vòng 2):** quản trị (R-ADMIN/R-DEVOPS/ADMIN_FULL) vẫn đăng nhập được bằng mã mail công ty; chiếm hộp thư của quản trị ⇒ phiên quản trị. A (đề xuất): chấp nhận + ghi "hộp thư công ty là yếu tố đăng nhập của quản trị" (mail do IT quản, bạn đang dùng). B: chặn LOGIN bằng mã mail cho quản trị, quản trị chỉ vào bằng mật khẩu. Chỉ cần trả lời trước khi BẬT cờ quên mật khẩu; đăng nhập mail đã BẬT sẵn trên `.99`.

- **m12.223 (đã sửa):** KHÔNG ngừng kho nào (D-m12-137). Chờ Toàn nói tên mới để đổi tên hiển thị hai kho (màn Kho › Sửa; gợi ý "Kho nguyên liệu Bình Phú"/"Kho thành phẩm Bình Phú"); thêm 1 vị trí mỗi kho. **Đính chính Phúc một dòng** (kho còn lại là kho nguyên liệu, không ngừng).
- **Cổng Nguy hiểm m12.208 · 210–217** (ô ký phiếu nhập kho, admin tạo user R-BOD, loại SKU, tên nhóm, đặt lại mật khẩu/gỡ vai, WP32): đề xuất A trừ 208, 210, 216, 217 (B), ở mục 4 của tổng hợp cổng.
- **m12.207** OPS-01 kho bằng chứng (A nới điều kiện "quét sạch" – đề xuất) · **m12.204** hàng thành phẩm làm trước 30/11 có bán qua M3 không (mẻ 27/11 thật ⇒ nhiều khả năng có) · m12.109/115/116 (WP12g còn lại) · GitLab token cho lịch CI đêm · xác nhận khoá JWT mới.
- **Chuẩn bị tối 26/11 (Toàn):** `wp/M12-010-bo-sang-27-11.md` §1 (ca, vị trí kho, NCC + vật tư thật, kích hoạt bán 1 SKU, nội dung công khai đã duyệt); Lan + chú Dũng báo nguyên liệu/NCC thật trước đó. Tin mời 27/11 (`ra-soat/2026-11-24-tin-nghiem-thu-27-11.md`) đã sửa thành "mẻ thật"; nếu bản cũ đã gửi thì nhắn bổ sung.

## Kế tiếp

1. Nhận báo cáo 2 verifier vòng 2: sửa phát hiện S1/S2 (coder mới), chạy lại verifier cho đúng phần sửa.
2. Push và lên `.99` (Production) chỉ khi Toàn ra lệnh đúng việc; gói `deploy/m12/chuyen-production-99/` cần Toàn duyệt SHA + 2 băm + khoá JWT mới ≠ khoá lịch sử.
4. Chuẩn bị 27/11: kịch bản, tập vai, danh sách chuẩn bị; sau buổi: NM3-45b trên .99 với mẻ thật.
