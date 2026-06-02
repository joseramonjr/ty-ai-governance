# TY AI OS -- Branch Protection Rule
# Repository Governance Integrity Requirement

**Status:** ACTIVE
**Version:** v0.1 -- Phase 14 baseline
**FIX:** FIX-710 · Entry-728
**Established:** 2026-06-02 | San Diego (America/Los_Angeles)
**Closes:** OAQ-002 CAT-2-013 (GAP -- branch protection not documented
  as canonical governance requirement)
**Authority:** Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.

---

## Governance Layer Classification

**Constitutional layer** -- the principle that governance repositories
must be protected against unauthorized rewriting is eternal. Force
push against a governance record is an attack on the chain of custody.
This holds at any scale, in any phase, under any deployment
configuration.

**Architectural layer** -- the specific branch protection mechanisms
(GitHub branch rules, force push disabled, required reviews) reflect
current platform and plan constraints. These will evolve as TY scales
to paid plans and federation. The constitutional principle does not
change as the mechanism evolves.

**Operational layer** -- specific GitHub settings, current plan
limitations, and current enforcement status per repo. These change
as the deployment environment evolves.

---

## The Rule (Constitutional Layer)

**The ty-ai-governance repository main branch must be protected
against force push and unauthorized history rewriting at all times.
Branch protection is not a GitHub convenience setting -- it is a
canonical governance requirement.**

The governance ledger (MFI, Ch18, all governance documents) is the
permanent, tamper-evident record of TY AI OS decisions. A force push
to main can rewrite or delete commits from that record. This is
equivalent to altering the governance ledger after the fact -- which
is permanently prohibited under the No Silent Change doctrine (C9-003)
and the append-only ledger principle (C10-002).

Branch protection enforces at the platform layer what the governance
doctrine requires at the constitutional layer: history cannot be
silently rewritten.

---

## Why This Rule Is Constitutional

The governance record is only trustworthy as evidence if it cannot
be altered after the fact. A git commit is tamper-evident -- it has
a cryptographic hash. A force push replaces commits with new ones,
changing the hash chain. Anyone with push access who performs a force
push can make the governance record say something it never said.

This matters more for TY AI OS than for ordinary software because:

1. The ty-ai-governance repo IS the governance record. It is not
   documentation of a separate system -- it is the system. Altering
   it alters the governance history.

2. External auditors, patent counsel, and future operators verify
   governance claims against the commit history. A rewritten history
   breaks every verification that depends on it.

3. The No Silent Change doctrine (C9-003) requires every governance
   change to be disclosed, documented, and traceable. Force push is
   the definition of a silent change -- it removes evidence from the
   record without producing a compensating entry.

---

## Current Branch Protection State (Operational Layer)

### ty-ai-governance (canonical governance repo)

**Status:** ACTIVE -- force push disabled
**Implemented:** 2026-05-31 as part of OAQ-002 CAT-2 remediation
  (FIX-698, session commit record)
**Protection:** Force push to main disabled. Direct push to main
  permitted for builder -- no required reviews (single-builder
  phase, guardian is the only authorized committer).
**Enforcement:** GitHub enforces at the platform layer. The rule
  cannot be bypassed without first disabling branch protection --
  which itself requires guardian action and produces a visible
  GitHub audit event.

---

### TYOVA (public transparency layer)

**Status:** Rule exists -- NOT enforced
**Reason:** Private repository on free GitHub plan. GitHub does
  not enforce branch protection rules on private repos under the
  free plan.
**Risk level:** Medium. TYOVA contains the public-facing record
  but not the canonical enforcement ledger. A rewritten TYOVA
  history would damage public trust but would not alter the
  canonical governance record in ty-ai-governance.
**Required action:** Enforce when TYOVA moves to a paid plan or
  becomes a public repository.

---

### Jaya-Runtime (runtime enforcement code)

**Status:** Rule exists -- NOT enforced
**Reason:** Private repository on free GitHub plan. Same
  limitation as TYOVA.
**Risk level:** Medium-High. Jaya-Runtime source code is the
  enforcement implementation. A rewritten history could obscure
  when specific enforcement behaviors were added or removed.
**Required action:** Enforce when Jaya-Runtime moves to a paid
  plan or becomes accessible to external auditors.

---

## What Branch Protection Must Include (Architectural Layer)

A compliant branch protection configuration for any TY AI OS
governance repository must include at minimum:

1. Force push disabled on main branch -- no one may rewrite
   committed history regardless of their access level
2. Branch deletion disabled on main branch -- the main branch
   cannot be deleted
3. For multi-guardian deployments (Phase 15+): required reviews
   before merge -- a second authorized guardian must approve
   any change to the governance record before it is committed

What branch protection does NOT require at current scale:

- Required status checks (no CI pipeline currently required)
- Required signed commits (desirable but not yet implemented)
- Restrict who can push (single builder -- only guardian pushes)

---

## What Branch Protection Protects Against (Constitutional)

**Attack vector: unauthorized history rewriting**
An actor with push access performs a force push to rewrite the
governance record. Branch protection makes this structurally
impossible regardless of the actor's access level. Even the
guardian cannot force push to main without first disabling
branch protection -- which produces a visible audit event.

**Attack vector: silent commit deletion**
A commit containing a governance entry is deleted from the
history. Branch protection prevents this at the platform layer.
The append-only principle prevents it at the governance layer.
Both layers must hold.

**Attack vector: branch replacement**
The main branch is deleted and replaced with a branch that has
different history. Branch deletion protection closes this vector.

**At federation scale:** Each federation node's governance
repository must have branch protection active. A node that
operates without branch protection on its governance repository
has an unprotected governance record -- it cannot be trusted
as a verification source by other federation members.

---

## Relationship to Other Governance Rules (Architectural Layer)

Branch protection is the platform-layer enforcement of rules
that exist at the constitutional layer:

**No Silent Change doctrine (C9-003):** No governance change
may be made silently. Branch protection enforces this by making
it impossible to silently rewrite history -- any bypass requires
a visible administrative action.

**Append-only ledger principle (C10-002):** The governance
ledger is append-only. Branch protection enforces this at the
repository level -- commits cannot be removed, only added.

**GIQ-013 (Chat not canonical):** Governance requires Git
commits. Branch protection ensures that Git commits, once made,
are permanent evidence -- they cannot be quietly removed later.

**Zero-Fabrication Rule:** The governance record cannot be
retroactively altered to make it appear that something was
documented that was not. Branch protection enforces this
structurally.

---

## Future-Scale Considerations (Architectural Layer)

**Paid plan enforcement:** When ty-ai-governance, TYOVA, and
Jaya-Runtime move to paid GitHub plans or become public
repositories, branch protection must be enforced on all three.
This is a deployment requirement, not a recommendation.

**Required signed commits (Phase 15+):** As TY AI OS scales
to external operators and federation, requiring Ed25519 or
GPG-signed commits on governance repositories will add a
cryptographic layer of chain of custody on top of branch
protection. Each commit will be verifiably attributed to the
guardian who made it. This is a Phase 15 hardening item.

**Required reviews for federation (Phase 15+):** When TY AI OS
has multiple authorized guardians or a federation governance
board, requiring at least one additional review before any
merge to the canonical governance record adds a second human
check. No single actor can unilaterally commit to the
governance record without a second authorized reviewer.

**External operator repositories:** Each Path 2, 3, and 4
operator (Phase 10) who maintains their own governance
repository must enforce branch protection equivalent to
the ty-ai-governance standard. An operator whose governance
repo has no branch protection has an unverifiable governance
record -- they cannot claim governance compliance.

**TYOVA and Jaya-Runtime public release:** When TY-0001.C
ships and external operators can inspect the reference
implementation, TYOVA and Jaya-Runtime will likely become
publicly readable. At that point branch protection enforcement
becomes critical -- public repos on any GitHub plan support
full branch protection enforcement.

**Node governance repos in federation:** A Jaya Runtime node
-- a Jaya Runtime instance, distinct from TYOVA EcosystemFlowPage
WARDs which are display components only -- that maintains a
governance repository for its local record must apply branch
protection equivalent to the canonical standard. No node
governance repo may permit force push by any actor.

---

## Canonical References

- C9-003: Conscience Thread -- No Silent Change doctrine --
  no governance change may be made silently
- C10-002: Conscience Thread -- append-only ledger -- no
  delete, no update -- branch protection enforces this at
  the repository layer
- GIQ-013: Chat not canonical -- governance requires Git
  commits -- branch protection ensures those commits are
  permanent evidence
- Zero-Fabrication Rule: governance record cannot be
  retroactively altered
- FIX-698: Branch protection activated on ty-ai-governance
  2026-05-31 (OAQ-002 CAT-2 remediation)
- Phase 10 FIX-508: External operator governance requirements
  -- branch protection standard applies to all operator repos
- TY_LEDGER_LAYER_DISTINCTION.md (FIX-706): MFI is the
  documentation authority -- branch protection preserves its
  integrity
