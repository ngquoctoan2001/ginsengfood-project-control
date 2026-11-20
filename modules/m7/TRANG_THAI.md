# Trạng thái — m7

Mốc: 20/11/2026 13:0x (UTC+7, thứ Sáu) · origin/main = main máy Lead = `68c9100` · .63 main `cbfc54e`, **8 commit CHƯA push** (`49c4ff0`, `90da326`, `87a2d0d`, `9dbef72`, `4a06f85`, `31bd18c`, `0ccd5f0`, `cbfc54e`), sạch · CI giữ tắt.
**Bộ kiểm đủ `cbfc54e` ĐỎ, KHÔNG push (D-m7-133):** 65/74 bước rồi .63 bị tắt cứng 15:38–15:42 (không có dòng tắt máy). Đỏ thật: `T036` `Ep174LoadsEveryRepositoryPromptFileAndFindsItAlreadySeededAsync` (T223 `90da326` thêm mục bản 2 DRAFT vào `prompts/manifest.json`, cố ý nạp qua EP-174 không qua migration, test cũ của T036 vẫn đòi mọi mục đã có hạt giống; chạy lại vẫn đỏ). Chập chờn: `T076b` (AsrVerify bắt đầu trước Render kết thúc 176 ms; chạy lại đúng môi trường 3/3 xanh) → ghi nợ. m7.207 → D-m7-134: phiên .63 sửa ở lượt 06.
**Lượt 07 chạy 4 luồng từ 20/11 12:59** (D-m7-142; lượt 06 dừng 11:50 vì hết hạn mức, Toàn đăng nhập tài khoản mới 12:40); `vong-lap.sh` tự nối khi hết hạn mức 5 giờ. Main .63 `7a589b0` (11 commit chưa push); bộ kiểm đủ trên `7a589b0` chạy từ 11:52, xanh thì `push-sau-06.sh` tự push (D-m7-135). Đã đăng nhập: worker `m7-claude-01`, `m7-claude-02`, Codex `m7-codex-01`.
**Điều khiển .63 (D-m7-110):** phiên m7 máy Lead đọc bản ghi, giao lượt qua ssh (`claude --resume … -p`, `auto`, tệp lệnh, log ở `~/m7-drive/`); nối lượt bằng script setsid trên .63 (`noi-06.sh`). Phiên máy Lead không tự sửa mã M7. Sổ trên .63 đọc ở `~/dev/project-control` (chỉ đọc).
Sẵn sàng **15%** (chấm 11/11, chưa chấm lại). Mốc 1: **TRỄ, ĐỎ**, đóng khi T232 ra video (D-m7-101, DL-337). Mốc 2 (30/11, còn 11 ngày): ĐỎ.

## WP31 (T222…T233) lúc 19/11

| Task | Trạng thái | SHA (.63, chưa push) |
|---|---|---|
| T222 thiết kế + đo Muse | xong (11/13 lượt Muse) | trên origin |
| T231 đặc tả | xong | trên origin `02b1330` |
| T225 kho ảnh, nhân vật | xong; sửa 12 lỗi tester R3, verifier ĐẠT; migration 5b3 + 5b4 đã áp DB dev; 6 ảnh hộp đã nhập (nguồn AI) | `49c4ff0` |
| T223 kịch bản bản 2 | gộp (R3 ok); nối claude-subscription `0ccd5f0` verifier ĐẠT; gói EN_IMAGE_PROMPT đã nạp DB dev. Kịch bản Claude thật CHƯA: Toàn phải `dev-ai.ps1 -Login` trên .63, chưa có bộ chạy eval E3 (câu 12), câu 17 | `90da326`, `0ccd5f0`, `cbfc54e` |
| T224 từ điển cách đọc (C) | xong, verifier v4 ĐẠT | `9dbef72` |
| T233 test Muse trên Ubuntu + RU-16 | xong, verifier v4 ĐẠT | `4a06f85`, `31bd18c` |
| T226 adapter codex-chatgpt (R3) | ok gộp (D-m7-132) nhưng chưa vào main; bản trên `31bd18c` là `541d77f` | ngoài main |
| T227 bộ nhận diện + khung hình | coder lõi `598e1a9` (trên T226), verifier đang chạy thì dừng | ngoài main |
| T228 Muse một phiên | coder vừa bắt đầu thì dừng; cần Muse thật (chưa duyệt) | — |
| T229, T230, T232 | chưa | — |

**Luật mới D-m7-139:** một bản duy nhất (không "bản 1/bản 2", không "tên nháp") và làm luôn một lần (không "task sau"); đã đưa vào `p-07.txt`. **Kế hoạch, danh sách task, quyết định cần Toàn: [KE_HOACH.md](KE_HOACH.md)** (D-m7-140; cập nhật mỗi lần kiểm .63). Chờ Toàn: m7.211…250 (40 câu: 19 làm ngay, 19 chốt luôn, 2 không làm); việc tay: đăng nhập Claude nhiều bí danh, Codex, sudo .63. Yêu cầu mới D-m7-140 (tạm dừng/sửa tay/chạy tiếp, cấu hình trên UI, nhiều tài khoản Claude) đã vào `p-07.txt`. Sự cố 18/11: log test T233 in token nhắn tin của phiên .63 ra tệp trên .63, đã xoá, không commit, không ra ngoài.

## Việc tay của Toàn

1. (Xong 20/11 08:10: .63 dùng tài khoản Claude khác còn hạn mức.) Lúc lượt 06 chạy, tab claude tương tác của Toàn trên .63 (thư mục repo M7) đừng giao việc sửa mã M7.
2. Đăng nhập hồ sơ Claude của worker trên .63: `pwsh -NoProfile -File tools/dev/dev-ai.ps1 -Login` (tương tác), cần cho kịch bản Claude thật.
3. (Xong 20/11, D-m7-136: Muse T228 ≤ 4, T232 ≤ 8, trần 25; tới phiên .63 ở lượt 07 qua `noi-07.sh`.) Trả lời 39 câu m7.211…249.
4. Báo phiên m7 khi Anh Tuấn giao máy ảo M7 hoặc máy staging.

## Sheet (19/11 13:1x)

- 19/11: M7-250 T224 Hoàn thành `9dbef72`; M7-259 T233 Hoàn thành `4a06f85`; M7-249 T223 Chờ review 95% `0ccd5f0`; M7-252 T226 ghi chú chưa gộp; M7-253 T227 Đang làm 50%; M7-254 T228 Đang làm 10%. Lead Đạt cho các task này chờ bộ kiểm đủ trên SHA mới.
- 18/11: M7-251 T225 Hoàn thành `49c4ff0` (W Đạt); 13 task R1/R2 Lead Đạt; 10 task thiếu verifier kiểm bù sau T232 (D-m7-125, danh sách ở nhật ký 18/11).
- R3 M7-014 T008, M7-019 T013 chờ Toàn. M7-009 (T003 CI) Bị chặn do CI tắt (rủi ro đã nhận).

## Máy và vận hành

- Máy chạy thật M7: máy ảo Ubuntu 22.04 không card (D-m7-099, DL-338); máy staging giống .99; Anh Tuấn chưa giao cả hai.
- .63: máy ảo Hyper-V 10 vCPU, 38 GB; runner CI `may-63` dùng chung. Stack dev `m7-m7-*` 6/6 healthy, dựng từ `cbfc54e` (ảnh worker có Claude CLI 2.1.311, chế độ mock). Kiểm tách rời dùng clone `--no-local`.
- Máy Lead: ssh chờ nền hay bị Claude Code tắt khi thiếu RAM; nối lượt đặt trên .63. `_wt/m7/` đã dọn 20/11 (m7.250): 179 bản sao xoá, tệp vá + 7 bundle ở `_wt/m7-luu-2026-11-20/`; còn `kiem-T008`, `kiem-T012`, `local` (không phải git) và 34 log T073v.
- Mở sau Mốc 1: T066 vòng 3, T076b.2, T076b.4, T076.8, T076.10, `evidence_region` Muse, T088…T090, T044, T065 còn lại, T062b; nợ T085, T190b, ngưỡng ASR 20 kịch bản (Mốc 2); V5 đồng ý nhân vật REAL (WP29, D-m7-130).
- Báo cáo tuần: phiên m7 không tự viết (D-m7-090).

Ranh giới: push và Muse thật chỉ theo lời Toàn từng lần; không migration DB dùng chung, không UAT hay production nếu Lead chưa nói rõ. D-m7-067, 069…097, 099…133 vẫn hiệu lực.
