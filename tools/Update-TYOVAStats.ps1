# Update-TYOVAStats.ps1
# FIX-953 -- Option C -- Auto-update TYOVA masterHubRegistry.ts stats
# Reads live values from source files and patches masterHubRegistry.ts
# Does NOT update phasesSealed or snapshotDate -- those are human decisions only
# Run from any directory -- paths are absolute
# Zero-Fabrication Rule applies -- only writes values it can verify from source

param(
    [switch]$DryRun,
    [switch]$Quiet
)

$ErrorActionPreference = "Stop"

# ─────────────────────────────────────────────────────────────
# PATHS
# ─────────────────────────────────────────────────────────────
$TYOVA_ROOT       = "E:\TY-Ecosystem\TYOVA"
$REGISTRY_FILE    = "$TYOVA_ROOT\src\config\masterHubRegistry.ts"
$BOOK_INDEX_FILE  = "$TYOVA_ROOT\src\pages\BookOfTyIndex.tsx"
$CH26_FILE        = "E:\TY-Ecosystem\ty-ai-governance\book\TY_BOOK_CHAPTER_26_THE_TY_AI_OS_VOCABULARY.md"
$TEST_COUNT_FILE  = "E:\TY-Ecosystem\Jaya-Runtime\src-tauri\.last-test-count.json"

if (-not $Quiet) {
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "  TY AI OS -- Update-TYOVAStats.ps1" -ForegroundColor Cyan
    Write-Host "  Auto-sync masterHubRegistry.ts from live source files" -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host ""
}

$errors   = @()
$updates  = @()

# ─────────────────────────────────────────────────────────────
# READ 1 -- chaptersSealed from BookOfTyIndex.tsx
# Count { ... sealed: true ... } entries in the chapters array
# ─────────────────────────────────────────────────────────────
$chaptersSealed = $null
if (Test-Path $BOOK_INDEX_FILE) {
    $indexContent = Get-Content $BOOK_INDEX_FILE -Raw
    $sealedMatches = [regex]::Matches($indexContent, '\{\s*num:\s*\d+')
    $chaptersSealed = $sealedMatches.Count
    if (-not $Quiet) {
        Write-Host "  [READ] chaptersSealed  : $chaptersSealed (from BookOfTyIndex.tsx)" -ForegroundColor Gray
    }
} else {
    $errors += "BookOfTyIndex.tsx not found at $BOOK_INDEX_FILE"
}

# ─────────────────────────────────────────────────────────────
# READ 2 -- vocabTerms from Ch26 header
# Reads: **Current Term Count:** NNN
# ─────────────────────────────────────────────────────────────
$vocabTerms = $null
if (Test-Path $CH26_FILE) {
    $ch26Content = Get-Content $CH26_FILE -Raw
    $termMatch = [regex]::Match($ch26Content, '\*\*Current Term Count:\*\*\s*(\d+)')
    if ($termMatch.Success) {
        $vocabTerms = [int]$termMatch.Groups[1].Value
        if (-not $Quiet) {
            Write-Host "  [READ] vocabTerms      : $vocabTerms (from Ch26 header)" -ForegroundColor Gray
        }
    } else {
        $errors += "Could not find **Current Term Count:** in Ch26"
    }
} else {
    $errors += "Ch26 not found at $CH26_FILE"
}

# ─────────────────────────────────────────────────────────────
# READ 3 -- testsTotal / testsPass from .last-test-count.json
# Written by cargo test via Write-TestCount.ps1 after each run
# Falls back gracefully if file does not exist yet
# ─────────────────────────────────────────────────────────────
$testsTotal = $null
$testsPass  = $null
if (Test-Path $TEST_COUNT_FILE) {
    try {
        $testJson   = Get-Content $TEST_COUNT_FILE -Raw | ConvertFrom-Json
        $testsTotal = [int]$testJson.testsTotal
        $testsPass  = [int]$testJson.testsPass
        if (-not $Quiet) {
            Write-Host "  [READ] testsTotal      : $testsTotal (from .last-test-count.json)" -ForegroundColor Gray
            Write-Host "  [READ] testsPass       : $testsPass (from .last-test-count.json)" -ForegroundColor Gray
        }
    } catch {
        $errors += "Could not parse .last-test-count.json: $_"
    }
} else {
    if (-not $Quiet) {
        Write-Host "  [SKIP] testsTotal/Pass : .last-test-count.json not found -- skipping test count update" -ForegroundColor Yellow
        Write-Host "         Run Write-TestCount.ps1 after cargo test to enable auto-update" -ForegroundColor Yellow
    }
}

# ─────────────────────────────────────────────────────────────
# ABORT if critical reads failed
# ─────────────────────────────────────────────────────────────
if ($errors.Count -gt 0) {
    Write-Host ""
    Write-Host "  [ABORT] Cannot update -- source read errors:" -ForegroundColor Red
    foreach ($e in $errors) {
        Write-Host "    - $e" -ForegroundColor Red
    }
    Write-Host ""
    exit 1
}

# ─────────────────────────────────────────────────────────────
# READ CURRENT VALUES from masterHubRegistry.ts
# ─────────────────────────────────────────────────────────────
if (-not (Test-Path $REGISTRY_FILE)) {
    Write-Host "  [ABORT] masterHubRegistry.ts not found at $REGISTRY_FILE" -ForegroundColor Red
    exit 1
}

$registry = Get-Content $REGISTRY_FILE -Raw

$currentChapters = [regex]::Match($registry, 'chaptersSealed:\s*(\d+)').Groups[1].Value
$currentVocab    = [regex]::Match($registry, 'vocabTerms:\s*(\d+)').Groups[1].Value
$currentTotal    = [regex]::Match($registry, 'testsTotal:\s*(\d+)').Groups[1].Value
$currentPass     = [regex]::Match($registry, 'testsPass:\s*(\d+)').Groups[1].Value

# ─────────────────────────────────────────────────────────────
# COMPUTE CHANGES
# ─────────────────────────────────────────────────────────────
$changed = $false

if ($chaptersSealed -ne $null -and [int]$currentChapters -ne $chaptersSealed) {
    $updates += "  chaptersSealed : $currentChapters --> $chaptersSealed"
    $registry = $registry -replace "chaptersSealed:\s*\d+", "chaptersSealed: $chaptersSealed"
    $changed = $true
}

if ($vocabTerms -ne $null -and [int]$currentVocab -ne $vocabTerms) {
    $updates += "  vocabTerms     : $currentVocab --> $vocabTerms"
    $registry = $registry -replace "vocabTerms:\s*\d+", "vocabTerms: $vocabTerms"
    $changed = $true
}

if ($testsTotal -ne $null -and [int]$currentTotal -ne $testsTotal) {
    $updates += "  testsTotal     : $currentTotal --> $testsTotal"
    $registry = $registry -replace "testsTotal:\s*\d+", "testsTotal: $testsTotal"
    $changed = $true
}

if ($testsPass -ne $null -and [int]$currentPass -ne $testsPass) {
    $updates += "  testsPass      : $currentPass --> $testsPass"
    $registry = $registry -replace "testsPass:\s*\d+", "testsPass: $testsPass"
    $changed = $true
}

# ─────────────────────────────────────────────────────────────
# REPORT
# ─────────────────────────────────────────────────────────────
if (-not $Quiet) {
    Write-Host ""
    if ($changed) {
        Write-Host "  Changes detected:" -ForegroundColor Yellow
        foreach ($u in $updates) {
            Write-Host $u -ForegroundColor Yellow
        }
    } else {
        Write-Host "  No changes needed -- masterHubRegistry.ts is current." -ForegroundColor Green
    }
    Write-Host ""
    Write-Host "  NOTE: phasesSealed and snapshotDate are NOT auto-updated." -ForegroundColor Gray
    Write-Host "        These are human governance decisions -- update manually." -ForegroundColor Gray
    Write-Host ""
}

# ─────────────────────────────────────────────────────────────
# WRITE (unless DryRun)
# ─────────────────────────────────────────────────────────────
if ($changed -and -not $DryRun) {
    [System.IO.File]::WriteAllText($REGISTRY_FILE, $registry, [System.Text.UTF8Encoding]::new($false))
    if (-not $Quiet) {
        Write-Host "  [WRITE] masterHubRegistry.ts updated." -ForegroundColor Green
        Write-Host "  Commit TYOVA after verifying the diff." -ForegroundColor Green
    }
} elseif ($DryRun -and $changed) {
    if (-not $Quiet) {
        Write-Host "  [DRY-RUN] No files written. Remove -DryRun to apply." -ForegroundColor Cyan
    }
}

if (-not $Quiet) {
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host ""
}

# Return exit code 0 = success / no change needed
# Return exit code 2 = changes were made (for Pre-Flight awareness)
if ($changed -and -not $DryRun) { exit 2 }
exit 0
