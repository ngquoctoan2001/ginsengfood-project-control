# G-11b — Thiết kế hiệu lực thật cho giọng và tốc độ đọc theo vùng (M8)

Lập 26/11/2026 (subagent thiết kế, chỉ đọc). Mã: `C:\Projects\ginsengfood-ivr` `main` `3a2518dc`; `tệp:dòng` tính từ gốc repo đó. Nối tiếp `giong-doc-thiet-ke.md` (G-01), W-0566, W-0567. Toàn chốt m8.130 = B (D-m8-161): làm thật ngay, phạm vi giọng vẫn là **ba giọng đã duyệt**. Chưa chạy gì (không build, test, container, ssh); `docker images` chỉ đọc danh sách. Mã W do phiên chính đặt (đề nghị W-0579…W-0585).

## 0. Kết luận và phát hiện đổi phạm vi

| # | Phát hiện (đo bằng mã) | Hệ quả thiết kế |
|---|---|---|
| 1 | Engine VieNeu **không có tham số tốc độ**: `infer(...)` chỉ có nhiệt độ, top-k, top-p, phạt lặp (`third_party/vieneu-tts/src/vieneu/_v3_turbo_engine/onnx_runtime_lite.py:373-379`); sidecar từ chối tốc độ khác `voices.json` (`deploy/tts/shim/backend.py:176-177`) | Tốc độ làm bằng **mã M8**: co giãn thời gian giữ cao độ (WSOLA thuần C#) lên clip WAV đã dựng ở 1.00. Không sửa `backend.py`/`voices.json` (ghim hash) |
| 2 | **Hoán đổi giọng đang bế tắc.** Chỉ có 3 giọng đã duyệt (sidecar cứng 3: `backend.py:141`), cả 3 đang là giọng của 3 vùng. `ux_ivr_voice_profiles_one_active_per_voice` (`VoiceModel.cs:25,129-131`) và kiểm `Distinct` (`VoiceProfileRules.cs:161-176`, `DbVoiceProfileSource.cs:310-322`) buộc ba vùng ba giọng khác nhau ⇒ vùng X muốn giọng Y thì vùng đang dùng Y phải đổi trước, mà vùng đó cũng bị chặn y như vậy | **CẦN TOÀN m8.148.** Đề xuất bỏ ràng buộc "khác nhau" cho hồ sơ (§C); nếu giữ thì phải kích hoạt nguyên tử cả bộ (đổi YAML draft.51) |
| 3 | Bank là MỘT manifest, đúng 3 giọng, mỗi vùng một giọng (`PrerenderedSpeechCatalog.cs:127,137,142-146`), cả công cụ Node cũng ép 3 (`speech-clip-bank-lib.mjs:130-137`) | Cần **bank schema 3**: đủ 9 cặp (3 vùng × 3 giọng), một manifest, ghim hash mới (§C) |
| 4 | Mọi clip bank/cụm hiện là bản 1.00; Asterisk chỉ phát **tệp** (`sound:<tiền tố>/<sha256>`, `PrerenderedSpeechCatalog.cs:215`) | Bản co giãn là **tệp dẫn xuất** tạo sẵn lúc làm nóng/kích hoạt, lưu cạnh cụm (§B) |
| 5 | Máy Lead: 56 ảnh docker, **không có ảnh `ivr-*`/VieNeu**; `deploy/tts/models/` chỉ có `MODELS.lock` (15.724 B), không có mô hình | Dựng clip giọng mới bằng sidecar thật **không làm được đêm nay trên máy Lead** (§C) |
| 6 | Phần C# (co giãn, bank 3, bản dẫn xuất, luồng gọi, luật, nghe thử) làm trọn và kiểm được trên máy Lead bằng WAV dựng bằng mã | 5 gói làm đêm nay, 2 gói cần máy thật/Toàn (§E) |

## A. Bank hiện nay (câu 1)

| Điểm | Sự thật · tệp:dòng |
|---|---|
| Công cụ dựng | `deploy/ci/scripts/render-speech-clips.mjs`: Node, gọi sidecar loopback `/synthesize` (`:40-62`), mỗi câu một lượt, cắt lặng `trimJoinEdges` + `finishFluentClip`, nối câu cách 200 ms (`:93-105`). Kế hoạch clip từ `tools/dev/ClipPlan` (C#, `README.md:28-35`); duyệt `approve-speech-clips.mjs`; cổng `speech-clip-bank-gate.mjs`; đo `measure-speech-bank.mjs`; QA `speech-clip-qa.mjs`. Kiểm/chuyển bank: `tools/Ivr.Ops/BankDeployment.cs:20-76` (`bank-check`, `bank-stage`) |
| Manifest | JSON schema 2, khoá snake_case: `voices[3]` = `{region, voice_id, speaking_rate, clips[]}`; clip = `{clip_id, text, text_hash, kind, audio_sha256, duration_samples, media_file}` (`PrerenderedSpeechCatalog.cs:32-66,116-117`). `approval.bank_sha256` = `ComputeBankHash` (`:288-301`, bản JS `speech-clip-bank-lib.mjs:96-105`); `SHA256SUMS` ghim mọi WAV + manifest (`ClipPlan/README.md:74`) |
| Bao nhiêu clip | **170 clip mỗi giọng, 510 cho 3 giọng** (bank mẫu owner W-0457: `docs/evidence/W-0457/README.md:43`; công thức 165 + 3×tên + 2×địa bàn, trần 1.000/giọng: `ClipPlan/README.md:86`). Danh sách clip khác nhau theo **vùng** vì số đọc theo vùng (`PrerenderedSpeechPlan.cs:68-69,89`), không theo giọng |
| Độ dài/dung lượng | WAV 8 kHz PCM16 mono, đầu 44 byte (`:303-321`); 11.297.320 byte / 510 clip ≈ 22 KB/clip ≈ 1,4 s ≈ 3,8 MB/giọng; manifest 233.446 B (`W-0457/README.md:47`). Trần: manifest 2 MiB (`:109`), ConfigMap 1 MiB, media 128 MiB (`ClipPlan/README.md:106`) |
| Nằm ở đâu | **Không nằm trong repo** (repo chỉ có số đo `docs/evidence/W-0457/`). Trên .99: `/data/ginsengfood-ivr/du-lieu/bank` gắn chỉ đọc vào api `/clip-bank` (`deploy/m8/compose.yml:73`), worker (`:114`), Asterisk `ivr-clips` (`:221`). Bank thật trên .99 có đúng là bank mẫu 510 clip hay không: **CHƯA XÁC MINH** (cần `bank-check` ở .99) |
| Ghim hash | Cấu hình `Ivr:Speech:Tts:Prerendered` `{ManifestPath, ManifestSha256, MediaImageDigest, MediaReferencePrefix}` (`:13-21`, kiểm `:102-111`); từng WAV kiểm sha256 + dấu RIFF (`VerifyWave :303-321`); chế độ REMOTE_VM thêm ghim `BankManifestSha256` + MediaReceiver `SealBank` (`MediaReplicationOptions.cs:31-35`). Giá trị thật trên .99: ngoài repo, không xác minh |
| Ép khớp (vùng, giọng, tốc độ) | `PrerenderedSpeechCatalog.cs:127` đúng 3 giọng · `:137` 3 vùng khác nhau · `:142-146` giọng = giọng cấu hình của vùng, tốc độ = tốc độ cấu hình · `:163` hash · tra `(vùng, giọng, clip)` ở `:211` (tốc độ **không** nằm trong khoá, chỉ ép lúc nạp) |
| Cụm kho (tên, địa bàn) | `ivr_speech_phrase_clips` PK `(region, voice_id, clip_id)` (`SpeechPhraseStore.cs:123,292`), WAV `<sha256>.wav` ở volume `phrases` (worker ghi `compose.yml:115`; API/Asterisk đọc `:74,222`). Worker gọi sidecar với `work.VoiceId` của hàng nhưng tốc độ lấy từ cấu hình vùng (`SpeechPhraseRendering.cs:168-171,215-225`) |

## B. Tốc độ có hiệu lực thật (câu 2)

**B1. Phương án chính: WSOLA thuần C#** (`Ivr.Domain`, không thêm gói NuGet). Khung 24 ms (192 mẫu), bước ra 12 ms, tìm trong ±8 ms, cửa sổ Hann làm tròn Q15, tương quan chuẩn hoá bằng số nguyên (int64) để **kết quả giống hệt trên mọi máy** (Windows dev và Linux .99; tránh `Math.Sin/Cos` ở lúc chạy). Tốc độ r: 1.00 = trả nguyên bản; độ dài ra = độ dài vào / r. Độ phức tạp ≈ 260 phép nhân-cộng/mẫu ra ⇒ clip 4 s ≈ 10 ms; cả bộ ≈ 4.000 clip ≈ 1 phút một luồng. Bản chất: cắt-ghép đoạn sóng gốc (không dựng lại tiếng) nên **cao độ giữ nguyên**.

| Lựa chọn khác | Vì sao loại |
|---|---|
| SoundTouch / SoundTouch.Net | LGPL-2.1 (nối tĩnh vào ảnh độc quyền cần xét giấy phép), thêm gói/native |
| Rubber Band, SoX, Praat | GPL hoặc thương mại |
| ffmpeg `atempo` | binary ngoài, LGPL/GPL, ảnh worker không có, khó ghim |
| PSOLA | cần dò cao độ, dễ vỡ với giọng nữ 8 kHz; mã nhiều hơn, lợi ít |
| Vocoder pha | mờ phụ âm, nặng CPU |
| Sửa sidecar cho nhận tốc độ | bị cấm (ghim hash) **và** vô ích: engine không có tham số tốc độ (§0 #1) |

**B2. Áp ở đâu**

| Phương án | Kết luận |
|---|---|
| Lúc phát (mỗi cuộc, tệp tạm) | Loại: Asterisk cần tệp; REMOTE_VM phải nhân bản và chờ xác nhận (`MediaReplicaRuntime.cs:100-116`); tệp rác; không nghe duyệt trước được |
| Worker dựng cụm, lưu thay bản 1.00 | Loại: mất nguồn 1.00, đổi/khôi phục tốc độ = dựng lại bằng sidecar (≈ 1,9 s/cụm); rollback vô nghĩa; xoá dữ liệu cá nhân phức tạp |
| Bank nhiều tốc độ (9 mức × bank) | Loại: media ×9, mỗi mức một manifest phải ghim + nghe duyệt |
| **Bản dẫn xuất (clip, tốc độ) lưu cạnh nguồn, tạo lúc làm nóng/kích hoạt và khi cụm mới READY** | **Chọn.** Nguồn 1.00 giữ nguyên; đổi tốc độ = chạy lại bộ co giãn (giây, không cần sidecar); nghe duyệt và rollback được |

**B3. Lưu, khoá, dọn.** Bảng mới `ivr_voice_clip_variants` (migration chỉ thêm), PK `(region, voice_id, clip_id, rate)`: `source_kind` `BANK|STORE`, `source_sha256` (WAV 1.00 đã dùng để dẫn xuất), `bank_manifest_sha256` (chỉ hàng BANK), `algo` (`wsola-v1`), `audio_sha256`, `duration_samples` (1..2.400.000), `rate numeric(4,2)` CHECK trong tập hợp lệ và ≠ 1.00, `created_at`, `last_used_at`. WAV `<audio_sha256>.wav` ghi vào **volume `phrases`** (worker ghi, API/Asterisk đọc; ghi bằng `SpeechPhraseRenderRuntime.WriteMedia`, `SpeechPhraseRendering.cs:239-269`), tham chiếu `sound:ivr-phrases/<sha256>`, nhân bản REMOTE_VM bằng `MediaReplicaJournal.PublishAsync` (`MediaReplicaJournal.cs:49`) trong cùng giao dịch ghi hàng; không ghi vào thư mục bank (chỉ đọc, ghim). Hàng **hợp lệ chỉ khi** `source_sha256` = hash nguồn hiện tại (nguồn dựng lại ⇒ bản dẫn xuất cũ bị bỏ qua, dẫn xuất lại). Xoá: (a) hàng STORE đi theo nguồn: hai chỗ xoá hàng cụm của `SpeechPhraseRetention.cs` (`PurgeExpiredAsync :135`, `DeleteAsync` theo DSAR `:188`; `tools/Ivr.Dsar` không đụng cụm) phải xoá hàng dẫn xuất + đưa hash vào hàng đợi xoá media cùng giao dịch (`SpeechPhraseMediaFence.EnqueueAsync`); (b) tốc độ không còn hồ sơ ACTIVE/DRAFT dùng quá 30 ngày thì dọn. Giữ nguồn 1.00 nên **không thêm cột `render_rate`** vào `ivr_speech_phrase_clips` (PK không đổi được, `ON CONFLICT` ở `SpeechPhraseStore.cs:292`; hàng cụm luôn là bản đã duyệt 1.00).

**B4. Chi phí (ước, chưa đo).** CPU: ≈ 1 phút/bộ tốc độ (không đáng kể so với sidecar). Dung lượng mỗi (vùng, giọng, tốc độ): bank ≈ 3,8 MB + cụm giao hàng 854–1.368 × ≈ 50 KB (2,5–4 s ở 16 KB/s theo `deploy/tts/README.md:37-38`) ≈ 45–70 MB; ba vùng một tốc độ ≈ 175 MB; giữ ≤ 2 tốc độ ⇒ < 400 MB. Cụm tên (lời chào) co giãn theo nhu cầu, xoá cùng nguồn. Cụm mới READY sau khi kích hoạt: bộ dẫn xuất quét mỗi 1 s, thêm ≈ 0,1 s ⇒ nằm trong `DispatchWaitMilliseconds` 4 s (`SpeechPhraseOptions.cs:66`) khi hàng đợi rảnh.

**B5. Ảnh hưởng từng thành phần**

| Thành phần | Thay đổi |
|---|---|
| `PrerenderedSpeechCatalog` | Khoá nguồn **không đổi** `(vùng, giọng, clip)`. `Render` nhận thêm bảng dẫn xuất `(clip → sha, mẫu)` do luồng gọi nạp; khi `voice.SpeakingRate` ≠ tốc độ gốc của giọng thì mọi clip lấy từ bảng đó, **thiếu = `TTS_CLIP_NOT_RENDERED` (không bao giờ rơi về 1.00 lặng lẽ)**; bằng tốc độ gốc thì chạy đúng như hôm nay (từng byte). Nạp (`Load`) sửa riêng ở §C |
| `SpeechPhraseResolver.PrepareForPlaybackAsync` (`:132-212`) | Sau `GetReadyAsync`, thay hàng nguồn bằng hàng dẫn xuất đúng tốc độ; thiếu bản dẫn xuất = coi như chưa sẵn sàng (xin dựng + chờ như cụm chưa READY); thêm `ISpeechPhraseStore.GetReadyVariantsAsync` |
| `RegionalVoiceMap.Resolve` (`:105-108`) / `DbVoiceProfileSource` | Không đổi: `profile.Rate` đã là `SpeakingRate` chọn. `Judge` (`DbVoiceProfileSource.cs:291-299`): kiểm tốc độ đổi từ "= đã duyệt" sang "trong tập hợp lệ"; thêm lý do bỏ hàng `variants_missing` khi bản dẫn xuất BANK không đủ đếm |
| `SpeechPhraseRenderRuntime.SpeakingRateFor` (`:215-225`) | Luôn gọi sidecar ở **tốc độ gốc của giọng** (1.00), theo giọng chứ không theo vùng |
| `VoiceProfileRules` (`:74-75,104-109,161-176`) | Thêm `TempoRules`: tập tốc độ hợp lệ; `Rate` = trong tập; `Bank` = bank giữ (vùng, giọng, **tốc độ gốc**) |
| `readiness` (`VoiceReadiness.cs:132-146`) | **Không thêm trường** (giữ YAML): `rate` = trong tập; `bank` = bank giữ cặp **và** đủ bản dẫn xuất BANK (số hàng = `bank.clips` ở đúng `bank_manifest_sha256`); `phrases` = `ready ≥ needed` với `ready` chỉ đếm cụm READY, không REJECTED, **có bản dẫn xuất ở tốc độ**; chi tiết thiếu nằm trong `details.variants_missing` (map chuỗi) của 409 |
| `DispatchedVoice` (`DispatchedVoice.cs:20-24`) | Thêm `SpeakingRate`; cột `ivr_call_attempts.voice_speaking_rate numeric(4,2) NULL` (thêm cột rỗng, hàng cũ = 1.00); `SpeechSynthesisService.cs:170-173` ghi tốc độ thật đã phát. **Không lộ ra API** ⇒ YAML không đổi |
| Xem trước ở intake (`PrerenderedSpeechBank.Validate`) | Không chờ bản dẫn xuất: ước độ dài = mẫu nguồn / r để kiểm trần danh sách phát; thiếu bản dẫn xuất chỉ bị chặn lúc quay (`TTS_PHRASE_NOT_READY`, kỹ thuật, thử lại) |
| Độ dài cuộc gọi | Danh sách phát ×1/r: 0.80 ⇒ ×1,25 (cuộc Nam 22 s ≈ 27,5 s; clip phụ dài nhất 6,18 s ≈ 7,7 s < `SentenceLimit` 12 s, `CallFollowUps.cs:41`; trần `RenderedAudio.cs:109-116` còn xa). `KeyPromptTiming` đọc `audio.Duration` nên tự đúng. **Cước/giây trả lời tăng ≈ 25 % ở 0.80** (liên quan trần `max_answered_seconds_per_day`) |

**B6. Tập tốc độ hợp lệ: 0.80–1.20, bước 0.05 (9 mức; 1.00 = nguyên bản).** Lý do giới hạn: ngoài ±20 % WSOLA bắt đầu lặp/mất đoạn nghe thấy được (§D) và số tiền là nội dung nghe sai gây hại (xác nhận nhầm đơn). Luật: `rate*20` là số nguyên, 0.80 ≤ r ≤ 1.20, hai số lẻ (khớp cột `numeric(4,2)` và mẫu YAML `^[0-2]\.[0-9]{2}$`). Khuyến nghị vận hành: bật thật trong 0.90–1.10 cho tới khi Toàn nghe số tiền ở hai mép.

**B7. Rollback (ba lớp).** (1) `Ivr:Voice:ProfileSource=OPTIONS` (nạp lại JSON, tức thì, không khởi động lại) ⇒ giọng và tốc độ cấu hình (1.00, bank gốc); (2) `:rollback` về hồ sơ trước, bản dẫn xuất của tốc độ cũ còn 30 ngày nên `readiness` đạt ngay; (3) mất bản dẫn xuất BANK ⇒ `Judge` bỏ hàng (`variants_missing`), vùng quay về cấu hình (an toàn theo cấu trúc, như `not_in_bank`).

## C. Đổi giọng thật (câu 3)

**C1. Điều kiện cần.** (vùng X, giọng Y) hiện KHÔNG có clip: bank chỉ có giọng gốc của vùng (§A). Cần (i) bank 9 cặp, (ii) cụm giao hàng của X dựng lại dưới giọng Y, (iii) hoán đổi không bị chặn (§0 #2).

**C2. Bank schema 3 (9 cặp).**
- `PrerenderedSpeechCatalog.Load` (`:127,137,142-146`): schema 3 nhận 3–9 phần tử `voices`, cặp `(region, voice_id)` không trùng; giọng ∈ ba giọng cấu hình, tốc độ = tốc độ cấu hình của giọng đó; **phải có** bộ ba cấu hình của từng vùng (để cấu hình mặc định luôn chạy); từ vựng suy từ `voices[0]` (`:129-133`) vẫn đúng vì mỗi cặp phải khớp danh sách clip của vùng (`:147-148`). Schema 1/2 giữ nguyên (bank cũ vẫn nạp được).
- `ComputeBankHash` (`:295`): thêm `ThenBy(VoiceId)` (không đổi hash bank cũ vì mỗi vùng chỉ một giọng); sửa cặp JS `speech-clip-bank-lib.mjs:96-105` và `validateBank :123-137`; phải có test đối chiếu C# ↔ JS cùng manifest.
- `IVoiceBankCoverageReader.cs:62-85` đã đọc danh sách cặp tự do ⇒ không sửa.
- Công cụ dựng: `render-speech-clips.mjs` thêm chế độ `--pairs` (mặc định 9 cặp) dùng đúng hàm hậu xử lý hiện có (cùng dây chuyền, không viết lại); `approve`, `gate`, `measure`, `qa`, selftest nhận schema 3. Giọng ∈ tập `selections` của bản duyệt giọng của Toàn.
- Quy mô: 9 × 170 = 1.530 clip ≈ 34 MB, manifest ≈ 0,7 MB: vừa trần 1 MiB ConfigMap và 128 MiB media (nếu bank thật đúng là bank mẫu).
- **Giờ máy:** bản dựng W-0457 chạy 04:12:53–04:31:36 cho 564 lượt (`docs/evidence/W-0457/render-summary.json:13,206-207`) ≈ 2,0 s/lượt (2 CPU/4 GiB, một lượt một lúc) ⇒ ≈ 6,2 phút/cặp, **6 cặp mới ≈ 37 phút** (một lần). Sidecar sampled-v1 cho kết quả giống từng byte giữa các máy cùng ảnh (`deploy/tts/README.md:35-36`, W-0469) nên bank cũ giữ nguyên byte, chỉ thêm 6 cặp.

**C3. Cụm giao hàng (kho).** Đổi giọng vùng X ⇒ dựng lại **toàn bộ cụm DELIVERY của X** (khoá `(X, Y, clip_id)`; `:warm` của W-0567 đã sao chép hàng thiếu để worker dựng nền): Bắc 1.368, Trung 1.096, Nam 854 (`deploy/tts/lam-nong/README.md:36-37`). Trung vị 1,9 s/cụm: **Bắc ≈ 43 phút, Trung ≈ 35, Nam ≈ 27; cả ba vùng ≈ 1,75 giờ** (khoảng 1,4–3,0 giờ). Cụm lời chào (tên khách) không làm nóng trước: dựng theo nhu cầu như hôm nay (lần đầu mất tên trong lời chào, chờ ≤ 8 s, `SpeechPhraseOptions.cs:75`). Sau khi dựng xong, bộ dẫn xuất tạo bản ở tốc độ đã chọn (≈ 1 phút). Chưa bắt buộc làm nóng trước mọi cặp (≈ 3,7 giờ nữa cho 6 cặp): chỉ làm cho cặp Toàn chọn.

**C4. Làm ở đâu.**

| Việc | Máy Lead (đêm nay) | Cần .99/Toàn/Phúc |
|---|---|---|
| Mã C# + Node, test bằng WAV/bank dựng bằng mã, Testcontainers PostgreSQL (`postgres:16-alpine` có sẵn) | Trọn vẹn | — |
| Dựng 6 cặp bank thật | Không: thiếu ảnh sidecar và mô hình. Có thể dựng ảnh từ `deploy/tts/Dockerfile.tts` và tải 211 MB mô hình ghim bằng `scripts/fetch-model-nonprod.py` (mạng ra ngoài, cần Toàn cho phép), nhưng ảnh khác digest ảnh .99 thì **không bảo đảm giống byte** bank cũ | **Đề xuất: .99** với ảnh `ivr-tts` đang chạy + `du-lieu/models` (Phúc/Toàn chạy công cụ trong mạng của worker, lúc hàng đợi cụm rảnh) |
| Nghe duyệt bank mới | — | Toàn (chỉ phần mới: 6 cặp; hồ sơ nghe ghi tham chiếu + hash) |
| Chuyển bank mới + đổi `ManifestSha256` (api, worker, Asterisk; REMOTE_VM thêm ghim + `SealBank`) | — | Toàn/Phúc, theo `bank-stage` |
| Làm nóng cụm, bật `ProfileSource=STORE`, kích hoạt hồ sơ | — | Toàn/Phúc |

**C5. Pháp lý.** `MODELS.lock` `legal_gate.status=PENDING_SEP_SIGNATURE`, `production_activation_allowed:false` (X-03). Cùng mô hình, cùng ba giọng đã nghe: không phát sinh việc pháp lý mới; chỉ **chặn bật production** (cờ `STORE` + hồ sơ ở .99 thật), không chặn dựng và thử ở dev/lab.

**C6. (ĐÃ THAY 26/11 bởi D-m8-162: Toàn chốt m8.148 = B, GIỮ ràng buộc ba vùng ba giọng khác nhau; cần kích hoạt nguyên tử cả bộ + tập giọng cấu hình được; đoạn dưới là đề xuất A không dùng.)** Bỏ ràng buộc "khác nhau" (đề xuất của m8.148). Migration mới bỏ chỉ mục `ux_ivr_voice_profiles_one_active_per_voice` (không phá triển khai cuốn chiếu: bản cũ không dựa vào nó); `VoiceProfileRules.Evaluate`/`DbVoiceProfileSource.Judge` bỏ `Distinct` khỏi điều kiện (giữ chỉ mục theo vùng). Khoá catalog `(vùng, giọng, clip)` đã cho phép một giọng ở nhiều vùng. `TtsProviderOptionsValidator` (cấu hình) giữ nguyên. `VoiceMigrationTests` cấm Drop nên cần ca riêng cho migration này.

## D. Chất lượng và rủi ro (câu 4, vùng Nguy hiểm: lời nói với khách)

| Rủi ro | Biện pháp |
|---|---|
| Méo âm ở 0.80 (kéo dài ×1,25) | Đoạn bị lặp nghe như vang nhẹ, phụ âm nổ ("tờ", "cờ") có thể nghe hai lần; băng hẹp 8 kHz che bớt. Test đo tự động trên tín hiệu mô phỏng (cao độ lệch ≤ 2 %, độ dài lệch ≤ 0,5 % + một khung, RMS ±1,5 dB, không vỡ tiếng) rồi **Toàn nghe** |
| Méo âm ở 1.20 (rút ngắn ×0,83) | Bỏ ≈ 17 % sóng: phụ âm ngắn và âm đầu ("ba/tám", "trăm") có thể mất ⇒ rủi ro nghe sai số tiền. Là lý do giới hạn ±20 %, khuyến nghị 0.90–1.10, và Toàn nghe số tiền ở hai mép trước khi bật |
| Nghe duyệt TRƯỚC khi kích hoạt | `POST /voice-previews` đã có `rate` (`IvrVoicePreviewRequest.rate`, YAML `:6075`): bỏ luật "tốc độ = đã duyệt", worker dựng ở 1.00 rồi **co giãn sau `Finish`** (`VoicePreviewRenderRuntime.cs:85-86`) bằng đúng bộ co giãn của sản xuất ⇒ nghe thử = bản khách sẽ nghe. Khi câu/cụm đã có clip cùng hash chữ và giọng thì **lấy clip rồi co giãn, không cần sidecar** (nghe được cả khi `Preview:Synthesis=OFF`, tức production); không thì dựng bằng sidecar như nay. Thêm lệnh `Ivr.Ops tempo-listen <vùng> <giọng> <tốc độ>` ghép lời đầy đủ như gói nghe W-0457 để Toàn nghe cả cuộc trên máy mình |
| Cuộc gọi trễ/ngắt | Bản dẫn xuất sẵn từ trước (không co giãn lúc gọi) ⇒ không thêm độ trễ; cụm mới chưa có bản dẫn xuất ⇒ chờ ≤ 4 s rồi lỗi kỹ thuật, thử lại, **không tính vào lần gọi** (đúng cơ chế hiện có `SpeechPhraseResolver.cs:192-211`); không bao giờ phát nhầm tốc độ khác |
| Ghi nhận | `DispatchedVoice.SpeakingRate` + `voice_speaking_rate` theo từng lượt gọi (§B5): bằng chứng khách nghe tốc độ nào |
| Cổng readiness bắt buộc | voice + rate trong tập + bank (cặp + bản dẫn xuất đủ) + cụm có bản dẫn xuất (+ `Distinct` nếu m8.148 giữ) = 100 %; kích hoạt trong giao dịch SERIALIZABLE như W-0567 |
| Lệch khi bản dẫn xuất tạo ở máy khác | Thuật toán số nguyên, hash `<sha256>.wav` tạo ở worker .99; test hash vàng trên Windows **và** Linux CI |

Điều phải đúng cho verifier (thêm vào "Vùng 3", `modules/m8/cong-nguy-hiem.md`) và đột biến gợi ý: (1) tốc độ = nguyên bản ⇒ danh sách phát giống từng byte hôm nay (đột biến: luôn tra bảng dẫn xuất); (2) bản dẫn xuất thiếu hoặc `source_sha256` lệch ⇒ không phát (đột biến: rơi về 1.00; bỏ so `source_sha256`); (3) `Judge` bỏ hàng khi bản dẫn xuất BANK không đủ (đột biến: bỏ kiểm đếm); (4) xoá cụm/DSAR xoá luôn bản dẫn xuất + media (đột biến: bỏ xoá hàng dẫn xuất); (5) tốc độ ngoài tập bị từ chối ở API, nguồn và nghe thử (đột biến: nới 2.0); (6) `voice_speaking_rate` ghi tốc độ thật đã phát, không phải cấu hình; (7) worker luôn gọi sidecar ở tốc độ gốc (đột biến: truyền tốc độ hồ sơ ⇒ sidecar 4xx).

## E. Kế hoạch gói (câu 5)

Mức: **NH** = Nguy hiểm (verifier độc lập một lần ở cổng), **T** = Thường. "Đêm nay" = làm trọn và kiểm trên máy Lead.

| Gói | Mục tiêu | Tệp/thư mục chính | Phụ thuộc | Test chính | Mức | Cần Toàn/.99 | YAML |
|---|---|---|---|---|---|---|---|
| **W-0579** Bộ co giãn | `WsolaTimeStretcher` + `TempoRules` (tập 0.80–1.20/0.05) + `Ivr.Ops tempo-listen` | `src/Ivr.Domain/Voice/Tempo/`, `tools/Ivr.Ops/` (lệnh mới), `tests/Ivr.UnitTests/Voice/Tempo/` | — | `UT-TEMPO-*`: độ dài, cao độ, RMS, không vỡ tiếng, 1.00 nguyên byte, tất định (hash vàng), biên (40 ms, im lặng, 2,4 triệu mẫu), WAV vào/ra qua `SpeechPhraseAudio.Wave` và `VerifyWave`; đột biến: bỏ cửa sổ, bỏ tìm kiếm | T (đầu vào của NH) | Đêm nay trọn; Toàn nghe thử 2–3 clip bank ở 0.80/1.20 (copy từ .99) | Không |
| **W-0580** Bank schema 3 | Nạp/đọc/băm bank 9 cặp + công cụ Node dựng/duyệt/cổng | `PrerenderedSpeechCatalog.cs` (`Load`, `ComputeBankHash`), `tools/Ivr.Ops/BankDeployment.cs`, `deploy/ci/scripts/{render,approve,gate,measure,qa}-speech-*.mjs`, `speech-clip-bank-lib.mjs`, selftest | — | `UT-BANK3-*` (bank mô phỏng 9 cặp: nạp, thiếu cặp, trùng cặp, giọng lạ, tốc độ sai, bộ ba cấu hình thiếu, hash); bank cũ schema 2 vẫn nạp; đối chiếu hash C# ↔ JS; selftest Node với PCM giả | NH | Đêm nay trừ dựng thật | Không |
| **W-0581** Bản dẫn xuất (dữ liệu + bộ chạy nền) | Bảng `ivr_voice_clip_variants`, kho, `VoiceVariantJobHost`, hook xoá/DSAR/retention, phân loại dữ liệu | `src/Ivr.Infrastructure/Voice/Variants/` (mới), `SpeechPhraseRetention.cs` (hai chỗ xoá `:135,:188`), migration, `DataClassification.cs`, `docs/data-governance.md`, `docs/compliance/ivr-data-inventory.md`, `Ivr.Worker/Program.cs` (1 dòng) | W-0579 (giao diện bộ co giãn); danh sách clip BANK qua giao diện từ W-0580 | `IT-VARIANT-*` (Testcontainers): dẫn xuất đủ, lặp lại không đổi, nguồn đổi ⇒ bỏ cũ, xoá nguồn xoá bản dẫn xuất + hàng đợi xoá media, DSAR; `VoiceMigrationTests` (chỉ thêm); `DG-RETENTION-04`; công tắc `Ivr:Voice:Variants:Enabled` mặc định tắt | NH (có dữ liệu cá nhân) | Đêm nay | Không |
| **W-0582** Luồng gọi dùng bản dẫn xuất | Tra bản dẫn xuất ở `Render`, resolver, intake; worker dùng tốc độ gốc; ghi tốc độ đã phát | `PrerenderedSpeechCatalog.cs` (`Render`), `SpeechPhraseResolver.cs`, `SpeechPhraseStore.cs` (`GetReadyVariantsAsync`), `PrerenderedSpeechBank.cs`, `SpeechPhraseRendering.cs:215-225`, `DispatchedVoice.cs`, `PostgresTelephonyDispatchStore.cs`, migration cột `voice_speaking_rate` | W-0581, W-0580 (cùng tệp `PrerenderedSpeechCatalog.cs`: **làm sau W-0580, cùng khoá**) | `UT-VARIANT-CALL-*`: tốc độ gốc ⇒ danh sách phát giống hôm nay (cả bộ ca cũ 461 đạt); tốc độ khác ⇒ độ dài/tham chiếu đúng, thiếu ⇒ `TTS_CLIP_NOT_RENDERED`; `KeyPromptTiming` với độ dài co giãn; `voice_speaking_rate`; tương thích triển khai cuốn chiếu | NH | Đêm nay | Không (cột không lộ ra API) |
| **W-0583** Luật, readiness, nguồn, nghe thử | Tập tốc độ hợp lệ; readiness có bản dẫn xuất (không thêm trường); `Judge`; nghe thử có tốc độ; bỏ `Distinct` (nếu m8.148 = A) + migration bỏ chỉ mục | `VoiceProfileRules.cs`, `VoiceReadiness.cs`, `PostgresVoiceProfileStore.cs` (`ActivateAsync`, `RollbackAsync`, `WarmAsync`: warm cũng xếp việc dẫn xuất), `DbVoiceProfileSource.cs`, `VoicePreviewRequestValidator.cs`, `VoicePreviewRenderRuntime.cs`, `VoiceModel.cs` | W-0579, W-0581 | Cập nhật `VoiceProfileRulesTests`/`ParityTests`/`ReadinessTests`/`ProfileSourceTests`; `IT-VOICE-STORE-*` (kích hoạt/quay lại ở tốc độ ≠ 1.00); nghe thử với `FakeSpeechPhraseSynthesizer` ⇒ độ dài co giãn; kiểm "hoán đổi hai vùng" chạy được | NH | Đêm nay | Không (xem §F) |
| **W-0584** Dựng + nghe duyệt bank 9 cặp | Dựng 6 cặp mới ở .99, `measure`, `bank-check`, Toàn nghe duyệt, đưa bank lên | quy trình `deploy/` + `docs/evidence/W-05xx/` | W-0580 | `bank-check`, `speech-clip-bank-gate`, hồ sơ nghe có hash | NH | **Cần .99 + Toàn nghe + Phúc/Toàn đổi ghim** (≈ 40 phút máy + thời gian nghe) | Không |
| **W-0585** Làm nóng, bật thật, bằng chứng | `:warm` cho cặp đã chọn (≈ 27–43 phút/vùng), nghe thử tốc độ đề xuất, bật `STORE`, kích hoạt, đối chiếu `voice_speaking_rate`; phiên m34 đổi giao diện thành chọn tốc độ (hiện chỉ 1.0: `giong-m34-be-fe.md:16`); cổng "Vùng 3" mở rộng + verifier một lần | `modules/m8/cong-nguy-hiem.md`, `docs/operations/voice-profiles-admin.md` | W-0582, W-0583, W-0584, X-03 (chỉ bật production) | verifier theo §D | NH | **Cần .99 + Toàn** | Không |

**Thứ tự và song song.** Sóng 1 (song song, 3 agent nặng): W-0579 ∥ W-0580 ∥ W-0581 (W-0581 chỉ cần giao diện của W-0579). Sóng 2: W-0582 (sau W-0580) ∥ W-0583. Sau sóng 2: nối migration (`dotnet ef`, snapshot, phân loại dữ liệu) bởi phiên chính, một verifier ở cổng. W-0584/W-0585 chờ máy thật. Tệp nóng chỉ phiên chính hoặc một chủ khoá: `IvrDbContext.cs`, `IvrDbContextModelSnapshot.cs`, `Ivr.Worker/Program.cs`, `PrerenderedSpeechCatalog.cs`, `SpeechPhraseRetention.cs`. Mỗi coder chạy `impact` GitNexus trên `PrerenderedSpeechCatalog`, `RegionalVoiceMap`, `VoiceProfileRules`, `SpeechPhraseRetention` trước khi sửa.

## F. Hợp đồng draft.50 (hash `a8852a7f…bcb6`, đã đóng băng)

- **Không buộc đổi YAML** (W-0579…W-0585 theo mặc định): tập tốc độ hợp lệ là kiểm tra ở máy chủ, vẫn trả `RATE_NOT_APPROVED` (mẫu `IvrVoiceRate` `^[0-2]\.[0-9]{2}$`, YAML `:5817-5823`, đã nhận 0.80–1.20); readiness giữ đúng 5 boolean của `IvrVoiceReadinessChecks` (`:5937-5946`, `additionalProperties:false`) nhờ gộp ý nghĩa bản dẫn xuất vào `rate`/`bank`/`phrases` (§B5); `rate` ở `IvrVoicePreviewRequest` có sẵn (`:6075`); `voice_speaking_rate` không lộ ra API.
- **Hệ quả:** vài câu mô tả YAML sẽ lỗi thời ("Only the rate the bank holds … 1.00 today", `:5822-5823`; mô tả `/voices` `:1968-1974`, kiểm `distinct`). Ghi vào `docs/operations/voice-profiles-admin.md`; sửa chữ = draft.51 gom **một lần** ở cuối (hỏi m8.151).
- **Buộc đổi YAML (draft.51, báo m34 hash mới):** (a) kích hoạt nguyên tử cả bộ nếu m8.148 = B (tuyến mới `…/voice-profiles:activate-set`); (b) lộ tập tốc độ ở `GET /voices` (`rate_min/max/step`) hoặc thêm `checks.variants`; (c) tham số `rate` cho `GET …/audio` của clip bank/cụm. Cả ba **không cần** để bật thật.
- Phiên m34: giao diện đang cứng 1.0; cần ô chọn tốc độ 0.80–1.20 (bước 0.05) và hiện `details.variants_missing`. Báo qua tin phiên, kèm lưu ý hash không đổi.

## G. Câu hỏi cần Toàn (tối đa 4)

| Mã | Câu hỏi | Mặc định đề xuất |
|---|---|---|
| **m8.148** | Hồ sơ giọng hiện buộc ba vùng ba giọng khác nhau, nên với 3 giọng đã duyệt **không vùng nào đổi giọng được** (kẹt vòng). A = bỏ ràng buộc "khác nhau" cho hồ sơ (một giọng có thể ở nhiều vùng; migration bỏ chỉ mục theo giọng); B = giữ ràng buộc, thêm kích hoạt nguyên tử cả bộ (YAML draft.51 + sửa giao diện M3); C = giữ nguyên (chỉ đổi tốc độ, không đổi giọng) | **A** | **→ Toàn chốt B (D-m8-162).**
| **m8.149** | Khoảng tốc độ cho phép: A = 0.80–1.20 bước 0.05 (khuyến nghị bật thật 0.90–1.10); B = hẹp 0.90–1.10 | **A** |
| **m8.150** | Bank: dựng đủ 9 cặp một lượt (≈ 37 phút máy, Toàn nghe 6 cặp mới), dựng ở **.99** bằng ảnh sidecar đang chạy (Phúc/Toàn chạy) thay vì dựng ảnh + tải 211 MB mô hình về máy Lead | **9 cặp, dựng ở .99** |
| **m8.151** | Sửa chữ mô tả YAML cho khớp (draft.51, một lần ở cuối, báo m34 ghim lại) hay giữ mô tả cũ lỗi thời trong lúc chưa bật `STORE` thật | **Gom draft.51 ở cuối** khi chuẩn bị bật thật |

Đã tự chọn (không hỏi): bản dẫn xuất lưu ở volume `phrases` + bảng riêng; lời chào tên khách không làm nóng trước; công tắc `Ivr:Voice:Variants:Enabled` mặc định tắt; tốc độ gốc luôn 1.00 theo giọng.

## H. Chưa xác minh (không suy diễn)

Bank thật trên .99 (số clip, manifest, chế độ LOCAL_SHARED hay REMOTE_VM) và cấu hình `Prerendered`/`Phrases` thật; dung lượng volume `phrases` còn trống; kích cỡ thật của cụm giao hàng (50 KB là ước); số hàng cụm hiện có trong kho .99; ảnh `ivr-tts` có kéo về máy Lead được từ kho GitLab hay không; thời gian dựng trên .99 (số 2,0 s/lượt đo ở 03/10 trên máy khác, cùng quota 2 CPU/4 GiB); chất lượng nghe thật của WSOLA ở 0.80/1.20 (chỉ nghe mới biết); `dotnet ef` và Testcontainers trên máy phiên chính (Docker có, `postgres:16-alpine` có sẵn); GitNexus `impact` chưa chạy (chỉ đọc bằng grep).
