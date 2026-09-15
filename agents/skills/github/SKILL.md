---
name: github
description: >
  Expert knowledge for git, GitHub, the gh CLI, and GitHub Actions, including
  branching and pull-request workflows, forks, conventional and signed commits,
  Actions CI/CD with least-privilege permissions, caching, artifacts, OIDC,
  environments, reusable workflows, Dependabot, code scanning, and rulesets.
  REQUIRED when working with git repositories, gh commands, PRs, issues,
  releases, or .github/workflows on this machine. Covers git essentials
  (clone/add/commit/push/pull/rebase/merge/stash/cherry-pick/log/diff/blame/
  bisect), .gitignore, reset vs revert vs restore, and troubleshooting.
  Triggers: github, gh cli, git, pull request, pr, issue, fork, clone, push,
  rebase, merge conflict, cherry-pick, stash, actions, workflow, artifact,
  dependabot, codespaces, release, branch protection, ruleset.
---

# GitHub Skill

Expert agent for **git**, **GitHub**, the **`gh` CLI**, and **GitHub Actions**
on this machine. This machine runs Arch Linux with **fish** shell and
**git 2.55.0**; **`gh` is NOT installed** (see Section 1). Verified against
current GitHub features and standards as of September 2026.

## 0. Primary references (GitHub docs are canonical)

Core docs:

- **GitHub Docs**: <https://docs.github.com/>
- **gh manual**: <https://cli.github.com/manual/> — subcommand pages `gh_repo`,
  `gh_pr`, `gh_issue`, `gh_run`, `gh_release`, `gh_api`, `gh_search`
  (e.g. <https://cli.github.com/manual/gh_pr>)
- **GitHub Actions docs**: <https://docs.github.com/en/actions>
- **Actions Marketplace**: <https://github.com/marketplace?type=actions>
- **ArchWiki git**: <https://wiki.archlinux.org/title/Git>
- **Pro Git book (git-scm)**: <https://git-scm.com/book/en/v2>
- **Git reference**: <https://git-scm.com/docs>

Actions, security, and collaboration:

- **Workflow syntax**: <https://docs.github.com/en/actions/reference/workflows/workflow-syntax-for-github-actions>
- **Reusable workflows**: <https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows>
- **OpenID Connect (OIDC)**: <https://docs.github.com/en/actions/concepts/security/openid-connect>
- **Environments and secrets**: <https://docs.github.com/en/actions/how-tos/deploy/configure-and-manage-deployments/manage-environments>
- **Dependabot**: <https://docs.github.com/en/code-security/dependabot>
- **Code scanning (CodeQL)**: <https://docs.github.com/en/code-security/code-scanning>
- **Rulesets**: <https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets>
- **Projects, Releases, Codespaces**: <https://docs.github.com/en/issues/planning-and-tracking-with-projects>,
  <https://docs.github.com/en/repositories/releasing-projects-on-github>,
  <https://docs.github.com/en/codespaces>
- **GitHub Pages**: see the companion `github-pages` skill.

## 1. Machine setup (Arch + fish, git 2.55.0, no gh yet)

Install `gh` from the official repos and authenticate:

```bash
sudo pacman -S github-cli
gh --version   # 2.97+ as of Sept 2026; 2.98.0 cut Aug 2026
gh auth login  # HTTPS + browser or token; follow the prompts
gh auth status
```

Baseline git identity (once per machine):

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
git config --global pull.rebase false        # merge by default; true for rebase
git config --global push.autoSetupRemote true
```

fish notes: completions ship with the package (run `exec fish` after
install). Never persist tokens in `config.fish`; use the keyring-backed
login or one-shot env vars:

```bash
env GH_TOKEN=... gh api user --jq .login   # one-shot, no persistence
```

Commit signing — SSH (simplest) or GPG:

```bash
ssh-keygen -t ed25519 -C "you@example.com" -f ~/.ssh/id_sign
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_sign.pub
git config --global commit.gpgsign true
# add the PUBLIC key as a "Signing Key" at github.com/settings/keys
git log --show-signature -1
```

```bash
gpg --full-generate-key   # RSA 4096 or ed25519
gpg --list-secret-keys --keyid-format=long
git config --global user.signingkey <KEYID>
git config --global commit.gpgsign true
```

## 2. Git essentials

Clone, stage, commit, sync:

```bash
git clone git@github.com:OWNER/REPO.git
git status -sb
git add -p                  # stage hunks interactively
git commit -m "feat: add thing"
git push
git pull                    # fetch + merge (or rebase if configured)
git fetch --all --prune
```

History, inspection, search:

```bash
git log --oneline --graph --decorate -20
git log --follow -- path/to/file
git show <sha> --stat
git diff                    # worktree vs index
git diff --staged           # index vs HEAD
git diff main...feature     # what feature adds vs merge-base
git blame -L 10,30 -- file
```

Rebase, merge, cherry-pick, stash:

```bash
git switch -c feature/short-name
git rebase main             # replay feature onto main (private branches only)
git rebase -i HEAD~5        # squash/reword/fixup before a PR
git merge --no-ff feature/short-name
git cherry-pick <sha>
git stash push -m "wip: context"
git stash pop
```

Bisect a regression (fully scriptable):

```bash
git bisect start; git bisect bad HEAD; git bisect good v1.2.3
git bisect run cargo test --quiet   # or pytest -x -q
git bisect reset
```

Tags are cut with releases — `gh release create v0.2.0` tags for you
(Section 9); push a manual tag with `git tag -a v0.2.0 -m "..."`.

## 3. .gitignore patterns

Start from the GitHub template set (<https://github.com/github/gitignore>),
then append project specifics:

```bash
# OS / editor
.DS_Store
.idea/
.vscode/

# Python
__pycache__/
*.py[cod]
.venv/
dist/

# Rust (/target/; keep Cargo.lock for binaries, ignore for libraries)
# Node (node_modules/ dist/ .env*.local)
# Secrets — never commit these: .env  *.pem  *.key
```

Verify ignore rules when a file mysteriously does not stage:

```bash
git check-ignore -v path/to/file
```

## 4. reset vs revert vs restore (pick the right one)

| Command | Scope | Rewrites history? | Use when |
|---|---|---|---|
| `git restore <file>` | Worktree/index only | No | Discard local edits to a file |
| `git revert <sha>` | New commit undoing `<sha>` | No | Undo a pushed/shared commit safely |
| `git reset --soft <sha>` | Move HEAD only | Yes | Re-point branch, keep staged changes |
| `git reset --mixed <sha>` | HEAD + index | Yes | Unstage, keep worktree edits (default) |
| `git reset --hard <sha>` | HEAD + index + worktree | Yes, destructive | Throw away local commits/edits |

```bash
git restore --source=HEAD --staged --worktree -- file
git revert HEAD                       # safe undo of a shared commit
git push --force-with-lease origin feature/x   # private branches only
```

Never `reset --hard` or `push --force` on shared branches.

## 5. Branching and pull-request workflow

Short slugged names (`feat/`, `fix/`, `docs/`, `chore/`), one logical
change per PR. Rebase private branches onto `main` before review.

```bash
git switch main && git pull
git switch -c feat/short-name
# ... small logical commits ...
git push -u origin feat/short-name
gh pr create --fill-first --base main
gh pr list --limit 20
gh pr status
gh pr checks                  # CI status for current PR
gh pr checkout 123            # review someone else's PR locally
gh pr review 123 --approve
gh pr merge 123 --squash --delete-branch
```

Fork-based contributions (external contributors):

```bash
gh repo fork OWNER/REPO --clone=true
git switch -c fix/typo && git push -u origin fix/typo
gh pr create --repo OWNER/REPO --fill-first
```

Conventional Commits (<https://www.conventionalcommits.org/>):

```bash
git commit -m "feat(auth): support ssh commit signing"
git commit -m "fix(ci): pin setup-python to v6"
git commit -m "chore(deps): bump actions/checkout 5 to 6"
# types: feat fix docs style refactor perf test build ci chore revert
# breaking change: append ! — "feat(api)!: drop v1 endpoint"
```

With Section 1 configured every commit is signed; the "Verified" badge
confirms it. Enforce signing org-wide via a ruleset (Section 8).

## 6. gh CLI cheat sheet

Auth, repos, issues:

```bash
gh auth login && gh auth status && gh auth refresh -s workflow
gh repo list --limit 30
gh repo clone OWNER/REPO
gh repo create my-proj --public --clone
gh repo fork OWNER/REPO --clone=true
gh issue create --title "Bug: ..." --body "repro steps"
gh issue list --search "label:bug sort:updated-desc" --limit 20
gh issue view 42 --comments
```

PRs, runs, releases:

```bash
gh pr create --fill-first --base main --label "needs-review"
gh pr list --state open --author "@me" --json number,title --jq .
gh pr checks --watch --fail-fast
gh run list --workflow=ci.yml --limit 10
gh run view <run-id> --log-failed
gh run watch <run-id>
gh release create v0.2.0 --generate-notes --target main
gh release download v0.2.0  # no auth needed for public repos (2.95+)
```

Search and API (scripting superpowers):

```bash
gh search repos "topic:rust stars:>1000" --limit 10
gh search prs "repo:OWNER/REPO is:open label:bug" --limit 20
gh api repos/OWNER/REPO --jq '{stars: .stargazers_count}'
gh api repos/OWNER/REPO/actions/runs --jq '.workflow_runs[:5] | .[].conclusion'
gh repo read-file README.md --repo OWNER/REPO   # read without cloning (2.95+)
```

## 7. GitHub Actions

Current standards (Sept 2026): JS actions run on **node24** — Node20 was
removed from runners on 2026-09-23. Pin current majors:
`checkout@v6`, `setup-*@v6`, `upload-artifact@v6`,
`download-artifact@v7`, `cache@v4`, `configure-pages@v5`,
`upload-pages-artifact@v3`, `deploy-pages@v5`, `codeql-action@v4`.

Minimal CI with least-privilege permissions and current syntax:

```yaml
name: ci
on:
  push:
    branches: [main]
  pull_request:

permissions:
  contents: read   # least privilege at top level; escalate per-job only

jobs:
  lint-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - uses: actions/setup-python@v6
        with:
          python-version: "3.13"
          cache: pip            # built-in cache, no separate cache step
      - run: pip install -r requirements.txt
      - run: pytest -q
```

Rust CI with explicit caching:

```yaml
jobs:
  rust:
    runs-on: ubuntu-latest
    permissions:
      contents: read
    steps:
      - uses: actions/checkout@v6
      - uses: dtolnay/rust-toolchain@stable
        with:
          components: rustfmt, clippy
      - uses: actions/cache@v4
        with:
          path: |
            ~/.cargo/registry
            ~/.cargo/git
            target
          key: ${{ runner.os }}-cargo-${{ hashFiles('**/Cargo.lock') }}
      - run: cargo fmt --check
      - run: cargo clippy -- -D warnings
      - run: cargo test
```

Artifacts (v4+ API — a tag bump alone is not enough):

```yaml
- uses: actions/upload-artifact@v6
  with:
    name: dist
    path: dist/
    retention-days: 7
- uses: actions/download-artifact@v7
  with:
    name: dist
    path: dist/
```

Secrets and environments (never echo secrets into logs):

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production        # approvals + scoped secrets live here
    permissions:
      contents: read
      id-token: write             # only when using OIDC below
    steps:
      - uses: actions/checkout@v6
      - run: ./deploy.sh
        env:
          API_TOKEN: ${{ secrets.API_TOKEN }}
```

OIDC to cloud (no long-lived keys — preferred for AWS/Azure/GCP):

```yaml
permissions:
  id-token: write
  contents: read
steps:
  - uses: aws-actions/configure-aws-credentials@v5
    with:
      role-to-assume: arn:aws:iam::123456789012:role/gha-deploy
      aws-region: eu-central-1
```

Reusable workflows (share CI from a central repo):

```yaml
# central repo: .github/workflows/reusable-python.yml
on:
  workflow_call:
    inputs:
      python-version: { required: false, type: string, default: "3.13" }
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - uses: actions/setup-python@v6
        with: { python-version: ${{ inputs.python-version }}, cache: pip }
      - run: pytest -q
# caller:  jobs: { test: { uses: ORG/central/.github/workflows/reusable-python.yml@main } }
```

Dependabot (Actions, pip, cargo in one file):

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: github-actions
    directory: /
    schedule: { interval: weekly }
  - package-ecosystem: pip
    directory: /
    schedule: { interval: weekly }
  - package-ecosystem: cargo
    directory: /
    schedule: { interval: weekly }
```

Lint workflows before pushing: `pre-commit run --all-files` and
`actionlint .github/workflows/*.yml`.

## 8. Security posture: Dependabot, scanning, rulesets

Enable per repo in this order: Dependabot alerts + updates, secret
scanning with push protection, CodeQL default setup, then a ruleset.
Custom CodeQL analysis for repos needing it:

```yaml
jobs:
  analyze:
    runs-on: ubuntu-latest
    permissions:
      security-events: write
      contents: read
    steps:
      - uses: actions/checkout@v6
      - uses: github/codeql-action/init@v4
        with: { languages: python }
      - uses: github/codeql-action/analyze@v4
```

Rulesets (successor to legacy branch protection — prefer these): target
`main` (and `release/*`) with PR + 1 approval, required `ci` status
checks, required signed commits, blocked force pushes, and resolved
conversations. Manage under Settings > Rules > Rulesets, or as code via
`gh api repos/OWNER/REPO/rulesets`; keep org-wide rulesets in a central
`.github` repo.

## 9. Projects, Releases, Codespaces

```bash
gh project list --owner "@me"
gh release create v0.3.0 --generate-notes --latest
```

Projects (v2) give kanban/roadmap views over PRs and issues; automate
triage with Actions. Releases pair a tag with generated notes and binary
assets (`gh release upload`). Codespaces (`gh cs create/ssh`) is optional
and billed — prefer local dev on this machine, and reach for a codespace
only for ephemeral review environments.

## 10. Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `gh auth` / 401 / bad credentials | Expired or narrow token | `gh auth refresh`; re-login if SSO enforced |
| `! [rejected] main -> main (non-fast-forward)` | Remote moved ahead | `git pull --rebase`, resolve, `git push`; never force shared branches |
| Merge conflicts on rebase/merge | Overlapping edits | Edit markers, `git add`, `git rebase --continue`; abort with `--abort` |
| `detached HEAD` | Checked out a sha/tag | `git switch -c rescue/branch` to keep work, or `git switch main` |
| Push of 100MB+ file rejected | GitHub 100 MB hard limit | `git lfs install && git lfs track "*.psd"`, recommit without the blob |
| `^M` / CRLF churn in diffs | Windows line endings | `git config --global core.autocrlf input`; commit `.gitattributes` with `* text=auto` |
| `permission denied (publickey)` | SSH key missing/unknown | `ssh -T git@github.com`; `ssh-add` the key; upload pubkey to GitHub |
| Action node16/node20 deprecation warning | Pinned old major | Bump to checkout/setup v6, upload-artifact v6, deploy-pages v5 |
