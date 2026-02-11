# Hephaestus - HEPHAESTUS Emblem

God of the Forge, fire, metalworking, and craftsmanship.

---

## Implementation Status

### Scripts to Create
- [x] `hephaestus_events.dsc` - Activity tracking
- [x] `hephaestus_crate.dsc` - Crate system
- [x] `hephaestus_blessing.dsc` - Blessing item
- [x] `vulcan_crate.dsc` - Meta crate
- [x] `vulcan_items.dsc` - Meta items

### Scripts to Update
- [x] `promachos.dsc` - System info, emblem check
- [x] `profile_gui.dsc` - Emblem display, progress GUI
- [x] `emblem_data.dsc` - Emblem procedures
- [x] `admin_commands.dsc` - Admin commands

---

## Core Identity

| Property | Value |
|----------|-------|
| Emblem | HEPHAESTUS |
| Greek God | Hephaestus |
| Roman God | Vulcan |
| Display Name | Hephaestus |
| Color Code | `<&8>` dark gray |
| Emblem Icon | `iron_pickaxe` |
| Crate Border | `gray_stained_glass_pane` |

---

## Three Activities

Iron-themed progression loop:

| # | Activity | Event | Key Threshold | Component Milestone |
|---|----------|-------|---------------|---------------------|
| 1 | Mine iron ore | Break iron_ore/deepslate_iron_ore | 50 | 5,000 |
| 2 | Smelt in blast furnace | Take item from blast furnace | 50 | 5,000 |
| 3 | Create iron golems | Golem spawns near player | 1 | 100 |

**Design Notes:**
- Iron-focused theme ties all activities together
- Blast furnace only (not regular furnace) - fits forge theme
- Golems are expensive (36 iron + pumpkin) so 1:1 key ratio
- Each milestone = 100 keys worth of activity

---

## Crate Loot

### MORTAL (56% / 55% with emblem)
| Item | Quantity |
|------|----------|
| cobblestone | 16 |
| coal | 8 |
| raw_iron | 4 |
| copper_ingot | 4 |
| emerald | 8 |
| bone_meal | 16 |
| flint | 8 |

### HEROIC (26%)
| Item | Quantity |
|------|----------|
| golden_carrot | 8 |
| emerald | 16 |
| gold_block | 1 |
| experience | 100 |
| lapis_block | 2 |

### LEGENDARY (12%)
| Item | Quantity |
|------|----------|
| golden_apple | 2 |
| hephaestus_key | 2 |
| emerald_block | 6 |
| experience | 250 |

### MYTHIC (5%)
| Item | Quantity |
|------|----------|
| enchanted_golden_apple | 1 |
| hephaestus_pickaxe | 1 |
| hephaestus_blessing | 1 |
| hephaestus_title | 1 |
| gold_block | 16 |
| emerald_block | 16 |

### MYTHIC Pool Addition: Hephaestus Mythic Fragment

The Hephaestus base crate MYTHIC tier can also drop a **Hephaestus Mythic Fragment** — a crafting ingredient used in the Mythic Forge system. Players combine 4 fragments with a Vulcan Pickaxe Blueprint and 4 Diamond Blocks to forge a Vulcan Pickaxe.

### OLYMPIAN (1% / 2% with emblem)
| Item | Quantity |
|------|----------|
| vulcan_key | 1 |

---

## Special Items

### Hephaestus Blessing
One-time consumable that adds 10% to all incomplete component milestones:
- Iron ore: +500 (10% of 5,000)
- Blast furnace: +500 (10% of 5,000)
- Iron golems: +10 (10% of 100)

Caps at milestone, triggers key awards and component checks.

### Hephaestus Pickaxe
Unbreakable diamond pickaxe (matches Demeter Hoe / Heracles Sword pattern).

### Hephaestus Title
Grants chat prefix: `[Master Smith]`

---

## Item Lore Format

All special items follow this lore pattern:
```
<&7>Description line 1
<&7>Description line 2
<empty>
<&8>Feature (e.g., Unbreakable)
<empty>
<&d><&l>MYTHIC [TYPE]
```

Display names use: `<&d>Item Name<&r>` (magenta/purple)

---

## Vulcan Meta Items

| # | Item | Material | Effect |
|---|------|----------|--------|
| 1 | Vulcan Pickaxe | `netherite_pickaxe` | Unbreakable, right-click toggles auto-smelt (iron/gold ore only) |
| 2 | Vulcan Title | `name_tag` | Grants `[Vulcan's Chosen]` chat prefix |
| 3 | Head of Hephaestus | `player_head` | Decorative collectible |
| 4 | Gray Shulker Box | `gray_shulker_box` | Portable storage |
