# Charon Emblem

**Tier:** 2 (requires 2 Tier 1 emblem completions)
**Color:** `<&5>` dark purple
**Icon:** soul_lantern
**Meta-god:** Dis

## Overview

Charon is the Ferryman of the Dead, a Nether-themed Tier 2 emblem. Players must have completed at least 2 of the 3 Tier 1 emblems (Demeter, Hephaestus, Heracles) before it can be selected.

## NPC

Charon has a **dedicated NPC** (separate from Promachos) that handles:
- Ancient debris turn-ins
- Emblem unlock ceremony
- Emblem info/progress display

Promachos retains emblem selection and tier gating.

## Activities

| Activity | Mechanic | Key Threshold | Milestone | Total Keys |
|----------|----------|--------------|-----------|------------|
| Ancient Debris | Turn in to Charon NPC | 5/key | 500 | 100 |
| Wither Combat | Kill wither skeletons (+1) and withers (+15) | 15/key | 1,500 | 100 |
| Piglin Bartering | Piglin completes barter near player | 25/key (1% bonus) | 2,500 | 100 |

### Ancient Debris
- Hold ancient debris in hand, right-click Charon NPC
- NPC takes all debris from hand, increments count
- Keys awarded every 5 debris turned in
- Component at 500 debris

### Wither Combat
- Kill wither skeletons and withers with Charon emblem active
- Wither skeleton: +1 to count
- Wither boss: +15 to count
- Keys awarded every 15 kill points
- Component at 1,500 total kill points

### Piglin Bartering
- Complete piglin barters with Charon emblem active
- Uses nearest player within 8 blocks (no direct player context in barter event)
- Each barter: +1 to count, checked against threshold
- 1% bonus key chance per barter
- Keys awarded every 25 barters
- Component at 2,500 barters

## Blessing

**Charon Blessing** — 5% boost on all incomplete activities:
- Debris: +25 (5% of 500)
- Withers: +75 (5% of 1,500)
- Barters: +125 (5% of 2,500)

If all 3 components are already complete, converts to **10 Charon Keys** instead.

## Crate System

**Charon Crate** — 5 tiers, nether-themed loot:

| Tier | Probability | Probability (Unlocked) |
|------|------------|----------------------|
| MORTAL | 56% | 55% |
| HEROIC | 26% | 26% |
| LEGENDARY | 12% | 12% |
| MYTHIC | 5% | 5% |
| OLYMPIAN | 1% | 2% |

### Loot Tables

**MORTAL:** blaze_rod:1, magma_cream:4, nether_wart:2, blackstone:8, soul_sand:4, emerald:8, gold_ingot:2

**HEROIC:** golden_carrot:8, emerald:16, quartz_block:8, experience:100, glowstone:8

**LEGENDARY:** golden_apple:2, charon_key:2, nether_gold_ore:16, experience:250

**MYTHIC:** charon_blessing:1, charon_mythic_fragment:1, wither_skeleton_skull:3, gold_block:16

> Charon Mythic Fragments are also awarded 1x per component milestone (Debris, Withers, Barters = 3 total).

**OLYMPIAN:** dis_key:1 (100%)

## Components

| Component | Requirement | Flag |
|-----------|-------------|------|
| Debris Component | 500 ancient debris | `charon.component.debris` |
| Wither Component | 1,500 wither kills | `charon.component.withers` |
| Barter Component | 2,500 piglin barters | `charon.component.barters` |

## Emblem Unlock

When all 3 components are obtained, right-clicking the Charon NPC triggers the unlock ceremony:
- Thematic sound: `entity_wither_ambient`
- Visual: `soul_fire_flame` particle effect
- 30 bonus Charon Keys awarded
- `charon.emblem.unlocked` flag set
- `emblem.rank` incremented

## Files

- `scripts/emblems/charon/charon_items.dsc` — Key, blessing, fragment, components
- `scripts/emblems/charon/charon_npc.dsc` — NPC assignment, interact, turn-in, ceremony, info GUI
- `scripts/emblems/charon/charon_events.dsc` — Wither combat, piglin bartering
- `scripts/emblems/charon/charon_crate.dsc` — 5-tier crate system
- `scripts/emblems/charon/charon_blessing.dsc` — Blessing consumable
