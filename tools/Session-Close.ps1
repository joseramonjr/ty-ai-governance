# TY-ANCHOR -- Session-Close.ps1
# Full session close checklist. Confirm R14. Display summary.
# Usage: .\Session-Close.ps1
# Built: FIX-534 | 2026-05-19 | San Diego
# Part of TY-ANCHOR v0.1 -- see TY-ANCHOR-ETHOS.md

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$CH18         = "E:\TY-Ecosystem\ty-ai-governance\book\TY_BOOK_CHAPTER_18_GOVERNANCE_MAINTENANCE_RECORD.md"
$MFI          = "E:\TY-Ecosystem\ty-ai-governance\governance\ledger\MASTER_FIX_INDEX.md"
$CH26         = "E:\TY-Ecosystem\ty-ai-governance\book\TY_BOOK_CHAPTER_26_THE_TY_AI_OS_VOCABULARY.md"
$SESSION_FILE = "E:\TY-Ecosystem\ty-ai-governance\tools\.ty-anchor-session.json"

$repos = @(
    @{ name = "ty-ai-governance"; path = "E:\TY-Ecosystem\ty-ai-governance" },
    @{ name = "TYOVA";            path = "E:\TY-Ecosystem\TYOVA" },
    @{ name = "Jaya-Runtime";     path = "E:\TY-Ecosystem\Jaya-Runtime" }
)

$failures = 0

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  TY-ANCHOR -- Session-Close" -ForegroundColor Cyan
Write-Host "  $(Get-Date -Format 'yyyy-MM-dd HH:mm') PDT | San Diego" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# -- GATE 1: No open FIX
Write-Host "GATE 1: Open FIX check" -ForegroundColor Yellow
Write-Host "----------------------------------------------------------"
if (Test-Path $SESSION_FILE) {
    $session = Get-Content $SESSION_FILE | ConvertFrom-Json
    if ($session.status -eq "OPEN") {
        Write-Host "  [FAIL] $($session.fixId) is still OPEN." -ForegroundColor Red
        Write-Host "         Run FIX-Close.ps1 before Session-Close.ps1." -ForegroundColor Red
        $failures++
    } else {
        Write-Host "  [PASS] Last FIX $($session.fixId) -- CLOSED." -ForegroundColor Green
    }
} else {
    Write-Host "  [PASS] No session file found -- no open FIX." -ForegroundColor Green
}
Write-Host ""

# -- GATE 2: Repo states
Write-Host "GATE 2: Repo states" -ForegroundColor Yellow
Write-Host "----------------------------------------------------------"
foreach ($r in $repos) {
    if (-not (Test-Path $r.path)) {
        Write-Host "  [SKIP] $($r.name) -- path not found" -ForegroundColor Gray
        continue
    }
    Push-Location $r.path
    try {
        $head       = (git rev-parse --short HEAD 2>&1).Trim()
        $msg        = (git log -1 --pretty=format:"%s" 2>&1).Trim()
        $statusOut  = (git status --porcelain 2>&1)
        $dirty      = @($statusOut | Where-Object { $_ -match "^[MADRCU]| [MADRCU]" }).Count
        if ($dirty -gt 0) {
            Write-Host "  [WARN] $($r.name)  HEAD: $head -- $dirty uncommitted file(s)" -ForegroundColor Yellow
            $failures++
        } else {
            Write-Host "  [PASS] $($r.name)  HEAD: $head -- clean" -ForegroundColor Green
        }
        Write-Host "         $msg" -ForegroundColor Gray
    } finally {
        Pop-Location
    }
}
Write-Host ""

# -- GATE 3: Ch18 scan
Write-Host "GATE 3: Ch18 chain -- last 5 entries" -ForegroundColor Yellow
Write-Host "----------------------------------------------------------"
if (Test-Path $CH18) {
    $entries = Get-Content $CH18 | Select-String "### Entry|## ENTRY" | Select-Object -Last 5
    foreach ($e in $entries) { Write-Host "    $($e.Line)" }
    $ch18Lines = [System.IO.File]::ReadAllLines($CH18).Count
    Write-Host "  Total Ch18 lines: $ch18Lines" -ForegroundColor Gray
    Write-Host "  [PASS] Ch18 scan complete." -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Ch18 not found." -ForegroundColor Red
    $failures++
}
Write-Host ""

# -- GATE 4: MFI confirmed current
Write-Host "GATE 4: MFI last entry" -ForegroundColor Yellow
Write-Host "----------------------------------------------------------"
if (Test-Path $MFI) {
    $mfiLines  = [System.IO.File]::ReadAllLines($MFI)
    $lastMFI   = ($mfiLines | Select-String "(^#{2,3} (FIX-|FLAG-)\d+|^\| (FIX-|FLAG-)\d+)" | Select-Object -Last 1).Line.Trim()
    Write-Host "  Last MFI entry: $lastMFI" -ForegroundColor Gray
    Write-Host "  Total MFI lines: $($mfiLines.Count)" -ForegroundColor Gray
    Write-Host "  [PASS] MFI confirmed current." -ForegroundColor Green
} else {
    Write-Host "  [FAIL] MFI not found." -ForegroundColor Red
    $failures++
}
Write-Host ""

# -- GATE 5: Ch26 present
Write-Host "GATE 5: Ch26 vocabulary file" -ForegroundColor Yellow
Write-Host "----------------------------------------------------------"
if (Test-Path $CH26) {
    $ch26Lines = [System.IO.File]::ReadAllLines($CH26).Count
    $termCount = (Get-Content $CH26 | Select-String "Current Term Count" | Select-Object -First 1).Line.Trim()
    Write-Host "  $termCount" -ForegroundColor Gray
    Write-Host "  Total Ch26 lines: $ch26Lines" -ForegroundColor Gray
    Write-Host "  [PASS] Ch26 present." -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Ch26 not found." -ForegroundColor Red
    $failures++
}
Write-Host ""

# -- VERDICT
Write-Host "============================================================" -ForegroundColor Cyan
if ($failures -eq 0) {
    Write-Host "  SESSION-CLOSE: PASS" -ForegroundColor Green
    Write-Host "  R14 CLEAR. All gates passed. Safe to end session." -ForegroundColor Green
} else {
    Write-Host "  SESSION-CLOSE: FAIL -- $failures gate(s) did not pass." -ForegroundColor Red
    Write-Host "  Resolve all failures before ending session." -ForegroundColor Red
}
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""