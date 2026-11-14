# r-c2-ip-99.sh (.99, CHỈ ĐỌC): chỉ IP + số lượt. Trường 1 nhật ký nginx là IP khách sau realip (nginx/m34.conf tin X-Forwarded-For từ
# LAN /23); IP kết nối thật (máy cổng vào của Anh Tuấn) đọc từ kết nối TCP đang mở trong container nginx (busybox netstat).
cd "$G"
echo "-- IP khách 15 phút qua"
docker compose logs --no-log-prefix --since 15m nginx 2>/dev/null | awk '$1 ~ /^[0-9.]+$/ {print $1}' | sort | uniq -c | sort -rn | head -n 8
echo "-- IP kết nối TCP đang mở vào :80"
{ docker compose exec -T nginx netstat -tn < /dev/null 2>/dev/null || true; } | awk '$4 ~ /:80$/ {n = split($5, a, ":"); print a[1]}' | sort | uniq -c | sort -rn | head -n 8
echo C2_XONG
