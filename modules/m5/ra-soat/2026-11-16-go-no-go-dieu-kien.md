# Điều kiện Go/No-go M5 — bảng theo dõi tới họp ≤ 20/11/2026

Lập 16/11/2026 (phiên `m5`, kế hoạch tuần D-lead-048). Nguồn: hồ sơ M5-114 bản 0.5 `module5/docs/04-sdlc/GO_NO_GO_2026-11-13.md` @`2eef3dab`
(mục 3 Done Gate, mục 5 việc còn thiếu), Sheet M5 16/11 09:42, sổ Tài `M4-PLAN` @`c920f0c` (`BAN_GIAO_DOI_ACCOUNT_2026-11-16.md`), quyết định D-m5-018…043.
Họp: 2 ngày làm việc sau khi `mkt.` có HTTPS (D-m5-028/035/040), chậm nhất **thứ Sáu 20/11** → HTTPS phải có **trước hết thứ Tư 18/11**.
Hạn chạy thật 30/11 giữ (D-lead-025). Người lập bằng chứng: Tài (DL-088); người quyết: Toàn.

## 1. Done Gate (pilot một Page, chế độ phạm vi, khoá production tắt)

| # | Điều kiện | Task | Hiện trạng 16/11 | Ai | Cần xong |
|---|---|---|---|---|---|
| 1 | `mkt.ginsengfood.vn` có HTTPS qua proxy Caddy trên .98 (D-m5-051), chỉ chuyển `/api/admin/ads/` → .98:6600, `/admin/`, `/api/admin/`, `/api/channel/meta/` → .98:3000, còn lại 404 (D-m5-048) | — | **ĐẠT 17/11 ~16:3x** (phiên lead; chứng chỉ Sectigo wildcard tới 03/06/2027). Phiên m5 kiểm 16:38: `/` 301 → `/admin/`, `/api/admin/ads/dashboard` 401, `/health` 404, route admin cũ 404, `GET /api/channel/meta/webhook` không token 403. Còn: cổng 80 công khai lỗi (http ra 400), không chặn Meta — `modules/lead/may-chu/2026-11-17-ke-hoach-ten-mien-public.md` | phiên lead | xong |
| 2 | Bản ứng viên chạy trên .98, khoá production tắt, thư mục `/data/ginsengfood-marketing`, khai SHA đang chạy | M5-091, M5-093 | Dữ liệu đã dời sang `/data/ginsengfood-marketing` 17/11 (sổ Tài, bản cũ `/data/m5` còn). **M5 lên `aa6d55d4` 18/11 07:54** (Tài báo; có C6, 3 tin rác không thêm dòng DB). M6 chờ M6-159. Còn: khai SHA trong sổ, kiểm độc lập | Tài | 18/11 |
| 3 | Webhook Page pilot đăng ký trên `mkt.`, token Page thật | M5-053, M5-100 | Webhook `mkt.` **Meta xác minh đạt 18/11** (chỉ `feed`), sự kiện thử qua kiểm chữ ký, URL xoá dữ liệu đã lưu (Tài báo). App còn chế độ phát triển (chỉ sự kiện thử) vì thiếu URL chính sách. Còn: gắn Page pilot + token System User 60 ngày, phát hành app | Tài | 19/11 |
| 4 | Sink CSKH + sink cảnh báo thật; khởi động từ chối khi sink giả (D-m5-021) | M5-104, M5-081B | Mã sink Telegram đã gộp (#145), chưa có bot/nhóm. **Toàn chọn Telegram 18/11** (D-m5-066, một bot hai nhóm). Thiếu thì M5 **không khởi động** ở chế độ phạm vi | Tài | 18/11 |
| 5 | SMK-001–016 trên .98 (DL-130) | M5-110, M5-084 | `NOT_RUN`. DL-230 Toàn duyệt 16/11 20:37 (D-m5-049): luồng P0 chạy thật ở chế độ phạm vi; ngoài phạm vi = 6 port giả + bộ ẩn bình luận + `AI_ADVISOR`, `SPOTLIGHT_SINK`, 3 nguồn suppression (SMK-009–013 chỉ chứng minh luồng); SMK-008/014 ghi ngoài phạm vi; sink CSKH, cảnh báo, `CSKH_SINK` rate-moderation phải thật. Còn: Tài ký DL-230, task code roll-up | Tài | ký + task code 18/11, SMK 19/11 |
| 6 | UAT nội bộ ≥ 10 kịch bản, có biên bản; người thử ký đồng ý | M5-111 | `NOT_RUN`; PILOT_READINESS §5, §7 còn ô `[ĐIỀN]` (giờ pilot, bảng trực, KPI) | Tài | 19/11 |
| 7 | Rà bảo mật: lỗi Cao sửa xong; thêm theo D-m5-050 (vì `/api/admin/`, `/api/channel/meta/` ra Internet): gỡ 2 route admin cũ trước HTTPS, T4 chữ ký webhook sai không làm DB tăng theo số lần gửi, T6 mỗi người một JWT hạn ngắn + bước thu hồi khẩn | M5-112 (H1 = M5-126, H2 = M5-140) | Route cũ gỡ (#131); T4 (#149, lên .98 18/11 07:54, Tài tự kiểm 3 tin rác); H1 M5-126 gộp (#140, #148); H2 M5-140 (#136); C7 tuổi token 8 giờ + thu hồi (#150). T6 phía phát: đăng nhập bằng mã gửi mail (D-m5-065, phiên m5 code), tạm phát tay. Chưa rà độc lập | Tài, phiên m5 (T6) | 19/11 |
| 8 | Sao lưu RPO 15 phút + diễn tập khôi phục ≤ 2 giờ (DL-116) | M5-092 | Chưa bắt đầu; Sheet hạn 26/11 (sau họp) → kéo về trước họp, tối thiểu diễn tập một lần trên .98 | Tài | 19/11 |
| 9 | Pháp chế đợt 1 (dữ liệu khách + chữ công khai) có văn bản (D-m5-037) | M5-103 | Chưa gửi | Tài | 19/11 |
| 10 | Trang chính sách + trang công khai ở `https://mkt.ginsengfood.vn/policy/` (D-m5-064), một trang chung Facebook + YouTube (D-m5-058) | M5-101 | Toàn duyệt chữ phần mình 18/11 (D-m5-062); chờ tuyến `/policy/` (phiên lead) + Tài đặt HTML | Tài, phiên lead | 18/11 |
| 11 | Meta: App Review nộp sau mục 1 + 3 + 10; chưa duyệt thì pilot chỉ người có vai trò (D-m5-018) | M5-102 | Chưa nộp. 7 quyền đang ở mức chuẩn ("Sẵn sàng thử nghiệm"); Advanced Access cần video từng quyền. Toàn đồng ý 18/11 (D-m5-063): có URL chính sách → phát hành app, Page pilot + token thật, nộp song song; trước họp chỉ người có vai trò | Tài | 19/11 |
| 12 | Không lộ giá/PII: DL-225 ký (M5-060), 124, 126 | M5-060, 126 | DL-225 chờ Tài ký; 126 như mục 7 | Tài | 19/11 |
| 13 | Xoá dữ liệu theo người chạy được trên .98 (quyền `audit_log`, DL-217) | M5-135, M5-141 | Tester M5-141 dừng chờ Tài; DL-217 chưa ký | Tài | 19/11 |
| 14 | Khoá JWT công khai cho UI + CLI cờ dừng ≤ 5 giây (DL-115) | M5-016 | Kiểm `iat` (#142) + tuổi/thu hồi (#150) đã gộp. Đăng nhập bằng mã gửi mail @ssavigroup.com, M5 tự ký JWT bằng khoá trên .98 (D-m5-065, thay D-m5-052); M6 dùng chung (D-m5-045). Tạm phát tay | phiên m5 code, Tài đặt khoá + cấu hình .98 | 19/11 |
| 15 | Tài liệu khớp mã | M5-121 | Cần sửa | Tài | 19/11 |
| 16 | Hồ sơ bản 0.6 theo `main` mới, Tài ký bằng chứng, Toàn quyết | M5-114 | Bản 0.5 (12/11), chờ 0.6 | Tài → Toàn | 19/11 |

## 2. Không chặn Go pilot (ghi để khỏi nhầm)

- AI trả lời tin riêng (D-m5-034): pilot Go được với `AI_ADVISOR_MODE` trống; bật AI cần pháp chế đợt 2 + NCC A1–A6 + P0 M4 + câu M5-101 khai AI.
- Báo giá/nháp đơn chặn suốt pilot (D-m5-039) — kiểm cờ theo Page tắt trên .98 trong SMK.
- `ORDER_STATE_READER` thật (M5-144 + M3-181): cần cho production 30/11 (D-m5-036), pilot chạy chế độ phạm vi. Cửa TLS 8446 trên .99 cần cho M5-144 nối thật.
- M5-123 đăng bài nhiều Page: ngoài Go/No-go (D-m5-012).

## 3. Đánh giá thật

Ở 16/11, **0/16 mục có bằng chứng chạy thật trên .98**; mục 1 do Anh Tuấn, mục 4–9 là việc Tài chưa bắt đầu hoặc đang FAIL.
Nếu HTTPS có 18/11 thì 19–20/11 chỉ còn 2 ngày cho SMK, UAT, sao lưu, App Review. Dự báo hiện tại: **họp 20/11 nhiều khả năng No-go lượt 2**,
trừ khi Tài làm song song mục 4, 7, 8, 12, 13 ngay từ 16/11 (không cần HTTPS). Đường găng: mục 4 (không có sink thật thì M5 không khởi động
ở chế độ phạm vi) → mục 5 (DL-230 đã duyệt 16/11, D-m5-049; còn task code roll-up) → mục 6.
