# TY-ANCHOR -- FIX-Close.ps1
# Closes a FIX. Writes Ch18 + MFI entries. Confirms chain.
# Usage: .\FIX-Close.ps1 -CommitHash "abc1234" -CloseNote "what was built"
# Built: FIX-534 | 2026-05-19 | San Diego
# Part of TY-ANCHOR v0.1 -- see TY-ANCHOR-ETHOS.md

param(
    [Parameter(Mandatory=$true)] [string]$CommitHash,
    [Parameter(Mandatory=$true)] [string]$CloseNote
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$CH18         = "E:\TY-Ecosystem\ty-ai-governance\book\TY_BOOK_CHAPTER_18_GOVERNANCE_MAINTENANCE_RECORD.md"
$MFI          = "E:\TY-Ecosystem\ty-ai-governance\governance\ledger\MASTER_FIX_INDEX.md"
$SESSION_FILE = "E:\TY-Ecosystem\ty-ai-governance\tools\.ty-anchor-session.json"

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  TY-ANCHOR -- FIX-Close" -ForegroundColor Cyan
Write-Host "  $(Get-Date -Format 'yyyy-MM-dd HH:mm') PDT | San Diego" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# -- Guard: require open session file
if (-not (Test-Path $SESSION_FILE)) {
    Write-Host "  [FAIL] No session file found." -ForegroundColor Red
    Write-Host "         Run FIX-Open.ps1 before FIX-Close.ps1." -ForegroundColor Red
    exit 1
}
$session = Get-Content $SESSION_FILE | ConvertFrom-Json
if ($session.status -ne "OPEN") {
    Write-Host "  [FAIL] No open FIX found. Session status: $($session.status)" -ForegroundColor Red
    exit 1
}

$fixId     = $session.fixId
$entryId   = $session.entryId
$dest      = $session.destination
$scope     = $session.scope
$openTime  = $session.openTimestamp
$detectedClose = Get-Date -Format "yyyy-MM-dd HH:mm"
Write-Host "  Detected close time  : $detectedClose" -ForegroundColor Gray
Write-Host "  Press ENTER to accept or type correct San Diego time (HH:MM): " -NoNewline -ForegroundColor Yellow
$closeInput = Read-Host
if ($closeInput -eq "") {
    $closeTime = "$detectedClose PDT San Diego"
} else {
    $datepartClose = Get-Date -Format "yyyy-MM-dd"
    $closeTime = "$datepartClose $closeInput PDT San Diego"
}
Write-Host "  Close time confirmed : $closeTime" -ForegroundColor Green

Write-Host "  FIX ID         : $fixId"
Write-Host "  Entry          : $entryId"
Write-Host "  Destination    : $dest"
Write-Host "  Scope          : $scope"
Write-Host "  Opened         : $openTime"
Write-Host "  Closed         : $closeTime"
Write-Host "  Commit         : $CommitHash"
Write-Host ""

# -- Write Ch18 entry
$ch18Entry = @"


### $entryId | $fixId | $openTime -- $closeTime

**Destination:** $dest
**Commit:** $CommitHash
**Scope:** $scope

$CloseNote

**Status:** CLOSED
"@

$ch18Content = [System.IO.File]::ReadAllText($CH18, [System.Text.Encoding]::UTF8)
[System.IO.File]::WriteAllText($CH18, $ch18Content + $ch18Entry, [System.Text.Encoding]::UTF8)
$ch18Lines = [System.IO.File]::ReadAllLines($CH18).Count
Write-Host "  [OK] Ch18 entry written. Lines: $ch18Lines" -ForegroundColor Green

# -- Write MFI entry
$mfiEntry = @"


| $fixId | $openTime -- $closeTime | $dest | $scope. $CloseNote Commit $CommitHash. CLOSED |
"@

$mfiContent = [System.IO.File]::ReadAllText($MFI, [System.Text.Encoding]::UTF8)
[System.IO.File]::WriteAllText($MFI, $mfiContent + $mfiEntry, [System.Text.Encoding]::UTF8)
$mfiLines = [System.IO.File]::ReadAllLines($MFI).Count
Write-Host "  [OK] MFI entry written. Lines: $mfiLines" -ForegroundColor Green

# -- Ch18 scan gate
Write-Host ""
Write-Host "  Ch18 scan gate (last 3):" -ForegroundColor Yellow
$ch18Entries = Get-Content $CH18 | Select-String "### Entry|## ENTRY" | Select-Object -Last 3
foreach ($e in $ch18Entries) { Write-Host "    $($e.Line)" }

# -- Mark session closed
$session.status         = "CLOSED"
$session.closeTimestamp = $closeTime
$session.commitHash     = $CommitHash
[System.IO.File]::WriteAllText($SESSION_FILE, ($session | ConvertTo-Json -Depth 3), [System.Text.Encoding]::UTF8)

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  $fixId CLOSED -- R14 satisfied" -ForegroundColor Green
Write-Host "  Ch18: $ch18Lines lines | MFI: $mfiLines lines" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  NEXT STEP: commit Ch18 + MFI to ty-ai-governance then push." -ForegroundColor Yellow
Write-Host ""
Write-Host "  PASS TO: PowerShell terminal" -ForegroundColor Yellow
Write-Host "  cd E:\TY-Ecosystem\ty-ai-governance" -ForegroundColor Gray
Write-Host "  git add book/TY_BOOK_CHAPTER_18_GOVERNANCE_MAINTENANCE_RECORD.md" -ForegroundColor Gray
Write-Host "  git add governance/ledger/MASTER_FIX_INDEX.md" -ForegroundColor Gray
Write-Host "  git commit -m `"GOV: $fixId $entryId -- $scope -- Ch18 + MFI | $closeTime`"" -ForegroundColor Gray
Write-Host "  git push origin main" -ForegroundColor Gray
Write-Host ""