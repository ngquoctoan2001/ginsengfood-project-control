# Trạng thái — m34

Mốc: 18/11/2026 13:5x (+07) · **D-m34-108 (D-lead-060): chỉ Phúc ghi .99 cho repo bán hàng; phiên m34 CHỈ ĐỌC .99**
· BP `origin/dev` = `origin/toandeptrai` = local `dev` = local `toandeptrai` = `826aee599` (PR #170 tab Cước gọi 15:2x; trước đó `0d941de79` 14:0x; trước đó `a48db1dc0` 10:2x, D-m34-107, m34.132; dev thêm PR #166–#168 Tài + 14 commit Phúc đẩy thẳng 08:30–09:01, không PR)
· `origin/dev015` `405939275` · `origin/PhucApu` `b2568a319` (không đổi từ 16/11) · M4-PLAN `3ff48a75` (pull ff 18/11)
· .99 (đọc 14:08): M3/M4 image `d1039f46f` (Phúc lên 12:34, Flyway V358–V360); `be` Phúc tạo lại 13:51 → OTP giả + nối IVR TẮT (lớp công khai giữ), quan sát M12 BẬT (`OPS_CORE_ENABLED=true`, ENFORCE + giữ hàng tắt, `OPS_CORE_TOKEN_OK`) · M12 `565272e01` · M8 `0f1a9eb5` MOCK, lịch TẮT 13:49.
Sẵn sàng: **40%** (chấm 10/11, chưa chấm lại) · 30/11: ĐỎ · mốc gần: buổi sếp test M4 18–19/11, cổng NK-b 20/11.

## Trang bán hàng đã ra Internet (https://ginsengfood.vn chạy thật từ 17/11 ~16:3x qua Caddy .98)
- **XONG 18/11 08:32 (m34.128 + m34.130, D-m34-105):** OTP giả và nối M3 → M8 TẮT trên .99 bằng lớp chồng `compose.cong-khai.yml` cuối `COMPOSE_FILE`; `be` tạo lại 08:32:02, healthy sau ~31 giây, ready 200 qua nginx và qua https://ginsengfood.vn. Trước khi tắt: 0 xác nhận IVR active, 0 đơn 24 giờ. Watchdog IVR tắt theo cùng cờ; quản trị IVR giữ. Đã báo M8.
- 12:36:50–13:51 OTP giả + nối IVR mở (m34 `lui` cho khung E, Toàn "chạy"; đụng lượt lên bản của Phúc 12:34), 0 đơn; Toàn "tắt" 13:4x, Phúc tạo lại `be` 13:51 → tắt lại. Từ nay m34 chỉ đọc .99 (D-m34-108).
- Khung E (phiếu `wp/khung-e-1811.md`) DỪNG, làm lại hôm khác với Phúc chạy `lui`/`tat`. Đồng hồ M3: gọi cuối ≤ +15 phút, kết quả ≤ +17 phút; đơn lạ tự xác nhận (D-m34-106). Đã đính chính phiên lead: lớp công khai bị bỏ 12:36 do `lui` của m34, không do lượt của Phúc.

## Buổi sếp test M4 (phiếu `wp/deploy-m4-99-sep-test.md`, CHỜ)
- CI GitHub repo bán hàng vẫn KẸT Billing (tài khoản PhucApu): mọi `m34-images` từ 17/11 08:42 (`9c71e37ce`, `5b92e6618`, `103036c8b`, `88d5fe01e`) hỏng ở bước bắt đầu job → không image mới. Image GHCR mới nhất có: `3627ce4f0`.
  m34.131 A (D-m34-107): nhắc Phúc sửa Billing, tin nháp [tin](ra-soat/2026-11-18-phuc-tin-billing.md) CHƯA GỬI.
- D-m34-109 (thay chặn của D-m34-107): nhánh chú để sau; Toàn chấp nhận đưa `dev` (có V392–V395) lên .99 trước, Phúc xử lý thứ tự Flyway khi gộp chú. Kế hoạch: xong tab "Cước gọi" (`wp/ivr-cuoc-goi.md`, coder đang làm) → gộp `toandeptrai` → `dev` + push → tin để Toàn nhờ Phúc đưa `dev` mới nhất lên .99.
- Tài: chưa thấy SHA cuối + bảng cờ + kịch bản kiểm trong sổ; báo cáo đầu ngày 18/11 ghi M4-SEP-TEST-KICH-BAN-001 READY_FOR_TEST "đang để", ".99 chạy SHA nào chưa kiểm, Phúc nắm máy" (từ 13:4x đúng: Phúc nắm máy, D-m34-108).
- Khung chat FE bật trong image từ `3627ce4f0` → lên .99 là người ngoài Internet thấy (m34.129). P0 `FIX-CHAT-CHILD-GATE-LEAK-PUNCT-001` của Tài: "phải xong trước khi gắn Page khách thật".
- Lượt deploy kế tiếp gồm: giao diện IVR ui-kit-v2, nginx proxy .98 (`nginx -t` trên .99 trước), ghim mạng `m34_app` (Compose tự tạo lại mạng → cửa sổ dừng M3, chạy đủ bộ), bộ ngắt mạch theo ngăn, việc "sau HTTPS": `.env` `CORS_ALLOWED_ORIGINS` thêm https://ginsengfood.vn + www (giữ http://192.168.1.99 tới pha 4), `AUTH_COOKIE_SECURE=true`.
- Tài M3-017 (VNPAY sandbox + COD lên .99) hạn 18/11, Sheet "Chưa bắt đầu", cần lượt máy chủ.

## Nối M12 ↔ M3 trên .99
- XONG 17/11 15:2x–15:31 (D-m34-100–102): secret `SVC-M3-SELLABLE` v5, token từ be 200, 18 SP "suất"→"hộp", 19 link SKU + kho `GF-VN-HCM-01`↔`WH_FG_MAIN` (DAT).
- Còn: bật quan sát từ 20/11 (m34.124: `OPS_CORE_ENABLED/CLIENT_ID/BASE_URL` + restart be, ENFORCE + giữ hàng tắt).
- D-m34-095: M2 đổi DB sạch 29–30/11 → M3 tắt giữ hàng/ENFORCE/OPS_CORE trước giờ đổi, nạp lại link khi M2 có kho.

## NK-b (phiếu `wp/SUA-SAU-RA-SOAT-NKB.md`, tạm dừng tới khi Toàn lệnh)
- Gói 10 `sec22` (M3-164, R2, hạn 19/11) · gói 2 `kien-truc` chờ nhánh chú · gói 11 `chay-99` chờ .63 + M12 lên .99. Sáng 20/11 rà lại 20 task Cần sửa → cổng NK-b.
- Bộ ngắt mạch theo ngăn CHECK/READ `75663cf47` đã vào dev (bộ đủ 3883 ca, chỉ 6 đỏ sẵn; M3-201 Đạt). Việc sau: token cache dùng chung CHECK/READ; CONG_TON_M12 lọc bucket=CHECK.

## Nhánh chú Dũng (Phúc rà + gộp, D-m34-091; D-m9-002)
- `chudung/m3-14112026-gop-…` `3c6d3ce2e` (hơn dev 79) + `chudung/m9-…-misa` `a3458abd5` CHƯA vào dev; Phúc gộp trước 19/11 (tin m9 chưa gửi). Sau gộp: m34 kéo dev về `toandeptrai`.
- Bản rà 16/11 VÀNG: gọi lại 24 giờ cần M8 draft.47 trước; thứ tự lên máy M12 → M8 draft.47 → M3 nhánh gộp → bật cờ. D-m34-087: giữ `PT55M`.
- Migration V383–V391 của chú chặn CONV-STATE M4 (Tài) vì .99 Flyway `out-of-order=false`.

## M3 → M8 (IVR)
- Nghiệm thu 15/11: E01, E02, E03, E05, E06-A/B, E10 ĐẠT. E07/E02/E03/E08 dời; lần tới đọc lại id đơn (`_wt/m34/_tools/doc-id-don-99.sh`).
- F1/F2 + ghim draft.47 trong dev từ `3627ce4f0`, .99 còn `afb6d404c` (chưa có F1/F2: 429/403 của M8 = lỗi cuối).
- Hàng chờ (D-m8-135, hộp thư `m34-2026-11-18-m8-api-do-cuoc-draft48.md`): tab "Cước gọi" — ghim lại draft.48, proxy `call-usage` + `export` qua `IvrAdminController`. M8 chưa push → chưa ghim. Mở gói khi Toàn duyệt (m34.133).

## Phúc / Tài
- Rà Phúc 17/11 ([bản rà](ra-soat/2026-11-17-phuc.md)): 3 Đạt, 36 Cần sửa; tin nháp [tin](ra-soat/2026-11-17-phuc-tin-nhan-nhap.md) CHƯA GỬI. Phúc chưa có commit mới trên origin từ 16/11 16:33.
- Tài: PR #165–#168 tự gộp không CI (PM gộp theo OWN-379/380, kiểm cục bộ), chỉ vùng chat M4. Contracts PR #2 chưa ai review; M3-181 (Phúc) hạn 21/11.
- Chưa kiểm Sheet M3/M4 sáng 18/11 (trễ hạn, chặn).

## Máy
- `_wt/m34`: 77 thư mục (45 worktree phụ BP) cũ. `don_may -Dung` 07:52: 0 tiến trình, 0 container dừng.

## Quyết định đã áp (chi tiết `QUYET_DINH.md`)
- D-m34-001…097 như sổ cũ · 098 rà Phúc: không bảo vệ nhánh, mã email trung lập, tài khoản mẫu cố tình · 099 ghim mạng `m34_app` · 100–102 nối M12 .99, kho, "hộp" · 103–104 gộp #164 không CI · 105 tắt OTP giả + nối IVR .99 · 106 đơn lạ trong khung tự xác nhận · 107 131 A, kéo + push dev về toandeptrai, chặn deploy dev tới khi nhánh chú vào.
- Luật giữ: KHÔNG ghi .99 (D-m34-108, cần gì soạn tin cho Toàn nhắn Phúc); không push/PR/gửi tin khi Toàn chưa nói rõ từng lần; không sửa nhánh chú, không nhắn chú. M9 thuộc luồng `m9`.

## Câu hỏi mở: m34.129 (khung chat, đề xuất B) · m34.133 (mở gói tab "Cước gọi", đề xuất: sau khung tối nay, làm giao diện từ tài liệu M8, ghim khi M8 push)
