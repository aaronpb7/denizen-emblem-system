# ============================================
# HEPHAESTUS CRATE - Placeholder
# ============================================
#
# Hephaestus crate opening system (MINING):
# - 5 tiers: MORTAL, HEROIC, LEGENDARY, MYTHIC, OLYMPIAN
# - Rewards: Mining tools, ores, blocks, Hephaestus items
# - MYTHIC tier includes Hephaestus Title unlock
#
# STATUS: PLACEHOLDER - NOT YET IMPLEMENTED
# TODO: Implement full crate system following Demeter crate pattern

# Placeholder key item
hephaestus_key:
    type: item
    material: tripwire_hook
    display name: <&c><&l>Hephaestus Key
    lore:
    - <&7>Unlocks a Hephaestus Crate
    - <&7>Rewards focused on mining
    - ""
    - <&c><&o>Not yet implemented

# Placeholder usage event
hephaestus_key_usage:
    type: world
    debug: false
    events:
        on player right clicks block with:hephaestus_key:
        - determine cancelled passively
        - narrate "<&c>Hephaestus crates coming soon!"
        - playsound <player> sound:entity_villager_no

# TODO: Implement following Demeter crate pattern:
# - hephaestus_crate_animation task with 3-phase scrolling
# - roll_hephaestus_tier procedure
# - roll_hephaestus_loot procedure with 5 tiers
# - MYTHIC loot pool should include hephaestus_title
# - OLYMPIAN tier should award vulcan_key (1% chance)
# - build_loot_display_item procedure
# - Red/orange color theme for border
