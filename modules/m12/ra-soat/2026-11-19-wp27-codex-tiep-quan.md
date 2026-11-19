# WP27 Việt hoá — tiếp quản và kiểm độc lập Codex 19/11/2026

Trạng thái: **ĐÃ COMMIT CỤC BỘ A/B/C — CHỜ GATE ĐỦ THEO SHA CUỐI**. Task Sheet **M12-116** đang làm. Chưa push/deploy hoặc chạy DB dùng chung.

## Phạm vi và nguồn kiểm

Tiếp phiên Claude `4cc32cce-d423-4897-9969-948bede14083`. Toàn xác nhận dừng cả ba Claude và agent con, yêu cầu tiếp WP27 và phối hợp WP26/WP28. Luật chữ theo D-m12-118/120/122; nguồn yêu cầu là phiếu WP27 và hai bản rà UI/giá trị ô bảng 18/11.

Chụp `main@937cbd989123e938938419d3d01c046dcf49295b` + WIP vào thư mục kiểm thường `C:/Projects/_wt/m12/wp27-codex-1911`, không tạo nhánh/worktree phát triển. Manifest 8.879 tệp, loại tệp môi trường/bí mật/Sheet. Kiểm hash 517 tệp WIP đã nhận; sau khi bổ sung hai tệp test vào B, đối chiếu đủ 519 tệp A/B/C trên main `120b2ea7e`: không có sai lệch hash hoặc trùng danh sách. Bằng chứng này là **local WIP**, không phải CI/exact-SHA phát hành hay staging/production.

Bằng chứng bền vững: [evidence/2026-11-19-codex-wp27](evidence/2026-11-19-codex-wp27/), có `evidence-sha256.json`. Bản chạy gốc: `C:/Users/Administrator/AppData/Local/Temp/codex-tiep-quan-m12-20261119/WP27-evidence/`. Danh sách và hash trước sửa trong `snapshot.json`, `allowlist-*.txt`, `allowlist-*.sha256.json`, `WP27-intake.md` ở thư mục cha.

## Phát hiện và sửa trong lượt Codex

1. **Thiếu coverage thực tế ở bộ lọc SKU**: test cũ chỉ kiểm exported constant, nên đột biến bỏ ACTIVE_BASELINE khỏi Select vẫn xanh. Thêm đúng một tệp `tests/frontend/admin-web/component/src-features/catalog/sku-status-filter-ui.test.tsx`; render trang/Select thật, kiểm đủ lựa chọn, chọn SKU gốc gửi mã ACTIVE_BASELINE, Xóa lọc bỏ mã. Không sửa runtime. Coder xanh1/1; verifier độc lập xanh1/1 → mutant đỏ1/1 đúng thiếu lựa chọn → xanh1/1. SHA256 `2d59ea65524631fdf1bf4ec54c22ca644a26a6ebe3ce50e3c5332dba0e14a895`.
2. **Comment FRM-15 còn sót ở test PWA** làm D2 đỏ: chuyển đúng chủ WP28, họ đổi sang PERSONNEL_ATTENDANCE (commit `1a0641dbc`). Overlay duy nhất vào snapshot được ghi hash `d5775c2711d177bb77ec1840a813fcd07e7a8ef110f0a68266c4ee1ca3084f00`. WP26 chạy D2 lại trên snapshot riêng, đạt1/1; raw TRX trong `wp26-execution/governance-d2-results/`. Không tự nhận root đã rerun toàn bộ Governance.
3. **Log A2 cũ đỏ “Cost center” đã hết trên source cuối**: seed21 đã là “Trung tâm chi phí”; UiRegistry guard chạy mới đạt. Không sửa lại việc Claude đã hoàn thành.

## Kết quả đã chạy mới

| Phần | Kết quả thực tế | Bằng chứng |
|---|---|---|
| Backend build/dependencies A/A2 | Qua API/Unit; không lỗi build trong lane | `backend/unit.log` |
| Unit A/A2 + cảnh báo/kiểm toán/máy in | 478 +47 =525 đạt, 0 skip | `backend/results/`, `unit.log`, `reporting-unit.log` |
| SchemaSmoke lọc | 87 đạt; 1 bị chặn vì snapshot thiếu `.env.example` | `backend/schema-smoke.log` |
| Phần seed của ca MISA bị chặn | 9 forbidden markers đạt; 4 ca MISA khác xanh; không nhận full ca config xanh | `backend/misa-seed-sensitive-markers.json` |
| Governance lọc ban đầu | 36 đạt/1 đỏ D2; đúng lỗi comment PWA nêu trên | `backend/governance.log` |
| D2 sau sửa, WP26 kiểm | 1/1 đạt, 0 skip; binary/base/hash ghi trong tin bàn giao và raw TRX | `../wp26-execution/governance-d2-overlay.log` |
| API contract | 56/56 đạt, 0 skip (51 PublicTrace +5 RawIntake), 20m29s | `backend/results/wp27-api-contract.trx` |
| Integration tên phiếu | 4/4 direct caller đạt, 0 skip | `backend/results/wp27-integration.trx` |
| Frontend B2+C + static guards | 229 tệp, 2366/2366 ca đạt | `frontend/vitest.log` |
| MISA + SKU thực tế bổ sung | 24+1 đạt; tổng 231 tệp/2391 ca khác nhau đạt | `frontend/review.md` |
| Typecheck app/tests | Đạt; tests đã chạy lại sau tệp SKU mới và đạt | `frontend/typecheck-*.log` |
| ESLint 298 tệp B/C | 1 lỗi đã tồn tại ở HEAD (WarehouseReceiptCreateForm.tsx:70, setFormError-before-declare), 82 cảnh báo; không gọi toàn lint xanh | `frontend/eslint.json` |
| Scanner câu UI | REVIEW0/9479; 87 miễn trừ có khai báo | `frontend/language-scan.log/json` |
| Mutations M4/M5/M7 | Cả ba đỏ đúng label/filter mã/CSV thiếu mã | `frontend/` |
| Mutation M9 sau test mới | Đỏ đúng thiếu ACTIVE_BASELINE trên menu thực tế | `frontend/sku-filter-independent-*.log` |
| Mutation seed05 | Audit Log làm guard đỏ1/1; restore hash nguyên, main không đụng | `backend/seed05-mutation.json/log` |
| Migration DB riêng | 156 bản áp dụng thành công | `seed/migration.log` |
| Chuỗi seed đầy đủ | 61×2, validation79/79 | `seed/seed-summary.json` |
| Bộ seed production trên DB local | 42×2, profile53/53 +boundary đạt; không phải kiểm máy production | `seed/seed-summary.json` |
| Manifest/profile | 48/48 hash +sourceSet đúng | `seed/seed-summary.json` |
| Pester E07/DB13 | 30/30 đạt, 0 skip | `seed/pester.xml` |
| Collision guard | Đạt, 0 blocking; giữ các finding baseline (không coi là 0 finding) | `seed/collision.json` |

## Giới hạn dữ liệu và kiểm

- Bộ production: 1799/1799 dấu vân tay cột không đổi sau lần seed thứ hai, đã loại cột timestamp/UUID/date.
- Full-chain: 1798/1799 cột không đổi, chỉ `misa_mapping.mapping_payload` lệch. Seed13/27a không đổi so HEAD; 27a có retiredAt=NOW sau khi seed13 khôi phục fixture. Đây là quy nguyên nhân từ source, chưa giữ cặp normalized payload trước/sau, nên không gọi raw equality toàn DB. Probe normalized đến sau lúc container đã dọn, không chạy được; không lấy probe đó làm bằng chứng đạt.
- Audit seed độc lập: 27 tệp, 22 SQL, 603 literal đổi là nhãn/mô tả/kỳ vọng; SQL skeleton, enum/khóa/điều kiện giữ nguyên. Xem `seed/review.md` và `literal-review.json`.
- B/C có ghi chú UX mức thấp từ đọc source: chọn Mã khác trong bộ lọc rồi Xóa lọc có thể còn ô nhập rỗng do otherMode nội bộ; query đã clear. Chưa chạy tái hiện riêng, không ghi thành lỗi chức năng đã kiểm. Bàn giao WP28 xem khi làm features.
- `.99` cần quyền riêng: seed05c ghi lại 6 config_value/status; seed02 DO NOTHING không cập nhật mô tả vai cũ; seed05a ngoài production; phiếu lịch sử giữ snapshot tên cũ. Không tự chạy lại chuỗi seed trên `.99`.

## Bàn giao commit và phần còn lại

Danh sách không giao nhau: A88/B181/C250 đều READY trong phạm vi kiểm. Đã chuyển allowlist/hash cho WP28; mọi hash khớp main120b2ea7e trước ghép. WP28 giữ index và commit tuần tự A→B→C khi kết luận cuối đủ; WP27 không stage/commit. B giữ catalog/glossary; C giữ ba lib comment do C đã chạm. TopNavigation test thuộc A theo ngoại lệ đã được WP28 xác nhận. Auth/InternalUser/Supplier validator chỉ giữ WIP câu chữ đã có, WP26 xác nhận không đè.

WP28 đã ghép local tuần tự: A `5acb6b121`, B `cdc72cb64`, C `084b0d406`. Root đối chiếu nội dung 519 tệp trong ba commit với manifest/snapshot: khớp, chỉ có khác biệt xuống dòng CRLF/LF được liệt kê riêng; A thêm tệp weekly theo bàn giao WP28, B/C đúng danh sách. Xem `committed-blob-verification.json`. Đã trả toàn bộ features/lib cho WP28. Tiếp theo: điều phối bộ gate đủ một lần theo SHA cuối; đối chiếu nội dung không thay thế test trên commit cuối. Task M12-116 vẫn IN_PROGRESS khi thiếu bằng chứng này.

DB riêng Codex đã được dọn bằng owner container ID. Không dừng DB/progress/container của Claude hoặc chat khác. Hai session Testcontainers API/integration đều tự dọn hết (`backend/cleanup.json`); không dừng process khác. Giữ snapshot nguồn và build artifacts để đối chiếu candidate sau commit, không có test WP27 còn chạy. CPU PID34120 từng ghi trong telemetry không xác minh được ownership, đã vô hiệu attribution; kết luận API dùng TRX/container session.


## 19/11/2026 11:02 — đã áp dụng nhãn seed Việt hóa lên localhost

- Lead duyệt trực tiếp tại chat WP27: áp dụng seed Việt hóa localhost, chưa đụng `.99`. Đích đã kiểm: `ginsengfood-postgres-local`, `localhost:55432`, DB `ginsengfood_operational_local`; nhánh main.
- Áp dụng riêng 535 cặp câu chữ từ 20 seed đã commit WP27, không phát lại toàn chuỗi seed. Một giao dịch đổi 544 ô trên 10 bảng: 87 tên màn, 282 tên thao tác, 129 nhãn trường (31 nhãn dữ liệu nguồn), 3 tên phiếu mẫu, 14 tên bước kiểm tra, 16 mô tả vai, 6 mô tả cấu hình, 2 tên kho, 4 tên vị trí và 1 nhãn menu.
- Chạy thử rồi ROLLBACK: đạt; áp dụng COMMIT: đạt; chạy kiểm lại rồi ROLLBACK: 0 thay đổi. Dấu vân tay của mọi cột ngoài cột nhãn trên 10 bảng giữ nguyên; không còn nhãn cũ trong ánh xạ đã duyệt. Giữ nguyên giá trị cấu hình, quyền, dữ liệu/snapshot phiếu lịch sử; không sửa credential/principal hoặc chạy script triển khai.
- Đã sao lưu DB trực tuyến trước cập nhật: 5572313 byte; SHA256 `af80d28b3cdce98a733e64020ee9805a509d5edb002d2a79743cd3db6e50e818`; pg_dump và pg_restore --list mã thoát 0, chưa thử khôi phục. Bản dump giữ riêng tại thư mục Temp `WP27-local-vietnamese`, không sao chép vào Git/bộ bằng chứng.
- Lệnh: `python .../WP27-local-vietnamese/run.py preflight`, `apply`, `verify`; các lệnh SQL thực hiện qua psql với ON_ERROR_STOP, khóa hữu hạn và kiểm dữ liệu ngoài nhãn ngay trong giao dịch. Bằng chứng bền vững: `modules/m12/ra-soat/evidence/2026-11-19-codex-wp27/local-vietnamese/` (SQL, scope/hash nguồn, kết quả và nhật ký).
- Ví dụ đọc lại DB: SCR-AUDIT-LOG = Nhật ký kiểm toán; SCR-USERS-ROLES = Người dùng & Vai trò; SCR-DASHBOARD = Tổng quan vận hành (bản cũ). Cần tải lại trang localhost:3000 để bỏ cache menu phía trình duyệt; WP28 tiếp tục kiểm giao diện sau seed. Không mở server mới, không còn tiến trình cập nhật của WP27. Không thao tác `.99`. Task M12-116 vẫn Đang làm trong khi chờ kiểm tổng thể giao diện theo SHA cuối.
