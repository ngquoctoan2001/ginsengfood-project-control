# r-b1-bao-tri-60.sh (.60): bắt đầu cửa sổ cắt. Lưu crontab, gỡ dòng gói m34 khỏi crontab (sao lưu, tồn demo, đồng bộ tồn,
# cảnh báo không chạy vào CSDL đang dump), dừng đường vào và nơi ghi: nginx (khách + admin), cầu M8, fe, be. pg, redis, clamav còn chạy.
# Đường lui trong cửa sổ: lui-60.sh (khôi phục crontab đã lưu + bật lại).
cd "$G"
[ ! -e DA_CHUYEN_SANG_99.txt ] || dung ".60 đã có DA_CHUYEN_SANG_99.txt (đã qua pha D): không cắt lại từ máy này"
mkdir -p -m 700 _chuyen-may
# Dấu "be .99 đã bật" / "cổng vào đã trỏ .99" của lần cắt trước (đã lui): lần cắt này bắt đầu lại từ dữ liệu .60.
for d in b6-bat-dau c-cong-vao-99; do
  if [ -e "_chuyen-may/$d" ]; then mv -- "_chuyen-may/$d" "_chuyen-may/$d.cu-$(date -u +%Y%m%dT%H%M%SZ)"; echo "dấu $d của lần cắt trước: đổi tên"; fi
done
hien=$(mktemp); trap 'rm -f -- "$hien"' EXIT
crontab -l > "$hien" 2>/dev/null || : > "$hien"
# Lưu bản đang chạy mỗi khi nó còn dòng gói m34 (lần cắt đầu, hoặc lần cắt lại sau một lần lui có thể đã thêm dòng mới, vd M7).
# Không còn dòng m34 (B1 chạy lại ngay sau một B1 hỏng giữa chừng) thì giữ bản đã lưu, không ghi đè bằng bản đã gỡ.
if grep -Eq "$CRON_M34" "$hien" || [ ! -e _chuyen-may/crontab.60.truoc ]; then cp -- "$hien" _chuyen-may/crontab.60.truoc; fi
echo "crontab đã lưu: $(grep -c . _chuyen-may/crontab.60.truoc || true) dòng, $(grep -Ec "$CRON_M34" _chuyen-may/crontab.60.truoc || true) dòng gói m34"
{ grep -Ev "$CRON_M34" _chuyen-may/crontab.60.truoc || true; } | crontab -
[ "$(crontab -l 2>/dev/null | grep -Ec "$CRON_M34" || true)" = 0 ] || dung "crontab còn dòng gói m34"
dv="nginx"
# Lấy danh sách trước rồi mới grep: `docker compose config --services | grep -q` dưới pipefail sai khi grep thoát sớm (compose bị SIGPIPE).
dvs=$(docker compose config --services)
if grep -qx m8that-cb <<< "$dvs"; then dv="$dv m8that-cb"; fi
docker compose stop $dv fe be
docker compose ps --format '  {{.Service}} {{.State}}'
[ -z "$(docker compose ps -q --status running be)" ] || dung "be vẫn chạy"
echo "B1_XONG $(date -u +%FT%TZ)"
