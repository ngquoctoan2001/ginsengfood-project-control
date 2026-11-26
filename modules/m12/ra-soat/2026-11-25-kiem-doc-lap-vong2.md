# Kiểm độc lập cổng Nguy hiểm, vòng 2 (25/11/2026, D-lead-064)

Hai verifier độc lập chạy nền sau khi code vào `main` cục bộ. Không có khoá/mật khẩu/băm trong tệp này. Báo cáo đầy đủ ở thư mục tạm của phiên (không vào git).

## V2: gói chuyển `.99` sang Production, commit `710b89a01` — CẦN SỬA (không CHẶN)

Không có lỗi S1 tái hiện được: không đường nào làm mất dữ liệu CSDL, lộ bí mật hay chạm container Postgres trong luồng thường. 6 lỗi S2 phải sửa trước khi Toàn chạy. Gốc chung: bộ kiểm của coder chỉ chạy trên Git Bash Windows; trên Linux thật (môi trường `.99`) lộ thêm lỗi (C.UTF-8 370/0/1, en_US.utf8 367/3/1).

| # | Mức | Lỗi | Hướng sửa |
|---|---|---|---|
| F1 | S2 | regex `[\!-\~]+` sai dưới `en_US.UTF-8` ⇒ chạy lại P3 xoay nhầm bí mật proxy trang QR ⇒ giới hạn theo IP của trang QR hỏng lặng lẽ | `[[:graph:]]`, `LC_ALL=C`, kiểm bí mật container = `.env` |
| F2 | S2 | đổi khoá JWT làm M3 nhận 401 một lần rồi tự xin token lại (200); P7 đếm mọi 401 là lỗi ⇒ báo hỏng oan | chỉ 403/429 là lỗi; 401 lỗi nếu lần cuối vẫn 401 |
| F3 | S2 | thử đệm webhook từ container API CŨ (chưa có `extra_hosts`) ⇒ báo 000 rồi tự lùi oan | thử sau khi API mới lên; hỏng chỉ cảnh báo |
| F4 | S2 | quên `--tao-lai-caddy` vẫn "XONG" trong khi Caddy giữ dải tin cũ `/23` | P7 so môi trường container caddy với `.env` |
| F5 | S2 | không dặn chạy trong tmux/nohup; mất ssh giữa `compose up` có thể mất API | bắt buộc tmux, trap SIGHUP, dòng "ssh lại, `bash lui.sh`" |
| F6 | S2 | `p2 --xoay` sinh lại khoá mã hoá bằng chứng, không giữ bản cũ ⇒ bằng chứng mã hoá mất vĩnh viễn | từ chối khi kho có đối tượng mã hoá; luôn lưu bản cũ |

S3 (nợ, ghi trong báo cáo đầy đủ): dry-run dừng ở P5; P6 chạy một mình sau lùi báo đạt sai; `lui.sh` ghi LUI_XONG cả khi lỗi và trả cấu hình lai khi mất bản sao; tệp trạng thái 644; `M12_SECRETS_DIR` lạ bị chmod; `.env.truoc-production-*` giữ khoá lịch sử vô hạn; allowlist cũ rộng `/8` im lặng; chưa từng chạy bộ kiểm ở Linux. Đột biến: 37 thử, 26 bị bắt, 11 không ai bắt (cần thêm ca âm).

Thứ CHƯA CHẠY: cả gói trên `.99` thật; shellcheck; hairpin container→proxy `.98`→Caddy; OTP/SMTP thật; IP nguồn M12 thấy từ M3; hành vi `compose up` khi mất ssh; `ssv` ∈ nhóm docker và ảnh có sẵn trên `.99`.

**Xử lý:** coder `m12/prod99-fix` sửa F1–F6 + S3 + ca âm cho 11 đột biến, chạy bộ bash cả Windows và Linux hai locale; sau đó chấm lại đúng phần sửa.

## V1: F2/F3 `397fefb24`, WP32+S3 `007cea669`, m12.211 `ae147decf`, OPS-01 `ec942c357` — cả 4 ĐẠT

Không có lỗi S1. HEAD đầu = cuối = `710b89a01`, `git diff HEAD` trên tệp của 4 gói rỗng suốt lượt. Chạy lại: unit 128/0/0, integration (Testcontainers) 128/0/0 (9 phút 17 giây), Governance 1130/0/0. 16 đột biến: 15 bị bắt, 1 KHÔNG ai bắt (bỏ qua vai INACTIVE của tài khoản đích ở F2). Đua đồng thời hai quản trị gỡ vai/vô hiệu hoá nhau 120 lượt: luôn đúng một bên thắng, luôn còn một quản trị. Ma trận ký chuẩn hoá hoa/thường/khoảng trắng, chỉ một nơi ghi (PUT). Cờ tắt trả 404 cả hai route. Mã dùng một lần, đổi mật khẩu thu hồi phiên.

| # | Mức | Phát hiện | Xử lý |
|---|---|---|---|
| 2-S2 (có điều kiện) | S2 | Tài khoản R-ADMIN/R-DEVOPS/ADMIN_FULL vẫn đăng nhập được bằng mã mail (mục đích LOGIN); chiếm hộp thư công ty của quản trị cho phiên ADMIN_FULL mà không cần đặt lại mật khẩu. Cờ reset đòi cờ đăng nhập mail đang BẬT trên `.99` | **m12.236** chờ Toàn quyết: A chấp nhận và ghi quyết định "hộp thư công ty là yếu tố đăng nhập của quản trị" (đề xuất; mail công ty do IT quản, Toàn đang dùng) hoặc B chặn LOGIN bằng mã mail cho quản trị |
| 2-S3a | S3 | Kẻ lạ vẫn khoá hộp thư 24 giờ bằng 3 lần `start` (nạn nhân nhận 3 thư) + 15 sai trên mã sống | Chấp nhận theo thiết kế (mật khẩu vẫn đăng nhập được, cờ reset TẮT); ghi nợ: khoá theo cặp (hộp thư, IP) hoặc chỉ làm chết mã |
| 2-S3b | S3 | `IsPrivilegedAccount` bỏ qua vai ADMIN_FULL đang INACTIVE trong khi F2 đếm vai INACTIVE | Coder `m12/fix-gate2-s3` đang vá + test |
| 1-S3a | S3 | Không test nào ghim "vai INACTIVE của đích vẫn tính" (đột biến sống) | Cùng coder thêm ca |
| 1-S3b | S3 | `RevokeUserSessions`, `AssignUserRole`, `UpdateUserProfile` không qua guard đích; token chỉ `USER_MANAGE` ép đăng xuất một quản trị (không leo quyền) | Ghi nợ |
| 1-S3c | S3 | `DeactivateInternalUser` chốt "admin cuối" theo mã `R-ADMIN` cứng | Ghi nợ (người thao tác phải là ADMIN_FULL) |
| 3-S3a | S3 | Sàn m12.211 bảo đảm ô ký tồn tại, không bảo đảm người ký khác nhau; admin/nhiều vai tự ký đủ 3 ô | Chấp nhận (người sản xuất đơn vai chỉ ký được DAY_LEADER, đúng mục tiêu) |
| 3-S3b | S3 | Ma trận đã lưu dưới sàn từ trước không bị đụng | Thêm kiểm chỉ đọc ở P0 của gói Production |
| 4-S3 | S3 | Quét sống OPS-01 tính cả tệp tạm `*.uploading` ⇒ `STARTUP_SCAN_NOT_CLEAN` | Thêm kiểm P0 + bước dọn tay trong runbook |

Chủ ý ghi trong mã (D-m12-099), không phải lỗi: ADMIN_FULL đặt lại mật khẩu/gắn mail cho tài khoản mang bốn mã miễn rồi đăng nhập thay họ (chỉ có audit).

CHƯA CHẠY: vitest form-signing (phiên chính đã chạy 9/0), Pester M12CD02 (phiên chính đã chạy 1025/1025), ApiContract, SchemaSmoke, kiểm hiện trường `.99`, luồng ký thật cho m12.211.

## V2 lượt 2: gói Production sau sửa, commit `1472c5a5a` — ĐẠT

Sáu lỗi S2 (F1–F6) sửa đúng, mỗi lỗi có ca bắt riêng; S3 F7–F18 xử lý hợp lý; không có S1/S2 mới. Bộ bash trên Linux thật (postgres:17, bash 5.2, `--network none`, mã gắn chỉ đọc): 595/0/1 ở cả `C.UTF-8` và `en_US.utf8` (lượt trước en_US đỏ 3 ca); chênh 21 ca với bản có docker CLI (616) đã xác nhận do ảnh thiếu docker CLI. Git Bash Windows 605/0/2. shellcheck 0.11.0: 22 cảnh báo, không lỗi thật. 37 đột biến mới: 35 bị bắt, 2 không ai bắt (quét `.evidence-staging` đệ quy; nhận diện `screen`). Phiên chính chạy lại: bộ bash Linux 595/0/1 hai locale, Pester M12P99 22/22.

Ghi chú S3 mới: R2-1 nhật ký `nohup` mặc định quyền 644 ghi dấu vết mật khẩu CSDL; R2-2 quét kho của P0 lệch quét khởi động API (tệp `GFEN2` ngắn, tệp uid 10001 không đọc được, tệp `*.uploading` có phong bì hợp lệ, liên kết mềm); R2-3 ba chỗ lệch kiểm ma trận ký; **R2-4 (sửa trước khi chạy thật): P2 sinh khoá mã hoá bằng chứng MỚI khi tệp khoá mất dù kho đã có bằng chứng mã hoá** (phiên chính mở rộng: P2 cũng không nhập khoá này từ `.env` nếu chế độ Development đang giữ nó, mà P3 gỡ khỏi `.env` ⇒ mất khoá cũ, bằng chứng tải ở buổi 27/11 không đọc được vĩnh viễn); R2-5 SIGPIPE khi đóng ssh không tty; R2-6 `LC_ALL=C` cho `daily-backup.py`; R2-7 biến thừa.

**Xử lý:** coder `m12/prod99-fix2` sửa R2-4 mở rộng (nhập từ `.env`, từ chối khi mất khoá mà kho có bằng chứng mã hoá, P3 chỉ gỡ khi tệp khoá đã khớp, P0 báo trước) + R2-1…R2-7 + hai đột biến sống. Sau đó phiên chính chạy lại, gọi verifier chấm lại riêng phần P2/P3.

## V2 lượt 3: P2/P3 khoá bằng chứng, commit `7c7d07234` — ĐẠT CÓ ĐIỀU KIỆN

Kiểm trên chính commit đã push và đã dùng để chạy P0 thật trên `.99`. P0 chỉ đọc (xác nhận bằng chạy thật trong thế giới giả rồi so cây: ngoài `tam-sql/` không tệp/thư mục nào đổi; lệnh docker chỉ đọc + 2 `docker run --rm` gắn `:ro`). `evi_decide`/P2/P3: không có đường thay/ghi đè/gỡ khoá đang dùng hay làm lộ giá trị; thử `.env` nháy kép/đơn/`export`/CRLF/trùng dòng/mẫu giữ chỗ/43 ký tự không đệm/31–33 byte/`=` cuối, `--xoay`, `--xoay-tru-bang-chung`, `--ghi-lai-db`, P2 chết giữa chừng, P3 trước P2, lùi rồi P2 lại: đều an toàn. Hằng số quét khớp mã .NET (GFEN2 ≥ 45, GFENC ≥ 34; đính chính: lượt 2 ghi nhầm 37). Bộ bash Linux 725/0/1 ở hai locale; 20 đột biến mới: 17 bắt, 3 không ai bắt (base64 thiếu đệm; P0 tạo thư mục rỗng; cờ `:ro` của `fp_existing`).

| # | Mức | Phát hiện | Xử lý |
|---|---|---|---|
| R3-1 | S2 có điều kiện | `evi_decide` chỉ biết `.env` và tệp khoá; nếu khoá Development ở nguồn khác (pilot env, `environment:` trong compose tay) mà kho trống lúc P2 thì P2 sinh khoá mới và bằng chứng tải sau P2 bằng khoá cũ mất | **Điều kiện không xảy ra trên `.99`** (phiên chính đọc 25/11 21:2x: API Dev có 0 biến `EvidenceStorage__EncryptionKey` ở container/`.env`/pilot env). Ghi nợ: P0 ghi tên biến trong môi trường container; P6 dừng nếu lượt này P2 sinh khoá mà kho giờ có đối tượng mã hoá |
| R3-2…R3-5 | S3 | tệp khoá 0 byte/sai dạng; thư mục secrets quyền 000; quét uid 10001 mù khi thư mục gốc không vào được; 3 đột biến sống | Ghi nợ |

CHƯA CHẠY: P1–P7 trên `.99`; ENOSPC thật; SIGPIPE; Pester đọc kết quả Git Bash.
