<#
don_may.ps1 - tim va dung tien trinh chay ngam ton CPU/RAM bi bo quen (D-lead-031).
Mac dinh chi bao. -Dung: dung nhom MO_COI, RANH_LAU va container test RANH_LAU.

Chi xet tien trinh cua du an: dong lenh / duong chay co C:\Projects, Temp\claude, .claude\shell-snapshots, ms-playwright,
hoac ten testhost / MSBuild / VBCSCompiler. Khong dung Chrome that, VS Code, Docker Desktop, app Claude,
MCP server cua phien (tien trinh khong qua shell cua cong cu), tien trinh nguoi dung tu bat trong terminal cua minh.

Nhom:
  MO_COI    cha da chet (phien tao ra no khong con), tuoi >= PhutMoCoi, ranh trong mau       -> dung ca cay
  RANH_LAU  thuoc phien con song, loai nang, bat qua shell cong cu, tuoi >= PhutRanh, ranh trong mau,
            phien chu khong nhac cong / duong dan worktree / PID cua no trong PhutNhac phut      -> dung ca cay, bao phien chu
  DANG_CHAY dung CPU trong mau                                                                   -> giu
  GIU       con lai (moi, phien chu vua nhac toi, khong ro phien)                                -> giu
Container (chi khi CPU < 1 %, khong ket noi nao toi cong cua no, chay >= PhutRanh):
  MO_COI    nhan testcontainers ma khong con ryuk cua phien do (bo test tao ra no da chet)
  RANH_LAU  ten ngau nhien, anh postgres|redis|mssql|mysql|mongo|rabbitmq
  giu ginsengfood-postgres-local, ryuk, moi container runner/registry. Dung = docker stop (khong xoa).

Moi nhom: cay co ket noi TCP Established (vd. dotnet test <-> testhost, client DB) -> GIU 'con ket noi mang'.

Che do lich (-Ghi <log>, task \Ginsengfood\DonMay moi 30 phut): ghi gon vao log, luu trang thai "<log>.state.json";
chi dung khi lan chay TRUOC cung da thay dung cay do (cung PID + gio tao, cung danh sach PID con), CPU ca cay tang
<= 0.002 x giay troi + 0.5 (dung yen hai luot lien), container cung phai la ung vien o lan truoc.

Vi du:
  pwsh -File "C:\Projects\Project Control\tools\don_may.ps1"          # chi bao
  pwsh -File "C:\Projects\Project Control\tools\don_may.ps1" -Dung    # dung nhom MO_COI + RANH_LAU
  pwsh -File "C:\Projects\Project Control\tools\don_may.ps1" -Dung -Ghi "$env:LOCALAPPDATA\don_may\don_may.log"   # nhu lich
#>
param(
  [switch]$Dung,
  [switch]$Het,
  [string]$Ghi = '',
  [int]$PhutMoCoi = 20,
  [int]$PhutRanh = 120,
  [int]$PhutNhac = 60,
  [int]$MauGiay = 15,
  [double]$NguongCpu = 0.5
)
if ($Ghi) {
  $dirGhi = Split-Path -Parent $Ghi
  if ($dirGhi -and -not (Test-Path $dirGhi)) { New-Item -ItemType Directory -Force -Path $dirGhi | Out-Null }
  trap { Add-Content -Path $Ghi -Encoding utf8 -Value "$((Get-Date).ToString('dd/MM HH:mm')) don_may LOI: $($_.Exception.Message)"; break }
}
$now = Get-Date
$all = @(Get-CimInstance Win32_Process)
$byId = @{}; foreach ($p in $all) { $byId[[int]$p.ProcessId] = $p }
$kids = @{}
foreach ($p in $all) {
  $pp = [int]$p.ParentProcessId
  if ($pp -eq [int]$p.ProcessId) { continue }
  if (-not $kids.ContainsKey($pp)) { $kids[$pp] = [System.Collections.Generic.List[int]]::new() }
  $kids[$pp].Add([int]$p.ProcessId)
}

$NANG = '^(dotnet|node|testhost|testhost\.x86|MSBuild|VBCSCompiler|python|python3|pythonw|py|java|chrome|chrome-headless-shell|esbuild|uvicorn)\.exe$'
$PHU = '^(pwsh|powershell|bash|sh|tail|grep|git|git-remote-https|git-credential-manager|timeout|sleep)\.exe$'
$SHELL = '^(bash|sh|pwsh|powershell)\.exe$'
$DU_AN = '(?i)C:[\\/]+Projects|Temp[\\/]+claude[\\/]|\.claude[\\/]+shell-snapshots|ms-playwright|testhost|MSBuild\.(dll|exe)|VBCSCompiler|__claudeCodeScript|ginsengfood'
$GOC_NGOAI = '^(explorer|services|svchost|wininit|winlogon|Code|WindowsTerminal|OpenConsole|claude|Docker Desktop|devenv|rider64|idea64)\.exe$|^com\.docker\.'

function Redact([string]$s) {
  if (-not $s) { return '' }
  $s = $s -replace '\s+', ' '
  return ($s -replace '(?i)(token|password|passwd|secret|apikey|api_key|key)=\S+', '$1=***')
}
function Short([string]$s, [int]$n) { if ($s.Length -le $n) { return $s } else { return $s.Substring(0, $n) } }

# Phien Claude con song: CLI claude-code -> ma phien (de doc transcript)
$clis = @{}
foreach ($p in $all) {
  if ($p.Name -eq 'claude.exe' -and $p.CommandLine -match 'claude-code') {
    $clis[[int]$p.ProcessId] = if ($p.CommandLine -match '--(?:resume|session-id)[ =]"?([0-9a-f-]{36})') { $Matches[1] } else { '' }
  }
}

# Cay cua chinh lenh nay: khong bao gio dung
$mine = [System.Collections.Generic.HashSet[int]]::new()
$c = $byId[[int]$PID]
for ($i = 0; $c -and $i -lt 40; $i++) { [void]$mine.Add([int]$c.ProcessId); $c = $byId[[int]$c.ParentProcessId] }

function Owner($p) {
  $cur = $p; $shell = ($p.Name -match $SHELL)
  for ($i = 0; $i -lt 40; $i++) {
    $ppid = [int]$cur.ParentProcessId
    if ($clis.ContainsKey($ppid)) { return [pscustomobject]@{ Kind = 'CLI'; Cli = $ppid; Shell = $shell } }
    $par = $byId[$ppid]
    if (-not $par -or $par.CreationDate -gt $cur.CreationDate) { return [pscustomobject]@{ Kind = 'CHET'; Cli = $null; Shell = $shell } }
    if ($par.Name -match $GOC_NGOAI) { return [pscustomobject]@{ Kind = 'NGOAI'; Cli = $null; Shell = $shell } }
    if ($par.Name -match $SHELL) { $shell = $true }
    $cur = $par
  }
  return [pscustomobject]@{ Kind = 'NGOAI'; Cli = $null; Shell = $shell }
}
function TreeIds([int]$root) {
  $seen = [System.Collections.Generic.HashSet[int]]::new(); $stack = [System.Collections.Generic.Stack[int]]::new(); $stack.Push($root)
  while ($stack.Count) { $x = $stack.Pop(); if ($seen.Add($x) -and $kids.ContainsKey($x)) { foreach ($k in $kids[$x]) { $stack.Push($k) } } }
  return @($seen)
}
function IsCand($p) {
  if ($clis.ContainsKey([int]$p.ProcessId) -or $mine.Contains([int]$p.ProcessId)) { return $false }
  if ($p.CommandLine -match 'don_may(_lap)?\.ps1') { return $false }   # chinh cong cu va vong lap 30 phut
  if ($p.Name -notmatch $NANG -and $p.Name -notmatch $PHU) { return $false }
  if ($p.Name -match '^chrome' -and $p.ExecutablePath -notmatch 'ms-playwright') { return $false }
  return ((($p.CommandLine + ' ' + $p.ExecutablePath)) -match $DU_AN)
}

$cand = @($all | Where-Object { IsCand $_ })
$candIds = [System.Collections.Generic.HashSet[int]]::new(); foreach ($p in $cand) { [void]$candIds.Add([int]$p.ProcessId) }
# Don vi = ung vien tren cung (cha khong phai ung vien)
$units = @($cand | Where-Object { -not $candIds.Contains([int]$_.ParentProcessId) })

$cpu0 = @{}
foreach ($u in $units) { foreach ($id in (TreeIds ([int]$u.ProcessId))) { $g = Get-Process -Id $id -ErrorAction SilentlyContinue; if ($g) { $cpu0[$id] = [double]$g.CPU } } }
Start-Sleep -Seconds $MauGiay

$ports = @{}
Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue | ForEach-Object { $o = [int]$_.OwningProcess; if (-not $ports.ContainsKey($o)) { $ports[$o] = @() }; $ports[$o] += [int]$_.LocalPort }
$estPid = [System.Collections.Generic.HashSet[int]]::new(); $estPort = @{}
Get-NetTCPConnection -State Established -ErrorAction SilentlyContinue | ForEach-Object { [void]$estPid.Add([int]$_.OwningProcess); $estPort[[int]$_.RemotePort] = $true }

# Trang thai lan truoc (chi che do lich)
$stateFile = if ($Ghi) { "$Ghi.state.json" } else { '' }
$prev = @{}; $next = @{}
if ($stateFile -and (Test-Path $stateFile)) {
  try { $h = Get-Content -Raw -Path $stateFile | ConvertFrom-Json -AsHashtable; if ($h) { $prev = $h } } catch { $prev = @{} }
}

$textCache = @{}
function RecentText([string]$sid) {
  if ($textCache.ContainsKey($sid)) { return $textCache[$sid] }
  $root = Join-Path $HOME '.claude\projects'
  $files = @(Get-ChildItem -Path $root -Recurse -File -Filter '*.jsonl' -ErrorAction SilentlyContinue |
      Where-Object { $_.Name -eq "$sid.jsonl" -or $_.FullName -match [regex]::Escape("\$sid\subagents\") })
  if (-not $files.Count) { $textCache[$sid] = $null; return $null }
  $sb = [System.Text.StringBuilder]::new()
  foreach ($f in ($files | Where-Object { $_.LastWriteTime -ge $now.AddMinutes(-$PhutNhac) })) {
    try {
      $fs = [System.IO.File]::Open($f.FullName, 'Open', 'Read', 'ReadWrite')
      $len = [Math]::Min($fs.Length, 400KB); [void]$fs.Seek(-$len, 'End')
      $buf = New-Object byte[] $len; [void]$fs.Read($buf, 0, $len); $fs.Close()
      [void]$sb.Append([System.Text.Encoding]::UTF8.GetString($buf))
    } catch { }
  }
  $textCache[$sid] = $sb.ToString(); return $textCache[$sid]
}

$rows = foreach ($u in $units) {
  $tree = TreeIds ([int]$u.ProcessId)
  $cpu = 0.0; $tot = 0.0; $ram = 0.0; $alive = 0; $tp = @(); $live = @()
  foreach ($id in $tree) {
    $g = Get-Process -Id $id -ErrorAction SilentlyContinue
    if ($g) { $alive++; $live += $id; $ram += $g.WorkingSet64 / 1MB; $tot += [double]$g.CPU; if ($cpu0.ContainsKey($id)) { $cpu += ([double]$g.CPU - $cpu0[$id]) } }
    if ($ports.ContainsKey($id)) { $tp += $ports[$id] }
  }
  if (-not $alive) { continue }
  $hasEst = @($live | Where-Object { $estPid.Contains($_) }).Count -gt 0
  $key = "$($u.ProcessId)|$($u.CreationDate.Ticks)"
  $sig = (@($live | Sort-Object) -join ',')
  $age = [int]($now - $u.CreationDate).TotalMinutes
  $o = Owner $u
  $cmd = Redact $u.CommandLine
  $heavyTree = @($tree | Where-Object { $byId[$_] -and $byId[$_].Name -match $NANG }).Count -gt 0
  $nhom = 'GIU'; $ly = ''
  if ($cpu -ge $NguongCpu) { $nhom = 'DANG_CHAY' }
  elseif ($hasEst) { $ly = 'con ket noi mang' }
  elseif ($o.Kind -eq 'CHET') {
    if ($age -ge $PhutMoCoi) { $nhom = 'MO_COI'; $ly = 'cha da chet' } else { $ly = 'mo coi moi' }
  }
  elseif ($o.Kind -eq 'CLI') {
    if (-not $o.Shell) { $ly = 'khong qua shell (MCP/LSP)' }
    elseif (-not $heavyTree) { $ly = 'tac vu nen cua phien' }
    elseif ($age -lt $PhutRanh) { $ly = 'chua du lau' }
    else {
      $sid = $clis[$o.Cli]
      $txt = if ($sid) { RecentText $sid } else { $null }
      if ($null -eq $txt) { $ly = 'khong ro phien' }
      else {
        $needles = @()
        foreach ($pt in ($tp | Sort-Object -Unique)) { $needles += "(?<!\d)$pt(?!\d)" }
        if ($cmd -match '_wt[\\/]+[^\\/]+[\\/]+([^\\/\s"'']+)') { $needles += [regex]::Escape($Matches[1]) }
        $needles += "(?<!\d)$($u.ProcessId)(?!\d)"
        $hit = @($needles | Where-Object { $txt -match $_ })
        if ($hit.Count) { $ly = 'phien chu vua nhac' } else { $nhom = 'RANH_LAU'; $ly = "phien $(Short $sid 8) khong nhac $PhutNhac phut" }
      }
    }
  }
  else { $ly = 'ngoai phien' }
  if ($Ghi) {
    $next[$key] = @{ cpu = $tot; sig = $sig; t = $now.ToString('o') }
    if ($nhom -in 'MO_COI', 'RANH_LAU') {
      $pv = $prev[$key]
      if (-not $pv) { $nhom = 'GIU'; $ly = "cho lan sau ($ly)" }
      else {
        $el = 0.0; try { $el = ($now - [datetime]::Parse([string]$pv.t)).TotalSeconds } catch { }
        if ($el -le 0 -or [string]$pv.sig -ne $sig -or ($tot - [double]$pv.cpu) -gt (0.002 * $el + 0.5)) { $nhom = 'GIU'; $ly = "co lam viec tu lan truoc ($ly)" }
      }
    }
  }
  [pscustomobject]@{
    Nhom = $nhom; PID = [int]$u.ProcessId; Ten = $u.Name; Tuoi = $age; CPU = [math]::Round($cpu, 2); RAM_MB = [int]$ram
    SoTT = $alive; Cong = (($tp | Sort-Object -Unique) -join ','); Chu = $(if ($o.Cli) { "$($o.Cli)/$(Short $clis[$o.Cli] 8)" } else { $o.Kind })
    LyDo = $ly; Lenh = (Short $cmd 110); Cay = $tree
  }
}

# Container: testcontainers khong con ryuk cua phien = bo test tao ra no da chet (MO_COI)
$crow = @()
if (Get-Command docker -ErrorAction SilentlyContinue) {
  $st = @{}
  docker stats --no-stream --format '{{.ID}}|{{.CPUPerc}}|{{.MemUsage}}' 2>$null | ForEach-Object { $a = $_ -split '\|'; if ($a.Count -ge 3) { $st[$a[0]] = $a } }
  $info = @()
  foreach ($cid in @(docker ps -q 2>$null)) {
    $f = docker inspect -f '{{.Name}}|{{.Config.Image}}|{{index .Config.Labels "org.testcontainers"}}|{{index .Config.Labels "org.testcontainers.session-id"}}|{{.State.StartedAt}}|{{range $p,$c := .NetworkSettings.Ports}}{{range $c}}{{.HostPort}},{{end}}{{end}}' $cid 2>$null
    $a = "$f" -split '\|'; if ($a.Count -lt 6) { continue }
    $info += [pscustomobject]@{ ID = $cid; Ten = $a[0].TrimStart('/'); Anh = $a[1]; Tc = $a[2]; Sess = $a[3]; Start = $a[4]; Cong = @($a[5] -split ',' | Where-Object { $_ }) }
  }
  $ryukSess = @($info | Where-Object { $_.Anh -match 'ryuk' } | ForEach-Object { if ($_.Sess) { $_.Sess } elseif ($_.Ten -match 'ryuk-([0-9a-f-]{36})') { $Matches[1] } })
  foreach ($c in $info) {
    $age = 0; try { $age = [int]($now - [datetime]::Parse($c.Start).ToLocalTime()).TotalMinutes } catch { }
    $cpu = 0.0; $mem = ''
    if ($st.ContainsKey($c.ID)) { $cpu = [double](($st[$c.ID][1]) -replace '[%\s]', ''); $mem = ($st[$c.ID][2] -split '/')[0].Trim() }
    $inUse = @($c.Cong | Where-Object { $estPort.ContainsKey([int]$_) }).Count -gt 0
    $test = $c.Anh -match '(?i)postgres|redis|mssql|mysql|mongo|rabbitmq'
    $nhom = 'GIU'; $ly = ''
    if ($c.Ten -eq 'ginsengfood-postgres-local' -or $c.Ten -match '(?i)runner|registry' -or $c.Anh -match '(?i)runner|registry|ryuk') { $ly = 'giu co dinh' }
    elseif ($cpu -ge 1) { $nhom = 'DANG_CHAY' }
    elseif ($inUse) { $ly = 'con ket noi' }
    elseif ($age -lt $PhutRanh) { $ly = 'chua du lau' }
    elseif ($c.Tc -eq 'true') {
      if ($ryukSess -contains $c.Sess) { $ly = 'ryuk cua phien con giu' } else { $nhom = 'MO_COI'; $ly = 'testcontainers khong con ryuk' }
    }
    elseif ($test -and $c.Ten -match '^[a-z]+_[a-z]+\d*$') { $nhom = 'RANH_LAU'; $ly = 'container test ranh' }
    else { $ly = 'co ten rieng' }
    if ($Ghi -and $nhom -in 'MO_COI', 'RANH_LAU') {
      $next["c:$($c.ID)"] = @{ t = $now.ToString('o') }
      if (-not $prev.ContainsKey("c:$($c.ID)")) { $nhom = 'GIU'; $ly = "cho lan sau ($ly)" }
    }
    $crow += [pscustomobject]@{ Nhom = $nhom; ID = $c.ID; Ten = $c.Ten; Anh = (Short ($c.Anh -replace '@sha256:.*$', '') 30); Tuoi = $age; CPU = $cpu; RAM = $mem; LyDo = $ly }
  }
}

$dungP = @($rows | Where-Object { $_.Nhom -in 'MO_COI', 'RANH_LAU' })
$dungC = @($crow | Where-Object { $_.Nhom -in 'MO_COI', 'RANH_LAU' })
$mb = [int](($dungP | Measure-Object RAM_MB -Sum).Sum)
if (-not $Ghi) {
  "== Tien trinh du an ($($now.ToString('dd/MM HH:mm')), mau CPU $MauGiay giay; CPU = giay CPU ca cay trong mau)"
  $an = @($rows | Where-Object { $_.Nhom -eq 'GIU' -and $_.RAM_MB -lt 100 }).Count
  $rows | Where-Object { $Het -or $_.Nhom -ne 'GIU' -or $_.RAM_MB -ge 100 } |
    Sort-Object @{ e = { @{ MO_COI = 0; RANH_LAU = 1; DANG_CHAY = 2; GIU = 3 }[$_.Nhom] } }, @{ e = 'RAM_MB'; Descending = $true } |
    Format-Table Nhom, PID, Ten, Tuoi, CPU, RAM_MB, SoTT, Cong, Chu, LyDo, Lenh -AutoSize | Out-String -Width 320
  if (-not $Het -and $an) { "($an tien trinh GIU duoi 100 MB an di; -Het de xem)" }
  "== Container"
  $crow | Sort-Object Nhom, Tuoi -Descending | Format-Table -AutoSize | Out-String -Width 220
  "== Se dung: $($dungP.Count) cay tien trinh (~$mb MB RAM), $($dungC.Count) container"
}

$log = [System.Collections.Generic.List[string]]::new()
if ($Dung) {
  foreach ($r in $dungP) {
    foreach ($id in ($r.Cay | Sort-Object -Descending)) {
      if ($mine.Contains($id) -or $clis.ContainsKey($id)) { continue }
      Stop-Process -Id $id -Force -ErrorAction SilentlyContinue
    }
    $con = @($r.Cay | Where-Object { Get-Process -Id $_ -ErrorAction SilentlyContinue })
    $log.Add("DUNG $($r.Nhom) $($r.PID) $($r.Ten) tuoi=$($r.Tuoi)p RAM=$($r.RAM_MB)MB cong=$($r.Cong) chu=$($r.Chu) | $(Short $r.Lenh 90) -> " + $(if ($con.Count) { "con song: $($con -join ',')" } else { 'da dung' }))
  }
  foreach ($cr in $dungC) {
    docker stop -t 10 $cr.ID 2>&1 | Out-Null
    $log.Add("DUNG container $($cr.Ten) ($($cr.Anh)) tuoi=$($cr.Tuoi)p -> " + $(if (docker ps -q --filter "id=$($cr.ID)") { 'con chay' } else { 'da dung (khong xoa)' }))
  }
}

if ($Ghi) {
  $cho = @($rows | Where-Object { $_.LyDo -like 'cho lan sau*' }).Count + @($crow | Where-Object { $_.LyDo -like 'cho lan sau*' }).Count
  $head = "$($now.ToString('dd/MM HH:mm')) don_may: $($dungP.Count) cay (~$mb MB), $($dungC.Count) container" +
    $(if (-not $Dung) { ' (chi bao)' } else { '' }) + $(if ($cho) { "; $cho muc cho lan sau" } else { '' })
  Add-Content -Path $Ghi -Encoding utf8 -Value (@($head) + @($log))
  $lines = @(Get-Content -Path $Ghi -Encoding utf8)
  if ($lines.Count -gt 5000) { $lines | Select-Object -Last 4000 | Set-Content -Path $Ghi -Encoding utf8 }
  $next | ConvertTo-Json -Depth 4 | Set-Content -Path $stateFile -Encoding utf8
} else { $log }
