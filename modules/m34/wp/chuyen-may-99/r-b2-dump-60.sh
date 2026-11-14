# r-b2-dump-60.sh (.60): pg_dump -Fc khi be đã dừng (giữ trên .60 làm điểm lui), kiểm pg_restore --list, sha256,
# đếm chính xác mọi bảng public (chỉ tên + số), rồi dừng redis để chép volume lúc đứng yên.
cd "$G"
[ -z "$(docker compose ps -q --status running be)" ] || dung "be còn chạy trên .60 (B1 chưa xong)"
u=$(doc_env POSTGRES_USER); db=$(doc_env POSTGRES_DB); u=${u:-ginsengfood_app}; db=${db:-ginsengfood}
tep="chuyen-may-99-$(date -u +%Y%m%dT%H%M%SZ)-$(doc_env M34_BAN | cut -c1-8).dump"
tam="sao-luu/.$tep.dang-ghi"
trap 'rm -f -- "$tam"' EXIT
docker compose exec -T pg pg_dump -Fc -U "$u" -d "$db" --lock-wait-timeout=60s < /dev/null > "$tam"
n=$(docker compose exec -T pg pg_restore --list < "$tam" | grep -cv '^;' || true)
[ "${n:-0}" -gt 0 ] || dung "dump không có mục nào"
mv -f -- "$tam" "sao-luu/$tep"
trap - EXIT
(cd sao-luu && sha256sum "$tep" > "$tep.sha256")
dem_bang > _chuyen-may/dem-60.tsv
docker compose stop redis
echo "TEP=$tep"
echo "SHA=$(cut -c1-64 "sao-luu/$tep.sha256")"
echo "CO=$(stat -c %s "sao-luu/$tep")"
echo "MUC=$n"
echo "DEM=$(sha256sum < _chuyen-may/dem-60.tsv | cut -c1-64) · $(wc -l < _chuyen-may/dem-60.tsv) bảng · $(awk -F '\t' '{t += $2} END {print t}' _chuyen-may/dem-60.tsv) dòng"
echo B2_XONG
