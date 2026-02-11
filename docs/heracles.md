# Heracles Combat Progression - Complete Specification

## Overview

**Heracles** (Ἡρακλῆς) is the greatest of Greek heroes, known for strength, courage, and combat prowess.

Players with the **HERACLES** emblem active earn progress toward Heracles' emblem through three village-defense activities:
1. Killing pillagers
2. Completing raids
3. Trading emeralds with villagers

Each activity has:
- A **key threshold**: Awards Heracles Keys at regular intervals
- A **component milestone**: Awards component item once at high count

---

## Emblem Requirement

**CRITICAL**: All Heracles tracking ONLY occurs when:
```
<player.flag[emblem.active]> == HERACLES
```

If player has any other emblem active, NO counters increment, NO keys drop, NO components awarded.

Players may still:
- Use Heracles Keys (open crates)
- Trade Heracles items
- View progress in profile

---

## Activities

### Activity 1: Slay Pillagers

**Description**: Kill pillagers (illager patrol units)

**Tracking**:
- Event: `after player kills pillager`
- Emblem gate: `<player.flag[emblem.active]> == HERACLES`

**Counter Flag**: `heracles.pillagers.count`

**Key Threshold**: Every 100 pillagers
- Flag: `heracles.pillagers.keys_awarded`
- Logic:
  ```
  current_count = pillagers.count
  keys_earned_so_far = pillagers.keys_awarded
  keys_should_have = floor(current_count / 100)
  if keys_should_have > keys_earned_so_far:
      award (keys_should_have - keys_earned_so_far) keys
      set keys_awarded = keys_should_have
  ```

**Component Milestone**: 2,500 pillagers
- Flag: `heracles.component.pillagers` (boolean)
- Award: Pillager Slayer Component
- Once-only: Check if `heracles.component.pillagers` is false before awarding

**Feedback**:
- On key award:
  ```
  <&c><&l>HERACLES KEY!<&r> <&7>Pillagers slain: <&a><count><&7>/2500
  ```
  - Sound: `entity_experience_orb_pickup`

- On component milestone:
  ```
  <&4><&l>MILESTONE!<&r> <&c>Pillager Slayer Component obtained! <&7>(2,500 pillagers)
  ```
  - Sound: `ui_toast_challenge_complete`
  - Server announce:
    ```
    <&c>[Promachos]<&r> <&f><player.name> <&7>has obtained the <&4>Pillager Slayer Component<&7>!
    ```

**Edge Cases**:
- Only pillagers count (not vindicators, evokers, ravagers)
- Must be player kill (not environment, not other players)
- Works in any dimension/location

---

### Activity 2: Complete Raids

**Description**: Successfully defend villages from raids

**Tracking**:
- Event: `on raid finishes`
- Condition: `<context.raid.heroes.contains[<player>]>` (player participated)
- Emblem gate: `<player.flag[emblem.active]> == HERACLES`

**Counter Flag**: `heracles.raids.count`

**Key Threshold**: 2 keys per raid
- Flag: `heracles.raids.keys_awarded` (tracks total raids)
- Award: 2 Heracles Keys immediately on each raid completion

**Component Milestone**: 50 raids
- Flag: `heracles.component.raids`
- Award: Raid Victor Component
- Once-only check

**Feedback**:
- On raid completion:
  ```
  <&c><&l>RAID VICTORY!<&r> <&7>+2 Heracles Keys
  <&7>Raids completed: <&a><count><&7>/50
  ```
  - Sound: `ui_toast_challenge_complete`

- On component milestone:
  ```
  <&4><&l>MILESTONE!<&r> <&c>Raid Victor Component obtained! <&7>(50 raids)
  ```
  - Server announce

**Edge Cases**:
- Player must be present when raid finishes (in hero list)
- Raid difficulty/level doesn't matter for component progress
- Losing a raid awards nothing
- Heroes list includes all players who damaged raid mobs

---

### Activity 3: Trade with Villagers

**Description**: Spend emeralds trading with villagers

**Tracking**:
- Event: `after player trades`
- Extraction: Count emeralds in `<context.recipe.inputs>` or track pre/post emerald count
- Emblem gate: `<player.flag[emblem.active]> == HERACLES`

**Counter Flag**: `heracles.emeralds.count`

**Key Threshold**: Every 100 emeralds spent
- Flag: `heracles.emeralds.keys_awarded`
- Logic: Same as pillagers (multiples of 100)

**Component Milestone**: 10,000 emeralds spent
- Flag: `heracles.component.emeralds`
- Award: Trade Master Component
- Once-only check

**Feedback**:
- On key award:
  ```
  <&c><&l>HERACLES KEY!<&r> <&7>Emeralds spent: <&a><count><&7>/10000
  ```

- On component milestone:
  ```
  <&4><&l>MILESTONE!<&r> <&c>Trade Master Component obtained! <&7>(10,000 emeralds)
  ```
  - Server announce

**Edge Cases**:
- Only emeralds SPENT count (not received from selling)
- Trading with wandering traders: COUNTS
- Trading in any dimension: COUNTS
- Multi-emerald trades count full amount (e.g., 12 emerald trade = +12)

---

## Heracles Key

### Item Definition

**Material**: `TRIPWIRE_HOOK`

**Display Name**: `<&c><&l>HERACLES KEY<&r>`

**Lore**:
```
<&c>HEROIC

<&7>A crimson key blessed by
<&7>the greatest of Greek heroes.

<&e>Right-click to open a
<&e>Heracles Crate.
```

**NBT**:
- Enchantment: `mending:1` with `HIDE_ENCHANTS` flag (glint effect)
- Custom model data: Optional (for texture pack)

**Stackable**: Yes (normal item stack)

**Tradeable**: Yes

**Use**: Right-click (any location, any time) to open Heracles Crate

---

## Component Items

Components implemented as **flags only** (no physical items). Display in profile GUI.

### Pillager Slayer Component

**Flag**: `heracles.component.pillagers: true`

**Display in GUI**:
```
<&4><&l>Pillager Slayer Component
<&7>Symbol of 2,500 pillagers slain.
<&7>Required for Heracles' Emblem.

<&8><&o>Obtained: <date>
```

---

### Raid Victor Component

**Flag**: `heracles.component.raids: true`

**Display in GUI**:
```
<&4><&l>Raid Victor Component
<&7>Symbol of 50 raids defended.
<&7>Required for Heracles' Emblem.

<&8><&o>Obtained: <date>
```

---

### Trade Master Component

**Flag**: `heracles.component.emeralds: true`

**Display in GUI**:
```
<&4><&l>Trade Master Component
<&7>Symbol of 10,000 emeralds spent.
<&7>Required for Heracles' Emblem.

<&8><&o>Obtained: <date>
```

---

## Progress Display (Profile GUI)

### Heracles Section

Show in `/profile` GUI when emblem = HERACLES (or always, grayed out if inactive):

**Title**: `Heracles - Hero of Olympus`

**Active Emblem Indicator**:
- If active: `<&a>● ACTIVE`
- If inactive: `<&8>○ Inactive`

**Progress Bars**:

```
Pillagers: [████░░░░░░] 1,247 / 2,500  (50%)
  ├─ Keys earned: 12
  └─ Component: ✗ Not yet obtained

Raids: [██████████] 50 / 50  (100%)
  ├─ Keys earned: 100
  └─ Component: ✓ OBTAINED

Emeralds: [███░░░░░░░] 3,420 / 10,000  (34%)
  ├─ Keys earned: 34
  └─ Component: ✗ Not yet obtained
```

**Emblem Status**:
- If all components: `<&e>⚠ READY TO UNLOCK!` (clickable → Promachos)
- If incomplete: `<&7>In Progress (1/3 components)`
- If unlocked: `<&a>✓ UNLOCKED`

---

## Heracles Crate System

### Tier Structure (Standard Crates)

| Tier | Probability | Color | Rewards |
|------|------------|-------|---------|
| MORTAL | 56% (55%*) | <&f>White | Basic combat supplies |
| HEROIC | 26% | <&e>Yellow | Mid-tier combat items |
| LEGENDARY | 12% | <&6>Gold | High-tier items, rare materials |
| MYTHIC | 5% | <&d>Magenta | Unique items, titles |
| OLYMPIAN | 1% (2%*) | <&b>Cyan | Meta-progression keys (Mars) |

*With Heracles emblem unlocked, OLYMPIAN increases to 2% (MORTAL loses 1%).

### Heracles Crate

**Key:** `heracles_key` (tripwire_hook)

**Animation:**
- 3-phase scrolling animation (~4.75 seconds)
- Same pattern as Demeter crate
- Phase 1: Fast scroll (20 cycles, 2t each)
- Phase 2: Medium scroll (10 cycles, 3t each)
- Phase 3: Slow scroll (5 cycles, 5t each)
- Final landing with item reveal
- **Color theme**: Dark red/crimson border (instead of yellow)

**Early Close:**
- Players can close inventory anytime
- Loot is pre-rolled before animation starts
- Closing early awards loot immediately and stops animation
- No duplicate awards

---

## Loot Tables

### MORTAL Tier (56% / 55% with emblem)

Equally weighted within tier (7 entries):

| Item | Quantity | Display Name |
|------|----------|--------------|
| Arrow | 8 | `Arrow x8` |
| Gunpowder | 4 | `Gunpowder x4` |
| Bread | 8 | `Bread x8` |
| Iron Ingot | 4 | `Iron Ingot x4` |
| Emerald | 8 | `Emerald x8` |
| Bone | 16 | `Bone x16` |
| Leather | 4 | `Leather x4` |

---

### HEROIC Tier (26% total)

Equally weighted within tier (5 entries):

| Item | Quantity | Display Name |
|------|----------|--------------|
| Golden Carrot | 8 | `Golden Carrot x8` |
| Emerald | 16 | `Emerald x16` |
| Gold Block | 1 | `Gold Block` |
| Experience | 100 XP | N/A (direct grant) |
| Ender Pearl | 2 | `Ender Pearl x2` |

---

### LEGENDARY Tier (12% total)

Equally weighted within tier (4 entries):

| Item | Quantity | Display Name |
|------|----------|--------------|
| Golden Apple | 2 | `Golden Apple x2` |
| Heracles Key | 2 | `<&c><&l>HERACLES KEY` |
| Emerald Block | 6 | `Emerald Block x6` |
| Experience | 250 XP | N/A (direct grant) |

**Note**: "Heracles Keys x2" means player gets 2 keys back (net +1 since they spent 1)

---

### MYTHIC Tier (5% total)

Equally weighted within tier (6 entries):

| Item | Quantity | Display Name |
|------|----------|--------------|
| Enchanted Golden Apple | 1 | `Enchanted Golden Apple` |
| Heracles Sword | 1 | `<&c><&l>HERACLES SWORD` (custom) |
| Heracles Blessing | 1 | `<&c><&l>HERACLES BLESSING` (custom) |
| Heracles Title | 1 | `Hero of Olympus` (unlock) |
| Gold Block | 16 | `Gold Block x16` |
| Emerald Block | 16 | `Emerald Block x16` |

**Custom Items**:
- **Heracles Sword**: Diamond sword, Unbreakable, mythic rarity
- **Heracles Blessing**: Consumable item (see below)
- **Heracles Title**: Unlocks `<&4>[Hero of Olympus]<&r>` chat prefix

### MYTHIC Pool Addition: Heracles Mythic Fragment

The Heracles base crate MYTHIC tier can also drop a **Heracles Mythic Fragment** — a crafting ingredient used in the Mythic Forge system. Players combine 4 fragments with a Mars Shield Blueprint and 4 Diamond Blocks to forge a Mars Shield.

---

### OLYMPIAN Tier (1% / 2% with emblem)

Only one entry:

| Item | Quantity | Display Name |
|------|----------|--------------|
| Mars Key | 1 | `<&4><&l>MARS KEY` (custom) |

**100% chance** when OLYMPIAN tier rolled

**Mars Key**: Opens Mars Crate (see mars section below)

---

## Custom Items

### Heracles Sword (MYTHIC)

**Material**: `DIAMOND_SWORD`

**Display Name**: `<&c><&l>HERACLES SWORD<&r>`

**Lore**:
```
<&c>MYTHIC

<&7>A diamond blade blessed by
<&7>Heracles, unbreakable and eternal.

<&8>Unbreakable
```

**NBT**:
- Unbreakable: true
- Enchantment: `mending:1` (hidden, for glint)

**Mechanics**: Standard sword, no special behavior (cosmetic/prestige item)

---

### Heracles Blessing (MYTHIC)

**Material**: `ENCHANTED_BOOK`

**Display Name**: `<&c><&l>HERACLES BLESSING<&r>`

**Lore**:
```
<&c>MYTHIC

<&7>A divine blessing from the
<&7>greatest of Greek heroes.

<&e>Right-click to boost all
<&e>incomplete Heracles activities
<&e>by 10% of their requirement.

<&8>Single-use consumable
```

**Boost Amounts**:
- Pillagers: +250 (10% of 2,500)
- Raids: +5 (10% of 50)
- Emeralds: +1,000 (10% of 10,000)

**Use**: Right-click to consume

**Event**:
```yaml
on player right clicks block with:heracles_blessing:
- determine cancelled passively
- take item:heracles_blessing quantity:1

# Apply boosts to incomplete activities only
- if !<player.has_flag[heracles.component.pillagers]>:
    - flag player heracles.pillagers.count:+:250
    - narrate "<&e>+250 pillager progress"

- if !<player.has_flag[heracles.component.raids]>:
    - flag player heracles.raids.count:+:5
    - narrate "<&e>+5 raid progress"

- if !<player.has_flag[heracles.component.emeralds]>:
    - flag player heracles.emeralds.count:+:1000
    - narrate "<&e>+1,000 emerald progress"

- title "title:<&c><&l>HERACLES' BLESSING" subtitle:<&e>Divine boost applied
- playsound <player> sound:block_beacon_activate
```

---

### Heracles Title (MYTHIC)

**Not a physical item** - flag-based cosmetic unlock

**Flag**: `heracles.item.title: true`

**Title Text**: `<&4>[Hero of Olympus]<&r>`

**Display**: Prefix in chat

**Example**:
```
<&4>[Hero of Olympus]<&r> PlayerName: Hello!
```

**Chat Integration**:
```yaml
heracles_title_chat:
    type: world
    events:
        on player chats:
        - if <player.has_flag[heracles.item.title]>:
            - determine passively cancelled
            - announce "<&4>[Hero of Olympus]<&r> <player.display_name><&7>: <context.message>"
```

---

## Mars Meta-Progression

**Mars** is the Roman god of war (equivalent to Greek Ares, thematically aligned with Heracles).

### Mars Key

**Material**: `NETHER_STAR`

**Display Name**: `<&4><&l>MARS KEY<&r>`

**Lore**:
```
<&4>OLYMPIAN

<&7>A key forged in the Roman forge,
<&7>where Mars guards his most
<&7>deadly and finite treasures.

<&e>Right-click to unlock
<&e>a Mars Crate.

<&8>50% God Apple / 50% Unique Item
```

**NBT**: Glint

**Use**: Right-click to open Mars Crate (50/50 logic, finite items)

**Source**: 1% drop from Heracles Crate (OLYMPIAN tier only, 2% with emblem unlocked)

---

### Mars Crate - 50/50 System

**Same logic as Ceres**: 50% Enchanted Golden Apple, 50% unique item from finite pool

**Finite Item Pool (4 items)**:

1. **Head of Heracles** (Player head collectible)
2. **Mars Title** (Cosmetic chat title unlock: `<&4>[Mars' Chosen]`)
3. **Gray Shulker Box** (Standard shulker box item)
4. **Mars Shield** (Shield with active resistance buff, via Blueprint + Mythic Crafting)

**Mechanics**:
- 50% chance: High-tier combat reward (Enchanted Golden Apple)
- 50% chance: Unique item from pool (if not all obtained)
- Once all 4 items obtained → always god apple
- Tracks obtained items with flags: `mars.item.head`, `mars.item.title`, etc.

**Dark red/crimson border theme** (matches combat aesthetic)

---

## Mars Items

### 1. Head of Heracles (COLLECTIBLE)

**Material**: Player Head (custom texture)

**Display Name**: `<&c>Head of Heracles<&r>`

**Lore**:
```
<&7>A divine effigy of Heracles,
<&7>god of strength and heroes.

<&8>Decorative collectible
<&8>Unique - One per player
```

**Flag**: `mars.item.head`

**Purpose**: Rare collectible/decorative item

---

### 2. Mars Title (COSMETIC)

**Not a physical item**—this is a **flag-based unlock**.

**Flag**: `mars.item.title: true`

**Title Text**: `<&4>[Mars' Chosen]<&r>`

**Display**: Prefix in chat messages

**Example**:
```
<&4>[Mars' Chosen]<&r> <player.name>: Hello!
```

---

### 3. Gray Shulker Box (UTILITY)

**Material**: `GRAY_SHULKER_BOX`

**Display Name**: `<&8>Gray Shulker Box<&r>`

**Lore**:
```
<&7>A rare shulker box from
<&7>the Arena of Champions.

<&8>Standard shulker box
<&8>Unique - One per player
```

**NBT**: Standard shulker box (no special mechanics)

**Flag**: `mars.item.shulker`

---

### 4. Mars Shield (LEGENDARY)

**Material**: `SHIELD`

**Display Name**: `<&4><&l>MARS SHIELD<&r>`

**Lore**:
```
<&4>MYTHIC

<&7>A shield blessed by Mars,
<&7>granting divine protection.

<&e>Right-click to activate
<&e>Resistance I for 15 seconds

<&8>Cooldown: 3 minutes
<&8>Unbreakable
<&8>Unique - One per player
```

**NBT**:
- Unbreakable: true
- Enchantment: `mending:1` (hidden, for glint)

**Mechanics**:
```yaml
mars_shield_activate:
    type: world
    events:
        on player right clicks block with:mars_shield:
        - determine cancelled passively

        # Check cooldown
        - if <player.has_flag[mars.shield_cooldown]>:
            - define remaining <player.flag_expiration[mars.shield_cooldown].from_now.formatted>
            - narrate "<&c>Shield on cooldown: <[remaining]>"
            - playsound <player> sound:entity_villager_no
            - stop

        # Set cooldown
        - flag player mars.shield_cooldown expire:180s

        # Grant Resistance I for 15 seconds
        - cast resistance duration:15s amplifier:0 <player> no_icon no_ambient

        # Feedback
        - narrate "<&e>Mars' protection activated!"
        - playsound <player> sound:block_beacon_activate
        - playeffect effect:flame at:<player.location> quantity:30 offset:1.0
```

**Flag**: `mars.item.shield`

---

## Admin Commands

See `docs/testing.md` for full command list. Key commands:

### Set Counter
```
/heraclesadmin <player> set pillagers <count>
/heraclesadmin <player> set raids <count>
/heraclesadmin <player> set emeralds <count>
```

Sets counter directly. Does NOT auto-award keys or components (must manually trigger).

### Award Keys
```
/heraclesadmin <player> keys <amount>
```

Gives Heracles Key items directly.

### Toggle Component
```
/heraclesadmin <player> component pillagers <true|false>
/heraclesadmin <player> component raids <true|false>
/heraclesadmin <player> component emeralds <true|false>
```

Sets component flag.

### Reset All
```
/heraclesadmin <player> reset
```

Wipes ALL Heracles flags:
- Counters (pillagers/raids/emeralds)
- Keys awarded tracking
- Component flags
- Emblem unlock flag

---

## Event Handlers (Implementation)

### Pillager Tracking

```yaml
heracles_pillager_tracking:
    type: world
    events:
        after player kills pillager:
        - if <player.flag[emblem.active]> != HERACLES:
            - stop

        # Increment counter
        - flag player heracles.pillagers.count:++
        - define count <player.flag[heracles.pillagers.count]>

        # Check for key award (every 100)
        - define keys_awarded <player.flag[heracles.pillagers.keys_awarded].if_null[0]>
        - define keys_should_have <[count].div[100].round_down>
        - if <[keys_should_have]> > <[keys_awarded]>:
            - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
            - give heracles_key quantity:<[keys_to_give]>
            - flag player heracles.pillagers.keys_awarded:<[keys_should_have]>
            - narrate "<&c><&l>HERACLES KEY!<&r> <&7>Pillagers: <&a><[count]><&7>/2500"
            - playsound <player> sound:entity_experience_orb_pickup

        # Check for component milestone (2,500)
        - if <[count]> >= 2500 && !<player.has_flag[heracles.component.pillagers]>:
            - flag player heracles.component.pillagers:true
            - flag player heracles.component.pillagers_date:<util.time_now.format>
            - narrate "<&4><&l>MILESTONE!<&r> <&c>Pillager Slayer Component obtained!"
            - playsound <player> sound:ui_toast_challenge_complete
            - announce "<&c>[Promachos]<&r> <&f><player.name> <&7>obtained the <&4>Pillager Slayer Component<&7>!"
```

### Raid Tracking

```yaml
heracles_raid_tracking:
    type: world
    events:
        on raid finishes:
        - foreach <context.raid.heroes> as:hero:
            - if !<[hero].is_player>:
                - foreach next
            - if <[hero].flag[emblem.active]> != HERACLES:
                - foreach next

            # Increment counter
            - flag <[hero]> heracles.raids.count:++
            - define count <[hero].flag[heracles.raids.count]>

            # Award 2 keys per raid
            - give <[hero]> heracles_key quantity:2
            - narrate "<&c><&l>RAID VICTORY!<&r> <&7>+2 Heracles Keys" targets:<[hero]>
            - narrate "<&7>Raids completed: <&a><[count]><&7>/50" targets:<[hero]>
            - playsound <[hero]> sound:ui_toast_challenge_complete

            # Check for component milestone (50)
            - if <[count]> >= 50 && !<[hero].has_flag[heracles.component.raids]>:
                - flag <[hero]> heracles.component.raids:true
                - flag <[hero]> heracles.component.raids_date:<util.time_now.format>
                - narrate "<&4><&l>MILESTONE!<&r> <&c>Raid Victor Component obtained!" targets:<[hero]>
                - announce "<&c>[Promachos]<&r> <&f><[hero].name> <&7>obtained the <&4>Raid Victor Component<&7>!"
```

### Emerald Tracking

```yaml
heracles_emerald_tracking:
    type: world
    events:
        after player trades:
        - if <player.flag[emblem.active]> != HERACLES:
            - stop

        # Count emeralds in trade inputs
        - define emeralds_spent 0
        - foreach <context.recipe.inputs> as:input:
            - if <[input].material.name> == emerald:
                - define emeralds_spent <[emeralds_spent].add[<[input].quantity>]>

        - if <[emeralds_spent]> <= 0:
            - stop

        # Increment counter
        - flag player heracles.emeralds.count:+:<[emeralds_spent]>
        - define count <player.flag[heracles.emeralds.count]>

        # Check for key award (every 100)
        - define keys_awarded <player.flag[heracles.emeralds.keys_awarded].if_null[0]>
        - define keys_should_have <[count].div[100].round_down>
        - if <[keys_should_have]> > <[keys_awarded]>:
            - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
            - give heracles_key quantity:<[keys_to_give]>
            - flag player heracles.emeralds.keys_awarded:<[keys_should_have]>
            - narrate "<&c><&l>HERACLES KEY!<&r> <&7>Emeralds: <&a><[count]><&7>/10000"
            - playsound <player> sound:entity_experience_orb_pickup

        # Check for component milestone (10,000)
        - if <[count]> >= 10000 && !<player.has_flag[heracles.component.emeralds]>:
            - flag player heracles.component.emeralds:true
            - flag player heracles.component.emeralds_date:<util.time_now.format>
            - narrate "<&4><&l>MILESTONE!<&r> <&c>Trade Master Component obtained!"
            - playsound <player> sound:ui_toast_challenge_complete
            - announce "<&c>[Promachos]<&r> <&f><player.name> <&7>obtained the <&4>Trade Master Component<&7>!"
```

---

## Testing Scenarios

### Scenario 1: Fresh Player

1. Player selects Heracles emblem
2. Kill 100 pillagers → Receives 1 key
3. Kill 100 more → Receives 1 key (total 2 keys, 200 pillagers)
4. Continue to 2,500 → Receives Pillager Slayer Component + 25 keys total
5. Complete 1 raid → Receives 2 keys
6. Continue to 50 → Receives Raid Victor Component + 100 keys total
7. Spend 100 emeralds → Receives 1 key
8. Continue to 10,000 → Receives Trade Master Component + 100 keys total
9. Visit Promachos → Unlock Heracles emblem

### Scenario 2: Emblem Switching

1. Player has 500 pillagers with Heracles emblem (5 keys earned)
2. Switch to Demeter emblem
3. Kill 500 more pillagers → NO keys, counter stays 500
4. Switch back to Heracles emblem
5. Kill 1 pillager → Counter now 501, no new key (next key at 600)

### Scenario 3: Component Once-Only

1. Player reaches 2,500 pillagers → Component awarded
2. Player continues to 3,000 pillagers → NO second component
3. Counter continues to track for keys, but component flag remains true

### Scenario 4: Raid Heroes

1. 3 players defend village together
2. Raid finishes successfully
3. All 3 players with HERACLES emblem receive +2 keys and +1 raid count
4. Players with other emblems receive nothing

---

## Performance Considerations

- **Early exit**: Emblem gate checks first (cheapest operation)
- **No loops**: Single event, single increment, bounded math
- **Flag reads**: Use `.if_null[0]` to avoid errors on first access
- **Announcement spam**: Only on milestones (not every key)

---

## Future Enhancements

- **Leaderboards**: Top pillager slayers, raid defenders, traders
- **Seasonal bonuses**: Double progress weekends
- **Activity milestones**: Every 500 pillagers → bonus loot
- **Component variants**: Gold/Silver/Bronze tiers for different thresholds
