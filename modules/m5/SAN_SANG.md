# Sẵn sàng — M5 Facebook Gateway

> Cập nhật bằng chứng27/11/2026 tại `f9318df5`. Chưa chấm lại trọng số/thang readiness; các số11%/25% trong báo cáo cũ là lịch sử.
> Mốc30/11 giữ nguyên. Lượt rà không nghiệm thu production hoặc mở khách thật. Task Đạt không thay Go/No-go.

## Năng lực và phần còn thiếu

| Nhóm | Đã kiểm ở code/hồ sơ | Cổng còn thiếu |
|---|---|---|
| Nhận và gửi Facebook | Webhook sai chữ ký dừng trước ghi DB; cửa gửi/adapter và bộ chạy SMK đã có | Sheet110 ghi lượt.98 ngày24/11:1 PASS/14 FAIL/1 NOT_RUN; chưa đủ16/16.42/51/53 chờ cập nhật;43/56 đang làm |
| Phân quyền và đăng nhập | JWT iat/jti/tuổi8giờ; OTP mail, người dùng/vai, cookie làm mới, web hiện tại525/525 | P2 audit165 và logout168; receipt ma trận.98 task016, duyệt diff R3 task162 |
| An toàn dữ liệu/nội dung | Các sửa masking/địa chỉ/secret đã gộp; task134 Đạt; test không DB217/0 |126 còn7 lớp phải chốt rõ;141 chưa receipt RU18 trên .98;135 chưa cập nhật; pháp chế103 chưa gửi/nhận kết luận |
| UI quản trị | AppShell bước4 và nhãn Việt đạt (139/164), danh mục quyền đã có |166 chờ Tài duyệt chữ; không có UAT trình duyệt mới trong lượt rà |
| Vận hành/cảnh báo | Sink mail có receipt gửi, runbook pilot và lock_timeout đã có |081 thiếu AL-01/AL-23;083 chưa diễn tập cờ dừng/lịch trực đủ |
| Sao lưu và phục hồi | PR183, dump15phút, backup-check, restore-drill; hồ sơ ghi restore DB.98 10giây |092: DL255, bản ngoài máy TRK99, cảnh báo TRK100;10giây chưa gồm dựng lại máy/lấy dump |
| Meta và pilot | HTTPS/policy/deploy.98 có receipt trong repo; quyền xử lý Meta giao Tài D-m5-070 |102 thiếu cập nhật kết quả sau25/11;114 Go/No-go còn dữ liệu cũ; chưa chứng minh đủ điều kiện mở khách thật |
| YouTube |9 bảng và OAuth nhiều kênh có code;152 Đạt |153 còn DL251/gate;154–161 Chưa bắt đầu trên Sheet, chưa có luồng đọc–soạn–duyệt–gửi đầy đủ |
| Quy trình/chứng cứ |007/133/143 đã khép phần được giao;32 task được rà và ghi Sheet |002/074/101/103/114/121/122/151/169 và các receipt còn thiếu theo bảng; không đóng bằng lời tự khai |

## Quyết định đang áp dụng

- D-m5-067: trong khung thử được giao, sự kiện người ngoài vào thì đếm; dừng khi gửi ra ngoài danh sách thử hoặc trả lời công khai lộ giá/dữ liệu cá nhân. Không giữ câu cũ tự dừng chỉ vì nhận sự kiện.
- D-m5-069/070: không đăng ký Tech Provider; Tài tự làm các bước Meta/App Review trên Page pilot. Chưa được Meta duyệt tới30/11 thì phạm vi nội bộ theo quyết định, không suy quyền khách thật.
- D-m5-059/060/061: ngoại lệ YouTube thử bằng bình luận nhân viên đã chốt, Page ngoài Hub không chốt đơn; docs phải nhập lại, không hỏi Lead lần nữa.
- D-m5-065/DL250: JWT M5 tự ký từ đăng nhập mail, không tiếp tục chờ nguồn token Tuấn cũ. Duyệt diff R3 vẫn cần receipt.
- DL217 đã ký; không dùng thiếu chữ ký cũ để chặn141. DL236 có hiệu lực nhưng cột7 lớp a10/a11 vẫn chờ xác nhận rõ.

## Bước tiếp

1. Tài sửa hai race165/168 và thêm test; chốt các receipt/quyết định còn thiếu theo bảng32 task.
2. Hoàn tất cảnh báo, diễn tập cờ dừng, backup ngoài máy/cảnh báo; nộp bằng chứng SMK/UAT trên đúng bản triển khai.
3. Đồng bộ policy/nhãn code, pháp chế, Meta và hồ sơ Go/No-go; cập nhật004 theo máy.98.
4. Trình đúng ứng viên và bằng chứng cho Toàn quyết; không nâng readiness chỉ vì merge hoặc test local xanh.

## Bằng chứng và giới hạn

- [Rà27/11](ra-soat/2026-11-27-tai.md), [bảng32 task](ra-soat/evidence/2026-11-27-tai/bang-tung-task.md), [receipt32/32](ra-soat/evidence/2026-11-27-tai/ghi-ket-qua.json).
- Local: typecheck/Prisma validate/docs PASS;217 probe PASS,34DB/Redis SKIP;web525/525 PASS. Hai repro race xác nhận lỗi.
- Không SSH, DB chung, Meta/Google/SMTP thật; receipt.98 là hồ sơ đã đối chiếu, chưa reverify server.
- Bản SAN_SANG trước lượt này lưu trong evidence `san-sang-before.md`; không lấy các số/mốc cũ làm hiện trạng.
