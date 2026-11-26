# W-0569 — API kho cụm tên địa bàn: liệt kê, nghe, duyệt/từ chối, đọc lại, yêu cầu dựng, xuất CSV (KE_HOACH G-07; thay việc "nhờ Chú duyệt 455 tên")

Trạng thái: CHƯA LÀM (chờ W-0564, W-0565) · Mức: Nguy hiểm (REJECT cụm làm cuộc tới địa bàn đó lỗi; dữ liệu PiiDirect) · Mốc: 27/11
Sheet: (cấp khi xong) · Ước lượng: 5 giờ · Khoá tệp: `m8/W-0569`

## Brief
1. Quy tắc chung [giong-doc-quy-tac-agent.md](giong-doc-quy-tac-agent.md); thiết kế [giong-doc-thiet-ke.md](giong-doc-thiet-ke.md) §0 #4–5, §A (cách cuộc gọi dùng cụm), §E tuyến 15–22 + giới hạn + lỗi, §J hàng 13–14.
2. Mục tiêu: thay stub của `src/Ivr.Api/Admin/Voice/Phrases/SpeechPhraseAdminEndpoints.cs`: `GET /speech-phrases` (chỉ `phrase_kind='DELIVERY'`; lọc region/voice_id/status/review_status/q; trang `limit` 1–200), `GET /speech-phrases/summary` (đếm vùng × trạng thái × duyệt = tiến độ làm nóng), `GET /speech-phrases/export?review_status=UNREVIEWED` (CSV UTF-8 BOM, ≤ 5.000 hàng, chống chèn công thức: ô bắt đầu `= + - @` thêm `'`, mỗi ô qua `EnsureSafeContactText`), `GET /speech-phrases/{region}/{voiceId}/{clipId}` (cụm lời chào ⇒ 404), `GET …/audio` (WAV từ `Phrases:MediaDirectory`, kiểm RIFF + kích thước = 44 + 2×`duration_samples` + sha256, `no-store`), `POST …:review` (APPROVE|REJECT, người nghe = `X-Actor-Id`, **audit mới cùng giao dịch** — hiện `SpeechPhraseStore.cs:466-479` không audit; REJECT cụm có `use_count>0` cần `acknowledge_call_impact=true` ⇒ không thì 409 `CALL_IMPACT_NOT_ACKNOWLEDGED`), `POST …:respell` (`render_text` ≤ 400, chỉ chữ cái/dấu cách/`,.-'`, không số; về PENDING + UNREVIEWED; cùng quy tắc ack), `POST /speech-phrases:request` (thử lại cụm FAILED, đặt `render_attempts=0`, ≤ 500 khoá). KHÔNG có endpoint xoá (`docs/compliance/phrase-deletion.md`). Dùng `VoicePiiMaskingFilter` mới (sao chép `PiiMaskingFilter.cs`; `area_text`/`render_text` chỉ qua `EnsureSafeContactText` vì `PiiGuard.cs:71-72` bắt "đường/tổ/thôn/ấp" làm 422 cả trang với tên địa bàn như "Đường Lâm"). Quyền `IVR_PHRASE_REVIEW` qua `CallRuleAdminFilter`; đọc không cần quyền.
3. Phạm vi ghi: `src/Ivr.Infrastructure/Voice/Phrases/**`, `src/Ivr.Api/Admin/Voice/Phrases/**` (+ `VoicePiiMaskingFilter` ở thư mục này), test `tests/Ivr.UnitTests/Voice/SpeechPhraseCsvTests` (~6), `tests/Ivr.IntegrationTests/Voice/` (`SpeechPhraseAdminApiTests` ~28, `SpeechPhraseAdminStoreTests` ~14, `SpeechPhraseAudioEndpointTests` ~8; sửa stub tuyến 15–22 trong `VoiceAdminStubTests`), `docs/evidence/W-0569/README.md`, `docs/operations/speech-phrases-admin.md`. Cấm: `SpeechPhraseStore.cs` (đọc/tái dùng, KHÔNG sửa hành vi cuộc gọi: nếu cần hàm mới, đặt ở `Voice/Phrases/`), migration, YAML, `Profiles/`, `Preview/`, `Cost/`.
4. Bất biến: HTTP không bao giờ trả cụm lời chào/tên khách (lọc ở truy vấn + test `phrase-greeting-*` ⇒ 404); không đường ghi nào ngoài review/respell/request; audit không chứa `area_text`/`render_text`; đường cuộc gọi (`SpeechPhraseResolver`, `GetReadyAsync`) không đổi.
5. Đột biến tự thử: bỏ lọc `DELIVERY`; `GET {key}` không chặn lời chào; CSV không qua guard; bỏ kiểm ack; coi `use_count` null là 0; bỏ audit ở `:review`.

## Diễn biến
- 25/11 22:4x phiên chính: tạo phiếu.

## Bước kế tiếp chính xác
Giao agent coder khi W-0564 + W-0565 đã commit.
