# Backup-JayaLedger.ps1
# TY AI OS -- Jaya Runtime SQLite Backup Script
# Tier 1 -- Local Backup
# FIX-714 | FLAG-139 | 2026-06-02 15:01 PDT San Diego
# Authority: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
#
# Governance: This script implements the Tier 1 backup requirement defined in
# TY_SQLITE_BACKUP_DISCIPLINE.md (FIX-709). It must be run daily via Task
# Scheduler. Pre-Flight.ps1 checks that the most recent backup is not older
# than 2 days. A stale or missing backup blocks Pre-Flight with ACTION REQUIRED.
#
# Source DB:  C:\Users\joseramonjr\AppData\Roaming\com.jaya.runtime\jaya_governance.db
# Backup dir: E:\TY-Ecosystem\backups\jaya-ledger
# Retention:  30 days
# Log:        E:\TY-Ecosystem\backups\jaya-ledger\backup_log.txt

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# --- Paths ---
$SourceDb    = "C:\Users\joseramonjr\AppData\Roaming\com.jaya.runtime\jaya_governance.db"
$BackupDir   = "E:\TY-Ecosystem\backups\jaya-ledger"
$LogFile     = "$BackupDir\backup_log.txt"
$RetainDays  = 30

# --- Timestamp (San Diego) ---
$TZ          = [System.TimeZoneInfo]::FindSystemTimeZoneById("Pacific Standard Time")
$NowUTC      = [System.DateTime]::UtcNow
$NowSD       = [System.TimeZoneInfo]::ConvertTimeFromUtc($NowUTC, $TZ)
$DateStamp   = $NowSD.ToString("yyyy-MM-dd")
$TimeStamp   = $NowSD.ToString("yyyy-MM-dd HH:mm:ss") + " PDT San Diego"

# --- Derived paths ---
$BackupFile  = "$BackupDir\jaya_ledger_backup_$DateStamp.db"
$HashFile    = "$BackupDir\jaya_ledger_backup_$DateStamp.db.sha256"

function Write-Log {
    param([string]$Message)
    $entry = "[$TimeStamp] $Message"
    Write-Host $entry
    Add-Content -Path $LogFile -Value $entry -Encoding UTF8
}

# --- Create backup directory if needed ---
if (-not (Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
    Write-Log "Created backup directory: $BackupDir"
}

# --- Verify source exists ---
if (-not (Test-Path $SourceDb)) {
    Write-Log "BACKUP FAILED -- source database not found: $SourceDb"
    exit 1
}

$SourceSize = (Get-Item $SourceDb).Length
Write-Log "Source verified: $SourceDb ($SourceSize bytes)"

# --- Copy database ---
try {
    Copy-Item -Path $SourceDb -Destination $BackupFile -Force
    Write-Log "Backup copied: $BackupFile"
    # Stamp LastWriteTime to backup-run time (Copy-Item preserves source timestamp)
    (Get-Item $BackupFile).LastWriteTime = $NowSD
} catch {
    Write-Log "BACKUP FAILED -- copy error: $_"
    exit 1
}

# --- Verify copy size matches source ---
$BackupSize = (Get-Item $BackupFile).Length
if ($BackupSize -ne $SourceSize) {
    Write-Log "BACKUP FAILED -- size mismatch: source=$SourceSize backup=$BackupSize"
    Remove-Item $BackupFile -Force
    exit 1
}
Write-Log "Size verified: $BackupSize bytes (matches source)"

# --- Compute SHA-256 ---
try {
    $Hash = (Get-FileHash -Path $BackupFile -Algorithm SHA256).Hash
    $HashEntry = "$Hash  jaya_ledger_backup_$DateStamp.db"
    [System.IO.File]::WriteAllText($HashFile, $HashEntry, [System.Text.Encoding]::UTF8)
    Write-Log "SHA-256 computed: $Hash"
    Write-Log "Hash file written: $HashFile"
} catch {
    Write-Log "BACKUP FAILED -- hash computation error: $_"
    exit 1
}

# --- Retention: delete backups older than 30 days ---
$Cutoff = $NowSD.AddDays(-$RetainDays)
$OldBackups = Get-ChildItem -Path $BackupDir -Filter "jaya_ledger_backup_*.db" |
    Where-Object { $_.LastWriteTime -lt $Cutoff }
foreach ($old in $OldBackups) {
    $oldHash = $old.FullName + ".sha256"
    Remove-Item $old.FullName -Force
    if (Test-Path $oldHash) { Remove-Item $oldHash -Force }
    Write-Log "Purged old backup: $($old.Name)"
}

Write-Log "Backup complete. File: jaya_ledger_backup_$DateStamp.db | Hash: $Hash"
Write-Log "--- END BACKUP RUN ---"
exit 0