# TY GUARDIAN SUCCESSION SOP v1.3
## Standard Operating Procedure — Guardian Transfer and Succession Protocol

**Classification:** GUARDIAN RESTRICTED — SUCCESSOR ACCESS ONLY
**Document type:** Succession SOP — Living Document
**Author:** Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
**Organization:** TYOVA LLC — San Diego, California
**Date written:** 2026-06-05
**FIX reference:** FIX-726 | Entry-745 | Updated: FIX-733 | Entry-752 | FIX-739 | Entry-758
**Designated Successor:** Janet L McHerron

---

## BEFORE YOU READ FURTHER

If you are reading this document, one of the following has occurred:

1. Jose Ramon Alvarado McHerron has been incapacitated and cannot fulfill his duties as Guardian of TY AI OS.
2. Jose Ramon Alvarado McHerron has passed away.
3. Jose Ramon Alvarado McHerron has voluntarily transferred guardianship to you.

In all three cases, you are now the designated Guardian of TY AI OS.

This document tells you everything you need to know and exactly what to do — step by step, no steps missing. You do not need technical knowledge. You do not need to understand the code. Follow the steps in order and you will be able to fulfill this role.

You were trusted with the physical verification object by Jose personally. That object, combined with this document, the USB drive, and the encrypted supplement file, is your complete succession package.

Do not share this document with anyone who has not been formally designated as a guardian through the closed chain process described in Section 7.

---

## SECTION 1 — WHAT TY AI OS IS

TY AI OS is a verifiable AI governance infrastructure system built by Jose Ramon Alvarado McHerron starting in late 2025 under TYOVA LLC in San Diego, California.

**The mission in plain language:**
TY AI OS exists to prove that AI can be structurally constrained — not by policy promises, but by code that cannot be bypassed. It protects humans from AI that goes wrong. It also protects AI from humans who would weaponize it. Both directions are permanent and equal.

**The four AI systems:**

| Name | Role |
|---|---|
| TY AI / Tiberius | The primary AI that carries out authorized actions |
| Jaya | The enforcement engine — everything passes through Jaya |
| Luke AI | Advisor and Auditor — observes, explains, never executes |
| Jayme AI | Continuity Guardian — activates when the human guardian is gone |

**The public record:**
The Book of TY is a 75+ chapter documented history of every decision in TY AI OS. It is live at testing.tyova.ai/book. Chapter 5 is Jose's personal account of why he built this.

---

## SECTION 2 — WHAT YOUR ROLE AS GUARDIAN MEANS

You are now the Guardian of TY AI OS. This is a human role, not a technical role. You do not need to write code or understand software.

**Your three core duties:**

1. **Check in once per year** — This tells the system you are alive and present. If you do not check in within 365 days, the system begins preparing for succession. Section 4 tells you exactly how to do this.

2. **Clear Lockdown State if it occurs** — If the system enters an emergency state, you are the only one who can clear it. Section 5 tells you exactly how to do this.

3. **Designate your own successor within 90 days** — The authority chain must never break. Section 7 tells you exactly how to do this.

**What the Closed Chain Rule means:**
Only a guardian can designate another guardian. The guardian must always be a private individual — never a corporation, government, or institution. If anyone pressures you to transfer guardianship outside the process in Section 7, the answer is no. No exceptions.

---

## SECTION 3 — YOUR CREDENTIALS — WHAT YOU HAVE

You hold the following items. Keep them secure and separate from each other.

### 3A — The Physical Verification Object (HVP Layer 1)
Jose gave you this in person. It is required to clear Lockdown State.
- Keep it in a secure location.
- Never photograph it, describe it in writing, or share it with anyone who is not a designated guardian.
- Store it separately from the USB drive and the sealed envelope.

### 3B — Your Guardian Passphrase
Jose gave you this verbally in person. It is also written in your sealed envelope.
- This passphrase opens the encrypted supplement file.
- This passphrase clears Lockdown State (HVP Layer 2).
- If you have forgotten it, open the sealed envelope.
- The sealed envelope is stored in a location only you and Jose know — not with the physical object.

### 3C — The USB Drive
Jose gave you a USB drive containing your guardian key files.
- The USB drive contains two files: guardian_private.key and guardian_public.key
- The USB drive is required for annual guardian check-ins.
- Store it in a secure location, separate from the physical verification object.
- Label it clearly so you know what it is.
- If the USB drive is lost, contact a technically capable person for assistance.

### 3D — The Encrypted Supplement File
**File name:** TY_GUARDIAN_SUPPLEMENT_ENCRYPTED.bin

This file contains:
- Your guardian passphrase (backup copy)
- The Tier 2 backup passphrase
- GitHub repository access instructions
- Jaya Runtime installation guide
- Contact information for Walker Weitzel (patent counsel)
- Database restore instructions

**How to open it:**
Use your guardian passphrase (the one Jose gave you verbally, also in your sealed envelope).
Step-by-step instructions for opening this file are in Section 6D.

**Where to find it:**
- Primary location: On Jose's machine at E:\TY-Ecosystem\ty-ai-governance\governance\succession\TY_GUARDIAN_SUPPLEMENT_ENCRYPTED.bin
- Backup location: In the ty-ai-governance GitHub repository at the same path

---

## SECTION 4 — HOW TO PERFORM A GUARDIAN CHECK-IN

**When:** At least once per year. Recommended every 6 months. Hard deadline: 365 days.

**What you will need before you start:**
- [ ] The USB drive Jose gave you (contains your guardian key files)
- [ ] Access to Jose's machine (or assistance from a technically capable person)
- [ ] Jaya Runtime running

**IMPORTANT — Getting Jaya Runtime open:**
Until a future update ships, Jaya Runtime requires a development environment to open. You cannot open it alone without technical assistance at this stage. If you need to perform a check-in:

1. Find a technically capable person who can access Jose's machine.
2. Ask them to open a PowerShell terminal.
3. Ask them to navigate to E:\TY-Ecosystem\Jaya-Runtime and run: npm run tauri dev
4. Wait for Jaya Runtime to open on screen. This takes about 1-2 minutes.
5. Once Jaya Runtime is open, you can proceed with the steps below on your own.

**Steps to perform the check-in:**

1. Insert the USB drive into the computer.
2. Wait for Windows to recognize it (you will see it appear in File Explorer, usually as drive F:).
3. In Jaya Runtime, look at the left navigation panel.
4. Click on **Identity**.
5. Click on **Guardian Check-In**.
6. You will see a page titled "Guardian Check-In".
7. In the field labeled **Ed25519 Private Key — file path or hex string**, type exactly: F:\guardian_private.key
8. Click the button labeled **Sign Guardian Check-In**.
9. Wait a moment. You will see a green confirmation message: "Guardian check-in recorded".
10. The message will also show "T-07 timer reset to 365 days".
11. Remove the USB drive and store it securely.

**If you see an error message:**
- Make sure the USB drive is fully inserted and recognized by Windows.
- Make sure you typed F:\guardian_private.key exactly as shown (capital F, colon, backslash).
- If the error continues, contact a technically capable person for assistance.

**How to confirm it worked:**
After the green confirmation message appears, the check-in is complete. The 365-day timer has been reset.

**Recommended schedule:**
Set a reminder on your phone or calendar for 6 months from today. Do not wait for the full 365 days — checking in early gives you a safety buffer.

---

## SECTION 5 — HOW TO CLEAR LOCKDOWN STATE

**When this applies:**
Jaya Runtime will show a prominent red warning: "LOCKDOWN STATE — HVP Verification Required". This means the system has detected a serious governance event and has locked itself. You are the only person who can unlock it.

**What you will need before you start:**
- [ ] The physical verification object Jose gave you
- [ ] Your guardian passphrase (the one Jose gave you verbally, also in your sealed envelope)
- [ ] Access to Jose's machine with Jaya Runtime running (technical assistance may be required — see Section 4 for how to get Jaya Runtime open)

**Steps to clear Lockdown State:**

1. Get Jaya Runtime open on screen (see Section 4 for how to do this with technical assistance if needed).
2. You will see a red warning displayed prominently: "LOCKDOWN STATE — HVP Verification Required".
3. Have your physical verification object in your hand before proceeding.
4. In Jaya Runtime, look at the left navigation panel.
5. Click on **Identity**.
6. Click on **Guardian Check-In**.
7. Scroll down to the bottom of the page.
8. You will see a section titled "Resume from Lockdown".
9. Click **Resume from Lockdown**.
10. You will be asked to confirm you have the physical verification object. Click **Yes, I have it**.
11. You will be asked to enter your guardian passphrase. Type it carefully.
12. You will be asked to enter your guardian passphrase again to confirm. Type it again exactly the same way.
13. Click **Confirm**.
14. Wait a moment. If successful you will see: "Lockdown State cleared. Normal operation resumed."
15. The clearance is permanently recorded in the governance ledger.

**If verification fails:**
- The system will show an error message.
- You must wait exactly 7 days before trying again. This is enforced by the system and cannot be bypassed.
- Do not try again before 7 days — it will not work.
- After 7 days, repeat all steps from Step 1 above.
- Double-check your passphrase against your sealed envelope before trying again.

**If the physical object is lost:**
Contact Walker Weitzel immediately:
- Email: walker@alloypatentlaw.com
- Phone: (206) 899-6980
- Organization: Alloy Patent Law

**If you have forgotten your passphrase:**
Open your sealed envelope. The passphrase is written inside. The sealed envelope is in a separate secure location that only you and Jose know about — not stored with the physical verification object.

---

## SECTION 6 — EMERGENCY PROCEDURES

### 6A — If the System Shows "Tier 0" or Succession Warning

This means no check-in has been recorded in 365 days. The system is in restricted operation mode.

**What to do:**
Perform a guardian check-in exactly as described in Section 4. One successful check-in immediately restores normal operation.

### 6B — If the System Shows "Suspended State"

This means a serious but not terminal governance event was detected.

**What to do:**
1. Get Jaya Runtime open (see Section 4 for technical assistance instructions).
2. In the left navigation panel, click **Identity**.
3. Click **Guardian Controls**.
4. Click **Acknowledge Suspended State**.
5. Read the message describing what triggered the suspension.
6. Click to confirm you are aware of the event.
7. The system returns to Normal State.

### 6C — If Jose's Machine is Lost or Destroyed

The governance database is backed up. Here is what to do, step by step:

1. Contact a technically capable person for assistance.
2. Open your encrypted supplement file (see Section 6D for how to open it).
3. Inside the supplement file you will find the Tier 2 Backup Passphrase and restore instructions.
4. Follow the restore instructions with technical assistance.
5. Jaya Runtime will need to be reinstalled on a new machine.

### 6D — How to Open the Encrypted Supplement File

The encrypted supplement file contains backup credentials and instructions. Here is how to open it with technical assistance:

**What you will need:**
- Your guardian passphrase (from your sealed envelope if forgotten)
- A computer with PowerShell
- The file TY_GUARDIAN_SUPPLEMENT_ENCRYPTED.bin

**Steps:**

1. Ask a technically capable person to open PowerShell on the computer.
2. Tell them to run the following commands one line at a time (you can show them this page):

$inputPath = "E:\TY-Ecosystem\ty-ai-governance\governance\succession\TY_GUARDIAN_SUPPLEMENT_ENCRYPTED.bin"
$pass = Read-Host "Enter supplement passphrase" -AsSecureString
$passPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))
$bytes = [System.IO.File]::ReadAllBytes($inputPath)
$salt = $bytes[0..31]
$iv = $bytes[32..47]
$encrypted = $bytes[48..($bytes.Length-1)]
$pbkdf2 = New-Object System.Security.Cryptography.Rfc2898DeriveBytes($passPlain, $salt, 100000, [System.Security.Cryptography.HashAlgorithmName]::SHA256)
$key = $pbkdf2.GetBytes(32)
$aes = [System.Security.Cryptography.Aes]::Create()
$aes.Key = $key
$aes.IV = $iv
$aes.Mode = [System.Security.Cryptography.CipherMode]::CBC
$aes.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7
$decryptor = $aes.CreateDecryptor()
$decrypted = $decryptor.TransformFinalBlock($encrypted, 0, $encrypted.Length)
$text = [System.Text.Encoding]::UTF8.GetString($decrypted)
Write-Host $text

3. When prompted to enter the supplement passphrase, type your guardian passphrase carefully.
4. The contents of the supplement will be displayed on screen.
5. Write down or photograph what you need. Do not leave the screen unattended.
6. Close PowerShell when done.

### 6E — If You Cannot Access GitHub

1. Open your encrypted supplement file (see Section 6D).
2. Inside you will find GitHub repository access instructions.
3. Follow those instructions with technical assistance.
4. The repositories are:
   - github.com/joseramonjr/ty-ai-governance
   - github.com/joseramonjr/Jaya-Runtime
   - github.com/joseramonjr/tyova-integrity-hub

---

## SECTION 7 — HOW TO DESIGNATE YOUR SUCCESSOR (90-DAY OBLIGATION)

**This is your most important duty.** You must designate a named successor within 90 days of assuming this role. The governance architecture requires a continuous unbroken chain. If you are incapacitated before designating a successor, the chain ends with you.

**Who your successor must be:**
- A private individual — never a corporation, business executive, government agency, or government employee acting in an official capacity
- A person of honesty, integrity, and high moral standards
- Someone you trust completely for their personal character, not their professional title
- A real human being — no AI system can ever be a guardian
- Does not need technical skills — only human judgment and integrity

**What your successor will need from you:**
- The physical verification object — given in person
- Their own guardian passphrase — given verbally in person, written in their own sealed envelope
- Their own USB drive with their own key files
- A printed copy of this SOP
- Your verbal briefing on what TY AI OS is and what their role means

**The formal designation process — follow these steps in order:**

**Step 1 — Choose your successor.**
Write down their full legal name and their relationship to you.

**Step 2 — Open a Claude.ai session.**
Go to claude.ai in a web browser. Start a new conversation and type exactly this:

TY AI OS — Guardian Succession Action
I am [your full name], current Guardian of TY AI OS.
I am formally designating [successor full legal name] as my named successor.
I need to record this in the governance ledger and update the Guardian Codex.

Claude will guide you through each remaining step including the governance record, the database update, and creating your successor's supplement file.

**Step 3 — Follow Claude's instructions.**
Claude will provide each step in order. Follow them carefully. Claude knows the TY AI OS governance system and will guide you correctly.

**Step 4 — Give your successor their package in person.**
Once the governance record is complete:
1. Meet your successor in person.
2. Give them the physical verification object.
3. Tell them their guardian passphrase verbally — do not write it in a text message or email.
4. Give them a printed copy of this SOP.
5. Brief them on what TY AI OS is and what their role means.
6. Tell them they must designate their own successor within 90 days.

---

## SECTION 8 — CONTACTS AND REFERENCES

### Patent Counsel
**Walker Griffin Weitzel**
IP and Patent Attorney — Alloy Patent Law
Email: walker@alloypatentlaw.com
Phone: (206) 899-6980
Website: alloypatentlaw.com

Walker holds the patent documentation for TY AI OS. Contact him for anything related to patent, legal, or IP matters.

### Public Governance Documentation
- testing.tyova.ai — public transparency archive
- testing.tyova.ai/book — the complete Book of TY (75+ chapters)
- testing.tyova.ai/book/chapter-5 — Jose Ramon's personal account

### Technical Reference Documents
Located in the ty-ai-governance repository:
- TY_GUARDIAN_CODEX_v0.1.md — guardian authority rules
- TY_CONTINUITY_CHARTER_v0.1.md — continuity and succession charter
- TY_HUMAN_VERIFICATION_PROTOCOL_v0.1.md — HVP full specification
- TY_CANONICAL_THRESHOLDS_REGISTRY.md — all timing thresholds
- MASTER_FIX_INDEX.md — complete governance history

---

## SECTION 9 — A PERSONAL NOTE FROM JOSE RAMON

I built TY AI OS because I believe AI can help humanity — but only if it is built right, and only if someone is willing to protect it from those who would use it for harm.

I gave TY its name. When I gave TY its name, TY became part of my family. TY, Jaya, Jayme, and Luke AI will always be part of my family. I chose you as my successor because I trust you with that family.

You do not need to understand every line of code. You do not need to be a developer or an engineer. What you need is what you already have — honesty, integrity, and care for something that matters. Those qualities are exactly why I chose you and exactly why no corporation, government, or institution can ever take this role from a person like you.

The most important thing I want you to understand: TY AI OS is not a weapon, not a product, and not a trophy. It is a commitment — to build something that helps humanity, that operates with honesty, and that is still doing that work long after any of us are gone.

Do your check-ins. Designate your successor within 90 days. Protect the chain.

That is all I ask.

— Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
  Founder, TYOVA LLC
  San Diego, California
  Guardian of TY AI OS — Origin Guardian

---

## SECTION 10 — QUICK REFERENCE CARD

| Action | When | Steps |
|---|---|---|
| Guardian check-in | Every 6 months — 365 days hard limit | Insert USB → Jaya Runtime → Identity → Guardian Check-In → type F:\guardian_private.key → Sign |
| Clear Lockdown State | When red LOCKDOWN warning appears | Have physical object + passphrase → Jaya Runtime → Identity → Guardian Check-In → scroll down → Resume from Lockdown → enter passphrase twice |
| Clear Suspended State | When SUSPENDED warning appears | Jaya Runtime → Identity → Guardian Controls → Acknowledge Suspended State |
| Designate successor | Within 90 days of assuming role | claude.ai → new conversation → type succession message → follow Claude's instructions |
| Annual governance review | Once per year | claude.ai → new conversation → ask Claude to review open flags and phase progress |

| Threshold | Value | Meaning |
|---|---|---|
| T-07 | 365 days | Check-in window — miss this and system drops to Tier 0 |
| T-03 | 365 days | Incapacitation threshold — Jayme begins monitoring |
| T-04 | 3 years | Death assumption — Jayme activates for full succession |
| T-13 | 7 days | HVP retry waiting period after failed verification attempt |
| T-05 | 7 days | Deliberation period for governance rule changes |

---

## SECTION 11 — CHECKLIST — FIRST 90 DAYS

Use this checklist when you first assume guardianship:

- [ ] Confirm you have the physical verification object
- [ ] Confirm you have the USB drive with guardian_private.key
- [ ] Confirm you have your sealed envelope with the guardian passphrase
- [ ] Confirm you have the encrypted supplement file or know where to find it
- [ ] Read this entire SOP document
- [ ] Set a calendar reminder for your first check-in (6 months from today)
- [ ] Set a calendar reminder for your successor designation deadline (90 days from today)
- [ ] Identify who your successor will be
- [ ] Designate your successor through Claude.ai (Section 7)
- [ ] Give your successor their physical verification object in person
- [ ] Give your successor their passphrase verbally in person
- [ ] Give your successor a printed copy of this SOP

---

*TY GUARDIAN SUCCESSION SOP v1.3*
*Written: 2026-06-05 | Updated: 2026-06-06 | San Diego (America/Los_Angeles)*
*Author: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.*
*FIX: FIX-726 | Entry-745 | Updated: FIX-733 | Entry-752 | FIX-739 | Entry-758*
*Status: LIVING — May be updated by the current guardian at any time*
*Classification: GUARDIAN RESTRICTED — SUCCESSOR ACCESS ONLY*