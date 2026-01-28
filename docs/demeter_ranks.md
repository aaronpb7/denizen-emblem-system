# Demeter Rank System - Complete Specification

## Overview

The **Demeter Rank System** is a parallel progression system alongside component milestones that rewards sustained farming activity with **permanent passive buffs**.

Unlike components (which are one-time unlocks leading to emblems), ranks provide **ongoing gameplay benefits** that enhance farming efficiency.

---

## Rank Tiers

Players progress through 3 ranks by meeting **cumulative thresholds** in both wheat AND cow activities:

| Rank | Wheat Required | Cows Required | Status |
|------|----------------|---------------|--------|
| **Acolyte of Demeter** | 2,500 | 50 | First rank |
| **Disciple of Demeter** | 12,000 | 300 | Second rank |
| **Hero of Demeter** | 50,000 | 700 | Final rank |

**Important:** Both thresholds must be met simultaneously. A player with 60,000 wheat but only 40 cows is still **Unranked**.

---

## Rank Rewards

Each rank unlocks **permanent passive bonuses** that apply while the player has **role.active = FARMING**.

### Acolyte of Demeter
**Requirements:** 2,500 wheat + 50 cows

**Bonuses:**
- **Farming Speed I** (Haste I effect)
  - Applies for 5 seconds when breaking any crop
  - Makes harvesting noticeably faster
- **+5% Extra Crop Chance**
  - 5% chance to drop an extra wheat when harvesting fully-grown wheat
  - Triggers happy villager particles on proc

### Disciple of Demeter
**Requirements:** 12,000 wheat + 300 cows

**Bonuses:**
- **Farming Speed II** (Haste II effect)
  - Applies for 5 seconds when breaking any crop
  - Significantly faster harvesting
- **+20% Extra Crop Chance**
  - 20% chance to drop an extra wheat when harvesting fully-grown wheat
  - Triggers happy villager particles on proc
- **10% Twin Breeding Chance**
  - 10% chance to spawn twin calves when breeding cows
  - Both calves are babies
  - Triggers heart particles and special message

### Hero of Demeter
**Requirements:** 50,000 wheat + 700 cows

**Bonuses:**
- **Farming Speed II** (Haste II effect)
  - Same as Disciple tier
- **+50% Extra Crop Chance**
  - 50% chance (half of all harvests!) to drop an extra wheat
  - Triggers happy villager particles on proc
- **30% Twin Breeding Chance**
  - 30% chance to spawn twin calves when breeding cows
  - Both calves are babies
  - Triggers heart particles and special message

---

## Rank-Up Ceremony

When a player's wheat and cow counters both cross a rank threshold, they immediately experience:

### Visual Effects
- **Particle burst:** 50 villager_happy particles + 30 composter particles
- **Sound:** `UI_TOAST_CHALLENGE_COMPLETE`
- **Title announcement:** "DEMETER RANK UP!" with rank name subtitle

### Chat Announcement
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚜ DEMETER RANK ACHIEVED ⚜
You have become: [Rank Name]

Rewards Unlocked:
• Farming Speed: Speed II
• Extra Crop Chance: +20%
• Twin Breeding Chance: 10%
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Server Announcement
```
[Promachos] PlayerName has achieved Disciple of Demeter!
```

---

## Buff Mechanics

### Farming Speed (Haste)

**Trigger:** Breaking any crop (wheat, carrots, potatoes, beetroots, nether_wart, cocoa)
**Effect:** Haste I (Acolyte) or Haste II (Disciple/Hero) for 5 seconds
**Conditions:**
- Only applies if `role.active = FARMING`
- Rank must be 1 or higher
- Effect is invisible (no icon, no particles)

**Implementation Note:** Reapplies on every crop break, effectively maintaining permanent haste while actively farming.

---

### Extra Crop Drops

**Trigger:** Breaking fully-grown wheat (age 7)
**Effect:** Drop 1 additional wheat item at break location
**Chance:** 5% (Acolyte), 20% (Disciple), 50% (Hero)
**Conditions:**
- Only applies if `role.active = FARMING`
- Only on fully-grown wheat (partially grown crops don't trigger)
- Rank must be 1 or higher

**Visual Feedback:** Happy villager particles at crop location when bonus triggers

**Balance Note:** At Hero rank, players effectively get 150% wheat yield on average (1 + 50% bonus).

---

### Twin Breeding

**Trigger:** Successfully breeding two adult cows
**Effect:** Spawn a second baby cow at the same location
**Chance:** 10% (Disciple), 30% (Hero)
**Conditions:**
- Only applies if `role.active = FARMING`
- Breeder must be a player (not dispenser)
- Rank must be 2 (Disciple) or higher

**Visual Feedback:**
- Heart particles above parent cow
- Cow ambient sound at higher pitch
- Chat message: "✦ Demeter's blessing grants twin calves! ✦"

**Mechanics:**
- Second calf spawns at parent's location
- Both calves are babies (age -24000)
- Both calves count as 1 breeding for activity tracking (not double-counted)

---

## Relationship to Components and Emblems

**Ranks and Emblems are parallel systems, not sequential:**

| System | Purpose | Requirements | Rewards |
|--------|---------|--------------|---------|
| **Components** | One-time milestones | 15k wheat, 2k cows, 300 cakes | Unlock Demeter Emblem |
| **Ranks** | Ongoing progression | Combined wheat + cow thresholds | Permanent passive buffs |

**Example Progression:**
1. Player reaches 2,500 wheat + 50 cows → **Acolyte rank** (buffs active)
2. Player reaches 15,000 wheat (but only 300 cows) → **Wheat Component** (emblem 1/3)
3. Player reaches 2,000 cows → **Cow Component** (emblem 2/3), also crosses **Disciple rank** threshold (12k wheat already passed)
4. Player crafts 300 cakes → **Cake Component** (emblem 3/3)
5. Player visits Promachos → **Demeter Emblem unlocked**

Ranks provide immediate gameplay benefits while pursuing the emblem.

---

## Flag Reference

### Rank Storage
```
demeter.rank: <integer>
```
- `0` = Unranked
- `1` = Acolyte
- `2` = Disciple
- `3` = Hero

**Calculated dynamically** from wheat/cow counters by `demeter_check_rank` task, called after every wheat harvest or cow breed event.

### Required Activity Flags
```
demeter.wheat.count: <integer>
demeter.cows.count: <integer>
```

These are the same flags used for component milestones—ranks simply check different thresholds.

---

## Admin Commands

### Check Player's Rank
```
/demeteradmin <player> checkrank
```
Shows current rank and progress toward next rank.

### Set Activity Counters (Indirect Rank Control)
```
/demeteradmin <player> set wheat 12000
/demeteradmin <player> set cows 300
```
Setting counters will automatically trigger rank check. If both thresholds crossed, rank-up ceremony fires immediately.

**Note:** There is no direct rank-setting command. Ranks are derived from activity counters.

---

## Testing Scenarios

### Test 1: First Rank-Up (Acolyte)
1. Set role to FARMING
2. `/demeteradmin Player set wheat 2500`
3. `/demeteradmin Player set cows 50`
4. Observe rank-up ceremony
5. Break a wheat crop → Verify Haste I effect
6. Harvest fully-grown wheat repeatedly → Verify 5% bonus drops (roughly 1 in 20)

**Expected:** Rank-up announcement, haste effect applies, bonus drops occasionally

---

### Test 2: Skip to Disciple
1. Set counters: 12,000 wheat + 300 cows
2. Observe rank-up ceremony skips Acolyte, goes straight to Disciple
3. Break a wheat crop → Verify Haste II effect
4. Harvest fully-grown wheat repeatedly → Verify 20% bonus drops (roughly 1 in 5)
5. Breed 2 cows repeatedly → Verify 10% twin chance (roughly 1 in 10)

**Expected:** Ceremony shows Disciple rewards, all buffs active

---

### Test 3: Threshold Edge Case (Wheat Only)
1. Set counters: 15,000 wheat + 0 cows
2. Check rank: Should be **Unranked**
3. Break wheat → No haste buff

**Expected:** High wheat count alone doesn't grant rank

---

### Test 4: Role Switch Disables Buffs
1. Achieve Disciple rank as FARMING
2. Switch role to MINING
3. Break wheat crops → No haste buff
4. Harvest wheat → No bonus drops

**Expected:** Buffs only work with active FARMING role

---

### Test 5: Hero Rank Power
1. Set counters: 50,000 wheat + 700 cows
2. Harvest 100 fully-grown wheat
3. Count total wheat drops
4. Breed cows 30 times, count twin births

**Expected:**
- ~150 wheat from 100 harvests (50% bonus rate)
- ~9 twin births from 30 breedings (30% chance)

---

## Performance Considerations

### Event Load
- **Haste buff:** Applies on every crop break (cheap potion effect)
- **Extra crops:** Rolls RNG on every wheat break (minimal overhead)
- **Twin breeding:** Rolls RNG on every cow breed (spawns 1 entity)
- **Rank check:** Runs after every wheat/cow activity (2 integer comparisons)

**Verdict:** Very lightweight. Rank system adds negligible server load.

---

## Balance Considerations

### Rank Thresholds
Current thresholds are calibrated for **long-term players**:
- Acolyte (2,500 wheat + 50 cows): ~17 Demeter Keys earned, achievable in 2-3 hours
- Disciple (12,000 wheat + 300 cows): ~95 Demeter Keys earned, achievable in 1-2 weeks
- Hero (50,000 wheat + 700 cows): ~368 Demeter Keys earned, achievable in 1-2 months

### Reward Power Levels
- **Acolyte:** QoL improvement (minor speed boost, rare bonus drops)
- **Disciple:** Noticeable efficiency gain (consistent bonus drops, occasional twins)
- **Hero:** Major advantage (50% yield increase is very strong)

**Recommendation:** Monitor Hero rank players for economic impact. If wheat becomes too abundant, consider adjusting bonus drop chance to 40% or adding a daily cap.

---

## Future Enhancements

### Potential Additions
- **Visual rank indicator:** Particle effects or nameplate badges for ranked players
- **Rank-specific items:** Special hoe skins or cosmetic rewards
- **Cross-activity ranks:** e.g., "Cake Master" rank for 10,000+ cakes crafted
- **Prestige system:** Reset ranks for cosmetic titles/badges

### Hephaestus/Heracles Ranks
When implementing other roles, use the same 3-tier structure:
- Acolyte → Disciple → Hero
- Dual activity requirements (e.g., 5,000 iron + 100 golems for Hephaestus)
- Role-specific passive buffs (e.g., faster smelting, bonus ore drops)

---

## Common Questions

### Q: Do ranks reset if I switch roles?
**A:** No. Ranks are stored per-god (demeter.rank, hephaestus.rank, etc.). Switching roles preserves all ranks, but **buffs only apply when the corresponding role is active**.

### Q: Can I lose a rank?
**A:** No. Ranks are permanent once earned. Activity counters never decrease.

### Q: Do ranks affect emblem unlocking?
**A:** No. Ranks and emblems are independent systems. You could unlock Demeter's Emblem at Unranked, or be Hero rank without any components.

### Q: What if I hit the wheat threshold but not cows?
**A:** You remain at your current rank until **both** thresholds are met. Ranks require dual progress.

### Q: Does the Ceres Hoe extra crop chance stack with rank bonuses?
**A:** The Ceres Hoe does not have extra crop drop mechanics—it only auto-replants. Rank bonuses apply regardless of tool used.

### Q: Do rank buffs work in the Nether (for nether wart)?
**A:** Yes. Farming Speed buff applies when breaking nether_wart. Extra crop chance only applies to overworld wheat.

---

## Implementation Files

**Primary:** `scripts/emblems/demeter/demeter_ranks.dsc`

**Key Scripts:**
- `demeter_rank_data` - Rank definitions (thresholds, buffs)
- `get_demeter_rank` - Procedure to calculate rank from counters
- `demeter_check_rank` - Task to check for rank-up after activity
- `demeter_rank_up_ceremony` - Rank-up announcement and effects
- `demeter_farming_speed` - Haste buff handler
- `demeter_extra_crops` - Bonus wheat drop handler
- `demeter_twin_breeding` - Twin calf spawn handler

**Related Files:**
- `scripts/emblems/demeter/demeter_events.dsc` - Calls `demeter_check_rank` after wheat/cow activities
- `scripts/profile_gui.dsc` - May display rank in player profile (if implemented)

---

## Summary

The Demeter Rank System adds **meaningful progression rewards** that directly impact gameplay, making farming more efficient and rewarding as players invest time into the role.

Key design principles:
- **Parallel to emblems:** Both systems coexist without interfering
- **Dual requirements:** Encourages balanced activity (not just wheat grinding)
- **Permanent buffs:** Ranks feel valuable and never wasted
- **Visible feedback:** Ceremonies and effects make rank-ups feel epic
- **Long-term goals:** Hero rank is aspirational, not easily obtained

This system transforms Demeter from a milestone checklist into a living progression path with tangible benefits at every step.
