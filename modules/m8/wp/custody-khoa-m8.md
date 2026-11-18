# Cất khoá M8 (custody) — đóng phần custody của D-m8-010

Căn cứ: D-m8-122 (D-lead-058, Toàn 17/11 09:2x "bạn tự lưu đi"): không nhờ Anh Tuấn; bản gốc nằm trên máy dùng nó, quyền chỉ chủ đọc;
một bản dự phòng do Toàn giữ ngoài git. Kiểm kê 17/11 09:31 (chỉ đọc, `ra-soat/kich-ban-99-1611/kiem_khoa_99_1711.sh`, log
`k-1711-khoa-99.log` — loại khỏi git). **Không ghi giá trị nào vào tệp này** (repo Project Control công khai).
Trạng thái: **XONG phần .99 (17/11)** — m8.96 A (D-m8-124): gói `khoa-m8-20261117.tar.gpg` (GPG AES256, sha256 `f209e8ea…0031`), Toàn tự gõ mật khẩu, đã chép về máy Lead (thư mục `khoa-m8` trong hồ sơ người dùng, ngoài git), bản trên .99 đã xoá; Toàn chuyển gói + mật khẩu sang chỗ cất riêng (USB/trình quản lý mật khẩu) và thử giải mã một lần. m8.97 (D-m8-125): khoá CD .61 đã thu hồi (dòng trên .61, biến GitLab `M8_DEPLOY_*`, environment `m8-61`, tệp trên máy Lead). Còn: phía .64 trong 02I.

## 1. Danh sách khoá và bí mật của M8

Chủ `ssv` trên .99 trừ khi ghi khác. Thư mục `/data/ginsengfood-ivr` 750, `du-lieu/`, `m8-noi-m3/`, `sao-luu/` đều 700 (chỉ `ssv` vào được).

| # | Thứ | Dùng làm gì | Bản gốc (máy:đường dẫn) | Quyền hiện tại | Bản khác đang có |
|---|---|---|---|---|---|
| 1 | Media-token | worker M8 (.99) đẩy clip sang Asterisk (.64) | .99 `du-lieu/worker/media-token` | 444 trong thư mục 700 | .99 `du-lieu/l34-input/media-token` (600); .64 phía nhận: CHƯA KIỂM (cần sudo .64, làm trong 02I) |
| 2 | ARI mTLS (khoá + chứng thư client, CA hai phía) | cầu ARI .99 ↔ Asterisk .64 | .99 `du-lieu/ari/tls/{key.pem,cert.pem,own-ca.pem,peer-ca.pem}` | 444 trong thư mục 755 (nằm dưới `du-lieu` 700) | .99 `du-lieu/l34-input/ari-secret.json` (600); .64 phía server: CHƯA KIỂM |
| 3 | TLS 8443 (khoá server) | cổng vào https của M8 cho M3 | .99 `du-lieu/tls/server.key` | `root` 400 | .99 `tls-99/server.key` (400, bản sinh 13/11) |
| 4 | Khoá CD `deploy_m8_99` | GitLab runner ssh vào .99 chạy `trien-khai.sh` | máy Lead `~/.ssh/gfivr_ci_m8_99_ed25519` (vân tay `SHA256:v1bstQCh…`) | Windows (quyền NTFS, chưa kiểm ACL) | biến GitLab `M8_99_DEPLOY_SSH_KEY` (File); .99 `~/.ssh/authorized_keys` dòng `restrict,command=` |
| 5 | Khoá CD `deploy_m8_61` (cũ) | job đã gỡ (D-m8-121, W-0545) | máy Lead `~/.ssh/gfivr_ci_m8_61_ed25519` (`SHA256:u2E7e+T8…`) | Windows | biến GitLab `M8_DEPLOY_SSH_KEY`/`M8_DEPLOY_KNOWN_HOSTS`, environment `m8-61`; .61 `authorized_keys` → **thu hồi** (m8.97) |
| 6 | `.env` của compose `m8` | mật khẩu Postgres M8 và biến bí mật khác | .99 `.env` | 600 | .99 `.env.cu-20261114T004447Z` (600, trước giờ cắt) |
| 7 | Bí mật dịch vụ Order Core | M3 → M8 (token dịch vụ) | .99 `m8-noi-m3/bi-mat-order-core` | 600 | — |
| 8 | Khoá đọc đĩa VM (ops-agent) | ops-agent đọc dung lượng đĩa | .99 `du-lieu/ivr-operations/private/vm-disk-ed25519` | 600 | — |
| 9 | Cấu hình gắn vào api/worker | có thể chứa khoá dịch vụ (chưa đọc nội dung) | .99 `du-lieu/{api,worker}/appsettings.json` | 444 trong thư mục 700 | 6 bản `sao-luu/cau-hinh-*` (700) |
| 10 | Bản sao trước giờ cắt | giữ để quay lui | .99 `du-lieu.cu-20261114T004447Z/`, `m8-noi-m3.cu-20261114T004447Z/` | `server.key` root 400, còn lại 600/444 | — |
| 11 | Sao lưu CSDL hằng đêm | khôi phục M8 | .99 `/data/sao-luu/ginsengfood-ivr` | 700 | Anh Tuấn tự sao lưu `/data` (D-m8-122, thay kho ngoài máy) |
| — | Không bí mật (công khai) | ghim chứng thư | `m8-noi-m3/ca-m3.pem`, `ca-m8.pem`, `du-lieu/worker/tin-cay/ca-cau-m3.pem`, `*.crt`, `*.pub` | — | — |

Đăng nhập .99 (`~/.ssh/authorized_keys`, 600): 3 khoá, 2 dòng có `command=` (một là khoá CD #4); vân tay ghi ở log, không ghi khoá.

## 2. Cách giữ (đề xuất, chờ Toàn duyệt m8.96)

- **Bản gốc:** để nguyên trên máy dùng nó như bảng trên. Ngoại lệ đã biết: #1, #2, #9 là 444 vì container chạy uid khác (1654) phải đọc qua bind
  mount; chúng nằm dưới thư mục 700 nên trên máy chỉ `ssv` (và root) tới được. Không đổi quyền vì sẽ làm worker/ari không đọc được.
- **Bản dự phòng (A, đề xuất):** một gói mã hoá đối xứng, Toàn tự gõ mật khẩu:
  `ssh -t ssv@192.168.1.99 'cd /data/ginsengfood-ivr && tar -cf - .env du-lieu/worker/media-token du-lieu/ari/tls du-lieu/l34-input m8-noi-m3/bi-mat-order-core du-lieu/ivr-operations/private | gpg -c --cipher-algo AES256 -o ~/khoa-m8-$(date +%Y%m%d).tar.gpg'`
  rồi chép về máy Toàn (`scp`), xoá bản trên .99, Toàn cất gói + mật khẩu ở chỗ riêng (USB hoặc trình quản lý mật khẩu), không vào git, không
  gửi qua chat. Thêm `server.key` (#3, root) cần `sudo`: Toàn gõ sudo, hoặc bỏ qua vì sinh lại được. Khoá CD #4 đã có bản ở GitLab + máy Lead.
  Phiên m8 chỉ ghi vào sổ: ngày, sha256 của gói, nơi Toàn cất (mô tả chung), không ghi mật khẩu.
- **Phương án B:** Toàn tự chép từng giá trị vào trình quản lý mật khẩu (thủ công, dễ sót tệp nhiều dòng như khoá/chứng thư).
- Phía .64 (#1, #2 phía server): kiểm kê và gói tương tự trong khung bảo trì 02I (cần sudo .64).

## 3. Thu hồi khoá CD .61 (đề xuất, chờ Toàn duyệt m8.97)

Sau khi W-0545 lên `main`: (1) Toàn xoá biến GitLab `M8_DEPLOY_SSH_KEY`, `M8_DEPLOY_KNOWN_HOSTS` và environment `m8-61` (hoặc cho phiên m8 làm
trên GitLab ở khung trình duyệt); (2) xoá dòng khoá `gfivr_ci_m8_61` trong `authorized_keys` của .61 (ssh .61, không cần sudo); (3) xoá tệp
`~/.ssh/gfivr_ci_m8_61_*` trên máy Lead.

## 4. Còn mở (không chặn)

- Quyền NTFS của khoá trên máy Lead chưa kiểm (Git Bash hiện `rw-r--r--` là giả lập).
- Bản sao trước giờ cắt (#10) và `.env.cu-*`: giữ tới khi bỏ đường lui .61 hẳn; khi đó xoá cùng lượt.
