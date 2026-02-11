# ============================================
# TRITON ITEMS
# ============================================
#
# All items for Triton progression:
# - Triton Key (crate opener)
# - Triton Blessing (consumable boost)
# - Triton Mythic Fragment (crafting ingredient)
# - Component items (milestone rewards)
#

# ============================================
# TRITON KEY
# ============================================

triton_key:
    type: item
    material: tripwire_hook
    display name: <&e>Triton Key<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>A coral-encrusted key from
    - <&7>the depths of Triton's domain.
    - <empty>
    - <&e>Right-click to open a
    - <&e>Triton Crate.
    - <empty>
    - <&e><&l>HEROIC KEY

# ============================================
# TRITON BLESSING
# ============================================

triton_blessing:
    type: item
    material: nether_star
    display name: <&d>Triton Blessing<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>A divine blessing from the
    - <&7>god of the sea, imbued with
    - <&7>the ocean's boundless power.
    - <empty>
    - <&e>Right-click to boost progress
    - <&e>on all incomplete Triton
    - <&e>activities by 5%.
    - <empty>
    - <&8>Single-use consumable
    - <&8>Stackable & tradeable
    - <empty>
    - <&d><&l>MYTHIC CONSUMABLE

# ============================================
# TRITON MYTHIC FRAGMENT
# ============================================

triton_mythic_fragment:
    type: item
    material: prismarine_shard
    display name: <&d>Triton Mythic Fragment<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>A shard of divine energy
    - <&7>from Triton's ocean realm.
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

lantern_component:
    type: item
    material: sea_lantern
    display name: <&6>Lantern Component<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>Symbol of 1,000 sea lanterns offered.
    - <&7>Required for Triton's Emblem.
    - <empty>
    - <&8><&o>Obtained: <player.flag[triton.component.lanterns_date].if_null[Unknown]>
    - <empty>
    - <&6><&l>LEGENDARY COMPONENT

guardian_component:
    type: item
    material: prismarine_crystals
    display name: <&6>Guardian Component<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>Symbol of 1,500 guardians vanquished.
    - <&7>Required for Triton's Emblem.
    - <empty>
    - <&8><&o>Obtained: <player.flag[triton.component.guardians_date].if_null[Unknown]>
    - <empty>
    - <&6><&l>LEGENDARY COMPONENT

conduit_component:
    type: item
    material: conduit
    display name: <&6>Conduit Component<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>Symbol of 25 conduits crafted.
    - <&7>Required for Triton's Emblem.
    - <empty>
    - <&8><&o>Obtained: <player.flag[triton.component.conduits_date].if_null[Unknown]>
    - <empty>
    - <&6><&l>LEGENDARY COMPONENT
