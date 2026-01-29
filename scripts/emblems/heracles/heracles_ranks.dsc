# ============================================
# COMBAT SKILL XP SYSTEM
# ============================================
#
# XP-based progression with 5 ranks
# Progress only counts while COMBAT role is active
#
# Rank Requirements:
#   Acolyte:  1,000 XP    → Regen I (low health), +5% vanilla XP
#   Disciple: 3,500 XP    → Regen I (low health), +10% vanilla XP
#   Hero:     9,750 XP    → Regen II (low health), +15% vanilla XP
#   Champion: 25,375 XP   → Regen II (low health), +20% vanilla XP
#   Legend:   64,438 XP   → Regen II (low health), +25% vanilla XP
#

# ============================================
# RANK DATA
# ============================================

combat_rank_data:
    type: data
    ranks:
        1:
            name: Acolyte of War
            xp_required: 1000
            xp_total: 1000
            regen_amplifier: 0
            xp_bonus: 5
            key_reward: 5
        2:
            name: Disciple of War
            xp_required: 2500
            xp_total: 3500
            regen_amplifier: 0
            xp_bonus: 10
            key_reward: 5
        3:
            name: Hero of War
            xp_required: 6250
            xp_total: 9750
            regen_amplifier: 1
            xp_bonus: 15
            key_reward: 5
        4:
            name: Champion of War
            xp_required: 15625
            xp_total: 25375
            regen_amplifier: 1
            xp_bonus: 20
            key_reward: 5
        5:
            name: Legend of War
            xp_required: 39063
            xp_total: 64438
            regen_amplifier: 1
            xp_bonus: 25
            key_reward: 10

# ============================================
# XP AWARD RATES
# ============================================

combat_xp_rates:
    type: data
    rates:
        # Hostile mob kills
        mobs:
            # Common (2 XP)
            zombie: 2
            skeleton: 2
            spider: 2
            creeper: 2
            cave_spider: 2
            silverfish: 2
            # Uncommon (5 XP)
            enderman: 5
            witch: 5
            blaze: 5
            ghast: 5
            piglin_brute: 5
            hoglin: 5
            zombified_piglin: 5
            pillager: 5
            # Rare (8 XP)
            vindicator: 8
            evoker: 8
            ravager: 8
            wither_skeleton: 8
            # Elite (15 XP)
            elder_guardian: 15
            guardian: 15
        # Raid completion
        raids:
            1: 50   # Bad Omen I
            2: 75   # Bad Omen II
            3: 100  # Bad Omen III
            4: 150  # Bad Omen IV
            5: 200  # Bad Omen V
        # Trading
        emerald: 1  # Per emerald spent

# ============================================
# HELPER PROCEDURES
# ============================================

get_combat_rank_name:
    type: procedure
    debug: false
    definitions: rank
    script:
    - choose <[rank]>:
        - case 1:
            - determine "Acolyte of War"
        - case 2:
            - determine "Disciple of War"
        - case 3:
            - determine "Hero of War"
        - case 4:
            - determine "Champion of War"
        - case 5:
            - determine "Legend of War"
        - default:
            - determine "Unranked"

get_combat_rank_from_xp:
    type: procedure
    debug: false
    definitions: xp
    script:
    # Return highest rank achieved based on XP
    - if <[xp]> >= 64438:
        - determine 5
    - else if <[xp]> >= 25375:
        - determine 4
    - else if <[xp]> >= 9750:
        - determine 3
    - else if <[xp]> >= 3500:
        - determine 2
    - else if <[xp]> >= 1000:
        - determine 1
    - else:
        - determine 0

# ============================================
# BUFF SYSTEM (PLACEHOLDER)
# ============================================
#
# Buffs to implement:
# 1. Low Health Regeneration
#    - Trigger at <6 HP (3 hearts)
#    - Regen I or II for 5s
#    - 3 min cooldown
#
# 2. Vanilla XP Bonus
#    - Multiply experience orb drops
#    - On mob kill events
#
# TODO: Implement combat_low_health_regen world script
# TODO: Implement combat_xp_bonus world script
