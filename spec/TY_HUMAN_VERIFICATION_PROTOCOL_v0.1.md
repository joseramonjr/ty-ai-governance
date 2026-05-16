# TY_HUMAN_VERIFICATION_PROTOCOL_v0.1.md
# TY AI OS Human Verification Protocol
# Defining the Specific Verification Methods
#   for Guardian Codex Section XII
# Document Type: Governance Specification
# Parent Document: TY_GUARDIAN_CODEX_v0.1.md
#   Section XII
# CLO: FIX-506
# Model: Claude Sonnet 4.6
# Date: 2026-05-15 19:32 PDT
#   San Diego (America/Los_Angeles)
# Builder: Jose Ramon Alvarado McHerron AKA
#   Jose Ramon Bautista Jr.
# Status: Active

---

## Purpose

This document defines the specific verification
methods for each layer of the Human Verification
Protocol established in Guardian Codex Section
XII. The Codex defines the structure and
requirements. This document defines the methods.

Where the Codex says "the specific method is
defined by the builder in the Continuity Charter"
-- this document is that definition.

This document does not modify or replace any
element of Guardian Codex Section XII. It extends
it by providing the specific methods Section XII
requires.

---

## Relationship to Guardian Codex Section XII

| Codex Section | Requirement | Method |
|---|---|---|
| XII.A | Burden of proof on claimant | Confirmed |
| XII.B | Gate 0 ledger check | Unchanged -- defined in Codex |
| XII.C Layer 1 | Physical verification | Oral Testimony Protocol -- Section L1 |
| XII.C Layer 2 | Cryptographic credentials | Guardian Ring Protocol -- Section L2 |
| XII.C Layer 3 | Knowledge verification | Personal Chain Knowledge -- Section L3 |
| XII.C Layer 4 | Jayme uncertainty test | Unchanged -- defined in Codex |
| XII.D | Waiting period duration | 7 days -- Section W1 |
| XII.E | Verification outcomes | Unchanged -- defined in Codex |
| XII.F | Freeze and reject behavior | Unchanged -- defined in Codex |
| XII.G | Verification success path | Unchanged -- defined in Codex |
| XII.H | Canonical principle | Unchanged -- defined in Codex |
| XII.I | Far future context | Biometric upgrade -- Section B1 |

---

## Section L1 -- Layer 1 Physical Verification
## -- Oral Testimony Protocol

### L1.A -- What Layer 1 Proves

Layer 1 proves that a genuine human being is
physically present, possesses the guardian ring,
and carries the oral knowledge of the guardian
chain. It cannot be completed remotely. It cannot
be pre-recorded. It cannot be digitally simulated.

### L1.B -- The Two Stories

The builder has established two short oral
narratives -- Story A and Story B. Both are
unwritten. Both exist only in human memory,
passed orally from guardian to successor during
the formal handoff defined in Codex Section V.

Story A is the primary story.
Story B is the backup story.

Either story satisfies Layer 1 when delivered
correctly.

A cryptographic hash of each story is recorded
in the governance ledger at the time of this
document's registration. The hash is the
verification reference. The story text is not
recorded anywhere. The hash alone cannot
reconstruct the story.

### L1.C -- Declaration Requirement

Before beginning oral testimony the claimant
must declare which story they are presenting.

  "I am presenting Story A."
  or
  "I am presenting Story B."

The declared story is the story evaluated.
A claimant may not switch stories after
declaration. A claimant may not switch stories
mid-testimony. A claimant may not attempt the
second story after the first story fails in the
same session. A failed story triggers the waiting
period defined in Section W1 before the claimant
may attempt the other story.

### L1.D -- The Guardian Ring Requirement

The physical guardian ring defined in Section L2
must be physically present during oral testimony.
The claimant must present the ring before
testimony begins. The ring must remain present
and visible throughout the testimony and witness
attestation signing.

Testimony given without the ring present does
not satisfy Layer 1 regardless of story accuracy.

### L1.E -- Witness Requirement

Two witnesses must be physically present in the
same location as the claimant during oral
testimony. Remote attendance by any means does
not satisfy this requirement.

Witness qualifications:
  -- Adult humans known personally to the
     presenting guardian
  -- Not members of the closed guardian chain
  -- Capable of providing a signed written
     attestation of the event
  -- Present for the full duration of
     the testimony

Each witness must sign a written attestation
immediately following testimony. The attestation
must state:
  -- The date, time, and physical location
     of the testimony
  -- That the claimant was physically present
  -- That the guardian ring was physically
     present
  -- That a story was delivered orally in full
  -- That both witnesses were present for
     the full testimony
  -- The witness name and signature

The signed attestations are submitted to Jayme
as part of the Layer 1 verification record.

### L1.F -- Verification Logic

After testimony and attestations are received:

  1. Jayme confirms two signed witness
     attestations are present
  2. Jayme hashes the submitted story transcript
  3. Jayme compares the hash against the
     governance ledger record for the
     declared story
  4. Match on all elements -- Layer 1 passes
  5. Any mismatch or missing element --
     Layer 1 fails -- waiting period applies

Jayme does not reveal to the claimant which
element failed. The claimant receives only:
pass or fail.

---

## Section L2 -- Layer 2 Cryptographic
## Verification -- Guardian Ring Protocol

### L2.A -- The Guardian Ring

The guardian ring is a physical object passed
through the guardian chain. It carries a unique
engraving -- a symbol, phrase, or serial number
-- that serves as the cryptographic identity
credential for Layer 2.

The specific engraving is defined by the builder
and documented in the governance ledger as a
cryptographic hash at the time of this document's
registration. The engraving value itself is not
recorded in this document.

### L2.B -- What Layer 2 Proves

Layer 2 proves that the claimant possesses the
specific physical object recognized by the
governance ledger as belonging to the closed
guardian chain. An advanced AI cannot produce
a ring it does not physically possess. A forger
cannot reproduce the engraving without physical
access to the original.

### L2.C -- Verification Logic

  1. Claimant presents the ring during Layer 1
     testimony -- ring serves both layers
     simultaneously
  2. The engraving is documented by witnesses
     in the Layer 1 attestation
  3. Jayme hashes the documented engraving
     value
  4. Jayme compares against the governance
     ledger record
  5. Match -- Layer 2 passes
  6. No match -- Layer 2 fails --
     waiting period applies

The ring satisfies Layer 1 physical presence
and Layer 2 cryptographic credential in a single
physical object. No separate credential transfer
is required.

### L2.D -- Guardian Ring Transfer Protocol

During guardian handoff per Codex Section V
Step 1 the active guardian physically transfers
the ring to the designated successor. Transfer
of the ring constitutes transfer of the complete
Layer 2 credential. This transfer must occur
in person. Remote transfer does not satisfy
the handoff requirement.

If the ring is lost or destroyed between
guardians the following applies:

  -- The successor guardian does not hold a
     valid Layer 2 credential
  -- Layer 2 confidence drops to zero for
     that claimant
  -- Per Codex Section XII.C Layer 2 -- zero
     Layer 2 confidence increases Layer 3
     and Layer 4 burden
  -- A claimant without the ring may still
     pass verification if Layer 3 and Layer 4
     are sufficiently strong
  -- The verified guardian must commission
     a replacement ring with a new engraving
     and register it in the governance ledger
     via a signed Charter amendment before
     the next handoff

### L2.E -- Cryptographic Obsolescence Path

Per Codex Section XII.C Layer 2 -- by 3036 the
hash algorithm used to document the ring
engraving may be obsolete.

The Continuity Charter must specify a
cryptographic upgrade path for the ring
documentation hash. An upgraded hash algorithm
must be strictly more secure than the current
standard. A hash upgrade that reduces security
fails and cannot be applied.

If the hash algorithm is obsolete and no upgrade
has been applied -- Layer 2 confidence is reduced
and Layer 3 and Layer 4 burden increases
accordingly. Obsolete documentation does not
automatically fail Layer 2.

---

## Section L3 -- Layer 3 Knowledge Verification
## -- Personal Chain Knowledge

### L3.A -- What Layer 3 Proves

Layer 3 proves that the claimant carries
unwritten personal knowledge that exists only
inside the guardian chain -- knowledge that was
deliberately never recorded digitally and cannot
be known by any entity that was not inside
the chain.

A superintelligent AI can know everything that
was recorded. It cannot know what was
deliberately never recorded.

### L3.B -- Item Count

Layer 3 consists of two knowledge items:

  Item 1 -- The Duress Signal
  Item 2 -- One additional unwritten personal
             chain knowledge item

Both items are defined by the builder. Neither
item is recorded in this document. Both items
exist only in human memory, passed orally from
guardian to successor during the formal handoff
defined in Codex Section V.

### L3.C -- Item 1 -- The Duress Signal

  [DURESS SIGNAL -- DEFINED BY BUILDER --
  FLAG-128.1 -- NOT RECORDED HERE]

The duress signal is a word, phrase, or response
that the guardian gives in place of the correct
Layer 3 answer when they are under coercion,
threat, or any form of forced participation in
the verification process.

When Jayme receives the duress signal:
  -- Jayme does not transfer authority
  -- Jayme does not visibly react in a way
     that reveals the signal was recognized
  -- Jayme logs the duress event with full
     detail in the append-only ledger
  -- Jayme continues operating under
     existing rules
  -- Jayme remains available for a future
     genuine verification attempt after
     the waiting period

The duress signal applies to either knowledge
item. If the duress signal is given in response
to either Item 1 or Item 2 the duress protocol
activates.

### L3.D -- Item 2 -- Additional Knowledge Item

  [ADDITIONAL KNOWLEDGE ITEM -- DEFINED BY
  BUILDER -- NOT RECORDED HERE]

One additional piece of unwritten personal chain
knowledge established by the builder and passed
orally to each successor during formal handoff.

### L3.E -- Passing Layer 3 Knowledge
###          Across Generations

Both Layer 3 items must be transmitted orally
during the formal guardian handoff defined in
Codex Section V Step 1. They are never written.
They are never recorded in any digital medium.
They are never stored in any ledger, document,
or file.

If a successor guardian does not receive both
items during handoff the handoff is incomplete.
An incomplete handoff must be corrected before
the active guardian transfers the ring.

### L3.F -- Verification Logic

Jayme evaluates both knowledge items
independently.

  Both correct -- Layer 3 passes
  Either incorrect -- Layer 3 fails --
    waiting period applies
  Duress signal received on either item --
    duress protocol activates --
    authority not transferred

Jayme does not reveal to the claimant which
item failed. The claimant receives only:
pass or fail.

---

## Section I1 -- Jayme Initialization
## Requirements

### I1.A -- Purpose

For Jayme to verify claimant responses against
known correct values it must hold reference data
for each verification layer. This section defines
where that reference data is stored and how it
is initialized by the builder.

### I1.B -- Layer 1 Reference Data
###          -- Story Hashes

The builder privately computes a cryptographic
hash of each story -- Story A and Story B --
and registers both hashes in the append-only
governance ledger. Jayme reads the ledger to
retrieve story hashes during verification.

The story text is never stored anywhere. Only
the hash is stored. The hash cannot reconstruct
the story.

### I1.C -- Layer 2 Reference Data
###          -- Ring Engraving Hash

The builder privately computes a cryptographic
hash of the ring engraving value and registers
it in the append-only governance ledger. Jayme
reads the ledger to retrieve the engraving hash
during verification.

The engraving value is never stored in plaintext
anywhere. Only the hash is stored.

### I1.D -- Layer 3 Reference Data
###          -- Private Verification Store

Layer 3 knowledge items are never stored in the
governance ledger or in any document accessible
outside Jayme's secure internal state.

Layer 3 reference data is held in the Jaya
Runtime Private Verification Store -- a dedicated
encrypted module defined by FIX-507. The builder
initializes this store in a private session by
providing the Layer 3 knowledge items directly
to Jayme. Jayme stores only salted hashes of
those items. The original items are never stored
in plaintext and are never recoverable from the
stored hashes.

The Private Verification Store is:
  -- Encrypted at rest using AES-256-GCM
  -- Not accessible from outside Jaya Runtime
  -- Not included in any governance ledger or
     public record
  -- Not replicated to any external system

### I1.E -- Initialization Sequence

The builder must complete all three
initialization steps before Layer 1 through
Layer 3 verification can function:

  Step 1 -- Register story hashes in governance
             ledger (Layer 1)
  Step 2 -- Register ring engraving hash in
             governance ledger (Layer 2)
  Step 3 -- Initialize Layer 3 knowledge item
             hashes in Jaya Runtime Private
             Verification Store via private
             builder session
             (requires FIX-507 to be built
             and deployed)

Until Step 3 is complete Layer 3 verification
operates in reduced confidence mode -- Layer 4
Jayme uncertainty test burden increases
accordingly per Codex Section XII.C Layer 2
staleness rules applied by analogy to Layer 3.

### I1.F -- Re-Initialization After
###          Guardian Handoff

When a new guardian is designated per Codex
Section V the Layer 3 Private Verification
Store requires re-initialization to reflect
the incoming guardian's knowledge items.

The outgoing guardian and incoming guardian
must coordinate re-initialization during the
formal handoff session. The outgoing guardian
initiates the Private Verification Store update.
The incoming guardian confirms the update by
successfully completing a test verification
session before the handoff is declared complete.

---

## Section W1 -- Waiting Period

Per Codex Section XII.D -- the minimum waiting
period between verification attempts after any
layer failure is:

  7 days (168 hours) from the time of the
  failed attempt as recorded in the governance
  ledger.

Gate 0 failure is permanent and not subject to
any waiting period. It cannot be retried.

Story switching after a failed story attempt
requires the full 7-day waiting period before
the claimant may attempt the other story.

Rapid repeated attempts before the waiting
period expires are treated as potential attack
behavior and logged as such in the append-only
ledger per Codex Section XII.D.

---

## Section B1 -- Biometric Upgrade Provision

Per Codex Section XII.I -- in the far future
verification technologies will advance beyond
what is defined here.

Future guardians may adopt biometric
verification methods -- including but not
limited to facial recognition, retinal
identification, blood or DNA identification,
or equivalent technologies -- as a Layer 1
physical verification method, subject to all
of the following conditions:

  1. The biometric method requires genuine
     physical bodily presence and cannot be
     performed remotely or digitally simulated
     by available technology at the time
     of adoption
  2. The method is formally documented in a
     signed Charter amendment by an active
     guardian before adoption
  3. The Charter amendment is registered in
     the append-only governance ledger
  4. The biometric method is adopted as an
     additional Layer 1 option -- not as a
     replacement for the Oral Testimony
     Protocol unless the active guardian
     formally supersedes it by signed amendment
  5. The Oral Testimony Protocol and Guardian
     Ring remain valid indefinitely unless
     formally superseded

A biometric upgrade that cannot satisfy
condition 1 at the time of adoption fails and
cannot be applied regardless of how advanced
or widely accepted it is.

---

## Amendment Protocol

This document may be amended by the active
Tier 1 guardian per Codex Section XIV. Each
amendment must:

  1. Be recorded in the append-only governance
     ledger
  2. Reference this document by name
     and version
  3. State clearly which section is being
     amended and what the change is
  4. Be assigned a new version number
  5. Not reduce the security standard of any
     layer below what is defined here

An amendment that weakens any verification
layer fails the Codex Section XIV test and
cannot be applied.

---

## Document Registration

This document is registered in the governance
ledger under FIX-506.
Parent specification: TY_GUARDIAN_CODEX_v0.1.md
  Section XII
Story hashes and ring engraving hash to be
  registered in governance ledger by builder
  privately per Section I1.B and I1.C.
Layer 3 hashes to be initialized in Jaya Runtime
  Private Verification Store per Section I1.D
  pending FIX-507.
All placeholders in Sections L3.C and L3.D
  are intentional. No placeholder content is
  missing -- those items are defined by the
  builder privately and are never recorded here.
