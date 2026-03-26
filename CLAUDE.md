<!-- GSD:project-start source:PROJECT.md -->
## Project

**Omuntu**

A fork of Omarchy adapted for Ubuntu 24.04 LTS. Omuntu transforms an existing Ubuntu installation into the full Omarchy desktop experience (Hyprland + themes + tooling) via a shell-based installer — not an ISO. The goal is to provide an experience as close to Arch-based Omarchy as possible, changing only what's necessary for Ubuntu compatibility.

**Core Value:** The installation must produce a fully working Hyprland desktop on Ubuntu that can be used as a daily driver — terminal opens, apps launch, waybar works, themes apply, keybindings function.

### Constraints

- **Platform**: Ubuntu 24.04 LTS (x86_64 only) — enforced by preflight guard
- **Language**: Pure Bash — no external templating engines, keep consistent with upstream Omarchy
- **Upstream compatibility**: Minimize divergence from Omarchy to ease future syncs
- **Testing environment**: QEMU/libvirt VM with Ubuntu 24.04, snapshot at `ubuntu2404.pre-omuntu`
- **No package pinning**: Versions float with upstream repos (apt, Flatpak, cargo)
<!-- GSD:project-end -->

<!-- GSD:stack-start source:codebase/STACK.md -->
## Technology Stack

## Languages
- Bash (5.x, requires 4+) - All install scripts, bin utilities (~5600 lines across `bin/`), config scripts, hooks, helpers. Every file in `bin/`, `install/`, and `default/bash/` is pure Bash.
- Go >= 1.25 - Used to build Elephant from source (`install/packaging/build-elephant.sh`)
- Rust (stable + nightly) - Used to build Walker (`install/packaging/build-walker.sh`) and SwayOSD (`install/packaging/build-swayosd.sh`) from source
- QML (Qt Quick 2.0) - SDDM login theme (`default/sddm/omuntu/Main.qml`)
- Lua - Elephant menu configs (`default/elephant/omuntu_themes.lua`, `default/elephant/omuntu_background_selector.lua`)
- Plymouth Script - Boot splash animation (`default/plymouth/omuntu.script`)
- CSS - Waybar styling (`config/waybar/style.css`), Walker themes (`default/walker/themes/`)
- JavaScript - Chromium extension (`default/chromium/extensions/copy-url/background.js`)
- TOML - Configuration files: Starship (`config/starship.toml`), Walker (`config/walker/config.toml`), Ghostty, theme color definitions (`themes/*/colors.toml`)
- JSONC - Waybar config (`config/waybar/config.jsonc`), Fastfetch config (`config/fastfetch/config.jsonc`)
- Hyprland config language - All files in `config/hypr/` and `default/hypr/`
## Runtime
- Ubuntu 24.04+ (x86_64 only) - Enforced by `install/preflight/guard.sh`
- Wayland session via Hyprland compositor
- UWSM (Universal Wayland Session Manager) for session lifecycle
- SDDM display manager for login (`install/login/session.sh`)
- systemd (user units for battery monitor, Elephant service, Walker restart)
- Bash as default and only supported shell
- Default bashrc at `default/bashrc` sources `default/bash/rc` which chains: envs, shell, aliases, functions, init
## Package Managers
- Primary package manager for Ubuntu
- Package list: `install/packages/apt.packages` (109 packages)
- PPAs configured in `install/preflight/apt-setup.sh`:
- Secondary package manager for sandboxed GUI apps
- Package list: `install/packages/flatpak.packages` (6 packages: LocalSend, Obsidian, Spotify, Signal, Typora, Pinta)
- Installed via rustup (`install/packaging/rustup.sh`), NOT Ubuntu's packaged rustc (1.75 is too old)
- Package list: `install/packages/cargo.packages` (8 crates: bluetui, dust, impala, satty, starship, usage-cli, tree-sitter-cli, wiremix)
- Used instead of pip for CLI tools (Ubuntu 24.04 externally managed Python)
- Package list: `install/packages/pip.packages` (2 packages: terminaltexteffects, tzupdate)
- Installed via curl from https://mise.jdx.dev/install.sh (`install/packaging/mise.sh`)
- Manages dev language runtimes: Node.js, Ruby, Python, Go, Java, Elixir, Erlang, Zig, Bun, Deno, .NET, Clojure, Scala
- Activated in bash via `eval "$(mise activate bash)"` in `default/bash/init`
- Activated in UWSM env via `mise activate bash --shims` in `config/uwsm/env`
- Used to provide Go >= 1.25 when system Go is too old (`install/packaging/build-elephant.sh`)
- Walker (Rust app launcher) - `install/packaging/build-walker.sh`
- SwayOSD + gtk4-layer-shell - `install/packaging/build-swayosd.sh` (requires Rust nightly)
- Elephant (Go Walker data provider) - `install/packaging/build-elephant.sh`
- lazygit - binary from GitHub releases (`install/packaging/lazygit.sh`)
- lazydocker - binary from GitHub releases (`install/packaging/build-lazydocker.sh`)
- Nerd Fonts - downloaded from GitHub releases (`install/packaging/install-nerd-fonts.sh`)
## Frameworks & Core Components
- Hyprland - Wayland compositor/window manager
- Waybar - Status bar (`config/waybar/config.jsonc`, `config/waybar/style.css`)
- Walker - Application launcher (Rust-based, with Elephant data backend)
- Mako - Notification daemon (`default/mako/core.ini`)
- SwayOSD - On-screen display for volume/brightness
- swaybg - Wallpaper manager
- hypridle - Idle management (`config/hypr/hypridle.conf`)
- hyprlock - Lock screen (`config/hypr/hyprlock.conf`)
- hyprsunset - Night light / blue light filter (`config/hypr/hyprsunset.conf`)
- hyprpicker - Color picker
- Ghostty (default, from PPA) - `config/ghostty/config`
- Alacritty (optional) - `config/alacritty/`
- Kitty (optional) - `config/kitty/`
- Starship - Cross-shell prompt (`config/starship.toml`)
- zoxide - Smart directory jumping (integrated as `cd` replacement in `default/bash/aliases`)
- fzf - Fuzzy finder (completions + keybindings in `default/bash/init`)
- mise - Runtime version manager (activated in `default/bash/init`)
- eza - Modern `ls` replacement (aliased in `default/bash/aliases`)
- bat - Modern `cat` with syntax highlighting (theme: ansi)
- ripgrep - Fast search
- fd-find - Fast file finder (symlinked to `fd` in `install/packaging/base.sh`)
- Neovim with LazyVim distribution - setup via `bin/omuntu-nvim-setup` (149 lines)
- tmux - `config/tmux/tmux.conf` (vi mode, C-Space prefix, 256-color)
- lazygit - TUI git client
- gh - GitHub CLI
- Git config at `config/git/config` (rebase on pull, autoSetupRemote, histogram diff, rerere)
- docker.io, docker-buildx, docker-compose-v2 (from apt)
- lazydocker - TUI Docker client
- Configured in `install/config/docker.sh` (socket activation, log limits, DNS via systemd-resolved)
- gum (Charm) - Used extensively in installer for prompts, menus, error handling, and styled output. Installed early in `install/helpers/presentation.sh` before anything else.
## Theming System
- 17 built-in themes in `themes/`: catppuccin, catppuccin-latte, ethereal, everforest, flexoki-light, gruvbox, hackerman, kanagawa, matte-black, miasma, nord, osaka-jade, ristretto, rose-pine, tokyo-night, vantablack, white
- Each theme directory contains: `colors.toml` (16-color ANSI palette + accent/cursor/foreground/background/selection), optional `btop.theme`, `neovim.lua`, `vscode.json`, `waybar.css`, `icons.theme`, `light.mode`, `backgrounds/`
- Template files in `default/themed/*.tpl` use `{{ variable }}` placeholder syntax (simple substitution, NOT Go templates)
- Variable modifiers: `{{ variable_strip }}` (hex without #), `{{ variable_rgb }}` (decimal R,G,B)
- Theme switching: `bin/omuntu-theme-set` copies theme, processes templates, swaps atomically, restarts all themed components
- User overrides: `~/.config/omuntu/themed/*.tpl` takes priority over `default/themed/`
- User themes: `~/.config/omuntu/themes/<name>/` overlays on stock themes
- Scripts in `~/.config/omuntu/hooks/` executed on events: theme-set, font-set, post-update, battery-low
- Samples provided with `.sample` extension in `config/omuntu/hooks/`
- `~/.config/omuntu/extensions/menu.sh` can override any menu function from `bin/omuntu-menu`
## Key Dependencies
- gum (Charm) - TUI framework for installer and menus
- jq - JSON processing, used in Hyprland scripts for monitor/window queries
- wl-clipboard - Wayland clipboard (wl-copy/wl-paste)
- brightnessctl - Display/keyboard brightness control
- playerctl - Media player control
- pamixer - PulseAudio mixer CLI
- xmlstarlet - XML processing for webapp generation
- PipeWire (pipewire, pipewire-alsa, pipewire-jack, pipewire-pulse) + WirePlumber - Audio stack
- Docker (docker.io, docker-buildx, docker-compose-v2) - Container runtime
- bluez - Bluetooth stack
- ufw - Firewall (`install/first-run/firewall.sh`)
- cups + cups-browsed + cups-filters + printer-driver-cups-pdf - Printing
- avahi-daemon + libnss-mdns - Network service discovery (mDNS)
- gnome-keyring - Secrets/credential storage
- policykit-1-gnome - Privilege escalation UI
- power-profiles-daemon - Power management
- plocate - File indexing/searching
## Configuration
- `OMUNTU_PATH` = `~/.local/share/omuntu`
- `TERMINAL` = `xdg-terminal-exec`
- `EDITOR` = `nvim`
- `BAT_THEME` = `ansi`
- Wayland session vars: XDG_CURRENT_DESKTOP, QT_QPA_PLATFORM, GDK_BACKEND, SDL_VIDEODRIVER, etc.
- fcitx5 input method vars in `config/environment.d/fcitx.conf`
- `~/.local/share/omuntu/` - Omuntu installation (git clone of this repo)
- `~/.config/omuntu/current/` - Active theme, background symlink, theme name
- `~/.config/omuntu/themes/` - User-installed themes
- `~/.config/omuntu/branding/` - Customizable logo/screensaver ASCII art
- `~/.local/state/omuntu/` - Runtime state: first-run marker, toggles, migrations
- `/var/log/omuntu-install.log` - Full install log with timestamps per script
## Platform Requirements
- Git, Bash 5.x
- Understanding of Hyprland config syntax, Waybar JSONC, TOML
- Familiarity with Ubuntu packaging (apt, PPAs, dpkg)
- No build system or CI pipeline detected in this repository
- Ubuntu 24.04+ (x86_64) - strictly enforced
- Internet connection for initial install (`boot.sh` clones repo and runs `install.sh`)
- Sudo access (installer grants temporary passwordless sudo, removes after install)
<!-- GSD:stack-end -->

<!-- GSD:conventions-start source:CONVENTIONS.md -->
## Conventions

## Naming Patterns
- All 198 commands live in `bin/` and follow `omuntu-{prefix}-{action}` naming
- Use lowercase kebab-case: `omuntu-theme-set`, `omuntu-launch-browser`, `omuntu-hyprland-window-close-all`
- Prefix after `omuntu-` indicates purpose (defined in `AGENTS.md`):
- When adding a new command, always use the appropriate prefix. If no prefix fits, consider whether a new prefix category is needed.
- Named with descriptive kebab-case: `build-elephant.sh`, `apt-setup.sh`, `nvidia.sh`
- Fix scripts prefixed with `fix-`: `fix-powerprofilesctl-shebang.sh`, `fix-intel-panther-lake-display.sh`
- Aggregator scripts always named `all.sh` in each install subdirectory
- Hardware-specific configs in `install/config/hardware/` subdirectory
- Live in `install/packages/` with `{manager}.packages` naming: `apt.packages`, `cargo.packages`, `pip.packages`, `flatpak.packages`, `ppa.packages`
- One package per line, comments start with `#`, blank lines allowed for grouping
- Theme directories in `themes/{theme-name}/` using kebab-case: `tokyo-night`, `rose-pine`, `matte-black`
- Each theme contains `colors.toml` (required) plus optional overrides: `btop.theme`, `icons.theme`, `keyboard.rgb`, `neovim.lua`, `vscode.json`, `preview.png`, `backgrounds/`
- Live in `default/themed/` with `.tpl` extension: `ghostty.conf.tpl`, `hyprland.conf.tpl`, `waybar.css.tpl`
- User overrides go in `~/.config/omuntu/themed/*.tpl` (with `.sample` suffix for examples)
- `config/` mirrors `~/.config/` structure: `config/hypr/`, `config/waybar/`, `config/ghostty/`
- `default/` contains Omuntu-managed base configs: `default/hypr/`, `default/bash/`, `default/waybar/`
- The split: `config/` is copied to `~/.config/` (user-editable). `default/` stays in `~/.local/share/omuntu/` (sourced/linked by user configs, never edited by users directly).
- UPPER_SNAKE_CASE for exported/global variables: `OMUNTU_PATH`, `OMUNTU_INSTALL`, `CURRENT_THEME_PATH`, `OMUNTU_INSTALL_LOG_FILE`
- lower_snake_case for local variables: `config_file`, `exit_code`, `log_lines`, `browser_exec`
- Boolean flags as lowercase strings: `ERROR_HANDLING=false`, `BACK_TO_EXIT=false`, `PRINT_ONLY=false`, `NO_SUDO=false`
- lower_snake_case for shell functions: `show_main_menu`, `back_to`, `hex_to_rgb`, `catch_errors`
- Menu functions prefixed with `show_`: `show_theme_menu`, `show_install_menu`, `show_setup_menu`
- Helper verbs: `install()`, `install_and_launch()`, `install_font()`, `aur_install()`
## Shebang and Script Structure
- `install/helpers/*.sh` (sourced via `all.sh`)
- `install/preflight/*.sh` (sourced or run via `run_logged`)
- `install/config/*.sh` (run via `run_logged`)
- `install/packaging/*.sh` (run via `run_logged` -- some have shebangs, like `build-elephant.sh`)
#!/bin/bash
#!/bin/bash
## Error Handling
- `command 2>/dev/null || true` -- tolerate failures on optional operations
- `&>/dev/null` -- silence both stdout and stderr for presence checks
- `|| (($? == 127))` -- tolerate "command not found" specifically (used in `bin/omuntu-update`)
- `|| true` at end of loop iterations for non-critical package installs (cargo, flatpak)
- Check before acting: `if command -v elephant &>/dev/null; then echo "already installed"; exit 0; fi`
- Package install with `omuntu-pkg-add` checks if packages are already present via `omuntu-pkg-missing`
- PPA setup uses `|| true` on `apt-get update` because AppStream metadata failures are non-fatal
- Flatpak and cargo installs use `|| true` to continue past individual package failures
## Conditionals and Testing
- `[[ ]]` for string and file tests. Do NOT quote variables inside `[[ ]]`, but DO quote string literals:
- `(( ))` for numeric tests -- NEVER use `[[ $x -lt 5 ]]`:
- Use helper commands in bin scripts: `omuntu-cmd-missing <cmd>` / `omuntu-cmd-present <cmd>`
- Direct check when helpers unavailable: `command -v gum &>/dev/null`
- Pattern: `if ! command -v gum &>/dev/null; then ... fi`
- Use helpers: `omuntu-pkg-missing <pkg>` / `omuntu-pkg-present <pkg>`
- Implementation: `dpkg -l "$pkg" 2>/dev/null | grep -q '^ii'`
- `pgrep -x <process>` for exact match: `pgrep -x hypridle >/dev/null`
- `pgrep -f` for pattern match: `pgrep -f "walker.*--dmenu"`
## Quoting Conventions
- Quote string/path variables with spaces: `"$APP_DIR/Disk Usage.desktop"` (never backslash-escape)
- Do NOT quote variables inside `[[ ]]`: `[[ -z $config_file ]]`
- DO quote `"$@"` when passing arguments: `for cmd in "$@"`
- Quote heredoc delimiters to prevent expansion: `<<'EOF'`
- Unquoted variable references are acceptable in `source` commands within the install flow: `source $OMUNTU_INSTALL/helpers/all.sh`
- In general, quote variables in paths and command arguments: `"$HOME/.config/$config_file"`, `"$OMUNTU_INSTALL_LOG_FILE"`
## Code Style
- 2-space indentation, no tabs
- LF line endings
- UTF-8 charset
- Trim trailing whitespace
- Insert final newline
- Single-line cases with `;;` on same line (most common pattern):
- Multi-line cases with `;;` on separate line:
## Template Patterns
- Use `{{ variable }}` (double-brace, space-padded) placeholders -- NOT Go templates
- Variables come from `themes/{name}/colors.toml` keys
- Three variants per color variable:
- Template processing done by `bin/omuntu-theme-set-templates` using `sed` substitution
- Example from `default/themed/ghostty.conf.tpl`:
- TOML key-value pairs with quoted hex values
- Standard keys: `accent`, `cursor`, `foreground`, `background`, `selection_foreground`, `selection_background`, `color0` through `color15`
- Example from `themes/tokyo-night/colors.toml`:
## Configuration Layering Pattern
- Omuntu ships defaults in `default/` (read-only after install, sourced/linked from user configs)
- User-editable configs live in `config/` (copied to `~/.config/` during install)
- User configs `source` Omuntu defaults first, then apply overrides
- Use `omuntu-refresh-config <relative-path>` to copy a default config to `~/.config/`
- Automatically creates `.bak.{timestamp}` backup of existing file
- Compares old and new, removes backup if identical, shows diff if changed
## Install Flow Conventions
- Each phase directory has an `all.sh` that calls scripts in order
- Scripts that need logging are called via `run_logged $OMUNTU_INSTALL/path/script.sh`
- Scripts that must share shell state use `source` instead of `run_logged`
- `run_logged` runs scripts in a subshell with `DEBIAN_FRONTEND=noninteractive` and output redirected to log file
## Hook and Extension System
- Sample hooks provided with `.sample` suffix: `theme-set.sample`, `post-update.sample`, `battery-low.sample`, `font-set.sample`
- Remove `.sample` to activate
- Known hooks: `post-update`, `theme-set`, `battery-low`, `font-set`
- `~/.config/omuntu/extensions/menu.sh` -- sourced by `bin/omuntu-menu` to allow function overrides
## State Management
- Presence of file means feature is off (e.g., `suspend-off`)
- Check pattern: `[[ -f ~/.local/state/omuntu/toggles/suspend-off ]]`
- One empty file per completed migration (filename matches migration script)
- Skipped migrations tracked in `migrations/skipped/` subdirectory
- `theme/` -- current theme config files (atomic swap via `next-theme/` staging)
- `theme.name` -- plain-text file containing current theme name
- `background` -- current wallpaper image
## Process Launching Conventions
- Always use `uwsm-app --` to launch GUI applications under Hyprland (UWSM session management)
- Use `setsid` for detached processes: `exec setsid uwsm-app -- "$browser_exec" ...`
- Use `xdg-terminal-exec` for terminal launching (respects user's terminal preference)
- Use `omuntu-launch-or-focus` pattern for singleton applications
- Use `omuntu-launch-or-focus-tui` for TUI applications that should run in a terminal
## Interactive UI Conventions
- `gum choose` for selection menus
- `gum confirm` for yes/no prompts
- `gum input` for text input
- `gum style` for styled output with padding/colors
- Tokyo Night theme colors configured in `install/helpers/presentation.sh`
- `omuntu-launch-walker --dmenu` for filtered search menus
- Used in `bin/omuntu-menu` as the primary menu interface
- Red errors: `echo -e "\e[31mError message\e[0m"` or `echo -e "\033[0;31mError\033[0m"`
- Green success: `echo -e "\e[32mSuccess\e[0m"`
## Git Workflow and Commit Conventions
- `dev` is the default branch (not `main`/`master`)
- `stable` branch for release channel
- `boot.sh` defaults to `dev`: `OMUNTU_REF="${OMUNTU_REF:-dev}"`
- Imperative mood verb prefix: `Fix`, `Add`, `Remove`, `Rename`, `Rewrite`, `Ensure`, `Guard`, `Extract`, `Use`
- Descriptive body after colon or parenthetical: `Fix elephant build (missing libsqlite3-dev) and add missing TUI/system packages`
- No conventional commit prefixes (no `feat:`, `fix:`, etc.)
- Lowercase after the verb
- GitHub Issues for validated bugs only (`.github/ISSUE_TEMPLATE/bug.yml`)
- Suggestions and support go to GitHub Discussions (`.github/ISSUE_TEMPLATE/config.yml`)
- Migrations named after unix timestamp of last commit: `{unix_timestamp}.sh`
- Created via `bin/omuntu-dev-add-migration --no-edit`
- Migration scripts have no shebang, start with `echo` describing the migration
## Comment and Documentation Style
- One-line description after shebang, preceded by blank line:
- Explain "why", not "what": `# apt-get update exits non-zero if any index file fails`
- Use for non-obvious behavior: `# Truncate long command lines to fit the display`
- Simple: `echo "Usage: omuntu-foo <arg>"` followed by `exit 1`
- Complex: heredoc for multi-line usage
- Section headers: `# Build tools (needed for source builds: SwayOSD, Walker)`
- Inline explanations: `# rustc and cargo installed via rustup (Ubuntu's 1.75 is too old for SwayOSD)`
## Import / Source Organization
## Platform Handling
- Ubuntu 24.04+ via `/etc/os-release`
- Non-root via `(( EUID == 0 ))`
- x86_64 via `uname -m`
- Uses `gum confirm` to allow override (soft failure)
- Used as conditionals: `if omuntu-hw-asus-rog; then ... fi`
- `OMUNTU_ONLINE_INSTALL` env var set by `boot.sh` for curl-based installations
- Controls retry availability in error handler
- `OMUNTU_CHROOT_INSTALL` env var enables chroot mode
- `chrootable_systemctl_enable` uses `enable` without `--now` in chroot
## Logging
- `run_logged` wraps script execution with timestamped log entries to `$OMUNTU_INSTALL_LOG_FILE` (`/var/log/omuntu-install.log`)
- Log format: `[YYYY-MM-DD HH:MM:SS] Starting: $script` / `Completed: $script` / `Failed: $script (exit code: N)`
- Real-time log display via background process that tails the log file with gray ANSI formatting
- Install timing tracked with start/end timestamps and duration calculation
<!-- GSD:conventions-end -->

<!-- GSD:architecture-start source:ARCHITECTURE.md -->
## Architecture

## Pattern Overview
- Pure Bash -- no templating engine beyond `sed` for theme variable substitution
- File-copy-based config management (`config/` -> `~/.config/`, `default/` sourced in place)
- Convention-over-configuration CLI with prefixed command names (`omuntu-cmd-*`, `omuntu-pkg-*`, etc.)
- Hyprland desktop session manager (Wayland compositor) with UWSM session integration
- Theme system using `{{ variable }}` placeholder substitution in `.tpl` template files
- Two-layer config: managed defaults (read-only at `~/.local/share/omuntu/default/`) and user configs (mutable at `~/.config/`)
## Layers
- Purpose: User-facing commands and internal helpers, all prefixed `omuntu-`
- Location: `bin/`
- Contains: 198 executable Bash scripts
- Depends on: System packages (gum, walker, hyprctl, etc.), each other
- Used by: User shell, Hyprland keybindings, waybar modules, the installer, the menu
- Added to PATH via `$OMUNTU_PATH/bin` in `config/uwsm/env`, `default/bash/envs`, and `install.sh`
- Purpose: Orchestrate fresh system setup from bare Ubuntu to full desktop
- Location: `install/`
- Contains: Shell scripts organized by install phase, plus package list files
- Depends on: `bin/` commands, `config/`, `default/`, `install/packages/`
- Used by: `install.sh` (entry point), `boot.sh` (curl-to-shell bootstrap)
- Purpose: Default dotfiles that get **copied** to `~/.config/` on install
- Location: `config/`
- Contains: App config files for hypr, waybar, walker, ghostty, kitty, alacritty, tmux, git, btop, omuntu extensions, etc.
- Depends on: Managed defaults (Hyprland configs source from `~/.local/share/omuntu/default/`)
- Used by: Installer (`install/config/config.sh` copies them), `omuntu-refresh-config`, `omuntu-reinstall-configs`
- Key distinction: After copying, these become the user's own files to edit freely
- Purpose: Reference configs **sourced at runtime** (not copied), plus theme templates
- Location: `default/`
- Contains: Bash shell setup, Hyprland base configs, theme `.tpl` templates, system-level defaults (systemd, udev, plymouth, sddm)
- Depends on: Nothing (static files)
- Used by: User's `~/.bashrc` sources `default/bash/rc`; Hyprland `source =` directives reference `default/hypr/` files
- Purpose: Color theme definitions and template-based config generation
- Location: `themes/` (17 color scheme directories), `default/themed/` (14 `.tpl` templates)
- Contains: `colors.toml` per theme, `.tpl` template files, theme-specific overrides (btop, vscode, neovim, keyboard RGB, icons)
- Depends on: `bin/omuntu-theme-set-templates` for sed-based substitution
- Used by: `omuntu-theme-set`, which triggers component restarts after applying
- Purpose: Desktop entry files and icons for app launcher integration
- Location: `applications/`
- Contains: Custom `.desktop` files, 19 webapp icon PNGs, 31 hidden desktop entries (to suppress unwanted apps from launcher)
- Depends on: Nothing
- Used by: Installer copies into `~/.local/share/applications/`
## Data Flow
- Persistent state stored in `~/.local/state/omuntu/` as empty marker files
- `omuntu-state set <name>` creates a marker, `omuntu-state clear <name>` removes it (supports glob patterns)
- Used to track: first-run completion, feature toggles (suspend, idle, screensaver, notifications)
- Migration state tracked in `~/.local/state/omuntu/migrations/` (one empty file per completed migration)
- Skipped/failed migrations tracked separately in `~/.local/state/omuntu/migrations/skipped/`
- Current theme stored in `~/.config/omuntu/current/theme.name`
- Current background symlinked at `~/.config/omuntu/current/background`
## Key Abstractions
- Purpose: Execute installer scripts in isolated subshells with full logging
- Defined in: `install/helpers/logging.sh`
- Pattern: `DEBIAN_FRONTEND=noninteractive bash -c "source '$script'" </dev/null >>$LOG 2>&1`
- Tracks `CURRENT_SCRIPT` for error reporting
- Returns the script's exit code for error propagation
- Used throughout all installer phases (preflight, packaging, config, login, post-install)
- Purpose: Unified package management interface hiding apt/dpkg details
- `bin/omuntu-pkg-add` -- installs missing packages via `apt-get install -y`, verifies with `dpkg -l`
- `bin/omuntu-pkg-missing` / `bin/omuntu-pkg-present` -- check dpkg status
- `bin/omuntu-pkg-drop` / `bin/omuntu-pkg-remove` -- remove packages
- `bin/omuntu-pkg-install` -- interactive TUI for picking new packages via fzf with apt-cache preview
- `bin/omuntu-pkg-aur-add` / `bin/omuntu-pkg-aur-install` -- Flatpak-based alternative installs (named "aur" for compatibility with upstream omarchy)
- Purpose: Return exit codes indicating hardware presence (for use in `if` conditionals)
- Examples: `bin/omuntu-hw-asus-rog`, `bin/omuntu-hw-framework16`, `bin/omuntu-hw-surface`
- Pattern: Exit code 0 = hardware present, non-zero = absent
- Used in installer: `if omuntu-hw-asus-rog; then omuntu-pkg-add asusctl; fi`
- Purpose: Generate app-specific theme configs from a shared color palette
- Orchestrator: `bin/omuntu-theme-set-templates`
- Templates: `default/themed/*.tpl` (14 files)
- Input: `themes/<name>/colors.toml` (key-value pairs: accent, background, foreground, color0-15, etc.)
- Substitution variants: `{{ key }}` (raw), `{{ key_strip }}` (strip leading `#`), `{{ key_rgb }}` (hex to `R,G,B`)
- User can add custom templates in `~/.config/omuntu/themed/*.tpl`
- Purpose: Allow users to run custom scripts at defined extension points
- Runner: `bin/omuntu-hook`
- Pattern: If `~/.config/omuntu/hooks/<name>` exists, execute it with arguments
- Available hooks: `post-update`, `theme-set`, `font-set`, `battery-low`
- Samples provided in `config/omuntu/hooks/*.sample`
- Purpose: Allow users to add/override menu items
- Location: `config/omuntu/extensions/menu.sh`
- Pattern: Sources user-defined bash functions that override or extend the Walker dmenu
- Purpose: Copy a default config to user config with automatic backup and diff reporting
- Location: `bin/omuntu-refresh-config`
- Pattern: `omuntu-refresh-config hypr/hyprlock.conf` copies `config/hypr/hyprlock.conf` -> `~/.config/hypr/hyprlock.conf`
- Purpose: Persist feature toggle states as empty marker files
- Location: `bin/omuntu-state`
- Pattern: `omuntu-state set suspend.disabled` / `omuntu-state clear suspend.*`
- Purpose: Adapt systemctl calls for chroot-based installs (e.g., ISO building)
- Location: `install/helpers/chroot.sh`
- Pattern: Uses `enable` in chroot mode vs `enable --now` in normal mode
- Activated by setting `OMUNTU_CHROOT_INSTALL=1`
## Entry Points
- Location: `boot.sh`
- Triggers: `curl -fsSL https://raw.githubusercontent.com/hvpaiva/omuntu/dev/boot.sh | bash`
- Responsibilities: Set `OMUNTU_ONLINE_INSTALL=true`, install git/curl, clone repo to `~/.local/share/omuntu/`, source `install.sh`
- Supports custom repo (`OMUNTU_REPO`) and branch (`OMUNTU_REF`) via environment variables
- Location: `install.sh`
- Triggers: Called by `boot.sh` or directly from a local clone
- Responsibilities: Set `OMUNTU_PATH`, `OMUNTU_INSTALL`, add `bin/` to PATH, source all 6 install phases in order
- Location: `bin/omuntu-cmd-first-run`
- Triggers: Hyprland autostart (via `default/hypr/autostart.conf` -> `exec-once = omuntu-cmd-first-run`)
- Responsibilities: Complete setup steps that require a running desktop session; runs only once (removes marker file)
- Location: `bin/omuntu-update`
- Triggers: User invocation from terminal or omuntu-menu
- Responsibilities: Pull repo updates via git, run system package updates, run pending migrations, execute hooks
- Location: `bin/omuntu-menu` (627 lines, largest script)
- Triggers: Hyprland keybinding or direct invocation
- Responsibilities: Walker-based dmenu providing access to all system functions (theme, settings, installs, hardware, etc.)
- Location: Session files created by `install/login/session.sh` at `/usr/share/wayland-sessions/`
- Triggers: SDDM login screen
- Responsibilities: Launch Hyprland via UWSM, set Wayland environment variables
## Error Handling
- `set -eEo pipefail` at top of `install.sh` propagates failures
- Global `ERR`/`INT`/`TERM` traps defined in `install/helpers/errors.sh`
- Trap handler: stops log output, restores terminal outputs, shows cursor, clears screen
- Displays: logo, "installation stopped" message, truncated log tail, failed script path, exit code
- Offers interactive menu via `gum choose`: Retry installation (online mode only), Report issue, View full log, Exit
- Saves and restores stdout/stderr file descriptors (FD 3/4) so trap output goes to screen even when logging redirects
- Prevents recursive error handling via `ERROR_HANDLING` flag
- Individual packaging scripts use `|| true` for non-critical failures (flatpak installs, cargo installs)
- `omuntu-pkg-add` verifies each package installed successfully with `dpkg -l` after `apt-get install` and exits 1 on failure
- apt-get update failures are tolerated (`|| true`) because metadata index errors are common on Ubuntu
- Failed migrations prompt "Skip and continue?" via `gum confirm`
- Skipped migrations tracked in `~/.local/state/omuntu/migrations/skipped/` (won't be retried)
- Individual bin scripts use `set -e` selectively
- Hardware detection scripts use exit codes as booleans -- callers use `if` guards
- Most runtime scripts fail with simple error messages or `notify-send`
## Cross-Cutting Concerns
- Install: All output captured to `/var/log/omuntu-install.log` via `run_logged` with timestamps per script start/end
- Live display: Background process in `logging.sh` tails log file every 0.1s, renders last 20 lines in gray below the logo
- Update: Output captured to `/tmp/omuntu-update.log` via `tee`
- Debug: `omuntu-debug` collects inxi, dmesg, journalctl, installed packages for bug reporting
- `omuntu-upload-log` uploads install log for remote support
- `$OMUNTU_PATH/bin` added to PATH in 3 places:
- Additional PATH entries: `~/.cargo/bin` (via rustup), mise shims (`~/.local/share/mise/shims`)
- `gum` (Charm TUI toolkit) used for prompts, confirmations, styled output, choose menus
- Gum styling configured with Tokyo Night theme colors in `install/helpers/presentation.sh`
- Padding dynamically calculated to center content based on terminal width
- ASCII art logo from `logo.txt` centered during install
- `tte` (terminaltexteffects) used for post-install completion animation
- `walker --dmenu` used as the primary menu/launcher interface in `omuntu-menu`
- UWSM (Universal Wayland Session Manager) manages Hyprland compositor
- SDDM display manager pre-configured to launch `hyprland-uwsm.desktop` via `/var/lib/sddm/state.conf`
- Environment variables set in `config/environment.d/` (Wayland session vars) and `config/uwsm/env` (OMUNTU_PATH, editor, terminal)
- `uwsm-app` prefix used for all autostart processes in `default/hypr/autostart.conf`
- Temporary NOPASSWD sudo via `/etc/sudoers.d/99-omuntu-installer` during install (removed in `post-install/finished.sh`)
- First-run sudoers in `/etc/sudoers.d/first-run` with limited command scope (removed after first login)
- No secrets or credentials stored in the repository
- `DEBIAN_FRONTEND=noninteractive` prevents interactive prompts during package installation
- User hooks in `~/.config/omuntu/hooks/` (samples provided at install)
- Menu extensions via `~/.config/omuntu/extensions/menu.sh` (function overrides)
- User theme overrides in `~/.config/omuntu/themes/<name>/`
- User template overrides in `~/.config/omuntu/themed/*.tpl`
- All Hyprland config files support user overrides (sourced after defaults in `config/hypr/hyprland.conf`)
- User's `~/.bashrc` sources managed defaults first, then allows custom additions
<!-- GSD:architecture-end -->

<!-- GSD:workflow-start source:GSD defaults -->
## GSD Workflow Enforcement

Before using Edit, Write, or other file-changing tools, start work through a GSD command so planning artifacts and execution context stay in sync.

Use these entry points:
- `/gsd:quick` for small fixes, doc updates, and ad-hoc tasks
- `/gsd:debug` for investigation and bug fixing
- `/gsd:execute-phase` for planned phase work

Do not make direct repo edits outside a GSD workflow unless the user explicitly asks to bypass it.
<!-- GSD:workflow-end -->



<!-- GSD:profile-start -->
## Developer Profile

> Profile not yet configured. Run `/gsd:profile-user` to generate your developer profile.
> This section is managed by `generate-claude-profile` -- do not edit manually.
<!-- GSD:profile-end -->
