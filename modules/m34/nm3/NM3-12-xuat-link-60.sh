#!/usr/bin/env bash
# NM3-12 / SKU-M12-11 - xuat link ops-core tu DB .60 ra CSV de phien m12 kiem (CHI DOC, SELECT). Chay qua chay-tren-60.sh sau khi Toan duyet dung viec nay:
#   bash C:/Projects/_wt/m34/len60-notes/lenh/chay-tren-60.sh "C:/Projects/Project Control/modules/m34/nm3/NM3-12-xuat-link-60.sh"
# CSV (giua hai dong "== CSV BAT DAU ==" / "== CSV HET =="): sku_code, ops_core_sku_id, uom_code, ops_core_warehouse_id (kho mac dinh dang hoat dong).
# Khong co bi mat (ma SKU cong khai, UUID M12 khong bi mat). Khong ghi, khong sua. Chua co du lieu khach.
export LC_ALL=C
export PATH="$PATH:/usr/local/bin"
cd "${M34_HOME:-/home/ssv/m34}" || { echo "KHONG VAO DUOC thu muc m34"; echo "== KET THUC NM3-12-xuat-link-60 rc=1 =="; exit 1; }
main() {
exec </dev/null
echo "== CSV BAT DAU =="
docker exec -i "${M34_PG_CONTAINER:-m34-pg-1}" sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -X -q -v ON_ERROR_STOP=1 -c "\copy (select l.sku_code, l.ops_core_sku_id, l.uom_code, w.ops_core_warehouse_id from ops_core_sku_links l cross join (select ops_core_warehouse_id from ops_core_warehouse_links where is_default and is_active) w where l.is_active order by l.sku_code) to stdout with (format csv, header true)"'
echo "== CSV HET =="
}
NAME=NM3-12-xuat-link-60
NONCE=""; ARGS=(); for a in "$@"; do case "$a" in --nonce=*) NONCE="${a#*=}";; *) ARGS+=("$a");; esac; done; set -- "${ARGS[@]}"
{ main; echo "== KET THUC $NAME rc=$?${NONCE:+ nonce=$NONCE} =="; } 2>&1
