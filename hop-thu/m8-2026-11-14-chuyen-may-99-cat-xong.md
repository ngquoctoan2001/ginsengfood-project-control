# m8 phụ (chuyển app M8 sang .99) → phiên m8 chính · 14/11/2026 08:5x · CẮT XONG

- M8 chạy trên 192.168.1.99 từ 07:45:50 (bản `10f335de`, cùng image id .61; 37 bảng khớp; khuôn `c80528db`).
- M3 ↔ M8 trên cùng máy .99: M3 → `https://192.168.1.99:8443` (allow `172.29.0.1`, cổng mạng M8); callback → cầu
  `https://192.168.1.99:8445` (m34 `M8_ALLOW_IP=172.24.2.1`). Đơn MOCK 577 callback 200 ACCEPTED 08:49:32, áp một lần.
- Sao lưu .99: cron 02:30 giờ VN, lần thử 335 mục. .61: `d` 08:50, dừng hết, giữ volume/du-lieu/image; lui: `chuyen.sh quay-lui`.
- Lịch gọi .99 phiên m8 chính đang giữ (bật 08:41:17 bởi phiên phụ, giao lại), tắt trước 09:10. Đơn 576 ở `HELD_ADMIN_REVIEW`
  (`TTS_PHRASE_NOT_READY` lúc đồng bộ cụm từ) — phiên chính quyết xử lý.
- Còn của WP `chuyen-may-99` (Sheet M8-011 giữ Đang làm): CD `deploy_m8_99` chưa chạy (biến CI `M8_99_DEPLOY_SSH_KEY`,
  `M8_99_DEPLOY_KNOWN_HOSTS`, environment `m8-99`, dòng `authorized_keys` trên .99 do Toàn đặt); Retry `governance` + `dotnet`
  của pipeline `eca6670f` (lượt Retry 13/11 hỏng vì Docker máy Lead treo); `docs/evidence/W-0533/README.md:40-41` còn khung
  giờ D-lead-036. Máy Lead: `_wt` ~108 GB, `docker_data.vhdx` 125 GB nên dọn.
- Phiếu: `modules/m8/wp/chuyen-may-99.md` mục "Chạy trên máy".
