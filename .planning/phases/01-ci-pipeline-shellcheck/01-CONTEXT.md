# Phase 1: CI Pipeline & ShellCheck - Context

**Gathered:** 2026-03-26
**Status:** Ready for planning

<domain>
## Phase Boundary

Set up GitHub Actions CI that runs ShellCheck on all 293 shell scripts (198 in bin/, 95 in install/) on every push to dev and every PR targeting dev. Fix all existing warnings upfront so CI starts green. A PR with a ShellCheck error shows a failing check; a clean PR shows a passing check.

</domain>

<decisions>
## Implementation Decisions

### ShellCheck Triage Strategy
- **D-01:** Fix all ~49 existing warnings upfront before enabling CI. The actual warning count is much lower than the ~100+ initially estimated in STATE.md, making a full fix feasible.
- **D-02:** Handle SC2086 (unquoted variables) case-by-case. Add quotes where genuinely needed (command args, paths). Use inline `# shellcheck disable=SC2086` only for the `[[ ]]` convention cases where the codebase intentionally omits quotes per Bash spec.
- **D-03:** Handle SC1090/SC1091 (dynamic source paths, ~14 instances) with inline `# shellcheck source=path/to/file` or `# shellcheck disable=SC1090` directives, not global suppression. Documents the intent while keeping the global check active.

### CI Workflow Scope
- **D-04:** Trigger CI on push to `dev` branch and on all PRs targeting `dev`. No other branches trigger CI.
- **D-05:** Phase 1 CI contains ShellCheck only. No additional checks (shebangs, permissions, package validation). Those come in their respective phases per the roadmap.
- **D-06:** Use `ubuntu-latest` GitHub-hosted runner. ShellCheck is trivially apt-installable.
- **D-07:** Single workflow file (`.github/workflows/ci.yml`) with a `shellcheck` job. Later phases add their own jobs to the same file. One file, one status check on PRs.

### Suppression Policy
- **D-08:** Minimal `.shellcheckrc`: only `shell=bash` and `external-sources=true`. No global suppressions — all disables are inline.
- **D-09:** Every inline `# shellcheck disable=SCXXXX` must have a comment explaining why. No exceptions.

### Failure Strictness
- **D-10:** ShellCheck is a required (blocking) status check from day one. PRs cannot merge with failures.
- **D-11:** All ShellCheck severity levels fail CI (error, warning, info, style). Zero tolerance since we're starting from a clean baseline.

### Claude's Discretion
- How to structure the `find` command in CI to discover all shell scripts (bin/ executables + install/ .sh files)
- Whether to use ShellCheck's SARIF output format for GitHub integration or plain text
- Exact ordering of fixes (by script, by warning code, etc.)

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Codebase Analysis
- `.planning/codebase/TESTING.md` -- Documents current test state (none), ShellCheck gap, recommended CI structure
- `.planning/codebase/CONVENTIONS.md` -- Bash coding conventions including the `[[ ]]` no-quote rule that affects SC2086 handling
- `.planning/codebase/STRUCTURE.md` -- Directory layout showing where all scripts live (bin/, install/)

### Project Context
- `.planning/REQUIREMENTS.md` -- STAT-01 (ShellCheck zero errors) and STAT-09 (CI pipeline on push/PR) are this phase's requirements
- `.planning/ROADMAP.md` -- Phase 1 success criteria and dependency map (phases 2-4 depend on this)

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `.editorconfig` exists with formatting rules (2-space indent, LF, UTF-8, trim trailing whitespace) — ShellCheck won't conflict with these

### Established Patterns
- All bin/ scripts use `#!/bin/bash` shebang (never `#!/usr/bin/env bash`) — ShellCheck `shell=bash` directive aligns
- Codebase convention: no quoting inside `[[ ]]` — requires inline SC2086 disables at those sites
- Install scripts use unquoted `source` for dynamic paths — requires inline SC1090 directives
- Scripts use `set -eEo pipefail` in installer, `set -e` selectively in bin/ — ShellCheck is aware of these

### Integration Points
- `.github/` directory exists but only has issue templates — workflows directory needs to be created
- Future phases (2, 3, 4) will add jobs to the same CI workflow file

</code_context>

<specifics>
## Specific Ideas

No specific requirements — open to standard approaches

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 01-ci-pipeline-shellcheck*
*Context gathered: 2026-03-26*
