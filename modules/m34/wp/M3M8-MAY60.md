# M3M8-MAY60 — máy chạy thử BP .60: đổi CI/registry sang GitHub Actions + GHCR

Trạng thái: ĐẠT, commit `fcb3bcd9e` đã push; .60 chạy m34 từ 05/11 21:54 (M3-090) · Rủi ro: R2 (hạ tầng triển khai, chưa chạm máy thật) · Chế độ: worktree tách rời `C:\Projects\_wt\m34\may-60` (detached `3c9993b36`, 8 mục chưa commit)
· Mốc: B (máy chạy thử trước 10/11) · Sheet: M3-071 (cha), M3-072…100 · Thiết kế: `C:\Projects\_wt\m34\may-60-notes\THIET_KE.md` (bản GitLab) · Tệp nóng: `.github/workflows/`, `SecurityConfig.java`

## Quyết định áp
D-m34-027 (.60 theo khuôn `~/m12`/`~/m8`) · D-m34-031 (m34.44 B: GitHub Actions + GHCR thay GitLab). D-m34-034: m34.45 A (CSDL mới sạch), m34.46 có (phiên chính commit sau R2 ĐẠT), m34.53 A → B (D-m34-038: chưa xin admin, Phúc tự đặt secret khi bật cách B).

## Brief
1. Mục tiêu: thay phần GitLab của gói bằng GitHub: workflow build 2 image `bp-backend`, `bp-frontend` nhãn `${{ github.sha }}` đẩy `ghcr.io/phucapu/…` bằng `GITHUB_TOKEN`
   (`permissions: packages: write`), chạy khi push `dev` + bấm tay; job deploy .60 bấm tay (`workflow_dispatch`, `environment: m34-60`, `concurrency` một lượt) gọi
   `cd-entry.sh` qua SSH với secret khoá CD + known_hosts. Xác minh cách m12/m8 với tới LAN `.61` từ runner (đọc `C:\Projects\ginsengfood-ops-core\.gitlab-ci.yml:1005-1076`,
   `C:\Projects\ginsengfood-ivr\deploy\ci\cd.gitlab-ci.yml`): runner GitHub dùng chung **không** vào được `192.168.1.60` → đề xuất phương án (runner tự cài trên LAN có nhãn,
   hay .60 kéo image theo lệnh tay `trien-khai.sh <sha40>`), làm phương án không cần secret admin làm mặc định, ghi rõ.
2. Tiêu chí: `.gitlab-ci.yml` bỏ; workflow mới qua `actionlint` (nếu có) hoặc kiểm cú pháp YAML; `ci.yml` cũ không đổi; `deploy/m34/{env.mau,trien-khai.sh,cd-entry.sh,README.md}` đổi
   `M34_KHO` sang GHCR, đăng nhập registry bằng token chỉ `read:packages`; `deploy/m34/tests/test_khuon.py` cập nhật bất biến (image chỉ `ghcr.io/…:<sha40>`, không `latest`,
   không build tại máy) và xanh; danh sách secret/quyền GitHub cần Phúc làm (chủ repo) ghi ở `may-60-notes/github.md`.
3. Phạm vi: chỉ `may-60` + `may-60-notes`. 4. Cấm: commit/push, SSH/scp tới máy nào, tạo secret/token, gọi API GitHub ghi; không chạm checkout chính/`u13-retry`/`outbox-dl`.
5. Lệnh: `python -m pytest deploy/m34/tests -q`; `bash -n` cho script; health test BE chỉ chạy lại nếu sửa phần Java (`-Dtest=…`, RAM ≥ 4 GiB).
6. Bằng chứng: `may-60-notes/lan-github.md` (diff tóm tắt, lệnh + kết quả). 7. Dừng khi: thiết kế cần quyền admin repo mà không có phương án thay. 8. Báo về ≤ 20 dòng.

## Diễn biến
- 04/11 23:02 gói GitLab kiểm độc lập R2 lượt 2 ĐẠT (13/13 đột biến, 129 test).
- 05/11 12:4x D-m34-031 → giao coder đổi sang GitHub Actions + GHCR.
- 05/11 12:5x D-m34-034 (45 A, 46 có, 53 A), đã nhắn coder.
- 05/11 13:1x coder xong (`may-60-notes/lan-github.md`): bỏ `.gitlab-ci.yml`, thêm `.github/workflows/m34-images.yml` (kiem-tra-khuon → build-images GHCR `packages: write` → quet trivy → deploy-60 tắt, cần runner LAN `m34-lan`), env/README/script sang GHCR, unittest 133/133, đột biến 19/19, `bash -n` đạt; CHƯA CHẠY actionlint, lượt thật trên GitHub · thêm lọc `paths` ngoài brief · hỏi: workflow chỉ chạy trên `dev`; phút Actions/GHCR tính vào tài khoản Phúc · giao verifier R2
- 05/11 13:5x verifier R2: CẦN SỬA chỉ vì thiếu bằng chứng Maven `*Health*` (RAM < 4 GiB); tiêu chí 1–4, 6 ĐẠT (unittest 133/133, 7/7 đột biến riêng bắt); ghi nhận nhỏ: action chưa ghim SHA, trivy chưa ghim digest, `build-images` bấm tay không giới hạn nhánh · phiên chính chạy Maven Health nền khi RAM ≥ 4 GiB → `may-60-notes/verify-health-maven.txt`
- 05/11 14:0x Maven `*Health*` 601/601 (HealthControllerTest 5/5) → R2 ĐẠT · Lead "54 A" (D-m34-035): thêm `toandeptrai` vào nhánh kích hoạt, `test_khuon` 28/28 · patch từ worktree → `git apply --index` lên `toandeptrai` `c45c64fe7` (tệp gói không khác giữa `c45c64fe7` và `dev`, không ff để giữ lab cho m34.52) · `sheet-sync log` M3-086 Đang làm 50% · commit `fcb3bcd9e` (26 tệp + sổ tuần), chưa push · worktree `may-60` còn giữ (thay đổi đã nằm trong commit), dọn khi bạn đồng ý
- 05/11 13:22 Lead "Push đi" (D-m34-036): `origin/toandeptrai` `c45c64fe7..fcb3bcd9e`; workflow `m34-images` run 41979966081 queued (chưa có kết quả)
- 05/11 13:3x workflow run 41979966081 xong: `kiem-tra-khuon` ✓ 37 s, `build-images` ✓ 8 phút (2 image lên GHCR nhãn `fcb3bcd9e…`), `quet-images` trivy báo HIGH/CRITICAL (undici, vite…; không chặn), `deploy-60` skipped · Phúc hỏi 5 điểm → tin trả lời `ra-soat/2026-11-05-phuc-tra-loi-may-60-tin-nhan-nhap.md` (chưa gửi): cách A không cần secret/admin · Sheet: M3-078/083/089/095 đổi nội dung GitHub, M3-082/086/087 Hoàn thành (đọc lại 7/7)
- 05/11 13:5x Sheet: 15 task repo (M3-072…082, 084…087) W=Đạt/J=Hoàn thành qua `sheet_lead.mjs` (đọc lại 15/15); 088–100 (việc trên .60) Chưa bắt đầu
- 05/11 14:1x M3-088 xong: `~/m34` trên .60 (7 tệp sha256 khớp, `.env` sinh trên máy, compose config đạt); chờ M3-089 (Toàn đăng nhập GHCR) + duyệt M3-090 cắt chuyển
- 05/11 16:4x M3-089: Toàn login GHCR; pull 2 image đạt (BE 679 MB, FE 2,02 GB); bản LAN vẫn chạy 6 container
- 05/11 21:5x M3-090 (D-m34-038): sao lưu `sha256sum -c` OK → 21:52:45 `docker compose -p ginsengfood-lan stop` (không down) → `trien-khai.sh fcb3bcd9e…` thoát 0 lúc 21:54:04 (lần đầu bỏ sao lưu) · Flyway 265 tới V264, 0 hỏng · 6 container m34 healthy · `/nginx-health` ok, ready/live 200, `/` 307 · `PHIEN_BAN` dòng đầu `fcb3bcd9e…` · log BE 0 dòng ERROR · gián đoạn ~80 s · nhật ký máy `~/m34/nhat-ky/cat-chuyen-20261105.log`, `trien-khai-20261105T145300Z-fcb3bcd9.log` · Sheet M3-090 Đạt/Hoàn thành (`sheet_lead.mjs`, đọc lại 1/1) · tiếp: M3-091 admin đầu tiên, M3-092 cron sao lưu
- 06/11 07:3x M3-092: TZ Asia/Ho_Chi_Minh, `sao-luu.sh` tay thoát 0 (3.929 mục), crontab ssv (trước rỗng, giữ `crontab.truoc`) thêm 1 dòng `30 22 * * *`, cron active; khôi phục thử `khoi_phuc_thu` khớp (265/V264/304 bảng) rồi dropdb; lượt cron 22:30 05/11 Đạt · M3-093: health/ready/live 200, `/vi` 200, trang sản phẩm/giỏ/Giờ Vàng/about/admin 200, `/v3/api-docs` + `/actuator/*` 404, API chưa đăng nhập 401; env `be` cờ đối tác/AI/IVR/seed tắt, kill switch bật; LAN chỉ nghe 22 + 80 · Sheet M3-092/093 Đạt (đọc lại 2/2) · ghi nhận `SEED_ADMIN_PASSWORD` trong env container (compose.yml:151 bắt buộc) — lệnh kiểm env lỡ in giá trị trong phiên, không chép đi đâu → đổi mật khẩu sau M3-091
- 06/11 07:4x "Push đi" (D-m34-039): `origin/toandeptrai` đã `7fbdef0c3` từ 05/11 21:48; CI run 42048522587 xanh → image `7fbdef0c3…` trên GHCR; .60 vẫn `fcb3bcd9e`
- 06/11 07:44 triển khai `7fbdef0c3` lên .60 (D-m34-040): `trien-khai.sh` thoát 0 (kéo image, sao lưu `truoc-trien-khai-20261106T004358Z-7fbdef0c.dump` 3.929 mục, đổi container) · Flyway áp 1 migration → V265, 266 dòng 0 hỏng, quyền `ORDER.EDIT` có · ready/live 200, `/vi` 200 · GET `edit-state`, PATCH `/admin/orders/{id}` chưa đăng nhập 401 · log BE 0 ERROR · `PHIEN_BAN` 7fbdef0c3 / fcb3bcd9e
- 07/11 09:07 triển khai bản `dev` `9a4690574` lên .60 (D-m34-043): xoá dòng V265 cũ (đã lưu csv), `trien-khai.sh` thoát 0, Flyway 29 migration mới tới V318 (V307 thay V265), health 200, 0 ERROR; bản trước `7fbdef0c3`. Sửa CI: heap Node 4 GB cho `next build`
