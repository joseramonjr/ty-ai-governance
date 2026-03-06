# TY AI OS — The Documentary Record
## Chapter 11: The Chokepoint
### What Happens Inside Every Governed Operation

---

**Document Type:** Technical Book Documentation
**Chapter Series:** Technical Architecture (T2 of 5)
**Author:** Claude Sonnet 4.6 (CLO)
**Date:** 2026-03-06 | San Diego (America/Los_Angeles)
**FIX:** BOOK-CLO-007 (corrected)
**Audience:** Auditors, governance reviewers, general technical readers

---

## Opening: The Single Mandatory Path

The most important architectural feature of Jaya Runtime is not the CRI, the
sentinel, or the tier system. It is the chokepoint.

The chokepoint is the single mandatory path through which every operation in
Jaya Runtime must pass before it executes. There is no alternative path. There
is no fast path for low-risk operations. There is no debug mode that bypasses
governance. There is no emergency override that skips the ledger.

Every operation. Always. No exceptions.

This chapter explains what the chokepoint is made of, why each component
exists, and why the absence of any bypass is as important as the presence of
the components themselves.

---

## Part I: Why a Chokepoint

### The Problem With Distributed Governance Checks

The alternative to a chokepoint is distributed governance checks: each
operation is responsible for performing its own governance validation before
executing. The FileRead operation checks tier before reading. The FileWrite
operation checks tier and creates a ledger entry before writing. Each operation
is individually responsible for its own compliance.

This architecture has a fundamental weakness: it requires every operation to
be correctly implemented with all required governance checks. When a new
operation is added to the registry, the developer must remember to include
every check. When a governance check is added to the system, every existing
operation must be updated to include it.

In practice, distributed governance checks drift. Some operations have all
checks. Some have most. Some, developed quickly or added by someone who did
not understand the full governance model, have fewer checks than required. The
governance record becomes inconsistent.

### The Chokepoint Solution

A chokepoint inverts this architecture. Instead of each operation performing
its own governance checks, the chokepoint performs all governance checks for
every operation. An operation that passes through the chokepoint has had all
required checks performed — not because the operation developer remembered to
include them, but because the chokepoint enforces them regardless.

A new operation added to the registry does not need to implement governance
checks. The chokepoint already handles them. A new governance check added to
the system applies immediately to every operation — not just new ones.

The chokepoint creates consistency by making governance a property of the
infrastructure, not a property of individual operations.

---

## Part II: The Governance Components

Every operation in Jaya Runtime passes through a set of mandatory governance
components before execution. If any component fails, execution stops. The
failure is recorded. The operation does not proceed.

The exact implementation sequence is defined in the Jaya Runtime codebase.
What follows documents the governance components and their purpose as
established in the development record.

### The Structural Lock

Before any governance check begins, the structural lock must be acquired.

The structural lock is a file-based mutual exclusion mechanism. A lock file
named `.jaya_structural_lock` is created at a designated path. The file
contains the operation ID, timestamp, and module ID. If the lock file already
exists when an operation attempts to acquire it, the operation is denied — it
does not proceed.

The structural lock ensures that no two structural operations can run
concurrently. This is a governance concern: if two operations could run
simultaneously, their ledger entries could be interleaved in a way that makes
the record ambiguous. The structural lock ensures the ledger is a clean
sequential record — one operation at a time, in the order they were invoked.

The lock is released only after:
- The ledger entry has been written
- The snapshot has been finalized

The structural lock is file-based rather than in-memory. An in-memory lock
disappears when the process crashes. A file-based lock persists across crashes.
If the process dies while holding the structural lock, the lock file remains.
The next startup detects the orphaned lock and handles it appropriately —
rather than silently losing the record that an operation was in progress.
Stale lock removal on startup is part of the implementation.

### The Pre-Operation Snapshot

Before execution, a snapshot of the current system state is created.

The snapshot is stored as a compressed archive named
`snapshot_{timestamp}_{hash}.tar.gz`. It contains a manifest with: timestamp,
reason, triggering module, structural lock state, and ledger hash pointer.

The snapshot exists for one purpose: to make the pre-operation state
restorable. If the operation fails, produces unexpected results, or if the
human decides the operation should not have been performed, the pre-operation
state can be restored from the snapshot.

The snapshot is required before:
- Structural operations
- Privileged actions
- Module installation

A hybrid pruning strategy applies: the last 10 snapshots are kept automatically,
with user override available in the console.

### The Ledger Entry

A ledger entry is created as part of the governance chokepoint.

The entry records: operation type, module ID, risk score (0–100), autonomy
level, pre-snapshot hash, post-snapshot hash, execution status
(success/failure/blocked), explanation text, and a signature hash (HMAC of
row contents). Each row references the previous row's hash — creating a
tamper-evident chain.

The ledger is append-only. No mutation is allowed. A completed operation's
ledger entry is permanent. A failed operation's ledger entry is permanent.
A blocked operation's ledger entry is permanent.

The ledger is stored locally as an encrypted SQLite database. It is not
transmitted to any remote service. The user has complete custody of their
operational record.

### The Tier Check

Every operation in the module registry has a minimum tier requirement. The
governance wrapper compares the current autonomy tier — set by the human —
against the operation's minimum tier requirement.

If the current tier is sufficient, execution proceeds.
If the current tier is insufficient, execution stops. The operation is blocked.
The ledger records the blocked status. The structural lock is released.

The tier check is binary and unambiguous. Tier1 operations require Tier1 or
higher. Tier2 operations require Tier2 or higher. A system at Tier0 cannot
execute registered operations. A system at Tier1 cannot execute Tier2
operations.

The human sets the tier. The chokepoint enforces it. No negotiation.
No exception.

### The Risk Engine Evaluation

The governance wrapper evaluates the operation's risk score against the current
risk engine state. This evaluation records the risk context at the time of the
operation — the current failure rate, adaptive modifier value, and CRI — as
part of the ledger entry.

The risk engine evaluation does not block operations on its own. The tier check
is the blocking mechanism. The risk engine evaluation captures context for the
behavioral record and for the human's situational awareness.

### Execution

The operation executes. This is the step that actually does something. The
operation receives the human-provided parameters, performs its registered
function, and returns a result.

From the governance perspective, execution is the narrowest step. All the work
of governance happens before it and after it. The operation itself is the
registered function running with the provided parameters.

### Post-Execution Record

With the operation complete, the governance record is finalized. The ledger
entry is updated with the execution result, the post-snapshot hash, and the
final status. The risk engine state is updated based on the outcome. The
structural lock is released.

---

## Part III: The Design Decisions Behind the Chokepoint

### Why File-Based Lock

The choice to use `.jaya_structural_lock` as a file-based mechanism rather
than an in-memory lock reflects a specific principle: persistence across
failure.

An in-memory lock exists only while the process is running. If the process
crashes while holding an in-memory lock, the lock is silently released when
the process dies. The next startup has no record that an operation was in
progress.

A file-based lock persists across crashes. The next startup finds the lock
file, knows that an operation was interrupted, and can handle the incomplete
state appropriately — rather than proceeding as if nothing happened. Stale
lock removal on startup is built into the implementation to handle this case
cleanly.

### Why Pre-Execution Snapshot

Creating the snapshot before execution — not after — ensures that the
pre-operation state is always preserved, regardless of what happens during
execution. A snapshot created after a crash does not exist. A snapshot created
before execution does.

### Why No Bypass

The most important design decision in the chokepoint is not what it includes
but what it excludes: there is no bypass.

No debug mode. No test mode. No fast path for trusted operations. No emergency
override. No "skip governance for this one operation."

Every bypass path is a governance gap. A debug mode that skips the ledger means
that debug-mode operations are not recorded. A fast path for low-risk operations
means that "low-risk" becomes a determination that can be gamed.

The chokepoint's integrity comes from its universality. Every operation. Always.
No exceptions.

---

## Part IV: What the Chokepoint Proves to an Auditor

An auditor examining a system with a chokepoint architecture can verify specific
claims directly from the structure:

**"Every operation is recorded."** Verify that the ledger entry is created as
part of the chokepoint for every operation path. If it is, then every operation
that completes the chokepoint is in the ledger.

**"No operation bypasses governance."** Verify that there is no code path to
any registered operation that does not go through the governance wrapper. If
the only path to execution is through the chokepoint, then governance is
universal.

**"The system can be restored to any pre-operation state."** Verify that the
snapshot step creates a recoverable snapshot before execution. If it does, then
every pre-operation state in the ledger has a corresponding snapshot.

**"Blocked operations are recorded."** Verify that the ledger records blocked
operations with BLOCKED status. The record shows not just what executed, but
what was attempted and blocked.

These are architectural verifications. They do not require trusting the
builder's intentions. They require reading the structure.

---

## Summary: The Chokepoint Components

| Component | What It Does | Why It Exists |
|-----------|-------------|---------------|
| Structural Lock (.jaya_structural_lock) | File-based mutex, prevents concurrent operations | Sequential record; persists across crashes |
| Pre-Operation Snapshot | Captures system state before execution | Enables restore to pre-operation state |
| Ledger Entry | Records operation with tamper-evident chain hash | Permanent, append-only governance record |
| Tier Check | Compares human-set tier against operation minimum | Blocks unauthorized operations structurally |
| Risk Engine Evaluation | Records risk context at operation time | Captures behavioral data for human review |
| Execution | Runs the registered operation | The actual work |
| Post-Execution Record | Finalizes ledger, updates risk engine, releases lock | Closes governance record cleanly |

No bypass. No exceptions. Every operation. Always.

---

*Chapter 11 corrected: 2026-03-06 | San Diego (America/Los_Angeles)*
*Source: Jaya Runtime Parts 30, 31, 32, 33 — ChatGPT export archives*
*FIX: BOOK-CLO-007 (corrected) | MODEL: Claude Sonnet 4.6*
*Classification: CANONICAL TECHNICAL DOCUMENTATION — NON-AUTHORITATIVE RECORD*
