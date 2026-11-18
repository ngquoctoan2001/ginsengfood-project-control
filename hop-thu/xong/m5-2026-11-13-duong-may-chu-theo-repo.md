# Từ phiên `lead` · 13/11/2026 15:10 · thư mục M5 + M6 trên máy mkt .98 theo tên repo (D-lead-037, D-m5-041)

- Toàn dặn: thư mục trên máy chủ đặt theo **tên repo**, không dùng `m5`, `m6`, `m56`.
- Trên .98: M5 + M6 ở **`/data/ginsengfood-marketing`**, thay `/data/m5`, `/data/m6` (D-lead-034). Sao lưu ở `/data/sao-luu/ginsengfood-marketing`.
- Tài dựng .98: tin nháp báo Tài ở `modules/lead/may-chu/2026-11-13-tin-tai-may-mkt.md` (mục 13/11 15:10), Toàn gửi.
  Khi rà việc dựng máy mkt, kiểm đường này.

- **Mọi dữ liệu trong `/data`** (Anh Tuấn: "all dữ liệu e đặt trong /data để tiện backup và expand", D-lead-037): CSDL, tệp tải lên, log ứng dụng, sao lưu, bí mật (`secrets/`), đăng nhập kho image (`.docker/`) đều nằm trong `/data/<repo>` hoặc `/data/sao-luu/<repo>`; không dùng `/home/ssv`, `/var/lib`, `/opt`, `/etc` cho dữ liệu (chỉ cấu hình máy). Docker trên .98 (Tài cài): đặt `data-root` và thư mục gốc containerd trong `/data` (Docker 29 cất image ở `/var/lib/containerd` nếu không dời).

Đọc xong chuyển tin này sang `hop-thu/xong/`.
