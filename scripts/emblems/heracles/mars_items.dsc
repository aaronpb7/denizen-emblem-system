# ============================================
# MARS CUSTOM ITEMS
# ============================================
#
# Unique items from Mars crate (meta-progression):
# - Mars Sword (lifesteal mechanic)
# - Mars Title (flag-based chat prefix unlock)
# - Red Shulker Box (standard utility)
# - Mars Shield (active resistance buff)
# - Head of Heracles (decorative god head, lightning on place)
#

# ============================================
# MARS SWORD (MYTHIC)
# ============================================

mars_sword:
    type: item
    material: netherite_sword
    display name: <&b>Mars Sword<&r>
    mechanisms:
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
# RED SHULKER BOX (UTILITY)
# ============================================
#
# Standard red shulker box - no special mechanics
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
    mechanisms:
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

# ============================================
# MARS SHIELD BLUEPRINT
# ============================================

mars_shield_blueprint:
    type: item
    material: map
    display name: <&b>Mars Shield Blueprint<&r>
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>Battle plans detailing the
    - <&7>forging of Mars' divine shield.
    - <empty>
    - <&e>Right-click to view recipe.
    - <empty>
    - <&b><&l><&k>|||<&r> <&b><&l>OLYMPIAN BLUEPRINT<&r> <&b><&l><&k>|||

mars_shield_activate:
    type: world
    debug: false
    events:
        on player raises mars_shield:
        # Check cooldown (silent fail)
        - if <player.has_flag[mars.shield_cooldown]>:
            - stop

        # Set cooldown (3 minutes = 180 seconds)
        - flag player mars.shield_cooldown expire:180s

        # Grant Resistance I for 15 seconds
        - cast resistance duration:15s amplifier:0 <player> no_icon no_ambient

        # Feedback (action bar only)
        - actionbar "<&4>MARS' PROTECTION <&7>- <&c>Resistance I for 15s"
        - playsound <player> sound:block_beacon_activate volume:1.0 pitch:1.2
        - playeffect effect:flame at:<player.location> quantity:30 offset:1.0

        # Schedule cooldown ready notification
        - run mars_shield_cooldown_notify def.player:<player> delay:180s

mars_shield_cooldown_notify:
    type: task
    debug: false
    definitions: player
    script:
    - if !<[player].is_online>:
        - stop
    - actionbar "<&a>Mars Shield ready!" targets:<[player]>
    - playsound <[player]> sound:block_note_block_chime volume:0.5 pitch:1.5

# ============================================
# HEAD OF HERACLES (TROPHY)
# ============================================

heracles_head:
    type: item
    material: player_head
    mechanisms:
        skull_skin: dd684938-d05e-4dfc-8bb7-1d7f1ff35074|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYTY2YWVlOWMyZWFiNzc3YzA3M2E5MjUwMDQxY2RiNjU5MDJlYWZhZGI5NDdiYTRkNTQxMzg1MTQwMmRiZjIyYyJ9fX0=
    display name: <&b>Head of Heracles<&r>
    lore:
    - <&7>A divine effigy of Heracles,
    - <&7>hero of strength and valor.
    - <empty>
    - <&e>Right-click to pick up.
    - <empty>
    - <&8>Unique - One per player
    - <empty>
    - <&b><&l><&k>|||<&r> <&b><&l>OLYMPIAN TROPHY<&r> <&b><&l><&k>|||
