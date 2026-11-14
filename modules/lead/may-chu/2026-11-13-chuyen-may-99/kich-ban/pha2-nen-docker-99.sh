#!/usr/bin/env bash
# Pha 2 · nền Docker cho máy 192.168.1.99 (D-lead-035) · phiên lead soạn 13/11/2026.
# CẦN ROOT: Toàn (hoặc Anh Tuấn) tự chạy và tự gõ mật khẩu sudo; phiên Claude không dùng mật khẩu.
#   ssh -t ssv@192.168.1.99 'sudo bash ~/nen-99/pha2-nen-docker-99.sh 2>&1 | tee ~/nen-99/pha2.log'
# Làm: thư mục /data, daemon.json (data-root /data/docker), Docker CE + Compose từ kho chính thức,
# ssv vào nhóm docker, chặn cổng Docker chỉ cho đúng IP nội bộ (bảng cong-noi-bo.conf). Chạy lại được nhiều lần.
set -euo pipefail
[ "$(id -u)" = 0 ] || { echo "Can chay bang sudo"; exit 1; }
NGUOI=ssv
NHA=/home/$NGUOI
THU=$(cd "$(dirname "$0")" && pwd)
MOC=$(date +%Y%m%d%H%M%S)

echo "== 0. ufw truoc khi doi (chi in)"
ufw status verbose || true

echo "== 1. thu muc /data"
install -d -m 711 -o root -g root /data/docker
# Thu muc theo ten repo (D-lead-037), thu muc that, khong lien ket trong nha ssv.
for r in ginsengfood-ops-core ginsengfood-business-platform ginsengfood-ivr; do
  install -d -m 750 -o "$NGUOI" -g "$NGUOI" "/data/$r" "/data/sao-luu/$r"
done
chown "$NGUOI:$NGUOI" /data/sao-luu; chmod 750 /data/sao-luu
ls -la /data "$NHA"

echo "== 2. daemon.json (dat truoc khi cai de Docker khoi dong lan dau da dung /data/docker)"
install -d -m 755 /etc/docker
[ -e /etc/docker/daemon.json ] && cp -a /etc/docker/daemon.json "/etc/docker/daemon.json.truoc-$MOC"
cat > /etc/docker/daemon.json <<'JSON'
{
  "data-root": "/data/docker",
  "log-driver": "json-file",
  "log-opts": { "max-size": "50m", "max-file": "5" },
  "live-restore": true,
  "default-address-pools": [ { "base": "172.24.0.0/14", "size": 24 } ]
}
JSON

echo "== 3. Docker CE + Compose tu kho chinh thuc download.docker.com"
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y ca-certificates curl jq
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
. /etc/os-release
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $VERSION_CODENAME stable" \
  > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable --now containerd docker

echo "== 4. ssv vao nhom docker (co hieu luc tu lan dang nhap sau)"
usermod -aG docker "$NGUOI"

echo "== 5. chan cong Docker: chi mo cho dung IP trong /etc/ginsengfood/cong-noi-bo.conf"
install -d -m 755 /etc/ginsengfood
[ -e /etc/ginsengfood/cong-noi-bo.conf ] && cp -a /etc/ginsengfood/cong-noi-bo.conf "/etc/ginsengfood/cong-noi-bo.conf.truoc-$MOC"
install -m 644 "$THU/cong-noi-bo.conf" /etc/ginsengfood/cong-noi-bo.conf
install -m 755 "$THU/gf-tuong-lua.sh" /usr/local/sbin/gf-tuong-lua.sh
install -m 644 "$THU/gf-tuong-lua.service" /etc/systemd/system/gf-tuong-lua.service
systemctl daemon-reload
systemctl enable gf-tuong-lua.service
systemctl restart gf-tuong-lua.service
iptables -S DOCKER-USER

echo "== 5b. ufw: container goi dich vu chay mang host (M8 Asterisk S5: ARI 18088 tren gateway sandbox 172.29.0.1)"
# ufw chan INPUT; goi tu container toi IP host la INPUT, khong qua DOCKER-USER. Chi mo dung cong nay, chi tu dai container.
ufw allow proto tcp from 172.16.0.0/12 to any port 18088 comment 'M8 container -> ARI Asterisk S5 (mang host)'
ufw status verbose

echo "== 6. kiem"
docker --version
docker compose version
docker info --format 'root={{.DockerRootDir}} driver={{.Driver}} live-restore={{.LiveRestoreEnabled}} cgroup={{.CgroupVersion}}'
systemctl is-active docker containerd gf-tuong-lua
id "$NGUOI"
df -h /data
echo "PHA2 XONG $(date -Is)"
