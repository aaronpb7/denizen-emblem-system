# Vulcan Meta-Progression - Complete Specification

## Overview

**Vulcan** is the Roman god of fire and the forge, representing **meta-progression**—a premium layer accessible only through rare Hephaestus Crate rolls.

**Access**: Obtain Vulcan Keys (1% drop from Hephaestus Crate OLYMPIAN tier, 2% with Hephaestus emblem unlocked)

**Mechanics**: 50/50 chance between god apple and finite unique items

**Goal**: Collect all 4 Vulcan items: Title, Shulker, Pickaxe (via Blueprint + Crafting), Head of Hephaestus

**Relationship**: Vulcan is to Hephaestus as Ceres is to Demeter (mining vs farming)

---

## Vulcan Key

### Item Definition

**Material**: `NETHER_STAR`

**Display Name**: `<&8><&l>VULCAN KEY<&r>`

**Lore**:
```
<&8>OLYMPIAN

<&7>A key forged in the eternal flames,
<&7>where Vulcan guards his most
<&7>powerful and finite creations.

<&e>Right-click to unlock
<&e>a Vulcan Crate.

<&8>50% God Apple / 50% Unique Item
```

**NBT**:
- Enchantment: `mending:1` (hidden, for glint)
- Custom model data: Optional

**Stackable**: Yes

**Tradeable**: Yes

**Source**: 1% chance from Hephaestus Crate (OLYMPIAN tier only)

---

## Usage Mechanics

### Trigger

**Event**: `on player right clicks using:vulcan_key`

**Location**: Any location (not location-gated)

**Role**: No role requirement (usable regardless of active role)

**Consumption**: Remove 1 key from player's hand

---

## GUI Animation

**Title**: `Vulcan's Forge - Opening...`

**Duration**: ~4.75 seconds (same as other crates)

**Inventory**: 27 slots (3 rows)

**Border Color**: Gray stained glass panes (forge/metal theme)

### Animation Sequence

**Phase 1: Opening (0.0s - 0.5s)**
- All slots filled with gray stained glass panes
- Title: `Vulcan's Forge - Opening...`

**Phase 2: Cycling (0.5s - 1.5s)**
- Center slot (14) alternates between enchanted golden apple and "?" icon
- Creates suspense for 50/50 outcome
- Border panes shimmer (optional: cycle through gray/light_gray)

**Phase 3: Outcome Reveal (1.5s - 2.0s)**
- Stop cycling
- Replace center with actual loot item
- Update title: `Vulcan's Forge - <outcome>!`

**Phase 4: Loot Award (2.0s)**
- Give item to player
- Play sound
- Wait 1s for player to see item
- Close GUI

### Sounds

- **Opening**: `block_ender_chest_open`
- **Cycling**: `block_beacon_ambient` (quiet, looping)
- **God Apple**: `entity_player_levelup`
- **Unique Item**: `ui_toast_challenge_complete` + `block_anvil_use` (layered, forge theme)

---

## Loot Logic: 50/50 System

### Two Paths

**Path A: God Apple (50% base chance)**
- Award: 1 Enchanted Golden Apple
- Always available

**Path B: Unique Item (50% base chance)**
- Award: ONE item from the finite Vulcan item pool
- **Constraint**: Can only obtain each item ONCE per player
- **Progression tracking**: Items already obtained are removed from pool

### Finite Item Pool (4 items total)

1. **Vulcan Pickaxe** (Netherite pickaxe, auto-smelt toggle) — obtained via **Blueprint + Mythic Crafting**, not a direct drop
2. **Vulcan Title** (Cosmetic chat title unlock)
3. **Head of Hephaestus** (Player head collectible)
4. **Gray Shulker Box** (Standard shulker box item)

### Progression Rules

**When player has 0-3 items**:
- Roll 50/50: God Apple vs. Unique Item
- If Unique Item path: Randomly select ONE item player does NOT have yet
- Award item, flag as obtained

**When player has all 4 items**:
- ALWAYS award God Apple (100% chance)
- Path B is disabled (no items left to obtain)

---

## Vulcan Items

### 1. Vulcan Pickaxe (MYTHIC)

**Material**: `NETHERITE_PICKAXE`

**Display Name**: `<&8><&l>VULCAN PICKAXE<&r>`

**Obtained via**: Mythic Crafting (Blueprint from Vulcan Crate + 4x Hephaestus Mythic Fragment + 4x Diamond Block)

**Lore**:
```
<&d>MYTHIC

<&7>A netherite pickaxe forged by
<&7>Vulcan, unbreakable and magical.

<&e>Right-click to toggle auto-smelt
<&e>(works on iron and gold ore)

<&8>Unbreakable
<&8>Unique - One per player
```

**NBT**:
- Unbreakable: true
- Enchantment: `mending:1` (hidden, for glint)

**Mechanics**: Right-click toggles auto-smelt mode
- When enabled: Iron ore drops iron ingots, gold ore drops gold ingots
- Only affects iron_ore, deepslate_iron_ore, gold_ore, deepslate_gold_ore
- Toggle persists via player flag

**Implementation**:
```yaml
vulcan_pickaxe_toggle:
    type: world
    debug: false
    events:
        on player right clicks block with:vulcan_pickaxe:
        - determine cancelled passively
        - if <player.has_flag[vulcan.autosmelt]>:
            - flag player vulcan.autosmelt:!
            - narrate "<&7>Auto-smelt <&c>disabled"
            - playsound <player> sound:block_fire_extinguish
        - else:
            - flag player vulcan.autosmelt:true
            - narrate "<&7>Auto-smelt <&a>enabled"
            - playsound <player> sound:block_fire_ambient

vulcan_pickaxe_smelt:
    type: world
    debug: false
    events:
        on player breaks iron_ore|deepslate_iron_ore|gold_ore|deepslate_gold_ore:
        - if <context.item.script.name.if_null[null]> != vulcan_pickaxe:
            - stop
        - if !<player.has_flag[vulcan.autosmelt]>:
            - stop
        - determine cancelled passively
        - define material <context.location.material.name>
        - if <[material].contains[iron]>:
            - drop iron_ingot <context.location>
        - else:
            - drop gold_ingot <context.location>
        - playeffect effect:flame at:<context.location> quantity:10 offset:0.3
```

---

### 2. Vulcan Title (COSMETIC)

**Not a physical item**—this is a **flag-based unlock**.

**Flag**: `vulcan.item.title: true`

**Title Text**: `<&8>[Vulcan's Chosen]<&r>`

**Display**: Prefix in chat messages

**Example**:
```
<&8>[Vulcan's Chosen]<&r> <player.name>: Hello!
```

**Implementation**: Chat event modification

```yaml
vulcan_title_chat:
    type: world
    debug: false
    events:
        on player chats:
        - if <player.has_flag[vulcan.item.title]>:
            - determine passively cancelled
            - announce "<&8>[Vulcan's Chosen]<&r> <player.display_name><&7>: <context.message>"
```

**Lore** (if shown in profile GUI):
```
<&d>COSMETIC UNLOCK

<&7>You bear the title of
<&8>Vulcan's Chosen<&7>,
<&7>a mark of forging mastery.

<&8>Unique - One per player
```

---

### 3. Head of Hephaestus (COLLECTIBLE)

**Material**: Player Head (custom texture)

**Display Name**: `<&8>Head of Hephaestus<&r>`

**Lore**:
```
<&7>A divine effigy of Hephaestus,
<&7>god of the forge.

<&8>Decorative collectible
<&8>Unique - One per player
```

**Flag**: `vulcan.item.head`

**Purpose**: Rare collectible/decorative item

---

### 4. Gray Shulker Box (UTILITY)

**Material**: `GRAY_SHULKER_BOX`

**Display Name**: `<&8>Gray Shulker Box<&r>`

**Lore**:
```
<&7>A rare shulker box from
<&7>Vulcan's personal crucible.

<&8>Standard shulker box
<&8>Unique - One per player
```

**NBT**: Standard shulker box (no special mechanics)

**Purpose**: Rare/cosmetic utility item (unique color)

**Flag**: `vulcan.item.shulker`

---

## Mythic Crafting Integration

The **Vulcan Pickaxe** is not a direct crate drop. Instead, the crate drops a **Vulcan Pickaxe Blueprint**, and the player must craft the final item using the Mythic Forge.

### Recipe: Vulcan Pickaxe

| Ingredient | Source | Quantity |
|---|---|---|
| Vulcan Pickaxe Blueprint | Vulcan Crate (unique item roll) | 1 |
| Hephaestus Mythic Fragment | Hephaestus Base Crate (MYTHIC tier) | 4 |
| Diamond Block | Survival | 4 |

### How to Craft

1. Right-click the Blueprint or any Hephaestus Mythic Fragment to open the **Mythic Forge** GUI
2. The GUI shows the 3x3 recipe layout (display only, not a real crafting table)
3. Click the result item in slot 26 to craft
4. System validates all ingredients are in inventory
5. On success: ingredients consumed, Vulcan Pickaxe given, `vulcan.item.pickaxe` flag set, server-wide announcement

### Implementation

All Mythic Crafting logic lives in `scripts/emblems/core/crafting.dsc`.

---

## Progress Display (Profile GUI)

### Vulcan Section

Show Vulcan item checklist in `/profile` GUI:

**Title**: `Vulcan - The Eternal Forge`

**Unlock Requirement**: Must have obtained at least 1 Vulcan Key (or opened 1 Vulcan Crate)

**Checklist**:
```
Vulcan Pickaxe:      [✓] Obtained  /  [✗] Locked (via Blueprint + Crafting)
Vulcan Title:        [✓] Obtained  /  [✗] Locked
Head of Hephaestus:  [✓] Obtained  /  [✗] Locked
Gray Shulker Box:    [✓] Obtained  /  [✗] Locked

Progress: 2 / 4 items
```

**Completion Reward**: None (all items are rewards themselves)

**Cosmetic**: Profile GUI shows gray badge if all 4 items obtained

---

## Admin Commands

### Give Vulcan Keys
```
/vulcanadmin <player> keys <amount>
```

### Toggle Item Obtained
```
/vulcanadmin <player> item pickaxe <true|false>
/vulcanadmin <player> item title <true|false>
/vulcanadmin <player> item head <true|false>
/vulcanadmin <player> item shulker <true|false>
```

### Reset All Vulcan Flags
```
/vulcanadmin <player> reset
```

### Simulate Roll
```
/testroll vulcan
```

Simulates a Vulcan crate roll for the executing player (does not consume key).

---

## Testing Scenarios

### Test 1: First Vulcan Key

1. Player obtains first Vulcan Key (from Hephaestus OLYMPIAN roll)
2. Right-click key
3. Roll: 50/50 → Path B (Unique Item)
4. Player has 0 items → All 4 available
5. Random selection: Vulcan Pickaxe
6. Player receives pickaxe + flag set
7. Message: `<&8>[VULCAN]<&r> <&d>Vulcan Pickaxe<&r> <&e>UNIQUE ITEM!`

### Test 2: Second Key (God Apple)

1. Player has 1 item (pickaxe)
2. Use second Vulcan Key
3. Roll: Path A → God Apple
4. Player receives enchanted golden apple
5. Message: `<&8>[VULCAN]<&r> Enchanted Golden Apple`

### Test 3: All Items Obtained

1. Player has all 4 items
2. Use Vulcan Key
3. Roll forced to Path A (no items left)
4. Player receives god apple
5. Message: `<&8>[VULCAN]<&r> Enchanted Golden Apple <&7>(All items obtained)`

### Test 4: Pickaxe Auto-Smelt

1. Player holds Vulcan Pickaxe
2. Right-click to enable auto-smelt
3. Mine iron ore → Drops iron ingot instead of raw iron
4. Flame particles appear at break location

### Test 5: Mythic Crafting (Vulcan Pickaxe)

1. Player has `vulcan_pickaxe_blueprint` + 4x `hephaestus_mythic_fragment` + 4x diamond blocks
2. Right-click blueprint or fragment to open Mythic Forge GUI
3. Click result slot (slot 26) to craft
4. Ingredients consumed, Vulcan Pickaxe given, flag set

### Test 6: Title Display

1. Player obtains Vulcan Title
2. Player types in chat: "Hello!"
3. Server broadcasts: `<&8>[Vulcan's Chosen]<&r> PlayerName<&7>: Hello!`

---

## Balance Considerations

### Vulcan Key Rarity

**Drop Rate**: 1% from Hephaestus Crates (OLYMPIAN tier), 2% with Hephaestus emblem unlocked

**Expected Keys**:
- 100 Hephaestus Keys opened → ~1 Vulcan Key
- To obtain all 4 items:
  - Need ~8 Vulcan Keys (50% item rate → 4 items expected in 8 rolls)
  - Need ~800 Hephaestus Keys (8 Vulcan Keys × 100 Hephaestus Keys per Vulcan)

**Conclusion**: Vulcan items are **very rare**, suitable for long-term/endgame players

### Item Power Levels

- **Vulcan Pickaxe**: Moderate mining utility, auto-smelt (requires Mythic Crafting)
- **Vulcan Title**: Pure cosmetic, no gameplay impact
- **Head of Hephaestus**: Pure collectible, no gameplay impact
- **Gray Shulker**: Utility, standard item

**Verdict**: Vulcan items are **prestige/utility** more than raw power upgrades

---

## Comparison: Ceres vs Vulcan vs Mars

| Aspect | Ceres | Vulcan | Mars |
|--------|----------------|-----------------|---------------|
| **Source** | Demeter OLYMPIAN (1-2%) | Hephaestus OLYMPIAN (1-2%) | Heracles OLYMPIAN (1-2%) |
| **System** | 50/50 (god apple / unique) | 50/50 (god apple / unique) | 50/50 (god apple / unique) |
| **Pool Size** | 4 items | 4 items | 4 items |
| **Head** | Head of Demeter (collectible) | Head of Hephaestus (collectible) | Head of Heracles (collectible) |
| **Title** | [Ceres' Chosen] (gold) | [Vulcan's Chosen] (gray) | [Mars' Chosen] (dark red) |
| **Shulker** | Yellow | Gray | Red |
| **Crafted** | Ceres Wand (bee summon, via Blueprint) | Vulcan Pickaxe (auto-smelt, via Blueprint) | Mars Shield (resistance buff, via Blueprint) |
| **Theme** | Agriculture, growth | Fire, metalworking | War, protection |
| **Border Color** | Cyan | Gray | Crimson/Dark Red |

---

## Flag Reference

### Vulcan Crate Flags
```
vulcan.crates_opened              # Total crates opened

# Unique Items (Finite Pool)
vulcan.item.pickaxe               # Boolean: Has Vulcan Pickaxe
vulcan.item.title                 # Boolean: Has Vulcan Title
vulcan.item.head                  # Boolean: Has Head of Hephaestus
vulcan.item.shulker               # Boolean: Has Gray Shulker

# Meta Stats
vulcan.unique_items               # Count of unique items obtained (0-4)
vulcan.god_apples                 # Count of god apples received

# Pickaxe Toggle
vulcan.autosmelt                  # Boolean: Auto-smelt mode enabled
```

---

## Summary

The Vulcan Meta-Progression adds **meaningful endgame rewards** for dedicated mining players, with items that enhance efficiency and provide prestige.

Key design principles:
- **Mirrors Ceres/Mars structure**: Same 50/50 system, 4 finite items
- **Forge-themed**: Auto-smelt pickaxe (via Mythic Crafting), head collectible, forge titles
- **Ultra-rare**: ~800 Hephaestus Keys needed on average to complete
- **Quality-of-life**: Items provide utility, not raw power
- **Cosmetic prestige**: Vulcan's Chosen title marks elite players
- **Parallel to Hephaestus**: Both systems coexist without interfering

This system provides a **complete progression path** with aspirational meta-rewards for the Hephaestus emblem.
