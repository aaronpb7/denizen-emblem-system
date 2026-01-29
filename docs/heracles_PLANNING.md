# Heracles Combat System - Complete Planning Document

## Overview

**Heracles** (Ἡρακλῆς) is the greatest of Greek heroes, known for strength, courage, and slaying monsters.

Players with active role **Hoplites (COMBAT)** earn progress toward Heracles' emblem through three combat activities:
1. Killing hostile mobs
2. Taking damage from enemies
3. Defeating challenging enemies (mini-bosses/bosses)

---

## Design Philosophy

### Parallel to Demeter System

| Aspect | Demeter (Farming) | Heracles (Combat) |
|--------|-------------------|-------------------|
| **Greek Name** | Δημήτηρ (Demeter) | Ἡρακλῆς (Heracles) |
| **Roman Name** | Ceres | Mars |
| **Role** | Georgos (FARMING) | Hoplites (COMBAT) |
| **Activities** | Wheat, Cows, Cakes | Mobs, Damage, Bosses |
| **Rank Buffs** | Extra crops, Speed | Extra damage, Resistance |
| **Crate Tiers** | 5 (MORTAL→OLYMPIAN) | 5 (MORTAL→OLYMPIAN) |
| **Meta Crate** | Ceres (50/50, 4 items) | Mars (50/50, 4 items) |
| **Custom Items** | Hoe, Blessing, Title | Sword, Blessing, Title |
| **Emblem Unlock** | 3 components | 3 components |

---

## Role Requirement

**CRITICAL**: All Heracles tracking ONLY occurs when:
```
<player.flag[role.active]> == COMBAT
```

If player has any other role:
- NO counters increment
- NO keys drop
- NO components awarded

Players may still:
- Use Heracles Keys (open crates)
- Trade Heracles items
- View progress in profile

---

## Activities & Components

### Activity 1: Slay Monsters

**Description**: Kill hostile mobs

**Tracking**:
- Event: `after player kills <entity>` where entity is monster
- Role gate: `<player.flag[role.active]> == COMBAT`
- Categories:
  - **Common**: Zombie, Skeleton, Spider, Creeper, etc. (1 point each)
  - **Uncommon**: Enderman, Witch, Blaze, etc. (3 points each)
  - **Rare**: Wither Skeleton, Phantom, Shulker (5 points each)

**Counter Flag**: `heracles.monsters.count` (total points, not kills)

**Key Threshold**: Every 100 points (approx 100 common mobs)
- Flag: `heracles.monsters.keys_awarded`
- Award: 1 Heracles Key

**Component Milestone**: 10,000 points (approx 10,000 common mobs)
- Flag: `heracles.component.monsters` (boolean)
- Award: Monster Slayer Component
- Server announce: `<&c>[Promachos]<&r> <player.name> has obtained the <&4>Monster Slayer Component<&7>!`

**Point Values**:
```yaml
monsters:
  common: 1    # Zombie, Skeleton, Spider, Creeper, Cave Spider, Silverfish
  uncommon: 3  # Enderman, Witch, Blaze, Ghast, Piglin Brute, Hoglin
  rare: 5      # Wither Skeleton, Phantom, Shulker, Elder Guardian, Evoker
```

**Feedback**:
- On key: `<&c><&l>HERACLES KEY!<&r> <&7>Monsters slain: <&a><count><&7>/10000`
- Sound: `entity_experience_orb_pickup`

---

### Activity 2: Survive Combat

**Description**: Take damage from hostile sources

**Tracking**:
- Event: `after player damaged by <entity>` where entity is monster
- Role gate: `<player.flag[role.active]> == COMBAT`
- Increment: Round damage to nearest integer (min 1)

**Counter Flag**: `heracles.damage_taken.count`

**Key Threshold**: Every 500 damage taken
- Flag: `heracles.damage_taken.keys_awarded`
- Award: 1 Heracles Key

**Component Milestone**: 50,000 damage taken
- Flag: `heracles.component.damage_taken` (boolean)
- Award: Battle-Hardened Component
- Server announce: `<&c>[Promachos]<&r> <player.name> has obtained the <&4>Battle-Hardened Component<&7>!`

**Valid Damage Sources**:
- Monster melee attacks
- Monster ranged attacks (arrows, fireballs, etc.)
- Monster effects (wither, poison from witch)
- Environmental from monster (creeper explosion, TNT from creeper)

**Excluded Damage**:
- Fall damage
- Fire from lava/fire blocks (unless ignited by blaze/ghast)
- Drowning
- Starvation
- Void damage
- Self-inflicted damage

**Feedback**:
- On key: `<&c><&l>HERACLES KEY!<&r> <&7>Combat damage survived: <&a><count><&7>/50000`
- Sound: `entity_experience_orb_pickup`

---

### Activity 3: Defeat Champions

**Description**: Kill challenging boss-tier enemies

**Tracking**:
- Event: `after player kills <entity>` where entity is boss
- Role gate: `<player.flag[role.active]> == COMBAT`

**Counter Flag**: `heracles.champions.count`

**Boss Categories**:
```yaml
bosses:
  wither: 10 points
  ender_dragon: 15 points
  elder_guardian: 5 points
  warden: 20 points  # If 1.19+
```

**Key Threshold**: Every 20 points
- Flag: `heracles.champions.keys_awarded`
- Award: 1 Heracles Key
- Examples:
  - 2 Withers = 20 points = 1 key
  - 1 Wither + 2 Elder Guardians = 20 points = 1 key
  - 4 Elder Guardians = 20 points = 1 key

**Component Milestone**: 200 points
- Flag: `heracles.component.champions` (boolean)
- Award: Champion Slayer Component
- Server announce: `<&c>[Promachos]<&r> <player.name> has obtained the <&4>Champion Slayer Component<&7>!`
- Equivalent to: 20 Withers, 14 Ender Dragons, 40 Elder Guardians, or 10 Wardens

**Feedback**:
- On boss kill:
  ```
  <&4><&l>CHAMPION DEFEATED!<&r> <&c>+<points> <boss_name>
  <&7>Champions slain: <&a><total_points><&7>/200
  ```
- On key: `<&c><&l>HERACLES KEY!<&r>`
- Sound: `ui_toast_challenge_complete`

**Edge Cases**:
- Ender Dragon respawns: COUNTS (farmable)
- Wither killed by player: COUNTS
- Wither killed by environment: DOES NOT COUNT (must be player kill)
- Elder Guardian killed with indirect damage: COUNTS if player initiated

---

## Emblem Unlock Requirements

**Heracles Emblem** unlocks when ALL three components are obtained:

1. ✓ Monster Slayer Component (10,000 monster points)
2. ✓ Battle-Hardened Component (50,000 damage taken)
3. ✓ Champion Slayer Component (200 champion points)

**Unlock Ceremony**:
- Close profile GUI
- Title: `<&4><&l>HERACLES' FAVOR OBTAINED`
- Subtitle: `<&c>Strength, Courage, and Valor`
- Sound: `ui_toast_challenge_complete` + `entity_ender_dragon_growl`
- Narrate:
  ```
  <&4><&l>━━━━━━━━━━━━━━━━━━━━━━
  <&c>Heracles, greatest of heroes,
  <&c>recognizes your combat prowess.
  <&c>You have earned his emblem.
  <&4><&l>━━━━━━━━━━━━━━━━━━━━━━
  ```
- Flag: `heracles.emblem.unlocked: true`
- Reward: 10 Heracles Keys + unlock Mars crate access

---

## Combat Skill Ranks

### XP-Based Progression

Players earn **Combat XP** through combat activities (separate from component counters).

### Rank Tiers

| Rank | XP Required (Total) | XP for Rank | Damage Bonus | Defense Bonus | Key Reward |
|------|---------------------|-------------|--------------|---------------|------------|
| **Acolyte of War** | 1,000 | 1,000 | +5% melee | None | 5 keys |
| **Disciple of War** | 3,500 | 2,500 | +10% melee | Resistance I | 5 keys |
| **Hero of War** | 9,750 | 6,250 | +15% melee | Resistance I | 5 keys |
| **Champion of War** | 25,375 | 15,625 | +20% melee | Resistance II | 5 keys |
| **Legend of War** | 64,438 | 39,063 | +25% melee | Resistance II | 10 keys |

**Same XP curve as Farming** (1000 → 3500 → 9750 → 25375 → 64438)

---

### XP Award Rates

#### Monster Kills (Hostile Mobs Only)

| Mob | XP Awarded |
|-----|------------|
| **Common** (Zombie, Skeleton, Spider, Creeper, Cave Spider, Silverfish) | 2 XP |
| **Uncommon** (Enderman, Witch, Blaze, Ghast, Piglin Brute, Hoglin, Zombified Piglin) | 5 XP |
| **Rare** (Wither Skeleton, Phantom, Shulker, Vindicator, Evoker, Ravager) | 10 XP |
| **Elite** (Elder Guardian, Guardian) | 15 XP |
| **Boss** (Wither, Ender Dragon) | 50 XP |
| **Apex** (Warden, if 1.19+) | 100 XP |

**Conditions**:
- Must have `role.active = COMBAT`
- Must be player kill (not environment, not other players)
- No XP for passive mobs (cow, pig, villager, etc.)

#### Damage Taken from Hostiles

| Damage Amount | XP Awarded |
|---------------|------------|
| Per 10 damage taken | 1 XP |

**Example**: Taking 47 damage from a zombie = 4 XP (floor(47/10))

**Conditions**:
- Must have `role.active = COMBAT`
- Damage source must be hostile mob
- Min 10 damage to award XP (prevents farming trivial hits)

#### Combat Actions (Optional)

| Action | XP Awarded |
|--------|------------|
| Block attack with shield (successful) | 1 XP |
| Deflect projectile with shield | 2 XP |
| Kill mob with critical hit | Bonus +1 XP |

---

### Rank Buffs

#### Damage Bonus (Melee Only)

Applies to all melee weapon attacks (sword, axe, trident in hand):

- **Rank 1**: +5% damage (multiply final damage by 1.05)
- **Rank 2**: +10% damage
- **Rank 3**: +15% damage
- **Rank 4**: +20% damage
- **Rank 5**: +25% damage

**Implementation**:
```yaml
combat_damage_buff:
    type: world
    events:
        after player damages entity with:<item[<list[*_sword|*_axe|trident]>]>:
        - if <player.flag[role.active]> != COMBAT:
            - stop

        - define rank <proc[get_combat_rank].context[<player.flag[heracles.xp.total]>]>
        - if <[rank]> < 1:
            - stop

        - define bonus <proc[get_combat_damage_bonus].context[<[rank]>]>
        - define extra_damage <context.damage.mul[<[bonus]>]>
        - hurt <context.entity> amount:<[extra_damage]> source:player
```

#### Resistance Effect

Permanent resistance potion effect while COMBAT role is active:

- **Rank 1**: No resistance
- **Rank 2-4**: Resistance I (20% damage reduction)
- **Rank 5**: Resistance II (40% damage reduction)

**Implementation**:
```yaml
combat_resistance_buff:
    type: world
    events:
        on system time secondly every:5:
        - foreach <server.online_players> as:p:
            - if <[p].flag[role.active]> != COMBAT:
                - foreach next

            - define rank <proc[get_combat_rank].context[<[p].flag[heracles.xp.total]>]>
            - if <[rank]> < 2:
                - foreach next

            - define amplifier <proc[get_combat_resistance_bonus].context[<[rank]>]>
            - if <[amplifier]> >= 0:
                - cast resistance duration:15s amplifier:<[amplifier]> <[p]> hide_particles no_icon
```

---

### Rank-Up Ceremony

On achieving a new rank:

1. **Visual**: Title display
   ```
   Title: <&c><&l>RANK UP!
   Subtitle: <rank_name>
   ```

2. **Sound**: `entity_player_levelup`

3. **Narrate**:
   ```
   <&4><&l>━━━━━━━━━━━━━━━━━━━━━━
   <&c>Combat Rank Achieved!
   <&e><rank_name>

   <&7>Melee Damage: <&a>+<bonus>%
   <&7>Resistance: <&a><resistance_level>
   <&4><&l>━━━━━━━━━━━━━━━━━━━━━━
   ```

4. **Reward**: Award keys immediately
   - Ranks 1-4: 5 Heracles Keys each
   - Rank 5: 10 Heracles Keys

---

## Heracles Crate System

### Crate Tiers (Same as Demeter)

| Tier | Probability | Color |
|------|-------------|-------|
| MORTAL | 56% | White (<&f>) |
| HEROIC | 26% | Yellow (<&e>) |
| LEGENDARY | 12% | Gold (<&6>) |
| MYTHIC | 5% | Magenta (<&d>) |
| OLYMPIAN | 1% | Cyan (<&b>) |

### Loot Tables

#### MORTAL (56%) - Combat Supplies

Equally weighted (7 entries):

| Item | Quantity |
|------|----------|
| Arrow | 32 |
| Cooked Beef | 8 |
| Bread | 8 |
| Iron Ingot | 8 |
| Leather | 16 |
| Bone | 16 |
| Gunpowder | 8 |

#### HEROIC (26%) - Enhanced Gear

Equally weighted (5 entries):

| Item | Quantity |
|------|----------|
| Golden Apple | 2 |
| Diamond | 4 |
| Ender Pearl | 8 |
| Experience | 150 XP |
| Spectral Arrow | 16 |

#### LEGENDARY (12%) - Rare Resources

Equally weighted (4 entries):

| Item | Quantity |
|------|----------|
| Enchanted Golden Apple | 1 |
| Heracles Key | 2 |
| Diamond Block | 2 |
| Experience | 300 XP |

#### MYTHIC (5%) - Epic Items

Equally weighted (5 entries):

| Item | Quantity |
|------|----------|
| Totem of Undying | 1 |
| Heracles Sword (Custom) | 1 |
| Heracles Blessing (Custom) | 1 |
| Heracles Title (Custom) | 1 |
| Netherite Scrap | 4 |

#### OLYMPIAN (1%) - Meta Progression

Single entry:

| Item | Quantity |
|------|----------|
| Mars Key (Custom) | 1 |

---

## Custom Items

### Heracles Sword (MYTHIC)

**Material**: `NETHERITE_SWORD`

**Display Name**: `<&c><&l>HERACLES SWORD<&r>`

**Lore**:
```
<&c>MYTHIC

<&7>A netherite blade blessed by
<&7>Heracles, unbreakable and mighty.

<&e>+10% bonus damage to all mobs

<&8>Unbreakable
```

**NBT**:
- Unbreakable: true
- Enchantment: `sharpness:5` (standard sharpness)
- Enchantment: `mending:1` (hidden, for glint)

**Mechanics**:
```yaml
heracles_sword_bonus:
    type: world
    events:
        after player damages entity with:heracles_sword:
        - define bonus_damage <context.damage.mul[0.10]>
        - hurt <context.entity> amount:<[bonus_damage]> source:player
```

---

### Heracles Blessing (MYTHIC)

**Material**: `ENCHANTED_BOOK`

**Display Name**: `<&c><&l>HERACLES BLESSING<&r>`

**Lore**:
```
<&c>MYTHIC

<&7>A divine blessing from the
<&7>greatest of Greek heroes.

<&e>Right-click to boost all
<&e>incomplete Heracles activities
<&e>by 10% of their requirement.

<&8>Single-use consumable
```

**Use Effect**:
- Monsters: +1,000 points (10% of 10,000)
- Damage Taken: +5,000 damage (10% of 50,000)
- Champions: +20 points (10% of 200)

**Event**:
```yaml
on player right clicks block with:heracles_blessing:
- determine cancelled passively
- take item:heracles_blessing quantity:1

# Apply boosts
- if !<player.has_flag[heracles.component.monsters]>:
    - flag player heracles.monsters.count:+:1000
    - narrate "<&e>+1,000 monster points"

- if !<player.has_flag[heracles.component.damage_taken]>:
    - flag player heracles.damage_taken.count:+:5000
    - narrate "<&e>+5,000 damage taken"

- if !<player.has_flag[heracles.component.champions]>:
    - flag player heracles.champions.count:+:20
    - narrate "<&e>+20 champion points"

- title "title:<&c><&l>HERACLES' BLESSING" subtitle:<&e>Divine boost applied
- playsound <player> sound:block_beacon_activate
```

---

### Heracles Title (MYTHIC)

**Not a physical item** - flag-based cosmetic unlock

**Flag**: `heracles.item.title: true`

**Title Text**: `<&4>[Heracles' Champion]<&r>`

**Display**: Prefix in chat

**Example**:
```
<&4>[Heracles' Champion]<&r> PlayerName: Hello!
```

**Chat Integration**:
```yaml
heracles_title_chat:
    type: world
    events:
        on player chats:
        - if <player.has_flag[heracles.item.title]>:
            - determine passively cancelled
            - announce "<&4>[Heracles' Champion]<&r> <player.display_name><&7>: <context.message>"
```

---

## Mars Meta-Progression

**Mars** is the Roman god of war, equivalent to Greek Ares (NOT Heracles, but thematically aligned).

### Mars Key

**Material**: `NETHERITE_UPGRADE_SMITHING_TEMPLATE` or `NETHER_STAR`

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

**Source**: 1% drop from Heracles Crate (OLYMPIAN tier only)

---

### Mars Crate - 50/50 System

**Same logic as Ceres**: 50% Enchanted Golden Apple, 50% unique item from finite pool

**Finite Item Pool (4 items)**:

1. **Mars Sword** (Netherite sword, life steal mechanic)
2. **Mars Title** (Cosmetic chat title unlock: `<&4>[Mars' Chosen]`)
3. **Red Shulker Box** (Standard shulker box item)
4. **Mars Shield** (Shield with thorns-like reflection)

---

### Mars Sword (MYTHIC)

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

**Mechanics**:
```yaml
mars_sword_lifesteal:
    type: world
    events:
        after player damages entity with:mars_sword:
        - define heal <context.damage.mul[0.10]>
        - heal <player> <[heal]>
        - playeffect effect:heart at:<player.eye_location> quantity:3 offset:0.5
```

---

### Mars Shield (MYTHIC)

**Material**: `SHIELD`

**Display Name**: `<&4><&l>MARS SHIELD<&r>`

**Lore**:
```
<&4>MYTHIC

<&7>A shield blessed by Mars,
<&7>reflecting the fury of combat.

<&e>Reflects 50% of blocked damage
<&e>back to attackers

<&8>Unbreakable
<&8>Unique - One per player
```

**Mechanics**:
```yaml
mars_shield_reflect:
    type: world
    events:
        after player damaged:
        - if !<context.was_blocked>:
            - stop
        - if <player.item_in_hand.script.name.if_null[null]> != mars_shield:
            - if <player.item_in_offhand.script.name.if_null[null]> != mars_shield:
                - stop

        - define damager <context.damager>
        - if !<[damager].is_mob>:
            - stop

        - define reflect <context.damage.mul[0.50]>
        - hurt <[damager]> amount:<[reflect]> source:player
        - playeffect effect:crit at:<[damager].eye_location> quantity:5
```

---

## GUI Updates Needed

### Profile GUI - Heracles Section

**Icon**: Diamond Sword (or Netherite Sword if unlocked)

**Display**:
```
<&c><&l>HERACLES - COMBAT
<&7>Role: <&f>Hoplites

<&e>Progress:
<&7>• Monsters: <&a><count><&7>/10000 <&8>(<keys> keys)
<&7>• Damage Taken: <&a><count><&7>/50000 <&8>(<keys> keys)
<&7>• Champions: <&a><count><&7>/200 <&8>(<keys> keys)

<&e>Rank: <&c><rank_name> <&7>(<rank>/5)
<&7>• Combat XP: <&a><xp><&7>/<next_rank_xp>
<&7>• Damage Bonus: <&a>+<bonus>%
<&7>• Resistance: <&a><level>

<&e>Click for detailed view
```

**Unlocked Status**:
```
<&c><&l>HERACLES - COMBAT <&2>✓
<&7>Emblem Unlocked

<&a>All components obtained!
<&7>Rank: <&c><rank_name>
```

---

### Promachos Role Selection

Update combat role button:

**Current** (placeholder):
```
<&4>Hoplites (Combat)
<&8><&o>Select this role to begin
```

**New**:
```
<&c><&l>HOPLITES
<&7>Path of Heracles

<&e>Activities:
<&7>• Slay monsters
<&7>• Survive combat
<&7>• Defeat champions

<&e>Rewards:
<&7>• Heracles Keys (crates)
<&7>• Combat rank buffs
<&7>• Mars meta-progression

<&e>Click to select
```

---

### Emblem Check GUI

Update Heracles emblem icon:

**Before unlock**:
```
<&c><&l>Heracles' Emblem
<&7><&o>"Emblem of heroic valor"

<&e>Progress: <&7><components>/3 components

<&7>Complete three heroic deeds
<&7>to earn Heracles' favor.

<&e>Click for detailed progress
```

**Ready to unlock**:
```
<&c><&l>Heracles' Emblem <&e>⚠
<&e>READY TO UNLOCK!

<&7>All components obtained!
<&2>Click to unlock this emblem.
```

**After unlock**:
```
<&c><&l>Heracles' Emblem <&2>✓
<&2>UNLOCKED

<&7>Symbol of combat mastery.
```

---

## Implementation Files Structure

```
scripts/emblems/heracles/
├── heracles_events.dsc         # Monster kills, damage taken, champion kills
├── heracles_ranks.dsc          # XP system, rank buffs
├── heracles_crate.dsc          # Crate animation, loot tables
├── heracles_items.dsc          # Heracles Sword, Blessing, Title items
└── heracles_mechanics.dsc      # Sword bonus, blessing consumption

scripts/emblems/mars/
├── mars_crate.dsc              # 50/50 crate logic, 4 unique items
├── mars_items.dsc              # Mars Sword, Shield, Title
└── mars_mechanics.dsc          # Lifesteal, shield reflection
```

---

## Testing Scenarios

### Scenario 1: Normal Progression

1. Player selects Hoplites role
2. Kills 100 zombies → 100 monster points → 1 Heracles Key
3. Takes 500 damage from skeletons → 1 Heracles Key
4. Uses keys, gets MORTAL rewards (arrows, iron)
5. Eventually reaches 10,000 monster points → Monster Slayer Component
6. Continues until all 3 components → Emblem unlock

### Scenario 2: Rank Progression

1. Player kills monsters, earns Combat XP
2. At 1,000 XP → Rank 1 (Acolyte of War) → +5% damage, 5 keys
3. At 3,500 XP → Rank 2 (Disciple of War) → +10% damage, Resistance I, 5 keys
4. Damage bonus applies to all melee attacks
5. Resistance effect visible on player

### Scenario 3: Boss Farming

1. Player defeats Ender Dragon → 15 champion points → progress toward 200
2. Player defeats Wither → 10 champion points
3. At 20 champion points total → 1 Heracles Key
4. At 200 champion points → Champion Slayer Component

### Scenario 4: Mars Meta

1. Player opens 100 Heracles crates
2. Gets 1 Mars Key (1% OLYMPIAN drop)
3. Uses Mars Key → 50/50 roll → Gets Mars Sword
4. Mars Sword lifesteals 10% of damage
5. Player continues farming Mars Keys for other 3 items

---

## Balance Considerations

### Activity Difficulty vs Demeter

| Activity | Demeter Equivalent | Heracles | Relative Difficulty |
|----------|-------------------|----------|---------------------|
| Activity 1 | Wheat (passive farming) | Monsters (active combat) | Harder |
| Activity 2 | Cows (controlled breeding) | Damage (requires risk) | Much harder |
| Activity 3 | Cakes (simple crafting) | Bosses (end-game content) | Significantly harder |

**Conclusion**: Heracles should be slightly slower to complete than Demeter due to higher risk and effort required.

### Adjustment Levers

If progression too slow:
- Lower monster points requirement (10,000 → 7,500)
- Lower damage requirement (50,000 → 40,000)
- Increase key drop rates (100 → 75, 500 → 400)

If progression too fast:
- Increase requirements
- Add diminishing returns (later kills worth less)
- Gate behind world difficulty (Easy gives less progress)

---

## Future Enhancements

- **Kill Streaks**: Killing 10 mobs without taking damage → bonus XP
- **Boss Rush Mode**: Special challenge areas with increased boss spawn rates
- **Mars Challenges**: Special quests to earn bonus Mars Keys
- **Heracles Dialogue**: NPC encounter when first component obtained
- **PvP Integration**: Optional PvP kills count toward progression
- **Leaderboards**: Track fastest emblem unlock, highest rank, etc.

---

## Questions for Design Review

1. **Balance**: Are 10,000 monsters / 50,000 damage / 200 champions reasonable?
2. **Damage Bonus**: Is +25% melee damage at max rank balanced?
3. **Mars Items**: Should Mars Sword lifesteal be 10% or different value?
4. **Boss Points**: Should Warden be worth more than Ender Dragon?
5. **Rank Buffs**: Should resistance be persistent or only in combat?
6. **Damage Tracking**: Should environmental damage from mobs count?
7. **Kill Credit**: How to handle team kills / shared credit?

---

**End of Planning Document**

Ready for implementation once design is approved!
