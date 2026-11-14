# Hướng dẫn dùng Project Control

Đọc một lần. Sau đó mỗi ngày chỉ cần các câu lệnh ngắn ở mục 3.

## 1. Cài đặt một lần

1. Claude app → tab Code → chọn thư mục `C:\Projects\Project Control`. Chỉ mở thư mục này; các repo khác đã được cấp quyền
   trong `.claude/settings.json` nên phiên tự đọc được.
2. Tạo 7 phiên, mỗi phiên gõ đúng một lệnh đầu tiên, rồi đổi tên phiên cho dễ tìm:

| Tên phiên đề xuất | Lệnh đầu tiên | Bạn dùng để |
|---|---|---|
| 0 · Lead | `/phien lead` | nhìn toàn hệ thống, chốt quyết định gộp, báo cáo Chú |
| 1 · M1-M2 ops-core | `/phien m12` | code |
| 2 · M3-M4 rà soát | `/phien m34` | rà việc Phúc (M3) và Tài (M3 vận chuyển + thanh toán, M4) |
| 3 · M5 Facebook | `/phien m5` | giám sát, rà soát Tài |
| 4 · M6 Quảng cáo | `/phien m6` | giám sát, rà soát Tài |
| 5 · M7 Video | `/phien m7` | code |
| 6 · M8 IVR | `/phien m8` | code |

Lệnh không hiện trong danh sách `/` thì gõ: `đọc .claude/commands/phien.md và làm theo, đối số: m12`.

## 2. Nhịp làm việc

- **Sáng (15 phút):** phiên Lead `/phien lead` → đọc một bảng gộp mọi luồng → trả lời một lần (ví dụ `ok m5.1, m6.2 có, m7.1 A`).
  Phiên Lead ghi quyết định vào `QUYET_DINH.md` của đúng luồng; phiên luồng đó tự áp lần mở sau.
- **Phiên mở từ hôm trước:** sáng vẫn gõ `/phien <mã>` để phiên đọc lại luật và sổ mới (phiên Lead có thể đã sửa trong đêm).
- **Mở luồng code** (`m12`, `m7`, `m8`): `/phien m12` → lần đầu `/ke-hoach` (3–4 agent khảo sát song song, dựng danh sách gói việc tới
  chạy thật) → `chạy đi` (một sóng 2–3 gói việc chạy song song, mỗi gói có agent kiểm độc lập).
- **Rà task ở mọi module:** `/ra-soat` → kiểm checkout, `pull --ff-only --no-rebase` repo nguồn và ghim SHA
  → đọc Sheet, rà song song đủ mọi task DONE/REVIEW theo từng tiêu chí/code/PR/test
  → bảng đầy đủ + ghi **Lead duyệt** (chỉ Đạt hoặc Cần sửa) và nối **Ghi chú Lead** bằng `tools/sheet_lead.mjs`, đọc lại Sheet + tin nhắn nháp.
  Task đã Đạt không rà lại. Task do Lead/Nguyễn Quốc Toàn phụ trách: W/X và J (Đạt → Hoàn thành, Cần sửa → Đang làm), H tự tính.
  Task người khác: chỉ W/X, giữ H/J; soạn tin nháp theo đúng người phụ trách để bạn gửi. Không tự gửi tin.
  Phân loại theo người phụ trách trên Sheet, không theo module/agent; định vị cột bằng header và đọc lại sau ghi (D-lead-011).
  Repo chưa pull được thì giữ nguyên checkout và báo lý do. Mỗi lượt ghim ID/SHA, kiểm không bỏ sót và đọc lại thay đổi cuối lượt;
  `bao-cao`/`lien-module` cũng đồng bộ nguồn trước, giữ khuôn báo cáo riêng.
- **Cuối ngày:** `/cuoi-phien` ở phiên nào đã chạy việc. Phiên nhớ trạng thái qua `modules/<mã>/TRANG_THAI.md`, mai mở lại không cần kể lại.
- **Thứ Bảy** (chi tiết `chung/VAN_BAO_CAO.md`): sáng `m12`, `m7`, `m8` gõ `/bao-cao-tuan` để tự báo cáo từng module của bạn.
  Phúc, Tài tự báo cáo rồi gửi file → bạn thả vào `C:\Projects\bao-cao-tuan\<kỳ>\` → `m34`, `m5`, `m6` gõ `/bao-cao-tuan` để rà
  (chỉ đối chiếu số liệu, không trả lại, không tin nhắn). Chiều phiên `lead` gõ `/tong-hop-tuan`. Lệnh kiểm chéo trước: rà 3 báo
  cáo của bạn, tìm commit mới sau giờ rà, đối chiếu chỗ nối giữa các module, rồi gộp 8 báo cáo thành bản gửi Chú theo prompt 3:
  bảng, không %, xưng "Toàn", xuất cả .md và .docx khổ ngang.

## 3. Câu lệnh ngắn

| Bạn gõ | Phiên làm |
|---|---|
| `sao rồi` / `M5 thế nào` | trả lời từ trạng thái + kiểm git nhanh, không chạy việc mới |
| `ok` | duyệt đúng đề xuất vừa trình |
| `ok 1 A, 3 không` | trả lời câu hỏi đánh số của luồng (`m12.1`, `m12.3`); ở phiên Lead ghi đủ mã: `ok m12.1 A` |
| `chạy đi` / `làm tiếp` | chạy đề xuất gần nhất: luồng code chạy sóng gói việc, luồng rà soát chạy đợt rà |
| `/song WP01 WP04` | chạy đúng các gói này song song |
| `/ra-soat phuc 26/10` | pull an toàn + ghim SHA; rà đủ task DONE/REVIEW của Phúc, đối chiếu lịch sử từ 26/10, cập nhật hai cột Lead và soạn tin nháp |
| `/quyet hoãn M6 sau 15/11` | ghi quyết định, sửa kế hoạch bị ảnh hưởng |
| `/ke-hoach ưu tiên nối M3` | làm mới danh sách gói việc theo ghi chú |

Việc mới chưa muốn mở phiên: thả tệp vào `hop-thu/` (xem `hop-thu/README.md`).

## 4. Giới hạn chạy song song

- Mỗi phiên tối đa 3 agent nặng cùng lúc (viết code + kiểm) + 4 agent chỉ đọc. Toàn máy khoảng 10 agent.
- Vì vậy **cùng lúc chỉ chạy sóng code ở 2 phiên** (ví dụ `m12` và `m8`); các phiên rà soát chạy xen giữa.
- Gặp lỗi quá giới hạn (429): phiên tự hạ cỡ sóng; bạn đừng mở thêm phiên.

## 4b. Máy sẽ hỏi bạn trước khi

push, merge, rebase, tạo/gộp PR, `ssh`/`scp` lên máy chủ — kể cả khi phiên đang chạy chế độ bỏ qua quyền. Bấm cho phép nếu đúng
việc bạn đã bảo. Force-push, `reset --hard`, xoá nhánh, `--no-verify`, đọc `.env*`/token thì bị chặn hẳn.
Lưu ý: luật và hook trong `.claude/` của từng repo **không** chạy khi mở ở Project Control; chỉ git hook (ops-core, ivr) còn chạy.

## 5. Tệp nào để làm gì

| Tệp | Ý nghĩa |
|---|---|
| `TONG_QUAN.md` | bảng 9 module, luồng khách, 5 rủi ro |
| `modules/<mã>/SAN_SANG.md` | còn gì để luồng này chạy thật: hạng mục, bậc, gói việc, đường găng |
| `modules/<mã>/TRANG_THAI.md` | hôm nay tới đâu, cần bạn quyết gì (≤ 60 dòng) |
| `modules/<mã>/QUYET_DINH.md` | mỗi quyết định của bạn một dòng |
| `modules/<mã>/PHIEN.md` | luật và lệnh riêng của repo đó |
| `modules/<mã>/wp/<WP>.md` | phiếu từng gói việc: brief, diễn biến, kết quả kiểm, commit (luồng code) |
| `modules/<mã>/ra-soat/` | bản rà soát (luồng rà soát) |
| `modules/<mã>/nhat-ky/` | mỗi ngày một tệp, mỗi việc một dòng |
| `chung/` | cách làm, cổng chạy thật, luật subagent, quy trình báo cáo, mẫu tệp |
| `modules/lead/GHI_CHU_DIEU_HANH.md` | phân công, thay đổi người — dùng cho báo cáo Chú |
| `tools/git_tong_quan.py` | trạng thái git cả 9 repo trong ~1 giây, so với mốc SHA đã lưu (`modules/<mã>/git_moc.json`); tự chạy đầu và cuối phiên |
| `modules/lead/VIEC_NGOAI.md` | việc chờ bên ngoài (Meta, VNPAY, nhà mạng, giấy định danh, anh Tuấn): ai gỡ, cần trước ngày |

## 6. Khác gì cách của Tài

| Cách của Tài (M4-PLAN) | Ở đây |
|---|---|
| Một phiên ôm mọi repo | mỗi luồng một phiên; phiên Lead nhìn toàn cục |
| Mở phiên nạp hàng trăm KB trạng thái | mở phiên đọc 4 tệp ngắn |
| ~290 quyết định chồng ngoại lệ | quyết định một dòng, sửa thẳng luật bị ảnh hưởng |
| Coder/Tester/Judge cho cả việc nhỏ | mức kiểm theo rủi ro R1/R2/R3 |
| Hàng trăm thẻ việc nhỏ | gói việc lớn tới chạy thật, chạy song song |
| % theo số task xong | % theo thang sẵn sàng chung (50/75/90/100) |
| Tối đa 2 agent | 2–3 agent viết + agent kiểm, mỗi phiên |
| Giữ: bảng sáng có "cần quyết" + "đề xuất", ghi quyết định, kiểm độc lập, luật cấm rõ | giữ nguyên |

**Vì sao ít tệp hơn nhiều (31/10: M4-PLAN 12.792 tệp, ~800MB).** Gần hết là sổ và bằng chứng tích lại của một người làm một
module: `04_REPORTS` 10.548 tệp/669MB (mỗi lượt Coder/Tester/Judge một thư mục), `06_PROMPTS` 427 prompt viết tay từng lượt,
`03_TASKS` 292 thẻ việc, 74 tệp `_MEMORY`, ~60 tệp quyết định riêng. Ở đây mỗi chức năng có chỗ, nhưng gọn hơn:

| Thư mục của Tài | Ở đây | Vì sao gọn hơn |
|---|---|---|
| `00_GOVERNANCE` (64 tệp: quy trình, OWN-xxx, DoD) | `CLAUDE.md`, `chung/`, `QUYET_DINH.md` | luật sửa tại chỗ, quyết định một dòng |
| `01_SPECS`, `01_SOURCE_DOCUMENTS` | tài liệu nằm trong repo từng module; `PHIEN.md` trỏ tới | không chép hai nơi |
| `02_PLANS`, `03_TASKS` + `REGISTRY.json` | `SAN_SANG.md` + `wp/` + Google Sheet của repo | gói việc lớn, không thẻ vụn |
| `04_REPORTS` (bằng chứng từng lượt) | phiếu `wp/<WP>.md` + `ra-soat/`; log/test để trong repo | một phiếu mỗi gói việc, không một thư mục mỗi lượt |
| `05_SESSION_MEMORY`, `_MEMORY`, `NHAT_KY` | `TRANG_THAI.md` + `nhat-ky/` + bộ nhớ Claude | trạng thái ghi đè, không tích luỹ |
| `06_PROMPTS` (427) | 8 lệnh `.claude/commands/` + 4 agent `.claude/agents/` | prompt dùng lại, không viết mỗi lượt |
| `07_COORDINATION` | `chung/CACH_LAM.md` §3 (sóng, chế độ W/S/A) | — |
| `Nhiệm Vụ Phát Sinh/` | `hop-thu/` | — |
| `tools/control.py` | `tools/git_tong_quan.py` | — |
| `SEPAY-M3/` (việc riêng của Tài) | phạm vi `tai-m3` trong `modules/m34/PHIEN.md` | Lead chỉ rà, không giữ sổ thay Tài |

Số tệp sẽ tăng dần theo việc thật (phiếu WP, bản rà soát, nhật ký) nhưng mỗi phiên chỉ đọc 4 tệp ngắn khi mở.
