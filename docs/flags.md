# Flag Reference - Authoritative List

## Overview

This document lists ALL flags used in the Emblem System V2. Flags are organized by category and include data types, purposes, and example values.

---

## Core System Flags

### Promachos

| Flag | Type | Purpose | Example Value | Set When |
|------|------|---------|---------------|----------|
| `met_promachos` | Boolean | Player has met Promachos | `true` | First interaction complete |
| `role.active` | String | Player's active role | `FARMING` | Role selected/changed |

**Valid `role.active` values**: `FARMING`, `MINING`, `COMBAT`

---

## Demeter Progression Flags

### Activity Counters

| Flag | Type | Purpose | Example Value | Incremented When |
|------|------|---------|---------------|------------------|
| `demeter.wheat.count` | Integer | Total wheat harvested | `8432` | Wheat age=7 broken, role=FARMING |
| `demeter.cows.count` | Integer | Total cows bred | `1205` | Cow breed event, role=FARMING |
| `demeter.cakes.count` | Integer | Total cakes crafted | `95` | Cake craft event, role=FARMING |

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
| `ceres.item.hoe` | Boolean | Ceres Hoe obtained | `true` | Ceres crate rolls hoe |
| `ceres.item.title` | Boolean | Ceres Title obtained | `true` | Ceres crate rolls title |
| `ceres.item.shulker` | Boolean | Yellow Shulker obtained | `true` | Ceres crate rolls shulker |
| `ceres.item.wand` | Boolean | Ceres Wand obtained | `true` | Ceres crate rolls wand |

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

## Future God Flags (Placeholder Structure)

### Hephaestus (Mining - To Be Implemented)

```
hephaestus.iron.count
hephaestus.iron.keys_awarded
hephaestus.golems.count
hephaestus.golems.keys_awarded
hephaestus.smelting.count
hephaestus.smelting.keys_awarded

hephaestus.component.iron
hephaestus.component.golem
hephaestus.component.smelting

hephaestus.emblem.unlocked
hephaestus.emblem.unlock_date
```

### Heracles (Combat - To Be Implemented)

```
heracles.pillagers.count
heracles.pillagers.keys_awarded
heracles.raids.count
heracles.raids.keys_awarded
heracles.bosses.count
heracles.bosses.keys_awarded

heracles.component.pillager
heracles.component.raid
heracles.component.boss

heracles.emblem.unlocked
heracles.emblem.unlock_date
```

### Vulcan & Mars (Meta - To Be Implemented)

```
vulcan.item.hammer
vulcan.item.title
vulcan.item.furnace
vulcan.item.tool

mars.item.sword
mars.item.title
mars.item.shield
mars.item.banner
```

---

## Next Emblem Line Flags (Gating)

### Purpose

After unlocking Demeter, gate the next farming emblem (placeholder).

| Flag | Type | Purpose | Example Value | Set When |
|------|------|---------|---------------|----------|
| `farming.next_emblem.unlocked` | Boolean | Next farming emblem line unlocked | `true` | Demeter emblem ceremony |
| `mining.next_emblem.unlocked` | Boolean | Next mining emblem line unlocked | `true` | Hephaestus emblem ceremony |
| `combat.next_emblem.unlocked` | Boolean | Next combat emblem line unlocked | `true` | Heracles emblem ceremony |

**UI Display**: "Next Emblem: To be revealed..." or "LOCKED - Complete Demeter first"

---

## Temporary/Entity Flags

### Ceres Bees

| Flag | Type | Purpose | Example Value | Set When |
|------|------|---------|---------------|----------|
| `ceres.temporary` | Expiring (Entity) | Mark bee as temporary | `expire:30s` | Bee spawned by wand |

**Applied to**: Bee entities spawned by Ceres Wand

**Purpose**: Filter bees for despawn after 30s

---

## Deprecated Flags (V1 - Do Not Use)

These flags were used in the old stage-based system and should NOT be referenced in V2 code. They are preserved for migration/rollback purposes only.

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

**Migration**: See `docs/migration.md` for mapping strategy.

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
- define role <player.flag[role.active].if_null[NONE]>

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

/ceresadmin <player> item hoe true
/ceresadmin <player> reset

/roleadmin <player> FARMING
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
