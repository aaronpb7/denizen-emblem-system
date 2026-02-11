# Neptune Meta-Progression - Complete Specification

## Overview

**Neptune** is the Roman god of the sea, equivalent to Greek Triton. In the emblem system, Neptune represents **meta-progression** for the Triton emblem—a premium layer accessible only through rare Triton Crate rolls.

**Access**: Obtain Neptune Keys (1% drop from Triton Crate OLYMPIAN tier, 2% with Triton emblem unlocked)

**Mechanics**: 50/50 chance between god apple and finite unique items

**Goal**: Collect all 4 Neptune items: Title, Shulker, Trident (via Blueprint + Crafting), Head of Triton

---

## Neptune Key

### Item Definition

**Material**: `NETHER_STAR`

**Display Name**: `<&b><&l>NEPTUNE KEY<&r>`

**Lore**:
```
<&b>OLYMPIAN

<&7>A key forged in Neptune's depths,
<&7>where the god of the sea guards
<&7>his most precious treasures.

<&e>Right-click to unlock
<&e>a Neptune Crate.

<&8>50% God Apple / 50% Unique Item
```

**NBT**:
- Enchantment: `mending:1` (hidden, for glint)

**Stackable**: Yes

**Tradeable**: Yes

**Source**: 1% chance from Triton Crate (OLYMPIAN tier only)

---

## Usage Mechanics

### Trigger

**Event**: `on player right clicks using:neptune_key`

**Location**: Any location (not location-gated)

**Emblem**: No emblem requirement (usable regardless of active emblem)

**Consumption**: Remove 1 key from player's hand

---

## GUI Animation

**Title**: `Neptune Depths - Opening...`

**Duration**: ~4.75 seconds (same 3-phase animation as base crates)

**Inventory**: 27 slots (3 rows)

### Animation Sequence

**Border**: `dark_prismarine` (dark aqua theme)

**Preview Pool**: Alternates between enchanted golden apple and mystery item (name tag "?")

**Phases**: Same 3-phase scrolling as base crates (20 fast + 10 medium + 5 slow)

**Sounds**: Same as Ceres crate pattern

---

## Loot Logic: 50/50 System

### Two Paths

**Path A: God Apple (50% base chance)**
- Award: 1 Enchanted Golden Apple
- Always available

**Path B: Unique Item (50% base chance)**
- Award: ONE item from the finite Neptune item pool
- **Constraint**: Can only obtain each item ONCE per player
- **Progression tracking**: Items already obtained are removed from pool

### Finite Item Pool (4 items total)

1. **Neptune Title** — "Neptune's Chosen" chat prefix (flag unlock)
2. **Cyan Shulker Box** — Standard cyan shulker box item
3. **Neptune Trident Blueprint** — Blueprint for Mythic Forge crafting
4. **Head of Triton** — Player head collectible

### Progression Rules

**When player has 0-3 items**:
- Roll 50/50: God Apple vs. Unique Item
- If Unique Item path: Randomly select ONE item player does NOT have yet
- Award item, flag as obtained

**When player has all 4 items**:
- ALWAYS award God Apple (100% chance)
- Path B is disabled (no items left to obtain)

---

## Neptune Items

### 1. Head of Triton (COLLECTIBLE)

**Material**: Player Head (custom skull skin)

**Display Name**: `<&b>Head of Triton<&r>`

**Lore**:
```
<&7>A divine effigy of Triton,
<&7>god of the sea.

<&8>Decorative collectible
<&8>Unique - One per player

<&b><&l>OLYMPIAN
```

**Flag**: `neptune.item.head`

**Purpose**: Rare collectible/decorative item

---

### 2. Neptune Title (COSMETIC)

**Not a physical item**—this is a **flag-based unlock**.

**Flag**: `neptune.item.title: true`

**Title Text**: `<&3>[Neptune's Chosen]<&r>`

**Display**: Prefix in chat messages

**Example**:
```
<&3>[Neptune's Chosen]<&r> PlayerName: Hello!
```

---

### 3. Cyan Shulker Box (ITEM)

**Material**: `CYAN_SHULKER_BOX`

**Display Name**: `<&3>Cyan Shulker Box<&r>`

**Lore**:
```
<&7>A rare shulker box from
<&7>Neptune's Depths.

<&8>Standard shulker box
<&8>Unique - One per player

<&b><&l>OLYMPIAN
```

**Flag**: `neptune.item.shulker`

**Purpose**: Rare/cosmetic utility item

---

### 4. Neptune's Trident (MYTHIC)

**Material**: `TRIDENT`

**Display Name**: `<&d><&l>NEPTUNE'S TRIDENT<&r>`

**Lore**:
```
<&7>A divine trident forged in
<&7>the depths of Neptune's realm.

<&e>Riptide III
<&e>Loyalty III
<&e>Channeling I

<&8>Unbreakable
<&8>Unique - One per player

<&d><&l>MYTHIC
```

**Enchantments**: Riptide III, Loyalty III, Channeling I, Unbreaking III

**Flags**: `hf:HIDE_ENCHANTS`, Unbreakable

**Flag**: `neptune.item.trident`

**Obtained via**: Mythic Forge crafting (Blueprint + 4x Triton Mythic Fragment + 4x Diamond Block)

---

## Mythic Crafting Integration

The **Neptune's Trident** is not a direct crate drop. Instead, the crate drops a **Neptune Trident Blueprint**, and the player must craft the final item using the Mythic Forge.

### Recipe: Neptune's Trident

| Ingredient | Source | Quantity |
|---|---|---|
| Neptune Trident Blueprint | Neptune Crate (unique item roll) | 1 |
| Triton Mythic Fragment | Triton Base Crate (MYTHIC tier) | 4 |
| Diamond Block | Survival | 4 |

### How to Craft

1. Right-click the Blueprint or any Triton Mythic Fragment to open the **Mythic Forge** GUI
2. The GUI shows the 3x3 recipe layout (display only, not a real crafting table)
3. Click the result item in slot 26 to craft
4. System validates all ingredients are in inventory
5. On success: ingredients consumed, Neptune's Trident given, `neptune.item.trident` flag set, server-wide announcement

---

## Admin Commands

### Give Neptune Keys
```
/neptuneadmin <player> keys <amount>
```

### Give Specific Item
```
/neptuneadmin <player> give <head|shulker|blueprint|trident>
```

### Toggle Item Obtained Flag
```
/neptuneadmin <player> item <title|shulker|trident|head> <true|false>
```

### Reset All Neptune Flags
```
/neptuneadmin <player> reset
```

### Simulate Roll
```
/testroll neptune
```

Simulates a Neptune crate roll for the executing player (does not consume key).

---

## Flags

### Item Obtained Flags

| Flag | Type | Purpose | Set When |
|------|------|---------|----------|
| `neptune.item.title` | Boolean | Neptune Title obtained | Neptune crate rolls title |
| `neptune.item.shulker` | Boolean | Cyan Shulker obtained | Neptune crate rolls shulker |
| `neptune.item.trident` | Boolean | Neptune's Trident obtained | Mythic Forge craft / admin |
| `neptune.item.head` | Boolean | Head of Triton obtained | Neptune crate rolls head |

### Optional Statistics

| Flag | Type | Purpose |
|------|------|---------|
| `neptune.crates_opened` | Integer | Total Neptune crates opened |
| `neptune.god_apples` | Integer | God apples from Neptune |
| `neptune.unique_items` | Integer | Unique items from Neptune (0-4) |

---

## Balance Considerations

### Neptune Key Rarity

**Drop Rate**: 1% from Triton Crates (OLYMPIAN tier), 2% with Triton emblem unlocked

**Expected Keys**:
- 100 Triton Keys opened → ~1 Neptune Key
- To obtain all 4 items:
  - Need ~8 Neptune Keys (50% item rate → 4 items expected in 8 rolls)
  - Need ~800 Triton Keys (8 Neptune Keys × 100 Triton Keys per Neptune)

**Conclusion**: Neptune items are **very rare**, suitable for long-term/endgame players. Additionally, Triton is a Tier 2 emblem requiring 2 Tier 1 completions, adding another layer of gating.

### Item Power Levels

- **Head of Triton**: Pure collectible, no gameplay impact
- **Title**: Pure cosmetic, no gameplay impact
- **Shulker**: Utility, standard item
- **Trident**: Strong combat/utility item (Riptide + Loyalty + Channeling), requires Mythic Crafting

**Verdict**: Neptune items are **prestige/cosmetic** with one strong utility trident
