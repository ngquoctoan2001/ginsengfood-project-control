# Từ phiên `lead` · 13/11/2026 15:10 · đường M1–M2 trên .99 đổi theo tên repo (D-lead-037)

- Toàn dặn: thư mục trên máy chủ đặt theo **tên repo**, không dùng `m12`, `m34`, `m56`…
- Trên .99: M1–M2 ở **`/data/ginsengfood-ops-core`** (thư mục thật). `~/m12` đã gỡ, nhà `ssv` không có liên kết.
  Sao lưu ở `/data/sao-luu/ginsengfood-ops-core`. Thay cho `~/m12` → `/data/m12` trong tin `nen-99-san-sang`.
- Kịch bản và CD trên .99 dùng đường này: `trien-khai.sh`, `cd-entry.sh` (`command="/data/ginsengfood-ops-core/cd-entry.sh"`), tác vụ kéo sao lưu.
  Tên project compose giữ `m12` (`-p`/`name:`). .61 giữ `~/m12` làm đường lui.
- `/data/ginsengfood-ops-core` có sau khi Toàn chạy một lệnh `sudo mv`. Giờ cắt không đổi (D-lead-036).

- **Mọi dữ liệu trong `/data`** (Anh Tuấn: "all dữ liệu e đặt trong /data để tiện backup và expand", D-lead-037): CSDL, tệp tải lên, log ứng dụng, sao lưu, bí mật (`secrets/`), đăng nhập kho image (`.docker/`) đều nằm trong `/data/<repo>` hoặc `/data/sao-luu/<repo>`; không dùng `/home/ssv`, `/var/lib`, `/opt`, `/etc` cho dữ liệu (chỉ cấu hình máy). Docker: `data-root /data/docker`; kho image containerd dời về `/data/containerd` (pha 2c, 13/11).

Đọc xong chuyển tin này sang `hop-thu/xong/`.
