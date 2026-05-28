# TY_ARCHITECTURAL_DECISIONS_RECORD.md
# TY AI OS -- Central Architectural Decisions Register
# FIX-661 | Entry-679 | 2026-05-27 | San Diego
# Builder: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
#
# PURPOSE
# Every significant architectural question asked during TY AI OS development,
# with the options considered, the decision made, and the rationale.
# This file is the single source of truth for WHY the system was built
# the way it was. Future guardians, auditors, and patent reviewers
# should consult this file before asking why any design choice was made.
#
# FORMAT
# Each entry is an ADR (Architectural Decision Record).
# New ADRs are appended at the bottom. Never modify past entries.
# Reference: CLO session, FIX number, Phase, or date where the decision occurred.
#
# GOVERNANCE
# This file is governed by the Zero-Fabrication Rule.
# Only confirmed builder decisions are recorded here.
# Speculation, assumptions, and deferred questions are NOT recorded as decisions.

---

## SECTION 1 -- FOUNDING ARCHITECTURE

---

### ADR-001 -- TY AI OS Mission: Governance-First, Not Feature-First

**Date:** 2025-08 (origin) -- crystallized 2025-12
**Phase:** Founding
**Question:** What is the primary purpose of TY AI OS? An AI assistant with
  governance features, or a governance system that happens to include AI?
**Options considered:**
  A. AI assistant with governance as a safety layer added on top
  B. Governance infrastructure that proves AI can be structurally constrained
**Decision:** Option B. TY AI OS is governance-first. The AI components
  exist to demonstrate governance, not the other way around.
**Rationale:** The value proposition of TY AI OS is provability. An assistant
  with governance bolted on can always argue the governance is theater.
  A governance system that enforces structure at the architecture level
  cannot make that argument because the structure IS the system.
**Builder confirmed:** Jose Ramon Alvarado McHerron
**Reference:** Book of TY Ch1, TY_GUARDIAN_CODEX_v0.1.md

---

### ADR-002 -- Local-First Doctrine

**Date:** 2025-12
**Phase:** Founding
**Question:** Where does governance execution live -- locally on the
  builder's machine or in a cloud service?
**Options considered:**
  A. Cloud-hosted governance (Supabase, Vercel, or similar)
  B. Local-first -- governance runs on the builder's machine
**Decision:** Option B. Jaya Runtime executes locally. Supabase is a
  message queue and event log, not a governance authority.
**Rationale:** Governance that depends on a third-party service can be
  interrupted, modified, or surveilled by that third party. Local-first
  ensures the guardian retains full control. The authority remains
  on the user's machine.
**Builder confirmed:** Jose Ramon Alvarado McHerron
**Reference:** ADR-001 in bookChapterContent.ts (commit b686525)

---

### ADR-003 -- SQLite Append-Only Ledger as Governance Record

**Date:** 2025-12 / Phase 1
**Phase:** Phase 1
**Question:** What is the canonical record of all governance events?
**Options considered:**
  A. Cloud database (Supabase)
  B. Local SQLite with append-only enforcement
  C. Flat files on disk
**Decision:** Option B. SQLite ledger running locally, append-only by
  design -- no DELETE, no UPDATE on governance entries.
**Rationale:** Append-only prevents history rewriting. Local prevents
  third-party access. SQLite provides a queryable, structured record
  without network dependency.
**Builder confirmed:** Jose Ramon Alvarado McHerron
**Reference:** ledger.rs, TY_BOOK_CHAPTER_14_LEDGER.md

---

### ADR-004 -- Ed25519 as the Cryptographic Primitive

**Date:** Phase 1 / Phase 5-6
**Phase:** Phase 1 (established), Phase 5-6 (GAL implementation)
**Question:** Which cryptographic algorithm for signing governance proofs?
**Options considered:**
  A. RSA (widely known, larger keys)
  B. Ed25519 (modern, fast, small keys, strong security)
  C. ECDSA secp256k1
**Decision:** Option B. Ed25519 for all governance attestations.
**Rationale:** Ed25519 is the modern standard for digital signatures.
  Small key size (32 bytes), fast signing, strong security guarantees,
  and native support in the Rust ed25519-dalek crate used throughout
  Jaya Runtime.
**Builder confirmed:** Jose Ramon Alvarado McHerron
**Reference:** keychain.rs, TY_GAL_SPEC_v0.1.md, TY_CANONICAL_THRESHOLDS_REGISTRY.md T-06

---

### ADR-005 -- Tier 0-3 Autonomy System

**Date:** Phase 1
**Phase:** Phase 1
**Question:** How should AI autonomy be structured and enforced?
**Options considered:**
  A. Binary (allowed / not allowed)
  B. Tiered system with escalating autonomy levels
**Decision:** Option B. Four tiers: Tier 0 (maximum restriction),
  Tier 1 (restricted), Tier 2 (standard), Tier 3 (elevated).
**Rationale:** Binary systems have no gradation -- any deviation triggers
  full shutdown. A tiered system allows proportional response to risk,
  and CRI-based automatic escalation without requiring human action
  for every governance event.
**Builder confirmed:** Jose Ramon Alvarado McHerron
**Reference:** risk_engine.rs, TY_BOOK_CHAPTER_10_ARCHITECTURE.md

---

### ADR-006 -- SilverSounds321 as First Live Host of TY AI OS

**Date:** 2025-12-02
**Phase:** Founding / Phase 1
**Question:** Where does TY AI OS first operate in a real-world context?
**Decision:** SilverSounds321 (silversounds321.com) -- a live independent
  music platform built simultaneously with TY AI OS.
**Rationale:** TY AI OS needs a real governed application to prove its
  principles are not theoretical. SS321 serves as the first genuine
  production deployment, making the governance claims verifiable in
  a live public system.
**Builder confirmed:** Jose Ramon Alvarado McHerron
**Reference:** TY_BOOK_CHAPTER_01, supabase_writer.rs, jaya_audit_events table

---

## SECTION 2 -- RUNTIME ARCHITECTURE

---

### ADR-007 -- Jaya Runtime as Governance-Grade AI Runtime

**Date:** Phase 1-2 (crystallized in Jaya Part 32)
**Phase:** Phase 2
**Question:** What kind of system is Jaya Runtime? An AI assistant or
  a governance execution engine?
**Options considered:**
  A. Governance-enhanced AI assistant (conversational + governed)
  B. Governance-grade AI runtime (governance enforcement as primary function)
**Decision:** Option B. Jaya Runtime is a governance-grade AI runtime.
  The distinction is: Jaya enforces, it does not converse. The governance
  structures are the product, not a wrapper around a product.
**Rationale:** This fork decision (Jaya Part 32 in ChatGPT history,
  confirmed in FIX-659 audit) is the single most important architectural
  choice in TY AI OS. It determines every downstream design decision.
**Builder confirmed:** Jose Ramon Alvarado McHerron
**Reference:** Jaya Part 32 (ChatGPT history), TY_GUARDIAN_CODEX_v0.1.md

---

### ADR-008 -- CRI Deterministic Decay Rate

**Date:** Phase 2
**Phase:** Phase 2
**Question:** How does the Cumulative Risk Index recover during normal operation?
**Decision:** Deterministic decay: CRI decreases by 1 per 2 seconds during
  normal operation. No human action required.
**Rationale:** Manual CRI reset would require guardian attention for every
  governance cycle. Deterministic decay allows the system to self-correct
  from past anomalies while maintaining a live risk signal.
**Builder confirmed:** Jose Ramon Alvarado McHerron
**Reference:** TY_CANONICAL_THRESHOLDS_REGISTRY.md T-14, Jaya_SEALS.md

---

## SECTION 3 -- CRYPTOGRAPHIC AND ATTESTATION DECISIONS

---

### ADR-009 -- GAL Attestation Freshness Window = 30 Seconds

**Date:** Phase 5-6
**Phase:** Phase 6 (GAL implementation)
**Question:** How old can an attestation payload be before it is considered stale?
**Decision:** 30 seconds. A payload older than 30 seconds from its
  timestamp is rejected as stale.
**Rationale:** Governance verification must reflect the current state.
  A 30-second window prevents replay of old proofs while tolerating
  minor network latency. The proof refresh interval was aligned to
  30 seconds in FIX-660 (F-01 Resolution A).
**Builder confirmed:** Jose Ramon Alvarado McHerron
**Reference:** TY_CANONICAL_THRESHOLDS_REGISTRY.md T-06, TY_GAL_SPEC_v0.1.md line 378
**F-01 note:** Documentation previously stated 60 seconds in multiple files.
  Resolved in FIX-660: 30 seconds is canonical throughout.

---

### ADR-010 -- Proof Refresh Interval = 30 Seconds (F-01 Resolution A)

**Date:** 2026-05-27 (F-01 resolution)
**Phase:** Phase 14 / FIX-660
**Question (F-01):** The GAL spec says 30-second freshness window but
  multiple documentation files said Jaya generates proofs every 60 seconds.
  Which is correct?
**Options considered:**
  A. 30 seconds throughout (GAL spec is canonical, all 60s references wrong)
  B. 60 seconds throughout (implementation was correct, spec was wrong)
  C. Both intentional -- different mechanisms
  D. 60 seconds for external reference implementations, 30 for Jaya
**Decision:** Resolution A -- 30 seconds throughout.
**Rationale:** A proof generated every 60 seconds but valid for only 30
  seconds means it is stale for half of every cycle. External verifiers
  would see governance failures during normal operation. 30 seconds
  throughout eliminates this window and aligns with the GAL spec intent.
**Builder confirmed:** Jose Ramon Alvarado McHerron | 2026-05-27
**Reference:** FIX-660 Entry-678, TY_CANONICAL_THRESHOLDS_REGISTRY.md T-06

---

### ADR-011 -- Nonce Expiry = 30 Seconds

**Date:** Phase 5
**Phase:** Phase 5-6
**Question:** How long before a nonce expires for replay protection?
**Decision:** 30 seconds. After expiry, the nonce is purged from the
  registry. Nonces are single-use -- the 30-second window is for cleanup.
**Rationale:** Aligned with the GAL freshness window (T-06). All
  time-sensitive security mechanisms operate at the same 30-second
  granularity for consistency.
**Builder confirmed:** Jose Ramon Alvarado McHerron
**Reference:** TY_CANONICAL_THRESHOLDS_REGISTRY.md T-19, nonce.rs line 12

---

### ADR-012 -- Key Rotation Grace Period = 300 Seconds

**Date:** Phase 5
**Phase:** Phase 5-6
**Question:** How long does the old key remain valid after a rotation?
**Decision:** 300 seconds (5 minutes). Old key is verifiable within
  the grace period, rejected after.
**Rationale:** In-flight operations signed with the old key need time
  to complete before the key is invalidated. 300 seconds is sufficient
  for any legitimate in-flight governance operation.
**Builder confirmed:** Jose Ramon Alvarado McHerron
**Reference:** TY_CANONICAL_THRESHOLDS_REGISTRY.md T-08, keychain.rs line 29

---

## SECTION 4 -- GUARDIAN AND SUCCESSION DECISIONS

---

### ADR-013 -- Guardian Authorized Healing Window = 24 Hours

**Date:** Guardian Codex authorship
**Phase:** Phase 7-8 (Codex)
**Question:** How long can a Tier 1 guardian operate in reduced
  authority mode before escalation?
**Decision:** 24 hours maximum Authorized Healing Window.
**Rationale:** Long enough to address most operational issues without
  requiring Tier 2 involvement. Short enough to prevent indefinite
  operation without proper authority.
**Builder confirmed:** Jose Ramon Alvarado McHerron
**Reference:** TY_CANONICAL_THRESHOLDS_REGISTRY.md T-01, TY_CONTINUITY_CHARTER_v1.0.md line 159

---

### ADR-014 -- Tier 2 Healing Window Maximum = 72 Hours

**Date:** Guardian Codex authorship
**Phase:** Phase 7-8 (Codex)
**Question:** How long can emergency healing authority last before
  it requires escalation beyond Tier 2?
**Decision:** 72 hours maximum for Tier 2 emergency authority.
**Rationale:** Three days covers any realistic short-term emergency
  while forcing longer situations through proper escalation channels.
**Builder confirmed:** Jose Ramon Alvarado McHerron
**Reference:** TY_CANONICAL_THRESHOLDS_REGISTRY.md T-02, TY_GUARDIAN_CODEX_v0.1.md lines 281-286

---

### ADR-015 -- Guardian Incapacitation Threshold = 1 Year (T-03)

**Date:** Guardian Codex authorship
**Phase:** Phase 7-8 (Codex)
**Question:** After how long without guardian activity does TY AI OS
  assume incapacitation?
**Decision:** 1 year (365 days) of complete inactivity.
  This is the constitutional layer threshold.
**Rationale:** One year is the minimum period after which a guardian
  can reasonably be assumed incapacitated rather than simply traveling
  or temporarily unavailable.
**Builder confirmed:** Jose Ramon Alvarado McHerron
**Reference:** TY_CANONICAL_THRESHOLDS_REGISTRY.md T-03, TY_GUARDIAN_CODEX_v0.1.md lines 925, 955, 979

---

### ADR-016 -- Death Assumption / Jayme Activation = 3 Years (T-04)

**Date:** Guardian Codex + Continuity Charter authorship
**Phase:** Phase 7-8 (Codex + Charter)
**Question:** After how long does TY AI OS assume the guardian has died
  and activate Jayme AI for full succession?
**Decision:** 3 years minimum (Stage 2: 1 year + Stage 3: 1 year +
  Stage 4: 1 year). This threshold is non-negotiable. It cannot be
  shortened by any subsequent instruction.
**Rationale:** Three years ensures the guardian's absence is conclusive
  before irreversible succession actions are taken. False positives
  in succession are catastrophic; three years minimizes them.
**Builder confirmed:** Jose Ramon Alvarado McHerron
**Reference:** TY_CANONICAL_THRESHOLDS_REGISTRY.md T-04, TY_GUARDIAN_CODEX_v0.1.md lines 1046-1052

---

### ADR-017 -- Succession Check-In Window = 365 Days (T-07)

**Date:** 2026-05-27
**Phase:** Phase 14 P1 / FIX-660
**Question (Q1):** What value should T-07 (the Phase 14 runtime check-in
  window) be set to?
**Options considered:**
  A. 72 hours -- matches T-02 (Tier 2 healing maximum)
  B. 7 days -- matches T-05 (deliberation period)
  C. 30 days -- matches T-17 (snapshot retention default)
  D. 365 days -- aligned with T-03 (incapacitation threshold)
  E. Configurable with ceiling
**Decision:** 365 days, aligned with T-03.
**Rationale:** Phase 14's succession chain is the RUNTIME ENFORCEMENT
  of what the Guardian Codex already defines at the constitutional layer.
  Aligning T-07 with T-03 means the runtime drops to Tier 0 at exactly
  the same moment that Jayme assumes incapacitation. The two layers
  synchronize at 1 year. The value of Phase 14 is converting the Codex
  document promise into actual enforced Rust code.
**Builder confirmed:** Jose Ramon Alvarado McHerron | 2026-05-27
**Reference:** TY_CANONICAL_THRESHOLDS_REGISTRY.md T-07, FIX-660 Entry-678

---

### ADR-018 -- Guardian Check-In Mechanism = Ed25519-Signed Heartbeat (Q2)

**Date:** 2026-05-27
**Phase:** Phase 14 P1 / FIX-660
**Question (Q2):** What counts as a valid check-in that resets the T-07 timer?
**Options considered:**
  A. Ed25519-signed heartbeat written to ledger (guardian runs command,
     private key signs, ledger entry created)
  B. Any successful guardian attestation event (broader, could be automated)
  C. Explicit succession-keepalive command (dedicated command only)
**Decision:** Option A -- Ed25519-signed heartbeat.
**Rationale:** This IS the guardian presenting themselves as proof of
  being the guardian. The private key is the proof. Only the guardian
  holds the private key. Cannot be triggered by automation. Cannot be
  forged. The signature IS the identity proof.
**Builder confirmed:** Jose Ramon Alvarado McHerron | 2026-05-27
**Reference:** FIX-660 Entry-678, succession_chain.rs record_guardian_checkin()

---

### ADR-019 -- Succession Recovery = Any Valid Guardian Attestation (Q3)

**Date:** 2026-05-27
**Phase:** Phase 14 P1 / FIX-660
**Question (Q3):** After a Tier 0 drop from succession timeout, what
  is required to restore normal tier operation?
**Options considered:**
  A. Two deliberate acts: re-attest + explicit reset command
  B. Any valid guardian attestation alone (one act sufficient)
**Decision:** Option B -- any valid guardian attestation restores
  normal operation.
**Rationale:** The guardian has already proven identity by signing the
  check-in. Requiring a second explicit reset command adds friction
  without adding security. If the guardian can produce a valid Ed25519
  signature, they are the guardian and the system should restore.
**Builder confirmed:** Jose Ramon Alvarado McHerron | 2026-05-27
**Reference:** FIX-660 Entry-678, succession_chain.rs record_succession_recovery()

---

### ADR-020 -- Succession Module Placement = Own Namespace (Q4)

**Date:** 2026-05-27
**Phase:** Phase 14 P1 / FIX-660
**Question (Q4):** Where does succession_chain.rs live in Jaya Runtime?
**Options considered:**
  A. src/governance/evolution/ -- alongside Phase 12 modules
  B. succession_chain.rs -- own dedicated namespace separate from evolution/
**Decision:** Option B -- own namespace.
**Rationale:** Evolution modules govern WHAT THE RULES ARE (can governance
  change?). Succession governs WHO HAS AUTHORITY (what happens when the
  builder is gone?). Different questions deserve different namespaces.
  Future auditors and builders will understand the architecture faster
  when these concerns are clearly separated.
**Builder confirmed:** Jose Ramon Alvarado McHerron | 2026-05-27
**Reference:** FIX-660 Entry-678, succession_chain.rs

---

## SECTION 5 -- GOVERNANCE PROCESS DECISIONS

---

### ADR-021 -- 7-Day Minimum Deliberation for Governance Rule Changes

**Date:** Phase 12 specification
**Phase:** Phase 12 (Governed Evolution)
**Question:** How long must deliberation remain open before a governance
  rule change can be authorized?
**Decision:** 7 days minimum (604,800 seconds). Enforced in Rust code.
  A test confirms this constant cannot be quietly changed.
**Rationale:** Governance rule changes are irreversible in practical
  terms. Seven days ensures the guardian has time to reflect, consult,
  and identify unintended consequences before committing.
**Builder confirmed:** Jose Ramon Alvarado McHerron
**Reference:** TY_CANONICAL_THRESHOLDS_REGISTRY.md T-05, evolution_deliberation.rs line 29

---

### ADR-022 -- Zero-Fabrication Rule

**Date:** Phase 1 / ongoing
**Phase:** All phases
**Question:** What standard of evidence is required for governance records?
**Decision:** All TY AI OS records must be exactly true with supporting
  primary-source documentation. Where evidence stops, the record stops.
  Claude session memory is NOT a primary source.
**Rationale:** A governance system that fabricates its own records
  cannot be trusted for anything. The Zero-Fabrication Rule is the
  foundation that makes all other governance claims credible.
**Builder confirmed:** Jose Ramon Alvarado McHerron
**Reference:** TY Write Rules, TY-ANCHOR-ETHOS.md

---

### ADR-023 -- Governance Hash v0.2 as Canonical Anchor

**Date:** Phase 7-8
**Phase:** Phase 7-8 (sealed)
**Question:** What is the canonical governance hash that all proofs
  are measured against?
**Decision:** governance_hash v0.2 =
  11ee89f117bad9dd54819792dff8bc0fd5190010b85ea2d9e951b2da5b0a35e2
  Sealed. Cannot be changed without a Phase 12 governed evolution process.
**Rationale:** A fixed governance hash creates a cryptographic anchor
  that all attestations reference. Changing it unilaterally would
  invalidate all prior attestations.
**Builder confirmed:** Jose Ramon Alvarado McHerron
**Reference:** node_identity.rs GOVERNANCE_HASH_V2, FIX-644

---

### ADR-024 -- Supabase as Message Queue, Not Governance Authority

**Date:** Phase 9-10
**Phase:** Phase 9 (Supabase integration, ADR-001 in codebase)
**Question:** What role does Supabase play in TY AI OS governance?
**Options considered:**
  A. Supabase as the governance authority (cloud-first)
  B. Supabase as a shared state / message queue (local-first maintained)
  C. Per-user local Jaya instances
**Decision:** Option B -- Supabase as message queue only.
  Jaya Runtime writes governance events TO Supabase.
  Supabase holds the record; Jaya holds the authority.
**Rationale:** Local-first doctrine (ADR-002) requires authority to
  remain on the builder's machine. Supabase enables external visibility
  (TYOVA, SS321 /status page) without transferring authority.
**Builder confirmed:** Jose Ramon Alvarado McHerron
**Reference:** ADR-001 commit b686525, supabase_writer.rs, supabase_reader.rs

---

### ADR-025 -- Five Fields Exposed via Public Governance RPC

**Date:** Phase 10-11
**Phase:** Phase 10
**Question:** Which governance event fields should be publicly accessible
  via get_governance_events_public / get_jaya_events_public?
**Decision:** Exactly five fields: created_at, action_type,
  execution_status, governance_tier, g41_applied.
**Rationale:** These five fields prove governance is running (action_type),
  when (created_at), at what tier (governance_tier), with what result
  (execution_status), and whether the core personalization boundary
  was active (g41_applied). More fields would expose internal state.
  Fewer would not prove governance.
**Builder confirmed:** Jose Ramon Alvarado McHerron
**Reference:** TY_BOOK_CHAPTER_18_GOVERNANCE_MAINTENANCE_RECORD.md FIX-571

---

## SECTION 6 -- ENCODING AND INFRASTRUCTURE DECISIONS

---

### ADR-026 -- UTF-8 Without BOM as Canonical Encoding

**Date:** 2026-05-27
**Phase:** FIX-661
**Question:** What is the canonical file encoding for all TY AI OS files?
**Decision:** UTF-8 without BOM. All files: no BOM, LF line endings.
**Rationale:** UTF-8 BOM (EF BB BF) changes the byte content of files,
  producing different SHA-256 hashes than clean UTF-8. For a system
  that uses cryptographic hashes as governance anchors, BOM corruption
  directly undermines governance integrity. 165 files were found BOM-corrupted
  in FIX-661 and corrected.
**Builder confirmed:** Jose Ramon Alvarado McHerron | 2026-05-27
**Reference:** FIX-661 Entry-679, .gitattributes added to ty-ai-governance + Jaya-Runtime

---

### ADR-027 -- TYOVA BOM Deferred (FLAG-134)

**Date:** 2026-05-27
**Phase:** FIX-661
**Question:** Should the 109 BOM-corrupted TYOVA files be fixed in FIX-661?
**Decision:** Deferred. TYOVA is Lovable-hosted. Fixing .tsx files directly
  and pushing risks Lovable sync conflicts. The BOM is not currently
  breaking Vite builds or production operation.
**Rationale:** Risk of introducing Lovable conflicts outweighs the
  urgency of the BOM fix for TYOVA. Defer to a dedicated Lovable-aware
  session (FLAG-134).
**Builder confirmed:** Jose Ramon Alvarado McHerron | 2026-05-27
**Reference:** FIX-661 Entry-679, FLAG-134

---

## SECTION 7 -- OPEN ARCHITECTURAL QUESTIONS

Questions not yet decided. Each will become an ADR when resolved.

| # | Question | Phase | Status |
|---|---|---|---|
| OAQ-001 | Phase 14 P2 -- Conscience Thread design | Phase 14 | OPEN |
| OAQ-002 | Phase 14 P3 -- Internal Red-Team scope | Phase 14 | OPEN |
| OAQ-003 | TYOVA BOM correction strategy with Lovable | FLAG-134 | DEFERRED |
| OAQ-004 | Yampolskiy Gap 3 -- future AI scalability | Future | DEFERRED |

---

## SECTION 8 -- MAINTENANCE LOG

| Date | ADRs Added | CLO |
|------|-----------|-----|
| 2026-05-27 | ADR-001 through ADR-027 + OAQ-001 through OAQ-004 | FIX-661 |