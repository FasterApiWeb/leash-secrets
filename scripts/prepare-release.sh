#!/usr/bin/env bash
set -euo pipefail

# Prepare a release PR branch locally (org blocks GitHub Actions from opening PRs).
REPO="${RELEASE_PLEASE_REPO:-FasterApiWeb/leash-secrets}"
TOKEN="${GITHUB_TOKEN:-$(gh auth token 2>/dev/null || true)}"

if [[ -z "$TOKEN" ]]; then
  echo "Set GITHUB_TOKEN or run: gh auth login"
  exit 1
fi

echo "→ Preparing release PR for ${REPO}..."
npx --yes release-please@latest release-pr \
  --repo-url="https://github.com/${REPO}" \
  --token="${TOKEN}"

BRANCH="release-please--branches--main--components--leash-secrets"
if gh pr list --repo "${REPO}" --head "${BRANCH}" --state open --json number -q 'length' | grep -q '^0$'; then
  echo ""
  echo "→ Open the release PR manually:"
  echo "  gh pr create --repo ${REPO} --head ${BRANCH} --base main \\"
  echo "    --title 'chore(main): release X.Y.Z' --body-file CHANGELOG.md"
fi
