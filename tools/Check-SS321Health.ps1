# ===========================================================
#  TY AI OS -- Check-SS321Health.ps1
#  SS321 Integration Health Check -- FLAG-179
#  FIX-906 | Entry-926 | 2026-07-05 21:52 PDT San Diego
#  Builder: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
# ===========================================================
#  Checks:
#    1. SS321 site returns HTTP 200
#    2. SS321 Supabase project reachable
#    3. user_presence has at least one row with last_seen_at
#       within last 3 minutes (keep-alive working)
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
$SS321_URL            = "https://silversounds321.com"
$PRESENCE_WINDOW_SECS = 180   # 3 minutes -- keep-alive fires every 2 min
$PASS_SYMBOL          = "[PASS]"
$FAIL_SYMBOL          = "[FAIL]"
$WARN_SYMBOL          = "[WARN]"
$SKIP_SYMBOL          = "[SKIP]"

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
        if ($_ -match '^VITE_SS321_SUPABASE_URL=(.+)$')      { $supabaseUrl = $Matches[1].Trim() }
        if ($_ -match '^VITE_SS321_SUPABASE_ANON_KEY=(.+)$') { $supabaseKey = $Matches[1].Trim() }
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
    Write-Host "  TY AI OS -- SS321 Integration Health Check"
    Write-Host "  $(Get-Date -Format 'yyyy-MM-dd HH:mm') San Diego"
    Write-Host "==========================================================="
}

$allPassed = $true

# -----------------------------------------------------------
# CHECK 1 -- SS321 SITE REACHABILITY
# -----------------------------------------------------------
if (-not $Quiet) { Write-Host "" ; Write-Host "  [CHECK 1] SS321 Site Reachability" }

try {
    $resp = Invoke-WebRequest -Uri $SS321_URL -Method Head -TimeoutSec 10 -UseBasicParsing
    if ($resp.StatusCode -eq 200) {
        Write-Check $PASS_SYMBOL $SS321_URL "HTTP $($resp.StatusCode)"
    } else {
        Write-Check $FAIL_SYMBOL $SS321_URL "HTTP $($resp.StatusCode)"
        $allPassed = $false
    }
} catch {
    Write-Check $FAIL_SYMBOL $SS321_URL "UNREACHABLE"
    $allPassed = $false
}

# -----------------------------------------------------------
# CHECK 2 -- SS321 SUPABASE PROJECT REACHABLE
# -----------------------------------------------------------
if (-not $Quiet) { Write-Host "" ; Write-Host "  [CHECK 2] SS321 Supabase Project Reachable" }

if (-not $supabaseUrl -or -not $supabaseKey) {
    Write-Check $SKIP_SYMBOL "SS321 Supabase" "credentials not loaded from env file"
} else {
    $headers = @{
        "apikey"        = $supabaseKey
        "Authorization" = "Bearer $supabaseKey"
    }

    # Query user_presence with limit 1 -- if table exists Supabase is up
    $testUrl = "$supabaseUrl/rest/v1/user_presence?select=id&limit=1"
    try {
        $resp = Invoke-WebRequest -Uri $testUrl -Headers $headers -Method Get -TimeoutSec 10 -UseBasicParsing
        if ($resp.StatusCode -eq 200) {
            Write-Check $PASS_SYMBOL "SS321 Supabase project" "reachable"
        } else {
            Write-Check $FAIL_SYMBOL "SS321 Supabase project" "HTTP $($resp.StatusCode)"
            $allPassed = $false
        }
    } catch {
        Write-Check $FAIL_SYMBOL "SS321 Supabase project" "UNREACHABLE"
        $allPassed = $false
    }

    # -----------------------------------------------------------
    # CHECK 3 -- user_presence RECENCY (keep-alive window = 3 minutes)
    # -----------------------------------------------------------
    if (-not $Quiet) { Write-Host "" ; Write-Host "  [CHECK 3] user_presence Recency (keep-alive window = $PRESENCE_WINDOW_SECS seconds)" }

    $cutoff      = [System.DateTimeOffset]::UtcNow.AddSeconds(-$PRESENCE_WINDOW_SECS).ToString("yyyy-MM-ddTHH:mm:ssZ")
    $presenceUrl = "$supabaseUrl/rest/v1/user_presence?select=id,last_seen_at&last_seen_at=gte.$cutoff&limit=1"

    try {
        $resp = Invoke-WebRequest -Uri $presenceUrl -Headers $headers -Method Get -TimeoutSec 10 -UseBasicParsing
        $rows = $resp.Content | ConvertFrom-Json
        if ($rows.Count -gt 0) {
            Write-Check $PASS_SYMBOL "user_presence" "row found within last $PRESENCE_WINDOW_SECS seconds -- keep-alive working"
        } else {
            Write-Check $WARN_SYMBOL "user_presence" "NO row within last $PRESENCE_WINDOW_SECS seconds -- no active SS321 session or keep-alive may have lapsed"
            # WARN not FAIL -- no active session is expected when no one is on SS321
        }
    } catch {
        Write-Check $FAIL_SYMBOL "user_presence" "query failed -- $_"
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
        Write-Host "  SS321 HEALTH: PASS -- all checks green"
    } else {
        Write-Host "  SS321 HEALTH: FAIL -- one or more checks failed"
    }
    Write-Host "==========================================================="
    Write-Host ""
}

exit $(if ($allPassed) { 0 } else { 1 })