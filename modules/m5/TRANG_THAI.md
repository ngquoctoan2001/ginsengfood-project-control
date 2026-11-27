# Trạng thái — M5

Cập nhật 27/11/2026 13:10 (Asia/Bangkok), phiên Codex rà Tài.
Code `module5/main` = `origin/main` = `f9318df5c1efd8abff980d7837eaf232656e90b6`, đã pull ff-only, checkout sạch.
PLAN ghim `a1245e55`; checkout được đồng bộ trong lúc phiên M34 đang dùng, phiên này chỉ đọc git object.
Quyết định mới nhất đã đọc: D-m5-070 (25/11). Mốc chạy thật 30/11; chưa có kết luận Go cho khách thật trong lượt rà này.

## Kết quả rà

- 32/32 task cần rà: **10 Đạt, 22 Cần sửa**; 6 task chờ Tài cập nhật sau lần trả lại trước.
- Đã ghi cột W/X bằng `sheet_lead.mjs`, `ok:true`, **verified32/32**; giữ trạng thái của người làm và ghi chú cũ.
- Đạt: 007,133,134,139,143,146,152,163,164,167.
- Chờ sửa từ lượt cũ: 036,042,051,053,104,135; không rà hoặc ghi lại các dòng này.
- Sheet toàn tab: 122 task; 57 Hoàn thành,35 Chờ review,15 Đang làm,14 Chưa bắt đầu,1 Hủy. Không tính readiness theo số task.
- Báo cáo: [rà 27/11](ra-soat/2026-11-27-tai.md); [đủ 32 dòng](ra-soat/evidence/2026-11-27-tai/bang-tung-task.md); [tin nháp](ra-soat/2026-11-27-tai-tin-nhan-nhap.md), chưa gửi.

## Thay đổi và bằng chứng

- Từ lượt rà16/11: thêm69 PR trong repo chung M5/M6. M5 có đăng nhập mail, quản lý người dùng/quyền, refresh cookie, AppShell/nhãn Việt;
  nền dữ liệu/OAuth YouTube, sink mail, policy, sửa masking/webhook/JWT, backup15phút, runbook pilot và công cụ SMK/load.
- Kiểm tại đúng SHA: typecheck source/test, Prisma validate, docs links/trace PASS; root **217 PASS /34 SKIP /0 FAIL**;
  web typecheck/lint PASS, **525/525 PASS**.34 probe DB/Redis không chạy. Không truy cập server/Meta/Google thật.
- Repro mới P2:165 audit sai vai cũ khi sửa đồng thời;168 refresh đến muộn phục hồi state/token UI sau logout.
  Hai ca dùng source thật và dữ liệu giả; chưa kết luận lỗi phân quyền backend từ repro UI.

## Việc chặn và bước tiếp

- Tài sửa165/168, thêm test race; hoàn tất luật cảnh báo081, diễn tập cờ dừng083, backup ngoài máy/cảnh báo092.
- M5-110: Sheet còn SMK.98 ngày24/11 =1 PASS/14 FAIL/1 NOT_RUN; cần bộ nghiệm thu đúng ứng viên.
- M5-114 Go/No-go còn DRAFT, mốc20/11/HTTPS/sink lỗi thời; điều kiện dừng phải áp D-m5-067.
- Meta: áp D-m5-069/070. Không Tech Provider; Tài tự xử lý/nộp App Review trên Page pilot, không hỏi từng bước.
  Tới30/11 chưa được Meta duyệt thì chỉ phạm vi nội bộ theo quyết định đã có; task102 chưa có receipt mới trong nguồn đã kiểm.
- Policy101/169: nhãn code mới và policy lệch; DL-257/cách trả lời người hay máy cần chốt trung thực. Pháp chế103 chưa có receipt gửi/kết luận.
- YouTube 154–161 vẫn Chưa bắt đầu trên Sheet; phần152/153 chưa chứng minh đủ luồng bình luận. Nhập D-m5-059/060/061 đã chốt vào sổ.
- Còn các xác nhận/receipt trên từng task, gồm duyệt diff162, DL-251/gate153; không đồng nhất22 Cần sửa với22 lỗi code.
- M5-004 còn ghi máy .60, phải cập nhật theo hạ tầng.98 đã giao. Không dùng lại giả định chưa deploy ngày22/10.

Sẵn sàng chưa chấm lại theo thang chung; không dùng % lịch sử25% làm mức hiện tại. [SAN_SANG](SAN_SANG.md) cập nhật theo bằng chứng lượt này.
