# Claude Code Rainmeter Widget

## Project Summary
A Rainmeter desktop widget for Claude Code that displays:
- Slash commands reference
- Capabilities reference
- Quick launch buttons for projects (with model selector)
- Usage limits with live API data

## Current State
Widget is fully functional with:
- 3 themes: Dark, Light, Neon (cycle with theme button)
- Collapsible sections
- Model selector (Default/Opus/Sonnet/Haiku)
- Usage data auto-refreshes every 60 seconds
- Manual sync button still available

## Recent Changes
- Added auto-refresh timer (`MeasureAutoRefresh`) that triggers usage fetch every 60 seconds
- Usage now updates automatically without pressing Sync

## Files
- `ClaudeCode.ini` - Main widget config
- `ThemeManager.lua` - Theme switching logic
- `UsageManager.lua` - Parses usage data and updates variables
- `FetchUsage.ps1` - PowerShell script to fetch usage from Claude API
- `usage_cache.txt` - Cached usage data from API

## Notes
- Right-click widget to refresh/reload
- Theme button in header cycles through themes
- Model selector affects which model launches with projects
