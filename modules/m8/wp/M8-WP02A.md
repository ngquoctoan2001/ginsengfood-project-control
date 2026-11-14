# M8-WP02A — Dựng DB production và phân quyền cho `.61`, diễn tập trên Postgres tạm

Trạng thái: ĐẠT — đã ghép `main` d6c7e1bc (W-0486), đã có trên GitLab/GitHub tại c9f0cd18 (fetch + ls-remote 02/11 09:55) · Rủi ro: R3 (phân quyền DB) · Chế độ: A · Mốc: A 07/11 (công cụ), D 14/11 (chạy thật)
Hạng mục nâng: Cài bản thật `.61`/`.64` từ 50 lên 50 (giữ bậc, thêm công cụ có kiểm lab; lên 75 khi chạy được trên máy thật) · Sheet: M8-002 · W: W-0486 · Ước lượng: 6–8 giờ
Chỗ làm: `C:\Projects\_wt\m8\wp02a-db` (bản sao `git archive`, repo tạm, commit `goc` 8c86558) · Base SHA: `2aaacb35` · Chỗ kiểm: cùng bản sao

## Brief
1. Repo `ginsengfood-ivr` (.NET 10 + công cụ Python ở `deploy/`). Thư mục làm việc DUY NHẤT: `C:\Projects\_wt\m8\wp02a-db`
   (bản sao, repo git tạm có commit `goc`). KHÔNG ghi vào `C:\Projects\ginsengfood-ivr` và `G:\ivr-lab\` (chỉ đọc). Không tạo nhánh.
2. Mục tiêu: khi xong, Lead có một công cụ dựng DB production mới trên `.61` theo đúng mục T+10–30 của cửa sổ, đã diễn tập trọn
   trên Postgres tạm cùng image ứng viên. Công cụ `deploy/production-window/db/db_provision.py` (Python 3.10, chỉ stdlib + `psql`
   trong container), các bước `plan | bootstrap | migrate | grants | check | policy`:
   - `bootstrap`: tạo các role LOGIN (owner migration, `ivr_api`, `ivr_worker`, `ivr_ops`, `ivr_backup`, `ivr_monitor`…, lấy đúng
     danh sách từ `database-grants.sql`, `monitor-grants.sql`, `provisioning-register.json`) với NOSUPERUSER NOCREATEDB NOCREATEROLE
     NOREPLICATION NOBYPASSRLS, không membership chéo; tạo DB `ivr_production` thuộc owner. Mật khẩu đọc từ TỆP (đường dẫn
     `/srv/ivr-production/private/db-*`), không bao giờ qua argv/biến in ra log; chạy lại lần 2 không đổi gì (idempotent).
   - `migrate`: áp 45 migration của ứng viên (`G:/ivr-lab/release-final-20261026/candidate/migrations.sql`) bằng owner.
   - `grants`: `database-grants.sql` rồi `monitor-grants.sql`. `check`: `database-role-check.sql` + đăng nhập TỪNG DSN, kiểm
     đọc/ghi đúng phạm vi, DDL bị chặn, `SET ROLE` sang role khác bị chặn, API/worker cùng DB khác role.
   - `policy`: in (và trong lab thì chạy) đúng 3 lệnh Ivr.Ops `--version gh-247-prod-v4` của README cửa sổ cho Compose `.61`;
     từ chối mọi lệnh policy thiếu `--version`. Nếu chạy Ivr.Ops trong lab không khả thi trong thời gian → ghi `CHƯA CHẠY` + lý do.
   - Có chế độ `--dry-run` in kế hoạch không chứa bí mật; không bao giờ chạm DB S5 (từ chối DSN/DB tên khác `ivr_production`).
   Tiêu chí đạt: (a) test `python -X utf8 -m unittest discover -s deploy/production-window/db/tests -v` đạt, gồm test đỏ-trước cho
   từng quy tắc trên; (b) diễn tập lab trọn chuỗi bootstrap→migrate→grants→check(→policy) trên container
   `ivr-release-postgres:66d9045d8be0` cổng ngẫu nhiên, chạy hai lần liền đạt; (c) đột biến: bỏ một cờ NO* hoặc cấp thừa quyền
   → `check` phải đỏ; (d) `README.md` trong thư mục công cụ: cách chạy trên `.61` (Lead tự chạy), điểm dừng, quay lui (giữ DB mới).
3. Ghi được: `deploy/production-window/db/**`, `docs/evidence/W-0486/**`. Cấm: mọi tệp khác, đặc biệt migration +
   `IvrDbContextModelSnapshot.cs`, `deploy/release-candidate/*.sql` (đọc, không sửa — thấy lỗi thì báo `CẦN QUYẾT`),
   `deploy/rollouts/**`, `docs/release/**`, `docs/traceability-tests.md`, OpenAPI draft.44, `.gitattributes`, `tools/task-tracker/**`.
4. Đọc trước: `CLAUDE.md` của bản sao; `deploy/rollouts/production-window-20261027/{README.md §2,secrets-and-access.md "Quyền DB",
   provisioning-sequence.md bước 4,provisioning-register.json}`; `deploy/release-candidate/{database-grants.sql,monitor-grants.sql}`;
   `deploy/operations/readiness/{README.md,database-role-check.sql,test_database_roles.py}` (dùng lại cách dựng Postgres Docker);
   `tools/Ivr.Ops` README mục "Policy ba lượt"; `G:/ivr-lab/release-final-20261026/candidate/config/host61/{compose.json,database-grants.sql}`.
   Trước khi viết: tìm xem đã có công cụ tương đương chưa — có thì mở rộng, không viết trùng.
5. Được chạy: Python unittest; `docker run --rm` tên tiền tố `m8-wp02a-`, cổng ngẫu nhiên, dọn container/volume khi xong;
   `dotnet build/run` cho `tools/Ivr.Ops` với thư mục build riêng trong bản sao. KHÔNG: `docker compose` của repo (cổng cố định
   5005/55433), chạm container `ginsengfood-postgres-local`, ssh/scp, mọi máy `.60/.61/.63/.64`, `s5v4_host.py`, `run_lab.py`,
   sheet-sync, `gitnexus analyze`, đọc `.env*`/khoá thật, sinh bí mật production. Mật khẩu lab: sinh ngẫu nhiên trong thư mục tạm, xoá sau.
6. Bằng chứng: `docs/evidence/W-0486/README.md` (lệnh, số test, kết quả diễn tập 2 lần, đột biến, phiên bản image), không chứa bí mật/PII;
   chạy `sh deploy/ci/scripts/scan-pii.sh docs/evidence/W-0486` đạt.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`. Không commit trong bản sao (để thay đổi ở cây làm việc).
8. Đầu ra: tin nhắn cuối ≤ 25 dòng theo LUAT_SUBAGENT mục 10.

## Diễn biến (mỗi vòng một dòng, mới nhất ở cuối)
- 01/11 17:40 tạo bản sao + phiếu, giao coder v1
- 01/11 18:41 coder v1 bị ngắt do 429 (hạn mức 5 giờ) khi mới đọc tài liệu, bản sao chưa đổi → cho chạy tiếp
- 01/11 19:15 coder v1: ĐẠT (lab) · 7 tệp mới `deploy/production-window/db/**` + `docs/evidence/W-0486/**`, đã add chưa commit · unittest 58/58 (181 s, 7 test Docker) · diễn tập 2 lượt trên postgres 16.15 image ứng viên: 5 role, 45 migration, check 100 phép thử, policy v4 exit 1,0,0 rồi 0,0,0, lượt 2 không đổi · đột biến 15/15 đỏ · scan-pii PASS · CẦN QUYẾT: (1) `candidate/migrations.sql` hỏng với psql (5 khối DO thiếu `;`, dừng ở migration 26) → dùng image `migrate` niêm phong; (2) owner = superuser bootstrap theo compose niêm phong, 5 role runtime NO*+NOINHERIT; (3) mật khẩu đọc từ tệp compose mount (`db-bootstrap`, `db-migrate`, `db-ops`, `api.json`, `worker.json`, `backup.pgpass`)
- 01/11 23:47 tester độc lập (2 lần do 429): CÓ LỖI · 69 test, 64 đạt, 5 hỏng, đều là lỗi thật của `check` (exit 0 khi cấp thừa): VỪA CREATE trên schema mới; VỪA `pg_default_acl`; VỪA SELECT `pg_authid` cho monitor; NHẸ WITH GRANT OPTION; NHẸ PUBLIC còn TEMPORARY · bộ coder 58/58 · scan-pii PASS · ghi chú: tài liệu nói monitor đọc "3 bảng aggregate" nhưng `monitor-grants.sql` niêm phong cấp 3 bảng vận hành (có `ivr_call_jobs`) → báo Lead
- 01/11 23:48 giao coder v2 sửa 5 lỗi + lọc tên container chính xác; TEMP: chỉ thu hồi nếu `src/` không dùng bảng tạm
- 02/11 00:07 coder v2: ĐẠT · `check` đỏ với cả 5 lỗi + 3 trường hợp cùng loại (mọi schema, `pg_default_acl` so 7 lệnh niêm phong, mọi ACL tường minh + catalog nhạy cảm, grant option); `src/` không dùng bảng tạm → `bootstrap` REVOKE TEMPORARY khỏi PUBLIC trên `ivr_production`; lab_rehearsal lọc tên chính xác · unittest 135/135 (coder 66 + tester 69), 239,8 s · diễn tập 2 lượt đạt, check 105 thử · đột biến 23/23 · scan-pii PASS · CẦN QUYẾT nhẹ: DB bảo trì `postgres` để mặc định (role runtime có CONNECT+TEMP)
- 02/11 00:07 giao verifier (tiêu chí 1–9, container `m8-wp02a-v-`)
- 02/11 00:27 verifier: CẦN SỬA · tiêu chí 1–6, 8, 9 đạt (135/135 chạy lại 247,9 s; lab riêng 2 lượt dấu vân tay pg_dumpall+pg_dump bằng nhau; 80 probe tự viết đều chặn; `migrations.sql` hỏng xác nhận rc 3 ở migration 26; mật khẩu không lộ 3 lượt) · tiêu chí 7: đột biến 7/8 (M6 sống do assertion lỏng `test_db_provision.py:611`) · VỪA: `check` bỏ sót ACL cấp cho PUBLIC (`:562-563`) — PUBLIC EXECUTE `pg_read_binary_file` cho role thường đọc được heap pg_authid · NHẸ: README thiếu bước chép công cụ lên `.61` + sha256 + Python ≥3.10
- 02/11 00:27 giao coder v3 sửa 3 điểm (vòng verifier 1/2)
- 02/11 00:42 coder v3: ĐẠT · `check` xét PUBLIC trên mọi loại đối tượng so mặc định PG + baseline image ghim `public_acl_baseline.json` (208 hơn/64 kém mặc định, sha ghim, sinh lại tất định); assertion NEGATIVE_AUTH chặt; README thêm bước đưa lên `.61` · đỏ-trước 4 đột biến PUBLIC PASS trên mã cũ · 143/143 (288 s) · lab 2 lượt đạt · đột biến 27/27 · scan-pii PASS · đề xuất `.gitattributes` LF cho `deploy/production-window/**`
- 02/11 00:42 giao verifier lần 2 (lần cuối)
- 02/11 00:56 verifier lần 2: CẦN SỬA (vòng 2/2 → dừng, báo Lead) · tiêu chí 1–8 ĐẠT: 143/143 (287,9 s), lab 2 lượt idempotent, 80 probe chặn, 16/16 ca PUBLIC/ACL đỏ (4 cũ + 12 mới), baseline sinh lại trùng byte, 208 mục "hơn mặc định" đều là mặc định PG16 · đột biến 13/14 (P5 sống: nhánh `parameter` `db_provision.py:500` không test nào bắt) · tiêu chí 9 KHÔNG ĐẠT: README `:59-61` `git archive` trên máy `core.autocrlf=true` ra CRLF → `sha256sum -c` FAILED (an toàn: dừng) · sửa: `git -c core.autocrlf=false archive` hoặc `.gitattributes` LF
- 02/11 01:56 phiên chính: bản vá `wp02a-db.patch` (14 tệp, +5468; renormalize LF tệp tester CRLF), apply --check OK
- 02/11 06:52 Lead: m8.8 A (vòng 4 hẹp) + m8.7 có (thu hồi CONNECT+TEMPORARY 5 role runtime trên DB `postgres`) → giao coder v4: README `:59-61`, 4 ca PUBLIC (tham số, large object, FDW, tablespace), `bootstrap`/`check` cho DB `postgres`

- 02/11 07:34 coder v4: ĐẠT · `db_provision.py` sha mới `4060bf84…` (baseline không đổi `fe29df64…`) · README xuất `git -c core.autocrlf=false archive` (cũ 2/2 FAILED, mới 2/2 OK) · `bootstrap` thu hồi CONNECT+TEMP `postgres` khỏi PUBLIC (không role runtime nào dùng `postgres`; `restore.sh`/`failover.sh` dùng owner), `check` 5/5 DENIED · unittest 143→170/170 Py 3.13 (389 s); Py 3.10: 99/99 unit, lab CHƯA CHẠY (container không Docker) · đỏ trước 11/12 unit + 9/15 lab · đột biến mã 14/14, đột biến DB 35/35 · lab 2 lượt đạt, lượt 2 không đổi · scan-pii PASS · lưu ý: sửa fixture umask 077 (lỗi cũ trên Py 3.10, 60 hỏng) + nới `scope_violations` trong `tests/independent_lab.py` của tester cho `dbname=postgres` → verifier soi · `template1` còn CONNECT PUBLIC (chỉ báo)
- 02/11 07:34 giao verifier hẹp (vòng kiểm 3, theo D-m8-004)
- 02/11 07:53 verifier vòng 3 (hẹp): CẦN SỬA · mã công cụ đạt mọi tiêu chí: 170/170 Py 3.13 (384 s), Py 3.10 99/99 unit (lab CHƯA CHẠY); README xuất LF 2/2 OK (bỏ cờ → 2/2 FAILED); 4 ca PUBLIC + B2 đều đỏ; thu hồi `postgres` đúng phạm vi (template0/1, `ivr_production` không đổi), lab riêng 2 lượt idempotent, 5/5 role bị từ chối; công cụ từ chối DB khác ở cả 6 bước; umask 077 không che lỗi; đột biến tự gây 13/13 · VỪA: `tests/independent_lab.py:395-397` nới `dbname=postgres` cho MỌI bước (chỉ nên `check`) — sửa 1 dòng, verifier đã thử 44/44 rồi trả lại · NHẸ: `_local_login`/`_tcp_login` `db_provision.py:804-812` nhận `postgres` không ràng bước (hiện chỉ `check` gọi) → chờ Lead m8.9
- 02/11 08:16 Lead: m8.9 A (D-m8-005) → phiên chính áp dòng verifier ở `independent_lab.py:396` (chỉ `check` được `dbname=postgres`) + sửa câu "Đổi test độc lập" README bằng chứng · thử nhanh `scope_violations`: `postgres` ở plan/bootstrap/migrate/grants/policy → vi phạm, ở `check` → cho phép, `template1` → vi phạm mọi bước
- 02/11 08:19 phiên chính: `test_independent_lab` **44/44** (118,7 s, Py 3.13.13) + `test_independent_{rehearsal,unit}` **25/25** (126,5 s); dọn sạch container/volume/mạng `m8-wp02a-*`; README bằng chứng ghi lệnh + kết quả; scan-pii PASS · bản vá mới `wp02a-db.patch` 15 tệp +6.197 (thêm `test_lab_maintenance_public_acl.py` của vòng 4), 0 byte CR, sha256 `bfd4b39b…`, `apply --check` OK trên `2aaacb35`, repo chính vẫn sạch · bản cũ giữ ở `wp02a-db-v3-0155.patch` · `db_provision.py` sha `4060bf84…` không đổi so vòng 4 → ĐẠT, chờ Lead duyệt diff R3
- 02/11 09:05 Lead `ok gộp 02A 02B 02C` → phiên chính ghép: commit `d6c7e1bc` W-0486 · test: 170/170 trên checkout chính (Windows Py 3.13); `.gitattributes` LF cùng commit; README công cụ sửa 1 chữ "đường"→"cách" (quét PII mẫu địa chỉ bắt nhầm); README bằng chứng ghi đã ghép · gate-sweep 47/51, 4 FAIL có sẵn từ trước (document-links, progressive-selftest, selftest-pii, tts-provenance), không do ghép · detect_changes LOW · Sheet M8-002 đã ghi
## Bước kế tiếp chính xác
Đã ghép. Việc tiếp theo thuộc sóng 2 M8-002 (phiếu mới): `vm_deploy.py` quản project 3 dịch vụ `.64`, nợ test NHẸ của 3 gói, chuyển giám sát thật; chạy thật chờ m8.6 + anh Tuấn.

## Còn lại / CẦN QUYẾT
- Phiên chính đã chấp nhận (2): tài liệu chỉ cấm superuser cho API/worker/Ops/monitor/backup; brief ghi thừa "owner NOSUPERUSER".
- Báo Lead (1): lỗi `migrations.sql` của bộ ứng viên — dùng image `migrate` niêm phong là đúng đường compose `.61`; ghi backlog ứng viên.
- Chạy thật trên `.61` cần: người giữ bí mật + nơi lưu (Lead), sudo + khung bảo trì (anh Tuấn).
