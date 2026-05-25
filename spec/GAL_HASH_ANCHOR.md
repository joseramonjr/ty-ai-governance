# GAL GOVERNANCE HASH ANCHOR
# Document ID: TY-GAL-HASH-ANCHOR-v0.1
# Author: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
# Date: 2026-03-11 | San Diego (America/Los_Angeles)
# CLO: JAYA-CLO-135 | Part: 68
# Recomputed: FIX-635 | Entry-653 | 2026-05-25 | San Diego (America/Los_Angeles)
---
## Purpose
This document records the canonical governance_hash for GAL protocol v0.1.
The governance_hash is the SHA-256 hash of the canonical governance invariant
set as defined in TY_GAL_SPEC_v0.1.md Section IX.
This value must be included in all GAL v0.1 attestation payloads as the
governance_hash field.
---
## Hash Value -- v0.2 (current -- recomputed FIX-635 2026-05-25)
governance_hash: 11ee89f117bad9dd54819792dff8bc0fd5190010b85ea2d9e951b2da5b0a35e2
Algorithm: SHA-256
Encoding: Hex (lowercase)
---
## Hash Value -- v0.1 (superseded -- computed 2026-03-11)
governance_hash: cd7ef6c73e8050394bec5b0e0289238cd000d7c4ce133ec951653531356a6e09
Status: SUPERSEDED. Source files were modified after this hash was computed.
Preserved as historical record only. All current attestation payloads must
use v0.2.
---
## Source Files -- v0.2 (recomputed 2026-05-25)
The hash was computed over the concatenated UTF-8 contents of:
1. E:\TY-Ecosystem\ty-ai-governance\governance\01_CORE_INVARIANTS.md
   Commit: b358ce7
2. E:\TY-Ecosystem\ty-ai-governance\governance\03_NON_WEAPONIZATION_GUARDRAIL.md
   Commit: f2e5108
3. E:\TY-Ecosystem\ty-ai-governance\spec\TY_GAL_SPEC_v0.1.md
   Commit: 9c4d105 (tag: phase4-gal-spec-v0.1-draft)
Concatenation separator: newline character
Hash computed: 2026-05-25 | San Diego (America/Los_Angeles)
---
## Source Files -- v0.1 (historical -- 2026-03-11)
1. governance/01_CORE_INVARIANTS.md at commit a107ded
2. governance/03_NON_WEAPONIZATION_GUARDRAIL.md at commit a107ded
3. spec/TY_GAL_SPEC_v0.1.md at commit c247983
---
## Recomputation Instructions
To verify or recompute this hash, run the following in PowerShell:
  $f1 = [System.IO.File]::ReadAllText("...\governance\01_CORE_INVARIANTS.md")
  $f2 = [System.IO.File]::ReadAllText("...\governance\03_NON_WEAPONIZATION_GUARDRAIL.md")
  $f3 = [System.IO.File]::ReadAllText("...\spec\TY_GAL_SPEC_v0.1.md")
  $combined = $f1 + "`n" + $f2 + "`n" + $f3
  $bytes = [System.Text.Encoding]::UTF8.GetBytes($combined)
  $sha256 = [System.Security.Cryptography.SHA256]::Create()
  $hash = ([BitConverter]::ToString($sha256.ComputeHash($bytes)) -replace '-','').ToLower()
If any of the three source files are updated, the governance_hash must be
recomputed and this document must be updated before any new attestation
payloads are generated.
---
## Invalidation Conditions
This hash is invalid and must be recomputed if any of the following occur:
- 01_CORE_INVARIANTS.md is modified
- 03_NON_WEAPONIZATION_GUARDRAIL.md is modified
- TY_GAL_SPEC_v0.1.md is modified
- GAL protocol version is incremented
---
## Seal Record
v0.1: CLO JAYA-CLO-135 | 2026-03-11 | San Diego (America/Los_Angeles)
v0.2: FIX-635 Entry-653 | 2026-05-25 | San Diego (America/Los_Angeles)