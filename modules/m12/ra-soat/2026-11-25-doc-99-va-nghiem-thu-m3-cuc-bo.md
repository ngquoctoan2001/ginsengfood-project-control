# Bằng chứng nối M12 ↔ M3, 25/11: đọc `.99` chỉ đọc + bộ nghiệm thu M3 cục bộ 18/18

Hai nguồn, không nguồn nào ghi vào máy chủ. Không có bí mật trong tệp này (không băm, khoá, mật khẩu, `.env`).

## 1. Đọc `.99` chỉ đọc (Toàn duyệt m12.221, D-m12-136), 25/11 12:4x

Cách đọc: một phiên ssh `ssv@192.168.1.99`, truy vấn SELECT với `default_transaction_read_only=on` qua `docker exec` trong `m12-pg-ops-1`; biến môi trường chỉ in các khoá không bí mật; không đọc `.env`; không in cột `secret_hash`/`secret_ref`.

| Mục | Giá trị đọc được |
|---|---|
| Bản M1–M2 | `a0ccc740e16f…` từ 25/11 03:31Z; 4 container m12 healthy; M3 `m34-be-1` healthy |
| API M12 | `ASPNETCORE_ENVIRONMENT=Development` (compose `.99` vẫn bản WP16, chưa Production); không thấy biến `ExternalApi__SourceAllowlist*`, `ExternalApi__AllocationSelfRelease__Enabled`, `ExternalApi__AllocationHoldLimits*` trong môi trường container ⇒ dùng mặc định trong mã (tự nhả TẮT, không giới hạn nguồn) |
| Principal dịch vụ | `SVC-M3-SELLABLE` (ACTIVE, **10 quyền**), `SVC-M6-ADS-RISK` (ACTIVE, 1 quyền); cùng tạo 20/11 |
| Tín chỉ | mỗi principal 1 tín chỉ `HASHED_TOKEN` phiên bản 1, ACTIVE, hiệu lực từ 20/11, hết hạn 19/05/2027, chưa tắt |
| SKU | 19, cả 19 `ACTIVE_BASELINE`; **`op_sku_activation` = 0** (chưa kích hoạt bán SKU nào) ⇒ M12 chưa thể trả "bán được" cho SKU nào |
| Kho | 2 kho KHÁC LOẠI, cùng tên hiển thị "Kho Bình Phú": `WH-20112026-000001` = `RAW_MATERIAL` (nguyên liệu), `WH-20112026-000002` = `FINISHED_GOODS` (thành phẩm), tạo 20/11 04:23:35Z và 04:23:42Z; M3 nối `…002`; **0 vị trí kho**; 19 chính sách cảnh báo tồn thuộc `…002`; không bảng nào khác tham chiếu kho (0 phiếu, 0 tồn) |
| Mẻ / tồn / giữ hàng | 0 mẻ; 0 dòng `op_inventory_allocation`; `outbox_event` 2 dòng |
| M3 (`m34-be-1`, chỉ các biến không bí mật) | `OPS_CORE_ENABLED=true`, `OPS_CORE_BASE_URL=http://192.168.1.99:5000`, `OPS_CORE_CLIENT_ID=SVC-M3-SELLABLE`; **bật**: `WAREHOUSES`, `SKU_LIST`, `ALLOCATION_QUOTA`; **tắt**: `STOCK_BALANCES`, `LIFECYCLE` |
| Lưu lượng M3 → M12, 24 giờ | 627 × `POST /v1/availability/check`, 8 × `POST /v1/service-tokens`, 1 × `GET /v1/skus`; **toàn bộ 200**; **0** lần 401/403/429 |
| Mạng | M3 `172.24.2.8` (mạng `m34_app`, cổng ra `172.24.2.1`, dải `172.24.2.0/24`); M12 API `172.24.1.6` (`m12_default`), cổng 5000 publish `0.0.0.0`; log API KHÔNG ghi IP nguồn ⇒ IP nguồn M12 thấy chưa đo trực tiếp (ước: trong `172.24.2.0/24`) |

Nhận xét:
- **M3 đã bật quan sát từ trước 25/11** (Phúc) và chạy sạch 24 giờ: việc "bật quan sát" (NM3-30) không còn là việc chờ; M12 trả "không bán được" đúng thiết kế vì chưa kích hoạt bán + chưa có mẻ.
- Principal M3 trên DB sạch là **phiên bản 1**, không phải v5 như ghi 17/11: DB sạch 20/11 dựng lại principal (có chủ ý, D-m12-128); M3 vẫn lấy được token ⇒ secret M3 phía `.env` khớp. Không có việc xoay thêm.
- Khi bật chế độ Production + danh sách nguồn cho `/v1` (WP17b), phải đặt `M12_SOURCE_ALLOWLIST` gồm dải `172.24.2.0/24` (M3 gọi qua cổng publish của máy chủ nên M12 có thể thấy `172.24.2.1` hoặc IP container M3); nếu đặt chỉ `172.24.2.8` mà Docker đổi nguồn thành cổng ra thì M3 bị 403 ⇒ đo lại ngay sau bật bằng một lời gọi thật của M3. Đây là dữ kiện còn thiếu của NM3-22/NM3-71.
- Hai kho cùng tên hiển thị nhưng khác loại (nguyên liệu / thành phẩm): dễ nhầm cho Lan (chọn kho trong phiếu). **KHÔNG ngừng `…001`** (kho nguyên liệu, cần cho 27/11; đề xuất ngừng ban đầu của phiên m12 sai, D-m12-137). Việc đúng: đổi tên hiển thị cho phân biệt, thêm 1 vị trí mỗi kho.
- **Khoảng trống phát hiện:** M3 đã gọi 627 lần/24 giờ nhưng M12 không ghi IP nguồn trong log và chưa có cảnh báo tự động (SEC-18) nếu số lỗi 401/403 tăng; theo dõi hiện là tay (NM3-30b 70).

## 2. Bộ nghiệm thu M3 cục bộ (bản HEAD `69a901434` = mã đang chạy trên `.99` + công cụ lab), 25/11 12:36–12:42

Lệnh: `pwsh -File tools/integration/m3-acceptance/local/Invoke-M3AcceptanceLocal.ps1 -ApiPort 5212` (bằng PowerShell gốc; lần 1 hỏng vì Git Bash dùng `tar` GNU). Chạy trên PostgreSQL 18 dùng một lần, DB nhân bản từ mẫu `ginsengfood_uat2710_tpl` (chỉ đọc), áp đủ migration (160) + seed clean-ops, cấp credential cục bộ cho `SVC-M3-SELLABLE` và principal thiếu quyền; lượt 1–2 cờ tự nhả TẮT, lượt 3 cờ BẬT. Không đụng lab, DB dev hay máy chủ.

**Kết quả: 18 ca · PASS 18 · FAIL 0 · SKIP 0; M3 parser: FAIL 0 (PASS 6, N/A 12).** Gồm: lấy token + 7 quyền (1), tồn kho không tham số/theo SKU/phân trang/đổi limit/`materialId` sai (2, 3, 6, 7, 8), kiểm bán được: bán được, vượt tồn, khoá bán, có `uom_code`, đúng dạng M3 gửi thật FULL_FILL (4, 5, 11, 12, 13, 14), giữ hàng + gọi lại cùng khoá `X-Idempotency-Key` (9), token thiếu quyền 403 (10), tự nhả khi cờ TẮT = 404 (C37-1), cờ BẬT: tự nhả + phát lại cùng khoá (C37-2), nhả lại nguồn đã nhả `ALLOCATION_NOT_HELD`/dùng lại khoá cho nguồn khác 422 (C37-3), phân bổ đã `ISSUED` không nhả được/không giữ lại được (C37-4).

Ý nghĩa: bản M12 đang chạy trên `.99` (cùng mã) đáp đúng mọi tình huống phía M3 đã thiết kế (kể cả bộ kiểm parser của M3). Phần còn thiếu trước khi M3 vào giữ hàng thật: S08–S14 (hết hạn, `CONFIRMED`, xuất bán) cục bộ (đang làm), ghim hợp đồng (đang làm), và chạy lại ngay trên `.99` sau khi có mẻ bán được (NM3-45b).

Artefact (gitignored, chỉ trên máy Lead): `.artifacts/m3-acceptance/local-20261125053611wiyn/{summary.md,raw-log.jsonl,results-*.json}`.
