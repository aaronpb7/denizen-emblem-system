# ============================================
# HERACLES CUSTOM ITEMS
# ============================================
#
# Custom items from Heracles MYTHIC crate tier:
# - Heracles Sword (cosmetic prestige sword)
# - Heracles Blessing (5% progress boost consumable)
# - Heracles Title (flag-based chat prefix unlock)
#

# ============================================
# HERACLES SWORD (MYTHIC)
# ============================================

heracles_sword:
    type: item
    material: diamond_sword
    display name: <&d>Heracles Sword<&r>
    mechanisms:
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
    - <&e>activities by 5%.
    - <empty>
    - <&8>Single-use consumable
    - <&8>Stackable & tradeable
    - <empty>
    - <&d><&l>MYTHIC CONSUMABLE

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

# ============================================
# HERACLES MYTHIC FRAGMENT
# ============================================

heracles_mythic_fragment:
    type: item
    material: amethyst_shard
    display name: <&d>Heracles Mythic Fragment<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>A shard of divine energy
    - <&7>from Heracles' trials of valor.
    - <empty>
    - <&e>Right-click to view recipe.
    - <empty>
    - <&8>Crafting ingredient
    - <&8>Stackable & tradeable
    - <empty>
    - <&d><&l>MYTHIC FRAGMENT
