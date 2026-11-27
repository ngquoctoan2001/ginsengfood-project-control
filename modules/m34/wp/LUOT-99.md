# LUOT-99 — một lượt .99 của Phúc chiều 28/11 cho bản chạy thật 30/11 (chỉ COD)

Trạng thái: SẴN SÀNG (chờ Toàn gửi Phúc) · Làn: L2 Phúc lên máy, L1 m34 soạn và đọc kết quả · Mức: Nguy hiểm (cờ tiền, quyền, dữ liệu)
Quyết định gốc: D-m34-121…127 (Toàn "Ok hết đề xuất" 27/11 19:4x) · D-lead-060 (chỉ Phúc ghi .99) · Hạn: 28/11 chiều; KHÔNG trùng hai lượt M12 trên .99 (nâng M2 lên `4bb29f8df`, rồi P0–P7; mỗi lượt M3 gián đoạn 1–2 phút; m12 báo giờ khi Toàn chốt, D-m12-145)
Kế hoạch: [SAN_SANG.md](../SAN_SANG.md) · Bản tối thiểu 30/11: web xem hàng, giỏ, khách vãng lai đặt hàng OTP email, CHỈ COD; huỷ/hoàn tay; giao nội bộ + vận đơn tay; nối M3 → M8 tắt, nhân viên gọi tay; M4 thử nội bộ.

## 1. Hiện trạng .99 (K99-DOC, m34 đọc qua ssh chỉ đọc 27/11 19:46, D-m34-121)
- M3 `be`/`fe` ảnh `4e5d26aee` (lên 19:15 theo D-m34-120), healthy, khởi động lại 0; Flyway cao nhất V416 thành công, 0 dòng lỗi; log `be` 1 giờ: 0 ERROR, 203 WARN.
- Lớp compose của `be` (nhãn container): `compose.yml`, `compose.override.yml` (demo), `compose.m8-that.yml`, `compose.m8-that.quan-tri.yml`, `compose.m5-cua.yml`, `compose.cong-khai.yml`, `compose.vnpay-sandbox.yml`.
  Lớp `compose.ivr-thu.yml` KHÔNG còn: Phúc đã tự gỡ trước 19:15 (có sao lưu `.env.truoc-tat-ivr-2711`) → `APP_IVR_INTEGRATION_ENABLED=false`. D-m34-123 coi như xong.
- M8 trên .99: `ivr-api`/`ivr-worker` ảnh `75aa3a9c8` (lên 27/11 11:09), hợp đồng OpenAPI cùng hash draft.51 (`abf1d485…`) với bản M3 ghim → các màn Giọng đọc, Trần, Luật gọi gọi được M8; không cần lên lại M8.
- Cờ `be` đáng chú ý cho ngày chạy thật: `SPRING_PROFILES_ACTIVE=demo` · `SEED_ENABLED`, `SEED_SAMPLE_ENABLED`, `SEED_DEV_CUSTOMER_ENABLED`, `SEED_SECURITY_ADMIN_ENABLED`, `SEED_CATALOG_DEMO_*`, `APP_SEED_DEMO_ENABLED` = true ·
  `STAGING_TEST_STOCK_REFRESH_ENABLED=true` (tồn 19 SKU được làm mới giả) · `PAYMENT_VNPAY_ENABLED=true` (sandbox, IPN cho 19 IP) · `SHIPPING_GHN_ENABLED`, `SHIPPING_VIETTELPOST_ENABLED`, `SHIPPING_SPX_ENABLED` = true ·
  `AI_RUNTIME_ENABLED=true`, `AI_CUSTOMER_FACING_CHAT_ENABLED=true`, `M4_CLAUDE_ENABLED=true`, `AI_RUNTIME_KILL_SWITCH=false` · `OTP_PHONE_EMAIL_FALLBACK_ENABLED=true`, `OTP_SMS_EXPOSE_MOCK_CODE=false` ·
  `OPS_CORE_ENABLED=true`, `APP_INVENTORY_OPS_CORE_ALLOCATION_ENABLED=false`, `OPS_CORE_STOCK_BALANCES_ENABLED=false` · `IVR_RULES_MODE_*=LEGACY_V4`, `APP_IVR_DISPATCH_POLICY_ENABLED=false` · `AUTH_M4_CHANNEL_ADVISE_ENABLED=false`.
- Cron `canh-bao.sh` của user `ssv`: 0 dòng → chưa cài cảnh báo trên .99.
- Đơn mới từ 12:47 hôm nay: 5.

## 2. Việc Phúc làm trong lượt (theo thứ tự)
1. **VNPAY thử lại (sáng 28/11, Tài đặt đơn):** một giao dịch sandbox mới sau khi mở đủ 19 IP → IPN 200, đơn "Đã thanh toán". Ghi số đơn + giờ. (Biết chắc IPN chạy để dùng khi có VNPAY thật.)
2. **Giờ Vàng không mở cho khách 30/11 (D-m34-126):** tắt tự tạo phiên Giờ Vàng (worker Phúc làm 26/11) và huỷ/ẩn phiên đã lên lịch cho 29/11–30/11; trang chủ không hiện ô Giờ Vàng mua được.
3. **Khung chat AI ẩn hoặc chặn với khách (D-m34-127):** Tài chọn cách gọn nhất (cờ `be` hoặc cờ dựng `fe`), Phúc lên. Kiểm: mở ginsengfood.vn bằng trình duyệt ẩn danh không thấy hoặc không chat được.
4. **Cài cron cảnh báo** `canh-bao.sh` theo `deploy/m34/VAN_HANH.md`, chạy thử một lượt, dán dòng kết quả.
5. **Cấu hình cho chạy thật (Toàn chốt 27/11 19:5x, D-m34-128…130):**
   - **Tồn (D-m34-128):** GIỮ làm mới tồn thử cho 19 SKU chuẩn (`STAGING_TEST_STOCK_REFRESH_ENABLED=true`) tới khi M2 có tồn thật. Nếu gỡ demo làm mất cơ chế làm mới tồn của 19 SKU chuẩn (cron `lam-moi-ton-thu` hay job trong `be`) thì giữ lại đúng phần cho 19 SKU chuẩn; ngày chạy thật nhân viên kiểm kho tay khi gọi xác nhận đơn.
   - **Dữ liệu mẫu (D-m34-129):** theo `deploy/m34/ops-core/GO_SKU_DEMO.md`: (1) gỡ lớp `compose.override.yml` demo khỏi `COMPOSE_FILE`, đặt `SEED_ENABLED=false` (tắt seed không xoá dữ liệu đã nạp; Phúc xác nhận các gói chuẩn 19 SKU, cấu hình giao nội bộ đã nạp trước khi tắt) → (2) `--kiem` → `--ap-dung --tat-hang-ton-demo` → (3) `--kiem` lại phải ra "SẴN SÀNG", chỉ còn 19 mã chuẩn Hoạt động → (4) tài khoản mẫu (admin mẫu, khách mẫu) khoá hoặc đổi mật khẩu trên giao diện quản trị. Bỏ qua bước "bật ENFORCE" của runbook (ENFORCE vẫn tắt).
   - **Hãng vận chuyển (D-m34-130):** tắt `SHIPPING_GHN_ENABLED`, `SHIPPING_VIETTELPOST_ENABLED`, `SHIPPING_SPX_ENABLED` ở lượt tối 29/11 (mục 7), SAU khi Tài thử SPX/GHN/VTP trên .99 (T-99, 28–29/11). Ngày 30/11 chỉ giao nội bộ + nhập vận đơn tay.
6. **M2 KHÔNG đổi DB** (m12 trả 27/11 19:4x: M2 đã chạy DB sạch từ 20/11, D-m12-126/128; lượt M12 28/11 P0–P7 giữ PostgreSQL, 19 `sku_code`, đơn vị, UUID SKU/kho không đổi; secret `SVC-M3-SELLABLE` không đổi) → bỏ việc tắt `OPS_CORE` của D-m34-095.
   Lúc P6 (giờ m12 báo sau): M2 đổi khoá ký JWT, API gián đoạn 1–2 phút; M3 tự bỏ token bị từ chối 401 rồi xin lại (`OpsCoreHttpClient.java:240`, `OpsCoreTokenCache.java:137`), không cần làm gì. Sau P6: xem log `be` có lượt hỏi M2 thành công lại. Khoá ký webhook M12 → M3 mới chỉ giao khi bật webhook thật (m12 đề xuất sau 30/11).
7. **Tối 29/11 (lượt cuối trước chạy thật):** gỡ `compose.vnpay-sandbox.yml` khỏi `COMPOSE_FILE` → `PAYMENT_VNPAY_ENABLED=false` (trừ khi VNPAY gửi thông số thật trước 29/11 và Toàn duyệt riêng) · tắt ba hãng vận chuyển (mục 5, D-m34-130) · nếu bộ đủ BE/FE (BO-DU) đỏ ở vùng tiền/đăng nhập/migration thì lượt này chỉ đổi cấu hình, không đổi bản.
8. **Gửi Toàn nội dung `compose.cong-khai.yml`** (không kèm bí mật) để đưa vào git `deploy/m34` (gói LOP-PHU-GIT); tệp `compose.ivr-thu.yml` không còn dùng, xoá hay giữ tuỳ Phúc.
9. Việc mã của Phúc nếu kịp, không chặn lượt: M3-218 điểm theo hạng đổi migration sang **V417 trở lên** (V414 đã có trên dev); mã đăng nhập admin bằng email trả 404 khi email không có tài khoản, sửa về trả trung lập (D-m34-098).

Mỗi lần đổi `.env`: sao lưu `.env.truoc-<việc>-2811`, `docker compose up -d --no-build --wait`, giữ dòng `COMPOSE_FILE` hiện có trừ phần được dặn gỡ.

**Bản đưa lên trong lượt:** `dev` `74b8b5664` (có nút "Huỷ đơn" gửi lý do, M3-222, D-m34-131; còn lại giống `12cae1799`/`4e5d26aee`, không migration mới). Phúc chờ GitLab dựng ảnh cho `74b8b5664` rồi `trien-khai.sh` như thường, sao lưu trước.

## 3. Kiểm sau lượt (Phúc chạy, m34 đọc lại)
`/api/health/ready` 200 · đăng nhập quản trị · một đơn COD thử bằng khách vãng lai (OTP email) rồi huỷ tay · cờ `be` khớp mục 2 (m34 đọc lại bằng `docker inspect` lọc tên) · log `be` 10 phút 0 ERROR.

## 4. Không làm trong lượt
Không bật `M8_RULES`, chính sách điều kiện gửi đơn (D-m34-122) · không bật lại nối M3 → M8 · không bật advise M5 → M4 · không ENFORCE, không giữ hàng · không đụng M12, M8.

## Diễn biến
- 27/11 19:46 m34 đọc .99 (K99-DOC, mục 1). Kết luận: M8 .99 đã đủ tuyến; nối M3 → M8 đã tắt; cần chốt thêm m34.148–150 (tồn thử, dữ liệu mẫu, hãng vận chuyển).
- 27/11 19:4x m12 trả: KHÔNG đổi DB M2 (DB sạch từ 20/11); P6 sáng 28/11 đổi khoá JWT, M3 tự xin token lại khi 401 (đã đọc mã). Mục 6 sửa theo.
- 27/11 19:5x Toàn chốt m34.148–150 theo đề xuất (D-m34-128…130): giữ tồn thử 19 SKU, gỡ dữ liệu/SKU/tài khoản mẫu, tắt ba hãng vận chuyển tối 29/11 sau khi Tài thử. Mục 5 và 7 sửa theo.
- 27/11 19:5x m12 bổ sung (D-m12-145): webhook M12 → M3 thật dời sau 30/11 (không giao khoá ký); M2 lên `4bb29f8df` ở một lượt riêng trước P0–P7; tránh lên BP .99 trùng giờ. Phát hiện thêm: nút "Từ chối IVR" gửi thiếu lý do → m34.151 (HUY-TAY-FE), nếu duyệt thì Phúc lên bản có bản sửa trong lượt này.
- 27/11 20:08 m12 nâng M2 trên .99 lên `4bb29f8df` (Development, ~19 giây, giữ DB); M3 gọi kiểm bán được 13 lần đều 200. Còn lượt P0–P7 (đổi khoá JWT) m12 báo giờ riêng — LUOT-99 tránh trùng.
- 27/11 20:2x m34 đẩy `dev` = `74b8b5664` (nút huỷ đơn gửi lý do). Lượt chiều 28/11 lên bản này.
