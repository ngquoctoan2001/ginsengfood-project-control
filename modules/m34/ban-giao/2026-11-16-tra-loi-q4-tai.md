# Trả lời Q4a–Q4e (runbook buổi sếp test M4 trên .99) · 16/11/2026 20:4x

Gửi kèm tin nhắn cho Tài. Nguồn: đọc chỉ đọc trên .99 lúc 16/11 20:42 (Toàn duyệt, D-m34-092; không đọc `.env`, không in bí mật) + `chung/MAY_CHU.md`.
Câu hỏi gốc: M4-PLAN `02_PROJECT_CONTROL/04_REPORTS/M4/SEP-TEST/RUNBOOK_60.md` mục 0.

## Đang chạy trên .99
- Thư mục `/data/ginsengfood-business-platform`, project compose `m34`. `be` và `fe` chạy image `afb6d404c` (chưa có J1, chưa có bản sửa cờ `SEED_STAGING_TEST_ENABLED`).
- `COMPOSE_FILE` đang dùng: `compose.yml`, `compose.override.yml`, `compose.m8-that.yml`, `compose.m8-that.quan-tri.yml`, `compose.m5-cua.yml`.
  Hai tệp `compose.m8-gia-lap.yml` và `compose.m3-112-ui.yml` còn nằm trong thư mục nhưng KHÔNG nằm trong `COMPOSE_FILE`.

## Q4a — Tên miền đã trỏ vào .99, có khách thật chưa?
- **Chưa có tên miền nào chạy thật.** DNS `ginsengfood.vn`, `www.` đã trỏ IP công ty, nhưng nginx 443 của Anh Tuấn chưa chuyển tên nào về .99 (kiểm từ ngoài 14/11 13:00: mọi tên trả cùng một 302, `/admin` 404, chưa có chứng chỉ công khai).
- Anh Tuấn đang làm HTTPS, hạn 18/11, trùng ngày sếp test. **Buổi test dùng LAN `http://192.168.1.99`.** Ngay trước khi bật cờ test, m34 kiểm lại từ ngoài (check-host / 4G).
  Nếu lúc đó tên miền đã vào .99 thì tạm dừng bật OTP giả và gói test, báo Toàn.

## Q4b — .99 có đơn/khách thật chưa?
- Đếm lúc 20:42: 70 đơn (08/09 → 14/11), 11 đơn trong 7 ngày gần nhất, 51 khách. Đó là dữ liệu chép từ .60 lúc chuyển máy và đơn thử của Toàn/M8 (nghiệm thu M3 → M8 13–15/11).
- Chưa có cổng công khai nên chưa có khách thật. Dữ liệu `DEMO_*` và job tồn giả **dùng chung CSDL được** trong buổi test, với điều kiện cờ chỉ bật sau khi bản sửa "không nạp gói `demo-*`" (PR #162) đã vào `dev` và lên .99.

## Q4c — `OPS_CORE_ENABLED` trên .99?
- **`OPS_CORE_ENABLED=false`, `OPS_CORE_GATE_ENFORCE=false`.** M3 trên .99 chưa gọi M12. Tồn chỉ có một nguồn, không lẫn tồn WMS với tồn giả.

## Q4d — Override có đặt cờ trùng danh sách mục 2 không?
- **Có.** `compose.override.yml` dòng 30–40 ghi cứng (không đọc từ `.env`) 11 khoá: `SPRING_PROFILES_ACTIVE` (= `demo`), `SEED_ENABLED`, `SEED_CONFIGURED_ADMIN_PORTAL_ACCESS_ENABLED`,
  `SEED_SECURITY_ADMIN_ENABLED`, `SEED_DEV_CUSTOMER_ENABLED`, `SEED_CATALOG_DEMO_ENABLED`, `SEED_CATALOG_DEMO_PRODUCTS_ENABLED`, `SEED_INVENTORY_TRACE_DEV_ENABLED`,
  `APP_SEED_DEMO_ENABLED`, `APP_SEED_CONTENT_CMS_ENABLED`, `APP_SEED_SHIPPING_DEMO_ENABLED`. Giá trị đang chạy: đều `true`.
  → Sửa `.env` cho các khoá này **không có tác dụng**. Muốn đổi thì sửa override; m34 làm trong lượt deploy.
- `OTP_SMS_EXPOSE_MOCK_CODE` **đang `true`** (đặt ở `compose.m8-that.yml`, phục vụ nghiệm thu M8), `OTP_SMS_PROVIDER=MOCK`. Phải tắt trước khi tên miền chạy thật, xem Q4a.
- Cờ M4 đang chạy: `AI_RUNTIME_ENABLED=false`, `AI_RUNTIME_KILL_SWITCH=true`, `AI_ADVISOR_PRODUCTION_MODE=false`, `AI_CUSTOMER_FACING_CHAT_ENABLED=false`, `AI_ADVISOR_GATEWAY_DELIVERY_ENABLED=false`,
  `M4_CLAUDE_ENABLED=false`, các cờ Gemini `false`. Các cờ sau **chưa đặt** (dùng mặc định trong mã): `AI_ADVISOR_WEB_COMMERCE_ENABLED`, `AI_SELLABLE_ADAPTER_ENABLED`,
  `AI_CUSTOMER_CONTEXT_SOURCE_ADAPTER_ENABLED`, `AI_CUSTOMER_PURCHASE_HISTORY_ADAPTER_ENABLED`, `AI_DEV_LIMITED_RECOMMENDATION_TRUTH_ENABLED`, `AI_TPCN_ROLEPLAY_ENABLED`,
  `M4_LLM_COMPOSE_ENABLED`, `M4_LLM_PROVIDER`, `AI_RUNTIME_ENVIRONMENT`, `AI_RUNTIME_DEV_ONLY`, `SEED_STAGING_TEST_ENABLED`, `STAGING_TEST_STOCK_REFRESH_ENABLED`, `SEED_GUARD_STRICT`.
- Khung chat: `deploy/m34/build-args.60.json` dòng 13 đặt `NEXT_PUBLIC_AI_ADVISOR_WIDGET_ENABLED=false` (build-time, `test_khuon.py:55` khoá giá trị này) → muốn hiện khung chat phải build lại image `fe`. Toàn chọn bật (D-m34-094): `d1039f46f` đặt `true`, đã vào `dev` `3627ce4f0` (PR #163, 17/11 08:12); image `fe` từ CI `m34-images` trên `dev`. Tắt lại khi tên miền chạy thật.

## Q4e — Ai deploy .99 tuần này?
- **m34 (Toàn) deploy**, một lượt chiều 17/11, sau buổi gọi thử M8 (E07/E08). Toàn duyệt lúc chạy (D-m34-092). PM của Tài không chạy lệnh trên .99.
- Tài gửi cho Toàn trước trưa 17/11: (1) mã bản cuối trên `dev` (sau J1 + PR #162), (2) bảng cờ cần bật theo đợt (mục 2–3 runbook, ghi rõ khoá nào nằm trong override), (3) kịch bản kiểm sau deploy (mục 5).
- Image lấy từ CI `m34-images` trên `dev` (cần `kiem-tra-khuon` xanh). Không đưa bản M3 nào lên .99 trong lúc buổi gọi thử M8 chạy (D-lead-056).
