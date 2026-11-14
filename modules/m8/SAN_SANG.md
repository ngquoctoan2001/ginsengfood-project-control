# Sẵn sàng — M8 IVR

Mốc: 13/11/2026 16:28 +07 · **Sẵn sàng 54%** (49 → 54: "Nối với M3" 50 → 75 nhờ E02 đầu-cuối 13/11) ·
**Kịp 15/11: bản tối thiểu XANH trên cặp thử .60/.61 (đã đạt 13/11 14:32), VÀNG trên máy chính thức .99** — một đơn M3 → M8 → gọi MOCK → callback `ACCEPTED` đã chạy; nghiệm thu E01–E10 còn lại và lặp E02 phải làm trên .99 sau khi M8 cắt (m12 → m34 → m8, D-lead-038), nên mốc C trượt tới ~17/11.
**Kịp 30/11: VÀNG** — gọi khách thật còn chờ ngoài (Chú duyệt lời thoại + pháp lý VieNeu, MobiFone xác nhận kênh, kho sao lưu ngoài máy, custody khoá, định danh ~20/11).
Nguồn: `ginsengfood-ivr` `main` local `eb5156ff` (remote `af93ca42`; `7f12ddaf` W-0533 của phiên phụ và `eb5156ff` W-0534 chưa push); sổ m8 tới 13/11 16:28; 2 scout chỉ đọc 13/11 (không chạy test, không vào máy; điểm không xác minh được ghi rõ). Thay hẳn bản 10/11. Hạn chung: 30/11 chạy thật, 15/11 mốc giữa (D-lead-025).

> **Máy chủ từ 13/11 (D-lead-035/036/037/038, `chung/MAY_CHU.md`):** app M8 chuyển từ `.61` sang `192.168.1.99` (thư mục `/data/ginsengfood-ivr`; phiên phụ "m8 phụ · chuyển app M8", W-0533; phiên chính không đụng `deploy/m8` của nó), Asterisk `.64` giữ (đã mở cầu ARI cho .99 lúc 16:08). Cắt ngay khi kịch bản sẵn sàng và Toàn duyệt liền, sau m12 và m34. Sau cắt M8 ở `https://192.168.1.99:8443`, chứng thư tự ký mới; `.61` chỉ còn đường lui. Chỗ nào dưới đây ghi `.61` là hiện trạng tới giờ cắt hoặc đường lui; việc mới nhắm `.99`.

## Phạm vi và quyết định đang hiệu lực

- D-m8-008: phía M3 của M3 → M8 do Toàn làm ở phiên m34; phiên m8 chỉ làm phần M8 và nhận bằng chứng. D-m34-065 (13/11): nghiệm thu E01, E03, E05, E06-A/B, E10 làm trên .99 sau khi M8 chuyển máy; E02 trên .60/.61 giữ làm bằng chứng.
- D-m8-010: máy chạy app M8 giữ khoá LAB tạm; custody production chốt trước release. D-m8-011: cụm hai máy (app + VieNeu + DB) + .64 (Asterisk). D-m8-076: 15/11 gọi MOCK, 01D (gọi số nội bộ thật) sau 15/11.
- `REAL_CUSTOMER_CALL_ALLOWED=NO`, `production_accepted=false`, `deployable=false`; kế hoạch không tự đổi.

## Hạng mục lõi (tổng trọng số 100, giữ trọng số cũ)

| Hạng mục | Trọng số | Bậc | Bằng chứng | Thiếu để lên bậc sau | WP |
|---|---:|---:|---|---|---|
| Phần mềm IVR lõi: nhận đơn, lập lịch giờ gọi, gọi, nhận phím, gọi lại, trả kết quả | 25 | 50 | Pipeline `62b0e973` xanh (Unit 1654 ×2, Integration 808, 09/11) và pipeline 3052521652 `10f335de` xanh (11/11); `src/` không đổi từ `005bc43d` (`git diff --name-only 005bc43d eb5156ff -- src` = 0), W-0526 chỉ thêm 34 test lối vào (`tests/Ivr.IntegrationTests/LoiVao*`); đường thuận chạy trên .61 (E02: nhận đơn, lịch, một lượt MOCK trả lời phím 1, `IVR_CONFIRMED`, `docs/evidence/W-0534`) | 75: ca không nghe / sai phím / phím 0 (E03) / gọi lại / hết cửa sổ / thu hồi chưa chạy trên máy thử (chỉ có test tự động: `ResultNormalizationPersistenceTests.cs:534`, `MockTelephonyFollowUpTests.cs:33`, `EligibilityBlockedDeadlineTests.cs:27`, `TaskRevocationApiTests.cs:87`); CI các commit sau `10f335de` CHƯA KIỂM; `IT-IMG-E2E-05` đỏ 2/4 lượt local (W-0530), nguyên nhân chưa rõ | 01E, 02M |
| Nối với M3: nhận đơn từ M3, trả kết quả về M3 | 20 | **75** ↑ | E02 đầu-cuối trên cặp .60/.61: đơn M3 363 → TLS ghim chứng thư lá + token thật → task `ELIGIBLE` → lượt gọi MOCK → callback `DELIVERED_ACCEPTED`/`ACCEPTED`/200 → M3 `CONFIRMED`; `doi_soat_m3.py` KHỚP 1/1, M3 kết luận áp đúng một lần (`docs/evidence/W-0534`, `ra-soat/2026-11-13-e02-doi-soat.md`); hợp đồng draft.45 hash `38c85c87…`, callback target-v1 `af0cb5cc…` khớp bản M3 ghim | 90: phiếu E01–E10 chưa đóng ca nào; Lead chưa thao tác theo phiếu; hợp đồng vẫn `DRAFT` (M3 chưa ký nhận); máy chính thức đổi sang .99 (chứng thư, `M8_ORIGIN`, cầu 8445) nên phải lặp lớp 2 trên .99 | 01E; m34 |
| Tổng đài và nhà mạng MobiFone | 15 | 50 | Một cuộc nội mạng 23/10 đạt bằng dialplan riêng, phím 1 (`docs/evidence/l35-single-call-20261022/public-from-20261023/README.md:30-60`); worker → SIP lab 20 ca (`docs/evidence/l35-worker-route-20261026/`); .64 đã mở cầu ARI cho .99 (TCP mở, HTTPS không chứng thư trả 400) | Chưa cuộc nào từ worker M8 qua trunk; 36 kênh/2 CPS chưa được xác nhận (MobiFone chỉ trả "400 cuộc/1 IP/10 s"); .64 vẫn bản 27/10 | 02I, 05 |
| Giọng đọc, lời thoại 3 miền, tên địa bàn | 10 | 50 | Nguồn địa bàn M3 34/3.321, công cụ 80/80 test; 2.866 tên khớp, 455 chờ duyệt; 92 mẫu Toàn đã duyệt (`wp/M8-WP04A.md`, `docs/evidence/l26-listening-20261020/`); công cụ làm nóng 3.318 cụm đã gộp (W-0520) | Làm nóng CHƯA CHẠY (≈1,75 giờ máy, chưa đo CPU); Chú chưa duyệt lời thoại; pháp lý `PENDING_SEP_SIGNATURE` (`deploy/tts/models/MODELS.lock`) | 04B, 07V |
| Giờ Vàng 5.000 đơn | 10 | 50 | 5.000 đơn/77 phút 45 s, 36 kênh/2 CPS giả lập (`docs/reports/21-10-ket-qua-5000-don-phan-bo-bat-may-som.md`) | Chưa chạy lại trên bản hiện hành, chưa đo qua nhà mạng, .99 dùng chung 6 nhân với M1–M2/M3/M4/M9 | 08 |
| Cài lên máy chủ (đích .99 + .64) | 10 | 50 | .61: khuôn, CI → registry → `deploy_m8_61` Passed, quay lui, hậu kiểm 12/11, `10f335de`; kịch bản chuyển .99 test host giả 30 ca, đột biến 5/5 (`docs/evidence/W-0533`) | .99: mọi pha CHƯA CHẠY, `7f12ddaf` chưa push, không có verifier độc lập; .64 vẫn bản 27/10; ảnh đang chạy `10f335de` còn runtime .NET 10.0.14 (bản 10.0.15 cần CD `deploy_m8_99`, biến CI `M8_99_*` chưa tạo) | 02K, 02I |
| Sao lưu và khôi phục | 5 | 50 | `deploy/backup/` backup/restore/offhost + 5 bộ test; W-0522 lab 5/5, RTO 8–66 s trên DB giả ~15,8 MB; `may-99/sao-luu.sh` (giữ 14 bản, cùng VM) | Restore trên máy thật CHƯA CHẠY; cron sao lưu .99 chưa cài; kho ngoài máy chờ Anh Tuấn (M8-003 Bị chặn); RPO/RTO chưa duyệt | 03B |
| Hồ sơ phát hành | 5 | 30 | `docs/release/readiness-board.md:24`: board nấc 0; 522 work item, 310 ACCEPTED (tự nghiệm thu), 161 EVIDENCE_SUBMITTED; 11 gate ngoài `BLOCKED_EXTERNAL` | Chữ ký/release approval; rà 161 mục | 07F |
| **Tổng** | **100** | **54%** | (25×50 + 20×75 + 15×50 + 10×50 + 10×50 + 10×50 + 5×50 + 5×30)/100 = 54,0 | | |

Bậc 75 cần thao tác như người dùng thật trên máy thử; 90 cần Lead/Chú tự thao tác theo phiếu. "Nối với M3" lên 75 vì mô tả hạng mục (nhận đơn từ M3, trả kết quả về M3) đã chạy trọn ở E02; "Phần mềm IVR lõi" giữ 50 vì hạng mục gồm cả gọi lại, sai phím, hết cửa sổ mà trên máy thử mới có đường thuận. Deploy .61 không cộng điểm riêng vì hạng mục "Cài lên máy chủ" gồm cả .99 và .64.

**Mở rộng (ngoài trọng số):** ngoại mạng + nhà mạng thứ hai — bậc 0, chờ giấy định danh (hẹn ~20/11, không phải cam kết) → [06](wp/M8-WP06.md).

## Cổng G1–G8

| Cổng | Kết luận | Thiếu gì · đóng bằng gì |
|---|---|---|
| G1 Chức năng lõi | CHƯA | Không hạng mục nào ≥ 90 · 01E → UAT Lead |
| G2 Liên module | CHƯA | Một ca (E02) đạt trên .60/.61; hợp đồng khớp hash nhưng `DRAFT`, M3 chưa ký nhận (`docs/api-changelog.md:3`); E02 lặp (đơn 577), E01, E06-A và E03 đạt trên .99 14/11; E05, E06-B, E10 chưa · 01E |
| G3 Bảo mật | CHƯA | Token Sheet cũ còn trong lịch sử (`e464cd05`, GitLab + GitHub; xoay chờ phiên lead); mật khẩu sudo .61 lộ chat 09/11 và gõ lại vào chat 12/11, chưa có bằng chứng đã đổi; custody khoá production chưa chốt; ma trận 401/403/429 đạt ở test local (41/41, 188 + 236 ca), công cụ đo CHƯA CHẠY trên máy thật; m8.78, m8.81 chờ Lead; chứng thư 8443 mới trên .99 chưa thử với be Java M3 · 07E đo, 07G, việc ngoài |
| G4 Dữ liệu | CHƯA | Migrate từ bản đang chạy đạt trên .61 (11/11, 45 migration); từ DB rỗng chỉ lab local; restore chỉ lab; chuyển CSDL .61 → .99 (`pg_dump` lúc dừng ghi, `pg_restore`, so số dòng từng bảng) mới thử bằng host giả; kho ngoài máy chưa có · 03B, 02K |
| G5 Triển khai | CHƯA | Khuôn M8 là ngoại lệ D-m8-011 (nhiều container, 8443, `/health/live`, `USER 1654`), chưa ghi vào `MODULE_DEPLOY_CONTRACT.md`; .99 chưa chạy pha nào; `M8_99_DEPLOY_SSH_KEY`/`_KNOWN_HOSTS`/environment `m8-99` chưa tạo; Protected environment cần GitLab Premium; pipeline của `af93ca42` chưa xem được · 02K, 02M, 02I |
| G6 Vận hành | CHƯA | Có `X-Correlation-Id` và 3 luật cảnh báo nhưng chưa nối người nhận (m8.73 gác, D-m8-075; .61 đang bắn 3 × `IvrOperationsProbeUnknown`); runbook có (`deploy/m8/README.md` §3/8–13, `tat-khan/README.md`); diễn tập tắt khẩn chưa chạy trên máy thật; cron sao lưu .99 chưa cài; reboot chưa chạy · 02J, 03B |
| G7 Kiểm thử | CHƯA | CI xanh `62b0e973` và `10f335de`; pipeline GitLab `eca6670f` (13/11 19:11) có 2 job đỏ không do mã: `governance` dừng ở dind kéo `docker:29.6.2-cli` (`TLS handshake timeout`, exit 125), `dotnet` đạt mọi test và cổng (JUnit 2542 + 1654 + 25 ca, `JUNIT_SUBSET_GATE_PASS` 6/6) rồi chạm hạn 1h lúc tải artifact, lúc máy Lead 100% CPU; chờ Retry khi máy rảnh; quét trước push (D-m8-055) PASS trên `eca6670f` (phiên phụ, 13/11 19:44: dựng 9/9 image `--no-cache`, trivy 8/8, `refresh-locks --check`, PII 3397 tệp, gate-sweep; gitleaks 0) sau khi `refresh-locks` (W-0537) vào main; phiếu E01–E10 chưa đóng ca nào; tải chưa chạy trên bản hiện hành · 02M, 01E, 08 |
| G8 Ngoài code | CHƯA | Bảng việc ngoài dưới đây; trừ .64 mở cho .99 (13/11 16:08) và `/data/ginsengfood-ivr` (15:15), chưa việc nào có bằng chứng đã gửi/đã xong |

11 gate repo `BLOCKED_EXTERNAL`: G-CONTRACT, G-SPEECH, G-DIAL, G-AUTH, G-POLICY, G-LAB-SIM, G-ESIM32, G-LEGAL, G-RELEASE, G-GITLAB, G-PLATFORM (`docs/release/gate-status.yaml`).

## Gói việc

Đã xong: 01A, 02A–02E, 02G, 02H, 03A, 04A, 07A, 07D, 01B (cấu hình nối M3 đã áp và chạy trên .61 13/11), công cụ 01C/02J/07E/03B/04B (đã gộp, W-0520…W-0526), hỗ trợ nối M3 (W-0527 bảng địa bàn, W-0528/0529 `lan-thu.sh`, W-0531 ghim chứng thư lá, W-0532 kiểm `/healthz/`), W-0530 runtime .NET 10.0.15, W-0534 bằng chứng E02. Giờ = công AI tạo + kiểm còn lại, chưa gồm chờ ngoài.

| WP | Mục tiêu | Rủi ro | Phụ thuộc | Mốc | Giờ | Trạng thái |
|---|---|---|---|---|---:|---|
| 02K mới (phiên phụ, W-0533, Sheet M8-011) | Chuyển app M8 từ .61 sang .99: kịch bản pha `kiem`/`a`/`mo-64`/`b`/`allow --ip`/`sao-luu`/`d`/`quay-lui`, CD `deploy_m8_99` | R3/S | Lead duyệt push `7f12ddaf` + lượt duyệt liền; .64 mở (xong 13/11); m12 → m34 cắt xong trước pha `b` | sau m34 cắt (~15–16/11) | 6 (còn lại) | Mã xong, local `7f12ddaf`; mọi pha trên máy CHƯA CHẠY ([phiếu](wp/chuyen-may-99.md)) |
| 01E mới | Nghiệm thu trên .99: E02 lặp, rồi E01, E06-A, E03, E05/E06-B, E10; điền phiếu | R2/S | 02K xong; m34 trên .99 + `ca-m8.pem` mới + cầu 8445; trong khung gọi 08:00–21:08 | 1–2 ngày sau cắt (~16–17/11) | 8 | ĐANG LÀM: E02 lặp .99 ĐẠT 14/11 08:49 (đơn 577, [đối soát](ra-soat/2026-11-14-e02-lap-99-doi-soat.json)); E01 ĐẠT 14/11 09:36 ([đối soát](ra-soat/2026-11-14-e01-99.md)); E06-A ĐẠT 14/11 10:10 ([ghi chú](ra-soat/2026-11-14-e06a-99.md)); E03 ĐẠT 14/11 10:23 ([ghi chú](ra-soat/2026-11-14-e03-99.md)); còn E05/E06-B, E10 ([phiếu](wp/nghiem-thu-tren-99.md)); E02 .60/.61 làm bằng chứng đã có |
| 02M mới | CI xanh trên đúng bản sẽ lên: xem pipeline GitLab của `af93ca42`; điều tra `IT-IMG-E2E-05` chập chờn; `refresh-locks` (phiên phụ làm, không chạy song song) | R1/S | commit refresh-locks của phiên phụ vào main | trước push kế | 4 | Chưa làm |
| 01D | Gọi số nội bộ thật cùng callback M3 trên .99 (mã tắt Asterisk khi bật hồ sơ sandbox M3) | R3/A | 01E, 02I (.64 bản mới), số nội bộ Lead cấp | sau 15/11, trước 30/11 | 8 (ước) | Chưa làm |
| 07G mới | m8.78: hạn mức không che 403/404 (XONG phần mã: W-0536 `855a57c2` + `1ec9e911`, verifier R3 ĐẠT 13/11, local chưa push); còn: m8.81 và hợp đồng draft.45 (enum `sales-platform`, 401 vs 403, 6 lối nội bộ khai 429), 400-trước-401 ở lối nội bộ | R3/A | Lead quyết m8.81; sửa hợp đồng đổi hash draft.45 → báo m34 một lần | sau 15/11 | 6 (còn lại, ước) | m8.78 đã làm local; phần hợp đồng chờ m8.81 |
| 04B | Làm nóng 3.318 cụm trên .99, đo CPU (≈1,75 giờ máy); gói 455 tên gửi Chú | R2/A | 02K (kho clip chuyển sang .99); Chú duyệt | sau cắt | 4 | Công cụ đã gộp W-0520; CHƯA CHẠY ([phiếu](wp/M8-WP04B.md)) |
| 03B | Restore thật trên .99 vào DB tách riêng, đo RTO; 45 migration từ DB rỗng; cron sao lưu; nối kho ngoài khi có | R3/A | 02K; Anh Tuấn kho | sau cắt | 4 | Công cụ đã gộp W-0522; diễn tập máy thật CHƯA CHẠY; `dien_tap_khoi_phuc.py` mặc định `~/m8`, .99 phải truyền `/data/ginsengfood-ivr` ([phiếu](wp/M8-WP03B.md)) |
| 07E | Đo ma trận lối vào 401/403/429 trên máy thật (`do_loi_vao.py`; `--loat-429` chỉ sau khi báo M3) | R3/A | 02K | sau cắt | 2 | Test + công cụ đã gộp W-0526; đo CHƯA CHẠY ([phiếu](wp/M8-WP07E.md)) |
| 02J | Diễn tập công tắc tắt khẩn + luật cảnh báo trên máy thật; người nhận chờ m8.73 | R2/A | 02K | sau cắt | 3 | Công cụ đã gộp W-0525; CHƯA CHẠY ([phiếu](wp/M8-WP02J.md)) |
| 02I | .64 lên bản mới; secret media-sync .99 → .64 (media-token, ARI TLS) | R3/A | Anh Tuấn sudo + khung bảo trì .64 + chỗ cất khoá; custody | 18/11 | 14 | Chưa làm (chưa có phiếu); ARI .99 → .64 đã mở cổng |
| [07V](wp/M8-WP07V.md) | Bộ giọng/artifact được duyệt | R3/A | Chú: lời thoại, pháp lý, kho artifact | 20/11 | 10 | CHẶN ngoài |
| [07B](wp/M8-WP07B.md) | Đóng và kiểm bộ ứng viên đủ định danh | R2/A | 07V-L, 02I | 22/11 | 10 | LAB monitoring đạt; 07B-L chờ |
| [05](wp/M8-WP05.md) | Worker M8 → MobiFone thật, đủ ca phím/busy/không nghe | R3/A | 02I, 07B-L, kênh + grant MobiFone | 24/11 | 8 | CHẶN |
| [08](wp/M8-WP08.md) | Đo tải thật, chốt quy mô (mô phỏng chạy lại được sớm, cần cửa sổ độc quyền; .99 dùng chung 6 nhân) | R3/A | 05 | 26/11 | 6 | CHẶN |
| [02F](wp/M8-WP02F.md) | Lên production bằng `trien-khai.sh` + phiếu kiểm, nghiệm thu vận hành; phiếu đọc lại theo `/data/ginsengfood-ivr` (D-m8-068) | R3/A | 07B-L, 02I, custody, cửa sổ | 27–28/11 | 12 | D020 xong `005bc43d`; viết lại cho .99 |
| 07F | Hồ sơ phát hành: rà 161 mục, danh sách chữ ký, sinh lại board | R1/S | 01E, 05, 08 | 28/11 | 6 | Chưa làm |
| [06](wp/M8-WP06.md) | Ngoại mạng, nhà mạng thứ hai | R3/A | Giấy định danh | sau 20/11, chốt lại | 6 | CHẶN |

**Tiêu chí đạt và tệp nóng của WP mới/đổi** (phiếu `wp/` lập khi giao sóng):

| WP | Tiêu chí đạt | Phạm vi ghi · tệp nóng |
|---|---|---|
| 02K | Push `7f12ddaf`; `kiem`, `a`, `b`, `allow --ip`, `sao-luu`, `d` đạt; `/health/live` 8443 trên .99 200; 10 dịch vụ chạy đúng SHA; so số dòng từng bảng khớp; quay lui thử được | `deploy/m8/may-99/**`, `compose.yml`, `trien-khai.sh`, `noi-m3/{dat-cau-hinh,lan-thu}.sh`, CD · **chỉ phiên phụ ghi** |
| 01E | E02 .99 `KHOP`; E01 401/403/403 + `so_task=0`; E06-A `TASK_REVOKED`, 0 lượt gọi; E03 xác nhận + hủy (kịch bản bấm 0) `KHOP`; E05/E06-B `RETRY_EXHAUSTED` rồi replay; E10 `sau-luot`, receipt sha256, đối soát trước/sau thu dọn; mỗi ca có correlation M3 → job → callback | `docs/evidence/` (WP mới từ W-0535), `~/…/nghiem-thu/` trên .99; **không sửa `deploy/m8`** khi 02K còn chạy |
| 02M | Pipeline GitLab của HEAD xanh, hoặc từng job đỏ có nguyên nhân + việc sửa; `IT-IMG-E2E-05` giải thích | `deploy/ci/**`, khóa gói (sau commit refresh-locks của phiên phụ) |
| 07G | m8.78 theo phương án Lead chọn: 6 lối nội bộ + hạn mức không che 403/404; test KDL-43 đổi; m8.81 hợp đồng và hash mới báo m34 | `src/Ivr.Api/Middleware`, `Internal`, `specs/api/` · **nóng:** hash draft.45 M3 đã ghim |
| 04B / 03B / 07E / 02J | Như phiếu cũ, chạy trên .99 (đường `/data/ginsengfood-ivr`, project compose `m8`) | công cụ đã gộp; chỉ phiên chính chạy trên máy, không giao subagent |

Tệp một người ghi giữ như `PHIEN.md` (register, gate-status, traceability, migration + snapshot, compose/appsettings chung).

## Sóng đề xuất

| Sóng | Khi | L1 | L2 | L3 | Tài liệu |
|---|---|---|---|---|---|
| 1 | 13–16/11 | 02K (phiên phụ, R3): push, `kiem`, `a`, `mo-64`; `b` sau m34 cắt | 02M (R1): pipeline + `IT-IMG-E2E-05`, sau commit refresh-locks | — (m8 chính: báo m34 giờ cắt, đổi callback .61 khi m34 cắt) | tin nhóm Phúc/Tài trước pha `b` |
| 2 | sau cắt (~16–19/11) | 01E (R2): E02 lặp → E01 → E06-A → E03 → E05/E06-B → E10 | 03B + 04B + 02J (chạy trên máy, tuần tự) | 07E đo (R3) | biên bản UAT, phiếu E01–E10 |
| 3 | 18–28/11 | 02I → 05 → 08 → 02F (R3, nối tiếp) | 07V, 07B (Chú) | 07G (sau Lead quyết), 07F | gói phát hành |

Tệp nóng không chồng: sóng 1 `deploy/m8/may-99` (phiên phụ) · `deploy/ci` (02M); sóng 2 `docs/evidence` + việc chạy trên máy (một người một lúc); sóng 3 `src/Ivr.Api` (07G) · `deploy/telephony-vm` (02I).
Tối đa 3 agent nặng cùng lúc gồm cả tester/verifier; việc trên máy chủ do phiên chính (hoặc phiên phụ cho 02K) chạy theo lệnh Lead, không giao subagent.

**Kiểm chéo:** 8/8 hạng mục dưới 90 có WP (lõi: 01E, 02M; nối M3: 01E; tổng đài: 02I, 05; giọng: 04B, 07V; Giờ Vàng: 08; cài máy: 02K, 02I; sao lưu: 03B; hồ sơ: 07F). Tổng 121 giờ AI còn lại (02K 6, 01E 8, 02M 4, 01D 8, 07G 10, 04B 4, 03B 4, 07E 2, 02J 3, 02I 14, 07V 10, 07B 10, 05 8, 08 6, 02F 12, 07F 6, 06 6). Tới 17/11 cần khoảng 31 giờ (02K, 01E, 02M, 03B, 04B, 07E, 02J) trên 3 làn ≈ 10 giờ/làn: làm được nếu cắt .99 chạy trong 15–16/11; nút thắt không phải giờ code mà là thứ tự cắt (m12 → m34 → m8), quyền sudo/khung bảo trì .64 và việc ngoài (Chú, MobiFone, Anh Tuấn).

## Đường găng tới mốc A–D

| Mốc | Ngày | Cần có | Trạng thái · cách xử lý |
|---|---|---|---|
| A Xong chức năng | 07/11 | Mọi hạng mục ≥ 50, trên nhánh chung, lên máy thử | Đạt muộn 09/11 trừ hồ sơ phát hành (30) |
| B Nối liên module | 10/11 → **13/11** | M3 .60 nối M8 thật .61, một đơn thử | **Đạt 13/11 14:32** ở mức một đơn MOCK (E02 KHỚP). Trên .99 phải lặp |
| C Nghiệm thu | 12/11 → 14/11 → **~17/11** | Lead UAT phiếu E01–E10 trên máy chính thức .99 | D-m34-065 dời sang .99; phụ thuộc 02K cắt xong (m12 → m34 → m8). Nghiệm thu đầy đủ (lời thoại, pháp lý, nhà mạng) ~25/11 |
| D Chạy thật | 14/11 → **28/11** | Bản đã nghiệm thu lên production, smoke, quay lui | Production: 07V 20/11 → 07B 22/11 → 02I + 05 24/11 → 08 26/11 → 02F 27–28/11; trên .99/.64 |
| Hạn chung | 30/11 | Gọi khách thật nội mạng MobiFone | Ngoại mạng nếu giấy định danh về kịp |

## Việc ngoài code (phiên `lead` gom về `modules/lead/VIEC_NGOAI.md`, bản đó cũ từ 02/11)

Ngày là ngày kế hoạch cần, không phải cam kết của người gỡ. Trạng thái chỉ ghi "đã" khi thấy tệp/tin chứng minh.

| Việc | Ai gỡ | Cần trước | Trạng thái |
|---|---|---|---|
| .64 cho .99 vào cầu ARI | Lead (sudo) | 13/11 | **XONG 16:08** |
| `sudo mv` tạo `/data/ginsengfood-ivr` + `/data/sao-luu/ginsengfood-ivr` | Lead | trước pha `a` | **XONG 15:15** (phiếu 02K còn ghi chưa làm) |
| Duyệt push `7f12ddaf` (và W-0534 `eb5156ff` nếu muốn) | Lead | trước khi cắt | Chờ |
| m12 rồi m34 cắt sang .99 xong; m34 đổi `M8_ORIGIN` + ghim `ca-m8.pem` mới, đo `M8_ALLOW_IP` | Lead (phiên m12, m34) | trước pha `b` của m8 | m12 dự kiến 13/11 22:30; m34 14/11 (không cắt giữa buổi chạy mốc D) |
| Nhắn nhóm Phúc, Tài: M8 dừng nhận đơn ~20 phút lúc pha `b` | Lead | trước pha `b` | Chưa |
| Quyết m8.78, m8.81 | Lead | — | Chờ |
| Đổi mật khẩu sudo `ssv` .61 và mật khẩu đã gõ vào chat (09/11, 12/11) | Lead | ngay | Chưa có bằng chứng |
| Kho sao lưu ngoài máy cho M8 (đích .99), RPO/RTO | Anh Tuấn | 12/11 (trễ từ 07/11) | Chưa; Sheet M8-003 Bị chặn |
| Chỗ cất khoá media-token + ARI TLS, người giữ dự phòng | Anh Tuấn + Lead | 13/11; custody 25/11 | Chưa |
| .64: khung bảo trì để lên bản mới (02I) | Lead + Anh Tuấn | 18/11 | Chưa |
| Kênh nhận cảnh báo ngoài giờ + người trực | Lead | 13/11 | Chưa chọn (m8.73 gác, D-m8-075) |
| Lời thoại 3 miền + 455 tên | Chú | 14/11 | Chưa có kết quả; `VIEC_NGOAI.md` ghi "chưa gửi", TRANG_THAI ghi bản nghe gửi 09/11: lệch, Lead xác nhận |
| Pháp lý VieNeu, kho artifact (DF-03, G-LEGAL) | Chú / Lead | 18/11 (07V 20/11) | Chưa |
| MobiFone: xác nhận 36 kênh/2 CPS, DTMF, đầu mối, hẹn thử ~24/11 | Lead | trả lời 18/11 | Chưa thấy đã gửi (Sheet M8-005 Bị chặn, quá hạn 11/11) |
| Giấy định danh → ngoại mạng | Đơn vị dịch vụ / Lead | ~20/11 | Hồ sơ gửi 31/10; Sheet M8-006 Bị chặn, chưa biết ngày |
| Custody khoá production + người dự phòng | Lead | 25/11 (trước 02F) | Chưa (D-m8-010) |
| Biến CI `M8_99_DEPLOY_SSH_KEY`, `M8_99_DEPLOY_KNOWN_HOSTS`, environment `m8-99`, `authorized_keys` .99 | Lead | để đưa ảnh 10.0.15 lên .99 (không chặn cắt) | Chưa |
| Protected environment GitLab (Premium) hoặc chấp nhận cách thay | Lead | 25/11 | Chưa |
| Xoay token Sheet cũ (6 repo) | phiên lead | trước 30/11 | Chưa thấy bằng chứng (`hop-thu/lead-2026-11-05-m8-xoay-token-sheet.md`) |
| Tên miền `admin.` cho M8 qua proxy | Anh Tuấn; phiên lead | — | DNS `admin` đã xoá (theo nhật ký phiên lead 13/11); M8 8443 chỉ LAN; có còn cần UI admin M8 từ ngoài: KHÔNG XÁC MINH ĐƯỢC |

## Không kịp 15/11 + bản tối thiểu chạy được 15/11

- **Không kịp 15/11:** nghiệm thu đầy đủ trên máy chính thức .99 (mốc C trượt ~17/11, tuỳ lúc m8 cắt), gọi khách thật (cần lời thoại, pháp lý, xác nhận kênh, custody), .64 bản mới, đo tải qua nhà mạng, lên production → 24–28/11; ngoại mạng sau giấy định danh.
- **Bản tối thiểu 15/11 (D-m8-069, D-m8-076):** một đơn M3 → M8 thật → gọi MOCK → callback `ACCEPTED`, M3 áp một lần, không gọi số thật: **đã chạy 13/11 14:32** trên cặp .60/.61 (E02 KHỚP, `docs/evidence/W-0534`). Giữ lại trên .99: E02 lặp + E01 + E06-A + E03 + E05/E06-B + E10 sau cắt (01E); restore thử, công tắc tắt khẩn thử, làm nóng kho tên phường chạy trên .99 (03B, 02J, 04B). `REAL_CUSTOMER_CALL_ALLOWED=NO` giữ nguyên.
- **Nếu cắt .99 trễ hoặc lùi:** M3 và M8 về cặp .60/.61 (đường lui nguyên vẹn: `chuyen.sh quay-lui`; lưu ý `quay-lui` KHÔNG chép dữ liệu ghi trên .99 ngược về .61); bản tối thiểu vẫn là E02 13/11, ghi rõ không phải trên máy chính thức.

## Rủi ro lớn nhất

1. **Cắt .99 chưa chạy pha nào trên máy thật, không có verifier độc lập** (`docs/evidence/W-0533`); thời gian dừng app .61 "chưa đo"; `quay-lui` không chép dữ liệu ngược (đơn ghi trên .99 sau cắt mất nếu lui).
2. **Đường nối M3 ↔ M8 trên cùng .99 và CI:** IP nguồn qua NAT Docker chưa đo (nginx 8443 sẽ 403 tới khi `allow --ip`), chứng thư tự ký mới chưa thử với be Java; CI GitLab các commit sau `10f335de` chưa kiểm (quét trước push cục bộ PASS trên `eca6670f`); ảnh chuyển sang vẫn runtime 10.0.14 (3 CVE HIGH) tới khi CD `deploy_m8_99` chạy.
3. **Gọi khách thật trước 30/11 phụ thuộc việc ngoài** (Chú duyệt lời thoại và pháp lý, MobiFone, kho sao lưu ngoài máy, custody, .64 khung bảo trì): nhiều việc đã quá hạn hoặc chưa có bằng chứng đã gửi.

## Quyết định và câu còn mở

- Đã chốt: D-m8-068…077 (10–11/11); D-m8-076 (15/11 gọi MOCK); D-m8-078 (cách làm); D-m8-099 (13/11): nghiệm thu còn lại dời sang .99 (D-m34-065); D-m8-100/101 (không đụng phiên phụ; cắt là việc phiên phụ theo D-lead-038).
- Lead trả lời 13/11 (D-m8-102): m8.78 làm (W-0536 `855a57c2`: hạn mức chỉ tính ở lối quản trị; 07G còn phần hợp đồng cùng m8.81); m8.83 bỏ (dev/test, không chép dữ liệu ngược khi quay lui); m8.84 làm 02M; m8.85 người trực = Nguyễn Quốc Toàn (đổi được), kênh nhận cảnh báo chưa chọn, không gấp. **Còn mở:** m8.81 (hợp đồng: enum `sales-platform`, 401 vs 403, và 6 lối nội bộ khai 429; sửa đổi hash draft.45, báo m34 một lần).
