# deploy-m4-99-sep-test — đưa bản `dev` có M4 lên .99 cho buổi sếp test (18–19/11), m34 chạy

Trạng thái: CHỜ (chuẩn bị; lượt ghi .99 chiều 17/11, Toàn duyệt lúc chạy) · Rủi ro: R3 (ghi máy chạy thật, đổi cờ, dữ liệu giả chung CSDL) · Chế độ: lượt ssh có kịch bản · Mốc: 17/11 chiều
Nguồn: m34.115 A (D-m34-092); runbook của Tài M4-PLAN `02_PROJECT_CONTROL/04_REPORTS/M4/SEP-TEST/RUNBOOK_60.md`; trả lời Q4 `ban-giao/2026-11-16-tra-loi-q4-tai.md`; log đọc .99 `C:\Projects\_wt\m34\doc-q4-99-20261116-2042.log`.

## Hiện trạng .99 (đọc 16/11 20:42)
- `be`/`fe` image `afb6d404c`; `COMPOSE_FILE` = compose + override + m8-that + m8-that.quan-tri + m5-cua. `OPS_CORE_ENABLED=false`.
- `compose.override.yml` dòng 30–40 GHI CỨNG profile `demo` + 10 cờ seed (đều `true`) → bảng cờ của Tài đặt qua `.env` không ăn với các khoá này.
- `OTP_SMS_EXPOSE_MOCK_CODE=true` (từ `compose.m8-that.yml`), AI tắt hết, khung chat FE tắt lúc build (`deploy/m34/build-args.60.json:13`, `test_khuon.py:55`).

## Điều kiện trước lượt ghi
1. Buổi gọi thử M8 (E07/E08, D-lead-056) xong hoặc Toàn bỏ: không đưa M3 mới lên .99 khi buổi đang chạy.
2. `dev` có PR #163 (Toàn, F1/F2 + khung chat, gộp 08:12 `3627ce4f0`) và PR #162 (Tài, gộp 08:59 → `dev` `2084740f9`). Image deploy = SHA `dev` Tài xác nhận, KHÔNG gồm PR #164 (giao diện IVR, gộp sau deploy, D-m34-096). CI `m34-images` trên SHA đó: `kiem-tra-khuon` + `build-images` xanh.
3. Tài gửi trước trưa 17/11: SHA cuối, bảng cờ theo đợt (mục 2–3 runbook), kịch bản kiểm (mục 5).
4. Khung chat FE: Toàn chọn bật (m34.118 A, D-m34-094) → `d1039f46f` đặt `NEXT_PUBLIC_AI_ADVISOR_WIDGET_ENABLED=true`, đi trong PR #163; image `fe` mới từ CI `m34-images` sau khi gộp. Tắt lại khi tên miền chạy thật.
5. Kiểm từ ngoài (check-host / 4G) ngay trước khi bật cờ test: tên miền chưa vào .99. Đã vào → dừng phần OTP giả + gói test, báo Toàn.
6. (D-m34-107) Thứ tự migration: `dev` từ `a48db1dc0` có V392–V395 (Phúc) mà V361–V391 (nhánh gộp chú) chưa vào; .99 ở V357, Flyway `out-of-order=false`. KHÔNG deploy `dev` lên .99 tới khi nhánh chú vào `dev`
   (hoặc Toàn chọn image `88d5fe01e` — tới V360, cần CI build đúng SHA đó). Trước lượt ghi: `git ls-tree` thư mục migration của SHA image, dãy số phải liền.

## Lượt ghi (bản nháp, viết kịch bản `_wt/m34/_tools/` khi có SHA)
- Sao lưu CSDL + chụp `compose.override.yml`, `COMPOSE_FILE` (giữ `.tu-<giờ>`), ghi SHA image cũ để lui.
- Chép `nginx/m34.conf` mới (D-m34-097: `X-Forwarded-Proto` theo proxy .98, webhook M12 `allow .99`) từ commit `toandeptrai` đã kiểm; chạy `docker run --rm --entrypoint nginx --add-host be:127.0.0.1 --add-host fe:127.0.0.1 -v <conf>:/etc/nginx/conf.d/default.conf:ro nginx:stable-alpine -t` trên .99 TRƯỚC khi tạo lại `nginx` (máy Lead không có image, CI không chạy `nginx -t`); lỗi → giữ conf cũ.
- Mạng `m34_app` ghim 172.24.2.0/24 (D-m34-099, `95dbab13f`): lần `up` đầu sau ghim Compose TỰ tạo lại mạng và dừng MỌI container → lượt này là CỬA SỔ DỪNG M3 ngắn (báo trước M8/Tài).
  Trước: `docker network inspect m34_app` (chỉ đọc) không có container lạ. Chạy ĐỦ BỘ `docker compose up -d --no-build --wait` (không mở đầu bằng `cong-tac-khan.sh`/`up be`: lỗi, be nằm dừng). Sau: cầu M8 (allow 172.24.2.1), be → M12 :5000, `/api/health/ready`.
- Kéo image theo SHA mới, `up -d be fe`, kiểm `/api/health/ready`, M3 → M8 vẫn chạy (quản trị IVR, `kiem-m3-chi-doc.sh`).
- Bật cờ theo đợt của Tài; khoá nằm trong override thì sửa override (ghi khác biệt), không sửa `.env` cho khoá đó.
- Sau buổi test: tắt cờ test theo mục 6–7 runbook; trước khi tên miền chạy thật: `OTP_SMS_EXPOSE_MOCK_CODE=false`, bỏ profile `demo`/cờ seed (việc trước 30/11).
- Lui: image cũ `afb6d404c` + override cũ + CSDL sao lưu.

## Nối M12 phía M3 (m34.123 — bước 1–4 XONG 17/11 15:2x–15:31, D-m34-100–102; KHÔNG bật cờ)
1. Chép `/data/ginsengfood-ops-core/m3.secret` → tệp secret M3 (`secrets/ops_core_client_secret`) ngay trên .99, 0600, không in, không qua chat/log.
2. Đọc danh sách kho M3 (chỉ đọc) → ghép `kho.csv` với `kho-m12.csv` (`WH_FG_MAIN`); M3 có > 1 kho active → dừng hỏi Toàn.
3. `ops-core/nap-link.sh --skus=… --kho=… --ky-vong-sku=19` chạy khô → đúng 19 SKU + 1 kho mặc định → `--ap-dung`, kiểm `ket_luan=DAT`.
4. Kiểm token từ `m34-be-1` bằng tệp mount (không `-e`), Host `api-ops.ginsengfood.vn`, `POST http://192.168.1.99:5000/v1/service-tokens`; GHI GIỜ GỌI (đến giây) báo M12 đọc IP nguồn (allowlist WP17b).
5. Bật quan sát (m34.124) sau buổi sếp test, từ 20/11: đặt `OPS_CORE_ENABLED=true`, `OPS_CORE_CLIENT_ID=SVC-M3-SELLABLE`, `OPS_CORE_BASE_URL=http://192.168.1.99:5000`, `OPS_CORE_ALLOW_PLAIN_HTTP=true` (+ Host `api-ops.ginsengfood.vn` nếu M3 cần), ENFORCE + giữ hàng tắt, `restart be`, kiểm `OPS_CORE_TOKEN_OK`.

## Sau HTTPS (tên miền chạy thật từ 17/11 ~16:3x, phiên lead)
- `.env` .99: `CORS_ALLOWED_ORIGINS` thêm `https://ginsengfood.vn,https://www.ginsengfood.vn` (giữ `http://192.168.1.99` tới pha 4); `AUTH_COOKIE_SECURE=true` — sau đó vào `/admin` bằng `https://ginsengfood.vn/admin` (LAN cũng được), không dùng `http://192.168.1.99/admin` nữa.
- OTP giả + nối IVR: ĐÃ TẮT 18/11 08:32 (m34.128 + m34.130, D-m34-105) bằng lớp chồng `.99` `compose.cong-khai.yml` đặt CUỐI `COMPOSE_FILE`
  (`OTP_SMS_EXPOSE_MOCK_CODE=false`, `APP_IVR_INTEGRATION_ENABLED=false`); kịch bản `_wt/m34/_tools/cong-khai-99.sh tat|lui`, log `_wt/m34/cong-khai-99-tat-*.log`,
  bản chụp `.env.tu-20261118-0832` trên .99. **Mọi lượt deploy sau: giữ `:compose.cong-khai.yml` cuối `COMPOSE_FILE` và kiểm hai cờ trong `be` = false sau `up`**,
  tới khi Toàn quyết bật lại (đặt đơn thử qua M8 = cửa sổ có hẹn: `lui` rồi `tat`).
- Khung chat khi tên miền đã mở: theo quyết định m34.129.

## Diễn biến
- 16/11 20:5x tạo phiếu sau lượt đọc chỉ đọc .99 (Q4b/c/d).
- 17/11 07:3x m34.118 A: commit `d1039f46f` (build-args + README mục 15), chạy bộ test khuôn trước push.
