# Sẵn sàng — M1–M2 Operational Core

> **13/11 (D-lead-034/035/036, `chung/MAY_CHU.md`):** máy chủ chính thức là **.99** (nhà máy + bán hàng: M1–M2, M3, M4, M9, app M8); `.61` chỉ còn đường lui. Mọi chỗ ghi `.61` bên dưới là lịch sử/bằng chứng đã có hoặc đường lui; việc mới nhắm `.99`. Bậc 75 ("chạy trên máy thật") nay tính trên `.99`.

Mốc: 10/11 10:4x (`/ke-hoach`, 4 scout chỉ đọc; ops-core `main` @ `b89c8f89f` = `origin/main` + 5 commit WP12e chưa push; `.61` vẫn `1cee9b11e-pui022`) ·
% sẵn sàng: **44** (trung bình trọng số, không đổi từ 02/11) · Kịp 15/11: **ĐỎ** — mốc A (WP02c lên `.61`) trễ từ 07/11, mốc B (nối M3) không đạt hôm nay,
việc ngoài code của Anh Tuấn, Phúc, phiên `lead` đều quá hạn; bản tối thiểu (mục cuối) còn kịp nếu WP02c chạy 11/11 và nghiệm thu người thật 12–13/11.
Hạn cuối dự án 30/11 (D-lead-025): phần không kịp 15/11 dời về đó, không bỏ.
Lead chốt 10/11 13:3x (D-m12-050/051/052): đích 15/11 là bản tối thiểu; WP02c 11/11 giữ compose hiện tại; Production bật ở cutover (WP17b); JWT đóng bằng khoá mới lúc cutover.

Vì sao không nâng bậc: WP12d/WP12e/WP16 mới ĐẠT cục bộ, 14 PUI đã sửa chưa kiểm lại trên giao diện, chưa thứ gì chạy trên `.61` (bậc 75 cần `.61`).
UAT (sổ `docs/evidence/27-10-14-30-uat-chay-nhanh/results-2710.jsonl`, 2.535 dòng, dòng cuối mỗi ca, catalog v1 2.290 ca hiệu lực):
**1.643 Đạt · 14 Không đạt · 131 Bị chặn · 34 Không áp dụng · 468 chưa chạy** (10/11 13:xx sau WP03g đợt a+b, 31 dòng 2536–2566; bảng theo nhóm bên dưới chưa tính lại; trước WP03g: 1.619 / 33 / 136 / 34 / 468). Bị chặn theo nguyên nhân (đếm trước WP03g): 42 cần đăng nhập đúng vai, 36 vai + dữ liệu,
49 thiếu fixture (chuỗi đóng gói → FRM-20 → phát hành), 9 thiết bị.

## Hạng mục lõi (tổng trọng số 100)
| Hạng mục | Trọng số | Bậc | Bằng chứng | Lên bậc kế cần |
|---|---|---|---|---|
| H1 Dữ liệu gốc, công thức G1/G2+ | 10 | 50 | unit 7.790 / gov 986 / integration 1.860 @ `2364072ce` + `fc18a053b` (WP12e); UAT A 19/50, B 100/311 (A 31 · B 211 chưa chạy) | WP03d, WP03e, WP02c |
| H2 Lệnh SX, xuất NL, công đoạn, PWA xưởng | 15 | 50 | UAT E 214/296 (1 KĐ, 67 BC, 14 chưa); PWA 164 ca: 127 chưa chạy, nhóm N 0/46 | WP03j, WP03f, M12-010 trên `.61` + thiết bị |
| H3 QC và phát hành lô | 10 | 50 | UAT G 28/75 (6 KĐ, 31 BC, 10 chưa); WP12d ĐẠT `e81a56017` (5 PUI QC/phát hành, chưa kiểm lại UI) | WP03i → WP03g, WP02c |
| H4 Đóng gói, QR, nhập bao bì (in tem tại xưởng **hoãn**) | 10 | 40 | UAT D 261/289, F 107/175 (8 KĐ, 2 BC, 34 KAD, 24 chưa); WP12e 9 PUI UOM/GTIN/QR `2364072ce` chưa kiểm lại UI | WP03g, WP03i |
| H5 Kho, điều chỉnh tồn, C37 | 10 | 40 | UAT H 115/152 (12 KĐ, 12 BC, 13 chưa), I 10/15; WP04c ĐẠT `b164260cb`; `ISSUED` chưa vào contracts (`a7832a4`) | WP03g, WP07b, WP02c |
| H6 Truy xuất, thu hồi, trang công khai | 10 | 50 | UAT K 191/200, J 3/33 (28 chưa); recall integration 6/6; WP16 tên miền ĐẠT cục bộ `11fbf6ba1`, chưa deploy | WP03e (J), WP02c (WP16) |
| H7 Cầu nối MISA (**hoãn**, D-m12-002) | 5 | 30 | UAT L 73/73, M 42/42; chỉ có `FailClosedMisaProductionAdapter` | hoãn tới sau 30/11 |
| H8 Kết nối M3 | 10 | 40 | ops-core 50 mọi chỗ nối (WP06a); M3 `toandeptrai` @ `67f358ed9` chỉ có token + `availability/check`, thiếu `stock-balances`, phân bổ, tự nhả, bên nhận webhook; contracts thiếu `ISSUED`/release | WP06, WP07b + Phúc + phiên `lead` |
| H9 Cổng phát hành, bảo mật | 10 | 40 | 19/19 job cục bộ (WP01); ngoại lệ JWT hết 15/11 16:59Z (`further_renewal_planned=false`); `tools/task-tracker/sheet.json` còn tracked; `deploy/m12/compose.yml:35,51` `Development`, `:75` `Auth__AdminBootstrap__Enabled: "true"`; chưa có pipeline hosted trên SHA mới | WP17, WP01c-a |
| H10 Triển khai, sao lưu, vận hành, đào tạo | 10 | 40 | WP13/14/15/09/16 ĐẠT cục bộ; `.61` đã lên `87acc810d` 11/11 (152, 0 dead-letter, Degraded chỉ do `MISA_SYNC`); tác vụ sao lưu đêm lỗi 64 từ 04/11, ngoài máy chỉ 1 bản `20261103T150002Z`; runbook cutover/hypercare còn mẫu cũ; WP08 chưa ký, chưa tập huấn | WP02c, WP18, WP19, WP11 |

Hạng mục mở rộng (không tính %): in tem tại xưởng (hoãn) · MISA thật (hoãn) · SBOM/ký image/DAST (WP01c-b, 30/11) · thử tải (WP10) ·
tài khoản máy `availability-v1` cho M6 (Tài có client), M7 (chưa có client), M8 dừng · N12 ảnh chụp tồn WMS (chưa có owner, lead.53) · migration bỏ enum chết (owner/DBA).

## Cổng G1–G8 (`chung/CONG_PRODUCTION.md` §3)
| Cổng | Trạng thái | Thiếu gì |
|---|---|---|
| G1 Chức năng lõi | chưa | mọi hạng mục < 90; UAT 468 chưa chạy, 136 Bị chặn, 33 Không đạt; 14 PUI đã sửa chưa kiểm lại trên giao diện |
| G2 Liên module | chưa | M3 thiếu 4 chỗ nối; contracts thiếu `ISSUED`/release, bản local kẹt merge dở; 0/11 ca trên `.61`; M6 cần tài khoản `availability-v1`, M7 chưa client; N12 chưa owner |
| G3 Bảo mật | chưa | `sheet.json` còn tracked, xoay token chưa xác minh; ngoại lệ JWT hết 15/11 16:59Z; compose `.61` chạy `Development` + bật AdminBootstrap; DAST/HTTPS công khai chưa chạy |
| G4 Dữ liệu | một phần | migration 152 + khôi phục đạt trên dump; `.61` chưa 152 (không migration mới sau 152, seed đổi từ WP14); sao lưu đêm hỏng từ 04/11 |
| G5 Triển khai | chưa | `.61` bản cũ; lệch `MODULE_DEPLOY_CONTRACT.md` (m12.18); WP16 chưa deploy (IP nginx /32, m12.78/79) |
| G6 Vận hành | một phần | có `/health`, `X-Correlation-Id`, runbook lùi; `.61` Degraded 55 dead-letter; kênh cảnh báo `BLOCKED_EXTERNAL`; cutover/hypercare còn mẫu cũ |
| G7 Kiểm thử | chưa | chưa pipeline hosted xanh trên SHA mới (runner `ops-core-win`, concurrent=1); thử tải cũ 05/2026; manifest nghiệm thu chưa ký |
| G8 Ngoài code | chưa | Anh Tuấn (runner/OIDC/DNS/cảnh báo) quá 07/11; Phúc (adapter M3) quá 08/11; 3 chữ ký + tập huấn chưa; thiết bị PWA chưa |

## Gói việc (trạng thái theo phiếu `wp/`)
Đã xong, đã trên remote: WP01/01b, WP02/02b, WP03a, WP03b, WP04/04b/04c, WP05/05b, WP06a, WP07, WP08 (giấy tờ; ký/tập huấn ở việc ngoài code), WP09,
WP12, WP12b, WP12c, WP12d (`e81a56017`), WP13, WP14, WP15, WP16 (`11fbf6ba1`, chưa deploy). WP03c: phần A/B ĐẠT ghi sổ, vòng giao diện 216/217 xong
(4 ca I01-F02 → WP03g; 15 điểm CẦN QUYẾT của tester còn mở). WP12e ĐẠT kiểm độc lập (`2364072ce`, `fc18a053b`, hồ sơ `b89c8f89f`), **chưa push** (m12.80).

| WP | Mục tiêu · tiêu chí đạt | Phạm vi ghi / tệp nóng | Rủi ro | Phụ thuộc | Mốc | Ước lượng | Trạng thái |
|---|---|---|---|---|---|---|---|
| WP02c | Lên `.61`: bản 152 + WP12d/e + WP16 (4 tên miền) qua CD `~/m12`, bật webhook, gỡ lô sandbox, tài khoản `availability-v1` M6. Đạt: sao lưu ngoài máy trước khi nâng, 4 cổng + cron + smoke Host xanh, 55 dead-letter xử lý có ghi chép (ACK C38 14 + m12.8 41; đọc component `OUTBOX_QUEUE` + đếm SQL — tổng `/health/ready` luôn DEGRADED vì `MISA_SYNC` UNKNOWN; sự kiện chưa có bộ chuyển ở `FAILED_RETRYABLE` thử lại mỗi 300 giây, thành dead-letter sau 24 giờ) | `.61`; tệp `deploy/m12/*` lấy từ SHA đã commit, không từ checkout đang sửa | R3 | bạn: m12.75 (protect `main`, khoá SSH, `M12_CD_FROM_MAIN`, §10.2) + m12.80 push; IP nginx /32 + m12.78/79; W9b Lan, chú Dũng | A (trễ) → 11/11 | 3–4 g + khung giờ | **ĐÃ LÊN `.61` 11/11 12:33 trừ m12.7** (bản `87acc810d`; 55 dead-letter → 0; `BLOCKED m12.7` chờ xác nhận chữ Lan + chú Dũng; bậc H6/H10 chưa nâng tới khi người thật smoke trên `.61`) |
| WP17 | (D-m12-051: gộp vào `main` sau verifier R3, KHÔNG tự bật Production; bật ở cutover 13–14/11 qua WP17b) Cứng hoá cấu hình chạy thật: `ASPNETCORE_ENVIRONMENT=Production`, tắt AdminBootstrap, cookie `Secure`, tắt `/scalar`; callback Caddyfile production lọt `/` cuối + bẫy IP tĩnh `docker-compose.prod.yml` (ghi chú WP16); `sheet.json` ra khỏi git (giữ tệp local). Đạt: test khoá từng điểm, đột biến đỏ đúng lý do | `deploy/m12/compose.yml`, `deploy/Caddyfile`, `docker-compose.prod.yml`, `.gitignore`, chỉ mục `sheet.json` | R3 | xoay token: bạn (m12.79 cookie `Secure` nay do chính gói này giải: `AdminAuthCookies` bật `Secure` khi không phải Development) | C → 11/11 | 3 g + tester + verifier | **ĐÃ GỘP `main` cục bộ `e3fac2b2b` (10/11 16:2x, chưa push)**, verifier R3 ĐẠT: Caddy smoke 714/714, boot Production thật 26/26, 48/50 đột biến bị bộ tĩnh bắt, bộ cũ xanh; gộp KHÔNG tự bật Production; **Production trên `.61` chưa chạy được** tới khi Lead quyết 6 mục (m12.87) (Sheet M12-026) |
| WP18 | (m12.83: Lead tự chạy lệnh runbook sao lưu mục 4) Sao lưu đêm chạy lại: tác vụ 23:30 gọi đúng `pwsh` + script trong repo (bỏ đường codex/`.artifacts`). Đạt: 2 đêm liền PULLED, sha khớp, giữ 14 bản | lệnh đăng ký + runbook WP15 | R2 | bạn chạy lệnh đăng ký (m12.83) | 10/11 | 1 g | MỚI |
| WP03i | Dựng chuỗi dữ liệu lab: lô đóng gói → FRM-20 → yêu cầu phát hành, mẻ QC_PENDING thứ hai, fixture H05; chạy lại được nhiều lần. Đạt: 49 ca Bị chặn vì fixture có dữ liệu để chạy | script mới trong `tools/uat/`, DB lab 1 | R2 | lab 1 dựng lại @ `b89c8f89f` (xong 10/11) | C | 4–6 g | **ĐẠT vòng 1** (`f7bffe193`, verifier R2); **vòng 2 coder XONG** (`cf2bf4308`: 4 lỗi sửa, FRM-22 có bằng chứng, 2 mẻ QC chờ; node test 28/28); ca Bị chặn nay 121 = A 57 (56 dựng) · B 52 · C 2 · D 10 (Sheet M12-027) |
| WP03g | Kiểm lại trên giao diện 14 PUI đã sửa (5 WP12d + 9 WP12e) + 4 ca I01-F02 (m12.74). Đạt: mỗi PUI `FIXED_VERIFIED_LAB` hoặc mở lại có ảnh | ghi thẳng `results-2710.jsonl` (vòng `WP03g-ui-10/11`; WP03i không ghi sổ) + ảnh; không sửa mã | R2 | lab 2 @ `b89c8f89f` (DB nhân bản từ lab 1, xong 10/11); I01-F02 sau WP03i | C | 5–7 g | **ĐẠT PHẦN CHẠY ĐƯỢC + KIỂM ĐỘC LẬP (đợt a)** 10/11: 13/14 PUI FIXED_VERIFIED_LAB, 1 chưa kiểm được, 4 ca I01-F02 (3 Đạt-giới hạn, 1 Không đạt), 4 PUI mới; WP03h 21/21 khớp; đợt b (lab 2 dựng lại): +6 Đạt, 3 chưa kiểm được (H01-F03) — đợt b CHƯA qua kiểm độc lập; còn thiếu dữ liệu FRM-22 + 2 mẻ QC chờ (WP03i-b) (Sheet M12-028) |
| WP03j | Ca cần đăng nhập đúng vai (42) + vai và dữ liệu (36), tài khoản dev đúng vai (D-m12-021) | sổ phần riêng | R2 | WP03i | C | 8–10 g | MỚI |
| WP03h | Verifier bốc mẫu vòng giao diện WP03c + WP03g. Đạt: ≥ 10% ca mỗi đợt chạy lại độc lập, khớp sổ | chỉ đọc + báo cáo | R2 | WP03g | C | 2–3 g | **ĐẠT** 10/11 12:xx (21/21 ca chạy lại khớp sổ; phiếu `wp/M12-WP03h.md`) |
| WP03d | UAT B dữ liệu gốc (211), như WP03a | sổ phần riêng | R2 | lab | C, có thể tràn 30/11 | ~17 g | SẴN SÀNG |
| WP03e | UAT A, O, D02/D04/D05, J (~127), như WP03a | sổ phần riêng | R2 | lab; J công khai sau WP02c | C/D | ~10,5 g | SẴN SÀNG |
| WP03f | UAT PWA phần trình duyệt (127); thiết bị → M12-010 (m12.17 A) | sổ phần riêng | R2 | lab | C/D | ~14 g | SẴN SÀNG |
| WP06 | 11 ca M3 + webhook trên `.61`: ca M3 có thì chạy thật, thiếu phía M3 ghi Bị chặn kèm tên chỗ nối | `docs/evidence/` | R3 | WP02c, Phúc | B (trễ) → 12/11 | 3 g | CHỜ |
| WP07b | Vòng 5B: dời pin, truth matrix 33, cờ tự nhả, L1–L3, lọc `requested_by` | contracts pin, cờ | R3 | phiên `lead` publish contracts (kẹt merge dở), Phúc review | 30/11 nếu contracts chưa có trước 12/11 | 4–6 g | CHỜ |
| WP01c-a | Pipeline hosted xanh trọn trên SHA lên `.61` + xử lý ngoại lệ JWT theo m12.76 trước 15/11 16:59Z | `.gitlab-ci.yml` nếu cần, hồ sơ ngoại lệ | R2 | m12.80 push, runner `ops-core-win`, m12.76 | C → 13/11 | 3 g + máy | CHỜ |
| WP01c-b | SBOM, ký image, DAST | CI | R2 | runner Linux + OIDC (Anh Tuấn) | 30/11 | 1 ngày | SAU 15/11 |
| WP10 | Thử tải cơ bản (m12.19 A): `tools/perf` trên lab dữ liệu giả, ghi p95 | `tools/perf`, evidence | R1 | lab | C | 3 g | SẴN SÀNG |
| WP12f | Sửa 9 PUI mới từ WP03g/WP03i (FRM-22 không nộp được bằng chứng ưu tiên số 1, thương phẩm trùng 500→409, audit điều kiện bán, nghi thiếu "Gửi duyệt", 5 đề xuất WP03i: lỗi mã sửa, quyền/nghiệp vụ ghi CẦN QUYẾT). Đạt: test đỏ→xanh từng lỗi, governance xanh | `services/**`, `apps/admin-web/**`, `tests/**` | R2 | m12.86 A | C → 12/11 | ~1 ngày | **ĐẠT (verifier R2)** 11/11: commit `b56012e42` cục bộ, vào CD lần 2; 6/26 đột biến sống là lỗ hổng test, không chặn (Sheet M12-029) |
| WP17b | Bật Production ở cutover trên **DB mới sạch dựng từ seed production (P1, m12.90 đề xuất)**: nối dây seed production 2 lượt + `production-staging-boundary.sql` (E-07) vào `~/m12`, tạo principal máy M3/M6 (seed bundle loại `SVC-M3-SELLABLE`, `SVC-M6-ADS-RISK`), sinh attestation kho bằng chứng (hoặc bước riêng, `pwsh` trên `.61`?), runbook lần chạy đầu có người trực, thu 3 cổng web về loopback (m12.78 B1); báo Phúc: khi API đầu tiên chạy `HttpWebhook` các sự kiện outbox chưa quá 24 giờ sẽ được gửi cả loạt sang M3; đưa hai smoke Caddy thật (C03, C05) vào CI hoặc bước diễn tập bắt buộc; diễn tập P1 trên lab (Postgres local) trước 12/11 | `deploy/m12/**`, runbook | R3 | WP17 gộp; Lead trả lời 3 mục (webhook M3, `.env`, vault); Phúc | D → diễn tập 13/11 | 3–4 g + kiểm | phần a coder XONG 10/11 18:xx (`9716c515d` cục bộ, E-07 PASS hai vòng, principal M3/M6 tạo được, 26/26 đột biến; chưa kiểm độc lập, chưa chạy trên `.61`; Sheet M12-030); phần b–d chưa giao |
| WP20 | Vá gate JWT lịch sử cho cả hai nhánh của D-m12-052: nhận bản đóng dứt điểm sau xoay khoá (chính) và bản gia hạn lần 3 đến 30/11 (dự phòng) — `tools/ci/verify_historical_jwt_source_disposition.py`, pin `.gitlab-ci.yml` job `historical-jwt-source-receipt-preview`, `tests/security/test_historical_jwt_source_disposition.py` + `OPS10.ScannerExecution.Tests.ps1`, `SECURITY_EVIDENCE_CONTRACT.md`. Đạt: test đỏ→xanh, job xanh sau 15/11 16:59Z, không backdate | `tools/ci/**`, `.gitlab-ci.yml`, `tests/security/**` | R3 | WP17b (khoá mới), Lead duyệt hồ sơ; nháp `C:\Projects\_wt\m12\jwt-gia-han-30-11-NHAP\` | trước 15/11 16:59Z (mục tiêu 13/11) | 3–4 g + tester + verifier | MỚI |
| WP19 | Runbook cutover + hypercare 14/11 thay mẫu cũ (khung C0–C13 trong `C:\Projects\_wt\m12\WP19-dukien.md`: thứ tự, người, điểm dừng, lùi, go/no-go) + hypercare (lịch trực, cờ tắt khẩn khai trong compose, công cụ kiểm kê D7/D14 chạy được trên `~/m12`) + diễn tập đủ bước 13/11 | `docs/runbooks/` phần cutover/hypercare | R2 | WP02c | D → 13/11 | 3–4 g | MỚI |
| WP11 | Chạy thật: cutover M1–M2 sang `.99` (13/11 22:30–23:00, phiên phụ `m12 phụ`; `.61` = đường lui), gỡ dữ liệu giả, nhập thật, hypercare | `.99` | R3 | nghiệm thu C (M12-010 + 3 chữ ký), WP19 | D 14/11 | 1 ngày | CHỜ |
| NM3 | Nối M12 ↔ M3 (Toàn chịu trách nhiệm hai phía; kế hoạch `docs/integration/module-3/11-11-15-00-ke-hoach-noi-m12-m3.md`): 15/11 M3 kiểm tồn ở chế độ quan sát; giữ/nhả 24/7 qua publish contracts + WP07b + NK-b M3 (cổng 20/11); 48 task Sheet `NM3-*` (M12-032..061 phiên m12, M3-121..139 phiên m34) | ops-core, contracts (worktree `_wt/m12/contracts-noi-m3`), `.61`; phía M3 do phiên m34 | R2/R3 | Anh Tuấn (https + 4 tên miền), Phúc (rà hợp đồng), Toàn (duyệt push/`.60`/`.61`) | A → 15/11; NK-b 27/11 | ≈24 người-ngày | ĐANG LÀM (11/11: NM3-00/02/03/12a/16 xong, 15a ĐẠT R2, 32 + 33 pha A đang chạy) |

Sóng đề xuất (≤ 3 agent nặng, 2 lab: 5200/3200 và 5202/3202):
- Sóng 1 (10–11/11) **ĐÃ GIAO 10/11 10:5x**: L1 WP03i (lab 1) · L2 WP03g (lab 2) · L3 WP17. Phiên chính đã dựng lại 2 lab @ `b89c8f89f` (lab 2 = `lab2.ps1`, DB `ginsengfood_uat2710_lab2`); còn soạn lệnh WP18, chạy WP02c khi bạn gỡ chặn.
- Sóng 2 (11–12/11): L1 WP03j · L2 WP03h → WP03d · L3 WP01c-a → WP10 → WP19. Phiên chính: CD lần 2 mang WP12f (không mang compose Production), WP06, chuẩn bị M12-010.
- Sóng 3 (13/11): phần còn lại WP03d/e/f, diễn tập cutover; 14/11 WP11.

Kiểm chéo (10/11):
- Hạng mục < 90 đều có WP: H1 WP03d/e · H2 WP03j/f + M12-010 · H3 WP03i/g · H4 WP03g · H5 WP03g, WP07b · H6 WP03e, WP02c · H7 hoãn (D-m12-002) ·
  H8 WP06, WP07b · H9 WP17, WP01c · H10 WP02c, WP18, WP19, WP11.
- Tệp nóng: sổ `results-2710.jsonl` mỗi sóng chỉ MỘT WP ghi (sóng 1: WP03g; WP03i chỉ dựng dữ liệu); `deploy/m12/*` chỉ WP17 sửa, WP02c lấy từ SHA đã commit;
  sóng 1–2 không WP nào sửa mã sản phẩm hay `api:sync`/`ApiErrorCodes.cs` (PUI mở lại → gói sửa riêng sóng sau).
- Ước lượng: sóng 1 ~20–24 g agent, sóng 2 ~36–40 g, sóng 3 ~25 g → ~85 g trên 3 làn × 4,5 ngày còn lại: vừa khít, không dư cho vòng 2 CẦN SỬA
  hay giới hạn 5 giờ/tuần (đã dính 05/11). WP03d/e/f coi như có thể tràn sang 30/11. Nút thắt chính vẫn ngoài code: WP02c chờ bạn.

## Đường găng tới mốc A–D
- **A (07/11, trễ 3 ngày) → 11/11:** hôm nay bạn gỡ m12.75, push m12.80, đăng ký lại sao lưu (m12.83) → 11/11 sáng WP02c (SHA `f7bffe193`, compose WP16) → CD lần 2 mang WP12f (WP17 gộp vào `main` nhưng KHÔNG tự bật Production; compose Production chép tay ở WP17b, D-m12-051).
- **B (10/11, trễ) → 12/11:** WP06 trên `.61` với phần M3 đang có (`availability/check`); thiếu phía M3 thì cờ tắt, M3 kéo; WP07b chỉ khi contracts publish trước 12/11.
- **C 12/11 → 13/11:** WP03i → WP03g/WP03j song song trên lab; M12-010 người thật trên `.61` chiều 12/11 (Lan, chú Dũng, Khánh, Sang + thiết bị);
  tập huấn + ký 3 vai 13/11; WP01c-a xanh trước 13/11.
- **D 14/11:** tối 13/11 diễn tập cutover (WP19) → 14/11 WP11 → trước 15/11 16:59Z xong JWT (m12.76).

## Việc ngoài code (phiên `lead` gom về `modules/lead/VIEC_NGOAI.md`)
| Việc | Ai gỡ | Cần trước | Trạng thái |
|---|---|---|---|
| GitLab protect `main` + khoá SSH job CD + biến `M12_CD_FROM_MAIN`; `.61` runbook §10.2 | Toàn | 10/11 | chưa (m12.75) |
| Push 5 commit WP12e lên GitHub + GitLab | Toàn | 10/11 | chưa (m12.80) |
| Đăng ký lại tác vụ sao lưu 23:30 (lỗi 64 từ 04/11) | Toàn | 10/11 | hỏng 6 đêm (m12.83) |
| IP nginx /32 của `.60`; cổng (m12.78), cookie `Secure` (m12.79) | Toàn (hỏi Anh Tuấn nếu cần) | 11/11 | chưa |
| Xác nhận W9b gỡ lô sandbox (D-m12-011) | Lan, chú Dũng | 11/11 | chưa |
| Runner GitLab Linux + OIDC/khoá ký, DNS + chứng chỉ, kênh cảnh báo | Anh Tuấn | 07/11 | quá hạn |
| Adapter giữ hàng / phân bổ / kéo tồn + bên nhận webhook M3 | Phúc | 08/11 | quá hạn (`67f358ed9` chưa có) |
| Contracts: gỡ merge dở local, publish `ISSUED` + release/tự nhả | phiên `lead`, Phúc review | 08/11 | quá hạn |
| N12 ảnh chụp tồn WMS: chọn owner | phiên `lead` (lead.53) | 12/11 | chưa |
| Tài khoản máy `availability-v1` M6 (M7 khi có client) | Toàn, trong WP02c/WP11 | 14/11 | chưa |
| Thiết bị PWA + người thật cho M12-010 (10 ca BC WP03a + ca thiết bị) | Sang (xưởng), Toàn | 12/11 | chưa |
| Tập huấn theo giáo án WP08 | Toàn + Khánh, chú Dũng, Lan, Sang | 13/11 | chưa |
| 3 chữ ký nghiệm thu (D-m12-013) | Khánh (QA Lead), Toàn (Operations Owner), chú Dũng (Product Owner) | 13/11 | chưa ký |
| Xoay token Sheet sau khi `sheet.json` ra khỏi git | Toàn | 14/11 | chưa xác minh |
| Dữ liệu thật thay dữ liệu giả | chủ dự án, lúc cutover | 14/11 | theo D-m12-003 |
| nginx + DNS + chứng chỉ https 4 tên miền + IP /32 (Production bật cookie `Secure` nên thiếu thì không ai đăng nhập; diễn tập 13/11 cũng không chạy) | Anh Tuấn (Toàn chốt) | 12/11 (quá hạn từ 07/11) | chưa |
| Lịch trực hypercare 14–27/11 (D1 = 14/11 T7) + ca xưởng cuối tuần 14–15/11 + SLO uptime/5xx | Toàn lập, mình soạn bảng nháp | 13/11 | chưa có |
| Dữ liệu thật: NCC, NCC–vật tư, tồn đầu kỳ (nhóm 10), nội dung công khai, tên người chủ hàng/phòng mua | Lan, chú Dũng, (chưa có tên) | gửi 11/11 | chưa |
| Principal máy M3/M6 trên DB sạch (`availability-v1`, `SVC-M3-SELLABLE`, `SVC-M6-ADS-RISK`), token M3 mới | Toàn + Phúc + Tài | 14/11 | chưa |
| Diễn tập break-glass admin (B-01) | Toàn | 13/11 | NOT_RUN |

## Không kịp 15/11 + bản tối thiểu chạy được 15/11
- Dời về 30/11 (D-lead-025): MISA, in tem tại xưởng (hoãn) · WP07b + M3 giữ hàng/tự nhả/webhook nếu Phúc và contracts chưa xong (cờ tắt, M3 kéo) ·
  WP01c-b SBOM/ký/DAST · phần UAT B/A/O/PWA tràn khỏi 3 sóng · PWA trên thiết bị ngoài M12-010 · N12 · migration bỏ enum chết.
- Bản tối thiểu 15/11 trên `.99` (từ 13/11 máy chủ chính thức; `.61` đường lui): bản 152 + WP12d/e + WP16 (4 tên miền HTTPS) + WP17 cứng hoá; F1–F5 admin web, QC/phát hành, kho + C37,
  truy xuất/thu hồi nội bộ + trang công khai; M3 chỉ `availability/check`; sao lưu đêm ngoài máy chạy lại; in tem tay, MISA nhập tay;
  nghiệm thu M12-010 có 3 chữ ký.
