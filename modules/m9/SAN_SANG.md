# Sẵn sàng — m9 (M9 Tài chính, MISA)

> **BẢN NHÁP 17/11/2026** (luồng mới, D-lead-059). Chưa chấm bậc; chạy `/ke-hoach` sau lượt rà đầu tiên tài liệu MISA của chú Dũng.

## Hạng mục (chưa chấm)

| Hạng mục | Tình hình 17/11 | Bằng chứng |
|---|---|---|
| Hoa hồng, chi trả | có mã `commission/`, chạy trên .99 (bản `afb6d404c`) | chưa rà trong luồng này |
| Kế toán nội bộ: lời lỗ tháng, hoá đơn nội bộ, đối soát COD | mã chú Dũng đợt 15–16/11 (nhánh `chudung/m9-*`, một phần đã gộp qua nhánh gộp M3) | chưa rà |
| Kết nối MISA AMIS Kế toán (17 loại chứng từ, kế toán duyệt hai bước) | tài liệu bản 2 (`a3458abd5`) đã rà 17/11: đủ bắt đầu phần chắc, 24 mục sửa; chưa có mã; mã nền chỉ trên nhánh gộp chưa vào `dev` | `ra-soat/2026-11-17-rasoat-tai-lieu-misa.md` |
| Luật tiền M9 được kế toán trưởng duyệt trước khi bật thật | D-m34-083 | chưa |

## Gói việc

Đề xuất 17/11 (chưa phiếu, chờ Toàn gửi Tài + chốt m9.1–m9.2; chi tiết `ra-soat/2026-11-17-tai-ket-noi-misa-kem.md` §4):

| Gói | Việc | Cần trước | Hạn đề xuất |
|---|---|---|---|
| MISA-00 | Tài đầu mối: tài khoản AMIS (chị Giang), đăng ký ClientID, dữ liệu thử, câu hỏi kế toán + MISA, gửi chú danh sách sửa (D-m9-006) | — | 18/11 (ClientID tuỳ MISA) |
| MISA-01 | bộ gửi `api` + AMIS giả, phân loại lỗi, ngắt mạch, kiểm cấu hình | — (dev hiện tại) | 20/11 |
| MISA-02 | mô hình V2, migration V392 + sửa ràng buộc V321/V328, trạng thái, duyệt hàng loạt, quyền | nhánh gộp vào `dev` | 22/11 |
| MISA-03 | callback, kéo dự phòng, đồng bộ danh mục | 01, 02 | 24/11 |
| MISA-04 | bộ lập #1 #2 #3 #6 #8 #9 #10, lô 01:00 quét lùi | 02 | 25/11 |
| MISA-05 | bộ lập #4 #5 #7 + chi hoàn tiền, #11 #12 | 02 | 26/11 |
| MISA-06 | bộ lập #13 (+ trường nền tảng M6) #14 #15 #16 #17, thông tin hoá đơn công ty | 02 | 27/11 |
| MISA-07 | màn MISA + đối chiếu ngày/tháng | hợp đồng §9 | 28/11 |
| MISA-08 | Tài tự thử 22 bước trên dữ liệu thử AMIS, chị Giang ký | ClientID (00), 01–06 | khi có ClientID |

