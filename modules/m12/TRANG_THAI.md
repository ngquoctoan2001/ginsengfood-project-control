# Trạng thái: m12

Mốc 24/11 18:1x (T3). Cập nhật bởi phiên m12 `M1-2` (tài khoản mới) sau khi đọc phiên m12 fork `874c329c` (21–23/11) và hộp thư lead 24/11.

- **ops-core:** `main` = `origin` = `gitlab` = `417f15d53` (21/11 21:48) ⇒ **0 commit chưa push**. 3 tệp dirty supplier-portal (`FeedbackDialog.tsx`, `IntakeActivitySection.tsx`, `FeedbackPackagingDialog.tsx`) không thuộc WP30–33, chủ chưa rõ ⇒ làm né.
- **.99:** M1–M2 chạy `417f15d53` từ 23/11 18:4x (migration 160 + 14 seed production 2 lượt, D-m12-133/134), DB sạch `ginsengfood_ops_production`. Cờ quên mật khẩu TẮT, đăng nhập mail BẬT, `.env` không đụng. Số liệu theo báo cáo của phiên fork, **chưa đọc lại .99 trong phiên này**.
- **Sẵn sàng:** 47% (`SAN_SANG.md` 17/11, chưa tính lại). Kịp 30/11: **VÀNG** (WP17b mã chưa ai làm).
- **Mốc** (D-m12-088): M-c ≤ 25/11 Production · nghiệm thu + tập huấn sáng 27/11 · M-d 28/11 · chạy thật 30/11; ngoại lệ JWT hết 30/11 16:59Z.
- **Luật:** D-lead-063 (một checkout, khai khoá `tools/khoa_tep.py`, chỉ phiên chính commit theo đường dẫn) · D-lead-064 (kiểm hai mức, CI không chạy khi push, lên .99 không qua CI).
- **Khoá tệp:** `m12/nong` đã giải 24/11 18:0x (tệp khoá đã commit sạch trong `417f15d53`); hiện không có khoá nào.

## Đã làm từ 21/11 (nguồn: `wp/M12-WP30-33-gop-y-20-11.md`, `QUYET_DINH.md` D-m12-130…134)

- **11 góp ý 20/11:** xong mã cả 11, đã lên .99. WP30, WP31, WP32 kiểm độc lập ĐẠT; cờ quên mật khẩu vẫn TẮT.
- **WP33 (thứ hay đổi sửa được trên màn): 25/25 gói + gói dọn xong mã**, mức Thường (coder test lọc + đọc diff), đã lên .99: P1a/P1b, P2, P3a/P3b, P4, P5, P6, P8a/P8b, P9, P10, P11, P13, P14, P15, #17.
- **Lên .99 không qua CI** (D-m12-133): dựng 5 ảnh ở máy Lead, `docker save | ssh`, `trien-khai.sh`. Hai lượt: `b51361ad7` (21/11 16:31) rồi `417f15d53` (23/11 18:47, sau khi Toàn chọn A cho m12.205).
- **Dữ liệu mặc định có trên .99:** 11 tiêu chí QC, 3 nhóm + 2 loại SKU, 4 quyền mới (kế toán, kế hoạch, kiểm toán, ban giám đốc, QA cần đăng nhập lại), 19 mức cảnh báo tồn, 119 dòng chính sách NL, lý do mới, 1 bộ lời quảng cáo.
- **Chưa thử ghi phiếu thật trên .99**; phiên fork chỉ kiểm chỉ đọc (health 200, đăng nhập, tên miền).

## Còn nợ (không chặn M-c)

- App xưởng vẫn dùng bảng tên vai cũ (phiên đăng nhập chưa trả tên vai); bảng nhu cầu sản xuất còn 1 chỗ kiểm theo tên vai.
- Tên menu "Ngưỡng cảnh báo nguyên liệu" chưa đổi; bảng chính sách cảnh báo tồn cũ (chỉ đọc) còn hiện; kích hoạt SKU chưa tự tạo dòng kế hoạch NL; chữ cố định trang truy xuất cần đổi hợp đồng công khai (việc phiên lead).
- **Phiếu ĐANG LÀM không phiên nào chạy:** WP24, WP25, WP27, WP28 (cổng chưa chạy, gồm bộ dò bố cục chạy app thật), WP12g đợt 2, WP-UAT sóng 0; WP26 chờ Toàn duyệt diff R3 đợt 2. Chưa rà lại.
- **WP17b mã:** OPS-01 kho bằng chứng, cổng JWT sau 30/11 16:59Z (hiện chỉ có nhánh gia hạn lần 3 ⇒ sau mốc đó không ra image), compose Production. `deploy/m12/**` chưa ai sửa từ 17/11.
- Lịch CI đêm 01:30 chưa tạo (cần token GitLab, Toàn quyết có/không). `git_tong_quan` thấy ops-core còn 4 worktree phụ (lead báo đã dọn 123 mục `_wt` 21/11): kiểm rồi dọn bằng `tools/don_wt.py`, nhắn phiên m12 kia trước.

## Cổng Nguy hiểm 25–27/11 (Toàn duyệt diff từng vùng trước khi bật cờ thật)

Đăng nhập/phân quyền: WP31, WP32, P10, P13, #17 · migration: P14 (migration 160) · tiền: VAT P1b. Mỗi vùng một lượt kiểm độc lập tối đa 2 giờ; chưa chạy.

## Cần Toàn quyết (m12.200–204 còn mở; m12.205 đã trả A = D-m12-134)

- **m12.200** nhận gói nào: A WP17b mã · B cổng WP28 · C WP-UAT. Đề xuất A.
- **m12.201** tin mời nghiệm thu + tập huấn sáng 27/11 và sửa kịch bản M12-010 theo .99 DB sạch. Đề xuất có, **làm hôm nay 24/11**.
- **m12.202** 6 phiếu bỏ dở: A rà nhanh 1 scout rồi gộp · B để sau. Đề xuất A.
- **m12.203** cách có mẻ bán được qua M3 (M3 đã nối kho + 19/19 SKU, M12 trả "không bán được" đúng thiết kế): A mẻ thật đầu tiên với xưởng · B mẻ thử qua API rồi khoá bán · C chờ 30/11.
- **m12.204** hàng thành phẩm làm trước 30/11 có cần bán qua M3 không (có ⇒ luồng nhập lô TP cũ, R3).

## Kế tiếp (theo `hop-thu/m12-2026-11-24-viec-hoan-thien.md`, Lead 24/11)

1. m12.201 (tin mời + kịch bản M12-010) → 2. WP17b mã (khai khoá `deploy/m12/**`, coder + tester độc lập + verifier ở cổng) → 3. m12.202 rà 6 phiếu + WP28 cổng → 4. chuẩn bị diff cổng Nguy hiểm → 5. đọc lại .99 (chỉ đọc) trước M-c.
Hai phiên m12: `cf1de578` giữ WP30–33, `874c329c` giữ m12.200 trở đi; phiên nào không chạy thì phiên kia nhận phần đó. Push, lên .99, cờ production, `.env`, bật cờ quên mật khẩu: chỉ khi Toàn nói rõ.
