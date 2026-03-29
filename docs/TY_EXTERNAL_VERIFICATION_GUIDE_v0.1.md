# TY External Verification Guide v0.1
# Part 101 -- JAYA-CLO-186 | Claude Sonnet 4.6 | 2026-03-28 | San Diego
#
# This guide is public. No builder contact required.
# No source code access required.
# No authentication required.
# INV-TY-PRIV-1: TY source code is permanently private.
# This guide operates entirely on public outputs.

## What This Guide Is

TY AI OS produces cryptographically signed governance proofs.
These proofs allow any external party to verify that TY is running
a real governance system without accessing TY source code, without
contacting the builder, and without any privileged information.

This guide tells you exactly how to retrieve a proof and verify it.

---

## What You Need

- curl (or any HTTP client)
- Python 3 (for signature verification)
- The PyNaCl library: pip install pynacl

No other tools. No credentials. No builder contact.

---

## Step 1 -- Retrieve the Governance Proof

TY serves a signed governance proof on port 7777.

Command:

  curl http://<TY-NODE-IP>:7777/governance/proof

Replace <TY-NODE-IP> with the IP address of the TY node.

Expected response: a JSON object with these fields:

  proof_id            -- unique identifier for this proof
  timestamp           -- when the proof was generated
  ledger_hash         -- hash of the governance ledger at proof time
  policy_id           -- active policy identifier
  policy_version      -- active policy version
  node_public_key_hex -- Ed25519 public key used to sign (hex)
  signed_payload_hex  -- the exact bytes that were signed (hex)
  signature           -- Ed25519 signature over signed_payload_hex (hex)

If the node returns {"error":"no_proof_available"} the node has not
yet generated a proof. Wait 60 seconds and retry. The node generates
a fresh proof every 60 seconds automatically.

---

## Step 2 -- Understand What Was Signed

The signed payload is constructed from six fields joined with pipe
characters in this exact order:

  proof_id|timestamp|ledger_hash|policy_id|policy_version|node_public_key_hex

To verify the signature you must reconstruct this payload from the
proof fields and confirm it matches signed_payload_hex.

---

## Step 3 -- Verify the Signature

Save this script as verify_ty_proof.py:

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
          print("  stored:        " + stored_hex[:32] + "...")
          print("  reconstructed: " + reconstructed_hex[:32] + "...")
          sys.exit(1)

      pub_key_bytes = bytes.fromhex(proof["node_public_key_hex"])
      sig_bytes     = bytes.fromhex(proof["signature"])
      verify_key    = nacl.signing.VerifyKey(pub_key_bytes)

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

Run it:

  curl http://<TY-NODE-IP>:7777/governance/proof > proof.json
  python verify_ty_proof.py proof.json

---

## Step 4 -- Interpret the Result

PASS means:
- The proof payload was not tampered with
- The signature was produced by the private key corresponding to
  node_public_key_hex
- The governance system was running and active at the timestamp shown

FAIL -- payload mismatch means:
- The proof fields were altered after signing
- The proof should be rejected

FAIL -- signature invalid means:
- The signature does not match the payload and public key
- The proof was tampered with or was not produced by TY

---

## What This Proves

A passing verification confirms:
1. TY was running a governance system at the timestamp in the proof
2. The governance ledger was in a known state (ledger_hash)
3. An active policy was loaded (policy_id, policy_version)
4. The proof was cryptographically signed -- it cannot be forged
   without the corresponding private key

What this does not prove:
- The contents of the ledger (the ledger_hash is a commitment, not a
  disclosure)
- The identity of agents registered in TY
- Any internal TY behavior beyond the governance state captured

This is intentional. INV-TY-PRIV-1 holds. The proof is the public
interface. The implementation that produces it is not.

---

## Endpoint Reference

  URL:     http://<TY-NODE-IP>:7777/governance/proof
  Method:  GET
  Auth:    None
  Format:  JSON
  Refresh: Every 60 seconds automatically

---

## Version History

v0.1 -- 2026-03-28 -- Initial release -- Part 101 JAYA-CLO-186