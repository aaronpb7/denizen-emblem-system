# ============================================
# DIS ITEMS
# ============================================
#
# Dis meta-progression items:
# - Dis Key (opens Dis crate, 50/50 god apple vs unique item)
# - Head of Charon (decorative god head)
# - Dis Shulker (purple shulker box)
# - Dis Fire Charm Blueprint (Mythic Forge recipe)
# - Dis Fire Charm (mythic charm, crafted via Mythic Forge)
#

# ============================================
# DIS KEY
# ============================================

dis_key:
    type: item
    material: nether_star
    display name: <&5>Dis Key<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>A key forged in the Roman vault,
    - <&7>where Dis guards his most
    - <&7>precious and finite treasures.
    - <empty>
    - <&e>Right-click to unlock
    - <&e>a Dis Crate.
    - <empty>
    - <&8>50% God Apple / 50% Unique Item
    - <empty>
    - <&5><&l><&k>|||<&r> <&5><&l>OLYMPIAN KEY<&r> <&5><&l><&k>|||

# ============================================
# HEAD OF CHARON (TROPHY)
# ============================================

charon_head:
    type: item
    material: player_head
    mechanisms:
        skull_skin: 33fc5c15-4d09-44ad-835e-84f2097860ab|ewogICJ0aW1lc3RhbXAiIDogMTY4NDgzMTAzMjMwMCwKICAicHJvZmlsZUlkIiA6ICIzOTg5OGFiODFmMjU0NmQxOGIyY2ExMTE1MDRkZGU1MCIsCiAgInByb2ZpbGVOYW1lIiA6ICI4YjJjYTExMTUwNGRkZTUwIiwKICAic2lnbmF0dXJlUmVxdWlyZWQiIDogdHJ1ZSwKICAidGV4dHVyZXMiIDogewogICAgIlNLSU4iIDogewogICAgICAidXJsIiA6ICJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlL2Y5YWE3ODhlMDgyODI4ODBhNDNmNjUwMjZhNDBhZmRiZGQxMjg0Y2ZiYmE2ODYyNDk3OTQwOTFkM2E1N2MzYjQiCiAgICB9CiAgfQp9
    display name: <&5>Head of Charon<&r>
    lore:
    - <&7>A divine effigy of Charon,
    - <&7>ferryman of the dead.
    - <empty>
    - <&e>Right-click to pick up.
    - <empty>
    - <&8>Unique - One per player
    - <empty>
    - <&5><&l><&k>|||<&r> <&5><&l>OLYMPIAN TROPHY<&r> <&5><&l><&k>|||

# ============================================
# DIS FIRE CHARM BLUEPRINT
# ============================================

dis_fire_charm_blueprint:
    type: item
    material: map
    display name: <&5>Dis Fire Charm Blueprint<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>Ancient schematics detailing
    - <&7>the construction of Dis' Fire Charm.
    - <empty>
    - <&e>Right-click to view recipe.
    - <empty>
    - <&5><&l><&k>|||<&r> <&5><&l>OLYMPIAN BLUEPRINT<&r> <&5><&l><&k>|||

# ============================================
# DIS FIRE CHARM (MYTHIC ITEM)
# ============================================

dis_fire_charm:
    type: item
    material: red_dye
    display name: <&5>Dis Fire Charm<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>A charm infused with the
    - <&7>fires of the underworld,
    - <&7>cold to the touch yet burning
    - <&7>with the memory of the Styx.
    - <empty>
    - <&8>Unique - One per player
    - <empty>
    - <&5><&l><&k>|||<&r> <&5><&l>OLYMPIAN CHARM<&r> <&5><&l><&k>|||
