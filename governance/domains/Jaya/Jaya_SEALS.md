# Jaya_SEALS

Status: Active
Domain: Jaya Runtime
Canonical Timezone: America/Los_Angeles

---

## Overview

This file records all formal seal declarations for Jaya Runtime Parts.
Seals are immutable once recorded.

---

## Seal Records

| Seal FIX | Part | Date | Status |
|---|---|---|---|
| Pre-repo | Parts 1–34 | Pre-2026-02-18 | COMPLETE (backfill pending) |
| FIX-35.99 | Part 35 | 2026-02-18 | SEALED — IMMUTABLE |

---

## Seal Definitions

### Part 35 — CRI Lifecycle Completion and Authority Reservation
Sealed by FIX-35.99 on 2026-02-18 (America/Los_Angeles).

Scope sealed:
- CRI accumulation implemented
- Hard cap at 100
- Deterministic decay at minus 1 every 2 seconds
- Persistence on anomaly events only
- Startup restore implemented
- Safe getter exposed
- CRI designated Future-Authorizable Modifier Input
- No behavioral coupling active at seal time

This seal is immutable. No retroactive modification permitted.

---
## Part 38 — Agent Registry Foundation
Sealed by FIX-38.99 on 2026-03-07 (America/Los_Angeles).
Commit: 49bf9e2 | Tag: jaya-part-38
Model: Claude Sonnet 4.6 | San Diego

Scope sealed:
- FileRead and FileWrite registered in ModuleRegistry at boot
- AgentRegistry created as separate governed surface from ModuleRegistry
- AgentPermission enum: FileRead, FileWrite, LedgerRead, SnapshotRead
- AgentStatus enum: Active, Suspended, Revoked
- AgentViolation struct with per-agent violation count tracking
- AgentRecord struct: identity, permissions, status, violation_count, registered_at
- 9 Tauri commands exposed: register_agent, get_agent, get_all_agents,
  log_agent_violation, get_agent_violations, get_all_agent_violations,
  set_agent_status, check_agent_permission, get_agent_count

Architectural decision (canonical, immutable):
Agents are NOT JayaModules. External AI agents are governed and monitored
by Jaya — not executed by it. AgentRegistry and ModuleRegistry are
permanently separate surfaces. This separation must not be collapsed
in any future part.

Book flag: Part 38 opens Chapter X — Governing the Outside World.
Chapter closes when agent monitoring is live (Part 39+).

This seal is immutable. No retroactive modification permitted.
