# Trạng thái: m12

Mốc 25/11 13:4x (T4). Phiên m12 `M1-2`. Chi tiết lịch sử: `nhat-ky/2026-11-24.md`, `nhat-ky/2026-11-25.md`; quyết định `QUYET_DINH.md` D-m12-130…137.

- **ops-core:** `main` `d4163331c` hơn `origin`/`gitlab` (`7c7d07234`, đã push 25/11 theo D-m12-138) 2 commit chưa push: `973225ac4` SOP kho NM3-44 + `d4163331c` **vá lỗi offset +07:00** (inbox sự kiện nhu cầu + `expires_at` giữ hàng, 26/11 00:19; unit 10.766, Governance 1130, ApiContract mới 20, Integration lát 87 đều xanh; bản `.99` `7c7d07234` CHƯA có bản vá). Kiểm độc lập vòng 2 xong; verifier V2 lượt 3 đang chấm P2/P3 khoá bằng chứng (`ra-soat/2026-11-25-kiem-doc-lap-vong2.md`). Dirty không phải của ta: 3 tệp supplier-portal; `next-env.d.ts`/`tsconfig.json` do `next dev` của lab.
- **.99:** M1–M2 chạy **`7c7d07234`** từ 25/11 21:08 (`trien-khai.sh` kèm sao lưu CSDL, migrate không có gì áp, 6 dịch vụ healthy, M3 gọi bình thường; đường lui `a0ccc740e`). API vẫn `Development`, compose/`.env`/cờ chưa đổi (quên mật khẩu TẮT, đăng nhập mail BẬT). **Khoá mã hoá bằng chứng đã đặt (D-m12-139, 25/11 21:3x)**: bằng chứng tải từ giờ được mã hoá; P0 chỉ đọc: còn 1 HỎNG (1 tệp bản rõ cũ, ảnh thử 20/11, chuyển đi lúc chuyển Production). **Toàn tự cất bản sao khoá** (terminal riêng, không qua phiên này). Chưa ghi phiếu thật; 19 SKU, 0 kích hoạt bán, 0 mẻ, 0 giữ hàng. Kho: `…000001` nguyên liệu, `…000002` thành phẩm (cùng tên, 0 vị trí kho).
- **Mốc** (D-m12-088): M-c ≤ 25/11 Production · nghiệm thu + tập huấn sáng **27/11** · M-d 28/11 · chạy thật 30/11; ngoại lệ JWT hết 30/11 16:59Z. Kịp 30/11: **VÀNG**.
- **Luật:** D-lead-063 (một checkout, khai khoá, chỉ phiên chính commit theo đường dẫn) · D-lead-064 (kiểm hai mức, lên .99 không qua CI). Push, ssh/.99, cờ production, `.env`: chỉ khi Toàn nói rõ cho đúng việc.

## Cổng Nguy hiểm (7 vùng, kiểm độc lập xong 25/11 rạng sáng)

#17, P13, P10, P14, VAT P1b, WP31: ĐẠT sau sửa (F1 `fdba2a1ad`, test P10, P14 `497019c07`, test U02) — tất cả đã trong `a0ccc740e` trên remote và trên .99. **WP32 (quên mật khẩu, cờ TẮT): đã sửa S1/S3 (`007cea669`), chờ verifier vòng 2 rồi mới được bật cờ.** Admin quên mật khẩu: nhờ admin khác đặt lại ở màn Người dùng. Tổng hợp + bảng quyết: `ra-soat/2026-11-25-cong-nguy-hiem-tong-hop-cho-toan.md`.

## 63 ca nghiệm thu chưa đạt (Toàn lệnh 25/11): XONG phần chạy lại, 25/11 14:3x (phiếu `wp/M12-UAT-63-ca.md`)

Sổ nghiệm thu 2.326 bước (26/11 00:3x: **1.810 đạt · 0 không đạt** · 0 bị chặn · 59 không áp dụng · 457 chưa chạy; 4 ca đỏ do lỗi offset +07:00 đã vá `d4163331c` và chạy lại Đạt, xem `wp/M12-UAT-468-ca.md`); đầu đợt 63 ca: **1.799 đạt · 0 không đạt · 0 bị chặn · 59 không áp dụng · 468 chưa chạy** (đầu ngày 1.737 · 10 · 53 · 58 · 468). 62 ca ĐẠT trên lab bản `a0ccc740e`, E01-F06-T01 (in lệnh SX) chuyển Không áp dụng (D-m12-002/006, tiền lệ D-m12-103). Lỗi thật đã sửa + commit: QR/trang công khai `4226499b9`, phiếu cấp đông/sấy `85d56310f`, Gán tôi + lý do QC `a0ccc740e`, liên kết MRP `466245762`, câu chặn rõ lý do `4b3655cc3` (+ test thu hồi `2f763f04c`). 39 ca gắn `catalog_correction_pending` (sửa sổ tay, không đổi code). Chi tiết + quyết m12.230–224: `ra-soat/2026-11-25-63-ca-ket-qua.md`. Lab đã dừng, tệp `next-env.d.ts` khôi phục, build lab xoá.

## Nối M12 ↔ M3 (Sheet 67 việc: ~30 hoàn thành; chi tiết `ra-soat/2026-11-25-noi-m3-ke-hoach-chot.md`)

- **Hợp đồng:** `main` = `a57a11f` (fast-forward 45 commit, D-m12-136). Dời ghim ops-core `1e73bc1` → `a57a11f` + ma trận truth: coder `m12/pin-hd` đang làm (Governance có 3 ca đỏ đúng vùng ghim cho tới khi xong).
- **Bằng chứng 25/11** (`ra-soat/2026-11-25-doc-99-va-nghiem-thu-m3-cuc-bo.md`): M3 trên .99 ĐÃ bật quan sát, 24 giờ 627 lần hỏi bán được + 8 token + 1 `/v1/skus` đều 200, 0 lỗi 401/403/429; principal `SVC-M3-SELLABLE` ACTIVE 10 quyền. Bộ nghiệm thu M3 cục bộ **25/25 PASS** (18 ca §6/ca 14/C37 + S08–S14 giữ/nhả/hết hạn/xác nhận/xuất bán), parser M3 0 lỗi; chưa chạy trên .99.
- **m12.203 = A:** buổi 27/11 làm MẺ THẬT đầu tiên, M3 giữ quan sát. Chưa làm trên .99: kích hoạt bán 1 SKU, nguyên liệu/nhà cung cấp thật, nội dung công khai đã duyệt, vị trí kho (Toàn chuẩn bị tối 26/11). Tin Phúc đã gửi (có câu sai về kho ⇒ cần đính chính, bản ở `ra-soat/2026-11-25-tin-phuc-noi-m3.md`).
- **Còn:** NM3-45b (S01–S18 trên .99) chờ mẻ bán được; NM3-43/44/51b/60/62/99 theo sau; phía Phúc: bật `STOCK_BALANCES` sau khi có tồn, đẩy bản M3 lên kho chung, ghim hợp đồng mới. Khi lên Production: đặt allowlist `/v1` gồm dải `172.24.2.0/24` và đo lại bằng lời gọi thật của M3.

## Còn nợ (không chặn 27/11)

WP17b: OPS-01 kho bằng chứng (chờ m12.207), hồ sơ đóng ngoại lệ JWT (cần Toàn xác nhận khoá mới ≠ khoá lịch sử; hạn 30/11 16:59Z), compose Production lên .99, 2 smoke Docker chưa chạy · WP28 cổng bố cục (1,5–2 ngày) chưa chạy · lịch CI đêm chưa tạo (cần token GitLab) · app xưởng còn bảng tên vai cũ; tên menu "Ngưỡng cảnh báo nguyên liệu" · WP26 chờ duyệt diff R3 đợt 2 · còn worktree phụ ở ops-core (`tools/don_wt.py`).

## Cần Toàn quyết / làm tay

- **m12.240 / 241 / 242 (mới):** (240) giữ đường M3→M12 qua IP máy `.99:5000` đến sau 30/11, đóng NM3-52/71 chấp nhận — đề xuất A; (241) cắt SKU-M12-08 (sự kiện vòng đời SKU, M3 đã kéo `/v1/skus`) — đề xuất A; (242) SEC-18: tác vụ 15 phút trên máy Toàn đọc `.99` chỉ đọc rồi báo thông báo Windows — đề xuất A, cần bạn nói rõ mới tạo lịch. Chi tiết `ra-soat/2026-11-25-34-viec-noi-m3-con-lai.md`.
- **m12.243 (mới, 26/11):** push 2 commit chưa push (`973225ac4`, `d4163331c`) và đưa bản vá offset lên `.99` Development (build lại 5 ảnh, `trien-khai.sh`, có sao lưu CSDL, ~2 phút gián đoạn M3) — đề xuất CÓ cả hai, nhưng là hai việc riêng, mỗi việc cần bạn nói rõ; làm trước tối 26/11 để mẻ thật 27/11 chạy trên bản đã vá. M3 gọi `expires_at` kiểu `Z` nên chưa bị lỗi, đây là phòng khi ai gửi giờ `+07:00`.
- **468 ca giao diện chưa chạy cần phiên CÓ trình duyệt:** phiên m12 này không có Chrome kết nối (danh sách rỗng). Bạn nối Chrome vào phiên này, hoặc mở các phiên tester có Chrome rồi gõ "chạy lô L01…L25 trong `wp/M12-UAT-468-ca.md`". 25 lô đã chia sẵn.


- **Đã quyết D-m12-138 (19:5x):** m12.236 = A (mã mail là yếu tố đăng nhập của quản trị, không chặn); m12.237 = CÓ (chạy P0 chỉ đọc trên `.99` sau khi `prod99-fix2` xong); m12.238 = CÓ (push + đưa ảnh mới lên `.99` Development ngay khi sẵn sàng, trước tối 26/11; Production để 28/11, lệnh riêng). Đang làm: dựng ảnh (cache làm nóng từ `c4381dcbf`), chờ `m12/prod99-fix2`.


- **m12.223 (đã sửa):** KHÔNG ngừng kho nào (D-m12-137). Chờ Toàn nói tên mới để đổi tên hiển thị hai kho (màn Kho › Sửa; gợi ý "Kho nguyên liệu Bình Phú"/"Kho thành phẩm Bình Phú"); thêm 1 vị trí mỗi kho. **Đính chính Phúc một dòng** (kho còn lại là kho nguyên liệu, không ngừng).
- **Cổng Nguy hiểm m12.208 · 210–217** (ô ký phiếu nhập kho, admin tạo user R-BOD, loại SKU, tên nhóm, đặt lại mật khẩu/gỡ vai, WP32): đề xuất A trừ 208, 210, 216, 217 (B), ở mục 4 của tổng hợp cổng.
- **m12.207** OPS-01 kho bằng chứng (A nới điều kiện "quét sạch" – đề xuất) · **m12.204** hàng thành phẩm làm trước 30/11 có bán qua M3 không (mẻ 27/11 thật ⇒ nhiều khả năng có) · m12.109/115/116 (WP12g còn lại) · GitLab token cho lịch CI đêm · xác nhận khoá JWT mới.
- **Chuẩn bị tối 26/11 (Toàn):** `wp/M12-010-bo-sang-27-11.md` §1 (ca, vị trí kho, NCC + vật tư thật, kích hoạt bán 1 SKU, nội dung công khai đã duyệt); Lan + chú Dũng báo nguyên liệu/NCC thật trước đó. Tin mời 27/11 (`ra-soat/2026-11-24-tin-nghiem-thu-27-11.md`) đã sửa thành "mẻ thật"; nếu bản cũ đã gửi thì nhắn bổ sung.

## Kế tiếp

1. Nhận báo cáo 2 verifier vòng 2: sửa phát hiện S1/S2 (coder mới), chạy lại verifier cho đúng phần sửa.
2. Push và lên `.99` (Production) chỉ khi Toàn ra lệnh đúng việc; gói `deploy/m12/chuyen-production-99/` cần Toàn duyệt SHA + 2 băm + khoá JWT mới ≠ khoá lịch sử.
4. Chuẩn bị 27/11: kịch bản, tập vai, danh sách chuẩn bị; sau buổi: NM3-45b trên .99 với mẻ thật.
