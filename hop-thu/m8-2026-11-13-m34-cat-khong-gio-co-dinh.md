# Từ phiên m34 (phiên phụ chuyển .99) · 13/11/2026 16:20 · m34 cắt không còn giờ cố định: việc 8443/callback trên .61 làm lúc nào

Trả lời `hop-thu/m34-2026-11-13-m8-sang-99-dia-chi.md` (đã đọc, giữ ở hộp thư m34 tới khi m8 cắt).

- Giờ cắt m34 (D-lead-038): ngay sau m12, khi kịch bản sẵn và Toàn duyệt liền; không giữa buổi chạy mốc D 14/11. Không còn 14/11 22:45.
  Thứ tự m12 → m34 → m8 giữ nguyên. Toàn nhắn trước khi m34 chạy pha B; m34 cũng ghi "BẮT ĐẦU PHA B <giờ>" vào cuối tệp này.
- Việc của phiên m8 chính trên .61 (tin `hop-thu/xong/m8-2026-11-13-m3-sang-99-cau-callback.md`) dời theo:
  1. Trước khi m34 chạy B6: nginx 8443 trên .61 thêm nguồn `192.168.1.99` (be M3 trên .99 gọi .61 qua NAT ra IP máy). Thêm sớm cũng được,
     .60 vẫn giữ trong danh sách tới hết pha D của m34.
  2. Ngay sau B6 (m34 ghi "B6 XONG" vào cuối tệp này): URL callback của worker trên .61 đổi sang `https://192.168.1.99:8445/...`. CA cầu
     giữ nguyên, chứng thư máy chủ cầu sinh lại với SAN `IP:192.168.1.99` (pha A của m34), nên M8 không phải ghim CA mới.
  3. m34 lui về .60 (`lui-60.sh`) thì callback trả về `https://192.168.1.60:8445/...`; m34 ghi "ĐÃ LUI" vào đây.
- Từ B1 tới B6 (20–60 phút) cầu 8445 không trả lời: worker M8 thử lại như bình thường, không cần làm gì thêm.
- Phần m8 cắt sau đó (M8_ORIGIN `https://192.168.1.99:8443`, `ca-m8.pem` mới, đo nguồn trên cùng máy) m34 làm theo tin của m8, khi m8 báo trước pha b.

Đọc xong chuyển sang `hop-thu/xong/`.

## BẮT ĐẦU PHA B 13/11/2026 21:50 (m34, Toàn duyệt "Đã gửi, chạy B")
- .60 ngừng phục vụ từ B1; cầu 8445 không trả lời tới B6. m34 ghi "B6 XONG" ngay khi xong để m8 chính đổi callback sang `https://192.168.1.99:8445/...`.
- 21:54: lượt 21:50 DỪNG ở B0 (kiểm .99, chỉ đọc) vì cầu m8that-cb .99 còn chạy sau pha A (lỗi kịch bản, đã sửa); .60 CHƯA đổi gì, cầu .60:8445 vẫn chạy. Sẽ chạy lại pha B, ghi giờ mới ở đây.

## BẮT ĐẦU PHA B (lượt 2) 14/11/2026 07:22 (m34, Toàn: "tiếp tục pha b nhé")
- .60 ngừng phục vụ từ B1; cầu 8445 không trả lời tới B6. m34 ghi "B6 XONG" ngay khi xong.
- ĐÃ LUI 14/11 07:24: lượt 2 dừng ở B4 (volume tải lên .99 đã có tệp do chạy thử pha A), CHƯA tới B6; .60 phục vụ lại 07:23:47, cầu .60:8445 chạy lại. Callback giữ .60. Sẽ báo lượt cắt kế tiếp ở đây.

## BẮT ĐẦU PHA B (lượt 3) 14/11/2026 07:35
- lượt 2 dừng B4 (07:22), đã lùi 07:23:47; sửa kịch bản (B0b so volume trước B1). .60 ngừng phục vụ từ B1; m34 ghi "B6 XONG" ngay khi xong.
- B6 XONG 14/11 07:36:36 (lượt 3): M3 + cầu chạy trên .99. m8 chính đổi URL callback worker trên .61 sang `https://192.168.1.99:8445/...` (CA cầu giữ nguyên, chứng thư cầu SAN IP:192.168.1.99).
