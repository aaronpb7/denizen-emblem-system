# ============================================
# MARS CRATE - Meta-Progression
# ============================================
#
# Mars crate opening system:
# - 50% chance: Enchanted Golden Apple
# - 50% chance: Unique item from finite pool (4 items total)
# - Once all 4 items obtained → always god apple
#

# ============================================
# MARS KEY
# ============================================

mars_key:
    type: item
    material: nether_star
    display name: <&b>Mars Key<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>A key forged in the Roman forge,
    - <&7>where Mars guards his most
    - <&7>deadly and finite treasures.
    - <empty>
    - <&e>Right-click to unlock
    - <&e>a Mars Crate.
    - <empty>
    - <&8>50% God Apple / 50% Unique Item
    - <empty>
    - <&b><&l><&k>|||<&r> <&b><&l>OLYMPIAN KEY<&r> <&b><&l><&k>|||

# ============================================
# KEY USAGE EVENT
# ============================================

mars_key_usage:
    type: world
    debug: false
    events:
        on player right clicks block with:mars_key:
        - determine cancelled passively

        # Roll outcome BEFORE taking key (safer)
        - define result <proc[roll_mars_outcome]>

        # Take 1 key after successful roll
        - take item:mars_key quantity:1

        # Start crate animation with pre-rolled result
        # Use player-specific queue ID so it can be stopped if they close early
        - run mars_crate_animation def.result:<[result]> id:mars_crate_<player.uuid>

        # Track statistics
        - flag player mars.crates_opened:++

mars_crate_animation:
    type: task
    debug: false
    definitions: result
    script:
    # Store result as flag for early close detection
    - flag player mars.crate.pending_result:<[result]>
    - flag player mars.crate.animation_running:true

    # Narrate opening message
    - narrate "<&7>You unlock the <&4>Mars Arena<&7>..."
    - playsound <player> sound:block_ender_chest_open volume:1.0

    # Open GUI with dark red border frame
    - define filler <item[gray_stained_glass_pane].with[display=<&7>]>
    - define border <item[red_stained_glass_pane].with[display=<&4>]>
    - define gui_items <list>
    - repeat 27:
        - define gui_items <[gui_items].include[<[filler]>]>

    - inventory open d:mars_crate_gui
    - define crate_inv <player.open_inventory>
    - inventory set d:<[crate_inv]> o:<[gui_items]>

    # Set dark red border frame around entire GUI
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
    # Middle row center slots: 12, 13, 14, 15, 16 (5 slots centered, scrolls right to left)
    # Alternates between god apple and mystery item

    # Define preview pool as actual ItemTags
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
        # Check if player closed inventory early
        - if !<player.has_flag[mars.crate.animation_running]>:
            - stop

        # Shift items left and add new item on right
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
        # Check if player closed inventory early
        - if !<player.has_flag[mars.crate.animation_running]>:
            - stop

        # Shift items left and add new item on right
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
        # Check if player closed inventory early
        - if !<player.has_flag[mars.crate.animation_running]>:
            - stop

        # Shift items left and add new item on right
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
    - if !<player.has_flag[mars.crate.animation_running]>:
        - stop

    # Clear animation flag BEFORE closing to prevent early close handler from triggering
    - flag player mars.crate.animation_running:!

    # Close GUI
    - inventory close
    - wait 5t

    # Award loot
    - inject award_mars_loot

    # Clear pending result flag after normal completion
    - flag player mars.crate.pending_result:!

mars_crate_gui:
    type: inventory
    inventory: chest
    gui: true
    title: <&8>Mars Arena - Opening...
    size: 27

# ============================================
# OUTCOME ROLLING
# ============================================

roll_mars_outcome:
    type: procedure
    debug: false
    script:
    # Check if all items obtained
    - define all_obtained true
    - if !<player.has_flag[mars.item.sword]>:
        - define all_obtained false
    - if !<player.has_flag[mars.item.title]>:
        - define all_obtained false
    - if !<player.has_flag[mars.item.shulker]>:
        - define all_obtained false
    - if !<player.has_flag[mars.item.shield]>:
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
    - if !<player.has_flag[mars.item.sword]>:
        - define available <[available].include[sword]>
    - if !<player.has_flag[mars.item.title]>:
        - define available <[available].include[title]>
    - if !<player.has_flag[mars.item.shulker]>:
        - define available <[available].include[shulker]>
    - if !<player.has_flag[mars.item.shield]>:
        - define available <[available].include[shield]>

    # Select random from available
    - define chosen <[available].random>

    # Build result map
    - choose <[chosen]>:
        - case sword:
            - define result_map <map[type=UNIQUE;item_id=sword;item=<item[mars_sword]>;display=Mars Sword]>
        - case title:
            - define result_map <map[type=UNIQUE;item_id=title;item=<item[book].with[display=<&4><&l>MARS TITLE<&r>;lore=<&7>Cosmetic unlock:|<&4>[Mars' Chosen]<&7> title]>;display=Mars Title]>
        - case shulker:
            - define result_map <map[type=UNIQUE;item_id=shulker;item=<item[red_shulker_box]>;display=Red Shulker Box]>
        - case shield:
            - define result_map <map[type=UNIQUE;item_id=shield;item=<item[mars_shield]>;display=Mars Shield]>

    - determine <[result_map]>

# ============================================
# LOOT AWARDING
# ============================================

award_mars_loot:
    type: task
    debug: false
    script:
    # This task is injected, so <[result]> is available from parent context
    - choose <[result].get[type]>:
        # God Apple
        - case GOD_APPLE:
            - give enchanted_golden_apple
            - playsound <player> sound:entity_player_levelup
            - flag player mars.god_apples:++
            # Title feedback
            - title "title:<&4><&l>MARS DROP" subtitle:<&f><[result].get[display]> fade_in:5t stay:40t fade_out:10t targets:<player>

        # Unique Item
        - case UNIQUE:
            - define item_id <[result].get[item_id]>

            # Award item
            - choose <[item_id]>:
                - case sword:
                    - give mars_sword
                    - flag player mars.item.sword:true
                - case title:
                    - flag player mars.item.title:true
                    # No physical item for title (just flag)
                - case shulker:
                    - give red_shulker_box
                    - flag player mars.item.shulker:true
                - case shield:
                    - give mars_shield
                    - flag player mars.item.shield:true

            # Sound feedback
            - playsound <player> sound:ui_toast_challenge_complete volume:1.0
            - playsound <player> sound:entity_wither_spawn volume:0.3 pitch:2.0

            # Title feedback
            - title "title:<&4><&l>OLYMPIAN DROP" subtitle:<&d><[result].get[display]> fade_in:5t stay:40t fade_out:10t targets:<player>

            # Server announcement
            - announce "<&4><&l>OLYMPIAN DROP!<&r> <&f><player.name> <&7>obtained a unique Mars item<&co> <&d><[result].get[display]><&7>!"

            # Track stats
            - flag player mars.unique_items:++

# ============================================
# EARLY CLOSE HANDLER
# ============================================

mars_crate_early_close:
    type: world
    debug: false
    events:
        on player closes mars_crate_gui:
        # Check if animation is still running
        - if !<player.has_flag[mars.crate.animation_running]>:
            - stop

        # Clear the animation running flag to signal the queue to stop naturally
        # Don't try to force-stop the queue - it may have already finished
        - flag player mars.crate.animation_running:!

        # Wait a tick to ensure the queue sees the flag change
        - wait 1t

        - define result <player.flag[mars.crate.pending_result]>

        # Award loot using same logic as normal completion
        - inject award_mars_loot

        # Clear pending result flag
        - flag player mars.crate.pending_result:!
