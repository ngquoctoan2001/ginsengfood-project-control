#!/usr/bin/env bash
# m34.99 bước 3 (D-m34-076): đưa gói M3/M4/M9 trên .99 lên <sha40> (đã push lên origin/toandeptrai, CI m34-images xanh có image).
# Chạy trên máy Toàn: bash cap-nhat-99.sh <sha40>   — chỉ sau tin "M8 .99 XONG" của m8 phụ, không trong buổi nghiệm thu M1-2.
# Chép đúng các tệp bộ triển khai liệt kê dưới (bản <sha40>, qua git archive, không lấy cây làm việc), rồi r-cap-nhat-99.sh trên .99.
. "$(dirname "${BASH_SOURCE[0]}")/chung.sh"
SHA=${1:?thiếu sha40}
[[ $SHA =~ ^[0-9a-f]{40}$ ]] || dung "sha40 sai dạng"
REPO=${M34_REPO:-C:/Projects/ginsengfood-business-platform}
git -C "$REPO" merge-base --is-ancestor "$SHA" origin/toandeptrai 2>/dev/null || dung "$SHA chưa có trên origin/toandeptrai (chưa push?)"
TEP=(compose.yml env.mau nginx/m34.conf README.md crontab.mau compose.m5-cua.yml m5-cua/tao-chung-thu-m5-cua.sh m5-cua/.gitignore
     m8-that/kiem-m3-chi-doc.sh m8-that/BANG_CHUNG_M3.md m8-that/M8_THAT.md don-thu/README.md don-thu/nap-don-thu.sql don-thu/go-don-thu.sql)
LOG="$NHAT_KY_LOCAL/cap-nhat-99-$(moc).log"
{
  tieu_de "chép ${#TEP[@]} tệp bộ triển khai bản ${SHA:0:9} lên .99/_cap-nhat"
  git -C "$REPO" archive --format=tar "$SHA" "${TEP[@]/#/deploy/m34/}" \
    | lenh 99 "rm -rf $D99/_cap-nhat && mkdir -p $D99/_cap-nhat && tar -x -C $D99/_cap-nhat --strip-components=2 && find $D99/_cap-nhat -type f | wc -l" \
    || dung "chép tệp hỏng"
  tieu_de "cài + trien-khai.sh + kiểm (.99)"
  chay 99 r-cap-nhat-99.sh "$SHA"
} 2>&1 | tee "$LOG"
