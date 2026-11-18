# Tin cho Tài · 18/11/2026 sáng · trả lời báo cáo app Meta + các chốt 18/11 (CHƯA GỬI — bản cuối, gửi được)

Nguồn: tin Tài gửi Toàn sáng 18/11 (app Meta "Ginsengfood Gateway Dev"; Tài thu hồi bản đầu, gửi lại 08:4x với đề xuất đặt trang ở `mkt.ginsengfood.vn/policy`).
Toàn chốt 18/11 08:0x m5.48–51 (D-m5-058…061) và 08:41 "ok 56 B, 54, 55, 47 A, 53 có" (D-m5-062…066).
Phiên m5 kiểm 08:06: `https://mkt.ginsengfood.vn/` 301, `/admin/` 200, `GET /api/channel/meta/webhook` không token 403, `/api/admin/ads/dashboard` 401.
Trang chính sách đối chiếu tại module5 `main` `aa6d55d4`, `docs/05-reference/public/privacy-policy.md` (bảng đầu ghi bản 1.5 = 1.4 + mục 11 YouTube).
Tuyến `/policy/` đã nhờ phiên lead (`hop-thu/lead-2026-11-18-m5-tuyen-policy.md`); phiên lead báo thư mục thì phiên m5 nhắn Tài thêm một câu.
Gửi phần (a) qua Zalo, kèm **hai tệp**: (b) dưới đây, và gửi lại `2026-11-16_lead_m5-dl230-route-admin.md` (phần (b) của `2026-11-16-tin-tai-2.md`; Tài báo chưa nhận hai chỗ DL-230).

## (a) Tin Zalo

```text
Ok Tài, lên bản mới với webhook xác minh đạt là ngon rồi nha.
Trang chính sách anh đọc mấy chỗ phần anh rồi, ok. Mấy chỗ chữ còn lại em tự chốt như đã nói, đăng một trang chung cho Facebook với YouTube luôn.
Chỗ đặt anh chịu cách em đề xuất: mkt.ginsengfood.vn/policy. Bên anh thêm tuyến trên proxy rồi báo em thư mục, em xuất HTML bỏ vô đó là chạy.
Hướng pilot anh đồng ý: có trang chính sách thì em phát hành app, gắn Page pilot lấy token thật luôn, không cần chờ giờ pilot, nộp App Review song song. Trước họp Go/No-go chỉ người có vai trò trên app thử thôi, khoá chạy thật vẫn tắt, trả lời khách thật chờ họp xong anh duyệt. Thấy sự kiện của người không có vai trò lọt vô thì dừng báo anh liền nghen.
Kênh CSKH với cảnh báo anh chốt Telegram, một bot hai nhóm như PM đề xuất. Em tạo luôn hôm nay, bắn thử mỗi nhóm một tin rồi báo anh, thiếu cái này M5 không khởi động chế độ pilot được.
Đăng nhập màn quản trị anh đổi cách: vô bằng mã gửi về mail công ty, M5 tự ký mã truy cập, bên anh đang làm. Em khỏi viết công cụ phát token. Trong lúc chờ, cần vào thì em phát tay mã 8 tiếng, cặp khoá sinh luôn trên .98 để sau M5 ký chung.
Mấy câu YouTube em hỏi anh trả lời trong file rồi, câu Q8 chọn a nên M5-156 làm tiếp được. File DL-230 hôm 16 em nói chưa nhận, anh gửi kèm lại đây.
Họp Go/No-go chậm nhất thứ Sáu 20/11 hen. Chi tiết anh để trong file.
```

## (b) Tệp kèm — `2026-11-18_lead_m5-meta-youtube.md`

```markdown
Gửi Tài · 18/11/2026 · từ Toàn
Việc: (1) đăng trang chính sách; (2) phát hành app Meta + Page pilot + App Review; (3) Telegram; (4) đăng nhập màn quản trị; (5) trả lời câu hỏi YouTube.
Vì sao: em báo sáng 18/11 — M5 trên .98 lên main aa6d55d4 lúc 07:54 (có C6), webhook mkt. Meta xác minh đạt (chỉ feed), URL xoá dữ liệu đã lưu;
trang "Đăng" của Meta chỉ còn thiếu URL chính sách, app còn chế độ phát triển nên chỉ nhận sự kiện thử.

1. Trang chính sách (D-m5-062, D-m5-064, D-m5-038)
- Anh đã đọc phần của anh trong privacy-policy.md tại main aa6d55d4: mục 1 tên pháp nhân + địa chỉ (P01, P02), câu khai AI ở mục 2 (Messenger) và mục 9, mục 11 YouTube. Ok.
- Phần chữ còn lại em tự chốt, gồm D1, D2 ở README §3.5 (D1: callback xoá dữ liệu nay đã khai trên app, em chọn PA cho khớp).
- Một trang chung Facebook + YouTube: sửa dòng "Áp dụng cho" cho gồm kênh YouTube của GinsengFood; gỡ dòng chú thích NHÁP M5-151; điền P04 (link Page), P22 (ngày đăng).
- Chỗ đặt: https://mkt.ginsengfood.vn/policy/ (thay GitHub Pages của DL-072, em ghi DL mới). Proxy Caddy edge-98 thêm tuyến tĩnh /policy/* trả tệp từ một thư mục
  trên .98, chỉ đọc, không vào app M5; anh báo em đường dẫn thư mục khi xong. Các trang công khai khác (điều khoản, hướng dẫn xoá dữ liệu) cùng thư mục.
- Em xuất chữ đã duyệt ra HTML tĩnh (không script, không gọi ra ngoài), đặt vào thư mục đó, ghi SHA nguồn + ngày đăng vào sổ.
- Cùng một URL khai cho Meta và cho màn đồng ý Google (M5-150). Đổi lại trang phụ thuộc .98 + Caddy; .98 bảo trì lâu thì báo anh trước.

2. Phát hành app + pilot (D-m5-063, D-m5-018, D-m5-035)
- Có URL chính sách: em phát hành app (Live), gắn Page pilot, lấy token System User 60 ngày (M5-053, chạy trên .98) ngay, không chờ giờ pilot. Nộp App Review
  xin Advanced Access song song (M5-102, video từng quyền). Em kiểm Meta duyệt mất bao lâu rồi ghi vào sổ.
- Trước họp Go/No-go: chỉ người có vai trò trên app thử (đây là SMK/UAT cần cho họp), PRODUCTION_ENABLED vẫn tắt, chế độ phạm vi.
  Trả lời khách thật chỉ sau họp Go/No-go đạt và anh duyệt. Nếu thấy sự kiện của người không có vai trò vào M5 thì dừng, báo anh.

3. Kênh CSKH + cảnh báo thật (D-m5-066, DL-234)
- Telegram, một bot, hai nhóm (CSKH, vận hành). Em tạo hôm nay, token bot chỉ để trên .98, bắn thử thật mỗi nhóm một tin, ký DL-234.
- Đây là điều kiện M5 khởi động chế độ phạm vi (D-m5-021) và chạy SMK. Bên anh đã nhờ kiểm .98 ra được api.telegram.org.

4. Đăng nhập màn quản trị (D-m5-065, thay D-m5-052)
- Người dùng nhập mail @ssavigroup.com, mail có trong danh sách anh duyệt (kèm vai) thì nhận mã 6 số qua mail (hạn 10 phút, sai 5 lần khoá), nhập mã là vào.
- M5 tự ký JWT 8 giờ (iat, jti, vai) bằng khoá riêng nằm trên .98 (tệp bí mật, không vào repo/sổ). M6 kiểm bằng khoá công khai như cũ, không phải sửa mã M6.
- Bên anh làm (task M5-162, nhánh m5/M5-162-dang-nhap-mail), có CLI phát tay tạm + runbook. Em khỏi viết công cụ phát token riêng; DL-228 phần
  "khoá riêng không tới .98" và DL-242 ý 4 sẽ dẫn sang DL mới.
- Em chuẩn bị trên .98: sinh cặp khoá RSA ≥ 2048 (khoá riêng mode 600, không rời .98), đặt khoá công khai cho M5 + M6 (cùng iss/aud).
  Trong lúc chờ M5-162 gộp, cần vào thì em phát tay token ≤ 8 giờ, mỗi người một sub, bằng chính cặp khoá này.
- Khi M5-162 gộp: em đặt mật khẩu hộp mail gửi đi + tệp danh sách mail theo runbook (anh gửi danh sách và hộp mail riêng, không ghi vào repo).

5. Trả lời câu hỏi YouTube (M5-151/CAU_HOI_LEAD.md)
- Q8 → (a) (D-m5-059): ngoại lệ hẹp của câu B3, chỉ cho YouTube. Trước văn bản pháp chế đợt 2, M4 được dùng Claude soạn câu trên kênh thử với bình luận
  do nhân viên tự viết (không có bình luận người thật; che tên/mã tác giả trước khi gửi M4) và soạn bộ 30 câu thử nộp pháp chế. Bình luận thật sang Claude vẫn chờ đợt 2.
  Messenger và người thử nội bộ giữ nguyên B3. Em sửa cho khớp một câu ở DL-243, DL-245, DPIA §10.2, bản khai AI, hồ sơ pháp chế. M5-156 hết chặn.
- Q3 (D-m5-060): BR-007 giữ, chỉ Hub "Cháo Sâm Mỗi Ngày" chốt đơn. Fanpage đích của video/kênh không phải Hub thì Page đó không báo giá, không nháp đơn;
  khách hỏi mua/giá → chuyển người trực (như Page pilot). Chọn Fanpage đích linh hoạt giữ nguyên (D-m5-054). Em ghi vào BR-007/DL YouTube.
- Q9, Q5: xem mục 1 (một trang chung, mục 11 anh đã đọc).
- Q1 (D-m5-061): ưu tiên theo đề xuất người soạn — P0: kho token, che dữ liệu, giữ/xoá, M4 soạn câu, ngoại lệ link, người duyệt, chống spam, cờ;
  P1: đọc bình luận, hạn mức, Fanpage, màn đọc, referral, phễu.
- Q6: GET /api/admin/youtube/quota làm ở M5-155.
- Q7: có, em ghi DL riêng cho D-m5-034, 037, 039, 050. D-m5-052 đã thay bằng D-m5-065 (mục 4), DL do M5-162 thêm.
- Q10: câu đồng ý Điều khoản YouTube đặt ở màn kết nối kênh, ghi audit người bấm + thời điểm; em chốt chữ.
- Q2, Q4: theo spike M5-150 và pháp chế đợt 2 như em ghi.
- M5-150: danh sách kênh YouTube, người giữ đăng nhập, quyền Owner Google Cloud, bản ghi TXT xác minh tên miền — anh gửi riêng.

Báo lại bằng: URL chính sách đã đăng, ảnh app Live + Page pilot gắn (đã che), ảnh tin thử 2 nhóm Telegram (đã che), dòng Sheet M5-053/081/100/101/102/104/156 cập nhật,
PR sửa sổ cho Q3/Q8 + DL thay DL-072.
```
