#!/usr/bin/env bash
# Pha 2c · .99 · dời kho image containerd vào /data (Anh Tuấn: "all dữ liệu đặt trong /data để tiện backup và expand") · D-lead-037.
# Docker 29 dùng kho image containerd (giống .60/.61): image + lớp đĩa container nằm ở thư mục gốc của containerd,
# mặc định /var/lib/containerd (ổ gốc), không theo data-root. Dời về /data/containerd, giữ nguyên kiểu kho.
# CẦN ROOT, Toàn chạy: sudo bash /tmp/gf-pha2c.sh 2>&1 | tee /tmp/gf-pha2c.log
set -euo pipefail
[ "$(id -u)" = 0 ] || { echo "Can chay bang sudo"; exit 1; }
MOC=$(date +%Y%m%d%H%M%S)
CFG=/etc/containerd/config.toml

if [ -n "$(docker ps -q)" ]; then echo "DANG CO CONTAINER CHAY - DUNG, bao phien lead"; docker ps; exit 1; fi

echo "== truoc"
du -sh /var/lib/containerd 2>/dev/null || true
grep -vE '^[[:space:]]*(#|$)' "$CFG" || true

cp -a "$CFG" "$CFG.truoc-$MOC"
systemctl stop docker.socket docker containerd

if [ -d /var/lib/containerd ] && [ ! -e /data/containerd ]; then
  mv /var/lib/containerd /data/containerd
fi
install -d -m 700 -o root -g root /data/containerd
if ! grep -qE '^[[:space:]]*root[[:space:]]*=' "$CFG"; then
  sed -i '1i root = "/data/containerd"' "$CFG"
fi

systemctl start containerd docker
sleep 2

echo "== sau"
grep -vE '^[[:space:]]*(#|$)' "$CFG"
containerd config dump 2>/dev/null | grep -E '^(root|state) '
ls -ld /var/lib/containerd /data/containerd 2>&1 || true   # 13/11: thiếu `|| true` làm set -e thoát sớm ở đây (các bước trước đã chạy)
docker info --format 'docker root={{.DockerRootDir}} driver={{.Driver}}'
systemctl is-active containerd docker gf-tuong-lua
iptables -S DOCKER-USER | head -3
echo "PHA2C XONG $(date -Is)"
