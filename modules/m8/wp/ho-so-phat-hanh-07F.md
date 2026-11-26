# Hồ sơ phát hành M8 (07F / KE_HOACH K-04) — kết quả rà 26/11 (scout chỉ đọc, HEAD `b5c1824a`)

Nguồn: `ginsengfood-ivr` `docs/release/{readiness-board.md, work-register.md, gate-status.yaml}`, `docs/compliance/`, `specs/decisions/`. Số liệu do scout tự parse bảng; chưa chạy `gate-status.mjs`/`acceptance-batches.mjs` (nếu khác thì theo script). Board và yaml KHÔNG sửa tay: sửa `work-register.md` rồi chạy `node deploy/ci/scripts/gate-status.mjs --write` (CI đỏ nếu lệch).

## 1. Số work item (khớp board 25/11)
551 = ACCEPTED 310 · EVIDENCE_SUBMITTED 190 · CANCELLED 24 · BLOCKED_EXTERNAL 20 · DEFERRED_TARGET 3 · N/A 2 · CODE_DONE 1 · TESTS_PASS 1. 54 dòng P-prompt: 46/54 xong (nấc 1 cần 54/54: còn W-0048/49/50/51/56 BLOCKED_EXTERNAL, W-0033/34 DEFERRED_TARGET, W-0037 TESTS_PASS). 10 quyết định mở: OD-V1-01, 02, 03, 05, 06, 07, 08, 09, 10, 16.

## 2. 11 cổng repo `BLOCKED_EXTERNAL`: thiếu gì · ai ký · việc phần mềm làm trước được

| Cổng | Thiếu | Ai ký/cấp | Làm trước |
|---|---|---|---|
| G-CONTRACT | Module 3 đồng ký hợp đồng (draft.50 vẫn DRAFT), CDC, E2E chung; E04/E07/E08/E09 NOT_RUN | Phúc/m34 + Toàn | báo m34 ghim hash draft.50; thay stub 501 bằng thật (W-0565…0570) |
| G-SPEECH | gate CONTENT/PRIVACY_LEGAL theo chế độ; tên khách chờ Privacy (W-0370); lời thoại 3 miền + 455 tên | Chú (lời thoại), Privacy | UI chọn giọng + duyệt cụm (đang làm) |
| G-DIAL | OD-V1-05 mở (M3 ký producer, threat model đường số trực tiếp) | M3 + Toàn + MobiFone | viết threat model ngắn |
| G-AUTH | OD-V1-07 (sandbox/secret thật chưa nghiệm thu; ma trận 401/403/429 chưa đo trên máy thật; custody khoá chưa chốt) | M3 + Toàn | đo 07E trên .99 (Toàn nói), phiếu custody |
| G-POLICY | OD-V1-08/16 cần nạp luật vào .99 + M3 nhận; sổ còn ghi `mock-lab-v3` trong khi .99 chạy `mock-lab-v4` + luật cấu hình được | Toàn + M3 | B-02/B-03; viết lại tiêu chí |
| G-LAB-SIM | báo cáo lab/allowlist/kill switch 1 SIM; thực tế là trunk MobiFone qua .64: chưa cuộc nào từ worker M8 | MobiFone, Toàn (sudo .64), Anh Tuấn | khung bảo trì .64 (H-02/H-04), CDR (W-0572) |
| G-ESIM32 | tiêu chí lịch sử 32 kênh; thiếu số kênh/CPS/cước thật (OD-V1-10) | Toàn đổi tiêu chí; MobiFone | B-05 đo tải (chặn X-01) |
| G-LEGAL | trống chữ ký Privacy/Legal (`docs/compliance/pia.md:35-36`); DF-07, DT-05, legal basis pack đều `LEGAL_SIGNOFF_REQUIRED`; VieNeu `MODELS.lock` PENDING_SEP_SIGNATURE | chú Dũng (cổng TTS từ chối chữ ký của người dựng); "Legal thật" không xác minh được | phần mềm không gỡ được; chỉ cập nhật hồ sơ (X-03) |
| G-RELEASE | thiếu `specs/decisions/DF-03-signoff.md`, P9-1 (W-0050) BLOCKED, mọi cổng trên, người duyệt thứ hai thật (OD-V1-20) | Toàn + người thứ hai (chưa rõ) | viết lại `df03-signoff-input.md`, sinh lại board |
| G-GITLAB | cần Premium/Ultimate + reviewer thứ hai (W-0061); Protected environment hạn 25/11 chưa làm | Toàn | probe đẩy bị từ chối (cần Toàn cho phép) |
| G-PLATFORM | W-0063 đòi K8s 4 môi trường, registry, secret store…; chỗ chạy thật là compose trên .99/.64 (D-m8-011) | Toàn viết lại gate hoặc Anh Tuấn cấp | smoke các điểm cuối .99 hiện có |

## 3. 190 EVIDENCE_SUBMITTED (phân loại bằng từ khoá, không phải kết quả `acceptance-batches.mjs`)
- **18 dòng thiếu bằng chứng** (README không có `REAL_CUSTOMER_CALL_ALLOWED=NO`, quy tắc C1): W-0500…0510 (W-0507 chưa có thư mục evidence), 0515, 0516, 0517, 0523, 0526, 0535, 0542. Sửa là chữ, nhưng CHỈ thêm khi đã kiểm commit của gói không đổi cờ (không ghi sự thật chưa kiểm).
- **80 dòng README đủ, không còn chờ/nợ:** chỉ chờ Toàn đọc rồi chuyển ACCEPTED (A 11, B 43, C 7, D 7, E 7, F 5).
- **92 dòng README đủ nhưng còn "chờ/chưa":** cần Toàn đọc từng dòng (A 19, B 12, C 12, D 1, E 39 — nhắc .99/.64/M3/MobiFone, F 9).
- **F (W-0556, 0558…0562)** ghi CHƯA CHẠY: verifier cổng Nguy hiểm (vùng 1 đã chạy 25/11), bộ đủ, oasdiff, gitleaks, thử .99 — việc chạy, không phải mã mới (K-03).

## 4. Chữ ký/phê duyệt người thật trước go-live (nơi ghi)
Privacy + Legal (`docs/compliance/pia.md:35-36`, trống; Toàn đã ký 07/10 vai khác) · DF-07 retention, DT-05 recording-off, legal basis pack (`LEGAL_SIGNOFF_REQUIRED`) · VieNeu legal + kho artifact (`MODELS.lock:10-11,22-23`); lời thoại 3 miền + 455 tên (Chú; D-m8-160 bỏ khâu chọn giọng, pháp lý vẫn riêng) · M3 đồng ký hợp đồng Target V1/callback/ACK/order version/no-answer (`open-decisions-register.md`, `docs/api-changelog.md:3`) · Auth production (M3 + authority triển khai); policy lên registry đích; MobiFone xác nhận DTMF/disposition/CPS/cước · security disposition (13 HIGH + 3 CRITICAL residual của W-0122); custody khoá production (`wp/custody-khoa-m8.md`, m8.96) · runtime gate hai người (OD-V1-20) · `DF-03-signoff.md` chưa tồn tại · release/go-live/pilot (S-06), OD-V1-12 (lần mở gọi đầu cần phê duyệt riêng); bật `REAL_CUSTOMER_CALL_ALLOWED` Toàn tự quyết cuối cùng.

## 5. Năm mục ít việc nhất (không mục nào đưa board khỏi nấc 0 một mình)
(1) 18 dòng thiếu marker (sau khi kiểm từng gói) → `gate-status --write`; (2) 80 dòng sạch: sinh lại danh sách bằng `collect-acceptance-evidence.mjs` + `acceptance-batches.mjs` trên checkout sạch rồi Toàn đọc (danh sách cũ là bản 26/09); (3) W-0037 TESTS_PASS (soak PT-SOAK-02 PASS) — Toàn quyết ACCEPTED: 47/54; (4) W-0033/W-0034 DEFERRED_TARGET có chủ ý (OD-V1-23 CLOSED) — một quyết định đổi N/A: 49/54; (5) W-0007 đóng cùng lúc nhập OD-V1-08/16; ứng viên thêm W-0285, W-0292, W-0401 (còn giá trị hay không: không xác minh được).

## 6. Sổ lệch (sẽ sửa ở nối 3/K-05)
NEXT_WORK_ID `work-register.md:19` còn W-0564 nhưng W-0564, W-0572 đã commit mà chưa có dòng sổ; số hiệu đã cấp tới W-0574 (W-0571 là sổ cổng, không có mã) ⇒ NEXT_WORK_ID đúng = W-0575 sau nối 3 · `modules/m8/TRANG_THAI.md` "Số W" lệch · `KE_HOACH.md`/`SAN_SANG.md` còn "161 EVIDENCE_SUBMITTED/522" (board: 190/551) · tệp cũ so với board: `acceptance-batches.md` (26/09), `df03-signoff-input.md`, `gd3-acceptance-review-pack.md`, `release-compliance-checklist.md` (05/10), `pia.md` (07/10), `open-decisions-register.md` (10/10; OD-V1-02 "chờ consumer" dù E02 đạt từ 13/11) · `readiness-board.md:79` mô tả K8s/Premium trong khi đích là compose .99/.64 · thiếu 12 số trong W-0001…0563.
