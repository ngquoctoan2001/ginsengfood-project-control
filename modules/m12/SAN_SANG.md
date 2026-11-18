# Sẵn sàng — M1–M2 Operational Core

Mốc: 17/11 08:3x (`/ke-hoach`, 4 scout chỉ đọc; ops-core `main` = origin = gitlab = `ac5bc00d4`; `.99` chạy `87acc810`; hợp đồng `origin/m12-noi-m3` = `a57a11f`) ·
% sẵn sàng: **47** (trung bình trọng số; 10/11: 44 — H5, H8, H9 lên 50) · Kịp 15/11: **ĐỎ** (đã qua; nghiệm thu chưa chạy, Production chưa bật) ·
Kịp 30/11: **VÀNG** — đủ mã cho bản tối thiểu, nhưng chưa hạng mục nào ≥ 75: mọi việc trên `.99` (deploy, Production, nối M3, nghiệm thu) còn phía trước
và phụ thuộc lời duyệt từng lần của Toàn, hạ tầng Anh Tuấn, chữ ký người dùng.
Mốc cứng: ngoại lệ JWT hết **30/11 16:59Z**, không gia hạn lần 4 (`tools/ci/historical-jwt-fp-renewal-20261115.json`) ⇒ khoá ký mới phải lên cùng Production.

## Hạng mục lõi (tổng trọng số 100; giữ trọng số từ 31/10)
| Hạng mục | TL | Bậc | Bằng chứng | Lên bậc kế cần |
|---|---|---|---|---|
| H1 Dữ liệu gốc, công thức G1/G2+ | 10 | 50 | CI push #3074445757 `ac5bc00d4` 13/14 (JWT đỏ do thiết kế); verifier R3 `9f0e40b60` Unit 9.041/9.042, Gov 1.103; UAT A 19/50, B 100/311 | lên `.99` + UAT B/A 242 ca (WP-UAT); người thao tác trên máy |
| H2 Lệnh SX, xuất NL, công đoạn, PWA | 15 | 50 | UAT E 267/296 (6 KĐ, 9 BC, 14 chưa), N 0/46; PUI S3 FRM-28/29, S4 A1 đang sửa | WP12g; N + E07 PWA (WP-UAT sóng 4); thiết bị thật ở M12-010 |
| H3 QC, phát hành lô | 10 | 50 | UAT G 57/75 (2 KĐ, 6 BC, 10 chưa) | m12.109 nút "Phê duyệt", PUI FRM-21 422 (WP12g) |
| H4 Đóng gói, QR, nhập bao bì (in tem tại xưởng hoãn) | 10 | 40 | UAT D 261/289, F 113/175 (3 KĐ, 34 KAD, 24 chưa); PUI S2 QA phát hành không bật được truy xuất công khai, S3 GTIN-13 | WP12g (m12.115, GTIN-13) ⇒ 50 |
| H5 Kho, điều chỉnh tồn, C37 | 10 | 50 | UAT H 127/152, I 14/15; luật chú (kho chỉ cộng tồn khi lô kiểm đạt, kế toán đóng phiếu, giá theo vai) có test, chưa lên máy; `ISSUED` trong mã + hợp đồng `a57a11f` | WP-D99 (seed tay), WP-UAT (catalog D01/D03 theo luật chú), C37 thật ở WP22 |
| H6 Truy xuất, thu hồi, trang công khai | 10 | 50 | UAT K 191/200, J 5/33; `trace.` chỉ smoke HTTP 200 | J 28 ca (WP-UAT sóng 2), PUI S2 (WP12g), HTTPS qua proxy `.98` (WP17b) |
| H7 Cầu nối MISA (hoãn, D-m12-002) | 5 | 30 | UAT L 73/73, M 42/42; chỉ `FailClosedMisaProductionAdapter` | hoãn sau 30/11 |
| H8 Kết nối M3 | 10 | 50 | phía M12: CI đủ Integration + ApiContract trên `ac5bc00d4`; WP06a 17/17 cục bộ (`8b13ffb96`); hợp đồng `a57a11f` 10/10, M34 khớp (D-m34-093); chưa lượt gọi thật nào trên `.99` (M3 `OPS_CORE_ENABLED=false`) | WP21 (quan sát), WP22 (giữ hàng thật, webhook, S01–S18) |
| H9 Cổng phát hành, bảo mật | 10 | 50 | WP17 verifier R3 ĐẠT (cứng hoá Production trong mã), CI Linux `.63` xanh 13/13 ở `668b29e0d`, 13/14 ở `ac5bc00d4`; JWT có hạn 30/11 | WP17b: Production + khoá JWT mới + XFF `/32` + HTTPS chạy trên `.99` |
| H10 Triển khai, sao lưu, vận hành, đào tạo | 10 | 40 | `.99` chạy từ 13/11; sao lưu 22:00 + kéo ngoài máy 4 đêm PASS (13–16/11); khoá CD thử đạt 14/11; `deploy-99` chưa xanh lần nào; khôi phục chưa thử; HDSD chưa theo luật chú, chưa buổi tập huấn nào | WP-D99, WP18b, WP-NT |
| **Tổng** | 100 | **47** | | |

Hạng mục mở rộng (không tính %): in tem tại xưởng (hoãn) · MISA thật (hoãn) · quét image/SBOM/DAST trên Linux (D-m12-090: sau 30/11) · app hiện trường ngoại tuyến,
tạo nhà cung cấp trên app, chọn kho (chú ghi "chưa làm") · tài khoản máy M6/M7 · N12 ảnh chụp tồn WMS · migration bỏ enum chết.

## Cổng G1–G8
| Cổng | Trạng thái | Thiếu gì |
|---|---|---|
| G1 Chức năng lõi | chưa | mọi hạng mục < 90; UAT 1.725/2.290 Đạt, còn 521 (468 chưa chạy, 36 BC, 17 KĐ); 12 PUI mở (S2 ×2) |
| G2 Liên module | chưa | 0 ca M12 ↔ M3 trên máy thật; hợp đồng `a57a11f` chưa vào `main` (lead.93), ops-core còn ghim `1e73bc1`; S01–S18 chưa chạy; webhook chưa POST https |
| G3 Bảo mật | chưa | XFF `.99` đã hạ `/32` (.98) + bí mật public-trace đặt 17/11 (D-m12-105); chưa HTTPS (proxy `.98`, router 443 ~18/11); principal M3 trên `.99` còn secret dev (công cụ xoay chưa có); token Sheet còn trong lịch sử, chưa xoay; `PublicTrace__ClientIpProxySecret` rỗng. Mã: xác thực/phân quyền mọi route có test ghim, rate limit có |
| G4 Dữ liệu | một phần | migration 153/154 chưa chạy trên máy; khôi phục từ sao lưu `.99` chưa thử lần nào; Production chạy trên DB hiện tại tới 29/11, đổi DB sạch lúc chạy thật, danh mục nhập sau qua giao diện (D-m12-089/092/093) |
| G5 Triển khai | chưa | `deploy-99` chưa từng chạy; `.99` compose WP16 Development; deploy không chạy seed; deploy contract chưa ghi ngoại lệ M1–M2 (nhiều dịch vụ, cổng 5000) |
| G6 Vận hành | một phần | có mã tương quan, log JSON, `/health`; cảnh báo SEC-18 chưa có kênh; runbook `.99` Production chưa có; cờ tắt khẩn chưa khai trong compose (chỉ tự nhả) |
| G7 Kiểm thử | chưa | pipeline tay #3076718270 (`ac5bc00d4`) đang chạy; UAT 75%; nghiệm thu M12-010 chưa chạy; thử tải chỉ có bản 27/05 ENV_BLOCKED |
| G8 Ngoài code | chưa | 3 chữ ký nghiệm thu, chữ Lan + chú m12.7, HTTPS/router 443, tường lửa M3, dữ liệu danh mục thật, xoay token Sheet (bảng dưới) |

## Gói việc (WP; phiếu `wp/` là nguồn trạng thái)
Đã xong: WP01–WP09, WP12–WP12f, WP13–WP16, WP17 (mã), WP20/20b, CI Linux (`ci-linux-63`, `ci-rut-gon`), gộp nhánh chú lần 1–3 (M12-103/106), WP03a–i/h.
Gộp lại: WP02c/WP11/WP19 → WP11b; WP06/WP07b/NM3 → WP21 + WP22; WP03j/d/e/f → WP-UAT; WP18 → WP18b.

| WP | Mục tiêu · tiêu chí đạt | Phạm vi ghi / tệp nóng | Rủi ro | Phụ thuộc | Mốc | Ước lượng | Trạng thái |
|---|---|---|---|---|---|---|---|
| WP-D99 | Lên `.99` bản `ac5bc00d4` ([phiếu](wp/deploy-99-17-11.md)): đọc trước (phiếu nhập mở, vai, env), `deploy-99`, seed tay 02/06/21/45 + patch 03/11, kiểm vai/giá, báo Lan + kho. Đạt: health ready, migration max `20261115090000`, 5 kiểm vai đúng | `.99` (không sửa repo) | R3 | #3076718270 xanh; Toàn nói rõ deploy + ssh | M-a 17/11 | 0,5 ngày | CHỜ |
| WP21 | M3 bật quan sát trên `.99`: công cụ xoay secret principal dev (N21 chưa có), xuất CSV 19 SKU/kho + `kiem-link` 19/19, kiểm token từ container M3, đo IP nguồn + `M12_SOURCE_ALLOWLIST_2`, theo dõi NM3-30b. Đạt: M3 gọi `availability`/`stock-balances` 200 từ `m34_app`, K5 xanh | `tools/ops/**`, `.99` | R3 | WP-D99; tường lửa `.99` `172.24.2.0/24 → :5000` (phiên lead soạn kịch bản, Toàn gõ sudo, D-lead-058 — m12 gửi dải nguồn + cổng đã đo); m34 nạp link + đổi `.env` | M-b 20/11 (quan sát ≥ 48 giờ từ ≤ 18/11) | 1–1,5 ngày | ĐẠT + đã chạy `.99` 17/11 (M3 v5, M6 v2, CSV link; tường lửa không cần) — chờ m34 bật quan sát (M12-108 Đạt) |
| WP22 | Giữ hàng thật: dời ghim hợp đồng tới `a57a11f` (gitlink + truth matrix 35 chỗ, sau lead.93), bật tự nhả (NM3-43), khoá ký webhook hai phía (NM3-51b/23b, SEC-05) theo thứ tự khoá → đo IP → `allow` → URL, NM3-45b S01–S18 `--profile 99`, cổng NM3-35, ENFORCE; `ReserveExternalInventoryAllocationHandler.cs` 799/800 dòng ⇒ tách helper trước khi thêm (HYG-09) | contracts gitlink, `tests/governance` truth matrix, `tools/integration/m3-acceptance` | R3 | WP21; lead.93; m34 (M3 bản có `0c83bc4a5`, PT26H/27H/26H) | ENFORCE 21–22/11; S01–S18 ≤ 27/11 | 2–3 ngày | CHỜ |
| WP17b | Production trên `.99` (phần b–d), bật trên DB HIỆN TẠI của `.99` (D-m12-093; DB sạch đổi ở WP11b), compose + Caddy Production lên máy, khoá JWT mới (đóng ngoại lệ), XFF `192.168.1.98/32` (trên `.99` đã đặt 17/11, D-m12-105), HTTPS qua proxy `.98` (D-m12-087; tên miền ops./pwa./trace. chạy thật từ 17/11 16:3x, chứng chỉ Sectigo wildcard tới 03/06/2027 — phiên lead), đưa `extra_hosts` + `M12_PUBLIC_TRACE_PROXY_SECRET` bắt buộc vào compose repo (OPS-02/03/07: `.99` đang compose WP16 sửa tay), URL webhook https, tên DB + `daily-backup.py`, khai cờ tắt khẩn trong compose, smoke `kiem-dien-tap-production.sh`. `M12_SOURCE_ALLOWLIST*` (bắt buộc ở compose Production) phải gồm nguồn M3 theo kết quả đo `kiem-m3-goi-m12-99.sh` của phiên lead (DNAT 172.24.2.x hay gateway docker-proxy). API hiện KHÔNG ghi IP nguồn lượt M2M (log request, audit_log) ⇒ đo bằng conntrack/tcpdump (sudo) hoặc thêm RemoteIpAddress vào log request (M3 lấy token v5 ĐẠT 17/11 15:23, correlation `m3-kiem-token-20261117T082331Z`). Build args `.99`: `NEXT_PUBLIC_TRACE_MEDIA_ORIGINS=https://trace.ginsengfood.vn` (D-m12-106; `deploy/m12/build-args.*.json`, cần build lại public-trace) + kiểm URL bằng chứng nằm dưới host đó (media phục vụ tĩnh ở `https://trace.ginsengfood.vn/media/<thư mục>/<tệp>` từ Caddy `.98`, phiên lead đã dựng 17/11, chép bằng `deploy/edge-98/chep-media.sh`; sửa lọc tài liệu theo origin thuộc luồng L7/WP12g đợt sau). **Phải sửa mã trước khi bật** (rà release phía gốc 17/11): OPS-01 P0 kho bằng chứng `COMPANY_SERVER` đòi khớp tuyệt đối với attestation tĩnh ⇒ tải 1 ảnh bằng chứng là lần khởi động sau API chết (`EVIDENCE_LEGACY_PLAINTEXT_INVENTORY_NOT_EXACT`, tự lùi không cứu); SECR-02/OPS-05 P1 cổng JWT chỉ có nhánh gia hạn lần 3 ⇒ từ 30/11 16:59Z job JWT đỏ vĩnh viễn dù đã đổi khoá (build-images/deploy-99 kẹt trong hypercare) + pipeline push không build image (mỗi hotfix cần pipeline tay ~2,5 giờ). Đạt: Production boot, cookie `Secure` qua HTTPS, E-07 PASS, diễn tập lùi | `deploy/m12/**`, runbook cutover Production | R3 | proxy `.98` + chứng chỉ (phiên lead, Toàn); Phúc nhận secret/URL mới | diễn tập 20–21/11, bật M-c ≤ 25/11 | 3–3,5 ngày (gồm sửa OPS-01 + cổng JWT) + cửa sổ 2–3 giờ | phần a XONG (`9716c515d`); b–d CHỜ |
| WP18b | Vận hành `.99`: khôi phục thử bản sao lưu vào Postgres dùng một lần (so số dòng), runbook bật/tắt/sự cố/lùi `.99`, sửa `ci-cd-release-runbook.md:240`, SEC-18 gắn kênh cảnh báo, thử tải WP10 trên lab (p95), ghi ngoại lệ deploy contract (nhờ phiên lead) | `docs/runbooks/release/` (trừ runbook cutover của WP17b), `tools/perf`, `tools/ops/giam-sat*` | R2 | Toàn duyệt ssh; kênh cảnh báo (Toàn/Anh Tuấn chọn) | 19–24/11 | 1–1,5 ngày | CHỜ |
| WP12g | Sửa PUI + sau rà: A1 (D-m12-086, đang kiểm), m12.115 S2, m12.116 S3, m12.109, FRM-21 422, GTIN-13, quyền tải bằng chứng FRM-22, câu báo 409 + khoá ô sau lỗi mạng app hiện trường, validator độ dài field capture, map tranh chấp giá bao bì → 409, test giá bao bì trên phiếu đã chốt; SECR-08 (cùng mẫu A1: màn Xuất vật tư bọc cả khối chỉ đọc "Bút toán sau xuất kho" trong `MATERIAL_ISSUE_EXECUTE`); m12.109 dùng lại 2 hook sẵn `useUploadOperationalEvidenceItem`, `useBatchReleaseReadiness`; `OperationalPermissionCatalog.cs` 796/800 dòng ⇒ tách trước khi thêm (HYG-09) | `services/**`, `apps/**`, `tests/**`; seed 02 chỉ nếu m12.115 cấp quyền (tệp nóng: một WP/sóng) | R2 | m12.109/115/116; chú (A2, lô cũ) | 18–22/11 | 1,5–2 ngày | A1 ĐẠT (M12-107); đợt 1 + 1b ĐẠT `db49269e2` + `565272e01` (bộ đủ sóng 1 xanh); đợt 2 CHỜ (M12-109 65%) |
| WP-UAT | UAT v1 còn 521 ca ([phiếu](wp/M12-UAT-SONG-16-11.md)): dựng lại lab ở SHA ≥ `dbd97af84` (có A1) + sửa catalog luật chú VÀ chạy lại 25 ca đang Đạt theo luật cũ (D01-F03 ×4, D01-F10 ×9, D01-F12 ×7, D03-F14 ×5; cờ `catalog_correction_pending` hiệu lực 11 ca) + ~22 ca mới cho 4 chức năng lần 3 (app quét phiếu, nhập giá bao bì, quản trị không thấy giá, trần 48 giờ); tổng ~558 ca → sóng 1 còn 53 → 2 WP03e 130 → 3 WP03d 211 → 4 WP03f PWA 127 → 5 hồi quy ~57; một làn giao diện | sổ `results-2710.jsonl` (chỉ WP này ghi), `catalog.json`, sổ tay | R2 | lab; Sheet M12-105 | xong M-d 28/11 | ~5–6 ngày làn (đo 16/11: 101 ca/ngày) | ĐANG LÀM (sóng 1: đợt S1-0b dựng lab `671c23fa7` + catalog) |
| WP-NT | Nghiệm thu + đào tạo (M12-010, M12-013): sửa kịch bản/biên bản theo luật chú và `.99` Production, cập nhật HDSD-OPS-01 (kế toán đóng phiếu, giá theo vai, R-PLAN/R-BOD, app quét phiếu), tập huấn, buổi nghiệm thu có thiết bị PWA, 3 chữ ký | `docs/runbooks/release/huong-dan-su-dung/`, `wp/M12-010-*` | R1 + G8 | WP17b; Khánh, chú Dũng, Lan, Sang | buổi sáng 27/11 (D-m12-091) | 1 ngày soạn + buổi | CHỜ |
| WP11b | Chạy thật + hypercare (D-m12-093): 29–30/11 đổi sang DB SẠCH (tên riêng, migrate + seed production, E-07), nhập 2 ca sản xuất, tài khoản thật, principal M3 mới; M3 về quan sát tới khi kho + tồn đầu kỳ thật nhập qua giao diện (D-m12-092), rồi nạp lại link 19 SKU/kho; DB cũ giữ làm bản lưu; yêu cầu của M3 (D-m34-095): giữ nguyên 19 `sku_code` + đơn vị `hộp` (khoá V347; 17/11 M3 đã đổi 18 SKU "suất" → "hộp", D-m34-102; nguồn M12 = trade item BOX ở seed `24_real_box_gtin_seed.sql`, `xuat-link` chặn khi thiếu) để link chỉ đổi UUID, báo giờ đổi DB trước ≥ 1 ngày (M3 tắt giữ hàng + ENFORCE + `OPS_CORE_ENABLED` trước giờ đổi, tránh huỷ đơn chờ IVR), giao CSV `sku_code,ops_core_sku_id,uom_code` + kho mặc định ngay khi có kho, báo nếu secret ký webhook đổi, secret giao bằng tệp; lịch trực, go/no-go 28/11, chạy thật 30/11 | `.99` | R3 | WP17b, WP-NT, m34 (M3 về quan sát) | 28–30/11 | 1 ngày + trực | CHỜ |

Rà release toàn bộ ops-core 17/11 (phiên m12 gốc, chỉ đọc @ `dbd97af84`): [tổng hợp](ra-soat/2026-11-17-release/00-TONG-HOP.md) — P0/P1 phải xong trước 30/11, chia 9 luồng sửa L1–L9 theo nhóm tệp (§5);
quyết định RS-1…10 = D-m12-095…104: WAL/PITR (WP17b/WP18b) · huỷ lệnh công việc có điều kiện, audit tồn bao bì, tên trên phiếu nhập cho R-PLAN/R-BOD, chặn tự gán vai, khoá đăng nhập theo IP + tài khoản, phiên xưởng = 1 ca, host media công khai, PUI I01 (WP12g hoặc luồng L4–L7) · 9 ca in tem KAD (WP-UAT).

## Đường găng tới 30/11 (mốc m12, D-m12-088)
- **M-a 17/11:** #3076718270 xanh → WP-D99 (`deploy-99` + seed tay) → báo Lan/kho luật mới.
- **M-b 20/11:** 18/11 WP21 (xoay secret, link 19 SKU, tường lửa Anh Tuấn) → M3 quan sát ≥ 48 giờ → cổng NK-b 20/11 → ENFORCE 21–22/11 (WP22).
  Trượt tường lửa hay xoay secret quá 18/11 ⇒ ENFORCE trượt từng ngày.
- **M-c 25/11:** 20–21/11 diễn tập WP17b (cần proxy `.98` + chứng chỉ) → 22–25/11 bật Production + khoá JWT mới → chạy lại S17/S01–S18 (WP22) vì M12 khởi động lại lần hai.
- **M-d 28/11:** UAT xong (WP-UAT), WP12g gộp, nghiệm thu M12-010 ký 27–28/11 (WP-NT), go/no-go.
- **29–30/11:** đổi sang DB sạch (WP11b), M3 về quan sát tới khi có kho + tồn thật; **30/11** chạy thật, hypercare; trước 16:59Z ngoại lệ JWT phải đã đóng bằng khoá mới.

## Việc ngoài code
| Việc | Ai gỡ | Cần trước | Trạng thái |
|---|---|---|---|
| Lời `deploy-99` + từng lệnh ssh `.99` (nên duyệt liền một lượt) | Toàn | 17/11 | chờ #3076718270 |
| Tường lửa `.99` `172.24.2.0/24 → :5000` (`gf-tuong-lua`, D-lead-058) | phiên lead soạn, Toàn gõ sudo; m12 gửi dải + cổng đã đo | 18/11 | chưa |
| Router 443 về `.98`, chứng chỉ Mắt Bão, proxy Caddy `.98` (D-lead-057) | Anh Tuấn · Toàn · phiên lead | 20/11 (diễn tập WP17b) | chưa |
| `main` hợp đồng fast-forward tới `a57a11f` (lead.93); số bảo đảm 26 giờ (lead.92) | phiên lead, Toàn duyệt push | 20/11 | chưa |
| Chữ xác nhận gỡ lô sandbox (m12.7) — không cần khi chạy thật trên DB sạch (D-m12-089/092) | Lan, chú Dũng | — | không cần |
| Danh mục thật (NCC, NCC–vật tư, kho/vị trí, tồn đầu kỳ) nhập qua giao diện khi vào vận hành (D-m12-092) | Lan, chú Dũng | khi bắt đầu vận hành | chưa có, không chặn 30/11 |
| Trả lời chú: ai làm phần "chưa làm" (phiếu đưa lô cũ về chờ kiểm, tạo NCC trên app…), cấp app cho Lan | chú Dũng (tin nháp `ra-soat/2026-11-16-tin-chudung.md`) | 20/11 | tin chưa gửi |
| Kênh cảnh báo SEC-18 | Toàn / Anh Tuấn | 24/11 | chưa |
| Xoay token Sheet (còn trong lịch sử git) | Toàn | trước 30/11 | chưa |
| Buổi nghiệm thu M12-010 + tập huấn + 3 chữ ký (Khánh, Toàn, chú Dũng); thiết bị PWA (Sang) | Toàn mời (tin trước 24/11) | sáng 27/11 (D-m12-091) | chưa mời |
| Lịch trực hypercare 28/11–07/12 | Toàn | 27/11 | chưa |

## Kiểm chéo (17/11)
- Hạng mục < 90 đều có WP: H1 WP-UAT, WP-NT · H2 WP12g, WP-UAT, WP-NT · H3 WP12g, WP-UAT · H4 WP12g, WP-UAT · H5 WP-D99, WP-UAT, WP22 · H6 WP12g, WP-UAT, WP17b ·
  H7 hoãn · H8 WP21, WP22 · H9 WP17b · H10 WP-D99, WP18b, WP-NT, WP11b.
- Tệp nóng: seed 02 chỉ WP12g (nếu m12.115 cấp quyền) và không cùng sóng với WP17b; `deploy/m12/**` chỉ WP17b; truth matrix/gitlink chỉ WP22;
  sổ UAT + `catalog.json` chỉ WP-UAT; runbook: WP17b phần cutover Production, WP18b phần vận hành.
- Ước lượng: mã ~9–11 ngày-agent (WP21 1,5 · WP22 2,5 · WP17b 2,5 · WP18b 1,5 · WP12g 2 · WP-NT 1) trên 2 làn mã + 1 làn UAT (~6 ngày) trong 13 ngày lịch: vừa,
  dư ~2 ngày cho vòng CẦN SỬA. Nút thắt không phải mã: lời duyệt `.99` từng lần, tường lửa + router của Anh Tuấn, dữ liệu/chữ ký của Lan, chú Dũng, Khánh.

## Không kịp 30/11 + bản tối thiểu 30/11
- Sau 30/11: MISA, in tem tại xưởng (làm tay) · quét image/SBOM/DAST trên Linux (D-m12-090) · app hiện trường ngoại tuyến, tạo NCC trên app ·
  N12, tài khoản máy M6/M7 · migration bỏ enum chết · phần UAT thiết bị ngoài buổi M12-010.
- Bản tối thiểu 30/11: M1–M2 `ac5bc00d4`+ chạy Production trên `.99` qua HTTPS (proxy `.98`), khoá JWT mới, XFF `/32`; luật chú (kế toán đóng phiếu, giá theo vai,
  giữ hàng 26/48 giờ); M3 kiểm tồn + giữ hàng (ENFORCE; trượt thì quan sát, M3 tự xử khi M2 tắt); sao lưu đêm + đã thử khôi phục; in tem tay, MISA nhập tay;
  nghiệm thu M12-010 có 3 chữ ký.
