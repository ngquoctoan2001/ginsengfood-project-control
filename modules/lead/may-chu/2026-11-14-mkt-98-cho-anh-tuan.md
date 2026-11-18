# mkt.ginsengfood.vn → máy .98 (14/11/2026)

**Không gửi tệp này (D-lead-041, 14/11 11:29):** Anh Tuấn chỉ chuyển `mkt.` → `.98:80`; bảng dưới là việc Tài làm bằng nginx trên .98.

Tên miền `mkt.ginsengfood.vn` đã trỏ về IP 14.224.139.101. Nhờ anh làm HTTPS (chứng chỉ hợp lệ) rồi chuyển vào máy `192.168.1.98` như sau:

| Đường | Chuyển tới |
|---|---|
| `/api/admin/ads/` | `192.168.1.98:6600` (đặt **trước** dòng `/api/admin/`) |
| `/admin/` | `192.168.1.98:3000` |
| `/api/admin/` | `192.168.1.98:3000` |
| `/api/channel/meta/webhook` | `192.168.1.98:3000` |
| `/` | chuyển hướng 301 về `/admin/` |
| các đường khác | trả 404 |

Gửi kèm header `X-Forwarded-For` và `X-Forwarded-Proto`.

`/api/channel/meta/webhook` là chỗ Facebook gọi vào; Facebook chỉ gọi khi HTTPS có chứng chỉ hợp lệ.
