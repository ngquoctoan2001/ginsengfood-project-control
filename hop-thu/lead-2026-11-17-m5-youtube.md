# Từ phiên m5 · 17/11/2026 · M5 thêm YouTube — việc của phiên lead

Toàn giao 17/11: M5 kết nối nhiều kênh YouTube, gom bình luận, M4 phân loại + chọn mẫu trả lời kéo khách về Fanpage, M4 tư vấn trên Messenger.
Thiết kế: `modules/m5/giao-viec/2026-11-17-youtube-binh-luan.md`. Toàn chốt 17/11 09:44: D-m5-053 làm cả 3 giai đoạn ngay, D-m5-054 Fanpage đích linh hoạt,
D-m5-055 M4 hiểu ngữ cảnh và tự soạn câu trả lời công khai (ngoại lệ BR-018 chỉ cho YouTube), D-m5-056 có tên + link Fanpage (ngoại lệ BR-040 chỉ cho YouTube), D-m5-057 người duyệt mặc định.

Việc cần phiên `lead` (làm ngay, theo D-m5-053):
1. `ginsengfood-contracts`: gói "YouTube Live Gateway" đang là gói dự phòng CATEGORY-04, bị chặn tới `ACTIVE_GOVERNED_EXTENSION` (`MASTER-06 …:1773`, §19.7).
   Cần kích hoạt phần **bình luận YouTube** (chưa gồm Live), thêm mã kênh `YOUTUBE_COMMENT` vào enum kênh, ghi chế độ `PUBLIC_REPLY` của `/advise` v2 (§7 thiết kế). Tài review.
2. `TONG_QUAN.md`: M5 đang ghi "cổng Facebook" — thêm YouTube (Toàn đã chốt).
3. **Phát hiện ngoài YouTube, ảnh hưởng chạy thật 30/11:** M4 `POST /api/v1/m4/channel/advise` trả **403 khi M4 chạy production**
   (`ChannelAdviseController.java:104-106`; `auth.m4-channel-advise-enabled` mặc định false, ghim false ở `application-production.yml:51`; nhánh `origin/dev015` `26ae11956`).
   Nghĩa là M5 tư vấn Messenger bằng M4 sẽ không chạy khi M4 ở cấu hình production, trừ khi có quyết định bật. Phiên lead/m34 (phần Tài) kiểm xem đã có kế hoạch chưa.
4. Dự án Google Cloud của công ty cho YouTube Data API: Toàn + Tài quyền Owner, dùng tài khoản công ty (không tài khoản cá nhân). Nếu phiên lead đang giữ danh mục tài khoản/hạ tầng thì ghi vào đó.
