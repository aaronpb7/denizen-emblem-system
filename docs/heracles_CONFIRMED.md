# Heracles Combat System - CONFIRMED Design Decisions

## ✅ CONFIRMED: Components (Emblem Unlock Activities)

### Activity 1: Pillager Slayer
- **Milestone**: 2,500 pillagers killed → Component unlocked
- **Key rate**: 1 key per 100 pillagers (25 keys total)
- **Tracking**: `heracles.pillagers.count`
- **Component flag**: `heracles.component.pillagers`

### Activity 2: Raid Victor
- **Milestone**: 50 raids completed → Component unlocked
- **Key rate**: 2 keys per raid (100 keys total)
- **Tracking**: `heracles.raids.count`
- **Component flag**: `heracles.component.raids`

### Activity 3: Trade Master
- **Milestone**: 10,000 emeralds spent → Component unlocked
- **Key rate**: 1 key per 100 emeralds (100 keys total)
- **Tracking**: `heracles.emeralds.count`
- **Component flag**: `heracles.component.emeralds`

**Total keys from components: 225 keys**

---

## ✅ CONFIRMED: Rank XP Rates

### Hostile Mob Kills (Combat XP)

| Mob Type | XP Awarded |
|----------|------------|
| **Common** (Zombie, Skeleton, Spider, Creeper, Cave Spider, Silverfish) | 2 XP |
| **Uncommon** (Enderman, Witch, Blaze, Ghast, Piglin Brute, Hoglin) | 5 XP |
| **Pillager** | 5 XP |
| **Rare** (Vindicator, Evoker, Ravager, Wither Skeleton) | 8 XP |
| **Elite** (Elder Guardian, Guardian) | 15 XP |

**Notes:**
- Phantoms excluded (disabled on server)
- Pillagers reduced to 5 XP (easy to farm)

### Raid Completion (Combat XP)

| Raid Level | XP Awarded |
|------------|------------|
| Level 1 (Bad Omen I) | 50 XP |
| Level 2 (Bad Omen II) | 75 XP |
| Level 3 (Bad Omen III) | 100 XP |
| Level 4 (Bad Omen IV) | 150 XP |
| Level 5 (Bad Omen V) | 200 XP |

**Event**: `on raid finishes` with `<context.raid.level>`

### Emerald Trading (Combat XP)

| Activity | XP Awarded |
|----------|------------|
| Per Emerald Spent | 1 XP |

---

## ✅ CONFIRMED: Rank Buffs

| Rank | XP Required | Low Health Regen | Vanilla XP Bonus | Keys |
|------|-------------|------------------|------------------|------|
| **Acolyte of War** | 1,000 | Regen I (5s, 3min CD) | +5% experience orbs | 5 keys |
| **Disciple of War** | 3,500 | Regen I (5s, 3min CD) | +10% experience orbs | 5 keys |
| **Hero of War** | 9,750 | Regen II (5s, 3min CD) | +15% experience orbs | 5 keys |
| **Champion of War** | 25,375 | Regen II (5s, 3min CD) | +20% experience orbs | 5 keys |
| **Legend of War** | 64,438 | Regen II (5s, 3min CD) | +25% experience orbs | 10 keys |

**Buff Details:**

### Low Health Regeneration
- **Trigger**: When health drops below 6 HP (3 hearts)
- **Effect**: Regeneration I or II for 5 seconds
- **Cooldown**: 3 minutes (180 seconds)
- **Ranks 1-2**: Regen I
- **Ranks 3-5**: Regen II

### Vanilla XP Bonus
- **Type**: Bonus to Minecraft experience orbs (for enchanting)
- **Application**: When killing mobs, multiply dropped XP by bonus
- **Example at Rank 5**: Zombie drops 5 XP × 1.25 = 6.25 XP

---

## ✅ CONFIRMED: Crate Loot Tables

### MORTAL Tier (56% - 7 items)

| Item | Quantity |
|------|----------|
| Arrow | 8 |
| Gunpowder | 4 |
| Bread | 8 |
| Iron Ingot | 4 |
| Emerald | 8 |
| Bone | 16 |
| Leather | 4 |

### HEROIC Tier (26% - 5 items)

| Item | Quantity |
|------|----------|
| Golden Carrot | 8 |
| Emerald | 16 |
| Gold Block | 1 |
| Experience | 100 XP |
| Ender Pearl | 2 |

### LEGENDARY Tier (12% - 4 items)

| Item | Quantity |
|------|----------|
| Golden Apple | 2 |
| Heracles Key | 2 |
| Emerald Block | 6 |
| Experience | 250 XP |

### MYTHIC Tier (5% - 6 items)

| Item | Quantity |
|------|----------|
| Enchanted Golden Apple | 1 |
| Heracles Sword | 1 (custom) |
| Heracles Blessing | 1 (custom) |
| Heracles Title | 1 (custom) |
| Gold Block | 16 |
| Emerald Block | 16 |

### OLYMPIAN Tier (1% - 1 item)

| Item | Quantity |
|------|----------|
| Mars Key | 1 (custom) |

---

## ✅ CONFIRMED: Custom Items

### Heracles Sword (MYTHIC)

**Material**: Diamond Sword

**Display Name**: `<&c><&l>HERACLES SWORD<&r>`

**Lore**:
```
<&c>MYTHIC

<&7>A diamond blade blessed by
<&7>Heracles, unbreakable and eternal.

<&8>Unbreakable
```

**NBT**:
- Unbreakable: true
- Enchantment: mending:1 (hidden, for glint)

**Mechanics**: Cosmetic prestige item (no special abilities)

---

### Heracles Blessing (MYTHIC)

**Material**: Enchanted Book

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

**Boost Amounts**:
- Pillagers: +250 (10% of 2,500)
- Raids: +5 (10% of 50)
- Emeralds: +1,000 (10% of 10,000)

**Flag**: `heracles.item.blessing` (tracks ownership for Mars crate)

---

### Heracles Title (MYTHIC)

**Type**: Flag-based cosmetic unlock (not physical item)

**Flag**: `heracles.item.title: true`

**Title Text**: `<&4>[Hero of Olympus]<&r>`

**Display**: Chat prefix

**Example**:
```
<&4>[Hero of Olympus]<&r> PlayerName: Hello!
```

---

## ✅ CONFIRMED: Mars Meta-Progression

### Mars Crate System
- **Source**: 1% drop from Heracles OLYMPIAN tier
- **Logic**: 50/50 system (god apple vs unique item)
- **Pool**: 4 unique items (one-time unlocks per player)
- **Color Theme**: Dark red/crimson border (matching Heracles)

### Mars Unique Items (4 total)

#### 1. Mars Sword (MYTHIC)

**Material**: Netherite Sword

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
- Lifesteal: Heals player for 10% of damage dealt
- Event: `after player damages entity with:mars_sword`
- Flag: `mars.item.sword`

---

#### 2. Mars Title (COSMETIC)

**Type**: Flag-based cosmetic unlock (not physical item)

**Flag**: `mars.item.title: true`

**Title Text**: `<&4>[Mars' Chosen]<&r>`

**Display**: Chat prefix

**Example**:
```
<&4>[Mars' Chosen]<&r> PlayerName: Hello!
```

---

#### 3. Gray Shulker Box (UTILITY)

**Material**: Gray Shulker Box

**Display Name**: `<&8>Gray Shulker Box<&r>`

**Lore**:
```
<&7>A rare shulker box from
<&7>the Arena of Champions.

<&8>Standard shulker box
<&8>Unique - One per player
```

**Mechanics**: Standard shulker box (no special abilities)

**Flag**: `mars.item.shulker`

---

#### 4. Mars Shield (LEGENDARY)

**Material**: Shield

**Display Name**: `<&4><&l>MARS SHIELD<&r>`

**Lore**:
```
<&4>MYTHIC

<&7>A shield blessed by Mars,
<&7>granting divine protection.

<&e>Right-click to activate
<&e>Resistance I for 15 seconds

<&8>Cooldown: 3 minutes
<&8>Unbreakable
<&8>Unique - One per player
```

**Mechanics**:
- Active ability: Right-click grants Resistance I (amplifier 0) for 15 seconds
- Cooldown: 3 minutes (180 seconds)
- Event: `on player right clicks block with:mars_shield`
- Flag: `mars.item.shield`
- Cooldown flag: `mars.shield_cooldown` (expires after 180s)

---

## 🔄 REMAINING TASKS

### 1. GUI Updates
- Profile GUI - Heracles section layout
- Promachos role selection - Combat button text
- Emblem check GUI - Heracles icon/progress

### 2. Implementation Details
- Event handlers (pillager kills, raid completion, trading)
- Rank buff mechanics (regen trigger, XP multiplier)
- Crate animation (reuse Demeter pattern with dark red theme)
- Blessing consumption logic
- Mars crate 50/50 logic (reuse Ceres pattern)

---

## Design Principles (Confirmed)

1. **Mirror Demeter Structure**: Same 3 components, same rank curve, same crate tiers
2. **Combat/Village Theme**: Pillagers, raids, trading (not generic monster killing)
3. **Balanced Power**: Crate loot matches Demeter's value tier-for-tier
4. **Cosmetic Prestige**: Main custom items are cosmetic (like Demeter Hoe)
5. **Utility Buffs**: Ranks give survival (regen) + economy (XP bonus)

---

## Next Steps

1. ✅ ~~Choose Heracles title text~~ - **DONE**: `<&4>[Hero of Olympus]<&r>`
2. ✅ ~~Design Mars meta-progression (4 items)~~ - **DONE**: Sword, Title, Gray Shulker, Shield
3. Plan GUI updates
4. Create implementation files structure
5. Write complete specification document (heracles.md)

---

**Last Updated**: Design finalization session
**Status**: ✅ ALL DESIGN DECISIONS CONFIRMED. Ready for complete specification document and implementation.
