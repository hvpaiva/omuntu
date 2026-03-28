# Roadmap: Omuntu

## Overview

Omuntu needs testing infrastructure before its desktop bugs can be sustainably fixed. The roadmap builds a four-layer test pyramid (static analysis, unit tests, integration tests, VM system tests) from cheapest-to-run to most-comprehensive, then uses that infrastructure to fix the six known desktop failures. Each testing layer gates the next, delivering independently useful CI feedback from the first merged phase. Fine granularity splits the static analysis and unit test layers into focused delivery boundaries so each phase completes in a tight scope.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [ ] **Phase 1: CI Pipeline & ShellCheck** - GitHub Actions CI with ShellCheck linting on all scripts
- [ ] **Phase 2: Package List Validators** - Validate apt, Flatpak, cargo, and pip package lists against real repos
- [ ] **Phase 3: Config & Template Validators** - Validate config paths, theme template variables, and desktop entries
- [ ] **Phase 4: BATS Framework Setup** - bats-core framework with helpers, mocks, and temp directory isolation
- [ ] **Phase 5: Unit Tests for Critical Scripts** - BATS tests for core bin/ scripts and install helpers
- [ ] **Phase 6: Unit Tests for Guards & Parsing** - BATS tests for install guards and package list parsing
- [ ] **Phase 7: Integration Tests** - Multi-script workflow tests for config deployment, themes, and sessions
- [ ] **Phase 8: VM Automation** - Single-command VM revert/install/validate pipeline with structured reporting
- [ ] **Phase 9: Terminal & Compositor Fixes** - Fix terminal launch, waybar duplication, and keybinding failures
- [ ] **Phase 10: App & Theme Fixes** - Fix elephant build, walker launcher, and theme application

## Phase Details

### Phase 1: CI Pipeline & ShellCheck
**Goal**: Every push and PR gets automatic feedback on shell script correctness
**Depends on**: Nothing (first phase)
**Requirements**: STAT-01, STAT-09
**Success Criteria** (what must be TRUE):
  1. Pushing a commit to any branch triggers a GitHub Actions workflow that completes without manual intervention
  2. A PR with a ShellCheck error in any shell script shows a failing CI check
  3. A PR with no ShellCheck errors in any shell script shows a passing CI check
  4. The project has a .shellcheckrc that suppresses only intentional patterns (documented with comments)
**Plans**: 2 plans

Plans:
- [ ] 01-01-PLAN.md — Create .shellcheckrc and fix ShellCheck warnings in install/, default/, and top-level scripts
- [x] 01-02-PLAN.md — Fix ShellCheck warnings in bin/ scripts and create GitHub Actions CI workflow

### Phase 2: Package List Validators
**Goal**: Package list errors are caught in CI before they reach a 30-minute VM install cycle
**Depends on**: Phase 1
**Requirements**: STAT-02, STAT-03, STAT-04, STAT-05
**Success Criteria** (what must be TRUE):
  1. Adding a nonexistent package name to apt.packages causes CI to fail with a clear error message naming the bad package
  2. Adding a nonexistent Flatpak app ID to flatpak.packages causes CI to fail
  3. Adding a nonexistent crate name to cargo.packages causes CI to fail
  4. Adding a nonexistent PyPI package to pip.packages causes CI to fail
**Plans**: 1 plan

Plans:
- [x] 02-01-PLAN.md — Add four package validation CI jobs (apt, Flatpak, cargo, pip) to ci.yml

### Phase 3: Config & Template Validators
**Goal**: Broken config references, incomplete themes, and malformed desktop entries are caught in CI
**Depends on**: Phase 1
**Requirements**: STAT-06, STAT-07, STAT-08
**Success Criteria** (what must be TRUE):
  1. A config path referenced in an install script that does not exist in config/ causes CI to fail with the broken reference identified
  2. A theme template variable in a .tpl file that has no matching entry in any themes/*/colors.toml causes CI to fail
  3. A .desktop file in applications/ that fails desktop-file-validate causes CI to fail
**Plans**: TBD

Plans:
- [ ] 03-01: TBD

### Phase 4: BATS Framework Setup
**Goal**: A working test framework exists that any developer can run locally and in CI
**Depends on**: Phase 1
**Requirements**: UNIT-01
**Success Criteria** (what must be TRUE):
  1. Running `make test-unit` (or equivalent) from repo root executes bats tests and produces TAP output
  2. A sample test demonstrating PATH-based mocking, temp directory isolation, and bats-assert usage passes
  3. CI runs unit tests after static analysis passes (gated)
**Plans**: TBD

Plans:
- [ ] 04-01: TBD

### Phase 5: Unit Tests for Critical Scripts
**Goal**: The most important bin/ and install helper scripts have automated correctness checks
**Depends on**: Phase 4
**Requirements**: UNIT-02, UNIT-03
**Success Criteria** (what must be TRUE):
  1. omuntu-theme-set, omuntu-update, omuntu-refresh-config, and omuntu-reinstall-configs each have at least one bats test that validates their core behavior
  2. Install helper functions (error handling, logging, presentation) each have at least one bats test
  3. Breaking a tested script's core logic causes a CI test failure
**Plans**: TBD

Plans:
- [ ] 05-01: TBD
- [ ] 05-02: TBD

### Phase 6: Unit Tests for Guards & Parsing
**Goal**: Install precondition checks and package parsing logic are verified automatically
**Depends on**: Phase 4
**Requirements**: UNIT-04, UNIT-05
**Success Criteria** (what must be TRUE):
  1. Guard scripts (OS detection, architecture check, user validation) have bats tests that verify correct acceptance and rejection
  2. Package list parsing logic has bats tests covering comments, blank lines, inline annotations, and edge cases
  3. A guard script change that breaks OS detection causes a CI test failure
**Plans**: TBD

Plans:
- [ ] 06-01: TBD
- [ ] 06-02: TBD

### Phase 7: Integration Tests
**Goal**: Multi-script workflows produce correct filesystem state when run together on Ubuntu
**Depends on**: Phase 4
**Requirements**: INTG-01, INTG-02, INTG-03, INTG-04
**Success Criteria** (what must be TRUE):
  1. Config deployment test copies all files from config/ to correct target paths in a temp directory matching the expected structure
  2. Theme rendering test produces valid configs for all 17 themes with no unresolved template placeholders
  3. Session file generation test creates valid Hyprland/UWSM .desktop entries that pass desktop-file-validate
  4. Integration tests run in CI on an Ubuntu runner without requiring a VM
  5. Total CI time for static analysis + unit tests + integration tests stays under 5 minutes
**Plans**: TBD

Plans:
- [ ] 07-01: TBD
- [ ] 07-02: TBD

### Phase 8: VM Automation
**Goal**: Full install validation is a single command instead of a 30-minute manual workflow
**Depends on**: Phase 7
**Requirements**: VM-01, VM-02, VM-03
**Success Criteria** (what must be TRUE):
  1. A single command reverts the VM to the pre-omuntu snapshot, starts it, and runs the installer without manual steps
  2. After install, a validation script inside the VM checks binaries, services, configs, waybar, and terminal and produces a structured pass/fail report
  3. The validation report clearly identifies which checks passed and which failed with actionable details
**Plans**: TBD

Plans:
- [ ] 08-01: TBD
- [ ] 08-02: TBD

### Phase 9: Terminal & Compositor Fixes
**Goal**: After installation, the core desktop session works -- terminal opens, waybar is correct, keybindings respond
**Depends on**: Phase 8
**Requirements**: FIX-01, FIX-02, FIX-05
**Success Criteria** (what must be TRUE):
  1. Pressing Super+Return after a fresh install opens a terminal window (ghostty)
  2. Waybar appears once at the top of the screen with no duplicate instance
  3. Super+Space opens walker, Super+Alt+Space opens walker in a secondary mode, and Super+K opens the clipboard manager
  4. VM validation script confirms all three checks pass on a fresh install
**Plans**: TBD
**UI hint**: yes

Plans:
- [ ] 09-01: TBD
- [ ] 09-02: TBD

### Phase 10: App & Theme Fixes
**Goal**: Remaining desktop applications and theming work correctly after installation
**Depends on**: Phase 9
**Requirements**: FIX-03, FIX-04, FIX-06
**Success Criteria** (what must be TRUE):
  1. Elephant builds from source during install and runs correctly on Ubuntu
  2. Walker app launcher can be opened, accepts a search query, and launches the selected application
  3. Applying a theme via omuntu-theme-set changes the appearance of waybar, walker, ghostty, hyprland, and btop without errors
  4. VM validation script confirms all three checks pass on a fresh install
**Plans**: TBD
**UI hint**: yes

Plans:
- [ ] 10-01: TBD
- [ ] 10-02: TBD

## Progress

**Execution Order:**
Phases execute in numeric order: 1 -> 2 -> 3 -> 4 -> 5 -> 6 -> 7 -> 8 -> 9 -> 10
Note: Phases 2, 3, and 4 all depend only on Phase 1 and could execute in parallel.
Phases 5 and 6 both depend on Phase 4 and could execute in parallel.

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. CI Pipeline & ShellCheck | 0/2 | Not started | - |
| 2. Package List Validators | 0/1 | Not started | - |
| 3. Config & Template Validators | 0/1 | Not started | - |
| 4. BATS Framework Setup | 0/1 | Not started | - |
| 5. Unit Tests for Critical Scripts | 0/2 | Not started | - |
| 6. Unit Tests for Guards & Parsing | 0/2 | Not started | - |
| 7. Integration Tests | 0/2 | Not started | - |
| 8. VM Automation | 0/2 | Not started | - |
| 9. Terminal & Compositor Fixes | 0/2 | Not started | - |
| 10. App & Theme Fixes | 0/2 | Not started | - |
