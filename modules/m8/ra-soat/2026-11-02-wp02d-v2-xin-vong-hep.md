# WP02D — đề xuất một vòng sửa hẹp sau verifier R3 vòng 2

Mốc 02/11/2026 13:22 UTC+7. Chưa sửa theo đề xuất này; chưa ghép WP02D vào main.
VM đang kiểm: `fbce0e1d5dd0864343c2d94b107da0be8de804108cb15cbd5d7d4fb10d04ec73`.

## Điều còn thiếu

V1 (reprepare tự nhận token/key mới) đã bị chặn, bao gồm khoảng từ prepare đầu tới apply.
V2: CLI thay `ari_secret_file` sang tệp khác có cùng nội dung gọi `host_preflight` một lần trước
khi `prepare` từ chối path set mới. Preflight chạy `docker run --rm` để kiểm phiên bản/quyền;
chưa `compose up`, chưa activate bản mới. Luồng phải từ chối trước bước chạy container tạm này.
Probe độc lập: `docs/evidence/W-0489/verifier-r2-cli-path-probe.py` — 1 FAIL, 0 ERROR;
log giữ nguyên. Các bộ trước đó đạt: VM108, cutover116 (đã gồm các ca độc lập), 84 độc lập
chạy riêng, V1 probe1 và fresh nested Docker11; không cộng các số thành tổng riêng.

## Diff dự kiến, chưa áp dụng

Chỉ phần `main()` tại `deploy/telephony-vm/vm_deploy.py`, trước `host_preflight`:

```diff
         if args.action in ("prepare", "apply"):
-            external_baseline(root)
+            baseline = external_baseline(root)
+            pins = external_inputs(settings, stack) if stack else None
+            require(baseline is None or pins == baseline,
+                    "External private input identity changed; preflight cannot authorize rotation")
             host_preflight(settings, stack=stack)
             release = prepare(settings, root, stack=stack)
```

Giữ nguyên check trong `prepare` để kiểm lại sau preflight; không thêm quyền rotation, không
chuyển kiểm ra ngoài lock, không sửa baseline/secret bytes hoặc candidate niêm phong.
Cập nhật hash tool bằng byte thật, thêm regression CLI prepare/apply có state/chưa state,
path khác nhưng nội dung bằng nhau; khôi phục đúng path vẫn cho phép retry.

## Kết luận verifier vòng 2 đã đóng băng

[Báo cáo độc lập](C:/Projects/_wt/m8/m8-wp02d/docs/evidence/W-0489/verifier-r2-review.md): **CẦN SỬA V2**.
Freeze35 tệp SHA256 `c54162e82c41f7b64b2486e298ff37efad3563b54cf6bcf23953ef388a960ade`;
177/177 hash bảo vệ không đổi, mutation3/3 bị bắt, PII32/32 đạt; không còn tài nguyên Docker verifier.

## Vòng hẹp đề nghị

Original coder sửa đúng guard trên và regression; verifier độc lập chạy lại probe V2,
VM/cutover + bộ độc lập bị ảnh hưởng, mutation bỏ guard và nested11 trên tool SHA mới.
DB/secrets không đổi được đối chiếu hash, không gọi bộ full cũ là một candidate mới.
Nếu vẫn có lỗi: dừng, không tự mở thêm vòng. Sau khi đạt vẫn trình diff R3 trước ghép.
Không commit/push/deploy/SSH hoặc gọi khách từ việc chấp thuận vòng sửa.

Căn cứ: [/song bước 5](../../../.claude/commands/song.md) ghi
“vẫn chưa đạt sau vòng 2 → dừng WP, báo Lead”; [CÁCH LÀM §4](../../../chung/CACH_LAM.md)
ghi “Hai vòng vẫn chưa đạt → dừng, báo Lead”. Vì vậy m8.15 xin đúng một vòng hẹp,
không xin tự duyệt hoặc bỏ qua verifier. `REAL_CUSTOMER_CALL_ALLOWED=NO`.
