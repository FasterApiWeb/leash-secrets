# CI/CD & Releases

Maintainer reference for GitHub Actions, secrets, and how to ship a version of `leash-secrets`.

> **Not Fork Shepherd.** [Fork Shepherd](https://github.com/marketplace/actions/fork-shepherd) is a Marketplace action for **forks** syncing with an upstream. This page is about **leash-secrets**’s own pipelines. The **Release Draft** workflow only reuses the same *release idea* (manual patch/minor/major → draft → publish).

## Mental model

```
You open a PR
    → CI (+ Validate Patterns if patterns change)
    → merge when green

Push lands on main
    → CI again
    → Deploy Docs
    → Release (release-please)  ← legacy; usually ignore

When you want to ship a version
    → Actions → Release Draft (patch/minor/major)
    → workflow bumps version files + pushes commit (if needed)
    → draft GitHub Release appears
    → you Publish the draft in the UI
    → Publish npm runs (skips if that version is already on npm)
```

| Stage | Tool | Output |
|-------|------|--------|
| Validate code | **CI** | Pass/fail on PR |
| Update docs site | **Deploy Docs** | GitHub Pages |
| Cut a version | **Release Draft** | Version bump commit (if needed) + draft GitHub Release + assets |
| Make it live | You click **Publish** | Public GitHub Release |
| Package registry | **Publish npm** | `leash-secrets` on npm (no-op if already published) |

```
Release Draft (auto-bump)  →  draft tag/assets  →  Publish draft  →  npm
```

## Workflow table

| Workflow | When it runs | Purpose |
|----------|--------------|---------|
| **CI** | Every PR + every push to `main` | Quality gate: Node 18/20/22 tests, shell syntax, hygiene (incl. `install.sh` ↔ `package.json` version), dogfood scan |
| **Validate Patterns** | PRs/pushes that touch `patterns/` | Pattern JSON / fixture validation |
| **Deploy Docs** | Push to `main` | MkDocs → GitHub Pages |
| **Release** (release-please) | Push to `main` | **Legacy.** Tries to manage release PRs/tags. Org often blocks Actions from opening PRs — prefer **Release Draft** |
| **Release Draft** | **Manual** (`workflow_dispatch`) | You pick patch/minor/major → bumps `package.json` / `install.sh` / etc. if needed → **draft** `leash-secrets-vX.Y.Z` + assets |
| **Publish npm** | Manual, **or** when a draft release is **published** | `npm publish --provenance` (succeeds as no-op if version already on npm) |

Workflow files live under [`.github/workflows/`](https://github.com/FasterApiWeb/leash-secrets/tree/main/.github/workflows).

## Secrets needed

Add under **Settings → Secrets and variables → Actions**.

| Secret | Required? | Used by | How to create |
|--------|-----------|---------|---------------|
| `NPM_TOKEN` | **Yes** (to publish) | Publish npm | [npmjs.com](https://www.npmjs.com) → Access Tokens → Granular token with **Read and Write** + **Bypass 2FA for publish** |
| `RELEASE_TOKEN` | Optional | Release Draft | PAT with contents write; otherwise `GITHUB_TOKEN` is used |
| `RELEASE_APP_ID` / `RELEASE_APP_PRIVATE_KEY` / `RELEASE_APP_INSTALLATION_ID` | Optional | Release Draft | GitHub App install token (same pattern as fork-shepherd releases) |
| `VSCE_PAT` | Deferred | VS Code extension publish | Azure DevOps PAT with **Marketplace → Manage** |

### Actions policy

Org/repo must allow Marketplace actions:

`Settings → Actions → General → Allow all actions and reusable workflows`

If CI shows `startup_failure` with zero jobs, the org is likely set to `local_only`.

## Day-to-day (features / fixes)

1. Open a PR → wait for **CI** (and **Validate Patterns** if you changed patterns).
2. Merge when green (squash).
3. **Deploy Docs** updates the site on `main`.
4. Ignore **Release** (release-please) unless debugging it.

No npm publish happens on normal merges.

## How to ship a version

### 1. Create a draft release

1. **Actions → Release Draft → Run workflow**
2. Branch: `main`
3. Bump: `patch` / `minor` / `major`
4. Optional: `dry_run` = true to preview the next tag

The workflow:

- Computes the next version from the latest `leash-secrets-v*` tag
- If `package.json` is behind, **bumps** `package.json`, `install.sh`, `CITATION.cff`, `vscode-extension/package.json`, manifest, and `CHANGELOG.md`, then **pushes** `chore: release X.Y.Z` to `main`
- Creates a **draft** release `leash-secrets-vX.Y.Z` + assets

If the push fails (branch protection), add `RELEASE_TOKEN` (admin PAT that can push to `main` / bypass rulesets) or allow the GitHub Actions app to bypass the main ruleset, then re-run.

### 2. Publish the draft

1. **Releases** → open the draft  
2. Review notes/assets  
3. **Publish release**

Result: **Publish npm** runs and publishes `leash-secrets@X.Y.Z` (or no-ops if that version is already on npm).

### 3. If you only need npm

**Actions → Publish npm → Run workflow** — publishes whatever version is on the checked-out ref; skips cleanly if already published.

Optional local prep (still supported): `bash scripts/prepare-release.sh` if you prefer a version-bump PR before Release Draft.
## Branch protection (maintainer note)

`main` requires PRs and the CI status checks. Required **approving** reviews are set to **0** so the sole maintainer can merge their own PRs (GitHub never counts self-approvals). CI must still be green. Revisit if more maintainers join.

See also: [CONTRIBUTING.md](https://github.com/FasterApiWeb/leash-secrets/blob/main/CONTRIBUTING.md) (repo root) and [Development Setup](development.md).
