# r-d-60.sh (.60): dừng (stop, KHÔNG down, KHÔNG xoá volume) mọi dịch vụ project m34; ghi tệp dấu để người sau không bật nhầm
# (trien-khai.sh bản toandeptrai từ chối khi có tệp này; lui-60.sh dừng khi có tệp này trừ khi Toàn đặt cờ rõ).
cd "$G"
[ "$(crontab -l 2>/dev/null | grep -Ec "$CRON_M34" || true)" = 0 ] || dung "crontab .60 còn dòng gói m34 (B1 chưa chạy?)"
docker compose stop
printf '%s\n' "~/m34 đã chuyển sang 192.168.1.99 ($D99) lúc $(date -u +%FT%TZ) (D-lead-035/037)." \
  "Máy này giữ dữ liệu làm đường lui tới khi Toàn cho gỡ. KHÔNG bật lại (trien-khai.sh, docker compose up) khi .99 đang phục vụ:" \
  "hai máy cùng ghi sẽ tách dữ liệu. Lui về: xem deploy/m34/CHUYEN_MAY_99.md mục 7 (Đường lui)." > DA_CHUYEN_SANG_99.txt
docker compose ps -a --format '  {{.Service}} {{.State}}'
echo "volume giữ: $(docker volume ls --format '{{.Name}}' | grep -c '^m34_' || true) (m34_pg, m34_uploads, …)"
echo "-- Toàn làm tiếp (ngoài máy): tắt biến repo M34_DEPLOY_60 (job deploy-60); gỡ dòng khoá CD .60 (command=...cd-entry.sh) khỏi"
echo "   ~ssv/.ssh/authorized_keys của .60 nếu có: hiện $(grep -c 'cd-entry.sh' "$HOME/.ssh/authorized_keys" 2>/dev/null || echo 0) dòng"
echo D_XONG
