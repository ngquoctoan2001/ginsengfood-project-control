# Tin gửi Tài · rà M6 ngày 13/11/2026 · lượt 3 (CHƯA GỬI)

> Gộp luôn các quyết định ngày 05/11 (tin gộp 05/11 chưa gửi). Gửi đúng phần dưới vạch; kèm tệp `2026-11-05-m6-114-de-xuat.md` cho phần M6-114.

---

Tài ơi, sáng nay anh rà 47 task M6 đang Hoàn thành/Chờ review, ở `main` `2f733b21`. Kết quả đã ghi vào cột Lead duyệt và Ghi chú Lead trên Sheet, mỗi task có ghi rõ việc còn lại.
Test anh chạy lại ở `2f733b21` (container Python 3.12 + PG16): pytest 3413 passed, 2 ca `test_pepper_check_tools` chỉ đỏ khi bản sao thiếu lịch sử git (clone đủ thì xanh); smoke 318 passed. Web: typecheck, lint, build đạt, vitest 401/401, fixtures-m6 khớp contract. `test_worker` 5 lượt Linux đều xanh.

**Đạt (37):** 033, 034, 036, 037, 043, 045, 046, 053, 060, 062, 064, 072, 073, 074, 075, 077, 081, 102, 135, 138, 139, 140, 141–153 (13 task UI và route), 155, 156. Phần UI và route quản trị làm chắc tay.
**Cần sửa (10):** 015, 024, 038, 052, 100, 120, 125, 131, 133, 137.
**Còn treo từ 05/11 (em chưa cập nhật):** 042, 044, 051, 063, 134, 136; ghi chú cũ trên Sheet vẫn đúng.

**1. Đường găng tới Go/No-go (chậm nhất 20/11)**
- **Gắn tag `m6-l1-done` ở `d7fe04e`.** Anh đã chốt từ 05/11, chưa có tag nên `deploy.py` dừng mã 11, chưa dựng được gì lên .60. Ghi DL kèm (M6-024).
- **DL-O09 đăng nhập admin:** auth hiện chỉ NONE/FAKE, nên ngoài dev mọi `/api/admin/ads/*` trả 401: 8 màn UI và phần nhập chi phí cho M9 chưa dùng được trên .60. Em chốt với Anh Tuấn sớm (M6-042, M6-154).
- **Đường từ UI tới m6-api:** UI gọi `/api/admin/ads` cùng origin, m6-api chỉ mở `127.0.0.1:6600`, khối nginx mẫu là `/m6/` và đang tắt. Em khai prefix `/api/admin/ads/` trong bản khai (M6-100) rồi gửi Anh Tuấn.
- **Smoke Go/No-go:** `smoke_report.py:88` trỏ tệp ADS-P0-016 chưa có nên lệnh luôn thoát 1. Thêm test (đỏ trước) hoặc ghi DL tạm bỏ khỏi bắt buộc; chốt nhóm S1–S4 (M6-120).
- **Hồ sơ Go/No-go (M6-125):** sửa lịch theo quyết định mới: họp 2 ngày làm việc sau khi `mkt.` trên .60 có HTTPS, chậm nhất 20/11; release theo Go/No-go; chạy thật 30/11. Máy là .60 (không phải .63); ĐK2 chỉ còn việc gắn tag. Soát xong nộp anh trước buổi họp.

**2. Quyết định của anh ngày 05/11, em ghi DL giúp (chưa thấy trong DECISION_LOG)**
- M6-039: đọc ba cờ `M6_GLOBAL_GATEWAY_STATE`, `M6_PRODUCTION_FLAG`, `M6_EXTERNAL_SEND`, thiếu thì dùng hằng; chỉ nhận BLOCKED/OFF/OFF, giá trị khác (kể cả rỗng, `on`) thì app/worker không khởi động. Thêm 2 test: ON/rỗng bị từ chối; không lane nào export tên cờ. Mở production vẫn là quyết định riêng ở Go/No-go.
- DL-O25: tới khi pháp chế duyệt (M6-117) chỉ nhận mã CH21 thử, không nhận mã khách thật. Đóng DL-O25 theo phạm vi này (`DECISION_LOG:308` còn OPEN).
- Tag L1: gắn ở `d7fe04e`; tiêu chí 7 chỉ xét `app/` và diff L1; ĐK 4, 5, 9, 10 dời sang L0.
- M6-114: duyệt T-9, T-2, T-1, T-3, T-4, T-8 đúng như tệp đề xuất kèm theo; T-5, T-6, T-7, T-10 dùng mặc định trong bảng tới khi chốt.

**3. Sổ sách và chỗ lệch nhỏ**
- M6-015: thẻ và outcome còn ghi GitHub Actions; đổi sang CI_LOCAL theo DL-089, dán CI_LOCAL N/N trên `main` hiện tại.
- M6-038: bước docker của RUNBOOK 2.2 còn NOT_RUN; dòng 117 còn "2 job(s)" (nay 6); điền ngày xong.
- M6-045: anh đã chuyển sang Đạt. DL-083 (danh sách event track công khai) là phần bảo mật nên PM không chốt thay được; anh xác nhận nguyên văn DL-083 ngày 13/11, em ghi người chốt là Toàn (13/11) vào dòng đó.
- M6-052: PR #56 gộp squash; ghi vào WT như WT-056/057. Dòng đo chưa mang nhãn v1 (TRK-72): ghi DL hoặc thêm cột.
- M6-131: docs còn staging .63 (`SAD.md:266`), DL-095 và C1–C4 cũ ở `admin-ui-api.md:41,366`, lịch cũ; chốt commit ứng viên.
- M6-133: thêm outcome và thẻ, đổi tiêu đề cho đúng việc (conversion và tín hiệu M5, không phải track).
- M6-137: compose chưa có `M6_INBOUND_HMAC_KEY_*` (TRK-81); ghi DL dời sang task gắn kênh máy.
- M6-037: anh đã chạy 5 lượt Linux xanh, em ghi số vào WT-041.

**4. Cần em chốt sớm (không chặn ngay)**
- DL-098: Diamond Revenue đã loại đơn chỉ có `diamond_id`, nhưng số commission-ready vẫn tính các đơn đó. Chốt trước khi M9/kế toán dùng số.
- `CLAUDE.md` §6 đòi `GATE=ĐẠT` cho thay đổi trong `web/`, nhưng `run.cjs` không chạy gì trong `web/`. Nên sửa §6: web chạy typecheck, lint, vitest, build.
- TRK-88 (route scale trả 500 với ký tự NUL/số mũ lớn) nên sửa trước staging.

Em cứ làm theo thứ tự mục 1 rồi 2, xong phần nào cập nhật Sheet là anh rà lượt sau, không cần chờ anh trả lời từng ý.
