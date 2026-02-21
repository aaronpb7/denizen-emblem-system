# ============================================
# CHARON ITEMS
# ============================================
#
# All items for Charon progression:
# - Charon Key (crate opener)
# - Charon Blessing (consumable boost)
# - Charon Mythic Fragment (crafting ingredient)
# - Component items (milestone rewards)
#

# ============================================
# CHARON KEY
# ============================================

charon_key:
    type: item
    material: tripwire_hook
    display name: <&e>Charon Key<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>A soul-forged key from
    - <&7>the rivers of the underworld.
    - <empty>
    - <&e>Right-click to open a
    - <&e>Charon Crate.
    - <empty>
    - <&e><&l>HEROIC KEY

# ============================================
# CHARON BLESSING
# ============================================

charon_blessing:
    type: item
    material: nether_star
    display name: <&d>Charon Blessing<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>A divine blessing from the
    - <&7>ferryman of the dead, imbued
    - <&7>with the underworld's power.
    - <empty>
    - <&e>Right-click to boost progress
    - <&e>on all incomplete Charon
    - <&e>activities by 5%.
    - <empty>
    - <&8>Single-use consumable
    - <&8>Stackable & tradeable
    - <empty>
    - <&d><&l>MYTHIC CONSUMABLE

# ============================================
# CHARON MYTHIC FRAGMENT
# ============================================

charon_mythic_fragment:
    type: item
    material: blaze_powder
    display name: <&d>Charon Mythic Fragment<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>A shard of divine energy
    - <&7>from Charon's underworld realm.
    - <empty>
    - <&e>Right-click to view recipe.
    - <empty>
    - <&8>Crafting ingredient
    - <&8>Stackable & tradeable
    - <empty>
    - <&d><&l>MYTHIC FRAGMENT

# ============================================
# COMPONENT ITEMS
# ============================================

debris_component:
    type: item
    material: ancient_debris
    display name: <&6>Debris Component<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>Symbol of 500 ancient debris offered.
    - <&7>Required for Charon's Emblem.
    - <empty>
    - <&8><&o>Obtained: <player.flag[charon.component.debris_date].if_null[Unknown]>
    - <empty>
    - <&6><&l>LEGENDARY COMPONENT

wither_component:
    type: item
    material: wither_skeleton_skull
    display name: <&6>Wither Component<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>Symbol of 1,500 wither forces slain.
    - <&7>Required for Charon's Emblem.
    - <empty>
    - <&8><&o>Obtained: <player.flag[charon.component.withers_date].if_null[Unknown]>
    - <empty>
    - <&6><&l>LEGENDARY COMPONENT

barter_component:
    type: item
    material: gold_ingot
    display name: <&6>Barter Component<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>Symbol of 2,500 piglin barters.
    - <&7>Required for Charon's Emblem.
    - <empty>
    - <&8><&o>Obtained: <player.flag[charon.component.barters_date].if_null[Unknown]>
    - <empty>
    - <&6><&l>LEGENDARY COMPONENT
