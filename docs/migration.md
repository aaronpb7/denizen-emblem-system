# Migration Strategy - Fresh Start V2

## Overview

**Migration Strategy**: **FULL RESET** - No migration from legacy to V2.

All old emblem code, flags, and progression will be **deleted and replaced**. Players start fresh with the new system.

---

## Rationale

The V2 system is fundamentally different from legacy:
- legacy: Sequential stage-gated progression
- V2: Parallel activity-based progression with roles

**Incompatibility**: The progression models are incompatible. Attempting to map old stages to new counters would be complex, error-prone, and unfair to players at different stages.

**Decision**: Clean slate for all players. Announce the rework, explain the new system, and start everyone at zero.

---

## Pre-Deployment Checklist

### 1. Backup Current System

**CRITICAL**: Before deploying V2, backup all legacy files and player data.

```bash
# Backup scripts
cp -r scripts/emblems scripts/emblems_legacy_backup
cp scripts/profile_gui.dsc scripts/profile_gui_legacy_backup.dsc
cp scripts/bulletin.dsc scripts/bulletin_legacy_backup.dsc

# Backup player data (Denizen saves)
# Location varies by server setup, typically:
cp -r plugins/Denizen/saves plugins/Denizen/saves_legacy_backup
```

**Purpose**: If rollback needed due to critical bugs, restore from backup.

---

### 2. Announce Rework to Players

**Minimum 1 week notice** before deployment.

**Bulletin Update**:
- Increment bulletin version
- Add announcement entry explaining:
  - System is being reworked
  - All progress will reset
  - New system is more rewarding and flexible
  - Date of deployment

**Discord/Forum Post** (if applicable):
```
📢 **Emblem System V2 - Coming [DATE]**

We're completely reworking the emblem progression system!

**What's Changing:**
- ✅ NEW: Choose a role (Farming/Mining/Combat)
- ✅ NEW: Frequent key drops & crate rewards
- ✅ NEW: No more stage gates - progress at your own pace
- ✅ NEW: Rare Ceres meta-progression

**What's Being Reset:**
- ❌ All emblem stages, progress, and unlocks
- ❌ All players start fresh with the new system

**Why?**
The new system is fundamentally different and incompatible with the old stages. We believe it's more fun, rewarding, and flexible!

**Timeline:**
- [DATE - 1 week]: Announcement (today)
- [DATE]: V2 deployment
- [DATE + 1 week]: Feedback collection
```

---

### 3. Player Compensation (Optional)

Consider compensating players who had significant legacy progress:

**Option A: XP Grant**
- Stage 1-2 claimed: 500 XP levels
- Stage 3-4 claimed: 1000 XP levels
- Stage 5 completed (emblem): 2000 XP levels

**Option B: Starter Keys**
- Any progress in legacy: 10 Demeter Keys
- Stage 5 completed: 25 Demeter Keys

**Option C: Cosmetic Recognition**
- Special chat title: "[legacy Veteran]"
- Unique item: "Emblem of the Old Ways" (cosmetic, lore explains legacy history)

**Recommendation**: Option B (starter keys) - gives legacy players a head start without breaking V2 balance.

---

## Deployment Steps

### Step 1: Shut Down Server

**Graceful shutdown**:
```bash
# Give players warning
say Server restarting in 5 minutes for Emblem System V2 deployment!
# (wait 5 minutes)
say Server restarting NOW!
stop
```

---

### Step 2: Delete Old legacy Files

**Remove all legacy emblem scripts**:

```bash
cd scripts/emblems
rm -f emblem_items.dsc
rm -f emblem_guis.dsc
rm -f emblem_events.dsc
rm -f emblem_admin.dsc
rm -f emblem_recipes.dsc
rm -f promachos_npc.dsc
```

**DO NOT DELETE**:
- `scripts/profile_gui.dsc` (will be updated, not replaced)
- `scripts/bulletin.dsc` (will be updated with announcement)
- `scripts/server_restrictions.dsc` (unrelated to emblems)

---

### Step 3: Deploy V2 Files

**Create new directory structure**:

```bash
cd scripts
mkdir -p emblems/core
mkdir -p emblems/demeter
mkdir -p emblems/ceres
mkdir -p emblems/admin
```

**Copy all V2 script files** (provided in code deliverables section).

---

### Step 4: Update Existing Files

**Update `profile_gui.dsc`**:
- Replace emblem section with V2 role/progress display
- Update bulletin icon integration (if needed)

**Update `bulletin.dsc`**:
- Increment version (e.g., v2 → v3)
- Add V2 announcement entry

---

### Step 5: Clear Player Flags (CRITICAL)

**Problem**: Old legacy flags will persist in player data.

**Solution**: Run one-time flag cleanup script on server start.

**Cleanup Script** (`scripts/emblems/admin/legacy_flag_cleanup.dsc`):

```yaml
legacy_flag_cleanup:
    type: world
    debug: false
    events:
        after server start:
        - announce "<&e>[System]<&r> Running legacy emblem flag cleanup..."
        - foreach <server.online_players>:
            - ~run legacy_flag_cleanup_task def:<[value]>
        - announce "<&e>[System]<&r> legacy flag cleanup complete!"

legacy_flag_cleanup_task:
    type: task
    debug: false
    definitions: player
    script:
    # Remove all old Hephaestus flags
    - foreach <list[stage1|stage2|stage3|stage4|stage5]>:
        - flag <[player]> emblem.hephaestus.<[value]>.progress:!
        - flag <[player]> emblem.hephaestus.<[value]>.claimed:!
    - flag <[player]> emblem.hephaestus.stage5.completed:!

    # Remove all old Demeter flags
    - foreach <list[stage1|stage2|stage3|stage4|stage5]>:
        - flag <[player]> emblem.demeter.<[value]>.progress:!
        - flag <[player]> emblem.demeter.<[value]>.claimed:!
    - flag <[player]> emblem.demeter.stage5.completed:!

    # Remove all old Heracles flags
    - foreach <list[stage1|stage2|stage3|stage4|stage5]>:
        - flag <[player]> emblem.heracles.<[value]>.progress:!
        - flag <[player]> emblem.heracles.<[value]>.claimed:!
    - flag <[player]> emblem.heracles.stage5.completed:!

    # KEEP met_promachos flag (reuse in V2)
    # All other legacy flags removed
```

**Alternative (Manual)**:
- Use admin command to wipe flags per player: `/ex flag <player> emblem:!`
- Time-consuming for large player bases

---

### Step 6: Reset Promachos NPC

**Problem**: Old NPC assignment may have legacy dialogue/trades.

**Solution**:
1. Delete old NPC (if needed): `/npc remove`
2. Create new NPC with V2 assignment
3. OR: Update NPC assignment script to V2 version (replaces old script)

**Note**: V2 reuses `met_promachos` flag but all dialogue is new. First interaction will force role selection.

---

### Step 7: Start Server & Monitor

```bash
# Start server
./start.sh
# Or however your server starts

# Monitor console for errors
tail -f logs/latest.log
```

**Watch for**:
- Script load errors
- Event handler failures
- Flag read/write errors

---

### Step 8: Test Core Functions

**Immediate tests** (as admin on live server):

1. **Promachos Interaction**:
   - Right-click NPC → Should open role selection (even with `met_promachos` from legacy)
   - Select role → Confirm flag set

2. **Activity Tracking**:
   - Harvest wheat as FARMING → Check counter increments
   - Switch to MINING → Harvest wheat → Confirm no increment

3. **Key Usage**:
   - Give self Demeter Key: `/demeteradmin <self> keys 1`
   - Right-click → Confirm GUI opens and loot awarded

4. **Profile GUI**:
   - Run `/profile` → Confirm V2 layout displays

---

## Post-Deployment

### Week 1: Monitoring

**Daily checks**:
- Server performance (TPS, lag)
- Player feedback (chat, Discord)
- Error logs (Denizen debug)

**Common issues to watch for**:
- Key drops not working
- Role gates not enforcing
- GUI animations causing lag
- Flags not persisting across restarts

---

### Week 2: Feedback Collection

**Survey players**:
- Is the new system more fun?
- Are key drop rates balanced?
- Are crate rewards satisfying?
- Any bugs encountered?

**Adjust based on feedback**:
- Tweak key thresholds (e.g., 150 wheat → 100 wheat if too grindy)
- Adjust crate loot probabilities
- Add QoL features

---

### Week 4: Evaluate Success

**Metrics**:
- Player engagement (how many players active in emblems?)
- Progression speed (average time to first component?)
- Key economy (how many keys in circulation?)
- Ceres key rarity (how many obtained?)

**Decision point**:
- If successful: Plan Hephaestus & Heracles implementations
- If issues: Iterate on Demeter before expanding

---

## Rollback Plan (Emergency Only)

**If V2 has critical bugs** (server crashes, data loss, game-breaking exploits):

### Rollback Steps

1. **Shut down server immediately**

2. **Restore legacy backup**:
   ```bash
   rm -rf scripts/emblems
   cp -r scripts/emblems_legacy_backup scripts/emblems
   cp scripts/profile_gui_legacy_backup.dsc scripts/profile_gui.dsc
   cp -r plugins/Denizen/saves_legacy_backup/* plugins/Denizen/saves/
   ```

3. **Restart server**

4. **Announce rollback**:
   ```
   Due to critical issues, we've rolled back to Emblem legacy.
   V2 will be re-deployed after fixes.
   Apologies for the disruption!
   ```

5. **Debug V2 offline**, fix issues, re-test

6. **Re-deploy V2** following deployment steps again

---

## Flag Cleanup Details

### legacy Flags to Remove

**Hephaestus**:
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
```

**Demeter** (same pattern):
```
emblem.demeter.stage1.*
emblem.demeter.stage2.*
emblem.demeter.stage3.*
emblem.demeter.stage4.*
emblem.demeter.stage5.*
```

**Heracles** (same pattern):
```
emblem.heracles.stage1.*
emblem.heracles.stage2.*
emblem.heracles.stage3.*
emblem.heracles.stage4.*
emblem.heracles.stage5.*
```

### legacy Flags to KEEP

```
met_promachos  (reused in V2)
```

---

## Communication Timeline

**T-14 days**: Initial announcement (Discord, bulletin)

**T-7 days**: Reminder announcement + FAQ

**T-3 days**: Final reminder

**T-1 day**: "Tomorrow!" hype message

**T-0 (Deployment Day)**:
- Morning: Final backup
- Afternoon: Deploy V2
- Evening: Monitor & assist players

**T+1 day**: Post-deployment feedback thread

**T+7 days**: Week 1 review

**T+30 days**: Month 1 retrospective

---

## Player Compensation Implementation

If choosing **Option B: Starter Keys**:

**Run this task on all players post-deployment**:

```yaml
legacy_compensation:
    type: world
    debug: false
    events:
        after server start:
        - wait 5s
        - foreach <server.online_players>:
            - if <[value].has_flag[legacy.compensated]>:
                - foreach next
            - give <[value]> demeter_key quantity:10
            - narrate "<&e>[Promachos]<&r> <&7>Thank you for your service in the old emblem trials. Accept these keys as a token of appreciation." targets:<[value]>
            - flag <[value]> legacy.compensated:true
```

**Note**: Use flag `legacy.compensated` to prevent giving keys multiple times.

---

## FAQ for Players

**Q: Will my old emblem progress carry over?**
A: No. V2 is a complete rework with a different progression model. Everyone starts fresh.

**Q: Why not migrate old progress?**
A: legacy and V2 are fundamentally incompatible. legacy had sequential stages; V2 has parallel activities with role-based tracking. Mapping would be unfair and complex.

**Q: Will I get anything for my legacy progress?**
A: Yes! Players with legacy progress will receive 10 Demeter Keys as compensation.

**Q: When does V2 launch?**
A: [DATE] (exact date TBD)

**Q: What if I don't like V2?**
A: We're collecting feedback for the first month and will make adjustments based on player input.

**Q: Can I keep my old emblem items?**
A: Old emblem items (if physical) will remain in your inventory but may not function in V2. Consider them collectibles.

---

## Final Checklist

**Before Deployment**:
- [ ] legacy files backed up
- [ ] Player data backed up
- [ ] V2 files prepared and tested on staging server
- [ ] Players announced (minimum 1 week prior)
- [ ] FAQ posted
- [ ] Admin team briefed on V2 mechanics

**During Deployment**:
- [ ] Server shut down gracefully
- [ ] legacy files deleted
- [ ] V2 files deployed
- [ ] Flag cleanup script loaded
- [ ] Bulletin updated
- [ ] Server restarted
- [ ] Core functions tested

**After Deployment**:
- [ ] Monitor server performance
- [ ] Assist players with questions
- [ ] Collect feedback
- [ ] Log bugs and issues
- [ ] Plan iterative improvements

---

## Success Criteria

V2 deployment considered successful if:
- ✅ No server crashes or rollbacks
- ✅ 80%+ of active players engage with new system within 1 week
- ✅ Positive feedback outweighs negative 3:1
- ✅ No game-breaking bugs reported
- ✅ Server performance stable (TPS > 19.5)

If all criteria met → Proceed with Hephaestus & Heracles implementations.
