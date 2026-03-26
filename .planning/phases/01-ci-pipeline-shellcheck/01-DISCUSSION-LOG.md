# Phase 1: CI Pipeline & ShellCheck - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-03-26
**Phase:** 01-ci-pipeline-shellcheck
**Areas discussed:** ShellCheck triage strategy, CI workflow scope, Suppression policy, Failure strictness

---

## ShellCheck Triage Strategy

### Q1: How to handle existing warnings?

| Option | Description | Selected |
|--------|-------------|----------|
| Fix all upfront | Fix all ~49 real warnings before enabling CI. CI starts green from day one. | ✓ |
| Suppress baseline, fix later | Record current warnings as baseline, enforce zero new warnings. | |
| Fix critical only | Fix errors and high-severity warnings only. Suppress style/info. | |

**User's choice:** Fix all upfront
**Notes:** Actual warning count (~49) is much lower than the 100+ estimated in STATE.md, making full upfront fix feasible.

### Q2: SC2086 handling strategy?

| Option | Description | Selected |
|--------|-------------|----------|
| Fix case-by-case | Add quotes where needed, inline disable for [[ ]] convention. Max coverage. | ✓ |
| Suppress SC2086 globally | Add to .shellcheckrc. Loses protection outside [[ ]]. | |
| Fix all — add quotes everywhere | Quote even inside [[ ]]. Changes codebase convention. | |

**User's choice:** Fix case-by-case
**Notes:** Preserves maximum ShellCheck coverage while respecting the existing [[ ]] no-quote convention.

### Q3: SC1090/SC1091 handling?

| Option | Description | Selected |
|--------|-------------|----------|
| Inline disable | Add `# shellcheck source=` or `# shellcheck disable=SC1090` per instance. | ✓ |
| Suppress globally | Add SC1090/SC1091 to .shellcheckrc. | |
| You decide | Claude picks based on instance count and disruption. | |

**User's choice:** Inline disable
**Notes:** Documents intent at each dynamic source site while keeping the global check active.

---

## CI Workflow Scope

### Q1: Workflow trigger rules?

| Option | Description | Selected |
|--------|-------------|----------|
| Push + PR to dev | Run on push to dev and PRs targeting dev. | ✓ |
| All pushes + all PRs | Run on every push to any branch and every PR. | |
| PR only | Only run on pull requests. | |

**User's choice:** Push + PR to dev

### Q2: Additional checks beyond ShellCheck?

| Option | Description | Selected |
|--------|-------------|----------|
| ShellCheck only | Keep Phase 1 focused. Other checks come in their own phases. | ✓ |
| Add shebang + permission checks | Also verify shebangs and executable bits. | |
| Add basic structure checks | ShellCheck + shebangs + permissions + duplicate package check. | |

**User's choice:** ShellCheck only

### Q3: Runner type?

| Option | Description | Selected |
|--------|-------------|----------|
| ubuntu-latest | GitHub-hosted, free for public repos, zero setup. | ✓ |
| ubuntu-24.04 pinned | Pin to exact Ubuntu version. More deterministic. | |
| You decide | Claude picks. | |

**User's choice:** ubuntu-latest

### Q4: Workflow file structure?

| Option | Description | Selected |
|--------|-------------|----------|
| Single workflow, add jobs | One ci.yml, phases add jobs. Single status check. | ✓ |
| Separate workflow per phase | One .yml per phase. Independent triggers. | |
| You decide | Claude picks. | |

**User's choice:** Single workflow, add jobs

---

## Suppression Policy

### Q1: .shellcheckrc contents?

| Option | Description | Selected |
|--------|-------------|----------|
| Minimal: shell + external only | Just `shell=bash` and `external-sources=true`. No global suppressions. | ✓ |
| Minimal + suppress SC2086 | Same plus global SC2086 disable. | |
| You decide | Claude picks. | |

**User's choice:** Minimal: shell + external only

### Q2: Require comments on inline suppressions?

| Option | Description | Selected |
|--------|-------------|----------|
| Yes, always | Every disable directive must have a comment explaining why. | ✓ |
| Only for non-obvious ones | Self-explanatory ones don't need comments. | |
| No comments needed | Directive is documentation enough. | |

**User's choice:** Yes, always

---

## Failure Strictness

### Q1: Block PR merges from day one?

| Option | Description | Selected |
|--------|-------------|----------|
| Block from day one | Required status check. PRs cannot merge with failures. | ✓ |
| Advisory first, block after Phase 2 | Non-required check initially. | |
| You decide | Claude picks. | |

**User's choice:** Block from day one

### Q2: Which severity levels fail CI?

| Option | Description | Selected |
|--------|-------------|----------|
| All severities | Error, warning, info, style all fail CI. Zero tolerance. | ✓ |
| Error + warning only | Ignore info and style. | |
| Error only | Most permissive. | |

**User's choice:** All severities

---

## Claude's Discretion

- Script discovery command structure in CI
- ShellCheck output format (SARIF vs plain text)
- Fix ordering strategy

## Deferred Ideas

None — discussion stayed within phase scope
