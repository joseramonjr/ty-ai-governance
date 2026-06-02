# TY AI OS -- Offline Fail-Closed Rule
# Jaya Runtime Degraded State Governance

**Status:** ACTIVE
**Version:** v0.1 -- Phase 14 baseline
**FIX:** FIX-708 · Entry-726
**Established:** 2026-06-02 | San Diego (America/Los_Angeles)
**Closes:** OAQ-002 CAT-2-010 (GAP -- no explicit rule stating Jaya
  offline means fail-closed not fail-open)
**Authority:** Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
**Related:** FLAG-138 -- Federation Network Partition Governance
  (Phase 15+ scope -- backup connectivity architecture deferred)

---

## Governance Layer Classification

**Constitutional layer** -- the fail-closed rule itself is eternal.
When Jaya Runtime loses connectivity or operates in a degraded state,
it always becomes more restrictive, never less. This holds at any
scale, in any phase, under any AI capability level. It cannot be
amended by any process.

**Architectural layer** -- the three-tier degraded state response
model (Option A/B/C) reflects the designed evolution path as TY
scales to federation. Option A is implemented today. Option B
is the Phase 15 threshold design. Option C is deferred to FLAG-138.

**Operational layer** -- specific threshold values, current component
names, and current connectivity endpoints. These change as the
ecosystem grows.

---

## The Rule (Constitutional Layer)

**When Jaya Runtime loses network connectivity, loses its Supabase
connection, or operates in any degraded state, it fails closed.
It becomes more restrictive. It never becomes more permissive.**

Fail-closed means:
- Local enforcement continues at full strength
- No governance action is suspended because connectivity is lost
- No agent receives expanded permissions during degraded operation
- No enforcement path requires network connectivity to function
- Degraded state is a signal to become more conservative, not less

Fail-open is permanently prohibited. A system that relaxes its
governance constraints when it cannot verify its state is a system
that can be exploited by deliberately inducing connectivity failures.

---

## Why This Rule Is Constitutional

Local-first is a governance decision, not a privacy decision
(GIQ-028). The kill switch must work completely independent of
any network connection. A system that weakens enforcement when
offline has made network connectivity a dependency of governance
-- which means anyone who can cut the network connection can
weaken governance. This is an unacceptable attack surface.

TY AI OS enforcement authority lives in local SQLite, not in
Supabase, not in any cloud service (ADR-002, ADR-003,
TY_ENFORCEMENT_AUTHORITY_BOUNDARY.md FIX-704). Network
connectivity is visibility. Enforcement is local. These must
never be confused. When visibility is lost, enforcement does
not change.

This rule becomes more critical at federation scale. A network
partition that isolates a node from its peers must not cause
that node to become more permissive. An adversary who can
induce a partition must not gain governance advantage from it.

---

## What Fail-Closed Means in Practice (Architectural Layer)

### Current State -- Option A (Phase 14, Active)

When Jaya Runtime loses connectivity today:

**What continues without interruption:**
- All local enforcement decisions via SQLite ledger
- All policy checks and CRI evaluations
- All agent action governance
- All violation recording
- All tier enforcement
- Kill-switch dominance
- Guardian succession monitoring (local)

**What is suspended until connectivity is restored:**
- Supabase governance event writes (visibility layer only)
- Guardian email alerts via Resend API
- Cross-node attestation verification (if federation active)
- TYOVA EcosystemFlowPage live updates (display layer only)

**What the guardian sees:**
Jaya Runtime continues operating. The TYOVA public display
goes stale. Email alerts stop. When connectivity is restored,
Supabase writes resume and the governance record catches up.
The local SQLite ledger contains the complete enforcement
history for the offline period -- nothing is lost.

**Key principle:** Suspended items are all visibility layer.
Zero enforcement items are suspended. The governance record
is complete and continuous in local SQLite regardless of
how long the node is offline.

---

### Phase 15 Design -- Option B (Isolation Threshold,
### Not Yet Implemented)

As TY scales to federation, extended isolation of a node from
its peers represents an elevated risk. A node that cannot verify
its peers for an extended period may be operating on stale
attestation data. Option B addresses this with an automatic
tier drop after an isolation threshold is exceeded.

**Design intent (not yet implemented):**

If a federation node -- a Jaya Runtime instance, distinct from
TYOVA EcosystemFlowPage WARDs which are display components only
-- cannot perform cross-node attestation verification for longer
than a defined isolation threshold, it automatically drops to a
more restrictive autonomy tier until peer connectivity is restored
and attestation is re-verified.

This threshold will be added to TY_CANONICAL_THRESHOLDS_REGISTRY
as a new entry (T-25 or next available) when Phase 15 federation
architecture is defined. The threshold is guardian-configurable
per deployment within bounds set by the canonical registry.

**This is not punishment for isolation.** It is a recognition
that a node operating without peer verification for an extended
period has less information about the governance state of its
federation. Less information warrants more caution.

**Analogy to existing thresholds:**
T-09 (JAYA_SILENT, 10 minutes) detects when Jaya stops writing
to Supabase. The Option B isolation threshold will similarly
detect when a federation node stops receiving peer attestations
and respond with automatic tier reduction.

**Not yet authorized -- requires Phase 15 federation ADR.**

---

### Future Infrastructure -- Option C (Backup Connectivity,
### FLAG-138, Phase 15+)

Option C addresses the question of whether Jaya Runtime should
have a secondary network path when the primary fails -- a backup
Supabase endpoint, peer-to-peer direct connections, or local
network fallbacks for federation communication.

This is infrastructure engineering work that requires:
- Its own dedicated ADR defining the architecture
- Security analysis of backup path attack surfaces
- Definition of which visibility functions use which paths
- Guardian authorization for any new egress destinations
  (per TY_EGRESS_ALLOWLIST.md FIX-705)

**See FLAG-138 for the full scope definition and three
architectural options. Option C is deferred to Phase 15.**

The fail-closed rule (Option A) does not depend on backup
connectivity being implemented. Option A holds regardless
of whether Option C is ever built.

---

## Exploitation Resistance (Constitutional)

This section addresses deliberate attacks that attempt to exploit
the offline state to weaken governance.

**Attack vector: induced connectivity failure**
An adversary who can cut Jaya Runtime's network connection must
not gain any governance advantage from doing so. The fail-closed
rule ensures cutting the network makes governance more
conservative, not less. There is no benefit to the attacker
from inducing offline state.

**Attack vector: extended isolation**
An adversary who can maintain a network partition for an extended
period must not cause governance to degrade. Option A holds
enforcement constant during isolation. Option B (Phase 15)
adds automatic tier reduction after the isolation threshold --
making extended isolation even less advantageous to an attacker.

**Attack vector: false reconnection**
When connectivity is restored after an isolation period, Jaya
Runtime must not automatically grant expanded permissions on
the assumption that reconnection means the isolation is over.
Reconnection restores visibility functions. It does not change
the enforcement tier. Tier restoration requires explicit
guardian action or the standard tier governance process.

**At federation scale:** A node that rejoins a federation after
isolation must re-verify cross-node attestation before resuming
full federation participation. Reconnection alone is not
sufficient. Verified attestation is required.

---

## What Fail-Open Would Mean (Constitutional -- Prohibited)

For clarity, this section explicitly states what fail-open
behavior looks like so it can be recognized and rejected.

Fail-open would mean any of the following -- all permanently
prohibited:

1. Suspending enforcement decisions when Supabase is unreachable
2. Allowing agents to take unevaluated actions during offline
   periods on the grounds that the evaluation system is unavailable
3. Reducing CRI sensitivity during degraded operation to avoid
   generating alerts that cannot be sent
4. Granting temporary elevated permissions during offline periods
   to maintain operational continuity
5. Treating offline state as an implicit authorized healing window
6. Reducing tier restrictions automatically when network is lost
7. Resuming full federation participation after isolation without
   re-verifying cross-node attestation

None of these are operational accommodations. All of them are
governance failures that create exploitable attack surfaces.

---

## Future-Scale Considerations (Architectural Layer)

**Federation network partitions:** In a multi-node federation,
network partitions are not edge cases -- they are expected
operational events. Every federation node must be designed with
the assumption that it will experience isolation periods. The
fail-closed rule ensures isolation never degrades governance.
Option B (Phase 15) adds proactive tier management during
extended isolation.

**Multi-guardian deployments:** When TY AI OS scales to
deployments with multiple guardians across multiple time zones,
offline periods for individual nodes become more common. The
fail-closed rule means a guardian in a different time zone
does not need to take emergency action when a node goes offline
-- enforcement continues locally and the visibility gap is
recorded in SQLite for review when connectivity is restored.

**Adversarial AI environments:** As AI capabilities advance,
adversarial AI systems may attempt to exploit governance gaps
during offline periods. The fail-closed rule means there are
no governance gaps during offline periods to exploit. Local
enforcement is continuous and unconditional.

**WARDs and offline state:** TYOVA EcosystemFlowPage WARDs
(the 24 visual display panels -- visibility layer only, no
enforcement authority) will show stale data during a Jaya
offline period. This is expected and correct. Stale WARD
display does not indicate governance failure -- it indicates
a visibility gap. The enforcement record in local SQLite
remains complete and current.

---

## Canonical References

- ADR-002: Local-first -- governance authority never leaves the
  guardian's machine
- ADR-003: SQLite append-only ledger as canonical governance record
- GIQ-028: Local-first is a governance decision -- kill switch
  requires local-first
- TY_ENFORCEMENT_AUTHORITY_BOUNDARY.md (FIX-704): Supabase
  visibility only -- enforcement authority never leaves local SQLite
- T-09: JAYA_SILENT threshold -- analog for isolation detection
- FLAG-138: Federation Network Partition Governance -- backup
  connectivity architecture (Phase 15+)
- C10-002: Conscience Thread -- append-only ledger, no delete,
  no update -- offline periods fully recorded
- Phase 12 F-19: Governed evolution -- only process by which
  tier management thresholds can be formally established
- TY_EGRESS_ALLOWLIST.md (FIX-705): Any backup connectivity
  paths require egress allowlist amendment
