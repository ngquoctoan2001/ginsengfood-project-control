# Trạng thái — m8

Mốc: **27/11/2026 19:4x** (đồng hồ máy) · phiên m8 · `/ke-hoach` dựng lại [SAN_SANG.md](SAN_SANG.md) tới 30/11 (3 scout chỉ đọc + đọc .99). Bản 26/11: git history; danh sách việc chi tiết vẫn ở [KE_HOACH.md](KE_HOACH.md) §3.

## Máy thật (đọc 27/11 19:27, chỉ đọc)
- `ginsengfood-ivr`: `main` = GitLab = GitHub `169a6859` (27/11 17:39, runbook .99). Trước đó 27/11: `09fb5a2b` (agent MOCK m34), `e7ce8510` (ghim gói Asterisk + gitleaks giả), `75aa3a9c` (sửa định dạng C#). Không do phiên này push.
- **.99 chạy M8 `75aa3a9c`** (triển khai 27/11 04:08Z, 52 migration, cái cuối `W0586RegionProvinces`): có giọng/tốc độ, tỉnh–vùng, draft.51, luật gọi L-05/L-07/L-11. Lịch TẮT, `REAL_CUSTOMER_CALL_ALLOWED=NO`, `ASPNETCORE_ENVIRONMENT=SandboxM3`, 0 task trong 7 ngày, 5 callback chết cũ, 0 cuộc dở; sao lưu đêm còn chạy (bản 27/11 02:30).
- M3 .99: be `4e5d26ae` (27/11 19:15, phiên m34 ngoại lệ một lần D-m34-120; lần sau chỉ Phúc), ghim draft.51 `abf1d485…61fd` khớp M8; đã có `IvrDialEvidenceQueryAdapter` đọc `dial_evidence` mà M8 chưa trả.
- .64: Asterisk 22.11.0 từ 20/11; chưa RTP, chưa CDR; chứng thư lá ARI hết hạn 13/01/2027.

## Sẵn sàng
- **54%** (không đổi). Kịp 30/11 gọi khách thật: **ĐỎ** (0 cuộc qua worker + trunk, MobiFone chưa hẹn, pháp lý giọng chưa ký). Bản tối thiểu MOCK 30/11: **VÀNG**. Sóng 1–2 đạt hết ⇒ 70%.
- `production_accepted=false`, `deployable=false`.

## Kiểm
- Bộ đủ lần hai `cebf9d1c` 26/11: unit 3235/3235, integration 1781/1781, contract 46, media 14, chaos 8, python 458 OK. Sau đó 3 commit (định dạng C#, ghim gói, tài liệu): bộ đủ CHƯA CHẠY lại.
- **CHƯA CHẠY:** mọi ca trên bản `75aa3a9c` (ca E gần nhất trên ảnh `10f335de` 14/11 và E07/E08 17/11), oasdiff draft.50→51, gitleaks chế độ git, trivy ảnh `75aa3a9c`, gate-sweep lần hai, bank 9 cặp, làm nóng cụm, nghe tốc độ 0.80/1.20.

## Gói việc tới 30/11 (chi tiết [SAN_SANG.md](SAN_SANG.md))
- Làn máy (phiên chính, Toàn duyệt): **K99** kiểm sau lên + cấu hình bắt buộc + trần → **E99** chạy lại bộ ca MOCK, Toàn tự đặt 2 đơn → **L10** luật gọi với M3 (Phúc bật cờ) → **GIONG99** bank + làm nóng + bật giọng, Toàn nghe → **VH** quay lui, khôi phục, tắt khẩn. **H64** bảo trì .64 tối 28/11 22:30.
- Làn code: **DE** `dial_evidence` + draft.52 (cổng Nguy hiểm, báo m34 ghim). Làn sổ: **QUET**, **07F**.
- Chặn ngoài: **01D**, **08** phần nhà mạng, **02F** (X-01 MobiFone, X-03, X-07).

## CẦN TOÀN
- **Đã chốt 27/11 19:4x ("ok 155-159"):** D-m8-163 chuỗi K99 + E99 trên .99 từ 08:30 28/11 (Toàn đặt 2 đơn); D-m8-164 `dial_evidence` làm ngay (W-0596); D-m8-165 bật giọng mới trên .99 coi là máy thử; D-m8-166 bảo trì .64 28/11 22:30; D-m8-167 30/11 = bản MOCK, gọi thật là mốc riêng.
- Việc ngoài: X-01 hẹn MobiFone; nhắn Phúc bật `M8_RULES` + quyền (29/11); báo Anh Tuấn khung .64; X-04 kênh cảnh báo; X-05 xoay token Sheet, đổi mật khẩu đã lộ, khoá CA (m8.126); X-07 số nội bộ.
- Câu cũ còn mở (giữ mặc định KE_HOACH §6): m8.124–126, m8.138–140, m8.142–144.

## Quyết định đang hiệu lực
- D-m8-157, 160, 161, 162; D-m8-138; D-m8-150 (bỏ chờ CI, dựng ảnh rồi kéo lên .99); D-lead-060 (lên .99 phía M3 chỉ Phúc), D-lead-063 (một checkout, khoá tệp), D-lead-064 (kiểm Thường/Nguy hiểm), D-lead-065 (.99 làm máy thử tới khi Anh Tuấn bàn giao máy thử).
- Số W: `NEXT_WORK_ID` W-0596 (W-0584/W-0585 giữ cho bank và bật giọng trên .99).

## Nợ và sổ
- Nợ nhẹ ở [cong-nguy-hiem.md](cong-nguy-hiem.md); N-12 báo động chưa đặt trần (m8.145 = C, chỉ checklist).
- Sổ lệch đã biết: tracker lead L-08/L-09 còn "CHƯA LÀM" (đã push + đã lên .99); hồ sơ phát hành nay 579 work item (EVIDENCE_SUBMITTED 218). Sửa ở gói 07F.
- Hộp thư chưa xử lý: [m8-2026-11-27-m3-dial-evidence.md](../../hop-thu/m8-2026-11-27-m3-dial-evidence.md) (gói DE).
- Dirty không do phiên trong repo ivr: không còn (`m34_mock_agent*` đã vào `09fb5a2b`).
