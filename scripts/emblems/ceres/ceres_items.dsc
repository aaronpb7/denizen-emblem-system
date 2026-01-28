# ============================================
# EMBLEM SYSTEM V2 - CERES ITEMS
# ============================================
#
# Ceres meta-progression items:
# - Ceres Key (opens Ceres crate, 50/50 god apple vs unique item)
# - Ceres Hoe (netherite, unbreakable, auto-replant)
# - Ceres Wand (bee summoner staff)
# - Yellow Shulker Box (rare utility)
#

# ============================================
# CERES KEY
# ============================================

ceres_key:
    type: item
    material: echo_shard
    display name: <&b><&l>CERES KEY<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&b>OLYMPIAN
    - <empty>
    - <&7>A key forged in the Roman vault,
    - <&7>where Ceres guards her most
    - <&7>precious and finite treasures.
    - <empty>
    - <&e>Right-click to unlock
    - <&e>a Ceres Crate.
    - <empty>
    - <&8>50% God Apple / 50% Unique Item

# ============================================
# CERES HOE
# ============================================

ceres_hoe:
    type: item
    material: netherite_hoe
    display name: <&d><&l>CERES HOE<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
        unbreakable: true
    lore:
    - <&d>MYTHIC
    - <empty>
    - <&7>A netherite hoe blessed by
    - <&7>Ceres, unbreakable and eternal.
    - <empty>
    - <&e>Automatically replants crops
    - <&e>when harvested.
    - <empty>
    - <&8>Unbreakable
    - <&8>Unique - One per player

# ============================================
# CERES WAND
# ============================================

ceres_wand:
    type: item
    material: blaze_rod
    display name: <&d><&l>CERES WAND<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
        unbreakable: true
    lore:
    - <&d>MYTHIC
    - <empty>
    - <&7>A staff imbued with the
    - <&7>protective fury of Ceres' bees.
    - <empty>
    - <&e>Right-click to summon 6 angry
    - <&e>bees that attack nearby hostiles.
    - <empty>
    - <&8>Cooldown: 30 seconds
    - <&8>Unique - One per player
