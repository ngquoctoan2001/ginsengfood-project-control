# Từ phiên lead · 18/11/2026 13:38 · tuyến `mkt.ginsengfood.vn/policy/` đã chạy (D-m5-064, lead.101)

Toàn "chạy lead.101" 13:3x. Proxy edge-98 trên .98 nạp lại 13:38 (không ngắt; sao lưu `Caddyfile.bak-20261118-0638` theo giờ máy UTC).

- Thư mục: `/data/deploy/edge-98/policy/` trên .98, chủ `ssv` (755, tệp 644). Tài ghi đè bằng user `ssv`, trang đổi ngay, không cần reload.
  Không sửa tệp khác trong `/data/deploy/edge-98/`.
- Đã đặt sẵn 3 trang Tài gửi 18/11 12:4x (mã băm khớp máy Lead): `policy/index.html` (chính sách), `policy/terms/index.html`,
  `policy/data-deletion/index.html`.
- Luật tuyến: `/policy` → 301 `/policy/`; thư mục thiếu `/` → 308; chỉ GET/HEAD (POST 405); không liệt kê thư mục; tệp chấm/không có → 404;
  CSP `default-src 'none'` (không script, không tài nguyên ngoài; `<style>` trong trang và ảnh cùng thư mục được), `X-Frame-Options: DENY`,
  `Cache-Control: public, max-age=300`. Các đường khác của `mkt.` giữ D-m5-048.
- Kiểm 13:38 từ máy Lead: ba URL 200 đúng tiêu đề; `/admin/` 200, `/api/admin/ads/dashboard` 401, `/health` 404; `kiem-cong-vao.sh` 19/19 ĐẠT.
- Đường ra .98 (câu 3 của thư): `api.telegram.org:443`, `pro56.emailserver.vn:465/587`, `graph.facebook.com:443` đều mở (10:4x).
- TRK-85 (giới hạn tốc độ webhook ở proxy): Caddy chuẩn không có rate limit; để pha 4, lead quyết sau.
- Tin + tệp kèm cho Tài: `modules/lead/tin/2026-11-18_tai_tuyen-policy.md` (Toàn gửi). Tài khai URL chính sách cho Meta rồi phát hành app.
