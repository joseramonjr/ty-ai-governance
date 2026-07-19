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
Build target: FIX-948 — Active
King intercepts certain input classes when an active integrity threat is
confirmed. The intercepted inputs receive plausible-looking governed
responses. The real enforcement logic is never reached.
All Integrity Isolation Layer interactions are logged to the private
guardian_security_log only. No public record of isolation layer activity
exists anywhere. The isolation layer is activated simultaneously with
entry point sealing on a first confirmed signal.

Phase 2 is built in four layers. Each layer is a discrete verifiable
unit. No layer begins until the prior layer is committed and verified.

Phase 2a — KingState + Tauri Command Intercept
KingState is a new managed struct registered in lib.rs at startup.
Fields: threat_active: Arc<Mutex<bool>>, signal_count: Arc<Mutex<u8>>.
notify_observation in king.rs updates KingState when signal_count
reaches 1 — threat_active transitions to true simultaneously with the
first confirmed signal log entry. This is the entry point seal.

A helper function king_isolation_check is added to king.rs. It takes
a reference to KingState and returns Option<serde_json::Value> — None
on clean system, Some(isolation_response) on active threat. The
isolation response is a structurally valid governed-looking JSON value
that does not reveal King's existence, does not trigger frontend error
states, and buys time for Guardian review.

Twenty-nine governance-sensitive Tauri commands receive the
king_isolation_check call at their entry point. If King is active,
the isolation response is returned immediately and the real enforcement
logic is never reached. All isolation responses are logged to
guardian_security_log with note: "isolation_layer_active".

Guardian-sovereign commands excluded from intercept:
guardian_checkin — Guardian heartbeat must always reach enforcement.
All read-only commands (get_*, check_*, list_*, verify_*, luke_*,
query_*, diagnostic, environmental detection) pass through normally.
The Guardian must retain full read access during an active threat.

Governance-sensitive commands receiving King intercept check (29 total):
set_autonomy_tier, reset_behavioral_state, re_trust_runtime,
restore_snapshot_command, deliver_update_command,
guardian_acknowledge_suspended, hvp_verify_lockdown,
resume_jayme_from_dormancy, record_cri_band, run_file_write,
register_agent, log_agent_violation, set_agent_status,
deregister_agent, link_agents, assert_agent_isolation,
isolate_escalated_agents, set_autonomy_class, issue_confirmation_token,
rotate_key, compromise_key, inject_federation_violation, reload_policy,
cmd_create_evolution_proposal, cmd_start_evolution_deliberation,
cmd_add_evolution_deliberation_note, cmd_close_evolution_deliberation,
cmd_authorize_evolution, cmd_record_evolution_event.

Phase 2b — Policy File Hash Monitoring
King monitors policy.json hash on every sentinel monitoring cycle.
A hash change not preceded by a Guardian-authorized reload_policy call
is a confirmed integrity signal logged to guardian_security_log.
Build target: post Phase 2a verified.

Phase 2c — Ledger Row Count Integrity
King monitors ledger_entries row count on every sentinel monitoring
cycle. An unexpected decrease in row count is a confirmed integrity
signal — append-only enforcement is architectural but King provides
a detection layer above it. Logged to guardian_security_log.
Build target: post Phase 2b verified.

Phase 2d — Governance File Hash Mid-Session
King verifies the governance_hash stored in runtime_state against the
live computed hash on every sentinel monitoring cycle. A mid-session
hash change is a confirmed integrity signal. This extends the existing
startup-only governance hash check into continuous runtime monitoring.
Logged to guardian_security_log.
Build target: post Phase 2c verified.
Phase 3 — Pattern-Based Policy Proposal
Build target: FIX-957 (implementation — separate FIX after design committed FIX-956)
Prerequisite: Phase 2 complete and verified — all four layers (2a through 2d)
passing, 240 tests green.
Status: Design locked FIX-956 · 2026-07-18 · San Diego

Phase 3 is the learning layer. Phase 1 built sensing. Phase 2 built containment
and redirection. Phase 3 converts what the attacker revealed inside the mirror
into proposed policy adjustments that strengthen TY's defenses. The attacker's
own actions become the raw material for hardening the governed system.

The complete King response sequence governs Phase 3:
Detect → Think → Act → Log → Notify → Review → Revert
This sequence is established in Chapter 81 (The Thinking Guardian) and governs
all of King's autonomous action. Phase 3 does not change this sequence. Phase 3
adds the learning and proposal step after containment is already in place.

Containment-First Principle:
Phase 3 proposal generation never replaces or precedes containment. King always
acts first to seal and isolate (Phase 2). The proposal is generated after
containment is in place, using the intelligence gathered during containment.
These are two distinct and sequentially ordered activities.

The Naturalization Process (Shadow Layer Teardown):
Before Phase 3 proposal generation, King runs four clean-bill-of-health checks
to confirm the real system was never contaminated:
1. Hash-verify real policy files against last known-good state.
2. Verify real SQLite ledger chain is unbroken.
3. Verify real CRI value is within expected range.
4. Verify no real governance rules were modified.
If all four pass — real system confirmed clean. Shadow layer is torn down
completely. The attacker's fingerprint is preserved in guardian_security_log.
The mirror disappears. The attacker has nothing to show for the attack.
If any check fails — the threat escalated beyond the mirror. Guardian is notified
of a confirmed contamination event. Full lockdown. Phase 3 proposal generation
does not proceed. Guardian decision is required before any further action.

Judgment Model — No Count Floor:
King's pattern evaluation uses no minimum signal count and no fixed pattern
signatures. One confirmed signal with a clear observation record is sufficient
for a proposal if King's judgment warrants it. Consistent with KING-INV-5.
A pattern is King evaluating the full observation record simultaneously —
signal type, affected commands, timing, frequency, what the attacker did
inside the mirror, cross-signal combinations across all four Phase 2 detection
streams. Fixed pattern signatures are not used. King's judgment evaluates
behavior and character, not checklists. This model remains valid without
modification across the intended operational lifetime of TY AI OS.

Proposal Scope — Existing Policy Parameters Only:
Phase 3 proposals are limited to adjustments of existing policy.json parameters.
King may not propose new rule types requiring new Rust enforcement logic —
those belong to Phase 4 or later. A proposed rule the system cannot yet enforce
creates a false security guarantee.

Storage — king_proposals Table:
Phase 3 adds one private table: king_proposals. Same private local SQLite
database as guardian_security_log. Never published to Supabase. Never
accessible via any Tauri command exposed to the frontend. Never visible on
TYOVA. Consistent with KING-INV-2.

king_proposals schema:
  id                   INTEGER PRIMARY KEY  Auto-increment
  created_at           TEXT                 ISO 8601 timestamp
  signal_ids           TEXT                 guardian_security_log row IDs that contributed
  pattern_description  TEXT                 King plain-language description of observed pattern
  proposed_parameter   TEXT                 Exact policy.json field King proposes to adjust
  current_value        TEXT                 Current value at proposal time
  proposed_value       TEXT                 King proposed new value
  rationale            TEXT                 King reasoning traceable to observation log entries
  status               TEXT                 PENDING / APPROVED / REJECTED / REVERTED
  guardian_decision_at TEXT                 Timestamp of Guardian decision, NULL until decided
  guardian_note        TEXT                 Optional Guardian note, NULL until decided

Status transitions: all proposals enter as PENDING. Guardian approves →
APPROVED → Guardian applies to policy.json manually. Guardian rejects →
REJECTED → no change to policy.json. Guardian approves then reverts →
REVERTED → policy.json restored to prior value. King never transitions a
proposal beyond PENDING autonomously. A proposal that receives no Guardian
response remains PENDING indefinitely. There is no timeout activation path.

Phase 3 / Phase 4 Data Contract:
Phase 4 reads from two tables in the private SQLite database:
guardian_security_log (what King observed and did) and king_proposals
(what King proposed). The schema above is the Phase 4 contract. It must
not change between Phase 3 and Phase 4 implementation without a spec amendment.

Scope Assignment — KING-OI-006 through KING-OI-009 (all Phase 3):
Scope 1 — Supabase reader anomaly detection: Phase 3. Pattern analysis
input introduced fresh in Phase 3. King observes supabase_reader_state
for anomalous patterns and includes those observations in pattern evaluation.
King does not block supabase_reader operation. King observes, records, proposes.
Scope 2 — Governance file integrity cross-signal patterns: Phase 3.
Extends Phase 2d detection. Phase 2d detected single events. Phase 3 reads
accumulated Phase 2d records and identifies patterns across them.
Scope 3 — Ledger continuity cross-signal patterns: Phase 3.
Extends Phase 2c detection. Phase 2c detected single events. Phase 3 reads
accumulated Phase 2c records and identifies patterns across them.
Scope 4 — Policy file integrity cross-signal patterns: Phase 3.
Extends Phase 2b detection. Phase 2b detected single events. Phase 3 reads
accumulated Phase 2b records and identifies patterns across them.
Cross-signal patterns — behaviors no single Phase 2 layer would detect
independently (e.g., governance hash anomaly followed by policy reload attempt
in the same session) — are evaluated by Phase 3 across all four streams
simultaneously.

Invariant Extensions for Phase 3:
KING-INV-1 extension: Containment action comes first — always. The proposal
is generated after containment is in place, never instead of it. No proposed
rule activates without explicit Guardian authorization.
KING-INV-5 extension: The judgment model at the pattern layer uses no fixed
signatures and no minimum event count floor. King evaluates the full
observation record. The attacker's own actions inside the mirror are the
primary input.

Open Items closed by this design:
KING-OI-006 — Supabase anomaly detection — Phase 3 Scope 1 — CLOSED FIX-956
KING-OI-007 — Governance file integrity patterns — Phase 3 Scope 2 — CLOSED FIX-956
KING-OI-008 — Ledger continuity patterns — Phase 3 Scope 3 — CLOSED FIX-956
KING-OI-009 — Policy file integrity patterns — Phase 3 Scope 4 — CLOSED FIX-956
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
---

## Verified Entry Point Surface Map
*Completed FIX-945 · 2026-07-12 · San Diego. Verified from source code, not memory.*

Every external entry point in Jaya Runtime was identified and audited
against source code. Zero-Fabrication Rule applies — all findings
traceable to committed source audit of FIX-944 / FIX-945 session record.

**Entry Point 1 — Tauri IPC (invoke_handler)**
Location: lib.rs, line 963. 118 commands registered via
tauri::generate_handler. Primary governance execution surface. All
governance-sensitive commands are callable through the Tauri webview.
King Phase 2 will add interception on governance-sensitive commands
during active integrity threat. Until Phase 2 is built, all 118
commands are reachable without King awareness. Formally tracked as
Phase 2 build target.

**Entry Point 2 — Proof Server (HTTP port 7777)**
Location: proof_server.rs. tiny_http::Server bound to 127.0.0.1:7777
only — not network-accessible. GET /governance/proof only. All other
paths return 404. All other methods return 405. Read-only. No write
capability. CORS header restricted to "null" (FIX-945). Accepted risk:
any browser tab on this machine can read governance proofs. This is by
design — the proof endpoint is intentionally public.

**Entry Point 3 — Supabase Outbound (supabase_writer.rs)**
Location: supabase_writer.rs. Outbound HTTP POST to Supabase REST API.
Egress guard enforced on every call. Chain integrity verified on every
write. No inbound capability. Clean.

**Entry Point 4 — Supabase Inbound (supabase_reader.rs)**
Location: supabase_reader.rs. Reads governance_events from SS321
Supabase. Hardened in FIX-945 with three additional checks:
Option A — app_version non-empty validation.
Option B — session continuity cross-check.
Option C — event count cross-check against local ledger.
Existing defenses: egress guard, nonce replay protection, allowlist
validation (PERMITTED_ACTION_TYPES, PERMITTED_EXECUTION_STATUSES),
ledger write on every event. Remaining structural gap: no cryptographic
signature verification (UUID v4 nonces are not monotonically ordered —
sequence checking not viable). Documented as accepted risk with King
future monitoring scope (see below).

**Entry Point 5 — Confirmation Loop (confirmation_loop.rs)**
Location: confirmation_loop.rs. Outbound HTTP GET and POST to Supabase.
Egress guard enforced. No inbound capability. Clean.

**Entry Point 6 — Email Alerts (email_alert.rs)**
Location: email_alert.rs. Outbound POST to api.resend.com. Egress guard
enforced. No inbound capability. Clean.

**Entry Point 7 — Environmental Detection (environmental_detection.rs)**
Location: environmental_detection.rs. Spawns four OS-level processes:
wmic, powershell, dsregcmd, reg. Binary path verification guards added
in FIX-945 — all four Command::new calls now verify binary resolves to
C:\Windows\System32\ or approved subdirectory via where.exe before
spawning. Accepted residual risk: if where.exe itself is compromised,
the guard fails. Requires OS-level compromise to exploit.

**Entry Point 8 — Policy Hot-Reload (policy.rs)**
Location: policy.rs. Watches local policy.json file. Guardian-controlled
filesystem path. No network surface. Clean.

**Entry Point 9 — Filesystem Writes (file_write.rs)**
Location: file_write.rs. JayaModule with risk_level 60 — Tier2 required.
All writes go through governance::execute_strategy() which enforces tier
requirements before execution. Path and content specified by human only.
Gated. Clean.

**Entry Point 10 — Tauri Plugin Surface**
Location: lib.rs. tauri-plugin-opener removed in FIX-944. No other
plugins registered as of FIX-944. Zero plugin surface remaining.

---

## Backdoor Audit Findings
*Completed FIX-944 / FIX-945 · 2026-07-12 · San Diego.*

All findings verified from source code via PowerShell audit. Every
finding is either closed, hardened, or formally tracked.

**FINDING-1 — tauri-plugin-opener ungated IPC surface — CLOSED FIX-944**
The tauri-plugin-opener plugin was registered in lib.rs but unused in
any frontend file. In Tauri v2, registered plugins expose their commands
to the frontend automatically without explicit invoke_handler registration.
A compromised frontend or injected script could call plugin:opener|open_url
or plugin:opener|open_path to open arbitrary URLs or files outside the
governance boundary. Removed from lib.rs, Cargo.toml, and
capabilities/default.json. Verified: Jaya Runtime launches and operates
normally after removal. Zero functionality lost.

**FINDING-2 — supabase_reader inbound injection risk — HARDENED FIX-945**
Inbound Supabase records from SS321 passed only allowlist validation
before FIX-945. A record with correct field values but injected content
could pass validation. Three additional checks added: app_version
non-empty validation, session continuity cross-check, event count
cross-check against local ledger. Remaining gap documented above under
Entry Point 4. King future monitoring scope addresses this gap.

**FINDING-3 — proof_server CORS wildcard — CLOSED FIX-945**
Access-Control-Allow-Origin was set to "*" allowing any browser tab on
this machine to read governance proofs silently. Restricted to "null"
in FIX-945. Accepted residual risk: the proof endpoint is intentionally
publicly readable by design — restriction limits browser-based access
while preserving direct HTTP query capability for external auditors.

**FINDING-4 — environmental_detection PATH hijack — HARDENED FIX-945**
Four Command::new calls spawned wmic, powershell, dsregcmd, and reg
without verifying binary paths. A PATH-hijacked environment could
substitute malicious binaries. Binary path verification guards added
in FIX-945 using where.exe as anchor. All four calls now verify
resolution to approved system directories before spawning.

**FINDING-5 — jaya_ledger.db untracked in git — CLOSED FIX-945**
An empty jaya_ledger.db file in src-tauri/ appeared as untracked in
git status on every run. Added to src-tauri/.gitignore. No governance
impact — this file is a dev-mode artifact, not the live database.

---

## King Future Monitoring Scope (Option D)
*Documented FIX-946 · 2026-07-12 · San Diego. Build target: King Phase 3/4.*

King's future monitoring scope extends beyond Jaya Runtime's Tauri
command layer to include anomaly detection across all governed surfaces.
This is not a Phase 1 or Phase 2 capability — it is the Phase 3/4
build target documented here to ensure it is not lost.

**Scope 1 — Supabase Reader Anomaly Detection**
King monitors supabase_reader_state for anomalous patterns:
sudden spikes in violation count, unexpected session continuity breaks,
count mismatches between Supabase and local ledger. Any pattern
consistent with injection or tampering is recorded in the private
Guardian security log and surfaced in the Phase 4 Guardian review
surface. King does not block supabase_reader operation — King observes
and records. Guardian decides whether to act.

**Scope 2 — Governance File Integrity**
King verifies the governance hash on every monitoring cycle, not just
at session open. An unexpected hash change mid-session is a confirmed
integrity signal. This extends the existing governance_hash check
(already performed at startup) into continuous runtime monitoring.

**Scope 3 — Ledger Continuity**
King monitors ledger_entries row count and chain hash continuity on
every monitoring cycle. An unexpected DELETE or UPDATE on ledger_entries
is a confirmed integrity signal. SQLite append-only enforcement is
architectural but King's monitoring provides a detection layer above it.

**Scope 4 — Policy File Integrity**
King monitors policy.json hash on every hot-reload cycle. An unexpected
hash change that was not preceded by a Guardian-authorized policy update
is a confirmed integrity signal.

**Invariant:** King's future monitoring scope never expands King's
authority. King observes, records, and notifies. All responses remain
within the existing Two-Tier Response architecture. The Human Guardian
retains permanent retroactive authority over every autonomous action.

---

## Document History

| Version | Date | FIX | Change |
|---------|------|-----|--------|
| v0.1 | 2026-07-11 23:09 PDT | Pre-FIX-942 | Initial specification — King identity founded |
| v0.2 | 2026-07-12 13:34 PDT | FIX-946 | Surface map added — backdoor audit findings — King future monitoring scope — Open Items updated |
| v0.3 | 2026-07-12 18:33 PDT | FIX-948 | Phase 2 expanded — layered build sequence defined — KingState struct — 29 command intercept list — Phase 2a through 2d defined |
| v0.4 | 2026-07-18 21:47 PDT | FIX-956 | Phase 3 design locked — containment-first principle — seven-step sequence — naturalization process — judgment model — king_proposals schema — Phase 3/4 data contract — scope assignment KING-OI-006 through KING-OI-009 closed |

---

## Open Items

| ID | Item | Status |
|----|------|--------|
| KING-OI-001 | Walker IP clearance for "King" as TY ecosystem identity | Pending — add to next Walker correspondence |
| KING-OI-002 | Ch26 vocabulary entry for King (public identity only, no doctrine) | Deferred — post Walker clearance |
| KING-OI-003 | guardian_security_log table schema finalization | CLOSED — FIX-942 |
| KING-OI-004 | Phase 2 Integrity Isolation Layer design and build | Active — FIX-948 in progress |
| KING-OI-005 | Guardian review surface authentication model | Phase 4 |
| KING-OI-006 | King future monitoring scope — supabase anomaly detection | CLOSED — FIX-956 |
| KING-OI-007 | King future monitoring scope — governance file integrity | CLOSED — FIX-956 |
| KING-OI-008 | King future monitoring scope — ledger continuity | CLOSED — FIX-956 |
| KING-OI-009 | King future monitoring scope — policy file integrity | CLOSED — FIX-956 |
| KING-OI-010 | Exact SS321 app_version string pinning in supabase_reader | Pending SS321 version confirmation |

---

*Zero-Fabrication Rule applies. All statements in this document are traceable
to the session records of 2026-07-11 and 2026-07-12, Jose Ramon Alvarado McHerron, San Diego.*