# M8-WP07B — Đóng và kiểm một bộ ứng viên có đủ định danh

Trạng thái: ĐẠT phần đóng gói monitoring LAB; toàn gói 07B-L/A chưa đạt · Rủi ro: R2 · Chế độ: A · Mốc: 08–09/11 ứng viên lab; 12/11 nghiệm thu
Hạng mục nâng: Lõi 50 và hồ sơ 30 giữ đến khi có nghiệm thu; cung cấp bằng chứng cho 75/90 · Sheet: M8-007 · Làn: L3
Ước lượng: 12 giờ công AI (8 người chuẩn bị/kiểm + 4 verifier; thêm soak 4 giờ máy, không tính vào công AI); dự toán, chưa phải cam kết thời gian chờ ngoài.
Chỗ làm: dự kiến `C:\Projects\_wt\m8\m8-wp07b` (chưa tạo) · Base khảo sát: `c9f0cd188f4966d07aafb3155039656b1b451034`.
Chỗ kiểm: bản sao/checkout cố định của đúng bộ byte; không build trên checkout đang có coder sửa. Trước /song kiểm lại HEAD và phạm vi.

## Brief

1. Repo: `C:\Projects\ginsengfood-ivr`, chỉ `main`; phiên chính chuẩn bị bản sao git archive, không worktree/nhánh mới.
2. Mục tiêu: Đóng và kiểm một bộ ứng viên có đủ định danh. Tiêu chí đạt:
   - 1. Ghim runtime SHA và bộ công cụ riêng; artifact tồn tại/hash/image digest/platform đúng. Giữ nguyên evidence 26/10; không cộng test từ nhiều bộ thành một PASS.
   - 2. Mốc 07B-L (ứng viên đạt lab): trên main sau ghép, nguồn ổn định và đủ Git objects thật, full Release build/tests/format, OpenAPI/traceability/gate-sweep và dependency/image scan mới. Parent dừng mọi coder trước kiểm. Archive chỉ dùng cho kiểm không cần lịch sử; không giả shallow/bỏ guard. Receipt 07B-L chỉ có khi mọi kiểm lab, identity và soak cần thiết đạt.
   - 3. Smoke/upgrade→rollback→upgrade, bộ DB/secrets/backup/monitoring, và soak 4h theo profile ứng viên; test failure/rollback có bằng chứng.
   - 4. Mốc 07B-A (hồ sơ nghiệm thu): sau 07B-L, nhận evidence 01A/05/08/02F/07V để đối chiếu G1–G8, DF-03/legal và release approval đúng chữ ký thật. 02F chỉ đợi 07B-L, không đợi cả WP07B ĐẠT; chưa đủ 07B-A thì WP07B chưa đóng. Hosted release evidence gắn exact SHA; GitHub Actions tắt dev không phải blocker.
   - 5. Mọi đổi nguồn, artifact, mirror, audio hoặc công cụ sau freeze phải đánh giá phạm vi và chạy lại kiểm bị ảnh hưởng; không nâng gate nếu còn thiếu.
3. Phạm vi ghi: deploy/release-candidate recipe/profiles/tests khi có gap cụ thể; hồ sơ candidate mới; checklist/evidence mới. Root giữ work-register, gate-status, readiness-board, traceability.
   Tệp nóng: Runtime SHA, tool hashes, model/audio hashes và toàn candidate freeze; không chạy cùng bất kỳ coder thay nguồn/image/pins.
   Cấm: secret thật, .env*, sheet.json, OpenAPI/baseline/hash niêm phong ngoài scope; không commit/push/merge/PR/deploy hoặc đổi cờ production.
4. Đọc trước: deploy/release-candidate/BUILD.md; docs/evidence/release-final-20261026/README.md; production-window README và gate list; WP07A.
   Thêm `AGENTS.md`, `CLAUDE.md` repo; `modules/m8/PHIEN.md`, `SAN_SANG.md`, bản rà `ra-soat/2026-11-02-ke-hoach-m8.md`.
5. Lệnh kiểm/phạm vi được dự kiến cho /song: dotnet build/test Ivr.sln Release; format --verify-no-changes; node deploy/ci/scripts/gate-sweep.mjs; candidate harness/Trivy/soak theo BUILD.md. Máy/container kiểm riêng, root điều phối độc quyền.
   Lượt /ke-hoach CHƯA chạy các lệnh này. Runtime/công cụ cũ giữ nguyên; dependency chỉ cài trong nơi cô lập khi brief /song cho phép.
6. Bằng chứng: SHA nguồn + image/tool/artifact hash thích hợp, môi trường, lệnh, số pass/fail/skip, kiểm âm/đột biến, phạm vi thiếu; không dữ liệu/giá trị bí mật.
   R2: test đỏ trước → coder → verifier độc lập. R3: thêm tester độc lập và Lead duyệt diff trước ghép. Không tự ký nghiệm thu hay gọi test lab là production.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`. Parent giữ tracker/W-ID/generated files và tích hợp tuần tự; tối đa 3 agent nặng.
   GitNexus index lúc khảo sát stale `00b9004`, query thiếu FTS: trước sửa symbol parent xử lý index/impact theo luật repo; không scout tự analyze.
8. Đầu ra ≤25 dòng: đạt/chưa xong/chặn, tệp đổi, bằng chứng, việc còn lại/tệp xung đột; tracker và commit để phiên chính.

## Phụ thuộc và ranh giới

WP07A,02D,02E,03A và mốc 07V-L (artifact/phê duyệt đủ để đóng candidate) nếu đổi model/audio. 07B-L không đợi playback/nghiệm thu host cuối của 07V. WP07D chốt trước cửa sổ thật; evidence host trả về 07B-A.
D-m8-010: .61 chỉ là kho tạm LAB, không chặn code/lab; custody production vẫn chốt trước cấp production/release.
D-m8-008: phần M3 do phiên m34 tự xử lý; m8 chỉ đọc để biết, không giao việc hoặc soạn/gửi hợp đồng cho M3.
Rủi ro/ước lượng phải đánh giá lại khi tái hiện lỗi, scope hoặc HEAD thay đổi; phát hiện thiếu quyền thì làm tiếp phần lab độc lập.

## Diễn biến

- 02/11 /ke-hoach: tạo phiếu từ 3 scout chỉ đọc và đối chiếu nguồn; chưa giao coder, chưa tạo bản sao, chưa chạy test/host.

## Bước kế tiếp chính xác

Sau khi ghép mọi gói thuộc candidate, chụp HEAD/tree và tạo nơi kiểm cố định; nếu sửa chính sách bảo mật/release chuyển R3.

- 03/11/2026 01:55 UTC+7 · D-m8-017 cho tiếp LAB khi đầu vào07V-L mới chưa có. Parent đã kiểm model13, bank510WAV/511checksum/PCM và các binding hiệnhành; nguồnartifact vẫn66d9045d. Giao coder CORE phần đónggói monitoring R2 trên archivef14, goc e8bff795,4.521publicfiles; impactLOW1caller/0flow. DànhW-0495, trackerM8-007. [Brief](../ra-soat/2026-11-03-07b-lab-brief.md). Không nốiF5/R5, không đóng07B-L, giữWIP main; chưa push/deploy.
- 03/11 02:00 · Coder đỏ trước code: operations_payload 1FAIL/2 thiếu monitoring-toolset.json; toolset10FAIL/10 vì helper chưa có, không lỗi môi trường/import.34protectedhash đã chụp. Đang helper+1call render_operations; chưa sửa render_hosts. Parent Linux saufreeze, khôngstub fcntl.
- 03/11 02:10 · Coder freeze37tệp, manifest2a65fdeb…85db. Windows21/21,34protected nguyên; PII32+4metadata đạt, broad2dòngBUILDcũ giữFAIL vàpins. Source5paths, render_hosts/engine/controller/authority nguyên. Parent xácminh36/36manifest vàđangLinux6suite+16observations; chưaverifier/ghép.

- 03/11/2026 02:34 UTC+7 · R2 verifier đạt:21 + extracted16 + independent15;2mutants bị bắt. Đã ghép/commit local `17ef92fed3171e8001bddfdae8ad46e4339a2e12`, giữ WIP13/weekly của phiên kia; W-0495/M8-007. Chưa F5/R5, candidate07B-L/A hoặc host/production. [Kết quả](../ra-soat/2026-11-03-07b-lab-ket-qua.md).
