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
    debug: false
    script:
    - run open_profile_gui

profile_inventory:
    type: inventory
    inventory: chest
    gui: true
    debug: false
    title: <&8><player.name>'s Profile
    size: 45
    procedural items:
    - determine <proc[get_profile_items]>

get_profile_items:
    type: procedure
    debug: false
    script:
    - define items <list>
    - define filler <item[gray_stained_glass_pane].with[display=<empty>]>

    # Fill all slots with filler
    - repeat 45:
        - define items <[items].include[<[filler]>]>

    # Row 1: Player head (centered slot 5)
    - define head <item[<player.skull_item>].with[display=<&2><player.name>;lore=<&7>Welcome to your profile!|<&7>UUID<&co> <&e><player.uuid>]>
    - define items <[items].set[<[head]>].at[5]>

    # Row 3: Active role (19), Ranks (21), Emblems (23), Cosmetics (25), Bulletin (27) - centered 5-item layout
    - define role_item <proc[get_role_display_item]>
    - define items <[items].set[<[role_item]>].at[19]>

    - define ranks_item <proc[get_ranks_icon_item]>
    - define items <[items].set[<[ranks_item]>].at[21]>

    - define emblems_item <proc[get_emblems_icon_item]>
    - define items <[items].set[<[emblems_item]>].at[23]>

    - define cosmetics_item <proc[get_cosmetics_icon_item]>
    - define items <[items].set[<[cosmetics_item]>].at[25]>

    - define bulletin_item <proc[get_bulletin_icon_item]>
    - define items <[items].set[<[bulletin_item]>].at[27]>

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
    debug: false
    script:
    - inventory open d:profile_inventory

# ============================================
# PROFILE ITEM PROCEDURES
# ============================================

get_role_display_item:
    type: procedure
    debug: false
    script:
    - if !<player.has_flag[role.active]>:
        - define lore <list>
        - define lore <[lore].include[<&7><&o>"Three paths diverge before you..."]>
        - define lore <[lore].include[<empty>]>
        - define lore <[lore].include[<&7>You have not chosen a role yet.]>
        - define lore <[lore].include[<empty>]>
        - define lore <[lore].include[<&e>Speak to Promachos to choose]>
        - determine <item[compass].with[display=<&6>No Role Selected;lore=<[lore]>]>

    - define role <player.flag[role.active]>
    - define display <proc[get_role_display_name].context[<[role]>]>
    - define god <proc[get_god_for_role].context[<[role]>]>
    - define icon <proc[get_role_icon].context[<[role]>]>

    - define lore <list>
    - choose <[role]>:
        - case FARMING:
            - define lore <[lore].include[<&e>Patron<&co> <&6><[god]><&7>, Goddess of Harvest]>
            - define lore "<[lore].include[<&sp>]>"

            # Show actual progress stats
            - define wheat <player.flag[demeter.wheat.count].if_null[0]>
            - define cows <player.flag[demeter.cows.count].if_null[0]>
            - define cakes <player.flag[demeter.cakes.count].if_null[0]>
            - define keys <player.flag[demeter.wheat.keys_awarded].if_null[0].add[<player.flag[demeter.cows.keys_awarded].if_null[0]>].add[<player.flag[demeter.cakes.keys_awarded].if_null[0]>]>
            - define xp <player.flag[farming.xp].if_null[0]>
            - define rank <player.flag[farming.rank].if_null[0]>

            - define lore <[lore].include[<&6>Your Progress<&co>]>
            - define lore <[lore].include[<&7>• Wheat harvested<&co> <&e><[wheat].format_number>]>
            - define lore <[lore].include[<&7>• Cows bred<&co> <&e><[cows].format_number>]>
            - define lore <[lore].include[<&7>• Cakes crafted<&co> <&e><[cakes].format_number>]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&6>Keys earned<&co> <&e><[keys]> <&7>Demeter Keys]>
            - define lore <[lore].include[<&6>Farming XP<&co> <&e><[xp].format_number> <&7>XP]>

            # Show rank if they have one
            - if <[rank]> > 0:
                - define rank_name <proc[get_farming_rank_name].context[<[rank]>]>
                - define lore <[lore].include[<&6>Rank<&co> <&e><[rank_name]>]>
            - else:
                - define lore <[lore].include[<&6>Rank<&co> <&7>Unranked]>

        - case MINING:
            - define lore <[lore].include[<&e>Patron<&co> <&6><[god]><&7>, God of the Forge]>
            - define lore "<[lore].include[<&sp>]>"

            # Show actual progress stats
            - define iron <player.flag[hephaestus.iron.count].if_null[0]>
            - define smelting <player.flag[hephaestus.smelting.count].if_null[0]>
            - define golems <player.flag[hephaestus.golems.count].if_null[0]>
            - define keys <player.flag[hephaestus.iron.keys_awarded].if_null[0].add[<player.flag[hephaestus.smelting.keys_awarded].if_null[0]>].add[<player.flag[hephaestus.golems.keys_awarded].if_null[0]>]>
            - define xp <player.flag[mining.xp].if_null[0]>
            - define rank <player.flag[mining.rank].if_null[0]>

            - define lore <[lore].include[<&7>Your Progress<&co>]>
            - define lore <[lore].include[<&8>• Iron ore mined<&co> <&f><[iron].format_number>]>
            - define lore <[lore].include[<&8>• Items smelted<&co> <&f><[smelting].format_number>]>
            - define lore <[lore].include[<&8>• Golems created<&co> <&f><[golems].format_number>]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&7>Keys earned<&co> <&f><[keys]> <&8>Hephaestus Keys]>
            - define lore <[lore].include[<&7>Mining XP<&co> <&f><[xp].format_number> <&8>XP]>

            # Show rank if they have one
            - if <[rank]> > 0:
                - define rank_name <proc[get_mining_rank_name].context[<[rank]>]>
                - define lore <[lore].include[<&7>Rank<&co> <&f><[rank_name]>]>
            - else:
                - define lore <[lore].include[<&7>Rank<&co> <&8>Unranked]>
        - case COMBAT:
            - define lore <[lore].include[<&e>Patron<&co> <&6><[god]><&7>, Hero of Strength]>
            - define lore "<[lore].include[<&sp>]>"

            # Show actual progress stats
            - define pillagers <player.flag[heracles.pillagers.count].if_null[0]>
            - define raids <player.flag[heracles.raids.count].if_null[0]>
            - define emeralds <player.flag[heracles.emeralds.count].if_null[0]>
            - define keys_pil <player.flag[heracles.pillagers.keys_awarded].if_null[0]>
            - define keys_raid <player.flag[heracles.raids.count].if_null[0].mul[2]>
            - define keys_em <player.flag[heracles.emeralds.keys_awarded].if_null[0]>
            - define keys <[keys_pil].add[<[keys_raid]>].add[<[keys_em]>]>
            - define xp <player.flag[heracles.xp].if_null[0]>
            - define rank <proc[get_combat_rank_from_xp].context[<[xp]>]>

            - define lore <[lore].include[<&c>Your<&sp>Progress<&co>]>
            - define lore <[lore].include[<&7>•<&sp>Pillagers<&sp>slain<&co><&sp><&c><[pillagers].format_number>]>
            - define lore <[lore].include[<&7>•<&sp>Raids<&sp>defended<&co><&sp><&c><[raids].format_number>]>
            - define lore <[lore].include[<&7>•<&sp>Emeralds<&sp>traded<&co><&sp><&c><[emeralds].format_number>]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&c>Keys<&sp>earned<&co><&sp><&c><[keys]><&sp><&7>Heracles<&sp>Keys]>
            - define lore <[lore].include[<&c>Combat<&sp>XP<&co><&sp><&c><[xp].format_number><&sp><&7>XP]>

            # Show rank if they have one
            - if <[rank]> > 0:
                - define rank_name <proc[get_combat_rank_name].context[<[rank]>]>
                - define lore <[lore].include[<&c>Rank<&co><&sp><&c><[rank_name]>]>
            - else:
                - define lore <[lore].include[<&c>Rank<&co><&sp><&7>Unranked]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&8>Change role by speaking to Promachos]>

    - determine <item[<[icon]>].with[display=<&6><&l><[display]>;lore=<[lore]>;enchantments=mending,1;hides=ALL]>

get_ranks_icon_item:
    type: procedure
    debug: false
    script:
    - define active_role <player.flag[role.active].if_null[NONE]>

    # Show farming ranks if FARMING role
    - if <[active_role]> == FARMING:
        - define xp <player.flag[farming.xp].if_null[0]>
        - define rank <proc[get_farming_rank].context[<[xp]>]>
        - define rank_name <proc[get_farming_rank_name].context[<[rank]>]>

        - define lore <list>
        - if <[rank]> == 0:
            - define lore <[lore].include[<&7>No rank achieved yet]>
            - define lore <[lore].include[<empty>]>
            - define lore <[lore].include[<&e>Start farming to gain XP!]>
        - else:
            - define lore <[lore].include[<&6>Current Rank<&co> <&e><[rank_name]>]>
            - define lore <[lore].include[<empty>]>
            - define lore <[lore].include[<&7>Total XP<&co> <&e><[xp].format_number>]>
        - define lore <[lore].include[<empty>]>
        - define lore <[lore].include[<&e>Click to view ranks]>

        - if <[rank]> > 0:
            - determine <item[experience_bottle].with[display=<&6><&l>Farming Ranks;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
        - else:
            - determine <item[experience_bottle].with[display=<&6><&l>Farming Ranks;lore=<[lore]>]>

    # Show combat ranks if COMBAT role
    - else if <[active_role]> == COMBAT:
        - define xp <player.flag[heracles.xp].if_null[0]>
        - define rank <proc[get_combat_rank_from_xp].context[<[xp]>]>
        - define rank_name <proc[get_combat_rank_name].context[<[rank]>]>

        - define lore <list>
        - if <[rank]> == 0:
            - define lore <[lore].include[<&7>No<&sp>rank<&sp>achieved<&sp>yet]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&e>Start<&sp>fighting<&sp>to<&sp>gain<&sp>XP!]>
        - else:
            - define lore <[lore].include[<&c>Current<&sp>Rank<&co><&sp><&c><[rank_name]>]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&7>Total<&sp>XP<&co><&sp><&c><[xp].format_number>]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&e>Click<&sp>to<&sp>view<&sp>ranks]>

        - if <[rank]> > 0:
            - determine <item[experience_bottle].with[display=<&c><&l>Combat Ranks;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
        - else:
            - determine <item[experience_bottle].with[display=<&c><&l>Combat Ranks;lore=<[lore]>]>

    # Show mining ranks if MINING role
    - else if <[active_role]> == MINING:
        - define xp <player.flag[mining.xp].if_null[0]>
        - define rank <proc[get_mining_rank].context[<[xp]>]>
        - define rank_name <proc[get_mining_rank_name].context[<[rank]>]>

        - define lore <list>
        - if <[rank]> == 0:
            - define lore <[lore].include[<&8>No rank achieved yet]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&f>Start mining to gain XP!]>
        - else:
            - define lore <[lore].include[<&7>Current Rank<&co> <&f><[rank_name]>]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&8>Total XP<&co> <&f><[xp].format_number>]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&f>Click to view ranks]>

        - if <[rank]> > 0:
            - determine <item[experience_bottle].with[display=<&8><&l>Mining Ranks;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
        - else:
            - determine <item[experience_bottle].with[display=<&8><&l>Mining Ranks;lore=<[lore]>]>

    # No role selected - show generic message
    - else:
        - define lore <list>
        - define lore <[lore].include[<&7>Choose<&sp>a<&sp>role<&sp>to<&sp>view<&sp>ranks]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&e>Speak<&sp>to<&sp>Promachos]>
        - determine <item[experience_bottle].with[display=<&7><&l>Skill<&sp>Ranks;lore=<[lore]>]>

get_emblems_icon_item:
    type: procedure
    debug: false
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
    debug: false
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
    debug: false
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
        - define lore <[lore].include[<&2>✓ Wheat: <[wheat_count]>/15,000 COMPLETE]>
    - else:
        - define percent <[wheat_count].div[15000].mul[100].round>
        - define lore <[lore].include[<&7>Wheat: <[wheat_count]>/15,000 (<[percent]>%)]>

    # Cows
    - if <[cow_complete]>:
        - define lore <[lore].include[<&2>✓ Cows: <[cows_count]>/2,000 COMPLETE]>
    - else:
        - define percent <[cows_count].div[2000].mul[100].round>
        - define lore <[lore].include[<&7>Cows: <[cows_count]>/2,000 (<[percent]>%)]>

    # Cakes
    - if <[cake_complete]>:
        - define lore <[lore].include[<&2>✓ Cakes: <[cakes_count]>/500 COMPLETE]>
    - else:
        - define percent <[cakes_count].div[500].mul[100].round>
        - define lore <[lore].include[<&7>Cakes: <[cakes_count]>/500 (<[percent]>%)]>

    - define lore <[lore].include[<empty>]>

    # Emblem status
    - if <player.has_flag[demeter.emblem.unlocked]>:
        - define lore <[lore].include[<&6>Emblem: <&2>✓ UNLOCKED]>
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

    - determine <item[wheat].with[display=<&e><&l>Demeter;lore=<[lore]>]>

# ============================================
# PROFILE CLICK HANDLER
# ============================================

profile_click_handler:
    type: world
    debug: false
    events:
        after player clicks experience_bottle in profile_inventory:
        - define active_role <player.flag[role.active].if_null[NONE]>
        - if <[active_role]> == FARMING:
            - inventory open d:farming_ranks_gui
        - else if <[active_role]> == COMBAT:
            - inventory open d:combat_ranks_gui
        - else if <[active_role]> == MINING:
            - inventory open d:mining_ranks_gui
        - else:
            - narrate "<&7>Choose a role first by speaking to Promachos"
            - playsound <player> sound:entity_villager_no

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

        # Emblem check GUI clicks
        after player clicks item in emblem_check_gui:
        # Check if clicking Demeter emblem (wheat item)
        - if <context.item.material.name> == wheat:
            - inventory open d:demeter_progress_gui
        # Check if clicking Heracles emblem (diamond sword item)
        - else if <context.item.material.name> == diamond_sword:
            - inventory open d:heracles_progress_gui
        # Check if clicking Hephaestus emblem (iron pickaxe item)
        - else if <context.item.material.name> == iron_pickaxe:
            - inventory open d:hephaestus_progress_gui

        after player clicks emblem_check_back_button in emblem_check_gui:
        - inventory open d:profile_inventory

        # Demeter progress GUI clicks
        after player clicks demeter_progress_back_button in demeter_progress_gui:
        - inventory open d:emblem_check_gui

        # Heracles progress GUI clicks
        after player clicks heracles_progress_back_button in heracles_progress_gui:
        - inventory open d:emblem_check_gui

        # Hephaestus progress GUI clicks
        after player clicks hephaestus_progress_back_button in hephaestus_progress_gui:
        - inventory open d:emblem_check_gui

# ============================================
# DEMETER DETAILED PROGRESS GUI
# ============================================

demeter_progress_gui:
    type: inventory
    inventory: chest
    gui: true
    debug: false
    title: <&8>Demeter - Activity Progress
    size: 27
    procedural items:
    - determine <proc[get_demeter_progress_items]>

get_demeter_progress_items:
    type: procedure
    debug: false
    script:
    - define items <list>
    - define filler <item[gray_stained_glass_pane].with[display=<empty>]>

    # Fill all slots
    - repeat 27:
        - define items <[items].include[<[filler]>]>

    # Row 2: Three activity items centered (slots 12, 14, 16)
    - define wheat_item <proc[get_demeter_wheat_progress_item]>
    - define items <[items].set[<[wheat_item]>].at[12]>

    - define cow_item <proc[get_demeter_cow_progress_item]>
    - define items <[items].set[<[cow_item]>].at[14]>

    - define cake_item <proc[get_demeter_cake_progress_item]>
    - define items <[items].set[<[cake_item]>].at[16]>

    # Back button (bottom left slot 19)
    - define items <[items].set[<item[demeter_progress_back_button]>].at[19]>

    - determine <[items]>

get_demeter_wheat_progress_item:
    type: procedure
    debug: false
    script:
    - define count <player.flag[demeter.wheat.count].if_null[0]>
    - define keys <player.flag[demeter.wheat.keys_awarded].if_null[0]>
    - define complete <player.has_flag[demeter.component.wheat]>

    - define lore <list>
    - if <[complete]>:
        - define lore <[lore].include[<&2><&l>✓ COMPONENT COMPLETE]>
    - else:
        - define lore <[lore].include[<&7>Component In Progress]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7><&o>"Reap golden stalks beneath endless skies"]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&e>Task<&co> <&7>Harvest fully grown wheat from]>
    - define lore <[lore].include[<&7>your fields. Each stalk brings you closer]>
    - define lore <[lore].include[<&7>to Demeter's favor.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&6>Component Progress<&co>]>
    - define lore <[lore].include[<&7><[count]> / 15,000 wheat harvested]>
    - if <[complete]>:
        - define percent 100
    - else:
        - define percent <[count].div[15000].mul[100].round>
    - define lore <[lore].include[<&7>(<[percent]>% complete)]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&8><&o>Component progress is independent]>
    - define lore <[lore].include[<&8><&o>from Farming XP ranks.]>

    - if <[complete]>:
        - determine <item[wheat].with[display=<&e><&l>Wheat Harvest;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - else:
        - determine <item[wheat].with[display=<&e><&l>Wheat Harvest;lore=<[lore]>]>

get_demeter_cow_progress_item:
    type: procedure
    debug: false
    script:
    - define count <player.flag[demeter.cows.count].if_null[0]>
    - define keys <player.flag[demeter.cows.keys_awarded].if_null[0]>
    - define complete <player.has_flag[demeter.component.cow]>

    - define lore <list>
    - if <[complete]>:
        - define lore <[lore].include[<&2><&l>✓ COMPONENT COMPLETE]>
    - else:
        - define lore <[lore].include[<&7>Component In Progress]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7><&o>"Shepherd the sacred herds of the goddess"]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&e>Task<&co> <&7>Breed cows to grow your herds.]>
    - define lore <[lore].include[<&7>Each new calf born under your care]>
    - define lore <[lore].include[<&7>honors the cycle of life.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&6>Component Progress<&co>]>
    - define lore <[lore].include[<&7><[count]> / 2,000 cows bred]>
    - if <[complete]>:
        - define percent 100
    - else:
        - define percent <[count].div[2000].mul[100].round>
    - define lore <[lore].include[<&7>(<[percent]>% complete)]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&8><&o>Component progress is independent]>
    - define lore <[lore].include[<&8><&o>from Farming XP ranks.]>

    - if <[complete]>:
        - determine <item[leather].with[display=<&e><&l>Cow Breeding;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - else:
        - determine <item[leather].with[display=<&e><&l>Cow Breeding;lore=<[lore]>]>

get_demeter_cake_progress_item:
    type: procedure
    debug: false
    script:
    - define count <player.flag[demeter.cakes.count].if_null[0]>
    - define keys <player.flag[demeter.cakes.keys_awarded].if_null[0]>
    - define complete <player.has_flag[demeter.component.cake]>

    - define lore <list>
    - if <[complete]>:
        - define lore <[lore].include[<&2><&l>✓ COMPONENT COMPLETE]>
    - else:
        - define lore <[lore].include[<&7>Component In Progress]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7><&o>"Craft delicacies fit for divine feasts"]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&e>Task<&co> <&7>Craft cakes from the harvest]>
    - define lore <[lore].include[<&7>of your labors. Transform raw bounty]>
    - define lore <[lore].include[<&7>into artisan creations.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&6>Component Progress<&co>]>
    - define lore <[lore].include[<&7><[count]> / 500 cakes crafted]>
    - if <[complete]>:
        - define percent 100
    - else:
        - define percent <[count].div[500].mul[100].round>
    - define lore <[lore].include[<&7>(<[percent]>% complete)]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&8><&o>Component progress is independent]>
    - define lore <[lore].include[<&8><&o>from Farming XP ranks.]>

    - if <[complete]>:
        - determine <item[cake].with[display=<&e><&l>Cake Crafting;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - else:
        - determine <item[cake].with[display=<&e><&l>Cake Crafting;lore=<[lore]>]>

demeter_progress_back_button:
    type: item
    material: arrow
    display name: <&e>← Back
    lore:
    - <&7>Return<&sp>to<&sp>emblems

# ============================================
# HERACLES DETAILED PROGRESS GUI
# ============================================

heracles_progress_gui:
    type: inventory
    inventory: chest
    gui: true
    debug: false
    title: <&8>Heracles - Activity Progress
    size: 27
    procedural items:
    - determine <proc[get_heracles_progress_items]>

get_heracles_progress_items:
    type: procedure
    debug: false
    script:
    - define items <list>
    - define filler <item[gray_stained_glass_pane].with[display=<empty>]>

    # Fill all slots
    - repeat 27:
        - define items <[items].include[<[filler]>]>

    # Row 2: Three activity items centered (slots 12, 14, 16)
    - define pillagers_item <proc[get_heracles_pillagers_progress_item]>
    - define items <[items].set[<[pillagers_item]>].at[12]>

    - define raids_item <proc[get_heracles_raids_progress_item]>
    - define items <[items].set[<[raids_item]>].at[14]>

    - define emeralds_item <proc[get_heracles_emeralds_progress_item]>
    - define items <[items].set[<[emeralds_item]>].at[16]>

    # Back button (bottom left slot 19)
    - define items <[items].set[<item[heracles_progress_back_button]>].at[19]>

    - determine <[items]>

get_heracles_pillagers_progress_item:
    type: procedure
    debug: false
    script:
    - define count <player.flag[heracles.pillagers.count].if_null[0]>
    - define keys <player.flag[heracles.pillagers.keys_awarded].if_null[0]>
    - define complete <player.has_flag[heracles.component.pillagers]>

    - define lore <list>
    - if <[complete]>:
        - define lore <[lore].include[<&2><&l>✓<&sp>COMPONENT<&sp>COMPLETE]>
    - else:
        - define lore <[lore].include[<&7>Component<&sp>In<&sp>Progress]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7><&o>"Strike<&sp>down<&sp>the<&sp>raiders<&sp>who<&sp>threaten<&sp>peace"]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&c>Task<&co><&sp><&7>Defeat<&sp>pillagers<&sp>that<&sp>roam<&sp>the<&sp>land.]>
    - define lore <[lore].include[<&7>Each<&sp>marauder<&sp>slain<&sp>brings<&sp>justice<&sp>and]>
    - define lore <[lore].include[<&7>earns<&sp>the<&sp>hero's<&sp>respect.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&c>Component<&sp>Progress<&co>]>
    - define lore <[lore].include[<&7><[count]><&sp>/<&sp>2,500<&sp>pillagers<&sp>slain]>
    - if <[complete]>:
        - define percent 100
    - else:
        - define percent <[count].div[2500].mul[100].round>
    - define lore <[lore].include[<&7>(<[percent]>%<&sp>complete)]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&8><&o>Component<&sp>progress<&sp>is<&sp>independent]>
    - define lore <[lore].include[<&8><&o>from<&sp>Combat<&sp>XP<&sp>ranks.]>

    - if <[complete]>:
        - determine <item[iron_sword].with[display=<&c><&l>Pillager<&sp>Slayer;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - else:
        - determine <item[iron_sword].with[display=<&c><&l>Pillager<&sp>Slayer;lore=<[lore]>]>

get_heracles_raids_progress_item:
    type: procedure
    debug: false
    script:
    - define count <player.flag[heracles.raids.count].if_null[0]>
    - define complete <player.has_flag[heracles.component.raids]>

    - define lore <list>
    - if <[complete]>:
        - define lore <[lore].include[<&2><&l>✓<&sp>COMPONENT<&sp>COMPLETE]>
    - else:
        - define lore <[lore].include[<&7>Component<&sp>In<&sp>Progress]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7><&o>"Stand<&sp>as<&sp>shield<&sp>between<&sp>chaos<&sp>and<&sp>home"]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&c>Task<&co><&sp><&7>Defend<&sp>villages<&sp>from<&sp>illager<&sp>raids.]>
    - define lore <[lore].include[<&7>Every<&sp>victory<&sp>preserves<&sp>innocent<&sp>lives]>
    - define lore <[lore].include[<&7>and<&sp>proves<&sp>your<&sp>heroism.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&c>Component<&sp>Progress<&co>]>
    - define lore <[lore].include[<&7><[count]><&sp>/<&sp>50<&sp>raids<&sp>defended]>
    - if <[complete]>:
        - define percent 100
    - else:
        - define percent <[count].div[50].mul[100].round>
    - define lore <[lore].include[<&7>(<[percent]>%<&sp>complete)]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&8><&o>Component<&sp>progress<&sp>is<&sp>independent]>
    - define lore <[lore].include[<&8><&o>from<&sp>Combat<&sp>XP<&sp>ranks.]>

    - if <[complete]>:
        - determine <item[shield].with[display=<&c><&l>Raid<&sp>Victor;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - else:
        - determine <item[shield].with[display=<&c><&l>Raid<&sp>Victor;lore=<[lore]>]>

get_heracles_emeralds_progress_item:
    type: procedure
    debug: false
    script:
    - define count <player.flag[heracles.emeralds.count].if_null[0]>
    - define keys <player.flag[heracles.emeralds.keys_awarded].if_null[0]>
    - define complete <player.has_flag[heracles.component.emeralds]>

    - define lore <list>
    - if <[complete]>:
        - define lore <[lore].include[<&2><&l>✓<&sp>COMPONENT<&sp>COMPLETE]>
    - else:
        - define lore <[lore].include[<&7>Component<&sp>In<&sp>Progress]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7><&o>"Forge<&sp>bonds<&sp>of<&sp>commerce<&sp>and<&sp>prosperity"]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&c>Task<&co><&sp><&7>Trade<&sp>emeralds<&sp>with<&sp>villagers.]>
    - define lore <[lore].include[<&7>Each<&sp>transaction<&sp>strengthens<&sp>the<&sp>bonds]>
    - define lore <[lore].include[<&7>between<&sp>warrior<&sp>and<&sp>community.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&c>Component<&sp>Progress<&co>]>
    - define lore <[lore].include[<&7><[count]><&sp>/<&sp>10,000<&sp>emeralds<&sp>spent]>
    - if <[complete]>:
        - define percent 100
    - else:
        - define percent <[count].div[10000].mul[100].round>
    - define lore <[lore].include[<&7>(<[percent]>%<&sp>complete)]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&8><&o>Component<&sp>progress<&sp>is<&sp>independent]>
    - define lore <[lore].include[<&8><&o>from<&sp>Combat<&sp>XP<&sp>ranks.]>

    - if <[complete]>:
        - determine <item[emerald].with[display=<&c><&l>Trade<&sp>Master;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - else:
        - determine <item[emerald].with[display=<&c><&l>Trade<&sp>Master;lore=<[lore]>]>

heracles_progress_back_button:
    type: item
    material: arrow
    display name: <&e>← Back
    lore:
    - <&7>Return<&sp>to<&sp>emblems

# ============================================
# HEPHAESTUS DETAILED PROGRESS GUI
# ============================================

hephaestus_progress_gui:
    type: inventory
    inventory: chest
    gui: true
    debug: false
    title: <&8>Hephaestus - Activity Progress
    size: 27
    procedural items:
    - determine <proc[get_hephaestus_progress_items]>

get_hephaestus_progress_items:
    type: procedure
    debug: false
    script:
    - define items <list>
    - define filler <item[gray_stained_glass_pane].with[display=<empty>]>

    # Fill all slots
    - repeat 27:
        - define items <[items].include[<[filler]>]>

    # Row 2: Three activity items centered (slots 12, 14, 16)
    - define iron_item <proc[get_hephaestus_iron_progress_item]>
    - define items <[items].set[<[iron_item]>].at[12]>

    - define smelting_item <proc[get_hephaestus_smelting_progress_item]>
    - define items <[items].set[<[smelting_item]>].at[14]>

    - define golem_item <proc[get_hephaestus_golem_progress_item]>
    - define items <[items].set[<[golem_item]>].at[16]>

    # Back button (bottom left slot 19)
    - define items <[items].set[<item[hephaestus_progress_back_button]>].at[19]>

    - determine <[items]>

get_hephaestus_iron_progress_item:
    type: procedure
    debug: false
    script:
    - define count <player.flag[hephaestus.iron.count].if_null[0]>
    - define keys <player.flag[hephaestus.iron.keys_awarded].if_null[0]>
    - define complete <player.has_flag[hephaestus.component.iron]>

    - define lore <list>
    - if <[complete]>:
        - define lore <[lore].include[<&2><&l>✓ COMPONENT COMPLETE]>
    - else:
        - define lore <[lore].include[<&7>Component In Progress]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7><&o>"Strike the earth and claim its hidden treasures"]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&8>Task<&co> <&7>Mine iron ore from the depths.]>
    - define lore <[lore].include[<&7>Each vein broken brings you closer]>
    - define lore <[lore].include[<&7>to the Forge God's blessing.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&8>Component Progress<&co>]>
    - define lore <[lore].include[<&7><[count]> / 5,000 iron ore mined]>
    - if <[complete]>:
        - define percent 100
    - else:
        - define percent <[count].div[5000].mul[100].round>
    - define lore <[lore].include[<&7>(<[percent]>% complete)]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7><&o>Component progress is independent]>
    - define lore <[lore].include[<&7><&o>from Mining XP ranks.]>

    - if <[complete]>:
        - determine <item[iron_ore].with[display=<&8><&l>Iron Mining;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - else:
        - determine <item[iron_ore].with[display=<&8><&l>Iron Mining;lore=<[lore]>]>

get_hephaestus_smelting_progress_item:
    type: procedure
    debug: false
    script:
    - define count <player.flag[hephaestus.smelting.count].if_null[0]>
    - define keys <player.flag[hephaestus.smelting.keys_awarded].if_null[0]>
    - define complete <player.has_flag[hephaestus.component.smelting]>

    - define lore <list>
    - if <[complete]>:
        - define lore <[lore].include[<&2><&l>✓ COMPONENT COMPLETE]>
    - else:
        - define lore <[lore].include[<&7>Component In Progress]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7><&o>"Transform raw ore in the sacred flames"]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&8>Task<&co> <&7>Smelt items in the blast furnace.]>
    - define lore <[lore].include[<&7>The forge's heat purifies metal]>
    - define lore <[lore].include[<&7>and pleases Hephaestus.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&8>Component Progress<&co>]>
    - define lore <[lore].include[<&7><[count]> / 5,000 items smelted]>
    - if <[complete]>:
        - define percent 100
    - else:
        - define percent <[count].div[5000].mul[100].round>
    - define lore <[lore].include[<&7>(<[percent]>% complete)]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7><&o>Component progress is independent]>
    - define lore <[lore].include[<&7><&o>from Mining XP ranks.]>

    - if <[complete]>:
        - determine <item[blast_furnace].with[display=<&8><&l>Forge Smelting;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - else:
        - determine <item[blast_furnace].with[display=<&8><&l>Forge Smelting;lore=<[lore]>]>

get_hephaestus_golem_progress_item:
    type: procedure
    debug: false
    script:
    - define count <player.flag[hephaestus.golems.count].if_null[0]>
    - define keys <player.flag[hephaestus.golems.keys_awarded].if_null[0]>
    - define complete <player.has_flag[hephaestus.component.golem]>

    - define lore <list>
    - if <[complete]>:
        - define lore <[lore].include[<&2><&l>✓ COMPONENT COMPLETE]>
    - else:
        - define lore <[lore].include[<&7>Component In Progress]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7><&o>"Breathe life into iron sentinels"]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&8>Task<&co> <&7>Create iron golems to guard]>
    - define lore <[lore].include[<&7>villages. Each construct is a tribute]>
    - define lore <[lore].include[<&7>to divine craftsmanship.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&8>Component Progress<&co>]>
    - define lore <[lore].include[<&7><[count]> / 100 golems created]>
    - if <[complete]>:
        - define percent 100
    - else:
        - define percent <[count].div[100].mul[100].round>
    - define lore <[lore].include[<&7>(<[percent]>% complete)]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7><&o>Component progress is independent]>
    - define lore <[lore].include[<&7><&o>from Mining XP ranks.]>

    - if <[complete]>:
        - determine <item[carved_pumpkin].with[display=<&8><&l>Golem Crafting;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - else:
        - determine <item[carved_pumpkin].with[display=<&8><&l>Golem Crafting;lore=<[lore]>]>

hephaestus_progress_back_button:
    type: item
    material: arrow
    display name: <&e>← Back
    lore:
    - <&7>Return<&sp>to<&sp>emblems

create_progress_bar:
    type: procedure
    debug: false
    definitions: percent
    script:
    - define total_bars 10
    - define filled <[percent].div[10].round_down>
    - define empty <[total_bars].sub[<[filled]>]>
    - define bar ""
    - repeat <[filled]>:
        - define bar "<[bar]><&2>█"
    - repeat <[empty]>:
        - define bar "<[bar]><&8>█"
    - determine <[bar]>

get_cosmetics_icon_item:
    type: procedure
    debug: false
    script:
    - define lore <list>
    - define lore <[lore].include[<&7>Manage your cosmetic unlocks]>
    - define lore "<[lore].include[<&sp>]>"

    # Count available titles
    - define title_count 0
    - if <player.has_flag[ceres.item.title]>:
        - define title_count <[title_count].add[1]>
    - if <player.has_flag[demeter.item.title]>:
        - define title_count <[title_count].add[1]>
    - if <player.has_flag[hephaestus.item.title]>:
        - define title_count <[title_count].add[1]>
    - if <player.has_flag[vulcan.item.title]>:
        - define title_count <[title_count].add[1]>
    - if <player.has_flag[heracles.item.title]>:
        - define title_count <[title_count].add[1]>
    - if <player.has_flag[mars.item.title]>:
        - define title_count <[title_count].add[1]>

    - define lore <[lore].include[<&e>Available Titles<&co> <&6><[title_count]>]>

    # Show active title
    - if <player.has_flag[cosmetic.title.active]>:
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&2>Active Title<&co>]>
        - define active_title <player.flag[cosmetic.title.active]>
        - choose <[active_title]>:
            - case ceres:
                - define lore "<[lore].include[<&6><&lb>Ceres' Chosen<&rb>]>"
            - case demeter:
                - define lore "<[lore].include[<&6><&lb>Harvest Queen<&rb>]>"
            - case hephaestus:
                - define lore "<[lore].include[<&7><&lb>Master Smith<&rb>]>"
            - case vulcan:
                - define lore "<[lore].include[<&7><&lb>Vulcan's Chosen<&rb>]>"
            - case heracles:
                - define lore "<[lore].include[<&4><&lb>Hero of Olympus<&rb>]>"
            - case mars:
                - define lore "<[lore].include[<&4><&lb>Mars' Chosen<&rb>]>"
    - else:
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&7>No title equipped]>

    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&e>Click to manage cosmetics]>

    - determine <item[armor_stand].with[display=<&d><&l>Cosmetics;lore=<[lore]>]>

# ============================================
# COSMETICS MENU
# ============================================

cosmetics_inventory:
    type: inventory
    inventory: chest
    gui: true
    debug: false
    title: <&8>Cosmetics
    size: 27
    procedural items:
    - determine <proc[get_cosmetics_menu_items]>

get_cosmetics_menu_items:
    type: procedure
    debug: false
    script:
    - define items <list>
    - define filler <item[gray_stained_glass_pane].with[display=<empty>]>

    # Fill with filler
    - repeat 27:
        - define items <[items].include[<[filler]>]>

    # Show all 6 titles (2 farming, 2 mining, 2 combat) in center row
    # Farming (left): slots 10, 11 | Mining (center): slots 13, 14 | Combat (right): slots 16, 17
    - define ceres_title <proc[get_ceres_title_item]>
    - define items <[items].set[<[ceres_title]>].at[10]>

    - define demeter_title <proc[get_demeter_title_item]>
    - define items <[items].set[<[demeter_title]>].at[11]>

    - define hephaestus_title <proc[get_hephaestus_title_item]>
    - define items <[items].set[<[hephaestus_title]>].at[13]>

    - define vulcan_title <proc[get_vulcan_title_item]>
    - define items <[items].set[<[vulcan_title]>].at[14]>

    - define heracles_title <proc[get_heracles_title_item]>
    - define items <[items].set[<[heracles_title]>].at[16]>

    - define mars_title <proc[get_mars_title_item]>
    - define items <[items].set[<[mars_title]>].at[17]>

    # Back button (bottom left)
    - define items <[items].set[<item[cosmetics_back_button]>].at[19]>

    - determine <[items]>

get_ceres_title_item:
    type: procedure
    debug: false
    script:
    - define lore <list>

    # Check if unlocked
    - if <player.has_flag[ceres.item.title]>:
        - define lore "<[lore].include[<&6><&lb>Ceres' Chosen<&rb>]>"
        - define lore "<[lore].include[<&sp>]>"
        - if <player.has_flag[cosmetic.title.active]> && <player.flag[cosmetic.title.active]> == ceres:
            - define lore <[lore].include[<&2>✓ Currently Active]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&e>Click to unequip]>
            - determine <item[name_tag].with[display=<&6><&l>Ceres Title;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
        - else:
            - define lore <[lore].include[<&7>Not equipped]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&e>Click to equip]>
            - determine <item[name_tag].with[display=<&6><&l>Ceres Title;lore=<[lore]>]>
    - else:
        - define lore <[lore].include[<&8>???]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&7>Unlock from<&co> <&b>Ceres Crates]>
        - determine <item[gray_dye].with[display=<&8>???;lore=<[lore]>]>

get_demeter_title_item:
    type: procedure
    debug: false
    script:
    - define lore <list>

    # Check if unlocked (placeholder - not implemented yet)
    - if <player.has_flag[demeter.item.title]>:
        - define lore "<[lore].include[<&6><&lb>Harvest Queen<&rb>]>"
        - define lore "<[lore].include[<&sp>]>"
        - if <player.has_flag[cosmetic.title.active]> && <player.flag[cosmetic.title.active]> == demeter:
            - define lore <[lore].include[<&2>✓ Currently Active]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&e>Click to unequip]>
            - determine <item[name_tag].with[display=<&e><&l>Demeter Title;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
        - else:
            - define lore <[lore].include[<&7>Not equipped]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&e>Click to equip]>
            - determine <item[name_tag].with[display=<&e><&l>Demeter Title;lore=<[lore]>]>
    - else:
        - define lore <[lore].include[<&8>???]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&7>Unlock from<&co> <&6>Demeter Crates]>
        - determine <item[gray_dye].with[display=<&8>???;lore=<[lore]>]>

get_hephaestus_title_item:
    type: procedure
    debug: false
    script:
    - define lore <list>

    # Check if unlocked
    - if <player.has_flag[hephaestus.item.title]>:
        - define lore "<[lore].include[<&7><&lb>Master Smith<&rb>]>"
        - define lore "<[lore].include[<&sp>]>"
        - if <player.has_flag[cosmetic.title.active]> && <player.flag[cosmetic.title.active]> == hephaestus:
            - define lore <[lore].include[<&2>✓ Currently Active]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&e>Click to unequip]>
            - determine <item[name_tag].with[display=<&8><&l>Hephaestus Title;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
        - else:
            - define lore <[lore].include[<&8>Not equipped]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&e>Click to equip]>
            - determine <item[name_tag].with[display=<&8><&l>Hephaestus Title;lore=<[lore]>]>
    - else:
        - define lore <[lore].include[<&8>???]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&7>Unlock from<&co> <&7>Hephaestus Crates]>
        - determine <item[gray_dye].with[display=<&8>???;lore=<[lore]>]>

get_vulcan_title_item:
    type: procedure
    debug: false
    script:
    - define lore <list>

    # Check if unlocked
    - if <player.has_flag[vulcan.item.title]>:
        - define lore "<[lore].include[<&7><&lb>Vulcan's Chosen<&rb>]>"
        - define lore "<[lore].include[<&sp>]>"
        - if <player.has_flag[cosmetic.title.active]> && <player.flag[cosmetic.title.active]> == vulcan:
            - define lore <[lore].include[<&2>✓ Currently Active]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&e>Click to unequip]>
            - determine <item[name_tag].with[display=<&8><&l>Vulcan Title;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
        - else:
            - define lore <[lore].include[<&8>Not equipped]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&e>Click to equip]>
            - determine <item[name_tag].with[display=<&8><&l>Vulcan Title;lore=<[lore]>]>
    - else:
        - define lore <[lore].include[<&8>???]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&7>Unlock from<&co> <&7>Vulcan Crates]>
        - determine <item[gray_dye].with[display=<&8>???;lore=<[lore]>]>

get_heracles_title_item:
    type: procedure
    debug: false
    script:
    - define lore <list>

    # Check if unlocked
    - if <player.has_flag[heracles.item.title]>:
        - define lore "<[lore].include[<&4><&lb>Hero of Olympus<&rb>]>"
        - define lore "<[lore].include[<&sp>]>"
        - if <player.has_flag[cosmetic.title.active]> && <player.flag[cosmetic.title.active]> == heracles:
            - define lore <[lore].include[<&2>✓ Currently Active]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&e>Click to unequip]>
            - determine <item[name_tag].with[display=<&c><&l>Heracles Title;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
        - else:
            - define lore <[lore].include[<&7>Not equipped]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&e>Click to equip]>
            - determine <item[name_tag].with[display=<&c><&l>Heracles Title;lore=<[lore]>]>
    - else:
        - define lore <[lore].include[<&8>???]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&7>Unlock from<&co> <&4>Heracles Crates]>
        - determine <item[gray_dye].with[display=<&8>???;lore=<[lore]>]>

get_mars_title_item:
    type: procedure
    debug: false
    script:
    - define lore <list>

    # Check if unlocked
    - if <player.has_flag[mars.item.title]>:
        - define lore "<[lore].include[<&4><&lb>Mars' Chosen<&rb>]>"
        - define lore "<[lore].include[<&sp>]>"
        - if <player.has_flag[cosmetic.title.active]> && <player.flag[cosmetic.title.active]> == mars:
            - define lore <[lore].include[<&2>✓ Currently Active]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&e>Click to unequip]>
            - determine <item[name_tag].with[display=<&c><&l>Mars Title;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
        - else:
            - define lore <[lore].include[<&7>Not equipped]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&e>Click to equip]>
            - determine <item[name_tag].with[display=<&c><&l>Mars Title;lore=<[lore]>]>
    - else:
        - define lore <[lore].include[<&8>???]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&7>Unlock from<&co> <&4>Mars Crates]>
        - determine <item[gray_dye].with[display=<&8>???;lore=<[lore]>]>

cosmetics_back_button:
    type: item
    material: arrow
    display name: <&e>← Back
    lore:
    - <&7>Return to profile

# ============================================
# COSMETICS CLICK HANDLERS
# ============================================

cosmetics_click_handler:
    type: world
    debug: false
    events:
        # Open cosmetics from profile
        on player clicks armor_stand in profile_inventory:
        - inventory open d:cosmetics_inventory

        # Back to profile
        on player clicks cosmetics_back_button in cosmetics_inventory:
        - inventory open d:profile_inventory

        # Click title items
        on player clicks name_tag in cosmetics_inventory:
        - define clicked_title ""

        # Determine which title was clicked based on slot
        # Farming (slots 10, 11) | Mining (slots 13, 14) | Combat (slots 16, 17)
        - if <context.slot> == 10:
            - define clicked_title ceres
            - define title_flag ceres.item.title
            - define title_name "<&6>[Ceres' Chosen]"
        - else if <context.slot> == 11:
            - define clicked_title demeter
            - define title_flag demeter.item.title
            - define title_name "<&6>[Harvest Queen]"
        - else if <context.slot> == 13:
            - define clicked_title hephaestus
            - define title_flag hephaestus.item.title
            - define title_name "<&8>[Master Smith]"
        - else if <context.slot> == 14:
            - define clicked_title vulcan
            - define title_flag vulcan.item.title
            - define title_name "<&8>[Vulcan's Chosen]"
        - else if <context.slot> == 16:
            - define clicked_title heracles
            - define title_flag heracles.item.title
            - define title_name "<&4>[Hero of Olympus]"
        - else if <context.slot> == 17:
            - define clicked_title mars
            - define title_flag mars.item.title
            - define title_name "<&4>[Mars' Chosen]"

        # Check if player has this title unlocked
        - if !<player.has_flag[<[title_flag]>]>:
            - playsound <player> sound:entity_villager_no
            - stop

        # Toggle title on/off
        - if <player.has_flag[cosmetic.title.active]> && <player.flag[cosmetic.title.active]> == <[clicked_title]>:
            # Turn off current title
            - flag player cosmetic.title.active:!
            - playsound <player> sound:block_note_block_pling pitch:0.8
            - narrate "<&7>Title disabled"
        - else:
            # Equip this title
            - flag player cosmetic.title.active:<[clicked_title]>
            - playsound <player> sound:block_note_block_pling pitch:1.2
            - narrate "<[title_name]> <&7>equipped!"

        # Refresh inventory
        - inventory open d:cosmetics_inventory

        # Click locked titles (gray_dye)
        on player clicks gray_dye in cosmetics_inventory:
        - playsound <player> sound:entity_villager_no

        # Farming ranks GUI
        on player clicks farming_ranks_back_button in farming_ranks_gui:
        - inventory open d:profile_inventory

        # Combat ranks GUI
        on player clicks combat_ranks_back_button in combat_ranks_gui:
        - inventory open d:profile_inventory

        # Mining ranks GUI
        on player clicks mining_ranks_back_button in mining_ranks_gui:
        - inventory open d:profile_inventory

# ============================================
# FARMING RANKS GUI
# ============================================

farming_ranks_gui:
    type: inventory
    inventory: chest
    gui: true
    debug: false
    title: <&8>Farming Skill Ranks
    size: 54
    procedural items:
    - determine <proc[get_farming_ranks_items]>

get_farming_ranks_items:
    type: procedure
    debug: false
    script:
    - define items <list>
    - define filler <item[gray_stained_glass_pane].with[display=<empty>]>

    # Fill all slots
    - repeat 54:
        - define items <[items].include[<[filler]>]>

    # Build rank info item
    - define rank <proc[get_farming_rank].context[<player.flag[farming.xp].if_null[0]>]>
    - define xp <player.flag[farming.xp].if_null[0]>
    - define rank_name <proc[get_farming_rank_name].context[<[rank]>]>

    - define rank_lore <list>
    - define rank_lore <[rank_lore].include[<&7>Current<&sp>Rank<&co><&sp><&e><[rank_name]>]>
    - define rank_lore <[rank_lore].include[<&7>Total<&sp>XP<&co><&sp><&e><[xp].format_number>]>
    - define rank_lore "<[rank_lore].include[<&sp>]>"

    # Show current buffs if player has a rank
    - if <[rank]> > 0:
        - define crops <proc[get_extra_crop_chance].context[<[rank]>]>
        - define speed <proc[get_farming_speed_bonus].context[<[rank]>]>
        - define rank_lore <[rank_lore].include[<&e>Active<&sp>Buffs<&co>]>
        - if <[crops]> > 0:
            - define rank_lore <[rank_lore].include[<&7>•<&sp>Extra<&sp>Crop<&sp>Output<&co><&sp><&a>+<[crops]>%]>
        - if <[speed]> >= 0:
            - define speed_level <[speed].add[1]>
            - define rank_lore <[rank_lore].include[<&7>•<&sp>Farming<&sp>Speed<&co><&sp><&a>Speed<&sp><[speed_level]>]>
        - define rank_lore "<[rank_lore].include[<&sp>]>"

    # Show progress
    - if <[rank]> < 5:
        - define next_rank <[rank].add[1]>
        - define next_xp <proc[get_farming_rank_data].context[<[next_rank]>].get[xp_total]>
        - define rank_lore <[rank_lore].include[<&6>Progress<&sp>to<&sp>Next<&sp>Rank<&co>]>
        - define rank_lore <[rank_lore].include[<&7><[xp].format_number><&sp>/<&sp><[next_xp].format_number><&sp>XP]>
    - else:
        - define rank_lore <[rank_lore].include[<&6><&l>MAX<&sp>RANK<&sp>ACHIEVED!]>

    - define rank_item <item[experience_bottle].with[display=<&6><&l>Your<&sp>Farming<&sp>Rank;lore=<[rank_lore]>]>
    - define items <[items].set[<[rank_item]>].at[14]>

    # XP method items
    - define items <[items].set[<item[farming_xp_crops]>].at[30]>
    - define items <[items].set[<item[farming_xp_animals]>].at[32]>
    - define items <[items].set[<item[farming_xp_foods]>].at[34]>

    # Back button
    - define items <[items].set[<item[farming_ranks_back_button]>].at[46]>

    - determine <[items]>

farming_xp_crops:
    type: item
    material: wheat
    display name: <&e><&l>Crop<&sp>Harvesting
    lore:
    - <&7>Harvest<&sp>fully<&sp>grown<&sp>crops
    - <&7>while<&sp>FARMING<&sp>role<&sp>is<&sp>active
    - <&sp>
    - <&6>XP<&sp>Rates<&co>
    - <&7>•<&sp>Wheat/Carrots/Potatoes/Beetroots<&co><&sp><&e>2<&sp>XP
    - <&7>•<&sp>Pumpkin/Melon<&co><&sp><&e>5<&sp>XP
    - <&7>•<&sp>Nether<&sp>Wart<&co><&sp><&e>3<&sp>XP
    - <&7>•<&sp>Cocoa<&co><&sp><&e>1<&sp>XP
    - <&7>•<&sp>Sugar<&sp>Cane/Cactus/Kelp/Bamboo<&co><&sp><&e>1<&sp>XP

farming_xp_animals:
    type: item
    material: beef
    display name: <&e><&l>Animal<&sp>Breeding
    lore:
    - <&7>Breed<&sp>animals<&sp>while<&sp>FARMING
    - <&7>role<&sp>is<&sp>active
    - <&sp>
    - <&6>XP<&sp>Rates<&co>
    - <&7>•<&sp>Horse<&co><&sp><&e>30<&sp>XP
    - <&7>•<&sp>Turtle<&co><&sp><&e>20<&sp>XP
    - <&7>•<&sp>Llama/Hoglin<&co><&sp><&e>12<&sp>XP
    - <&7>•<&sp>Cow/Sheep/Pig<&co><&sp><&e>10<&sp>XP
    - <&7>•<&sp>Rabbit/Bee<&co><&sp><&e>8<&sp>XP
    - <&7>•<&sp>Chicken<&co><&sp><&e>6<&sp>XP

farming_xp_foods:
    type: item
    material: cake
    display name: <&e><&l>Food<&sp>Crafting
    lore:
    - <&7>Craft<&sp>food<&sp>items<&sp>while<&sp>FARMING
    - <&7>role<&sp>is<&sp>active
    - <&sp>
    - <&6>XP<&sp>Rates<&co>
    - <&7>•<&sp>Rabbit<&sp>Stew<&co><&sp><&e>15<&sp>XP
    - <&7>•<&sp>Cake<&co><&sp><&e>12<&sp>XP
    - <&7>•<&sp>Pumpkin<&sp>Pie<&co><&sp><&e>10<&sp>XP
    - <&7>•<&sp>Suspicious<&sp>Stew<&co><&sp><&e>8<&sp>XP
    - <&7>•<&sp>Beetroot<&sp>Soup<&co><&sp><&e>6<&sp>XP
    - <&7>•<&sp>Mushroom<&sp>Stew<&co><&sp><&e>4<&sp>XP

farming_ranks_back_button:
    type: item
    material: arrow
    display name: <&e>← Back
    lore:
    - <&7>Return<&sp>to<&sp>profile

# ============================================
# COMBAT RANKS GUI
# ============================================

combat_ranks_gui:
    type: inventory
    inventory: chest
    gui: true
    debug: false
    title: <&8>Combat Skill Ranks
    size: 54
    procedural items:
    - determine <proc[get_combat_ranks_items]>

get_combat_ranks_items:
    type: procedure
    debug: false
    script:
    - define items <list>
    - define filler <item[gray_stained_glass_pane].with[display=<empty>]>

    # Fill all slots
    - repeat 54:
        - define items <[items].include[<[filler]>]>

    # Build rank info item
    - define rank <proc[get_combat_rank_from_xp].context[<player.flag[heracles.xp].if_null[0]>]>
    - define xp <player.flag[heracles.xp].if_null[0]>
    - define rank_name <proc[get_combat_rank_name].context[<[rank]>]>

    - define rank_lore <list>
    - define rank_lore <[rank_lore].include[<&7>Current<&sp>Rank<&co><&sp><&c><[rank_name]>]>
    - define rank_lore <[rank_lore].include[<&7>Total<&sp>XP<&co><&sp><&c><[xp].format_number>]>
    - define rank_lore "<[rank_lore].include[<&sp>]>"

    # Show current buffs if player has a rank
    - if <[rank]> > 0:
        - define rank_data <script[combat_rank_data].data_key[ranks.<[rank]>]>
        - define xp_bonus <[rank_data].get[xp_bonus]>
        - define regen_amp <[rank_data].get[regen_amplifier]>
        - define rank_lore <[rank_lore].include[<&e>Active<&sp>Buffs<&co>]>
        - define regen_level <[regen_amp].add[1]>
        - define rank_lore <[rank_lore].include[<&7>•<&sp>Low<&sp>HP<&sp>Regen<&sp><[regen_level]>]>
        - define rank_lore <[rank_lore].include[<&7>•<&sp>Vanilla<&sp>XP<&sp>Bonus<&co><&sp><&a>+<[xp_bonus]>%]>
        - define rank_lore "<[rank_lore].include[<&sp>]>"

    # Show progress
    - if <[rank]> < 5:
        - define next_rank <[rank].add[1]>
        - define next_rank_data <script[combat_rank_data].data_key[ranks.<[next_rank]>]>
        - define next_xp <[next_rank_data].get[xp_total]>
        - define rank_lore <[rank_lore].include[<&6>Progress<&sp>to<&sp>Next<&sp>Rank<&co>]>
        - define rank_lore <[rank_lore].include[<&7><[xp].format_number><&sp>/<&sp><[next_xp].format_number><&sp>XP]>
    - else:
        - define rank_lore <[rank_lore].include[<&6><&l>MAX<&sp>RANK<&sp>ACHIEVED!]>

    - define rank_item <item[experience_bottle].with[display=<&c><&l>Your<&sp>Combat<&sp>Rank;lore=<[rank_lore]>]>
    - define items <[items].set[<[rank_item]>].at[14]>

    # XP method items
    - define items <[items].set[<item[combat_xp_mobs]>].at[30]>
    - define items <[items].set[<item[combat_xp_raids]>].at[32]>
    - define items <[items].set[<item[combat_xp_emeralds]>].at[34]>

    # Back button
    - define items <[items].set[<item[combat_ranks_back_button]>].at[46]>

    - determine <[items]>

combat_xp_mobs:
    type: item
    material: zombie_head
    display name: <&c><&l>Combat<&sp>Kills
    lore:
    - <&7>Kill<&sp>hostile<&sp>mobs
    - <&7>while<&sp>COMBAT<&sp>role<&sp>is<&sp>active
    - <&sp>
    - <&6>XP<&sp>Rates<&co>
    - <&7>•<&sp>Common<&sp>(Zombie,<&sp>Skeleton)<&co><&sp><&c>2<&sp>XP
    - <&7>•<&sp>Uncommon<&sp>(Enderman,<&sp>Blaze)<&co><&sp><&c>5<&sp>XP
    - <&7>•<&sp>Rare<&sp>(Vindicator,<&sp>Ravager)<&co><&sp><&c>8<&sp>XP
    - <&7>•<&sp>Elite<&sp>(Guardian)<&co><&sp><&c>15<&sp>XP

combat_xp_raids:
    type: item
    material: shield
    display name: <&c><&l>Raid<&sp>Defense
    lore:
    - <&7>Complete<&sp>village<&sp>raids
    - <&7>while<&sp>COMBAT<&sp>role<&sp>is<&sp>active
    - <&sp>
    - <&6>XP<&sp>Rates<&co>
    - <&7>•<&sp>Bad<&sp>Omen<&sp>I<&co><&sp><&c>50<&sp>XP
    - <&7>•<&sp>Bad<&sp>Omen<&sp>II<&co><&sp><&c>75<&sp>XP
    - <&7>•<&sp>Bad<&sp>Omen<&sp>III<&co><&sp><&c>100<&sp>XP
    - <&7>•<&sp>Bad<&sp>Omen<&sp>IV<&co><&sp><&c>150<&sp>XP
    - <&7>•<&sp>Bad<&sp>Omen<&sp>V<&co><&sp><&c>200<&sp>XP

combat_xp_emeralds:
    type: item
    material: emerald
    display name: <&c><&l>Emerald<&sp>Trading
    lore:
    - <&7>Trade<&sp>with<&sp>villagers
    - <&7>while<&sp>COMBAT<&sp>role<&sp>is<&sp>active
    - <&sp>
    - <&6>XP<&sp>Rate<&co>
    - <&7>•<&sp>Per<&sp>emerald<&sp>spent<&co><&sp><&c>1<&sp>XP

combat_ranks_back_button:
    type: item
    material: arrow
    display name: <&e>← Back
    lore:
    - <&7>Return<&sp>to<&sp>profile

# ============================================
# MINING RANKS GUI
# ============================================

mining_ranks_gui:
    type: inventory
    inventory: chest
    gui: true
    debug: false
    title: <&8>Mining Skill Ranks
    size: 54
    procedural items:
    - determine <proc[get_mining_ranks_items]>

get_mining_ranks_items:
    type: procedure
    debug: false
    script:
    - define items <list>
    - define filler <item[gray_stained_glass_pane].with[display=<empty>]>

    # Fill all slots
    - repeat 54:
        - define items <[items].include[<[filler]>]>

    # Build rank info item
    - define rank <proc[get_mining_rank].context[<player.flag[mining.xp].if_null[0]>]>
    - define xp <player.flag[mining.xp].if_null[0]>
    - define rank_name <proc[get_mining_rank_name].context[<[rank]>]>

    - define rank_lore <list>
    - define rank_lore <[rank_lore].include[<&7>Current Rank<&co> <&f><[rank_name]>]>
    - define rank_lore <[rank_lore].include[<&7>Total XP<&co> <&f><[xp].format_number>]>
    - define rank_lore "<[rank_lore].include[<&sp>]>"

    # Show current buffs if player has a rank
    - if <[rank]> > 0:
        - define rank_data <script[mining_rank_data].data_key[ranks.<[rank]>]>
        - define ore_xp <[rank_data].get[ore_xp_bonus]>
        - define haste_amp <[rank_data].get[haste_amplifier]>
        - define rank_lore <[rank_lore].include[<&8>Active Buffs<&co>]>
        - if <[haste_amp]> >= 0:
            - define haste_level <[haste_amp].add[1]>
            - define rank_lore <[rank_lore].include[<&7>• Mining Speed<&co> <&a>Haste <[haste_level]>]>
        - define rank_lore <[rank_lore].include[<&7>• Ore XP Bonus<&co> <&a>+<[ore_xp]>%]>
        - define rank_lore "<[rank_lore].include[<&sp>]>"

    # Show progress
    - if <[rank]> < 5:
        - define next_rank <[rank].add[1]>
        - define next_rank_data <script[mining_rank_data].data_key[ranks.<[next_rank]>]>
        - define next_xp <[next_rank_data].get[xp_total]>
        - define rank_lore <[rank_lore].include[<&8>Progress to Next Rank<&co>]>
        - define rank_lore <[rank_lore].include[<&7><[xp].format_number> / <[next_xp].format_number> XP]>
    - else:
        - define rank_lore <[rank_lore].include[<&8><&l>MAX RANK ACHIEVED!]>

    - define rank_item <item[experience_bottle].with[display=<&8><&l>Your Mining Rank;lore=<[rank_lore]>]>
    - define items <[items].set[<[rank_item]>].at[14]>

    # XP method items
    - define items <[items].set[<item[mining_xp_ores]>].at[30]>
    - define items <[items].set[<item[mining_xp_smelting]>].at[32]>
    - define items <[items].set[<item[mining_xp_golems]>].at[34]>

    # Back button
    - define items <[items].set[<item[mining_ranks_back_button]>].at[46]>

    - determine <[items]>

mining_xp_ores:
    type: item
    material: iron_ore
    display name: <&8><&l>Ore Mining
    lore:
    - <&7>Mine ores while MINING
    - <&7>role is active
    - <&sp>
    - <&8>XP Rates<&co>
    - <&7>• Coal/Copper/Quartz<&co> <&f>2 XP
    - <&7>• Iron/Nether Gold<&co> <&f>3 XP
    - <&7>• Lapis/Redstone<&co> <&f>4 XP
    - <&7>• Gold<&co> <&f>5 XP
    - <&7>• Diamond/Emerald<&co> <&f>10 XP
    - <&7>• Ancient Debris<&co> <&f>20 XP

mining_xp_smelting:
    type: item
    material: blast_furnace
    display name: <&8><&l>Blast Furnace
    lore:
    - <&7>Smelt items in blast furnace
    - <&7>while MINING role is active
    - <&sp>
    - <&8>XP Rate<&co>
    - <&7>• Per item smelted<&co> <&f>1 XP

mining_xp_golems:
    type: item
    material: carved_pumpkin
    display name: <&8><&l>Golem Crafting
    lore:
    - <&7>Create iron golems
    - <&7>while MINING role is active
    - <&sp>
    - <&8>XP Rate<&co>
    - <&7>• Per golem created<&co> <&f>25 XP

mining_ranks_back_button:
    type: item
    material: arrow
    display name: <&e>← Back
    lore:
    - <&7>Return<&sp>to<&sp>profile

get_current_farming_rank_item:
    type: procedure
    debug: false
    script:
    - define xp <player.flag[farming.xp].if_null[0]>
    - define rank <player.flag[farming.rank].if_null[0]>
    - define rank_name <proc[get_farming_rank_name].context[<[rank]>]>

    - define lore <list>
    - if <[rank]> == 0:
        - define lore <[lore].include[<&7>You<&sp>haven't<&sp>achieved<&sp>a<&sp>rank<&sp>yet.]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&7>Total<&sp>XP<&co><&sp><&e><[xp].format_number><&sp>/<&sp>1,000]>
        - define percent <[xp].div[1000].mul[100].round.min[100]>
        - define bar <proc[create_progress_bar].context[<[percent]>]>
        - define lore <[lore].include[<[bar]>]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&e>Next<&sp>Rank<&co><&sp><&6>Acolyte<&sp>of<&sp>the<&sp>Farm]>
        - determine <item[wheat_seeds].with[display=<&6><&l>Your<&sp>Farming<&sp>Rank;lore=<[lore]>]>
    - else:
        - define rank_data <script[farming_rank_data].data_key[ranks.<[rank]>]>
        - define lore <[lore].include[<&6><&l>CURRENT<&sp>RANK]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&7>Total<&sp>XP<&co><&sp><&e><[xp].format_number>]>
        - define lore "<[lore].include[<&sp>]>"

        # Show buffs
        - define haste <proc[get_farming_speed_bonus].context[<[rank]>]>
        - define crops <proc[get_extra_crop_chance].context[<[rank]>]>

        - define lore <[lore].include[<&e>Active<&sp>Buffs<&co>]>
        - if <[crops]> > 0:
            - define lore <[lore].include[<&7>•<&sp>Extra<&sp>Crop<&sp>Output<&co><&sp><&e>+<[crops]>%]>
        - if <[haste]> >= 0:
            - define lore <[lore].include[<&7>•<&sp>Farming<&sp>Speed<&co><&sp><&e>Speed<&sp><[haste].add[1]>]>

        # Show next rank if not maxed
        - if <[rank]> < 5:
            - define lore "<[lore].include[<&sp>]>"
            - define next_rank <[rank].add[1]>
            - define next_name <proc[get_farming_rank_name].context[<[next_rank]>]>
            - define next_data <script[farming_rank_data].data_key[ranks.<[next_rank]>]>
            - define next_xp_total <[next_data].get[xp_total]>
            - define lore <[lore].include[<&e>Next<&sp>Rank<&co><&sp><&6><[next_name]>]>
            - define lore <[lore].include[<&7><[xp].format_number><&sp>/<&sp><[next_xp_total].format_number><&sp>XP]>
            - define percent <[xp].div[<[next_xp_total]>].mul[100].round.min[100]>
            - define bar <proc[create_progress_bar].context[<[percent]>]>
            - define lore <[lore].include[<[bar]>]>
        - else:
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&6><&l>MAX<&sp>RANK<&sp>ACHIEVED!]>

        - determine <item[golden_hoe].with[display=<&6><&l><[rank_name]>;lore=<[lore]>;enchantments=mending,1;hides=ALL]>

get_rank_detail_item:
    type: procedure
    debug: false
    definitions: tier|status
    script:
    - define rank_data <script[farming_rank_data].data_key[ranks.<[tier]>]>
    - define rank_name <[rank_data].get[name]>
    - define xp_total <[rank_data].get[xp_total]>
    - define key_reward <[rank_data].get[key_reward]>
    - define crops_bonus <[rank_data].get[extra_crop_chance]>
    - define haste_amp <[rank_data].get[haste_amplifier]>

    - define lore <list>

    # Status header
    - if <[status]> == current:
        - define lore <[lore].include[<&2><&l>✓<&sp>CURRENT<&sp>RANK]>
    - else:
        - define lore <[lore].include[<&e><&l>→<&sp>NEXT<&sp>RANK]>

    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&6>Total<&sp>XP<&sp>Required<&co><&sp><&e><[xp_total].format_number>]>
    - define lore "<[lore].include[<&sp>]>"

    # Buffs
    - define lore <[lore].include[<&e>Rank<&sp>Buffs<&co>]>
    - if <[crops_bonus]> > 0:
        - define lore <[lore].include[<&7>•<&sp>Extra<&sp>Crop<&sp>Output<&co><&sp><&e>+<[crops_bonus]>%]>
    - if <[haste_amp]> >= 0:
        - define speed_level <[haste_amp].add[1]>
        - define lore <[lore].include[<&7>•<&sp>Farming<&sp>Speed<&co><&sp><&e>Speed<&sp><[speed_level]>]>
    - else:
        - define lore <[lore].include[<&7>•<&sp>No<&sp>speed<&sp>buff<&sp>yet]>

    - define lore "<[lore].include[<&sp>]>"
    - if <[status]> == next:
        - define lore <[lore].include[<&e>Rank-Up<&sp>Reward<&co><&sp><&6><[key_reward]><&sp>Demeter<&sp>Keys]>

    # Choose icon based on tier
    - choose <[tier]>:
        - case 1:
            - define material wheat_seeds
        - case 2:
            - define material iron_hoe
        - case 3:
            - define material golden_hoe
        - case 4:
            - define material diamond_hoe
        - case 5:
            - define material netherite_hoe

    - if <[status]> == current:
        - determine <item[<[material]>].with[display=<&6><&l><[rank_name]>;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - else:
        - determine <item[<[material]>].with[display=<&6><&l><[rank_name]>;lore=<[lore]>]>

get_crops_xp_item:
    type: procedure
    debug: false
    script:
    - define lore <list>
    - define lore <[lore].include[<&7>Harvest<&sp>fully<&sp>grown<&sp>crops]>
    - define lore <[lore].include[<&7>while<&sp>FARMING<&sp>role<&sp>is<&sp>active]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&6>XP<&sp>Rates<&co>]>
    - define lore <[lore].include[<&7>•<&sp>Wheat/Carrots/Potatoes/Beetroots<&co><&sp><&e>2<&sp>XP]>
    - define lore <[lore].include[<&7>•<&sp>Pumpkin/Melon<&co><&sp><&e>5<&sp>XP]>
    - define lore <[lore].include[<&7>•<&sp>Nether<&sp>Wart<&co><&sp><&e>3<&sp>XP]>
    - define lore <[lore].include[<&7>•<&sp>Cocoa<&co><&sp><&e>1<&sp>XP]>
    - define lore <[lore].include[<&7>•<&sp>Sugar<&sp>Cane/Cactus/Kelp/Bamboo<&co><&sp><&e>1<&sp>XP]>
    - determine <item[wheat].with[display=<&e><&l>Crop<&sp>Harvesting;lore=<[lore]>]>

get_animals_xp_item:
    type: procedure
    debug: false
    script:
    - define lore <list>
    - define lore <[lore].include[<&7>Breed<&sp>animals<&sp>while<&sp>FARMING]>
    - define lore <[lore].include[<&7>role<&sp>is<&sp>active]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&6>XP<&sp>Rates<&co>]>
    - define lore <[lore].include[<&7>•<&sp>Horse<&co><&sp><&e>30<&sp>XP]>
    - define lore <[lore].include[<&7>•<&sp>Turtle<&co><&sp><&e>20<&sp>XP]>
    - define lore <[lore].include[<&7>•<&sp>Llama/Hoglin<&co><&sp><&e>12<&sp>XP]>
    - define lore <[lore].include[<&7>•<&sp>Cow/Sheep/Pig<&co><&sp><&e>10<&sp>XP]>
    - define lore <[lore].include[<&7>•<&sp>Rabbit/Bee<&co><&sp><&e>8<&sp>XP]>
    - define lore <[lore].include[<&7>•<&sp>Chicken<&co><&sp><&e>6<&sp>XP]>
    - determine <item[beef].with[display=<&e><&l>Animal<&sp>Breeding;lore=<[lore]>]>

get_foods_xp_item:
    type: procedure
    debug: false
    script:
    - define lore <list>
    - define lore <[lore].include[<&7>Craft<&sp>food<&sp>items<&sp>while<&sp>FARMING]>
    - define lore <[lore].include[<&7>role<&sp>is<&sp>active]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&6>XP<&sp>Rates<&co>]>
    - define lore <[lore].include[<&7>•<&sp>Rabbit<&sp>Stew<&co><&sp><&e>15<&sp>XP]>
    - define lore <[lore].include[<&7>•<&sp>Cake<&co><&sp><&e>12<&sp>XP]>
    - define lore <[lore].include[<&7>•<&sp>Pumpkin<&sp>Pie<&co><&sp><&e>10<&sp>XP]>
    - define lore <[lore].include[<&7>•<&sp>Suspicious<&sp>Stew<&co><&sp><&e>8<&sp>XP]>
    - define lore <[lore].include[<&7>•<&sp>Beetroot<&sp>Soup<&co><&sp><&e>6<&sp>XP]>
    - define lore <[lore].include[<&7>•<&sp>Mushroom<&sp>Stew<&co><&sp><&e>4<&sp>XP]>
    - determine <item[cake].with[display=<&e><&l>Food<&sp>Crafting;lore=<[lore]>]>
