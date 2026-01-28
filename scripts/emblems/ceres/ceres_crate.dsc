# ============================================
# EMBLEM SYSTEM V2 - CERES CRATE
# ============================================
#
# Ceres crate opening system:
# - 50% chance: Enchanted Golden Apple
# - 50% chance: Unique item from finite pool (4 items total)
# - Once all 4 items obtained → always god apple
#

# ============================================
# KEY USAGE EVENT
# ============================================

ceres_key_usage:
    type: world
    debug: false
    events:
        on player right clicks block with:ceres_key:
        - determine cancelled passively

        # Temporary OP-only restriction
        - if !<player.is_op>:
            - narrate "<&e>Crate system coming soon!"
            - stop

        # Take 1 key immediately
        - take item:ceres_key quantity:1

        # Start crate animation
        - run ceres_crate_animation

        # Track statistics (optional)
        - flag player ceres.crates_opened:++

ceres_crate_animation:
    type: task
    script:
    # Narrate opening message
    - narrate "<&7>You unlock the <&b>Ceres Vault<&7>..."

    # Open GUI with cyan panes
    - define filler <item[cyan_stained_glass_pane].with[display_name=<&7>]>
    - define gui_items <list>
    - repeat 27:
        - define gui_items <[gui_items].include[<[filler]>]>

    - inventory open d:ceres_crate_gui
    - inventory set d:<player.open_inventory> o:<[gui_items]>

    # Cycling animation (1s) - alternate between god apple and mystery
    - repeat 5:
        - if <[value].mod[2]> == 0:
            - inventory set d:<player.open_inventory> o:<item[enchanted_golden_apple]> slot:14
        - else:
            - inventory set d:<player.open_inventory> o:<item[gray_dye].with[display_name=<&8>???]> slot:14
        - playsound <player> sound:block_beacon_ambient volume:0.3
        - wait 2t

    # Roll outcome
    - define result <proc[roll_ceres_outcome]>

    # Show result item
    - inventory set d:<player.open_inventory> o:<[result].get[item]> slot:14
    - wait 20t

    # Award loot
    - run award_ceres_loot def:<[result]>

    # Close GUI
    - inventory close

ceres_crate_gui:
    type: inventory
    inventory: chest
    gui: true
    title: <&8>Ceres Vault - Opening...
    size: 27

# ============================================
# OUTCOME ROLLING
# ============================================

roll_ceres_outcome:
    type: procedure
    script:
    # Check if all items obtained
    - define all_obtained true
    - if !<player.has_flag[ceres.item.hoe]>:
        - define all_obtained false
    - if !<player.has_flag[ceres.item.title]>:
        - define all_obtained false
    - if !<player.has_flag[ceres.item.shulker]>:
        - define all_obtained false
    - if !<player.has_flag[ceres.item.wand]>:
        - define all_obtained false

    # If all obtained, force god apple
    - if <[all_obtained]>:
        - define result_map <map[type=GOD_APPLE;item=<item[enchanted_golden_apple]>;display=Enchanted Golden Apple]>
        - determine <[result_map]>

    # Roll 50/50
    - define roll <util.random.int[1].to[2]>

    # Path A: God Apple (roll = 1)
    - if <[roll]> == 1:
        - define result_map <map[type=GOD_APPLE;item=<item[enchanted_golden_apple]>;display=Enchanted Golden Apple]>
        - determine <[result_map]>

    # Path B: Unique Item (roll = 2)
    # Get unobtained items
    - define available <list>
    - if !<player.has_flag[ceres.item.hoe]>:
        - define available <[available].include[hoe]>
    - if !<player.has_flag[ceres.item.title]>:
        - define available <[available].include[title]>
    - if !<player.has_flag[ceres.item.shulker]>:
        - define available <[available].include[shulker]>
    - if !<player.has_flag[ceres.item.wand]>:
        - define available <[available].include[wand]>

    # Select random from available
    - define chosen <[available].random>

    # Build result map
    - choose <[chosen]>:
        - case hoe:
            - define result_map <map[type=UNIQUE;item_id=hoe;item=<item[ceres_hoe]>;display=Ceres Hoe]>
        - case title:
            - define result_map <map[type=UNIQUE;item_id=title;item=<item[book].with[display_name=<&d><&l>CERES TITLE<&r>;lore=<&7>Cosmetic unlock:|<&6>[Ceres' Chosen]<&7> title]>;display=Ceres Title]>
        - case shulker:
            - define result_map <map[type=UNIQUE;item_id=shulker;item=<item[yellow_shulker_box]>;display=Yellow Shulker Box]>
        - case wand:
            - define result_map <map[type=UNIQUE;item_id=wand;item=<item[ceres_wand]>;display=Ceres Wand]>

    - determine <[result_map]>

# ============================================
# LOOT AWARDING
# ============================================

award_ceres_loot:
    type: task
    definitions: result
    script:
    - choose <[result].get[type]>:
        # God Apple
        - case GOD_APPLE:
            - give enchanted_golden_apple
            - narrate "<&b>[CERES]<&r> Enchanted Golden Apple"
            - playsound <player> sound:entity_player_levelup
            - flag player ceres.god_apples:++

        # Unique Item
        - case UNIQUE:
            - define item_id <[result].get[item_id]>

            # Award item
            - choose <[item_id]>:
                - case hoe:
                    - give ceres_hoe
                    - flag player ceres.item.hoe:true
                - case title:
                    - flag player ceres.item.title:true
                    # No physical item for title (just flag)
                - case shulker:
                    - give yellow_shulker_box
                    - flag player ceres.item.shulker:true
                - case wand:
                    - give ceres_wand
                    - flag player ceres.item.wand:true

            # Feedback
            - narrate "<&b>[CERES]<&r> <&d><[result].get[display]><&r> <&e>UNIQUE ITEM!"
            - playsound <player> sound:ui_toast_challenge_complete volume:1.0
            - playsound <player> sound:block_beacon_activate volume:0.5

            # Server announcement
            - announce "<&b><&l>OLYMPIAN DROP!<&r> <&f><player.name> <&7>obtained a unique Ceres item<&co> <&d><[result].get[display]><&7>!"

            # Track stats
            - flag player ceres.unique_items:++
