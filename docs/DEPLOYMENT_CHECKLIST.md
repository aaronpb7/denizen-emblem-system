# Emblem System - Deployment Checklist

## Pre-Deployment (1-2 Weeks Before)

### ☐ Backup Everything
```bash
# Backup legacy scripts
cp -r scripts/emblems scripts/emblems_legacy_backup
cp scripts/profile_gui.dsc scripts/profile_gui_legacy_backup.dsc

# Backup player data
cp -r plugins/Denizen/saves plugins/Denizen/saves_legacy_backup
```

### ☐ Test on Staging Server
1. Copy all current files to staging server
2. Run through full test checklist (`docs/testing.md`)
3. Verify no errors in console
4. Test with 2-3 players concurrently
5. Confirm performance (TPS > 19.5)

### ☐ Announce to Players (Minimum 1 Week Notice)
**Bulletin Update**:
- Increment version in `scripts/bulletin.dsc`
- Add current announcement entry

**Discord/Forum Post**:
```
📢 Emblem System - Coming [DATE]

We're completely reworking the emblem system!

NEW:
✅ Choose a role (Farming/Mining/Combat)
✅ Frequent key drops & crate rewards
✅ No more stage gates
✅ Rare Ceres meta-progression

RESET:
❌ All emblem progress will be wiped
❌ Everyone starts fresh

COMPENSATION:
🎁 10 Demeter Keys for all players with legacy progress

Learn more: [link to EMBLEM_V2_README.md]
```

### ☐ Prepare Admin Team
- Brief all admins/mods on current mechanics
- Share `docs/testing.md` and `EMBLEM_V2_README.md`
- Assign roles: who monitors console, who answers questions, who tests

---

## Deployment Day

### Phase 1: Server Shutdown (5 minutes)

```bash
# Give players warning
say Server restarting in 5 minutes for Emblem System!
say All emblem progress will reset. You'll receive 10 Demeter Keys as compensation.

# Wait 3 minutes
say Server restarting in 2 minutes!

# Wait 1 minute
say Server restarting in 1 minute!

# Wait 1 minute
say Server restarting NOW!
stop
```

---

### Phase 2: Delete legacy Files

```bash
cd /path/to/server/plugins/Denizen/scripts

# Remove old emblems folder
rm -rf emblems/

# Keep these files (unchanged):
# - profile_gui.dsc (will be replaced with updated version)
# - bulletin.dsc
# - server_restrictions.dsc
```

---

### Phase 3: Deploy current Files

```bash
# Create current directory structure
mkdir -p emblems/core
mkdir -p emblems/demeter
mkdir -p emblems/ceres
mkdir -p emblems/admin

# Copy all current scripts
# (Upload via FTP, SFTP, or copy from local backup)

# Verify file count:
find emblems -name "*.dsc" | wc -l
# Should return: 11 files
```

**Files to upload**:
```
emblems/core/roles.dsc
emblems/core/promachos.dsc
emblems/demeter/demeter_items.dsc
emblems/demeter/demeter_events.dsc
emblems/demeter/demeter_crate.dsc
emblems/demeter/demeter_blessing.dsc
emblems/ceres/ceres_items.dsc
emblems/ceres/ceres_crate.dsc
emblems/ceres/ceres_mechanics.dsc
emblems/admin/admin_commands.dsc
```

---

### Phase 4: Replace Updated Files

```bash
# Replace profile_gui.dsc with current version
cp profile_gui_v2.dsc profile_gui.dsc

# Update bulletin.dsc (increment version, add current announcement)
# Edit manually or use updated file
```

---

### Phase 4.5: **CRITICAL** - Remove OP-Only Testing Gate

**⚠️ REQUIRED FOR PRODUCTION DEPLOYMENT ⚠️**

The Promachos NPC interaction currently has an OP-only gate for testing purposes. **This MUST be removed before players can use the system.**

**File:** `scripts/emblems/core/promachos.dsc`

**Lines to Remove (33-36):**
```yaml
# Temporary OP-only restriction
- if !<player.is_op>:
    - narrate "<&e>Emblem system coming soon!"
    - stop
```

**How to Remove:**
1. Open `scripts/emblems/core/promachos.dsc`
2. Navigate to the `promachos_interact` script (line ~27)
3. Delete lines 33-36 (the OP check block)
4. Save file
5. Run `/denizen reload` on server

**Before (Testing):**
```yaml
promachos_interact:
    type: interact
    steps:
        1:
            click trigger:
                script:
                # Temporary OP-only restriction
                - if !<player.is_op>:
                    - narrate "<&e>Emblem system coming soon!"
                    - stop

                - if !<player.has_flag[met_promachos]>:
                    - run promachos_first_meeting
                - else:
                    - inventory open d:promachos_main_menu
```

**After (Production):**
```yaml
promachos_interact:
    type: interact
    steps:
        1:
            click trigger:
                script:
                - if !<player.has_flag[met_promachos]>:
                    - run promachos_first_meeting
                - else:
                    - inventory open d:promachos_main_menu
```

**Verification:**
1. As a non-OP player, right-click Promachos NPC
2. Should see first-time dialogue or main menu
3. Should NOT see "Emblem system coming soon!" message

---

### Phase 5: Optional - Create legacy Flag Cleanup Script

**Only if you want automatic flag cleanup on server start**:

Create `emblems/admin/legacy_flag_cleanup.dsc`:
```yaml
legacy_flag_cleanup:
    type: world
    debug: false
    events:
        after server start:
        - announce "<&e>[System]<&r> Cleaning up legacy emblem flags..."
        - foreach <server.online_players>:
            # Remove all old emblem flags
            - flag <[value]> emblem:!
        - announce "<&e>[System]<&r> Cleanup complete!"
```

**OR** manually wipe flags later via command:
```
/ex flag <player> emblem:!
```

---

### Phase 6: Update Promachos NPC

**Option A: Update Existing NPC**:
```
/npc sel 0
/npc assignment --set promachos_assignment
```

**Option B: Create New NPC** (if old one doesn't exist):
```
/npc create Promachos --type PLAYER
/npc skin Promachos   # Or use a custom skin
/npc assignment --set promachos_assignment
```

**Verify**: Right-click Promachos should trigger dialogue (even if `met_promachos` flag exists)

---

### Phase 7: Start Server

```bash
./start.sh
# Or however your server starts
```

**Monitor console** for:
- Script load errors (should see 11 current scripts load)
- Event registration errors
- Flag read/write errors

**Expected output** (example):
```
[Denizen] Loading script emblems/core/roles.dsc
[Denizen] Loading script emblems/core/promachos.dsc
[Denizen] Loading script emblems/demeter/demeter_items.dsc
...
[Denizen] 11 scripts loaded successfully
```

---

### Phase 8: Immediate Testing (On Live Server)

**As admin, test these immediately**:

☐ **Promachos Interaction**:
```
1. Right-click Promachos
2. Should see dialogue OR role selection GUI
3. Select a role
4. Confirm flag set: /ex narrate <player.flag[role.active]>
```

☐ **Activity Tracking**:
```
1. Set role to FARMING: /roleadmin YourName FARMING
2. Harvest 1 wheat (age 7)
3. Check counter: /ex narrate <player.flag[demeter.wheat.count]>
   Should return: 1
4. Switch to MINING: /roleadmin YourName MINING
5. Harvest 1 wheat
6. Check counter: /ex narrate <player.flag[demeter.wheat.count]>
   Should STILL return: 1 (no increment when role != FARMING)
```

☐ **Key Usage**:
```
1. Give yourself a key: /demeteradmin YourName keys 1
2. Right-click key
3. Should see GUI animation → tier reveal → loot award
4. Confirm loot received
```

☐ **Profile GUI**:
```
1. Run /profile
2. Should see expanded GUI (45 slots)
3. Should show active role
4. Should show Demeter progress (if role = FARMING)
```

☐ **Admin Commands**:
```
/demeteradmin YourName set wheat 15000
/demeteradmin YourName component wheat true
/testroll demeter
/testroll ceres
```

All should work without errors.

---

## Post-Deployment (First 24 Hours)

### Hour 1: Active Monitoring

☐ **Watch Console**:
- Errors/exceptions
- Script failures
- Flag errors

☐ **Monitor TPS**:
```
/tps
```
Should stay > 19.5

☐ **Check Player Feedback**:
- Discord/chat for questions
- Common confusion points
- Bug reports

---

### First Day Checklist

☐ **Player Onboarding**:
- Are players finding Promachos?
- Are players understanding role selection?
- Are keys dropping correctly?

☐ **Performance Check**:
- Server TPS stable?
- Any lag spikes during crate openings?
- GUI animations smooth?

☐ **Bug Triage**:
- Any critical bugs? (Fix immediately or rollback)
- Any minor bugs? (Log for next update)
- Any balance issues? (Log for tuning)

---

### Week 1: Feedback Collection

☐ **Survey Players** (Discord poll or in-game):
```
1. Is the new system more fun than legacy? (Yes/No/Neutral)
2. Are key drop rates fair? (Too frequent/Just right/Too rare)
3. Are crate rewards satisfying? (Yes/No)
4. Any bugs encountered? (Free text)
```

☐ **Collect Metrics**:
- How many players have chosen a role?
- How many keys have been opened?
- How many components unlocked?
- Has anyone unlocked an emblem yet?

☐ **Adjust Based on Feedback**:
- Too grindy? Lower key thresholds (e.g., 150 wheat → 100 wheat)
- Too easy? Raise thresholds
- Loot boring? Adjust crate tables
- Bugs? Patch and announce

---

## Rollback Plan (Emergency Only)

**If current has critical game-breaking bugs**:

### Emergency Rollback Steps

1. **Shut down server immediately**:
```bash
stop
```

2. **Restore legacy backup**:
```bash
cd /path/to/server/plugins/Denizen/scripts

# Remove V2
rm -rf emblems/

# Restore legacy
cp -r emblems_legacy_backup emblems/
cp profile_gui_legacy_backup.dsc profile_gui.dsc

# Restore player data (if needed)
cp -r plugins/Denizen/saves_legacy_backup/* plugins/Denizen/saves/
```

3. **Restart server**:
```bash
./start.sh
```

4. **Announce rollback**:
```
say Emblem current has been rolled back due to critical issues.
say We've restored the old system. Apologies for the disruption!
say current will be re-deployed after fixes.
```

5. **Debug current offline**, fix issues, re-test on staging

6. **Re-deploy** when ready (follow checklist again)

---

## Success Criteria

Mark current as successful if after 1 week:

- ☐ No rollbacks required
- ☐ Server uptime > 99%
- ☐ TPS stable (> 19.5 average)
- ☐ 80%+ of active players engaged with V2
- ☐ Positive feedback > 3:1 ratio vs negative
- ☐ No game-breaking bugs
- ☐ < 5 minor bugs reported

**If all criteria met**: Proceed with Hephaestus & Heracles implementations!

---

## Common Issues & Fixes

### Issue: Scripts not loading
**Symptom**: Console shows "Script not found" errors
**Fix**:
```
1. Check file paths are correct (case-sensitive on Linux)
2. Verify .dsc extension (not .txt or .yml)
3. Run: /denizen reload
```

### Issue: Promachos not responding
**Symptom**: Right-clicking NPC does nothing
**Fix**:
```
1. Check NPC assignment: /npc sel 0 then /npc assignment
   Should show: promachos_assignment
2. If not set: /npc assignment --set promachos_assignment
3. Check NPC has click trigger: /npc trigger --list
```

### Issue: Keys not dropping
**Symptom**: Activities increment counter but no keys
**Fix**:
```
1. Check role is correct: /ex narrate <player.flag[role.active]>
2. Check counter: /ex narrate <player.flag[demeter.wheat.count]>
3. Check keys_awarded: /ex narrate <player.flag[demeter.wheat.keys_awarded]>
4. If keys_awarded > count/150: Manually give keys and reset flag
```

### Issue: Crate animation stuck
**Symptom**: GUI opens but doesn't award loot
**Fix**:
```
1. Player closes GUI
2. Manually give loot: /give <player> <item>
3. Check console for script errors
4. May need to increase animation wait times if server is laggy
```

### Issue: Flags not persisting across restarts
**Symptom**: Players lose progress after server restart
**Fix**:
```
1. Check Denizen saves folder exists and is writable
2. Verify saves are being written: /denizen save
3. Check file permissions (Linux): chmod 755 plugins/Denizen/saves
```

---

## Final Notes

**Documentation**: Keep `/docs` folder updated as you make changes

**Version Control**: Consider backing up scripts to Git after successful deployment

**Player Communication**: Transparency is key. Announce bugs, fixes, and updates promptly.

**Iteration**: current is a foundation. Listen to feedback and evolve the system!

---

**Good luck with your deployment!** 🚀

May Promachos guide your server to glory.
