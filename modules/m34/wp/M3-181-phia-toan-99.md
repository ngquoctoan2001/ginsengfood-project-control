# M3-181 phía Toàn trên .99: kế hoạch (m34 phụ soạn 14/11 13:00) · 14/11 21:25: bước 1 (.99 chạy afb6d404c, có M3-181) XONG; bước 3 cửa 8446 XONG 22:22 (từ .98: 503/403/404); bước 2 (bật token) chưa

Nguồn: `hop-thu/m34-2026-11-13-m3-181-phia-toan.md` (mục 1–8). Rủi ro: R3 (xác thực, cổng mạng). Mỗi bước ghi máy cần Toàn duyệt riêng.

## Hiện trạng đo được (14/11 12:56–13:00, chỉ đọc)

| Mục hộp thư | Trạng thái |
|---|---|
| 1. nginx khối `/api/v1/internal/orders/by-code/` chỉ `.98`, chỉ GET | **ĐANG CHẠY trên .99**: `nginx/m34.conf` .99 trùng hệt bản `toandeptrai` (sha `2569444583ae`), `nginx -T` thấy `allow 192.168.1.98; deny all; limit_except GET` |
| 6. 2 biến `be.environment` (`AUTH_M5_ORDER_STATE_ENABLED`, `M5_ORDER_STATE_SERVICE_TOKEN`) | có trong `deploy/m34/compose.yml` của `toandeptrai`; **`compose.yml` trên .99 là bản cũ, thiếu 2 biến** (và thiếu `OPS_CORE_ALLOCATION_QUOTA_MAX_LINE_QUANTITY`); `.env` .99 chưa có 2 khoá |
| Mã M3-181 của Phúc (`5928cfe35`, 13/11 16:37) | có trong `dev` = `9bc855de8` (CI `m34-images` xanh, có image); **image đang chạy trên .99 là `f9e179a45`, CHƯA có mã M3-181** → gọi by-code lúc này ra 404 của Spring |
| 2. Đường `/api/v1/internal/*` cũ đi ra ngoài qua `location ^~ /api/` | nhật ký nginx .99 6 giờ qua: **0 lượt** gọi `/api/v1/internal/*` hay `/internal/*` qua :80. Front-end không gọi `v1/internal` (git grep). Callback M8 đi cầu 8445 thẳng `be`, không qua :80 |
| 3–4. Token M5 + bật cổng | chưa (chờ bước 1) |
| 5. Script SQL 4 đơn thử GF-TEST | Phúc đã đặt `deploy/m34/don-thu/` (`nap-don-thu.sql`, `go-don-thu.sql`, trong `dev`); **chưa rà** |
| 8. Cửa TLS nội bộ cho M5 | chưa có. Cổng 8446 trên .99 trống. Client M5 (`http-m4-advisor.ts`) bắt buộc `https:` khi không phải loopback, không có tuỳ chọn CA riêng → Tài phải đặt `NODE_EXTRA_CA_CERTS` cho M5 |
| M4 advise trên .99 | **đóng (fail-closed)**: compose không có `AUTH_M4_CHANNEL_ADVISE_ENABLED`/`M4_CHANNEL_SERVICE_TOKEN`, `AI_RUNTIME_ENABLED=false`, profile `demo`. Cửa TLS dựng xong thì M5 gọi advise vẫn nhận 403 (M5 hiểu `M4_AUTH_REJECTED`) tới khi Go/No-go M4 (D-m34-064) |

## Bước 1: đưa .99 lên bản có M3-181 (deploy, Toàn duyệt)

Bản đích: SHA đầu `toandeptrai` sau khi push 4 commit (`a1fc34ba5`, cùng back-end/front-end với `9bc855de8`; CI sẽ dựng image vì commit đổi `deploy/m34/**`).
Đi kèm: 8 migration mới V350–V357 (golden hour, program 24/7, audit log; V355/V357 chặn TRUNCATE bảng audit), 15 commit/431 tệp của Phúc gộp sáng 14/11 **chưa chạy test** (Toàn "khỏi test").

1. (chỉ đọc DB thật) Thử Flyway trên bản sao: dựng pg tạm trên .99 từ bản sao lưu mới nhất, chạy be mới với CSDL tạm, xem V350–V357 sạch, 0 ERROR;
   trên chính bản sao đó chạy `don-thu/nap-don-thu.sql` rồi `go-don-thu.sql` (phải ra `0 0`; V355/V357 chặn TRUNCATE + sửa/xoá nhật ký giá); xoá container + volume tạm.
   Trước bước 2: thêm `ADMIN_ALLOWED_EMAIL_DOMAINS`, `ADMIN_SAMPLE_ACCOUNT_DOMAINS` vào `be.environment` (chi tiết `chuyen-may-99.md` mục "Trước m34.99"; .99 hiện không khoá vì profile `demo` + 42 tài khoản mẫu `.local`). Sau bước 3 Toàn tự đăng nhập `/admin`.
2. Chép `compose.yml` + `env.mau` + `m8-that/kiem-m3-chi-doc.sh` bản `toandeptrai` lên .99 (giữ `.tu-truoc`), không đổi `.env` (biến mới mặc định tắt).
3. `trien-khai.sh <sha40>`: tự sao lưu `pg_dump`, đổi image, kiểm qua nginx, tự về image cũ nếu hỏng (CSDL không tự lùi: khôi phục từ dump của lượt).
4. Kiểm: 7 dịch vụ khoẻ, 4 đường 200, Flyway 326 dòng 0 hỏng, 0 ERROR; `GET by-code` từ máy Lead → 403 (nginx), từ trong `be` → 503 (công tắc tắt); `kiem-m3-chi-doc.sh --don=577` → `AP_DUNG_MOT_LAN`.
Gián đoạn: web M3/M4 khoảng 1–3 phút lúc `be` khởi động lại. Không có lịch M8 bật trong lúc này.

## Bước 2: bật cổng M3-181 (Toàn duyệt, sau khi Tài gọi thử stub xong)

Sinh token trên .99 (`openssl rand`), ghi thẳng `.env` (600) cùng `AUTH_M5_ORDER_STATE_ENABLED=true`, tạo lại riêng `be`; không in giá trị.
Toàn lấy token trên máy đưa Tài (kênh riêng, không ghi sổ) cho `M3_ORDER_STATE_SERVICE_TOKEN` bên M5. Rà + chạy script đơn GF-TEST của Phúc là lượt riêng.

## Bước 3: cửa TLS nội bộ cho M5 (soạn + thử ở máy Toàn trước, lên máy là lượt riêng)

- Tệp mới `deploy/m34/compose.m5-cua.yml` theo khuôn cầu M8 (`compose.m8-that.yml`, dịch vụ `m8that-cb`): nginx nghe `192.168.1.99:8446` → 8443 trong container, TLS 1.2/1.3,
  chứng thư lá SAN `IP:192.168.1.99` ký bởi CA riêng `m5-cua` (khoá CA, khoá lá ở `secrets/` 600 trên .99, không rời máy).
- `allow 192.168.1.98; deny all;` · đúng 2 đường: `GET` regex `^/api/v1/internal/orders/by-code/[A-Za-z0-9_-]+/channel-state$`, `POST = /api/v1/m4/channel/advise` (thân ≤ 64 KB);
  còn lại 404; `proxy_pass` thẳng `be:8080`, đặt `X-Forwarded-For $remote_addr`, giữ `X-M5-Service-Token`.
- `compose.yml`: thêm `AUTH_M4_CHANNEL_ADVISE_ENABLED: ${…:-false}`, `M4_CHANNEL_SERVICE_TOKEN: ${…:-}` (mặc định tắt, như 2 biến M3-181).
- Cùng lượt (mục 2): khối :80 `location ^~ /api/v1/internal/ { return 404; }` (giữ khối by-code .98 và webhook M12 riêng) → đường nội bộ chỉ đi cổng riêng (8445 M8, 8446 M5).
- Thử: test khuôn (`tests/test_compose.py`, test nginx) + nginx thật trong container (như kiểm cầu M8), host giả; commit trên `toandeptrai`, push hỏi riêng.
- Lên máy: dựng `m5-cua` trên .99; **Toàn sudo** thêm dòng `8446 192.168.1.98` vào `/etc/ginsengfood/cong-noi-bo.conf` + `sudo systemctl restart gf-tuong-lua`;
  đo nguồn từ .98 (Tài gọi thử), từ máy Lead phải 403. Gửi Tài: địa chỉ `https://192.168.1.99:8446` + tệp `ca-m5-cua.pem` (không gửi khoá).
