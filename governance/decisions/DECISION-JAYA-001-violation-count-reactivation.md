# DECISION-JAYA-001 — Violation Count Behavior on Agent Reactivation

**Status:** CANONICAL  
**Date:** 2026-03-08  
**Author:** Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.  
**Recorded by:** Claude Sonnet 4.6 | San Diego  
**FIX #:** JAYA-CLO-069  

---

## Decision

Violation counts on an AgentRecord are **permanent and cumulative**.

When an agent is reactivated (status changed from `Suspended` or `Revoked` back to `Active`), the violation count is **not reset**. The count carries forward across all status transitions for the lifetime of the agent.

---

## Rationale

- Violation counts are a governance audit signal, not a behavioral state
- Resetting on reactivation would destroy historical accountability
- The count is persisted to SQLite and restored on boot — it is part of the permanent record
- Operators must make reactivation decisions with full knowledge of prior violation history

---

## Enforcement

- `AgentRegistry::log_violation()` increments the count unconditionally
- `AgentRegistry::set_status()` does not touch the violation count
- `db::persist_status()` updates only the status column — violation_count column is untouched
- `db::persist_violation()` increments violation_count in the DB unconditionally

---

## Scope

Applies to all Jaya Runtime versions from Part 38 onward.  
This decision is sealed as part of Part 41 Group D.
