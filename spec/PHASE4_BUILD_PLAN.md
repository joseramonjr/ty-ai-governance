# PHASE 4 BUILD PLAN -- GLOBAL ATTESTONIC LAYER
# Document ID: TY-PHASE4-BUILD-PLAN-v0.1
# Author: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
# Date: 2026-03-11 | San Diego (America/Los_Angeles)
# Status: DRAFT
# CLO: JAYA-CLO-134
# Part: 67

---

## I. PURPOSE

This document defines the Phase 4 build sequence, proof condition,
and seal criteria for the Global Attestonic Layer.

This document is separate from TY_GAL_SPEC_v0.1.md by design.
The spec defines what the protocol is permanently.
This document defines what gets built, in what order, to prove the spec.

---

## II. PHASE 4 PROOF CONDITION

Phase 4 is considered PROVEN when all seven conditions are satisfied.
All seven are required. Partial completion does not constitute proof.

### Condition 1 -- Specification Exists
TY_GAL_SPEC_v0.1.md is committed to ty-ai-governance/spec/
and sealed with git tag: phase4-gal-spec-v0.1-draft

### Condition 2 -- Payload Schema Defined
Deterministic attestation payload schema is specified in the GAL spec
(Section IX) with all required fields enumerated and typed.

### Condition 3 -- Verification Algorithm Specified
Attestation freshness rules (Section X), failure classification (Section XI),
and failure behavior (Section XII) are fully specified in the GAL spec.

### Condition 4 -- Jaya Reference Implementation Exists
Jaya Runtime implements:
- Attestation payload generation
- Payload signing (Ed25519)
- Peer payload verification
- Failure classification (Soft / Hard)
- Lifecycle state management (REGISTERED / ACTIVE / SUSPENDED / REVOKED)
- Ledger recording for all attestation events
- Human alert on Hard Failure

### Condition 5 -- Two Independent Instances Prove the Protocol
Two separate Jaya process instances (separate node_id, separate keypair,
separate SQLite database) running on the same machine can:
- Exchange attestation payloads
- Successfully validate each other
- Reject a tampered payload (signature invalid test)
- Reject a payload with guardrail_flag = false

### Condition 6 -- No Authority Transferred
Verified by test: after successful attestation exchange, neither node's
autonomy tier, CRI, execution rights, or configuration has been modified.

### Condition 7 -- Guardrail Compliance Verifiable
A node with guardrail_flag = false is rejected as a Hard Failure.
This is demonstrated in the two-instance proof.

---

## III. BUILD SEQUENCE

### Pre-Implementation Gate (Must complete before any code)

- [ ] TY_GAL_SPEC_v0.1.md committed and sealed
- [ ] TY Core Invariants updated with Autonomy Ceiling Invariant
- [ ] governance_hash anchor computed and recorded
- [ ] Core Invariants commit tagged in ty-ai-governance
- [ ] CLO recorded for invariant update

### Part 67 (This Part) -- Specification and Scope Lock

Output: TY_GAL_SPEC_v0.1.md + PHASE4_BUILD_PLAN.md
CLO: JAYA-CLO-134
Status: In progress

### Part 68 -- Core Invariants Update + Governance Hash Computation

Scope:
- Add Autonomy Ceiling Invariant to TY Core Invariants
- Commit and tag invariant update
- Compute governance_hash from sealed invariant set
- Record governance_hash in a new file: ty-ai-governance/spec/GAL_HASH_ANCHOR.md
- Update Chapter 18 ledger

CLO: JAYA-CLO-135
Destination: ty-ai-governance

### Part 69 -- Jaya Keypair and Identity Infrastructure

Scope:
- Add Ed25519 keypair generation to Jaya Runtime
- Generate stable node_id from public key
- Persist keypair to encrypted local store
- Add node identity panel to UI (display node_id, public key fingerprint)
- cargo check = 0 errors before commit

CLO: JAYA-CLO-136
Destination: Jaya-Runtime

### Part 70 -- Attestation Payload Generation

Scope:
- Implement attestation payload struct (all v0.1 fields)
- Implement registry_hash computation (SHA-256 of registry state)
- Implement governance_hash loading and inclusion
- Implement guardrail_flag evaluation
- Implement timestamp generation (UTC ISO 8601)
- Implement payload signing (Ed25519 over all fields)
- cargo check = 0 errors before commit

CLO: JAYA-CLO-137
Destination: Jaya-Runtime

### Part 71 -- Peer Registry and Key Pinning

Scope:
- Implement peer trust store (local SQLite table)
- Implement human-mediated key pinning UI (add peer by public key)
- Implement peer node_id to public key mapping
- Implement lifecycle state tracking per peer
- No auto-discovery, no automatic trust
- cargo check = 0 errors before commit

CLO: JAYA-CLO-138
Destination: Jaya-Runtime

### Part 72 -- Attestation Verification Engine

Scope:
- Implement payload verification (signature check)
- Implement freshness check (30 second window)
- Implement guardrail_flag check
- Implement governance_hash check
- Implement protocol_version compatibility check
- Implement Soft / Hard failure classification
- Implement peer lifecycle state transitions on failure
- Record all attestation events to ledger
- cargo check = 0 errors before commit

CLO: JAYA-CLO-139
Destination: Jaya-Runtime

### Part 73 -- Human Alert Integration for GAL

Scope:
- Extend existing human alert system to include attestation failure alerts
- Hard Failure alert: non-silent, requires acknowledgement, specifies peer + reason
- Soft Failure alert: logged, visible, does not require acknowledgement
- Alert includes: peer node_id, failure class, failure reason, timestamp
- cargo check = 0 errors before commit

CLO: JAYA-CLO-140
Destination: Jaya-Runtime

### Part 74 -- GAL UI Panel

Scope:
- Add Attestation tab to App.tsx
- Display: local node identity, peer list, peer lifecycle states
- Display: attestation history (success / soft fail / hard fail)
- Display: last attestation timestamp per peer
- Manual "Request Attestation" button per peer
- cargo check = 0 errors before commit

CLO: JAYA-CLO-141
Destination: Jaya-Runtime

### Part 75 -- Phase 4 Proof Condition Demonstration

Scope:
- Run two independent Jaya instances (separate config, separate SQLite)
- Pin each to the other via key pinning
- Execute attestation exchange
- Verify: both instances reach ACTIVE state
- Execute tamper test: modify payload, verify Hard Failure and REVOKED state
- Execute guardrail test: set guardrail_flag = false, verify Hard Failure
- Record proof in ty-ai-governance/proofs/PHASE4_PROOF.md
- Ledger sealed, tag applied

CLO: JAYA-CLO-142
Destination: Jaya-Runtime + ty-ai-governance

### Part 76 -- Phase 4 Seal

Scope:
- Verify all 7 proof conditions satisfied
- Update Jaya_PART_INDEX.md (Parts 67-75)
- Update MASTER_FIX_INDEX.md (CLOs 134-142)
- Update PENDING_TASKS.md
- Write Chapter 18 Entry for Phase 4
- Write Chapter 21 of Book of TY: "The Global Attestonic Layer"
- Seal commit + tag in ty-ai-governance
- Seal commit + tag in Jaya-Runtime

CLO: JAYA-CLO-143
Destination: ty-ai-governance + Jaya-Runtime

---

## IV. CLO SEQUENCE FOR PHASE 4

| CLO | Part | Scope |
|---|---|---|
| JAYA-CLO-134 | 67 | GAL Spec v0.1 + Build Plan |
| JAYA-CLO-135 | 68 | Core Invariants update + governance_hash |
| JAYA-CLO-136 | 69 | Keypair + node identity |
| JAYA-CLO-137 | 70 | Attestation payload generation |
| JAYA-CLO-138 | 71 | Peer registry + key pinning |
| JAYA-CLO-139 | 72 | Verification engine |
| JAYA-CLO-140 | 73 | Human alert integration |
| JAYA-CLO-141 | 74 | GAL UI panel |
| JAYA-CLO-142 | 75 | Phase 4 proof condition |
| JAYA-CLO-143 | 76 | Phase 4 seal |

---

## V. DEFERRED TO PHASE 4.2

The following items are explicitly deferred and must not be added to
Phase 4 v0.1 scope:

- Challenge-response nonce (stronger replay defense)
- Ledger hash in attestation payload
- Class B Cooperative Autonomy
- Cross-boundary CRI weighting
- Alternative signature scheme support
- Network transport layer (HTTP / gRPC / etc.)
- Multi-machine two-instance proof

---

## VI. GOVERNANCE FILE UPDATES REQUIRED AT PART 76 SEAL

- ty-ai-governance/governance/ledger/MASTER_FIX_INDEX.md
- ty-ai-governance/governance/domains/Jaya/Jaya_PART_INDEX.md
- ty-ai-governance/governance/ledger/PENDING_TASKS.md
- ty-ai-governance/book/chapter_21.md (new)
- ty-ai-governance/book/chapter_18.md (Entry for Phase 4)
- ty-ai-governance/proofs/PHASE4_PROOF.md (new)
- ty-ai-governance/spec/GAL_HASH_ANCHOR.md (new, Part 68)

---

## VII. TYOVA UPDATES REQUIRED AT PHASE 4 SEAL

TYOVA files requiring update:
- src/data/bookChapterContent.ts (add Chapter 21)
- src/pages/BookOfTyIndex.tsx (update chapter list)
- src/pages/BookOfTyChapter.tsx (if routing needed)

Lovable prompt to be generated at Part 76 seal session.

---

## DOCUMENT SEAL RECORD

Draft Status: DRAFT
Seal Condition: Committed to ty-ai-governance alongside TY_GAL_SPEC_v0.1.md
CLO: JAYA-CLO-134
Model: Claude Sonnet 4.6
Date: 2026-03-11 | San Diego (America/Los_Angeles)

---

END OF PHASE4_BUILD_PLAN.md
