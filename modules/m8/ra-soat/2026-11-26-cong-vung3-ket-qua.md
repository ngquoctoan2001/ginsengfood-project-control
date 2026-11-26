# K-02 / K-01 — cổng Nguy hiểm vùng 3 + vùng 2: kết quả verifier độc lập (26/11/2026)

**Phán quyết: vùng 3 = ĐẠT, chờ bộ đủ · vùng 2 = ĐẠT, chờ bộ đủ.** 0 nặng, 0 trung bình, 10 nhẹ (đưa vào "Nợ"). Một vòng; 16 đột biến (vùng 3: 12, vùng 2: 4), 15 đỏ + 1 tương đương.
Cây: HEAD đầu = cuối `673904dc`; chỉ có 2 tệp chưa theo dõi của agent khác (`deploy/operations/m34_mock_agent.py`, `test_m34_mock_agent.py`), không đụng. Mỗi đột biến hoàn lại từ bản chép, SHA-256 khớp, `git diff` src/tests/deploy rỗng. Khoá `@dot-bien` + `@bo-kiem-du` (m8/verifier-K02) đã giải; `.artifacts/build-K02*` đã dọn, không còn tiến trình/container của tôi. `dotnet build-server shutdown` để phiên chính (máy chủ build dùng chung nhiều phiên). Ma trận API ghi lại `.artifacts/api-matrix/` (đã gitignore).

## Lệnh + số thật (chạy lại từ đầu, không tin số của người viết)
- Unit lọc `Voice`, `Cost`, `DailyDialBudget`, `VietnameseMobile`, `CallDurationCap`: **335/335**. Integration lọc `Cost` + `Voice` + `DailyDialBudgetPersistence` (PostgreSQL Testcontainers): **343/343**, 8 phút 27.
- Contract **33/33**; `AdminContractParity` + `CompositionRoot` + `ProductionDialPath` + `OpenApiDocument` + ma trận API `IT-API-MATRIX-38` (87 thao tác): **13/13**, 2 phút 9, sau khi dựng lại bản sạch.
- Python: CDR tối giản + tổng hợp 57/57 (1 bỏ qua: HĐH không tạo symlink); ghim số dòng m8 7/7 + 24/24 + kiểm độc lập nối M3 126 ca (9 bỏ qua do môi trường); `scan-pii.sh` PASS trên 14 thư mục bằng chứng W-0563…W-0577; grep diff: 0 bí mật, chỉ số giả trong test.
- H-02 `kiem-logic.sh` (lệnh giả, đã kiểm `type -P` trỏ vào shim): **226/226 đạt, 0 đỏ** (lượt đầu bị `timeout 280 s` cắt ở ca 150, chạy lại đủ).

## Vùng 3 — 17 hàng điều phải đúng → bằng chứng
| Hàng | Bằng chứng (đọc mã thật + test + đột biến) |
|---|---|
| 1 Production không tổng hợp lúc gọi | `SpeechSynthesisService.cs:75-90`, `SpeechServiceCollectionExtensions.cs:514-526`; không type nào của `Ivr.Api` dùng synthesizer/TTS (grep 0); `UT-VOICE-PREVIEW-ISO-01…04` (quét IL), `IT-VOICE-PREVIEW-ISO-API-01…03` |
| 2 ACTIVE đúng giọng, ba vùng ba giọng | `VoiceProfileRules.cs:127-176`, `ConfiguredVoices.Approved`; Đb 9 (chỉ mục `per_voice`) đỏ 2; bank theo từng vùng nên khó trùng giọng |
| 3 Kích hoạt chỉ khi readiness 100% | Đb 1 (`Ready >= 0`) đỏ 5; `ActivateAsync` chấm trong giao dịch SERIALIZABLE |
| 4 Rollback đúng bộ ba bản trước | Đb 4 (bỏ kiểm readiness) đỏ 2; đọc `RollbackAsync:431-531` (hàng mới, RETIRED hiện hành) |
| 5 `voice_id` là giọng thật đã phát; lệch bank không đổi giọng | `SpeechSynthesisService.cs:103,170-173`; Đb 2 (bỏ kiểm bank ở `Judge`) đỏ 3 |
| 6 Nghe thử không bao giờ phát cho khách | bảng riêng + CHECK `clip_id`; `VoicePreviewRenderRuntime` chỉ `store.CompleteAsync`; Đb 10 (bỏ kiểm hash chữ) đỏ 1; ISO IL |
| 7 Chữ nghe thử chỉ câu cố định/cụm DELIVERY, qua guard | Đb 3 (cho lời chào) đỏ 2; `IsSpeakable` ở API (`:106`) và lúc dựng (`:167`) |
| 8 Quyền không gán sẵn, 403 trước replay, audit không chữ | đọc từng tuyến + `CallRuleAdminFilter.cs:59-63`; không nơi nào gán 4 quyền mới; `IT-VOICE-API-01…05` xanh |
| 9 Lỗi/trống kho giọng không đổi giọng | `DbVoiceProfileSource.Fail:349-369` giữ ảnh chụp cũ; test W-0566 xanh trong 335 |
| 10 Trần tiền fail-closed | Đb 15 (`CEILING_UNSET`⇒dial) đỏ 6; Đb 14 (bỏ `Enabled` bắt buộc) đỏ 8 |
| 11 Hạ/nâng trần đúng | Đb 7 (bỏ `CEILING_BELOW_USAGE`) đỏ 1; PUT không pause/resume (đọc `ApplyAsync`) |
| 12 Audit trần cùng giao dịch | một `SaveChanges` trong SERIALIZABLE (`PostgresCostCeilingStore.cs` `ApplyAsync`); `IT-COST-API-22…25` xanh |
| 13 HTTP không trả lời chào/PII | Đb 6 (bỏ lọc DELIVERY) đỏ 7; `SpeechPhraseCsv.Cell` chống `=+-@`; `VoicePiiMaskingFilter` |
| 14 REJECT/đọc lại cụm đã dùng cần ack | Đb 5 đỏ 2 |
| 15 Migration chỉ thêm, dọn trùng, chỉ mục duy nhất | Đb 8 (bỏ `hold_new_calls DESC`) đỏ 1; Đb 9; đọc `Up/Down`: LOCK→UPDATE→INDEX |
| 16 CDR .64 không số điện thoại, volume bền, verify chặn | Đb 12 (bỏ kiểm chữ lạ) đỏ 4; Đb 11 xanh = tương đương (kiểm cột đúng thứ tự ngay sau chặn cùng ca); volume `external`, `cdr_giu.py` mặc định chạy thử |
| 17 Kịch bản bảo trì .64 (H-02) | đọc `buoc3.sh` (CIDR, dừng khi còn cuộc, `lui`); chạy `kiem-logic.sh`; CHƯA chạy trên .64, không đột biến (hết hạn mức 12) |

## Vùng 2 — quay số thật, cước
Đb 13 (`IsMobile` thêm đầu số 2) đỏ 1; Đb 14 (validator) đỏ 8; Đb 15 đỏ 6; Đb 16 (lớp bọc `DailyBudgetSchedulerStore` bỏ dừng khi `!MayDial`) đỏ 1 IT + 1 UT. Đọc: chỉ lối `PRODUCTION_REAL+ARI+SipTrunk` quay khách và nó luôn bọc guard (`SchedulerCapacity.cs:1253-1260`); `TIMEOUT(absolute)` đặt trước khi phát (`AsteriskAriSimGateway.cs:475-490`). W-0551 (đo cước: bảng tổng theo ngày + xuất đối soát) không đổi đường quay; công thức 6+1 giây vẫn chờ MobiFone xác nhận.

## Phát hiện nhẹ → "Nợ" (không chặn)
N1 `VoiceReadiness.cs:140`, `PostgresVoiceProfileStore.cs:555-560`: kho cụm trống ⇒ `needed=0` ⇒ `phrases` đạt (ghim chủ ý ở `IT-VOICE-READY-04`); kích hoạt được khi chưa làm nóng cụm nào, cuộc đầu thành thử lại kỹ thuật (không sai giọng). Sửa: cảnh báo khi `needed=0` hoặc runbook đòi `:warm` + `needed>0`.
N2 `PostgresVoiceProfileStore.cs:310,478-485`: rollback bị chặn nếu bản trước thiếu cụm mới phát sinh dưới giọng hiện hành, bản RETIRED không `:warm` được ⇒ phải tạo nháp `based_on`; lùi nhanh = đặt `Ivr:Voice:ProfileSource=OPTIONS`. Ghi runbook; thiếu IT "rollback của rollback" và ca này.
N3 `SpeechPhraseResolver.cs:50,146`, `PrerenderedSpeechBank.cs:38`, `RegionalVoiceMap.cs:105`: `Resolve` được gọi riêng ở intake, ở `Plan` và ở dựng (`SpeechSynthesisService.cs:103`); trúng lúc ảnh chụp đổi (2 s) thì `Plan` xin cụm theo giọng mới, phát theo giọng cũ ⇒ chờ/thử lại kỹ thuật, không sai giọng (`DispatchedVoice` lấy đúng `voice` đã dựng). Sửa: truyền `voice` vào `Plan`.
N4 `DailyDialBudget.cs:268-283` và `DailyDialUsageQuery.cs:31-45`: hai bản câu đếm giữ giống nhau chỉ nhờ `IT-COST-USAGE-PARITY`; cho guard gọi `DailyDialUsageQuery`.
N5 `DailyBudgetSchedulerStore.cs:38-44`: kiểm trần rồi mới claim ⇒ nhiều worker có thể vượt tối đa N−1 lượt (nợ cũ W-0550 §3, chưa có test đua).
N6 `AsteriskAriOptions.cs:145-165`: "trần 120 s" thực ra là cấu hình 1–300 bắt buộc; 120 chỉ ở mẫu `closed-profile.example.json`; thêm vào checklist go-live.
N7 `VoiceProfileRules.cs:112-119`: `BankHolds` không đòi `Clips ≥ 1` (manifest ghim sha nên rủi ro nhỏ).
N8 `VoicePreviewApiIsolationTests.cs:88-107`: ISO-API-03 chỉ kiểm hàm đăng ký riêng; host API đủ vẫn đăng ký `ISpeechPhraseSynthesizer` (có từ trước, qua `AddIvrFoundation→AddIvrSpeech` khi `Phrases:Enabled`), không type API nào dùng nó. Sửa chữ hàng 1 của `cong-nguy-hiem.md` hoặc thêm test host đủ.
N9 `deploy/telephony-vm/cdr_giu.py:37,45-54`: cờ `--bay-gio` (dành cho test) nhận giờ tuỳ ý; kèm `--ap-dung xoa-qua-han` một giờ ở tương lai xoá hết CDR đã xoay. Bỏ cờ hoặc từ chối giờ > hiện tại + 1 ngày.
N10 Migration W0565: dọn trùng sự cố tạm dừng không để lại audit/admin action cho các hàng bị RESOLVED (resume thì có); ghi tay vào nhật ký lên .99. Chữ cũ `IvrAdminEndpoints.cs:93` còn "answering 501".
Chưa có test: đua hai vùng cùng giọng; đổi manifest ghim sau kích hoạt (`/voice-profiles/effective` vẫn nói `STORE` dù `Judge` gạt hồ sơ); đua nhiều worker qua trần. Công thức cước 6+1 chờ MobiFone xác nhận (nợ cũ).

## Chưa chạy / giới hạn
Bộ đủ, CI, oasdiff, gitleaks, document-links; mọi thứ trên .99/.98/.64 (không ssh, không mạng); `buoc3.sh` trên .64 thật; đột biến H-02. Không sửa mã sản phẩm, không commit.
