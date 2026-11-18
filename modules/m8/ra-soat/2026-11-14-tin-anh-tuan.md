# Tin nhờ Anh Tuấn — 14/11/2026 (Toàn gửi)

## (a) Tin Zalo

```text
Dạ anh Tuấn, em nhờ anh ba việc máy chủ cho M8 (gọi xác nhận đơn) được hông anh.
Một là cho em một khung giờ bảo trì với quyền sudo trên máy tổng đài .64, em nâng tổng đài lên bản mới, anh chọn giờ ít gọi nhất trước 18/11 nha.
Hai là chỗ cất bản sao lưu M8 ở máy khác ngoài .99, giờ bản sao lưu còn nằm chung máy, hư máy là mất luôn.
Ba là anh với em chốt chỗ cất khoá của tổng đài với người giữ dự phòng.
Chi tiết em để trong file kèm theo, anh coi giúp em hen. Em cảm ơn anh nhiều nha.
```

## (b) Tệp kèm

Gửi Anh Tuấn · 14/11/2026 · từ Toàn

Việc: ba việc cần quyền quản trị để M8 (gọi xác nhận đơn) đi tiếp từ chạy thử sang gọi thật. Đây là các mục 2, 3, 4 em nhờ hôm 10/11, giờ đổi máy đích sang .99.

Vì sao:
- M8 chạy trên máy chính thức .99 từ sáng 14/11, nối với web bán hàng đạt các ca thử. Tối 14/11 em thử khôi phục dữ liệu M8 trên .99: khôi phục đạt, mất khoảng 10 giây với dữ liệu hiện tại.
- Bản sao lưu tự động chạy 02:30 mỗi đêm nhưng vẫn nằm trên chính .99. Máy .99 hư hay mất đĩa là mất luôn bản sao lưu.
- Tổng đài .64 vẫn chạy bản 27/10. Muốn gọi thử số nội bộ thật, rồi gọi qua MobiFone (hẹn khoảng 24/11), thì phải nâng .64 lên bản mới trước.

Cần làm:
1. **Máy tổng đài .64.** Quyền sudo cho tài khoản `ssv` trong một khung bảo trì (hoặc anh ngồi cùng em), em ước khoảng 2 giờ, anh chọn giờ ngoài giờ gọi, trước 18/11. Trước khung giờ, em gửi anh kế hoạch từng bước, có bước sao lưu cấu hình hiện tại và cách quay về bản cũ nếu lỗi. Cầu ARI từ .99 sang .64 đã mở từ 14/11, không cần làm lại.
2. **Kho sao lưu ngoài máy cho M8.** Một máy hoặc ổ khác hẳn .99, cho M8 ghi vào bằng SFTP với một tài khoản riêng, chỉ được ghi vào thư mục của M8. Dung lượng: một bản sao lưu hiện khoảng 1 MB (dữ liệu 18 MB), giữ 30 ngày thì vài GB là dư. Em đề xuất mất tối đa dữ liệu 24 giờ gần nhất (RPO) và khôi phục xong trong 2 giờ (RTO); anh thấy chưa hợp thì sửa giúp em.
3. **Chỗ cất khoá của tổng đài.** Hai thứ: khoá dùng để đẩy file âm thanh từ .99 sang .64, và chứng chỉ của cầu ARI. Cần chốt cất ở đâu và ai giữ dự phòng ngoài em.

Xong khi: mỗi mục anh nhắn lại một dòng (đã làm, hoặc giờ hẹn). Em ghi vào sổ M8.

Hạn: mục 1 trước 18/11; mục 2 và 3 càng sớm càng tốt (đã trễ từ 12–13/11). Báo lại bằng tin nhắn hay Zalo đều được.
