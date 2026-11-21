# Trạng thái — m34

Mốc: 20/11/2026 16:0x (+07) · **D-m34-108 (D-lead-060): chỉ Phúc ghi .99 cho repo bán hàng; phiên m34 CHỈ ĐỌC .99**
· BP `origin/dev` = `eb58c76a7` (20/11 15:44, Phúc: cổng CI trên .63 M3-206; trước đó PR #171–#177 Tài tự gộp; nhánh chú V361–V391 vào dev 19/11 07:55 `04a01d4e6`) · `origin/toandeptrai` = local = `826aee599` (chưa kéo dev mới) · `dev015` `699fd410c` (= dev) · M4-PLAN `87362e22`
· .99 (đọc 20/11 09:56): CI/CD qua GitLab PhucApu (runner LAN `m34-lan`, tự deploy theo SHA); `be`/`fe` `5b68a2162` + bản trước `efa976c61` đều KHÔNG có trên GitHub, `compose.yml` .99 ≠ dev; lớp công khai + `compose.vnpay-sandbox.yml` trong `COMPOSE_FILE`; Claude bật, khoá có nhưng **42/42 lượt HTTP 401** → chat ra câu mẫu ([rà 20/11](ra-soat/2026-11-20-m4-dev-tai.md)) · M8 `0f1a9eb5` MOCK.
Sẵn sàng: **40%** (chấm 10/11, chưa chấm lại) · 30/11: ĐỎ · mốc gần: buổi sếp test M4 18–19/11, cổng NK-b 20/11.

## Trang bán hàng đã ra Internet (https://ginsengfood.vn chạy thật từ 17/11 ~16:3x qua Caddy .98)
- **XONG 18/11 08:32 (m34.128 + m34.130, D-m34-105):** OTP giả và nối M3 → M8 TẮT trên .99 bằng lớp chồng `compose.cong-khai.yml` cuối `COMPOSE_FILE`; `be` tạo lại 08:32:02, healthy sau ~31 giây, ready 200 qua nginx và qua https://ginsengfood.vn. Trước khi tắt: 0 xác nhận IVR active, 0 đơn 24 giờ. Watchdog IVR tắt theo cùng cờ; quản trị IVR giữ. Đã báo M8.
- 12:36:50–13:51 OTP giả + nối IVR mở (m34 `lui` cho khung E, Toàn "chạy"; đụng lượt lên bản của Phúc 12:34), 0 đơn; Toàn "tắt" 13:4x, Phúc tạo lại `be` 13:51 → tắt lại. Từ nay m34 chỉ đọc .99 (D-m34-108).
- Khung E (phiếu `wp/khung-e-1811.md`) DỪNG, làm lại hôm khác với Phúc chạy `lui`/`tat`. Đồng hồ M3: gọi cuối ≤ +15 phút, kết quả ≤ +17 phút; đơn lạ tự xác nhận (D-m34-106). Đã đính chính phiên lead: lớp công khai bị bỏ 12:36 do `lui` của m34, không do lượt của Phúc.

## Luật gọi cấu hình được + hàng chờ nhân viên (phần M3; m8 làm phần M8; theo dõi chung `modules/lead/wp/theo-doi-luat-goi.md`)
- Toàn chốt 20/11 (D-m8-143…147); kế hoạch M3-01…07: [wp/luat-goi-m3.md](wp/luat-goi-m3.md), M3-01, M3-03, M3-02 XONG trong cây `_wt/m34/luat-goi` (verifier độc lập ĐẠT; patch `luat-goi-ab.patch` `68dc72dca359`, CHƯA commit/PR); M3-05 verifier độc lập CẦN SỬA (21/11 06:1x; không lỗi cao, 2 lỗi trung `recall_of_task_id` ca nhập nhằng + thu hồi lần gọi lại hết lượt gửi, 4 thấp), coder đang sửa rồi kiểm lại (patch trước sửa `luat-goi-abcd.patch` `0cd26cd60135`, V409); M3-04 XONG phần mã (verifier R3 hai vòng, lỗi cao đã sửa trên `JpaTransactionManager` thật, V408; lượt lấp cuối gộp vào kiểm tích lũy M3-07; 21/11 04:0x; patch tích lũy `luat-goi-abc.patch` `de64b4b3ff32`, 62 tệp); M3-06 XONG phần mã (verifier hai vòng, lỗi đã sửa; `luat-goi-e.patch` `2977170d14d2`, 41 tệp; V407 chỉ ghi danh mục quyền, admin phải gán theo tài khoản); mã xong trên dev 27/11, Phúc lên .99 28/11, thử đầu–cuối 28–29/11.
- Phát hiện: dev đã có hàng giữ 24 giờ + M3 tự gọi lại + nhân viên Xác nhận/Huỷ thay khách (nhánh chú) → chỉnh theo cờ `app.ivr-rules.mode`, mặc định `LEGACY_V4` = không đổi (MobiFone ~24/11 an toàn). Toàn "Có, đảo luôn" (D-m34-110): chế độ mới đảo QT-CHUNG-011/015/016, chế độ cũ giữ nguyên. Hợp đồng draft.49 m8 đã giao + chốt đủ 6 điểm (20/11); 24/11 không đẩy gì lên .99.

## Buổi sếp test M4 (phiếu `wp/deploy-m4-99-sep-test.md`, CHỜ)
- **20/11 rà M4:** khoá Claude trên .99 bị từ chối (401) chứ không do mã/compose như sổ Tài ghi; tin nháp Tài (tạo khoá mới + trần chi tiêu → Phúc thay) trong [rà 20/11](ra-soat/2026-11-20-m4-dev-tai.md), CHƯA GỬI. Tài 18–20/11 chủ yếu vá luật lọc chat (#171–#176) + M3 ship/VNPAY.
- CI GitHub repo bán hàng vẫn KẸT Billing (tài khoản PhucApu): mọi `m34-images` từ 17/11 08:42 (`9c71e37ce`, `5b92e6618`, `103036c8b`, `88d5fe01e`) hỏng ở bước bắt đầu job → không image mới. Image GHCR mới nhất có: `3627ce4f0`.
  m34.131 A (D-m34-107): tin Billing 18/11 THAY bằng tin đồng bộ GitLab ↔ GitHub (image giờ build trên GitLab) trong [rà 20/11](ra-soat/2026-11-20-m4-dev-tai.md), CHƯA GỬI.
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
- Nhánh gộp m3 của chú ĐÃ vào dev 19/11 07:55 (`04a01d4e6`, Phúc) → hết nguy cơ Flyway sai thứ tự (D-m34-107/109). `chudung/m9-…-misa` còn ngoài dev (luồng m9). Việc m34: kéo dev về `toandeptrai` (chưa làm).
- Bản rà 16/11 VÀNG: gọi lại 24 giờ cần M8 draft.47 trước; thứ tự lên máy M12 → M8 draft.47 → M3 nhánh gộp → bật cờ. D-m34-087: giữ `PT55M`.
- Migration V383–V391 của chú chặn CONV-STATE M4 (Tài) vì .99 Flyway `out-of-order=false`.

## M3 → M8 (IVR)
- Nghiệm thu 15/11: E01, E02, E03, E05, E06-A/B, E10 ĐẠT. E07/E02/E03/E08 dời; lần tới đọc lại id đơn (`_wt/m34/_tools/doc-id-don-99.sh`).
- F1/F2 + ghim draft.47/48 trong dev; .99 `5b68a2162` (19/11) đã có.
- Tab "Cước gọi" (`wp/ivr-cuoc-goi.md`, `7c3910714`, PR #170 18/11): phần M3 ĐÃ trên .99 (`IvrCallUsageCsv` có trong jar `be`, đọc 20/11 10:2x). M8 `da306952` lên .99 20/11 10:20 (API `call-usage` + `export`, draft.48, bảng gộp 0 dòng vì chưa có cuộc gọi từ 14/11). Chưa thử đầu-cuối: Toàn mở `/admin` → IVR → Báo cáo → Cước gọi, kỳ vọng bảng rỗng, không lỗi.

## Phúc / Tài
- Rà Phúc 17/11 ([bản rà](ra-soat/2026-11-17-phuc.md)): 3 Đạt, 36 Cần sửa; tin nháp [tin](ra-soat/2026-11-17-phuc-tin-nhan-nhap.md) CHƯA GỬI. Phúc chưa có commit mới trên origin từ 16/11 16:33.
- Tài: PR #165–#168 tự gộp không CI (PM gộp theo OWN-379/380, kiểm cục bộ), chỉ vùng chat M4. Contracts PR #2 chưa ai review; M3-181 (Phúc) hạn 21/11.
- Chưa kiểm Sheet M3/M4 sáng 18/11 (trễ hạn, chặn).

## Máy
- `_wt/m34`: 77 thư mục (45 worktree phụ BP) cũ. `don_may -Dung` 07:52: 0 tiến trình, 0 container dừng.

## Quyết định đã áp (chi tiết `QUYET_DINH.md`)
- D-m34-001…097 như sổ cũ · 098 rà Phúc: không bảo vệ nhánh, mã email trung lập, tài khoản mẫu cố tình · 099 ghim mạng `m34_app` · 100–102 nối M12 .99, kho, "hộp" · 103–104 gộp #164 không CI · 105 tắt OTP giả + nối IVR .99 · 106 đơn lạ trong khung tự xác nhận · 107 131 A, kéo + push dev về toandeptrai, chặn deploy dev tới khi nhánh chú vào.
- Luật giữ: KHÔNG ghi .99 (D-m34-108, cần gì soạn tin cho Toàn nhắn Phúc); không push/PR/gửi tin khi Toàn chưa nói rõ từng lần; không sửa nhánh chú, không nhắn chú. M9 thuộc luồng `m9`.

## Câu hỏi mở: m34.129 (khung chat khi tên miền đã mở — nay gắn với khoá Claude: khoá chạy là người ngoài chat với AI thật)
- **m34.135** (LEGACY_V4, chưa gấp): nhân viên huỷ đơn giữ vì lỗi kỹ thuật ở chế độ cũ vẫn tính vào khách (khách huỷ +1, cờ cam +1), huỷ 'không bắt máy' cộng đôi hai cột thống kê, khách đọc 'huỷ theo yêu cầu của khách'. Chế độ mới đã sửa. Đề xuất: giữ nguyên LEGACY (D-m34-110, MobiFone 24/11), sửa sau khi chạy luật mới; hạn: trước khi bật `M8_RULES` thật.
