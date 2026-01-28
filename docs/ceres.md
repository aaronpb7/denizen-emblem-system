# Ceres Meta-Progression - Complete Specification

## Overview

**Ceres** is the Roman goddess of agriculture, equivalent to Greek Demeter. In the emblem system, Ceres represents **meta-progression**—a premium layer accessible only through rare Demeter Crate rolls.

**Access**: Obtain Ceres Keys (1% drop from Demeter Crate OLYMPIAN tier)

**Mechanics**: 50/50 chance between god apple and finite unique items

**Goal**: Collect all 4 Ceres items (one-time unlocks per player)

---

## Ceres Key

### Item Definition

**Material**: `ECHO_SHARD` (or `NETHER_STAR` if visually preferred)

**Display Name**: `<&b><&l>CERES KEY<&r>`

**Lore**:
```
<&b>OLYMPIAN

<&7>A key forged in the Roman vault,
<&7>where Ceres guards her most
<&7>precious and finite treasures.

<&e>Right-click to unlock
<&e>a Ceres Crate.

<&8>50% God Apple / 50% Unique Item
```

**NBT**:
- Enchantment: `mending:1` (hidden, for glint)
- Custom model data: Optional

**Stackable**: Yes

**Tradeable**: Yes

**Source**: 1% chance from Demeter Crate (OLYMPIAN tier only)

---

## Usage Mechanics

### Trigger

**Event**: `on player right clicks using:ceres_key`

**Location**: Any location (not location-gated)

**Role**: No role requirement (usable regardless of active role)

**Consumption**: Remove 1 key from player's hand

---

## GUI Animation

**Title**: `Ceres Vault - Opening...`

**Duration**: 2 seconds

**Inventory**: 27 slots (3 rows)

### Animation Sequence

**Phase 1: Opening (0.0s - 0.5s)**
- All slots filled with cyan/light blue stained glass panes
- Title: `Ceres Vault - Opening...`

**Phase 2: Cycling (0.5s - 1.5s)**
- Center slot (13) alternates between enchanted golden apple and "?" icon
- Creates suspense for 50/50 outcome
- Border panes shimmer (optional: cycle through white/light blue)

**Phase 3: Outcome Reveal (1.5s - 2.0s)**
- Stop cycling
- Replace center with actual loot item
- Update title: `Ceres Vault - <outcome>!`

**Phase 4: Loot Award (2.0s)**
- Give item to player
- Play sound
- Wait 1s for player to see item
- Close GUI

### Sounds

- **Opening**: `block_ender_chest_open`
- **Cycling**: `block_beacon_ambient` (quiet, looping)
- **God Apple**: `entity_player_levelup`
- **Unique Item**: `ui_toast_challenge_complete` + `block_beacon_activate`

---

## Loot Logic: 50/50 System

### Two Paths

**Path A: God Apple (50% base chance)**
- Award: 1 Enchanted Golden Apple
- Always available

**Path B: Unique Item (50% base chance)**
- Award: ONE item from the finite Ceres item pool
- **Constraint**: Can only obtain each item ONCE per player
- **Progression tracking**: Items already obtained are removed from pool

### Finite Item Pool (4 items total)

1. **Ceres Hoe** (Netherite hoe, auto-replant mechanic)
2. **Ceres Title** (Cosmetic chat title unlock)
3. **Yellow Shulker Box** (Standard shulker box item)
4. **Ceres Wand** (Bee summoning staff)

### Progression Rules

**When player has 0-3 items**:
- Roll 50/50: God Apple vs. Unique Item
- If Unique Item path: Randomly select ONE item player does NOT have yet
- Award item, flag as obtained

**When player has all 4 items**:
- ALWAYS award God Apple (100% chance)
- Path B is disabled (no items left to obtain)

---

## Loot Distribution Algorithm

### Pseudocode

```
1. Check Ceres item completion:
   - Count items already obtained (check flags)
   - If count == 4: force Path A (god apple), skip roll

2. Roll 50/50:
   - Random 1-2
   - 1 = Path A (God Apple)
   - 2 = Path B (Unique Item)

3. Path A (God Apple):
   - Give 1 Enchanted Golden Apple
   - Narrate: "<&b>[CERES]<&r> Enchanted Golden Apple"
   - Sound: entity_player_levelup

4. Path B (Unique Item):
   - Get list of unobtained items (filter by flags)
   - Randomly select one from list
   - Award item (see item definitions below)
   - Flag as obtained (e.g., ceres.item.hoe = true)
   - Narrate: "<&b>[CERES]<&r> <&d><item_name><&r> <&e>UNIQUE ITEM!"
   - Sound: ui_toast_challenge_complete + block_beacon_activate
   - Optional: Server announcement
```

### Script Example

```yaml
ceres_crate_roll:
    type: task
    script:
    # Check completion
    - define obtained <list>
    - if <player.has_flag[ceres.item.hoe]>:
        - define obtained <[obtained].include[hoe]>
    - if <player.has_flag[ceres.item.title]>:
        - define obtained <[obtained].include[title]>
    - if <player.has_flag[ceres.item.shulker]>:
        - define obtained <[obtained].include[shulker]>
    - if <player.has_flag[ceres.item.wand]>:
        - define obtained <[obtained].include[wand]>

    # If all 4 obtained, force god apple
    - if <[obtained].size> == 4:
        - give enchanted_golden_apple
        - narrate "<&b>[CERES]<&r> Enchanted Golden Apple <&7>(All items obtained)"
        - playsound <player> sound:entity_player_levelup
        - stop

    # Roll 50/50
    - define roll <util.random.int[1].to[2]>

    # Path A: God Apple
    - if <[roll]> == 1:
        - give enchanted_golden_apple
        - narrate "<&b>[CERES]<&r> Enchanted Golden Apple"
        - playsound <player> sound:entity_player_levelup
        - stop

    # Path B: Unique Item
    - define available <list[hoe|title|shulker|wand].exclude[<[obtained]>]>
    - define chosen <[available].random>

    # Award item
    - choose <[chosen]>:
        - case hoe:
            - give ceres_hoe
            - flag player ceres.item.hoe:true
            - narrate "<&b>[CERES]<&r> <&d>Ceres Hoe<&r> <&e>UNIQUE ITEM!"
        - case title:
            - flag player ceres.item.title:true
            - narrate "<&b>[CERES]<&r> <&d>Ceres Title<&r> <&e>UNIQUE ITEM!"
        - case shulker:
            - give yellow_shulker_box
            - flag player ceres.item.shulker:true
            - narrate "<&b>[CERES]<&r> <&d>Yellow Shulker Box<&r> <&e>UNIQUE ITEM!"
        - case wand:
            - give ceres_wand
            - flag player ceres.item.wand:true
            - narrate "<&b>[CERES]<&r> <&d>Ceres Wand<&r> <&e>UNIQUE ITEM!"

    - playsound <player> sound:ui_toast_challenge_complete
    - playsound <player> sound:block_beacon_activate volume:0.5
    - announce "<&b>[CERES]<&r> <&f><player.name> <&7>obtained a unique Ceres item!"
```

---

## Ceres Items

### 1. Ceres Hoe (MYTHIC)

**Material**: `NETHERITE_HOE`

**Display Name**: `<&d><&l>CERES HOE<&r>`

**Lore**:
```
<&d>MYTHIC

<&7>A netherite hoe blessed by
<&7>Ceres, unbreakable and eternal.

<&e>Automatically replants crops
<&e>when harvested.

<&8>Unbreakable
<&8>Unique - One per player
```

**NBT**:
- Unbreakable: true
- Enchantment: `mending:1` (hidden, for glint)

**Mechanics**: See "Ceres Hoe Auto-Replant" section below

---

### 2. Ceres Title (COSMETIC)

**Not a physical item**—this is a **flag-based unlock**.

**Flag**: `ceres.item.title: true`

**Title Text**: `<&6>[Ceres' Chosen]<&r>` (or similar mythological title)

**Display**: Prefix in chat messages

**Example**:
```
<&6>[Ceres' Chosen]<&r> <player.name>: Hello!
```

**Implementation**: Chat event modification (see "Ceres Title Chat Integration" below)

**Lore** (if shown in profile GUI):
```
<&d>COSMETIC UNLOCK

<&7>You bear the title of
<&6>Ceres' Chosen<&7>,
<&7>a mark of agricultural mastery.

<&8>Unique - One per player
```

---

### 3. Yellow Shulker Box (ITEM)

**Material**: `YELLOW_SHULKER_BOX`

**Display Name**: `<&e>Yellow Shulker Box<&r>`

**Lore**:
```
<&7>A rare shulker box from
<&7>the Ceres Vault.

<&8>Standard shulker box
<&8>Unique - One per player
```

**NBT**: Standard shulker box (no special mechanics)

**Purpose**: Rare/cosmetic utility item, not available in survival otherwise (if shulker boxes are rare on server)

**Note**: If shulker boxes are common on your server, consider replacing with a different rare item (e.g., elytra, totem of undying, enchanted book with rare enchants)

---

### 4. Ceres Wand (LEGENDARY)

**Material**: `BLAZE_ROD` (or `STICK` with custom model)

**Display Name**: `<&d><&l>CERES WAND<&r>`

**Lore**:
```
<&d>MYTHIC

<&7>A staff imbued with the
<&7>protective fury of Ceres' bees.

<&e>Right-click to summon 6 angry
<&e>bees that attack nearby hostiles.

<&8>Cooldown: 30 seconds
<&8>Unique - One per player
```

**NBT**:
- Enchantment: `mending:1` (hidden, for glint)
- Unbreakable: true (does not consume durability)

**Mechanics**: See "Ceres Wand Bee Summon" section below

---

## Ceres Hoe Auto-Replant

### Mechanic

When player breaks a fully-grown crop while holding Ceres Hoe, the crop is **automatically replanted** at the same location.

**Supported Crops**:
- Wheat
- Carrots
- Potatoes
- Beetroots
- Nether Wart

### Implementation

**Event**: `after player breaks <crop>` with `hand:<context.item>` check

**Logic**:
```yaml
ceres_hoe_replant:
    type: world
    events:
        after player breaks wheat|carrots|potatoes|beetroots|nether_wart:
        # Check if holding Ceres Hoe
        - if <context.item.script.name.if_null[null]> != ceres_hoe:
            - stop

        # Check if fully grown (age 7 for wheat/carrots/potatoes/beetroots, age 3 for nether wart)
        - define material <context.location.material.name>
        - define age <context.location.material.age>

        - if <[material]> == nether_wart:
            - if <[age]> != 3:
                - stop
        - else:
            - if <[age]> != 7:
                - stop

        # Replant
        - wait 1t
        - modifyblock <context.location> <[material]>

        # Optional: Particle effect
        - playeffect effect:villager_happy at:<context.location> quantity:5 offset:0.3
```

**Notes**:
- `wait 1t` ensures block break completes before replanting
- Does NOT replant if crop not fully grown (allows early harvest without waste)
- Works with Demeter activity tracking (break event fires normally, then replant occurs)

---

## Ceres Wand Bee Summon

### Mechanic

Right-click to summon **6 angry bees** that attack nearby hostile mobs.

**Bees**:
- Angry state (attack hostiles)
- Spawn at player location with slight offset
- Targeting: Nearest hostile mobs within 16 blocks
- Despawn after 30 seconds
- Do NOT attack players or passive mobs

**Cooldown**: 30 seconds per player

### Implementation

```yaml
ceres_wand_use:
    type: world
    events:
        on player right clicks using:ceres_wand:
        # Check cooldown
        - if <player.has_flag[ceres.wand_cooldown]>:
            - define remaining <player.flag_expiration[ceres.wand_cooldown].from_now.formatted>
            - narrate "<&c>Wand on cooldown: <[remaining]>"
            - playsound <player> sound:entity_villager_no
            - determine cancelled
            - stop

        # Set cooldown
        - flag player ceres.wand_cooldown expire:30s

        # Summon 6 bees
        - repeat 6:
            - define offset <location[0,0,0].random_offset[2,1,2]>
            - define spawn_loc <player.location.add[<[offset]>]>
            - spawn bee[angry=true] <[spawn_loc]> save:bee_<[value]>
            - define bee <entry[bee_<[value]>].spawned_entity>

            # Flag bee as temporary
            - flag <[bee]> ceres.temporary expire:30s

            # Optional: Target nearest hostile
            - define hostiles <[spawn_loc].find_entities[hostile_mobs].within[16]>
            - if <[hostiles].size> > 0:
                - attack <[bee]> target:<[hostiles].first>

        # Feedback
        - narrate "<&e>Ceres' bees swarm to your defense!"
        - playsound <player> sound:entity_bee_loop_aggressive volume:1.0
        - playeffect effect:villager_happy at:<player.location> quantity:30 offset:2.0

        # Despawn after 30s
        - wait 30s
        - define all_bees <player.location.find_entities[bee].within[50].filter[has_flag[ceres.temporary]]>
        - foreach <[all_bees]>:
            - remove <[value]>
```

**Hostile Mob List**:
- Zombie, Skeleton, Creeper, Spider, Cave Spider, Enderman, Witch, Blaze, Wither Skeleton, etc.
- Use Denizen tag: `<location.find_entities[monster].within[16]>`

**Edge Cases**:
- Bees may die in combat before 30s → natural despawn
- If no hostiles nearby, bees wander aimlessly → despawn after 30s
- Wand does not consume durability (unbreakable)

---

## Ceres Title Chat Integration

### Mechanic

Players with `ceres.item.title: true` have a prefix in chat.

**Title Options**:
1. `<&6>[Ceres' Chosen]<&r>`
2. `<&e>[Harvester Supreme]<&r>`
3. `<&6>[Roman Farmer]<&r>`
4. `<&e>⚜<&r>` (symbol only, minimalist)

Recommend: **Option 1** (mythologically consistent)

### Implementation

**Event**: `on player chats`

```yaml
ceres_title_chat:
    type: world
    events:
        on player chats:
        - if <player.has_flag[ceres.item.title]>:
            - determine passively cancelled
            - announce "<&6>[Ceres' Chosen]<&r> <player.display_name><&7>: <context.message>"
```

**Optional**: Allow players to toggle title on/off via command (`/cerestitle toggle`)

---

## Progress Display (Profile GUI)

### Ceres Section

Show Ceres item checklist in `/profile` GUI:

**Title**: `Ceres - Roman Vault`

**Unlock Requirement**: Must have obtained at least 1 Ceres Key (or opened 1 Ceres Crate)

**Checklist**:
```
Ceres Hoe:         [✓] Obtained  /  [✗] Locked
Ceres Title:       [✓] Obtained  /  [✗] Locked
Yellow Shulker:    [✓] Obtained  /  [✗] Locked
Ceres Wand:        [✓] Obtained  /  [✗] Locked

Progress: 2 / 4 items
```

**Completion Reward**: None (all items are rewards themselves)

**Cosmetic**: Profile GUI shows gold badge if all 4 items obtained

---

## Admin Commands

See `docs/testing.md` for full list. Key commands:

### Give Ceres Keys
```
/ceresadmin <player> keys <amount>
```

### Toggle Item Obtained
```
/ceresadmin <player> item hoe <true|false>
/ceresadmin <player> item title <true|false>
/ceresadmin <player> item shulker <true|false>
/ceresadmin <player> item wand <true|false>
```

### Reset All Ceres Flags
```
/ceresadmin <player> reset
```

### Simulate Roll
```
/testroll ceres
```

Simulates a Ceres crate roll for the executing player (does not consume key).

---

## Testing Scenarios

### Test 1: First Ceres Key

1. Player obtains first Ceres Key (from Demeter OLYMPIAN roll)
2. Right-click key
3. Roll: 50/50 → Path B (Unique Item)
4. Player has 0 items → All 4 available
5. Random selection: Ceres Hoe
6. Player receives hoe + flag set
7. Message: "<&b>[CERES]<&r> <&d>Ceres Hoe<&r> <&e>UNIQUE ITEM!"

### Test 2: Second Key (God Apple)

1. Player has 1 item (hoe)
2. Use second Ceres Key
3. Roll: Path A → God Apple
4. Player receives enchanted golden apple
5. Message: "<&b>[CERES]<&r> Enchanted Golden Apple"

### Test 3: All Items Obtained

1. Player has all 4 items
2. Use Ceres Key
3. Roll forced to Path A (no items left)
4. Player receives god apple
5. Message: "<&b>[CERES]<&r> Enchanted Golden Apple <&7>(All items obtained)"

### Test 4: Hoe Auto-Replant

1. Player holds Ceres Hoe
2. Break fully-grown wheat
3. Wheat drops items (seeds + wheat)
4. 1 tick later, wheat replanted at same location (age 0)
5. Particle effect plays

### Test 5: Wand Bee Summon

1. Player right-clicks Ceres Wand
2. 6 bees spawn around player
3. Bees target nearest zombie
4. Cooldown message if clicked again: "Wand on cooldown: 25s"
5. After 30s, bees despawn (if still alive)

### Test 6: Title Display

1. Player obtains Ceres Title
2. Player types in chat: "Hello!"
3. Server broadcasts: "<&6>[Ceres' Chosen]<&r> PlayerName<&7>: Hello!"

---

## Balance Considerations

### Ceres Key Rarity

**Drop Rate**: 1% from Demeter Crates (OLYMPIAN tier)

**Expected Keys**:
- 100 Demeter Keys opened → ~1 Ceres Key
- To obtain all 4 items:
  - Need ~8 Ceres Keys (50% item rate → 4 items expected in 8 rolls)
  - Need ~800 Demeter Keys (8 Ceres Keys × 100 Demeter Keys per Ceres)

**Conclusion**: Ceres items are **very rare**, suitable for long-term/endgame players

### Item Power Levels

- **Hoe**: QoL (quality of life), saves replanting time but doesn't break balance
- **Title**: Pure cosmetic, no gameplay impact
- **Shulker**: Utility, standard item
- **Wand**: Moderate combat utility, 30s cooldown prevents spam

**Verdict**: Ceres items are **prestige/cosmetic** more than power upgrades

---

## Future Enhancements

- **Ceres Emblem**: If all 4 items obtained, unlock Ceres emblem (separate from Demeter)
- **Ceres Dialogue**: NPC encounter when first Ceres item obtained
- **Ceres Shop**: Trade Ceres Keys for specific items (remove randomness)
- **More Items**: Expand pool to 8-10 items (longer progression)
- **Ceres Challenges**: Special quests to earn bonus Ceres Keys
