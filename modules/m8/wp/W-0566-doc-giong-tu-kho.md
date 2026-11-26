# W-0566 — `RegionalVoiceMap` đọc hồ sơ ACTIVE từ kho (KE_HOACH G-04)

Trạng thái: CHƯA LÀM (chờ W-0565 và W-0567 vì dùng `VoiceProfileRules` + `IVoiceBankCoverage` do W-0567 tạo) · Mức: Nguy hiểm (đổi giọng nói với khách; cắt được đầu tiên nếu trượt) · Mốc: 27/11
Sheet: (cấp khi xong) · Ước lượng: 4 giờ · Khoá tệp: `m8/W-0566`

## Brief
1. Quy tắc chung [giong-doc-quy-tac-agent.md](giong-doc-quy-tac-agent.md); thiết kế [giong-doc-thiet-ke.md](giong-doc-thiet-ke.md) §0 #1–2, §D (toàn bộ), §J hàng 5 và 9.
2. Mục tiêu: `IVoiceProfileSource { VoiceProfileSnapshot Current { get; } }` (đồng bộ, không chặn; snapshot bất biến `{LoadedAt, Active: vùng→(profile_id, voice_id, rate), State: NOT_LOADED|OK|STALE}`), `DbVoiceProfileSource` làm mới mỗi 2 giây bằng `IHostedService` ở cả API lẫn Worker (đăng ký trong `AddIvrVoice`), `RegionalVoiceMap` giữ nguyên constructor + thêm tham số tuỳ chọn `IVoiceProfileSource? source = null` (12 tệp test dựng thẳng `new RegionalVoiceMap(...)` phải còn biên dịch và xanh). Cờ `Ivr:Voice:ProfileSource` = `OPTIONS` (mặc định, hành vi y hệt hôm nay) | `STORE`. Hiệu lực cho cuộc MỚI trong ≤ 5 giây; cuộc đã dựng không đổi (`DispatchedVoice`). Rơi về: vùng chưa có hàng ACTIVE ⇒ cấu hình; **lỗi nạp ⇒ giữ snapshot gần nhất** (khác chữ KE_HOACH cũ); chưa từng nạp ⇒ cấu hình; hàng ACTIVE có bộ ba không có trong bank đang nạp (`IVoiceBankCoverage`) hoặc trái `VoiceProfileRules` ⇒ BỎ QUA hàng, dùng cấu hình cho vùng đó. Log cảnh báo (không chữ/khoá) + đồng hồ `ivr_voice_profile_source_state{state}`, `ivr_voice_profile_rejected_total{reason}` (mẫu `TtsTelemetry.cs`); `STALE` quá 10 phút ⇒ log mức lỗi. `SpeechPhraseRenderRuntime.SpeakingRateFor` KHÔNG đổi ở MVP.
3. Phạm vi ghi: `src/Ivr.Infrastructure/Voice/Source/**` (trừ `IVoiceBankCoverage*` của W-0567: chỉ DÙNG), `src/Ivr.Infrastructure/Speech/RegionalVoiceMap.cs` (**khoá riêng**; thêm tham số tuỳ chọn + một nhánh `Resolve`), `src/Ivr.Worker/Program.cs`/DI: chỉ nếu nối 0 chưa đủ (báo, phiên chính nối); test `tests/Ivr.UnitTests/Voice/` (`VoiceProfileSourceTests` ~16 với `FakeTimeProvider`, `RegionalVoiceMapStoreTests` ~8), chạy lại `RegionalVoiceRoutingTests`/`DeliveryRegionResolverTests`/`DispatchedVoiceTests`/`PrerenderedSpeechCatalogTests`/`N1TransitionRuleTests`, `docs/evidence/W-0566/README.md`. Cấm: migration, YAML, `Profiles/`, `Preview/`, `Phrases/`, `Cost/`, validator cũ (`TtsProviderOptionsValidator`: không refactor).
4. Đột biến: nhánh lệch bank trả hàng DB; ghi `voice_id` từ cấu hình thay vì từ lựa chọn; lỗi nạp ⇒ rơi về options; xoá snapshot khi lỗi; chấp nhận bộ ba trái `VoiceProfileRules`; đổi mặc định `ProfileSource` thành `STORE`.

## Diễn biến
- 25/11 22:4x phiên chính: tạo phiếu.

## Bước kế tiếp chính xác
Giao sau W-0567; đọc diff `RegionalVoiceMap.cs` từng dòng (đường gọi thật).
