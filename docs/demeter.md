# Demeter Progression - Complete Specification

## Overview

**Demeter** (Δημήτηρ) is the goddess of harvest, agriculture, and fertility.

Players with active role **Georgos (FARMING)** earn progress toward Demeter's emblem through three agricultural activities:
1. Harvesting wheat
2. Breeding cows
3. Crafting cakes

Each activity has:
- A **key threshold**: Awards 1 Demeter Key every N activities
- A **component milestone**: Awards component item once at high count

---

## Role Requirement

**CRITICAL**: All Demeter tracking ONLY occurs when:
```
<player.flag[role.active]> == FARMING
```

If player has any other role, NO counters increment, NO keys drop, NO components awarded.

Players may still:
- Use Demeter Keys (open crates)
- Trade Demeter items
- View progress in profile

---

## Activities

### Activity 1: Harvest Wheat

**Description**: Break fully-grown wheat crops

**Tracking**:
- Event: `after player breaks wheat`
- Condition: `<context.location.material.age> == 7` (fully grown only)
- Role gate: `<player.flag[role.active]> == FARMING`

**Counter Flag**: `demeter.wheat.count`

**Key Threshold**: Every 150 wheat
- Flag: `demeter.wheat.keys_awarded` (tracks multiples of 150)
- Logic:
  ```
  current_count = wheat.count
  keys_earned_so_far = wheat.keys_awarded
  keys_should_have = floor(current_count / 150)
  if keys_should_have > keys_earned_so_far:
      award (keys_should_have - keys_earned_so_far) keys
      set keys_awarded = keys_should_have
  ```

**Component Milestone**: 15,000 wheat
- Flag: `demeter.component.wheat` (boolean)
- Award: Wheat Component item (or just set flag)
- Once-only: Check if `demeter.component.wheat` is false before awarding

**Feedback**:
- On key award:
  ```
  <&e><&l>DEMETER KEY!<&r> <&7>Wheat harvested: <&a><wheat.count><&7>/15000
  ```
  - Sound: `entity_experience_orb_pickup`

- On component milestone:
  ```
  <&6><&l>MILESTONE!<&r> <&e>Wheat Component obtained! <&7>(15,000 wheat)
  ```
  - Sound: `ui_toast_challenge_complete`
  - Server announce:
    ```
    <&e>[Promachos]<&r> <&f><player.name> <&7>has obtained the <&6>Wheat Component<&7>!
    ```

**Edge Cases**:
- Silk touch: Allowed (counts as harvest)
- Fortune: Allowed (only counts as 1 harvest regardless of drop count)
- Trampling: Does NOT count (must break with tool/hand)
- Partially grown: Does NOT count (age must be 7)

---

### Activity 2: Breed Cows

**Description**: Successfully breed two cows

**Tracking**:
- Event: `after cow breeds`
- Context extraction: `<context.breeder>` (must be player)
- Role gate: `<player.flag[role.active]> == FARMING`

**Counter Flag**: `demeter.cows.count`

**Key Threshold**: Every 20 cows
- Flag: `demeter.cows.keys_awarded`
- Logic: Same as wheat (multiples of 20)

**Component Milestone**: 2,000 cows
- Flag: `demeter.component.cow`
- Award: Cow Component item (or flag)
- Once-only check

**Feedback**:
- On key award:
  ```
  <&e><&l>DEMETER KEY!<&r> <&7>Cows bred: <&a><cows.count><&7>/2000
  ```

- On component milestone:
  ```
  <&6><&l>MILESTONE!<&r> <&e>Cow Component obtained! <&7>(2,000 cows)
  ```
  - Server announce

**Edge Cases**:
- Breeder must be the player (not dispenser, not other player)
- Both parents must be adults (baby cows cannot breed)
- Baby cow spawn counts as 1 breed (don't count both parents)

---

### Activity 3: Craft Cakes

**Description**: Successfully craft cakes

**Tracking**:
- Event: `after player crafts cake`
- Role gate: `<player.flag[role.active]> == FARMING`

**Counter Flag**: `demeter.cakes.count`

**Key Threshold**: Every 5 cakes
- Flag: `demeter.cakes.keys_awarded`
- Logic: Same as wheat (multiples of 5)

**Component Milestone**: 500 cakes
- Flag: `demeter.component.cake`
- Award: Cake Component item (or flag)
- Once-only check

**Feedback**:
- On key award:
  ```
  <&e><&l>DEMETER KEY!<&r> <&7>Cakes crafted: <&a><cakes.count><&7>/500
  ```

- On component milestone:
  ```
  <&6><&l>MILESTONE!<&r> <&e>Cake Component obtained! <&7>(500 cakes)
  ```
  - Server announce

**Edge Cases**:
- Only successful crafts count (must result in cake item)
- Shift-clicking bulk crafts counts individually (e.g., 5 cakes at once = +5 count)
- Creative mode: Allowed (counts if crafting recipe used)

---

## Demeter Key

### Item Definition

**Material**: `TRIPWIRE_HOOK`

**Display Name**: `<&6><&l>DEMETER KEY<&r>`

**Lore**:
```
<&e>HEROIC

<&7>A golden key blessed by
<&7>the goddess of harvest.

<&e>Right-click to open a
<&e>Demeter Crate.
```

**NBT**:
- Enchantment: `mending:1` with `HIDE_ENCHANTS` flag (glint effect)
- Custom model data: Optional (for texture pack)

**Stackable**: Yes (normal item stack)

**Tradeable**: Yes

**Use**: Right-click (any location, any time) to open Demeter Crate

---

## Component Items

Components may be implemented as **physical items** or **flags only**. Recommend **flags only** for simplicity, but if items:

### Wheat Component

**Material**: `WHEAT`

**Display Name**: `<&6><&l>Wheat Component<&r>`

**Lore**:
```
<&6>LEGENDARY

<&7>Symbol of 15,000 wheat harvested.
<&7>Required for Demeter's Emblem.

<&8><&o>Obtained: <date>
```

**NBT**: Glint, not consumable

---

### Cow Component

**Material**: `LEATHER`

**Display Name**: `<&6><&l>Cow Component<&r>`

**Lore**:
```
<&6>LEGENDARY

<&7>Symbol of 2,000 cows bred.
<&7>Required for Demeter's Emblem.

<&8><&o>Obtained: <date>
```

---

### Cake Component

**Material**: `CAKE`

**Display Name**: `<&6><&l>Cake Component<&r>`

**Lore**:
```
<&6>LEGENDARY

<&7>Symbol of 500 cakes crafted.
<&7>Required for Demeter's Emblem.

<&8><&o>Obtained: <date>
```

---

## Progress Display (Profile GUI)

### Demeter Section

Show in `/profile` GUI when role = FARMING (or always, grayed out if inactive):

**Title**: `Demeter - Goddess of Harvest`

**Active Role Indicator**:
- If active: `<&a>● ACTIVE`
- If inactive: `<&8>○ Inactive`

**Progress Bars**:

```
Wheat: [████████░░] 8,432 / 15,000  (56%)
  ├─ Keys earned: 56
  └─ Component: ✗ Not yet obtained

Cows: [██████████] 2,000 / 2,000  (100%)
  ├─ Keys earned: 100
  └─ Component: ✓ OBTAINED

Cakes: [███░░░░░░░] 95 / 500  (19%)
  ├─ Keys earned: 31
  └─ Component: ✗ Not yet obtained
```

**Emblem Status**:
- If all components: `<&e>⚠ READY TO UNLOCK!` (clickable → Promachos)
- If incomplete: `<&7>In Progress (1/3 components)`
- If unlocked: `<&a>✓ UNLOCKED`

---

## Rank System

In addition to component milestones, Demeter has a **separate XP-based rank progression system** that provides **permanent passive buffs** while the FARMING role is active.

### Rank Tiers

| Rank | XP Required | Crop Bonus | Speed Bonus | Key Reward |
|------|-------------|------------|-------------|------------|
| Acolyte of the Farm | 1,000 | +5% | None | 5 keys |
| Disciple of the Farm | 3,500 | +10% | Speed I | 5 keys |
| Hero of the Farm | 9,750 | +15% | Speed I | 5 keys |
| Champion of the Farm | 25,375 | +20% | Speed I | 5 keys |
| Legend of the Farm | 64,438 | +25% | Speed II | 10 keys |

### XP Sources

**Crop Harvesting (fully grown only):**
- Wheat, Carrots, Potatoes, Beetroots: 2 XP
- Pumpkin, Melon: 5 XP
- Nether Wart: 3 XP
- Cocoa, Sugar Cane, Cactus, Kelp, Bamboo: 1 XP

**Animal Breeding:**
- Horse: 30 XP | Turtle: 20 XP | Llama/Hoglin: 12 XP
- Cow/Sheep/Pig: 10 XP | Rabbit/Bee: 8 XP | Chicken: 6 XP

**Food Crafting:**
- Rabbit Stew: 15 XP | Cake: 12 XP | Pumpkin Pie: 10 XP
- Suspicious Stew: 8 XP | Beetroot Soup: 6 XP | Mushroom Stew: 4 XP

### Relationship to Components

- Ranks and components are **parallel systems**
- You can achieve ranks without components, and vice versa
- Ranks provide gameplay benefits; components unlock emblems

---

## Admin Commands

See `docs/testing.md` for full command list. Key commands:

### Set Counter
```
/demeteradmin <player> set wheat <count>
/demeteradmin <player> set cows <count>
/demeteradmin <player> set cakes <count>
```

Sets counter directly. Does NOT auto-award keys or components (must manually trigger).

### Award Keys
```
/demeteradmin <player> keys <amount>
```

Gives Demeter Key items directly.

### Toggle Component
```
/demeteradmin <player> component wheat <true|false>
/demeteradmin <player> component cow <true|false>
/demeteradmin <player> component cake <true|false>
```

Sets component flag.

### Reset All
```
/demeteradmin <player> reset
```

Wipes ALL Demeter flags:
- Counters (wheat/cows/cakes)
- Keys awarded tracking
- Component flags
- Emblem unlock flag

---

## Event Handlers (Implementation)

### Wheat Harvest

```yaml
demeter_wheat_tracking:
    type: world
    events:
        after player breaks wheat:
        - if <player.flag[role.active]> != FARMING:
            - stop
        - if <context.location.material.age> != 7:
            - stop

        # Increment counter
        - flag player demeter.wheat.count:++
        - define count <player.flag[demeter.wheat.count]>

        # Check for key award (every 150)
        - define keys_awarded <player.flag[demeter.wheat.keys_awarded].if_null[0]>
        - define keys_should_have <[count].div[150].round_down>
        - if <[keys_should_have]> > <[keys_awarded]>:
            - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
            - give demeter_key quantity:<[keys_to_give]>
            - flag player demeter.wheat.keys_awarded:<[keys_should_have]>
            - narrate "<&e><&l>DEMETER KEY!<&r> <&7>Wheat: <&a><[count]><&7>/15000"
            - playsound <player> sound:entity_experience_orb_pickup

        # Check for component milestone (15,000)
        - if <[count]> >= 15000 && !<player.has_flag[demeter.component.wheat]>:
            - flag player demeter.component.wheat:true
            - narrate "<&6><&l>MILESTONE!<&r> <&e>Wheat Component obtained!"
            - playsound <player> sound:ui_toast_challenge_complete
            - announce "<&e>[Promachos]<&r> <&f><player.name> <&7>obtained the <&6>Wheat Component<&7>!"
```

### Cow Breeding

```yaml
demeter_cow_tracking:
    type: world
    events:
        after cow breeds:
        - define breeder <context.breeder>
        - if <[breeder]> == null || !<[breeder].is_player>:
            - stop
        - if <[breeder].flag[role.active]> != FARMING:
            - stop

        # Increment counter
        - flag <[breeder]> demeter.cows.count:++
        - define count <[breeder].flag[demeter.cows.count]>

        # Key award logic (every 20)
        - define keys_awarded <[breeder].flag[demeter.cows.keys_awarded].if_null[0]>
        - define keys_should_have <[count].div[20].round_down>
        - if <[keys_should_have]> > <[keys_awarded]>:
            - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
            - give <[breeder]> demeter_key quantity:<[keys_to_give]>
            - flag <[breeder]> demeter.cows.keys_awarded:<[keys_should_have]>
            - narrate "<&e><&l>DEMETER KEY!<&r> <&7>Cows: <&a><[count]><&7>/2000" targets:<[breeder]>
            - playsound <[breeder]> sound:entity_experience_orb_pickup

        # Component milestone (2,000)
        - if <[count]> >= 2000 && !<[breeder].has_flag[demeter.component.cow]>:
            - flag <[breeder]> demeter.component.cow:true
            - narrate "<&6><&l>MILESTONE!<&r> <&e>Cow Component obtained!" targets:<[breeder]>
            - playsound <[breeder]> sound:ui_toast_challenge_complete
            - announce "<&e>[Promachos]<&r> <&f><[breeder].name> <&7>obtained the <&6>Cow Component<&7>!"
```

### Cake Crafting

```yaml
demeter_cake_tracking:
    type: world
    events:
        after player crafts cake:
        - if <player.flag[role.active]> != FARMING:
            - stop

        # Increment counter (context.amount handles shift-click)
        - define craft_amount <context.amount>
        - flag player demeter.cakes.count:+:<[craft_amount]>
        - define count <player.flag[demeter.cakes.count]>

        # Key award (every 5)
        - define keys_awarded <player.flag[demeter.cakes.keys_awarded].if_null[0]>
        - define keys_should_have <[count].div[5].round_down>
        - if <[keys_should_have]> > <[keys_awarded]>:
            - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
            - give demeter_key quantity:<[keys_to_give]>
            - flag player demeter.cakes.keys_awarded:<[keys_should_have]>
            - narrate "<&e><&l>DEMETER KEY!<&r> <&7>Cakes: <&a><[count]><&7>/500"
            - playsound <player> sound:entity_experience_orb_pickup

        # Component milestone (500)
        - if <[count]> >= 500 && !<player.has_flag[demeter.component.cake]>:
            - flag player demeter.component.cake:true
            - narrate "<&6><&l>MILESTONE!<&r> <&e>Cake Component obtained!"
            - playsound <player> sound:ui_toast_challenge_complete
            - announce "<&e>[Promachos]<&r> <&f><player.name> <&7>obtained the <&6>Cake Component<&7>!"
```

---

## Testing Scenarios

### Scenario 1: Fresh Player

1. Player selects Georgos role
2. Harvest 150 wheat → Receives 1 key
3. Harvest 150 more → Receives 1 key (total 2 keys, 300 wheat)
4. Continue to 15,000 → Receives Wheat Component + 100 keys total
5. Breed 20 cows → Receives 1 key
6. Continue to 2,000 → Receives Cow Component + 100 keys total
7. Craft 5 cakes → Receives 1 key
8. Continue to 500 → Receives Cake Component + 100 keys total
9. Visit Promachos → Unlock Demeter emblem

### Scenario 2: Role Switching

1. Player has 500 wheat as Georgos (3 keys earned)
2. Switch to Metallourgos
3. Harvest 500 more wheat → NO keys, counter stays 500
4. Switch back to Georgos
5. Harvest 1 wheat → Counter now 501, no new key (next key at 600)

### Scenario 3: Component Once-Only

1. Player reaches 15,000 wheat → Component awarded
2. Player continues to 20,000 wheat → NO second component
3. Counter continues to track for keys, but component flag remains true

### Scenario 4: Bulk Crafting

1. Player shift-clicks to craft 8 cakes at once
2. Counter increments by 8 (not 1)
3. If counter was 48, now 56 → Awards 1 key (for reaching 50)

---

## Performance Considerations

- **Early exit**: Role gate checks first (cheapest operation)
- **No loops**: Single event, single increment, bounded math
- **Flag reads**: Use `.if_null[0]` to avoid errors on first access
- **Announcement spam**: Only on milestones (not every key)

---

## Future Enhancements

- **Leaderboards**: Top wheat harvesters, cow breeders, cake crafters
- **Seasonal bonuses**: Double progress weekends
- **Activity milestones**: Every 1,000 wheat → bonus loot
- **Component variants**: Gold/Silver/Bronze tiers for different thresholds
