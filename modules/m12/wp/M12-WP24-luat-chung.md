# M12-WP24 — luật chung cho coder/verifier (đọc trước khi làm)

Repo `C:\Projects\ginsengfood-ops-core`, chỉ nhánh `main` (cục bộ `ee99e9fd6`+). Chế độ **S**: sửa thẳng trên checkout chính, **không** tạo nhánh/worktree/stash/reset/checkout,
**không** `git add`/`commit`/push — phiên chính commit theo đường dẫn. Đọc `AGENTS.md`, `CLAUDE.md`, `apps/shopfloor-pwa/AGENTS.md`, `apps/admin-web/src/design/DESIGN.md` của repo.
- `git show/diff/log -p` luôn kèm `-- . ':!**/sheet.json' ':!**/.env*'`; không đọc/in `.env*`, khoá, token, mật khẩu.
- **Tệp của phiên khác đang sửa dở — KHÔNG đụng:** `apps/admin-web/src/lib/navigation/admin-menu.tsx`, `apps/admin-web/src/features/master-data/screens/ReasonConfigRegistryPage.parts.tsx`,
  `apps/admin-web/src/features/packaging-printing/screens/TradeItemsPage.components.tsx`, `apps/admin-web/src/features/warehouse-inventory/InventoryAllocationsPage.tsx`, `db/**`,
  `deploy/seed/**`, `tests/backend/**`, `tests/frontend/admin-web/static-guards/navigation/**`, `tests/frontend/admin-web/component/src-features/**`. Thấy tệp dirty lạ khác ⇒ để nguyên, báo.
- Chỉ sửa tệp trong phạm vi brief của mình (coder khác đang sửa phần khác cùng lúc). Cần chạm tệp ngoài phạm vi ⇒ dừng, báo.
- Trước khi sửa/đổi tên symbol dùng chung: xem chỗ dùng (GitNexus `impact` nếu có; không `gitnexus analyze`; không có thì `grep -rn`).
- Chữ hiển thị cho người dùng: **tiếng Việt có dấu, dễ hiểu cho công nhân**, không mã thô/tiếng Anh/thuật ngữ kỹ thuật (guard `vietnamese-ui-text-static`).
  Nội dung từng màn (tiêu đề, mô tả, cách làm, menu, nhóm, vai) theo `C:\Projects\Project Control\modules\m12\wp\M12-WP24-noi-dung.md` khi tệp đó đã có.
- Thiết kế: dùng token ngữ nghĩa (không hex/px cứng), component của `packages/ui` khi đã có; trần **800 dòng/tệp** (governance + `file-size-budget-static`).
- Guard tĩnh của PWA (`tests/frontend/shopfloor-pwa/static-guards/**`) và admin ghim nhiều chi tiết giao diện: đổi giao diện thì sửa guard **cùng lúc**, giữ ý định của guard
  (ranh giới API mobile, không lộ token, không `localStorage.setItem` trừ chỗ đã cho phép, bundle shell nhẹ), ghi rõ guard nào đổi + vì sao.
- Build/test: .NET (nếu có) `--artifacts-path .artifacts/dotnet/<tên-WP> --disable-build-servers`, không `dotnet build-server shutdown`; Next/Vitest: `NEXT_DIST_DIR` riêng
  (`.next-<tên-WP>`) nếu build; KHÔNG dùng cổng 5100/3000; không chạy dev server lâu, tắt mọi tiến trình mình bật. Không ssh, không gọi máy chủ.
- Kiểm nhanh tầng 1 (chỉ phần của mình): typecheck app bị đổi, vitest các tệp test liên quan + static-guards của app bị đổi, eslint tệp đổi. KHÔNG chạy `pnpm run check`/bộ đủ.
- Đầu ra ≤ 30 dòng: ĐẠT tự kiểm / CHƯA ĐẠT; danh sách tệp đổi/thêm (đường dẫn đủ, để phiên chính commit theo đường dẫn); guard đã đổi + lý do; lệnh kiểm + số; việc chưa làm + lý do.
