# ============================================
# CHARON CRATE - Opening System
# ============================================
#
# Charon crate opening system:
# - Right-click key -> GUI animation -> Loot award
# - 5 tiers: MORTAL (56%), HEROIC (26%), LEGENDARY (12%), MYTHIC (5%), OLYMPIAN (1%)
#

# ============================================
# KEY USAGE EVENT
# ============================================

charon_key_usage:
    type: world
    debug: false
    events:
        on player right clicks block with:charon_key:
        - determine cancelled passively

        # Roll tier and loot BEFORE taking key (safer)
        - define tier_result <proc[roll_charon_tier]>
        - define tier <[tier_result].get[1]>
        - define tier_color <[tier_result].get[2]>
        - define loot <proc[roll_charon_loot].context[<[tier]>]>

        # Take 1 key after successful roll
        - take item:charon_key quantity:1

        # Start crate animation with pre-rolled results
        - run charon_crate_animation def.tier:<[tier]> def.tier_color:<[tier_color]> def.loot:<[loot]> id:charon_crate_<player.uuid>

        # Track statistics
        - flag player charon.crates_opened:++
        - flag player charon.tier.<[tier].to_lowercase>:++

        # Pity counter tracking (only while wearing divine armor)
        - if <proc[is_wearing_divine_armor].context[<player>|charon]>:
            - if <[tier]> == OLYMPIAN:
                - flag player charon.pity_counter:0
            - else:
                - flag player charon.pity_counter:++

charon_crate_animation:
    type: task
    debug: false
    definitions: tier|tier_color|loot
    script:
    # Store loot data as flag for early close detection
    - flag player charon.crate.pending_loot:<[loot]>
    - flag player charon.crate.pending_tier:<[tier]>
    - flag player charon.crate.pending_tier_color:<[tier_color]>
    - flag player charon.crate.animation_running:true

    # Narrate opening message
    - narrate "<&7>You insert the <&5>Charon Key<&7>..."
    - playsound <player> sound:block_chest_open volume:1.0

    # Open GUI with purple border around rolling area
    - define filler <item[gray_stained_glass_pane].with[display=<&7>]>
    - define border <item[purple_stained_glass_pane].with[display=<&5>]>
    - define gui_items <list>
    - repeat 27:
        - define gui_items <[gui_items].include[<[filler]>]>

    - inventory open d:charon_crate_gui
    - define crate_inv <player.open_inventory>
    - inventory set d:<[crate_inv]> o:<[gui_items]>

    # Set purple border frame around entire GUI
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
    # Middle row center slots: 12, 13, 14, 15, 16 (5 slots centered, scrolls left to right)
    # Final result lands in center (slot 14)

    # Define preview pool as actual ItemTags
    - define preview_pool <list>
    - define preview_pool <[preview_pool].include[<item[blaze_rod]>]>
    - define preview_pool <[preview_pool].include[<item[magma_cream]>]>
    - define preview_pool <[preview_pool].include[<item[nether_wart]>]>
    - define preview_pool <[preview_pool].include[<item[soul_sand]>]>
    - define preview_pool <[preview_pool].include[<item[blackstone]>]>
    - define preview_pool <[preview_pool].include[<item[gold_ingot]>]>
    - define preview_pool <[preview_pool].include[<item[netherrack]>]>
    - define preview_pool <[preview_pool].include[<item[quartz]>]>
    - define preview_pool <[preview_pool].include[<item[nether_brick]>]>

    # Initialize scrolling slots with random items
    - define slot1 <[preview_pool].random>
    - define slot2 <[preview_pool].random>
    - define slot3 <[preview_pool].random>
    - define slot4 <[preview_pool].random>
    - define slot5 <[preview_pool].random>

    # Phase 1: Fast scroll (20 cycles, 2t each = 2s)
    - repeat 20:
        - if !<player.has_flag[charon.crate.animation_running]>:
            - stop

        - define slot1 <[slot2]>
        - define slot2 <[slot3]>
        - define slot3 <[slot4]>
        - define slot4 <[slot5]>
        - define slot5 <[preview_pool].random>

        - inventory set d:<[crate_inv]> slot:12 o:<[slot1]>
        - inventory set d:<[crate_inv]> slot:13 o:<[slot2]>
        - inventory set d:<[crate_inv]> slot:14 o:<[slot3]>
        - inventory set d:<[crate_inv]> slot:15 o:<[slot4]>
        - inventory set d:<[crate_inv]> slot:16 o:<[slot5]>
        - playsound <player> sound:ui_button_click volume:0.2 pitch:1.5
        - wait 2t

    # Phase 2: Medium scroll (10 cycles, 3t each = 1.5s)
    - repeat 10:
        - if !<player.has_flag[charon.crate.animation_running]>:
            - stop

        - define slot1 <[slot2]>
        - define slot2 <[slot3]>
        - define slot3 <[slot4]>
        - define slot4 <[slot5]>
        - define slot5 <[preview_pool].random>

        - inventory set d:<[crate_inv]> slot:12 o:<[slot1]>
        - inventory set d:<[crate_inv]> slot:13 o:<[slot2]>
        - inventory set d:<[crate_inv]> slot:14 o:<[slot3]>
        - inventory set d:<[crate_inv]> slot:15 o:<[slot4]>
        - inventory set d:<[crate_inv]> slot:16 o:<[slot5]>
        - playsound <player> sound:ui_button_click volume:0.3 pitch:1.2
        - wait 3t

    # Phase 3: Slow scroll (5 cycles, 5t each = 1.25s)
    - repeat 5:
        - if !<player.has_flag[charon.crate.animation_running]>:
            - stop

        - define slot1 <[slot2]>
        - define slot2 <[slot3]>
        - define slot3 <[slot4]>
        - define slot4 <[slot5]>
        - define slot5 <[preview_pool].random>

        - inventory set d:<[crate_inv]> slot:12 o:<[slot1]>
        - inventory set d:<[crate_inv]> slot:13 o:<[slot2]>
        - inventory set d:<[crate_inv]> slot:14 o:<[slot3]>
        - inventory set d:<[crate_inv]> slot:15 o:<[slot4]>
        - inventory set d:<[crate_inv]> slot:16 o:<[slot5]>
        - playsound <player> sound:ui_button_click volume:0.4 pitch:0.9
        - wait 5t

    # Build final display item with correct quantity embedded
    - define final_display_item <proc[build_loot_display_item].context[<[loot]>]>

    # Final landing animation - winning item scrolls into center
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
    - define slot5 <[preview_pool].random>

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
    - define slot5 <[preview_pool].random>

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
    - if !<player.has_flag[charon.crate.animation_running]>:
        - stop

    # Clear animation flag BEFORE closing to prevent early close handler from triggering
    - flag player charon.crate.animation_running:!

    # Close GUI
    - inventory close
    - wait 5t

    # Award loot directly
    - choose <[loot].get[type]>:
        - case ITEM:
            - define material <[loot].get[material]>
            - define qty <[loot].get[quantity]>
            - give <item[<[material]>].with[quantity=<[qty]>]>

        - case EXPERIENCE:
            - experience give <[loot].get[amount]>

        - case CUSTOM:
            - define script_name <[loot].get[script]>
            - define qty <[loot].get[quantity]>
            - give <item[<[script_name]>].with[quantity=<[qty]>]>

        - case TITLE:
            - flag player <[loot].get[flag]>:true

    # Sound feedback
    - choose <[tier]>:
        - case MORTAL:
            - playsound <player> sound:entity_item_pickup
        - case HEROIC:
            - playsound <player> sound:entity_player_levelup
        - case LEGENDARY:
            - playsound <player> sound:block_enchantment_table_use
        - case MYTHIC:
            - playsound <player> sound:ui_toast_challenge_complete
        - case OLYMPIAN:
            - playsound <player> sound:ui_toast_challenge_complete volume:1.0
            - playsound <player> sound:entity_ender_dragon_growl volume:0.5

    # Title feedback
    - title "title:<[tier_color]><&l><[tier]> DROP" subtitle:<&f><[loot].get[display]> fade_in:5t stay:40t fade_out:10t targets:<player>

    # Clear pending loot flags after normal completion
    - flag player charon.crate.pending_loot:!
    - flag player charon.crate.pending_tier:!
    - flag player charon.crate.pending_tier_color:!

charon_crate_gui:
    type: inventory
    inventory: chest
    gui: true
    title: <&8>Charon Crate - Rolling...
    size: 27

# ============================================
# TIER ROLLING
# ============================================

roll_charon_tier:
    type: procedure
    debug: false
    script:
    # Pity timer: guaranteed OLYMPIAN every 50 crates while wearing divine armor
    - if <proc[is_wearing_divine_armor].context[<player>|charon]>:
        - if <player.flag[charon.pity_counter].if_null[0]> >= 49:
            - determine <list[OLYMPIAN|<&b>]>

    - define roll <util.random.int[1].to[100]>

    # Standard rates: 56/26/12/5/1
    - define caps <list[56|82|94|99]>

    - if <[roll]> <= <[caps].get[1]>:
        - determine <list[MORTAL|<&f>]>
    - else if <[roll]> <= <[caps].get[2]>:
        - determine <list[HEROIC|<&e>]>
    - else if <[roll]> <= <[caps].get[3]>:
        - determine <list[LEGENDARY|<&6>]>
    - else if <[roll]> <= <[caps].get[4]>:
        - determine <list[MYTHIC|<&d>]>
    - else:
        - determine <list[OLYMPIAN|<&b>]>

# ============================================
# LOOT TABLES
# ============================================

roll_charon_loot:
    type: procedure
    debug: false
    definitions: tier
    script:
    - choose <[tier]>:
        - case MORTAL:
            - define pool <list>
            - define pool <[pool].include[blaze_rod:1]>
            - define pool <[pool].include[magma_cream:4]>
            - define pool <[pool].include[nether_wart:2]>
            - define pool <[pool].include[blackstone:8]>
            - define pool <[pool].include[soul_sand:4]>
            - define pool <[pool].include[emerald:8]>
            - define pool <[pool].include[gold_ingot:2]>
            - define choice <[pool].random>
            - define parts <[choice].split[<&co>]>
            - define material <[parts].get[1]>
            - define qty <[parts].get[2]>
            - define display_name <[material].to_titlecase.replace[_].with[ ]>
            - define loot_map <map[type=ITEM;material=<[material]>;quantity=<[qty]>;display=<[display_name]> x<[qty]>]>
            - determine <[loot_map]>

        - case HEROIC:
            - define pool <list>
            - define pool <[pool].include[golden_carrot:8]>
            - define pool <[pool].include[emerald:16]>
            - define pool <[pool].include[quartz_block:8]>
            - define pool <[pool].include[experience:100]>
            - define pool <[pool].include[glowstone:8]>
            - define choice <[pool].random>
            - define parts <[choice].split[<&co>]>
            - define material <[parts].get[1]>
            - define qty <[parts].get[2]>
            - if <[material]> == experience:
                - define loot_map <map[type=EXPERIENCE;amount=<[qty]>;display=+<[qty]> Experience]>
            - else:
                - define display_name <[material].to_titlecase.replace[_].with[ ]>
                - define loot_map <map[type=ITEM;material=<[material]>;quantity=<[qty]>;display=<[display_name]> x<[qty]>]>
            - determine <[loot_map]>

        - case LEGENDARY:
            - define pool <list>
            - define pool <[pool].include[golden_apple:2]>
            - define pool <[pool].include[charon_key:2]>
            - define pool <[pool].include[nether_gold_ore:16]>
            - define pool <[pool].include[experience:250]>
            - define choice <[pool].random>
            - define parts <[choice].split[<&co>]>
            - define material <[parts].get[1]>
            - define qty <[parts].get[2]>
            - if <[material]> == experience:
                - define loot_map <map[type=EXPERIENCE;amount=<[qty]>;display=+<[qty]> Experience]>
            - else if <[material]> == charon_key:
                - define loot_map <map[type=CUSTOM;script=charon_key;quantity=<[qty]>;display=Charon Key x<[qty]>]>
            - else:
                - define display_name <[material].to_titlecase.replace[_].with[ ]>
                - define loot_map <map[type=ITEM;material=<[material]>;quantity=<[qty]>;display=<[display_name]> x<[qty]>]>
            - determine <[loot_map]>

        - case MYTHIC:
            - define pool <list>
            - define pool <[pool].include[charon_blessing:1]>
            - define pool <[pool].include[charon_mythic_fragment:1]>
            - define pool <[pool].include[wither_skeleton_skull:3]>
            - define pool <[pool].include[gold_block:16]>
            - define choice <[pool].random>
            - define parts <[choice].split[<&co>]>
            - define material <[parts].get[1]>
            - define qty <[parts].get[2]>
            - if <[material]> == charon_blessing:
                - define loot_map <map[type=CUSTOM;script=charon_blessing;quantity=<[qty]>;display=Charon Blessing x<[qty]>]>
            - else if <[material]> == charon_mythic_fragment:
                - define loot_map <map[type=CUSTOM;script=charon_mythic_fragment;quantity=<[qty]>;display=Charon Mythic Fragment x<[qty]>]>
            - else:
                - define display_name <[material].to_titlecase.replace[_].with[ ]>
                - define loot_map <map[type=ITEM;material=<[material]>;quantity=<[qty]>;display=<[display_name]> x<[qty]>]>
            - determine <[loot_map]>

        - case OLYMPIAN:
            - define loot_map <map[type=CUSTOM;script=dis_key;quantity=1;display=Dis Key x1]>
            - determine <[loot_map]>

# ============================================
# EARLY CLOSE HANDLER
# ============================================

charon_crate_early_close:
    type: world
    debug: false
    events:
        on player closes charon_crate_gui:
        # Check if animation is still running
        - if !<player.has_flag[charon.crate.animation_running]>:
            - stop

        # Clear the animation running flag to signal the queue to stop naturally
        - flag player charon.crate.animation_running:!

        # Wait a tick to ensure the queue sees the flag change
        - wait 1t

        - define loot <player.flag[charon.crate.pending_loot]>
        - define tier <player.flag[charon.crate.pending_tier]>
        - define tier_color <player.flag[charon.crate.pending_tier_color]>

        # Award loot
        - choose <[loot].get[type]>:
            - case ITEM:
                - define material <[loot].get[material]>
                - define qty <[loot].get[quantity]>
                - give <item[<[material]>].with[quantity=<[qty]>]>

            - case EXPERIENCE:
                - experience give <[loot].get[amount]>

            - case CUSTOM:
                - define script_name <[loot].get[script]>
                - define qty <[loot].get[quantity]>
                - give <item[<[script_name]>].with[quantity=<[qty]>]>

            - case TITLE:
                - flag player <[loot].get[flag]>:true

        # Sound and title feedback (shorter since they closed early)
        - playsound <player> sound:entity_item_pickup
        - title "title:<[tier_color]><&l><[tier]> DROP" subtitle:<&f><[loot].get[display]> fade_in:2t stay:20t fade_out:5t targets:<player>

        # Clear pending flags
        - flag player charon.crate.pending_loot:!
        - flag player charon.crate.pending_tier:!
        - flag player charon.crate.pending_tier_color:!
