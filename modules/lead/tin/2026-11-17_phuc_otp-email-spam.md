# Tin Toàn gửi Phúc · 17/11/2026 · mail OTP từ @ssavigroup.com vào thư mục Spam

Bối cảnh: Phúc báo mail OTP gửi khách từ hộp thư `@ssavigroup.com` bị vào Spam. Toàn hỏi Mắt Bão (ticket): Mắt Bão kiểm DNS, xác nhận
**SPF và DKIM đúng**, cho rằng do nội dung thư, khuyên sửa nội dung + nhờ người nhận bấm "Không phải thư rác".
Phiên lead tra DNS công khai 17/11 (chỉ đọc): MX `pro56.emailserver.vn` (mail Mắt Bão) · SPF `v=spf1 mx include:emailserver.vn include:spf.protection.outlook.com -all`
· DKIM selector `default` có · **DMARC `p=quarantine` (cả tên con)**.

## (a) Tin Zalo

```text
Phúc ơi, vụ mail OTP vô Spam anh hỏi Mắt Bão rồi, bên đó kiểm tên miền thấy cấu hình gửi mail đúng hết, nghi do nội dung thư.
Nhưng anh thấy tên miền mình đang bật chế độ thư nào không qua kiểm tra là cho vô Spam luôn, nên em kiểm giúp anh 2 chuyện trước: máy chủ gửi mail mình đang xài là cái nào, và mở thư OTP bị vô Spam coi kết quả kiểm tra có đạt hết không. Sau đó sửa lại nội dung thư cho gọn.
Em làm trong hôm nay hoặc sáng mai rồi báo anh kết quả nha. Chi tiết anh để trong file.
```

## (b) Tệp gửi kèm (gửi Phúc)

**Việc:** tìm đúng lý do mail OTP vào Spam và sửa; xong khi gửi thử tới Gmail và Outlook đều vào Hộp thư đến.

**Vì sao không chỉ do nội dung:** tên miền `ssavigroup.com` đặt DMARC `p=quarantine` — thư nào gửi bằng địa chỉ `@ssavigroup.com` mà **không đạt
SPF hoặc DKIM khớp tên miền** thì bên nhận tự cho vào Spam. Mắt Bão chỉ xác nhận bản ghi DNS có đúng, chưa xem thư thật của mình gửi đi qua máy chủ nào.

1. **Kiểm máy chủ gửi** (cấu hình M3 `MAIL_HOST`, `MAIL_USERNAME`, `OTP_EMAIL_FROM`; không gửi mật khẩu qua chat):
   - Gửi qua máy chủ mail Mắt Bão (hộp thư `@ssavigroup.com` thật, cổng 587) → SPF đạt (có `include:emailserver.vn`).
   - Gửi qua Gmail/Google, dịch vụ khác, hoặc gửi thẳng từ máy chủ .99 mà vẫn ghi người gửi `@ssavigroup.com` → **SPF/DKIM không khớp → DMARC trượt → Spam**.
     Sửa: gửi qua máy chủ Mắt Bão, hoặc dịch vụ gửi mail giao dịch có xác thực tên miền (thêm SPF + DKIM của dịch vụ đó vào DNS).
   - `OTP_EMAIL_FROM` phải cùng tên miền với hộp thư đăng nhập SMTP.
2. **Xem kết quả kiểm trên thư thật:** mở một thư OTP bị vào Spam trong Gmail → ⋮ → "Hiện thư gốc" (Show original). Ba dòng **SPF, DKIM, DMARC**
   phải là **PASS**. DKIM phải ký bằng `d=ssavigroup.com`. Dòng nào FAIL/không có là ra nguyên nhân — chụp màn hình gửi anh.
3. **Chấm điểm thư:** gửi một thư OTP tới địa chỉ thử của mail-tester.com (trang cho địa chỉ ngẫu nhiên), xem điểm và mục bị trừ; mục tiêu ≥ 9/10.
4. **Nội dung thư OTP** (theo Mắt Bão + thông lệ thư giao dịch):
   - Tiêu đề ngắn, rõ, không viết HOA, không chữ quảng cáo: ví dụ "Mã xác nhận Ginsengfood: 123456".
   - Có cả phần chữ thường (text/plain) bên cạnh HTML; HTML gọn, không chỉ toàn ảnh, không link rút gọn, không nhiều link.
   - Tên người gửi cố định ("Ginsengfood"), có chân thư tên + địa chỉ công ty, một dòng "Nếu bạn không yêu cầu mã này, hãy bỏ qua thư".
   - Không gửi lặp nhiều thư giống hệt trong thời gian ngắn (giới hạn gửi lại OTP).
5. **Sức chứa hộp thư Mắt Bão:** hỏi/kiểm giới hạn số thư gửi mỗi giờ/ngày của gói mail; lúc đông khách có thể chạm trần.
6. Thử lại: gửi tới 2–3 hộp Gmail + 1 Outlook mới (chưa từng nhận), đều vào Hộp thư đến thì báo anh. Bấm "Không phải thư rác" chỉ giúp hộp thư đó, không sửa tận gốc.

Ghi task tracker theo luật repo (M3-192 OTP email). Hạn: báo kết quả mục 1–3 trong 18/11.
