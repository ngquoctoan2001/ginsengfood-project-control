# Trạng thái — m7

Mốc: 24/11/2026 18:0x (UTC+7, thứ Ba; kiểm .63 bằng ssh chỉ đọc) · origin/main = main .63 = `4ef0350` (24/11 06:03; `day-len.sh` push mỗi giờ, push cuối 06:33) · cây .63 sạch, 0 commit chưa push · CI GitLab của M7 giữ tắt.
**.63 ĐANG DỪNG chờ Toàn:** vòng nối lượt kết thúc 24/11 06:03 mã 0 ("dừng để máy Lead xem", sau 7 lần nối vì hết hạn mức 5 giờ). Không có test hay lượt Studio chạy; còn `day-len.sh`, stack dev `m7-m7-*` (api, worker 13 giờ healthy; edge, dev-idp 2 ngày), tải 0,57, đĩa 35%. Báo cáo của phiên .63: `~/m7-drive/bao-07-nhap.md` (bản sao ở bằng chứng nhật ký 24/11); sổ task `~/m7-drive/trang-thai-task.md`.
**Luật đang chạy:** D-m7-150 (luồng video THẬT trước: Claude/Codex/Muse thật, dữ liệu MẪU, qua UI Studio; test hạn chế, bộ đủ không chạy, push mỗi giờ), D-lead-063/064 (một checkout, khoá tệp, kiểm theo hai mức), D-m7-110 (máy Lead đọc bản ghi, giao lượt qua ssh `claude --resume … -p`, log `~/m7-drive/`; không sửa mã M7). UI: `ssh -N -L 6700:127.0.0.1:6700` rồi `https://localhost:6700` (DL-364).
Sẵn sàng **15%** (chấm 11/11, chưa chấm lại). **Mốc 1: TRỄ, ĐỎ** (đóng khi T232 ra video, D-m7-101, DL-337): video đầu CÓ nhưng ASR 0,8954 < 0,90 nên lượt FAILED; video 2 PAUSED chờ Toàn. Mốc 2 (30/11, còn 6 ngày): ĐỎ.

## Video thật (lượt D-m7-150)

- **Video đầu:** `~/m7-drive/video/SV-20261122-003-1343.mp4` (+ `.txt`): 1080×1920, 93,7 giây, RENDER ffmpeg thật (bản dựng 1), lượt Studio `01a20723`. ASR_VERIFY 0,8954 < ngưỡng tạm 0,90 → FAILED, không sang IN_QA; chấm lại bằng T230 (từ điển ngược `21273ed`) được 0,9008. AUTO_CHECK 15 mục mới sẽ chặn video này ở mục đứng hình (6 giây cuối giữ khung, DL-333): đúng thiết kế, bản dựng 2 (T229) bỏ giữ khung. Là video xem trước, không phát.
- **Video 2 (luồng mới)** SV-20261123-001, lượt `01a20945` PAUSED, 7/8 clip: kịch bản Claude thật (5 lần EP-122: lời luôn ngắn hơn 91 giây hay vượt 8 cảnh), IDENTITY_KIT, IMAGE_PROMPT, TTS 98,5 giây, KEYFRAME Codex 8 khung hình (Codex 11/12; sửa tay làm lại khung 4, 5 qua EP-246; sửa một dòng kịch bản qua EP-247), điểm dừng, Muse một phiên có đính khung hình. Chạy tiếp cần EP-243 và worker `realrun6`, ngưỡng ASR tạm 0,90; còn shot 8 (INVITATION) → RENDER bản 2 → ASR → AUTO_CHECK 17 mục.
- **Muse đã dùng 28/33:** T232 8/8, video 2 8/8, T228 2/4 (shot 3, 7 của video đầu). **Claude** 4 kịch bản + 3 IMAGE_PROMPT; **Codex** ảnh thật 11/12 ở video 2. Hạn mức Claude của worker: `m7-claude-01` hết tuần tới 23/11 23:00, `-03` tới 24/11 03:00, `-02` hết phiên (đã qua; kiểm lại khi giao lượt).

## WP31, WP32 lúc 24/11 06:03 (`4ef0350`)

| Task | Trạng thái | SHA (đã lên origin) |
|---|---|---|
| T222, T231, T225, T224, T233 | xong từ trước | — |
| T223 kịch bản một bản, gói guard, danh mục cảm xúc, từ điển cách đọc | xong (luồng 2 lượt 07); nợ: EP-177 chưa tạo được dòng đầu cho khoá nhạy cảm (ADM-009) | `c43b87e`, `cde186b`, `0f880b0`, `ff8e8a0` |
| T226 Codex ảnh | xong (đợt A + B: cài worker Ubuntu + pidfd), Codex thật chạy | `6d78800`, `0d1c442`, `2e46f3f`, `8d6018c`, `1ccb451` |
| T227 bộ nhận diện + khung hình | gộp main | `9da8b00` |
| T228 Muse một phiên | gộp main; lỗi tự gây `56cca87` (chạy script trong trang) đã thay `6fc7cb0` (nhận thẻ mới bằng thuộc tính) | `88531d7`, `6fc7cb0` |
| T229 dựng bản 2 (mốc từ, karaoke, bỏ giữ khung, gộp shot ngắn, API xin clip đúng độ dài) | xong; 4/5 ca đầu-cuối | `67410a6`, `1c68c12`, `d553ece`, `128a161` |
| T230 kiểm tự động bản 2 (17 mục) + ASR từ điển ngược | xong cả 5 phần | `21273ed`, `db90999`, docs `4ef0350` |
| WP32: T234 tạm dừng, T235 sửa tay (EP-244…247), T236 điểm dừng duyệt | xong; T236 sửa điểm dừng đến muộn `2a01497` | `e388111`, `1e70b13`, `6f95538`, `d6192db`, `77979f5` |
| T237 màn Cài đặt vận hành; T238 | xong; bảng khoá vận hành chờ Toàn duyệt | `c407f5c` |
| EP-192…195 API mẫu dây chuyền (qua ApprovalService) | xong | `63bbeb9` |
| T232 (video thật) | video đầu có, ASR không đạt; video 2 chờ Toàn | — |

Kỹ thuật đáng nhớ: migration `_L10_StudioRunPause`, `_L10_KeyframeStep`, `_L11_StoryboardEmotionSetting`, `_L11_ScriptTemplateSeed` đã áp DB dev (sao lưu `~/m7-drive/luu/dev-db-1123-1326.sql.gz`); stack dựng lại 4 lần từ cây sạch (lần cuối 24/11 05:21 từ `5345c2d`); Architecture trọn trên `67410a6` 1279/1281 (2 ca sửa ở `627b556`). Đã dừng worker mồ côi của test T076 (PID 144460) nối edge `:6700` dưới danh tính dev-desktop.

## Việc tay của Toàn và câu cần quyết

1. **Chờ Toàn (chặn video 2):** m7.260 cho thêm 1 lượt Muse (tổng 9, vượt DL-358 một lượt) để làm shot 8, rồi dựng, kiểm lời, kiểm tự động. Chi tiết 10 câu m7.260…269 ở `KE_HOACH.md` mục A.
2. Việc tay (DL-359): `sudo bash ~/m7-drive/can-sudo-worker-ubuntu.sh` rồi `sudo bash ~/m7-drive/can-sudo-codex-user.sh`, sau đó tự đăng nhập Codex cho tài khoản `m7codex`; duyệt bảng khoá vận hành M7-T237; kiểm hồ sơ Claude của worker còn hạn (`dev-ai.ps1 -Login` nếu cần).
3. Giao lượt .63 chạy tiếp khi Toàn trả lời: máy Lead viết lệnh vào `~/m7-drive/p-NN.txt` rồi chạy `claude --resume <id> -p` bằng setsid (xem `PHIEN.md`).

## Sheet, máy và vận hành

- Sheet (ghi ở máy Lead, .63 không có `sheet.json`): cập nhật lần cuối 19/11; **chưa ghi** các commit 21/11 → 24/11 (T227, T228, T229, T230, T234…T238, EP-192…195, video đầu): ghi theo `trang-thai-task.md` khi Toàn bảo.
- Máy chạy thật M7 = .63 (máy ảo Ubuntu, 10 vCPU, 38 GB; chạy chung runner CI `may-63`); `_wt/m7` ở máy Lead đã dọn. Stack dev `m7-m7-*` ở .63. Máy staging giống .99 do Anh Tuấn nhân bản, chưa giao.
- Mở sau Mốc 1: T066 vòng 3, T076b.2, T076b.4, T076.8, T076.10, `evidence_region` Muse, T088…T090, T044, T065 còn lại, T062b, ngưỡng ASR 20 kịch bản (Mốc 2); V5 nhân vật REAL (WP29, D-m7-130).
- Báo cáo tuần: phiên m7 không tự viết (D-m7-090).

Ranh giới: push và Muse thật chỉ theo lời Toàn từng lần (trần DL-352/DL-358); không migration DB dùng chung, không UAT hay production nếu Lead chưa nói rõ. D-m7-067, 069…097, 099…150 vẫn hiệu lực.
