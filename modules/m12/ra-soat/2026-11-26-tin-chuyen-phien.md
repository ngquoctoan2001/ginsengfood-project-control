# Tin chuyển phiên m12 sang account khác (26/11/2026 ~00:45)

Dán nguyên khối dưới đây vào phiên mới mở tại `C:\Projects\Project Control`. Không có bí mật trong tệp này.

---

/phien m12

Bạn tiếp nối phiên m12 `M1-2` (M1–M2 Operational Core) của Lead Nguyễn Quốc Toàn, đang làm dở lúc 26/11/2026 ~00:45. Trả lời tiếng Việt, gọi Toàn là "bạn"; trong tệp viết "Toàn", "Anh Tuấn". Đọc trước: `modules/m12/TRANG_THAI.md`, `nhat-ky/2026-11-26.md` và `2026-11-25.md`, `QUYET_DINH.md` (D-m12-130…139), `ra-soat/2026-11-25-34-viec-noi-m3-con-lai.md`, `ra-soat/2026-11-26-tin-chuyen-phien.md` (tệp này), `wp/M12-UAT-468-ca.md`.

LUẬT CỨNG
- Project Control là repo CÔNG KHAI: không ghi bí mật, số điện thoại, dữ liệu khách vào sổ. Không đọc/in `.env*`, khoá, token, mật khẩu, `tools/task-tracker/sheet.json` (Sheet chỉ qua `node tools/task-tracker/sheet-sync.mjs` ở ops-core).
- Push, ssh/ghi lên `.99`, đổi cờ production, sửa `.env`, bật quên-mật-khẩu: CHỈ khi Toàn nói rõ đúng việc đó; lời đồng ý không chuyển sang việc khác. Không bao giờ nối `git push` vào lệnh commit.
- Một checkout, không worktree (D-lead-063): khai khoá `python "C:\Projects\Project Control\tools\khoa_tep.py" khai --repo ops-core --chu <tên> --tep <đường dẫn>` / `giai` / `xem`; khoá đặc biệt `@bo-kiem-du` (bộ test có DB), `@dot-bien`, `@dong-bo`. Chỉ phiên chính commit, theo đường dẫn (`git commit -m … -- <đường dẫn>`, tệp mới `git add -- <đúng đường dẫn>` trước). Cấm `add -A`, `add .`, `commit -a`, stash, reset, clean, rebase. Commit kết thúc bằng dòng ghi công mà hệ thống nêu.
- Kiểm hai mức (D-lead-064): Thường = test lọc + phiên chính đọc diff; Nguy hiểm (tiền, đăng nhập/phân quyền, xoá/migration dữ liệu thật, gọi khách thật) = verifier độc lập. CI không chạy khi push; lên `.99` không qua CI.
- Tin Toàn gửi người khác: ngắn, giọng miền Tây, không dán đường dẫn/SHA/code.
- Cuối MỖI câu trả lời có đúng một câu dòng trạng thái (việc nối M3 xong bao nhiêu, bản vá, ca nghiệm thu, cái gì chặn).

TRẠNG THÁI
- ops-core (`C:\Projects\ginsengfood-ops-core`, nhánh `main`): HEAD `d4163331c`; `origin`/`gitlab` đang ở `7c7d07234`. Hai commit CHƯA push: `973225ac4` (SOP kho giữ hàng M3 + sửa số cũ ở runbook) và `d4163331c` (vá lỗi giờ `+07:00`: entity hộp sự kiện nhu cầu + lưới `UtcInstantCommandInterceptor` ở `AppDbContext.OnConfiguring`; test xanh: unit 10.766, Governance 1130, ApiContract mới 20, Integration lát 87; 4 ca IT T91/T92/T110/T111 chạy lại ĐẠT). Dirty không phải của ta: 3 tệp supplier-portal admin-web.
- `.99`: M1–M2 chạy `7c7d07234` (Development, từ 25/11 21:08), CHƯA có bản vá offset. Đường lui `trien-khai.sh a0ccc740e16f3cf97e351190c1b34becfdc0cd28` (thư mục `/data/ginsengfood-ops-core`). Khoá mã hoá bằng chứng đã đặt (D-m12-139; Toàn tự cất bản sao). Quên mật khẩu TẮT, đăng nhập mail BẬT. 19 SKU, 0 kích hoạt bán, 0 mẻ, 0 giữ hàng. M3 (`m34-be-1`) gọi M12 qua `http://192.168.1.99:5000` sạch 24 giờ (0 lỗi 401/403/429).
- Đưa bản mới lên `.99` = dựng 5 ảnh theo đúng commit (`git archive` + `docker build`; script ở `modules/m12/ra-soat/build_m12_images_sha.sh`), `docker save | ssh ssv@192.168.1.99 docker load`, rồi `trien-khai.sh <sha>`. CHỈ khi Toàn ra lệnh.
- Gói chuyển Production `deploy/m12/chuyen-production-99/` (P0–P7, `lui.sh`, qua 3 lượt verifier): P0 đã chạy chỉ đọc; P1–P7 CHƯA chạy, chờ lệnh riêng của Toàn (~28/11).
- Sổ nghiệm thu: 2.326 bước = 1.810 đạt · 0 không đạt · 59 không áp dụng · 457 chưa chạy. 457 ca là ca GIAO DIỆN, cần phiên CÓ Chrome (phiên cũ không có). 25 lô L01–L25 ở `wp/M12-UAT-468-ca.md`; bỏ 11 mã O07-F06 đã chạy.
- Sheet (tab M1-M2): 123 việc, 60 xong, 63 chưa xong; trong 63 có 32 việc nối M3 (4 nhóm chặn ở `ra-soat/2026-11-25-34-viec-noi-m3-con-lai.md`). Số "36/98" ghi trong dòng trạng thái cũ là SAI (đếm thiếu 25 việc mã M12-105 trở lên và lệch số xong): dùng số này.
- Mốc: nghiệm thu + tập huấn 27/11 (mẻ THẬT đầu tiên, m12.203 = A) · chuyển Production 28/11 · chạy thật 30/11 · ngoại lệ JWT hết 30/11 16:59Z.

CHỜ TOÀN QUYẾT (không tự làm)
- m12.243: push 2 commit; đưa bản vá lên `.99` Development (hai việc riêng, mỗi việc Toàn phải nói rõ).
- m12.240 (giữ đường M3→M12 qua IP máy, đề xuất A), m12.241 (cắt SKU-M12-08, A), m12.242 (tác vụ giám sát 15 phút trên máy Toàn, A, cần "go" rõ mới tạo lịch).
- Chuyển Production: Toàn duyệt SHA + 2 băm của gói (compose `1df348da…1a550`, Caddyfile `3639671f…f7a3c`, theo gói ở `7c7d07234`), xác nhận khoá JWT mới ≠ khoá lịch sử, báo Phúc M3 gián đoạn 1–2 phút, chạy trong tmux; P0 sẽ vẫn báo 1 tệp bằng chứng bản rõ (ảnh thử 20/11) → chuyển thư mục `evidence` đi lúc chuyển.
- Toàn tự chuẩn bị tối 26/11: ca, vị trí kho, nhà cung cấp + vật tư thật, kích hoạt bán 1 SKU, nội dung công khai đã duyệt, ghép điện thoại Sang (`wp/M12-010-bo-sang-27-11.md` §1).
- Còn lại: m12.204, m12.109/115/116, m12.207, go/no-go NK-b, DIET-2, QD-RS, SEC-11, token GitLab cho CI đêm, đính chính Phúc về kho, đổi tên hiển thị hai kho.

VIỆC KẾ TIẾP CỦA PHIÊN MỚI
1. Trình Toàn các quyết định trên theo thứ tự hạn (m12.243 và chuẩn bị 27/11 trước).
2. Chuẩn bị buổi 27/11 (kịch bản, tập vai); sau mẻ thật chạy NM3-45b (S01–S18 trên `.99`).
3. Dọn Sheet: sửa số UAT cũ (M12-009 "958 ca", M12-105 "603 ca" → còn 457 ca giao diện), đóng/gộp việc đã được thay thế.
4. Khi có Chrome: phát lô L01–L25 cho tester.
5. Chuẩn bị chuyển Production 28/11 theo gói, khi Toàn ra lệnh.
