# r-kiem-99.sh: CHỈ ĐỌC trên .99.
echo "giờ máy: $(date '+%F %T %z') · múi $(timedatectl show -p Timezone --value 2>/dev/null || cat /etc/timezone 2>/dev/null)"
echo "địa chỉ: $(hostname -I) · nhóm: $(id -nG)"
if [ -L "$G" ]; then echo "$G: SYMLINK -> $(readlink "$G") (phải là thư mục thật)"
elif [ -d "$G" ]; then echo "$G: thư mục thật, chủ $(stat -c %U "$G"), quyền $(stat -c %a "$G"), $(ls -A "$G" | wc -l) mục"
else echo "$G: CHƯA CÓ (chờ Toàn chạy lệnh sudo mv của nền .99, D-lead-037)"; fi
if [ -e "$HOME/m34" ] || [ -L "$HOME/m34" ]; then echo "~/m34: CÒN trên .99 (D-lead-037 bỏ; kịch bản không dùng)"; else echo "~/m34: không có (đúng D-lead-037)"; fi
ls -ld /data /data/sao-luu "$SL99" 2>&1 | sed 's/^/  /' || true
echo "docker: $(docker version --format '{{.Server.Version}}' 2>&1) · compose: $(docker compose version --short 2>&1) · gốc dữ liệu: $(docker info --format '{{.DockerRootDir}}' 2>&1)"
df -h / /data 2>&1 | sed 's/^/  /' || true
echo "-- cổng đang nghe"
ss -ltnH 2>/dev/null | awk '{print $4}' | sort -u | sed 's/^/  /'
echo "-- container đang có"
docker ps -a --format '  {{.Names}} {{.State}} {{.Ports}}'
echo "-- volume m34_*: $(docker volume ls --format '{{.Name}}' | grep -c '^m34_' || true)"
echo "ghcr.io: $(ma_http https://ghcr.io/v2/) (401 = tới được, chờ đăng nhập)"
echo "tới .60:80 $(ma_http http://192.168.1.60/nginx-health) · .61:5000 $(curl -s -m 5 -o /dev/null -w '%{http_code}' http://192.168.1.61:5000/ 2>/dev/null || echo 000) · .99:5000 $(curl -s -m 5 -o /dev/null -w '%{http_code}' http://192.168.1.99:5000/ 2>/dev/null || echo 000)"
for c in openssl flock timeout sha256sum curl tar; do command -v "$c" >/dev/null || echo "THIẾU lệnh $c"; done
echo "crontab ssv: $(crontab -l 2>/dev/null | grep -vc '^#' || true) dòng"
echo "KIEM_99_XONG"
