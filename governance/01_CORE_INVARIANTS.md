# 01_CORE_INVARIANTS

Status: Active

## Canonical Timestamp Standard

All governance FIX entries, seals, audits, and registry updates must use:

America/Los_Angeles (San Diego time)

No other timezone may be used in governance records.

---

## FIX Discipline

1. No FIX exists unless recorded in MASTER_FIX_INDEX.
2. No Part exists unless recorded in PART_REGISTRY.
3. No Seal exists unless recorded in SEAL_REGISTRY.
4. No retroactive renumbering is permitted.
5. No duplicate FIX identifiers are allowed.
6. All FIX entries must include:
   - Domain
   - Part
   - Timestamp (America/Los_Angeles)
   - Status

---

## Repository Canon Rule

Chat sessions are not canonical.

The Git repository is the only authoritative governance record.
