# Bàn giao khi đổi tài khoản Claude · 14/11/2026 ~12:40

Tài khoản cũ hết hạn mức. Phiên mới (tài khoản mới) đọc tệp này, mở lại các phiên phụ bằng brief dưới, rồi báo Toàn việc đang chờ.
Mọi phiên đều ở chế độ bypass; luật chung vẫn là `CLAUDE.md` (máy chủ: `chung/MAY_CHU.md`; repo công khai: không ghi bí mật).

## Cách mở lại

- **Cách gọn (đề xuất):** mở phiên mới ở `C:\Projects\Project Control`, gõ `/phien lead`, dán: "Đọc `modules/lead/ban-giao/2026-11-14-chuyen-tai-khoan.md`, mở lại các phiên ở mục 'Phiên phụ' bằng start_session (context fresh, brief trong tệp), rồi báo tôi việc đang chờ tôi." Phiên mới đọc sổ nên không cần lịch sử cũ.
- **Mở lại nguyên lịch sử một phiên:** `powershell -File "C:\Projects\Project Control\tools\mo_lai_phien.ps1"` liệt kê các phiên cũ (giờ, cỡ, câu đầu); `… -Mo <số>` mở `claude --resume` trong tab mới. Lịch sử dài (20–110 MB) nên tốn hạn mức; chỉ dùng khi cần.
- **Phiên trên .63** (M7): lịch sử nằm trên .63. Tài khoản mới phải đăng nhập Claude trên .63 một lần: `ssh -t ssv@192.168.1.63 "bash -lc claude"` rồi `/login`. Kết nối SSH `may-63` đã có trong Claude Desktop (`~/.claude/settings.json` → `sshConfigs`).

## 13 phiên và mã của chúng (lấy từ bản ghi Claude Desktop `%APPDATA%\Claude\claude-code-sessions\…\local_*.json`)

Mã lịch sử (cột "Lịch sử") là tên tệp `C:\Users\Administrator\.claude\projects\C--Projects-Project-Control\<mã>.jsonl`, dùng cho `claude --resume <mã>`.
Kịch bản `tools/mo_lai_phien.ps1` đã ghi sẵn bảng này: chạy không đối số để xem, `-Mo <số>` để mở lại.

| Số | Nhóm | Phiên | Mã Desktop | Mã lịch sử | Ở đâu |
|---|---|---|---|---|---|
| 1 | lead | Lead (fork) — điều phối | `local_690b40cd-88b2-4f24-9a93-780af402d5a7` | `e90f04e2-b267-4404-a6e5-91e2597d33ae` | máy Lead, 22 MB |
| 2 | phụ | lead · dựng nền máy .99 | `local_e7d5193b-3dfe-4276-8135-3099a2a0dafc` | `7f9e1618-f77e-431d-adfe-9637e44c5f06` | máy Lead, 8 MB |
| 3 | phụ | m12 phụ · chuyển M1–M2, CI Linux | `local_a2ba6f6c-2ebd-4dc5-adc6-6b22bc9290b3` | `f215475d-6366-4982-b455-6b4135e1b6ba` | máy Lead, 19 MB |
| 4 | phụ | m34 phụ · gói M3/M4/M9 sang .99 | `local_54b466ed-461d-4058-be67-68df396859da` | `c558a618-20e4-4355-a685-11bc382cb73c` | máy Lead, 17 MB |
| 5 | phụ | m8 phụ · app M8 sang .99 | `local_4a116c00-1159-4ce5-a342-4746ce514d03` | `4c3f1c8d-d2d6-43c9-95cd-28785ac97f1a` | máy Lead, 13 MB |
| 6 | phụ | M8 · sửa test chập chờn bare-cr | `local_8fd8fc64-ddef-4cce-aef1-6afcd755c77d` | `88ce48ac-7d7e-4a97-9b90-de48e074c5dc` | máy Lead, 3 MB |
| 7 | phụ | M7 trên .63 · T221, T076d, T085 | `local_5ce7e61c-6726-4789-8c59-02ee243194eb` | `db97fd09-9d99-488b-be74-bf9ffe869ef2` | **.63** (`~/.claude` của `ssv`) |
| 8 | chính | M1-2 (`m12`) | `local_c2c32977-4e56-4b79-a4c6-c0dc69f4b6b8` | `6b4be261-c086-4b8d-b8a0-d709823e1a2e` | máy Lead, 64 MB |
| 9 | chính | M3-4 (`m34`) | `local_2efacb7e-721d-477a-9220-125c8f10fa18` | `8d38bd21-896f-4bf1-b5a6-9e4d42febf01` | máy Lead, 23 MB |
| 10 | chính | M5 (`m5`) | `local_19ccd510-b9c4-4a77-a672-33167981a8ad` | `7c0b5c92-b669-448e-a45f-79b23111103a` | máy Lead, 6 MB |
| 11 | chính | M6 (`m6`) | `local_c80bf97a-fafe-49f0-a27e-f3b1a0706ccd` | `9268894f-5b58-4c99-9318-b4f29d286235` | máy Lead, 3 MB |
| 12 | chính | M7 (`m7`, chỉ giữ sổ) | `local_c45f3895-8255-49c2-81da-5091c2bbf213` | `5fa8b65e-84b9-44b6-ac6e-d123c6e95511` | máy Lead, 108 MB |
| 13 | chính | M8 (`m8`) | `local_da399f74-764c-4378-a426-324aa6ae9461` | `4916bdfb-d21d-426e-85db-f75a6e6ae5f2` | máy Lead, 4 MB |

Bản ghi Desktop nằm theo từng tài khoản (`claude-code-sessions\<A>\<B>\`), nên tài khoản mới mở Desktop sẽ **không thấy** 13 phiên này ở thanh bên.
`mo_lai_phien.ps1 -NhapDesktop` chép 13 bản ghi sang thư mục của tài khoản mới (xem trước; `-XacNhan` mới chép; chỉ thêm tệp, không ghi đè, không xoá; dừng nếu chưa thấy thư mục của tài khoản vừa đăng nhập).
Mã lịch sử có thể đổi khi phiên chạy tiếp ở tài khoản cũ; chạy lại kịch bản trên bản ghi mới nếu cần.

## Trạng thái chung (12:40)

- Máy chủ chính thức: .99 nhà máy + bán hàng (M1–M2 từ 13/11 19:15, M3/M4/M9 từ 14/11 07:36, M8 từ 07:46), .98 mkt (M5 cổng 3000, M6 cổng 6600 chưa mở ra LAN), .63 máy dev (D-lead-039).
- Runner GitLab: `may-63` #59199848 trên .63 (tag `ginsengfood-docker`, `ops-core-linux`; ivr + ops-core) online; `ivr-docker-winhost` #55115499 máy Lead **tạm dừng**; `ops-core-win` #54358997 máy Lead vẫn chạy (CI ops-core còn Windows tới khi xong D-lead-040).
- Project Control là repo **công khai** `github.com/ngquoctoan2001/ginsengfood-project-control` (commit cuối đã push `ccb5bb7`; sổ sau đó chưa push — quét bí mật trước khi push).
- Kế hoạch máy dev + checklist: `modules/lead/may-chu/2026-11-14-ke-hoach-may-dev-63.md`. Nhật ký: `modules/lead/nhat-ky/2026-11-14.md`.

## Việc đang chờ Toàn

1. m12 phụ: chọn **m12.c8** (cách đưa bộ quét SAST đã duyệt sang Linux).
2. m8: duyệt push 2 commit W-0538 sửa test `bare-cr` (`5714b6b8`, `e9976810`, đã quét gitleaks + pre-push xanh).
3. M7 trên .63: khi T085 commit xong, duyệt push `5609ed1` (T221), `9ca04ca` (T076d), T085.
4. m34: duyệt push `0eeeb60e5` (sửa công cụ kiểm đơn, nhánh `toandeptrai`).
5. Gửi tin Tài rồi Anh Tuấn về `mkt.` (D-lead-041, tin do phiên dựng nền soạn): Tài chia đường trên .98 bằng nginx cổng 80; Anh Tuấn HTTPS + chuyển `mkt.` → .98:80. Tài mở cổng M6 6600 ra LAN như M5.
6. Gửi Anh Tuấn: xin cố định RAM .98 8 GB; hỏi .63 có chung máy vật lý .98/.99 không (tin cuối `may-chu/2026-11-14-ke-hoach-may-dev-63.md`).
7. Pipeline ivr `eca6670f`: Retry `publish_images`, `publish_aux_images` (đỏ vì Docker máy Lead treo 13/11, chạy lại sẽ lên .63); `pii_scan` đỏ thật.
8. Lưu ý: ngoại lệ JWT ops-core hết **15/11 16:59Z** → pipeline main ops-core đỏ tới khi xong WP20 (phiên M1-2 chính).

## Phiên phụ — brief để mở lại (start_session, context fresh)

### 1. `lead-nen-99` — hạ tầng .99/.98/.63 (cwd `C:\Projects\Project Control`)
Phiên `lead` phụ trách máy chủ. Đọc `chung/MAY_CHU.md`, `may-chu/KIEM_KE_MAY_CHU.md`, `may-chu/2026-11-11-ten-mien-may-chu-chinh-thuc.md`, quyết định D-lead-034…041.
Còn: theo dõi Anh Tuấn trỏ tên miền + HTTPS (ginsengfood.vn, www, /admin → .99:80; ops/pwa/trace → .99:8012; mkt → .98:80 theo D-lead-041);
gỡ dòng "tạm" trong `cong-noi-bo.conf` khi cả ba luồng đã ở .99; theo dõi runner `may-63` (`/home/ssv/dev/gitlab-runner/runner-63.sh kiem`).
Không dùng mật khẩu máy; vào bằng khoá. Không đổi cổng vào khi Toàn chưa nói.

### 2. `m12-chuyen-99` — CI ops-core sang Linux trên .63 (D-lead-040)
Phiếu `modules/m12/wp/ci-linux-63.md`, nhật ký `modules/m12/nhat-ky/2026-11-14-ci-linux-63.md`. Toàn đã chọn m12.c6 B, c7 A; nền CI Linux đã sửa (chưa commit),
9 job đầu đạt trên .63; chờ m12.c8 (SAST). Luật phiên PHỤ: chỉ `.gitlab-ci.yml`, `tools/ci/`, tài liệu CI; sửa thẳng `main` theo PHIEN.md, add theo đường dẫn;
thử bằng container trên .63 trước khi push; push gom một đợt hỏi Toàn. Xong khi pipeline main xanh trọn trên `may-63`, rồi báo phiên lead tạm dừng `ops-core-win`.
Việc cũ: `deploy-99` chờ pipeline xanh; .61 dừng hẳn, giữ làm đường lui; sao lưu ngoài máy 23:30 trỏ .99.

### 3. `m34-chuyen-99` — gói M3/M4/M9 trên .99
Đã chạy trên .99 từ 07:36, E06-A đạt (đơn 578 tự huỷ, M8 thu hồi). Còn pha C (chờ Anh Tuấn trỏ tên miền, rồi kiểm chỉ đọc) và pha D (dừng hẳn .60).
Commit `0eeeb60e5` trên `toandeptrai` chờ Toàn duyệt push (sau push kiểm `kiem-tra-khuon` xanh). Việc M3-181 phía Toàn: `hop-thu/m34-2026-11-13-m3-181-phia-toan.md`
(khối nginx `/by-code/` chỉ .98 GET; 2 biến `be.environment`; cửa TLS nội bộ cho M5 gọi M4/M3). Anh Mạnh đã nghỉ: không soạn tin cho anh Mạnh.

### 4. `m8-chuyen-99` — app M8 trên .99
M8 chạy trên .99 từ 07:46, M3 ↔ M8 thông hai chiều, sao lưu 02:30. Bước `d` (dừng hẳn M8 trên .61) sau callback ACCEPTED với đơn thử.
W-0538 xong (2 commit chưa push). CI ivr chạy trên `may-63`. Pipeline `eca6670f`: retry 2 job publish khi Toàn cho; `pii_scan` có thể do quét nhầm artifact `dotnet` hỏng 09:22.

### 5. `m7-tren-63` — M7 trên máy dev (target ssh, host `may-63`, cwd `~/dev/ginsengfood-golden-hour-video`)
Chỉ phiên này sửa mã M7. Gói bàn giao `~/dev/ban-giao-m7`. T221 `5609ed1`, T076d `9ca04ca` đã commit (chưa push); T085 chờ verifier R2 rồi commit.
T190 (video thật) cần Muse/Chrome/VieNeu/faster-whisper/ffmpeg ở máy Lead — không làm trên .63. Push chỉ khi Toàn nói "push" trong phiên này (remote `github-m7`).
Báo SHA sau mỗi commit cho phiên `M7` máy Lead (giữ sổ `modules/m7/`). Máy dùng chung runner CI: `-m:4`, không prune, không động `stg_*`.

## Phiên chính của các luồng (của Toàn, mở bằng `/phien <mã>`)
M1-2 (`m12`), M3-4 (`m34`), M5 (`m5`), M6 (`m6`), M7 (`m7` — chỉ giữ sổ, không sửa mã M7), M8 (`m8`). Mỗi phiên tự đọc `PHIEN.md`, `TRANG_THAI.md` và hộp thư.
