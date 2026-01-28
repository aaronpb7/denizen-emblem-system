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
            - define lore <[lore].include[<&7>Cultivate the earth and nurture life.]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&6>Your Activities<&co>]>
            - define lore <[lore].include[<&7>• Harvest wheat from your fields]>
            - define lore <[lore].include[<&7>• Breed cows and livestock]>
            - define lore <[lore].include[<&7>• Craft delicious cakes]>
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
        - define lore <[lore].include[<&2>✓ Cakes: <[cakes_count]>/300 COMPLETE]>
    - else:
        - define percent <[cakes_count].div[300].mul[100].round>
        - define lore <[lore].include[<&7>Cakes: <[cakes_count]>/300 (<[percent]>%)]>

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

    # Row 1: Rank display (centered slot 5)
    - define rank_item <proc[get_demeter_rank_display_item]>
    - define items <[items].set[<[rank_item]>].at[5]>

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
    - define lore <[lore].include[<&6>Key Rewards<&co>]>
    - define lore <[lore].include[<&7>Every 150 wheat harvested will grant]>
    - define lore <[lore].include[<&7>you 1 <&e>Demeter Key<&7>.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&8>Keys Earned<&co> <&e><[keys]>]>

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
    - define lore <[lore].include[<&6>Key Rewards<&co>]>
    - define lore <[lore].include[<&7>Every 20 cows bred will grant you]>
    - define lore <[lore].include[<&7>1 <&e>Demeter Key<&7>.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&8>Keys Earned<&co> <&e><[keys]>]>

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
    - define lore <[lore].include[<&7><[count]> / 300 cakes crafted]>
    - if <[complete]>:
        - define percent 100
    - else:
        - define percent <[count].div[300].mul[100].round>
    - define lore <[lore].include[<&7>(<[percent]>% complete)]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&6>Key Rewards<&co>]>
    - define lore <[lore].include[<&7>Every 3 cakes crafted will grant you]>
    - define lore <[lore].include[<&7>1 <&e>Demeter Key<&7>.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&8>Keys Earned<&co> <&e><[keys]>]>

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

get_demeter_rank_display_item:
    type: procedure
    script:
    - define rank <player.flag[demeter.rank].if_null[0]>
    - define rank_name <proc[get_demeter_rank_name].context[<[rank]>]>
    - define wheat <player.flag[demeter.wheat.count].if_null[0]>
    - define cows <player.flag[demeter.cows.count].if_null[0]>

    - define lore <list>
    - if <[rank]> == 0:
        - define lore <[lore].include[<&7>No rank achieved yet]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&e>Next Rank<&co> <&6>Acolyte of Demeter]>
        - define lore "<[lore].include[<&sp>]>"
        # Wheat progress bar
        - define wheat_needed 2500
        - define wheat_percent <[wheat].div[<[wheat_needed]>].mul[100].round.min[100]>
        - define wheat_bar <proc[create_progress_bar].context[<[wheat_percent]>]>
        - define lore <[lore].include[<&7>Wheat<&co> <&e><[wheat]>/<[wheat_needed]>]>
        - define lore <[lore].include[<[wheat_bar]>]>
        - define lore "<[lore].include[<&sp>]>"
        # Cow progress bar
        - define cows_needed 50
        - define cows_percent <[cows].div[<[cows_needed]>].mul[100].round.min[100]>
        - define cows_bar <proc[create_progress_bar].context[<[cows_percent]>]>
        - define lore <[lore].include[<&7>Cows<&co> <&e><[cows]>/<[cows_needed]>]>
        - define lore <[lore].include[<[cows_bar]>]>
        - determine <item[wheat_seeds].with[display_name=<&6>Demeter Rank;lore=<[lore]>]>
    - else:
        - define lore <[lore].include[<&6><&l>CURRENT RANK]>
        - define lore "<[lore].include[<&sp>]>"

        # Get benefits
        - define haste <proc[get_farming_speed_bonus].context[<[rank]>]>
        - define crops <proc[get_extra_crop_chance].context[<[rank]>]>
        - define twins <proc[get_twin_breeding_chance].context[<[rank]>]>

        - define lore <[lore].include[<&e>Active Benefits<&co>]>
        - if <[haste]> >= 0:
            - define lore <[lore].include[<&7>• Farming Speed<&co> <&e>Speed <[haste].add[1]>]>
        - if <[crops]> > 0:
            - define lore <[lore].include[<&7>• Extra Crops<&co> <&e>+<[crops]>%]>
        - if <[twins]> > 0:
            - define lore <[lore].include[<&7>• Twin Breeding<&co> <&e><[twins]>%]>

        # Show next rank if not max
        - if <[rank]> < 3:
            - define lore "<[lore].include[<&sp>]>"
            - define next_rank <[rank].add[1]>
            - define next_name <proc[get_demeter_rank_name].context[<[next_rank]>]>
            - define lore <[lore].include[<&e>Next Rank<&co> <&6><[next_name]>]>
            - define lore "<[lore].include[<&sp>]>"
            # Progress bars for next rank
            - choose <[next_rank]>:
                - case 1:
                    - define wheat_needed 2500
                    - define cows_needed 50
                - case 2:
                    - define wheat_needed 12000
                    - define cows_needed 300
                - case 3:
                    - define wheat_needed 50000
                    - define cows_needed 700
            # Wheat progress bar
            - define wheat_percent <[wheat].div[<[wheat_needed]>].mul[100].round.min[100]>
            - define wheat_bar <proc[create_progress_bar].context[<[wheat_percent]>]>
            - define lore <[lore].include[<&7>Wheat<&co> <&e><[wheat]>/<[wheat_needed]>]>
            - define lore <[lore].include[<[wheat_bar]>]>
            - define lore "<[lore].include[<&sp>]>"
            # Cow progress bar
            - define cows_percent <[cows].div[<[cows_needed]>].mul[100].round.min[100]>
            - define cows_bar <proc[create_progress_bar].context[<[cows_percent]>]>
            - define lore <[lore].include[<&7>Cows<&co> <&e><[cows]>/<[cows_needed]>]>
            - define lore <[lore].include[<[cows_bar]>]>

        - determine <item[golden_hoe].with[display_name=<&6><&l><[rank_name]>;lore=<[lore]>;enchantments=mending,1;hides=ALL]>

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
