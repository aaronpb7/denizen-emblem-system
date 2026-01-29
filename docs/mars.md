# Mars Meta-Progression - Complete Specification

## Overview

**Mars** is the Roman god of war, representing **meta-progression**—a premium layer accessible only through rare Heracles Crate rolls.

**Access**: Obtain Mars Keys (1% drop from Heracles Crate OLYMPIAN tier)

**Mechanics**: 50/50 chance between god apple and finite unique items

**Goal**: Collect all 4 Mars items (one-time unlocks per player)

**Relationship**: Mars is to Heracles as Ceres is to Demeter (combat vs farming)

---

## Mars Key

### Item Definition

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

**NBT**:
- Enchantment: `mending:1` (hidden, for glint)
- Custom model data: Optional

**Stackable**: Yes

**Tradeable**: Yes

**Source**: 1% chance from Heracles Crate (OLYMPIAN tier only)

---

## Usage Mechanics

### Trigger

**Event**: `on player right clicks using:mars_key`

**Location**: Any location (not location-gated)

**Role**: No role requirement (usable regardless of active role)

**Consumption**: Remove 1 key from player's hand

---

## GUI Animation

**Title**: `Mars Arena - Opening...`

**Duration**: ~4.75 seconds (same as Demeter/Ceres pattern)

**Inventory**: 27 slots (3 rows)

**Border Color**: Dark red/crimson stained glass panes (combat theme)

### Animation Sequence

**Phase 1: Opening (0.0s - 0.5s)**
- All slots filled with crimson/red stained glass panes
- Title: `Mars Arena - Opening...`

**Phase 2: Cycling (0.5s - 1.5s)**
- Center slot (14) alternates between enchanted golden apple and "?" icon
- Creates suspense for 50/50 outcome
- Border panes shimmer (optional: cycle through red/dark_red)

**Phase 3: Outcome Reveal (1.5s - 2.0s)**
- Stop cycling
- Replace center with actual loot item
- Update title: `Mars Arena - <outcome>!`

**Phase 4: Loot Award (2.0s)**
- Give item to player
- Play sound
- Wait 1s for player to see item
- Close GUI

### Sounds

- **Opening**: `block_ender_chest_open`
- **Cycling**: `block_beacon_ambient` (quiet, looping)
- **God Apple**: `entity_player_levelup`
- **Unique Item**: `ui_toast_challenge_complete` + `entity_wither_spawn` (layered, combat theme)

---

## Loot Logic: 50/50 System

### Two Paths

**Path A: God Apple (50% base chance)**
- Award: 1 Enchanted Golden Apple
- Always available

**Path B: Unique Item (50% base chance)**
- Award: ONE item from the finite Mars item pool
- **Constraint**: Can only obtain each item ONCE per player
- **Progression tracking**: Items already obtained are removed from pool

### Finite Item Pool (4 items total)

1. **Mars Sword** (Netherite sword, lifesteal mechanic)
2. **Mars Title** (Cosmetic chat title unlock)
3. **Gray Shulker Box** (Standard shulker box item)
4. **Mars Shield** (Shield with active resistance buff)

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
1. Check Mars item completion:
   - Count items already obtained (check flags)
   - If count == 4: force Path A (god apple), skip roll

2. Roll 50/50:
   - Random 1-2
   - 1 = Path A (God Apple)
   - 2 = Path B (Unique Item)

3. Path A (God Apple):
   - Give 1 Enchanted Golden Apple
   - Narrate: "<&4>[MARS]<&r> Enchanted Golden Apple"
   - Sound: entity_player_levelup

4. Path B (Unique Item):
   - Get list of unobtained items (filter by flags)
   - Randomly select one from list
   - Award item (see item definitions below)
   - Flag as obtained (e.g., mars.item.sword = true)
   - Narrate: "<&4>[MARS]<&r> <&d><item_name><&r> <&e>UNIQUE ITEM!"
   - Sound: ui_toast_challenge_complete + entity_wither_spawn
   - Server announcement
```

### Script Example

```yaml
roll_mars_outcome:
    type: procedure
    debug: false
    script:
    # Check if all items obtained
    - define all_obtained true
    - if !<player.has_flag[mars.item.sword]>:
        - define all_obtained false
    - if !<player.has_flag[mars.item.title]>:
        - define all_obtained false
    - if !<player.has_flag[mars.item.shulker]>:
        - define all_obtained false
    - if !<player.has_flag[mars.item.shield]>:
        - define all_obtained false

    # If all obtained, force god apple
    - if <[all_obtained]>:
        - define result_map <map[type=GOD_APPLE;item=<item[enchanted_golden_apple]>;display=Enchanted Golden Apple]>
        - determine <[result_map]>

    # Roll 50/50
    - define roll <util.random.int[1].to[2]>

    # Path A: God Apple (roll = 1)
    - if <[roll]> == 1:
        - define result_map <map[type=GOD_APPLE;item=<item[enchanted_golden_apple]>;display=Enchanted Golden Apple]>
        - determine <[result_map]>

    # Path B: Unique Item (roll = 2)
    # Get unobtained items
    - define available <list>
    - if !<player.has_flag[mars.item.sword]>:
        - define available <[available].include[sword]>
    - if !<player.has_flag[mars.item.title]>:
        - define available <[available].include[title]>
    - if !<player.has_flag[mars.item.shulker]>:
        - define available <[available].include[shulker]>
    - if !<player.has_flag[mars.item.shield]>:
        - define available <[available].include[shield]>

    # Select random from available
    - define chosen <[available].random>

    # Build result map
    - choose <[chosen]>:
        - case sword:
            - define result_map <map[type=UNIQUE;item_id=sword;item=<item[mars_sword]>;display=Mars Sword]>
        - case title:
            - define result_map <map[type=UNIQUE;item_id=title;item=<item[book].with[display=<&4><&l>MARS TITLE<&r>;lore=<&7>Cosmetic unlock:|<&4>[Mars' Chosen]<&7> title]>;display=Mars Title]>
        - case shulker:
            - define result_map <map[type=UNIQUE;item_id=shulker;item=<item[gray_shulker_box]>;display=Gray Shulker Box]>
        - case shield:
            - define result_map <map[type=UNIQUE;item_id=shield;item=<item[mars_shield]>;display=Mars Shield]>

    - determine <[result_map]>
```

---

## Mars Items

### 1. Mars Sword (MYTHIC)

**Material**: `NETHERITE_SWORD`

**Display Name**: `<&4><&l>MARS SWORD<&r>`

**Lore**:
```
<&4>MYTHIC

<&7>A netherite blade blessed by
<&7>Mars, unbreakable and vampiric.

<&e>Heals 10% of damage dealt

<&8>Unbreakable
<&8>Unique - One per player
```

**NBT**:
- Unbreakable: true
- Enchantment: `mending:1` (hidden, for glint)

**Mechanics**: Lifesteal - player heals for 10% of damage dealt

**Implementation**:
```yaml
mars_sword_lifesteal:
    type: world
    debug: false
    events:
        after player damages entity with:mars_sword:
        # Calculate heal amount (10% of damage)
        - define heal <context.damage.mul[0.10]>

        # Heal player
        - heal <player> <[heal]>

        # Visual feedback
        - playeffect effect:heart at:<player.eye_location> quantity:3 offset:0.5
```

**Notes**:
- Works with any entity (mobs, players if PvP enabled, etc.)
- Healing is instant
- No cooldown (triggers on every hit)
- Stacks with rank buffs and other damage bonuses

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

**Implementation**: Chat event modification

```yaml
mars_title_chat:
    type: world
    debug: false
    events:
        on player chats:
        - if <player.has_flag[mars.item.title]>:
            - determine passively cancelled
            - announce "<&4>[Mars' Chosen]<&r> <player.display_name><&7>: <context.message>"
```

**Lore** (if shown in profile GUI):
```
<&d>COSMETIC UNLOCK

<&7>You bear the title of
<&4>Mars' Chosen<&7>,
<&7>a mark of combat mastery.

<&8>Unique - One per player
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

**Purpose**: Rare/cosmetic utility item (unique color)

**Flag**: `mars.item.shulker`

**Note**: If shulker boxes are common on your server, this serves as a collectible/completion item. The unique gray color is not otherwise obtainable in survival without dyeing a shulker.

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

**Mechanics**: Active ability - Right-click grants Resistance I for 15 seconds

**Implementation**:
```yaml
mars_shield_activate:
    type: world
    debug: false
    events:
        on player right clicks block with:mars_shield:
        - determine cancelled passively

        # Check cooldown
        - if <player.has_flag[mars.shield_cooldown]>:
            - define remaining <player.flag_expiration[mars.shield_cooldown].from_now.formatted>
            - narrate "<&c>Shield on cooldown: <[remaining]>"
            - playsound <player> sound:entity_villager_no
            - stop

        # Set cooldown (3 minutes = 180 seconds)
        - flag player mars.shield_cooldown expire:180s

        # Grant Resistance I for 15 seconds
        - cast resistance duration:15s amplifier:0 <player> no_icon no_ambient

        # Feedback
        - narrate "<&e>Mars' divine protection activated!"
        - playsound <player> sound:block_beacon_activate
        - playeffect effect:flame at:<player.location> quantity:30 offset:1.0

        # Optional: Title display
        - title "title:<&4>MARS' PROTECTION" subtitle:<&c>Resistance I for 15 seconds fade_in:5t stay:30t fade_out:10t
```

**Cooldown Management**:
- Flag: `mars.shield_cooldown`
- Duration: 180 seconds (3 minutes)
- Expires automatically via `expire:180s`

**Notes**:
- Resistance I = 20% damage reduction (amplifier 0)
- Effect is hidden (no particle spam)
- Can be used proactively before combat
- Does NOT stack with rank buffs (higher amplifier takes precedence)
- Can be activated while holding shield in either hand

---

## Progress Display (Profile GUI)

### Mars Section

Show Mars item checklist in `/profile` GUI:

**Title**: `Mars - Arena of Champions`

**Unlock Requirement**: Must have obtained at least 1 Mars Key (or opened 1 Mars Crate)

**Checklist**:
```
Mars Sword:         [✓] Obtained  /  [✗] Locked
Mars Title:         [✓] Obtained  /  [✗] Locked
Gray Shulker Box:   [✓] Obtained  /  [✗] Locked
Mars Shield:        [✓] Obtained  /  [✗] Locked

Progress: 2 / 4 items
```

**Completion Reward**: None (all items are rewards themselves)

**Cosmetic**: Profile GUI shows dark red badge if all 4 items obtained

---

## Admin Commands

See `docs/testing.md` for full list. Key commands:

### Give Mars Keys
```
/marsadmin <player> keys <amount>
```

### Toggle Item Obtained
```
/marsadmin <player> item sword <true|false>
/marsadmin <player> item title <true|false>
/marsadmin <player> item shulker <true|false>
/marsadmin <player> item shield <true|false>
```

### Reset All Mars Flags
```
/marsadmin <player> reset
```

### Simulate Roll
```
/testroll mars
```

Simulates a Mars crate roll for the executing player (does not consume key).

---

## Testing Scenarios

### Test 1: First Mars Key

1. Player obtains first Mars Key (from Heracles OLYMPIAN roll)
2. Right-click key
3. Roll: 50/50 → Path B (Unique Item)
4. Player has 0 items → All 4 available
5. Random selection: Mars Sword
6. Player receives sword + flag set
7. Message: "<&4>[MARS]<&r> <&d>Mars Sword<&r> <&e>UNIQUE ITEM!"

### Test 2: Second Key (God Apple)

1. Player has 1 item (sword)
2. Use second Mars Key
3. Roll: Path A → God Apple
4. Player receives enchanted golden apple
5. Message: "<&4>[MARS]<&r> Enchanted Golden Apple"

### Test 3: All Items Obtained

1. Player has all 4 items
2. Use Mars Key
3. Roll forced to Path A (no items left)
4. Player receives god apple
5. Message: "<&4>[MARS]<&r> Enchanted Golden Apple <&7>(All items obtained)"

### Test 4: Sword Lifesteal

1. Player holds Mars Sword
2. Attacks zombie dealing 10 damage
3. Player heals 1 HP (10% of 10)
4. Heart particles appear at player location

### Test 5: Shield Activation

1. Player right-clicks Mars Shield
2. Resistance I applied for 15 seconds
3. Flame particles spawn around player
4. Title displays protection message
5. Cooldown message if clicked again: "Shield on cooldown: 2m 45s"

### Test 6: Title Display

1. Player obtains Mars Title
2. Player types in chat: "Hello!"
3. Server broadcasts: "<&4>[Mars' Chosen]<&r> PlayerName<&7>: Hello!"

---

## Balance Considerations

### Mars Key Rarity

**Drop Rate**: 1% from Heracles Crates (OLYMPIAN tier)

**Expected Keys**:
- 100 Heracles Keys opened → ~1 Mars Key
- To obtain all 4 items:
  - Need ~8 Mars Keys (50% item rate → 4 items expected in 8 rolls)
  - Need ~800 Heracles Keys (8 Mars Keys × 100 Heracles Keys per Mars)

**Conclusion**: Mars items are **very rare**, suitable for long-term/endgame players

**Comparison to Ceres**:
- Same drop rate (1% OLYMPIAN)
- Same 50/50 system
- Same 4-item pool
- Same rarity tier

### Item Power Levels

- **Mars Sword**: Moderate combat utility (10% lifesteal is noticeable but not overpowered)
- **Mars Title**: Pure cosmetic, no gameplay impact
- **Gray Shulker**: Utility, standard item
- **Mars Shield**: Strong defensive utility (3min cooldown prevents spam)

**Verdict**: Mars items are **prestige/utility** more than raw power upgrades

**Comparison to Ceres**:
- Ceres: Farming convenience (auto-replant, bee summon)
- Mars: Combat survival (lifesteal, resistance buff)
- Both provide quality-of-life improvements within their role themes

---

## Future Enhancements

- **Mars Emblem**: If all 4 items obtained, unlock Mars emblem (separate from Heracles)
- **Mars Dialogue**: NPC encounter when first Mars item obtained
- **Mars Shop**: Trade Mars Keys for specific items (remove randomness)
- **More Items**: Expand pool to 8-10 items (longer progression)
- **Mars Challenges**: Special quests to earn bonus Mars Keys

---

## Comparison: Ceres vs Mars

| Aspect | Ceres (Farming) | Mars (Combat) |
|--------|----------------|---------------|
| **Source** | Demeter OLYMPIAN (1%) | Heracles OLYMPIAN (1%) |
| **System** | 50/50 (god apple / unique) | 50/50 (god apple / unique) |
| **Pool Size** | 4 items | 4 items |
| **Weapon** | Ceres Hoe (auto-replant) | Mars Sword (lifesteal) |
| **Title** | [Ceres' Chosen] (gold) | [Mars' Chosen] (dark red) |
| **Shulker** | Yellow | Gray |
| **Special** | Ceres Wand (bee summon) | Mars Shield (resistance buff) |
| **Theme** | Agriculture, growth | War, protection |
| **Border Color** | Cyan | Crimson/Dark Red |

---

## Flag Reference

### Mars Crate Flags
```
mars.crates_opened              # Total crates opened

# Unique Items (Finite Pool)
mars.item.sword                 # Boolean: Has Mars Sword
mars.item.title                 # Boolean: Has Mars Title
mars.item.shulker               # Boolean: Has Gray Shulker
mars.item.shield                # Boolean: Has Mars Shield

# Meta Stats
mars.unique_items               # Count of unique items obtained (0-4)
mars.god_apples                 # Count of god apples received

# Shield Cooldown
mars.shield_cooldown            # Expires after 180s
```

---

## Implementation Files Structure

```
scripts/emblems/mars/
├── mars_crate.dsc              # 50/50 crate logic, GUI animation
├── mars_items.dsc              # Mars Sword, Shield, Title item definitions
└── mars_mechanics.dsc          # Lifesteal, shield activation, title chat
```

---

## Summary

The Mars Meta-Progression adds **meaningful endgame rewards** for dedicated combat players, with items that enhance survival and provide prestige.

Key design principles:
- **Mirrors Ceres structure**: Same 50/50 system, 4 finite items
- **Combat-themed**: Lifesteal sword, resistance shield, war titles
- **Ultra-rare**: ~800 Heracles Keys needed on average to complete
- **Quality-of-life**: Items provide utility, not raw power
- **Cosmetic prestige**: Mars' Chosen title marks elite players
- **Parallel to Heracles**: Both systems coexist without interfering

This system transforms COMBAT from a role into a **complete progression path** with aspirational meta-rewards.
