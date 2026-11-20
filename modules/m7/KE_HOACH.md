# Kế hoạch M7: ra video từ ảnh sản phẩm, chạy thật 30/11

Cập nhật: **20/11/2026 11:1x** · người cập nhật: phiên m7 máy Lead (sau mỗi lần kiểm .63 hay mỗi commit task) · nơi làm mã: phiên M7 trên .63.
Luật đang áp: **một bản duy nhất** (không "bản 1/bản 2", không "tên nháp") và **làm luôn một lần** (không "để sau") — D-m7-139.

---

## A. Cần bạn quyết

Hiện **không có câu nào chờ bạn**. Đã chốt gần nhất: m7.211–250 "ok" lúc 11:08 (D-m7-141, chi tiết mục E).

Còn chờ bạn một việc tay: **cho dùng sudo trên .63** để tạo tài khoản Linux riêng chạy Codex (m7.238). Có thì nhắn "có".

Đã chốt theo đề xuất, **muốn khác thì nói** (D-m7-140):

| Chuyện | Đã chốt |
|---|---|
| Tạm dừng, sửa tay, chạy tiếp | Nút **Tạm dừng** trên lượt làm video: dừng sau bước đang chạy. Sửa hay làm lại mọi thứ AI đã làm (kịch bản, storyboard, khung hình, clip từng shot, chữ đọc, phụ đề). Bấm **Tiếp tục** thì chỉ chạy lại phần bị ảnh hưởng. Thêm cài đặt **điểm dừng duyệt** (sau kịch bản, sau khung hình, sau clip) bật tắt trên UI |
| Cấu hình trên UI | Mọi cài đặt vận hành sửa ở trang **Cấu hình**; khoá nhạy cảm cần người duyệt; bí mật không hiện, chỉ hiện trạng thái (đã đăng nhập, hết hạn mức…) |
| Thứ tự | Video đầu (T232) **không chờ** tính năng tạm dừng; tạm dừng và cấu hình UI làm song song; xong thì làm video thứ hai có dùng tạm dừng, sửa tay |

---

## B. Bạn làm tay (lệnh)

Mở một tab mới: `ssh ssv@192.168.1.63`, rồi chạy trong đó. Không ảnh hưởng lượt đang chạy.

**1. Claude cho worker (mỗi tài khoản một bí danh, xoay vòng khi một tài khoản hết hạn mức):**

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

**2. Codex (gói ChatGPT của công ty):**

```bash
install -d -m 700 "$HOME/.m7/codex-profiles/m7-codex-01"
CODEX_HOME="$HOME/.m7/codex-profiles/m7-codex-01" codex login --device-auth
CODEX_HOME="$HOME/.m7/codex-profiles/m7-codex-01" codex login status
```

Lệnh thứ hai in địa chỉ và mã thiết bị: mở địa chỉ trên trình duyệt, đăng nhập tài khoản ChatGPT công ty, nhập mã. Lệnh thứ ba in "Logged in" là xong.

**3.** Cho dùng sudo trên .63 để tạo tài khoản Linux riêng chạy Codex (m7.238). Có sudo thì nhắn mình một chữ "có".

**4.** Xem nhanh bảng nhãn 20 brief mẫu khi phiên .63 soạn xong (m7.219).

**5.** Nhắc Anh Tuấn giao máy ảo chạy thật M7 (tin đã soạn 20/11), báo mình khi có.

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
| [~] | T227 khung hình từng shot | Sửa vòng 1 xong, verifier vòng 2 đang chạy | `b4d02ce` (bản sao) | Lượt nối + migration 5b5 đã duyệt (m7.229), làm ở lượt 07 |
| [~] | T228 Muse một phiên cho cả video | Coder xong, verifier đang chạy | — | Muse thật tối đa 4 lượt (đã duyệt D-m7-136) |
| [ ] | T229 dựng video mới (ranh shot theo lời, karaoke, nhạc nền, khung kết) | Đang soạn giao việc | — | 14 giờ ước |
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
| [ ] | Claude CLI không lưu bản ghi phiên | m7.222 | Đã giao lượt 07 |
| [ ] | Ghi địa chỉ Claude gọi ra ngoài, làm bộ lọc mạng cho máy thật | m7.224 | Đã giao lượt 07 |
| [ ] | API quản lý mẫu Studio (thay SQL duyệt giả) | m7.225 | Đã giao lượt 07 |
| [ ] | JPEG tự đổi sang PNG | m7.227 | Đã giao lượt 07 |
| [ ] | Từ điển cách đọc áp cho địa chỉ tổ chức | m7.235 | Đã giao lượt 07 |
| [ ] | Chạy thử Codex thật 1–2 ảnh | m7.237 | Đã giao lượt 07; cần B2 |
| [ ] | Codex chạy dưới tài khoản Linux riêng | m7.238 | Chờ B3 (sudo); phiên .63 soạn sẵn script |
| [ ] | Thủ tục cài worker Ubuntu + khép kẽ hở dọn Chrome | m7.245, m7.248 | Đã giao lượt 07 |
| [ ] | Thêm Vivaldi, Opera vào danh sách cấm | m7.249 | Đã giao lượt 07 |
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
| [~] | Push lên GitHub khi bộ kiểm đủ xanh | Script trên .63 tự push sau lượt 06 (D-m7-135) | Đang chờ lượt 06 xong |
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

## F. Ghi chép

- Quyết định: `QUYET_DINH.md` (mỗi quyết định một dòng, có nguyên văn lời bạn). Diễn biến từng ngày: `nhat-ky/<ngày>.md`. Trên .63, phiên M7 ghi lại vào `docs/00-overview/DECISION_LOG.md` của repo.
- Trạng thái tóm tắt: `TRANG_THAI.md`. Tệp này (`KE_HOACH.md`) là nơi xem danh sách task và việc cần quyết.
