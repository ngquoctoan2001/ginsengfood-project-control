# Sẵn sàng — M8 IVR

Mốc: **27/11/2026 19:4x** (đồng hồ máy) · % sẵn sàng: **54** (trung bình trọng số, không đổi từ 26/11) · **Kịp 30/11 gọi khách thật: ĐỎ** — chưa có cuộc nào từ worker M8 qua trunk MobiFone, MobiFone chưa hẹn gọi thử (hạn 24/11 đã qua), pháp lý giọng VieNeu chưa ký. **Bản tối thiểu 30/11 (MOCK trên .99, D-m8-167): VÀNG** — mã và ảnh đã lên .99, còn phải chạy lại ca trên bản mới và Toàn tự thao tác.

Nguồn: `/ke-hoach` 27/11, 3 scout chỉ đọc (lõi + nối M3; tổng đài + giọng + Giờ Vàng; triển khai + vận hành + hồ sơ) và phiên chính đọc .99 lúc 19:27 ([log](ra-soat/kich-ban-99-1611/kiem-ban-99-2711.log), thư mục không vào git). Repo `ginsengfood-ivr` `main` = GitLab = GitHub `169a6859`. Bản trước: [nhat-ky/2026-11-27-san-sang-truoc-viet-lai.md](nhat-ky/2026-11-27-san-sang-truoc-viet-lai.md). Danh sách việc chi tiết G/T/H/N/K/B/X vẫn ở [KE_HOACH.md](KE_HOACH.md) §3; tệp này là kế hoạch tới 30/11. Khung `chung/MAU.md` §0 đổi mốc 15/11 thành 30/11 vì các mốc A–D đã qua.

**Máy (đọc 27/11 19:27):** .99 chạy M8 `75aa3a9c` (triển khai 27/11 11:08, 52 migration, cái cuối `W0586RegionProvinces`), chỉ kém `main` một commit tài liệu; lịch gọi TẮT, `REAL_CUSTOMER_CALL_ALLOWED=NO`, 0 task trong 7 ngày, 5 callback chết cũ; sao lưu đêm còn chạy (bản 27/11 02:30). M3 .99 chạy be `4e5d26ae` (19:15, phiên m34 dùng ngoại lệ một lần D-m34-120; lần sau chỉ Phúc, D-lead-060), ghim cùng hash draft.51 `abf1d485…61fd`. .64 Asterisk 22.11.0 từ 20/11.

## Hạng mục lõi (tổng trọng số 100, giữ trọng số cũ)

| Hạng mục (người ngoài hiểu được) | Trọng số | Bậc | Bằng chứng (tệp:dòng / lệnh / SHA) | Thiếu để lên bậc kế |
|---|---:|---:|---|---|
| Phần mềm IVR lõi: nhận đơn, lập lịch giờ gọi, gọi, nhận phím, gọi lại, trả kết quả (gồm luật gọi cấu hình được) | 25 | 50 | Bộ đủ `cebf9d1c` 26/11: unit 3235/3235, integration 1781/1781, contract 46, chaos 8; luật gọi L-01…L-07, L-11 có trong ảnh `75aa3a9c` (L-05 `c2bb7064`, L-07 `6ed2d535`, L-11 `15e5a6bb`); cổng Nguy hiểm vùng 1–3 ĐẠT ([cong-nguy-hiem.md](cong-nguy-hiem.md)) | 75: chạy trên `75aa3a9c` các ca thuận + không nghe / sai phím / phím 0 / hết cửa sổ / gọi lại (E04 chưa chạy lần nào); luật gọi bật `IntakeMode` + luật ACTIVE và chạy L-10 cùng M3 |
| Nối với M3: nhận đơn từ M3, trả kết quả về M3 | 20 | 75 | E02/E03/E01/E05/E06-A/B/E10 đạt trên .99 14/11 (AI thao tác, `docs/evidence/W-0540/README.md`, `565490cd`), trên ảnh cũ `10f335de`; E07/E08 Toàn xác nhận 17/11 ([hướng dẫn bậc 90](wp/huong-dan-bac-90-noi-m3.md):49-50); hợp đồng draft.51 hai phía cùng hash (`IvrContractPinTest.java:25` ở BP `4e5d26ae`) | Lặp ca trên bản mới (đỏ thì hạ về 50); 90: Toàn tự đặt đơn E02/E03 theo phiếu và ký; `dial_evidence` M3 đang đọc mà M8 chưa trả ([hộp thư](../../hop-thu/m8-2026-11-27-m3-dial-evidence.md)) |
| Tổng đài và nhà mạng MobiFone | 15 | 50 | Một cuộc lab nội mạng 23/10 (`docs/evidence/l35-single-call-20261022/public-from-20261023/README.md:31-61`); worker → SIP lab 20 ca (`l35-worker-route-20261026/README.md:26,37`); .64 22.11.0 + ufw 5060 chỉ SBC ([WP02I](wp/M8-WP02I.md):47-56); kịch bản bảo trì H-02 226/226 kiểm giả, CDR W-0572/W-0574 | 75: một cuộc qua worker M8 trên .99 + .64 + trunk (X-01 MobiFone, `carrier_configured:false`, số nội bộ X-07); RTP/CDR áp trên .64 |
| Giọng đọc, lời thoại 3 miền, tên địa bàn (hồ sơ giọng, nghe thử, đổi giọng/tốc độ, tỉnh thuộc vùng) | 10 | 50 | W-0579…W-0583 (WSOLA, bank 9 cặp, bản dẫn xuất, kích hoạt cả bộ), W-0586/0587/0589 (34 tỉnh), draft.51; rà độc lập 0 nặng 0 trung bình, đột biến giọng 15/15, tỉnh–vùng 22/22; có trong ảnh `75aa3a9c`; màn M3 lên .99 27/11 | 75: dựng 6 cặp bank trên .99 (W-0584, ≈37 phút máy), làm nóng 3.318 cụm (≈1,75 giờ máy), bật `Variants`/`STORE`/`RegionSource=STORE`, Toàn nghe 0.80/1.20 và đổi vùng một tỉnh (W-0585). Pháp lý `MODELS.lock` `PENDING_SEP_SIGNATURE` chỉ chặn production |
| Giờ Vàng 5.000 đơn | 10 | 50 | Mô phỏng 21/10: 5.000 đơn/77 phút 45 s, 36 kênh (`docs/reports/21-10-ket-qua-5000-don-phan-bo-bat-may-som.md:7,84-86`), bản `90795cfe` (cũ 200 commit) | Chạy lại trên bản hiện hành chỉ làm mới bậc 50; 75 cần đo qua nhà mạng (sau X-01 + 01D) |
| Cài lên máy chủ (.99 + .64) | 10 | 50 | `deploy_m8_99` 17/11; `trien-khai.sh` lên `f8e29b46` 21/11 và `75aa3a9c` 27/11 (52 migration, health); .64 22.11.0 20/11 (Toàn gõ sudo, `verify` PASS) | 75: kiểm sau lên bản 27/11 theo [checklist-go-live](wp/checklist-go-live.md):9-14 (health, ready, JWKS, 32 tuyến, cấu hình bắt buộc `PlaybackCallLimitSeconds`, `DailyBudget`), Toàn nhập trần; diễn tập quay lui một lần |
| Sao lưu và khôi phục | 5 | 75 | Khôi phục .99 14/11 22:36, RTO 9,7 s (W-0541 `143c9c79`); cron đêm 02:30 chạy liền 25–27/11 (bản gần nhất `ivr-20261126T193001Z`) | 90: Toàn tự diễn tập khôi phục trên schema 52 migration theo phiếu, duyệt RPO/RTO (`deploy/backup/README.md:17-18`) |
| Hồ sơ phát hành | 5 | 30 | `docs/release/readiness-board.md`: nấc 0, 579 work item (ACCEPTED 310, EVIDENCE_SUBMITTED 218, BLOCKED_EXTERNAL 20); 11 gate repo `BLOCKED_EXTERNAL` ([07F](wp/ho-so-phat-hanh-07F.md) §2) | Sinh lại board, thêm dấu cho 18 dòng, Toàn đọc 80 dòng chờ; chữ ký gate là việc ngoài |
| **Tổng** | **100** | **54** | (25×50 + 20×75 + 15×50 + 10×50 + 10×50 + 10×50 + 5×75 + 5×30)/100 = 54,0 | |

Nếu sóng 1–2 dưới đây đạt hết: lõi 75, nối M3 90, giọng 75, cài máy 75, sao lưu 90, hồ sơ 50 ⇒ **70%**. Tổng đài và Giờ Vàng không lên được nếu MobiFone chưa hẹn.

**Mở rộng (ngoài trọng số):** ngoại mạng + nhà mạng thứ hai — bậc 0, chờ giấy định danh (hồ sơ gửi 31/10, Sheet M8-006 chặn, không có ngày) → [WP06](wp/M8-WP06.md). `dial_evidence` cho M3 (bộ đếm Điều kiện gửi đơn) — bậc 0, gói DE dưới đây.

## Cổng G1–G8 (`chung/CONG_PRODUCTION.md` §3)

| Cổng | Kết luận | Thiếu gì · đóng bằng gì |
|---|---|---|
| G1 Chức năng lõi | CHƯA | Không hạng mục nào ≥ 90 · E99 + L10 rồi Toàn nghiệm thu |
| G2 Liên module | CHƯA | Hash draft.51 khớp hai phía; ca E chỉ đạt trên ảnh cũ; `dial_evidence` lệch; hợp đồng vẫn `DRAFT`, M3 chưa ký (`docs/api-changelog.md:3`) · E99, DE, ký G-CONTRACT |
| G3 Bảo mật | CHƯA | Token Sheet cũ (`e464cd05`) chưa xoay; mật khẩu sudo máy cũ lộ chat chưa có bằng chứng đã đổi; khoá CA ARI chưa rõ chỗ (m8.126); 401/403 đo 178/178 ngày 17/11, chưa đo 32 tuyến draft.50/51; trivy ảnh `75aa3a9c` chưa chạy · QUET, K99, X-05 |
| G4 Dữ liệu | CHƯA | Khôi phục mới thử trên 45 migration (14/11); RPO/RTO chưa duyệt; sao lưu cùng VM (D-m8-122: Anh Tuấn chụp `/data`, chưa thấy xác nhận) · VH |
| G5 Triển khai | CHƯA | Ngoại lệ nhiều container (D-m8-011) chưa vào `MODULE_DEPLOY_CONTRACT.md` (phiên lead); chưa diễn tập quay lui; Protected environment GitLab chưa có · K99, VH, hộp thư lead |
| G6 Vận hành | CHƯA | 5 luật cảnh báo, chưa có Alertmanager/người nhận (m8.73, X-04); tắt khẩn đạt 17/11 trên bản cũ; reboot .99 chưa chạy; runbook viết lại 27/11 (`169a6859`, `deploy/m8/README.md` §3, §10–13) · VH, X-04 |
| G7 Kiểm thử | CHƯA | Bộ đủ xanh ở `cebf9d1c` (trước 2 commit sửa định dạng C#); CHƯA CHẠY: oasdiff draft.50→51, gitleaks chế độ git, gate-sweep lần hai, phiếu E trên bản mới, đo tải; CI định kỳ chờ X-08 · QUET, E99 |
| G8 Ngoài code | CHƯA | Bảng việc ngoài dưới đây: MobiFone, pháp lý, lời thoại, định danh đều chưa có bằng chứng tiến triển |

## Gói việc (mức theo D-lead-064: Thường / Nguy hiểm)

Đã xong từ mốc 14/11 (chi tiết ở bản trước và KE_HOACH §3): 02K chuyển .99, 01E nghiệm thu 6/10 ca 14/11, 07E, 02J, 02I .64, W-0549, 07G, 03B, luật gọi L-01…L-07 + L-11, giọng/tốc độ W-0579…W-0583, tỉnh–vùng W-0586…W-0590, draft.51 W-0590…W-0595, nợ C, cổng Nguy hiểm vùng 1–3, lên .99 `75aa3a9c` (27/11).

| WP | Mục tiêu | Mức | Phụ thuộc | Hạn | Giờ | Trạng thái |
|---|---|---|---|---|---:|---|
| K99 | Kiểm sau lên `75aa3a9c` + cấu hình bắt buộc: đọc cờ và trần, health/ready/JWKS, 32 tuyến đúng mã (`do_loi_vao.py`), đặt `PlaybackCallLimitSeconds`/`DailyBudget` nếu thiếu; Toàn nhập trần trên màn M3 (T-03) | Thường (đặt cấu hình .99: Toàn duyệt) | D-m8-163 | 28/11 sáng | 3 | SẴN SÀNG (duyệt) |
| E99 | Chạy lại bộ ca trên bản mới, MOCK: E01, E02, E03, E05, E06-A/B, E10, ca không nghe / sai phím / hết cửa sổ, E04, gọi lại; Toàn tự đặt 2 đơn web (E02/E03) và ký phiếu | Nguy hiểm (bật lịch trên .99, theo lượt duyệt một lần) | K99; web .99 đặt được đơn | 28/11 trong khung 08:00–21:08 | 7 | SẴN SÀNG (phiếu cũ [buoi-e07-e02-e03-e08](wp/buoi-e07-e02-e03-e08.md), [nghiem-thu-tren-99](wp/nghiem-thu-tren-99.md)) |
| L10 | Luật gọi đầu–cuối với M3 trên .99: `IntakeMode=RULES_ALLOWED`, muối `phone_key`, nạp luật ACTIVE; M3 bật `M8_RULES` + quyền (Phúc); hết luật → hàng chờ nhân viên → xác nhận / huỷ / gọi lại | Nguy hiểm | E99; Phúc bật cờ M3 (D-lead-060) | 29/11 | 6 | CHỜ PHÚC ([luat-goi-cau-hinh](wp/luat-goi-cau-hinh.md), [theo dõi](../lead/wp/theo-doi-luat-goi.md)) |
| DE | `dial_evidence` cho 2 tuyến GET kết quả: cột chế độ lúc quay (migration thêm cột, cho phép rỗng), đóng dấu khi bắt đầu quay, `DIALED`/`NO_DIAL_FINAL`/`UNKNOWN`, hợp đồng draft.52 (NSwag, baseline, manifest), 8 ca test; báo m34 hash mới | Nguy hiểm (migration + hợp đồng) | D-m8-164 | 29/11 | 10 + 2 cổng | ĐANG LÀM (W-0596, [phiếu](wp/DE-dial-evidence.md)) |
| GIONG99 | W-0584 + W-0585 trên .99: dựng 6 cặp bank, làm nóng 3.318 cụm (đêm), bật `Variants` → Toàn nghe 0.80/1.20 trên câu có số tiền → `STORE` → kích hoạt cả bộ → đổi vùng một tỉnh; lùi bằng cờ OPTIONS | Nguy hiểm (lời nói với khách) | K99; D-m8-165 | 29/11 (làm nóng đêm 28/11) | 7 + máy | SẴN SÀNG, Toàn nghe ([checklist-go-live](wp/checklist-go-live.md) §4) |
| H64 | Bảo trì .64 tối thứ Bảy 28/11 22:30 (đệm 29/11): preflight, `bat-log`, CDR apply/verify, đọc hạn chứng thư; RTP HOLD khi chưa có cuộc thử; chứng thư lá ARI dừng ở CSR nếu chưa rõ khoá CA | Nguy hiểm | D-m8-166; Toàn gõ sudo; Anh Tuấn nhận lịch | 28/11 | 4 | CHUẨN BỊ ([phiếu 27/11](ra-soat/2026-11-27-goi-van-hanh-64-01d-wp10-wp11.md)) |
| VH | Vận hành: diễn tập quay lui `trien-khai.sh`, khôi phục trên schema 52 (Toàn tự làm theo phiếu), tắt khẩn lại trên bản mới, nối người nhận cảnh báo khi X-04 có | Nguy hiểm | E99 xong; X-04 | 30/11 sáng | 4 | SẴN SÀNG |
| QUET | oasdiff draft.50→51 (sau DE: →52), gitleaks chế độ git, trivy ảnh `75aa3a9c`, gate-sweep, CI bấm tay một lần | Thường | — | 28/11 | 2 | SẴN SÀNG |
| 07F | Hồ sơ phát hành: sinh lại board, dấu cho 18 dòng, sửa dòng cũ L-08/L-09 trong tracker lead, đưa 80 dòng cho Toàn đọc | Thường | DE xong (một người ghi register) | 30/11 | 3 | MỘT PHẦN ([phiếu](wp/ho-so-phat-hanh-07F.md)) |
| 01D | Gọi số nội bộ thật qua worker + trunk MobiFone, 1–3 cuộc (phím 1/0/không bấm) cùng callback M3 | Nguy hiểm | X-01, X-07, H64 | khi MobiFone hẹn | 8–10 | CHẶN (X-01) |
| 08 | Đo tải: chạy lại mô phỏng 5.000 đơn trên bản hiện hành (máy Lead); đo qua nhà mạng sau 01D | Nguy hiểm | 01D cho phần nhà mạng | sau 30/11 | 4 + 6 | CHẶN phần nhà mạng ([WP08](wp/M8-WP08.md)) |
| 02F | Lên production + bật gọi thật | Nguy hiểm | 01D, 08, X-03, cổng Nguy hiểm cuối | sau 30/11 | 12 | CHẶN ([WP02F](wp/M8-WP02F.md)) |

**Tiêu chí đạt và tệp nóng** (phiếu `wp/` lập khi giao sóng; chỉ phiên chính chạy lệnh trên .99/.64, không giao subagent):

| WP | Tiêu chí đạt | Phạm vi ghi · tệp nóng |
|---|---|---|
| K99 | Log đọc cờ + trần; 32 tuyến draft.51 đúng mã 401/403/2xx; trần hiển thị trên màn M3; `checklist-go-live` mục 9–14 tick | `ra-soat/` (không vào git), `du-lieu/*/appsettings.json` trên .99 qua `dat-cau-hinh.sh` có sao lưu |
| E99 | Mỗi ca có tương quan M3 → task → job → callback, `doi_soat_m3.py` KHỚP; lịch trả về TẮT, worker về sha cũ, hàng đợi như trước; phiếu Toàn ký cho E02/E03 | `docs/evidence/W-05xx/` (bằng chứng mới), kịch bản `ra-soat/kich-ban-99-*` |
| L10 | Ba nhánh hàng chờ nhân viên chạy thật MOCK; chế độ v4 cũ vẫn chạy khi tắt cờ | cấu hình .99 (M8 phiên m8, M3 Phúc) |
| DE | Bốn tổ hợp M3 đòi (quay rồi không bắt máy, lỗi trước/sau quay, thu hồi, gọi lại, dữ liệu cũ thiếu chế độ, đổi chế độ sau quay) có test; hash draft.52 báo m34 một lần; verifier một vòng | **nóng:** migration + `IvrDbContextModelSnapshot.cs`, `specs/api/openapi/ivr-order-confirmation.v1.yaml`, NSwag, `PostgresSchedulerStore.cs`, `TaskResultReadService.cs`, `work-register.md` |
| GIONG99 | `bank-check` đạt 9 cặp; readiness 100%; một cuộc MOCK ghi đúng `voice_speaking_rate` và giọng vùng; Toàn ghi đạt sau khi nghe | `deploy/tts/`, cấu hình .99; ghim bank mới |
| H64 | Biên bản từng phần GO/HOÃN; `verify` PASS sau thay đổi; 0 kênh trước/sau | `ra-soat/kich-ban-64-bao-tri/` |
| VH | Quay lui và quay về bản cũ có health 200; khôi phục khớp bảng + 52 migration; RTO ghi lại | `docs/evidence/`, `deploy/backup/` chỉ đọc |
| QUET | oasdiff không breaking ngoài danh sách đã duyệt; gitleaks 0 mới; trivy 0 HIGH/CRITICAL | chỉ đọc |

## Sóng và đường găng tới 30/11

Ba làn, không chung tệp nóng: **L1 code** (DE, agent coder trong checkout `main`, khai khoá `tools/khoa_tep.py`); **L2 máy** (K99 → E99 → L10 → GIONG99 → VH, phiên chính, tuần tự, Toàn duyệt theo chuỗi); **L3 sổ/quét** (QUET ngay, 07F sau DE vì chung `work-register.md`).

| Sóng | Khi | L1 | L2 (.99/.64) | L3 |
|---|---|---|---|---|
| 1 | 27/11 tối – 28/11 | DE (mã + test + draft.52) | 28/11 08:30 K99 → E99 (Toàn đặt 2 đơn); 22:30 H64; đêm làm nóng cụm (GIONG99 bước đầu) | QUET |
| 2 | 29/11 – 30/11 sáng | DE: cổng verifier, báo m34 ghim | L10 (cần Phúc) → GIONG99 nghe + bật → VH | 07F, chấm lại % |

| Mốc | Ngày | Cần có | Trạng thái |
|---|---|---|---|
| Kiểm bản mới trên .99 | 28/11 trưa | K99 + E99 đạt | Duyệt (D-m8-163) |
| Toàn nghiệm thu nối M3 | 28/11 tối | Toàn tự đặt E02/E03, ký | Lần 16/11 không có đơn (web chưa đặt); đặt lại |
| Luật gọi + giọng chạy thật MOCK | 29/11 | L10, GIONG99 | Cần Phúc + Toàn nghe |
| Bản tối thiểu 30/11 | 30/11 | MOCK đầu–cuối trên bản hiện hành, trần đặt, quay lui đã thử | Khả thi nếu L2 bắt đầu sáng 28/11 |
| Gọi khách thật | 30/11 | X-01 + 01D + X-03 + 02F | Không kịp nếu MobiFone chưa hẹn trước 29/11 |

Kiểm chéo: 8/8 hạng mục dưới 90 có WP hoặc lý do (lõi: E99, L10; nối M3: E99, DE; tổng đài: H64, 01D; giọng: GIONG99; Giờ Vàng: 08, phần nhà mạng chặn ngoài; cài máy: K99, VH; sao lưu: VH; hồ sơ: 07F). Tệp nóng: chỉ DE ghi migration/hợp đồng; 07F ghi register sau DE; làn máy một người. Ước lượng: L1 12 giờ (vừa), L2 27 giờ máy + người trong ~2,5 ngày, phần lớn trong khung gọi 08:00–21:08 và cần Toàn có mặt ⇒ **nút thắt là giờ của Toàn và Phúc, không phải giờ code**; nếu thiếu thì bỏ GIONG99 trước, giữ K99 + E99 + VH.

## Việc ngoài code (phiên `lead` gom về `modules/lead/VIEC_NGOAI.md`)

| Việc | Ai gỡ | Cần trước | Trạng thái (chỉ "đã" khi có bằng chứng) |
|---|---|---|---|
| X-01 MobiFone hẹn gọi thử qua trunk, đầu mối, nguồn SIP/RTP sau NAT, xác nhận kênh/cước/chặn quốc tế | Toàn | 28/11 | Chưa thấy đã hẹn; Sheet M8-005 chặn từ 14/11; hạn 24/11 đã qua |
| X-03 Pháp lý VieNeu (`MODELS.lock`), kho artifact | chú Dũng ký (D-m8-117); Chú cấp kho | trước bật production | `PENDING_SEP_SIGNATURE`; lời "tôi ký nè" 27/11 của Toàn chưa đủ uỷ quyền; không chặn máy thử |
| Lời thoại 3 miền + 455 tên | Chú (Toàn gửi) | trước bật production | Chưa thấy kết quả; tính năng tự chọn giọng không thay cổng này |
| X-07 Số nội bộ thật cho 01D | Toàn | trước 01D | Chưa |
| X-04 Kênh nhận cảnh báo + người trực | Toàn | trước bật thật | Người trực = Toàn (m8.85); kênh chưa chọn |
| X-05 Xoay token Sheet cũ (6 repo), đổi mật khẩu sudo đã lộ, khoá CA ARI | Toàn + phiên lead | 28/11 | Chưa thấy bằng chứng; custody .99 xong 17/11 |
| X-09 Khung bảo trì .64 28/11 22:30 + sudo | Toàn, Anh Tuấn | 28/11 | Phiếu soạn 27/11; chưa thấy Anh Tuấn nhận lịch |
| Phúc bật `M8_RULES` + quyền `IVR.RULE.*` trên .99 | Phúc (Toàn nhắn) | 29/11 | Chưa nhắn |
| m34 ghim draft.52 sau DE | Toàn/phiên m34 | 29/11 | Chờ DE |
| Anh Tuấn chụp `/data` ngoài máy; bàn giao máy thử (D-lead-065) | Anh Tuấn | 28/11 | Mở |
| X-02 Giấy định danh (ngoại mạng) | đơn vị dịch vụ | không chặn 30/11 | Không có ngày |
| X-08 Token GitLab `api` cho CI đêm | Toàn | — | Chưa; không có CI định kỳ |
| Protected environment GitLab | Toàn | — | Chưa (cần Premium hoặc chấp nhận cách thay) |

## Không kịp 30/11 + bản tối thiểu 30/11

- **Không kịp 30/11:** gọi khách thật (thiếu cuộc thử MobiFone qua worker, pháp lý giọng, lời thoại Chú duyệt, 01D, đo tải qua nhà mạng, production 02F); ngoại mạng; xoay chứng thư ARI (hạn ~14/12, khoá CA chưa rõ); mọi chữ ký gate phát hành.
- **Bản tối thiểu 30/11 (MOCK, `REAL_CUSTOMER_CALL_ALLOWED=NO`):** trên .99 bản hiện hành, đơn M3 thật → M8 → gọi MOCK (phím 1, phím 0, không nghe, hết cửa sổ) → callback → M3 đổi trạng thái đúng một lần; trần cuộc/ngày đã nhập; Toàn tự đặt đơn và ký phiếu E02/E03; quay lui và khôi phục đã diễn tập. Luật gọi và giọng mới là phần thêm nếu Phúc và Toàn kịp.

## Rủi ro lớn nhất

1. **Hạn 30/11 gọi khách thật trượt vì việc ngoài**: MobiFone chưa hẹn, pháp lý chưa ký; phần mềm không gỡ được. Cách giảm: chốt với Toàn ngay rằng 30/11 = MOCK, gọi thật là mốc riêng sau khi có cuộc thử.
2. **Bản mới trên .99 chưa chạy ca nào** (52 commit từ lần chạy ca gần nhất, gồm luật gọi, giọng, tỉnh–vùng): có thể lộ lỗi khi chạy thật MOCK. Cách giảm: K99 + E99 ngay sáng 28/11, trước mọi việc bật cờ.
3. **Giờ Toàn và Phúc** là nút thắt của làn máy (duyệt ghi .99, đặt đơn, nghe giọng, sudo .64, bật cờ M3). Lần 16/11 cả buổi E dời vì không có đơn. Cách giảm: duyệt một lần cho cả chuỗi K99 → E99, soạn sẵn kịch bản, hẹn giờ cụ thể.

## Câu đã chốt 27/11 19:4x ("ok 155-159", D-m8-163…167)

- **m8.155** Cho phiên m8 chạy K99 + E99 trên .99 từ 08:30 thứ Bảy 28/11 (đọc cờ, đặt trần/cấu hình bắt buộc có sao lưu, bật lịch MOCK theo lượt, chạy bộ ca, trả lại), duyệt một lần cho cả chuỗi; Toàn tự đặt 2 đơn web. Đề xuất: **có**.
- **m8.156** `dial_evidence` (draft.52, M3 ghim lại): **A** làm ngay ở làn code (đề xuất) / B sau 30/11.
- **m8.157** Bật giọng mới (bank, `Variants`, `STORE`) trên .99 coi là máy thử theo D-lead-065, pháp lý chỉ chặn production: **A** có (đề xuất) / B chờ máy thử của Anh Tuấn.
- **m8.158** Bảo trì .64 tối 28/11 22:30 (m8.123): preflight + log + CDR, RTP hoãn, chứng thư dừng ở CSR. Đề xuất: **có**, Toàn báo Anh Tuấn.
- **m8.159** 30/11 là bản MOCK; gọi khách thật thành mốc riêng sau cuộc thử MobiFone. Đề xuất: **có**, Toàn hẹn MobiFone trong tuần sau.

Câu cũ còn mở (giữ mặc định ở KE_HOACH §6): m8.124–126, m8.138–140, m8.142–144.
