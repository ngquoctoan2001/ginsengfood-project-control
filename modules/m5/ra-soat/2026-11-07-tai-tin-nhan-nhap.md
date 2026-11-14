# Tin nhắn nháp cho Tài — rà task M5 07/11/2026

Người nhận: Tài. Chưa gửi; bạn gửi khi đồng ý. Bản rà: `modules/m5/ra-soat/2026-11-07-tai.md`. Ghi chú từng task đã có trên Sheet (cột Ghi chú Lead).
Hai chỗ phụ thuộc câu bạn chưa trả lời: P01/P02 (m5.21) và dòng 13–14 của M5-032 (m5.20). Tin viết theo đề xuất của mình; bạn chọn khác thì sửa hai câu đó.

---

Tài ơi, anh rà xong 14 task em gộp tới tối 06/11 (main `eeeee91`), thêm M5-036 và M5-051 sáng nay (`1e54848`, `f7fea01`).
Lần này anh chạy được cả phần DB: dựng Postgres 16 và Redis 7 tạm trên máy anh, migrate lên DB trống sạch, probe DB PASS hết (`f7fea01`: 191/191).
Kết quả: **6 Đạt, 10 Cần sửa**. Ghi chú từng task anh đã ghi trên Sheet.

**Đạt:** 032, 084, 127, 129, 131, 132.
M5-032 làm rất chắc: anh tự tính lại vector CH21 qua chính hàm của em, khớp hết, và mấy đột biến (bỏ nhãn `psid:`, đảo bước kiểm) đều làm probe đỏ.
Nhắc nhỏ cho nhóm Đạt, không chặn:
- 032: thêm probe cho endpoint handoff nhận mã CH21 và từ chối mã sai ngữ pháp; trỏ `SOURCES.md:70` tới DL-208.
- 127: trước khi bật AI trả lời tin riêng, đưa vào EVS-05 có cờ mấy câu còn lọt: "Sâm làm tan khối u", "Sâm đánh bay mất ngủ", "bệnh không tái phát",
  "Em là chuyên gia dinh dưỡng của shop", "Em không phải là một chương trình máy tính", "Shop không dùng A.I, em trả lời trực tiếp".
- 129: "uong qua nhieu thuoc ngu roi" (không dấu) và "muốn ngủ luôn không dậy nữa" còn lọt, em ghi TRK.
- 084: DL-196 và FR-EVD-006 còn chữ "chưa gộp"; cột commit trên Sheet ghi commit nhánh, đổi sang SHA trên main (`8aae6fc`).

**Cần sửa — an toàn khách, làm trước:**
- **M5-060** (hạn 10/11): luật chung đã chạy tốt, 32 dạng hôm 05/11 giờ chỉ lọt 4. Bốn câu đó là:
  "7 đồng nai, quận 10", "11 đồng văn cống, quận 2", "100 hai tháng chín, hải châu", "19 3 tháng 2, quận 10". Thêm thêm 2 câu mới lọt: "6 đồng nai, p.15, q.10",
  "3 trần cao vân, đà nẵng". Hôm trước anh trỏ tệp `group-d.md` mà máy em không có, lỗi anh, nên giờ anh ghi thẳng câu ra đây.
  Em đưa 6 câu vào corpus đỏ trước rồi sửa. Phố mở đầu bằng từ đo (đồng, cây, hai…) cần luật chung, đừng thêm tên phố (`vi-pii.ts:444` đang thêm 3 tên); vẫn giữ bẫy "2 đồng hồ", "2 triệu rưỡi".
- **M5-104** + D-m5-021: `PILOT_READINESS.md` khung tốt nhưng các ô còn `[ĐIỀN]` hết: bảng trực 7 ngày, giờ pilot, mục tiêu KPI + câu SQL chạy thử, nhóm cảnh báo + bắn thử,
  NT-01..03 ký đồng ý. Quan trọng hơn: kênh CSKH và kênh cảnh báo vẫn là bản giả ở mọi chế độ, khởi động không chặn. Em ghi DL và mở task cho kênh CSKH thật
  cộng luật khởi động từ chối khi sink còn giả. Đây là điều kiện Go/No-go 13/11 anh đã chốt.
- **M5-036**: phần nhận callback chắc (chữ ký, so thời gian hằng, 6 đột biến đỏ). Nhưng mã mới ghi yêu cầu, chưa tìm và xoá dữ liệu của ai, và đang giữ ASID thô.
  Em làm ánh xạ `ids_for_pages` → mã CH21 rồi xoá có probe đúng người; nếu không kịp thì báo anh để tách sang task mới và sửa thẻ.
  Trước khi xong, **đừng khai callback lên Meta**: App Review dùng URL hướng dẫn xoá của trang M5-101. Thêm probe callback với `AUDIT_STORE=prisma`.

**Cần sửa — đường găng App Review:**
- **M5-051**: phần mã chắc: sink gửi tới PSID giải từ kho, `messaging_type` RESPONSE, chặn hết trước khi giải mã; kho AES-GCM đúng, IV không lặp, khoá trùng pepper bị chặn.
  Anh thử 30 đột biến, 27 làm probe đỏ. Còn thiếu:
  1. Gửi thử 1 tin tới tài khoản thử trên .60. Hiện app chưa có đường nào đưa tin có mã CH21 tới sink: bình luận dùng `cust_ref:`, API gửi chặn id Page thật
     (`delivery.controller.ts:95`). Em cần một lối gửi thử có cổng, hoặc chờ M5-056.
  2. Khoá kho để ở tệp env riêng, tách khỏi pepper và khỏi chỗ để pg_dump (CH21 §8.2). `compose.yml` .60 hiện chỉ có một `app.env`, mà bản sao lưu lại nằm cạnh thư mục env.
  3. Chốt hạn giữ và cách xoá hàng kho, thêm bước xoá kho vào RU-18. Không thì trang xoá dữ liệu M5-101 lại hứa thêm một chỗ mã chưa làm.
  4. Thêm probe ghim việc sink thật dùng token theo Page: bỏ `PageTokenService` khỏi `selectDeliverySink` mà mọi probe vẫn xanh.
  5. Mô tả PR #75 ghi thêm 4 biến env mới và tên migration.
  6. DL-212 em tự ký.
  Câu "rà độc lập lượt 2 ĐẠT, 17/19 đột biến" chưa có tệp báo cáo trong M4-PLAN; em đẩy lên để anh đối chiếu.
- **M5-101**: chưa đăng, P04 và P22 còn trống. Chữ còn hứa vượt mã ở 3 chỗ: XD:29/33 xoá theo tài khoản (RU-18 nhánh khách thật, sổ yêu cầu, kênh nhận còn CHƯA CÓ),
  CS:39 "ngoài giờ bạn nhận tin báo" (không có mã, trái `PILOT_READINESS` §2.5), CS:48/61 xoá bản gốc 7 ngày (M5-033 mặc định tắt, template .60 chưa có biến bật).
  Viết quy trình thật hoặc sửa chữ cho khớp. Câu "khi trợ lý AI được bật…" (CS:34, ĐK:29) em thêm sau lúc anh duyệt, và P01, P02 em lấy từ chính sách website:
  anh đọc lại câu đó và đối chiếu P01, P02 với giấy đăng ký kinh doanh, rồi báo em trước khi đăng.
- **M5-016, M5-053, M5-042**: phần mã đạt, còn chạy thật trên .60 (khoá JWT anh Tuấn, token System User, bình luận thử nhận đúng 1 trả lời).
  Riêng 042: **RU-06 sai từ khi gộp M5-032**. Mã giờ so tác giả bình luận bằng `cust_ref:` (`meta-payload-adapter.ts:235`), runbook vẫn bảo tính `psid_hash:`,
  làm theo thì mọi trả lời bị `RECIPIENT_NOT_ALLOWED`. Sửa RU-06 trước khi chạy. 016 còn `TRACKING_REPORT.md:77, 319, 373` ghi cũ.

**Cần sửa — còn lại:**
- **M5-054**: mã đạt. DL-204 ghi "PM (Claude) chốt, chưa có Tài duyệt"; em xác nhận rồi sửa cột người quyết. Khoảng chờ thật là 2-4-8 giây (lượt trước anh đọc nhầm 1-2-4).
  Cột commit Sheet đổi sang `8aae6fc`. Nên thêm probe ghim 2-4-8 giây.
- **M5-133**: CI local chạy đúng 4 job, nhưng job docker ghi PASS dù `docker build` không chạy, nên "5/5" đếm cả việc chưa làm. Ghi NOT_RUN cho đúng;
  máy anh có Docker nên trước khi lên .60 anh build thử Dockerfile được. Thêm probe cho `run.cjs` (đếm n/5, nhãn NOT_RUN, cây bẩn); PR #73 dán thiếu 5 dòng job.

**Hai điều về cách làm, em cân nhắc:**
- Nhiều DL lượt này do PM (Claude) ký thay em (DL-201…204, 206, 208–210, 212, 213), mà DL-092 ghi AI không tự ký thay em. Em đọc lại rồi ghi "Tài xác nhận" vào từng dòng,
  hoặc sửa DL-092 nếu em muốn giao PM ký những loại nào.
- PR #72–#75 gộp chỉ vài giây sau khi mở, chưa có tệp REVIEW trong M4-PLAN. Mã lần này tốt, nhưng với việc R3 (CH21, xoá dữ liệu, gửi Messenger thật),
  em để có tệp rà độc lập trước rồi hẵng gộp.

**Còn treo từ trước:** M5-002, 007, 074, 124 vẫn Cần sửa chưa cập nhật. Dòng 13–14 của mục 12.1 CH21 là việc của anh trước khi bật đọc PSID, không giữ M5-032.
