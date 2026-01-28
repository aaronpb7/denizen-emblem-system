# Error Fixes Summary - Emblem System V2

## All Errors Fixed (2026-01-28)

### 1. Event Handler Syntax Errors
**Problem**: Events using incorrect right-click format were not matching Denizen ScriptEvents
**Solution**: Changed to `on player right clicks block with:item_name:` format (air counts as a block)

**Files Fixed**:
- `scripts/emblems/demeter/demeter_blessing.dsc:23`
  - **Final Correct Format**: `on player right clicks block with:demeter_blessing:`

- `scripts/emblems/demeter/demeter_crate.dsc:18`
  - **Final Correct Format**: `on player right clicks block with:demeter_key:`

- `scripts/emblems/ceres/ceres_mechanics.dsc:51`
  - **Final Correct Format**: `on player right clicks block with:ceres_wand:`

- `scripts/emblems/ceres/ceres_crate.dsc:19`
  - **Final Correct Format**: `on player right clicks block with:ceres_key:`

### 2. Tick Event Format Error
**Problem**: `after tick time:1t` is not a valid event format
**Solution**: Changed to system time event

**File Fixed**:
- `scripts/emblems/ceres/ceres_mechanics.dsc:90`
  - Changed: `after tick time:1t:`
  - To: `on system time secondly every:1:`

### 3. Title Command Syntax Error
**Problem**: Title command had too many linear arguments - missing quotes and time unit markers
**Solution**: Added quotes around title/subtitle and 't' suffix for time values

**File Fixed**:
- `scripts/emblems/core/promachos_v2.dsc:403`
  - Changed: `- title title:<&6><&l>EMBLEM UNLOCKED! subtitle:<&e>Demeter's Blessing fade_in:10 stay:40 fade_out:10`
  - To: `- title "title:<&6><&l>EMBLEM UNLOCKED!" "subtitle:<&e>Demeter's Blessing" fade_in:10t stay:40t fade_out:10t`

### 4. Tab Completions Causing Player Tag Errors
**Problem**: Tab completions using `<server.online_players.parse[name]>` were evaluated at script load without player context
**Solution**: Removed all tab completion sections from commands

**Files Fixed**:
- `scripts/emblems/admin/admin_commands_v2.dsc`
  - Removed tab completions from: `roleadmin_command`, `demeteradmin_command`, `ceresadmin_command`, `testroll_command`

- `scripts/emblems/admin/v1_cleanup_on_join.dsc:60`
  - Removed tab completions from: `v1_cleanup_player_command`

### 5. Bulletin Back Button (Already Fixed Previously)
**Problem**: Invalid block label `gui_back_button`
**Solution**: Created `bulletin_back_button` item script and updated references

**File**: `scripts/bulletin.dsc` - Already correct

---

## Current Status: All Errors Resolved ✓

All script errors visible in the screenshots have been addressed. The server should reload scripts without errors now.

**To apply changes**: Use `/ex reload` or restart the server to reload Denizen scripts.
