# Sẵn sàng — m34 (M3 bán hàng, M3 vận chuyển + thanh toán, M4 AI tư vấn, M3 → M8)

Mốc: 27/11 19:4x · % sẵn sàng: **47** (trung bình trọng số; 10/11: 40) · Kịp chạy thật 30/11: **ĐỎ** cho đủ phạm vi, **VÀNG** cho bản tối thiểu (COD, M8 MOCK hoặc tắt, M4 pilot nội bộ):
chưa có hạng mục nào lên 75; huỷ đơn và hoàn tiền chưa có mã; VNPAY thật chưa có thông số; IPN VNPAY sau khi mở thêm IP chưa thử lại; phiếu nghiệm thu chưa ai chạy, còn viết cho .60.

Ref: `gitlab/dev` = `gitlab/toandeptrai` = `origin/dev` = `12cae1799` (migration cao nhất V416, số kế tiếp V417) · `gitlab/dev015` `f1d7c206d` (chỉ hơn dev 1 commit tài liệu) · `gitlab/PhucApu` `662642874` (đã trong dev) ·
.99 chạy `4e5d26aee` (mã ≡ `12cae1799`, lên 19:15 theo D-m34-120) với lớp `compose.cong-khai.yml` + lớp `compose.ivr-thu.yml` Phúc thêm 12:47 (bật nối M3 → M8 cho M8 thử một đơn nội bộ; còn bật sau 19:15 không: CHƯA KIỂM) · M4-PLAN `ebe9da565`.
Nguồn: 3 scout + 1 auditor 27/11 19:3x, chỉ đọc, không chạy test, không ssh; số test tự khai chưa ai chạy lại không dùng để nâng bậc. Hạn: 30/11 chạy thật (D-lead-025). Lên .99 chỉ Phúc (D-lead-060); kiểm hai mức Thường/Nguy hiểm (D-lead-064).

## Hạng mục lõi (tổng trọng số 100)

| # | Hạng mục (người ngoài hiểu được) | Người | Trọng số | Bậc 10/11 → 27/11 | Bằng chứng | Còn thiếu tới 75 / 90 |
|---|---|---|---|---|---|---|
| 1 | Cửa hàng web: xem sản phẩm, giỏ, đăng nhập khách, OTP | Phúc | 15 | 40 → 50 | Phúc tự mua qua Chrome trên .99: COD đơn 598 (26/11), VNPAY sandbox đơn 600 PAID, IPN 200 (27/11) (`docs/weekly-tracking/truong-cong-phuc.md:16126,16269`); OTP qua email dự phòng (`application.yml:548` mặc định tắt, .99 bật); Google tắt (`:664`) | 75: đăng nhập tài khoản khách, OTP SMS thật (chưa có brandname), tra cứu đơn chưa chạy trên .99; Basa không bán được (giá vốn). 90: phiếu nghiệm thu cho .99 |
| 2 | Đặt hàng lõi: tạo đơn, vòng đời, huỷ, hết hạn | Phúc | 10 | 40 → 40 | tạo đơn chạy trên .99 (598, 600); 0 commit huỷ/hoàn/hết hạn từ 17/11; khách không có đường huỷ (`CustomerOrderController.java:59,85` chỉ GET); `ORDER.CANCEL` chưa gán vai (`V252:137-138`); job hết hạn tắt (`application.yml:399`); TODO phát ORDER_CANCELLED (`OrderStateMachineImpl.java:509`) | 75: M3-110 (huỷ khi chưa có vận đơn, quản trị huỷ có lý do, hoàn tay, quyền bằng migration V417+, bật job) rồi thử trên .99. Vùng Nguy hiểm (tiền). Quy tắc đã chốt 10/11 (m34.68 A) nhưng Phúc ghi "chưa chốt" |
| 3 | Khách hàng, khuyến mãi, hạng thành viên, cộng tác viên | Phúc | 10 | 35 → 40 | `95be0ac29` (Hội viên, hạng chia tab); 24/7 + ngày lễ ~13 commit, Real E2E chạy máy Phúc; M3-218 điểm theo hạng chưa commit và dùng V414 (trùng `V414__m3_ivr_dispatch_rules` trên dev) | 75: khách mới/Silver/Gold mua qua giao diện trên .99 (M3-109, trễ từ 23/11). Hoa hồng/chi trả CTV thuộc luồng m9 |
| 4 | Quản trị M3 + quản trị hệ thống (tài khoản, vai, quyền) | Phúc | 10 | 30 → 40 | 11 commit IAM (tài khoản bằng tên đăng nhập, đặt lại mật khẩu, khoá/mở, nhật ký đăng nhập `6b9d4db92`); rà 17/11: XII 0/16 Đạt, IAM 2/10 (`ra-soat/2026-11-17-phuc.md:31-32`); mã đăng nhập admin bằng email còn 404 khi email không có tài khoản (`AdminEmailCodeLoginServiceImpl.java:241-247`), trái D-m34-098 | 75: người thật tạo tài khoản, gán vai, khoá trên .99, có ghi; 20 task XII trễ (M3-053/058/059 chưa bắt đầu). 90: cổng Nguy hiểm (đăng nhập, phân quyền) |
| 5 | Thanh toán: COD, VNPAY, SePay, đối soát | Tài | 15 | 40 → 50 | COD đặt tay trên .99 (576–580 ngày 14/11; 598 ngày 26/11); VNPAY sandbox qua lớp `compose.vnpay-sandbox.yml`, đơn 600 PAID; 599 và 602 kẹt vì IPN từ dải IP thứ hai bị 403, Phúc đã mở đủ 19 IP, chưa có giao dịch thử lại; B1 link cũ huỷ đơn đã sửa (`1169c79ad`, `f52ff964e` trong dev); `compose.yml:219-223` ghi cứng tắt mock/VNPAY/SePay/QR | 75: một giao dịch sandbox mới tới "Đã thanh toán" qua IPN sau khi mở IP; đối soát treo M3-019 chưa có commit. Thật: thông số VNPAY (hạn 28/11) + `kiem-vnpay.sh` đang chặn URL ngoài sandbox + cổng Nguy hiểm (tiền) |
| 6 | Vận chuyển: phí nội bộ, vận đơn tay, GHN, Viettel Post, SPX | Tài | 10 | 40 → 50 | Tài báo phí trên .99 qua Chrome 26/11: GHN 38.500đ, VTP 41.880đ (`M4-PLAN/.../TEST_CHROME_2026-11-26/BAO_CAO.md`); SPX `80257c1b5` có trong bản .99, chưa thử; 26/11 22:34 báo phí sandbox lỗi làm `/orders/preview` 409 (`truong-cong-phuc.md:16175`); cân/kích thước giả định 200 g (`compose.yml:210`, `application.yml:807`) | 75: SPX + vận đơn sandbox + webhook ký thử trên .99; vận đơn tay qua quản trị. Khách thật: báo giá GHN (quá hạn 21/11), cân 18/19 SKU (quá hạn), hợp đồng SPX (sau 30/11) |
| 7 | Gọi xác nhận đơn tự động M3 → M8 | Toàn | 15 | 50 → 50 | E01, E02, E03, E05, E06-A/B, E10 ĐẠT trên .99 ngày 14/11 bằng đơn script (`nhat-ky/2026-11-14.md:15,22,25,35`); quản trị IVR 12 màn lên .99 27/11 19:15 (`/admin/ivr*` 200); Cước gọi lên .99 20/11 chưa thử; luật gọi M3-02…07 + điều kiện gửi đơn M3-023 (V414–V416) trên dev, cờ `LEGACY_V4` (`application.yml:610-616`), chính sách tắt (`compose.yml:235`); hash hợp đồng draft.51 khớp M8 `main` `169a6859` | 75: M8 trên .99 lên bản có 32 tuyến (sổ m8: .99 còn `f8e29b46` 21/11, CHƯA KIỂM) → màn Giọng đọc/Trần/Luật gọi mới gọi được; gán quyền IVR cho vai (V407, V411); một đơn người thật đặt qua web đi qua M8 MOCK, có ghi. 90: phiếu + lô gọi nhà mạng thật (WP11, chặn ở X-01/X-07, .64 bảo trì 28/11 22:30) |
| 8 | AI tư vấn M4: M5 gọi M4, chat web, an toàn sức khoẻ | Tài | 10 | 40 → 50 | chat web công khai chạy trên .99: m34 thử 9 câu 25/11, lỗi 4 (`ra-soat/2026-11-25-test-chat-m4-ginsengfood-vn.md`), Tài thử 26/11 11 lỗi (3 P1); P0 lọt chữ trẻ em `021e92a62` + MR !182, !183 trong bản .99, chưa thử lại; khoá Claude 401 ngày 20/11, CHƯA KIỂM lại; M5 → M4: advise trả 403 tới khi bật cờ + token, token bên .98 rỗng, pilot FB 27/11 để AI tự trả lời tắt | 75: một lượt M5 → M4 thật có ghi; chat web thử lại sau 19:15. 90 + khách thật: người duyệt an toàn sức khoẻ, Chú duyệt câu công dụng, pháp chế (OWN-435 chặn tới 05/12), M4-007/009 chưa bắt đầu |
| 9 | Phiên Giờ Vàng phía M3 + nối kho M12 | Phúc | 5 | 35 → 40 | mô hình "bỏ giữ chỗ" V410/V412 (có `DELETE`, `DROP COLUMN`)/V413, lên .99 26/11 20:28 có dump; M12 quan sát từ 18/11, 19 SKU tồn 0 (`modules/m12/TRANG_THAI.md:14`); ENFORCE tắt; Giờ Vàng cấm COD (`CheckoutValidationServiceImpl.java:70`); ENFORCE bật thì checkout Giờ Vàng bị từ chối (`GoldenHourCheckoutServiceImpl.java:145-146`, NK-c chưa làm) | 75: có tồn thật ở M12 + một phiên Giờ Vàng mua bằng VNPAY sandbox trên .99. Bán thật cần VNPAY thật. M3 → M7 dời sau 30/11 (`modules/lead/SAN_SANG.md:23`) |

Tính: (15·50 + 10·40 + 10·40 + 10·40 + 15·50 + 10·50 + 15·50 + 10·50 + 5·40) / 100 = 46,5 ≈ **47**. Trọng số giữ từ 03/11. Hạng mục 1, 5, 6, 8 có phần con đã chạy trên .99 kiểu người dùng (75) nhưng phần yếu nhất giữ cả hạng mục ở 50.

**Hạng mục mở rộng (không tính %, không chặn 30/11):** M3 → M7 Giờ Vàng, M3 → M6 `ORDER_VERIFIED` (chưa có hợp đồng, chưa phát) · GHN/VTP/SPX cho khách thật · OTP SMS brandname, đăng nhập Google · chat web công khai cho khách thật · 2FA nhân viên (D-m34-010) · VAT/hoá đơn · M9 (luồng `m9`).

## Cổng G1–G8 (`chung/CONG_PRODUCTION.md` §3)

| Cổng | Kết quả | Thiếu gì |
|---|---|---|
| G1 Chức năng lõi | chưa | cao nhất 50; huỷ đơn 0 mã |
| G2 Liên module | chưa | M2 ↔ M3: hỏi tồn 19/19 HTTP 200, tồn 0, S01–S18 NOT_RUN, NK-b NO-GO tạm; M2 KHÔNG đổi DB (m12 trả 27/11: DB sạch từ 20/11, D-m12-126/128; P6 sáng 28/11 đổi khoá JWT, M3 tự xin token lại khi 401 `OpsCoreHttpClient.java:240`) · M3 ↔ M8: hash draft.51 khớp, mới chạy luồng cũ giả lập 14/11; `dial_evidence` M8 chưa có (`hop-thu/m8-2026-11-27-m3-dial-evidence.md`) · M5 → M4: hợp đồng ở `module5/docs/05-reference/m4-channel-advise-contract.md`, gọi thật NOT_RUN · M3 → M6, M3 ↔ M7: không có hợp đồng · `ginsengfood-contracts` local còn dở merge (phiên `lead`) |
| G3 Bảo mật | chưa | có: nginx 4 vùng giới hạn (`deploy/m34/nginx/m34.conf:92-95,188-191`), OTP giả tắt, webhook hãng có xác thực. Thiếu: ~38 đường `permitAll` (`SecurityConfig.java:365-403`), consultation-leads/public/leads/shipping-fee chưa giới hạn; mã email admin 404; cổng Nguy hiểm đăng nhập/phân quyền chưa chạy. Tài khoản mẫu: Lead đã chấp nhận (D-m34-098) |
| G4 Dữ liệu | chưa | có: V416, 0 trùng; Flyway từ rỗng + nâng cấp trên PG cô lập; `trien-khai.sh` tự dump (27/11 `truoc-trien-khai-20261127T121501Z-4e5d26ae.dump`); thử khôi phục bản sao .99 ngày 14/11 0 lỗi. Thiếu: migration xoá dữ liệu V412 vào dev qua commit `wip` không ai rà; V414 của Phúc trùng số |
| G5 Triển khai | gần đạt | image GitLab → `trien-khai.sh <sha>` có đường lùi; `USER app`; `/api/health/ready`. Thiếu: lớp `compose.cong-khai.yml` (và `compose.ivr-thu.yml`) nằm ngoài git, dựng lại máy là mất; cổng 8080/3000 và `/api/health` lệch `MODULE_DEPLOY_CONTRACT.md` chưa ghi ngoại lệ |
| G6 Vận hành | chưa | có: `[rid=…]` trong log (`application.yml:902-906`), `canh-bao.sh` 7 kiểm, `deploy/m34/VAN_HANH.md` (`6ef071e09`). Thiếu: `cong-tac-khan.sh` chỉ phủ vnpay/ghn/vtp/spx (IVR, AI tắt bằng cờ/lớp phủ); cron cảnh báo trên .99 CHƯA KIỂM; chưa diễn tập tắt khẩn |
| G7 Kiểm thử | chưa | `.gitlab-ci.yml` có đủ job nhưng các lượt lên .99 21, 26, 27/11 đi đường khẩn, test không chạy; bộ đủ BE chưa xanh từ 13–14/11 (47 lỗi theo báo cáo tuần Phúc); M3-108 chưa bắt đầu; phiếu `nghiem-thu/M34-NT.md` 0 ô kết quả, còn viết cho .60; chưa thử tải cửa hàng/đặt hàng/chat |
| G8 Ngoài code | chưa | bảng dưới; `modules/lead/VIEC_NGOAI.md` cũ từ 02/11 (phiên `lead`) |

## Gói việc tới 30/11

Làn: **L1** Toàn qua phiên m34 (code M3 → M8, tài liệu, chuẩn bị yêu cầu cho Phúc; không ghi .99) · **L2** Phúc (mã M3, lên .99) · **L3** Tài (thanh toán, vận chuyển, M4).
Phiếu cũ còn mở (`luat-goi-m3`, `GOI-LENH-NOI-M8-THAT`, `ivr-menu-kit-2711`, `ivr-cuoc-goi`, `ivr-admin-99`, `khung-e-1811`, `M34-VH-OPS`, `M34-VH-LOG`, `chuyen-may-99`, `M3-181-phia-toan-99`, `deploy-m4-99-sep-test`, `M3M8-WP0910`, `NM3-12b`, `NM3-17`, `SUA-SAU-RA-SOAT-NKB`, `kien-truc`, `cau-hinh`) và WP 10/11 (WP09-DONG, UI-DONG, WP10-TAI, M3M8-WMS, M34-RS2, M34-LIEN, P-XII-SUA, P-CTV): đóng, gộp vào gói dưới hoặc dời sau 30/11 trong NT-99.

| WP | Mục tiêu → tiêu chí đạt | Làn | Mức | Tệp nóng | Phụ thuộc | Hạn | Ước | Trạng thái |
|---|---|---|---|---|---|---|---|---|
| K99-DOC | (D-m34-121, XONG 27/11 19:46: M8 .99 = `75aa3a9c8` đủ tuyến draft.51; nối M3 → M8 đã tắt; cờ chạy thật đã chốt D-m34-128…130; cron cảnh báo chưa cài — chi tiết `wp/LUOT-99.md` §1) đọc hiện trạng .99 (chỉ đọc): bản M8 đang chạy (có 32 tuyến không), `COMPOSE_FILE` có những lớp nào (`cong-khai`, `ivr-thu`, `vnpay-sandbox`), Flyway V416 thành công, cờ IVR/OTP/VNPAY qua `docker inspect` lọc đúng tên biến (không in giá trị bí mật), log be 1 giờ → bảng hiện trạng trong phiếu | L1 | Thường | — | D-m34-121 đã duyệt | 27/11 tối | 0,5 giờ | XONG |
| LUOT-99 | MỘT lượt .99 của Phúc chiều 28/11, theo tệp yêu cầu m34 soạn: (a) ~~M8 lên bản 32 tuyến~~ không cần: .99 đã chạy M8 `75aa3a9c8` (K99-DOC); (b) thử lại IPN VNPAY sandbox 1 giao dịch tới "Đã thanh toán"; (c) gán quyền IVR cho vai quản trị; (d) gỡ lớp `ivr-thu` sau khi M8 thử xong (D-m34-123); (g) gỡ lớp `vnpay-sandbox` trước 30/11, không mở phiên Giờ Vàng cho khách (D-m34-126); (h) ẩn/chặn khung chat công khai (D-m34-127); (i) giữ tồn thử 19 SKU, gỡ dữ liệu/SKU/tài khoản mẫu (D-m34-128/129); tối 29/11 tắt GHN/VTP/SPX sau khi Tài thử (D-m34-130); (e) kiểm khoá Claude; (f) sửa mã email admin 404 (D-m34-098) nếu Phúc kịp → bài kiểm nhanh sau lượt (`/health`, đăng nhập, 1 đơn MOCK) | L2 (+ L1 soạn) | Nguy hiểm (tiền, quyền) | `.env`, lớp phủ trên .99 | K99-DOC; M12 P1–P7 sáng 28/11 xong trước (không chồng cửa sổ) | 28/11 | Phúc 2 giờ, m34 1 giờ | CHỜ |
| BO-DU | bộ đủ BE (`ci-unit` + Postgres) + FE (`vitest`, `build`) MỘT lần trên `12cae1799` dưới khoá `@bo-kiem-du` → bảng đỏ quy về người/tệp, so danh sách đỏ sẵn; đỏ ở vùng Nguy hiểm (tiền, đăng nhập, migration) báo chủ trong ngày | L1 | — | khoá `@bo-kiem-du` | D-m34-124 | 27/11 tối → 28/11 | ~4 giờ máy | ĐANG LÀM |
| NT-99 | viết lại phiếu nghiệm thu cho .99 (khách vãng lai OTP email → COD; VNPAY sandbox; khách Silver/Gold; quản trị đơn + vận đơn tay; M8 MOCK hoặc tắt theo m34.143; quản trị IVR + Cước gọi; chat M4 có người canh) + đóng/dời phiếu cũ + sửa sổ lệch → Toàn (và Phúc) chạy 29/11, mỗi ô có kết quả; phần đạt lên 90 | L1 viết, Toàn chạy | Thường | `nghiem-thu/` | LUOT-99 | viết 27/11, chạy 29/11 sáng | chạy 2–3 giờ | VIẾT XONG 27/11 ([phiếu](nghiem-thu/NT-99.md)); chờ chạy 29/11 |
| HUY-TAY-FE | nút "Từ chối IVR" ở trang đơn quản trị gửi lệnh huỷ KHÔNG kèm lý do (`front-end/src/features/order/api.ts:532-548` gửi không body) trong khi máy chủ bắt buộc `reasonCode` (`OrderTransitionController.java:86-103`) → nhân viên không huỷ được đơn bằng tay. Sửa: hộp chọn lý do từ `GET /api/v1/admin/order-cancellation-reasons?context=STAFF_MANUAL` + ghi chú khi bắt buộc, gửi `{reasonCode, note}`; vitest; NT-99 bước C3 đạt | L1 (vùng Phúc, báo Phúc trước) | Thường (chỉ giao diện) | `features/order/api.ts`, `hooks/useAdminOrders.ts`, `admin/components/AdminOrderOperationsPage.tsx` | D-m34-131 | 27/11 tối → "đồng bộ dev" → Phúc lên trong LUOT-99 | 2–3 giờ | XONG mã `ab106e2d9` (Sheet M3-222), đã vào GitLab `dev` `74b8b5664` 20:2x; vitest 27/27, tsc/eslint 0 lỗi; CHƯA CHẠY trên .99 (NT-99 C3) |
| LOP-PHU-GIT | đưa `compose.cong-khai.yml` (+ mẫu `compose.ivr-thu.yml`) vào `deploy/m34` trên `toandeptrai` + test khuôn + README; nội dung lấy từ Phúc | L1 | Thường | `deploy/m34/compose.*.yml`, `deploy/m34/tests/` | Phúc gửi tệp | 29/11 | 2 giờ | CHỜ |
| CONG-NH-IVR | cổng Nguy hiểm (1 verifier, ≤ 2 giờ) cho luật gọi M3-04/05, điều kiện gửi đơn M3-023, giọng đọc/trần G-08/09 — CHỈ khi bật `M8_RULES` hoặc chính sách gửi đơn trước 30/11 | L1 | Nguy hiểm | — (đọc) | D-m34-122: không bật trước 30/11 | khi định bật | 2 giờ | DỜI |
| HUY-DON | M3-110 bản tối thiểu: quản trị huỷ có lý do + ghi hoàn tay + quyền V417 → thử trên .99, cổng Nguy hiểm | L2 | Nguy hiểm | `OrderStateMachineImpl`, migration V417 | D-m34-125 | sau 30/11 | 2–3 ngày | DỜI |
| T-99 | Tài thử trên .99 sau LUOT-99: SPX báo phí, một vận đơn sandbox, chat web lại 9 câu 25/11 + 4 bản vá mới → ghi kết quả | L3 | Thường | — | LUOT-99 | 29/11 | 0,5 ngày | CHỜ |
| T-VNPAY-THAT | M3-018/019: thông số VNPAY thật + IP, lớp phủ riêng, đối soát treo | L3 | Nguy hiểm | `order/` VNPAY, lớp phủ | VNPAY gửi thông số trước 29/11 (D-m34-126) | chỉ khi có thông số trước 29/11 | 1–2 ngày | CHẶN (VNPAY) |
| M2-DOI-DB | hỏi m12 còn đổi DB M2 29–30/11 không | L1 | Thường | — | m12 trả lời | 28/11 | 0,5 giờ | XONG 27/11 19:4x: KHÔNG đổi DB; bỏ việc tắt `OPS_CORE` của D-m34-095 |

**Kiểm chéo:**
- Mọi hạng mục lõi dưới 90 có gói hoặc lý do: 1 (NT-99; OTP SMS thật là việc ngoài code) · 2 (HUY-DON dời; huỷ tay cần HUY-TAY-FE; tạo đơn trong NT-99) · 3 (NT-99 khách Silver/Gold; M3-022 dời) · 4 (LUOT-99 mục f; 20 task XII dời sau 30/11, không kịp) · 5 (LUOT-99 b, NT-99, T-VNPAY-THAT) · 6 (T-99, NT-99) · 7 (K99-DOC, LUOT-99 a/c/d, NT-99, CONG-NH-IVR) · 8 (T-99; khách thật dời theo D-m34-127) · 9 (phụ thuộc tồn M12 + VNPAY: không lên 75 trước 30/11, ghi lý do).
- Tệp nóng không chồng: LOP-PHU-GIT là gói duy nhất ghi `deploy/m34`; BO-DU chỉ đọc mã, giữ `@bo-kiem-du`; NT-99 chỉ ghi Project Control; LUOT-99 chỉ ghi .99 (Phúc).
- Ước lượng so với thời gian còn (27/11 tối → 30/11): L1 khoảng 1,5 ngày-AI trong 2,5 ngày, được. L2 cần 1 lượt .99 + sửa nhỏ; 20 task XII, M3-108/109/110 không vào được, Phúc đang là nút cổ chai (91 task mở, 28 trễ). L3: thử trên .99 được; VNPAY thật phụ thuộc đối tác.

## Đường găng tới 30/11

1. **27/11 tối:** Toàn trả m34.141–147 = theo đề xuất (D-m34-121…127). K99-DOC, bắt đầu BO-DU, hỏi m12, soạn yêu cầu LUOT-99.
2. **28/11 sáng:** M12 P1–P7 (Phúc, phiên m12) · BO-DU chạy ở máy · M2-DOI-DB hỏi m12 · m34 soạn tệp yêu cầu LUOT-99.
3. **28/11 chiều:** Phúc LUOT-99 theo [phiếu](wp/LUOT-99.md) → bài kiểm nhanh (M8 .99 đã đủ tuyến, không cần lên lại). 22:30 .64 bảo trì (phiên m8).
4. **29/11 sáng:** Toàn + Phúc chạy NT-99 trên .99; Tài T-99. **Chiều:** sửa lỗi chặn; lượt .99 cuối của Phúc (nếu cần) sau bộ đủ không đỏ ở vùng Nguy hiểm.
5. **30/11:** chạy thật chỉ COD (D-m34-126); Toàn trực; công tắc tắt khẩn theo `VAN_HANH.md`.

## Việc ngoài code (phiên `lead` gom về `modules/lead/VIEC_NGOAI.md`, đang cũ từ 02/11)

| Việc | Ai gỡ | Cần trước | Trạng thái 27/11 |
|---|---|---|---|
| Thông số VNPAY thật + IP | VNPAY; Tài theo dõi | 28/11 | mở; M3-018 chưa có commit |
| Báo giá GHN | chị Lan; Tài | 21/11 | quá hạn; M3-020 bị chặn |
| Cân + kích thước 18/19 SKU | xưởng; Tài | 21/11 | quá hạn; phí ship theo hộp giả định |
| Hợp đồng SPX + tệp địa chỉ | chị Lan; Tài | sau 30/11 | không chặn 30/11 |
| Người duyệt an toàn sức khoẻ M4, Chú duyệt câu công dụng, pháp chế | Toàn, Chú | 13/11 | quá hạn; chặn M4 cho khách thật |
| Khoá Claude chạy được trên .99 | Tài → Phúc | 29/11 | 401 ngày 20/11; CHƯA KIỂM lại |
| Brandname SMS cho OTP | Toàn | trước khi bán thật | chưa có; đang dùng OTP email |
| M2 báo giờ đổi DB | m12 | 28/11 | XONG: không đổi DB; chỉ báo giờ P6 (gián đoạn 1–2 phút) |
| Gọi nhà mạng thật (MobiFone thử, số nội bộ) | Toàn, phiên m8 | 28/11 | X-01/X-07 chờ |

## Không kịp 30/11 + bản tối thiểu chạy được 30/11

**Không kịp 30/11 (dời, D-m34-125/126/127):** huỷ đơn + hoàn tiền M3-110 (0 mã, vùng tiền) · 20 task XII + M3-053/058/059 · VNPAY thật + đối soát (chờ VNPAY) · GHN/VTP/SPX cho khách thật (báo giá, cân SKU, hợp đồng) ·
Giờ Vàng bán thật (cần VNPAY thật + tồn M12) · M4 cho khách thật (người duyệt sức khoẻ, pháp chế) · M3 → M7, M3 → M6 · gọi nhà mạng thật lô 10 → 50 (WP11) · OTP SMS brandname · thử tải.

**Bản tối thiểu 30/11** (D-m34-122…127, Toàn duyệt 27/11 19:4x):
- Web ginsengfood.vn: xem sản phẩm, giỏ, khách vãng lai đặt hàng với OTP email, **chỉ COD**; VNPAY tắt (gỡ lớp sandbox); Giờ Vàng không mở phiên cho khách.
- Huỷ đơn: nhân viên huỷ tay bằng nút "Từ chối IVR" (cần HUY-TAY-FE vì nút đang gửi thiếu lý do), không có nút cho khách.
- Vận chuyển: phí nội bộ + vận đơn nhập tay; GHN/VTP/SPX tắt ở trang thanh toán (D-m34-130).
- Hàng: 19 SKU chuẩn, tồn thử làm mới, nhân viên kiểm kho khi gọi xác nhận (D-m34-128); không còn SKU/dữ liệu/tài khoản mẫu (D-m34-129).
- Gọi xác nhận: nối M3 → M8 tắt (gỡ lớp `ivr-thu`, D-m34-123), nhân viên gọi tay; quản trị IVR, Cước gọi xem được.
- M4: pilot nội bộ có người canh, không gắn Page khách thật, không bật advise cho khách; khung chat công khai ẩn hoặc chặn cho khách (D-m34-127).
- Điều kiện: LUOT-99 xong 28/11 · NT-99 chạy 29/11 không lỗi chặn · bộ đủ không đỏ ở vùng tiền/đăng nhập/migration · công tắc tắt khẩn đã thử một lần.
