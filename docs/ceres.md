# Ceres Meta-Progression - Complete Specification

## Overview

**Ceres** is the Roman goddess of agriculture, equivalent to Greek Demeter. In the emblem system, Ceres represents **meta-progression**—a premium layer accessible only through rare Demeter Crate rolls.

**Access**: Obtain Ceres Keys (1% drop from Demeter Crate OLYMPIAN tier, 2% with Demeter emblem unlocked)

**Mechanics**: 50/50 chance between god apple and finite unique items

**Goal**: Collect all 4 Ceres items: Title, Shulker, Wand (via Blueprint + Crafting), Head of Demeter

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

**Title**: `Ceres Grove - Opening...`

**Duration**: 2 seconds

**Inventory**: 27 slots (3 rows)

### Animation Sequence

**Phase 1: Opening (0.0s - 0.5s)**
- All slots filled with cyan/light blue stained glass panes
- Title: `Ceres Grove - Opening...`

**Phase 2: Cycling (0.5s - 1.5s)**
- Center slot (13) alternates between enchanted golden apple and "?" icon
- Creates suspense for 50/50 outcome
- Border panes shimmer (optional: cycle through white/light blue)

**Phase 3: Outcome Reveal (1.5s - 2.0s)**
- Stop cycling
- Replace center with actual loot item
- Update title: `Ceres Grove - <outcome>!`

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

1. **Head of Demeter** (Player head collectible)
2. **Ceres Title** (Cosmetic chat title unlock)
3. **Yellow Shulker Box** (Standard shulker box item)
4. **Ceres Wand** (Bee summoning staff) — obtained via **Blueprint + Mythic Crafting**, NOT direct drop

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
   - If wand rolled: give ceres_wand_blueprint, set ceres.item.wand flag
   - Flag as obtained (e.g., ceres.item.head = true)
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
    - if <player.has_flag[ceres.item.head]>:
        - define obtained <[obtained].include[head]>
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
    - define available <list[head|title|shulker|wand].exclude[<[obtained]>]>
    - define chosen <[available].random>

    # Award item
    - choose <[chosen]>:
        - case head:
            - give ceres_head_of_demeter
            - flag player ceres.item.head:true
            - narrate "<&b>[CERES]<&r> <&d>Head of Demeter<&r> <&e>UNIQUE ITEM!"
        - case title:
            - flag player ceres.item.title:true
            - narrate "<&b>[CERES]<&r> <&d>Ceres Title<&r> <&e>UNIQUE ITEM!"
        - case shulker:
            - give yellow_shulker_box
            - flag player ceres.item.shulker:true
            - narrate "<&b>[CERES]<&r> <&d>Yellow Shulker Box<&r> <&e>UNIQUE ITEM!"
        - case wand:
            - give ceres_wand_blueprint
            - flag player ceres.item.wand:true
            - narrate "<&b>[CERES]<&r> <&d>Ceres Wand Blueprint<&r> <&e>UNIQUE ITEM!"

    - playsound <player> sound:ui_toast_challenge_complete
    - playsound <player> sound:block_beacon_activate volume:0.5
    - announce "<&b>[CERES]<&r> <&f><player.name> <&7>obtained a unique Ceres item!"
```

---

## Ceres Items

### 1. Head of Demeter (COLLECTIBLE)

**Material**: Player Head (custom texture)

**Display Name**: `<&b>Head of Demeter<&r>`

**Lore**:
```
<&7>A divine effigy of Demeter,
<&7>goddess of the harvest.

<&8>Decorative collectible
<&8>Unique - One per player
```

**Flag**: `ceres.item.head`

**Purpose**: Rare collectible/decorative item

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
<&7>the Ceres Grove.

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

## Ceres Wand Bee Summon

### Mechanic

Right-click to summon **6 angry bees** that act as combat companions.

**Bee Behavior** (Advanced AI System):
- **Attack Assist**: Bees attack whatever the player attacks
- **Follow Owner**: Automatically teleport to player if >10 blocks away
- **Safety Mode**: Will NOT attack players, even when angry
- **Managed Lifecycle**: Auto-despawn after 30 seconds
- **Owner Tracking**: Each bee is bound to its summoner via UUID flags

**Cooldown**: 30 seconds per player

### Advanced Features

#### Follow Behavior
Bees automatically stay near their owner:
- **Distance Check**: Every second, check if bee is >10 blocks from owner
- **Auto-Teleport**: If too far, teleport to random offset near owner (2-block radius)
- **Prevents Loss**: Bees never get left behind in combat or exploration

#### Attack Assist System
Bees coordinate with player combat:
- **Event Trigger**: When player damages a monster entity
- **Bee Command**: All living bees from that player attack the same target
- **Validation**: Only attacks if bee is still spawned and properly flagged
- **Smart Targeting**: Ignores non-monster entities (doesn't waste AI on passive mobs)

#### Safety Protections
Multiple safeguards prevent friendly fire:
- **Player Target Block**: Bees explicitly blocked from targeting any player
- **Owner UUID Check**: Bees only respond to commands from their summoner
- **Managed Flag**: Only bees with `ceres.managed` flag are controlled (prevents affecting natural bees)

### Implementation

**Summon Handler:**
```yaml
ceres_wand_activate:
    type: task
    script:
        # Check cooldown
        - if <player.has_flag[ceres.wand_cooldown]>:
            - define remaining <player.flag_expiration[ceres.wand_cooldown].from_now.formatted>
            - narrate "<&c>Wand on cooldown: <[remaining]>"
            - playsound <player> sound:ENTITY_VILLAGER_NO
            - stop

        # Set cooldown
        - flag player ceres.wand_cooldown expire:30s

        # Clear previous bees list
        - flag player ceres.wand_bees:!

        # Summon 6 bees with advanced flagging
        - repeat 6:
            - define offset <location[0,0,0].random_offset[2,1,2]>
            - define spawn_loc <player.location.add[<[offset]>]>
            - spawn bee[angry=true] <[spawn_loc]> save:spawned_bee
            - define bee <entry[spawned_bee].spawned_entity>

            # Flag bee with management markers
            - flag <[bee]> ceres.managed:true
            - flag <[bee]> ceres.temporary:true expire:30s
            - flag <[bee]> ceres.owner:<player.uuid> expire:30s

            # Add to player's bee list
            - flag player ceres.wand_bees:->:<[bee]> expire:30s

        # Feedback
        - narrate "<&e>Ceres' bees swarm to your aid!"
        - playsound <player> sound:ENTITY_BEE_LOOP_AGGRESSIVE volume:1.0
        - playeffect effect:VILLAGER_HAPPY at:<player.location> quantity:30 offset:2.0
```

**Attack Assist Handler:**
```yaml
ceres_bee_attack_assist:
    type: world
    events:
        after player damages entity:
        # Only assist on monster targets
        - if !<context.entity.entity_type.is_monster>:
            - stop

        # Check if player has active bees
        - if !<player.has_flag[ceres.wand_bees]>:
            - stop

        # Command all valid bees to attack the target
        - foreach <player.flag[ceres.wand_bees]> as:bee:
            - if !<[bee].is_spawned.if_null[false]>:
                - foreach next
            - if !<[bee].has_flag[ceres.managed]>:
                - foreach next
            - if <[bee].flag[ceres.owner].if_null[none]> != <player.uuid>:
                - foreach next
            # Command bee to attack
            - attack <[bee]> target:<context.entity>
```

**Follow & Cleanup System:**
```yaml
ceres_bee_management:
    type: world
    events:
        on system time secondly every:1:
        # Follow logic - teleport distant bees
        - foreach <server.online_players> as:p:
            - if !<[p].has_flag[ceres.wand_bees]>:
                - foreach next
            - foreach <[p].flag[ceres.wand_bees]> as:bee:
                - if !<[bee].is_spawned.if_null[false]>:
                    - foreach next
                - if !<[bee].has_flag[ceres.managed]>:
                    - foreach next
                - if <[bee].flag[ceres.owner].if_null[none]> != <[p].uuid>:
                    - foreach next
                # Teleport if too far from owner
                - if <[bee].location.distance[<[p].location>]> > 10:
                    - define offset <location[0,0,0].random_offset[2,1,2]>
                    - teleport <[bee]> <[p].location.add[<[offset]>]>

        # Cleanup logic - remove expired bees
        - foreach <server.worlds> as:world:
            - foreach <[world].entities[bee]> as:bee:
                - if !<[bee].has_flag[ceres.managed]>:
                    - foreach next
                # If managed but temporary flag expired, remove
                - if !<[bee].has_flag[ceres.temporary]>:
                    - remove <[bee]>
```

**Player Protection:**
```yaml
ceres_bee_no_player_target:
    type: world
    events:
        on bee targets player:
        - if <context.entity.has_flag[ceres.managed]>:
            - determine cancelled
```

### Performance Considerations

**Tick System Impact:**
- Runs every second (not every tick) to check all active bees
- Only processes bees with `ceres.managed` flag (ignores natural bees)
- Cleanup automatically removes orphaned bees

**Worst Case Load:**
- 10 online players each with 6 bees = 60 bees managed
- 60 distance checks + potential teleports per second
- Minimal overhead (entities are cheap, teleport is instant)

**Recommendation:** System is optimized for typical server loads (1-20 players). No performance issues expected.

### Edge Cases

**Bee Death in Combat:**
- Bee dies naturally → Removed from entity list
- No cleanup needed (flag expires with entity)

**Player Logout:**
- Bees remain for 30s after owner logs out
- `ceres.temporary` flag expires → Cleanup removes them
- `ceres.wand_bees` flag on player expires naturally

**Dimension Changes:**
- Bees follow owner across dimensions (teleport works cross-world)
- If owner enters dimension bees can't enter (like End portal) → Bees despawn when temporary flag expires

**Cooldown Edge Case:**
- Summoning new bees clears old `ceres.wand_bees` list
- Old bees still exist but are no longer commanded
- Old bees despawn when their 30s expires

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

## Mythic Crafting Integration

The **Ceres Wand** is not a direct crate drop. Instead, the crate drops a **Ceres Wand Blueprint**, and the player must craft the final item using the Mythic Forge.

### Recipe: Ceres Wand

| Ingredient | Source | Quantity |
|---|---|---|
| Ceres Wand Blueprint | Ceres Crate (unique item roll) | 1 |
| Demeter Mythic Fragment | Demeter Base Crate (MYTHIC tier) | 4 |
| Diamond Block | Survival | 4 |

### How to Craft

1. Right-click the Blueprint or any Demeter Mythic Fragment to open the **Mythic Forge** GUI
2. The GUI shows the 3x3 recipe layout (display only, not a real crafting table)
3. Click the result item in slot 26 to craft
4. System validates all ingredients are in inventory
5. On success: ingredients consumed, Ceres Wand given, `ceres.item.wand` flag set, server-wide announcement

### Implementation

All Mythic Crafting logic lives in `scripts/emblems/core/crafting.dsc`.

---

## Progress Display (Profile GUI)

### Ceres Section

Show Ceres item checklist in `/profile` GUI:

**Title**: `Ceres - Roman Grove`

**Unlock Requirement**: Must have obtained at least 1 Ceres Key (or opened 1 Ceres Crate)

**Checklist**:
```
Head of Demeter:   [✓] Obtained  /  [✗] Locked
Ceres Title:       [✓] Obtained  /  [✗] Locked
Yellow Shulker:    [✓] Obtained  /  [✗] Locked
Ceres Wand:        [✓] Obtained  /  [✗] Locked (via Blueprint + Crafting)

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
/ceresadmin <player> item head <true|false>
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
5. Random selection: Head of Demeter
6. Player receives head + flag set
7. Message: "<&b>[CERES]<&r> <&d>Head of Demeter<&r> <&e>UNIQUE ITEM!"

### Test 2: Second Key (God Apple)

1. Player has 1 item (head)
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

### Test 4: Mythic Crafting (Ceres Wand)

1. Player has `ceres_wand_blueprint` + 4x `demeter_mythic_fragment` + 4x diamond blocks
2. Right-click blueprint or fragment to open Mythic Forge GUI
3. Click result slot (slot 26) to craft
4. Ingredients consumed, Ceres Wand given, flag set
5. Announcement: server-wide crafting message

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

**Drop Rate**: 1% from Demeter Crates (OLYMPIAN tier), 2% with Demeter emblem unlocked

**Expected Keys**:
- 100 Demeter Keys opened → ~1 Ceres Key
- To obtain all 4 items:
  - Need ~8 Ceres Keys (50% item rate → 4 items expected in 8 rolls)
  - Need ~800 Demeter Keys (8 Ceres Keys × 100 Demeter Keys per Ceres)

**Conclusion**: Ceres items are **very rare**, suitable for long-term/endgame players

### Item Power Levels

- **Head of Demeter**: Pure collectible, no gameplay impact
- **Title**: Pure cosmetic, no gameplay impact
- **Shulker**: Utility, standard item
- **Wand**: Moderate combat utility, 30s cooldown prevents spam (requires Mythic Crafting)

**Verdict**: Ceres items are **prestige/cosmetic** more than power upgrades

---

## Future Enhancements

- **Ceres Emblem**: If all 4 items obtained, unlock Ceres emblem (separate from Demeter)
- **Ceres Dialogue**: NPC encounter when first Ceres item obtained
- **Ceres Shop**: Trade Ceres Keys for specific items (remove randomness)
- **More Items**: Expand pool to 8-10 items (longer progression)
- **Ceres Challenges**: Special quests to earn bonus Ceres Keys
