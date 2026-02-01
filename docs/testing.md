# Testing Guide - Manual Test Checklist & Admin Commands

## Overview

This document provides a comprehensive testing checklist and admin command reference for the Emblem System V2.

---

## Admin Commands Reference

### Role Management

```
/roleadmin <player> <role>
```

**Purpose**: Set player's active role

**Valid Roles**: `FARMING`, `MINING`, `COMBAT`

**Example**:
```
/roleadmin Notch FARMING
```

**Output**: `Set Notch's role to FARMING`

---

### Demeter Admin Commands

#### Give Keys

```
/demeteradmin <player> keys <amount>
```

**Example**: `/demeteradmin Notch keys 10`

#### Set Activity Counter

```
/demeteradmin <player> set <activity> <count>
```

**Valid Activities**: `wheat`, `cows`, `cakes`

**Examples**:
```
/demeteradmin Notch set wheat 14500
/demeteradmin Notch set cows 1900
/demeteradmin Notch set cakes 250
```

**Note**: Does NOT auto-award keys or components. Use separate commands for those.

#### Toggle Component

```
/demeteradmin <player> component <activity> <true|false>
```

**Valid Activities**: `wheat`, `cow`, `cake`

**Examples**:
```
/demeteradmin Notch component wheat true
/demeteradmin Notch component cow false
```

#### Reset All Demeter Flags

```
/demeteradmin <player> reset
```

**Warning**: Wipes ALL Demeter progression (counters, components, emblem unlock, keys_awarded tracking)

---

### Global Reset Command

#### Complete System Reset

```
/emblemreset <player>
/emblemreset <player> confirm
```

**Purpose**: Completely resets a player's entire emblem progression across ALL systems

**Safety Feature**: Requires two-step confirmation to prevent accidental resets

**First Command** (`/emblemreset <player>`):
- Shows detailed warning of what will be deleted
- Lists all systems affected
- Provides confirmation command

**Second Command** (`/emblemreset <player> confirm`):
- Executes the full reset
- Notifies admin and player
- Logs to console

**What Gets Reset:**

**Core System:**
- `met_promachos` - Allows re-introduction to NPC
- `role.active` - Removes active role
- `role.changed_before` - Resets role change history

**Demeter (FARMING):**
- All activity counters (wheat, cows, cakes)
- All keys awarded tracking
- All components (wheat, cow, cake) + dates
- Rank progression
- Crate statistics (opens, tier counts)
- Item unlocks (demeter title)
- Animation state flags

**Ceres (Meta-Progression):**
- Crate open count
- All unique items (hoe, title, shulker, wand)
- Unique item counter
- Animation state flags

**Cosmetics:**
- Active title selection

**Future Systems:**
- Hephaestus flags (wildcard removal)
- Heracles flags (wildcard removal)
- Vulcan flags (wildcard removal)
- Mars flags (wildcard removal)

**Example Workflow:**
```bash
# Step 1: Check what will be reset
/emblemreset Notch

# Output shows warning:
# ⚠ WARNING: This will permanently delete:
# - Role selection and active role
# - All Demeter progress (wheat, cows, cakes)
# - All Demeter components and ranks
# - All Ceres unlocks (hoe, title, shulker, wand)
# - All cosmetic titles
# - All crate statistics
# - Promachos introduction flag
#
# To confirm, run: /emblemreset Notch confirm

# Step 2: Confirm reset
/emblemreset Notch confirm

# Output:
# ✓ Successfully reset all emblem progress for Notch
# They can now start fresh by visiting Promachos.
```

**Player Notification:**
```
[Emblem System] Your emblem progression has been completely reset by an admin.
Visit Promachos to begin your journey!
```

**Use Cases:**
- Testing full progression flows from scratch
- Resetting players who request it
- Cleaning up test accounts before production
- Preparing accounts for QA testing

**Important Notes:**
- This does NOT remove physical items from player inventory (keys, rewards, etc.)
- Only removes flags and progression data
- Future-proof: automatically includes Hephaestus/Heracles when implemented
- Console logging for audit trail

---

### Farming XP Admin Commands

#### Give Farming XP

```
/farmingadmin <player> xp <amount>
```

**Example**: `/farmingadmin Notch xp 500`

#### Set Total XP

```
/farmingadmin <player> setxp <amount>
```

**Example**: `/farmingadmin Notch setxp 10000`

**Note**: Triggers rank-up ceremony if rank increases.

#### Force Set Rank

```
/farmingadmin <player> rank <0-5>
```

**Valid Ranks**: 0 (none), 1-5 (Acolyte through Legend)

**Example**: `/farmingadmin Notch rank 3`

#### Reset Farming XP/Rank

```
/farmingadmin <player> reset
```

---

### Heracles Admin Commands

#### Give Keys

```
/heraclesadmin <player> keys <amount>
```

**Example**: `/heraclesadmin Notch keys 10`

#### Set Activity Counter

```
/heraclesadmin <player> set <activity> <count>
```

**Valid Activities**: `pillagers`, `raids`, `emeralds`

**Examples**:
```
/heraclesadmin Notch set pillagers 2000
/heraclesadmin Notch set raids 40
/heraclesadmin Notch set emeralds 500
```

#### Give Combat XP

```
/heraclesadmin <player> xp <amount>
```

**Example**: `/heraclesadmin Notch xp 1000`

#### Toggle Component

```
/heraclesadmin <player> component <pillagers|raids|emeralds> <true|false>
```

**Example**: `/heraclesadmin Notch component pillagers true`

#### Award Raid Completion

```
/heraclesadmin <player> raid <level>
```

**Level**: 1-5 (Bad Omen level)

**Awards**: XP based on level + 2 Heracles Keys + increments raid counter

**Example**: `/heraclesadmin Notch raid 3`

#### Reset All Heracles Flags

```
/heraclesadmin <player> reset
```

---

### Ceres Admin Commands

#### Give Ceres Keys

```
/ceresadmin <player> keys <amount>
```

**Example**: `/ceresadmin Notch keys 5`

#### Toggle Item Obtained

```
/ceresadmin <player> item <item> <true|false>
```

**Valid Items**: `hoe`, `title`, `shulker`, `wand`

**Examples**:
```
/ceresadmin Notch item hoe true
/ceresadmin Notch item title false
```

#### Reset All Ceres Flags

```
/ceresadmin <player> reset
```

**Warning**: Wipes ALL Ceres item flags

---

### Test Roll Commands

#### Simulate Demeter Crate

```
/testroll demeter
```

**Purpose**: Simulate a Demeter crate roll for the executing player without consuming a key

**Output**: Tier rolled, loot awarded, messages/sounds as normal

#### Simulate Ceres Crate

```
/testroll ceres
```

**Purpose**: Simulate a Ceres crate roll for the executing player without consuming a key

**Output**: 50/50 roll result, god apple or unique item (if available)

---

### Check Keys Command

```
/checkkeys [player]
```

**Purpose**: Check key tracking for a player (shows counts, keys awarded, keys owed)

**Permission**: None (all players can use)

**Supports**: Offline players

**Output**:
```
DEMETER:
  Wheat: 5000 | Awarded: 33 | Should: 33 | Owed: 0
  Cows: 800 | Awarded: 40 | Should: 40 | Owed: 0
  Cakes: 150 | Awarded: 30 | Should: 30 | Owed: 0
HERACLES:
  Pillagers: 1000 | Awarded: 40 | Should: 40 | Owed: 0
  Raids: 20 | Awarded: 40 | Should: 40 | Owed: 0
  Emeralds: 350 | Awarded: 3 | Should: 3 | Owed: 0
```

---

## Manual Testing Checklist

### Phase 1: Core System Tests

#### Test 1.1: Promachos First Meeting

**Steps**:
1. Create fresh player (or use `/demeteradmin <player> reset` + remove `met_promachos` flag)
2. Right-click Promachos NPC
3. Observe dialogue sequence (5 parts, 3s delays)
4. Role selection GUI opens after dialogue

**Expected**:
- All 5 dialogue lines appear in chat
- `met_promachos` flag set to true
- GUI opens with 3 role options + cancel

**Pass/Fail**: ___

---

#### Test 1.2: Role Selection

**Steps**:
1. In role selection GUI, click Georgos (farming)
2. Observe confirmation message
3. Check `/profile` shows active role

**Expected**:
- GUI closes
- Message: "You have chosen the path of Georgos..."
- Sound plays
- `role.active` flag set to `FARMING`

**Pass/Fail**: ___

---

#### Test 1.3: Role Switching

**Steps**:
1. Player with existing role right-clicks Promachos
2. Click "Change Role"
3. Select different role (e.g., Metallourgos)
4. Observe confirmation

**Expected**:
- Main menu opens (not dialogue)
- Change role option visible
- Role switches successfully
- Message confirms previous progress preserved

**Pass/Fail**: ___

---

### Phase 2: Demeter Activity Tracking

#### Test 2.1: Wheat Harvesting (Active Role)

**Setup**: Set role to FARMING

**Steps**:
1. Plant wheat, wait for age=7
2. Harvest 150 wheat
3. Observe key drop

**Expected**:
- Counter increments each harvest
- At 150: +1 Demeter Key awarded
- Message: "DEMETER KEY! Wheat: 150/15000"
- Sound: `entity_experience_orb_pickup`

**Pass/Fail**: ___

---

#### Test 2.2: Wheat Harvesting (Inactive Role)

**Setup**: Set role to MINING or COMBAT

**Steps**:
1. Harvest 50 wheat
2. Check counter

**Expected**:
- Counter does NOT increment
- No keys awarded
- No messages

**Pass/Fail**: ___

---

#### Test 2.3: Wheat Component Milestone

**Setup**: Set counter to 14,950 via admin command

**Steps**:
1. Set role to FARMING
2. Harvest 50 wheat (reaches 15,000)
3. Observe component award

**Expected**:
- At 15,000: Wheat Component flag set to true
- Message: "MILESTONE! Wheat Component obtained!"
- Sound: `ui_toast_challenge_complete`
- Server announcement

**Pass/Fail**: ___

---

#### Test 2.4: Component Once-Only

**Setup**: Player already has wheat component

**Steps**:
1. Continue harvesting wheat past 15,000 (e.g., to 20,000)
2. Observe no second component

**Expected**:
- Counter continues to increment
- Keys still awarded (every 150)
- Component does NOT award again
- No duplicate milestone message

**Pass/Fail**: ___

---

#### Test 2.5: Cow Breeding

**Setup**: Set role to FARMING

**Steps**:
1. Breed 20 cows (wheat feeding)
2. Observe key drop

**Expected**:
- Counter increments each breed
- At 20: +1 Demeter Key awarded
- Message: "DEMETER KEY! Cows: 20/2000"

**Pass/Fail**: ___

---

#### Test 2.6: Cow Component Milestone

**Setup**: Set counter to 1,990

**Steps**:
1. Breed 10 more cows (reaches 2,000)
2. Observe component award

**Expected**:
- At 2,000: Cow Component flag set
- Milestone message and sound
- Server announcement

**Pass/Fail**: ___

---

#### Test 2.7: Cake Crafting

**Setup**: Set role to FARMING

**Steps**:
1. Craft 5 cakes
2. Observe key drop

**Expected**:
- Counter increments by craft quantity (bulk crafts count individually)
- At 5: +1 Demeter Key awarded
- Message: "DEMETER KEY! Cakes: 5/500"

**Pass/Fail**: ___

---

#### Test 2.8: Cake Bulk Crafting

**Setup**: Set counter to 492

**Steps**:
1. Shift-click to craft 10 cakes at once
2. Observe key awards

**Expected**:
- Counter increments to 502
- 2 keys awarded (for 495 and 500)
- Component awarded at 500

**Pass/Fail**: ___

---

### Phase 3: Demeter Crate System

#### Test 3.1: Key Usage (Normal)

**Steps**:
1. Give player 1 Demeter Key
2. Right-click key in hand
3. Observe GUI animation
4. Receive loot

**Expected**:
- Key consumed
- GUI opens with animation (2s)
- Tier rolled and displayed
- Loot awarded
- Appropriate sound plays

**Pass/Fail**: ___

---

#### Test 3.2: Tier Distribution (100 Rolls)

**Steps**:
1. Use `/testroll demeter` 100 times
2. Record tier frequencies

**Expected** (approximate):
- MORTAL: ~56
- HEROIC: ~26
- LEGENDARY: ~12
- MYTHIC: ~5
- OLYMPIAN: ~1

**Actual Results**:
- MORTAL: ___
- HEROIC: ___
- LEGENDARY: ___
- MYTHIC: ___
- OLYMPIAN: ___

**Pass/Fail**: ___

---

#### Test 3.3: MORTAL Loot

**Steps**:
1. Force MORTAL roll (or roll until MORTAL)
2. Check loot awarded

**Expected**:
- One of: Bread x16, Cooked Beef x8, Baked Potato x8, Wheat x32, Hay Bale x8, Bone Meal x16, Pumpkin Pie x8

**Pass/Fail**: ___

---

#### Test 3.4: OLYMPIAN Loot (Ceres Key)

**Steps**:
1. Force OLYMPIAN roll (or admin give Ceres Key to verify drop)
2. Observe Ceres Key received

**Expected**:
- 1 Ceres Key awarded
- Dramatic sound (ender dragon growl + challenge complete)
- Message: "[OLYMPIAN] Ceres Key x1"

**Pass/Fail**: ___

---

#### Test 3.5: Full Inventory Handling

**Steps**:
1. Fill inventory completely
2. Open Demeter crate
3. Observe loot drop

**Expected**:
- Loot drops at player feet
- Message: "Inventory full! Item dropped at your feet."

**Pass/Fail**: ___

---

### Phase 4: Demeter Blessing

#### Test 4.1: Normal Use (All Incomplete)

**Setup**:
- Wheat: 5,000 (incomplete)
- Cows: 800 (incomplete)
- Cakes: 150 (incomplete)

**Steps**:
1. Give player Demeter Blessing
2. Right-click to use
3. Observe counter boosts

**Expected**:
- Wheat: +1,500 → 6,500
- Cows: +200 → 1,000
- Cakes: +50 → 200
- Blessing consumed
- Message shows all 3 boosts
- Keys awarded if thresholds crossed

**Pass/Fail**: ___

---

#### Test 4.2: One Activity Complete

**Setup**:
- Wheat: 15,000 (component obtained)
- Cows: 1,000 (incomplete)
- Cakes: 200 (incomplete)

**Steps**:
1. Use Demeter Blessing
2. Observe selective boosting

**Expected**:
- Wheat: NO boost (15,000 unchanged)
- Cows: +200 → 1,200
- Cakes: +50 → 250
- Message shows only 2 boosts

**Pass/Fail**: ___

---

#### Test 4.3: All Activities Complete

**Setup**:
- All 3 components obtained

**Steps**:
1. Right-click Demeter Blessing
2. Observe blocked use

**Expected**:
- Blessing NOT consumed
- Message: "All Demeter activities already complete!"
- Sound: villager_no

**Pass/Fail**: ___

---

#### Test 4.4: Near-Cap Boost

**Setup**:
- Wheat: 14,800

**Steps**:
1. Use Demeter Blessing (+1,500)
2. Observe capping

**Expected**:
- Wheat: 15,000 (capped, not 16,300)
- Message shows actual boost: "+200 (14,800 → 15,000)"
- Component awarded immediately

**Pass/Fail**: ___

---

#### Test 4.5: Multiple Blessings

**Steps**:
1. Give player 3 Demeter Blessings
2. Use all 3 sequentially
3. Observe stacking boosts

**Expected**:
- First use: Wheat +1,500
- Second use: Wheat +1,500 again (total +3,000)
- Third use: Wheat +1,500 again (total +4,500)
- Each blessing consumed individually

**Pass/Fail**: ___

---

### Phase 5: Ceres System

#### Test 5.1: First Ceres Key (Unique Item)

**Setup**: Player has no Ceres items

**Steps**:
1. Give Ceres Key
2. Right-click key
3. Observe roll (force unique item path via multiple attempts if 50/50)

**Expected**:
- 50% chance for unique item
- One of: Ceres Hoe, Title, Shulker, Wand
- Item flag set to true
- Message: "[CERES] <item name> UNIQUE ITEM!"
- Server announcement

**Pass/Fail**: ___

---

#### Test 5.2: Ceres Key (God Apple)

**Steps**:
1. Use Ceres Key
2. Roll god apple path (50%)

**Expected**:
- 1 Enchanted Golden Apple awarded
- Message: "[CERES] Enchanted Golden Apple"
- Sound: `entity_player_levelup`

**Pass/Fail**: ___

---

#### Test 5.3: Ceres All Items Obtained

**Setup**: Use admin to set all 4 Ceres item flags to true

**Steps**:
1. Use Ceres Key
2. Observe forced god apple

**Expected**:
- Always awards god apple (no 50/50 roll)
- Message: "[CERES] Enchanted Golden Apple (All items obtained)"

**Pass/Fail**: ___

---

#### Test 5.4: Ceres Hoe Auto-Replant

**Setup**: Player has Ceres Hoe in hand

**Steps**:
1. Plant wheat, wait for age=7
2. Break wheat with Ceres Hoe
3. Observe replanting

**Expected**:
- Wheat breaks, drops items (seeds + wheat)
- 1 tick later, wheat replanted at same location (age=0)
- Particle effect plays
- Works with Demeter counter tracking

**Pass/Fail**: ___

---

#### Test 5.5: Ceres Wand Bee Summon

**Setup**: Player has Ceres Wand

**Steps**:
1. Right-click wand in area with hostile mobs
2. Observe bee spawns
3. Wait 30s, observe despawn

**Expected**:
- 6 angry bees spawn around player
- Action bar: "CERES' BEES - 6 bees summoned for 30s"
- Bees target nearest hostile mobs
- Bees despawn after 30s
- After 30s: action bar "Ceres Wand ready!" + chime sound

**Pass/Fail**: ___

---

#### Test 5.6: Ceres Wand Cooldown

**Setup**: Just used Ceres Wand

**Steps**:
1. Try to use wand again immediately
2. Observe silent fail

**Expected**:
- No message (silent fail)
- Wand NOT activated
- After 30s cooldown expires: action bar "Ceres Wand ready!" + chime sound

**Pass/Fail**: ___

---

#### Test 5.7: Ceres Title Chat Display

**Setup**: Player has Ceres Title unlocked

**Steps**:
1. Player types message in chat: "Hello!"
2. Observe formatted broadcast

**Expected**:
- Message broadcasts as: "[Ceres' Chosen] PlayerName: Hello!"
- Title prefix colored correctly

**Pass/Fail**: ___

---

### Phase 6: Emblem Unlock

#### Test 6.1: Emblem Ready (All Components)

**Setup**:
- All 3 Demeter components obtained
- Emblem NOT yet unlocked

**Steps**:
1. Right-click Promachos
2. Open "Check Emblems"
3. Observe Demeter emblem status

**Expected**:
- Demeter item shows "READY TO UNLOCK!"
- Item is nether star with glint
- Clickable

**Pass/Fail**: ___

---

#### Test 6.2: Emblem Unlock Ceremony

**Setup**: All components, emblem ready

**Steps**:
1. Click "READY!" Demeter emblem in GUI
2. Observe ceremony

**Expected**:
- GUI closes
- 3-part dialogue sequence (3s delays)
- Sound: `ui_toast_challenge_complete`
- Flag `demeter.emblem.unlocked` set to true
- Unlock date saved
- Server announcement
- Particle effects
- Next emblem line unlocked (flag set)

**Pass/Fail**: ___

---

#### Test 6.3: Emblem Already Unlocked

**Setup**: Demeter emblem already unlocked

**Steps**:
1. Check emblem status in GUI
2. Observe display

**Expected**:
- Demeter shows "✓ UNLOCKED"
- Gold/enchanted item with checkmark
- Shows unlock date in lore

**Pass/Fail**: ___

---

### Phase 7: Profile GUI Integration

#### Test 7.1: Active Role Display

**Setup**: Player has role set to FARMING

**Steps**:
1. Run `/profile`
2. Check GUI display

**Expected**:
- Shows "Active Role: Georgos"
- Color-coded or highlighted

**Pass/Fail**: ___

---

#### Test 7.2: Demeter Progress Bars

**Setup**: Partial progress (e.g., 8,000 wheat, 1,200 cows, 95 cakes)

**Steps**:
1. Open `/profile` → Demeter section
2. Observe progress display

**Expected**:
- Shows counters: 8000/15000, 1200/2000, 95/500
- Shows keys earned: 53, 60, 19
- Shows component status: ✗, ✗, ✗
- Progress bars visual (optional)

**Pass/Fail**: ___

---

#### Test 7.3: Ceres Item Checklist

**Setup**: Player has 2 of 4 Ceres items

**Steps**:
1. Open `/profile` → Ceres section
2. Observe checklist

**Expected**:
- Shows 4 items with ✓ or ✗
- Shows "2 / 4 items obtained"

**Pass/Fail**: ___

---

### Phase 8: Edge Cases & Stress Tests

#### Test 8.1: Rapid Key Usage

**Steps**:
1. Give player 10 Demeter Keys
2. Spam right-click rapidly
3. Observe handling

**Expected**:
- Keys consumed one at a time
- No double-opens or errors
- Rate limit prevents spam (optional)

**Pass/Fail**: ___

---

#### Test 8.2: Role Switch Mid-Activity

**Steps**:
1. Start harvesting wheat as FARMING role
2. Switch to MINING mid-harvest
3. Continue harvesting
4. Switch back to FARMING
5. Harvest more

**Expected**:
- Counters only increment when role = FARMING
- No errors when switching
- Progress resumes correctly

**Pass/Fail**: ___

---

#### Test 8.3: Server Restart Persistence

**Steps**:
1. Set progress (counters, components, emblem)
2. Restart server
3. Check flags

**Expected**:
- All flags persist
- Counters preserved
- Role preserved
- Components preserved

**Pass/Fail**: ___

---

#### Test 8.4: Concurrent Activity Tracking

**Steps**:
1. As FARMING role, perform all 3 activities simultaneously:
   - Harvest wheat
   - Breed cow
   - Craft cake
2. Observe all counters

**Expected**:
- All 3 counters increment correctly
- No race conditions or missed events

**Pass/Fail**: ___

---

## Performance Tests

### Test P.1: Wheat Harvest Performance

**Steps**:
1. Use world edit or admin to create 1000 block wheat farm
2. Harvest all at once (efficiency tool)
3. Observe server performance

**Expected**:
- No lag spikes
- All harvests counted
- Keys awarded correctly

**Pass/Fail**: ___

---

### Test P.2: Crate Animation Performance

**Steps**:
1. Open 50 Demeter crates rapidly (5-10s delay between)
2. Observe client/server performance

**Expected**:
- Animations smooth
- No lag or GUI glitches
- All loot awarded

**Pass/Fail**: ___

---

## Regression Tests (After Updates)

After any code changes, re-run:
- Test 2.1, 2.2 (Role gating)
- Test 2.3, 2.4 (Component once-only)
- Test 3.1 (Key usage)
- Test 4.1 (Blessing boost)
- Test 6.2 (Emblem unlock)

---

## Bug Reporting Template

If any test fails, use this template:

```
**Test ID**: [e.g., Test 2.3]
**Expected Behavior**: [What should happen]
**Actual Behavior**: [What actually happened]
**Steps to Reproduce**:
1. ...
2. ...
**Server Version**: [e.g., Paper 1.20.1]
**Denizen Version**: [e.g., 1.2.9]
**Error Logs**: [Paste relevant errors]
```

---

## Automated Testing (Future)

Consider implementing automated tests for:
- Counter increment logic (unit tests)
- Tier probability distribution (100+ rolls)
- Flag persistence across restarts
- Role gating enforcement
