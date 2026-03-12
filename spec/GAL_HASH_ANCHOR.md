# GAL GOVERNANCE HASH ANCHOR
# Document ID: TY-GAL-HASH-ANCHOR-v0.1
# Author: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
# Date: 2026-03-11 | San Diego (America/Los_Angeles)
# CLO: JAYA-CLO-135
# Part: 68

---

## Purpose

This document records the canonical governance_hash for GAL protocol v0.1.

The governance_hash is the SHA-256 hash of the canonical governance invariant
set as defined in TY_GAL_SPEC_v0.1.md Section IX.

This value must be included in all GAL v0.1 attestation payloads as the
governance_hash field.

---

## Hash Value

governance_hash: cd7ef6c73e8050394bec5b0e0289238cd000d7c4ce133ec951653531356a6e09

Algorithm: SHA-256
Encoding: Hex (lowercase)

---

## Source Files (Canonical Invariant Set)

The hash was computed over the concatenated UTF-8 contents of:

1. E:\TY-Ecosystem\ty-ai-governance\governance\01_CORE_INVARIANTS.md
   Commit: a107ded

2. E:\TY-Ecosystem\ty-ai-governance\governance\03_NON_WEAPONIZATION_GUARDRAIL.md
   Commit: a107ded

3. E:\TY-Ecosystem\ty-ai-governance\spec\TY_GAL_SPEC_v0.1.md
   Commit: c247983 (tag: phase4-gal-spec-v0.1-draft)

Concatenation separator: newline character
Hash computed: 2026-03-11 | San Diego (America/Los_Angeles)

---

## Recomputation Instructions

To verify or recompute this hash, run the following in PowerShell:

  files = 01_CORE_INVARIANTS.md + 03_NON_WEAPONIZATION_GUARDRAIL.md + TY_GAL_SPEC_v0.1.md
  combined = concatenate file contents joined by newline
  governance_hash = SHA-256(UTF-8 bytes of combined)

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

CLO: JAYA-CLO-135
Model: Claude Sonnet 4.6
Date: 2026-03-11 | San Diego (America/Los_Angeles)
