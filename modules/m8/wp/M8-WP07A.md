# M8-WP07A — Khôi phục các cổng kiểm và xác minh phạm vi quét bí mật

Trạng thái: ĐẠT default gates 51/51; đã commit local · Rủi ro: R2 · Chế độ: A · Mốc: 03/11
Hạng mục nâng: Hồ sơ phát hành 30 → 30 (mở đường kiểm ứng viên) · Sheet: M8-007 · Làn: L3
Ước lượng: 9 giờ công AI (6 coder + 3 verifier; nếu đổi ranh giới scanner chuyển R3 và bổ sung tester); dự toán, chưa phải cam kết thời gian chờ ngoài.
Chỗ làm: `C:\Projects\_wt\m8\m8-wp07a` · Base sóng 1: `c9f0cd188f4966d07aafb3155039656b1b451034`.
Chỗ kiểm: bản sao/checkout cố định của đúng bộ byte; không build trên checkout đang có coder sửa. Trước /song kiểm lại HEAD và phạm vi.

## Brief

1. Repo: `C:\Projects\ginsengfood-ivr`, chỉ `main`; phiên chính chuẩn bị bản sao git archive, không worktree/nhánh mới.
2. Mục tiêu: Khôi phục các cổng kiểm và xác minh phạm vi quét bí mật. Tiêu chí đạt:
   - 1. Tái hiện riêng 4 lỗi đã ghi; CT-CI-06j chưa tái hiện trong /ke-hoach nên phải chốt nguyên nhân bằng test đỏ trước sửa.
   - 2. Xử lý đúng file/thư mục rollout, phân loại .codex đúng chính sách, sửa metadata/link theo provenance; không miễn duyệt TTS hoặc bỏ quét đường dẫn.
   - 3. Các đối chứng PII thay/mới/chuyển/symlink/hash sai vẫn đỏ. Không thêm ignore rộng, nới regex, đổi baseline hoặc sửa evidence niêm phong để xanh.
   - 4. Targeted và kiểm âm/đột biến chạy trong archive; full gate-sweep và kiểm cần historical Git objects chạy sau ghép trên main cố định khi mọi coder dừng sửa checkout, parent điều phối verifier. Không giả shallow/dựng history hoặc bỏ guard để qua document-links; quét evidence. Kiểm riêng việc tools/task-tracker/sheet.json đang tracked bằng báo cáo đã lọc, không đọc/in secret. Nếu phát hiện credential thật, dừng phần cần thu hồi và ghi chủ xử lý; không tự miễn kiểm.
3. Phạm vi ghi: deploy/ci/scripts/{progressive-selftest.mjs,selftest-pii.sh,document-links.mjs,tts-provenance-gate.mjs} khi có lỗi; deploy/ci/governance/tts-repository-paths.json; docs/document-history.json; deploy/ci/pii-reviewed-evidence.tsv chỉ khi có căn cứ; evidence mới.
   Tệp nóng: Ba tệp governance/history/manifest trên chỉ WP07A ghi trong sóng 1; chưa re-pin MODELS.lock hoặc candidate.
   Cấm: secret thật, .env*, sheet.json, OpenAPI/baseline/hash niêm phong ngoài scope; không commit/push/merge/PR/deploy hoặc đổi cờ production.
4. Đọc trước: Bản rà 2026-11-02-ke-hoach-m8.md E10; scripts progressive-selftest:153-154, selftest-pii:152-188, tts-provenance-gate:74-82; history/r1/README:7-9.
   Thêm `AGENTS.md`, `CLAUDE.md` repo; `modules/m8/PHIEN.md`, `SAN_SANG.md`, bản rà `ra-soat/2026-11-02-ke-hoach-m8.md`.
5. Lệnh kiểm/phạm vi được dự kiến cho /song: Targeted theo gate --list trong archive. Git Bash full node deploy/ci/scripts/gate-sweep.mjs và sh deploy/ci/scripts/scan-pii.sh <evidence mới> trên main ổn định sau ghép, có Git objects thật; parent giữ độc quyền checkout lúc kiểm.
   Lượt /ke-hoach CHƯA chạy các lệnh này. Runtime/công cụ cũ giữ nguyên; dependency chỉ cài trong nơi cô lập khi brief /song cho phép.
6. Bằng chứng: SHA nguồn + image/tool/artifact hash thích hợp, môi trường, lệnh, số pass/fail/skip, kiểm âm/đột biến, phạm vi thiếu; không dữ liệu/giá trị bí mật.
   R2: test đỏ trước → coder → verifier độc lập. R3: thêm tester độc lập và Lead duyệt diff trước ghép. Không tự ký nghiệm thu hay gọi test lab là production.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`. Parent giữ tracker/W-ID/generated files và tích hợp tuần tự; tối đa 3 agent nặng.
   GitNexus index lúc khảo sát stale `00b9004`, query thiếu FTS: trước sửa symbol parent xử lý index/impact theo luật repo; không scout tự analyze.
8. Đầu ra ≤25 dòng: đạt/chưa xong/chặn, tệp đổi, bằng chứng, việc còn lại/tệp xung đột; tracker và commit để phiên chính.

## Phụ thuộc và ranh giới

Làm ngay. Không phụ thuộc bật GitHub Actions trong giai đoạn dev.
D-m8-010: .61 chỉ là kho tạm LAB, không chặn code/lab; custody production vẫn chốt trước cấp production/release.
D-m8-008: phần M3 do phiên m34 tự xử lý; m8 chỉ đọc để biết, không giao việc hoặc soạn/gửi hợp đồng cho M3.
Rủi ro/ước lượng phải đánh giá lại khi tái hiện lỗi, scope hoặc HEAD thay đổi; phát hiện thiếu quyền thì làm tiếp phần lab độc lập.

## Diễn biến

- 02/11 /ke-hoach: tạo phiếu từ 3 scout chỉ đọc và đối chiếu nguồn; chưa giao coder, chưa tạo bản sao, chưa chạy test/host.

## Bước kế tiếp chính xác

/song chạy tái hiện trước; thay thuật toán/ranh giới scanner phải áp R3, không tự giảm tiêu chí.

- 02/11 11:29 /song: Lead duyệt D-m8-011; parent chuẩn bị và điều phối sóng 1. Dành số W-0490; evidence docs/evidence/W-0490/. Archive LF từ c9f0cd18, loại .env* và sheet.json theo luật bí mật; full history gate chỉ ở main.
- 02/11 11:37 · Archive đã tạo, hash tar64a91ff4721a01f1e7f92421f6b998bf0dad71db522e8492d8370e013ae93114; coder đã nhận brief đầy đủ. GitNexus index-only PASS136s, c9f0cd18 up-to-date; không đổi AGENTS/CLAUDE.
- 02/11 11:47 · Coder frozen:23/23 regression; progressive/TTS PASS; LinuxPII21baseline+147negative+3badmanifest PASS; GitBash nativefile-symlink FAIL do môi trường. Parent tái hiện document-linksmain lỗi thật; secret-scanredacted1finding line5 generic-api-key, validityNOT_TESTED, Lead xửlýngoàiscope. Chờverifier; chưa ghép.
- 02/11 12:36 · R1 verifier: 23/23 và 3 mutation đạt; full main R1 50/51, chỉ PII symlink Windows lỗi môi trường. Coder R2 bổ sung runner Linux local pinned, giữ 21 baseline/147 negative/3 manifest; 18/18 dispatch test và hai môi trường đạt. OPS đang kiểm độc lập vòng 2; chưa ghép R2.
- 02/11 12:49 · Verifier R2 ĐẠT: 18/18 dispatch, hai môi trường giữ 21/147/3, 3 mutation; 60 hash ổn định. Parent ghép incremental patch 6fe2eac6, 79/79 byte khớp archive. Main targeted 23 Windows + 18 Linux đạt; hai lỗi harness parent (native /bin/sh và tmpfs noexec) giữ log, không sửa source. Chờ full gate-sweep sau phần nguồn M3 mới.
- 02/11 14:04 · Commit1ef80eb2 trênmain sạch;23regression Windows+18dispatch Linux đạt. VerifierR2 đạt,scanner/TSVkhôngđổi. Full51 đangchạy trênHEADcốđịnh; secretfindingline5 vẫnngoàiscope.
- 02/11 14:18 · Full default trên main sạch 1ef80eb2: 51/51, 39 skip đúng manifest, 534 hash ổn định; bằng chứng a625d694. PII của sáu tệp mới và document-links/gate-status đạt. Tracker M8-007 đã đồng bộ một lần, shutdown build server xong; secret finding vẫn cần Lead xử lý.
