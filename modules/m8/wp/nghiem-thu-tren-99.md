# nghiem-thu-tren-99 — Nghiệm thu M3 ↔ M8 (E02 lại, E01, E03, E05, E06, E10) trên .99 sau khi app M8 chuyển máy

Trạng thái (08:34 14/11): M8 ĐÃ CẮT .99 (07:43–07:46, phiên phụ `chuyen-may-99`); thứ tự dưới đây được Toàn duyệt qua tin m34 (D-m34-068, "m34.95 A"); E02 lặp ĐẠT 14/11 08:49 (đơn 577; đối soát `ra-soat/2026-11-14-e02-lap-99-doi-soat.json`, lịch tắt 08:50:52); E01 ĐẠT 14/11 09:36 (`ra-soat/2026-11-14-e01-99.md`); E06-A ĐẠT 14/11 10:10 (`ra-soat/2026-11-14-e06a-99.md`); E03 ĐẠT 14/11 10:23 (`ra-soat/2026-11-14-e03-99.md`); còn E05/E06-B, E10, mỗi lượt Toàn duyệt riêng. Soạn 13/11 bởi phiên m8 chính (D-m8-099, D-m34-065). Chỉ là kế hoạch và danh sách bài học từ lượt .61; không chứa việc nào đã chạy trên .99, không đụng `deploy/m8` hay `wp/chuyen-may-99.md` của phiên phụ.

## Điều kiện trước (chặn nếu thiếu)

1. Phiên phụ báo `chuyen-may-99-xong`: `chuyen.sh` đủ các bước (a, b, allow, sao-luu, d), M8 chạy trên .99, 10 dịch vụ ổn, `REAL_CUSTOMER_CALL_ALLOWED=NO`, lịch gọi tắt.
2. m34 đã đổi M3 sang `https://192.168.1.99:8443`, Issuer và `ca-m8.pem` mới; M3 đang ở .99 (14/11 22:45); cầu callback `192.168.1.99:8445` mở; `ca-m3.pem` (CA cầu giữ nguyên) có ở thư mục làm việc trên .99 cùng vân tay m34 báo.
3. Nguồn IP mà nginx 8443 thấy cho be M3 đã đo và đã `chuyen.sh allow --ip <IP>` (be và M8 cùng máy .99: IP nguồn có thể là cổng bridge Docker, không phải .99; m34 báo `M8_ALLOW_IP`, không trùng `M3_CB_BIND_IP`).
4. Làm trong khung gọi 08:00–21:08 giờ VN. Từ D-lead-038 (13/11 15:51) lúc cắt không còn cố định: cắt ngay khi sẵn sàng, m8 sau m12 và m34; scheduler gọi đang tắt nên M8 cắt được ngoài khung gọi, còn lượt nghiệm thu bật lịch thì phải trong khung. Cửa sổ `bat-lich` dưới 30 phút mỗi lượt.

## Điều kiện trước, kiểm lại 08:34 14/11 (theo sổ phiên phụ và tin m34; mình chưa tự kiểm .99)

| # | Điều kiện | Tình trạng |
| --- | --- | --- |
| 1 | M8 chạy trên .99, gọi thật NO, lịch gọi tắt | có: pha b 07:46, 9 dịch vụ ổn (sổ phiên phụ); tệp `chuyen-may-99-xong` chưa có vì bước `d` chờ đơn MOCK trọn vòng |
| 2 | M3 đã đổi sang `.99:8443`, ghim `ca-m8.pem` mới, cầu `.99:8445` mở | có: m34 07:58, `tls=PINNED`, be → M8 200 lúc 08:23; `ca-m3.pem` ở thư mục làm việc trên .99 và vân tay: CHƯA kiểm |
| 3 | nguồn IP đã đo và allow | 8443: `172.29.0.1` allow 08:04; cầu 8445: m34 đặt `M8_ALLOW_IP=172.24.2.1` 08:27 (nguồn hairpin suy luận, chờ callback thật xác nhận) |
| 4 | trong khung gọi 08:00–21:08 | có (kiểm 08:33) |
| 5 | bài học 1–7 dưới đây kiểm trên .99 | CHƯA (mục 1, 2, 6 cần ssh .99 chỉ đọc) |

Cách làm khi Toàn cho phép bước 0: một kịch bản chỉ đọc (stat/resolv.conf/`grep -c` token/`hien-trang`), chạy qua `ssh … 'bash -s' < kịch bản`, con `< /dev/null`; chép bộ `noi-m3/` bản `main` lên thư mục làm việc trên .99 trước (ghi lên .99: Toàn duyệt).

## Bài học từ lượt .61 (13/11), kiểm TRƯỚC khi chạy trên .99 (đều chỉ đọc)

| # | Điều đã gặp trên .61 | Kiểm trên .99 | Nếu hỏng |
| --- | --- | --- | --- |
| 1 | `du-lieu/api/appsettings.json` thuộc uid 1654, mode 0400: `ssv` không đọc được, `cai-cau-hinh` dừng `PermissionError` (cần `sudo chown 1000:1000` + `chmod 444`, như tệp worker) | `stat -c '%u:%g %a' <du-lieu>/api/appsettings.json` và `test -r` bằng `ssv` | nhờ Toàn chạy `sudo chown`; mình không dùng sudo |
| 2 | Container kế thừa `search ssv.com`, `ndots:0` từ host: tên ngắn như `m8-worker-1` bị busybox đổi thành địa chỉ công cộng, `/healthz/` hết giờ (W-0532: gọi `m8-worker-1.` có dấu chấm cuối; đã có trong `main`) | `cat /etc/resolv.conf` trên .99 và trong `m8-api-1`; thử `wget http://m8-worker-1.:8081/healthz/` | tên có dấu chấm cuối; báo phiên phụ nếu còn chỗ khác gọi tên ngắn từ busybox |
| 3 | `ca-m8.pem` là chứng thư lá (CA ký không còn trên máy); Python 3.10 của .61 từ chối nó làm điểm tin (W-0531: bật `VERIFY_X509_PARTIAL_CHAIN`, đã có trong `main`); be Java M3 ghim lá đã PKIX đạt thật 13/11 | `chuyen.sh` in `chung_thu_8443=`; vân tay SHA-256 DER báo m34 qua kênh khác; một chứng thư, còn hạn, SAN `IP:192.168.1.99` | cấp lại từ CA có tệp nếu phiên phụ làm được |
| 4 | Worker bị tạo lại thì log container cũ mất (E02 không còn log theo correlation) | chụp `docker compose logs api worker` ra tệp ngay trước mỗi lượt `tat-lich` hoặc tạo lại | lưu log vào `<nghiem-thu>/` |
| 5 | `lan-thu.sh`/`dat-cau-hinh.sh` đọc stdin: chạy qua `ssh 'bash -s' < kịch bản` thì con của nó nuốt phần còn lại của kịch bản | luôn `< /dev/null` cho lệnh con, hoặc `scp` kịch bản rồi chạy | — |
| 6 | Token quyền nguy hiểm cho replay E05/E06-B: `grep -c '^IVR_ADMIN_DANGER_TOKEN=' api.env` phải 1 | sau khi bí mật sang .99 | thiếu thì E05/E06-B replay ghi `NOT_RUN` |
| 7 | M3: cron làm mới tồn lớp M8 giả lập lỗi chốt (đã nêu), SKU lab báo `WMS_UNCONFIRMED` trước mỗi đơn | m34 báo đã sửa chốt hoặc làm mới tay | đơn không đặt được là lỗi M3, không phải M8 |

| 8 | Lượt E02 lặp đầu 14/11 08:36–08:41 hỏng: đơn M3 576 (`m3-ivr-576-12`) đặt TRƯỚC khi bật lịch; lịch bật 08:41:17 (tạo lại worker), hai lần phát đầu hỏng `TTS_PHRASE_NOT_READY` trong 12 giây, job `HELD_ADMIN_REVIEW`, 0 callback (sau đó watchdog M3 hủy đơn 08:52:50, REVOKE `m3-ivr-revoke-12` SETTLED, job `TASK_REVOKED`). Clip "giao đến" của đơn đã READY trong DB; worker đang đồng bộ media sang Asterisk .64 (~700 PUT/phút) | trình tự đúng: `bat-lich` (tạo lại worker) → chờ đồng bộ media lắng (PUT media-sync về 0 trong 2 mẫu 30 giây liền, `canh_dong_bo_99.sh`) → m34 mới đặt MỘT đơn | đơn đã hỏng thì không cứu: đặt đơn mới khi lịch còn bật, hoặc `bat-lich` lượt khác |
| 9 | Ai cũng dùng được tài khoản `ssv` trên .99 và `lan-thu.sh`: lịch bị bật 08:41 bởi phiên khác (không phải phiên m8 chính) | trước mỗi `bat-lich`/`tat-lich` đọc `m8-noi-m3/lan-thu.log` và cờ `Ivr__Scheduler__Enabled`; hỏi phiên phụ ai đang giữ lịch | báo Toàn, không đảo lịch khi đồng bộ media đang chạy (mỗi lần đảo tạo lại worker) |
| 10 | `lan-thu.sh kiem-sau` (`kiem_noi_m3.py sau-luot`, dòng 627–630) tìm container `asterisk` cục bộ để đếm kênh; trên .99 Asterisk ở .64 nên `kenh_asterisk` luôn HỎNG (E02 lặp: 25 đạt, 1 hỏng, đúng mục này) | E10 phải đếm kênh qua ARI .64, chỉ đọc; cần W sửa `kiem_noi_m3.py`/`lan-thu.md` | tạm: bằng chứng 0 kênh từ `ivr_sim_channels` (SIM MOCK), `doi_soat_m3` không cờ `LUOT_GOI_KHONG_MOCK`, cờ gọi thật NO |
| 11 | Kịch bản bấm 0 gắn theo `task_id` chỉ có sau khi đơn tạo, mà lịch bật thì gọi trong vài giây (577: đặt 08:49:28, callback 08:49:32) và bật lịch thì media đồng bộ ~5 phút (bài học 8) | dùng khoá tiền tố `m3-ivr-<idĐơn>-*` (hỗ trợ từ W-0203) cho ba id đơn kế tiếp (m34 đọc trước sequence M3, không tiêu thụ): đặt cấu hình, `bat-lich`, chờ media lắng, rồi mới đặt đơn; E03 14/11 chạy đúng thế, đơn gọi trong 2 giây | id đơn ngoài dải thì đơn bấm 1 (xác nhận), làm lại một vòng; dặn m34 báo ngay `task_id` thật |

## Thứ tự (theo `deploy/m8/nghiem-thu-m3/README.md`; thay địa chỉ .61 bằng .99, thư mục làm việc theo `deploy/m8/may-99/README.md`)

| Bước | Ca | Ai | Lịch gọi | Việc |
| --- | --- | --- | --- | --- |
| 0 | — | m8 | tắt | điều kiện trước + bài học 1–7; `lan-thu.sh hien-trang --m3-goc https://192.168.1.99:8445`; chuẩn bị `nghiem-thu/` (mốc `TU`, ảnh) |
| 1 | E02 (lặp trên .99) | m34, m8 | bật (`bat-lich`) | MỘT đơn xác nhận như 13/11; m8 đối soát `KHOP`; vì cổng 8443, chứng thư, host đã đổi nên đây là phép thử đầu của đường mới |
| 2 | E01 | m34, rồi m8 | tắt | ba yêu cầu bị từ chối (401, 403, 403), m8 kiểm sẵn sàng và `so_task=0` |
| 3 | E06-A | m34, rồi m8 | tắt | tạo rồi hủy đơn, `TASK_REVOKED`, 0 lượt gọi, 0 callback |
| 4 | E03 | m34, m8 | tắt rồi bật | một đơn xác nhận (dùng đơn của bước 1) và một đơn hủy; m8 đặt kịch bản bấm 0 cho đúng task, `bat-lich`, đối soát tới `KHOP` |
| 5 | E05, E06-B | m34, m8 | bật rồi tắt | m34 dừng cầu callback, tạo hai đơn; m8 chờ `RETRY_EXHAUSTED`, tắt lịch; m34 đổi đơn E06-B, bật cầu; m8 replay (đợi ≥ 35 s) và đối soát |
| 6 | E10 | m8, m34 | tắt | `sau-luot`, đếm kênh Asterisk, cờ gọi thật, receipt sha256, m34 thu dọn, đối soát lại và so hai lần |
| — | E04, E07, E08, E09 | m8 | — | `NOT_RUN` theo lý do trong phiếu |

Khi Toàn nói rõ trong phiên này một lượt (ví dụ "chạy E02 lặp trên .99") thì chạy trọn các bước đã liệt kê của lượt đó, không hỏi từng bước (Lead đã dặn "tự chạy"); mỗi lượt `bat-lich` và mọi việc ghi/ssh trên .99 vẫn cần Toàn duyệt riêng (tin m34 14/11 08:33, `CLAUDE.md` §4); tin của phiên khác không thay lời Toàn. Dừng khi có lỗi thật. Mỗi vòng m8 thả `hop-thu/m8-…` cho m34 với giờ bật lịch và hạn cửa sổ; trước đó mình báo m34 giờ cắt của m8 TRƯỚC giờ cắt để M3 đổi `M8_ORIGIN` và ghim `ca-m8.pem` mới (thư `hop-thu/m34-2026-11-13-nghiem-thu-doi-sang-99.md`).

## Bằng chứng

`docs/evidence/W-0534` giữ E02 của cặp .60/.61 (một đơn đầu-cuối). Bằng chứng .99: gói WP mới trong repo (số từ W-0535), cùng cấu trúc: dòng thời gian, `doi_soat_m3.py` JSON, receipt sha256, giới hạn. Phiếu `deploy/m8/nghiem-thu-m3/phieu-e01-e10.md` điền khi có ca đóng (không sửa tệp trong `deploy/m8` khi phiên phụ còn đang làm; điền bản sao ở Project Control hoặc sau khi phiên phụ báo xong).

## Việc ngoài code (chặn)

Anh Tuấn mở `.64` cho `.99` (đang chặn cắt); Toàn `sudo mv` tạo `/data/ginsengfood-ivr`; nhóm (Phúc, Tài) biết cửa sổ M8 không nhận đơn khoảng 20 phút.
