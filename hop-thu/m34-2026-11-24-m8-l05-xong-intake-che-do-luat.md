# Từ phiên m8 · 24/11/2026 · L-05 xong phía M8: intake chế độ luật (hợp đồng draft.49 đổi hash)

L-05 (W-0558) đã xong và commit ở repo ivr (`c2bb7064`, nằm trong `main` đã lên origin + GitHub 25/11 07:26 cùng L-07; **chưa lên .99**; push và lên .99 chỉ khi Toàn nói trong phiên m8). Tài liệu cho m34 nằm ở
`C:\Projects\ginsengfood-ivr\docs\operations\call-rules-intake.md` (§1 chọn chế độ, §4 bảng lỗi, §7 ack, §9 việc của m34). L-07 (gọi lại thủ công) chưa làm: **M3 chưa lật cờ luật gọi cho tới khi m8 báo L-07 xong.**

- **Hợp đồng draft.49 đổi hash** (sửa tại chỗ, chưa phát hành): `c5f10955…1ac8` → `26a7bbe5df9367c76978b800582130f33e15534ccdbdcb2a07c484d1897bc729`. Callback không đổi (`323ba1d2…`). Ba trường `attempt_policy_version`, `max_customer_attempts`, `attempt_offsets_seconds` ra khỏi `required` của thân intake. m34 ghim lại hash khi nhận bản mới.
- **Cách gửi:** đủ ba trường = v4 y nguyên; **vắng cả ba (không gửi khoá, không gửi null)** = chế độ luật; một hoặc hai = 400 `IVR_MALFORMED_REQUEST` nêu trường thiếu. Đợt thử MobiFone ~24/11 vẫn gửi đủ ba trường (v4).
- **Chế độ luật chỉ nhận khi M8 bật cờ** `Ivr:CallRules:IntakeMode=RULES_ALLOWED` cùng muối `Ivr:CallRules:PhoneKeySalt` (bí mật, ≥ 16 ký tự). Mặc định `V4_ONLY`: thân thiếu ba trường nhận đúng 400 cũ. Cờ này là việc của m8 + Phúc khi lên .99, không phải của M3.
- **Không có luật ACTIVE cho chương trình:** 200 `TASK_HELD_POLICY_MISSING` + `blocked_reasons: ["RULE_SET_NOT_ACTIVE"]`, không có `ivr_call_job_id`, không rơi về v4 (đúng điều đã chốt ở `decisions_for_m34.4`). Thiếu muối: 200 `TASK_BLOCKED_OPERATIONAL` + `PHONE_KEY_SALT_UNAVAILABLE` (lỗi cấu hình M8, báo vận hành). Luật dùng mốc phiên Giờ Vàng mà thiếu `session_ends_at`: 400 nêu `session_ends_at`.
- **Ack thêm:** `call_rule_set {id, version, program_code}`, `first_call_due_at`, `planned_horizon_at` (chỉ ở chế độ luật). **Không có `earliest_final_at`** của bản đọc được 20/11, đã bỏ khỏi `wp/luat-goi-hop-dong-draft49.yaml`. `planned_horizon_at`: job chạy ngay = `expires_at` của job; đơn giữ ngoài khung giờ = `confirmation_window_expires_at`. Watchdog của M3 đặt sau mốc này.
- **Đơn tới ngoài khung giờ luật:** được nhận và giữ tới khung kế (ack có `first_call_due_at`), không từ chối.
- **Gọi lại (`recall_of_task_id`) ở chế độ luật: ĐÃ ĐƯỢC NHẬN từ L-07** (câu "409 tới L-07" ở bản đầu hộp thư này đã hết hiệu lực); xem hộp thư `m34-2026-11-24-m8-l07-xong-goi-lai-che-do-luat.md`. Hash draft.49 ở trên cũng đã thay: ghim hash cuối ở hộp thư L-07.
- **Phát lại:** cùng khoá + cùng thân trả đúng ack đã lưu dù luật ACTIVE đã đổi. Nếu cờ về `V4_ONLY` mà M3 gửi lại đơn chế độ luật thì nhận 400 (không phát lại ack).
- **Chưa kiểm độc lập:** gói Thường, chưa đột biến, chưa verifier (cổng Nguy hiểm 25–27/11), chưa chạy trên .99 (L-10 là chỗ M3 và M8 thử đầu–cuối với MOCK sau khi Toàn nói).

Đọc xong chuyển sang `hop-thu/xong/`.
