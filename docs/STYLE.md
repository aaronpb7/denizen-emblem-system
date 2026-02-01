# Emblem System - Style Guide

Reference for colors, sounds, message patterns, and UI conventions used throughout the emblem system.

---

## Color Codes

### Role Colors
| Role | Primary | Light | Usage |
|------|---------|-------|-------|
| FARMING | `<&6>` gold | `<&e>` yellow | Demeter, Ceres |
| MINING | `<&c>` red | `<&c>` red | Hephaestus, Vulcan |
| COMBAT | `<&4>` dark red | `<&c>` red | Heracles, Mars |

### Tier Colors (Crates)
| Tier | Color | Code |
|------|-------|------|
| MORTAL | White | `<&f>` |
| HEROIC | Yellow | `<&e>` |
| LEGENDARY | Gold | `<&6>` |
| MYTHIC | Pink | `<&d>` |
| OLYMPIAN | Cyan | `<&b>` |

### UI Colors
| Purpose | Code | Example |
|---------|------|---------|
| Description text | `<&7>` | Gray |
| Meta/notes | `<&8>` | Dark gray |
| Success/positive | `<&a>` | Green |
| Error/warning | `<&c>` | Red |
| Highlight | `<&e>` | Yellow |
| Special/divine | `<&d>` | Pink |

### Crate Border Materials
| Crate | Border |
|-------|--------|
| Demeter | `yellow_stained_glass_pane` |
| Heracles | `red_stained_glass_pane` |
| Ceres | `cyan_stained_glass_pane` |
| Mars | `red_stained_glass_pane` |

---

## Sound Cues

### Activity Rewards
| Event | Sound | Notes |
|-------|-------|-------|
| Key awarded | `entity_experience_orb_pickup` | Single key drop |
| Component/milestone | `ui_toast_challenge_complete` | Major achievement |
| Rank up | `ui_toast_challenge_complete` | + totem effect |

### Crate System
| Event | Sound | Notes |
|-------|-------|-------|
| Crate open | `block_chest_open` | When animation starts |
| Scroll tick | `ui_button_click` | Pitch varies: 1.5 → 1.2 → 0.9 |
| MORTAL drop | `entity_item_pickup` | |
| HEROIC drop | `entity_player_levelup` | |
| LEGENDARY drop | `block_enchantment_table_use` | |
| MYTHIC drop | `ui_toast_challenge_complete` | |
| OLYMPIAN drop | `ui_toast_challenge_complete` + `entity_ender_dragon_growl` | Epic combo |

### Item Abilities
| Event | Sound | Notes |
|-------|-------|-------|
| Ability activated | `block_beacon_activate` | Divine power |
| Cooldown ready | `block_note_block_chime` | Soft notification |
| Action denied | `entity_villager_no` | Error/cooldown |
| Blessing used | `block_enchantment_table_use` | Consumable |

### Emblem Unlock
| Event | Sound | Notes |
|-------|-------|-------|
| Emblem unlock | `ui_toast_challenge_complete` + `entity_ender_dragon_growl` | Epic moment |
| Server announce | `ui_toast_challenge_complete` at 0.5 volume | All players |

---

## Message Patterns

### Key Award
```
<&ROLE_COLOR><&l>GOD KEY!<&r> <&7>Activity: <&a>count<&7>/goal
```
Examples:
- `<&e><&l>DEMETER KEY!<&r> <&7>Wheat: <&a>1,500<&7>/15,000`
- `<&c><&l>HERACLES KEY!<&r> <&7>Pillagers: <&a>500<&7>/2,500`

### Milestone/Component
```
<&ROLE_DARK><&l>MILESTONE!<&r> <&ROLE_LIGHT>Component Name obtained! <&7>(requirement)
```
Examples:
- `<&6><&l>MILESTONE!<&r> <&e>Wheat Component obtained! <&7>(15,000 wheat)`
- `<&4><&l>MILESTONE!<&r> <&c>Pillager Slayer Component obtained! <&7>(2,500 pillagers)`

### Bonus Keys (Blessing)
```
<&ROLE_COLOR><&l>BONUS KEYS!<&r> <&7>+count God Keys (Activity)
```
Examples:
- `<&e><&l>BONUS KEYS!<&r> <&7>+10 Demeter Keys (Wheat)`
- `<&c><&l>BONUS KEYS!<&r> <&7>+5 Heracles Keys (Raids)`

### Blessing Activated
```
<&d><&l>GOD BLESSING ACTIVATED!<&r>
  <&ROLE_COLOR>Activity<&7>: +amount (old → new)
```

### All Activities Complete
```
<&ROLE_COLOR>All God activities already complete!
```

---

## Server Announcements

### Component Obtained
```
<&ROLE_COLOR>[Promachos]<&r> <&f>PlayerName <&7>has obtained the <&ROLE_COLOR>Component Name<&7>!
```

### Rank Achieved
```
<&ROLE_COLOR>[Promachos]<&r> <&f>PlayerName <&7>has achieved <&ROLE_COLOR>Rank Name<&7>!
```

### Emblem Unlocked (Bold prefix)
```
<&ROLE_COLOR><&l>[Promachos]<&r> <&f>PlayerName <&7>has unlocked the <&ROLE_COLOR><&l>Emblem of God<&7>!
```

### Olympian Drop
```
<&ROLE_COLOR><&l>OLYMPIAN DROP!<&r> <&f>PlayerName <&7>obtained a unique God item<&co> <&d>ItemName<&7>!
```

---

## NPC Dialogue

### Promachos Speech Pattern
```
<&e><&l>Promachos<&r><&7>: Message here.
```
- Always yellow/gold prefix
- Formal but encouraging tone
- References Greek mythology

---

## Title/Subtitle Patterns

### Standard Timing
```
fade_in:5t stay:40t fade_out:10t
```

### Ceremony Timing (longer)
```
fade_in:10t stay:70t fade_out:20t
```

### Crate Drop
```
title:<&TIER_COLOR><&l>TIER DROP
subtitle:<&f>Item Name
```

### Rank Up
```
title:<&ROLE_COLOR><&l>ROLE RANK UP!
subtitle:<&ROLE_LIGHT>Rank Name
```

### Emblem Unlock
```
title:<&ROLE_COLOR><&l>EMBLEM UNLOCKED!
subtitle:<&ROLE_LIGHT>God's Blessing/Favor
```

---

## Ceremony Chat Box

### Rank Up Ceremony
```
<&ROLE_COLOR>━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
<&ROLE_LIGHT><&l>SYMBOL ROLE RANK ACHIEVED SYMBOL
<&7>You have become<&co> <&ROLE_COLOR>Rank Name

<&b>Rewards Unlocked:
<&7>• <&f>Buff Name: <&e>Value
<&7>• <&f>Rank Reward: <&e>X Keys
<&ROLE_COLOR>━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Symbols by role:
- FARMING: `⚜` (fleur-de-lis)
- COMBAT: `⚔` (crossed swords)
- MINING: `⛏` (pickaxe) - suggested

---

## Item Lore Structure

### Standard Item
```yaml
lore:
- <&7>Description line 1
- <&7>Description line 2
- <empty>
- <&e>Effect/usage instructions
- <&e>Second effect line (optional)
- <empty>
- <&8>Note (Single-use, Unbreakable, etc.)
- <&8>Second note (optional)
- <empty>
- <&d><&l>RARITY LABEL
```

### Rarity Labels
| Rarity | Label | Color |
|--------|-------|-------|
| Common Key | `HEROIC KEY` | `<&e><&l>` |
| Component | `LEGENDARY COMPONENT` | `<&6><&l>` |
| Blessing | `MYTHIC CONSUMABLE` | `<&d><&l>` |
| Tool | `MYTHIC HOE/SWORD` | `<&d><&l>` |
| Olympian | `OLYMPIAN KEY/ITEM` | `<&b><&l>` |

---

## Action Bar Patterns

### Ability Activated
```
<&ROLE_COLOR>ABILITY NAME <&7>- <&e>Effect description
```
Examples:
- `<&4>MARS' PROTECTION <&7>- <&c>Resistance I for 15s`
- `<&b>CERES' BEES <&7>- <&e>6 bees summoned for 30s`

### Cooldown Ready
```
<&a>Item Name ready!
```

### XP Gained (Farming)
```
<&6>+amount Farming XP <&8>| <&7>Source
```

---

## GUI Conventions

### Slot Layout (27-slot crate GUI)
```
[B][B][B][B][B][B][B][B][B]  ← Border row (1-9)
[B][B][1][2][3][4][5][B][B]  ← Scroll area (12-16)
[B][B][B][B][B][B][B][B][B]  ← Border row (19-27)
```
- B = Border (colored glass pane)
- 1-5 = Scrolling item slots
- Center slot (14) = Final result

### Filler Items
- Empty slots: `gray_stained_glass_pane` with `display=<&7>`
- Border slots: Role-colored glass pane

---

## Naming Conventions

### Flags
```
god.category.subcategory
```
Examples:
- `demeter.wheat.count`
- `heracles.pillagers.keys_awarded`
- `ceres.item.hoe`

### Script Names
```
god_purpose
```
Examples:
- `demeter_events`
- `heracles_crate_animation`
- `mars_sword_lifesteal`

### Item Scripts
```
god_item_type
```
Examples:
- `demeter_key`
- `heracles_blessing`
- `mars_shield`

---

## Adding New Content

### New Role Checklist
1. Define colors in this guide
2. Create border material choice
3. Choose rank ceremony symbol
4. Follow flag naming: `god.category.subcategory`
5. Mirror existing role message patterns

### New Ability Checklist
1. Action bar on activation (not narrate)
2. Silent fail on cooldown
3. Action bar + chime when cooldown ready
4. Scheduled task for cooldown notification

### New Crate Tier Item
1. Match tier sound from table above
2. Follow lore structure template
3. Use correct rarity label
