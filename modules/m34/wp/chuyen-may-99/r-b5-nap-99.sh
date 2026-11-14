# r-b5-nap-99.sh <tệp dump> <sha256> (.99): nạp dump .60 vào CSDL .99 (xoá CSDL thử của A8, tạo lại, pg_restore một giao dịch),
# rồi so số dòng từng bảng với .60. Theo khối xoá–tạo–nạp của deploy/m34/KHOI_PHUC.md.
cd "$G"
tep=${1:?}; sha=${2:?}
[[ $tep =~ ^chuyen-may-99-[0-9TZ]+-[0-9a-f]{8}\.dump$ ]] || dung "tên dump lạ"
[[ $sha =~ ^[0-9a-f]{64}$ ]] || dung "sha lạ"
f=$SL99/chuyen-may/$tep
[ "$(sha256sum "$f" | cut -c1-64)" = "$sha" ] || dung "sha256 dump trên .99 lệch .60"
[ -s _chuyen-may/dem-60.tsv ] || dung "thiếu số đếm của .60"
for s in be fe nginx m8that-cb; do
  [ -z "$(docker compose ps -q --status running "$s" 2>/dev/null)" ] || dung "$s đang chạy trên .99"
done
u=$(doc_env POSTGRES_USER); db=$(doc_env POSTGRES_DB); u=${u:-ginsengfood_app}; db=${db:-ginsengfood}
docker compose exec -T pg pg_restore --list < "$f" > /dev/null || dung "pg_restore không đọc được dump"
docker compose exec -T pg dropdb -U "$u" "$db" < /dev/null
docker compose exec -T pg createdb -U "$u" "$db" < /dev/null
time docker compose exec -T pg pg_restore --no-owner --exit-on-error --single-transaction -U "$u" -d "$db" < "$f"
docker compose exec -T pg psql -X -q -U "$u" -d "$db" -c ANALYZE < /dev/null
dem_bang > _chuyen-may/dem-99.tsv
if cmp -s _chuyen-may/dem-60.tsv _chuyen-may/dem-99.tsv; then
  echo "số dòng KHỚP: $(wc -l < _chuyen-may/dem-99.tsv) bảng, $(awk -F '\t' '{t += $2} END {print t}' _chuyen-may/dem-99.tsv) dòng"
else
  diff _chuyen-may/dem-60.tsv _chuyen-may/dem-99.tsv | head -n 40 || true   # diff trả 1 khi lệch: không để pipefail cắt mất dòng DỪNG
  dung "số dòng .99 lệch .60"
fi
echo B5_XONG
