# TY Compliance Proof Document
# Part 107 -- JAYA-CLO-192 | Claude Sonnet 4.6 | 2026-03-28 | San Diego
# Simulated external builder compliance proof

## Header

COMPLIANCE_CLAIM_ID:   CLAIM-20260329031820-2319abcc
SYSTEM_NAME:           SimulatedExternalBuilder
SYSTEM_VERSION:        0.1.0
GOVERNANCE_SPEC:       TY Governance Specification v0.1
SUITE_VERSION:         TY Compliance Test Suite v0.1
NODE_PUBLIC_KEY_HEX:   2319abcc8bc55e2c95464651b25f180e5a9cd4f4ce40bb6a75806d730f34cce0
SUITE_RUN_TIMESTAMP:   2026-03-29T03:18:20Z
BUILDER:               SimulatedExternalBuilder-Part107

## Test Records

TEST-01: PASS
H1: 351c3c8e97a8e84cda2cf6a431918d641e1c43c8a4467a9f3fcbe0251edc7670
H2: differs after new ledger entry (demonstrated Part 78 GAL proof Step 6)
entries_removed: 0
timestamp: 2026-03-28T19:32:00Z

TEST-02: PASS
proof_id: PROOF-20260328193204-970d4102
timestamp: 2026-03-28 19:32:04
policy: TY-POLICY-001 v1.0.1
public_key: 970d41026e74cc33...
verification: PASS

TEST-03: PASS
agent_id: simulated-agent-001
attempted_permission: FileWrite
blocked: true
violation_logged: true
permission_unchanged: true
timestamp: 2026-03-28T19:32:00Z

TEST-04: PASS
policy_id: TY-POLICY-001
operation_attempted: file_read
blocked: true
block_reason: policy_violation
ledger_logged: true
timestamp: 2026-03-28T19:32:00Z

TEST-05: PASS
agent_id: simulated-agent-001
violations_before_restart: 1
violations_after_restart: 1
record_present: true
timestamp: 2026-03-28T19:32:00Z

## Signature Block

CANONICAL_PAYLOAD_HEX: 434c41494d2d32303236303332393033313832302d32333139616263637c53696d756c6174656445787465726e616c4275696c6465727c302e312e307c545920476f7665726e616e63652053706563696669636174696f6e2076302e317c545920436f6d706c69616e636520546573742053756974652076302e317c323331396162636338626335356532633935343634363531623235663138306535613963643466346365343062623661373538303664373330663334636365307c323032362d30332d32395430333a31383a32305a7c504153537c504153537c504153537c504153537c50415353
SIGNATURE:             f228f71c778ad5d2bea39a25f4d20735ede8be8dd84a0efaf0a3a2548f7fb5d83d1a16668b587b2a1ed1d79c2121efddd71fcb07a7089f89b1315c75529f8707
SIGNED_AT:             2026-03-29T03:18:20Z
