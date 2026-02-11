# Emblem Implementation Template

Complete checklist for implementing a new emblem line (Greek god + Roman meta).

**Replace placeholders:**
- `<god>` = Greek god lowercase (e.g., `hephaestus`)
- `<God>` = Greek god capitalized (e.g., `Hephaestus`)
- `<GOD>` = Greek god uppercase (e.g., `HEPHAESTUS`)
- `<meta_god>` = Roman god lowercase (e.g., `vulcan`)
- `<Meta_God>` = Roman god capitalized (e.g., `Vulcan`)
- `<Emblem>` = Emblem display name (e.g., `Hephaestus`)
- `<&X>` = Emblem color code (e.g., `<&b>` for cyan)

---

## Phase 1: Design Decisions

### Core Identity
- [ ] **Emblem**: DEMETER / HEPHAESTUS / HERACLES (or new god name)
- [ ] **Greek God**: Name, title, theme
- [ ] **Roman God**: Name (meta-progression)
- [ ] **Color Code**: `<&X>` for all UI (pick one: `<&6>` gold, `<&c>` red, `<&b>` cyan, `<&a>` green)
- [ ] **Emblem Icon Material**: For profile display (e.g., `diamond_pickaxe`)
- [ ] **Crate Border Material**: `X_stained_glass_pane` (e.g., `cyan_stained_glass_pane`)

### Three Activities (keys + components)

| # | Activity | Event Trigger | Key Threshold | Component Milestone |
|---|----------|---------------|---------------|---------------------|
| 1 | e.g., "Mine iron ore" | `player breaks iron_ore` | 100 | 10,000 |
| 2 | e.g., "Smelt items" | `player takes from furnace` | 50 | 5,000 |
| 3 | e.g., "Craft anvils" | `player crafts anvil` | 10 | 500 |

### Crate Loot (5 tiers)

| Tier | Weight | Example Rewards |
|------|--------|-----------------|
| MORTAL | 50 | Common items, small stacks |
| HEROIC | 30 | Uncommon items, medium stacks |
| LEGENDARY | 13 | Rare items, enchanted gear |
| MYTHIC | 6 | Very rare, special items |
| OLYMPIAN | 1 | Best loot, Blessing/Tool/Title chance |

### Special Crate Items
- [ ] **Blessing**: Temporary boost to all 3 activities
- [ ] **Tool**: Emblem-specific tool with special ability
- [ ] **Title**: Chat prefix cosmetic

### Meta Items (4 unique from Roman crate)

| # | Item Name | Material | Effect |
|---|-----------|----------|--------|
| 1 | e.g., "Vulcan Hammer" | `netherite_pickaxe` | ... |
| 2 | e.g., "Vulcan Title" | `name_tag` | `[Vulcan's Chosen]` prefix |
| 3 | e.g., "Vulcan Furnace" | `blast_furnace` | ... |
| 4 | e.g., "Shulker Box" | `cyan_shulker_box` | Portable storage |

---

## Phase 2: Create Script Files

### File 1: `scripts/emblems/<god>/<god>_events.dsc`

**World Scripts to Create:**

- [ ] `<god>_activity1_handler` - Track activity 1
  - Event: `on player <event>:`
  - Check emblem: `<player.flag[emblem.active]> == <GOD>`
  - Increment: `flag player <god>.activity1.count:++`
  - Check blessing boost
  - Check key threshold
  - Check component milestone

- [ ] `<god>_activity2_handler` - Track activity 2 (same pattern)

- [ ] `<god>_activity3_handler` - Track activity 3 (same pattern)

**Key Award Logic (in each handler):**
```yaml
# Calculate keys earned
- define count <player.flag[<god>.activity1.count].if_null[0]>
- define keys_awarded <player.flag[<god>.activity1.keys_awarded].if_null[0]>
- define keys_should_have <[count].div[THRESHOLD].round_down>
- define delta <[keys_should_have].sub[<[keys_awarded]>]>
- if <[delta]> > 0:
    - flag player <god>.activity1.keys_awarded:<[keys_should_have]>
    - give <item[<god>_key].with[quantity=<[delta]>]>
    - narrate "<&X>+<[delta]> <God> Key(s)!"
```

**Component Milestone Logic:**
```yaml
- if <[count]> >= MILESTONE && !<player.has_flag[<god>.component.activity1]>:
    - flag player <god>.component.activity1:true
    - narrate "<&d><&l>COMPONENT UNLOCKED! <&7>Activity1 mastered!"
    - playsound <player> sound:ui_toast_challenge_complete
    - announce "<player.name> unlocked the <&d>Activity1 Component<&7>!"
```

**Flags Used:**
```
<god>.activity1.count
<god>.activity1.keys_awarded
<god>.activity2.count
<god>.activity2.keys_awarded
<god>.activity3.count
<god>.activity3.keys_awarded
<god>.component.activity1
<god>.component.activity2
<god>.component.activity3
```

---

### File 2: `scripts/emblems/<god>/<god>_crate.dsc`

**Items:**
- [ ] `<god>_key` - Key item (tripwire_hook, colored display)
- [ ] `<god>_crate_filler` - Border glass pane
- [ ] `<god>_crate_center` - Center animation slot

**World Scripts:**
- [ ] `<god>_key_use_handler`
  - Event: `on player right clicks block with:<god>_key:`
  - Take 1 key, run crate open task

**Tasks:**
- [ ] `open_<god>_crate` - Main crate opening
  - Open GUI, run animation, determine reward

- [ ] `<god>_crate_animation` - 3-phase scroll animation
  - Phase 1: Fast (5 ticks, 8 iterations)
  - Phase 2: Medium (10 ticks, 5 iterations)
  - Phase 3: Slow (15 ticks, 3 iterations)

- [ ] `<god>_crate_display_win` - Show final reward
  - Center slot highlight, give item, close after delay

**Procedures:**
- [ ] `roll_<god>_tier` - Weighted tier selection
  ```yaml
  - define roll <util.random.int[1].to[100]>
  - if <[roll]> <= 50:
      - determine MORTAL
  - if <[roll]> <= 80:
      - determine HEROIC
  - if <[roll]> <= 93:
      - determine LEGENDARY
  - if <[roll]> <= 99:
      - determine MYTHIC
  - determine OLYMPIAN
  ```

- [ ] `roll_<god>_loot` - Tier-based loot selection
  - Each tier has weighted loot table
  - OLYMPIAN has 1% meta key drop (2% with emblem unlocked)

- [ ] `get_<god>_sample_item` - Random item for animation

**GUI:**
- [ ] `<god>_crate_gui` - 27 slots, colored border
  ```yaml
  <god>_crate_gui:
      type: inventory
      inventory: chest
      gui: true
      debug: false
      title: <&8><God> Crate
      size: 27
      definitions:
          x: <item[<god>_crate_filler]>
          o: <item[<god>_crate_center]>
      slots:
      - [x] [x] [x] [x] [x] [x] [x] [x] [x]
      - [x] [o] [o] [o] [o] [o] [o] [o] [x]
      - [x] [x] [x] [x] [x] [x] [x] [x] [x]
  ```

**Close Handler:**
- [ ] `<god>_crate_close_handler`
  - Event: `on player closes <god>_crate_gui:`
  - Flag cleanup for animation state

---

### File 3: `scripts/emblems/<god>/<god>_blessing.dsc`

**Items:**
- [ ] `<god>_blessing` - Consumable boost item
  ```yaml
  <god>_blessing:
      type: item
      material: paper
      display name: <&X><&l><God>'s Blessing
      lore:
      - <&7>A divine blessing from <&X><God><&7>.
      - <empty>
      - <&e>Effects (30 minutes)<&co>
      - <&7>• +50 Activity1 per action
      - <&7>• +10 Activity2 per action
      - <&7>• +2 Activity3 per action
      - <empty>
      - <&e>Right-click to activate!
      enchantments:
      - mending:1
      mechanisms:
          hides: ENCHANTS
  ```

**World Scripts:**
- [ ] `<god>_blessing_use_handler`
  - Event: `on player right clicks with:<god>_blessing:`
  - Check not already active
  - Take item, set flag with expiration
  - Show effects message

**Flag:**
```
<god>.blessing.active (expire:30m)
```

**Boost Values (check in events):**
```yaml
- if <player.has_flag[<god>.blessing.active]>:
    - define boost <[base_amount].add[BOOST_AMOUNT]>
```

---

### File 4: `scripts/emblems/<meta_god>/<meta_god>_crate.dsc`

**Items:**
- [ ] `<meta_god>_key` - Meta key item (prismarine shard, colored)
- [ ] `<meta_god>_crate_filler` - Border (same color as god)
- [ ] `<meta_god>_crate_center` - Center slot

**World Scripts:**
- [ ] `<meta_god>_key_use_handler` - Open meta crate

**Tasks:**
- [ ] `open_<meta_god>_crate` - Main task
- [ ] `<meta_god>_crate_animation` - Same 3-phase pattern
- [ ] `<meta_god>_crate_display_win` - Show reward

**Procedures:**
- [ ] `roll_<meta_god>_reward` - 50/50 unique vs god apple
  ```yaml
  - define available <list>
  - if !<player.has_flag[<meta_god>.item.item1]>:
      - define available <[available].include[item1]>
  # ... check all 4
  - if <[available].is_empty>:
      - determine god_apple
  - if <util.random.int[1].to[2]> == 1:
      - determine <[available].random>
  - determine god_apple
  ```

- [ ] `get_<meta_god>_sample_item` - Animation items

**GUI:**
- [ ] `<meta_god>_crate_gui` - 27 slots, colored border

**Flags:**
```
<meta_god>.item.item1
<meta_god>.item.item2
<meta_god>.item.item3
<meta_god>.item.item4
```

---

### File 5: `scripts/emblems/<meta_god>/<meta_god>_items.dsc`

**Items (4 unique):**
- [ ] `<meta_god>_item1` - First unique item
- [ ] `<meta_god>_item2` - Second unique (usually title)
- [ ] `<meta_god>_item3` - Third unique
- [ ] `<meta_god>_item4` - Fourth unique (usually shulker)

**World Scripts (for items with mechanics):**
- [ ] `<meta_god>_item1_handler` - Use handler if needed
- [ ] Cooldown handling if applicable

**Title Item:**
```yaml
<meta_god>_title:
    type: item
    material: name_tag
    display name: <&X><&l><Meta_God> Title
    lore:
    - <&7>A title granted by <&X><Meta_God><&7>.
    - <empty>
    - <&e>Grants title<&co>
    - <&X>[<Meta_God>'s Chosen]
    - <empty>
    - <&e>Right-click to unlock!
```

---

## Phase 3: Update Existing Files

### File 6: `scripts/emblems/core/promachos.dsc`

**System Info Items (update lore):**

- [ ] `system_info_emblems_list` - Add emblem description
  ```yaml
  - <&X><Emblem> <&7>(<GOD>)<&co>
  - <&7>Activity1, activity2, activity3
  ```

- [ ] `system_info_emblems` - Add emblem info
  ```yaml
  - <&X><God>'s Emblem <&7>(<GOD>)<&co>
  - <&7>Activity1, activity2, activity3 milestones
  ```

- [ ] `system_info_crates` - Add crate info
  ```yaml
  - <&X><God> Crates <&7>(<GOD>)<&co>
  - <&7>Brief loot description
  ```

**Emblem Check GUI:**

- [ ] `get_emblem_check_items` procedure - Add new emblem display
  ```yaml
  # Add case for <god>
  - define <god>_item <proc[get_<god>_emblem_status_item]>
  - define items <[items].set[<[<god>_item]>].at[SLOT]>
  ```

- [ ] Create `get_<god>_emblem_status_item` procedure
  - Show component progress
  - Show locked/unlocked state

**Emblem Completion:**

- [ ] `check_emblem_completion` task - Add check
  ```yaml
  - if <player.has_flag[<god>.component.activity1]> && <player.has_flag[<god>.component.activity2]> && <player.has_flag[<god>.component.activity3]>:
      - if !<player.has_flag[<god>.emblem.unlocked]>:
          - run <god>_emblem_ceremony
  ```

- [ ] Create `<god>_emblem_ceremony` task
  - Set emblem flags
  - Awards, announcements, effects

---

### File 7: `scripts/profile_gui.dsc`

**This is the most detailed section - many procedures to update/create.**

#### 7.1 Emblem Display Item

- [ ] `get_emblem_display_item` procedure - Add CASE block:
  ```yaml
  - case <GOD>:
      - define lore <[lore].include[<&e>Patron<&co> <&X><[god]><&7>, God of X]>
      - define lore "<[lore].include[<&sp>]>"

      # Show progress stats
      - define activity1 <player.flag[<god>.activity1.count].if_null[0]>
      - define activity2 <player.flag[<god>.activity2.count].if_null[0]>
      - define activity3 <player.flag[<god>.activity3.count].if_null[0]>
      - define keys <player.flag[<god>.activity1.keys_awarded].if_null[0].add[...]>

      - define lore <[lore].include[<&X>Your Progress<&co>]>
      - define lore <[lore].include[<&7>• Activity1<&co> <&X><[activity1].format_number>]>
      - define lore <[lore].include[<&7>• Activity2<&co> <&X><[activity2].format_number>]>
      - define lore <[lore].include[<&7>• Activity3<&co> <&X><[activity3].format_number>]>
      - define lore "<[lore].include[<&sp>]>"
      - define lore <[lore].include[<&X>Keys earned<&co> <&X><[keys]> <&7><God> Keys]>
  ```

- [ ] `get_emblem_icon` procedure (in emblem_data.dsc) - Add case:
  ```yaml
  - case <GOD>:
      - determine <material>  # e.g., diamond_pickaxe
  ```

#### 7.2 Progress GUI (Activity Details)

- [ ] Create `<god>_progress_gui` inventory:
  ```yaml
  <god>_progress_gui:
      type: inventory
      inventory: chest
      gui: true
      debug: false
      title: <&8><God> - Activity Progress
      size: 27
      procedural items:
      - determine <proc[get_<god>_progress_items]>
  ```

- [ ] Create `get_<god>_progress_items` procedure:
  - Slot 11: Activity 1 progress item
  - Slot 13: Activity 2 progress item
  - Slot 15: Activity 3 progress item
  - Slot 19: Back button
  - Show count, keys earned, component status, % to milestone

- [ ] Create `get_<god>_activity1_item` procedure (etc for each)
  ```yaml
  - define count <player.flag[<god>.activity1.count].if_null[0]>
  - define complete <player.has_flag[<god>.component.activity1]>
  - define lore <list>
  - if <[complete]>:
      - define lore <[lore].include[<&2>✓ COMPLETE]>
  - else:
      - define percent <[count].div[MILESTONE].mul[100].round>
      - define lore <[lore].include[<&7>Progress<&co> <[count]>/MILESTONE (<[percent]>%)]>
  - define lore <[lore].include[<&7>Keys earned<&co> <player.flag[<god>.activity1.keys_awarded].if_null[0]>]>
  ```

- [ ] Create `<god>_progress_back_button` item

- [ ] Add click handler to open from emblem item click

#### 7.3 Cosmetics Integration

- [ ] `get_cosmetics_icon_item` procedure - Add title count check:
  ```yaml
  - if <player.has_flag[<god>.item.title]>:
      - define title_count <[title_count].add[1]>
  - if <player.has_flag[<meta_god>.item.title]>:
      - define title_count <[title_count].add[1]>
  ```

- [ ] `get_cosmetics_icon_item` procedure - Add active title display:
  ```yaml
  - case <god>:
      - define lore "<[lore].include[<&X><&lb>Title Text<&rb>]>"
  - case <meta_god>:
      - define lore "<[lore].include[<&X><&lb>Meta Title Text<&rb>]>"
  ```

- [ ] `get_cosmetics_menu_items` procedure - Add title slots:
  ```yaml
  - define <god>_title <proc[get_<god>_title_item]>
  - define items <[items].set[<[<god>_title]>].at[SLOT]>

  - define <meta_god>_title <proc[get_<meta_god>_title_item]>
  - define items <[items].set[<[<meta_god>_title]>].at[SLOT]>
  ```

- [ ] Create `get_<god>_title_item` procedure:
  ```yaml
  - if <player.has_flag[<god>.item.title]>:
      # Show unlocked, equipped/unequipped state
  - else:
      # Show locked gray dye
  ```

- [ ] Create `get_<meta_god>_title_item` procedure (same pattern)

- [ ] Add click handlers for title equip/unequip:
  ```yaml
  on player clicks name_tag in cosmetics_inventory:
      # Check which title, toggle cosmetic.title.active flag
  ```

#### 7.4 Click Handlers

- [ ] `profile_gui_click_handler` - Add handlers:
  ```yaml
  # Emblem item click -> open progress GUI
  after player clicks <emblem_material> in profile_inventory:
      - if <player.flag[emblem.active].if_null[NONE]> == <GOD>:
          - inventory open d:<god>_progress_gui

  # Progress GUI back button
  after player clicks <god>_progress_back_button in <god>_progress_gui:
      - run open_profile_gui
  ```

---

### File 8: `scripts/emblems/core/emblem_data.dsc`

- [ ] `is_valid_emblem` - Should already include all emblems
- [ ] `get_emblem_display_name` - Add case:
  ```yaml
  - case <GOD>:
      - determine <Emblem>  # e.g., Hephaestus
  ```
- [ ] `get_emblem_god` - Add case:
  ```yaml
  - case <GOD>:
      - determine <God>  # e.g., Hephaestus
  ```
- [ ] `get_emblem_meta_god` - Add case:
  ```yaml
  - case <GOD>:
      - determine <Meta_God>  # e.g., Vulcan
  ```
- [ ] `get_emblem_icon` - Add case:
  ```yaml
  - case <GOD>:
      - determine <material>  # e.g., diamond_pickaxe
  ```

---

### File 9: `scripts/emblems/admin/admin_commands.dsc`

#### 9.1 Create `<god>admin` command:
```yaml
<god>admin_command:
    type: command
    name: <god>admin
    description: Manage <God> progression
    usage: /<god>admin (player) (action) [args...]
    permission: emblems.admin
    debug: false
    script:
    # Subcommands:
    # set activity1 <count>
    # set activity2 <count>
    # set activity3 <count>
    # keys <amount>
    # component <name> <true/false>
    # emblem <true/false>
    # reset
```

#### 9.2 Create `<meta_god>admin` command:
```yaml
# Subcommands:
# item <name> <true/false>
# keys <amount>
# reset
```

#### 9.3 Update existing commands:
- [ ] `checkkeys` - Add new key display
- [ ] `emblemreset` - Add new flags to clear

---

## Phase 4: Documentation

### File 10: Create `docs/<god>.md`
- [ ] Overview and theme
- [ ] Activities table (thresholds, milestones)
- [ ] Key earning explanation
- [ ] Component milestones
- [ ] Crate loot tables (all 5 tiers)
- [ ] Special items (Blessing, Tool, Title)

### File 11: Create `docs/<meta_god>.md`
- [ ] Overview
- [ ] How to unlock (from Olympian crates)
- [ ] Four unique items with descriptions
- [ ] God apple fallback

### File 12: Update `docs/flags.md`
- [ ] Activity counter flags
- [ ] Keys awarded flags
- [ ] Component flags
- [ ] Emblem unlock flags
- [ ] Meta item flags
- [ ] Cooldown flags (if any)

### File 13: Update `docs/testing.md`
- [ ] `<god>admin` command reference
- [ ] `<meta_god>admin` command reference
- [ ] Test scenarios for all features

### File 14: Update `CLAUDE.md`
- [ ] Script structure tree
- [ ] Admin commands list
- [ ] Emblem status (planned -> complete)

### File 15: Update `docs/README.md`
- [ ] God documentation link
- [ ] Meta god documentation link
- [ ] Emblem status

---

## Phase 5: Testing Checklist

### Activity Tracking
- [ ] Activity 1 increments correctly
- [ ] Activity 2 increments correctly
- [ ] Activity 3 increments correctly
- [ ] Only tracks when emblem active
- [ ] Blessing boost works (+X per action)

### Key Awards
- [ ] Keys at correct thresholds
- [ ] Delta prevents double-awards
- [ ] Keys appear in inventory
- [ ] Notification displays

### Components
- [ ] Component 1 at milestone
- [ ] Component 2 at milestone
- [ ] Component 3 at milestone
- [ ] Once-only award
- [ ] Broadcast announcement

### Emblem Unlock
- [ ] Promachos detects completion
- [ ] Ceremony triggers
- [ ] Flags set correctly
- [ ] Rewards given

### Crate System
- [ ] Key consumed
- [ ] GUI opens
- [ ] Animation plays (3 phases)
- [ ] Tiers weighted correctly
- [ ] Loot appropriate per tier
- [ ] Special items drop
- [ ] Meta key drops (1% Olympian)
- [ ] GUI closes cleanly

### Meta Crate
- [ ] Meta key consumed
- [ ] Unique items until all collected
- [ ] God apples after all unique
- [ ] Item flags set

### Meta Items
- [ ] Each item works
- [ ] Cooldowns work
- [ ] No exploits

### Admin Commands
- [ ] All set commands
- [ ] All reset commands
- [ ] Key give commands
- [ ] Permission checks

### Profile GUI
- [ ] Emblem icon correct material
- [ ] Emblem icon shows all stats
- [ ] Click opens correct progress GUI
- [ ] Progress GUI shows all activities
- [ ] Progress GUI percentages correct
- [ ] Back buttons all work
- [ ] Cosmetics shows new titles
- [ ] Titles equip/unequip

### Emblem Check GUI
- [ ] New emblem displays
- [ ] Component status correct
- [ ] Unlock ceremony works

---

## Phase 6: Final Steps

- [ ] Full playtest (zero to emblem)
- [ ] Test emblem switching
- [ ] Test edge cases (max values, rapid clicks)
- [ ] Verify `debug: false` on ALL scripts
- [ ] Remove test narrates
- [ ] Update bulletin announcement
- [ ] Increment bulletin version
- [ ] Reload and final test

---

## Quick File Reference

### New Files (7)
```
scripts/emblems/<god>/
├── <god>_events.dsc
├── <god>_crate.dsc
└── <god>_blessing.dsc

scripts/emblems/<meta_god>/
├── <meta_god>_crate.dsc
└── <meta_god>_items.dsc

docs/
├── <god>.md
└── <meta_god>.md
```

### Updated Files (8)
```
scripts/
├── profile_gui.dsc         # Major updates
└── emblems/
    ├── core/
    │   ├── promachos.dsc   # Emblem check, system info
    │   └── emblem_data.dsc # Emblem procedures
    └── admin/
        └── admin_commands.dsc

docs/
├── README.md
├── flags.md
└── testing.md

CLAUDE.md
```
