#!/usr/bin/env bash
# Ginsengfood · máy .99 · ĐO M3 (mạng Docker m34_app) gọi API M1–M2 qua 192.168.1.99:5000 (WP21, D-lead-058). Không đổi gì.
# Chạy: `sudo bash ~/kiem-m3-goi-m12-99.sh` (sudo để đọc iptables/ufw; không sudo vẫn chạy phần Docker).
# Việc duy nhất có tạo ra: một container curl tạm trong m34_app, tự xoá (--rm).
#
# Vì sao phải đo: gf-tuong-lua.sh chỉ lọc kết nối MỚI đi vào từ eth0 (LAN); gói đi từ cầu Docker (m34_app) được RETURN ngay,
# nên bảng cong-noi-bo.conf KHÔNG chặn M3 → 5000. Nếu vẫn không tới thì chặn ở chỗ khác:
#   (a) docker-proxy (userland-proxy) nhận gói ở INPUT → ufw chặn nguồn 172.24.2.0/24 → mở bằng ufw (như luật 18088 của M8);
#   (b) Docker cách ly hai mạng cầu (DOCKER-ISOLATION) sau khi DNAT → cho qua bằng ACCEPT trong DOCKER-USER (sửa gf-tuong-lua.sh).
set -u
NET=${NET:-m34_app}
DICH=${DICH:-192.168.1.99:5000}
IMG=curlimages/curl:8.11.1

echo "== Mang $NET"
docker network inspect "$NET" --format '{{range .IPAM.Config}}subnet {{.Subnet}} gateway {{.Gateway}}{{end}} · driver {{.Driver}} · id {{printf "%.12s" .Id}}' || exit 1
docker network inspect "$NET" --format '{{range .Containers}}  {{.Name}} {{.IPv4Address}}{{"\n"}}{{end}}'
echo "== userland-proxy (daemon.json)"
grep -o '"userland-proxy"[^,}]*' /etc/docker/daemon.json 2>/dev/null || echo "  khong khai -> mac dinh BAT"
echo "== Ai nghe cong 5000"
ss -ltnp 2>/dev/null | grep -E ':5000[[:space:]]' || ss -ltn | grep -E ':5000[[:space:]]'

echo "== Thu goi tu $NET -> http://$DICH/health/live (cho 200)"
MA=$(docker run --rm --network "$NET" "$IMG" -s -o /dev/null -m 6 -w '%{http_code}' -H 'Host: api-ops.ginsengfood.vn' "http://$DICH/health/live" 2>/dev/null || true)
echo "  ket qua: ${MA:-000}"

if [ "$(id -u)" = 0 ]; then
  echo "== DOCKER-USER"; iptables -S DOCKER-USER
  echo "== Cach ly mang Docker"
  iptables -S DOCKER-ISOLATION-STAGE-1 2>/dev/null | head -20
  iptables -S DOCKER-ISOLATION-STAGE-2 2>/dev/null | head -20
  echo "== DNAT cong 5000"; iptables -t nat -S DOCKER 2>/dev/null | grep -- '--dport 5000' || true
  echo "== ufw"; ufw status numbered 2>/dev/null | head -40
else
  echo "== (bo qua iptables/ufw: chay lai bang sudo de xem)"
fi

case "${MA:-000}" in
  200) echo "KET LUAN: DA TOI DUOC - khong can mo tuong lua" ;;
  000) echo "KET LUAN: KHONG TOI (het gio/tu choi) - xem muc ufw va cach ly o tren de chon cach mo (a) hoac (b)" ;;
  *)   echo "KET LUAN: TOI DUOC nhung ma ${MA} - kiem Host/AllowedHosts/allowlist phia M12, khong phai tuong lua" ;;
esac
