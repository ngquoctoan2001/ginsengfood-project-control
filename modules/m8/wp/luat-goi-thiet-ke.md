# M8-WP08A — Thiết kế bảng quy tắc gọi (bản nháp 1, 20/11/2026; chốt cùng hợp đồng draft.49)

Phiếu: [luat-goi-cau-hinh.md](luat-goi-cau-hinh.md) · Theo dõi chung: `modules/lead/wp/theo-doi-luat-goi.md`. Tệp này là thiết kế kỹ thuật để coder, m34 và verifier bám; sửa tại đây trước, rồi mới sang `specs/` của repo ivr.

## 1. Mô hình: bảng quy tắc (decision table) + khung giờ + trần

Mỗi chương trình có **một bộ luật đang dùng** (`ACTIVE`). Đơn mới nhận → M8 chụp bản luật đó vào job (bất biến, như nay). Sau **mỗi cuộc gọi đã tính lượt**, bộ máy luật nhận (lịch sử cuộc, giờ hiện tại) và trả: gọi tiếp lúc nào, hoặc kết thúc với kết quả nào. Job cũ (policy v4) giữ đường lịch tính sẵn như nay.

```json
{
  "time_zone": "Asia/Ho_Chi_Minh",
  "calling_windows": [ {"days": ["MON","TUE","WED","THU","FRI","SAT","SUN"], "from": "08:00", "to": "21:08"} ],
  "min_gap_seconds": 60,
  "rows": [
    {"id": "r1", "when": {"outcomes": ["UNREACHABLE","INVALID_DESTINATION"]}, "then": {"action": "FINISH", "result": "IVR_INVALID_PHONE_FINAL"}},
    {"id": "r2", "when": {"calls_made": {"from": 1, "to": 1}}, "then": {"action": "CALL_AFTER", "minutes": 7.5}},
    {"id": "r3", "when": {"calls_made": {"from": 2, "to": 2}}, "then": {"action": "CALL_AFTER", "minutes": 7}},
    {"id": "r4", "when": {"calls_made": {"from": 3, "to": 3}}, "then": {"action": "CALL_IN_WINDOW", "from": "13:00", "to": "14:00", "not_before_day": 0}},
    {"id": "r5", "when": {"calls_made": {"from": 4, "to": 4}}, "then": {"action": "CALL_IN_WINDOW", "from": "08:00", "to": "09:00", "not_before_day": 1}},
    {"id": "r6", "when": {}, "then": {"action": "FINISH", "result": "IVR_NO_ANSWER_FINAL"}}
  ],
  "limits": {
    "max_total_calls": 8,
    "max_calls_per_day_per_order": 4,
    "max_calls_per_phone_per_day": 6,
    "max_horizon_minutes": 2160,
    "stop_after_session_end_minutes": null,
    "first_call_delay_after_session_end_minutes": null,
    "technical_retry_limit": 1
  }
}
```

(Ví dụ minh hoạ cấu trúc, **không phải** đề xuất con số; Toàn bổ sung luật thật sau. r2 + r3 + r6 giữ nguyên v4 24/7: cuộc 1 lúc T0, cuộc 2 sau 7,5 phút, cuộc 3 sau 7 phút, rồi kết thúc.)

### Điều kiện `when` (mọi trường tuỳ chọn; dòng khớp khi tất cả trường có mặt đều đúng)
- `calls_made`: `{from,to}` — số cuộc đã tính lượt tới giờ (≥ 1).
- `outcomes`: tập nhóm kết quả của cuộc vừa xong, lấy từ danh sách **cố định của nền tảng** (không sửa được): `RING_TIMEOUT` (không nghe), `BUSY`, `SUBSCRIBER_ABSENT` (thuê bao: tắt máy/ngoài vùng), `REJECTED`, `ANSWERED_NO_INPUT` (nghe máy không bấm), `WRONG_INPUT` (nghe máy, bấm phím không hỗ trợ; cuộc vẫn tính lượt), `UNREACHABLE`, `INVALID_DESTINATION`. Lỗi kỹ thuật (đứt cuộc, mạng, SIM, âm thanh, DTMF) KHÔNG phải nhóm: đi đường retry kỹ thuật riêng (`technical_retry_limit`), không tính lượt khách.
- `day_index`: `{from,to}` — ngày thứ mấy theo giờ Việt Nam kể từ ngày của T0 (0 = cùng ngày).
- Không có `when` nào → dòng khớp mọi trường hợp (dùng làm dòng cuối).

### Hành động `then`
- `CALL_AFTER {minutes}`: gọi sau X phút tính từ **lúc bắt đầu cuộc trước** (giữ cách tính offset của v4, 0/450/870 giây từ T0).
- `CALL_IN_WINDOW {from,to,not_before_day}`: gọi trong khung `[from,to)` (giờ VN) sớm nhất mà thời điểm ≥ lúc đủ nghỉ và ngày ≥ ngày của T0 + `not_before_day`.
- `FINISH {result}`: kết thúc, kết quả ∈ {`IVR_NO_ANSWER_FINAL`, `IVR_INVALID_PHONE_FINAL`}. Dòng nào không khớp và hết dòng → mặc định `IVR_NO_ANSWER_FINAL`.

### Ràng buộc luôn áp (sau khi dòng chọn thời điểm)
1. `calling_windows`: thời điểm gọi bị đẩy tới lúc khung kế tiếp mở nếu rơi ngoài; biên đóng không cho bắt đầu đúng giờ đóng (như hiện nay: 24/7 `[08:00,21:08)`, Giờ Vàng `[08:00,22:08)`).
2. `min_gap_seconds` (mặc định 60, không dưới 60) sau cuộc đã tính lượt.
3. Trần: `max_total_calls` (1–10: `attempt_number` của callback tối đa 10 và hash callback `323ba1d2…` giữ nguyên nên không nâng trần dây), `max_calls_per_day_per_order` (vượt → dời sang ngày kế), `max_calls_per_phone_per_day` (đếm mọi đơn của số đó trong ngày VN; vượt → dời sang ngày kế), `max_horizon_minutes` từ T0 và **không vượt trần giữ đơn M3 gửi** (`confirmation_window_expires_at`): quá → `FINISH IVR_NO_ANSWER_FINAL` với lý do `HORIZON`.
4. Giờ Vàng: `stop_after_session_end_minutes` (D-m8-146): thời điểm > `session_ends_at` + N phút → `FINISH IVR_NO_ANSWER_FINAL` lý do `SESSION_ENDED`; để trống = không mốc.
5. Cuộc gọi thật sự quay số vẫn qua cổng hiện có (kênh, quota, kill switch, ngân sách ngày W-0550, giờ gọi).

### Cuộc đầu tiên
T0 = `confirmation_window_started_at` do M3 gửi (Giờ Vàng: M3 đã tính max(giờ thanh toán, hết phiên thật + 10 phút); M8 không cộng thêm). Từ 16/11 M3 không gửi `session_ends_at` cho Giờ Vàng nên luật dựng sẵn để `stop_after_session_end_minutes` và `first_call_delay_after_session_end_minutes` = null; chỉ khi luật dùng một trong hai thì M8 đòi `session_ends_at` (thiếu → 400) và validator báo lỗi nếu stop_after ≤ first_call_delay (m34 20/11). Tham số tuỳ chọn `limits.first_call_delay_after_session_end_minutes` (Giờ Vàng, mặc định trống): có giá trị thì T0 = max(started_at, `session_ends_at` + giá trị) — để sau này bỏ phần M3 tự tính mà không đổi hợp đồng (m34 hỏi 20/11). Trước đó T0 = lúc đơn đủ điều kiện tới M8; cuộc 1 gọi ngay nếu trong khung, không thì giữ tới khung kế (như đơn giữ ban đêm hiện nay, đặt T0 lúc bắt đầu). Giờ Vàng gọi liền.

## 2. Dữ liệu (đề xuất)
- `ivr_call_rule_sets` (id, program_code, version, status, definition_json, created/approved/activated by/at, notes; duy nhất 1 `ACTIVE` mỗi chương trình) + `ivr_call_rule_set_events` (audit).
- Job: thêm `rule_set_id`, `rule_set_version`, `rule_snapshot_json` (bất biến), `engine_mode`, `next_attempt_due_at`; job v4 giữ `AttemptScheduleJson`.
- `ivr_call_phone_day_counters` (hoặc đếm trực tiếp từ `ivr_call_attempts` theo số đã băm + ngày VN: ưu tiên cách nào không cần bảng mới nếu đủ nhanh — coder đo).
- Luật mặc định nạp sẵn bằng seed: bản v4 24/7 và Giờ Vàng viết lại thành bảng quy tắc (chứng minh tương đương).

## 3. API quản trị (OpenAPI draft.49, cùng tiền tố `/v1/ivr/order-confirmation`)
`GET /call-rule-sets` (lọc chương trình, trạng thái) · `GET /call-rule-sets/{id}` · `GET /call-rule-sets/effective/{programCode}` · `POST /call-rule-sets` (nháp, có thể từ bản đang dùng) · `PUT /call-rule-sets/{id}` (chỉ nháp, `If-Match`) · `POST …:validate` · `POST …:simulate` · `POST …:submit` · `POST …:approve` (người duyệt ≠ người soạn) · `POST …:reject` (SUBMITTED → DRAFT, trả về để sửa) · `POST …:activate` (chỉ đơn mới từ lúc đó) · `POST …:retire`. Mỗi thay đổi ghi audit; quyền ghi tầng riêng (khớp mô hình quyền của `/scripts/…`).
- `:validate`: kiểm cấu trúc, khung giờ không chồng, mọi đường đều kết thúc hữu hạn (không vòng), đường xấu nhất ≤ `max_horizon_minutes`, `max_total_calls` khớp số dòng gọi tối đa, v.v.
- `:simulate`: nhận giờ nhận đơn + chuỗi kết quả giả định (+ `session_ends_at`) → lịch gọi dự kiến và kết quả cuối + cảnh báo. Không ghi gì.

## 4. Hợp đồng với M3 (draft.49)
- **Callback không đổi dây** (mã kết quả, nhãn `recommended_core_action`, hash ghim). Ngữ nghĩa mới ghi trong mô tả: `IVR_NO_ANSWER_FINAL`, `IVR_INVALID_PHONE_FINAL`, `IVR_CONFIRMATION_WINDOW_EXPIRED`, `IVR_CAPACITY_EXCEPTION` = "chưa có 0/1, cần nhân viên" (M3 không huỷ); `IVR_CUSTOMER_CANCELLED` huỷ; `IVR_CONFIRMED` xác nhận.
- **Intake:** `max_customer_attempts`, `attempt_offsets_seconds`, `attempt_policy_version` thành tuỳ chọn. Có đủ cả ba → đường v4 như nay (kiểm khớp registry). Không gửi cả ba → chế độ luật: M8 chọn luật `ACTIVE` theo `program_code`. Gửi một phần → 400. `confirmation_window_expires_at` luôn là trần giữ đơn của M3 (M8 không lên lịch cuộc nào quá trần). Ack thêm `call_rule_set {id, version}` và `first_call_due_at`, `planned_horizon_at`.
- **Gọi lại thủ công** = task mới có `recall_of_task_id` (giữ các chốt: gốc lạ, đơn còn chuỗi mở); bỏ khung giờ gọi lại cố định, theo `calling_windows` của luật; chạy luật từ đầu.
- **Đọc trạng thái** (`/tasks/{id}/result`, `/call-jobs`): thêm mã/phiên bản luật, số cuộc đã tính lượt, lần gọi kế (`next_attempt_due_at`) để giao diện hàng chờ hiển thị.

### Lý do kết quả cuối (`result_reason`, chuỗi tự do trong callback nên không đổi hợp đồng ghim; thêm theo yêu cầu m34 20/11)
Callback đã có `result_reason`, `attempt_number` (số cuộc đã tính lượt), `occurred_at` (giờ cuộc cuối kết thúc). Chế độ luật dùng lý do ổn định, một giá trị mỗi trường hợp, không đổi tên sau này:
- `IVR_NO_ANSWER_FINAL` + `RULES_EXHAUSTED:<NHÓM_CUỘC_CUỐI>` (hết dòng quy tắc), `HORIZON_REACHED:<NHÓM>` (chạm tầm xa/trần giữ đơn), `SESSION_ENDED:<NHÓM>` (mốc Giờ Vàng sau phiên), với `<NHÓM>` ∈ nhóm kết quả cố định ở trên (RING_TIMEOUT, BUSY, SUBSCRIBER_ABSENT, REJECTED, ANSWERED_NO_INPUT, WRONG_INPUT).
- `IVR_INVALID_PHONE_FINAL` + `UNREACHABLE` / `INVALID_DESTINATION` (như nay).
- `IVR_CONFIRMATION_WINDOW_EXPIRED` + các lý do `WINDOW_EXPIRED_*` đã có: `…_ALL_CALLS_TECHNICAL_FAILURE` = có gọi nhưng mọi cuộc lỗi kỹ thuật (M3 phân biệt với "khách không bắt máy", QT-CHUNG-001); `…_BEFORE_FINAL_RESULT` = chưa gọi được cuộc nào.
- `IVR_CAPACITY_EXCEPTION` + `CAPACITY_UNAVAILABLE` (như nay).

## 5. Kiểm thử bắt buộc
- Bộ máy luật: bảng ca (outcome × calls_made × giờ × khung), bất biến "không bao giờ gọi ngoài khung", "không vượt trần", "luôn hữu hạn", đối chiếu **tương đương v4** (24/7 và Giờ Vàng viết lại thành bảng cho đúng cùng lịch gọi như `GoldenHourTwoCallAttemptPolicies`/`BufferedThreeCallAttemptPolicies`), qua nửa đêm VN, ranh giới `21:08`/`22:08`, cắt phiên Giờ Vàng.
- Tích hợp: job luật hoàn chỉnh từ intake tới kết quả cuối với kịch bản MOCK (không nghe nhiều lượt qua ngày, thuê bao, số sai, bấm 1/0 giữa chừng, trần cuộc mỗi số).
- Đường v4 không đổi hành vi (toàn bộ test lịch gọi hiện có vẫn xanh) — đây là bất biến của gói.
- Đột biến do verifier (R3): xoá kiểm khung giờ, trần, kiểm hữu hạn, so sánh người duyệt/người soạn.

## 6. Tích hợp với lịch gọi hiện có (scout 20/11; nguyên tắc: diff nhỏ nhất, đường v4 không đổi)

Hiện nay lịch của job là mảng tĩnh `ivr_call_jobs.attempt_schedule_json`, tính một lần lúc nhận đơn (`TaskIntakeService.cs:975-979`), bộ lập lịch lấy phần tử theo chỉ số `counted` (`PostgresSchedulerStore.cs:244-333`: `counted < max_attempts`, `schedule[counted] <= now < expires_at`, chặn cuộc muộn K-107, nghỉ 60 giây, không có cuộc đang chạy, không tạm dừng hàng đợi). Không có cột "giờ gọi kế tiếp". Kết quả cuối `IVR_NO_ANSWER_FINAL` do `DispositionMapper.ReachedFinalAttempt` (`AttemptNumber >= MaxAttempts || OccurredAt >= hết cửa sổ`); job quá hạn do `CloseMissedDeadlinesAsync`.

**Cách làm: job chế độ luật (`engine_mode`) dùng NGUYÊN đường claim cũ, lịch chỉ được thêm vào cuối (append-only).**
- Lúc nhận đơn: `rule_set_id`, `rule_set_version`, `rule_snapshot_json` (bất biến), `engine_mode=true`; `max_attempts` = `limits.max_total_calls` (≤ 10); `attempt_schedule_json` = `[T0]` (đơn giữ ngoài giờ: `[]` như `HeldCallJobs.NoSchedule` rồi `[T0]` lúc kích hoạt); `attempt_offsets_seconds_json` = `[0]` (offset = giờ − T0, giữ cùng độ dài lịch vì `SchedulerCapacity.CreateQueueItems` ném lỗi khi lệch); `expires_at` = min(T0 + `max_horizon_minutes`, trần giữ đơn của M3).
- Sau mỗi cuộc **có tính lượt** (`ResultRepository.NormalizeNextAsync` → `ApplyJobOutcome`, dòng ~73/380-413): tính nhóm kết quả → gọi bộ máy luật → `CALL_AT t` thì thêm `t` vào cuối `attempt_schedule_json` (+ offset), job về `READY_FOR_SCHEDULER`; `FINISH` thì kết quả cuối (callback, đóng job). Quyết định cuối cùng của bộ máy thay cho `ReachedFinalAttempt` (thêm vào `AttemptNormalizationContext`). Lỗi kỹ thuật không tính lượt: không gọi bộ máy, đường retry kỹ thuật cũ giữ nguyên.
- Bất biến bản chụp: `PersistenceInvariantValidator.cs:81-90,159-180` và trigger DB `W0410HeldOffHoursOrders` (`Migrations/20261001020953…cs:62-102`) hiện chỉ cho đổi lịch lúc kích hoạt đơn giữ → nới **chỉ cho job `engine_mode`**: được thêm đúng một phần tử vào cuối lịch (và offsets), tuyệt đối không sửa phần tử đã có.
- Chặn muộn K-107 / `AttemptStartRules.PolicyLatestStartAt` / giới hạn phiên Giờ Vàng (`PostgresSchedulerStore.cs:278-296`): job luật dùng mốc riêng — giờ gọi đã được bộ máy chọn đúng khung và trần nên mốc muộn nhất = `expires_at`; mốc phiên Giờ Vàng do bộ máy xử lý (`stop_after_session_end_minutes`), claim không xét lại. Coder xác định đúng từng điều kiện SQL, không nới gì cho job v4.
- Khung giờ gọi: cổng giờ hiện có (`CallingWindow.cs`, `SchedulerRuntime.cs:168-182`, config `Ivr:Scheduler:CallingWindow` 08:00–21:08, Giờ Vàng 22:08) **giữ làm vỏ an toàn**: khung của luật chỉ được **hẹp hơn hoặc bằng** vỏ (kiểm ở `:validate`); mở rộng hơn vỏ là việc cấu hình triển khai, ghi nhận để Toàn biết ("cấu hình được hết" có một trần pháp lý/vận hành cố định ở mức triển khai).
- Quét hết hạn (`CloseMissedDeadlinesAsync`, dòng ~554-865): job luật chạm `expires_at` mà chưa kết thúc → có ≥ 1 cuộc tính lượt thì `IVR_NO_ANSWER_FINAL` lý do `HORIZON_REACHED:<nhóm cuối>`; mọi cuộc đều lỗi kỹ thuật → `IVR_CONFIRMATION_WINDOW_EXPIRED` lý do `WINDOW_EXPIRED_ALL_CALLS_TECHNICAL_FAILURE`; chưa gọi cuộc nào → `WINDOW_EXPIRED_BEFORE_FINAL_RESULT`. (Hiện `customerHadEveryCall = CountedAttempts >= MaxAttempts`, dòng ~738.)
- Nơi khác đọc lịch và phải kiểm lại cho job luật: `SchedulerQueueBacklog.cs:65,86-90`, `SchedulerCapacity.CreateQueueItems` (673-745), `EligibilityService.cs:38-60`, `ReadChannelDemandAsync`/`CallingHoursRanOut` (`PostgresSchedulerStore.cs:1064-1131`), `HeldJobActivationBudget.cs`, `ActivateHeldJobsAsync` (932-1056).
- Tệp bị ghim sha256 trong script kiểm: `TaskIntakeService.cs` (opt-out + dial-token bundle validators), `AttemptPolicy.cs` (attempt-policy bundle validator), `ProviderPorts.cs`. Sửa `TaskIntakeService.cs` thì phiên chính **ghim lại hash** ở các validator khi ghép (như các W trước); không sửa `AttemptPolicy.cs`/`ProviderPorts.cs`.
- Đếm cuộc mỗi số mỗi ngày: không lưu số thật; coder đề xuất khoá không PII đã có (hoặc cột băm có muối) và cách đếm nhanh; chốt trong L-02.
- Mỗi route mới còn phải khai ở `deploy/m8/loi-vao/bang-loi-vao.json`, `KdlDanhMucTests.cs`, `deploy/ci/scripts/api-behavior-matrix.mjs` (số operation đang cứng 48) — việc của L-06.
- Chuỗi hợp đồng draft.49: xem danh sách tệp ghim hash và lệnh sinh lại trong báo cáo scout (tóm: sửa tay `ivr-order-confirmation.v1.yaml` + baseline + `contract-freeze-verifier.mjs` + changelog; sinh lại NSwag `regenerate-openapi.ps1`, `contract-freeze-verifier.mjs --write`, `build-api-docs.mjs`, `database-docs.mjs --write`, `generate-test-traceability.mjs`, `gate-status.mjs --write`; phiên chính làm lúc ghép).

## 7. Chưa biết / để coder đo
- Cách đếm cuộc mỗi số mỗi ngày đủ nhanh ở lúc lên lịch và lúc quay số, và khoá không PII dùng để đếm.
- Điều kiện SQL claim nào của job luật cần nhánh riêng (K-107, giới hạn phiên): coder đọc và nêu trong báo cáo.
