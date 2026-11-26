# Từ phiên m8 · 26/11/2026 · Hợp đồng M8 draft.50 đã đóng băng: ghim hash này (thay mọi hash draft.50 cũ)

Đọc cùng [m34-2026-11-25-m8-giong-doc-tran-ngay-ke-hoach.md](m34-2026-11-25-m8-giong-doc-tran-ngay-ke-hoach.md) và phiếu `modules/m8/wp/giong-m34-be-fe.md` (G-08 BE, G-09 FE, T-02).

**Hash CUỐI của `ivr-order-confirmation.v1.yaml` (draft.50): `a8852a7f92d98f6f58424b37ec86d190fe61f5991c549f59668531c66481bcb6`.** Callback `order-core-ivr-callback.target-v1.yaml` không đổi (`323ba1d2…85a7`). Baseline draft.49 không đổi. Nếu hôm trước m34 đã ghim `62cf0a46…4f21` thì bỏ, ghim hash này.

M8 hiện (commit local trong `ginsengfood-ivr` `main`, **chưa push, chưa lên .99**): cả 26 tuyến của draft.50 đã chạy thật (không còn 501): hồ sơ giọng (10), nghe thử + âm thanh clip bank (5), kho cụm tên địa bàn (8), trần cuộc/ngày (3). Tầng token, quyền (`IVR_VOICE_EDIT`, `IVR_VOICE_ACTIVATE`, `IVR_PHRASE_REVIEW`, `IVR_COST_EDIT`), `Idempotency-Key`, `If-Match`, lý do ở bước nguy hiểm giữ như phiếu cũ. Mô tả từng tuyến: `docs/operations/{voice-profiles-admin,voice-preview,speech-phrases-admin,cost-ceilings-admin}.md` trong repo M8.

Điều m34 cần để ý (khác bản mô tả hôm 25/11):
- **Tốc độ đọc và đổi giọng thật chưa có tác dụng ở MVP**: hồ sơ chỉ nhận giọng đã cấu hình (3 giọng, mỗi vùng một giọng) và tốc độ đã duyệt; màn hình nên cho chọn/kích hoạt/quay lại hồ sơ, đừng hứa "chỉnh tốc độ". Chờ Toàn chốt (m8.130).
- **Nghe thử mặc định chỉ nghe cái đã có** (câu cố định, clip bank, cụm đã dựng); dựng mới bị tắt (`409 PREVIEW_UNAVAILABLE`) cho tới khi Toàn bật. Nghe thử không bao giờ phát cho khách.
- **Kho cụm chỉ phục vụ cụm tên địa bàn**; cụm lời chào (có tên khách) trả 404 ở mọi tuyến. CSV xuất > 5.000 hàng là 400 (không cắt). Audio cụm lỗi tệp = 404 kèm `details.reason`.
- **Trần cuộc/ngày**: chưa có trần (hàng trống) thì M8 không quay cuộc nào (`CEILING_UNSET`); lưu trần xong có hiệu lực trong ≤ 5 giây. Hạ trần ≤ mức đã dùng hôm nay phải kèm `acknowledge_below_usage`. Số phải là số nguyên (chuỗi là 400).
- Audio là nhị phân (`audio/wav`, `no-store`), không đi qua lớp JSON 1 MiB của `IvrAdminHttpClient`: cần nhánh riêng như phiếu G-08.

Chưa có phiên m34 thì phần G-08/G-09/T-02 chờ Toàn (m8.141). Đọc xong chuyển sang `hop-thu/xong/`.
