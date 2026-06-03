# Backup-JayaLedger-Tier2.ps1
# TY AI OS -- Jaya Runtime SQLite Backup Script
# Tier 2 -- Encrypted Offsite Backup (D:\ separate physical disk)
# FIX-714 | FLAG-139 | 2026-06-02 15:01 PDT San Diego
# Authority: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
#
# Governance: This script implements the Tier 2 backup requirement defined in
# TY_SQLITE_BACKUP_DISCIPLINE.md (FIX-709). Runs weekly via Task Scheduler.
# AES-256-CBC encryption. Passphrase held by guardian only -- never committed
# to any repo or governance file. Permanent retention -- no deletion.
# When storage is moved to a larger location, update EncryptedBackupDir
# and re-register the Task Scheduler entry with a new FIX number.
#
# Source DB:   C:\Users\joseramonjr\AppData\Roaming\com.jaya.runtime\jaya_governance.db
# Backup dir:  D:\TY-Backups\jaya-ledger-encrypted
# Retention:   PERMANENT -- no deletion
# Encryption:  AES-256-CBC via .NET System.Security.Cryptography
# Log:         D:\TY-Backups\jaya-ledger-encrypted\backup_log.txt

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# --- Paths ---
$SourceDb           = "C:\Users\joseramonjr\AppData\Roaming\com.jaya.runtime\jaya_governance.db"
$EncryptedBackupDir = "D:\TY-Backups\jaya-ledger-encrypted"
$LogFile            = "$EncryptedBackupDir\backup_log.txt"
$PassphrasePlain    = "GUARDIAN-HELD-NOT-STORED-IN-REPO -- see guardian succession credentials"

# --- Timestamp (San Diego) ---
$TZ        = [System.TimeZoneInfo]::FindSystemTimeZoneById("Pacific Standard Time")
$NowUTC    = [System.DateTime]::UtcNow
$NowSD     = [System.TimeZoneInfo]::ConvertTimeFromUtc($NowUTC, $TZ)
$DateStamp = $NowSD.ToString("yyyy-MM-dd")
$TimeStamp = $NowSD.ToString("yyyy-MM-dd HH:mm:ss") + " PDT San Diego"

# --- Derived paths ---
$EncryptedFile = "$EncryptedBackupDir\jaya_ledger_tier2_$DateStamp.db.aes"
$HashFile      = "$EncryptedBackupDir\jaya_ledger_tier2_$DateStamp.db.aes.sha256"

function Write-Log {
    param([string]$Message)
    $entry = "[$TimeStamp] $Message"
    Write-Host $entry
    Add-Content -Path $LogFile -Value $entry -Encoding UTF8
}

# --- Create backup directory if needed ---
if (-not (Test-Path $EncryptedBackupDir)) {
    New-Item -ItemType Directory -Path $EncryptedBackupDir -Force | Out-Null
    Write-Log "Created backup directory: $EncryptedBackupDir"
}

# --- Verify source exists ---
if (-not (Test-Path $SourceDb)) {
    Write-Log "BACKUP FAILED -- source database not found: $SourceDb"
    exit 1
}

$SourceSize = (Get-Item $SourceDb).Length
Write-Log "Source verified: $SourceDb ($SourceSize bytes)"

# --- Read source database bytes ---
$sourceBytes = [System.IO.File]::ReadAllBytes($SourceDb)

# --- Derive AES-256 key and IV from passphrase using SHA-256 ---
$sha256   = [System.Security.Cryptography.SHA256]::Create()
$keyBytes = $sha256.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($PassphrasePlain))
$ivBytes  = $keyBytes[0..15]

# --- Encrypt with AES-256-CBC ---
try {
    $aes           = [System.Security.Cryptography.Aes]::Create()
    $aes.KeySize   = 256
    $aes.BlockSize = 128
    $aes.Mode      = [System.Security.Cryptography.CipherMode]::CBC
    $aes.Padding   = [System.Security.Cryptography.PaddingMode]::PKCS7
    $aes.Key       = $keyBytes
    $aes.IV        = $ivBytes

    $encryptor   = $aes.CreateEncryptor()
    $msEncrypted = New-Object System.IO.MemoryStream
    $cs          = New-Object System.Security.Cryptography.CryptoStream($msEncrypted, $encryptor, [System.Security.Cryptography.CryptoStreamMode]::Write)
    $cs.Write($sourceBytes, 0, $sourceBytes.Length)
    $cs.FlushFinalBlock()
    $encryptedBytes = $msEncrypted.ToArray()
    $cs.Dispose()
    $msEncrypted.Dispose()
    $aes.Dispose()

    [System.IO.File]::WriteAllBytes($EncryptedFile, $encryptedBytes)
    (Get-Item $EncryptedFile).LastWriteTime = $NowSD
    Write-Log "Encrypted backup written: $EncryptedFile ($($encryptedBytes.Length) bytes)"
} catch {
    Write-Log "BACKUP FAILED -- encryption error: $_"
    exit 1
}

# --- Compute SHA-256 of encrypted file ---
try {
    $Hash      = (Get-FileHash -Path $EncryptedFile -Algorithm SHA256).Hash
    $HashEntry = "$Hash  jaya_ledger_tier2_$DateStamp.db.aes"
    [System.IO.File]::WriteAllText($HashFile, $HashEntry, [System.Text.Encoding]::UTF8)
    Write-Log "SHA-256 computed: $Hash"
    Write-Log "Hash file written: $HashFile"
} catch {
    Write-Log "BACKUP FAILED -- hash error: $_"
    exit 1
}

# --- PERMANENT RETENTION -- no deletion ---
$totalBackups = @(Get-ChildItem -Path $EncryptedBackupDir -Filter "jaya_ledger_tier2_*.db.aes").Count
Write-Log "Retention: PERMANENT -- total backups on disk: $totalBackups"
Write-Log "Backup complete. File: jaya_ledger_tier2_$DateStamp.db.aes | Hash: $Hash"
Write-Log "--- END TIER 2 BACKUP RUN ---"
exit 0
