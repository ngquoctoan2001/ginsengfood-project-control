<#
don_may_lap.ps1 - chay "don_may.ps1 -Dung -Ghi <log>" moi 30 phut (D-lead-031).
Thay cho Task Scheduler: may nay tu choi tao task khi khong nang quyen ("Access is denied" ca voi task rong).

  pwsh -File "C:\Projects\Project Control\tools\don_may_lap.ps1" -Cai   # tao loi tat Startup (tu bat khi dang nhap) + bat ngay
  pwsh -File "C:\Projects\Project Control\tools\don_may_lap.ps1" -Tat   # dung vong lap dang chay + xoa loi tat Startup
  (khong tham so) = chay vong lap; loi tat Startup goi kieu nay qua "conhost --headless" (khong cua so).

Log: %LOCALAPPDATA%\don_may\don_may.log (don_may.ps1 tu cat con 4000 dong khi qua 5000).
Mot ban duy nhat (mutex Local\GinsengfoodDonMayLap). don_may.ps1 bo qua moi tien trinh co "don_may" trong dong lenh.
#>
param([switch]$Cai, [switch]$Tat, [int]$Phut = 30)
$tool = Join-Path $PSScriptRoot 'don_may.ps1'
$self = $PSCommandPath
$log = Join-Path $env:LOCALAPPDATA 'don_may\don_may.log'
$lnk = Join-Path ([Environment]::GetFolderPath('Startup')) 'Ginsengfood-DonMay.lnk'
$pw = Join-Path $env:LOCALAPPDATA 'Microsoft\WindowsApps\pwsh.exe'   # alias, khong doi khi pwsh cap nhat
if (-not (Test-Path $pw)) { $pw = (Get-Command pwsh.exe).Source }
$conhost = Join-Path $env:SystemRoot 'System32\conhost.exe'
$argLap = "--headless `"$pw`" -NoProfile -NonInteractive -ExecutionPolicy Bypass -File `"$self`""

function Loops {
  @(Get-CimInstance Win32_Process -Filter "Name='pwsh.exe'" |
      Where-Object { $_.CommandLine -match 'don_may_lap\.ps1' -and $_.CommandLine -notmatch '\s-(Cai|Tat)\b' -and [int]$_.ProcessId -ne $PID })
}

if ($Tat) {
  foreach ($p in Loops) { Stop-Process -Id $p.ProcessId -Force -ErrorAction SilentlyContinue; "dung vong lap PID $($p.ProcessId)" }
  if (Test-Path $lnk) { Remove-Item $lnk -Force; "xoa loi tat $lnk" }
  return
}

if ($Cai) {
  $ws = New-Object -ComObject WScript.Shell
  $s = $ws.CreateShortcut($lnk)
  $s.TargetPath = $conhost
  $s.Arguments = $argLap
  $s.WindowStyle = 7
  $s.Description = 'Ginsengfood D-lead-031: don tien trinh bo quen moi 30 phut'
  $s.Save()
  "loi tat Startup: $lnk"
  $dang = Loops
  if ($dang.Count) { "vong lap da chay: PID $(($dang | ForEach-Object { $_.ProcessId }) -join ',')" }
  else { Start-Process -FilePath $conhost -ArgumentList $argLap -WindowStyle Hidden; "da bat vong lap" }
  return
}

# Vong lap
$mtx = [System.Threading.Mutex]::new($false, 'Local\GinsengfoodDonMayLap')
if (-not $mtx.WaitOne(0)) { return }
$dir = Split-Path -Parent $log
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
Add-Content -Path $log -Encoding utf8 -Value "$((Get-Date).ToString('dd/MM HH:mm')) don_may_lap: bat (PID $PID, moi $Phut phut)"
while ($true) {
  try { & $pw -NoProfile -NonInteractive -ExecutionPolicy Bypass -File $tool -Dung -Ghi $log | Out-Null }
  catch { Add-Content -Path $log -Encoding utf8 -Value "$((Get-Date).ToString('dd/MM HH:mm')) don_may_lap LOI: $($_.Exception.Message)" }
  Start-Sleep -Seconds ($Phut * 60)
}
