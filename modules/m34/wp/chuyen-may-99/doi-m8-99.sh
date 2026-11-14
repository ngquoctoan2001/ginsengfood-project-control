#!/usr/bin/env bash
# Sau tin "M8 PHA B XONG" (m8 phụ 14/11 07:46): M3 trên .99 chuyển sang gọi M8 ở .99 — M8_ORIGIN + Issuer https://192.168.1.99:8443,
# ca-m8.pem mới (~/m8-chuyen-99/ca-m8-99.pem trên máy Toàn, vân tay SHA-256 m8 báo), be.env ghim lại, tạo lại be + cầu, gọi thử
# /health/live để m8 đọc IP nguồn rồi allow. M8_ALLOW_IP đo và đặt ở bước sau. Hỏng thì tự lùi về bản cũ.
# Chạy: bash "C:/Projects/Project Control/modules/m34/wp/chuyen-may-99/doi-m8-99.sh"
. "$(dirname "${BASH_SOURCE[0]}")/chung.sh"
LOG="$NHAT_KY_LOCAL/doi-m8-99-$(moc).log"
CA_MOI=${M34_CA_M8_MOI:-$HOME/m8-chuyen-99/ca-m8-99.pem}
VT_M8_BAO='01:39:29:F5:61:81:11:92:21:9F:20:11:7D:B5:0B:12:33:CD:E6:DA:11:8C:4E:0C:A5:4F:73:82:08:FD:86:E1'
{
  tieu_de "M8.1 máy Toàn: ca-m8.pem mới đúng vân tay m8 báo"
  [ -s "$CA_MOI" ] || dung "thiếu $CA_MOI"
  vt=$(openssl x509 -in "$CA_MOI" -noout -fingerprint -sha256 | sed 's/^.*=//')
  [ "$vt" = "$VT_M8_BAO" ] || dung "vân tay $CA_MOI ($vt) khác m8 báo"
  vt_hex=$(printf '%s' "$vt" | tr -d ':' | tr 'A-F' 'a-f')
  echo "khớp: $vt"

  tieu_de "M8.2 chép ca-m8.pem mới sang .99 (m8-that/bi-mat/ca-m8.pem.moi, 600)"
  lenh 99 "umask 077 && cat > $D99/m8-that/bi-mat/ca-m8.pem.moi && echo CHEP_XONG" < "$CA_MOI" || dung "chép ca-m8.pem mới hỏng"

  tieu_de "M8.3 .99: M8_ORIGIN, ca-m8.pem, be.env, tạo lại be + cầu, gọi thử M8"
  chay 99 r-doi-m8-99.sh "$vt_hex"
  tieu_de "M8 XONG (bước 1): báo m8 dòng GOI_THU_M8 ở trên; m8 allow xong thì đo nguồn callback ở cầu rồi đặt M8_ALLOW_IP"
} 2>&1 | tee "$LOG"
