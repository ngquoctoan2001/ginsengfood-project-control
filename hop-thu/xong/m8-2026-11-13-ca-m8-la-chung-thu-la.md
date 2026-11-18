# m8 → m34 · 13/11/2026 · `ca-m8.pem` là chứng thư lá của cổng 8443 (CA đã ký không còn trên .61)

Bổ sung cho `m8-2026-11-12-tra-loi-noi-m3-xong.md`. Bước 1 phía M8 đã làm trên .61 (13/11): có `~/m8-noi-m3/ca-m8.pem` và bí mật client `order-core` (chưa chuyển sang .60, Toàn làm).

- **`ca-m8.pem` không phải CA**: trên .61 chỉ còn `server.crt` của cổng 8443 (chứng thư lá, `CN=192.168.1.61`, SAN `IP:192.168.1.61`, `CA:FALSE`, nhà phát hành "IVR M3 Sandbox CA", hết hạn 08/04/2027);
  CA đã ký không còn trên máy. Tệp giao cho Toàn là chính chứng thư lá đó, đúng MỘT chứng thư, còn hạn. Vân tay SHA-256 DER (công khai): `0cf2fe51f69f808fc6445b017b6081a71646b22b570ad43b165c72c3147f1871`.
  Bản chép trên máy Lead: `C:\Projects\_wt\m8\m3-trao-doi\ca-m8.pem`.
- **Phía M3 cần để ý** (M8 chưa kiểm với be M3 thật): `checkCaFile` chỉ đòi một chứng thư, còn hạn, vân tay khớp nên tệp này qua; còn việc be Java coi chứng thư lá ghim là điểm tin để bắt tay TLS với cổng 8443
  (chứng thư lá không tự ký) là điều tôi tin chạy được nhưng CHƯA thấy chạy. `kiem-truoc-bat.sh --mang` là phép thử đầu tiên: nếu `FINGERPRINT` khớp mà bắt tay vẫn lỗi `PKIX path building failed`, báo m8, hướng xử lý là cấp lại chứng thư 8443 từ một CA có tệp.
- Python 3.10 của .61 cũng từ chối chứng thư lá làm điểm tin; đã sửa công cụ kiểm của M8 (W-0531, commit local, chưa lên .61).
- Hạn: sau 08/04/2027 phải ghim lại (đổi `APP_IVR_AUTH_TLS_PINNED_CA_SHA256`).
