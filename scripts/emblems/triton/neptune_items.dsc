# ============================================
# NEPTUNE ITEMS
# ============================================
#
# Neptune meta-progression items:
# - Neptune Key (opens Neptune crate, 50/50 god apple vs unique item)
# - Head of Triton (decorative god head)
# - Neptune Shulker (cyan shulker box)
# - Neptune Trident Blueprint (Mythic Forge recipe)
# - Neptune Trident (mythic trident, crafted via Mythic Forge)
#

# ============================================
# NEPTUNE KEY
# ============================================

neptune_key:
    type: item
    material: nether_star
    display name: <&b>Neptune Key<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>A key forged in the Roman vault,
    - <&7>where Neptune guards his most
    - <&7>precious and finite treasures.
    - <empty>
    - <&e>Right-click to unlock
    - <&e>a Neptune Crate.
    - <empty>
    - <&8>50% God Apple / 50% Unique Item
    - <empty>
    - <&b><&l><&k>|||<&r> <&b><&l>OLYMPIAN KEY<&r> <&b><&l><&k>|||

# ============================================
# HEAD OF TRITON (TROPHY)
# ============================================

triton_head:
    type: item
    material: player_head
    mechanisms:
        skull_skin: aa869790-efe7-461d-aa47-49f2956b039c|ewogICJ0aW1lc3RhbXAiIDogMTY1OTIwNzg2Mzg3MiwKICAicHJvZmlsZUlkIiA6ICJlNGY1NWQzMzBjZmU0NzExYWNkMzNlYmNiMmU1YTc0ZCIsCiAgInByb2ZpbGVOYW1lIiA6ICJKMG9iaSIsCiAgInNpZ25hdHVyZVJlcXVpcmVkIiA6IHRydWUsCiAgInRleHR1cmVzIiA6IHsKICAgICJTS0lOIiA6IHsKICAgICAgInVybCIgOiAiaHR0cDovL3RleHR1cmVzLm1pbmVjcmFmdC5uZXQvdGV4dHVyZS83N2Q0OTBiMDVkYmE2Nzc4OTU1ZDZmMzUzNDA0YzZiNjIyZGUxNDUyYWI5N2MzY2E5OTRlOWNlNGEzNjc4MzIxIiwKICAgICAgIm1ldGFkYXRhIiA6IHsKICAgICAgICAibW9kZWwiIDogInNsaW0iCiAgICAgIH0KICAgIH0KICB9Cn0=
    display name: <&b>Head of Triton<&r>
    lore:
    - <&7>A divine effigy of Triton,
    - <&7>god of the sea.
    - <empty>
    - <&e>Right-click to pick up.
    - <empty>
    - <&8>Unique - One per player
    - <empty>
    - <&b><&l><&k>|||<&r> <&b><&l>OLYMPIAN TROPHY<&r> <&b><&l><&k>|||

# ============================================
# NEPTUNE SHULKER
# ============================================
#
# Standard cyan shulker box - no special mechanics
# Just a rare/unique collectible from Neptune crate
# Flag: neptune.item.shulker: true (tracked but no special behavior)
# Given as raw material: cyan_shulker_box (no item script)
#

# ============================================
# NEPTUNE TRIDENT BLUEPRINT
# ============================================

neptune_trident_blueprint:
    type: item
    material: map
    display name: <&b>Neptune Trident Blueprint<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>Ancient schematics detailing
    - <&7>the construction of Neptune's Trident.
    - <empty>
    - <&e>Right-click to view recipe.
    - <empty>
    - <&b><&l><&k>|||<&r> <&b><&l>OLYMPIAN BLUEPRINT<&r> <&b><&l><&k>|||

# ============================================
# NEPTUNE TRIDENT (MYTHIC WEAPON)
# ============================================

neptune_trident:
    type: item
    material: trident
    display name: <&b>Neptune's Trident<&r>
    enchantments:
    - riptide:4
    mechanisms:
        unbreakable: true
    lore:
    - <&7>A trident forged by Neptune,
    - <&7>ruler of all seas. It commands
    - <&7>the tides and storms.
    - <empty>
    - <&e>Riptide IV
    - <empty>
    - <&8>Unbreakable
    - <&8>Unique - One per player
    - <empty>
    - <&b><&l><&k>|||<&r> <&b><&l>OLYMPIAN TRIDENT<&r> <&b><&l><&k>|||
