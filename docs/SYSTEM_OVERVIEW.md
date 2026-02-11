# Promachos - Emblem-Based Progression System

## Overview

The Promachos system is an emblem-based progression framework where players choose one of three paths (DEMETER, HEPHAESTUS, HERACLES) and progress through activities to earn keys, unlock crate rewards, and obtain cosmetic titles.

**System Architecture:**
- **4 Emblems**: DEMETER (Demeter), HEPHAESTUS (Hephaestus), HERACLES (Heracles), TRITON (Triton)
- **Activity Tracking**: Players earn keys by completing emblem-specific activities
- **Component Milestones**: One-time achievements at high activity counts (unlock emblems)
- **Emblem Rank**: Global rank that increments each time an emblem is unlocked
- **Tier System**: Tier 1 emblems available immediately; Tier 2 requires 2 Tier 1 completions
- **Crate System**: Keys unlock tiered crates with rewards (5 tiers per crate)
- **Meta-Progression**: Ultra-rare Roman god crates (Ceres, Vulcan, Mars, Neptune) with finite unique items
- **Cosmetics**: Unlockable chat title prefixes from crates

---

## Project Structure

```
scripts/
├── profile_gui.dsc                 # Main /profile command and UI
├── bulletin.dsc                    # Server announcements system
├── server_events.dsc               # Join handlers, daily restart
├── server_restrictions.dsc         # Server rules/restrictions
└── emblems/
    ├── core/
    │   ├── roles.dsc              # Emblem data and procedures
    │   ├── promachos.dsc          # NPC interactions and emblem selection
    │   ├── item_utilities.dsc     # Shared item procedures
    │   └── crafting.dsc           # Mythic crafting system
    ├── admin/
    │   ├── admin_commands.dsc     # Admin testing commands
    │   └── migration.dsc         # Migration from role.active to emblem.active
    ├── demeter/                   # DEMETER emblem + Ceres meta
    │   ├── demeter_events.dsc     # Activity tracking (wheat, cows, cakes)
    │   ├── demeter_crate.dsc      # Demeter crate opening system
    │   ├── demeter_blessing.dsc   # Demeter Blessing consumable
    │   ├── demeter_items.dsc      # Custom items (key, hoe, blessing, fragment)
    │   ├── ceres_crate.dsc        # Ceres vault (meta-progression)
    │   ├── ceres_mechanics.dsc    # Chat title handler
    │   └── ceres_items.dsc        # Unique items (hoe, wand, blueprint, head)
    ├── heracles/                  # HERACLES emblem + Mars meta
    │   ├── heracles_events.dsc    # Activity tracking (pillagers, raids, emeralds)
    │   ├── heracles_crate.dsc     # Heracles crate opening system
    │   ├── heracles_blessing.dsc  # Heracles Blessing consumable
    │   ├── heracles_items.dsc     # Custom items (key, sword, blessing, fragment)
    │   ├── mars_crate.dsc         # Mars arena (meta-progression)
    │   └── mars_items.dsc         # Unique items (sword, shield, blueprint, head)
    ├── hephaestus/                # HEPHAESTUS emblem + Vulcan meta
    │   ├── hephaestus_events.dsc  # Activity tracking (iron, smelting, golems)
    │   ├── hephaestus_crate.dsc   # Hephaestus crate opening system
    │   ├── hephaestus_blessing.dsc # Hephaestus Blessing consumable
    │   ├── hephaestus_items.dsc   # Custom items (key, pickaxe, blessing, fragment)
    │   ├── vulcan_crate.dsc       # Vulcan vault (meta-progression)
    │   └── vulcan_items.dsc       # Unique items (pickaxe, blueprint, head)
    └── triton/                    # TRITON emblem (Tier 2) + Neptune meta
        ├── triton_npc.dsc         # Triton NPC (turn-ins, ceremony, info GUI)
        ├── triton_events.dsc      # Activity tracking (guardians, conduits)
        ├── triton_crate.dsc       # Triton crate opening system
        ├── triton_blessing.dsc    # Triton Blessing consumable
        ├── triton_items.dsc       # Custom items (key, blessing, fragment, components)
        ├── neptune_crate.dsc      # Neptune depths (meta-progression)
        └── neptune_items.dsc      # Unique items (trident, blueprint, head)
```

---

## Emblem System

### Emblem Selection

Players interact with **Promachos NPC** (requires `met_promachos` flag) to choose their path:

| Emblem ID | Display Name | God | Activities |
|-----------|--------------|-----|------------|
| DEMETER | Demeter | Demeter, Goddess of Harvest | Wheat harvesting, cow breeding, cake crafting |
| HEPHAESTUS | Hephaestus | Hephaestus, God of the Forge | Mining ores, smelting, golem creation |
| HERACLES | Heracles | Heracles, Hero of Strength | Pillager slaying, raid defense, emerald trading |
| TRITON | Triton | Triton, God of the Sea | Sea lantern turn-ins, guardian kills, conduit crafting |

**Key Mechanics:**
- Players can switch emblems at any time
- Progress is preserved across emblem changes
- Only activities performed with active emblem count toward progression
- Flag: `emblem.active` (value: "DEMETER", "HEPHAESTUS", or "HERACLES")

### Emblem Colors

```yaml
DEMETER:     <&6>  (Gold)
HEPHAESTUS:  <&c>  (Red)
HERACLES:    <&4>  (Dark Red)
TRITON:      <&3>  (Dark Aqua)
```

### Tier System

Emblems are organized into two tiers:

| Tier | Requirement | Emblems |
|------|-------------|---------|
| **Tier 1** | Available immediately | DEMETER, HEPHAESTUS, HERACLES |
| **Tier 2** | Complete 2 Tier 1 emblems | TRITON |

Completing an emblem (all components collected) increments the player's `emblem.rank` flag.

---

## Progression System

### Activity Tracking (Example: Demeter)

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

### Player Progression

A global `emblem.rank` integer that increments each time a player completes an emblem. Each rank has a Greek-themed title, unique color, and corresponding material in the profile GUI.

**Rank Ladder:**

| Rank | Title | Meaning | Emblems Required | Color | Material |
|------|-------|---------|-----------------|-------|----------|
| 0 | Uninitiated | Not yet begun | 0 | Gray | Clay Ball |
| 1 | Neophyte | Newly initiated | 1 | White | Iron Nugget |
| 2 | Mystes | Initiate of the mysteries | 2 | Yellow | Gold Nugget |
| 3 | Epoptes | Beholder of the mysteries | 3 | Gold | Gold Ingot |
| 4 | Aristos | The excellent | 4 | Aqua | Diamond |
| 5 | Heros | Hero | 5 | Pink | Emerald |
| 6 | Hemitheos | Demigod | 6 | Purple | Nether Star |

**Key Features:**
- `emblem.rank` starts at 0 and increments by 1 per emblem completion
- Reaching rank 2 (2 Tier 1 completions) unlocks Tier 2 emblems
- Rank data is stored in `player_rank_data` script in `profile_gui.dsc`
- Profile GUI shows current rank with flavor text, next rank goal, and full rank ladder
- Item material and enchant glow change per rank for visual progression
- Flag: `emblem.rank` (integer)
- Migration flag: `emblem.migrated` (boolean, set after migration from old system)

---

## Crate System

### Tier Structure (Standard Crates)

| Tier | Probability | Color | Rewards |
|------|------------|-------|---------|
| MORTAL | 56% (55%*) | <&f>White | Basic resources, low-tier items |
| HEROIC | 26% | <&9>Blue | Mid-tier items, enchanted gear |
| LEGENDARY | 12% | <&5>Purple | High-tier items, rare materials |
| MYTHIC | 5% | <&d>Pink | Unique items, titles |
| OLYMPIAN | 1% (2%*) | <&b>Cyan | Meta-progression keys (Ceres/Vulcan/Mars) |

*Players with the corresponding emblem unlocked get 2% OLYMPIAN (taken from MORTAL).

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
- `demeter_blessing` (consumable +5% progress boost)
- `demeter_mythic_fragment` (crafting ingredient for Ceres Wand)
- Enchanted Golden Apple
- Gold/Emerald Blocks (x16)

**OLYMPIAN Loot:**
- 1% chance: `ceres_key` (meta-progression)

### Meta-Progression (Ceres Crate)

**Key:** `ceres_key` (nether_star)
**Source:** 1% drop from Demeter OLYMPIAN tier

**Unique Items Pool (Finite):**
1. `ceres_title` - "Ceres' Chosen" chat prefix (flag unlock)
2. Yellow Shulker Box
3. `ceres_wand_blueprint` - Blueprint for Ceres Wand (requires crafting)
4. `demeter_head` - Head of Demeter trophy

**Mechanics:**
- 50% chance: Enchanted Golden Apple
- 50% chance: Unique item from pool (if not all obtained)
- Once all 4 items obtained → always god apple
- Tracks obtained items with flags: `ceres.item.title`, `ceres.item.shulker`, etc.
- Collection completion triggers server announcement

---

## Cosmetics System

### Title System

Players can equip one chat title prefix at a time via `/profile` → Cosmetics menu.

**Available Titles:**

| Title | Flag | Display | Unlock Source | Color |
|-------|------|---------|---------------|-------|
| Ceres' Chosen | `ceres.item.title` | [Ceres' Chosen] | Ceres Crate | <&6>Gold |
| Vulcan's Chosen | `vulcan.item.title` | [Vulcan's Chosen] | Vulcan Crate | <&8>Dark Gray |
| Mars' Chosen | `mars.item.title` | [Mars' Chosen] | Mars Crate | <&4>Dark Red |
| Neptune's Chosen | `neptune.item.title` | [Neptune's Chosen] | Neptune Crate | <&3>Dark Aqua |

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
| `demeter_hoe` | diamond_hoe | MYTHIC cosmetic tool |
| `demeter_blessing` | nether_star | +5% progress boost (10 keys if maxed) |
| `demeter_mythic_fragment` | amethyst_shard | Crafting ingredient for Ceres Wand |

### Ceres Items

| Script Name | Material | Purpose |
|-------------|----------|---------|
| `ceres_key` | nether_star | Opens Ceres Grove (meta) |
| `ceres_wand` | blaze_rod | Bee summoner staff (via Mythic Crafting) |
| `ceres_wand_blueprint` | map | Blueprint for Ceres Wand (from crate) |
| `demeter_head` | player_head | Head of Demeter trophy |

### Hephaestus Items

| Script Name | Material | Purpose |
|-------------|----------|---------|
| `hephaestus_key` | tripwire_hook | Opens Hephaestus Crate |
| `hephaestus_pickaxe` | diamond_pickaxe | MYTHIC cosmetic pickaxe |
| `hephaestus_blessing` | nether_star | +5% progress boost (10 keys if maxed) |
| `hephaestus_mythic_fragment` | amethyst_shard | Crafting ingredient for Vulcan Pickaxe |

### Heracles Items

| Script Name | Material | Purpose |
|-------------|----------|---------|
| `heracles_key` | tripwire_hook | Opens Heracles Crate (5 tiers) |
| `heracles_sword` | diamond_sword | Unbreakable cosmetic sword (MYTHIC) |
| `heracles_blessing` | nether_star | +5% progress boost (10 keys if maxed) |
| `heracles_mythic_fragment` | amethyst_shard | Crafting ingredient for Mars Shield |

### Mars Items

| Script Name | Material | Purpose |
|-------------|----------|---------|
| `mars_key` | nether_star | Opens Mars Crate (50/50 system) |
| `mars_shield` | shield | Active resistance buff, 3min cooldown (via Mythic Crafting) |
| `mars_shield_blueprint` | map | Blueprint for Mars Shield (from crate) |
| `heracles_head` | player_head | Head of Heracles trophy |

### Vulcan Items

| Script Name | Material | Purpose |
|-------------|----------|---------|
| `vulcan_key` | nether_star | Opens Vulcan Crate (50/50 system) |
| `vulcan_pickaxe` | netherite_pickaxe | Auto-smelt pickaxe |
| `vulcan_pickaxe_blueprint` | map | Blueprint for Vulcan Pickaxe (from crate) |
| `hephaestus_head` | player_head | Head of Hephaestus trophy |

### Triton Items

| Script Name | Material | Purpose |
|-------------|----------|---------|
| `triton_key` | tripwire_hook | Opens Triton Crate (5 tiers) |
| `triton_blessing` | nether_star | +5% progress boost (10 keys if maxed) |
| `triton_mythic_fragment` | prismarine_shard | Crafting ingredient for Neptune's Trident |
| `lantern_component` | sea_lantern | Milestone component (1,000 lanterns) |
| `guardian_component` | prismarine_crystals | Milestone component (1,500 guardian kills) |
| `conduit_component` | conduit | Milestone component (25 conduits) |

### Neptune Items

| Script Name | Material | Purpose |
|-------------|----------|---------|
| `neptune_key` | nether_star | Opens Neptune Crate (50/50 system) |
| `neptune_trident` | trident | Mythic trident with Riptide/Loyalty/Channeling (via Mythic Crafting) |
| `neptune_trident_blueprint` | map | Blueprint for Neptune's Trident (from crate) |
| `triton_head` | player_head | Head of Triton trophy |
| *(raw item)* | cyan_shulker_box | Cyan Shulker Box |

### Mythic Crafting System

Players combine Blueprints (from meta crates) + Mythic Fragments (from base crate MYTHIC tier) + Diamond Blocks to forge Olympian items.

| Recipe | Blueprint | Fragment (x4) | Result |
|--------|-----------|---------------|--------|
| Ceres Wand | `ceres_wand_blueprint` | `demeter_mythic_fragment` | `ceres_wand` |
| Mars Shield | `mars_shield_blueprint` | `heracles_mythic_fragment` | `mars_shield` |
| Vulcan Pickaxe | `vulcan_pickaxe_blueprint` | `hephaestus_mythic_fragment` | `vulcan_pickaxe` |
| Neptune's Trident | `neptune_trident_blueprint` | `triton_mythic_fragment` | `neptune_trident` |

All recipes also require **4x Diamond Block**. Right-click any fragment or blueprint to view the recipe GUI.

---

## Admin Commands

### Emblem Management
```
/emblemadmin <player> <DEMETER|HEPHAESTUS|HERACLES|TRITON>
```

### Progress Management
```
/demeteradmin <player> <keys|set|component|reset>
/heraclesadmin <player> <keys|set|component|raid|reset>
/hephaestusadmin <player> <keys|set|component|reset>
```

### Triton Progress Management
```
/tritonadmin <player> <keys|set|component|reset>
```

### Meta-Progression Management
```
/ceresadmin <player> <keys|item|reset>        # items: title, shulker, wand, head
/marsadmin <player> <keys|item|reset>          # items: title, shulker, shield, head
/vulcanadmin <player> <keys|item|reset>        # items: pickaxe, title, shulker, head
/neptuneadmin <player> <keys|give|item|reset>  # items: title, shulker, trident, head
```

### Utility Commands
```
/rankadmin <player> [set <number>]
/checkkeys [player]
/testroll <demeter|ceres|heracles|mars|hephaestus|vulcan|triton|neptune>
/emblemreset <player> [confirm]
/invsee <player>                                # View/edit inventory (works offline)
/endersee <player>                              # View/edit ender chest (works offline)
```

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
emblem.active              # String: "DEMETER", "HEPHAESTUS", "HERACLES", "TRITON"
emblem.rank                # Integer: Increments per emblem unlock (0+)
emblem.migrated            # Boolean: Migrated from old role.active system
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
ceres.god_apples           # Total god apples received

# Unique Items (Finite Pool)
ceres.item.head
ceres.item.title
ceres.item.shulker
ceres.item.wand

# Meta Stats
ceres.unique_items         # Count of unique items obtained
```

### Triton Flags
```
# Activity Progress
triton.lanterns.count
triton.lanterns.keys_awarded
triton.component.lanterns

triton.guardians.count
triton.guardians.keys_awarded
triton.component.guardians

triton.conduits.count
triton.conduits.keys_awarded
triton.component.conduits

# Emblem Unlock
triton.emblem.unlocked
triton.emblem.unlock_date

# Crate System
triton.crates_opened
triton.tier.mortal
triton.tier.heroic
triton.tier.legendary
triton.tier.mythic
triton.tier.olympian
```

### Neptune Flags
```
# Unique Items (Finite Pool)
neptune.item.head
neptune.item.title
neptune.item.shulker
neptune.item.trident

# Meta Stats
neptune.crates_opened
neptune.god_apples
neptune.unique_items
```

### Cosmetics Flags
```
cosmetic.title.active      # String: "ceres", "vulcan", "mars", "neptune" (or not set)
```

### Crafting Flags
```
crafting.viewing_recipe    # Temporary, cleared on close
```

### Bulletin Flags
```
bulletin.seen_version      # Integer: Last bulletin version viewed
```

---

## Implementation Status

### ✅ Completed Systems

- ✅ Core emblem selection and switching
- ✅ Emblem rank system (increments per emblem unlock)
- ✅ Tier system (Tier 1 immediate, Tier 2 requires 2 completions)
- ✅ Migration from old role.active system
- ✅ Demeter activity tracking (wheat, cows, cakes)
- ✅ Demeter crate system (5 tiers, scrolling animation)
- ✅ Demeter Blessing consumable (+5% progress boost)
- ✅ Ceres meta-progression crate (50/50 system, 4 unique items)
- ✅ Ceres custom items (hoe auto-replant, wand bee summon, blueprint crafting)
- ✅ Hephaestus activity tracking (iron ore, blast furnace, iron golems)
- ✅ Hephaestus crate system (5 tiers, forge theme)
- ✅ Hephaestus Blessing consumable (+5% progress boost)
- ✅ Vulcan meta-progression crate (50/50 system, 4 unique items)
- ✅ Vulcan custom items (pickaxe auto-smelt)
- ✅ Heracles activity tracking (pillagers, raids, emerald trading)
- ✅ Heracles crate system (5 tiers, combat theme)
- ✅ Heracles Blessing consumable (+5% progress boost)
- ✅ Mars meta-progression crate (50/50 system, 4 unique items)
- ✅ Mars custom items (sword lifesteal, shield resistance buff)
- ✅ Mythic crafting system (blueprints + fragments → Olympian items)
- ✅ Cosmetics system (title equipping/unequipping)
- ✅ Chat title prefixes (Ceres, Vulcan, Mars)
- ✅ Profile GUI with emblem display
- ✅ Promachos NPC with emblem unlock ceremonies
- ✅ Bulletin system
- ✅ Admin commands for testing
- ✅ Early close handling for crates (no duplicate awards)

- ✅ Triton activity tracking (sea lanterns, guardian kills, conduit crafting)
- ✅ Triton crate system (5 tiers, ocean theme)
- ✅ Triton Blessing consumable (+5% progress boost)
- ✅ Triton NPC (dedicated NPC for turn-ins, ceremony, info)
- ✅ Neptune meta-progression crate (50/50 system, 4 unique items)
- ✅ Neptune's Trident (mythic trident via Mythic Crafting)
- ✅ Tier 2 gating (requires 2 Tier 1 completions)
- ✅ Selection GUI expansion (45 slots, tier labels)

### 🔜 Future Enhancements

- Additional cosmetics (particles, sounds, etc.)
- Leaderboards per emblem
- Seasonal challenges
- Cross-emblem rewards
- Guild/team progression

---

## Adding New Emblems

### Checklist

1. **Create folder structure:**
   - `scripts/emblems/<emblem_name>/`
   - `scripts/emblems/<roman_name>/` (meta-progression)

2. **Update `roles.dsc`:**
   - Add emblem to `emblems` list
   - Add tier assignment to `tiers`
   - Add display name to `display_names`
   - Add color to `colors`
   - Add icon material to `icons`

3. **Create activity tracking:**
   - `<emblem_name>_events.dsc` with event handlers
   - Track activities with flags: `<emblem>.activity.count`
   - Award keys at intervals
   - Award components at milestones

4. **Create crate system:**
   - `<emblem_name>_crate.dsc` with 5 tiers
   - Tier rolling procedure
   - Loot rolling procedure
   - Scrolling animation (copy from demeter_crate.dsc)
   - Early close handler

5. **Create meta-progression:**
   - `<roman_name>_crate.dsc` with finite pool (4 unique items)
   - 50/50 split between reward and unique item
   - Track obtained items with flags

6. **Create custom items:**
   - Key item (tripwire_hook)
   - Meta key (nether_star)
   - Title items (name_tag)
   - Unique rewards

7. **Update cosmetics system:**
   - Add title to `profile_gui.dsc` cosmetics menu
   - Add case to `title_chat_handler` in `ceres_mechanics.dsc`

8. **Create admin commands:**
   - Progress setters/adders
   - Component management
   - Key giving
   - Reset command

9. **Update profile GUI:**
    - Add emblem icon to emblem selection
    - Add progress display for emblem

---

## Development Guidelines

### Naming Conventions

- **Flags:** `<emblem>.category.subcategory` (e.g., `demeter.wheat.count`)
- **Scripts:** `<emblem>_purpose` (e.g., `demeter_events`)
- **Items:** `<emblem>_item_name` (e.g., `demeter_key`)
- **Procedures:** `<emblem>_action_noun` (e.g., `demeter_roll_tier`)
- **Tasks:** `<emblem>_action` (e.g., `demeter_crate_animation`)

### File Organization

- **Events:** Activity tracking, key awarding
- **Crate:** Opening animation, loot rolling, reward awarding
- **Items:** Item definitions only (no mechanics)
- **Mechanics:** Item abilities, special interactions

### Code Patterns

**Activity Tracking:**
```yaml
<emblem>_<activity>_tracking:
    type: world
    events:
        on <event>:
        # Emblem gate
        - if <player.flag[emblem.active]> != <EMBLEM>:
            - stop

        # Increment counter
        - flag player <emblem>.<activity>.count:++
        - define count <player.flag[<emblem>.<activity>.count]>

        # Check for key award
        - define keys_awarded <player.flag[<emblem>.<activity>.keys_awarded].if_null[0]>
        - define keys_should_have <[count].div[INTERVAL].round_down>
        - if <[keys_should_have]> > <[keys_awarded]>:
            - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
            - give <emblem>_key quantity:<[keys_to_give]>
            - flag player <emblem>.<activity>.keys_awarded:<[keys_should_have]>

        # Check for component milestone
        - if <[count]> >= MILESTONE && !<player.has_flag[<emblem>.component.<activity>]>:
            - flag player <emblem>.component.<activity>:true
            - flag player <emblem>.component.<activity>_date:<util.time_now.format>
```

**Crate Animation:**
```yaml
<emblem>_crate_animation:
    type: task
    definitions: tier|tier_color|loot
    script:
    # Store for early close
    - flag player <emblem>.crate.pending_loot:<[loot]>
    - flag player <emblem>.crate.animation_running:true

    # Open GUI and border
    # ...

    # 3-phase scrolling with early close checks
    - repeat 20:
        - if !<player.has_flag[<emblem>.crate.animation_running]>:
            - stop
        # ... scroll logic

    # Clear flag BEFORE closing
    - flag player <emblem>.crate.animation_running:!

    # Close and award
    - inventory close
    - wait 5t
    # ... award loot
```

**Early Close Handler:**
```yaml
<emblem>_crate_early_close:
    type: world
    events:
        on player closes <emblem>_crate_gui:
        - if !<player.has_flag[<emblem>.crate.animation_running]>:
            - stop

        - flag player <emblem>.crate.animation_running:!
        - define loot <player.flag[<emblem>.crate.pending_loot]>

        # Award loot
        # ...

        # Clear pending flags
        - flag player <emblem>.crate.pending_loot:!
```

---

## Testing Workflow

1. **Set emblem:**
   ```
   /emblemadmin set <player> <EMBLEM>
   ```

2. **Test activity tracking:**
   - Perform activities (harvest wheat, breed cows, etc.)
   - Check flags with `/ex player.flag[<emblem>.<activity>.count]`
   - Verify key awards at intervals

3. **Test components:**
   ```
   /<emblem>admin givecomponent <player> <component>
   ```

4. **Test crate opening:**
   - Give key: `/<emblem>admin givekey <player> 1`
   - Right-click key on any block
   - Test early close (close inventory mid-animation)
   - Verify no duplicate awards

5. **Test cosmetics:**
   - Open `/profile` → Cosmetics
   - Equip/unequip titles
   - Test chat with title active

6. **Reset and retry:**
   ```
   /<emblem>admin reset <player>
   ```

---

## FAQ

### Can players have multiple emblems active?
No, only one emblem can be active at a time. Switching emblems preserves progress.

### What happens if I harvest wheat without DEMETER emblem?
No progress is tracked. Emblem gate stops event immediately.

### Can I get duplicate titles?
No, titles are tracked with flags. Crate loot checks `<player.has_flag[<emblem>.item.title]>` before awarding.

### What if I close crate animation early?
Loot is pre-rolled, so closing early awards immediately and stops animation. No duplicate awards.

### How do I switch emblems?
Talk to Promachos NPC and select a different emblem. Progress is preserved.

### Can I reset my progress?
Only OPs can reset progress with admin commands. Normal players cannot reset.

### What are components?
Milestones in activity tracking. Example: harvesting 15,000 wheat awards the Wheat Component. Collecting all components completes the emblem and increments `emblem.rank`.

### What are meta-progression crates?
Ultra-rare crates (Ceres, Vulcan, Mars) with finite pools of 4 unique items. 1% drop from OLYMPIAN tier of main crates (2% with emblem unlocked).
