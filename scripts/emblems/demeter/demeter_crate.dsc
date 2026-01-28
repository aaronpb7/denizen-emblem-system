# ============================================
# EMBLEM SYSTEM V2 - DEMETER CRATE
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

        # Take 1 key immediately
        - take item:demeter_key quantity:1

        # Start crate animation
        - run demeter_crate_animation

        # Track statistics (optional)
        - flag player demeter.crates_opened:++

demeter_crate_animation:
    type: task
    debug: false
    script:
    # Narrate opening message
    - narrate "<&7>You insert the <&6>Demeter Key<&7>..."

    # Open GUI with gray panes
    - define filler <item[gray_stained_glass_pane].with[display_name=<&7>]>
    - define gui_items <list>
    - repeat 27:
        - define gui_items <[gui_items].include[<[filler]>]>

    - inventory open d:demeter_crate_gui
    - inventory set d:<player.open_inventory> o:<[gui_items]>

    # Cycling animation (1s)
    - define preview_items <list[bread|cooked_beef|wheat|emerald|golden_apple|enchanted_golden_apple]>
    - repeat 5:
        - define random_item <[preview_items].random>
        - inventory set d:<player.open_inventory> o:<item[<[random_item]>]> slot:14
        - playsound <player> sound:ui_button_click volume:0.3
        - wait 2t

    # Roll tier
    - define tier_result <proc[roll_demeter_tier]>
    - define tier <[tier_result].get[1]>
    - define tier_color <[tier_result].get[2]>

    # Roll loot
    - define loot <proc[roll_demeter_loot].context[<[tier]>]>

    # Show loot item in GUI
    - choose <[loot].get[type]>:
        - case ITEM:
            - inventory set d:<player.open_inventory> o:<[loot].get[item]> slot:14
        - case CUSTOM:
            - inventory set d:<player.open_inventory> o:<item[<[loot].get[script]>]> slot:14
        - case EXPERIENCE:
            - inventory set d:<player.open_inventory> o:<item[experience_bottle].with[display_name=<&a>+<[loot].get[amount]> Experience]> slot:14
    - wait 20t

    # Award loot INLINE (MapTag does not survive def: passing)
    - choose <[loot].get[type]>:
        - case ITEM:
            - define award_item <[loot].get[item]>
            - define award_qty <[loot].get[quantity]>
            - if <player.inventory.can_fit[<[award_item]>]> >= <[award_qty]>:
                - give <[award_item]> quantity:<[award_qty]>
            - else:
                - drop <[award_item]> quantity:<[award_qty]> at:<player.location>
                - narrate "<&c>Inventory full! Item dropped at your feet."

        - case EXPERIENCE:
            - experience give <[loot].get[amount]>

        - case CUSTOM:
            - define award_script <[loot].get[script]>
            - define award_qty <[loot].get[quantity]>
            - if <player.inventory.can_fit[<item[<[award_script]>]>]> >= <[award_qty]>:
                - give <item[<[award_script]>]> quantity:<[award_qty]>
            - else:
                - drop <item[<[award_script]>]> quantity:<[award_qty]> at:<player.location>
                - narrate "<&c>Inventory full! Item dropped at your feet."

    # Chat feedback
    - narrate "<&7>[<[tier_color]><[tier]><&7>] <&f><[loot].get[display]>"

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

    # Track tier stats
    - flag player demeter.tier.<[tier].to_lowercase>:++

    # Close GUI
    - inventory close

demeter_crate_gui:
    type: inventory
    inventory: chest
    gui: true
    title: <&e>Demeter Crate - Rolling...
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
            - define pool <[pool].include[bread|16]>
            - define pool <[pool].include[cooked_beef|8]>
            - define pool <[pool].include[baked_potato|8]>
            - define pool <[pool].include[wheat|32]>
            - define pool <[pool].include[hay_block|8]>
            - define pool <[pool].include[bone_meal|16]>
            - define pool <[pool].include[pumpkin_pie|8]>
            - define choice <[pool].random>
            - define parts <[choice].split[|]>
            - define material <[parts].get[1]>
            - define qty <[parts].get[2]>
            - define display_name <[material].to_titlecase.replace[_].with[ ]>
            - define loot_map <map[type=ITEM;item=<item[<[material]>]>;quantity=<[qty]>;display=<[display_name]> x<[qty]>]>
            - determine <[loot_map]>

        - case HEROIC:
            - define pool <list>
            - define pool <[pool].include[golden_carrot|8]>
            - define pool <[pool].include[emerald|16]>
            - define pool <[pool].include[gold_block|1]>
            - define pool <[pool].include[experience|100]>
            - define pool <[pool].include[lead|1]>
            - define choice <[pool].random>
            - define parts <[choice].split[|]>
            - define material <[parts].get[1]>
            - define qty <[parts].get[2]>
            - if <[material]> == experience:
                - define loot_map <map[type=EXPERIENCE;amount=<[qty]>;display=+<[qty]> Experience]>
            - else:
                - define display_name <[material].to_titlecase.replace[_].with[ ]>
                - define loot_map <map[type=ITEM;item=<item[<[material]>]>;quantity=<[qty]>;display=<[display_name]> x<[qty]>]>
            - determine <[loot_map]>

        - case LEGENDARY:
            - define pool <list>
            - define pool <[pool].include[golden_apple|2]>
            - define pool <[pool].include[demeter_key|2]>
            - define pool <[pool].include[emerald_block|6]>
            - define pool <[pool].include[experience|250]>
            - define choice <[pool].random>
            - define parts <[choice].split[|]>
            - define material <[parts].get[1]>
            - define qty <[parts].get[2]>
            - if <[material]> == experience:
                - define loot_map <map[type=EXPERIENCE;amount=<[qty]>;display=+<[qty]> Experience]>
            - else if <[material]> == demeter_key:
                - define loot_map <map[type=CUSTOM;script=demeter_key;quantity=<[qty]>;display=Demeter Key x<[qty]>]>
            - else:
                - define display_name <[material].to_titlecase.replace[_].with[ ]>
                - define loot_map <map[type=ITEM;item=<item[<[material]>]>;quantity=<[qty]>;display=<[display_name]> x<[qty]>]>
            - determine <[loot_map]>

        - case MYTHIC:
            - define pool <list>
            - define pool <[pool].include[enchanted_golden_apple|1]>
            - define pool <[pool].include[demeter_hoe|1]>
            - define pool <[pool].include[demeter_blessing|1]>
            - define pool <[pool].include[gold_block|16]>
            - define pool <[pool].include[emerald_block|16]>
            - define choice <[pool].random>
            - define parts <[choice].split[|]>
            - define material <[parts].get[1]>
            - define qty <[parts].get[2]>
            - if <[material]> == demeter_hoe || <[material]> == demeter_blessing:
                - define display_name <[material].to_titlecase.replace[_].with[ ]>
                - define loot_map <map[type=CUSTOM;script=<[material]>;quantity=<[qty]>;display=<[display_name]> x<[qty]>]>
            - else:
                - define display_name <[material].to_titlecase.replace[_].with[ ]>
                - define loot_map <map[type=ITEM;item=<item[<[material]>]>;quantity=<[qty]>;display=<[display_name]> x<[qty]>]>
            - determine <[loot_map]>

        - case OLYMPIAN:
            - define loot_map <map[type=CUSTOM;script=ceres_key;quantity=1;display=Ceres Key x1]>
            - determine <[loot_map]>

# ============================================
# LOOT AWARDING
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

    # Feedback
    - narrate "<&7>[<[tier_color]><[tier]><&7>] <&f><[loot].get[display]>"

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
