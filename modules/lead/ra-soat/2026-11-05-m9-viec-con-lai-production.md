# M9 — việc còn lại tới production (05/11/2026)

Căn cứ:
- Rà `dev 51ff1935b` (báo cáo `2026-11-05-ra-soat-m9-pr148.md`).
- Đặc tả `GUI_TOAN_0511/02_DAC_TA_M9_V0.2.md` §1, §8–§17 và phạm vi đợt này `00_DOC_TRUOC.md`.
- `module6` master `4c75f88`.

Mốc chung: chạy thật 14/11, bàn giao 15/11.

## 0. Trả lời nhanh: số hiện nay lấy từ đâu, đã thật chưa?

| Nguồn | M9 lấy bằng cách nào | Đã đủ "không mock" chưa |
|---|---|---|
| **M3 bán hàng** (đơn đã xác nhận, hoàn/trả, hoa hồng CTV, CTV) | M9 nằm **cùng ứng dụng** BP, đọc thẳng bảng M3 qua 3 lớp truy vấn chỉ đọc do M3 sở hữu: `order/.../FinanceVerifiedOrderQueryServiceImpl`, `commission/.../FinanceCommissionQueryServiceImpl`, `collaborator/.../FinanceCollaboratorQueryServiceImpl`. Không qua HTTP, và cùng một service nên như vậy là đúng. | **Mã đọc là thật**, phép tính đúng (đã đối chiếu tay). **Dữ liệu đã thử là bộ số demo** `E2E_M9_DEMO26_` chèn thẳng vào bảng M3. Bộ này không đi qua luồng thật đặt đơn → xác nhận → tính hoa hồng → hoàn. **Chưa có lượt đầu-cuối nào với đơn thật.** Riêng "rút xác nhận" (`verification_revoked_at`) thì M3 **không có chỗ nào ghi**, nên phần này M9 luôn đọc ra rỗng. |
| **M6 chi phí quảng cáo** | `M6AdSpendClient` gọi `GET {M6_BASE_URL}/api/v1/ads-spend/approved`, khoá `M9_M6_SERVICE_TOKEN`. M6 **đã có** endpoint này (M6-134, `app/http/m9.py`); khuôn JSON hai bên khớp trên giấy. | **Chưa.** Mặc định `FINANCE_AD_COST_SOURCE=stub` là số giả, và hôm nay đã ghi 50 dòng giả vào sổ local. Chưa cấu hình URL/khoá, **chưa gọi thử M6 thật lần nào**. Số M6 là CSV nhập tay đã duyệt, không lấy tự động từ Meta. |
| **MISA** | Không có. | Chưa làm; **làm trong hạn 08/11**. |
| **Ngân hàng / UNC** | Không có. "Đã chi" chỉ dựa vào mã chứng từ gõ tay. | Chưa làm; **làm trong hạn 08/11**. |
| **KPI năm / voucher thưởng** | Không có. BP không có bảng `kpi_year_*`; voucher giới thiệu (V226/V227/V234) là của M3. | Chưa làm; đặc tả để đợt sau. |

Kết luận: **M9 chưa đủ để gọi là chạy bằng số thật.** Phần M3 có đường đọc thật nhưng chưa chạy đầu-cuối. M6 mới có ở hai đầu, chưa nối. MISA, ngân hàng và KPI chưa bắt đầu.

## 1. Việc phải xong cho chạy thật 14/11 (phạm vi đợt này)

### A. Sửa lỗi từ lượt rà 05/11: anh Mạnh, PR mới, R3

| # | Việc | Xong khi |
|---|---|---|
| A1 | P0 chi trùng: dòng đã có chứng từ thì không trả khoản về hàng chờ; phần hoàn ghi `CLAWBACK` (`FinanceCommissionAdjustmentService.java:87-98`) | Test ca "ghi chứng từ → hoàn → kéo số → lập bảng kê mới" không ra khoản chi lại |
| A2 | "Thực chi" của bảng kê trừ dòng đang giữ | Tổng bảng kê bằng tổng các dòng còn chi |
| A3 | "Kiểm tra khớp" so thật: sổ M9 với M3, sổ khoản với dòng bảng kê | Cài lệch có chủ đích thì màn báo lệch |
| A4 | Lúc duyệt xét lại hoàn/trả ngay tại thời điểm duyệt, không phụ thuộc job kéo số | Test duyệt khi job tắt |
| A5 | CI xanh khi chạy cả bộ (2 test phụ thuộc thứ tự) | Pipeline xanh 2 lần liền |
| A6 | Các lỗi P2/P3 có ảnh hưởng tiền: DRAFT huỷ được; xét lại CTV còn hoạt động lúc lập; M6 trả mảng rỗng thì không xoá chi phí; hoa hồng tăng thì ghi điều chỉnh tăng; tách quyền ghi chứng từ với quyền đánh dấu đã chi | Mỗi mục có test |

### B. Nối số thật, bỏ mock

| # | Việc | Ai | Xong khi |
|---|---|---|---|
| B1 | **M3 → M9 đầu-cuối bằng đơn thật** trên môi trường thử: đặt đơn có mã giới thiệu → xác nhận (admin hoặc IVR M8) → M3 tính hoa hồng (`OrderVerificationCheckpointServiceImpl` → `AffiliateCommissionRuntimeServiceImpl`) → hoàn một phần, hoàn hết, trả hàng → M9 kéo số → lập bảng kê | Mạnh + Phúc (M3) | Biên bản số từng bước, không dùng `FinanceTestDataDemoLoaderTest` |
| B2 | **M3 ghi "rút xác nhận"**: luồng huỷ xác nhận đơn phải ghi `verification_status='REVOKED'` và `verification_revoked_at` (hiện không có chỗ ghi) | Mạnh + Phúc (M3) | M9 kéo được REVOKED từ thao tác thật |
| B3 | **Xác nhận đơn từ M8 IVR**: kết quả gọi xác nhận phải thành `VERIFIED` ở M3; đây là nguồn chính để M9 tính doanh thu và hoa hồng | Lead (M3→M8, `toandeptrai`) | Một đơn đi IVR → M9 thấy doanh thu |
| B4 | **M6 → M9 thật**: đặt `FINANCE_AD_COST_SOURCE=m6`, `M6_BASE_URL` (mạng nội bộ .60), khoá dịch vụ hai bên trùng nhau (`M9_M6_SERVICE_TOKEN` ↔ `M6_M9_SERVICE_TOKEN`); M6 có CSV chi phí đã duyệt; gọi thử, so số dashboard M9 với M6 | Mạnh + Tài | Dashboard M9 ra đúng số M6 của một tuần thật |
| B5 | **Bỏ mock khỏi mặc định**: `FINANCE_AD_COST_SOURCE` mặc định tắt (`stub` chỉ dùng cho test); `SEED_ADMIN_FULL_PERMISSIONS=false` ngoài local; dọn dữ liệu demo và dòng giả trên `.63`; production không bao giờ chạy bộ nạp demo | Mạnh | grep cấu hình production không còn `stub`; CSDL production không có `E2E_M9_` |
| B6 | **Job kéo số chạy thật**: bật `FINANCE_SYNC_SCHEDULER_ENABLED` trên production, đặt `FINANCE_SYNC_INITIAL_FROM` đúng ngày bắt đầu, cảnh báo khi một lượt lỗi, có cách kéo bù | Mạnh + Anh Tuấn (kênh cảnh báo) | 24 giờ chạy không lỗi, có cảnh báo thử |
| B7 | **MISA** (D1 kéo lên): bảng ánh xạ, hàng đợi gửi + worker, idempotency, thử lại, nhật ký, kế toán duyệt trước khi gửi, đối soát, màn theo dõi; smoke M9-P0-009/010/011 | Mạnh + kế toán | Bảng kê đã chi lên MISA thử, kế toán thấy đúng bút toán |
| B8 | **Ngân hàng / UNC** (D2 kéo lên): xuất UNC, TRANSFERRED → RECONCILED, nhập sao kê khớp `bank_ref`, chuyển lỗi/sai người; smoke P0-007/008 | Mạnh + kế toán | Một bảng kê đi hết duyệt → UNC → sao kê → khớp |

### C. Lên production

| # | Việc | Ai | Xong khi |
|---|---|---|---|
| C1 | Hợp đồng: OpenAPI các endpoint `/api/v1/admin/finance/*` và hợp đồng M6→M9 vào `ginsengfood-contracts` | Mạnh soạn, Lead gộp | Có snapshot, CI so khớp |
| C2 | Gói triển khai: M9 đi cùng BP lên .60; thêm biến `FINANCE_*`, `M6_BASE_URL`, `M9_M6_SERVICE_TOKEN` vào gói deploy; migration V270–V299 chạy qua CD, không chạy tay | Lead (deploy) + Mạnh | Lên môi trường thử bằng CD rồi mới lên production |
| C3 | Vai trò `FINANCE.*`: ai lập (kế toán Lan?), ai duyệt (khác người lập), ai ghi chứng từ, ai đánh dấu đã chi | **Chú Dũng quyết** | Bảng vai trò được duyệt, gán trên production |
| C4 | Kế toán khoá chính sách TNCN (tỷ lệ, ngưỡng, xét theo lần hay theo tháng) và mẫu chứng từ chi | Kế toán, chú Dũng chốt | Chính sách nhập bằng tài khoản kế toán |
| C5 | Sao lưu CSDL có cả sổ M9 (chỉ ghi thêm, không sửa tay được) | Anh Tuấn | Có bản khôi phục thử |
| C6 | Nghiệm thu bằng số thật: chạy song song một kỳ với cách tính tay của kế toán | Kế toán + Mạnh | Lệch = 0 hoặc có giải thích |
| C7 | Theo dõi: `06-tracking` (TRACKING_REPORT, WORK_TRACKING, tệp tuần của anh Mạnh), task M9 trên Sheet | Mạnh | Có như M5/M6 |

## 2. Phần đặc tả M9 chưa làm

> D1–D7 đều vào hạn 08/11 (chậm nhất trước 10/11): D1 MISA, D2 ngân hàng thành B7, B8; D3–D7 là việc 8–12 ở `2026-11-05-gui-manh-m9.md` mục 5. Bảng giữ lại để tra chi tiết. D8 ngoài phạm vi.

| # | Hạng mục (đặc tả) | Hiện có | Cần làm | Chặn bởi |
|---|---|---|---|---|
| D1 | **MISA của M9** (§12: hoa hồng/thưởng/thuế) | Không có gì | Bảng ánh xạ (tài khoản, khách hàng, doanh thu, chiết khấu, hoa hồng, TNCN); chuẩn hoá payload; hàng đợi + `MisaSyncWorker`; idempotency; thử lại có giới hạn; nhật ký gửi; 7 trạng thái (NOT_SYNCED…CANCELLED); kế toán duyệt trước khi gửi; đối soát với chứng từ MISA; màn MISA Sync Monitor; smoke M9-P0-009/010/011 | Kế toán duyệt bảng ánh xạ; xác định bản MISA (AMIS hay SME), API và tài khoản sandbox; anh Mạnh tự làm với kế toán |
| D2 | **Ngân hàng / UNC / đối soát** (§11) | Chứng từ là chuỗi gõ tay, bấm "đã chi" | Xuất UNC theo mẫu ngân hàng (hoặc API ngân hàng); trạng thái TRANSFERRED → RECONCILED; nhập sao kê, khớp `bank_ref`, số tiền, người nhận; chuyển lỗi, chuyển sai người; smoke P0-007/008 | Chọn ngân hàng và mẫu UNC; số tài khoản CTV (dữ liệu nhạy cảm) |
| D3 | **Sổ TNCN và kê khai** (§9) | Chỉ có thuế trên từng dòng bảng kê | `pit_ledger` theo người, theo tháng; điều chỉnh thuế khi hoàn; gom theo kỳ kê khai (DRAFT/SUBMITTED/PAID); xuất cho kế toán | Kế toán khoá cách tính |
| D4 | **Thu hồi sau khi đã chi** (§13) | `CLAWBACK` chỉ ghi lại rồi "chờ kế toán xử lý tay"; không trừ kỳ sau, không tính lại thuế | Trừ vào kỳ sau (offset) hoặc ghi khoản phải thu; tính lại thuế; màn Reversal & Clawback | Kế toán chọn cách xử lý |
| D5 | **Luồng duyệt đủ bậc** (§10) | Lập → duyệt (một bậc) | Thêm TAX_REVIEW, OWNER_APPROVAL cho khoản lớn, giữ khẩn cấp | Chú Dũng chốt ngưỡng |
| D6 | **KPI năm / thưởng / voucher** (§8) | BP không có KPI năm | Nhận bản ghi KPI đã duyệt → thưởng → TNCN → chi; voucher không phải tiền thì hạch toán riêng | Chưa có chủ sở hữu KPI năm |
| D7 | **Màn còn thiếu** (§15–16) | Có dashboard và màn chi trả | Nhật ký audit, Evidence Center, danh sách ứng viên hoa hồng, chứng từ có tệp đính kèm | — |
| D8 | NPP / đại lý | Không có | Ngoài phạm vi, ghi lại để không bị quên | Chú quyết |

## 3. Thứ tự đề xuất

> **Cập nhật 05/11 tối:** chú Dũng giao hạn M9 là **08/11** (6 ngày từ 03/11). Lịch dồn theo ngày nằm ở `2026-11-05-gui-manh-m9.md` mục 5. Lịch dưới đây theo mốc chung cũ, chỉ để tham khảo.

1. **Tới 08/11:** toàn bộ A, B, C và D1–D7 (lịch theo ngày ở file gửi anh Mạnh mục 5) · C3 (chú Dũng) · C4 (kế toán).
2. **Tới 10/11 (mốc B nối liên module):** B1, B2, B3, B4 · C1, C2.
3. **Tới 12/11 (mốc C nghiệm thu):** B6, C6 trên môi trường thử · C5.
4. **14/11:** M9 chạy thật **phạm vi đợt này**: doanh thu M3, chi phí M6, hoa hồng → bảng kê → chi ngoài hệ thống có chứng từ.
5. **Phần chưa kịp 08/11:** chậm nhất trước 10/11.

## 4. Lead cần quyết

| Mã | Nội dung | Đề xuất |
|---|---|---|
| lead.63 | ~~08/11 M9 chỉ chạy phạm vi đợt này (không MISA, không ngân hàng)~~ → MISA và ngân hàng làm trong hạn 08/11 (D-lead-022) | đã quyết |
| lead.64 | Vai trò `FINANCE.*`: do chú Dũng chốt, kế toán xác nhận | chuyển chú Dũng |
| lead.65 | MISA: phần của M9, anh Mạnh làm với kế toán, không dính m12 (D-lead-023) | đã quyết |
| lead.66 | B2 (ghi rút xác nhận ở M3): anh Mạnh phối hợp Phúc (D-lead-023) | đã quyết |
