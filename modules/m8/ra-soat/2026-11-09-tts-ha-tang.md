# Rà soát TTS VieNeu, hạ tầng và trạng thái production M8 — 09/11/2026

Nguồn: đọc mã + tài liệu repo `ginsengfood-ivr` tại `b0c557c0` và sổ `modules/m8/`. Không SSH, không kiểm máy thật: phần "đang chạy gì trên .61/.64" lấy theo sổ, CHƯA KIỂM TRÊN MÁY.

## 1. TTS VieNeu chạy thế nào

| Điểm | Thực tế | Nguồn |
|---|---|---|
| Lúc đang gọi khách | VieNeu **không** sinh giọng. Cuộc gọi chỉ phát file WAV có sẵn (quy tắc N1). Cấu hình production có endpoint TTS bị chặn ngay khi khởi động | `src/Ivr.Infrastructure/Speech/RuntimeSynthesisForbiddenTtsProvider.cs:5-34`, `deploy/tts/README.md:5-9` |
| Câu đọc ghép từ đâu | Lời chào, câu cố định, số tiền (ghép từ clip số), hướng dẫn bấm 1/0: **kho clip đọc sẵn** đã duyệt (510 WAV). Riêng **tên khách (tên ngắn)** và **phường/tỉnh giao hàng**: kho tự bổ sung do VieNeu sinh | `src/Ivr.Domain/Speech/FinalConfirmationSpeech.cs:15-31`, `deploy/tts/README.md:24-31,62-63` |
| VieNeu sinh lúc nào | Ngay khi nhận đơn từ M3: cụm tên/địa bàn chưa có trong kho thì xếp hàng; worker (`SpeechPhraseJobHost`) gọi VieNeu, kiểm âm thanh, lưu `<sha256>.wav`. Cụm đã có thì dùng lại cho mọi đơn sau | `deploy/tts/README.md:39-55`, `src/Ivr.Worker/Jobs/SpeechPhraseJobHost.cs` |
| Chưa sinh kịp | Cuộc gọi đầu chờ (không giữ kênh SIM) tối đa 8 s cho tên, 30 s cho địa bàn. Tên chưa kịp → chào không tên. Địa bàn chưa kịp → lỗi kỹ thuật, đơn thử lại sau, không phát nửa câu | `deploy/tts/README.md:56-70` |
| Chạy ở đâu | Container `phrase-tts` trong compose `~/m8` trên **.61**, dùng chung mạng với `worker`, chỉ nghe `127.0.0.1:8090` | `deploy/m8/compose.yml:128-172` |
| Phần cứng | **Chỉ CPU, không cần GPU.** Mô hình VieNeu-TTS-v3-Turbo ONNX int8. Cấu hình 2 CPU / 4 GiB, mỗi lúc 1 yêu cầu | `deploy/tts/models/MODELS.lock`, `compose.yml:131-169`, `deploy/tts/README.md:9` |
| Tốc độ đo được | 1,5–3,3 s mỗi cụm, trung vị 1,9 s (lab S5, 2 CPU/4 GiB) | `deploy/tts/README.md:36-38`, W-0469 |
| Dự phòng | Không có TTS ngoài. Dự phòng duy nhất: kho clip đọc sẵn + bỏ tên khỏi lời chào | `deploy/tts/README.md:62-70,86` |

## 2. Âm thanh tới Asterisk (.64) bằng cách nào

- Thiết kế hai máy (D-m8-011, gói L32/L34): app, PostgreSQL, VieNeu ở .61; Asterisk + `Ivr.MediaReceiver` ở .64. Cụm vừa sinh được **đẩy từ .61 sang .64** qua `media-sync/v1` (mTLS cổng 18089, token media riêng). Asterisk .64 chỉ đọc thư mục `phrases` và bank đã niêm phong. Nguồn: `deploy/media-sync/README.md:1-25`.
- Compose `~/m8` trên .61 hiện vẫn có một Asterisk S5 (mạng host), đọc thẳng volume `phrases`. Đây là khuôn lab một máy cũ. Nguồn: `deploy/m8/compose.yml:203-212`, `deploy/m8/README.md:48`.
- Secret cho đường .61→.64 (media token, TLS, `ari.conf` production) **chưa cấp**, người giữ khoá chưa chốt. Nguồn: `deploy/rollouts/production-window-20261027/secrets-and-access.md:8-11`.

## 3. Vướng mắc hạ tầng

| # | Vướng mắc | Hệ quả | Ai gỡ |
|---|---|---|---|
| 1 | Đường đẩy file .61→.64 chưa chạy với secret production | Asterisk .64 không có file tên/địa bàn → chào không tên hoặc đơn lỗi kỹ thuật | Lead + Anh Tuấn (secret, mTLS, khung bảo trì) |
| 2 | Năng lực VieNeu: 1 luồng, ~1,9 s/cụm ≈ 30 cụm/phút. Đơn mới có cả tên lẫn địa bàn chưa có trong kho ≈ 15 đơn/phút. Địa bàn lặp nhiều nên kho đầy dần sẽ nhẹ hơn | Đợt đơn dồn lúc cao điểm có thể phải chờ | Chưa đo tải thật trên .61 |
| 3 | Phần cứng .61 chưa có số kiểm kê; .61 còn chạy M1–M2 (`~/m12`) | VieNeu (2 CPU) tranh CPU với ops-core, chưa biết dư bao nhiêu | Anh Tuấn kiểm kê; Lead quyết |
| 4 | Pháp lý VieNeu chờ Sếp ký, kho mirror nội bộ chưa cấp (`LEGAL`, `INTERNAL_MIRROR`); image `ivr-tts` production phải dựng lại qua mirror | Cổng G-LEGAL chặn phát hành | Chú/Lead |
| 5 | Duyệt nghe: 15 câu mới chưa nghe, lấy mẫu `sampled-v1` cần bản duyệt mới (CB-107), lời thoại 3 miền chờ duyệt | Cổng G-SPEECH chặn | Chú/Lead |
| 6 | Sao lưu: thiếu kho backup ngoài máy, RPO/RTO | Mất .61 là mất kho cụm đã sinh (sinh lại được, nhưng chậm) | Anh Tuấn |

## 4. M8 đã xong chưa

**Chưa.** Theo tài liệu, M8 chưa chạy production với khách thật:
- `REAL_CUSTOMER_CALL_ALLOWED=NO`, `production_accepted=false` (`modules/m8/TRANG_THAI.md:24`, `deploy/m8/compose.yml:69,107,134`).
- Readiness board nấc 0/4; cả 11 cổng `BLOCKED_EXTERNAL` (`docs/release/readiness-board.md:20-40`, `docs/release/gate-status.yaml:45-100`).
- `production-window-20261027`: "PREPARED / NOT READY TO EXECUTE"; chưa mở trunk MobiFone ngoại mạng (`deploy/rollouts/production-window-20261027/README.md:3-9`).
- .61 vẫn chạy bản S5/current-lan 27/10, chưa cắt sang khuôn `~/m8` (m8.43 chờ Lead); .64 có 3 container current-lan 27/10 (`TONG_QUAN.md:20`, `TRANG_THAI.md:4,43`).
- E2E với M3: E01–E04 "CHƯA TEST M3" (`deploy/rollouts/production-window-20261027/m3-e2e.md:3,24-34`). Sổ M8 không ghi UI IVR đã lên admin M3 (.60); phần đó thuộc phiên m34.
- Sẵn sàng 47% theo thang chung (`modules/m8/SAN_SANG.md`).

Việc còn lại, chia theo người:
- **Lead/phiên m8:** CI xanh (W-0513/0514 vừa push 09/11); cắt .61 sang `~/m8` (m8.43); dựng media-sync .64 (L34); test E01–E10 với M3 (phiên m34).
- **Ngoài:** chữ ký pháp lý VieNeu + mirror (Chú); duyệt nghe lời thoại; MobiFone cấp capacity/ngoại mạng; Anh Tuấn: kiểm kê, quyền, ACL, backup ngoài máy; người giữ khoá production.
