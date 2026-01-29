# ============================================
# MARS CUSTOM ITEMS
# ============================================
#
# Unique items from Mars crate (meta-progression):
# - Mars Sword (lifesteal mechanic)
# - Mars Title (flag-based chat prefix unlock)
# - Gray Shulker Box (standard utility)
# - Mars Shield (active resistance buff)
#

# ============================================
# MARS SWORD (MYTHIC)
# ============================================

mars_sword:
    type: item
    material: netherite_sword
    display name: <&b>Mars Sword<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
        unbreakable: true
    lore:
    - <&7>A netherite blade blessed by
    - <&7>Mars, unbreakable and vampiric.
    - <empty>
    - <&e>Heals 10% of damage dealt.
    - <empty>
    - <&8>Unbreakable
    - <&8>Unique - One per player
    - <empty>
    - <&b><&l><&k>|||<&r> <&b><&l>OLYMPIAN SWORD<&r> <&b><&l><&k>|||

mars_sword_lifesteal:
    type: world
    debug: false
    events:
        after player damages entity with:mars_sword:
        # Calculate heal amount (10% of damage)
        - define heal <context.damage.mul[0.10]>

        # Heal player
        - heal <player> <[heal]>

        # Visual feedback
        - playeffect effect:heart at:<player.eye_location> quantity:3 offset:0.5

# ============================================
# MARS TITLE (COSMETIC)
# ============================================
#
# Not a physical item - this is a flag-based unlock
# Flag: mars.item.title: true
# Title Text: <&4>[Mars' Chosen]<&r>
#
# Awarded directly from Mars crate (sets flag)
# Chat integration handled in cosmetics system
#

# ============================================
# GRAY SHULKER BOX (UTILITY)
# ============================================
#
# Standard gray shulker box - no special mechanics
# Just a rare/unique collectible from Mars crate
# Flag: mars.item.shulker: true (tracked but no special behavior)
#

# ============================================
# MARS SHIELD (LEGENDARY)
# ============================================

mars_shield:
    type: item
    material: shield
    display name: <&b>Mars Shield<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
        unbreakable: true
    lore:
    - <&7>A shield blessed by Mars,
    - <&7>granting divine protection.
    - <empty>
    - <&e>Right-click to activate
    - <&e>Resistance I for 15 seconds.
    - <empty>
    - <&8>Cooldown: 3 minutes
    - <&8>Unbreakable
    - <&8>Unique - One per player
    - <empty>
    - <&b><&l><&k>|||<&r> <&b><&l>OLYMPIAN SHIELD<&r> <&b><&l><&k>|||

mars_shield_activate:
    type: world
    debug: false
    events:
        on player raises mars_shield:
        # Check cooldown (silently - shield still works normally)
        - if <player.has_flag[mars.shield_cooldown]>:
            - stop

        # Set cooldown (3 minutes = 180 seconds)
        - flag player mars.shield_cooldown expire:180s

        # Grant Resistance I for 15 seconds
        - cast resistance duration:15s amplifier:0 <player> no_icon no_ambient

        # Feedback
        - narrate "<&e>Mars' divine protection activated!"
        - playsound <player> sound:block_beacon_activate volume:1.0 pitch:1.2
        - playeffect effect:flame at:<player.location> quantity:30 offset:1.0

        # Action bar display
        - actionbar "<&4>MARS' PROTECTION <&7>- <&c>Resistance I for 15 seconds"
