# Trạng thái — m7

Mốc: 18/11/2026 08:30 (UTC+7, thứ Tư) · origin/main = main máy Lead = `68c9100` (push 08:28, D-m7-118), sạch · .63 main `68c9100` + việc lượt 04 đang làm · CI giữ tắt.
**Tài khoản mới (18/11):** Toàn chuyển tài khoản Claude sáng 18/11, đã `/login` trên .63 lúc 08:08. Phiên CLI .63 `9b228a48-18f2-4f89-a565-0d017ccdc4ab` chạy tiếp được ở tài khoản mới.
**Điều khiển .63 (D-m7-110):** phiên m7 máy Lead đọc bản ghi, giao lượt qua ssh (`claude --resume … -p`, `auto`, tệp lệnh, log ở `~/m7-drive/`, cách làm ở `PHIEN.md`). Phiên máy Lead không tự sửa mã M7. Toàn không gõ vào phiên `9b228a48` khi đang có lượt (phiên Claude tương tác Toàn mở ở `~` là phiên khác, được).
Sẵn sàng **15%** (chấm 11/11, chưa chấm lại). Mốc 1: **TRỄ, ĐỎ**, đóng khi T232 ra video (D-m7-101, DL-337). Mốc 2 (30/11, còn 12 ngày): ĐỎ (748 giờ ước).

## Đang chạy trên .63

- **Lượt 04 DỪNG vì hết hạn mức 5 giờ** của tài khoản Claude (dùng chung với các phiên khác của Toàn; mở lại 12:40). Lượt chạy 08:12–~10:4x (sóng 2 T226 ‖ T233 trên `68c9100`), không commit. Dở ở `~/m7-drive/wave2/`: patch T226, patch T233, `T225-tester` (58 ca tấn công, 13 đỏ), `T225-fix` (dở). T225 đã push và Sheet M7-251 đã ghi Lead Đạt sáng 18/11 → m7.199.
- **Lượt 05 ĐANG CHẠY** từ 12:33 (PID 1093904, `~/m7-drive/p-05.txt` → `o-05.log`; sửa 10:5x: bước 0 kết luận 13 ca đỏ T225 + `T225-fix` trước migration và nhập ảnh; tối đa 2 tác nhân nặng; đọc sổ ở `~/dev/project-control`), D-m7-128: D-m7-119…124 (gộp T223, nối Claude thật + EN_IMAGE_PROMPT, T224 theo C, migration 5b3 trên dev, RU-16 vào T233, nhập 6 ảnh với nguồn AI dựng), rồi T227 → T228 → T229 → T230 khi đủ phụ thuộc; dừng trước mọi lượt Muse thật và báo số lượt cần; bộ đủ cuối lượt; không push.
- Bộ đủ `68c9100` XANH (17/11 17:55–20:53): build, Contract 56, Architecture 1.153, Domain 5.399, GuardCorpus 1.975, StudioWorker 1.835 (89 bỏ qua), Integration 56 namespace 0 hỏng, docs, web. Log `~/m7-drive/full-68c9100/`. Bộ đủ `cf6a954` XANH.
- Stack dev `m7-m7-*` 6/6 healthy. RAM .63 trống 31/38 GB (07:53).

## WP31 (T222…T233)

- Trên origin (`68c9100`): T222 thiết kế + đo Muse (`6d7eb2c`, `68c9100`) · T231 `02b1330` (R1 ĐẠT) · T225 `8dce70a` kho ảnh + nhân vật, có migration 5b3 (R2 ĐẠT, 20 đột biến) · DL-340…343 `b2dab53`.
- Toàn đã chốt, lượt 05 làm: T223 `bfcf956` ok gộp (R3) + Claude thật · T224 `2192d48` theo C.
- Đang làm (lượt 04): T226, T233. Còn: T227 (cần T223, T226, ảnh: đã có), T228 (sau T233), T229 (cần T224), T230, T232 (lượt thật, cần Muse).
- Đo Muse 4/4, đã tiêu 11/13: số giây đúng xin (8–20 giây), nhận ảnh đính làm khung đầu, giữ ngữ cảnh cùng cuộc trò chuyện; clip 720x1280, 24/30 khung/giây, có tiếng → T229 phải chuẩn hoá.
- Câu mở phiên .63 nêu, chưa hỏi Toàn: DL-332 có áp master không, chữ caption DL-O09, cài worker Ubuntu (đề xuất T059).

## 18/11: D-m7-126 (M7-251 T225 về Đang làm, W còn Đạt vì web app chặn rà lại) · D-m7-128 (Toàn đăng nhập lại .63 cùng tài khoản máy Lead 12:32; lượt 05 bật 12:33, thay hẹn giờ D-m7-127) · D-m7-129 (migration 5b4 cùng 5b3 trên DB dev .63) · D-m7-130 (V5 không làm bây giờ: 6 ảnh là ảnh ChatGPT, không người thật; nợ WP29 phương án b) · D-m7-131 (giữ nguồn AI, sửa chữ F08) · D-m7-132 (T226 ok gộp, làm ở lượt 06). Commit .63 chưa push: `3bd7833` T225 sửa sau tester R3 (verifier ĐẠT), `87a2d0d` DL-344…348

## Quyết định 18/11 08:2x (D-m7-118…124, "Oke, cứ theo đề xuất của bạn và tiếp tục nhé")

Push 5 commit: xong 08:28, máy Lead chạy qua ssh trên repo .63 tới đúng `68c9100` · T223 ok gộp · T223 Claude thật + EN_IMAGE_PROMPT · T224 phương án C · migration 5b3 `--approve` chỉ DB dev .63 · RU-16 gộp T233 · ảnh: máy Lead chép 6 PNG (thư mục chỉ có 6, không phải 5) vào `~/dev/m7-input/chao-sam/chao-sam-diem-mach-hat-sen-1…6.png`, sha256 khớp 6/6; đều là ảnh hộp dựng bằng ChatGPT, nhập với nguồn AI. Câu cũ không chặn: m7.164, m7.153–159.

## Việc tay của Toàn

1. Codex: `codex login status` trên .63 trả 0 lúc 07:53 (có vẻ đã đăng nhập; phiên .63 kiểm khi cần gọi thật).
2. Báo phiên m7 khi Anh Tuấn giao máy ảo M7 hoặc máy staging.
3. Sắp tới: duyệt số lượt Muse thật cho T228/T232 (lượt 05 sẽ báo số cần).

## Sheet (18/11 08:1x)

- Ghi 18/11: M7-251 T225 Hoàn thành `8dce70a` + Lead Đạt; M7-257 T231 Lead Đạt; M7-249 T223, M7-250 T224 Chờ review; M7-248 T222 thêm đo Muse. Lead Đạt qua `sheet_lead.mjs`, đọc lại 2/2 (`ra-soat/2026-11-18-sheet/`).
- 09:0x: auditor rà 23 task R1/R2 sau `a6011c4` (đều là tổ tiên `68c9100`, bộ đủ XANH) → ghi Lead Đạt 13 task đủ bằng chứng verifier ĐẠT (M7-049, 064, 066, 067, 070, 074, 086, 091, 093, 244…247), đọc lại 13/13 (`ra-soat/2026-11-18-sheet/dat-13.json`).
- 10 task CHƯA đủ bằng chứng verifier cho bản cuối, giữ nguyên; kiểm bù trên .63 sau khi T232 ra video (D-m7-125): M7-041 T035 (phiên chính tự vá sau vòng 2 CẦN SỬA), M7-075 T069 (verifier kiểm v1, commit là v2: đổi test), M7-087 T081 (test thêm chưa ai xem), M7-088 T082 (vá `IsSafeText` ở `dfa0591`), M7-089 T083 (sửa F1′ không có vòng verifier 3), M7-090 T084 (không verifier), M7-082 T076 (T076b, T076d không verifier), M7-207 T189 (vòng 2 T189a, T189b không verifier), M7-242 T220, M7-243 T221 (không verifier). Sheet M7-041 và nhật ký 12/11 (T081) ghi "verifier ĐẠT" sai so với báo cáo.
- R3 M7-014 T008, M7-019 T013 chờ Toàn. M7-252 T226, M7-259 T233, M7-249/250 ghi khi lượt 04, 05 báo.
- M7-009 (T003 CI) Bị chặn do CI tắt (rủi ro đã nhận).

## Máy và vận hành

- Máy chạy thật M7: máy ảo Ubuntu 22.04 không card (D-m7-099, DL-338); máy staging giống .99; Anh Tuấn chưa giao cả hai.
- .63: máy ảo Hyper-V 10 vCPU, 38 GB; runner CI `may-63` dùng chung. Máy Lead vào bằng `ssv@` địa chỉ .63. Kiểm tách rời dùng clone `--no-local`, không `git worktree`.
- Máy Lead: `_wt/m7/` hơn 70 clone, dọn ở `/cuoi-phien`.
- Mở sau Mốc 1: T066 vòng 3, T076b.2, T076b.4, T076.8, T076.10, `evidence_region` Muse, T088…T090, T044, T065 còn lại, T062b; nợ T085, T190b (tệp phụ đề tạm), ngưỡng ASR 20 kịch bản (Mốc 2).
- Báo cáo tuần: phiên m7 không tự viết (D-m7-090).

Ranh giới: push và Muse thật chỉ theo lời Toàn từng lần; không migration DB dùng chung, không UAT hay production nếu Lead chưa nói rõ. D-m7-067, 069…097, 099…132 vẫn hiệu lực.
