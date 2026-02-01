# Emblem System Documentation

Documentation for the Promachos role-based progression system.

---

## Quick Reference

| Doc | Purpose |
|-----|---------|
| [SYSTEM_OVERVIEW.md](SYSTEM_OVERVIEW.md) | Complete system architecture and mechanics |
| [STYLE.md](STYLE.md) | Colors, sounds, message patterns, UI conventions |
| [flags.md](flags.md) | Flag reference for all progression data |
| [testing.md](testing.md) | Admin commands and test scenarios |
| [EMBLEM_TEMPLATE.md](EMBLEM_TEMPLATE.md) | Implementation checklist for new emblems |

---

## Role Documentation

| Role | Greek God | Roman God (Meta) |
|------|-----------|------------------|
| FARMING | [demeter.md](demeter.md) | [ceres.md](ceres.md) |
| MINING | [hephaestus.md](hephaestus.md) | [vulcan.md](vulcan.md) |
| COMBAT | [heracles.md](heracles.md) | [mars.md](mars.md) |

### NPC System
- [promachos.md](promachos.md) - Promachos NPC interactions and role selection

---

## System Overview

**Roles:** FARMING (Georgos), MINING (Metallourgos), COMBAT (Hoplites)

**Progression Flow:**
1. Choose role via Promachos NPC
2. Complete activities to earn keys
3. Open crates for rewards (5 tiers: MORTAL to OLYMPIAN)
4. Reach milestones to unlock components
5. Collect all components to unlock emblem
6. Access Roman god meta-crate for unique items

---

## For Developers

See [STYLE.md](STYLE.md) for:
- Color codes by role and tier
- Sound cues for all events
- Message patterns (keys, milestones, announcements)
- Action bar and title patterns
- GUI conventions
- Naming conventions for flags and scripts

