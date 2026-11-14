# r-lui-kiem-99.sh (.99, CHỈ ĐỌC): .99 đã nhận ghi sau cắt chưa?
# Thoát 0: chưa tới B6 (be .99 chưa từng chạy trên dữ liệu .60: dấu _chuyen-may/b6-bat-dau do r-b6 ghi), hoặc số dòng từng bảng
# khớp số đếm .60 lúc cắt (B2). 3: lệch (in tên bảng + số). 4: không đếm được (pg .99 không chạy).
[ -d "$G" ] || { echo "  .99 chưa có $G (pha A chưa chạy)"; exit 0; }
cd "$G"
[ -e _chuyen-may/b6-bat-dau ] || { echo "  be .99 chưa chạy trên dữ liệu .60 (chưa tới B6): không có gì để mất"; exit 0; }
[ -s _chuyen-may/dem-60.tsv ] || { echo "  thiếu số đếm .60 trên .99"; exit 4; }
[ -n "$(docker compose ps -q --status running pg)" ] || { echo "  pg .99 không chạy: không đếm được"; exit 4; }
dem_bang > _chuyen-may/dem-99-lui.tsv || { echo "  đếm bảng .99 hỏng"; exit 4; }
if cmp -s _chuyen-may/dem-60.tsv _chuyen-may/dem-99-lui.tsv; then
  echo "  số dòng .99 khớp .60 lúc cắt: $(wc -l < _chuyen-may/dem-99-lui.tsv) bảng (be .99 bật từ $(cat _chuyen-may/b6-bat-dau))"
  exit 0
fi
echo "  LỆCH (bảng · .60 lúc cắt · .99 bây giờ), chỉ tên bảng + số:"
join -t "$(printf '\t')" -a 1 -a 2 -e - -o 0,1.2,2.2 _chuyen-may/dem-60.tsv _chuyen-may/dem-99-lui.tsv | awk -F '\t' '$2 != $3' | head -n 30 | sed 's/^/    /' || true
exit 3
