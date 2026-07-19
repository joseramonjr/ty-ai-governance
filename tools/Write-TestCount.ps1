# Write-TestCount.ps1
# FIX-953 -- Companion to Update-TYOVAStats.ps1
# Run after cargo test in Jaya-Runtime src-tauri
# Captures test count and writes to .last-test-count.json
# Update-TYOVAStats.ps1 reads this file to auto-update masterHubRegistry.ts
#
# Usage:
#   cd E:\TY-Ecosystem\Jaya-Runtime\src-tauri
#   cargo test 2>&1 | .\tools\Write-TestCount.ps1
#
# Or run cargo test first, paste count manually:
#   .\tools\Write-TestCount.ps1 -TestsTotal 240 -TestsPass 240

param(
    [int]$TestsTotal = 0,
    [int]$TestsPass  = 0
)

$OUTPUT_FILE = "E:\TY-Ecosystem\Jaya-Runtime\src-tauri\.last-test-count.json"

# If called with explicit params, write directly
if ($TestsTotal -gt 0) {
    $json = @{
        testsTotal  = $TestsTotal
        testsPass   = $TestsPass
        recordedAt  = (Get-Date -Format "yyyy-MM-dd HH:mm") + " PDT San Diego"
    } | ConvertTo-Json

    [System.IO.File]::WriteAllText($OUTPUT_FILE, $json, [System.Text.UTF8Encoding]::new($false))
    Write-Host "  [WRITE] .last-test-count.json -- testsTotal=$TestsTotal testsPass=$TestsPass" -ForegroundColor Green
    exit 0
}

# Otherwise read from pipeline (cargo test output)
$input_lines = @($input)
$output = $input_lines -join "`n"

# Parse: "test result: ok. NNN passed; 0 failed"
$match = [regex]::Match($output, 'test result: ok\.\s+(\d+) passed')
if ($match.Success) {
    $count = [int]$match.Groups[1].Value
    $json = @{
        testsTotal  = $count
        testsPass   = $count
        recordedAt  = (Get-Date -Format "yyyy-MM-dd HH:mm") + " PDT San Diego"
    } | ConvertTo-Json

    [System.IO.File]::WriteAllText($OUTPUT_FILE, $json, [System.Text.UTF8Encoding]::new($false))
    Write-Host "  [WRITE] .last-test-count.json -- testsTotal=$count testsPass=$count" -ForegroundColor Green
    # Also pass through the original output
    Write-Output $output
    exit 0
} else {
    Write-Host "  [WARN] Could not parse test count from cargo test output -- .last-test-count.json not updated" -ForegroundColor Yellow
    Write-Output $output
    exit 1
}
