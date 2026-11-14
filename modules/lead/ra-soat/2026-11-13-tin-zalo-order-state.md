# Tin Zalo nhóm 3 người · 13/11/2026 · nối M3 → M5 đọc trạng thái đơn (D-m5-036)

Toàn tự gửi, chưa gửi. Gửi theo thứ tự: tin chung (kèm 8 file) → tin @Phúc → tin @Tài.
Khi dán vào Zalo, gõ lại `@` và chọn tên để Zalo tag thật (chữ "@Phúc" dán vào không tự thành tag).

**8 file đính kèm, cùng một thư mục, chọn hết rồi kéo vào nhóm:**
`C:\Projects\Project Control\modules\lead\ra-soat\2026-11-13-gui-zalo-order-state\`

| File | Là gì |
|---|---|
| `so-do-1-thanh-phan.png` | thành phần: bên gọi → M5 → M3, các bước 1–7 |
| `so-do-2-tuan-tu.png` | luồng một lần gửi tin có mã đơn, các nhánh lỗi và chặn |
| `so-do-3-anh-xa.png` | bảng + cây ánh xạ trạng thái M3 → PaymentState của M5 |
| `so-do-4-lich.png` | lịch tới 30/11 |
| `giao-viec-order-state-reader.md` | phân tích gốc, có dòng code hai phía |
| `order-channel-state.v1.yaml` | hợp đồng API (bản ở PR 2) |
| `order-channel-state.schema.json` | schema câu trả lời |
| `order-channel-state.v1.examples.json` | 7 ví dụ request/response |

## Tin 1 · gửi chung (kèm 8 file)

```text
Anh giao hai em việc nối M3 → M5: M5 đọc trạng thái đơn từ M3 trước khi gửi tin cho khách. Phúc làm phía M3, Tài làm phía M5. Anh tóm chung ở đây, việc riêng của từng đứa anh tag bên dưới.

Vì sao cần: tin M5 gửi khách có thể có câu "đã nhận tiền", "đơn đã xác nhận". FinalGuard của M5 phải biết trạng thái đơn thật để chặn câu sai. Hiện M3 chưa có API nào cho dịch vụ khác gọi (endpoint đơn nào cũng cần JWT nhân viên hoặc khách), còn M5 đang dùng reader giả, nên chế độ production của M5 không chịu khởi động. Pilot chạy chế độ phạm vi nên không chờ việc này, nhưng chạy thật 30/11 thì phải có.

Cách nối (ảnh 1, 2):
- M5 gọi M3: GET /api/v1/internal/orders/by-code/{mã đơn}/channel-state, header X-M5-Service-Token. Chỉ gọi trong mạng nội bộ máy chủ, không mở ra ngoài.
- M3 trả 7 trường: schema_version, order_code, order_status, payment_status, payment_method, order_version, updated_at. Không trả tên, SĐT, địa chỉ, số tiền, mặt hàng.
- Lỗi: 404 không có đơn, 401 sai token, 503 khi cờ tắt.
- M3 trả giá trị gốc trong enum của mình, M5 tự ánh xạ sang PaymentState (ảnh 3). Phía M5 mọi lỗi hoặc quá 2 giây đều coi là UNKNOWN và chặn.
- Token: một bí mật riêng cho đường này, khác token M4. M3 đọc ở M5_ORDER_STATE_SERVICE_TOKEN, M5 đọc ở M3_ORDER_STATE_SERVICE_TOKEN, cùng một giá trị, đặt trong vault trên .60.

Hợp đồng: https://github.com/sasamviet-ai/ginsengfood-contracts/pull/2 (3 tệp hợp đồng anh gửi kèm cho tiện xem). Hai em review và chốt với nhau trước 17/11 mấy điểm anh ghi ở x-open-points:
1. Tra theo order_code (bên gọi chỉ có mã đơn) hay order_id.
2. Cờ tắt trả 503 hay 401.
3. Đơn COD đã xác nhận mà chưa trả tiền thì M5 coi là gì (anh đề xuất WAITING).
4. Tên 3 mã lỗi.
Chốt xong anh mới gộp PR.

Task trên Sheet: M3-181 của Phúc (hạn 21/11), M5-144 của Tài (hạn 24/11, chờ M3-181).

Lịch (ảnh 4): 17/11 chốt hợp đồng · 21/11 Phúc xong API vào dev · 22–23/11 lên .60 · 24/11 Tài xong reader · trước 26/11 nối thật trên .60 đủ 4 ca: đơn chờ trả, đã trả, đã xác nhận, không có đơn · 26–27/11 chuẩn bị production · 30/11 chạy thật.

Đính kèm: 4 ảnh sơ đồ, file giao việc .md (phân tích gốc, có dòng code hai phía), 3 tệp hợp đồng. Chỗ nào file .md lệch với hợp đồng thì theo hợp đồng.
```

## Tin 2 · tag Phúc

```text
@Phúc phần của em là task M3-181: API nội bộ đọc trạng thái đơn cho M5, P0, hạn 21/11.

1. Review PR hợp đồng (anh gán em rồi), cùng Tài chốt mấy điểm mở trước 17/11.
2. Controller + service chỉ đọc trong order/: tra đơn theo order_code, không đổi trạng thái đơn, không ghi DB, chỉ trả đúng 7 trường trong hợp đồng.
3. Cổng token riêng: header X-M5-Service-Token, so sánh hằng thời gian, cờ AUTH_M5_ORDER_STATE_ENABLED mặc định tắt, token đọc từ M5_ORDER_STATE_SERVICE_TOKEN (khác token M4, để trống thì không khớp gì). JWT nhân viên hay khách không thay được token này. SecurityConfig.java đang dùng chung với phần M4 của Tài, em nhắn Tài trước khi sửa để hai đứa khỏi đè code nhau nha.
4. Test 200 / 404 / 401 / cờ tắt, thêm một ca kiểm câu trả lời không có trường nào ngoài hợp đồng.
5. Snapshot hợp đồng vào contracts/api-snapshots/ giống bên M8, rồi PR PhucApu → dev.
6. Để Tài gọi thử đủ 4 ca thì trên .60 cần 4 đơn test dữ liệu giả: chờ trả, đã trả, đã xác nhận, và một mã không có. Em chuẩn bị giúp anh.

Xong khi: test xanh trên dev, ví dụ request/response khớp hợp đồng, Tài gọi thử được (stub hoặc .60) đủ 4 ca.
Xong em gửi anh link PR và cập nhật M3-181 trên Sheet giúp anh. Vướng gì nhắn anh.
```

## Tin 3 · tag Tài

```text
@Tài phần của em là task M5-144: thay ORDER_STATE_READER mock bằng bản thật gọi API M3, P0, hạn 24/11, nối .60 trước 26/11. Task này chờ M3-181 của Phúc; trong lúc chờ em làm với stub theo 7 ví dụ trong hợp đồng.

Em chưa có quyền repo contracts nên xem 3 tệp hợp đồng anh gửi kèm; cần vào PR thì báo anh thêm quyền. Cùng Phúc chốt mấy điểm mở trước 17/11.

1. Đổi cổng sang async: read(orderRef): Promise<PaymentState>. Dispatcher await trong try/catch, lỗi gì cũng ra UNKNOWN như windowCheck đang làm (outbound-dispatcher.ts:339-340). Hiện ở :441-445 lỗi ném ra là dispatch reject luôn.
2. Lớp HttpM3OrderStateReader theo khuôn http-m4-advisor.ts, tier REAL. Chọn bằng ORDER_STATE_READER_MODE=mock|real (thêm vào ENV_CHOICES), thêm M3_ORDER_STATE_BASE_URL (có /api), M3_ORDER_STATE_SERVICE_TOKEN, M3_ORDER_STATE_TIMEOUT_MS (anh đề xuất 2000). Hiện lớp đang bind cố định ở outbound-guard.module.ts:104. Sửa env-reference.md và khối env mà probe ghim.
3. Ghi DL cho bảng ánh xạ ở ảnh 3, gồm ca đơn COD đã xác nhận mà chưa trả tiền (anh đề xuất WAITING, em quyết có thêm giá trị mới không).
4. Sửa các probe đang ghim reader là MOCK (production-flip-block, smk-runner, smk-evidence-package, runtime-evidence-source), thêm probe cho reader: đủ 6 dòng ánh xạ, quá giờ, 401, evidence order_state_read chỉ có orderRef đã băm.
5. Đừng dán REAL lên mock nha. PR có khối CI_LOCAL GATE=ĐẠT.
6. Token trên .60: em đặt vào vault cùng một giá trị cho cả M3 lẫn M5, phần hạ tầng vault Anh Tuấn lo. Phúc sẽ sửa SecurityConfig.java (phần chung với M4 của em) để gắn token, Phúc nhắn em trước khi sửa.

Xong khi: probe xanh; khởi động production trên máy tạm không còn PRODUCTION_POSTURE_MOCK_ADAPTER port=ORDER_STATE_READER; gọi API M3 thật trên .60 đủ 4 ca; M5-115 chỉ còn chặn bởi các cổng khác.
Xong em gửi anh PR và cập nhật M5-144 trên Sheet giúp anh. Vướng gì nhắn anh.
```
