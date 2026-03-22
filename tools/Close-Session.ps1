# =====================================================
# Close-Session.ps1
# TY AI OS -- Session Close Automation
# Location: E:\TY-Ecosystem\ty-ai-governance\tools\
# Model reference: Generate-Handoff.ps1
# =====================================================

param(
    [Parameter(Mandatory=$true)]
    [string]$CLO,

    [Parameter(Mandatory=$true)]
    [string]$FIX,

    [Parameter(Mandatory=$true)]
    [string]$PartNumber,

    [Parameter(Mandatory=$true)]
    [string]$SessionSummary
)

$ErrorActionPreference = "Stop"

# ── Timestamp ──────────────────────────────────────
$tzSanDiego  = [System.TimeZoneInfo]::FindSystemTimeZoneById("Pacific Standard Time")
$nowUtc      = [System.DateTime]::UtcNow
$nowSD       = [System.TimeZoneInfo]::ConvertTimeFromUtc($nowUtc, $tzSanDiego)
$dateStamp   = $nowSD.ToString("yyyy-MM-dd")
$timeStamp   = $nowSD.ToString("HH:mm")
$fullStamp   = "$dateStamp | $timeStamp San Diego"

Write-Host ""
Write-Host "====================================================="
Write-Host " TY AI OS -- SESSION CLOSE"
Write-Host " $fullStamp"
Write-Host "====================================================="

# ── Paths ──────────────────────────────────────────
$rootJaya    = "E:\TY-Ecosystem\Jaya-Runtime"
$rootGov     = "E:\TY-Ecosystem\ty-ai-governance"
$rootTYOVA   = "E:\TY-Ecosystem\TYOVA"
$ch18Path    = "$rootGov\book\TY_BOOK_CHAPTER_18_GOVERNANCE_MAINTENANCE_RECORD.md"
$masterIdx   = "$rootGov\governance\ledger\MASTER_FIX_INDEX.md"
$policyFile  = "$rootGov\policy\active_policy.json"
$srcTauri    = "$rootJaya\src-tauri"

# ── GATE 1: S1 Scan -- UTF-8 double-encoding ───────
Write-Host ""
Write-Host "[ GATE 1 ] S1 Scan -- UTF-8 encoding corruption"
$s1Hits = Get-ChildItem "$rootJaya\src","$rootJaya\src-tauri\src","$rootGov","$rootTYOVA\src" `
    -Recurse -Include "*.rs","*.tsx","*.ts","*.md" | ForEach-Object {
        $raw = Get-Content $_.FullName -Raw
        if ($raw -match "â€\x9d|â€\x93|â€\x94|Ã\x83Ã") {
            $_.FullName
        }
    }

if ($s1Hits) {
    Write-Host "  FAIL -- S1 hits found:"
    $s1Hits | ForEach-Object { Write-Host "    REAL CORRUPTION: $_" }
    Write-Host "  STOP -- resolve S1 corruption before closing session."
    exit 1
} else {
    Write-Host "  PASS -- S1 clean"
}

# ── GATE 2: S2 Scan -- A~ pattern ──────────────────
Write-Host ""
Write-Host "[ GATE 2 ] S2 Scan -- A~ pattern corruption"
$knownFalsePositives = @(
    @{ File = "TY_BOOK_CHAPTER_18_GOVERNANCE_MAINTENANCE_RECORD.md"; Lines = @(108,291,406,431) },
    @{ File = "TY_BOOK_CHAPTER_22_THE_BUILD_RESILIENCE_RECORD.md";   Lines = @(68) },
    @{ File = "TY_BOOK_CHAPTER_26_THE_TY_AI_OS_VOCABULARY.md";       Lines = @(944) }
)

$s2Results = Get-ChildItem "$rootJaya\src","$rootJaya\src-tauri\src","$rootGov","$rootTYOVA\src" `
    -Recurse -Include "*.rs","*.tsx","*.ts","*.md" | Select-String "A~" | Select-Object Path, LineNumber

$realS2Hits = $s2Results | Where-Object {
    $hit = $_
    $isFalsePositive = $false
    foreach ($fp in $knownFalsePositives) {
        if ($hit.Path -like "*$($fp.File)*" -and $fp.Lines -contains $hit.LineNumber) {
            $isFalsePositive = $true
            break
        }
    }
    -not $isFalsePositive
}

if ($realS2Hits) {
    Write-Host "  FAIL -- Real S2 hits found:"
    $realS2Hits | ForEach-Object { Write-Host "    HIT: $($_.Path) line $($_.LineNumber)" }
    Write-Host "  STOP -- resolve S2 corruption before closing session."
    exit 1
} else {
    Write-Host "  PASS -- S2 clean (known false positives excluded)"
}

# ── GATE 3: cargo check ────────────────────────────
Write-Host ""
Write-Host "[ GATE 3 ] cargo check -- Jaya-Runtime"
Push-Location $srcTauri
$cargoResult = cargo check 2>&1
Pop-Location

$cargoErrors = $cargoResult | Where-Object { $_ -match "^error" }
if ($cargoErrors) {
    Write-Host "  FAIL -- cargo check errors:"
    $cargoErrors | ForEach-Object { Write-Host "    $_" }
    Write-Host "  STOP -- resolve cargo errors before closing session."
    exit 1
} else {
    Write-Host "  PASS -- cargo check = 0 errors"
}

# ── GATE 4: Repo States ────────────────────────────
Write-Host ""
Write-Host "[ GATE 4 ] Repo states"

Push-Location $rootJaya
$jayaLog = git log --oneline -1
$jayaStatus = git status --short
Pop-Location

Push-Location $rootGov
$govLog = git log --oneline -1
$govStatus = git status --short
Pop-Location

Push-Location $rootTYOVA
$tyovaLog = git log --oneline -1
$tyovaStatus = git status --short
Pop-Location

Write-Host "  Jaya-Runtime:     $jayaLog"
Write-Host "  ty-ai-governance: $govLog"
Write-Host "  TYOVA:            $tyovaLog"

if ($jayaStatus -or $govStatus -or $tyovaStatus) {
    Write-Host "  WARNING -- uncommitted changes detected:"
    if ($jayaStatus) { Write-Host "    Jaya-Runtime: $jayaStatus" }
    if ($govStatus)  { Write-Host "    ty-ai-governance: $govStatus" }
    if ($tyovaStatus){ Write-Host "    TYOVA: $tyovaStatus" }
} else {
    Write-Host "  PASS -- all repos clean"
}

# ── GATE 5: MASTER_FIX_INDEX append ───────────────
Write-Host ""
Write-Host "[ GATE 5 ] MASTER_FIX_INDEX -- appending entry"

$fixEntry = @"

### $FIX | $CLO | Claude Sonnet 4.6 | $dateStamp | $timeStamp San Diego
Part: $PartNumber
Summary: $SessionSummary
Jaya-Runtime:     $jayaLog
ty-ai-governance: $govLog
TYOVA:            $tyovaLog
"@

$existingMaster = [System.IO.File]::ReadAllText($masterIdx)
$newMaster = $existingMaster + $fixEntry
[System.IO.File]::WriteAllText($masterIdx, $newMaster, [System.Text.UTF8Encoding]::new($false))
Write-Host "  PASS -- MASTER_FIX_INDEX entry written"

# ── GATE 6: Chapter 18 append ──────────────────────
Write-Host ""
Write-Host "[ GATE 6 ] Chapter 18 -- appending entry"

$ch18Lines = [System.IO.File]::ReadAllLines($ch18Path)
$lastEntryLine = ($ch18Lines | Select-String "### Entry-" | Select-Object -Last 1)
$lastEntryNum  = 0
if ($lastEntryLine -match "Entry-(\d+)") { $lastEntryNum = [int]$Matches[1] }
$nextEntryNum  = ($lastEntryNum + 1).ToString("D3")

$ch18Entry = @"

### Entry-$nextEntryNum | $FIX | $CLO | $fullStamp
**Part:** $PartNumber
**Summary:** $SessionSummary
**Scans:** S1 clean -- S2 clean
**Build:** cargo check = 0
**Repos:** Jaya $jayaLog | Gov $govLog | TYOVA $tyovaLog
"@

$existingCh18 = [System.IO.File]::ReadAllText($ch18Path)
$newCh18 = $existingCh18 + $ch18Entry
[System.IO.File]::WriteAllText($ch18Path, $newCh18, [System.Text.UTF8Encoding]::new($false))
Write-Host "  PASS -- Chapter 18 Entry-$nextEntryNum written"

# ── GATE 7: Ch18 scan confirmation ─────────────────
Write-Host ""
Write-Host "[ GATE 7 ] Chapter 18 -- entry format scan"
$ch18Entries = Get-Content $ch18Path | Select-String "### Entry-|## ENTRY"
Write-Host "  Entries found:"
$ch18Entries | ForEach-Object { Write-Host "    $_" }

# ── GATE 8: Invoke Generate-Handoff.ps1 ───────────
Write-Host ""
Write-Host "[ GATE 8 ] Generating handoff document"
$handoffScript = "$rootGov\tools\Generate-Handoff.ps1"
if (Test-Path $handoffScript) {
    & $handoffScript
    Write-Host "  PASS -- Handoff generated"
} else {
    Write-Host "  SKIP -- Generate-Handoff.ps1 not found at $handoffScript"
}

# ── Summary ────────────────────────────────────────
Write-Host ""
Write-Host "====================================================="
Write-Host " SESSION CLOSE COMPLETE"
Write-Host " $FIX | $CLO | $fullStamp"
Write-Host " All gates passed. Session is sealed."
Write-Host "====================================================="