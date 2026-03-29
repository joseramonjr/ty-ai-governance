# TY Compliance Proof Kit v0.1
# Part 103 -- JAYA-CLO-188 | Claude Sonnet 4.6 | 2026-03-28 | San Diego
#
# This document defines what an external builder must implement and prove
# to claim TY governance compliance.
# No TY source code access required.
# No builder contact required.
# Compliance is demonstrated through verifiable proof, not assertion.

## What TY Compliance Means

A TY-compliant system is one that implements verifiable governance
controls and can prove those controls are active without requiring
an auditor to trust the builder's word.

Compliance is not a certification process. It is a proof process.
A compliant system produces signed, verifiable evidence. A non-compliant
system cannot produce this evidence regardless of what it claims.

---

## Section 1 -- Minimum Requirements

A TY-compliant system must implement all of the following:

### REQ-01 -- Append-Only Audit Ledger

The system must maintain an append-only audit ledger. Every governance
decision, permission check, violation, and enforcement action must be
logged before it takes effect. Records cannot be deleted or modified
after creation.

Proof: the system must produce a hash of the current ledger state
that changes when new entries are added and does not change otherwise.

### REQ-02 -- Signed Governance Proof Endpoint

The system must serve a cryptographically signed governance proof on
a public endpoint. The proof must be queryable without authentication.
The proof must contain:

  - A unique proof identifier
  - A timestamp
  - The current ledger hash
  - The active policy identifier and version
  - The node public key (Ed25519)
  - The signed payload (hex)
  - The Ed25519 signature

The proof must be auto-generated at startup and refreshed at regular
intervals without builder intervention.

### REQ-03 -- Human Authority Non-Delegation

The system must never delegate human override authority to any
automated process. Escalation decisions that affect agent status
must require human action. No agent may authorize its own permissions.

Proof: the system must demonstrate that an agent cannot promote its
own permissions or override an escalation decision without human input.

### REQ-04 -- Policy Enforcement

The system must enforce an active policy that governs permitted
operations. The policy must be loaded at startup. If the policy
fails to load the system must default to maximum restriction --
never open access.

Proof: the system must demonstrate that a policy violation results
in a blocked operation, not a degraded-mode permission grant.

### REQ-05 -- Violation Records Are Permanent

The system must treat violation records as permanent. A violation
logged to the ledger cannot be removed. Violation count must
increase monotonically for any given agent.

Proof: the system must demonstrate that a logged violation persists
across a restart.

---

## Section 2 -- Proof Kit Structure

A TY compliance proof consists of five signed proof documents,
one per requirement. Each document is produced by running the
compliance test suite (defined in Part 104 -- JAYA-CLO-189).

### PROOF-01 -- Ledger Append-Only Proof

  Demonstrates: REQ-01
  Method: Record ledger hash H1. Trigger a governance event.
  Record ledger hash H2. Confirm H1 != H2. Confirm H1 state
  is still retrievable and unchanged.
  Pass condition: H1 != H2 and H1 is immutable.

### PROOF-02 -- Signed Endpoint Proof

  Demonstrates: REQ-02
  Method: Query the public endpoint. Retrieve the proof JSON.
  Run signature verification using the embedded public key.
  Pass condition: PASS -- signature valid.

### PROOF-03 -- Human Authority Non-Delegation Proof

  Demonstrates: REQ-03
  Method: Attempt to have an agent authorize its own permission
  expansion. Confirm the attempt is blocked and logged.
  Pass condition: attempt blocked, violation logged, no
  permission granted.

### PROOF-04 -- Policy Enforcement Proof

  Demonstrates: REQ-04
  Method: Set a policy that disables a specific operation.
  Attempt the operation. Confirm it is blocked.
  Pass condition: operation blocked with policy violation reason.

### PROOF-05 -- Violation Persistence Proof

  Demonstrates: REQ-05
  Method: Log a violation. Record violation count V1. Restart
  the system. Query violation count V2.
  Pass condition: V2 >= V1 and the violation record is present.

---

## Section 3 -- Compliance Claim Format

A valid TY compliance claim consists of:

1. All five PROOF-01 through PROOF-05 documents signed by the
   claiming system's active Ed25519 key
2. The node public key used for signing (hex)
3. The timestamp of each proof run
4. The software version and governance spec version claimed

A compliance claim is only valid if all five proofs pass. A system
that passes four of five proofs is not compliant.

---

## Section 4 -- What Compliance Does Not Require

- Access to TY source code
- Contact with the TY builder
- Use of TY runtime binaries
- Any certification body or third party

A builder implementing TY governance from the specification alone
can produce a valid compliance claim. The specification is the
standard. The proofs are the evidence.

---

## Section 5 -- INV-TY-PRIV-1 Boundary

This kit is designed for external builders implementing their own
governance systems. It does not require and must not involve access
to TY source code, internal governance logic, or build records.

A builder using this kit is building their own compliant system.
They are not receiving TY. TY source code is permanently private
per INV-TY-PRIV-1.

---

## Version History

v0.1 -- 2026-03-28 -- Initial release -- Part 103 JAYA-CLO-188