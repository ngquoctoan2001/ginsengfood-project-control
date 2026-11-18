Gửi Tài · 16/11/2026 · từ Lead
Việc: sửa 12 task M6 còn Cần sửa sau lượt rà 4 và chuẩn bị đủ cho họp Go/No-go (chậm nhất 20/11).
Vì sao: anh rà 18 task ở `main` `6ee2bedc` lúc 20:38; CI_LOCAL 10/10 (pytest 3700 passed có Postgres 16, smoke 318), build image M6 đạt (uid 10001).
Kết quả và việc còn lại của từng task đã ghi ở cột Lead duyệt / Ghi chú Lead trên Sheet.

**Đạt (6):** M6-015, M6-044, M6-063, M6-134, M6-136, M6-137.

## Cần làm

**1. Đường găng tới Go/No-go (hạn 18/11)**
1. M6-100: viết lại `m6/deploy/BAN_KHAI.md` theo khuôn A–D của hợp đồng triển khai chung (module_id, service_name, runtime, prefix, quan hệ gọi ra/vào, Phần D), bỏ trạng thái ĐỀ XUẤT, ghi DL cho các điểm lệch hợp đồng chung (`:79-86`), sửa `:7`, `:77`, rồi gửi Anh Tuấn.
2. M6-042 / bật JWT trên .98: ký DL-228 (sổ M5) và đóng DL-O09 (người chốt Toàn 16/11); sửa `BAN_KHAI.md:47,77`; Sheet ghi PR #125.
   Trước khi bật trên máy: ghi mã lý do từ chối phía server (`session.py:105-106` đang nuốt lỗi, WT-104); thêm `M6_AUTH_MODE`, `M6_JWT_*` vào mẫu env;
   kiểm token Anh Tuấn cấp có `iat`, exp − iat ≤ 30 ngày, claim vai chứa đủ 6 vai M6 (thiếu `iat` là M6 trả 401 cho mọi người).
3. M6-039: gỡ Bị chặn trên Sheet (anh đã duyệt 05/11, D-m6-007 = DL-101) và làm: `app/` đọc `M6_GLOBAL_GATEWAY_STATE`, `M6_PRODUCTION_FLAG`, `M6_EXTERNAL_SEND`, chỉ nhận BLOCKED/OFF/OFF.
4. M6-125: cập nhật hồ sơ Go/No-go theo số mới (mốc code sau PR #125, trạng thái Sheet sau lượt 4), sửa `:45-46` tự mâu thuẫn, bỏ staging/.63 (`:59`, `:103`), ghi DL-100; nộp anh **trước 19/11**.
5. M6-120: ghi DL chốt nhóm S1–S4 (`smoke_report.py:12`); Sheet ghi PR #119 kèm một lần chạy `smoke_report --groups S1,S2` trên `main`.

**2. Sổ sách theo kịp code (hạn 18/11)**
6. M6-082: TRK-14, TRK-36 → ĐÃ SỬA; TRK-35 → ĐÃ SỬA MỘT PHẦN; WT-103 ghi gộp PR #120; SRS FR-OBX-005/006/008, FR-EGR-002 theo mã mới; Sheet TC-OBX-007 theo thẻ `SPRINT_PLAN:314` (0 audit, DL-092);
   mở task lane E truyền `external_send_permitted` ở `conversions.py:205`.
7. M6-052: ký DL cho TRK-72 (nháp đang ở M4-PLAN) vào DECISION_LOG, đổi TRK-72, sửa thẻ `SPRINT_PLAN:270` và Sheet theo DL.
8. M6-051: cột Kết quả cần đạt trên Sheet "Migration 0019" → 0020.
9. M6-157: chạy `docker compose -f m6/deploy/compose.json --env-file <tệp giả> config`, đính kết quả; sửa tiêu chí "conversions không 503 trên staging" (route chưa gắn);
   mở TRK + task cho lỗi `deploy.py:163-170` (`compose_env` để biến cùng tên trong shell máy lọt vào container).
10. M6-131: chốt commit ứng viên + nghĩa STAGED rồi đồng bộ docs ở commit đó: `SAD.md:65,176,963,1137` bỏ .63, `:288,941` ghi `M6_API_BIND` và `/data/ginsengfood-marketing`;
    `RELEASE_NOTES.md:112` (tag đã có ở `d7fe04e`), `:27`, `:165`; `admin-ui-api.md:68` (.60 → `mkt.`/.98), `:39`, `:369` (DL-O09).
11. M6-024: bảng WORK_TRACKING mục 4 theo DL-102/103 (`:183-189`, `:204`); thẻ M6-025 `SPRINT_PLAN:232` theo D-m6-010; Sheet commit `c028d383`/PR #117.

**3. Anh đã chốt 16/11 21:46 — em ghi mỗi ý một dòng DL vào `m6/docs/00-overview/DECISION_LOG.md`, người chốt Toàn, ngày 16/11/2026**
- M6-042 (D-m6-021): JWT vai vận hành hạn tối đa 30 ngày tính bằng exp − iat; token thiếu `iat` bị từ chối (đúng mã PR #125, `m6/app/auth/jwt.py`).
  Bên phát token (Anh Tuấn) phải ghi `iat`; em báo Anh Tuấn điều này khi xin khoá.
- M6-133 (D-m6-022): duyệt phương án (a): khoá PSID viết hoa, toàn chiều rộng, có khoảng trắng hai đầu (NFKC, bỏ khoảng trắng, casefold) đều là PSID thô,
  từ chối 422 trước mọi lần ghi ở track, conversion, tín hiệu M5; audit chỉ ghi mã. Thay phần PM chốt; dẫn DL từ thẻ `SPRINT_PLAN:233`, WT-074; điền lane/ưu tiên trên Sheet.
- M6-038 (D-m6-023): em chạy bước 1 RUNBOOK 2.2 (dựng Postgres dùng một lần bằng docker, chỉ nghe trên máy dev) **trên máy dev**, không dùng .98, dọn container ngay;
  ghi kết quả vào RUNBOOK 2.2 (`:89`) và WT-044. Không ghi NOT_RUN nữa.
- M6-024 (D-m6-024): bỏ tiêu chí 8 "gửi thư xin soát hồ sơ L1", vì anh đã rà và chốt L1 ngày 05/11 (D-m6-010), tag đã gắn ở `d7fe04e`; sửa dòng tiêu chí 8 ở WORK_TRACKING mục 4 (`:205`) dẫn DL.
- M6-157 / M6-137 / M6-044 (D-m6-025): giữ khoá HMAC kênh server theo nhãn cố định V1–V3 trong compose, đóng TRK-81 phần nhãn; cổng "mỗi khoá gắn một principal"
  giữ ở sổ (thẻ M6-044, TRK-02), viết mã cùng lần gắn route conversions (DL-O10); chưa cấp khoá cho bên gửi nào trước khi có mã đó.

**4. Nhắc thêm (không chặn task)**
- Bom giờ CI: `test_every_mapped_file_exists_or_is_waived` đỏ từ 01/12 nếu M6-055 chưa thêm tệp ADS-P0-016.
- RUNBOOK mục 3 còn "staging .63" (`OPERATIONS_RUNBOOK.md:124-165`): mở task sửa sang .98, `/data/ginsengfood-marketing`.
- M6-134: sổ còn giao tin chi phí cho Mạnh; M9 nay Phúc làm, M9 đang mặc định nguồn `none` (không phải stub). DL-071 còn ghi "chưa gộp".
- DL-O10 (gắn route conversions, Tài + Phúc) còn OPEN: chưa nhận `ORDER_VERIFIED` từ M3 nên ROAS null. DQ chưa có nguồn tín hiệu nên KPI HOLD hết: cần task + người phụ trách.
- Thấp: `machine.py:49-50` comment theo cổng khoá↔principal; M6-136 thêm ca ghim kiểm theo sổ DB; thẻ M6-063 `:286` theo DL-073 (chỉ loại FAIL); WT-021 còn BỊ CHẶN.

Xong khi: 12 task có commit trên `origin/main` (PR gộp merge commit) và Sheet Chờ review kèm bằng chứng; CI_LOCAL N/N trên `main` mới.
Hạn: mục 1–2 trước 18/11, hồ sơ Go/No-go trước 19/11 · báo lại bằng: PR + Sheet, anh rà lượt 5.
