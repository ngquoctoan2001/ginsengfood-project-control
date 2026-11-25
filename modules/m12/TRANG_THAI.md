# Trạng thái: m12

Mốc 25/11 13:4x (T4). Phiên m12 `M1-2`. Chi tiết lịch sử: `nhat-ky/2026-11-24.md`, `nhat-ky/2026-11-25.md`; quyết định `QUYET_DINH.md` D-m12-130…137.

- **ops-core:** `origin` = `gitlab` = `a0ccc740e`; `main` cục bộ `e98aa9458` hơn 3 commit CHƯA push (`69a901434` công cụ lab UAT-63; `f6b2b5399` bộ chạy nghiệm thu M3 cục bộ có S08–S14; `e98aa9458` dời ghim hợp đồng + ma trận truth). Dời ghim hợp đồng xong (`e98aa9458`), Governance 1128/1128. Dirty không phải của ta: 3 tệp supplier-portal; `next-env.d.ts`/`tsconfig.json`/`AGENTS.md` do `next dev` của lab (khôi phục đúng từng tệp CHỈ sau khi dừng lab).
- **.99:** M1–M2 chạy **`a0ccc740e`** từ 25/11 10:31 (`trien-khai.sh` 18 giây, sao lưu CSDL trước, migrate "không có gì áp"; bản trước `417f15d53` = đường lui). **`ops.ginsengfood.vn` phục vụ code mới** (đã kiểm: tệp JS chỉ có ở bản mới tải được qua tên miền, không có trong ảnh cũ). API vẫn `Development`, compose `.99` vẫn bản WP16 chỉnh tay (WP17b/Production chưa bật), cờ quên mật khẩu TẮT, đăng nhập mail BẬT. **Chưa ghi phiếu thật; 19 SKU nhưng 0 kích hoạt bán, 0 mẻ, 0 giữ hàng.** Kho: `WH-20112026-000001` = nguyên liệu, `…000002` = thành phẩm (cùng tên "Kho Bình Phú", chưa có vị trí kho nào).
- **Mốc** (D-m12-088): M-c ≤ 25/11 Production · nghiệm thu + tập huấn sáng **27/11** · M-d 28/11 · chạy thật 30/11; ngoại lệ JWT hết 30/11 16:59Z. Kịp 30/11: **VÀNG**.
- **Luật:** D-lead-063 (một checkout, khai khoá, chỉ phiên chính commit theo đường dẫn) · D-lead-064 (kiểm hai mức, lên .99 không qua CI). Push, ssh/.99, cờ production, `.env`: chỉ khi Toàn nói rõ cho đúng việc.

## Cổng Nguy hiểm (7 vùng, kiểm độc lập xong 25/11 rạng sáng)

#17, P13, P10, P14, VAT P1b, WP31: ĐẠT sau sửa (F1 `fdba2a1ad`, test P10, P14 `497019c07`, test U02) — tất cả đã trong `a0ccc740e` trên remote và trên .99. **WP32 (quên mật khẩu, cờ TẮT): CẦN SỬA trước khi bật** (chiếm hộp thư ⇒ đặt lại mật khẩu R-ADMIN/R-DEVOPS; kẻ lạ khoá hộp thư 24 giờ). Tổng hợp + bảng quyết: `ra-soat/2026-11-25-cong-nguy-hiem-tong-hop-cho-toan.md`.

## 63 ca nghiệm thu chưa đạt (Toàn lệnh 25/11; phiếu `wp/M12-UAT-63-ca.md`)

Sổ (2.844 dòng, 13:4x): **1.789 đạt · 3 không đạt · 8 bị chặn · 58 KAD · 468 chưa chạy** (2.326). Trong 63 ca: **52 ĐẠT** (9 lỗi phần mềm sửa `4226499b9`/`85d56310f`/`a0ccc740e` + chạy lại trên lab bản mới; vòng tester t1…t10 do các phiên có trình duyệt ghi; mình đếm theo sổ, chưa rà bằng chứng từng ca của t6…t10). **Còn 11:** C04-F03-T02 và C05-F03-T02 (KĐ: lõi nghiệp vụ đúng nhưng thông điệp chặn bị giấu/ca dựng bằng SQL lab), C02-F03-T01, E08-F04-T05, O07-F06-T99/T100 (cần lab 2 + app xưởng), C02-F05-T90, C02-F07-T90, H05-F04-T02, G02-F02-T04 phần PRINTER_DEFERRED (cần API lab 2 khởi động lại với `ReleaseScope__Profile`), E01-F06-T01 (in lệnh SX, hoãn ⇒ ghi Không áp dụng khi chốt). Phiên m12 này KHÔNG có trình duyệt (built-in không còn, Chrome chưa kết nối): các ca còn lại do phiên có trình duyệt chạy. Lab còn chạy (API 5200/5202, admin 3200/3202, app xưởng 3201, bộ thu 5299); dừng: `lab.ps1`/`lab2.ps1 -Action all-stop -ArtifactsName UAT63` + dừng bộ thu + khôi phục `next-env.d.ts`.

## Nối M12 ↔ M3 (Sheet 67 việc: ~30 hoàn thành; chi tiết `ra-soat/2026-11-25-noi-m3-ke-hoach-chot.md`)

- **Hợp đồng:** `main` = `a57a11f` (fast-forward 45 commit, D-m12-136). Dời ghim ops-core `1e73bc1` → `a57a11f` + ma trận truth: coder `m12/pin-hd` đang làm (Governance có 3 ca đỏ đúng vùng ghim cho tới khi xong).
- **Bằng chứng 25/11** (`ra-soat/2026-11-25-doc-99-va-nghiem-thu-m3-cuc-bo.md`): M3 trên .99 ĐÃ bật quan sát, 24 giờ 627 lần hỏi bán được + 8 token + 1 `/v1/skus` đều 200, 0 lỗi 401/403/429; principal `SVC-M3-SELLABLE` ACTIVE 10 quyền. Bộ nghiệm thu M3 cục bộ **25/25 PASS** (18 ca §6/ca 14/C37 + S08–S14 giữ/nhả/hết hạn/xác nhận/xuất bán), parser M3 0 lỗi; chưa chạy trên .99.
- **m12.203 = A:** buổi 27/11 làm MẺ THẬT đầu tiên, M3 giữ quan sát. Chưa làm trên .99: kích hoạt bán 1 SKU, nguyên liệu/nhà cung cấp thật, nội dung công khai đã duyệt, vị trí kho (Toàn chuẩn bị tối 26/11). Tin Phúc đã gửi (có câu sai về kho ⇒ cần đính chính, bản ở `ra-soat/2026-11-25-tin-phuc-noi-m3.md`).
- **Còn:** NM3-45b (S01–S18 trên .99) chờ mẻ bán được; NM3-43/44/51b/60/62/99 theo sau; phía Phúc: bật `STOCK_BALANCES` sau khi có tồn, đẩy bản M3 lên kho chung, ghim hợp đồng mới. Khi lên Production: đặt allowlist `/v1` gồm dải `172.24.2.0/24` và đo lại bằng lời gọi thật của M3.

## Còn nợ (không chặn 27/11)

WP17b: OPS-01 kho bằng chứng (chờ m12.207), hồ sơ đóng ngoại lệ JWT (cần Toàn xác nhận khoá mới ≠ khoá lịch sử; hạn 30/11 16:59Z), compose Production lên .99, 2 smoke Docker chưa chạy · WP28 cổng bố cục (1,5–2 ngày) chưa chạy · lịch CI đêm chưa tạo (cần token GitLab) · app xưởng còn bảng tên vai cũ; tên menu "Ngưỡng cảnh báo nguyên liệu" · WP26 chờ duyệt diff R3 đợt 2 · còn worktree phụ ở ops-core (`tools/don_wt.py`).

## Cần Toàn quyết / làm tay

- **m12.223 (đã sửa):** KHÔNG ngừng kho nào (D-m12-137). Chờ Toàn nói tên mới để đổi tên hiển thị hai kho (màn Kho › Sửa; gợi ý "Kho nguyên liệu Bình Phú"/"Kho thành phẩm Bình Phú"); thêm 1 vị trí mỗi kho. **Đính chính Phúc một dòng** (kho còn lại là kho nguyên liệu, không ngừng).
- **Cổng Nguy hiểm m12.208 · 210–217** (ô ký phiếu nhập kho, admin tạo user R-BOD, loại SKU, tên nhóm, đặt lại mật khẩu/gỡ vai, WP32): đề xuất A trừ 208, 210, 216, 217 (B), ở mục 4 của tổng hợp cổng.
- **m12.207** OPS-01 kho bằng chứng (A nới điều kiện "quét sạch" – đề xuất) · **m12.204** hàng thành phẩm làm trước 30/11 có bán qua M3 không (mẻ 27/11 thật ⇒ nhiều khả năng có) · m12.109/115/116 (WP12g còn lại) · GitLab token cho lịch CI đêm · xác nhận khoá JWT mới.
- **Chuẩn bị tối 26/11 (Toàn):** `wp/M12-010-bo-sang-27-11.md` §1 (ca, vị trí kho, NCC + vật tư thật, kích hoạt bán 1 SKU, nội dung công khai đã duyệt); Lan + chú Dũng báo nguyên liệu/NCC thật trước đó. Tin mời 27/11 (`ra-soat/2026-11-24-tin-nghiem-thu-27-11.md`) đã sửa thành "mẻ thật"; nếu bản cũ đã gửi thì nhắn bổ sung.

## Kế tiếp

1. Đọc diff + commit phần dời ghim của `m12/pin-hd` khi xong; cập nhật Sheet NM3-33/M12-049.
2. Chạy lại Governance đủ sau khi ghim xong; push khi Toàn ra lệnh (2 commit + phần ghim).
3. Sửa WP32 (chặn đặt lại mật khẩu cho tài khoản quản trị, mở khoá hộp thư) sau khi Toàn duyệt bảng cổng.
4. Chuẩn bị 27/11: kịch bản, tập vai, danh sách chuẩn bị; sau buổi: NM3-45b trên .99 với mẻ thật.
