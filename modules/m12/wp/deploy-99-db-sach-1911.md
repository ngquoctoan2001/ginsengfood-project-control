# Đổi `.99` sang DB sạch dựng từ seed production — thủ tục (D-m12-126, 19/11/2026)

Trạng thái: **ĐÃ CHẠY 20/11 07:33–07:39 VN (Toàn duyệt "Duyệt, chạy đi" = D-m12-128; kết quả ở §9; từ đây là hồ sơ thủ tục; SHA đích `3e84ab68b`, 19/11 ~22:3x; băm manifest seed ở SHA này `ffd88180…7911`, so lại ở A2; seed, bản vá, `db/validation`, `cutover-principal-m3.sh` không đổi từ `51f6fb1b8`; `836f76d61..3e84ab68b` chỉ đổi CI quét bí mật, 1 test FE và 1 dòng pin băm manifest ở `db/validation/profiles/production-staging-post-seed.json` = `ffd88180…7911`; đã kiểm git). — các lệnh dưới đây đã chạy đúng thứ tự, riêng C2 dùng `mang-mat-khau.sh`** · Rủi ro: R3 (máy thật, xoá dữ liệu thử khỏi sử dụng, mật khẩu, principal) · Người soạn: phiên m12 phụ (`.99`)
Quyết định: D-m12-126 (đổi `.99` sang DB sạch ngay sau khi lên bản mới, không lùi dữ liệu) · thay mốc D-m12-093/WP11b "đổi DB sạch lúc chạy thật 29–30/11".
Gốc: runbook [DB production sạch P1](../../../../ginsengfood-ops-core/docs/runbooks/release/10-11-17-30-db-production-sach-p1-runbook.md) (viết cho `.61`), [chuyển `.99`](../../../../ginsengfood-ops-core/docs/runbooks/release/13-11-15-00-chuyen-m12-sang-99-runbook.md), [tài khoản thật](../../../../ginsengfood-ops-core/docs/runbooks/release/03-11-21-50-tai-khoan-that-61-runbook.md), `tools/ops/cutover-principal-m3.sh`, lượt xoay principal 17/11 ([WP21](M12-WP21.md)).

## 0. Hiện trạng `.99` (chỉ đọc 19/11 ~22:0x; không in bí mật)

| Mục | Giá trị |
|---|---|
| Thư mục, project | `/data/ginsengfood-ops-core`, compose project `m12`, compose bản WP16 (KHÁC repo `deploy/m12/compose.yml` bản WP17: không `secrets/`) |
| Dịch vụ | `pg-ops` (postgres:18-alpine, không mở cổng ra máy), `ops-core-api`, `admin-web`, `public-trace`, `shopfloor-pwa`, `caddy`; image đang chạy `565272e01` (sẽ lên SHA mới trước thủ tục này) |
| Tên DB | một DB duy nhất `ginsengfood_operational` (298 MB) do `.env` `OPS_POSTGRES_DB`; user `ginsengfood`; chuỗi kết nối dựng trong `compose.yml` từ `OPS_POSTGRES_DB` + `OPS_POSTGRES_PASSWORD` (không có tệp `OperationalDb__ConnectionString`) |
| Môi trường API | `ASPNETCORE_ENVIRONMENT=Development`, `Auth__AdminBootstrap__Enabled=true` **cố định trong `compose.yml`**, không có biến mật khẩu bootstrap trong `.env` ⇒ mặc định Development (xem Rủi ro R1) |
| Migration | 154 (`20261115090000_RawLotQcPendingAndFgProvisionalCost`); SHA `3e84ab68b` thêm 155–157 ⇒ **157**, max `20261119120000_EAuthUserProfileNoInternalContactEmail` |
| Dữ liệu thử sẽ rời khỏi sử dụng | 41 tài khoản, 24 lệnh sản xuất, 15 NCC, 4 kho, 1 phiếu nhập NL, 26 số dư lô, 73 sự kiện outbox, 736 dòng audit, 94 phiên đăng nhập |
| Principal trong DB cũ | `SVC-M3-SELLABLE` (10 quyền, credential v5), `SVC-M6-ADS-RISK` (1 quyền, v2), `SVC-M3-TEST-NOPERM` (test), 3 principal N21 đã vô hiệu |
| Tệp bí mật principal | `m3.secret`, `m6.secret` (quyền 600, 44 byte, 17/11 07:26) trong thư mục compose — **chỉ kiểm quyền + cỡ, không đọc** |
| Sao lưu | cron 22:00 VN `sao-luu/daily-backup.py`, dump **`$POSTGRES_DB` của container `pg-ops`** (không ghi tên DB trong script), giữ 14 ngày; bản gần nhất 17/11 22:00 exit 0 |
| `du-lieu/api-var` | 416 KB, 5 tệp bằng chứng, chủ `10001:10001` |
| `/data` | 247 GB trống |

## 1. Quyết định cần Toàn chốt trước khi chạy (phiên m12 chính cấp số `m12.1xx`)

| # | Câu hỏi | Đề xuất của phiên này |
|---|---|---|
| Q1 | Tên DB mới | **`ginsengfood_ops_production`** (script `tao-db-production-sach.sh` và cổng E-07 chỉ nhận tên này; sau này đổi API sang Production không phải đổi tên). DB cũ `ginsengfood_operational` GIỮ NGUYÊN làm lưu trữ, **không DROP**. |
| Q2 | Mật khẩu 5 tài khoản seed 45 (`toan.nq`, `khanh.nk`, `sang.pv`, `dung.ptn`, `lan.vnm`) | **A (khuyên):** chép nguyên băm mật khẩu + cờ "bắt đổi mật khẩu" từ DB cũ sang DB mới bằng ống trong chính máy `.99` (không in, không ra ngoài máy); 5 người vào bằng mật khẩu tạm đang có, vẫn bị bắt đổi. 5 tài khoản này KHÔNG nằm trong 19 tài khoản dùng mật khẩu mặc định (R2). **B:** để khoá như seed, Toàn tự đặt lại từng người qua màn Người dùng — nhưng chưa ai vào được màn đó (không còn `admin`), nên B cần bước bootstrap có mật khẩu do Toàn đặt (`Auth__AdminBootstrap__Password`), phức tạp hơn. |
| Q3 | Mang sang bao nhiêu tài khoản | **Chỉ 5 người của seed 45.** 36 tài khoản còn lại (kể cả `admin`, `tung.nv` R-ADMIN, `phuc.tm` R-DEVOPS, tài khoản dev/UAT) KHÔNG mang: 19 trong số đó đang dùng mật khẩu mặc định. Ai cần thì Toàn tạo lại qua màn Người dùng với mật khẩu mới. Vai chỉnh tay trên DB cũ ngoài bảng seed 45 (nếu có) mất, gán lại qua giao diện. |
| Q4 | Secret M3/M6 trên DB mới | **Dùng lại `m3.secret`/`m6.secret` đang ở `.99`** nếu Toàn xác nhận đó là bản M3 và M6 đang cầm (WP21 17/11: xoay M3 → v5, M6 → v2 từ chính hai tệp này) ⇒ Phúc, Tài **không phải đổi gì**. Không chắc ⇒ sinh tệp mới bằng `cutover-principal-m3.sh sinh-secret` (từ chối ghi đè nên đổi tên tệp cũ trước) rồi giao 1:1 cho Phúc/Tài bằng tệp. |
| Q5 | Giờ chuyển + báo ai | API ngắt **~2–3 phút**; mọi người đăng nhập lại (DB mới không có phiên). Báo Phúc (M3 đang tắt, quan sát từ 20/11), Tài (M6), xưởng/kho/kế toán. Đề xuất: ngoài ca xưởng, trước 22:00 để bản sao lưu đêm chụp luôn DB mới. |
| Q6 | Sửa `compose.yml` `.99`: `Auth__AdminBootstrap__Enabled` từ `"true"` sang `"false"` (một dòng, sao lưu tệp trước) | **Bắt buộc** (R1). Không sửa thì lần khởi động API đầu tiên trên DB sạch TỰ TẠO tài khoản `admin` (R-ADMIN) với mật khẩu mặc định ghi trong mã nguồn. |
| Q7 | 19 tài khoản đang dùng mật khẩu mặc định trên DB hiện tại (R2): xử lý ngay hay chờ tới lúc chuyển | Phiên này **không động tới**. Toàn quyết: khoá/đặt lại bằng giao diện ngay, hoặc đưa giờ chuyển lên sớm. |
| Q8 | `SVC-M3-TEST-NOPERM` (principal thử) | Không tạo lại trên DB mới. |

## 2. Rủi ro đã đo (đọc trước khi duyệt)

- **R1 — bootstrap `admin` mặc định.** `AdminBootstrapHostedService` ở Development tạo `admin` (R-ADMIN) bằng mật khẩu mặc định của mã nguồn khi tài khoản chưa có. DB cũ đã có `admin` (mật khẩu đã đổi, đo: không khớp mật khẩu mặc định) nên bị bỏ qua; DB sạch thì **không**. Cổng G-ADMIN: sửa Q6 TRƯỚC lần khởi động API đầu tiên trên DB mới, và kiểm sau (log "Admin bootstrap disabled", `auth_user` = 5, không có `admin`).
- **R2 — đang có lỗ hổng sống trên `.99`:** 19/41 tài khoản ACTIVE khớp mật khẩu mặc định Development, gồm 1 R-ADMIN và 1 R-DEVOPS (đo bằng so khớp băm trong Postgres, không đăng nhập thử; danh sách ở `ra-soat/2026-11-19-db-sach-99/` ngoài git). `ops.ginsengfood.vn` đi qua nginx của Anh Tuấn, DNS trỏ về IP công cộng của nhà máy: nếu nginx không giới hạn nguồn thì với tới được từ ngoài LAN (CHƯA KIỂM phía nginx). Thủ tục này loại bỏ chúng, nhưng chỉ khi chuyển xong.
- **R3 — sao lưu theo `$POSTGRES_DB` của container.** Đổi `OPS_POSTGRES_DB` trong `.env` chưa đủ: phải tạo lại container `pg-ops` (`up -d` đủ bộ) thì `POSTGRES_DB` trong container mới đổi, nếu không cron 22:00 vẫn dump DB cũ. Bước C6 kiểm bằng tiêu đề dump.
- **R4 — E-07 xung đột với việc chép băm mật khẩu.** E-07 đòi 5 tài khoản còn băm khoá của seed. Vì vậy E-07 + `seed-lai` chạy TRƯỚC khi chép băm; sau khi chép không chạy lại `kiem-lai`/`seed-lai` (sẽ đỏ `E07_PILOT_ACCOUNT_CREDENTIAL_UNSAFE` — đúng thiết kế, không phải lỗi).
- **R5 — script chưa từng chạy trên compose WP16 của `.99`.** `tao-db-production-sach.sh` thử trên compose WP17 (smoke 44 ca) và `.61`; bước A3 `kiem-tra` là phép thử đầu tiên trên `.99`, không ghi gì. Script chép băm (C3) là **mới**, phải viết + thử trên Postgres dùng một lần (tester độc lập) trước khi chạy `.99`.
- **R6 — link M3 hỏng.** Kho thành phẩm `WH_FG_MAIN` và dữ liệu kho tạo lại ⇒ id kho mới; M3 giữ id cũ trong `ops_core_warehouse_links` (cảnh báo KHO-M12-02 "cấm tạo lại kho FG đã link"). Chấp nhận theo D-m12-126; xuất link + nạp lại ở §6.
- **R7 — `ASPNETCORE_ENVIRONMENT=Development` vẫn giữ** (đổi sang Production là gói riêng: cần `secrets/`, compose WP17, `ExpectedDatabase`); thủ tục này chỉ chuẩn bị tên DB cho nó.

## 3. Điều kiện vào

1. Phiên WP26 [9199d3] đã `deploy-99` SHA mới (`3e84ab68b` = `3e84ab68bf68243057dce04e0a69ae2678f7b846`, main 19/11, có migration 157): `.env` `M12_BAN=3e84ab68bf68243057dce04e0a69ae2678f7b846`, 4 dịch vụ app healthy, `/health/live` + `/health/ready` 200 (Host `api-ops.`), DB cũ `count=157` max `20261119120000_…`, `docker image ls` có `ops-core-migrate:3e84ab68bf68243057dce04e0a69ae2678f7b846`.
**Đã đạt khi đọc chỉ-đọc 20/11 06:11 VN (phiên WP26 [0e8719] deploy-99 `3e84ab68b` PASS 06:09):** `M12_BAN=3e84ab68b`, 4 app healthy `3e84ab68b`, `/health/live` + `/health/ready` 200, DB cũ 157 migration (max `20261119120000_…`), 0 nhân viên có mail liên hệ, image `ops-core-migrate:3e84ab68b` có, 0 giao dịch mở > 60 s, `/data` 243 GB trống, bản sao lưu ngay trước migrate `ops-pilot-daily-20261119T230902Z-b22649bb`, `compose.yml` bootstrap vẫn `"true"` (chờ Q6).
2. Toàn đã trả lời Q1–Q8; giờ chuyển đã báo (Q5). **Chưa có.**
3. Không giao dịch mở > 60 s; `/data` ≥ 20 GB trống; không phiên khác đang chạy `trien-khai.sh` (`.trien-khai.lock`).
4. Trong shell ssh KHÔNG có `PGHOST`, `PGDATABASE`, `DATABASE_URL`, `OperationalDb__*`; không `export OPS_POSTGRES_DB` (script tự từ chối).

Đặt biến cho các lệnh dưới (trên `.99`, `ssv`):

```bash
G=/data/ginsengfood-ops-core; S=$G/tam-seed; DB=ginsengfood_ops_production; cd $G
M=<băm manifest ghi ở A2>
T="bash $S/deploy/seed/tao-db-production-sach.sh"; O="--nguon $S --compose-dir $G --manifest-sha256 $M"
pq() { docker compose exec -T pg-ops sh -c 'exec psql -X -q -At -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$1"' _ "$1"; }   # stdin = lệnh SQL
```

## 4. Các bước (Toàn duyệt từng lệnh ghi; mỗi pha một khối)

### Pha A — chuẩn bị, không đổi DB đang chạy (~15 phút)

| # | Việc | Lệnh | Kiểm "xong" | Lùi |
|---|---|---|---|---|
| A1 | Lưu trữ DB cũ ra ngoài vòng xoay 14 ngày | `python3 sao-luu/daily-backup.py` rồi `mkdir -p /data/sao-luu/ginsengfood-ops-core/luu-tru-db-thu-1911 && cp -p` tệp `.dump` + `.dump.json` mới nhất vào đó, `sha256sum` ghi sổ | `.dump.json` `PASS`; `pg_restore --list` thấy `Database: ginsengfood_operational` | xoá bản chép |
| A2 | Chép gói seed đúng SHA (máy Lead, Git Bash) | `git -C /c/Projects/ginsengfood-ops-core archive 3e84ab68b deploy/seed db/seeds db/validation/profiles/production-staging-boundary.sql docs/software-specs/data/csv tools/ops/cutover-principal-m3.sh \| gzip \| ssh ssv@192.168.1.99 'mkdir -p /data/ginsengfood-ops-core/tam-seed && tar -xzf - -C /data/ginsengfood-ops-core/tam-seed'`; ghi `sha256sum $S/deploy/seed/production-seed-manifest.sha256` = **M** và băm `git show 3e84ab68b:deploy/seed/production-seed-manifest.sha256 \| sha256sum` | hai băm khớp; script A3 tự kiểm 47+ tệp theo manifest (CRLF làm lệch băm thì dừng `SEED_LECH`) | `rm -rf $S` |
| A3 | Kiểm điều kiện, **không ghi gì** | `$T kiem-tra $O` | `TAO_DB_SACH_KIEM_TRA_DAT … trang_thai_db=chua-co` (không dòng `LUU_Y` thiếu image) | — |

### Pha B — dựng DB sạch bên cạnh, API vẫn chạy DB cũ (~10–15 phút, không ngắt dịch vụ)

| # | Việc | Lệnh | Kiểm "xong" | Lùi |
|---|---|---|---|---|
| B1 | Tạo DB rỗng → migrate (`ops-core-migrate:3e84ab68bf68243057dce04e0a69ae2678f7b846`) → seed production ×2 → E-07 | `$T tao --db $DB $O --so-migration 157` | `E07_PRODUCTION_BOUNDARY_PASS\|…\|157\|19\|19\|19\|38` và `TAO_DB_SACH_XONG db=ginsengfood_ops_production migrations=157 auth_user=5 e07=PASS`. Không sửa `.env`, không động `pg-ops` | dừng giữa chừng: runbook P1 §8 (DB mới chưa mang dữ liệu thật, Toàn quyết xoá tay rồi `tao` lại); DB cũ không bị đụng |
| B2 | Chứng minh seed lặp không đổi gì | `$T seed-lai --db $DB $O` | `TAO_DB_SACH_SEED_LAI_KHONG_DOI` | — |
| B3 | Principal M3/M6 (secret từ tệp 0600 có sẵn, Q4) | `bash $S/tools/ops/cutover-principal-m3.sh tao --may 99 --db $DB --nguon $S --manifest-sha256 $M` (chạy khô) rồi thêm `--thuc-hien` | `TAO_DB_SACH_PRINCIPAL_XONG db=ginsengfood_ops_production principals=2`; 2 dòng `PRINCIPAL …\|ACTIVE\|HASHED_TOKEN\|hash=$2…` quyền M3 = 10, M6 = 1 | một giao dịch: lỗi thì không để lại gì; tạo nhầm: Toàn quyết, DB mới chưa dùng nên dựng lại |
| B4 | Tài khoản thật: seed 45 đã tạo 5 người + vai theo bảng D-m12-010 (gồm R-BOD chú Dũng, email NULL theo WP29); chạy thử bản vá, KHÔNG chạy thật | `sed 's/^COMMIT;$/ROLLBACK;/' $S/deploy/seed/patches/2026-11-03-tai-khoan-that-61.sql \| docker compose exec -T pg-ops sh -c 'psql -X -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d ginsengfood_ops_production'` (`$S/deploy/seed/patches/` có trong gói A2) | `WP14_PATCH_OK`, bảng SAU khớp bảng vai, khối "Dong audit lan chay nay" **rỗng**, dòng cuối `ROLLBACK`. Có bất kỳ thay đổi ⇒ DỪNG báo Toàn | không ghi gì |
| B5 | Kiểm lại E-07 chỉ đọc (lần cuối trước khi chép băm, R4) | `$T kiem-lai $O` | `TAO_DB_SACH_KIEM_LAI_DAT` | — |
| B6 | So lược đồ DB cũ với DB mới | chạy cùng một khối SQL trên hai DB: `pq ginsengfood_operational <<'SQL'` … `SQL` rồi `pq $DB <<'SQL'` … `SQL`, khối = `SELECT count(*), md5(string_agg("MigrationId", ',' ORDER BY "MigrationId")) FROM "__EFMigrationsHistory"; SELECT count(*) FROM information_schema.tables WHERE table_schema = 'public';` | số migration + băm danh sách khớp nhau (157); số bảng bằng nhau | — |

**Điểm dừng 1:** gửi Toàn đầu ra B1–B6 (19 SKU/19 G1/38 GTIN, 5 người dùng, 2 principal, 157 migration) trước khi sang pha C.

### Pha C — chuyển API sang DB mới (~10 phút, API ngắt ~2–3 phút)

| # | Việc | Lệnh | Kiểm "xong" | Lùi |
|---|---|---|---|---|
| C0 | Sao lưu cấu hình (giữ quyền 0600) | `ts=$(date -u +%Y%m%dT%H%M%SZ); cp -p .env .env.truoc-db-sach-$ts; cp -p compose.yml compose.yml.truoc-db-sach-$ts` | hai tệp có, quyền như gốc | xoá |
| C1 | Dừng API (DB cũ ngừng nhận ghi) | `docker compose stop ops-core-api` | `docker compose ps` API Exited; **mốc ngắt bắt đầu** | `docker compose up -d ops-core-api` |
| C2 | Chép băm mật khẩu 5 người (Q2-A; script **chưa viết**, R5) | `mang-mat-khau.sh` (sẽ nằm ở `_wt/m12/db-sach-99/`, thử trên Postgres dùng một lần trước): MỘT phiên psql vào DB mới — `BEGIN; CREATE TEMP TABLE … ON COMMIT DROP; COPY … FROM STDIN` nhận từ `COPY (SELECT username, password_hash, password_change_required FROM auth_user WHERE username IN (5 tên)) TO STDOUT` chạy trên DB cũ qua ống; `UPDATE auth_user … WHERE username khớp`; kiểm đúng 5 dòng đổi, `status`/vai không đổi; `COMMIT`. Không `-e`/xtrace, không in dữ liệu COPY | in `MANG_MAT_KHAU_OK 5/5`; không dòng nào chứa băm | ROLLBACK tự động khi lỗi; DB mới còn khoá như seed |
| C3 | Cất dữ liệu tệp của DB cũ (có root: dùng hộp như `chuyen-99`) | `docker run --rm --network none -v $G/du-lieu:/d postgres:18-alpine sh -c 'mv /d/api-var /d/api-var.truoc-db-sach-'$ts' && mkdir /d/api-var && chown 10001:10001 /d/api-var && chmod 755 /d/api-var'` | `ls -ld du-lieu/api-var` chủ `10001:10001`, rỗng | `rm -rf du-lieu/api-var && mv du-lieu/api-var.truoc-db-sach-$ts du-lieu/api-var` |
| C4 | Trỏ sang DB mới + tắt bootstrap (G-ADMIN, Q1+Q6) | `sed -i 's/^OPS_POSTGRES_DB=.*/OPS_POSTGRES_DB=ginsengfood_ops_production/' .env` và `sed -i 's/Auth__AdminBootstrap__Enabled: "true"/Auth__AdminBootstrap__Enabled: "false"/' compose.yml`; `docker compose config -q`; `diff compose.yml.truoc-db-sach-$ts compose.yml` chỉ đúng 1 dòng; `grep -c '^OPS_POSTGRES_DB=ginsengfood_ops_production$' .env` = 1 | diff đúng 1 dòng, `config -q` thoát 0 | khôi phục từ hai tệp `.truoc-db-sach-$ts` |
| C5 | Đổi container: `pg-ops` tạo lại 1 lần (dữ liệu ở volume, mất kết nối vài giây), API lên với DB mới | `docker compose up -d --no-build --wait --wait-timeout 180` | `pg-ops` + `ops-core-api` healthy; `docker compose exec -T pg-ops printenv POSTGRES_DB` = `ginsengfood_ops_production`; `curl -H 'Host: api-ops.ginsengfood.vn' http://127.0.0.1:5000/health/live` và `/health/ready` = 200; log API có "Admin bootstrap disabled", KHÔNG có "Admin bootstrap created"; **mốc ngắt kết thúc** | mục Lùi §5 |
| C6 | Kiểm sau chuyển | `echo "SELECT count(*), count(*) FILTER (WHERE username='admin') FROM auth_user" \| pq $DB` → `5\|0`; migration 157; `SELECT count(*) FROM op_warehouse` = 0; chạy tay `python3 sao-luu/daily-backup.py`: `.dump.json` PASS và `pg_restore --list` thấy `Database: ginsengfood_ops_production`; `cutover-principal-m3.sh kiem-db --may 99 --db $DB` PASS; 0 lỗi API 5 phút đầu; `https://ops.ginsengfood.vn/login` 200, `https://pwa.ginsengfood.vn` 307, `https://trace.ginsengfood.vn` 200; đăng nhập `toan.nq` bằng mật khẩu tạm đang có (Toàn làm, bị bắt đổi) | các dòng trên đều đạt | R3: nếu dump vẫn ra DB cũ ⇒ `pg-ops` chưa tạo lại, dừng báo |
| C7 | Dọn gói tạm | `rm -rf $S` (gói seed + công cụ lần này; không chứa bí mật; `/tmp/m12-seed-lan4` của lượt `ee99e9fd6` đã không còn khi đọc 20/11) | thư mục không còn | — |

`OPS_POSTGRES_DB` đổi nên `trien-khai.sh`/`deploy-99` sau này migrate + sao lưu đúng DB mới (nó đọc `.env` + `$POSTGRES_DB`). DB cũ **không còn được migrate**: giữ ở 157, chỉ để lưu trữ/đọc.

## 5. Điểm lùi

- **Trước C4:** chưa đổi gì ngoài DB mới nằm cạnh. Lùi = bật lại API (`docker compose up -d ops-core-api`) nếu đã dừng ở C1; DB mới bỏ đó (không xoá, Toàn quyết).
- **Sau C5 (API đã chạy DB mới):** `docker compose stop ops-core-api`; `cp -p .env.truoc-db-sach-$ts .env`; `cp -p compose.yml.truoc-db-sach-$ts compose.yml`; trả `du-lieu/api-var` (C3); `docker compose up -d --no-build --wait` (API về DB cũ, đang ở 157 = cùng image); kiểm health. Dữ liệu cũ nguyên vẹn vì API dừng từ C1 và không ai ghi DB cũ; **mọi thứ ghi vào DB mới sau C5 không tự về DB cũ** (đúng ý "không lùi dữ liệu" của Toàn). Lùi hết mất ~3 phút.
- **Lùi image** (về `565272e01`) không hỗ trợ: DB cũ đã ở 157. Cần thì khôi phục bản A1 (sao lưu trước migrate là bản của `deploy-99`).
- Không có lệnh `DROP`/`TRUNCATE`/`RENAME` ở bất kỳ bước nào. Xoá DB cũ hoặc đổi tên là quyết định riêng của Toàn sau khi chạy ổn ≥ 1 tuần.

## 6. Sau chuyển: việc nhập liệu thật + nối lại M3 (thứ tự, không nằm trong cửa sổ ngắt)

1. Lan (`/admin/master-data/warehouses`): kho, vị trí kho; Dũng: ca sản xuất; NCC, vùng nguồn, B3 min/max 8 vật tư, `shelf_life_days` 19 SKU, thiết bị PWA (`/admin/system/mobile-devices`, cấp mã + QR theo WP24), máy in — danh sách đầy đủ ở runbook P1 §7.
2. Kích hoạt bán 19 SKU: `tools/db/Invoke-SkuActivation.ps1` (cần đăng nhập, SKU-M12-02).
3. Nối M3: `cutover-principal-m3.sh xuat-link --may 99 --db $DB --thuc-hien` (CHỈ đọc, ra `skus.csv` + `kho-m12.csv`) → phiên m34/Phúc nạp lại link SKU/kho vào M3 → `tools/ops/kiem-link-m3.sh` + `kiem-token`. M3 thấy danh mục/tồn rỗng cho tới khi xong (D-m12-126).
4. Thêm tài khoản người dùng khác qua màn Người dùng (mật khẩu mới), gán vai; cờ mail công ty WP26 vẫn **tắt** (`Auth__EmailLogin__Enabled=false`, đã có 7 khoá trong `.env`) cho tới khi Toàn bật.

## 7. Bước CHỈ Toàn làm hoặc duyệt

- Trả lời Q1–Q8; báo Phúc/Tài/xưởng giờ ngắt (Q5).
- Duyệt từng lệnh ghi ở A1–C7 (mỗi lệnh `--thuc-hien`, sửa `.env`/`compose.yml`, `docker compose up/stop`).
- Xác nhận `m3.secret`/`m6.secret` đúng là bản M3/M6 đang dùng (Q4); nếu sinh mới thì giao tệp 1:1 cho Phúc/Tài (không qua chat) và xoá bằng `shred -u`.
- Mật khẩu: Toàn không gõ gì ở Q2-A; sau chuyển tự đăng nhập `toan.nq` kiểm. Nếu chọn Q2-B: Toàn tự nhập `Auth__AdminBootstrap__Password` vào `.env` (không qua chat/sổ), đăng nhập `admin`, đặt lại 5 người, rồi tắt bootstrap.
- `scp`/chép gói A2 (lệnh ssh pipe do Toàn duyệt).
- Không gõ mật khẩu, khoá, secret vào sổ này, nhật ký hay chat.

## 8. CHƯA CHẠY / chưa kiểm

- Mọi lệnh ghi ở trên (A1–C7). Chỉ có đọc `.99` ngày 19/11 ~22:0x.
- `mang-mat-khau.sh` (C2) chưa viết, chưa thử.
- `tao-db-production-sach.sh` + `cutover-principal-m3.sh tao` trên compose WP16 của `.99` (R5); đo thời gian thật của B1.
- Số 157 là số của `3e84ab68b` (phiên m12 [f1e7c3] báo; đếm ở DB cũ sau deploy-99 để xác nhận); kiểm lại ở §3 bước 1.

## 9. Kết quả 20/11/2026 (D-m12-128, phiên m12 phụ `.99`) — XONG, 0 lệnh lệch thủ tục

Bằng chứng (ngoài git): `ra-soat/2026-11-19-db-sach-99/` (`b1-tao.log`, `phac-chuyen-api.log`, `mang-mat-khau.sh`, danh sách 19 tài khoản mật khẩu mặc định). SHA `3e84ab68bf68243057dce04e0a69ae2678f7b846`.

- **A (07:32–07:34 VN):** A1 sao lưu DB cũ `ops-pilot-daily-20261120T003226Z-68aa5069` PASS (16,5 MB, 2.055 mục, `dbname: ginsengfood_operational`, sha256 khớp), chép sang `/data/sao-luu/ginsengfood-ops-core/luu-tru-db-thu-1911/`. A2 gói seed chép bằng `git archive`, băm manifest `ffd88180…7911` = git, `sha256sum -c` OK, không CRLF. A3 `kiem-tra` ĐẠT trên compose WP16 (R5 hết): `trang_thai_db=chua-co`.
- **B (07:33–07:37, API vẫn chạy DB cũ):** B1 `tao` 58 giây: migrate 157, seed ×2 (42 tệp + 6 csv), `E07_PRODUCTION_BOUNDARY_PASS|…|157|19|19|19|38`, `auth_user=5`. B2 `seed-lai` không đổi (215 bảng). B3 principal `SVC-M3-SELLABLE` (10 quyền) + `SVC-M6-ADS-RISK` (1 quyền), BCrypt 12, hạn 19/05/2027, tạo từ `m3.secret`/`m6.secret` đang có. B4 bản vá tài khoản chạy thử ROLLBACK: `WP14_PATCH_OK`, 0 dòng audit, TRƯỚC = SAU (không cần chạy thật). B5 `kiem-lai` PASS. B6 DB cũ và DB mới cùng 157 migration, cùng băm danh sách `e2143b6252b9`, cùng 237 bảng.
- **C2 script:** `mang-mat-khau.sh` viết + thử trên Postgres 18 dùng một lần: 25/25 PASS (chạy tốt, thử ROLLBACK không đổi, 4 kịch bản từ chối — thiếu tài khoản, băm khớp mật khẩu mặc định, băm không phải BCrypt, DB mới thiếu — đều không đổi DB, trùng tên DB, tham số lạ, đột biến bỏ kiểm mật khẩu mặc định bị bắt). Chạy `thu` trên `.99` (ROLLBACK) đạt rồi mới `that`.
- **C (00:38:03–00:38:26Z = 07:38 VN, API ngắt ~23 giây):** C0 sao lưu `.env` + `compose.yml` (`.env.truoc-db-sach-20261120T003803Z`, `compose.yml.truoc-db-sach-…`, quyền giữ 600/644) · C1 dừng API · C2 `MANG_MAT_KHAU_OK 5/5` · C3 `du-lieu/api-var` cất sang `api-var.truoc-db-sach-…` + tạo thư mục rỗng `10001:10001` · C4 `.env` `OPS_POSTGRES_DB=ginsengfood_ops_production`, compose `Auth__AdminBootstrap__Enabled: "false"` (diff đúng 1 dòng) · C5 `up -d --wait`: `pg-ops` tạo lại 1 lần, API healthy sau 20 giây, `live=200 ready=200`.
- **C6 kiểm sau:** `pg-ops` `POSTGRES_DB=ginsengfood_ops_production`; migration 157 (max `20261119120000_EAuthUserProfileNoInternalContactEmail`); `auth_user=5`, **không có `admin`**, 5 ACTIVE; 0 kho/NCC/lệnh SX/outbox/phiên; băm mật khẩu 5 người **khớp DB cũ** (so md5 trong shell, kèm cờ bắt đổi mật khẩu); log API "Admin bootstrap disabled"; 0 lỗi Error/Critical (đo lúc +1 phút và +5 phút 00:43Z; chỉ có cảnh báo khởi động bình thường của DataProtection/cổng và 1 lượt 401 `/admin/auth/me` chưa đăng nhập); sao lưu thử ra `ops-pilot-daily-20261120T003855Z-48d9825b` PASS với `dbname: ginsengfood_ops_production` (R3 hết: cron 22:00 sẽ dump DB mới); `kiem-db` principal **PASS 7/7**; từ máy Lead: `https://ops.ginsengfood.vn/login` 200, `https://pwa.ginsengfood.vn` 307, `https://trace.ginsengfood.vn` 200.
- **C7:** `tam-seed` và tệp tạm đã xoá; giữ để lùi/lưu trữ: `.env.truoc-db-sach-*`, `compose.yml.truoc-db-sach-*`, `du-lieu/api-var.truoc-db-sach-*`, `luu-tru-db-thu-1911/`, và DB cũ `ginsengfood_operational` (41 tài khoản, 24 lệnh SX, 774 dòng audit, nguyên vẹn, không app nào nối).
- **CHƯA CHẠY / chưa kiểm:** (1) đăng nhập thật của 5 người (Toàn tự làm; mình không có mật khẩu, chỉ kiểm băm khớp DB cũ); (2) `kiem-token` của M3/M6 bằng secret thật (phía m34/Phúc; script tạo principal đã tự kiểm băm khớp tệp secret trước COMMIT, nhưng chỉ kiem-token mới chứng minh M3 cầm đúng tệp đó); (3) `ASPNETCORE_ENVIRONMENT` vẫn Development (R7); (4) nhập liệu thật + nối lại link M3 (§6).
- **Q7:** 19 tài khoản mật khẩu mặc định (1 R-ADMIN) chỉ còn ở DB cũ lưu trữ, không app nào nối ⇒ lỗ hổng trên `.99` đã đóng; DB cũ chỉ vào được bằng `psql` trên máy.
- **Lùi (nếu cần, ~3 phút):** `docker compose stop ops-core-api`; `cp -p .env.truoc-db-sach-20261120T003803Z .env`; `cp -p compose.yml.truoc-db-sach-20261120T003803Z compose.yml`; trả `api-var` (xoá thư mục rỗng mới rồi `mv api-var.truoc-db-sach-… api-var`, quyền `10001:10001`); `docker compose up -d --no-build --wait`. Mọi thứ ghi vào DB mới sau 07:38 không về DB cũ.
