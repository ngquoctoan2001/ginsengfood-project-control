# Trạng thái — m12

Mốc 18/11 07:55 (T4, phiên mới sau khi Toàn đổi tài khoản Claude) · ops-core `main` = `origin` = `gitlab` = **`cef6861db`** (không commit mới qua đêm; chưa luồng sửa L1–L9 nào commit) ·
`.99` chạy **`565272e01`** từ 17/11 18:18 (D-m12-109, `deploy-99` job 18097073296 ĐẠT, migration 154, sao lưu `20261117T111809Z`) + cấu hình proxy `.98` (D-m12-105) ·
đo 18/11 07:5x từ máy Lead: ops. `/login` 200, pwa. 307, trace. 200, `/api/v1/admin/auth/me` 401 (đúng) · hợp đồng `origin/m12-noi-m3` = `a57a11f`.
Sẵn sàng **47%** (`SAN_SANG.md` 17/11, đã kiểm). Kịp 30/11 **VÀNG**. Mốc (D-m12-088): M-a 17/11 ĐẠT · **M-b 20/11** M3 quan sát (còn 2 ngày) · M-c ≤ 25/11 Production · M-d 28/11 · 30/11.

## Tình hình

- **Sóng 1 (17/11) XONG, bộ đủ `565272e01` XANH** (Unit 9.083/9.084, Integration 1.981/1.981, ApiContract 645/646, Gov 1.103, vitest admin 5.101/PWA 846/trace 359). Log `ra-soat/2026-11-17-song1/`.
  - **WP21** (M12-108 Đạt): đã chạy `.99` (D-m12-108) — M3 v5, M6 v2, kiem-db 7/7, CSV 19 SKU + `WH_FG_MAIN`. m34 lấy token v5 200 (17/11 15:23) + nạp link 15:31; M3 còn `OPS_CORE_ENABLED=false`, quan sát từ 20/11.
  - **WP12g** (M12-109 65%): đợt 1 `db49269e2` + 1b `565272e01` trên `.99`. Lỗi kg app quét phiếu: bản sửa đã chạy, **chưa thử bằng phiếu thật** (thử ở lượt nhập NL kế tiếp).
  - **WP-UAT** (M12-105 42%): 2.312 ca hiệu lực — **1.737 Đạt · 44 KAD · 10 KĐ · 53 BC · 468 chưa chạy ⇒ còn 531**.
- **Máy Lead sau đổi tài khoản:** tiến trình phiên cũ chết ⇒ API thử 5310 cho Phúc (PID 18400) TẮT; lab UAT tắt hết (don_may 07:52 dừng API 5200 mồ côi PID 18552);
  Docker 0 container chạy (postgres-local dừng). Còn: credential v2 `SVC-M3-SELLABLE` trên DB lab 2 ACTIVE; tệp `C:\Projects\_wt\m12\tin-gui-phuc.txt` (có mật khẩu thử) còn trên máy.
- **PUI mở cho WP12g đợt 2:** S3 đóng phiếu NL ghi đè ghi chú (mất số phiếu giao của phiếu quét); S3 "Có thể bán" khi có lô thu hồi (chờ chú); S4 thuế suất bao bì không che;
  S4 nhãn READY_FOR_PACKAGING thô; thiếu test Kg+kg; + m12.109/115/116, FRM-21 422, GTIN-13, RS-5/6/7, TRC-01 phần mã.
- **Rà release** (`ra-soat/2026-11-17-release/00-TONG-HOP.md`, RS-1…10 = D-m12-095…104, host media D-m12-106): 1 P0 + ~27 P1, 9 luồng L1–L9. **Chưa luồng nào mở** ⇒
  đợt A (17–20/11: L1 OPS-01, L2 cổng JWT, L4 BE-02 + BE-01) trễ 1 ngày ⇒ đề xuất gộp vào sóng 2 (WP17b-mã, WP12g đợt 2).
- **MISA chạm M1–M2** (D-m9-005, `hop-thu/lead-2026-11-17-m9-misa-cham-m12.md`, phiên lead chưa chuyển chính thức): chung ClientID, M12 sang họ `amiskt/v1`, M9 nhận callback
  chung rồi chuyển phần `M12:` sang ops-core qua mạng nội bộ `.99` — m12 đề xuất đường nhận + cách ký, Tài cần ~24/11. M12-012 vẫn hoãn (D-m12-002).
- **Sheet M12:** 60 task mở, ~30 task thời `.61`/NM3 quá hạn chưa đóng (M12-005, 007, 031, 036, 038, 043…) ⇒ dọn ở `/cuoi-phien`.

## Cần bạn quyết

- **m12.109** nút "Phê duyệt" màn Phát hành lô (G02-F02) chết, duyệt thật = ký FRM-21: A sửa nút đi đúng đường ký (dùng lại 2 hook sẵn) · B bỏ nút + HDSD. Đề xuất A.
- **m12.115** PUI S2: R-QA-REL không bật được truy xuất công khai (Sổ QR gọi trade-items 403 ⇒ nút mờ): A sửa để QA phát hành bật được · B giao việc bật cho R-OPS-MGR. Đề xuất A.
- **m12.116** PUI S3: FRM-28 Cấp đông / FRM-29 Sấy thăng hoa tự sinh trống giờ/nhiệt độ, ký được dù lệch sự kiện: A lấy số từ sự kiện như phiếu Chế biến · B giữ nhập tay + cảnh báo lệch. Đề xuất A.
- **m12.125** bản thử 5310 cho Phúc (đã tắt, tường lửa chưa mở; phần đọc M12 của Phúc đã khớp `.99`): A dừng hẳn — vô hiệu credential v2 lab 2 + xoá tệp tin có mật khẩu · B bạn mở tường lửa, m12 bật lại. Đề xuất A.
- **m12.126** MISA (D-m9-005): A m12 viết đề xuất hợp đồng chuyển tiếp callback M9 → ops-core + xác nhận M1–M2 không gửi 1555B/154, trước 24/11, mã vẫn sau 30/11 · B hoãn hết. Đề xuất A.
- **m12.127** menu admin-web lệch (tài khoản quản trị dựng sidebar từ cây `ui_menu_item` DB; nhóm Truy vết/Tích hợp bị dàn phẳng, 3 nhóm sai tên, mất 5 mục, sai thứ tự): A sidebar luôn theo cây chuẩn, API chỉ lọc + seed sửa registry + test chặn lệch · B bỏ hẳn menu API, ai cũng dùng cây chuẩn lọc theo quyền. Đề xuất A (nhật ký 18/11 08:4x).
- Việc của bạn: duyệt diff R3 M12-106 (gộp nhánh chú lần 3); gửi tin chú (`ra-soat/2026-11-16-tin-chudung.md`); thử đăng nhập ops. + cài PWA trên điện thoại; khoá M6 cho Tài (nếu chưa).

## Việc chặn

- M3 bật quan sát 20/11: Phúc gộp nhánh chú `0c83bc4a5` vào `dev`; CI repo bán hàng kẹt Billing (m34). WP17b diễn tập 20–21/11 cần mã OPS-01 + cổng JWT xong trước ⇒ giao 18/11.
- Chú Dũng: RS-2, RS-3, RS-4 B, PUI thu hồi/có thể bán chờ tin (chưa gửi).

## Kế tiếp (sóng 2 đề xuất)

1. WP17b-mã (L1 OPS-01 + L2 cổng JWT/build image + compose `extra_hosts`/bí mật public-trace bắt buộc + build arg trace media) R3.
2. WP12g đợt 2 + L4a (BE-02 hạn dùng lô so ngày UTC, BE-01 trần độ dài) — R3 phần BE-02, R2 phần còn. 3. WP-UAT: bật lại lab `565272e01`, 17 ca 1g + 9 bước IT POST + O07, rồi WP03e 130 ca.
4. Tài liệu MISA (nếu m12.126 A). Sau: WP18b, WP22 (sau M3 quan sát), WP-NT, WP11b.
