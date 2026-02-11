# ============================================
# MYTHIC CRAFTING SYSTEM
# ============================================
#
# Combines Mythic Fragments + Blueprints + Diamond Blocks
# to forge Olympian items.
#
# Recipes:
# - Ceres Wand: ceres_wand_blueprint + 4x demeter_mythic_fragment + 4x diamond_block
# - Mars Shield: mars_shield_blueprint + 4x heracles_mythic_fragment + 4x diamond_block
# - Vulcan Pickaxe: vulcan_pickaxe_blueprint + 4x hephaestus_mythic_fragment + 4x diamond_block
# - Neptune Trident: neptune_trident_blueprint + 4x triton_mythic_fragment + 4x diamond_block
#

# ============================================
# RECIPE GUI INVENTORY
# ============================================

mythic_crafting_gui:
    type: inventory
    inventory: chest
    gui: true
    title: <&8>Mythic Forge
    size: 45

# ============================================
# RECIPE DATA PROCEDURE
# ============================================

get_recipe_data:
    type: procedure
    debug: false
    definitions: recipe_id
    script:
    - choose <[recipe_id]>:
        - case ceres_wand:
            - determine <map[blueprint=ceres_wand_blueprint;fragment=demeter_mythic_fragment;result=ceres_wand;result_name=<&b>Ceres Wand;flag=ceres.item.wand;fragment_name=<&d>Demeter Mythic Fragment;god_color=<&b>]>
        - case mars_shield:
            - determine <map[blueprint=mars_shield_blueprint;fragment=heracles_mythic_fragment;result=mars_shield;result_name=<&b>Mars Shield;flag=mars.item.shield;fragment_name=<&d>Heracles Mythic Fragment;god_color=<&4>]>
        - case vulcan_pickaxe:
            - determine <map[blueprint=vulcan_pickaxe_blueprint;fragment=hephaestus_mythic_fragment;result=vulcan_pickaxe;result_name=<&b>Vulcan Pickaxe;flag=vulcan.item.pickaxe;fragment_name=<&d>Hephaestus Mythic Fragment;god_color=<&b>]>
        - case neptune_trident:
            - determine <map[blueprint=neptune_trident_blueprint;fragment=triton_mythic_fragment;result=neptune_trident;result_name=<&b>Neptune's Trident;flag=neptune.item.trident;fragment_name=<&d>Triton Mythic Fragment;god_color=<&3>]>
    # Fallback
    - determine null

# ============================================
# OPEN RECIPE GUI TASK
# ============================================

open_recipe_gui:
    type: task
    debug: false
    definitions: recipe_id
    script:
    # Get recipe data
    - define recipe <proc[get_recipe_data].context[<[recipe_id]>]>
    - if <[recipe]> == null:
        - narrate "<&c>Unknown recipe."
        - stop

    # Store which recipe we're viewing
    - flag player crafting.viewing_recipe:<[recipe_id]>

    # Open GUI
    - inventory open d:mythic_crafting_gui

    # Fill with gray panes
    - define pane <item[gray_stained_glass_pane].with[display=<&7>]>
    - define inv <player.open_inventory>
    - repeat 45:
        - inventory set d:<[inv]> slot:<[value]> o:<[pane]>

    # Build display items
    - define diamond_display <item[diamond_block].with[display=<&b>Diamond Block]>
    - define fragment_display <item[<[recipe].get[fragment]>].with[quantity=1]>
    - define blueprint_display <item[<[recipe].get[blueprint]>]>
    - define arrow_display <item[crafting_table].with[display=<&e>Mythic Forge;lore=<&7>Combine ingredients to|<&7>forge an Olympian item.]>

    # Build result display
    - define result_display <item[<[recipe].get[result]>]>
    - if <player.has_flag[<[recipe].get[flag]>]>:
        - define result_display <[result_display].with[lore=<&7>A divine Olympian item.|<empty>|<&a>You already own this item!|<empty>|<&c>Cannot craft again.]>
    - else:
        - define result_display <[result_display].with[lore=<&7>A divine Olympian item.|<empty>|<&a>Click to craft!|<empty>|<&8>Requires all ingredients.]>

    # Place items in 3x3 grid pattern
    # Row 2: slots 10-18 → DB(11), MF(12), DB(13)
    # Row 3: slots 19-27 → MF(20), BP(21), MF(22), arrow(24), result(26)
    # Row 4: slots 28-36 → DB(29), MF(30), DB(31)
    - inventory set d:<[inv]> slot:11 o:<[diamond_display]>
    - inventory set d:<[inv]> slot:12 o:<[fragment_display]>
    - inventory set d:<[inv]> slot:13 o:<[diamond_display]>
    - inventory set d:<[inv]> slot:20 o:<[fragment_display]>
    - inventory set d:<[inv]> slot:21 o:<[blueprint_display]>
    - inventory set d:<[inv]> slot:22 o:<[fragment_display]>
    - inventory set d:<[inv]> slot:24 o:<[arrow_display]>
    - inventory set d:<[inv]> slot:26 o:<[result_display]>
    - inventory set d:<[inv]> slot:29 o:<[diamond_display]>
    - inventory set d:<[inv]> slot:30 o:<[fragment_display]>
    - inventory set d:<[inv]> slot:31 o:<[diamond_display]>

# ============================================
# RIGHT-CLICK HANDLER (Fragments + Blueprints)
# ============================================

mythic_crafting_right_click:
    type: world
    debug: false
    events:
        # Fragments
        on player right clicks block with:demeter_mythic_fragment:
        - determine cancelled passively
        - run open_recipe_gui def.recipe_id:ceres_wand

        on player right clicks air with:demeter_mythic_fragment:
        - determine cancelled passively
        - run open_recipe_gui def.recipe_id:ceres_wand

        on player right clicks block with:heracles_mythic_fragment:
        - determine cancelled passively
        - run open_recipe_gui def.recipe_id:mars_shield

        on player right clicks air with:heracles_mythic_fragment:
        - determine cancelled passively
        - run open_recipe_gui def.recipe_id:mars_shield

        on player right clicks block with:hephaestus_mythic_fragment:
        - determine cancelled passively
        - run open_recipe_gui def.recipe_id:vulcan_pickaxe

        on player right clicks air with:hephaestus_mythic_fragment:
        - determine cancelled passively
        - run open_recipe_gui def.recipe_id:vulcan_pickaxe

        # Blueprints
        on player right clicks block with:ceres_wand_blueprint:
        - determine cancelled passively
        - run open_recipe_gui def.recipe_id:ceres_wand

        on player right clicks air with:ceres_wand_blueprint:
        - determine cancelled passively
        - run open_recipe_gui def.recipe_id:ceres_wand

        on player right clicks block with:mars_shield_blueprint:
        - determine cancelled passively
        - run open_recipe_gui def.recipe_id:mars_shield

        on player right clicks air with:mars_shield_blueprint:
        - determine cancelled passively
        - run open_recipe_gui def.recipe_id:mars_shield

        on player right clicks block with:vulcan_pickaxe_blueprint:
        - determine cancelled passively
        - run open_recipe_gui def.recipe_id:vulcan_pickaxe

        on player right clicks air with:vulcan_pickaxe_blueprint:
        - determine cancelled passively
        - run open_recipe_gui def.recipe_id:vulcan_pickaxe

        on player right clicks block with:triton_mythic_fragment:
        - determine cancelled passively
        - run open_recipe_gui def.recipe_id:neptune_trident

        on player right clicks air with:triton_mythic_fragment:
        - determine cancelled passively
        - run open_recipe_gui def.recipe_id:neptune_trident

        on player right clicks block with:neptune_trident_blueprint:
        - determine cancelled passively
        - run open_recipe_gui def.recipe_id:neptune_trident

        on player right clicks air with:neptune_trident_blueprint:
        - determine cancelled passively
        - run open_recipe_gui def.recipe_id:neptune_trident

# ============================================
# CRAFT CLICK HANDLER (slot 26 = result)
# ============================================

mythic_crafting_click:
    type: world
    debug: false
    events:
        on player clicks in mythic_crafting_gui:
        # Only respond to slot 26 (result item)
        - if <context.slot> != 26:
            - stop

        # Get recipe being viewed
        - if !<player.has_flag[crafting.viewing_recipe]>:
            - stop
        - define recipe_id <player.flag[crafting.viewing_recipe]>
        - define recipe <proc[get_recipe_data].context[<[recipe_id]>]>
        - if <[recipe]> == null:
            - stop

        # Check if already owned
        - if <player.has_flag[<[recipe].get[flag]>]>:
            - narrate "<&c>You already own this item!"
            - playsound <player> sound:entity_villager_no volume:0.5
            - stop

        # Check ingredients
        - define blueprint_script <[recipe].get[blueprint]>
        - define fragment_script <[recipe].get[fragment]>

        # Count what player has
        - define has_blueprint 0
        - define has_fragments 0
        - define has_diamonds 0

        - foreach <player.inventory.map_slots> as:item:
            - if <[item].script.name.if_null[null]> == <[blueprint_script]>:
                - define has_blueprint <[has_blueprint].add[<[item].quantity>]>
            - else if <[item].script.name.if_null[null]> == <[fragment_script]>:
                - define has_fragments <[has_fragments].add[<[item].quantity>]>
            - else if <[item].material.name> == diamond_block:
                - define has_diamonds <[has_diamonds].add[<[item].quantity>]>

        # Check if missing anything
        - define missing <list>
        - if <[has_blueprint]> < 1:
            - define missing <[missing].include[<&8>- <&f>1x <&b><[blueprint_script].replace[_].with[ ].to_titlecase>]>
        - if <[has_fragments]> < 4:
            - define need <element[4].sub[<[has_fragments]>]>
            - define missing <[missing].include[<&8>- <&f><[need]>x <[recipe].get[fragment_name]>]>
        - if <[has_diamonds]> < 4:
            - define need <element[4].sub[<[has_diamonds]>]>
            - define missing <[missing].include[<&8>- <&f><[need]>x <&b>Diamond Block]>

        - if <[missing].size> > 0:
            - narrate "<&c>Missing ingredients:"
            - foreach <[missing]> as:line:
                - narrate <[line]>
            - playsound <player> sound:entity_villager_no volume:0.5
            - stop

        # All ingredients present — take them
        - take item:<[blueprint_script]> quantity:1
        - take item:<[fragment_script]> quantity:4
        - take diamond_block quantity:4

        # Give result item
        - give <[recipe].get[result]>

        # Set ownership flag (safety net)
        - flag player <[recipe].get[flag]>:true

        # Close GUI
        - inventory close

        # Feedback
        - playsound <player> sound:ui_toast_challenge_complete volume:1.0
        - playsound <player> sound:block_anvil_use volume:0.5 pitch:0.8
        - title "title:<&b><&l>ITEM FORGED" "subtitle:<[recipe].get[result_name]>" fade_in:5t stay:40t fade_out:10t targets:<player>

        # Server announcement
        - announce "<&d><&l>MYTHIC FORGE!<&r> <&f><player.name> <&7>forged <[recipe].get[result_name]><&7>!"

# ============================================
# GUI CLOSE HANDLER
# ============================================

mythic_crafting_close:
    type: world
    debug: false
    events:
        on player closes mythic_crafting_gui:
        - flag player crafting.viewing_recipe:!
