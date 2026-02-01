# ============================================
# MINING SKILL XP SYSTEM
# ============================================
#
# XP-based progression with 5 ranks
# Progress only counts while MINING role is active
#
# Rank Requirements:
#   Acolyte:  1,000 XP    → +5% ore XP
#   Disciple: 3,500 XP    → +10% ore XP, Haste I
#   Hero:     9,750 XP    → +15% ore XP, Haste I
#   Champion: 25,375 XP   → +20% ore XP, Haste I
#   Legend:   64,438 XP   → +25% ore XP, Haste II
#

# ============================================
# RANK DATA
# ============================================

mining_rank_data:
    type: data
    ranks:
        1:
            name: Acolyte of the Forge
            xp_required: 1000
            xp_total: 1000
            haste_amplifier: -1
            ore_xp_bonus: 5
            key_reward: 5
        2:
            name: Disciple of the Forge
            xp_required: 2500
            xp_total: 3500
            haste_amplifier: 0
            ore_xp_bonus: 10
            key_reward: 5
        3:
            name: Hero of the Forge
            xp_required: 6250
            xp_total: 9750
            haste_amplifier: 0
            ore_xp_bonus: 15
            key_reward: 5
        4:
            name: Champion of the Forge
            xp_required: 15625
            xp_total: 25375
            haste_amplifier: 0
            ore_xp_bonus: 20
            key_reward: 5
        5:
            name: Legend of the Forge
            xp_required: 39063
            xp_total: 64438
            haste_amplifier: 1
            ore_xp_bonus: 25
            key_reward: 10

# ============================================
# PROCEDURES
# ============================================

# Award mining XP to player (centralized handler)
award_mining_xp:
    type: task
    debug: false
    definitions: player|amount|source
    script:
    # Role gate - only MINING role gains XP
    - if <[player].flag[role.active]> != MINING:
        - determine false

    # Award XP
    - flag <[player]> mining.xp:+:<[amount]>
    - define total_xp <[player].flag[mining.xp]>

    # Show action bar notification
    - define source_display <[source].to_titlecase.replace[_].with[ ]>
    - actionbar "<&7>+<[amount]> Mining XP <&8>| <&f><[source_display]>" targets:<[player]>

    # Check for rank-up
    - define old_rank <[player].flag[mining.rank].if_null[0]>
    - define new_rank <proc[get_mining_rank].context[<[total_xp]>]>

    - if <[new_rank]> > <[old_rank]>:
        - flag <[player]> mining.rank:<[new_rank]>
        - run mining_rank_up_ceremony def.player:<[player]> def.rank:<[new_rank]>

    - determine true

# Get player's current rank (1-5) based on total XP
get_mining_rank:
    type: procedure
    debug: false
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
get_mining_rank_name:
    type: procedure
    debug: false
    definitions: rank
    script:
    - choose <[rank]>:
        - case 1:
            - determine "Acolyte of the Forge"
        - case 2:
            - determine "Disciple of the Forge"
        - case 3:
            - determine "Hero of the Forge"
        - case 4:
            - determine "Champion of the Forge"
        - case 5:
            - determine "Legend of the Forge"
        - default:
            - determine "Unranked"

# Get rank data for a rank level
get_mining_rank_data:
    type: procedure
    debug: false
    definitions: rank
    script:
    - if <[rank]> >= 1 && <[rank]> <= 5:
        - determine <script[mining_rank_data].data_key[ranks.<[rank]>]>
    - else:
        - determine <map[xp_total=1000]>

# Get haste amplifier for rank (-1 = no haste, 0 = Haste I, 1 = Haste II)
get_mining_haste_bonus:
    type: procedure
    debug: false
    definitions: rank
    script:
    - choose <[rank]>:
        - case 2 3 4:
            - determine 0
        - case 5:
            - determine 1
        - default:
            - determine -1

# Get ore XP bonus for rank (percentage)
get_ore_xp_bonus:
    type: procedure
    debug: false
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

mining_rank_up_ceremony:
    type: task
    debug: false
    definitions: player|rank
    script:
    - define rank_name <proc[get_mining_rank_name].context[<[rank]>]>
    - define rank_data <script[mining_rank_data].data_key[ranks.<[rank]>]>
    - define key_reward <[rank_data].get[key_reward]>

    # Play effects
    - playeffect effect:LAVA at:<[player].location> quantity:50 offset:1,2,1
    - playeffect effect:SMOKE_NORMAL at:<[player].location> quantity:30 offset:0.5,1,0.5
    - playsound <[player]> sound:UI_TOAST_CHALLENGE_COMPLETE volume:1 pitch:1

    # Title announcement
    - title title:<&8><&l>MINING<&sp>RANK<&sp>UP! subtitle:<&f><[rank_name]> targets:<[player]> fade_in:10t stay:70t fade_out:20t

    # Chat message
    - narrate "<&7>━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" targets:<[player]>
    - narrate "<&f><&l>⚒ MINING RANK ACHIEVED ⚒" targets:<[player]>
    - narrate "<&8>You have become<&co> <&7><[rank_name]>" targets:<[player]>
    - narrate "" targets:<[player]>

    # Show rewards
    - define haste <proc[get_mining_haste_bonus].context[<[rank]>]>
    - define ore_bonus <proc[get_ore_xp_bonus].context[<[rank]>]>

    - narrate "<&b>Rewards Unlocked:" targets:<[player]>
    - if <[ore_bonus]> > 0:
        - narrate "<&8>• <&f>Ore XP Bonus: <&7>+<[ore_bonus]>%" targets:<[player]>
    - if <[haste]> >= 0:
        - narrate "<&8>• <&f>Mining Speed: <&7>Haste <[haste].add[1]>" targets:<[player]>
    - narrate "<&8>• <&f>Rank Reward: <&7><[key_reward]> Hephaestus Keys" targets:<[player]>

    - narrate "<&7>━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" targets:<[player]>

    # Award keys
    - give hephaestus_key quantity:<[key_reward]> player:<[player]>

    # Server-wide announcement
    - announce "<&e>[Promachos]<&r> <&f><[player].name> <&8>has achieved <&7><[rank_name]><&8>!"

# ============================================
# RANK BONUS HANDLERS
# ============================================

# Apply mining haste when breaking ores (for ranked players)
mining_haste_buff:
    type: world
    debug: false
    events:
        after player breaks coal_ore|deepslate_coal_ore|copper_ore|deepslate_copper_ore|iron_ore|deepslate_iron_ore|gold_ore|deepslate_gold_ore|nether_gold_ore|lapis_ore|deepslate_lapis_ore|redstone_ore|deepslate_redstone_ore|diamond_ore|deepslate_diamond_ore|emerald_ore|deepslate_emerald_ore|nether_quartz_ore|ancient_debris:
        # Role gate
        - if <player.flag[role.active].if_null[NONE]> != MINING:
            - stop

        # Get rank and apply haste if qualified
        - define rank <player.flag[mining.rank].if_null[0]>
        - if <[rank]> >= 2:
            - define haste_amp <proc[get_mining_haste_bonus].context[<[rank]>]>
            - if <[haste_amp]> >= 0:
                - cast haste <player> duration:5s amplifier:<[haste_amp]> no_icon hide_particles

# Apply extra vanilla XP from ores (for ranked players)
mining_ore_xp_bonus:
    type: world
    debug: false
    events:
        on player breaks coal_ore|deepslate_coal_ore|copper_ore|deepslate_copper_ore|iron_ore|deepslate_iron_ore|gold_ore|deepslate_gold_ore|nether_gold_ore|lapis_ore|deepslate_lapis_ore|redstone_ore|deepslate_redstone_ore|diamond_ore|deepslate_diamond_ore|emerald_ore|deepslate_emerald_ore|nether_quartz_ore|ancient_debris:
        # Role gate
        - if <player.flag[role.active].if_null[NONE]> != MINING:
            - stop

        # Get rank and calculate bonus
        - define rank <player.flag[mining.rank].if_null[0]>
        - if <[rank]> > 0:
            - define bonus_percent <proc[get_ore_xp_bonus].context[<[rank]>]>
            # Get base XP the ore drops
            - define base_xp <context.xp.if_null[0]>
            - if <[base_xp]> > 0:
                - define bonus_xp <[base_xp].mul[<[bonus_percent]>].div[100].round>
                - if <[bonus_xp]> > 0:
                    - determine <context.xp.add[<[bonus_xp]>]>
