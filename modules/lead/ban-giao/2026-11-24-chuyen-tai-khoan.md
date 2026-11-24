# Bàn giao khi đổi tài khoản Claude · 24/11/2026 17:5x

Thay `2026-11-18-chuyen-tai-khoan.md`. Toàn chuyển sang tài khoản Claude khác (phiên m12 đã chạm giới hạn 5 giờ, mở lại 19:10 ngày 24/11).
**Khác lần 18/11: các phiên luồng ĐÃ CÓ SẴN trên máy này, KHÔNG tạo phiên mới.** Phiên `lead` ở tài khoản mới đọc tệp này, lấy id bằng `list_sessions`
(thêm `include_archived` nếu không thấy), gửi mỗi phiên đúng khối ở mục 3 bằng `SendMessage`, xong báo Toàn mục 2. Nếu Toàn tiếp tục ngay ở phiên lead cũ
(`local_016c7092…`, "Phiên lead chuyển tài khoản") sau khi đăng nhập tài khoản mới thì không cần tin ở mục 4. Nguồn đúng vẫn là `modules/<mã>/TRANG_THAI.md`,
`QUYET_DINH.md`, `nhat-ky/`; số liệu dưới đây lấy lúc 24/11 17:5x (TRANG_THAI m12, m34, m8, m7 ghi mốc 21/11, mới hơn là quyết định D-m12-134 23/11).

| Phiên | id | Ghi chú |
|---|---|---|
| m12 | `local_cf1de578-6b48-4935-aa3a-2d4a1672ddbf` | + bản fork `local_874c329c-df70-44a0-bfec-632f9c7f42f6` (mở 21/11 10:1x, đánh số câu hỏi từ m12.200) |
| m34 | `local_e59ba360-b7bb-436d-930f-21dea206cc73` | |
| m8 | `local_5320dd02-d0f8-490f-88ba-f9fc8fdefe39` | |
| m7 | `local_76a91745-5a47-4234-8622-070752fa38f6` | điều khiển phiên trên .63 |
| m5 / m6 / m9 | `local_93f172da-edaa-4fc7-b126-84345baf00d9` / `local_a2155b5d-2835-4a00-b8cb-2833e08aeefe` / `local_ccda712c-8db1-4b7d-acae-d12699463217` | im từ 18/11, giám sát |

## 1. Trạng thái chung

- **Luật làm việc mới (21/11):** D-lead-063: không worktree/bản sao/clone, mọi phiên và agent sửa thẳng checkout chính, giữ nhau bằng `tools/khoa_tep.py`
  (khoá tệp + khoá đặc biệt `@bo-kiem-du`, `@dot-bien`, `@dong-bo`), chỉ phiên chính commit theo đường dẫn; `_wt` đã dọn 123 mục bằng `tools/don_wt.py`,
  bản vá phần dở ở `C:\Projects\_wt\_luu\<mã>\`. D-lead-064: kiểm nhẹ hai mức (Thường / Nguy hiểm), verifier chỉ ở **cổng Nguy hiểm 25–27/11** trước khi bật cờ thật,
  CI không chạy khi push (ops-core, ivr), lên .99 không qua CI: m12 dựng 5 ảnh ở máy Lead (`git archive <sha> | docker build -`, `docker save | ssh .99 docker load`,
  rồi `trien-khai.sh <sha>`, D-m12-133); m8 dùng pipeline web `M8_FAST_DEPLOY=true` + `deploy_m8_99`. Chi tiết `chung/CACH_LAM.md` §3–§4. Danh sách cổng của m8: `modules/m8/cong-nguy-hiem.md`.
- **.99 đang chạy:** M1–M2 `417f15d53` (WP33 cuối, 23/11 ~18:4x, migration 160, 14 seed production đã chạy 2 lượt) · bán hàng `be`/`fe` `1e2406589` (Phúc, 21/11) với nginx 1.30.7 ·
  M8 `f8e29b46` (21/11 15:10, MOCK, lịch gọi TẮT, `REAL_CUSTOMER_CALL_ALLOWED=NO`). **.98:** proxy Caddy 2.11.9 (20/11), M5 + M6 bản 14/11. **.63:** runner `may-63` + worker M7.
- **Git:** ops-core `main` `417f15d53` đã push (GitHub + GitLab) · bán hàng `dev` = `toandeptrai` = `d109369c2` (đã push, gồm luật gọi M3-02…07, cờ tắt) ·
  ivr `main` `f8e29b46` (đã push) · M7 `origin/main` `0233366` (`day-len.sh` .63 push mỗi giờ). Sổ Project Control: bản `save` tự động 21/11 14:07 đã lên GitHub (kể cả luật mới); còn 17 tệp nhật ký/phiếu chưa commit.
- **Mốc:** 24/11 thử MobiFone (luật v4 cũ, không được vỡ) · 25/11 M-c Production (m12) + mở cổng Nguy hiểm · 26/11 pha 4 tên miền (chỉ khi Toàn bảo) · **27/11 sáng nghiệm thu + tập huấn M12** ·
  28/11 Phúc lên .99 bản bán hàng mới + M-d · **30/11 chạy thật** · ngoại lệ JWT M12 hết 30/11 16:59Z.
- **Rủi ro mở:** (1) chat Claude M4 trên .99: 42/42 lượt bị 401 (20/11), chờ Tài làm khoá mới + trần chi tiêu, Phúc thay; trang bán hàng đã public. (2) Repo bán hàng: BE chưa biên dịch kiểm sau gộp dev
  `d109369c2`; ca `aPressedKeyArrivingWhileTheOrderWaitsStillDecidesIt` timeout giao dịch 5 giây (31/32, riêng ca đó xanh), chưa phân biệt tải máy hay tương tác giữa ca; CI repo bán hàng không chạy test khi push. (3) Backend chạy hồ sơ demo/STAGING, production ghim Claude tắt: phải chốt trước 30/11.
  (4) Cổng 80 công khai ra 400 (chờ Anh Tuấn). (5) Khoá tệp cũ `m12/nong` giữ 68 giờ trên ops-core: phiên m12 giải nếu đã xong.
- **Tài khoản/hạn mức:** mỗi tài khoản có hạn mức 5 giờ và hạn mức tuần; phiên chạm hạn mức ghi lỗi "You've hit your 5-hour limit" rồi dừng, gửi lại sau giờ mở. Phiên .63 của M7 dùng đăng nhập Claude riêng
  trên .63: hết hạn mức tuần thì Toàn đăng nhập tài khoản khác (`ssh -t ssv@192.168.1.63 "bash -lc claude"` rồi `/login`); worker M7 đã hỗ trợ nhiều tài khoản.
- Quyết định lead tới **D-lead-064**. Memory của phiên lead (`C:\Users\Administrator\.claude\projects\C--Projects-Project-Control\memory\`) có `feedback-no-worktrees-single-checkout.md`, `feedback-light-verification-no-ci.md`.

## 2. Việc đang chờ Toàn

| # | Việc | Phiên |
|---|---|---|
| 1 | **m12.200–204** (`modules/m12/TRANG_THAI.md`): nhận gói nào (A WP17b phần mã) · tin mời nghiệm thu + tập huấn sáng 27/11 và sửa kịch bản M12-010 theo DB sạch (nên gửi trước 24/11, tức hôm nay) · 6 phiếu bỏ dở · cách có mẻ bán được (Phúc báo M3 nối kho 19/19 SKU, M12 trả "không bán được", đúng thiết kế) · có làm luồng nhập lô TP cũ không (m12.205 đã trả A) | m12 |
| 2 | **m8: bắt đầu L-05 (intake chế độ luật, vùng Nguy hiểm số 1) có/không**; lịch đêm 03:30 của m8 và m12 cần token GitLab | m8, m12 |
| 3 | m34: bộ đủ ở máy một lần trước 28/11 · cổng Nguy hiểm M3-04 (huỷ đơn + hoàn tiền) và M3-05 (gọi khách thật) · ghi chú triển khai cho Phúc (migration V405–V409, biến `IVR_RULES_*`, quyền `IVR.RULE.*`) · M8 phải xong L-05/L-07 trước khi lật cờ | m34 |
| 4 | m7: 40 câu m7.211…250 (6 câu chặn T232) · đăng nhập hồ sơ Claude của worker (`pwsh tools/dev/dev-ai.ps1 -Login` trên .63) nếu kịch bản Claude thật cần | m7 |
| 5 | Tin còn treo (Toàn tự gửi): Tài/Phúc `modules/lead/tin/2026-11-20_tai-phuc_trien-khai-99-21-11.md`, Tài `modules/lead/tin/2026-11-20_tai_duyet-m5-153.md` (M5-153 chờ Tài gộp `main` + 4 điều kiện), Tài/Phúc `modules/m34/ra-soat/2026-11-20-m4-dev-tai.md` (khoá Claude, đồng bộ GitLab ↔ GitHub), Tài về số migration (m34) | Toàn tự gửi |
| 6 | Anh Tuấn: luật chuyển cổng 80 (http:// ra 400), DMARC, hộp `no-reply@ssavigroup.com`, khoá deploy .98 chỉ đọc; pha 4 tên miền ~26/11 chỉ khi Toàn bảo | lead |
| 7 | Cất khoá riêng + zip chứng chỉ Mắt Bão khỏi Downloads (nếu chưa) | Toàn |
| 8 | Cổng Nguy hiểm 25–27/11: duyệt diff từng vùng trước khi bật cờ thật (m12: WP31, WP32, P10, P13, #17, P14, VAT P1b; m34: M3-04, M3-05; m8: L-05…; m7: theo `KE_HOACH.md`) | từng phiên |

## 3. Khối tin gửi từng phiên (đã có sẵn, chỉ nhắc)

Chung cho mọi khối: đọc lại `CLAUDE.md` §3 mục 5 và 8, `chung/CACH_LAM.md` §3–§4; không tạo worktree; phiên nào dừng vì giới hạn thì chạy tiếp từ `TRANG_THAI.md`/nhật ký, không làm lại việc đã xong.

- **m12 (+ fork):** WP33 cuối `417f15d53` đã lên .99 (23/11), WP30–33 xong phần lên máy. Còn: giải khoá `m12/nong`; cổng Nguy hiểm 25–27/11; WP28 cổng, WP17b phần mã (cờ production, `.env`, bật cờ đặt lại mật khẩu vẫn hỏi Toàn riêng);
  nghiệm thu + tập huấn 27/11; m12.200–204 chờ Toàn. Hai phiên m12: một phiên giữ WP30–33 (`cf1de578`), một phiên giữ m12.200 trở đi (`874c329c`), tránh trùng việc, khoá tệp bảo vệ.
- **m34:** `dev` = `toandeptrai` = `d109369c2`. Việc tiếp: BE biên dịch kiểm sau gộp; ca timeout `OrderIvrRulesModePostgresTest` (tải hay tương tác); bộ đủ một lần dưới `@bo-kiem-du` trước 28/11; ghi chú triển khai cho Phúc; gói NK-b tạm dừng tới khi Toàn lệnh. Lên .99 chỉ Phúc (D-lead-060). Phúc push cả GitHub và GitLab.
- **m8:** `f8e29b46` trên .99 (MOCK). Chờ Toàn quyết bắt đầu L-05; sau đó L-07, L-10 (chạy thử đầu–cuối với m34, MOCK), L-11. `NEXT_WORK_ID` W-0558. Thử đột biến chỉ ở cổng.
- **m7:** `0233366`; luồng làm video thật (D-m7-150: dữ liệu mẫu, Claude/Codex/Muse thật qua UI Studio, test hạn chế, `day-len.sh` push mỗi giờ); đang chờ m7.211…250 và hồ sơ Claude của worker. Mốc 1 trễ, ĐỎ, đóng khi T232 ra video.
- **m5 / m6 / m9:** im từ 18/11. m5: M5-153 (OAuth YouTube, R3) chờ Tài gộp `main`; m6: Go/No-go M6-125; m9: Tài MISA-00/01, Phúc gộp nhánh chú. Không cần gửi tin trừ khi Toàn bảo.

## 4. Tin mở đầu ở tài khoản mới (Toàn dán vào phiên lead mới)

Nếu mở phiên lead mới: gõ `/phien lead`, rồi gửi:

```text
Mình vừa chuyển sang tài khoản Claude khác. Đọc modules/lead/ban-giao/2026-11-24-chuyen-tai-khoan.md rồi làm theo: các phiên m12, m34, m8, m7, m5, m6, m9 đã có sẵn (đừng tạo phiên mới), lấy id ở mục đầu tệp, gửi mỗi phiên đúng khối ở mục 3, phiên nào đang failed vì hết giới hạn thì gửi lại sau giờ mở; xong báo mình mục 2.
```
