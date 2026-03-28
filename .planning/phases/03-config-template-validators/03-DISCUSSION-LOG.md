# Phase 3: Config & Template Validators - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-03-28
**Phase:** 03-config-template-validators
**Areas discussed:** Config path detection, Template variable completeness, Desktop entry scope, CI job structure

---

## Config Path Detection (STAT-06)

**Discussion:** User questioned relevance of this check. Analysis showed that `install/config/config.sh` does a bulk `cp -R config/* ~/.config/`, meaning broken paths already fail visibly in the install log. Agreed this is the lowest-value check of the three but worth keeping for completeness.

**User's choice:** Keep but don't over-engineer
**Notes:** User recognized this is a simple mechanical check — no deep discussion needed.

---

## Template Variable Completeness (STAT-07)

**User's choice:** Standard approach — extract variables from .tpl, strip _strip/_rgb suffixes, check base keys exist in all colors.toml files.
**Notes:** User agreed this catches real silent failures (literal `{{ variable }}` in generated configs).

---

## Desktop Entry Scope (STAT-08)

**User's choice:** Validate all .desktop files (applications/ + applications/hidden/).
**Notes:** No discussion — straightforward.

---

## CI Job Structure

| Option | Description | Selected |
|--------|-------------|----------|
| Single combined job | One `validate-configs` job with all three checks sequentially | ✓ |
| Three separate jobs | Separate jobs per validator (validate-config-paths, validate-templates, validate-desktop) | |

**User's choice:** Single combined job
**Notes:** Unlike Phase 2 where each package manager needed different setup (PPAs, Flatpak remote, etc.), all three checks here are local file operations — separate jobs add overhead without benefit.

---

## Claude's Discretion

- Config path extraction patterns and grep logic
- Template variable parsing implementation
- desktop-file-validate warning/error handling
- Error message formatting
- Job dependency configuration

## Deferred Ideas

None — discussion stayed within phase scope
