# TY-ANCHOR -- Verify.ps1
# Ad-hoc chain integrity check. Gap detection. Governance hash check.
# Usage: .\Verify.ps1
# Built: FIX-534 | 2026-05-19 | San Diego
# Updated: FIX-636 | 2026-05-25 | San Diego -- governance_hash check added
# Part of TY-ANCHOR v0.1 -- see TY-ANCHOR-ETHOS.md
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$CH18         = "E:\TY-Ecosystem\ty-ai-governance\book\TY_BOOK_CHAPTER_18_GOVERNANCE_MAINTENANCE_RECORD.md"
$MFI          = "E:\TY-Ecosystem\ty-ai-governance\governance\ledger\MASTER_FIX_INDEX.md"
$SESSION_FILE = "E:\TY-Ecosystem\ty-ai-governance\tools\.ty-anchor-session.json"
$ANCHOR       = "E:\TY-Ecosystem\ty-ai-governance\spec\GAL_HASH_ANCHOR.md"
$F1_PATH      = "E:\TY-Ecosystem\ty-ai-governance\governance\01_CORE_INVARIANTS.md"
$F2_PATH      = "E:\TY-Ecosystem\ty-ai-governance\governance\03_NON_WEAPONIZATION_GUARDRAIL.md"
$F3_PATH      = "E:\TY-Ecosystem\ty-ai-governance\spec\TY_GAL_SPEC_v0.1.md"
Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  TY-ANCHOR -- Verify" -ForegroundColor Cyan
Write-Host "  $(Get-Date -Format 'yyyy-MM-dd HH:mm') PDT | San Diego" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
# -- Session state
Write-Host "SESSION STATE:" -ForegroundColor Yellow
Write-Host "----------------------------------------------------------"
if (Test-Path $SESSION_FILE) {
    $session = Get-Content $SESSION_FILE | ConvertFrom-Json
    $color = if ($session.status -eq "OPEN") { "Yellow" } else { "Green" }
    Write-Host "  FIX       : $($session.fixId)" -ForegroundColor $color
    Write-Host "  Entry     : $($session.entryId)" -ForegroundColor $color
    Write-Host "  Status    : $($session.status)" -ForegroundColor $color
    Write-Host "  Opened    : $($session.openTimestamp)"
    if ($session.closeTimestamp) {
        Write-Host "  Closed    : $($session.closeTimestamp)"
        Write-Host "  Commit    : $($session.commitHash)"
    }
} else {
    Write-Host "  No session file found." -ForegroundColor Gray
}
Write-Host ""
# -- Ch18 entry chain (last 10) with gap detection
Write-Host "CH18 ENTRY CHAIN -- last 10:" -ForegroundColor Yellow
Write-Host "----------------------------------------------------------"
if (Test-Path $CH18) {
    $allEntries = Get-Content $CH18 | Select-String "### Entry|## ENTRY"
    $last10     = $allEntries | Select-Object -Last 10
    $nums       = @()
    foreach ($e in $last10) {
        $num = [int]([regex]::Match($e.Line, "Entry-(\d+)").Groups[1].Value)
        if ($num -gt 0) { $nums += $num }
        Write-Host "    $($e.Line)"
    }
    Write-Host ""
    $gaps = @()
    for ($i = 1; $i -lt $nums.Count; $i++) {
        if ($nums[$i] - $nums[$i-1] -gt 1) {
            $gaps += "Gap detected: Entry-$($nums[$i-1]) -> Entry-$($nums[$i])"
        }
    }
    if ($gaps.Count -eq 0) {
        Write-Host "  [PASS] No gaps in last 10 entries." -ForegroundColor Green
    } else {
        foreach ($g in $gaps) { Write-Host "  [WARN] $g" -ForegroundColor Yellow }
    }
    Write-Host "  Total entries : $($allEntries.Count)"
    Write-Host "  Total lines   : $([System.IO.File]::ReadAllLines($CH18).Count)"
} else {
    Write-Host "  [FAIL] Ch18 not found: $CH18" -ForegroundColor Red
}
Write-Host ""
# -- MFI last 5
Write-Host "MFI -- last 5 entries:" -ForegroundColor Yellow
Write-Host "----------------------------------------------------------"
if (Test-Path $MFI) {
    $mfiLines   = [System.IO.File]::ReadAllLines($MFI)
    $mfiEntries = ($mfiLines | Select-String "(^#{2,3} (FIX-|FLAG-)\d+|^\| (FIX-|FLAG-)\d+)") | Select-Object -Last 5
    foreach ($e in $mfiEntries) { Write-Host "    $($e.Line.Trim())" }
    Write-Host "  Total lines : $($mfiLines.Count)"
} else {
    Write-Host "  [FAIL] MFI not found: $MFI" -ForegroundColor Red
}
Write-Host ""
# -- Governance hash check (FIX-636)
Write-Host "GOVERNANCE HASH:" -ForegroundColor Yellow
Write-Host "----------------------------------------------------------"
try {
    $anchorLines = Get-Content $ANCHOR
    $storedHash = (($anchorLines | Where-Object { $_ -match '^governance_hash: [a-f0-9]{64}$' } | Select-Object -First 1) -replace 'governance_hash: ','').Trim()
    $f1 = [System.IO.File]::ReadAllText($F1_PATH, [System.Text.Encoding]::UTF8)
    $f2 = [System.IO.File]::ReadAllText($F2_PATH, [System.Text.Encoding]::UTF8)
    $f3 = [System.IO.File]::ReadAllText($F3_PATH, [System.Text.Encoding]::UTF8)
    $combined = $f1 + [char]10 + $f2 + [char]10 + $f3
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($combined)
    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    $computed = ([BitConverter]::ToString($sha256.ComputeHash($bytes)) -replace '-','').ToLower()
    if ($storedHash -eq $computed) {
        Write-Host "  [PASS] governance_hash current: $($storedHash.Substring(0,16))..." -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] governance_hash MISMATCH -- source files changed since anchor." -ForegroundColor Red
        Write-Host "         Stored  : $storedHash" -ForegroundColor Red
        Write-Host "         Computed: $computed" -ForegroundColor Red
        Write-Host "         Recompute and update GAL_HASH_ANCHOR.md + Jaya Runtime." -ForegroundColor Red
    }
} catch {
    Write-Host "  [WARN] Could not verify governance_hash: $_" -ForegroundColor Yellow
}
Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  Verify complete." -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""