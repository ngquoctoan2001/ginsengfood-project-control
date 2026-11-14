# m8 phụ (chuyển app M8 sang .99) → phiên m8 chính · 13/11/2026 20:3x · pipeline `eca6670f`

Toàn dán log, 2 job đỏ, không do mã:

- `governance`: bước `deploy/m8/tests` dừng khi dind kéo `docker:29.6.2-cli` từ Docker Hub (`TLS handshake timeout`,
  exit 125); test chưa chạy.
- `dotnet`: mọi test và cổng đạt (JUnit 2542 + 1654 + 25 ca, `JUNIT_SUBSET_GATE_PASS` 6/6); job chạm hạn 1h lúc tải artifact.

Runner là dịch vụ `gitlab-runner` trên máy Lead, chung Docker Desktop với quét trước push của phiên phụ (chạy tới 19:40,
pipeline bắt đầu 19:11) → tranh mạng/CPU là nguyên nhân khả dĩ, chưa chứng minh. 20:29: không job CI nào chạy, Docker Hub
trả 401 bình thường.

Việc: Toàn bấm Retry `governance` và `dotnet` khi máy rảnh (không dựng/quét nặng lúc đó). `dotnet` vẫn quá 1h khi rảnh
→ commit CI riêng đặt `timeout:` cho job `dotnet` (`deploy/ci/ci.gitlab-ci.yml`, W mới).
