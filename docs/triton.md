# Triton Emblem

**Tier:** 2 (requires 2 Tier 1 emblem completions)
**Color:** `<&3>` dark aqua
**Icon:** trident
**Meta-god:** Neptune

## Overview

Triton is the God of the Sea. This is the first Tier 2 emblem, requiring players to have completed at least 2 of the 3 Tier 1 emblems (Demeter, Hephaestus, Heracles) before it can be selected.

## NPC

Triton has a **dedicated NPC** (separate from Promachos) that handles:
- Sea lantern turn-ins
- Emblem unlock ceremony
- Emblem info/progress display

Promachos retains emblem selection and tier gating.

## Activities

| Activity | Mechanic | Key Threshold | Milestone | Total Keys |
|----------|----------|--------------|-----------|------------|
| Sea Lanterns | Turn in to Triton NPC | 10/key | 1,000 | 100 |
| Guardian Kills | Kill guardians (regular=+1, elder=+15) | 15/key | 1,500 | 100 |
| Conduit Crafting | Craft conduits | 1 conduit = 4 keys | 25 | 100 |

### Sea Lanterns
- Hold sea lanterns in hand, right-click Triton NPC
- NPC takes all lanterns from hand, increments count
- Keys awarded every 10 lanterns turned in
- Component at 1,000 lanterns

### Guardian Kills
- Kill guardians with Triton emblem active
- Regular guardian: +1 to count
- Elder guardian: +15 to count
- Keys awarded every 15 kill points
- Component at 1,500 total kill points

### Conduit Crafting
- Craft conduits with Triton emblem active
- Each conduit crafted awards 4 keys
- Component at 25 conduits crafted

## Blessing

**Triton Blessing** — 5% boost on all incomplete activities:
- Lanterns: +50 (5% of 1,000)
- Guardians: +75 (5% of 1,500)
- Conduits: +1 (5% of 25, rounded down)

If all 3 components are already complete, converts to **10 Triton Keys** instead.

## Crate System

**Triton Crate** — 5 tiers, ocean-themed loot:

| Tier | Probability | Probability (Unlocked) |
|------|------------|----------------------|
| MORTAL | 56% | 55% |
| HEROIC | 26% | 26% |
| LEGENDARY | 12% | 12% |
| MYTHIC | 5% | 5% |
| OLYMPIAN | 1% | 2% |

### Loot Tables

**MORTAL:** cooked_cod:16, cooked_salmon:16, dried_kelp_block:8, prismarine:8, iron_ingot:4, sponge:1, emerald:8

**HEROIC:** golden_carrot:8, emerald:16, sponge:2, experience:100, dark_prismarine:8

**LEGENDARY:** golden_apple:2, triton_key:2, emerald_block:6, experience:250

**MYTHIC:** triton_blessing:1, triton_mythic_fragment:1, gold_block:16, emerald_block:16

**OLYMPIAN:** neptune_key:1 (100%)

## Components

| Component | Requirement | Flag |
|-----------|-------------|------|
| Lantern Component | 1,000 sea lanterns | `triton.component.lanterns` |
| Guardian Component | 1,500 guardian kills | `triton.component.guardians` |
| Conduit Component | 25 conduits crafted | `triton.component.conduits` |

## Emblem Unlock

When all 3 components are obtained, right-clicking the Triton NPC triggers the unlock ceremony:
- Thematic sound: `entity_elder_guardian_ambient`
- Visual: `bubble_pop` particle effect
- 30 bonus Triton Keys awarded
- `triton.emblem.unlocked` flag set
- `emblem.rank` incremented

## Files

- `scripts/emblems/triton/triton_items.dsc` — Key, blessing, fragment, components
- `scripts/emblems/triton/triton_npc.dsc` — NPC assignment, interact, turn-in, ceremony, info GUI
- `scripts/emblems/triton/triton_events.dsc` — Guardian kills, conduit crafting
- `scripts/emblems/triton/triton_crate.dsc` — 5-tier crate system
- `scripts/emblems/triton/triton_blessing.dsc` — Blessing consumable
