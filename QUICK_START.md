# Emblem System - Quick Start

## 📁 File Structure

```
scripts/
├── profile_gui.dsc                    # Player profile with emblem integration
├── bulletin.dsc                       # Server announcements
├── server_restrictions.dsc            # Gameplay restrictions
└── emblems/                           # Complete emblem system
    ├── core/
    │   ├── roles.dsc                  # Role system + procedures
    │   └── promachos_v2.dsc           # NPC + role selection + ceremonies
    ├── demeter/
    │   ├── demeter_items.dsc          # Keys, blessing, hoe, components
    │   ├── demeter_events.dsc         # Activity tracking
    │   ├── demeter_crate.dsc          # Crate system with loot
    │   └── demeter_blessing.dsc       # +10% boost consumable
    ├── ceres/
    │   ├── ceres_items.dsc            # Ceres key, hoe, wand
    │   ├── ceres_crate.dsc            # Meta-progression crate
    │   └── ceres_mechanics.dsc        # Special item mechanics
    └── admin/
        ├── admin_commands_v2.dsc      # Testing commands
        └── v1_cleanup_on_join.dsc     # Auto-wipe old flags (one-time)

docs/                                  # Full documentation
├── overview.md
├── promachos.md
├── demeter.md
├── crates_demeter.md
├── ceres.md
├── flags.md
├── testing.md
└── migration.md
```

---

## 🚀 First-Time Setup

### 1. V1 Cleanup (If Upgrading)

**Automatic Cleanup** (Recommended):
- The script `v1_cleanup_on_join.dsc` automatically wipes old emblem flags when players join
- Players see a message: "Your emblem progress has been reset for the new system"
- After all players have joined at least once, run: `/v1cleanupcomplete`

**Manual Cleanup** (Alternative):
```
/v1cleanup <player>     # Wipe old flags for specific player
```

### 2. Set Up Promachos NPC

**If NPC doesn't exist yet:**
```
/npc create Promachos --type PLAYER
/npc skin Promachos              # Or set custom skin
/npc assignment --set promachos_assignment
```

**If NPC already exists (ID 0):**
```
/npc sel 0
/npc assignment --set promachos_assignment
```

**Verify:**
- Right-click Promachos → Should trigger dialogue or role selection GUI

### 3. Test Core Functions (As Admin)

**Test Role Selection:**
```
1. Right-click Promachos
2. Choose a role (Georgos/Metallourgos/Hoplites)
3. Check flag: /ex narrate <player.flag[role.active]>
   Should show: FARMING (or MINING/COMBAT)
```

**Test Activity Tracking:**
```
1. Set role to FARMING: /roleadmin <your_name> FARMING
2. Harvest 1 fully-grown wheat
3. Check counter: /ex narrate <player.flag[demeter.wheat.count]>
   Should show: 1
```

**Test Key Usage:**
```
1. Give yourself keys: /demeteradmin <your_name> keys 5
2. Right-click a key
3. Should see 2s animation → loot award
```

**Test Profile GUI:**
```
/profile
Should show:
- Active role
- Demeter progress (if role = FARMING)
- Emblem status
```

---

## 🎮 Player Quick Start

### For Your Players

**Step 1: Find Promachos**
- Look for the NPC named "Promachos" on the server
- Right-click to start

**Step 2: Choose Your Role**
- **Georgos** (Farmer) → Demeter progression
- **Metallourgos** (Miner) → Coming soon
- **Hoplites** (Warrior) → Coming soon

**Step 3: Earn Keys**
If you chose Farming:
- Harvest wheat → Every 150, get a Demeter Key
- Breed cows → Every 20, get a Demeter Key
- Craft cakes → Every 3, get a Demeter Key

**Step 4: Open Crates**
- Right-click Demeter Key
- Watch animation
- Get loot!

**Step 5: Check Progress**
```
/profile
```
Shows your role, counters, and emblem status.

---

## 🛠️ Admin Commands

### Role Management
```
/roleadmin <player> <FARMING|MINING|COMBAT>
```

### Demeter Commands
```
/demeteradmin <player> keys <amount>              # Give keys
/demeteradmin <player> set wheat <count>          # Set counter
/demeteradmin <player> component wheat true       # Mark component complete
/demeteradmin <player> reset                      # Wipe all Demeter flags
```

### Ceres Commands
```
/ceresadmin <player> keys <amount>                # Give Ceres keys
/ceresadmin <player> item hoe true                # Mark item obtained
/ceresadmin <player> reset                        # Wipe all Ceres flags
```

### Testing
```
/testroll demeter        # Simulate Demeter crate (no key consumed)
/testroll ceres          # Simulate Ceres crate (no key consumed)
```

### V1 Cleanup
```
/v1cleanup <player>      # Manually wipe old flags for a player
/v1cleanupcomplete       # Mark cleanup complete server-wide (disables auto-wipe)
```

---

## 📊 Key Thresholds

### Demeter (FARMING role only)

| Activity | Key Threshold | Component Milestone |
|----------|---------------|---------------------|
| Wheat | Every 150 | 15,000 total |
| Cows | Every 20 | 2,000 total |
| Cakes | Every 3 | 300 total |

### Crate Tiers

| Tier | Chance | Notable Loot |
|------|--------|--------------|
| MORTAL | 56% | Food, basic resources |
| HEROIC | 26% | Golden carrots, emeralds, XP |
| LEGENDARY | 12% | Golden apples, more keys |
| MYTHIC | 5% | Demeter Blessing, Demeter Hoe |
| OLYMPIAN | 1% | Ceres Key |

---

## 🆘 Common Issues

**Issue: Old flags not wiping**
- Ensure `v1_cleanup_on_join.dsc` is loaded
- Check player has joined since deployment
- Manually run: `/v1cleanup <player>`

**Issue: Promachos not responding**
- Check NPC assignment: `/npc sel 0` then `/npc assignment`
- Should show: `promachos_assignment`
- If not: `/npc assignment --set promachos_assignment`

**Issue: Keys not dropping**
- Verify role is correct: `/ex narrate <player.flag[role.active]>`
- Must be FARMING for Demeter activities
- Check counter is incrementing: `/ex narrate <player.flag[demeter.wheat.count]>`

**Issue: Activities not tracking**
- Wheat must be fully grown (age 7)
- Cows must be bred by the player (not dispenser)
- Role must match activity type

---

## 📚 Full Documentation

See `/docs` folder:
- `overview.md` - Complete system design
- `testing.md` - Full test checklist
- `flags.md` - All flag references
- `EMBLEM_V2_README.md` - Player guide

---

## ✅ Post-Deployment Checklist

After deploying to your server:

- [ ] All old V1 `.dsc` files deleted
- [ ] `emblems_v2` renamed to `emblems`
- [ ] Promachos NPC created and assigned
- [ ] Tested role selection
- [ ] Tested activity tracking
- [ ] Tested key usage
- [ ] Tested profile GUI
- [ ] Players notified of reset
- [ ] First players joining (auto-cleanup running)
- [ ] After all players joined once: `/v1cleanupcomplete`

---

## 🎯 Success Metrics

After 1 week, check:
- Server stability (no crashes, TPS > 19.5)
- Player engagement (% of players who chose a role)
- Feedback ratio (positive vs negative)
- Bug count (critical vs minor)

If successful → Expand to Hephaestus (mining) and Heracles (combat)!

---

**You're all set!** 🎉

Refer to `DEPLOYMENT_CHECKLIST.md` for detailed deployment steps.
