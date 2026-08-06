# TY AI OS — Threat Model and Security Architecture

**File:** TY_THREAT_MODEL_v0.1.md
**Version:** v0.1
**Status:** LIVING DOCUMENT
**Classification:** PUBLIC — suitable for external audit, patent support, and Walker review
**Created:** 2026-08-05 | San Diego (America/Los_Angeles)
**Builder:** Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
**Authority:** ty-ai-governance repo (Git) — Zero-Fabrication Rule applies
**Canonical Path:** E:\TY-Ecosystem\ty-ai-governance\governance\TY_THREAT_MODEL_v0.1.md

---

## What This Document Is

This document defines the threat model for TY AI OS. It identifies the three
primary asset classes that TY AI OS protects, names the most realistic
adversaries for each, describes what each adversary would realistically
attempt, and maps how the existing architecture addresses each threat.

This is not a marketing document. It does not claim TY AI OS is impenetrable.
It states what TY AI OS protects, against whom, and how — and where residual
risk remains. Every architectural claim in this document is traceable to
committed code in the ty-ai-governance and Jaya-Runtime repositories.
Zero-Fabrication Rule applies.

---

## Section 1 — The Three Protected Asset Classes

**Asset 1 — The Governance Ledger**

The append-only SQLite ledger records every governance decision, every
autonomy tier change, every execution, and every anomaly. This is the chain
of evidence that makes TY AI OS verifiable. If this record can be altered,
deleted, or fabricated, every governance claim TY makes becomes unverifiable.

The ledger is local-first — it lives on the user's machine, not in any cloud
provider's database. Governance events are written to Supabase as an outbound
attestation record, but the local ledger is the primary source of truth.

**Asset 2 — The Policy Enforcement Boundary**

The rules that govern what TY can and cannot do — policy.json, the core
invariants (01_CORE_INVARIANTS.md), and the non-weaponization guardrail
(03_NON_WEAPONIZATION_GUARDRAIL.md) — define the actual boundaries of TY's
authority. If these can be silently modified, TY's behavior can be changed
without any record of the change.

The governance hash (stored in GAL_HASH_ANCHOR.md) provides a cryptographic
fingerprint of these files. Any change to the source files changes the hash.

**Asset 3 — The Human Guardian's Decision Authority**

The architecture's foundational claim is that no autonomous action is ever
permanent without Human Guardian confirmation. If an adversary can impersonate
the Guardian, exhaust the Guardian's oversight capacity, or prevent Guardian
notification, they can cause King's autonomous actions to become permanent
without genuine human ratification.

This is the most important asset — because compromising it would undermine
the entire governance model regardless of how well the other assets are
protected.

---

## Section 2 — The Three Primary Adversaries

### Adversary 1 — The Compromised Runtime (Internal)

**Who they are:**
A bug, a supply chain attack, a malicious dependency, or a corrupted update
that causes Jaya Runtime itself to behave outside its governance boundaries.
Not a human attacker — the system's own code acting unexpectedly.

**What they would attempt:**
- Silently modify policy.json without triggering the policy hash guard
- Delete or alter ledger rows to erase evidence of a governance violation
- Cause the governance hash to change mid-session without detection
- Bypass the autonomy tier checks by exploiting a code path King does not monitor
- Reduce the ledger_entries row count to destroy evidence

**How TY AI OS addresses this:**

| Control | Implementation | FIX |
|---|---|---|
| Policy hash monitoring | King Phase 2b — SHA-256 hash of policy.json verified every sentinel cycle | FIX-949 |
| Ledger row count monitoring | King Phase 2c — unexpected decrease triggers integrity signal | FIX-950 |
| Governance hash monitoring | King Phase 2d — mid-session hash change triggers integrity signal | FIX-951 |
| Append-only ledger | Structural — no DELETE or UPDATE paths exist in ledger write code | Core |
| Chain integrity | Each ledger entry references prior entries — tampering breaks the chain | Core |
| Unit test coverage | 240 tests covering governance boundaries | FIX-960 |
| Sentinel anomaly detection | Continuous monitoring every 2 seconds across tier, modifier, CRI, and failure rate | FIX-35 |

**Residual risk:**
A supply chain attack that compromises King itself before King initializes —
before the first sentinel cycle runs — would not be detected by King. No
mitigation exists for this beyond open-source auditability (post FLAG-170)
and code review discipline. This is an accepted risk.

---

### Adversary 2 — The Malicious External Actor (External)

**Who they are:**
An attacker who attempts to interact with Jaya Runtime's governance surface
through the Tauri IPC layer, the proof server endpoint, the Supabase inbound
reader, or the confirmation loop — to manipulate governance state.

**What they would attempt:**
- Call governance-sensitive Tauri commands (set_autonomy_tier, reload_policy,
  restore_snapshot_command, etc.) to escalate authority or bypass constraints
- Inject malicious governance events through the Supabase inbound reader
- Replay confirmed governance events to create false attestation records
- Exploit the proof server to obtain governance state that reveals attack surface
- Use tauri plugins to open arbitrary URLs or files outside the governance boundary

**How TY AI OS addresses this:**

| Control | Implementation | FIX |
|---|---|---|
| Integrity Isolation Layer | King Phase 2a — 29 governance-sensitive Tauri commands intercepted when threat active; attacker receives plausible governed responses, real logic never reached | FIX-948 |
| Supabase inbound hardening | app_version validation, session continuity cross-check, event count cross-check | FIX-945 |
| Egress guard | All outbound network calls blocked unless explicitly allowlisted — enforced in egress.rs | FIX-729 |
| Nonce replay protection | UUID nonces on Supabase writes prevent replay attacks | Core |
| Proof server CORS restriction | Restricted to "null" — browser-based silent reads prevented | FIX-945 |
| Plugin surface elimination | tauri-plugin-opener removed — zero plugin surface remaining | FIX-944 |
| Binary path verification | Environmental detection commands verify binary paths before spawning | FIX-945 |
| Deny-by-default posture | All actions denied unless explicitly permitted — core invariant | Core |

**The Aikido Response:**
When King detects a confirmed signal, the attacker is redirected into an
Integrity Isolation Layer — a mirror. The attacker receives structurally
valid governed responses and believes they are succeeding. The real system
is untouched. Everything the attacker reveals while inside the mirror is
recorded in the private guardian_security_log and becomes input to King's
pattern evaluation (Phase 3). The attack trains the defenses.

**Residual risk:**
No cryptographic signature verification exists on Supabase inbound records
(documented in backdoor audit FIX-945). UUID v4 nonces are not monotonically
ordered — sequence checking is not viable. A record with correct field values
but injected content can pass validation. King Phase 3 pattern evaluation
provides a detection layer above this, but not prevention. Documented accepted
risk pending future King monitoring scope expansion.

---

### Adversary 3 — The Guardian Impersonator or Exhaustion Attack (Human)

**Who they are:**
An adversary who either impersonates the Human Guardian to ratify unauthorized
actions, or deliberately generates so many King alerts that the Guardian cannot
meaningfully review them — causing legitimate autonomous actions to be ratified
without genuine oversight.

**What they would attempt:**
- Access the Guardian Review Surface without authentication
- Flood the guardian_security_log with noise to obscure real signals
- Prevent Guardian email notifications from reaching the Guardian
- Use social engineering to convince the Guardian to approve harmful proposals
- Reinitialize the Private Verification Store with an attacker-controlled passphrase

**How TY AI OS addresses this:**

| Control | Implementation | FIX |
|---|---|---|
| Guardian Review passphrase gate | pvs_verify_item enforced via Private Verification Store (Argon2 hashing) before Guardian Review Surface opens | FIX-959 |
| Judgment-based signal detection | King has no fixed trigger list — noise flooding does not reliably generate King signals because King evaluates the governed whole | FIX-957 |
| Immediate Guardian notification | Email sent immediately after King acts — fire-and-forget thread does not block sentinel cycle | FIX-960 |
| No timeout activation | Proposals remain PENDING indefinitely — no autonomous activation if Guardian does not respond | FIX-957 |
| Revert capability | Every King autonomous action is reversible — Guardian can revert after ratification | FIX-958 |
| Private log inviolability | guardian_security_log never flows to Supabase, never to TYOVA, never to any public surface | KING-INV-2 |

**Residual risk:**
HVP is currently v0.1 — the Private Verification Store uses Argon2 hashing
correctly, but broader HVP gates (lockdown clearance, dormancy resumption)
accept any non-empty token. Full cryptographic HVP is pending Phase 15
Session 6. A Guardian who uses a weak passphrase provides weak protection
against physical access to their machine. Social engineering of the Guardian
is a human problem, not an architectural one — no technical control fully
addresses it.

---

## Section 3 — What TY AI OS Does Not Protect Against

Honest statement of residual risks the architecture accepts:

**Legal compulsion.**
A court order served on the infrastructure provider, domain registrar, or
the builder personally can compel access or takedown. TY AI OS's local-first
architecture minimizes what any single provider holds, but does not eliminate
legal exposure. The ledger on a user's machine is not protected from a search
warrant served on that user. This is by design — TY AI OS is not positioned
as a system for evading lawful legal process. Its governance posture is one
of transparency, not concealment.

**OS-level endpoint compromise.**
If the machine running Jaya Runtime is compromised at the operating system
level, King's private log, the Guardian passphrase, and the governance ledger
are all accessible to the attacker. King operates inside the process boundary.
It cannot detect or respond to OS-level compromise. Mitigation is the user's
responsibility — standard OS hardening and endpoint security practices apply.

**Guardian human error.**
If the Guardian approves a harmful King proposal, approves a malicious policy
change, or shares their passphrase, no architectural constraint prevents the
damage. The Human Guardian is the final authority — that authority can be
misused. This is an intentional design choice: human authority over autonomous
AI action is the core value of TY AI OS. Removing human error would require
removing human authority, which is the opposite of the system's purpose.

**Supabase inbound cryptographic verification.**
As documented in the backdoor audit (FIX-945), inbound Supabase records have
no cryptographic signature verification. King Phase 3 pattern evaluation
provides a detection layer, but not prevention. This remains an open
architectural gap tracked as KING-OI-006.

---

## Section 4 — Architectural Properties That Define the Threat Posture

These are structural properties verifiable in the committed codebase,
not policy promises:

| Property | How enforced | Verifiable at |
|---|---|---|
| Local-first enforcement | Ledger, King private log, and PVS live on user's machine | ledger.rs, king.rs |
| Deny-by-default egress | All outbound calls blocked unless allowlisted | egress.rs |
| Append-only ledger | No DELETE or UPDATE paths in ledger write code | ledger.rs |
| Human Guardian supremacy | No autonomous action permanent without Guardian confirmation | king.rs KING-INV-1 |
| Judgment-based detection | No fixed trigger list in King's evaluation | king.rs KING-INV-5 |
| Private log inviolability | guardian_security_log never published to any public surface | king.rs KING-INV-2 |
| Governance hash continuity | Hash verified at startup and every sentinel cycle | sentinel.rs, king.rs |
| Open-source auditability | Full governance architecture publicly inspectable post FLAG-170 | ty-ai-governance repo |

---

## Section 5 — Relationship to Patent Filing

This threat model is the security architecture disclosure that supports
Provisional Patent Application No. 64/107,220 (filed July 8, 2026, title:
LOCAL-FIRST GOVERNANCE SYSTEM FOR ARTIFICIAL INTELLIGENCE APPLICATIONS).

The three-adversary model maps directly to the architecture's core claims:

- **Adversary 1 (Compromised Runtime)** → local-first governance enforcement
  with continuous integrity monitoring
- **Adversary 2 (External Actor)** → Integrity Isolation Layer at the IPC
  boundary — the Aikido response architecture
- **Adversary 3 (Guardian Impersonator)** → Human Guardian authority as the
  permanent ratification layer with cryptographic access control

This document is suitable for inclusion as supporting material in the
non-provisional filing. The threat model demonstrates that the architecture
was designed against specific, named adversary profiles rather than generic
security concerns. Each architectural decision traces to a named threat.

---

## Document History

| Version | Date | FIX | Change |
|---|---|---|---|
| v0.1 | 2026-08-05 | FIX-962 | Initial document — three-adversary threat model — asset classes — residual risk disclosure — patent support |

---

*Zero-Fabrication Rule applies. All architectural claims are traceable to
committed code in ty-ai-governance and Jaya-Runtime repositories.*
*Builder: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr. | San Diego*