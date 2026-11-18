---
description: (phiên lead) Kiểm commit sau giờ báo cáo và chỗ nối liên module, rồi gộp báo cáo của Toàn + 5 báo cáo Phúc/Tài thành báo cáo tổng hợp M1–M8 gửi Chú theo prompt 3
argument-hint: [kỳ yyyy-mm-dd_yyyy-mm-dd]
---

Chỉ chạy trong phiên `lead`. Kỳ: `$ARGUMENTS`, trống thì tuần này (thứ Hai–thứ Bảy, theo `date`).
Thư mục tuần: `C:\Projects\bao-cao-tuan\<từ>_<đến>\`. Mã báo cáo (`<mã BC>`), repo: `chung/VAN_BAO_CAO.md`.

1. **Kiểm đủ đầu vào** trong thư mục tuần:
   - 5 báo cáo Phúc/Tài (`M3-ban-hang`, `M3-van-chuyen-thanh-toan`, `M4-tu-van-ai`, `M5-cong-facebook`, `M6-do-luong-quang-cao`),
     mỗi cái có bản `-ra-soat` (phiên `m34`, `m5`, `m6` đã rà; chưa có thì giao auditor rà ngay ở bước 2).
   - Báo cáo của Toàn `bao-cao-tuan-<từ>_<đến>-Toan.md` (D-lead-045, `/bao-cao-tuan toan`, Toàn đã duyệt). Báo cáo này đã có 3 auditor rà commit
     lúc lập nên không rà lại bằng prompt 2; chỉ kiểm commit vào sau giờ báo cáo ở bước 2.
   Thiếu báo cáo nào → liệt kê, hỏi Toàn một câu: chờ hay phiên tự lập phần đó từ mã và sổ. Vẫn chạy bước 2 với những gì đã có.
   Không có vòng trả lại, không soạn tin nhắn cho người nộp (D-lead-005).
2. **Kiểm chéo — chạy nền ngay, một `auditor` chỉ đọc** (thêm auditor rà báo cáo Phúc/Tài nào chưa có bản `-ra-soat`):
   - **Sau giờ báo cáo và chỗ nối**: (a) `python "C:\Projects\Project Control\tools\git_tong_quan.py" --fetch --tu "<giờ
     báo cáo hoặc bản rà soát sớm nhất>"`, với mỗi module có commit mới vào nhánh chung: commit đó có làm sai câu nào trong báo cáo hay bản rà
     soát không (gộp, hoàn tác, sửa chức năng đã báo xong); (b) gom các câu trong 6 báo cáo nói về chỗ nối hai module (đặt hàng → gọi
     xác nhận, Messenger → AI tư vấn, đơn → giữ/trừ kho, video → cổng Facebook, sự kiện → đo quảng cáo, thanh toán, vận chuyển),
     đối chiếu `C:\Projects\ginsengfood-contracts` và mã ở **cả hai phía**; mỗi câu: khớp / lệch / chưa kiểm chứng, kèm `tệp:dòng` hoặc SHA.
   - Auditor trả nội dung, không tự ghi. Phiên chính ghi phần kiểm chéo vào `modules/lead/ra-soat/<yyyy-mm-dd>-kiem-cheo-tuan.md` (≤ 60 dòng).
3. **Ghi chú điều hành** (làm trong lúc chờ bước 2): đọc `modules/lead/GHI_CHU_DIEU_HANH.md` và `modules/lead/VIEC_NGOAI.md`;
   hỏi Lead có gì mới tuần này (một câu), cập nhật tệp.
4. **Xử lý kết quả kiểm chéo** (trình Lead một lần, đánh số `lead.<n>`):
   - Bản rà (mọi module) chỉ cho số đã đối chiếu và ý nhận xét; không trả lại, không ai phải sửa báo cáo module.
   - Commit sau giờ rà hoặc chỗ nối lệch → mỗi mục một câu hỏi: ghi vào báo cáo gửi Chú thế nào (sửa số, thêm vào "việc còn lại",
     hay bỏ qua). Không sửa báo cáo hay bản rà soát của Phúc/Tài; dùng số đã đối chiếu trong bản gửi Chú.
   **M3 ba người (D-lead-024):** bảng tổng quan và phần từng module tách M3 thành ba dòng, ba mục: Phúc (giao diện + backend bán hàng),
   Tài (vận chuyển, thanh toán), Toàn (nối M3 → M8 và M1–M2 ↔ M3, máy chủ .99). Không gộp số, không ghi việc của người này cho người kia.
   Phần M1–M2, M7, M8, phần M3 của Toàn và máy chủ lấy từ báo cáo của Toàn (giữ các bảng tách nhóm lý do của con số chưa đạt).
5. Đọc `C:\Projects\bao-cao-tuan\prompt-3-bao-cao-tong-hop.md` và làm đúng theo đó, với khung THÔNG TIN điền từ kỳ, thư mục,
   báo cáo tổng hợp kỳ trước (thư mục tuần trước), ghi chú điều hành ở bước 3 và các mục Lead đã quyết ở bước 4.
6. Đối chiếu bảng tổng quan với `TONG_QUAN.md`, `modules/*/TRANG_THAI.md` và tệp kiểm chéo; lệch thì tin bản rà soát, ghi lại cho Lead.
7. **Kiểm trước khi lưu** (Chú không chuyên IT): tìm và bỏ `%`, chữ "Lead", xưng "con", "trả lại"; mã commit (chuỗi 7–40 ký tự hex), mã task/quyết định (`M5-012`, `OWN-`,
   `DL-`, `WT-`, `WP`), tên tệp, đường dẫn, chỗ trống `<…>` chưa điền, từ tiếng Anh kỹ thuật ngoài bảng đổi thuật ngữ của prompt 3.
8. Xuất Word khổ dọc: `python "C:\projects\Project Control\tools\md_sang_docx.py" <tệp>.md --doc`, đếm trang bằng Word
   (12–13 trang, D-lead-027; quá thì rút gọn), mở lại tệp .docx kiểm số bảng
   và dấu tiếng Việt. Trả theo mục "Lưu và trả lời" của prompt 3 (đường dẫn .md và .docx), thêm một dòng kết quả kiểm chéo;
   cập nhật `TONG_QUAN.md`.
9. **Ghi tab "Báo cáo tuần" của Sheet** khi Lead chốt bản gửi (Lead sửa tay bản Word → đồng bộ .md theo Word trước, rồi mới ghi).
   Soạn `sheet-bao-cao-tuan-<kỳ>.json` trong thư mục tuần: 9 dòng, mỗi module một dòng (M3 ba dòng: Phúc, Tài, Nguyễn Quốc Toàn; dòng của Toàn lấy từ báo cáo của Toàn), trường
   `week` (`yyyy-Www`, tuần ISO), `from`, `to` (`yyyy-mm-dd`), `module` (tên tab `M1-M2`, `M3`…`M8`), `owner` (họ tên đầy đủ, Lead =
   `Nguyễn Quốc Toàn`; khoá có tên người nên luôn viết y hệt), `done`, `doing`, `blocked`, `next`, `file` (tên tệp báo cáo module),
   `review` (ý "Nhận xét" của bản gửi). **Không gửi `sent`** (dòng mới tự "Chưa gửi"; Lead tự đổi "Đã gửi"). Chữ lấy từ bản gửi Chú,
   mỗi ô một dòng, các ý cách nhau bằng "; ". Chạy `weekly-list --from <từ> --to <đến>` trước: dòng đã có thì bỏ `review` khỏi tệp
   (không đè ô Lead sửa tay). Rồi `node <repo>\tools\task-tracker\sheet-sync.mjs weekly --rows <tệp.json> --dry-run`, bỏ `--dry-run`,
   kiểm lại bằng `weekly-list`. `<repo>` = bản có lệnh `weekly`: `C:\Projects\ginsengfood-business-platform` nhánh `toandeptrai` (từ `d145849d7`;
   repo khác có sau khi chạy `install.mjs`). Chạy lại không tạo dòng trùng (khoá: từ ngày, đến ngày, module, người).
   `ping` trả version < 1.4.0 → web app chưa triển khai lại: xuất thêm `.tsv` cùng tên (ngày `dd/mm/yyyy`, cột cuối "Chưa gửi") để
   Lead dán tay, báo Lead.
