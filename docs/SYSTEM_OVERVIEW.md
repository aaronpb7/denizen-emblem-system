# Promachos - Role-Based Progression System

## Overview

The Promachos system is a role-based progression framework where players choose one of three paths (FARMING, MINING, COMBAT) and progress through activities to earn keys, unlock crate rewards, and obtain cosmetic titles.

**System Architecture:**
- **3 Main Roles**: FARMING (Demeter), MINING (Hephaestus), COMBAT (Heracles)
- **Activity Tracking**: Players earn keys by completing role-specific activities
- **Component Milestones**: One-time achievements at high activity counts (unlock emblems)
- **Rank System**: Tiered progression with passive gameplay buffs (3 ranks per role)
- **Emblem System**: Cosmetic unlocks earned by completing all components in a god line
- **Crate System**: Keys unlock tiered crates with rewards (5 tiers per crate)
- **Meta-Progression**: Ultra-rare Roman god crates (Ceres, Vulcan, Mars) with finite unique items
- **Cosmetics**: Unlockable chat title prefixes from crates

---

## Project Structure

```
scripts/
├── profile_gui.dsc                 # Main /profile command and UI
├── bulletin.dsc                    # Server announcements system
└── emblems/
    ├── core/
    │   ├── roles.dsc              # Role data and procedures
    │   ├── promachos.dsc          # NPC interactions and role selection
    │   └── item_utilities.dsc     # Shared item procedures
    ├── admin/
    │   └── admin_commands.dsc     # Admin testing commands
    ├── demeter/  (FARMING)
    │   ├── demeter_events.dsc     # Activity tracking (wheat, cows, cakes)
    │   ├── demeter_ranks.dsc      # Rank progression system
    │   ├── demeter_crate.dsc      # Demeter crate opening system
    │   ├── demeter_blessing.dsc   # Demeter Blessing consumable
    │   └── demeter_items.dsc      # Custom items (key, hoe, blessing, title)
    ├── ceres/  (FARMING META)
    │   ├── ceres_crate.dsc        # Ceres vault (meta-progression)
    │   ├── ceres_mechanics.dsc    # Chat title handler
    │   └── ceres_items.dsc        # Unique items (hoe, title, shulker, wand)
    ├── hephaestus/  (MINING - PLACEHOLDER)
    │   ├── hephaestus_crate.dsc   # Placeholder crate system
    │   └── vulcan_crate.dsc       # Placeholder meta-progression
    ├── heracles/  (COMBAT - ✅ COMPLETE)
    │   ├── heracles_events.dsc    # Activity tracking (pillagers, raids, emeralds)
    │   ├── heracles_ranks.dsc     # Rank progression system
    │   ├── heracles_crate.dsc     # Heracles crate opening system
    │   ├── heracles_blessing.dsc  # Heracles Blessing consumable
    │   └── heracles_items.dsc     # Custom items (key, sword, blessing, title)
    └── mars/  (COMBAT META - ✅ COMPLETE)
        ├── mars_crate.dsc         # Mars arena (meta-progression)
        └── mars_items.dsc         # Unique items (sword, shield, title, shulker)
```

---

## Role System

### Role Selection

Players interact with **Promachos NPC** (requires `met_promachos` flag) to choose their path:

| Role ID | Display Name | Greek Name | God | Activities |
|---------|--------------|------------|-----|------------|
| FARMING | Farmer | Georgos | Demeter | Wheat harvesting, cow breeding, cake crafting |
| MINING | Miner | Metallourgos | Hephaestus | Mining ores, smelting (TBD) |
| COMBAT | Warrior | Hoplites | Heracles | Pillager slaying, raid defense, emerald trading |

**Key Mechanics:**
- Players can switch roles at any time
- Progress is preserved across role changes
- Only activities performed with active role count toward progression
- Flag: `role.active` (value: "FARMING", "MINING", or "COMBAT")

### Role Colors

```yaml
FARMING: <&6>  (Gold)
MINING:  <&c>  (Red)
COMBAT:  <&4>  (Dark Red)
```

---

## Progression System

### Activity Tracking (Example: Demeter/Farming)

| Activity | Key Interval | Milestone | Component Reward |
|----------|--------------|-----------|------------------|
| Wheat Harvesting | Every 150 wheat | 15,000 total | Wheat Component |
| Cow Breeding | Every 20 cows | 2,000 total | Cow Component |
| Cake Crafting | Every 3 cakes | 300 total | Cake Component |

**Flags:**
```
demeter.wheat.count              # Total wheat harvested
demeter.wheat.keys_awarded       # Keys given (prevents double awards)
demeter.component.wheat          # Boolean: milestone reached

demeter.cows.count
demeter.cows.keys_awarded
demeter.component.cow

demeter.cakes.count
demeter.cakes.keys_awarded
demeter.component.cake
```

### Rank System

**3 tiered ranks per role** that provide **permanent passive buffs** when role is active.

**Example: Demeter (FARMING)**

| Rank | Requirements | Buffs |
|------|-------------|-------|
| **Acolyte of Demeter** | 2,500 wheat + 50 cows | Haste I, +5% crop drops |
| **Disciple of Demeter** | 12,000 wheat + 300 cows | Haste II, +20% crop drops, 10% twin breeding |
| **Hero of Demeter** | 50,000 wheat + 700 cows | Haste II, +50% crop drops, 30% twin breeding |

**Key Features:**
- Ranks require **dual activity thresholds** (wheat AND cows for Demeter)
- Buffs apply **only when corresponding role is active**
- Rank-up triggers **ceremony with server announcement**
- Ranks are **parallel to component milestones** (not sequential)

**Flag:** `demeter.rank` (value: 0-3, calculated dynamically)

**See:** `docs/demeter_ranks.md` for complete rank specification

---

## Crate System

### Tier Structure (Standard Crates)

| Tier | Probability | Color | Rewards |
|------|------------|-------|---------|
| MORTAL | 56% | <&f>White | Basic resources, low-tier items |
| HEROIC | 26% | <&9>Blue | Mid-tier items, enchanted gear |
| LEGENDARY | 12% | <&5>Purple | High-tier items, rare materials |
| MYTHIC | 5% | <&d>Pink | Unique items, titles |
| OLYMPIAN | 1% | <&b>Cyan | Meta-progression keys (Ceres/Vulcan/Mars) |

### Demeter Crate

**Key:** `demeter_key` (tripwire_hook)

**Animation:**
- 3-phase scrolling animation (~4.75 seconds)
- Phase 1: Fast scroll (20 cycles, 2t each)
- Phase 2: Medium scroll (10 cycles, 3t each)
- Phase 3: Slow scroll (5 cycles, 5t each)
- Final landing with item reveal

**Early Close:**
- Players can close inventory anytime
- Loot is pre-rolled before animation starts
- Closing early awards loot immediately and stops animation
- No duplicate awards

**MYTHIC Loot Pool:**
- `demeter_title` (unlocks "Harvest Queen" chat prefix)
- `demeter_hoe` (custom tool)
- `demeter_blessing` (consumable item)
- High-tier resources

**OLYMPIAN Loot:**
- 1% chance: `ceres_key` (meta-progression)

### Meta-Progression (Ceres Crate)

**Key:** `ceres_key` (nether_star)
**Source:** 1% drop from Demeter OLYMPIAN tier

**Unique Items Pool (Finite):**
1. `ceres_hoe` - Legendary farming tool
2. `ceres_title` - "Ceres' Chosen" chat prefix
3. `ceres_shulker` - Special shulker box
4. `ceres_wand` - Unique item

**Mechanics:**
- 50% chance: High-tier farming reward
- 50% chance: Unique item from pool (if not all obtained)
- Once all 4 items obtained → always high-tier reward
- Tracks obtained items with flags: `ceres.item.hoe`, `ceres.item.title`, etc.

**Cyan border theme** (matches farming aesthetic)

---

## Cosmetics System

### Title System

Players can equip one chat title prefix at a time via `/profile` → Cosmetics menu.

**Available Titles:**

| Title | Flag | Display | Unlock Source | Color |
|-------|------|---------|---------------|-------|
| Ceres' Chosen | `ceres.item.title` | [Ceres' Chosen] | Ceres Crate | <&6>Gold |
| Harvest Queen | `demeter.item.title` | [Harvest Queen] | Demeter Crate (MYTHIC) | <&6>Gold |
| The Unconquered | `heracles.item.title` | [The Unconquered] | Heracles Crate (MYTHIC) | <&c>Red |

**Active Title Flag:** `cosmetic.title.active` (value: "ceres", "demeter", or "heracles")

**Chat Format:**
```
<&6>[Ceres' Chosen]<&r> PlayerName<&7>: message
```

**Cosmetics Menu:**
- Shows all 3 title slots
- Locked titles show as `???` with unlock source
- Unlocked titles show preview and equip/unequip button
- Only one title can be active at a time
- Clicking active title unequips it

---

## Custom Items

### Demeter Items

| Script Name | Material | Purpose |
|-------------|----------|---------|
| `demeter_key` | tripwire_hook | Opens Demeter Crate |
| `demeter_hoe` | diamond_hoe | MYTHIC tier reward |
| `demeter_blessing` | honey_bottle | Consumable buff item |
| `demeter_title` | name_tag | Unlocks "Harvest Queen" title (virtual) |

### Ceres Items

| Script Name | Material | Purpose |
|-------------|----------|---------|
| `ceres_key` | nether_star | Opens Ceres Vault (meta) |
| `ceres_hoe` | netherite_hoe | Unique farming tool |
| `ceres_title` | name_tag | Unlocks "Ceres' Chosen" title (virtual) |
| `ceres_shulker` | shulker_box | Special storage |
| `ceres_wand` | blaze_rod | Unique item |

### Hephaestus Items (Placeholder)

| Script Name | Material | Purpose |
|-------------|----------|---------|
| `hephaestus_key` | tripwire_hook | Opens Hephaestus Crate (TBD) |

### Heracles Items (✅ Complete)

| Script Name | Material | Purpose |
|-------------|----------|---------|
| `heracles_key` | tripwire_hook | Opens Heracles Crate (5 tiers) |
| `heracles_sword` | diamond_sword | Unbreakable cosmetic sword (MYTHIC) |
| `heracles_blessing` | enchanted_book | +10% progress boost consumable (MYTHIC) |
| `heracles_title` | flag-based | `[Hero of Olympus]` chat prefix (MYTHIC) |

### Mars Items (✅ Complete)

| Script Name | Material | Purpose |
|-------------|----------|---------|
| `mars_key` | nether_star | Opens Mars Crate (50/50 system) |
| `mars_sword` | netherite_sword | 10% lifesteal netherite sword |
| `mars_shield` | shield | Active resistance buff (3min cooldown) |
| `mars_title` | flag-based | `[Mars' Chosen]` chat prefix |
| `gray_shulker_box` | gray_shulker_box | Unique collectible |

---

## Admin Commands

### Role Management

```
/demeteradmin setrole <player> <role>
```
Sets player's active role (FARMING, MINING, COMBAT).

### Progress Testing

**Wheat Progress:**
```
/demeteradmin setwheat <player> <amount>
/demeteradmin addwheat <player> <amount>
```

**Cow Progress:**
```
/demeteradmin setcows <player> <amount>
/demeteradmin addcows <player> <amount>
```

**Cake Progress:**
```
/demeteradmin setcakes <player> <amount>
/demeteradmin addcakes <player> <amount>
```

**Components:**
```
/demeteradmin givecomponent <player> <wheat|cow|cake>
/demeteradmin removecomponent <player> <wheat|cow|cake>
```

**Keys:**
```
/demeteradmin givekey <player> <amount>
```

**Rank:**
```
/demeteradmin setrank <player> <BRONZE|SILVER|GOLD|PLATINUM|DIAMOND>
```

**Reset:**
```
/demeteradmin reset <player>
```
Wipes all Demeter progress and flags.

---

## Bulletin System

Server-wide announcements shown on join and accessible via `/profile`.

**Version Control:**
- `bulletin_data` script contains current version number
- Players see notification if their `bulletin.seen_version` < current version
- Bulletin icon shows "NEW!" badge with glint if unread

**Adding Updates:**
1. Increment `version` in `bulletin_data`
2. Add new items to `bulletin_inventory` slots
3. All players will see notification on next join

---

## Flag Reference

### Core Flags
```
met_promachos              # Boolean: Introduced to NPC
role.active                # String: "FARMING", "MINING", "COMBAT"
role.changed_before        # Boolean: Has switched roles at least once
```

### Demeter Flags
```
# Activity Progress
demeter.wheat.count
demeter.wheat.keys_awarded
demeter.component.wheat
demeter.component.wheat_date

demeter.cows.count
demeter.cows.keys_awarded
demeter.component.cow
demeter.component.cow_date

demeter.cakes.count
demeter.cakes.keys_awarded
demeter.component.cake
demeter.component.cake_date

# Rank System
demeter.rank               # String: "BRONZE", "SILVER", etc.

# Crate System
demeter.crates_opened      # Total crates opened
demeter.tier.mortal        # Count per tier
demeter.tier.heroic
demeter.tier.legendary
demeter.tier.mythic
demeter.tier.olympian

# Item Unlocks
demeter.item.title         # Boolean: Has Demeter Title
```

### Ceres Flags
```
# Crate System
ceres.crates_opened

# Unique Items (Finite Pool)
ceres.item.hoe
ceres.item.title
ceres.item.shulker
ceres.item.wand

# Meta Stats
ceres.unique_items         # Count of unique items obtained
```

### Cosmetics Flags
```
cosmetic.title.active      # String: "ceres", "demeter", "heracles" (or not set)
```

### Bulletin Flags
```
bulletin.seen_version      # Integer: Last bulletin version viewed
```

---

## Implementation Status

### ✅ Completed Systems

- ✅ Core role selection and switching
- ✅ Demeter activity tracking (wheat, cows, cakes)
- ✅ Demeter rank progression (5 ranks with buffs)
- ✅ Demeter crate system (5 tiers, scrolling animation)
- ✅ Demeter Blessing consumable (+10% progress boost)
- ✅ Ceres meta-progression crate (50/50 system, 4 unique items)
- ✅ Ceres custom items (hoe auto-replant, wand bee summon)
- ✅ Heracles rank progression (5 ranks with buffs)
- ✅ Heracles crate system (5 tiers, combat theme)
- ✅ Heracles Blessing consumable (+10% progress boost)
- ✅ Mars meta-progression crate (50/50 system, 4 unique items)
- ✅ Mars custom items (sword lifesteal, shield resistance buff)
- ✅ Cosmetics system (title equipping/unequipping)
- ✅ Chat title prefixes (Demeter, Ceres, Heracles, Mars)
- ✅ Profile GUI with role display
- ✅ Promachos NPC with emblem unlock ceremonies
- ✅ Bulletin system
- ✅ Admin commands for testing
- ✅ Early close handling for crates (no duplicate awards)

### 🚧 Placeholder/Incomplete

- 🚧 Hephaestus (Mining) - All systems (role exists but no activities)
- 🚧 Vulcan meta-progression (Mining meta)
- 🚧 Heracles activity tracking events (pillagers, raids, emerald trading)
- 🚧 Heracles rank buff mechanics (low health regen, vanilla XP bonus)

### 🔜 Future Enhancements

- Additional cosmetics (particles, sounds, etc.)
- Leaderboards per role
- Seasonal challenges
- Cross-role rewards
- Guild/team progression

---

## Adding New Roles

### Checklist

1. **Create folder structure:**
   - `scripts/emblems/<role_name>/`
   - `scripts/emblems/<roman_name>/` (meta-progression)

2. **Update `roles.dsc`:**
   - Add role to `roles` list
   - Add Greek name to `greek_names`
   - Add god name to `gods`
   - Add color to `colors`
   - Add icon material to `icons`

3. **Create activity tracking:**
   - `<role_name>_events.dsc` with event handlers
   - Track activities with flags: `<role>.activity.count`
   - Award keys at intervals
   - Award components at milestones

4. **Create rank system:**
   - `<role_name>_ranks.dsc` with 5 ranks
   - Check procedure: `<role>_check_rank`
   - Flag: `<role>.rank`

5. **Create crate system:**
   - `<role_name>_crate.dsc` with 5 tiers
   - Tier rolling procedure
   - Loot rolling procedure
   - Scrolling animation (copy from demeter_crate.dsc)
   - Early close handler

6. **Create meta-progression:**
   - `<roman_name>_crate.dsc` with finite pool (4 unique items)
   - 50/50 split between reward and unique item
   - Track obtained items with flags

7. **Create custom items:**
   - Key item (tripwire_hook)
   - Meta key (nether_star)
   - Title items (name_tag)
   - Unique rewards

8. **Update cosmetics system:**
   - Add title to `profile_gui.dsc` cosmetics menu
   - Add case to `title_chat_handler` in `ceres_mechanics.dsc`

9. **Create admin commands:**
   - Progress setters/adders
   - Component management
   - Key giving
   - Rank setting
   - Reset command

10. **Update profile GUI:**
    - Add role icon to emblem selection
    - Add progress display for role

---

## Development Guidelines

### Naming Conventions

- **Flags:** `<role>.category.subcategory` (e.g., `demeter.wheat.count`)
- **Scripts:** `<role>_purpose` (e.g., `demeter_events`)
- **Items:** `<role>_item_name` (e.g., `demeter_key`)
- **Procedures:** `<role>_action_noun` (e.g., `demeter_check_rank`)
- **Tasks:** `<role>_action` (e.g., `demeter_crate_animation`)

### File Organization

- **Events:** Activity tracking, key awarding
- **Ranks:** Rank checking and display
- **Crate:** Opening animation, loot rolling, reward awarding
- **Items:** Item definitions only (no mechanics)
- **Mechanics:** Item abilities, special interactions

### Code Patterns

**Activity Tracking:**
```yaml
<role>_<activity>_tracking:
    type: world
    events:
        on <event>:
        # Role gate
        - if <player.flag[role.active]> != <ROLE>:
            - stop

        # Increment counter
        - flag player <role>.<activity>.count:++
        - define count <player.flag[<role>.<activity>.count]>

        # Check for rank-up
        - run <role>_check_rank def.player:<player>

        # Check for key award
        - define keys_awarded <player.flag[<role>.<activity>.keys_awarded].if_null[0]>
        - define keys_should_have <[count].div[INTERVAL].round_down>
        - if <[keys_should_have]> > <[keys_awarded]>:
            - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
            - give <role>_key quantity:<[keys_to_give]>
            - flag player <role>.<activity>.keys_awarded:<[keys_should_have]>

        # Check for component milestone
        - if <[count]> >= MILESTONE && !<player.has_flag[<role>.component.<activity>]>:
            - flag player <role>.component.<activity>:true
            - flag player <role>.component.<activity>_date:<util.time_now.format>
```

**Crate Animation:**
```yaml
<role>_crate_animation:
    type: task
    definitions: tier|tier_color|loot
    script:
    # Store for early close
    - flag player <role>.crate.pending_loot:<[loot]>
    - flag player <role>.crate.animation_running:true

    # Open GUI and border
    # ...

    # 3-phase scrolling with early close checks
    - repeat 20:
        - if !<player.has_flag[<role>.crate.animation_running]>:
            - stop
        # ... scroll logic

    # Clear flag BEFORE closing
    - flag player <role>.crate.animation_running:!

    # Close and award
    - inventory close
    - wait 5t
    # ... award loot
```

**Early Close Handler:**
```yaml
<role>_crate_early_close:
    type: world
    events:
        on player closes <role>_crate_gui:
        - if !<player.has_flag[<role>.crate.animation_running]>:
            - stop

        - flag player <role>.crate.animation_running:!
        - define loot <player.flag[<role>.crate.pending_loot]>

        # Award loot
        # ...

        # Clear pending flags
        - flag player <role>.crate.pending_loot:!
```

---

## Testing Workflow

1. **Set role:**
   ```
   /<role>admin setrole <player> <ROLE>
   ```

2. **Test activity tracking:**
   - Perform activities (harvest wheat, breed cows, etc.)
   - Check flags with `/ex player.flag[<role>.<activity>.count]`
   - Verify key awards at intervals

3. **Test components:**
   ```
   /<role>admin givecomponent <player> <component>
   ```

4. **Test ranks:**
   ```
   /<role>admin givekey <player> 200
   /<role>admin setrank <player> DIAMOND
   ```

5. **Test crate opening:**
   - Give key: `/<role>admin givekey <player> 1`
   - Right-click key on any block
   - Test early close (close inventory mid-animation)
   - Verify no duplicate awards

6. **Test cosmetics:**
   - Open `/profile` → Cosmetics
   - Equip/unequip titles
   - Test chat with title active

7. **Reset and retry:**
   ```
   /<role>admin reset <player>
   ```

---

## FAQ

### Can players have multiple roles active?
No, only one role can be active at a time. Switching roles preserves progress.

### What happens if I harvest wheat without FARMING role?
No progress is tracked. Role gate stops event immediately.

### Can I get duplicate titles?
No, titles are tracked with flags. Crate loot checks `<player.has_flag[<role>.item.title]>` before awarding.

### What if I close crate animation early?
Loot is pre-rolled, so closing early awards immediately and stops animation. No duplicate awards.

### How do I switch roles?
Talk to Promachos NPC and select a different role. Progress is preserved.

### Can I reset my progress?
Only OPs can reset progress with admin commands. Normal players cannot reset.

### What are components?
Milestones in activity tracking. Example: harvesting 15,000 wheat awards the Wheat Component. Required for BRONZE rank.

### What are meta-progression crates?
Ultra-rare crates (Ceres, Vulcan, Mars) with finite pools of 4 unique items. 1% drop from OLYMPIAN tier of main crates.
