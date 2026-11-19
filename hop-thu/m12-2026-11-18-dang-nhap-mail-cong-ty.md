# Từ phiên lead · 18/11/2026 15:2x · M12 thêm đăng nhập bằng mail công ty @ssavigroup.com (D-m12-115)

Lời Toàn (phiên lead, 15:2x): "tôi muốn thêm đăng nhập bằng mail sever của công ty á, @ssavigroup.com vì mỗi nhân viên sẽ có 1 tài khoản mail này để
đăng nhập vào quản trị, rồi tùy phân quyền trong hệ thống … mỗi nhân viên của công ty sẽ có 2 lựa chọn đăng nhập: username hoặc mail công ty, cả 2 tài khoản
này là 1. trường hợp nhân viên chưa có mail công ty thì admin vẫn tạo được username … sau khi cấp mail công ty rồi thì liên kết vào, gửi otp/link qua bên mail
(gửi từ mail no-reply@ssavigroup.com) để xác nhận liên kết hoặc đăng nhập … tôi muốn làm cho m12 trước. đăng nhập vào ops.ginsengfood.vn và pwa.ginsengfood.vn".

## Yêu cầu

1. **Một tài khoản, hai cách vào:** tên đăng nhập + mật khẩu (giữ nguyên như hiện nay) **hoặc** mail công ty + mã OTP. Cùng tài khoản, cùng vai, cùng kiểu phiên/cookie
   như đăng nhập thường. Áp cho admin-web (`ops.`) và shopfloor PWA (`pwa.`), hai app dùng chung API và bảng người dùng.
2. **Chỉ nhận mail đuôi `@ssavigroup.com`** (danh sách đuôi để cấu hình được).
3. **Admin vẫn tạo tài khoản bằng tên đăng nhập như cũ**; trường mail công ty để trống được. Một mail chỉ gắn một tài khoản; admin gỡ liên kết được.
4. **Liên kết mail:** (a) nhân viên đang đăng nhập bằng tên → hồ sơ của mình → nhập mail công ty → hệ thống gửi OTP tới mail đó → nhập đúng mới gắn;
   (b) admin nhập mail cho tài khoản → trạng thái "chờ xác nhận" → nhân viên xác nhận bằng OTP gửi tới mail đó. Chưa xác nhận thì chưa đăng nhập bằng mail được.
5. **Đăng nhập bằng mail:** nhập mail → gửi mã OTP 6 số (hạn 10 phút, dùng một lần) → nhập mã → vào.
   Phiên lead đề xuất **mã OTP làm cách chính, không dùng link đăng nhập**: PWA cài trên điện thoại, link bấm từ app mail mở ở trình duyệt khác nên phiên không về
   đúng PWA. Link (nếu muốn) chỉ dùng cho bước xác nhận liên kết; phiên m12 quyết.
6. **Bảo mật (R3):** trả lời giống hệt nhau dù mail có hay không có tài khoản (không dò được ai có tài khoản) · giới hạn gửi mã theo mail và theo IP · khoá tạm
   sau nhiều lần sai · mã lưu dạng băm, so sánh thời gian hằng · tài khoản bị khoá/vô hiệu thì mail cũng không vào · nhật ký kiểm toán cho gửi mã, đăng nhập,
   liên kết, gỡ · không ghi mã hay mail đầy đủ vào log · đổi/gỡ mail thì thu hồi phiên đang mở bằng mail đó.
7. **Gửi mail:** SMTP `pro56.emailserver.vn` cổng 465 (SSL) hoặc 587, hộp `no-reply@ssavigroup.com` (Toàn tạo ở Mắt Bão). Mật khẩu SMTP để trong tệp bí mật
   trên .99 do **Toàn tự dán** (phiên không đọc, không in). Đo 18/11 15:2x: .99 ra được 465 và 587. Kiểm thư không rơi vào Spam (M3 từng bị với `noreply@`).
8. **Cờ bật/tắt**, mặc định tắt; bật trên .99 sau khi kiểm độc lập đạt và Toàn duyệt.
9. **Không đổi:** đăng nhập nhà cung cấp, tài khoản dịch vụ (`SVC-M3-SELLABLE`…), luồng mật khẩu, CSRF/cookie host-only hiện có.
10. **Đồng bộ với M5:** `mkt.` đang làm đăng nhập bằng mã gửi mail công ty (D-m5-065, M5-162). Giữ cùng quy ước (OTP 6 số, đuôi `@ssavigroup.com`, hộp no-reply chung)
    để sau gộp đăng nhập chung (SSO) dễ.

## Phiên m12 làm

Lập gói việc R3 (coder + tester độc lập + verifier), tra `DECISION_LOG`/`lat/` theo vùng auth trước khi viết brief, đưa Toàn các câu cần chốt (link hay chỉ OTP,
số lần sai, hạn mã). **Toàn 15:3x: "làm ngay nhé"** — mở gói việc ngay, song song với release (WP17b, M-c ≤ 25/11); cờ tắt nên không chặn release. Việc tay của Toàn: tạo hộp
`no-reply@ssavigroup.com` (dùng chung cho M12 và M5) rồi tự dán mật khẩu SMTP vào .99 theo hướng dẫn của phiên m12.
