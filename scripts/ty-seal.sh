#!/bin/bash

# ════════════════════════════════════════════════════
#  TY AI OS — Universal Seal Script
#  Version: 1.0.0
#  Repo: ty-ai-governance/scripts/ty-seal.sh
#  Usage: ty-seal <DESTINATION> <FIX> "<DESC>" <CLO>
# ════════════════════════════════════════════════════

# ── REPO CONFIG ──────────────────────────────────────
GOVERNANCE_REPO="/e/TY-Ecosystem/ty-ai-governance"
GOVERNANCE_LEDGER_DIR="governance/domains"

DESTINATIONS=(
  "JAYA|/e/TY-Ecosystem/Jaya-Runtime|Jaya/Jaya_FIX_LEDGER.md|joseramonjr/Jaya-Runtime"
  "TYOVA|/e/TY-Ecosystem/TYOVA|TYOVA/TYOVA_FIX_LEDGER.md|joseramonjr/TYOVA"
  "TY|/e/TY-Ecosystem/TY-AI-OS|TY/TY_FIX_LEDGER.md|joseramonjr/TY-AI-OS"
  "LUKE|/e/TY-Ecosystem/Luke|Luke/LUKE_FIX_LEDGER.md|joseramonjr/Luke"
  "JAYME|/e/TY-Ecosystem/Jayme|Jayme/JAYME_FIX_LEDGER.md|joseramonjr/Jayme"
)

# ── VALIDATE ARGS ────────────────────────────────────
if [ "$#" -ne 4 ]; then
  echo "Usage: ty-seal <DESTINATION> <FIX_NUMBER> \"<DESCRIPTION>\" <CLO_TAG>"
  echo "Example: ty-seal JAYA FIX-37.01 \"Added FileRead operation\" JAYA-CLO-005"
  exit 1
fi

DEST="$1"
FIX="$2"
DESC="$3"
CLO="$4"

# ── LOOKUP DESTINATION ───────────────────────────────
REPO_PATH=""
LEDGER_PATH=""
GITHUB_REPO=""

for entry in "${DESTINATIONS[@]}"; do
  IFS='|' read -r name path ledger github <<< "$entry"
  if [ "$name" == "$DEST" ]; then
    REPO_PATH="$path"
    LEDGER_PATH="$GOVERNANCE_LEDGER_DIR/$ledger"
    GITHUB_REPO="$github"
    break
  fi
done

if [ -z "$REPO_PATH" ]; then
  echo "ERROR: Unknown destination '$DEST'"
  echo "Valid destinations: JAYA, TYOVA, TY, LUKE, JAYME"
  exit 1
fi

if [ ! -d "$REPO_PATH" ]; then
  echo "ERROR: Repo path does not exist: $REPO_PATH"
  echo "Create the repo first before sealing."
  exit 1
fi

# ── TIMESTAMP ────────────────────────────────────────
TIMESTAMP=$(TZ="America/Los_Angeles" date "+%Y-%m-%d %H:%M:%S PDT")
DATE_ONLY=$(TZ="America/Los_Angeles" date "+%Y-%m-%d")

# ── HEADER ───────────────────────────────────────────
echo ""
echo "════════════════════════════════════════"
echo "  TY AI OS — Seal Script"
echo "  Destination : $DEST"
echo "  Fix         : $FIX"
echo "  Description : $DESC"
echo "  CLO Tag     : $CLO"
echo "  Timestamp   : $TIMESTAMP"
echo "════════════════════════════════════════"
echo ""
# ── SHOW CHANGED FILES ───────────────────────────────
cd "$REPO_PATH" || exit 1
CHANGED=$(git status --short)

if [ -z "$CHANGED" ]; then
  echo "No changed files in $DEST repo."
  echo -n "Ledger-only seal? (y/n): "
  read -r LEDGER_ONLY
  if [ "$LEDGER_ONLY" != "y" ]; then
    echo "Aborted."
    exit 0
  fi
else
  echo "Changed files in $DEST repo:"
  echo "$CHANGED"
  echo ""
  echo -n "Commit these files? (y/n): "
  read -r CONFIRM
  if [ "$CONFIRM" != "y" ]; then
    echo "Aborted."
    exit 0
  fi

  echo ""
  echo "[$DEST] Staging files..."
  git add .

  COMMIT_MSG="$FIX: $DESC ($CLO) | MODEL: Claude Sonnet 4.6 | DATE: $DATE_ONLY | San Diego"
  echo "[$DEST] Committing..."
  git commit -m "$COMMIT_MSG"

  echo "[$DEST] Pushing to GitHub..."
  git push
  TARGET_COMMIT=$(git rev-parse --short HEAD)
fi

# ── APPEND LEDGER ENTRY ──────────────────────────────
cd "$GOVERNANCE_REPO" || exit 1
LEDGER_FULL_PATH="$GOVERNANCE_REPO/$LEDGER_PATH"

if [ ! -f "$LEDGER_FULL_PATH" ]; then
  echo "WARNING: Ledger file not found: $LEDGER_FULL_PATH"
  echo "Creating it..."
  mkdir -p "$(dirname "$LEDGER_FULL_PATH")"
  echo "# $DEST FIX LEDGER" > "$LEDGER_FULL_PATH"
fi

echo "$FIX | $DESC | $DATE_ONLY | COMPLETE" >> "$LEDGER_FULL_PATH"
echo "[ty-ai-governance] Ledger entry appended."

# ── COMMIT GOVERNANCE REPO ───────────────────────────
echo "[ty-ai-governance] Committing governance seal..."
git add "$LEDGER_PATH"
GOV_COMMIT_MSG="GOV: Seal $FIX — $DESC ($CLO)"
git commit -m "$GOV_COMMIT_MSG"

echo "[ty-ai-governance] Pushing to GitHub..."
git push
GOV_COMMIT=$(git rev-parse --short HEAD)

# ── FINAL SUMMARY ────────────────────────────────────
echo ""
echo "════════════════════════════════════════"
echo "  SEALED ✓"
echo "  $DEST repo       : ${TARGET_COMMIT:-ledger-only}"
echo "  ty-ai-governance : $GOV_COMMIT"
echo "  Timestamp        : $TIMESTAMP"
echo "════════════════════════════════════════"
echo ""
