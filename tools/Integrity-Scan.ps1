# TY-ANCHOR -- Integrity-Scan.ps1
# Governance integrity verification. Checks governance_hash currency,
# source file commit consistency, and key record files.
# Usage: powershell -ExecutionPolicy Bypass -File "...\tools\Integrity-Scan.ps1"
# Built: FIX-636 | 2026-05-25 | San Diego
# Part of TY-ANCHOR v0.1 -- see TY-ANCHOR-ETHOS.md
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$BASE     = "E:\TY-Ecosystem\ty-ai-governance"
$ANCHOR   = "$BASE\spec\GAL_HASH_ANCHOR.md"
$F1_PATH  = "$BASE\governance\01_CORE_INVARIANTS.md"
$F2_PATH  = "$BASE\governance\03_NON_WEAPONIZATION_GUARDRAIL.md"
$F3_PATH  = "$BASE\spec\TY_GAL_SPEC_v0.1.md"
$CH26     = "$BASE\book\TY_BOOK_CHAPTER_26_THE_TY_AI_OS_VOCABULARY.md"
$SPEC_REG = "$BASE\governance\SPEC_IMPLEMENTATION_REGISTRY.md"
$CODEX    = "$BASE\spec\TY_GUARDIAN_CODEX_v0.1.md"
$failures = 0
Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  TY-ANCHOR -- Integrity-Scan" -ForegroundColor Cyan
Write-Host "  $(Get-Date -Format 'yyyy-MM-dd HH:mm') PDT | San Diego" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
# -- CHECK 1: governance_hash currency
Write-Host "CHECK 1: governance_hash currency" -ForegroundColor Yellow
Write-Host "----------------------------------------------------------"
try {
    $anchorLines = Get-Content $ANCHOR
    $storedHashLine = ($anchorLines | Where-Object { $_ -match '^governance_hash: [a-f0-9]{64}$' } | Select-Object -First 1)
    $storedHash = $storedHashLine -replace 'governance_hash: ', ''
    $f1 = [System.IO.File]::ReadAllText($F1_PATH, [System.Text.Encoding]::UTF8)
    $f2 = [System.IO.File]::ReadAllText($F2_PATH, [System.Text.Encoding]::UTF8)
    $f3 = [System.IO.File]::ReadAllText($F3_PATH, [System.Text.Encoding]::UTF8)
    $combined = $f1 + "`n" + $f2 + "`n" + $f3
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($combined)
    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    $computedHash = ([BitConverter]::ToString($sha256.ComputeHash($bytes)) -replace '-','').ToLower()
    Write-Host "  Stored  : $storedHash" -ForegroundColor Gray
    Write-Host "  Computed: $computedHash" -ForegroundColor Gray
    if ($storedHash -eq $computedHash) {
        Write-Host "  [PASS] governance_hash is current." -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] governance_hash MISMATCH -- source files changed since anchor." -ForegroundColor Red
        Write-Host "         Recompute hash and update GAL_HASH_ANCHOR.md + Jaya Runtime." -ForegroundColor Red
        $failures++
    }
} catch {
    Write-Host "  [FAIL] Error: $_" -ForegroundColor Red
    $failures++
}
Write-Host ""
# -- CHECK 2: Source file commit consistency
Write-Host "CHECK 2: Source file commit currency" -ForegroundColor Yellow
Write-Host "----------------------------------------------------------"
try {
    Push-Location $BASE
    $anchorLines = Get-Content $ANCHOR
    $commitLines = $anchorLines | Where-Object { $_ -match '^\s+Commit: [a-f0-9]{7}' -and $_ -notmatch 'tag:' }
    $storedF1 = if ($commitLines.Count -ge 1) { ($commitLines[0] -replace '.*Commit: ','').Trim() } else { 'unknown' }
    $storedF2 = if ($commitLines.Count -ge 2) { ($commitLines[1] -replace '.*Commit: ','').Trim() } else { 'unknown' }
    $actualF1 = (git log --oneline -1 -- "governance/01_CORE_INVARIANTS.md" 2>&1).ToString().Split(' ')[0]
    $actualF2 = (git log --oneline -1 -- "governance/03_NON_WEAPONIZATION_GUARDRAIL.md" 2>&1).ToString().Split(' ')[0]
    $actualF3 = (git log --oneline -1 -- "spec/TY_GAL_SPEC_v0.1.md" 2>&1).ToString().Split(' ')[0]
    $f1ok = $actualF1 -eq $storedF1
    $f2ok = $actualF2 -eq $storedF2
    $f1color = if ($f1ok) {"Green"} else {"Red"}
    $f2color = if ($f2ok) {"Green"} else {"Red"}
    Write-Host "  01_CORE_INVARIANTS        anchor:$storedF1  current:$actualF1  $(if($f1ok){'[PASS]'}else{'[FAIL] MODIFIED'})" -ForegroundColor $f1color
    Write-Host "  03_NON_WEAPONIZATION      anchor:$storedF2  current:$actualF2  $(if($f2ok){'[PASS]'}else{'[FAIL] MODIFIED'})" -ForegroundColor $f2color
    Write-Host "  TY_GAL_SPEC_v0.1          current:$actualF3" -ForegroundColor Gray
    if (-not $f1ok -or -not $f2ok) {
        Write-Host "  [FAIL] Source file modified since anchor -- recompute governance_hash." -ForegroundColor Red
        $failures++
    } else {
        Write-Host "  [PASS] Source file commits match anchor record." -ForegroundColor Green
    }
    Pop-Location
} catch {
    Write-Host "  [FAIL] Error: $_" -ForegroundColor Red
    $failures++
}
Write-Host ""
# -- CHECK 3: Ch26 term count header present
Write-Host "CHECK 3: Ch26 term count header" -ForegroundColor Yellow
Write-Host "----------------------------------------------------------"
try {
    $headerLine = (Get-Content $CH26 | Select-String "Current Term Count" | Select-Object -First 1).Line
    $headerNum = [int]([regex]::Match($headerLine, 'Count:\*\*\s+(\d+)').Groups[1].Value)
    $ch26Lines = [System.IO.File]::ReadAllLines($CH26).Count
    Write-Host "  Header: $headerLine" -ForegroundColor Gray
    Write-Host "  Total Ch26 lines: $ch26Lines" -ForegroundColor Gray
    if ($headerNum -gt 0) {
        Write-Host "  [PASS] Term count header present: $headerNum terms." -ForegroundColor Green
    } else {
        Write-Host "  [WARN] Could not parse term count." -ForegroundColor Yellow
    }
} catch {
    Write-Host "  [FAIL] Error: $_" -ForegroundColor Red
    $failures++
}
Write-Host ""
# -- CHECK 4: Key governance files present
Write-Host "CHECK 4: Key governance files present" -ForegroundColor Yellow
Write-Host "----------------------------------------------------------"
$keyFiles = @(
    @{ path=$ANCHOR;   name="GAL_HASH_ANCHOR.md" },
    @{ path=$CH26;     name="Ch26 Vocabulary" },
    @{ path=$SPEC_REG; name="SPEC_IMPLEMENTATION_REGISTRY.md" },
    @{ path=$CODEX;    name="TY_GUARDIAN_CODEX_v0.1.md" },
    @{ path=$F1_PATH;  name="01_CORE_INVARIANTS.md" },
    @{ path=$F2_PATH;  name="03_NON_WEAPONIZATION_GUARDRAIL.md" },
    @{ path=$F3_PATH;  name="TY_GAL_SPEC_v0.1.md" }
)
foreach ($kf in $keyFiles) {
    if (Test-Path $kf.path) {
        Write-Host "  [PASS] $($kf.name)" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] MISSING: $($kf.name)" -ForegroundColor Red
        $failures++
    }
}
Write-Host ""
# -- VERDICT
Write-Host "============================================================" -ForegroundColor Cyan
if ($failures -eq 0) {
    Write-Host "  INTEGRITY-SCAN: PASS" -ForegroundColor Green
    Write-Host "  All governance integrity checks passed." -ForegroundColor Green
} else {
    Write-Host "  INTEGRITY-SCAN: FAIL -- $failures check(s) failed." -ForegroundColor Red
    Write-Host "  Resolve all failures before sealing any phase." -ForegroundColor Red
}
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""