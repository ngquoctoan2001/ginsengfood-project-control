# Kế hoạch M7: ra video từ ảnh sản phẩm, chạy thật 30/11

Cập nhật: **21/11/2026 10:1x** · người cập nhật: phiên m7 máy Lead (sau mỗi lần kiểm .63 hay mỗi commit task) · nơi làm mã: phiên M7 trên .63.
Luật đang áp: **một bản duy nhất** (không "bản 1/bản 2", không "tên nháp") và **làm luôn một lần** (không "để sau") — D-m7-139.

---

## A. Cần bạn quyết

| Mã | Quyết gì | Đề xuất | Hệ quả |
|---|---|---|---|
| [x] m7.257 | Task R3: tester + verifier ĐẠT thì tự gộp, bạn xem sau | Đã duyệt 15:0x (D-m7-146) | Có hiệu lực từ lần nối lượt kế tiếp |
| [x] m7.256 | Bộ kiểm đủ chạy thưa: mỗi đêm 01:30 + mốc lớn, xanh thì tự push | Đã chốt 14:1x (D-m7-145) | Đêm nay 01:30 chạy lần đầu trên main .63 |
| [x] m7.255 | Muse thật cho video thứ hai tối đa 8 lượt, trần 25 → 33 | Đã duyệt 13:0x (D-m7-143) | — |

Đã chốt gần nhất: m7.254 chạy 4 luồng, trần lệnh nặng 3 (D-m7-142, 12:4x); m7.211–250 (D-m7-141, chi tiết mục E).

**Tình hình lúc 21/11 10:1x:** **phiên .63 ĐỨNG từ 20/11 17:46** vì tài khoản Claude hết **hạn mức TUẦN** (mở lại 24/11 03:00); lúc 10:08 tài khoản trên .63 vẫn báo hết hạn mức tuần. **Cần bạn đăng nhập .63 bằng tài khoản Claude còn hạn mức tuần**; lượt tự chạy lại trong 3 phút. Trước khi dừng đã gộp vào main .63: nhiều tài khoản Claude cho worker, API mẫu Studio, cấm hồ sơ Vivaldi/Opera, lệnh tạo ảnh Codex (1 lượt Codex thật ĐẠT). Bộ kiểm đủ đêm 21/11 trên `17f165e`: 2 bước đỏ (bản OpenAPI của web lệch; một test tìm sai thư mục build), KHÔNG push; đã giao sửa. GitHub hiện ở `b3d635d`. Luật mới D-lead-063 đã áp cho M7 trên .63 (không bản sao, khoá tệp, bộ kiểm đủ chạy trong checkout chính).

Sudo trên .63: bạn đã cho (D-m7-144). AI không nhập mật khẩu: phiên .63 soạn sẵn script, khi cần bạn chạy đúng một lệnh `sudo bash ~/m7-drive/can-sudo-<việc>.sh` (mình báo khi có).

Đã chốt theo đề xuất, **muốn khác thì nói** (D-m7-140):

| Chuyện | Đã chốt |
|---|---|
| Tạm dừng, sửa tay, chạy tiếp | Nút **Tạm dừng** trên lượt làm video: dừng sau bước đang chạy. Sửa hay làm lại mọi thứ AI đã làm (kịch bản, storyboard, khung hình, clip từng shot, chữ đọc, phụ đề). Bấm **Tiếp tục** thì chỉ chạy lại phần bị ảnh hưởng. Thêm cài đặt **điểm dừng duyệt** (sau kịch bản, sau khung hình, sau clip) bật tắt trên UI |
| Cấu hình trên UI | Mọi cài đặt vận hành sửa ở trang **Cấu hình**; khoá nhạy cảm cần người duyệt; bí mật không hiện, chỉ hiện trạng thái (đã đăng nhập, hết hạn mức…) |
| Thứ tự | Video đầu (T232) **không chờ** tính năng tạm dừng; tạm dừng và cấu hình UI làm song song; xong thì làm video thứ hai có dùng tạm dừng, sửa tay |

---

## B. Bạn làm tay (lệnh)

Mở một tab mới: `ssh ssv@192.168.1.63`, rồi chạy trong đó. Không ảnh hưởng lượt đang chạy.

**1. [x] Claude cho worker (mỗi tài khoản một bí danh, xoay vòng khi hết hạn mức).** Đã đăng nhập `m7-claude-01`, `m7-claude-02` (12:58). Còn tài khoản thì thêm `03`, `04` theo cùng lệnh:

```bash
cd ~/dev/ginsengfood-golden-hour-video
pwsh -NoProfile -File tools/dev/dev-ai.ps1 -Login -Alias m7-claude-01
pwsh -NoProfile -File tools/dev/dev-ai.ps1 -InitProfile -Alias m7-claude-02
pwsh -NoProfile -File tools/dev/dev-ai.ps1 -Login -Alias m7-claude-02
pwsh -NoProfile -File tools/dev/dev-ai.ps1 -InitProfile -Alias m7-claude-03
pwsh -NoProfile -File tools/dev/dev-ai.ps1 -Login -Alias m7-claude-03
```

Lệnh `-Login` in một địa chỉ: mở trên trình duyệt máy bạn, đăng nhập đúng tài khoản Claude, dán mã lại vào terminal. Mỗi bí danh một tài khoản khác nhau. Còn tài khoản thì làm tiếp `m7-claude-04`… Kiểm: `pwsh -NoProfile -File tools/dev/dev-ai.ps1 -AuthStatus -Alias m7-claude-01` (in `loggedIn=true`).

Phiên Claude điều phối trên .63 (khác worker) dùng một tài khoản một lúc; hết hạn mức thì bạn `/login` tài khoản khác như sáng 20/11.

**2. [x] Codex (gói ChatGPT của công ty).** Đã đăng nhập `m7-codex-01` (12:56). Lệnh để làm lại khi cần:

```bash
install -d -m 700 "$HOME/.m7/codex-profiles/m7-codex-01"
CODEX_HOME="$HOME/.m7/codex-profiles/m7-codex-01" codex login --device-auth
CODEX_HOME="$HOME/.m7/codex-profiles/m7-codex-01" codex login status
```

Lệnh thứ hai in địa chỉ và mã thiết bị: mở địa chỉ trên trình duyệt, đăng nhập tài khoản ChatGPT công ty, nhập mã. Lệnh thứ ba in "Logged in" là xong.

**3.** Khi phiên .63 báo, chạy `sudo bash ~/m7-drive/can-sudo-<việc>.sh` trong tab .63 (việc đầu: tài khoản Linux riêng chạy Codex, m7.238).

**4.** Xem nhanh bảng nhãn 20 brief mẫu khi phiên .63 soạn xong (m7.219).

**5.** Nhắc Anh Tuấn giao máy ảo chạy thật M7 (tin đã soạn 20/11), báo mình khi có.

**6.** Giữ sẵn 3–4 tài khoản Claude cho phiên điều phối trên .63. Chạy 4 luồng thì mỗi tài khoản hết hạn mức sau khoảng 1–1,5 ngày; mình báo là bạn `/login` tài khoản khác ngay. Mỗi lần chờ đăng nhập là luồng đứng.

---

## C. Mốc

| Mốc | Nội dung | Hạn | Tình trạng |
|---|---|---|---|
| Mốc 1 | Video đầu tiên từ ảnh sản phẩm, luồng mới (T232) | 15/11 (đã trễ) | ĐỎ. Còn T227 → T228 → T229 → T230 → T232, khoảng 40 giờ ước |
| Mốc 2 | Chạy thật trên máy ảo M7: đủ chức năng, tạm dừng/sửa tay, cấu hình trên UI | 30/11 | ĐỎ. Chưa có máy ảo |

---

## D. Danh sách task

Ký hiệu: [x] xong · [~] đang làm · [ ] chưa · [!] vướng. SHA là commit trên .63; "chưa push" = GitHub chưa có.

### D1. Đường ra video đầu (T232)

| | Task | Trạng thái | Đã làm | Vướng / cần |
|---|---|---|---|---|
| [x] | T222 thiết kế + đo Muse | Xong | Trên GitHub | — |
| [x] | T231 đặc tả luồng mới | Xong | Trên GitHub `02b1330` | — |
| [x] | T225 kho ảnh, nhân vật | Xong | `49c4ff0` (chưa push); 6 ảnh hộp đã nhập, nguồn AI | — |
| [x] | T224 từ điển cách đọc | Xong | `9dbef72` (chưa push) | — |
| [x] | T233 Muse chạy trên Ubuntu | Xong | `4a06f85`, `31bd18c` (chưa push) | — |
| [x] | T226 tạo ảnh qua Codex | Gộp | `20dd57f` (chưa push) | Lượt Codex thật: chờ bạn đăng nhập Codex (B2) |
| [~] | T223 kịch bản + storyboard mới | Gộp, cần gộp về một bản | `90da326`, `0ccd5f0`, `cbfc54e`; sửa test `7a589b0` | Gộp về một bản (m7.211, luật D-m7-139); Claude thật chờ bạn đăng nhập (B1) |
| [~] | T227 khung hình từng shot | Tester R3 bắt 1 lỗi vừa + 5 thấp; coder đang sửa hết. Xong thì tự gộp (m7.257) | `5c2559b` (bản sao) | Lượt nối + migration 5b5 đã duyệt (m7.229), làm ở lượt 07 |
| [~] | T228 Muse một phiên cho cả video | Coder sửa vòng 2 xong; verifier đang kiểm | `65a7128` (bản sao) | Muse thật tối đa 4 lượt (đã duyệt D-m7-136) |
| [ ] | T229 dựng video mới (ranh shot theo lời, karaoke, nhạc nền, khung kết) | Đã soạn giao việc (`wave3/T229`) | — | 14 giờ ước |
| [ ] | T230 kiểm tự động video mới | Chưa | — | 8 giờ ước |
| [ ] | **T232 lượt thật: ra video** | Chưa | — | Cần B1, B2; Muse tối đa 8 lượt (đã duyệt) |

### D2. Làm ngay theo D-m7-139, D-m7-141 (song song D1)

| | Việc | Mã câu | Trạng thái |
|---|---|---|---|
| [ ] | Gộp kịch bản về một bản, gỡ bản cũ | m7.211 | Đã giao lượt 07 (theo luật D-m7-139) |
| [ ] | Danh mục cảm xúc thành cài đặt | m7.213 | Đã giao lượt 07 |
| [ ] | Bộ kiểm xét cả dòng lẫn đoạn nối | m7.214 | Đã giao lượt 07 |
| [ ] | Cổng tự động: thiếu gói luật tiếng Anh thì không bật mẫu | m7.215 | Đã giao lượt 07 |
| [ ] | Vá 5 nhóm câu cấm còn lọt | m7.217 | Đã giao lượt 07 |
| [ ] | Tự thêm dấu chấm cuối dòng | m7.218 | Đã giao lượt 07 |
| [ ] | Bộ chấm kịch bản trên Claude thật (20 brief) | m7.219 | Đã giao lượt 07; chạy thật cần B1 và B4 |
| [~] | Claude CLI không lưu bản ghi phiên | m7.222 | Coder xong `2fec3bb` (bản sao S2), chờ verifier cùng luồng 2 |
| [ ] | Ghi địa chỉ Claude gọi ra ngoài, làm bộ lọc mạng cho máy thật | m7.224 | Đã giao lượt 07 |
| [~] | API quản lý mẫu Studio (thay SQL duyệt giả) | m7.225 | Coder xong (bản sao S4), verifier đang kiểm |
| [ ] | JPEG tự đổi sang PNG | m7.227 | Đã giao lượt 07 |
| [ ] | Từ điển cách đọc áp cho địa chỉ tổ chức | m7.235 | Đã giao lượt 07 |
| [~] | Chạy thử Codex thật 1–2 ảnh | m7.237 | Lượt 1/2 ĐẠT: ảnh PNG 1064×1478 sau 81 giây; verifier đang kiểm |
| [ ] | Codex chạy dưới tài khoản Linux riêng | m7.238 | Đã giao lượt 07; phiên .63 soạn script, bạn chạy bằng sudo (B3) |
| [ ] | Thủ tục cài worker Ubuntu + khép kẽ hở dọn Chrome | m7.245, m7.248 | Đã giao lượt 07 |
| [~] | Thêm Vivaldi, Opera vào danh sách cấm | m7.249 | Coder xong (bản sao S4), verifier đang kiểm |
| [x] | Dọn 179 bản sao cũ trên máy bạn (4,5 GB) | m7.250 | Xong 11:2x: xoá 179, tệp vá + 7 bundle ở `C:\Projects\_wt\m7-luu-2026-11-20\` (86 MB) |

### D3. Yêu cầu mới 20/11 (D-m7-140), song song D1

| | Việc | Trạng thái | Ghi chú |
|---|---|---|---|
| [ ] | Tạm dừng / sửa tay / chạy tiếp lượt làm video (máy chủ: trạng thái tạm dừng, chạy lại phần phụ thuộc) | Đã giao lượt 07 | Hiện lượt chỉ có Chờ, Chạy, Chờ người vận hành, Xong, Lỗi, Huỷ; chưa có Tạm dừng |
| [ ] | Màn hình Studio: nút Tạm dừng, Tiếp tục; sửa kịch bản, khung hình, clip, chữ đọc ngay trên lượt | Đã giao lượt 07 | |
| [ ] | Điểm dừng duyệt (sau kịch bản, khung hình, clip) bật tắt trên UI | Đã giao lượt 07 | |
| [ ] | Trang Cấu hình mở đủ cài đặt vận hành | Đã giao lượt 07 | Đã có trang: cấu hình chung, hồ sơ đầu ra, loại video ngắn, mẫu prompt |
| [ ] | Nhiều tài khoản Claude xoay vòng trên stack dev | Đã giao lượt 07 | Mã đã có xoay vòng (`M7_AI:ACCOUNTS`); công cụ dev mới bật một bí danh |
| [ ] | Video thứ hai có dùng tạm dừng, sửa tay | Chưa | Sau T232 và tính năng tạm dừng |

### D4. Lên chạy thật (Mốc 2)

| | Việc | Trạng thái | Vướng |
|---|---|---|---|
| [~] | Push lên GitHub khi bộ kiểm đủ xanh | Bộ đủ `7a589b0` đỏ (T054 chập chờn do quá tải), đã dừng, không push. Kiểm mỗi đêm 01:30, xanh thì tự push (D-m7-145) | Lần đầu: đêm 20/11 rạng sáng 21/11 |
| [!] | Máy ảo chạy thật M7 (Ubuntu 22.04, 8 nhân, 16 GB, 1 TB) | Chưa giao | Anh Tuấn |
| [ ] | Cài worker và stack lên máy ảo, chạy thử một video | Chưa | Cần máy ảo |
| [ ] | Kiểm bù 10 task thiếu verifier (D-m7-125) | Chưa | Sau T232 |
| [ ] | Lỗi chập chờn T076b (176 ms) | Đã ghi nợ | — |

---

## E. 40 câu m7.211–250 (đã duyệt 20/11 11:08, D-m7-141)

**Làm ngay (19):** m7.211 gộp về một bản · m7.213 cảm xúc thành cài đặt · m7.214 kiểm cả dòng lẫn đoạn nối · m7.215 cổng gói tiếng Anh · m7.217 vá 5 nhóm câu lọt · m7.218 tự thêm dấu chấm · m7.219 bộ chấm trên Claude thật · m7.222 CLI không lưu phiên · m7.224 ghi địa chỉ + lọc mạng máy thật · m7.225 API mẫu Studio · m7.227 JPEG sang PNG · m7.229 nối khung hình + migration 5b5 · m7.235 từ điển cho địa chỉ · m7.237 thử Codex thật · m7.238 Codex dưới tài khoản Linux riêng · m7.245 thủ tục cài worker Ubuntu · m7.248 khép kẽ hở dọn Chrome · m7.249 thêm Vivaldi, Opera · m7.250 dọn bản sao cũ.

**Chốt luôn (19):**

| Mã | Chốt |
|---|---|
| m7.212 | Cảnh ≤ 6 dòng, dòng ≤ 96 ký tự; cảnh ≤ 12 shot, video ≤ 120 shot |
| m7.216 | Sửa chữ trong dòng được; đổi số cảnh, số dòng thì cho AI viết lại (cùng tạm dừng/sửa tay ở D3) |
| m7.220 | Thư mục đăng nhập Claude của worker do người dùng container làm chủ |
| m7.221 | Chờ Claude 180 giây, bộ nhớ worker 1.536 MB; đo ở lượt thật rồi chỉnh |
| m7.223 | Claude thật trong Studio bật khi chạy lượt video, xong tắt cho đỡ tốn hạn mức |
| m7.226 | Cho Claude xem khung hình để kiểm trước khi gửi Muse (ảnh đã qua cổng, không người thật) |
| m7.228 | Khung hình đã qua kiểm đi thẳng sang Muse; muốn duyệt từng khung thì bật điểm dừng duyệt (D3) |
| m7.230 | Storyboard trỏ ảnh bằng mã ảnh, nhân vật bằng mã nhân vật (tên chính thức) |
| m7.231 | Không giữ chứng nhận C2PA của bên tạo ảnh; M7 tự ghi "ảnh AI", khai báo AI ở caption |
| m7.232 | Khoá từ điển cách đọc là khoá nhạy cảm, đổi cần người duyệt |
| m7.234 | Tên, mã lỗi phần từ điển thành chính thức |
| m7.236 | Codex chạy thẳng trên máy, không trong container, cho cả máy thật |
| m7.239 | Tin đầu gửi Muse gộp khung shot 1 với bộ nhận diện; sai thì sửa ngay ở lượt thật |
| m7.240 | Câu "Clip length: N seconds." để cố định trong mã |
| m7.241 | Ô đính ảnh của Muse bật cùng lúc nối khung hình |
| m7.242 | Video dài 70 phút vẫn giữ nhãn AI trên hình |
| m7.243 | Dòng đầu caption: "Nội dung có sử dụng AI" (sửa được trên UI) |
| m7.244 | Sản phẩm thực phẩm bảo vệ sức khoẻ: khuyến cáo hiện suốt phần nói về sản phẩm |
| m7.246 | Giữ tên "máy để bàn" |

**Không làm (2):** m7.233 chặn "worker cũ" (chỉ còn một bản worker) · m7.247 lọc biến Chrome trên Windows (worker chỉ chạy Ubuntu).

Nguồn câu: báo cáo task T223, T224, T226, T227, T228, T231, T233 trên .63. Câu đã trả lời trước nên bỏ: T223 câu 4, 5; T224 câu 4; T225 câu 1–4; T228 câu 2, 3.

---

## F. Ước lượng ngày xong (20/11 11:4x)

**Cách tính.** Nhịp thật đo từ 3 lượt trước: 2 tác nhân song song làm khoảng **5 giờ ước của kế hoạch trong 1 giờ đồng hồ** (lượt 03: 8 giờ, khoảng 40 giờ ước; lượt 05: 7,5 giờ, khoảng 38 giờ ước). Cộng thêm 30% cho vòng sửa sau tester, verifier. Máy chạy khoảng 14 giờ mỗi ngày (trừ lúc chờ hạn mức, chờ đăng nhập, bộ kiểm đủ ban đêm).

**Khối việc còn lại (giờ ước):**

| Luồng | Việc | Giờ ước | Giờ chạy | Xong khoảng |
|---|---|---|---|---|
| 1. Ra video đầu | T227 xong + nối khung hình 5b5, T228 + Muse thật, T229 dựng, T230 kiểm tự động, **T232 ra video** | ~46 | ~24 | **tối 21/11 – trưa 22/11** |
| 2. Một bản + bộ kiểm nội dung | m7.211 gộp một bản, 213 cảm xúc, 214, 215, 217 vá câu lọt, 218, 222, 235 | ~28 | ~15 | sáng 21/11 (phải xong trước T232) |
| 3. Tạm dừng, sửa tay, chạy tiếp | Máy chủ (trạng thái tạm dừng, chạy lại phần phụ thuộc, audit), màn hình Studio, điểm dừng duyệt | ~50 | ~26 | tối 22/11 |
| 4. Cấu hình trên UI + phần còn lại | Trang Cấu hình đủ khoá, API mẫu Studio (225), nhiều tài khoản Claude, JPEG (227), Codex thật + tài khoản riêng (237, 238), lọc mạng (224), cài worker Ubuntu (245, 248, 249), bộ chấm E3 (219) | ~63 | ~33 | sáng 23/11 |
| Sau 4 luồng | Bộ kiểm đủ + push (3,5 giờ, chạy đêm), **video thứ hai có tạm dừng, sửa tay**, kiểm bù 10 task (D-m7-125) | ~15 | ~10 | 23/11 |
| Máy chạy thật | Cài stack + worker lên máy ảo, bạn đăng nhập Claude, Codex, Muse trên máy mới, chạy thử 1 video | ~10 | ~6 | **1 ngày sau khi Anh Tuấn giao máy** |

**Kết quả:**

| Cách chạy | Video đầu (T232) | Xong chức năng trên .63 | Xong cả máy thật |
|---|---|---|---|
| **4 luồng, trần nặng 3 (đang chạy, D-m7-142)** | tối 21/11 – trưa 22/11 | **23/11** | **24/11** nếu có máy ngày 23/11 |
| Nếu chỉ 2 luồng (không chọn) | 22/11 | 26–27/11 | 27–28/11 |

Hạn 30/11: chạy 4 luồng thì còn đệm khoảng 5 ngày; 2 luồng thì còn 2–3 ngày.

**Điều kiện để kịp (rủi ro lớn nhất trước):**
1. **Hạn mức Claude** của phiên điều phối: hết mà không ai đăng nhập tài khoản khác thì cả 4 luồng đứng (mục B6).
2. Đăng nhập Claude cho worker và Codex hôm nay (B1, B2); thiếu thì T232 dừng ở bước kịch bản thật hay khung hình.
3. **Anh Tuấn giao máy ảo** chậm nhất 23/11; trễ ngày nào thì ngày xong lùi ngày đó.
4. Muse, Codex thật chạy đúng như đo; giao diện Muse đổi thì thêm khoảng nửa ngày.
5. Bạn duyệt kịp: bảng nhãn 20 brief (B4), xem video đầu và video thứ hai.

---

## G. Ghi chép

- Quyết định: `QUYET_DINH.md` (mỗi quyết định một dòng, có nguyên văn lời bạn). Diễn biến từng ngày: `nhat-ky/<ngày>.md`. Trên .63, phiên M7 ghi lại vào `docs/00-overview/DECISION_LOG.md` của repo.
- Trạng thái tóm tắt: `TRANG_THAI.md`. Tệp này (`KE_HOACH.md`) là nơi xem danh sách task và việc cần quyết.
