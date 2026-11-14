"""Tổng quan git mọi repo của Project Control trong vài giây, không tốn agent.

Chỉ đọc. Riêng --fetch cập nhật nhánh remote (refs/remotes), không đụng nhánh local hay tệp đang làm.

Mốc so sánh là SHA đã lưu lần trước (không đoán giờ): modules/<luồng>/git_moc.json, phiên lead dùng modules/lead/git_moc.json.

Dùng (gọi bằng đường dẫn tuyệt đối nếu không đứng ở thư mục Project Control):
  python tools/git_tong_quan.py --fetch m34          # đầu phiên: commit mới từ mốc đã lưu của luồng m34
  python tools/git_tong_quan.py --fetch               # phiên lead: mọi repo
  python tools/git_tong_quan.py m34 --luu             # cuối bảng đầu phiên / cuối phiên: lưu SHA hiện tại làm mốc mới
  python tools/git_tong_quan.py --tu "2026-10-31 10:00"   # thay mốc bằng giờ (theo ngày commit, có thể sót commit gộp muộn)
"""
import argparse
import json
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime
from pathlib import Path

GOC = Path(r"C:\Projects")
PC = Path(__file__).resolve().parents[1]
# (luồng, thư mục, nhánh remote theo dõi chi tiết)
REPO = [
    ("m12", "ginsengfood-ops-core", ["origin/main", "gitlab/main"]),
    ("m34", "ginsengfood-business-platform", ["origin/dev", "origin/dev015", "origin/PhucApu", "origin/master"]),
    ("m34", "M4-PLAN", ["origin/main"]),
    ("m5", "module5", ["origin/main"]),
    ("m5", "M4-PLAN", ["origin/main"]),
    ("m6", "module5", ["origin/main"]),  # M6 ở module5/m6/ từ 10/11 (D-m5-025); module6 lưu trữ
    ("m7", "ginsengfood-golden-hour-video", ["origin/main"]),
    ("m8", "ginsengfood-ivr", ["origin/main"]),
    ("chung", "ginsengfood-contracts", ["origin/main"]),
    ("chung", "deploy", []),
]
LUONG = {"m12", "m34", "m5", "m6", "m7", "m8", "chung", "lead"}
FMT = ["--format=%h %cd %an · %s", "--date=format:%d/%m %H:%M"]


def git(repo, *args, timeout=60):
    try:
        r = subprocess.run(["git", "--no-optional-locks", "-C", str(repo), *args], capture_output=True,
                           text=True, encoding="utf-8", errors="replace", timeout=timeout)
    except subprocess.TimeoutExpired:
        return None
    return r.stdout.strip() if r.returncode == 0 else None


def fetch(repo):
    return None if git(repo, "fetch", "--all", "--prune", "--quiet", timeout=120) is not None else f"{repo.name}: fetch lỗi"


def remote_refs(repo):
    out = git(repo, "for-each-ref", "--format=%(refname:short) %(objectname)", "refs/remotes") or ""
    return {l.split()[0]: l.split()[1] for l in out.splitlines() if "/" in l.split()[0]}


def nhanh(repo, ref, cu, tu):
    dong = git(repo, "log", "-1", "--format=%h %cd", "--date=format:%d/%m %H:%M", ref)
    if dong is None:
        return [f"   {ref:<16} (không có)"]
    if tu:
        so = git(repo, "rev-list", "--count", f"--since={tu}", ref) or "0"
        log = git(repo, "log", f"--since={tu}", "-n", "6", *FMT, ref) or ""
        dau = f"   {ref:<16} {dong} · {so} commit từ {tu}"
    elif cu:
        if git(repo, "cat-file", "-e", cu) is None:
            return [f"   {ref:<16} {dong} · mốc {cu[:9]} không còn (bị ghi đè lịch sử?)"]
        so = git(repo, "rev-list", "--count", f"{cu}..{ref}") or "0"
        if so == "0":
            return [f"   {ref:<16} {dong} · không đổi từ mốc"]
        log = git(repo, "log", "-n", "6", *FMT, f"{cu}..{ref}") or ""
        dau = f"   {ref:<16} {dong} · {so} commit mới từ mốc {cu[:9]}"
    else:
        log = git(repo, "log", "-n", "3", *FMT, ref) or ""
        dau = f"   {ref:<16} {dong} · (chưa có mốc, 3 commit gần nhất)"
    return [dau] + [f"      {l[:110]}" for l in log.splitlines()]


def mot_repo(luong, ten, refs, moc, tu):
    repo = GOC / ten
    if git(repo, "rev-parse", "--git-dir") is None:
        return f"== {luong} {ten}: không phải repo git hoặc không mở được", {}
    cur = git(repo, "branch", "--show-current") or "(tách rời)"
    head = git(repo, "rev-parse", "--short", "HEAD") or "?"
    st = (git(repo, "status", "--porcelain=v1") or "").splitlines()
    chua_theo_doi = sum(1 for l in st if l.startswith("??"))
    xung_dot = sum(1 for l in st if l[:2] in ("UU", "AA", "DD", "AU", "UA", "DU", "UD"))
    dang_merge = git(repo, "rev-parse", "-q", "--verify", "MERGE_HEAD") is not None
    ab = git(repo, "rev-list", "--left-right", "--count", "HEAD...@{u}")
    wt = len((git(repo, "worktree", "list", "--porcelain") or "").split("\n\n")) - 1

    tt = [f"nhánh {cur} @ {head}", f"bẩn {len(st) - chua_theo_doi} tệp + {chua_theo_doi} chưa theo dõi"]
    if ab:
        hon, kem = ab.split()
        tt.append(f"so remote +{hon}/-{kem}")
    if dang_merge or xung_dot:
        tt.append(f"ĐANG MERGE DỞ ({xung_dot} xung đột)")
    if wt:
        tt.append(f"{wt} worktree phụ")
    out = [f"== {luong} · {ten} · " + " · ".join(tt)]

    hien = remote_refs(repo)
    cu_repo = moc.get(ten, {})
    for ref in refs:
        out += nhanh(repo, ref, cu_repo.get(ref), tu)
    if cu_repo and not tu:
        khac = [r for r, s in hien.items() if r not in refs and cu_repo.get(r) != s]
        mat = [r for r in cu_repo if r not in hien]
        if khac:
            out.append(f"   nhánh remote khác mới/đổi ({len(khac)}): " + ", ".join(sorted(khac)[:8]))
        if mat:
            out.append(f"   nhánh remote đã xoá ({len(mat)}): " + ", ".join(sorted(mat)[:8]))
    return "\n".join(out), hien


def main():
    sys.stdout.reconfigure(encoding="utf-8")
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("luong", nargs="*", help="m12 m34 m5 m6 m7 m8 chung lead (trống hoặc lead = tất cả)")
    p.add_argument("--fetch", action="store_true", help="git fetch --all --prune trước (song song)")
    p.add_argument("--luu", action="store_true", help="lưu SHA hiện tại làm mốc mới")
    p.add_argument("--tu", help='so theo giờ thay vì mốc SHA, dạng "yyyy-mm-dd hh:mm"')
    a = p.parse_args()

    la = [l for l in a.luong if l not in LUONG]
    if la:
        p.error(f"luồng không có: {', '.join(la)} (có: {' '.join(sorted(LUONG))})")
    tat_ca = not a.luong or "lead" in a.luong
    chon = [r for r in REPO if tat_ca or r[0] in a.luong]
    chon = [r for i, r in enumerate(chon) if r[1] not in [x[1] for x in chon[:i]]]  # một repo một lần
    tep_moc = PC / "modules" / ("lead" if tat_ca or len(a.luong) > 1 else a.luong[0]) / "git_moc.json"
    try:
        moc = json.loads(tep_moc.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        moc = {}
    if not a.tu:
        print(f"Mốc: {moc.get('_luc', 'chưa có')} ({tep_moc.relative_to(PC)})")

    with ThreadPoolExecutor(max_workers=6) as ex:
        if a.fetch:
            for loi in ex.map(fetch, [GOC / r[1] for r in chon]):
                if loi:
                    print(loi)
        kq = list(ex.map(lambda r: mot_repo(*r, moc, a.tu), chon))
    for khoi, _ in kq:
        print(khoi)

    if a.luu:
        moi = dict(moc)
        moi["_luc"] = datetime.now().strftime("%Y-%m-%d %H:%M")
        for (_, ten, _), (_, hien) in zip(chon, kq):
            if hien:
                moi[ten] = hien
        tep_moc.write_text(json.dumps(moi, ensure_ascii=False, indent=1), encoding="utf-8")
        print(f"Đã lưu mốc {moi['_luc']} vào {tep_moc.relative_to(PC)}")


if __name__ == "__main__":
    main()
