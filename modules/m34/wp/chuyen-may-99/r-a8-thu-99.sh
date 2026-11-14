# r-a8-thu-99.sh (.99): chạy thử cả gói trên CSDL RỖNG (Flyway tạo lược đồ; CSDL này bị xoá ở B5 trước khi nạp dữ liệu .60),
# kiểm health, rồi tắt đường vào (nginx, cầu, fe, be) để .99 tối tới giờ cắt; pg, redis, clamav chạy tiếp.
cd "$G"
if ! timeout 1500 docker compose up -d --no-build --wait; then
  docker compose ps --format '  {{.Service}} {{.State}} {{.Health}}'
  docker compose logs --no-log-prefix --tail 200 be 2>&1 | grep -E ' (ERROR|WARN) ' | tail -n 15 || true
  dung "up --wait chưa khoẻ"
fi
docker compose ps --format '  {{.Service}} {{.State}} {{.Health}}'
printf '/nginx-health %s · /api/health/ready %s · /vi %s · /admin %s\n' \
  "$(ma_http http://192.168.1.99/nginx-health)" "$(ma_http http://192.168.1.99/api/health/ready)" \
  "$(ma_http http://192.168.1.99/vi)" "$(ma_http http://192.168.1.99/admin)"
[ "$(ma_http http://192.168.1.99/api/health/ready)" = 200 ] || dung "/api/health/ready qua nginx .99 chưa 200"
echo "dòng ERROR trong log be: $(docker compose logs --no-log-prefix be 2>&1 | grep -c ' ERROR ' || true)"
docker compose logs --no-log-prefix be 2>&1 | grep -m 2 -E 'IVR-AUTH-CONFIG|Successfully applied' || true
echo "-- be gọi M12 (OPS_CORE_ENABLED=$(doc_env OPS_CORE_ENABLED), GATE_ENFORCE=$(doc_env OPS_CORE_GATE_ENFORCE)); pha A chỉ báo:"
thu_ops_core || echo "  => trước cửa sổ cắt cần thông (dòng DOCKER-USER: phiên lead/Toàn; danh sách nguồn M12: m12)"
dv="nginx"
# Lấy danh sách trước rồi mới grep: `docker compose config --services | grep -q` dưới pipefail sai khi grep thoát sớm (compose bị SIGPIPE).
dvs=$(docker compose config --services)
if grep -qx m8that-cb <<< "$dvs"; then dv="$dv m8that-cb"; fi
docker compose stop $dv fe be
docker compose ps --format '  {{.Service}} {{.State}}'
echo A8_XONG
