# r-cron-thu.sh (.60, CHỈ ĐỌC): chạy thử phép đổi cron gói m34 của .60 sang .99 (giờ VN -> UTC, đường ~/m34 -> thư mục .99)
# để thấy trước B7. Dòng không đổi tự động được thì báo, B7 sẽ không cài dòng đó (sửa tay sau cửa sổ).
n=$(crontab -l 2>/dev/null | grep -Ec "$CRON_M34" || true)
echo "dòng cron gói m34 trên .60: $n"
if [ "$n" != 0 ]; then
  loi=$(mktemp); trap 'rm -f -- "$loi"' EXIT
  if crontab -l 2>/dev/null | grep -E "$CRON_M34" | grep -v '^[[:space:]]*#' | doi_cron_99 2> "$loi" | sed 's/^/  .99: /'; then
    echo "  đổi được hết"
  else
    sed 's/^LOI_DOI_GIO /  KHÔNG ĐỔI ĐƯỢC (B7 bỏ qua, sửa tay): /' "$loi"
  fi
fi
echo CRON_THU_XONG
