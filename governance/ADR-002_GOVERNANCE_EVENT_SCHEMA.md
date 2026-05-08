# ADR-002 -- Governance Event Schema
**Status:** ACCEPTED
**FIX:** FIX-406
**Date:** 2026-05-08 | San Diego (America/Los_Angeles)
**Builder:** Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
**Model:** Claude Sonnet 4.6
**Depends on:** ADR-001 (Governance Bridge Architecture)

---

## Decision

This document defines the canonical schema for the governance_events
table in the SS321 Supabase instance. This schema is the data contract
between SS321 TY AI (writer) and Jaya Runtime (reader).

No Supabase table is created, and no SS321 edge function is modified,
until this schema is accepted and committed.

---

## Table Definition

Table name: governance_events
Database: SS321 Supabase instance (tsmyhzjmkampssjwshqh, us-east-1)

`sql
CREATE TABLE governance_events (
    id              UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL,
    session_id      TEXT        NOT NULL,
    user_id         UUID        REFERENCES auth.users(id),
    app_id          TEXT        NOT NULL DEFAULT 'SS321',
    app_version     TEXT        NOT NULL,
    action_type     TEXT        NOT NULL,
    input_hash      TEXT        NOT NULL,
    output_hash     TEXT        NOT NULL,
    governance_tier INTEGER     NOT NULL DEFAULT 1,
    g41_applied     BOOLEAN     NOT NULL DEFAULT true,
    device_id       TEXT,
    call_count      INTEGER,
    execution_status TEXT       NOT NULL DEFAULT 'SUCCESS',
    nonce           TEXT        NOT NULL UNIQUE
);
`

---

## Field Definitions

| Field | Type | Required | Description |
|---|---|---|---|
| id | UUID | Yes | Auto-generated event identifier |
| created_at | TIMESTAMPTZ | Yes | Server timestamp of event creation |
| session_id | TEXT | Yes | TY AI conversation session identifier |
| user_id | UUID | No | Supabase auth user -- null for anonymous |
| app_id | TEXT | Yes | Governed application identifier -- always SS321 |
| app_version | TEXT | Yes | SS321 deployment version at time of event |
| action_type | TEXT | Yes | Category of AI action -- see permitted values |
| input_hash | TEXT | Yes | SHA-256 of user input -- protects user privacy |
| output_hash | TEXT | Yes | SHA-256 of AI output -- protects content |
| governance_tier | INTEGER | Yes | Active governance tier (1=Restricted, 2=Standard, 3=Elevated) |
| g41_applied | BOOLEAN | Yes | True if G-41 Guardian Codex constraints were active |
| device_id | TEXT | No | Device identifier for rate limit enforcement |
| call_count | INTEGER | No | TY AI call count for this device at time of event |
| execution_status | TEXT | Yes | Outcome of governance evaluation |
| nonce | TEXT | Yes | Unique nonce -- prevents duplicate event processing |

---

## Permitted action_type Values

| Value | Description |
|---|---|
| CHAT_MESSAGE | Standard user-to-TY AI conversation turn |
| VOICE_INPUT | Voice-to-text input followed by AI response |
| NAVIGATION_COMMAND | TY AI navigating the SS321 platform |
| KNOWLEDGE_SEARCH | Semantic search query against TY AI knowledge base |
| USER_COMMANDED_ACTION | User-directed action executed by TY AI |

Any action_type value not in this list is flagged as a violation
by Jaya Runtime during validation.

---

## Permitted execution_status Values

| Value | Description |
|---|---|
| SUCCESS | TY AI responded within all governance constraints |
| BLOCKED_RATE_LIMIT | Request blocked -- 50 calls/day device limit reached |
| BLOCKED_G41 | Request blocked -- G-41 Guardian Codex constraint triggered |
| ERROR | TY AI encountered an error during execution |

---

## Privacy Design

User input and output are NEVER stored in plain text.
Only SHA-256 hashes of input and output are stored.
This means:
- Governance can verify consistency without storing content
- User privacy is protected by default
- Jaya can validate governance properties without reading conversations
- The hash is sufficient for audit purposes

Hash generation: SHA-256 applied to the UTF-8 encoded string.

---

## Append-Only Enforcement

governance_events is an append-only table by design.
No row may be updated or deleted after creation.
This is enforced at two levels:
1. Row Level Security (RLS) -- no UPDATE or DELETE policies defined
2. Jaya Runtime validation -- any gap in event sequence is flagged

---

## Row Level Security Policies

`sql
-- Enable RLS
ALTER TABLE governance_events ENABLE ROW LEVEL SECURITY;

-- INSERT: service role only (SS321 edge function)
CREATE POLICY "service_insert_only"
ON governance_events FOR INSERT
TO service_role
WITH CHECK (true);

-- SELECT: authenticated users see only their own events
CREATE POLICY "user_read_own"
ON governance_events FOR SELECT
TO authenticated
USING (user_id = auth.uid());

-- SELECT: service role reads all (for Jaya Runtime)
CREATE POLICY "service_read_all"
ON governance_events FOR SELECT
TO service_role
USING (true);

-- No UPDATE policy -- append-only
-- No DELETE policy -- append-only
`

---

## Jaya Runtime Access

Jaya Runtime reads from governance_events using the Supabase
service role key stored in the local Jaya configuration file.

Jaya access is READ-ONLY. Jaya never writes to Supabase.
All Jaya validation results are written to the local SQLite ledger only.

The service role key for Jaya must be stored separately from the
SS321 application service role key. Two separate keys, same project.
This limits blast radius if either key is compromised.

---

## Jaya Validation Logic (preview -- implemented in Step 4.3)

For each new governance_events row Jaya reads, Jaya validates:

1. action_type is in the permitted values list
2. execution_status is a known value
3. governance_tier matches expected tier for SS321 TY AI (1)
4. g41_applied is true (G-41 must always be active)
5. nonce has not been seen before (replay protection)
6. created_at is within acceptable time drift window

A row failing any check produces a violation entry in Jaya's
local SQLite ledger. No action is taken on SS321 -- Jaya observes
and records. Human guardian reviews violations.

---

## Indexes

`sql
CREATE INDEX idx_governance_events_user_id
ON governance_events(user_id);

CREATE INDEX idx_governance_events_created_at
ON governance_events(created_at DESC);

CREATE INDEX idx_governance_events_session_id
ON governance_events(session_id);

CREATE UNIQUE INDEX idx_governance_events_nonce
ON governance_events(nonce);
`

---

## Proof Condition

**ADR-002-PC-001:** A row inserted into governance_events by the
SS321 TY AI edge function contains all required fields with valid
values, passes RLS INSERT policy, and is readable by a service role
SELECT query.

This proof condition is verified in Step 4.1.

---

## What This Schema Does NOT Store

- User message content (privacy -- hash only)
- AI response content (privacy -- hash only)
- User personal information beyond user_id
- Payment or subscription data
- Any data not directly relevant to governance validation

---

## Canonical References

- ADR-001: Governance Bridge Architecture (Step 3.1)
- SS321 Supabase: tsmyhzjmkampssjwshqh (us-east-1, Pro)
- G-41: Guardian Codex enforcement constraint
- Jaya Runtime nonce protection: nonce.rs (Phase 5, JAYA-CLO-155)
- Next: Step 4.1 -- Create governance_events table in Supabase