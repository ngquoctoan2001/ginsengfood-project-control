# Kế hoạch M7: ra video từ ảnh sản phẩm, chạy thật 30/11

Cập nhật: **24/11/2026 18:2x** (kiểm .63 chỉ đọc; `.63` main = origin/main = `4ef0350`) · người cập nhật: phiên m7 máy Lead (sau mỗi lần kiểm .63 hay mỗi commit task) · nơi làm mã: phiên M7 trên .63.
Luật đang áp: **một bản duy nhất** (không "bản 1/bản 2", không "tên nháp") và **làm luôn một lần** (không "để sau") — D-m7-139.

---

## A. Cần bạn quyết

| Mã | Quyết gì | Đề xuất | Hệ quả |
|---|---|---|---|
| [x] m7.260 | **Video 2 chờ bạn:** cho thêm 1 lượt Muse (tổng 9, vượt DL-358 một lượt) để làm shot 8 (INVITATION), rồi dựng bản 2, kiểm lời, kiểm tự động 17 mục? Chỉ cần tiếp tục lượt đang PAUSED (EP-243, worker `realrun6`, ngưỡng ASR tạm 0,90) | **Có** (máy Lead) → Toàn duyệt "260 oke" 24/11 (D-m7-151); .63 làm ở lượt 08 | Không có thì video 2 đứng ở 7/8 clip, không có video thứ hai để xem |
| [x] m7.261 | Hai lượt Muse của phần T228 đã dùng cho shot 3, 7 của video đầu (D-m7-150 cho dùng, DL-352 ghi "không mượn phần của task kia"): tính là lượt thử thật của T228 hay ghi lệch? Phần T228 còn 2 | **Toàn chốt 24/11: A + BỎ trần lượt Muse (D-m7-152)** (đề xuất cũ: Tính là lượt thử thật của T228 (đường một cuộc trò chuyện), giữ 2 còn lại cho T228) | Chỉ ghi sổ |
| [x] m7.262 | ASR video đầu 0,8954 < ngưỡng tạm 0,90: coi video này chỉ để xem, hay hạ ngưỡng tạm? (bản chấm mới T230 đã cho 0,9008) | **Toàn chốt 24/11: A** (đề xuất cũ: Chỉ để xem; ngưỡng giữ 0,90) | Hạ ngưỡng thì video đầu sang IN_QA nhưng AUTO_CHECK 17 mục vẫn chặn ở mục đứng hình (6 giây cuối giữ khung) |
| [x] m7.263 | Cảnh hệ thống (tên sản phẩm, khuyến cáo, tổ chức): (a) đọc câu bắt buộc ngay trong cảnh, hay (b) không lời, hình chạy dưới lời cảnh trước (đang dùng tạm, `749d9d4`) | **Toàn chốt 24/11: A = (a) đọc câu bắt buộc trong cảnh** (đề xuất cũ: (b) cho video 2 (máy Lead, tạm; phiên .63 chưa đề xuất); (a) nếu bạn muốn nghe đọc) | (a) tăng độ dài lời nhưng giúp qua ngưỡng 91 giây |
| [x] m7.264 | KEYFRAME_CHECK chạy ở m7-api lúc chốt bước KEYFRAME nhưng m7-api không có lớp AI: dev dùng bản giả (production chặn bằng Unavailable). (a) tách thành bước MÁY CHỦ chạy ở m7-worker, hay (b) chỉ dev cho m7-api gọi Claude | **Toàn chốt 24/11: a** (đề xuất cũ: (a)) | (b) nhanh nhưng lệch production |
| [x] m7.265 | EP-195: cho người có vai AD kích hoạt mục không nhạy cảm (đổi ApprovalPolicy dùng chung)? Cấm hẳn tự duyệt mẫu dây chuyền (DL-036 cho same_person)? | **Toàn chốt 24/11: A (giữ nguyên)** (đề xuất cũ: Giữ như đã làm: AD tự kích hoạt 403, không đổi chính sách dùng chung (phiên .63 chưa đề xuất)) | AD tự kích hoạt đang 403 |
| [x] m7.266 | Hạt giống có quyết định: (a) migration nạp sẵn mẫu prompt ACTIVE kèm quyết định kích hoạt dẫn DL-355 (`_L11_ScriptTemplateSeed`, `_L10_KeyframeStep` KEYFRAME_CHECK) có đúng ý "bản mới nạp sẵn dùng luôn"? (b) khoá nhạy cảm `tts.pronunciation_dictionary`: theo DL-094 KHÔNG hạt giống; cho nới luật ADM-009 để EP-177 tạo được dòng đầu? | **Toàn chốt 24/11: (a) có; (b) tách thành m7.270, đã chốt có** (đề xuất cũ: (a) đúng ý; (b) cho nới ADM-009 chỉ cho đường tạo dòng đầu (máy Lead, tạm; phiên .63 chưa đề xuất)) | Không nới thì từ điển cách đọc chưa nạp được từ UI |
| [x] m7.267 | Mẫu kịch bản (≤ 12 từ/dòng, ≤ 6 dòng/cảnh) cộng 3 cảnh hệ thống và trần 8 lượt Muse chỉ cho tối đa ~90 giây lời, dưới ngưỡng 91 giây (mọi lần Claude viết đều thiếu; video 2 phải sửa brief; lần 2 ra 11 cảnh, vượt trần Muse): chỉnh luật mẫu hay ngưỡng? Miễn eval IMAGE_PROMPT_GENERATE cho mọi DB? Mẫu IMAGE_PROMPT_GENERATE v2 có mục lời dặn biên tập? | **Toàn chốt 24/11: A, cấu hình thoáng sửa được trên UI** (đề xuất cũ: Chỉnh luật mẫu (nới số từ mỗi dòng hay số dòng mỗi cảnh), giữ 91 giây; miễn eval; có mục lời dặn (máy Lead, tạm; phiên .63 chưa đề xuất)) | Không chỉnh thì mọi kịch bản Claude thật phải sửa tay |
| [x] m7.268 | AUTO_CHECK mục 16 (ranh shot so ranh lời) và 17 (karaoke): ngưỡng làm theo dòng kế hoạch 300 ms và 250 ms (trung vị/p95); thiết kế T222 (DL-340) đề xuất 200 ms và trung vị 120 ms: chọn theo số đo video 2? Cảnh không lời đứng sau cảnh chỉ một câu bị mục 16 chặn (đề xuất giữ, FR-STU-008). Gói guard EN_IMAGE_PROMPT: nhóm IMG_VI_* chặn mọi chữ "bác sĩ", "bệnh viện", danh sách tên người nổi tiếng là danh sách tĩnh: giữ? | **Toàn chốt 24/11: oke** (đề xuất cũ: Giữ 300/250 tới khi có số đo video 2; giữ cảnh không lời bị mục 16 chặn (đề xuất của phiên .63); giữ gói guard (máy Lead)) | — |
| [x] m7.269 | T229: một clip mỗi cảnh (giữ cho T232); nhạc nền khi có tệp có quyền; khung kết dùng phần tiếp clip cuối; phông Noto Sans tới khi có Be Vietnam Pro; trần độ dài clip khi bật nhà cung cấp video qua API | **Toàn chốt 24/11: oke** (đề xuất cũ: Giữ một clip mỗi cảnh (đề xuất của phiên .63); các mục còn lại phiên .63 chưa đề xuất) | — |
| [x] m7.270 | Phần (b) của m7.266: nới luật ADM-009 CHỈ cho đường tạo dòng đầu của khoá nhạy cảm `tts.pronunciation_dictionary` (EP-177 qua ApprovalService, vẫn hai người), để từ điển cách đọc nạp được từ UI? | **Toàn chốt 24/11: có, chỉ đường đó (D-m7-153)** (đề xuất cũ: Có, chỉ đường tạo dòng đầu (máy Lead; Toàn trả lời "a" ở m7.266 nên chưa tính là đã chốt)) | Không nới thì từ điển cách đọc dùng đường đang có |
| [x] m7.271 | Video 2 hỏng AUTO_CHECK mục 10: luật VN-AI-01 đòi nhãn AI từ khung 0, DL-332 đã bỏ nhãn trên hình. (a) phiên bản mới bộ luật tuân thủ, video ngắn chỉ đòi nhãn ở caption, gói, manifest, kích hoạt qua duyệt thật; hay (b) bật lại nhãn trên hình (đổi DL-332, dựng lại) | **Toàn chốt 24/11: (a) sửa bộ luật (D-m7-154)** (đề xuất cũ: (a)) | Nguy hiểm: verifier ở cổng trước go-live; (a) cho video 2 đi tiếp ngay, 0 Muse |
| [x] m7.272 | **Chặn Mốc 1 (từ 01:33 25/11):** làm lại video 2 từ AUTO_CHECK theo thiết kế luôn dựng lại RENDER và chạy lại ASR (FR-STU-013). (a) cho dựng lại RENDER + ASR trên máy để bàn .63 (0 Muse, 0 Claude, khoảng 10–15 phút, dùng đúng clip, lời đọc, phụ đề đã có; video mới thay bản 2); hay (b) thêm đường làm lại chỉ AUTO_CHECK (đổi FR-STU-013, vùng Nguy hiểm máy trạng thái lượt, lâu hơn) | **Toàn chốt 25/11: (a) dựng lại (D-m7-161)** (đề xuất cũ: **(a)** (phiên .63)) | Lượt `01a20ece…` đang QUEUED; (b) tái dùng đúng tệp bản 2 nhưng đổi máy trạng thái lượt |
| [~] m7.273 | **Chặn Mốc 1 (25/11 10:32):** video 2 qua AUTO_CHECK 17/17, nhưng khi soát duyệt thấy cảnh cuối (giây 88–96) có túi giấy in rõ logo "Kraft" (nhãn hiệu thật bên thứ ba) → QA-V-12 "bao bì trên hình đúng SKU" không đạt. (a) 1 lượt Muse làm lại clip cảnh có túi (prompt cấm logo, nhãn hiệu thật) rồi dựng, kiểm lời, kiểm tự động lại (0 Claude/Codex); hay (b) chấp nhận như bản xem trước nội bộ không phát, ghi QA-V-12 không đạt kèm lưu ý | **Máy Lead chọn (a) theo đề xuất 25/11 11:06 vì Toàn dặn "xong hết" (D-m7-163), Toàn chưa trả lời; đổi ý thì bảo.** (đề xuất cũ: **(a)**) | (a) khoảng 30 phút, Muse không còn trần; (b) đóng Mốc 1 sớm hơn nhưng duyệt một video có logo bên thứ ba |
| [x] m7.258 | Khung dọc không đúng 9:16 | Cắt giữa (D-m7-149) | — |
| [x] m7.259 | Băm điểm ảnh ảnh có người | Có, cột ở migration 5b5 trên DB dev .63 (D-m7-149) | — |
| [x] m7.257 | Task R3: tester + verifier ĐẠT thì tự gộp, bạn xem sau | Đã duyệt 15:0x (D-m7-146) | Có hiệu lực từ lần nối lượt kế tiếp |
| [x] m7.256 | Bộ kiểm đủ chạy thưa: mỗi đêm 01:30 + mốc lớn, xanh thì tự push | Đã chốt 14:1x (D-m7-145) | Đêm nay 01:30 chạy lần đầu trên main .63 |
| [x] m7.255 | Muse thật cho video thứ hai tối đa 8 lượt, trần 25 → 33 | Đã duyệt 13:0x (D-m7-143) | — |

**Tình hình lúc 24/11 18:0x (kiểm .63):** phiên .63 chạy tới 24/11 06:03 rồi dừng (báo cáo `~/m7-drive/bao-07-nhap.md`); đã lên origin 59 commit từ 21/11 15:00, HEAD `4ef0350`; **video đầu có (93,7 giây, ASR 0,8954 chưa đạt 0,90)**, video 2 (kiểm 24/11 22:29) đã dựng 101,3 giây, ASR 0,934, AUTO_CHECK hỏng mục 10 nên Toàn chốt m7.271 (a) lúc 22:39 (D-m7-154); Muse đã dùng 28 lượt (hết trần từ 24/11 18:17, D-m7-152). Mười câu m7.260…269 là mười câu của báo cáo lượt 07 theo thứ tự (260 đã duyệt 24/11; 261…269 Toàn trả lời 24/11, D-m7-152; m7.270 = phần (b) của 266, Toàn duyệt 24/11, D-m7-153); việc tay sudo (DL-359) ở `TRANG_THAI.md`.

Đã chốt gần nhất: m7.254 chạy 4 luồng, trần lệnh nặng 3 (D-m7-142, 12:4x); m7.211–250 (D-m7-141, chi tiết mục E).

**Tình hình lúc 21/11 15:3x (D-m7-150):** đã push 11 commit lên GitHub (`0233366`); từ nay tự push mỗi giờ, không chờ xanh; bộ kiểm đủ đêm đã tắt, test hạn chế tối đa. **Phiên .63 chuyển sang chạy luồng làm video THẬT ngay** (Claude, Codex, Muse thật, dữ liệu MẪU) qua UI Studio để bạn xem; luồng 2–4 chạy phụ. Xem UI: mở PowerShell chạy `ssh -N -L 6700:127.0.0.1:6700 ssv@192.168.1.63`, rồi mở trình duyệt `https://localhost:6700` (bỏ qua cảnh báo chứng chỉ).

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

**24/11 18:0x: bảng trạng thái từng task nằm ở `TRANG_THAI.md` (mục WP31, WP32 lúc 24/11 06:03); các hàng dưới đây là bản 21/11, chưa viết lại: T227, T228, T229, T230, WP32 (T234…T236), T237, T238, EP-192…195 nay đều xong và đã lên origin; còn T232 (video 2) chờ m7.260.**

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
| [x] | T227 khung hình từng shot (lõi) | Đã gộp vào main 21/11 14:07 sau vòng sửa của tester; phần guard prompt ở danh sách cổng | `9da8b00` | Lượt nối + migration 5b5 đã duyệt (m7.229), làm ở lượt 07 |
| [x] | T228 Muse một phiên cho cả video (lõi) | Đã gộp 21/11 15:12; còn nối phần máy chủ cùng khung hình 5b5 và chạy Muse thật | `88531d7` | Muse thật tối đa 4 lượt (đã duyệt D-m7-136) |
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
| [~] | Tạm dừng / sửa tay / chạy tiếp lượt làm video (máy chủ: trạng thái tạm dừng, chạy lại phần phụ thuộc) | Phần miền xong `e388111` (T234); đang làm lưu trữ, API, audit | Hiện lượt chỉ có Chờ, Chạy, Chờ người vận hành, Xong, Lỗi, Huỷ; chưa có Tạm dừng |
| [ ] | Màn hình Studio: nút Tạm dừng, Tiếp tục; sửa kịch bản, khung hình, clip, chữ đọc ngay trên lượt | Đã giao lượt 07 | |
| [ ] | Điểm dừng duyệt (sau kịch bản, khung hình, clip) bật tắt trên UI | Đã giao lượt 07 | |
| [ ] | Trang Cấu hình mở đủ cài đặt vận hành | Đã giao lượt 07 | Đã có trang: cấu hình chung, hồ sơ đầu ra, loại video ngắn, mẫu prompt |
| [ ] | Nhiều tài khoản Claude xoay vòng trên stack dev | Đã giao lượt 07 | Mã đã có xoay vòng (`M7_AI:ACCOUNTS`); công cụ dev mới bật một bí danh |
| [ ] | Video thứ hai có dùng tạm dừng, sửa tay | Chưa | Sau T232 và tính năng tạm dừng |

### D4. Lên chạy thật (Mốc 2)

| | Việc | Trạng thái | Vướng |
|---|---|---|---|
| [x] | Push lên GitHub (D-m7-150: push mỗi giờ, không chờ xanh) | Bộ đủ `7a589b0` đỏ (T054 chập chờn do quá tải), đã dừng, không push. Kiểm mỗi đêm 01:30, xanh thì tự push (D-m7-145) | Lần đầu: đêm 20/11 rạng sáng 21/11 |
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
