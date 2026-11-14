# Tin nháp gửi Phúc — rà XII M3-039…M3-059 (04/11/2026) · CHƯA GỬI

Người nhận: Trương Công Phúc. Lead xem, sửa rồi tự gửi. Báo cáo: `modules/m34/ra-soat/2026-11-04-phuc-xii.md`.

---

Phúc ơi, sáng nay 07:10 anh rà mảng XII từ M3-039 tới M3-059 như em báo là đã xong và đã merge dev. Anh chưa thấy phần mã đó ở đâu cả.

**Anh thấy gì:**
- Trên GitHub, `dev` vẫn ở `527204310` (03/11 12:39). Repo được đẩy lần cuối lúc 03/11 17:04, là nhánh của Tài.
- Mảng XII trên `dev` chỉ có 3 commit, đều từ tối 02/11: M3-039 `7f360a879`, M3-040 `e261827c1`, M3-043 `7c5f5db6a`.
  Không có commit nào cho M3-041, 042, 044 tới 059 trên mọi nhánh remote, cũng không có PR.
- Trên Sheet, các task này vẫn Chưa bắt đầu (M3-044 Bị chặn), cập nhật lần cuối 02/11. M3-039 vẫn Đang làm.

**Em làm giúp anh:**
1. Gửi anh SHA và tên nhánh/remote em đã merge. Nếu mới merge trên máy em thì đẩy lên `PhucApu` rồi mở PR vào `dev` (D-m34-019).
   Task R3 chỉ vào `dev` khi anh duyệt Đạt (D-m34-010 mục 9).
2. Mỗi task xong thì chuyển Sheet sang Chờ review, ghi SHA, lệnh test và kết quả. Anh rà ngay khi thấy cập nhật.
3. M3-039: execution note của em còn ghi IN_PROGRESS: E2E 36/37 (ca rememberMe), 27 ô UAT chưa tick, chưa hẹn buổi UAT 30 phút.
   Hạn rememberMe anh sẽ chốt riêng; em sửa cấu hình hoặc test theo đó, rồi hẹn buổi UAT.
4. M3-040, M3-043 vẫn giữ các việc cần sửa từ hôm qua (ghi ở cột Ghi chú Lead). Cả hai đang nằm trên `dev` khi chưa duyệt:
   gỡ khỏi `dev` qua PR, sửa trên `PhucApu`, xong thì báo anh rà lại.

Anh đã ghi "Cần sửa" kèm lý do vào cột Lead duyệt của 19 task này để em xem lại từng mục. Có mã lên GitHub là anh rà lại liền.
