# Emblem Functionality

## Overview

The emblem system implements multiple progression lines tied to Greek gods. Players complete 5 sequential stages through various activities to earn final emblem rewards.

**Current Emblems:**
- **Forgeheart Emblem** (Hephaestus) - Mining, combat, trading, crafting
- **Verdant Oath Emblem** (Demeter) - Farming, breeding, trading
- **Trial of Might Emblem** (Heracles) - Combat, raids, trading

---

## Project Structure

```
scripts/
├── profile_gui.dsc              Entry point (/profile command)
└── emblems/
    ├── emblem_items.dsc         Custom item definitions
    ├── emblem_guis.dsc          Inventory GUIs and progression display
    ├── emblem_events.dsc        Event handlers and progress tracking
    ├── emblem_recipes.dsc       Crafting recipes and recipe viewer
    ├── emblem_admin.dsc         Admin commands for testing
    └── promachos_npc.dsc        NPC interaction and trade system
```

---

## Rarity System

| Tier | Color Code | Color | Use Case |
|------|------------|-------|----------|
| MORTAL | `<&f>` | White | Currency, basic tools |
| HEROIC | `<&e>` | Yellow | Consumables, rare drops |
| LEGENDARY | `<&6>` | Gold | Emblems |

### Item Lore Format
```yaml
lore:
- <&7><&o>Flavor text description
- <&7><&o>continues here.
- " "
- <&e>Ability Name<&co>        # If applicable
- <&f>Ability description.
- " "
- <&COLOR><&l>TIER ITEMTYPE    # e.g., <&f><&l>MORTAL MATERIAL
```

### Item Conventions
- All custom items (except tools/armor) have enchant glint:
  ```yaml
  enchantments:
  - mending:1
  mechanisms:
      hides: ENCHANTS
  ```
- Use legacy color codes (`<&6>`, `<&e>`, etc.) for consistency

### Drop Message Format
```
<&e><&l>HEROIC DROP! <&r><&f>Item Name <&e>X%
```

---

## Progression Stages

### Hephaestus - Forgeheart Emblem

| Stage | Name | Requirement | Reward |
|-------|------|-------------|--------|
| 1 | Iron Harvest | Mine 500 iron ore | 100 XP |
| 2 | Golem Slayer | Kill 100 iron golems | 200 XP |
| 3 | Ember Trader | Trade for 10 Hephaestian Embers | 300 XP |
| 4 | Deep Forge | Mine 2,000 deepslate iron ore with Hammer of the Flame | 400 XP |
| 5 | Forgeheart | Final trade with Promachos NPC | 500 XP |

**Notes:**
- Silk touch prevents mining progress (stages 1 and 4)
- Stage 4 has 0.5% chance per ore to drop Molten Shard (~10 expected from 2,000 blocks)

### Demeter - Verdant Oath Emblem

| Stage | Name | Requirement | Reward |
|-------|------|-------------|--------|
| 1 | Harvest of Plenty | Harvest 2,000 fully-grown wheat | 100 XP |
| 2 | Steward of the Herd | Breed 200 cows | 200 XP |
| 3 | Verdant Exchange | Obtain 32 Sheaves of Abundance | 300 XP |
| 4 | Sacred Nurturing | Harvest 20,000 wheat AND use Verdant Feed 1,000 times | 400 XP |
| 5 | Verdant Oath | Final trade with Promachos NPC | 500 XP |

**Notes:**
- Wheat must be fully grown (age 7) for stages 1 and 4
- Stage 4 has dual requirements (both must be completed)
- Verdant Feed has 2-second cooldown, spawns 1 baby cow, 1% chance for Seed of Renewal (~10 expected from 1,000 feeds)

### Heracles - Trial of Might Emblem

| Stage | Name | Requirement | Reward |
|-------|------|-------------|--------|
| 1 | Cleansing the Wilds | Kill 250 pillagers | 100 XP |
| 2 | Trial of the Banner | Complete 15 full raids (victory + participated) | 200 XP |
| 3 | Spoils of Conquest | Obtain 8 Marks of Conquest | 300 XP |
| 4 | The Hero's Trial | Kill 800 raid mobs with Lionfang Blade during raids | 400 XP |
| 5 | Ascension of Might | Final trade with Promachos NPC | 500 XP |

**Notes:**
- Stage 1 has anti-cheese: pillagers with `from_spawner` flag don't count
- Raid mobs are flagged with `heracles.is_raid_mob` when spawned in raid waves
- Stage 4 requires wielding Lionfang Blade AND mob must have raid flag
- Stage 4 has 1.5% chance per kill to drop Mark of Might (~12 expected from 800 kills)
- Valid raid mobs: pillager, vindicator, evoker, ravager, vex

### General Rules
- Each stage must be claimed before the next becomes available
- Stage info is hidden until the previous stage is claimed
- Progress only tracks when on the active stage (previous stage claimed, current not claimed)

---

## Custom Items

### Hephaestus Items

| Script Name | Material | Tier | Purpose |
|-------------|----------|------|---------|
| `hephaestian_ember` | blaze_powder | MORTAL | Trade currency, crafting ingredient |
| `hammer_of_the_flame` | diamond_pickaxe | MORTAL | Required tool for Stage 4 |
| `molten_shard` | gold_nugget | HEROIC | Rare drop (0.5%), emblem requirement |
| `forgeheart_emblem` | nether_star | LEGENDARY | Final reward item |

### Demeter Items

| Script Name | Material | Tier | Purpose |
|-------------|----------|------|---------|
| `sheaf_of_abundance` | paper | MORTAL | Trade currency |
| `verdant_feed` | wheat_seeds | HEROIC | Consumable for Stage 4, 1% seed drop |
| `seed_of_renewal` | melon_seeds | HEROIC | Rare drop (1%), emblem requirement |
| `verdant_oath_emblem` | nether_star | LEGENDARY | Final reward item |

### Heracles Items

| Script Name | Material | Tier | Purpose |
|-------------|----------|------|---------|
| `mark_of_conquest` | emerald | MORTAL | Trade currency |
| `lionfang_blade` | diamond_sword | MORTAL | Required weapon for Stage 4 |
| `mark_of_might` | gold_nugget | HEROIC | Rare drop (1.5%), emblem requirement |
| `trial_of_might_emblem` | nether_star | LEGENDARY | Final reward item |

### GUI Items

| Script Name | Material | Purpose |
|-------------|----------|---------|
| `hephaestus_emblem_icon` | anvil | Emblem selection menu |
| `demeter_emblem_icon` | hay_block | Emblem selection menu |
| `heracles_emblem_icon` | iron_sword | Emblem selection menu |
| `gui_back_button` | arrow | Navigation |
| `*_locked_stage` | gray_dye | Hidden stage placeholder ("???") |
| `promachos_locked_trade` | gray_dye | Locked trade placeholder ("???") |

### Stage Info Item Materials

| Emblem | Stage 1 | Stage 2 | Stage 3 | Stage 4 | Stage 5 |
|--------|---------|---------|---------|---------|---------|
| Hephaestus | iron_ore | carved_pumpkin | blaze_powder | diamond_pickaxe | nether_star |
| Demeter | wheat | cow_spawn_egg | paper | wheat_seeds | nether_star |
| Heracles | crossbow | white_banner | emerald | diamond_sword | nether_star |

---

## GUI Structure

### Inventory Sizes
- Emblem Selection: 27 slots (3 rows)
- Progress GUIs: 45 slots (5 rows)
- NPC Menus: 27 slots (3 rows)

### Progress GUI Layout (45 slots, 5 rows)
```
Row 1: [Empty padding - slots 1-9]
Row 2: [] [] [S1 Info] [S2 Info] [S3 Info] [S4 Info] [S5 Info] [] []
Row 3: [] [] [S1 Pane] [S2 Pane] [S3 Pane] [S4 Pane] [S5 Pane] [] []
Row 4: [Empty padding - slots 28-36]
Row 5: [] [] [] [] [Back] [] [] [] []
```
- Stage info items: slots 12-16
- Status panes: slots 21-25
- Back button: slot 41

### Status Pane Colors
| Color | Material | Meaning |
|-------|----------|---------|
| Red | red_stained_glass_pane | Locked or in progress |
| Yellow | yellow_stained_glass_pane | Ready to claim (clickable) |
| Lime | lime_stained_glass_pane | Already claimed |

### Dynamic Pane Display
```yaml
# Locked (previous stage not claimed)
display_name: <&c>Locked
lore: <&7>Complete stage X first

# In Progress
display_name: <&c>In Progress
lore: <&7>Progress Label<&co> <&f>X<&7>/<&f>Required

# Ready to Claim
display_name: <&e>Ready to Claim!
lore: [progress line] | <&a>Click to claim reward!

# Claimed
display_name: <&a>Stage X Complete
lore: [progress line] | <&a>Claimed!
```

---

## Flag Structure

### Hephaestus Flags
```
hephaestus.stage1.progress     (Number, 0-500)
hephaestus.stage1.claimed      (Boolean)
hephaestus.stage2.progress     (Number, 0-100)
hephaestus.stage2.claimed      (Boolean)
hephaestus.stage3.progress     (Number, 0-10)
hephaestus.stage3.claimed      (Boolean)
hephaestus.stage4.progress     (Number, 0-2000)
hephaestus.stage4.claimed      (Boolean)
hephaestus.stage5.completed    (Boolean - set when emblem traded)
hephaestus.stage5.claimed      (Boolean)
```

### Demeter Flags
```
demeter.stage1.progress        (Number, 0-2000)
demeter.stage1.claimed         (Boolean)
demeter.stage2.progress        (Number, 0-200)
demeter.stage2.claimed         (Boolean)
demeter.stage3.progress        (Number, 0-32)
demeter.stage3.claimed         (Boolean)
demeter.stage4.wheat           (Number, 0-20000)
demeter.stage4.feed            (Number, 0-1000)
demeter.stage4.claimed         (Boolean)
demeter.stage5.completed       (Boolean - set when emblem traded)
demeter.stage5.claimed         (Boolean)
demeter.feed_cooldown          (2s expiring - Verdant Feed spam prevention)
```

### Heracles Flags
```
heracles.stage1.progress       (Number, 0-250)
heracles.stage1.claimed        (Boolean)
heracles.stage2.progress       (Number, 0-15)
heracles.stage2.claimed        (Boolean)
heracles.stage3.progress       (Number, 0-8)
heracles.stage3.claimed        (Boolean)
heracles.stage4.progress       (Number, 0-800)
heracles.stage4.claimed        (Boolean)
heracles.stage5.completed      (Boolean - set when emblem traded)
heracles.stage5.claimed        (Boolean)
heracles.is_raid_mob           (Entity flag - marks raiders from raid waves)
```

### Shared Flags
```
met_promachos                  (Boolean - NPC introduction completed)
```

---

## Event Tracking

### Hephaestus Events

| Event | Stage | Conditions | Action |
|-------|-------|------------|--------|
| `after player breaks iron_ore\|deepslate_iron_ore` | 1 | Not silk touch, stage not claimed | Increment progress |
| `on player kills iron_golem` | 2 | Stage 1 claimed, stage 2 not claimed | Increment progress |
| NPC trade (ember) | 3 | Stage 2 claimed, stage 3 not claimed | Increment progress |
| `after player breaks deepslate_iron_ore` | 4 | Hammer equipped, stage 3 claimed, not silk touch | Increment + 0.5% shard drop |

### Demeter Events

| Event | Stage | Conditions | Action |
|-------|-------|------------|--------|
| `after player breaks wheat` | 1 | Age 7, stage not claimed | Increment progress |
| `after cow breeds` | 2 | Breeder is player, stage 1 claimed | Increment progress |
| NPC trade (sheaf) | 3 | Stage 2 claimed, stage 3 not claimed | Increment progress |
| `after player breaks wheat` | 4 | Age 7, stage 3 claimed | Increment wheat count |
| `on player right clicks cow with:verdant_feed` | 4 | Adult cow, stage 3 claimed, no cooldown | Spawn baby, 1% seed drop, increment feed |

### Heracles Events

| Event | Stage | Conditions | Action |
|-------|-------|------------|--------|
| `on player kills pillager` | 1 | No `from_spawner` flag, stage not claimed | Increment progress |
| `after raid finishes` | 2 | Player in winners list, stage 1 claimed | Increment progress per winner |
| NPC trade (mark) | 3 | Stage 2 claimed, stage 3 not claimed | Increment progress |
| `on player kills pillager\|vindicator\|evoker\|ravager\|vex` | 4 | Has `is_raid_mob` flag, Lionfang equipped | Increment + 1.5% mark drop |
| `after raid spawns wave` | - | Always | Flag all new raiders with `heracles.is_raid_mob` |

### Server Announcements
| Trigger | Message Format |
|---------|----------------|
| Stage 1-4 complete | `[Promachos] PlayerName has completed EmblemName stage X!` |
| Stage 5 complete | Same + `ui_toast_challenge_complete` sound to all players |

---

## NPC Trading (Promachos)

### Resources Menu

| Trade | Unlock | Cost | Reward | Stage Progress |
|-------|--------|------|--------|----------------|
| Ember | Hephaestus Stage 2 | 100 Iron Ingots | 1 Hephaestian Ember | Stage 3 |
| Sheaf | Demeter Stage 2 | 128 Wheat | 1 Sheaf of Abundance | Stage 3 |
| Verdant Feed | Demeter Stage 3 | 1 Sheaf | 32 Verdant Feed | None |
| Mark of Conquest | Heracles Stage 2 | 128 Emeralds | 1 Mark of Conquest | Stage 3 |

### Emblems Menu

**Forgeheart Emblem** (Requires Hephaestus Stage 4)
- 20 Hephaestian Embers
- 50 Iron Blocks
- 20 Molten Shards
- 1 Nether Star

**Verdant Oath Emblem** (Requires Demeter Stage 4)
- 64 Sheaves of Abundance
- 20 Seeds of Renewal
- 64 Hay Bales
- 1 Nether Star

**Trial of Might Emblem** (Requires Heracles Stage 4)
- 8 Marks of Conquest
- 20 Marks of Might
- 3 Totems of Undying
- 9 Emerald Blocks
- 1 Nether Star

### Trade Completion
- First purchase sets `emblem.stage5.completed` flag
- Triggers NPC dialogue sequence (3 narrates with waits)
- Announces to server with sound
- Can purchase multiple emblems after first completion

---

## Crafting Recipes

### Hammer of the Flame
```
[Ember] [Ember] [Ember]
[     ] [Block] [     ]
[     ] [Block] [     ]
```
- **Unlock:** Hephaestus Stage 2 claimed
- **Ingredients:** 3 Hephaestian Embers, 2 Diamond Blocks
- **Gate Event:** `on player crafts hammer_of_the_flame`

### Lionfang Blade
```
[     ] [Mark ] [     ]
[Block] [Mark ] [Block]
[     ] [Blaze] [     ]
```
- **Unlock:** Heracles Stage 2 claimed
- **Ingredients:** 2 Marks of Conquest, 2 Diamond Blocks, 1 Blaze Rod
- **Gate Event:** `on player crafts lionfang_blade`

### Recipe Viewer
- Right-click Hephaestian Ember to open recipe viewer GUI
- Shows visual crafting layout

---

## Commands

### Player Commands
| Command | Description |
|---------|-------------|
| `/profile` | Opens the player profile GUI with emblem access |

### Admin Commands (OP only)

| Command | Action | Description |
|---------|--------|-------------|
| `/[emblem]admin complete <player> <stage>` | complete | Set progress to max AND claim stage |
| `/[emblem]admin claim <player> <stage>` | claim | Set progress to max, leave unclaimed (ready to claim) |
| `/[emblem]admin lock <player> <stage>` | lock | Remove all progress and claimed status |
| `/[emblem]admin reset <player>` | reset | Wipe all emblem flags for player |

Where `[emblem]` is: `hephadmin`, `demeteradmin`, or `heraclesadmin`

---

## Adding New Emblems

### Checklist

1. **emblem_items.dsc** - Add items:
   - [ ] Currency item (MORTAL MATERIAL)
   - [ ] Tool/weapon item (MORTAL, with recipe if applicable)
   - [ ] Rare drop item (HEROIC MATERIAL)
   - [ ] Emblem item (LEGENDARY EMBLEM)
   - [ ] GUI icon (for emblem selection)
   - [ ] Locked stage placeholder (gray_dye)

2. **emblem_guis.dsc** - Add GUI components:
   - [ ] Progress inventory (45 slots)
   - [ ] `open_[emblem]_gui` task
   - [ ] Stage info items (5 items, materials match theme)
   - [ ] `get_[emblem]_stage_info` procedure
   - [ ] `get_[emblem]_stage_pane` procedure

3. **emblem_events.dsc** - Add event handlers:
   - [ ] Navigation events (icon click, back button)
   - [ ] Yellow pane click handler (claim stages)
   - [ ] Progress tracking events for each stage
   - [ ] `[emblem]_claim_stage` task

4. **emblem_recipes.dsc** - Add crafting:
   - [ ] Recipe viewer GUI (if applicable)
   - [ ] Crafting gate event

5. **promachos_npc.dsc** - Add NPC trades:
   - [ ] Trade display items
   - [ ] Add slots to `open_promachos_resources` task
   - [ ] Add slots to `open_promachos_emblems` task
   - [ ] Trade click handlers

6. **emblem_admin.dsc** - Add admin command:
   - [ ] Command script with complete/claim/lock/reset
   - [ ] Helper tasks for each action

7. **emblem_guis.dsc** - Update selection menu:
   - [ ] Add new icon to `emblem_selection_inventory` slots

### Naming Conventions
- Items: `[emblem]_item_name` (e.g., `hephaestian_ember`)
- GUIs: `[emblem]_progress_inventory`
- Tasks: `open_[emblem]_gui`, `[emblem]_claim_stage`
- Procedures: `get_[emblem]_stage_info`, `get_[emblem]_stage_pane`
- Flags: `[emblem].stageN.progress`, `[emblem].stageN.claimed`
- Admin: `[emblem]admin` or `[short]admin` (e.g., `hephadmin`)

### Stage Requirements Pattern
```yaml
# Standard pattern for tracking
- if !<player.has_flag[emblem.stageN-1.claimed]>:  # Previous stage check
    - stop
- if <player.has_flag[emblem.stageN.claimed]>:     # Already claimed check
    - stop
- flag player emblem.stageN.progress:++
- if <player.flag[emblem.stageN.progress]> == REQUIRED:
    - announce "[Promachos] PlayerName has completed EmblemName stage N!"
```

### Claim Task Pattern
```yaml
[emblem]_claim_stage:
    type: task
    definitions: stage
    script:
    - if <player.has_flag[emblem.stage<[stage]>.claimed]>:
        - narrate "<&7>You have already claimed this reward."
        - stop
    - choose <[stage]>:
        - case 1:
            - if <player.flag[emblem.stage1.progress].if_null[0]> < REQUIRED:
                - narrate "<&c>You haven't completed this stage yet!"
                - stop
            - define xp 100
        # ... cases 2-5
    - flag player emblem.stage<[stage]>.claimed:true
    - experience give <[xp]>
    - narrate "<&e>[Promachos] <&f>Stage <&e><[stage]> <&f>claimed! <&e>+<[xp]> XP"
    - playsound <player> sound:entity_player_levelup
```
