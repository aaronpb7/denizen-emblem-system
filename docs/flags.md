# Flag Reference - Authoritative List

## Overview

This document lists ALL flags used in the Emblem System V2. Flags are organized by category and include data types, purposes, and example values.

---

## Core System Flags

### Promachos

| Flag | Type | Purpose | Example Value | Set When |
|------|------|---------|---------------|----------|
| `met_promachos` | Boolean | Player has met Promachos | `true` | First interaction complete |
| `emblem.active` | String | Player's active emblem | `DEMETER` | Emblem selected/changed |
| `emblem.changed_before` | Boolean | Player has changed emblem at least once | `true` | Emblem changed via Promachos |
| `emblem.rank` | Integer | Player's progression rank (0=Uninitiated, 1=Neophyte, 2=Mystes, 3=Epoptes, 4=Aristos, 5=Heros, 6=Hemitheos) | `2` | Emblem ceremony completes |
| `emblem.migrated` | Boolean | One-time migration flag from old role system | `true` | Migration task runs |

**Valid `emblem.active` values**: `DEMETER`, `HEPHAESTUS`, `HERACLES`, `TRITON`

---

## Demeter Progression Flags

### Activity Counters

| Flag | Type | Purpose | Example Value | Incremented When |
|------|------|---------|---------------|------------------|
| `demeter.wheat.count` | Integer | Total wheat harvested | `8432` | Wheat age=7 broken, emblem=DEMETER |
| `demeter.cows.count` | Integer | Total cows bred | `1205` | Cow breed event, emblem=DEMETER |
| `demeter.cakes.count` | Integer | Total cakes crafted | `95` | Cake craft event, emblem=DEMETER |

### Key Award Tracking

| Flag | Type | Purpose | Example Value | Purpose |
|------|------|---------|---------------|---------|
| `demeter.wheat.keys_awarded` | Integer | Keys awarded from wheat | `56` | Prevents double-awarding on intervals |
| `demeter.cows.keys_awarded` | Integer | Keys awarded from cows | `60` | Tracks multiples of 20 |
| `demeter.cakes.keys_awarded` | Integer | Keys awarded from cakes | `31` | Tracks multiples of 3 |

**Logic**: `keys_should_have = floor(count / threshold)`. Award delta if `keys_should_have > keys_awarded`.

### Component Flags

| Flag | Type | Purpose | Example Value | Set When |
|------|------|---------|---------------|----------|
| `demeter.component.wheat` | Boolean | Wheat component obtained | `true` | Counter reaches 15,000 |
| `demeter.component.cow` | Boolean | Cow component obtained | `true` | Counter reaches 2,000 |
| `demeter.component.cake` | Boolean | Cake component obtained | `true` | Counter reaches 300 |

**Once-only**: Cannot be re-earned. Check `!<player.has_flag[...]>` before awarding.

### Emblem Unlock

| Flag | Type | Purpose | Example Value | Set When |
|------|------|---------|---------------|----------|
| `demeter.emblem.unlocked` | Boolean | Demeter emblem unlocked | `true` | Promachos ceremony (all components complete) |
| `demeter.emblem.unlock_date` | Timestamp | When emblem unlocked | `1706400000` | Same as above |

### Optional Statistics

| Flag | Type | Purpose | Example Value |
|------|------|---------|---------------|
| `demeter.crates_opened` | Integer | Total Demeter crates opened | `342` |
| `demeter.tier.mortal` | Integer | MORTAL rolls | `191` |
| `demeter.tier.heroic` | Integer | HEROIC rolls | `89` |
| `demeter.tier.legendary` | Integer | LEGENDARY rolls | `41` |
| `demeter.tier.mythic` | Integer | MYTHIC rolls | `17` |
| `demeter.tier.olympian` | Integer | OLYMPIAN rolls | `4` |

---

## Ceres Meta-Progression Flags

### Item Obtained Flags

| Flag | Type | Purpose | Example Value | Set When |
|------|------|---------|---------------|----------|
| `ceres.item.title` | Boolean | Ceres Title obtained | `true` | Ceres crate rolls title |
| `ceres.item.shulker` | Boolean | Yellow Shulker obtained | `true` | Ceres crate rolls shulker |
| `ceres.item.wand` | Boolean | Ceres Wand obtained | `true` | Ceres crate rolls wand |
| `ceres.item.head` | Boolean | Head of Demeter obtained | `true` | Ceres crate rolls head |

**Finite Progression**: Once all 4 flags are true, Ceres crate always awards god apple.

### Cooldowns

| Flag | Type | Purpose | Example Value | Set When |
|------|------|---------|---------------|----------|
| `ceres.wand_cooldown` | Expiring | Wand usage cooldown | `expire:30s` | Wand right-clicked |

**Check**: `<player.has_flag[ceres.wand_cooldown]>` returns true if still active.

### Optional Statistics

| Flag | Type | Purpose | Example Value |
|------|------|---------|---------------|
| `ceres.crates_opened` | Integer | Total Ceres crates opened | `12` |
| `ceres.god_apples` | Integer | God apples from Ceres | `8` |
| `ceres.unique_items` | Integer | Unique items from Ceres | `4` |

---

## Hephaestus Progression Flags

### Activity Counters

| Flag | Type | Purpose | Example Value | Incremented When |
|------|------|---------|---------------|------------------|
| `hephaestus.iron.count` | Integer | Total iron ore mined | `3500` | Iron ore broken, emblem=HEPHAESTUS |
| `hephaestus.smelting.count` | Integer | Total items smelted in blast furnace | `4200` | Item taken from blast furnace, emblem=HEPHAESTUS |
| `hephaestus.golems.count` | Integer | Total iron golems created | `75` | Iron golem spawns near player, emblem=HEPHAESTUS |

### Key Award Tracking

| Flag | Type | Purpose | Example Value |
|------|------|---------|---------------|
| `hephaestus.iron.keys_awarded` | Integer | Keys awarded from iron | `70` |
| `hephaestus.smelting.keys_awarded` | Integer | Keys awarded from smelting | `84` |
| `hephaestus.golems.keys_awarded` | Integer | Keys awarded from golems | `75` |

### Component Flags

| Flag | Type | Purpose | Set When |
|------|------|---------|----------|
| `hephaestus.component.iron` | Boolean | Iron component obtained | Counter reaches 5,000 |
| `hephaestus.component.smelting` | Boolean | Smelting component obtained | Counter reaches 5,000 |
| `hephaestus.component.golem` | Boolean | Golem component obtained | Counter reaches 100 |

### Emblem Unlock

| Flag | Type | Purpose |
|------|------|---------|
| `hephaestus.emblem.unlocked` | Boolean | Hephaestus emblem unlocked |
| `hephaestus.emblem.unlock_date` | Timestamp | When emblem unlocked |

---

## Heracles Progression Flags

### Activity Counters

| Flag | Type | Purpose | Example Value | Incremented When |
|------|------|---------|---------------|------------------|
| `heracles.pillagers.count` | Integer | Total pillagers killed | `1800` | Pillager killed, emblem=HERACLES |
| `heracles.raids.count` | Integer | Total raids completed | `35` | Raid finished with player as hero, emblem=HERACLES |
| `heracles.emeralds.count` | Integer | Total emeralds spent trading | `7500` | Emeralds used in villager trades, emblem=HERACLES |

### Key Award Tracking

| Flag | Type | Purpose | Example Value |
|------|------|---------|---------------|
| `heracles.pillagers.keys_awarded` | Integer | Keys awarded from pillagers | `18` |
| `heracles.raids.keys_awarded` | Integer | Keys awarded from raids (2 per raid) | `70` |
| `heracles.emeralds.keys_awarded` | Integer | Keys awarded from emeralds | `75` |

### Component Flags

| Flag | Type | Purpose | Set When |
|------|------|---------|----------|
| `heracles.component.pillagers` | Boolean | Pillager component obtained | Counter reaches 2,500 |
| `heracles.component.raids` | Boolean | Raid component obtained | Counter reaches 50 |
| `heracles.component.emeralds` | Boolean | Emerald component obtained | Counter reaches 10,000 |

### Emblem Unlock

| Flag | Type | Purpose |
|------|------|---------|
| `heracles.emblem.unlocked` | Boolean | Heracles emblem unlocked |
| `heracles.emblem.unlock_date` | Timestamp | When emblem unlocked |

---

## Triton Progression Flags

### Activity Counters

| Flag | Type | Purpose | Example Value | Incremented When |
|------|------|---------|---------------|------------------|
| `triton.lanterns.count` | Integer | Total sea lanterns turned in | `850` | Sea lanterns turned in to Triton NPC, emblem=TRITON |
| `triton.guardians.count` | Integer | Total guardian kill points | `1200` | Guardian killed (+1) or Elder Guardian killed (+15), emblem=TRITON |
| `triton.conduits.count` | Integer | Total conduits crafted | `18` | Conduit craft event, emblem=TRITON |

### Key Award Tracking

| Flag | Type | Purpose | Example Value |
|------|------|---------|---------------|
| `triton.lanterns.keys_awarded` | Integer | Keys awarded from lanterns | `85` |
| `triton.guardians.keys_awarded` | Integer | Keys awarded from guardians | `80` |
| `triton.conduits.keys_awarded` | Integer | Keys awarded from conduits | `72` |

**Logic**: Lanterns: `floor(count / 10)`. Guardians: `floor(count / 15)`. Conduits: `count * 4`.

### Component Flags

| Flag | Type | Purpose | Set When |
|------|------|---------|----------|
| `triton.component.lanterns` | Boolean | Lantern component obtained | Counter reaches 1,000 |
| `triton.component.guardians` | Boolean | Guardian component obtained | Counter reaches 1,500 |
| `triton.component.conduits` | Boolean | Conduit component obtained | Counter reaches 25 |

### Emblem Unlock

| Flag | Type | Purpose |
|------|------|---------|
| `triton.emblem.unlocked` | Boolean | Triton emblem unlocked |
| `triton.emblem.unlock_date` | Timestamp | When emblem unlocked |

### Optional Statistics

| Flag | Type | Purpose |
|------|------|---------|
| `triton.crates_opened` | Integer | Total Triton crates opened |
| `triton.tier.mortal` | Integer | MORTAL rolls |
| `triton.tier.heroic` | Integer | HEROIC rolls |
| `triton.tier.legendary` | Integer | LEGENDARY rolls |
| `triton.tier.mythic` | Integer | MYTHIC rolls |
| `triton.tier.olympian` | Integer | OLYMPIAN rolls |

---

## Neptune Meta-Progression Flags

### Item Obtained Flags

| Flag | Type | Purpose | Set When |
|------|------|---------|----------|
| `neptune.item.title` | Boolean | Neptune Title obtained | Neptune crate rolls title |
| `neptune.item.shulker` | Boolean | Cyan Shulker obtained | Neptune crate rolls shulker |
| `neptune.item.trident` | Boolean | Neptune's Trident obtained | Mythic Forge craft |
| `neptune.item.head` | Boolean | Head of Triton obtained | Neptune crate rolls head |

### Optional Statistics

| Flag | Type | Purpose |
|------|------|---------|
| `neptune.crates_opened` | Integer | Total Neptune crates opened |
| `neptune.god_apples` | Integer | God apples from Neptune |
| `neptune.unique_items` | Integer | Unique items from Neptune (0-4) |

---

## Vulcan Meta-Progression Flags

### Item Obtained Flags

| Flag | Type | Purpose | Set When |
|------|------|---------|----------|
| `vulcan.item.pickaxe` | Boolean | Vulcan Pickaxe obtained | Vulcan crate rolls pickaxe |
| `vulcan.item.title` | Boolean | Vulcan Title obtained | Vulcan crate rolls title |
| `vulcan.item.shulker` | Boolean | Gray Shulker obtained | Vulcan crate rolls shulker |
| `vulcan.item.head` | Boolean | Head of Hephaestus obtained | Vulcan crate rolls head |

### Cooldowns & Toggles

| Flag | Type | Purpose |
|------|------|---------|
| `vulcan.autosmelt` | Boolean | Pickaxe auto-smelt mode enabled |

### Optional Statistics

| Flag | Type | Purpose |
|------|------|---------|
| `vulcan.crates_opened` | Integer | Total Vulcan crates opened |
| `vulcan.god_apples` | Integer | God apples from Vulcan |
| `vulcan.unique_items` | Integer | Unique items from Vulcan (0-4) |

---

## Mars Meta-Progression Flags

### Item Obtained Flags

| Flag | Type | Purpose | Set When |
|------|------|---------|----------|
| `mars.item.title` | Boolean | Mars Title obtained | Mars crate rolls title |
| `mars.item.shield` | Boolean | Mars Shield obtained | Mars crate rolls shield |
| `mars.item.shulker` | Boolean | Red Shulker obtained | Mars crate rolls shulker |
| `mars.item.head` | Boolean | Head of Heracles obtained | Mars crate rolls head |

### Cooldowns

| Flag | Type | Purpose |
|------|------|---------|
| `mars.shield_cooldown` | Expiring | Shield ability cooldown (expire:180s) |

### Optional Statistics

| Flag | Type | Purpose |
|------|------|---------|
| `mars.crates_opened` | Integer | Total Mars crates opened |
| `mars.god_apples` | Integer | God apples from Mars |
| `mars.unique_items` | Integer | Unique items from Mars (0-4) |

---

## Temporary/Entity Flags

### Ceres Bees

| Flag | Type | Purpose | Example Value | Set When |
|------|------|---------|---------------|----------|
| `ceres.temporary` | Expiring (Entity) | Mark bee as temporary | `expire:30s` | Bee spawned by wand |

**Applied to**: Bee entities spawned by Ceres Wand

**Purpose**: Filter bees for despawn after 30s

---

## Crafting System Flags

### Temporary

| Flag | Type | Purpose | Example Value | Set When |
|------|------|---------|---------------|----------|
| `crafting.viewing_recipe` | String | Recipe currently being viewed | `ceres_wand` | Mythic Forge GUI opened |

**Cleared**: When player closes the Mythic Forge GUI.

**Valid values**: `ceres_wand`, `mars_shield`, `vulcan_pickaxe`, `neptune_trident`

---

## Deprecated Flags (legacy - Do Not Use)

These flags were used in older system versions and should NOT be referenced in current code. They are preserved for migration/rollback purposes only.

### Old Role System Flags (V2)

```
role.active (replaced by emblem.active)
role.changed_before (replaced by emblem.changed_before)
farming.xp
farming.rank
mining.xp
mining.rank
heracles.xp
farming.next_emblem.unlocked
mining.next_emblem.unlocked
combat.next_emblem.unlocked
```

### Old Hephaestus Flags

```
emblem.hephaestus.stage1.progress
emblem.hephaestus.stage1.claimed
emblem.hephaestus.stage2.progress
emblem.hephaestus.stage2.claimed
... (up to stage5)
emblem.hephaestus.stage5.completed
```

### Old Demeter Flags

```
emblem.demeter.stage1.progress
emblem.demeter.stage1.claimed
emblem.demeter.stage2.progress
emblem.demeter.stage2.claimed
... (up to stage5)
emblem.demeter.stage5.completed
```

### Old Heracles Flags

```
emblem.heracles.stage1.progress
emblem.heracles.stage1.claimed
emblem.heracles.stage2.progress
emblem.heracles.stage2.claimed
... (up to stage5)
emblem.heracles.stage5.completed
```

---

## Flag Naming Conventions

### Hierarchy

Use dot notation for nested data:
```
<god>.<activity>.<property>
<god>.component.<activity>
<god>.emblem.<property>
<meta_god>.item.<item_name>
```

### Consistency

- **Lowercase**: All flag names lowercase (e.g., `demeter.wheat.count`, not `Demeter.Wheat.Count`)
- **Underscores**: Use underscores for multi-word properties (e.g., `keys_awarded`, `unlock_date`)
- **Plural vs. Singular**: Use plural for countable collections (e.g., `cows.count`), singular for single values (e.g., `emblem.unlocked`)

### Boolean Flags

- Use `.unlocked`, `.obtained`, `.claimed`, `.completed` for true/false states
- Absence of flag = `false` (use `.if_null[false]` or `!<player.has_flag[...]>`)

### Counter Flags

- Use `.count` for activity counters (e.g., `wheat.count`)
- Use `.keys_awarded` for tracking key payout multiples
- Initialize to 0 if absent: `<player.flag[demeter.wheat.count].if_null[0]>`

### Expiring Flags

- Use `expire:duration` syntax (e.g., `expire:30s`, `expire:1h`, `expire:1d`)
- Check existence with `<player.has_flag[...]>` (returns false if expired)
- Check remaining time: `<player.flag_expiration[...].from_now>`

---

## Common Flag Operations

### Reading Flags

```yaml
# Boolean flag
- if <player.has_flag[demeter.emblem.unlocked]>:
    - narrate "Emblem unlocked!"

# Integer flag with default
- define count <player.flag[demeter.wheat.count].if_null[0]>

# String flag
- define emblem <player.flag[emblem.active].if_null[NONE]>

# Timestamp flag
- define date <player.flag[demeter.emblem.unlock_date].as_time>
```

### Writing Flags

```yaml
# Set boolean
- flag player demeter.emblem.unlocked:true

# Set integer
- flag player demeter.wheat.count:5000

# Increment integer
- flag player demeter.wheat.count:++

# Add value to integer
- flag player demeter.wheat.count:+:150

# Set with expiration
- flag player ceres.wand_cooldown expire:30s

# Set timestamp
- flag player demeter.emblem.unlock_date:<util.time_now>
```

### Removing Flags

```yaml
# Remove single flag
- flag player demeter.wheat.count:!

# Remove all flags matching pattern (NOT SUPPORTED IN DENIZEN)
# Instead, manually remove each:
- flag player demeter.wheat.count:!
- flag player demeter.wheat.keys_awarded:!
- flag player demeter.component.wheat:!
```

---

## Flag Safety & Best Practices

### 1. Always Use Defaults

```yaml
# BAD (errors if flag absent)
- define count <player.flag[demeter.wheat.count]>

# GOOD (defaults to 0)
- define count <player.flag[demeter.wheat.count].if_null[0]>
```

### 2. Check Before Awarding Once-Only Items

```yaml
# BAD (can award multiple times)
- if <[count]> >= 15000:
    - flag player demeter.component.wheat:true

# GOOD (checks if not already awarded)
- if <[count]> >= 15000 && !<player.has_flag[demeter.component.wheat]>:
    - flag player demeter.component.wheat:true
```

### 3. Use Hierarchical Structure

```yaml
# BAD (flat namespace, collision risk)
- flag player wheat_count:5000
- flag player cow_count:1000

# GOOD (hierarchical, clear ownership)
- flag player demeter.wheat.count:5000
- flag player demeter.cows.count:1000
```

### 4. Document Complex Flags

```yaml
# Flag: demeter.wheat.keys_awarded
# Purpose: Tracks how many keys have been awarded from wheat activity
# Logic: keys_should_have = floor(wheat.count / 150)
#        Award (keys_should_have - keys_awarded) keys if delta > 0
```

---

## Admin Commands for Flag Management

See `docs/testing.md` for complete command list. Key examples:

```
/demeteradmin <player> set wheat 5000
/demeteradmin <player> component wheat true
/demeteradmin <player> reset

/ceresadmin <player> item head true
/ceresadmin <player> reset

/marsadmin <player> item shield true
/marsadmin <player> reset

/emblemadmin <player> DEMETER
/rankadmin <player> set 3
```

---

## Future Flag Additions

When adding new gods/features, follow this template:

```
<god>.<activity1>.count
<god>.<activity1>.keys_awarded
<god>.<activity2>.count
<god>.<activity2>.keys_awarded
<god>.<activity3>.count
<god>.<activity3>.keys_awarded

<god>.component.<activity1>
<god>.component.<activity2>
<god>.component.<activity3>

<god>.emblem.unlocked
<god>.emblem.unlock_date

<god>.crates_opened (optional)
<god>.tier.<tier_name> (optional, per tier)
```

For meta gods:

```
<meta_god>.item.<item1>
<meta_god>.item.<item2>
<meta_god>.item.<item3>
<meta_god>.item.<item4>

<meta_god>.crates_opened (optional)
<meta_god>.god_apples (optional)
<meta_god>.unique_items (optional)
```
