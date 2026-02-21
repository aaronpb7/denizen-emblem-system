# Dis Meta-Progression - Complete Specification

## Overview

**Dis** is the Roman god of the underworld, equivalent to Greek Charon. In the emblem system, Dis represents **meta-progression** for the Charon emblem—a premium layer accessible only through rare Charon Crate rolls.

**Access**: Obtain Dis Keys (1% drop from Charon Crate OLYMPIAN tier, 2% with Charon emblem unlocked)

**Mechanics**: 50/50 chance between god apple and finite unique items

**Goal**: Collect all 4 Dis items: Title, Shulker, Fire Charm (via Blueprint + Crafting), Head of Charon

---

## Dis Key

### Item Definition

**Material**: `NETHER_STAR`

**Display Name**: `<&5><&l>DIS KEY<&r>`

**Lore**:
```
<&5>OLYMPIAN

<&7>A key forged in the fires of Dis,
<&7>where the lord of the underworld
<&7>guards his most precious treasures.

<&e>Right-click to unlock
<&e>a Dis Crate.

<&8>50% God Apple / 50% Unique Item
```

**NBT**:
- Enchantment: `mending:1` (hidden, for glint)

**Stackable**: Yes

**Tradeable**: Yes

**Source**: 1% chance from Charon Crate (OLYMPIAN tier only)

---

## Usage Mechanics

### Trigger

**Event**: `on player right clicks using:dis_key`

**Location**: Any location (not location-gated)

**Emblem**: No emblem requirement (usable regardless of active emblem)

**Consumption**: Remove 1 key from player's hand

---

## GUI Animation

**Title**: `Dis Passage - Opening...`

**Duration**: ~4.75 seconds (same 3-phase animation as base crates)

**Inventory**: 27 slots (3 rows)

### Animation Sequence

**Border**: `purple_stained_glass_pane` (dark purple theme)

**Preview Pool**: Alternates between enchanted golden apple and mystery item (name tag "?")

**Phases**: Same 3-phase scrolling as base crates (20 fast + 10 medium + 5 slow)

---

## Loot Logic: 50/50 System

### Two Paths

**Path A: God Apple (50% base chance)**
- Award: 1 Enchanted Golden Apple
- Always available

**Path B: Unique Item (50% base chance)**
- Award: ONE item from the finite Dis item pool
- **Constraint**: Can only obtain each item ONCE per player
- **Progression tracking**: Items already obtained are removed from pool

### Finite Item Pool (4 items total)

1. **Dis Title** — "Dis' Chosen" chat prefix (flag unlock)
2. **Purple Shulker Box** — Standard purple shulker box item
3. **Dis Fire Charm Blueprint** — Blueprint for Mythic Forge crafting
4. **Head of Charon** — Player head collectible

### Progression Rules

**When player has 0-3 items**:
- Roll 50/50: God Apple vs. Unique Item
- If Unique Item path: Randomly select ONE item player does NOT have yet
- Award item, flag as obtained

**When player has all 4 items**:
- ALWAYS award God Apple (100% chance)
- Path B is disabled (no items left to obtain)

---

## Dis Items

### 1. Head of Charon (COLLECTIBLE)

**Material**: Player Head (custom skull skin)

**Display Name**: `<&5>Head of Charon<&r>`

**Lore**:
```
<&7>A divine effigy of Charon,
<&7>ferryman of the dead.

<&8>Decorative collectible
<&8>Unique - One per player

<&5><&l>OLYMPIAN
```

**Flag**: `dis.item.head`

**Purpose**: Rare collectible/decorative item

---

### 2. Dis Title (COSMETIC)

**Not a physical item**—this is a **flag-based unlock**.

**Flag**: `dis.item.title: true`

**Title Text**: `<&5>[Dis' Chosen]<&r>`

**Display**: Prefix in chat messages

**Example**:
```
<&5>[Dis' Chosen]<&r> PlayerName: Hello!
```

---

### 3. Purple Shulker Box (ITEM)

**Material**: `PURPLE_SHULKER_BOX`

**Display Name**: `<&5>Purple Shulker Box<&r>`

**Lore**:
```
<&7>A rare shulker box from
<&7>the Dis Passage.

<&8>Standard shulker box
<&8>Unique - One per player

<&5><&l>OLYMPIAN
```

**Flag**: `dis.item.shulker`

**Purpose**: Rare/cosmetic utility item

---

### 4. Dis Fire Charm (MYTHIC)

**Material**: `RED_DYE`

**Display Name**: `<&5><&l>DIS FIRE CHARM<&r>`

**Lore**:
```
<&7>A charm imbued with the fires
<&7>of the underworld.

<&e>Grants fire and lava immunity
<&e>while in your inventory.

<&8>Unbreakable
<&8>Unique - One per player

<&d><&l>MYTHIC
```

**Enchantments**: `mending:1` (hidden, for glint)

**Flag**: `dis.item.charm`

**Passive Effect**: Grants fire resistance while in any inventory slot (checked every 1 second, 3s buffer). Plays soul_fire_flame particles.

**Obtained via**: Mythic Forge crafting (Blueprint + 4x Charon Mythic Fragment + 4x Diamond Block)

---

## Mythic Crafting Integration

The **Dis Fire Charm** is not a direct crate drop. Instead, the crate drops a **Dis Fire Charm Blueprint**, and the player must craft the final item using the Mythic Forge.

### Recipe: Dis Fire Charm

| Ingredient | Source | Quantity |
|---|---|---|
| Dis Fire Charm Blueprint | Dis Crate (unique item roll) | 1 |
| Charon Mythic Fragment | Component milestones (3) + MYTHIC crate tier | 4 |
| Diamond Block | Survival | 4 |

### How to Craft

1. Right-click the Blueprint or any Charon Mythic Fragment to open the **Mythic Forge** GUI
2. The GUI shows the 3x3 recipe layout (display only, not a real crafting table)
3. Click the result item in slot 26 to craft
4. System validates all ingredients are in inventory
5. On success: ingredients consumed, Dis Fire Charm given, `dis.item.charm` flag set, server-wide announcement

---

## Admin Commands

### Give Dis Keys
```
/disadmin <player> keys <amount>
```

### Give Specific Item
```
/disadmin <player> give <title|shulker|charm|head>
```

### Toggle Item Obtained Flag
```
/disadmin <player> item <title|shulker|charm|head> <true|false>
```

### Reset All Dis Flags
```
/disadmin <player> reset
```

### Simulate Roll
```
/testroll dis
```

Simulates a Dis crate roll for the executing player (does not consume key).

---

## Flags

### Item Obtained Flags

| Flag | Type | Purpose | Set When |
|------|------|---------|----------|
| `dis.item.title` | Boolean | Dis Title obtained | Dis crate rolls title |
| `dis.item.shulker` | Boolean | Purple Shulker obtained | Dis crate rolls shulker |
| `dis.item.charm` | Boolean | Dis Fire Charm obtained | Mythic Forge craft / admin |
| `dis.item.head` | Boolean | Head of Charon obtained | Dis crate rolls head |

### Optional Statistics

| Flag | Type | Purpose |
|------|------|---------|
| `dis.crates_opened` | Integer | Total Dis crates opened |
| `dis.god_apples` | Integer | God apples from Dis |
| `dis.unique_items` | Integer | Unique items from Dis (0-4) |

---

## Balance Considerations

### Dis Key Rarity

**Drop Rate**: 1% from Charon Crates (OLYMPIAN tier), 2% with Charon emblem unlocked

**Expected Keys**:
- 100 Charon Keys opened → ~1 Dis Key
- To obtain all 4 items:
  - Need ~8 Dis Keys (50% item rate → 4 items expected in 8 rolls)
  - Need ~800 Charon Keys (8 Dis Keys x 100 Charon Keys per Dis)

**Conclusion**: Dis items are **very rare**, suitable for long-term/endgame players. Additionally, Charon is a Tier 2 emblem requiring 2 Tier 1 completions, adding another layer of gating.

### Item Power Levels

- **Head of Charon**: Pure collectible, no gameplay impact
- **Title**: Pure cosmetic, no gameplay impact
- **Shulker**: Utility, standard item
- **Fire Charm**: Strong passive (permanent fire/lava immunity in any inventory slot), requires Mythic Crafting

**Verdict**: Dis items are **prestige/cosmetic** with one strong utility charm
