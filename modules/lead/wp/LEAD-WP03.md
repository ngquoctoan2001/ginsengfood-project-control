# LEAD-WP03 — Đủ bộ sổ theo dõi ở mọi repo như M5/M6; Nguyễn Quốc Toàn có nhật ký tuần riêng

Trạng thái: ĐẠT, bộ sổ ĐÃ DUYỆT bản 1.1 (M7, business, ops-core đã lên remote; M8 commit ở máy chờ push) · Rủi ro: R2 (tracker) / R1 (tài liệu) · Chế độ: tracker W (worktree tách rời business), tài liệu S (tệp mới, tách nhau)
Hạng mục nâng: công cụ theo dõi + sổ theo dõi từng module · Sheet: M12-001 · Ước lượng: 3–4 giờ AI
Lời Lead 02/11 14:3x: "module 5 và module 6 tao rất hài lòng, mày hãy xem và cập nhật lại cho đủ từng repo… làm xong push lên giúp tao,
riêng repo m34 business platform commit push lên dev (nhánh toandeptrai nữa) — và cho tao đoạn tin nhắn để tụi nó pull về".
Người: M1–M2, M7, M8 chỉ Nguyễn Quốc Toàn · M3–M4: Nguyễn Quốc Toàn (M3 kết nối M8, sau đó M3 kết nối M1–M2), Nguyễn Phát Tài
(M4 AI tư vấn, M3 vận chuyển + thanh toán), Trương Công Phúc (M3 backend + frontend).

## Chuẩn (mẫu M5/M6)
`docs/06-tracking/TRACKING_REPORT.md` (hiện trạng, tiến độ, lỗi, nhận xét) · `docs/06-tracking/WORK_TRACKING.md` (sổ `WT-nnn` việc của người + AI)
· `docs/weekly-tracking/<người>.md` (lệnh `sheet-sync log` tự ghi, mỗi người một tệp).

## Chỗ thiếu (kiểm 02/11 14:3x, `git ls-files` + quét ổ)
| Repo | TRACKING_REPORT | WORK_TRACKING | Tệp tuần |
|---|---|---|---|
| ginsengfood-ops-core (M1–M2) | thiếu | thiếu | thiếu `nguyen-quoc-toan.md` |
| ginsengfood-business-platform (M3–M4) | thiếu | thiếu | có Phúc, Tài; thiếu `nguyen-quoc-toan.md` |
| ginsengfood-golden-hour-video (M7) | có | thiếu | thiếu `nguyen-quoc-toan.md` |
| ginsengfood-ivr (M8) | thiếu | thiếu | thiếu `nguyen-quoc-toan.md` |
| module5, module6 | có | có | có (Tài) — mẫu, không đổi |
Gốc lỗi công cụ: `team.json` để `trackingFile: null` cho Nguyễn Quốc Toàn → lệnh `log` không ghi tệp tuần của Toàn ở repo nào.

## Gói con
- A tracker (business, worktree `C:\Projects\_wt\lead\bp-task-tracker-1.4`): Toàn có `trackingFile`; Toàn làm M4/M5/M6 vẫn ghi tệp Tài
  (giữ nguyên M5/M6); không tự giao task mới cho Toàn ở module người khác; câu rule trong `install.mjs`; test `C:\Projects\_wt\lead\test-toan-file\`.
- B–E tài liệu: ops-core, business (worktree), M7, M8 — chỉ tệp mới (M7 có thể thêm một liên kết trong TRACKING_REPORT).
- F ghép: `install.mjs` sang ops-core, ivr (đường tracker sạch); M7 chỉ chép `team.json` (phiên m7 đang sửa `tools/task-tracker`,
  `sheet.json` đã stage xoá — không đụng). Commit theo đường dẫn; push: business `toandeptrai` + `dev`, ops-core `main`, M7 `main`, M8 `main`.

## Diễn biến (mỗi vòng một dòng, mới nhất ở cuối)
- 02/11 14:4x phiên lead: lập phiếu, giao 5 coder song song (A tracker; B ops-core; C business; D M7; E M8).
- Lead chọn "Chờ m12 xong": không push ops-core khi `main` còn commit WP03a chưa kiểm.
- A coder: 46 ca test mới (23 ca đỏ trước) · verifier ĐẠT 19/21 đột biến, test 46/46, 70/70, 39/39 (5 ca cũ đổi kỳ vọng có chủ đích) · phiên lead sửa câu rule
  "(M4, M5, M6) → tệp Tài", README, PROMPT-module-khac.
- B ops-core 3 tệp (39 WT, 25 TRK) · C business 3 tệp (33 WT, 20 TRK; phát hiện V259 trùng số, CI #146 đỏ) · D M7 2 tệp (19 WT; check_docs bỏ qua
  weekly-tracking như M6) · E M8 3 tệp (31 WT, 15 TRK). Verifier đọc nhanh: M8 ĐẠT; ops-core (trạng thái push cũ), business (thiếu §Nhật ký phiên),
  M7 (42→43 tệp, WT-019 cũ) CẦN SỬA → phiên lead đã sửa; M7 check_docs 0 lỗi.
- F ghép 17:3x: `install.mjs` → ops-core, ivr (`sheet.json` trả về bản đang commit vì giá trị giống hệt); M7 chép `team.json`; `log --dry-run` cả 3 repo →
  tệp Toàn; `sheet-sync log` M12-001 ở 4 repo (Sheet đồng bộ, mục vào tệp tuần mới). Commit: ops-core `d70b3cc95` (chưa push, sau `7e6946a39` m12),
  ivr `8bca14bd` (chưa push, sau sóng 2 `5fa00ccd`, `055b9a9f` đang kiểm cuối; detect_changes rủi ro thấp), M7 `62cfb1e` **đã push**,
  business `bce4564d7` + `4baf81207` → `toandeptrai` và `dev` **đã push** (ff từ `f29bf2667`, gồm WP01/02). Hộp thư m12, m8, m7, m34.
- 02/11 19:25 → 03/11 01:3x · Bạn: "tag lại file code gs. xóa nhánh, duyệt draft. soát lại." · gửi lại `Code.gs` 1.4.0 · xoá nhánh
  `lead/task-tracker-1.4.0` bị cài đặt chặn → bạn tự chạy · duyệt bản 1.0 → ĐÃ DUYỆT 1.1 (D-lead-012) · auditor soát Tổng kết tuần 44: M7 ĐẠT;
  ops-core, business, M8 sửa theo báo cáo tổng hợp tuần (bản Word), git và sổ phiên, bỏ "chờ soát". Commit chỉ phần của mình (mục các phiên
  khác ghi thêm vào tệp tuần để ngoài): business `f9ef593c5` → `toandeptrai` + `dev` **đã push**; M7 `a0aa1a2` **đã push**; ops-core `060c9de68` (phiên m12 push cùng `4ad2efae1`),
  ivr `d76c249b` (detect_changes thấp) commit ở máy, chưa push. Hộp thư 4 luồng thêm dòng bổ sung.

## Bước kế tiếp chính xác
Ops-core: đã lên remote (`4ad2efae1`). Push ivr `main` (`8bca14bd`, `d76c249b`, sau sóng 2 và `f14a6a25`) khi phiên m8
kiểm xong sóng 2 và bạn cho. Phúc, Tài pull `dev`. Phiên m7 chạy lại `install.mjs` sau khi xong việc gỡ `sheet.json`.
Bạn: dán `Code.gs` 1.4.0 vào Apps Script, triển khai, chạy "Khởi tạo / cập nhật cấu trúc"; xoá nhánh cục bộ `lead/task-tracker-1.4.0`.

## Còn lại / CẦN QUYẾT
- module5, module6 giữ bộ tracker cũ (Toàn làm ở đó vẫn ghi tệp Tài): `install.mjs` sang đó khi Tài sẵn sàng, không gấp.
