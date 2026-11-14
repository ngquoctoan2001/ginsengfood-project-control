<#
  muse-dang-nhap.ps1 - mo cua so Chrome RIENG cua worker M7 de Toan tu dang nhap Muse bang tay (RU-16, D-m7-073).

  Dung (PowerShell thuong, khong can admin):
    pwsh -NoProfile -File "C:\Projects\Project Control\modules\m7\tools\muse-dang-nhap.ps1" -Url "<dia chi trang dang nhap Muse>"

  Lam gi: chi mo Chrome voi mot thu muc ho so rieng (khong phai Chrome ca nhan cua Toan) tai dia chi Toan dua vao.
  Khong doc, khong luu, khong gui email, mat khau, cookie. Chrome tu giu phien dang nhap trong thu muc ho so.

  Sau khi dang nhap xong:
    1. Thay trang tai khoan Muse (da dang nhap), lam thu thach chong may neu Muse hoi.
    2. DONG HET cua so Chrome nay (Chrome khong cho hai tien trinh dung chung mot thu muc ho so;
       worker se mo lai dung thu muc nay luc chay that).
    3. Bao phien m7: "da dang nhap Muse". Chi khi Toan noi ro "chay T189" thi moi co luot goi Muse that.
#>
param(
    [string]$Url = '',
    [string]$ProfileDir = (Join-Path $env:LOCALAPPDATA 'M7\muse-profile'),
    # Mo lai cac tab lan truoc (de Toan lay dia chi trang Muse tu thanh dia chi roi sao chep).
    [switch]$RestoreLastSession
)

$ErrorActionPreference = 'Stop'

# Khong co -Url thi Chrome mo trang moi; Toan tu go dia chi Muse trong cua so do.
if ($Url -ne '' -and $Url -notmatch '^https://[A-Za-z0-9.-]+(/[^\s]*)?$') {
    throw 'Url phai la dia chi https:// day du cua Muse (khong chua khoang trang).'
}

$chrome = Join-Path $env:ProgramFiles 'Google\Chrome\Application\chrome.exe'
if (-not (Test-Path -LiteralPath $chrome)) {
    throw "Khong thay Chrome o $chrome"
}

New-Item -ItemType Directory -Force -Path $ProfileDir | Out-Null

Write-Host "Mo Chrome voi ho so rieng cua worker M7."
Write-Host "Thu muc ho so: $ProfileDir"
Write-Host "Dang nhap Muse trong cua so vua mo, roi DONG HET cua so Chrome do."

$chromeArgs = @("--user-data-dir=$ProfileDir", '--no-first-run', '--no-default-browser-check')
if ($RestoreLastSession) { $chromeArgs += '--restore-last-session' }
if ($Url -ne '') { $chromeArgs += $Url }
Start-Process -FilePath $chrome -ArgumentList $chromeArgs
