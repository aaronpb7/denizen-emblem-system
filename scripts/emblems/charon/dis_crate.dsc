# ============================================
# DIS CRATE - Meta-Progression
# ============================================
#
# Dis crate opening system:
# - 50% chance: Enchanted Golden Apple
# - 50% chance: Unique item from finite pool (4 items)
# - Once all 4 items obtained → always god apple
#

# ============================================
# KEY USAGE EVENT
# ============================================

dis_key_usage:
    type: world
    debug: false
    events:
        on player right clicks block with:dis_key:
        - determine cancelled passively

        # Roll outcome BEFORE taking key (safer)
        - define result <proc[roll_dis_outcome]>

        # Take 1 key after successful roll
        - take item:dis_key quantity:1

        # Start crate animation with pre-rolled result
        - run dis_crate_animation def.result:<[result]> id:dis_crate_<player.uuid>

        # Track statistics
        - flag player dis.crates_opened:++

dis_crate_animation:
    type: task
    debug: false
    definitions: result
    script:
    # Store result as flag for early close detection
    - flag player dis.crate.pending_result:<[result]>
    - flag player dis.crate.animation_running:true

    # Narrate opening message
    - narrate "<&7>You unlock the <&5>Dis Passage<&7>..."
    - playsound <player> sound:block_chest_open volume:1.0

    # Open GUI with purple border frame
    - define filler <item[gray_stained_glass_pane].with[display=<&7>]>
    - define border <item[purple_stained_glass_pane].with[display=<&5>]>
    - define gui_items <list>
    - repeat 27:
        - define gui_items <[gui_items].include[<[filler]>]>

    - inventory open d:dis_crate_gui
    - define crate_inv <player.open_inventory>
    - inventory set d:<[crate_inv]> o:<[gui_items]>

    # Set border frame around entire GUI
    # Top row (1-9)
    - inventory set d:<[crate_inv]> o:<[border]> slot:1
    - inventory set d:<[crate_inv]> o:<[border]> slot:2
    - inventory set d:<[crate_inv]> o:<[border]> slot:3
    - inventory set d:<[crate_inv]> o:<[border]> slot:4
    - inventory set d:<[crate_inv]> o:<[border]> slot:5
    - inventory set d:<[crate_inv]> o:<[border]> slot:6
    - inventory set d:<[crate_inv]> o:<[border]> slot:7
    - inventory set d:<[crate_inv]> o:<[border]> slot:8
    - inventory set d:<[crate_inv]> o:<[border]> slot:9
    # Middle row sides (10, 11, 17, 18)
    - inventory set d:<[crate_inv]> o:<[border]> slot:10
    - inventory set d:<[crate_inv]> o:<[border]> slot:11
    - inventory set d:<[crate_inv]> o:<[border]> slot:17
    - inventory set d:<[crate_inv]> o:<[border]> slot:18
    # Bottom row (19-27)
    - inventory set d:<[crate_inv]> o:<[border]> slot:19
    - inventory set d:<[crate_inv]> o:<[border]> slot:20
    - inventory set d:<[crate_inv]> o:<[border]> slot:21
    - inventory set d:<[crate_inv]> o:<[border]> slot:22
    - inventory set d:<[crate_inv]> o:<[border]> slot:23
    - inventory set d:<[crate_inv]> o:<[border]> slot:24
    - inventory set d:<[crate_inv]> o:<[border]> slot:25
    - inventory set d:<[crate_inv]> o:<[border]> slot:26
    - inventory set d:<[crate_inv]> o:<[border]> slot:27

    # SCROLLING REEL ANIMATION
    # Alternates between god apple and mystery item
    - define preview_pool <list>
    - define preview_pool <[preview_pool].include[<item[enchanted_golden_apple]>]>
    - define preview_pool <[preview_pool].include[<item[gray_dye]>]>
    - define preview_pool <[preview_pool].include[<item[enchanted_golden_apple]>]>
    - define preview_pool <[preview_pool].include[<item[gray_dye]>]>
    - define preview_pool <[preview_pool].include[<item[enchanted_golden_apple]>]>
    - define preview_pool <[preview_pool].include[<item[gray_dye]>]>

    # Initialize scrolling slots with random items
    - define slot1 <[preview_pool].random>
    - define slot2 <[preview_pool].random>
    - define slot3 <[preview_pool].random>
    - define slot4 <[preview_pool].random>
    - define slot5 <[preview_pool].random>

    # Enhance mystery item display
    - if <[slot1].material.name> == gray_dye:
        - define slot1 <[slot1].with[display=<&8>???]>
    - if <[slot2].material.name> == gray_dye:
        - define slot2 <[slot2].with[display=<&8>???]>
    - if <[slot3].material.name> == gray_dye:
        - define slot3 <[slot3].with[display=<&8>???]>
    - if <[slot4].material.name> == gray_dye:
        - define slot4 <[slot4].with[display=<&8>???]>
    - if <[slot5].material.name> == gray_dye:
        - define slot5 <[slot5].with[display=<&8>???]>

    # Phase 1: Fast scroll (20 cycles, 2t each = 2s)
    - repeat 20:
        - if !<player.has_flag[dis.crate.animation_running]>:
            - stop

        - define slot1 <[slot2]>
        - define slot2 <[slot3]>
        - define slot3 <[slot4]>
        - define slot4 <[slot5]>
        - define new_item <[preview_pool].random>
        - if <[new_item].material.name> == gray_dye:
            - define slot5 <[new_item].with[display=<&8>???]>
        - else:
            - define slot5 <[new_item]>

        - inventory set d:<[crate_inv]> slot:12 o:<[slot1]>
        - inventory set d:<[crate_inv]> slot:13 o:<[slot2]>
        - inventory set d:<[crate_inv]> slot:14 o:<[slot3]>
        - inventory set d:<[crate_inv]> slot:15 o:<[slot4]>
        - inventory set d:<[crate_inv]> slot:16 o:<[slot5]>
        - playsound <player> sound:ui_button_click volume:0.2 pitch:1.5
        - wait 2t

    # Phase 2: Medium scroll (10 cycles, 3t each = 1.5s)
    - repeat 10:
        - if !<player.has_flag[dis.crate.animation_running]>:
            - stop

        - define slot1 <[slot2]>
        - define slot2 <[slot3]>
        - define slot3 <[slot4]>
        - define slot4 <[slot5]>
        - define new_item <[preview_pool].random>
        - if <[new_item].material.name> == gray_dye:
            - define slot5 <[new_item].with[display=<&8>???]>
        - else:
            - define slot5 <[new_item]>

        - inventory set d:<[crate_inv]> slot:12 o:<[slot1]>
        - inventory set d:<[crate_inv]> slot:13 o:<[slot2]>
        - inventory set d:<[crate_inv]> slot:14 o:<[slot3]>
        - inventory set d:<[crate_inv]> slot:15 o:<[slot4]>
        - inventory set d:<[crate_inv]> slot:16 o:<[slot5]>
        - playsound <player> sound:ui_button_click volume:0.3 pitch:1.2
        - wait 3t

    # Phase 3: Slow scroll (5 cycles, 5t each = 1.25s)
    - repeat 5:
        - if !<player.has_flag[dis.crate.animation_running]>:
            - stop

        - define slot1 <[slot2]>
        - define slot2 <[slot3]>
        - define slot3 <[slot4]>
        - define slot4 <[slot5]>
        - define new_item <[preview_pool].random>
        - if <[new_item].material.name> == gray_dye:
            - define slot5 <[new_item].with[display=<&8>???]>
        - else:
            - define slot5 <[new_item]>

        - inventory set d:<[crate_inv]> slot:12 o:<[slot1]>
        - inventory set d:<[crate_inv]> slot:13 o:<[slot2]>
        - inventory set d:<[crate_inv]> slot:14 o:<[slot3]>
        - inventory set d:<[crate_inv]> slot:15 o:<[slot4]>
        - inventory set d:<[crate_inv]> slot:16 o:<[slot5]>
        - playsound <player> sound:ui_button_click volume:0.4 pitch:0.9
        - wait 5t

    # Final landing animation - winning item scrolls into center
    - define final_display_item <[result].get[item]>

    # Step 1: Final item enters at slot 16 (far right)
    - define slot1 <[slot2]>
    - define slot2 <[slot3]>
    - define slot3 <[slot4]>
    - define slot4 <[slot5]>
    - define slot5 <[final_display_item]>

    - inventory set d:<[crate_inv]> slot:12 o:<[slot1]>
    - inventory set d:<[crate_inv]> slot:13 o:<[slot2]>
    - inventory set d:<[crate_inv]> slot:14 o:<[slot3]>
    - inventory set d:<[crate_inv]> slot:15 o:<[slot4]>
    - inventory set d:<[crate_inv]> slot:16 o:<[slot5]>
    - playsound <player> sound:ui_button_click volume:0.4 pitch:0.9
    - wait 5t

    # Step 2: Final item moves to slot 15
    - define slot1 <[slot2]>
    - define slot2 <[slot3]>
    - define slot3 <[slot4]>
    - define slot4 <[slot5]>
    - define new_item <[preview_pool].random>
    - if <[new_item].material.name> == gray_dye:
        - define slot5 <[new_item].with[display=<&8>???]>
    - else:
        - define slot5 <[new_item]>

    - inventory set d:<[crate_inv]> slot:12 o:<[slot1]>
    - inventory set d:<[crate_inv]> slot:13 o:<[slot2]>
    - inventory set d:<[crate_inv]> slot:14 o:<[slot3]>
    - inventory set d:<[crate_inv]> slot:15 o:<[slot4]>
    - inventory set d:<[crate_inv]> slot:16 o:<[slot5]>
    - playsound <player> sound:ui_button_click volume:0.4 pitch:0.9
    - wait 5t

    # Step 3: Final item lands at slot 14 (center)
    - define slot1 <[slot2]>
    - define slot2 <[slot3]>
    - define slot3 <[slot4]>
    - define slot4 <[slot5]>
    - define new_item <[preview_pool].random>
    - if <[new_item].material.name> == gray_dye:
        - define slot5 <[new_item].with[display=<&8>???]>
    - else:
        - define slot5 <[new_item]>

    - inventory set d:<[crate_inv]> slot:12 o:<[slot1]>
    - inventory set d:<[crate_inv]> slot:13 o:<[slot2]>
    - inventory set d:<[crate_inv]> slot:14 o:<[slot3]>
    - inventory set d:<[crate_inv]> slot:15 o:<[slot4]>
    - inventory set d:<[crate_inv]> slot:16 o:<[slot5]>
    - playsound <player> sound:ui_button_click volume:0.5 pitch:1.0
    - wait 5t

    # Clear surrounding slots, leave final item in center
    - inventory set d:<[crate_inv]> o:<[filler]> slot:12
    - inventory set d:<[crate_inv]> o:<[filler]> slot:13
    - inventory set d:<[crate_inv]> o:<[filler]> slot:15
    - inventory set d:<[crate_inv]> o:<[filler]> slot:16
    - wait 16t

    # Check one final time before closing
    - if !<player.has_flag[dis.crate.animation_running]>:
        - stop

    # Clear animation flag BEFORE closing to prevent early close handler from triggering
    - flag player dis.crate.animation_running:!

    # Close GUI
    - inventory close
    - wait 5t

    # Award loot
    - inject award_dis_loot

    # Clear pending result flag after normal completion
    - flag player dis.crate.pending_result:!

dis_crate_gui:
    type: inventory
    inventory: chest
    gui: true
    title: <&8>Dis Passage - Opening...
    size: 27

# ============================================
# OUTCOME ROLLING
# ============================================

roll_dis_outcome:
    type: procedure
    debug: false
    script:
    # Check if all items obtained
    - define all_obtained true
    - if !<player.has_flag[dis.item.title]>:
        - define all_obtained false
    - if !<player.has_flag[dis.item.shulker]>:
        - define all_obtained false
    - if !<player.has_flag[dis.item.charm]>:
        - define all_obtained false
    - if !<player.has_flag[dis.item.head]>:
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
    - if !<player.has_flag[dis.item.title]>:
        - define available <[available].include[title]>
    - if !<player.has_flag[dis.item.shulker]>:
        - define available <[available].include[shulker]>
    - if !<player.has_flag[dis.item.charm]>:
        - define available <[available].include[charm]>
    - if !<player.has_flag[dis.item.head]>:
        - define available <[available].include[head]>

    # Select random from available
    - define chosen <[available].random>

    # Build result map
    - choose <[chosen]>:
        - case title:
            - define result_map <map[type=UNIQUE;item_id=title;item=<item[book].with[display=<&d><&l>DIS TITLE<&r>;lore=<&7>Cosmetic unlock:|<&5>[Dis' Chosen]<&7> title]>;display=Dis Title]>
        - case shulker:
            - define result_map <map[type=UNIQUE;item_id=shulker;item=<item[purple_shulker_box]>;display=Purple Shulker Box]>
        - case charm:
            - define result_map <map[type=UNIQUE;item_id=charm;item=<item[dis_fire_charm_blueprint]>;display=Dis Fire Charm Blueprint]>
        - case head:
            - define result_map <map[type=UNIQUE;item_id=head;item=<item[charon_head]>;display=Head of Charon]>

    - determine <[result_map]>

# ============================================
# LOOT AWARDING
# ============================================

award_dis_loot:
    type: task
    debug: false
    script:
    # This task is injected, so <[result]> is available from parent context
    - choose <[result].get[type]>:
        # God Apple
        - case GOD_APPLE:
            - give enchanted_golden_apple
            - playsound <player> sound:entity_player_levelup
            - flag player dis.god_apples:++
            # Title feedback
            - title "title:<&5><&l>DIS DROP" subtitle:<&f><[result].get[display]> fade_in:5t stay:40t fade_out:10t targets:<player>

        # Unique Item
        - case UNIQUE:
            - define item_id <[result].get[item_id]>

            # Award item
            - choose <[item_id]>:
                - case title:
                    - flag player dis.item.title:true
                    # No physical item for title (just flag)
                - case shulker:
                    - give purple_shulker_box
                    - flag player dis.item.shulker:true
                - case charm:
                    - give dis_fire_charm_blueprint
                    - flag player dis.item.charm:true
                - case head:
                    - give charon_head
                    - flag player dis.item.head:true

            # Sound feedback
            - playsound <player> sound:ui_toast_challenge_complete volume:1.0
            - playsound <player> sound:block_beacon_activate volume:0.5

            # Title feedback
            - title "title:<&5><&l>OLYMPIAN DROP" subtitle:<&d><[result].get[display]> fade_in:5t stay:40t fade_out:10t targets:<player>

            # Server announcement
            - announce "<&5><&l>OLYMPIAN DROP!<&r> <&f><player.name> <&7>obtained a unique Dis item<&co> <&d><[result].get[display]><&7>!"

            # Track stats
            - flag player dis.unique_items:++

            # Check if all unique items collected
            - if <player.has_flag[dis.item.title]> && <player.has_flag[dis.item.shulker]> && <player.has_flag[dis.item.charm]> && <player.has_flag[dis.item.head]>:
                - announce "<&5><&l>COLLECTION COMPLETE!<&r> <&f><player.name> <&7>has collected every unique <&5>Dis<&7> item!"
                - playsound <player> sound:entity_ender_dragon_growl volume:0.5

# ============================================
# EARLY CLOSE HANDLER
# ============================================

dis_crate_early_close:
    type: world
    debug: false
    events:
        on player closes dis_crate_gui:
        # Check if animation is still running
        - if !<player.has_flag[dis.crate.animation_running]>:
            - stop

        # Clear the animation running flag to signal the queue to stop naturally
        - flag player dis.crate.animation_running:!

        # Wait a tick to ensure the queue sees the flag change
        - wait 1t

        - define result <player.flag[dis.crate.pending_result]>

        # Award loot using same logic as normal completion
        - inject award_dis_loot

        # Clear pending result flag
        - flag player dis.crate.pending_result:!
