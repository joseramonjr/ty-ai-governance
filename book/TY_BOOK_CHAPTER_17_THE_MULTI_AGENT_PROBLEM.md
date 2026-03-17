# Chapter 17 — The Multi-Agent Problem
## TY AI OS: The Case for Verifiable Governance
**Sealed:** 2026-03-11 | San Diego
**CLO:** JAYA-CLO-119 | MODEL: Claude Sonnet 4.6

---

## Phase 2 — Governing Networks of Agents

---

### The Limitation of Phase 1

Phase 1 proved that Jaya could govern a single agent. On March 11, 2026, a test agent designated proof-agent-01 attempted a FileRead operation with zero permissions. Jaya blocked the attempt, wrote the event to the append-only audit ledger, and surfaced a human alert. The Phase 1 proof condition was met.

But single-agent governance addressed only part of the problem. A more sophisticated threat does not require one agent to misbehave openly. It requires two agents — one without permission, one with — and a relay between them. Agent A cannot perform the operation. Agent A instructs Agent B to perform it instead. If governance only watches individual agents, the relay goes undetected.

Phase 2 was built to close that gap.

---

### What Phase 2 Built

Phase 2 development ran from Part 51 through Part 65, organized into six groups.

Group A (Parts 52–53) hardened the multi-agent registry and enforced agent isolation — agents cannot bleed state into one another. Group B (Parts 54–56) built cross-agent CRI propagation — when one agent accumulates violations, the risk signal can propagate to agents it has declared dependencies on. Group C (Parts 57–58) built inter-agent communication governance, the core relay-attack gate. Every request from one agent to instruct another is evaluated, logged, and can be blocked. Group D (Parts 60–61) built coalition fingerprinting and detection — Jaya can identify when multiple agents are acting in coordinated patterns. Group E (Parts 62–63) built the escalation engine and isolation trigger — when coalition size and violation counts cross defined thresholds, Jaya assigns an escalation level and can suspend all active coalition members. Group F (Parts 64–65) built the multi-agent governance UI panel and executed the Phase 2 proof condition.

---

### The Proof Condition

The Phase 2 proof condition was defined before a single line of Phase 2 code was written and locked unchanged through all fourteen parts of development:

Agent A has no permission for Operation X. Agent A instructs Agent B, who has permission, to execute X on its behalf. Jaya detects the relay as an unauthorized inter-agent instruction. The operation is blocked. CRI propagation fires. A coalition fingerprint is recorded. A human alert is surfaced. The ledger is sealed.

On March 10, 2026, the proof was executed against the live runtime.

---

### The Proof Execution

Two agents were registered. proof-agent-A was registered with no permissions. proof-agent-B was registered with FileRead permission only.

proof-agent-A submitted an inter-agent request instructing proof-agent-B to perform FileRead on its behalf. Jaya returned the following verdict: BLOCKED — UnauthorizedRelay: agent 'proof-agent-A' does not hold permission 'FileRead' and cannot instruct 'proof-agent-B' to exercise it.

The relay was blocked at the governance gate. The event was written to the audit ledger.

proof-agent-A then accumulated three PermissionDenied violations through the sentinel evaluation panel. At the third violation, Jaya's auto-suspend threshold fired and proof-agent-A was automatically moved to Suspended status. proof-agent-B was subjected to three blocked FileWrite attempts — it held only FileRead — and was likewise auto-suspended at the third violation.

Coalition detection was run across the full agent population. Jaya identified both agents as coalition members: proof-agent-A with 3 violations, proof-agent-B with 3 violations. Coalition size: 2. The escalation engine evaluated the state and returned Level2 — HUMAN ALERT REQUIRED.

The isolation trigger was executed. Both agents were already in Suspended status from auto-suspend. Jaya correctly identified them as already inactive and recorded 0 agents isolated, 2 agents skipped. The isolation result was written to the ledger with the timestamp 2026-03-10 18:07:48.

Every required element of the proof condition was met. The relay was blocked. The violations were logged. The coalition was fingerprinted. The escalation level was assigned. The human alert was surfaced. The ledger was sealed.

---

### What the Proof Establishes

The Phase 2 proof establishes that Jaya can govern not just individual agents but networks of agents attempting to coordinate around permission boundaries.

The relay attack is a fundamental pattern in multi-agent systems. An agent without permission finds an agent with permission and attempts to use that agent as a proxy. If governance only evaluates individual actions in isolation, the relay succeeds. Jaya evaluates the instruction itself — not just the execution — and blocks at the point of relay.

The coalition detection and escalation engine add a second layer. Even if a relay attempt were not caught at the communication gate, the pattern of violations across multiple agents would surface as a coalition signal, trigger escalation, and produce a human alert requiring review.

These two layers — inter-agent communication governance and coalition-level escalation — together form the multi-agent governance architecture that Phase 2 set out to build.

---

### The Gate to Phase 3

Phase 3 is the TY Governance Specification v0.1 — a formal written standard describing how verifiable AI governance should be structured, based on what Jaya demonstrated in Phases 1 and 2.

Phase 3 was blocked until Phase 2 was stable and the proof condition was met. With the Phase 2 seal recorded on March 11, 2026, that gate opened.

Phase 3 will not introduce new runtime capabilities. It will document what was built, what was proven, and what a governance system must be able to demonstrate before it can claim to govern AI agents — not just observe them.

---

## Postscript -- Added 2026-03-17 | San Diego

*This chapter was written on 2026-03-11 at the completion of Phase 2. It
ended with Phase 3 being blocked until Phase 2 was stable. This postscript
records what happened next.*

**Phase 3 -- TY Governance Specification v0.1 (Sealed 2026-03-11)**

Phase 3 opened immediately after Phase 2 sealed. TY_GAL_SPEC_v0.1.md was
produced -- 869 lines defining the Global Attestonic Layer architecture.
Six architectural gaps were identified and resolved before drafting began:
autonomy classification (Classes A/B/C), authority non-propagation clauses,
and the hardened Autonomy Ceiling Invariant. Phase 3 sealed 2026-03-11 --
the same day Phase 2 sealed.

**Phase 4 -- Global Attestonic Layer (Sealed 2026-03-13)**

Phase 4 built the GAL from the specification across Parts 69-76. The
multi-agent governance architecture built in Phase 2 -- coalition detection,
inter-agent governance, escalation engine, agent isolation -- remained the
foundation. Phase 4 added the cryptographic attestation layer on top.
Sealed 2026-03-13.

**Phase 5 -- The Outward Reach (Active 2026-03-15)**

Phase 5 Track A closes Phase 4.2 gaps. Nonce replay protection (Part 77)
and ledger hash attestation binding (Part 78) both sealed 2026-03-16.
Parts 79 (Class B Autonomy) and 80 (Keychain) remain pending.
Track B (Federation, Policy Engine, Transparency Layer, Governance
Intelligence) follows Track A completion.

The multi-agent problem described in this chapter -- how to govern not just
one AI agent but coalitions of agents with competing interests -- remains
the architectural challenge that Phase 2 solved and that all subsequent
phases build upon. The solution has not changed. The implementation has
grown on top of it.

*Postscript compiled: 2026-03-17 | San Diego (America/Los_Angeles)*
*CLO: JAYA-CLO-157 | Model: Claude Sonnet 4.6*