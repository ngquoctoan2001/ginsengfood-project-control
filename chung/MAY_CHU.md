# Máy chủ chính thức Ginsengfood (từ 13/11/2026)

Chỉ phiên `lead` sửa. Nguồn: D-lead-034, D-lead-035, D-lead-036, D-lead-037 (`modules/lead/QUYET_DINH.md`); chi tiết máy `modules/lead/may-chu/KIEM_KE_MAY_CHU.md`;
cổng vào, cổng LAN, ai gọi ai, lịch cắt: `modules/lead/may-chu/2026-11-11-ten-mien-may-chu-chinh-thuc.md`.

## Máy nào chạy gì

| Máy | Vai | Module | Ghi chú |
|---|---|---|---|
| **192.168.1.99** (`ginsengfood`, 6 nhân, 28 GB, `/data` 280 GB) | **nhà máy + bán hàng** | M1–M2 (`/data/ginsengfood-ops-core`), M3 + M4 + M9 (`/data/ginsengfood-business-platform`), app M8 (`/data/ginsengfood-ivr`) | dữ liệu dưới `/data`; `ssv` vào bằng khoá; sudo cần mật khẩu → phần root do Toàn/Anh Tuấn |
| **192.168.1.98** (mkt) | **marketing** + **cổng vào HTTPS** | M5 + M6 (`/data/ginsengfood-marketing`), giao diện chung `mkt.`; proxy Caddy `edge` (`/data/deploy/edge-98`, cổng 80/443, D-lead-057) | Tài dựng nền + app; proxy do phiên `lead` giữ (17/11: chạy chứng chỉ nội bộ, chờ chứng chỉ Mắt Bão + Anh Tuấn chuyển cổng) |
| 192.168.1.60 | **không dùng** (14/11) | không còn app nào chạy (kiểm 14/11 20:3x: chỉ CSDL M3 cũ + clamav, giữ làm đường lui); M7 thử trên .63 | không dựng gì mới; xin Anh Tuấn để nguyên tới khi Toàn báo thu hồi |
| 192.168.1.61 | **không dùng** (14/11) | app M1–M2, M8 đã dừng (kiểm 14/11 20:3x); dữ liệu cũ giữ làm đường lui; cụm microk8s + Prometheus chung .61/.63/.64 không phải của mình (lead.26) | không dựng gì mới; để nguyên tới khi Toàn báo thu hồi |
| 192.168.1.64 | Asterisk M8 | giữ nguyên | đang chặn .99, Anh Tuấn mở trước khi cắt m8 |
| 192.168.1.63 | **máy dev** (D-lead-039) — **từ 18/11 chỉ chạy CI + M7** (D-lead-061; staging `stg*` đã dọn; máy thử trước release sẽ là bản sao .99 do Anh Tuấn nhân bản) | runner GitLab `may-63` cho CI ivr + ops-core (container `gitlab-runner-63`, **3 job một lúc từ 18/11 14:45** (D-lead-062; trước đó 2), mỗi job 5 nhân, 12 GB từ 16/11 14:09, D-m12-078; ops-core chỉ chạy ở đây, D-lead-042); phiên M7 | bản thử cũ `stg_*` giữ nguyên, cấm `docker … prune`; không chạy thật gì ở đây |

Máy video (M7) và máy thử: Anh Tuấn chưa giao.

## Lịch cắt sang .99 (D-lead-036, D-lead-038)

Không chờ giờ cố định: luồng nào kịch bản sẵn thì cắt ngay, Toàn duyệt liền. **Cả ba đã chạy trên .99:** 1. m12 (M1–M2) xong 13/11 19:15 · 2. m34 (M3 + M4 + M9) xong 14/11 07:36 · 3. m8 xong 14/11 08:50 (vòng M3 ↔ M8 đơn MOCK đạt). .60 (M3) và .61 (M1–M2, M8) dừng, giữ dữ liệu làm đường lui. Hai dòng cổng tạm trên .99 (.60 → 8443, .61 → 8445) **đã gỡ 16/11 11:02** (D-lead-046; kiểm sau = DAT; .60/.61 không còn gọi vào .99, đường lui chỉ còn là dữ liệu cũ trên máy).
Chụp CSDL máy cũ ngay trước khi dừng ghi; nhắn nhóm Phúc/Tài một câu trước khi dừng ghi.
Tới giờ cắt của luồng nào thì địa chỉ cũ của luồng đó vẫn dùng; sau giờ cắt máy cũ dừng app, giữ dữ liệu làm đường lui tới khi Toàn cho gỡ.

## Địa chỉ nội bộ mới (áp từ giờ cắt của bên được gọi)

| Gọi tới | Địa chỉ | Bên gọi phải đổi |
|---|---|---|
| API M1–M2 | `http://192.168.1.99:5000` (LAN chỉ mở cho .60, .98; M3 trên chính .99 từ mạng Docker `m34_app` 172.24.2.0/24 gọi được — đo 17/11 200, tường lửa không chặn đường cầu Docker) | M3 `OPS_CORE_BASE_URL`, M6 `M6_OPSCORE_BASE_URL`, M7 `M7_OPSCORE__BASEURL` |
| `ops.`, `pwa.`, `trace.` (Caddy M1–M2) | `http://192.168.1.99:8012` | proxy cổng vào trên .98 (D-lead-057) |
| M3 + M4 (nginx gói `ginsengfood-business-platform`) | `http://192.168.1.99:80` | M5 `M4_ADVISOR_BASE_URL`, `M3_ORDER_STATE_*`; M6 `M6_M3_BASE_URL`; M7 `M7_M3__BASEURL` |
| M8 | `https://192.168.1.99:8443` (chứng thư mới theo IP .99) | M3 `M8_ORIGIN` + ghim CA mới |
| M5 + M6 | máy .98, proxy cổng vào trên .98 chia đường thẳng (D-lead-057; luật chia đường D-lead-050 giữ, thay nginx :80 của Tài trong D-lead-041): M5 `.98:3000` (`/admin/`, `/api/admin/`, `/api/channel/meta/`), M6 `.98:6600` (`/api/admin/ads/`); đường nội bộ M5 chỉ qua LAN | M7, M3 (sự kiện M6) |

## Cổng vào Internet (D-lead-057, thay D-lead-036)

IP ngoài của công ty: `14.224.139.101`; DNS mọi tên đã trỏ về IP này (Mắt Bão, Toàn có quyền).
**Cổng vào do bên mình giữ, đặt trên .98** (góp ý Anh Tuấn 16/11 tối, Toàn chốt 17/11): router (Anh Tuấn) chuyển 443 (xin cả 80) của IP công ty về .98;
proxy trên .98 (Caddy, dịch vụ riêng ngoài compose M5/M6 để cập nhật app nào cũng không tắt proxy; phiên `lead` dựng) giữ chứng chỉ wildcard `*.ginsengfood.vn` kèm tên gốc mua ở Mắt Bão (Toàn mua, D-lead-058; cấp lại mỗi ≤ 200 ngày), chặng LAN chạy http,
80 → 301 HTTPS, chia theo tên về IP LAN cố định: `ginsengfood.vn`, `www.`, `/admin` → `.99:80`; `ops.`, `pwa.`, `trace.` → `.99:8012`;
`mkt.`: `/api/admin/ads/` → `.98:6600`; `/admin/`, `/api/admin/`, `/api/channel/meta/` → `.98:3000`; `/` → 301 `/admin/`; còn lại 404 (D-lead-050); `video.` → máy video M7 khi có; `staging.` **gỡ 18/11** (rơi về 404, D-lead-061).
**Danh sách tên giữ như cũ, mọi tên public ra Internet** (app nào cũng có đăng nhập, nhân viên ở nhà phải vào được); không đổi sang thư mục con, không giới hạn LAN/VPN.
App sau proxy chỉ tin `X-Forwarded-For` từ `.98/32`. **Kế hoạch + checklist + tin chốt Anh Tuấn:** `modules/lead/may-chu/2026-11-17-ke-hoach-ten-mien-public.md` (pha 0–4, việc từng luồng, tiêu chí đạt, đường lui).
**Chạy thật từ 17/11 ~16:3x:** 443 công khai → proxy .98, chứng chỉ Sectigo wildcard (hết hạn 03/06/2027, cấp lại trước ~04/05/2027), kiểm từ ngoài đạt; trong LAN gõ tên miền vào được. Cổng 80 công khai còn chuyển nhầm vào 443 của .98 (http ra 400) — nhắc Anh Tuấn khi tiện. (14/11 13:00 các lần "302" là trang quản trị router DrayTek giữ 443.) Từ LAN không vào được IP ngoài (router không quay vòng): kiểm từ ngoài (check-host.net, 4G).
Go/No-go M4/M5/M6 tính theo HTTPS `mkt.` trên .98, chậm nhất 20/11; HTTPS nay là việc bên mình (chứng chỉ + proxy .98), chỉ cần Anh Tuấn chuyển cổng router.

## Luật

- Việc mới (triển khai, cấu hình, tài liệu, kế hoạch, kiểm thử máy) nhắm **.99 / .98**. Không lập kế hoạch mới trên .60/.61; nhắc .60/.61 chỉ khi nói về đường lui hoặc M7.
- Thư mục trên máy chủ **theo tên repo** (D-lead-037): `/data/ginsengfood-ops-core`, `/data/ginsengfood-business-platform`, `/data/ginsengfood-ivr`, `/data/ginsengfood-marketing`, `/data/ginsengfood-golden-hour-video`; sao lưu `/data/sao-luu/<repo>`; thư mục thật, không liên kết trong nhà `ssv`; không đặt `m12`, `m34`, `m56`… (.60/.61 giữ tên cũ làm đường lui).
- **Ai đưa bản lên máy (D-lead-060, 18/11):** repo `ginsengfood-business-platform` (M3, M4, M9) trên .99 — **chỉ Phúc** (bản mới, `.env`, compose, cờ,
  khởi động lại container), qua image CI (runner trên .63 do Phúc dựng) + `trien-khai.sh`, báo trước, giữ lớp `compose.cong-khai.yml`, gửi lại mã commit + kết quả;
  Toàn, phiên `m34`/`m9`, Tài, chú Dũng chỉ đọc .99 và nhắn Phúc khi cần. M1–M2 (.99): phiên `m12` · M8 (.99, .64): phiên `m8` · M5 + M6 (.98): Tài ·
  proxy `edge` (.98): phiên `lead` — mọi lượt vẫn theo lời Toàn.
- Mật khẩu máy (Anh Tuấn gửi qua Zalo) không ghi, không in, không dùng; phiên vào bằng khoá. `ssh`/`scp` không còn hộp hỏi duyệt (14/11); việc đổi máy chủ (deploy, cắt máy, migration) vẫn theo lời Toàn trong phiên.
