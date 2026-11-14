# r-b6-len-99.sh (.99): bật cả gói trên dữ liệu đã nạp, kiểm health, Flyway không chạy migration mới (cùng SHA với .60),
# log be không ERROR, dòng cấu hình IVR.
cd "$G"
bat_dau=$(date -u +%FT%TZ)
# Dấu cho lui-60.sh: từ đây be .99 chạy trên dữ liệu .60 và có thể ghi (job nền, outbox), lui phải so số dòng trước.
mkdir -p -m 700 _chuyen-may && printf '%s\n' "$bat_dau" > _chuyen-may/b6-bat-dau
if ! timeout 1500 docker compose up -d --no-build --wait; then
  docker compose ps --format '  {{.Service}} {{.State}} {{.Health}}'
  docker compose logs --no-log-prefix --since "$bat_dau" be 2>&1 | grep -E ' (ERROR|WARN) ' | tail -n 15 || true
  dung "up --wait chưa khoẻ (đường lui: lui-60.sh)"
fi
docker compose ps --format '  {{.Service}} {{.State}} {{.Health}}'
printf '/nginx-health %s · /api/health/ready %s · /vi %s · /admin %s\n' \
  "$(ma_http http://192.168.1.99/nginx-health)" "$(ma_http http://192.168.1.99/api/health/ready)" \
  "$(ma_http http://192.168.1.99/vi)" "$(ma_http http://192.168.1.99/admin)"
[ "$(ma_http http://192.168.1.99/api/health/ready)" = 200 ] || dung "/api/health/ready qua nginx .99 chưa 200"
oc_bat=$(doc_env OPS_CORE_ENABLED); oc_chan=$(doc_env OPS_CORE_GATE_ENFORCE)
echo "-- be gọi M12 (OPS_CORE_ENABLED=${oc_bat:-?}, GATE_ENFORCE=${oc_chan:-?}):"
if ! thu_ops_core; then
  if [ "$oc_chan" = true ]; then dung "chặn bán theo M12 đang bật mà be không tới được M12 (đường lui: lui-60.sh)"; fi
  if [ "$oc_bat" = true ]; then echo "CHÚ Ý: quan sát ops-core không tới được M12, bán vẫn chạy; báo m12 + lead ngay sau cửa sổ"; fi
fi
u=$(doc_env POSTGRES_USER); db=$(doc_env POSTGRES_DB); u=${u:-ginsengfood_app}; db=${db:-ginsengfood}
fw=$(docker compose exec -T pg psql -X -q -At -F ' ' -U "$u" -d "$db" -c \
  "SELECT count(*), count(*) FILTER (WHERE NOT success), (SELECT version FROM flyway_schema_history ORDER BY installed_rank DESC LIMIT 1) FROM flyway_schema_history" < /dev/null)
echo "flyway (tổng, hỏng, bản cuối): $fw"
[ "$(printf '%s' "$fw" | cut -d' ' -f2)" = 0 ] || dung "flyway có dòng hỏng"
[ "$(docker compose logs --no-log-prefix --since "$bat_dau" be 2>&1 | grep -c 'Successfully applied [1-9]' || true)" = 0 ] \
  || echo "CHÚ Ý: be vừa chạy migration mới trên dữ liệu .60 (không mong đợi khi cùng SHA)"
echo "dòng ERROR trong log be từ lúc bật: $(docker compose logs --no-log-prefix --since "$bat_dau" be 2>&1 | grep -c ' ERROR ' || true)"
docker compose logs --no-log-prefix --since "$bat_dau" be 2>&1 | grep -m 1 'IVR-AUTH-CONFIG' || echo "(không thấy dòng IVR-AUTH-CONFIG)"
echo B6_XONG
