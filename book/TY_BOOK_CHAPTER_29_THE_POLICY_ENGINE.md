# Chapter 29 -- The Policy Engine

**CLO:** JAYA-CLO-166 (seal)
**Parts:** 85 -- 86 -- 87
**Phase:** Phase 5 Track B -- B2
**Sealed:** 2026-03-21 | San Diego (America/Los_Angeles)
**Builder:** Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
**Model:** Claude Sonnet 4.6

---

## The Gap That Preceded This Chapter

From the beginning of Jaya Runtime development, governance rules were
hardcoded into the binary. Every boundary -- the maximum permitted risk
level, whether file reads were allowed, whether inter-agent communication
was permitted -- existed as constants and conditions written directly into
Rust source code.

This created a structural gap. The TY Governance Specification is a
document. The Jaya Runtime is a compiled binary. When the specification
changed, the binary had to be rebuilt. A developer had to find the right
constant, change it, recompile, and redeploy. The gap between what the
governance document said and what the runtime enforced could only be
closed by writing new code.

This is not governance. A governance system that requires a developer to
change what it enforces is a build artifact, not an enforcement layer.
The B2 Policy Engine was built to close this gap permanently.

---

## What the Policy Engine Is

The Policy Engine is the capability for the Jaya Runtime to evaluate
agent behavior against rules expressed in the TY Governance Specification
without those rules being hardcoded into the runtime at build time.

It has three components, each built in a separate part:

**Part 85 -- Foundation:** The schema, the loader, and the Core Invariant
validation gate. A Policy struct holds boundary definitions as data fields.
A PolicyLoader reads a JSON file from the governance repository, validates
it against the Autonomy Ceiling Invariant, and returns a PolicyState. If
anything fails -- file absent, empty, corrupt, or invariant violation --
the loader does not fail open. It returns maximum restriction.

**Part 86 -- Enforcement Hooks:** The loaded policy is wired into five
runtime enforcement points. Every module execution is checked against
max_allowed_risk_level before the structural lock is acquired. File read,
file write, inter-agent communication, and federation participation are
each gated by their corresponding policy boolean. A policy violation is
logged and the operation is rejected.

**Part 87 -- Hot-Reload:** The runtime can reload the policy from disk
without restart. A reload_policy Tauri command reads the current policy
file, validates it against Core Invariants, replaces the managed
PolicyState in place, and logs the reload as a governance event. The
runtime reflects the updated policy immediately.

---

## The Core Invariant Decision

Before any policy code was written, an architectural decision was made
that defines the entire Policy Engine: Core Invariants are expressed as
first-class Rust types.

The governance document 01_CORE_INVARIANTS.md contains the Autonomy
Ceiling Invariant -- a formally defined hard ceiling on what any policy
file can instruct the runtime to do. This invariant existed as a
document. Part 85 made it executable.

core_invariants.rs defines PolicyViolatesInvariant -- an enum with
eleven named violation types derived directly from the Autonomy Ceiling
Invariant. The InvariantCheckable trait defines eleven boolean methods.
CoreInvariantCheck::validate runs all eleven checks against any type
that implements the trait. A policy that fails any check is rejected
before it enters runtime state.

The Policy struct implements InvariantCheckable with all eleven methods
returning false. This is correct by design. The struct has no field that
can grant a capability, expand a permission, or modify autonomy state.
The invariant check is a structural guarantee -- not a runtime check on
values, but an architectural constraint on what fields can exist.

If a future developer adds a granting field to the Policy struct, the
InvariantCheckable implementation must return true for the corresponding
check. CoreInvariantCheck::validate will then reject every policy loaded
with that field. The governance constraint is self-enforcing at the type
level.

---

## The Fail-Safe Invariant

The spec required: an empty or corrupt policy file does not silently grant
unrestricted access -- it triggers a fail-safe that defaults to maximum
restriction.

Policy::maximum_restriction() returns a Policy with every field at its
most restrictive value: risk level zero, autonomy tier zero, all
operations disabled. PolicyLoader returns this in every failure case --
file not found, empty file, JSON parse error, invariant violation. There
is no third state. The loader returns either a valid policy or maximum
restriction. Nothing is permitted by default.

This is deny-by-default applied to the policy layer itself.

---

## The BOM Problem

During proof condition verification, the PolicyLoader was returning
maximum restriction despite the policy file existing on disk. The
diagnostic command revealed the cause: the file had been written with a
UTF-8 BOM (byte order mark) prepended by
[System.IO.File]::WriteAllLines() with the standard UTF8 encoding.

serde_json does not handle BOM. It sees a non-JSON character at position
1 and fails silently -- triggering the fail-safe correctly, as designed.
The fix is to use WriteAllText with System.Text.UTF8Encoding($false)
which produces UTF-8 without BOM.

This is now the required method for all JSON file writes in the TY
ecosystem. The write rules have been updated accordingly.

---

## The B2 Proof Condition

The spec defined the B2 proof condition:

A governance rule is expressed in the policy definition format. The
Jaya Runtime loads the policy without a rebuild. An agent action that
violates the policy triggers a violation log. The policy is updated to
tighten a boundary. The runtime reflects the updated policy without
restart. Cargo check passes with zero errors.

All six steps were verified in the live running Jaya Runtime on
2026-03-21:

Step 1 -- PASS: TY-POLICY-001 v1.1.0 expressed in JSON policy format
with max_allowed_risk_level set to 5.

Step 2 -- PASS: load_active_policy confirmed policy loaded without
rebuild. is_failsafe: false. policy_id: TY-POLICY-001.

Step 3 -- PASS: run_system_health_check (risk level 10) rejected with:
Policy violation: module risk 10 exceeds policy maximum 5. Violation
logged to ledger as POLICY_VIOLATION.

Step 4 -- PASS: Policy tightened on disk -- max_allowed_risk_level
dropped from 60 to 5 without touching any Rust code.

Step 5 -- PASS: reload_policy called without restart. Managed
PolicyState replaced in place. Runtime immediately reflected the
tightened policy.

Step 6 -- PASS: cargo check = 0 errors throughout all three parts.

Step 7 -- Additional verification: Policy restored to baseline v1.0.1,
max_risk=60. reload_policy called. run_system_health_check succeeded --
confirming the policy engine correctly permits operations within policy
bounds, not just rejects violations.

---

## What Changed

Before the Policy Engine, changing a governance boundary required:
opening Rust source code, finding the correct constant or condition,
modifying it, running cargo check, committing, and rebuilding the binary.

After the Policy Engine, changing a governance boundary requires:
editing one field in active_policy.json and calling reload_policy.

No code change. No rebuild. No redeploy. The governance specification is
directly executable.

The boundary between the governance document and the runtime enforcement
is now a single JSON file under version control in the governance
repository. Every change to that file is committed, timestamped, and
attributable. The audit trail is complete.

---

## What Comes Next

B2 is sealed. The dependency chain defined in TY_PHASE5_SPEC_v0.1.md
requires B3 -- the Transparency Layer -- to begin next.

B3 proof condition: an external party verifies governance proof without
system access. The Transparency Layer produces a public, cryptographically
verifiable governance proof at defined intervals. Verification requires
no credentials. The proof never exposes internal agent identity or
behavior data.

Chapter 29 is sealed. Part 88 begins next.

---

*Chapter Type: SEALED*
*Sealed: 2026-03-21 | San Diego (America/Los_Angeles)*
*CLO: JAYA-CLO-166*
*Builder: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.*
*Model: Claude Sonnet 4.6
---

## Real-World Impact -- What B2 Means for Operators

The governance layer is responsive to human authority in real time.
That is what governance is supposed to mean.

Before B2, governance boundaries existed inside a compiled binary. An
operator who needed to tighten a risk ceiling, disable file writes, or
restrict federation participation had to wait for a developer. The code
had to be found, modified, compiled, and redeployed. During that entire
window the old boundary remained in effect.

After B2, that same operator opens active_policy.json, changes one
field, and calls reload_policy. The boundary changes immediately. No
developer. No rebuild. No downtime. The system enforces the new rule
and logs the change as a governance event in the audit record.

**What is implemented and proven as of 2026-03-21:**

The following was verified in the live running Jaya Runtime:

- max_allowed_risk_level was changed from 60 to 5 by editing
  active_policy.json -- no code change, no rebuild.
- reload_policy was called without restarting the runtime.
- run_system_health_check (risk level 10) was immediately rejected
  with: "Policy violation: module risk 10 exceeds policy maximum 5."
- The violation was logged to the governance ledger.
- The policy was restored to baseline and reloaded.
- run_system_health_check then succeeded -- confirming the policy
  engine correctly permits operations within bounds.

The active_policy.json file is committed to the ty-ai-governance
repository. Every change to it is a committed record with a timestamp
and attribution. This is the beginning of a verifiable, auditable
governance boundary history.

**What is not yet implemented:**

The following capabilities are not yet built and are noted here so
the record is accurate:

- No policy management UI exists. Policy changes require direct file
  editing and a manual reload_policy call.
- The runtime does not watch the policy file for changes
  automatically. Reload must be triggered explicitly.
- Only one policy file exists. Multiple policy files for different
  operating contexts have not been built.
- This system runs on one machine operated by the builder. No
  external operators, no deployment, no multi-machine enforcement.
- The audit trail in the governance repository is real and
  cryptographically chained, but no formal process exists yet for
  regulators or external parties to query it. That is the B3
  Transparency Layer -- not yet built.

**The civilizational point:**

TY AI OS was designed around one ordering principle: governance must
precede intelligence. A system that is intelligent before it is
governed is ungovernable.

B2 advances that principle in a specific and concrete way on one
machine operated by one builder. The governance boundary between the
specification and the enforcement is now a JSON file -- not compiled
code. The operator can change it in seconds without touching the
binary. That is a real, proven, and documented capability as of
today.

What it will mean when TY AI OS reaches multiple machines, external
operators, and real-world deployment is described in the post-Phase-5
roadmap. That work has not begun. What is written here describes only
what exists and has been proven today.

*Addendum sealed: 2026-03-21 | San Diego (America/Los_Angeles)*
*CLO: JAYA-CLO-166*
