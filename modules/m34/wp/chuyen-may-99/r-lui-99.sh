# r-lui-99.sh (.99): tắt đường vào (nginx, cầu, fe, be) và gỡ khối cron gói m34 khỏi crontab .99 (giữ dòng m12/m8...).
# pg, redis, clamav để chạy; dữ liệu và volume giữ nguyên.
if [ ! -d "$G" ]; then echo "  .99 chưa có $G: không có gì để tắt"; echo L1_XONG; exit 0; fi
cd "$G"
dv=nginx
# Lấy danh sách trước rồi mới grep: `docker compose config --services | grep -q` dưới pipefail sai khi grep thoát sớm (compose bị SIGPIPE).
dvs=$(docker compose config --services)
if grep -qx m8that-cb <<< "$dvs"; then dv="$dv m8that-cb"; fi
docker compose stop $dv fe be
{ crontab -l 2>/dev/null || true; } | { grep -v -e "$D99" -e '^M34_HOST_IP=' -e '^M34_HOME=' -e '^# m34 (D-lead-035)' || true; } | crontab -
echo "  crontab .99 còn $(crontab -l 2>/dev/null | grep -c "$D99" || true) dòng gói m34"
docker compose ps --format '  {{.Service}} {{.State}}'
echo L1_XONG
