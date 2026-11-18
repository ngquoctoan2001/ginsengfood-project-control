# Bàn giao khi đổi tài khoản Claude · 16/11/2026 20:2x

Toàn chuyển sang tài khoản khác, bên đó đã có đủ các phiên. Phiên `lead` bên tài khoản mới đọc tệp này rồi **gửi từng khối ở mục 3
cho đúng phiên của luồng** (SendMessage; tìm phiên bằng ListAgents / list_sessions theo tên, ví dụ "Phien M12", "M1-2"). Khối nào không
tìm thấy phiên thì báo Toàn một dòng, không tự mở phiên mới. Gửi xong thì báo Toàn mục 2 (việc đang chờ Toàn).

Mọi số liệu dưới đây lấy từ sổ lúc 20:2x. Nguồn đúng vẫn là sổ của từng luồng: `modules/<mã>/TRANG_THAI.md`, `QUYET_DINH.md`, `nhat-ky/2026-11-16.md`.
Phiên ở tài khoản cũ đều đứng yên (không phiên nào đang chạy) và không chạy tiếp, tránh hai phiên cùng ghi một tệp.
Các phiên phụ bên tài khoản cũ (m12 phụ CI, m8 phụ .99, m34 phụ .99, lead hạ tầng) **không mở lại**; việc còn của chúng đã gộp vào khối của phiên chính.

## 1. Trạng thái chung

- Máy .99: M1–M2 `87acc810` (13/11), M3/M4/M9 `afb6d404c` + lớp quản trị IVR (15/11), M8 `e9976810` (draft.45). .98: M5 :3000, M6 :6600.
  .63 máy dev chạy lại từ 10:14 16/11 (D-lead-055), runner `may-63` chạy 2 job một lúc (mỗi job 5 nhân, 12 GB; lui = 1 job).
  Hai dòng cổng tạm trên .99 đã gỡ 11:02 (lead.h1 xong). .60/.61 dừng app, giữ dữ liệu làm đường lui.
- Quyết định lead hôm nay: D-lead-048…056 (`modules/lead/QUYET_DINH.md`). Quan trọng nhất:
  D-lead-054: Phúc **chỉ** rà và gộp nhánh chú Dũng vào `dev` BP (+ M9, D-lead-052); Toàn vẫn code M3 → M8 + gói NK-b trên `toandeptrai`, tự gộp vào `dev`.
  D-lead-051: ops-core và ivr gộp code chú vào `main`, giữ luật chú, bật hết, push `main` (đã xong cả hai).
  D-lead-056: buổi E07 → E02 + E03 → E08 chạy **trước** khi M8 mới lên .99.
- Rà liên module 12:50 VÀNG: `modules/lead/ra-soat/2026-11-16-lien-module-m12-m34-m8.md` (thứ tự lên máy đúng ở mục "Thứ tự đúng").
- 16:31 Windows máy Lead có lệnh tắt/đăng xuất, Docker Desktop bị tắt; m34 bật lại 18:0x. Lab UAT m12 tắt hẳn, container `ginsengfood-postgres-local` Exited.
- Sổ Project Control có nhiều thay đổi chưa commit/push (repo công khai: quét bí mật trước, push khi Toàn bảo).

## 2. Việc đang chờ Toàn

| # | Việc | Phiên |
|---|---|---|
| 1 | Bấm `deploy-99` ops-core (pipeline #3072542878 trên `668b29e0d` xanh 13/13) — bước 1 thứ tự nối M12 ↔ M3 | m12 |
| 2 | Cho bật lại lab UAT m12 (Docker đã chạy lại) | m12 |
| 3 | Duyệt push `toandeptrai` (6 commit, tới `d3d91686d`) + PR vào `dev` | m34 |
| 4 | Chọn giờ mới cho buổi E (14:14–18:00 không ai đặt đơn thử nên dời; M8 đã trả lại, lịch TẮT) | m8 + m34 |
| 5 | M7 trên .63: chép 5 ảnh sản phẩm (lệnh trong khối M7 .63), đăng nhập Codex CLI, duyệt thiết kế T222 + trần Muse 4, duyệt push 3 commit | m7 .63 |
| 6 | lead.92 nâng số bảo đảm giữ hàng trong hợp đồng `m12-noi-m3` lên 26 giờ (đề xuất có) · lead.93 fast-forward `main` hợp đồng lên `5b90c0b` (đề xuất có) | lead |
| 7 | Dán `tools/sheet-lead/Code.gs` 1.5.2 vào Apps Script + deploy bản mới (tab M9 chủ Phúc) | Toàn tự làm |
| 8 | Gửi tin: Phúc (bàn giao `modules/m34/ban-giao/2026-11-16-*`), Tài (M5 + M6 + M4, `modules/lead/tin/2026-11-16_tai_m5-m6-m4.md`), trả lời Tài về cờ seed | Toàn tự gửi |
| 9 | Thêm chú vào `deploy/ci/governance/m8-builders.json` không (đề xuất có) · xoá 2 nhánh `chudung/m12-*` trên GitHub | lead / Toàn |

## 3. Khối tin gửi từng phiên

### 3.1 Gửi phiên m12 (M1–M2)
Đổi tài khoản 16/11 20:2x, đọc lại `modules/m12/TRANG_THAI.md`, `QUYET_DINH.md` (tới D-m12-080), `nhat-ky/2026-11-16.md`. Phiên m12 phụ (CI) đã xong việc, không mở lại; phần còn của nó về phiên này.
- ops-core `main` = origin = gitlab = `668b29e0d`; cục bộ còn 5 commit UAT/theo dõi tới `27b7a658a` CHƯA push.
- Pipeline tay #3072542878 xanh 13/13; `deploy-99` manual, chờ Toàn bấm. Lên xong: trên .99 tạo principal + secret cho M3, nạp link 19 SKU/kho, bật tự nhả (thứ tự ở bản rà liên module).
- Lab UAT tắt do Docker bị tắt 16:31 và don_may của m34 dừng tiến trình `_wt/m12/uat-*`; hỏi Toàn trước khi bật lại. Đợt 1d (29 ca) chưa chạy.
- Hợp đồng `origin/m12-noi-m3` = `5b90c0b`, chưa vào `main` hợp đồng (lead.93); ops-core vẫn ghim `1e73bc1`. lead.92 (số bảo đảm 26 giờ) chờ Toàn.
- Để sau: quét image ứng viên + DAST trên Linux (D-m12-065); bỏ mặc định .61 trong `Invoke-M12Deploy61.ps1`; mô tả runner GitLab còn ghi "1 job".
- Nghiệm thu M12-010 chưa có ảnh biên bản ký; tin chú `ra-soat/2026-11-16-tin-chudung.md` chưa gửi.

### 3.2 Gửi phiên m34 (M3, M4, M9)
Đổi tài khoản 16/11 20:2x, đọc lại `modules/m34/TRANG_THAI.md`, `QUYET_DINH.md` (tới D-m34-091), `nhat-ky/2026-11-16.md`.
- Phân việc theo D-m34-091 / D-lead-054: Phúc chỉ rà + gộp nhánh chú vào `dev` (+ M9); m34 (Toàn) giữ M3 → M8 + gói NK-b trên `toandeptrai`, tự gộp vào `dev`.
- Local `toandeptrai` `d3d91686d` đi trước `origin/dev` `b2568a319` 6 commit, CHƯA push: gói 7 `95ebd81dd`, `ghim-draft47` `76ef7d060`, gói 8 `d8960e9b0`, gộp dev `b4d4b1368`, sửa `env.mau` `d3d91686d` (CI dev đỏ 2 ca khuôn vì khối `MAIL_*` của Phúc đặt sai chỗ). Chờ Toàn duyệt push + PR vào `dev`; sau push kiểm `kiem-tra-khuon` xanh.
- m34.109 F1/F2 (`IvrTaskHttpClient`) chờ Toàn. Bàn giao Phúc + tin nháp Phúc/Tài chưa gửi.
- Buổi E dời (M8 chờ tới 18:00, không có đơn thử). Lần tới: đơn kế tiếp đọc lại bằng `doc-id-don-99.sh` (lần trước 590).
- Lần sau don_may gặp tiến trình `_wt/m12/uat-*` thì nhắn m12 trước, không dừng.

### 3.3 Gửi phiên m8 (IVR)
Đổi tài khoản 16/11 20:2x, đọc lại `modules/m8/TRANG_THAI.md`, `QUYET_DINH.md` (tới D-m8-116), `nhat-ky/2026-11-16.md`. Phiên m8 phụ không mở lại; phần còn của nó về phiên này.
- ivr `main` = GitLab = GitHub `680508c7` (sinh lại NSwag cho draft.47 sau khi CI `8ab726dd` đỏ). Pipeline `3072568426` lúc 16:34 còn chờ runner: kiểm kết quả.
- `deploy_m8_99` bấm tay, KHÔNG bấm trước buổi E (D-lead-056).
- Buổi E dời: 14:14–18:00 không có đơn, đã `tra-lai` 18:01 (lịch TẮT, 0 cuộc dở, 0 callback đang gửi, 5 dead letter cũ như trước). Chờ Toàn chọn giờ mới; phiếu `wp/buoi-e07-e02-e03-e08.md` ở trạng thái DỜI.
- Câu mở: thêm chú vào `deploy/ci/governance/m8-builders.json`; báo động sớm khi gửi lại callback kéo dài 24 giờ (hỏi chú).

### 3.4 Gửi phiên m5 (M5, M4 của Tài)
Đổi tài khoản 16/11 20:2x, đọc lại `modules/m5/TRANG_THAI.md`, `QUYET_DINH.md` (tới D-m5-048).
- m5.35–39 A đã ghi (D-m5-044…048). Tin gộp M5 + M6 cho Tài: Toàn gửi bằng tệp `modules/lead/tin/2026-11-16_tai_m5-m6-m4.md` (bản đã sửa câu Phúc).
- Go/No-go chậm nhất 20/11; HTTPS `mkt.` Anh Tuấn hạn 18/11 (đường đi theo D-lead-050). M5-142 Cần sửa, PR #118 5 lỗi Cao chờ Tài.

### 3.5 Gửi phiên m6
Đổi tài khoản 16/11 20:2x, đọc lại `modules/m6/TRANG_THAI.md`, `QUYET_DINH.md` (tới D-m6-020). Lượt rà 4 chờ M6-082, M6-157 gộp `main`. Deploy key chỉ đọc .98: Tài sinh khoá, Toàn dán GitHub (hạn 17/11). Không có câu m6 mở.

### 3.6 Gửi phiên m7 máy Lead (chỉ giữ sổ)
Đổi tài khoản 16/11 20:2x, đọc lại `modules/m7/TRANG_THAI.md`, `QUYET_DINH.md` (tới D-m7-100). Phiên .63 đã báo qua lead, chưa vào sổ m7:
- T190a/T190b `4e86eb3`, `a99ffa2`: lượt cũ `SV-20261114-006` chạy lại thành công (ASR 0,906), video ở trạng thái chờ QA, cần Toàn duyệt.
- T222 làm lại luồng video ngắn: thiết kế commit `0137486` (DL-330…335, gói WP31 11 task ~98 giờ), chưa code. Cần hỏi: WP31 nằm trong Mốc 1 hay sau 30/11.
- Cả 3 commit chưa push (origin `765eaa6`). Ghi sổ + Sheet khi phiên .63 báo SHA.

### 3.7 Gửi phiên M7 trên .63 (ssh `may-63`, `~/dev/ginsengfood-golden-hour-video`)
Đổi tài khoản 16/11 20:2x. Đang chờ Toàn: chép 5 ảnh sản phẩm vào `~/dev/m7-input/chao-sam/` (lần trước chép nhầm 91 icon Windows, đã xoá, thư mục trống), đăng nhập Codex CLI, duyệt thiết kế T222 + trần Muse 4, push `4e86eb3`, `a99ffa2`, `0137486` (chỉ khi Toàn nói "push").
Lệnh chép đã gửi Toàn (PowerShell trên Windows, ghi thẳng đường dẫn nên không phụ thuộc thư mục đang mở): `scp (Get-ChildItem -LiteralPath '<thư mục A1. Diêm mạch hạt sen>' -Filter *.png).FullName ssv@<máy .63>:dev/m7-input/chao-sam/` — đúng thì 5 tệp, mỗi tệp 2,5–4,4 MB.
Lưu ý tài khoản mới phải đăng nhập Claude trên .63 một lần (`ssh -t ssv@192.168.1.63 "bash -lc claude"` rồi `/login`).

### 3.8 Phiên lead (chính phiên nhận tệp này)
Đọc `modules/lead/TRANG_THAI.md`, `QUYET_DINH.md` (tới D-lead-056), `nhat-ky/2026-11-16.md`, kế hoạch tuần `ke-hoach-tuan/2026-11-16_2026-11-21.md`.
Phần hạ tầng (phiên lead phụ cũ) về phiên này: theo dõi Anh Tuấn HTTPS 4 tên + `mkt.` (hạn 18/11), máy ảo M7 + máy staging, RAM .98, IP nginx (m12.100), kho sao lưu ngoài máy; tệp Excel máy chủ gửi Anh Tuấn (Toàn tự sửa sheet VIDEO; tệp chứa mật khẩu, giữ ngoài git).
Deploy lên .99/.98 vẫn theo lời Toàn từng lần; lời đồng ý không chuyển sang việc khác.
