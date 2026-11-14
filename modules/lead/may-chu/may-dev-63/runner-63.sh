#!/usr/bin/env bash
# Runner GitLab cho repo ginsengfood-ivr chạy trên máy dev .63 (kế hoạch 2026-11-14-ke-hoach-may-dev-63.md).
# Chạy trên .63 bằng tài khoản ssv (nhóm docker, không cần sudo).
#   bash runner-63.sh chuan-bi   # tạo thư mục, kéo image runner
#   bash runner-63.sh dang-ky    # hỏi mã runner (glrt-…) KHÔNG hiện chữ, đăng ký, ghi config — Toàn tự dán mã
#   bash runner-63.sh chay       # khởi động container runner (tự lên lại khi máy khởi động lại)
#   bash runner-63.sh kiem       # trạng thái, KHÔNG in mã
#   bash runner-63.sh dung       # đường lui: dừng runner trên .63
# Không bao giờ chạy docker … prune, không động container/volume stg_* (luật ~/staging/README.txt).
set -euo pipefail

ANH="gitlab/gitlab-runner:v19.2.0"           # cùng bản runner máy Lead
GOC="/home/ssv/dev/gitlab-runner"
CFG="$GOC/config"
TEN="gitlab-runner-63"

case "${1:-}" in
  chuan-bi)
    mkdir -p "$CFG" "$GOC/nhat-ky"
    chmod 700 "$CFG"
    docker pull "$ANH" >/dev/null
    echo "OK chuan-bi: $(docker image inspect "$ANH" --format '{{.Id}}' | cut -c1-19)"
    ;;
  dang-ky)
    if [ -s "$CFG/config.toml" ] && grep -q '^\[\[runners\]\]' "$CFG/config.toml"; then
      echo "Da co runner trong $CFG/config.toml, khong dang ky lai."; exit 1
    fi
    printf 'Dan ma runner (glrt-...) roi Enter (khong hien chu): '
    IFS= read -rs MA; echo
    case "$MA" in glrt-*) ;; *) echo "Ma khong dung dang glrt-..., dung."; exit 1;; esac
    docker run --rm -v "$CFG":/etc/gitlab-runner "$ANH" register --non-interactive \
      --url "https://gitlab.com" --token "$MA" --name "may-63" \
      --executor docker --docker-image "debian:bookworm-slim" --docker-privileged \
      --docker-volumes "/cache" --docker-cpus "6" --docker-memory "16g" \
      --limit 1 --request-concurrency 1 >/dev/null 2>"$GOC/nhat-ky/dang-ky.err" || { echo "Dang ky LOI, xem $GOC/nhat-ky/dang-ky.err"; unset MA; exit 1; }
    unset MA
    sed -i 's/^concurrent = .*/concurrent = 1/' "$CFG/config.toml"
    chmod 600 "$CFG/config.toml"
    echo "OK dang-ky: runner may-63 da ghi config (1 job mot luc, 6 nhan, 16 GB)."
    grep -E '^(concurrent|  (name|executor|limit)|    (privileged|cpus|memory|image)) ' "$CFG/config.toml" || true
    ;;
  chay)
    docker rm -f "$TEN" >/dev/null 2>&1 || true
    docker run -d --name "$TEN" --restart unless-stopped \
      --cpus 1 --memory 512m \
      -v "$CFG":/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock \
      "$ANH" >/dev/null
    sleep 5
    docker ps --filter "name=$TEN" --format '{{.Names}} | {{.Status}}'
    ;;
  kiem)
    docker ps --filter "name=$TEN" --format '{{.Names}} | {{.Status}}'
    docker logs --tail 30 "$TEN" 2>&1 | grep -vE 'token|glrt-' | tail -15 || true
    echo "--- job dang chay:"; docker ps --filter "label=com.gitlab.gitlab-runner.type" --format '{{.Names}} | {{.Status}}'
    df -h / | tail -1
    ;;
  dung)
    docker stop "$TEN" && echo "Da dung runner tren .63 (con config, bat lai: bash runner-63.sh chay)."
    ;;
  *) echo "Dung: bash runner-63.sh {chuan-bi|dang-ky|chay|kiem|dung}"; exit 2;;
esac
