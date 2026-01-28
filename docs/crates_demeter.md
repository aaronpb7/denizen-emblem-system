# Demeter Crate - Complete Specification

## Overview

The **Demeter Crate** is opened by right-clicking a Demeter Key. It uses a tiered loot system with 5 rarity brackets:

1. **MORTAL** (56%) - Common resources
2. **HEROIC** (26%) - Valuable items
3. **LEGENDARY** (12%) - Rare rewards
4. **MYTHIC** (5%) - Very rare items
5. **OLYMPIAN** (1%) - Ultra-rare meta-progression

Each key use consumes 1 key and awards exactly 1 loot entry.

---

## Usage Mechanics

### Trigger

**Event**: `on player right clicks using:demeter_key`

**Location**: Any location (not location-gated)

**Role**: No role requirement (keys usable regardless of active role)

**Consumption**: Remove 1 key from player's hand/inventory

---

## GUI Animation

**Purpose**: Create anticipation and excitement for loot reveal

**Duration**: 2 seconds total

**Inventory**: 27 slots (3 rows)

**Title**: `Demeter Crate - Rolling...`

### Animation Sequence

**Phase 1: Opening (0.0s - 0.5s)**
- All slots filled with gray stained glass panes
- Title: `Demeter Crate - Rolling...`

**Phase 2: Cycling (0.5s - 1.5s)**
- Center slot (13) cycles through random item previews every 0.2s
- Previews drawn from loot pool (all tiers mixed)
- Creates "slot machine" effect
- Border panes remain gray

**Phase 3: Tier Reveal (1.5s - 2.0s)**
- Stop cycling
- Replace center slot with tier indicator item (colored pane)
- Update title: `Demeter Crate - <TIER NAME>!`

**Phase 4: Loot Reveal (2.0s)**
- Replace tier indicator with actual loot item
- Play sound based on tier
- Wait 1s for player to see item
- Give item to player
- Close GUI

### Tier Indicator Items

- **MORTAL**: White stained glass pane, `<&f>MORTAL`
- **HEROIC**: Yellow stained glass pane, `<&e>HEROIC`
- **LEGENDARY**: Gold stained glass pane, `<&6>LEGENDARY`
- **MYTHIC**: Light purple stained glass pane, `<&d>MYTHIC`
- **OLYMPIAN**: Nether star, `<&b>OLYMPIAN` (glint)

### Sounds

- **Opening**: `block_chest_open` (when GUI opens)
- **Cycling**: `ui_button_click` (each preview change, quiet volume)
- **MORTAL**: `entity_item_pickup`
- **HEROIC**: `entity_player_levelup`
- **LEGENDARY**: `block_enchantment_table_use`
- **MYTHIC**: `ui_toast_challenge_complete`
- **OLYMPIAN**: `ui_toast_challenge_complete` + `entity_ender_dragon_growl` (layered)

---

## Tier Probabilities

**Weighted Random Selection**:

| Tier | Weight | Probability | Cumulative |
|------|--------|-------------|------------|
| MORTAL | 56 | 56% | 0-56 |
| HEROIC | 26 | 26% | 57-82 |
| LEGENDARY | 12 | 12% | 83-94 |
| MYTHIC | 5 | 5% | 95-99 |
| OLYMPIAN | 1 | 1% | 100 |

**Total Weight**: 100

**Implementation**:
```yaml
- define roll <util.random.int[1].to[100]>
- if <[roll]> <= 56:
    - define tier MORTAL
- else if <[roll]> <= 82:
    - define tier HEROIC
- else if <[roll]> <= 94:
    - define tier LEGENDARY
- else if <[roll]> <= 99:
    - define tier MYTHIC
- else:
    - define tier OLYMPIAN
```

---

## Loot Tables

### MORTAL Tier (56% total)

Equally weighted within tier (each entry ~8% of tier, ~4.5% overall):

| Item | Quantity | Display Name |
|------|----------|--------------|
| Bread | 16 | `Bread` |
| Cooked Beef | 8 | `Cooked Beef` |
| Baked Potato | 8 | `Baked Potato` |
| Wheat | 32 | `Wheat` |
| Hay Bale | 8 | `Hay Bale` |
| Bone Meal | 16 | `Bone Meal` |
| Pumpkin Pie | 8 | `Pumpkin Pie` |

**7 entries**, equal weight per entry

---

### HEROIC Tier (26% total)

Equally weighted within tier (each entry ~5.2% of tier, ~1.4% overall):

| Item | Quantity | Display Name |
|------|----------|--------------|
| Golden Carrot | 8 | `Golden Carrot` |
| Emerald | 16 | `Emerald` |
| Gold Block | 1 | `Gold Block` |
| Experience | 100 XP | N/A (direct grant) |
| Lead | 1 | `Lead` |

**5 entries**, equal weight per entry

**Note**: "Experience 100xp" means `experience give 100` (not levels, experience points)

---

### LEGENDARY Tier (12% total)

Equally weighted within tier (each entry 3% of tier, ~0.36% overall):

| Item | Quantity | Display Name |
|------|----------|--------------|
| Golden Apple | 2 | `Golden Apple` |
| Demeter Key | 2 | `<&6><&l>DEMETER KEY` |
| Emerald Block | 6 | `Emerald Block` |
| Experience | 250 XP | N/A (direct grant) |

**4 entries**, equal weight per entry

**Note**: "Demeter Keys x2" means player gets 2 keys back (net +1 since they spent 1)

---

### MYTHIC Tier (5% total)

Equally weighted within tier (each entry 1.25% of tier, ~0.0625% overall):

| Item | Quantity | Display Name |
|------|----------|--------------|
| Enchanted Golden Apple | 1 | `Enchanted Golden Apple` |
| Demeter Hoe | 1 | `<&d><&l>DEMETER HOE` (custom) |
| Demeter Blessing | 1 | `<&d><&l>DEMETER BLESSING` (custom) |
| Gold Block | 16 | `Gold Block` |
| Emerald Block | 16 | `Emerald Block` |

**5 entries**, equal weight per entry

**Custom Items**:
- **Demeter Hoe**: Diamond hoe, Unbreakable, mythic rarity
- **Demeter Blessing**: Consumable item (see `demeter_blessing.md`)

---

### OLYMPIAN Tier (1% total)

Only one entry:

| Item | Quantity | Display Name |
|------|----------|--------------|
| Ceres Key | 1 | `<&b><&l>CERES KEY` (custom) |

**100% chance** when OLYMPIAN tier rolled

**Ceres Key**: Opens Ceres Crate (see `ceres.md`)

---

## Custom Item Definitions

### Demeter Hoe (MYTHIC)

**Material**: `DIAMOND_HOE`

**Display Name**: `<&d><&l>DEMETER HOE<&r>`

**Lore**:
```
<&d>MYTHIC

<&7>A diamond hoe blessed by
<&7>Demeter, unbreakable and eternal.

<&8>Unbreakable
```

**NBT**:
- Unbreakable: true
- Enchantment: `mending:1` (hidden, for glint)

**Mechanics**: Standard hoe, no special behavior (cosmetic/prestige item)

---

### Demeter Blessing (MYTHIC)

See full specification in `demeter_blessing.md`.

**Material**: `ENCHANTED_BOOK` (or `NETHER_STAR`)

**Display Name**: `<&d><&l>DEMETER BLESSING<&r>`

**Lore**:
```
<&d>MYTHIC

<&7>A divine blessing from the
<&7>goddess of harvest.

<&e>Right-click to boost all
<&e>incomplete Demeter activities
<&e>by 10% of their requirement.

<&8>Single-use consumable
```

**Use**: Right-click to consume (see blessing doc for mechanics)

---

### Ceres Key (OLYMPIAN)

See full specification in `ceres.md`.

**Material**: `ECHO_SHARD` (or `NETHER_STAR`)

**Display Name**: `<&b><&l>CERES KEY<&r>`

**Lore**:
```
<&b>OLYMPIAN

<&7>A key to the Roman vault,
<&7>where Ceres guards her
<&7>most precious gifts.

<&e>Right-click to open a
<&e>Ceres Crate.
```

**NBT**: Glint

**Use**: Right-click to open Ceres Crate (50/50 logic, finite items)

---

## Loot Distribution Logic

### Pseudocode

```
1. Roll tier (weighted random 1-100)
2. Get loot pool for tier
3. Randomly select one entry from pool (equal weight per entry)
4. Award loot:
   - If item: give item with quantity
   - If experience: grant XP
   - If custom item: give custom item script
5. Narrate reward message
6. Play tier sound
```

### Implementation Example

```yaml
demeter_crate_roll:
    type: task
    script:
    - define tier <proc[roll_demeter_tier]>
    - define loot <proc[get_demeter_loot].context[<[tier]>]>

    # Award loot
    - choose <[loot.type]>:
        - case ITEM:
            - give <[loot.item]> quantity:<[loot.quantity]>
        - case EXPERIENCE:
            - experience give <[loot.amount]>
        - case CUSTOM:
            - give <[loot.script]>

    # Feedback
    - narrate "<&7>[<[tier].color>]<[tier]><&7> <[loot.display]>"
    - playsound <player> sound:<[tier].sound>
```

---

## Player Communication

### On Key Use

```
<&7>You insert the <&6>Demeter Key<&7>...
```

### On Tier Roll

```
<&7>[<tier_color>]<TIER NAME><&7> <loot_name> x<quantity>
```

**Examples**:
```
<&7>[<&f>MORTAL<&7>] Bread x16
<&7>[<&e>HEROIC<&7>] Golden Carrot x8
<&7>[<&6>LEGENDARY<&7>] Demeter Key x2
<&7>[<&d>MYTHIC<&7>] Demeter Blessing x1
<&7>[<&b>OLYMPIAN<&7>] Ceres Key x1
```

### On Experience Loot

```
<&7>[<&e>HEROIC<&7>] +100 Experience
```

---

## Edge Cases

### Full Inventory

**Problem**: Player inventory full when loot awarded

**Solution**:
- Try `give` command (fills available slots)
- If no space, drop at player location: `drop <[loot]> <player.location>`
- Narrate: `<&c>Inventory full! Item dropped at your feet.`

### Key Removed During Animation

**Problem**: Player drops key or GUI closes mid-animation

**Solution**:
- Check key count BEFORE starting animation
- Remove key immediately on event trigger (before GUI opens)
- Animation runs regardless (loot already committed)

### Multiple Keys Used Rapidly

**Problem**: Player spam-clicks with stack of keys

**Solution**:
- Event cooldown: `- ratelimit <player> 3s`
- Or: Check if GUI already open, stop if true

---

## Testing Scenarios

### Scenario 1: Normal Roll

1. Player has 1 Demeter Key
2. Right-click key
3. GUI opens with animation
4. Tier rolled: HEROIC
5. Loot rolled: Golden Carrot x8
6. Player receives 8 golden carrots
7. GUI closes
8. Key consumed

### Scenario 2: OLYMPIAN Roll

1. Player right-clicks key
2. Tier rolled: OLYMPIAN (1% chance)
3. Loot: Ceres Key x1
4. Player receives Ceres Key
5. Dramatic sound plays
6. Message: `<&7>[<&b>OLYMPIAN<&7>] Ceres Key x1`

### Scenario 3: Demeter Blessing Roll

1. Tier: MYTHIC
2. Loot: Demeter Blessing
3. Player receives blessing item
4. Can use later (stackable, tradeable)

### Scenario 4: Full Inventory

1. Player inventory completely full
2. Rolls LEGENDARY → Emerald Block x6
3. 6 emerald blocks drop at player's feet
4. Message: `<&c>Inventory full! Item dropped at your feet.`

### Scenario 5: Experience Loot

1. Tier: HEROIC
2. Loot: 100 XP
3. Player's XP bar increases by 100 points (not levels)
4. Message: `<&7>[<&e>HEROIC<&7>] +100 Experience`

---

## Statistics Tracking (Optional)

For player profiles or leaderboards, track:

- `demeter.crates_opened` (total count)
- `demeter.tier.mortal` (count per tier)
- `demeter.tier.heroic`
- `demeter.tier.legendary`
- `demeter.tier.mythic`
- `demeter.tier.olympian`

**Increment on roll**:
```yaml
- flag player demeter.crates_opened:++
- flag player demeter.tier.<[tier].to_lowercase>:++
```

---

## Performance Considerations

- **Animation length**: Keep at 2s (balance excitement vs. efficiency)
- **Inventory updates**: Minimize (one open, one close, one loot update)
- **Sound spam**: Use reasonable volume, single sound per tier (not per cycle)
- **Async rolls**: Consider `~run` for task if animation causes lag

---

## Future Enhancements

- **Bad luck protection**: Guarantee MYTHIC+ every 100 rolls
- **Tier preview**: Show probability percentages in GUI
- **Statistics display**: `/profile` shows tier distribution
- **Streak bonuses**: Open 10 in a row → bonus loot
- **Seasonal crates**: Special loot pools during events
