# Gửi Phúc · 20/11/2026 · cập nhật nginx repo bán hàng lên 1.30.7 (đồng bộ mọi chỗ)

## Vì sao

nginx.org công bố 4 lỗi mới (1 lỗi nặng ở HTTP/2 flow control, 3 lỗi trung bình: HTTP/2, HTTP/3, resolver). Bản vá: **stable 1.30.7** (mainline 1.31.9).
Mọi bản tới 1.31.8 đều dính. Nhánh 1.27 đã hết hỗ trợ. Anh Tuấn đã hỏi, Toàn đã hứa cập nhật ngay.

Kiểm .99 sáng 20/11 (chỉ đọc):

| Container | Service compose | Bản đang chạy |
|---|---|---|
| `m34-nginx-1` (web bán hàng) | `nginx` (`compose.yml`, `nginx:stable-alpine`) | 1.30.6 |
| `m34-m5cua-nginx-1` (cửa TLS cho M5 gọi M3, cổng 8446) | `m5cua-nginx` (`compose.m5-cua.yml`, `nginx:1.27-alpine`) | 1.27.5 |
| `m34-m8that-cb-1` (cửa TLS M8 báo kết quả về M3, cổng 8445) | `m8that-cb` (`compose.m8-that.yml`, `nginx:1.27-alpine`) | 1.27.5 |

## Bản đích — dùng chung một bản cho mọi chỗ

**`nginx:1.30.7-alpine`** (ghim đúng số bản, không dùng `stable-alpine` hay `1.30-alpine` để mọi máy chạy giống nhau và không tự nhảy bản).
Docker Hub 18/11: `1.30.7-alpine` = `1.30-alpine` = `stable-alpine`, cùng digest amd64 `sha256:4d1d4ce08432…`.
M8 (phiên của Toàn) cũng đưa `m8-https`, `m8-ari` về đúng bản này.

## 1. Trong repo (nhánh `dev`, qua PR, CI khuôn xanh)

Đổi mọi dòng `image: nginx:…` trong `deploy/m34/` sang `nginx:1.30.7-alpine`:
- `compose.yml:372` (`nginx`)
- `compose.m5-cua.yml:41` (`m5cua-bi-mat`), `:81` (`m5cua-nginx`)
- `compose.m8-that.yml:40` (`m8that-bi-mat`), `:116` (`m8that-cb`)
- `compose.m8-gia-lap.yml:205`
- test `deploy/m34/tests/test_m8_that.py:545` (đang khẳng định `nginx:1.27-alpine`) → bản mới
- README `deploy/m34/README.md` dòng 495, 519, 830, 842 → bản mới

Chạy bộ test `deploy/m34/tests` (khuôn `kiem-tra-khuon`) xanh rồi mới gộp.

## 2. Trên .99 (`/data/ginsengfood-business-platform`)

1. Sao lưu: `.env` và ba tệp `compose.yml`, `compose.m5-cua.yml`, `compose.m8-that.yml` (`cp -p <tệp> <tệp>.tu-$(date +%Y%m%d-%H%M)`).
2. Sửa **chỉ dòng `image:` của nginx** trong ba tệp trên sang `nginx:1.30.7-alpine`. Không đổi `COMPOSE_FILE` (lớp `compose.cong-khai.yml` phải ở cuối).
3. `docker pull nginx:1.30.7-alpine`
4. Kiểm cấu hình bằng image mới **trước khi** tạo lại, từng service, có gắn đúng tệp cấu hình như lúc chạy:
   `docker compose run --rm --no-deps --entrypoint nginx <service> -t` với `<service>` = `nginx`, `m5cua-nginx`, `m8that-cb`. Cả ba phải "syntax is ok / test is successful".
5. Tạo lại **chỉ ba service nginx, có `--no-deps`**:
   `docker compose up -d --no-build --no-deps --wait nginx m5cua-nginx m8that-cb`
   - `--no-deps` để **không chạy lại** `m5cua-bi-mat` / `m8that-bi-mat` (job sinh chứng thư/bí mật; chạy lại có thể đổi chứng thư làm M5, M8 hết tin cửa TLS).
   - Web bán hàng gián đoạn vài giây lúc tạo lại `nginx`.
6. Kiểm và gửi Toàn kết quả:
   - `docker exec <container> nginx -v` = `nginx/1.30.7` cho cả ba container.
   - `https://ginsengfood.vn/vi` và `/admin` trả 200.
   - Cửa 8446 (M5 → M3) và 8445 (M8 → M3) vẫn mở TLS: `curl -k -s -o /dev/null -w '%{http_code}' https://192.168.1.99:8446/` và `:8445/` (mã lỗi 4xx là được, miễn không phải "connection refused" hay lỗi TLS).
   - Trong `be`: `OTP_SMS_EXPOSE_MOCK_CODE=false`, `APP_IVR_INTEGRATION_ENABLED=false` (không đụng `be` thì không đổi, vẫn kiểm cho chắc).
   - Lùi: chép lại các tệp `.tu-…`, `docker compose up -d --no-build --no-deps --wait nginx m5cua-nginx m8that-cb`.

## 3. Báo lại

Giờ làm, bản nginx ba container, kết quả bước 6. `deploy/compose.lan.yml` (bộ LAN cũ, không chạy) đổi theo cho đồng bộ khi tiện, không gấp.
