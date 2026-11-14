# Phiên `lead` — Toàn hệ thống M1–M9

Phiên điều phối: không code module. Nhìn cả hệ thống, nối liên module, gỡ việc chặn chung, báo cáo Chú, giữ "bộ luật" của
Project Control (`CLAUDE.md`, `chung/`, `.claude/`, `tools/`, `TONG_QUAN.md` chỉ phiên này sửa) và hai repo dùng chung
`ginsengfood-contracts`, `deploy` (chủ là phiên này, `CACH_LAM.md` §3).

## Nguồn

- `TONG_QUAN.md` (bảng 9 dòng), `VIEC_NGOAI.md` (việc chờ bên ngoài) và `modules/*/TRANG_THAI.md` — mỗi tệp ngắn, đọc hết được.
- Repo module: `ginsengfood-ops-core`, `ginsengfood-business-platform` (`dev`, `dev015`, `PhucApu`), `module5`, `module6`,
  `ginsengfood-golden-hour-video`, `ginsengfood-ivr`; `M4-PLAN` (sổ của Tài, chỉ đọc đoạn cần).
- Repo dùng chung: `ginsengfood-contracts`, `deploy`, `bao-cao-tuan`.
- `hop-thu/lead-*` — việc mới Lead thả vào (lời Chú, tin nhắn, ý tưởng); phiên này phân về luồng (đổi tiền tố tệp).
- `GHI_CHU_DIEU_HANH.md` — phân công, thay đổi người, điều không có trong repo nào.

## Kiểm đầu phiên (`/phien lead`)

1. `python "C:\Projects\Project Control\tools\git_tong_quan.py" --fetch` — mọi repo so với mốc SHA đã lưu
   (`modules/lead/git_moc.json`): commit mới, tệp bẩn, merge dở, nhánh remote mới/xoá. Vài giây, không tốn agent.
2. Giao 2 `scout` chạy nền trong một message cho phần ngoài git:
   (a) báo cáo đầu ngày mới nhất của Tài (`M4-PLAN/02_PROJECT_CONTROL/04_REPORTS/PERIODIC/bao-cao-dau-ngay-<yyyy-mm-dd>.md`)
   + `gh pr list` ở business-platform và module5 (máy đã đăng nhập `gh`): việc Tài/Phúc chờ Lead, PR chờ;
   (b) `C:\Projects\bao-cao-tuan\` + Sheet các repo (`sheet-sync.mjs list`): báo cáo tuần đã nộp, task bị chặn.
3. Phiên chính đọc mọi `modules/*/TRANG_THAI.md` mục "Cần Lead quyết", mục việc ngoài code trong `modules/*/SAN_SANG.md`
   (cập nhật `VIEC_NGOAI.md`), và `hop-thu/lead-*`.

**Bảng đầu phiên lead** (≤ 40 dòng): 9 dòng module (Sẵn sàng · Kịp 15/11 · thay đổi một câu) → **mọi việc cần bạn quyết gom
từ các luồng**, giữ số `<mã>.<n>` của luồng (`m5.1`, `m34.2`…), xếp theo hạn → việc ngoài code sắp trễ → việc chặn liên module →
đề xuất hôm nay (luồng nào mở phiên, chạy lệnh gì). Lead trả lời ở đây → phiên `lead` chỉ **thêm dòng** vào `QUYET_DINH.md`
của luồng đó (`/quyet`), không sửa sổ khác của luồng; phiên luồng tự áp ở lần mở sau.

## Việc của phiên

| Việc | Lệnh | Ghi chú |
|---|---|---|
| Nhìn toàn hệ thống mỗi sáng | `/phien lead` | 5 phút đọc, trả lời gộp một lần |
| Nối liên module (mốc B 10/11) | `/ke-hoach`, `/ra-soat lien-module` | `SAN_SANG.md` của phiên này = bảng điểm nối |
| Việc ngoài code (G8) | `/phien lead` | `VIEC_NGOAI.md`: ai gỡ, cần trước ngày; soạn tin đòi mốc |
| Repo dùng chung | `/song` chỉ khi Lead cho | contracts kẹt merge từ tháng 5; deploy cũ |
| Báo cáo Chú | `/tong-hop-tuan` | đủ 9 báo cáo (M3 ba người: Phúc, Tài, Toàn — D-lead-024); 5 báo cáo Phúc/Tài có bản rà (đối chiếu số, không trả lại); lệnh tự kiểm chéo (rà M12, M7, M8, M3 của Toàn, commit sau giờ rà, chỗ nối) |
| Rà sớm báo cáo M12, M7, M8 | `/ra-soat bao-cao` | không bắt buộc; `/tong-hop-tuan` dùng lại bản đã có |
| Sửa luật chung | `/quyet` | sửa `CLAUDE.md`, `chung/`, lệnh; ghi `D-lead-NNN` |

## Luật riêng

- Không sửa mã repo module từ phiên này; việc code thuộc phiên của luồng đó.
- Không soạn tin cho Phúc, Tài, Anh Tuấn trừ khi Lead yêu cầu trong lệnh; khi đó soạn vào `ra-soat/` (`chung/MAU.md` §3), Lead tự gửi.
- Bí mật: 6 repo có token Google Sheet trong `tools/task-tracker/sheet.json` đã commit → không đọc, không in tệp đó.
