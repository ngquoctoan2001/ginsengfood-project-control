# Báo cáo tuần: dùng lại quy trình 3 bước của Lead

Không viết khuôn mới. Mọi báo cáo theo bộ prompt Lead đã soạn (quyết định 31/10, README
`tools/task-tracker/bao-cao-tuan/README.md` trong mọi repo module):

| Bước | Ai | Prompt | Ra |
|---|---|---|---|
| 1. Tự báo cáo module | người phụ trách: Phúc, Tài cho phần của họ; Lead cho M12, M7, M8 và phần M3 của Lead (nối M3 → M8, đưa lên máy chủ) | `<repo>\tools\task-tracker\bao-cao-tuan\prompt-1-<người>-<mã>.md` (+ hướng dẫn chung `prompt-1-bao-cao-module.md`) | `bao-cao-tuan-<từ>_<đến>-<mã>.md`, ≤ 200 dòng |
| 2. Lead rà soát | báo cáo Phúc, Tài: phiên `m34`, `m5`, `m6`; báo cáo M12, M7, M8, M3 của Lead: phiên `lead` trong `/tong-hop-tuan` | `<repo>\tools\task-tracker\bao-cao-tuan\prompt-2-lead-ra-soat.md` | `…-<mã>-ra-soat.md`, ≤ 60 dòng: số khớp/lệch với git + nhận xét, **không kết luận ĐẠT/TRẢ LẠI** |
| 3. Tổng hợp | Lead | `C:\Projects\bao-cao-tuan\prompt-3-bao-cao-tong-hop.md` | `bao-cao-tong-hop-<từ>_<đến>.md` + `.docx` khổ dọc 12–13 trang gửi Chú |

**Không có vòng trả lại, không soạn tin nhắn** (D-lead-005): người phụ trách nộp báo cáo là xong phần của họ. Bản rà soát chỉ để Lead
dùng số đã đối chiếu và viết "Nhận xét:" khi tổng hợp. Prompt 2 trong repo module còn phần kết luận ĐẠT/TRẢ LẠI và tin nhắn sửa:
phiên bỏ qua hai phần đó.

Báo cáo M12, M7, M8 và M3 của Lead không do phiên viết ra tự chấm: `/tong-hop-tuan` mở đầu bằng bước **kiểm chéo**. Bước này gồm 4 agent rà
4 báo cáo đó theo prompt 2, và 1 agent tìm commit vào sau giờ rà soát và đối chiếu chỗ nối giữa các module với mã ở cả hai phía.
Lệch thì dùng số đã đối chiếu trong bản gửi Chú; lệch làm đổi kết luận thì hỏi Lead một câu. Muốn rà sớm hơn thì phiên `lead` chạy `/ra-soat bao-cao`; khi gộp sẽ dùng lại bản đó.

Danh sách báo cáo gốc: `C:\Projects\ginsengfood-business-platform\tools\task-tracker\bao-cao-tuan\bao-cao.json`
(sửa ở đó rồi chạy `install.mjs` ở từng repo).

## Mã báo cáo theo luồng

| Luồng | Mã file | Người | Repo | File bước 1 tới thư mục tuần bằng cách |
|---|---|---|---|---|
| `m34` | `M3-ban-hang` | Phúc | business-platform | Phúc lưu + commit ở repo `docs/weekly-tracking/bao-cao/`, **gửi file cho Lead**; Lead thả vào thư mục tuần |
| `m34` | `M3-van-chuyen-thanh-toan` | Tài | business-platform | như trên |
| `m34` | `M4-tu-van-ai` | Tài | business-platform | như trên |
| `m5` | `M5-cong-facebook` | Tài | module5 | như trên |
| `m6` | `M6-do-luong-quang-cao` | Tài | module5 (`m6/`) | như trên |
| `m34` | `M3-ket-noi-trien-khai` | Lead | business-platform | prompt 1 lưu thẳng vào thư mục tuần |
| `m12` | `M12-van-hanh-nha-may` | Lead | ginsengfood-ops-core | prompt 1 lưu thẳng vào thư mục tuần |
| `m7` | `M7-video-gio-vang` | Lead | ginsengfood-golden-hour-video | như trên |
| `m8` | `M8-ivr` | Lead | ginsengfood-ivr | như trên |

Thư mục tuần: `C:\Projects\bao-cao-tuan\<từ>_<đến>\` (thứ Hai → thứ Bảy). Mọi báo cáo, bản rà soát, bản tổng hợp nằm ở đây.
Phúc/Tài chưa gửi file nhưng đã commit vào repo → phiên lấy bản trong repo, ghi rõ "lấy từ repo, chưa nhận file gửi".

## Lịch thứ Bảy

M3 có ba người, ba báo cáo: Phúc (`M3-ban-hang`: giao diện và backend bán hàng), Tài (`M3-van-chuyen-thanh-toan`),
Toàn (`M3-ket-noi-trien-khai`: nối M3 → M8, máy chủ .99 (trước 14/11 là .60), CI lên máy chủ). Khi tổng hợp, M3 viết thành ba phần theo người, không gộp số (D-lead-024).

| Giờ | Việc | Bạn gõ ở phiên |
|---|---|---|
| 09:00–11:00 | Phúc, Tài tự chạy prompt 1 ở máy họ, kiểm lại, gửi file cho Lead. Cùng lúc Lead tự báo cáo M12, M7, M8 (ba phiên chạy song song) | `m12`, `m7`, `m8`: `/bao-cao-tuan` |
| khi nhận file | Thả file Phúc/Tài gửi vào thư mục tuần | — |
| 11:00–14:00 | Lead rà 5 báo cáo của Phúc/Tài, mỗi báo cáo một agent (chỉ đối chiếu số liệu, không trả lại). Phiên `m34` cùng lượt viết luôn báo cáo M3 của Lead (task M3 trên Sheet có người phụ trách là Nguyễn Quốc Toàn) | `m34` (viết 1 + rà 3), `m5`, `m6`: `/bao-cao-tuan` |
| 14:00–16:00 | Kiểm chéo (~30–45 phút: rà M12, M7, M8, M3 của Lead; commit sau giờ rà; chỗ nối liên module) → Lead quyết các chỗ lệch → gộp 9 báo cáo + 9 bản rà soát thành báo cáo gửi Chú | `lead`: `/tong-hop-tuan` |

## Văn phong cho Chú (tóm tắt — chi tiết trong prompt 3)

- Người không chuyên đọc hiểu: không mã commit, mã task, tên tệp, từ kỹ thuật tiếng Anh; dùng bảng đổi thuật ngữ trong prompt 3.
- Mọi việc còn lại có: vì sao chưa xong · giải pháp · ai làm · hạn.
- Bảng là chính (xuất Word khổ A4 dọc 12–13 trang bằng `tools/md_sang_docx.py --doc`, không có phần điều hành (D-lead-027): chữ ≥ 13, tiêu đề 18 đậm, ô bảng thoáng);
  "Nhận xét:" viết từng ý.
- "backend" giữ nguyên, không dịch thành "máy chủ" (máy chủ chỉ dùng cho server thật) (D-lead-007).
- Không ghi %; không có mục cần Chú quyết hoặc hỗ trợ; không bàn quỹ giờ; mọi module lấy hạn 30/11, 15/11 là mốc giữa kỳ (D-lead-025), trừ phần đã ghi "hoãn".
- Người viết xưng "Toàn", không "con"; không dùng chữ "Lead", gọi đúng tên từng người; Chú vẫn là "Chú".
- M5, M6, M7 (và module nào vừa đổi người) trình bày hiện trạng trước khi nhận bàn giao cạnh hiện nay.
- Trung thực: không có bằng chứng thì ghi "chưa kiểm chứng".
