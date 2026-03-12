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

---

## Autonomy Ceiling Invariant
Added: 2026-03-11 | JAYA-CLO-135 | Part 68

The Global Attestonic Layer shall not increase, extend, unlock, or propagate
execution authority across nodes.

For the purposes of this specification, execution authority includes:
- Module execution capability
- Autonomy tier transitions
- Modifier adjustments
- CRI manipulation
- Governance state mutation
- Registry modification
- Operational configuration changes

No attestation result -- successful or failed -- may:
- Grant new capabilities to any node
- Expand existing permissions
- Modify autonomy tier
- Modify modifier state
- Modify CRI state
- Alter execution rights
- Alter runtime configuration

Attestation is a verification mechanism only.

Attestation outcomes may:
- Record local audit entries
- Trigger local human alerts
- Change local trust classification of a peer

Attestation outcomes may not:
- Cause remote configuration changes
- Trigger cross-node execution
- Enforce coordinated behavior
- Alter another node's governance state

This invariant applies to all present and future versions of the Global
Attestonic Layer. There are no override conditions.
