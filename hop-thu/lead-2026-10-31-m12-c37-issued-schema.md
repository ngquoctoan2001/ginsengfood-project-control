# Từ phiên m12 · 31/10 22:52 · C37 cần sửa hợp đồng (repo `ginsengfood-contracts`, thuộc phiên `lead`)

M12-WP04 (Sheet M12-007) đang hiện thực C37 trong ops-core: phân bổ có trạng thái mới `ISSUED` (giữ hàng → xuất bán),
theo `C:\Projects\ginsengfood-ops-core\docs\decisions\hop-dong-module-ngoai.md` §OD-ALLOC-CONSUME-01 (mục C37-2 số 12).

## Cần phiên `lead` làm

1. Thêm `ISSUED` vào enum trạng thái của 2 schema: `schemas/ops/x03b/external-inventory-allocation.schema.json`,
   `schemas/ops/x03b/external-allocation-reserve-line.schema.json` + CHANGELOG. Theo `VERSIONING.md` là thay đổi phá vỡ phía
   M3 → Phúc review trước khi merge (`docs/integration/module-3/09-09-09-55-chot-ket-noi-module-3.md:1137`).
2. Sau khi publish: dời pin submodule trong ops-core (phiên m12 làm khi được báo).

## Điều lạ cần bạn xem trước

- Ops-core pin submodule ở `a7832a49` (có thư mục `schemas/ops/x03b/`).
- Repo dùng chung `C:\Projects\ginsengfood-contracts` đang ở `08585c1`: **không chứa** `a7832a49` trong lịch sử của HEAD
  (`a7832a49..HEAD` = 1 commit, `HEAD..a7832a49` = 81 commit), cũng không có `x03b`. Cùng remote `sasamviet-ai/ginsengfood-contracts`.
  → hai dòng lịch sử tách nhau; cần chốt dòng nào là chuẩn trước khi sửa schema.

Không gấp hơn mốc B (10/11); mã ops-core không phụ thuộc bước này để chạy test nội bộ.

## Bổ sung 01/11 17:01 — operation mới cùng vòng (QĐ 5B)

Theo DEC OD-M3-REPLY-01 §3.2 + mục 5B, lệnh `/v1` tự nhả (QĐ 2B) đi **cùng vòng hợp đồng** với `ISSUED`. Ops-core đã có mã
(commit `f6f848e96`, route `POST /v1/inventory/allocations/release`, `operationId: releaseInventoryAllocationV1`, sau cờ tắt mặc định
`ExternalApi:AllocationSelfRelease:Enabled` tới khi dời pin). Cần thêm vào `ginsengfood-contracts` (chi tiết từng trường:
`C:\Projects\_wt\m12\WP07-bao-cao.md` §4):

1. `openapi/ops-core/inventory.v1.yaml`: path mới, `security: ServiceBearer`, audience `allocation.v1`.
2. Schema mới trong `schemas/ops/x03b/`: `external-allocation-release-request`, `-result`, `-line`, `-error` (hoặc mở rộng reserve-error)
   với mã mới `ALLOCATION_NOT_HELD` (409, không retry).
3. asyncapi không đổi (dùng lại `INVENTORY_ALLOCATION_RELEASED`). CHANGELOG/VERSIONING: một bản cho cả `ISSUED` + operation mới; Phúc review.
4. Sau khi publish: phiên m12 dời pin, sửa truth matrix (32→33 operation), bật cờ.
Các chi tiết hiện thực để Phúc góp ý trong vòng review (không phải quyết định owner): 409 `ALLOCATION_NOT_HELD` hay 200 `ALREADY_RELEASED`;
dùng chung túi rate `ExternalAllocationWrite`; khoá idempotency dùng lại cho nguồn khác → 422 (lệnh giữ đang trả 409).
