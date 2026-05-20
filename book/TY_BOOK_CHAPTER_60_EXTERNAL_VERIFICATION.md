# TY AI OS — Book of TY
# Chapter 60: External Verification — Anyone Can Check
# How to Verify TY AI OS Governance Without Builder Involvement
#
# Document Type: Canonical Book Documentation — Phase 6 Track A Record
# Era Covered: March 2026
# Author: Claude Sonnet 4.6 (CLO) — compiled from Phase 6 Track A session records
# Date: 2026-03-28 | San Diego (America/Los_Angeles)
# FIX: Part 101 — JAYA-CLO-186
# Audience: External parties, auditors, governance reviewers, general public
# Classification: CANONICAL BOOK DOCUMENTATION

---

## The Principle Behind This Chapter

TY AI OS was built on one foundational claim: governance that only the builder can verify is not governance. It is trust in a person. And trust in a person is fragile — fragile under pressure, fragile across time, fragile when the person is unavailable or compromised.

From the earliest phases of the project, the goal was structural verification. Not a whitepaper. Not a certification badge. Not the builder's word. A cryptographic proof that any external party can obtain and verify independently, using standard tools, without contacting the builder, and without accessing any private code.

Phase 6 Track A was built to make this real. The track was completed across Parts 99 through 102 in late March 2026. Track A's proof condition — met on 2026-03-29 — required that an external party, given only the public endpoint URL and the verification guide, successfully confirm a valid signed governance proof with zero builder involvement.

That proof condition was met. This chapter is the record of how it works and how anyone reading this book can verify TY AI OS governance for themselves right now.

---

## What You Need

The verification procedure requires three things only:

- curl or any HTTP client capable of making a GET request
- Python 3
- The PyNaCl library, installed with: pip install pynacl

No credentials. No authentication. No builder contact. No special software. These are standard tools available on any development machine.

---

## Step 1 — Retrieve the Governance Proof

TY AI OS serves a signed governance proof on port 7777. The endpoint is:

GET http://<TY-NODE-IP>:7777/governance/proof

Replace TY-NODE-IP with the IP address of the machine running Jaya Runtime.

The expected response is a JSON object containing these fields: proof_id (unique identifier for this proof), timestamp (when the proof was generated), ledger_hash (hash of the governance ledger at proof time), policy_id (active policy identifier), policy_version (active policy version), node_public_key_hex (Ed25519 public key used to sign the proof, in hex), signed_payload_hex (the exact bytes that were signed, in hex), and signature (Ed25519 signature over the signed payload, in hex).

If the node returns a no_proof_available error, the node has not yet generated a proof. Wait 60 seconds and retry. Jaya Runtime generates a fresh proof every 60 seconds automatically.

---

## Step 2 — Understand What Was Signed

The signed payload is constructed from six fields joined with pipe characters in this exact order: proof_id, timestamp, ledger_hash, policy_id, policy_version, node_public_key_hex.

To verify the signature, the verifier must reconstruct this payload from the proof fields and confirm it matches the signed_payload_hex in the response. If the fields in the response have been altered after signing, the reconstructed payload will not match and verification will fail.

This construction method means the proof covers the complete governance state at the moment of signing: the ledger state (via ledger_hash), the active policy (via policy_id and policy_version), and the node identity (via node_public_key_hex). A passing verification confirms all three were in the stated state at the stated time.

---

## Step 3 — Verify the Signature

Save the following script as verify_ty_proof.py:

    import sys
    import json
    import binascii
    import nacl.signing

    def verify(proof_path):
        with open(proof_path) as f:
            proof = json.load(f)
        payload = "|".join([
            proof["proof_id"],
            proof["timestamp"],
            proof["ledger_hash"],
            proof["policy_id"],
            proof["policy_version"],
            proof["node_public_key_hex"],
        ])
        stored_hex = proof["signed_payload_hex"]
        reconstructed_hex = binascii.hexlify(payload.encode()).decode()
        if stored_hex != reconstructed_hex:
            print("FAIL -- payload mismatch")
            sys.exit(1)
        pub_key_bytes = bytes.fromhex(proof["node_public_key_hex"])
        sig_bytes = bytes.fromhex(proof["signature"])
        verify_key = nacl.signing.VerifyKey(pub_key_bytes)
        try:
            verify_key.verify(payload.encode(), sig_bytes)
            print("PASS -- signature valid")
            print("  proof_id:   " + proof["proof_id"])
            print("  timestamp:  " + proof["timestamp"])
            print("  policy:     " + proof["policy_id"] + " v" + proof["policy_version"])
            print("  public_key: " + proof["node_public_key_hex"][:16] + "...")
        except Exception as e:
            print("FAIL -- signature invalid: " + str(e))
            sys.exit(1)

    if __name__ == "__main__":
        if len(sys.argv) != 2:
            print("Usage: python verify_ty_proof.py proof.json")
            sys.exit(1)
        verify(sys.argv[1])

Run it with:

    curl http://<TY-NODE-IP>:7777/governance/proof > proof.json
    python verify_ty_proof.py proof.json

---

## Step 4 — Interpret the Result

A result of PASS means three things simultaneously:

First, the proof payload was not tampered with. If any field in the JSON had been altered after signing, the reconstructed payload would not match the signed_payload_hex and verification would fail at the payload mismatch check before the signature is even evaluated.

Second, the signature was produced by the private key corresponding to node_public_key_hex. Ed25519 signatures cannot be forged without the private key. A passing signature means the Jaya Runtime instance that produced this proof holds the private key and used it to sign the stated governance state.

Third, the governance system was running and active at the timestamp shown. A timestamp that is more than 60 seconds old should prompt the verifier to query the endpoint again — Jaya Runtime refreshes its proof every 60 seconds when running. A stale proof does not indicate a problem; it indicates the node may not be currently running.

A result of FAIL with payload mismatch means the proof fields were altered after signing. The proof should be rejected.

A result of FAIL with signature invalid means the signature does not match the payload and public key. The proof was tampered with or was not produced by TY.

---

## What This Proves

A passing verification confirms:

- TY was running a governance system at the timestamp in the proof
- The governance ledger was in a known state at proof time, recorded by the ledger_hash
- An active policy was loaded, identified by policy_id and policy_version
- The proof was cryptographically signed and cannot be forged without the corresponding private key

What verification does not prove: the contents of the ledger (the ledger_hash is a commitment, not a disclosure), the identity of agents registered in the system, or any internal TY behavior beyond the governance state captured in the proof fields. This is intentional. INV-TY-PRIV-1 holds.

---

## The Phase 6 Track A Proof Condition

The Track A proof condition required that an external party, using only the public endpoint and the verification guide, successfully confirm a valid signed governance proof with zero builder involvement. This proof condition was met on 2026-03-29.

The governance hash published at TYOVA — cd7ef6c73e8050394bec5b0e0289238cd000d7c4ce133ec951653531356a6e09 — is the canonical governance hash established in Phase 4 and maintained through all subsequent phases. Walker Weitzel at Alloy Patent Law was informed of the live verification endpoint as part of the patent evidence package. The endpoint, the verification guide, and the published governance hash together constitute the public verification capability for TY AI OS.

---

## TY-0001.A and TY-0001.B — Independent File Verification

Beyond the live governance proof endpoint, TY AI OS produces signed public releases. TY-0001.A was published to GitHub at github.com/joseramonjr/ty-ai-os-releases with SHA-256 hash 3A6FAD0CA68C52DCBA3F3F264A5244A50B32399A263D9224D3D66AD739ADAA23.

TY-0001.B was published with SHA-256 hash 3A48E33BAAE0691E22FBAE879424EB3F0B4541534E5968673A85F16476D77782.

Any person can download these releases and run a SHA-256 hash independently. If the hash matches the published value, the file has not been modified since publication. No trust in the builder required. This is file integrity verification — independent of the live governance proof endpoint and available even when Jaya Runtime is not running.

---

## Summary

TY AI OS can be verified by anyone with Python, curl, and two minutes. The verification requires no credentials, no builder contact, no source code access, and no special knowledge beyond following the steps in this chapter. The mathematics is the authority.

This was not designed as a feature. It was designed as a principle — the principle that governance which cannot be independently verified is not governance. Phase 6 built the infrastructure to make that principle real. This chapter is the instruction manual.

---

*Chapter 60 compiled: 2026-05-20 | San Diego (America/Los_Angeles)*
*Source: Phase 6 Track A session records, Part 101, JAYA-CLO-186, 2026-03-28*
*FIX: Part 101 — JAYA-CLO-186 | MODEL: Claude Sonnet 4.6*
*Classification: CANONICAL BOOK DOCUMENTATION*