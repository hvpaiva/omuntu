# Omuntu

## What This Is

A fork of Omarchy adapted for Ubuntu 24.04 LTS. Omuntu transforms an existing Ubuntu installation into the full Omarchy desktop experience (Hyprland + themes + tooling) via a shell-based installer — not an ISO. The goal is to provide an experience as close to Arch-based Omarchy as possible, changing only what's necessary for Ubuntu compatibility.

## Core Value

The installation must produce a fully working Hyprland desktop on Ubuntu that can be used as a daily driver — terminal opens, apps launch, waybar works, themes apply, keybindings function.

## Requirements

### Validated

- ✓ Installer framework with phased execution (preflight → packaging → config → login → post-install) — existing
- ✓ Package installation via apt, Flatpak, cargo, pipx, and source builds — existing
- ✓ Config deployment (config/ → ~/.config/) with managed defaults (default/) — existing
- ✓ Theme system with 17 color schemes and template-based config generation — existing
- ✓ Hyprland session creation and UWSM integration — existing
- ✓ CLI command framework (198 omuntu-* scripts) — existing
- ✓ Walker app launcher build and configuration — existing
- ✓ Hardware detection and configuration (NVIDIA, bluetooth, audio, wifi) — existing
- ✓ Desktop entry management (custom apps + hidden entries) — existing
- ✓ Update mechanism (omuntu-update) — existing
- ✓ Migration framework for config upgrades — existing

### Active

- [ ] Automated test infrastructure for validating changes without full VM cycle
- [ ] Local tests: script syntax validation, package existence checks, config path verification
- [ ] VM automation: scripted revert/start, post-install validation script
- [ ] Terminal opens correctly after installation (ghostty/session config)
- [ ] Waybar runs as single instance (no duplication)
- [ ] Elephant builds and runs correctly on Ubuntu
- [ ] App launcher (Walker) functions end-to-end
- [ ] All keybindings work (Super+Return, Super+Space, Super+Alt+Space, Super+K)
- [ ] Theme application works across all components

### Out of Scope

- Building an ISO — Omuntu is an installer, not a distribution
- Plymouth/boot splash theming — not managed on Ubuntu
- Bootloader configuration — not managed on Ubuntu
- SDDM theming — Ubuntu uses existing DM (GDM)
- Snapshots/rollback — not implemented for Ubuntu (stub exists)
- Autologin — not managed
- Multi-architecture support — x86_64 only

## Context

- Fork of [Omarchy](https://github.com/basecamp/omarchy) (Arch Linux)
- Pure Bash codebase (~198 scripts in bin/, installer in install/)
- Key Arch→Ubuntu adaptations already done: pacman→apt, AUR→Flatpak, package renaming, PPA setup, source builds for unavailable packages
- Current state: installs successfully but desktop has cascading failures — terminal doesn't open, which blocks validation of everything downstream
- Testing is 90%+ manual via QEMU/libvirt VMs with snapshot-based revert
- Each validation cycle takes 30-40 minutes, has been repeated 20+ times
- Known tech debt: AUR naming remnants, monolithic menu script, various script bugs (see .planning/codebase/CONCERNS.md)

## Constraints

- **Platform**: Ubuntu 24.04 LTS (x86_64 only) — enforced by preflight guard
- **Language**: Pure Bash — no external templating engines, keep consistent with upstream Omarchy
- **Upstream compatibility**: Minimize divergence from Omarchy to ease future syncs
- **Testing environment**: QEMU/libvirt VM with Ubuntu 24.04, snapshot at `ubuntu2404.pre-omuntu`
- **No package pinning**: Versions float with upstream repos (apt, Flatpak, cargo)

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Build testing infrastructure before fixing bugs | 20+ manual cycles proved fixing without tests is unsustainable | — Pending |
| Two-layer testing (local + VM) | Local catches 70% of issues fast; VM validates what needs real environment | — Pending |
| Keep Bash-only approach | Consistency with upstream Omarchy, no additional dependencies | — Pending |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd:transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd:complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-03-25 after initialization*
