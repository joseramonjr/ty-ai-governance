# TY AI OS -- Jaya Runtime SQLite Backup Discipline
# Ledger Resilience and Recovery Protocol

**Status:** ACTIVE
**Version:** v0.1 -- Phase 14 baseline
**FIX:** FIX-709 · Entry-727
**Established:** 2026-06-02 | San Diego (America/Los_Angeles)
**Closes:** OAQ-002 CAT-3-014 (GAP -- SQLite backup discipline never
  committed as canonical governance requirement)
**Authority:** Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
**Pre-Ship Blocker:** FLAG-139 -- Jaya Runtime SQLite backup must be
  implemented and verified before TY-0001.C ships
**Historical Note:** IBB-1 (Internal Backup Button) was designed during
  SS321 Part 37 (Fix 37.4) for the SS321 web app layer. IBB-1 predates
  Jaya Runtime and does not apply to the SQLite enforcement ledger.
  This document establishes the Jaya Runtime SQLite backup discipline
  as a separate, dedicated governance requirement.

---

## Governance Layer Classification

**Constitutional layer** -- the backup discipline requirement itself
is permanent. The Jaya Runtime SQLite ledger is the enforcement
authority. Its loss is a governance crisis. A guardian who has not
established backup discipline has created a single point of failure
in the governance chain. This requirement does not change at any
scale, in any phase, or under any deployment configuration.

**Architectural layer** -- the three-tier backup architecture
(Tier 1 local, Tier 2 offsite encrypted, Tier 3 federation
redundancy) reflects the designed evolution path. Tier 1 is the
minimum acceptable standard. Tier 2 is required before TY-0001.C
ships. Tier 3 is Phase 15+ federation scope.

**Operational layer** -- specific backup paths, schedules, and
tooling. These change as the deployment environment evolves.
Current paths and schedules are defined in the FLAG-139
implementation record when completed.

---

## Current State -- Confirmed Gap (Constitutional)

**As of 2026-06-02, no formal backup of the Jaya Runtime SQLite
enforcement ledger exists.**

This was confirmed by the OAQ-002 Red-Team (CAT-3-014, verdict GAP)
and verified against the full project history. The gap is real and
must be resolved before TY-0001.C ships.

What IS backed up through existing infrastructure:
- ty-ai-governance documentation repo (GitHub) -- MFI, Ch18, all
  governance documents
- TYOVA frontend repo (GitHub) -- public transparency layer
- Jaya-Runtime source code repo (GitHub) -- code, not runtime data
- Governance event stream (partial) -- Supabase jaya_audit_events
  receives events after SQLite records them, but only when online

What is NOT backed up:
- The SQLite database file itself -- the live enforcement ledger
  containing all governance events, agent registry, policy state,
  CRI history, tier history, and all runtime enforcement data

**This is the gap. This document closes the documentation gap and
opens FLAG-139 to close the implementation gap.**

---

## What a Backup Must Include (Constitutional)

A compliant Jaya Runtime SQLite backup must include all of the
following:

1. The complete SQLite database file -- all tables, all rows,
   all enforcement history
2. A SHA-256 hash of the backup file computed at backup time --
   for integrity verification on restore
3. A timestamp of when the backup was taken -- San Diego
   (America/Los_Angeles) timezone
4. A version identifier linking the backup to the Jaya Runtime
   commit that produced the data

A backup that omits any of these four elements is not a compliant
backup for governance purposes.

---

## What a Backup Must NOT Include (Constitutional)

Derived from QA-022 (memory backup design, SS321 Part 69):

The SQLite ledger backup is a data backup, not an authority backup.
The following must never be treated as restorable from backup:

1. Guardian authority -- guardian identity and authority are
   re-established through the HVP (Human Verification Protocol)
   on recovery, not restored from backup. A backup cannot
   restore who the guardian is.

2. Active key material -- Ed25519 private keys are never stored
   in the SQLite database and must never be included in a backup.
   Key material is held in the Private Verification Store (PVS),
   governed by TY_HUMAN_VERIFICATION_PROTOCOL_v0.1.md.

3. System authority grants -- authority is always re-issued by
   the guardian after recovery. It cannot be restored from a
   data backup.

What the backup restores is the historical enforcement record --
what happened, when, and what decisions were made. It does not
restore who is in charge.

---

## Three-Tier Backup Architecture (Architectural Layer)

### Tier 1 -- Local Backup (Minimum Acceptable Standard)

**Status:** Required immediately (FLAG-139)
**What:** Daily automated copy of the SQLite database file to a
second location on the guardian's machine -- a different drive,
partition, or folder that is not the primary Jaya Runtime data
directory.
**How:** PowerShell script scheduled via Windows Task Scheduler.
Runs daily at a guardian-defined time. Copies the SQLite file
with a datestamped filename. Computes SHA-256 of the copy and
writes it alongside the backup file.
**Protects against:** Accidental deletion, file corruption,
some ransomware scenarios (if the backup location is not
encrypted by the same ransomware pass).
**Does not protect against:** Total hardware failure, theft,
fire, flood, or ransomware that encrypts all local drives.
**Retention:** Keep last 30 daily backups. Older backups are
removed by the same script.
**Implementation:** FLAG-139 defines the exact PowerShell script,
schedule, and verification gate before TY-0001.C ships.

---

### Tier 2 -- Encrypted Offsite Backup (Pre-Ship Requirement)

**Status:** Required before TY-0001.C ships (FLAG-139)
**What:** The SQLite database file encrypted with AES-256 and
stored in a guardian-controlled offsite location -- separate from
the primary machine and the Tier 1 local backup location.
**Acceptable offsite locations:**
- An encrypted archive on a personal cloud storage account
  (guardian-controlled, not shared)
- An encrypted archive on an external drive kept at a separate
  physical location from the guardian's primary machine
- A dedicated encrypted backup service under guardian control
**Encryption requirement:** AES-256 minimum. The encryption key
is held by the guardian only. The key is never stored in the
same location as the backup. The key is never stored in any
TY AI OS governance file.
**Frequency:** Weekly minimum. After any session that produces
significant governance events (guardian discretion).
**Protects against:** Total hardware failure, theft, fire, flood.
**Implementation:** FLAG-139 defines the exact encryption method,
key management protocol, and offsite location requirements.

---

### Tier 3 -- Federation Redundancy (Phase 15+)

**Status:** Not yet implemented -- Phase 15+ scope
**What:** In a federated deployment, peer nodes hold attestation
records that can partially reconstruct ledger state. Cross-node
attestation payloads contain governance state hashes that provide
an independent verification record across the federation.
**Important limitation:** This is not a substitute for Tier 1
and Tier 2 backup. Federation redundancy provides partial
reconstruction capability only -- it cannot restore the full
SQLite schema including agent registry, policy state, and
CRI history. Tier 1 and Tier 2 remain required at all scales.
**See FLAG-138:** Federation Network Partition Governance
covers the broader federation resilience architecture.

---

## Recovery Procedure (Architectural Layer)

If the Jaya Runtime SQLite ledger is lost due to hardware failure,
corruption, or any other cause, the recovery procedure is:

**Step 1 -- Do not launch Jaya Runtime without a ledger.**
Launching Jaya Runtime without its enforcement ledger creates
a new empty ledger. This is not a recovery -- it is starting
a new chain. The old governance history is not merged.

**Step 2 -- Identify the most recent compliant backup.**
Verify the backup SHA-256 hash against the stored hash before
restoring. A backup whose hash does not match must not be
restored -- it may be corrupted or tampered.

**Step 3 -- Restore the backup to the Jaya Runtime data directory.**
Replace the missing or corrupted SQLite file with the verified backup.

**Step 4 -- Write a Gap Entry to the restored ledger.**
Using the TY-ANCHOR governance tooling, write a formal gap
entry documenting:
- The date and time of the ledger loss
- The cause of the loss (hardware failure, corruption, etc.)
- The backup date from which recovery was made
- The governance events that may have been lost between the
  backup date and the loss date (acknowledged gap)
- Guardian identity confirmation via Ed25519 signed check-in

**Step 5 -- Resume normal operation.**
The restored ledger with the gap entry is the canonical record.
The acknowledged gap is permanent and auditable. It is not
hidden. It is governance evidence of what happened.

**Step 6 -- Notify the governance record.**
Write a Ch18 entry and MFI entry documenting the recovery event
in the same session as the restore. This is a mandatory ledger
discipline action regardless of the circumstances of the loss.

---

## Gap Entry Format (Operational Layer)

When a ledger recovery gap entry is required (Step 4 above),
the entry must contain these fields:

GAP_ENTRY
Type: LEDGER_RECOVERY
Date: [San Diego timestamp]
Cause: [hardware failure / corruption / other]
Backup_Date: [date of backup used for recovery]
Backup_Hash: [SHA-256 of the backup file]
Acknowledged_Gap_Start: [timestamp of last event in backup]
Acknowledged_Gap_End: [timestamp of recovery]
Guardian_Attestation: [Ed25519 signature of this entry]
Guardian: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.

This format is operational and may be updated as the recovery
tooling evolves. The constitutional requirement -- that the gap
is permanently recorded and not hidden -- does not change.

---

## Pre-Ship Blocker -- FLAG-139

**TY-0001.C must not ship without Tier 1 and Tier 2 backup
being implemented, tested, and verified.**

A production release of TY AI OS governance infrastructure
that does not have a working backup of its enforcement ledger
is not production-ready. This is not a documentation gap --
it is a survivability gap. The governance system must be able
to survive its guardian's hardware failing before it can be
deployed to external operators.

FLAG-139 defines:
- The exact PowerShell script for Tier 1 local backup
- The Windows Task Scheduler configuration
- The Tier 2 encryption method and key management protocol
- The verification gate: a test restore must succeed before
  the backup system is considered implemented
- The Pre-Flight.ps1 addition: backup verification gate added
  to session-open check

See FLAGS.md FLAG-139 for full scope.

---

## Future-Scale Considerations (Architectural Layer)

**External operator deployments:** When TY AI OS is deployed by
Path 2, 3, and 4 operators (Phase 10), each operator must
establish their own Tier 1 and Tier 2 backup discipline for
their Jaya Runtime instance. The TY_EXTERNAL_USER_GOVERNANCE_GUIDE
must be updated to include backup discipline as a deployment
requirement. An external operator who does not have backup
discipline has an unsupported deployment.

**Guardian succession:** When guardian succession activates
(Phase 14 P1, succession_chain.rs), the incoming guardian must
be given access to the backup archives as part of the succession
handoff. The Guardian Codex succession protocol must be updated
to include backup access transfer. A successor who cannot access
the historical enforcement record cannot verify governance
continuity.

**Federation deployments:** Each federation node -- a Jaya Runtime
instance, distinct from TYOVA EcosystemFlowPage WARDs which are
display components only -- maintains its own Tier 1 and Tier 2
backup independently. There is no central federation backup
system. Authority non-propagation applies to backup access --
no node has access to another node's backup. Each node's backup
is the guardian of that node's governance history.

**AI-assisted backup verification:** Future AI capabilities may
assist in verifying backup integrity, checking SHA-256 hashes,
and confirming backup schedules are being followed. The
constitutional constraint: backup restoration requires guardian
authorization. An AI assistant may verify that a backup is
intact -- it may not initiate a restore without guardian
confirmation.

---

## Canonical References

- ADR-003: SQLite append-only ledger as canonical governance record
- C10-002: Conscience Thread -- append-only ledger, no delete no
  update -- what the backup must preserve
- QA-022: Memory backup design -- M1 (Logs) and M2 (Config)
  backup permitted; M4 (Authority) and M5 (Identity) backup
  FORBIDDEN -- directly constrains what SQLite backup restores
- QA-023: Recovery modes R-0 through R-3 -- human-only recovery
  authority
- IBB-1: Internal Backup Button (SS321 Part 37, Fix 37.4,
  ChatGPT era) -- historical precursor for SS321 web app layer;
  not applicable to Jaya Runtime SQLite; documented for provenance
- TY_HUMAN_VERIFICATION_PROTOCOL_v0.1.md: Key material and
  guardian identity are not restorable from backup -- HVP
  governs re-establishment
- FLAG-139: Pre-ship blocker -- Tier 1 + Tier 2 backup
  implementation required before TY-0001.C
- FLAG-138: Federation Network Partition Governance -- Tier 3
  federation redundancy (Phase 15+)
- TY_OFFLINE_FAIL_CLOSED_RULE.md (FIX-708): Jaya continues
  enforcing during backup unavailability -- backup loss does
  not trigger fail-open
- Phase 10 FIX-508: External operator backup discipline
  requirement to be added to governance guide
