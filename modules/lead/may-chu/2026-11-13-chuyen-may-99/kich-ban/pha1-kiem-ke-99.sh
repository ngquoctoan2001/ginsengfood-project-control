#!/usr/bin/env bash
# Pha 1 · kiểm kê CHỈ ĐỌC máy 192.168.1.99 (D-lead-035) · phiên lead 13/11/2026.
# Không sửa gì, không dùng mật khẩu (sudo -n chỉ hỏi "có sudo không cần mật khẩu không"),
# không đọc .env, khoá riêng, authorized_keys. Chạy từ máy Lead:
#   ssh -i ~/.ssh/id_ed25519 -o IdentitiesOnly=yes -o BatchMode=yes -o PasswordAuthentication=no \
#       -o KbdInteractiveAuthentication=no -o ConnectTimeout=10 ssv@192.168.1.99 'bash -s' < pha1-kiem-ke-99.sh
set -u
export LANG=C LC_ALL=C
s() { printf '\n== %s\n' "$1"; }
tcp() { if timeout 4 bash -c "</dev/tcp/$1/$2" 2>/dev/null; then echo "$1:$2 mo"; else echo "$1:$2 KHONG"; fi; }

s "may"
hostname; grep -E '^(PRETTY_NAME|VERSION_ID)=' /etc/os-release; uname -r; uptime
systemd-detect-virt 2>/dev/null

s "cpu-ram"
nproc; lscpu | grep -E '^Model name|^CPU\(s\)|^Hypervisor'; free -h

s "dia"
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT
df -hT -x tmpfs -x devtmpfs -x squashfs -x overlay

s "data"
if [ -e /data ]; then
  stat -c '%n chu=%U:%G quyen=%a' /data
  findmnt -T /data -o TARGET,SOURCE,FSTYPE,SIZE,AVAIL
  ls -la /data | head -20
else
  echo "KHONG CO /data"
fi

s "tai-khoan"
id
getent group sudo docker
if sudo -n true 2>/dev/null; then echo "SUDO_KHONG_MAT_KHAU=co"; else echo "SUDO_KHONG_MAT_KHAU=khong"; fi

s "docker"
if command -v docker >/dev/null; then
  docker --version
  docker compose version 2>&1 | head -1
  docker info --format 'server={{.ServerVersion}} root={{.DockerRootDir}} driver={{.Driver}}' 2>&1 | head -2
else
  echo "KHONG CO docker"
fi
command -v docker-compose >/dev/null && docker-compose --version
systemctl is-active docker containerd 2>&1
ls -l /etc/docker/daemon.json 2>&1
cat /etc/docker/daemon.json 2>/dev/null

s "gio"
timedatectl 2>&1 | grep -E 'Local time|Time zone|synchronized|NTP service'

s "mang"
ip -br addr
ip route | head -5
grep -E '^nameserver|^search' /etc/resolv.conf
resolvectl dns 2>/dev/null | head -3

s "cong-dang-nghe"
ss -ltnu | head -40

s "tuong-lua"
systemctl is-active ufw 2>&1
command -v ufw || echo "khong co ufw"

s "ra-ngoai"
for h in ghcr.io registry.gitlab.com gitlab.com download.docker.com archive.ubuntu.com; do
  printf '%s dns=' "$h"; getent hosts "$h" | awk '{print $1}' | head -1 | tr -d '\n'; printf ' '; tcp "$h" 443
done
if command -v curl >/dev/null; then
  for u in https://ghcr.io/v2/ https://registry.gitlab.com/v2/; do
    printf '%s http=' "$u"; curl -sS -o /dev/null -m 10 -w '%{http_code}\n' "$u" 2>&1 | tail -1
  done
else
  echo "khong co curl"
fi

s "noi-bo"
for hp in 192.168.1.60:22 192.168.1.60:80 192.168.1.60:443 192.168.1.61:22 192.168.1.61:5000 \
          192.168.1.61:8443 192.168.1.64:22 192.168.1.64:18089 192.168.1.98:22; do
  tcp "${hp%:*}" "${hp#*:}"
done
ping -c1 -W2 192.168.1.64 >/dev/null 2>&1 && echo "ping .64 ok" || echo "ping .64 KHONG"

s "nha-ssv"
ls -la ~ | head -30
ls ~/.ssh
crontab -l 2>&1 | head -5

s "dich-vu-dang-chay"
systemctl list-units --type=service --state=running --no-pager --no-legend | awk '{print $1}' | head -40

s "goi"
apt-cache policy docker-ce docker.io docker-compose-plugin 2>/dev/null | grep -E '^[a-z]|Installed|Candidate'
snap list 2>/dev/null | head -10

s "xong"
date -Is
