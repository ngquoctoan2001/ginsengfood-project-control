"""Kiểm kê và dọn C:\\Projects\\_wt (D-lead-063: không còn worktree/bản sao).

Mặc định CHỈ ĐỌC: in bảng giữ/xoá. Thêm --xoa để xoá những mục an toàn.

Xoá khi (và nếu mục có thay đổi chưa commit mà nội dung chưa nằm trong lịch sử repo thì LƯU BẢN VÁ trước vào
C:\\Projects\\_wt\\_luu\\<mã>\\<mục>__<sha7>.patch, bản vá nhỏ so với cả cây):
  - worktree đã đăng ký: không bị khoá, HEAD nằm trong nhánh/tag khác, hoặc mọi tệp ở HEAD đã có trong lịch sử repo;
  - bản sao archive (repo tạm có commit "goc");
  - clone: mọi tệp ở HEAD đã có trong lịch sử repo.
Luôn GIỮ: tệp lẻ (patch, log), thư mục bắt đầu bằng "_" (công cụ, log, _luu), mục sửa trong 24 giờ qua (có thể đang dùng),
mục không rõ, mục có commit chưa nằm đâu. Không bao giờ xoá nhánh. Không đụng worktree nằm ngoài C:\\Projects\\_wt.
"""
import argparse
import json
import os
import shutil
import stat
import subprocess
import sys
import time
from pathlib import Path

sys.stdout.reconfigure(encoding="utf-8")
WT = Path(r"C:\Projects\_wt")
LUU = WT / "_luu"
REPOS = [
    r"C:\Projects\ginsengfood-business-platform",
    r"C:\Projects\ginsengfood-ops-core",
    r"C:\Projects\ginsengfood-ivr",
    r"C:\Projects\ginsengfood-golden-hour-video",
    r"C:\Projects\module5",
    r"C:\Projects\ginsengfood-contracts",
    r"C:\Projects\deploy",
    r"C:\Projects\Project Control",
    r"C:\Projects\M4-PLAN",
]
RECENT_SEC = 24 * 3600
MAX_PATCH = 100 * 1024 * 1024


def run(args, cwd=None, timeout=120):
    r = subprocess.run(args, cwd=cwd, capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=timeout)
    return r.returncode, r.stdout.strip(), r.stderr.strip()


def norm(p) -> str:
    return str(p).replace("\\", "/").rstrip("/").lower()


def registered() -> dict:
    """đường dẫn chuẩn hoá -> {repo, head, branch, locked}"""
    out = {}
    for repo in REPOS:
        if not (Path(repo) / ".git").exists():
            continue
        code, txt, _ = run(["git", "-C", repo, "worktree", "list", "--porcelain"])
        if code != 0:
            continue
        cur = None
        for line in txt.splitlines() + [""]:
            if line.startswith("worktree "):
                cur = {"repo": repo, "path": line[9:].strip(), "head": "", "branch": None, "locked": False}
            elif cur is None:
                continue
            elif line.startswith("HEAD "):
                cur["head"] = line[5:].strip()
            elif line.startswith("branch "):
                cur["branch"] = line[7:].strip()
            elif line.startswith("locked"):
                cur["locked"] = True
            elif line == "":
                if cur and norm(cur["path"]) != norm(cur["repo"]):
                    out[norm(cur["path"])] = cur
                cur = None
    return out


def newest_mtime(item: Path, info: dict | None) -> float:
    t = item.stat().st_mtime
    g = item / ".git"
    if g.exists():
        t = max(t, g.stat().st_mtime)
    if info:
        d = Path(info["repo"]) / ".git" / "worktrees" / Path(info["path"]).name
        for f in ("index", "HEAD", "logs/HEAD"):
            if (d / f).exists():
                t = max(t, (d / f).stat().st_mtime)
    elif (item / ".git").is_dir():
        for f in ("index", "HEAD"):
            if (item / ".git" / f).exists():
                t = max(t, (item / ".git" / f).stat().st_mtime)
    return t


def dirty_lines(path: Path) -> list:
    code, txt, _ = run(["git", "--no-optional-locks", "-C", str(path), "status", "--porcelain", "-uall"], timeout=300)
    if code != 0:
        return ["<status lỗi>"]
    return [l for l in txt.splitlines() if l.strip()]


_BLOBS = None


def blobs() -> set:
    """Mọi đối tượng (blob/tree/commit) với nhánh, tag, remote của mọi repo: nội dung nào đã từng được commit."""
    global _BLOBS
    if _BLOBS is None:
        s = set()
        for repo in REPOS:
            if not (Path(repo) / ".git").exists():
                continue
            p = subprocess.Popen(["git", "-C", repo, "rev-list", "--all", "--objects"], stdout=subprocess.PIPE, text=True, encoding="utf-8", errors="replace")
            for line in p.stdout:
                s.add(line[:40])
            p.wait()
        _BLOBS = s
    return _BLOBS


def noi_dung_da_commit(path: Path, lines: list) -> bool:
    """Mọi tệp đang sửa/mới có nội dung trùng một blob đã nằm trong lịch sử repo (đã được gộp ở đâu đó)."""
    if len(lines) > 400:
        return False
    b = blobs()
    for l in lines:
        code, rest = l[:2], l[3:]
        if "D" in code:
            return False
        if " -> " in rest:
            rest = rest.split(" -> ", 1)[1]
        rest = rest.strip().strip('"')
        f = path / rest
        if not f.is_file():
            return False
        rc, h, _ = run(["git", "-C", str(path), "hash-object", "--", rest])
        if rc != 0 or h not in b:
            return False
    return True


def cay_da_commit(path: Path) -> bool:
    """Mọi tệp ở HEAD của `path` có nội dung đã nằm trong lịch sử repo."""
    rc, txt, _ = run(["git", "-C", str(path), "ls-tree", "-r", "HEAD"], timeout=300)
    if rc != 0:
        return False
    b = blobs()
    for l in txt.splitlines():
        meta = l.split("\t", 1)[0].split()
        if len(meta) >= 3 and meta[1] == "blob" and meta[2] not in b:
            return False
    return True


def classify(item: Path, reg: dict) -> tuple:
    """-> (hanh_dong 'xoa'|'giu', loai, ly_do, luu_ban_va)"""
    if not item.is_dir():
        return "giu", "tep", "tệp lẻ (patch/log/script)", False
    if item.name.startswith("_"):
        return "giu", "cong-cu", "thư mục công cụ/log", False
    info = reg.get(norm(item))
    age = time.time() - newest_mtime(item, info)
    if age < RECENT_SEC:
        return "giu", "gan-day", f"sửa {age / 3600:.1f} giờ trước, có thể đang dùng", False
    if info:
        if info["locked"]:
            return "giu", "worktree", "bị khoá", False
        d = dirty_lines(item)
        luu = bool(d) and not noi_dung_da_commit(item, d)
        own = info["branch"] or ""
        args = ["git", "-C", info["repo"], "rev-list", "--count", info["head"], "--not"]
        if own.startswith("refs/heads/"):
            args += [f"--exclude={own}"]
        args += ["--branches", "--remotes", "--tags"]
        code, txt, _ = run(args)
        if code != 0 or txt != "0":
            if not cay_da_commit(item):
                return "giu", "worktree", f"{txt or '?'} commit chưa nằm trong nhánh/tag nào khác", False
        ly = "commit đã nằm trong nhánh khác" if code == 0 and txt == "0" else "mọi tệp ở HEAD đã nằm trong lịch sử repo"
        return "xoa", "worktree", f"{ly}; {len(d)} tệp dở" + (" (lưu bản vá)" if luu else " đã nằm trong lịch sử") if d else f"sạch, {ly}", luu
    g = item / ".git"
    if g.is_dir():
        d = dirty_lines(item)
        luu = bool(d) and not noi_dung_da_commit(item, d)
        _, author, _ = run(["git", "-C", str(item), "log", "-1", "--format=%an"])
        if author == "goc":
            return "xoa", "ban-sao", (f"bản sao archive, {len(d)} tệp dở" + (" (lưu bản vá)" if luu else " đã nằm trong lịch sử")) if d else "bản sao archive không đổi", luu
        if cay_da_commit(item):
            return "xoa", "clone", f"mọi tệp ở HEAD của clone đã nằm trong lịch sử repo; {len(d)} tệp dở", luu
        return "giu", "clone", "clone có tệp ở HEAD chưa nằm trong lịch sử repo", False
    if g.is_file():
        return "giu", "worktree-mat", ".git trỏ tới worktree không còn đăng ký, xem tay", False
    return "giu", "khong-ro", "không phải worktree/bản sao, xem tay", False


def luu_ban_va(item: Path, top: str, muc: str) -> str | None:
    """Lưu thay đổi chưa commit (cả tệp mới) thành một bản vá nhỏ. Trả đường dẫn, hoặc None nếu không lưu được."""
    _, head, _ = run(["git", "-C", str(item), "rev-parse", "--short=7", "HEAD"])
    dest_dir = LUU / top
    dest_dir.mkdir(parents=True, exist_ok=True)
    dest = dest_dir / f"{muc}__{head or 'nohead'}.patch"
    run(["git", "-C", str(item), "add", "-N", "--", "."], timeout=300)
    with open(dest, "wb") as f:
        r = subprocess.run(["git", "-C", str(item), "diff", "--binary", "HEAD"], stdout=f, stderr=subprocess.DEVNULL, timeout=600)
    if r.returncode not in (0, 1) or not dest.exists() or dest.stat().st_size == 0 or dest.stat().st_size > MAX_PATCH:
        if dest.exists():
            dest.unlink()
        return None
    return str(dest)


def xoa_thu_muc(item: Path) -> str:
    def onerr(func, p, _exc):
        try:
            os.chmod(p, stat.S_IWRITE)
            func(p)
        except OSError:
            pass
    shutil.rmtree("\\\\?\\" + str(item), onerror=onerr)
    return "ok" if not item.exists() else "còn sót"


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--xoa", action="store_true", help="xoá các mục 'xoa' (mặc định chỉ liệt kê)")
    ap.add_argument("--json", default="", help="ghi kết quả kiểm kê ra tệp JSON")
    ap.add_argument("--chi", default="", help="chỉ xét thư mục con này của _wt (vd m34)")
    a = ap.parse_args()
    reg = registered()
    rows = []
    for top in sorted(p for p in WT.iterdir() if p.is_dir() and not p.name.startswith("_")):
        if a.chi and top.name != a.chi:
            continue
        for item in sorted(top.iterdir()):
            hd, loai, ly, luu = classify(item, reg)
            rows.append({"top": top.name, "muc": item.name, "hanh_dong": hd, "loai": loai, "ly_do": ly, "luu": luu})
    tong = {}
    for r in rows:
        k = (r["top"], r["hanh_dong"] + ("+bản vá" if r["luu"] else ""))
        tong[k] = tong.get(k, 0) + 1
    print(f"== {len(rows)} mục dưới {WT}")
    for (top, hd), n in sorted(tong.items()):
        print(f"  {top}: {hd} {n}")
    gl = {}
    for r in rows:
        if r["hanh_dong"] == "giu":
            gl.setdefault(r["loai"], []).append(f'{r["top"]}/{r["muc"]} ({r["ly_do"][:50]})')
    print("== GIỮ")
    for loai, ds in sorted(gl.items(), key=lambda x: -len(x[1])):
        print(f"  [{loai}] {len(ds)}" + (" · " + "; ".join(ds[:6]) if loai not in ("tep", "khong-ro") and len(ds) <= 20 else ""))
    ngoai = [v for k, v in reg.items() if not k.startswith(norm(WT))]
    print(f"== worktree đăng ký ngoài _wt (không đụng): {len(ngoai)}")
    for v in ngoai[:10]:
        print("  ", v["path"])
    if a.json:
        Path(a.json).write_text(json.dumps(rows, ensure_ascii=False, indent=1), encoding="utf-8")
    if not a.xoa:
        print("== CHỈ ĐỌC. Thêm --xoa để xoá các mục 'xoa'.")
        return 0
    todo = [r for r in rows if r["hanh_dong"] == "xoa"]
    LUU.mkdir(parents=True, exist_ok=True)
    log = LUU / "nhat-ky-don.jsonl"
    print(f"== XOÁ {len(todo)} mục", flush=True)
    ok = 0
    for i, r in enumerate(todo, 1):
        item = WT / r["top"] / r["muc"]
        info = reg.get(norm(item))
        t0 = time.time()
        patch = None
        if r["luu"]:
            patch = luu_ban_va(item, r["top"], r["muc"])
            if patch is None:
                kq = "BỎ QUA: không lưu được bản vá (rỗng/quá lớn)"
                print(f"  [{i}/{len(todo)}] {r['top']}/{r['muc']} → {kq}", flush=True)
                continue
        if info:
            code, _, err = run(["git", "-C", info["repo"], "worktree", "remove", "--force", str(item)], timeout=1800)
            kq = "ok" if code == 0 and not item.exists() else (xoa_thu_muc(item) if item.exists() else f"lỗi {err[:80]}")
        else:
            kq = xoa_thu_muc(item)
        ok += kq == "ok"
        with open(log, "a", encoding="utf-8") as f:
            f.write(json.dumps({"gio": time.strftime("%d/%m %H:%M:%S"), "top": r["top"], "muc": r["muc"], "loai": r["loai"], "ban_va": patch, "kq": kq}, ensure_ascii=False) + "\n")
        print(f"  [{i}/{len(todo)}] {r['top']}/{r['muc']} → {kq}{' + bản vá' if patch else ''} ({time.time() - t0:.0f}s)", flush=True)
    for repo in REPOS:
        if (Path(repo) / ".git").exists():
            run(["git", "-C", repo, "worktree", "prune"])
    print(f"== xong: {ok}/{len(todo)} xoá được")
    return 0


if __name__ == "__main__":
    sys.exit(main())
