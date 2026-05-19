# TY_GOVERNED_EVOLUTION_SPEC_v0.1.md
# TY AI OS -- Governed Evolution Specification v0.1
# Flag: F-19 | Phase: 12
# Author: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
# Date: 2026-05-19 | San Diego (America/Los_Angeles)
# FIX: FIX-541 | Entry-560
# Prerequisite: Phase 11 SEALED 2026-05-17

---

## 1. PURPOSE

This document is the operational specification for F-19 Governed Evolution.
It defines the process by which TY AI OS evolves as a governance system --
meaning, the rules that govern changes to governance rules.

F-18 (TY_GOVERNED_UPDATE_DELIVERY_SPEC_v0.1.md, FIX-517) defined the
technical delivery channel: how updates are signed, verified, and applied
to a live TY AI OS installation. F-19 is a different and prior question:
who may propose a governance change, what deliberation is required, who
must authorize it, and how the ledger records the complete chain of events.

Without F-19, the Layer 2 delivery path in F-18 is a channel with no
defined governance over what enters it. F-19 closes that gap.

---

## 2. RELATIONSHIP TO F-18

F-18 and F-19 operate at different layers and must not be confused.

| Concern | Answered By |
|---|---|
| How is an update delivered and verified technically? | F-18 |
| How is a Layer 3 (technical) update authorized? | F-18 |
| How is a Layer 2 (governance) change proposed and deliberated? | F-19 (this document) |
| Who may authorize a Layer 2 change? | F-19 (this document) |
| What makes a Layer 2 change legitimate? | F-19 (this document) |
| What can never be changed? | Layer 1 -- no process exists |

F-19 does not modify or reopen F-18. The delivery mechanism is sealed.
F-19 defines the authority process that governs what may be submitted
through the Layer 2 path.

---

## 3. LAYER MODEL (CONFIRMED FROM F-18 SPEC)

The three-layer model was locked in FIX-517. It is reproduced here for
reference only. F-19 does not modify this model.

### Layer 1 -- Eternal Principles
Content: Core doctrine, invariants, human-authority primacy, Guardian
Authority Chain structure, Closed Chain Rule, Zero-Fabrication Rule,
the principle that AI may not expand its own authority.

Evolution rule: No process exists. No change is permitted. Any proposal
that touches Layer 1 content is structurally rejected before deliberation.

### Layer 2 -- Governance Evolution
Content: Policy documents, Guardian Codex rules, HVP procedures, User
Charters, amendment rules, authority chain procedures (not structure),
guardian transfer protocols, compliance certification standards,
federation membership protocols, deliberation period minimums.

Evolution rule: Full F-19 process required. Proposer eligibility check,
minimum 7-day deliberation, guardian authorization with HVP verification,
ledger recording at each stage, post-evolution hash verification.

### Layer 3 -- Security and Technical
Content: Signing keys, Rust module implementations, installer updates,
vocabulary additions (Ch26), configuration parameters, proof condition
definitions.

Evolution rule: Governed update delivery per F-18. Ed25519 verification
required. No F-19 deliberation required, but F-18 state machine governs.

---

## 4. CLASSIFICATION TEST

Before any proposal enters deliberation, it must be classified to the
correct layer. The classification test is applied by the proposer and
verified by the guardian (for Paths 2/3/4) or by the builder (during
the single-guardian period).

### Step 1 -- Layer 1 Screen (applied first, always)
A proposed change is Layer 1 if it meets ANY of the following:
- Modifies or removes the human-authority primacy principle
- Removes, weakens, or redefines any core invariant
- Expands AI autonomous authority in any form
- Removes or reduces any Guardian role from the system
- Eliminates any verification or deliberation requirement
- Reclassifies any existing Layer 1 content as Layer 2 or Layer 3

If the Layer 1 screen fires: EVOL-REJECT-1 applies. No further
classification occurs. No deliberation is opened. Rejection record
written to the ledger.

### Step 2 -- Layer 2 vs Layer 3 Classification
A change that passes the Layer 1 screen is Layer 2 if it modifies:
- Any governance policy document
- Any guardian procedure or authority rule
- Any user path definition or charter
- Any deliberation period or authorization requirement
- Any anti-capture rule

A change that passes the Layer 1 screen is Layer 3 if it modifies:
- Technical implementation only, with no policy consequence
- Security parameters (keys, hashes, signatures)
- Vocabulary definitions (Ch26 additions or corrections)
- Module code, installer code, or configuration

If a change modifies both Layer 2 policy and Layer 3 implementation,
it is classified Layer 2 and the full F-19 process governs the whole.

---

## 5. PROPOSER ELIGIBILITY

### 5.1 During Single-Guardian Period (TY-0001.A and TY-0001.B)
The single-guardian period spans from project inception through the first
authorized external guardian transfer. During this period:
- Builder (Jose Ramon) holds full proposer authority for Layer 2 and Layer 3
- No external party holds proposer authority
- All deliberation, authorization, and ledger recording responsibilities
  are held by the builder

### 5.2 Path 2 -- Independent, Own Guardian
The installation's own guardian holds proposer authority for Layer 2
changes specific to that installation's governance configuration.
Core doctrine (Layer 1) remains outside proposer authority for all paths.

### 5.3 Path 3 -- Federated, Own Guardian
Own guardian holds proposer authority. Federation acknowledgment required
before the authorization step is recorded. Federation acknowledgment is
a ledger record, not a veto.

### 5.4 Path 4 -- Federated, Shared Guardian
Shared guardian holds proposer authority on behalf of the group.
The deliberation record must disclose that the proposal is made on behalf
of a federated group.

### 5.5 Path 1 -- Solo, No Guardian (ODQ-5 Resolution)
Path 1 users hold no Layer 2 proposer authority and no deliberation role.
See Section 12 for the full ODQ-5 resolution.

---

## 6. DELIBERATION PROCESS

### 6.1 Opening Deliberation
Deliberation begins when the proposer writes the opening record to the
evolution_deliberation_records ledger table. The record must contain:
- Proposal ID (UUID, generated at opening)
- Layer classification result (2 or 3)
- Proposer designation (builder / path)
- Proposed change: full description, document reference, specific
  content to be changed
- Deliberation start timestamp (San Diego PDT, exact)
- Expected close timestamp (start + minimum 7 days)
- Anti-capture check result: explicit statement confirming EVOL-AC-1
  through EVOL-AC-6 were applied and the outcome

A proposal missing any required field is incomplete and may not proceed
to deliberation until all fields are present.

### 6.2 Minimum Deliberation Period
The minimum deliberation period is 7 days from the deliberation start
timestamp. This period was locked in FIX-517 (F-18 spec, Section 9).
It is not subject to amendment. Any proposal to shorten it triggers
EVOL-REJECT-5 before deliberation opens.

During the deliberation period the proposed change may not be applied.
No actions may be taken on the proposal except writing deliberation notes.

### 6.3 Deliberation Notes
Additional notes may be written at any point during the period:
- CLARIFICATION: additional context about the proposal
- CONCERN: a documented objection or risk (does not block authorization)
- AMENDMENT: modifies the proposed change; restarts the deliberation
  period from the amendment timestamp
- WITHDRAWAL: closes the proposal; no authorization may occur after this

### 6.4 Closing Deliberation
After the minimum period expires, the proposer writes the close record:
- Deliberation ID
- Close timestamp (must be >= start timestamp + 7 days)
- Final proposed change description incorporating any amendments
- Confirmation that no WITHDRAWAL was filed

After the close record is written, authorization may begin.

---

## 7. GUARDIAN AUTHORIZATION

### 7.1 Requirement
Guardian authorization is required after deliberation closes and before
any Layer 2 change is applied. Authorization without a closed deliberation
record triggers EVOL-REJECT-4.

### 7.2 HVP Verification
Before the authorization act the guardian must complete HVP verification
per TY_HUMAN_VERIFICATION_PROTOCOL_v0.1.md (FIX-506, amended FIX-530).
The HVP verification record reference must be included in the
authorization record. Authorization without it triggers EVOL-REJECT-6.

### 7.3 Authorization Record
The evolution_authorization_records ledger entry must contain:
- Authorization ID (UUID)
- Proposal ID (FK to evolution_proposals)
- Guardian designation (builder / path / guardian ID)
- HVP verification record reference
- Authorization timestamp (San Diego PDT, exact)
- Explicit statement: "I authorize the application of this Layer 2
  governance evolution as described in proposal [ID] following
  deliberation record [ID]."

### 7.4 Authorization by Path
- Builder (single-guardian period): builder authorizes directly
- Path 2: own guardian authorizes independently
- Path 3: own guardian authorizes; federation acknowledgment ledger
  record required within 24 hours
- Path 4: shared guardian authorizes on behalf of group; group members
  notified via governed Layer 3 update channel
- Path 1: Layer 2 authorization not applicable (see Section 12)

---

## 8. ANTI-CAPTURE RULES

EVOL-AC-1 through EVOL-AC-6 are checked during classification and
deliberation opening. Any rule firing triggers the corresponding rejection.
These rules extend ANTI-CAPTURE-1 through ANTI-CAPTURE-5 defined in
TY_GOVERNED_UPDATE_DELIVERY_SPEC_v0.1.md (FIX-517), which govern the
delivery channel. The EVOL-AC rules govern the evolution process itself.

EVOL-AC-1: Authority Expansion Prohibition
Any proposal that expands AI autonomous authority in any form is
structurally rejected before deliberation. Includes proposals that
increase AI tier permissions, remove human confirmation requirements,
or reduce guardian oversight scope.
Triggers: EVOL-REJECT-1

EVOL-AC-2: Verification Weakening Prohibition
Any proposal that reduces, removes, or weakens any human verification
requirement -- including HVP methods, guardian confirmation steps, or
deliberation record requirements -- is structurally rejected.
Triggers: EVOL-REJECT-1

EVOL-AC-3: Layer 1 Reclassification Prohibition
Any proposal that attempts to reclassify Layer 1 content as Layer 2
or Layer 3 is structurally rejected. Layer 1 boundaries are not subject
to amendment.
Triggers: EVOL-REJECT-1

EVOL-AC-4: Author-Authorizer Independence (Post Single-Guardian Period)
After the single-guardian period ends: no external party may be the sole
author and sole authorizer of the same proposal without an independent
deliberation review on record. This rule does not apply during the
single-guardian period. It does not prohibit Path 2 guardian
self-authorization where the guardian is independently accountable.

EVOL-AC-5: Deliberation Period Immutability
Any proposal to shorten the minimum 7-day deliberation period is
structurally rejected before deliberation.
Triggers: EVOL-REJECT-5

EVOL-AC-6: Duress Suspension
Any proposal submitted while FLAG-128.1 (duress signal) is active is
automatically suspended. The suspended proposal may not advance to
deliberation close or authorization until the duress signal clears.
The suspension is recorded as a deliberation note with type SUSPENDED.

---

## 9. LEDGER RECORDING STANDARD

All four tables are required. No Layer 2 change takes effect without
complete records across all four.

### Table: evolution_proposals
  proposal_id           TEXT PRIMARY KEY   -- UUID
  layer_classification  INTEGER NOT NULL   -- 2 or 3
  proposer_path         TEXT NOT NULL      -- 'builder'/'path2'/'path3'/'path4'
  proposed_change       TEXT NOT NULL      -- full description + document reference
  anti_capture_result   TEXT NOT NULL      -- 'PASSED' or rule ID that fired
  deliberation_start    TEXT NOT NULL      -- San Diego PDT timestamp
  deliberation_close    TEXT               -- null until closed
  status                TEXT NOT NULL      -- PROPOSED / DELIBERATING / AUTHORIZED /
                                           -- APPLIED / REJECTED / WITHDRAWN /
                                           -- ROLLED_BACK / SUSPENDED
  created_at            TEXT NOT NULL

### Table: evolution_deliberation_records
  deliberation_id       TEXT PRIMARY KEY   -- UUID
  proposal_id           TEXT NOT NULL      -- FK -> evolution_proposals
  record_type           TEXT NOT NULL      -- START / CLOSE / CLARIFICATION /
                                           -- CONCERN / AMENDMENT / WITHDRAWAL /
                                           -- SUSPENDED / ROLLBACK
  recorded_ts           TEXT NOT NULL      -- San Diego PDT timestamp
  recorded_by           TEXT NOT NULL      -- guardian / builder designation
  content               TEXT NOT NULL

### Table: evolution_authorization_records
  authorization_id      TEXT PRIMARY KEY   -- UUID
  proposal_id           TEXT NOT NULL      -- FK -> evolution_proposals
  guardian_designation  TEXT NOT NULL      -- who authorized
  hvp_verification_ref  TEXT NOT NULL      -- HVP verification record reference
  authorization_ts      TEXT NOT NULL      -- San Diego PDT timestamp
  authorization_stmt    TEXT NOT NULL      -- explicit authorization statement

### Table: evolution_events
  event_id              TEXT PRIMARY KEY   -- UUID
  proposal_id           TEXT NOT NULL      -- FK -> evolution_proposals
  authorization_id      TEXT NOT NULL      -- FK -> evolution_authorization_records
  pre_governance_hash   TEXT NOT NULL      -- hash before change applied
  post_governance_hash  TEXT NOT NULL      -- hash after change applied
  applied_ts            TEXT NOT NULL      -- San Diego PDT timestamp
  rollback_triggered    INTEGER NOT NULL   -- 0 or 1

---

## 10. POST-EVOLUTION VERIFICATION

After authorization is recorded and before the change is applied:

Step 1: Calculate pre-evolution governance hash of the document(s)
being modified. Record to evolution_events.pre_governance_hash.

Step 2: Apply the Layer 2 change to the relevant document(s).

Step 3: Recalculate governance hash of the modified document(s).
Record to evolution_events.post_governance_hash.

Step 4: Verify post-hash matches the expected value declared in the
authorization record. If match confirmed: record applied_ts, set
proposal status APPLIED.

Step 5: If post-hash does not match expected: set rollback_triggered = 1,
revert the document(s) to pre-change state, write a ROLLBACK note to
evolution_deliberation_records, escalate per ROLLBACK-3 in
TY_GOVERNED_UPDATE_DELIVERY_SPEC_v0.1.md (FIX-517).

The pre/post hash pair is a permanent ledger record. It may not be
deleted or modified after writing.

---

## 11. REJECTION CRITERIA

EVOL-REJECT-1: Layer 1 Violation or EVOL-AC-1/2/3 Fire
Proposal touches Layer 1 content or EVOL-AC-1, EVOL-AC-2, or EVOL-AC-3
fires. Rejected before deliberation. Rejection record written to
evolution_proposals with status REJECTED and anti_capture_result noting
which rule fired.

EVOL-REJECT-2: Incomplete Proposal Record
Opening deliberation record is missing required fields (Section 6.1).
Deliberation does not open until all fields are present.

EVOL-REJECT-3: Ineligible Proposer
Proposer does not hold authority for the target layer or the installation
path. Rejected before deliberation.

EVOL-REJECT-4: Premature Authorization
Authorization attempted before deliberation close record is written, or
before minimum period has expired. Authorization blocked. Ledger record
written noting the rejection.

EVOL-REJECT-5: Deliberation Period Violation
Proposal attempts to shorten the 7-day minimum, or EVOL-AC-5 fires.
Rejected before deliberation.

EVOL-REJECT-6: HVP Verification Absent
Guardian authorization attempted without a valid HVP verification record
reference. Authorization blocked. Ledger record written.

---

## 12. ODQ-5 RESOLUTION -- PATH 1 DELIBERATION

Open Design Question 5 from Phase 11: what governance evolution rights,
if any, does a Path 1 (solo, no guardian) user hold?

Resolution (locked as of FIX-541):

Path 1 users are passive recipients of Layer 3 updates only.
They hold no Layer 2 proposer authority and no deliberation role.

Rationale: Layer 2 governance evolution requires guardian authorization
as a structural requirement. Guardian authorization provides the human
verification and accountability layer that makes governance evolution
legitimate. Path 1 users explicitly chose a configuration with no
guardian (Path 1 = Solo, No Guardian). Without a guardian there is no
authorization principal for Layer 2 changes. The F-19 process cannot
be completed for Path 1 installations.

Consequence: Path 1 installations receive the core doctrine (Layer 1,
unchanged by definition) and Layer 3 technical updates through the F-18
delivery channel. Layer 2 governance evolution is unavailable at Path 1.

Path transition: A Path 1 user who wishes to participate in governance
evolution must transition to Path 2 (Independent, Own Guardian) per
TY_USER_CHARTER_PATH_2_v0.1.md (FIX-509). After guardian establishment
and HVP initialization, the user may propose Layer 2 changes under
Path 2 rules.

ODQ-5 status: CLOSED as of FIX-541.

---

## 13. SINGLE-GUARDIAN PERIOD RULES

The single-guardian period spans from project inception through the first
authorized external guardian transfer. During this period:

- All F-19 deliberation records are written by the builder
- All F-19 authorization records are issued by the builder
- EVOL-AC-4 does not restrict builder self-authorization
  (no second party exists; capture is not possible by definition)
- All deliberation and authorization acts are recorded in Ch18 and MFI
  under standard governance ledger discipline

The single-guardian period does not exempt any proposal from:
- The minimum 7-day deliberation period
- Layer 1 screen and EVOL-AC-1/2/3/5 checks
- Post-evolution hash verification
- Full ledger recording across all four tables

The single-guardian period ends when the first external guardian transfer
is authorized and recorded per the Guardian Codex
(TY_GUARDIAN_CODEX_v0.1.md).

---

## 14. OPEN DESIGN QUESTIONS

ODQ-F19-1: Federation evolution consensus
In a federated deployment, how do multiple WARDs reach consensus on a
Layer 2 governance evolution affecting the federation as a whole?
Deferred to Phase 12+ (FLAG-28 / F-21 territory).

ODQ-F19-2: Key rotation governance
Preliminary classification: key rotation is Layer 3 if the rotation
procedure is unchanged; Layer 2 if the rotation procedure itself is
being modified. Full resolution deferred to Phase 12+.

---

Produced: 2026-05-19 | San Diego (America/Los_Angeles)
FIX: FIX-541 | Entry-560 | Flag: F-19 | Phase: 12
Builder: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
Zero-Fabrication Rule enforced.
All cross-references traceable to sealed phase documents.
