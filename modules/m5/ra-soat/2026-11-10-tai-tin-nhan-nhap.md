# Tin nhắn nháp cho Tài — rà task M5 10/11/2026

Người nhận: Tài. Chưa gửi; bạn gửi khi đồng ý. Bản rà: `modules/m5/ra-soat/2026-11-10-tai.md`. Ghi chú từng task đã ghi trên Sheet (cột Ghi chú Lead) lúc 15:25.
Câu Dockerfile theo D-m5-029 (10/11 16:27, bạn chọn B: Tài build ở bước triển khai .60).

---

Tài ơi, anh rà xong 8 task M5 đang chờ (main `226e18a`, chiều nay). Anh tự chạy lại hết trên máy: typecheck sạch, probe không DB, probe DB trên Postgres/Redis tạm.
Kết quả: **2 Đạt, 6 Cần sửa**. Ghi chú từng task anh đã ghi trên Sheet. Phần lớn task Cần sửa là mã đã đạt, chỉ còn thủ tục hoặc phần chạy trên .60.

**Đạt:** 054, 064.
- 054: việc lần trước xong cả, ca S6 ghim 2-4-8 giây bắt đúng đột biến. Nhắc nhỏ: khoảng 10 chỗ tài liệu còn ghi "M5-054 nhánh, chưa gộp",
  sai nhất là `state-machines.md:487` ("trên main RETRYING vẫn là điểm dừng"). Cột mã DL-204 cũng còn câu "Còn thiếu: Tài duyệt".
- 064: chắc tay, đột biến nào cũng đỏ. Một điểm cần nhớ khi làm TRK-44: opt-out bên Messenger chưa chặn tin riêng trả lời bình luận,
  vì bình luận dùng khoá `cust_ref`, khác mã CH21. Phải xử lý trước khi bật private reply cho khách thật.

**Cần sửa, vùng dữ liệu khách và bảo mật (em làm trước):**
- **M5-126**: mật khẩu viết bằng lời vẫn lọt cả bộ che lẫn FinalGuard, nên đi thẳng vào prompt M4, và M4 viết lại thì tới tay khách. Các mẫu anh thử:
  "mk là Sam@Vang", "MK: hoaSen99", "pass là …", "pass: …", "password là …", mật khẩu trong nháy ngược ”…”, "Mã OTP **482913**", "Mật khẩu - …".
  Em vá rồi thêm các ca vào probe. Mẫu nào em muốn để sau thì tự ghi chấp nhận vào DL-214. Vùng bảo mật thì em hoặc anh chốt, PM không để backlog thay được (N25–N28).
- **M5-135**: phần mã chính tốt (117/117, đột biến đỏ hết). Còn mấy việc:
  1. Probe DB `prisma-data-deletion-erasure-db` E4, E5 đỏ trên `226e18a`. Anh chạy lượt đầy đủ, chạy riêng, rồi chạy trên DB mới, cả ba lần đều đỏ.
     Em ghi 205/205 trên `4562142`, nên có thể đỏ do lúc gộp main.
  2. DL-217 vẫn "CẦN XÁC NHẬN — chờ Tài", chỉ phần SALE_LOCK/RECALL là em đã chốt. Đây là dữ liệu khách nên em đọc rồi ký.
     Trong đó chốt luôn app token hay token Page: DL-213 em ký ghi app token, còn mã đang dùng token Page.
  3. Thêm `EVIDENCE_STORE` vào `STORES` của CLI, kèm probe.
  4. Mẫu env .60 hiện chỉ có 2/7 kho, nên lệnh `run` trên .60 sẽ giữ mọi yêu cầu `STORE_NOT_REACHED`. Đặt đủ 7 kho là `prisma`,
     và bật purge cho `meta_webhook_event`, chỗ còn câu chữ của khách.
- DL-215 mục (5): OPT_OUT giữ vô thời hạn kể cả khi khách đòi xoá, vẫn ghi "chờ Tài". Em chốt luôn khi ký DL-217.

**Cần sửa, còn lại:**
- **M5-043**: mã đạt, sink handoff hết đường tắt rồi. Còn kiểm trên .60 khi có HTTPS: bình luận hỏi giá nhận đúng 1 tin theo comment_id,
  Meta gửi lại hoặc khách sửa bình luận thì không gửi lần 2, bật `disable_private_reply_from_comment` thì endpoint BLOCKED. Dán log vào thẻ.
  SMK-003/016 đang ghim "2 tin riêng" ở full pipeline giả, nhớ sửa khi M5-056 bỏ W4.
- **M5-055** và **M5-133**: chung một chuyện. PR #80, #81 gộp sau 8–12 giây, mô tả trống, không có khối CI_LOCAL. Status `ci-local` chỉ có tới #79.
  Anh biết em có chạy cổng, vì khối nằm trong `PR_BODY.md` ở M4-PLAN. Em dán khối đó vào #80, #81 (#80 ghi thêm migration `messenger_ai_label`,
  #81 ghi biến `M5_SHOP_PUBLIC_CONTACTS_JSON`). Status thì đăng cho head #80–#85, hoặc sửa DL-211 và §2.4 điều 4 cho khớp cách em làm thật.
  Phần mã của 133 thì đạt: 4 việc lần trước xong, probe `run.cjs` 33/33.
- **M5-136**: 7/8 mục đạt. Mục 5: probe `data-deletion-audit-store` ở chế độ DB in ALL PASS rồi tiến trình sập lúc thoát
  (`UV_HANDLE_CLOSING`, Node 24.19 trên Windows), nên runner ghi FAIL cả 3 lần. Em đóng Prisma hoặc app cho xong trước `process.exit`
  (hoặc dùng `process.exitCode`) rồi nộp lượt DB xanh.

**Mấy việc anh cần em xem thêm:**
- Bốn task 016, 036, 042, 051 em sửa trong #84 nhưng chưa cập nhật dòng Sheet, nên chưa vào hàng rà. Em cập nhật thì anh rà.
  Phần còn lại của từng task ngoài #84: 042 `TEST_STRATEGY.md:596` còn ".63" và "lấy mã từ DB", trái RU-06; 016 `TRACKING_REPORT.md:795`;
  051 khoá kho để env riêng, PR #75 ghi env và migration.
- Còn treo Cần sửa chưa cập nhật: 002, 007, 053, 060, 074, 101, 104, 124. Riêng M5-104 (kênh CSKH thật) là điều kiện mở pilot.
- Trên máy anh, probe `prisma-m4-conversation`, `prisma-rollback-flag-store` (DB) và `main-process` (không DB, kiểm E1) đỏ cả khi chạy riêng. Mã mấy chỗ này không đổi từ 07/11 nên nhiều khả năng do máy. Em chạy lại bên em giúp anh.
- Dockerfile chưa ai build từ 06/11, kể cả bản 09/11 thêm UI. Em build ở bước triển khai .60, trước khi chạy smoke, rồi ghi kết quả (đạt hay lỗi, SHA)
  vào thẻ triển khai. Lỗi thì sửa xong mới chạy .60.
