# Divine Armor Sets — Implementation Plan

## Context

Currently, completing an emblem gives a passive 2% OLYMPIAN tier bonus (up from 1%) for that emblem's crates. This is boring and barely noticeable. Replace it with a **divine armor set** system: 5 diamond armor sets (one per emblem), earned via NPC quest + Mythic Forge crafting. Wearing the full set provides generous meta-progression bonuses.

**Bonuses (full set required):**
- **Pity timer**: Every 50 of that emblem's crates opened → guaranteed OLYMPIAN (meta key)
- **Meta crate boost**: 75/25 unique/apple split (instead of 50/50) when opening the corresponding meta crate
- **2% OLYMPIAN bonus removed entirely**

---

## Phase 1: Core Infrastructure

### 1A. `is_wearing_divine_armor` procedure → `roles.dsc`

New procedure at bottom of `scripts/emblems/core/roles.dsc`:

```yaml
is_wearing_divine_armor:
    type: procedure
    debug: false
    definitions: player|god
    script:
    - if <[player].equipment.helmet.script.name.if_null[null]> != <[god]>_divine_helm:
        - determine false
    - if <[player].equipment.chestplate.script.name.if_null[null]> != <[god]>_divine_chestplate:
        - determine false
    - if <[player].equipment.leggings.script.name.if_null[null]> != <[god]>_divine_leggings:
        - determine false
    - if <[player].equipment.boots.script.name.if_null[null]> != <[god]>_divine_boots:
        - determine false
    - determine true
```

Usage: `<proc[is_wearing_divine_armor].context[<player>|demeter]>`

### 1B. Add 5 armor recipes → `crafting.dsc` `get_recipe_data`

New recipe type: 1 schematic (center) + 4 diamond armor pieces (cross) + 4 themed blocks (corners). Add `type=armor`, `god`, and `themed_block`/`themed_block_name` keys.

```yaml
- case demeter_armor:
    - determine <map[type=armor;blueprint=demeter_divine_schematic;themed_block=gold_block;themed_block_name=<&6>Gold Block;result_name=<&6>Demeter's Divine Armor;flag=demeter.armor.crafted;god_color=<&6>;god=demeter]>
- case hephaestus_armor:
    - determine <map[type=armor;blueprint=hephaestus_divine_schematic;themed_block=iron_block;themed_block_name=<&f>Iron Block;result_name=<&8>Hephaestus' Divine Armor;flag=hephaestus.armor.crafted;god_color=<&8>;god=hephaestus]>
- case heracles_armor:
    - determine <map[type=armor;blueprint=heracles_divine_schematic;themed_block=emerald_block;themed_block_name=<&a>Emerald Block;result_name=<&c>Heracles' Divine Armor;flag=heracles.armor.crafted;god_color=<&c>;god=heracles]>
- case triton_armor:
    - determine <map[type=armor;blueprint=triton_divine_schematic;themed_block=sea_lantern;themed_block_name=<&e>Sea Lantern;result_name=<&3>Triton's Divine Armor;flag=triton.armor.crafted;god_color=<&3>;god=triton]>
- case charon_armor:
    - determine <map[type=armor;blueprint=charon_divine_schematic;themed_block=crying_obsidian;themed_block_name=<&5>Crying Obsidian;result_name=<&5>Charon's Divine Armor;flag=charon.armor.crafted;god_color=<&5>;god=charon]>
```

**Forge recipe layout (armor type):**
```
Row 2: ThemedBlock(11), Helmet(12),     ThemedBlock(13)
Row 3: Chestplate(20), Schematic(21),   Leggings(22),  Arrow(24), Result(26)
Row 4: ThemedBlock(29), Boots(30),      ThemedBlock(31)
```

### 1C. Modify `open_recipe_gui` → `crafting.dsc`

Branch on recipe type for the GUI display. For armor recipes, show diamond armor pieces in cross slots and themed blocks in corners:

```yaml
- if <[recipe].get[type].if_null[weapon]> == armor:
    # Themed blocks in corners
    - define block_display <item[<[recipe].get[themed_block]>].with[display=<[recipe].get[themed_block_name]>]>
    - inventory set d:<[inv]> slot:11 o:<[block_display]>
    - inventory set d:<[inv]> slot:13 o:<[block_display]>
    - inventory set d:<[inv]> slot:29 o:<[block_display]>
    - inventory set d:<[inv]> slot:31 o:<[block_display]>
    # Diamond armor in cross
    - inventory set d:<[inv]> slot:12 o:<item[diamond_helmet].with[display=<&b>Diamond Helmet]>
    - inventory set d:<[inv]> slot:20 o:<item[diamond_chestplate].with[display=<&b>Diamond Chestplate]>
    - inventory set d:<[inv]> slot:22 o:<item[diamond_leggings].with[display=<&b>Diamond Leggings]>
    - inventory set d:<[inv]> slot:30 o:<item[diamond_boots].with[display=<&b>Diamond Boots]>
    # Schematic in center
    - inventory set d:<[inv]> slot:21 o:<item[<[recipe].get[blueprint]>]>
    # Result: diamond chestplate icon
    - if <player.has_flag[<[recipe].get[flag]>]>:
        - define result_display <item[diamond_chestplate].with[display=<[recipe].get[result_name]>;lore=<&7>A full set of divine armor.|<empty>|<&7>Helm, Chestplate, Leggings, Boots|<empty>|<&a>You already own this set!|<empty>|<&c>Cannot craft again.;enchantments=mending,1;hides=ALL]>
    - else:
        - define result_display <item[diamond_chestplate].with[display=<[recipe].get[result_name]>;lore=<&7>A full set of divine armor.|<empty>|<&7>Helm, Chestplate, Leggings, Boots|<empty>|<&a>Click to craft!|<empty>|<&8>Requires all ingredients.;enchantments=mending,1;hides=ALL]>
    - inventory set d:<[inv]> slot:24 o:<[arrow_display]>
    - inventory set d:<[inv]> slot:26 o:<[result_display]>
- else:
    # Existing weapon recipe display (unchanged)
```

### 1D. Modify craft click handler → `crafting.dsc` `mythic_crafting_click`

For armor recipes, verify different materials and give 4 items:

```yaml
- if <[recipe].get[type].if_null[weapon]> == armor:
    # Count armor pieces + themed blocks in inventory
    - define has_blueprint 0
    - define has_helmet 0
    - define has_chest 0
    - define has_legs 0
    - define has_boots 0
    - define has_blocks 0
    - define block_mat <[recipe].get[themed_block]>
    - foreach <player.inventory.map_slots> as:item:
        - if <[item].script.name.if_null[null]> == <[recipe].get[blueprint]>:
            - define has_blueprint <[has_blueprint].add[<[item].quantity>]>
        - else if <[item].material.name> == diamond_helmet:
            - define has_helmet <[has_helmet].add[<[item].quantity>]>
        - else if <[item].material.name> == diamond_chestplate:
            - define has_chest <[has_chest].add[<[item].quantity>]>
        - else if <[item].material.name> == diamond_leggings:
            - define has_legs <[has_legs].add[<[item].quantity>]>
        - else if <[item].material.name> == diamond_boots:
            - define has_boots <[has_boots].add[<[item].quantity>]>
        - else if <[item].material.name> == <[block_mat]>:
            - define has_blocks <[has_blocks].add[<[item].quantity>]>
    # Check missing (1 schematic, 1 each armor, 4 blocks)
    - define missing <list>
    - if <[has_blueprint]> < 1:
        - define missing <[missing].include[1x Schematic]>
    - if <[has_helmet]> < 1:
        - define missing <[missing].include[1x Diamond Helmet]>
    - if <[has_chest]> < 1:
        - define missing <[missing].include[1x Diamond Chestplate]>
    - if <[has_legs]> < 1:
        - define missing <[missing].include[1x Diamond Leggings]>
    - if <[has_boots]> < 1:
        - define missing <[missing].include[1x Diamond Boots]>
    - if <[has_blocks]> < 4:
        - define missing <[missing].include[<element[4].sub[<[has_blocks]>]>x <[recipe].get[themed_block_name]>]>
    # Stop if missing
    - if <[missing].size> > 0:
        - narrate "<&c>Missing ingredients:"
        - foreach <[missing]> as:line:
            - narrate "<&8>- <&f><[line]>"
        - playsound <player> sound:entity_villager_no volume:0.5
        - stop
    # Check inventory space for 4 result items
    - if <player.inventory.empty_slots.size> < 4:
        - narrate "<&c>You need at least 4 empty inventory slots!"
        - playsound <player> sound:entity_villager_no volume:0.5
        - stop
    # Take ingredients
    - take item:<[recipe].get[blueprint]> quantity:1
    - take diamond_helmet quantity:1
    - take diamond_chestplate quantity:1
    - take diamond_leggings quantity:1
    - take diamond_boots quantity:1
    - take <[block_mat]> quantity:4
    # Give armor set
    - define god <[recipe].get[god]>
    - give <[god]>_divine_helm
    - give <[god]>_divine_chestplate
    - give <[god]>_divine_leggings
    - give <[god]>_divine_boots
- else:
    # Existing weapon recipe flow (unchanged)
```

Ownership flag, close GUI, sounds, title, and server announcement all remain the same pattern — just the announcement says "forged **Demeter's Divine Armor**" etc.

### 1E. Add schematic right-click handlers → `crafting.dsc`

Add 10 new event handlers (block + air for each god's schematic):

```yaml
on player right clicks block with:demeter_divine_schematic:
- determine cancelled passively
- run open_recipe_gui def.recipe_id:demeter_armor
```

*(Repeat block+air for all 5 gods.)*

### Forge recipe summary

| Set | Center | Cross (4) | Corners (4) |
|-----|--------|-----------|-------------|
| Demeter | Schematic | Diamond armor set | Gold blocks |
| Hephaestus | Schematic | Diamond armor set | Iron blocks |
| Heracles | Schematic | Diamond armor set | Emerald blocks |
| Triton | Schematic | Diamond armor set | Sea lanterns |
| Charon | Schematic | Diamond armor set | Crying obsidian |

---

## Phase 2: Armor Items & Quest Tasks (5 new files)

### New Files

| File | Contents |
|------|----------|
| `scripts/emblems/demeter/demeter_armor.dsc` | 4 armor items + schematic + quest task + soulbound handler |
| `scripts/emblems/hephaestus/hephaestus_armor.dsc` | Same pattern |
| `scripts/emblems/heracles/heracles_armor.dsc` | Same pattern |
| `scripts/emblems/triton/triton_armor.dsc` | Same pattern |
| `scripts/emblems/charon/charon_armor.dsc` | Same pattern |

### Item Definitions (same across all 5, swap names/colors/materials)

**4 armor pieces per set:**

```yaml
demeter_divine_helm:
    type: item
    material: diamond_helmet
    display name: <&6>Demeter's Helm<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
        unbreakable: true
    lore:
    - <&7>A divine helm forged with
    - <&7>Demeter's golden blessing.
    - <empty>
    - <&e>Full set bonus:
    - <&7>Guaranteed meta key every 50 crates
    - <&7>Enhanced meta-crate unique odds
    - <empty>
    - <&8>Soulbound
    - <empty>
    - <&b><&l>DIVINE ARMOR
```

*(Repeat for chestplate, leggings, boots with appropriate material and lore flavor.)*

**Schematic item:**

```yaml
demeter_divine_schematic:
    type: item
    material: filled_map
    display name: <&6>Demeter's Divine Schematic<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>Ancient schematics detailing the
    - <&7>construction of Demeter's armor.
    - <empty>
    - <&e>Right-click to view recipe.
    - <empty>
    - <&b><&l>DIVINE SCHEMATIC
```

**Color/name table:**

| Emblem | Color | Helm Name | Schematic Name |
|--------|-------|-----------|----------------|
| Demeter | `<&6>` | Demeter's Helm | Demeter's Divine Schematic |
| Hephaestus | `<&8>` | Hephaestus' Helm | Hephaestus' Divine Schematic |
| Heracles | `<&c>` | Heracles' Helm | Heracles' Divine Schematic |
| Triton | `<&3>` | Triton's Helm | Triton's Divine Schematic |
| Charon | `<&5>` | Charon's Helm | Charon's Divine Schematic |

### Quest Task (per armor file)

Each `<god>_armor_quest` task handles all states:

1. **Armor already crafted** → "You already bear the armor."
2. **Schematic already obtained** → "Seek the Mythic Forge."
3. **Quest not started** → Introduce quest, list materials, set `<god>.armor.quest_started:true`
4. **Quest started + has all materials** → Take materials, give schematic, set `<god>.armor.schematic_obtained:true`
5. **Quest started + missing materials** → Show progress (X/Y per material)

### Quest Materials

| Emblem | Material 1 | Material 2 | Material 3 |
|--------|-----------|-----------|-----------|
| Demeter | 16 golden apples | 32 hay bales | 16 honey bottles |
| Hephaestus | 8 netherite ingots | 16 obsidian | 4 blast furnaces |
| Heracles | 16 blaze rods | 8 ghast tears | 4 wither skeleton skulls |
| Triton | 4 hearts of the sea | 16 nautilus shells | 32 prismarine crystals |
| Charon | 16 crying obsidian | 4 wither skeleton skulls | 8 soul lanterns |

### Soulbound Handler (per armor file)

```yaml
<god>_armor_soulbound:
    type: world
    debug: false
    events:
        on player drops <god>_divine_helm|<god>_divine_chestplate|<god>_divine_leggings|<god>_divine_boots:
        - determine cancelled
        - narrate "<&c>Divine armor is soulbound and cannot be dropped."
```

---

## Phase 3: NPC Quest Triggers

### 3A. Promachos → `promachos.dsc` (Tier 1 emblems)

Insert armor quest checks between ceremony checks and the `else` main menu:

```yaml
                # ...existing ceremony checks...
                # Armor quests (only if emblem unlocked, schematic not yet obtained)
                - else if <player.has_flag[demeter.emblem.unlocked]> && !<player.has_flag[demeter.armor.schematic_obtained]> && !<player.has_flag[demeter.armor.crafted]>:
                    - run demeter_armor_quest
                - else if <player.has_flag[hephaestus.emblem.unlocked]> && !<player.has_flag[hephaestus.armor.schematic_obtained]> && !<player.has_flag[hephaestus.armor.crafted]>:
                    - run hephaestus_armor_quest
                - else if <player.has_flag[heracles.emblem.unlocked]> && !<player.has_flag[heracles.armor.schematic_obtained]> && !<player.has_flag[heracles.armor.crafted]>:
                    - run heracles_armor_quest
                - else:
                    - inventory open d:promachos_main_menu
```

NPC captures click until schematic is obtained. Once obtained, falls through to main menu.

### 3B. Triton NPC → `triton_npc.dsc`

Insert between ceremony check and sea lantern turn-in:

```yaml
                - else if <player.has_flag[triton.emblem.unlocked]> && !<player.has_flag[triton.armor.schematic_obtained]> && !<player.has_flag[triton.armor.crafted]>:
                    - run triton_armor_quest
```

### 3C. Charon NPC → `charon_npc.dsc`

Same pattern, insert between ceremony check and debris turn-in.

---

## Phase 4: Crate Pity Timer (5 emblem crate files)

### 4A. Modify tier rolling procedures

In each `roll_<emblem>_tier` procedure, **remove** the 2% bonus and **add** pity check:

```yaml
roll_demeter_tier:
    type: procedure
    debug: false
    script:
    # Pity timer: guaranteed OLYMPIAN after 50 crates while wearing divine armor
    - if <proc[is_wearing_divine_armor].context[<player>|demeter]>:
        - if <player.flag[demeter.pity_counter].if_null[0]> >= 50:
            - determine <list[OLYMPIAN|<&b>]>

    - define roll <util.random.int[1].to[100]>
    # Flat 1% OLYMPIAN for everyone (no emblem-unlocked bonus)
    - define caps <list[56|82|94|99]>

    - if <[roll]> <= <[caps].get[1]>:
        - determine <list[MORTAL|<&f>]>
    # ...rest unchanged...
```

### 4B. Add pity counter tracking to key usage events

In each `<emblem>_key_usage` event, after taking the key and before the animation:

```yaml
        # Pity counter tracking
        - if <proc[is_wearing_divine_armor].context[<player>|demeter]>:
            - if <[tier]> == OLYMPIAN:
                - flag player demeter.pity_counter:0
            - else:
                - flag player demeter.pity_counter:++
```

**Flow:** Procedure checks `>= 50` → forces OLYMPIAN. Event resets on OLYMPIAN, increments otherwise. Counter only ticks while wearing full set. Persists across sessions.

### Files to modify:
- `scripts/emblems/demeter/demeter_crate.dsc`
- `scripts/emblems/heracles/heracles_crate.dsc`
- `scripts/emblems/hephaestus/hephaestus_crate.dsc`
- `scripts/emblems/triton/triton_crate.dsc`
- `scripts/emblems/charon/charon_crate.dsc`

---

## Phase 5: Meta-Crate Boost (5 meta crate files)

Modify `roll_<god>_outcome` procedures. Replace the 50/50 roll with an armor-aware check:

```yaml
    # Check divine armor for boosted unique odds
    - if <proc[is_wearing_divine_armor].context[<player>|demeter]>:
        # 75% unique / 25% apple
        - define roll <util.random.int[1].to[4]>
        - if <[roll]> == 1:
            - define result_map <map[type=GOD_APPLE;...]>
            - determine <[result_map]>
    - else:
        # Standard 50/50
        - define roll <util.random.int[1].to[2]>
        - if <[roll]> == 1:
            - define result_map <map[type=GOD_APPLE;...]>
            - determine <[result_map]>
    # ...unique item selection continues below (unchanged)...
```

**God-to-armor mapping:**

| Meta Crate | Armor Check |
|-----------|-------------|
| Ceres (`ceres_crate.dsc`) | `demeter` |
| Vulcan (`vulcan_crate.dsc`) | `hephaestus` |
| Mars (`mars_crate.dsc`) | `heracles` |
| Neptune (`neptune_crate.dsc`) | `triton` |
| Dis (`dis_crate.dsc`) | `charon` |

**Note:** "All obtained" check at top of procedure remains unchanged — always forces god apple if all 4 uniques owned, regardless of armor.

---

## Phase 6: Admin Commands

### 6A. New `/armoradmin` command → `admin_commands.dsc`

```
/armoradmin <player> give <emblem>      — Give full armor set + set crafted flag
/armoradmin <player> schematic <emblem> — Give schematic + set obtained flag
/armoradmin <player> pity <emblem>      — Show pity counter
/armoradmin <player> pity <emblem> set <n> — Set pity counter
/armoradmin <player> reset <emblem>     — Clear all armor flags for that emblem
```

### 6B. Update `emblemreset_task`

No changes needed — `flag <[target]> demeter:!` already clears the entire `demeter.*` flag tree, which includes `demeter.armor.*` and `demeter.pity_counter`.

---

## New Flags

| Flag | Type | Purpose |
|------|------|---------|
| `<god>.armor.quest_started` | bool | NPC has offered the quest |
| `<god>.armor.schematic_obtained` | bool | Schematic received from NPC |
| `<god>.armor.crafted` | bool | Armor forged at Mythic Forge |
| `<god>.pity_counter` | int | Crates opened wearing set since last OLYMPIAN |

---

## Files Summary

### New (5 files)
- `scripts/emblems/demeter/demeter_armor.dsc`
- `scripts/emblems/hephaestus/hephaestus_armor.dsc`
- `scripts/emblems/heracles/heracles_armor.dsc`
- `scripts/emblems/triton/triton_armor.dsc`
- `scripts/emblems/charon/charon_armor.dsc`

### Modified (16 files)
- `scripts/emblems/core/roles.dsc` — add `is_wearing_divine_armor`
- `scripts/emblems/core/crafting.dsc` — 5 recipes, armor type handling, schematic right-clicks, GUI display
- `scripts/emblems/core/promachos.dsc` — armor quest triggers in interact script
- `scripts/emblems/triton/triton_npc.dsc` — armor quest trigger
- `scripts/emblems/charon/charon_npc.dsc` — armor quest trigger
- `scripts/emblems/demeter/demeter_crate.dsc` — remove 2% bonus, add pity
- `scripts/emblems/heracles/heracles_crate.dsc` — same
- `scripts/emblems/hephaestus/hephaestus_crate.dsc` — same
- `scripts/emblems/triton/triton_crate.dsc` — same
- `scripts/emblems/charon/charon_crate.dsc` — same
- `scripts/emblems/demeter/ceres_crate.dsc` — 75/25 meta boost
- `scripts/emblems/heracles/mars_crate.dsc` — same
- `scripts/emblems/hephaestus/vulcan_crate.dsc` — same
- `scripts/emblems/triton/neptune_crate.dsc` — same
- `scripts/emblems/charon/dis_crate.dsc` — same
- `scripts/emblems/admin/admin_commands.dsc` — `/armoradmin`

---

## Verification

1. `/armoradmin <player> give demeter` — confirm 4 pieces appear, all unbreakable with correct lore
2. Wear full set → `/testroll demeter 100` — confirm at least 1 OLYMPIAN per 50 rolls
3. `/armoradmin <player> pity demeter set 49` → open 1 Demeter crate wearing set → confirm OLYMPIAN
4. Open Ceres crate wearing Demeter set → confirm unique items appear ~75% of the time
5. Open Ceres crate WITHOUT set → confirm ~50/50 split
6. Test quest flow: unlock emblem → click NPC → collect materials → click NPC → get schematic → right-click schematic → craft at forge
7. Verify soulbound: try dropping armor piece, try putting in chest
8. `/emblemreset` → confirm all armor flags cleared
