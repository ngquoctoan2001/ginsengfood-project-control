#!/usr/bin/env bash
# Dọn rác CI trên .63 mỗi đêm (cron 03:00). KHÔNG dùng docker … prune, KHÔNG động container/volume/image đang dùng bởi stg_*.
set -uo pipefail
GOC="/home/ssv/dev/gitlab-runner"
echo "== $(date '+%F %T')"
# 1. Container job runner đã dừng quá 1 ngày (runner thường tự xoá; đây là phần sót).
docker ps -a --filter "label=com.gitlab.gitlab-runner.type" --filter "status=exited" --format '{{.ID}} {{.Names}}' \
  | while read -r id ten; do case "$ten" in stg_*) ;; *) docker rm "$id" >/dev/null && echo "xoa container $ten";; esac; done
# 2. Image lơ lửng (không tên) — không phải image bản thử stg.
docker images --filter dangling=true -q | sort -u | while read -r img; do docker rmi "$img" >/dev/null 2>&1 && echo "xoa image $img"; done
# 3. Cảnh báo ổ.
dung=$(df --output=pcent / | tail -1 | tr -dc '0-9')
if [ "${dung:-0}" -gt 80 ]; then echo "CANH BAO: o / dung ${dung}%"; echo "$(date '+%F %T') o / ${dung}%" >> "$GOC/canh-bao.log"; fi
echo "o / ${dung}%"
