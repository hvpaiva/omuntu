---
phase: 01-ci-pipeline-shellcheck
plan: 01
subsystem: infra
tags: [shellcheck, bash, static-analysis, linting, ci]

# Dependency graph
requires: []
provides:
  - ".shellcheckrc with shell=bash and external-sources=true"
  - "Zero ShellCheck warnings across all install/, default/bash/, top-level, and config/omuntu/ scripts"
  - "Inline source directives for all dynamic source paths"
affects: [01-ci-pipeline-shellcheck-plan-02, all-future-phases]

# Tech tracking
tech-stack:
  added: [shellcheck]
  patterns: ["shellcheck source= directives for dynamic source paths", "source=/dev/null for system files", "separate declare and assign for local variables"]

key-files:
  created:
    - ".shellcheckrc"
  modified:
    - "install/helpers/all.sh"
    - "install/helpers/logging.sh"
    - "install/helpers/presentation.sh"
    - "install/helpers/chroot.sh"
    - "install/config/all.sh"
    - "install/packaging/all.sh"
    - "install/preflight/all.sh"
    - "install/login/all.sh"
    - "install/post-install/all.sh"
    - "install.sh"
    - "boot.sh"
    - "default/bash/rc"
    - "default/bash/shell"
    - "default/bash/init"
    - "default/bash/functions"
    - "default/bashrc"

key-decisions:
  - "Used shellcheck source= directives (not disable=SC1090) for known repo-internal sources"
  - "Used source=/dev/null for system files like /etc/os-release and bash-completion"
  - "Kept intentional SC2064 trap expansion with inline disable and explaining comment"
  - "Wrapped boot.sh cd in subshell instead of cd back pattern (SC2103)"

patterns-established:
  - "shellcheck source=path/to/file: Always add before source of known repo files"
  - "shellcheck source=/dev/null with comment: For system files not available during analysis"
  - "Separate declare and assign: Split local var=$(cmd) into two lines for SC2155"
  - "Every shellcheck disable must have explaining comment per D-09"

requirements-completed: [STAT-01]

# Metrics
duration: 7min
completed: 2026-03-26
---

# Phase 01 Plan 01: ShellCheck Fixes Summary

**Created .shellcheckrc and resolved all 132 ShellCheck warnings across install/, default/bash/, top-level scripts, and config/omuntu/ -- achieving zero-warning baseline for CI**

## Performance

- **Duration:** 7 min
- **Started:** 2026-03-26T13:55:12Z
- **Completed:** 2026-03-26T14:02:08Z
- **Tasks:** 2
- **Files modified:** 33

## Accomplishments
- Created .shellcheckrc with shell=bash and external-sources=true, eliminating all SC2148 warnings from sheban-less sourced scripts
- Fixed 132 ShellCheck warnings across 33 files (100 SC2086, 16 SC1091/SC1090, 7 SC2155, 2 SC2164, 2 SC2059, plus SC2236, SC2129, SC2103, SC2064, SC2231)
- All non-bin/ shell scripts now pass shellcheck --severity=style with zero warnings

## Task Commits

Each task was committed atomically:

1. **Task 1: Create .shellcheckrc and fix all install/ ShellCheck warnings** - `faae3a5b` (fix)
2. **Task 2: Fix all ShellCheck warnings in default/ and config/omuntu/ scripts** - `e6058c55` (fix)

## Files Created/Modified
- `.shellcheckrc` - Project-level ShellCheck config (shell=bash, external-sources=true)
- `install/helpers/all.sh` - Quoted source paths, added shellcheck source= directives
- `install/helpers/logging.sh` - Fixed SC2059 (printf format), SC2086 (pid quoting), SC2155 (export split), SC2129 (combined redirections)
- `install/helpers/presentation.sh` - Fixed SC2155 (export split for TERM_HEIGHT/WIDTH, LOGO_WIDTH/HEIGHT, PADDING)
- `install/helpers/chroot.sh` - Quoted $1 in systemctl enable calls
- `install/config/all.sh` - Quoted all 49 run_logged paths
- `install/packaging/all.sh` - Quoted all 16 run_logged paths
- `install/preflight/all.sh` - Quoted source and run_logged paths, added shellcheck source= directives
- `install/login/all.sh` - Quoted 2 run_logged paths
- `install/post-install/all.sh` - Quoted paths, added shellcheck source= directives
- `install.sh` - Added shellcheck source= directives for all 6 install phase sources
- `boot.sh` - Fixed SC2164 (cd || exit), SC2103 (subshell for cd), SC1090 (source directive)
- `install/preflight/guard.sh` - Added source=/dev/null for /etc/os-release
- `install/config/docker.sh` - Quoted ${USER}
- `install/config/input-group.sh` - Quoted ${USER}
- `install/config/hardware/fix-apple-t2.sh` - Quoted ${USER}
- `install/config/hardware/set-wireless-regdom.sh` - Fixed SC2236 (!-n to -z), SC1091 (source=/dev/null), SC2086 (quoted ${COUNTRY})
- `install/config/hardware/fix-asus-rog-audio-mixer.sh` - Quoted $OMUNTU_PATH path
- `install/config/walker-elephant.sh` - Quoted $OMUNTU_PATH paths
- `install/config/omuntu-ai-skill.sh` - Quoted $OMUNTU_PATH path
- `install/packaging/install-nerd-fonts.sh` - Fixed SC2155 (split local tmp_dir)
- `install/packaging/build-elephant.sh` - Added disable=SC2064 with explaining comment
- `install/packaging/fonts.sh` - Quoted source path, added shellcheck source= directive
- `install/packaging/mise.sh` - Quoted command path in subshell
- `install/packaging/rustup.sh` - Quoted command paths in subshells
- `default/bash/rc` - Added shellcheck source= directives for all 5 sourced files
- `default/bash/shell` - Added source=/dev/null for bash-completion
- `default/bash/init` - Added source=/dev/null for fzf scripts
- `default/bash/functions` - Quoted glob expansion, added source=/dev/null
- `default/bashrc` - Added shellcheck source= directive
- `default/bash/fns/drives` - Split local var=$(cmd) (SC2155)
- `default/bash/fns/tmux` - Split local var=$(cmd) (SC2155)
- `default/bash/fns/worktrees` - Split local var=$(cmd) (SC2155), added || return to cd (SC2164)

## Decisions Made
- Used `shellcheck source=path/to/file` directives instead of `shellcheck disable=SC1090` for known repo-internal source targets. This documents the actual dependency path.
- Used `shellcheck source=/dev/null` with explaining comments for system files (/etc/os-release, /etc/conf.d/wireless-regdom, bash-completion, fzf scripts).
- Kept the intentional SC2064 trap expansion in build-elephant.sh with inline disable and comment, since expanding BUILD_DIR at trap-set time is correct (captures the temp path).
- Used subshell `( cd ... )` in boot.sh instead of `cd -` pattern to cleanly avoid SC2103 and ensure the working directory is restored regardless of errors.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None.

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- All non-bin/ scripts now pass ShellCheck with zero warnings
- .shellcheckrc at repo root provides project-wide configuration
- Plan 02 (CI workflow + bin/ scripts) can proceed; the CI workflow will be able to run ShellCheck on the files fixed in this plan
- All shellcheck source= directives and inline disables have explaining comments per D-09

## Self-Check: PASSED

- FOUND: .shellcheckrc
- FOUND: 01-01-SUMMARY.md
- FOUND: faae3a5b (Task 1 commit)
- FOUND: e6058c55 (Task 2 commit)

---
*Phase: 01-ci-pipeline-shellcheck*
*Completed: 2026-03-26*
