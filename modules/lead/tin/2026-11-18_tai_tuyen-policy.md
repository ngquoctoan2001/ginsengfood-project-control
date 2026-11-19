# Gửi Tài · 18/11/2026 · từ Toàn · trang công khai `https://mkt.ginsengfood.vn/policy/`

## Đã làm

- Proxy .98 có tuyến tĩnh `/policy/*` (D-m5-064), phục vụ thẳng tệp từ thư mục trên .98, không đi qua app M5.
- Ba trang em gửi 18/11 12:4x đã đặt lên:

| URL | Tệp trên .98 |
|---|---|
| `https://mkt.ginsengfood.vn/policy/` | `/data/deploy/edge-98/policy/index.html` |
| `https://mkt.ginsengfood.vn/policy/terms/` | `/data/deploy/edge-98/policy/terms/index.html` |
| `https://mkt.ginsengfood.vn/policy/data-deletion/` | `/data/deploy/edge-98/policy/data-deletion/index.html` |

## Sửa trang về sau

- Thư mục `/data/deploy/edge-98/policy/`, chủ `ssv`: em ghi đè tệp bằng user `ssv` là trang đổi ngay, không cần khởi động lại gì. Không sửa tệp nào khác
  trong `/data/deploy/edge-98/` (cấu hình proxy, chứng chỉ).
- Trang con mới: tạo thư mục `<tên>/index.html`. Gõ thiếu dấu `/` cuối thì proxy tự chuyển sang có `/` (308).
- Proxy đặt CSP chặt cho `/policy/`: **không chạy script**, không tải CSS, font, ảnh từ trang khác. Được dùng `<style>` trong trang và ảnh đặt cùng thư mục
  (hoặc `data:`). Liên kết ra ngoài (Facebook, Google) bấm vẫn đi bình thường.
- Không liệt kê thư mục; tệp bắt đầu bằng dấu chấm và tệp không có đều trả 404; chỉ nhận GET/HEAD.
- Dòng cuối "Nguồn: commit …" em bỏ ở lần sửa tới: trang cho khách không cần mã commit nội bộ.

## Kiểm (phiên lead)

`/policy` → 301 `/policy/`; ba trang 200 với đúng tiêu đề; `/policy/terms` → 308 `/policy/terms/`; POST → 405; tệp ẩn, tệp không có,
đường dò ngược ra cấu hình proxy → 404.
