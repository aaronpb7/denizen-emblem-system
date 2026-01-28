# ============================================
# FARMING SKILL XP SYSTEM
# ============================================
#
# XP-based progression with 5 ranks
# Progress only counts while FARMING role is active
#
# Rank Requirements:
#   Acolyte:  1,000 XP    → +5% crops
#   Disciple: 3,500 XP    → +10% crops, Speed I
#   Hero:     9,750 XP    → +15% crops, Speed I
#   Champion: 25,375 XP   → +20% crops, Speed I
#   Legend:   64,438 XP   → +25% crops, Speed II
#

# ============================================
# RANK DATA
# ============================================

farming_rank_data:
    type: data
    ranks:
        1:
            name: Acolyte of the Farm
            xp_required: 1000
            xp_total: 1000
            haste_amplifier: -1
            extra_crop_chance: 5
            key_reward: 5
        2:
            name: Disciple of the Farm
            xp_required: 2500
            xp_total: 3500
            haste_amplifier: 0
            extra_crop_chance: 10
            key_reward: 5
        3:
            name: Hero of the Farm
            xp_required: 6250
            xp_total: 9750
            haste_amplifier: 0
            extra_crop_chance: 15
            key_reward: 5
        4:
            name: Champion of the Farm
            xp_required: 15625
            xp_total: 25375
            haste_amplifier: 0
            extra_crop_chance: 20
            key_reward: 5
        5:
            name: Legend of the Farm
            xp_required: 39063
            xp_total: 64438
            haste_amplifier: 1
            extra_crop_chance: 25
            key_reward: 10

# ============================================
# XP AWARD RATES
# ============================================

farming_xp_rates:
    type: data
    # Crop harvesting (fully grown only)
    crops:
        wheat: 2
        carrots: 2
        potatoes: 2
        beetroots: 2
        nether_wart: 3
        cocoa: 1
        pumpkin: 5
        melon: 5
        sugar_cane: 1
        cactus: 1
        kelp: 1
        bamboo: 1
    # Animal breeding
    animals:
        cow: 10
        sheep: 10
        pig: 10
        chicken: 6
        rabbit: 8
        horse: 30
        llama: 12
        bee: 8
        turtle: 20
        hoglin: 12
    # Food crafting
    foods:
        bread: 3
        cookie: 4
        cake: 12
        pumpkin_pie: 10
        mushroom_stew: 5
        rabbit_stew: 15
        beetroot_soup: 6
        honey_bottle: 3
        suspicious_stew: 8

# ============================================
# PROCEDURES
# ============================================

# Award farming XP to player (centralized handler)
award_farming_xp:
    type: procedure
    definitions: player|amount|source
    script:
    # Role gate - only FARMING role gains XP
    - if <[player].flag[role.active]> != FARMING:
        - determine false

    # Award XP
    - flag <[player]> farming.xp:+:<[amount]>
    - define total_xp <[player].flag[farming.xp]>

    # Show action bar notification
    - define source_display <[source].to_titlecase.replace[_].with[ ]>
    - actionbar "<&6>+<[amount]> Farming XP <&8>| <&7><[source_display]>" targets:<[player]>

    # Check for rank-up
    - define old_rank <[player].flag[farming.rank].if_null[0]>
    - define new_rank <proc[get_farming_rank].context[<[total_xp]>]>

    - if <[new_rank]> > <[old_rank]>:
        - flag <[player]> farming.rank:<[new_rank]>
        - run farming_rank_up_ceremony def.player:<[player]> def.rank:<[new_rank]>

    - determine true

# Get player's current rank (1-5) based on total XP
get_farming_rank:
    type: procedure
    definitions: total_xp
    script:
    - if <[total_xp]> >= 64438:
        - determine 5
    - else if <[total_xp]> >= 25375:
        - determine 4
    - else if <[total_xp]> >= 9750:
        - determine 3
    - else if <[total_xp]> >= 3500:
        - determine 2
    - else if <[total_xp]> >= 1000:
        - determine 1
    - determine 0

# Get display name for a rank level
get_farming_rank_name:
    type: procedure
    definitions: rank
    script:
    - choose <[rank]>:
        - case 1:
            - determine "Acolyte of the Farm"
        - case 2:
            - determine "Disciple of the Farm"
        - case 3:
            - determine "Hero of the Farm"
        - case 4:
            - determine "Champion of the Farm"
        - case 5:
            - determine "Legend of the Farm"
        - default:
            - determine "Unranked"

# Get haste amplifier for rank (-1 = no haste, 0 = Speed I, 1 = Speed II)
get_farming_speed_bonus:
    type: procedure
    definitions: rank
    script:
    - choose <[rank]>:
        - case 2 3 4:
            - determine 0
        - case 5:
            - determine 1
        - default:
            - determine -1

# Get extra crop drop chance for rank (percentage)
get_extra_crop_chance:
    type: procedure
    definitions: rank
    script:
    - choose <[rank]>:
        - case 1:
            - determine 5
        - case 2:
            - determine 10
        - case 3:
            - determine 15
        - case 4:
            - determine 20
        - case 5:
            - determine 25
        - default:
            - determine 0

# ============================================
# RANK-UP CEREMONY
# ============================================

farming_rank_up_ceremony:
    type: task
    definitions: player|rank
    script:
    - define rank_name <proc[get_farming_rank_name].context[<[rank]>]>
    - define rank_data <script[farming_rank_data].data_key[ranks.<[rank]>]>
    - define key_reward <[rank_data].get[key_reward]>

    # Play effects
    - playeffect effect:VILLAGER_HAPPY at:<[player].location> quantity:50 offset:1,2,1
    - playeffect effect:COMPOSTER at:<[player].location> quantity:30 offset:0.5,1,0.5
    - playsound <[player]> sound:UI_TOAST_CHALLENGE_COMPLETE volume:1 pitch:1

    # Title announcement
    - title title:<&6><&l>FARMING<&sp>RANK<&sp>UP! subtitle:<&e><[rank_name]> targets:<[player]> fade_in:10t stay:70t fade_out:20t

    # Chat message
    - narrate "<&6>━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" targets:<[player]>
    - narrate "<&e><&l>⚜ FARMING RANK ACHIEVED ⚜" targets:<[player]>
    - narrate "<&7>You have become<&co> <&6><[rank_name]>" targets:<[player]>
    - narrate "" targets:<[player]>

    # Show rewards
    - define haste <proc[get_farming_speed_bonus].context[<[rank]>]>
    - define crops <proc[get_extra_crop_chance].context[<[rank]>]>

    - narrate "<&b>Rewards Unlocked:" targets:<[player]>
    - if <[crops]> > 0:
        - narrate "<&7>• <&f>Extra Crop Chance: <&e>+<[crops]>%" targets:<[player]>
    - if <[haste]> >= 0:
        - narrate "<&7>• <&f>Farming Speed: <&e>Speed <[haste].add[1]>" targets:<[player]>
    - narrate "<&7>• <&f>Rank Reward: <&e><[key_reward]> Demeter Keys" targets:<[player]>

    - narrate "<&6>━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" targets:<[player]>

    # Award keys
    - give demeter_key quantity:<[key_reward]>

    # Server-wide announcement
    - announce "<&e>[Promachos]<&r> <&f><[player].name> <&7>has achieved <&6><[rank_name]><&7>!"

# ============================================
# RANK BONUS HANDLERS
# ============================================

# Apply farming speed when breaking crops (for ranked players)
farming_speed_buff:
    type: world
    debug: false
    events:
        after player breaks wheat|carrots|potatoes|beetroots|nether_wart|cocoa|pumpkin|melon:
        # Role gate
        - if <player.flag[role.active]> != FARMING:
            - stop

        # Get rank and apply speed if qualified
        - define rank <player.flag[farming.rank].if_null[0]>
        - if <[rank]> >= 2:
            - define speed_amp <proc[get_farming_speed_bonus].context[<[rank]>]>
            - if <[speed_amp]> >= 0:
                - cast speed <player> duration:5s amplifier:<[speed_amp]> no_icon hide_particles

# Apply extra crop drops on wheat harvest (for ranked players)
farming_extra_crops:
    type: world
    debug: false
    events:
        after player breaks wheat:
        # Role gate
        - if <player.flag[role.active]> != FARMING:
            - stop

        # Only fully grown wheat
        - if <context.material.age> != 7:
            - stop

        # Get rank and apply extra crop chance
        - define rank <player.flag[farming.rank].if_null[0]>
        - if <[rank]> > 0:
            - define extra_chance <proc[get_extra_crop_chance].context[<[rank]>]>
            - if <util.random.int[1].to[100]> <= <[extra_chance]>:
                - drop wheat quantity:1 <context.location>
                - playeffect effect:HAPPY_VILLAGER at:<context.location.add[0.5,0.5,0.5]> quantity:5 offset:0.3
