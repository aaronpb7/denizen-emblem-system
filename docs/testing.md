# Testing Guide - Manual Test Checklist & Admin Commands

## Overview

This document provides a comprehensive testing checklist and admin command reference for the Emblem System V2.

---

## Admin Commands Reference

### Emblem Management

```
/emblemadmin <player> <emblem>
```

**Purpose**: Set player's active emblem

**Valid Emblems**: `DEMETER`, `HEPHAESTUS`, `HERACLES`, `TRITON`

**Example**:
```
/emblemadmin Notch DEMETER
```

**Output**: `Set Notch's emblem to DEMETER`

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

#### Max Out Demeter Emblem

```
/demeteradmin <player> max
```

Sets all 3 components to complete, marks emblem as unlocked, and increments rank.

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
- `emblem.active` - Removes active emblem
- `emblem.changed_before` - Resets emblem change history
- `emblem.rank` - Resets emblem rank
- `emblem.migrated` - Resets migration flag

**Demeter:**
- All activity counters (wheat, cows, cakes)
- All keys awarded tracking
- All components (wheat, cow, cake) + dates
- Crate statistics (opens, tier counts)
- Item unlocks (demeter title)
- Animation state flags

**Heracles:**
- All activity counters (pillagers, raids, emeralds)
- All keys awarded tracking
- All components (pillagers, raids, emeralds) + dates
- Crate statistics (opens, tier counts)
- Animation state flags

**Hephaestus:**
- All activity counters (iron, smelting, golems)
- All keys awarded tracking
- All components (iron, smelting, golem) + dates
- Crate statistics (opens, tier counts)
- Animation state flags

**Ceres (Meta-Progression):**
- Crate open count
- All unique items (title, shulker, wand, head)
- Unique item counter
- Animation state flags

**Mars (Meta-Progression):**
- Crate open count
- All unique items (title, shulker, shield, head)
- Unique item counter

**Vulcan (Meta-Progression):**
- Crate open count
- All unique items (pickaxe, title, shulker, head)
- Unique item counter

**Triton:**
- All activity counters (lanterns, guardians, conduits)
- All keys awarded tracking
- All components (lanterns, guardians, conduits) + dates
- Crate statistics (opens, tier counts)
- Animation state flags

**Neptune (Meta-Progression):**
- Crate open count
- All unique items (title, shulker, trident, head)
- Unique item counter

**Crafting System:**
- `crafting.viewing_recipe` flag

**Cosmetics:**
- Active title selection

**Example Workflow:**
```bash
# Step 1: Check what will be reset
/emblemreset Notch

# Output shows warning:
# ⚠ WARNING: This will permanently delete:
# - Emblem selection and active emblem
# - Emblem rank progression
# - All Demeter progress (wheat, cows, cakes)
# - All Demeter components
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

### Rank Admin Commands

```
/rankadmin <player> set <rank>
```

**Purpose**: Set player's emblem rank directly

**Example**: `/rankadmin Notch set 3`

**Output**: `Set Notch's emblem rank to 3`

```
/rankadmin <player> reset
```

**Purpose**: Reset player's emblem rank to 0

---

### Inventory Viewer Commands

#### View Player Inventory

```
/invsee <player>
```

**Purpose**: Open a player's inventory for viewing/editing

**Supports**: Offline players

**Example**: `/invsee Notch`

---

#### View Player Ender Chest

```
/endersee <player>
```

**Purpose**: Open a player's ender chest for viewing/editing

**Supports**: Offline players

**Example**: `/endersee Notch`

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

**Awards**: 2 Heracles Keys + increments raid counter

**Example**: `/heraclesadmin Notch raid 3`

#### Max Out Heracles Emblem

```
/heraclesadmin <player> max
```

Sets all 3 components to complete, marks emblem as unlocked, and increments rank.

#### Reset All Heracles Flags

```
/heraclesadmin <player> reset
```

---

### Hephaestus Admin Commands

#### Give Keys

```
/hephaestusadmin <player> keys <amount>
```

**Example**: `/hephaestusadmin Notch keys 10`

#### Set Activity Counter

```
/hephaestusadmin <player> set <activity> <count>
```

**Valid Activities**: `iron`, `smelting`, `golems`

**Example**: `/hephaestusadmin Notch set iron 5000`

#### Toggle Component

```
/hephaestusadmin <player> component <iron|smelting|golem> <true|false>
```

**Example**: `/hephaestusadmin Notch component iron true`

#### Max Out Hephaestus Emblem

```
/hephaestusadmin <player> max
```

Sets all 3 components to complete, marks emblem as unlocked, and increments rank.

#### Reset All Hephaestus Flags

```
/hephaestusadmin <player> reset
```

---

### Mars Admin Commands

#### Give Mars Keys

```
/marsadmin <player> keys <amount>
```

**Example**: `/marsadmin Notch keys 5`

#### Toggle Item Obtained

```
/marsadmin <player> item <item> <true|false>
```

**Valid Items**: `title`, `shulker`, `shield`, `head`

**Examples**:
```
/marsadmin Notch item shield true
/marsadmin Notch item head false
```

#### Reset All Mars Flags

```
/marsadmin <player> reset
```

**Warning**: Wipes ALL Mars item flags

---

### Vulcan Admin Commands

#### Give Vulcan Keys

```
/vulcanadmin <player> keys <amount>
```

**Example**: `/vulcanadmin Notch keys 5`

#### Toggle Item Obtained

```
/vulcanadmin <player> item <item> <true|false>
```

**Valid Items**: `pickaxe`, `title`, `shulker`, `head`

**Examples**:
```
/vulcanadmin Notch item head true
/vulcanadmin Notch item title false
```

#### Reset All Vulcan Flags

```
/vulcanadmin <player> reset
```

**Warning**: Wipes ALL Vulcan item flags

---

### Triton Admin Commands

#### Give Keys

```
/tritonadmin <player> keys <amount>
```

**Example**: `/tritonadmin Notch keys 10`

#### Set Activity Counter

```
/tritonadmin <player> set <activity> <count>
```

**Valid Activities**: `lanterns`, `guardians`, `conduits`

**Examples**:
```
/tritonadmin Notch set lanterns 900
/tritonadmin Notch set guardians 1400
/tritonadmin Notch set conduits 20
```

**Note**: Does NOT auto-award keys or components. Use separate commands for those.

#### Toggle Component

```
/tritonadmin <player> component <lanterns|guardians|conduits> <true|false>
```

**Example**: `/tritonadmin Notch component lanterns true`

#### Max Out Triton Emblem

```
/tritonadmin <player> max
```

Sets all 3 components to complete, marks emblem as unlocked, and increments rank.

#### Reset All Triton Flags

```
/tritonadmin <player> reset
```

**Warning**: Wipes ALL Triton progression (counters, components, emblem unlock, keys_awarded tracking)

---

### Neptune Admin Commands

#### Give Neptune Keys

```
/neptuneadmin <player> keys <amount>
```

**Example**: `/neptuneadmin Notch keys 5`

#### Give Specific Item

```
/neptuneadmin <player> give <head|shulker|blueprint|trident>
```

**Example**: `/neptuneadmin Notch give trident`

#### Toggle Item Obtained

```
/neptuneadmin <player> item <item> <true|false>
```

**Valid Items**: `title`, `shulker`, `trident`, `head`

**Examples**:
```
/neptuneadmin Notch item title true
/neptuneadmin Notch item head false
```

#### Reset All Neptune Flags

```
/neptuneadmin <player> reset
```

**Warning**: Wipes ALL Neptune item flags

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

**Valid Items**: `title`, `shulker`, `wand`, `head`

**Examples**:
```
/ceresadmin Notch item head true
/ceresadmin Notch item title false
```

#### Reset All Ceres Flags

```
/ceresadmin <player> reset
```

**Warning**: Wipes ALL Ceres item flags

---

### Test Roll Commands

```
/testroll <demeter|ceres|heracles|mars|hephaestus|vulcan|triton|neptune>
```

**Purpose**: Simulate a crate roll for the executing player without consuming a key

**Output**: Tier rolled, loot awarded, messages/sounds as normal

**Examples**:
- `/testroll demeter` - Simulate Demeter crate
- `/testroll ceres` - Simulate Ceres meta-crate (50/50 god apple or unique item)
- `/testroll heracles` - Simulate Heracles crate
- `/testroll mars` - Simulate Mars meta-crate
- `/testroll hephaestus` - Simulate Hephaestus crate
- `/testroll vulcan` - Simulate Vulcan meta-crate
- `/testroll triton` - Simulate Triton crate
- `/testroll neptune` - Simulate Neptune meta-crate

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
TRITON:
  Lanterns: 500 | Awarded: 50 | Should: 50 | Owed: 0
  Guardians: 750 | Awarded: 50 | Should: 50 | Owed: 0
  Conduits: 12 | Awarded: 48 | Should: 48 | Owed: 0
```

---

## Manual Testing Checklist

### Phase 1: Core System Tests

#### Test 1.1: Promachos First Meeting

**Steps**:
1. Create fresh player (or use `/demeteradmin <player> reset` + remove `met_promachos` flag)
2. Right-click Promachos NPC
3. Observe dialogue sequence (5 parts, 3s delays)
4. Emblem selection GUI opens after dialogue

**Expected**:
- All 5 dialogue lines appear in chat
- `met_promachos` flag set to true
- GUI opens with 3 emblem options + cancel

**Pass/Fail**: ___

---

#### Test 1.2: Emblem Selection

**Steps**:
1. In emblem selection GUI, click Emblem of Demeter
2. Observe confirmation message
3. Check `/profile` shows active emblem

**Expected**:
- GUI closes
- Message: "You have chosen the Emblem of Demeter..."
- Sound plays
- `emblem.active` flag set to `DEMETER`

**Pass/Fail**: ___

---

#### Test 1.3: Emblem Switching

**Steps**:
1. Player with existing emblem right-clicks Promachos
2. Click "Change Emblem"
3. Select different emblem (e.g., Hephaestus)
4. Observe confirmation

**Expected**:
- Main menu opens (not dialogue)
- Change emblem option visible
- Emblem switches successfully
- Message confirms previous progress preserved

**Pass/Fail**: ___

---

### Phase 2: Demeter Activity Tracking

#### Test 2.1: Wheat Harvesting (Active Emblem)

**Setup**: Set emblem to DEMETER

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

#### Test 2.2: Wheat Harvesting (Inactive Emblem)

**Setup**: Set emblem to HEPHAESTUS or HERACLES

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
1. Set emblem to DEMETER
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

**Setup**: Set emblem to DEMETER

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

**Setup**: Set emblem to DEMETER

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

#### Test 4.3: All Activities Complete (Key Conversion)

**Setup**:
- All 3 components obtained

**Steps**:
1. Right-click Demeter Blessing

**Expected**:
- Blessing consumed
- Player receives 10 Demeter Keys
- Message: "All activities complete! Converted to 10 Demeter Keys."
- Sound: block_enchantment_table_use

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
- One of: Title, Shulker, Wand Blueprint, Head of Demeter
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

#### Test 5.4: Ceres Wand Mythic Crafting

**Setup**: Player has `ceres_wand_blueprint` + 4x `demeter_mythic_fragment` + 4x diamond blocks

**Steps**:
1. Right-click blueprint or fragment to open Mythic Forge GUI
2. Verify recipe layout shows correct ingredients
3. Click result slot (slot 26) to craft

**Expected**:
- Ingredients consumed from inventory
- Ceres Wand given to player
- `ceres.item.wand` flag set
- Server-wide announcement sent

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

### Phase 5B: Mythic Crafting System

#### Test 5B.1: Fragment Right-Click Opens Recipe

**Steps**:
1. Give player Demeter Mythic Fragment (`/ex give demeter_mythic_fragment`)
2. Right-click in hand

**Expected**:
- Mythic Forge GUI opens
- Shows Ceres Wand recipe: 4x Diamond Block + 4x Fragment + 1x Blueprint = Ceres Wand
- Result slot shows "Click to craft!" in lore

**Pass/Fail**: ___

---

#### Test 5B.2: Blueprint Right-Click Opens Recipe

**Steps**:
1. Give player Ceres Wand Blueprint (`/ex give ceres_wand_blueprint`)
2. Right-click in hand

**Expected**:
- Same Mythic Forge GUI as fragment
- Shows matching recipe

**Pass/Fail**: ___

---

#### Test 5B.3: Craft With Missing Ingredients

**Steps**:
1. Open recipe GUI via fragment/blueprint
2. Click result slot with no ingredients

**Expected**:
- Error message listing missing ingredients with counts
- Items NOT consumed
- GUI stays open

**Pass/Fail**: ___

---

#### Test 5B.4: Successful Craft

**Setup**: Give player 1x ceres_wand_blueprint, 4x demeter_mythic_fragment, 4x diamond_block

**Steps**:
1. Right-click fragment or blueprint
2. Click result slot

**Expected**:
- All ingredients consumed (1 blueprint, 4 fragments, 4 diamond blocks)
- Ceres Wand given to player
- GUI closes
- Title display: "ITEM FORGED" / "Ceres Wand"
- Server announcement: "MYTHIC FORGE! PlayerName forged Ceres Wand!"
- `ceres.item.wand` flag set to true

**Pass/Fail**: ___

---

#### Test 5B.5: Duplicate Craft Prevention

**Setup**: Player already has `ceres.item.wand` flag set

**Steps**:
1. Give ingredients and open recipe GUI
2. Click result slot

**Expected**:
- Message: "You already own this item!"
- Ingredients NOT consumed
- Result slot shows "You already own this item!" in lore

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
- `emblem.rank` incremented
- Server announcement
- Particle effects

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

#### Test 7.1: Active Emblem Display

**Setup**: Player has emblem set to DEMETER

**Steps**:
1. Run `/profile`
2. Check GUI display

**Expected**:
- Shows "Active Emblem: Demeter"
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

#### Test 8.2: Emblem Switch Mid-Activity

**Steps**:
1. Start harvesting wheat as DEMETER emblem
2. Switch to HEPHAESTUS mid-harvest
3. Continue harvesting
4. Switch back to DEMETER
5. Harvest more

**Expected**:
- Counters only increment when emblem = DEMETER
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
- Emblem preserved
- Components preserved

**Pass/Fail**: ___

---

#### Test 8.4: Concurrent Activity Tracking

**Steps**:
1. As DEMETER emblem, perform all 3 activities simultaneously:
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

### Phase 9: Migration Testing

#### Test 9.1: Migration from Old Role System

**Setup**: Player has old flags:
- `role.active` = `FARMING`
- `role.changed_before` = `true`

**Steps**:
1. Player joins server (triggers migration)
2. Check new flags

**Expected**:
- `emblem.active` = `DEMETER`
- `emblem.changed_before` = `true`
- `emblem.migrated` = `true`
- Old `role.active` and `role.changed_before` flags removed

**Pass/Fail**: ___

---

#### Test 9.2: Migration Value Mapping

**Setup**: Test each old value maps correctly

**Expected Mappings**:
- `FARMING` -> `DEMETER`
- `MINING` -> `HEPHAESTUS`
- `COMBAT` -> `HERACLES`

**Pass/Fail**: ___

---

#### Test 9.3: Migration Idempotency

**Setup**: Player already has `emblem.migrated` = `true`

**Steps**:
1. Player joins server again
2. Check flags unchanged

**Expected**:
- Migration does NOT run again
- No duplicate flag writes

**Pass/Fail**: ___

---

#### Test 9.4: Migration for New Players

**Setup**: Fresh player with no emblem flags

**Steps**:
1. Player joins server
2. Check flags

**Expected**:
- No `emblem.active` set (player must visit Promachos)
- `emblem.migrated` NOT set (nothing to migrate)
- No errors

**Pass/Fail**: ___

---

### Phase 10: Rank Admin Testing

#### Test 10.1: Set Emblem Rank

**Steps**:
1. Run `/rankadmin Notch set 3`
2. Check player's `emblem.rank` flag

**Expected**:
- `emblem.rank` = `3`
- Confirmation message displayed

**Pass/Fail**: ___

---

#### Test 10.2: Reset Emblem Rank

**Steps**:
1. Run `/rankadmin Notch reset`
2. Check player's `emblem.rank` flag

**Expected**:
- `emblem.rank` removed/reset to 0
- Confirmation message displayed

**Pass/Fail**: ___

---

## Regression Tests (After Updates)

After any code changes, re-run:
- Test 2.1, 2.2 (Emblem gating)
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
- Emblem gating enforcement
