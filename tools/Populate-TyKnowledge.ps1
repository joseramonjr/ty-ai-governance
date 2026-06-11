# Populate-TyKnowledge.ps1
# ADR-029 GAP 1B -- Population Script v2
# Loads all five canonical governance documents into ty_knowledge SQLite table
# Uses stdin batch transaction approach to handle apostrophes correctly
# Builder-run only. No AI component may execute this script.
# FIX-758 | 2026-06-10 | San Diego

param(
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

# Paths
$sqlite     = "E:\TY-Ecosystem\sqlite-tools\sqlite3.exe"
$dbPath     = "C:\Users\joseramonjr\AppData\Roaming\com.jaya.runtime\jaya\ledger.db"
$timestamp  = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

$doc_thresh = "E:\TY-Ecosystem\ty-ai-governance\spec\TY_CANONICAL_THRESHOLDS_REGISTRY.md"
$doc_adr    = "E:\TY-Ecosystem\ty-ai-governance\governance\TY_ARCHITECTURAL_DECISIONS_RECORD.md"
$doc_qa     = "E:\TY-Ecosystem\ty-ai-governance\governance\TY_QA_REGISTRY.md"
$doc_ct     = "E:\TY-Ecosystem\ty-ai-governance\governance\TY_CONSCIENCE_THREAD_v0.1.md"
$doc_ch26   = "E:\TY-Ecosystem\ty-ai-governance\book\TY_BOOK_CHAPTER_26_THE_TY_AI_OS_VOCABULARY.md"

# Verify prerequisites
if (-not (Test-Path $sqlite)) { Write-Error "sqlite3.exe not found at $sqlite"; exit 1 }
if (-not (Test-Path $dbPath)) { Write-Error "ledger.db not found at $dbPath -- start Jaya first"; exit 1 }

# Verify ty_knowledge exists
$tableCheck = & $sqlite $dbPath "SELECT name FROM sqlite_master WHERE type='table' AND name='ty_knowledge';"
if ($tableCheck -ne "ty_knowledge") { Write-Error "ty_knowledge table not found -- run FIX-757 first"; exit 1 }

Write-Host "============================================================"
Write-Host "  Populate-TyKnowledge.ps1 v2"
Write-Host "  $timestamp | San Diego"
Write-Host "  DryRun: $DryRun"
Write-Host "============================================================"

# Collect all SQL statements
$sqlStatements = [System.Collections.Generic.List[string]]::new()
$sqlStatements.Add("BEGIN TRANSACTION;")
$sqlStatements.Add("DELETE FROM ty_knowledge;")

$totalEntries = 0
$dryRunLog = [System.Collections.Generic.List[string]]::new()

function Add-Row {
    param($source, $type, $key, $content)
    
    # Escape single quotes for SQLite
    $safeKey     = $key -replace "'", "''"
    $safeContent = $content -replace "'", "''"
    $safeSource  = $source -replace "'", "''"
    
    $sql = "INSERT INTO ty_knowledge (document_source, entry_type, entry_key, entry_content, last_updated) VALUES ('$safeSource', '$type', '$safeKey', '$safeContent', '$timestamp');"
    $script:sqlStatements.Add($sql)
    $script:totalEntries++
    $script:dryRunLog.Add("  [ENTRY] $type | $key")
}

function Split-ByPattern {
    param($text, $pattern)
    $matches = [regex]::Matches($text, $pattern, [System.Text.RegularExpressions.RegexOptions]::Multiline)
    $entries = @()
    for ($i = 0; $i -lt $matches.Count; $i++) {
        $start = $matches[$i].Index
        $end = if ($i + 1 -lt $matches.Count) { $matches[$i+1].Index } else { $text.Length }
        $entries += $text.Substring($start, $end - $start).Trim()
    }
    return $entries
}

# ============================================================
# 1. THRESHOLDS
# ============================================================
Write-Host ""
Write-Host "[1/5] Loading Thresholds..."
$content = [System.IO.File]::ReadAllText($doc_thresh, [System.Text.Encoding]::UTF8)
$entries = Split-ByPattern $content "(?m)^### T-\d+"
foreach ($entry in $entries) {
    $keyMatch = [regex]::Match($entry, "^### (T-\d+)")
    if ($keyMatch.Success) {
        Add-Row "TY_CANONICAL_THRESHOLDS_REGISTRY.md" "threshold" $keyMatch.Groups[1].Value $entry
    }
}
Write-Host "  Thresholds queued: $($entries.Count)"

# ============================================================
# 2. ADR
# ============================================================
Write-Host ""
Write-Host "[2/5] Loading ADR entries..."
$content = [System.IO.File]::ReadAllText($doc_adr, [System.Text.Encoding]::UTF8)
$entries = Split-ByPattern $content "(?m)^### ADR-\d+"
foreach ($entry in $entries) {
    $keyMatch = [regex]::Match($entry, "^### (ADR-\d+)")
    if ($keyMatch.Success) {
        Add-Row "TY_ARCHITECTURAL_DECISIONS_RECORD.md" "decision" $keyMatch.Groups[1].Value $entry
    }
}
Write-Host "  ADR entries queued: $($entries.Count)"

# ============================================================
# 3. QA REGISTRY
# ============================================================
Write-Host ""
Write-Host "[3/5] Loading QA Registry entries..."
$content = [System.IO.File]::ReadAllText($doc_qa, [System.Text.Encoding]::UTF8)

$qaEntries = Split-ByPattern $content "(?m)^### QA-\d+"
foreach ($entry in $qaEntries) {
    $keyMatch = [regex]::Match($entry, "^### (QA-\d+)")
    if ($keyMatch.Success) { Add-Row "TY_QA_REGISTRY.md" "qa" $keyMatch.Groups[1].Value $entry }
}

$giqEntries = Split-ByPattern $content "(?m)^### GIQ-\d+"
foreach ($entry in $giqEntries) {
    $keyMatch = [regex]::Match($entry, "^### (GIQ-\d+)")
    if ($keyMatch.Success) { Add-Row "TY_QA_REGISTRY.md" "giq" $keyMatch.Groups[1].Value $entry }
}

$adqEntries = Split-ByPattern $content "(?m)^### ADQ-\d+"
foreach ($entry in $adqEntries) {
    $keyMatch = [regex]::Match($entry, "^### (ADQ-\d+)")
    if ($keyMatch.Success) { Add-Row "TY_QA_REGISTRY.md" "adq" $keyMatch.Groups[1].Value $entry }
}
Write-Host "  QA: $($qaEntries.Count) | GIQ: $($giqEntries.Count) | ADQ: $($adqEntries.Count)"

# ============================================================
# 4. CONSCIENCE THREAD
# ============================================================
Write-Host ""
Write-Host "[4/5] Loading Conscience Thread entries..."
$content = [System.IO.File]::ReadAllText($doc_ct, [System.Text.Encoding]::UTF8)
$entries = Split-ByPattern $content "(?m)^### C\d+-\d+"
foreach ($entry in $entries) {
    $keyMatch = [regex]::Match($entry, "^### (C\d+-\d+)")
    if ($keyMatch.Success) {
        Add-Row "TY_CONSCIENCE_THREAD_v0.1.md" "invariant" $keyMatch.Groups[1].Value $entry
    }
}
Write-Host "  Conscience Thread entries queued: $($entries.Count)"

# ============================================================
# 5. CH26 VOCABULARY
# ============================================================
Write-Host ""
Write-Host "[5/5] Loading Ch26 Vocabulary terms..."
$content = [System.IO.File]::ReadAllText($doc_ch26, [System.Text.Encoding]::UTF8)
$entries = Split-ByPattern $content "(?m)^\*\*[A-Z]"
foreach ($entry in $entries) {
    $keyMatch = [regex]::Match($entry, "^\*\*([^*]+)\*\*")
    if ($keyMatch.Success) {
        $key = $keyMatch.Groups[1].Value.Trim()
        if ($key -notmatch "^(Document Type|CLO|Model|Started|Updated|Builder|Current Term)") {
            Add-Row "TY_BOOK_CHAPTER_26_THE_TY_AI_OS_VOCABULARY.md" "term" $key $entry
        }
    }
}
Write-Host "  Ch26 terms queued"

# ============================================================
# COMMIT
# ============================================================
$sqlStatements.Add("COMMIT;")

Write-Host ""
Write-Host "Total entries queued: $totalEntries"

if ($DryRun) {
    Write-Host ""
    $dryRunLog | ForEach-Object { Write-Host $_ }
    Write-Host ""
    Write-Host "============================================================"
    Write-Host "  DRY RUN COMPLETE -- no rows inserted"
    Write-Host "============================================================"
} else {
    Write-Host "Writing SQL batch file and executing..."
    
    # Write all SQL to temp file
    $batchFile = [System.IO.Path]::GetTempFileName() + ".sql"
    [System.IO.File]::WriteAllLines($batchFile, $sqlStatements, [System.Text.UTF8Encoding]::new($false))
    
    # Execute via stdin pipe
    $result = Get-Content $batchFile | & $sqlite $dbPath 2>&1
    Remove-Item $batchFile -ErrorAction SilentlyContinue
    
    if ($result) {
        Write-Host "SQLite output: $result"
    }
    
    # Verify row count
    $rowCount = & $sqlite $dbPath "SELECT COUNT(*) FROM ty_knowledge;"
    $byType = & $sqlite $dbPath "SELECT entry_type, COUNT(*) FROM ty_knowledge GROUP BY entry_type ORDER BY entry_type;"
    
    Write-Host ""
    Write-Host "============================================================"
    Write-Host "  POPULATION COMPLETE"
    Write-Host "  Total rows in ty_knowledge: $rowCount"
    Write-Host ""
    Write-Host "  By type:"
    $byType | ForEach-Object { Write-Host "    $_" }
    Write-Host "============================================================"
}