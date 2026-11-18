# Project Control — bàn điều phối của Lead

Thư mục này là nơi Lead (Nguyễn Quốc Toàn) điều phối hệ thống Ginsengfood M1–M9. Ở đây **không có code**.
Code nằm ở các repo trong `C:\Projects\`. Mỗi phiên Claude mở tại đây nhận **một luồng việc** (bảng §2)
và làm việc với repo của luồng đó bằng đường dẫn tuyệt đối.

Hạn dự án: **30/11/2026** chạy thật, xong hết (D-lead-025). 15/11 là mốc giữa kỳ (bản tối thiểu), các mốc con của nó:
**A** xong chức năng 07/11 · **B** nối liên module 10/11 · **C** nghiệm thu 12/11 · **D** chạy bản tối thiểu 14/11 · 15/11/2026.
Ngày giờ hiện tại: chạy `date`, không đoán.

## 1. Mở phiên

- Lead gõ `/phien <mã>`. Chưa có mã thì hỏi đúng một câu "Phiên này là luồng nào?", không tự đoán.
- Phiên chỉ nạp: `chung/CACH_LAM.md`, `modules/<mã>/PHIEN.md`, `modules/<mã>/SAN_SANG.md`, `modules/<mã>/TRANG_THAI.md`.
  Tài liệu khác chỉ đọc khi việc cần, và đọc đoạn cần (grep), không đọc trọn tệp lớn.
- Lead chốt điều gì giữa chừng → ghi bằng `/quyet` (một dòng `QUYET_DINH.md` + sửa thẳng luật/kế hoạch bị ảnh hưởng).

## 2. Luồng việc

| Mã | Luồng | Repo chính (`C:\Projects\…`) | Người làm | Lead dùng phiên để |
|---|---|---|---|---|
| `m12` | M1–M2 Operational Core | `ginsengfood-ops-core` | Lead | code |
| `m34` | M3 bán hàng (Phúc) · M3 vận chuyển + thanh toán (Tài) · M4 AI tư vấn (Tài) · M3 → M8 + gói NK-b (Lead) · nhánh chú Dũng: Phúc rà + gộp vào `dev` (D-lead-054) | `ginsengfood-business-platform` (+ `M4-PLAN` để đối chiếu) | Phúc, Tài, Lead | rà soát, báo cáo; code M3 → M8 + gói NK-b trên `toandeptrai`, tự gộp vào `dev`; giữ `dev` GitHub có code mới nhất của Lead và `toandeptrai` có code mới nhất của `dev` (D-m34-003, D-lead-054) |
| `m5` | M5 Facebook Gateway | `module5` (gốc; UI quản trị `web/` chung với M6) | Tài | giám sát, rà soát, quyết |
| `m6` | M6 Đo quảng cáo / ROAS | `module5` thư mục `m6/` (từ 10/11, D-m5-025; `module6` = lưu trữ, chỉ đọc) | Tài | giám sát, rà soát, quyết |
| `m7` | M7 Video Giờ Vàng | `ginsengfood-golden-hour-video` (`module7`, `module7-qa` = lưu trữ, chỉ đọc) | Lead | code |
| `m8` | M8 IVR gọi xác nhận đơn | `ginsengfood-ivr` | Lead | code |
| `m9` | M9 Tài chính: hoa hồng, chi trả, kế toán, kết nối MISA (D-lead-059) · chú Dũng tài liệu + sửa mã, Phúc rà + gộp + sửa test, Tài kết nối MISA | `ginsengfood-business-platform` (`finance/`, `commission/`, `docs/m9/`; + `M4-PLAN` để đối chiếu) | chú Dũng, Phúc, Tài | giám sát, rà soát, quyết, giao việc |
| `lead` | Toàn hệ thống: tổng quan, nối liên module, báo cáo Chú | đọc mọi repo | Lead | điều phối |

Repo dùng chung: `ginsengfood-contracts` (hợp đồng API/sự kiện), `deploy` (bộ triển khai chung, `MODULE_DEPLOY_CONTRACT.md`),
`bao-cao-tuan` (báo cáo tuần). Worktree của các phiên: `C:\Projects\_wt\<mã>\<gói việc>\`.
`ginsengfood-contracts` và `deploy` thuộc phiên `lead`; luồng khác cần sửa thì thả `hop-thu/lead-…`.
Trạng thái git: `python "C:\Projects\Project Control\tools\git_tong_quan.py" [luồng] [--fetch] [--luu]` (chỉ đọc, vài giây,
so với mốc SHA đã lưu). Mẫu sẵn sàng, phiếu gói việc, rà soát, tin nhắn, nhật ký: `chung/MAU.md`.

## 3. Luật vàng

1. **Một phiên một luồng.** Chỉ ghi vào `modules/<mã>/` của mình, repo của luồng mình, `C:\Projects\_wt\<mã>\`, tệp
   `hop-thu/<mã>-*` của mình (chuyển sang `hop-thu/xong/` khi xử lý xong) và báo cáo tuần của mình trong
   `C:\Projects\bao-cao-tuan\<kỳ>\`. `CLAUDE.md`, `chung/`, `TONG_QUAN.md`, `.claude/`, `tools/` chỉ phiên `lead` sửa.
   Phiên `lead` được thêm dòng vào `QUYET_DINH.md` của luồng khác, không ghi đè sổ khác của luồng (bảng đầy đủ: `CACH_LAM.md` §7).
2. **Luật repo đích thắng.** Ở repo nào theo `CLAUDE.md`/`AGENTS.md` của repo đó về nhánh, commit, test, tracker.
   Phiên mở ở đây **không nạp** `.claude/settings.json` và hook Claude của repo đích (chỉ git hook `.githooks` còn chạy) →
   tự giữ các luật đó. `PHIEN.md` tóm tắt; thấy lệch thì đọc lại repo và sửa `PHIEN.md`.
3. **Làm theo gói việc tới production, không làm vụn.** Đơn vị là gói việc (WP) trong `SAN_SANG.md`; mỗi gói nâng
   năng lực lên một bậc của thang sẵn sàng (`chung/CONG_PRODUCTION.md`). Việc vặt gộp vào gói cùng vùng.
4. **Song song bằng subagent.** Một lệnh của Lead → phiên tách thành nhiều subagent chạy cùng lúc
   (`/song`, `/ra-soat`, `/ke-hoach`). Phiên chính điều phối, ghép kết quả, giữ sổ; không tự đọc cả repo.
5. **Kiểm độc lập theo mức rủi ro** (R1/R2/R3, `chung/CACH_LAM.md` §4). Người viết không tự chấm.
6. **Trung thực.** Chưa chạy ghi `CHƯA CHẠY`, không suy thành đạt. Không gọi module là "sẵn sàng chạy thật" khi chưa qua
   cổng. % luôn theo thang chung, không tính bằng số task xong.
7. **Ngữ cảnh gọn.** `TRANG_THAI.md` ≤ 60 dòng, ghi đè mỗi lần chốt; lịch sử vào `nhat-ky/`; quyết định một dòng một mục.

## 4. An toàn

- **Thư mục này là repo git CÔNG KHAI** (`github.com/ngquoctoan2001/ginsengfood-project-control`, Lead chốt 14/11): mọi tệp ngoài
  `.gitignore` sẽ ai cũng đọc được. Không ghi bí mật, mật khẩu, số điện thoại hay dữ liệu khách thật vào sổ; bằng chứng nặng để trong
  thư mục con của `modules/<mã>/ra-soat/` (đã loại khỏi git). Trước mỗi lần push chạy lại bước quét bí mật.
- Không đọc, in, chép bí mật (mọi `.env*`, khoá, token, mật khẩu, chuỗi số từ 10 chữ số); không dùng dữ liệu khách thật.
  6 repo có token Sheet trong `tools/task-tracker/sheet.json` đã commit: `git show/diff/log -p` luôn thêm
  `-- . ':!**/sheet.json' ':!**/.env*'`.
- `.claude/settings.json` chặn hẳn force-push, `reset --hard`, `clean -f`, xoá nhánh, `--no-verify`, đổi hook, script máy thật.
  Không còn luật "ask" (Lead bỏ 14/11, các phiên chạy bypass): máy không hiện hộp hỏi duyệt lệnh nữa; không thêm lại luật "ask".
- Không force-push, `reset --hard`, `clean -fdx`, xoá nhánh, rebase nhánh chung, sửa lịch sử.
- Máy chủ chính thức từ 13/11: **.99** nhà máy + bán hàng (M1–M2, M3, M4, M9, app M8), **.98** mkt (M5 + M6); .60 chỉ còn M7 tạm và đường lui,
  .61 đường lui, .64 Asterisk. Bảng máy, địa chỉ, lịch cắt: `chung/MAY_CHU.md`. Việc mới nhắm .99/.98, không lập kế hoạch mới trên .60/.61.
- Không push, merge, mở PR, deploy, chạy migration lên DB dùng chung hay máy chủ (.60/.61/.63/.64/.98/.99), đổi cờ production
  (`PRODUCTION_ENABLED`, `M5_M7_DISPATCH_MODE=real`, `GLOBAL_GATEWAY_STATE`…), gọi đối tác thật (Meta, VNPAY, GHN, Viettel Post,
  nhà mạng) — **trừ khi Lead nói rõ cho đúng việc đó trong phiên này**. Lời đồng ý không chuyển sang việc khác.
- Khi `/ra-soat`, phiên chính đồng bộ repo nguồn bằng `git pull --ff-only --no-rebase` sau khi kiểm checkout sạch, đúng nhánh/upstream
  và không có phiên đang dùng checkout; ghim SHA rồi rà trong môi trường tách biệt. Không tự đổi nhánh, stash/reset hoặc tạo merge commit.
  Phần rà của `m34`, `m5`, `m6`, `m9` không sửa mã/commit vào repo Phúc/Tài/chú Dũng; muốn sửa mã phải có lệnh Lead và báo người đó trước.
- Không sửa tệp đang dở của người khác; thấy dirty lạ thì báo, không stash/revert.

## 5. Lead nói ngắn — hiểu thế nào

- "ok" sau một đề xuất = duyệt **đúng** đề xuất vừa trình. Câu hỏi cho Lead đánh số `<mã>.<n>` (`m12.1`); trong phiên của
  luồng "ok 1,3" = `<mã>.1` và `<mã>.3`; ở phiên `lead` phải ghi đủ mã (`ok m5.1, m6.2 A`). Không tự mở rộng.
- "chạy đi", "làm tiếp" = chạy đề xuất gần nhất: luồng code `/song`, luồng rà soát `/ra-soat`.
- Câu hỏi ("sao rồi", "M5 thế nào") = trả lời từ `TRANG_THAI.md` + kiểm nhanh git; không chạy việc mới.
- Không chắc lệnh nghĩa là gì → hỏi lại một câu, kèm phương án đề xuất.

## 6. Lệnh tắt

| Lệnh | Làm gì |
|---|---|
| `/phien <mã>` | nhận vai luồng + bảng đầu phiên: thay đổi, % sẵn sàng, việc chặn, cần Lead quyết, đề xuất sóng |
| `/ke-hoach` | khảo sát sâu song song, dựng lại `SAN_SANG.md`: năng lực, gói việc, đường găng tới 14/11 |
| `/song [WP…]` | chạy một sóng gói việc song song: subagent viết → subagent kiểm → ghép |
| `/ra-soat [đối tượng]` | pull an toàn + ghim SHA; rà đủ DONE/REVIEW; task Lead cập nhật H/J/W + X, task người khác W/X; soạn tin nháp theo người phụ trách; `bao-cao`/`lien-module` giữ khuôn riêng |
| `/quyet <nội dung>` | ghi quyết định Lead, sửa luật/kế hoạch bị ảnh hưởng |
| `/cuoi-phien` | chốt phiên: trạng thái, sẵn sàng, nhật ký, tracker |
| `/bao-cao-tuan [toan] [kỳ]` | phiên `lead` + `toan`: báo cáo tuần của Toàn (một tệp, D-lead-045); phiên `m34`/`m5`/`m6`: rà báo cáo Phúc/Tài; vào `C:\Projects\bao-cao-tuan\<kỳ>\` |
| `/tong-hop-tuan [kỳ]` | (phiên `lead`) báo cáo tổng hợp gửi Chú |

Lệnh không hiện trong app thì gõ: "đọc `.claude/commands/<lệnh>.md` và làm theo, đối số: …".

Mọi lượt `/ra-soat` bắt đầu bằng bước pull an toàn của lệnh; repo chưa pull được phải ghi lý do, không ngầm dùng bản cũ.
`/ra-soat` người/module đã bao gồm quyền ghi **Lead duyệt** (W) và nối **Ghi chú Lead** (X), đồng thời soạn tin nháp (D-lead-020):
- Chỉ rà task Hoàn thành/Chờ review **chưa Đạt**. Task đã Đạt không rà lại; task Cần sửa chưa được sửa thì chờ.
- Rà xong chỉ có **Đạt** hoặc **Cần sửa** (thiếu bằng chứng = Cần sửa, ghi việc phải làm). Không để task đã rà ở Chưa duyệt.
- Ghi bằng code ngay trong lượt: `node "C:\Projects\Project Control\tools\sheet_lead.mjs" ghi <ket-qua.json>`, công cụ tự đọc lại.
  Không mở Chrome/trình duyệt, không sửa tay.
- Task Lead/Nguyễn Quốc Toàn: W, X và J (Đạt → Hoàn thành, Cần sửa → Đang làm), H tự tính theo J (Đã xong / Đang chạy).
- Task Phúc/Tài: chỉ W/X, giữ mọi cột khác; soạn tin nháp cho đúng người phụ trách.
Không dùng `sheet-sync log` đè task coder, không tự sửa mã/commit hay gửi tin. Kết luận task không thay quyền
merge/deploy/nghiệm thu production. Chi tiết bắt buộc ở `.claude/commands/ra-soat.md` và `chung/CACH_LAM.md` §8.

## 7. Ngôn ngữ

Tiếng Việt có dấu, ngắn, có đường dẫn tệp. Gọi Lead là "bạn" trừ khi Lead dặn khác. Gọi người khác bằng tên
(Phúc, Tài, Tuấn), không đoán đại từ. Tên tệp, thư mục mới: ASCII không dấu.

**Tin nhắn Toàn gửi người** (Anh Tuấn, Tài, Phúc, chú Dũng, người khác; Lead dặn 14/11): ngắn, đơn giản, giọng miền Tây
gần gũi như nhắn Zalo thường ngày ("dạ", "nha", "nghen", "hen", "được hông", "tụi em"…), không cứng, không kiểu máy, không khúm núm.
Xưng hô: Anh Tuấn — em/anh, giọng nhờ; Tài, Phúc — anh/em, Toàn là lead nên chốt việc dứt khoát; chú Dũng — con/chú.
Trong tin **không** dán đường dẫn tệp, mã commit, tên biến, dòng code hay bảng dài: tin chỉ nói việc gì, hạn, ai làm, rồi
"chi tiết anh để trong file". Phần kỹ thuật viết trong tệp `.md` gửi kèm (mẫu `chung/MAU.md` §3).
