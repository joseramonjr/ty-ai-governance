# TY AI OS -- Ledger Layer Distinction
# SQLite Enforcement Ledger vs. MFI Documentation Layer

**Status:** ACTIVE
**Version:** v0.1 -- Phase 14 baseline
**FIX:** FIX-706 · Entry-724
**Established:** 2026-06-02 | San Diego (America/Los_Angeles)
**Closes:** OAQ-002 CAT-1-011 (GAP -- no explicit distinction between
  SQLite enforcement ledger and MFI documentation layer)
**Authority:** Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.

---

## Governance Layer Classification

This document contains rules at three layers. Each layer has
different amendment rules and different survival expectations
as TY AI OS scales.

**Constitutional layer** -- never changes regardless of scale,
phase, AI capability advancement, or federation size. These rules
hold whether TY governs one agent or one million across a global
federation. Amendment requires full governed evolution process
(Phase 12, F-19).

**Architectural layer** -- governs current design with a defined
evolution path. Will change as TY scales. Amendment requires a
dedicated FIX with explicit rationale, MFI + Ch18 entries, and
builder authorization. No silent change permitted.

**Operational layer** -- current-state specifics. Expected to be
updated as the ecosystem grows. File paths, tool names, and
current phase references fall here. Amendment follows standard
FIX discipline.

---

## Core Rule (Constitutional Layer)

**TY AI OS operates two distinct ledger layers. They serve
different purposes, operate at different speeds, and neither
is a substitute for the other. This distinction is permanent
and holds at any scale.**

This rule does not change when:
- The federation grows to hundreds of nodes
- New AI agents are added to the ecosystem
- Jaya Runtime is extended with new capabilities
- The tooling changes or the file paths move
- A new guardian inherits the system

The two-layer architecture is a constitutional invariant because
collapsing the layers -- treating runtime enforcement records as
documentation, or treating documentation as proof of enforcement
-- destroys the auditability that makes TY AI OS trustworthy.

---

## Layer 1 -- SQLite Enforcement Ledger (Constitutional)

**What it is:** The live runtime record of every governance
decision Jaya Runtime makes at the moment it makes it.

**Written by:** Jaya Runtime automatically -- no human action
required or permitted for individual entries.

**Written when:** Before every operation executes. The ledger
entry is created BEFORE the operation runs, not after (C10-003).
This ensures that even catastrophic failures appear in the record.

**Content:** Every governance event, policy check, CRI evaluation,
agent action, violation, escalation, tier change, attestation,
and sentinel scan that Jaya Runtime processes.

**Append-only:** Yes -- no DELETE, no UPDATE, ever. This is a
constitutional constraint, not a configuration option (C10-002,
ADR-003). A ledger that can be deleted is not a ledger.

**Speed:** Real-time. Entries are created at the moment of
operation -- millisecond precision.

**Authority:** The enforcement authority. What happened at runtime
is defined by what is in this ledger. No other source overrides it.

**Audience:** Jaya Runtime itself (enforcement decisions), Luke AI
(read-only via SQLite), external auditors with direct database
access.

**Scale invariant:** This layer must exist and operate identically
whether Jaya is governing 5 agents or 5,000. At larger scale the
volume grows; the structure and append-only constraint do not change.

**Cannot be substituted by:** MFI entries, chat conversations,
memory, Supabase records, or any external source.

---

## Layer 2 -- MFI Documentation Layer (Constitutional Structure,
## Operational Details)

**What it is:** The human governance record of every intentional
change made to any TY AI OS component, written by the builder at
session close.

**Written by:** Builder (Jose Ramon Alvarado McHerron AKA Jose
Ramon Bautista Jr.) -- or future authorized guardian -- at every
session close. No automated system writes MFI entries.

**Written when:** Session close -- every FIX receives an MFI entry
in the same session it is created (R14). A session that closes
without MFI entries for all open FIXes is a governance violation.

**Content:** Every FIX applied to any TY ecosystem component --
what changed, when, in which repo, under which commit, with what
San Diego timestamp, and why.

**Append-only:** Yes -- MFI entries are immutable once committed
(Ledger Discipline, Ch26). This is constitutional -- the historical
record cannot be rewritten.

**Speed:** Session-close cadence. MFI lags the runtime by up to
one full work session. This lag is expected and acceptable -- MFI
documents intent, not millisecond-by-millisecond enforcement.

**Authority:** The documentation authority. What was intentionally
changed and why is defined by what is in MFI. It is the human
layer of the audit chain.

**Audience:** Humans -- builders, guardians, auditors, future
maintainers, external verifiers reading the governance history.

**Scale invariant:** As TY scales to federation and external
deployment, the MFI discipline must be maintained by whoever
holds builder or guardian authority. The append-only constraint
and session-close gate do not relax at any scale.

**Cannot be substituted by:** SQLite ledger data, Supabase
records, chat conversations, or memory.

---

## What Each Layer Is NOT (Constitutional)

These distinctions are permanent regardless of scale or phase.

**SQLite enforcement ledger is NOT:**
- A human-readable governance narrative
- A record of why architectural decisions were made
- A substitute for MFI documentation
- The place to look for FIX history or design intent
- Evidence that a change was intentionally authorized

**MFI documentation layer is NOT:**
- Evidence of runtime enforcement behavior
- A record of what Jaya actually enforced at runtime
- A substitute for SQLite enforcement data
- Real-time -- it lags runtime by up to one full session
- Queryable by Jaya Runtime, Luke AI, or Jayme

---

## How They Work Together (Architectural Layer)

The two layers are complementary, not redundant. A complete
governance audit requires both.

**SQLite answers:** What did Jaya Runtime actually do, when,
and with what result?

**MFI answers:** What did the builder change, when, in which
repo, and under which commit?

**Current audit chain (Phase 14):**
Runtime event --> SQLite ledger entry (real-time)
Builder change --> MFI entry + Ch18 entry (session close)
Session close --> Six-gate TY-ANCHOR Session-Close.ps1 verification

**Future audit chain (Phase 15+ federation):**
The same two-layer structure applies across all federation nodes.
Each node maintains its own SQLite enforcement ledger. The MFI
documentation layer remains the single builder-maintained
governance record for the canonical ty-ai-governance repository.
Federation nodes do not write to MFI -- they maintain their own
local documentation records per the governance path they operate
under (Path 1 through Path 4, Phase 10).

---

## The Session Bridge (Operational Layer)

At session close the builder writes MFI entries documenting
the FIXes applied that session. This synchronizes the two layers.

**Current tooling (Phase 14):**
- TY-ANCHOR Session-Close.ps1 (six-gate enforcement)
- MASTER_FIX_INDEX.md at canonical path
- TY_BOOK_CHAPTER_18 as companion ledger

**Future tooling:** As TY AI OS scales, the session-close
tooling may evolve. The constitutional requirement -- every FIX
documented in MFI in the same session -- does not change.
The tools that enforce it may be replaced or extended.

---

## Future-Scale Considerations (Architectural Layer)

As TY AI OS grows the following architectural questions will
arise. This section names them so future builders and guardians
know they are anticipated, not edge cases.

**Federation node ledgers:** Each federation node will maintain
its own SQLite enforcement ledger. These are not merged into a
central ledger -- authority non-propagation applies. Each node's
ledger is the enforcement authority for that node only.

**Guardian succession and MFI:** When guardian succession
activates (Phase 14 P1, succession_chain.rs), the incoming
guardian must be trained on MFI discipline before they can
maintain the documentation layer. The Guardian Codex
(TY_GUARDIAN_CODEX_v0.1.md) governs this transition.

**External operator documentation:** Path 2, 3, and 4 operators
(Phase 10) maintain their own FIX ledgers per their governance
path. The canonical MFI (this repo) covers only the core TY AI
OS ecosystem -- TYOVA, Jaya Runtime, ty-ai-governance, SS321.
External operator ledgers are governed by their own charters.

**AI-assisted documentation:** Future AI capabilities may assist
in drafting MFI entries. The constitutional constraint is that
MFI entries require builder or guardian authorization and Git
commit -- regardless of who or what drafts the content.

---

## Canonical References

- ADR-003: SQLite append-only ledger as canonical governance record
- C10-002: Conscience Thread -- append-only ledger, no delete,
  no update (Part 30/44)
- C10-003: Conscience Thread -- pre-execution ledger entry creation
- Ch26 Ledger Discipline: SQLite and MFI append-only rules
- Ch26 FIX Discipline: MFI sequential numbering and session
  discipline
- GIQ-013: Chat not canonical -- governance requires Git commits
  + Ch18 + MFI entries
- R14: Every fix receives sequential FIX ID + MFI + Ch18 +
  San Diego timestamp in the same session
- TY-ANCHOR Session-Close.ps1: Six-gate session-close enforcement
- TY_GUARDIAN_CODEX_v0.1.md: Guardian succession and MFI
  discipline transfer
- Phase 10 FIX-508: Four governance paths -- external operator
  documentation responsibilities
