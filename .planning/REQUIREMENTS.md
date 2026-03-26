# Requirements: Omuntu

**Defined:** 2026-03-25
**Core Value:** The installation must produce a fully working Hyprland desktop on Ubuntu that can be used as a daily driver.

## v1 Requirements

Requirements for initial release. Each maps to roadmap phases.

### Static Analysis

- [x] **STAT-01**: All shell scripts pass ShellCheck with zero errors in CI on every push
- [ ] **STAT-02**: All packages in apt.packages exist in Ubuntu 24.04 repos (including configured PPAs)
- [ ] **STAT-03**: All packages in flatpak.packages exist on Flathub
- [ ] **STAT-04**: All packages in cargo.packages are valid crate names
- [ ] **STAT-05**: All packages in pip.packages are valid PyPI packages
- [ ] **STAT-06**: Config paths referenced in install scripts exist in the config/ directory
- [ ] **STAT-07**: Theme template variables in .tpl files have matching entries in all themes/*/colors.toml
- [ ] **STAT-08**: All .desktop files in applications/ pass desktop-file-validate
- [x] **STAT-09**: GitHub Actions CI pipeline runs all static checks on every push and PR

### Unit Tests

- [ ] **UNIT-01**: bats-core framework set up with test helpers, PATH-based mocking, and temp directory isolation
- [ ] **UNIT-02**: Critical bin/ scripts have bats tests (omuntu-theme-set, omuntu-update, omuntu-refresh-config, omuntu-reinstall-configs)
- [ ] **UNIT-03**: Install helper scripts have bats tests (error handling, logging, presentation)
- [ ] **UNIT-04**: Install guard scripts have bats tests (OS detection, architecture check, user validation)
- [ ] **UNIT-05**: Package list parsing logic has bats tests

### Integration Tests

- [ ] **INTG-01**: Config deployment copies all files from config/ to correct target paths in a temp directory
- [ ] **INTG-02**: Theme rendering produces valid configs for all 17 themes without errors
- [ ] **INTG-03**: Session file generation creates valid Hyprland/UWSM .desktop entries
- [ ] **INTG-04**: Integration tests run in CI on Ubuntu runner (no VM needed)

### VM Automation

- [ ] **VM-01**: Single command reverts VM to pre-omuntu snapshot, starts it, and runs install
- [ ] **VM-02**: Post-install validation script runs inside VM and checks: binaries present, services active, configs deployed, waybar running (single instance), terminal launches
- [ ] **VM-03**: Validation script produces a structured report (pass/fail per check with details)

### Desktop Core Fixes

- [ ] **FIX-01**: Terminal (ghostty) opens correctly via Super+Return after installation
- [ ] **FIX-02**: Waybar runs as a single instance (no duplicate top bars)
- [ ] **FIX-03**: Elephant builds from source and runs correctly on Ubuntu
- [ ] **FIX-04**: Walker app launcher functions end-to-end (launch, search, select)
- [ ] **FIX-05**: All primary keybindings work (Super+Return, Super+Space, Super+Alt+Space, Super+K)
- [ ] **FIX-06**: Theme application works across all components (waybar, walker, ghostty, hyprland, btop)

## v2 Requirements

Deferred to future release. Tracked but not in current roadmap.

### Advanced Testing

- **ADV-01**: Idempotency tests — running install twice produces same result
- **ADV-02**: Hyprland config syntax validation via hyprctl --check in VM
- **ADV-03**: Nightly automated VM runs via CI self-hosted runner
- **ADV-04**: shfmt enforcement for consistent code formatting

### Extended Desktop

- **EXT-01**: All omuntu-menu entries functional
- **EXT-02**: Hardware-specific scripts validated (NVIDIA, bluetooth, audio)
- **EXT-03**: First-run flow works completely (migration, config customization)
- **EXT-04**: omuntu-update works end-to-end without errors

### Tech Debt

- **DEBT-01**: Rename AUR-prefixed scripts/functions to Flatpak equivalents
- **DEBT-02**: Refactor monolithic omuntu-menu (627 lines) into modular structure
- **DEBT-03**: Fix omuntu-reinstall-configs command substitution bug
- **DEBT-04**: Implement snapshot/rollback mechanism (timeshift or snapper)

## Out of Scope

| Feature | Reason |
|---------|--------|
| ISO testing pipeline | Omuntu is an installer, not a distribution |
| Visual regression testing | Too complex for single-developer Bash project; manual visual check is sufficient |
| Browser-based test dashboard | Over-engineering; terminal output and CI status are sufficient |
| Container-based full install testing | Containers cannot test systemd/Wayland/DRM — fundamentally wrong tool |
| Automated Wayland session testing | No existing tooling; headless Hyprland testing is uncharted territory |
| Bash code coverage tooling | Marginal value for shell scripts; focus on functional correctness |
| Package version pinning tests | Omuntu doesn't pin versions; testing floating versions is not actionable |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| STAT-01 | Phase 1 | Complete |
| STAT-02 | Phase 2 | Pending |
| STAT-03 | Phase 2 | Pending |
| STAT-04 | Phase 2 | Pending |
| STAT-05 | Phase 2 | Pending |
| STAT-06 | Phase 3 | Pending |
| STAT-07 | Phase 3 | Pending |
| STAT-08 | Phase 3 | Pending |
| STAT-09 | Phase 1 | Complete |
| UNIT-01 | Phase 4 | Pending |
| UNIT-02 | Phase 5 | Pending |
| UNIT-03 | Phase 5 | Pending |
| UNIT-04 | Phase 6 | Pending |
| UNIT-05 | Phase 6 | Pending |
| INTG-01 | Phase 7 | Pending |
| INTG-02 | Phase 7 | Pending |
| INTG-03 | Phase 7 | Pending |
| INTG-04 | Phase 7 | Pending |
| VM-01 | Phase 8 | Pending |
| VM-02 | Phase 8 | Pending |
| VM-03 | Phase 8 | Pending |
| FIX-01 | Phase 9 | Pending |
| FIX-02 | Phase 9 | Pending |
| FIX-03 | Phase 10 | Pending |
| FIX-04 | Phase 10 | Pending |
| FIX-05 | Phase 9 | Pending |
| FIX-06 | Phase 10 | Pending |

**Coverage:**
- v1 requirements: 27 total
- Mapped to phases: 27
- Unmapped: 0

---
*Requirements defined: 2026-03-25*
*Last updated: 2026-03-25 after roadmap creation*
