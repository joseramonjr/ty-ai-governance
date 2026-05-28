# TY-ANCHOR -- TY AI OS Session Governance Tooling Suite
# Version: v0.1
# Built: FIX-534 | 2026-05-19 | San Diego (America/Los_Angeles)
# Builder: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
# Location: E:\TY-Ecosystem\ty-ai-governance\tools\

---

## What TY-ANCHOR Is

TY-ANCHOR is the TY AI OS session governance tooling suite. It is a set of
governed PowerShell scripts that enforce session discipline structurally
rather than relying on memory or manual checklists.

TY-ANCHOR is not an AI ecosystem component. It is not Jaya, Jayme, or Luke.
It does not execute governance decisions. It enforces the session discipline
rules that the builder established in the governance doctrine.

TY-ANCHOR may call the Claude API for language generation tasks only.
TY-ANCHOR never calls the Claude API for verification. All governance
verification -- chain integrity, repo states, file presence, line counts --
is performed locally by the PowerShell scripts themselves. Verification
never depends on an external service.

---

## The Session Governance Contract

Every TY AI OS work session follows this sequence:

  STEP 1 -- SESSION OPEN
    Run Pre-Flight.ps1
    Confirm all repos match expected state. Confirm ledger files present.
    Do not begin any work until Pre-Flight reports OVERALL: READY.

  STEP 2 -- FIX START
    Run FIX-Open.ps1 -FixId FIX-NNN -Destination "dest" -Scope "scope"
    Records the FIX opening in the session working file.
    Confirms the proposed FIX ID is sequential.
    Records start timestamp from system clock.

  STEP 3 -- WORK
    Build, write, commit as required by the FIX scope.
    Follow all active governance rules (R1-R14, Zero-Fabrication, PASS TO).

  STEP 4 -- FIX COMPLETE
    Run FIX-Close.ps1 -CommitHash "abc1234" -CloseNote "what was built"
    Writes Ch18 entry. Writes MFI entry.
    Runs Ch18 scan gate. Confirms chain.
    Outputs commit command for ty-ai-governance.

  STEP 5 -- SESSION END
    Run Session-Close.ps1
    Full close checklist. All gates must pass.
    Repo states confirmed. R14 confirmed. Phase summary displayed.

  STEP 6 -- AD-HOC VERIFICATION
    Run Verify.ps1 at any time to check chain integrity.

No work session may close without Session-Close.ps1 confirming all gates
pass. Session close is blocked if any FIX is still OPEN.

---

## Tool Reference

### Pre-Flight.ps1
Purpose  : Session start gate. Read-only diagnostic.
Run when : Start of every session, before any work.
Output   : OVERALL: READY or OVERALL: ACTION REQUIRED
Location : E:\TY-Ecosystem\ty-ai-governance\tools\Pre-Flight.ps1
Version  : v5 (FIX-532 | 2026-05-19)

### FIX-Open.ps1
Purpose  : Open a new FIX. Record start state. Enforce sequential ID.
Run when : Beginning any new FIX.
Usage    : .\FIX-Open.ps1 -FixId FIX-NNN -Destination "dest" -Scope "scope"
Output   : Session working file written. FIX confirmed open.

### FIX-Close.ps1
Purpose  : Close a FIX. Write Ch18 + MFI entries. Confirm chain.
Run when : FIX work is complete and committed.
Usage    : .\FIX-Close.ps1 -CommitHash "abc1234" -CloseNote "description"
Output   : Ch18 entry written. MFI entry written. Chain confirmed.

### Session-Close.ps1
Purpose  : Full session close checklist. Confirm R14. Display summary.
Run when : End of every session, after all FIXes are closed.
Usage    : .\Session-Close.ps1
Output   : All gates PASS or failures listed. R14 status.

### Verify.ps1
Purpose  : Ad-hoc chain integrity check. Gap detection.
Run when : Any time integrity verification is needed.
Usage    : .\Verify.ps1
Output   : Ch18 last 10 entries. MFI last 5 entries. Gap report.

---

## Session Working File

FIX-Open.ps1 writes a session working file at:
  E:\TY-Ecosystem\ty-ai-governance\tools\.ty-anchor-session.json

This file records: current FIX ID, entry ID, destination, scope, open
timestamp, commit hash (added at close), and status (OPEN or CLOSED).

FIX-Close.ps1 reads this file when generating ledger entries and marks
status CLOSED on completion. Session-Close.ps1 reads this file to confirm
no FIX is still OPEN before allowing session close.

The session working file is NOT committed to git. It is local-only.
It persists across terminal sessions on the same machine.

---

## TY-ANCHOR Governance Rules

Rule 1: TY-ANCHOR tools are themselves governed.
  Every change to a TY-ANCHOR tool receives a FIX ID and ledger entry.
  No tool is modified without a governance record.

Rule 2: TY-ANCHOR never bypasses governance.
  If a tool cannot complete a required step, it reports failure and stops.
  It never silently continues past a failed gate.

Rule 3: Verification is always local.
  No external service, no AI, no cloud dependency for any verification.
  Chain integrity is checked against files on disk. Period.

Rule 4: Timestamps come from the system clock.
  Tools running locally on the builder machine in San Diego may use the
  system clock for timestamps. The "ask for San Diego time" rule was
  established for AI sessions where the AI cannot know the actual time.
  Local tooling reads the actual system time directly.

Rule 5: TY-ANCHOR is designed to outlast the builder.
  All tools are documented, readable, and operable by any future guardian
  who reads this document and the governance doctrine.

Rule 6: TY-ANCHOR enforces structure. It does not replace judgment.
  The builder still decides what to build, when to build it, and whether
  a session is complete. TY-ANCHOR enforces that the record matches
  those decisions.

---

## Version History

v0.1 | FIX-534 | 2026-05-19 | San Diego
  Initial build. ETHOS.md + four tools established.
  Pre-Flight.ps1 already existed at v5 (FIX-532).
  FIX-Open.ps1, FIX-Close.ps1, Session-Close.ps1, Verify.ps1 built.