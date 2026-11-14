# r-kiem-60.sh: CHỈ ĐỌC trên .60. Không in .env (chỉ dòng tên không bí mật), không đọc khoá.
cd "$G"
echo "giờ máy: $(date '+%F %T %z')"
for k in M34_BAN M34_KHO COMPOSE_FILE M34_BIND_IP M3_CB_BIND_IP M3_CB_PORT M8_ALLOW_IP M8_ORIGIN OPS_CORE_ENABLED \
         OPS_CORE_GATE_ENFORCE OPS_CORE_BASE_URL OPS_CORE_ALLOW_PLAIN_HTTP CORS_ALLOWED_ORIGINS AUTH_COOKIE_SECURE POSTGRES_DB POSTGRES_USER; do
  printf '  %s=%s\n' "$k" "$(doc_env "$k")"
done
echo "-- PHIEN_BAN (3 dòng đầu)"; head -n 3 PHIEN_BAN 2>/dev/null || echo "  (không có)"
echo "-- tên trong ~/m34 và cỡ (không đọc nội dung)"
du -sh -- * .[!.]* 2>/dev/null | sort -k2 || true
echo "-- compose.override.yml (không có trong repo): khoá cấp 1–3 và số dòng có 192.168.1.60 (chỉ tên khoá, không giá trị)"
if [ -f compose.override.yml ]; then
  sed -n 's/^\( \{0,4\}\)\([A-Za-z0-9_.-]\{1,\}\):.*/  \1\2/p' compose.override.yml
  grep -n '192\.168\.1\.60' compose.override.yml | sed -n 's/^\([0-9]*\):[[:space:]-]*\([A-Za-z0-9_.-]*\).*/  dòng \1 có .60: khoá "\2"/p' || true
else
  echo "  (không có)"
fi
echo "-- tệp dump trong sao-luu/: $(find sao-luu -name '*.dump' 2>/dev/null | wc -l) tệp, $(du -sh sao-luu 2>/dev/null | cut -f1)"
echo "-- compose ps"
docker compose ps --format '  {{.Service}} {{.State}} {{.Health}} {{.Image}}'
echo "-- image be/fe đang chạy (Id)"
for c in m34-be-1 m34-fe-1; do printf '  %s %s\n' "$c" "$(docker inspect --format '{{.Image}}' "$c" 2>/dev/null || echo '?')"; done
echo "-- volume m34_*"
docker volume ls --format '{{.Name}}' | grep '^m34_' | sed 's/^/  /' || true
echo "-- cỡ volume"
docker system df -v 2>/dev/null | awk '/^m34_/ {print "  " $1, $NF}'
echo "-- tệp tải lên (m34_uploads) và thư OTP (m34_mail)"
for v in m34_uploads m34_mail; do printf '  %s %s\n' "$v" "$(ke_volume "$v" || true)"; done
echo "-- crontab ssv: dòng có m34"
crontab -l 2>/dev/null | grep -n 'm34' | sed 's/^/  /' || echo "  (không có)"
echo "-- khoá CD có command=cd-entry.sh trong authorized_keys: $(grep -c 'cd-entry.sh' "$HOME/.ssh/authorized_keys" 2>/dev/null || echo 0) dòng"
echo "-- health qua nginx .60"
printf '  /nginx-health %s · /api/health/ready %s · /vi %s · /admin %s\n' \
  "$(ma_http http://192.168.1.60/nginx-health)" "$(ma_http http://192.168.1.60/api/health/ready)" \
  "$(ma_http http://192.168.1.60/vi)" "$(ma_http http://192.168.1.60/admin)"
echo "-- số bảng / tổng dòng (đếm chính xác, chỉ số)"
dem_bang | awk -F '\t' '{b++; t+=$2} END {printf "  %d bảng, %d dòng\n", b, t}'
echo "-- cổng đang nghe (80, 8445)"
ss -ltnH 2>/dev/null | awk '{print $4}' | grep -E ':(80|8445)$' | sed 's/^/  /' || true
echo "KIEM_60_XONG"
