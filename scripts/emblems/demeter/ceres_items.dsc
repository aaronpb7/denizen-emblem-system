# ============================================
# CERES ITEMS
# ============================================
#
# Ceres meta-progression items:
# - Ceres Key (opens Ceres crate, 50/50 god apple vs unique item)
# - Ceres Hoe (netherite, unbreakable, auto-replant)
# - Ceres Wand (bee summoner staff)
# - Head of Demeter (decorative god head, lightning on place)
# - Yellow Shulker Box (rare utility)
#

# ============================================
# CERES KEY
# ============================================

ceres_key:
    type: item
    material: nether_star
    display name: <&b>Ceres Key<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>A key forged in the Roman vault,
    - <&7>where Ceres guards her most
    - <&7>precious and finite treasures.
    - <empty>
    - <&e>Right-click to unlock
    - <&e>a Ceres Crate.
    - <empty>
    - <&8>50% God Apple / 50% Unique Item
    - <empty>
    - <&b><&l><&k>|||<&r> <&b><&l>OLYMPIAN KEY<&r> <&b><&l><&k>|||

# ============================================
# CERES HOE
# ============================================

ceres_hoe:
    type: item
    material: netherite_hoe
    display name: <&b>Ceres Hoe<&r>
    mechanisms:
        unbreakable: true
    lore:
    - <&7>A netherite hoe blessed by
    - <&7>Ceres, unbreakable and eternal.
    - <empty>
    - <&e>Automatically replants crops
    - <&e>when harvested.
    - <empty>
    - <&8>Unbreakable
    - <&8>Unique - One per player
    - <empty>
    - <&b><&l><&k>|||<&r> <&b><&l>OLYMPIAN HOE<&r> <&b><&l><&k>|||

# ============================================
# CERES WAND
# ============================================

ceres_wand:
    type: item
    material: blaze_rod
    display name: <&b>Ceres Wand<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
        unbreakable: true
    lore:
    - <&7>A staff imbued with the
    - <&7>protective fury of Ceres' bees.
    - <empty>
    - <&e>Right-click to summon 6 angry
    - <&e>bees that attack nearby hostiles.
    - <empty>
    - <&8>Cooldown: 30 seconds
    - <&8>Unique - One per player
    - <empty>
    - <&b><&l><&k>|||<&r> <&b><&l>OLYMPIAN WAND<&r> <&b><&l><&k>|||

# ============================================
# CERES WAND BLUEPRINT
# ============================================

ceres_wand_blueprint:
    type: item
    material: map
    display name: <&b>Ceres Wand Blueprint<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>Ancient schematics detailing
    - <&7>the construction of Ceres' Wand.
    - <empty>
    - <&e>Right-click to view recipe.
    - <empty>
    - <&b><&l><&k>|||<&r> <&b><&l>OLYMPIAN BLUEPRINT<&r> <&b><&l><&k>|||

# ============================================
# HEAD OF DEMETER (TROPHY)
# ============================================

demeter_head:
    type: item
    material: player_head
    mechanisms:
        skull_skin: 7fef7fb4-e604-4b09-8eb1-d29ad0c0ed10|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMzQyMmE3NTU4NmZlOTUxMDgwNjMzMGE3YWUxYWY5Nzg0NjhjNjZkMmJkODExMWI4Njc1OWQxYzY2ZWI3N2M1OSJ9fX0=
    display name: <&b>Head of Demeter<&r>
    lore:
    - <&7>A divine effigy of Demeter,
    - <&7>goddess of the harvest.
    - <empty>
    - <&e>Right-click to pick up.
    - <empty>
    - <&8>Unique - One per player
    - <empty>
    - <&b><&l><&k>|||<&r> <&b><&l>OLYMPIAN TROPHY<&r> <&b><&l><&k>|||
