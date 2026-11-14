# Tên miền và máy chủ chính thức · góp ý Anh Tuấn · 11/11/2026

Nguồn: Toàn kể lại cuộc gọi sáng 11/11 với Anh Tuấn (dựng mới trên máy chủ vật lý của công ty, chia nhỏ; Chú Dũng xem và thao tác
trực tiếp). Trước đó: 8 tên Chú duyệt 09/11 (D-lead-029). **Chưa chốt**, chờ Anh Tuấn trả lời; chốt xong ghi `/quyet` và báo Chú
(bỏ `admin.`, `api-ops.` là đổi danh sách Chú đã duyệt).

## Hướng đã thống nhất với Toàn (11/11)

- Cấu hình máy (máy ảo hay cài thẳng, cỡ CPU/RAM/ổ) Anh Tuấn tự quyết; bên mình chỉ góp ý cách gom.
- Gom: nhà máy (M1–M2) + bán hàng (M3, M4, M9) + phần ứng dụng M8 chung một chỗ (gọi nhau theo từng đơn);
  marketing (M5–M6, `mkt.`) riêng; video (M7, `video.`) riêng; Asterisk riêng.
- Tên miền: quản lý bán hàng thành `ginsengfood.vn/admin` (web bán hàng đã phục vụ `/admin`, không sửa mã); bỏ `admin.` và `api-ops.`
  (M3 gọi M1–M2 trong mạng nội bộ). Giữ tên con `ops.`, `pwa.`, `trace.`, `mkt.`, `video.`: mỗi trang là một ứng dụng chiếm gốc
  `/`, `/_next`, `/api`; trùng `/api/v1/admin` (bán hàng 145 controller và M1–M2), `/admin` (bán hàng và `basePath` M5–M6),
  M7 chiếm `/api`, `/auth`, `/me`; dồn chung phải sửa 5 repo (có mã Phúc, Tài). DNS gọn bằng một bản ghi `*.ginsengfood.vn`.
- `trace.` có thể đổi sang `ginsengfood.vn/truy-xuat` (chỉ sửa mã M1–M2, `PublicTrace__BaseUrl`), phải chốt trước lô tem đầu; hiện giữ `trace.`.
- Trỏ xong đóng, chỉ dùng nội bộ, trừ đường đối tác gọi về: VNPAY `ginsengfood.vn/api/v1/payments/webhooks/*`, Facebook
  `mkt.ginsengfood.vn/api/channel/meta/webhook`, trang chính sách riêng tư/xoá dữ liệu, GHN/VTP khi bật vận chuyển. Ở ngoài vào qua VPN.
- Cổng vào: máy nginx của Anh Tuấn đang giữ 443 + HTTPS, giữ vai đó; không đề xuất máy riêng.
- Cách ly: mỗi module một bộ container + CSDL riêng, kéo image theo commit, kiểm `/health`, lỗi tự quay lui (D-lead-017).
  Sao lưu ra ngoài máy vật lý (bài học 11/11: sao lưu ngoài máy .61 lỗi 64 mỗi đêm).

Việc kéo theo khi chốt: đường chính sách riêng tư Facebook/Google (luồng `m5`), đường webhook GHN/VTP (luồng `m34`) để gửi Anh Tuấn.

## Tin nhắn gửi Anh Tuấn (Toàn tự gửi)

Chỉ nói chia máy và tên miền, không hướng dẫn Anh Tuấn cách làm (Toàn dặn 11/11). Đường đối tác gọi về, VPN, sao lưu
nêu sau khi Anh Tuấn trả lời, nếu cần.

Dạ anh Tuấn, em gửi anh cách chia máy và tên miền bên em đề xuất theo góp ý sáng nay, anh xem qua và góp ý giúp em nha.

1. Máy nhà máy + bán hàng (hai bên gọi qua lại theo từng đơn nên để chung):
- ginsengfood.vn (và www): web bán hàng
- ginsengfood.vn/admin: quản lý bán hàng, đơn hàng, giao hàng, gọi xác nhận đơn
- ops.ginsengfood.vn: vận hành sản xuất, nhập kho, thu hồi
- pwa.ginsengfood.vn: ứng dụng anh em xưởng dùng trên điện thoại, máy tính bảng
- trace.ginsengfood.vn: truy xuất nguồn gốc, khách quét mã trên tem

2. Máy marketing (kết nối Facebook/YouTube, đo quảng cáo):
- mkt.ginsengfood.vn

3. Máy video Giờ Vàng:
- video.ginsengfood.vn

4. Tổng đài Asterisk: giữ riêng như anh nói.

So với danh sách trước: admin. chuyển thành ginsengfood.vn/admin, bỏ api-ops. vì chỉ dùng nội bộ. ops., pwa., trace. em xin giữ tên con, vì mỗi trang là một ứng dụng riêng, dồn vào ginsengfood.vn thì bị trùng đường dẫn, bên em phải sửa lại mã, sợ không kịp 30/11.

Anh thấy chỗ nào chưa hợp lý thì góp ý giúp em nha. Em cảm ơn anh.

## Tiến độ

- 13/11: Anh Tuấn báo **máy mkt xong**: 192.168.1.98, hệ điều hành mặc định + SSH, "cần gì thì mình cài thêm".
  Mọi dữ liệu đặt trong `/data` để sao lưu và mở rộng. Tài khoản gửi trong Zalo (không chép vào sổ).
  Các máy còn lại (nhà máy + bán hàng, video, máy thử) chưa có tin.
- 13/11 12:43: D-lead-034: M5 + M6 lên máy mkt ngay (thay .60), Tài dựng nền + app, giữ mật khẩu Anh Tuấn cấp.
  Go/No-go M4/M5/M6 tính theo "`mkt.` trên máy mkt có HTTPS", chậm nhất 20/11.
- Còn mở lead.81: máy nhà máy + bán hàng chuyển trước hay sau 30/11 (đề xuất: có máy trước 20/11 thì chuyển trước 30/11, sau 20/11 thì
  chạy thật trên .60/.61 rồi chuyển sau, hẹn giờ dừng). Lý do mkt có trước không làm trễ: nhà máy + bán hàng đang chạy trên .60/.61,
  cùng LAN; `mkt.` thì chưa có HTTPS ở máy nào và đang chặn Go/No-go.

- 13/11: tin Tài đã gửi (`2026-11-13-tin-tai-may-mkt.md`). Tin dưới **không gửi**: Toàn chờ Anh Tuấn tự báo khi xong
  (HTTPS `mkt.` qua nginx 443 của Anh Tuấn, máy nhà máy + bán hàng). Tài dựng M5/M6 xong thì báo cổng để Anh Tuấn trỏ `mkt.`.

- 13/11 (chiều): Anh Tuấn báo **máy "SRV Ginsengfood" chạy www xong: 192.168.1.99**, tài khoản SSH `ssv` (mật khẩu gửi trong Zalo,
  không chép vào sổ). Theo cách chia 11/11 đây là máy nhà máy + bán hàng. Có trước 20/11 → trình lead.81 (chuyển trước 30/11) và
  lead.82 (ai dựng) trong `TRANG_THAI.md`. Còn máy video, máy thử chưa có tin; HTTPS `mkt.` chưa có tin.

### Tin trả lời Anh Tuấn 13/11 (bản nháp, không gửi)

Dạ em cảm ơn anh nhiều. Bên em sẽ để hết dữ liệu trong /data như anh dặn.
Anh cho em hỏi thêm 2 chuyện ạ:
1. mkt.ginsengfood.vn trỏ về máy này có HTTPS thì anh làm giúp em phía router luôn, hay bên em tự cài trên máy ạ? Bên em cần sớm để Facebook gọi vào được.
2. Máy nhà máy + bán hàng anh tính khoảng khi nào xong ạ? Kịp trước 20/11 thì bên em chuyển sang luôn trước khi chạy thật 30/11, không kịp thì bên em chạy tạm trên .60, .61 rồi chuyển sau.

## Máy .99: cổng vào và lịch cắt (D-lead-035, phiên `lead` dựng nền, 13/11 14:50)

Dữ kiện: kiểm kê .99 (`KIEM_KE_MAY_CHU.md` §10); scout đọc `deploy/m34` (toandeptrai), `deploy/m12`, `deploy/m8`; tra DNS công khai
qua 1.1.1.1 lúc 14:44. Cổng vào theo hướng 11/11 (máy nginx của Anh Tuấn giữ 443 + HTTPS, trỏ theo tên). D-lead-036 (13/11 14:52, Toàn duyệt) thay phần cổng vào của D-lead-028 ("proxy trước trên
.60"): không dựng proxy trước trên máy nào của mình. Gói m34 còn viết theo D-lead-028 (`m34.conf:152`) → phiên m34 sửa; gói m12 đã theo hướng 11/11.

**Hiện trạng DNS (tra lại 13/11 16:30, có dấu chấm cuối):** tên miền quản lý ở **Mắt Bão** (`ns1/ns2.matbao.vn`, serial 2026110910); mọi tên (`ginsengfood.vn`, `www.`, `ops.`, `pwa.`, `trace.`, `mkt.`, `api-ops.`, `staging.`) **đã trỏ IP công ty 14.224.139.101**; 13/11 16:45 Toàn xoá `admin`, `api-ops` (đã bỏ khỏi danh sách 11/11), còn @, www, ops, pwa, trace, mkt, video, staging. Từ ngoài Internet, cổng 443 của IP này bị từ chối (13/11 16:30) → **chưa tên nào chạy thật**. Bản tra cũ (165.160.13.20/15.20) **sai**: máy Lead tự gắn hậu tố `ssv.com` (vùng của CSC, có bản ghi đại diện) khi tra không dấu chấm cuối.
Toàn vào được trang DNS Mắt Bão, tạo bản ghi được; hiện không cần tạo thêm. Việc còn lại là của máy nginx Anh Tuấn (chuyển theo tên + HTTPS).
Trỏ tên **không phải bước của cửa sổ cắt**: các luồng cắt bằng IP LAN; Anh Tuấn chuyển thẳng về đích mới khi sẵn sàng.

**Đụng cổng:** trên .99, nginx gói `ginsengfood-business-platform` và Caddy gói `ginsengfood-ops-core` đều nghe :80 → Caddy dời sang **8012** (biến `M12_HTTP_PORT`, phiên m12 đã thêm).

### Bảng cổng vào

| Tên / đường | Đích hiện tại | Đích mới | Ai đổi, khi nào |
|---|---|---|---|
| `ginsengfood.vn`, `www.` (web bán hàng, M4 trong đó) | DNS đỗ; bản LAN `http://192.168.1.60:80` (nginx `~/m34`) | nginx Anh Tuấn 443 → `http://192.168.1.99:80` | Anh Tuấn (DNS về IP công ty + HTTPS + upstream), sau khi cắt m34 |
| `ginsengfood.vn/admin` (quản trị M3, M8, M9) | như trên (fe phục vụ `/admin`) | như trên, cùng upstream | cùng lúc |
| `ginsengfood.vn/api/v1/payments/webhooks/*` (VNPAY), GHN/VTP | chưa mở | `.99:80` → be | chỉ mở ra ngoài khi bật đối tác thật (Toàn nói) |
| `ops.`, `pwa.`, `trace.` | DNS đỗ; Caddy `192.168.1.61:80` theo Host | nginx Anh Tuấn 443 → `http://192.168.1.99:8012` | Anh Tuấn, sau khi cắt m12 |
| `api-ops.` | bỏ khỏi danh sách công khai (11/11) | không trỏ ra ngoài; M3/M6/M7 gọi `http://192.168.1.99:5000` | — |
| `mkt.` | máy mkt .98 (D-lead-034) | không đổi | Tài báo cổng, Anh Tuấn trỏ |
| `video.` | M7 trên .60 (edge `127.0.0.1:6700`) | không đổi | phiên m7 |
| `staging.` | 03/11: nginx Anh Tuấn → .63:8080; DNS trỏ IP công ty (không phải tên của mình, giữ) | không đổi | — |

### Cổng LAN trên .99 (`kich-ban/cong-noi-bo.conf`, lọc ở DOCKER-USER vì cổng Docker đi vòng ufw)

| Nguồn | Cổng .99 | Dùng cho |
|---|---|---|
| LAN 192.168.0.0/23 | 80 | nginx `ginsengfood-business-platform`: máy nginx Anh Tuấn + máy trong LAN (13/11 Toàn chốt không xin IP nginx: giữ cả LAN, app tin dải LAN cho IP khách) |
| LAN 192.168.0.0/23 | 8012 | Caddy `ginsengfood-ops-core`: `ops.`, `pwa.`, `trace.` |
| .60, .98 | 5000 | API M1–M2: M7 (+ M3 lúc còn ở .60), M6 máy mkt |
| 192.168.0.64 (máy Lead) | 8443 | M8: công cụ nghiệm thu M3–M8 (nginx M8 trên .61 đang cho máy này) |
| .60 (tạm) | 8443 | M3 còn ở .60 gọi M8 đã sang .99 (m34 đã sang .99 14/11: giữ cho đường lui `lui-60`, xoá sau 15/11) |
| .61 (tạm) | 8445 | M8 còn ở .61 gọi lại cầu callback M3 đã sang .99 (m8 đã sang .99 14/11: giữ cho đường lui `quay-lui`, xoá sau 15/11) |

Không mở cho LAN: 5432/6379/3000–3002 (chỉ trong máy). Ra ngoài Internet: không cổng nào (router chưa chuyển). Asterisk .64 hiện **chặn .99**
(18089 đóng; ufw .64 chỉ cho .61), phải nhờ Anh Tuấn mở trước khi cắt m8. ufw .99 thêm một luật: dải container → cổng 18088 trên máy
(ARI Asterisk S5 của gói m8 chạy mạng host).

### Ai gọi ai (đổi gì khi bên kia chuyển)

- m12 chuyển → M3 `OPS_CORE_BASE_URL`, M6 `M6_OPSCORE_BASE_URL`, M7 `M7_OPSCORE__BASEURL` đổi sang `http://192.168.1.99:5000`; allowlist app M1–M2
  (`M12_SOURCE_ALLOWLIST_0` một mục → thêm .98); `AllowedHosts` ghim .61; CI ssh `ssv@192.168.1.61`; tác vụ kéo sao lưu 23:30 máy Lead.
- m34 chuyển → M5 (.98) `M4_ADVISOR_BASE_URL`, `M3_ORDER_STATE_*`; M7 `M7_M3__BASEURL`; M6 `M6_M3_BASE_URL`; M1–M2 webhook allow `192.168.1.61`
  trong `m34.conf`; cầu callback M8 (chứng thư SAN IP .60, `M8_ALLOW_IP`); CORS/cookie (`http://192.168.1.60`).
- m8 chuyển → M3 `M8_ORIGIN` + ghim `ca-m8.pem` (chứng thư lá `CN=192.168.1.61`, CA cũ đã mất → phải cấp mới); M8 `Issuer`, IP cứng
  `192.168.1.61:8443` trong `deploy/m8/compose.yml:186`, `M8_DIA_CHI`; .64 ufw + khoá ssh từ .61; `offhost.py` chặn đích .61/.64.

Thư mục trên .99 theo tên repo (D-lead-037): `/data/ginsengfood-ops-core`, `/data/ginsengfood-business-platform`, `/data/ginsengfood-ivr`.

### Lịch cắt (D-lead-036, bỏ khung giờ theo D-lead-038 13/11 15:51)

**Không chờ giờ cố định:** luồng nào kịch bản sẵn (test host giả xanh, image đúng SHA trên registry) thì cắt ngay, Toàn duyệt liền một lượt (push + các pha). Chụp CSDL máy cũ ngay trước khi dừng ghi; nhắn nhóm Phúc/Tài một câu trước khi dừng ghi. Khung đêm cũ (m12 22:30, m34 14/11 22:45, m8 21:15) bỏ vì chưa có giờ xưởng thật, chưa tên miền nào sống, scheduler M8 đang tắt.

Giờ xưởng thật: **không có nguồn** (chỉ có ca mẫu 06:00–14:00, 14:00–22:00 trong dữ liệu giả). Khung gọi M8 08:00–21:08 (Giờ Vàng tới 22:08,
scheduler đang tắt); CSKH 08:00–20:00; sao lưu: m12 22:00, m34 22:30 (giờ VN). Mỗi cửa sổ: kịch bản soạn sẵn theo pha, Toàn duyệt liền.

| Thứ tự | Luồng | Khi nào | Dừng ghi ước | Điều kiện trước | Vì sao thứ tự này |
|---|---|---|---|---|---|
| 1 | m12 (M1–M2) | **xong 13/11 19:15** (bản 87acc810) | 20–30 phút (CSDL ~15 MB) | nền .99 xong; `/data/ginsengfood-ops-core` dựng sẵn, pull đúng SHA, /health xanh; kịch bản thử host giả | ít bên phụ thuộc: M3 trên .60 chỉ đổi `OPS_CORE_BASE_URL` (13/11: không cần, M3 .60 đang tắt gọi M12) |
| 2 | m34 (M3 + M4 + M9) | **xong 14/11 07:36** (lượt 3; lượt 13/11 21:50 dừng ở B0, lượt 14/11 07:22 dừng ở B4 rồi lui sạch) | 45–60 phút (kéo image ~6 phút làm trước; CSDL + `m34_uploads`) | m12 đã ở .99; image đúng SHA kéo sẵn; tin nháp Phúc/Tài/anh Mạnh; M5 đổi địa chỉ | gói lớn nhất, nhiều bên gọi; M8 còn ở .61 gọi lại qua 8445 (đã mở tạm) |
| 3 | m8 (app M8) | **xong 14/11 08:50** (pha b 07:43–07:46, bản 10f335de, 37 bảng khớp, gián đoạn ~2 phút) | 20–30 phút | Anh Tuấn mở .64 cho .99; chứng thư 8443 mới (IP .99), M3 ghim lại | bị chặn bởi .64; cắt sau cùng thì M3 + M8 hội tụ một lần |

Sau mỗi cửa sổ: máy cũ dừng app, giữ nguyên dữ liệu làm đường lui tới khi Toàn cho gỡ; gỡ dòng "tạm" trong `cong-noi-bo.conf` khi cả ba đã ở .99.
