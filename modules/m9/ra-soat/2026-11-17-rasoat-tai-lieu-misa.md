# Rà tài liệu kết nối MISA của chú Dũng (bản 2) · 17/11/2026

- **Đối tượng:** `docs/m9/misa/2026-11-17-brief-ket-noi-misa-amis.md` (1.190 dòng) + bản sao `2026-11-14-mo-ta-dong-bo-misa-ban-nhap-03.md`,
  nhánh `origin/chudung/m9-17112026-brief-ket-noi-misa-cho-tai` `a3458abd5` (= `91f16fae4` bản 1 → `dd1cff191` bản 2 → gộp `dev` `ed5664dff`). Nhánh chỉ thêm 2 tệp tài liệu, không có mã.
- **Đối chiếu với:** `origin/dev` `ed5664dff`; nhánh gộp của chú `origin/chudung/m3-14112026-gop-cac-nhanh-sua-ngay-14-11` (`2fc679e20` tài liệu dẫn, đầu nhánh `4ab3b8a9f`);
  ops-core `origin/main`; tài liệu MISA công khai "AMIS Kế toán Open API" V1.0.0 (05/08/2026, `developer.misa.vn`).
- **Cách rà:** chỉ đọc (`git show`, `git grep`), không checkout, không sửa nhánh chú, không gọi MISA. Phiên m9 tự rà phần nghiệp vụ/định khoản; 1 auditor rà mã, 1 agent đối chiếu API công khai.
- **Bằng chứng chi tiết** (ngoài git): `ra-soat/2026-11-17-misa/a-hien-trang-ma.md`, `ra-soat/2026-11-17-misa/b-api-misa.md`.

## Kết luận

**ĐỦ ĐỂ TÀI BẮT ĐẦU, nhưng chỉ phần chắc. CHƯA ĐỦ để code migration và bộ lập chứng từ cuối cùng.**

Phần làm được ngay: tài liệu đã chốt kiến trúc, phạm vi, quy tắc tiền, trạng thái, API nội bộ, thứ tự làm và tiêu chí xong. Phần API MISA (token, `/save`,
callback, mã lỗi, mã loại chứng từ) khớp tài liệu MISA công khai bản mới. Tài làm được ngay **bộ gửi `api` + AMIS giả (WireMock) + callback + đọc danh mục**
trên `dev` hiện tại.

Phần chưa làm được, 6 lý do:
1. Mã nền tài liệu dựa vào (11 bảng nguồn, `OrderInvoiceVat`, `loyalty`, `distributor`, nút START, 10 khoá ánh xạ) chỉ có trên nhánh gộp của chú, **chưa vào `dev`**.
2. Migration V392 trong tài liệu chưa tính **7 ràng buộc sẵn có** của V321/V328. Làm như tài liệu thì vỡ ràng buộc.
3. **3 mẫu JSON sai trường bắt buộc**: đối tượng bên Có, `purchase_purpose_id`, `reason_type_id`.
4. **Thiếu hoặc mơ hồ 4 loại chứng từ**: chi hoàn tiền khách, mua dịch vụ vận chuyển, xuất kho đơn nhà phân phối, chứng từ về trễ.
5. **Chưa có 2 nguồn dữ liệu**: kênh bán trên đơn, nhà cung cấp quảng cáo từ M6.
6. **Chỗ nối với M1–M2 chưa thống nhất**: hai bên dùng hai họ API MISA khác nhau, cách ký callback khác nhau.

Gửi thật lên MISA 30/11 phụ thuộc ngoài code: MISA cấp ClientID, kế toán trả lời câu hỏi, kế toán trưởng ký nghiệm thu 22 bước. Tài liệu tự ước code
12–15 ngày làm việc, mà từ 17/11 tới 30/11 chỉ còn khoảng 11 ngày (tính thứ Bảy). → câu m9.2.

## 1. Việc chặn (phải gỡ trước khi Tài làm phần lớn)

| # | Chặn gì | Bằng chứng | Ai gỡ | Cần trước |
|---|---|---|---|---|
| C-1 | Mã nền chưa vào `dev`. Nhánh gộp `chudung/m3-14112026-gop-cac-nhanh-sua-ngay-14-11` hơn `dev` 78 commit, riêng `finance/` + `commission/` + migration có 146 tệp. Nhánh tài liệu dựa trên `dev` nên không có phần mã này | `merge-base`: `2fc679e20`, `4ab3b8a9f` đều không là tổ tiên của `ed5664dff`; thử gộp bằng `merge-tree` thì sạch, không xung đột chữ (a-hien-trang-ma §0) | Phúc gộp nhánh gộp vào `dev` (việc đã giao, D-m34-091). Gộp vào `dev` chưa phải deploy: thứ tự lên .99 (M12 → M8 → M3) giữ nguyên | 19/11, để Tài làm gói MISA-02 |
| C-2 | Chứng từ chi hoa hồng trên `dev` ghi **đủ chi phí lúc chi** (Nợ 6421 theo số gộp). Nhánh gộp đã sửa thành chỉ ghi phần chênh so với lúc chốt kỳ. Nếu bật gửi #11 (chốt kỳ) trên mã `dev` thì chi phí bị ghi hai lần (trái M9-QT-034 (4)) | `FinanceAccountingPostingPlanner.java` `dev` :196-198 (`COMMISSION_EXPENSE -> grossAmount`) và gộp :232-244 (`grossGap`) | Như C-1 | Trước khi bật gửi #11/#12 |
| C-3 | Chưa có ClientID, mã kết nối dữ liệu thử, câu trả lời kế toán (đường găng luồng 0 của tài liệu) | Tài liệu §12.2 | Chủ hệ thống, kế toán trưởng (Tài hỗ trợ) → câu m9.3 | Bắt đầu 17–18/11 |
| C-4 | Ràng buộc DB sẵn có làm V392 vỡ (chi tiết T-18) | V321:99-102, :109-111, :120-125, :187; V328:14-16 | Chú sửa §8.2, hoặc Tài tự xử khi viết migration rồi báo chú | Trước gói MISA-02 |

## 2. Hiện trạng mã (mục 3, 6.1, 8, 9 của tài liệu)

Mọi tệp:dòng ở §3 của tài liệu **đúng trên nhánh gộp** (`application.yml:994-1003` đúng ở `4ab3b8a9f`). Trên `dev` có 11 bảng nguồn, `OrderInvoiceVat`,
module `loyalty`/`distributor`, `FinanceJournalAccounts`, `FinanceExpenseMisaRule` và nút START ở worker **không có**. `dev` mới có 6 khoá ánh xạ, chưa có 10.
Bảng đầy đủ: `ra-soat/2026-11-17-misa/a-hien-trang-ma.md` §1.

Sai/thiếu so với mã (chú sửa tài liệu):

| # | Chỗ | Vấn đề | Sửa | Mức |
|---|---|---|---|---|
| T-18 | 8.2 migration V392 | Không tính các ràng buộc sẵn có: (a) CHECK dạng khoá chống trùng `MISA:<type>:<id>:<group>` (V321:101-102) chặn dạng `:r<n>`; (b) mỗi nguồn một job chưa huỷ (V321:109-111) chặn job điều chỉnh `revision+1`; (c) `SUCCESS` bắt buộc có `misa_voucher_no` (V321:99-100, nhật ký :189-190), trong khi callback không trả số chứng từ; (d) trigger chỉ cho sửa danh sách cột cố định (V321:120-125), nên cột mới phải được thêm vào; (e) nhật ký chỉ nhận SUCCESS/RETRYABLE/FATAL (V321:187), chưa nhận `ACCEPTED`; (f) `internal_id` chỉ cho `OBJECT_COLLABORATOR` và chỉ nhận số (V328:14-16), chặn `CHAO_SAM`, `WEBSITE`, mã SKU, `HOP`; (g) `finance_accounting_postings` chỉ chứa dòng Nợ/Có (`entry_kind` cố định, `amount > 0`), không chứa dòng hàng, nên câu "làm tương tự cho postings" phải quyết lại | Thêm vào §8.2 từng thay đổi ràng buộc, kèm test PostgreSQL cho mỗi ràng buộc | CAO |
| T-19 | 8.3 trạng thái | `SENT` hiện có nghĩa "đã xuất tệp, chờ kế toán ghi số", lệnh `confirm` dùng nó (`FinanceMisaSyncStatus.java:12`). Tài liệu đổi thành "chờ callback" | Chặn `confirm` ở chế độ `api`, hoặc thêm trạng thái riêng | VỪA |
| T-20 | 10.2 luồng gửi | `sendNextDue` gọi `gateway.send` ngay trong giao dịch đang khoá dòng (`FinanceMisaSyncService.java:308,365`). Callback có thể về trước khi giao dịch commit, lúc đó không tìm thấy job `SENT` | Gọi `/save` ngoài giao dịch (đánh dấu đang gửi trước), hoặc callback lưu nguyên bản rồi xử lý lại khi job đã `SENT` | VỪA |
| T-21 | 9.3 cổng đọc | Đã có `order/port/in/FinanceVerifiedOrderQueryPort` trên `dev` (lấy theo `verifiedAt`, chỉ có tổng đơn) và `distributor/port/in/DistributorRevenueQueryPort` trên nhánh gộp, tài liệu không nhắc | Ghi rõ: mở rộng cổng cũ hay tạo cổng mới (đề xuất tạo cổng mới cho kế toán, giữ cổng cũ) | THẤP |
| T-22 | 8.1 mô hình V2 | `sourceId` dạng chuỗi, nhưng cột `source_id BIGINT NOT NULL` (V321:67). Chứng từ gộp (quảng cáo theo kỳ + nhà cung cấp, chi phí voucher theo ngày) không có một id số | Quy ước id cho chứng từ gộp (ví dụ bảng kỳ gộp có id riêng) | VỪA |
| T-23 | 3.4 front-end | Danh sách khoá ánh xạ cứng trong `financeMisa.ts` phải thêm khoá mới | Thêm vào việc F | THẤP |

Ghi chú cho Phúc, không phải lỗi tài liệu: test thang số migration trên `dev` (`GoldenHourRulesPolicyGuardMigrationContractTest.java:76`) khai danh sách số bị
bỏ trống lệch với thực tế của `dev`, có thể đang đỏ sẵn (CHƯA CHẠY). Nhánh gộp đã sửa (:91).

Số migration: `dev` V360, nhánh gộp V391 (V361–V391 liền nhau), `dev015` V357, `PhucApu` V360. Không nhánh nào dùng từ V392 trở lên, không có dải số riêng
cho MISA (luật M9: lấy số kế tiếp trên `dev` lúc gộp, `HOP_DONG_M9.md:175`). **V392–V393 an toàn với điều kiện nhánh gộp vào `dev` trước.** Không chạy V392
trên DB nào khi DB đó chưa có V361–V391. Quét lại số lớn nhất trước khi gộp.

Chống trùng, duyệt hai bước, chế độ thử, khoá API:
- Đã có: khoá job duy nhất, `SKIP LOCKED`, `Idempotency-Key` cho lệnh quản trị, duyệt trước khi gửi mặc định bật, gateway mặc định `none`, worker mặc định tắt.
- Chưa có: duyệt job theo kiểu người lập khác người duyệt (hiện chỉ áp cho ánh xạ), biến môi trường cho khoá API.
- Tài liệu §11.7 đúng hướng: thêm biến mới, ứng dụng không khởi động khi thiếu bí mật. M12 đã có mẫu `MisaSyncOptionsValidator`.

## 3. API MISA (mục 7, 11.5, 15) — đối chiếu tài liệu công khai

Khớp (chắc chắn cao): cách bật kết nối và dữ liệu thử (không có máy chủ thử riêng, thử trên một dữ liệu kế toán riêng); lấy token; `/save`, `/delete`,
`/get_call_back_detail_error`; gửi bất đồng bộ, kết quả về callback; tối đa 500 dòng/chứng từ; chữ ký callback HMAC-SHA256 của chuỗi `data`, khoá ClientID,
hex chữ thường; 10 mã lỗi; mã loại chứng từ 1/3/5/6/7/8/9/12/13 và reftype 1500/1510/1010/4010/2020/2022/2023/2030–2032;
API AMIS Kế toán không phát hành hoá đơn (khớp QĐ-4: kế toán phát hành trong MISA).

Sai/thiếu — chú sửa tài liệu (T = mục sửa):

| # | Chỗ | Sai/thiếu | Sửa thành | Mức |
|---|---|---|---|---|
| T-1 | 15.2 chốt kỳ hoa hồng, 15.3 chứng từ phí | Gắn người nhận hoa hồng (Có 3388) và ĐVVC (Có 131) vào `account_object_code` — trường này là đối tượng **Nợ** | Đối tượng bên Có gửi ở `credit_account_object_code`; thêm vào bảng 7.4 và mô hình V2 (`creditObjectKey`) | CAO — sai sổ công nợ theo người/ĐVVC |
| T-2 | 15.2, 15.3, mẫu chi tiền gửi | Thiếu `purchase_purpose_id` (bắt buộc trên dòng chứng từ khác và dòng chi tiền gửi) | Thêm trường + khoá ánh xạ (kế toán chọn giá trị) | CAO — AMIS trả `InvalidParam` |
| T-3 | 15.3 thu tiền gửi | Thiếu `reason_type_id` (bắt buộc; 29 thu tiền khách hàng không theo hoá đơn … 34 thu khác) | Thêm trường, giá trị theo loại thu (khoá ánh xạ) | CAO |
| T-4 | 7.3 đọc danh mục | `take: 1000`, dừng khi trả về ít hơn `take` | `take = 100` (giới hạn ghi ở các API đọc khác), dừng khi trang rỗng | VỪA — đọc thiếu danh mục |
| T-5 | 7.4 dòng bán hàng | Nói gửi mã hàng thay GUID — chưa có nguồn; `inventory_item_id` đánh bắt buộc; `stock_name` bắt buộc nhưng bảng không liệt kê | Lấy `inventory_item_id` từ `get_dictionary` lưu ở `finance_misa_dictionary_items.misa_id`; thêm `stock_name`; ghi vào câu hỏi MISA | VỪA |
| T-6 | 7.5, 8.3, 11.5 bước 7 | Tên trường callback lệch ngay trong tài liệu MISA (`org_order_refid`/`org_refid`, `error_callback_message`/`session_id`); callback thành công chỉ là "AMIS đã nhận đề nghị", không trả số chứng từ AMIS | Bộ đọc nhận cả hai cách đặt tên; `SUCCESS` ghi rõ = "đã nhận đề nghị"; bước 7 "số chứng từ AMIS lưu được" đổi thành kế toán nhập tay (hoặc bỏ) vì không có API công khai | VỪA |
| T-7 | 11.5 chuẩn bị, 11.6 | "ClientID của dữ liệu thử" | ClientID cấp theo ứng dụng tích hợp; cái gắn với từng dữ liệu (thử/thật) là **mã kết nối** | THẤP |
| T-8 | 9.2 callback | Sai chữ ký trả `{"Success": false, "ErrorMessage": …}` | Mẫu MISA trả thêm `ErrorCode: "InvalidParam"` | THẤP |
| T-9 | 7.2 token | Hạn token 24 giờ hay 12 giờ (tài liệu MISA tự mâu thuẫn) | Dùng `expired_time` trả về, làm mới trước hạn | THẤP |

Chưa có nguồn công khai (đưa vào câu hỏi MISA, mục 6): nơi đăng ký URL callback, AMIS gọi lại mấy lần, dải IP; gửi lại cùng `org_refid` khi chưa lập chứng từ thì
cập nhật hay trùng (tài liệu khẳng định "cập nhật" — chưa có nguồn); giới hạn tần suất, số chứng từ/lần (tài liệu cũ 100); tên reftype 3530, 3540.

## 4. Định khoản 17 loại chứng từ (mục 5) — phiên m9 rà

Phần lớn khớp quy tắc đã chốt (mục 2) và bản nháp 03. Chỗ thiếu/mâu thuẫn:

| # | Chỗ | Vấn đề | Đề xuất | Mức |
|---|---|---|---|---|
| T-10 | 5.1 (#7 trả hàng, #4 voucher) | **Thiếu chứng từ chi hoàn tiền cho khách** (Nợ 131 / Có 1121) và **đảo #4 voucher** khi hoàn. Ví dụ đơn 1.000.000 đ, voucher 100.000 đ, khách trả 900.000 đ: #2 Nợ 131 1.000.000; #4 Có 131 100.000; #8 Có 131 900.000 → 131 = 0. Hoàn toàn bộ: #7 Có 131 1.000.000, chi trả khách 900.000 (chưa có chứng từ) → 131 âm 100.000 nếu không đảo #4 | Thêm loại "chi hoàn tiền khách" (`ORDER_REFUND_PAYMENT`, chi tiền gửi `3`/`1510`) hoặc ghi rõ kế toán tự lập trên AMIS; thêm dòng đảo #4 (Nợ 131 / Có 3388_VOUCHER) khi voucher được trả lại. Câu kế toán m9.7 | CAO — công nợ 131 lệch |
| T-11 | 5.1 #6, so bản nháp 03 #11 | **Mất loại "mua dịch vụ vận chuyển"** (phí công ty chịu, phí hai chiều đơn hoàn khi ĐVVC lập hoá đơn riêng, không cấn trừ ở #10: Nợ 6421_VANCHUYEN, Nợ 1331 / Có 331). #6 ghi "phí hai chiều theo #9 hoặc #10" — #9 là chuyển công nợ, không phải phí | Thêm lại loại này (mua dịch vụ `17`) hoặc ghi rõ mọi phí ĐVVC đều cấn trừ ở #10; sửa tham chiếu #6 | VỪA |
| T-12 | 5.2 #14 đơn nhà phân phối | "Như #2" nhưng #2 dựa vào #1 (xuất gửi bán 157 khi ĐVVC lấy hàng); đơn nhà phân phối không đi luồng vận đơn → không có bước xuất kho | Ghi rõ: bán hàng kiêm xuất kho trực tiếp (Nợ 632 / Có 155x, `is_sale_with_outward = true`), ngày chứng từ = ngày giao nhà phân phối | VỪA |
| T-13 | 10.1 lô 01:00 | Chỉ gom `documentDate = hôm qua` → nguồn về trễ (đối soát COD hãng báo sau vài ngày, vận đơn cập nhật giao thành công muộn, hoàn tiền xử lý sau) có ngày chứng từ cũ **bị bỏ sót mãi** | Lô quét lùi N ngày (đề xuất 35 ngày, chống trùng bằng khoá nguồn đã có); chứng từ có ngày thuộc kỳ AMIS đã khoá sổ → chờ kế toán quyết (câu m9.8) | CAO — mất chứng từ |
| T-14 | 5.1 #10(b) | Nợ 1331 cần tiền thuế trên hoá đơn GTGT của ĐVVC, nhưng số hãng báo (`order_shipment_carrier_figures`) chỉ có tổng phí | Như #13: kế toán gắn hoá đơn ĐVVC trước khi duyệt; chưa có hoá đơn thì ghi toàn bộ vào chi phí (mặc định KT-11) | THẤP |
| T-15 | 5.2 #16 gia công | M9 lập nhập kho thực phẩm chức năng (Nợ 1555B / Có 154); phía M1–M2 tự gửi "nhập thành phẩm" — cần ghi rõ M1–M2 **không** gửi nhập kho hàng gia công để không nhập hai lần | Ghi vào mục 6.4; phiên m12 xác nhận (báo qua lead) | VỪA |
| T-16 | 1.2, 5.2 #17 | "17 loại chứng từ" thực ra là 16 chứng từ gửi AMIS + lưu số hoá đơn (#17 không gửi) | Ghi rõ để đếm tiến độ không lệch | THẤP |
| T-17 | 9.2, 10.6 đối chiếu tháng | Dòng 632 "số đã gửi AMIS": M9 không gửi giá vốn (AMIS tính) → không có số để so | 632 chỉ so số lời lỗ tháng với số kế toán nhập từ AMIS, ghi lý do chênh "giá vốn quản trị khác giá vốn kế toán" | THẤP |
| T-24 | 6.2 danh mục, M9-QT-027 | Tài khoản 6421_QUANGCAO dùng ở #13 nhưng không có trong danh sách tài khoản kế toán phải mở trên AMIS | Thêm 6421_QUANGCAO vào §6.2 (đã đưa vào việc nhờ chị Giang) | THẤP |

## 5. Chỗ chạm module khác

**M1–M2 (phiên `m12`, báo qua phiên `lead`: `hop-thu/lead-2026-11-17-m9-misa-cham-m12.md`)**

Phần §6.4 tài liệu mô tả đúng: khung MISA riêng của ops-core, bộ gửi đang khoá (`FailClosedMisaProductionAdapter`), đường callback
`/api/v1/admin/integrations/misa/callback`. Tài liệu bỏ sót bảng `misa_sync_log`, `misa_reconcile_record` và chế độ DryRun/Production. Chỗ lệch cần chốt:
1. **Họ API khác nhau.** M12 đang cấu hình họ cũ "ACT Open API" (`/api/oauth/actopen/connect`, `/apir/sync/actopen/save`, `MisaSyncOptions.cs:34-37`).
   M9 theo họ mới `amiskt/v1` (tài liệu MISA V1.0.0, 05/08/2026). Dùng chung ClientID thì phải chung một họ API.
2. **Callback.** AMIS gọi về một địa chỉ cho mỗi ứng dụng. Chữ ký nằm trong thân tin (HMAC-SHA256 của `data`). M12 lại đòi header riêng
   `X-MISA-Callback-Signature/-Version/-Timestamp/-Request-Id` (`MisaTokenPorts.cs:49-52`). Phương án "M9 nhận rồi chuyển sang M12" cần một hợp đồng
   chuyển tiếp nội bộ có chữ ký. → câu m9.4, Toàn chốt A (D-m9-005).
3. **Thứ tự danh mục.** M9 làm chủ mã hàng thành phẩm (SKU). Phiếu nhập thành phẩm của M1–M2 (Nợ 1555A) dùng mã SKU đó, nên M9 phải đồng bộ danh mục
   trước, M1–M2 chỉ đọc. M1–M2 làm chủ mã kho, M9 chỉ đọc.
4. **Không ghi hai lần.** Xuất kho bán thành phẩm chỉ M9 gửi (#1, #6, #7). Nhập kho thực phẩm chức năng gia công chỉ M9 gửi (#16). Phiên m12 xác nhận M1–M2
   không gửi hai loại này (T-15).
5. **Một bí mật ở hai nơi.** ClientID và mã kết nối nằm ở cấu hình cả hai máy, cùng trên .99. Ai giữ và ai xoay khoá: chốt cùng câu m9.4.

**M3 (đơn hàng; Phúc rà phần `order`)**
- Cần thêm: cổng đọc `OrderAccountingSourcePort`, cờ hàng tặng, thông tin xuất hoá đơn công ty ở bước đặt hàng (việc G), phí gia công trên phiếu nhập
  hàng gia công (việc C7).
- Đơn **chưa có cột kênh bán** (chỉ có `program_type` 24/7 hoặc Giờ vàng), nên "Khách lẻ theo kênh" chưa có dữ liệu. → câu m9.5.
- Bảng đối soát COD, số hãng vận chuyển, QR tĩnh, `OrderInvoiceVat` chỉ có trên nhánh gộp (C-1).

**M6 (Tài, `module5/m6`)**
- `finance_ad_cost_entries` (V272) và dữ liệu M6 gửi sang (`M6AdSpendJsonParser.java:19`) **không có trường nền tảng/nhà cung cấp**. Vì vậy "Có 331 theo
  Meta, Google" (M9-QT-042) chưa có dữ liệu. → câu m9.6.
- `ginsengfood-contracts` chưa có hợp đồng M6 → M9 (thuộc phiên `lead`; đã ghi trong hộp thư lead).

**M8:** không liên quan.

## 6. Câu cần chốt

### 6.1 Toàn chốt

**Đã chốt 17/11 12:33: "ok m9.1–m9.4 A"** (D-m9-002…005 trong `QUYET_DINH.md`). **12:43 đổi m9.3 (D-m9-006):** Tài làm đầu mối với chú, chị Giang,
hỗ trợ MISA (xin tài khoản AMIS, đăng ký ClientID, dữ liệu thử, gửi câu hỏi, gửi chú mục 7), Tài tự thử trên dữ liệu thử; Toàn không nhắn chú/chị Giang.

| Mã | Câu hỏi | Đề xuất | Trễ thì sao |
|---|---|---|---|
| m9.1 | Mã nền cho Tài: **A** Phúc gộp nhánh gộp của chú vào `dev` trước 19/11, Tài kéo `dev` về `dev015` rồi làm tiếp · **B** Tài làm thẳng trên nhánh gộp của chú | **A**. Thử gộp sạch, không xung đột chữ. Gộp vào `dev` chưa phải deploy, thứ tự lên .99 giữ nguyên. Chọn B thì nhánh chú còn đổi, PR của Tài kéo theo 78 commit không phải của Tài | Sau 19/11, Tài chỉ làm được bộ gửi, chưa làm được migration và bộ lập |
| m9.2 | "Chạy thật 30/11" với MISA nghĩa là gì: **A** 30/11 có đủ code 16 loại chứng từ + lưu số hoá đơn, đủ test, đã chạy trên dữ liệu thử AMIS nếu có ClientID; bật gửi thật khi kế toán trưởng ký nghiệm thu (có thể sau 30/11), trong lúc chờ để `FINANCE_MISA_GATEWAY=none`, nguồn vẫn ghi đủ để gửi bù · **B** bắt buộc gửi thật từ 30/11, phải xin chú rút phạm vi (ngược QĐ-5 B) | **A**. Code tự ước 12–15 ngày làm việc, còn 11 ngày, chưa tính thời gian chờ MISA và kế toán. Lô gửi quét lùi (T-13) sẽ gửi bù chứng từ từ 30/11, kể cả chốt kỳ hoa hồng tháng 11 lúc 01:00 ngày 01/12 | Không chốt thì Tài không biết cắt gì khi trễ |
| m9.3 | Luồng 0 (đường găng: đăng ký ClientID trên developer.misa.vn, lấy mã kết nối dữ liệu thử, kế toán trả lời câu hỏi): **A** hôm nay Toàn nhắn chú + chị Giang, kèm danh sách câu hỏi kế toán (m9.5–m9.9) và câu hỏi MISA (§6.3); phiên soạn tin nháp · **B** để Tài tự liên hệ kế toán | **A**, Tài hỗ trợ kỹ thuật khi đăng ký. Thời gian MISA duyệt ClientID chưa biết bao lâu | Mỗi ngày trễ là một ngày lùi buổi thử trên dữ liệu thử |
| m9.4 | Nối MISA với M1–M2 (Toàn là chủ M12): **A** M12 chuyển sang họ API `amiskt/v1`; M9 nhận callback chung, chuyển phần `M12:` sang M12 qua mạng nội bộ .99 bằng chữ ký nội bộ; chốt hợp đồng chuyển tiếp trước việc E của Tài (~24/11) · **B** xin MISA cho hai ứng dụng, mỗi bên một ClientID và callback riêng (phải xin chú đổi phần "chung ClientID" của QĐ-3) | Hỏi MISA trong luồng 0 xem một ứng dụng có đăng ký được nhiều địa chỉ callback không. Chưa có trả lời thì theo **A**. Phía M12 do phiên m12 làm, M12-012 đang hoãn theo D-m12-002 | Việc E (callback) của Tài phải làm lại nếu đổi phương án sau 24/11 |

### 6.2 Kế toán chốt (qua chú / chị Giang; Tài làm theo mặc định trước, để cấu hình đổi được)

| Mã | Câu hỏi | Mặc định đề xuất |
|---|---|---|
| m9.5 | Đơn chưa có cột kênh bán. "Khách lẻ theo kênh" lấy kênh từ đâu (KT-8)? | Tạm hai đối tượng theo `program_type` có sẵn ("Khách lẻ – 24/7", "Khách lẻ – Giờ vàng"). Khi M3 có cột kênh thì tách thêm |
| m9.6 | Nhà cung cấp quảng cáo (Meta, Google) cho Có 331: M6 chưa gửi trường này | Tài thêm trường nền tảng vào API chi phí quảng cáo của M6 và cột ở BP; dòng cũ không có trường thì gán `META` |
| m9.7 | Hoàn tiền khách (T-10): có tự lập chứng từ chi hoàn tiền (Nợ 131 / Có 1121) và dòng đảo voucher (Nợ 131 / Có 3388_VOUCHER) không? | Có, tự lập. Chi hoàn tiền dùng loại chi tiền gửi `3`/`1510`, ngày = ngày chuyển tiền hoàn |
| m9.8 | Chứng từ về trễ (T-13): nguồn có ngày chứng từ cũ (đối soát COD, hoàn tiền, giao thành công cập nhật muộn). Nếu ngày rơi vào kỳ AMIS đã khoá sổ thì sao? | Lô 01:00 quét lùi 35 ngày, không sinh trùng. Ngày thuộc kỳ đã khoá thì giữ ở trạng thái chờ kế toán quyết, không tự đổi ngày |
| m9.9 | (a) Phí ĐVVC không cấn trừ, ĐVVC lập hoá đơn riêng (T-11): thêm lại loại "mua dịch vụ vận chuyển"? (b) Đơn nhà phân phối (T-12) xuất kho thế nào? | (a) Thêm (mua dịch vụ `17`, Nợ 6421_VANCHUYEN, Nợ 1331 / Có 331 ĐVVC), làm sau cùng; tới lúc đó kế toán tự lập trên AMIS. (b) Bán hàng kiêm xuất kho thẳng (Nợ 632 / Có 155x), không qua 157 |

KT-1 đến KT-11 của tài liệu (§14.2) giữ nguyên, Tài làm theo mặc định trong tài liệu.

### 6.3 Câu hỏi MISA (kế toán làm đầu mối, hỏi trong luồng 0)

1. Đăng ký URL callback ở đâu; một ứng dụng đăng ký được mấy địa chỉ; AMIS gọi lại mấy lần khi lỗi; gọi từ dải IP nào.
2. Xin một callback mẫu thật, để chốt tên trường (`org_refid` hay `org_order_refid`, `session_id`).
3. Callback thành công là "đã nhận đề nghị" hay "đã lập chứng từ"; có cách nào lấy số chứng từ AMIS không.
4. Gửi lại cùng `org_refid` khi kế toán chưa lập chứng từ thì AMIS cập nhật đề nghị hay tạo trùng.
5. Giới hạn số chứng từ mỗi lần gửi, số danh mục mỗi lần, `take` tối đa, tần suất gọi.
6. Token hết hạn sau 24 giờ hay 12 giờ.
7. `inventory_item_id` (GUID) có bắt buộc không, hay gửi mã hàng là đủ.
8. Danh sách `purchase_purpose_id` cho dòng không có hàng (chứng từ khác, chi tiền gửi).
9. ClientID có dùng chung cho dữ liệu thử và dữ liệu thật không. M1–M2 và M9 dùng chung một ClientID được không.
10. AMIS có tự tính giá xuất kho cho dòng xuất không gửi giá không. Chuyển kho sang kho "Hàng gửi bán" (157) có tự tính giá không.

## 7. Gom lại cho chú sửa tài liệu (bản 3)

- **CAO** (sửa trước khi Tài viết migration và bộ lập): T-1 đối tượng bên Có · T-2 `purchase_purpose_id` · T-3 `reason_type_id` · T-10 chi hoàn tiền khách + đảo voucher · T-13 lô quét lùi cho chứng từ về trễ · T-18 ràng buộc V321/V328 trong V392.
- **VỪA:** T-4 `take` 100 · T-5 `inventory_item_id`, `stock_name` · T-6 callback hai cách đặt tên, ý nghĩa `SUCCESS` · T-11 mua dịch vụ vận chuyển · T-12 xuất kho đơn nhà phân phối · T-15 gia công không nhập hai lần · T-19 `SENT` hai nghĩa · T-20 gửi trong giao dịch khoá dòng · T-22 id chứng từ gộp.
- **THẤP:** T-7, T-8, T-9, T-14, T-16, T-17, T-21, T-23, T-24.
- Mục §1.2/§10.1 ghi thêm cách hiểu "chạy thật 30/11" (D-m9-003): 30/11 đủ code + test + đã thử trên dữ liệu thử; gửi thật khi kế toán trưởng ký, lô quét lùi gửi bù.
- Mục §6.4 ghi thêm (D-m9-005): M1–M2 chuyển sang họ `amiskt/v1`; M9 nhận callback chung, chuyển phần `M12:` sang ops-core có ký nội bộ.

Tài không chờ bản 3: chỗ nào bản rà này nói khác tài liệu thì làm theo bản rà, kèm mặc định ở §6.2.
