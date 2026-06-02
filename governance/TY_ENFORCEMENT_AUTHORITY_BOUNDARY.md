# TY AI OS -- Enforcement Authority Boundary
# Supabase Visibility vs. SQLite Enforcement

**Status:** ACTIVE
**FIX:** FIX-704 · Entry-722
**Established:** 2026-06-02 | San Diego (America/Los_Angeles)
**Closes:** OAQ-002 CAT-1-003 (GAP -- no explicit written rule)
**Authority:** Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.

---

## Rule

**Supabase holds visibility state only. Enforcement authority never
leaves local SQLite.**

---

## What This Means

TY AI OS operates two distinct persistence layers with distinct roles
that must never be confused or merged:

**Local SQLite (Jaya Runtime)**
- The enforcement authority
- All governance decisions are made here
- All policy checks execute here
- The append-only ledger lives here
- Offline operation is full -- no degradation
- No third party can read, modify, or interrupt it

**Supabase (cloud)**
- Visibility state only
- Receives governance events AFTER they are recorded in SQLite
- Enables public monitoring (TYOVA EcosystemFlowPage, SS321 /status)
- Cannot issue governance decisions
- Cannot override or modify enforcement results
- Its unavailability does not affect enforcement

---

## The Authority Chain

Jaya Runtime (local) --> SQLite (local) --> Supabase (cloud, visibility only)

Enforcement always flows left to right. Authority never flows right
to left. Supabase is a downstream recipient of governance records,
not a participant in producing them.

---

## What This Rule Prohibits

1. Any component reading from Supabase to make a governance decision
2. Any governance enforcement path that requires Supabase to be online
3. Any architecture where Supabase unavailability degrades enforcement
4. Any future design that grants Supabase write authority over
   governance state in local SQLite
5. Luke AI reading Supabase directly -- the correct path is
   Jaya writes Supabase-sourced events into SQLite;
   Luke reads them through SQLite (established ADQ-041)

---

## What This Rule Permits

1. Jaya writing governance events to Supabase after SQLite commitment
2. TYOVA and public surfaces reading from Supabase for display
3. Jayme reading Supabase event streams for drift monitoring
4. External auditors verifying governance state via Supabase read access

---

## Why This Rule Exists

Governance that depends on a third-party cloud service for enforcement
authority can be interrupted, modified, or surveilled by that third
party. Local-first enforcement ensures the guardian retains full
control at all times. The authority remains on the guardian's machine.

This principle is established in ADR-002 (Supabase as message queue
only) and ADR-003 (SQLite append-only ledger as canonical record).
This document makes the boundary explicit as a binding rule, closing
the gap identified in OAQ-002 CAT-1-003.

---

## Canonical References

- ADR-002: Supabase bridge architecture -- Jaya holds authority,
  Supabase holds record
- ADR-003: SQLite append-only ledger as canonical governance record
- ADQ-041: Luke AI must never read Supabase directly
- OAQ-002 CAT-1-003: Gap -- enforcement authority boundary not
  explicitly documented

---

## Enforcement

This rule is a governance invariant. It cannot be amended by session
decision. Any proposed architecture that violates this boundary
requires a formal ADR with explicit rationale and builder
authorization before implementation.

---

## Three-Layer Classification
## Retroactive application per FLAG-137 | FIX-713 | 2026-06-02 15:01 PDT San Diego

### Constitutional Layer (Permanent -- Cannot Be Amended by F-19)

The rule that enforcement authority never leaves local SQLite is a
constitutional constraint. It is derived from the Local-First Doctrine
(ADR-002), the Deny-by-Default principle (GIQ-047), and the structural
requirement that no third party can interrupt, read, or modify Jaya
enforcement decisions. This constraint cannot be changed through the
normal Phase 12 governed evolution process. Any proposal to move
enforcement authority to a cloud layer requires a full architectural
rebuild and explicit guardian authorization at the constitutional level.

This rule does not change when:
- The federation grows to hundreds of nodes
- New AI agents are added to the ecosystem
- Jaya Runtime is extended with new capabilities
- A new guardian inherits the system
- External parties apply pressure to adopt a cloud-first model

**AI Era Clause:**
As AI capabilities advance, no AI component of TY AI OS may claim that
its capability level justifies reading this rule more permissively. A
more capable AI does not earn more permissive authority over enforcement
architecture. Capability advancement narrows scrutiny -- it does not
expand permission.

**External Pressure Resistance:**
No government, court, regulatory body, enterprise customer, or any
external organization can compel a more permissive interpretation of
this rule through legal authority, commercial agreements, or regulatory
directive. The guardian chain is closed (C4-001, C4-002, GIQ-025,
GIQ-026). External pressure is not a path to architectural change.
The only path to change is Phase 12 F-19 governed evolution with
explicit guardian authorization and permanent ledger record.

**AI-Assisted Governance:**
AI-assisted interpretation is a tool for the guardian, not a
replacement for the guardian. The guardian authorizes. The AI assists.
This hierarchy does not invert regardless of how capable the AI
becomes. No AI system may produce a binding interpretation of this
rule without guardian review, confirmation, and authorization via
Git commit.

### Architectural Layer (Current Design -- Defined Evolution Path)

The two-layer persistence architecture -- local SQLite as enforcement
authority, Supabase as downstream visibility layer -- is the current
architectural implementation of the constitutional constraint. This
architecture was established in ADR-024 (Supabase as Message Queue,
Not Governance Authority). Future phases may extend the architecture
-- for example, Phase 15 federation may introduce multi-node SQLite
coordination -- but any extension must preserve the constitutional
constraint: enforcement authority remains local and no cloud layer
may issue governance decisions.

### Operational Layer (Current-State Specifics -- Subject to Authorized Change)

The specific enforcement modules (supabase_writer.rs, supabase_reader.rs),
the specific Supabase project IDs, and the specific governance tables
(jaya_audit_events, jaya_governance_reports, jaya_execution_receipts,
jaya_agents) are operational specifics reflecting the Phase 14 baseline.
Operational specifics may be updated with builder authorization and a
governance record entry (MFI + Ch18). Changes to operational specifics
do not require constitutional-layer review provided they do not alter
the enforcement-stays-local constraint.