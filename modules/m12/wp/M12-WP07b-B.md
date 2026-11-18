# M12-WP07b-B — Dời ghim hợp đồng `1e73bc1` + WP07b pha B + gộp SKU-M12-03 (`GET /v1/skus`)

Trạng thái: ĐẠT, chờ bộ đủ (Toàn duyệt diff 19:45, D-m12-068; `0bd8be4ec` đã trên remote) · Rủi ro: R3 (bề mặt API ra ngoài, phân quyền principal) · Chế độ: S (checkout chung, không commit) · Mốc: cổng NK-b 20/11
Hạng mục nâng: H8 Kết nối M3 · Sheet: M12-049 (NM3-33), M12-088 (SKU-M12-03) · Ước lượng: 4–6 g + tester + verifier
Chỗ làm: `C:\Projects\ginsengfood-ops-core` `main` @ `2710d7da2` · Quyết định: D-m12-067 (hợp đồng push), lệnh Toàn 14/11 18:2x "Làm ngay"

## Brief
1. Repo `C:\Projects\ginsengfood-ops-core`, `main` @ `2710d7da2`, sửa trên checkout chung, KHÔNG commit/`git add`/nhánh/worktree làm mã. Submodule
   `ginsengfood-contracts` phiên chính ĐÃ checkout `1e73bc1` (nhánh `m12-noi-m3` trên origin; chưa vào `main` hợp đồng — ghi rủi ro, không tự merge).
   Phiên phụ CI đang sửa `.gitlab-ci.yml`, `.gitignore`, `tools/ci/**`, `tests/*.runsettings`, `tests/security/*.ps1`, `tools/agent|db|integration/**`: KHÔNG đụng.
2. Khi xong: (a) gitlink trỏ `1e73bc1` (phiên chính stage); (b) áp `C:\Projects\_wt\m12\SKU-M12-03.patch` (verifier ĐẠT 13/11, `kiem-SKU-M12-03-bao-cao.md`;
   làm theo `brief-SKU-M12-03.md`); (c) WP07b pha B theo `C:\Projects\_wt\m12\WP07b-brief-nhap.md` §3 "Pha B" mục **B1–B4 + B6**: ma trận
   `OPS_CORE_EXTERNAL_CONTRACT_TRUTH_MATRIX.json` (sửa bằng script có kiểm; số đếm tính lại cho CẢ route nhả LẪN `GET /v1/skus`, lấy giá trị manifest từ
   thông báo guard, không bịa), hằng số guard, host kiểm tra bật cờ nhả, parity schema nhả; (d) **KHÔNG làm B5** (không bật `AllocationSelfRelease` trong
   `deploy/m12/compose.yml`: đổi cờ chạy thật là NM3-43, Toàn duyệt riêng); (e) `pnpm run api:sync` nếu `/v1/skus` đổi OpenAPI, tệp sinh đi cùng.
   Đạt: tiêu chí brief nháp §6 mục 1, 3, 4 (trừ B5) + test SKU-M12-03 xanh; host mặc định (cờ tắt) vẫn 404 route nhả.
3. Phạm vi ghi: `services/**`, `tests/**` (trừ tệp phiên phụ ở mục 1), `docs/software-specs/phase-project/OPS_CORE_EXTERNAL_CONTRACT_TRUTH_MATRIX.json`,
   `packages/api-contracts/openapi.json`, `apps/admin-web/src/lib/api/generated/types.ts`, docs B6. Tệp nóng chỉ gói này chạm. Không migration, không seed, không quyền mới.
4. Đọc trước: hai brief trên, `WP07b-A-bao-cao.md`, `kiem-WP07b-A2-bao-cao.md`, `SKU-M12-03-bao-cao.md` (đều ở `C:\Projects\_wt\m12\`); repo `CLAUDE.md`/`AGENTS.md`;
   `.claude/agents/operational-implementer.md`. Grep `DECISION_LOG`/`docs/decisions` theo `WP07b`, `SKU-M12-03` trước khi sửa.
5. Lệnh kiểm nhanh: theo brief nháp §5 (Unit/ApiContract/Integration/Governance lọc), `--artifacts-path .artifacts/dotnet/WP07bB --disable-build-servers`,
   Testcontainers (`REQUIRE_DATABASE_BACKED_TESTS=1`, bỏ `TEST_PG_*`), lọc thêm `~Sku` cho SKU-M12-03. Bộ đủ: KHÔNG (pipeline CI `.63`).
   KHÔNG: cả solution, lane script, ssh, sheet-sync, push, `gitnexus analyze`.
6. Bằng chứng: số trước/sau từng lọc; đột biến ≥ 2; số đếm ma trận cũ → mới; diff stat; mục CẦN QUYẾT.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`. 8. Tin cuối ≤ 25 dòng.

## Diễn biến
- 14/11 18:2x phiên chính checkout submodule `1e73bc1`; giao coder + tester độc lập (tester viết bộ hộp đen route nhả + `/v1/skus` theo hợp đồng `1e73bc1`).

- 14/11 ~19:0x tester độc lập: 57 ca hộp đen (`_wt/m12/WP07bB/tester/`, nhả 25 · `/v1/skus` 32), theo hợp đồng `1e73bc1`. Trên `2710d7da2`: `/v1/skus` 31 đỏ đúng lý do
  (404), lệnh nhả 25/25 xanh (route có sẵn sau cờ từ WP07 ⇒ ca giữ hồi quy); đột biến 4/4; áp mù `SKU-M12-03.patch` ⇒ 32/32. Mơ hồ: id `source_object_id`
  không phải UUID ⇒ 400 hay 422; hợp đồng chưa ghi loại dòng `updated_at` > `as_of`. Chờ coder.

- 14/11 ~19:3x coder ĐẠT: áp SKU-M12-03 (32 tệp), B2 ma trận (op 86→88, v1 68→70, parity 32→34, manifest `7b4a3315…`→`be27b77e…` đọc từ guard),
  B3/B4 (3 cặp DTO nhả + 11 ca đột biến parity, lớp schema nhả 7 ca), B6 tài liệu; không B5, không tệp sinh (route ẩn khỏi OpenAPI) · Unit 683/683,
  Governance 130/133 (3 ca gitlink chờ commit), ApiContract 75/75, Integration 239/239, đua 2/2, đột biến 4/4. Phiên chính sửa chú thích cũ
  `ExternalAllocationReleaseV1Contracts.cs`, stage gitlink, commit cục bộ `0bd8be4ec` (41 tệp, theo danh sách đường dẫn, không lấy tệp phiên phụ CI).
  Verifier R3 kiểm ở worktree `kiem-WP07bB` (gồm bộ tester 57 ca). Còn tồn từ SKU-M12-03: sinh lại `catalog.json`, đoạn `SKU_CODE_IMMUTABLE` trong runbook.

- 14/11 ~20:0x verifier R3 **ĐẠT, chờ bộ đủ** (`kiem-WP07bB-bao-cao.md`): gitlink 4/4, ma trận 14/14 (3 ca gitlink nay xanh), parity nhả 42/42, Unit 683,
  Governance 133/133, ApiContract 57 (lọc brief) + 7 schema nhả, Integration 241, tester 57/57, đột biến 5/5; cờ mặc định tắt, compose không đổi.
  Ghi chú: ca R2 tester không bắt đột biến bật cờ mặc định (test coder bắt); cha thật `61e07b871` (commit CI phiên phụ). Sheet M12-049, M12-088 → Chờ review;
  sổ tuần `4c942fc14`. Worktree `kiem-WP07bB` chưa xoá được (có submodule).

- 14/11 19:45 Toàn "Duyệt" (m12.103 → D-m12-068). Sheet M12-049 85%, M12-088 80% (Đang làm: còn `/release` 200 trên diễn tập = NM3-43; M3 đọc `/v1/skus` = Phúc NM3-34); sổ tuần `70666a73f`.

## Bước kế tiếp chính xác
Pipeline Linux `.63` xanh trên SHA chứa `0bd8be4ec` (= bộ đủ) → ghi SHA + số vào đây, `sheet_lead` khi cả task đạt; NM3-43 bật cờ nhả có duyệt.

## Còn lại / CẦN QUYẾT
- Ghim tới commit chỉ có trên nhánh `m12-noi-m3` (chưa `main` hợp đồng): CI clone theo SHA vẫn lấy được; nhánh không được xoá/force; merge `main` hợp đồng là việc phiên lead.
- B5 (bật cờ nhả trong compose) để NM3-43.
