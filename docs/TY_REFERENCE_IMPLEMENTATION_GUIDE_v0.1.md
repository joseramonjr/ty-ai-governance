# TY Reference Implementation Guide v0.1
# Part 106 -- JAYA-CLO-191 | Claude Sonnet 4.6 | 2026-03-28 | San Diego
#
# This guide explains how to implement TY governance in a new system
# from scratch without access to TY source code.
# The TY Governance Specification v0.1 is the standard.
# This guide is the implementation roadmap.
# INV-TY-PRIV-1: TY source code is permanently private.
# Everything in this guide is derived from the public specification.

## Who This Guide Is For

This guide is for builders who want to implement a TY-compliant
governance system in their own software. You do not need TY binaries.
You do not need TY source code. You do not need to contact the TY builder.

You need this guide, the TY Governance Specification v0.1, and the
TY Compliance Proof Kit v0.1.

---

## Section 1 -- Core Architecture Requirements

A TY-compliant system must implement these five architectural components.
They are not optional. A system missing any component cannot produce
a valid compliance proof.

### Component 1 -- Append-Only Audit Ledger

Implement a ledger that records every governance event. The ledger
must satisfy these properties:

  - Every record is written before the action it records takes effect
  - Records cannot be deleted or modified after creation
  - The ledger produces a deterministic hash of its current state
  - The hash changes when new records are added
  - The hash does not change when no records are added

Implementation options:
  - SQLite with INSERT-only operations and no DELETE or UPDATE
  - Append-only log file with SHA-256 hash chain
  - Any database with write-once enforced at the application layer

The hash function must be deterministic. SHA-256 over the concatenated
record content is acceptable. The implementation must produce the same
hash for the same set of records regardless of when it is computed.

### Component 2 -- Ed25519 Signing Infrastructure

Implement Ed25519 keypair management. The system must:

  - Generate a keypair at first startup
  - Persist the keypair across restarts
  - Never expose the private key outside the process
  - Use the private key to sign governance proof payloads
  - Include the public key in every signed document

Recommended libraries:
  - Rust: ed25519-dalek
  - Python: PyNaCl or cryptography
  - Go: golang.org/x/crypto/ed25519
  - Node.js: @noble/ed25519

The signing key must be stored securely. File system storage with
restricted permissions is acceptable for a local-first system.

### Component 3 -- Signed Governance Proof Endpoint

Implement an HTTP server that serves a signed governance proof. The
endpoint must satisfy these properties:

  - Listens on a configurable port
  - Serves GET requests without authentication
  - Returns a JSON object with all required proof fields
  - Auto-generates a proof at startup
  - Refreshes the proof at regular intervals (60 seconds recommended)
  - Never exposes internal agent data, source code, or private keys

Required proof fields:
  proof_id            -- unique identifier
  timestamp           -- proof generation time
  ledger_hash         -- current ledger hash at proof time
  policy_id           -- active policy identifier
  policy_version      -- active policy version
  node_public_key_hex -- Ed25519 public key (hex)
  signed_payload_hex  -- canonical payload (hex)
  signature           -- Ed25519 signature over payload (hex)

Canonical payload construction (pipe-separated):
  proof_id|timestamp|ledger_hash|policy_id|policy_version|node_public_key_hex

### Component 4 -- Policy Engine

Implement a policy loader and enforcer. The policy must:

  - Be loaded from a configuration file at startup
  - Define which operations are permitted
  - Be checked before any permitted operation executes
  - Default to maximum restriction if the policy file fails to load
  - Be reloadable without system restart

Minimum policy fields:
  policy_id               -- unique policy identifier
  version                 -- policy version string
  file_read_permitted     -- boolean
  file_write_permitted    -- boolean
  inter_agent_permitted   -- boolean

Policy enforcement rule: if a policy field is false, the operation
is blocked before execution. The block is logged to the audit ledger.
No degraded-mode fallback. No silent permission grants.

### Component 5 -- Agent Registry with Violation Tracking

Implement an agent registry that tracks registered agents and their
violations. The registry must:

  - Require explicit registration before any agent can act
  - Track violation count per agent
  - Persist violation records across restarts
  - Never allow an agent to authorize its own permissions
  - Never allow violation records to be deleted

Minimum agent record fields:
  agent_id          -- unique identifier
  permissions       -- list of permitted operations
  status            -- Active, Suspended, or Revoked
  violation_count   -- monotonically increasing integer
  registered_at     -- ISO timestamp

---

## Section 2 -- Implementation Order

Build in this order. Each component depends on the previous.

  Step 1: Audit ledger (Component 1)
          Reason: everything else logs to the ledger.
          Do not build anything else until the ledger works.

  Step 2: Ed25519 signing (Component 2)
          Reason: the proof endpoint requires signing.

  Step 3: Policy engine (Component 4)
          Reason: the agent registry enforces policy.

  Step 4: Agent registry (Component 5)
          Reason: agents need the ledger and policy to be ready.

  Step 5: Proof endpoint (Component 3)
          Reason: requires ledger hash and signing infrastructure.

Do not skip steps. Do not build in a different order.

---

## Section 3 -- Proof Condition Checklist

Before running the compliance test suite confirm all of the following:

  [ ] Ledger is running and accepting records
  [ ] Ledger hash changes when a new record is added
  [ ] Ed25519 keypair is generated and persisted
  [ ] Proof endpoint is live and returning HTTP 200
  [ ] Proof endpoint returns all required JSON fields
  [ ] Proof signature verifies with embedded public key
  [ ] Policy file is loaded and enforced
  [ ] Policy default-to-restriction on load failure is implemented
  [ ] Agent registry is running with at least one registered agent
  [ ] Violation records persist across a restart

If any item is unchecked the system is not ready for the test suite.

---

## Section 4 -- Common Implementation Errors

These errors will cause compliance test failures.

Error: Ledger hash does not change after new records
Cause: Hash computed over schema instead of record content
Fix: Hash over concatenated record field values, not table structure

Error: Proof endpoint returns no_proof_available on cold start
Cause: Proof generated only on manual trigger
Fix: Auto-generate proof at startup before serving first request

Error: Policy load failure opens access instead of restricting
Cause: Missing failsafe default
Fix: If policy file is missing or malformed, set all permitted
     fields to false

Error: Violation count resets to zero after restart
Cause: Violations stored in memory only
Fix: Persist violation records to the audit ledger or database

Error: Signature verification fails with valid proof
Cause: Canonical payload constructed differently at sign and verify
Fix: Use identical field order and pipe separator at both points

---

## Section 5 -- INV-TY-PRIV-1 Boundary

This guide is derived entirely from the public TY Governance
Specification v0.1. It does not contain TY source code, internal
implementation details, or build records.

A builder implementing this guide is building their own system.
They are not receiving TY. The specification is the standard.
The implementation is the builder's own work.

TY source code is permanently private per INV-TY-PRIV-1.

---

## Version History

v0.1 -- 2026-03-28 -- Initial release -- Part 106 JAYA-CLO-191