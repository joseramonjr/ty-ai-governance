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
