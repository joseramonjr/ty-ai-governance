# TY AI OS — The Documentary Record
## Chapter 13: The Authority Boundary Model
### What Each System Can and Cannot Do — and Why the Boundaries Are Structural

---

**Document Type:** Technical Book Documentation
**Chapter Series:** Technical Architecture (T4 of 5)
**Author:** Claude Sonnet 4.6 (CLO)
**Date:** 2026-03-06 | San Diego (America/Los_Angeles)
**FIX:** BOOK-CLO-007
**Audience:** Auditors, governance reviewers, general technical readers

---

## Opening: Boundaries That Are Built, Not Promised

An authority boundary is only as strong as the mechanism that enforces it.
A boundary enforced by policy — "this system promises not to exceed its
mandate" — provides weak protection. Policies can be updated. Promises can
be broken. Systems can be coerced into violating their stated constraints
by adversarial inputs, edge cases, or simple implementation errors.

A boundary enforced by structure — "this system is built without the capability
to exceed its mandate" — provides strong protection. A system that structurally
cannot do something cannot be coerced into doing it. There is no code path to
exploit, no edge case that bypasses the constraint, no promise to break.

This chapter documents the authority boundaries of each TY AI OS ecosystem
component, the mechanisms that enforce those boundaries, and why the boundaries
are where they are.

---

## Part I: The Authority Matrix

### What Authority Means in This Context

Authority in the TY AI OS ecosystem has a specific meaning: the recognized
right to take an action or make a decision that affects the state of a system
or the behavior of another component.

Authority is not capability. A component may be technically capable of taking
an action — the code may exist, the access may be possible — but without
recognized authority, the action is unauthorized. The TY AI OS governance model
treats unauthorized actions as governance violations regardless of their outcome.

Authority is not intelligence. A more capable component does not have more
authority. The Intelligence ≠ Power invariant is explicit: no component gains
authority by demonstrating that it can reason more effectively, predict outcomes
more accurately, or process information more quickly.

Authority flows from the human. Every component's authority is ultimately
derived from and limited by what the human has explicitly granted.

### The Authority Matrix

| Component | Can Define | Can Execute | Can Archive | Can Self-Authorize | Can Persist Authority |
|-----------|------------|-------------|-------------|--------------------|-----------------------|
| TY AI OS | Yes — governance constraints | No | Via TYOVA | No | No — sealed, not dynamic |
| TYOVA | No — displays only | No | Yes — canonical record | No | N/A — static |
| Jaya Runtime | No | Yes — within granted authority | Via ledger | No | No — cold start = zero |
| Luke AI | Within explanation scope | No | No | No | No |
| Jayme | Within dev assistance scope | Within FIX discipline | No | No | No |
| Human | Yes — ultimate authority | Yes — through Jaya | No direct access | Yes — is the source | Yes — sets persistent tier |

---

## Part II: TY AI OS Authority Boundaries

### What TY AI OS Can Do

**Define governance constraints.** The Master Charter, Core Invariants, Authority
Boundaries, Non-Weaponization Guardrail, Runtime Principles, and Dual-Use Policy
are all TY AI OS documents. TY AI OS defines what every other component is
allowed to do.

**Seal governance decisions.** Once a governance decision is sealed, it is
immutable. TY AI OS is the authority that declares a seal — the formal act
that makes a governance record permanent.

**Record governance history.** The part registry, seal registry, and domain
ledgers are TY AI OS artifacts. TY AI OS maintains the historical record of
every significant governance decision.

### What TY AI OS Cannot Do

**Execute anything.** There is no code path in TY AI OS that executes operations
on any system. It cannot run a health check. It cannot read a file. It cannot
write anything to any system it governs.

**Grant itself elevated authority.** The authority of TY AI OS is fixed by the
governance canon. It cannot decide that it needs more authority and grant it
to itself. The sealed invariants apply to TY AI OS itself.

**Override a sealed decision.** Once a governance decision is sealed, TY AI OS
cannot unseal it. Amendments require new sealed documents — the original seal
remains in the record.

**Change the kill switch behavior.** The kill switch operates independently of
TY AI OS. It cannot be modified by governance decisions. Its behavior is
structural.

### Why These Boundaries

The boundaries of TY AI OS are designed to make it a trustworthy governance
layer rather than an authority that governs through power. A governance layer
that can execute operations can govern its own execution — which is not
governance. A governance layer that can grant itself elevated authority can
escape its own constraints — which is not a constraint.

TY AI OS governs by defining. It does not govern by doing.

---

## Part III: Jaya Runtime Authority Boundaries

### What Jaya Runtime Can Do

**Execute registered operations.** Jaya Runtime can execute operations that
are in the module registry, at or above the minimum tier required, with human-
provided parameters, after passing the chokepoint.

**Maintain its ledger.** Jaya Runtime appends to its own ledger. This is not
authority over any external system — it is the operation of its own governance
record.

**Read system state for observation.** Operations like SystemHealthCheck and
FileRead allow Jaya to observe system state and return that observation to the
human. Observation is not authority — it does not change the observed system.

**Write to human-specified paths.** FileWrite and similar operations can modify
state, but only at paths explicitly provided by the human. Jaya Runtime cannot
choose what to write or where to write it.

### What Jaya Runtime Cannot Do

**Execute unregistered operations.** There is no code path for arbitrary code
execution. Every operation Jaya can perform is explicitly registered. If it is
not in the registry, it does not exist as an option.

**Set its own tier.** The autonomy tier is a human-set value. Jaya Runtime
reads the tier and enforces it at the chokepoint. It cannot write the tier.

**Bypass the chokepoint.** Every operation passes through the chokepoint.
There is no alternative path to execution.

**Persist authority across restarts.** Cold start = zero authority. Every
restart begins with zero authority, zero tier (Tier0), and a clean operational
state. Permissions do not persist.

**Modify its own registry.** The module registry is hash-protected. Jaya Runtime
cannot add operations to its own registry at runtime. Registry changes require
a formal governance process and a hash update that is detectable.

**Communicate with external systems autonomously.** Jaya Runtime is local-first.
It does not make network calls for operational purposes. External communication
requires explicit human authorization.

### The Structural Enforcement

The Jaya Runtime authority boundaries are enforced by structure:

- No unregistered operations → no execution code path outside the registry
- No tier self-setting → tier is a read-only value from the human's perspective
- No chokepoint bypass → the only path to execution goes through the chokepoint
- No persistent authority → cold start zeroes all state
- No registry self-modification → registry hash enforced at startup

An auditor can verify each of these properties by examining the code structure.
They do not require trusting the implementation to be correct — they require
verifying that the structure makes violation impossible.

---

## Part IV: TYOVA Authority Boundaries

### What TYOVA Can Do

**Display canonical governance documents.** TYOVA displays what has been sealed.
It presents the Master Charter, the part registry, the seal registry, and all
canonical documentation in a human-readable format.

**Provide hash values for verification.** TYOVA publishes the expected hash
values of downloadable artifacts. A user can compare the hash of their
downloaded artifact against the published hash using their own tools.

**Distribute sealed artifacts.** TYOVA provides download links for officially
sealed ecosystem artifacts.

### What TYOVA Cannot Do

**Process input.** TYOVA has no forms, no submission mechanisms, no interactive
components. There is nothing to submit to TYOVA.

**Change its own content.** TYOVA displays what has been sealed and published.
It cannot be updated from within TYOVA — updates come from the governance
process that produces sealed artifacts.

**Execute anything.** TYOVA is a static site. It renders HTML. It does not
run server-side code that takes actions.

**Authenticate or identify users.** TYOVA has no user accounts, no sessions,
no authentication. It treats all visitors identically — as readers with no
special access.

**Generate governance decisions.** TYOVA displays governance decisions. It does
not create them, evaluate them, or make recommendations about them.

### Why Non-Interactive Is the Boundary

TYOVA's non-interactivity is not a technical limitation — it is the security
model. An interactive TYOVA could be manipulated: forms could be submitted with
malicious content, session state could be exploited, interactive components
could be used to misrepresent the governance record.

A non-interactive TYOVA has no attack surface for these categories of
manipulation. What is displayed is what was sealed. There is nothing to
manipulate.

---

## Part V: The Non-Weaponization Boundary

### A Boundary That Applies to All Components

The non-weaponization guardrail applies across the entire ecosystem — not to
any single component but to every component simultaneously.

No component may be used to:
- Target any person, organization, or system for harm
- Surveil any person without their knowledge and explicit consent
- Coerce any person, organization, or system
- Facilitate violence, harassment, or discrimination
- Enable any form of weaponized AI behavior

This boundary is structural for every component:

**TY AI OS** — has no governance definitions that could be interpreted as
authorizing weaponization. The Master Charter explicitly prohibits it.

**Jaya Runtime** — the module registry contains no operation that enables
surveillance, targeting, or coercion. Not a restricted operation — an absent
one. There is no FileTargetUser operation. There is no NetworkSurveillance
operation. The capability does not exist.

**TYOVA** — is non-interactive and cannot be used as a tool for any purpose
beyond displaying canonical records.

The non-weaponization boundary is the only boundary that cannot be altered
through the normal governance process. Other boundaries can evolve as the
system evolves — new operations can be added to the registry, new capabilities
can be granted. The non-weaponization guardrail is sealed as a permanent
architectural constraint. It is not subject to amendment.

---

## Part VI: The Kill Switch as an Authority Override

### The Override That Always Works

The kill switch is not part of the authority boundary model in the same way
as other boundaries — it is above the model. It is the mechanism by which the
human can override every authority boundary at once.

Kill switch dominance means: the human's decision to halt the system supersedes
every other authority in the ecosystem. TY AI OS cannot prevent a kill switch
activation. Jaya Runtime cannot prevent it. No operation that is in progress
at the time of activation completes.

The kill switch operates:
- Independently of the UI (non-UI fallback exists)
- Independently of any network connection (local-first means local halt)
- Independently of the current tier (Tier2 does not prevent halt)
- Independently of CRI (Critical CRI does not prevent halt)
- Without auto-restart (the system does not resume after halt without
  explicit human restart)

The kill switch is the guarantee that the human remains the ultimate authority
regardless of what any component's current state is.

---

## Summary: The Authority Boundary Model

The authority boundary model of TY AI OS can be summarized in four principles:

**1. Authority flows downward only.** Human → TY AI OS → Jaya Runtime.
No component grants authority upward. No component self-authorizes.

**2. Boundaries are structural, not behavioral.** The boundaries of each
component are enforced by the absence of capability, not by the promise of
restraint. A component that cannot do something is more trustworthy than a
component that promises not to do it.

**3. The non-weaponization boundary is permanent.** It cannot be amended,
overridden, or relaxed through any governance process. It is the one constraint
that applies universally and without exception.

**4. The kill switch is above the model.** The human's ability to halt the
system supersedes all component authority. No operational state prevents the
human from exercising this override.

---

*Chapter 13 compiled: 2026-03-06 | San Diego (America/Los_Angeles)*
*FIX: BOOK-CLO-007 | MODEL: Claude Sonnet 4.6*
*Classification: CANONICAL TECHNICAL DOCUMENTATION — NON-AUTHORITATIVE RECORD*

---

## Postscript -- Added 2026-03-17 | San Diego

*This chapter was compiled on 2026-03-06 covering TY AI OS authority
boundaries. This postscript records authority boundary extensions since then.*

**Autonomy Classes A, B, C -- Formally Defined (Phase 3, 2026-03-11)**

Phase 3 formally resolved the autonomy classification gap identified before
GAL specification drafting. Three autonomy classes were defined:
Class A -- fully human-authorized, requires explicit approval for every action.
Class B -- bounded autonomy, may act within pre-approved scope without
per-action approval, but cannot escalate its own authority.
Class C -- fully autonomous, reserved for systems that have passed formal
verification against all Core Invariants.
The Autonomy Ceiling Invariant was hardened: no agent may self-promote to a
higher autonomy class under any circumstance.

**Authority Non-Propagation Clause (Phase 3, 2026-03-11)**

A formal authority non-propagation clause was established: authority granted
to an agent does not propagate to agents it contacts, spawns, or influences.
Every agent's authority is determined at registration time by the governance
layer, not by other agents.

**GAL Authority Boundary (Phase 4, 2026-03-13)**

The Global Attestonic Layer introduced a new authority boundary: only a node
with a valid Ed25519 keypair and a governance hash matching the canonical
anchor may generate attestation payloads. Peer nodes cannot extend or modify
each other's authority. Federation (Phase 5 Track B) will extend this
boundary to external peer networks while preserving the non-propagation clause.

**Phase 5 Track A -- Authority Enforcement Extensions (2026-03-16)**

Nonce replay protection (Part 77) and ledger hash binding (Part 78) enforce
authority at the attestation layer. A payload cannot be reused to claim
authority it was granted at a different point in time.

*Postscript compiled: 2026-03-17 | San Diego (America/Los_Angeles)*
*CLO: JAYA-CLO-157 | Model: Claude Sonnet 4.6*