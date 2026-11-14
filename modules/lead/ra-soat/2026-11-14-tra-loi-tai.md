# Trả lời Tài · 14/11/2026 08:12 · 6 câu sau 3 việc ngày 13/11 (M5-144, máy mkt .98, rà M6 lượt 3)

Toàn tự gửi, một tin chốt, không nhắn qua lại. Căn cứ đã kiểm:
- `gh api …/ginsengfood-contracts/collaborators/Nguyenphattai020904/permission` = `write` (Nguyễn Phát Tài) → Tài đã có quyền, review PR #2 được.
- M3 + M4 + M9 chạy trên .99 từ 14/11 07:36 (phiên phụ m34); M8 sang .99 07:46; M3 → M8 .99 đổi 07:58.
- Cổng vào D-lead-036 thay D-lead-028: nginx Anh Tuấn 443 trỏ `mkt.` về .98, không qua .60 (`chung/MAY_CHU.md`).
- Đường M4: `ChannelAdviseController` `@RequestMapping("/api/v1/m4/channel")` + `@PostMapping("/advise")` → `POST /api/v1/m4/channel/advise`.
- Gọi lại IVR: M8 gọi M3 qua cầu callback nội bộ (`M8_ALLOW_IP`), DNS công khai chưa trỏ về công ty → không bên ngoài nào gọi.
- `deploy/MODULE_DEPLOY_CONTRACT.md` ở repo `C:\Projects\deploy` (không có remote, sửa lần cuối 17/07, mẫu "gộp 1 server" cũ).

```text
@Tài anh trả lời gộp, em làm theo luôn nha:

0. Đổi thứ tự: dựng máy mkt .98 lên đầu. Go/No-go M4/M5/M6 chỉ họp được khi mkt. trên .98 có HTTPS, mà Anh Tuấn chỉ trỏ tên miền được khi em báo cổng M5, M6 trên máy đó. Hạn 20/11 không đổi. Sau đó mới tới hợp đồng với Phúc, M5-144 với stub, sổ M6.
1. Repo contracts: em có quyền ghi rồi (tài khoản Nguyenphattai020904). Vào review PR 2 luôn: https://github.com/sasamviet-ai/ginsengfood-contracts/pull/2, chốt với Phúc trước 17/11.
2. Go/No-go và chạy thật M5, M6 đều trên .98. Bản rà ghi .60 là bản cũ. mkt. đi thẳng từ nginx 443 của Anh Tuấn về .98, không qua .60 (bỏ hướng proxy trên .60 từ 13/11). Mốc họp: 2 ngày làm việc sau khi mkt. trên .98 có HTTPS, chậm nhất 20/11. Hồ sơ M6-125 em ghi theo đó.
3. HTTPS qua LAN: M3, M4 không còn ở .60, đã chuyển sang .99 từ 07:36 sáng nay. Em giữ luật HTTPS của M5 là đúng. Anh mở trên .99 một cửa TLS nội bộ: cổng riêng, chỉ cho .98, chỉ 2 đường GET /api/v1/internal/orders/by-code/{mã}/channel-state và POST /api/v1/m4/channel/advise, chứng thư nội bộ theo IP 192.168.1.99. Xong anh gửi em cổng và file CA để M5 ghim. Trong lúc chờ em làm với stub. Việc này phía anh, không cần Anh Tuấn.
4. Đường IVR callback: không có bên ngoài nào gọi. M8 gọi về M3 qua cầu nội bộ trên .99, tên miền cũng chưa trỏ ra ngoài. Anh không chặn cả /api/v1/internal/, chỉ khoá riêng đường by-code cho .98; các đường internal cũ anh tự xử ở cửa công khai. Em không cần làm gì phần này.
5. MODULE_DEPLOY_CONTRACT.md nằm ở repo deploy chung trên máy anh, không có trên GitHub, mà bản đó cũ (tháng 7). Em đừng tạo mới. Em ghi bảng gọi ra/gọi vào của M5, M6 (đường, máy, cổng, ai gọi) vào tài liệu triển khai sẵn có trong module5/deploy/ rồi gửi anh link.
6. DECISION_LOG M6 và tag m6-l1-done ở d7fe04e: ok.
```
