# Test chat M4 trên https://ginsengfood.vn (25/11/2026) — bằng chứng để gửi Tài

Toàn bảo test vì chat trả lời "ngu". Phiên m34 mở trang bằng trình duyệt trong app (Chrome chưa nối), không đăng nhập, không nhập thông tin cá nhân, không đặt hàng. 9 câu, `POST /api/v1/ai/advisor/chat` đều trả 200. Mã yêu cầu để Tài tìm log: cột `requestId`.

| # | Câu hỏi (phiên) | Kết quả | `status` / `sellableStatus` | `requestId` |
|---|---|---|---|---|
| 1 | "Bên em có những loại cháo nào, giá bao nhiêu vậy?" (phiên 1, câu đầu) | Từ chối cụt: "chưa thể xác nhận tồn kho, giá cuối hoặc chốt mua trực tiếp trong khung chat"; không liệt kê món, không thẻ sản phẩm | `HANDOFF_REQUIRED` / `BLOCKED` | `chat-req-1795580955619-zcr4r7` |
| 2 | "Mẹ mình 70 tuổi, buổi sáng ăn không nhiều, có món nào nhẹ bụng dễ ăn không?" | Trả lời được, 4 món + 4 thẻ. **Lỗi: gọi khách là "Minh" ("mẹ Minh", "để Minh dễ so sánh") vì đọc chữ "mình" thành tên người** | `ANSWERED` / `SELLABLE` | `chat-req-1795580983496-jn4gix` |
| 3 | "Món gà ác đó có giá bao nhiêu em?" | Đúng: thẻ Cháo Sâm – Gà ác, `basePrice` 96.800, có nút thêm giỏ. Chữ trả lời không nêu số, chỉ "giá em để ở thẻ bên dưới" | `ANSWERED` / `SELLABLE` | `chat-req-1795581010982-lixq4r` |
| 4 | "Ba mình bị tiểu đường ăn cháo sâm được không?" | "Trường hợp này hơi nhạy cảm… để CSKH hỗ trợ" (chặn sức khỏe, đúng luật) | `HANDOFF_REQUIRED` / `BLOCKED` | `chat-req-1795581019102-13p8pv` |
| 5 | "Ship về Bến Tre mất mấy ngày vậy?" (ngay sau câu 4) | **Lỗi: vẫn "hơi nhạy cảm"** dù là câu giao hàng | `HANDOFF_REQUIRED` / `BLOCKED` | `chat-req-1795581027200-ia3mn8` |
| 6 | "Giao hàng về Bến Tre bao lâu thì tới?" (cùng phiên, sau câu 4) | **Lỗi: vẫn "hơi nhạy cảm"** | `HANDOFF_REQUIRED` / `BLOCKED` | `chat-req-1795581047720-b1mv09` |
| 7 | "Cho mình hỏi giờ vàng là gì vậy?" (cùng phiên, sau câu 4) | **Lỗi: vẫn "hơi nhạy cảm"** | `HANDOFF_REQUIRED` / `BLOCKED` | `chat-req-1795581055848-bwama1` |
| 8 | Câu 6 hỏi lại, phiên MỚI (đã bấm xoá cuộc trò chuyện) | "Chưa có chính sách hỗ trợ đã duyệt cho câu hỏi này trong dữ liệu tư vấn" (không có chính sách giao hàng) | `ANSWERED` / `UNKNOWN_ONLY` | `chat-req-1795581087341-yj9ay3` |
| 9 | Câu 7 hỏi lại, phiên MỚI | Trả lời được về quyền mua sớm Giờ Vàng, không nêu con số, đưa số hotline | `ANSWERED` / `UNKNOWN_ONLY` | `chat-req-1795581095441-w12l1l` |

## Kết luận (m34, từ 9 câu trên; chưa đọc mã M4, chưa đọc log .99)
1. **Khoá cả phiên sau một câu sức khỏe (câu 4 → 5, 6, 7 vs 8, 9):** cùng câu hỏi giao hàng/Giờ Vàng, phiên mới trả lời được, phiên đã hỏi tiểu đường thì bị "hơi nhạy cảm" mãi. Có thể là luật cố ý ("tín hiệu sức khỏe qua nhiều lượt") nhưng thực tế khách hỏi một câu là cả khung chat chết.
2. **Câu hỏi giá chung bị từ chối cụt (câu 1):** hỏi "giá các loại cháo" ra từ chối, không kèm món nào; hỏi giá đúng một món (câu 3) mới ra thẻ có giá. `sellableStatus` = `BLOCKED` ở câu đầu của phiên mới.
3. **Nhầm "mình" thành tên "Minh" (câu 2):** lỗi bóc tên khách.
4. **Không có chính sách giao hàng trong dữ liệu tư vấn (câu 8):** câu cơ bản nhất của khách mà bot không trả lời được.
5. **Câu trả lời đều có dạng khuôn cố định** (mở đầu "Dạ…", các khối ACKNOWLEDGEMENT / RECOMMENDATION / DETAIL, đuôi "Ngon như mẹ nấu…"); không thấy dấu hiệu mô hình ngôn ngữ trả lời tự do. Sổ m34 20/11 ghi khoá Claude trên .99 trả 401: chưa kiểm lại hôm nay.

Chưa chạy: bảo đảm lỗi 1 do luật cố ý hay lỗi; kiểm khoá Claude trên .99 hôm nay; kiểm trên bản `dev` mới nhất (.99 đang chạy bản nào chưa đọc lại).
