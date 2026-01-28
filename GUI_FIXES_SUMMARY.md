# GUI Navigation Fixes Summary

## Problem
GUIs were not responding to clicks because:
1. Click handlers used incorrect conditional check: `if <context.item.script.name.if_null[null]> == item:`
2. Handlers were using slot-based detection instead of item-based detection
3. Unnecessary `inventory close` + `wait 1t` before opening new GUIs

## Solution
Converted all GUI click handlers to use `after player clicks item_name in inventory_name` pattern (like bulletin system).

---

## Files Modified

### 1. scripts/profile_gui.dsc

**Item Scripts Created:**
- `profile_emblems_locked` - Gray dye for locked emblems
- `profile_emblems_icon` - Nether star for emblem access
- `profile_bulletin_icon` - Writable book for bulletin (normal)
- `profile_bulletin_new` - Writable book for bulletin (with NEW badge)
- `profile_close_button` - Barrier to close GUI

**Handler Changes:**
```yaml
# BEFORE: Slot-based with conditional check
on player clicks in profile_inventory:
- determine cancelled passively
- if <context.item.script.name.if_null[null]> == item:
    - choose <context.slot>:
        - case 22:
            - inventory close
            - wait 1t
            - inventory open d:emblem_check_gui

# AFTER: Item-based, no unnecessary closes
after player clicks profile_emblems_icon in profile_inventory:
- inventory open d:emblem_check_gui
```

### 2. scripts/emblems/core/promachos_v2.dsc

**Item Scripts Created:**
- `promachos_change_role_button` - Compass
- `promachos_check_emblems_button` - Nether star
- `promachos_system_info_button` - Book
- `promachos_farming_role_button` - Golden hoe
- `promachos_mining_role_button` - Diamond pickaxe
- `promachos_combat_role_button` - Diamond sword
- `promachos_cancel_button` - Barrier
- `emblem_check_back_button` - Arrow
- `demeter_emblem_ready` - Nether star (ready to unlock state)

**Handler Changes:**
```yaml
# Main Menu - BEFORE
on player clicks in promachos_main_menu:
- determine cancelled passively
- if <context.item.script.name.if_null[null]> == item:
    - choose <context.slot>:
        - case 11:
            - inventory close
            - wait 1t
            - inventory open d:role_selection_gui

# Main Menu - AFTER
after player clicks promachos_change_role_button in promachos_main_menu:
- inventory open d:role_selection_gui

# Role Selection - BEFORE
on player clicks in role_selection_gui:
- determine cancelled passively
- if <context.item.script.name.if_null[null]> == item:
    - choose <context.slot>:
        - case 11:
            - run set_player_role def:FARMING

# Role Selection - AFTER
after player clicks promachos_farming_role_button in role_selection_gui:
- run set_player_role def:FARMING

# Emblem Check - BEFORE
on player clicks in emblem_check_gui:
- determine cancelled passively
- if <context.slot> == 12:
    - if <proc[check_demeter_components_complete]> && !<player.has_flag[demeter.emblem.unlocked]>:
        - run demeter_emblem_unlock_ceremony

# Emblem Check - AFTER
after player clicks demeter_emblem_ready in emblem_check_gui:
- run demeter_emblem_unlock_ceremony
```

---

## Benefits

1. **More Reliable** - Item-based detection is more robust than slot-based
2. **Cleaner Code** - No conditional checks needed, direct event matching
3. **Better Performance** - No unnecessary inventory closes and waits
4. **Easier to Maintain** - Item scripts are reusable and centralized
5. **Consistent Pattern** - All GUIs now use same approach as bulletin system

---

## Testing Checklist

- [ ] `/profile` opens profile GUI
- [ ] Click Emblems icon → Opens emblem check GUI
- [ ] Click Bulletin icon → Opens bulletin
- [ ] Click Close → Closes GUI
- [ ] Click Promachos NPC → Opens main menu (first time: dialogue)
- [ ] Main menu: Change Role → Opens role selection
- [ ] Main menu: Check Emblems → Opens emblem check
- [ ] Main menu: System Info → Shows info message, closes GUI
- [ ] Role selection: Click farming/mining/combat → Sets role, closes
- [ ] Role selection: Cancel → Closes GUI
- [ ] Emblem check: Click ready emblem → Runs unlock ceremony
- [ ] Emblem check: Back → Returns to main menu
