# Sẵn sàng — liên module và hệ thống chung (tới chạy thật 30/11)

Mốc: 25/11 08:4x · % sẵn sàng: **35** (trung bình trọng số) · Kịp 30/11: **ĐỎ** cho đủ phạm vi; bản tối thiểu (cuối tệp) kịp nếu đường găng giữ được.
Nguồn: `/ke-hoach` 25/11, 3 scout chỉ đọc (git fetch 25/11; không ssh, không chạy test). Ghim: BP `origin/dev` = `toandeptrai` `d109369c2` · ops-core `738d91808`
· ivr `6ed2d535` · module5 `62dab674` · M7 `880f26e` · contracts `main` `a7832a4` (nhánh `m12-noi-m3` `a57a11f`, `lead/order-channel-state-v1` `2d6807d`).
.99 chạy M1–M2 `417f15d53`, bán hàng `1e2406589`, M8 `f8e29b46` MOCK (sổ 24/11). Bậc điểm nối = bậc phía thấp hơn; chưa điểm nào 75 trên bản hiện tại.

## Hạng mục lõi (tổng trọng số 100)
| Hạng mục (người ngoài hiểu được) | Trọng số | Bậc | Bằng chứng |
|---|---|---|---|
| N5 Đơn mới → gọi xác nhận → kết quả về đơn (M3 ↔ M8) | 20 | 50 | Hợp đồng nguồn `ivr/specs/api/openapi` draft.49; **ba hash lệch**: M3 ghim draft.48 `978b0db4…` (`IvrContractPinTest.java:26-27`), .99 M8 `c5f10955…`, `main` M8 `56cd056d…`. M3-02…07 trên `dev`, cờ `IVR_RULES_*`=LEGACY_V4 (`application.yml:646-652`). Đường v4 từng 75 (14–15/11) nhưng ảnh đã đổi; nối .99 TẮT từ 18/11 |
| N8 Giữ/nhả/trừ hàng, đọc kho/SKU/tồn (M3 ↔ M1–M2) | 15 | 40 | Hợp đồng chỉ ở nhánh contracts `a57a11f`; ghim lệch (ops-core `1e73bc1`, BP `a3b4bbf`). Đọc + cổng bán 50 (token 200 17/11 rồi tắt); NK-b 40–50; NK-c, trừ hàng 0. Release cần `AllocationSelfRelease:Enabled` (mặc định false, `deploy/m12/compose.yml:140`); M3 `max-hold` PT55M (`application.yml:327-334`) |
| Tồn kho cho đơn thật khi xác nhận | (trong N5) | 0 | `OrderIvrInventoryServiceImpl.java:60` đọc `inventory_wms_stock_snapshots`; chỉ fixture E2E ghi bảng này; webhook M12 chỉ ghi inbox → đơn thật bấm 1 có thể ra `REVIEW_REQUIRED` (D-m34-023, thư `hop-thu/lead-2026-11-04-m34-anh-ton-kho-wms.md`). Từ đọc mã, CHƯA KIỂM trên .99 |
| N4 + N3 AI tư vấn: trong web (M4 → M3) và Messenger (M5 → M4) | 10 | 40 | M4 chỉ phát thẻ giá + `cartAction`, không tạo giỏ (`useConsultationChatSession.ts:132-140`); quote-preview TẮT. N3 hợp đồng v1.3 trong module5, 5 fixture cùng blob hai phía; khoá Claude .99 401 (20/11); .98 `AI_ADVISOR_MODE` rỗng; M4-004/007 quá hạn |
| N6 + N7 Thanh toán VNPAY, vận chuyển GHN/VTP/SPX | 15 | 40 | VNPAY 50: SIT 6/6 (30/10), lớp sandbox .99, IPN 403 vì danh sách IP rỗng (`compose.vnpay-sandbox.yml:6-7`), chưa có lớp cổng thật. Vận chuyển 40: 3 hãng bật, 0 hãng báo giá (VTP 503, SPX 403, GHN thiếu cân/kích thước) |
| N13 M5 đọc trạng thái đơn trước khi gửi tin | 5 | 50 | Hai phía khớp 8+8 trạng thái; hợp đồng DRAFT, PR #2 contracts OPEN từ 13/11. M3 cờ tắt (503); M5 reader trên main, .98 mock; mẫu env .98 thiếu `ORDER_STATE_READER_MODE`, `M3_ORDER_STATE_*` |
| Đo quảng cáo: N10 M3 → M6, M5 → M6, N9 băm CH21 | 5 | 0 | M6 có bộ nhận "đơn đã xác nhận" nhưng "Not wired" (`m6/app/measurement/inbound/order_verified.py:35`); M3 phát 0 chỗ; M5 → M6 0 lời gọi; CH21 khớp định dạng 6/6, hợp đồng nằm ngoài repo |
| Hạ tầng chung: cổng vào HTTPS, sao lưu, khôi phục, bí mật (G3–G5) | 15 | 40 | `edge-98` 75 (công khai từ 17/11, 19/19) nhưng `deploy/edge-98` chưa commit, HSTS 300 s. Sao lưu: M1–M2 kéo đêm về máy Toàn đều tới 24/11 (`C:\GinsengfoodBackups\m12-ops-pilot-daily\pull-log.jsonl`); BP, M8, M5/M6 chỉ trên máy. Khôi phục: chỉ M8 75 (14/11, RTO 9,7 s). Token Sheet còn bị theo dõi ở BP (1), module5 (2), module6 (1); M5-094 trễ 20 ngày; BP, module5 không gitleaks |
| Chạy thật toàn hệ thống: runbook, thứ tự bật cờ, trực, cảnh báo (G6) | 10 | 0 | Chưa có runbook chung; chỉ runbook từng module (ops-core `go-live-cutover-plan.md`, ivr cutover cho .61/.64, module5 RU-01…21). Kênh cảnh báo M12 `BLOCKED_EXTERNAL`; M8 chưa người trực; BP .99 hồ sơ demo + `AI_RUNTIME_ENVIRONMENT=STAGING`; `compose.cong-khai.yml` không nằm trong git BP |
| M9: M6 → M9 chi phí, M9 ↔ M1–M2 (MISA) | 5 | 10 | M6 → M9 mã hai phía khớp (`m9.py:33` ↔ `M6AdSpendClient.java:41`), M9 nguồn `none`. MISA: không hợp đồng, BP gateway none/file/fake, ops-core `MisaSyncOptions__Mode: DryRun`; thư `hop-thu/lead-2026-11-17-m9-misa-cham-m12.md` chưa xử lý; D-m9-003 cho bật MISA sau 30/11 |

Cách tính: (20×50 + 15×40 + 10×40 + 15×40 + 5×50 + 5×0 + 15×40 + 10×0 + 5×10) / 100 = 35.
**Mở rộng, sau 30/11:** M7 → M5 (đăng tay theo `MetaSchedulePackage`, không có client), N11 M7 → M6 (chưa chốt chiều), N1 M3 → M7 (M7 chưa adapter), N2 M7 → M1–M2 (mock; tài khoản `availability-v1`, `SVC-M7` chưa tạo).

## Cổng G1–G8 (`chung/CONG_PRODUCTION.md` §3)
| Cổng | Trạng thái | Thiếu gì |
|---|---|---|
| G1 Chức năng lõi | chưa | xem `SAN_SANG.md` từng luồng |
| G2 Liên module | chưa | ba hash N5 lệch; contracts `main` chưa có hợp đồng giữ hàng, PR #2 DRAFT; chưa điểm nào chạy đầu-cuối trên bản hiện tại |
| G3 Bảo mật | chưa | token Sheet, M5-094, khoá Claude M4; gitleaks BP + module5; checkout contracts còn merge kẹt (41 xung đột, `08585c1` +1/−81) |
| G4 Dữ liệu | chưa | sao lưu ngoài máy BP, M8, M5/M6; khôi phục thử M1–M2, BP trên .99; BP chưa hồ sơ production, còn dữ liệu demo |
| G5 Triển khai | một phần | từng repo có `trien-khai.sh`; `deploy` chung lỗi thời (17/07, không remote); `edge-98` chưa commit; không có máy thử (staging gỡ 18/11) |
| G6 Vận hành | chưa | runbook chung + bảng cờ; kênh cảnh báo + người trực P1/P2 |
| G7 Kiểm thử | chưa | CI tắt khi push (D-lead-064); cổng Nguy hiểm: m12 7/7 vùng (WP32 cần sửa), m8 L-05/L-07 chưa bằng chứng, m34 M3-04/05 chưa phiếu, m7 dở, **m5, m6, m9 chưa có danh sách** |
| G8 Ngoài code | chưa | bảng việc ngoài dưới đây; `VIEC_NGOAI.md` dừng ở 02/11, cần viết lại |

## Gói việc
| WP | Mục tiêu (xong khi) | Rủi ro | Phụ thuộc | Mốc | Ước lượng | Trạng thái |
|---|---|---|---|---|---|---|
| LM-01 Một bản hợp đồng M3 ↔ M8 | M3 ghim draft.49 `56cd056d…` + sửa `IvrContractPinTest`; M8 L-05/L-07 qua cổng Nguy hiểm; Phúc lên .99 bản `dev` (luật gọi + V405–V409), M8 lên .99 L-05/L-07; E01–E10 + luật mới (L-10) đạt trên .99 | Nguy hiểm (gọi khách, huỷ + hoàn tiền) | Phúc lên .99; Toàn nói push | 28–29/11 | m34 3 h, m8 4 h | SẴN SÀNG |
| LM-02 Tồn kho cho đơn thật | Kiểm trên .99 đơn không phải SKU demo bấm 1 ra gì; chọn và làm một đường ghi/đọc tồn (lead.108) | Nguy hiểm (xác nhận đơn thật) | dữ liệu nền M12 | 28/11 | m34 4 h | SẴN SÀNG |
| LM-03 Hợp đồng chung | contracts `origin/main` FF lên `a57a11f` (push refspec, không đụng checkout); PR #2 vào `main`; lưu bản vá rồi bỏ merge kẹt local; hai repo dời ghim | Thường | Toàn nói push; Phúc + Tài duyệt PR #2 | 27/11 | lead 2 h | CHỜ Toàn (lead.109) |
| LM-04 Nối kho chế độ quan sát | Dữ liệu nền M12 .99 (m12.206 tối 26/11); nạp lại link kho/SKU M3 (đối chiếu `WH_FG_MAIN` vs `WH-20112026-000002`); M3 đặt PT26H/PT27H; bật OBSERVE, không ENFORCE (NK-c chưa có) | Nguy hiểm (tồn kho) | LM-03; Phúc ghi .99 | 27–30/11 | m12 3 h, m34 2 h | SẴN SÀNG |
| LM-05 Runbook bật thật + bảng cờ | Một tệp: thứ tự M12 → M3 → M8 (MOCK) → M5 → M6, giờ, người bấm, điều kiện dừng, cách lùi; bảng cờ gộp (an toàn / chạy thật / ai bấm); diễn tập đọc ngày 29/11 | Thường | sổ cờ từng luồng | 27/11 soạn, 29/11 diễn tập | lead 4 h | SẴN SÀNG |
| LM-06 Hạ tầng chung | Commit `edge-98` + sửa README (staging, 2.11.9); HSTS 1 năm (lead.110); gitleaks một lượt BP + module5; xoay token Sheet + gỡ theo dõi; sao lưu ngoài máy BP, M8 (lead.111); khôi phục thử một lần M1–M2, BP trên .99 | Thường (khôi phục: Nguy hiểm) | Toàn; Phúc (BP .99), Tài (module5) | 28/11 | lead 3 h + Phúc, Tài | CHỜ Toàn |
| LM-07 Pilot marketing 30/11 | Chốt chế độ pilot (lead.106); nếu có AI: khoá Claude mới + trần, cờ advise + token, `AI_ADVISOR_MODE=real` .98; N13 cờ + token, biến mẫu .98, gọi thử 4 đơn `GF-TEST`; gắn Page pilot | Nguy hiểm (chat công dụng) | Toàn quyết; phép thử tài khoản ngoài (D-m5-069) | 27/11 | Tài 4 h, Phúc 1 h | CHỜ Toàn |
| LM-08 Thanh toán, vận chuyển trên .99 | IP IPN VNPAY, một giao dịch sandbox trên .99; GHN cân/kích thước SKU + báo giá; VTP thử lại; phương án COD + giao tay nếu chưa có hãng | Nguy hiểm (tiền) | VNPAY, hãng, chị Lan | 28/11 | Tài 4 h, Phúc 1 h | SẴN SÀNG |
| LM-09 Cổng Nguy hiểm liên luồng | Mỗi luồng có danh sách vùng + phiếu: m34 M3-04/05; m5 OAuth YouTube, OTP quản trị; m6 token đăng nhập (lỗi Cao 24/11); m9 hoa hồng/chi trả; BP VNPAY/IPN, OTP admin, chat công dụng | Nguy hiểm | các luồng | 25–27/11 | lead 2 h điều phối | SẴN SÀNG |
Hoãn sau 30/11: N10 M3 → M6 (lead.105; không kịp thì M6 pilot chỉ chi phí), M5 → M6, N9, M7 ↔ M3/M5/M6/M1–M2, MISA (D-m9-003).

## Đường găng tới 30/11
25/11 Toàn quyết lead.103–111 → 26/11 M3 ghim hợp đồng N5, khoá Claude mới, dữ liệu nền M12 tối 26/11 → 27/11 cổng Nguy hiểm xong (m8 L-05/L-07, m34 M3-04/05), nghiệm thu M12, Phúc lên .99 bản `dev`, contracts FF
→ 28/11 kho quan sát, tồn kho đơn thật, VNPAY sandbox → 28–29/11 E01–E10 + luật mới trên .99 → 29/11 chụp DB, khôi phục thử, diễn tập runbook → 30/11 bật theo runbook.
Trễ một ngày ở 26–27/11 là mất gọi xác nhận tự động ngày 30/11 (rơi về xác nhận tay).

## Việc ngoài code
| Việc | Ai gỡ | Cần trước ngày | Trạng thái |
|---|---|---|---|
| Cổng 80 công khai; RAM .98 trên 8 GB; máy thử bản sao .99; máy video M7; xác nhận chụp `/data` | Anh Tuấn | 28/11 (máy video chưa ngày) | mở |
| MobiFone thử trunk + phím; giấy định danh tên công ty | Toàn → MobiFone, đơn vị dịch vụ | 27/11 | quá hạn (24/11, ~20/11) |
| Chú duyệt lời thoại 3 miền + 455 tên; 19 câu công dụng + 4 TPCN cho chat M4 | Chú (Toàn gửi) | 27/11 | quá hạn; tin công dụng 20/11 chưa gửi |
| Khoá Claude M4 mới + trần chi tiêu | Tài tạo, Phúc thay | 26/11 | mở (401 từ 20/11) |
| Meta: phép thử tài khoản ngoài (bình luận + tin riêng), gắn Page pilot; không đăng ký Tech Provider | Tài (D-m5-069) | 25/11 | đạt cả hai thì không cần App Review; không đạt thì chốt hướng khác 25/11, pilot nội bộ |
| VNPAY thông số thật + IP IPN; GHN báo giá; VTP máy thử; SPX hợp đồng | Tài, chị Lan, hãng | 28/11 (SPX sau 30/11) | mở |
| M12: tin mời nghiệm thu 27/11, 3 chữ ký, dữ liệu nền | Toàn; Khánh, chú Dũng, Lan, Sang | 26/11 | tin mời chưa thấy xác nhận đã gửi |
| Xoay token Sheet; cất khoá + chứng chỉ Mắt Bão khỏi Downloads; custody khoá M8 | Toàn | 28/11 | mở |

## Không kịp 30/11 + bản tối thiểu chạy được 30/11
Không kịp: gọi khách thật (MobiFone, định danh, lời thoại); VNPAY thật; báo giá ship qua hãng nếu hãng chưa cấp; ROAS M6; MISA; M7 nối thật, chương trình 70 phút; NK-c (giữ hàng Giờ Vàng).
Bản tối thiểu 30/11: M1–M2 chạy thật sau nghiệm thu 27/11 · web bán hàng nhận đơn COD (giao tay nếu chưa có hãng), VNPAY thử nghiệm tắt với khách · xác nhận đơn: M8 MOCK hoặc xác nhận tay, nối kho chế độ quan sát
· M5 + M6 pilot phạm vi trên .98 (chi phí quảng cáo, tin riêng chuyển người trực nếu chưa có AI) · M4 chỉ bật khi đạt 20 kịch bản + có người trực · M7 video ngắn đăng tay · M9 chạy trong bản bán hàng, MISA sau.
