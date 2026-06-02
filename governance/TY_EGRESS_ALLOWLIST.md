# TY AI OS -- Jaya Runtime Egress Allowlist
# Formal Network Destination Authorization

**Status:** ACTIVE
**Version:** v0.1 -- Phase 14 baseline
**FIX:** FIX-705 · Entry-723
**Established:** 2026-06-02 | San Diego (America/Los_Angeles)
**Closes:** OAQ-002 CAT-1-006 (GAP -- no formal egress allowlist document)
**Authority:** Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.

---

## Governing Principle

All outbound network traffic from Jaya Runtime is blocked unless
explicitly listed in this document. This is the Deny-by-Default
Egress invariant -- established 2025-12-28 19:40 San Diego
(GIQ-047, C1-008, Ch26 Egress Gateway term).

TY cannot reach the internet without an explicit outbound permission
grant. Every outbound connection must pass through the Egress Gateway.
This invariant does not change across phases, versions, or deployment
configurations. It is a constitutional layer constraint.

Unauthorized outbound connections are the primary exfiltration vector.
A governance system that can reach the internet at will can exfiltrate
data, contact external authorities, or receive instructions from
external sources without the guardian's knowledge. Deny-by-default
egress means TY cannot phone home, receive external instructions, or
initiate any connection unless the guardian has explicitly authorized
those specific destinations in this document.

---

## Section 1 -- Currently Authorized Destinations
## Phase 14 Baseline -- Three Entries

All three entries are confirmed active as of FIX-705 (2026-06-02).

---

### Entry E-001 -- TYOVA Governance Supabase

**Host:** utzkoozekztyztdxejij.supabase.co
**Protocol:** HTTPS (port 443)
**Purpose:** TYOVA-dedicated governance tables. Jaya reads and writes
governance events to the TYOVA governance Supabase project, separate
from SS321 user data.
**Modules:** supabase_reader.rs, supabase_writer.rs
**Established:** ADQ-051 (FIX-646) -- dedicated TYOVA-governance
Supabase project, separated from SS321 user data by architectural
decision
**Direction:** Bidirectional (read + write)
**Authorization date:** 2026-05-26 PDT San Diego

---

### Entry E-002 -- SS321 Production Supabase (Governance Bridge)

**Host:** tsmyhzjmkampssjwshqh.supabase.co
**Protocol:** HTTPS (port 443)
**Purpose:** SS321 production governance bridge. Jaya reads SS321
governance events via supabase_reader.rs and writes governance
observations to jaya_audit_events via supabase_writer.rs. This is
the live host connection -- SilverSounds321.com is the first
real-world TY AI OS host.
**Modules:** supabase_reader.rs, supabase_writer.rs
**Established:** FIX-569 (2026-05-21) -- bidirectional governance
bridge proven live. First write confirmed 2026-05-21 19:05:23 UTC.
**Direction:** Bidirectional (read + write)
**Authorization date:** 2026-05-21 PDT San Diego

---

### Entry E-003 -- Resend Email API (Guardian Alert Delivery)

**Host:** api.resend.com
**Protocol:** HTTPS (port 443)
**Purpose:** Push email alerts to the guardian when significant
governance events occur -- CRI Critical band, Sentinel anomaly,
verification failure, or other high-severity conditions. Guardian
should be notified; guardian should not have to watch a dashboard
indefinitely to discover that something has occurred.
**Modules:** email_alert.rs
**Established:** FIX-572 (2026-05-21) -- guardian alert system
**Direction:** Outbound only (write)
**Scope:** Scoped to silversounds321.com sender identity only
**Authorization date:** 2026-05-21 PDT San Diego

---

## Section 2 -- Future Destination Categories
## Not Yet Authorized -- Paths Defined for Future Phases

The following categories are anticipated based on confirmed
architectural design in the TY AI OS roadmap. None of these
destinations are currently authorized. Each will be formally
added to Section 1 via the amendment process (Section 3) when
the corresponding phase is opened and the architecture is defined.

This section exists so future guardians, builders, and auditors
know exactly what egress expansion is expected, why, and what
process governs it. It is a governance signal, not a permission.

---

### Future Category F-001 -- Federation Peer-to-Peer Communication

**Phase:** Phase 15+ (FLAG-136, ADR-029)
**Why anticipated:** TY AI OS supports four governance paths for
external operators (Path 1 through Path 4, established Phase 10,
FIX-508). Paths 3 and 4 are federated. Federation requires Jaya
nodes to exchange attestation payloads for cross-node governance
verification (Cross-Node Attestation, built Phase 5 Track B,
Part 84, JAYA-CLO-163). When federation is live, each node must
be able to reach authorized peer nodes to exchange
AttestationExchangePayload records and verify governance state.
**Constraint when added:** Each federation peer endpoint must be
individually listed in Section 1. No wildcard federation domain
is permitted. Each peer is a named, authorized destination.
**Authority non-propagation applies:** A verified attestation
from a peer grants that peer zero authority over the local node's
governance. Cross-node attestation is verification only, never
authority transfer.
**Not yet authorized -- requires Phase 15 federation ADR.**

---

### Future Category F-002 -- External Verifier Endpoints

**Phase:** Phase 15+ (TY-0001.C release, Compliance Proof Kit)
**Why anticipated:** TY-0001.C will include the TY Compliance
Proof Kit (FIX-561, Entry-580). External builders adopting TY AI
OS governance may need to submit compliance verification requests
or query a federation compliance registry. If a public compliance
verification endpoint is established, it will require an egress
entry.
**Not yet authorized -- requires dedicated compliance ADR.**

---

### Future Category F-003 -- Knowledge Layer Sync

**Phase:** Phase 15+ (ADR-029 -- TY AI Ecosystem Knowledge Layer)
**Why anticipated:** ADR-029 defines a machine-readable knowledge
layer derived from ty-ai-governance canonical documents, stored
in SQLite alongside the Jaya ledger, queryable by all TY AI
components at runtime. If this knowledge layer is distributed
or synced across federation nodes, an egress destination will
be required.
**Constraint when added:** Knowledge layer is read-only for AI
components. Updates require builder authorization. No AI component
may write to the knowledge layer via network.
**Not yet authorized -- requires ADR-029 implementation ADR.**

---

### Future Category F-004 -- Additional Governed Host Connections

**Phase:** As new TY AI OS hosts are onboarded beyond SS321
**Why anticipated:** SS321 (silversounds321.com) is the first
real-world TY AI OS host. Future hosts (Path 2, Path 3, Path 4
operators) may require dedicated Supabase or equivalent governance
bridge connections analogous to E-001 and E-002.
**Constraint when added:** Each new host connection requires its
own Section 1 entry with host, protocol, purpose, module,
direction, and authorization date. No host is added by code
change alone.
**Not yet authorized -- each new host requires its own FIX.**

---

## Section 3 -- Amendment Process

Adding any new authorized destination to Section 1 requires all
of the following. No exception.

1. A dedicated FIX with explicit rationale for the new destination
2. MFI entry (MASTER_FIX_INDEX.md) in the same session
3. Ch18 entry (TY_BOOK_CHAPTER_18) in the same session
4. Builder authorization: Jose Ramon Alvarado McHerron AKA
   Jose Ramon Bautista Jr.
5. This document updated and committed to ty-ai-governance before
   the corresponding code change is committed

The governance document is updated first. The code follows.
A code change that contacts an unlisted destination before this
document is updated is a governance violation regardless of intent.

---

## Section 4 -- Permanently Prohibited Destination Classes

The following destination classes may never be added to Section 1
regardless of phase, use case, or architectural argument. These
are constitutional layer prohibitions derived from the
Non-Weaponization Guardrail (FIX-36.00, 2026-02-18) and the
five structural guardrails of TY AI OS.

1. Any external AI inference endpoint or model API -- TY AI OS
   governance must not depend on external AI decision-making
2. Any telemetry, analytics, crash reporting, or usage tracking
   service -- no data about guardian behavior leaves the system
3. Any surveillance, monitoring, or population processing service
4. Any kinetic or offensive capability endpoint
5. Any service that would grant a third party authority over
   local governance state
6. Any endpoint added without guardian knowledge or authorization

These prohibitions hold across all phases, all deployment
configurations, and all federation sizes.

---

## Section 5 -- Canonical References

- GIQ-047: Deny-by-default egress -- locked answer
- C1-008: Conscience Thread -- deny-by-default egress invariant
- Ch26: Egress Gateway, Deny-by-Default Egress vocabulary terms
- ADQ-051: TYOVA dedicated Supabase project (utzkoozekztyztdxejij)
- FIX-569: SS321 bidirectional governance bridge established
- FIX-572: Guardian email alert system (email_alert.rs)
- ADR-029: TY AI Ecosystem Knowledge Layer -- Phase 15+ scope
- FLAG-136: Phase 15+ scope flag
- Phase 10 FIX-508: Four governance paths including federated paths
- Phase 5 Track B Part 84 JAYA-CLO-163: Cross-node attestation
  (foundation for future federation egress)
- Non-Weaponization Guardrail FIX-36.00: Prohibited destination
  classes basis
