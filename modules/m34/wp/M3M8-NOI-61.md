# M3M8-NOI-61 — M3 .60 nối M8 thật .61 (MOCK) cho UAT 14/11 · Sheet M3-023 (+ task con)

Giao: Toàn, 12/11/2026 (hộp thư M8 `hop-thu/m34-2026-11-10-noi-m8-that-61.md`). Ưu tiên cao hơn mọi việc M12↔M3 tới 14/11.
Gọi MOCK, KHÔNG gọi số thật, `REAL_CUSTOMER_CALL_ALLOWED=NO`, cờ production tắt.

Tài liệu nguồn (chỉ đọc), repo `C:\Projects\ginsengfood-ivr`:
`deploy/m8/noi-m3/viec-m34.md` (việc phía M3, có tệp:dòng) · `deploy/m8/noi-m3/luot-thu.md` (thứ tự lượt thử) ·
`deploy/m8/nghiem-thu-m3/phieu-e01-e10.md` + `README.md` (ca E01–E10). Mẫu chạy được trong lab: `deploy/m34/compose.m8-gia-lap.yml`
(`m8-cb`, `m8-cb-nginx`, `m8-be-ivr`, `m8-bi-mat`) và `deploy/m34/m8-gia-lap/tao-bi-mat.sh`.

## Luật chung (mọi phần)
- Mã chỉ trên nhánh `toandeptrai`. Làm trong bản sao tách rời (detached worktree @ `44ac63978`), KHÔNG sửa checkout chính
  `C:\Projects\ginsengfood-business-platform`, KHÔNG commit, KHÔNG push, KHÔNG ssh/scp, KHÔNG chạm .60/.61, KHÔNG gọi mạng ngoài.
  Kết quả = một tệp patch (`git add -N` rồi `git diff`, gồm tệp mới) + báo cáo. Phiên chính commit.
- Không in, không chép bí mật (mọi `.env*`, khoá, token, secret). Bí mật chỉ đi bằng tệp chmod 600. Test chỉ dùng giá trị giả sinh tại chỗ.
- Không ghim `.60`/`.61` cứng trong mã mới: tham số từ `.env`/biến môi trường; mặc định `192.168.1.60`/`192.168.1.61` được, kèm guard chặt
  (sai dạng thì dừng, không đoán).
- Test lọc đúng vùng đổi (`-Dtest=…`), bộ đủ một lần cuối nếu cần. Chỉ một Maven tại một thời điểm; máy nặng: không chạy song song nhiều bộ.
  Python test: `python` (không `python3`), `sys.stdout.reconfigure(encoding="utf-8")`. Viết tệp bằng công cụ Write, không heredoc cho tệp có `\`.
- Trung thực: chưa chạy thì ghi `CHƯA CHẠY`. Không ghi giờ ước lượng; cần giờ thì chạy `date`.
- Việc nằm ngoài phiếu thấy trên đường (lỗi có sẵn…) thì báo, không sửa lan.

## A. `delivery_area_short` (CHẶN lượt thử) — gói A, vùng Java `back-end`
Hiện `OrderIvrCheckoutBridge.java:102` gửi tên tỉnh trơn → M8 (kịch bản v6) trả 422 `IVR_PII_POLICY_VIOLATION`. Cần gửi
`<đơn vị> <tên phường/xã>, <đơn vị> <tên tỉnh>`: đơn vị viết thường (`phường|xã|đặc khu`, `tỉnh|thành phố`), tên giữ như danh mục (có dấu, hoa đầu chữ),
Unicode NFC, đúng một dấu phẩy + một khoảng trắng, chỉ hai cấp. Ví dụ: `phường Cửa Nam, thành phố Hà Nội` · `phường Hải Châu, thành phố Đà Nẵng` ·
`phường Long Châu, tỉnh Vĩnh Long`. Luật hình dạng M8 (`AreaShape`, không phân biệt hoa thường nhưng mã clip phân biệt):
`^(?:phường|xã|đặc khu) [\p{L}\p{M}\p{Nd} '’-]+, (?:tỉnh|thành phố) [\p{L}\p{M} -]+$`.

Dữ kiện đã đọc (kiểm lại trước khi dựa vào):
- Danh mục: `back-end/src/main/resources/reference-data/vietnam-address-tree.json` (3.321 phường/xã; seed bằng `V134__addr_01_vietnam_address_reference_data.sql`).
  `fullName` của phường/xã đã ở dạng `Phường Hà Đông, Thành phố Hà Nội` / `Xã … , Tỉnh …` / `Đặc khu …`. Cổng tra: `VietnamAddressReferencePort.findActiveWardReference(provinceCode, wardCode)` → `WardReference(code, provinceCode, name, fullName)`.
- Đơn chỉ chụp tỉnh: `Order.java:226-227` (`shipping_province_code_snapshot`, `shipping_province_name_snapshot`), gán ở `OrderCreateServiceImpl.java` ~955 (đường quote/pricing) và ~1477 (`applyShippingResolution`);
  địa chỉ giải ra `CheckoutAddressResolutionResult(customerId, customerAddressId, addressSnapshotId, receiverName, receiverPhone, shippingAddressText, provinceCode, provinceName)` — chưa có phường/xã.
  Yêu cầu có `wardCode` (`OrderController.java:210`, `ShippingAddressRequest.wardCode`); địa chỉ đã lưu có `CustomerAddress.wardCode`.
- Cầu IVR: `OrderIvrCheckoutBridge.snapshot(...)` dựng `CheckoutSnapshot(... deliveryAreaShort ...)`; `OrderIvrTaskAssembler.validateSpeech` (~dòng 190-198) chặn số đầu chuỗi, `số/số`, chữ `đường|street|số nhà`, dài >160.
- Bảo vệ sửa đơn sau khi gửi: hàm trigger `guard_order_ivr_snapshot_edit()` (thân hiện hành ở `V307__m3_m8_order_edit_permission.sql`, kiểm xem có migration sau đó thay thế chưa) so sánh cả `shipping_province_*_snapshot`.
- Migration: toandeptrai hiện tới V331; `origin/dev` đã có V332–V334 (Phúc). **Dùng V335** (khoảng V335–V339 dành cho gói này; V340+ đã dành cho SKU-M3-02). Kiểm `git ls-tree origin/dev …/db/migration` và `origin/PhucApu` ngay trước khi chốt số.
- Ba tên danh mục M8 từ chối (M3 phải chuẩn hoá khi dựng chuỗi, KHÔNG sửa danh mục để khỏi làm nóng lại): `00378` `Phường Nam Đông Hà., Tỉnh Quảng Trị` (dấu chấm cuối) → `phường Nam Đông Hà, tỉnh Quảng Trị`;
  `00533` `Phường B' Lao, Tỉnh Lâm Đồng` (nháy rời) → `phường B'Lao, tỉnh Lâm Đồng`; `00555` `Xã Chân Mây – Lăng Cô, Thành phố Huế` (gạch dài) → `xã Chân Mây - Lăng Cô, thành phố Huế`.
  Bốn tên khác (`03271`, `01805`, `03094`, `02381`) M8 nhận nguyên văn: giữ nguyên, không chuẩn hoá thêm.

Việc phải làm:
1. Chụp phường/xã lúc đặt: migration (cột snapshot phường/xã trên `orders`, vd `shipping_ward_code_snapshot`, `shipping_ward_name_snapshot` = `fullName` danh mục; nullable; đơn cũ để null) + entity + nạp ở CẢ HAI đường tạo đơn
   (khách vãng lai, khách có tài khoản, địa chỉ đã lưu `shippingAddressId`, địa chỉ nhập tay có `wardCode`, Giờ Vàng). Mở rộng `CheckoutAddressResolutionResult` (giữ constructor cũ) nếu cần.
   Thêm cột mới vào hàm trigger `guard_order_ivr_snapshot_edit` (CREATE OR REPLACE giữ nguyên mọi luật hiện có).
2. Hàm dựng thuần (lớp nhỏ, tĩnh, dễ test): từ `fullName` → `delivery_area_short` theo luật trên, kèm chuẩn hoá ba lỗi trên (bỏ `.` cuối tên, `' ` → `'`, `–/—/‒` → `-`, gộp khoảng trắng, NFC),
   rồi **tự kiểm** bằng đúng `AreaShape` ở trên và các luật `validateSpeech`; không đạt thì trả rỗng.
3. `OrderIvrCheckoutBridge`: dùng hàm dựng; **đơn thiếu phường/xã hoặc không dựng được thì KHÔNG gửi tên tỉnh trơn**. Tìm đường “giữ ở M3, báo nhân viên” đã có (vd `SPEECH_PII_INVALID` /
   `REVIEW_REQUIRED` / giữ hành chính) và dùng lại, không tự chế trạng thái mới; nêu rõ trong báo cáo đơn kết thúc ở trạng thái nào, nhân viên thấy ở đâu, và đơn không cần IVR (COD khách cũ…) KHÔNG bị chặn.
   Kiểm mọi chỗ khác dựng `CheckoutSnapshot`/`deliveryAreaShort` (vd dựng lại khi sửa đơn U13, outbox) để không còn đường gửi tên tỉnh trơn.
4. Test: (a) bảng giá trị vàng — ba ví dụ của M8 + ba tên chuẩn hoá; (b) quét cả 3.321 phường/xã trong `vietnam-address-tree.json`: dựng được và qua `AreaShape` + `validateSpeech`
   (kỳ vọng 3.321; liệt kê mã không đạt, nhất là tên có chữ “đường”); (c) cầu: có phường/xã → chuỗi đúng; thiếu → không gửi; (d) migration + trigger (nếu cần Docker/Testcontainers mà máy không chạy được thì ghi `CHƯA CHẠY` kèm lý do, không bỏ qua im lặng);
   (e) `ModuleBoundaryArchitectureTest` không thêm ca đỏ mới (3 ca đỏ có sẵn); đi qua cổng `address.port`, không import lớp trong của module địa chỉ.
5. Không đổi DTO phản hồi công khai trừ khi bắt buộc.

Xong khi: patch áp sạch lên `44ac63978`; test vùng đổi xanh, kể rõ test nào CHƯA CHẠY; danh sách mã phường/xã không dựng được (nếu có); mô tả đường “giữ ở M3”.

## B. Cầu TLS callback M8 → M3 trên .60 — gói BC, vùng `deploy/m34`
Đúng theo `viec-m34.md` §2: nginx nghe `<M3_CB_BIND_IP>:<M3_CB_PORT>` ssl (TLS 1.2/1.3), chứng thư có SAN `IP:<M3_CB_BIND_IP>` (mặc định 192.168.1.60) do CA riêng của cầu ký; chỉ cho `<M8_ALLOW_IP>` (mặc định 192.168.1.61) vào
(`allow …; deny all;`); chỉ `POST` khớp `^/api/v1/internal/orders/[0-9]+/ivr-result-callbacks$` tới `be:8080` (`limit_except POST`), xoá `X-Forwarded-*`/`Forwarded`, timeout đọc 15 s; mọi path khác `404` (kể cả `GET /` — công cụ M8 dùng để đọc giờ .60 từ header `Date`).
Soạn: dịch vụ nginx trong lớp phủ mới, cấu hình, script sinh chứng thư (`openssl`, ngoại tuyến; khoá giữ `0600` trong thư mục bí mật `0700`, chỉ CA PEM công khai để gửi M8 + in vân tay), kiểm trước khi bật (chỉ đọc).
`M3_CB_PORT` không đặt mặc định mơ hồ: chọn một mặc định hợp lý (vd 8445) NHƯNG script kiểm trước phải kiểm cổng đó trống (`ss -ltn`) và dừng nếu bận; ghi rõ cổng phải được Toàn kiểm trên .60 trước khi chốt (agent không ssh).
Tránh trùng cổng đang dùng trong repo (`deploy/m34/**`, `nginx/`, README).

## C. Cấu hình be M3 trỏ M8 thật .61 — gói BC
Lớp phủ compose MỚI `deploy/m34/compose.m8-that.yml` (KHÔNG sửa `compose.yml`, `trien-khai.sh`, `test_compose.py`, `test_trien_khai.py`: đang có patch NM3-13 chưa commit chạm các tệp đó). Khoá be (`viec-m34.md` §1, tên khoá chuẩn của `IvrAuthProperties`, `IvrTaskClientProperties`, `IvrAdminProperties`, `OrderIvrProducerProperties`):
`app.ivr-auth.issuer=<M8_ORIGIN>` (mặc định `https://192.168.1.61:8443`, https, không `/` cuối, guard) · `tls.pinned-ca-file` + `tls.pinned-ca-sha256` (vân tay DER của `ca-m8.pem`, tính bằng script, không phải bí mật) ·
`token-client.{enabled=true, token-uri=<origin>/oauth2/token, client-id=order-core, client-secret-file=<tệp chmod 600>}` · `callback-verifier.{enabled=true, jwks-uri=<origin>/.well-known/jwks.json, clock-skew=PT30S}` ·
`app.ivr-task-client.intake-uri=<origin>/v1/ivr/order-confirmation/tasks` · `app.ivr-integration.{enabled=true, callback-enabled=true}` · `app.ivr-producer.{execution-mode=MOCK, attempt-policy-version=mock-lab-v4}` · `app.ivr-admin.enabled=false` (đề xuất của M8, không cần ba token admin).
Mọi ràng buộc validator của be (issuer/token/jwks/intake cùng origin https; MOCK ⇒ mock-lab-v4…) phải thoả: đọc `IvrAuthProperties`/`IvrAuthConfigRules`/`IvrTaskClientProperties`/`OrderIvrProducerProperties` rồi viết test dựng cấu hình thật ↔ validator.
Tệp bí mật: be từ chối tệp quyền group/other và máy không có sudo ⇒ dùng đúng mẫu dịch vụ một lần `m8-bi-mat` của `compose.m8-gia-lap.yml` (chép sang volume, chủ uid 10001 của be, 0400) cho `ca-m8.pem` + `order-core-secret` + chứng thư/khoá cầu.
Thư mục nguồn `deploy/m34/m8-that/bi-mat/` (gitignore, 0700): Toàn đặt `ca-m8.pem` (công khai) và `order-core-secret` (64 hex do Lead M8 chuyển bằng tệp chmod 600) vào đó; không bao giờ vào git/compose/properties.
Thêm mục IVR vào `env.mau` (chỉ tên biến + mô tả, không giá trị bí mật; khối cuối tệp để dễ gộp với patch NM3-13). Tài liệu: `deploy/m34/m8-that/M8_THAT.md` (mới; chỉ thêm một dòng trỏ vào README/VAN_HANH nếu thật cần).
Tắt lớp M8 giả lập khi bật thật, có đường quay lại: hai lớp phủ loại trừ nhau (guard từ chối khi cả hai cùng trong `COMPOSE_FILE`); kịch bản chuyển `giả lập → thật` và `thật → giả lập` (đổi một dòng `COMPOSE_FILE` trong `~/m34/.env`, rồi `docker compose up -d --no-build --wait`, các dịch vụ `m8-*` của lab dừng đúng tên), kèm kiểm sau chuyển (chỉ đọc).
Test (python, theo kiểu `tests/test_m8_gia_lap.py`): không dùng docker thật nếu máy không có; không ssh; cấu hình sinh ra không chứa bí mật; guard bắt giá trị sai; sinh chứng thư thật bằng `openssl` trong thư mục tạm và `openssl verify` + SAN IP + vân tay.

## D. Lệnh kiểm chỉ đọc phía .60 + bằng chứng “áp đúng một lần” — phiên chính làm (không giao agent)
## E. Đơn thử E02/E03 + correlation `m3-ivr-<orderId>-<decisionId>` — phiên chính làm

## Diễn biến
(ghi theo lần chạy, giờ thật từ `date`)
- 12/11 ~13:30 · **B+C** commit local `310233def` (cầu `m8that-cb`, lớp phủ `compose.m8-that.yml`, script sinh chứng thư/kiểm trước/chuyển qua lại, `env.mau`). Verifier độc lập ĐẠT (17 đột biến, 15 bị bắt); 5 sửa S1–S4 + D1 đã áp, chạy lại 71 ca xanh. CHƯA CHẠY trên .60/.61.
- 12/11 ~14:20 · **D+E** commit local `a54fbb68a` (`kiem-m3-chi-doc.sh`, `dat-don-uat.py`, `BANG_CHUNG_M3.md`, 11 test xanh). Đã đính chính điều viết sai: be KHÔNG khởi động khi cấu hình IVR sai (crash-loop), không phải chạy tiếp.
- 12/11 ~16:10 · **A** verifier độc lập ĐẠT (147 ca xanh, 25 đột biến, 22 bị bắt; chỗ sống là lỗi 1–2 đã sửa, M11b tương đương vô hại). Áp patch vào checkout chính, sửa 2 điểm verifier nêu: luật dấu nháy lẻ của M8 (`UnsafeApostrophe`) vào `isSpeakable`, thêm test `wardCode` cho địa chỉ đã lưu/nhập tay và ca NFC. Test lọc 5 lớp chạy sau khoá Maven: 147 ca xanh (15+23+11+9+89). **A commit local `a600c43ca`**, nhật ký tuần `74de9d586`; Sheet M3-023 đã đồng bộ. Hộp thư gửi m8: `hop-thu/m8-2026-11-12-noi-m3-xong.md`. CHƯA CHẠY: bộ đủ, Postgres IVR qua Maven, đột biến lại sau sửa, .60/.61. Còn mở: tài liệu lược đồ chưa nêu 2 cột mới; đơn cũ có ngữ cảnh tên tỉnh trơn gây `SPEECH_PII_INVALID` khi Giờ Vàng thanh toán thành công hoặc sửa U13 (chỉ đơn thử MOCK; kiểm trước khi bật).
- 12/11 16:17 · **D-m34-061 (Toàn: "Giữ tới sau UAT")**: 8 xã có chữ "đường" (00306, 00954, 01211, 01784, 02450, 02631, 02794, 03068) giữ ở đường nhân viên xác nhận, luật `validateSpeech` không nới trong UAT; xem lại sau 14/11. Mã gói A `a600c43ca` đã đúng quyết định, không đổi mã.

- 13/11 15:04 · **Dời nghiệm thu sang .99 (D-m34-065, Toàn "Dời sang .99")**: E02 trên .60 ĐẠT và M8 đối soát KHỚP 1/1 (đơn 363, `AP_DUNG_MOT_LAN`); E01, E03, E05, E06-A/B, E10 làm trên .99 sau khi m8 chuyển máy (dự kiến 15–16/11), không đặt thêm đơn và không làm vòng 1 của m8 trên .60. Đổi theo: `M8_ORIGIN` + CA ghim mới + chứng thư cầu SAN IP .99 + chốt cron tồn lớp thật (bản vá chờ gộp).
