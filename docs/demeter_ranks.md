# Farming Skill Ranks - Complete Specification

## Overview

The **Farming Skill Rank System** is an **XP-based progression system** that rewards farming activity with **permanent passive buffs**.

Unlike Demeter components (which are activity counters for emblem unlocking), ranks provide **ongoing gameplay benefits** that enhance farming efficiency as players gain experience.

**Key Design Principle**: Ranks are **generic skill progression**, not tied to any specific emblem. They represent mastery of the FARMING role itself.

---

## Rank Tiers

Players progress through **5 ranks** by earning **Farming XP** through various farming activities:

| Rank | XP Required (Total) | XP for This Rank | Crop Bonus | Speed Bonus | Key Reward |
|------|---------------------|------------------|------------|-------------|------------|
| **Acolyte of the Farm** | 1,000 | 1,000 | +5% | None | 5 keys |
| **Disciple of the Farm** | 3,500 | 2,500 | +10% | Speed I | 5 keys |
| **Hero of the Farm** | 9,750 | 6,250 | +15% | Speed I | 5 keys |
| **Champion of the Farm** | 25,375 | 15,625 | +20% | Speed I | 5 keys |
| **Legend of the Farm** | 64,438 | 39,063 | +25% | Speed II | 10 keys |

**XP Scaling**: Each rank requires approximately **2.5x more XP** than the previous rank's increment (exponential progression).

---

## XP Award Rates

### Crop Harvesting (Fully Grown Only)

Harvest fully-grown crops while FARMING role is active:

| Crop | XP Awarded |
|------|------------|
| Wheat, Carrots, Potatoes, Beetroots | 2 XP |
| Pumpkin, Melon | 5 XP |
| Nether Wart | 3 XP |
| Cocoa | 1 XP |
| Sugar Cane, Cactus, Kelp, Bamboo | 1 XP |

**Conditions**:
- Must have `role.active = FARMING`
- Crops with age property must be fully grown (age 7 for wheat/carrots/potatoes/beetroots, age 3 for nether wart, age 2 for cocoa)
- Partially grown crops award NO XP

---

### Animal Breeding

Breed animals while FARMING role is active:

| Animal | XP Awarded |
|--------|------------|
| Horse | 30 XP |
| Turtle | 20 XP |
| Llama, Hoglin | 12 XP |
| Cow, Sheep, Pig | 10 XP |
| Rabbit, Bee | 8 XP |
| Chicken | 6 XP |

**Conditions**:
- Must have `role.active = FARMING`
- Breeder must be a player (not dispenser)
- Both parents must be adults

---

### Food Crafting

Craft food items while FARMING role is active:

| Food | XP Awarded |
|------|------------|
| Rabbit Stew | 15 XP |
| Cake | 12 XP |
| Pumpkin Pie | 10 XP |
| Suspicious Stew | 8 XP |
| Beetroot Soup | 6 XP |
| Mushroom Stew | 4 XP |

**Conditions**:
- Must have `role.active = FARMING`
- XP multiplied by craft quantity (shift-clicking bulk crafts uses `<context.amount>`)

---

## Rank Rewards

### Acolyte of the Farm (1,000 XP)

**Bonuses:**
- **+5% Extra Crop Output**
  - 5% chance to drop an extra wheat when harvesting fully-grown wheat
  - Triggers happy villager particles on proc
- **5 Demeter Keys** awarded on rank-up

**First Milestone**: Unlocks the extra crop mechanic

---

### Disciple of the Farm (3,500 XP)

**Bonuses:**
- **+10% Extra Crop Output**
  - 10% chance to drop an extra wheat
- **Farming Speed I** (Haste I effect)
  - Applies for 5 seconds when breaking any crop
  - Makes harvesting noticeably faster
- **5 Demeter Keys** awarded on rank-up

**Major Power Spike**: Farming speed buff begins

---

### Hero of the Farm (9,750 XP)

**Bonuses:**
- **+15% Extra Crop Output**
  - 15% chance to drop an extra wheat
- **Farming Speed I** (Haste I effect)
  - Same as Disciple tier
- **5 Demeter Keys** awarded on rank-up

**Steady Progression**: Incremental improvement

---

### Champion of the Farm (25,375 XP)

**Bonuses:**
- **+20% Extra Crop Output**
  - 20% chance (1 in 5) to drop an extra wheat
- **Farming Speed I** (Haste I effect)
  - Same as previous tiers
- **5 Demeter Keys** awarded on rank-up

**Advanced Farmer**: Significant yield bonus

---

### Legend of the Farm (64,438 XP)

**Bonuses:**
- **+25% Extra Crop Output**
  - 25% chance (1 in 4) to drop an extra wheat
- **Farming Speed II** (Haste II effect)
  - Applies for 5 seconds when breaking any crop
  - Significantly faster harvesting
- **10 Demeter Keys** awarded on rank-up

**Master Farmer**: Maximum efficiency, double key reward

---

## Rank-Up Ceremony

When a player crosses an XP threshold to achieve a new rank:

### Visual Effects
- **Particle burst:** 50 villager_happy particles + 30 composter particles at player location
- **Sound:** `UI_TOAST_CHALLENGE_COMPLETE`
- **Title announcement:** "FARMING RANK UP!" with rank name subtitle (70t display)

### Chat Announcement
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚜ FARMING RANK ACHIEVED ⚜
You have become: Acolyte of the Farm

Rewards Unlocked:
• Extra Crop Chance: +5%
• Rank Reward: 5 Demeter Keys
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Server Announcement
```
[Promachos] PlayerName has achieved Acolyte of the Farm!
```

### Rewards
- Demeter Keys given directly to inventory
- Rank flag updated immediately
- Buffs apply on next farming activity

---

## XP Gain Feedback

Every time a player earns Farming XP, they receive an **action bar notification**:

```
+2 Farming XP | Wheat
+10 Farming XP | Cow
+12 Farming XP | Cake
```

**Format**: `+[amount] Farming XP | [activity]`

**Benefits**:
- Clear feedback on XP gains
- Shows what skill is being progressed
- Non-intrusive (action bar, not chat)

---

## Buff Mechanics

### Farming Speed (Haste)

**Trigger:** Breaking any crop (wheat, carrots, potatoes, beetroots, nether_wart, cocoa, pumpkin, melon)

**Effect:**
- Haste I (Ranks 2-4) or Haste II (Rank 5) for 5 seconds
- Effect is invisible (no icon, no particles)

**Conditions:**
- Only applies if `role.active = FARMING`
- Rank must be 2 or higher
- Reapplies on every crop break, effectively maintaining permanent haste while actively farming

**Implementation**: Event handler in `demeter_ranks.dsc` applies potion effect on crop break

---

### Extra Crop Drops

**Trigger:** Breaking fully-grown wheat (age 7)

**Effect:** Drop 1 additional wheat item at break location

**Chance:**
- Rank 1 (Acolyte): 5%
- Rank 2 (Disciple): 10%
- Rank 3 (Hero): 15%
- Rank 4 (Champion): 20%
- Rank 5 (Legend): 25%

**Conditions:**
- Only applies if `role.active = FARMING`
- Only on fully-grown wheat (partially grown crops don't trigger)
- Rank must be 1 or higher

**Visual Feedback:** Happy villager particles at crop location when bonus triggers

**Balance Note:** At Legend rank (25%), players effectively get 125% wheat yield on average (1 + 25% bonus).

---

## Relationship to Components and Emblems

**Ranks and Emblems are completely independent systems:**

| System | Purpose | Requirements | Rewards |
|--------|---------|--------------|---------|
| **Farming Ranks** | Generic skill progression | Earn XP through all farming activities | Permanent passive buffs |
| **Demeter Components** | Emblem-specific milestones | 15k wheat, 2k cows, 500 cakes | Unlock Demeter Emblem |

**Key Differences**:
- Ranks are **XP-based** (cumulative across all activities)
- Components are **counter-based** (specific activity thresholds)
- Ranks provide **gameplay buffs** (speed, extra drops)
- Components provide **emblem unlocking** (cosmetic/progression)
- Ranks are **generic to FARMING role** (not Demeter-specific)
- Components are **Demeter-specific** (tied to goddess)

**Example Progression:**
1. Player earns 1,000 XP (mostly from wheat) → **Acolyte rank** (buffs active)
2. Player reaches 15,000 wheat → **Wheat Component** (emblem 1/3)
3. Player earns 3,500 total XP (wheat + cows + cakes) → **Disciple rank** (stronger buffs)
4. Player reaches 2,000 cows → **Cow Component** (emblem 2/3)
5. Player reaches 500 cakes → **Cake Component** (emblem 3/3)
6. Player earns 9,750 total XP → **Hero rank** (even stronger buffs)
7. Player visits Promachos → **Demeter Emblem unlocked**

**Both systems can progress simultaneously and independently.**

---

## Flag Reference

### Rank Storage
```
farming.rank: <integer>
```
- `0` = Unranked
- `1` = Acolyte
- `2` = Disciple
- `3` = Hero
- `4` = Champion
- `5` = Legend

**Calculated dynamically** from total XP by `get_farming_rank` procedure, called after every XP award.

### XP Storage
```
farming.xp: <integer>
```
- Total Farming XP earned across all activities
- Persists across sessions
- Never decreases

### Relationship to Demeter Flags
```
demeter.wheat.count: <integer>       # Activity counter for component
demeter.cows.count: <integer>        # Activity counter for component
demeter.cakes.count: <integer>       # Activity counter for component
```

**These are separate systems**: Demeter counters track specific activities for components, while `farming.xp` tracks overall skill progression for ranks.

---

## Admin Commands

### Give XP
```
/farmingadmin <player> xp <amount>
```
Adds XP to player's total (awards rank-up if threshold crossed)

**Example**: `/farmingadmin Notch xp 500`

---

### Set Total XP
```
/farmingadmin <player> setxp <amount>
```
Sets player's XP to exact amount (recalculates rank, triggers ceremony if rank increases)

**Examples**:
```
/farmingadmin Notch setxp 1000    # Set to Acolyte rank
/farmingadmin Notch setxp 3500    # Set to Disciple rank
/farmingadmin Notch setxp 9750    # Set to Hero rank
/farmingadmin Notch setxp 25375   # Set to Champion rank
/farmingadmin Notch setxp 64438   # Set to Legend rank
```

---

### Force Set Rank
```
/farmingadmin <player> rank <0-5>
```
Directly sets rank without changing XP (useful for testing buffs)

**Example**: `/farmingadmin Notch rank 3`

**Note**: This bypasses XP requirements and does NOT trigger rank-up ceremony.

---

### Reset Farming Progression
```
/farmingadmin <player> reset
```
Wipes ALL farming rank data:
- `farming.xp` flag removed
- `farming.rank` flag removed
- Player returns to Unranked with 0 XP

**Warning**: This does NOT affect Demeter component progress (those are separate flags).

---

## GUI Display

### Farming Ranks GUI

Accessible from `/profile` → Click "Ranks" icon (experience bottle)

**Layout:**
- **Top Center (Slot 14)**: Current rank overview
  - Rank name
  - Total XP
  - Active buffs (if rank > 0)
  - Progress to next rank (if not maxed)

- **Bottom Row (Slots 30, 32, 34)**: XP gain methods
  - Crop Harvesting (shows all crop XP rates)
  - Animal Breeding (shows all animal XP rates)
  - Food Crafting (shows all food XP rates)

**Example Display**:
```
Your Farming Rank
Current Rank: Disciple of the Farm
Total XP: 4,832

Active Buffs:
• Extra Crop Output: +10%
• Farming Speed: Speed I

Progress to Next Rank:
4,832 / 9,750 XP
```

---

## Testing Scenarios

### Test 1: XP Gain from Crops
1. Set role to FARMING
2. Harvest 500 fully-grown wheat (should award 1,000 XP total at 2 XP each)
3. Observe action bar notifications: `+2 Farming XP | Wheat`
4. Check `/profile` → Ranks → Should show 1,000 XP (Acolyte rank achieved)

**Expected:** Rank-up ceremony at 1,000 XP, 5 Demeter Keys awarded

---

### Test 2: XP Gain from Animals
1. Set role to FARMING
2. Breed 10 cows (should award 100 XP total at 10 XP each)
3. Observe action bar notifications: `+10 Farming XP | Cow`

**Expected:** XP increments correctly, action bar feedback clear

---

### Test 3: XP Gain from Food
1. Set role to FARMING
2. Craft 10 cakes (should award 120 XP total at 12 XP each)
3. Bulk craft 5 cakes at once (should award 60 XP, not 12)

**Expected:** Bulk crafting multiplies XP by quantity

---

### Test 4: Role Gate Enforcement
1. Set role to MINING
2. Harvest 100 wheat
3. Check XP → Should be 0 (no XP gained)
4. Switch to FARMING
5. Harvest 1 wheat
6. Check XP → Should be 2

**Expected:** XP only awarded when `role.active = FARMING`

---

### Test 5: Rank Buffs Apply
1. Use `/farmingadmin <player> setxp 3500` (Disciple rank)
2. Set role to FARMING
3. Break a wheat crop
4. Check potion effects → Should have Haste I for 5 seconds
5. Harvest 100 fully-grown wheat
6. Count drops → Should get ~10 bonus wheat (10% chance)

**Expected:** Both speed buff and extra crop drops active

---

### Test 6: Skip Multiple Ranks
1. Start at 0 XP (Unranked)
2. Use `/farmingadmin <player> setxp 25375` (Champion rank)
3. Observe rank-up ceremony

**Expected:** Ceremony shows Champion rank (skips Acolyte, Disciple, Hero), awards 5 keys

---

### Test 7: Max Rank
1. Achieve Legend rank (64,438 XP)
2. Continue farming to earn more XP (e.g., 70,000 XP)
3. Check GUI

**Expected:** XP continues to increment, GUI shows "MAX RANK ACHIEVED!", no further rank-ups

---

## Performance Considerations

### Event Load
- **XP Award:** Runs on every crop harvest, animal breed, food craft
  - Reads 2 flags, increments 1 flag, checks rank threshold
  - Minimal overhead (~0.1ms per event)
- **Action Bar Notification:** String formatting and display
  - No chat spam, non-intrusive
- **Rank Check:** Integer comparisons (5 thresholds)
  - Instant calculation
- **Rank-Up Ceremony:** Only triggers on threshold cross
  - Rare event, acceptable overhead

**Verdict:** Very lightweight system. Adds negligible server load.

---

## Balance Considerations

### XP Rates
Current rates are calibrated for **long-term progression**:
- **Acolyte (1,000 XP):** ~500 wheat OR ~100 cows OR ~84 cakes (1-2 hours of focused farming)
- **Disciple (3,500 XP):** ~1,750 wheat (5-7 hours)
- **Hero (9,750 XP):** ~4,875 wheat (15-20 hours)
- **Champion (25,375 XP):** ~12,688 wheat (40-50 hours)
- **Legend (64,438 XP):** ~32,219 wheat (100+ hours)

### Reward Power Levels
- **Acolyte:** Minor QoL (5% crop bonus, no speed)
- **Disciple:** Noticeable improvement (10% crops, Haste I unlocked)
- **Hero:** Steady progression (15% crops)
- **Champion:** Significant advantage (20% crops, 1 in 5)
- **Legend:** Master tier (25% crops, Haste II)

### Cross-Activity Balancing
- **Wheat:** Most common, lowest XP per action (2 XP)
- **Cows:** Moderate effort, moderate XP (10 XP)
- **Cakes:** Resource-intensive, highest XP per action (12 XP)
- **Horse Breeding:** Rare activity, very high XP (30 XP)

**Design Goal:** Encourage diverse farming activities rather than pure wheat grinding.

---

## Future Enhancements

### Potential Additions
- **Prestige System:** Reset ranks for cosmetic rewards (titles, particles)
- **Rank-Specific Items:** Unique hoe skins or tool upgrades at each rank
- **XP Multiplier Events:** Double XP weekends for seasonal engagement
- **Leaderboards:** Track top XP earners per week/month
- **Additional Buffs:** Consider Fortune-like effects or crop growth speed boosts at higher ranks

### Hephaestus/Heracles Ranks
When implementing other roles, use the same structure:
- **5-tier XP-based progression** (Acolyte → Disciple → Hero → Champion → Legend)
- **Role-specific passive buffs** (e.g., faster smelting, bonus ore drops, combat bonuses)
- **Separate XP pools** (`hephaestus.xp`, `heracles.xp`)
- **Consistent scaling** (2.5x multiplier between tiers)

---

## Common Questions

### Q: Do ranks reset if I switch roles?
**A:** No. Ranks are stored per-role (`farming.rank`, `hephaestus.rank`, etc.). Switching roles preserves all ranks, but **buffs only apply when the corresponding role is active**.

### Q: Can I lose a rank?
**A:** No. Ranks are permanent once earned. XP never decreases.

### Q: Do ranks affect emblem unlocking?
**A:** No. Ranks and emblems are independent systems. You could unlock Demeter's Emblem at Unranked, or be Legend rank without any components.

### Q: What if I earn XP from multiple activities?
**A:** All XP is cumulative. XP from wheat, cows, cakes, and all other activities adds to the same `farming.xp` pool. This encourages diverse farming.

### Q: Does farming speed buff work in the Nether?
**A:** Yes. The buff applies when breaking **any** crop, including nether wart. Extra crop drops only apply to overworld wheat.

### Q: Does the extra crop chance work with Fortune or Silk Touch?
**A:** Yes. The bonus drop is independent of tool enchantments. It simply drops 1 additional wheat at the break location.

---

## Implementation Files

**Primary:** `scripts/emblems/demeter/demeter_ranks.dsc`

**Key Scripts:**
- `farming_rank_data` - Rank definitions (XP thresholds, buffs, rewards)
- `farming_xp_rates` - XP award rates for all activities
- `award_farming_xp` - Centralized XP handler (increments, checks rank-up, shows action bar)
- `get_farming_rank` - Procedure to calculate rank from total XP
- `get_farming_rank_name` - Procedure to get display name for rank number
- `get_farming_rank_data` - Procedure to get rank data map for GUI
- `get_farming_speed_bonus` - Procedure to get haste amplifier for rank
- `get_extra_crop_chance` - Procedure to get crop bonus percentage for rank
- `farming_rank_up_ceremony` - Rank-up announcement and effects
- `farming_speed_buff` - Haste buff handler (event-driven)
- `farming_extra_crops` - Bonus wheat drop handler (event-driven)

**Related Files:**
- `scripts/emblems/demeter/demeter_events.dsc` - Calls `award_farming_xp` after each activity
- `scripts/profile_gui.dsc` - Farming Ranks GUI display
- `scripts/emblems/admin/admin_commands.dsc` - `/farmingadmin` commands

---

## Summary

The Farming Skill Rank System adds **meaningful progression rewards** that directly impact gameplay, making farming more efficient and rewarding as players invest time into the role.

Key design principles:
- **Generic skill progression:** Not tied to any specific emblem
- **XP-based:** Encourages diverse farming activities (not just one counter)
- **Permanent buffs:** Ranks feel valuable and never wasted
- **Clear feedback:** Action bar notifications show real-time XP gains
- **Long-term goals:** Legend rank is aspirational, requiring 100+ hours
- **Parallel to emblems:** Both systems coexist without interfering

This system transforms FARMING from a role into a **living skill** with tangible mastery progression.
