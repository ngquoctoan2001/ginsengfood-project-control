# Lệnh .60 phía M3 để Toàn duyệt MỘT LƯỢT (nối M12, chế độ quan sát) — soạn 13/11

> **LỖI THỜI MỘT PHẦN (13/11 15:30):** D-lead-034/035/036 (`chung/MAY_CHU.md`): gói `~/m34` (M3 + M4 + M9) cắt sang **.99** 14/11 22:45–00:15 (phiên phụ "m34 phụ · chuyển gói ~/m34" làm), M1–M2 sang .99 13/11 22:30; `.60` chỉ còn M7 tạm + đường lui. Nội dung các cụm (kiểm chỉ đọc, bí mật qua tệp, nạp link, quan sát, webhook) vẫn đúng NHƯNG đổi máy đích sang `.99` và địa chỉ M12 thành `http://192.168.1.99:5000` (chờ bảng allowlist/nguồn mới của m12); không lập kế hoạch mới trên .60. Bản giao cho phiên chuyển máy: `BAN-GIAO-CHUYEN-99.md`.

**CẬP NHẬT 13/11 08:47:** phiên M3→M8 của Toàn đã deploy ảnh `f9e179a45` lên `.60` (B1–B4: sao lưu 4315 mục, chép compose/trien-khai.sh/nginx từ commit, `trien-khai.sh f9e179a4` rc=0, Flyway V330→V349 chạy sạch trên DB THẬT của .60, `be` 0 ERROR, ops-core TẮT, cờ thanh toán/vận chuyển tắt). Nghĩa là Cụm 0 và các bước 1, 3 của Cụm 2 ĐÃ XONG; còn lại của Cụm 2 là bước 2 (tệp bí mật + `.env` ops-core) và bước 4 (bật). V340–V349 đã áp lên DB thật, nên Cụm 1 mục 3–4 chỉ còn là kiểm sau (SELECT).

Bài học 11/11: duyệt từng lệnh làm cửa sổ cutover kéo dài 75 phút thay vì 30. Tài liệu này gom lệnh phía M3 thành các cụm, mỗi cụm có điều kiện vào, lệnh, kết quả mong đợi, điểm lùi. Phía M12 (`.61`) xem bảng "Các lệnh Toàn phải duyệt riêng" ở `C:\Projects\ginsengfood-ops-core\docs\runbooks\release\go-live-cutover-plan.md` mục cuối C-M3-7; các số # dưới đây ghi theo bảng đó.
Mọi bí mật (secret principal M3 từ NM3-11) Toàn tự nhập trên `.60`, không đi qua chat/phiên Claude. Không cụm nào bật `OPS_CORE_GATE_ENFORCE`; tất cả ở chế độ quan sát (`ENABLED=true, GATE_ENFORCE=false`: không đổi quyết định bán).

## Cụm 0 — trên máy Toàn (không đụng máy chủ), cần duyệt PUSH
- `git push origin toandeptrai` (có merge `dev` của Phúc), chờ job `m34-images` xanh (`gh run watch`), ghim SHA 40 hex. Nếu đỏ: sửa rồi push lại (không tới `.60` khi chưa xanh). Sau xanh mới đưa `dev` tiến nhanh (hoặc PR).

## Cụm 1 — kiểm chỉ đọc trên .60 (trước mọi thay đổi)  [m12 #1, #4]
1. `bash NM3-10-kiem-mang-60-61.sh` (chỉ đọc; `/health/live` 200 từ `.60` tới `.61:5000`, thử lấy token: Toàn nhập secret ẩn; ghi IP nguồn M12 thấy).
2. `bash NM3-12-doc-db-60.sh` (chỉ SELECT: 19 mã trong `sku_master_codes`, kho, link, cờ) và, sau khi m12 xuất ánh xạ, `bash NM3-12-xuat-link-60.sh` (chỉ đọc, CSV cho công cụ của m12).
3. Trước V346: `SELECT count(*) FROM product_warehouse_stocks WHERE qty_available<0 OR qty_reserved<0 OR qty_sold<0` và `SELECT count(*) FROM inventory_lots WHERE qty_in<0 OR qty_available<0` (phải 0; có dòng âm thì CHECK còn NOT VALID và dòng đó không UPDATE được).
4. Trước V347/V348: soát 19 mã canonical (`master_version`, `group_code`, `formula_code`); sau V347: `SELECT * FROM sku_unit_lock_mismatches`.
Điểm lùi: không đổi gì.

## Cụm 2 — đưa bản mới lên .60 (cần Cụm 0 xanh)  [m12 #3]
Thứ tự BẮT BUỘC (SEC-09): image `be` có SEC-09 chạy cùng lúc hoặc trước compose mới; dùng `trien-khai.sh <sha40>` (README mục 3–4, 12.1, 12.2).
1. `scp` bộ deploy mới lên `~/m34` (README mục 1–2: `compose.yml`, `trien-khai.sh`, `env.mau`, `nginx/m34.conf`, `m8-gia-lap/*`, `ops-core/*`, `canh-bao.sh`, `cong-tac-khan.sh`, `compose.khan.yml`, `crontab.mau`).
2. Tạo tệp bí mật bằng tay (Toàn): `mkdir -m 700 ~/m34/secrets; umask 077` rồi ghi secret principal M3 vào `secrets/ops_core_client_secret` (chmod 644 theo README 12.2, thư mục 700); điền `.env`: `OPS_CORE_ENABLED=true`, `OPS_CORE_GATE_ENFORCE=false`, `OPS_CORE_BASE_URL=http://<ip .61>:5000`, `OPS_CORE_ALLOW_PLAIN_HTTP=true`, `OPS_CORE_CLIENT_ID=SVC-M3-SELLABLE`; (webhook: để trống tới Cụm 5).
3. `~/m34/trien-khai.sh <sha40>` (tiền kiểm của script chặn nếu thiếu cấu hình; sha mới khác sha đang chạy, nếu không script thoát "đang chạy rồi").
4. Kiểm: `docker compose ps be` khoẻ; log `be` không có `OPS_CORE_CONFIG_INVALID`; có `OPS_CORE_CALL`; `OPS_CORE_SECRET_FROM_FILE`.
Điểm lùi: `OPS_CORE_ENABLED=false` trong `.env` rồi `trien-khai.sh <sha40-moi>` hoặc `docker compose up -d --no-build --wait` (README 12.1). Lùi về image cũ mà giữ compose mới thì mất bí mật lặng lẽ: lùi cả compose.

## Cụm 3 — nạp link SKU/kho và kiểm  [m12 #5, #6]
Điều kiện: m12 đã xuất `skus.csv` (3 cột `sku_code,ops_core_sku_id,uom_code`) + `kho.csv` (m12 SKU-M12-11); mã kho M3 chốt (`NM3-12-doc-db-60.sh` cho thấy kho M3 ghép với `WH_FG_MAIN`).
1. `scp` CSV + chạy khô: `~/m34/ops-core/nap-link.sh` (mặc định chạy khô; đọc kết quả); 2. `nap-link.sh --ap-dung` (một giao dịch, ảnh chụp trước); 3. `bash kiem-link-m3.sh` (m12, từ `.60`).
Điểm lùi: `nap-link.sh --vo-hieu-tat-ca-link` (UPDATE is_active=false, không xoá; V340 chặn DELETE) hoặc khôi phục từ ảnh chụp `nhat-ky/nap-link-*.csv`.

## Cụm 4 — quan sát 48–72 giờ  [NM3-30]
Mỗi ngày: `canh-bao.sh` (cron `*/5`), đếm `OPS_CORE_*` trong log `be`, so quyết định M3 và M12 (`/check` khớp ≥ 99%, p95 < 500 ms, 0 `UNKNOWN_BLOCKED` do lệch khung). Không bật ENFORCE trước kết luận cổng Q1 (≥ 20/11) và trước khi gỡ SKU demo (`go-sku-demo.sh`, SKU-M3-10) + gỡ lớp phủ demo.

## Cụm 5 — webhook (sau Cụm 2, cùng m12 SEC-12/13)
1. Đường vào (m12, 13/11): Production M12 BẮT BUỘC `M12_OUTBOX_WEBHOOK_URL` là https cổng 443 tên miền (không IP, không http; API không khởi động nếu sai); lúc cutover URL là đệm `https://ops.ginsengfood.vn/hooks/m3-sink` (không tới M3); bên nhận thật sẽ là URL https qua front proxy `.60` (D-lead-028), KHÔNG gọi thẳng `.60:80`. IP nguồn nginx M3 thấy CHƯA đo (hairpin container→tên miền chưa thử): đừng đoán dòng `allow 192.168.1.61`; HMAC là xác thực chính; đo ở diễn tập rồi mới đổi `allow` (Anh Tuấn/Toàn chốt đường vào).
2. Đặt `secrets/ops_core_webhook_secret` (cùng khoá M12 ký) → `trien-khai.sh`; `docker compose restart nginx` (nginx chỉ đọc conf lúc khởi động).
Điểm lùi: xoá tệp secret (receiver tự trả 503 → M12 thử lại/dead-letter, M3 vẫn kéo bằng pull).

## Không thuộc các cụm trên (khi nào Toàn muốn)
- Cron tồn một chiều `dong-bo-ton.py` (`*/5`), bật giữ hàng NK-b (`OPS_CORE_ALLOCATION_ENABLED`, cần ENFORCE + Q4), lifecycle (`APP_INVENTORY_OPSCORE_LIFECYCLE_ENABLED` với `enforce=false` một vòng trước): mỗi việc một quyết định riêng, đọc `ops-core/NOI_M12.md`.
