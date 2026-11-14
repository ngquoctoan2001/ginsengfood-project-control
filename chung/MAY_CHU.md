# Máy chủ chính thức Ginsengfood (từ 13/11/2026)

Chỉ phiên `lead` sửa. Nguồn: D-lead-034, D-lead-035, D-lead-036, D-lead-037 (`modules/lead/QUYET_DINH.md`); chi tiết máy `modules/lead/may-chu/KIEM_KE_MAY_CHU.md`;
cổng vào, cổng LAN, ai gọi ai, lịch cắt: `modules/lead/may-chu/2026-11-11-ten-mien-may-chu-chinh-thuc.md`.

## Máy nào chạy gì

| Máy | Vai | Module | Ghi chú |
|---|---|---|---|
| **192.168.1.99** (`ginsengfood`, 6 nhân, 28 GB, `/data` 280 GB) | **nhà máy + bán hàng** | M1–M2 (`/data/ginsengfood-ops-core`), M3 + M4 + M9 (`/data/ginsengfood-business-platform`), app M8 (`/data/ginsengfood-ivr`) | dữ liệu dưới `/data`; `ssv` vào bằng khoá; sudo cần mật khẩu → phần root do Toàn/Anh Tuấn |
| **192.168.1.98** (mkt) | **marketing** | M5 + M6 (`/data/ginsengfood-marketing`), giao diện chung `mkt.` | Tài dựng nền + app |
| 192.168.1.60 | **tạm** | M7 tới khi có máy video; gói M3/M4/M5/M6 cũ chỉ là đường lui sau giờ cắt | không dựng thêm gì mới cho M3–M6 |
| 192.168.1.61 | **đường lui** | M1–M2, M8 cũ sau giờ cắt | không dựng thêm gì mới |
| 192.168.1.64 | Asterisk M8 | giữ nguyên | đang chặn .99, Anh Tuấn mở trước khi cắt m8 |
| 192.168.1.63 | bỏ qua | staging cũ | — |

Máy video (M7) và máy thử: Anh Tuấn chưa giao.

## Lịch cắt sang .99 (D-lead-036, D-lead-038)

Không chờ giờ cố định: luồng nào kịch bản sẵn thì cắt ngay, Toàn duyệt liền. **Cả ba đã chạy trên .99:** 1. m12 (M1–M2) xong 13/11 19:15 · 2. m34 (M3 + M4 + M9) xong 14/11 07:36 · 3. m8 xong 14/11 08:50 (vòng M3 ↔ M8 đơn MOCK đạt). .60 (M3) và .61 (M1–M2, M8) dừng, giữ dữ liệu làm đường lui.
Chụp CSDL máy cũ ngay trước khi dừng ghi; nhắn nhóm Phúc/Tài một câu trước khi dừng ghi.
Tới giờ cắt của luồng nào thì địa chỉ cũ của luồng đó vẫn dùng; sau giờ cắt máy cũ dừng app, giữ dữ liệu làm đường lui tới khi Toàn cho gỡ.

## Địa chỉ nội bộ mới (áp từ giờ cắt của bên được gọi)

| Gọi tới | Địa chỉ | Bên gọi phải đổi |
|---|---|---|
| API M1–M2 | `http://192.168.1.99:5000` (chỉ mở cho .60, .98) | M3 `OPS_CORE_BASE_URL`, M6 `M6_OPSCORE_BASE_URL`, M7 `M7_OPSCORE__BASEURL` |
| `ops.`, `pwa.`, `trace.` (Caddy M1–M2) | `http://192.168.1.99:8012` | nginx Anh Tuấn |
| M3 + M4 (nginx gói `ginsengfood-business-platform`) | `http://192.168.1.99:80` | M5 `M4_ADVISOR_BASE_URL`, `M3_ORDER_STATE_*`; M6 `M6_M3_BASE_URL`; M7 `M7_M3__BASEURL` |
| M8 | `https://192.168.1.99:8443` (chứng thư mới theo IP .99) | M3 `M8_ORIGIN` + ghim CA mới |
| M5 + M6 | máy .98, cổng Tài báo | M7, M3 (sự kiện M6) |

## Cổng vào Internet (D-lead-036, thay D-lead-028)

IP ngoài của công ty: `14.224.139.101` (router → máy nginx Anh Tuấn, kiểm 03/11 qua `staging.`); DNS mọi tên đã trỏ về IP này (Mắt Bão).
Máy nginx của Anh Tuấn giữ 443 + HTTPS, trỏ theo tên về đích LAN: `ginsengfood.vn`, `www.`, `/admin` → `.99:80`; `ops.`, `pwa.`, `trace.` → `.99:8012`;
`mkt.` → .98; `video.` → M7. Không dựng proxy trước trên máy nào của mình. DNS (Mắt Bão, Toàn có quyền) đã trỏ mọi tên về IP công ty; 443 từ ngoài còn bị từ chối → **chưa tên nào chạy thật** (13/11).
Go/No-go M4/M5/M6 tính theo HTTPS `mkt.` trên .98, chậm nhất 20/11.

## Luật

- Việc mới (triển khai, cấu hình, tài liệu, kế hoạch, kiểm thử máy) nhắm **.99 / .98**. Không lập kế hoạch mới trên .60/.61; nhắc .60/.61 chỉ khi nói về đường lui hoặc M7.
- Thư mục trên máy chủ **theo tên repo** (D-lead-037): `/data/ginsengfood-ops-core`, `/data/ginsengfood-business-platform`, `/data/ginsengfood-ivr`, `/data/ginsengfood-marketing`, `/data/ginsengfood-golden-hour-video`; sao lưu `/data/sao-luu/<repo>`; thư mục thật, không liên kết trong nhà `ssv`; không đặt `m12`, `m34`, `m56`… (.60/.61 giữ tên cũ làm đường lui).
- Mật khẩu máy (Anh Tuấn gửi qua Zalo) không ghi, không in, không dùng; phiên vào bằng khoá. `ssh`/`scp` không còn hộp hỏi duyệt (14/11); việc đổi máy chủ (deploy, cắt máy, migration) vẫn theo lời Toàn trong phiên.
