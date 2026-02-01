# Hephaestus - Mining Role

God of the Forge, fire, metalworking, and craftsmanship.

---

## Implementation Status

### Scripts to Create
- [x] `hephaestus_events.dsc` - Activity tracking
- [x] `hephaestus_crate.dsc` - Crate system
- [x] `hephaestus_blessing.dsc` - Blessing item
- [x] `hephaestus_ranks.dsc` - XP/rank system
- [x] `vulcan_crate.dsc` - Meta crate
- [x] `vulcan_items.dsc` - Meta items

### Scripts to Update
- [x] `promachos.dsc` - System info, emblem check
- [x] `profile_gui.dsc` - Role display, progress GUI, ranks GUI
- [x] `roles.dsc` - Role procedures
- [x] `admin_commands.dsc` - Admin commands

---

## Core Identity

| Property | Value |
|----------|-------|
| Role | MINING |
| Greek God | Hephaestus |
| Roman God | Vulcan |
| Display Name | Metallourgos |
| Color Code | `<&8>` dark gray |
| Role Icon | `iron_pickaxe` |
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

## Ranks

**Buffs:**
- Haste (faster mining) - applies while mining
- Ore XP Bonus (extra vanilla XP from ores)

| Rank | Title | XP Required | Haste | Ore XP Bonus | Key Reward |
|------|-------|-------------|-------|--------------|------------|
| 1 | Acolyte of the Forge | 1,000 | None | +5% | 5 keys |
| 2 | Disciple of the Forge | 3,500 | Haste I | +10% | 5 keys |
| 3 | Hero of the Forge | 9,750 | Haste I | +15% | 5 keys |
| 4 | Champion of the Forge | 25,375 | Haste I | +20% | 5 keys |
| 5 | Legend of the Forge | 64,438 | Haste II | +25% | 10 keys |

---

## XP Sources

| Action | XP |
|--------|-----|
| Coal ore | 2 |
| Copper ore | 2 |
| Nether quartz ore | 2 |
| Iron ore | 3 |
| Nether gold ore | 3 |
| Lapis ore | 4 |
| Redstone ore | 4 |
| Gold ore | 5 |
| Diamond ore | 10 |
| Emerald ore | 10 |
| Ancient debris | 20 |
| Blast furnace smelt | 1 |
| Iron golem created | 25 |

---

## Crate Loot

### MORTAL (56%)
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

### OLYMPIAN (1%)
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
| 3 | Vulcan Forge Charm | `magma_cream` or `blaze_powder` | Hold in offhand for fire resistance + light particles |
| 4 | Gray Shulker Box | `gray_shulker_box` | Portable storage |
