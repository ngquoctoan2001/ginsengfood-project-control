#!/usr/bin/env bash
# NM3-12 (Sheet M3-122) - doc DB .60 de nap link ops-core: CHI DOC (SELECT). Chay qua chay-tren-60.sh sau khi Toan duyet dung viec nay:
#   bash C:/Projects/_wt/m34/len60-notes/lenh/chay-tren-60.sh C:/Projects/Project\ Control/modules/m34/nm3/NM3-12-doc-db-60.sh
# Khong ghi, khong sua, khong in .env. Chi in: so dong, ma SKU (cong khai), ma/ten kho, so link. Khong co du lieu khach.
export LC_ALL=C
export PATH="$PATH:/usr/local/bin"
cd /home/ssv/m34 || { echo "KHONG VAO DUOC /home/ssv/m34"; echo "== KET THUC NM3-12-doc-db-60 rc=1 =="; exit 1; }
sec() { echo; echo "##### $*"; }
main() {
exec </dev/null
sec "0 gio"; date '+%F %T %z'
sec "1 sku_master_codes: dem 19 ma cua M12 (ky vong 19)"
docker exec -i m34-pg-1 sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -X -A -t -v ON_ERROR_STOP=1' <<'SQL'
BEGIN READ ONLY;
select 'co_trong_sku_master', count(*) from sku_master_codes where sku_code in (
 'A1/CS/DM/HS','A2/CS/BASA','A3/CS/LUON','A4/CS/CUU','B1/CS/RM/ĐX','B2/CS/DHA','B3/CS/CACOM','B4/CS/COLAGEN','B5/CS/SINHLUC','B6/CS/GAAC',
 'C1/CS/BAONGU','C2/CS/DONGTRUNG','C3/CS/NAMDONGCO','C4/CS/CUABIEN','C5/CS/CANGU','C6/CS/TOM/RONGBIEN','C7/CS/THITGA','C8/CS/THITHEO','C9/CS/THITBO');
select 'thieu', sku_code from (values ('A1/CS/DM/HS'),('A2/CS/BASA'),('A3/CS/LUON'),('A4/CS/CUU'),('B1/CS/RM/ĐX'),('B2/CS/DHA'),('B3/CS/CACOM'),('B4/CS/COLAGEN'),('B5/CS/SINHLUC'),('B6/CS/GAAC'),
 ('C1/CS/BAONGU'),('C2/CS/DONGTRUNG'),('C3/CS/NAMDONGCO'),('C4/CS/CUABIEN'),('C5/CS/CANGU'),('C6/CS/TOM/RONGBIEN'),('C7/CS/THITGA'),('C8/CS/THITHEO'),('C9/CS/THITBO')) v(sku_code)
 where sku_code not in (select sku_code from sku_master_codes);
select 'is_active_false', sku_code from sku_master_codes where sku_code in ('A1/CS/DM/HS','A2/CS/BASA','A3/CS/LUON','A4/CS/CUU','B1/CS/RM/ĐX','B2/CS/DHA','B3/CS/CACOM','B4/CS/COLAGEN','B5/CS/SINHLUC','B6/CS/GAAC','C1/CS/BAONGU','C2/CS/DONGTRUNG','C3/CS/NAMDONGCO','C4/CS/CUABIEN','C5/CS/CANGU','C6/CS/TOM/RONGBIEN','C7/CS/THITGA','C8/CS/THITHEO','C9/CS/THITBO') and is_active is not true;
COMMIT;
SQL
sec "2 warehouses (chon kho M3 ghep voi WH_FG_MAIN)"
docker exec -i m34-pg-1 sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -X -A -t -F "|" -v ON_ERROR_STOP=1' <<'SQL'
BEGIN READ ONLY;
select id, market_code, warehouse_code, warehouse_name, is_active from warehouses order by id;
COMMIT;
SQL
sec "3 link ops-core hien co (ky vong 0)"
docker exec -i m34-pg-1 sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -X -A -t -v ON_ERROR_STOP=1' <<'SQL'
BEGIN READ ONLY;
select 'sku_links', count(*), count(*) filter (where is_active) from ops_core_sku_links;
select 'warehouse_links', count(*), count(*) filter (where is_active), count(*) filter (where is_default and is_active) from ops_core_warehouse_links;
select 'flyway', max(version::int) from flyway_schema_history where success and version ~ '^[0-9]+$';
COMMIT;
SQL
sec "4 co OPS_CORE_ENABLED trong env be (chi true/false)"
docker inspect --format '{{range .Config.Env}}{{println .}}{{end}}' m34-be-1 | grep -E '^OPS_CORE_(ENABLED|GATE_ENFORCE)=' | sort
}
NAME=NM3-12-doc-db-60
NONCE=""; ARGS=(); for a in "$@"; do case "$a" in --nonce=*) NONCE="${a#*=}";; *) ARGS+=("$a");; esac; done; set -- "${ARGS[@]}"
{ main; echo "== KET THUC $NAME rc=$?${NONCE:+ nonce=$NONCE} =="; } 2>&1
