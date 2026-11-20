# Chay API localhost:5000 voi dang nhap mail cong ty BAT, de thu tren may Toan (M12-WP26).
# Tep nay KHONG chua bi mat: mat khau SMTP duoc hoi luc chay (go khong hien), khoa OTP tu sinh ngau nhien moi lan.
# Ca hai chi nam trong bien moi truong cua tien trinh API nay va bi xoa khi API dung. Khong ghi ra dia.
# Cach dung: Ctrl+C API cu o cong 5000 (neu con), mo PowerShell moi, chay tep nay, giu cua so mo.
$ErrorActionPreference = 'Stop'
$repo = 'C:\Projects\ginsengfood-ops-core'

if (Get-NetTCPConnection -State Listen -LocalPort 5000 -ErrorAction SilentlyContinue) {
    throw 'Cong 5000 dang co tien trinh khac. Ctrl+C no truoc roi chay lai.'
}

$smtpUser = Read-Host 'Tai khoan SMTP (Enter = no-reply@ssavigroup.com)'
if ([string]::IsNullOrWhiteSpace($smtpUser)) { $smtpUser = 'no-reply@ssavigroup.com' }
$secure = Read-Host 'Mat khau SMTP cua hop no-reply (go o day, khong hien ra)' -AsSecureString
$plain = [System.Net.NetworkCredential]::new('', $secure).Password
if ([string]::IsNullOrEmpty($plain)) { throw 'Chua nhap mat khau SMTP.' }

$bytes = New-Object byte[] 48
[System.Security.Cryptography.RandomNumberGenerator]::Fill($bytes)

$names = @(
    'Auth__EmailLogin__Enabled', 'Auth__EmailLogin__OtpHmacKey',
    'Auth__EmailLogin__Smtp__Host', 'Auth__EmailLogin__Smtp__Port', 'Auth__EmailLogin__Smtp__Security',
    'Auth__EmailLogin__Smtp__Username', 'Auth__EmailLogin__Smtp__Password'
)
try {
    $env:Auth__EmailLogin__Enabled = 'true'
    $env:Auth__EmailLogin__OtpHmacKey = [Convert]::ToBase64String($bytes)
    $env:Auth__EmailLogin__Smtp__Host = 'pro56.emailserver.vn'
    $env:Auth__EmailLogin__Smtp__Port = '465'
    $env:Auth__EmailLogin__Smtp__Security = 'SslOnConnect'
    $env:Auth__EmailLogin__Smtp__Username = $smtpUser
    $env:Auth__EmailLogin__Smtp__Password = $plain

    Set-Location $repo
    # Giong cach ban vua chay: profile http (Development, http://localhost:5000).
    dotnet run --project services/operational-api/src/Ginsengfood.Operational.Api/Ginsengfood.Operational.Api.csproj --launch-profile http
}
finally {
    foreach ($n in $names) { Remove-Item "Env:$n" -ErrorAction SilentlyContinue }
    $plain = $null
}
