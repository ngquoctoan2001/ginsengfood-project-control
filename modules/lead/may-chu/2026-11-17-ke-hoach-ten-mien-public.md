# Kế hoạch đưa tên miền ra Internet (HTTPS) · 17/11/2026

Chủ: phiên `lead` (hạ tầng chung). Nguồn: D-lead-057 (cổng vào do bên mình giữ, proxy trên .98, tên giữ như cũ, public hết).
Toàn dặn 17/11: **làm chuẩn một lần**, xong thì chỉ tập trung code. Đích: chạy thật trên Internet **trong ngày 18/11**, chậm nhất 19/11
(Go/No-go M4/M5/M6 ≤ 20/11). Tệp này vừa là kế hoạch vừa là checklist: tick `[x]` kèm giờ + người khi xong, không xoá dòng.

## 0. Dữ kiện đã kiểm (17/11 08:5x)

- DNS ở Mắt Bão (`ns1.matbao.vn`, serial `2026111303`, TTL 3600): `@`, `www`, `ops`, `pwa`, `trace`, `mkt`, `video`, `staging` → `14.224.139.101`; `api-ops` không còn.
  **Không có bản ghi CAA** → CA nào cũng cấp được. **Cắt không cần đổi DNS**: chỉ đổi chuyển cổng ở router, nên lui cũng chỉ là trả cổng.
- 14/11: từ ngoài TCP 443 vào được IP công ty, **TCP 80 hết giờ** (router hoặc nhà mạng chặn, chưa rõ). Router không quay vòng: trong LAN gõ tên miền là treo.
- .98: cổng 80 và 443 đang trống (không nghe gì). RAM .98 khoảng 3,3 GB, trần `mem_limit` M5 đã 3,5 GB → chật.
- .99: M3 nginx `:80`, Caddy M1–M2 `:8012` (chọn app theo Host; IP trần → 404), M8 `:8443`; `:443` không nghe. Tường lửa `gf-tuong-lua` cho LAN `192.168.0.0/23` vào 80, 8012.
- admin-web và PWA M1–M2 build sẵn địa chỉ API `https://ops.ginsengfood.vn`, `https://pwa.ginsengfood.vn` → **chỉ đăng nhập được khi có HTTPS thật**
  (vào bằng hosts + `:8012` thì mở được trang nhưng gọi API sang cổng 443 không có ai). Trace chạy đủ vì server tự gọi API trong máy.

## 1. Đích cuối

```text
Khách / đối tác ──DNS Mắt Bão (không đổi)──> 14.224.139.101 (router, Anh Tuấn)
   └─ chuyển TCP 443 + 80 → 192.168.1.98, giữ IP nguồn thật (không SNAT)
        └─ Caddy "cổng vào" trên .98 (TLS, 80 → 301 https, header an ninh, log, chặn tên lạ)
             ├─ ginsengfood.vn, www, /admin ─────────> http://192.168.1.99:80   (nginx M3/M4/M9)
             ├─ ops., pwa., trace. (giữ nguyên Host) ─> http://192.168.1.99:8012 (Caddy M1–M2)
             ├─ mkt. /api/admin/ads/ ────────────────> http://192.168.1.98:6600 (M6)
             ├─ mkt. /admin/ /api/admin/ /api/channel/meta/ ─> http://192.168.1.98:3000 (M5); / → 301 /admin/; còn lại 404
             └─ video. ───────────────────────────────> máy video M7 :6700 (khi Anh Tuấn giao; trước đó 503)
Nhân viên trong công ty: quay vòng NAT trên router HOẶC DNS nội bộ trỏ các tên trên → 192.168.1.98 (Anh Tuấn chọn cách)
```

## 2. Bảng tên

| Tên | Ai dùng | Đích LAN | Ghi chú |
|---|---|---|---|
| `ginsengfood.vn` | khách | `.99:80` | tên chính |
| `www.ginsengfood.vn` | khách | 301 → `https://ginsengfood.vn` | một địa chỉ chuẩn cho SEO, cookie |
| `ginsengfood.vn/admin` | nhân viên bán hàng, M8, M9 | `.99:80` | có đăng nhập |
| `ginsengfood.vn/api/v1/payments/webhooks/*`, GHN/VTP | đối tác | `.99:80` | đường có sẵn; chỉ khai với đối tác khi bật thật (Toàn nói) |
| `ops.ginsengfood.vn` | nhà máy (admin-web) | `.99:8012` | có đăng nhập |
| `pwa.ginsengfood.vn` | xưởng (điện thoại) | `.99:8012` | PWA cần HTTPS để cài và dùng camera |
| `trace.ginsengfood.vn` | khách quét tem | `.99:8012` | in lên tem → không đổi tên sau lô tem đầu |
| `trace.ginsengfood.vn/media/*` | khách xem bằng chứng nguồn gốc | tệp tĩnh `media/` trên .98 | ảnh/video/pdf vùng nguyên liệu (TRC-01, RS-8; Toàn "trace.ginsengfood.vn"), chép bằng `chep-media.sh`; m12 build `NEXT_PUBLIC_TRACE_MEDIA_ORIGINS=https://trace.ginsengfood.vn` |
| `mkt.ginsengfood.vn` | Meta + nhân viên mkt | `.98:3000` / `.98:6600` | chia đường theo D-lead-050 |
| `video.ginsengfood.vn` | nhân viên M7 | máy video `:6700` | chờ máy; M7 tự làm TLS nội bộ → proxy gọi https, tin CA nội bộ M7 |
| `staging.ginsengfood.vn` | (đang dùng, → `.63:8080`) | `http://192.168.1.63:8080` | proxy chuyển tiếp như cũ, không hỏi (D-lead-058) |
| tên lạ, IP trần | — | 404 | không lộ gì |
| `api-ops` | — | không public | M3/M6/M7 gọi `.99:5000` trong LAN |

## 3. Chứng chỉ — CHỐT: mua wildcard ở Mắt Bão (D-lead-058, lead.99 = B)

- Loại: wildcard `*.ginsengfood.vn`, **kèm tên gốc `ginsengfood.vn`** (kiểm gói trước khi trả tiền). Toàn mua.
- Báo giá Mắt Bão 17/11: **Wildcard SSL-DV 2.390.000 đ/năm (2.581.200 đ có VAT)**, xác thực qua tên miền, cấp ~30 phút, gói DV không thêm SAN được. Hỏi Mắt Bão trong nhóm Zalo (Toàn, chú, chị Lan, nhân viên Mắt Bão): có kèm tên gốc không, cấp lại trong năm có mất phí không. Chị Lan lo thanh toán + hoá đơn VAT.
- Cách cấp: phiên lead sinh khoá riêng + CSR **trên .98** (khoá không rời máy, không vào repo/sổ) → Toàn dán CSR ở Mắt Bão → xác thực bằng bản ghi TXT
  ở DNS Mắt Bão (Toàn thêm) → tải tệp chứng chỉ + chuỗi trung gian → phiên lead cài vào Caddy. **Cài được trước khi chuyển cổng.**
- Hạn: từ 15/03/2026 chứng chỉ công khai tối đa 200 ngày (CA/B Forum SC-081) → gói nhiều năm vẫn phải **cấp lại mỗi ≤ 200 ngày**.
  Phiên lead ghi ngày hết hạn vào `KIEM_KE_MAY_CHU.md`, nhắc Toàn trước 30 ngày; cấp lại theo đúng các bước trên.

## 4. Proxy trên .98 (phiên `lead` dựng, Toàn duyệt lệnh ghi trên máy)

- Caddy 2 (image chính thức, ghim đúng số bản khi dựng), một compose riêng tên `edge`, **không nằm trong compose M5/M6**: Tài deploy, khởi động lại
  M5/M6 không đụng proxy. `restart: unless-stopped`, giới hạn 256 MB.
- Nguồn cấu hình ở repo `C:\Projects\deploy\edge-98\` (Caddyfile, compose, kịch bản kiểm, runbook); trên máy `/data/deploy/edge-98/` (D-lead-037 theo tên repo);
  thư mục dữ liệu Caddy (chứng chỉ, khoá) nằm trong đó, quyền chỉ chủ đọc, nằm dưới `/data` nên đi chung sao lưu của Anh Tuấn.
- Chặng LAN (proxy → máy) chạy http (D-lead-058); mỗi máy sẽ chỉ cho proxy vào (pha 4).
- Đổi cấu hình: `caddy validate` rồi `caddy reload` (không ngắt kết nối). Giữ `Caddyfile.bak` bản đang chạy để lui.
- Chuyển tiếp: **giữ nguyên Host** (M1–M2 chọn app theo Host; M5 dựng URL xoá dữ liệu Meta từ Host), **ĐẶT** `X-Forwarded-For = IP khách`
  (`header_up X-Forwarded-For {remote_host}`, không nối thêm — nginx M3 đọc theo kiểu đặt), `X-Forwarded-Proto: https`; không sửa thân yêu cầu
  (chữ ký webhook Meta tính trên thân thô); websocket tự đi.
- `mkt.` chặn thêm 404 hai route admin cũ `GET /api/admin/gateway/evidence`, `GET /api/admin/facebook/events` tới khi Tài gỡ khỏi mã (D-m5-050).
- Header: bỏ `Server`, `X-Powered-By` (admin-web lộ `Next.js`, rà release N-5), `X-Content-Type-Options: nosniff`, `Referrer-Policy: strict-origin-when-cross-origin`; **không đè CSP của app**.
  HSTS: bật `max-age=300` khi cắt, nâng 1 năm sau 7 ngày ổn định, không preload.
- Log truy cập JSON, xoay vòng 50 MB × 10 tệp. Đường kiểm sống của proxy chỉ trả trong LAN.
- Chỉ mở TCP 80, 443 (không mở UDP/HTTP3). Cổng Docker đi vòng ufw → lọc ở `DOCKER-USER` như bài học .99.

## 5. Phía app — mỗi luồng chỉnh gì

Khảo sát cấu hình 17/11 (đọc `origin/dev` BP, `origin/main` ops-core, module5, M7; không đọc `.env` thật). Cột "Khi": **trước** = làm trước pha 2,
không phá chạy LAN hiện tại; **sau** = chỉ làm khi HTTPS thật + quay vòng/DNS nội bộ đã chạy (làm sớm sẽ khoá người đang dùng `http://IP`).

| Luồng | Việc | Khi | Chỗ |
|---|---|---|---|
| m34 (M3) | nginx đang gửi `X-Forwarded-Proto $scheme` (= `http` vì proxy gọi bằng HTTP) → lấy theo proxy (`$http_x_forwarded_proto`, mặc định `http`). Không sửa thì cookie giới thiệu không Secure, canonical/OG ra `http://` | trước | `deploy/m34/nginx/m34.conf:148,187,201,238,250` |
| m34 (M3) | IP khách: nginx đã tin XFF từ `192.168.0.0/23` → .98 nằm trong; không cần sửa. Thu về `192.168.1.98/32` ở pha 4 | pha 4 | `m34.conf:50-52` |
| m34 (M3) | `.env` .99: `CORS_ALLOWED_ORIGINS=https://ginsengfood.vn,https://www.ginsengfood.vn` (giữ thêm `http://192.168.1.99` tới pha 4), `AUTH_COOKIE_SECURE=true` | sau | `deploy/m34/env.mau:28-30` |
| m34 (M3) | XONG 17/11 `4cfd37b32` (D-m34-097, chưa push, `nginx -t` chạy ở lượt deploy .99): `X-Forwarded-Proto`/`Port` chỉ tin khi kết nối thật từ `192.168.1.98`, còn lại `$scheme`; `allow .61` → `.99`. Webhook M12 đi `extra_hosts` → .98 nên Caddy thấy IP `.99` (không qua router) | trước | `m34.conf` |
| m34 (M3) | `allow 192.168.1.61` cho webhook M12 đã cũ (M12 nay ở .99, đi qua proxy .98 thì IP sau realip là `.99`) → đổi sang `.99`; đo lại `allow 192.168.1.98` của M5 by-code | trước (nối M12 ↔ M3) | `m34.conf:136,223` |
| m34 (M3) | khi bật đối tác thật: thêm `PAYMENT_VNPAY_RETURN_URL=https://ginsengfood.vn/payment/result`, IPN khai ở cổng VNPAY; thêm hai khoá webhook GHN/VTP vào compose (đang thiếu → mọi callback 401) | khi bật | `application.yml:692-693,819-820` |
| m12 (M1–M2) | XONG 17/11 10:37 (D-m12-105, Toàn "Cho chạy"): `M12_FRONT_PROXY_CIDR=192.168.1.98/32` (giả XFF từ LAN vào /metrics, /health/ready, /scalar vẫn 404), `extra_hosts` API (`ginsengfood.vn`, `www`, `ops.` → .98), `M12_PUBLIC_TRACE_PROXY_SECRET` 48 ký tự; sao lưu `.env`/compose trước sửa trong `/data/ginsengfood-ops-core`. Webhook M12 → M3 bật ở WP22. Phiên lead kiểm lại qua proxy .98 10:5x: 17/17 DAT | xong | — |
| m12 (M1–M2) | `.env` .99: `M12_FRONT_PROXY_CIDR=192.168.1.98/32` (biến bắt buộc; proxy duy nhất là .98). Không build lại: admin-web, PWA đã bake https; CORS, `PublicTrace__BaseUrl`, cookie Secure ngoài Development đã đúng | trước | `deploy/m12/compose.yml:347` |
| m12 (M1–M2) | `.env` .99: đặt `M12_PUBLIC_TRACE_PROXY_SECRET` (32–256 ký tự) cùng lượt với dòng trên — bí mật giữa public-trace và API **trong .99**, proxy .98 không cần biết; không đặt thì mọi khách trang truy xuất chung hạn mức 600 lượt/giờ (OPS-07/TRC-03). Cổng API 5000 mở trên IP LAN (SECR-09) → siết ở pha 4 | trước | `deploy/m12/compose.yml:156-158,304` |
| m12 (M1–M2) | webhook M12 → M3 (`M12_OUTBOX_WEBHOOK_URL`) dùng tên miền https: container API thêm `extra_hosts` trỏ tên đó về `192.168.1.98` (LAN không quay vòng) | trước (nối M12 ↔ M3) | `deploy/m12/compose.yml:203` |
| m5 (Tài) | gỡ hai route admin cũ trước khi `mkt.` có HTTPS (D-m5-050); proxy chặn tạm hai route này | trước | M5-112 |
| m5 (Tài) | khai với Meta: webhook `https://mkt.ginsengfood.vn/api/channel/meta/webhook`, callback xoá dữ liệu, **URL chính sách riêng tư** (trong M5 chưa có trang này → Tài chọn chỗ đặt, ví dụ một trang trên `ginsengfood.vn`) | sau | `webhook.controller.ts:52`, `data-deletion.controller.ts:62` |
| m5 (Tài) | M5 gọi M3 (by-code, tư vấn, trạng thái đơn) phải giữ địa chỉ LAN (`.99:80` / cửa TLS `.99:8446`), **không** đổi sang tên miền: đi qua proxy thì nginx M3 thấy IP Docker/nội bộ của .98 → 403 (m34 nhắc 17/11) | luôn | `m34.conf:136` |
| m5 (Tài) | M5 không có "trust proxy" → chỉ `ip_ref` băm thấy IP proxy; chấp nhận, không sửa | — | SRS:1197 |
| m6 (Tài) | `M6_API_BIND` = IP LAN .98 (đang nghe LAN 6600, giữ). `M6_TRUSTED_PROXY_IPS` chỉ dùng cho `/api/ads/events/track` (chưa gắn, không qua proxy) → đo peer thật khi gắn | sau | `m6/deploy/compose.json:79`, `m6/app/settings/track.py:33` |
| m7 | khi có máy video: `M7_EDGE_BIND` = IP LAN máy video, thêm `video.ginsengfood.vn` vào site của edge, `M7_PUBLIC_BASE_URL=https://video.ginsengfood.vn` (redirect OIDC theo đó); CA nội bộ edge sinh lại mỗi lần khởi động → giữ CA bền hoặc proxy bỏ kiểm chứng chỉ ở chặng LAN | khi có máy | `deploy/compose/Caddyfile:5-6`, `compose.yaml:109,199` |
| m8 | không có tên public (tổng đài .64 đi SIP/UDP riêng, ngoài kế hoạch này) | — | — |

Phiên lead nhắn từng phiên luồng phần của nó ở pha 0; phần "trước" phải xong trước pha 2.

## 6. Việc của Anh Tuấn (nhờ) và câu chưa rõ

Luật (D-lead-058): **việc bên mình tự làm được thì không nhờ, không hỏi Anh Tuấn.** Chỉ nhờ 5 việc chỉ anh làm được (tin mục 9):
chuyển 443 + 80 về .98 giữ IP thật và không chặn IP nước ngoài ở hai cổng đó · quay vòng NAT hoặc DNS nội bộ · RAM .98 trên 8 GB · giờ chuyển cổng ·
máy ảo video + máy thử. Không hỏi: IP (đã có), cổng 80 (chuyển rồi thử), `staging.` (proxy tự chuyển tiếp), https trong LAN (chốt http), chứng chỉ (mua Mắt Bão),
.64 (m8 tự bảo trì, Toàn sudo), sao lưu (Anh Tuấn tự sao lưu `/data`), chỗ cất khoá (bên mình), khoá JWT (bên mình tự sinh).

## 7. Checklist theo pha

### Pha 0 — chốt (17/11)
- [x] 17/11 09:2x Toàn chốt lead.99 = B (mua wildcard Mắt Bão), proxy .98, RAM .98 trên 8 GB, bớt hỏi Anh Tuấn (D-lead-058).
- [x] 17/11 10:4x (Toàn "Chạy cả 3") khoá riêng RSA 2048 + CSR sinh trên .98 (`/data/deploy/edge-98/certs/`, thư mục 700, khoá 600 chủ `ssv`, không in ra). CSR (2 tên `*.ginsengfood.vn`, `ginsengfood.vn`) lưu bản ở máy Lead `modules/lead/ra-soat/may-chu-anh-tuan/wildcard.csr` (ngoài git).
- [x] 17/11 ~15:3x Toàn đã mua **Wildcard SSL-DV** Mắt Bão, Mắt Bão báo đã kích hoạt; kỹ thuật Mắt Bão sẽ liên hệ hướng dẫn khai báo `*.ginsengfood.vn`.
- [x] 17/11 16:2x Toàn dùng CSR + khoá Mắt Bão sinh (đổi so với đề xuất), xác thực qua email admin@ (Mắt Bão tạo hộp thư). Sectigo cấp `*.ginsengfood.vn` + `ginsengfood.vn`, hạn **17/11/2026 – 03/06/2027** (cấp lại trước ~04/05/2027), chuỗi DV R36 → Root R46 → USERTrust.
- [x] 17/11 16:3x (Toàn "Cài luôn") cài lên .98: khoá Mắt Bão → `certs/wildcard.key` (khoá tự sinh giữ `.tu-sinh-20261117-093448`), `cai-chung-chi.sh` (sửa lỗi tệp Sectigo thiếu xuống dòng cuối làm dính khối khi ghép), Caddy nạp lại không ngắt; áp Caddyfile `/media` + compose gắn `media/` (tạo lại container, healthy). `kiem-cong-vao.sh --dich 192.168.1.98` (kiểm chứng chỉ thật): **19/19 DAT**, chuỗi phục vụ đúng, verify 0. Từ ngoài (IR, RU, IL, IN, SE, DE, MD): ginsengfood.vn 307, ops. 307, mkt. 301. Trong LAN gõ tên miền vào được (router quay vòng).
- [x] 17/11 08:5x phiên lead: sửa tệp Excel máy chủ của Anh Tuấn theo proxy .98 (`ra-soat/may-chu-anh-tuan/Server Service Detail.xlsx`, ngoài git vì cột "How to run" có mật khẩu; cột đó không đọc, không đổi — kiểm bằng mã băm): 25 ô (cổng vào 4 dòng, dòng proxy mới trong khối MKT, ghi chú, 3 sheet chi tiết); 09:43 thêm MKT Detail B8 "trên 8 GB"; kiểm lại 09:4x khớp tin, không còn chữ "nginx của anh".
- [x] 17/11 09:4x Toàn gửi tin Anh Tuấn (bản Toàn sửa ở mục 9) kèm tệp Excel. Câu trả lời ghi vào mục 10.
- [x] 17/11 10:4x Phiên lead báo Tài qua phiên m5: .98 sắp chạy proxy cổng 80/443, không dựng gì ở hai cổng này.
- [x] 17/11 10:4x Đã nhắn Phien M12, Phien M34, Phien M5 phần việc mục 5 (chờ các phiên báo xong phần "trước").

### Pha 1 — dựng proxy trên .98, chưa chuyển cổng (17–18/11)
- [x] 17/11 10:3x Viết `C:\Projects\deploy\edge-98\` (Caddyfile, `tls-mat-bao.caddy`/`tls-noi-bo.caddy`, compose Caddy 2.11.7 256 MB, `sinh-csr.sh`, `cai-chung-chi.sh`, `kiem-cong-vao.sh`, README; chưa commit). `caddy validate` đạt cả hai chế độ. Chạy thử Caddy trên máy Lead (cổng 18443/18080, chứng chỉ nội bộ) tới .99/.98 thật: `kiem-cong-vao.sh` **17/17 DAT** (lượt sau ổn định; 4 lượt đầu ops./pwa. 307 thiếu Location trùng lúc app M1–M2 .99 khởi động lại). IP trần → từ chối TLS; header bỏ `Server`, có HSTS 300, nosniff, giữ CSP app. `sinh-csr.sh` (bản sao tạm): CSR đúng 2 tên, chạy lần 2 tự chặn. `cai-chung-chi.sh` trong Linux: khớp khoá + đủ tên đạt, chứng chỉ tự ký bị chặn ở bước chuỗi (đúng). Đã dọn container + dữ liệu thử. Từ .98 tới `.99:80`, `.99:8012`, `.63:8080` đều tới (chỉ đọc). `ssv` trên .98 có sudo không mật khẩu; `/data` của root → cần `sudo mkdir /data/deploy`.
- [x] 17/11 10:4x dựng trên .98: `sudo mkdir /data/deploy` (chủ `ssv`), chép `edge-98` (mã băm khớp), compose `edge` Caddy 2.11.7 chạy chứng chỉ nội bộ (`tls-hien-tai.caddy` = `tls-noi-bo.caddy`), healthy, 13 MB RAM, cổng 80/443 nghe trên .98 (Internet chưa vào vì router chưa chuyển). Đổi cách chọn chứng chỉ từ biến `.env` sang tệp `tls-hien-tai.caddy` (quyền phiên chặn tệp `.env*`; đổi chứng chỉ chỉ cần reload); `.env` tạm tạo lúc đầu đã xoá.
- [x] 17/11 10:4x `kiem-cong-vao.sh --dich 192.168.1.98 -k` từ máy Lead: **17/17 DAT**; log truy cập ghi đúng IP máy Lead (192.168.0.64) → Docker giữ IP nguồn; `caddy reload` đạt.
- [x] 17/11 10:4x RAM .98 sau khi thêm Caddy: còn ~3 GB khả dụng (RAM động, tổng 4,1 GB lúc kiểm); M5, M6 vẫn chạy.

- [x] Áp bản Caddy có đường `trace.…/media/*` lên .98 (đã validate + chạy thử trên máy Lead 17/11 11:0x: ảnh 200, tệp lạ/thư mục/chữ hoa/`..` 404) — 17/11 16:3x áp cùng lượt cài chứng chỉ (pha 0).

### Pha 2 — chuyển cổng (giờ Anh Tuấn chọn, mong 18/11)
- [x] 17/11 ~15:5x Anh Tuấn chuyển TCP 443 → .98 (mục 10). Cổng 80 chuyển nhầm đích, xem dòng dưới.
- [x] 17/11 16:3x chứng chỉ Mắt Bão cài trên Caddy (cài sau khi 443 đã vào, trình duyệt cảnh báo ~40 phút).
- [x] 18/11 10:1x thử cổng 80 từ ngoài (check-host 4 nút) và LAN: vào .98 nhưng rơi vào **cổng 443** → 400 "Client sent an HTTP request to an HTTPS server". Cần Anh Tuấn đổi đích luật 80 → `192.168.1.98:80` (mục 12 #1).
- [x] 18/11 10:0x–10:4x kiểm mục 8 từ máy Lead + check-host + SSL Labs: đạt trừ #10 (cổng 80); chi tiết mục 12.
- [x] 17/11 16:3x quay vòng NAT trên router chạy (LAN gõ tên miền vào được). Hệ quả: app thấy cả công ty chung IP `14.224.139.101` (mục 12 #6).

### Pha 3 — nối đối tác và app (18–19/11)
- [ ] Phiên luồng áp phần mục 5 cần HTTPS thật (URL công khai, cookie Secure, tin proxy .98).
- [ ] Tài khai URL webhook + chính sách + xoá dữ liệu với Meta; Meta gọi thử đạt.
- [ ] Đăng nhập thật qua https: admin-web, PWA (điện thoại cài được), `/admin` M3, quản trị mkt — từ ngoài và trong công ty.
- [x] 18/11 10:4x SSL Labs (không công bố): `ginsengfood.vn` **A**, `mkt.` **A** — TLS 1.2/1.3, chuỗi đủ, OCSP stapling, không lỗ hổng. A+ cần HSTS ≥ 6 tháng (pha 4).
- [ ] Sổ: `chung/MAY_CHU.md` ghi "đang chạy thật", `KIEM_KE_MAY_CHU.md` thêm proxy .98, báo Chú trong báo cáo tuần.

### Pha 4 — siết (sau 7 ngày ổn định, ~26/11)
- [ ] HSTS lên 1 năm.
- [ ] Thêm khối bắt-tất-cả `https://` (respond 404) trên Caddy .98: tên lạ có dấu chấm cuối (vd `ops.ginsengfood.vn.`) hiện nhận 200 rỗng thay vì 404 (m12 phát hiện 17/11 18:2x; không lộ app, không tới API). Kiểm validate với chứng chỉ thật trước khi reload.
- [ ] Tường lửa .99: cổng 80, 8012 chỉ cho .98 + máy video M7 + máy Lead (bỏ cả dải LAN); app M1–M2/M3/M5/M6 chỉ tin `X-Forwarded-For` từ `192.168.1.98/32` (đóng m12.100).
- [ ] Theo dõi từ ngoài: kiểm sống 5 phút/lần cho 6 tên + cảnh báo chứng chỉ còn < 21 ngày (kênh cảnh báo chung khi có).
- [ ] Diễn tập lui một lần: dừng Caddy 1 phút, khởi động lại, đo thời gian hồi.

## 8. Tiêu chí đạt (chạy `kiem-cong-vao.sh` — từ LAN trước, từ ngoài sau)

| # | Kiểm | Mong đợi |
|---|---|---|
| 1 | `https://ginsengfood.vn/` | 200 hoặc 307 → `/vi` (như LAN hiện tại) |
| 2 | `https://www.ginsengfood.vn/x` | 301 → `https://ginsengfood.vn/x` |
| 3 | `https://ginsengfood.vn/admin` | 200 (trang đăng nhập) |
| 4 | `https://ops.ginsengfood.vn/` | 307 → `/login`; đăng nhập được |
| 5 | `https://pwa.ginsengfood.vn/` | 307 → `/pwa/tasks`; đăng nhập được, cài PWA được |
| 6 | `https://trace.ginsengfood.vn/` | 200; một mã QR thử trả trang truy xuất |
| 7 | `https://mkt.ginsengfood.vn/` | 301 → `/admin/` |
| 8 | `https://mkt.ginsengfood.vn/api/admin/ads/dashboard` không token | 401 |
| 9 | `https://mkt.ginsengfood.vn/health` và đường nội bộ M5 | 404 |
| 10 | `http://<mọi tên>/` | 301 → https (nếu cổng 80 mở) |
| 11 | tên lạ / `https://14.224.139.101/` | 404 hoặc từ chối TLS, không lộ app |
| 12 | chứng chỉ | đúng tên, đủ chuỗi, còn ≥ 30 ngày, chỉ TLS 1.2/1.3 |
| 13 | IP khách | log app thấy IP 4G thật, không phải `.98` hay IP router |
| 14 | cập nhật app | khởi động lại M5 → `ginsengfood.vn`, `ops.` vẫn 200; `caddy reload` không rớt kết nối |

## 9. Tin chốt với Anh Tuấn (Toàn gửi, chỉ tin nhắn)

**ĐÃ GỬI 17/11 09:4x (Toàn sửa nhẹ: bỏ câu "anh em về nhà", câu staging; câu 3 "> 8 GB"; câu 5, câu kết).** Bản 17/11 09:3x theo D-lead-058 (chỉ nhờ việc bên mình không tự làm được, không hỏi thêm), gửi kèm tệp Excel đã sửa.
Thay mọi bản trước (bản 09:1x, 09:2x cùng mục này và tệp `2026-11-17-tin-anh-tuan-https-98.md` đều không gửi).

```text
Dạ anh Tuấn, em gửi anh file Excel máy chủ em sửa lại theo mấy ý anh nói hôm qua nha.

Bên em chốt vầy:
- Cổng vào bên em lo: dựng proxy trên máy .98, chứng chỉ SSL em mua bên Mắt Bão rồi cài lên đó. Proxy chạy riêng, cập nhật app nào cũng không ảnh hưởng app khác.
- Tên miền giữ như cũ (ginsengfood.vn, www, ops, pwa, trace, mkt, video), mở ra ngoài hết vì trang nào cũng có đăng nhập, anh em về nhà vẫn vô làm được. Tên staging em vẫn chuyển về máy .63 như cũ.
- Ngoài Internet chạy https hết, ai gõ http thì tự chuyển qua https. DNS giữ nguyên.

Em nhờ anh mấy việc bên em không tự làm được:
1. Chuyển cổng 443 với 80 của IP công ty về máy .98, giữ IP thật của khách (đừng đổi thành IP router). Hai cổng này anh đừng chặn IP nước ngoài giúp em, vì Facebook gọi về từ nước ngoài.
2. Bật quay vòng trên router, hoặc trỏ DNS nội bộ mấy tên trên về .98, để ngồi trong công ty gõ tên miền vô được.
3. Nâng RAM .98 lên trên 8 GB, giờ hơn 3 GB thôi, thêm proxy là chật.
4. Khi nào em dựng xong proxy với chứng chỉ trên .98 thì em báo anh, anh chuyển cổng giúp em nha.
5. Máy ảo cho Video Giờ Vàng (Ubuntu 22.04 server, 8 nhân, RAM 16 GB, ổ 1 TB, không cần card) với một máy thử giống .99, anh tính khi nào có giúp em.

Em cảm ơn anh nhiều nha.
```

## 10. Anh Tuấn trả lời

- 17/11 ~10:1x (Toàn kể): Anh Tuấn **đồng ý** cả 5 việc. Khi phiên lead báo proxy + chứng chỉ trên .98 sẵn sàng thì anh chuyển cổng. Giờ cụ thể, RAM .98, quay vòng/DNS nội bộ, máy video: chờ anh làm, ghi tiếp ở đây.

- 17/11 ~14:5x Anh Tuấn nhắn: "http và https public trỏ về https .98 rồi" (trước khi mình báo sẵn sàng; Caddy còn chứng chỉ nội bộ). Kiểm 14:5x–15:0x:
  log Caddy .98 có 3 lượt từ IP công khai 113.161.59.x vào cổng 80 (308 → https, IP thật giữ được); nhưng check-host (DE, JP, US, RU, UA, ES, SI) tới `14.224.139.101`
  vẫn ra máy cũ: https mọi tên 302, `/admin` 404, http 400 — **chưa tới .98**, không có dòng log nào từ các nút đó. Đã soạn tin hỏi lại Anh Tuấn.

- 17/11 15:04 Toàn thử bằng 4G: `https://ops.ginsengfood.vn` ra **trang đăng nhập router DrayTek Vigor2915** (chứng chỉ tự ký của router) → cổng 443 (và có lẽ 80) của
  IP công ty đang do **trang quản trị router** giữ, nên luật chuyển cổng về .98 không có tác dụng; các lần "302" từ 14/11 cũng là router, không phải nginx Anh Tuấn.
  Cần Anh Tuấn đổi cổng quản trị từ xa của router khỏi 443/80 (tốt nhất tắt quản trị qua Internet hoặc chỉ cho vài IP). Trang đăng nhập router đang lộ ra Internet.

- 17/11 ~15:5x **Cổng 443 đã vào .98**: check-host (DE, ID, IR) `https://ops.ginsengfood.vn/` → 307 `/login` (proxy mình); log Caddy 60 phút: 927 lượt từ IP công khai
  (HTTP/2 + TLS, `ginsengfood.vn` 200 ×899, IP thật giữ được). **Cổng 80 từ ngoài: hết giờ** (http → https chưa chạy). Chứng chỉ vẫn nội bộ Caddy (trình duyệt cảnh báo) — chờ Mắt Bão.

## 11. Đường lui

- Lỗi cấu hình proxy: chép lại `Caddyfile.bak`, `caddy reload` (dưới 1 phút).
- Proxy hỏng hẳn hoặc .98 sập: nhờ Anh Tuấn trả chuyển cổng về như trước (DNS không đổi nên lui trong vài phút); app trong LAN vẫn chạy như hiện nay.
- Không xoá gì trên .99/.98 khi cắt; không đổi cấu hình app nào trong pha 2.

## 12. Kiểm toàn diện 18/11 10:0x–10:4x (phiên lead, chỉ đọc)

Đạt: DNS 8 tên, chứng chỉ Sectigo đủ chuỗi (hạn 03/06/2027), chỉ TLS 1.2/1.3, OCSP stapling, **SSL Labs A** cho `ginsengfood.vn` và `mkt.`;
proxy .98 khớp bản máy Lead. Danh sách 15 việc còn lại (có chi tiết an ninh chưa sửa) để ngoài git, vì repo này công khai:
`modules/lead/ra-soat/2026-11-18-kiem-ten-mien/ket-qua-kiem.md`. Câu chờ Toàn: lead.100, lead.101.
