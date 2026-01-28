# Emblem System Documentation

Complete documentation for the Promachos role-based progression system.

---

## 📚 Documentation Index

### Getting Started
- **[QUICK_START.md](QUICK_START.md)** - Quick setup guide for new servers
- **[SYSTEM_OVERVIEW.md](SYSTEM_OVERVIEW.md)** - Complete system reference and architecture
- **[overview.md](overview.md)** - Philosophy and design principles
- **[DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)** - Production deployment steps

### Core Systems
- **[promachos.md](promachos.md)** - Promachos NPC interactions and role selection
- **[flags.md](flags.md)** - Complete flag reference guide

### Demeter (FARMING Role)
- **[demeter.md](demeter.md)** - Component milestones and activities
- **[demeter_ranks.md](demeter_ranks.md)** - Rank progression system with buffs ⭐ NEW
- **[demeter_blessing.md](demeter_blessing.md)** - Demeter Blessing consumable
- **[crates_demeter.md](crates_demeter.md)** - Demeter crate system

### Ceres (FARMING Meta-Progression)
- **[ceres.md](ceres.md)** - Ceres vault and unique items

### Testing & Administration
- **[testing.md](testing.md)** - Test scenarios and admin commands
- **[migration.md](migration.md)** - V1 to V2 migration guide

### Maintenance
- **[DOCUMENTATION_UPDATES_2026-01-28.md](DOCUMENTATION_UPDATES_2026-01-28.md)** - Recent documentation updates log

---

## 🗂️ Documentation by Purpose

### For Server Owners
1. Start with [QUICK_START.md](QUICK_START.md)
2. Read [SYSTEM_OVERVIEW.md](SYSTEM_OVERVIEW.md)
3. Follow [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) before going live
4. Reference [testing.md](testing.md) for admin commands

### For Players
1. Interact with Promachos NPC in-game
2. Use `/profile` command to track progress
3. Reference [SYSTEM_OVERVIEW.md](SYSTEM_OVERVIEW.md) for mechanics overview

### For Developers
1. Read [overview.md](overview.md) for design philosophy
2. Review [flags.md](flags.md) for data structure
3. Check individual system docs for implementation details
4. Follow naming conventions in existing files

---

## 📋 Quick Reference

### Roles
- **FARMING** (Georgos) → Demeter → Ceres
- **MINING** (Metallourgos) → Hephaestus → Vulcan (Coming Soon)
- **COMBAT** (Hoplites) → Heracles → Mars (Coming Soon)

### Key Systems
- **Activity Tracking**: Role-gated events earn keys
- **Components**: One-time milestones unlock emblems
- **Ranks**: Tiered progression with passive buffs
- **Crates**: 5-tier loot system per god
- **Meta-Progression**: Ultra-rare Roman god crates with finite items

### Important Files
- Role data: `scripts/emblems/core/roles.dsc`
- Promachos NPC: `scripts/emblems/core/promachos.dsc`
- Demeter progression: `scripts/emblems/demeter/demeter_events.dsc`
- Rank system: `scripts/emblems/demeter/demeter_ranks.dsc`

---

## ⚠️ Critical Notes

### Before Production Deployment
**MUST REMOVE OP-ONLY GATE:**
- File: `scripts/emblems/core/promachos.dsc`
- Lines: 33-36
- See [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) Phase 4.5

### Recent Updates (2026-01-28)
- ✨ Added complete rank system documentation
- 🔧 Corrected Ceres Hoe seed consumption mechanics
- 🔧 Documented Ceres Wand advanced AI features
- 🚨 Added OP-gate removal instructions
- 📝 Aligned all docs with v2 implementation

See [DOCUMENTATION_UPDATES_2026-01-28.md](DOCUMENTATION_UPDATES_2026-01-28.md) for full changelog.

---

## 📞 Support

For questions or issues:
1. Check relevant documentation file above
2. Review [testing.md](testing.md) for troubleshooting
3. Verify implementation in `scripts/emblems/` folder

---

## 🔄 Documentation Standards

When adding new documentation:
- Place all `.md` files in `docs/` folder
- Follow existing naming conventions
- Include code examples where applicable
- Cross-reference related docs with links
- Update this README index
- Log major changes in dated update files

---

**Last Updated:** 2026-01-28
**Documentation Status:** ✅ Synchronized with v2 implementation
