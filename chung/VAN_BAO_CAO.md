# Báo cáo tuần

Hai loại báo cáo, cùng văn phong cho Chú (người không chuyên IT):

| Loại | Ai lập | Ra |
|---|---|---|
| **Báo cáo tuần của Toàn** (D-lead-045, từ 14/11) | phiên `lead`: `/bao-cao-tuan toan` | `bao-cao-tuan-<từ>_<đến>-Toan.md` + `.docx` khổ dọc, ≤ 200 dòng |
| Báo cáo tổng hợp M1–M8 | phiên `lead`: `/tong-hop-tuan` | `bao-cao-tong-hop-<từ>_<đến>.md` + `.docx` khổ dọc gửi Chú |

Phúc và Tài vẫn tự báo cáo phần của họ theo prompt 1 (repo module `tools/task-tracker/bao-cao-tuan/`), phiên `m34`, `m5`, `m6` rà bằng
prompt 2 (chỉ số khớp/lệch với git + nhận xét, không kết luận ĐẠT/TRẢ LẠI). **Không có vòng trả lại, không soạn tin nhắn** (D-lead-005).
Phần của Toàn **không** còn viết 4 báo cáo riêng `M12-van-hanh-nha-may`, `M7-video-gio-vang`, `M8-ivr`, `M3-ket-noi-trien-khai`
theo prompt 1/2 (thay bằng báo cáo của Toàn; phiên `m12`, `m7`, `m8` không chạy `/bao-cao-tuan` nữa).

## Báo cáo tuần của Toàn (D-lead-045)

Một tệp chung cho mọi phần Toàn trực tiếp làm. Mẫu: `C:\Projects\bao-cao-tuan\2026-11-09_2026-11-14\bao-cao-tuan-2026-11-09_2026-11-14-Toan.md`.

**Quy trình** (phiên `lead`, thứ Bảy):
1. Hỏi dữ kiện các phiên luồng đang mở bằng tin nhắn phiên (một message, chạy song song): phiên M1-2, phiên M3-4 (chỉ phần Toàn),
   phiên M8, phiên M7, phiên hạ tầng máy chủ. Khung hỏi: đã làm + bằng chứng (SHA/tệp) · còn lại tới mốc gần nhất và 30/11 ·
   kế hoạch tuần tới · khó khăn + cách giải quyết · chưa chạy ghi "CHƯA CHẠY". Phiên không mở thì auditor đọc sổ thay.
2. Cùng lúc giao 3 `auditor` chỉ đọc, rà commit trong kỳ đối chiếu sổ: (a) M1–M2 + nối M1–M2 ↔ M3 (ops-core, hợp đồng, phần M3 của Toàn);
   (b) nối M3 → M8 + M8 (`toandeptrai` phần gọi xác nhận, ivr); (c) M7. Mỗi auditor trả: số commit theo ngày, việc xong theo nghiệp vụ
   + bằng chứng, việc chưa chạy, chỗ sổ lệch git, chất lượng và rủi ro khi chạy thật, khó khăn.
3. Phiên `lead` viết. Số liệu lấy theo bản auditor đã đối chiếu; số nghiệm thu đếm lại từ sổ nghiệm thu. **Mọi con số chưa đạt**
   (không đạt, bị chặn, chưa chạy, chưa xong) phải tách nhóm: số lượng · vì sao · cách giải quyết · khi nào (Toàn dặn 14/11: Chú cần hiểu
   tại sao và cách giải quyết, không chỉ con số). Con số đối tác/thông số lấy theo lời Toàn đã chốt, không theo bản nháp cũ.
4. Tự kiểm: ≤ 200 dòng; không `%`, mã commit/task/quyết định, tên tệp, từ tiếng Anh kỹ thuật (bảng đổi thuật ngữ trong prompt 3);
   bảng đủ cột. Toàn đọc, góp ý, sửa; Toàn duyệt rồi mới xuất Word: `python tools/md_sang_docx.py <tệp>.md --doc` (khoảng 10 trang).
5. Chỗ sổ lệch git mà auditor thấy: báo phiên luồng tự sửa, không sửa sổ của luồng. Ghi nhật ký `modules/lead/nhat-ky/`.

**Bố cục:**
- Đầu: "Kính gửi: Chú Dũng" · "Người báo cáo: Nguyễn Quốc Toàn" · "Ngày" (mỗi ý một dòng) + 2 dòng mở đầu nêu phạm vi.
- 1. Tóm tắt: bảng Phần việc · Tuần này làm được · Mốc gần nhất (15/11, …). Không cột Kịp 30/11.
- 2…7. Mỗi phần một mục, theo thứ tự: Đưa hệ thống lên máy chủ .99 · Module 1-2 · Nối Module 1-2 ↔ Module 3 · Nối Module 3 → Module 8 ·
  Module 8 · Module 7 (thêm Module 9 khi tuần có việc); tiêu đề dùng tên module chuẩn, không ghi màu. Mỗi mục: mục tiêu 1 dòng (với phần nối) · bảng "Việc đã làm | Kết quả" · bảng tách nhóm cho
  con số chưa đạt · bảng "Việc còn lại | Vì sao chưa xong | Cách giải quyết | Ai | Hạn" · "Nhận xét:" từng gạch đầu dòng, nói cả điểm yếu.
- 8. Kế hoạch tuần tới: bảng Phần · Việc · Hạn. 9. Khó khăn, vướng mắc và cách giải quyết: bảng Khó khăn · Ảnh hưởng · Cách giải quyết · Tình trạng.

## Báo cáo tổng hợp M1–M8

Đầu vào: báo cáo của Toàn + 5 báo cáo Phúc/Tài (mỗi cái kèm bản rà) trong thư mục tuần. Quy trình chi tiết: `.claude/commands/tong-hop-tuan.md`,
prompt `C:\Projects\bao-cao-tuan\prompt-3-bao-cao-tong-hop.md`. M3 viết thành ba phần theo người (Phúc: giao diện + backend bán hàng;
Tài: vận chuyển, thanh toán; Toàn: nối M3 với M8 và M1–M2, máy chủ), không gộp số (D-lead-024).

## Mã báo cáo Phúc, Tài

| Luồng | Mã file | Người | Repo | File tới thư mục tuần bằng cách |
|---|---|---|---|---|
| `m34` | `M3-ban-hang` | Phúc | business-platform | Phúc lưu + commit ở repo `docs/weekly-tracking/bao-cao/`, **gửi file cho Toàn**; Toàn thả vào thư mục tuần |
| `m34` | `M3-van-chuyen-thanh-toan` | Tài | business-platform | như trên |
| `m34` | `M4-tu-van-ai` | Tài | business-platform | như trên |
| `m5` | `M5-cong-facebook` | Tài | module5 | như trên |
| `m6` | `M6-do-luong-quang-cao` | Tài | module5 (`m6/`) | như trên |

Thư mục tuần: `C:\Projects\bao-cao-tuan\<từ>_<đến>\` (thứ Hai → thứ Bảy). Phúc/Tài chưa gửi file nhưng đã commit vào repo → phiên lấy
bản trong repo, ghi rõ "lấy từ repo, chưa nhận file gửi". Danh sách báo cáo gốc của bộ prompt module:
`C:\Projects\ginsengfood-business-platform\tools\task-tracker\bao-cao-tuan\bao-cao.json`.

## Lịch thứ Bảy

| Giờ | Việc | Bạn gõ ở phiên |
|---|---|---|
| 09:00–11:00 | Phúc, Tài tự chạy prompt 1, gửi file. Cùng lúc phiên `lead` lập báo cáo của Toàn (hỏi các phiên + 3 auditor) | `lead`: `/bao-cao-tuan toan` |
| 11:00–14:00 | Toàn đọc, duyệt báo cáo của mình → xuất Word. Phiên `m34`, `m5`, `m6` rà 5 báo cáo Phúc/Tài (chỉ đối chiếu số liệu) | `m34`, `m5`, `m6`: `/bao-cao-tuan` |
| 14:00–16:00 | Kiểm commit sau giờ báo cáo + chỗ nối liên module → gộp thành báo cáo tổng hợp gửi Chú | `lead`: `/tong-hop-tuan` |

## Văn phong cho Chú (áp cho cả hai loại)

- Người không chuyên đọc hiểu nhưng **không dịch gượng** (Toàn dặn 14/11): "code" thay "mã", "mã nguồn" thay "kho mã"; thuật ngữ đặc thù
  (API, test, CI, server, HTTPS, commit, database, backend, webhook…) dùng như bình thường, giải thích ngắn lần đầu nếu cần. Không mã commit,
  mã task, tên tệp, đường dẫn.
- Mọi việc còn lại có: vì sao chưa xong · cách giải quyết · ai làm · hạn. Con số chưa đạt luôn tách nhóm lý do.
- Bảng là chính (Word khổ A4 dọc, `tools/md_sang_docx.py --doc`; chữ ≥ 13, tiêu đề 18 đậm, ô bảng thoáng); "Nhận xét:" viết từng ý.
- Tên module viết đúng và **in đậm** mỗi khi nhắc (Toàn dặn 14/11): **Module 1-2 - Vận hành sản xuất** · **Module 3 - Bán hàng** · **Module 4 - AI Tư vấn** · **Module 5 - Kết nối Meta** · **Module 6 - Đo lường quảng cáo** · **Module 7 - Sản xuất Video giờ vàng** · **Module 8 - Gọi xác nhận đơn tự động**; không viết "nhà máy", "bán hàng", "gọi xác nhận đơn", "M1–M2"… thay cho tên module. Máy chủ luôn ghi "máy chủ .99" (cũng vậy với .98, .63, .60, .61), không ghi ".99" trơn hay "máy chủ chính thức (.99)".
- Bản tổng hợp: Kết luận tuần không có dòng "Nguy cơ lớn nhất" (rủi ro ở Phần 4); bảng tổng quan không có cột Kịp 30/11; tiêu đề module không ghi màu.
- "backend" giữ nguyên, không dịch thành "máy chủ" (máy chủ chỉ dùng cho server thật) (D-lead-007).
- Không ghi %; không có mục cần Chú quyết hoặc hỗ trợ (việc chờ người khác ghi trong bảng việc còn lại, có người và hạn); không bàn quỹ giờ;
  mọi module lấy hạn 30/11, 15/11 là mốc giữa kỳ (D-lead-025), trừ phần đã ghi "hoãn".
- Người viết xưng "Toàn", không "con"; không dùng chữ "Lead", gọi đúng tên từng người; Chú vẫn là "Chú".
- Module nào vừa đổi người trình bày hiện trạng trước khi nhận bàn giao cạnh hiện nay.
- Trung thực: không có bằng chứng thì ghi "chưa kiểm chứng" hoặc "chưa chạy"; nói cả điểm yếu.
