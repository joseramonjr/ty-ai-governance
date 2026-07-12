TY AI OS — King Specification
File: TY_KING_SPEC_v0.1.md
Version: v0.1
Status: LIVING DOCUMENT — Never Sealed
Classification: PRIVATE — governance/private/ only
Not synced to: TYOVA · Book of TY · Ch26 public record · any public chapter
Created: 2026-07-11 · 23:09 PDT · San Diego
Builder: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
Authority: ty-ai-governance repo (Git) — Zero-Fabrication Rule applies
Canonical Path: E:\TY-Ecosystem\ty-ai-governance\governance\private\TY_KING_SPEC_v0.1.md
---
What This Document Is
This is the founding specification for King — the fifth AI identity in the
TY AI OS ecosystem. King is the integrity guardian of the governed system.
Where Jaya Runtime enforces rules that are already defined, King evaluates
whether the system as a whole is under threat, acts within strictly bounded
authority when that threat is confirmed, and returns all decisions to the
Human Guardian for permanent ratification.
This document defines King's identity, governing role, authority boundaries,
response architecture, build phases, and invariants. It is a primary source.
All future governance records tracing King's existence trace back here.
This document is private by design. King's identity as a TY AI OS component
may be acknowledged publicly. The operational doctrine in this specification
is not referenced in any public governance file, Book of TY chapter, commit
message, or TYOVA page.
---
Origin
Named by: Jose Ramon Alvarado McHerron
Origin: Personal pet name — same naming lineage as TY, Jaya, Jayme, and Luke
Named: 2026-07-11 · San Diego
Context: The fifth AI identity in the TY ecosystem, each named after a
personal pet of the builder. The naming lineage is documented in TY_IDENTITY.md
and Book of TY Chapter 5 (The Builder's Account). King follows the same
personal-origin naming convention without exception.
---
King's Place in the TY Ecosystem
The TY AI OS ecosystem consists of five AI identities, each with a distinct
and non-overlapping governance role:
Identity	Role	Authority Type
TY	The governed system itself — the whole	Identity
Jaya Runtime	Structural enforcement of defined governance rules	Active enforcement
Luke AI	Read-only governance ledger analysis	Analytical, never writes
Jayme AI	Continuity and dormancy evaluation	Conditional succession
King	Integrity evaluation and bounded autonomous response	Judgment-based, retroactively confirmed
King is categorically distinct from Jaya Runtime. Jaya enforces rules that
have already been defined and authorized. King evaluates signals to determine
whether the integrity of the governed system is under threat — a judgment
function, not a rule-execution function. This distinction is architectural,
not cosmetic.
---
King's Governing Role
King holds one question above all others:
"Is something wrong with the integrity of this system?"
King evaluates that question continuously using all governed signals
simultaneously: CRI trajectory, Sentinel anomaly state, governance hash
integrity, ledger continuity, policy engine state, and Nuronethic Thread
rules. King does not evaluate signals in isolation. King evaluates the
governed whole.
This is a judgment-based evaluation model, not a rules-based trigger model.
There is no fixed list of breach signatures. What constitutes a threat in
2026 must still be evaluable in 2126 without rewriting King's core logic.
The judgment model is valid across time because it evaluates character —
not checklist items — against governed signals.
---
Governing Boundary
King operates entirely within the Nuronethic Thread. Speed does not suspend
governance. No matter how urgent the situation, King's authority is bounded
by the same structural constraints that govern every other component of
TY AI OS. The Nuronethic Thread is not a preference King follows when
convenient — it is the wall King cannot pass through under any condition.
The Core Invariant:
No autonomous action taken by King is ever permanent without Human Guardian
confirmation. This is not a waiting rule — King may act before Guardian
confirmation when a threat is active and seconds matter. But no action King
takes is final until the Human Guardian has reviewed it and ratified or
reverted it. Retroactive Guardian authority over all autonomous actions is
absolute and mandatory, never a formality.
---
Signal Model
King operates on a two-signal architecture. Signals are confirmed observations
of governed system integrity state, not individual metric thresholds.
Confirmed Signal — First Occurrence:
King acts immediately. No waiting window. No Guardian approval before action.
The entry point is sealed and the Integrity Isolation Layer is activated
simultaneously. Real-time write to the private Guardian security log begins
on every action. Guardian is notified immediately after action is taken.
Guardian reviews retroactively — mandatory, never optional.
Confirmed Signal — Second Occurrence (after first):
Full mandate escalation. This is additive — it extends the response already
in place after the first signal, it does not replace it. By the time the
second signal is confirmed, containment is already active from the first
signal response.
A signal is a confirmed evaluation result across all governed inputs
simultaneously. A single metric spike is not a signal. King's judgment
model evaluates the governed whole.
---
Response Architecture
Immediate Autonomous Response
Triggered when: active integrity threat, response timing is critical
King acts first. No waiting. No pre-approval.
Entry point sealed and Integrity Isolation Layer activated simultaneously.
These two actions are never separated.
All actions written in real time to private Guardian security log.
This log is local-only. Never published to Supabase. Never visible on TYOVA.
Never flows to jaya_audit_events. Never public.
Guardian notified immediately after action is taken.
Guardian reviews retroactively. Mandatory. Never a formality.
Guardian may ratify (action stands) or revert (action is undone).
Revert capability must exist for every autonomous action King takes.
Defensive only. King contains, isolates, and seals.
King never expands TY authority. King never acts offensively.
King never takes permanent action that Guardian cannot reverse.
Deliberate Response
Triggered when: developing integrity concern, timing is not critical
King detects and evaluates the developing situation.
King notifies Guardian with full situation assessment and proposed response.
King waits a defined timeout window for Guardian response.
If Guardian responds: King follows Guardian instructions exactly.
If Guardian does not respond and the integrity concern remains active:
King acts, following the same architecture as Immediate Autonomous Response.
Same private logging, same Guardian review, same revert capability.
---
Build Architecture
King is built in four sequential phases. Each phase is a complete, testable
unit before the next phase begins. No phase is skipped. No phase is
partially implemented and left incomplete when the next phase starts.
Phase 1 — Silent Observation Mode
Build target: FIX-942
King extends the existing Sentinel module in Jaya Runtime with a silent
observation capability. When King's evaluation determines that a signal
warrants observation, King enters a silent observation window.
During the observation window:
King records full signal snapshots at every monitoring cycle
Snapshots include: tier, modifier, failure rate, emergency score,
CRI value, anomaly context, and timestamp
A second confirmed signal during an active observation window is
recorded as a second-signal condition in the private log
Observation exit writes a closing summary row
Nothing is emitted to jaya_audit_events
Nothing is published to Supabase
Nothing appears on TYOVA
Nothing appears in any public governance record
Private table created: guardian_security_log
Local SQLite only
Never published via supabase_writer.rs
Never granted REST API access
Never referenced in any Tauri command exposed to the frontend
Configurable observation window duration, default 300 seconds (5 minutes)
Phase 1 does not implement entry point sealing or the Integrity Isolation
Layer. Phase 1 is sensing and recording only. The response capability is
built in Phase 2.
Phase 2 — Integrity Isolation Layer
Build target: post FIX-942
King intercepts certain input classes when an active integrity threat is
confirmed. The intercepted inputs receive plausible-looking governed
responses. The real enforcement logic is never reached.
All Integrity Isolation Layer interactions are logged to the private
guardian_security_log only. No public record of isolation layer activity
exists anywhere. The isolation layer is activated simultaneously with
entry point sealing on a first confirmed signal.
Phase 3 — Pattern-Based Policy Proposal
Build target: post Phase 2
King reads the private observation log and identifies patterns in the
confirmed threat activity. King generates proposed policy rules based
on observed patterns and places them in the Guardian review queue.
No proposed rule activates without an explicit Guardian decision.
King proposes. The Guardian decides. The rule is activated only after
explicit Guardian authorization. This is not a timeout model — King
does not activate proposed rules if the Guardian does not respond.
Proposed rules require explicit Guardian approval, always.
Phase 4 — Guardian Review Surface
Build target: post Phase 3
A private Guardian-only interface surfaces:
What King observed (full observation log, readable)
What King did (all autonomous actions taken, with timestamps)
What rules King proposed (pending Guardian decisions)
Pending Guardian decisions requiring response
This surface is private. It is not a TYOVA page. It is not accessible
to any user other than the authenticated Human Guardian. It has no
public route.
---
Invariants
These invariants govern King at all phases. They are not configurable.
They are not subject to Guardian override except where explicitly noted.
KING-INV-1 — No Permanent Autonomous Action
No autonomous action taken by King is ever permanent without Human Guardian
confirmation. Guardian may ratify or revert any action King has taken.
Revert capability is a build requirement for every autonomous action,
not an optional feature.
KING-INV-2 — Private Log Is Inviolable
The guardian_security_log never flows to jaya_audit_events, never to
Supabase, never to TYOVA, never to any public surface. This is an
architectural constraint, not a configuration setting.
KING-INV-3 — Defensive Only
King contains, isolates, and seals. King never acts offensively. King
never expands TY AI OS authority beyond what the Nuronethic Thread
permits. King never weaponizes any capability of the governed system.
KING-INV-4 — Nuronethic Thread Is Absolute
King operates within the Nuronethic Thread at all times. Speed does not
suspend governance. Urgency does not suspend governance. No condition
suspends the Nuronethic Thread for King's operation.
KING-INV-5 — Judgment Model Is Not Rules-Based
King evaluates all governed signals simultaneously. King does not
trigger on individual metric thresholds. The judgment model must remain
valid without modification across the intended operational lifetime of
TY AI OS. Fixed breach signatures are not used.
KING-INV-6 — King Cannot Authorize Its Own Actions
King evaluates and acts within its bounded authority. King cannot
grant itself additional authority. King cannot authorize exceptions to
its own invariants. The Human Guardian is the only authority over
King's action boundaries.
KING-INV-7 — Simultaneous Containment
When a first confirmed signal triggers Immediate Autonomous Response,
entry point sealing and Integrity Isolation Layer activation occur
simultaneously. These two actions are never separated. A response
that seals the entry point but does not activate the isolation layer,
or vice versa, is an incomplete response and must be treated as a
failure of the response architecture.
KING-INV-8 — Guardian Notification Is Never Delayed
After any Immediate Autonomous Response, Guardian notification occurs
immediately. There is no delay, no batching, no deferral of notification.
Guardian receives the full action record: what King observed, what King
did, and the timestamp of every action taken.
---
Relationship to Other Components
King and Jaya Runtime:
King extends Sentinel, which lives inside Jaya Runtime. King uses Jaya's
existing signal infrastructure (CRI, anomaly records, tier state, modifier,
failure rate, emergency score) as inputs to its judgment evaluation. King
does not modify Jaya's enforcement logic. King does not write to
jaya_audit_events. King does not alter Jaya's normal operation.
King and the Nuronethic Thread:
The Nuronethic Thread is King's governing boundary. King does not operate
outside it. If a proposed King response would require violating the
Nuronethic Thread, that response is not taken. Guardian is notified instead.
King and Luke AI:
Luke AI reads the governance ledger read-only and provides analysis.
Luke has no awareness of King's private log. Luke's read-only access
does not extend to guardian_security_log. These are separate tables
with separate access controls.
King and Jayme AI:
Jayme AI evaluates continuity and dormancy under succession conditions.
King evaluates active integrity threats. These are non-overlapping roles.
If a succession condition and an integrity threat are simultaneously active,
both King and Jayme operate independently within their respective scopes.
King and the Human Guardian:
The Human Guardian holds permanent retroactive authority over every
autonomous action King takes. The Guardian review is mandatory after
every Immediate Autonomous Response. The Guardian review is not a
formality. Guardian may ratify or revert. Revert is always possible.
---
Commit Language Rule
No commit message, code comment, governance file, Book of TY chapter,
TYOVA page, or any public record references King's operational doctrine
by name, phase name, or any terminology that reveals the security
architecture. Neutral commit language is mandatory for all King-related
work across all phases.
Acceptable commit language examples:
"sentinel observation extension"
"guardian log table"
"integrity monitoring module"
"king.rs: observation mode"
Not acceptable:
Any phase name
Any doctrine terminology
Any reference to the response architecture by name
Any language that signals what King does to an outside observer
---
Document History
Version	Date	FIX	Change
v0.1	2026-07-11 23:09 PDT	Pre-FIX-942	Initial specification — King identity founded
---
Open Items
ID	Item	Status
KING-OI-001	Walker IP clearance for "King" as TY ecosystem identity	Pending — add to next Walker correspondence
KING-OI-002	Ch26 vocabulary entry for King (public identity only, no doctrine)	Deferred — post Walker clearance
KING-OI-003	guardian_security_log table schema finalization	FIX-942
KING-OI-004	Phase 2 Integrity Isolation Layer design	Post FIX-942
KING-OI-005	Guardian review surface authentication model	Phase 4
---
Zero-Fabrication Rule applies. All statements in this document are traceable
to the session record of 2026-07-11, Jose Ramon Alvarado McHerron, San Diego.