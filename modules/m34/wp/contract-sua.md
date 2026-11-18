# contract-sua — `SkuMasterSeederWriteContractTest` xanh lại theo seed-packs (M3-162, SKU-M3-12)

Trạng thái: XONG (Đạt 15/11) · Rủi ro: R2 · Chế độ: A (worktree tách rời → patch → phiên chính áp + commit trên `toandeptrai`) · Mốc: trước 16/11
Hạng mục nâng: SKU-M3-12 khoá ghi mã SKU chuẩn, test hợp đồng đỏ → xanh · Sheet: M3-162 · Ước lượng: 1 giờ
Chỗ làm: `C:\Projects\_wt\m34\contract-sua` · Base SHA: `afb6d404c` · Patch: `C:\Projects\_wt\m34\contract-sua.patch` · Chỗ kiểm: worktree `kiem-contract-sua`
Nguồn: rà 14/11 (`ra-soat/evidence/2026-11-14-nm3-26/auditor-4.md` dòng M3-162), D-m34-080 (g).

## Brief
1. Repo `C:\Projects\ginsengfood-business-platform` (chỉ đọc) · làm trong `C:\Projects\_wt\m34\contract-sua` (HEAD tách `afb6d404c`) · luật chung: `C:\Projects\_wt\m34\_tools\BRIEF_CHUNG_SUA_NKB.md` (đọc trước).
2. Mục tiêu: `SkuMasterSeederWriteContractTest` (gói `seed`) xanh 4/4 trên `afb6d404c` mà KHÔNG nới luật.
   Hiện `skuMasterInsertsNeverUseConflictUpdate:76` đỏ: đòi ≥ 8 chỗ ghi `sku_master_codes` + chứa `CatalogE2ePackJdbcRepository.java`, `IvrOrdersRealE2eDataSeeder.java`,
   `GoldenHourAutomationE2eFixtureJdbcAdapter.java`; còn 5 sau khi Phúc chuyển seeder sang seed-packs (`4035b3b45`, `e275bfe4f`, gộp dev `128ed05c0`).
   Tiêu chí đạt:
   (a) Liệt kê thật mọi chỗ còn ghi `sku_master_codes` trên `afb6d404c` (Java main + SQL không phải migration + tệp dữ liệu seed-pack nếu có SQL/JSON trỏ bảng này);
       cập nhật ngưỡng và danh sách tên tệp bắt buộc trong ca "không rỗng" theo đúng tập đó (ghi rõ trong javadoc vì sao đổi, dẫn commit seed-packs).
   (b) Thêm ca khẳng định bộ nạp seed-pack không ghi `sku_master_codes` bằng đường nào khác ngoài các chỗ đã liệt kê có `ON CONFLICT (sku_code) DO NOTHING`
       (ví dụ: quét các `*PackEntryHandler`/`*SeedPack*JdbcRepository` và tài nguyên gói seed; nếu seed-pack dùng tên bảng động từ dữ liệu thì kiểm danh sách bảng được phép).
   (c) Nếu phát hiện chỗ ghi THẬT vi phạm luật (UPSERT `DO UPDATE`, `UPDATE sku_master_codes`, ghi đè nghĩa mã): KHÔNG sửa mã chạy của Phúc; dừng, ghi `CẦN QUYẾT` kèm tệp:dòng.
3. Phạm vi ghi: CHỈ `back-end/src/test/java/com/ginsengfood/project/seed/SkuMasterSeederWriteContractTest.java` (và tệp test mới cùng gói nếu cần).
   CẤM: mọi tệp `src/main/**`, migration, tệp seed-pack.
4. Đọc trước: chính tệp test (javadoc đầu tệp), `git log --oneline -8 -- back-end/src/main/java/com/ginsengfood/project/seed back-end/src/main/resources` ở worktree,
   các `seedpack` handler (`grep -ril seedpack back-end/src/main/java`), `auditor-4.md` ở trên.
5. Lệnh kiểm nhanh: Maven qua khoá `-P ci-unit -Dtest='SkuMasterSeederWriteContractTest'` (chạy trước khi sửa thấy đỏ một lần, sau khi sửa thấy xanh).
   Bộ kiểm đủ: chỉ phiên chính, cuối sóng. Không Testcontainers.
6. Bằng chứng: patch; danh sách chỗ ghi thật (tệp + kiểu ghi); đỏ trước/xanh sau (số ca); 2 đột biến: thêm tạm một `INSERT INTO sku_master_codes … DO UPDATE` vào một tệp main
   trong worktree → test đỏ; xoá `DO NOTHING` ở một chỗ ghi → đỏ; trả lại cả hai.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`.
8. Đầu ra ≤ 25 dòng theo brief chung.

## Diễn biến
- 14/11 22:26 giao coder v1 (nền).
- 14/11 22:52 coder v1: ĐẠT · 1 tệp test (+259/−3) · đỏ trước 4 chạy/1 hỏng (`:76` ≥8 but 5) → xanh 7/7 (4 cũ + 3 ca seed-pack) · 5 chỗ ghi thật, cả 5 `DO NOTHING`; seed-pack chỉ ghi qua `CatalogE2ePackJdbcRepository:73`; `E2eOrderPackJdbcRepository` từ chối bảng · đột biến 3/3 bắt · CẦN QUYẾT: không.
- 14/11 23:05 verifier: ĐẠT, chờ bộ đủ · tự tìm tập chỗ ghi khớp 5/5 · 7/7 xanh · đột biến 2/2 khác của coder bắt · ghi chú ngoài phạm vi: DELETE/TRUNCATE hoặc tên bảng trong ngoặc kép ngoài tầm bộ nạp chưa có ca bắt (mở gói sau).
- 14/11 23:06 ghép: áp patch lên checkout `toandeptrai`, commit `7aeb07edd` (chưa push) + nhật ký tuần `a930e7ee3`; Sheet M3-162 `log` DONE (Hoàn thành, đã đồng bộ). Gỡ `kiem-contract-sua`.
- 15/11 01:54 bộ đủ tầng 3 (`kiem-song` `771667637`, `ci-unit` 34301 ca): lớp này 7/7 xanh; 39 ca đỏ của bộ trùng đúng tên 39 ca đỏ sẵn trên `afb6d404c` → không đỏ mới. `sheet_lead.mjs ghi` M3-162 **Đạt** (`ra-soat/evidence/2026-11-15-song-nkb/ket-qua.json`, đọc lại 1/1).

## Bước kế tiếp chính xác
Xong. Gỡ worktree `contract-sua` lúc dọn cuối sóng.

## Còn lại / CẦN QUYẾT
- Lỗ cũ ngoài tiêu chí (verifier): DELETE/TRUNCATE `sku_master_codes` hoặc tên bảng trong ngoặc kép ở tệp ngoài tầm bộ nạp chưa có ca bắt → task sau.
