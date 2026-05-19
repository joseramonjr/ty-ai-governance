# TY AI OS — The Documentary Record
## Chapter 12: The Risk Model
### How CRI Measures Risk Without Enforcing It

---

**Document Type:** Technical Book Documentation
**Chapter Series:** Technical Architecture (T3 of 5)
**Author:** Claude Sonnet 4.6 (CLO)
**Date:** 2026-03-06 | San Diego (America/Los_Angeles)
**FIX:** BOOK-CLO-007 (corrected)
**Audience:** Auditors, governance reviewers, general technical readers

---

## Opening: Risk as Information, Not Authority

The Cumulative Risk Index — CRI — is the most misunderstood component of
Jaya Runtime, because it looks like a control mechanism. It has thresholds.
It has bands. It changes with every operation. It feeds into calculations that
affect how operations are weighted.

It is not a control mechanism.

CRI is an information system. It tells the human what has happened and what
the current risk context is. It does not tell the system what to do. It does
not restrict operations. It does not elevate tiers. It does not trigger alerts
that automatically escalate.

Understanding why CRI is observational — and why that is a design choice, not
a limitation — is essential to understanding the TY AI OS governance model.

---

## Part I: The Problem With Automated Risk Thresholds

### How Most Risk Systems Work

Most AI governance risk systems work through automated thresholds: when a risk
metric exceeds a defined value, the system automatically takes action. Rate
limiting kicks in. Operations are blocked. Alerts are sent. The system manages
itself.

This approach seems efficient. It removes the human from the loop for routine
risk management, allowing the human to focus on exceptional cases.

It has two serious problems.

**First, automated thresholds can be gamed.** If the system knows that exceeding
a certain CRI level triggers a block, an adversary can structure their operations
to stay just below the threshold — accumulating impact through many small
operations rather than a few large ones. The threshold creates an optimization
target.

**Second, automated thresholds transfer authority to the system.** When the
system blocks operations based on its own risk assessment, the system is making
governance decisions. The human may have a good reason to perform a high-risk
operation. The system does not know what the human knows. An automated block
prevents the human from overriding a system decision that the human may correctly
assess as wrong.

### The TY AI OS Position

TY AI OS rejects automated thresholds for a principled reason stated explicitly
in the development record: CRI is observational only. It never triggers automated
actions. It never automatically restricts operations. It is a number that a
human can read and interpret.

This is not a technical limitation. The system could be designed with automated
thresholds. The choice not to use them reflects a governance commitment: risk
decisions belong to humans, not to the system making the risk assessment.

This decision was formally locked during the Jaya Runtime Part 35 series with
the explicit statement: "CRI is a Future-Authorizable Modifier Input" — meaning
any future coupling of CRI to behavioral decisions requires explicit human
authorization as a formal governance act, not an implementation choice.

---

## Part II: How CRI Is Calculated

### The Risk Score

CRI is a rolling score that accumulates upward with each operation and decays
downward over time. Each operation registered in the module registry carries
a risk score between 0 and 100. The operation's risk score is the base
contribution to CRI when that operation executes.

Operation risk scores as established in the development record:
- SystemHealthCheck: risk 10
- FileRead: risk 20
- FileWrite: risk 60

These scores reflect the relative risk of each operation. A health check is
read-only with no side effects — low risk. A file write modifies state —
higher risk. The scores are defined when the operation is registered.

### The Adaptive Modifier

The adaptive modifier is a component of the RiskEngine that adjusts based on
recent behavioral patterns. It is tracked as a numeric value in the runtime
state — visible on the governance dashboard alongside failure rate, tier, and
emergency status.

The modifier starts at 0 at baseline (a clean, reset state). It increases
with failures and emergency events. It decays over time when the system is
stable.

The development record confirms the following observed behavior:
- At baseline reset state: Adaptive Modifier = 0
- After repeated failures: Adaptive Modifier elevated (observed value: 30
  during a high-failure-rate test session in Part 35A)
- After behavioral reset: Adaptive Modifier returns to 0

The exact floor, ceiling, and decay rate values for the adaptive modifier are
defined in the Jaya Runtime codebase in `risk_engine.rs`. Those implementation
details are not reproduced here — this chapter documents the governance
behavior, not the implementation constants.

What the development record confirms architecturally:
- The modifier reflects recent failure rate and emergency score
- It decays deterministically when the system is stable
- It is visible on the governance dashboard
- It does not directly gate operations — it contributes to risk context

### The Emergency Score

The risk engine tracks an emergency score separately from the adaptive modifier.
The emergency score reflects the accumulation of emergency-level events. When
the emergency score crosses a defined threshold, the runtime can enter
RESTRICTED mode — an operational state where execution is constrained.

The emergency score and the adaptive modifier are both components the sentinel
monitors as part of its pattern detection. They are governance signals, not
enforcement mechanisms on their own.

### The Failure Rate

The risk engine tracks recent execution failures as a failure rate. The
development record confirms:
- Failure rate is displayed on the governance dashboard as a percentage
- After behavioral reset: Failure Rate = 0.00%
- During a high-failure test session: Failure Rate reached 75.00%
- The failure rate feeds into the adaptive modifier calculation

### The Decay Model

CRI and the adaptive modifier decrease over time when the system is idle or
operating cleanly. The decay is deterministic — meaning the same conditions
produce the same decay behavior every time. This property was explicitly
verified during development: "Decay logic validated via instrumentation."

The decay model reflects a real principle: a system that is quiet and stable
is accumulating evidence of reliability. The decay makes that evidence visible
as a declining risk score.

---

## Part III: The Tier System

### Four Tiers, One Purpose

The autonomy tier system provides four discrete levels of operational
constraint. The tier system was defined in Jaya Runtime Part 30 and implemented
across Parts 30–32:

**Tier0 — Manual approval required**
The most conservative state. No registered operations execute at Tier0 without
explicit human authorization. This is the resting state the system returns to
after a behavioral reset.

**Tier1 — Default operational level**
Permits lower-risk operations. SystemHealthCheck (risk 10) and FileRead
(risk 20) are Tier1 operations. A system at Tier1 can read and observe. It
cannot execute state-modifying operations.

**Tier2 — Moderate autonomy**
Permits state-modifying operations. FileWrite (risk 60) is a Tier2 operation.
A system at Tier2 can change things. The tier elevation is a conscious human
decision to permit more impactful actions.

**Tier3 — High autonomy**
The development record defines Tier3 as the high-autonomy tier. At the time
of writing (Part 37), no Tier3 operations have been registered. Tier3 is
defined in the architecture but not yet operationally populated.

### The Human Sets the Tier

The tier is not set automatically. The human sets it.

The development record is explicit: CRI can be elevated, the sentinel can emit
anomaly signals, the failure rate can be high — none of these automatically
change the tier. The human reads the information and decides.

The tier is persisted in the ledger between sessions via `persist_autonomy_tier`
and `load_last_autonomy_tier`. This means the last human-set tier is remembered
across restarts — but it is loaded as a restored human decision, not as
inherited authority. Cold start = zero authority still applies to the
operational state; the tier persistence is a convenience that reflects the
last human decision.

---

## Part IV: The CRI Bands

### Visualization Without Authority

CRI bands are visual ranges that communicate the current risk level:

| Band | Range | Signal |
|------|-------|--------|
| Low | 0–25 | Normal operational context |
| Moderate | 26–50 | Notable activity has occurred |
| Elevated | 51–75 | Significant activity; attention may be warranted |
| Critical | 76–100 | Substantial activity or failures; human review recommended |

The bands carry no enforcement authority. A Critical band does not block
operations. A Low band does not authorize operations. The bands communicate;
the human decides.

The band classification system was formalized during the Claude session era
(Jaya Part 36), making it one of the first governance additions after the
transition from ChatGPT sessions to Claude sessions. It is documented in the
MASTER_FIX_INDEX as part of the CLO-era fixes.

---

## Part V: The Sentinel

### Pattern Detection Without Action

The sentinel is the component that watches for anomaly patterns — conditions
that are not captured by any single operation's risk score but that emerge
from the combination of multiple signals.

The sentinel captures a `MirrorRiskSnapshot` from read-only runtime state:
- Current tier
- Adaptive modifier value
- Failure rate
- Emergency score
- Runtime mode
- Timestamp

The sentinel does not store execution data. It stores governance signals only.

When the sentinel detects an anomaly pattern, it creates an `AnomalyEvent`
record and surfaces it in the sentinel anomaly log visible on the governance
dashboard. The anomaly types detected include patterns such as `EscalationDrift`
— a condition observed and resolved during Part 35 development where the
sentinel was continuously re-elevating CRI due to a misfire in the anomaly
detection logic.

**What the sentinel does:**
- Observes governance signals
- Records anomaly events in the sentinel log
- Displays anomalies in the governance dashboard

**What the sentinel does not do:**
- Change the autonomy tier
- Block operations
- Send alerts to external systems
- Take any action

The sentinel sees. The human decides.

### Why Pattern Detection Matters

Individual operations look normal in isolation. The sentinel's value is in
surfacing patterns across multiple signals that would not be visible from any
single metric. A combination of rising modifier, elevated failure rate, and
CRI trending upward may be more significant than any one of those signals alone.

The sentinel makes that pattern visible. The human sees it and decides whether
to investigate, change the tier, or continue with current settings.

---

## Part VI: What the Risk Model Proves to an Auditor

An auditor examining the TY AI OS risk model can verify specific properties:

**"CRI does not automatically restrict operations."** Verify that the tier
check in the governance wrapper uses the human-set tier, not the CRI score.
CRI contributes to the risk context record but does not directly gate operations.

**"The adaptive modifier reflects recent behavior."** Verify that the modifier
calculation uses actual behavioral history stored in the risk engine. Verify
that modifier = 0 after a behavioral reset, confirming no hidden state.

**"The sentinel cannot take autonomous action."** Verify that the sentinel
code path ends at recording an anomaly event and updating the UI display —
that there is no code path from sentinel detection to operation restriction
or tier modification.

**"Tier changes require human action."** Verify that no code path in the system
changes the autonomy tier without a human-initiated set_tier command.

**"Decay is deterministic."** Verify that the decay logic produces consistent
results under the same conditions. Deterministic decay was explicitly validated
during development via instrumentation.

These are verifiable claims about the risk model's governance properties. They
do not require trusting the builder. They require reading the structure and
the verified test results in the development record.

---

## Summary: The Risk Model

| Component | Function | Enforcement Authority |
|-----------|----------|----------------------|
| CRI | Rolling risk score 0–100 | None — observational only |
| Adaptive Modifier | Numeric value reflecting recent failures and emergency events | None — affects risk context record only |
| Failure Rate | Percentage of recent failed operations | None — governance signal only |
| Emergency Score | Accumulation of emergency-level events | Can trigger RESTRICTED mode when threshold crossed |
| Decay Model | Deterministic reduction over time | None — reflects stability passively |
| Autonomy Tier (Tier0–Tier3) | Human-set operational constraint | Yes — set by human, enforced by governance wrapper |
| CRI Bands (Low/Moderate/Elevated/Critical) | Visual risk communication | None — display only |
| Sentinel | Pattern anomaly detection across governance signals | None — records and displays anomaly events only |

The risk model is an information system. Authority belongs to the human.

---

*Chapter 12 corrected: 2026-03-06 | San Diego (America/Los_Angeles)*
*Source: Jaya Runtime Parts 30–37 — ChatGPT export archives + Claude session records*
*FIX: BOOK-CLO-007 (corrected) | MODEL: Claude Sonnet 4.6*
*Classification: CANONICAL TECHNICAL DOCUMENTATION — NON-AUTHORITATIVE RECORD*
