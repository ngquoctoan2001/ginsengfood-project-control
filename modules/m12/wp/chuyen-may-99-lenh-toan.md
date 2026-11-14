# Lệnh cho Toàn — khoá CD .99 và sao lưu ngoài máy (một lượt) · 13/11/2026, sửa 14/11

Soạn từ runbook `ginsengfood-ops-core/docs/runbooks/release/13-11-15-00-chuyen-m12-sang-99-runbook.md` §6 và runbook 152 §10.2.
Phiên không đọc, không in khoá riêng. Khoá để cạnh khoá CD .61 (`$HOME\.ssh\m12-cd-61\m12_cd_61`): thư mục `$HOME\.ssh\m12-cd-99\`
(14/11: `C:\GinsengfoodKeys` bị từ chối vì PowerShell không nâng quyền). Mọi lệnh dưới đây chạy trong PowerShell trên máy Windows, KHÔNG trong ssh .99.

## 1. Tạo khoá CD .99
```powershell
New-Item -ItemType Directory -Force "$HOME\.ssh\m12-cd-99" | Out-Null; ssh-keygen -t ed25519 -C m12-cd-99 -f "$HOME\.ssh\m12-cd-99\m12_cd_99"
```
Hỏi passphrase thì Enter hai lần (để trống — runner GitLab không nhập được).

## 2. Kiểm sshd .99 — ĐẠT (14/11, Toàn chạy)
`acceptenv LANG`, `acceptenv LC_*`, `permituserenvironment no`, không có khối `Match` → biến môi trường không lách được forced command.

## 3. Thêm forced command trên .99 — ĐÃ XONG 14/11 07:43 (Toàn duyệt "ok m12.c3")
Đã thêm 1 dòng; thử `thu` và không lệnh đều ra mã 2 `M12_CD_ENTRY_REJECTED` (khoá không mở được shell). Lưu ý: `.pub` do `ssh-keygen` Windows
tạo có CRLF → `cai_khoa_cd_99` từ chối; chạy với bản bỏ `\r` (`tr -d '\r' < m12_cd_99.pub > ban-lf.pub`).
```bash
bash deploy/m12/chuyen-99/chuyen-99.sh khoa-cd-99 --khoa-cong-khai "$HOME/.ssh/m12-cd-99/m12_cd_99.pub" --thuc-hien
```
Thêm đúng một dòng `restrict,command="/data/ginsengfood-ops-core/cd-entry.sh" ssh-ed25519 … m12-cd-99` vào `~ssv/.ssh/authorized_keys`.
Thử (phải ra mã **2** và chữ `M12_CD_ENTRY_REJECTED`):
```powershell
ssh -i "$HOME\.ssh\m12-cd-99\m12_cd_99" -o IdentitiesOnly=yes -o BatchMode=yes ssv@192.168.1.99 thu; "ma=$LASTEXITCODE"
```

## 4. Biến GitLab (Settings → CI/CD → Variables)
**14/11:** `M12_99_KNOWN_HOSTS` ĐÃ TẠO (phiên, Chrome: File, Protected, scope `m12-99`, vân tay đối khớp). `M12_CD_FROM_MAIN` đã có sẵn = `true`
(không Protected, mọi môi trường) → không tạo lại. `main` là nhánh protected → biến Protected vào được job. `M12_99_SSH_KEY`: Toàn đã thêm 14/11 (form phiên điền sẵn
(File, Protected, `m12-99`, Visible — khoá nhiều dòng không Masked được), Toàn chạy lệnh chép khoá riêng vào clipboard, dán vào ô Value, bấm Add variable).
(`ssh-keyscan` của Windows không bắt tay được với .99 — dùng dòng có sẵn trong `known_hosts` của máy Lead.)
Tạo tệp known_hosts và xem vân tay (phải là `SHA256:zTo/9BJ89nJdr4Vo0IH7lUdIuOYVomjLXI6LNWb5Oog`):
```powershell
ssh-keyscan -t ed25519 192.168.1.99 2>$null | Set-Content -Encoding ascii "$HOME\.ssh\m12-cd-99\known_hosts_99"; ssh-keygen -lf "$HOME\.ssh\m12-cd-99\known_hosts_99"
```
| Biến | Kiểu | Scope | Protected | Giá trị |
|---|---|---|---|---|
| `M12_99_SSH_KEY` | File | `m12-99` | có | nội dung khoá riêng: `Get-Content "$HOME\.ssh\m12-cd-99\m12_cd_99" -Raw \| Set-Clipboard` rồi dán |
| `M12_99_KNOWN_HOSTS` | File | `m12-99` | có | `Get-Content "$HOME\.ssh\m12-cd-99\known_hosts_99" -Raw \| Set-Clipboard` rồi dán |
| `M12_CD_FROM_MAIN` | Variable | tất cả | có | `true` (nếu chưa đặt; bật nút `deploy-99` trên main) |

## 5. Sao lưu ngoài máy — XONG 14/11 08:05 (Toàn chọn phương án A: máy Lead)
Tác vụ cũ (03/11) hỏng: gọi tệp `.artifacts/...run-offhost-backup-task.ps1` đã bị xoá, trỏ .61. Toàn chạy `wp/dang-ky-sao-luu-ngoai-may-99.ps1` (admin):
tác vụ trỏ .99, 23:30, S4U, chạy thử kết quả 0. Bản 13/11 đã kéo (sha256 khớp). Khối lệnh gốc dưới đây để tham khảo.

### Khối lệnh gốc (PowerShell **Run as Administrator**)
```powershell
$script = 'C:\Projects\ginsengfood-ops-core\tools\db\Invoke-OpsPilotOffhostBackupPull.ps1'
$shell = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
$action = New-ScheduledTaskAction -Execute $shell `
  -Argument ('-NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -File "' + $script + '" -RemoteHost ssv@192.168.1.99 -RemoteDirectory /data/sao-luu/ginsengfood-ops-core/ops-pilot/daily') `
  -WorkingDirectory 'C:\GinsengfoodBackups'
$trigger = New-ScheduledTaskTrigger -Daily -At '23:30'
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType S4U -RunLevel Limited
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Minutes 30)
Register-ScheduledTask -TaskName 'Ginsengfood-Ops-Pilot-Offhost-Daily' -Action $action -Trigger $trigger `
  -Principal $principal -Settings $settings -Force `
  -Description 'D-lead-035/037: keo dump hang ngay cua .99 ve C:\GinsengfoodBackups\m12-ops-pilot-daily (23:30)'
Start-ScheduledTask -TaskName 'Ginsengfood-Ops-Pilot-Offhost-Daily'
Start-Sleep -Seconds 60; (Get-ScheduledTaskInfo -TaskName 'Ginsengfood-Ops-Pilot-Offhost-Daily').LastTaskResult   # phai 0
Get-Content 'C:\GinsengfoodBackups\m12-ops-pilot-daily\pull-log.jsonl' -Tail 1
```
Trên .99 đã có bản `ops-pilot-daily-20261113T132630Z-050c24b8` (PASS) để tác vụ kéo ngay.

## 6. Lần bấm `deploy-99` đầu tiên — CHƯA bấm
.99 đang chạy bản `87acc810` với compose WP16 (Development, chép y .61). Bản `main` mới hơn cần compose WP17 (Production, `secrets/`)
→ phiên m12 chính đưa WP17 lên `/data/ginsengfood-ops-core` rồi mới bấm. Pipeline `main` cũng phải xanh (test `ComposeSamples` đang đỏ,
phiên chính sửa) thì `build-images` mới chạy và kho mới có image.
