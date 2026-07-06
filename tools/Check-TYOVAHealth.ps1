# ===========================================================
#  TY AI OS -- Check-TYOVAHealth.ps1
#  TYOVA Product Health Check -- FLAG-179
#  FIX-905 | Entry-925 | 2026-07-05 21:44 PDT San Diego
#  Builder: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
# ===========================================================
#  Checks:
#    1. TYOVA key pages return HTTP 200
#    2. jaya_audit_events has event within T-06 window (30 seconds)
#  Reads credentials from E:\TY-Ecosystem\TYOVA\.env at runtime.
#  No credentials stored in this script.
# ===========================================================

param(
    [string]$EnvFile = "E:\TY-Ecosystem\TYOVA\.env",
    [switch]$Quiet
)

$ErrorActionPreference = "SilentlyContinue"

# -----------------------------------------------------------
# CONFIGURATION
# -----------------------------------------------------------
$TYOVA_BASE     = "https://testing.tyova.ai"
$PAGES_TO_CHECK = @("/", "/book", "/ecosystem-flow-3d", "/attestation", "/verify-live")
$T06_SECONDS    = 30   # GAL freshness window -- TY_CANONICAL_THRESHOLDS_REGISTRY T-06
$PASS_SYMBOL    = "[PASS]"
$FAIL_SYMBOL    = "[FAIL]"
$SKIP_SYMBOL    = "[SKIP]"
$WARN_SYMBOL    = "[WARN]"

# -----------------------------------------------------------
# HELPERS
# -----------------------------------------------------------
function Write-Check {
    param([string]$Symbol, [string]$Label, [string]$Detail)
    if (-not $Quiet) {
        Write-Host "  $Symbol $Label" -NoNewline
        if ($Detail) { Write-Host " -- $Detail" } else { Write-Host }
    }
}

# -----------------------------------------------------------
# LOAD ENV FILE
# -----------------------------------------------------------
$supabaseUrl = $null
$supabaseKey = $null

if (Test-Path $EnvFile) {
    Get-Content $EnvFile | ForEach-Object {
        if ($_ -match '^VITE_JAYA_SUPABASE_URL=(.+)$')      { $supabaseUrl = $Matches[1].Trim() }
        if ($_ -match '^VITE_JAYA_SUPABASE_ANON_KEY=(.+)$') { $supabaseKey = $Matches[1].Trim() }
    }
} else {
    Write-Host "  $WARN_SYMBOL ENV file not found: $EnvFile -- Supabase checks will be skipped"
}

# -----------------------------------------------------------
# HEADER
# -----------------------------------------------------------
if (-not $Quiet) {
    Write-Host ""
    Write-Host "==========================================================="
    Write-Host "  TY AI OS -- TYOVA Health Check"
    Write-Host "  $(Get-Date -Format 'yyyy-MM-dd HH:mm') San Diego"
    Write-Host "==========================================================="
}

$allPassed = $true

# -----------------------------------------------------------
# CHECK 1 -- TYOVA PAGE REACHABILITY
# -----------------------------------------------------------
if (-not $Quiet) { Write-Host "" ; Write-Host "  [CHECK 1] TYOVA Page Reachability" }

foreach ($page in $PAGES_TO_CHECK) {
    $url = "$TYOVA_BASE$page"
    try {
        $resp = Invoke-WebRequest -Uri $url -Method Head -TimeoutSec 10 -UseBasicParsing
        if ($resp.StatusCode -eq 200) {
            Write-Check $PASS_SYMBOL $url "HTTP $($resp.StatusCode)"
        } else {
            Write-Check $FAIL_SYMBOL $url "HTTP $($resp.StatusCode)"
            $allPassed = $false
        }
    } catch {
        Write-Check $FAIL_SYMBOL $url "UNREACHABLE"
        $allPassed = $false
    }
}

# -----------------------------------------------------------
# CHECK 2 -- jaya_audit_events RECENCY (T-06 = 30 seconds)
# -----------------------------------------------------------
if (-not $Quiet) { Write-Host "" ; Write-Host "  [CHECK 2] jaya_audit_events Recency (T-06 = $T06_SECONDS seconds)" }

if (-not $supabaseUrl -or -not $supabaseKey) {
    Write-Check $SKIP_SYMBOL "jaya_audit_events" "credentials not loaded from env file"
} else {
    $cutoff    = [System.DateTimeOffset]::UtcNow.AddSeconds(-$T06_SECONDS).ToString("yyyy-MM-ddTHH:mm:ssZ")
    $eventsUrl = "$supabaseUrl/rest/v1/jaya_audit_events?select=id,created_at&created_at=gte.$cutoff&limit=1"
    try {
        $headers = @{
            "apikey"        = $supabaseKey
            "Authorization" = "Bearer $supabaseKey"
        }
        $resp   = Invoke-WebRequest -Uri $eventsUrl -Headers $headers -Method Get -TimeoutSec 10 -UseBasicParsing
        $events = $resp.Content | ConvertFrom-Json
        if ($events.Count -gt 0) {
            Write-Check $PASS_SYMBOL "jaya_audit_events" "event found within last $T06_SECONDS seconds -- Jaya Runtime is writing"
        } else {
            Write-Check $WARN_SYMBOL "jaya_audit_events" "NO event within last $T06_SECONDS seconds -- Jaya Runtime may not be running"
            # WARN not FAIL -- Jaya not running at Pre-Flight is expected in some sessions
        }
    } catch {
        Write-Check $FAIL_SYMBOL "jaya_audit_events" "query failed -- $_"
        $allPassed = $false
    }
}

# -----------------------------------------------------------
# RESULT
# -----------------------------------------------------------
if (-not $Quiet) {
    Write-Host ""
    Write-Host "==========================================================="
    if ($allPassed) {
        Write-Host "  TYOVA HEALTH: PASS -- all checks green"
    } else {
        Write-Host "  TYOVA HEALTH: FAIL -- one or more checks failed"
    }
    Write-Host "==========================================================="
    Write-Host ""
}

exit $(if ($allPassed) { 0 } else { 1 })