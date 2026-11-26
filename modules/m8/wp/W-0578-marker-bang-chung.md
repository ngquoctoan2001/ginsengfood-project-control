# W-0578 — Thêm dấu `REAL_CUSTOMER_CALL_ALLOWED=NO` vào 17 README bằng chứng còn thiếu (K-04, hồ sơ phát hành 07F)

Trạng thái: CHƯA GIAO (chờ verifier cổng vùng 3 xong: commit mới làm đổi HEAD) · Mức: Thường (chữ trong tài liệu, không mã) · Nguồn: [ho-so-phat-hanh-07F.md](ho-so-phat-hanh-07F.md) §3 "18 dòng thiếu bằng chứng"
Khoá tệp: agent tự khai `m8/W-0578` · Repo `C:\Projects\ginsengfood-ivr`

## Brief
1. Quy tắc chung [giong-doc-quy-tac-agent.md](giong-doc-quy-tac-agent.md) (không commit; không đổi mã/cờ; không ssh).
2. Danh sách: `docs/evidence/W-0500`, `W-0501` … `W-0510` (W-0507 **chưa có** thư mục evidence: bỏ qua, ghi vào báo cáo), `W-0515`, `W-0516`, `W-0517`, `W-0523`, `W-0526`, `W-0535`, `W-0542` (README không có dòng `REAL_CUSTOMER_CALL_ALLOWED=NO`, quy tắc C1 của `docs/release/readiness-board.md`/work-register).
3. Với MỖI gói: (a) tìm các commit của gói (`git log --oneline --all -- docs/evidence/W-05xx` và `git log --grep "W-05xx"`); (b) kiểm bằng `git show <sha> -- . ':!**/sheet.json' ':!**/.env*'` (đọc dòng thêm/xoá) rằng **không commit nào đổi `REAL_CUSTOMER_CALL_ALLOWED`** hay cờ production (`PRODUCTION_ENABLED`, `M5_M7_DISPATCH_MODE`, `GLOBAL_GATEWAY_STATE`) và gói không bật quay số thật; (c) CHỈ khi (b) đạt thì thêm một dòng đầu mục tóm tắt trong README đúng mẫu của gói gần đây (`docs/evidence/W-0563/README.md` dòng 3: `- REAL_CUSTOMER_CALL_ALLOWED=NO (không đổi) …` nối với câu hiện có, không viết lại nội dung); nếu một commit có đổi cờ hoặc không xác minh được: KHÔNG thêm, ghi gói + lý do vào báo cáo.
4. Không thêm chữ khác. Không dùng các chữ 'đường', 'ngõ', 'thôn', 'tổ', 'ấp', 'số nhà' (quét PII). Chạy `sh deploy/ci/scripts/scan-pii.sh docs/evidence/W-05xx` cho từng thư mục đã sửa (phải `PII_SCAN_PASS`). Không sửa `docs/release/*` (phiên chính sinh lại board).
5. Phạm vi ghi: chỉ `docs/evidence/W-0500…0542/README.md` kể trên và `docs/evidence/W-0578/README.md` (≤ 40 dòng: bảng gói → commit đã kiểm → thêm hay không). Báo cáo cuối ≤ 25 dòng.
