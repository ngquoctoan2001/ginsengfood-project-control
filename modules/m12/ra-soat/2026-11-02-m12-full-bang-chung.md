# Bằng chứng rà 10 task M12 — 02/11/2026

Nguồn mã ops-core: `5eb2c78e8ab894214e941cdc99a9cb72db901422`; business-platform: `d145849d73a0500c0ee9e9693669abc2a74aa6aa`.
Root tương ứng là `C:\Projects\ginsengfood-ops-core` và `C:\Projects\ginsengfood-business-platform`.
Số dòng dưới đây thuộc source đã ghim. Tài liệu ngoài Git được nhận diện bằng đường dẫn, hash và thời điểm đọc.

[Snapshot đầu vào](evidence/2026-11-02-full/sheet-snapshot.json) · [đồng bộ nguồn](evidence/2026-11-02-full/root-evidence.json) · [thay đổi đồng thời](evidence/2026-11-02-full/concurrent-update-and-weekly-probe.json) · [kết luận cuối](evidence/2026-11-02-full/review-verdicts-final.json) · [đọc lại sau ghi Sheet](evidence/2026-11-02-full/sheet-readback.json).

## M12-001 — CẦN SỬA

Bản mới d145 đã có CLI `weekly`/`weekly-list` tại `tools/task-tracker/sheet-sync.mjs:43–44,554–557`, cùng Apps Script 1.4.0. Finding thiếu CLI ở bản 547 đã được thay thế, không dùng để đánh giá bản mới.

Root chạy lệnh chỉ đọc `ping`: ok=true, version=1.4.0. Lệnh chỉ đọc `weekly-list --from 2026-10-26 --to 2026-10-31 --module M12` trả exit 3, ok=false, `WEEKLY_HEADER_MISMATCH`: K1 tab Báo cáo tuần là “Đánh giá của Nguyễn Quốc Toàn”, server yêu cầu “Đánh giá của Lead”. Connector đọc lại xác nhận K1 thực tế.

`tools/task-tracker/apps-script/Code.gs:116,699,803–814` định nghĩa và kiểm header cho đường đọc; đường ghi cũng kiểm ở :638, nhưng phiên này không thử ghi. Hàm normalize tên ở :859–919 chỉ sửa cột người, không đổi K1; chưa đủ bằng chứng quy thay đổi header cho commit này.

Setup và rename gọi `refreshBoards_` (:138–169,195–200). H được tính lại từ J/phụ thuộc (:931–966); H nhập tay không được bảo toàn qua setup. Các cặp H/J ghi trong lượt rà này phù hợp quy tắc đó.

Ping chỉ trả version, chưa gắn được server với build d145; chưa tái xác minh các số 70/70, 39/39 và mutation 24/25 trên Sheet. Cần phiên sở hữu khép schema/header, nhận diện bản triển khai và kiểm lại endpoint. Không chạy setup, đổi header hoặc deploy trong lượt rà.

## M12-002 — ĐẠT PHẠM VI đóng lỗi/chặn 30–31/10

Nguồn E: `C:\Projects\ginsengfood-ops-core\docs\evidence\27-10-14-30-uat-chay-nhanh`.

Auditor đọc đủ 46 ID trong `E\closeout-30-10\entry-46-cases.json`. Kết quả chốt đến hết 31/10: **32 Đạt + 14 Không áp dụng**. Đọc closing records tại `results-2710.jsonl:1462–1485,1528–1548,1557–1564`; đối chiếu workbook `ket-qua-2710.xlsx`: 1.332 Đạt, tab DaNgung có 14. ID và trạng thái khớp journal. Tập 14 khớp catalog tại source ghim; catalog :220666–220667 có 2.290 active/14 retired.

Đã đọc raw của F02-F08-T01/T04, F02-F13-T04, K02-F07-T05, O03-F05-T02 và quan sát UI/API/DB của đủ 32 ca đóng. Nội dung gồm hai.tt ký FRM-19/sinh một FRM-30; F13 kiểm FULL/PRINTER_DEFERRED/QUEUED; K02 kiểm binh.hv không có nút, API 409 và DB không đổi; O03 kiểm quyền trên /admin/system/approvals. Lab dùng 3202/5202 và một số ca 3201/5201.

Một số sidecar F02/M01/M02 vẫn lưu kết quả cũ; closing record mới không khai evidence_file. `RESUME.md:530` ghi bối cảnh này. Workbook dùng kết quả chốt mới trong journal; không khẳng định mọi sidecar đều Đạt.

Không có nghĩa đã chạy đủ 2.304 ca: 958 ca còn lại thuộc M12-009, MISA/enum là việc riêng. Không chạy lại UI hoặc full gates; các số ở RESUME:562 là bằng chứng lịch sử.

## M12-003 — ĐẠT PHẠM VI H04/audit/actor đợt 30–31/10

Workbook có **52/52 H04 Đạt**. Đọc đủ 7 raw JSON H04-F08-T05/T09/T10/T11 và H04-F12-T01/T02/T04; journal đóng ở :1549–1556.

T05/T09/T10/T11 lần lượt trả BATCH_NOT_RELEASED, SALE_LOCK_ACTIVE, RECALL_IMPACT_ACTIVE, INVENTORY_NOT_SELLABLE; trạng thái APPROVED, tồn và ledger không đổi. F12 tạo nháp không ghi tồn, lượng 0 không gửi mutation, bấm đúp chỉ một POST 201/một dòng mới. T11 dùng fixture B2 còn hai lý do chặn; owner nhận tại journal :1556, không chứng minh cô lập activation. QR mark-printed thủ công trên lab không là bằng chứng in vật lý.

F04-T02: `E\h04-30-10\F04-excess-apply-blocked.txt:19,43` có INSUFFICIENT_BALANCE; `F04-T02-excess-created.txt:122,132` có Chờ duyệt/1.001 hộp. Journal :1565 và commit 16299151c đổi kỳ vọng, khớp catalog :126637. Source `ApplyInventoryAdjustmentHandler.Quarantine.cs:16–21` kiểm tồn ở Apply; canonical M11 :74/104 ghi tạo → duyệt → áp dụng.

`h04audit-live-verification.json` có 21 audit mới/10 callsite; `audit-ui-checks.json` có 46 sự kiện. Auditor đã xem `F11-final-actors-visible.jpg`. Actor: mai.ntt tạo/áp dụng, hai.tt duyệt, ha.ntn đọc audit. Source `GetInventoryAdjustmentHandler.cs:47` tra cứu actor theo lô; `WarehouseInventoryMappings.cs:305–315` trả bốn tên hiển thị. Mười callsite giữ idempotency, gồm Apply handler :212,233. Commit 7f08d5f45 có 19 tệp.

Kết luận áp dụng cho hồ sơ đợt cũ, không phải runtime PASS của candidate 5eb2.

## M12-004 — ĐẠT PHẠM VI quy trình báo cáo

Ops-core `tools/task-tracker/bao-cao-tuan/README.md:6–10` đủ ba bước; prompt 1 :24–30,120–128, prompt riêng M12 và prompt 2 có thật. `C:\Projects\bao-cao-tuan\prompt-3-bao-cao-tong-hop.md:59–123` có bố cục và xuất Markdown/DOCX.

Project Control `chung/VAN_BAO_CAO.md:8–14` nối ba prompt, bỏ vòng TRẢ LẠI/tin sửa theo D-lead-005. `modules/m12/nhat-ky/2026-10-31.md:5` ghi Lead đóng lúc 22:45. Không chạy lại test-tracker hoặc so sánh năm repo; đã đọc trực tiếp đầu ra quy trình. Triển khai tracker thuộc M12-001.

## M12-005 — CHƯA ĐỦ BẰNG CHỨNG hosted CI

`tools/ci/historical-jwt-fp-renewal-20261101.json:24–26` gia hạn tới 15/11 16:59Z (23:59 UTC+7). `verify_historical_jwt_source_disposition.py:267–275,310–319` kiểm chuỗi/hash/thời hạn, web pipeline, SHA và Linux; `.gitlab-ci.yml:986` truyền SHA. Quyết định `01-11-08-52-historical-jwt-fp-renewal-to-15-11-decision.md:35–39` giữ UNBOUND_SOURCE_SCAN_ONLY, không chứng minh CI/SAST/DAST.

Đã đọc `C:\Projects\_wt\m12\WP01-bao-cao.md` và `WP01b-bao-cao.md`: 19 job là mô phỏng cục bộ trên 01940f658; 67 đạt/2 skip và 91/91 thuộc giai đoạn f223681db. Còn thiếu hosted CI toàn candidate được chọn, JWT Linux, image/SBOM/ký/DAST theo WP01c.

Chưa truy vấn hosted API trong lượt này; không kết luận pipeline mới đã thất bại.

## M12-006 — CHƯA ĐỦ BẰNG CHỨNG triển khai .61

Đọc artifact gốc `C:\Projects\_wt\m12\kiem-WP05b\.artifacts\pilot-upgrade-rehearsal\20261102-000119Z\pilot-upgrade-rehearsal.json`: :3 PASS/exit 0; :20 candidate sạch `d370852e71c2c68ad89d4afa7b1adc34ed4536cf`; :49 schema 152.

C38 thay đổi 14 rồi 0 (:933,946); m12.8 thay đổi 41 rồi 0 (:1101,1114); cột bất biến giữ nguyên (:1074,1241); reserved 20 → 0/CONSUMED (:1308–1315). Restore fingerprint/schema/migrations/data đều khớp (:1321–1327). Đây là diễn tập trên bản sao, không phải thao tác .61.

Source `SandboxLotRetireCommand.cs:37–105` kiểm DB đích/manifest/binary/candidate/hai actor; `OutboxNoAdapterRemediationPolicy.cs:20–40` giới hạn bốn loại đã đo. TRX lịch sử 977f0c696 có Integration 60/60, Unit 7.578 đạt/1 không chạy; không gộp thành test 5eb2.

D-m12-004 đã duyệt R3/push; D-m12-005 đã duyệt khung tối 03/11. Còn hai tài khoản m12.14, giờ/lệnh, phối hợp và bằng chứng .61. Candidate khác d370 phải diễn tập lại. Tiêu đề task ghi 151 là mốc cũ; kế hoạch hiện hành là 152.

## M12-007 — CẦN SỬA toàn phạm vi

Source `services/operational-api/src/Ginsengfood.Operational.Application/Commands/WarehouseInventory/ReserveExternalInventoryAllocation/ReserveExternalInventoryAllocationHandler.cs:117–163` lấy phân bổ theo source. Nhánh giữ lặp với key mới so phạm vi/lượng nhưng không kiểm RequestedBy, có thể trả phân bổ của principal A cho B. Helper :353–374 và `EfInventoryAllocationRepository.cs:60–103` cũng không lọc principal. Root đã đọc lại nhánh này.

Đây là việc WP07b/SAN_SANG:46 đã để mở; không phủ nhận R3 WP07 đã được duyệt. Cần kiểm ownership và test hai principal.

C37 có ISSUED ở `OpInventoryAllocation.cs:133–145`; test liên kết xuất ở `C37IndependentAcceptanceTests.IssueByAllocation.cs:37–49`. Gitlink contracts `a7832a49f49c430128f5013a6ddce773b138b7df`: allocation schema :21/reserve-line schema :36 chưa có ISSUED; inventory.v1.yaml chưa có operation tự nhả. Không kết luận về bản contracts mới chưa pin.

JSON gốc `.artifacts/m3-acceptance/wp06a-v2-run-2/`: off1/off2 mỗi pha 14 PASS + 3 SKIP, pha on 3 PASS, hợp nhất 17 ca; report gắn API 831c8d37d. Verifier 8b13 báo 17/17 nhưng raw/worktree vòng cuối đã gỡ. Không chuyển thành test 5eb2 hoặc nghiệm thu M3 thật.

Còn WP07b, contracts/pin/parity/M3 review, .61 bản 152, URL webhook/adapter của Phúc và 11 ca thật. W12 giữ tắt.

## M12-008 — ĐẠT PHẠM VI dữ liệu giả đã được duyệt

D-m12-003 tại `modules/m12/QUYET_DINH.md:9` cho phép dữ liệu giả có đánh dấu/lệnh gỡ; WP05b :41 ghi commit 4bc324cd3. Đọc `C:\Projects\_wt\m12\kiem-WP05b-bao-cao.md:13–29,39–61`: DB16 97/97 + 10/10, 348/348 dòng giả bị chặn mặc định, Load idempotent, Remove giữ tham chiếu, 14/14 kiểm an toàn production, 784/784 static và mutation checks.

Source `Invoke-PilotSyntheticData.ps1:74,95` kiểm SYNTHETIC_PASS/Assert-LocalDatabaseTarget; :21 loại seed 47 khỏi production. Runbook WP05 :262–320 ghi chuyển giả → thật; DB test :119,149 kiểm idempotency/tham chiếu.

Phạm vi đã được đổi nên không cần dữ liệu thật để đóng task này. Cutover vẫn cần nhập thật qua UI, gỡ/xử lý dữ liệu giả và REAL PASS; không suy thành production acceptance.

## M12-015 — ĐẠT PHẠM VI nộp báo cáo

Báo cáo tại `C:\Projects\bao-cao-tuan\2026-10-26_2026-10-31\bao-cao-tuan-2026-10-26_2026-10-31-M12-van-hanh-nha-may.md` có 145 dòng, đủ năm mục; nhật ký 31/10 :4 ghi đã nộp lúc 11:20.

Kiểm Git cutoff `01940f6589e04843ef600893c2bc535b895ce3ee`: 140 commit trong kỳ, 27/27 SHA được dẫn tồn tại. Bản `...-M12-van-hanh-nha-may-ra-soat.md:3–6` ghi số lệch và giới hạn; `bao-cao-tong-hop-2026-10-26_2026-10-31.md:64–88` đã dùng phần M12 và nhận xét sửa.

Theo D-m12-002/VAN_BAO_CAO:12–14, nộp xong là hoàn tất phần người báo cáo, không còn vòng trả lại. 01940f658 trên Sheet là commit workflow; báo cáo ngoài Git được ghim hash, không gọi là commit báo cáo.

## M12-016 và nhận diện artifact

[Review sáu tài liệu](2026-11-02-m12-016.md): root kiểm lại sáu hash vẫn khớp. Không chạy lại runtime.

SHA-256 đầy đủ của tài liệu ngoài Git:

| Artifact | SHA-256 |
|---|---|
| Prompt 3 | 200bf61129f4c1b76e574d8a7ab305651221e263267dfcc755ee6d5e4c811b2e |
| Báo cáo M12 | 568446493f498e48fccd03a83947bc629c1e10dcffe2da9e1a6d656b0bc09a65 |
| Bản rà báo cáo | 532f9f67e1f9098a21e0f31a6d336943d2c23c87698170669bee4c8a2b7a2f94 |
| Tổng hợp tuần | f32450a2942ac1cfa63f548a397adff3434158f751c6a6d46c0814b3a99e1f32 |
| UAT workbook | ad0437c0d9628cee673ff914ef14048fbf750bfcd348531e898e1b6c94f95242 |

Các hash sau là **tiền tố**, không phải hash đầy đủ: journal 51b93df9a109bd7e (tệp cập nhật 02/11 14:13:40, chỉ dùng record đến 31/10); entry46 54fb7dc9a6a939b7; audit live 8d6fc139d8898305; audit UI c9638e817f532a89; ảnh actor 695b2f528dbc0800; report WP05b fb308caf21dad992.
