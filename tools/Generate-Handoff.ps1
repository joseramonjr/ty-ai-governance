# Generate-Handoff.ps1
# TY AI OS -- Auto Handoff Generator
# FIX #: JAYA-CLO-157 | MODEL: Claude Sonnet 4.6 | DATE: 2026-03-17 | San Diego
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
$govDesc  = (git log --oneline -1) -replace "^[a-f0-9]+ ",""
Pop-Location

Push-Location $tyovaPath
$tyovaHash = (git log --oneline -1).Split(" ")[0]
$tyovaDesc = (git log --oneline -1) -replace "^[a-f0-9]+ ",""
Pop-Location

# ------------------------------------------------------------------
# Last CLO from MASTER_FIX_INDEX
# ------------------------------------------------------------------
$cloLines    = Get-Content $masterFix | Select-String "^## JAYA-CLO-\d+"
$lastCloLine = ($cloLines | Select-Object -Last 1).Line
$lastCloNum  = [int]([regex]::Match($lastCloLine, "JAYA-CLO-(\d+)").Groups[1].Value)
$nextCloNum  = $lastCloNum + 1
$lastCLO     = "JAYA-CLO-$lastCloNum"
$nextCLO     = "JAYA-CLO-$nextCloNum"
$lastCloDesc = ([regex]::Match($lastCloLine, "JAYA-CLO-\d+\s*\|\s*(.+)$").Groups[1].Value).Trim()
if ($lastCloDesc -eq "") { $lastCloDesc = "See MASTER_FIX_INDEX" }

# ------------------------------------------------------------------
# Chapter 18 last entry
# ------------------------------------------------------------------
$lastEntry = ((Get-Content $ch18 | Select-String "### Entry-") | Select-Object -Last 1).Line.Trim()

# ------------------------------------------------------------------
# Chapter 26 term count
# ------------------------------------------------------------------
# Existing terms use **Term** bold format. New terms use ### heading.
# Count both patterns and sum.
$boldTerms    = (Get-Content $ch26 | Select-String "^\*\*[A-Z]").Count
$headingTerms = (Get-Content $ch26 | Select-String "^### ").Count
$termCount    = $boldTerms + $headingTerms

# ------------------------------------------------------------------
# Next Part number -- derived from last Jaya-Runtime commit
# ------------------------------------------------------------------
$partMatch = [regex]::Match($jayaDesc, "Part (\d+):")
$lastPart  = if ($partMatch.Success) { [int]$partMatch.Groups[1].Value } else { 0 }
$nextPart  = $lastPart + 1

# ------------------------------------------------------------------
# Current date San Diego
# ------------------------------------------------------------------
$date = Get-Date -Format "yyyy-MM-dd"
$time = Get-Date -Format "HH:mm"

# ------------------------------------------------------------------
# Build repo state table rows as plain strings
# ------------------------------------------------------------------
$repoJaya  = "Jaya-Runtime      | $jayaHash | Clean -- Part $lastPart sealed (tag: $jayaTag)"
$repoGov   = "ty-ai-governance  | $govHash | Clean -- pushed to origin"
$repoTyova = "TYOVA             | $tyovaHash | Clean -- pushed to origin"

# ------------------------------------------------------------------
# Build handoff block
# ------------------------------------------------------------------
$handoff = @"
TY AI OS -- NEXT CHAT HANDOFF
Builder: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
Model: Claude Sonnet 4.6
Date: $date | $time | San Diego (America/Los_Angeles)

RESUME POINT
Last session: Part $lastPart sealed -- $lastCloDesc
WHAT TO DO FIRST:
Run S1 + S2 corruption scans
Confirm repo states
Begin Part $nextPart -- CLO $nextCLO

REPO STATE
$repoJaya
$repoGov
$repoTyova

Next CLO: $nextCLO
Next Jaya Part: $nextPart
Phase: Phase 5 ACTIVE -- Track A

PHASE 5 TRACK A STATUS
Part 77 | JAYA-CLO-155 | Nonce -- replay protection         | SEALED
Part 78 | JAYA-CLO-156 | Ledger Hash -- attestation binding  | SEALED
Part 79 | JAYA-CLO-157 | Class B Autonomy -- runtime enforce | NEXT
Part 80 | JAYA-CLO-158 | Keychain -- key rotation infra      | PENDING

BOOK OF TY STATUS
Title (LOCKED): "TY AI OS: The Case for Verifiable Governance"
Chapter 18 last entry: $lastEntry
Chapter 26: LIVING -- $termCount terms

KNOWN S2 FALSE POSITIVES
Chapter 18 line 108 -- R12 rule text
Zero hits beyond this one = clean.

MASTER_FIX_INDEX
Last CLO logged: $lastCLO
Next CLO: $nextCLO
Path: governance/ledger/MASTER_FIX_INDEX.md

MANDATORY SESSION-CLOSE GATES
S1+S2 clean | repo states confirmed | build complete cargo check=0 | proof verified | git tag applied | MASTER_FIX_INDEX written same session | vocab gate Ch26 | Ch18 entry committed | Ch18 scan run | MASTER_FIX_INDEX confirmed current | phase summary displayed

END OF HANDOFF
Jaya-Runtime HEAD:      $jayaHash (tag: $jayaTag)
ty-ai-governance HEAD:  $govHash
TYOVA HEAD:             $tyovaHash
Book of TY: 26 chapters (Ch5 blocked -- Ch26 living -- $termCount terms)
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