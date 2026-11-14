# r-cors-99.sh (.99): thêm tên miền vào CORS_ALLOWED_ORIGINS để đăng nhập/POST qua https://ginsengfood.vn (+ www) không bị be từ chối
# (AuthCookieRequestGuard so Origin đúng danh sách; preflight Spring cũng vậy). Giữ http://192.168.1.99 cho LAN.
# Lưu .env cũ cạnh, tạo lại be (~1 phút, nginx :80 khởi động lại theo be), thử preflight OPTIONS (không ghi gì) cho từng nguồn; hỏng thì tự lùi.
cd "$G"
MOI='http://192.168.1.99,https://ginsengfood.vn,https://www.ginsengfood.vn'
thu() { curl -s -o /dev/null -m 8 -X OPTIONS -H "Origin: $1" -H 'Access-Control-Request-Method: POST' \
  -H 'Access-Control-Request-Headers: content-type' -w '%{http_code}' http://192.168.1.99/api/v1/auth/login || true; }
[ -n "$(docker compose ps -q --status running be)" ] || dung "be .99 không chạy"
cu=$(doc_env CORS_ALLOWED_ORIGINS)
echo "CORS_ALLOWED_ORIGINS hiện: ${cu:-(trống)} · preflight Origin https://ginsengfood.vn: $(thu https://ginsengfood.vn)"
ts=''
lui_lai() {
  [ -n "$ts" ] || return 0
  echo "-- TỰ LÙI: chép lại .env.truoc-cors-$ts, tạo lại be"
  cp -p -- ".env.truoc-cors-$ts" .env
  docker compose up -d --no-build --wait be || true
}
if [ "$cu" = "$MOI" ]; then
  echo "đã đúng, không sửa .env"
else
  ts=$(date -u +%Y%m%dT%H%M%SZ)
  cp -p -- .env ".env.truoc-cors-$ts"; chmod 600 ".env.truoc-cors-$ts"
  KHOA_RE='^(export[[:space:]]+)?CORS_ALLOWED_ORIGINS='
  if grep -Eq "$KHOA_RE" .env; then
    sed -i --follow-symlinks -E "s#${KHOA_RE}.*#\\1CORS_ALLOWED_ORIGINS=$MOI#" .env
  else
    printf 'CORS_ALLOWED_ORIGINS=%s\n' "$MOI" >> .env
  fi
  [ "$(sed -nE "s/${KHOA_RE}//p" .env | sort -u)" = "$MOI" ] || { lui_lai; dung "sửa .env không ăn"; }
  echo "đã đổi; bản cũ .env.truoc-cors-$ts"
  echo "-- tạo lại be, chờ health"
  docker compose up -d --no-build --wait be || { lui_lai; dung "be chưa khoẻ sau khi đổi (đã tự lùi)"; }
fi
docker compose ps --format '  {{.Service}} {{.State}} {{.Health}}'
for o in https://ginsengfood.vn https://www.ginsengfood.vn http://192.168.1.99; do
  m=$(thu "$o"); echo "  preflight Origin $o: $m"
  [ "$m" = 200 ] || { lui_lai; dung "preflight $o ra $m, không phải 200 (compose.override.yml đặt đè CORS?) (đã tự lùi nếu có sửa)"; }
done
printf '  /api/health/ready %s · /vi %s · /admin %s\n' "$(ma_http http://192.168.1.99/api/health/ready)" "$(ma_http http://192.168.1.99/vi)" "$(ma_http http://192.168.1.99/admin)"
echo CORS_XONG
