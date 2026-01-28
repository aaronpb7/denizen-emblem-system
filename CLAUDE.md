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
- 3 roles: FARMING (Demeter), MINING (Hephaestus), COMBAT (Heracles)
- Role-based activity tracking with key rewards
- Crate system with 5 tiers (MORTAL → OLYMPIAN)
- Component milestones and rank progression
- Meta-progression via Roman god crates (Ceres, Vulcan, Mars)

**Comprehensive Documentation:**
- `SYSTEM_OVERVIEW.md` - Complete system reference
- `docs/overview.md` - Philosophy and design
- `docs/demeter.md` - Farming role details
- `docs/crates_demeter.md` - Crate system mechanics
- `docs/ceres.md` - Meta-progression
- `docs/promachos.md` - NPC interactions
- `docs/flags.md` - Flag reference
- `docs/testing.md` - Testing procedures

**Structure:**
```
scripts/
├── profile_gui.dsc       # Player profile command and GUI
├── bulletin.dsc          # Server news/updates system
└── emblems/
    ├── core/
    │   ├── roles.dsc
    │   ├── promachos_v2.dsc
    │   └── item_utilities.dsc
    ├── demeter/          # FARMING role (✅ complete)
    ├── ceres/            # FARMING meta (✅ complete)
    ├── hephaestus/       # MINING role (🚧 placeholder)
    ├── heracles/         # COMBAT role (🚧 placeholder)
    └── admin/            # Admin commands
```

**Admin Commands:**
- `/demeteradmin` - Demeter progression testing
- See `docs/testing.md` for full command reference

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
