<#
  m7-heavy.ps1 - cua cho lenh nang cua luong M7 (D-m7-079, 13/11/2026).

  Dung:
    pwsh -NoProfile -File "C:\Projects\Project Control\modules\m7\tools\m7-heavy.ps1" -Label <nhan> -Command '<lenh>'

  Lam gi:
    1. Toi da $Slots (mac dinh 2) lenh nang cung luc trong CA luong M7: xin mot trong hai tep khoa
       C:\Projects\_wt\m7\.heavy-locks\slot0.lock, slot1.lock (mo doc quyen, he dieu hanh tu nha khi tien trinh chet).
       Het cho thi doi toi da $MaxSlotWaitMin phut, quá han thoat ma 98.
    2. Doi den khi TIME_WAIT < $MaxTimeWait va RAM trong >= $MinFreeGb GB (toi da $MaxResourceWaitMin phut,
       qua han chay tiep va noi ro; do hang loat vi cong thi chay lai RIENG ca do).
    3. Ha uu tien tien trinh nay xuong BelowNormal (tien trinh con ke thua), dat MSBUILDDISABLENODEREUSE=1 va
       DOTNET_CLI_USE_MSBUILD_SERVER=0, chay lenh, tra ma thoat cua lenh.
  Lenh nang: dotnet build, dotnet test, vitest, tsc/eslint tren ca web, lenh dot bien, che do cong cu that
  (VieNeu, faster-whisper, ffmpeg). Lenh nhe (git, grep, python docs/_tools, doc tep) KHONG can qua cua.
#>
param(
    [Parameter(Mandatory = $true)][string]$Label,
    [Parameter(Mandatory = $true)][string]$Command,
    [int]$Slots = 2,
    [int]$MaxSlotWaitMin = 60,
    [int]$MinFreeGb = 3,
    [int]$MaxTimeWait = 4000,
    [int]$MaxResourceWaitMin = 10
)

$ErrorActionPreference = 'Stop'
$dir = 'C:\Projects\_wt\m7\.heavy-locks'
New-Item -ItemType Directory -Force -Path $dir | Out-Null

function Say([string]$message) {
    Write-Host ('[m7-heavy {0}] {1}' -f (Get-Date -Format 'HH:mm:ss'), $message)
}

$stream = $null
$slot = -1
$deadline = (Get-Date).AddMinutes($MaxSlotWaitMin)
$announced = $false
while ($true) {
    for ($i = 0; $i -lt $Slots; $i++) {
        try {
            $stream = [System.IO.File]::Open("$dir\slot$i.lock", [System.IO.FileMode]::OpenOrCreate,
                [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None)
            $slot = $i
            break
        }
        catch {
            $stream = $null
        }
    }
    if ($null -ne $stream) { break }
    if ((Get-Date) -gt $deadline) {
        Say "Het $MaxSlotWaitMin phut van khong co cho ($Slots cho da day): thoat 98."
        exit 98
    }
    if (-not $announced) {
        $holders = (Get-ChildItem -Path $dir -Filter 'slot*.info' -ErrorAction SilentlyContinue |
            ForEach-Object { (Get-Content -Raw -Path $_.FullName -ErrorAction SilentlyContinue).Trim() }) -join ' | '
        Say "Doi cho ($Slots cho dang day). Dang giu: $holders"
        $announced = $true
    }
    Start-Sleep -Seconds 15
}

$infoPath = "$dir\slot$slot.info"
$code = 0
try {
    Set-Content -Path $infoPath -Value ("{0} pid={1} tu {2:HH:mm}" -f $Label, $PID, (Get-Date)) -Encoding utf8

    $gateEnd = (Get-Date).AddMinutes($MaxResourceWaitMin)
    while ($true) {
        $timeWait = (Get-NetTCPConnection -State TimeWait -ErrorAction SilentlyContinue | Measure-Object).Count
        $freeGb = [math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1MB, 1)
        if ($timeWait -lt $MaxTimeWait -and $freeGb -ge $MinFreeGb) { break }
        if ((Get-Date) -gt $gateEnd) {
            Say "Van thieu tai nguyen sau $MaxResourceWaitMin phut (TIME_WAIT=$timeWait, RAM trong=$freeGb GB): chay tiep."
            break
        }
        Say "Doi tai nguyen: TIME_WAIT=$timeWait (can duoi $MaxTimeWait), RAM trong=$freeGb GB (can tu $MinFreeGb GB)."
        Start-Sleep -Seconds 30
    }

    (Get-Process -Id $PID).PriorityClass = 'BelowNormal'
    $env:MSBUILDDISABLENODEREUSE = '1'
    $env:DOTNET_CLI_USE_MSBUILD_SERVER = '0'
    Say "Chay [$Label] o cho $slot (uu tien BelowNormal): $Command"
    $global:LASTEXITCODE = 0
    Invoke-Expression $Command
    $code = $LASTEXITCODE
    if ($code -eq 0 -and -not $?) { $code = 1 }
}
catch {
    Say ("Loi: " + $_.Exception.Message)
    $code = 1
}
finally {
    Remove-Item -Path $infoPath -ErrorAction SilentlyContinue
    if ($null -ne $stream) { $stream.Dispose() }
}
Say "Xong [$Label], ma thoat $code."
exit $code
