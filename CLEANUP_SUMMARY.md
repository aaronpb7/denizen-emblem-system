# V1 to V2 Cleanup Summary

## ✅ What Was Done

### 1. Old V1 Files Deleted

**Removed folder:** `scripts/emblems/`

**Deleted files:**
- `scripts/emblems/emblem_items.dsc` ❌
- `scripts/emblems/emblem_guis.dsc` ❌
- `scripts/emblems/emblem_events.dsc` ❌
- `scripts/emblems/emblem_admin.dsc` ❌
- `scripts/emblems/emblem_recipes.dsc` ❌
- `scripts/emblems/promachos_npc.dsc` ❌

### 2. V2 Renamed to Current

**Old path:** `scripts/emblems_v2/` ❌
**New path:** `scripts/emblems/` ✅

This is now the official emblem system (no more "V2" designation).

### 3. Auto-Cleanup Script Added

**New file:** `scripts/emblems/admin/v1_cleanup_on_join.dsc` ✅

**What it does:**
- Automatically wipes all old V1 emblem flags when players join
- Shows message: "Your emblem progress has been reset for the new system"
- Marks each player as cleaned (won't run twice)
- Self-disables after all players are cleaned

**Commands added:**
- `/v1cleanup <player>` - Manually wipe V1 flags for a player
- `/v1cleanupcomplete` - Mark cleanup complete server-wide (disables auto-wipe)

---

## 📁 Current File Structure

```
scripts/
├── profile_gui.dsc                    # UPDATED for new system
├── bulletin.dsc                       # Unchanged
├── server_restrictions.dsc            # Unchanged
└── emblems/                           # ✨ NEW (renamed from emblems_v2)
    ├── core/
    │   ├── roles.dsc
    │   └── promachos_v2.dsc
    ├── demeter/
    │   ├── demeter_items.dsc
    │   ├── demeter_events.dsc
    │   ├── demeter_crate.dsc
    │   └── demeter_blessing.dsc
    ├── ceres/
    │   ├── ceres_items.dsc
    │   ├── ceres_crate.dsc
    │   └── ceres_mechanics.dsc
    └── admin/
        ├── admin_commands_v2.dsc
        └── v1_cleanup_on_join.dsc      # ✨ NEW (auto flag wipe)

docs/                                   # All documentation
├── overview.md
├── promachos.md
├── demeter.md
├── crates_demeter.md
├── ceres.md
├── flags.md
├── testing.md
└── migration.md

QUICK_START.md                          # ✨ NEW (deployment guide)
CLEANUP_SUMMARY.md                      # ✨ NEW (this file)
DEPLOYMENT_CHECKLIST.md                 # Deployment steps
IMPLEMENTATION_SUMMARY.md               # Technical overview
EMBLEM_V2_README.md                     # Player guide
```

---

## 🗑️ Old V1 Flags (Will Be Auto-Wiped)

These flags will be removed when players join:

```
emblem.hephaestus.stage1.progress
emblem.hephaestus.stage1.claimed
emblem.hephaestus.stage2.progress
emblem.hephaestus.stage2.claimed
emblem.hephaestus.stage3.progress
emblem.hephaestus.stage3.claimed
emblem.hephaestus.stage4.progress
emblem.hephaestus.stage4.claimed
emblem.hephaestus.stage5.progress
emblem.hephaestus.stage5.claimed
emblem.hephaestus.stage5.completed

emblem.demeter.stage1.progress
emblem.demeter.stage1.claimed
... (same pattern for stages 2-5)

emblem.heracles.stage1.progress
emblem.heracles.stage1.claimed
... (same pattern for stages 2-5)
```

**All flags under the `emblem.*` namespace are wiped.**

**Preserved:**
- `met_promachos` - Reused in new system

---

## 🚀 How Auto-Cleanup Works

### On Player Join

1. Player joins server
2. Check if server-wide cleanup marked complete → If yes, stop
3. Check if player already cleaned → If yes, stop
4. Wait 2 seconds (for full load)
5. Run: `flag player emblem:!` (wipes all old emblem flags)
6. Mark player as cleaned: `flag player v1.cleanup_done:true`
7. Show message to player
8. Log to console

### After All Players Migrated

Once all your players have joined at least once, run:
```
/v1cleanupcomplete
```

This sets a server flag that disables future auto-cleanup (no need to run checks anymore).

---

## 🛠️ Manual Cleanup Commands

### Wipe a Specific Player
```
/v1cleanup <player>
```
Manually removes all V1 emblem flags from that player.

### Mark Cleanup Complete
```
/v1cleanupcomplete
```
Tells the system all players are cleaned, disables auto-wipe on join.

### Re-Enable Auto-Cleanup (If Needed)
```
/ex flag server v1.cleanup_complete:!
```
Removes the "complete" flag, re-enables auto-cleanup for new players.

---

## ✅ Deployment Steps

### 1. Before Server Start
- ✅ Old V1 files deleted
- ✅ V2 renamed to `emblems`
- ✅ Auto-cleanup script in place

### 2. Start Server
```bash
./start.sh
```

Check console for:
- All scripts loading successfully
- No errors related to missing files
- `v1_cleanup_on_join.dsc` loaded

### 3. First Player Joins
- Player sees: "Your emblem progress has been reset for the new system"
- Console shows: "V1 flags wiped for player: <name>"
- Player's old flags are gone

### 4. After All Players Joined (Within 1-2 Weeks)
```
/v1cleanupcomplete
```
Disables auto-cleanup. System is fully migrated!

---

## 🔍 Verification

### Check Old Folder Gone
```bash
ls scripts/
```
Should NOT see `emblems_v2` or old `emblems` (from backup)
Should ONLY see new `emblems/`

### Check Auto-Cleanup Loaded
```
/denizen scripts
```
Look for: `v1_cleanup_on_join`

### Check Player Flags After Join
```
/ex narrate <player.flag[emblem]>
```
Should return: `null` (no old flags)

### Check New Flags Present
```
/ex narrate <player.flag[role.active]>
```
Should return: `FARMING` or `MINING` or `COMBAT` (if player chose a role)

---

## 📊 Migration Timeline

**Week 0 (Deployment Day)**:
- Old files deleted
- New system active
- Auto-cleanup running
- 0-20% of players migrated (as they join)

**Week 1**:
- Most active players migrated
- 50-80% of players migrated

**Week 2**:
- Nearly all players migrated
- 90-100% of players migrated
- Run `/v1cleanupcomplete` to close migration

**Week 3+**:
- Fully migrated
- Auto-cleanup disabled
- New players start fresh automatically

---

## 🆘 Troubleshooting

### Issue: Auto-cleanup not running
**Check:**
1. Script loaded: `/denizen scripts` → look for `v1_cleanup_on_join`
2. Server flag: `/ex narrate <server.flag[v1.cleanup_complete]>` → should be null or false
3. Player flag: `/ex narrate <player.flag[v1.cleanup_done]>` → should be null

**Fix:**
- Manually run: `/v1cleanup <player>`

### Issue: Player still has old flags after joining
**Check:**
- Wait 2 seconds after join (script has 2s delay)
- Check console for errors
- Manually verify: `/ex narrate <player.flag[emblem]>`

**Fix:**
- Run: `/v1cleanup <player>`

### Issue: Old emblem items still in inventory
**Note:** The cleanup script only removes FLAGS, not items.

**Fix (optional):**
- Let players keep old items as collectibles (they won't function)
- OR manually remove via `/clear <player> <item>` if needed

### Issue: Accidentally marked cleanup complete too early
**Fix:**
```
/ex flag server v1.cleanup_complete:!
```
This re-enables auto-cleanup for players who haven't joined yet.

---

## 📝 Notes

**Old Items:**
- Old emblem items (if physical) will remain in player inventories
- They won't function in the new system
- Consider them collectibles/legacy items
- Don't cause harm (players can drop/destroy them)

**Old NPCs:**
- If you had a Promachos NPC from V1, update its assignment:
  ```
  /npc sel 0
  /npc assignment --set promachos_assignment
  ```

**Old Trades:**
- Any old trading systems are disabled (files deleted)
- New system doesn't use trading (keys are the reward mechanism)

**Old GUIs:**
- Old emblem selection/progress GUIs are deleted
- New system uses Promachos menus and `/profile`

---

## ✨ What Players See

### First Join After Migration

```
[Server] Welcome! Your emblem progress has been reset for the new system.
[Server] Speak to Promachos to begin your journey!
```

### When They Ask "Where Are My Emblems?"

**Response:**
> The emblem system has been completely reworked! The old stage-based system has been replaced with a new role-based system with frequent rewards. Everyone starts fresh. Visit **Promachos** to choose your role and begin earning keys and unlocking new emblems!

### When They Ask "Can I Get My Progress Back?"

**Response:**
> Unfortunately, the new system is completely different and incompatible with the old one. Everyone starts fresh to keep things fair. The new system is more rewarding with frequent crate keys instead of long grinds!

---

## 🎉 Migration Complete!

Once you run `/v1cleanupcomplete`, the migration is officially done.

The old V1 system is completely removed and the new emblem system is the only version going forward.

**No more references to "V2"** - it's just **"the emblem system"** now!

---

**Summary:**
- ✅ Old files deleted
- ✅ V2 renamed to current
- ✅ Auto-cleanup script active
- ✅ Ready to deploy!

Refer to `QUICK_START.md` for deployment steps.
