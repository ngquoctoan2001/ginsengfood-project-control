# Tin nhắn nháp cho Tài — rà task M5 12/11 + 13/11/2026 (một tin cho 20 task)

Người nhận: Tài. Chưa gửi; bạn gửi khi đồng ý. Bản rà: `modules/m5/ra-soat/2026-11-12-tai.md` (16 task) và `2026-11-13-tai.md` (4 task).
Ghi chú từng task đã ghi trên Sheet (cột Ghi chú Lead) lúc 13/11 07:08 và 08:06.
Bạn đã duyệt m5.27, m5.28, m5.29, m5.6 lúc 13/11 07:39 (D-m5-030…033), các câu đó đã viết theo quyết định.
Bạn đã chốt m5.30–33 lúc 13/11 08:40 (D-m5-034…037) và m5.21, m5.34 lúc 09:11 (D-m5-038, D-m5-039). Mọi câu đã viết theo quyết định, không còn câu đề xuất.
Gửi từ dòng sau dấu `---` tới hết.
Tin này thay tin nháp 10/11 nếu bạn chưa gửi tin đó. 13/11 chiều: đổi .60 thành máy mkt .98 theo D-m5-040 (máy chủ chính thức).

---

Tài ơi, anh rà xong 20 task M5 đang chờ: 16 task trên main `c8cdd47`, và 4 task em gộp tối qua (017, 103, 114, 121) trên `2f733b2`.
Anh tự chạy lại trên máy: typecheck sạch, toàn bộ probe không DB, probe DB trên Postgres/Redis tạm, cả `web/`.
Kết quả: **2 Đạt, 18 Cần sửa**. Ghi chú từng task anh ghi trên Sheet ở cột "Lead duyệt" và "Ghi chú Lead" (cột Trạng thái là của em nên anh không đổi).
Phần lớn task Cần sửa là mã đã đạt, chỉ còn chạy trên máy mkt .98 hoặc chờ chốt.

**Đạt:** 124, 136.
- 124: N-1 chốt ở DL-223 rồi, test M4 có trên `origin/dev`, cổng M5 vẫn giữ. Khi mở AI tin riêng sau pilot (M4-009) thì nhớ rà lại DL-223.
- 136: mục 5 nay thoát sạch, lượt DB xanh cả hai lần anh chạy.

**Cần sửa, vùng dữ liệu khách và bảo mật (em làm trước):**
- **M5-135**: EVIDENCE_STORE và mẫu triển khai 11 kho xong rồi. Anh thấy thêm một lỗi chặn: `deploy/m5-60/db-setup.sql:29` thu quyền UPDATE `audit_log` của `m5_app`,
  mà kế hoạch xoá lại UPDATE `audit_log.target_ref` (`subject-erasure.ts:77`). CLI chạy bằng `m5_app`, nên trên máy chạy thật lần xoá nào cũng quay lui `STORE_ERROR`.
  Probe DB chạy bằng superuser nên không bắt được. Anh nghĩ nên tạo role riêng cho CLI xoá, chỉ có UPDATE cột `target_ref`, để `m5_app` vẫn chỉ ghi thêm vào `audit_log`;
  em thấy cách khác hợp hơn thì cứ làm. Nhớ thêm một probe chạy dưới đúng role đó.
  Còn lại: ký DL-217 và chốt app token hay token Page (`subject-erasure.ts:191`); bật purge `meta_webhook_event` có hạn; chạy CLI trên .98.
  Probe DB E4/E5 trên máy anh vẫn đỏ: 5 lượt, Node 24.19, cả DB mới sáng nay; E0–E3 thì xanh. Em ghi xanh trên Node 24.22.2,
  nên em xem giúp anh vì sao lệch, rồi nộp lượt xanh.
- **M5-036**: callback vẫn ổn. Chờ 135 xong, chạy CLI với token thật trên .98, rồi mới khai callback lên Meta. Khai trước thì ASID thô nằm lại trong `data_deletion_request`.
- **M5-126**: chưa có sửa mới, `masking.ts` vẫn như cũ. 9/9 mẫu vẫn lọt, thêm mẫu "pw: …". Em làm lượt a5: vá, thêm ca probe cho 3 cột DB và đường gửi M4.
- **M5-112**: bản rà ổn. Còn: H1 (là 126) và H2 (TODO `comment-boundary.resolver.ts:231`, M5-140 chưa có mã) phải vá rồi rà lại;
  rà bổ sung 3 PR sau `a3807706` (vault/m5.sh, CLI xoá, `vi-pii.ts`); mục quyền `audit_log` nên nâng lên Cao vì nó chặn hẳn việc xoá dữ liệu; nâng gói eslint của `web/` (7 moderate).
- **M5-051**: phần `vault.env` riêng xong, 3 đột biến đều đỏ. Còn: gửi thử trên .98; ký hạn 48 giờ ở DL-217 (5) rồi lập lịch `purge-vault`;
  mô tả PR #75 ghi thêm `PSID_VAULT_STORE`, `M5_PSID_VAULT_ACTIVE_KEY` và migration `m5_051_messenger_psid_vault`.

**Cần sửa, mã đạt, còn chạy trên .98:** 016, 053, 042, 056.
- 016: lấy khoá công khai, iss/aud, claim vai từ Anh Tuấn, chạy 200/403 và CLI mã 0/3 bằng token thật.
- 053: tạo token System User 60 ngày, chạy `tools/ops/page-token.cjs` trên .98, ghi ngày/hạn/người làm.
- 042, 056: chạy với token Page thật, nộp bằng chứng. 056 còn DL-224 ý (2) tin tự hại Messenger và ý (5) báo CSKH mỗi tin khi người trực đang trả lời, em chốt giúp anh.
- Một chuyện chung: gửi thử trên .98 của 042, 043, 051, 053, 056 đều bị cổng khởi động chặn (`always-on-posture.ts:116-117`) khi sink CSKH/cảnh báo còn giả.
  Vậy M5-081 phần B / M5-104 là việc phải xong trước cả cụm này. Em xếp lịch nó trước nhé.

**Cần sửa, chờ chốt:**
- **M5-060**: corpus 1218 ca 0 lọt 0 che nhầm, 6 câu anh đưa đều che, tốt. Anh nhận phương án (a) của DL-225: che thừa thì chuyển người, đếm số câu bị `PII_REVIEW`
  khi pilot. Anh cũng nhận giữ 3 tên phố tĩnh và 8 tên phố họ Triệu như danh sách phụ. Hai câu còn lọt ("12 triệu thái, quận 1", "ship tới 45 đồng khánh") em ghi vào TRK-22.
  Em ký DL-225 là xong phần quyết. Probe thời gian anh chạy lại lúc máy rảnh thì xanh.
- **M5-122**: mã đạt. Còn: chốt DL-222 (opt-out/cờ dừng có chặn tin chuyển người không, 3 câu về 3.4); sửa `text-set-v1.md` chỗ còn ghi "nhánh chưa gộp".
  Chữ 3.4 anh duyệt nguyên văn như `text-set-v1.md:98`, em ghi vào DL-222 và bỏ dòng "chưa được Toàn duyệt". PR #94 gộp khi CI_LOCAL đang `GATE=KHÔNG ĐẠT`, lần sau em đợi xanh rồi gộp.
- **M5-101**: CS:39 xong. D1 (kênh email/tin nhắn chưa có lệnh xoá đúng người): em với Anh Tuấn chọn PA1 hay PA2. Anh nghiêng PA1, vì PA2 không phủ người chỉ bình luận.
  Chọn xong gửi anh câu chữ. Phần chữ còn lại anh giao em, anh chỉ đối chiếu P01/P02 với giấy đăng ký kinh doanh và đọc câu "Khi trợ lý AI được bật…" trước khi đăng.
  Sau đó bật purge trên .98, điền P04/P22, đăng Pages, dán URL vào app Meta. README §3.5 dòng D2 còn ghi "M5-122 chưa gộp".
- **M5-007**: anh duyệt §5 bản `f774f759`, chỉ sửa một chỗ: §5.4 điều 4 bỏ status `ci-local`, giữ khối CI_LOCAL dán trong PR (xem mục status bên dưới).
  Em sửa xong thì PM bỏ chữ "chờ Toàn duyệt" ở `SPRINT_PLAN:129` rồi cập nhật dòng Sheet, anh chấm Đạt.

**M5-139**: bước 1–3 đạt (65/65 mã màu khớp kit M3, Inter tự lưu, không CDN). Tiêu đề task có "khung AppShell" nhưng bước 4 chưa làm
(thanh bên, màn hẹp, bỏ token tạm `brand-50/700`, `topbar`, nút `inverse`; `AppShell.tsx:54,156,164`). Em làm bước 4 hoặc tách task mới rồi sửa tiêu đề. Sheet đang ghi 100%.
PR #95 không có khối CI_LOCAL; `ci-local` chưa chạy phần `web/`, em thêm typecheck, lint, vitest của `web/` vào cổng.

**4 task gộp tối qua (cả 4 Cần sửa):**
- **M5-017**: làm chắc. Đủ 5 cổng, luật 3 đã dời, 3 probe mới xanh, anh thử 11 đột biến thì bắt được 9. Còn hai việc:
  1. Câu DL-163 "danh sách trang, không xét tác giả" có áp cho cả tin riêng ở production không, hiện mới chỉ nằm ở PR và Sheet. Đây là phạm vi pilot nên em chốt rồi ghi một dòng DL.
     Anh nghiêng giữ như mã đang làm (tin riêng cũng giới hạn Page), vì hẹp hơn.
  2. `single-send-door.probe.ts:103` chỉ bắt đúng tên lớp. Anh đặt bí danh `const C = MessengerSendSink; new C(deps).send()`, hoặc viết `class X extends MessengerSendSink`,
     gọi `.send()` ngoài dispatcher, thì probe vẫn xanh. Hai đường này bỏ qua suppression, cửa sổ 24h, FinalGuard và idempotency. Em giới hạn chỗ được import 3 lớp sink thật,
     cấm `extends`, rồi thêm self-check cho cả hai kiểu.
  Hệ quả em đã ghi: production không khởi động khi `ORDER_STATE_READER` còn giả. Anh chốt: pilot chạy chế độ phạm vi như đã định; production cần reader thật.
  Phúc làm API đọc trạng thái đơn bên M3, em viết reader thật + probe, cả hai xong trước 30/11. Anh giao task riêng trên Sheet kèm file .md có sơ đồ và khung hợp đồng.
  Đừng dán `REAL` lên mock để mở đường.
- **M5-103**: 4 tệp viết khớp mã, không có chuỗi nhạy cảm. Chưa gửi pháp chế nên chưa Đạt được. B1: **Có**, pilot bật AI cho tin riêng Messenger, dùng Claude API.
  B3: Không, chưa có văn bản pháp chế thì người thử nội bộ cũng chưa đi qua LLM ngoài. Anh đồng ý chia 2 đợt: đợt 1 các câu chặn dữ liệu khách thật và chữ công khai;
  đợt 2 các câu chặn bật AI. `AI_ADVISOR_MODE` để trống trên .98 tới khi đợt 2 có văn bản, nên đợt 2 giờ nằm trên đường găng của pilot có AI. B2, B4, B5 em điền (B5 anh nghiêng gửi M5 trước). Em thêm vào DPIA 9.6 và LEGAL_PACKAGE §3 lỗi quyền `audit_log`,
  kẻo pháp chế đọc thấy "xoá theo yêu cầu: Có" mà trên máy chạy thật lệnh xoá lại quay lui. Gửi xong, có văn bản thì ghi DL.
- **M5-114**: hồ sơ trung thực, anh đọc thấy không có chỗ nào tô hồng. Anh chọn **A**: No-go lượt này, họp lại 2 ngày làm việc sau khi `mkt.` trên .98 có HTTPS, chậm nhất 20/11, hạn 30/11 giữ.
  Em ra bản 0.6 theo main mới: thêm E4/E5; đưa lỗi `audit_log` lên chặn trước App Review và pilot; ghi luôn chuyện cổng smoke đang đòi `AI_ADVISOR` thật trong khi AI còn tắt tới đợt 2 pháp chế,
  đề xuất cách tính SMK trên .98 bằng một DL; ghi DL Go/No-go thay DL-200 (1) theo D-m5-028.
- **M5-121**: trace, check-links, 16 nhãn FR, endpoint, biến môi trường anh lấy mẫu đều khớp. Còn: 57 mục "Chưa chắc", em chốt trước các mục chạm bảo mật
  (FR-ADM-007/011 vai `OWNER` hay `OPS`/`ADMIN`, SUP-025, DLV-016, 15 TRK từ M5-112, CAS-25 `idempotency_key` chưa có trong kế hoạch xoá);
  `RELEASE_NOTES.md` đầu tệp còn mốc `3ec3578`, thiếu #106/#107/#111; thêm TRK cho lỗi `audit_log`; FR-NRM-002 ghi H1 còn mở.
- OWN-341 hôm qua ghi Messenger lúc pilot được báo giá và Claude soạn câu. Phần Claude soạn câu anh nhận: pilot dùng Claude API, khoá em đặt trên .98.
  Câu vẫn đi qua cửa gửi chung và FinalGuard của M5, chỉ chạy giờ có người trực, người trực vẫn nhận chuyển tiếp. Bật khi đủ 4 thứ: văn bản pháp chế đợt 2,
  NCC trả lời A1–A6, P0 bên M4 xong, chữ chính sách M5-101 có câu khai AI trả lời và anh đã đọc. Báo giá với nháp đơn trên Page pilot thì anh vẫn giữ chặn suốt pilot
  theo D-m5-015, cờ M5 để tắt; P3 em làm tiếp được, mở là chuyện quyết định riêng.
  Việc kéo theo: em ghi DL thay DL-200 (4) và phần "không bật AI" của DL-187; sửa luật 10 ở `scoped-send-posture.ts:61` (giờ chế độ phạm vi từ chối khởi động khi AI tự trả lời
  còn bật), cho phép AI khi `AI_ADVISOR` thật và Page nằm trong danh sách; sửa chữ `privacy-policy.md:34`, `tester-consent.md:38`; rà lại DL-223/M5-124 cho trường hợp AI trả lời tin riêng.

**Mấy việc khác:**
- Máy: M5 + M6 giờ chạy ở máy mkt .98, M3 + M4 sang .99 (tin máy chủ anh gửi riêng). Trên Sheet M5-004, 090–094 còn ghi .60,
  em sửa ghi chú và hạn theo .98 giúp anh.
- Status `ci-local` (OWN-342): anh bỏ yêu cầu này, không cần cấp token. Khối CI_LOCAL dán trong PR là đủ; em sửa DL-211, §2.4 điều 4 và §5.4 điều 4 cho khớp.
  Đổi lại hai điều phải giữ: PR chỉ gộp khi `GATE=ĐẠT` (#94 gộp lúc đang KHÔNG ĐẠT), và cổng chạy cả typecheck, lint, vitest của `web/`.
- Cột commit trên Sheet: 122 ghi "chưa commit (HEAD b848176)", 056 và 139 trống. Em điền SHA squash giúp anh.
- Còn treo Cần sửa chưa cập nhật: 002, 043, 055, 074, 104, 133. M5-104 (kênh CSKH thật) là điều kiện mở pilot.
- Có 16 probe khác cùng khuôn `fetch` + `process.exit` như lỗi 136 cũ (em đã ghi 12). Em mở một task riêng sửa cả loạt.
- Trên máy anh: `web/` vitest đỏ 15 ca lúc máy bận, chạy riêng thì xanh hết (325/325). Còn `prisma-m4-conversation` (DB) và `main-process` (qua runner)
  đỏ cả khi chạy riêng, giống 10/11. `app-logger` L6 (khởi động `src/main.ts` thành tiến trình con, trần 20 giây) thì chập chờn, 3/5 lượt đỏ.
  Mấy probe này ngoài các task lần này, em chạy lại bên em giúp anh.
