# ============================================
# VULCAN ITEMS
# ============================================
#
# Vulcan meta-progression items:
# - Vulcan Pickaxe (netherite, unbreakable, toggleable auto-smelt)
# - Vulcan Forge Charm (offhand fire resistance + particles)
# - Gray Shulker Box (rare utility)
# - Vulcan Title (flag-based chat prefix)
# - Head of Hephaestus (decorative god head, lightning on place)
#

# ============================================
# VULCAN PICKAXE
# ============================================

vulcan_pickaxe:
    type: item
    material: netherite_pickaxe
    display name: <&b>Vulcan Pickaxe<&r>
    mechanisms:
        unbreakable: true
    lore:
    - <&7>A netherite pickaxe blessed by
    - <&7>Vulcan, unbreakable and powerful.
    - <empty>
    - <&e>Right-click to toggle auto-smelt
    - <&e>for iron and gold ore.
    - <empty>
    - <&8>Unbreakable
    - <&8>Unique - One per player
    - <empty>
    - <&b><&l><&k>|||<&r> <&b><&l>OLYMPIAN PICKAXE<&r> <&b><&l><&k>|||

# ============================================
# VULCAN PICKAXE BLUEPRINT
# ============================================

vulcan_pickaxe_blueprint:
    type: item
    material: map
    display name: <&b>Vulcan Pickaxe Blueprint<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>Forge diagrams detailing the
    - <&7>creation of Vulcan's Pickaxe.
    - <empty>
    - <&e>Right-click to view recipe.
    - <empty>
    - <&b><&l><&k>|||<&r> <&b><&l>OLYMPIAN BLUEPRINT<&r> <&b><&l><&k>|||

# Auto-smelt toggle
vulcan_pickaxe_toggle:
    type: world
    debug: false
    events:
        on player right clicks block with:vulcan_pickaxe:
        - determine cancelled passively
        - run vulcan_pickaxe_toggle_task

        on player right clicks air with:vulcan_pickaxe:
        - determine cancelled passively
        - run vulcan_pickaxe_toggle_task

vulcan_pickaxe_toggle_task:
    type: task
    debug: false
    script:
    # Toggle auto-smelt flag
    - if <player.has_flag[vulcan.auto_smelt]>:
        - flag player vulcan.auto_smelt:!
        - actionbar "<&7>Auto-Smelt: <&c>OFF"
        - playsound <player> sound:block_lever_click volume:0.5 pitch:0.8
    - else:
        - flag player vulcan.auto_smelt:true
        - actionbar "<&7>Auto-Smelt: <&a>ON"
        - playsound <player> sound:block_lever_click volume:0.5 pitch:1.2

# Auto-smelt mechanic for iron and gold ore
vulcan_pickaxe_auto_smelt:
    type: world
    debug: false
    events:
        on player breaks iron_ore|deepslate_iron_ore|gold_ore|deepslate_gold_ore|nether_gold_ore:
        # Check if holding Vulcan Pickaxe
        - if <player.item_in_hand.script.name.if_null[null]> != vulcan_pickaxe:
            - stop

        # Check if auto-smelt is enabled
        - if !<player.has_flag[vulcan.auto_smelt]>:
            - stop

        # Determine output based on ore type
        - define ore <context.material.name>
        - if <[ore].contains[iron]>:
            - define output iron_ingot
            - define qty 1
        - else if <[ore]> == nether_gold_ore:
            - define output gold_nugget
            - define qty <util.random.int[2].to[6]>
        - else:
            - define output gold_ingot
            - define qty 1

        # Visual feedback
        - playeffect effect:flame at:<context.location.add[0.5,0.5,0.5]> quantity:5 offset:0.3
        - playsound <player> sound:block_furnace_fire_crackle volume:0.3 pitch:1.2

        # Replace default drops with smelted output
        - determine <item[<[output]>].with[quantity=<[qty]>]>

# ============================================
# VULCAN FORGE CHARM
# ============================================

vulcan_forge_charm:
    type: item
    material: blaze_powder
    display name: <&b>Vulcan Forge Charm<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>A charm imbued with the
    - <&7>eternal flames of Vulcan's forge.
    - <empty>
    - <&e>Hold in offhand for permanent
    - <&e>fire resistance and light particles.
    - <empty>
    - <&8>Unique - One per player
    - <empty>
    - <&b><&l><&k>|||<&r> <&b><&l>OLYMPIAN CHARM<&r> <&b><&l><&k>|||

# Forge charm passive effect loop
vulcan_forge_charm_effect:
    type: world
    debug: false
    events:
        on system time secondly every:1:
        - foreach <server.online_players> as:p:
            # Check if holding Vulcan Forge Charm in offhand
            - if <[p].item_in_offhand.script.name.if_null[null]> != vulcan_forge_charm:
                - foreach next

            # Apply fire resistance (refresh every second, 3 second duration for buffer)
            - cast fire_resistance duration:3s amplifier:0 <[p]> no_icon hide_particles no_ambient

            # Light particle effect (subtle)
            - playeffect effect:flame at:<[p].location.add[0,1,0]> quantity:3 offset:0.3 targets:<[p]>

# ============================================
# VULCAN TITLE
# ============================================
#
# Not a physical item - this is a flag-based unlock
# Flag: vulcan.item.title: true
# Title Text: <&8>[Vulcan's Chosen]<&r>
#
# Awarded directly from crate (TITLE type in loot table)
# Chat integration handled in cosmetics system (ceres_mechanics.dsc)
#

# ============================================
# HEAD OF HEPHAESTUS (TROPHY)
# ============================================

hephaestus_head:
    type: item
    material: player_head
    mechanisms:
        skull_skin: b8d496e9-3eb3-494e-8ada-4fb9ce7bcd85|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMWVkMTQ2Zjk1ZTEzMmZhNjM5NTNjNTI4ZjZhMWIzNDk5ZTg3MGM0NmEyZTIyODk5YjVmMzAwODQ0ZDgyZDJlNyJ9fX0=
    display name: <&b>Head of Hephaestus<&r>
    lore:
    - <&7>A divine effigy of Hephaestus,
    - <&7>god of the forge and flame.
    - <empty>
    - <&e>Right-click to pick up.
    - <empty>
    - <&8>Unique - One per player
    - <empty>
    - <&b><&l><&k>|||<&r> <&b><&l>OLYMPIAN TROPHY<&r> <&b><&l><&k>|||
