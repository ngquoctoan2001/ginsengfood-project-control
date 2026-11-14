# Sẵn sàng — M7 Video Giờ Vàng

Mốc: 11/11/2026 19:30 · main `cb7304a` (origin `64b0176`, 18 commit chưa push) · % sẵn sàng: **15** (10/11: 11; 07/11: 9) · Kịp 15/11: **ĐỎ**
- Mốc 1 còn 21 task, 175 giờ ước (sáng 10/11: 336). Từ sáng 10/11 đến tối 11/11 xong 23 task Mốc 1, khoảng 160 giờ ước, tức khoảng 115 giờ ước/ngày nhờ nhiều làn song song; 4 ngày còn lại cần khoảng 50 giờ ước/ngày.
- Điều kiện nhịp (làn .NET chạy liền) đã đạt. Vẫn ĐỎ vì dữ liệu CTA, hồ sơ sản phẩm chưa tới tay (m7.147 A, Toàn sẽ gửi, D-m7-074); tài khoản Muse đã có (m7.146, D-m7-073), còn việc Toàn đăng nhập tay vào hồ sơ Chrome của worker.
- Muse chưa có dòng mã nào (T064, T189 chờ tài khoản). Khung worker máy để bàn T058, T035, T080 đã giao, đang kiểm.

Mốc 1 thành **VÀNG** nếu có đủ cả ba điều kiện:
- 4 làn .NET chạy liền từ chiều 10/11, không bị ngắt hạn mức;
- Muse đăng nhập trước 12/11;
- CTA và hồ sơ sản phẩm có trước 12/11.

Ở nhịp cao nhất đã đo, video ra khoảng 16–17/11.

Đích (D-m7-063, m7.113 A):
- **Mốc 1 · 15/11:** luồng tự động tạo video ngắn chạy trọn bằng bộ máy thật: Claude thuê bao, VieNeu, faster-whisper, ảnh/clip Muse, ffmpeg. Kết quả là một video thật 95–120 giây ghép nhiều clip; dưới 91 giây thì không đạt.
- **Mốc 2 · 30/11:** chương trình 70 phút và mọi phần còn lại: xu hướng, phát, nối thật M3/M2/M1/Kho Media/M6/IdP, lên .60, nghiệm thu, kho ảnh/nhân vật (WP29). Bật chạy thật do Lead quyết riêng.
  - Kịp Mốc 2: **ĐỎ**. Cần 942 giờ ước trong 15 ngày, tức 63/ngày. 110/135 task phải chờ Mốc 1 xong.

Nguồn: 4 scout `/ke-hoach` ngày 10/11 (Mốc 1; Mốc 2 + G2; câu mở + G3–G6; L0, kiểm thử, nhịp đo) và kế hoạch repo `docs/04-sdlc/IMPLEMENTATION_PLAN.md` (219 task, 1.535 giờ ước; đã xong 38–40 task).
Thang `chung/CONG_PRODUCTION.md` §1: chưa có gì chạy trên máy chủ nên trần là 50.

## Hạng mục lõi (tổng trọng số 100, giữ trọng số 03/11 = tỉ lệ giờ ước)

| Hạng mục | Task | Trọng số | Bậc | Mốc | Bằng chứng / còn thiếu |
|---|---|---|---|---|---|
| H1 Khung hệ thống: đăng nhập, quyền, audit, bí mật, đóng gói | T001–T016, T018, T175 | 11 | 40 | 1: T014, T188 · 2: T018, T175 | 16/18 task, 114/128 giờ (T008 `cc21294`, T012 `5a11375`, T013 `dcff00b`, T014 `f4dedfe` công tắc dừng toàn cục, T188, T192 `b30574d`). Còn T018, T175 (Mốc 2). T003 CI: có commit `056639b` nhưng Sheet ghi Bị chặn vì CI tắt |
| H2 Bộ chặn nội dung, bộ luật, AI viết kịch bản | T020–T036, T072 | 11 | 40 | 1: T026, T029, T030, T034–T036 · 2: T028, T031, T072 | 14/18 task, 100/126 giờ (T026 `4c5eaab`, T029 `6981c3f`, T030 `7cec5bb`, T034 `a6011c4`, T036 `11fd24d`). Còn T035 (coder xong, verifier kiểm, chờ m7.160 và m7.161), T028, T031, T072. Adapter Claude có mã và test với CLI giả, chưa gọi Claude thật (cần khoá, m7.158) |
| H3 Xem, duyệt, QA, nhãn AI | T038–T042 | 3 | 50 | 1 | 5/5 task (T039 `2060a0a`, T040 `b6f3781`, T041 `c5e92a0`, T042 `9235062`; T038 thiết kế). Xong mã: bộ kiểm đủ XANH trên `a6011c4` 11/11 (lớp 1). Chưa chạy trên máy chủ chạy thử |
| H4 Studio dựng video: giọng, phụ đề, ảnh/clip, ghép | T045–T076, T103 | 20 | 20 | 1: T048–T050, T053–T056, T058, T060–T064, T068, T069, T076, T189 · 2: phần còn lại | 14/33 task, 103/239 giờ (T048 `eadd495`, T049 `5f9cb5e`, T050 `289c80e`, T053 `8983fc0`, T054 `b26f5d9`, T055 `9c1eee1`, T056 `6f046ad`, T062 `35062a7`, T063 `9ad44a3`, T073 `2fede93`). Có bước AUTO_CHECK (ffprobe, ffmpeg thật), IMAGE_PROMPT, SUBTITLE, cổng worker và kết quả bước. Còn khung worker máy để bàn T058 (coder xong, đang kiểm), TTS, ASR, RENDER, Muse: 0 tệp mã |
| H5 Video ngắn, gói xuất, nghiệm thu đợt 1 | T077–T091, T104, T105 | 10 | 10 | 1: T043, T079–T085, T087–T090, T190, T191 · 2: T086, T091, T104, T105 | 3/17 task, 18/129 giờ (T077 thiết kế, T078 `0ae4ba4` CSDL, T079 `a9b6604` loại video ngắn; T043 `cb7304a` cổng ops-core giả). T080 coder xong, đang kiểm |
| H6 Xu hướng nhập tay | T092–T102, T107, T108, T120 | 6 | 0 | 2 | Chỉ có thiết kế T092 `3b03cc0` |
| H7 Chương trình 70 phút | T109–T135 | 16 | 0 | 2 | Chưa có commit; `git ls-files src` không có tệp program/master |
| H8 Phát, lịch phát, tín hiệu M6, nghiệm thu đợt 2 | T136–T163 | 16 | 0 | 2 | Chưa có commit |
| H9 Nối thật module khác, lên chạy thật | T164–T174 | 7 | 0 | 2 (T174 Lead quyết) | M7 chưa có adapter nào gọi module khác. `deploy/compose/dev-idp/server.mjs` chỉ dùng cho dev |

% = (40×11 + 40×11 + 50×3 + 20×20 + 10×10) / 100 = 15,3 → **15**. H2 lên 40, H3 lên 50 và H4 lên 20 nhờ sóng 1 và sóng 2 ngày 10–11/11. Bậc 10–40 là ước theo phần chức năng con đã xong (giờ ước đã xong trên giờ ước của hạng mục); chưa hạng mục nào lên 75 vì chưa có gì chạy trên máy chủ chạy thử.

Kiểm tự động chạy lúc 11/11 13:44–19:11 trên `a6011c4` (bộ kiểm đủ một lần, D-lead-030; log `scratchpad/song1/full-suite-a6011c4.log`):
- Build: 0 lỗi, 0 cảnh báo.
- Test .NET: Contract 56, Architecture 633, Domain 3.810, GuardCorpus 1.975 đạt, 0 trượt.
- Integration: 4.784 đạt, 5 bỏ qua có chủ ý, 0 trượt; chạy từng namespace (41 lớp). T011 và T030 đỏ 1 ca ở lượt đầu lúc máy kín CPU (một ca nhạy thời gian, một ca đồng thời), chạy riêng đạt 126/126 và 42/42.
- Web: typecheck, lint, format đạt; vitest 1.167 đạt; build đạt (cài sạch `npm ci`).
- Docs: 0 lỗi, 11 cảnh báo cũ. Truy vết `gen_traceability --check`: đạt, TASK=219.
- Chưa chạy: máy chủ chạy thử (lớp 2), gọi Claude, VieNeu, faster-whisper, Muse thật.

**Hạng mục mở rộng (không tính vào %):**

| Hạng mục | Task | Bậc | Mốc | Ghi chú |
|---|---|---|---|---|
| E1 Kho ảnh tham chiếu, kho nhân vật, cổng ảnh, Muse nhiều tài khoản (D-m7-064…066) | T193–T219 | 0 | 2 | WP29, 27 task, 194 giờ, Sheet M7-213…239. Thêm sau ngày chốt trọng số |

## Nhịp đo thật (Sheet `doneDate` + `git log`)

| Kỳ | Giờ ước xong/ngày | Ghi chú |
|---|---|---|
| 03–05/11 | 04/11: 62 · 05/11: 54 | Cao nhất đã đo. Một giờ ước tốn 0,47 giờ thật, gồm cả kiểm độc lập |
| 07/11 | 18 | Hết hạn mức 5 giờ, dừng 7 agent. RAM trống khoảng 3,9 GB |
| 08/11 | 0 | Không chạy |
| 09/11 | 38 | Ngắt hạn mức lúc 15:35. RAM trống còn 0,54 GB |
| 10/11 (tới 10:20) | 16 | Gộp T013, T039 |
| Cần đạt | Mốc 1: 67/ngày (10–14/11) · Mốc 2: 63/ngày (16–30/11, làm cả Chủ nhật) | Cao hơn mọi mức đã đo. Nút thắt là hạn mức công cụ và RAM, không phải đường găng |

## Cổng G1–G8 (`chung/CONG_PRODUCTION.md` §3)

| Cổng | Trạng thái | Đã có · thiếu gì · hạn |
|---|---|---|
| G1 Chức năng lõi | chưa | Mốc 1: luồng video ngắn thật (WP07–WP11, WP22). Mốc 2: 70 phút, phát, xu hướng |
| G2 Liên module | chưa | 3/11 điểm nối đã có mã phía láng giềng: M3 phiên Giờ Vàng (`PublicGoldenHourController.java:30` @`67f358ed9`; nay bắt buộc `?locale=`, adapter phải bỏ giá), ops-core availability, M1 ProductPublicView. 8 điểm chưa có: M3 snapshot và số bán SKU, claim M1, Kho Media `usable-ranges`, tín hiệu và chỉ số M6, IdP, hợp đồng contracts. Tài khoản `availability-v1` và `SVC-M7` chưa tạo. Hạn 17–24/11 |
| G3 Bảo mật | chưa | **Có:** OIDC/BFF, RBAC, quyền duyệt dùng chung (T008), audit HMAC (T011), bí mật bắt buộc (T013), quét PII (T012), CSRF trả 403. **Thiếu:** T176 giới hạn tần suất, T177 bí mật dạng thư mục, T180 mã hoá khoá DataProtection; tất cả trước T103 (18/11). Lỗi CSRF trả 500 chưa có task (`docs/04-sdlc/tasks/M7-T015.md:195`). Quét bí mật có cấu hình nhưng chưa chạy lần nào (CI tắt). IdP .60 |
| G4 Dữ liệu | chưa | **Có:** 10 migration, vai DB tách (`deploy/db/init-roles.sql`), seed thử, `m7-migrate`. **Thiếu:** test nâng từ bản đang chạy, sao lưu T179, khôi phục T161 (chờ DL-O56), xoá theo hạn T153/T178 (chờ DL-O52), ổ kho .60 |
| G5 Triển khai | chưa | **Có:** Dockerfile nhiều tầng chạy non-root, compose `m7` 7 dịch vụ, health, kiểm khói 15/15 (T015 `23961bb`). **Thiếu:** phụ lục 9 điểm deploy contract (`deploy@225c586` còn mô tả M7 cũ), chỗ và cổng .60, chứng chỉ `m7-edge`, khoá audit .60, kho S3 T175, registry/CD theo D-lead-017/018, ảnh `worker` thiếu ffmpeg và Claude CLI (`deploy/docker/Dockerfile:12`). Hạn 18/11 |
| G6 Vận hành | chưa | **Có:** log có mã tương quan và che dữ liệu, OTLP, metric `m7_audit_chain_ok`, runbook RU-10…RU-45 (chưa diễn tập). **Thiếu:** công tắc dừng T014 (Mốc 1), cảnh báo T044, diễn tập runbook (Mốc 2) |
| G7 Kiểm thử | chưa | CI tắt (D-m7-023, D-m7-067 m7.112 không duyệt bật lại). Thay bằng build/test/docs/trace chạy tay, verifier độc lập và đột biến. Web test CHƯA CHẠY. TC-UAT: 34 dòng TODO (`TEST_STRATEGY.md` §14). TC-NPERF-001…005 TODO |
| G8 Ngoài code | chưa | Máy dev đủ cho Mốc 1 (T192 vòng 4: ffmpeg 8.1.2, VieNeu, faster-whisper, Claude CLI đã đăng nhập). Còn Muse và CTA/hồ sơ SP (chặn Mốc 1); .60, IdP, láng giềng (chặn Mốc 2). Chi tiết ở bảng dưới |

## Gói việc

Luật làn (D-m7-056, D-m7-061, m7.117):
- Mỗi task một clone `_wt/m7/code-<task>`, kiểm ở `kiem-<task>`. R1/R2 commit khi verifier ĐẠT; R3 chờ Lead "ok gộp". Chưa push nếu Lead chưa nói.
- Tối đa 4 làn .NET + 1 web + 1 tài liệu/dữ liệu. Làn D chỉ mở khi RAM trống ≥ 6 GB (đo lúc 10/11 10:17: 8,1 GB).

**Mốc 1 (45 task, 336 giờ ước, trong đó làn web 51 giờ):**

| WP | Task còn · giờ ước | Tiêu chí đạt | Phạm vi ghi · tệp nóng | Rủi ro | Phụ thuộc | Hạn | Trạng thái |
|---|---|---|---|---|---|---|---|
| M7-WP07 L0 còn lại | T014 (6), T188 (5) · 11 | Công tắc dừng chặn mọi adapter thật khi bật, có test. Chuỗi audit hỏng bị phát hiện và xác nhận được theo RU-27 | `Config/**`, `Audit/**` · migration chỉ khi T188 cần, và chỉ làn này | R3 (T014), R2 | T013 xong | T014 10/11 · T188 11/11 | T008, T012, T013, T192 xong; T014 có nền T013 |
| M7-WP08 Bộ chặn, bộ luật | T026 (8), T029 (8), T030 (6) · 22 | Có bộ luật TPBVSK theo loại SP, API bộ luật, hồ sơ tuân thủ SP. Guard ACTIVE chặn claim và CTA ngoài danh sách | `ContentGuard/**`, `Evidence/**` · `ContentGuardRegistration.cs`, `EvidenceRegistration.cs` | R2 | — | 11/11 | T023–T025, T027 xong |
| M7-WP09 AI viết, duyệt, nhãn AI | T034 (8), T035 (6), T036 (8), T040 (8), T041 (8), T042 (6, web) · 44 | Claude thuê bao viết kịch bản đúng lược đồ, chặn được chèn lệnh. Mẫu prompt có phiên bản. Có duyệt dùng chung và nhãn AI | `AiLayer/**`, `prompts/**`, `Review/**` · `AiLayerRegistration.cs`, `QaReviewRegistration.cs` | R2 | T014 → T034 | T034–T036 11/11 · T040–T042 12/11 | T039 xong; T040 có nền T039 |
| M7-WP10 Studio thật | T048–T050, T053–T056, T058, T060–T064, T068, T069, T076, T189 · 133 | Một lượt Studio trên máy dev: giọng VieNeu, kiểm lời faster-whisper, ảnh/clip Muse, phụ đề, ffmpeg dựng, nhãn AI trên hình. AUTO_CHECK ffprobe đạt | `Studio/**`, `VideoToolkit/**`, `Worker/**`, worker Python mới · `StudioEngineRegistration.cs`, `WorkerHost.cs` | R2 | T040 → T048; Muse (X8) cho T064, T189 | 14/11 | T045–T047, T052, T073 xong; Muse chưa có mã |
| M7-WP11 Video ngắn tới gói xuất | T043, T079–T085, T087–T090, T191, T190 · 113 | Đi trọn brief → kịch bản → guard → Studio → duyệt → gói xuất. T190 ra một video 95–120 giây ghép nhiều clip | `ShortVideo/**` (mới), các màn web video ngắn · menu web | R2 | WP08, WP09, WP10; CTA/hồ sơ SP (X12) cho T191 | 14/11 · T190 14–15/11 | T077, T078 xong |
| M7-WP22 Nền giao diện | T183 (4), T184 (4), T185 (5) · 13 | Có thành phần nhập liệu, lớp phủ và dữ liệu theo kho giao diện | `web/src/components/ui/**` | R2 | — | 11/11 | Dở trong `_wt/m7/code-T183…T185` từ 06/11 |

**Mốc 2 (135 task, 942 giờ ước):**

| WP | Task · giờ ước | Tiêu chí đạt | Rủi ro | Phụ thuộc · mở được ngay | Mở | Trạng thái |
|---|---|---|---|---|---|---|
| M7-WP12 Xu hướng | T093–T102, T107, T108, T120 · 96 | Nhập tay xu hướng, chấm điểm, bảng xu hướng dùng cho chương trình | R2 | 12/13 task chờ Mốc 1 · T093 mở được ngay | 16/11 | Thiết kế T092 |
| M7-WP25 Chương trình 70 phút | T109–T135 trừ T120 · 188 | Một bản master 4.200 giây thật | R2 | T194, T110 (chờ T014) · T109, T116, T123, T131 | 16/11 | Chưa |
| M7-WP26 Phát, lịch, M6, đợt 2 | T136–T163 · 182 | Lịch phát, gói phát, tín hiệu M6, nghiệm thu đợt 2 | R2 | T136, T144, T149, T156 | 16/11 | Chưa |
| M7-WP13 .60, nghiệm thu đợt 1 | T057, T059, T103–T105, T175–T177 · 56, cộng sửa CSRF 500 (chưa có mã task) và ảnh worker | Lên .60, kiểm khói, TC-UAT đợt 1 | R3 | Chỗ .60 cần trước 18/11 · T175, T176 | 16/11 | Chưa |
| M7-WP27 Nối thật, IdP | T164–T173 · 70 (T174 chờ Lead quyết) | Adapter thật thay giả, chạy được với láng giềng | R3 | Láng giềng 20–24/11, IdP 17/11 · T164, T165, T167–T170 | 16/11 | Chưa |
| M7-WP28 Vận hành, bảo mật, mở rộng | T017–T019, T028, T031, T037, T044, T065–T067, T070–T072, T074, T075, T086, T091, T106, T178–T181 · 156 | Cảnh báo, sao lưu, xoá theo hạn, mã hoá khoá | R2 | T180 | 16/11 | Chưa |
| M7-WP29 Kho ảnh, nhân vật | T193–T219 · 194 | Như phần E1 ở trên | R2 (7 task R3) | T193 | 16/11 | Sheet M7-213…239 |
| Đóng | WP01–06, WP14–21, WP23, WP24 `250873a`, WP30 `1cb3a52` | — | — | — | — | ĐÓNG |

Tệp nóng và cách chia (đã kiểm chéo):
- Không task Mốc 1 nào cần migration mới. Các bảng `gh_review_decision`, `gh_video_asset`, `gh_studio_worker`, `gh_upload_session` đã có trong migration L0–L10 (grep ngày 10/11). Riêng T188 có thể cần migration; nếu cần thì chỉ làn B được viết, và không chạy song song với migration nào khác.
- `ApiHost.cs` và `ApiInfrastructureRegistration.cs` chỉ làn A sửa trong sóng 1. Làn khác ghi dòng đăng ký trong tệp của vùng mình; phiên chính ghép ba chiều khi gộp. `WorkerHost.cs` chỉ làn C sửa.
- Sóng 2 có hai làn chạm Studio (B và C). `StudioEngineRegistration.cs` thuộc C; B để dòng đăng ký cho phiên chính ghép và không sửa `Worker/**`. Làn D (Muse) viết trong thư mục riêng.
- `openapi/m7-api.json` và `web/openapi/m7-api.json`: phiên chính sinh lại sau mỗi sóng. Không làn nào sửa `Directory.Packages.props` hay lockfile.
- Menu web (`web/src/components/AppShell/nav-model.ts`, `nav-keys.ts`, `web/src/lib/auth/nav.ts`): chỉ làn web sửa.

## Sóng Mốc 1

| Sóng | Làn A: AiLayer, Config | Làn B: ContentGuard, Audit, Studio port | Làn C: Studio, worker | Làn D: Review, video ngắn, Muse | Web | Dữ liệu | Giờ ước |
|---|---|---|---|---|---|---|---|
| 1 · chiều 10/11 → 11/11 | T014 → T034 → T035 → T036; T043 | T026, T029 → T030; T188 | T054 → T055; T049, T050 | T040 → T041; T079 | T183, T184, T185 (tiếp clone 06/11) | T191 khi T030 xong và có X12 | 130 |
| 2 · 12–13/11 | T080 → T081 → T082 → T062 | T048 → T056 → T053 | T058 → T060, T061, T063, T068 | T064 → T189 (cần Muse) | T042, T087, T088 | — | 134 |
| 3 · 14/11 → sáng 15/11 | T083 → T084 → T085 | T069 → T076 | — | — | T089, T090 | T190 chạy thật | 72 |

Điểm kiểm: 13/11 18:00. Nếu khi đó T058, T068 hoặc T082 chưa xong thì áp thứ tự cắt ở mục cuối (m7.149).

## Đường găng tới mốc A–D

| Mốc chung | Ngày | Ứng với M7 (D-m7-063) | Trạng thái |
|---|---|---|---|
| A Xong chức năng | 07/11 | Chức năng Mốc 1 xong 14/11 (T085) | Trễ: từ 07/11 mới xong 11/56 task Mốc 1 |
| B Nối liên module | 10/11 | Mốc 1 dùng adapter ops-core giả (T043); nối thật làm ở Mốc 2, 20–24/11 | Không áp dụng cho 15/11 |
| C Nghiệm thu | 12/11 | Mốc 1: Toàn chạy một lượt 15/11 và ký (chờ m7.150). TC-UAT đợt 1 chạy trên .60 ở Mốc 2 | Chưa |
| D Chạy bản tối thiểu | 14/11 | T190: một video 95–120 giây từ luồng thật trên máy dev | Chưa; nằm cuối sóng 3 |

- **Mốc 1, 79 giờ ước (khoảng 37 giờ thật):** T014 → T034 → T035 → T081 → T082 → T083 → T084 → T085 → T190.
  - Nhánh Studio, 70 giờ: T054 → T055 → T056 → T058 → T068 → T069 → T076 → T190.
  - Nhánh Muse, 70 giờ: … T058 → T064 → T065a (4 giờ, tách từ T065: `muse.ui_map` vào lease; 12/11, verifier T064 phát hiện không task nào trên đường găng sở hữu phần máy chủ này) → T189 → T190. Phần còn lại của T065 (WAITING_LOGIN, hạn mức, UI_CHANGED, đường SESSION_EXPIRED với ảnh đệm trung tính thay ảnh chụp màn đăng nhập theo D-m7-078, kèm sửa chữ FR-STU-006 tiêu chí 2 và TC-STU-014 ca 1) và T066 vẫn ở WP28, không nằm trên đường Mốc 1.
  - Nhánh CTA, 34 giờ: T029 → T030 → T191 → T190.
  - Đường găng không phải điểm nghẽn; khối lượng mới là điểm nghẽn.
- **Mốc 2, master 70 phút, 94 giờ ước:** T093 → T194 → T111 → T112 → T113 → T117 → T125 → T126 → T127 → T128 → T132 → T133. T111 còn chờ T110, mà T110 chờ T014.
- **Mốc 2, tất cả, 188 giờ ước:** … T133 → T134 → T138 → T139 → T140 → T150 → T152 → T154 → T162 → T163 → T171 → T172 → T173.
  - Nhánh WP29 tới T218: 88 giờ. Chuỗi lên .60 tới T105: 87 giờ.
- **Sức chứa Mốc 2:**
  - Ở nhịp 50/ngày còn thiếu 192 giờ ước; ở nhịp 35/ngày thiếu 417.
  - Phần Mốc 1 trượt qua 15/11 cộng thẳng vào số thiếu.
  - Chọn giữ đủ phạm vi hay dời WP29: m7.151, hạn 16/11.

| Lịch Mốc 2 | Việc |
|---|---|
| 16–19/11 | T093, T194, T109–T112; bảo mật trước T103 (T175, T176, T177, T180); T057, T059; T193 |
| 20–25/11 | Master T113–T133; T103 lên .60; T104; xu hướng; adapter thật T164–T170 khi láng giềng sẵn sàng |
| 26–30/11 | T134–T163; T171–T173; nghiệm thu T105, T163; WP29 xong |

## Việc ngoài code (phiên `lead` gom về `modules/lead/VIEC_NGOAI.md`)

| Việc | Ai gỡ | Cần trước | Trạng thái |
|---|---|---|---|
| Claude thuê bao, ffmpeg/ffprobe, VieNeu, faster-whisper, ổ trống trên máy dev | Toàn | 09–10/11 | **XONG**: T192 vòng 4 (`ra-soat/2026-11-09-t192/vong4/T192-v4-kiem-may.txt`), exit 0 |
| Tài khoản Muse trả phí, đăng nhập tay vào hồ sơ Chrome của worker (m7.114 A) | Toàn | 12/11 (T064, sóng 2) | **XONG** 13/11 ~14:52: Toàn đã đăng nhập tay vào hồ sơ riêng (`%LOCALAPPDATA%\M7\muse-profile`); còn địa chỉ trang Muse và câu "chạy T189" cho lượt thật |
| Danh sách CTA cho phép (DL-O26), hồ sơ SP mẫu (Giấy xác nhận, câu công dụng) | Toàn | 11/11 tối (T191, sóng 1) | 13/11 Toàn bảo dùng dữ liệu MẪU (D-m7-080, thay D-m7-074): phiên m7 tự nhập ở T191 từ ảnh nhãn; thay bằng dữ liệu thật khi có |
| Thêm tài khoản Muse cho chạy song song; Codex gói ChatGPT Pro trên máy chạy nền | Toàn | 20/11 (WP29) | Codex đã đăng nhập ChatGPT; chưa rõ có phải gói Pro. Muse thêm: chưa |
| Phụ lục 9 điểm deploy contract; thư mục, cổng `m7` trên .60 | phiên `lead`, Anh Tuấn | 18/11 | Hộp thư 03/11, chưa phản hồi |
| Chứng chỉ bền `m7-edge`, tên `video.` (D-lead-029); khoá audit `M7_AUDIT__*` .60 | phiên `lead`, Anh Tuấn; Toàn | 18/11 | Hộp thư 06/11; 3 câu chưa có trả lời |
| Ổ đĩa kho tệp .60 (còn ~500 GB, cần ~630 GB) hoặc NAS | Anh Tuấn | 18/11 | Chưa |
| IdP cho .60 (bộ phát JWT dev bị cấm, SRS IR-IDP-01; DL-O24 của M5 còn mở) | phiên `lead` | 17/11 | Chưa có chủ |
| Đổi địa chỉ nội bộ M7 gọi theo giờ cắt máy chủ (D-lead-034/035/036, `chung/MAY_CHU.md`): `M7_OPSCORE__BASEURL` = `http://192.168.1.99:5000` (M1–M2, từ 13/11 22:30; cổng 5000 mở cho .60), `M7_M3__BASEURL` = `http://192.168.1.99:80` (M3 + M4, từ 14/11 22:45), M5 ở máy mkt 192.168.1.98 (cổng Tài báo) | phiên `lead`, Anh Tuấn (đặt biến ở .60); phiên m7 không ssh | 13/11 22:30; 14/11 22:45 | Biến chưa có giá trị mặc định ở repo (env-reference §4); tới giờ cắt giữ cấu hình cũ. M7 dev local chưa gọi M1/M3 thật (T110, T164…) nên chưa ảnh hưởng Mốc 1 |
| M3: snapshot sản phẩm (không thấy `CommerceRuntimeSnapshot` ở cả 3 nhánh), số bán SKU (chưa có endpoint) | Phúc, phiên `m34` | 20/11, 24/11 | Chưa |
| M6: tín hiệu lần phát (DL-O17, luật `source` contracts), DL-O21 ghi "sau 15/11" | Tài, phiên `m6`, `lead` | 20/11 | Chưa |
| M2/M1: tài khoản `availability-v1` (m12 hạn 14/11), `SVC-M7`, endpoint claim M1; Kho Media `usable-ranges` (mới có spec) | Toàn, phiên `m12` | 20–22/11 | Chưa |
| Hợp đồng M7 trong `ginsengfood-contracts` | phiên `lead` | 20/11 | Chưa |
| Người ký UAT từng mốc (DL-O75) | Toàn | 14/11 | Chưa chốt (m7.150) |
| Pháp chế DL-048, DL-049, DL-O52; page thử Meta, nhãn AI (X16); người trực (DL-O62) | pháp chế, Toàn, Chú | trước bật chạy thật | Chưa; bộ chặn giữ mức chặt; Toàn giữ vai tới 30/11 |

Hộp thư: cả 4 thư M7 (03/11 deploy contract và mã lỗi, 06/11 chứng chỉ, 07/11 hạn mới) vẫn nằm ở `hop-thu/`, chưa thư nào có phản hồi. Sổ lead còn ghi "01–02/2027" (`modules/lead/SAN_SANG.md:33`).

## Câu mở DL-O (25 câu) xếp theo thời điểm cần quyết

- **Chặn Mốc 1:** DL-O26 (CTA, m7.147). DL-O09 (câu chữ nhãn AI) và DL-O11 (GREEN/AMBER/RED) đã có giả định DL-161, DL-110 nên không chặn.
- **Trước 17–20/11 (Mốc 2):**
  - DL-O17: event cho M6.
  - DL-O22 và DL-O63: dọn .61 (từ 13/11 chỉ phần M7 cũ; .61 là đường lui của M1–M2, M8).
  - DL-O56: nơi đặt sao lưu, người giữ khoá (T179).
  - DL-O16, DL-O13, DL-O40, DL-O24, DL-O71.
  - DL-O64: xoay bí mật cũ, nên quyết trước 13/11.
  - DL-O75: người ký UAT, m7.150.
- **Trước bật chạy thật:** DL-O52, DL-O62, DL-O12, DL-O87, DL-O42, DL-O43, DL-O44.
- **Không chặn:** DL-O01, DL-O05, DL-O29. DL-O27 chuyển thành chặn Mốc 2 nếu nối claim M1 thật.
- **Lỗ gán việc:** m7.141 đã duyệt nhưng chưa có task nhận. m7.125 và m7.126 chưa có dòng quyết định riêng.

## Không kịp 15/11 + bản tối thiểu chạy được 15/11

**Bản tối thiểu, không cắt:**
- brief → Claude viết kịch bản (T034–T036, T080–T082); (Mốc 1, D-m7-082/DL-326: kịch bản của video thật T190 do Claude Code viết NGOÀI M7 và nhập qua API; adapter Claude của M7 chạy thật ở Mốc 2);
- bộ chặn ACTIVE với hồ sơ SP và CTA (T026, T029, T030, T191);
- Studio trên máy dev: VieNeu, ảnh/clip Muse, phụ đề, ffmpeg, nhãn AI;
- duyệt (T040, T041, T084), gói xuất (T085);
- T190 ra một video 95–120 giây.
Đi kèm: adapter ops-core giả (T043) và công tắc dừng (T014).

**Thứ tự cắt nếu tới 13/11 18:00 còn chậm (m7.149):** dời sang 16–17/11, video vẫn đi qua API và các màn T087, T090.
1. T188 (5 giờ).
2. T061 kiểm lời faster-whisper (6 giờ); phụ đề lấy từ kịch bản.
3. Màn web T088, T089 và nền T183–T185.

Phần cắt chỉ bớt 11 giờ .NET. Phần còn lại là làn web: bớt tải RAM và hạn mức chứ không rút ngắn chuỗi .NET.

**Nếu thiếu đầu vào:**
- Thiếu Muse tới 12/11: clip thay bằng ảnh tĩnh chuyển động hoặc clip dự phòng M7-205 (m7.110 A). Khi đó không đạt "clip AI tự động", Mốc 1 không tính đạt (plan §4.6).
- Thiếu CTA tới 12/11: dùng dữ liệu mẫu ghi rõ chữ "mẫu". Video vẫn ra nhưng không dùng để phát (m7.147 B; chỉ dùng nếu dữ liệu A chưa tới).

**Mốc 2:** giữ nhịp đã đo thì nối thật và nghiệm thu đợt 2 trượt sang khoảng 03–05/12. Master 70 phút vẫn có thể kịp nếu Mốc 1 xong trước 17/11.
