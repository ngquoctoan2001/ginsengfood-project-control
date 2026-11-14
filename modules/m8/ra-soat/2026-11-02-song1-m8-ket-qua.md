# M8 — kết quả sóng 1 ngày 02/11/2026

Chốt lúc 14:18 UTC+7. Đã ghép local phần được duyệt; cleanup bản sao bị chặn bởi automatic approval review.
Repo `C:\Projects\ginsengfood-ivr`, nhánh main sạch. Không push, PR, deploy, SSH hoặc gọi thật.

## Định danh và quyền thực hiện

- Base khảo sát/archive: `c9f0cd188f4966d07aafb3155039656b1b451034`.
- Commit mã và bằng chứng từng gói: `1ef80eb287e9b2170ad03694fe7920a420eccfdc`, đúng 534 tệp allowlist.
- Commit sáu tệp bằng chứng cuối: `a625d6943dff9d4736422c71484bcf2c4765aef7`; không thay mã đã kiểm.
- D-m8-011 duyệt kiến trúc A và chạy sóng; D-m8-012 cho nguồn M3 mới/clean; D-m8-013 cho một vòng sửa hẹp V2; D-m8-014 duyệt diff R3 để ghép/commit local. Không còn chờ duyệt ghép WP02D.
- Các archive giữ base cố định, coder/tester/verifier tách vai; parent ghép tuần tự và sở hữu sổ chung.

## Kết quả từng gói

| Gói | Kết quả | Bằng chứng chính trong repo IVR |
|---|---|---|
| WP02D / W-0489 | ĐẠT công cụ/lab. Bộ ba asterisk/receiver/ari-link có identity, ownership, journal, rollback và preflight guard; V1/V2 đã đóng. Main VM112/cutover116 đạt; verifier lab bộ ba 11 ca đạt. | `docs/evidence/W-0489/parent-main.md`, `parent-main-results.json`, `verifier-r3-freeze.json` |
| WP07A / W-0490 | ĐẠT sửa bốn lỗi gate. 23 regression Windows/18 dispatch Linux đạt; default gates trên bản ghép cuối 51/51. Scanner/pattern/TSV không đổi. | `docs/evidence/W-0490/parent-final-gates.md`, `parent-gate-result.json`, `parent-gate-sweep.log` |
| WP04A / W-0491 | ĐẠT nguồn/công cụ. 80/80 test, 7/7 báo cáo giải được toàn bộ dòng về nguồn, 7/7 tái tạo byte giống nhau; 3 mutation và 3 drift negative đạt. 455 tên M3 chờ duyệt nội dung. | `docs/evidence/W-0491/CURRENT.md`, `parent-final-integration.json`, `privacy-r2-CURRENT.json` |
| WP07D | ĐẠT hồ sơ triển khai cụm .61/.64, 20/20 nguồn kiểm độc lập; không thay candidate hoặc nghiệm thu G5. | [Bản khai](2026-11-02-ban-khai-trien-khai-m8.md), [verifier](2026-11-02-wp07d-verifier.md) |

WP02D dùng patch đã duyệt SHA-256 `33340dbb0cc8885e71e2e5ce66227e2e43e0f878de75df761bf3a530590f4dde`; parent xác minh 236/236 byte sau ghép. Các bộ độc lập 46 VM/7 DB/8 secrets/23 cutover và hai probe cũng đạt trên main; số ca có giao nhau, không cộng thành tổng mới. Lab Docker lồng nhau dùng fixture TLS/proxy/media và image import offline, chưa chứng minh inter-host mTLS, carrier hoặc production image-manifest identity.

WP04A current manifest SHA `350068cb449786d4bc5a602a590d1c85d3bc0d9d11618b908731f3a99b170d2d`; verifier manifest SHA `ee69b77a8b8526414f20e2ba44401ebfc20b430e9b6f55de6f3f8421f757cbdd`. Parent đối chiếu 183/183 tệp và chạy lại 80 test. Báo cáo kiểm tra giữ ID/parent/namespace/status/hash/locator; tên gốc nằm tại nguồn chức năng. Không đổi scanner, không nhận hash là ẩn danh.

## Nguồn địa bàn mới

- M3 chỉ đọc tại `C:\Projects\ginsengfood-business-platform`, nhánh `toandeptrai`, commit `547dd59a0c1d3c1257afbd0688a50ab084c5715f`.
- Tệp nguồn `back-end/src/main/resources/reference-data/vietnam-address-tree.json`, blob `b4c31b195a3c6bed0853b34f487ba788f4a60809`.
- SHA-256 bản Git LF: `c7216ff910c8c2f8eb1bc3e6c21e9941255f7fb98c8688003d98b9d2f5d3ea46`; M8 lưu tại `deploy/reference-data/vietnam-addresses/` gồm cây gốc, provinces, wards và manifest.
- 34 tỉnh/thành, 3.321 đơn vị cấp xã; giữ mã chuỗi/số 0 đầu và quan hệ cha. Mã thuộc namespace nội bộ M3, không phải mã hành chính quốc gia.
- So tên và tỉnh: 2.854 exact + 12 format = 2.866 khớp duy nhất; 455 pending, 0 ambiguous. Không ghép theo mã trùng số. Không tự sửa loại của 13 bản ghi “Đặc khu”.
- Đây là nguồn mới cho chuẩn bị WP07V. L26 lịch sử chưa phục hồi binding; không dùng nguồn mới để nhận lại namesCompared cho L26. Receipt 92 mẫu/audio/MODELS giữ nguyên, chưa sinh hoặc duyệt audio mới.
- M3 source/HEAD/status được kiểm không đổi quanh thao tác lấy nguồn. Không sửa luồng M3→M8 của Lead.

## Kiểm cuối và sổ

- Lệnh đầy đủ: Git Bash chạy `node deploy/ci/scripts/gate-sweep.mjs` trên clean main `1ef80eb2`, từ 06:57:47 đến 07:09:11 UTC; exit 0, **51/51 PASS, 39 skipped by manifest**.
- HEAD/tree/status và 534 SHA tệp nguyên vẹn trước/sau; không còn gate lock. Log SHA-256 `3d48e0cd28a6d9c85ac2e903e1f0f17a73ef5a34745b89240d2c6d7c517e161d`.
- R1 50/51 và các lỗi môi trường harness trước đó giữ làm lịch sử, không đổi thành PASS. Full mới thay kết luận hiện tại chỉ trên đúng nguồn đã nêu.
- Sau đó sáu tệp bằng chứng mới qua PII (6 text, 0 binary, 0 exception), document-links (0 thiếu) và gate-status. Diff check đạt; GitNexus detect-changes trước commit bằng chứng không phát hiện symbol/flow thay đổi. Không chạy lại full chỉ vì thêm bằng chứng.
- `dotnet build-server shutdown` thành công. Tracker M8-007 đã đồng bộ đúng một lần cho sóng với agent Codex, trạng thái REVIEW; ghi kết quả M8-002/M8-004 kèm. Không sinh weekly file cho M8.
- Sổ sinh lại 479 work items, 310 ACCEPTED không đổi, 118 EVIDENCE_SUBMITTED, 11 gate ngoài; board vẫn 0/4. Readiness giữ 46%, G1–G8 chưa đóng.

## Giới hạn và cleanup

Một phát hiện `generic-api-key` tại cấu hình tracker dòng 5 còn để Lead xử lý; chỉ ghi metadata đã che, validity NOT_TESTED. Không in, kiểm hiệu lực hoặc sao chép giá trị. PII/default-gate PASS không chứng minh secret-clean. Dữ liệu địa bàn chức năng công khai có 110 lượt khớp rule PII chung đã phân loại; không tuyên bố toàn repo sạch PII.

Docker helper riêng đã xóa sau kiểm không còn container dùng; các container/network/volume lab riêng đã dọn theo ID. Automatic approval review từ chối xóa archive WP02D/WP07A và hai thư mục verifier-deps/verifier-mirror của WP04A trước khi thực thi, lý do “blocked by policy”. Giữ nguyên, không thử cách xóa khác; [biên bản cleanup](2026-11-02-song1-cleanup.json). Các patch/bằng chứng gốc được giữ để đối chiếu.

`.61` chỉ là nơi lưu khóa LAB theo D-m8-010; kho khóa production phải chốt trước cấp production/release. Giữ `REAL_CUSTOMER_CALL_ALLOWED=NO`, `production_accepted=false`, `deployable=false`. Không nhận gate local là hosted CI, UAT, gọi khách hay nghiệm thu production.

Sóng 2 đề xuất: **WP02E + WP03A + WP01A phần M8**; phụ thuộc công cụ WP02D đã đạt. Chưa bắt đầu sóng 2. WP07V còn nội dung/chữ ký/artifact; 455 tên cần duyệt trước nghiệm thu mới.
