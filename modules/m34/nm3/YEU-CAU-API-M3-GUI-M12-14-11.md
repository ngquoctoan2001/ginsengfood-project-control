# Anh trả lời file `yeu-cau-api-m3-gui-m12-2026-11-14.md` của em — đối chiếu với thực tế (14/11/2026)

Anh đối chiếu từng dòng với hợp đồng M12 (bản em đang ghim `a7832a4` và bản nháp mới `m12-final-draft`, `1e73bc1`), với code M3 ở `dev` = `toandeptrai` = `9bc855de8` và với code M12. Em ghi rõ là chưa đối chiếu repo M12 và chưa đọc nhánh hợp đồng mới, nên một số dòng "THIẾU/CHƯA CÓ" thật ra đã có hoặc đã chốt. Chỗ anh chưa kiểm ghi CHƯA KIỂM.

## 1. Kết luận 8 dòng
1. **Phần lớn P0 đã có.** Phân trang tồn kho (K5) đã có trong hợp đồng em đang ghim; `GET /v1/skus` (S4) và enum kho (K1) đã có trong bản nháp M12 (anh chưa đẩy lên GitHub); tài khoản dịch vụ `SVC-M3-SELLABLE` (V1) đã có.
2. **Giữ/nhả hàng (H1–H9): mã M3 anh làm xong từ 12–13/11** (NM3-40/41/42, cờ tắt), không còn là việc "24/11". Còn lại là bật: không sớm hơn 20/11, sau quan sát và sau khi chốt trần hold.
3. **Hai thứ em xin mà anh không làm theo cách em đề xuất:** hỏi nhiều SKU một lần (S5: `/v1/availability/check` là MỘT SKU một lần; 19 SKU thăm dò 4–5 phút chỉ ~0,06 yêu cầu/giây nên không cần); lọc gia tăng cho tồn kho (K6: hợp đồng ghi `x-delta-supported: false`, kéo cả bảng nhỏ là đủ).
4. **Chưa làm được hôm nay:** tài khoản thử riêng (V2) và môi trường thử cho máy dev (V3). Cổng `.99:5000` chỉ mở cho `.60` và `.98`; anh không mở cho IP máy dev khi M12 chưa có allowlist ở lớp ứng dụng. Anh sẽ làm bộ chạy M12 cho máy em (OD-10).
5. **OD-3, 4, 5, 6, 10 anh đã chốt** (mục 3): hàng trả qua QC; M3 chưa phát sự kiện đơn; anh duyệt nội dung bản nháp hợp đồng; thu hẹp lọ/hũ sau khi anh kiểm xong; anh làm bộ chạy M12 cho máy dev. Đẩy hợp đồng lên GitHub anh làm khi xong phần SKU; xoay secret dev (N21) anh làm trước khi quan sát trên `.99`.
6. **Đã chốt từ trước, không cần hỏi lại:** OD-1, OD-2, OD-7, OD-8, OD-9.
7. **Em sửa trong file của em** (mục 4) trước khi đưa Phần B cho AI viết code, vì vài mặc định ở B.10 lệch hợp đồng.
8. **Chưa gọi M12 thật lần nào** (đúng như em ghi); quan sát thật bắt đầu khi M3 lên `.99`.

## 2. Đối chiếu từng dòng (Phần A)
| Dòng | Em ghi | Thực tế | Ai / khi nào |
|---|---|---|---|
| S1 | ĐÃ CÓ | Đúng | — |
| S2, S3 | THIẾU: `updated_at`, `revision`, `sellable_uoms` | Có trong bản nháp M12 (`f2f1635`, `aa980c1`), anh chưa đẩy lên GitHub; `revision` ≈ 1,79e15 < 2^53 và cam kết không giảm; M12 chạy thật ≈ 24/11 | Anh đẩy hợp đồng; em ghim ở NM3-34 sau khi đóng băng ≈ 20/11 |
| S4 | CHƯA CÓ `GET /v1/skus` | **Đã có trong bản nháp** (`2062a7b`: cursor, limit, `lifecycle_status`, `updated_since`). Cách đọc khuyến nghị: gia tăng mỗi 5', `updated_since` = lần thành công trước − 5', đọc đủ khi khởi động và ít nhất mỗi 24 giờ. `GET /v1/skus` không ẩn SKU theo trạng thái; INACTIVE/RETIRED chặn bán nhưng vẫn đọc tồn | Em: bộ đọc phân trang (NM3-34) |
| S5 | Hỏi nhiều SKU một lần | **Không có và không cần**: request mẫu `availability-check.request.json` gồm `sku_id` + `warehouse_id` + `requested_quantity` | Bỏ khỏi yêu cầu |
| K1 | Enum kho chờ ghi hợp đồng | Đã ghi enum đóng `RAW_MATERIAL`/`FINISHED_GOODS` + `ACTIVE`/`INACTIVE` trong bản nháp (`80e0127`), chưa lên GitHub | Anh đẩy hợp đồng |
| K2 | ĐÃ CÓ | Đúng (`INVENTORY_BALANCE_VIEW`, audience bulk-read-v1) | — |
| K3 | `lot_code` THIẾU | **Sai: đã có**, bắt buộc ở mỗi dòng `stock-balances` (schema `external-stock-balance.schema.json`, mã lô hiển thị) | Xong |
| K4 | `expiry_date` chưa cam kết | Có ở bản nháp (`7ede9b8`, tuỳ chọn, kiểu `date` YYYY-MM-DD theo ngày lịch Việt Nam; ví dụ `examples/api/x03b/stock-balances.expiry.response.json`); code M12 đã viết và kiểm trên Postgres thật, chưa lên `main` (chờ hợp đồng đẩy); lô không có hạn thì vắng ⇒ M3 hiện "Chưa có HSD" | Chạy thật ≈ 24/11 |
| K5 | THIẾU phân trang | **Sai: đã có** trong `a7832a4`: tham số `Cursor`, `Limit` + `x-pagination-policy: ExternalSnapshotCursorV1` (limit mặc định 50, tối đa 100, cursor hết hạn 1800 s tuyệt đối, đủ khi nhận hết và `next_cursor` rỗng). Script đồng bộ tồn của anh (`deploy/m34/ops-core/dong-bo-ton.py`, NM3-31, `95f73875c`) đã đọc theo con trỏ này | Xong; em dùng đúng quy ước |
| K6 | Lọc gia tăng tồn | `x-delta-supported: false` ở `stock-balances`; chỉ `GET /v1/skus` có `updated_since` | Không xin thêm (19 SKU) |
| K7–K9 | Có trong hợp đồng, M3 chưa gọi | Đúng, P2 | Sau 24/11 nếu cần |
| H1–H5 | Giữ/nhả/đối soát/khoá/mã lỗi | **Mã M3 anh làm xong** (`6b19d621c`, `382d842ee`, `d789e53aa`, `bf3083f33`); khớp hợp đồng: giữ ≤60' tính từ lúc M12 nhận (M3 gửi 54:30), 409 `INSUFFICIENT_STOCK` ≠ 409 `ALLOCATION_CONFLICT` (`HOLD_LIMIT_REACHED`/`HOLD_SHARE_LIMIT_REACHED` là trần, không phải hết hàng), 429 + `Retry-After`; HTTP 500 không gửi lại, kết quả UNKNOWN + đối soát (`719574370`) | Xong; bật ≥ 20/11 |
| H6 | Hai bộ tên trạng thái lệch | Bộ thật = hợp đồng: `RESERVED`/`CONFIRMED`/`ISSUED`/`RELEASED`. `HELD`/`COMMITTED`/`EXPIRED` là tài liệu WMS cũ; `EXPIRED` chỉ là trạng thái nội bộ M3. Chuyển sang `CONFIRMED` do KHO (người) xác nhận bên M12 và không tự hết hạn tới `ISSUED`; M3 không có và không cần lời gọi "xác nhận giữ" | Xong (OD-8) |
| H7 | Tín hiệu `ISSUED` | **Anh chốt không thêm** sự kiện `ISSUED` hay giữ hết hạn (13 loại giữ nguyên; webhook chỉ là gợi ý "kéo lại"; giữ/nhả/xuất không đi ra theo thiết kế). M3 đối soát bằng `GET allocations` (cursor, lọc theo nguồn; NM3-42). Muốn có sự kiện = yêu cầu hợp đồng mới sau khi đóng băng | Chốt |
| H8 | Hạn mức | M12 (mặc định đang dùng, anh chốt giữ nguyên): 200 hold/principal, ≤60', 80% tồn sàn 50, 1000/dòng. M3: 3 hold/khách, 10/giờ/IP, 100 hộp/dòng. M3 giữ theo DÒNG đơn nên 1 dòng = 1 hold; `CONFIRMED` còn tính vào trần tới khi `ISSUED` | Chờ số giờ cao điểm |
| H9 | Giữ theo lô hay SKU | Một lệnh giữ một SKU/kho/đơn vị; M12 chọn lô, một lệnh trải nhiều lô vẫn là 1 hold; `lot_code` trả trong dòng phân bổ | — |
| R1–R5 | Trả hàng | Chưa có API; M3 lo tiền và đơn, M12 quyết nhập lại kho | OD-3 |
| §8 | Webhook | 13 loại khớp; HMAC `v1=<hex>`, ≤64 KiB, lệch ≤300 s, dedupe `X-Outbox-Event-Id`; `eventType` thiếu/sai ⇒ 2xx bỏ qua + cảnh báo `WEBHOOK_LOAI_SAI` (`719574370`) | Xong |
| §9 | M3 báo đơn cho M12 | Hợp đồng 6 sự kiện đơn đã có; chưa có đường gửi | OD-4 |
| V1 | Tài khoản dịch vụ riêng M3 | `SVC-M3-SELLABLE` có; cần 3 audience (availability-v1, bulk-read-v1, allocation-v1) + `INVENTORY_ALLOCATION_CREATE`/`VIEW` (đã ghi vào bản nháp); anh xoay secret dev (N21) trước khi quan sát | Anh |
| V2, V3 | Tài khoản thử, môi trường thử | Chưa làm được hôm nay: `.99` (bản thử) chưa có công cụ tạo principal; cổng 5000 chỉ cho `.60`/`.98`. Hiện anh mới có `docker-compose.local.yml` (Postgres 18 + Redis, cổng 55432), 62 tệp seed (19 SKU, principal dev `SVC-M3-SELLABLE` với secret dev công khai chỉ dùng cục bộ) và script dựng DB. Bộ chạy được trên máy sạch của em anh làm mới (nửa đến một ngày) | Anh làm (OD-10); quan sát thật trên `.99` sau khi M3 lên |
| V4 | `/health/live`, `/health/ready` | **Cả hai đều có** (`ready` có thành phần `OUTBOX_QUEUE`, ẩn danh nên không lộ chi tiết); anh dùng `ready` kiểm sau mỗi bước nối | Xong |
| V5–V8 | Giới hạn, 4 MB/trang, vỏ lỗi, cầu dao | Hợp đồng: policy `ExternalWarehouseRead` 5 rps, `ExternalBulkRead` 2 lần chờ/30 s (script đồng bộ tồn đã theo); trang tối đa 100 dòng nên < 4 MB; vỏ lỗi có `correlation_id` | Xong |
| V9, V10 | ID/đơn vị ổn định, đổi hợp đồng | `sku_code` bất biến (trigger DB), nếu đổi bằng migration thì anh báo em trước; quy trình nhánh hợp đồng → em rà → em ghim đang chạy (NM3-32b/32c/34) | — |
| V11–V14 | NTP, HTTPS, đầu mối, quan sát | NTP: SEC-25 anh còn mở; HTTPS: M12 chạy thật bắt buộc https cho webhook (M3 → M12 trong LAN dùng http + cờ); đầu mối M12 là anh; quan sát 48–72 giờ = NM3-30 sau khi M3 lên `.99` | — |

## 3. Chín quyết định B.10 (OD-1…OD-9, thêm OD-10)
| Mã | Quyết | Trạng thái |
|---|---|---|
| OD-1 nguồn sự thật tồn | **M12.** M3 kéo một chiều, `qty_available` = available của M12, không ghi ngược | **Đã chốt** |
| OD-2 bật giữ/nhả | Mã xong, cờ tắt; bật ≥ 20/11, sau quan sát và sau khi chốt trần hold. Dòng "mức 3" trong `NOI_M12.md` §7 là ô `[ĐIỀN]` chờ kết quả chạy thật, không phải "chưa có mã" | **Đã chốt** |
| OD-3 hàng trả về | **Qua QC, không tự cộng tồn.** M3 giữ tiền/đơn, M12 quyết nhập lại/huỷ/kiểm dịch, báo ngược bằng sự kiện. Chưa viết `POST /v1/inventory/returns` tới khi M12 có loại biến động kho "trả hàng" | **Anh chốt** (đổi được nếu chú Dũng/Khánh QC khác ý) |
| OD-4 vòng đời đơn | M3 **chưa phát** tới sau quan sát. Giữ/xuất kho không cần M12 biết đơn; nếu M12 cần "soạn hàng" thì M3 phát sự kiện đơn (6 loại hợp đồng đã có) cho M12 nghe, không để M3 gọi API M12 | **Anh chốt** |
| OD-5 duyệt nhánh hợp đồng | Anh **duyệt nội dung** bản nháp (`m12-final-draft`); em đọc "chịu thiếu trường" trong lúc chờ. Anh đẩy lên GitHub khi xong phần SKU, trước ≈ 20/11 | **Anh duyệt**, đẩy sau |
| OD-6 lọ/hũ | Hiện không SKU nào bán lọ/hũ. **Em thu hẹp `chk_ocsl_uom` còn hộp/thùng** (migration mới, dùng số trống trong dải V341, V343 hoặc V345; Flyway `out-of-order: true`) sau khi anh kiểm xong cách `/check` xử lý đơn vị ngoài trade item và báo em | **Anh chốt** |
| OD-7 ngày hết hạn lô | Trường tuỳ chọn `expiry_date`; thiếu thì "Chưa có HSD", không tự tính | **Đã chốt**, chạy thật ≈ 24/11 |
| OD-8 bộ tên trạng thái | Bộ M3 đang đọc = hợp đồng (RESERVED/CONFIRMED/ISSUED/RELEASED) | **Đã chốt** |
| OD-9 phân trang | **Theo hợp đồng, không theo mặc định B.10:** `limit` mặc định 50, tối đa 100, `cursor` snapshot, hết hạn 1800 s; B.10 ghi 100/500 là sai | **Đã chốt** |
| OD-10 (mới) bộ chạy M12 cho máy dev | Bộ chạy được trên máy sạch (compose + API cục bộ + seed 19 SKU + tài khoản thử + hướng dẫn), nửa đến một ngày. **Anh làm**, báo em ngày dự kiến sau khi xong việc đang chặn đường găng bên anh; trong lúc chờ em thử bằng test/fixture | **Anh chốt** |

## 4. Em sửa trong file của em trước khi giao AI
- **B.2 E5** (`GET /v1/skus`): đổi từ "ĐỀ XUẤT" thành "CÓ trong bản nháp `m12-final-draft`, chờ đẩy lên GitHub".
- **B.2 E8 và A mục K5, V6:** bỏ "THIẾU phân trang" (đã có `Cursor`/`Limit`/snapshot, limit 50/100).
- **B.10 OD-9:** đổi 100/500 thành 50/100; thêm "cursor hết hạn 1800 s, đọc lại đủ khi hết hạn".
- **A mục 6 (đầu) và 11:** NM3-40/41/42 đã xong; không còn mốc 24/11 cho mã M3.
- **A mục 4 (S5):** bỏ; **mục 5 (K3, K4):** `lot_code` đã có (bắt buộc), `expiry_date` có ở bản nháp; **mục 10 (V4):** `/health/ready` có.
- **A mục 13 dòng 4 và 190:** nhánh hợp đồng nay là `m12-final-draft` (anh chưa đẩy lên GitHub); phần lớn câu hỏi của em đã có trả lời trong file này.
- **B.10 OD-2:** ghi "mức 3" là ô `[ĐIỀN]` trong `NOI_M12.md` §7.

## 5. Anh đã kiểm trong code M12 (14/11) cho bốn điểm em chưa rõ
`lot_code` và `expiry_date` trong `stock-balances`: có (K3, K4). Sự kiện `ISSUED`/giữ hết hạn: không thêm (H7). Bộ chạy M12 cho máy dev: chưa có, anh làm mới (V2/V3). `/health/ready`: có (V4).

## 6. Em nhờ anh 3 việc: trả lời
1. **Từng dòng mục 4–7, 10:** bảng mục 2 ở trên.
2. **Gấp nhất, trước 17/11:** enum kho (có trong bản nháp, anh đẩy lên GitHub sau); tồn kho phân trang (đã có từ trước); tài khoản dịch vụ riêng cho M3 (`SVC-M3-SELLABLE` có; anh xoay secret dev); môi trường thử có dữ liệu mẫu (anh làm bộ chạy cho máy em, chưa có ngày). Đồng bộ tồn một chiều (script đồng bộ tồn) đã sẵn; chạy được khi M3 lên `.99` và link SKU/kho được nạp.
3. **Chín quyết định (+OD-10):** mục 3, đều có đáp án; riêng việc đẩy hợp đồng lên GitHub anh làm sau.
