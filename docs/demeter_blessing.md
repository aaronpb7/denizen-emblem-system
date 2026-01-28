# Demeter Blessing - Complete Specification

## Overview

**Demeter Blessing** is a MYTHIC-tier consumable item that boosts progress toward incomplete Demeter component milestones.

**Source**: 1.25% chance from Demeter Crate (MYTHIC tier, 1 of 5 entries)

**Function**: Adds +10% of requirement to each incomplete activity counter, capped at the requirement.

**Properties**:
- Stackable (normal stack limit)
- Tradeable (yes)
- Single-use (consumed on activation)
- No role requirement (usable regardless of active role)

---

## Item Definition

### Material

**Option 1**: `ENCHANTED_BOOK`
**Option 2**: `NETHER_STAR`

Recommend **NETHER_STAR** for visual distinctiveness.

### Display Name

```
<&d><&l>DEMETER BLESSING<&r>
```

### Lore

```
<&d>MYTHIC

<&7>A divine blessing from the
<&7>goddess of harvest, imbued
<&7>with her abundant grace.

<&e>Right-click to boost progress
<&e>on all incomplete Demeter
<&e>activities by 10%.

<&8>Single-use consumable
<&8>Stackable & tradeable
```

### NBT

- Enchantment: `mending:1` (hidden, for glint)
- Custom model data: Optional (for texture pack)

---

## Usage Mechanics

### Trigger

**Event**: `on player right clicks using:demeter_blessing`

**Location**: Any location (not location-gated)

**Role**: No role requirement (blessing usable even if role ≠ FARMING)

**Consumption**: Remove 1 blessing from player's hand after use

---

## Boost Logic

### Requirements

- **Wheat**: 15,000 (component at `demeter.component.wheat`)
- **Cows**: 2,000 (component at `demeter.component.cow`)
- **Cakes**: 500 (component at `demeter.component.cake`)

### Boost Amounts (10% of requirement)

- **Wheat**: +1,500 per use
- **Cows**: +200 per use
- **Cakes**: +50 per use

### Rules

1. **Only boosts incomplete activities**:
   - If `demeter.component.wheat == true`, skip wheat boost
   - If `demeter.component.cow == true`, skip cow boost
   - If `demeter.component.cake == true`, skip cake boost

2. **Caps at requirement**:
   - If wheat counter is 14,000, boost adds 1,500 → capped at 15,000
   - Cannot exceed milestone threshold

3. **Does NOT auto-award components or keys**:
   - Blessing only increments counters
   - Player must naturally trigger milestone/key thresholds afterward
   - **Example**: If wheat goes from 14,000 → 15,000, component flag is NOT set immediately. Player must harvest 1 more wheat to trigger component award.
   - **Alternative implementation** (your choice): Blessing triggers milestone checks immediately if threshold crossed.

4. **Cannot be used if ALL complete**:
   - If all 3 components already obtained, block usage
   - Message: `<&e><&l>Demeter<&r><&7> has no further need of this blessing.`
   - Do NOT consume item

---

## Implementation

### Pseudocode

```
1. Check if ALL components complete:
   - If yes: block use, narrate rejection, stop
2. Initialize boost list
3. For each activity (wheat, cows, cakes):
   - If component NOT complete:
     - Get current counter
     - Add boost amount (+10%)
     - Cap at requirement
     - Set new counter
     - Add to boost report
4. Consume 1 blessing from hand
5. Narrate boost report
6. Play success sound
7. Optional: Check if any milestones now reached
```

### Script Example

```yaml
demeter_blessing_use:
    type: world
    events:
        on player right clicks using:demeter_blessing:
        # Check if all complete
        - if <player.has_flag[demeter.component.wheat]> && <player.has_flag[demeter.component.cow]> && <player.has_flag[demeter.component.cake]>:
            - narrate "<&e><&l>Demeter<&r><&7> has no further need of this blessing."
            - playsound <player> sound:entity_villager_no
            - determine cancelled
            - stop

        # Initialize report
        - define boosted <list>

        # Boost wheat (if incomplete)
        - if !<player.has_flag[demeter.component.wheat]>:
            - define current <player.flag[demeter.wheat.count].if_null[0]>
            - define new_count <[current].add[1500].min[15000]>
            - flag player demeter.wheat.count:<[new_count]>
            - define boosted <[boosted].include[<&6>Wheat<&7>: +<[new_count].sub[<[current]>]> (<[current]> → <[new_count]>)]>

        # Boost cows (if incomplete)
        - if !<player.has_flag[demeter.component.cow]>:
            - define current <player.flag[demeter.cows.count].if_null[0]>
            - define new_count <[current].add[200].min[2000]>
            - flag player demeter.cows.count:<[new_count]>
            - define boosted <[boosted].include[<&6>Cows<&7>: +<[new_count].sub[<[current]>]> (<[current]> → <[new_count]>)]>

        # Boost cakes (if incomplete)
        - if !<player.has_flag[demeter.component.cake]>:
            - define current <player.flag[demeter.cakes.count].if_null[0]>
            - define new_count <[current].add[50].min[500]>
            - flag player demeter.cakes.count:<[new_count]>
            - define boosted <[boosted].include[<&6>Cakes<&7>: +<[new_count].sub[<[current]>]> (<[current]> → <[new_count]>)]>

        # Consume item
        - take item:demeter_blessing quantity:1

        # Narrate results
        - narrate "<&d><&l>DEMETER BLESSING ACTIVATED!<&r>"
        - foreach <[boosted]>:
            - narrate "  <[value]>"
        - playsound <player> sound:block_enchantment_table_use
        - playeffect effect:villager_happy at:<player.location> quantity:30 offset:1.0

        # Optional: Trigger milestone checks (if you want immediate component awards)
        # (See demeter_events.dsc for milestone logic)
```

---

## Player Communication

### On Successful Use

```
<&d><&l>DEMETER BLESSING ACTIVATED!<&r>
  <&6>Wheat<&7>: +1500 (10,000 → 11,500)
  <&6>Cows<&7>: +200 (800 → 1,000)
  <&6>Cakes<&7>: +50 (150 → 200)
```

**Note**: Only shows activities that were incomplete

### On Blocked Use (All Complete)

```
<&e><&l>Demeter<&r><&7> has no further need of this blessing.
```

Sound: `entity_villager_no`

### On Capped Boost

```
<&d><&l>DEMETER BLESSING ACTIVATED!<&r>
  <&6>Wheat<&7>: +500 (14,500 → 15,000) <&a>MAX REACHED
  <&6>Cakes<&7>: +50 (250 → 300)
```

**Note**: Wheat was capped at 15,000 (14,500 + 1,500 = 16,000, capped to 15,000)

---

## Edge Cases

### Case 1: Only One Activity Incomplete

**Scenario**: Player has wheat and cow components, only cakes remaining

**Before Use**:
- Wheat: 15,000 (complete)
- Cows: 2,000 (complete)
- Cakes: 120

**After Use**:
- Wheat: 15,000 (unchanged)
- Cows: 2,000 (unchanged)
- Cakes: 170 (+50)

**Message**:
```
<&d><&l>DEMETER BLESSING ACTIVATED!<&r>
  <&6>Cakes<&7>: +50 (120 → 170)
```

---

### Case 2: All Complete

**Scenario**: Player has all 3 components

**Result**: Use blocked, item NOT consumed

---

### Case 3: Near-Cap Boost

**Scenario**: Wheat at 14,800

**Before Use**:
- Wheat: 14,800

**Boost**: +1,500 → 16,300 (exceeds 15,000)

**After Use**:
- Wheat: 15,000 (capped)

**Message**:
```
<&d><&l>DEMETER BLESSING ACTIVATED!<&r>
  <&6>Wheat<&7>: +1200 (14,800 → 15,000) <&a>MILESTONE REACHED!
```

---

### Case 4: Multiple Blessings Used

**Scenario**: Player has 5 blessings, uses all at once

**Result**:
- Each use increments counter by +10%
- If cakes are 0 → 50 → 100 → 150 → 200 → 250 after 5 uses
- Stackable item means player must click 5 times (1 item consumed per click)

---

### Case 5: Zero Progress

**Scenario**: Player has never done any Demeter activities (all counters at 0)

**Before Use**:
- Wheat: 0
- Cows: 0
- Cakes: 0

**After Use**:
- Wheat: 1,500
- Cows: 200
- Cakes: 50

**Message**:
```
<&d><&l>DEMETER BLESSING ACTIVATED!<&r>
  <&6>Wheat<&7>: +1500 (0 → 1,500)
  <&6>Cows<&7>: +200 (0 → 200)
  <&6>Cakes<&7>: +50 (0 → 50)
```

---

## Milestone & Key Interaction

### Decision Point: When to Award Components/Keys?

**Option A**: Blessing ONLY increments counters, does NOT trigger milestone/key awards
- Player must perform 1 more activity to trigger award event
- Example: Wheat goes 14,000 → 15,000 via blessing, but component NOT awarded until player harvests 1 more wheat
- **Pro**: Simpler logic, consistent with natural activity tracking
- **Con**: Slightly confusing for players ("I hit 15k, why no component?")

**Option B**: Blessing checks thresholds after boosting and awards immediately
- After incrementing counters, run milestone/key award logic
- Example: Wheat goes 14,000 → 15,000 via blessing → component awarded instantly
- **Pro**: More intuitive for players
- **Con**: Duplicates milestone logic in two places (events + blessing)

**Recommendation**: **Option B** (immediate awards)

**Implementation** (Option B):
```yaml
# After setting new_count for wheat
- if <[new_count]> >= 15000 && !<player.has_flag[demeter.component.wheat]>:
    - flag player demeter.component.wheat:true
    - narrate "<&6><&l>MILESTONE!<&r> <&e>Wheat Component obtained!"
    - playsound <player> sound:ui_toast_challenge_complete

# Similar for cows (2,000) and cakes (500)
```

**Key Award Logic**:
```yaml
# After setting new_count for wheat
- define keys_awarded <player.flag[demeter.wheat.keys_awarded].if_null[0]>
- define keys_should_have <[new_count].div[150].round_down>
- if <[keys_should_have]> > <[keys_awarded]>:
    - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
    - give demeter_key quantity:<[keys_to_give]>
    - flag player demeter.wheat.keys_awarded:<[keys_should_have]>
    - narrate "<&e><&l>BONUS KEYS!<&r> <&7>+<[keys_to_give]> Demeter Keys"
```

---

## Testing Scenarios

### Test 1: Normal Use

1. Player has wheat: 5,000, cows: 500, cakes: 100
2. Right-click blessing
3. Counters update: wheat: 6,500, cows: 700, cakes: 130
4. Keys awarded if thresholds crossed (e.g., wheat 5,000 → 6,500 awards 10 keys: 5,100/5,250/.../6,450)
5. Blessing consumed
6. Message shows all 3 boosts

### Test 2: One Complete

1. Player has wheat component (15k+), cows: 1,000, cakes: 200
2. Use blessing
3. Only cows and cakes boosted
4. Wheat unchanged
5. Message shows 2 boosts only

### Test 3: All Complete

1. Player has all 3 components
2. Right-click blessing
3. Message: "Demeter has no further need..."
4. Blessing NOT consumed
5. Sound: villager_no

### Test 4: Near-Cap

1. Wheat at 14,900
2. Use blessing (+1,500)
3. Capped at 15,000
4. Component awarded
5. Message shows "+1100 (14,900 → 15,000) MILESTONE REACHED!"

### Test 5: Multiple Uses

1. Player has 3 blessings
2. Clicks 3 times rapidly
3. Each use boosts by 10%
4. Counters stack: 0 → 1,500 → 3,000 → 4,500
5. All 3 blessings consumed

---

## Balance Considerations

### Value Calculation

**Wheat**: 15,000 harvests → 100 keys
- Blessing grants +1,500 harvests → ~10 keys worth
- MYTHIC tier rarity (~0.0625% per crate) → 1 blessing per ~1,600 keys opened
- **Balanced**: Blessing worth 10 keys, drops every 1,600 keys (massive net loss if purely farming blessings)

**Cows**: 2,000 breeds → 100 keys
- Blessing grants +200 breeds → ~10 keys worth
- Same rarity, same value ratio

**Cakes**: 500 crafts → 100 keys
- Blessing grants +50 crafts → ~10 keys worth
- Same rarity, same value ratio

**Conclusion**: Blessing is a **boost/convenience item**, not a farming target. Players use it to skip ~10% of grind per activity.

### Stackability Risk

**Risk**: Players hoard hundreds of blessings, skip entire progression

**Mitigation**:
- 0.0625% drop rate (1 per ~1,600 crates) → incredibly rare
- Trading enabled but requires high value exchange
- 10% boost per use → need 10 blessings to skip 100% (statistically impossible to obtain 10)

**Verdict**: Stackability safe given rarity

---

## Future Enhancements

- **Tiered Blessings**: Greater Blessing (+20%), Supreme Blessing (+50%)
- **Targeted Blessings**: Wheat-only, Cow-only, Cake-only blessings (more common, specific)
- **Blessing Shop**: Trade rare currency for blessings (controlled supply)
- **Blessing Cooldown**: Per-player cooldown (e.g., 1 use per hour) to prevent rapid stacking
