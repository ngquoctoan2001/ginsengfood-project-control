# Duyệt R3 trước khi đẩy `main` — UI quản trị M5 (M5-137 + M5-138, D-m5-024)

09/11/2026. Nhánh ghép `m5/M5-137-ghep-ui-quan-tri` (worktree `C:\Projects\_wt\m5\ghep-ui`), HEAD `da306af`, nằm thẳng trên `origin/main` `465bc76`
→ đẩy là fast-forward, không merge commit, không force. Chưa đẩy gì.

## Đổi gì (10 commit, 128 tệp, +19.660 / −50)

| Phần | Nội dung |
|---|---|
| API (M5-137) | 17 route GET mới `/api/admin/*` (EP-20…36): tổng quan, tư thế khởi động + cờ (chỉ đọc), app Meta, Page, phiên live, webhook thô/chuẩn hoá, cách ly, hàng gửi, hàng gửi lại + dead-letter, guard log, bằng chứng, CSKH (chuyển người, cảnh báo, tạm dừng), yêu cầu xoá dữ liệu, audit. Tệp mới `src/admin/admin-console.{controller,service}.ts`, `admin-egress.ts` (che dữ liệu), `admin-query.ts` (tham số + cursor). |
| Quyền | Thêm `ADMIN_CONFIG_READ`, `ADMIN_AUDIT_READ` cho OPS + ADMIN; SERVICE không có. Giữ nguyên `SUPPRESSION_LIST_SET` của Tài (#79). |
| Kho | Port + adapter memory/Prisma chỉ thêm hàm liệt kê **tuỳ chọn** (keyset); hành vi cũ không đổi. Không migration, không biến môi trường mới, không gói npm mới ở gốc. |
| UI (M5-138) | `web/` Next.js 16.4.5 + React 19.3.1 (cùng M7), xuất tĩnh; Nest phục vụ ở `/admin` cùng container (`src/admin-ui/admin-ui.ts`, `bootstrap.ts` +2 dòng). 9 màn + đăng nhập. Chỉ đọc, trừ form đăng ký Page/live có sẵn (ghi bộ nhớ tiến trình, hộp xác nhận "Không gọi Meta"). Không nút bật cờ, gửi tin, subscribe. |
| Dựng | `Dockerfile` thêm stage `web`, runtime chép `web/out`; `.dockerignore` `**/.env*`; `package.json` thêm script `build:web`. |
| Tài liệu | Hợp đồng `docs/05-reference/admin-ui-api.md`, hướng dẫn `admin-ui.md`, `api-catalog.md`, `reason-codes.md` (mục 1.20), `docs/README.md` 1.19, TRACEABILITY sinh lại. |

## Che dữ liệu ở đầu ra (phần R3)

Không trả PSID/ASID, `psidHash`, mã CH21, `cust_ref`, token, `secret_ref`, `appScopedUserId`, thân webhook thô; Page id thành `page_ref:`+băm.
Chuỗi tự do qua `maskString`; trường mã có dãy ≥ 10 chữ số bị che rồi trả 200; payload bằng chứng còn sót → 500 `ADMIN_RESPONSE_REFUSED`
(thân chỉ `{statusCode, reasonCode}`, log không ghi giá trị). Mọi phản hồi route mới có `Cache-Control: no-store`, kể cả 401/403.

## Bằng chứng

| Kiểm | Kết quả |
|---|---|
| Tester độc lập (viết từ hợp đồng, không đọc mã) | 641 ca: đỏ đúng ở mốc trống (621 FAIL), xanh 641/641 trên mã |
| Verifier M5-137 (2 vòng) | Vòng 1 CẦN SỬA (lộ `cust_ref` băm; mẫu miễn quét lọt dãy 10–12 số; 401/403 thiếu no-store) → vòng 2 **ĐẠT**: DB tạm 22/0/0, đột biến 8/8 đỏ (+ m1c phiên chính tự chạy: đỏ) |
| Verifier M5-138 (2 vòng) | Vòng 1 CẦN SỬA (test bỏ sót thẻ đầu 4 màn, chưa test token chỉ ở sessionStorage) → vòng 2 **ĐẠT**: đột biến 8/8 đỏ; phục vụ tĩnh 56/56, 16 đường thoát thư mục 404 |
| Nhánh ghép — typecheck ×2, web | sạch; web lint 0, vitest 87/87, build 81 tệp không dữ liệu mẫu |
| CI_LOCAL `--only build,probes,docs` | build PASS · probes **174 PASS / 26 SKIP / 0 FAIL** (200) · docs PASS (TRACE_OK), cây sạch, HEAD `da306af` |
| Thay job `db` (máy không có pg_ctl/redis-server) | Postgres 16 + Redis 7.4 Docker tạm, `migrate deploy`, toàn bộ probe `M5_PROBE_DB=on`: **200 PASS / 0 SKIP / 0 FAIL** |
| Thay job `docker` | `docker build` thật PASS; chạy ảnh `HOST=127.0.0.1` + DB rỗng: healthy, `PrismaClient connected`, `ADMIN_UI_ON`; `/health` `/health/ready` 200; `/admin/` + 9 trang 200 HTML (CSP, nosniff, no-store); `/api/admin/overview` 403 no-store; 3 đường thoát thư mục 404 |

CI_LOCAL ghi `3/5 GATE=KHÔNG ĐẠT` vì `--only` (db, docker NOT_RUN theo thiết kế script); hai job đó thay bằng hai dòng trên.

## Bạn cần biết trước khi duyệt

- Đăng nhập trên .60 (`RBAC_MODE=real`) cần JWT do Anh Tuấn cấp (cùng khoá đang chặn M5-016). Chưa có khoá thì UI chỉ dùng được ở máy dev (`localhost`, chế độ dev).
- Ảnh chạy ngoài loopback vẫn bị tư thế sẵn có chặn khi thiếu pepper và bộ kiểm chữ ký thật (`STARTUP_POSTURE_REFUSED`): đúng thiết kế, không do gói này.
- `reason-codes.md` đầu tệp vẫn ghi phiên bản `1.18` như `main` (PM đánh số khi gộp); mục M5-137 là `1.20` sau mục 1.19 của M5-081A.
- Đẩy bằng `git push origin m5/M5-137-ghep-ui-quan-tri:main` (máy sẽ hỏi bạn). `main` đổi trước lúc đẩy thì ghép lại và chạy lại phần đổi.
