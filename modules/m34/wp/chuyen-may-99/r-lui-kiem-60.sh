# r-lui-kiem-60.sh (.60, CHỈ ĐỌC): thoát 3 nếu .60 đã qua pha D (có DA_CHUYEN_SANG_99.txt), 0 nếu chưa.
cd "$G"
if [ -e DA_CHUYEN_SANG_99.txt ]; then
  echo "  .60 có DA_CHUYEN_SANG_99.txt: $(head -n 1 DA_CHUYEN_SANG_99.txt)"
  exit 3
fi
for d in b6-bat-dau c-cong-vao-99; do
  if [ -e "_chuyen-may/$d" ]; then echo "DAU_${d}=$(head -n 1 "_chuyen-may/$d")"; fi
done
if [ -f _chuyen-may/crontab.60.truoc ]; then echo "  .60 chưa qua pha D; có crontab đã lưu ở B1"; else echo "  .60 chưa qua B1 (không có crontab đã lưu)"; fi
