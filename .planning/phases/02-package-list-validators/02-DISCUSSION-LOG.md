# Phase 2: Package List Validators - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md -- this log preserves the alternatives considered.

**Date:** 2026-03-27
**Phase:** 02-package-list-validators
**Areas discussed:** PPA validation strategy, Network resilience, CI job granularity

---

## PPA Validation Strategy

| Option | Description | Selected |
|--------|-------------|----------|
| Set up PPAs in CI (Recommended) | Replicate the PPA setup from apt-setup.sh in the CI job. Adds ~30s to CI but validates all packages exactly as the installer would see them. Most accurate. | ✓ |
| Validate apt.packages only, skip ppa.packages | Only validate the 110 default-repo packages. PPA packages are assumed correct since they're a small curated list. Simpler but leaves a gap. | |
| Validate PPA packages via Launchpad API | Query Launchpad's REST API for each PPA to check package existence. No PPA setup needed, but adds API dependency and doesn't cover the Charm repo (not a PPA). | |

**User's choice:** Set up PPAs in CI
**Notes:** Most accurate approach — validates all packages exactly as the installer would see them.

---

## Network Resilience

| Option | Description | Selected |
|--------|-------------|----------|
| Fail the CI run (Recommended) | If a registry is unreachable, the job fails. Simple and honest — you'll know immediately. False failures from outages are rare and a re-run fixes it. | ✓ |
| Skip with warning | If a registry is unreachable, skip that validator and emit a warning annotation. CI passes but the validation gap is visible. Avoids blocking PRs on transient outages. | |
| Retry then fail | Retry the check 2-3 times with a short delay before failing. Handles brief network blips but adds CI time on genuine outages. | |

**User's choice:** Fail the CI run
**Notes:** Clean and simple. Network outage → fail → re-run.

---

## CI Job Granularity

| Option | Description | Selected |
|--------|-------------|----------|
| One combined job (Recommended) | Single 'validate-packages' job that validates all four package managers sequentially. Simpler workflow, less CI overhead. | |
| Separate jobs per manager | Four parallel jobs: validate-apt, validate-flatpak, validate-cargo, validate-pip. Better isolation — apt failure doesn't block seeing cargo results. But 4 status checks on every PR and more YAML to maintain. | ✓ |
| Two jobs: apt+ppa vs others | Split apt/ppa validation (needs PPA setup, heavier) from cargo/pip/flatpak (lightweight API checks). | |

**User's choice:** Separate jobs per manager
**Notes:** Four separate jobs for isolated, parallel feedback. apt.packages and ppa.packages combined in the same validate-apt job since both use apt infrastructure.

---

## Claude's Discretion

- Exact validation commands per package manager
- Package list file parsing (comment stripping, blank lines)
- Parallel vs sequential validation within each job
- Error message formatting
- Job dependency configuration

## Deferred Ideas

None -- discussion stayed within phase scope
