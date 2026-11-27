# Sẵn sàng — M6 Đo quảng cáo / ROAS

> Cập nhật 27/11/2026 theo lượt rà 5 tại module5/main `f9318df5`, sổ M4-PLAN `a1245e55`. **13 Đạt,10 Cần sửa/23 task**; chưa dựng lại điểm/trọng số toàn module.

## Kết luận theo bằng chứng

Chưa đủ bằng chứng quyết định Go-live. Hạn chạy thật 30/11(D-lead-025); mốc họp Go/No-go chậm nhất 20/11(D-m6-013) đã qua nhưng hồ sơ được rà chưa có kết luận mới. Không tính readiness từ số task DONE hay testpass.
Code doanh thu M3 giả lập đã tiến thêm đến dashboard và hoàn-huỷ. Phần triển khai/bảo mật có nhiều sửa và log .98; nguồn doanh thu M3 thật và các gate nghiệm thu vẫn chưa hoàn tất.

## Phạm vi đã kiểm

| Gói | Hiện trạng27/11 | Phần còn phải có |
|---|---|---|
| Nền/L1/vệ sinh | M6-014, 024, 130 Đạt; LF / ngoại lệ OWN-430, hồ sơ L1, tag d7fe04e, tài liệu theo DL | Đồng bộ metadata Sheet cũ của 130 |
| Migration/local | M6-038Đạt; root PG 16 trống áp 31, replay 0,pending 0; E2E L2 đạt | Không dùng làm nghiệm thu .98 |
| Tư thế/JWT/PSID/compose | 039, 133, 157 Đạt; JWT code/test đạt,21/11 có hồ sơ login | 042 chờ kýDL-228, khớp bản khai và người giữ/cấp khoá |
| Registry/map/outbox | 051 Đạt; DQ đọc đúng liên kết ở160 | 052 kýDL-110 hoặc đủ trường dòng đo;082/TRK-90 sửa policy=None vẫn enqueue |
| M3 giả lập | 054, 055, 056, 160 Đạt; giao dịch inbox, chống trùng, adjustment, linkDQ | 057 kýDL-120;058 chốtDL-O81/tiêu chí lý do thiếu nguồn |
| Deploy/image | 159 Đạt; log 21/11 image-check 0,migration 0031, health 200; hồ sơbuild/deploy 24–25/11 | 100 kýDL-113, sửaJWT trong bản khai, bằng chứng gửi; chưa xác nhậnimage đang chạy hôm nay |
| Bảo mật | JWT/body/dump/env/dependency/container đã sửa qua177/179/180/184 | 122:T7 token Sheet, T8 giới hạn truy cập, T9 thu hồi bí mật; báo cáo SHA mới; test JSON Linux đỏ |
| Smoke/docs/Go/No-go | Docs 0 lỗi / 40 cảnh báo, traceability khớp; có smoke và ADS-P0-016 | 120 kýDL-111;131 chốtDL-112/release notes;125 pack còn DRAFT ở b369b491 |
| Nghiệm thu thật/M9/ops-core | Đã có hồ sơ .98, nguồn chi phí có mã từ các lượt trước | UAT, smoke đúngcandidate, restore/alert/thu hồi và tích hợp thật có biên bản; không nâng bậc chỉ từhealth 200 |

## Test và nguồn chứng cứ

- Root:36 tệp/1085 ca lọc trênLinux Python 3.12.16,dependency khoá vàPG 16 riêng. Sau cài git cho runner/chạy lại deploy:1084 pass,1 fail,0 error,0 skip. [Chi tiết](ra-soat/evidence/2026-11-27-tai/test-summary.json).
- CaJSONclosed-3000: fixture thiếu scale deps, Python vẫn parse được;503 thay 400. Đây là việc sửa bài test/khác môi trường, chưa chứng minh lỗi API production.
- ReceiptPR 188 tại `f447423a`:CI_LOCAL 11/11,4414 pytest Python 3.12.10;runtime/tests/migration/scripts/dependencies hiện tại trùng head đó. Đây là bằng chứng phía Tài, không phải rootfull suite 27/11.
- GitHubActions không khởi chạy vì giới hạn thanh toán. Kiểm mã local và hosted CI tách biệt.
- Deploy/login/.98 là đọc log/tài liệu, không live UAT/SSH trong lượt rà. Trạng thái máy hiện tại chưa xác minh trực tiếp.

## Cổng và quyết định còn giữ

- BLOCKED/OFF/OFF; không mở route ngoài, không đổi cờ. Chưa có M3 thật: doanh thu/ROAS chưa nghiệm thu; reader không nguồn.
- DL-104/T-4 đã thay ORDER_REVERSED bằng REVENUE_REVERSED + lý do: không bắt sửa code về tên cũ. M6-055 Đạt phạm vi này.
- M6-114: T-5/6/7/10 tiếp tục mặc địnhDL-104. Kết luận về consent/pháp chế/production chỉ khi đúng người chốt.
- M6-057/058 vàDL-110/111/112/113/120/228 chưa hoàn tất chữ ký/quyết định cần thiết. AI không ký thay Tài/Lead.
- M6-125 phải gắn một SHA ứng viên và đủ bằng chứng12 Done Gate; hiện chưa đủ điều kiện chốt chạy thật30/11.

[Bản rà27/11](ra-soat/2026-11-27-tai.md) · [Bảng23 task](ra-soat/evidence/2026-11-27-tai/task-review.md) · [Lượt4 ngày16/11](ra-soat/2026-11-16-tai.md).
