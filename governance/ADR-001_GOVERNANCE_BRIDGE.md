# ADR-001 -- Governance Bridge Architecture
**Status:** ACCEPTED
**FIX:** FIX-405
**Date:** 2026-05-08 | San Diego (America/Los_Angeles)
**Builder:** Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
**Model:** Claude Sonnet 4.6

---

## Decision

**Supabase as shared state** is the governance bridge architecture for
connecting a local Jaya Runtime to cloud-hosted governed applications.

This is the general pattern. SS321 (SilverSounds321) is the first
implementation. The pattern applies to any future governed application.

---

## Context

TY AI OS is a local-first governance system. Jaya Runtime runs on the
user's machine. Governed applications (such as SS321) run in the cloud.

The fundamental tension: a local enforcement engine must govern a
cloud-hosted application without being deployed to the cloud itself.

This is not a limitation -- it is the design. Local-first governance
means the user's machine is the authority. The cloud application reports
to the local engine, not the other way around.

---

## The General Pattern
### Governed Application Responsibilities
- Write a governance event row after every AI interaction
- Event contains: session_id, user_id, timestamp, action_type,
  input_hash, output_hash, governance_tier, execution_status
- Rows are append-only -- no update or delete permitted
- RLS enforced -- only authenticated app service role may insert

### Jaya Runtime Responsibilities
- Poll governance_events table on a defined interval
- Validate each new event against active governance invariants
- Write validation result to local SQLite ledger
- Flag violations for human review
- Never modify the Supabase table -- read-only access only

---

## Why This Preserves Local-First Doctrine

Jaya Runtime remains on the user's machine. It never moves to a server.
The Supabase table is a message queue -- not a governance authority.
Governance authority stays local. The cloud application is the reporter.
The local Jaya is the validator. This is the correct direction of authority.

---

## Rejected Alternatives

### Path 2 -- Jaya Deployed to Cloud
**Rejected.** A cloud-hosted Jaya Runtime violates the sealed local-first
doctrine. The kill switch, the ledger, and the governance authority must
remain on the user's machine. Deploying Jaya to a server removes user
sovereignty over governance. This path requires a formal doctrine
amendment -- it is not available as an implementation shortcut.

### Path 3 -- Not a Separate Path
Path 3 (per-user local Jaya governs their own SS321 experience) is the
same architecture as Path 1 applied to each individual user. When the
TY AI OS bundle ships, every user who installs it runs this same pattern.
Path 1 and Path 3 are the same design at different scales.

---

## SS321 -- First Implementation

SS321 (silversounds321.com) is the first governed application to implement
this pattern. The governed component is the SS321 TY AI feature (the
Claude Sonnet edge function at supabase/functions/ty-ai-chat/index.ts).

SS321 implementation steps (detailed in Steps 4.1 through 4.4):
- Step 4.1: Create governance_events table in SS321 Supabase instance
- Step 4.2: Modify ty-ai-chat edge function to write governance events
- Step 4.3: Add Supabase reader to Jaya Runtime
- Step 4.4: Verify end-to-end -- event written, read, validated, ledger entry

---

## Governance Event Schema (preview -- detailed in ADR-002)

The exact event schema is defined in Step 3.2 (ADR-002). Preview:

| Field | Type | Description |
|---|---|---|
| id | UUID | Event identifier |
| session_id | TEXT | User session |
| user_id | UUID | Supabase auth user |
| timestamp | TIMESTAMPTZ | Event time |
| action_type | TEXT | Type of AI action |
| input_hash | TEXT | SHA-256 of user input |
| output_hash | TEXT | SHA-256 of AI output |
| governance_tier | INTEGER | Active tier at time of event |
| execution_status | TEXT | SUCCESS or BLOCKED |
| validated_by_jaya | BOOLEAN | Default false -- set by Jaya |

---

## Proof Condition

**ADR-001-PC-001:** A governance event written by SS321 TY AI to the
Supabase governance_events table is read by a local Jaya Runtime,
validated against governance invariants, and produces a ledger entry
in Jaya's local SQLite database.

This proof condition is met in Step 4.4.

---

## Canonical References

- TY AI OS local-first doctrine: Part 2 Book of TY
- Jaya Runtime: E:\TY-Ecosystem\Jaya-Runtime
- SS321 Supabase: tsmyhzjmkampssjwshqh (us-east-1, Pro)
- Master Action Plan Steps 3.1 through 4.4
- Next: ADR-002 -- Governance Event Schema (Step 3.2)