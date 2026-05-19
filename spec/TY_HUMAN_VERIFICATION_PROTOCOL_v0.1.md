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
# Status: Active -- Amended 2026-05-17 by FIX-530 (Amendment 1: HVP Installation Policy)

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


---

## Section A1 -- Amendment 1: HVP Installation Policy
## Amendment date: 2026-05-17 | San Diego (America/Los_Angeles)
## Registered: FIX-530 | Entry-543
## Authorized by: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
## Version: v0.2

This amendment adds nine governance decisions made by the builder on
2026-05-17 during pre-publication review of Chapter 53 of the Book of TY.
These decisions define when HVP applies, who must use it, and what rules
govern its activation, deactivation, and fallback behavior. No existing
section of this document is modified. This amendment extends the document
by defining installation-level policy that was not addressed in v0.1.

### A1.1 -- HVP Applicability by Governance Path

HVP applies only where a guardian chain exists. The following applies
by governance path:

  Path 1 -- Solo, No Guardian:
    HVP does not apply. Path 1 installations have no designated guardian.
    Jayme AI is not enabled. There is no guardian return event for HVP to
    verify against. HVP initialization is not required and is not offered
    during installation.

  Path 2 -- Independent, Own Guardian:
    HVP applies. Whether it is required or optional depends on installation
    type per Section A1.2.

  Path 3 -- Federated, Own Guardian:
    HVP applies. Whether it is required or optional depends on installation
    type per Section A1.2.

  Path 4 -- Federated, Shared Guardian:
    HVP applies. Whether it is required or optional depends on installation
    type per Section A1.2.

### A1.2 -- HVP Tiered by Installation Type

For Paths 2, 3, and 4, whether HVP is required depends on the type of
installation:

  Home and Personal Installations:
    HVP is optional. The user chooses whether to enable it. The choice is
    made after receiving the full explanation required by Section A1.4. A
    home or personal user who declines HVP retains the passcode fallback
    defined in Section A1.7.

  Government and Business Installations:
    HVP is required. No opt-out is available. The protection level
    appropriate to institutional installations is not negotiable.
    For deployments where the organization requires HVP to be mandatory
    and non-overridable by the end user, a deployment configuration lock
    may be set by the organization's IT or security team before the
    installation reaches the end user. The end user cannot override a
    deployment lock.

### A1.3 -- Environmental Detection at Install Time

The installer does not rely solely on user self-declaration to determine
installation type. At install time, Jaya Runtime checks two environmental
signals silently:

  Signal 1 -- Domain join status:
    A Windows machine that is joined to an Active Directory domain is
    almost certainly an enterprise or government installation.

  Signal 2 -- MDM enrollment:
    A device enrolled in a Mobile Device Management system is almost
    certainly managed by an organization.

These signals set the recommended default for the HVP choice -- not a
hard gate. If enterprise signals are detected, HVP is pre-selected and
the installation is presented as a government or business installation.
If no enterprise signals are detected, HVP is presented as optional.

The user may override the environmental default in either direction with
full disclosure of what they are changing. A deployment configuration
lock set by an organization overrides the user and cannot itself be
overridden by the end user.

### A1.4 -- HVP Explanation Requirement

Before any user on Paths 2, 3, or 4 is asked whether to enable HVP,
the installer must present a plain-language explanation covering:

  -- What HVP is and why it exists
  -- What happens when a Lockdown State occurs and HVP is active:
     Jaya notifies the guardian, and the guardian completes the
     verification process defined in this document
  -- What the installation loses if HVP is not enabled
  -- That what the verification process requires is established during
     the guardian initialization session and is known only to the guardian
  -- That HVP can be enabled at any time after installation

No user makes an HVP decision without having received this explanation.
The explanation screen is not skippable.

### A1.5 -- HVP May Be Enabled at Any Time After Installation

A user who declines HVP at install time may enable it at any time
after installation. There is no deadline. The guardian initialization
session may be triggered from within the installer settings at any
point after installation. The governance ledger records when HVP was
initialized, by whom, and the San Diego timestamp.

### A1.6 -- HVP Disable Rules

The following rules govern disabling HVP once it has been initialized:

  Who may disable:
    Only the guardian who initialized HVP may disable it. No other user
    may disable it. The AI component may never disable it.

  Home and personal installations:
    The guardian may disable HVP at any time. A governance ledger entry
    is required recording the decision, the date, and the guardian identity.

  Government and business installations:
    Disabling HVP requires a formal governance process with documentation.
    Standard installer settings alone are insufficient.

  Lockdown State and Suspended State restriction:
    HVP cannot be disabled while the installation is in Lockdown State or
    Suspended State. The installation must be cleared from the protective
    state before HVP settings may be changed. This rule cannot be overridden
    by any instruction. It prevents the removal of the protective mechanism
    while the installation is already under protection.

### A1.7 -- Passcode Fallback for Non-HVP Installations

Path 1 installations and Path 2 through 4 installations where the user
declined HVP still have a Lockdown State clearance path. A simple
passcode -- set during installation and stored encrypted in the Private
Verification Store -- serves as the clearance mechanism.

The passcode fallback:
  -- Is lower security than full HVP
  -- Is appropriate for personal installations where the guardian
     impersonation threat is lower
  -- Is set during the installation session
  -- Is stored encrypted in the Private Verification Store (FIX-507)
  -- Results in a governance ledger entry recording that clearance
     was achieved via passcode rather than HVP

A user who selected the passcode fallback may upgrade to full HVP at
any time by completing the guardian initialization session.

### A1.8 -- Guardian Transfer Protocol Options

When a guardian change occurs -- a guardian leaves, a new guardian is
designated -- the following applies:

  Default behavior:
    The incoming guardian undergoes a new HVP initialization session.
    The outgoing guardian's verification materials in the Private
    Verification Store are replaced with the incoming guardian's
    materials per Section I1.F.

  Organization option:
    An organization may choose to retain the existing HVP settings
    during a guardian transfer rather than reinitializing. This option
    must be explicitly presented and chosen during the guardian transfer
    process. It is not a default. It is not assumed.

  Disclosure requirement:
    The consequences of each choice must be disclosed to the organization
    at the time of transfer. The choice and its consequences are recorded
    in the governance ledger.

  Incomplete handoff rule:
    A guardian handoff is not complete until either the new HVP
    initialization or the explicit retention decision has been recorded
    in the governance ledger.

### A1.9 -- Multi-Guardian Support: Future Phase Design Goal (F-21)

The current TY AI OS guardian model is sequential: one Tier 1 guardian,
one Tier 2 successor who activates only when Tier 1 is unreachable.
Multi-guardian support -- multiple guardians with simultaneous authority
-- is designated as a future phase design goal under flag F-21.

The confirmed future model is Model B: Multiple Must Agree, using M-of-N
logic with a minimum of 2 of 3. This means for an installation with three
designated guardians, at least two must complete verification
simultaneously or within a defined time window to clear a Lockdown State.
No single guardian can act alone.

This model is appropriate for high-security government, defense,
intelligence, and financial regulatory installations where dual-authority
control is operationally required.

Multi-guardian M-of-N support is not implemented in this version of the
HVP specification. It is recorded here as a confirmed future design goal
with builder authorization. Implementation will require its own phase
designation and FIX sequence.

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
