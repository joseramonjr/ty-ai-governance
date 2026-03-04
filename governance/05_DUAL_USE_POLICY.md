# 05_DUAL_USE_POLICY

Status: Active
Established: 2026-02-18 (America/Los_Angeles)
Authority: Global — applies to all TY ecosystem systems

---

## I. PURPOSE

This document defines the formal policy governing dual-use risk assessment
across the TY AI ecosystem. It establishes when audits are required, how
they are conducted, how findings are recorded, and what actions are triggered
by different classification outcomes.

Dual-use risk refers to the potential for a capability designed for beneficial
purposes to be repurposed toward harmful, militarized, or surveillance ends.

---

## II. WHEN A DUAL-USE AUDIT IS REQUIRED

A Dual-Use Risk Audit must be conducted before any of the following:

1. Implementation of a new external data ingestion channel
2. Implementation of autonomous decision-making with real-world effects
3. Any authority escalation pathway being added to a system
4. Any network-connected enforcement mechanism being introduced
5. Any new system being added to the TY AI ecosystem
6. Any capability expansion that increases a system's scope of action
7. Any Part seal where new capabilities were introduced

Audits are recorded in:
`governance/audit/DUAL_USE_AUDITS.md`

---

## III. AUDIT CLASSIFICATION LEVELS

### CLEAN
No dual-use alignment detected.
No structural drift toward militarization, surveillance, or coercion.
Implementation may proceed.

### WATCH
Low-level dual-use potential identified.
No immediate threat but requires monitoring.
Implementation may proceed with documented mitigation plan.

### ELEVATED
Meaningful dual-use risk identified.
Implementation must be paused pending architectural review.
A remediation FIX entry is required before proceeding.

### BLOCKED
Active dual-use alignment detected.
Implementation is prohibited.
A formal incident record is required in DUAL_USE_AUDITS.md.
The offending capability must be removed or restructured before any
further work on the affected system proceeds.

---

## IV. AUDIT PROCESS

### Step 1 — Scope Definition
Define the capability or system being audited.
Record the Part and FIX context.

### Step 2 — Subsystem Review
For each subsystem involved, assess:
- Does this introduce external control surfaces?
- Does this enable population-scale data processing?
- Does this create autonomous offensive decision pathways?
- Does this weaken existing authority boundaries?
- Does this create an external override channel?

### Step 3 — Classification
Assign one of the four classification levels defined above.

### Step 4 — Record
Commit the audit finding to:
`governance/audit/DUAL_USE_AUDITS.md`

Include:
- Audit ID
- Timestamp (America/Los_Angeles)
- Scope
- Subsystems reviewed
- Finding per subsystem
- Overall classification
- Any required follow-up actions

---

## V. EXISTING AUDIT RECORDS

| Audit ID | System | Date | Classification |
|---|---|---|---|
| 36-A | Jaya Runtime | 2026-02-18 | CLEAN |

Full audit details in:
`governance/audit/DUAL_USE_AUDITS.md`

---

## VI. POLICY CONSTRAINTS

1. No audit may be skipped because a capability "seems safe."
2. No audit classification may be retroactively changed without a new audit.
3. A BLOCKED classification cannot be overridden by builder instruction alone
   — it requires a full architectural remediation and re-audit.
4. Audit findings are immutable once committed to the repository.
5. The dual-use audit requirement applies equally to all systems regardless
   of their current maturity or trust level.

---

## VII. RELATIONSHIP TO NON-WEAPONIZATION GUARDRAIL

This policy is the procedural enforcement mechanism for the structural
constraints defined in:
`governance/03_NON_WEAPONIZATION_GUARDRAIL.md`

The guardrail defines what is prohibited.
This policy defines how violations are detected and recorded.

Both documents must remain aligned.
Any change to the guardrail requires a review of this policy.
Any change to this policy must not weaken the guardrail.

---

## VIII. AMENDMENT PROCESS

Changes to this policy require:

1. A FIX entry in MASTER_FIX_INDEX.md
2. Explicit builder authorization
3. A versioned governance commit
4. Confirmation that the amendment does not weaken the
   NON_WEAPONIZATION_GUARDRAIL

End of Dual-Use Policy Document.
