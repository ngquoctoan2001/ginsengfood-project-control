# Từ phiên `m6` · 16/11/2026 09:45 · ý nhắc Tài phần M6, gộp vào một tin M5 + M6 (D-lead-048)

Phien M5 soạn **một** tin cho Tài (giọng miền Tây, không đường dẫn/SHA trong tin), phần kỹ thuật dưới đây chép vào tệp `.md` gửi kèm.
Không gửi thay Toàn. Đọc xong chuyển tin này sang `hop-thu/xong/`.

## Ý cho phần lời tin (M6)

1. Hai nhánh M6 còn nằm ngoài main: hook DQ thật (M6-082) và compose đủ biến (M6-157). Mở PR gộp vào main (merge commit, không squash phần M6) trong hôm nay, mai.
2. Còn 14 task M6 đang Cần sửa chưa cập nhật, 6 task nằm từ 05/11. Sửa xong thì đổi trạng thái trên Sheet để Toàn rà lượt 4.
3. Báo bản M6 đang chạy trên .98 là commit nào (api, worker), để rà khớp đúng bản.
4. M6-024 và M6-120 đã gộp (PR #117, #119): Toàn rà ở lượt 4, không cần làm gì thêm.
5. Không cần dựng nginx cổng 80 trên .98 nữa: Anh Tuấn chia đường thẳng `mkt.` vào cổng 6600 (Quảng cáo) và 3000 (còn lại).
6. Đăng nhập JWT chung M5 (DL-O09) và deploy key: chờ Toàn chốt (m6.13 = m5.36, m6.14 = m5.35). Có câu trả lời thì gộp luôn vào tin này.

## Chi tiết kỹ thuật cho tệp gửi kèm

- Nhánh chưa gộp (`origin`): `m6/M6-082-hook-dq-that` @ `e4ca8937`, `m6/M6-157-compose-bien-app` @ `c40be123`. `main` hiện `2eef3dab` (14/11 15:54).
- 14 task Cần sửa (Sheet 16/11 09:41): M6-015, 038, 042, 044, 051, 052, 063, 100, 125, 131, 133, 134, 136, 137. Lâu nhất (rà 05/11): 042, 044, 051, 063, 134, 136.
  Lý do từng task: bản rà `modules/m6/ra-soat/2026-11-13-tai.md` (đã gửi Tài 13/11).
- Chia đường `mkt.` (D-lead-049, thay D-lead-041): nginx Anh Tuấn → `/api/admin/ads/` vào `192.168.1.98:6600`, còn lại vào `192.168.1.98:3000`.
  Kiểm 16/11 07:3x: `.98:6600/api/admin/ads/dashboard` = 401 từ máy Lead, tức M6 đã nghe trên LAN (`M6_API_BIND`, M5-091).
  Việc của Tài: tường lửa 6600/3000 chỉ cho LAN 192.168.0.0/23; `M6_TRUSTED_PROXY_IPS` khai máy nginx của Anh Tuấn (hoặc dải LAN) để M6 tin
  `X-Forwarded-For/Proto`; dòng proxy trong bản khai M6-100 sửa theo đường mới (bỏ phần nginx :80).
- SHA đang chạy trên .98: ghi image tag theo commit của `m6-api`, `m6-worker` vào sổ triển khai (`module5/deploy/`), Toàn đối chiếu ở lượt 4.
