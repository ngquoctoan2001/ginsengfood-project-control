# Luật tài nguyên máy cho agent của luồng M7 (D-m7-079, 13/11/2026)

Lead chốt m7.165 a–e vì M7 chiếm máy làm các phiên khác phải chờ. Điểm nghẽn đo được: RAM trống chỉ còn 1,5 GB trên 31,8 GB, TIME_WAIT 3500–6000 trên dải cổng tạm 16384 cổng; CPU trung bình M7 khoảng 2,4 trong 16 lõi. Mọi brief coder, verifier của M7 dẫn tệp này; luật ở đây **thắng** các dòng cũ trong brief mẫu (`brief-T064.md` mục 4, 5).

## 1. Mọi lệnh nặng đi qua cửa

```
pwsh -NoProfile -File "C:\Projects\Project Control\modules\m7\tools\m7-heavy.ps1" -Label <nhãn> -Command '<lệnh>'
```

- **Lệnh nặng:** `dotnet build`, `dotnet test`, `vitest`, `tsc`/`eslint`/`next build` trên cả web, mọi lượt đột biến (dựng rồi chạy), chế độ công cụ thật (VieNeu, faster-whisper, ffmpeg).
- **Lệnh nhẹ, không cần qua cửa:** `git`, `grep`, đọc tệp, `python docs/_tools/*`, `dotnet restore`, `dotnet format`.
- Cửa cho tối đa **2 lệnh nặng cùng lúc trong cả M7** (agent nào cũng vậy, kể cả verifier và coder khác nhau). Hết chỗ thì đợi, tối đa 60 phút (thoát 98: báo phiên chính, không tự chạy chồng).
- Cửa đợi tới khi TIME_WAIT dưới 4000 và RAM trống từ 3 GB (tối đa 10 phút, quá hạn chạy tiếp và nói rõ); hạ ưu tiên xuống BelowNormal; đặt `MSBUILDDISABLENODEREUSE=1`, `DOTNET_CLI_USE_MSBUILD_SERVER=0`; trả mã thoát của lệnh.
- Mỗi lúc đúng **một** `dotnet test` của mỗi agent (luật cũ giữ nguyên). Vitest luôn kèm `--maxWorkers=2`.
- Khoá nằm ở `C:\Projects\_wt\m7\.heavy-locks\` (hệ điều hành tự nhả khi tiến trình chết). Agent bị dừng giữa chừng không giữ chỗ.

## 2. Giảm việc lặp

- **Coder:** chỉ chạy lớp test của chính task, cộng tối đa MỘT lô lân cận khoảng 150 ca (chọn lớp mà tệp dùng chung đã sửa chạm tới). Lô lân cận lớn (hàng trăm ca, 30 phút) để verifier, và bộ đủ một lần cuối sóng (D-lead-030).
- **Đột biến:** coder tối đa **8** (logic rủi ro nhất, ghi rõ hành vi nào CHƯA có đột biến chứng minh); verifier tối đa **20** (chọn chỗ coder chưa đột biến). Mỗi lần khôi phục tệp phải làm mới mtime và đối chiếu sha256.
- **Dựng:** `--no-incremental` chỉ ở lượt build đầu và lượt build cuối; giữa các lượt dùng build tăng dần.
- **Verifier:** tập Integration gọn theo tệp mà patch chạm; nêu lý do chọn tập. Không chạy bộ đủ.

## 3. Việc không nằm trên đường găng Mốc 1 thì xếp sau

Phiên chính giữ hàng đợi: tối đa 2 làn nặng cùng lúc; đường găng (T076, T083, T065a, T084, T085, T189, T190) đi trước; T066, T065 phần còn lại và việc web ngoài đường găng chờ chỗ trống.

## 4. Dọn máy

Ai bật tiến trình thì tắt (D-lead-031). Không để tiến trình nền khi đợi; container Testcontainers của mình tự gỡ; xong sóng phiên chính chạy `don_may.ps1 -Dung`.
