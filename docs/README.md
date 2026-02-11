# Emblem System Documentation

Documentation for the Promachos emblem-based progression system.

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

## Emblem Documentation

| Emblem | Greek God | Roman God (Meta) |
|--------|-----------|------------------|
| DEMETER | [demeter.md](demeter.md) | [ceres.md](ceres.md) |
| HEPHAESTUS | [hephaestus.md](hephaestus.md) | [vulcan.md](vulcan.md) |
| HERACLES | [heracles.md](heracles.md) | [mars.md](mars.md) |

### NPC System
- [promachos.md](promachos.md) - Promachos NPC interactions and emblem selection

---

## System Overview

**Emblems:** DEMETER (Demeter), HEPHAESTUS (Hephaestus), HERACLES (Heracles)

**Progression Flow:**
1. Choose emblem via Promachos NPC
2. Complete activities to earn keys
3. Open crates for rewards (5 tiers: MORTAL to OLYMPIAN)
4. Reach milestones to unlock components
5. Collect all components to unlock emblem
6. Access Roman god meta-crate for unique items

---

## For Developers

See [STYLE.md](STYLE.md) for:
- Color codes by emblem and tier
- Sound cues for all events
- Message patterns (keys, milestones, announcements)
- Action bar and title patterns
- GUI conventions
- Naming conventions for flags and scripts

