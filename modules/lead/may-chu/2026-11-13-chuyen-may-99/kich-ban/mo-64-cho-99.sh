#!/usr/bin/env bash
# Mở cầu ARI .64 (18089) cho máy .99 giống .61 · phiên lead soạn 13/11/2026 · theo README m8 deploy/m8/may-99 mục 5.
# .64 là máy Asterisk của M8 (cầu ARI do luồng M8 dựng 15/10), ssv có nhóm sudo → Toàn tự chạy, không cần Anh Tuấn.
# CẦN ROOT, Toàn chạy từ máy mình:  ssh -t ssv@192.168.1.64 'sudo bash /tmp/gf-mo-64.sh 2>&1 | tee /tmp/gf-mo-64.log'
# Chỉ cộng thêm .99, giữ .61. Kiểm cấu hình mới trước khi áp; nạp lại nginx (không khởi động lại container). Chạy lại được.
set -euo pipefail
[ "$(id -u)" = 0 ] || { echo "Can chay bang sudo"; exit 1; }
CONF=/opt/ivr/ari-link-v1/nginx.conf
CT=ivr-ari-link-vm-ari-1
MOC=$(date +%Y%m%d%H%M%S)
TAM=$(mktemp)
trap 'rm -f "$TAM"' EXIT

echo "== truoc"
grep -nE '^[[:space:]]*(allow|deny|listen)' "$CONF"
docker ps --filter "name=^${CT}$" --format '{{.Names}} {{.Status}}'
DICH=$(docker inspect -f '{{range .Mounts}}{{if eq .Source "'"$CONF"'"}}{{.Destination}}{{end}}{{end}}' "$CT")
echo "mang=$(docker inspect -f '{{.HostConfig.NetworkMode}}' "$CT") conf_trong_container=$DICH"
[ -n "$DICH" ] || { echo "KHONG THAY CHO GAN nginx.conf - DUNG, bao phien lead"; exit 1; }

echo "== 1. nginx: them allow 192.168.1.99 ngay sau allow 192.168.1.61"
if grep -qE '^[[:space:]]*allow[[:space:]]+192\.168\.1\.99;' "$CONF"; then
  echo "da co .99 - bo qua"
else
  grep -qE '^[[:space:]]*allow[[:space:]]+192\.168\.1\.61;' "$CONF" \
    || { echo "KHONG THAY 'allow 192.168.1.61;' - DUNG, bao phien lead"; exit 1; }
  sed -E 's/^([[:space:]]*)allow[[:space:]]+192\.168\.1\.61;.*$/&\n\1allow 192.168.1.99;/' "$CONF" > "$TAM"
  diff "$CONF" "$TAM" || true
  # Container chỉ đọc (13/11: docker cp bị từ chối) → ghi tại chỗ rồi `nginx -t`; nginx đang chạy giữ cấu hình cũ
  # trong bộ nhớ tới khi reload, nên kiểm lỗi thì trả bản cũ ngay, không reload, không ảnh hưởng .61.
  cp -a "$CONF" "$CONF.truoc-$MOC"
  cat "$TAM" > "$CONF"   # ghi tại chỗ, giữ inode: container gắn tệp đơn lẻ thấy ngay
  if ! docker exec "$CT" nginx -t; then
    cat "$CONF.truoc-$MOC" > "$CONF"; echo "CAU HINH MOI LOI - DA TRA LAI BAN CU, CHUA RELOAD, bao phien lead"; exit 1
  fi
  docker exec "$CT" nginx -s reload
fi

echo "== 2. tuong lua .64 (chi them neu .61 dang co dong rieng cho 18089)"
ufw status | grep -E 'Status|18089' || true
iptables -S | grep -E '18089' || true
if ufw status | grep -E '18089' | grep -q '192\.168\.1\.61'; then
  ufw status | grep -E '18089' | grep -q '192\.168\.1\.99' \
    || ufw allow in on eth0 proto tcp from 192.168.1.99 to 192.168.1.64 port 18089 comment 'M8 .99 -> cau ARI'   # 13/11 bản chạy thật dùng dạng rộng hơn (mọi đích/giao diện, chỉ .99 cổng 18089)
else
  echo "ufw khong co dong rieng cho .61 o 18089 - khong them"
fi

echo "== sau"
grep -nE '^[[:space:]]*(allow|deny)' "$CONF"
ufw status | grep -E '18089' || true
docker ps --filter "name=^${CT}$" --format '{{.Names}} {{.Status}}'
echo "MO-64 XONG $(date -Is)"
