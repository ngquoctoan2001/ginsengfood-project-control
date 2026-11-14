# r-b7-cron-99.sh (.99): cài các dòng cron gói m34 của .60 lên .99 (giữ dòng cron khác của ssv, vd m12/m8): đường ~/m34 ->
# $D99, giờ VN -> UTC (.99 chạy múi UTC, .60 giờ VN; doi_cron_99 trong r-dau.sh); đầu khối đặt M34_HOST_IP, M34_HOME cho script ops-core.
# Dòng không đổi tự động được: KHÔNG cài, in "CHƯA CÀI" để sửa tay sau cửa sổ (pha 0/A đã in trước). Không dừng: .99 đã phục vụ từ B6.
# Rồi chạy sao lưu hằng ngày một lần.
cd "$G"
src=_chuyen-may/crontab.60.truoc
[ -f "$src" ] || dung "thiếu crontab đã lưu của .60"
mui=$(timedatectl show -p Timezone --value 2>/dev/null || cat /etc/timezone 2>/dev/null || echo '?')
[ "$mui" = UTC ] || [ "$mui" = Etc/UTC ] || dung "múi giờ .99 là $mui, không phải UTC: sửa phép đổi giờ trước"
moi=$(mktemp); loi=$(mktemp)
trap 'rm -f -- "$moi" "$loi"' EXIT
rc_doi=0
{
  echo "# m34 (D-lead-035): chép từ .60 $(date -u +%F), giờ đã đổi VN -> UTC (.99 chạy UTC). Sửa: deploy/m34/CHUYEN_MAY_99.md"
  echo "M34_HOST_IP=192.168.1.99"
  echo "M34_HOME=$D99"
  { grep -E "$CRON_M34" "$src" | grep -v '^[[:space:]]*#' || true; } | doi_cron_99 2> "$loi" || rc_doi=$?
} > "$moi"
# doi_cron_99 trả 1 khi có dòng LOI_DOI_GIO (đúng ý: không cài dòng đó); mã khác, hay 1 mà không có dòng nào, là sed/awk hỏng: không cài gì.
case $rc_doi in
  0) ;;
  1) grep -q '^LOI_DOI_GIO ' "$loi" || dung "đổi giờ cron hỏng (mã 1, không có dòng LOI_DOI_GIO): crontab .99 chưa đổi" ;;
  *) dung "đổi giờ cron hỏng (mã $rc_doi): crontab .99 chưa đổi" ;;
esac
{ { crontab -l 2>/dev/null || true; } | { grep -v -e "$D99" -e '^M34_HOST_IP=' -e '^M34_HOME=' -e '^# m34 (D-lead-035)' || true; }; cat "$moi"; } | crontab -
echo "-- dòng gói m34 trong crontab .99:"
crontab -l | grep -e "$D99" -e '^M34_HOST_IP=' -e '^M34_HOME=' | sed 's/^/  /' || true
if [ -s "$loi" ]; then
  echo "-- CHƯA CÀI (không đổi giờ tự động được, sửa tay sau cửa sổ):"
  sed 's/^LOI_DOI_GIO /  /' "$loi"
fi
echo "-- sao lưu hằng ngày chạy thử một lần"
bash sao-luu/sao-luu.sh
ls -l "$SL99/hang-ngay/" | tail -n 3 | sed 's/^/  /'
echo B7_XONG
