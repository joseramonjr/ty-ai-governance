# TY-ANCHOR -- FIX-Open.ps1
# Opens a new FIX. Records start state. Enforces sequential ID.
# Usage: .\FIX-Open.ps1 -FixId FIX-NNN -Destination "dest" -Scope "scope"
# Built: FIX-534 | 2026-05-19 | San Diego
# Part of TY-ANCHOR v0.1 -- see TY-ANCHOR-ETHOS.md

param(
    [Parameter(Mandatory=$true)] [string]$FixId,
    [Parameter(Mandatory=$true)] [string]$Destination,
    [Parameter(Mandatory=$true)] [string]$Scope
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$MFI          = "E:\TY-Ecosystem\ty-ai-governance\governance\ledger\MASTER_FIX_INDEX.md"
$SESSION_FILE = "E:\TY-Ecosystem\ty-ai-governance\tools\.ty-anchor-session.json"

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  TY-ANCHOR -- FIX-Open" -ForegroundColor Cyan
Write-Host "  $(Get-Date -Format 'yyyy-MM-dd HH:mm') PDT | San Diego" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# -- Guard: reject if a FIX is already open
if (Test-Path $SESSION_FILE) {
    $existing = Get-Content $SESSION_FILE | ConvertFrom-Json
    if ($existing.status -eq "OPEN") {
        Write-Host "  [FAIL] $($existing.fixId) is already OPEN." -ForegroundColor Red
        Write-Host "         Run FIX-Close.ps1 before opening a new FIX." -ForegroundColor Red
        exit 1
    }
}

# -- Verify MFI exists
if (-not (Test-Path $MFI)) {
    Write-Host "  [FAIL] MFI not found: $MFI" -ForegroundColor Red
    exit 1
}

# -- Get last MFI entry for reference
$mfiLines  = [System.IO.File]::ReadAllLines($MFI)
$lastMFI   = ($mfiLines | Select-String "(^#{2,3} (FIX-|FLAG-|SS-FIX-)\d+|^\| (FIX-|FLAG-|SS-FIX-)\d+)" | Select-Object -Last 1).Line.Trim()

# -- Get last Entry number
$lastEntryMatch = ($mfiLines | Select-String "Entry-(\d+)" | Select-Object -Last 1)
$lastEntryNum   = 0
if ($lastEntryMatch) {
    $lastEntryNum = [int]([regex]::Match($lastEntryMatch.Line, "Entry-(\d+)").Groups[1].Value)
}
$nextEntryNum = $lastEntryNum + 1
$nextEntry    = "Entry-$nextEntryNum"

# -- Timestamp: show detected time, prompt for confirmation
$detectedTime = Get-Date -Format "yyyy-MM-dd HH:mm"
Write-Host "  Detected system time : $detectedTime" -ForegroundColor Gray
Write-Host "  Press ENTER to accept or type correct San Diego time (HH:MM): " -NoNewline -ForegroundColor Yellow
$userInput = Read-Host
if ($userInput -eq "") {
    $timestamp = "$detectedTime PDT San Diego"
} else {
    $datepart = Get-Date -Format "yyyy-MM-dd"
    $timestamp = "$datepart $userInput PDT San Diego"
}
Write-Host "  Timestamp confirmed  : $timestamp" -ForegroundColor Green

# -- Display
Write-Host "  MFI last entry : $lastMFI"
Write-Host "  FIX ID         : $FixId"
Write-Host "  Entry          : $nextEntry"
Write-Host "  Destination    : $Destination"
Write-Host "  Scope          : $Scope"
Write-Host "  Opened         : $timestamp"
Write-Host ""

# -- Write session file
$session = [ordered]@{
    fixId          = $FixId
    entryId        = $nextEntry
    entryNum       = $nextEntryNum
    destination    = $Destination
    scope          = $Scope
    openTimestamp  = $timestamp
    closeTimestamp = ""
    commitHash     = ""
    status         = "OPEN"
}
$sessionJson = $session | ConvertTo-Json -Depth 3
[System.IO.File]::WriteAllText($SESSION_FILE, $sessionJson, [System.Text.Encoding]::UTF8)

Write-Host "  [OK] Session file written: .ty-anchor-session.json" -ForegroundColor Green
Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  $FixId OPEN" -ForegroundColor Green
Write-Host "  Entry: $nextEntry | Destination: $Destination" -ForegroundColor Green
Write-Host "  Opened: $timestamp" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""