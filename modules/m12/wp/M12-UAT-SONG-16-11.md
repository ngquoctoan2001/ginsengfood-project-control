# M12 — UAT v1 phần còn lại, chia sóng (16/11)

Trạng thái: **SÓNG 0 ĐANG LÀM** · Rủi ro: R2 (chạy ca, ghi sổ) · Lệnh: Toàn 16/11 "xem lại bảng uat hơn 2k3 case, chia wave và làm tiếp nhé"
Sổ: `docs/evidence/27-10-14-30-uat-chay-nhanh/results-2710.jsonl` (2.576 dòng, dòng cuối mỗi ca thắng) · catalog v1 `tools/uat/function-catalog/catalog.json`
(2.304 ca, 14 ca ngừng ⇒ **2.290 ca hiệu lực**). Catalog v2 (2.395 ca, 15/10) chưa dùng, không tương ứng 1-1, giữ nguyên.

## Số liệu 16/11 (tính lại từ sổ, không lấy số cũ)

| Trạng thái | Ca |
|---|---|
| Đạt | 1.643 |
| Không áp dụng | 44 |
| Không đạt | 14 |
| Bị chặn | 121 |
| Chưa chạy | 468 |
| **Còn phải làm** | **603** |

Lab cũ dựng ở `b89c8f89f` (10/11); `main` nay `668b29e0d` (+98 commit: WP12f, nhánh chú Dũng: giá phiếu nhập R-PLAN/R-ACC-INT, nhả đúng phần chờ QC, vai R-PLAN/R-BOD, seed 02/06/21/45; JWT; CI)
⇒ mọi sóng chạy trên lab dựng lại ở SHA mới; ca kỳ vọng đổi theo luật chú phải sửa catalog trước khi chạy.

## Chia sóng

| Sóng | Gói | Ca | P0 | Ước lượng sổ tay | Nội dung | Chỗ chạy |
|---|---|---|---|---|---|---|
| 0 | chuẩn bị | — | — | 3–4 g | dựng lại lab 1 + lab 2 tại `668b29e0d`, chạy lại fixture `tools/uat/lab-fixtures` (sửa theo luật chú nếu vỡ), rà lệch catalog ↔ code mới | lab 1/2 + đọc mã |
| 1 | WP03j | 135 | 126 | ~14 g | 121 Bị chặn (E02 26, E04 24, G02 22, E08 9, C02 8, G01 8, E06 7, C06 6…) + chạy lại 14 Không đạt (C05 MRP ×5, F03-F02 ×4, F01 GTIN13, I01 audit, G01/G02 lệch sổ tay, E01 hàng đợi in hoãn) | lab 1, giao diện, đăng nhập đúng vai (D-m12-021) |
| 2 | WP03e | 130 | 89 | ~11 g | A (31 đăng nhập/phiên/điều hướng/sẵn sàng phát hành/cảnh báo), O (54 người dùng/tắt màn/phê duyệt/kiểm toán/thiết bị/tài khoản dịch vụ), H01–H05 (8), D02/D04/D05 (13), J01 (14), J03 trang công khai (10) | lab, giao diện admin + công khai |
| 3 | WP03d | 211 | 163 | ~17 g | B dữ liệu gốc: đơn vị, kho, cấu hình, ngưỡng, NCC, nguyên liệu, vùng xuất xứ (58), SKU (37), công thức (37) | lab, giao diện admin |
| 4 | WP03f | 127 | 109 | ~14 g | PWA phần trình duyệt: D06, E07, F05, G03, H07, J04, K03, N01 (16), N07 (30); phần cần máy quét/camera thật → M12-010 trên `.99` | lab PWA |
| 5 | hồi quy | ~60 | — | 4–5 g | chạy lại mẫu ca Đạt (P0 Chính trước) của chức năng bị 98 commit đụng | lab |

Thứ tự: 0 → 1 → 2 → 3 → 4 → 5. Một làn giao diện một lúc (cookie `127.0.0.1` chung mọi cổng, một trình duyệt); làn thứ hai chỉ làm việc không
giao diện (fixture, lệch catalog, verifier bốc mẫu ≥ 10% mỗi sóng như WP03h). Sổ jsonl mỗi lúc chỉ MỘT làn ghi. Tối đa 2 agent.
Ca Bị chặn "cần đăng nhập vai" gỡ bằng D-m12-021 (mật khẩu dev từ seed/fixture repo, chỉ lab `127.0.0.1`, không ghi vào sổ/tin).

## Cần bạn quyết (khi tới sóng 1)
- **m12.108** G01-F03-T02, G02-F01-T02 (lệch sổ tay ↔ giao diện, mở từ 04/11): A sửa sổ tay theo giao diện (giao diện đang đúng luật) · B sửa giao diện theo sổ tay.
  Đề xuất A. Chưa trả lời khi tới lượt 2 ca này ⇒ làm theo A, ghi rõ trong sổ.
- **m12.109** G02-F02 (5 ca Bị chặn, đợt 1b): nút "Phê duyệt" yêu cầu phát hành không bao giờ bật — máy chủ đòi FRM-21 đã xác nhận + bằng chứng
  ACCEPTED, mà ký đủ FRM-21 (Trưởng ngày + QA phát hành) thì lô TỰ phát hành; màn FRM-21 không có chỗ tải bằng chứng. A sửa sổ tay "duyệt = ký FRM-21"
  (gộp với G02-F05) + mở PUI đường nộp bằng chứng FRM-21 và nút "Phê duyệt" chết · B sửa sản phẩm cho nút "Phê duyệt" chạy riêng. Đề xuất A
  (phát hành bằng giao diện vẫn làm được qua ký FRM-21). Chưa trả lời khi sửa sổ tay đợt sau ⇒ làm theo A.
- E01-F06-T01 hàng đợi in: đã chốt D-m12-006 (m12.24 A: Không đạt S2, hoãn cùng in tem) ⇒ giữ nguyên, không chạy lại.

## Lệch catalog ↔ code mới (scout, `C:\Projects\_wt\m12\UAT-S0-catalog-drift.md`)
- 38 ca mở cần sửa catalog (B08 21, B09 5, D04 3, O07 3, D06 2, D02 2, G01 1, G02 1; 5 sai hẳn) + 15 ca B08/B09 đổi theo mã SKU thử;
  18 ca đang Đạt có catalog sai/thiếu (D01 15, D02 3). Hồi quy đề xuất 57 ca (D01 16, D02 6, G01 5, E03 4…) = sóng 5.
- Nặng nhất: mã SKU thử `UAT_SKU_1010` không còn hợp lệ (SKU-M12-05 `e1329ed2a`: chữ hoa, số, `/`) ⇒ B08-F02-T01/T04 hỏng, 26 ca nhắc mã;
  D01 đổi thứ tự (chấp nhận dòng cần lô QC_PASS, giá chỉ R-ACC-INT/R-PLAN, đóng phiếu thiếu giá 409, tồn vào phần chờ kiểm tới khi QC đạt);
  O07-F06-T93 đếm hợp đồng ngoài 86 → 88. Lab cần seed 02/06/21/45 + migration 154 `20261115090000`.
- Không đạt: C05 ×5 (`7eb51cb9c`), I01-F02-T05 (`b56012e42`) đã sửa mã ⇒ chạy lại ở sóng 1; F03-F02 ×4 chạy lại bằng thao.pt; F01-F03-T02 GTIN-13 vẫn mở;
  H01-F03 (Bị chặn): quyền tải bằng chứng FRM-22 cho R-WH-FG chưa cấp.
- ⇒ Làn 2 (không giao diện) trong lúc sóng 1 chạy: sửa catalog 38 + 18 ca (nguồn `catalog.json`, sinh lại md/xlsx theo README) trước sóng 2/3/5.

## Diễn biến
- 16/11 13:5x phiên chính tính lại sổ (603 ca còn), chia sóng; lab tắt từ 14/11 (container `ginsengfood-postgres-local` Exited); giao sóng 0: coder dựng lab + fixture, scout rà lệch catalog.
- 16/11 14:37 scout lệch catalog XONG: 38 ca mở + 18 ca Đạt cần sửa catalog, hồi quy 57 ca; mã SKU thử `UAT_SKU_1010` hết hợp lệ; D01 đổi thứ tự theo luật chú. Coder sóng 0 (lab) còn chạy, đang sửa fixture nhập nguyên liệu thêm bước nhập giá.
- 16/11 15:12 coder sửa catalog XONG (chưa commit): 80 ca + 29 chức năng, mã SKU thử mới `UAT1010/CS`, sinh lại md/xlsx `10-10-15-38-so-tay-…`; verify_outputs PASS, Governance 1062+41; 35 khối lệch có sẵn (catalog sửa 30/10–04/11 chưa sinh lại) phiên chính GIỮ vì nguồn duy nhất. Báo cáo `C:\Projects\_wt\m12\UAT-catalog-fix-bao-cao.md`. Giao verifier R2. Ghi nhận: seed 45 chưa có tài khoản R-PLAN; S4 ô Tồn vật lý hiện số khả dụng; `roles_allowed` 17→19 vai chưa sửa.
- 16/11 15:25 SÓNG 0 XONG: lab 1 (5200/3200) + lab 2 (5202/3202) ở `668b29e0d`, migration 152→154, seed 02/06/21/45 + vá vai (19 vai), fixture v3 50/50 mẻ (`90-verify` exit 0), sổ không đổi; script giá theo luật chú commit `8f811fff0` (cục bộ). Phiên chính giữ cách chỉ áp 4 seed đổi (không chạy trọn clean-ops) để không mất fixture. Sóng 1 chia 3 đợt (gói `C:\Projects\_wt\m12\uat-song1\dot-*.tsv`): 1a lệnh SX 58 (E01/E02/E04/E06) · 1b QC/phát hành/kho 42 (G01/G02/F03/H01/H05/J02) · 1c MRP/PWA E08/I01 33; bỏ E01-F06-T01 (D-m12-006), F01-F03-T02 (PUI còn mở). Giao tester đợt 1a (lab 1, trình duyệt app).
- 16/11 15:26 verifier catalog CẦN SỬA nhỏ: D04-F05 tên mục màn cũ ('Tổng theo UOM', 'Breakdown kho / vị trí' → 'Tổng theo đơn vị tính', 'Tồn theo kho / vị trí'); 4 ca Đạt D01 (F05-T07, F12-T04/T05/T07) thiếu điều kiện lô QC đạt + người nhập giá; B08-F02-T02 tên trường `Request.SkuCode`. Phần khác ĐẠT (80 ca khớp, regex .NET thật, verify_outputs PASS, md khớp byte). verify_outputs chỉ bắt 2/5 đột biến ⇒ thêm kiểm so byte md ↔ bản sinh. Gửi lại coder catalog sửa.
- 16/11 15:34 verifier lượt 2 ĐẠT ⇒ commit `0450bb813` (sổ tay 81 ca); Sheet M12-105. Còn nhãn cũ ở H02-F01-T01 (sửa ở sóng 2).
- 16/11 15:57 ĐỢT 1a: 43/58 ca có dòng (sổ 2577–2619, sha1 sau `69276fce…`): **40 Đạt · 1 Không đạt · 2 Bị chặn**; 15 ca chưa chạy (hết ngữ cảnh). PUI mới `PUI-1611-E02-WO-ASSIGN-SELF-REPEAT` S4 (nút 'Gán tôi' bấm lại vẫn ghi audit, cả trên lệnh đã huỷ). Bị chặn E02-F05-T01/T04: thiếu lệnh công việc đã cấp NL chưa bắt đầu ⇒ coder fixture v3c. Quan sát chưa mở PUI: sự kiện công đoạn đẩy WO ON_HOLD/lô BLOCKED không có audit chuyển trạng thái riêng (nghi S3); huỷ WO để mẻ CREATED, lệnh cha vẫn IN_PROGRESS. Sổ + bằng chứng ở `docs/evidence/` (gitignored, chỉ trên máy). Chia lại: 1b = 15 ca 1a còn + G01 8 + G02 22 (45, ĐANG CHẠY) · 1c = F03/H01/H05/J02 12 + MRP/E08/I01 33 (45).
- 16/11 16:09 fixture v3c (WO đã cấp NL chưa bắt đầu) commit `df3e7e0b1`; E02-F05-T01/T04 vào đợt 1c (nay 47 ca).
- 16/11 16:32 ĐỢT 1b: 30/45 ca (sổ 2620–2649, sha1 sau `920bf939…`): **22 Đạt · 2 Không đạt · 6 Bị chặn**; G01 8/8, G02 22/22; E04/E06 15 chưa tới lượt. m12.108 chạy theo A (G01-F03-T02, G02-F01-T02 Đạt + `catalog_correction_pending`; cùng dạng G02-F03-T02, G02-F02-T02). PUI mới `PUI-1611-G01-FRM20-REASON-SAVED-CONCLUSION` S4, `PUI-1611-G02-FRM21-NONE-422` S3 (lập FRM-21 cho mẻ chưa có yêu cầu: 422, hộp thoại hứa tự tạo yêu cầu). Bị chặn G02-F02 ×5: nút 'Phê duyệt' không bao giờ bật (máy chủ đòi FRM-21 đã xác nhận + bằng chứng ACCEPTED; ký FRM-21 tự phát hành; màn FRM-21 không có chỗ tải bằng chứng) ⇒ **m12.109**; G02-F04-T07 chờ K02-F03-T08. Chia lại: 1d = E04/E06 15 + E02-F05 2 + F03/H01/H05/J02 12 (29, ĐANG CHẠY) · 1e = C02–C06 23 + E08 9 + I01 1 (33).
- 16/11 16:37 ĐỢT 1d CHẶN, 0 ca: 16:31:28 Windows có lệnh tắt máy/đăng xuất (Winsrv 10001: UltraViewer phản đối tắt máy; Winlogon 4004: đăng xuất không xong) ⇒ Docker Desktop bị kết thúc (0x40010004), container `ginsengfood-postgres-local` tắt; API 5200 /health/ready 503, đăng nhập 500. Sổ không đổi (2.649, `920bf939…`). Không tự bật lại Docker — hỏi Toàn (có thể Toàn đang tắt máy).
- 16/11 18:45 lab tắt hẳn: m34 bật lại Docker 18:0x, don_may m34 dừng API/web lab 18:5x; container Exited. Bật lại cần: `docker start ginsengfood-postgres-local` → `lab.ps1`/`lab2.ps1` api-start + web-start (worktree `_wt/m12/uat-WP03c` @ `668b29e0d`) → `90-verify --only-stages` → giao đợt 1d.
- 16/11 21:5x ĐỢT 1d (lab bật lại theo D-m12-084: `docker start ginsengfood-postgres-local`, lab 1/2 `all-start` ở `668b29e0d`, dữ liệu/fixture giữ nguyên, 4 cổng 200): 28/29 ca có dòng (sổ 2650–2677, sha1 sau `78fd8f90…`): **20 Đạt · 6 Không đạt · 2 Bị chặn**; bỏ H05-F04-T02 (giữ hàng ngoài, luật 48 giờ mới, dòng 2464 còn hiệu lực). PUI mới: `PUI-1611-F03-QAREL-PUBLIC-TRACE-LOCKED` **S2** (R-QA-REL không bật được truy xuất công khai: Sổ QR 403 danh sách thương phẩm ⇒ nút mờ; F03-F02-T01/T05 KĐ, T04 BC), `PUI-1611-E04-FRM28-29-EVENT-NOT-CARRIED` S3 (phiếu Cấp đông/Sấy thăng hoa không lấy số từ sự kiện, giờ lệch vẫn ký được; E04-F04/F05/F09-T01), `PUI-1611-E04-AUDITOR-NO-PROGRESS-VIEW` S4 (R-AUDITOR 403 chọn lệnh công việc). H01-F03-T05 BC do tester bấm đơn chữ ký kế toán kho trên FRM-22 (fixture frm22-evidence đã dùng hết). Sửa sổ tay: H01-F03 (xác nhận nhập kho = chữ ký kế toán kho FRM-22; fixture 6 hộp), E06-F02-T01, E06-F01-T02. Báo cáo `C:\Projects\_wt\m12\UAT-S1-1d-bao-cao.md`. Lab giữ chạy (PID API 27980/23916, web 28224/26632).
- Tổng sau 1d (tính lại từ sổ, 2.290 ca hiệu lực): **1.725 Đạt · 44 KAD · 17 KĐ · 36 BC · 468 chưa chạy ⇒ còn 521**.

## Sóng 1 phiên vận hành (17/11, Toàn "Chạy sóng 1") — đợt S1-0b: dựng lại lab + catalog luật chú lần 3
Trạng thái đợt: ĐANG LÀM · Rủi ro R2 · Chế độ S (catalog trên checkout chung; lab ở worktree tách) · Base `671c23fa7` (có A1) · Sheet M12-105
Brief (coder, KHÔNG chạy ca giao diện — tester làm đợt sau):
1. Lab: worktree `C:\Projects\_wt\m12\uat-WP03c` (detached `668b29e0d`) → `git -C <wt> restore apps/admin-web/next-env.d.ts apps/admin-web/tsconfig.json`,
   `git -C <wt> checkout --detach 671c23fa7` (không nhánh). Bật `ginsengfood-postgres-local` nếu Exited (`docker start`, không rm/recreate). DB lab
   `ginsengfood_uat2710_lab` + DB lab 2 đang ở migration 154 ⇒ không có migration mới; áp lại seed đổi ở nhánh chú lần 3 (02, 06, 21, 45; xem
   `git diff 668b29e0d 671c23fa7 --stat -- db/seeds`) vào CẢ HAI DB lab theo cách sóng 0 (`C:\Projects\_wt\m12\UAT-S0-bao-cao.md` mục 3: chỉ áp seed
   đổi, KHÔNG chạy trọn clean-ops, KHÔNG reset DB), mỗi tệp `psql -1 -v ON_ERROR_STOP=1`. Bật lab 1 (5200/3200) + lab 2 (5202/3202) bằng
   `docs/evidence/27-10-14-30-uat-chay-nhanh/lab.ps1` / `lab2.ps1 -Action all-start` (ArtifactsName/DistDir MỚI, ví dụ `S1b-1711`); `90-verify-preconditions`
   cho các stage còn dùng; fixture đổi (`pkgstock`/`rawstock`) chạy lại stage nào cần (không xoá dữ liệu cũ). 4 cổng 200. Cấm 5100/3000. Lab để chạy.
2. Catalog (`tools/uat/function-catalog/catalog.json`, sinh lại md/xlsx sổ tay theo README): sửa kỳ vọng 25 ca đang Đạt theo luật cũ (D01-F03 ×4,
   D01-F10 ×9, D01-F12 ×7, D03-F14 ×5) + 11 ca cờ `catalog_correction_pending` còn hiệu lực + H01-F03 (xác nhận nhập kho = chữ ký kế toán kho FRM-22,
   fixture 6 hộp), E06-F02-T01, E06-F01-T02, E04-F01-T01 (vai kiểm toán theo A1: ô lệnh công việc khoá, thấy tiến trình); thêm ~22 ca mới cho 4 chức
   năng lần 3 (app quét phiếu nhập NL, nhập giá bao bì đúng/sai vai, quản trị không thấy giá, trần giữ hàng 48 giờ qua API); 9 ca in tem F05-F04/F05
   = KAD (D-m12-103). Nguồn: `C:\Projects\Project Control\modules\m12\ra-soat\2026-11-17-release\10-kiem-thu-uat-tai-lieu.md` (QA-01/02/06),
   `ra-soat\2026-11-16-chudung-m12-lan3.md` mục "Ca UAT", `docs/decisions/16-11-21-19-*`. Không ghi sổ `results-2710.jsonl`.
3. Phạm vi ghi: `tools/uat/**`, `docs/runbooks/release/10-10-15-38-so-tay-chuc-nang-va-kiem-thu-ui-toan-he-thong-runbook.{md,xlsx}`, worktree lab,
   `docs/evidence/27-10-14-30-uat-chay-nhanh/` (log lab, RESUME thêm mục). CẤM: `services/**`, `apps/**` (ở checkout chính), `db/**`, `tools/ops/**`.
4. Kiểm nhanh: verify_outputs của catalog (README), Governance đủ project một lần cuối (`--artifacts-path .artifacts/dotnet/WP-UAT`), `node --test
   "tools/uat/lab-fixtures/test/*.test.mjs"`, 4 cổng lab 200, 90-verify exit 0. Không bộ đủ.
5. Bằng chứng: số ca sửa/thêm theo nhóm, danh sách ID ca cần chạy lại (cho tester), PID 4 tiến trình lab, lệnh + số. Đầu ra ≤ 25 dòng (LUAT_SUBAGENT §10).
- 17/11 10:4x giao coder đợt S1-0b.
- 17/11 11:3x đợt S1-0b coder ĐẠT (lab `671c23fa7`, seed 02, fixture v3d; catalog 47 sửa + 22 mới, 2.326 ca) · commit `bfcb981e5` · verifier catalog R2 ở `kiem-UAT-S1b`; tester chạy `dot-1f.tsv` (82 ca) sau verifier.
- 17/11 12:0x verifier catalog vòng 2 ĐẠT (`2d1915650`) · tester đợt 1f-a (41 ca, `uat-song1/dot-1f-a.tsv`) trên lab `671c23fa7`; đợt 1f-b (42 ca D01/D03, `dot-1f-b.tsv`) sau khi lab có WP12g 1b.
- 17/11 12:4x ĐỢT 1f-a (41 ca, lab `671c23fa7`): sổ 2704–2744 (sha1 sau `ae293ae2…`): **14 Đạt · 0 KĐ · 27 BC** (9 E08 app xưởng 3201 chưa bật; O07-F06-T99/T100/T101 + C02-F03-T01 cần worker/chờ/API riêng; C05-F02-T07…T12 sổ tay lệch thiết kế; 8 thiếu dữ liệu). PUI mới: `PUI-1711-I01-SELLABLE-RECALL-CONTRADICT` S3 (Có thể bán khi có lô thu hồi — chờ chú xác nhận), `PUI-1711-C02-PIR-STATUS-RAW` S4. I01-F02-T05 nay Đạt (PUI I01 đóng). Tổng (2.312 ca hiệu lực): **1.713 Đạt · 44 KAD · 10 KĐ · 60 BC · 485 chưa chạy ⇒ còn 555**. Kế tiếp: lab dựng lại ở SHA sau WP12g 1b CÓ app xưởng 3201 + worker hết hạn bật ⇒ 1f-b (42 D01/D03) + 9 E08 + 4 ca môi trường; sửa sổ tay C05-F02-T07…T12, C03-F05-T02.
- 17/11 13:2x Lab S1-0c ở `565272e01` (app xưởng 3201, worker nhả giữ hàng, trần 30/60 phút lab 1); sổ tay C05/C03 sửa `5122823d0`; tester đợt 1g (`dot-1g.tsv` 53 ca).
- 17/11 14:0x ĐỢT 1g (lab `565272e01`): 36/53 ca có dòng (sổ 2745–2780, sha1 sau `4e713ae9…`): **24 Đạt · 0 KĐ · 12 BC**, 17 chưa chạy (D01-F03 ×4, D01-F12 ×7, D03-F14 ×5 cần phiếu đã tiếp nhận + lô QC đạt + FRM-09/10; E08-F04-T05). Đạt: D01-F15 T01/T02/T05/T06/T08 (app quét phiếu chạy đúng, gửi lại cùng khoá ra đúng phiếu cũ), D01-F10 T01/T04–T10 (kế toán đóng phiếu), D01-F14-T03, D03-F18-T01, D03-F17-T03, E08 ×8. BC: 9 ca cần bước 'IT gửi POST' (công cụ chặn ghi API dựng tay), D01-F10-T02 thiếu fixture, O07-F06-T99/T100 cần khoá thử SVC-M3-SELLABLE trên lab. PUI mới: `PUI-1711-D01-CLOSE-NOTE-OVERWRITE` S3 (đóng phiếu ghi đè ghi chú ⇒ mất số phiếu giao của phiếu quét), `PUI-1711-D03-PKG-TAXRATE-UNMASKED` S4 (thuế suất bao bì không che). Ảnh trắng do khung trình duyệt ẩn.
- Tổng sau 1g (2.312 ca hiệu lực): **1.737 Đạt · 44 KAD · 10 KĐ · 53 BC · 468 chưa chạy ⇒ còn 531**. Kế tiếp: dùng `cutover-principal-m3.sh xoay` (WP21) trên lab 1 cấp khoá thử cho O07; phiên chính chạy 9 bước 'IT gửi POST' trên lab localhost; fixture D01-F10-T02/D01-F03/F12/D03-F14; sổ tay D01-F15-T08 (nút Nhập giá sau Tiếp nhận).
- 17/11 14:4x bộ kiểm đủ sóng 1 (gồm catalog verify_outputs PASS, lab-fixtures 46/46) XANH. don_may dừng web/PWA/lab 2 (mồ côi) — bật lại khi chạy đợt kế (17 ca 1g + 9 bước IT POST + O07 với khoá thử bằng `xoay` trên lab).
