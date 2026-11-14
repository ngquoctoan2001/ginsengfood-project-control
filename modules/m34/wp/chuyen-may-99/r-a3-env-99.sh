# r-a3-env-99.sh (.99): đổi đúng 3 khoá KHÔNG bí mật của .env (thư mục .99) sang .99. Không in giá trị nào khác.
# Giữ nguyên: bí mật (cùng bộ với .60, dữ liệu nạp từ .60 cần đúng các khoá này), M8_ORIGIN/M8_ALLOW_IP (M8 còn ở .61),
# OPS_CORE_BASE_URL (M1–M2 còn ở .61): đổi khi luồng m8/m12 cắt (CHUYEN_MAY_99.md mục 5).
cd "$G"
[ -f .env ] || dung "thiếu $G/.env (A2 chưa chép?)"
# .env vừa chép từ .60 (A2, hoặc B3b chép lại) thì lưu làm .env.tu-60; chạy lại trên .env đã đổi thì giữ bản lưu cũ.
if [ ! -e .env.tu-60 ] || grep -qx 'M34_BIND_IP=192.168.1.60' .env; then cp -p .env .env.tu-60; fi
chmod 600 .env .env.tu-60
dat() {  # dat <TÊN> <giá trị>: một dòng TÊN=giá trị (thay chỗ cũ, gộp dòng trùng, hoặc thêm cuối). Chỉ cho tên không bí mật.
  local tam
  tam=$(mktemp "$G/.env.XXXXXX")
  awk -v k="$1" -v v="$2" 'index($0, k "=") == 1 { if (!d) { print k "=" v; d = 1 } next } { print } END { if (!d) print k "=" v }' .env > "$tam"
  chmod 600 "$tam"
  mv -f "$tam" .env
}
dat M34_BIND_IP 192.168.1.99
dat M3_CB_BIND_IP 192.168.1.99
cors=$(doc_env CORS_ALLOWED_ORIGINS)
if [ -z "$cors" ]; then
  dat CORS_ALLOWED_ORIGINS http://192.168.1.99
else
  dat CORS_ALLOWED_ORIGINS "$(printf '%s' "$cors" | sed 's#http://192\.168\.1\.60\([,[:space:]]\|$\)#http://192.168.1.99\1#g')"
fi
for k in M34_BIND_IP M3_CB_BIND_IP CORS_ALLOWED_ORIGINS M8_ALLOW_IP M8_ORIGIN OPS_CORE_BASE_URL COMPOSE_FILE; do
  printf '  %s=%s\n' "$k" "$(doc_env "$k")"
done
echo "  khoá đổi so với .60: $(diff .env.tu-60 .env | sed -n 's/^[<>] \([A-Za-z0-9_]*\)=.*/\1/p' | sort -u | tr '\n' ' ')"
grep -q '192\.168\.1\.60' .env && echo "  CÒN dòng chứa 192.168.1.60: $(grep '192\.168\.1\.60' .env | cut -d= -f1 | tr '\n' ' ')" || true
if [ -f compose.override.yml ] && grep -q '192\.168\.1\.60' compose.override.yml; then
  echo "  CÒN 192.168.1.60 trong compose.override.yml (ngoài repo) ở dòng: $(grep -n '192\.168\.1\.60' compose.override.yml | cut -d: -f1 | tr '\n' ' ')— xem pha 0; trỏ M7/.60 thật thì giữ, gắn cổng/IP máy thì sửa trước A8"
fi
[ "$(stat -c %a .env)" = 600 ] || dung ".env không phải 600"
echo A3_XONG
