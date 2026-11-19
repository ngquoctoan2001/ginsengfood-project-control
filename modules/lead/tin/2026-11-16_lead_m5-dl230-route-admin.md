Gửi Tài · 16/11/2026 · từ Toàn
Việc: Toàn duyệt DL-230 (cách tính SMK cho pilot) và chốt cách xử lý hai route admin cũ + T4, T6 của M5-112, vì DL-231 mở /api/admin/ và /api/channel/meta/ ra Internet.
Vì sao: DL-230 (DECISION_LOG.md:651 @6ee2bedc) còn 4 điểm chờ Toàn: (3b), (3c), (4), (5). Phiếu 57 mục "Chưa chắc" của M5-121 (16/11) thấy DL-231 làm T12, T6, T4 nặng hơn, nâng lên "trước pilot".

Toàn chốt 16/11 20:37 (em ghi vào DL, dẫn lời Toàn):
F. Duyệt DL-230 theo đề xuất trong DL:
   (3b) HIDE_FLAG_BLOCK_ADAPTER vào danh sách "ngoài phạm vi pilot"; giữ scoped-send-posture.ts:58 (pilot không ẩn, không chặn bình luận thật).
   (3c) AI_ADVISOR, SPOTLIGHT_SINK vào danh sách. Ba nguồn suppression CRM_SUPPRESSION_SOURCE, OPERATIONAL_SOURCE, GATEWAY_CHANNEL_STATE cũng vào danh sách;
        SMK-009, 010, 011, 012, 013 ghi "chỉ chứng minh luồng, nguồn dữ liệu giả". CSKH_SINK của rate-moderation KHÔNG vào danh sách: phải đi kênh CSKH thật cùng M5-104.
   (4)  CSKH_ALERT_SINK và ALERT_SINK thật bắt buộc. HANDOFF_SINK, DELIVERY_SINK, SIGNATURE_VERIFIER, RATE_LIMITER (Redis), WINDOW_CHECK (real), FINAL_GUARD,
        PAGE_REGISTRY chạy lớp thật trên .98, không vào danh sách.
   (5)  SMK-008 (TYPING_EMITTER) và SMK-014 (ORDER_STATE_READER) ghi NGOÀI PHẠM VI PILOT: không tính đạt, không tính trượt. Cổng pilot đạt khi không dòng nào KHÔNG ĐẠT
        và mọi dòng còn lại ĐẠT (pilot). SKIP không phải PASS.
   Production 30/11 giữ NFR-OBS-06 nguyên văn (M5-115): không phần mock nào được tính.
G. Hai route admin cũ GET /api/admin/facebook/events và GET /api/admin/gateway/evidence (admin-read.controller.ts:25, :34; M5-112 M4 = T12) gỡ khỏi mã trước khi mkt. có HTTPS.
   Tuyến mkt. của DL-231 giữ nguyên, không thêm luật nginx cho hai đường này.
H. Thêm vào điều kiện Go/No-go (Done Gate mục rà bảo mật):
   T4: chữ ký webhook sai không làm DB tăng theo số lần gửi (hiện mỗi lần ghi signature_trace + audit + quarantine_log, channel-identity.resolver.ts:300-312).
   T6: mỗi người một JWT, sub riêng; hạn pilot ngắn (em chốt số ngày, trong trần 30 ngày đã chốt); runbook có bước thu hồi khẩn bằng đổi khoá công khai.

Cần làm:
1. Ký DL-230 kèm câu "Toàn duyệt 16/11/2026 20:37" và nội dung F. Ký DL-228 kèm cách phát JWT ở H (T6).
2. Mở task code theo DL-230 (6): rollup.ts:131 nhận danh sách F khi tư thế là chế độ phạm vi, vẫn đòi danh sách rỗng ở production; sửa smk-evidence-package.probe.ts; thêm câu riêng cho pilot ở NFR-OBS-06 (SRS).
3. CSKH_SINK của rate-moderation (rate-moderation.module.ts:61 đang MockCskhSink) nối lớp thật dùng chung kênh của M5-104; chế độ phạm vi từ chối khởi động khi nó còn giả (như D-m5-021). Gộp vào cụm M5-104/M5-081B.
4. Task gỡ hai route ở G: probe đỏ trước (gọi hai route phải ra 404), gỡ, CI_LOCAL GATE=ĐẠT dán vào PR, gộp trước khi anh Tuấn bật HTTPS. Sửa api-catalog.md §2.1 theo DL-231 (.98, bốn nhóm đường ra Internet). Ghi DL mới cho G và H.
5. Task T4: chữ ký sai chỉ tăng metric + một dòng gộp theo cửa sổ (PA1 trong phiếu), không ghi ba dòng mỗi lần.
6. T6: runbook ghi cách phát JWT (mỗi người một sub, hạn pilot) và bước thu hồi khẩn.
Xong khi: DL-230, DL-228 ký; hai route trả 404 trên main có GATE=ĐẠT trước HTTPS; probe gửi N lần chữ ký sai → số dòng ba bảng không tăng theo N; runbook có mục phát + thu hồi JWT; hồ sơ Go/No-go 0.6 có ba dòng T12, T4, T6.
Hạn: hai route 18/11 (trước HTTPS) · DL, roll-up, T4, T6 19/11 · báo lại bằng: PR + dòng Sheet (task mới mở trên tab M5).
