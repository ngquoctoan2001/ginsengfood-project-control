# Sóng nối M12↔M3 phía M3 — 12/11 (7 coder song song)

Nguồn lệnh: Toàn gõ trực tiếp 12/11 ~09:30 ("tiếp tục các task kết nối m12 và m3 … spawn nhiều sub agent song song … hạn chế test"). Phiên m12 (M1-2) làm phía M12, hai phiên nhắn nhau trực tiếp.
Base: `toandeptrai` = `dev` = `17212e584`. Brief chung: `C:/Projects/_wt/m34/_tools/BRIEF_CHUNG.md`. Khoá Maven: `_wt/m34/_tools/mvn-lock.sh` (một Maven mỗi lần). Mỗi coder một worktree `_wt/m34/<tên>`, trả patch `_wt/m34/<tên>.patch`, KHÔNG commit; phiên chính áp patch và commit.

| Gói | Task (Sheet) | Worktree / patch | Migration | Mức |
|---|---|---|---|---|
| sku02 | SKU-M3-02 (M3-143) trigger audit + chặn DELETE hai bảng link | `sku02` | V340 | R2 |
| kho123 | KHO-M3-01/02/03 (M3-144/145/146) | `kho123` | — | R2 |
| nm3-13 | NM3-13 (M3-123) compose .60 quan sát, kiểm trước deploy | `nm3-13` | — | — |
| sec16-sku04 | SEC-16 (M3-159) + SKU-M3-04 (M3-150) | `sec16-sku04` | — | R2 |
| docs-qd | KHO-M3-13 (M3-155) + SKU-M3-06 (M3-156) | `docs-qd` | — | Tài liệu |
| nkb | NM3-40 + NM3-41 (M3-132/133) | `nkb` | V342 | — |
| webhook | NM3-51a (M3-136) | `webhook` | V344 | — |

Dải migration M3: V340 sku02 · V341 dự phòng kho123 · V342–343 nkb · V344–345 webhook · V346+ chưa cấp (SKU-M3-11, KHO-M3-08, SKU-M3-12…).
Quy tắc tránh xung đột: chỉ sec16-sku04 được sửa `OpsCoreHttpClient`, `OpsCoreTokenCache`, `OpsCoreClientProperties`, `OpsCoreConfigRules`, `application.yml`; các gói khác dùng lớp cấu hình mới, mặc định trong mã.

Sóng sau (chờ sóng này): NM3-42 (sau nkb) · SKU-M3-03 (sau sec16; lifecycle 8 giá trị) · SKU-M3-10 · KHO-M3-05 + NM3-54 (FE, worktree `fe-nm354`) · KHO-M3-08/10 · SKU-M3-11/12 · SKU-M3-13 + NM3-61b (runbook, worktree `docs-rb`) · NM3-31 · SEC-15 · SEC-09/22 · NM3-73 · KHO-M3-07 · DIET-4 (chờ DIET-1/2 của m12).

## Diễn biến
- 12/11 09:55 giao 7 coder nền; Sheet 12 task chuyển Đang làm (5%).
- 12/11 09:50 trả lời m12 (3 câu): SEC-15 đề xuất 30 phút/tối đa 60, 3 hold chưa thanh toán/khách, 10 hold/giờ/IP, SEC-14 mặc định 200 hold/principal (m12 nhận); M3 không đọc 6 trường webhook sắp bỏ. m12 trả: `GET /v1/skus/{id}` đã có (lifecycle 8 giá trị, chưa có đơn vị/updated_at), stock-balances có cursor (≤100), hợp đồng reserve/release ổn định từ 12/11 (đóng băng chính thức trước 18/11; `GET allocations` sẽ bắt buộc `sourceObjectId`).
- 12/11 10:10 coder docs-qd xong: patch áp, commit `44ac63978` (6 tệp tài liệu; 5 tệp nằm trong manifest `to-do-list/_maintenance` nên STALE tới khi chạy `accept-revision`); Sheet M3-155/156 REVIEW 90%.
- 12/11 11:07 phiên khởi động lại, 5 coder (sku02, kho123, nm3-13, sec16-sku04, nkb) dừng giữa chừng; webhook không nhận được tin nhắn nên giao coder mới `a85e13b9…` tiếp tục từ worktree. Đã xoá khoá Maven cũ, đã gửi tin "tiếp tục từ chỗ dở" cho 5 coder còn lại. Bài học: phiên restart giết agent nền, nên brief bắt nộp patch sớm phần đã xong.
- 12/11 12:41 phiên khởi động lại lần 2 (4 agent dừng: sec16-sku04, 3 verifier); đã đánh thức lại, xoá khoá Maven cũ. Có hai phiên M3-4 cùng chạy (mình [bc594b] và một phiên Desktop [9a77e8]); đã nhắn phiên kia không chạm checkout BP, `_wt/m34`, ledger m34.
- 12/11 12:45 áp và commit: NM3-13 `7e52fd671` (kèm sửa guard cron tồn demo cho phép quan sát), KHO-M3-01/02/03 `68b8d91a9` (verifier ĐẠT). Giao sóng 2 (không Maven): docs-rb (SKU-M3-13 + NM3-61b), sku10 (SKU-M3-10), fe-nm354 (KHO-M3-05 + NM3-54). m12 chốt: UUIDv5 vector `order-item:*` khớp; webhook `docs/webhook-security.md`; SEC-14: 409 ALLOCATION_CONFLICT + HOLD_LIMIT_REACHED/HOLD_SHARE_LIMIT_REACHED (không phải hết hàng), 422 reason REQUESTED_QUANTITY_LIMIT_EXCEEDED/EXPIRES_AT_LIMIT_EXCEEDED, hạn giữ ≤ 60 phút. Cần đưa vào vòng sửa của nkb (NM3-42).
