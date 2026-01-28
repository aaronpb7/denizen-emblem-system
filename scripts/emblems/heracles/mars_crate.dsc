# ============================================
# MARS CRATE - Meta-Progression
# ============================================
#
# Mars crate opening system (META - COMBAT):
# - Roman god of war (meta-progression for combat)
# - 1% drop from Heracles OLYMPIAN tier
# - 50% chance: High-tier combat reward
# - 50% chance: Unique item from finite pool (4 items total)
# - Once all 4 items obtained → always high-tier reward
#
# STATUS: PLACEHOLDER - NOT YET IMPLEMENTED
# TODO: Implement following Ceres crate pattern

# Placeholder key item
mars_key:
    type: item
    material: nether_star
    display name: <&4><&l>Mars Key
    lore:
    - <&7>Unlocks the <&4>Arena of Champions
    - <&c><&l>ULTRA RARE
    - ""
    - <&7>Meta-progression for combat
    - ""
    - <&c><&o>Not yet implemented

# Placeholder usage event
mars_key_usage:
    type: world
    debug: false
    events:
        on player right clicks block with:mars_key:
        - determine cancelled passively
        - narrate "<&4>Mars Arena coming soon!"
        - playsound <player> sound:entity_villager_no

# TODO: Implement following Ceres crate pattern:
# - mars_crate_animation task with scrolling between reward and mystery
# - roll_mars_outcome procedure (50/50 split)
# - Finite pool: mars_sword, mars_title, mars_shield, mars_banner
# - Dark red/crimson color theme for border (matching Heracles)
# - Award flags: mars.item.* for tracking unlocks
