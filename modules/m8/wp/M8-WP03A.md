# M8-WP03A — Nối cấp quyền backup và khôi phục đủ đường đi trong lab

Trạng thái: ĐẠT LOCAL — integrated backup/restore LAB; ngoài máy/custody production còn riêng · Rủi ro: R3 · Chế độ: A · Mốc: 06/11 lab; restore ngoài máy trước 11/11
Hạng mục nâng: Sao lưu/DR 40 → 50 sau đủ kiểm tích hợp; 75 cần kho ngoài máy và phục hồi thật · Sheet: M8-003 · Làn: L3
Ước lượng: 12 giờ công AI (6 coder + 3 tester độc lập + 3 verifier); dự toán, chưa phải cam kết thời gian chờ ngoài.
Chỗ làm: `C:\Projects\_wt\m8\m8-wp03a` · Base sóng 2: `a625d6943dff9d4736422c71484bcf2c4765aef7`.
Chỗ kiểm: bản sao/checkout cố định của đúng bộ byte; không build trên checkout đang có coder sửa. Trước /song kiểm lại HEAD và phạm vi.

## Brief

1. Repo: `C:\Projects\ginsengfood-ivr`, chỉ `main`; phiên chính chuẩn bị bản sao git archive, không worktree/nhánh mới.
2. Mục tiêu: Nối cấp quyền backup và khôi phục đủ đường đi trong lab. Tiêu chí đạt:
   - 1. Tái dùng bộ backup hiện có; nối năm ref backup/recovery bị loại, backup.pgpass và role, kiểm cấp/stage/verify thay vì PASS_WITH_PENDING khi cần backup.
   - 2. Diễn tập credential → dump/capture → Restic → host/DB trống → rolecheck, đối soát ledger watermark cho cả hai host; thử đứt upload rồi chạy lại.
   - 3. Sai khóa, tamper, thiếu một host, thiếu quyền và watermark sai phải đỏ; receipt không chứa giá trị/hash secret.
   - 4. Có hướng dẫn phục hồi CA và khóa sao lưu từ kho độc lập; lab không tự ghi đã đạt offhost/reboot hoặc chốt người giữ/RPO/RTO.
3. Phạm vi ghi: deploy/backup/{offhost.py,capture_host.py,secret_archive.py} và tests; adapter backup trong deploy/production-window/secrets; db_provision/tests khi cần; fixture/register/access-table LAB mới dưới tests/evidence của WP. Metadata danh mục ref/schema thực tại deploy/rollouts/production-window-20261027/{provisioning-register.json,secrets-and-access.md} chỉ đề xuất diff hẹp và parent đối chiếu trước giao coder; không đổi custody, giá trị secret hay trạng thái production trong gói lab.
   Tệp nóng: db_provision.py, secret_stage.py, secret refs/bảng quyền chỉ WP03A ghi sau WP02D. Không chạy cùng WP07V nếu cùng bảng secret/custody.
   Cấm: secret thật, .env*, sheet.json, OpenAPI/baseline/hash niêm phong ngoài scope; không commit/push/merge/PR/deploy hoặc đổi cờ production.
4. Đọc trước: secrets README:14-16; db README:59; deploy/backup/README.md:9-31,121-127; release-final README:41-42; backup-request.md:20-25.
   Thêm `AGENTS.md`, `CLAUDE.md` repo; `modules/m8/PHIEN.md`, `SAN_SANG.md`, bản rà `ra-soat/2026-11-02-ke-hoach-m8.md`.
5. Lệnh kiểm/phạm vi được dự kiến cho /song: test_recovery.py, test_offhost_lab.py, test_capture_lab.py và test tích hợp DB/secret mới trên container/Linux cô lập; không dùng kho thật hoặc credential đang chạy.
   Lượt /ke-hoach CHƯA chạy các lệnh này. Runtime/công cụ cũ giữ nguyên; dependency chỉ cài trong nơi cô lập khi brief /song cho phép.
6. Bằng chứng: SHA nguồn + image/tool/artifact hash thích hợp, môi trường, lệnh, số pass/fail/skip, kiểm âm/đột biến, phạm vi thiếu; không dữ liệu/giá trị bí mật.
   R2: test đỏ trước → coder → verifier độc lập. R3: thêm tester độc lập và Lead duyệt diff trước ghép. Không tự ký nghiệm thu hay gọi test lab là production.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`. Parent giữ tracker/W-ID/generated files và tích hợp tuần tự; tối đa 3 agent nặng.
   GitNexus index lúc khảo sát stale `00b9004`, query thiếu FTS: trước sửa symbol parent xử lý index/impact theo luật repo; không scout tự analyze.
8. Đầu ra ≤25 dòng: đạt/chưa xong/chặn, tệp đổi, bằng chứng, việc còn lại/tệp xung đột; tracker và commit để phiên chính.

## Phụ thuộc và ranh giới

Sau WP02D vì cùng db_provision.py/secret_stage.py; lab dùng bộ bí mật giả, không đợi kho production.
D-m8-010: .61 chỉ là kho tạm LAB, không chặn code/lab; custody production vẫn chốt trước cấp production/release.
D-m8-008: phần M3 do phiên m34 tự xử lý; m8 chỉ đọc để biết, không giao việc hoặc soạn/gửi hợp đồng cho M3.
Rủi ro/ước lượng phải đánh giá lại khi tái hiện lỗi, scope hoặc HEAD thay đổi; phát hiện thiếu quyền thì làm tiếp phần lab độc lập.

## Diễn biến

- 02/11 /ke-hoach: tạo phiếu từ 3 scout chỉ đọc và đối chiếu nguồn; chưa giao coder, chưa tạo bản sao, chưa chạy test/host.

## Bước kế tiếp chính xác

Đợi WP02D ghép; sau đó R3 tích hợp backup trên bộ công cụ mới. Tuấn/custody là phụ thuộc cho lượt thật ở WP02F.
- 02/11 14:18 · Phụ thuộc WP02D đã đạt công cụ/lab và ghép local 1ef80eb2, default gates 51/51; có thể đưa vào sóng 2 khi Lead gọi chạy. Chưa tạo bản sao hoặc thực hiện gói.
- 02/11 14:28 · D-m8-015 cho chạy sóng 2 và commit local. Parent chuẩn bị archive lọc .env*/sheet.json; main sạch a625d694, GitNexus đang refresh. Dành W-0493 cho bằng chứng mới; không tự ghi sổ chung.
- 02/11 14:31 · Đã giao coder ops, archive a625d694/3.950 tệp, lọc .env*/sheet.json; GitNexus refresh xong219,1s. 01A mapping trước allowlist code; 03A giữ slot Docker đầu, 02E unit/source trước. Không sửa main.
- 02/11 14:40 · Impact plan_entries MEDIUM; load_credentials HIGH do bootstrap/migrate/check dùng chung. Parent đã công bố và cho diff hẹp require_backup opt-in/propagation; không đổi grant/login/rolepolicy. Fixture LAB cho5ref, backup-root ngoài payload và recoveryworkspace riêng; productionregister/custody giữ nguyên. Parent rà consumer pins sau freeze.
- 02/11 14:47 · Giữ sửa hẹp require_backup và wrapper đã công bố HIGH. Slot Docker nặng tạm chuyển02E;03A tiếp tục source/unit Linux, chưa chạy full capture/restore mới.
- 02/11 15:11 · Coder báo profile5refs positive PASS,10contract xanh; recovery/Restic18PASS,1capture skip chờ lab. Fullsecret214 lượt đầu12setup error vì runner RO thiếu tmpfs; DB112unit xanh nhưng5Docker setup thiếu daemon. Chưa chốt PASS toàn gói. Agent bị model at capacity; parent tạm giữ việc, giảm concurrency, sẽ resume sau slot.
- 02/11 15:22 · Đã resume thu secret attempt2:242tests,236PASS,1FAIL,5SKIP; lỗi PATH shim do /root tmpfs noexec. Parent cho runner test /root exec, giữ log và sourceSHA416178fb; không đổi hardening công cụ. Chưa fullDB/Restic chain.
- 02/11 15:36 · Fullsecret attempt3:242tests,237PASS+5SKIP;5Windows complement đạt riêng, source416178fb không drift. Parent cho chain Docker riêng chạy đồng thời lượt cuối02E/E2E01A theo tài nguyên đã kiểm, giới hạn outer3GiB/2CPU; chưa có verdict full restore.
- 02/11 15:55 · Coder actualchain attempt2 đạt36/36, backup full19/19,0skip; upload ngắt exit130→restart→retry và host/DB trống→CA recovery độc lập→DB/SQLite watermark21 đạt. LAB adapter chỉ dịch4image ID đã kiểm Config+RootFS, không chứng minh native production manifest. Attempt1 ID drift giữ nguyên. Diagnostic env line trong log đỏ giữ riêng ngoài delivery; lọc đúng1dòng và thêm kiểm marker,11/11 Linux+Windows đạt. Outer ownID đã dọn. Coder đang freeze; VOICE nhận tester criteria-first, chưa ghép.
- 02/11 16:02 · Coder freeze67tệp, manifest5f8663c75ab6914514c4d07029bcae5bee0044c714f9c4ea906fa28a85bef0d7;66hash delivery khớp,33tệp bảo vệ nguyên. PII56/0exception và30log không envdump;3mutants bị bắt. Tester VOICE bắt đầu từ plan ghim trước đọc implementation; OPS chuyển verifier01A, chưa có kết luận03A.
- 02/11 16:09 · Tester xác nhận T1: require_backup sai kiểu (7giá trị) làm offhost.validate bỏ kiểm hai file transport; valid control đạt. Giữ log đỏ, đang gom probe Linux production-root rồi giao coder sửa hẹp; chưa ghép hoặc tự nhận đạt. Hai lỗi fixture Windows đang sửa độc lập, không đổi runtime/assertions.
- 02/11 16:09 · Dọn exact scratch C:\Users\Administrator\AppData\Local\Temp\wp03a-independent-kav0y_b_ bị automatic approval review từ chối trước thực thi, reason blocked by policy. Chỉ SQLite synthetic của tester, giữ ngoài delivery; không xóa qua công cụ khác hoặc thư mục cha.
- 02/11 16:12 · Linux tester20methods:17PASS/3FAIL methods (10assertions),0error/skip. T2 xác nhận lab stage ghi backup-root trong PRODUCTION_AREA và verify nhận recovery-root cùng vùng; test chỉ patch vùng production sang /lab cô lập. OPS nhận sửa hẹp T1/T2, CORE chuẩn bị verifier sau v2freeze. Giữ original manifest/logs; không nới test, không chạy máy thật. Kiểm lại affected suites + actualchain trên byte mới; full237+5 cũ giữ đúng nguồn cũ, không gộp giả.
- 02/11 16:22 · Coder khóa v2source8pins (b4b31b165b144ea3346860a97944408c44db8136218e20f61f769469262e90df); chỉ2guard runtime và2test coder đổi. Tester giữ nguyên20ca/f124292f, chạy lại20/20 đạt,0skip; T1/T2 đóng ở tester. Manifest v2 e76428723241b9dd75e429a585207e8d3b9bddc6d422df9912a038fdf12eb97a,PII5đạt,container dọn. Chờ actualchain36 v2 + verifier CORE; chưa ghép.
- 02/11 16:51 · V2 chain36/backup21 đạt; verifier CORE ĐẠT guard11/adapter9,3mutants, manifest e98b9afc. Coder manifestf0cc01ba có117tệp; evidence PII log104 (không dùng số105 từ lời nhắn), broad4prose flags giữ FAIL. Ghép5fa00ccd; parent chỉ repin3ví dụ DBREADME và scoped attributes; chưa push/deploy. Đang fullmain checks.

- 02/11/2026 20:31 UTC+7 · Chốt sóng2 theo D-m8-016 trên bản sao055b9a9: .NET2459 có suite cuối đạt (Unit đầu4timeout giữ lịch sử; toànUnit1631 rerun đạt),8Python,default51/51+39manifestskip,E2E2/2vòng46tasks;4.423source+361binary nguyên. ĐẠT integrated backup/restore LAB; ngoài máy/custody production còn riêng. Hồ sơ commit `f14a6a256d0a69f1edaef2512015d6bd372f3628`; WIP phiênkhác giữ nguyên, chưa push/deploy. [Kết quả](../ra-soat/2026-11-02-song2-m8-ket-qua.md). Cleanup archive bị automatic approval review chặn, chưa hoàn tất.
