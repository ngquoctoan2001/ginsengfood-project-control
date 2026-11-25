# M8-WP08A — Luật gọi cấu hình được (số cuộc, khoảng cách, khung giờ, gọi lại) + hàng chờ nhân viên ở M3

Trạng thái: ĐÃ CHỐT HƯỚNG 20/11 (Toàn m8.110–114), CHƯA LÀM · Rủi ro: R3 (đổi lõi lịch gọi, hợp đồng intake, cách M3 xử lý đơn) · Chế độ: A, coder + verifier độc lập; m34 làm phần M3
Hạng mục nâng: Gọi xác nhận / vận hành · Sheet: chưa tạo · Ước lượng: chưa ước (lớn; cần tách bước khi giao)
Quyết định: D-m8-143 (luật cấu hình được), D-m8-144 (hết luật → hàng chờ nhân viên, đảo TN-2 09/10), D-m8-145 (trần cuộc mỗi số mỗi ngày)

## Yêu cầu của Toàn (20/11, nguyên ý)

1. Mỗi chương trình (Giờ Vàng, 24/7) có luật riêng, sửa được bằng API + giao diện quản trị IVR của M3, không sửa mã.
2. Đơn đủ điều kiện vào hàng đợi gọi liền; **giai đoạn 1** = N cuộc (số cuộc + khoảng cách phút cấu hình).
3. Hết giai đoạn 1 mà chưa bấm 0/1 và rơi vào các trường hợp quy định → **giai đoạn tiếp**: gọi thêm bao nhiêu cuộc, cách nhau bao nhiêu phút, trong ngày và qua hôm sau; tất cả cấu hình.
4. **Nhiều khung giờ gọi mỗi ngày** theo cấu hình.
5. Bấm 0 = huỷ, bấm 1 = xác nhận, mọi trường hợp còn lại (không nghe, nghe không bấm, thuê bao, bận, từ chối, bấm sai…) = nhóm "chưa có kết quả" do M8 giữ và gọi lại; M3 không nhận trạng thái trung gian.
6. Hết luật mà chưa 0/1: M8 trả M3 kết quả cuối (không phải 0/1). **M3 không tự huỷ**: đơn vào hàng chờ nhân viên với 2 lựa chọn — (a) nhân viên tự gọi, nút **Xác nhận / Không xác nhận** (chỉ 0 hoặc 1, gọi lúc nào cũng được tới khi xong); (b) nút **Gọi lại bằng IVR**: gửi M8 gọi từ đầu (reset).
7. Trần cuộc gọi mỗi số điện thoại mỗi ngày (chống gọi dồn khi một khách nhiều đơn).

## Hiện trạng (đọc mã 20/11; chưa sửa gì)

- M8 chỉ gọi callback cho **6 kết quả cuối** (CONFIRMED, CUSTOMER_CANCELLED, NO_ANSWER_FINAL, WINDOW_EXPIRED, INVALID_PHONE_FINAL, CAPACITY_EXCEPTION); không nghe/sai phím/lỗi kỹ thuật chỉ lưu (`specs/functional/05-result-normalization-callback.md`). M8 đã tách lý do: RING_TIMEOUT, BUSY, SUBSCRIBER_ABSENT (thuê bao), REJECTED, ANSWERED_NO_INPUT, WRONG_INPUT_MAX_ATTEMPTS; `UNREACHABLE` và `INVALID_DESTINATION` kết thúc ngay (`DispositionMapper.cs`).
- Intake: M3 gửi `max_customer_attempts` (≤10), `attempt_offsets_seconds` (≤10), `confirmation_window_*`, `attempt_policy_version`; M8 kiểm khớp chính xác bảng `ivr_attempt_policies`, lệch → `409 IVR_POLICY_MISMATCH`. Job giữ lịch tính sẵn (`AttemptScheduleJson`, offsets, `ExpiresAt`), bất biến.
- M3 (`OrderIvrLifecycleService`): cứng cửa sổ 390/990 giây, ba mã policy v4, hạn cuộc cuối 300/900 giây; watchdog huỷ đơn `IVR_WATCHDOG_EXPIRED` khi quá hạn; `OrderIvrResultServiceImpl` từ chối kết quả dương tính tới sau hạn, mọi kết quả khác "xác nhận" → huỷ + hoàn tiền + nhả hàng.
- Gọi lại hôm sau hiện do M3 gửi task mới `recall_of_task_id` (QT-CHUNG-011, khung 08–09/13–14/20–21 mặc định); M3 trên .99 chưa gửi.
- M8 chưa có API cấu hình luật; có sẵn vòng soạn → duyệt → dùng của kịch bản lời thoại (`/scripts/...:submit|approve|retire`) và cờ tính năng để học theo.

## Thiết kế đề xuất (chờ Toàn chốt từng điểm ở "Mặc định")

**Phân vai.** M3: gửi đơn đủ điều kiện + chương trình + trần giữ đơn của giai đoạn M8; nhận kết quả cuối; xử lý hàng chờ nhân viên. M8: chọn luật theo chương trình lúc nhận (snapshot bất biến vào job như nay), quyết mọi lần gọi lại, cam kết gửi kết quả cuối trước trần.

**Bộ luật** (bảng DB có phiên bản, mỗi chương trình một bản đang dùng):
- `calling_windows`: danh sách khung giờ trong ngày (nhiều khung; tuỳ chọn theo thứ), giờ Việt Nam; khoảng nghỉ tối thiểu giữa hai cuộc (nay 60 giây).
- `phase1`: số cuộc + danh sách khoảng cách (phút) từ T0 hoặc từ cuộc trước.
- `phase2`: chuỗi bước gọi tiếp — mỗi bước "sau X phút" hoặc "vào khung giờ K cùng ngày / ngày +1"; số cuộc tối đa mỗi bước.
- `outcome_actions`: bảng lý do → GỌI LẠI (theo chuỗi) / KẾT THÚC NGAY; mặc định: không nghe, bận, thuê bao, từ chối, nghe không bấm, sai phím = gọi lại; `UNREACHABLE`, `INVALID_DESTINATION` = kết thúc ngay.
- Trần: tổng cuộc mỗi đơn, cuộc mỗi ngày mỗi đơn, **cuộc mỗi số điện thoại mỗi ngày**, tầm xa tối đa từ lúc nhận (khớp trần M3), tuỳ chọn `stop_after_session_end_minutes` (Giờ Vàng).
- Hết luật → kết quả cuối `IVR_NO_ANSWER_FINAL` kèm số cuộc, lý do cuối, cờ cần nhân viên.

**API (M8; M3 chuyển tiếp ra UI như tab Cước gọi/kịch bản):** `GET` danh sách/một bản/bản đang dùng theo chương trình; `POST` tạo nháp từ bản đang dùng; `PUT` sửa nháp; `:validate`; `:simulate` (giờ nhận + chuỗi kết quả giả định → lịch dự kiến); `:submit`, `:approve` (người duyệt ≠ người soạn), `:activate` (chỉ đơn mới), `:retire`; audit mọi thay đổi; quyền ghi tầng riêng.

**Hợp đồng (draft.49).** Intake: các trường số cuộc/offsets/window trở thành tuỳ chọn; có `attempt_policy_version` kiểu cũ (v4) thì đi đường kiểm khớp như nay, không có thì M8 tự chọn luật; ack trả tầm xa dự kiến. Callback không đổi mã kết quả; thêm trường cho nhóm "cần nhân viên" (hoặc dùng nhãn `HOLD_ADMIN_REVIEW` đã có trong dây) — chốt khi viết hợp đồng. Gọi lại thủ công dùng lại `recall_of_task_id` (nối dòng dõi), bỏ khung giờ gọi lại cố định, theo `calling_windows`; vẫn từ chối khi đơn còn chuỗi gọi mở.

**Phần M3 (m34)** — xem hộp thư khi giao: bỏ phần cứng 390/990/ba mã v4; kết quả cuối không phải 0/1 (+ hết hạn watchdog) → trạng thái "chờ nhân viên", giữ hàng/tiền; UI hàng chờ + nút Xác nhận / Không xác nhận (ghi ai, lúc nào) + nút Gọi lại bằng IVR (task mới qua M8) ; khi nhân viên quyết thì thu hồi task M8 còn mở; nhận kết quả muộn của M8 theo "ai tới trước"; trang "Luật gọi" proxy API trên.

## Mặc định tôi chọn (ghi để Toàn đổi nếu khác; không hỏi lại)

- Mọi kết quả cuối khác 0/1 (hết luật, số sai, hết hạn, M8 không gọi được) đều vào hàng chờ nhân viên, kèm lý do; chỉ khách bấm 0 mới tự huỷ.
- Hàng chờ nhân viên KHÔNG tự huỷ; có ngưỡng cảnh báo cấu hình được (giờ chờ).
- Gọi lại thủ công chạy toàn bộ luật của chương trình từ đầu, đơn xin giờ ngoài khung thì giữ tới khung kế.
- Kết quả M8 tới sau khi nhân viên đã quyết: bỏ qua (ai tới trước thắng).

## Còn mở

- m8.114 ĐÃ CHỐT (Toàn 20/11 15:45, D-m8-146): mốc "không gọi sau khi phiên Giờ Vàng kết thúc + N phút" (QĐ-02, C-11) thành tuỳ chọn cấu hình được trong luật (`stop_after_session_end_minutes`, để trống = không mốc). Giá trị mặc định khi tạo luật Giờ Vàng: 5 phút (như hợp đồng hiện nay); 24/7: để trống.
- Chưa thử mã SIP của MobiFone: phân biệt "thuê bao" với "không nghe" ngoài đời chưa kiểm (chưa gọi thật).
- Đợt thử MobiFone ~24/11 chạy luật v4 hiện có (3/2 cuộc, M3 vẫn huỷ khi hết luật) vì phần mới chưa kịp an toàn.

## Bước kế tiếp chính xác

(Cập nhật 24/11 19:36) Đã giao từng gói con: W-0552…W-0557 xong và đã lên .99 ở `f8e29b46` (cờ chế độ luật chưa dùng). **L-05 intake chế độ luật = W-0558 XONG phía M8, commit local `c2bb7064`** (chưa push, chưa lên .99; Sheet M8-026; D-m8-152/153/154): chọn chế độ theo có/không ba trường v4, cờ M8 `IntakeMode` mặc định `V4_ONLY` (chưa có job chế độ luật nào được tạo ở đâu), ack thêm `call_rule_set`, `first_call_due_at`, `planned_horizon_at`, hợp đồng draft.49 đổi hash `c5f10955…1ac8` → `26a7bbe5…c729`; chưa đột biến/verifier (cổng Nguy hiểm 25–27/11); m34 đã được báo qua hộp thư. **L-07 gọi lại thủ công = W-0559 XONG phía M8, commit `6ed2d535`** (24/11; đã lên origin + GitHub 25/11 07:26, không do phiên m8; chưa lên .99; Sheet M8-027; D-m8-155; task chế độ luật mang `recall_of_task_id` nhận như task thường, theo `calling_windows` của luật, không theo khung 08–09/13–14/20–21, không bị mốc phiên, giữ chốt gốc/đơn mở; hash draft.49 mới `56cd056d…6229`; chưa đột biến/verifier — cổng 25–27/11). **Cổng Nguy hiểm vùng 1 cho L-05/L-07 đã chạy 25/11** (verifier CẦN SỬA, 0 nặng; đã sửa ở W-0560 `30ceb19c`; hash draft.49 cuối `af5b19204447276de55aa8f4f53a80364818ed46f74d782f95700cc2ff322e47`; chờ Toàn m8.118, m8.119). **L-11 XONG phía M8: W-0561 `15e5a6bb`** (25/11, local; DSAR + retention xoá `phone_key`, claim fail-closed khi mất khoá; chưa verifier phần claim). Kế tiếp: L-10 (chạy thử đầu–cuối với m34, MOCK, cần bật `IntakeMode`), L-11 (DSAR `phone_key`). Push/lên .99/đổi cờ chỉ khi Toàn nói.
