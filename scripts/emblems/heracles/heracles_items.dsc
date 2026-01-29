# ============================================
# HERACLES CUSTOM ITEMS
# ============================================
#
# Custom items from Heracles MYTHIC crate tier:
# - Heracles Sword (cosmetic prestige sword)
# - Heracles Blessing (10% progress boost consumable)
# - Heracles Title (flag-based chat prefix unlock)
#

# ============================================
# HERACLES SWORD (MYTHIC)
# ============================================

heracles_sword:
    type: item
    material: diamond_sword
    display name: <&d>Heracles Sword<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
        unbreakable: true
    lore:
    - <&7>A diamond blade blessed by
    - <&7>Heracles, unbreakable and eternal.
    - <empty>
    - <&8>Unbreakable
    - <empty>
    - <&d><&l>MYTHIC SWORD

# No special mechanics - cosmetic prestige item

# ============================================
# HERACLES BLESSING (MYTHIC)
# ============================================

heracles_blessing:
    type: item
    material: nether_star
    display name: <&d>Heracles Blessing<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>A divine blessing from the
    - <&7>greatest of Greek heroes,
    - <&7>imbued with heroic valor.
    - <empty>
    - <&e>Right-click to boost progress
    - <&e>on all incomplete Heracles
    - <&e>activities by 10%.
    - <empty>
    - <&8>Single-use consumable
    - <&8>Stackable & tradeable
    - <empty>
    - <&d><&l>MYTHIC CONSUMABLE

heracles_blessing_use:
    type: world
    debug: false
    events:
        on player right clicks block with:heracles_blessing:
        - determine cancelled passively

        # Take item first
        - take item:heracles_blessing quantity:1

        # Track boosted amounts
        - define boosts <list>

        # Apply boosts to incomplete activities only
        - if !<player.has_flag[heracles.component.pillagers]>:
            - flag player heracles.pillagers.count:+:250
            - define boosts <[boosts].include[<&e>+250 pillager progress]>

        - if !<player.has_flag[heracles.component.raids]>:
            - flag player heracles.raids.count:+:5
            - define boosts <[boosts].include[<&e>+5 raid progress]>

        - if !<player.has_flag[heracles.component.emeralds]>:
            - flag player heracles.emeralds.count:+:1000
            - define boosts <[boosts].include[<&e>+1,000 emerald progress]>

        # Feedback
        - if <[boosts].is_empty>:
            - narrate "<&c>All Heracles activities already complete!"
        - else:
            - foreach <[boosts]> as:boost:
                - narrate <[boost]>
            - title "title:<&c><&l>HERACLES' BLESSING" subtitle:<&e>Divine boost applied fade_in:5t stay:30t fade_out:10t
            - playsound <player> sound:block_beacon_activate volume:1.0 pitch:1.2
            - playsound <player> sound:entity_player_levelup volume:0.8

        on player right clicks entity with:heracles_blessing:
        - determine cancelled passively

        # Same logic as block click (DRY - inject would be better, but this works)
        - take item:heracles_blessing quantity:1
        - define boosts <list>

        - if !<player.has_flag[heracles.component.pillagers]>:
            - flag player heracles.pillagers.count:+:250
            - define boosts <[boosts].include[<&e>+250 pillager progress]>

        - if !<player.has_flag[heracles.component.raids]>:
            - flag player heracles.raids.count:+:5
            - define boosts <[boosts].include[<&e>+5 raid progress]>

        - if !<player.has_flag[heracles.component.emeralds]>:
            - flag player heracles.emeralds.count:+:1000
            - define boosts <[boosts].include[<&e>+1,000 emerald progress]>

        - if <[boosts].is_empty>:
            - narrate "<&c>All Heracles activities already complete!"
        - else:
            - foreach <[boosts]> as:boost:
                - narrate <[boost]>
            - title "title:<&c><&l>HERACLES' BLESSING" subtitle:<&e>Divine boost applied fade_in:5t stay:30t fade_out:10t
            - playsound <player> sound:block_beacon_activate volume:1.0 pitch:1.2
            - playsound <player> sound:entity_player_levelup volume:0.8

# ============================================
# HERACLES TITLE (MYTHIC)
# ============================================
#
# Not a physical item - this is a flag-based unlock
# Flag: heracles.item.title: true
# Title Text: <&4>[Hero of Olympus]<&r>
#
# Awarded directly from crate (TITLE type in loot table)
# Chat integration handled in cosmetics system
#
