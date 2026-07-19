# TY_TOOLS_REFERENCE.md
# TY AI OS -- Session Tooling Reference
# FIX-737 | Entry-756 | 2026-06-06 | San Diego
# Builder: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
#
# PURPOSE
# This document lists every tool built to make TY AI OS session work
# easier and faster. Read this at session open. Use these tools.
# Do not do manually what a tool already does.
#
# RULE: If a tool exists for a task, use it. Do not reinvent.

---

## SESSION LIFECYCLE TOOLS

### Pre-Flight.ps1
**When:** FIRST thing every session -- before any work begins
**What:** Verifies all three repo states, ledger backup currency,
Ch26 term count header, governance hash. Reports PASS or ACTION REQUIRED.
**Command:**
  powershell -ExecutionPolicy Bypass -File "E:\TY-Ecosystem\ty-ai-governance\tools\Pre-Flight.ps1"
**Never skip.** No work begins until Pre-Flight passes.

---

### FIX-Open.ps1
**When:** Before every single FIX -- no exceptions
**What:** Opens a FIX entry, records scope and timestamp, writes
session anchor file. Assigns Entry number.
**Command:**
  powershell -ExecutionPolicy Bypass -File "E:\TY-Ecosystem\ty-ai-governance\tools\FIX-Open.ps1" -FixId "FIX-NNN" -Destination "REPO" -Scope "description"
**Parameters:** FixId (e.g. FIX-727), Destination (ty-ai-governance / Jaya-Runtime / TYOVA), Scope (short description)

---

### FIX-Close.ps1
**When:** After every FIX commit and push -- before ledger commit
**What:** Closes the FIX entry, writes Ch18 and MFI ledger entries.
Always produces duplicate entries -- run duplicate-removal after.
**Command:**
  powershell -ExecutionPolicy Bypass -File "E:\TY-Ecosystem\ty-ai-governance\tools\FIX-Close.ps1" -CommitHash "HASH" -CloseNote "description"
**After FIX-Close:** Always check for duplicates in Ch18 and MFI before
committing the ledger. FIX-Close.ps1 is known to produce duplicates.

---

### Session-Close.ps1
**When:** End of every session -- after all FIXes are closed
**What:** Runs all 6 gates: open FIX check, repo states, Ch18 chain,
MFI last entry, Ch26 presence, governance hash. Reports PASS or FAIL.
**Command:**
  powershell -ExecutionPolicy Bypass -File "E:\TY-Ecosystem\ty-ai-governance\tools\Session-Close.ps1"
**Never end a session without Session-Close PASS.**

---

### Generate-Handoff.ps1
**When:** After Session-Close PASS -- before ending the chat
**What:** Reads live git state from all three repos, last MFI entry,
last Ch18 entry, Ch26 term count. Produces verified handoff document.
**Command:**
  powershell -ExecutionPolicy Bypass -File "E:\TY-Ecosystem\ty-ai-governance\tools\Generate-Handoff.ps1"

---

## CODE VERIFICATION TOOLS

### Integrity-Scan.ps1
**When:** After every Rust code change -- before git commit
**What:** S1 scan -- verifies governance hash, source file commits,
Ch26 term count header, key governance files present.
**Command:**
  powershell -ExecutionPolicy Bypass -File "E:\TY-Ecosystem\ty-ai-governance\tools\Integrity-Scan.ps1"
**Run from:** Any directory (paths are hardcoded)

---

### Verify.ps1
**When:** Additional verification pass when needed
**What:** Supplementary verification checks beyond Integrity-Scan.
**Command:**
  powershell -ExecutionPolicy Bypass -File "E:\TY-Ecosystem\ty-ai-governance\tools\Verify.ps1"

---

## VOCABULARY SYNC TOOLS

### Sync-Ch26ToTYOVA.ps1
**When:** EVERY TIME Ch26 gets new terms or sections -- before
manually touching bookChapterContent.ts
**What:** Reads TY_BOOK_CHAPTER_26 markdown, generates
TypeScript-ready term blocks formatted for bookChapterContent.ts.
Outputs to tools\Ch26_sync_output.txt.
**Command:**
  powershell -ExecutionPolicy Bypass -File "E:\TY-Ecosystem\ty-ai-governance\tools\Sync-Ch26ToTYOVA.ps1"
**Workflow:**
  1. Add terms to Ch26 markdown -- commit to ty-ai-governance
  2. Run Sync-Ch26ToTYOVA.ps1
  3. Review Ch26_sync_output.txt
  4. Copy new section output into bookChapterContent.ts
  5. Commit to TYOVA
**Do not write TypeScript term blocks by hand when this script exists.**

---

## TESTING TOOLS

### cargo test (standard command -- auto-writes test count)
**When:** After every Jaya-Runtime code change -- before FIX-Close
**What:** Runs full test suite and automatically records test count
to .last-test-count.json for Update-TYOVAStats.ps1 to read.
**Command:**
  cd "E:\TY-Ecosystem\Jaya-Runtime\src-tauri"
  cargo test 2>&1 | Tee-Object -Variable testOut | Select-Object -Last 5
  $count = ([regex]::Match(($testOut -join "`n"), '(\d+) passed')).Groups[1].Value
  E:\TY-Ecosystem\ty-ai-governance\tools\Write-TestCount.ps1 -TestsTotal $count -TestsPass $count
**Never run bare cargo test alone** -- always pipe through Write-TestCount
so the count is recorded for Update-TYOVAStats.ps1.

---

### Write-TestCount.ps1
**When:** Automatically called by the cargo test command above
**What:** Writes test count to Jaya-Runtime\src-tauri\.last-test-count.json
Read by Update-TYOVAStats.ps1 to auto-update masterHubRegistry.ts
**Manual use (if count is known):**
  E:\TY-Ecosystem\ty-ai-governance\tools\Write-TestCount.ps1 -TestsTotal 240 -TestsPass 240

---

### Update-TYOVAStats.ps1
**When:** At session open if TYOVA stats may be stale -- or after any
chapter, vocabulary, or test count change
**What:** Reads chaptersSealed from BookOfTyIndex.tsx, vocabTerms from
Ch26 header, testsTotal/testsPass from .last-test-count.json.
Patches masterHubRegistry.ts automatically. Does NOT update
phasesSealed or snapshotDate -- those are human decisions.
**Command:**
  E:\TY-Ecosystem\ty-ai-governance\tools\Update-TYOVAStats.ps1
**Dry-run (preview without writing):**
  E:\TY-Ecosystem\ty-ai-governance\tools\Update-TYOVAStats.ps1 -DryRun
**After running:** git diff TYOVA/src/config/masterHubRegistry.ts
then commit TYOVA if changes were made.

---

## TESTING TOOLS

### cargo test (standard command -- auto-writes test count)
**When:** After every Jaya-Runtime code change -- before FIX-Close
**What:** Runs full test suite and automatically records test count
to .last-test-count.json for Update-TYOVAStats.ps1 to read.
**Command:**
  cd "E:\TY-Ecosystem\Jaya-Runtime\src-tauri"
  cargo test 2>&1 | Tee-Object -Variable testOut | Select-Object -Last 5
  $count = ([regex]::Match(($testOut -join "`n"), '(\d+) passed')).Groups[1].Value
  E:\TY-Ecosystem\ty-ai-governance\tools\Write-TestCount.ps1 -TestsTotal $count -TestsPass $count
**Never run bare cargo test alone** -- always pipe through Write-TestCount
so the count is recorded for Update-TYOVAStats.ps1.

---

### Write-TestCount.ps1
**When:** Automatically called by the cargo test command above
**What:** Writes test count to Jaya-Runtime\src-tauri\.last-test-count.json
Read by Update-TYOVAStats.ps1 to auto-update masterHubRegistry.ts
**Manual use (if count is known):**
  E:\TY-Ecosystem\ty-ai-governance\tools\Write-TestCount.ps1 -TestsTotal 240 -TestsPass 240

---

### Update-TYOVAStats.ps1
**When:** At session open if TYOVA stats may be stale -- or after any
chapter, vocabulary, or test count change
**What:** Reads chaptersSealed from BookOfTyIndex.tsx, vocabTerms from
Ch26 header, testsTotal/testsPass from .last-test-count.json.
Patches masterHubRegistry.ts automatically. Does NOT update
phasesSealed or snapshotDate -- those are human decisions.
**Command:**
  E:\TY-Ecosystem\ty-ai-governance\tools\Update-TYOVAStats.ps1
**Dry-run (preview without writing):**
  E:\TY-Ecosystem\ty-ai-governance\tools\Update-TYOVAStats.ps1 -DryRun
**After running:** git diff TYOVA/src/config/masterHubRegistry.ts
then commit TYOVA if changes were made.

---

## BACKUP TOOLS

### Backup-JayaLedger.ps1
**When:** Automated -- runs daily via Windows Task Scheduler
**What:** Tier 1 local SQLite backup with SHA-256 verification.
Retains 30 days. Output: E:\TY-Ecosystem\backups\jaya-ledger\
**Manual run if needed:**
  powershell -ExecutionPolicy Bypass -File "E:\TY-Ecosystem\Jaya-Runtime\Backup-JayaLedger.ps1"

---

### Backup-JayaLedger-Tier2.ps1
**When:** Automated -- runs weekly via Windows Task Scheduler
**What:** Tier 2 AES-256-CBC encrypted backup. Permanent retention.
Output: D:\TY-Backups\jaya-ledger-encrypted\
**Manual run if needed:**
  powershell -ExecutionPolicy Bypass -File "E:\TY-Ecosystem\Jaya-Runtime\Backup-JayaLedger-Tier2.ps1"
**Note:** Age check uses CreationTime not LastWriteTime (known behavior).

---

## SUCCESSION TOOLS

### Build-GuardianSupplement-v3.ps1 (temp -- not committed)
**When:** When guardian supplement needs to be rebuilt
**What:** Interactively prompts for HVP passphrase, Tier 2 passphrase,
and supplement encryption passphrase. Builds AES-256 encrypted
supplement file for guardian succession.
**Location:** Saved to $env:TEMP at runtime -- not committed to repo
**Run alone -- private credentials involved.**

---

## TOOL USAGE RULES

1. Pre-Flight runs first -- no exceptions
2. FIX-Open before any work -- no exceptions
3. FIX-Close after every commit -- no exceptions
4. Session-Close before ending -- no exceptions
5. Sync-Ch26ToTYOVA before editing bookChapterContent.ts -- no exceptions
6. Integrity-Scan after every Rust change -- no exceptions
7. cargo test via piped command only -- always write test count to .last-test-count.json
8. Update-TYOVAStats.ps1 at session open if chapters, vocab, or tests may have changed
9. FIX-Close always produces duplicates -- always check before ledger commit
10. Rust files via VS Code paste only -- never PowerShell WriteAllLines
11. Backtick template literals via VS Code only -- never PowerShell heredoc
12. Always ask Jose for San Diego time before any ledger entry

---

## KNOWN TOOL BEHAVIORS

- FIX-Close.ps1 miscounts Entry numbers -- verify against handoff chain
- FIX-Close.ps1 produces duplicate Ch18 and MFI entries -- always remove
- Pre-Flight v6 includes LEDGER BACKUP gate
- PACKAGING_MANIFEST.md auto-regenerates via Lovable -- discard with git checkout
- Backup age check uses CreationTime not LastWriteTime

---

*Document Type: LIVING DOCUMENT*
*Created: FIX-737 | Entry-756 | 2026-06-06 | San Diego*
*Builder: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.*
*Update this document whenever a new tool is built or a tool behavior changes.*