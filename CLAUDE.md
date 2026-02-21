# Project Context

## Denizen Scripting

This project uses Denizen, a scripting language for Minecraft servers.

### Documentation
- Meta documentation: https://meta.denizenscript.com/
- Beginner guide: https://guide.denizenscript.com/

### Script Types
- `task` - Standalone executable scripts
- `command` - Custom commands
- `world` - Event handlers
- `inventory` - GUI menus
- `item` - Custom items
- `assignment` - NPC behavior
- `interact` - NPC interactions
- `procedure` - Reusable logic (returns values)

### Inventory GUIs
- Use `gui: true` to prevent players from taking items
- Slots use `[item_script_name]` or `[]` for empty
- Click handling uses world script: `after player clicks <item> in <inventory>`

### Definitions (Variables)
- Create: `- define name value`
- Use: `<[name]>`
- Only exist within script execution (short-term memory)

### Flags (Persistent Data)
- Set: `- flag <object> flag_name:value`
- Get: `<object.flag[flag_name]>`
- Check: `<object.has_flag[flag_name]>`
- Remove: `- flag <object> flag_name:!`
- Increment: `- flag <object> flag_name:++`
- Expiration: `- flag player cooldown expire:1d`
- Objects: server, player, npc, entity, location, chunk, world
- Persists across server restarts
- Submapping: `root.submap.key` for nested data

### Syntax
- 4-space indentation per level
- Commands are list items with `-`
- Command+Tag syntax (like Bash, not like Java/Python)
- `<>` = tag lookups (retrieve data)
- `<[name]>` = definition lookups
- Commands followed by space-separated arguments
- Example: `narrate "hello!" targets:<[players]>` is like `ls -la $FOLDER`
- Use colon `:` for nesting (not braces), e.g. `if <condition>:`
- Quotes surround ENTIRE arguments: `- flag player "my_flag:my value"` (correct)
- File extension: `.dsc` (not `.yml`)

### Modern Syntax (avoid outdated tutorials)
- Definitions: use `<[name]>` (not `%name%` or `<def[name]>`)
- Stop script: use `stop` (not `queue clear`)
- Flag check: use `.has_flag[]` (not `.flag[]` for existence)
- Flag expiration: `<player.flag_expiration[NAME].from_now>`

### Player Heads
- Use `<player.skull_item>` as material in item scripts - cleanest approach
- Dynamic tags work in item scripts when referenced from inventory with player context
- Alternative: `<item[player_head].with[skull_skin=<player>]>`
- Input formats: UUID only, Name only, UUID|Texture, Name|Texture, or UUID|Texture|Name
- Tags: `.skull_skin` (UUID), `.skin`, `.has_skin`

### Common Mistakes to Avoid
- Don't store data in lore/display text - use flags or script keys
- Don't compare items with `==` - use matchers or `.material.name`
- Don't hardcode coordinates - use noted locations
- Don't write raw object notation (`l@1,5,7`) - parser handles types
- Don't use `adjust` on items - use `ItemTag.with[]` or `inventory adjust`
- Don't use `== true` in conditionals - already boolean
- Don't trust player input - validate everything
- Use `.if_null[]` only when failure is expected, not everywhere

## Emblem Progression System

**Quick Reference:**
- 5 emblems: DEMETER, HEPHAESTUS, HERACLES, TRITON, CHARON
- Emblem-based activity tracking with key rewards
- Crate system with 5 tiers (MORTAL → OLYMPIAN)
- Component milestones (3 per emblem → emblem unlock)
- Player progression: 7 ranks (Uninitiated → Hemitheos), 1 rank per emblem earned
- Meta-progression via Roman god crates (Ceres, Vulcan, Mars, Neptune, Dis)

**Documentation:**
- `docs/SYSTEM_OVERVIEW.md` - Complete system reference
- `docs/STYLE.md` - Colors, sounds, message patterns, UI conventions
- `docs/EMBLEM_TEMPLATE.md` - Implementation checklist for new emblems
- `docs/demeter.md` - Demeter emblem (activities, crates)
- `docs/ceres.md` - Ceres meta-progression
- `docs/heracles.md` - Heracles emblem details
- `docs/mars.md` - Mars meta-progression
- `docs/hephaestus.md` - Hephaestus emblem details
- `docs/vulcan.md` - Vulcan meta-progression
- `docs/triton.md` - Triton emblem (Tier 2, activities, crates)
- `docs/neptune.md` - Neptune meta-progression
- `docs/charon.md` - Charon emblem (Tier 2, activities, crates)
- `docs/dis.md` - Dis meta-progression
- `docs/promachos.md` - NPC interactions
- `docs/flags.md` - Flag reference
- `docs/testing.md` - Testing procedures and admin commands

**Structure:**
```
scripts/
├── profile_gui.dsc         # Player profile command and GUI
├── bulletin.dsc            # Server news/updates system
├── server_events.dsc       # Join handlers, daily restart
├── server_restrictions.dsc # Server rules/restrictions
└── emblems/
    ├── core/
    │   ├── roles.dsc           # Emblem definitions
    │   ├── promachos.dsc       # NPC interactions
    │   ├── crafting.dsc        # Mythic Forge crafting system
    │   └── item_utilities.dsc  # Shared item helpers
    ├── demeter/            # DEMETER emblem + Ceres meta
    │   ├── demeter_events.dsc
    │   ├── demeter_items.dsc
    │   ├── demeter_crate.dsc
    │   ├── demeter_blessing.dsc
    │   ├── ceres_items.dsc
    │   ├── ceres_crate.dsc
    │   └── ceres_mechanics.dsc
    ├── heracles/           # HERACLES emblem + Mars meta
    │   ├── heracles_events.dsc
    │   ├── heracles_items.dsc
    │   ├── heracles_crate.dsc
    │   ├── heracles_blessing.dsc
    │   ├── mars_items.dsc
    │   └── mars_crate.dsc
    ├── hephaestus/         # HEPHAESTUS emblem + Vulcan meta
    │   ├── hephaestus_events.dsc
    │   ├── hephaestus_items.dsc
    │   ├── hephaestus_crate.dsc
    │   ├── hephaestus_blessing.dsc
    │   ├── vulcan_items.dsc
    │   └── vulcan_crate.dsc
    ├── triton/             # TRITON emblem (Tier 2) + Neptune meta
    │   ├── triton_npc.dsc
    │   ├── triton_events.dsc
    │   ├── triton_items.dsc
    │   ├── triton_crate.dsc
    │   ├── triton_blessing.dsc
    │   ├── neptune_items.dsc
    │   └── neptune_crate.dsc
    ├── charon/             # CHARON emblem (Tier 2) + Dis meta
    │   ├── charon_npc.dsc
    │   ├── charon_events.dsc
    │   ├── charon_items.dsc
    │   ├── charon_crate.dsc
    │   ├── charon_blessing.dsc
    │   ├── dis_items.dsc
    │   ├── dis_crate.dsc
    │   └── dis_mechanics.dsc
    └── admin/
        ├── admin_commands.dsc
        └── migration.dsc
```

**Admin Commands:**
- `/emblemadmin` - Set player emblem
- `/demeteradmin` - Demeter progression
- `/heraclesadmin` - Heracles progression
- `/hephaestusadmin` - Hephaestus progression
- `/rankadmin` - View/set emblem rank
- `/ceresadmin` - Ceres items
- `/marsadmin` - Mars items
- `/vulcanadmin` - Vulcan items
- `/tritonadmin` - Triton progression
- `/neptuneadmin` - Neptune items
- `/charonadmin` - Charon progression
- `/disadmin` - Dis items
- `/checkkeys` - View key tracking
- `/testroll` - Simulate crate rolls
- `/emblemreset` - Full player reset
- `/invsee` - View player inventory (offline support)
- `/endersee` - View player ender chest (offline support)

See `docs/testing.md` for full command reference.

## Bulletin System

Server news and updates shown via `/profile`.

### How It Works
- `bulletin_data` script holds current version number
- On join, compares player's `bulletin.seen_version` flag to current version
- If outdated, shows title/subtitle prompting `/profile`
- Bulletin icon in profile shows `NEW!` badge with glint if unread
- Opening bulletin marks it as seen

### Adding New Updates
1. Increment `version` in `bulletin_data` script
2. Add new item(s) to `bulletin_inventory` slots
3. All players will see notification on next join

### Flag Pattern
```
bulletin.seen_version (int) - last bulletin version player viewed
```

### Emblem Flags
```
emblem.active (string)   - active emblem: "DEMETER", "HEPHAESTUS", "HERACLES", or "TRITON"
emblem.rank (int)        - increments each time an emblem is unlocked
emblem.migrated (bool)   - whether player has been migrated from old role.active system
```
