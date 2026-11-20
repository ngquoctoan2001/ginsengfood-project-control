# Chuan bi bien moi truong dang nhap mail cong ty tren .99 (M12-WP26). Chay tren may Toan, KHONG chay trong ssh.
# Tep nay KHONG chua bi mat. Mat khau SMTP duoc hoi o day (go khong hien), gui qua ssh bang stdin
# (khong nam tren dong lenh, khong ghi ra dia may nay). Khoa OTP tu sinh NGAU NHIEN ngay tren .99 va khong in ra.
# Ket qua: them 7 dong Auth__EmailLogin__* vao /data/ginsengfood-ops-core/.env tren .99 (chmod 600),
# co co Enabled=false. API dang chay KHONG doi (container cu khong doc .env cho toi khi duoc tao lai).
# Ban .env cu duoc sao thanh .env.truoc-wp26-<gio UTC>. Chay lai khi da co khoa thi script dung, khong ghi de.
$ErrorActionPreference = 'Stop'

$secure = Read-Host 'Mat khau SMTP cua hop no-reply@ssavigroup.com (go o day, khong hien ra)' -AsSecureString
$plain = [System.Net.NetworkCredential]::new('', $secure).Password
if ([string]::IsNullOrEmpty($plain)) { throw 'Chua nhap mat khau SMTP.' }
if ($plain -match "[\r\n']") { throw "Mat khau co ky tu xuong dong hoac dau nhay don ('): script nay khong ghi an toan duoc. Bao phien m12 de dung tep bi mat." }

$remote = @'
set -euo pipefail
cd /data/ginsengfood-ops-core
if grep -q '^Auth__EmailLogin__' .env; then echo 'DA_CO_Auth__EmailLogin trong .env: dung lai, khong ghi de.'; exit 3; fi
IFS= read -r PW
PW="${PW%$'\r'}"
[ -n "$PW" ] || { echo 'Khong nhan duoc mat khau.'; exit 4; }
KEY=$(openssl rand -base64 48 | tr -d '\n')
umask 077
cp -p .env ".env.truoc-wp26-$(date -u +%Y%m%dT%H%M%SZ)"
{
  echo ''
  echo '# M12-WP26: dang nhap bang mail cong ty + ma OTP. Chay Development nen nhan khoa qua .env; khi len WP17 Production chuyen 2 khoa sang tep bi mat.'
  echo 'Auth__EmailLogin__Enabled=false'
  echo "Auth__EmailLogin__OtpHmacKey='${KEY}'"
  echo 'Auth__EmailLogin__Smtp__Host=pro56.emailserver.vn'
  echo 'Auth__EmailLogin__Smtp__Port=465'
  echo 'Auth__EmailLogin__Smtp__Security=SslOnConnect'
  echo 'Auth__EmailLogin__Smtp__Username=no-reply@ssavigroup.com'
  echo "Auth__EmailLogin__Smtp__Password='${PW}'"
} >> .env
chmod 600 .env
echo "EMAIL_ENV_OK: $(grep -c '^Auth__EmailLogin__' .env) dong Auth__EmailLogin__ (gia tri khong in), Enabled=$(sed -n 's/^Auth__EmailLogin__Enabled=//p' .env)"
'@

try {
    $b64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes(($remote -replace "`r", '')))
    $plain | ssh -o BatchMode=yes ssv@192.168.1.99 "bash <(echo $b64 | base64 -d)"
    if ($LASTEXITCODE -ne 0) { throw "ssh/script tren .99 thoat ma $LASTEXITCODE" }
}
finally {
    $plain = $null
}
