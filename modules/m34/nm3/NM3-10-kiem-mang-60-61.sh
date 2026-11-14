#!/usr/bin/env bash
# NM3-10 (Sheet M3-121) — kiem mang .60 -> .61:5000 (M3 goi M12). Toan chay TAY tren .60:
#   scp NM3-10-kiem-mang-60-61.sh ssv@192.168.1.60:/tmp/   (hoac dan noi dung vao phien ssh)
#   ssh ssv@192.168.1.60 'bash /tmp/NM3-10-kiem-mang-60-61.sh'
# Script CHI DOC: 1 GET health + 1 POST lay token. KHONG ghi tep, KHONG sua cau hinh, KHONG dung ~/m34.
# Secret: nhap khi duoc hoi (khong hien chu, khong vao lich su lenh, khong vao tep). Script KHONG in token/secret;
# chi in: ma HTTP, IP nguon/dich, thoi gian, ten claim va so luong quyen/audience cua token.
# Han muc token cua M12: 10 lan / 60 giay / IP (chung voi M5/M6/M7 cung IP .60). Script chi goi 1 lan; dung chay lap lien tuc.
# Gui lai cho phien m34/m12 CHI doan in ra (dong "KQ"), khong gui secret.
export LC_ALL=C
BASE="${BASE:-http://192.168.1.61:5000}"
echo "== NM3-10 $(date '+%F %T %z') host=$(hostname) ip=$(hostname -I | awk '{print $1}')"
echo "BASE=$BASE"

echo "## 1 health/live (khong can token)"
H=$(curl -sS -m 8 -o /dev/null -D /tmp/nm3-10.hdr -w '%{http_code} remote_ip=%{remote_ip} time_total=%{time_total}s' "$BASE/health/live" 2>&1)
echo "HEALTH: $H"
echo "M12 Date header: $(grep -i '^date:' /tmp/nm3-10.hdr 2>/dev/null | head -1 | tr -d '\r')  |  may nay: $(date -u '+%a, %d %b %Y %T GMT')"
rm -f /tmp/nm3-10.hdr

echo "## 2 lay token (POST /v1/service-tokens)"
read -r -p "client_id [SVC-M3-SELLABLE] (khong phai bi mat; Enter de dung mac dinh): " CID
CID="${CID:-SVC-M3-SELLABLE}"
read -r -s -p "client_secret (khong hien chu): " SEC; echo
if [ -z "$CID" ] || [ -z "$SEC" ]; then echo "DUNG: thieu client_id/secret"; exit 2; fi
RESP=$(python3 - "$BASE/v1/service-tokens" "$CID" "$SEC" <<'PY'
import base64, json, sys, urllib.request, urllib.error
url, cid, sec = sys.argv[1], sys.argv[2], sys.argv[3]
req = urllib.request.Request(url, json.dumps({"client_id": cid, "client_secret": sec}).encode(), method="POST",
                             headers={"Content-Type": "application/json; charset=utf-8", "Accept": "application/json"})
try:
    with urllib.request.urlopen(req, timeout=8) as r:
        code, body = r.status, r.read()
except urllib.error.HTTPError as e:
    code, body = e.code, e.read()
except Exception as e:
    print("TOKEN: loi mang %s" % type(e).__name__); sys.exit(0)
try:
    j = json.loads(body)
except Exception:
    print("TOKEN: HTTP %s, than khong phai JSON" % code); sys.exit(0)
if code != 200:
    err = j.get("error") or {}
    print("TOKEN: HTTP %s error.code=%s" % (code, err.get("code") if isinstance(err, dict) else err)); sys.exit(0)
d = j.get("data", j)
tok = d.get("access_token") or ""
print("TOKEN: HTTP 200 expires_in=%s token_type=%s do_dai_token=%d" % (d.get("expires_in"), d.get("token_type"), len(tok)))
try:
    p = tok.split(".")[1]; p += "=" * (-len(p) % 4)
    c = json.loads(base64.urlsafe_b64decode(p))
    for k, v in sorted(c.items()):
        if k in ("aud", "exp", "nbf", "iat", "iss", "typ", "sub_type"):
            print("CLAIM %s = %s" % (k, v))
        elif isinstance(v, (list, dict)):
            print("CLAIM %s : %d muc" % (k, len(v)))
        else:
            print("CLAIM %s : co (khong in gia tri)" % k)
    print("CO iat: %s (ky vong: khong co)" % ("iat" in c))
except Exception as e:
    print("TOKEN: khong giai ma duoc claim (%s)" % type(e).__name__)
PY
)
unset SEC
echo "$RESP"
echo "## KET QUA (gui doan nay cho phien m34/m12)"
echo "KQ $(date '+%F %T') health=[$H]"
echo "KQ $(echo "$RESP" | head -1)"
echo "Ky vong: health 200; TOKEN HTTP 200; aud co 3 gia tri (availability-v1, bulk-read-v1, allocation-v1); khong co iat."
echo "Phien m12 doc log M12 xem IP nguon thay la $(hostname -I | awk '{print $1}') luc $(date '+%T')."
