# Emblem System V2 - Quick Start Guide

## 🎯 What Is This?

A complete rework of the Minecraft server emblem progression system. Instead of long, stage-gated grinds, players now:

1. **Choose a role** (Farming, Mining, or Combat)
2. **Perform activities** (harvest wheat, breed cows, craft cakes, etc.)
3. **Earn keys frequently** (every 3-150 activities depending on type)
4. **Open crates** for immediate loot rewards
5. **Reach milestones** for component unlocks
6. **Unlock emblems** as cosmetic achievements

---

## 🚀 Quick Start (For Players)

### Step 1: Meet Promachos
- Find the NPC named **Promachos** on the server
- Right-click to start dialogue
- Listen to the 5-part introduction

### Step 2: Choose Your Role
- After dialogue, a GUI opens with 3 choices:
  - **Georgos** (Farmer) → Demeter progression
  - **Metallourgos** (Miner) → Hephaestus progression (coming soon)
  - **Hoplites** (Warrior) → Heracles progression (coming soon)
- Click your choice to begin!

### Step 3: Start Earning
**If you chose FARMING:**
- Harvest fully-grown wheat → Every 150, you get a **Demeter Key**
- Breed cows → Every 20, you get a **Demeter Key**
- Craft cakes → Every 3, you get a **Demeter Key**

### Step 4: Use Your Keys
- Right-click a **Demeter Key** anywhere
- Watch the crate animation (2 seconds)
- Receive loot! (food, resources, rare items, even more keys!)

### Step 5: Reach Milestones
- **15,000 wheat** → Wheat Component unlocked
- **2,000 cows** → Cow Component unlocked
- **300 cakes** → Cake Component unlocked

### Step 6: Unlock Your Emblem
- When you have all 3 components, visit **Promachos** again
- Click "Check Emblems" → Click "Demeter" → Watch the ceremony!
- **Demeter's Emblem** unlocked! (Cosmetic achievement)

---

## 📊 Check Your Progress

Type `/profile` to see:
- Your active role
- Activity counters (wheat, cows, cakes)
- Component completion status
- Emblem unlock status

---

## 🎁 Crate Loot Tiers

**Demeter Keys** open crates with 5 tiers:

| Tier | Chance | Examples |
|------|--------|----------|
| **MORTAL** | 56% | Bread, Cooked Beef, Wheat, Hay Bales |
| **HEROIC** | 26% | Golden Carrots, Emeralds, Gold Blocks, XP |
| **LEGENDARY** | 12% | Golden Apples, **More Keys**, Emerald Blocks |
| **MYTHIC** | 5% | Enchanted Golden Apples, **Demeter Blessing**, **Demeter Hoe** |
| **OLYMPIAN** | 1% | **Ceres Key** (meta-progression!) |

---

## 🌟 Special Items

### Demeter Blessing (MYTHIC)
- **Effect**: Boosts all incomplete Demeter activities by +10%
- **Use**: Right-click to activate
- **Example**: If you have 5,000 wheat, blessing adds +1,500 (10% of 15,000 requirement)
- **Stackable**: Yes! Use multiple for bigger boosts

### Demeter Hoe (MYTHIC)
- **Type**: Diamond Hoe
- **Special**: Unbreakable
- **Prestige item** (no special mechanics)

### Ceres Key (OLYMPIAN - 1% chance)
- **Opens**: Ceres Crate (different from Demeter!)
- **Rewards**: 50% Enchanted Golden Apple / 50% Unique Item
- **Unique Items** (one-time per player):
  1. **Ceres Hoe**: Netherite, unbreakable, **auto-replants crops** when harvested
  2. **Ceres Title**: Chat prefix "[Ceres' Chosen]"
  3. **Yellow Shulker Box**: Rare utility item
  4. **Ceres Wand**: Summons 6 angry bees to attack hostiles (30s cooldown)

---

## 🔄 Changing Roles

- Visit **Promachos** anytime
- Click "Change Role"
- Select new role
- **Your progress is saved!** Switching to Mining won't delete your Farming progress.
- Only your **active role** earns progress and keys.

---

## ❓ FAQ

**Q: Can I do multiple roles at once?**
A: No. Only one role is active at a time. But you can switch anytime without losing progress!

**Q: Can I trade keys?**
A: Yes! Keys are normal items. Trade, store, or save them.

**Q: Can I use keys if I'm not the Farming role?**
A: Yes! Keys can be used regardless of your active role.

**Q: What happens after I unlock Demeter's Emblem?**
A: Promachos reveals the next emblem in the Farming line (coming soon). You can also pursue other roles!

**Q: How rare is a Ceres Key?**
A: 1% chance per Demeter crate. Expect 1 Ceres Key per 100 Demeter Keys opened.

**Q: Can I get more than one Ceres Hoe?**
A: No. Ceres items are **one-time unlocks**. Once you own all 4, Ceres crates always give god apples.

**Q: Does the Ceres Hoe work with Demeter wheat tracking?**
A: Yes! Breaking wheat with Ceres Hoe counts for Demeter progress AND auto-replants.

---

## 🛠️ Admin Commands (For Server Staff)

### Role Management
```
/roleadmin <player> <FARMING|MINING|COMBAT>
```

### Demeter Testing
```
/demeteradmin <player> keys 10           # Give 10 Demeter Keys
/demeteradmin <player> set wheat 14500   # Set wheat counter to 14,500
/demeteradmin <player> component wheat true  # Mark wheat component complete
/demeteradmin <player> reset             # Wipe all Demeter flags
```

### Ceres Testing
```
/ceresadmin <player> keys 5              # Give 5 Ceres Keys
/ceresadmin <player> item hoe true       # Mark Ceres Hoe as obtained
/ceresadmin <player> reset               # Wipe all Ceres flags
```

### Test Rolls
```
/testroll demeter    # Simulate Demeter crate (no key consumed)
/testroll ceres      # Simulate Ceres crate (no key consumed)
```

---

## 📚 Full Documentation

See `/docs` folder for complete specs:
- `overview.md` - System philosophy and design
- `promachos.md` - NPC dialogue flows
- `demeter.md` - Activity tracking and thresholds
- `crates_demeter.md` - Loot tables and probabilities
- `ceres.md` - Meta-progression details
- `flags.md` - Technical flag reference
- `testing.md` - Complete test checklist
- `migration.md` - Deployment strategy

---

## 🐛 Reporting Bugs

If you find a bug:
1. Note the exact steps to reproduce
2. Check server console for errors
3. Report in server Discord with:
   - What you were doing
   - What you expected
   - What actually happened
   - Any error messages

---

## 🎨 Credits

**Mythology**:
- Greek: Demeter (harvest), Hephaestus (forge), Heracles (strength)
- Roman: Ceres, Vulcan, Mars
- Role Names: Georgos (farmer), Metallourgos (miner), Hoplites (warrior)
- NPC: Promachos (champion)

**System Design**: Claude (Anthropic)
**Implementation**: Denizen scripting engine
**Server**: Your awesome Minecraft server!

---

## 🚧 Coming Soon

- **Hephaestus Progression** (Mining role)
- **Heracles Progression** (Combat role)
- **Vulcan Meta-Progression** (Mining equivalent of Ceres)
- **Mars Meta-Progression** (Combat equivalent of Ceres)
- **Leaderboards** (Top farmers, miners, warriors)
- **Seasonal Events** (Double progress weekends)
- **Prestige System** (Reset for cosmetic rewards)

---

**Enjoy the new emblem system!**
May the gods smile upon your labors. 🌾⚔️⛏️
