# r-m5-cua-99.sh (.99): m34.100 (D-m34-076). Bật cửa TLS 8446 cho M5 (.98): sinh chứng thư (giữ CA nếu đã có), thêm compose.m5-cua.yml
# vào COMPOSE_FILE của .env (sao lưu .env trước, chỉ sửa đúng dòng COMPOSE_FILE, không in giá trị khác), up m5cua-nginx, kiểm TLS trên máy.
# Tường lửa (DOCKER-USER, /etc/ginsengfood/cong-noi-bo.conf) cần sudo: Toàn làm sau bước này; tới lúc đó LAN không vào được 8446 (đóng mặc định).
cd "$G"
[ -f compose.m5-cua.yml ] && [ -f m5-cua/tao-chung-thu-m5-cua.sh ] || dung "chưa có compose.m5-cua.yml / m5-cua/ (chạy cap-nhat-99.sh trước)"
[ -L .env ] && dung ".env là liên kết, không sửa"
echo "M1 sinh chứng thư cửa (không in khoá)"
bash m5-cua/tao-chung-thu-m5-cua.sh < /dev/null 2>&1 | sed 's/^/  /'
[ -s m5-cua/bi-mat/ca-m5-cua.pem ] && [ -s m5-cua/bi-mat/m5-cua.pem ] || dung "thiếu chứng thư sau khi sinh"
echo "M2 thêm compose.m5-cua.yml vào COMPOSE_FILE (.env)"
SL="$G/_chuyen-may/env.tu-truoc-m5cua-$(date -u +%Y%m%dT%H%M%SZ)"
cp -p .env "$SL"; chmod 600 "$SL"
echo "  trước: $(doc_env COMPOSE_FILE)"
if ! doc_env COMPOSE_FILE | grep -q 'compose\.m5-cua\.yml'; then
  sed -i '/^COMPOSE_FILE=/{/compose\.m5-cua\.yml/!s/$/:compose.m5-cua.yml/}' .env
fi
echo "  sau:   $(doc_env COMPOSE_FILE)"
if ! docker compose config -q 2>/dev/null; then cp -p "$SL" .env; dung "compose config hỏng sau khi thêm lớp phủ; đã trả .env"; fi
echo "M3 up m5cua-nginx"
docker compose up -d --no-build --wait m5cua-nginx 2>&1 | tail -n 6 | sed 's/^/  /' || { cp -p "$SL" .env; dung "cửa không lên khoẻ; đã trả .env (container cửa còn đó để xem: docker compose logs m5cua-bi-mat m5cua-nginx)"; }
docker compose ps -a --format '  {{.Service}} {{.State}} {{.Status}}' m5cua-bi-mat m5cua-nginx
echo "  cổng 192.168.1.99:8446: $(ss -ltnH | awk '{print $4}' | grep -c '^192.168.1.99:8446$' | sed 's/^0$/KHÔNG nghe/;s/^1$/đang nghe/')"
echo "M4 kiểm TLS trên máy .99 (không qua LAN)"
v=$(openssl s_client -connect 192.168.1.99:8446 -servername 192.168.1.99 -CAfile m5-cua/bi-mat/ca-m5-cua.pem -verify_return_error < /dev/null 2>/dev/null | grep -E 'Verify return code' | head -n 1)
echo "  chuỗi chứng thư: ${v:-không đọc được}"
echo "  GET từ máy .99 (không phải .98, phải 403): $(curl -s -m 5 --cacert m5-cua/bi-mat/ca-m5-cua.pem -o /dev/null -w '%{http_code}' https://192.168.1.99:8446/api/v1/internal/orders/by-code/GF-TEST-9999/channel-state || echo 000)"
echo "  vân tay SHA-256 CA: $(openssl x509 -in m5-cua/bi-mat/ca-m5-cua.pem -noout -fingerprint -sha256 | cut -d= -f2)"
echo "  tệp CA công khai: $G/m5-cua/bi-mat/ca-m5-cua.pem ($(stat -c %s m5-cua/bi-mat/ca-m5-cua.pem) byte)"
echo "  tường lửa: dòng có 8446 trong cong-noi-bo.conf: $(grep -cE '(^|[^0-9])8446([^0-9]|$)' /etc/ginsengfood/cong-noi-bo.conf 2>/dev/null || echo '?')"
echo "M5_CUA_BAT_XONG (sao lưu .env: ${SL#$G/})"
