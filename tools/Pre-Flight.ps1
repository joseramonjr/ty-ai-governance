# =============================================================================
# Pre-Flight.ps1 — TY AI OS Session State Diagnostic
# =============================================================================
# Purpose: Read-only diagnostic reporting state of the TY ecosystem:
#          - Two local git repos (ty-ai-governance, TYOVA)
#          - One Lovable-hosted local-ledger-only folder (SS321)
#          plus ledger state parsed from canonical governance files.
#          Run at the start of every TY work session to establish ground
#          truth before making any changes.
#
# Built under: FIX-189 | CLO-389 | Claude Opus 4.7 | 2026-04-19 | San Diego
# Per memory entries #28 (Accuracy-First Principle) and #30 (Pre-Flight proposal).
#
# Design:
#   - Zero arguments (run as: .\Pre-Flight.ps1)
#   - Fetches origin on each git repo before reporting remote HEAD
#   - Reports detailed working-tree drift (each file listed)
#   - Reports stash entries and bad-state warnings
#   - SS321 handled as non-git folder: reports ledger file presence only
#   - Parses ledger state (Last FIX/CLO/Ch18/SS-FIX/Ch26) from files
#   - Report and Continue (Option A): warnings prominent, script exits clean
#   - Read-only: makes no commits, no writes, no pushes. git fetch only.
#
# Revision history:
#   v1 2026-04-19 09:25 — initial draft, failed first test
#   v2 2026-04-19 12:30 — 4 fixes: PS5.x syntax, rebase detection,
#                          SS321 handling, Ch26 regex
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

    # Check path exists
    if (-not (Test-Path $path)) {
        Write-Host "  STATUS: PATH NOT FOUND" -ForegroundColor Red
        $actionItems += "$name : path does not exist"
        continue
    }

    # Check it is a git repo
    if (-not (Test-Path (Join-Path $path ".git"))) {
        Write-Host "  STATUS: NOT A GIT REPOSITORY" -ForegroundColor Red
        $actionItems += "$name : not a git repository"
        continue
    }

    Push-Location $path
    try {
        # --- Bad-state detection ---
        # Active rebase requires rebase-merge OR rebase-apply directory.
        # REBASE_HEAD file alone is often stale leftover from completed rebase,
        # and does NOT mean a rebase is in progress.
        $gitDir = ".git"
        $badStates = @()
        if (Test-Path (Join-Path $gitDir "MERGE_HEAD"))             { $badStates += "MERGE_IN_PROGRESS" }
        if (Test-Path (Join-Path $gitDir "rebase-merge"))           { $badStates += "REBASE_IN_PROGRESS (interactive)" }
        if (Test-Path (Join-Path $gitDir "rebase-apply"))           { $badStates += "REBASE_IN_PROGRESS (apply)" }
        if (Test-Path (Join-Path $gitDir "CHERRY_PICK_HEAD"))       { $badStates += "CHERRY_PICK_IN_PROGRESS" }
        if (Test-Path (Join-Path $gitDir "BISECT_LOG"))             { $badStates += "BISECT_IN_PROGRESS" }

        # --- Current branch / detached HEAD detection ---
        $branchRef = git symbolic-ref --quiet --short HEAD 2>$null
        if ($LASTEXITCODE -ne 0 -or -not $branchRef) {
            $currentCommit = git rev-parse --short HEAD 2>$null
            Write-Host "  Branch: (detached HEAD at $currentCommit)" -ForegroundColor Red
            $badStates += "DETACHED_HEAD"
        } else {
            Write-Host "  Branch: $branchRef"
        }

        # --- Prominent bad-state warning block ---
        if ($badStates.Count -gt 0) {
            Write-Host "  !! BAD STATE DETECTED: $($badStates -join ', ')" -ForegroundColor Red -BackgroundColor Black
            foreach ($b in $badStates) {
                $actionItems += "$name : $b"
            }
        }

        # --- Fetch origin (network call) ---
        Write-Host "  Fetching origin..." -ForegroundColor DarkGray
        $fetchOutput = git fetch origin 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Host "  FETCH FAILED: $fetchOutput" -ForegroundColor Red
            $actionItems += "$name : fetch failed (remote unreachable or auth issue)"
        }

        # --- Local HEAD ---
        $localHead    = git rev-parse --short HEAD 2>$null
        $localMsg     = git log -1 --pretty=format:"%s" 2>$null
        Write-Host ("  Local HEAD:  {0}  {1}" -f $localHead, $localMsg)

        # --- Remote HEAD (if branch has upstream) ---
        $upstream = git rev-parse --abbrev-ref --symbolic-full-name "@{upstream}" 2>$null
        if ($LASTEXITCODE -eq 0 -and $upstream) {
            $remoteHead = git rev-parse --short $upstream 2>$null
            $remoteMsg  = git log -1 --pretty=format:"%s" $upstream 2>$null
            Write-Host ("  Remote HEAD: {0}  {1}" -f $remoteHead, $remoteMsg)
            Write-Host ("  Upstream: {0}" -f $upstream)

            # --- Ahead / behind ---
            $counts = git rev-list --left-right --count "HEAD...$upstream" 2>$null
            if ($counts) {
                $parts  = $counts -split "\s+"
                $ahead  = [int]$parts[0]
                $behind = [int]$parts[1]
                if ($ahead -eq 0 -and $behind -eq 0) {
                    Write-Host "  Delta: same (local = remote)" -ForegroundColor Green
                } elseif ($ahead -gt 0 -and $behind -eq 0) {
                    Write-Host ("  Delta: ahead {0} commit(s) (local ahead of remote)" -f $ahead) -ForegroundColor Yellow
                    $actionItems += "$name : $ahead commit(s) ahead of remote (push pending?)"
                } elseif ($ahead -eq 0 -and $behind -gt 0) {
                    Write-Host ("  Delta: behind {0} commit(s) (remote ahead of local)" -f $behind) -ForegroundColor Yellow
                    $actionItems += "$name : $behind commit(s) behind remote (pull required)"
                } else {
                    Write-Host ("  Delta: DIVERGED (ahead {0}, behind {1})" -f $ahead, $behind) -ForegroundColor Red
                    $actionItems += "$name : diverged from remote (ahead $ahead, behind $behind)"
                }
            }
        } else {
            Write-Host "  Remote HEAD: (no upstream configured)" -ForegroundColor Yellow
            $actionItems += "$name : no upstream configured"
        }

        # --- Working-tree state (detailed) ---
        # PowerShell 5.x compatible: explicit if blocks, no inline expressions.
        $statusLines = git status --porcelain 2>$null
        if (-not $statusLines) {
            Write-Host "  Working tree: clean" -ForegroundColor Green
        } else {
            # Coerce to array if a single line was returned as string
            if ($statusLines -is [string]) { $statusLines = @($statusLines) }

            $modified  = @()
            $staged    = @()
            $untracked = @()
            $conflict  = @()
            foreach ($line in $statusLines) {
                if ($line.Length -lt 3) { continue }
                $code = $line.Substring(0, 2)
                $file = $line.Substring(3)
                if ($code -eq "??") {
                    $untracked += $file
                } elseif ($code -match "U") {
                    $conflict += $file
                } else {
                    # Index position (code[0]) tracks staged changes
                    if ($code[0] -ne ' ') {
                        $staged += $file
                    }
                    # Worktree position (code[1]) tracks unstaged changes
                    if ($code[1] -ne ' ') {
                        $modified += $file
                    }
                }
            }

            $totalCount = $statusLines.Count
            Write-Host "  Working tree: $totalCount entries" -ForegroundColor Yellow

            if ($staged.Count -gt 0) {
                Write-Host "    Staged ($($staged.Count)):"
                foreach ($f in $staged) { Write-Host "      $f" }
            }
            if ($modified.Count -gt 0) {
                Write-Host "    Modified ($($modified.Count)):"
                foreach ($f in $modified) { Write-Host "      $f" }
            }
            if ($untracked.Count -gt 0) {
                Write-Host "    Untracked ($($untracked.Count)):"
                foreach ($f in $untracked) { Write-Host "      $f" }
            }
            if ($conflict.Count -gt 0) {
                Write-Host "    CONFLICTED ($($conflict.Count)):" -ForegroundColor Red
                foreach ($f in $conflict) { Write-Host "      $f" }
                $actionItems += "$name : $($conflict.Count) conflicted file(s)"
            }

            # Only flag staged/modified/conflict as action items.
            # Untracked-only drift is common (node_modules, work scripts, etc.) and not an action.
            if ($staged.Count -gt 0 -or $modified.Count -gt 0) {
                $actionItems += "$name : uncommitted changes in working tree"
            }
        }

        # --- Stash entries ---
        $stashList = git stash list 2>$null
        if ($stashList) {
            if ($stashList -is [string]) { $stashList = @($stashList) }
            $stashCount = $stashList.Count
            Write-Host "  Stash entries: $stashCount" -ForegroundColor Yellow
            foreach ($s in $stashList) { Write-Host "    $s" }
            $actionItems += "$name : $stashCount stash entry(ies) (review before closing ecosystem)"
        } else {
            Write-Host "  Stash entries: 0"
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
Write-Host "  Local folder: $SS321_FOLDER"
Write-Host "  Git state:    N/A (SS321 code hosted by Lovable, no local clone)"

if (Test-Path $SS321_FOLDER) {
    Write-Host "  Folder exists: yes" -ForegroundColor Green

    if (Test-Path $SS321_FIX_INDEX) {
        $ssLedgerSize = (Get-Item $SS321_FIX_INDEX).Length
        $ssLedgerLines = (Get-Content $SS321_FIX_INDEX).Count
        Write-Host "  Ledger file:  SS321_FIX_INDEX.md ($ssLedgerSize bytes, $ssLedgerLines lines)"
    } else {
        Write-Host "  Ledger file:  SS321_FIX_INDEX.md MISSING" -ForegroundColor Red
        $actionItems += "SS321 : SS321_FIX_INDEX.md missing from $SS321_FOLDER"
    }
} else {
    Write-Host "  Folder MISSING at $SS321_FOLDER" -ForegroundColor Red
    $actionItems += "SS321 : local folder missing"
}

# =============================================================================
# SECTION 3: Ledger state (parsed from canonical files)
# =============================================================================
Write-Host ""
Write-Host "[LEDGER STATE - parsed from files]" -ForegroundColor Yellow

# Last FIX + CLO from MASTER_FIX_INDEX.md last "### FIX-N" heading line
if (Test-Path $MASTER_FIX_INDEX) {
    $lastFixLine = Select-String -Path $MASTER_FIX_INDEX -Pattern "^### FIX-\d+" | Select-Object -Last 1
    if ($lastFixLine) {
        Write-Host ("  MASTER_FIX_INDEX last heading (line {0}):" -f $lastFixLine.LineNumber)
        Write-Host ("    {0}" -f $lastFixLine.Line)
    } else {
        Write-Host "  MASTER_FIX_INDEX: no FIX headings found" -ForegroundColor Red
        $actionItems += "MASTER_FIX_INDEX : no FIX headings parseable"
    }
} else {
    Write-Host "  MASTER_FIX_INDEX: FILE NOT FOUND at $MASTER_FIX_INDEX" -ForegroundColor Red
    $actionItems += "MASTER_FIX_INDEX : file not found"
}

# Last Ch18 Entry from Ch18 last "### Entry-N" heading line
if (Test-Path $CH18) {
    $lastEntryLine = Select-String -Path $CH18 -Pattern "^### Entry-\d+|^### Entry \d+" | Select-Object -Last 1
    if ($lastEntryLine) {
        Write-Host ("  Ch18 last Entry (line {0}):" -f $lastEntryLine.LineNumber)
        Write-Host ("    {0}" -f $lastEntryLine.Line)
    } else {
        Write-Host "  Ch18: no Entry headings found" -ForegroundColor Red
        $actionItems += "Ch18 : no Entry headings parseable"
    }
} else {
    Write-Host "  Ch18: FILE NOT FOUND at $CH18" -ForegroundColor Red
    $actionItems += "Ch18 : file not found"
}

# Last SS-FIX from SS321_FIX_INDEX.md
if (Test-Path $SS321_FIX_INDEX) {
    $lastSsFixLine = Select-String -Path $SS321_FIX_INDEX -Pattern "SS-FIX-\d+" | Select-Object -Last 1
    if ($lastSsFixLine) {
        Write-Host ("  SS321_FIX_INDEX last SS-FIX reference (line {0}):" -f $lastSsFixLine.LineNumber)
        Write-Host ("    {0}" -f $lastSsFixLine.Line.Trim())
    } else {
        Write-Host "  SS321_FIX_INDEX: no SS-FIX references found" -ForegroundColor Yellow
    }
} else {
    Write-Host "  SS321_FIX_INDEX: file not found at $SS321_FIX_INDEX" -ForegroundColor Yellow
}

# Ch26 term count - pattern: **Current Term Count:** N (markdown bold)
if (Test-Path $CH26) {
    $termCountLine = Select-String -Path $CH26 -Pattern "Current Term Count" | Select-Object -First 1
    if ($termCountLine) {
        Write-Host ("  Ch26 term count (line {0}):" -f $termCountLine.LineNumber)
        Write-Host ("    {0}" -f $termCountLine.Line.Trim())
    } else {
        Write-Host "  Ch26: 'Current Term Count' line not located" -ForegroundColor Yellow
    }
} else {
    Write-Host "  Ch26: FILE NOT FOUND at $CH26" -ForegroundColor Red
    $actionItems += "Ch26 : file not found"
}

# =============================================================================
# SECTION 4: Overall summary
# =============================================================================
Write-Host ""
Write-Host "===========================================================" -ForegroundColor Cyan
if ($actionItems.Count -eq 0) {
    Write-Host "  OVERALL: READY" -ForegroundColor Green
    Write-Host "  Both git repos clean and synced. SS321 ledger present. Ledger files parseable." -ForegroundColor Green
} else {
    Write-Host "  OVERALL: ACTION REQUIRED" -ForegroundColor Yellow
    Write-Host "  $($actionItems.Count) item(s) to review before proceeding:" -ForegroundColor Yellow
    foreach ($item in $actionItems) {
        Write-Host "    - $item" -ForegroundColor Yellow
    }
}
Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host ""
