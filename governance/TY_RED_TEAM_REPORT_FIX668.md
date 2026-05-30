# TY AI OS -- Internal Red-Team Report
# FIX-668 | Entry-686 | Phase 14 P4
# Date: 2026-05-30 | San Diego (America/Los_Angeles)
# Builder: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
# Scope: Verify WARD role specs against actual Jaya Runtime code implementation

---

## METHODOLOGY

15 Rust source modules read directly from Jaya-Runtime src-tauri/src/.
All reads performed using [System.IO.File]::ReadAllText with UTF8 encoding.
Byte-level S1 corruption scan run on risk_engine.rs -- confirmed clean (false positive from PowerShell CP1252 display).
Findings traced to primary source code only -- Zero-Fabrication Rule applied.

---

## VERIFIED CORRECT -- Role specs accurate

| WARD | Module | Finding |
|---|---|---|
| policy | policy.rs | Fail-closed confirmed. PolicyLoader validates against CoreInvariantCheck before accepting any policy. On load failure defaults to maximum restriction. |
| cri | risk_engine.rs | Tier0-3 confirmed. AutonomyTier enum, RiskEngine struct, emergency_score cap=10, modifier cap=50, is_allowed() tier-based permission. 12 tests (FIX-648, FIX-651). |
| sentinel | sentinel.rs | 4 anomaly types: TierInconsistency, EmergencyIntegrityViolation, EscalationDrift, TierTransitionViolation. CRI integration, ledger write via insert_sentinel_anomaly. |
| alert | alerts.rs + email_alert.rs | In-app alerts (DriftDetected, SentinelBlock, AgentSuspended, VerificationFailed) + Resend API email to guardian_email. Config from local file, never committed. |
| codex | core_invariants.rs | 11 PolicyViolatesInvariant types. All policies must pass CoreInvariantCheck. Cannot grant capability, expand permissions, modify autonomy tier. |
| ledger | ledger.rs | SQLite append-only confirmed. WAL mode (FIX-414). get_readonly_connection() for Luke INV-L2 (FIX-420). SHA256 imported. |
| luke | luke.rs | 5 invariants (INV-L1 through INV-L5) enforced in code. 26 event templates. Unknown event fallback (LC-013). Activation via luke.enabled flag file. Substantially implemented -- 36KB. |
| ss321 | supabase_writer/reader.rs | Bidirectional bridge confirmed. 5 attestation invariants (INV-A1 through INV-A5). Event hash chain (prev_hash). JAYA_VERSION = TY-0001.B. |
| keyRotation | keychain.rs | Ed25519 key lifecycle. 3 states: Active/Retired/Compromised. Grace period 300 seconds. SHA256 fingerprint. Compromised keys always rejected. |
| agents | agent_registry.rs | AutonomyTier integrated. AgentStatus: Active/Suspended/Revoked/Deregistered. 5 violation types. FileRead/FileWrite/LedgerRead/SnapshotRead permissions. |
| fedPeers | federation.rs | Peer registry confirmed. INV-P5-04 structural: registering a peer grants ZERO authority over local governance. Append-only federation ledger. |
| proof7777 | proof_server.rs | Port 7777 confirmed. GET /governance/proof only. No auth. Dedicated OS thread. Serves latest GovernanceProof as JSON on demand. |
| jayme | jayme_dormancy.rs | 3-state dormancy: Active/HeightenedMonitoring/Dormant. Triggered by CRITICAL/TERMINAL events. HVP Layer 1 clearance required. State survives restart via SQLite. |
| attestation | verification.rs | Ed25519 signature verification. Canonical message: node_id|governance_hash|timestamp_utc|nonce|ledger_hash. Nonce replay and ledger hash freshness enforced at Tauri layer. |
| evoEngine | evolution_*.rs | 3 modules: evolution_proposal.rs + evolution_deliberation.rs + evolution_authorization.rs. 59KB total. 7-day deliberation hold architecture confirmed. |

---

## FLAGS -- FINDINGS REQUIRING ACTION

### FLAG-RED-01 -- CRI decay rate: ROLE SPEC CORRECTION REQUIRED
- Affected WARD: cri
- Role spec states: "decays at 1 point per 2 seconds"
- Code (risk_engine.rs apply_time_decay): Duration::from_secs(10) -- 1 point per 10 seconds
- Action: Correct role spec in EcosystemFlowPage.tsx drill-down panel
- FIX: FIX-669

### FLAG-RED-02 -- Ledger INV-L2: KNOWN DEFERRED FIX (no spec change needed)
- Affected WARD: ledger
- Finding: Luke read-only enforced by SQL SELECT statements only, not SQLite connection level
- Code comment: "Full read-only handle enforcement deferred to future FIX"
- Action: Log only -- no role spec change. Deferred implementation gap.
- FIX: None -- tracked as known gap

### FLAG-RED-03 -- Jayme role spec INCOMPLETE
- Affected WARD: jayme
- Finding: jayme_dormancy.rs implements a full 3-state protection system not described in role spec
- States: Active / HeightenedMonitoring / Dormant
- Trigger: TERMINAL governance events
- Clearance: HVP Layer 1 physical guardian verification only
- Action: Add PROTECTION FUNCTION section to Jayme role spec in drill-down panel
- FIX: FIX-669

### FLAG-RED-04 -- proof7777 wording: ROLE SPEC CORRECTION REQUIRED
- Affected WARD: proof7777
- Role spec states: "auto-refreshing every 60 seconds"
- Code: server serves on demand -- no internal refresh timer
- Finding: 60-second cycle is TYOVA client-side polling, not server push
- Action: Correct wording in role spec
- FIX: FIX-669

### FLAG-RED-05 -- fedPeers: ROLE SPEC OVERSTATES CAPABILITY
- Affected WARD: fedPeers
- Role spec states: "exchange governance state signals"
- Code comment (Part 83): "transport resolution is out of scope"
- Finding: Federation is peer registry + attestation verification only -- no active signal exchange implemented
- Action: Correct role spec to accurately describe current capability
- FIX: FIX-669

### FLAG-RED-06 -- keyRotation + ed25519 share module (diagram note only)
- Affected WARDs: keyRotation, ed25519
- Finding: Both WARDs implemented in keychain.rs -- architecturally logical separation but single module
- Action: Diagram note only -- no role spec change required
- FIX: None

### FLAG-RED-07 -- Attestation role spec UNDERSTATES IMPLEMENTATION
- Affected WARD: attestation
- Role spec states: "SHA-256 fingerprint recomputation in browser"
- Code: Full Ed25519 signature verification + governance hash + ledger hash + nonce replay protection
- Finding: Role spec describes TYOVA page behavior only, misses full Jaya attestation protocol
- Action: Expand role spec to include Ed25519 + governance hash + ledger hash + nonce
- FIX: FIX-669

### FLAG-RED-08 -- NWP PROTECTION MACHINE: MISSING WARD -- CRITICAL
- Affected: Ecosystem flow diagram
- Finding: protection_state.rs (28KB, Phase 11 Track B, FIX-524) implements a 3-state protection machine with no WARD in the diagram
- States: Normal (Tier 1) / Suspended (Tier 3, CRITICAL) / Lockdown (Tier 4, TERMINAL)
- Lockdown clearance: HVP Layer 1 physical guardian verification only
- State survives Jaya Runtime restart via SQLite
- All transitions recorded in governance ledger
- Action: Add new NWP Protection WARD to ecosystem flow diagram
- FIX: FIX-670

### FLAG-RED-09 -- selfHeal: NO DEDICATED MODULE
- Affected WARD: selfHeal
- Finding: system_health.rs is health metrics collection only (CPU, memory, failure rate)
- Finding: protection_state.rs handles CRITICAL/TERMINAL events (requires guardian -- not autonomous)
- Finding: Actual self-healing loop (FIX-645) embedded in lib.rs -- no standalone module
- Action: Note in role spec that selfHeal behavior is embedded in lib.rs pending extraction
- FIX: FIX-669

---

## SUMMARY

Modules verified: 15
Flags raised: 9
Flags requiring role spec correction: 6 (RED-01, RED-03, RED-04, RED-05, RED-07, RED-09)
Flags requiring new WARD: 1 (RED-08)
Flags requiring log only: 2 (RED-02, RED-06)

Primary source: E:\TY-Ecosystem\Jaya-Runtime\src-tauri\src\
Verified by: Claude Opus 4.8 | FIX-668 | 2026-05-30 | San Diego