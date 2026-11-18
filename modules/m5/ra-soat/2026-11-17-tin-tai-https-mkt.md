# Tin cho Tài · 17/11/2026 · HTTPS `mkt.` qua proxy .98 (ĐÃ GỬI — Toàn báo 17/11 10:42)

Nguồn: phiên lead nhắn 17/11 10:1x (D-m5-051; kế hoạch `modules/lead/may-chu/2026-11-17-ke-hoach-ten-mien-public.md` §4, §5, pha 2–3). Kèm phần (b).

## (a) Tin Zalo

```text
Tài ơi, anh Tuấn chịu chuyển cổng 443 với 80 về máy .98 rồi, chắc mai 18/11 là chạy, lúc proxy với chứng chỉ bên anh sẵn sàng.
Proxy là một compose riêng trên .98, nghe cổng 80 với 443, nên em đừng dựng gì ở hai cổng đó nha. Chia đường mkt. giữ y như đã chốt, hai đường admin cũ proxy chặn tạm giùm, em vẫn gỡ khỏi mã như đã nói.
Có HTTPS là em khai với Meta liền: webhook, đường xoá dữ liệu, với link chính sách riêng tư. Trang chính sách M5 chưa có, em chọn chỗ đặt rồi báo anh. Anh báo em giờ chuyển cổng sau.
Lưu ý: có tên miền rồi nhưng chỗ M5 gọi qua M3, M4 bên .99 (tra mã đơn, tư vấn, trạng thái đơn) em vẫn giữ địa chỉ nội bộ như bây giờ, đừng đổi sang tên miền nha, đi vòng qua proxy là bên M3 chặn 403 liền.
Chi tiết anh để trong file nghen.
```

## (b) Tệp kèm — `2026-11-17_lead_m5-https-mkt.md`

```markdown
Gửi Tài · 17/11/2026 · từ Toàn
Việc: chuẩn bị cho HTTPS mkt.ginsengfood.vn qua proxy Caddy trên .98 (mong cắt 18/11) và khai Meta sau khi có HTTPS.
Vì sao: D-m5-051 (proxy trên .98 thay nginx Anh Tuấn), Anh Tuấn đồng ý chuyển 443/80 về .98 khi proxy + chứng chỉ sẵn sàng.

Đã có (phiên lead, kiểm từ máy Toàn tới .98 thật 17/11): / → 301 /admin/; /admin/ 200; /api/admin/ads/dashboard 401; /health và /api/channel/delivery/send 404 (đúng D-m5-048).
Proxy: compose riêng `edge` ở /data/deploy/edge-98, nghe TCP 80 + 443 trên .98, giữ nguyên Host, đặt X-Forwarded-For/Proto, không sửa thân yêu cầu (chữ ký webhook Meta giữ được);
chặn sẵn 404 `/api/admin/gateway/evidence`, `/api/admin/facebook/events` tới khi em gỡ khỏi mã (D-m5-050).

Cần làm:
1. Không dựng/không map gì vào cổng 80, 443 trên .98 (compose M5/M6, nginx, Caddy riêng…). Deploy M5/M6 không đụng compose `edge`.
2. Vẫn gỡ hai route admin cũ khỏi mã (D-m5-050), probe đỏ trước.
3. Sau khi HTTPS chạy (Toàn báo giờ): khai với Meta
   - webhook: https://mkt.ginsengfood.vn/api/channel/meta/webhook (webhook.controller.ts:52);
   - callback xoá dữ liệu: đường của data-deletion.controller.ts:62 trên mkt.ginsengfood.vn;
   - URL chính sách riêng tư: M5 chưa có trang → em chọn chỗ đặt (ví dụ một trang trên ginsengfood.vn hoặc GitHub Pages theo D-m5-007), báo Toàn trước khi khai.
     Trang này dùng chung cho màn đồng ý Google của phần YouTube (thiết kế YouTube §10).
   - Meta gọi thử webhook đạt, ghi bằng chứng (đã che) vào Sheet.
4. M5 không có "trust proxy" → `ip_ref` băm thấy IP proxy: chấp nhận, không sửa (kế hoạch §5).
5. M5 gọi sang .99 (M3 by-code, M4 `/advise`, `M3_ORDER_STATE_*`) **giữ địa chỉ LAN đang dùng** (cửa TLS nội bộ `.99:8446` theo D-m5-042), **không đổi sang
   `ginsengfood.vn`/`mkt.`**: đi qua proxy .98 thì nginx M3 thấy IP nội bộ/Docker của .98 và trả 403 (m34 xác nhận 17/11, D-m34-097; kế hoạch tên miền §5).
Xong khi: Meta xác minh webhook đạt qua https; callback xoá dữ liệu khai đúng; URL chính sách mở được từ Internet.
Hạn: ngay sau giờ cắt HTTPS (mong 18/11) · báo lại bằng: dòng Sheet + ảnh chụp đã che.
```
