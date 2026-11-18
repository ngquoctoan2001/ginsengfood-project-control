# T190 chạy lại khi .63 lên (kế hoạch soạn sẵn, 15/11/2026 07:2x)

Trạng thái: ĐANG LÀM trên .63 từ 16/11 10:14 (.63 lên lại, hết gác: D-m7-100; gác 09:40–10:22 theo D-m7-098). Toàn chốt 15/11 07:20 "Theo đề xuất hết": a = A, b = có, c = có, d = C (D-m7-091…094) · Rủi ro: R2 (a, b), R1 (c), R3 phần gọi Muse thật (d) · Chế độ: S, `main` trên .63, chỉ phiên "M7 trên .63" sửa mã (D-m7-083) · Mốc: Mốc 1 (đã trễ 15/11)
Nguồn: `docs/04-sdlc/tasks/M7-T190.md` (origin `765eaa6`), mục Lỗi 3, 7, 8 và Đề xuất. Sheet: T190 = M7-208.

## Mục tiêu và tiêu chí đạt

Một lượt T190 `SUCCEEDED` trên .63: video MẪU 95–120 giây từ 7 clip Muse thật, giọng VieNeu, kiểm lời faster-whisper qua ngưỡng 0,90 máy dev (DL-328), AUTO_CHECK đạt, Toàn duyệt (lời duyệt của chính Toàn), gói xuất có nhãn AI và sha256 (T085). Bằng chứng: video, sha256, manifest gói, kịch bản đã duyệt, bảng thời gian từng bước, chép về `modules/m7/ra-soat/2026-11-14-t190/` ở máy Lead.

## Bước 0 · .63 vừa lên (phiên .63, ~30–45 phút)

1. Toàn: `tmux ls` trên .63; còn phiên `claude` CLI M7 trong tmux `m7` thì gõ `/exit` (chỉ còn phiên Desktop "M7 trên .63").
2. `git status` trên .63: sạch, bằng `765eaa6`; không có tệp dở lạ.
3. Dựng lại: `dev-up.ps1` (7 dịch vụ `healthy`, `dev-smoke.ps1` 15/15), `dev-display.ps1 -Start`, worker; `muse-probe` chỉ đọc. Mất đăng nhập Muse thì Toàn đăng nhập lại qua noVNC (`-Login`).
4. Runner CI `may-63` cùng máy: giữ `-m:4`, không chạy hai lệnh nặng M7 cùng lúc với job CI nặng.

## Bước 1 · a ‖ b song song, c do phiên chính (khoảng 4–6 giờ thật gồm verifier)

| Việc | Nội dung | Tệp | Ước | Kiểm |
|---|---|---|---|---|
| a (m7.T190.a A) | `asr_worker.py` nhận dạng theo khung từng câu của `narration_timing.json` (`clip_timestamps`), đổi phiên bản bộ chấm; tái hiện ca câu 17 bằng chính `narration.wav` của lượt thật; đo lại điểm trên kịch bản mẫu T221, T190 | worker Python (`tools/studio-python/…`), test Python; phía máy chủ chỉ khi đổi phiên bản bộ chấm | 4–6 giờ ước | coder test đỏ trước; verifier độc lập; đột biến ≤ 20 |
| b (m7.T190.b) | Tái hiện `GH_ASSET_METADATA_MISSING` khi làm lại bước sau RENDER bằng EP-083 (test Integration), tìm điều kiện chặn trong `AssetRegistrar`, sửa | `Studio/**` .NET, test Integration | 3–4 giờ ước | như trên; Integration chỉ lớp của task |
| c (m7.T190.c) | Ghi yêu cầu ffmpeg từ 8.1 vào RU-45, `check_dev_env.py` báo lỗi khi thấp hơn | docs, `tools/devcheck/` | 1 giờ ước | `unittest` devcheck, `check_docs.py` |

a và b tách tệp (Python worker và .NET Studio) nên chạy hai làn; máy .63 10 nhân, 38 GB đủ hai lệnh nặng. Commit từng task khi verifier ĐẠT (R2, D-m7-053); push gom một lần khi Toàn nói.

## Bước 2 · chạy lại T190 (theo m7.T190.d)

- **Đề xuất C:** sau a + b, làm lại từ `ASR_VERIFY` trên lượt cũ `SV-20261114-006` (bản dựng 98,9 giây đã có) → AUTO_CHECK → Toàn xem và duyệt → xuất gói. 0 lượt Muse, khoảng 15–30 phút.
- Nếu lượt cũ không làm lại được (lượt FAILED không cho EP-083, hay bản dựng cũ không còn): DỪNG, hỏi Toàn trước (D-m7-094). Chạy mới từ đầu = 7 lượt Muse, tổng 14, quá trần 10 của DL-327. Thời gian lượt mới khoảng 25–35 phút (7 clip ~10 phút, dựng ~2 phút, kiểm lời ~1,5 phút).
- Toàn cần có mặt ở bước duyệt (lời duyệt là của Toàn) và nếu Muse đòi đăng nhập lại.

## Ước tổng và mốc

.63 lên lúc X (Toàn báo) → bước 0 xong X + 45 phút → a, b, c xong X + 5–6 giờ → T190 qua X + 6–7 giờ. Khi chạy lại đo luôn RAM đỉnh cả stack: máy chạy thật M7 Toàn xin 16/11 chỉ có RAM ≥ 16 GB, không card (D-m7-099). Sau đó: bộ kiểm đủ trên SHA cuối ở .63 (vài giờ, chạy nền), ghi Sheet, chấm lại `SAN_SANG.md`.

## Rủi ro

- Bộ chấm mới cho điểm khác hẳn: ngưỡng 0,90 có thể phải đo lại (DL-328 cho đo lại ở Mốc 2); đổi ngưỡng cần quyết định mới.
- Làm lại lượt FAILED có thể bị chặn bởi luật trạng thái của lượt (chưa kiểm): rơi về chạy mới, tốn 7 lượt Muse.
- .63 chết lại: chưa rõ nguyên nhân 20:14 14/11; mọi việc mã M7, CI ops-core và ivr cùng đứng. Bằng chứng T190 chỉ ở .63 → chép về máy Lead ngay khi lên.
- Muse đổi giao diện hay hết phiên sau khởi động lại: `muse-probe` trước, Toàn đăng nhập lại.
- TTS không tất định: lượt mới có thể qua hay trượt khác lượt cũ.

## Diễn biến 16/11

- 16/11 tối (phiên .63 báo qua phiên lead): a, b `4e86eb3` verifier R2 ĐẠT vòng 2; d xong: làm lại `SV-20261114-006` từ RENDER/ASR (`a99ffa2`), 0 lượt Muse, ASR 0,906, AUTO_CHECK PASS 13/13, video 98,9 giây chờ Toàn duyệt QA. c chưa thấy báo. Cả 3 commit .63 chưa push.
- 16/11 20:3x phiên máy Lead chép bằng chứng (chỉ đọc .63, D-m7-102) về `ra-soat/2026-11-14-t190/` và `ra-soat/2026-11-16-t190-redo/`, mã băm khớp; video lượt làm lại trùng mã băm lượt 14/11. AUTO_CHECK lượt làm lại chạy ffprobe 6.1.1 của hệ thống → thuộc c.
- 16/11 20:37 D-m7-101: Mốc 1 đóng ở WP31 (T222), không đóng ở T190. Bước kế: Toàn duyệt QA video, phiên .63 làm c + DL dời WP29 (D-m7-104) cùng commit, xuất gói.
