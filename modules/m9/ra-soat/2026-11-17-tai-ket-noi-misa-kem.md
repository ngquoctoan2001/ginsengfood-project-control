Gửi Tài · 17/11/2026 · từ Toàn (Lead)

Việc: làm kết nối M9 → MISA AMIS Kế toán (gửi chứng từ tự động, một chiều) theo tài liệu chú Dũng. Em làm luôn đầu mối với chú Dũng, chị Giang và bên hỗ
trợ MISA (gói MISA-00). Phần code chia 8 gói nhỏ, mỗi gói một PR vào `dev`.

Vì sao: chủ hệ thống chốt 17/11 làm đủ 17 loại chứng từ một đợt (M9-QT-044), kế toán duyệt hai bước (M9-QT-041), mỗi bên M1–M2 và M9 tự gửi (QT-CHUNG-026).
Hạn chạy thật toàn hệ thống 30/11/2026.

## 1. Đọc trước

- Tài liệu chú (bản 2): `docs/m9/misa/2026-11-17-brief-ket-noi-misa-amis.md`, nhánh `origin/chudung/m9-17112026-brief-ket-noi-misa-cho-tai` `a3458abd5`
  (chỉ có tài liệu). Chưa vào `dev` thì đọc bằng `git show origin/chudung/m9-17112026-brief-ket-noi-misa-cho-tai:docs/m9/misa/2026-11-17-brief-ket-noi-misa-amis.md`.
- Tài liệu MISA: `https://developer.misa.vn/products-openapi/AMISKT` (bản V1.0.0, 05/08/2026, họ API `amiskt/v1`). Không dùng họ cũ "ACT Open API" (`actopen`).
- Bản rà của anh (gửi kèm): các chỗ tài liệu sai/thiếu, đánh số T-1 … T-24. **Chỗ nào bản rà nói khác tài liệu thì làm theo bản rà.** Chú sửa tài liệu sau,
  em không cần chờ. Mấy chỗ em sửa luôn khi code: T-1 (đối tượng bên Có gửi ở `credit_account_object_code`), T-2 (`purchase_purpose_id`), T-3
  (`reason_type_id`), T-4 (đọc danh mục `take` 100, dừng khi trang rỗng), T-5 (`inventory_item_id` lấy từ danh mục), T-6 (callback nhận cả hai cách đặt tên
  trường), T-18 (ràng buộc V321/V328), T-19, T-20.

## 2. Phạm vi

Làm: đầu mối với chú Dũng, chị Giang, hỗ trợ MISA (đăng ký, dữ liệu thử, câu hỏi; MISA-00); bộ gửi `api` của `FinanceMisaGateway`; mô hình `M9_MISA_VOUCHER_V2`; migration; callback; đồng bộ danh mục; bộ lập 16 loại chứng từ (#1–#16) + lưu số
hoá đơn (#17); thêm chi hoàn tiền khách và đảo voucher khi hoàn (bản rà T-10); màn `/admin/finance/misa`; đối chiếu ngày/tháng; thông tin xuất hoá đơn công
ty ở bước đặt hàng (việc G); trường nền tảng quảng cáo (Meta/Google) bên M6 cho chứng từ quảng cáo.

Không làm: phần M1–M2 gửi MISA (repo ops-core, anh lo); phát hành hoá đơn điện tử tự động qua meInvoice (làm sau); gửi lên dữ liệu kế toán thật.

## 3. Nhánh, PR, Sheet, an toàn

- Làm trên `dev015` (hoặc nhánh riêng em báo anh). Mỗi gói một PR vào `dev`, như PR #162/#165. Kéo `dev` về trước mỗi gói.
- **Mã nền:** phần lớn mã M9 tài liệu dựa vào (11 bảng nguồn, `OrderInvoiceVat`, module `loyalty`/`distributor`, nút START, 10 khoá ánh xạ) đang nằm trên
  nhánh gộp của chú (`chudung/m3-14112026-gop-cac-nhanh-sua-ngay-14-11`), **chưa vào `dev`**. Anh đã chốt: Phúc gộp nhánh đó vào `dev` **trước 19/11**,
  em kéo `dev` về `dev015` rồi làm từ MISA-02. Trong lúc chờ, em làm gói MISA-01 (chỉ cần mã đã có trên `dev`). Không tự kéo nhánh gộp vào `dev015`.
- **Nối với M1–M2 (anh đã chốt):** hai bên dùng chung một ClientID; M1–M2 cũng chuyển sang họ API `amiskt/v1`. **M9 nhận callback chung** của AMIS, phần
  nào có `org_refid` tiền tố `M12:` thì chuyển sang ops-core qua mạng nội bộ, kèm chữ ký nội bộ. Hợp đồng chuyển tiếp anh chốt với phía M1–M2 trước 24/11.
- **Migration:** lấy số kế tiếp sau số lớn nhất trên `dev` lúc tạo tệp. Nhánh gộp dùng liền V361–V391, nên sau khi gộp thì số của em là V392 trở đi.
  Trước khi mở PR quét lại số lớn nhất trên `dev`; `GoldenHourRulesPolicyGuardMigrationContractTest` phải xanh. Chỉ thêm tệp mới, không sửa migration cũ.
- **Khoá:** không ghi ClientID, mã kết nối, token vào code, `.env` mẫu, log, ảnh, PR. Biến môi trường theo §11.7 của tài liệu. Đặt
  `FINANCE_MISA_GATEWAY=api` mà thiếu bí mật thì ứng dụng không khởi động. Mặc định vẫn `none`.
- **Gọi MISA:** test tự động dùng AMIS giả (WireMock). Thử trên **dữ liệu thử** của AMIS em tự làm, không cần báo anh trước. Gửi lên **dữ liệu kế toán thật**
  chỉ khi anh và chị Giang đồng ý.
- **Tài khoản và mã MISA:** tài khoản AMIS chị Giang cấp, ClientID, mã kết nối là bí mật: không gửi trong nhóm chat, không ghi vào repo hay Sheet. Mã của dữ
  liệu thử em giữ ở máy làm việc (biến môi trường hoặc tệp cấu hình riêng nằm ngoài git). Mã dùng cho máy chủ thì báo anh để nhập vào máy chủ.
- **Sheet:** mỗi gói một task ở **tab M9** (`MISA-00` … `MISA-08`), người phụ trách Nguyễn Phát Tài. Xong gói nào thì cập nhật trạng thái + SHA/PR gói đó.
  Ghi nhật ký tuần như thường lệ.

## 4. Thứ tự làm (gói nhỏ)

| Gói | Việc | Cần trước | Hạn đề xuất |
|---|---|---|---|
| MISA-00 | **Đầu mối với chú, chị Giang, MISA (làm ngay, chạy song song với code).** (1) Xin chị Giang tài khoản AMIS để làm việc với dữ liệu thử. (2) Đăng ký ứng dụng trên `developer.misa.vn` để lấy ClientID; bật kết nối API trong AMIS; tạo dữ liệu thử, lấy mã kết nối; mở các tài khoản §6.2 của tài liệu, thêm 6421_QUANGCAO (T-24); tạo xong phải được chị Giang đồng ý. (3) Gửi chị Giang tệp câu hỏi kế toán (gửi kèm, 16 câu, câu nào chưa chắc thì để mặc định). (4) Liên hệ hỗ trợ MISA hỏi 10 câu ở mục 3 tệp đó. (5) Gửi chú danh sách sửa tài liệu (bản rà mục 7: 6 mục CAO trước) để chú ra bản 3. Có câu trả lời thì cập nhật mặc định, báo anh chỗ nào đổi phạm vi hoặc hạn | Không | Gửi câu hỏi + đăng ký: **18/11**; ClientID tuỳ MISA duyệt, báo anh ngày dự kiến |
| MISA-01 | **Bộ gửi `api` + AMIS giả.** `FinanceMisaAmisApiGateway`: token (giữ trong bộ nhớ, làm mới trước hạn theo `expired_time`, gặp lỗi token thì lấy lại đúng một lần, hai luồng cùng lúc chỉ gọi token một lần); `/save`; `/delete` (DELETE có body); `/get_call_back_detail_error`; `/get_dictionary` phân trang `take` 100. Phân loại 10 mã lỗi (không phân biệt hoa thường, mã lạ tính là thử lại được); ngắt mạch khi gặp `InvalidAppID`/`AppIDDisconnect`/`DBAmisNotConnectDBACT`; giới hạn tần suất; kiểm cấu hình lúc khởi động; che khoá trong log | Không (làm trên `dev` hiện tại) | 20/11 |
| MISA-02 | **Mô hình V2 + migration + trạng thái.** Record V2 (thêm đối tượng bên Có, khoá `purchase_purpose`, `reason_type`); V392 theo §8.2 **cộng** sửa 7 ràng buộc ở T-18; `Outcome.ACCEPTED`; `SENT` ở chế độ `api` = chờ callback, chặn `confirm` (T-19); gọi `/save` ngoài giao dịch khoá dòng (T-20); quy ước id cho chứng từ gộp (T-22); duyệt hàng loạt; lập điều chỉnh; quyền §8.4 | Nhánh gộp vào `dev` | 22/11 |
| MISA-03 | **Callback + kéo dự phòng + danh mục.** Đường công khai `/api/v1/integrations/misa/callback`: kiểm chữ ký HMAC-SHA256 (dùng mẫu C# của MISA làm ca chuẩn); lưu nguyên bản rồi mới xử lý; xử lý trùng một lần; `data_type` lạ thì trả thành công và ghi log; sai chữ ký trả thêm `ErrorCode: "InvalidParam"`. Kéo kết quả dự phòng mỗi 15 phút. Bảng `finance_misa_dictionary_items`, đồng bộ danh mục M9 làm chủ (SKU, đối tượng), kiểm mã trước khi gửi. **Phần chuyển kết quả sang M1–M2: chừa chỗ, làm sau khi anh chốt hợp đồng chuyển tiếp với phía M1–M2** | MISA-01, MISA-02 | 24/11 |
| MISA-04 | **Bộ lập nhóm bán hàng và tiền:** #1, #2, #3, #6, #8, #9, #10; cổng `OrderAccountingSourcePort` (Phúc rà phần `order`); cờ hàng tặng; lô 01:00 **quét lùi 35 ngày**, chạy lại không sinh trùng; `POST misa-vouchers/build` | MISA-02 | 25/11 |
| MISA-05 | **Hoa hồng, voucher, trả hàng:** #4, #5, #7, chi hoàn tiền khách + đảo voucher khi hoàn (T-10), #11 chốt kỳ, #12 chi lô chuyển sang V2 (chỉ ghi phần chênh, như mã trên nhánh gộp) | MISA-02 | 26/11 |
| MISA-06 | **Quảng cáo, nhà phân phối, gia công, hoá đơn:** #13 (thêm trường nền tảng vào API chi phí quảng cáo M6 + cột ở BP), #14 bán kiêm xuất kho thẳng, #15, #16, #17 nhập/tải số hoá đơn; việc G: thông tin xuất hoá đơn công ty ở bước đặt hàng | MISA-02 | 27/11 |
| MISA-07 | **Màn hình + đối chiếu:** mở rộng `/admin/finance/misa` (tab Chứng từ, Ánh xạ, Danh mục, Kết nối, Đối chiếu; duyệt hàng loạt; điều chỉnh). Phần giao diện làm song song từ 19/11 với API giả theo hợp đồng §9. Đối chiếu ngày + tháng làm sau MISA-04…06 | Hợp đồng §9 | 28/11 |
| MISA-08 | **Thử trên dữ liệu thử AMIS** (em tự chạy) đủ 22 bước §11.5, sửa lỗi; mời chị Giang xem và ký nghiệm thu | ClientID + mã kết nối dữ liệu thử (MISA-00); MISA-01…06 | Có ClientID là thử từng gói luôn; đủ 22 bước mục tiêu 28–30/11 |

Gói 04, 05, 06, 07 chia theo tệp (mỗi bộ lập một tệp, một thư mục JSON vàng riêng), nên chạy song song bằng trợ lý AI được, miễn mỗi PR tự chạy test của gói đó.

## 5. Xong khi (kiểm được)

Mỗi PR:
- Test của gói xanh, kèm lệnh chạy và kết quả dán vào PR. Bộ test sẵn có vẫn xanh: `FinanceMisaSyncServiceTest`, `FinanceMisaSchemaDbTest`,
  `FinanceMisaSyncConcurrencyDbTest`, `FinanceP0MisaSyncAcceptanceTest`, `ModuleBoundaryArchitectureTest` 15/15, test thang số migration.
- `git grep` tên các biến bí mật ở §11.7 không ra giá trị nào; log test không có token, ClientID, mã kết nối, họ tên, số điện thoại khách lẻ.
- Cập nhật `contracts/openapi/latest.json` và `contracts/api-snapshots/finance-m9-admin.json` nếu có đổi API.

Theo gói:
- MISA-00: chị Giang đã nhận câu hỏi; MISA đã nhận đăng ký ứng dụng (có mã hồ sơ hoặc email xác nhận); đã gửi hỗ trợ MISA 10 câu; chú đã nhận danh sách
  sửa. Có ClientID + mã kết nối dữ liệu thử thì gọi lấy token thành công một lần từ máy em. Câu trả lời ghi vào sổ của em, kèm mặc định nào đã đổi.
- MISA-01: AMIS giả chạy đủ ca 1–5 §11.2 (gửi → nhận; token hết hạn → lấy lại → gửi lại; 503 ba lần rồi được; `InvalidParam` không thử lại; `AppIDDisconnect`
  ngắt mạch). Đọc danh mục 250 bản ghi qua 3 trang. Thiếu bí mật thì không khởi động.
- MISA-02: test PostgreSQL cho từng ràng buộc mới (nhận giá trị đúng, từ chối giá trị lạ), có cả 7 điểm T-18; hai worker chạy cùng lúc thì mỗi job gửi
  đúng một lần; quyền đúng vai §8.4, không có ở vai kinh doanh và `ADMIN`.
- MISA-03: AMIS giả chạy ca 6–8 §11.2; đúng chữ ký thì nhận, sai một ký tự thì từ chối; callback về hai lần chỉ xử lý một lần.
- MISA-04 … 06: mỗi bộ lập có JSON vàng cho các ca §11.1, cộng các ca: hoàn tiền có voucher, đơn nhà phân phối, chứng từ về trễ 3 ngày. Tổng Nợ = tổng Có.
  Tiền khớp `OrderInvoiceVat` trên 1.000 đơn ngẫu nhiên. Chạy lô hai lần cùng ngày không sinh trùng.
- MISA-07: vitest §11.4; ảnh màn hình; kèm "Shared UI check", "Vietnamese UI check" trong PR.
- MISA-08: 22 bước §11.5 có ảnh và mã chứng từ thử, chị Giang ký nghiệm thu.

Tổng: đủ danh sách §13 của tài liệu.

## 6. Còn chờ chốt — làm phần chắc trước

| Chờ gì | Ai chốt | Trong lúc chờ em làm |
|---|---|---|
| Nhánh gộp của chú vào `dev` (đã chốt, hạn 19/11) | Phúc (anh nhắn) | MISA-01, giao diện MISA-07 với API giả |
| Tài khoản AMIS, ClientID, mã kết nối dữ liệu thử | Em làm (MISA-00): xin chị Giang tài khoản, đăng ký trên developer.misa.vn, liên hệ hỗ trợ MISA | Toàn bộ bằng AMIS giả; có mã thì tự thử trên dữ liệu thử |
| Hợp đồng chuyển callback sang M1–M2 (đã chốt hướng: M9 nhận, chuyển tiếp có ký nội bộ) | Anh chốt chi tiết với phía M1–M2 trước 24/11 | Làm callback phía M9 trước; chừa chỗ chuyển tiếp theo tiền tố `M12:`, lưu bảng `org_refid` → hệ thống |
| Tên trường callback thật, `inventory_item_id` có bắt buộc không, danh sách `purchase_purpose_id`, gửi lại cùng `org_refid` thì sao | Em hỏi hỗ trợ MISA (10 câu, tệp câu hỏi mục 3); thử trên dữ liệu thử cũng ra câu trả lời | Đọc cả hai cách đặt tên; để `purchase_purpose_id`, `reason_type_id` thành khoá ánh xạ; JSON vàng chốt sau khi có dữ liệu thử |
| Câu kế toán: KT-1 … KT-11 trong tài liệu; kênh "Khách lẻ"; nhà cung cấp quảng cáo; hoàn tiền + đảo voucher; chứng từ về trễ, kỳ đã khoá; phí ĐVVC không cấn trừ; xuất kho đơn nhà phân phối | Chị Giang trả lời (em gửi tệp câu hỏi, 16 câu) | Làm theo mặc định, để cấu hình đổi được. Kênh: tạm hai đối tượng theo `program_type` (24/7, Giờ vàng). Quảng cáo không có trường nền tảng thì gán `META`. Kỳ đã khoá: giữ chờ kế toán, không tự đổi ngày. Phí ĐVVC không cấn trừ: làm sau cùng |
| "Chạy thật 30/11" với MISA (đã chốt): 30/11 có đủ code + test + đã chạy trên dữ liệu thử nếu có ClientID; bật gửi thật khi kế toán trưởng ký, có thể sau 30/11 | — | Theo hạn ở mục 4 |

## 7. Hạn

- MISA-00: gửi câu hỏi cho chị Giang, chú, hỗ trợ MISA và đăng ký ứng dụng trong **18/11**. Việc này chờ MISA duyệt nên làm trước.
- Code MISA-01 … 07 xong **28/11**. MISA-08 chạy ngay khi có ClientID.
- Tài liệu chú tự ước phần code khoảng 12–15 ngày làm việc; từ nay tới 28/11 còn khoảng 10 ngày. Em coi lại, **trong ngày 18/11 báo anh ngày thật của từng
  gói** (trên Sheet hoặc nhắn anh). Gói nào không kịp thì báo sớm, anh chốt cắt hay dời.
- 30/11 (anh đã chốt): code đủ + test + đã chạy trên dữ liệu thử AMIS nếu có ClientID. Gửi thật bật khi kế toán trưởng ký nghiệm thu, có thể sau 30/11;
  tới lúc đó để `FINANCE_MISA_GATEWAY=none`, nguồn vẫn ghi đủ, bật lên thì lô quét lùi gửi bù (kể cả chốt kỳ hoa hồng tháng 11 lúc 01:00 ngày 01/12).
