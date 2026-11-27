# Sẵn sàng — M1–M2 Operational Core

Mốc: 27/11 19:3x (`/ke-hoach`, 4 scout chỉ đọc; ops-core `main` = origin = gitlab = `4bb29f8df`; `.99` chạy `d4163331c` **Development** từ 26/11 09:16
theo sổ, chưa xác minh lại; hợp đồng `origin/main` = gitlink = `a57a11f`) · % sẵn sàng: **48** (17/11: 47 — H4 40 → 50) ·
Kịp 30/11: **VÀNG nghiêng ĐỎ** — mã đủ cho bản tối thiểu (UAT lab 2.253 Đạt, 0 Không đạt), nhưng chưa hạng mục nào ≥ 75: `.99` chưa Production,
0 mẻ / 0 tồn / 0 thao tác người thật, biên bản nghiệm thu 27/11 trống cả 11 dòng, chưa buổi tập huấn nào. Còn 3 ngày, mọi bước phụ thuộc người.
Mốc cứng: ngoại lệ JWT hết **30/11 16:59Z (23:59 giờ VN)**, không gia hạn ⇒ khoá ký mới lên cùng Production (P2).

## Hạng mục lõi (tổng trọng số 100; giữ trọng số từ 31/10)
| Hạng mục | TL | Bậc | Bằng chứng | Lên bậc kế cần |
|---|---|---|---|---|
| H1 Dữ liệu gốc, công thức G1/G2+ | 10 | 50 | UAT lab A 50/50, B 311/311; test lọc `d4163331c`: Unit 10.766, Governance 1.130 (`nhat-ky/2026-11-26.md:4`) | người thật nhập NCC, kho/vị trí, ca, công thức trên `.99` (WP-ME) |
| H2 Lệnh SX, xuất NL, công đoạn, app xưởng | 15 | 50 | UAT E 297/298, N 45/46; Vitest PWA 1.455, admin 5.661 (`932b727bb`) | mẻ thật trên `.99` qua điện thoại Sang (WP-ME); N07-F02-T01 cần camera |
| H3 QC, phát hành mẻ | 10 | 50 | UAT G 75/75; D-m12-135 giữ đường FRM-21 → phê duyệt | QC + phát hành mẻ thật (biên bản dòng 6) |
| H4 Đóng gói, QR, nhập bao bì (in tem tại xưởng hoãn) | 10 | 50 | UAT D 306/306, F 132 + 43 KAD (in tem, D-m12-002/103); GTIN-13 `2508575d7` | đóng gói/QR mẻ thật |
| H5 Kho, điều chỉnh tồn, C37 | 10 | 50 | UAT H 142 + 10 KAD, I 15/15; luật chú (kho cộng tồn khi QC đạt, giá theo vai) có test; `.99` 15:21: 0 phiếu nhập TP, 19/19 SKU chưa tồn | FRM-22 + tồn bán được thật (biên bản dòng 7) |
| H6 Truy xuất, thu hồi, trang công khai | 10 | 50 | UAT J 29/33 (4 BC thiết bị), K 200/200; `trace.` HTTPS 200 | quét QR bằng điện thoại thật, cài PWA (dòng 8, 5 ca thiết bị) |
| H7 Cầu nối MISA (hoãn, D-m12-002) | 5 | 30 | UAT L 73/73, M 42/42 (lab); chỉ `FailClosedMisaProductionAdapter` | hoãn sau 30/11 |
| H8 Kết nối M3 | 10 | 50 | `.99`: principal SVC-M3 ACTIVE, M3 lấy token + gọi `availability` 627 lượt/24h đều 200, danh mục SKU 19/19, chế độ quan sát bật (các chỗ này đạt 75 riêng); bộ M3 cục bộ 25/25; S01–S18 0/18 trên `.99`; mọi câu trả lời "không bán được" vì 0 tồn ([hồ sơ](ra-soat/2026-11-27-noi-m3-thuc-hien.md)) | S02/S03 khi có tồn (WP-ME); NK-b giữ/nhả thật + ENFORCE sau 30/11 |
| H9 Cổng phát hành, bảo mật | 10 | 50 | gói Production qua verifier lượt 3 "ĐẠT có điều kiện", bộ bash 725/0/1, cổng Nguy hiểm 7 vùng ĐẠT ([tổng hợp](ra-soat/2026-11-25-cong-nguy-hiem-tong-hop-cho-toan.md)); HTTPS + XFF `/32` chạy `.99` | P0–P7 + P7 kiểm tay đạt (WP17b) |
| H10 Triển khai, sao lưu, vận hành, đào tạo | 10 | 40 | nhiều lượt lên `.99` có sao lưu trước (gần nhất 26/11 PASS); sao lưu đêm + kéo ngoài máy 14 đêm liền PASS (13–26/11); khôi phục thử bản 24/11 khớp số dòng (Sheet M12-019); chưa giám sát ngoài M3, chưa tập huấn, chưa người trực | WP-HYP, WP-NT |
| **Tổng** | 100 | **48** | | |

Hạng mục mở rộng (không tính %): in tem tại xưởng, MISA thật (hoãn) · quét image/SBOM/DAST (D-m12-090) · app ngoại tuyến, tạo NCC trên app ·
tài khoản máy M6 (có, client M6 đang tắt) / M7 (chưa có) · migration bỏ enum chết · WAL/PITR (D-m12-095, chưa làm).

## Cổng G1–G8
| Cổng | Trạng thái | Thiếu gì |
|---|---|---|
| G1 Chức năng lõi | chưa | H1–H6 ở 50; UAT lab 2.253 Đạt / 5 Bị chặn (đều thiết bị) / 68 KAD trên 2.326 ca — chạy ở lab, chỉ 457 ca ghi SHA `d4163331c`; chưa ca nào người thật chạy trên `.99`; không có sóng hồi quy UAT sau WP30–33 |
| G2 Liên module | một phần | M3 quan sát chạy `.99` (đúng quyết định D-m12-054/093/136/140); S01–S18 0/18 trên `.99`; NK-b NO-GO tạm; webhook M12 → M3 chưa POST lần nào, bên nhận M3 đang tắt; M3 ghim hợp đồng cũ `a3b4bbf84` (M3-131); M6/M7/M8/M9 không chặn 30/11 |
| G3 Bảo mật | một phần | HTTPS 443 qua `.98` (Sectigo tới 03/06/2027), XFF `/32`; khoá JWT mới chỉ sinh ở P2 (chưa chạy); hồ sơ đóng ngoại lệ JWT (`tools/ci/historical-jwt-rotation-20261201.json` + quyết định đóng) chưa có ⇒ job quét CI đỏ sau 30/11 16:59Z (deploy không qua CI); allowlist `/v1` chưa đặt; token Sheet còn trong lịch sử (SEC-11 sau 30/11); 3 nợ S3 cổng Nguy hiểm (seed gỡ quyền không xoay `token_version` ⇒ quyền cũ sống ≤ 12 giờ; khoá hộp thư 24 giờ do người lạ; tệp `*.uploading` làm quét khởi động báo bẩn); 1 ảnh `avt.png` bản rõ trong kho bằng chứng (P0 25/11 HỎNG) |
| G4 Dữ liệu | một phần | DB `ginsengfood_ops_production` sạch từ 20/11, 160 migration, candidate → HEAD 0 tệp migration/db/deploy; sao lưu đêm + ngoài máy PASS; khôi phục thử bản 24/11 đạt (máy Lead, không phải trên `.99`); chưa có dữ liệu vận hành thật; khoá mã hoá bằng chứng chỉ 1 bản trên `.99` (chưa xác nhận cất ngoài máy); chưa WAL/PITR (mất tới ~24 giờ) |
| G5 Triển khai | chưa | `.99` Development; P0–P7 chưa chạy trên candidate; deploy không qua CI (D-m12-133, D-lead-064: dựng ảnh máy Lead + `trien-khai.sh`); HEAD hơn candidate 15 commit (29 tệp `services/`, 31 `apps/`), chưa lên máy; deploy contract chưa ghi ngoại lệ M1–M2 |
| G6 Vận hành | một phần | có log JSON, mã tương quan, `/health`, runbook Production + `lui.sh` (chưa chạy thật), cờ tắt khẩn; lịch giám sát 15 phút chờ `go m12.242` (chỉ phần M3); không giám sát sống/chết, đĩa, sao lưu, chứng chỉ; người trực chưa có tên |
| G7 Kiểm thử | chưa | pipeline đủ xanh gần nhất `3e84ab68b` 20/11; không pipeline cho `d4163331c`/`4bb29f8df`; CI đêm có luật nhưng chưa tạo lịch (chờ quyền); test lọc candidate đạt; HEAD chỉ Vitest lọc 2 ca; thử tải chưa |
| G8 Ngoài code | chưa | 3 chữ ký, tập huấn, mẻ/nguyên liệu thật, người trực, thiết bị camera (bảng dưới) |

## Gói việc (tới 30/11; phiếu `wp/` + `ra-soat/` là nguồn trạng thái)
Đã xong phần mã và đã lên `.99` (26/11, `d4163331c`): WP12g đợt 1–1b + m12.115/116 + GTIN, WP23–WP33 (WP32 cờ TẮT qua mốc, D-m12-140), WP-UAT 0 chưa chạy, WP21 (quan sát M3).
Còn mở nhưng không chặn 30/11: duyệt diff các việc Chờ review (M12-106/110/114/119/121), WP28 cổng bố cục màn mới, WP30 ảnh L1–L4, WP12g RS-2/3/4B + FRM-21 422.

| WP | Mục tiêu · tiêu chí đạt | Phạm vi / tệp nóng | Mức | Phụ thuộc | Mốc | Ước lượng | Trạng thái |
|---|---|---|---|---|---|---|---|
| WP-HEAD | (m12.249 A, D-m12-145) Lên `.99` bản `4bb29f8df` ở Development TRƯỚC mẻ thật: dựng 5 ảnh từ HEAD, `trien-khai.sh`, sao lưu trước, smoke; UAT lab chạy lại mẫu ca 15 commit đụng (nhập kho, sổ kho, phát hành mẻ, dashboard 14 ngày A04-F04-T01, PWA). Đạt: health ready, 3 trang 200, M3 19/19 200, mẫu UAT đạt | `.99` (không sửa repo); sổ UAT | Thường (không đổi DB/deploy/quyền) | Toàn lệnh deploy riêng; tránh chồng lượt m34 lên `.99` | tối 27/11 – sáng 28/11 | 2–3 giờ | **XONG phần máy 27/11 20:08** (D-m12-146; live/ready 200, M3 13/13 lượt 200, 0 lỗi, Sheet M12-124); mẫu UAT lab chưa chạy lại |
| WP-ME | Mẻ thật đầu tiên trên `.99`: nhập NCC, nguyên liệu, kho/vị trí, ca, kích hoạt SKU → nhận NL (kế toán nhập giá) → QC → lệnh SX → công đoạn trên điện thoại Sang → QC TP → phát hành → FRM-22 nhập kho → tồn bán được; M3 S02 (1 hộp) / S03 (Q+1) ở chế độ quan sát. Đạt: biên bản dòng 7 + 9 có số, S02/S03 khớp | dữ liệu `.99` qua giao diện (D-m12-092) | Nguy hiểm (dữ liệu thật) | Lan, chú Dũng, Khánh, Sang thao tác; Toàn xác nhận; Phúc hỏi S02/S03 | 28/11 (P0 chờ xác nhận mẻ, D-m12-144) | 1 ngày xưởng | CHƯA (0 mẻ lúc 15:21) |
| WP17b | Production `.99` theo [phiếu 28/11](ra-soat/2026-11-26-chot-27-28-11.md): P0 kiểm chỉ đọc → P1 sao lưu → P2 khoá JWT + khoá ký webhook → P3 `.env` → P4 compose/Caddyfile (2 băm, giống hệt ở HEAD) → P5 kiểm → P6 tạo lại API (M3 gián đoạn 1–2 phút, tự `lui.sh` khi lỗi) → P7 kiểm sau (Production, cookie `Secure`, M3 ≥ 1 lượt 200, quên mật khẩu TẮT, đăng nhập tay, tải 1 ảnh + khởi động lại). Đạt: P7 đủ, M3 xin lại token đúng 1 lần (S01/S17) | `.99`, `deploy/m12/chuyen-production-99/` | Nguy hiểm | Toàn lệnh P0 và P1–P7, cửa sổ xưởng ngừng ghi, xác nhận JWT khác khoá lịch sử, cách ly `avt.png`, cất khoá bằng chứng ngoài máy; báo Phúc | 28/11 | ≤ 45 phút + P0 | CHỜ (P0 chưa chạy trên candidate) |
| WP-JWT | (m12.251 A, D-m12-145) Hồ sơ đóng ngoại lệ JWT sau P2 (bản nháp + script điền/kiểm soạn trước ở `_wt/_luu/m12-jwt-dong`): `tools/ci/historical-jwt-rotation-20261201.json` + `docs/decisions/24-11-19-00-historical-jwt-key-rotation-closure-decision.md` đúng khuôn verifier `d20dd1bbe`; Toàn ký ngày thật. Đạt: `verify_historical_jwt_source_disposition.py` + test Python xanh sau mốc giả lập | `tools/ci/**` (2 tệp mới), `docs/decisions/`, `.gitlab-ci.yml` (2 dòng ghim + `--expected-rotation-decision-sha256`, bắt buộc cùng commit) | Nguy hiểm (bằng chứng bảo mật), verifier ở cổng | P2 xong; lời duyệt Toàn; commit lên `main` trước 16:59Z | trước 30/11 16:59Z | 1 giờ sau P2 | BẢN NHÁP XONG 27/11 (`_wt/_luu/m12-jwt-dong`, tự kiểm ĐẠT, 18/18 ca sai đỏ đúng lý do) |
| WP-NT | Nghiệm thu M12-010 trên `.99` Production ([biên bản](wp/M12-010-bien-ban-27-11.md)): 11 dòng có kết quả, tập huấn GA-2711 (Lan, chú Dũng, Khánh, Sang), 5 ca thiết bị (điện thoại Android Sang: 4 ca quét + cài trang truy xuất), 3 chữ ký (Khánh, Toàn, chú Dũng); go/no-go | biên bản, HDSD (`6a104b28e`, `8a721b2b7`) | Nguy hiểm (người thật, máy thật) | WP17b, WP-ME; tin mời (nháp 24/11 chưa gửi) | 28–29/11 | 0,5 ngày soạn + buổi | CHƯA |
| WP-HYP | Hypercare 28/11–07/12: người trực hai phía (Toàn + Phúc), `go m12.242` (lịch giám sát 15 phút M3), thêm kiểm sống/chết + đĩa + sao lưu + chứng chỉ vào cùng lịch, phiếu trực 28–30/11, Sheet M12-057/059/060. Đạt: lịch chạy, cảnh báo thử nhận được, phiếu trực có tên | `tools/ops/giam-sat*`, máy Lead (lịch Windows) | Thường | Toàn `go`, Phúc tên người trực | 28/11 | 0,5 ngày | CHƯA |
| WP-SO | Dọn sổ cho go/no-go: Sheet M12-105 (UAT 0 chưa chạy), M12-001/117 (CLI thiếu `leadReview`/`leadNote`), M12-112 (Next 16.4.6), M12-030 rà lại sau P0; đầu phiếu WP12g/WP24–28 ghi đúng; PUI S4 đã sửa ở HEAD ghi FIXED khi lên máy; báo phiên lead: `deploy/edge-98` chưa commit, checkout `ginsengfood-contracts` kẹt merge từ 21/05 | Project Control, Sheet | Thường | — | 28/11 | 1–2 giờ | CHƯA |

## Đường găng tới 30/11
- **Tối 27/11:** Toàn trả m12.249–252 · (nếu A) WP-HEAD lên `.99` Development · Toàn/Lan chốt dữ liệu nền (NCC, nguyên liệu, kho, ca, SKU kích hoạt).
- **28/11 sáng:** WP-ME bắt đầu (nhận NL → QC → lệnh SX) · trưa khi xưởng ngừng ghi: P0 → P1–P7 (WP17b, ≤ 45 phút) · M3 xin lại token (S01/S17) · WP-HYP bật giám sát.
- **28/11 chiều – 29/11:** WP-ME đi tiếp tới FRM-22 + tồn bán được → S02/S03 · WP-NT tập huấn + nghiệm thu + 5 ca thiết bị · WP-JWT sau P2 · 29/11 tối chữ ký + go/no-go.
- **30/11:** chạy thật, hypercare; trước 23:59 giờ VN hồ sơ đóng ngoại lệ JWT đã ký.
- Trượt: chưa có mẻ đi trọn tới tồn bán được trước trưa 29/11 ⇒ 30/11 chạy thật phần nhập NL + sản xuất + QC (M3 vẫn quan sát, không phụ thuộc tồn); P1–P7 chưa chạy trước 29/11 tối ⇒ NO-GO, vì khoá JWT lịch sử hết hiệu lực 30/11.

## Việc ngoài code
| Việc | Ai gỡ | Cần trước | Trạng thái |
|---|---|---|---|
| Lệnh P0, P1–P7; cửa sổ xưởng ngừng ghi; xác nhận JWT mới khác khoá lịch sử; cách ly `avt.png`; cất bản sao khoá bằng chứng ngoài máy | Toàn | 28/11 | P0 chưa chạy |
| NCC + nguyên liệu thật, có tại kho (D-m12-137: tối 26/11 / 8:00 27/11) | Lan, chú Dũng | 28/11 sáng | chưa thấy xác nhận; `.99` 0 mẻ |
| Ca, vị trí 2 kho, kích hoạt SKU, nội dung trang công khai, ghép máy Sang | Toàn | 28/11 sáng | chưa thấy ghi nhận |
| Gửi tin mời nghiệm thu + tập huấn (nháp 24/11) | Toàn | 28/11 | chưa gửi |
| Tập huấn GA-2711, buổi nghiệm thu, 3 chữ ký | Lan, chú Dũng, Khánh, Sang; ký Khánh/Toàn/chú Dũng | 29/11 | trống |
| Điện thoại Android có camera + Chrome cài PWA (5 ca thiết bị) | Sang, Toàn | 28–29/11 | máy Windows không có camera |
| Biết gián đoạn 1–2 phút ở P6; hỏi S02/S03; người trực; bên nhận webhook | Phúc | 28/11 | bên nhận tắt; người trực chưa nêu; m34 vừa lên `.99` 27/11 — tránh chồng lượt |
| Người trực hypercare 28/11–07/12 | Toàn, Phúc | 28/11 | chưa có tên |
| `go m12.242` lịch giám sát | Toàn | 28/11 | chờ |
| Cổng 80 công khai ra 400; HSTS 1 năm; commit `deploy/edge-98` | Anh Tuấn / phiên lead | sau 30/11 | chưa hẹn |
| DIET-2, danh sách lô cũ (m12.204), RS-2/3/4B | chú Dũng | sau 30/11 | chờ |
| Xoay token Sheet (SEC-11) | Toàn | sau 30/11 (D-m12-140) | hoãn |

## Kiểm chéo (27/11)
- Hạng mục < 90 có WP: H1–H6 → WP-ME (lên 75) + WP-NT (lên 90) · H7 hoãn · H8 → WP-ME (S02/S03), NK-b sau 30/11 · H9 → WP17b, WP-JWT · H10 → WP-HYP, WP-NT.
- Tệp nóng: `.99` chỉ một lượt một lúc theo thứ tự WP-HEAD → WP-ME (giao diện) → WP17b; WP-JWT chỉ `tools/ci/` + `docs/decisions/` (không chung tệp với ai); sổ UAT chỉ WP-HEAD ghi (khoá `@bo-kiem-du` đang thuộc `m12/uat-codex` — xin bàn giao trước).
- Ước lượng: phần máy ~1 ngày (WP-HEAD 3 giờ, WP17b ≤ 1 giờ + P0, WP-JWT 3 giờ, WP-HYP 4 giờ, WP-SO 2 giờ) trên 2 làn — vừa. Nút thắt là người: lệnh từng pha của Toàn, nguyên liệu + thao tác xưởng, tập huấn, chữ ký trong 2 ngày.

## Không kịp 30/11 + bản tối thiểu 30/11
- **Sau 30/11 (đã có quyết định):** NK-b giữ/nhả thật, ENFORCE, tự nhả (D-m12-136/140) · webhook M12 → M3 thật M12-055 + 3 nợ S3 cổng Nguy hiểm (D-m12-145) · MISA, in tem tại xưởng (D-m12-002/006/103) · SEC-11, m12.240/241, cờ quên mật khẩu (D-m12-140) · quét image/SBOM/DAST (D-m12-090) · DIET-1/2/3.
- **Sau 30/11, chưa có quyết định:** WAL/PITR · khôi phục thử trên chính `.99` · giám sát ngoài M3 phần sâu · thử tải · cổng 80, HSTS · ngoại lệ deploy contract · CI đêm (chờ quyền) · WP28 bố cục màn mới, WP30 ảnh · M3 ghim hợp đồng mới (M3-131) · nối M6/M7.
- **Bản tối thiểu 30/11:** M1–M2 Production trên `.99` qua HTTPS, khoá JWT mới, XFF `/32`; nhận NL (giá theo vai) → QC → lệnh SX + app xưởng → QC TP → phát hành mẻ → nhập kho TP → tồn; truy xuất nội bộ + trang công khai; M3 chế độ quan sát (không giữ hàng, không ENFORCE, M3 tự xử khi M2 tắt); in tem tay, MISA nhập tay; sao lưu đêm + ngoài máy; quên mật khẩu và tự nhả TẮT; nghiệm thu M12-010 có 3 chữ ký (hoặc "GO có điều kiện" ghi rõ điều kiện).
