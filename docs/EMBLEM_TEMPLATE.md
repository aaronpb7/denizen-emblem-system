# New Emblem Implementation Guide

This is the complete reference for adding a new emblem to the system. It mirrors the exact patterns used by the 4 existing emblems (Demeter, Hephaestus, Heracles, Triton).

**How to use this doc:** Answer the design questions in Phase 1, then hand them to Claude along with this file. Claude will create all new files and modify all integration points following the exact patterns below.

---

## Placeholders Used Throughout

| Placeholder | Meaning | Example (Tier 1) | Example (Tier 2) |
|---|---|---|---|
| `{god}` | Greek god, lowercase | `demeter` | `triton` |
| `{God}` | Greek god, capitalized | `Demeter` | `Triton` |
| `{GOD}` | Greek god, uppercase | `DEMETER` | `TRITON` |
| `{meta}` | Roman god, lowercase | `ceres` | `neptune` |
| `{Meta}` | Roman god, capitalized | `Ceres` | `Neptune` |
| `{color}` | Primary color code | `<&6>` | `<&3>` |
| `{light}` | Light accent color | `<&e>` | `<&b>` |

---

## Phase 1: Design Decisions (Answer These First)

### 1.1 Identity

```
Greek God Name:     ___________  (e.g., Apollo)
Roman God Name:     ___________  (e.g., Sol)
Emblem Tier:        [ ] Tier 1 (immediate access)
                    [ ] Tier 2 (requires 2 Tier 1 completions)
                    [ ] Tier 3+ (requires N Tier N-1 completions)
Primary Color:      ___________  (e.g., <&2> dark green)
Light Color:        ___________  (e.g., <&a> green)
Emblem Icon:        ___________  (material for GUI, e.g., bow)
Crate Border:       ___________  (glass pane color, e.g., lime_stained_glass_pane)
Meta Crate Border:  ___________  (can differ, e.g., green_stained_glass_pane)
```

### 1.2 Three Activities

Each emblem has exactly 3 activities. Each activity has:
- A Denizen world event trigger
- A key threshold (every N actions = 1 key)
- A component milestone (total count to unlock component)
- A 5% blessing boost value (= milestone * 0.05)

```
Activity 1:
  Name:          ___________  (e.g., "arrows" — flag: {god}.arrows)
  Event:         ___________  (e.g., "after player shoots bow")
  Key Divisor:   ___________  (e.g., 50 — every 50 = 1 key)
  Milestone:     ___________  (e.g., 5,000 — component unlock)
  Blessing +5%:  ___________  (auto: milestone * 0.05 = 250)

Activity 2:
  Name:          ___________
  Event:         ___________
  Key Divisor:   ___________
  Milestone:     ___________
  Blessing +5%:  ___________

Activity 3:
  Name:          ___________
  Event:         ___________
  Key Divisor:   ___________
  Milestone:     ___________
  Blessing +5%:  ___________
```

**Existing examples for reference:**

| Emblem | Activity 1 | Div | Mile | Activity 2 | Div | Mile | Activity 3 | Div | Mile |
|--------|-----------|-----|------|-----------|-----|------|-----------|-----|------|
| Demeter | wheat (harvest) | 150 | 15,000 | cows (breed) | 20 | 2,000 | cakes (craft) | 5 | 500 |
| Hephaestus | iron (mine) | 50 | 5,000 | smelting (furnace) | 50 | 5,000 | golems (build) | 1 | 100 |
| Heracles | pillagers (kill) | 25 | 2,500 | raids (complete) | 2keys/raid | 50 | emeralds (trade) | 100 | 10,000 |
| Triton | lanterns (NPC turn-in) | 10 | 1,000 | guardians (kill) | 15 | 1,500 | catches (fish treasure) | 1 | 100 |

### 1.3 Crate Loot Pools (5 tiers)

Use existing tier weights (same across all emblems):
- Default: MORTAL 56% / HEROIC 26% / LEGENDARY 12% / MYTHIC 5% / OLYMPIAN 1%
- Emblem unlocked: MORTAL 55% / HEROIC 26% / LEGENDARY 12% / MYTHIC 5% / OLYMPIAN 2%

```
MORTAL pool (6-8 common items, format: material:quantity):
  ___________________________________________

HEROIC pool (4-6 uncommon items, can include experience):
  ___________________________________________

LEGENDARY pool (3-5 rare items, should include {god}_key:2 + experience:250):
  ___________________________________________

MYTHIC pool (always exactly these 4):
  {god}_blessing:1, {god}_mythic_fragment:1, gold_block:16, emerald_block:16

OLYMPIAN (always exactly):
  {meta}_key:1
```

**Preview pool** (items shown during crate scroll animation, 6-8 thematic items):
```
  ___________________________________________
```

### 1.4 Meta Crate — 4 Unique Items

Each meta god has exactly 4 unique items. 50/50 chance: god apple vs random uncollected unique.

```
Unique 1 — Title:
  Title text:    ___________  (e.g., "[Sol's Chosen]")
  Flag:          {meta}.item.title

Unique 2 — Shulker Box:
  Color:         ___________  (e.g., lime_shulker_box)
  Flag:          {meta}.item.shulker

Unique 3 — Blueprint/Craftable:
  Item name:     ___________  (e.g., "Sol Bow")
  Material:      ___________  (e.g., bow)
  Mechanic:      ___________  (what does it do?)
  Blueprint material: map
  Flag:          {meta}.item.{item_name}

Unique 4 — God Head Trophy:
  Script name:   {god}_head
  Skin texture:  ___________  (UUID|base64 from minecraft-heads.com)
  Flag:          {meta}.item.head
```

### 1.5 Tier 2+ Only: NPC Decision

Tier 2+ emblems can use either:
- **Promachos** (shared NPC) — simpler, fewer files
- **Dedicated NPC** (like Triton has its own NPC) — more immersive

```
NPC Choice:     [ ] Promachos (shared)
                [ ] Dedicated NPC named: ___________
```

If dedicated NPC: does any activity require NPC interaction? (Like Triton's sea lantern turn-in)
```
NPC turn-in activity:  [ ] None  [ ] Activity ___: player turns in ___________ items
```

---

## Phase 2: New Files to Create

### Overview — 7 script files + 2 doc files

```
scripts/emblems/{god}/
├── {god}_events.dsc          ← Activity tracking (3 world scripts)
├── {god}_items.dsc           ← Item definitions (key, blessing, fragment, components)
├── {god}_crate.dsc           ← Crate system (GUI, animation, loot tables)
├── {god}_blessing.dsc        ← Blessing consumable handler
├── {meta}_items.dsc          ← Meta unique items (4 items + mechanics)
├── {meta}_crate.dsc          ← Meta crate (50/50 system)
└── {god}_npc.dsc             ← ONLY if Tier 2+ with dedicated NPC

docs/
├── {god}.md                  ← Emblem documentation
└── {meta}.md                 ← Meta-progression documentation
```

---

### File 1: `{god}_events.dsc` — Activity Tracking

One world script per activity. All follow this exact pattern:

```yaml
# ============================================
# {GOD} EVENTS - Activity Tracking
# ============================================
#
# 1. {Activity1 description} → component at {MILESTONE1}
# 2. {Activity2 description} → component at {MILESTONE2}
# 3. {Activity3 description} → component at {MILESTONE3}
#
# Only tracks when player emblem = {GOD}
#

{god}_activity1_handler:
    type: world
    debug: false
    events:
        after player {EVENT_TRIGGER}:
        # Emblem gate
        - if <player.flag[emblem.active].if_null[NONE]> != {GOD}:
            - stop

        # (Optional: additional validation, e.g., age check for crops)

        # Track count
        - flag player {god}.{activity1}.count:++
        - define count <player.flag[{god}.{activity1}.count]>

        # Key award logic (every {DIVISOR})
        - define keys_awarded <player.flag[{god}.{activity1}.keys_awarded].if_null[0]>
        - define keys_should_have <[count].div[{DIVISOR}].round_down>
        - if <[keys_should_have]> > <[keys_awarded]>:
            - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
            - give {god}_key quantity:<[keys_to_give]>
            - flag player {god}.{activity1}.keys_awarded:<[keys_should_have]>
            - narrate "<{color}><&l>{GOD} KEY!<&r> <&7>{Activity1}: <&a><[count]><&7>/{MILESTONE}"
            - playsound <player> sound:entity_experience_orb_pickup

        # Component milestone ({MILESTONE})
        - if <[count]> >= {MILESTONE} && !<player.has_flag[{god}.component.{activity1}]>:
            - flag player {god}.component.{activity1}:true
            - flag player {god}.component.{activity1}_date:<util.time_now.format>
            - narrate "<{color}><&l>MILESTONE!<&r> <{light}>{Activity1} Component obtained! <&7>({MILESTONE} {activity1})"
            - playsound <player> sound:ui_toast_challenge_complete
            - announce "<{color}>[Promachos]<&r> <&f><player.name> <&7>has obtained the <{color}>{Activity1} Component<&7>!"
            - give {god}_mythic_fragment quantity:1
            - narrate "<&d>+1 {God} Mythic Fragment!"
```

Repeat for activity2 and activity3 with their own thresholds.

**Special event patterns from existing code:**

| Pattern | Example | Notes |
|---------|---------|-------|
| Crop harvest | `after player breaks wheat\|carrots\|...` | Check `context.material.age` for fully-grown |
| Animal breed | `after entity breeds:` | Use `context.breeder`, verify `.is_player` |
| Crafting | `after player crafts cake\|...` | Use `context.amount` for shift-click |
| Mob kill | `after player kills guardian` | Direct `<player>` context |
| NPC turn-in | Manual in NPC script | Count items in hand, `take`, then award |
| Furnace output | `after player takes from blast_furnace` | Use `context.item.quantity` |

---

### File 2: `{god}_items.dsc` — Item Definitions

```yaml
# ============================================
# {GOD} ITEMS
# ============================================

# KEY
{god}_key:
    type: item
    material: tripwire_hook
    display name: <{light}>{God} Key<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>A key blessed by
    - <&7>the god of {domain}.
    - <empty>
    - <{light}>Right-click to open a
    - <{light}>{God} Crate.
    - <empty>
    - <&e><&l>HEROIC KEY

# BLESSING (consumable 5% boost)
{god}_blessing:
    type: item
    material: nether_star
    display name: <&d>{God} Blessing<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>A divine blessing from the
    - <&7>god of {domain}, imbued
    - <&7>with divine grace.
    - <empty>
    - <&e>Right-click to boost progress
    - <&e>on all incomplete {God}
    - <&e>activities by 5%.
    - <empty>
    - <&8>Single-use consumable
    - <&8>Stackable & tradeable
    - <empty>
    - <&d><&l>MYTHIC CONSUMABLE

# MYTHIC FRAGMENT (crafting ingredient)
{god}_mythic_fragment:
    type: item
    material: amethyst_shard
    display name: <&d>{God} Mythic Fragment<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>A shard of divine energy
    - <&7>from {God}'s realm.
    - <empty>
    - <&e>Right-click to view recipe.
    - <empty>
    - <&8>Crafting ingredient
    - <&8>Stackable & tradeable
    - <empty>
    - <&d><&l>MYTHIC FRAGMENT
```

---

### File 3: `{god}_crate.dsc` — Crate System

This is the largest file. Copy the structure from `demeter_crate.dsc` exactly. Key scripts:

| Script Name | Type | Purpose |
|---|---|---|
| `{god}_key_usage` | world | Right-click handler: pre-rolls, takes key, runs animation |
| `{god}_crate_animation` | task | 3-phase scroll animation + loot award |
| `{god}_crate_gui` | inventory | 27-slot chest GUI |
| `roll_{god}_tier` | procedure | Weighted tier selection → returns `<list[TIER\|COLOR]>` |
| `roll_{god}_loot` | procedure | Tier-based loot selection → returns MapTag |
| `build_loot_display_item` | procedure | Already exists in demeter_crate.dsc (shared) |
| `get_tier_indicator_pane` | procedure | Already exists in demeter_crate.dsc (shared) |
| `{god}_crate_early_close` | world | Handles player closing GUI mid-animation |

**Crate animation pattern (all emblems identical):**
1. Pre-roll tier + loot BEFORE taking key (safety)
2. Take 1 key from inventory
3. Open GUI, set `{god}.crate.animation_running:true`
4. Store result in flags: `{god}.crate.pending_loot`, `{god}.crate.pending_tier`, `{god}.crate.pending_tier_color`
5. Phase 1: 20 cycles at 2t (fast, pitch 1.5)
6. Phase 2: 10 cycles at 3t (medium, pitch 1.2)
7. Phase 3: 5 cycles at 5t (slow, pitch 0.9)
8. Final landing sequence (3 steps at 5t each)
9. Award loot inline (MapTag doesn't survive `def:` passing)
10. Clear animation flag, close GUI, clear pending flags

**Loot MapTag format:**
```yaml
# For vanilla items:
- define loot_map <map[type=ITEM;material=bread;quantity=8;display=Bread x8]>

# For scripted items:
- define loot_map <map[type=CUSTOM;script={god}_blessing;quantity=1;display={God} Blessing x1]>

# For experience:
- define loot_map <map[type=EXPERIENCE;amount=100;display=+100 Experience]>
```

**OLYMPIAN tier always returns a meta key:**
```yaml
- case OLYMPIAN:
    - define loot_map <map[type=CUSTOM;script={meta}_key;quantity=1;display={Meta} Key x1]>
    - determine <[loot_map]>
```

---

### File 4: `{god}_blessing.dsc` — Blessing Handler

```yaml
{god}_blessing_usage:
    type: world
    debug: false
    events:
        on player right clicks block with:{god}_blessing:
        - determine cancelled passively
        - run {god}_blessing_activate

        on player right clicks air with:{god}_blessing:
        - determine cancelled passively
        - run {god}_blessing_activate

{god}_blessing_activate:
    type: task
    debug: false
    script:
    # Check all complete → convert to 10 keys instead
    - if <player.has_flag[{god}.component.{act1}]> && <player.has_flag[{god}.component.{act2}]> && <player.has_flag[{god}.component.{act3}]>:
        - take item:{god}_blessing quantity:1
        - give {god}_key quantity:10
        - narrate "<&d><&l>{GOD} BLESSING ACTIVATED!<&r>"
        - narrate "  <{color}>All activities complete! <&7>Converted to <{light}>10 {God} Keys<&7>."
        - playsound <player> sound:block_enchantment_table_use
        - playeffect effect:villager_happy at:<player.location> quantity:30 offset:1.0
        - stop

    - define boosted <list>

    # For each incomplete activity: boost by 5%, cap at milestone
    # Activity 1
    - if !<player.has_flag[{god}.component.{act1}]>:
        - define current <player.flag[{god}.{act1}.count].if_null[0]>
        - define boost {BOOST1}
        - define new_count <[current].add[<[boost]>].min[{MILESTONE1}]>
        - define actual <[new_count].sub[<[current]>]>
        - flag player {god}.{act1}.count:<[new_count]>
        - define boosted <[boosted].include[<{color}>{Activity1}<&7>: +<[actual]> (<[current]> → <[new_count]>)]>
        # Check key awards with new count
        - define keys_awarded <player.flag[{god}.{act1}.keys_awarded].if_null[0]>
        - define keys_should_have <[new_count].div[{DIVISOR1}].round_down>
        - if <[keys_should_have]> > <[keys_awarded]>:
            - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
            - give {god}_key quantity:<[keys_to_give]>
            - flag player {god}.{act1}.keys_awarded:<[keys_should_have]>
            - narrate "<{color}><&l>BONUS KEYS!<&r> <&7>+<[keys_to_give]> {God} Keys ({Activity1})"
        # Check milestone with new count
        - if <[new_count]> >= {MILESTONE1}:
            - flag player {god}.component.{act1}:true
            - flag player {god}.component.{act1}_date:<util.time_now.format>
            - narrate "<{color}><&l>MILESTONE!<&r> <{light}>{Activity1} Component obtained! <&7>({MILESTONE1} {act1})"
            - playsound <player> sound:ui_toast_challenge_complete
            - announce "<{color}>[Promachos]<&r> <&f><player.name> <&7>has obtained the <{color}>{Activity1} Component<&7>!"
            - give {god}_mythic_fragment quantity:1
            - narrate "<&d>+1 {God} Mythic Fragment!"

    # Repeat for Activity 2 and 3...

    - take item:{god}_blessing quantity:1
    - narrate "<&d><&l>{GOD} BLESSING ACTIVATED!<&r>"
    - foreach <[boosted]> as:line:
        - narrate "  <[line]>"
    - playsound <player> sound:block_enchantment_table_use
    - playeffect effect:villager_happy at:<player.location> quantity:30 offset:1.0
```

---

### File 5: `{meta}_items.dsc` — Meta Unique Items

4 unique items following the existing pattern:

```yaml
# META KEY
{meta}_key:
    type: item
    material: nether_star
    display name: <{light}>{Meta} Key<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>A key forged in the Roman vault...
    - <empty>
    - <{light}>Right-click to unlock
    - <{light}>a {Meta} Crate.
    - <empty>
    - <&8>50% God Apple / 50% Unique Item
    - <empty>
    - <{light}><&l><&k>|||<&r> <{light}><&l>OLYMPIAN KEY<&r> <{light}><&l><&k>|||

# BLUEPRINT (for Mythic Forge recipe)
{meta}_{item}_blueprint:
    type: item
    material: map
    display name: <{light}>{Meta} {Item} Blueprint<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>Ancient schematics detailing
    - <&7>the construction of {Meta}'s {Item}.
    - <empty>
    - <&e>Right-click to view recipe.
    - <empty>
    - <{light}><&l><&k>|||<&r> <{light}><&l>OLYMPIAN BLUEPRINT<&r> <{light}><&l><&k>|||

# GOD HEAD TROPHY
{god}_head:
    type: item
    material: player_head
    mechanisms:
        skull_skin: {UUID}|{BASE64_TEXTURE}
    display name: <{light}>Head of {God}<&r>
    lore:
    - <&7>A divine effigy of {God},
    - <&7>god of {domain}.
    - <empty>
    - <&e>Right-click to pick up.
    - <empty>
    - <&8>Unique - One per player
    - <empty>
    - <{light}><&l><&k>|||<&r> <{light}><&l>OLYMPIAN TROPHY<&r> <{light}><&l><&k>|||
```

Plus any items with mechanics (tool, wand, etc.) and their world script handlers.

---

### File 6: `{meta}_crate.dsc` — Meta Crate System

Follows the 50/50 system (same as Ceres/Vulcan/Mars/Neptune):

**Key scripts:**

| Script Name | Type | Purpose |
|---|---|---|
| `{meta}_key_usage` | world | Right-click handler |
| `{meta}_crate_animation` | task | Same 3-phase animation as base crate |
| `{meta}_crate_gui` | inventory | 27-slot chest: `<&8>{Meta} {Crate Name} - Opening...` |
| `roll_{meta}_outcome` | procedure | 50/50 roll logic |
| `award_{meta}_loot` | task | Awards god apple or unique item |
| `{meta}_crate_early_close` | world | Early close handler |

**Roll logic (procedure):**
```yaml
roll_{meta}_outcome:
    type: procedure
    debug: false
    script:
    # Build list of uncollected items
    - define available <list>
    - if !<player.has_flag[{meta}.item.title]>:
        - define available <[available].include[title]>
    - if !<player.has_flag[{meta}.item.shulker]>:
        - define available <[available].include[shulker]>
    - if !<player.has_flag[{meta}.item.{craftable}]>:
        - define available <[available].include[{craftable}]>
    - if !<player.has_flag[{meta}.item.head]>:
        - define available <[available].include[head]>

    # All collected → always god apple
    - if <[available].is_empty>:
        - determine <map[type=GOD_APPLE;item=enchanted_golden_apple;display=Enchanted Golden Apple]>

    # 50/50 roll
    - if <util.random.int[1].to[2]> == 1:
        - determine <map[type=GOD_APPLE;item=enchanted_golden_apple;display=Enchanted Golden Apple]>

    # Random uncollected unique
    - define choice <[available].random>
    - choose <[choice]>:
        - case title:
            - determine <map[type=UNIQUE;item_id=title;display={META} TITLE]>
        - case shulker:
            - determine <map[type=UNIQUE;item_id=shulker;display={Color} Shulker Box]>
        # ... etc for each unique
```

**Award logic (task):**
```yaml
# GOD_APPLE path:
- give enchanted_golden_apple
- flag player {meta}.god_apples:++
- sound: entity_player_levelup
- title: "<{light}><&l>{META} DROP" / "Enchanted Golden Apple"

# UNIQUE path:
- choose item_id → give item + set flag ({meta}.item.{id}:true)
- sound: ui_toast_challenge_complete + block_beacon_activate
- title: "<{light}><&l>OLYMPIAN DROP" / "{Item Name}"
- announce server-wide
- flag player {meta}.unique_items:++
- if all 4 collected: announce "COLLECTION COMPLETE!" + dragon growl
```

---

### File 7: `{god}_npc.dsc` — Dedicated NPC (Tier 2+ only, optional)

Only needed if the emblem has a dedicated NPC. Copy pattern from `triton_npc.dsc`:

```yaml
{god}_assignment:
    type: assignment
    debug: false
    actions:
        on assignment:
        - trigger name:click state:true

{god}_interact:
    type: interact
    debug: false
    steps:
        1:
            click trigger:
                script:
                # Tier gating check
                - if !<proc[can_access_tier].context[<player>|{TIER}]>:
                    - run {god}_turn_away
                    - stop
                # First meeting
                - if !<player.has_flag[met_{god}]>:
                    - run {god}_first_meeting
                    - stop
                # Ceremony check
                - if <proc[check_{god}_components_complete]> && !<player.has_flag[{god}.emblem.unlocked]>:
                    - run {god}_emblem_unlock_ceremony
                    - stop
                # NPC turn-in (if applicable)
                - if <player.item_in_hand.material.name> == {TURN_IN_MATERIAL} && <player.flag[emblem.active].if_null[NONE]> == {GOD}:
                    - run {god}_turnin
                    - stop
                # Default: info GUI
                - inventory open d:{god}_info_gui
```

---

## Phase 3: Files to Modify (Integration Points)

### 3.1 `scripts/emblems/core/roles.dsc` — Emblem Data

Add new emblem to 5 data maps:

```yaml
emblem_data:
    emblems:
        - {GOD}                           # ← ADD

    tiers:
        {GOD}: {TIER}                     # ← ADD

    display_names:
        {GOD}: {God}                      # ← ADD

    colors:
        {GOD}: {color}                    # ← ADD

    icons:
        {GOD}: {icon_material}            # ← ADD
```

If adding a new tier (e.g., Tier 3), also add:
```yaml
    tier_requirements:
        3: {N}                            # ← ADD (N completions required from Tier 2)
```

**No procedure changes needed** — all procedures use `.data_key[]` lookups and work automatically.

---

### 3.2 `scripts/emblems/core/promachos.dsc` — NPC & GUI

#### Emblem Selection GUI

Update `get_emblem_selection_items` procedure to add new emblem slot.

**Tier 1 slots (row 2):** 12, 14, 16 (currently filled). A 4th Tier 1 emblem would go at slot 18 (or rearrange to 11, 13, 15, 17 for 4 centered).

**Tier 2 slots (row 4):** Currently slot 31 (Triton). A 2nd Tier 2 emblem at slot 33.

```yaml
# In get_emblem_selection_items:
- define items <[items].set[<proc[get_{god}_emblem_select_item]>].at[{SLOT}]>
```

Create new procedure:
```yaml
get_{god}_emblem_select_item:
    type: procedure
    debug: false
    script:
    # Check if already active
    - if <player.flag[emblem.active].if_null[NONE]> == {GOD}:
        - define lore <list[<{color}><&l>Currently Active|<empty>|<&7>{God}'s emblem description|<empty>|<&e>Click to view details]>
        - determine <item[{icon}].with[display=<{color}><&l>{God}'s Emblem;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    # Standard display
    - define lore <list[<&7>{God}'s emblem description|<empty>|<&e>Click to select]>
    - determine <item[{icon}].with[display=<{color}><&l>{God}'s Emblem;lore=<[lore]>]>
```

#### Emblem Check GUI (45 slots)

Update `get_emblem_check_items`:
```yaml
# For Tier 1 (add at available slot):
- define items <[items].set[<proc[get_{god}_emblem_status_item]>].at[{SLOT}]>

# For Tier 2 (add after Triton):
- define items <[items].set[<proc[get_{god}_emblem_status_item]>].at[33]>

# For Tier 3 (add new label + row):
- define tier3_label <item[{color_pane}].with[display=<{color}><&l>Tier 3;lore=<&7>Requires {N} Tier 2 emblems]>
- define items <[items].set[<[tier3_label]>].at[38]>
- define items <[items].set[<proc[get_{god}_emblem_status_item]>].at[40]>
```

Create emblem status item procedure + component check + ceremony + "ready" item.
Copy the exact pattern from `get_demeter_emblem_status_item` (lines 477-538 of promachos.dsc):

```yaml
get_{god}_emblem_status_item:
    type: procedure
    debug: false
    script:
    # If unlocked
    - if <player.has_flag[{god}.emblem.unlocked]>:
        - define lore <list>
        - define lore <[lore].include[<&7><&o>"Emblem description"]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<{color}><&l>Emblem Attained]>
        # ... (same pattern)
        - determine <item[{icon}].with[display=<{color}><&l>{God}'s Emblem;lore=<[lore]>;enchantments=mending,1;hides=ALL]>

    # If ready (all components)
    - if <proc[check_{god}_components_complete]>:
        - determine <item[{god}_emblem_ready]>

    # In progress
    - define {act1}_complete <player.has_flag[{god}.component.{act1}]>
    # ... count components_done
    - define lore <list>
    - define lore <[lore].include[<&e>Progress<&co> <&7><[components_done]>/3 components]>
    # ...
    - determine <item[{icon}].with[display=<{color}><&l>{God}'s Emblem;lore=<[lore]>]>

check_{god}_components_complete:
    type: procedure
    debug: false
    script:
    - if <player.has_flag[{god}.component.{act1}]> && <player.has_flag[{god}.component.{act2}]> && <player.has_flag[{god}.component.{act3}]>:
        - determine true
    - determine false

{god}_emblem_ready:
    type: item
    material: nether_star
    display name: <{color}><&l>{God}'s Emblem <&a>✓
    lore:
    - <&a><&l>READY TO UNLOCK!
    - <empty>
    - <&7>You have completed all three
    - <&7>sacred trials of <{color}>{God}<&7>.
    - <empty>
    - <&e>Speak to <&6>Promachos<&e> to
    - <&e>receive your emblem!
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
```

#### Emblem Unlock Ceremony

```yaml
{god}_emblem_unlock_ceremony:
    type: task
    debug: false
    script:
    - inventory close
    - playsound <player> sound:ui_toast_challenge_complete volume:1.0
    - narrate "<&e><&l>Promachos<&r><&7>: You have completed the sacred trials of <{color}>{God}<&7>."
    - wait 3s
    - narrate "<&e><&l>Promachos<&r><&7>: Receive the emblem of <{color}>{God}<&7>!"
    - wait 3s
    - flag player {god}.emblem.unlocked:true
    - flag player emblem.rank:+:1
    - flag player {god}.emblem.unlock_date:<util.time_now>
    - give {god}_key quantity:30
    - narrate "<&7>Bonus reward: <{light}>30 {God} Keys"
    - title "title:<{color}><&l>EMBLEM UNLOCKED!" "subtitle:<{light}>{God}'s Blessing" fade_in:10t stay:40t fade_out:10t
    - playeffect effect:totem at:<player.location> quantity:50 offset:1.5
    - announce "<{color}><&l>[Promachos]<&r> <&f><player.name> <&7>has unlocked the <{color}><&l>Emblem of {God}<&7>!"
    - playsound <server.online_players> sound:ui_toast_challenge_complete volume:0.5
```

#### Selection GUI Click Handler

Add the click detection for the new emblem slot:
```yaml
# In the selection GUI click handler:
- else if <context.raw_slot> == {SLOT}:
    - run set_player_emblem def:{GOD}
```

#### Ceremony Detection in Interact Script

Add check BEFORE the default "open emblem check" path:
```yaml
# In promachos interact → click trigger:
- else if <proc[check_{god}_components_complete]> && !<player.has_flag[{god}.emblem.unlocked]>:
    - run {god}_emblem_unlock_ceremony
```

---

### 3.3 `scripts/profile_gui.dsc` — Profile Display

#### Emblem Display Stats (active emblem info)

Add a new case in `get_emblem_display_item` procedure:
```yaml
- case {GOD}:
    - define lore <[lore].include[<&e>Patron<&co> <{color}>{God}<&7>, God of {Domain}]>
    - define lore "<[lore].include[<&sp>]>"
    - define {act1} <player.flag[{god}.{act1}.count].if_null[0]>
    - define {act2} <player.flag[{god}.{act2}.count].if_null[0]>
    - define {act3} <player.flag[{god}.{act3}.count].if_null[0]>
    - define keys <player.flag[{god}.{act1}.keys_awarded].if_null[0].add[<player.flag[{god}.{act2}.keys_awarded].if_null[0]>].add[<player.flag[{god}.{act3}.keys_awarded].if_null[0]>]>
    - define lore <[lore].include[<{color}>Your Progress<&co>]>
    - define lore <[lore].include[<&7>• {Activity1}<&co> <{color}><[{act1}]>.format_number>]>
    - define lore <[lore].include[<&7>• {Activity2}<&co> <{color}><[{act2}]>.format_number>]>
    - define lore <[lore].include[<&7>• {Activity3}<&co> <{color}><[{act3}]>.format_number>]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<{color}>Keys earned<&co> <{color}><[keys]> <&7>{God} Keys]>
```

#### Progress GUI

Create `{god}_progress_gui` inventory + procedural items:

```yaml
{god}_progress_gui:
    type: inventory
    inventory: chest
    gui: true
    debug: false
    title: <&8>{God} - Activity Progress
    size: 27
    procedural items:
    - determine <proc[get_{god}_progress_items]>
```

**Slot layout:** Activities at slots 12, 14, 16. Meta progress at 22. Back button at 19.

#### Emblem Check Click Handler

Add in `profile_click_handler`:
```yaml
# Click emblem item → open progress GUI
after player clicks {icon_material} in emblem_check_gui:
# For Tier 2+: gate check
- if !<proc[can_access_tier].context[<player>|{TIER}]>:
    - narrate "<&c>You haven't unlocked Tier {TIER} emblems yet."
    - playsound <player> sound:entity_villager_no
    - stop
- inventory open d:{god}_progress_gui
```

#### Meta Progress Item

Create `get_{meta}_meta_progress_item` procedure (copy from existing ones in profile_gui.dsc ~line 1036):
```yaml
get_{meta}_meta_progress_item:
    type: procedure
    debug: false
    script:
    - define count 0
    - if <player.has_flag[{meta}.item.title]>:
        - define count <[count].add[1]>
    - if <player.has_flag[{meta}.item.shulker]>:
        - define count <[count].add[1]>
    - if <player.has_flag[{meta}.item.{craftable}]>:
        - define count <[count].add[1]>
    - if <player.has_flag[{meta}.item.head]>:
        - define count <[count].add[1]>
    # ... build lore, return nether_star item
```

#### Cosmetics Menu

Add new title to cosmetics (slot assignment: 11=Ceres, 13=Vulcan, 15=Mars, 17=Neptune — expand to 27→36 slot inventory if needed for more titles).

Update `get_cosmetics_menu_items`:
```yaml
- define items <[items].set[<proc[get_{meta}_title_item]>].at[{SLOT}]>
```

Create title item procedure + update click handler with new slot mapping.

Update `get_cosmetics_icon_item` to count new title:
```yaml
- if <player.has_flag[{meta}.item.title]>:
    - define title_count <[title_count].add[1]>
```

Update active title display and `title_chat_handler` in `ceres_mechanics.dsc`:
```yaml
- case {meta}:
    - define lore "<[lore].include[<{color}><&lb>{Meta}'s Chosen<&rb>]>"
```

---

### 3.4 `scripts/emblems/core/crafting.dsc` — Mythic Forge

Add recipe to `get_recipe_data`:
```yaml
- case {meta}_{item}:
    - determine <map[blueprint={meta}_{item}_blueprint;fragment={god}_mythic_fragment;result={meta}_{item};result_name=<{light}>{Meta}'s {Item};flag={meta}.item.{item};fragment_name=<&d>{God} Mythic Fragment;god_color=<{color}>]>
```

Add right-click handlers (4 events: block + air for fragment + blueprint):
```yaml
on player right clicks block with:{god}_mythic_fragment:
- determine cancelled passively
- run open_recipe_gui def.recipe_id:{meta}_{item}

on player right clicks air with:{god}_mythic_fragment:
- determine cancelled passively
- run open_recipe_gui def.recipe_id:{meta}_{item}

on player right clicks block with:{meta}_{item}_blueprint:
- determine cancelled passively
- run open_recipe_gui def.recipe_id:{meta}_{item}

on player right clicks air with:{meta}_{item}_blueprint:
- determine cancelled passively
- run open_recipe_gui def.recipe_id:{meta}_{item}
```

---

### 3.5 `scripts/emblems/core/item_utilities.dsc` — God Head Placement

Add new head to the placement event:
```yaml
after player places demeter_head|heracles_head|hephaestus_head|{god}_head:
```

---

### 3.6 `scripts/emblems/admin/admin_commands.dsc` — Admin Commands

Create 2 new commands following existing patterns:

**`/{god}admin` command:**
- `/{god}admin <player> set {act1} <count>` — Set activity count
- `/{god}admin <player> set {act2} <count>`
- `/{god}admin <player> set {act3} <count>`
- `/{god}admin <player> keys <amount>` — Give keys
- `/{god}admin <player> component {name} <true/false>` — Set component
- `/{god}admin <player> emblem <true/false>` — Set emblem unlock
- `/{god}admin <player> reset` — Clear all flags

**`/{meta}admin` command:**
- `/{meta}admin <player> item {name} <true/false>` — Set unique item flag
- `/{meta}admin <player> keys <amount>` — Give meta keys
- `/{meta}admin <player> reset` — Clear all meta flags

**Update existing commands:**
- `checkkeys` — Add new emblem's key counts
- `emblemreset` — Add new emblem + meta flags to clear

---

### 3.7 `scripts/server_events.dsc` — No changes needed

The join handler only checks `emblem.active` and `met_promachos` — no emblem-specific code.

---

### 3.8 `CLAUDE.md` — Project Documentation

Update:
- Script structure tree
- Admin commands list
- Emblem count ("5 emblems" etc.)

---

## Phase 4: Flag Reference

### Emblem Flags

```
{god}.{act1}.count                    (int)
{god}.{act1}.keys_awarded             (int)
{god}.{act2}.count                    (int)
{god}.{act2}.keys_awarded             (int)
{god}.{act3}.count                    (int)
{god}.{act3}.keys_awarded             (int)

{god}.component.{act1}               (bool)
{god}.component.{act1}_date           (string timestamp)
{god}.component.{act2}               (bool)
{god}.component.{act2}_date           (string timestamp)
{god}.component.{act3}               (bool)
{god}.component.{act3}_date           (string timestamp)

{god}.emblem.unlocked                 (bool)
{god}.emblem.unlock_date              (timestamp)

{god}.crates_opened                   (int, optional)
{god}.tier.mortal                     (int, optional)
{god}.tier.heroic                     (int, optional)
{god}.tier.legendary                  (int, optional)
{god}.tier.mythic                     (int, optional)
{god}.tier.olympian                   (int, optional)

{god}.crate.animation_running         (bool, temporary)
{god}.crate.pending_loot              (map, temporary)
{god}.crate.pending_tier              (string, temporary)
{god}.crate.pending_tier_color        (string, temporary)
```

### Meta Flags

```
{meta}.item.title                     (bool)
{meta}.item.shulker                   (bool)
{meta}.item.{craftable}               (bool)
{meta}.item.head                      (bool)

{meta}.crates_opened                  (int, optional)
{meta}.god_apples                     (int, optional)
{meta}.unique_items                   (int, optional)

{meta}.crate.animation_running        (bool, temporary)
{meta}.crate.pending_result           (map, temporary)
```

---

## Phase 5: Testing Checklist

### Activity Tracking
- [ ] Each activity increments only when `emblem.active == {GOD}`
- [ ] Switching emblems stops tracking
- [ ] Counts persist across sessions

### Key Awards
- [ ] Keys award at correct intervals
- [ ] Shift-click crafting awards correct delta
- [ ] No double-awarding on rejoin
- [ ] Keys appear in inventory with correct display

### Components
- [ ] Each component awards at milestone (one-time)
- [ ] Mythic fragment given on each milestone
- [ ] Server announcement fires
- [ ] Date timestamp stored

### Blessing
- [ ] 5% boost applies to incomplete activities
- [ ] Capped at milestone (doesn't exceed)
- [ ] All-complete converts to 10 keys
- [ ] Key awards checked after boost
- [ ] Milestone check after boost

### Crate System
- [ ] Key consumed on use
- [ ] GUI opens, animation plays
- [ ] All 5 tiers roll correctly
- [ ] Loot appropriate per tier
- [ ] OLYMPIAN gives meta key
- [ ] Emblem unlock boosts OLYMPIAN from 1% → 2%
- [ ] Early GUI close awards loot
- [ ] Pending flags cleared after award

### Meta Crate
- [ ] 50/50 split works
- [ ] Unique items don't repeat (flags set)
- [ ] All 4 collected → always god apple
- [ ] Collection complete announcement

### Emblem Unlock
- [ ] All 3 components → ready state in GUI
- [ ] Promachos/NPC detects and runs ceremony
- [ ] Ceremony sets unlocked flag + increments rank
- [ ] 30 bonus keys awarded
- [ ] Server announcement + effects

### GUI Integration
- [ ] Selection GUI shows new emblem at correct slot
- [ ] Tier gating works (Tier 2+)
- [ ] Emblem check GUI shows component progress
- [ ] Profile shows stats for active emblem
- [ ] Progress GUI shows all 3 activities + meta
- [ ] Cosmetics shows new title
- [ ] Title equip/unequip works
- [ ] Title shows in chat

### Mythic Forge
- [ ] Blueprint right-click opens recipe GUI
- [ ] Fragment right-click opens recipe GUI
- [ ] Crafting consumes 1 blueprint + 4 fragments + 4 diamond blocks
- [ ] Result item given + flag set

### Admin Commands
- [ ] `/{god}admin` set/reset/keys all work
- [ ] `/{meta}admin` item/keys/reset all work
- [ ] `checkkeys` shows new emblem
- [ ] `emblemreset` clears new emblem flags

---

## Quick Reference: File Counts

| Category | New Files | Modified Files |
|----------|-----------|----------------|
| **Emblem scripts** | 4 (`events`, `items`, `crate`, `blessing`) | — |
| **Meta scripts** | 2 (`items`, `crate`) | — |
| **NPC script** | 0-1 (Tier 2+ dedicated NPC only) | — |
| **Core scripts** | — | `roles.dsc`, `promachos.dsc`, `crafting.dsc`, `item_utilities.dsc` |
| **Profile** | — | `profile_gui.dsc` |
| **Admin** | — | `admin_commands.dsc` |
| **Docs** | 2 (`{god}.md`, `{meta}.md`) | `flags.md`, `CLAUDE.md` |
| **Total** | 6-7 new | 7-8 modified |
