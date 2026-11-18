#!/usr/bin/env bash
# Kiểm trước/sau khi gỡ dòng TAM cổng .99 (lead.h1, hẹn 16/11). Chạy trên máy Lead (Git Bash, LAN 192.168.0.64).
# Chỉ đọc: vào .99/.98/.60/.61 bằng khoá ssv, không sudo, không đổi gì.
#   bash kiem-go-tam-99.sh truoc  → "DU DIEU KIEN" khi: .60/.61 không còn app M3/M8/M1-2 chạy; 2 dòng TAM còn đúng 1 lần;
#                                   M1-2, M3, M8 trên .99 đang khoẻ (mốc để so sau khi gỡ)
#   bash kiem-go-tam-99.sh sau    → "DAT" khi: M1-2, M3, M8 trên .99 vẫn khoẻ; gf-tuong-lua chạy; dòng TAM đã hết;
#                                   .60 hết vào 8443, .61 hết vào 8445 (đúng ý gỡ)
set -uo pipefail
CHE="${1:-}"
[ "$CHE" = truoc ] || [ "$CHE" = sau ] || { echo "Dung: bash kiem-go-tam-99.sh truoc|sau"; exit 2; }
S=(ssh -o BatchMode=yes -o ConnectTimeout=8)
LOI=0
ok(){ echo "  OK   $*"; }
hong(){ echo "  HONG $*"; LOI=1; }
ma(){ curl -sk -o /dev/null -m 6 -w '%{http_code}' "$@"; }
R60='^192\.168\.1\.60[[:space:]]+8443[[:space:]]'
R61='^192\.168\.1\.61[[:space:]]+8445[[:space:]]'
CAN=(m12-admin-web-1 m12-caddy-1 m12-ops-core-api-1 m12-pg-ops-1 m12-public-trace-1 m12-shopfloor-pwa-1
     m34-be-1 m34-clamav-1 m34-fe-1 m34-m8that-cb-1 m34-nginx-1 m34-pg-1 m34-redis-1
     m8-api-1 m8-ari-1 m8-https-1 m8-ops-agent-1 m8-ops-metrics-1 m8-phrase-tts-1 m8-postgres-1 m8-prometheus-1 m8-worker-1)

kiem_99(){
  echo "* .99: M1-2, M3, M8"
  c=$(ma http://192.168.1.99/nginx-health);      [ "$c" = 200 ] && ok "M3 nginx :80" || hong "M3 nginx :80 ($c)"
  c=$(ma http://192.168.1.99/api/health/ready);  [ "$c" = 200 ] && ok "M3 api ready" || hong "M3 api ready ($c)"
  c=$(ma -H 'Host: trace.ginsengfood.vn' http://192.168.1.99:8012/)
  [ "$c" = 200 ] && ok "M1-2 caddy :8012 (trace.)" || hong "M1-2 caddy :8012 ($c)"
  c=$(ma https://192.168.1.99:8443/health/ready); [ "$c" = 200 ] && ok "M8 :8443 ready (tu may Lead)" || hong "M8 :8443 ($c)"
  c=$("${S[@]}" ssv@192.168.1.98 "curl -s -o /dev/null -m 6 -w '%{http_code}' -H 'Host: api-ops.ginsengfood.vn' http://192.168.1.99:5000/health/live" 2>/dev/null)
  [ "$c" = 200 ] && ok "M1-2 api :5000 tu .98" || hong "M1-2 api :5000 tu .98 ($c)"
  cb=$("${S[@]}" ssv@192.168.1.99 'docker exec m34-m8that-cb-1 wget -qO- http://127.0.0.1:8080/nginx-health' 2>/dev/null)
  [ "$cb" = ok ] && ok "cau callback M8->M3 (8445, trong may)" || hong "cau callback 8445 ($cb)"
  chay=$("${S[@]}" ssv@192.168.1.99 'docker ps --format "{{.Names}}"; echo "#unhealthy"; docker ps --filter health=unhealthy --format "{{.Names}}"' 2>/dev/null)
  thieu=""; for n in "${CAN[@]}"; do printf '%s\n' "$chay" | grep -qx "$n" || thieu="$thieu $n"; done
  benh=$(printf '%s\n' "$chay" | sed -n '/^#unhealthy$/,$p' | grep -v '^#unhealthy$' | tr '\n' ' ')
  [ -z "$thieu" ] && ok "du ${#CAN[@]} container m12/m34/m8 dang chay" || hong "thieu container:$thieu"
  [ -z "$benh" ] && ok "khong container unhealthy" || hong "unhealthy: $benh"
}

kiem_conf(){
  echo "* .99: bang cong + tuong lua"
  conf=$("${S[@]}" ssv@192.168.1.99 'cat /etc/ginsengfood/cong-noi-bo.conf; echo "#svc=$(systemctl is-active gf-tuong-lua)"' 2>/dev/null)
  n60=$(printf '%s\n' "$conf" | grep -cE "$R60"); n61=$(printf '%s\n' "$conf" | grep -cE "$R61")
  svc=$(printf '%s\n' "$conf" | sed -n 's/^#svc=//p')
  [ "$svc" = active ] && ok "gf-tuong-lua active" || hong "gf-tuong-lua: $svc"
  if [ "$CHE" = truoc ]; then
    [ "$n60" = 1 ] && [ "$n61" = 1 ] && ok "2 dong TAM con nguyen (moi dong 1 lan)" || hong "dong TAM: .60/8443=$n60 .61/8445=$n61 (mong 1/1)"
  else
    [ "$n60" = 0 ] && [ "$n61" = 0 ] && ok "dong TAM da het" || hong "dong TAM con: .60/8443=$n60 .61/8445=$n61"
  fi
  d=$(printf '%s\n' "$conf" | grep -E '[[:space:]]8446[[:space:]]' || true)
  echo "  ..   dong 8446 (giu nguyen): ${d:-(chua co)}"
}

kiem_cu(){
  echo "* .60/.61: con app nao goi cong TAM khong"
  if c60=$("${S[@]}" ssv@192.168.1.60 'docker ps --format "{{.Names}}"' 2>&1); then
    la=$(printf '%s\n' "$c60" | grep -E '^m34-|m8|ivr' | grep -vxE 'm34-pg-1|m34-clamav-1' || true)
    [ -z "$la" ] && ok ".60 khong con app M3/M8 (dang chay: $(echo $c60))" || hong ".60 con app: $(echo $la)"
  else hong ".60 khong vao duoc: $c60"; fi
  if c61=$("${S[@]}" ssv@192.168.1.61 'docker ps --format "{{.Names}}"' 2>&1); then
    la=$(printf '%s\n' "$c61" | grep -E 'm8|ivr|m12|ops|m34' || true)
    [ -z "$la" ] && ok ".61 khong con app M8/M1-2 (dang chay: $(echo $c61))" || hong ".61 con app: $(echo $la)"
  else hong ".61 khong vao duoc: $c61"; fi
}

kiem_chan(){
  echo "* .60/.61 da het vao cong TAM (dung y)"
  c=$("${S[@]}" ssv@192.168.1.60 "curl -sk -o /dev/null -m 5 -w '%{http_code}' https://192.168.1.99:8443/health/live" 2>/dev/null)
  [ "$c" = 000 ] && ok ".60 -> .99:8443 bi chan" || hong ".60 -> .99:8443 van vao ($c)"
  c=$("${S[@]}" ssv@192.168.1.61 "curl -sk -o /dev/null -m 5 -w '%{http_code}' https://192.168.1.99:8445/" 2>/dev/null)
  [ "$c" = 000 ] && ok ".61 -> .99:8445 bi chan" || hong ".61 -> .99:8445 van vao ($c)"
}

echo "kiem-go-tam-99 $CHE · $(date '+%d/%m %H:%M')"
if [ "$CHE" = truoc ]; then
  kiem_cu; kiem_conf; kiem_99
  [ "$LOI" = 0 ] && echo "=> DU DIEU KIEN go dong TAM" || echo "=> CHUA DU DIEU KIEN — khong go, xem dong HONG"
else
  kiem_conf; kiem_99; kiem_chan
  [ "$LOI" = 0 ] && echo "=> DAT" || echo "=> CO HONG — M1-2/M3/M8 hong thi tra ban .bak (duong lui trong go-dong-tam-99.sh)"
fi
exit "$LOI"
