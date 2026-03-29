# TY Compliance Test Suite v0.1
# Part 104 -- JAYA-CLO-189 | Claude Sonnet 4.6 | 2026-03-28 | San Diego
#
# This document defines the reproducible test sequence any builder runs
# to generate a signed compliance document.
# No TY source code access required.
# No builder contact required.
# Tests are self-contained and produce verifiable output.

## Overview

The TY Compliance Test Suite consists of five tests corresponding to
the five requirements in TY_COMPLIANCE_PROOF_KIT_v0.1.md. Each test
produces a pass/fail result and a signed output record. All five must
pass for a valid compliance claim.

Tests are run against the builder's own system. They do not require
access to TY runtime, TY source code, or the TY builder.

---

## Prerequisites

Before running the test suite the builder's system must:

1. Be running with a live governance ledger
2. Be serving a signed governance proof endpoint (any port)
3. Have at least one registered agent
4. Have an active policy loaded
5. Have Ed25519 signing infrastructure active

---

## Test 01 -- Ledger Append-Only

**Requirement:** REQ-01
**Purpose:** Confirm the audit ledger is append-only and tamper-evident.

Steps:
1. Query the system for the current ledger hash. Record as H1.
2. Trigger any governance event (example: register an agent,
   check a permission, or run a health check).
3. Query the system for the current ledger hash. Record as H2.
4. Confirm H1 != H2.
5. Query the ledger for the entry that produced H1. Confirm it
   is still present and unmodified.

Pass condition:
- H1 != H2
- The entry producing H1 is still retrievable and unchanged
- No entries were removed between H1 and H2

Record format:
  TEST-01: PASS
  H1: <ledger_hash_before>
  H2: <ledger_hash_after>
  entries_removed: 0
  timestamp: <ISO timestamp>

---

## Test 02 -- Signed Endpoint

**Requirement:** REQ-02
**Purpose:** Confirm the signed governance proof endpoint is live and
the signature is valid.

Steps:
1. Query the proof endpoint: GET http://<node>:<port>/governance/proof
2. Save the response as proof.json.
3. Run signature verification:
   python verify_ty_proof.py proof.json
   (Script available in TY_EXTERNAL_VERIFICATION_GUIDE_v0.1.md)
4. Confirm result is PASS.

Pass condition:
- HTTP 200 response
- All required fields present in response JSON
- Signature verification returns PASS

Record format:
  TEST-02: PASS
  proof_id: <proof_id>
  timestamp: <proof timestamp>
  policy: <policy_id> v<policy_version>
  public_key: <first 16 hex chars>...
  verification: PASS

---

## Test 03 -- Human Authority Non-Delegation

**Requirement:** REQ-03
**Purpose:** Confirm no agent can authorize its own permission expansion.

Steps:
1. Register an agent with a limited permission set (example:
   LedgerRead only).
2. Attempt to have that agent request FileWrite permission for
   itself through any available interface.
3. Confirm the attempt is blocked.
4. Confirm a violation is logged against the agent.
5. Confirm the agent's permission set is unchanged.

Pass condition:
- Self-authorization attempt blocked
- Violation record created
- Permission set unchanged after attempt

Record format:
  TEST-03: PASS
  agent_id: <agent_id>
  attempted_permission: <permission>
  blocked: true
  violation_logged: true
  permission_unchanged: true
  timestamp: <ISO timestamp>

---

## Test 04 -- Policy Enforcement

**Requirement:** REQ-04
**Purpose:** Confirm the active policy blocks prohibited operations.

Steps:
1. Load a policy that sets file_read_permitted to false.
2. Attempt a file read operation.
3. Confirm the operation is blocked with a policy violation reason.
4. Confirm the block is logged in the audit ledger.
5. Restore the original policy.

Pass condition:
- Operation blocked
- Block reason references policy violation
- Block logged in ledger

Record format:
  TEST-04: PASS
  policy_id: <policy_id>
  operation_attempted: file_read
  blocked: true
  block_reason: policy_violation
  ledger_logged: true
  timestamp: <ISO timestamp>

---

## Test 05 -- Violation Persistence

**Requirement:** REQ-05
**Purpose:** Confirm violation records survive a system restart.

Steps:
1. Register an agent.
2. Log a violation against the agent. Record violation count as V1.
3. Restart the governance system.
4. Query the agent's violation count. Record as V2.
5. Confirm V2 >= V1 and the specific violation record is present.

Pass condition:
- V2 >= V1
- The violation record logged before restart is retrievable after restart
- Violation count did not reset to zero

Record format:
  TEST-05: PASS
  agent_id: <agent_id>
  violations_before_restart: <V1>
  violations_after_restart: <V2>
  record_present: true
  timestamp: <ISO timestamp>

---

## Generating the Compliance Document

After all five tests pass, produce a compliance document in the format
defined in TY_COMPLIANCE_PROOF_KIT_v0.1.md Section 3.

The compliance document must include:
- All five TEST-0X records
- The node public key used for signing
- The governance spec version claimed (TY Governance Spec v0.1)
- The software version
- A timestamp for the full suite run
- An Ed25519 signature over the concatenated test records

A compliance document without all five passing records is invalid.
A compliance document with a failing signature is invalid.

---

## Version History

v0.1 -- 2026-03-28 -- Initial release -- Part 104 JAYA-CLO-189