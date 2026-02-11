# Profile GUI Script
# Command: /profile - Opens a GUI showing the player's head, emblem, and progression
#
# V2: Integrated with emblem system V2
# - Shows active emblem
# - Shows Demeter progress (if DEMETER emblem)
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

    # Row 3: Active emblem (19), Progression (21), Emblems (23), Cosmetics (25), Bulletin (27)
    - define emblem_item <proc[get_emblem_display_item]>
    - define items <[items].set[<[emblem_item]>].at[19]>

    - define ranks_item <proc[get_emblem_rank_icon_item]>
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

get_emblem_display_item:
    type: procedure
    debug: false
    script:
    - if !<player.has_flag[emblem.active]>:
        - define lore <list>
        - define lore <[lore].include[<&7><&o>"The gods await your decision..."]>
        - define lore <[lore].include[<empty>]>
        - define lore <[lore].include[<&7>You have not chosen an emblem yet.]>
        - define lore <[lore].include[<empty>]>
        - define lore <[lore].include[<&e>Speak to Promachos to choose an emblem]>
        - determine <item[compass].with[display=<&6>No Emblem Selected;lore=<[lore]>]>

    - define emblem <player.flag[emblem.active]>
    - define display <proc[get_emblem_display_name].context[<[emblem]>]>
    - define god <proc[get_god_for_emblem].context[<[emblem]>]>
    - define icon <proc[get_emblem_icon].context[<[emblem]>]>

    - define lore <list>
    - choose <[emblem]>:
        - case DEMETER:
            - define lore <[lore].include[<&e>Patron<&co> <&6><[god]><&7>, Goddess of Harvest]>
            - define lore "<[lore].include[<&sp>]>"

            # Show actual progress stats
            - define wheat <player.flag[demeter.wheat.count].if_null[0]>
            - define cows <player.flag[demeter.cows.count].if_null[0]>
            - define cakes <player.flag[demeter.cakes.count].if_null[0]>
            - define keys <player.flag[demeter.wheat.keys_awarded].if_null[0].add[<player.flag[demeter.cows.keys_awarded].if_null[0]>].add[<player.flag[demeter.cakes.keys_awarded].if_null[0]>]>

            - define lore <[lore].include[<&6>Your Progress<&co>]>
            - define lore <[lore].include[<&7>• Wheat harvested<&co> <&e><[wheat].format_number>]>
            - define lore <[lore].include[<&7>• Cows bred<&co> <&e><[cows].format_number>]>
            - define lore <[lore].include[<&7>• Cakes crafted<&co> <&e><[cakes].format_number>]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&6>Keys earned<&co> <&e><[keys]> <&7>Demeter Keys]>

        - case HEPHAESTUS:
            - define lore <[lore].include[<&e>Patron<&co> <&6><[god]><&7>, God of the Forge]>
            - define lore "<[lore].include[<&sp>]>"

            # Show actual progress stats
            - define iron <player.flag[hephaestus.iron.count].if_null[0]>
            - define smelting <player.flag[hephaestus.smelting.count].if_null[0]>
            - define golems <player.flag[hephaestus.golems.count].if_null[0]>
            - define keys <player.flag[hephaestus.iron.keys_awarded].if_null[0].add[<player.flag[hephaestus.smelting.keys_awarded].if_null[0]>].add[<player.flag[hephaestus.golems.keys_awarded].if_null[0]>]>

            - define lore <[lore].include[<&7>Your Progress<&co>]>
            - define lore <[lore].include[<&8>• Iron ore mined<&co> <&f><[iron].format_number>]>
            - define lore <[lore].include[<&8>• Items smelted<&co> <&f><[smelting].format_number>]>
            - define lore <[lore].include[<&8>• Golems created<&co> <&f><[golems].format_number>]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&7>Keys earned<&co> <&f><[keys]> <&8>Hephaestus Keys]>
        - case HERACLES:
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

            - define lore <[lore].include[<&c>Your<&sp>Progress<&co>]>
            - define lore <[lore].include[<&7>•<&sp>Pillagers<&sp>slain<&co><&sp><&c><[pillagers].format_number>]>
            - define lore <[lore].include[<&7>•<&sp>Raids<&sp>defended<&co><&sp><&c><[raids].format_number>]>
            - define lore <[lore].include[<&7>•<&sp>Emeralds<&sp>traded<&co><&sp><&c><[emeralds].format_number>]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&c>Keys<&sp>earned<&co><&sp><&c><[keys]><&sp><&7>Heracles<&sp>Keys]>
        - case TRITON:
            - define lore <[lore].include[<&e>Patron<&co> <&3><[god]><&7>, God of the Sea]>
            - define lore "<[lore].include[<&sp>]>"

            # Show actual progress stats
            - define lanterns <player.flag[triton.lanterns.count].if_null[0]>
            - define guardians <player.flag[triton.guardians.count].if_null[0]>
            - define conduits <player.flag[triton.conduits.count].if_null[0]>
            - define keys <player.flag[triton.lanterns.keys_awarded].if_null[0].add[<player.flag[triton.guardians.keys_awarded].if_null[0]>].add[<player.flag[triton.conduits.keys_awarded].if_null[0]>]>

            - define lore <[lore].include[<&3>Your Progress<&co>]>
            - define lore <[lore].include[<&7>• Sea lanterns offered<&co> <&3><[lanterns].format_number>]>
            - define lore <[lore].include[<&7>• Guardians slain<&co> <&3><[guardians].format_number>]>
            - define lore <[lore].include[<&7>• Conduits crafted<&co> <&3><[conduits].format_number>]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&3>Keys earned<&co> <&3><[keys]> <&7>Triton Keys]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&8>Change emblem by speaking to Promachos]>

    - determine <item[<[icon]>].with[display=<&6><&l><[display]>;lore=<[lore]>;enchantments=mending,1;hides=ALL]>

# Rank data: titles and materials for each rank level
# Rank 0: Uninitiated (no emblems)
# Rank 1: Neophyte (1 emblem)
# Rank 2: Mystes (2 emblems)
# Rank 3: Epoptes (3 emblems)
# Rank 4: Aristos (4 emblems)
# Rank 5: Heros (5 emblems)
# Rank 6: Hemitheos (6 emblems)
player_rank_data:
    type: data
    titles:
        0: Uninitiated
        1: Neophyte
        2: Mystes
        3: Epoptes
        4: Aristos
        5: Heros
        6: Hemitheos
    flavor:
        0: Your legend has yet to begin...
        1: A new initiate of the sacred rites
        2: You walk among the initiated
        3: The mysteries reveal themselves to you
        4: Excellence flows through your deeds
        5: Your name echoes through the ages
        6: The blood of gods runs in your veins
    materials:
        0: clay_ball
        1: iron_nugget
        2: gold_nugget
        3: gold_ingot
        4: diamond
        5: emerald
        6: nether_star

get_emblem_rank_icon_item:
    type: procedure
    debug: false
    script:
    - define rank <player.flag[emblem.rank].if_null[0]>
    - if <[rank]> > 6:
        - define rank 6

    # Look up rank data
    - define title <script[player_rank_data].data_key[titles.<[rank]>]>
    - define flavor <script[player_rank_data].data_key[flavor.<[rank]>]>
    - define mat <script[player_rank_data].data_key[materials.<[rank]>]>

    # Colors defined inline so formatting tags are parsed properly
    - define colors <list[<&7>|<&f>|<&e>|<&6>|<&b>|<&d>|<&5>]>
    - define color <[colors].get[<[rank].add[1]>]>

    - define lore <list>
    - define lore <[lore].include[<&7><&o>"<[flavor]>"]>
    - define lore "<[lore].include[<&sp>]>"

    # Current rank display
    - define lore <[lore].include[<&e>Rank<&co> <[color]><[title]>]>
    - define lore <[lore].include[<&7>Emblems earned<&co> <&f><[rank]>]>
    - define lore "<[lore].include[<&sp>]>"

    # Progress to next rank
    - if <[rank]> < 6:
        - define next_rank <[rank].add[1]>
        - define next_title <script[player_rank_data].data_key[titles.<[next_rank]>]>
        - define next_color <[colors].get[<[next_rank].add[1]>]>
        - define lore <[lore].include[<&7>Next rank<&co> <[next_color]><[next_title]>]>
        - define lore <[lore].include[<&8>Earn an emblem to advance]>
    - else:
        - define lore <[lore].include[<&d>✦ <&5>Maximum rank achieved <&d>✦]>

    # Rank ladder overview
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&e>All Ranks<&co>]>
    - foreach <list[0|1|2|3|4|5|6]> as:r:
        - define r_title <script[player_rank_data].data_key[titles.<[r]>]>
        - define r_color <[colors].get[<[r].add[1]>]>
        - if <[r]> == <[rank]>:
            - define lore <[lore].include[<&6>▸ <[r_color]><[r_title]>]>
        - else if <[r]> < <[rank]>:
            - define lore <[lore].include[<&8>  <[r_color]><[r_title]>]>
        - else:
            - define lore <[lore].include[<&8>  <[r_title]>]>

    - if <[rank]> > 0:
        - determine <item[<[mat]>].with[display=<[color]><&l><[title]>;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - else:
        - determine <item[<[mat]>].with[display=<[color]><&l><[title]>;lore=<[lore]>]>

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
        after player clicks item in profile_inventory:
        # Rank icon (slot 21)
        - if <context.raw_slot> == 21:
            - define rank <player.flag[emblem.rank].if_null[0]>
            - define title <script[player_rank_data].data_key[titles.<[rank].min[6]>]>
            - narrate "<&7>Your rank<&co> <&e><[title]><&7>. Earn emblems to advance!"
            - playsound <player> sound:entity_villager_ambient
            - stop

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
        # Check if clicking Triton emblem (trident item)
        - else if <context.item.material.name> == trident:
            - if !<proc[can_access_tier].context[<player>|2]>:
                - narrate "<&c>You haven't unlocked Tier 2 emblems yet. Complete 2 Tier 1 emblems first."
                - playsound <player> sound:entity_villager_no
                - stop
            - inventory open d:triton_progress_gui

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

        # Triton progress GUI clicks
        after player clicks triton_progress_back_button in triton_progress_gui:
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

    # Meta-crate progress (bottom right slot 27)
    - define items <[items].set[<proc[get_ceres_meta_progress_item]>].at[27]>

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
    - if !<[complete]>:
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
    - define lore <[lore].include[<&8><&o>Complete all components to earn the emblem.]>

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
    - if !<[complete]>:
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
    - define lore <[lore].include[<&8><&o>Complete all components to earn the emblem.]>

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
    - if !<[complete]>:
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
    - define lore <[lore].include[<&8><&o>Complete all components to earn the emblem.]>

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

    # Meta-crate progress (bottom right slot 27)
    - define items <[items].set[<proc[get_mars_meta_progress_item]>].at[27]>

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
    - if !<[complete]>:
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
    - define lore <[lore].include[<&8><&o>Complete<&sp>all<&sp>components<&sp>to<&sp>earn<&sp>the<&sp>emblem.]>

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
    - if !<[complete]>:
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
    - define lore <[lore].include[<&8><&o>Complete<&sp>all<&sp>components<&sp>to<&sp>earn<&sp>the<&sp>emblem.]>

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
    - if !<[complete]>:
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
    - define lore <[lore].include[<&8><&o>Complete<&sp>all<&sp>components<&sp>to<&sp>earn<&sp>the<&sp>emblem.]>

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

    # Meta-crate progress (bottom right slot 27)
    - define items <[items].set[<proc[get_vulcan_meta_progress_item]>].at[27]>

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
    - if !<[complete]>:
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
    - define lore <[lore].include[<&7><&o>Complete all components to earn the emblem.]>

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
    - if !<[complete]>:
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
    - define lore <[lore].include[<&7><&o>Complete all components to earn the emblem.]>

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
    - if !<[complete]>:
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
    - define lore <[lore].include[<&7><&o>Complete all components to earn the emblem.]>

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

# ============================================
# TRITON DETAILED PROGRESS GUI
# ============================================

triton_progress_gui:
    type: inventory
    inventory: chest
    gui: true
    debug: false
    title: <&8>Triton - Activity Progress
    size: 27
    procedural items:
    - determine <proc[get_triton_progress_items]>

get_triton_progress_items:
    type: procedure
    debug: false
    script:
    - define items <list>
    - define filler <item[gray_stained_glass_pane].with[display=<empty>]>

    # Fill all slots
    - repeat 27:
        - define items <[items].include[<[filler]>]>

    # Row 2: Three activity items centered (slots 12, 14, 16)
    - define lantern_item <proc[get_triton_lanterns_progress_item]>
    - define items <[items].set[<[lantern_item]>].at[12]>

    - define guardian_item <proc[get_triton_guardians_progress_item]>
    - define items <[items].set[<[guardian_item]>].at[14]>

    - define conduit_item <proc[get_triton_conduits_progress_item]>
    - define items <[items].set[<[conduit_item]>].at[16]>

    # Meta-crate progress (bottom right slot 27)
    - define items <[items].set[<proc[get_neptune_meta_progress_item]>].at[27]>

    # Back button (bottom left slot 19)
    - define items <[items].set[<item[triton_progress_back_button]>].at[19]>

    - determine <[items]>

get_triton_lanterns_progress_item:
    type: procedure
    debug: false
    script:
    - define count <player.flag[triton.lanterns.count].if_null[0]>
    - define complete <player.has_flag[triton.component.lanterns]>

    - define lore <list>
    - if !<[complete]>:
        - define lore <[lore].include[<&7>Component In Progress]>
        - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7><&o>"Illuminate the abyss with sacred light"]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&3>Task<&co> <&7>Offer sea lanterns to Triton.]>
    - define lore <[lore].include[<&7>Each lantern offered strengthens]>
    - define lore <[lore].include[<&7>the bond with the sea god.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&3>Component Progress<&co>]>
    - define lore <[lore].include[<&7><[count]> / 1,000 sea lanterns offered]>
    - if <[complete]>:
        - define percent 100
    - else:
        - define percent <[count].div[1000].mul[100].round>
    - define lore <[lore].include[<&7>(<[percent]>% complete)]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&8><&o>Complete all components to earn the emblem.]>

    - if <[complete]>:
        - determine <item[sea_lantern].with[display=<&3><&l>Sea Lanterns;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - else:
        - determine <item[sea_lantern].with[display=<&3><&l>Sea Lanterns;lore=<[lore]>]>

get_triton_guardians_progress_item:
    type: procedure
    debug: false
    script:
    - define count <player.flag[triton.guardians.count].if_null[0]>
    - define complete <player.has_flag[triton.component.guardians]>

    - define lore <list>
    - if !<[complete]>:
        - define lore <[lore].include[<&7>Component In Progress]>
        - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7><&o>"Purge the ocean's corrupted sentinels"]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&3>Task<&co> <&7>Slay guardians and elder guardians.]>
    - define lore <[lore].include[<&7>Regular guardians count +1,]>
    - define lore <[lore].include[<&7>elder guardians count +15.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&3>Component Progress<&co>]>
    - define lore <[lore].include[<&7><[count]> / 1,500 guardian kills]>
    - if <[complete]>:
        - define percent 100
    - else:
        - define percent <[count].div[1500].mul[100].round>
    - define lore <[lore].include[<&7>(<[percent]>% complete)]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&8><&o>Complete all components to earn the emblem.]>

    - if <[complete]>:
        - determine <item[prismarine_crystals].with[display=<&3><&l>Guardian Slayer;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - else:
        - determine <item[prismarine_crystals].with[display=<&3><&l>Guardian Slayer;lore=<[lore]>]>

get_triton_conduits_progress_item:
    type: procedure
    debug: false
    script:
    - define count <player.flag[triton.conduits.count].if_null[0]>
    - define complete <player.has_flag[triton.component.conduits]>

    - define lore <list>
    - if !<[complete]>:
        - define lore <[lore].include[<&7>Component In Progress]>
        - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7><&o>"Channel the ocean's ancient power"]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&3>Task<&co> <&7>Craft conduits from hearts]>
    - define lore <[lore].include[<&7>of the sea and nautilus shells.]>
    - define lore <[lore].include[<&7>Each conduit channels Triton's power.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&3>Component Progress<&co>]>
    - define lore <[lore].include[<&7><[count]> / 25 conduits crafted]>
    - if <[complete]>:
        - define percent 100
    - else:
        - define percent <[count].div[25].mul[100].round>
    - define lore <[lore].include[<&7>(<[percent]>% complete)]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&8><&o>Complete all components to earn the emblem.]>

    - if <[complete]>:
        - determine <item[conduit].with[display=<&3><&l>Conduit Crafting;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - else:
        - determine <item[conduit].with[display=<&3><&l>Conduit Crafting;lore=<[lore]>]>

triton_progress_back_button:
    type: item
    material: arrow
    display name: <&e>← Back
    lore:
    - <&7>Return<&sp>to<&sp>emblems

# ============================================
# META-CRATE PROGRESS ITEMS
# ============================================

get_ceres_meta_progress_item:
    type: procedure
    debug: false
    script:
    - define count 0
    - if <player.has_flag[ceres.item.title]>:
        - define count <[count].add[1]>
    - if <player.has_flag[ceres.item.shulker]>:
        - define count <[count].add[1]>
    - if <player.has_flag[ceres.item.wand]>:
        - define count <[count].add[1]>
    - if <player.has_flag[ceres.item.head]>:
        - define count <[count].add[1]>
    - define lore <list>
    - define lore <[lore].include[<&7><&o>"Treasures of the harvest goddess"]>
    - define lore "<[lore].include[<&sp>]>"
    - if <[count]> == 4:
        - define lore <[lore].include[<&a><&l>All Items Collected]>
    - else:
        - define lore <[lore].include[<&e>Collected<&co> <&7><[count]>/4 unique items]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7>Obtained from the Ceres Grove]>
    - define lore <[lore].include[<&7>via Olympian key drops.]>
    - if <[count]> == 4:
        - determine <item[nether_star].with[display=<&6><&l>Ceres Grove;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - determine <item[nether_star].with[display=<&6><&l>Ceres Grove;lore=<[lore]>]>

get_mars_meta_progress_item:
    type: procedure
    debug: false
    script:
    - define count 0
    - if <player.has_flag[mars.item.title]>:
        - define count <[count].add[1]>
    - if <player.has_flag[mars.item.shulker]>:
        - define count <[count].add[1]>
    - if <player.has_flag[mars.item.shield]>:
        - define count <[count].add[1]>
    - if <player.has_flag[mars.item.head]>:
        - define count <[count].add[1]>
    - define lore <list>
    - define lore <[lore].include[<&7><&o>"Spoils of the war god's arena"]>
    - define lore "<[lore].include[<&sp>]>"
    - if <[count]> == 4:
        - define lore <[lore].include[<&a><&l>All Items Collected]>
    - else:
        - define lore <[lore].include[<&e>Collected<&co> <&7><[count]>/4 unique items]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7>Obtained from the Mars Arena]>
    - define lore <[lore].include[<&7>via Olympian key drops.]>
    - if <[count]> == 4:
        - determine <item[nether_star].with[display=<&c><&l>Mars Arena;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - determine <item[nether_star].with[display=<&c><&l>Mars Arena;lore=<[lore]>]>

get_vulcan_meta_progress_item:
    type: procedure
    debug: false
    script:
    - define count 0
    - if <player.has_flag[vulcan.item.title]>:
        - define count <[count].add[1]>
    - if <player.has_flag[vulcan.item.shulker]>:
        - define count <[count].add[1]>
    - if <player.has_flag[vulcan.item.pickaxe]>:
        - define count <[count].add[1]>
    - if <player.has_flag[vulcan.item.head]>:
        - define count <[count].add[1]>
    - define lore <list>
    - define lore <[lore].include[<&7><&o>"Relics of the forge master"]>
    - define lore "<[lore].include[<&sp>]>"
    - if <[count]> == 4:
        - define lore <[lore].include[<&a><&l>All Items Collected]>
    - else:
        - define lore <[lore].include[<&e>Collected<&co> <&7><[count]>/4 unique items]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7>Obtained from the Vulcan Crucible]>
    - define lore <[lore].include[<&7>via Olympian key drops.]>
    - if <[count]> == 4:
        - determine <item[nether_star].with[display=<&8><&l>Vulcan Crucible;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - determine <item[nether_star].with[display=<&8><&l>Vulcan Crucible;lore=<[lore]>]>

get_neptune_meta_progress_item:
    type: procedure
    debug: false
    script:
    - define count 0
    - if <player.has_flag[neptune.item.title]>:
        - define count <[count].add[1]>
    - if <player.has_flag[neptune.item.shulker]>:
        - define count <[count].add[1]>
    - if <player.has_flag[neptune.item.trident_blueprint]>:
        - define count <[count].add[1]>
    - if <player.has_flag[neptune.item.head]>:
        - define count <[count].add[1]>
    - define lore <list>
    - define lore <[lore].include[<&7><&o>"Artifacts of the ocean depths"]>
    - define lore "<[lore].include[<&sp>]>"
    - if <[count]> == 4:
        - define lore <[lore].include[<&a><&l>All Items Collected]>
    - else:
        - define lore <[lore].include[<&e>Collected<&co> <&7><[count]>/4 unique items]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7>Obtained from the Neptune Depths]>
    - define lore <[lore].include[<&7>via Olympian key drops.]>
    - if <[count]> == 4:
        - determine <item[nether_star].with[display=<&3><&l>Neptune Depths;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - determine <item[nether_star].with[display=<&3><&l>Neptune Depths;lore=<[lore]>]>

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

    # Count available titles (meta-progression only)
    - define title_count 0
    - if <player.has_flag[ceres.item.title]>:
        - define title_count <[title_count].add[1]>
    - if <player.has_flag[vulcan.item.title]>:
        - define title_count <[title_count].add[1]>
    - if <player.has_flag[mars.item.title]>:
        - define title_count <[title_count].add[1]>
    - if <player.has_flag[neptune.item.title]>:
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
            - case vulcan:
                - define lore "<[lore].include[<&7><&lb>Vulcan's Chosen<&rb>]>"
            - case mars:
                - define lore "<[lore].include[<&4><&lb>Mars' Chosen<&rb>]>"
            - case neptune:
                - define lore "<[lore].include[<&3><&lb>Neptune's Chosen<&rb>]>"
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

    # Show 4 meta-progression titles centered (slots 11, 13, 15, 17)
    - define items <[items].set[<proc[get_ceres_title_item]>].at[11]>
    - define items <[items].set[<proc[get_vulcan_title_item]>].at[13]>
    - define items <[items].set[<proc[get_mars_title_item]>].at[15]>
    - define items <[items].set[<proc[get_neptune_title_item]>].at[17]>

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


get_neptune_title_item:
    type: procedure
    debug: false
    script:
    - define lore <list>

    # Check if unlocked
    - if <player.has_flag[neptune.item.title]>:
        - define lore "<[lore].include[<&3><&lb>Neptune's Chosen<&rb>]>"
        - define lore "<[lore].include[<&sp>]>"
        - if <player.has_flag[cosmetic.title.active]> && <player.flag[cosmetic.title.active]> == neptune:
            - define lore <[lore].include[<&2>✓ Currently Active]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&e>Click to unequip]>
            - determine <item[name_tag].with[display=<&3><&l>Neptune Title;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
        - else:
            - define lore <[lore].include[<&7>Not equipped]>
            - define lore "<[lore].include[<&sp>]>"
            - define lore <[lore].include[<&e>Click to equip]>
            - determine <item[name_tag].with[display=<&3><&l>Neptune Title;lore=<[lore]>]>
    - else:
        - define lore <[lore].include[<&8>???]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&7>Unlock from<&co> <&3>Neptune Crates]>
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

        # Determine which title was clicked based on slot (11=Ceres, 13=Vulcan, 15=Mars, 17=Neptune)
        - if <context.slot> == 11:
            - define clicked_title ceres
            - define title_flag ceres.item.title
            - define title_name "<&6>[Ceres' Chosen]"
        - else if <context.slot> == 13:
            - define clicked_title vulcan
            - define title_flag vulcan.item.title
            - define title_name "<&8>[Vulcan's Chosen]"
        - else if <context.slot> == 15:
            - define clicked_title mars
            - define title_flag mars.item.title
            - define title_name "<&4>[Mars' Chosen]"
        - else if <context.slot> == 17:
            - define clicked_title neptune
            - define title_flag neptune.item.title
            - define title_name "<&3>[Neptune's Chosen]"

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


