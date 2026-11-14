# M8-WP02E — Diễn tập chuyển giám sát theo profile máy đã ghim

Trạng thái: ĐẠT LOCAL — công cụ/LAB monitoring; candidate/host/reboot còn02F/07B · Rủi ro: R3 · Chế độ: A · Mốc: 05/11 lab
Hạng mục nâng: Cài bản thật/vận hành 50 → 50; bước host thuộc WP02F · Sheet: M8-002 · Làn: L2
Ước lượng: 12 giờ công AI (7 coder + 3 tester độc lập + 2 verifier); dự toán, chưa phải cam kết thời gian chờ ngoài.
Chỗ làm: `C:\Projects\_wt\m8\m8-wp02e` · Base sóng 2: `a625d6943dff9d4736422c71484bcf2c4765aef7`.
Chỗ kiểm: bản sao/checkout cố định của đúng bộ byte; không build trên checkout đang có coder sửa. Trước /song kiểm lại HEAD và phạm vi.

## Brief

1. Repo: `C:\Projects\ginsengfood-ivr`, chỉ `main`; phiên chính chuẩn bị bản sao git archive, không worktree/nhánh mới.
2. Mục tiêu: Diễn tập chuyển giám sát theo profile máy đã ghim. Tiêu chí đạt:
   - 1. Dựng profile cô lập mô phỏng đúng bộ cài 17/10; kiểm owner/unit/config/image/mount/provenance/lock trước khi nhận quản lý, không tạo receipt giả.
   - 2. Old → new → rollback → new; thử lỗi start, khóa con, SIGKILL, restart giữa bước; same-scope giữ dữ liệu mới nhất, cross-scope dùng state production mới.
   - 3. SQLite/WAL và TSDB được snapshot/chép nhất quán theo giao thức đã kiểm; dữ liệu cũ không thành mẫu production mới; UNKNOWN đến khi có mẫu hợp lệ.
   - 4. Bổ sung đường thực thi host theo profile/inventory đã ghim, mặc định từ chối khi thiếu quyền/phê duyệt thao tác cụ thể, thử đường này trong lab. host_handoff.py hiện bắt marker ISOLATED_SYSTEMD_LAB_ONLY: không chỉ gỡ marker/nới guard để chạy host; giữ lab adapter riêng và chứng minh adapter mới không nhận ngầm tài nguyên.
   - 5. Tester thử collision tên/cổng/project, sai hash/profile, thiếu phê duyệt; verifier kiểm recovery. SIGKILL không thay reboot thật. /song chỉ viết/kiểm adapter, không chạy trên .61/.64.
3. Phạm vi ghi: deploy/operations/migration/ + test profile/giao tiếp trong deploy/release-candidate/operations_upgrade.py nếu cần và đã impact; evidence mới.
   Tệp nóng: host_handoff/state_transfer/profile monitoring do WP02E giữ; không chạm provisioner DB/secrets của WP03A.
   Cấm: secret thật, .env*, sheet.json, OpenAPI/baseline/hash niêm phong ngoài scope; không commit/push/merge/PR/deploy hoặc đổi cờ production.
4. Đọc trước: docs/evidence/monitoring-systemd-20261027/README.md:3-7; deploy/operations/migration/systemd-lab.md:90-96; production rollout README mục3.
   Thêm `AGENTS.md`, `CLAUDE.md` repo; `modules/m8/PHIEN.md`, `SAN_SANG.md`, bản rà `ra-soat/2026-11-02-ke-hoach-m8.md`.
5. Lệnh kiểm/phạm vi được dự kiến cho /song: Python unittest test_host_handoff.py/test_state_transfer.py và systemd Linux lab cô lập theo README; không chạy run_lab.py trên máy .61/.64. Container do phiên chính điều phối.
   Lượt /ke-hoach CHƯA chạy các lệnh này. Runtime/công cụ cũ giữ nguyên; dependency chỉ cài trong nơi cô lập khi brief /song cho phép.
6. Bằng chứng: SHA nguồn + image/tool/artifact hash thích hợp, môi trường, lệnh, số pass/fail/skip, kiểm âm/đột biến, phạm vi thiếu; không dữ liệu/giá trị bí mật.
   R2: test đỏ trước → coder → verifier độc lập. R3: thêm tester độc lập và Lead duyệt diff trước ghép. Không tự ký nghiệm thu hay gọi test lab là production.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`. Parent giữ tracker/W-ID/generated files và tích hợp tuần tự; tối đa 3 agent nặng.
   GitNexus index lúc khảo sát stale `00b9004`, query thiếu FTS: trước sửa symbol parent xử lý index/impact theo luật repo; không scout tự analyze.
8. Đầu ra ≤25 dòng: đạt/chưa xong/chặn, tệp đổi, bằng chứng, việc còn lại/tệp xung đột; tracker và commit để phiên chính.

## Phụ thuộc và ranh giới

Có thể chuẩn bị lab ngay; xếp sóng 2 để giữ tối đa 3 agent nặng. Áp thật chờ inventory và quyền Tuấn.
D-m8-010: .61 chỉ là kho tạm LAB, không chặn code/lab; custody production vẫn chốt trước cấp production/release.
D-m8-008: phần M3 do phiên m34 tự xử lý; m8 chỉ đọc để biết, không giao việc hoặc soạn/gửi hợp đồng cho M3.
Rủi ro/ước lượng phải đánh giá lại khi tái hiện lỗi, scope hoặc HEAD thay đổi; phát hiện thiếu quyền thì làm tiếp phần lab độc lập.

## Diễn biến

- 02/11 /ke-hoach: tạo phiếu từ 3 scout chỉ đọc và đối chiếu nguồn; chưa giao coder, chưa tạo bản sao, chưa chạy test/host.

## Bước kế tiếp chính xác

Sau sóng 1, tạo bản sao riêng và giao R3; phần profile thật chỉ nhận inventory đã được phép, chưa SSH.
- 02/11 14:28 · D-m8-015 cho chạy sóng 2 và commit local. Parent chuẩn bị archive lọc .env*/sheet.json; main sạch a625d694, GitNexus đang refresh. Dành W-0492 cho bằng chứng mới; không tự ghi sổ chung.
- 02/11 14:31 · Đã giao coder voice, archive a625d694/3.950 tệp, lọc .env*/sheet.json; GitNexus refresh xong219,1s. 01A mapping trước allowlist code; 03A giữ slot Docker đầu, 02E unit/source trước. Không sửa main.
- 02/11 14:40 · Impact handoff/rollback LOW; coder thêm host adapter riêng, giữ markerlab và engine nếu đủ. Parent xác minh public legacyagent59aa841c/image-map26c46e10/archiveimages/candidate26-10 còn; không repin ứng viên hoặc giả receipt.
- 02/11 14:47 · Coder đã chạy đỏ18 policy+4 entry rồi xanh22 unit Windows; thêm authorized_handoff.py/host_profile.py, engine/lab marker giữ nguyên. Parent cấp slot systemd Docker sau khi03A xác nhận chưa chạy lab; chưa có kết luận verifier.
- 02/11 14:54 · Coder xác minh systemd lab pinned image, network none/private cgroup, không mount/port host; public input pins khớp. Linux52/52 (20 cũ+32 mới),0skip. Đang old matrix18/ownership3/child1, host adapter matrix mới rồi cross-scope riêng; engine/controller/state_transfer giữ byte. Chưa verifier.
- 02/11 15:11 · Coder thêm guard cross-scope target có dữ liệu không có journal cùng profile phải từ chối; reapply cùng profile sau rollback giữ dữ liệu mới nhất. Impact symbol mới UNKNOWN trong index; caller trực tiếp main đã đối chiếu, engine không đổi. Sau capacity errors ở2agent khác,02E tiếp tục lab.
- 02/11 15:22 · Coder báo old same-scope18+ownership3+child1 đạt; host adapter14scenarios đạt trên SHAae51e20c; Linux60/60,0skip. Đang kiểm copy SQLite/TSDB và UNKNOWN, rồi old/new cross-scope trên lab riêng. Chưa freeze hoặc nhận verifier.
- 02/11 15:27 · Coder tự soát provenance argv: script/config phải nằm trong source_files được pin;2negative đã đỏ đúng assertions, đang sửa policy mới rồi chạy unit/host same+cross trên hash cuối. Cross-scope vòng trước14+2ca đã đạt nhưng giữ riêng theo hash cũ. Engine full23/copy actual không đổi byte; chưa freeze.
- 02/11 15:55 · Coder freeze158tệp, manifest e58df3a472800b04fe8568fb4e634e66da28c2cb0dd340adc6d8201671d48e11. Final62unit, same14/cross14+2foreign, actual snapshot SQLite/TSDB+503→200 đạt; engine cũ23scenario giữ byte. PII155 đạt; lỗi transport/dependency trước đó giữ riêng. Container riêng đã dọn. CORE nhận tester R3 từ brief/public contract trước đọc implementation; chưa verifier/ghép.
- 02/11 16:09 · Tester cuối91/91 đạt,0skip;157hash coder nguyên,3container riêng dọn xong. R2 giữ4fail+1error do metadata bind mount Windows, R3 dùng copy byte-exact root-owned, không nới trusted_file. Probes Docker/systemd giả riêng; lifecycle thật vẫn là evidence coder ghim byte. Đang PII/freeze tester, chờ verifier OPS sau01A và sửa03A.
- 02/11 16:51 · Verifier ĐẠT R3:91rerun+2mutants,4.125hash nguyên, manifestdb7e2688. Ghép cùng sóng theo D-m8-015, commitlocal5fa00ccdc6cabb52b5e13edfe41b7b46c4289c28;437paths toàn sóng, không lấy WIP tracker. Đang fullmain checks, chưa push/deploy.

- 02/11/2026 20:31 UTC+7 · Chốt sóng2 theo D-m8-016 trên bản sao055b9a9: .NET2459 có suite cuối đạt (Unit đầu4timeout giữ lịch sử; toànUnit1631 rerun đạt),8Python,default51/51+39manifestskip,E2E2/2vòng46tasks;4.423source+361binary nguyên. ĐẠT công cụ/LAB monitoring; candidate/host/reboot còn02F/07B. Hồ sơ commit `f14a6a256d0a69f1edaef2512015d6bd372f3628`; WIP phiênkhác giữ nguyên, chưa push/deploy. [Kết quả](../ra-soat/2026-11-02-song2-m8-ket-qua.md). Cleanup archive bị automatic approval review chặn, chưa hoàn tất.
