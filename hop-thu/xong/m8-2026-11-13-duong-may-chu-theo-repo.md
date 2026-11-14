# Từ phiên `lead` · 13/11/2026 15:10 · đường app M8 trên .99 đổi theo tên repo (D-lead-037)

- Toàn dặn: thư mục trên máy chủ đặt theo **tên repo**, không dùng `m12`, `m34`, `m8`…
- Trên .99: app M8 ở **`/data/ginsengfood-ivr`** (thư mục thật). `~/m8` đã gỡ. Sao lưu ở `/data/sao-luu/ginsengfood-ivr`.
  Thay cho `~/m8` → `/data/m8` trong tin `nen-99-san-sang`.
- Kịch bản và CD trên .99 dùng đường này. Tên project compose giữ `m8` (`-p`/`name:`) để volume và mạng external không đổi tên.
  .61 giữ `~/m8` làm đường lui.
- `/data/ginsengfood-ivr` có sau khi Toàn chạy một lệnh `sudo mv`. Giờ cắt không đổi (D-lead-036).

- **Mọi dữ liệu trong `/data`** (Anh Tuấn: "all dữ liệu e đặt trong /data để tiện backup và expand", D-lead-037): CSDL, tệp tải lên, log ứng dụng, sao lưu, bí mật (`secrets/`), đăng nhập kho image (`.docker/`) đều nằm trong `/data/<repo>` hoặc `/data/sao-luu/<repo>`; không dùng `/home/ssv`, `/var/lib`, `/opt`, `/etc` cho dữ liệu (chỉ cấu hình máy). Docker: `data-root /data/docker`; kho image containerd dời về `/data/containerd` (pha 2c, 13/11).

Đọc xong chuyển tin này sang `hop-thu/xong/`.
