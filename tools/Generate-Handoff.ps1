# Generate-Handoff.ps1
# TY AI OS -- Auto Handoff Generator
# FIX-121.11 | JAYA-CLO-243 | Claude Sonnet 4.6 | 2026-04-03 | San Diego
#
# Reads live data from all repos and generates a verified handoff block.
# Output is printed to terminal AND auto-copied to clipboard.
# Run at session close. Paste output at top of next chat.
#
# Usage: .\Generate-Handoff.ps1
$ErrorActionPreference = "Stop"
# ------------------------------------------------------------------
# Paths
# ------------------------------------------------------------------
$jayaPath  = "E:\TY-Ecosystem\Jaya-Runtime"
$govPath   = "E:\TY-Ecosystem\ty-ai-governance"
$tyovaPath = "E:\TY-Ecosystem\TYOVA"
$lukePath  = "E:\TY-Ecosystem\luke-ai"
$jaymePath = "E:\TY-Ecosystem\jayme-ai"
$masterFix = "$govPath\governance\ledger\MASTER_FIX_INDEX.md"
$ch18      = "$govPath\book\TY_BOOK_CHAPTER_18_GOVERNANCE_MAINTENANCE_RECORD.md"
$ch26      = "$govPath\book\TY_BOOK_CHAPTER_26_THE_TY_AI_OS_VOCABULARY.md"
# ------------------------------------------------------------------
# Git HEADs
# ------------------------------------------------------------------
Push-Location $jayaPath
$jayaHash = (git log --oneline -1).Split(" ")[0]
$jayaTag  = (git describe --tags --abbrev=0 2>$null)
$jayaDesc = (git log --oneline -1) -replace "^[a-f0-9]+ ",""
Pop-Location
Push-Location $govPath
$govHash  = (git log --oneline -1).Split(" ")[0]
Pop-Location
Push-Location $tyovaPath
$tyovaHash = (git log --oneline -1).Split(" ")[0]
Pop-Location
Push-Location $lukePath
$lukeHash = (git log --oneline -1).Split(" ")[0]
Pop-Location
Push-Location $jaymePath
$jaymeHash = (git log --oneline -1).Split(" ")[0]
Pop-Location
# ------------------------------------------------------------------
# Last CLO from MASTER_FIX_INDEX
# Reads lines starting with "CLO: JAYA-CLO-" and takes the last one
# ------------------------------------------------------------------
$cloLines    = Get-Content $masterFix | Select-String "CLO: JAYA-CLO-\d+"
$lastCloLine = ($cloLines | Select-Object -Last 1).Line
$lastCloNum  = [int]([regex]::Match($lastCloLine, "JAYA-CLO-(\d+)").Groups[1].Value)
$nextCloNum  = $lastCloNum + 1
$lastCLO     = "JAYA-CLO-$lastCloNum"
$nextCLO     = "JAYA-CLO-$nextCloNum"
# ------------------------------------------------------------------
# Last FIX ID from MASTER_FIX_INDEX
# Reads lines starting with "### FIX-" and takes the last one
# ------------------------------------------------------------------
$fixLines   = Get-Content $masterFix | Select-String "^### FIX-\d+"
$lastFixLine = ($fixLines | Select-Object -Last 1).Line
$lastFix    = [regex]::Match($lastFixLine, "### (FIX-[\d\.]+)").Groups[1].Value
# ------------------------------------------------------------------
# Next Part number -- derived from MASTER_FIX_INDEX last FIX entry
# FIX-121.10 -> part 121 -> next part 122
# ------------------------------------------------------------------
$partMatch = [regex]::Match($lastFixLine, "FIX-(\d+)\.")
$lastPart  = if ($partMatch.Success) { [int]$partMatch.Groups[1].Value } else { 0 }
$nextPart  = $lastPart + 1
# ------------------------------------------------------------------
# Chapter 18 last entry
# ------------------------------------------------------------------
$lastEntry = ((Get-Content $ch18 | Select-String "### Entry-") | Select-Object -Last 1).Line.Trim()
# ------------------------------------------------------------------
# Chapter 26 term count
# ------------------------------------------------------------------
$termCountLine = (Get-Content $ch26 | Select-String "^\*\*Current Term Count").Line
$termCount = [regex]::Match($termCountLine, "(\d+)").Groups[1].Value
# ------------------------------------------------------------------
# Current date San Diego
# ------------------------------------------------------------------
$sdTime = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId((Get-Date), 'Pacific Standard Time')
$date = $sdTime.ToString("yyyy-MM-dd")
$time = $sdTime.ToString("HH:mm")
# ------------------------------------------------------------------
# Build handoff block
# ------------------------------------------------------------------
$handoff = @"
TY AI OS -- NEXT CHAT HANDOFF
Builder: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
Model: Claude Sonnet 4.6
Date: $date | $time | San Diego (America/Los_Angeles)

REPO STATE
Jaya-Runtime      | $jayaHash | $jayaTag
ty-ai-governance  | $govHash
TYOVA             | $tyovaHash
luke-ai           | $lukeHash
jayme-ai          | $jaymeHash

GOVERNANCE STATE
Last CLO:          $lastCLO
Next CLO:          $nextCLO
Last FIX:          $lastFix
Last Ch18 Entry:   $lastEntry
Ch26 Terms:        $termCount
Active Phase:      Phase 7 -- The Delivery
Next Part:         $nextPart

MANDATORY SESSION-OPEN GATES
Run S1+S2 corruption scans
Confirm all repo states match above HEADs
Confirm MASTER_FIX_INDEX last entry = $lastFix
Confirm Ch18 last entry = $lastEntry

S1 SCAN
powershell
Run S1 scan -- see MASTER_FIX_INDEX for UTF8 corruption pattern
S2 SCAN
powershell
Get-ChildItem -Recurse -Filter "*.tsx" | Select-String "font-mono" | Select-Object Path, LineNumber, Line
Ch18 CONFIRM
powershell
Get-Content "E:\TY-Ecosystem\ty-ai-governance\book\TY_BOOK_CHAPTER_18_GOVERNANCE_MAINTENANCE_RECORD.md" | Select-String "### Entry" | Select-Object -Last 3 | Select-Object Line
MASTER_FIX_INDEX CONFIRM
powershell
Get-Content "E:\TY-Ecosystem\ty-ai-governance\governance\ledger\MASTER_FIX_INDEX.md" | Select-String "FIX-" | Select-Object -Last 3 | Select-Object Line
"@
# ------------------------------------------------------------------
# Output
# ------------------------------------------------------------------
Write-Host ""
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host " TY AI OS -- HANDOFF BLOCK GENERATED" -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host $handoff
Write-Host ""
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host " COPIED TO CLIPBOARD" -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Cyan
$handoff | Set-Clipboard
