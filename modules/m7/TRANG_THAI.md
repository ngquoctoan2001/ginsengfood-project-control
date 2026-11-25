# Trạng thái — m7

Mốc: 25/11/2026 10:5x (UTC+7, thứ Tư; kiểm .63 chỉ đọc lúc 10:44) · main .63 `c9e732a` (10:41), 21 commit từ 09:00, 2 chưa push (`day-len.sh` đẩy hằng giờ) · **load .63 22–25 trên 10 nhân (quá tải)**: nhiều phiên build cùng lúc và một CI runner khác (dự án Phúc) cùng máy · CI GitLab của M7 giữ tắt.
**Năm phiên Claude trên .63:** phiên chính `9b228a48` (lượt 08, 16 giờ 34 phút, 4 tác nhân: S11, T096, T071, T175; luồng video, nợ, Mốc 2) · phiên phụ UI `e9fe67a7` (từ 09:30) · THUVIEN `065db2d0` (từ 09:45) · SERVER `cb75faea` (từ 09:45) · KHO `88924d85` (giai đoạn 1 xong 10:14, giai đoạn 2 triển khai từ 10:46). Khoá đặc biệt `@dung-stack` khi dựng lại stack. Log `~/m7-drive/o-<TEN>.log`, `vong-lap-<ten>.log`; sổ task `~/m7-drive/trang-thai-task.md`. Tab `claude` tương tác của Toàn (pid 3832018) gắn CÙNG phiên `9b228a48`: Toàn không gõ vào đó khi lượt chạy.
**Luật đang chạy:** D-m7-150 (luồng video THẬT trước, dữ liệu MẪU, qua UI Studio; test hạn chế, push mỗi giờ), D-lead-063/064 (một checkout, khoá tệp, kiểm theo hai mức), D-m7-110 (máy Lead đọc bản ghi, giao lượt qua ssh; không sửa mã M7). UI mở THẲNG `https://192.168.1.63:6700` cho cả LAN (D-m7-156, D-m7-157; DL-370 `f252945`): trình duyệt báo chứng chỉ tự ký; từ 10:03 CA của edge bền (volume `edge_data`, `3b20fec`), xuất chứng chỉ gốc bằng `tools/dev/dev-edge-ca.*`; RU-46 chưa sửa (SERVER giữ khoá RUNBOOK, vá sẵn `B17-ru46-runbook.py`).
Sẵn sàng **15%** (chấm 11/11, chưa chấm lại). **Mốc 1: TRỄ, ĐỎ, đang CHẶN ở m7.273** (đóng khi T232 ra video, D-m7-101, DL-337). Mốc 2 (30/11, còn 5 ngày): ĐỎ; có mã xu hướng (T093, T094, T095, T096 đang), hàng việc Studio (T075), adapter S3 (T175 đang); chương trình 70 phút mới có thiết kế nháp (`4cc72fa`).

## Video thật

- **Video đầu** `SV-20261122-003-1343.mp4`: 93,7 giây, ASR 0,8954 → FAILED; giữ làm bản xem trước, không phát. **Video 2** `SV-20261123-001-1937.mp4` (101,3 giây, ASR 0,934) có bản sao ở `modules/m7/ra-soat/2026-11-25-video/` (đã loại khỏi git) kèm `frame-92s.png`, `contact-8.png`.
- **m7.272 = (a), D-m7-161: XONG phần kỹ thuật.** Lượt `01a20ece` hỏng ở ASR vì DB dev mất dòng `asr.thresholds` (mặc định 0,95); đặt lại ngưỡng tạm dev 0,90; làm lại: lượt 4 `01a210b7-566c-71ee-b776-29cbb98c39d9` SUCCEEDED lúc 10:29: RENDER trùng từng byte bản 2 (sha `63644194…`), ASR 0,9341, **AUTO_CHECK 17/17 ĐẠT** với bộ luật v2 (đứng hình 0, ranh shot lệch tối đa 17 ms, karaoke trung vị 0 và p95 40 ms, -13,5 LUFS); 0 Muse/Claude/Codex; video IN_QA.
- **BLOCKED duyệt người, câu m7.273 cho Toàn:** soát duyệt (dev-approver) thấy cảnh kêu gọi cuối (giây 88–96) có TÚI GIẤY IN RÕ LOGO "Kraft" (nhãn hiệu thật bên thứ ba, không phải bao bì SKU) → QA-V-12 KHÔNG ĐẠT; chưa duyệt, chưa ghi từ chối; ảnh `~/m7-drive/thuc/video2/moc1/kraft-logo-91s-93s.png`. Quan sát thêm: nhân vật nữ khác nhau giữa các shot (áo hoa, áo tím, áo len kem). Checklist QA-V-05 còn ghi "nhãn AI từ khung đầu, đủ ba lớp", trái DL-368: cần bản mới.
- **Muse đã dùng 30 lượt**, hết trần (D-m7-152). Dịch vụ `m7-studio-worker` (user `m7worker`) cài 09:49 khởi động lại mỗi ~6 giây, không dùng được, không dừng được (cần sudo): phiên chính dùng worker kiểu cũ `realrun8`. Bản script sudo MỚI của phiên SERVER (`can-sudo-worker-ubuntu.sh`, bản cũ `.bak-25-11`) sửa việc này.

## Gói việc đang chạy (main .63 `c9e732a`)

| Phiên | Đã xong (SHA) | Đang làm |
|---|---|---|
| Chính | T095 `6b6d7cc`, T028 E1 `58ec2a6`, V4a1 (9 đạt), S9 sửa V4c, T086 gói hết hạn, T093, T075 | T096 xu hướng, T071 đường âm thanh, T175 adapter S3, S11 |
| UI | công cụ chụp ảnh `ui-shot.mjs` `9a3c412`; bố cục trang lượt và header `2c84253`; màn Bảng luồng `/studio/bang-luong` `b714c31`; sửa `c9e732a` (ảnh ở `~/m7-drive/ui/`) | dựng lại `m7-web` (khoá `@container-m7-web`) rồi báo |
| THUVIEN | màn Thư viện `/thu-vien` chỉ đọc `ddb9f82` (EP-249…255, SCR-69, T239…T241, DL-371) | API và web phần còn lại |
| SERVER | S1 CA bền `3b20fec`; S2 x11vnc/noVNC chỉ 127.0.0.1, S3 công cụ vào `/opt/m7/tools`, S5 script sudo một lần `4dd5cc8` | S4 đổi "máy để bàn" → "máy dựng", S6 khoá máy qua API (T057), S7 bảng chạy ở đâu |
| KHO | giai đoạn 1: kế hoạch `ef91172` (`docs/04-sdlc/WP29-KHO-KE-HOACH.md`): 23 task, 130 giờ ước kịp 30/11 (khoảng 36 giờ thật, 3 luồng), 74 giờ ước hoãn; 6 đợt; EP-256…281, SCR-70…74, T242…T246, RU-47 | giai đoạn 2 từ 10:46: đợt 1 nhập ảnh, duyệt, ngừng dùng (xong dự kiến chiều tối 25/11) |

**Kiểm trang đang chạy thật lúc 10:50:** `/studio/bang-luong` và `/thu-vien` trả 200 (web dựng lại 10:45), nhưng: (1) header vẫn hiện 4 chip "chưa rõ" (Cảnh báo, Chờ duyệt, Worker ngoại tuyến, Phiên Muse) kể cả sau khi tải xong: chưa nối dữ liệu; (2) mục "Thư viện" chưa có trong menu chính; (3) API thư viện (`/library/...`) trả 404 vì `m7-api` còn bản 08:42, chưa dựng lại; (4) Bảng luồng có sơ đồ nhưng khung hình và clip chưa có ảnh thu nhỏ (ô tối). Việc cho phiên UI nối tiếp (`p-UI2`) và THUVIEN khi họ xong.

**LỆNH 25/11 ~11:00 (D-m7-163): "tập trung code backend và ui cho xong hết tất cả".** Việc CHƯA CÓ: 110 task, 784 giờ ước (trên 238 task, 1.711 giờ); năng lực đến 30/11 khoảng 400–600 giờ ước, nên làm THEO THỨ TỰ CỨNG và cắt từ đuôi: (0) Mốc 1 (m7.273 làm (a)), (1) L12 xu hướng (T096…T102, T107, T108, T120), (2) chương trình 70 phút L2 (T110…T115) → L3 (T037, T117…T122) → L4 (T124…T130) → L5 (T132…T135), (3) việc Studio T059, T067, T103, T106, T177, T104, T105, T191, (4) đuôi L6 (T136…T143, T155), L7 (T144…T148), L8 (T149…T154), L9 (T156…T163, T178), GĐ3 (T164…T172), GĐ4 (T173, T174). Làn: phiên chính backend, phiên UI2 (11:05) web, KHO WP29; THUVIEN và SERVER sắp kết thúc. Điểm kiểm lại 26/11 buổi trưa.

## Việc tay của Toàn và câu cần quyết

1. **m7.273 (chặn Mốc 1; máy Lead chọn (a) theo đề xuất từ 11:05, D-m7-163, Toàn đổi ý thì bảo):** túi Kraft ở cảnh cuối video 2. (a) 1 lượt Muse làm lại clip cảnh có túi (prompt cấm logo và nhãn hiệu thật), rồi dựng, kiểm lời, kiểm tự động lại, 0 Claude/Codex; (b) chấp nhận như bản xem trước nội bộ, không phát (QA-V-12 ghi không đạt, duyệt có lưu ý). Đề xuất của máy Lead: (a).
2. 13 câu nhỏ ở `~/m7-drive/bao-08.md` (m7.268 chọn lại ngưỡng, EP-244 làm tại chỗ, dấu NA, cảnh khuyến cáo không phải TPBVSK, `script.narration_rules`, …) chưa trình bày; câu mới từ T028 (có tính vế RISK-AI?). KHO K.1…K.12: Lead đã chấp nhận mặc định (D-m7-162; K.1 không mở ảnh người thật, K.3 chỉ chạy thử dọn, K.5 ghép bộ cảm xúc bằng tay).
3. Việc tay: chạy script sudo MỚI `sudo bash ~/m7-drive/can-sudo-worker-ubuntu.sh` (phiên SERVER đã cập nhật: công cụ, noVNC, khoá máy, dịch vụ) rồi `can-sudo-codex-user.sh`, đăng nhập Codex cho `m7codex`, đăng nhập Muse qua đường hầm tới noVNC; duyệt bảng khoá vận hành T237; cài chứng chỉ gốc của edge một lần (hướng dẫn trong `tools/dev/dev-edge-ca.*`) để hết cảnh báo.
4. Giao lượt .63: không mở tiến trình thứ hai trên phiên `9b228a48`; phiên phụ nối tiếp bằng `~/m7-drive/chay-tiep.sh <TEN> <p-TEN2.txt>` (đọc mã phiên trong `<TEN>.phien`).

## Sheet, máy và vận hành

- Sheet (ghi ở máy Lead, .63 không có `sheet.json`): cập nhật lần cuối 19/11; **chưa ghi** các commit từ 21/11 (T227…T238, T088…T090, T093…T096, T075, T028, EP-192…195, 2 video): ghi theo `trang-thai-task.md` khi Toàn bảo.
- Máy chạy thật M7 = .63 (máy ảo Ubuntu, 10 vCPU, 38 GB; chạy chung runner CI của dự án khác). Máy staging giống .99 do Anh Tuấn nhân bản, chưa giao: không làm gì ngoài .63.
- Mở sau Mốc 1: T091, T074 còn lại, T044, T065 còn lại + `login_marker`, T066 vòng 3, T076b.2/.4, T076.8, T076.10, T062b, ngưỡng ASR 20 kịch bản; kiểm bù 10 task (D-m7-125) và ba cổng kiểm độc lập; WP29 phần hoãn 74 giờ ước (ảnh người thật, bộ cảm xúc Codex tự tạo, gắn nhãn tự động, Muse nhiều tài khoản, adapter API ảnh có phí, giọng theo nhân vật).
- Báo cáo tuần: phiên m7 không tự viết (D-m7-090); phần M7 của báo cáo 14→24/11 đã trả phiên M8.

Ranh giới: push chỉ theo lời Toàn từng lần; Muse thật không còn trần (D-m7-152): dữ liệu MẪU, không phát; không migration DB dùng chung, không UAT hay production nếu Lead chưa nói rõ. D-m7-067, 069…097, 099…162 vẫn hiệu lực (D-m7-152 thay phần trần Muse của các quyết định cũ).
