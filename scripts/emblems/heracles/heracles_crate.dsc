# ============================================
# HERACLES CRATE - Opening System
# ============================================
#
# Heracles crate opening system:
# - Right-click key → GUI animation → Loot award
# - 5 tiers: MORTAL (56%), HEROIC (26%), LEGENDARY (12%), MYTHIC (5%), OLYMPIAN (1%)
# - Combat theme: Dark red/crimson border
#

# ============================================
# KEY ITEM
# ============================================

heracles_key:
    type: item
    material: tripwire_hook
    display name: <&e>Heracles Key<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>A crimson key blessed by
    - <&7>the greatest of Greek heroes.
    - <empty>
    - <&e>Right-click to open a
    - <&e>Heracles Crate.
    - <empty>
    - <&e><&l>HEROIC KEY

# ============================================
# KEY USAGE EVENT
# ============================================

heracles_key_usage:
    type: world
    debug: false
    events:
        on player right clicks block with:heracles_key:
        - determine cancelled passively

        # Roll tier and loot BEFORE taking key (safer)
        - define tier_result <proc[roll_heracles_tier]>
        - define tier <[tier_result].get[1]>
        - define tier_color <[tier_result].get[2]>
        - define loot <proc[roll_heracles_loot].context[<[tier]>]>

        # Take 1 key after successful roll
        - take item:heracles_key quantity:1

        # Start crate animation with pre-rolled results
        # Use player-specific queue ID so it can be stopped if they close early
        - run heracles_crate_animation def.tier:<[tier]> def.tier_color:<[tier_color]> def.loot:<[loot]> id:heracles_crate_<player.uuid>

        # Track statistics
        - flag player heracles.crates_opened:++
        - flag player heracles.tier.<[tier].to_lowercase>:++

heracles_crate_animation:
    type: task
    debug: false
    definitions: tier|tier_color|loot
    script:
    # Store loot data as flag for early close detection
    - flag player heracles.crate.pending_loot:<[loot]>
    - flag player heracles.crate.pending_tier:<[tier]>
    - flag player heracles.crate.pending_tier_color:<[tier_color]>
    - flag player heracles.crate.animation_running:true

    # Narrate opening message
    - narrate "<&7>You insert the <&c>Heracles Key<&7>..."
    - playsound <player> sound:block_chest_open volume:1.0

    # Open GUI with dark red border around rolling area
    - define filler <item[gray_stained_glass_pane].with[display=<&7>]>
    - define border <item[red_stained_glass_pane].with[display=<&c>]>
    - define gui_items <list>
    - repeat 27:
        - define gui_items <[gui_items].include[<[filler]>]>

    - inventory open d:heracles_crate_gui
    - define crate_inv <player.open_inventory>
    - inventory set d:<[crate_inv]> o:<[gui_items]>

    # Set red border frame around entire GUI
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

    # Define preview pool as actual ItemTags (combat themed)
    - define preview_pool <list>
    - define preview_pool <[preview_pool].include[<item[arrow]>]>
    - define preview_pool <[preview_pool].include[<item[gunpowder]>]>
    - define preview_pool <[preview_pool].include[<item[iron_ingot]>]>
    - define preview_pool <[preview_pool].include[<item[emerald]>]>
    - define preview_pool <[preview_pool].include[<item[golden_apple]>]>
    - define preview_pool <[preview_pool].include[<item[enchanted_golden_apple]>]>
    - define preview_pool <[preview_pool].include[<item[diamond]>]>
    - define preview_pool <[preview_pool].include[<item[ender_pearl]>]>
    - define preview_pool <[preview_pool].include[<item[bone]>]>
    - define preview_pool <[preview_pool].include[<item[leather]>]>

    # Initialize scrolling slots with random items
    - define slot1 <[preview_pool].random>
    - define slot2 <[preview_pool].random>
    - define slot3 <[preview_pool].random>
    - define slot4 <[preview_pool].random>
    - define slot5 <[preview_pool].random>

    # Phase 1: Fast scroll (20 cycles, 2t each = 2s)
    - repeat 20:
        # Check if player closed inventory early
        - if !<player.has_flag[heracles.crate.animation_running]>:
            - stop

        # Shift items left and add new item on right
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
        # Check if player closed inventory early
        - if !<player.has_flag[heracles.crate.animation_running]>:
            - stop

        # Shift items left and add new item on right
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
        # Check if player closed inventory early
        - if !<player.has_flag[heracles.crate.animation_running]>:
            - stop

        # Shift items left and add new item on right
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
    - define final_display_item <proc[build_heracles_loot_display_item].context[<[loot]>]>

    # Final landing animation - winning item scrolls into center
    # Continue the scrolling pattern until final item reaches center (slot 14)
    # It takes 3 steps to go from slot 16 to slot 14

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
    - if !<player.has_flag[heracles.crate.animation_running]>:
        - stop

    # Clear animation flag BEFORE closing to prevent early close handler from triggering
    - flag player heracles.crate.animation_running:!

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
            - playsound <player> sound:entity_wither_spawn volume:0.5

    # Title feedback
    - title "title:<[tier_color]><&l><[tier]> DROP" subtitle:<&f><[loot].get[display]> fade_in:5t stay:40t fade_out:10t targets:<player>

    # Clear pending loot flags after normal completion
    - flag player heracles.crate.pending_loot:!
    - flag player heracles.crate.pending_tier:!
    - flag player heracles.crate.pending_tier_color:!

heracles_crate_gui:
    type: inventory
    inventory: chest
    gui: true
    title: <&8>Heracles Crate - Rolling...
    size: 27

# ============================================
# TIER ROLLING
# ============================================

roll_heracles_tier:
    type: procedure
    debug: false
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

# ============================================
# LOOT TABLES
# ============================================

roll_heracles_loot:
    type: procedure
    debug: false
    definitions: tier
    script:
    - choose <[tier]>:
        - case MORTAL:
            - define pool <list>
            - define pool <[pool].include[arrow:8]>
            - define pool <[pool].include[gunpowder:4]>
            - define pool <[pool].include[bread:8]>
            - define pool <[pool].include[iron_ingot:4]>
            - define pool <[pool].include[emerald:8]>
            - define pool <[pool].include[bone_meal:16]>
            - define pool <[pool].include[leather:4]>
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
            - define pool <[pool].include[ender_pearl:2]>
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
            - define pool <[pool].include[heracles_key:2]>
            - define pool <[pool].include[emerald_block:6]>
            - define pool <[pool].include[experience:250]>
            - define choice <[pool].random>
            - define parts <[choice].split[<&co>]>
            - define material <[parts].get[1]>
            - define qty <[parts].get[2]>
            - if <[material]> == experience:
                - define loot_map <map[type=EXPERIENCE;amount=<[qty]>;display=+<[qty]> Experience]>
            - else if <[material]> == heracles_key:
                - define loot_map <map[type=CUSTOM;script=heracles_key;quantity=<[qty]>;display=Heracles Key x<[qty]>]>
            - else:
                - define display_name <[material].to_titlecase.replace[_].with[ ]>
                - define loot_map <map[type=ITEM;material=<[material]>;quantity=<[qty]>;display=<[display_name]> x<[qty]>]>
            - determine <[loot_map]>

        - case MYTHIC:
            - define pool <list>
            - define pool <[pool].include[enchanted_golden_apple:1]>
            - define pool <[pool].include[heracles_sword:1]>
            - define pool <[pool].include[heracles_blessing:1]>
            - define pool <[pool].include[heracles_title:1]>
            - define pool <[pool].include[gold_block:16]>
            - define pool <[pool].include[emerald_block:16]>
            - define choice <[pool].random>
            - define parts <[choice].split[<&co>]>
            - define material <[parts].get[1]>
            - define qty <[parts].get[2]>
            - if <[material]> == heracles_sword || <[material]> == heracles_blessing:
                - define display_name <[material].to_titlecase.replace[_].with[ ]>
                - define loot_map <map[type=CUSTOM;script=<[material]>;quantity=<[qty]>;display=<[display_name]> x<[qty]>]>
            - else if <[material]> == heracles_title:
                - define loot_map <map[type=TITLE;flag=heracles.item.title;display=Hero of Olympus Title]>
            - else:
                - define display_name <[material].to_titlecase.replace[_].with[ ]>
                - define loot_map <map[type=ITEM;material=<[material]>;quantity=<[qty]>;display=<[display_name]> x<[qty]>]>
            - determine <[loot_map]>

        - case OLYMPIAN:
            - define loot_map <map[type=CUSTOM;script=mars_key;quantity=1;display=Mars Key x1]>
            - determine <[loot_map]>

# ============================================
# LOOT DISPLAY ITEM BUILDER
# ============================================

build_heracles_loot_display_item:
    type: procedure
    debug: false
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
            - determine <item[experience_bottle].with[display=<&a>+<[loot].get[amount]> Experience]>

        - case TITLE:
            # Title displays as a name tag
            - determine <item[name_tag].with[display=<&4><&l><[loot].get[display]>;enchantments=mending,1;hides=ALL]>

# ============================================
# EARLY CLOSE HANDLER
# ============================================

heracles_crate_early_close:
    type: world
    debug: false
    events:
        on player closes heracles_crate_gui:
        # Check if animation is still running
        - if !<player.has_flag[heracles.crate.animation_running]>:
            - stop

        # Clear the animation running flag to signal the queue to stop naturally
        # Don't try to force-stop the queue - it may have already finished
        - flag player heracles.crate.animation_running:!

        # Wait a tick to ensure the queue sees the flag change
        - wait 1t

        - define loot <player.flag[heracles.crate.pending_loot]>
        - define tier <player.flag[heracles.crate.pending_tier]>
        - define tier_color <player.flag[heracles.crate.pending_tier_color]>

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
        - flag player heracles.crate.pending_loot:!
        - flag player heracles.crate.pending_tier:!
        - flag player heracles.crate.pending_tier_color:!
