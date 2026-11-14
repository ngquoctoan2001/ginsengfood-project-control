# Tin nháp gửi Anh Tuấn · 14/11/2026 · xin máy ảo dev (Toàn tự gửi, CHƯA GỬI)

Bối cảnh (đo 14/11 ~09:30 trên máy Lead, 16 nhân / 32 GB): CPU 99%, RAM trống 8 GB. Ăn CPU nhiều nhất là job CI GitLab đang chạy
trong Docker của runner máy Lead (container `runner-…-build` ≈ 1.270% = gần 13 nhân); 22 tiến trình Claude ≈ 4,8 GB; 35 tiến trình
dotnet (build/test) ≈ 3,2 GB; testhost M7 ≈ 1,2 GB; bộ container M7 đang chạy rất nhẹ (< 2% CPU). Ba runner GitLab trên máy Lead đang online.
Đề xuất lead.86 A: máy ảo dev Linux riêng (không dùng .98/.99/.60 vì là máy chạy thật, D-lead-017), chuyển runner GitLab + phiên test nặng sang đó.

```text
Dạ anh Tuấn, bữa anh nói cần remote thì nhắn anh đó. Anh tạo giúp em thêm một máy ảo làm máy dev được hông anh, Ubuntu như mấy máy kia, cỡ 12–16 nhân, 48–64 GB RAM, ổ chừng 300–500 GB, dữ liệu em cũng để trong /data. Em vô bằng SSH là được rồi, khỏi remote desktop. Máy còn dư bao nhiêu thì anh cho bấy nhiêu cũng được nha. Em cảm ơn anh nhiều nghen.
```
