# Prompt 1 · phiên `lead` mới · dựng nền máy 192.168.1.99 (D-lead-035)

Mở phiên mới, gõ `/phien lead`, rồi dán khối dưới. Chạy prompt này trước prompt 2–4.

```text
Việc: dựng nền máy nhà máy + bán hàng 192.168.1.99 theo D-lead-035 (modules/lead/QUYET_DINH.md). Toàn đã duyệt chuyển ngay.

Bối cảnh
- Anh Tuấn cấp .99 ngày 13/11 ("SRV Ginsengfood chạy www"), tài khoản ssv. Mật khẩu Anh Tuấn gửi qua Zalo: không hỏi, không đọc, không ghi, không dùng. Phiên chỉ vào máy bằng khoá.
- Máy này nhận: M1–M2 (~/m12 trên .61, phiên m12), app M8 (~/m8 trên .61, phiên m8), M3 + M4 + M9 (~/m34 trên .60, phiên m34). M5 + M6 sang máy mkt .98 (Tài dựng, D-lead-034). M7 tạm ở .60 tới khi có máy video. Asterisk .64 giữ nguyên.
- Khuôn chung D-lead-017/018: CI đóng image theo commit → kho image → máy chỉ pull, up, kiểm /health, lỗi tự quay lui. Máy không có mã nguồn, không build.
- Anh Tuấn dặn máy mkt để mọi dữ liệu trong /data cho dễ sao lưu và mở rộng; .99 làm giống vậy. Anh Tuấn nói "cần gì thì mình cài thêm".
- Sổ: modules/lead/may-chu/KIEM_KE_MAY_CHU.md, modules/lead/may-chu/2026-11-11-ten-mien-may-chu-chinh-thuc.md.

Làm
1. Khoá: tìm khoá phiên đang dùng vào .60/.61 (ssh -G 192.168.1.61), in dòng khoá CÔNG KHAI để Toàn tự đăng nhập .99 bằng mật khẩu và thêm vào ~/.ssh/authorized_keys của ssv. Chờ Toàn báo xong rồi mới ssh.
2. Kiểm kê chỉ đọc .99, gom một lệnh: hệ điều hành, CPU/RAM/đĩa, /data (dung lượng, chủ sở hữu), ssv có sudo hay nhóm docker không, Docker + Compose (gói m34 cần Compose ≥ 2.23.1), múi giờ, ra được ghcr.io và kho image GitLab không, tới được .60, .61, .64, .98 không. Ghi KIEM_KE.
3. Nền: Docker + Compose; dữ liệu Docker nằm dưới /data (đề xuất data-root /data/docker để volume tự vào /data, các luồng không phải sửa compose); /data/sao-luu cho sao lưu. Thiếu quyền (sudo, cài Docker) thì soạn tin nhờ Anh Tuấn cài, giọng nhờ, không hướng dẫn cách làm; Toàn tự gửi.
4. Cổng vào: xác định ai đang giữ 80/443 (D-lead-028 ghi front proxy trên .60; ghi chú 11/11 ghi máy nginx của Anh Tuấn). Lập bảng tên miền → đích hiện tại → đích mới trên .99 (ginsengfood.vn, /admin, ops., pwa., trace.) và ai đổi lúc cắt. Cổng nội bộ trên .99 chỉ mở cho đúng IP cần gọi (.98 M5/M6, .60 M7, .64 Asterisk), không mở ra ngoài.
5. Lịch cắt: mỗi luồng một cửa sổ ngoài giờ xưởng dùng. Đọc deploy/m34 (business-platform), deploy/m12 (ops-core), deploy/m8 (ivr) để biết ai gọi ai, đề xuất thứ tự cắt, ghi vào kế hoạch chia máy.
6. Thả hop-thu/m12-…, hop-thu/m8-…, hop-thu/m34-… báo "nền .99 sẵn sàng", kèm: đường /data, bản Docker/Compose, có sudo hay không, cổng nội bộ đã mở, giờ cắt của luồng đó.

Luật
- Mỗi lệnh ssh/scp máy hỏi Toàn: gom lệnh theo pha thành kịch bản soạn sẵn, trình một lần để Toàn duyệt liền.
- .60/.61 chỉ đọc trong việc này: không dừng, không sửa gì ở đó. Không đổi cổng vào/tên miền khi chưa tới giờ cắt và Toàn chưa nói.
- Không đọc/in .env*, khoá riêng, token, mật khẩu. Subagent không ssh thật (host giả, kiểm `type ssh` trước).
- Xong bước nào ghi sổ ngay (KIEM_KE, kế hoạch chia máy, nhật ký); TRANG_THAI ≤ 60 dòng.

Xong khi: phiên vào .99 bằng khoá được; .99 có Docker/Compose, /data, kiểm kê đã ghi sổ; có bảng cổng vào và lịch cắt; 3 tin hop-thu đã thả.
```
