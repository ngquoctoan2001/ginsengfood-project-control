# Từ phiên m8 · 26/11/2026 · Hợp đồng M8 draft.51 (thêm 6 tuyến): ghim hash này, làm nút "đặt cả bộ" và màn hình Tỉnh–Vùng

Đọc cùng [m34-2026-11-26-m8-draft50-hash-cuoi.md](m34-2026-11-26-m8-draft50-hash-cuoi.md). Quyết định của Toàn: D-m8-161/162 trong `modules/m8/QUYET_DINH.md` (ba vùng ba giọng khác nhau GIỮ; đổi giọng là đổi theo từng vùng; tốc độ 0.80–1.20 bước 0.05; thêm cấu hình tỉnh thuộc vùng).

**Hash CUỐI của `ivr-order-confirmation.v1.yaml` (draft.51): `abf1d485f621b1a56f373053f459b7100bff0797bbc78ab38de047bbfcea61fd`.** draft.51 chỉ THÊM so với draft.50 (`a8852a7f…bcb6`, bản m34 đã ghim: giữ nguyên từng byte ở `specs/api/openapi/baselines/ivr-order-confirmation.v1.0.0-draft.50.yaml`). Callback không đổi (`323ba1d2…85a7`). Mã M8 (repo ivr `main` local, commit `cebf9d1c`, chưa lên .99) đã chạy đủ 32 tuyến.

## Sáu thao tác mới (đường dẫn dưới `/v1/ivr/order-confirmation`)
| operationId | Tuyến | Tầng · quyền |
|---|---|---|
| `activateVoiceProfileSet` | `POST /voice-profiles:activate-set` | danger · `IVR_VOICE_ACTIVATE` (như `:activate`: lý do ở thân, `Idempotency-Key`) |
| `listRegionProvinces` | `GET /region-provinces` (+ `ETag` = `table_version`) | read |
| `getRegionProvince` | `GET /region-provinces/{key}` | read |
| `getRegionProvinceReadiness` | `GET /region-provinces/{key}/readiness?target_region&missing_limit&page_token` | read |
| `warmRegionProvince` | `POST /region-provinces/{key}:warm` | write · `IVR_VOICE_EDIT` |
| `applyRegionProvinces` | `PUT /region-provinces` | danger · `IVR_VOICE_ACTIVATE`, `If-Match: "<table_version>"`, `X-Action-Reason` |

Quyền dùng lại hai quyền giọng đã có ở V410: không cần migration mới ở M3 (m8.153 = A, mặc định).

## Cho màn hình
- **Đặt cả bộ (hoán đổi giọng giữa vùng):** thân `{profiles:[{profile_id, if_match}], reason}` (2–3 hồ sơ DRAFT, mỗi vùng tối đa một, lý do 10–500 ký tự). Chỉ thành công khi mọi hồ sơ sẵn sàng và KẾT QUẢ vẫn là ba vùng ba giọng khác nhau; một lỗi = không đổi gì. Lỗi: 400 `/profiles` `SET_SIZE_INVALID|SET_PROFILE_DUPLICATE|SET_REGION_DUPLICATE`, `/reason` `REASON_TOO_SHORT`; 409 kèm `details.profile_index`. Kích hoạt từng hồ sơ riêng vẫn bị chặn nếu trùng giọng vùng khác: UI nên hướng người dùng sang "Đặt cả bộ".
- **Tỉnh–Vùng (G-14):** bảng 34 tỉnh × vùng (R1: `items[]` có `province_key, code, name, names[], region, default_region, is_default, row_version, updated_at, updated_by`; banner `source{flag,state}`: cờ `OPTIONS` ⇒ báo "đổi ở đây CHƯA có hiệu lực" cho tới khi bật `RegionSource=STORE`). Chọn nhiều dòng → hộp thoại 3 bước: (1) R3 xem thiếu (`needed, ready, failed, pending, missing_count, complete, store_empty, missing[]`); (2) R4 làm nóng, lặp R3 mỗi 5 giây tới `complete`; (3) R5 áp dụng (`If-Match` = `table_version`, lý do, `changes[{province_key, region}]`): chỉ ghi khi MỌI tỉnh `complete` (409 `IVR_OPERATIONAL_BLOCKED` `details.reason=REGION_NOT_READY`, `details.not_ready="khoá:thiếu,…"`); lệch phiên bản ⇒ 409 `IVR_VERSION_CONFLICT` + `details.current_table_version`. Nhắc người dùng: khách ở tỉnh đó sẽ nghe giọng và cách đọc số của vùng mới; đơn đã nhận mà chưa gọi cũng theo vùng mới. Quay lại = áp dụng lại vùng cũ; "về mặc định" = gửi `default_region`.
- Mẫu 200 đầy đủ và mã lỗi: `docs/operations/region-provinces-admin.md` §7 và `docs/operations/voice-profiles-admin.md` (repo ivr, đọc chỉ).
- Nhớ proxy chuyển nguyên `details.errors/failed_checks/variants_missing/not_ready/current_table_version`.

## Chưa có / chưa làm
- Cờ `RegionSource` và `ProfileSource` mặc định `OPTIONS`; hiệu lực thật chỉ khi Toàn bật ở .99. Bank hiện chỉ có 3 cặp (mỗi vùng một giọng gốc). Hồ sơ chọn giọng KHÁC giọng gốc của vùng, kể cả hoán đổi giữa hai vùng bằng "Đặt cả bộ", chỉ sẵn sàng khi bank có cặp đó (phải dựng thêm 6 cặp ở .99 và Toàn nghe duyệt); trước đó M8 trả 409 `VOICE_NOT_READY` với `failed_checks` có `bank`. Màn hình chỉ cần hiển thị lý do.
- Ma trận hành vi API của 6 tuyến mới đang làm bên M8; verifier độc lập chưa chạy. Nếu m34 thấy lệch giữa YAML và thực tế thì báo m8.
