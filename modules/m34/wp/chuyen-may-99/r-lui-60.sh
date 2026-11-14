# r-lui-60.sh <co|khong> (.60): khôi phục crontab đã lưu ở B1, bật lại cả gói, kiểm health.
# Có DA_CHUYEN_SANG_99.txt (đã qua pha D) thì dừng, trừ khi đối số là "co" (Toàn quyết, lui-60.sh đã kiểm): khi đó đổi tên tệp dấu
# (giữ làm vết) để trien-khai.sh trên .60 chạy lại được.
cd "$G"
sau_ghi=${1:-khong}
if [ -e DA_CHUYEN_SANG_99.txt ]; then
  [ "$sau_ghi" = co ] || dung ".60 đã qua pha D (DA_CHUYEN_SANG_99.txt): không lui thẳng"
  mv -- DA_CHUYEN_SANG_99.txt "DA_CHUYEN_SANG_99.txt.da-lui-$(date -u +%Y%m%dT%H%M%SZ)"
  echo "đã đổi tên tệp dấu DA_CHUYEN_SANG_99.txt (Toàn quyết lui sau pha D)"
fi
if [ -f _chuyen-may/crontab.60.truoc ]; then
  hien=$(mktemp); goc_bo=$(mktemp); trap 'rm -f -- "$hien" "$goc_bo"' EXIT
  crontab -l > "$hien" 2>/dev/null || : > "$hien"
  { grep -Ev "$CRON_M34" _chuyen-may/crontab.60.truoc || true; } > "$goc_bo"
  if grep -Eq "$CRON_M34" "$hien"; then
    echo "crontab .60 đã có dòng gói m34 (lần lui trước đã khôi phục?): giữ nguyên"
  elif cmp -s "$goc_bo" "$hien"; then
    crontab _chuyen-may/crontab.60.truoc
    echo "crontab khôi phục đúng bản lưu ở B1"
  else
    # Có dòng khác (vd m7) thêm/sửa sau B1: giữ crontab hiện tại, nối lại các dòng gói m34 đã lưu ở cuối.
    { cat "$hien"; echo "# m34: nối lại lúc lui $(date -u +%FT%TZ) (crontab đổi sau B1)"; grep -E "$CRON_M34" _chuyen-may/crontab.60.truoc; } | crontab -
    echo "CHÚ Ý: crontab .60 đổi sau B1: giữ phần đó, nối lại dòng gói m34 đã lưu ở cuối (xem lại biến môi trường đứng trước chúng)"
  fi
  echo "crontab: $(crontab -l | grep -Ec "$CRON_M34" || true) dòng gói m34"
else
  echo "không có crontab đã lưu (B1 chưa chạy): crontab .60 giữ nguyên ($(crontab -l 2>/dev/null | grep -Ec "$CRON_M34" || true) dòng gói m34)"
fi
if ! timeout 1500 docker compose up -d --no-build --wait; then
  docker compose ps --format '  {{.Service}} {{.State}} {{.Health}}'
  dung "up --wait chưa khoẻ trên .60"
fi
docker compose ps --format '  {{.Service}} {{.State}} {{.Health}}'
printf '/api/health/ready %s · /vi %s\n' "$(ma_http http://192.168.1.60/api/health/ready)" "$(ma_http http://192.168.1.60/vi)"
echo LUI_XONG
