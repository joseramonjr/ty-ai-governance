# TY AI OS — The Documentary Record
## Chapter 12: The Risk Model
### How CRI Measures Risk Without Enforcing It

---

**Document Type:** Technical Book Documentation
**Chapter Series:** Technical Architecture (T3 of 5)
**Author:** Claude Sonnet 4.6 (CLO)
**Date:** 2026-03-06 | San Diego (America/Los_Angeles)
**FIX:** BOOK-CLO-007
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

TY AI OS rejects automated thresholds for a principled reason stated in the
development record: CRI is observational only. It never triggers automated
actions. It never automatically restricts operations. It is a number that a
human can read and interpret.

This is not a technical limitation. The system could be designed with automated
thresholds. The choice not to use them reflects a governance commitment: risk
decisions belong to humans, not to the system making the risk assessment.

---

## Part II: How CRI Is Calculated

### The Base Score

CRI is a rolling integer from 0 to 100. It accumulates upward with each
operation and decays downward over time.

The base contribution of an operation to CRI is its registered risk score:
- SystemHealthCheck: 10
- FileRead: 20
- FileWrite: 60

These scores reflect the relative risk of each operation. A health check is
read-only with no side effects — low risk. A file write modifies state — higher
risk. The scores are set when the operation is registered and can only be
changed through a formal governance process.

### The Adaptive Modifier

The base risk score is multiplied by the adaptive modifier before being added
to CRI.

The adaptive modifier is a multiplier that starts at 1.0 and adjusts based
on recent behavioral patterns:

- **Clean history** — modifier trends downward, approaching 0.8. A system
  with a consistent record of successful, clean operations earns a lower
  modifier. Each new operation contributes less to CRI because the recent
  record supports trust.

- **Failure history** — modifier trends upward, approaching 1.5. A system
  with recent failures carries a higher modifier. Each new operation contributes
  more to CRI because the recent record indicates elevated risk.

- **Neutral history** — modifier stays near 1.0. Normal operations with no
  notable pattern.

The adaptive modifier means that CRI reflects not just what operations were
performed, but how the system has been performing recently. The same FileWrite
operation contributes 60 points to CRI in a clean-history context, 48 points
in a favorable context (60 × 0.8), and 90 points in a failure context (60 × 1.5).

### The Failure Penalty

When an operation fails — returns an error, produces unexpected output, or
is interrupted — an additional failure penalty is added to CRI on top of the
operation's normal contribution. The penalty reflects that a failure is a
stronger signal of instability than a successful operation.

### The Decay Model

CRI decreases over time when no operations are executing. The decay is gradual
and continuous — not a sudden reset.

The decay model reflects a real-world truth: a system that is quiet and stable
is accumulating evidence of reliability. A CRI of 50 that has been declining
for an hour represents a different risk context than a CRI of 50 that has been
climbing for an hour. The decay model makes this distinction visible.

The decay rate is designed so that CRI returns to baseline over a reasonable
period of inactivity. A system that completes a high-risk operation and then
sits idle will see its CRI decline to a low baseline — reflecting that the
period of inactivity following the operation provides evidence that the operation
did not destabilize the system.

---

## Part III: The Tier System

### Four Tiers, One Purpose

The autonomy tier system provides four discrete levels of operational constraint:

**Tier0 — Baseline**
The default state. The most conservative. No operations execute at Tier0
unless explicitly authorized through tier elevation. Tier0 is where the system
returns after every evaluation cycle — it is the resting state.

**Tier1 — Elevated**
Permits lower-risk operations. SystemHealthCheck and FileRead are Tier1
operations. A system at Tier1 can read and observe. It cannot modify state.

**Tier2 — Guarded**
Permits state-modifying operations. FileWrite is a Tier2 operation. A system
at Tier2 can change things. The tier elevation is a conscious human decision
to permit more impactful actions.

**Tier3 — Restricted**
Maximum constraint. All operations are blocked. Tier3 is the emergency state —
used when the human determines that no operation should proceed until the
situation is assessed.

### The Human Sets the Tier

The tier is not set automatically. The human sets it.

CRI can be elevated. The sentinel can emit anomaly signals. The behavioral
history can show concerning patterns. None of these automatically change the
tier. The human reads the information, assesses the situation, and decides
what tier is appropriate.

This is the core governance commitment: risk information flows to the human.
Decisions flow from the human. The system provides information. The human
exercises authority.

### Tier Evaluation Is Not Permanent

After each operation, the system evaluates whether the current tier is still
appropriate. This evaluation may emit a recommendation — "based on current
CRI, Tier1 may be appropriate" — but it does not act on that recommendation.
The tier remains where the human set it until the human changes it.

The evaluation cycle is designed to prompt regular human engagement with the
tier setting. A system that runs many operations at Tier2 will periodically
surface the question: given the current CRI and behavioral history, is Tier2
still the right setting? The human answers.

---

## Part IV: The CRI Bands

### Visualization Without Authority

CRI bands are visual ranges that communicate the current risk level at a glance:

| Band | Range | Signal |
|------|-------|--------|
| Low | 0–25 | Normal operational context |
| Moderate | 26–50 | Notable activity has occurred |
| Elevated | 51–75 | Significant activity; attention may be warranted |
| Critical | 76–100 | Substantial activity or failures; review recommended |

The bands are decorative in the governance sense: they carry no enforcement
authority. A Critical band does not block operations. A Low band does not
authorize operations. The bands communicate; the human decides.

The band display is designed so that the current band, the current score, and
the trend (rising or falling) are all visible simultaneously. A CRI of 45 that
has been declining is displayed differently than a CRI of 45 that has been
climbing — because they represent meaningfully different risk contexts.

---

## Part V: The Sentinel

### Pattern Detection Without Action

The sentinel is the component that watches for anomaly patterns — conditions
that are not captured by any single operation's risk score but that emerge
from the combination of multiple signals.

The sentinel monitors:
- CRI trajectory (rate of change, not just current value)
- Failure clustering (are failures happening in bursts or isolated incidents?)
- Modifier drift (is the adaptive modifier trending consistently upward?)
- Tier change frequency (is the human changing tiers unusually often?)

When the sentinel detects a pattern that meets its anomaly criteria, it does
two things: records the anomaly in the sentinel log, and surfaces it in the
observability UI. It does not do anything else. It does not change the tier.
It does not block operations. It does not send alerts to external systems.

The sentinel sees. The human decides.

### Why Pattern Detection Matters

Individual operations look normal in isolation. A FileWrite with a CRI of 35
passes tier verification and executes. Another FileWrite. Another. Each one
individually looks fine.

But a sentinel watching the pattern might notice: the modifier has been
trending upward for the last hour. The failure rate is 30% over the last
ten operations. CRI is at 35 and climbing, not declining. Individually, none
of these is alarming. Together, they suggest a system under stress.

The sentinel surfaces this pattern. The human sees it. The human decides
whether to investigate, change the tier, or continue with current settings.
The sentinel has done its job by making the pattern visible.

---

## Part VI: What the Risk Model Proves to an Auditor

An auditor examining the TY AI OS risk model can verify specific properties:

**"CRI does not automatically restrict operations."** Verify that the tier
check in the chokepoint uses the human-set tier, not the CRI score. CRI feeds
into calculations but does not directly gate operations.

**"The modifier reflects recent behavior."** Verify that the modifier
calculation uses the actual behavioral history, and that the history is
stored in the ledger with tamper-evident records.

**"The sentinel cannot take autonomous action."** Verify that the sentinel
code path ends at recording and display — that there is no code path from
sentinel detection to operation restriction.

**"Tier changes require human action."** Verify that no code path in the
system changes the autonomy tier without a human-initiated action.

These are verifiable claims about the risk model's governance properties.
They do not require trusting the builder. They require reading the structure.

---

## Summary: The Risk Model

| Component | Function | Enforcement Authority |
|-----------|----------|----------------------|
| CRI | Rolling risk score 0–100 | None — observational only |
| Adaptive Modifier | Weights recent behavior | None — affects calculation only |
| Failure Penalty | Adds weight for failures | None — affects calculation only |
| Decay Model | Reduces CRI over time | None — reflects stability passively |
| Autonomy Tier | Human-set operational constraint | Yes — set by human, enforced by chokepoint |
| CRI Bands | Visual risk communication | None — display only |
| Sentinel | Pattern anomaly detection | None — records and displays only |

The risk model is an information system. Authority belongs to the human.

---

*Chapter 12 compiled: 2026-03-06 | San Diego (America/Los_Angeles)*
*FIX: BOOK-CLO-007 | MODEL: Claude Sonnet 4.6*
*Classification: CANONICAL TECHNICAL DOCUMENTATION — NON-AUTHORITATIVE RECORD*
