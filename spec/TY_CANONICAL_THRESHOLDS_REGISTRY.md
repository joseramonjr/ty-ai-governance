# TY_CANONICAL_THRESHOLDS_REGISTRY.md
# TY AI OS -- Canonical Architecture Thresholds Registry
# Single Source of Truth for All Time, Duration, Interval, and Threshold Values
#
# Document Type: GOVERNANCE SPECIFICATION -- LIVING DOCUMENT
# CLO: FIX-658 | Entry-676
# Model: Claude Sonnet 4.6
# Created: 2026-05-27 | San Diego (America/Los_Angeles)
# Builder: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
#
# WHY THIS FILE EXISTS
#
# The same architectural concept can be asked in many different ways.
# "What is the inactivity threshold?" and "What is the succession trigger?"
# and "When does the runtime lock down?" can all refer to the same value.
# Without a single registry, the same question answered differently on
# different days creates contradictions across canonical documentation.
# This file prevents that. Every time-based, duration-based, interval-based,
# or threshold-based value in TY AI OS is registered here and only here.
# All other documents reference this registry -- they do not define
# values independently.
#
# USAGE RULES (NON-NEGOTIABLE)
#
# Rule 1: Before answering any question about a time, duration, interval,
#         or threshold, check this registry first.
#
# Rule 2: If a matching or similar concept already exists in this registry,
#         use the existing value. Do not create a new value for the same
#         concept, even if the question is worded differently.
#
# Rule 3: Before implementing any new time-based value in code or spec,
#         add it to this registry first. The registry is the authority.
#         The code references the registry -- not the other way around.
#
# Rule 4: Never remove or change an existing entry. If a value changes,
#         mark the old entry SUPERSEDED and add a new entry with the
#         updated value. Both entries remain in the record.
#
# Rule 5: The "Question Variants" field must capture every known way
#         this threshold has been asked. If a new variant is discovered,
#         add it to the existing entry rather than creating a duplicate.
#
# UPDATE DISCIPLINE
# Add new entries at session close when a new threshold is decided.
# Never reconstruct or guess values from memory -- verify from source files.
# All entries require a source file + line number as primary evidence.

---

## SECTION 1 -- CONSTITUTIONAL LAYER THRESHOLDS
## These govern succession, authority, and long-term guardian continuity.
## They operate at the Continuity Charter / Guardian Codex level.
## They are NOT the same as runtime operational thresholds (Section 2).

---

### T-01 -- Jayme AI Authorized Healing Window Duration

**Value:** 24 hours
**Layer:** Constitutional
**Status:** ACTIVE
**Source:** TY_CONTINUITY_CHARTER_v1.0.md -- lines 159, 173
**Governing text (line 159):** "Authorized Healing Window duration: 24 hours."
**First decided:** 2026-03-31 | Claude session | Phase 7 / Guardian Codex work
**Builder confirmed:** Yes -- embedded in signed Continuity Charter v1.0
**What this controls:** The maximum duration of a single Authorized Healing
  Window that Jayme AI may open. Jayme cannot extend this window. A new
  explicit authorization is required for any additional healing time.
**What this does NOT control:** Tier 2 Guardian healing windows (see T-02).
  Runtime operational timers (see Section 2).
**Question variants that map to this entry:**
  - "How long can Jayme run a healing operation?"
  - "What is the Authorized Healing Window for Jayme?"
  - "How long does Jayme have to complete a repair?"
  - "What is Jayme's healing window duration?"

---

### T-02 -- Tier 2 Guardian Healing Window Maximum

**Value:** 72 hours
**Layer:** Constitutional
**Status:** ACTIVE
**Source:** TY_GUARDIAN_CODEX_v0.1.md -- lines 281, 282, 285, 286, 565
**Governing text (lines 281-282):** "Exceeds 72 hours duration [binding
  duration confirmed in Continuity Charter]"
**First decided:** 2026-03-31 | Claude session | Guardian Codex authoring
**Builder confirmed:** Yes -- explicit "yes" confirmed in April 2026 Claude
  session during Guardian Codex review. Text: "Suggested: 72 hours maximum
  for Tier 2 authorized healing windows" -- Jose Ramon responded: "yes"
**What this controls:** The maximum single healing window a Tier 2 Guardian
  may authorize. If more than 72 hours of healing is required, the Tier 2
  Guardian must close the current window and open a new one with a new
  explicit authorization. Tier 2 cannot authorize a single continuous window
  exceeding 72 hours.
**What this does NOT control:** Jayme AI healing windows (see T-01). Runtime
  operational timers (see Section 2). Incapacitation thresholds (see T-03).
**Question variants that map to this entry:**
  - "What is the 72-hour rule?"
  - "How long can a Tier 2 Guardian run repairs?"
  - "What is the Tier 2 healing window limit?"
  - "Can a Tier 2 Guardian run a healing operation indefinitely?"
  - "What is the maximum healing window?"

---

### T-03 -- Guardian Incapacitation Threshold

**Value:** 1 year (365 days of inactivity)
**Layer:** Constitutional
**Status:** ACTIVE
**Source:** TY_GUARDIAN_CODEX_v0.1.md -- lines 421, 426, 427, 428, 925, 955, 979
**Governing text (lines 426-428):** "one (1) year, Jayme assumes incapacitation
  -- This threshold is distinct from the three (3) year death assumption
  threshold"
**Governing text (line 421):** "Jayme determines incapacitation based solely
  on guardian inactivity."
**First decided:** April 2026 | Claude session | Guardian Incapacitation
  Protocol development
**Builder confirmed:** Yes -- Jose Ramon confirmed: "yes, incapacitation at
  1 year, death assumption at 3 years" in April 2026 Claude session
**What this controls:** After 1 year of complete guardian inactivity, Jayme
  assumes the guardian is incapacitated (not dead, not under duress, but
  unable to act). Jayme enters Reduced Authority State: ledger read allowed,
  new entries accepted, new guardian designation accepted, governance
  decisions blocked, invariant modification blocked, verification responses
  blocked. Auto-escalates to T-04 (death assumption) if inactivity continues.
**What this does NOT control:** Jayme full activation (see T-04). Runtime
  operational safety timers (see Section 2). Healing windows (see T-01, T-02).
**IMPORTANT NOTE -- Phase 14 Relationship:**
  This constitutional threshold is conceptually related to the Phase 14
  runtime succession check-in mechanism (see T-07) but they are different
  mechanisms at different layers. T-03 governs long-term constitutional
  succession. T-07 governs short-term runtime operational safety.
  They operate independently and do not contradict each other.
**Question variants that map to this entry:**
  - "When does Jayme assume I am incapacitated?"
  - "What is the 1-year rule?"
  - "How long before the system assumes I cannot act?"
  - "What is the guardian inactivity threshold?"
  - "When does the succession protocol activate?"
  - "How long can the guardian be silent before something changes?"
  - "What is the incapacitation trigger?"
  - "Is this similar to a dead man switch?" -- ANSWER: Conceptually yes,
    but at the constitutional layer (1 year). The runtime layer equivalent
    is T-07.

---

### T-04 -- Death Assumption / Jayme Full Activation Threshold

**Value:** 3 years (total cumulative inactivity from guardian first becoming
  unreachable, across Stages 2, 3, and 4 of 1 year each)
**Layer:** Constitutional
**Status:** ACTIVE
**Source (primary):** TY_CONTINUITY_CHARTER_v1.0.md -- line 73
**Source (detail):** TY_GUARDIAN_CODEX_v0.1.md -- lines 1046, 1047, 1048,
  1049, 1052
**Governing text (Charter line 73):** "If I do not log in to the TY Ecosystem
  after 3 years"
**Governing text (Codex lines 1046-1052):** "Stage 2: 1 year / Stage 3: 1 year
  / Stage 4: 1 year / Minimum total: 3 years -- at least 3 years after a
  guardian first becomes [unreachable]"
**First decided:** 2026-03-xx | Claude session | Continuity Charter authoring
**Builder confirmed:** Yes -- embedded in signed Continuity Charter v1.0 and
  confirmed in April 2026 session
**What this controls:** After 3 years of guardian inactivity, death is assumed
  and Jayme AI activates fully per the Continuity Charter activation runbook.
  This is the terminal succession trigger. Stage 2 (1 year) + Stage 3 (1 year)
  + Stage 4 (1 year) = minimum 3 years total before Jayme activates.
**What this does NOT control:** Incapacitation protocol (see T-03). Runtime
  timers (see Section 2).
**Question variants that map to this entry:**
  - "When does Jayme take over?"
  - "What is the 3-year rule?"
  - "When does full Jayme activation happen?"
  - "How long before TY AI OS runs without me?"
  - "What is the death assumption threshold?"
  - "How long until Jayme becomes the constitutional successor?"

---

## SECTION 2 -- RUNTIME AND OPERATIONAL LAYER THRESHOLDS
## These govern day-to-day system operation, code behavior, and
## short-interval enforcement mechanisms in Jaya Runtime and GAL.
## They are NOT the same as constitutional succession thresholds (Section 1).

---

### T-05 -- Phase 12 Minimum Deliberation Period

**Value:** 7 days
**Layer:** Runtime / Governance Process
**Status:** ACTIVE
**Source:** TY_GOVERNED_EVOLUTION_SPEC_v0.1.md -- lines 67, 169, 170, 188,
  265, 266, 267, 373, 374, 427
**Governing text (lines 169-170):** "The minimum deliberation period is 7 days
  from the deliberation start timestamp. This period was locked in FIX-517
  (F-18 spec, Section 9)."
**Governing text (lines 265-267):** "EVOL-AC-5: Deliberation Period Immutability
  -- Any proposal to shorten the minimum 7-day deliberation period is
  structurally rejected before deliberation."
**First decided:** 2026-05-17 | FIX-517 | F-18 spec, Section 9
**Builder confirmed:** Yes -- locked as immutable in EVOL-AC-5
**What this controls:** Every Layer 2 (governance) change proposal must wait
  a minimum of 7 days from deliberation open before it can be authorized and
  applied. This period cannot be shortened by any proposal, guardian, or
  emergency. The 7-day window is structurally enforced in Rust (evolution_
  deliberation.rs).
**What this does NOT control:** Constitutional succession timelines (Section 1).
  GAL freshness windows (see T-06). Runtime check-in timers (see T-07).
**Question variants that map to this entry:**
  - "How long does a governance change take to approve?"
  - "What is the deliberation period?"
  - "How long must a proposed rule change wait?"
  - "Can a governance change be made immediately?"
  - "What is the Phase 12 deliberation window?"
  - "How long does evolution deliberation take?"

---

### T-06 -- GAL Attestation Payload Freshness Window

**Value:** 30 seconds
**Layer:** Runtime
**Status:** ACTIVE (v0.1)
**Source:** TY_GAL_SPEC_v0.1.md -- lines 378, 382, 387, 416
**Governing text (line 378):** "v0.1 freshness window: 30 seconds"
**Governing text (lines 381-382):** "A payload is considered stale if:
  current_time - payload.timestamp > 30 seconds"
**First decided:** Phase 5 / Phase 6 GAL implementation
**Builder confirmed:** Yes -- embedded in TY_GAL_SPEC_v0.1.md v0.1
**What this controls:** An attestation payload from the Global Attestonic Layer
  is valid for 30 seconds from its generation timestamp. After 30 seconds it
  is stale and must be regenerated. Nodes with clock drift exceeding 30 seconds
  will experience soft attestation failures.
**What this does NOT control:** Constitutional succession timelines (Section 1).
  Deliberation periods (see T-05). Runtime check-in windows (see T-07).
**NOTE -- Memory correction:** This value was previously stated as 60 seconds
  in a Claude session summary. The canonical value is 30 seconds per the
  actual spec file. The registry supersedes any prior informal summary.
**Question variants that map to this entry:**
  - "How fresh does an attestation payload need to be?"
  - "How often does the GAL refresh?"
  - "What is the GAL freshness window?"
  - "How long is a governance proof valid?"
  - "When does an attestation expire?"

---

### T-07 -- Runtime Succession Check-In Window (Phase 14 P1)

**Value:** PENDING -- to be decided and locked in FIX-659 (Phase 14 P1 open)
**Layer:** Runtime
**Status:** PENDING
**Source:** succession_chain.rs (not yet built)
**First decided:** Not yet decided
**Builder confirmed:** Not yet confirmed
**What this will control:** The maximum interval between valid guardian
  check-in events in Jaya Runtime. If no valid check-in is recorded within
  this window, Jaya Runtime automatically drops to Tier 0 (maximum
  restriction). This is a short-interval operational safety mechanism
  distinct from the constitutional incapacitation threshold (T-03).
  The Tier 0 drop from T-07 is reversible -- the guardian re-attests and
  the system restores. The T-03 incapacitation protocol is a separate,
  slower constitutional mechanism that operates independently.
**RELATIONSHIP TO T-03:** These are NOT the same mechanism. T-03 (1 year)
  governs who has constitutional authority over TY AI OS. T-07 governs
  whether the runtime is in operational Tier 0 or normal operation. Both
  can be active simultaneously without contradiction.
**Candidate values under consideration:**
  - 72 hours (aligns with existing T-02 anchor)
  - 7 days (aligns with T-05 deliberation window)
  - 30 days (longer operational window)
  - Configurable in policy file with hard ceiling
**Question variants that map to this entry:**
  - "What is the Phase 14 check-in window?"
  - "How long before the runtime locks to Tier 0?"
  - "What is the succession chain timeout?"
  - "How often must the builder check in?"
  - "What is the runtime inactivity limit?"
  - "Is the 1-year incapacitation threshold the same as the Phase 14
    check-in window?" -- ANSWER: No. See T-03 vs T-07 distinction above.

---

## SECTION 3 -- REGISTRY MAINTENANCE LOG

| Date | Entry | Change | CLO |
|------|-------|--------|-----|
| 2026-05-27 | T-01 through T-07 | Initial registry creation | FIX-658 |

---

*Document Type: GOVERNANCE SPECIFICATION -- LIVING DOCUMENT*
*Never remove entries. Mark superseded entries SUPERSEDED.*
*Builder: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.*
*Model: Claude Sonnet 4.6*
*Created: 2026-05-27 | San Diego (America/Los_Angeles)*