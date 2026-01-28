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
    title: <&8><player.name>'s Profile
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

    # Row 1: Player head (centered slot 5)
    - define head <item[<player.skull_item>].with[display_name=<&2><player.name>;lore=<&7>Welcome to your profile!|<&7>UUID<&co> <&e><player.uuid>]>
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
    script:
    - if !<player.has_flag[role.active]>:
        - define lore <list>
        - define lore <[lore].include[<&7><&o>"Three paths diverge before you..."]>
        - define lore <[lore].include[<empty>]>
        - define lore <[lore].include[<&7>You have not chosen a role yet.]>
        - define lore <[lore].include[<empty>]>
        - define lore <[lore].include[<&e>Speak to Promachos to choose]>
        - determine <item[compass].with[display_name=<&6>No Role Selected;lore=<[lore]>]>

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
            - define lore <[lore].include[<&7>Delve into stone and strike the earth.]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&6>Your Activities<&co>]>
            - define lore <[lore].include[<&8><&o>Coming soon...]>
        - case COMBAT:
            - define lore <[lore].include[<&e>Patron<&co> <&6><[god]><&7>, Hero of Strength]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&7>Prove your might through combat.]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&6>Your Activities<&co>]>
            - define lore <[lore].include[<&8><&o>Coming soon...]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&8>Change role by speaking to Promachos]>

    - determine <item[<[icon]>].with[display_name=<&6><&l><[display]>;lore=<[lore]>;enchantments=mending,1;hides=ALL]>

get_ranks_icon_item:
    type: procedure
    script:
    - define xp <player.flag[farming.xp].if_null[0]>
    - define rank <player.flag[farming.rank].if_null[0]>
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
        - determine <item[experience_bottle].with[display_name=<&6><&l>Farming Ranks;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - else:
        - determine <item[experience_bottle].with[display_name=<&6><&l>Farming Ranks;lore=<[lore]>]>

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

    - determine <item[wheat].with[display_name=<&e><&l>Demeter;lore=<[lore]>]>

# ============================================
# PROFILE CLICK HANDLER
# ============================================

profile_click_handler:
    type: world
    debug: false
    events:
        after player clicks experience_bottle in profile_inventory:
        - inventory open d:farming_ranks_gui

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

        after player clicks emblem_check_back_button in emblem_check_gui:
        - inventory open d:profile_inventory

        # Demeter progress GUI clicks
        after player clicks demeter_progress_back_button in demeter_progress_gui:
        - inventory open d:emblem_check_gui

# ============================================
# DEMETER DETAILED PROGRESS GUI
# ============================================

demeter_progress_gui:
    type: inventory
    inventory: chest
    gui: true
    title: <&8>Demeter - Activity Progress
    size: 27
    procedural items:
    - determine <proc[get_demeter_progress_items]>

get_demeter_progress_items:
    type: procedure
    script:
    - define items <list>
    - define filler <item[gray_stained_glass_pane].with[display_name=<&7>]>

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
        - determine <item[wheat].with[display_name=<&e><&l>Wheat Harvest;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - else:
        - determine <item[wheat].with[display_name=<&e><&l>Wheat Harvest;lore=<[lore]>]>

get_demeter_cow_progress_item:
    type: procedure
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
        - determine <item[leather].with[display_name=<&e><&l>Cow Breeding;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - else:
        - determine <item[leather].with[display_name=<&e><&l>Cow Breeding;lore=<[lore]>]>

get_demeter_cake_progress_item:
    type: procedure
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
        - determine <item[cake].with[display_name=<&e><&l>Cake Crafting;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - else:
        - determine <item[cake].with[display_name=<&e><&l>Cake Crafting;lore=<[lore]>]>

demeter_progress_back_button:
    type: item
    material: arrow
    display name: <&e>← Back
    lore:
    - <&7>Return to emblems

create_progress_bar:
    type: procedure
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
    script:
    - define lore <list>
    - define lore <[lore].include[<&7>Manage your cosmetic unlocks]>
    - define lore "<[lore].include[<&sp>]>"

    # Count available titles
    - define title_count 0
    - if <player.has_flag[ceres.item.title]>:
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
    - else:
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&7>No title equipped]>

    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&e>Click to manage cosmetics]>

    - determine <item[armor_stand].with[display_name=<&d><&l>Cosmetics;lore=<[lore]>]>

# ============================================
# COSMETICS MENU
# ============================================

cosmetics_inventory:
    type: inventory
    inventory: chest
    gui: true
    title: <&8>Cosmetics
    size: 27
    procedural items:
    - determine <proc[get_cosmetics_menu_items]>

get_cosmetics_menu_items:
    type: procedure
    script:
    - define items <list>
    - define filler <item[gray_stained_glass_pane].with[display_name=<&7>]>

    # Fill with filler
    - repeat 27:
        - define items <[items].include[<[filler]>]>

    # Show all 3 titles in center row (slots 12, 14, 16)
    - define title1 <proc[get_ceres_title_item]>
    - define items <[items].set[<[title1]>].at[12]>

    - define title2 <proc[get_demeter_title_item]>
    - define items <[items].set[<[title2]>].at[14]>

    - define title3 <proc[get_heracles_title_item]>
    - define items <[items].set[<[title3]>].at[16]>

    # Back button (bottom left)
    - define items <[items].set[<item[cosmetics_back_button]>].at[19]>

    - determine <[items]>

get_ceres_title_item:
    type: procedure
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
            - determine <item[name_tag].with[display_name=<&6><&l>Ceres Title;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
        - else:
            - define lore <[lore].include[<&7>Not equipped]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&e>Click to equip]>
            - determine <item[name_tag].with[display_name=<&6><&l>Ceres Title;lore=<[lore]>]>
    - else:
        - define lore <[lore].include[<&8>???]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&7>Unlock from<&co> <&b>Ceres Crates]>
        - determine <item[gray_dye].with[display_name=<&8>???;lore=<[lore]>]>

get_demeter_title_item:
    type: procedure
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
            - determine <item[name_tag].with[display_name=<&e><&l>Demeter Title;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
        - else:
            - define lore <[lore].include[<&7>Not equipped]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&e>Click to equip]>
            - determine <item[name_tag].with[display_name=<&e><&l>Demeter Title;lore=<[lore]>]>
    - else:
        - define lore <[lore].include[<&8>???]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&7>Unlock from<&co> <&6>Demeter Crates]>
        - determine <item[gray_dye].with[display_name=<&8>???;lore=<[lore]>]>

get_heracles_title_item:
    type: procedure
    script:
    - define lore <list>

    # Check if unlocked (placeholder - not implemented yet)
    - if <player.has_flag[heracles.item.title]>:
        - define lore "<[lore].include[<&c><&lb>The Unconquered<&rb>]>"
        - define lore "<[lore].include[<&sp>]>"
        - if <player.has_flag[cosmetic.title.active]> && <player.flag[cosmetic.title.active]> == heracles:
            - define lore <[lore].include[<&2>✓ Currently Active]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&e>Click to unequip]>
            - determine <item[name_tag].with[display_name=<&c><&l>Heracles Title;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
        - else:
            - define lore <[lore].include[<&7>Not equipped]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&e>Click to equip]>
            - determine <item[name_tag].with[display_name=<&c><&l>Heracles Title;lore=<[lore]>]>
    - else:
        - define lore <[lore].include[<&8>???]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&7>Unlock from<&co> <&4>Heracles Crates]>
        - determine <item[gray_dye].with[display_name=<&8>???;lore=<[lore]>]>

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
        - if <context.slot> == 12:
            - define clicked_title ceres
            - define title_flag ceres.item.title
            - define title_name "<&6>[Ceres' Chosen]"
        - else if <context.slot> == 14:
            - define clicked_title demeter
            - define title_flag demeter.item.title
            - define title_name "<&6>[Harvest Queen]"
        - else if <context.slot> == 16:
            - define clicked_title heracles
            - define title_flag heracles.item.title
            - define title_name "<&c>[The Unconquered]"

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

# ============================================
# FARMING RANKS GUI
# ============================================

farming_ranks_gui:
    type: inventory
    inventory: chest
    gui: true
    title: <&8>Farming Skill Ranks
    size: 54
    procedural items:
    - determine <proc[get_farming_ranks_items]>

get_farming_ranks_items:
    type: procedure
    script:
    - define items <list>
    - define filler <item[gray_stained_glass_pane].with[display_name=<&7>]>

    # Fill all slots
    - repeat 54:
        - define items <[items].include[<[filler]>]>

    # Build rank info item
    - define rank <player.flag[farming.rank].if_null[0]>
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

    - define rank_item <item[experience_bottle].with[display_name=<&6><&l>Your<&sp>Farming<&sp>Rank;lore=<[rank_lore]>]>
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

get_current_farming_rank_item:
    type: procedure
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
        - determine <item[wheat_seeds].with[display_name=<&6><&l>Your<&sp>Farming<&sp>Rank;lore=<[lore]>]>
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

        - determine <item[golden_hoe].with[display_name=<&6><&l><[rank_name]>;lore=<[lore]>;enchantments=mending,1;hides=ALL]>

get_rank_detail_item:
    type: procedure
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
        - determine <item[<[material]>].with[display_name=<&6><&l><[rank_name]>;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - else:
        - determine <item[<[material]>].with[display_name=<&6><&l><[rank_name]>;lore=<[lore]>]>

get_crops_xp_item:
    type: procedure
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
    - determine <item[wheat].with[display_name=<&e><&l>Crop<&sp>Harvesting;lore=<[lore]>]>

get_animals_xp_item:
    type: procedure
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
    - determine <item[beef].with[display_name=<&e><&l>Animal<&sp>Breeding;lore=<[lore]>]>

get_foods_xp_item:
    type: procedure
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
    - determine <item[cake].with[display_name=<&e><&l>Food<&sp>Crafting;lore=<[lore]>]>
