# Trạng thái — m8

Mốc: **26/11/2026 04:2x** (đồng hồ máy) · phiên m8 · Toàn giao 25/11 tối: làm hết [KE_HOACH.md](KE_HOACH.md) qua đêm, việc nào cần Toàn thì ghi CẦN TOÀN. **Phần tự làm được đã xong; còn lại đều cần Toàn hoặc việc ngoài.** Bản TRANG_THAI cũ (18–25/11): [nhat-ky/2026-11-25-trang-thai-truoc-viet-lai.md](nhat-ky/2026-11-25-trang-thai-truoc-viet-lai.md).

## Máy thật (không đổi đêm nay)

- `ginsengfood-ivr`: origin `main` = `f375bfaf`; **.99 chạy `f8e29b46` theo sổ 21/11, chưa kiểm lại**; MOCK, lịch TẮT, `REAL_CUSTOMER_CALL_ALLOWED=NO`. **.64** Asterisk 22.11.0.
- Đêm nay **không** push, không lên .99, không ssh/sudo máy chủ, không đổi cờ, không chạy lệnh trên .64.
- `main` local (HEAD `3a2518dc`) chạy trước origin 25 commit, toàn commit local theo gói W (xem `git log origin/main..main`).

## Đã xong đêm nay (13 gói W-0563…W-0578, commit local)

| Việc | Gói / commit |
|---|---|
| Hợp đồng draft.50 **đóng băng**, hash cuối `a8852a7f92d98f6f58424b37ec86d190fe61f5991c549f59668531c66481bcb6` (m34 ghim hash này: [hộp thư](../../hop-thu/m34-2026-11-26-m8-draft50-hash-cuoi.md)) | W-0564 `1ef3b3c7`, W-0576 `25f76cac` |
| 26 tuyến draft.50 **chạy thật** (hết 501): hồ sơ giọng 10, nghe thử 5, kho cụm 8, trần 3 | W-0567 `0652c742`, W-0568 `90518ccd`, W-0569 `cc912f55`, W-0570 `38db107c` |
| Dữ liệu 3 bảng + chỉ mục một sự cố tạm dừng mở; tạm dừng đua nhau chạy lại một lần | W-0565 `f8906674`, W-0575 `2fc21962` |
| Giọng theo vùng đọc từ kho, cờ `OPTIONS` mặc định (bật `STORE` ở MVP **không đổi giọng khách nghe**) | W-0566 `f86eaa52` |
| Trần cuộc/ngày nhập trên màn hình; chưa có trần thì **không quay** (`CEILING_UNSET`) | W-0570 |
| CDR tối giản .64 + ghim gói; kịch bản khung bảo trì .64 (226/226 ca giả) | W-0572 `b5c1824a`, W-0574 `4c078617`, H-02 |
| Ma trận hành vi API 87 thao tác (902 yêu cầu) | W-0577 `673904dc` |
| Nợ nhóm C, nợ nhẹ sau cổng, N-11, 17 README thêm dấu `REAL_CUSTOMER_CALL_ALLOWED=NO` | W-0563, W-0573, `ab598929`, W-0578 `7f7613c7` |
| Sổ: work-register 565 mục, gate-status, traceability, Sheet M8-030…044 | `d2eb0ef6`, `4af2bea9` |

## Kiểm (số thật, cây `0e8cf6d7` trở đi)

- **Cổng Nguy hiểm vùng 3 + vùng 2: ĐẠT chờ bộ đủ** (verifier độc lập, 1 vòng, 0 nặng, 0 trung bình, 10 nhẹ; 16 đột biến, 15 đỏ): [cong-nguy-hiem.md](cong-nguy-hiem.md), báo cáo `ra-soat/2026-11-26-cong-vung3-ket-qua.md`.
- **Bộ đủ:** integration 1550/1550 · unit 2705/2705 (sau sửa 2 ca đỏ, một ca đỏ có sẵn từ W-0558) · contract 33 · media 14 · chaos 8 · python `deploy/m8/tests` 458 OK · gate-status PASS · `scan-pii.sh` PASS 3413 tệp bằng chứng được theo dõi. gate-sweep 51/52, 1 đỏ chỉ do thư mục gitignore cục bộ.
- **CHƯA CHẠY:** `oasdiff` (chỉ CI), gitleaks chế độ git (đã quét diff: 21 phát hiện giả), CI, dựng ảnh + trivy, `buoc3.sh` trên .64 thật, mọi thứ trên .99/.98/.64. **Chưa phải "sẵn sàng chạy thật".**

## CẦN TOÀN (sáng mai đọc, chốt) — chi tiết [KE_HOACH §6](KE_HOACH.md)

- ~~m8.130~~ **ĐÃ CHỐT B (D-m8-161, 26/11 07:3x):** làm hiệu lực thật ngay đổi giọng/tốc độ (G-11b: bank mới + co giãn tốc độ); đang thiết kế ([wp/giong-thuc-te-thiet-ke.md](wp/giong-thuc-te-thiet-ke.md) khi xong). Pháp lý giọng (X-03) chỉ chặn bật production.
- ~~m8.141~~ **ĐÃ CHỐT B (D-m8-161):** Toàn đã mở phiên m34; phiên m34 làm G-08/G-09/T-02 theo [wp/giong-m34-be-fe.md](wp/giong-m34-be-fe.md); m8 đã nhắn brief + hash draft.50. m34 sẽ hỏi Tài giữ số migration V410.
- ~~m8.145–147~~ **ĐÃ CHỐT (D-m8-161):** 145 = C (chỉ checklist go-live, chưa làm báo động "chưa đặt trần"), 146 = A (kích hoạt hồ sơ khi kho cụm trống vẫn được), 147 = ghi "trần 120 giây là cấu hình bắt buộc 1–300" vào checklist go-live.
- **m8.140** N3 (hai task không `recall_of_task_id`); **m8.142–144** CDR; **m8.138/139** xoay chứng thư ARI; **m8.123–126** giờ bảo trì .64 (mặc định 28/11 22:30), ufw RTP, khoá CA ARI.
- Việc ngoài: X-01 MobiFone gọi thử, X-03 pháp lý giọng (VieNeu), X-04 người trực/cảnh báo, X-05 custody khoá, X-08 token GitLab, X-09 sudo .64; B-01…B-06 (push + quét trước push, lên .99 **chỉ Phúc**, 01D gọi thật nội bộ, đo tải, bật production).
- Bật nghe thử trên .99 cần `Ivr__Voice__Preview__Synthesis=ON` cho API và worker + `Phrases:Enabled` + `Ivr:Speech:Phrases:MediaDirectory` ở API; chỉ khi Toàn nói.
- K-04: 80 dòng bằng chứng chờ Toàn đọc rồi chuyển ACCEPTED; W-0037/W-0033/34/W-0007 cần Toàn quyết ([wp/ho-so-phat-hanh-07F.md](wp/ho-so-phat-hanh-07F.md)).

## Sẵn sàng và ranh giới

- **54%** (K-05 chấm lại 26/11: giữ, không tăng, vì thang đòi thao tác trên máy thử/Lead). Kịp 30/11: VÀNG — còn việc ngoài, .64, gọi thật nội bộ 01D, MobiFone.
- `production_accepted=false`, `deployable=false`.

## Quyết định đang hiệu lực

- D-m8-157 (m8.118 A, m8.119 A), D-m8-160 (kế hoạch giọng đọc + trần + .64), D-m8-138 (số trần nhập trên màn hình, không ghi trong mã). D-lead-063 (một checkout, khoá tệp), D-lead-064 (kiểm Thường/Nguy hiểm).
- Số W đã cấp tới W-0578 (W-0571 = số giữ, không có hàng); `NEXT_WORK_ID` W-0579.

## Nợ

- 10 nợ nhẹ N1…N10 của cổng 26/11 ở [cong-nguy-hiem.md](cong-nguy-hiem.md) (không chặn). N-12 báo động chưa đặt trần (chờ m8.145). Docs/phiếu: quy tắc chữ trong `docs/evidence` (không dùng "đường", "tổ", "ấp"… vì quét PII) ở [wp/giong-doc-quy-tac-agent.md](wp/giong-doc-quy-tac-agent.md).
- Trước gọi thật: ufw RTP 10000–10999 + nguồn SIP, thay chứng thư lá ARI hết hạn 13/01/2027 (~14/12), hỏi MobiFone khối tính cước + chặn quốc tế, công thức cước 6+1.
- Dirty không do phiên: `deploy/operations/m34_mock_agent.py` + test (chưa theo dõi, của phiên khác).
