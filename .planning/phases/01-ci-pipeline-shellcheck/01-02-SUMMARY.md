---
phase: 01-ci-pipeline-shellcheck
plan: 02
subsystem: testing
tags: [shellcheck, github-actions, ci, bash, linting]

# Dependency graph
requires: []
provides:
  - "All 198 bin/omuntu-* scripts passing ShellCheck --severity=style"
  - "GitHub Actions CI workflow at .github/workflows/ci.yml"
  - ".shellcheckrc with shell=bash and external-sources=true"
affects: [01-ci-pipeline-shellcheck]

# Tech tracking
tech-stack:
  added: [shellcheck, github-actions]
  patterns: [inline-shellcheck-directives-with-comments, ci-workflow-single-file]

key-files:
  created:
    - ".github/workflows/ci.yml"
    - ".shellcheckrc"
  modified:
    - "bin/omuntu-* (58 scripts)"

key-decisions:
  - "Used inline shellcheck disable with explanatory comments for intentional patterns (D-09)"
  - "Created .shellcheckrc as prerequisite for CI (D-08, was blocking)"
  - "Used explicit file lists in CI instead of complex find expressions"

patterns-established:
  - "Every shellcheck disable directive must have an explaining comment"
  - "SC2086 in brace expansion contexts gets inline disable with rationale"
  - "SC2155 fixed by splitting local var; var=$(cmd)"

requirements-completed: [STAT-01, STAT-09]

# Metrics
duration: 10min
completed: 2026-03-26
---

# Phase 01 Plan 02: bin/ ShellCheck Fixes and CI Workflow Summary

**Fixed 108 ShellCheck warnings across 58 bin/ scripts and created GitHub Actions CI workflow with ShellCheck job on ubuntu-latest**

## Performance

- **Duration:** 10 min
- **Started:** 2026-03-26T13:55:17Z
- **Completed:** 2026-03-26T14:05:19Z
- **Tasks:** 2
- **Files modified:** 60

## Accomplishments
- All 198 bin/omuntu-* scripts pass ShellCheck --severity=style with zero warnings
- GitHub Actions CI workflow created at .github/workflows/ci.yml, triggers on push to dev and PRs targeting dev
- .shellcheckrc created with shell=bash and external-sources=true for consistent ShellCheck behavior

## Task Commits

Each task was committed atomically:

1. **Task 1: Fix all ShellCheck warnings in bin/ scripts** - `cb199859` (fix)
2. **Task 2: Create GitHub Actions CI workflow with ShellCheck job** - `ea8480b0` (feat)

## Files Created/Modified
- `.github/workflows/ci.yml` - CI workflow with ShellCheck job covering all shell scripts
- `.shellcheckrc` - ShellCheck config: shell=bash, external-sources=true
- `bin/omuntu-battery-capacity` - Quote command substitution (SC2046)
- `bin/omuntu-battery-monitor` - Quote command substitution and variables (SC2046, SC2086)
- `bin/omuntu-battery-present` - Quote variables in cat commands (SC2086)
- `bin/omuntu-battery-remaining` - Quote command substitution (SC2046)
- `bin/omuntu-battery-remaining-time` - Quote command substitution (SC2046)
- `bin/omuntu-battery-status` - Quote command substitution (SC2046)
- `bin/omuntu-branch-set` - Quote variable expansions (SC2086)
- `bin/omuntu-brightness-display` - Replace ls with find (SC2012)
- `bin/omuntu-cmd-audio-switch` - Quote RHS of comparison (SC2053)
- `bin/omuntu-cmd-screenrecord` - Source directive, separate declare/assign (SC1090, SC2155, SC2086)
- `bin/omuntu-cmd-screensaver` - Add -r flag to read (SC2162)
- `bin/omuntu-cmd-screenshot` - Source directive, separate declare/assign, arithmetic fix (SC1090, SC2016, SC2155, SC2004)
- `bin/omuntu-dev-add-migration` - cd error handling, quote variables (SC2164, SC2086)
- `bin/omuntu-drive-select` - Fix array-to-string assignment (SC2124)
- `bin/omuntu-hook` - Suppress unused variable with explanation (SC2034)
- `bin/omuntu-hyprland-window-pop` - Quote variable expansions (SC2086)
- `bin/omuntu-hyprland-workspace-layout-toggle` - Quote variable expansion (SC2086)
- `bin/omuntu-install-dev-env` - Suppress single-quote expression, source directive (SC2016, SC1091)
- `bin/omuntu-install-docker-dbs` - Fix array-to-string assignment (SC2124)
- `bin/omuntu-install-terminal` - Quote variable expansions (SC2086)
- `bin/omuntu-install-xbox-controllers` - Quote command substitution and variable (SC2046, SC2086)
- `bin/omuntu-launch-browser` - Suppress word splitting in brace expansion (SC2086)
- `bin/omuntu-launch-or-focus` - Suppress word splitting for eval command (SC2086)
- `bin/omuntu-launch-or-focus-tui` - Fix array-to-string assignment (SC2124)
- `bin/omuntu-launch-or-focus-webapp` - Fix array-to-string assignment (SC2124)
- `bin/omuntu-launch-screensaver` - Quote variable expansions (SC2086)
- `bin/omuntu-launch-tui` - Quote command substitution and variable (SC2046, SC2086)
- `bin/omuntu-launch-webapp` - Suppress word splitting in brace expansion (SC2086)
- `bin/omuntu-menu` - Quote variable, separate declare/assign, source directive, suppress unused (SC2086, SC2155, SC1090, SC2034)
- `bin/omuntu-migrate` - Quote variable expansion (SC2086)
- `bin/omuntu-notification-dismiss` - Quote variable expansion (SC2086)
- `bin/omuntu-refresh-applications` - Quote variable expansions (SC2086)
- `bin/omuntu-refresh-walker` - Quote variable expansions (SC2086)
- `bin/omuntu-reinstall-configs` - Remove erroneous $(), quote variable (SC2091, SC2086)
- `bin/omuntu-reinstall-git` - Quote variable expansions (SC2086)
- `bin/omuntu-restart-app` - Quote variable expansion (SC2086)
- `bin/omuntu-setup-fido2` - Reorder comparison to fix glob matching (SC2053)
- `bin/omuntu-setup-fingerprint` - Reorder comparison to fix glob matching (SC2053)
- `bin/omuntu-theme-bg-next` - Quote RHS of comparison (SC2053)
- `bin/omuntu-theme-current` - Use sed directly on file instead of cat pipe (SC2086)
- `bin/omuntu-theme-install` - Quote variable expansion (SC2086)
- `bin/omuntu-theme-refresh` - Quote variable expansion (SC2086)
- `bin/omuntu-theme-remove` - Suppress unused variable with explanation (SC2034)
- `bin/omuntu-theme-set-browser` - Quote variable, suppress word splitting (SC2086)
- `bin/omuntu-theme-set-keyboard-asus-rog` - Quote command substitution (SC2046)
- `bin/omuntu-theme-set-keyboard-f16` - Quote command substitution (SC2046)
- `bin/omuntu-toggle-hybrid-gpu` - Quote variable expansions (SC2086)
- `bin/omuntu-toggle-nightlight` - Quote RHS of comparison (SC2053)
- `bin/omuntu-tui-remove` - Suppress single-quote expression, fix mapfile pattern (SC2016, SC2207)
- `bin/omuntu-update-available` - Quote command substitution, quote RHS of comparison (SC2046, SC2053)
- `bin/omuntu-update-git` - Quote variable expansions (SC2086)
- `bin/omuntu-update-restart` - Use parameter expansion instead of sed (SC2001)
- `bin/omuntu-version` - Quote variable expansion (SC2086)
- `bin/omuntu-version-branch` - Remove useless echo, quote substitution (SC2005, SC2046)
- `bin/omuntu-voxtype-install` - Quote variable expansion (SC2086)
- `bin/omuntu-webapp-handler-hey` - Use parameter expansion instead of sed (SC2001)
- `bin/omuntu-webapp-remove` - Fix mapfile pattern (SC2207)
- `bin/omuntu-windows-vm` - Quote variables, use parameter expansion (SC2086, SC2001)

## Decisions Made
- Used `# shellcheck disable=SC2086` with explanation for brace expansion contexts where quoting would break the pattern (omuntu-launch-browser, omuntu-launch-webapp)
- Used `# shellcheck disable=SC2086` with explanation for intentional word splitting in ffplay video_size_arg and eval LAUNCH_COMMAND
- Used `# shellcheck disable=SC2034` for variables set for use by external scripts (HOOK, ollama_pkg, CURRENT_DIR)
- Reordered `[[ "--remove" == $1 ]]` to `[[ $1 == "--remove" ]]` to fix SC2053 (avoids glob matching interpretation)
- Created .shellcheckrc as part of Task 2 since it is a prerequisite for the CI workflow (blocking dependency)

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Created .shellcheckrc as CI prerequisite**
- **Found during:** Task 2 (CI workflow creation)
- **Issue:** The .shellcheckrc file (D-08) was not yet created. It's required by the CI workflow to eliminate SC2148 warnings on install scripts that lack shebangs.
- **Fix:** Created .shellcheckrc with `shell=bash` and `external-sources=true` per the research document and D-08 decision
- **Files modified:** .shellcheckrc
- **Verification:** ShellCheck now correctly treats all scripts as Bash without needing shebangs
- **Committed in:** ea8480b0 (Task 2 commit)

---

**Total deviations:** 1 auto-fixed (1 blocking)
**Impact on plan:** Essential for CI workflow to function. No scope creep -- .shellcheckrc was a documented prerequisite in the research.

## Known Stubs

None -- all changes are complete fixes with no placeholder values.

## Issues Encountered
- Full suite ShellCheck (all 309 scripts) still has 150 warnings in install/, boot.sh, install.sh, and default/bash/ files. These are Plan 01's scope and will be fixed by the parallel executor. The CI workflow will pass once both plans complete.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness
- All bin/ scripts are ShellCheck-clean, establishing the baseline for future development
- CI workflow ready to enforce zero-warning policy on pushes and PRs to dev
- Remaining install/ and default/ warnings are Plan 01 scope (parallel execution)

## Self-Check: PASSED

- FOUND: .github/workflows/ci.yml
- FOUND: .shellcheckrc
- FOUND: 01-02-SUMMARY.md
- FOUND: cb199859 (Task 1 commit)
- FOUND: ea8480b0 (Task 2 commit)

---
*Phase: 01-ci-pipeline-shellcheck*
*Completed: 2026-03-26*
