# Gói lệnh nối M3 .60 ↔ M8 THẬT .61 (MOCK) — soạn 13/11, CHƯA CHẠY lệnh nào trong gói

Ghép `deploy/m34/m8-that/M8_THAT.md` (phía M3) với `ginsengfood-ivr/deploy/m8/noi-m3/lan-thu.md` (phía m8) thành MỘT thứ tự. Nhãn máy: **[DEV]** Git Bash máy Toàn · **[.60]** `ssh ssv@192.168.1.60` · **[.61]** m8 chạy ở `~/m8` ·
**[ROOT]** quyền sudo trên .60 (`ssv` thuộc nhóm `sudo`, mình CHƯA thử sudo; cần mật khẩu của `ssv`, hoặc người có root nếu `ssv` không có mật khẩu). Mọi tệp chép lên .60 lấy từ commit `f9e179a450915ff2fafa69ca55484a6f47f55101` (LF), không chép từ thư mục làm việc Windows (CRLF làm `bash` lỗi).
Không bí mật nào đi qua chat; `ca-m8.pem`, `order-core-secret` chỉ đi bằng `scp -3` hoặc tay (USB/WinSCP), `chmod 600`.

## Đã đo trên .60 lúc 13/11 09:12 (chỉ đọc)
- **Đồng hồ: ĐÃ SỬA 13/11 09:34 (Toàn chạy A0); đo lại 09:36: `NTPSynchronized=yes`, lệch −2 s so với GitHub, 0 s so với M8 .61.** Trước đó (09:12): `NTP=no`, `NTPSynchronized=no`. So tiêu đề `Date`: .60 chậm **100 s** so với GitHub, **109 s** so với M8 .61. `kiem-truoc-bat.sh --mang` và JWT hai chiều chỉ chịu lệch ≤ 30 s.
- Cổng 8445 **trống** (`ss -ltn`, không container nào publish). Đường ra .61: `src 192.168.1.60` (đúng IP M8 cho phép). `nginx:1.27-alpine` có sẵn. `~/m34/m8-that` và `compose.m8-that.yml` **chưa có** trên .60.
- Lớp đang chạy: `compose.yml:compose.override.yml:compose.m8-gia-lap.yml`; `OTP_SMS_EXPOSE_MOCK_CODE=true`. Ảnh `f9e179a4` đã chạy (be khoẻ), M8 giả lập rảnh.

## Giai đoạn A: chuẩn bị (không đổi gì đang chạy)
**A0 [ROOT] sửa đồng hồ .60.** Bước nhảy là TIẾN ~100 s (an toàn cho pg/cron; không bao giờ chỉnh lùi).
```bash
sudo timedatectl set-ntp true
timedatectl show -p NTP -p NTPSynchronized     # sau ít phút: NTPSynchronized=yes
```
Ubuntu 22.04, `systemd-timesyncd` đã cài sẵn nhưng đang `inactive`/`disabled`, nên lệnh đầu chỉ bật nó, không cần cài gì. Sau vài phút vẫn `NTPSynchronized=no` thì xem `timedatectl timesync-status` (có thể mạng chặn UDP 123 ra ngoài; khi đó đặt `NTP=<máy giờ trong LAN>` trong `/etc/systemd/timesyncd.conf`). Kiểm lại từ [DEV]: `cd /c/Projects/_wt/m34/len60-notes/lenh && bash chay-tren-60.sh d13-80-gio-cong.sh` → hai dòng `lech=` phải trong ±10 s. Nếu .61 cũng sai, đo với nguồn thứ ba rồi báo m8.

**A1 [DEV] chép bộ M8-that lên .60** (tệp từ commit):
```bash
cd /c/Projects/ginsengfood-business-platform && K=$(mktemp -d) && git -c core.autocrlf=false archive f9e179a450915ff2fafa69ca55484a6f47f55101 deploy/m34/compose.m8-that.yml deploy/m34/m8-that | tar -x -C "$K"
scp "$K/deploy/m34/compose.m8-that.yml" ssv@192.168.1.60:m34/ && scp -r "$K/deploy/m34/m8-that" ssv@192.168.1.60:m34/
ssh ssv@192.168.1.60 'cd ~/m34 && mkdir -p -m 700 m8-that/bi-mat && ls m8-that && sha256sum compose.m8-that.yml'
```
Tường lửa: Docker publish cổng bằng iptables nên thường không bị ufw chặn; nếu bật tường lửa riêng, [ROOT] mở `8445/tcp` chỉ cho `192.168.1.61`.

## Giai đoạn B: nhận tệp từ m8 — ĐÃ XONG 13/11 (mình chuyển giúp bằng `d13-25-chuyen-tep-m8.sh`; đối chiếu đạt, các lệnh dưới đây giữ để tham khảo/làm lại)
**B1 [.61] — m8 ĐÃ LÀM 13/11** (thư `hop-thu/m8-2026-11-13-ca-m8-la-chung-thu-la.md`): có `~/m8-noi-m3/ca-m8.pem` và bí mật `~/m8-noi-m3/bi-mat-order-core` (m8 chạy `bash noi-m3/lan-thu.sh bi-mat`). Bản chép công khai của `ca-m8.pem` có trên máy Toàn: `C:\Projects\_wt\m8\m3-trao-doi\ca-m8.pem`; vân tay SHA-256 DER mình tính lại từ bản đó = số m8 báo `0cf2fe51…1871` (1 chứng thư, CA:FALSE, SAN IP:192.168.1.61, không khoá riêng, hết hạn 08/04/2027); `ca-m8.pem` ở `~/m8-noi-m3/` (bản chép `server.crt`, chứng thư lá: `tao-chung-thu-cau.sh` chấp nhận, chỉ đòi đúng MỘT chứng thư X.509, còn hạn, không có khoá riêng).
**B2 [DEV] chuyển sang .60** (`scp -3` đi qua máy dev, không ghi đĩa; thay `<ĐƯỜNG_DẪN_BÍ_MẬT_M8>` bằng đường dẫn m8 in ở dòng cuối của `bi-mat`; máy dev không vào được .61 thì m8/Toàn chép tay):
```bash
scp /c/Projects/_wt/m8/m3-trao-doi/ca-m8.pem ssv@192.168.1.60:m34/m8-that/bi-mat/ca-m8.pem        # công khai; hoặc scp -3 từ ssv@192.168.1.61:m8-noi-m3/ca-m8.pem
scp -3 ssv@192.168.1.61:m8-noi-m3/bi-mat-order-core ssv@192.168.1.60:m34/m8-that/bi-mat/order-core-secret
ssh ssv@192.168.1.60 'chmod 600 ~/m34/m8-that/bi-mat/ca-m8.pem ~/m34/m8-that/bi-mat/order-core-secret && ls -l ~/m34/m8-that/bi-mat'
```

## Giai đoạn C: dựng cầu callback (vẫn chưa đổi be) — C1, C2, C3 ĐÃ XONG 13/11 (mình chạy, Toàn duyệt; C3 `KET QUA: DAT (0 loi)`; C2 `ca-m3.pem` đã ở `~/m8-noi-m3/` trên .61). Giai đoạn D cũng ĐÃ XONG 12:39 (be trỏ M8 thật, `KIỂM SAU CHUYỂN: ĐẠT`); còn giai đoạn E (m8), F, G
**C1 [.60]** `cd ~/m34 && bash m8-that/tao-chung-thu-cau.sh` → in vân tay CA M8 (so với số m8 báo) và vân tay CA cầu. Hỏng thì dừng, không sửa tay.
**C2 [DEV]** gửi m8: `ca-m3.pem` (công khai) + `192.168.1.60:8445` + vân tay CA cầu (kênh khác):
```bash
scp -3 ssv@192.168.1.60:m34/m8-that/bi-mat/ca-m3.pem ssv@192.168.1.61:m8-noi-m3/ca-m3.pem
```
**C3 [.60]** `bash m8-that/kiem-truoc-bat.sh --mang` → phải `KET QUA: DAT` (hai `.well-known` của M8 trả 200, lệch giờ ≤ 30 s). CANH BAO đọc kỹ, không bỏ qua; `src` của `ip route` khác `192.168.1.60` là cảnh báo cần dừng.

## Giai đoạn D: chuyển be sang M8 thật (be tạo lại, gián đoạn ngắn; 13/11 be đổi bản mất 46 s toàn lượt)
**D0 [.60] M8 giả lập phải rảnh** (đơn đang chờ lab không nhận kết quả sau khi chuyển): kỳ vọng `0|0|0`.
```bash
cd ~/m34 && docker compose exec -T m8-pg psql -U ivr -d ivr -X -At -c "select (select count(*) from ivr_call_attempts where started_at is not null and ended_at is null)||'|'||(select count(*) from ivr_call_jobs where closed_at is null)||'|'||(select count(*) from ivr_result_callbacks where delivery_status in ('READY','SENDING','RETRY_PENDING'))"
```
**D1 [.60]** đọc kế hoạch rồi đổi thật rồi kiểm:
```bash
bash m8-that/chuyen-m8.sh that               # chạy khô
bash m8-that/chuyen-m8.sh that --ap-dung     # đổi một dòng COMPOSE_FILE, up --wait; hỏng thì tự trả .env
bash m8-that/chuyen-m8.sh trang-thai         # phải: KIỂM SAU CHUYỂN: ĐẠT (lớp that)
```
**Lùi bất cứ lúc nào:** `bash m8-that/chuyen-m8.sh gia-lap --ap-dung` (lab dùng lại bí mật cũ). Dòng đạt của be: `[IVR-AUTH-CONFIG] tls=PINNED token-client=ON callback-verifier=ON`.
Nếu M8 báo 403 ở mọi đường: nginx cầu thấy IP cầu nối `172.x.0.1`, không phải .61. Chẩn đoán `docker compose logs --tail 20 m8that-cb`; KHÔNG nới `allow` sang 172.x, báo Lead.

## Giai đoạn E: m8 cài cấu hình phía M8 [.61] (theo `lan-thu.md`)
```bash
cd ~/m8 && M3=https://192.168.1.60:8445
bash noi-m3/lan-thu.sh hien-trang --m3-goc "$M3"                    # chỉ đọc
bash noi-m3/lan-thu.sh cai-cau-hinh --m3-goc "$M3"                  # chạy thử, chưa đổi gì
bash noi-m3/lan-thu.sh cai-cau-hinh --m3-goc "$M3" --chay           # đặt thật (tự trả bản cũ khi hỏng)
bash noi-m3/lan-thu.sh bat-lich --m3-goc "$M3"                      # bật lịch gọi chỉ cho lượt thử
```
Việc tồn khác 0, thiếu chính sách, kiểm hỏng: m8 DỪNG và hỏi Lead.

## Giai đoạn F: đơn thử E01–E10 [DEV] — DỜI SANG .99 (D-m34-065, 13/11): E02 đã xong trên .60 (đơn 363); E01, E03, E05, E06, E10 làm trên .99 sau khi m8 chuyển máy. Các lệnh dưới đây ghi cho .60: khi làm trên .99 đổi máy, `M8_ORIGIN`, CA ghim và chứng thư cầu theo phiếu chuyển máy.
Điều kiện từng ca và bằng chứng: `deploy/m34/m8-that/BANG_CHUNG_M3.md` (bảng "Từng ca"). Khung lệnh:
```bash
cd /c/Projects/_wt/m34/len60-notes/lenh && T=$(mktemp -d) && git -C /c/Projects/ginsengfood-business-platform show f9e179a450915ff2fafa69ca55484a6f47f55101:deploy/m34/m8-that/kiem-m3-chi-doc.sh > "$T/kiem-m3-chi-doc.sh"
bash chay-tren-60.sh "$T/kiem-m3-chi-doc.sh" --tinh-trang                                   # E01: CA, vân tay, dòng be, M8 giả lập đã dừng
bash chay-tren-60.sh "$T/kiem-m3-chi-doc.sh" --e01 --corr-a=uat-e01-khong-token-1 --corr-b=uat-e01-token-rac-1 --corr-c=uat-e01-sai-nguon-1
bash chay-tren-60.sh "$T/kiem-m3-chi-doc.sh" --don=<id>[,<id>]                              # bằng chứng "áp đúng một lần" sau callback
```
Đặt đơn (mỗi ca MỘT đơn, mỗi đơn MỘT số khác nhau; M8 MOCK không đọc số, M3 chỉ cần số mới để khỏi bị miễn gọi `SYSTEM_POLICY_EXEMPT`). Số giả ngẫu nhiên đủ cho MOCK, không cần số nội bộ thật:
```bash
SO=$(mktemp); python -c "import random,sys; s=set()
while len(s)<6: s.add('09'+''.join(random.choice('0123456789') for _ in range(8)))
open(sys.argv[1],'w').write('\n'.join(sorted(s))+'\n')" "$SO"
cd /c/Projects/ginsengfood-business-platform/deploy/m34/m8-that && python dat-don-uat.py check --base http://192.168.1.60
python dat-don-uat.py create --base http://192.168.1.60 --ca e02 --phones-file "$SO" --bo-qua-dong 0 --receipt-dir <thư_mục_receipt>   # e03 → 1, e06a → 2, e05 → 3, e06b → 4
```
Chỉ đặt trong giờ gọi 08:00–21:08, và đặt xong đọc kết quả rồi mới sang ca sau (lỗi thì script dừng, không tự thử lại). E05: `docker compose stop m8that-cb` trước khi đặt, `start` sau; E06-A: đơn luồng IVR KHÔNG hủy tay được ở admin (`cancelByStaff` ném `CONFIRMATION_ROUTE_NOT_ALLOWED`, kiểm 14/11 trên .99); REVOKE tới từ watchdog khi quá `result_deadline` (đơn đã có SUBMIT `SETTLED`, lịch M8 tắt) hoặc từ sửa đơn trước khi gọi (sinh thế hệ mới, không hợp E06-A); E06-B cần cầu dừng và lịch bật.

## Giai đoạn G: kết thúc
[.61] `bash noi-m3/lan-thu.sh tat-lich` rồi `bash noi-m3/lan-thu.sh kiem-sau --m3-goc "$M3"` (lịch tắt, 0 kênh Asterisk, ba lần `REAL_CUSTOMER_CALL_ALLOWED=NO`). [.60] `bash m8-that/chuyen-m8.sh trang-thai`. Giữ lớp thật cho UAT 14/11, hoặc `gia-lap --ap-dung` nếu cần demo trên lab.

## Cần Toàn quyết / làm
1. **A0 đồng hồ** (chặn cứng; cần sudo: Toàn tự làm được nếu có mật khẩu `ssv`, không thì Anh Tuấn). 2. Số điện thoại: số giả ngẫu nhiên (khuyên dùng; m8 cũng xác nhận MOCK không đọc số) hay số nội bộ thật. 3. Giữ `OTP_SMS_EXPOSE_MOCK_CODE=true` trên lớp thật trong UAT (đang true; khuyên giữ, gỡ lớp phủ thì về false).
4. Ai chạy từng giai đoạn: mình chạy được A1, C1, C3, D, F với duyệt từng việc; A0 và B2/C2 (chuyển bí mật giữa máy) do Toàn.

## CHƯA CHẠY / chưa chứng minh
Mọi lệnh trong gói; `docker compose up` lớp `compose.m8-that.yml`; nginx cầu trên .60 thấy IP nguồn thật của .61 hay 172.x; tường lửa .60; be ghim chứng thư lá của M8 với TLS thật (đã thử MÔ PHỎNG cục bộ 13/11: cách dựng điểm tin giống `PinnedCaIvrTlsContextProvider`, chứng thư lá CA:FALSE không còn CA, bắt tay TLS đạt trên JDK 25.0.3 và trên JRE Temurin 21.0.13 như ảnh be; chưa thử với chứng thư `server.crt` thật của .61, thử đầu tiên là lần be gọi M8 đầu tiên, đơn E02); lệch giờ .61 so với giờ thật (chỉ đo qua tiêu đề `Date`).
