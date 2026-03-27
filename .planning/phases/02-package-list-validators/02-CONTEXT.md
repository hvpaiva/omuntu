# Phase 2: Package List Validators - Context

**Gathered:** 2026-03-27
**Status:** Ready for planning

<domain>
## Phase Boundary

Validate that every package name in the five package list files (`apt.packages`, `ppa.packages`, `flatpak.packages`, `cargo.packages`, `pip.packages`) exists in its respective registry. Catch typos, removed packages, and invalid names in CI before they reach a 30-minute VM install cycle. Each package manager gets its own CI job for isolated feedback.

</domain>

<decisions>
## Implementation Decisions

### PPA Validation Strategy
- **D-01:** Set up PPAs in CI by replicating the PPA setup from `install/preflight/apt-setup.sh`. This means adding the 4 PPAs (cppiber/hyprland, mkasberg/ghostty-ubuntu, zhangsongcui3371/fastfetch, dotnet/backports) plus the Charm repo in the validate-apt job so both `apt.packages` and `ppa.packages` are validated against real repos.
- **D-02:** Validate `apt.packages` and `ppa.packages` in the same `validate-apt` job since both use apt infrastructure after PPA setup.

### Network Resilience
- **D-03:** Hard fail on network unreachability. If any external registry (apt repos, crates.io, PyPI, Flathub) is unreachable, the CI job fails. No retry logic, no skip-with-warning. A re-run fixes transient outages.

### CI Job Structure
- **D-04:** Four separate CI jobs for isolated, parallel feedback: `validate-apt`, `validate-flatpak`, `validate-cargo`, `validate-pip`. Each job runs independently so a failure in one doesn't block seeing results from others.
- **D-05:** All four jobs live in the existing `.github/workflows/ci.yml` file alongside the `shellcheck` job (per Phase 1 D-07).

### Claude's Discretion
- Exact validation commands per package manager (apt-cache, cargo search, pip index, flatpak remote-info, or API calls)
- How to parse package list files (comment stripping, blank line handling)
- Whether to validate packages in parallel within each job or sequentially
- Error message formatting (how to report which specific package failed)
- Job dependency configuration (whether package jobs depend on shellcheck or run independently)

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Package Lists
- `install/packages/apt.packages` -- 110 packages from default Ubuntu 24.04 repos (comments with `#`, blank line grouping)
- `install/packages/ppa.packages` -- 16 packages from PPAs (comments indicate source PPA)
- `install/packages/flatpak.packages` -- 6 Flatpak app IDs
- `install/packages/cargo.packages` -- 8 crate names (clean, no comments)
- `install/packages/pip.packages` -- 2 PyPI package names (clean, no comments)

### PPA Configuration
- `install/preflight/apt-setup.sh` -- PPA setup script that must be replicated in CI (4 PPAs + Charm repo)

### CI Workflow
- `.github/workflows/ci.yml` -- Existing CI workflow with shellcheck job; new jobs go here

### Project Context
- `.planning/REQUIREMENTS.md` -- STAT-02 (apt), STAT-03 (Flatpak), STAT-04 (cargo), STAT-05 (pip) are this phase's requirements
- `.planning/ROADMAP.md` -- Phase 2 success criteria and dependency map

### Codebase Analysis
- `.planning/codebase/STRUCTURE.md` -- Directory layout showing where package lists live
- `.planning/codebase/CONVENTIONS.md` -- Package list format conventions

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `install/preflight/apt-setup.sh` -- PPA setup logic to replicate in CI (add-apt-repository calls, Charm repo keyring setup)
- `.github/workflows/ci.yml` -- Existing CI workflow structure to extend with new jobs

### Established Patterns
- Package list format: one package per line, `#` for comments, blank lines for grouping
- `ppa.packages` uses comments to annotate which PPA provides each package (e.g., `# From ppa:cppiber/hyprland`)
- CI uses `ubuntu-latest` runner with standard apt tooling available

### Integration Points
- New jobs added to `.github/workflows/ci.yml` alongside existing `shellcheck` job
- Package list files are the same ones consumed by `install/packaging/base.sh` during actual installation

</code_context>

<specifics>
## Specific Ideas

No specific requirements -- open to standard approaches

</specifics>

<deferred>
## Deferred Ideas

None -- discussion stayed within phase scope

</deferred>

---

*Phase: 02-package-list-validators*
*Context gathered: 2026-03-27*
