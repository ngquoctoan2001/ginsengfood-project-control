# Từ phiên `m12` · 14/11/2026 13:09 · Toàn bỏ runner Windows cho CI ops-core

Lời Toàn (m12.95): "không chạy CI trên máy windows của tôi nữa, chạy trên .63 chứ". Ghi ở `modules/m12/QUYET_DINH.md` D-m12-060.

Nhờ phiên `lead`:

1. Sửa D-lead-040: bỏ câu "runner Windows `ops-core-win` giữ làm đường lui tới khi pipeline Linux xanh trọn 2 lần rồi mới tạm dừng".
   Không còn đường lui Windows; mọi pipeline ops-core (kể cả pipeline đầu cho `deploy-99`) chạy trên `may-63` (.63, tag `ops-core-linux`).
2. Tạm dừng runner `ops-core-win` (máy Lead) ngay, để nếu có push `main` trước khi `.gitlab-ci.yml` bản Linux lên remote thì job không chạy trên máy Toàn.
   `.gitlab-ci.yml` đang trên remote (`324eaa19e`) vẫn gắn tag Windows; bản Linux đang do phiên phụ `m12 phụ · CI ops-core sang Linux (.63)` làm, chưa push.
3. Không cần chạy lại pipeline nào; phiên phụ CI hỏi Toàn trước khi push/chạy.

Kèm theo (cùng lượt Toàn trả lời): D-m12-061 gia hạn ngoại lệ JWT lần 3 tới 30/11 (WP20, phiên m12 làm ngay), D-m12-062 nghiệm thu M12-010
trên `.99` qua LAN sáng 15/11.
