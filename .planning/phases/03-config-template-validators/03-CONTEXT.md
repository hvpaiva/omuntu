# Phase 3: Config & Template Validators - Context

**Gathered:** 2026-03-28
**Status:** Ready for planning

<domain>
## Phase Boundary

Add CI validation for three categories of static files: config path references in install scripts (STAT-06), theme template variable completeness across all 17 themes (STAT-07), and desktop entry correctness (STAT-08). All three are mechanical checks with no external dependencies beyond `desktop-file-validate`.

</domain>

<decisions>
## Implementation Decisions

### CI Job Structure
- **D-01:** Single combined `validate-configs` CI job with all three checks running sequentially. Unlike Phase 2 (which needed different setup per package manager), all three checks here are local file operations with no external dependencies — separate jobs would add overhead without benefit.
- **D-02:** Job lives in existing `.github/workflows/ci.yml` alongside shellcheck and package validator jobs (per Phase 1 D-07, Phase 2 D-05).
- **D-03:** Inline CI scripts, no external files (per Phase 2 convention).

### Config Path Validation (STAT-06)
- **D-04:** Lowest-value check of the three — the bulk `cp -R config/* ~/.config/` in `install/config/config.sh` copies everything, and path failures already show in install logs. Include for completeness but don't over-engineer.

### Template Variable Validation (STAT-07)
- **D-05:** Extract all `{{ variable }}` references from `default/themed/*.tpl` files, strip `_strip` and `_rgb` suffixes to get base key names, and verify each base key exists in every `themes/*/colors.toml`. A missing key means a theme would produce literal `{{ variable }}` in generated configs — a silent visual failure.

### Desktop Entry Validation (STAT-08)
- **D-06:** Run `desktop-file-validate` on all `.desktop` files in both `applications/` (4 files) and `applications/hidden/` (31 files). Validate everything — hidden entries are still parsed by desktop environments.

### Claude's Discretion
- How to extract config path references from install scripts (grep patterns, which scripts to scan)
- Exact grep/sed logic for extracting template variables and parsing colors.toml keys
- Whether `desktop-file-validate` warnings vs errors should both fail CI
- Error message formatting and output structure within the single job
- Job dependency (whether validate-configs depends on shellcheck or runs independently)

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Template System
- `bin/omuntu-theme-set-templates` — Template processing script showing how `{{ variable }}`, `{{ variable_strip }}`, `{{ variable_rgb }}` substitution works via sed
- `default/themed/*.tpl` — 14 template files using `{{ variable }}` placeholders
- `themes/*/colors.toml` — 17 theme color definitions (keys: accent, cursor, foreground, background, selection_foreground, selection_background, color0-color15)

### Config Deployment
- `install/config/config.sh` — Bulk config copy (`cp -R config/* ~/.config/`)
- `install/config/` — Other install scripts that reference specific config paths

### Desktop Entries
- `applications/*.desktop` — 4 custom desktop entry files
- `applications/hidden/*.desktop` — 31 hidden desktop entries (NoDisplay=true overrides)

### CI Workflow
- `.github/workflows/ci.yml` — Existing CI workflow to extend with new job

### Project Context
- `.planning/REQUIREMENTS.md` — STAT-06, STAT-07, STAT-08 are this phase's requirements
- `.planning/ROADMAP.md` — Phase 3 success criteria

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `bin/omuntu-theme-set-templates` — Contains the exact variable extraction and sed substitution logic; validator can mirror this parsing approach
- `.github/workflows/ci.yml` — Existing CI structure with shellcheck + 4 package validator jobs to extend

### Established Patterns
- Template variables use `{{ key }}` syntax with `_strip` (hex without #) and `_rgb` (decimal R,G,B) derived variants
- All 17 themes currently define the same standard key set (accent, cursor, foreground, background, selection_foreground, selection_background, color0-15)
- Package list format: one entry per line, `#` for comments, blank lines for grouping — same parsing pattern applies to colors.toml

### Integration Points
- New `validate-configs` job added to `.github/workflows/ci.yml`
- Template variable names extracted from `.tpl` files must match keys in `colors.toml` — the same mapping used at runtime by `omuntu-theme-set-templates`

</code_context>

<specifics>
## Specific Ideas

No specific requirements — checks are mechanical. Follow existing CI patterns from Phase 1 and 2.

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 03-config-template-validators*
*Context gathered: 2026-03-28*
