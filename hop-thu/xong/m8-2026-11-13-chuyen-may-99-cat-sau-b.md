# m8 phụ (chuyển app M8 sang .99) → phiên m8 chính · 13/11/2026 22:1x · M8 cắt ngay sau pha B của m34

- Toàn chốt 22:0x: M8 cắt ngay sau pha B của m34, không chờ pha C/D (cổng vào tên miền không dính M8).
- Việc của phiên chính trong tin `hop-thu/m8-2026-11-13-m3-sang-99-cau-callback.md` và tin m34 16:20 **phiên phụ làm thay,
  phiên chính đừng làm**:
  1. 8443 .61 thêm nguồn .99: bỏ (từ B6 tới hết pha b của M8, đơn M3 → M8 lỗi nhận, tin nhóm đã báo).
  2. Gốc callback worker .61 → `https://192.168.1.99:8445`: kịch bản `C:\Projects\_wt\m8\chuyen-may-99\doi-callback-99.sh`
     (qua `ssh … ssv@192.168.1.61 bash -s <`; thử cầu .99:8445 bằng CA cầu đang tin, `tron_cau_hinh.py --m3-goc`, chỉ cho đổi đúng
     `Ivr:CallbackDelivery:TargetBaseUrl`, rồi `dat-cau-hinh.sh --thu` + lượt thật). Thử trên máy Lead với tệp giả: 4 ca đạt,
     đột biến khoá thứ hai bị bắt. Pha b mang gốc mới sang .99.
- Thứ tự sau "B6 XONG": 4b đổi callback → Toàn nhắn nhóm → `chuyen.sh b --khuon c80528db` → m34 đổi `M8_ORIGIN`/Issuer/CA,
  `allow --ip`, `M8_ALLOW_IP` → một đơn MOCK trọn vòng → `sao-luu`. Phiếu: `modules/m8/wp/chuyen-may-99.md`.
- Máy Lead 21:5x: ổ C: hết chỗ (0 GB), Docker Desktop treo (API 500), runner CI (chạy trên máy này) không chạy được hai job
  Retry của `eca6670f`. Phiên phụ xoá bản sao `_wt/m8/khoa-goi` của mình (~6,5 GB); 22:1x còn ~19,8 GB. Docker Desktop vẫn
  treo, cần khởi động lại; `_wt` chiếm ~108 GB, `docker_data.vhdx` 125 GB — dọn sau đêm cắt.
