# ===========================================================
#  TY AI OS -- Deployment Verification Script
#  FLAG-155 Layer 3 -- Infrastructure Survivability
#  FIX-826 | Claude Sonnet 4.6 | 2026-06-18 | San Diego
# ===========================================================
#  Confirms all three FLAG-155 layers are operational:
#    Layer 1 -- Jaya INFRASTRUCTURE_FAULT event capability
#    Layer 2 -- TYOVA guided repair page reachable
#    Layer 3 -- This script (self-confirming)
#
#  Run after any deployment that touches:
#    - Jaya-Runtime (system_health.rs or lib.rs)
#    - TYOVA (InfrastructureRepairPage.tsx or App.tsx)
#    - ty-ai-governance policy or tooling
# ===========================================================

param(
    [string]$TYOVABase = "https://testing.tyova.ai"
)

$ErrorActionPreference = "SilentlyContinue"
$PassCount = 0
$FailCount = 0

function Write-Gate {
    param([string]$Label, [bool]$Passed, [string]$Detail)
    $status = if ($Passed) { "[PASS]" } else { "[FAIL]" }
    $color  = if ($Passed) { "Green" } else { "Red" }
    Write-Host "  $status $Label" -ForegroundColor $color
    if ($Detail) { Write-Host "         $Detail" -ForegroundColor DarkGray }
    if ($Passed) { $script:PassCount++ } else { $script:FailCount++ }
}

Write-Host ""
Write-Host "============================================================"
Write-Host "  TY AI OS -- Deployment Verification"
Write-Host "  FLAG-155 Layer 3 -- Infrastructure Survivability"
Write-Host "  $(Get-Date -Format 'yyyy-MM-dd HH:mm') San Diego"
Write-Host "============================================================"

Write-Host ""
Write-Host "GATE 1: Layer 1 -- Jaya INFRASTRUCTURE_FAULT capability"
Write-Host "----------------------------------------------------------"

$systemHealthPath = "E:\TY-Ecosystem\Jaya-Runtime\src-tauri\src\system_health.rs"
if (Test-Path $systemHealthPath) {
    $content = Get-Content $systemHealthPath -Raw
    Write-Gate "system_health.rs exists" $true $systemHealthPath
    Write-Gate "write_infrastructure_fault function present" ($content -match "pub fn write_infrastructure_fault") ""
    Write-Gate "Fault codes defined" ($content -match "FAULT_LEDGER_WRITE_FAILED") ""
    Write-Gate "Supabase write wired" ($content -match "write_governance_event_sync") ""
    Write-Gate "Ledger write wired" ($content -match "log_operation") ""
} else {
    Write-Gate "system_health.rs exists" $false "Not found at $systemHealthPath"
    Write-Gate "write_infrastructure_fault function present" $false "Cannot check -- file missing"
    Write-Gate "Fault codes defined" $false "Cannot check -- file missing"
    Write-Gate "Supabase write wired" $false "Cannot check -- file missing"
    Write-Gate "Ledger write wired" $false "Cannot check -- file missing"
}

$libPath = "E:\TY-Ecosystem\Jaya-Runtime\src-tauri\src\lib.rs"
if (Test-Path $libPath) {
    $libContent = Get-Content $libPath -Raw
    Write-Gate "lib.rs wired to write_infrastructure_fault" ($libContent -match "write_infrastructure_fault") ""
} else {
    Write-Gate "lib.rs wired to write_infrastructure_fault" $false "lib.rs not found"
}

Write-Host ""
Write-Host "GATE 2: Layer 2 -- TYOVA guided repair page"
Write-Host "----------------------------------------------------------"

$repairPagePath = "E:\TY-Ecosystem\TYOVA\src\pages\InfrastructureRepairPage.tsx"
if (Test-Path $repairPagePath) {
    $pageContent = Get-Content $repairPagePath -Raw
    Write-Gate "InfrastructureRepairPage.tsx exists" $true ""
    Write-Gate "Queries INFRASTRUCTURE_FAULT events" ($pageContent -match "INFRASTRUCTURE_FAULT") ""
    Write-Gate "Fault codes with repair steps present" ($pageContent -match "LEDGER_WRITE_FAILED") ""
} else {
    Write-Gate "InfrastructureRepairPage.tsx exists" $false "Not found at $repairPagePath"
    Write-Gate "Queries INFRASTRUCTURE_FAULT events" $false "Cannot check -- file missing"
    Write-Gate "Fault codes with repair steps present" $false "Cannot check -- file missing"
}

$appPath = "E:\TY-Ecosystem\TYOVA\src\App.tsx"
if (Test-Path $appPath) {
    $appContent = Get-Content $appPath -Raw
    Write-Gate "Route /infrastructure-repair registered in App.tsx" ($appContent -match "infrastructure-repair") ""
} else {
    Write-Gate "Route /infrastructure-repair registered in App.tsx" $false "App.tsx not found"
}

try {
    $response = Invoke-WebRequest -Uri "$TYOVABase/infrastructure-repair" -TimeoutSec 10 -UseBasicParsing
    Write-Gate "TYOVA repair page HTTP reachable" ($response.StatusCode -eq 200) "$TYOVABase/infrastructure-repair -- HTTP $($response.StatusCode)"
} catch {
    Write-Gate "TYOVA repair page HTTP reachable" $false "$TYOVABase/infrastructure-repair -- $($_.Exception.Message)"
}

Write-Host ""
Write-Host "GATE 3: Layer 3 -- Deployment verification script"
Write-Host "----------------------------------------------------------"

$scriptPath = "E:\TY-Ecosystem\ty-ai-governance\tools\Verify-Deployment.ps1"
Write-Gate "Verify-Deployment.ps1 present in tools directory" (Test-Path $scriptPath) $scriptPath

Write-Host ""
Write-Host "GATE 4: Jaya-Runtime build state"
Write-Host "----------------------------------------------------------"

Write-Gate "Jaya-Runtime target directory exists (built at least once)" (Test-Path "E:\TY-Ecosystem\Jaya-Runtime\src-tauri\target") ""

Write-Host ""
Write-Host "GATE 5: Repo states"
Write-Host "----------------------------------------------------------"

foreach ($repo in @("ty-ai-governance", "TYOVA", "Jaya-Runtime")) {
    $repoPath = "E:\TY-Ecosystem\$repo"
    if (Test-Path $repoPath) {
        $gitStatus = & git -C $repoPath status --porcelain 2>$null
        $head = & git -C $repoPath rev-parse --short HEAD 2>$null
        Write-Gate "$repo clean" ([string]::IsNullOrWhiteSpace($gitStatus)) "HEAD: $head"
    } else {
        Write-Gate "$repo exists" $false "Not found at $repoPath"
    }
}

Write-Host ""
Write-Host "============================================================"
if ($FailCount -eq 0) {
    Write-Host "  DEPLOYMENT VERIFIED: PASS" -ForegroundColor Green
    Write-Host "  All $PassCount gates passed. FLAG-155 layers operational." -ForegroundColor Green
} else {
    Write-Host "  DEPLOYMENT VERIFIED: FAIL" -ForegroundColor Red
    Write-Host "  $FailCount gate(s) failed. Navigate to $TYOVABase/infrastructure-repair for repair guidance." -ForegroundColor Red
}
Write-Host "  Passed: $PassCount | Failed: $FailCount"
Write-Host "============================================================"
Write-Host ""
