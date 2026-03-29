# TY AI OS -- Release Process
**Document ID:** TY-RELEASE-PROCESS-v1
**Version:** 1.0
**Date:** 2026-03-29
**Author:** Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
**Status:** CANONICAL -- LOCKED

---

## Purpose

This document defines the mandatory process for releasing a new version of the
TY AI OS bundle. Every release must follow this process exactly. No shortcuts.
No steps skipped. This process ensures users always receive clean, verified,
integrity-checked artifacts.

---

## Version Naming Convention

| Change Type | Version Bump | Example |
|---|---|---|
| Minor content fix or small update | Letter increment | TY-0001.A -> TY-0001.B |
| Significant content update | Number increment | TY-0001.A -> TY-0002.A |
| Major architectural change | New number | TY-0001.A -> TY-0002.A |

Current release: TY-0001.A
Next minor release: TY-0001.B
Next major release: TY-0002.A

---

## Files That Must Be Updated On Every Release

| File | Location | What Changes |
|---|---|---|
| manifest.json | TYOVA src/ty-ai-admin-core/bundle/ | version field |
| version.json | TYOVA src/ty-ai-admin-core/bundle/ | version field |
| VERIFY.md | TYOVA src/ty-ai-admin-core/bundle/package/ | version, hash, date |
| README.md | TYOVA src/ty-ai-admin-core/bundle/package/ | version references |
| PACKAGING_MANIFEST.md | TYOVA src/ty-ai-admin-core/bundle/ | version, ZIP filename |
| bundleIdentity.ts | ty-ai-os-bundle src/constants/ | integrityHash value |
| DistributionPage.tsx | TYOVA src/pages/ | download link URL and hash |

---

## Mandatory Release Checklist -- 10 Steps In Order

### Step 1 -- Make Source Changes
- Make all content changes to bundle source files in TYOVA repo
- Use VS Code only -- never Notepad
- Follow R1 through R14 write rules at all times

### Step 2 -- Run S1/S2 Corruption Scan
Run this scan on the entire bundle directory before proceeding:
`powershell
Get-ChildItem "E:\TY-Ecosystem\TYOVA\src\ty-ai-admin-core\bundle" -Recurse -Include "*.md","*.json","*.ts" | ForEach-Object { /**
 * Bundle Identity Manifest
 * 
 * SINGLE SOURCE OF TRUTH
 * This object is immutable and defines the canonical identity
 * of the TY AI OS Bundle. No runtime mutation is permitted.
 * 
 * DATA CLASSIFICATION: IDENTITY CONSTANTS
 * All values are fixed by design and cannot be changed at runtime.
 */

export interface BundleIdentityManifest {
  readonly bundleId: string;
  readonly bundleName: string;
  readonly bundleVersion: string;
  readonly buildTimestamp: string;
  readonly canonicalSource: string;
  readonly canonicalReference: string;
  readonly integrityHash: string;
  readonly executionGuarantee: string;
  readonly authorityGuarantee: string;
}

export const BUNDLE_IDENTITY: Readonly<BundleIdentityManifest> = Object.freeze({
  bundleId: "ty-ai-os-bundle",
  bundleName: "TY AI OS Bundle",
  bundleVersion: "TY-0001.A",
  buildTimestamp: "2026-02-03 17:28 PST (America/Los_Angeles)",
  canonicalSource: "TYOVA",
  canonicalReference: "TYOVA Canonical Documentation",
  integrityHash: "SHA-256:3A6FAD0CA68C52DCBA3F3F264A5244A50B32399A263D9224D3D66AD739ADAA23",
  executionGuarantee: "No runtime execution",
  authorityGuarantee: "No implicit or explicit authority",
});
 = Get-Content .FullName -Raw; if (/**
 * Bundle Identity Manifest
 * 
 * SINGLE SOURCE OF TRUTH
 * This object is immutable and defines the canonical identity
 * of the TY AI OS Bundle. No runtime mutation is permitted.
 * 
 * DATA CLASSIFICATION: IDENTITY CONSTANTS
 * All values are fixed by design and cannot be changed at runtime.
 */

export interface BundleIdentityManifest {
  readonly bundleId: string;
  readonly bundleName: string;
  readonly bundleVersion: string;
  readonly buildTimestamp: string;
  readonly canonicalSource: string;
  readonly canonicalReference: string;
  readonly integrityHash: string;
  readonly executionGuarantee: string;
  readonly authorityGuarantee: string;
}

export const BUNDLE_IDENTITY: Readonly<BundleIdentityManifest> = Object.freeze({
  bundleId: "ty-ai-os-bundle",
  bundleName: "TY AI OS Bundle",
  bundleVersion: "TY-0001.A",
  buildTimestamp: "2026-02-03 17:28 PST (America/Los_Angeles)",
  canonicalSource: "TYOVA",
  canonicalReference: "TYOVA Canonical Documentation",
  integrityHash: "SHA-256:3A6FAD0CA68C52DCBA3F3F264A5244A50B32399A263D9224D3D66AD739ADAA23",
  executionGuarantee: "No runtime execution",
  authorityGuarantee: "No implicit or explicit authority",
});
 -match "â€|Ã|â•|âœ|â€™|â€œ|â³|â€"|â€¢") { Write-Host "CORRUPTION: " } }
`
Expected: zero output. Any corruption must be fixed before proceeding.

### Step 3 -- Update Version String
Update the new version string in all seven files listed above.
Use PowerShell Replace -- never manual edit in Notepad.
Verify each file after writing.

### Step 4 -- Assemble New ZIP
`powershell
E:\TY-Ecosystem\TYOVA\src\ty-ai-admin-core\bundle\package = "E:\TY-Ecosystem\TYOVA\src\ty-ai-admin-core\bundle\package"
E:\TY-Ecosystem\ty-ai-os-TY-0001.A.zip = "E:\TY-Ecosystem\ty-ai-os-[NEW-VERSION].zip"
if (Test-Path E:\TY-Ecosystem\ty-ai-os-TY-0001.A.zip) { Remove-Item E:\TY-Ecosystem\ty-ai-os-TY-0001.A.zip }
Compress-Archive -Path "E:\TY-Ecosystem\TYOVA\src\ty-ai-admin-core\bundle\package\*" -DestinationPath E:\TY-Ecosystem\ty-ai-os-TY-0001.A.zip -CompressionLevel Optimal
Write-Host "ZIP created."
Get-Item E:\TY-Ecosystem\ty-ai-os-TY-0001.A.zip | Select-Object FullName, Length
`
Record the exact file size in bytes.

### Step 5 -- Compute Real SHA-256
`powershell
@{Algorithm=SHA256; Hash=3A6FAD0CA68C52DCBA3F3F264A5244A50B32399A263D9224D3D66AD739ADAA23; Path=E:\TY-Ecosystem\ty-ai-os-TY-0001.A.zip} = Get-FileHash "E:\TY-Ecosystem\ty-ai-os-[NEW-VERSION].zip" -Algorithm SHA256
Write-Host "SHA-256: 3A6FAD0CA68C52DCBA3F3F264A5244A50B32399A263D9224D3D66AD739ADAA23"
`
Record this hash immediately. Do not lose it.

### Step 6 -- Update VERIFY.md With Real Hash
Replace the previous hash with the new hash in VERIFY.md.
Replace the previous version with the new version.
Replace the previous ZIP filename with the new ZIP filename.
Run corruption scan on VERIFY.md after writing.

### Step 7 -- Update Bundle UI Hash
Send Lovable prompt to ty-ai-os-bundle project:
"Update bundleIdentity.ts -- replace the current integrityHash value with:
SHA-256:[NEW-HASH]
No other changes."
Pull and verify after Lovable applies the change.

### Step 8 -- Commit All Changes
Commit to TYOVA:
`
git add src/ty-ai-admin-core/bundle/
git commit -m "Release [NEW-VERSION]: bundle files updated -- JAYA-CLO-[###] | Claude Sonnet 4.6 | YYYY-MM-DD | San Diego"
git push origin main
`

### Step 9 -- Publish New GitHub Release
Go to: https://github.com/joseramonjr/ty-ai-os-releases/releases/new

Fill in:
- Tag: [NEW-VERSION] -- e.g. TY-0001.B
- Title: TY AI OS -- [NEW-VERSION]
- Description: include SHA-256 hash, verification URL, release notes
- Attach: ty-ai-os-[NEW-VERSION].zip
- Check: Set as pre-release (until full production release)
- Click: Publish release

Do NOT delete old releases. They must remain permanently.

### Step 10 -- Update TYOVA Distribution Page
Send Lovable prompt to TYOVA project:
"Update src/pages/DistributionPage.tsx -- update the TY AI OS Bundle download
link to point to the new release:
https://github.com/joseramonjr/ty-ai-os-releases/releases/tag/[NEW-VERSION]
Update the SHA-256 hash display to: [NEW-HASH]
No other changes."
Pull and verify after Lovable applies the change.
Run corruption scan on DistributionPage.tsx after pull.

---

## What Happens To Old Releases

Old releases are NEVER deleted. GitHub Releases is an append-only record.
Every version ever shipped remains permanently accessible.
Users who downloaded an old version can still verify its hash.
The audit trail is permanent -- this aligns with the append-only ledger doctrine.

The latest release is marked as Latest on GitHub.
The TYOVA distribution page always links to the latest release.

---

## FIX and CLO Requirements Per Release

Every release requires at minimum:
- One CLO consumed per significant change
- FIX entries for: version update, hash update, distribution page update
- MASTER_FIX_INDEX entries written same session -- never deferred
- Ch18 entry written and committed

---

## Governance Rules That Always Apply

- R1: Never pipe files in Git Bash -- use WriteAllLines
- R2: One atomic write per session
- R3: Verify line count and bytes after every write
- R12: S1/S2 scans after every file write
- R13: JSON files use WriteAllText with UTF8Encoding false
- R14: Every fix receives sequential FIX ID and San Diego timestamp

---

## Release History

| Version | Date | SHA-256 | GitHub Release |
|---|---|---|---|
| TY-0001.A | 2026-03-29 | 3A6FAD0CA68C52DCBA3F3F264A5244A50B32399A263D9224D3D66AD739ADAA23 | https://github.com/joseramonjr/ty-ai-os-releases/releases/tag/TY.0001.A |

---

**TY AI OS Release Process v1.0**
*Published by TYOVA Canonical Hub -- 2026-03-29 San Diego*