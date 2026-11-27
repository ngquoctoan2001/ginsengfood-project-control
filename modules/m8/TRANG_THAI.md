# Trạng thái — m8

Mốc: **26/11/2026 ~19:3x** (đồng hồ máy) · phiên m8 · lệnh Toàn 25/11 tối: làm hết [KE_HOACH.md](KE_HOACH.md); sáng 26/11 Toàn chốt D-m8-161/162 (làm hiệu lực thật đổi giọng/tốc độ, ba vùng ba giọng khác nhau, thêm cấu hình tỉnh thuộc vùng, phiên m34 làm phần Module 3). Bản cũ: [nhat-ky/2026-11-25-trang-thai-truoc-viet-lai.md](nhat-ky/2026-11-25-trang-thai-truoc-viet-lai.md).

## Máy thật (không đổi)
- `ginsengfood-ivr`: HEAD local `cebf9d1c` (hợp đồng draft.51 đã chốt chữ; 8 commit chưa lên origin); **.99 chạy `f8e29b46` theo sổ 21/11, chưa kiểm lại**; MOCK, lịch TẮT, `REAL_CUSTOMER_CALL_ALLOWED=NO`. **.64** Asterisk 22.11.0. Phiên m8 **không** push, không lên .99, không ssh/sudo, không đổi cờ, không chạy lệnh trên .64 (có người push `origin/main`; không phải phiên này).
- **Lên .99: M8 TRƯỚC (Toàn, pipeline M8), rồi bản M3 (Phúc).** Chi tiết: [wp/checklist-go-live.md](wp/checklist-go-live.md).

## Đã xong (commit local, chưa lên máy)
| Việc | Gói |
|---|---|
| Đêm 25–26/11: 26 tuyến draft.50 chạy thật (hồ sơ giọng, nghe thử, kho cụm, trần), dữ liệu, CDR + kịch bản bảo trì .64 (chỉ soạn), nợ nhóm C, ma trận API 87, bộ đủ xanh, cổng Nguy hiểm vùng 1–3 ĐẠT | W-0563…W-0578 |
| **Giọng/tốc độ thật (m8.130 = B):** bộ co giãn WSOLA (hash vàng đúng trên Windows + Linux), bank 9 cặp + tập giọng cấu hình được, bản dẫn xuất theo tốc độ, luồng gọi dùng bản dẫn xuất + ghi `voice_speaking_rate`, luật 0.80–1.20, readiness có bản dẫn xuất, kích hoạt nguyên tử cả bộ (hoán đổi giọng, GIỮ ba giọng khác nhau) | W-0579…W-0583 |
| **Tỉnh thuộc vùng:** bảng 34 tỉnh + nguồn `RegionSource`, kho + kiểm sẵn sàng + làm nóng + áp dụng lô tất-cả-hoặc-không + API, ghim vùng/giọng theo lượt quay | W-0586, W-0587, W-0589 |
| **Hợp đồng draft.51** (W-0590, chốt chữ ở W-0595) hash `abf1d485f621b1a56f373053f459b7100bff0797bbc78ab38de047bbfcea61fd` (draft.50 `a8852a7f…` giữ byte cho m34), 32 tuyến nối | W-0590 |
| **Chốt draft.51** hash CUỐI `abf1d485f621b1a56f373053f459b7100bff0797bbc78ab38de047bbfcea61fd` (thay `4efa9132…`, chưa ai ghim); ma trận API 93/93; nghe thử khi tổng hợp TẮT; nợ sau cổng giọng và tỉnh–vùng | W-0591, W-0592, W-0593, W-0594, W-0595 |
| Rà độc lập + đột biến: phần giọng ĐẠT (0/0/10 nhẹ; đột biến 15/15 đỏ do người viết gói nợ, 4 cái rà đề nghị đã nằm trong đó); phần tỉnh–vùng ĐẠT (0/0/8 nhẹ; đột biến độc lập 22/22 đỏ, 0 sống) ([cong-nguy-hiem.md](cong-nguy-hiem.md) Vùng 3b/3c) | — |
| m34 (Module 3): G-08/G-09/T-02 xong, commit trên `toandeptrai`; m34.136 = A (route queue/resume) | phiên m34 |

## Kiểm (bộ đủ lần hai, HEAD `cebf9d1c`, 26/11)
- contract 46, media 14, chaos 8, **unit 3235/3235, integration 1781/1781** (31 phút), python `deploy/m8/tests` 458 OK (14 bỏ qua): không đỏ nào. Lần một (đêm 25–26/11): integration 1550, unit 2705.
- **Chưa chạy:** `oasdiff` (CI), gitleaks chế độ git, trivy ảnh, gate-sweep lần hai, nghe tốc độ 0.80/1.20, bank 9 cặp + bản dẫn xuất + bật `STORE` trên .99. Không agent nào đang chạy.

## CẦN TOÀN / việc ngoài (tóm tắt; chi tiết [KE_HOACH §6](KE_HOACH.md))
- **Dán hộp thư cho phiên m34:** [hop-thu/m34-2026-11-26-m8-draft51-hash-moi.md](../../hop-thu/m34-2026-11-26-m8-draft51-hash-moi.md) (hash draft.51 **`abf1d485…61fd`** (đã chốt, dán được ngay), nút "đặt cả bộ", màn hình Tỉnh–Vùng); phiên m34 cũ không còn mở nên m8 không nhắn được.
- **Việc cần máy thật + Toàn:** dựng 6 cặp bank ở .99 rồi nghe duyệt (W-0584); **nghe tốc độ 0.80 và 1.20 trên câu có số tiền** (khuyến nghị chỉ bật 0.90–1.10 tới khi nghe); làm nóng, bật `Variants`, `ProfileSource=STORE`, `RegionSource=STORE`, kích hoạt (W-0585, từng bước, lùi bằng cờ OPTIONS).
- Còn mở: m8.140 (N3 recall), m8.142–144 (CDR), m8.138/139 (chứng thư ARI), m8.123–126 (bảo trì .64, mặc định 28/11 22:30), việc ngoài X-01/03/04/05/07/08/09, B-01…B-06 (push, lên .99, 01D, đo tải, production). Pháp lý giọng X-03 chỉ chặn bật production.
- Đã chốt (không còn hỏi): m8.130 B, m8.141 B, m8.145 C, m8.146 A, m8.147 ghi (checklist), m8.148 B (giữ ba giọng khác nhau), m8.149 A, m8.150 oke, m8.151 oke; m8.152–154 làm theo mặc định A (đơn đã nhận theo vùng mới từ lượt kế; dùng lại hai quyền giọng; chỉ cấu hình theo tỉnh), Toàn đảo được.

## Sẵn sàng và ranh giới
- **54%** (K-05 giữ, không tăng: thang đòi thao tác trên máy thử/Lead). Kịp 30/11: VÀNG. `production_accepted=false`, `deployable=false`. Chưa chạy: `oasdiff` (CI), gitleaks chế độ git, trivy ảnh, mọi thứ trên .99/.64.

## Quyết định đang hiệu lực
- D-m8-157, 160, 161, 162; D-m8-138 (số trần nhập trên màn hình); D-lead-063 (một checkout, khoá tệp); D-lead-064 (kiểm Thường/Nguy hiểm).
- Số W đã cấp tới W-0595; `work-register.md` đã ghi tới W-0595 (579 mục); `NEXT_WORK_ID` W-0596 (W-0584/W-0585 giữ cho dựng bank và bật thật ở .99).

## Nợ
- Nợ nhẹ N1…N10 (Vùng 3), N1…N10 (3b), N1…N8 (3c) ở [cong-nguy-hiem.md](cong-nguy-hiem.md); phần lớn đã giao W-0593/W-0594. Còn: N-12 báo động chưa đặt trần (m8.145 = C, chỉ checklist); đổi bank khi hồ sơ ≠ 1.00 thì vùng tạm về giọng cấu hình (N6 vùng 3b, vào runbook W-0584).
- Dirty không do phiên: `deploy/operations/m34_mock_agent.py` + test (chưa theo dõi).
