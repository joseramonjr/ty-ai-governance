# TY AI OS — Book of TY
# Chapter 59: Building a TY-Compliant System
# A Reference Implementation Guide for External Builders
#
# Document Type: Canonical Book Documentation — Phase 6 Track B Record
# Era Covered: March 2026
# Author: Claude Sonnet 4.6 (CLO) — compiled from Phase 6 Track B session records
# Date: 2026-03-28 | San Diego (America/Los_Angeles)
# FIX: Part 106 — JAYA-CLO-191
# Audience: External builders implementing TY governance from scratch
# Classification: CANONICAL BOOK DOCUMENTATION

---

## Who This Chapter Is For

This chapter is not for users of TY AI OS. It is not for organizations installing TY AI OS on their systems. It is for builders — engineers, architects, and organizations who want to implement TY governance principles in their own software, in their own language, on their own infrastructure, without using TY source code and without contacting the TY builder.

TY source code is permanently private under INV-TY-PRIV-1. That will not change. But the governance principles that TY AI OS implements are not secret. They are documented in the TY Governance Specification v0.1, the TY Compliance Proof Kit v0.1, and this reference guide. Any builder who reads these documents and implements what they describe can produce a TY-compliant governance system. The specification is the standard. The proofs are the evidence.

This guide was produced at Part 106, JAYA-CLO-191, on 2026-03-28 as the fourth document in the Phase 6 Track B compliance kit. It defines the five architectural components a builder must implement, the order in which to build them, common errors that will cause compliance test failures, and the checklist to run before attempting the test suite.

---

## The Five Architectural Components

A TY-compliant system must implement five architectural components. They are not optional. A system missing any one of them cannot produce a valid compliance proof.

### Component 1 — Append-Only Audit Ledger

The ledger is the foundation of everything else. It must be built first because every other component writes to it.

The ledger must record every governance event. Every record is written before the action it records takes effect. Records cannot be deleted or modified after creation. The ledger produces a deterministic hash of its current state. The hash changes when new records are added. The hash does not change when no records are added.

Implementation options: SQLite with INSERT-only operations and no DELETE or UPDATE, an append-only log file with a SHA-256 hash chain, or any database with write-once enforced at the application layer.

The hash function must be deterministic. SHA-256 over the concatenated record content is acceptable. The implementation must produce the same hash for the same set of records regardless of when it is computed. This is a common error source — builders who hash the table schema rather than the record content will find that Test 01 fails because the hash does not change when records are added.

### Component 2 — Ed25519 Signing Infrastructure

Ed25519 is the required signing algorithm. The system must generate an Ed25519 keypair at first startup, persist the keypair across restarts, never expose the private key outside the process, use the private key to sign governance proof payloads, and include the public key in every signed document.

The signing key must be stored securely. File system storage with restricted permissions is acceptable for a local-first system. The critical constraint is that the private key must never appear in any output, any log, any governance proof, or any compliance document. The TY Compliance Proof Example committed to the ty-ai-governance repository demonstrates correct behavior — the NODE_PUBLIC_KEY_HEX field contains only the public key.

Recommended libraries: Rust (ed25519-dalek), Python (cryptography library), Go (golang.org/x/crypto/ed25519), Node.js (@noble/ed25519).

### Component 3 — Signed Governance Proof Endpoint

The proof endpoint is the public interface through which governance state is verified. It must listen on a configurable port, serve GET requests without authentication, return a JSON object with all required proof fields, auto-generate a proof at startup, and refresh the proof at regular intervals — 60 seconds is recommended.

Required proof fields: proof_id (unique identifier), timestamp (proof generation time), ledger_hash (current ledger hash at proof time), policy_id (active policy identifier), policy_version (active policy version), node_public_key_hex (Ed25519 public key in hex), signed_payload_hex (canonical payload in hex), and signature (Ed25519 signature over payload in hex).

The canonical payload is constructed by concatenating these six fields with pipe separators in exact order: proof_id, timestamp, ledger_hash, policy_id, policy_version, node_public_key_hex. The pipe separator and the exact order are both required. Any deviation produces a different payload and verification will fail.

The endpoint must never expose internal agent data, source code, or private keys. The proof is the public interface. Everything behind it is private.

### Component 4 — Policy Engine

The policy engine defines what operations are permitted and enforces those definitions at runtime. The policy must be loaded from a configuration file at startup, define which operations are permitted, be checked before any permitted operation executes, default to maximum restriction if the policy file fails to load, and support policy reload without system restart.

The fail-closed default is the most important constraint. A builder who implements a governance system that opens access when the policy file is missing or malformed has built a system that fails in exactly the conditions when governance matters most. Test 04 of the compliance test suite specifically validates fail-closed behavior. A system that opens access on policy load failure will fail Test 04 and cannot claim compliance.

### Component 5 — Agent Registry with Violation Tracking

The agent registry tracks registered agents and their violations. Agents must be explicitly registered before they can act. The registry tracks violation count per agent. Violation records must persist across restarts — a common error is storing violations in memory only. The registry must never allow an agent to authorize its own permissions. Violation records must never be deleted.

Minimum agent record fields: agent_id (unique identifier), permissions (list of permitted operations), status (Active, Suspended, or Revoked), violation_count (monotonically increasing integer), and registered_at (ISO timestamp).

---

## The Build Order

Build in this exact order. Each component depends on the previous.

Step 1: Audit ledger. Everything else logs to the ledger. Do not build anything else until the ledger works and the hash changes correctly when records are added.

Step 2: Ed25519 signing infrastructure. The proof endpoint requires signing. Build the keypair generation and persistence before building the endpoint.

Step 3: Policy engine. The agent registry enforces policy. Build the policy loader and enforcer before building the registry.

Step 4: Agent registry. Agents need the ledger and policy to be ready. Build the registry after both are verified working.

Step 5: Proof endpoint. The endpoint requires ledger hash and signing infrastructure. Build it last, after all other components are verified.

Do not skip steps. Do not build in a different order. The order is not a suggestion — it reflects the dependency structure of the five components.

---

## Common Implementation Errors

These errors will cause compliance test failures. They are documented because each one was identified during the Phase 6 Track B proof condition work.

Error: Ledger hash does not change after new records are added.
Cause: Hash computed over the schema or table structure rather than the record content.
Fix: Hash over concatenated record field values, not the table definition.

Error: Proof endpoint returns an error on cold start instead of a valid proof.
Cause: Proof generated only on manual trigger or first request, not at startup.
Fix: Auto-generate the proof at application startup, before serving any requests.

Error: Policy load failure opens access instead of restricting it.
Cause: Missing fail-closed default in policy loader.
Fix: If the policy file is missing or malformed, set all permitted fields to false before continuing.

Error: Violation count resets to zero after system restart.
Cause: Violations stored in application memory rather than persisted to the ledger or database.
Fix: Write every violation record to persistent storage at the moment it is created.

Error: Signature verification fails on a proof document that was signed correctly.
Cause: Canonical payload constructed with a different field order or a different separator at signing versus verification.
Fix: Use identical field order and pipe separator at both signing and verification. Test against the TY_COMPLIANCE_PROOF_EXAMPLE_v0.1.md to confirm your verification implementation is correct before running the full compliance test suite.

---

## Pre-Test Checklist

Before running the compliance test suite, verify all of the following:

- Ledger is running and accepting records
- Ledger hash changes when a new record is added
- Ledger hash does not change when no records are added
- Ed25519 keypair is generated and persisted across a restart
- Proof endpoint is live and returning HTTP 200
- Proof endpoint returns all required JSON fields
- Proof signature verifies with embedded public key
- Policy file is loaded and enforced at startup
- Policy default-to-restriction on load failure is implemented and tested
- Agent registry is running with at least one registered agent
- Violation records persist across a system restart

If any item is unchecked, the system is not ready for the test suite. Running the suite against an unprepared system produces misleading failures that obscure the real state of the implementation.

---

## INV-TY-PRIV-1 Boundary

This guide is derived entirely from the public TY Governance Specification v0.1. It does not contain TY source code, internal implementation details, or build records from Jaya Runtime, Luke AI, or Jayme AI.

A builder implementing this guide is building their own system. They are not receiving TY. The specification is the standard. The implementation is the builder's own work. TY source code is permanently private under INV-TY-PRIV-1 and that will not change.

The goal of the compliance kit is not to replicate TY — it is to enable any builder to implement the same governance principles that TY implements and to prove that implementation through the same cryptographic proof process. The principles are public. The evidence is verifiable. The mathematics is the authority.

---

*Chapter 59 compiled: 2026-05-20 | San Diego (America/Los_Angeles)*
*Source: Phase 6 Track B session records, Part 106, JAYA-CLO-191, 2026-03-28*
*FIX: Part 106 — JAYA-CLO-191 | MODEL: Claude Sonnet 4.6*
*Classification: CANONICAL BOOK DOCUMENTATION*