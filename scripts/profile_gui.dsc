# Profile GUI Script
# Command: /profile - Opens a GUI showing the player's head, role, and progression
#
# V2: Integrated with emblem system V2
# - Shows active role
# - Shows Demeter progress (if FARMING role)
# - Links to Promachos emblem check

profile_command:
    type: command
    name: profile
    description: Opens your profile GUI
    usage: /profile
    script:
    # Temporary OP-only restriction
    - if !<player.is_op>:
        - narrate "<&e>Profile system coming soon!"
        - stop

    - run open_profile_gui

profile_inventory:
    type: inventory
    inventory: chest
    gui: true
    title: <player.name>'s Profile
    size: 45
    procedural items:
    - determine <proc[get_profile_items]>

get_profile_items:
    type: procedure
    script:
    - define items <list>
    - define filler <item[gray_stained_glass_pane].with[display_name=<&7>]>

    # Fill all slots with filler
    - repeat 45:
        - define items <[items].include[<[filler]>]>

    # Row 2: Player head (centered slot 14)
    - define head <item[<player.skull_item>].with[display_name=<&a><player.name>;lore=<&7>Welcome to your profile!|<&7>UUID<&co> <&e><player.uuid>]>
    - define items <[items].set[<[head]>].at[14]>

    # Row 3: Active role (21), Emblems (23), Bulletin (25) - centered 3-item layout
    - define role_item <proc[get_role_display_item]>
    - define items <[items].set[<[role_item]>].at[21]>

    - define emblems_item <proc[get_emblems_icon_item]>
    - define items <[items].set[<[emblems_item]>].at[23]>

    - define bulletin_item <proc[get_bulletin_icon_item]>
    - define items <[items].set[<[bulletin_item]>].at[25]>

    # Row 5: Close button (bottom left slot 37)
    - define items <[items].set[<item[profile_close_button]>].at[37]>

    - determine <[items]>

profile_close_button:
    type: item
    material: arrow
    display name: <&e>← Close
    lore:
    - <&7>Close profile

open_profile_gui:
    type: task
    script:
    - inventory open d:profile_inventory

# ============================================
# PROFILE ITEM PROCEDURES
# ============================================

get_role_display_item:
    type: procedure
    script:
    - if !<player.has_flag[role.active]>:
        - define lore <list>
        - define lore <[lore].include[<&7>You have not chosen a role yet.]>
        - define lore <[lore].include[<empty>]>
        - define lore <[lore].include[<&e>Speak to Promachos to choose.]>
        - determine <item[compass].with[display_name=<&6>No Role Selected;lore=<[lore]>]>

    - define role <player.flag[role.active]>
    - define display <proc[get_role_display_name].context[<[role]>]>
    - define god <proc[get_god_for_role].context[<[role]>]>
    - define icon <proc[get_role_icon].context[<[role]>]>

    - define lore <list>
    - define lore <[lore].include[<&a>● ACTIVE]>
    - define lore <[lore].include[<empty>]>
    - define lore <[lore].include[<&7>You serve <&e><[god]><&7>,]>
    - choose <[role]>:
        - case FARMING:
            - define lore <[lore].include[<&7>goddess of harvest.]>
        - case MINING:
            - define lore <[lore].include[<&7>god of the forge.]>
        - case COMBAT:
            - define lore <[lore].include[<&7>hero of strength.]>
    - define lore <[lore].include[<empty>]>
    - define lore <[lore].include[<&8>Change role via Promachos]>

    - determine <item[<[icon]>].with[display_name=<&6><&l><[display]><&r> <&7>(Active Role);lore=<[lore]>;enchantments=mending,1;item_flags=HIDE_ENCHANTS]>

get_emblems_icon_item:
    type: procedure
    script:
    - if !<player.has_flag[met_promachos]>:
        - determine <item[profile_emblems_locked]>

    - determine <item[profile_emblems_icon]>

# Item scripts for profile clicks
profile_emblems_locked:
    type: item
    material: gray_dye
    display name: <&8>???
    lore:
    - <&7>Speak to Promachos to begin.

profile_emblems_icon:
    type: item
    material: nether_star
    display name: <&6><&l>Emblems
    lore:
    - <&7>View your emblem progress
    - <&7>and unlock completed emblems.
    - <empty>
    - <&e>Click to view emblems
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS

get_bulletin_icon_item:
    type: procedure
    script:
    - define current_version <script[bulletin_data].data_key[version]>
    - define seen_version <player.flag[bulletin.seen_version].if_null[0]>

    - if <[seen_version]> < <[current_version]>:
        - determine <item[profile_bulletin_new]>
    - else:
        - determine <item[profile_bulletin_icon]>

profile_bulletin_icon:
    type: item
    material: writable_book
    display name: <&6>Bulletin
    lore:
    - <&7>Server news and updates
    - <empty>
    - <&e>Click to read

profile_bulletin_new:
    type: item
    material: writable_book
    display name: <&6>Bulletin
    lore:
    - <&e><&l>NEW!
    - <empty>
    - <&7>Server news and updates
    - <empty>
    - <&e>Click to read
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS

get_demeter_progress_item:
    type: procedure
    script:
    - define wheat_count <player.flag[demeter.wheat.count].if_null[0]>
    - define cows_count <player.flag[demeter.cows.count].if_null[0]>
    - define cakes_count <player.flag[demeter.cakes.count].if_null[0]>

    - define wheat_complete <player.has_flag[demeter.component.wheat]>
    - define cow_complete <player.has_flag[demeter.component.cow]>
    - define cake_complete <player.has_flag[demeter.component.cake]>

    - define lore <list>
    - define lore <[lore].include[<&e>Demeter Progress]>
    - define lore <[lore].include[<empty>]>

    # Wheat
    - if <[wheat_complete]>:
        - define lore <[lore].include[<&a>✓ Wheat: <[wheat_count]>/15,000 COMPLETE]>
    - else:
        - define percent <[wheat_count].div[15000].mul[100].round>
        - define lore <[lore].include[<&7>Wheat: <[wheat_count]>/15,000 (<[percent]>%)]>

    # Cows
    - if <[cow_complete]>:
        - define lore <[lore].include[<&a>✓ Cows: <[cows_count]>/2,000 COMPLETE]>
    - else:
        - define percent <[cows_count].div[2000].mul[100].round>
        - define lore <[lore].include[<&7>Cows: <[cows_count]>/2,000 (<[percent]>%)]>

    # Cakes
    - if <[cake_complete]>:
        - define lore <[lore].include[<&a>✓ Cakes: <[cakes_count]>/300 COMPLETE]>
    - else:
        - define percent <[cakes_count].div[300].mul[100].round>
        - define lore <[lore].include[<&7>Cakes: <[cakes_count]>/300 (<[percent]>%)]>

    - define lore <[lore].include[<empty>]>

    # Emblem status
    - if <player.has_flag[demeter.emblem.unlocked]>:
        - define lore <[lore].include[<&6>Emblem: <&a>✓ UNLOCKED]>
    - else if <[wheat_complete]> && <[cow_complete]> && <[cake_complete]>:
        - define lore <[lore].include[<&6>Emblem: <&e>⚠ READY TO UNLOCK!]>
        - define lore <[lore].include[<&e>Visit Promachos]>
    - else:
        - define components 0
        - if <[wheat_complete]>:
            - define components <[components].add[1]>
        - if <[cow_complete]>:
            - define components <[components].add[1]>
        - if <[cake_complete]>:
            - define components <[components].add[1]>
        - define lore <[lore].include[<&6>Emblem: <&7>In Progress (<[components]>/3 components)]>

    - determine <item[wheat].with[display_name=<&e><&l>Demeter;lore=<[lore]>]>

# ============================================
# PROFILE CLICK HANDLER
# ============================================

profile_click_handler:
    type: world
    debug: false
    events:
        after player clicks profile_emblems_locked in profile_inventory:
        - narrate "<&7>You must speak to <&e>Promachos <&7>first."
        - playsound <player> sound:entity_villager_no

        after player clicks profile_emblems_icon in profile_inventory:
        - inventory open d:emblem_check_gui

        after player clicks profile_bulletin_icon in profile_inventory:
        - run open_bulletin

        after player clicks profile_bulletin_new in profile_inventory:
        - run open_bulletin

        after player clicks profile_close_button in profile_inventory:
        - inventory close
