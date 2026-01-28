# ============================================
# DEMETER CRATE - Opening System
# ============================================
#
# Demeter crate opening system:
# - Right-click key → GUI animation → Loot award
# - 5 tiers: MORTAL (56%), HEROIC (26%), LEGENDARY (12%), MYTHIC (5%), OLYMPIAN (1%)
#

# ============================================
# KEY USAGE EVENT
# ============================================

demeter_key_usage:
    type: world
    debug: false
    events:
        on player right clicks block with:demeter_key:
        - determine cancelled passively

        # Temporary OP-only restriction
        - if !<player.is_op>:
            - narrate "<&e>Crate system coming soon!"
            - stop

        # Roll tier and loot BEFORE taking key (safer)
        - define tier_result <proc[roll_demeter_tier]>
        - define tier <[tier_result].get[1]>
        - define tier_color <[tier_result].get[2]>
        - define loot <proc[roll_demeter_loot].context[<[tier]>]>

        # Take 1 key after successful roll
        - take item:demeter_key quantity:1

        # Start crate animation with pre-rolled results
        # Use player-specific queue ID so it can be stopped if they close early
        - run demeter_crate_animation def.tier:<[tier]> def.tier_color:<[tier_color]> def.loot:<[loot]> id:demeter_crate_<player.uuid>

        # Track statistics
        - flag player demeter.crates_opened:++
        - flag player demeter.tier.<[tier].to_lowercase>:++

demeter_crate_animation:
    type: task
    debug: false
    definitions: tier|tier_color|loot
    script:
    # Store loot data as flag for early close detection
    - flag player demeter.crate.pending_loot:<[loot]>
    - flag player demeter.crate.pending_tier:<[tier]>
    - flag player demeter.crate.pending_tier_color:<[tier_color]>
    - flag player demeter.crate.animation_running:true

    # Narrate opening message
    - narrate "<&7>You insert the <&6>Demeter Key<&7>..."
    - playsound <player> sound:block_chest_open volume:1.0

    # Open GUI with yellow border around rolling area
    - define filler <item[gray_stained_glass_pane].with[display_name=<&7>]>
    - define border <item[yellow_stained_glass_pane].with[display_name=<&e>]>
    - define gui_items <list>
    - repeat 27:
        - define gui_items <[gui_items].include[<[filler]>]>

    - inventory open d:demeter_crate_gui
    - inventory set d:<player.open_inventory> o:<[gui_items]>

    # Set yellow border frame around entire GUI
    # Top row (1-9)
    - inventory set d:<player.open_inventory> o:<[border]> slot:1
    - inventory set d:<player.open_inventory> o:<[border]> slot:2
    - inventory set d:<player.open_inventory> o:<[border]> slot:3
    - inventory set d:<player.open_inventory> o:<[border]> slot:4
    - inventory set d:<player.open_inventory> o:<[border]> slot:5
    - inventory set d:<player.open_inventory> o:<[border]> slot:6
    - inventory set d:<player.open_inventory> o:<[border]> slot:7
    - inventory set d:<player.open_inventory> o:<[border]> slot:8
    - inventory set d:<player.open_inventory> o:<[border]> slot:9
    # Middle row sides (10, 18)
    - inventory set d:<player.open_inventory> o:<[border]> slot:10
    - inventory set d:<player.open_inventory> o:<[border]> slot:11
    - inventory set d:<player.open_inventory> o:<[border]> slot:17
    - inventory set d:<player.open_inventory> o:<[border]> slot:18
    # Bottom row (19-27)
    - inventory set d:<player.open_inventory> o:<[border]> slot:19
    - inventory set d:<player.open_inventory> o:<[border]> slot:20
    - inventory set d:<player.open_inventory> o:<[border]> slot:21
    - inventory set d:<player.open_inventory> o:<[border]> slot:22
    - inventory set d:<player.open_inventory> o:<[border]> slot:23
    - inventory set d:<player.open_inventory> o:<[border]> slot:24
    - inventory set d:<player.open_inventory> o:<[border]> slot:25
    - inventory set d:<player.open_inventory> o:<[border]> slot:26
    - inventory set d:<player.open_inventory> o:<[border]> slot:27

    # SCROLLING REEL ANIMATION
    # Middle row center slots: 12, 13, 14, 15, 16 (5 slots centered, scrolls left to right)
    # Final result lands in center (slot 14)

    - define preview_pool <list[bread|cooked_beef|baked_potato|wheat|emerald|golden_carrot|golden_apple|enchanted_golden_apple|hay_bale|bone_meal]>

    # Initialize scrolling slots with random items
    - define slot1 <item[<[preview_pool].random>]>
    - define slot2 <item[<[preview_pool].random>]>
    - define slot3 <item[<[preview_pool].random>]>
    - define slot4 <item[<[preview_pool].random>]>
    - define slot5 <item[<[preview_pool].random>]>

    # Phase 1: Fast scroll (20 cycles, 2t each = 2s)
    - repeat 20:
        # Check if player closed inventory early
        - if !<player.has_flag[demeter.crate.animation_running]>:
            - stop

        # Shift items left and add new item on right
        - define slot1 <[slot2]>
        - define slot2 <[slot3]>
        - define slot3 <[slot4]>
        - define slot4 <[slot5]>
        - define slot5 <item[<[preview_pool].random>]>

        - inventory set d:<player.open_inventory> slot:12 o:<[slot1]>
        - inventory set d:<player.open_inventory> slot:13 o:<[slot2]>
        - inventory set d:<player.open_inventory> slot:14 o:<[slot3]>
        - inventory set d:<player.open_inventory> slot:15 o:<[slot4]>
        - inventory set d:<player.open_inventory> slot:16 o:<[slot5]>
        - playsound <player> sound:ui_button_click volume:0.2 pitch:1.5
        - wait 2t

    # Phase 2: Medium scroll (10 cycles, 3t each = 1.5s)
    - repeat 10:
        # Check if player closed inventory early
        - if !<player.has_flag[demeter.crate.animation_running]>:
            - stop

        # Shift items left and add new item on right
        - define slot1 <[slot2]>
        - define slot2 <[slot3]>
        - define slot3 <[slot4]>
        - define slot4 <[slot5]>
        - define slot5 <item[<[preview_pool].random>]>

        - inventory set d:<player.open_inventory> slot:12 o:<[slot1]>
        - inventory set d:<player.open_inventory> slot:13 o:<[slot2]>
        - inventory set d:<player.open_inventory> slot:14 o:<[slot3]>
        - inventory set d:<player.open_inventory> slot:15 o:<[slot4]>
        - inventory set d:<player.open_inventory> slot:16 o:<[slot5]>
        - playsound <player> sound:ui_button_click volume:0.3 pitch:1.2
        - wait 3t

    # Phase 3: Slow scroll (5 cycles, 5t each = 1.25s)
    - repeat 5:
        # Check if player closed inventory early
        - if !<player.has_flag[demeter.crate.animation_running]>:
            - stop

        # Shift items left and add new item on right
        - define slot1 <[slot2]>
        - define slot2 <[slot3]>
        - define slot3 <[slot4]>
        - define slot4 <[slot5]>
        - define slot5 <item[<[preview_pool].random>]>

        - inventory set d:<player.open_inventory> slot:12 o:<[slot1]>
        - inventory set d:<player.open_inventory> slot:13 o:<[slot2]>
        - inventory set d:<player.open_inventory> slot:14 o:<[slot3]>
        - inventory set d:<player.open_inventory> slot:15 o:<[slot4]>
        - inventory set d:<player.open_inventory> slot:16 o:<[slot5]>
        - playsound <player> sound:ui_button_click volume:0.4 pitch:0.9
        - wait 5t

    # Build final display item with correct quantity embedded
    - define final_display_item <proc[build_loot_display_item].context[<[loot]>]>

    # Final landing animation - winning item scrolls into center
    # Continue the scrolling pattern until final item reaches center (slot 14)
    # It takes 3 steps to go from slot 16 to slot 14

    # Step 1: Final item enters at slot 16 (far right)
    - define slot1 <[slot2]>
    - define slot2 <[slot3]>
    - define slot3 <[slot4]>
    - define slot4 <[slot5]>
    - define slot5 <[final_display_item]>

    - inventory set d:<player.open_inventory> slot:12 o:<[slot1]>
    - inventory set d:<player.open_inventory> slot:13 o:<[slot2]>
    - inventory set d:<player.open_inventory> slot:14 o:<[slot3]>
    - inventory set d:<player.open_inventory> slot:15 o:<[slot4]>
    - inventory set d:<player.open_inventory> slot:16 o:<[slot5]>
    - playsound <player> sound:ui_button_click volume:0.4 pitch:0.9
    - wait 5t

    # Step 2: Final item moves to slot 15
    - define slot1 <[slot2]>
    - define slot2 <[slot3]>
    - define slot3 <[slot4]>
    - define slot4 <[slot5]>
    - define slot5 <item[<[preview_pool].random>]>

    - inventory set d:<player.open_inventory> slot:12 o:<[slot1]>
    - inventory set d:<player.open_inventory> slot:13 o:<[slot2]>
    - inventory set d:<player.open_inventory> slot:14 o:<[slot3]>
    - inventory set d:<player.open_inventory> slot:15 o:<[slot4]>
    - inventory set d:<player.open_inventory> slot:16 o:<[slot5]>
    - playsound <player> sound:ui_button_click volume:0.4 pitch:0.9
    - wait 5t

    # Step 3: Final item lands at slot 14 (center)
    - define slot1 <[slot2]>
    - define slot2 <[slot3]>
    - define slot3 <[slot4]>
    - define slot4 <[slot5]>
    - define slot5 <item[<[preview_pool].random>]>

    - inventory set d:<player.open_inventory> slot:12 o:<[slot1]>
    - inventory set d:<player.open_inventory> slot:13 o:<[slot2]>
    - inventory set d:<player.open_inventory> slot:14 o:<[slot3]>
    - inventory set d:<player.open_inventory> slot:15 o:<[slot4]>
    - inventory set d:<player.open_inventory> slot:16 o:<[slot5]>
    - playsound <player> sound:ui_button_click volume:0.5 pitch:1.0
    - wait 5t

    # Clear surrounding slots, leave final item in center
    - inventory set d:<player.open_inventory> o:<[filler]> slot:12
    - inventory set d:<player.open_inventory> o:<[filler]> slot:13
    - inventory set d:<player.open_inventory> o:<[filler]> slot:15
    - inventory set d:<player.open_inventory> o:<[filler]> slot:16
    - wait 16t

    # Check one final time before closing
    - if !<player.has_flag[demeter.crate.animation_running]>:
        - stop

    # Clear animation flag BEFORE closing to prevent early close handler from triggering
    - flag player demeter.crate.animation_running:!

    # Close GUI
    - inventory close
    - wait 5t

    # Award loot directly (give command handles safety)
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
    - flag player demeter.crate.pending_loot:!
    - flag player demeter.crate.pending_tier:!
    - flag player demeter.crate.pending_tier_color:!

demeter_crate_gui:
    type: inventory
    inventory: chest
    gui: true
    title: <&8>Demeter Crate - Rolling...
    size: 27

# ============================================
# TIER ROLLING
# ============================================

roll_demeter_tier:
    type: procedure
    script:
    - define roll <util.random.int[1].to[100]>

    # MORTAL: 1-56 (56%)
    - if <[roll]> <= 56:
        - determine <list[MORTAL|<&f>]>

    # HEROIC: 57-82 (26%)
    - else if <[roll]> <= 82:
        - determine <list[HEROIC|<&e>]>

    # LEGENDARY: 83-94 (12%)
    - else if <[roll]> <= 94:
        - determine <list[LEGENDARY|<&6>]>

    # MYTHIC: 95-99 (5%)
    - else if <[roll]> <= 99:
        - determine <list[MYTHIC|<&d>]>

    # OLYMPIAN: 100 (1%)
    - else:
        - determine <list[OLYMPIAN|<&b>]>

get_tier_indicator_pane:
    type: procedure
    definitions: tier
    script:
    - choose <[tier]>:
        - case MORTAL:
            - determine <item[white_stained_glass_pane].with[display_name=<&f>MORTAL]>
        - case HEROIC:
            - determine <item[yellow_stained_glass_pane].with[display_name=<&e>HEROIC]>
        - case LEGENDARY:
            - determine <item[orange_stained_glass_pane].with[display_name=<&6>LEGENDARY]>
        - case MYTHIC:
            - determine <item[magenta_stained_glass_pane].with[display_name=<&d>MYTHIC]>
        - case OLYMPIAN:
            - determine <item[nether_star].with[display_name=<&b>OLYMPIAN;enchantments=mending,1;item_flags=HIDE_ENCHANTS]>

# ============================================
# LOOT TABLES
# ============================================

roll_demeter_loot:
    type: procedure
    definitions: tier
    script:
    - choose <[tier]>:
        - case MORTAL:
            - define pool <list>
            - define pool <[pool].include[bread:8]>
            - define pool <[pool].include[cooked_beef:4]>
            - define pool <[pool].include[baked_potato:4]>
            - define pool <[pool].include[wheat:16]>
            - define pool <[pool].include[hay_bale:4]>
            - define pool <[pool].include[bone_meal:8]>
            - define pool <[pool].include[pumpkin_pie:4]>
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
            - define pool <[pool].include[gold_block:1]>
            - define pool <[pool].include[experience:100]>
            - define pool <[pool].include[lead:1]>
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
            - define pool <[pool].include[demeter_key:2]>
            - define pool <[pool].include[emerald_block:6]>
            - define pool <[pool].include[experience:250]>
            - define choice <[pool].random>
            - define parts <[choice].split[<&co>]>
            - define material <[parts].get[1]>
            - define qty <[parts].get[2]>
            - if <[material]> == experience:
                - define loot_map <map[type=EXPERIENCE;amount=<[qty]>;display=+<[qty]> Experience]>
            - else if <[material]> == demeter_key:
                - define loot_map <map[type=CUSTOM;script=demeter_key;quantity=<[qty]>;display=Demeter Key x<[qty]>]>
            - else:
                - define display_name <[material].to_titlecase.replace[_].with[ ]>
                - define loot_map <map[type=ITEM;material=<[material]>;quantity=<[qty]>;display=<[display_name]> x<[qty]>]>
            - determine <[loot_map]>

        - case MYTHIC:
            - define pool <list>
            - define pool <[pool].include[enchanted_golden_apple:1]>
            - define pool <[pool].include[demeter_hoe:1]>
            - define pool <[pool].include[demeter_blessing:1]>
            - define pool <[pool].include[demeter_title:1]>
            - define pool <[pool].include[gold_block:16]>
            - define pool <[pool].include[emerald_block:16]>
            - define choice <[pool].random>
            - define parts <[choice].split[<&co>]>
            - define material <[parts].get[1]>
            - define qty <[parts].get[2]>
            - if <[material]> == demeter_hoe || <[material]> == demeter_blessing:
                - define display_name <[material].to_titlecase.replace[_].with[ ]>
                - define loot_map <map[type=CUSTOM;script=<[material]>;quantity=<[qty]>;display=<[display_name]> x<[qty]>]>
            - else if <[material]> == demeter_title:
                - define loot_map <map[type=TITLE;flag=demeter.item.title;display=Demeter Title]>
            - else:
                - define display_name <[material].to_titlecase.replace[_].with[ ]>
                - define loot_map <map[type=ITEM;material=<[material]>;quantity=<[qty]>;display=<[display_name]> x<[qty]>]>
            - determine <[loot_map]>

        - case OLYMPIAN:
            - define loot_map <map[type=CUSTOM;script=ceres_key;quantity=1;display=Ceres Key x1]>
            - determine <[loot_map]>

# ============================================
# LOOT DISPLAY ITEM BUILDER
# ============================================

build_loot_display_item:
    type: procedure
    definitions: loot
    script:
    # Builds the final display item with quantity embedded
    # This fixes the quantity bug by constructing the complete ItemTag
    - choose <[loot].get[type]>:
        - case ITEM:
            - define material <[loot].get[material]>
            - define qty <[loot].get[quantity]>
            - determine <item[<[material]>].with[quantity=<[qty]>]>

        - case CUSTOM:
            - define script_name <[loot].get[script]>
            - define qty <[loot].get[quantity]>
            - determine <item[<[script_name]>].with[quantity=<[qty]>]>

        - case EXPERIENCE:
            # Experience displays as a bottle
            - determine <item[experience_bottle].with[display_name=<&a>+<[loot].get[amount]> Experience]>

        - case TITLE:
            # Title displays as a name tag
            - determine <item[name_tag].with[display_name=<&6><&l><[loot].get[display]>;enchantments=mending,1;hides=ALL]>

# ============================================
# DEPRECATED LOOT AWARDING
# ============================================

award_demeter_loot:
    type: task
    debug: false
    definitions: loot|tier|tier_color
    script:
    # DEPRECATED: MapTag does not survive def: passing
    # Loot awarding now handled inline in demeter_crate_animation
    # This task remains as a template for reference only
    # Award based on type
    - choose <[loot].get[type]>:
        - case ITEM:
            - define award_item <[loot].get[item]>
            - define award_qty <[loot].get[quantity]>
            - if <player.inventory.can_fit[<[award_item]>].quantity[<[award_qty]>]>:
                - give <[award_item]> quantity:<[award_qty]>
            - else:
                - drop <[award_item]> quantity:<[award_qty]> <player.location>
                - narrate "<&c>Inventory full! Item dropped at your feet."

        - case EXPERIENCE:
            - experience give <[loot].get[amount]>

        - case CUSTOM:
            - define award_qty <[loot].get[quantity]>
            - if <player.inventory.can_fit[<item[<[loot].get[script]>]>].quantity[<[award_qty]>]>:
                - give <item[<[loot].get[script]>]> quantity:<[award_qty]>
            - else:
                - drop <item[<[loot].get[script]>]> quantity:<[award_qty]> <player.location>
                - narrate "<&c>Inventory full! Item dropped at your feet."

    # Title feedback
    - title title:<[tier_color]><&l><[tier]> subtitle:<&f><[loot].get[display]> fade_in:5t stay:40t fade_out:10t targets:<player>

    # Sound
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

    # Track tier stats (optional)
    - flag player demeter.tier.<[tier].to_lowercase>:++

# ============================================
# EARLY CLOSE HANDLER
# ============================================

demeter_crate_early_close:
    type: world
    debug: false
    events:
        on player closes demeter_crate_gui:
        # Check if animation is still running
        - if !<player.has_flag[demeter.crate.animation_running]>:
            - stop

        # Stop the animation queue immediately
        - queue stop demeter_crate_<player.uuid>

        # Animation was interrupted - award pending loot
        - flag player demeter.crate.animation_running:!

        - define loot <player.flag[demeter.crate.pending_loot]>
        - define tier <player.flag[demeter.crate.pending_tier]>
        - define tier_color <player.flag[demeter.crate.pending_tier_color]>

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
        - flag player demeter.crate.pending_loot:!
        - flag player demeter.crate.pending_tier:!
        - flag player demeter.crate.pending_tier_color:!
