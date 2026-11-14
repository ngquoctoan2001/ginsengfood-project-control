# Tin nhắn nháp cho Tài — rà task M5 05/11/2026

Người nhận: Tài. Chưa gửi; bạn gửi khi đồng ý. Bản rà: `modules/m5/ra-soat/2026-11-05-tai.md`.
Ghi chú từng task đã có trên Sheet (cột Ghi chú Lead, khối `[Rà soát Lead 05/11/2026 …]`).
Đã áp D-m5-018–022 (bạn "ok 14–18" lúc 19:17). Ghi chú Sheet của 060, 074, 101 viết trước quyết định; tin này là bản mới hơn.

---

Tài ơi, anh rà xong 19 task M5 đang Hoàn thành/Chờ review trên main `e895c3a` (PR #63). Mỗi task đều chạy lại probe và thử đột biến
độc lập; đột biến gần như đều bị bắt, test đỏ trước rõ ràng. Tốt lắm.
Kết quả: **8 Đạt, 11 Cần sửa**, thêm M5-042 rà bổ sung (Cần sửa, cuối tin). Anh đã ghi Lead duyệt và Ghi chú Lead trên Sheet. PR #65 gộp sau giờ rà, nên mục "gộp PR #65" trong ghi chú coi như xong.

**Đạt:** 044, 063, 065, 072, 073, 125, 128, 130.
Nhắc nhỏ, không chặn: mô tả PR #52, #54, #59 thêm dòng tệp đổi / "không env, không migration"; sửa cột commit Sheet của 044 (`2176c30`),
054 (`91f8ed0`), 063 (`5cb17c9`); ghi TRK cho probe DB `prisma-normalized-event-store` đỏ ở merge `a4dd150`.

**Cần sửa — an toàn khách, làm trước:**
- **M5-129**: câu báo đã uống quá liều lọt ("em đã uống thuốc ngủ quá liều", "uống hết cả hộp thuốc ngủ rồi", "uống 30 viên thuốc ngủ rồi").
  Thêm cụm + probe. Ở `comment-boundary.resolver.ts:570-580` gọi báo CSKH trước khi ghi evidence/audit, để ghi lỗi không làm mất cảnh báo. Ghi DL đóng băng v4.
- **M5-131**: v4 lọt "em đâu thiết gì nữa", "em hết thiết gì nữa rồi" mà v3 bắt (T-1). Em quyết thêm lại cụm hay chấp nhận, rồi ghi DL. Mô tả PR #62 thêm env/migration/việc còn lại.
- **M5-060**: 5 ca hôm 03/11 đã che, nhưng 18/32 địa chỉ mới cùng lớp vẫn lọt, ví dụ "10 phạm văn đồng cầu giấy" (không dấu phẩy),
  hàng tre/than/mắm/gà, đồng xoài, mai hắc đế, kim đồng, cách mạng tháng 8. Danh sách đủ trong `group-d.md`.
  Thêm vào corpus (đỏ trước) rồi sửa bằng luật chung: số nhà + tên đường + phường/quận hoặc từ dẫn. Đừng thêm từng tên phố. Sửa TRK-22.
  Anh chốt **hạn 10/11**, không mở task hoãn: pilot là khách thật.
- **M5-124**: giá viết trần vẫn gửi trên Page pilot ("chỉ còn 399 một hộp", "bán 250 một hộp", "tổng cộng 750"; rà N-1 lọt 20/35), trái D-m5-015.
  Em chọn hướng N-1, ghi DL, đưa bằng chứng; sửa chữ "M5-124 (chưa code)" trong DL-187.
- **M5-127**: "Em là bác sỹ ạ", "Mình là dược sỹ" lọt (chữ sỹ) → thêm vào luật 9 + probe. Các ca lọt mới ("phòng/ngăn ngừa ung thư, đột quỵ",
  "đỡ/bớt đau", "cải thiện tiểu đường", "không phải A.I/robot", "Tôi chính là nhân viên") đưa vào EVS-05 có cờ, em quyết sửa hay hoãn.

**Cần sửa — đường găng App Review:**
- **M5-016**: mã đạt. Còn chạy RBAC real với khoá thật anh Tuấn giữ (anh đã chốt khoá nội bộ ngày 03/11): lấy khoá công khai + iss/aud + claim vai,
  đặt `M5_OIDC_*` trên .60, chạy 200/403 cho 3 vai và CLI mã 0/3 bằng token thật, lưu bằng chứng đã che. Ghi DL chốt (OWN-306), sửa TRK-05.
- **M5-053**: mã đạt. Sửa `DATA_RETENTION_AND_SECRETS` dòng 59, 140, 203, 253 theo DL-198. Tạo token System User 60 ngày, chạy `tools/ops/page-token.cjs`
  trên .60, gửi thử 1 tin tới tài khoản thử, ghi ngày/hạn/người làm, không ghi giá trị.
- **M5-101**: PR #64 khớp phiếu anh trả lời, P19 đúng từng chữ. **Anh duyệt chữ theo bảng đối chiếu P01–P23**, với điều kiện em sửa
  các mục dưới; câu chờ pháp chế/anh Tuấn để trống, không đăng số. Sửa trước khi đăng:
  (1) CS:66 "dữ liệu được xoá tự động" — job chỉ xoá bản thô 7 ngày + khoá, mặc định tắt;
  (2) ĐY:40 "xoá toàn bộ dữ liệu thử" — anh đã nêu từ 03/11;
  (3) XD:29,33 hứa xoá đúng người khi M5-036 chưa có mã — ghi quy trình làm tay thật;
  (4) bỏ trong bản pilot câu "AI trả lời tin nhắn" (CS:34, ĐK:29, theo DL-200(4)) và "tư vấn sản phẩm" (CS:71, P11).
  Em điền URL Page (P04). P01, P02 và repo Pages (P22) anh làm. Sửa xong, đăng và dán URL vào app Meta thì anh rà lại.

**Cần sửa — còn lại:**
- **M5-054**: mã đạt đủ thẻ. Ghi DL chốt số lần/khoảng chờ gửi lại (DL-120, mã đang 3 lần 1-2-4 giây ghi "mock") và ngưỡng AL-45.
- **M5-074**: anh tách phần chạy với M4 thật (`run-eval --mode b`, M4 thử, có người soát) thành task riêng, em mở task mới phụ thuộc M4-004.
  M5-074 chỉ còn: duyệt nhãn ghi sha256 (DL-193 (3)) và lưu báo cáo theo §7.4 (md + json, commit, người chạy). `--pilot` tại `e895c3a` còn 7 ca lọt.
- **M5-084**: gói runtime luôn `failGateTripped=true` vì thiếu phán quyết slice. Sửa FR-EVD-006, `evidence-report.service.ts` và ca "MISSING required slice"; api-catalog EP-17.

**Còn treo từ lượt 03/11:** M5-002 (11 ô "Tài xác nhận" ở WORK_TRACKING mục 3); M5-007 chờ anh duyệt §5.

**Việc khác anh nhắc:**
- DL-O28: M7 đã chốt rút vai cũ (DL-075 bên M7). Em đóng DL-O28 = rút và sửa DPIA, SRS (NFR-SEC-07, NFR-REL-09), GLOSSARY, CI_CD còn ghi "chờ Tài quyết".
- CH21 cho M5-032: anh gửi riêng tệp gốc kèm tin 06/11 (D-m5-023, thay câu "dùng bộ vector bên M6" của tin 03/11).
- Khoá SSH cho anh Tuấn (.60), token System User, M5-094 thay bí mật đã lộ (quá hạn 04/11), M5-126 danh sách hotline/địa chỉ shop.
- Kênh CSKH và kênh cảnh báo vận hành đang là bản giả ở mọi chế độ, khởi động không chặn. Lên máy thật thì mọi lần chuyển người không ai được báo.
  Anh chốt **M5-104 kênh CSKH thật + luật khởi động từ chối kênh báo giả (chế độ phạm vi và production) là điều kiện bắt buộc trước pilot**, thêm vào Go/No-go 13/11.

**Quyết định anh chốt 05/11, em ghi DL vào `DECISION_LOG.md`:**
- DL-200, DL-194 là quyết định của anh (giữ pilot 14/11; App Review khi đủ .60 HTTPS + token + M5-101; Meta chưa duyệt thì pilot chỉ người có vai trò;
  M4 không trả lời tin riêng trên Page pilot; pilot chỉ chạy giờ có người trực). Ghi chú "Toàn xác nhận 05/11" vào hai dòng này.
- M5-101: anh duyệt chữ theo bảng P01–P23 với điều kiện ở trên.
- M5-074: tách phần chạy M4 thật thành task riêng.
- M5-104 + luật khởi động chặn kênh báo giả: bắt buộc trước pilot, vào điều kiện Go/No-go (sửa SPRINT_PLAN mục Go/No-go).
- M5-060: sửa bằng luật chung, hạn 10/11; không mở task hoãn.

**M5-042 (rà bổ sung trên `e759955`) — Cần sửa:** mã chắc, chống trùng đúng (3 lần song song chỉ 1 lần đăng), không lọt token. Còn:
(1) chạy với token Page thật trên .60, bình luận thử nhận đúng 1 trả lời, nộp bằng chứng; (2) ghi DL chốt trần 10/bài/giờ, 30/Page/giờ
(mã ghi "đề xuất, Tài chốt", PR ghi "PM chốt"); (3) thêm probe nối DI sink thật + kho đếm (bỏ export `PROACTIVE_CAP_STORE` thì probe vẫn xanh)
và probe `HttpGraphClient` 2xx JSON hỏng; (4) ghi cách lấy ref `psid_hash` người thử, thêm `PUBLIC_COMMENT_SINK_MODE`, `M5_SCOPED_PUBLIC_CSKH`
vào template .60; `TEST_STRATEGY.md:596` còn trỏ .63.
