# ============================================
# DEMETER ITEMS
# ============================================
#
# All items for Demeter progression:
# - Demeter Key (crate opener)
# - Demeter Blessing (consumable boost)
# - Demeter Hoe (MYTHIC reward)
# - Component items (optional physical items)
#

# ============================================
# DEMETER KEY
# ============================================

demeter_key:
    type: item
    material: tripwire_hook
    display name: <&6><&l>DEMETER KEY<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&e>HEROIC
    - <empty>
    - <&7>A golden key blessed by
    - <&7>the goddess of harvest.
    - <empty>
    - <&e>Right-click to open a
    - <&e>Demeter Crate.

# ============================================
# DEMETER BLESSING
# ============================================

demeter_blessing:
    type: item
    material: nether_star
    display name: <&d><&l>DEMETER BLESSING<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&d>MYTHIC
    - <empty>
    - <&7>A divine blessing from the
    - <&7>goddess of harvest, imbued
    - <&7>with her abundant grace.
    - <empty>
    - <&e>Right-click to boost progress
    - <&e>on all incomplete Demeter
    - <&e>activities by 10%.
    - <empty>
    - <&8>Single-use consumable
    - <&8>Stackable & tradeable

# ============================================
# DEMETER HOE (MYTHIC REWARD)
# ============================================

demeter_hoe:
    type: item
    material: diamond_hoe
    display name: <&d><&l>DEMETER HOE<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
        unbreakable: true
    lore:
    - <&d>MYTHIC
    - <empty>
    - <&7>A diamond hoe blessed by
    - <&7>Demeter, unbreakable and eternal.
    - <empty>
    - <&8>Unbreakable

# ============================================
# COMPONENT ITEMS (OPTIONAL)
# ============================================
# These can be flags-only or physical items
# Implemented as items for visibility in inventory

wheat_component:
    type: item
    material: wheat
    display name: <&6><&l>Wheat Component<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&6>LEGENDARY
    - <empty>
    - <&7>Symbol of 15,000 wheat harvested.
    - <&7>Required for Demeter's Emblem.
    - <empty>
    - <&8><&o>Obtained: <player.flag[demeter.component.wheat_date].if_null[Unknown]>

cow_component:
    type: item
    material: leather
    display name: <&6><&l>Cow Component<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&6>LEGENDARY
    - <empty>
    - <&7>Symbol of 2,000 cows bred.
    - <&7>Required for Demeter's Emblem.
    - <empty>
    - <&8><&o>Obtained: <player.flag[demeter.component.cow_date].if_null[Unknown]>

cake_component:
    type: item
    material: cake
    display name: <&6><&l>Cake Component<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&6>LEGENDARY
    - <empty>
    - <&7>Symbol of 300 cakes crafted.
    - <&7>Required for Demeter's Emblem.
    - <empty>
    - <&8><&o>Obtained: <player.flag[demeter.component.cake_date].if_null[Unknown]>
