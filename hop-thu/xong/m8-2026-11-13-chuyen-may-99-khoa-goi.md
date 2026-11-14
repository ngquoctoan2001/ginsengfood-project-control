# Từ phiên phụ m8 (chuyển app M8 sang .99) · 13/11/2026 · khoá gói W-0537 đã commit, pha a + ARI đạt trên máy thật

Tiếp tin `hop-thu/xong/m8-2026-11-13-chuyen-may-99-xong.md`.

- **Commit local mới trên `main`** (`GIT_INDEX_FILE` riêng, không đụng `docs/weekly-tracking/nguyen-quoc-toan.md` và
  `deploy/operations/m34_mock_agent*.py`):
  - **W-0535 `c80528db`**: `tren-61.sh anh` lấy tham chiếu image từ container (lần pha a thật đầu dừng ở a5 vì
    `config --images <dv>` in cả image phụ thuộc); `chuyen.sh` không gắn nhãn image ghim id. 33 test, đột biến 3/3.
  - **W-0537 `be16a692`**: chỉ đầu ra `refresh-locks.mjs` (libc6 8.9→8.12; libc-dev-bin, libc6-dev →8.12; perl, libperl,
    perl-modules 0.6→0.7; thêm libc6, libc-bin, perl-base; docker-cli r0→r1 bằng `--write --upgrade --only ops-agent-apk.lock`
    vì CDN lúc còn lúc mất r0). Bảng gói ở thân commit và `modules/m8/wp/chuyen-may-99.md`. `--check` CLEAN.
  - **`eca6670f` (W-0537)**: trả lại `evidence` của W-0536 trong `gate-status.yaml` mà lần sinh lại ở `be16a692` làm mất.
  - `NEXT_WORK_ID` giờ là **W-0538**.
- Gitleaks `af93ca42..c80528db` 0; `GATE_STATUS_PASS`, `DOCUMENT_LINKS_PASS` trên `eca6670f`. Quét trước push đầy đủ trên
  `eca6670f` đang chạy (dựng mọi image, trivy, khoá, PII, gate-sweep); xong thì gitleaks lần nữa rồi trình Toàn **push cả chuỗi
  tới HEAD** (gồm W-0534 và W-0536 của phiên chính). Phiên chính commit thêm trước lúc đó thì quét phải chạy lại trên HEAD mới.
- Trên máy (13/11 16:13–16:33, .61 chỉ đọc): `kiem` ĐẠT, `mo-64` ĐẠT, pha a ĐẠT (postgres+api+https .99 healthy, CSDL bản sao,
  8443 ghim ĐẠT từ máy Lead), cầu ARI .99 → .64 `ari_http 401` ĐẠT. Pha b chờ m34 cắt xong.
- Tin `hop-thu/m8-2026-11-13-m34-cat-khong-gio-co-dinh.md` (8443 .61 thêm nguồn .99, URL callback sang .99:8445) là việc của
  phiên chính; phiên phụ không đụng .61 ngoài lệnh đọc. Pha b chép lại du-lieu từ .61, nên URL callback mới theo sang .99.

Đọc xong chuyển sang `hop-thu/xong/`.
