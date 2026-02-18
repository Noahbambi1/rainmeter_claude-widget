# Claude Code Rainmeter Widget

A Rainmeter desktop widget that provides a quick-reference dashboard and launcher for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Features live API usage tracking, project quick-launch buttons with model selection, and three switchable themes.

## Features

- **Three themes** -- Dark, Light, and Neon (cyberpunk) -- cycled with a single click
- **Collapsible sections** -- each card collapses to a slim header bar to save space
- **Slash commands reference** -- at-a-glance list of common Claude Code commands
- **Capabilities reference** -- summary of available Claude Code tools
- **Quick Launch** -- one-click buttons that open a terminal in a project directory and start `claude`
- **Model selector** -- choose Default, Opus, Sonnet, or Haiku before launching
- **Live usage limits** -- progress bars for current-session (5-hour) and rolling 7-day utilization, auto-refreshed every 60 seconds
- **Desktop icons toggle** -- footer button to show/hide Windows desktop icons without restarting Explorer

## Prerequisites

| Requirement | Notes |
|-------------|-------|
| [Rainmeter](https://www.rainmeter.net/) 4.5+ | Desktop customization engine |
| Windows PowerShell 5.1+ | Ships with Windows 10/11 |
| [Claude Code](https://docs.anthropic.com/en/docs/claude-code) subscription | Max or Pro plan for usage API access |
| **Fonts**: Bahnschrift, JetBrains Mono | Bahnschrift ships with Windows 10+; install [JetBrains Mono](https://www.jetbrains.com/lp/mono/) separately |

## Installation

1. Copy or clone the `claude` folder into your Rainmeter Skins directory:
   ```
   %USERPROFILE%\Documents\Rainmeter\Skins\claude\
   ```
2. In Rainmeter, right-click the tray icon and choose **Refresh All**.
3. Navigate to **claude > ClaudeCode.ini** and load the skin.

## Configuration

### API Credentials

Usage tracking requires OAuth credentials stored at:

```
%USERPROFILE%\.claude\.credentials.json
```

These are created automatically when you authenticate with Claude Code. No manual setup is needed if you are already signed in.

### Quick Launch Projects

Edit the `[LaunchProject*]` meters in `ClaudeCode.ini` to point to your own project directories. Each button runs:

```
cmd /c "cd /d <path> && claude <model-flag>"
```

### Model Selector

Click the model selector in the Quick Launch section to cycle through:

| Option | Flag |
|--------|------|
| Default | *(none)* |
| Opus | `--model claude-opus-4-5-20251101` |
| Sonnet | `--model claude-sonnet-4-20250514` |
| Haiku | `--model claude-haiku-4-5-20250514` |

## Themes

The widget ships with three built-in themes. Press the palette button in the header to cycle through them.

| Theme | Style |
|-------|-------|
| **Dark** | Deep navy backgrounds, white text, vibrant accents |
| **Light** | Near-white backgrounds, dark text, muted accents |
| **Neon** | Near-black with purple hue, electric magenta/cyan/green accents |

See [THEME_GUIDE.txt](THEME_GUIDE.txt) for details on the 15-variable color system and how to create custom themes.

## File Structure

| File | Description |
|------|-------------|
| `ClaudeCode.ini` | Main Rainmeter skin configuration |
| `ThemeManager.lua` | Lua script that cycles themes and applies color variables |
| `UsageManager.lua` | Lua script that parses cached usage JSON and updates meters |
| `FetchUsage.ps1` | PowerShell script that calls the Anthropic usage API and writes `~/.claude/usage-cache.json` |
| `ToggleDesktopIcons.ps1` | PowerShell script that toggles Windows desktop icon visibility via Win32 API |
| `THEME_GUIDE.txt` | Documentation for the theme color system |
| `CLAUDE.md` | Project notes for Claude Code context |
| `Test.ini` | Stub/template skin file |

## Usage Tips

- **Right-click** anywhere on the widget to refresh/reload the skin.
- **Collapse sections** you don't need to keep the widget compact.
- The **Sync** button in the Usage section triggers an immediate data refresh (otherwise data refreshes every 60 seconds).
- Usage bars show percentage utilization for the current 5-hour window, 7-day all-models window, and 7-day Sonnet-only window.

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Usage bars show 0% | Ensure you are signed in to Claude Code (`claude` in a terminal) and `~/.claude/.credentials.json` exists |
| Font rendering looks wrong | Install [JetBrains Mono](https://www.jetbrains.com/lp/mono/) and refresh the skin |
| Quick launch opens wrong directory | Edit the project paths in the `[LaunchProject*]` meters inside `ClaudeCode.ini` |
| Theme button not responding | Right-click the widget to force a reload |
