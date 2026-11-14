---
description: Dựng lại hoặc làm mới SAN_SANG.md của luồng - hạng mục tới chạy thật, bậc hiện tại có bằng chứng, gói việc lớn, đường găng tới 14/11 - bằng nhiều scout song song
argument-hint: [ghi chú thêm của Lead]
---

Dùng trong phiên đã `/phien`. Mục tiêu: biết chính xác còn gì để luồng này chạy thật, chia thành gói việc lớn chạy song song được.
Ghi chú của Lead (nếu có): $ARGUMENTS

1. **Chia khảo sát** thành 3–4 mảng không chồng nhau theo mục "Mảng khảo sát" của `PHIEN.md`. Không có thì chia:
   (a) chức năng lõi; (b) nối liên module (G2); (c) bảo mật, dữ liệu, triển khai, vận hành (G3–G6);
   (d) kiểm thử, nghiệm thu, việc ngoài code (G7–G8).
2. **Giao song song:** một message, mỗi mảng một `scout` chạy nền. Brief mỗi scout ghi: repo + tài liệu kế hoạch/spec/tracker
   cụ thể cần đọc; câu hỏi phải trả lời; yêu cầu đầu ra: bảng hạng mục (tên người ngoài hiểu được · bậc hiện tại theo thang
   `chung/CONG_PRODUCTION.md` §1 · bằng chứng `tệp:dòng`/lệnh/SHA) + khoảng trống + phụ thuộc ngoài (ai, cần trước ngày).
   Luồng của người khác (`m34`, `m5`, `m6`): thêm một `auditor` đối chiếu kế hoạch của người làm với git.
3. **Ghép vào `SAN_SANG.md`** theo khung `chung/MAU.md` §0 (thay hẳn bản nháp cũ):
   - bảng hạng mục lõi (5–10 dòng, trọng số tổng 100, bậc, bằng chứng) và hạng mục mở rộng;
   - cổng G1–G8: đạt / chưa / không áp dụng;
   - gói việc WP: mục tiêu, tiêu chí đạt, phạm vi ghi, tệp nóng, rủi ro, phụ thuộc, hạn theo mốc, ước lượng, trạng thái;
   - đường găng tới mốc A–D; việc ngoài code có người gỡ + ngày;
   - phần không kịp 15/11 + bản tối thiểu chạy được 15/11.
   Bỏ chữ "BẢN NHÁP" khi mọi bậc đã có bằng chứng.
4. **Kiểm chéo:** mỗi hạng mục lõi dưới 90 có ít nhất một WP hoặc lý do; các WP dự kiến chung sóng không chung tệp nóng;
   tổng ước lượng so với số ngày còn lại và số làn (L1–L3) có thực tế không.
5. **Trả Lead (≤ 30 dòng):** % hiện tại, kịp 15/11 không và vì sao, 3 rủi ro lớn nhất, câu hỏi cần quyết (đánh số),
   đề xuất 2 sóng đầu. Ghi một dòng nhật ký.
