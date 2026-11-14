# Tóm tắt diff cho anh Toàn đọc — 4 commit M7 ngày 05/11/2026 (D-m7-058, m7.84)

Repo `ginsengfood-golden-hour-video`, nhánh `main`. Cả 4 commit đã có trên origin (`9c6b15f`), được push ngoài phiên m7.
Mỗi commit: phiên chính commit bằng index tạm; sha diff của commit trùng bản ghép mà verifier đã kiểm.
Các lát thiết kế §2.6 xếp T047, T022, T016 hạng A. Phiếu WP xếp R2, nên mỗi task có một verifier độc lập (không có tester riêng).
Bảng dưới là tóm tắt để đọc sau.

| Commit | Task | Phạm vi | Thay đổi chính | Kiểm độc lập | Còn để sau |
|---|---|---|---|---|---|
| `41196fd` | M7-T047 migration `_L10_StudioRun` | 31 tệp, +10722/−92; Migrations, Persistence, test T047 | 10 bảng lượt Studio, worker, nhà cung cấp, job, tài sản video; 87 CHECK, 65 chỉ mục, 39 khoá ngoại (3 hoãn kiểm); 2 khoá `gh_stored_object` SET NULL NOT VALID; trigger `tg_step_lease_epoch` (GH002), `tg_worker_key_limit` (GH004); 5 adapter hạt giống `DRAFT`, tắt | Verifier R2 ĐẠT lần đầu: Integration 1757 (T047 405); lên, xuống, lên lại giữ dữ liệu 25 bảng cũ; đột biến 16/20 đỏ | `VALIDATE CONSTRAINT` hai khoá ở M7-T078 (m7.81); 6 NÊN SỬA test đã làm ở T052 |
| `73980ce` | M7-T022 engine guard | 32 tệp, +5616/−5; `Domain/ContentGuard`, `GuardCorpus.Tests` | Đọc, kiểm bộ luật `GUARD_RULES`; chuẩn hoá tiếng Việt vi-1 (bỏ dấu giữ vị trí, thẻ số, viết tắt); tách câu, mệnh đề, phủ định theo mệnh đề; câu miễn trừ; bảng chéo 6016 ô | Verifier R2 vòng 6 ĐẠT: GuardCorpus 348 + 3 bỏ qua, Integration 1759, đột biến 80/82 đỏ, chặn nhầm không tăng | Lỗ P0: 352 ô giá viết bằng chữ ("năm trăm đồng") lọt → M7-T024; "kg" hai cách đọc, câu lẫn dấu (X1) → M7-T023 (m7.79, m7.82); 3 ca Skip phải gỡ trước khi bật CI (m7.83) |
| `c17722e` | M7-T009 kho tệp `IFileStore` | 20 tệp, +3572; Storage (Application, Infrastructure), test T009 | Port ghi kèm sha256 mong đợi, đọc có kiểm sha256, đọc theo khoảng byte; adapter `FileSystemFileStore` cho dev, test: khoá không thoát gốc, ghi tạm rồi chuyển nguyên khối, hai lời ghi cùng lúc đúng một thắng; `filesystem` dừng ở staging, production | Verifier R2 vòng 5 ĐẠT: T009 156 ca, Linux không root 156/156, đột biến 33/34 đỏ (hạng B) | Gắn vào host ở M7-T012; S3 ở M7-T175 (m7.80) |
| `9c6b15f` | M7-T016 khung web Next.js | 79 tệp, +13780; `web/` | Next.js 16, client sinh từ OpenAPI (so byte với bản API), `proxy.ts` chặn `returnUrl` xấu, CSP có nonce; khung đọc `/me`, menu theo quyền; 401 về `/dang-nhap`; đăng xuất gỡ khung, xoá bộ đệm; không giữ token | Verifier R2 vòng 2 ĐẠT: Vitest 157/157, `next build`, chạy thử với API giả, đột biến 45/47 đỏ; vòng 1 bắt lỗi thật (bộ đệm dựng lại `/me` sau đăng xuất) | `/me` chỉ cấp `csrf_token` khi HTTPS ở T015; 29 gói npm gián tiếp vào danh sách giấy phép (WP21); e2e ở M7-T019 (m7.85) |

Bằng chứng: `ra-soat/2026-11-04-t047/`, `2026-11-04-t022/`, `2026-11-04-t009/`, `2026-11-04-t016/` (báo cáo verifier, log, đột biến).
