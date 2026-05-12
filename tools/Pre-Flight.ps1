# =============================================================================
# Pre-Flight.ps1 - TY AI OS Session State Diagnostic
# =============================================================================
# Purpose: Read-only diagnostic reporting state of the two TY ecosystem git
#          repos (ty-ai-governance, TYOVA) plus SS321 ledger state.
#          Run at the start of every TY work session to establish ground truth
#          before making any changes.
#
# Built under: FIX-189 | 2026-04-19 | San Diego
#
# Design:
#   - Zero arguments (run as: .\Pre-Flight.ps1)
#   - Fetches origin on each git repo before reporting remote HEAD
#   - Reports detailed working-tree drift (each file listed)
#   - Reports stash entries and bad-state warnings
#   - SS321 handled as non-git folder: reports ledger file presence only
#   - Parses ledger state (Last FIX/CLO/Ch18/SS-FIX/Ch26) from files
#   - Report and Continue: warnings prominent, script exits clean
#   - Read-only: makes no commits, no writes, no pushes. git fetch only.
#
# Revision history:
#   v1 2026-04-19 09:25 - initial draft, failed first test
#   v2 2026-04-19 12:30 - 4 fixes: PS5.x syntax, rebase detection,
#                         SS321 handling, Ch26 regex
#   v3 2026-05-07 15:45 - FIX-396: two regex fixes:
#                         (1) MASTER_FIX_INDEX: now catches both ## FIX- and ### FIX-
#                         (2) Ch18: now catches both ### Entry- and Entry-NNN | inline format
# =============================================================================

# --- Config: canonical repo paths and ledger files ---
$GIT_REPOS = @(
    @{ Name = "ty-ai-governance"; Path = "E:\TY-Ecosystem\ty-ai-governance" },
    @{ Name = "TYOVA";            Path = "E:\TY-Ecosystem\TYOVA" }
)

$SS321_FOLDER     = "E:\TY-Ecosystem\ss321"
$MASTER_FIX_INDEX = "E:\TY-Ecosystem\ty-ai-governance\governance\ledger\MASTER_FIX_INDEX.md"
$CH18             = "E:\TY-Ecosystem\ty-ai-governance\book\TY_BOOK_CHAPTER_18_GOVERNANCE_MAINTENANCE_RECORD.md"
$CH26             = "E:\TY-Ecosystem\ty-ai-governance\book\TY_BOOK_CHAPTER_26_THE_TY_AI_OS_VOCABULARY.md"
$SS321_FIX_INDEX  = "E:\TY-Ecosystem\ss321\SS321_FIX_INDEX.md"

# --- Collector for overall summary ---
$actionItems = @()

# --- Header ---
$now = Get-Date -Format "yyyy-MM-dd HH:mm"
Write-Host ""
Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host "  TY AI OS - Pre-Flight Session State" -ForegroundColor Cyan
Write-Host "  $now San Diego (America/Los_Angeles)" -ForegroundColor Cyan
Write-Host "===========================================================" -ForegroundColor Cyan

# =============================================================================
# SECTION 1: Git repositories (ty-ai-governance, TYOVA)
# =============================================================================
foreach ($repo in $GIT_REPOS) {
    $name = $repo.Name
    $path = $repo.Path

    Write-Host ""
    Write-Host "[REPO] $name" -ForegroundColor Yellow
    Write-Host "  Path: $path"

    if (-not (Test-Path $path)) {
        Write-Host "  STATUS: PATH NOT FOUND" -ForegroundColor Red
        $actionItems += "$name : path does not exist"
        continue
    }

    if (-not (Test-Path (Join-Path $path ".git"))) {
        Write-Host "  STATUS: NOT A GIT REPOSITORY" -ForegroundColor Red
        $actionItems += "$name : not a git repository"
        continue
    }

    Push-Location $path
    try {
        # --- Bad-state detection (directory-based only, no stale file false positives) ---
        $gitDir = Join-Path $path ".git"
        if (Test-Path (Join-Path $gitDir "rebase-merge")) {
            Write-Host "  !! BAD STATE DETECTED: REBASE_IN_PROGRESS (interactive)" -ForegroundColor Red
            $actionItems += "$name : interactive rebase in progress"
        } elseif (Test-Path (Join-Path $gitDir "rebase-apply")) {
            Write-Host "  !! BAD STATE DETECTED: REBASE_IN_PROGRESS (apply)" -ForegroundColor Red
            $actionItems += "$name : rebase apply in progress"
        }
        if (Test-Path (Join-Path $gitDir "MERGE_HEAD")) {
            Write-Host "  !! BAD STATE DETECTED: MERGE_IN_PROGRESS" -ForegroundColor Red
            $actionItems += "$name : merge in progress"
        }
        if (Test-Path (Join-Path $gitDir "CHERRY_PICK_HEAD")) {
            Write-Host "  !! BAD STATE DETECTED: CHERRY_PICK_IN_PROGRESS" -ForegroundColor Red
            $actionItems += "$name : cherry-pick in progress"
        }
        if (Test-Path (Join-Path $gitDir "BISECT_LOG")) {
            Write-Host "  !! BAD STATE DETECTED: BISECT_IN_PROGRESS" -ForegroundColor Red
            $actionItems += "$name : bisect in progress"
        }

        # --- Branch ---
        $branch = (git symbolic-ref --short HEAD 2>$null)
        if (-not $branch) {
            $branch = "DETACHED_HEAD"
            Write-Host "  Branch: $branch" -ForegroundColor Red
            $actionItems += "$name : detached HEAD"
        } else {
            Write-Host "  Branch: $branch"
        }

        # --- git fetch ---
        Write-Host "  Fetching origin..." -NoNewline
        git fetch origin 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-Host " done" -ForegroundColor Green
        } else {
            Write-Host " FAILED (network?)" -ForegroundColor Yellow
        }

        # --- Local HEAD ---
        $localHash    = (git rev-parse HEAD)
        $localMessage = (git log -1 --pretty=format:"%s")
        Write-Host "  Local  HEAD: $localHash  $localMessage"

        # --- Remote HEAD ---
        $remoteRef  = "origin/$branch"
        $remoteHash = (git rev-parse $remoteRef 2>$null)
        if ($remoteHash) {
            $remoteMessage = (git log -1 --pretty=format:"%s" $remoteRef)
            Write-Host "  Remote HEAD: $remoteHash  $remoteMessage"

            # --- Delta ---
            $ahead  = [int](git rev-list --count "$remoteRef..HEAD" 2>$null)
            $behind = [int](git rev-list --count "HEAD..$remoteRef" 2>$null)
            if ($ahead -eq 0 -and $behind -eq 0) {
                Write-Host "  Delta: same" -ForegroundColor Green
            } elseif ($ahead -gt 0 -and $behind -eq 0) {
                Write-Host "  Delta: ahead $ahead commit(s)" -ForegroundColor Yellow
                $actionItems += "$name : ahead $ahead commit(s) -- push needed"
            } elseif ($behind -gt 0 -and $ahead -eq 0) {
                Write-Host "  Delta: behind $behind commit(s)" -ForegroundColor Yellow
                $actionItems += "$name : behind $behind commit(s) -- pull needed"
            } else {
                Write-Host "  Delta: DIVERGED (ahead $ahead, behind $behind)" -ForegroundColor Red
                $actionItems += "$name : diverged -- manual resolution needed"
            }
        } else {
            Write-Host "  Remote HEAD: could not resolve $remoteRef" -ForegroundColor Yellow
        }

        # --- Working tree drift (PS5.x compatible -- explicit if blocks, no inline ternary) ---
        $staged    = @()
        $modified  = @()
        $untracked = @()
        $conflicts = @()

        $statusLines = (git status --porcelain)
        foreach ($line in $statusLines) {
            if ($line.Length -lt 3) { continue }
            $x    = $line[0]
            $y    = $line[1]
            $file = $line.Substring(3)
            if ($x -eq '?' -and $y -eq '?') {
                $untracked += $file
            } elseif ($x -eq 'U' -or $y -eq 'U') {
                $conflicts += $file
            } else {
                if ($x -ne ' ') {
                    $staged += $file
                }
                if ($y -ne ' ') {
                    $modified += $file
                }
            }
        }

        if ($staged.Count -gt 0) {
            Write-Host "  Staged ($($staged.Count)):" -ForegroundColor Yellow
            foreach ($f in $staged) { Write-Host "    + $f" }
            $actionItems += "$name : staged changes not yet committed"
        }
        if ($modified.Count -gt 0) {
            Write-Host "  Modified ($($modified.Count)):" -ForegroundColor Yellow
            foreach ($f in $modified) { Write-Host "    M $f" }
            $actionItems += "$name : uncommitted changes in working tree"
        }
        if ($conflicts.Count -gt 0) {
            Write-Host "  Conflicts ($($conflicts.Count)):" -ForegroundColor Red
            foreach ($f in $conflicts) { Write-Host "    C $f" }
            $actionItems += "$name : unresolved conflicts"
        }
        if ($untracked.Count -gt 0) {
            Write-Host "  Untracked ($($untracked.Count)):" -ForegroundColor Gray
            foreach ($f in $untracked) { Write-Host "    ? $f" }
            # Untracked files do NOT trigger ACTION REQUIRED
        }
        if ($staged.Count -eq 0 -and $modified.Count -eq 0 -and $conflicts.Count -eq 0) {
            Write-Host "  Working tree: clean" -ForegroundColor Green
        }

        # --- Stash ---
        $stashList = (git stash list)
        if ($stashList) {
            $stashCount = @($stashList).Count
            Write-Host "  Stash entries: $stashCount" -ForegroundColor Yellow
            foreach ($s in $stashList) { Write-Host "    $s" }
            $actionItems += "$name : $stashCount stash entry/entries present"
        } else {
            Write-Host "  Stash: 0"
        }

    } finally {
        Pop-Location
    }
}

# =============================================================================
# SECTION 2: SS321 (Lovable-hosted, local ledger only)
# =============================================================================
Write-Host ""
Write-Host "[SS321 - Lovable-hosted, local ledger only]" -ForegroundColor Yellow
Write-Host "  Path: $SS321_FOLDER"

if (Test-Path $SS321_FOLDER) {
    Write-Host "  Folder exists: yes"
    Write-Host "  Git state: N/A (source is Lovable, not a local clone)"
    if (Test-Path $SS321_FIX_INDEX) {
        $sfiBytes = (Get-Item $SS321_FIX_INDEX).Length
        $sfiLines = (Get-Content $SS321_FIX_INDEX).Count
        Write-Host "  SS321_FIX_INDEX.md: $sfiBytes bytes | $sfiLines lines" -ForegroundColor Green
    } else {
        Write-Host "  SS321_FIX_INDEX.md: NOT FOUND" -ForegroundColor Red
        $actionItems += "SS321 : SS321_FIX_INDEX.md missing"
    }
} else {
    Write-Host "  Folder: NOT FOUND" -ForegroundColor Red
    $actionItems += "SS321 : local folder does not exist"
}

# =============================================================================
# SECTION 3: Ledger state
# =============================================================================
Write-Host ""
Write-Host "[LEDGER STATE]" -ForegroundColor Yellow

# MASTER_FIX_INDEX last heading
# v4 fix: catches heading format (## FIX-, ### FIX-) and pipe-table format (| FIX-NNN |)
if (Test-Path $MASTER_FIX_INDEX) {
    $mfiLines   = Get-Content $MASTER_FIX_INDEX
    $mfiMatches = $mfiLines | Select-String "(^#{2,3} (FIX-|SS-FIX-)\d+|^\| (FIX-|SS-FIX-)\d+)"
    if ($mfiMatches) {
        $lastMfi     = ($mfiMatches | Select-Object -Last 1)
        $lastMfiLine = $lastMfi.LineNumber
        $lastMfiText = $lastMfi.Line.Trim()
        Write-Host "  MASTER_FIX_INDEX last: $lastMfiText (line $lastMfiLine)"
    } else {
        Write-Host "  MASTER_FIX_INDEX: no FIX headings found" -ForegroundColor Yellow
        $actionItems += "MASTER_FIX_INDEX : no FIX headings located"
    }
} else {
    Write-Host "  MASTER_FIX_INDEX: FILE NOT FOUND" -ForegroundColor Red
    $actionItems += "MASTER_FIX_INDEX : file missing"
}

# Ch18 last entry
# v3 fix: catches both "### Entry-NNN" (older) and "Entry-NNN |" inline format (newer)
if (Test-Path $CH18) {
    $ch18Lines   = Get-Content $CH18
    $ch18Matches = $ch18Lines | Select-String "^(### Entry-|Entry-\d+)"
    if ($ch18Matches) {
        $lastCh18     = ($ch18Matches | Select-Object -Last 1)
        $lastCh18Line = $lastCh18.LineNumber
        $lastCh18Text = $lastCh18.Line.Trim()
        Write-Host "  Ch18 last entry: $lastCh18Text (line $lastCh18Line)"
    } else {
        Write-Host "  Ch18: no Entry headings found" -ForegroundColor Yellow
    }
} else {
    Write-Host "  Ch18: FILE NOT FOUND" -ForegroundColor Red
    $actionItems += "Ch18 : file missing"
}

# SS321_FIX_INDEX last SS-FIX
if (Test-Path $SS321_FIX_INDEX) {
    $sfiContent = Get-Content $SS321_FIX_INDEX
    $sfiMatches = $sfiContent | Select-String "SS-FIX-\d+"
    if ($sfiMatches) {
        $lastSfi     = ($sfiMatches | Select-Object -Last 1)
        $lastSfiLine = $lastSfi.LineNumber
        $lastSfiNum  = [regex]::Match($lastSfi.Line, "SS-FIX-\d+").Value
        Write-Host "  SS321_FIX_INDEX last: $lastSfiNum (line $lastSfiLine)"
    } else {
        Write-Host "  SS321_FIX_INDEX: no SS-FIX references found" -ForegroundColor Yellow
    }
}

# Ch26 term count
if (Test-Path $CH26) {
    $ch26Match = Get-Content $CH26 | Select-String "Current Term Count"
    if ($ch26Match) {
        $ch26Line    = ($ch26Match | Select-Object -First 1)
        $ch26LineNum = $ch26Line.LineNumber
        $ch26Text    = $ch26Line.Line.Trim()
        Write-Host "  Ch26: $ch26Text (line $ch26LineNum)"
    } else {
        Write-Host "  Ch26: term count line not located" -ForegroundColor Yellow
        $actionItems += "Ch26 : Current Term Count line not found"
    }
} else {
    Write-Host "  Ch26: FILE NOT FOUND" -ForegroundColor Red
    $actionItems += "Ch26 : file missing"
}

# =============================================================================
# OVERALL SUMMARY
# =============================================================================
Write-Host ""
Write-Host "===========================================================" -ForegroundColor Cyan
if ($actionItems.Count -eq 0) {
    Write-Host "  OVERALL: READY" -ForegroundColor Green
    Write-Host "  All repos clean. Ledger files present." -ForegroundColor Green
} else {
    Write-Host "  OVERALL: ACTION REQUIRED" -ForegroundColor Yellow
    Write-Host "  $($actionItems.Count) item(s) to review before proceeding:" -ForegroundColor Yellow
    foreach ($item in $actionItems) {
        Write-Host "    - $item" -ForegroundColor Yellow
    }
}
Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host ""
