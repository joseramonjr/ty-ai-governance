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

---

### T-08 -- Key Rotation Grace Period

**Value:** 300 seconds (5 minutes)
**Layer:** Runtime
**Status:** ACTIVE
**Source:** TY_BOOK_CHAPTER_26_THE_TY_AI_OS_VOCABULARY.md -- line 1805
**Source (MFI):** MASTER_FIX_INDEX.md -- line 2231
**Governing text (Ch26 line 1805):** "In the Jaya Runtime the grace period is
  300 seconds."
**First decided:** Phase 5 / Phase 6 key rotation implementation
**Builder confirmed:** Yes -- embedded in Ch26 vocabulary and MFI ledger
**What this controls:** After a key rotation event, the previous key remains
  valid for a grace period of 300 seconds. During this window both the old
  key and the new key are accepted to allow in-flight operations to complete.
  After 300 seconds the old key is rejected entirely.
**What this does NOT control:** GAL attestation freshness (see T-06).
  Healing windows (see T-01, T-02). Succession timers (see T-03, T-04).
**Question variants that map to this entry:**
  - "How long is the key rotation grace period?"
  - "How long does the old key remain valid after rotation?"
  - "What is the key grace period?"
  - "When does the old key expire after a rotation?"

---

### T-09 -- JAYA_SILENT Detection Threshold

**Value:** 10 minutes
**Layer:** Runtime / Supabase monitoring
**Status:** ACTIVE
**Source:** governance/SPEC_IMPLEMENTATION_REGISTRY.md -- lines 860, 870, 913, 933
**Governing text (line 870):** "Threshold: 10 minutes without a new event"
**Governing text (line 933):** "AC-1: Supabase pg_cron detects JAYA_SILENT
  within 10 minutes"
**First decided:** Phase 13 governance bridge implementation
**Builder confirmed:** Yes -- embedded in SPEC_IMPLEMENTATION_REGISTRY.md
**What this controls:** If no new governance event has been written to the
  Supabase governance database within 10 minutes, the Supabase pg_cron
  monitor declares a JAYA_SILENT condition. This is the silence detection
  threshold for the live governance bridge. JAYA_SILENT is an operational
  alert -- it does not trigger constitutional succession (see T-03, T-04).
**What this does NOT control:** Constitutional succession (T-03, T-04).
  Runtime Tier 0 drop (T-07). Key rotation grace (T-08).
**Question variants that map to this entry:**
  - "How long before the system detects Jaya has gone silent?"
  - "What is the JAYA_SILENT threshold?"
  - "When is Jaya considered silent?"
  - "How long without a governance event before an alert fires?"

---

### T-10 -- Supabase pg_cron Check Interval

**Value:** 5 minutes
**Layer:** Runtime / Supabase monitoring
**Status:** ACTIVE
**Source:** governance/SPEC_IMPLEMENTATION_REGISTRY.md -- lines 860, 868
**Governing text (line 868):** "pg_cron schedule: every 5 minutes"
**First decided:** Phase 13 governance bridge implementation
**Builder confirmed:** Yes -- embedded in SPEC_IMPLEMENTATION_REGISTRY.md
**What this controls:** The Supabase pg_cron job that monitors for
  JAYA_SILENT conditions runs every 5 minutes. Combined with T-09
  (10-minute silence threshold), the worst-case detection latency
  is 15 minutes (10 minutes silence + up to 5 minutes before next
  pg_cron run).
**Relationship to T-09:** T-10 (5 min) is the check frequency.
  T-09 (10 min) is the silence threshold. These work together.
**Question variants that map to this entry:**
  - "How often does Supabase check for silence?"
  - "What is the pg_cron interval?"
  - "How frequently does the silence monitor run?"

---

### T-11 -- Governance Confirmation Loop Default Schedule

**Value:** 60 minutes (configurable)
**Layer:** Runtime
**Status:** ACTIVE
**Source:** spec/TY_GOVERNANCE_CONFIRMATION_LOOP_SPEC_v0.1.md -- line 244
**Governing text (line 244):** "Default schedule: every 60 minutes
  (configurable)"
**Source (ODQ):** Line 396: "ODQ-1: What is the correct reporting interval?
  60 minutes is the [default]"
**First decided:** Governance confirmation loop specification
**Builder confirmed:** Yes -- embedded in TY_GOVERNANCE_CONFIRMATION_LOOP_SPEC
**What this controls:** The governance confirmation loop runs on a default
  schedule of every 60 minutes. This interval is configurable -- deployments
  may set a different interval. The 60-minute default is the baseline for
  the reference implementation.
**What this does NOT control:** GAL attestation freshness (T-06). JAYA_SILENT
  detection (T-09, T-10). Healing windows (T-01, T-02).
**Question variants that map to this entry:**
  - "How often does the governance confirmation loop run?"
  - "What is the confirmation loop interval?"
  - "How frequently does TY AI OS confirm its governance state?"

---

### T-12 -- Layer 2 Amendment Rollback Window

**Value:** 14 days
**Layer:** Governance Process
**Status:** ACTIVE
**Source:** spec/TY_GOVERNED_UPDATE_DELIVERY_SPEC_v0.1.md -- lines 420, 430
**Governing text (lines 420, 430):** "the guardian may initiate a rollback
  within 14 days" -- "After 14 days, the amendment [is no longer
  reversible through this mechanism]"
**First decided:** Phase 11 governed update delivery spec
**Builder confirmed:** Yes -- embedded in TY_GOVERNED_UPDATE_DELIVERY_SPEC
**What this controls:** After a Layer 2 governance amendment has been
  authorized and applied, the guardian has a 14-day window to initiate
  a rollback if the amendment proves problematic in practice. After
  14 days the amendment is treated as permanent and cannot be reversed
  through the standard rollback mechanism.
**What this does NOT control:** Deliberation period (T-05). HVP retry
  waiting period (T-13).
**Question variants that map to this entry:**
  - "How long can I roll back a governance change?"
  - "What is the amendment rollback window?"
  - "How long after a governance change before it is permanent?"
  - "Can I undo a Layer 2 change after 14 days?"

---

### T-13 -- HVP Verification Retry Waiting Period

**Value:** 7 days
**Layer:** Governance Process
**Status:** ACTIVE
**Source:** spec/TY_HUMAN_VERIFICATION_PROTOCOL_v0.1.md -- lines 47, 474
**Governing text (line 47):** "Waiting period duration -- 7 days -- Section W1"
**Governing text (line 474):** "7 days (168 hours) from the time of the
  [failed verification attempt]"
**First decided:** Phase 10 Human Verification Protocol specification
**Builder confirmed:** Yes -- embedded in TY_HUMAN_VERIFICATION_PROTOCOL
**What this controls:** After a failed Human Verification Protocol attempt,
  the verifier must wait 7 days before retrying. This applies to failed
  identity verification attempts under Section W1 of the HVP. This is
  the anti-brute-force and cooling period for guardian identity verification.
**IMPORTANT DISTINCTION FROM T-05:** T-05 (7 days) is the Phase 12
  minimum deliberation period for governance rule changes. T-13 (7 days)
  is the waiting period between failed HVP verification attempts. Same
  number value, completely different mechanisms and different source
  documents. Both are canonical and correct.
**Question variants that map to this entry:**
  - "How long must I wait after a failed verification?"
  - "What is the HVP retry period?"
  - "What is the Section W1 waiting period?"
  - "How long between failed identity verification attempts?"
  - "Is the 7-day wait the same as the deliberation period?" --
    ANSWER: No. See T-05 vs T-13 distinction above.

---

### T-14 -- CRI Deterministic Decay Rate

**Value:** Minus 1 per 2 seconds during normal operation
**Layer:** Runtime
**Status:** ACTIVE
**Source:** governance/domains/Jaya/Jaya_SEALS.md -- line 41
**Source:** TY_BOOK_CHAPTER_35_JAYA_RUNTIME_THE_FOUNDATION_BUILD.md -- line 145
**Governing text (Ch35 line 145):** "CRI decreases by 1 per 2 seconds
  during normal operation."
**Governing text (Jaya_SEALS line 41):** "Deterministic decay at minus 1
  every 2 seconds"
**First decided:** Phase 2 Jaya Runtime CRI implementation
**Builder confirmed:** Yes -- embedded in Jaya_SEALS.md and Ch35
**What this controls:** The Cumulative Risk Index (CRI) decays automatically
  at a rate of 1 point every 2 seconds when the runtime is operating normally.
  This deterministic decay prevents CRI from permanently accumulating due to
  past anomalies. The decay is automatic and requires no human action.
**What this does NOT control:** CRI maximum cap (100). CRI band definitions.
  Tier escalation thresholds. These are separate governance parameters.
**Question variants that map to this entry:**
  - "How fast does CRI decay?"
  - "What is the CRI decay rate?"
  - "How quickly does the risk index go down during normal operation?"
  - "What is the deterministic decay rate?"

---

### T-15 -- Sentinel Anomaly Cooldown

**Value:** 10 seconds between same-type detections
**Layer:** Runtime
**Status:** ACTIVE
**Source:** governance/domains/Jaya/Jaya_PART_INDEX.md -- line 768
**Governing text (line 768):** "Anomaly cooldown: 10 seconds between
  same-type detections"
**First decided:** Phase 2 Jaya Runtime Sentinel implementation
**Builder confirmed:** Yes -- embedded in Jaya_PART_INDEX.md
**What this controls:** After the Sentinel detects an anomaly of a specific
  type, it will not re-detect the same anomaly type for 10 seconds. This
  cooldown prevents the same condition from generating an excessive number
  of duplicate alerts in rapid succession. After 10 seconds the Sentinel
  can detect and log the same anomaly type again if it persists.
**What this does NOT control:** JAYA_SILENT threshold (T-09). CRI decay
  (T-14). Other Sentinel behavior.
**Question variants that map to this entry:**
  - "How often can the Sentinel fire the same alert?"
  - "What is the Sentinel cooldown?"
  - "How long between duplicate anomaly detections?"
  - "What is the anomaly cooldown period?"

---

## FLAGGED INCONSISTENCY -- F-01: Proof Refresh Interval vs GAL Freshness Window

**Status:** UNRESOLVED -- Requires builder decision
**Flagged:** FIX-659 | 2026-05-27

**The conflict:**

| Source | Value | Context |
|--------|-------|---------|
| TY_GAL_SPEC_v0.1.md line 378 (registered as T-06) | 30 seconds | GAL attestation payload freshness window |
| TY_BOOK_CHAPTER_59 line 49 | 60 seconds | "60 seconds is recommended" for proof refresh |
| TY_BOOK_CHAPTER_60 line 49 | 60 seconds | "Jaya Runtime generates a fresh proof every 60 seconds automatically" |
| TY_EXTERNAL_VERIFICATION_GUIDE_v0.1.md line 172 | 60 seconds | "Refresh: Every 60 seconds automatically" |
| TY_REFERENCE_IMPLEMENTATION_GUIDE_v0.1.md line 76 | 60 seconds | "60 seconds recommended" |

**The architectural problem:**
A proof generated every 60 seconds but valid for only 30 seconds (T-06)
means the proof is stale for at least 30 seconds of every 60-second cycle.
This creates a window where external verifiers will receive a stale proof
even when Jaya Runtime is operating correctly.

**Possible resolutions:**
Resolution A -- The GAL spec (30 seconds) is the proof generation interval
  and the 60-second references are incorrect. Canonical value: 30 seconds.
Resolution B -- Jaya Runtime generates proofs every 60 seconds and the
  GAL freshness window should be updated to 60 seconds. Canonical: 60 seconds.
Resolution C -- These are two different mechanisms: Jaya generates every
  60 seconds; the GAL freshness window is intentionally tighter at 30 seconds
  to flag generation delays. Both values are intentional.
Resolution D -- The 60-second references describe EXTERNAL implementations
  (reference guide minimum), while Jaya Runtime itself generates every 30
  seconds matching the freshness window exactly.

**Builder action required:**
Choose A, B, C, or D above. Once decided, update T-06 accordingly and
resolve any spec file inconsistencies through a targeted FIX.

---

---

### T-16 -- Structural Lock Stale Threshold

**Value:** 300 seconds (5 minutes)
**Layer:** Runtime
**Status:** ACTIVE
**Source:** Jaya-Runtime/src-tauri/src/structural_lock.rs -- line 8
**Governing text (line 8):** "const STALE_THRESHOLD_SECONDS: u64 = 300; // 5 minutes"
**First decided:** Phase 2 Jaya Runtime structural lock implementation
**Builder confirmed:** Yes -- hardcoded constant in structural_lock.rs
**What this controls:** If a structural lock has been held for 300 seconds
  without being released, Jaya Runtime considers the lock abandoned (e.g.
  due to a process crash or hang) and force-releases it. This prevents the
  system from deadlocking on a stale lock from a crashed operation.
**IMPORTANT DISTINCTION FROM T-08:** T-08 (also 300 seconds) is the key
  rotation grace period -- how long the old key remains valid after rotation.
  T-16 (also 300 seconds) is the structural lock staleness threshold -- how
  long a held lock can exist before being force-released. Same numeric value.
  Completely different mechanisms. Both are canonical and correct.
**What this does NOT control:** Key rotation grace period (T-08). Any
  healing windows. Any succession thresholds.
**Question variants that map to this entry:**
  - "How long before a stale lock is force-released?"
  - "What is the structural lock timeout?"
  - "When does Jaya consider a lock abandoned?"
  - "What is STALE_THRESHOLD_SECONDS?"
  - "Is the 5-minute lock threshold the same as the key grace period?" --
    ANSWER: No. See T-08 vs T-16 distinction above. Same value, different
    mechanisms.

---

### T-17 -- Default Snapshot and Log Retention

**Value:** 30 days (default, configurable)
**Layer:** Runtime / Configuration
**Status:** ACTIVE
**Source:** TYOVA/ty-ai-admin-core/data/defaultSnapshots.ts -- lines 43, 86
**Governing text (line 43):** "retention: '30 days'"
**Governing text (line 86):** "logRetention: '30 days'"
**First decided:** TYOVA admin core implementation
**Builder confirmed:** Yes -- embedded in defaultSnapshots.ts as default
  configuration values
**What this controls:** The default retention period for governance snapshots
  and associated log data. After 30 days, snapshot and log records older
  than this threshold are eligible for pruning. This is the default value
  used when no explicit retention period has been configured. Individual
  deployments may override this default within the constraints of T-18.
**Relationship to T-18:** T-17 (30 days) is the default. T-18 (90 days)
  is the hard maximum. T-17 cannot exceed T-18.
**Question variants that map to this entry:**
  - "How long are snapshots kept by default?"
  - "What is the default log retention period?"
  - "When are old governance snapshots pruned?"
  - "What is the default snapshot retention?"

---

### T-18 -- Observability Data Retention Maximum

**Value:** 90 days (hard ceiling)
**Layer:** Runtime / Configuration
**Status:** ACTIVE
**Source:** TYOVA/ty-ai-admin-core/sections/observability/ObservabilityDashboard.tsx -- line 115
**Governing text (line 115):** label="30 of 90 days max"
**First decided:** TYOVA observability dashboard implementation
**Builder confirmed:** Yes -- embedded as UI constraint in
  ObservabilityDashboard.tsx
**What this controls:** The hard maximum ceiling for observability data
  retention. No deployment configuration may retain observability data
  for longer than 90 days through this mechanism. The UI enforces this
  ceiling by showing the current setting (default 30 days, per T-17) as
  a fraction of the maximum (90 days). This is a hard architectural
  constraint, not a recommendation.
**Relationship to T-17:** T-17 (30 days) is the default within this ceiling.
  T-18 (90 days) is the ceiling that T-17 cannot exceed.
**Question variants that map to this entry:**
  - "What is the maximum retention period?"
  - "Can I keep observability data longer than 90 days?"
  - "What is the hard ceiling on data retention?"
  - "What is the observability retention maximum?"

---

---

### T-19 -- Nonce Expiry for Replay Protection

**Value:** 30 seconds
**Layer:** Runtime
**Status:** ACTIVE
**Source:** Jaya-Runtime/src-tauri/src/nonce.rs -- line 12
**Governing text (line 12):** "pub const NONCE_EXPIRY_SECONDS: i64 = 30;"
**First decided:** Phase 5 / Phase 6 GAL + attestation implementation
**Builder confirmed:** Yes -- hardcoded constant in nonce.rs
**What this controls:** A nonce used in an attestation or governance
  request expires after 30 seconds. If the same nonce is presented
  again after 30 seconds it is rejected as expired. If the same
  nonce is presented twice within 30 seconds it is rejected as a
  replay attempt. This is the replay protection window for all
  nonce-based operations in Jaya Runtime.
**IMPORTANT DISTINCTION FROM T-06 AND T-20:** Three mechanisms share
  the value 30 seconds but are completely independent:
  T-06 (30s) -- GAL attestation payload freshness window
  T-19 (30s) -- Nonce expiry for replay protection
  T-20 (30s) -- Governance intelligence analysis interval
  Same value. Three different enforcement mechanisms.
**Question variants that map to this entry:**
  - "How long is a nonce valid?"
  - "What is the nonce expiry?"
  - "What is the replay protection window?"
  - "How long before a nonce can be reused?" -- ANSWER: never; nonces
    are single-use. The expiry means old nonces are purged after 30s.
  - "Is the nonce expiry the same as the GAL freshness window?" --
    ANSWER: No. See T-06 vs T-19 distinction above.

---

### T-20 -- Governance Intelligence Analysis Interval

**Value:** 30 seconds
**Layer:** Runtime
**Status:** ACTIVE
**Source:** Jaya-Runtime/src-tauri/src/governance_intelligence.rs -- line 362
**Governing text (line 362):** "pub const INTELLIGENCE_INTERVAL_SECS: u64 = 30;"
**First decided:** Phase 7 governance intelligence implementation
**Builder confirmed:** Yes -- hardcoded constant in governance_intelligence.rs
**What this controls:** The Governance Intelligence module runs its
  ledger pattern analysis every 30 seconds. The background thread
  spawned at Jaya launch calls analyze_ledger_patterns() on this
  interval. Results are stored and served via get_latest_intelligence_
  analysis Tauri command. This interval governs how frequently the
  system produces updated governance intelligence signals.
**IMPORTANT DISTINCTION FROM T-06 AND T-19:** Three mechanisms share
  the value 30 seconds. See T-19 for full distinction table.
**Question variants that map to this entry:**
  - "How often does governance intelligence run?"
  - "What is INTELLIGENCE_INTERVAL_SECS?"
  - "How frequently does the intelligence analysis update?"
  - "What is the governance intelligence refresh rate?"

---

### T-21 -- Governance Intelligence Score Thresholds

**Value:** LOW = 40.0 | MODERATE = 55.0 | HIGH = 70.0
**Layer:** Runtime
**Status:** ACTIVE
**Source:** Jaya-Runtime/src-tauri/src/governance_intelligence.rs -- lines 128, 131, 134
**Governing text:**
  "pub const THRESHOLD_LOW: f64 = 40.0;"      (line 128)
  "pub const THRESHOLD_MODERATE: f64 = 55.0;" (line 131)
  "pub const THRESHOLD_HIGH: f64 = 70.0;"     (line 134)
**First decided:** Phase 7 governance intelligence implementation
**Builder confirmed:** Yes -- hardcoded constants in governance_intelligence.rs
**What this controls:** The three score boundaries that classify governance
  health signals. A GI score below 40.0 is in the normal/healthy range.
  A score at or above 40.0 triggers LOW concern classification. At or
  above 55.0 triggers MODERATE. At or above 70.0 triggers HIGH concern.
  These thresholds drive the signal severity visible to the guardian.
**Question variants that map to this entry:**
  - "At what score does governance intelligence raise a concern?"
  - "What is the governance intelligence low threshold?"
  - "What is the moderate governance concern threshold?"
  - "When does governance intelligence signal high risk?"
  - "What are the GI scoring bands?"
  - "At what point does the governance signal turn yellow? red?"

---

### T-22 -- Governance Intelligence Analysis Window Size

**Value:** 20 events
**Layer:** Runtime
**Status:** ACTIVE
**Source:** Jaya-Runtime/src-tauri/src/governance_intelligence.rs -- line 125
**Governing text (line 125):** "pub const ANALYSIS_WINDOW_SIZE: u32 = 20;"
**First decided:** Phase 7 governance intelligence implementation
**Builder confirmed:** Yes -- hardcoded constant in governance_intelligence.rs
**What this controls:** The governance intelligence analysis evaluates
  the most recent 20 ledger events when computing the intelligence
  score. Events older than the 20-event window are not included in
  the current score calculation. This sliding window ensures the
  intelligence signal reflects recent behavior rather than historical
  averages that could mask current governance concerns.
**Question variants that map to this entry:**
  - "How many events does governance intelligence analyze?"
  - "What is the GI analysis window?"
  - "How far back does governance intelligence look?"
  - "What is ANALYSIS_WINDOW_SIZE?"

---

### T-23 -- Agent Auto-Suspend Threshold

**Value:** 3 violations
**Layer:** Runtime
**Status:** ACTIVE
**Source:** Jaya-Runtime/src-tauri/src/lib.rs -- line 146
**Governing text (line 146):** "const AGENT_AUTO_SUSPEND_THRESHOLD: u32 = 3;"
**First decided:** Phase 2 / Phase 3 agent governance implementation
**Builder confirmed:** Yes -- hardcoded constant in lib.rs
**What this controls:** When a registered agent accumulates 3 or more
  violations (actions that exceed its CRI band or trigger governance
  rules), the Jaya Runtime automatically suspends that agent without
  requiring a manual guardian decision. The auto-suspension is logged
  to the audit ledger. A suspended agent must be explicitly re-enabled
  by a human guardian action.
**Question variants that map to this entry:**
  - "How many violations before an agent is suspended?"
  - "What is the agent auto-suspend threshold?"
  - "When does Jaya automatically suspend an agent?"
  - "How many strikes does an agent get?"
  - "What is AGENT_AUTO_SUSPEND_THRESHOLD?"

---

### T-24 -- Multi-Agent Escalation Level Thresholds

**Value:** Level 1: minimum 2 coalition agents
           Level 2: minimum 3 violations
           Level 3: minimum 3 coalition agents AND minimum 5 violations
**Layer:** Runtime
**Status:** ACTIVE
**Source:** Jaya-Runtime/src-tauri/src/escalation.rs -- lines 47, 48, 49, 50
**Governing text:**
  "const LEVEL1_MIN_COALITION: usize = 2;"      (line 47)
  "const LEVEL2_MIN_VIOLATIONS: u32 = 3;"       (line 48)
  "const LEVEL3_MIN_COALITION: usize = 3;"      (line 49)
  "const LEVEL3_MIN_VIOLATIONS: u32 = 5;"       (line 50)
**First decided:** Phase 4 multi-agent governance implementation
**Builder confirmed:** Yes -- hardcoded constants in escalation.rs
**What this controls:** The three escalation levels for multi-agent
  governance violations:
  Level 1 escalation: 2 or more agents form a coalition acting in
    coordination that breaches governance rules.
  Level 2 escalation: an agent or coalition accumulates 3 or more
    distinct governance violations.
  Level 3 escalation (most severe): requires both a coalition of 3+
    agents AND 5+ violations simultaneously. This is the highest
    automated escalation tier before mandatory human intervention.
**Question variants that map to this entry:**
  - "How many agents does it take to trigger a coalition escalation?"
  - "What is the Level 3 escalation threshold?"
  - "When does multi-agent activity trigger an escalation?"
  - "What are the escalation level thresholds?"
  - "How many violations before Level 2 escalation?"
  - "What triggers the highest automated escalation?"

---

## SECTION 3 -- REGISTRY MAINTENANCE LOG

| Date | Entry | Change | CLO |
|------|-------|--------|-----|
| 2026-05-27 | T-01 through T-07 | Initial registry creation | FIX-658 |
| 2026-05-27 | T-08 through T-15 + F-01 | Full repo scan additions + inconsistency flag | FIX-659 |
| 2026-05-27 | T-16 through T-18 | Three-repo scan additions -- structural lock + retention defaults | FIX-659 |
| 2026-05-27 | T-19 through T-24 | Deep scan -- Rust constants -- nonce expiry + GI thresholds + escalation | FIX-659 |