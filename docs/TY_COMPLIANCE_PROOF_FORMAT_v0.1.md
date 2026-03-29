# TY Compliance Proof Format v0.1
# Part 105 -- JAYA-CLO-190 | Claude Sonnet 4.6 | 2026-03-28 | San Diego
#
# This document defines the signed output document structure that
# constitutes a valid TY compliance claim.
# A compliance claim without this structure is not valid.
# A compliance claim with a failing signature is not valid.

## Overview

A TY compliance proof document is a structured text file containing
five test records, system metadata, and an Ed25519 signature over
the canonical payload. It is the output of running the TY Compliance
Test Suite (TY_COMPLIANCE_TEST_SUITE_v0.1.md) against a compliant system.

---

## Section 1 -- Document Structure

A valid TY compliance proof document has three sections in this order:

  1. Header
  2. Test Records
  3. Signature Block

All three sections are required. A document missing any section is invalid.

---

## Section 2 -- Header

The header identifies the claiming system and the standards claimed.

Required fields:

  COMPLIANCE_CLAIM_ID    -- unique identifier for this claim
                           format: CLAIM-<YYYYMMDDHHMMSS>-<first 8 hex of public key>
  SYSTEM_NAME            -- name of the claiming system
  SYSTEM_VERSION         -- software version of the claiming system
  GOVERNANCE_SPEC        -- TY Governance Specification v0.1
  SUITE_VERSION          -- TY Compliance Test Suite v0.1
  NODE_PUBLIC_KEY_HEX    -- Ed25519 public key used to sign this document (hex)
  SUITE_RUN_TIMESTAMP    -- ISO timestamp of the full suite run
  BUILDER                -- name or identifier of the system builder

Example:

  COMPLIANCE_CLAIM_ID:   CLAIM-20260328193000-970d4102
  SYSTEM_NAME:           ExampleGovernanceSystem
  SYSTEM_VERSION:        0.1.0
  GOVERNANCE_SPEC:       TY Governance Specification v0.1
  SUITE_VERSION:         TY Compliance Test Suite v0.1
  NODE_PUBLIC_KEY_HEX:   970d41026e74cc3395aad0253ff438da2f62ddf2dc50273dba889b165df100a1
  SUITE_RUN_TIMESTAMP:   2026-03-28T19:30:00Z
  BUILDER:               ExampleBuilder

---

## Section 3 -- Test Records

Five test records in order TEST-01 through TEST-05. Each record
must match the record format defined in TY_COMPLIANCE_TEST_SUITE_v0.1.md.
All five must show PASS. A single FAIL invalidates the entire document.

Required format per record:

  TEST-0X: PASS
  <field>: <value>
  ...
  timestamp: <ISO timestamp>

All five records must be present. Order must be TEST-01, TEST-02,
TEST-03, TEST-04, TEST-05. No records may be omitted or reordered.

---

## Section 4 -- Canonical Payload

The canonical payload is the exact byte sequence that is signed.
It is constructed by concatenating the following fields with pipe
separators in this exact order:

  COMPLIANCE_CLAIM_ID|SYSTEM_NAME|SYSTEM_VERSION|GOVERNANCE_SPEC|
  SUITE_VERSION|NODE_PUBLIC_KEY_HEX|SUITE_RUN_TIMESTAMP|
  TEST-01-result|TEST-02-result|TEST-03-result|TEST-04-result|TEST-05-result

Where TEST-0X-result is the single word PASS or FAIL for each test.

The canonical payload hex must be included in the signature block.

---

## Section 5 -- Signature Block

The signature block contains the Ed25519 signature over the canonical
payload and the hex-encoded payload for independent verification.

Required fields:

  CANONICAL_PAYLOAD_HEX  -- hex encoding of the canonical payload bytes
  SIGNATURE              -- Ed25519 signature over canonical payload (hex)
  SIGNED_AT              -- ISO timestamp of signing

Example:

  CANONICAL_PAYLOAD_HEX: 434c41494d2d...
  SIGNATURE:             9e854ddbc3e9...
  SIGNED_AT:             2026-03-28T19:30:01Z

---

## Section 6 -- Verification Procedure

To verify a TY compliance proof document:

1. Extract NODE_PUBLIC_KEY_HEX from the header.
2. Extract CANONICAL_PAYLOAD_HEX from the signature block.
3. Decode CANONICAL_PAYLOAD_HEX to bytes.
4. Extract SIGNATURE from the signature block.
5. Verify the Ed25519 signature over the decoded payload bytes
   using the public key.
6. Confirm all five test records show PASS.
7. Confirm COMPLIANCE_CLAIM_ID format is valid.
8. Confirm SUITE_RUN_TIMESTAMP is present and parseable.

A document passes verification if and only if:
- Signature verification returns valid
- All five test records show PASS
- All required fields are present in all three sections

---

## Section 7 -- Invalidity Conditions

A compliance proof document is invalid if any of the following are true:

- Any test record shows FAIL
- Any test record is missing
- The signature does not verify against the canonical payload
- The canonical payload does not match the reconstructed payload
- Any required header field is missing
- The signature block is missing or incomplete
- The document has been modified after signing

An invalid compliance proof document is not a compliance claim.
It is evidence of a non-compliant or tampered system.

---

## Section 8 -- INV-TY-PRIV-1 Boundary

This format is designed for external builders. Producing a valid
compliance proof document does not require access to TY source code,
TY internal logic, or TY build records. The format is derived from
the public TY Governance Specification v0.1.

TY source code is permanently private per INV-TY-PRIV-1.

---

## Version History

v0.1 -- 2026-03-28 -- Initial release -- Part 105 JAYA-CLO-190