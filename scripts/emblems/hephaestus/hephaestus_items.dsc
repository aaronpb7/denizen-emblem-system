# ============================================
# HEPHAESTUS CUSTOM ITEMS
# ============================================
#
# Custom items from Hephaestus MYTHIC crate tier:
# - Hephaestus Pickaxe (cosmetic prestige pickaxe)
# - Hephaestus Blessing (10% progress boost consumable)
# - Hephaestus Title (flag-based chat prefix unlock)
#

# ============================================
# HEPHAESTUS PICKAXE (MYTHIC)
# ============================================

hephaestus_pickaxe:
    type: item
    material: diamond_pickaxe
    display name: <&d>Hephaestus Pickaxe<&r>
    mechanisms:
        unbreakable: true
    lore:
    - <&7>A diamond pickaxe blessed by
    - <&7>Hephaestus, unbreakable and eternal.
    - <empty>
    - <&8>Unbreakable
    - <empty>
    - <&d><&l>MYTHIC PICKAXE

# No special mechanics - cosmetic prestige item

# ============================================
# HEPHAESTUS BLESSING (MYTHIC)
# ============================================

hephaestus_blessing:
    type: item
    material: nether_star
    display name: <&d>Hephaestus Blessing<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>A divine blessing from the
    - <&7>god of the forge, imbued
    - <&7>with craftsmanship.
    - <empty>
    - <&e>Right-click to boost progress
    - <&e>on all incomplete Hephaestus
    - <&e>activities by 10%.
    - <empty>
    - <&8>Single-use consumable
    - <&8>Stackable & tradeable
    - <empty>
    - <&d><&l>MYTHIC CONSUMABLE

# ============================================
# HEPHAESTUS TITLE (MYTHIC)
# ============================================
#
# Not a physical item - this is a flag-based unlock
# Flag: hephaestus.item.title: true
# Title Text: <&8>[Master Smith]<&r>
#
# Awarded directly from crate (TITLE type in loot table)
# Chat integration handled in cosmetics system
#
