# Mo lai 13 phien Claude cua Project Control sau khi doi tai khoan Claude (14/11/2026).
# Ban giao: modules/lead/ban-giao/2026-11-14-chuyen-tai-khoan.md
#
#   powershell -File "C:\Projects\Project Control\tools\mo_lai_phien.ps1"                 # bang 13 phien (id Desktop, id lich su, thu muc, co tep lich su khong)
#   powershell -File "C:\Projects\Project Control\tools\mo_lai_phien.ps1" -Mo 3           # mo lai phien so 3: claude --resume trong tab moi
#   powershell -File "C:\Projects\Project Control\tools\mo_lai_phien.ps1" -Mo 2,3,4,5     # mo nhieu phien
#   powershell -File "C:\Projects\Project Control\tools\mo_lai_phien.ps1" -Mo all
#   powershell -File "C:\Projects\Project Control\tools\mo_lai_phien.ps1" -NhapDesktop    # xem truoc: chep ban ghi phien sang thu muc Desktop cua tai khoan moi
#   powershell -File "C:\Projects\Project Control\tools\mo_lai_phien.ps1" -NhapDesktop -XacNhan   # chep that (chi them tep, khong ghi de, khong xoa)
#
# Lich su phien (tep .jsonl) nam tren may nay, khong gan voi tai khoan; claude --resume <id> dung duoc voi tai khoan moi.
# Phien so 7 (M7 tren .63) co lich su tren .63: tai khoan moi phai dang nhap Claude tren .63 mot lan (ssh -t ssv@192.168.1.63 "bash -lc claude", go /login).
param([string[]]$Mo = @(), [switch]$NhapDesktop, [switch]$XacNhan)

$PHIEN = @(
  @{So=1;  Nhom='lead';   Ten='Lead (fork) - dieu phoi';                  Local='local_690b40cd-88b2-4f24-9a93-780af402d5a7'; Cli='e90f04e2-b267-4404-a6e5-91e2597d33ae'; Cwd='C:\Projects\Project Control'; Ssh=''}
  @{So=2;  Nhom='phu';    Ten='lead - dung nen may 192.168.1.99';         Local='local_e7d5193b-3dfe-4276-8135-3099a2a0dafc'; Cli='7f9e1618-f77e-431d-adfe-9637e44c5f06'; Cwd='C:\Projects\Project Control'; Ssh=''}
  @{So=3;  Nhom='phu';    Ten='m12 phu - chuyen M1-M2, CI Linux .63';    Local='local_a2ba6f6c-2ebd-4dc5-adc6-6b22bc9290b3'; Cli='f215475d-6366-4982-b455-6b4135e1b6ba'; Cwd='C:\Projects\Project Control'; Ssh=''}
  @{So=4;  Nhom='phu';    Ten='m34 phu - goi M3/M4/M9 sang .99';          Local='local_54b466ed-461d-4058-be67-68df396859da'; Cli='c558a618-20e4-4355-a685-11bc382cb73c'; Cwd='C:\Projects\Project Control'; Ssh=''}
  @{So=5;  Nhom='phu';    Ten='m8 phu - app M8 sang .99';                 Local='local_4a116c00-1159-4ce5-a342-4746ce514d03'; Cli='4c3f1c8d-d2d6-43c9-95cd-28785ac97f1a'; Cwd='C:\Projects\Project Control'; Ssh=''}
  @{So=6;  Nhom='phu';    Ten='M8 - sua test chap chon bare-cr';          Local='local_8fd8fc64-ddef-4cce-aef1-6afcd755c77d'; Cli='88ce48ac-7d7e-4a97-9b90-de48e074c5dc'; Cwd='C:\Projects\Project Control'; Ssh=''}
  @{So=7;  Nhom='phu';    Ten='M7 tren .63 - T221, T076d, T085';          Local='local_5ce7e61c-6726-4789-8c59-02ee243194eb'; Cli='db97fd09-9d99-488b-be74-bf9ffe869ef2'; Cwd='~/dev/ginsengfood-golden-hour-video'; Ssh='ssv@192.168.1.63'}
  @{So=8;  Nhom='chinh';  Ten='M1-2 (m12)';                               Local='local_c2c32977-4e56-4b79-a4c6-c0dc69f4b6b8'; Cli='6b4be261-c086-4b8d-b8a0-d709823e1a2e'; Cwd='C:\Projects\Project Control'; Ssh=''}
  @{So=9;  Nhom='chinh';  Ten='M3-4 (m34)';                               Local='local_2efacb7e-721d-477a-9220-125c8f10fa18'; Cli='8d38bd21-896f-4bf1-b5a6-9e4d42febf01'; Cwd='C:\Projects\Project Control'; Ssh=''}
  @{So=10; Nhom='chinh';  Ten='M5 (m5)';                                  Local='local_19ccd510-b9c4-4a77-a672-33167981a8ad'; Cli='7c0b5c92-b669-448e-a45f-79b23111103a'; Cwd='C:\Projects\Project Control'; Ssh=''}
  @{So=11; Nhom='chinh';  Ten='M6 (m6)';                                  Local='local_c80bf97a-fafe-49f0-a27e-f3b1a0706ccd'; Cli='9268894f-5b58-4c99-9318-b4f29d286235'; Cwd='C:\Projects\Project Control'; Ssh=''}
  @{So=12; Nhom='chinh';  Ten='M7 (m7) - chi giu so';                     Local='local_c45f3895-8255-49c2-81da-5091c2bbf213'; Cli='5fa8b65e-84b9-44b6-ac6e-d123c6e95511'; Cwd='C:\Projects\Project Control'; Ssh=''}
  @{So=13; Nhom='chinh';  Ten='M8 (m8)';                                  Local='local_da399f74-764c-4378-a426-324aa6ae9461'; Cli='4916bdfb-d21d-426e-85db-f75a6e6ae5f2'; Cwd='C:\Projects\Project Control'; Ssh=''}
)

$lichSu = Join-Path $env:USERPROFILE '.claude\projects\C--Projects-Project-Control'
$desk   = Join-Path $env:APPDATA 'Claude\claude-code-sessions'

function Tim-BanGhi([string]$local) {
  Get-ChildItem $desk -Recurse -Filter "$local.json" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
}

if ($NhapDesktop) {
  # Thu muc cua tai khoan dang chay = cap thu muc <A>\<B> co tep sua gan nhat ma KHONG chua ban ghi phien so 1.
  $cu = (Tim-BanGhi $PHIEN[0].Local).Directory.FullName
  $moi = Get-ChildItem $desk -Directory | ForEach-Object { Get-ChildItem $_.FullName -Directory } |
         Where-Object { $_.FullName -ne $cu } | Sort-Object LastWriteTime -Descending | Select-Object -First 1
  if (-not $moi) { Write-Host "Chua thay thu muc cua tai khoan moi trong $desk. Mo Claude Desktop bang tai khoan moi, tao 1 phien bat ky, roi chay lai."; exit 1 }
  Write-Host "Thu muc cu : $cu"; Write-Host "Thu muc moi: $($moi.FullName) (sua luc $($moi.LastWriteTime))"
  if ($moi.LastWriteTime -lt (Get-Date).AddHours(-12)) {
    Write-Host "DUNG: thu muc 'moi' sua tu $($moi.LastWriteTime), khong phai cua tai khoan vua dang nhap. Mo Claude Desktop bang tai khoan moi, tao 1 phien bat ky, roi chay lai."; exit 1
  }
  foreach ($p in $PHIEN) {
    $src = Join-Path $cu "$($p.Local).json"; $dst = Join-Path $moi.FullName "$($p.Local).json"
    if (-not (Test-Path $src)) { Write-Host ("  {0,2} KHONG CO ban ghi cu" -f $p.So); continue }
    if (Test-Path $dst) { Write-Host ("  {0,2} da co o thu muc moi, bo qua" -f $p.So); continue }
    if ($XacNhan) { Copy-Item $src $dst; Write-Host ("  {0,2} da chep {1}" -f $p.So, $p.Ten) } else { Write-Host ("  {0,2} se chep {1}" -f $p.So, $p.Ten) }
  }
  if (-not $XacNhan) { Write-Host "Xem truoc xong. Chep that: them -XacNhan, roi khoi dong lai Claude Desktop." } else { Write-Host "Xong. Khoi dong lai Claude Desktop de thanh ben hien cac phien." }
  exit 0
}

if ($Mo.Count -eq 0) {
  $PHIEN | ForEach-Object {
    $co = if ($_.Ssh) { 'tren .63' } elseif (Test-Path (Join-Path $lichSu "$($_.Cli).jsonl")) { '{0} MB' -f [int]((Get-Item (Join-Path $lichSu "$($_.Cli).jsonl")).Length / 1MB) } else { 'THIEU' }
    [pscustomobject]@{ So=$_.So; Nhom=$_.Nhom; Ten=$_.Ten; LichSu=$co; Cli=$_.Cli }
  } | Format-Table -AutoSize | Out-String -Width 200 | Write-Host
  Write-Host "Mo lai: -Mo <so> | -Mo 2,3 | -Mo all.  Hien trong thanh ben Desktop: -NhapDesktop (xem truoc) roi -NhapDesktop -XacNhan."
  exit 0
}

$chon = if ($Mo -contains 'all') { $PHIEN } else { $PHIEN | Where-Object { $Mo -contains [string]$_.So } }
foreach ($p in $chon) {
  if ($p.Ssh) {
    $lenh = "ssh -t $($p.Ssh) `"bash -lc 'cd $($p.Cwd) && claude --resume $($p.Cli)'`""
  } else {
    $lenh = "Set-Location -LiteralPath '$($p.Cwd)'; claude --resume $($p.Cli)"
  }
  Write-Host ("Mo {0,2} {1}" -f $p.So, $p.Ten)
  if (Get-Command wt.exe -ErrorAction SilentlyContinue) {
    Start-Process wt.exe -ArgumentList @('-w', '0', 'new-tab', '--title', "p$($p.So) $($p.Nhom)", 'powershell', '-NoExit', '-Command', $lenh)
  } else {
    Start-Process powershell.exe -ArgumentList @('-NoExit', '-Command', $lenh)
  }
  Start-Sleep -Milliseconds 400
}
