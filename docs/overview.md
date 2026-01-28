# Emblem System - Overview

## Philosophy

The emblem system has been redesigned from a linear, stage-gated progression to a **role-based, activity-driven loop** that rewards players frequently while preserving long-term goals.

### Core Loop

```
Choose Role → Perform Activities → Earn Keys → Open Crates → Get Loot
                    ↓
        Track Milestones → Earn Components → Unlock Emblem → Next Emblem Line
```

---

## Roles (Greek-Flavored)

Players must choose ONE active role at a time. Only the active role:
- Increments activity counters
- Awards god keys (Demeter, Hephaestus, Heracles)
- Advances toward component milestones

### Three Roles Available

| Role | Greek Name | Focus | God Line |
|------|-----------|-------|----------|
| Farming | **Georgos** (γεωργός) | Agriculture, breeding, food | Demeter → Ceres → ... |
| Mining | **Metallourgos** (μεταλλουργός) | Ore, stone, underground | Hephaestus → Vulcan → ... |
| Combat | **Hoplites** (ὁπλίτης) | Mobs, raids, dungeons | Heracles → Mars → ... |

**Internal IDs**: `FARMING`, `MINING`, `COMBAT` (used in flags)

### Role Selection & Switching

- **First Time**: Promachos forces role selection during first meeting
- **Anytime After**: Click Promachos → "Change Role" option → GUI picker
- **No Cooldown**: Switch as often as desired
- **No Data Loss**: All counters, keys, components preserved when role is inactive
- **Pause Only**: Inactive roles do not track activities or award keys

### Role Independence

- Players may **use keys** from any god regardless of active role
- Players may **open crates** regardless of active role
- Players may **trade keys/items** freely
- Role only gates **earning progress** for that god's activities

---

## Gods & Emblems

### Current Implementation: Demeter (Farming)

**Activities** (only when role = FARMING):
- Harvest fully-grown wheat
- Breed cows
- Craft cakes

**Rewards**:
- **Keys**: Earned at intervals (e.g., every 150 wheat)
- **Components**: Deterministic milestones (e.g., 15,000 wheat)
- **Emblem**: Cosmetic unlock when all 3 components obtained

**Meta-Progression**:
- Demeter crate has 1% chance to drop **Ceres Key**
- Ceres Key opens premium crate with finite item progression
- Ceres items are one-time unlocks per player

### Future Gods (Placeholder)

- **Hephaestus** (Mining): Activities TBD, similar structure
- **Heracles** (Combat): Activities TBD, similar structure
- **Vulcan** (Meta for Mining): Like Ceres for farming
- **Mars** (Meta for Combat): Like Ceres for combat

Each god follows the same template:
1. 3 activities with counter tracking
2. Key drops at intervals
3. Component milestones (once-only)
4. Crate with tiered loot
5. Emblem unlock ceremony

---

## Progression Flow

### 1. Choose Role (Promachos)
- First interaction: Dialogue → Role selection GUI
- Subsequent: "Change Role" option available

### 2. Perform Activities
- Only active role activities count
- Counters increment in real-time
- Server announces milestones (optional)

### 3. Earn Keys
- Keys drop automatically when thresholds reached
- Example: Every 150 wheat → +1 Demeter Key
- Keys are physical items (can be traded, stored, used later)

### 4. Open Crates
- Right-click key → GUI animation (2s roll)
- Tiered loot: MORTAL → HEROIC → LEGENDARY → MYTHIC → OLYMPIAN
- One loot entry per key consumed

### 5. Reach Component Milestones
- Example: 15,000 wheat → Wheat Component (once only)
- Component is symbolic item (or just flag + GUI display)
- Milestone complete → no further component drops

### 6. Unlock Emblem
- When all 3 components obtained → Visit Promachos
- Promachos checks completion → Ceremony dialogue
- Emblem unlocked as cosmetic flag
- Next emblem line unlocked (e.g., Demeter → "Next Farming Emblem TBD")

### 7. Meta-Progression (Ceres)
- Rare Ceres Keys from Demeter crates (1% OLYMPIAN tier)
- Ceres crate: 50% god apple / 50% unique item
- Finite item pool (4 items): Hoe, Title, Shulker, Wand
- Once all obtained → only god apples drop

---

## Key Design Principles

| Feature | Implementation |
|---------|----------------|
| Progression | Parallel activities with repeatable key rewards |
| Role System | One active role at a time, switch freely |
| Rewards | Frequent crate loot + deterministic component milestones |
| Emblems | Cosmetic unlocks (flags) tracked in profile |
| NPC Trading | Role selection and emblem unlock ceremonies |
| Long-Term Goals | Component milestones leading to emblem unlocks |
| Grind Feel | Short loops with frequent rewards for engagement |

---

## Cosmetic Unlocks & Profile Integration

### Emblem Display
- Profile GUI shows all emblem slots
- Locked: Gray icon + "???"
- In Progress: Color icon + progress bars
- Unlocked: Gold icon + ✓ checkmark + badge

### Optional Features (Future)
- Chat titles (e.g., "[Ceres' Chosen] PlayerName")
- Particle effects on emblem unlock
- Leaderboards for activity counters
- Emblem showcase command (`/emblems`)

---

## Scalability Template

To add a new god (e.g., Hephaestus):
1. Define 3 activities (e.g., mine iron, kill golems, smelt ingots)
2. Set key thresholds (e.g., every 200 iron → key)
3. Set component milestones (e.g., 20k iron → component)
4. Design crate loot table (5 tiers, probabilities)
5. Implement event handlers with role gate
6. Add to Promachos role mapping
7. Update profile GUI

**Code files to duplicate**:
- `demeter_items.dsc` → `hephaestus_items.dsc`
- `demeter_events.dsc` → `hephaestus_events.dsc`
- `demeter_crate.dsc` → `hephaestus_crate.dsc`
- Update `roles.dsc` and `promachos.dsc`

---

## Mythology & Naming

### Greek (Primary Progression)
- **Demeter** (Δημήτηρ): Goddess of harvest, agriculture, fertility
- **Hephaestus** (Ἥφαιστος): God of fire, metalworking, craftsmanship
- **Heracles** (Ἡρακλῆς): Hero of strength, courage, combat

### Roman (Meta-Progression)
- **Ceres**: Roman equivalent of Demeter, agricultural abundance
- **Vulcan**: Roman equivalent of Hephaestus, forge and volcanoes
- **Mars**: Roman god of war (distinct from Heracles but combat-themed)

### Role Names
- **Georgos** (γεωργός): Farmer, earth-worker
- **Metallourgos** (μεταλλουργός): Metal-worker, miner
- **Hoplites** (ὁπλίτης): Heavily-armed foot soldier

### Tone
- **Promachos**: Speaks as a champion/herald, formal but encouraging
- **Item Lore**: Mythologically consistent, references to gods' domains
- **Dialogue**: Respectful of player agency, congratulatory on milestones

---

## Performance & Safety

- **No heavy loops**: Activity tracking uses single-event handlers
- **Role gating**: Early exit if role ≠ required, no wasted computation
- **Crate animation**: 2s max, single inventory update per roll
- **Flag efficiency**: Hierarchical structure (e.g., `demeter.wheat.count`)
- **Component once-only**: Prevents infinite milestone rewards

---

## Future Enhancements

- **Leaderboards**: Top farmers/miners/warriors
- **Seasonal Events**: Bonus key weekends, double progress
- **Emblem Synergies**: Unlock special items when multiple emblems owned
- **Prestige System**: Reset counters for cosmetic rewards
- **Guild Integration**: Shared emblem progress or goals
