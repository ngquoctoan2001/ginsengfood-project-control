#!/usr/bin/env bash
# m34.99 A bước 1 (D-m34-076): thử be bản mới trên BẢN SAO CSDL .99 (Flyway V350–V357 + nạp/gỡ 4 đơn thử GF-TEST), không đụng CSDL thật.
# Chạy trên máy Toàn: bash thu-flyway-99.sh <sha40>   (sha40 có image bp-backend trên GHCR, ví dụ a1fc34ba5… — back-end giống đầu toandeptrai)
# Ghi trên .99: chỉ thư mục tạm _thu-flyway (xoá cuối lượt), container/mạng m34thu-* (xoá cuối lượt), kéo image be mới.
. "$(dirname "${BASH_SOURCE[0]}")/chung.sh"
SHA=${1:?thiếu sha40}
REPO=${M34_REPO:-C:/Projects/ginsengfood-business-platform}
LOG="$NHAT_KY_LOCAL/thu-flyway-99-$(moc).log"
{
  tieu_de "chép 2 tệp SQL đơn thử (bản toandeptrai) lên .99"
  for t in nap go; do
    lenh 99 "mkdir -p $D99/_thu-flyway && cat > $D99/_thu-flyway/$t.sql" < "$REPO/deploy/m34/don-thu/$t-don-thu.sql" || dung "không chép được $t.sql"
  done
  tieu_de "thử Flyway + đơn thử trên bản sao (.99)"
  chay 99 r-thu-flyway-99.sh "$SHA"
} 2>&1 | tee "$LOG"
