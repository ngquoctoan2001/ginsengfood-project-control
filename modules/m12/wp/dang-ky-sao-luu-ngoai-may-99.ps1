# Dang ky lai tac vu sao luu ngoai may M1-M2: 23:30 moi toi keo ban sao luu moi nhat tu .99 ve may nay.
# Chay trong PowerShell "Run as Administrator". Ghi de tac vu cu (dang tro .61, goi tep da bi xoa).
$ErrorActionPreference = 'Stop'
$ten = 'Ginsengfood-Ops-Pilot-Offhost-Daily'
$script = 'C:\Projects\ginsengfood-ops-core\tools\db\Invoke-OpsPilotOffhostBackupPull.ps1'
if (-not (Test-Path -LiteralPath $script)) { throw "Khong thay $script" }
$shell = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
$action = New-ScheduledTaskAction -Execute $shell `
  -Argument ('-NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -File "' + $script + '" -RemoteHost ssv@192.168.1.99 -RemoteDirectory /data/sao-luu/ginsengfood-ops-core/ops-pilot/daily') `
  -WorkingDirectory 'C:\GinsengfoodBackups'
$trigger = New-ScheduledTaskTrigger -Daily -At '23:30'
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType S4U -RunLevel Limited
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Minutes 30)
Register-ScheduledTask -TaskName $ten -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force `
  -Description 'D-lead-035/037: keo ban sao luu hang ngay cua M1-M2 tu .99 ve C:\GinsengfoodBackups\m12-ops-pilot-daily (23:30)' | Out-Null
Write-Host "Da dang ky. Chay thu ngay..."
Start-ScheduledTask -TaskName $ten
Start-Sleep -Seconds 45
$i = Get-ScheduledTaskInfo -TaskName $ten
Write-Host ("Ket qua lan chay thu: " + $i.LastTaskResult + "  (0 = dat; 267009 = con dang chay, doi them roi xem lai)")
Write-Host ("Lan chay ke: " + $i.NextRunTime)
