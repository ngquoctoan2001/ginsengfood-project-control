# Kiểm chéo báo cáo tuần 02/11–07/11/2026
Agent chỉ đọc, `git_tong_quan.py --fetch --tu "2026-11-06 17:30"` lúc 07/11 09:54. ops-core không có commit mới. PR #149, #150 (M9) gộp 06/11 15:15–15:16, trước giờ chốt sớm nhất.

## 1. Commit vào nhánh chung sau giờ chốt số

| Module | Commit | Câu bị ảnh hưởng | Đề xuất cho bản gửi Chú |
|---|---|---|---|
| M5 | `1e54848` 07/11 08:48 PR #74 M5-036 (xoá dữ liệu Meta) · `f7fea01` 09:06 PR #75 M5-051 (gửi Messenger thật, PSID mã hoá) | Báo cáo dòng 18, 20 "còn M5-032, 036, 051" đã cũ; bản rà ghi "dời 10–11/11" cũng cũ. Hai PR gộp 9–12 giây sau khi mở, #75 không có CI_LOCAL, DL-213 PM chốt thay Tài | Sửa việc còn lại: 032, 036, 051 có mã, mặc định vẫn bản giả; M5-051 (R3) chưa có lượt rà của Toàn |
| M6 | `ca342b1` 08:29 PR #71 M6-074 (cảnh báo thu hồi/khoá bán) | Dòng 27 "còn M6-074…077" | M6-074 đã có mã |
| M6 | `9905ae3` 09:32 PR #72 M6-015b CI chạy local, danh sách 89 "phát hiện đã biết" | Dòng 21, 129 "CI chưa bật" cũ; danh sách cho qua token Sheet, 2 EMAIL trong `tests/`, 4 PHONE | CI local đã có; lệch D-m6-010 (mục 3) |
| M3 kết nối | `9a4690574` 08:56 Toàn (tăng bộ nhớ build FE) | "CI xanh": lúc chốt run 42322720623 đỏ; sau 08:56 run 42326689372 xanh | Ghi "bản 07/11 đóng gói xanh sau khi sửa" |
| M8 | `712db10a` 08:47, `5fc9ec7d` 09:09 (W-0512) | "governance … đã sửa ở `c788cb75`": pipeline 3039043317 trên `c788cb75` vẫn đỏ; 29 → 31 commit | Ghi governance còn đỏ vì quá giờ, đã nới, chưa chạy lại |
| M3 bán hàng, M3 vận chuyển, M4, M7 | `ce21d1f59` (trước giờ chốt), PR #152 (bản rà M4 đã ghi), M7 3 commit chưa đẩy | Không đổi câu nào | Bỏ qua; nhắc đẩy `250873a` của M7 |

## 2. Chỗ nối giữa hai module

| Chỗ nối | Kết quả | Bằng chứng |
|---|---|---|
| M3 → M8 gửi đơn | Khớp mã, cờ tắt | BP `IvrAdminProperties.java:21`, `deploy/m34/compose.yml:180` ↔ M8 `TaskIntakeEndpoint.cs:25` |
| M8 → M3 trả kết quả | Mã khớp, người phụ trách lệch | BP `OrderIvrCallbackController.java:28` ↔ M8 `TargetV1CallbackTransport.cs:63`; mã do Toàn viết (M3-023), báo cáo M8 chờ Phúc, báo cáo M3 kết nối chờ luồng M8, báo cáo M3 bán hàng ghi của Phúc hạn 27/11 |
| Hợp đồng M3 ↔ M8 | Lệch | `ginsengfood-contracts` `ivr-order-confirmation.v1.yaml:258` sai đường; repo hợp đồng dừng `a7832a4` (21/09), bản local merge dở 41 xung đột |
| M5 → M4 tư vấn | Đường gọi khớp, "11/11 ca" chưa kiểm | M5 `http-m4-advisor.ts:93` ↔ BP `SecurityConfig.java:111`; hợp đồng chỉ ở `module5/docs`; `AI_ADVISOR_MODE` mặc định `mock` |
| M5 → M7 bình luận | Lệch | M5 `real-m7-comment-dispatch.ts:5` gửi tới đường của M7 cũ (`module7`); M7 mới bỏ phần này; cờ `noop` nên chưa hỏng |
| M3 → M1–M2 kiểm tồn | Khớp, cờ tắt | ops-core `AvailabilitySellableV1Endpoints.cs:71` ↔ BP `OpsCoreAvailabilityHttpAdapter.java:25`; `OPS_CORE_ENABLED` false |
| M3 → M1–M2 giữ/nhả hàng | Lệch ngày | ops-core có `ExternalAllocationCommandV1Endpoints.cs:38,53`; BP chưa có client; M12 cần trước 10/11, Phúc hẹn 27/11 |
| M3 → M6 doanh thu | Khớp (chưa nối); báo cáo M3 bán hàng bỏ sót | BP không có nơi phát doanh thu xác thực cho M6 |
| M5 → M6 tín hiệu | Khớp (hai phía tắt) | M6 `app/main.py:25` ↔ M5 `draft-locked-m6-emitter.ts:8-22`; M6-005 (P0, hạn 14/11) không có trong báo cáo |
| M6 → M9 chi phí | Mã khớp, chưa chạy | M6 `app/http/m9.py:33` ↔ BP `M6AdSpendClient.java:40`; `FINANCE_AD_COST_SOURCE: none` |
| Thanh toán và Giờ Vàng | Lệch | `CheckoutValidationServiceImpl.java:56-59` chặn COD cho Giờ Vàng; VNPAY tắt cứng ở `deploy/m34/compose.yml:165` → 15/11 chỉ COD thì không có đơn Giờ Vàng |
| Vận chuyển GHN, VTP | Chưa kiểm chứng | phụ thuộc đối tác, số cân 1/19 SKU |

## 3. Điểm cần Toàn quyết
1. Ai cấp địa chỉ, khoá chặng M3 ↔ M8 (cả hai luồng đều là Toàn).
2. Giữ/nhả hàng NK-b, NK-c: M12 cần trước 10/11, Phúc hẹn 27/11.
3. M6-015b cho qua phát hiện bí mật thay vì dọn (trái D-m6-010).
4. M5 gộp R3 (M5-051, M5-036) không chờ rà, không CI_LOCAL.
5. Chặng M5 → M7 trỏ vào M7 cũ; repo hợp đồng chung cũ từ 21/09.
6. Giờ Vàng không bán được nếu 15/11 chỉ có COD.
