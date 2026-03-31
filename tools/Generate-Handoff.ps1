# Generate-Handoff.ps1
# TY AI OS -- Auto Handoff Generator
# FIX #: JAYA-CLO-213 | MODEL: Claude Sonnet 4.6 | DATE: 2026-03-31 | San Diego
#
# Reads live data from all three repos and generates a verified handoff block.
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
# ------------------------------------------------------------------
# Last CLO from MASTER_FIX_INDEX
# Pattern matches lines like: CLO: JAYA-CLO-212
# ------------------------------------------------------------------
$cloLines   = Get-Content $masterFix | Select-String "^CLO: JAYA-CLO-\d+"
$lastCloLine = ($cloLines | Select-Object -Last 1).Line
$lastCloNum  = [int]([regex]::Match($lastCloLine, "JAYA-CLO-(\d+)").Groups[1].Value)
$nextCloNum  = $lastCloNum + 1
$lastCLO     = "JAYA-CLO-$lastCloNum"
$nextCLO     = "JAYA-CLO-$nextCloNum"
$lastCloDesc = "See MASTER_FIX_INDEX"
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
# Next Part number -- derived from last Jaya-Runtime commit
# ------------------------------------------------------------------
$partMatch = [regex]::Match($jayaDesc, "Part (\d+)")
$lastPart  = if ($partMatch.Success) { [int]$partMatch.Groups[1].Value } else { 0 }
$nextPart  = $lastPart + 1
# ------------------------------------------------------------------
# Current date San Diego
# ------------------------------------------------------------------
$sdTime = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId((Get-Date), 'Pacific Standard Time')
$date = $sdTime.ToString("yyyy-MM-dd")
$time = $sdTime.ToString("HH:mm")
# ------------------------------------------------------------------
# Build repo state table rows
# ------------------------------------------------------------------
$repoJaya  = "Jaya-Runtime      | $jayaHash | $jayaTag"
$repoGov   = "ty-ai-governance  | $govHash"
$repoTyova = "TYOVA             | $tyovaHash"
# ------------------------------------------------------------------
# Build handoff block
# ------------------------------------------------------------------
$handoff = @"
TY AI OS -- NEXT CHAT HANDOFF
Builder: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
Model: Claude Sonnet 4.6
Date: $date | $time | San Diego (America/Los_Angeles)

REPO STATE
$repoJaya
$repoGov
$repoTyova

GOVERNANCE STATE
Last CLO: $lastCLO
Next CLO: $nextCLO
Last Ch18 Entry: $lastEntry
Chapter 26: LIVING -- $termCount terms
Last FIX: See MASTER_FIX_INDEX

NEXT PART: $nextPart

BOOK OF TY STATUS
Title (LOCKED): TY AI OS: The Case for Verifiable Governance
Chapter 18 last entry: $lastEntry
Chapter 26: LIVING -- $termCount terms

MANDATORY SESSION-CLOSE GATES
S1+S2 clean | repo states confirmed | cargo check=0 | proof verified | git tag applied | MASTER_FIX_INDEX written same session | vocab gate Ch26 | Ch18 entry committed | Ch18 scan run | MASTER_FIX_INDEX confirmed current | phase summary displayed

END OF HANDOFF
Jaya-Runtime HEAD:     $jayaHash (tag: $jayaTag)
ty-ai-governance HEAD: $govHash
TYOVA HEAD:            $tyovaHash
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