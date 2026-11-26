#!/bin/bash
# Dựng 5 image M1-M2 từ ĐÚNG commit (git archive nên cây dở không lọt vào), D-m12-133. Không đẩy lên registry, không ssh.
# Dùng: build_m12_images_sha.sh <sha40> [--can-head]   (--can-head: dừng nếu HEAD != sha, dùng cho bản cuối)
set -euo pipefail
cd /c/Projects/ginsengfood-ops-core
SHA="${1:?can sha40}"
[[ "$SHA" =~ ^[0-9a-f]{40}$ ]] || { echo "sha phai 40 ky tu hex" >&2; exit 2; }
if [ "${2:-}" = "--can-head" ]; then [ "$(git rev-parse HEAD)" = "$SHA" ] || { echo "HEAD đã đổi, dừng" >&2; exit 2; }; fi
git cat-file -e "$SHA^{commit}"
REG=registry.gitlab.com/nqt20102001/ginsengfood-ops-core
SP="C:/Users/ADMINI~1/AppData/Local/Temp/claude/0d8e0f0b7c910113/6b4be261-c086-4b8d-b8a0-d709823e1a2e/scratchpad"
CTX="$SP/m12-ctx-$SHA.tar"
git archive --format=tar "$SHA" > "$CTX"
ls -l "$CTX" | awk '{print "context tar bytes:", $5}'
LBL="--label org.opencontainers.image.revision=$SHA"

echo "[1/5] ops-core-api"; date +%T
docker build -f services/operational-api/Dockerfile $LBL --build-arg SOURCE_REVISION=$SHA -t $REG/ops-core-api:$SHA - < "$CTX"
echo "[2/5] ops-core-migrate"; date +%T
docker build -f services/operational-api/Dockerfile.migrate $LBL -t $REG/ops-core-migrate:$SHA - < "$CTX"
echo "[3/5] admin-web"; date +%T
docker build -f apps/admin-web/Dockerfile $LBL \
  --build-arg NEXT_PUBLIC_OPERATIONAL_API_URL=https://ops.ginsengfood.vn --build-arg ALLOW_INSECURE_API_ORIGIN=false \
  --build-arg NEXT_PUBLIC_API_RECALL_CLOSE_APPROVAL=true --build-arg NEXT_PUBLIC_API_TRACE_CUSTOMER_REFERENCES=true \
  --build-arg NEXT_PUBLIC_API_RAW_STOCK_ISSUABLE_QUANTITY=true -t $REG/admin-web:$SHA - < "$CTX"
echo "[4/5] public-trace"; date +%T
docker build -f apps/public-trace/Dockerfile $LBL \
  --build-arg NEXT_PUBLIC_TRACE_API_URL=http://ops-core-api:5000 --build-arg NEXT_PUBLIC_TRACE_MEDIA_ORIGINS=https://trace.ginsengfood.vn \
  --build-arg NEXT_CSP_REPORT_URI= --build-arg NEXT_PUBLIC_ALLOW_INSECURE_API_ORIGIN=true -t $REG/public-trace:$SHA - < "$CTX"
echo "[5/5] shopfloor-pwa"; date +%T
docker build -f apps/shopfloor-pwa/Dockerfile $LBL \
  --build-arg NEXT_PUBLIC_SHOPFLOOR_API_URL=https://pwa.ginsengfood.vn --build-arg NEXT_PUBLIC_ALLOW_INSECURE_API_ORIGIN=false \
  -t $REG/shopfloor-pwa:$SHA - < "$CTX"
date +%T
docker images --format '{{.Repository}}:{{.Tag}} {{.ID}} {{.Size}}' | grep "$SHA" | sed 's/registry.gitlab.com\/nqt20102001\/ginsengfood-ops-core\///' | cut -c1-120
echo BUILD_XONG
