# ============================================
# DEMETER RANKING SYSTEM
# ============================================
#
# Tiered ranks earned by reaching cumulative wheat/cow thresholds (BOTH required)
# Unlocks passive farming bonuses: haste, extra crops, twin breeding
#
# Rank Requirements:
#   Acolyte:  2,500 wheat + 50 cows   → Haste I, +5% crops
#   Disciple: 12,000 wheat + 300 cows → Haste II, +20% crops, 10% twins
#   Hero:     50,000 wheat + 700 cows → Haste II, +50% crops, 30% twins
#

# ============================================
# RANK DATA
# ============================================

demeter_rank_data:
    type: data
    ranks:
        1:
            name: Acolyte of Demeter
            wheat: 2500
            cows: 50
            haste_amplifier: 0
            extra_crop_chance: 5
            twin_breeding_chance: 0
        2:
            name: Disciple of Demeter
            wheat: 12000
            cows: 300
            haste_amplifier: 1
            extra_crop_chance: 20
            twin_breeding_chance: 10
        3:
            name: Hero of Demeter
            wheat: 50000
            cows: 700
            haste_amplifier: 1
            extra_crop_chance: 50
            twin_breeding_chance: 30

# ============================================
# PROCEDURES
# ============================================

# Get player's current rank level (0-3) based on counters
get_demeter_rank:
    type: procedure
    definitions: player
    script:
    - define wheat <[player].flag[demeter.wheat.count].if_null[0]>
    - define cows <[player].flag[demeter.cows.count].if_null[0]>
    - define rank 0
    # Check each rank tier (highest first)
    - if <[wheat]> >= 50000 && <[cows]> >= 700:
        - determine 3
    - else if <[wheat]> >= 12000 && <[cows]> >= 300:
        - determine 2
    - else if <[wheat]> >= 2500 && <[cows]> >= 50:
        - determine 1
    - determine 0

# Get display name for a rank level
get_demeter_rank_name:
    type: procedure
    definitions: rank
    script:
    - choose <[rank]>:
        - case 1:
            - determine "Acolyte of Demeter"
        - case 2:
            - determine "Disciple of Demeter"
        - case 3:
            - determine "Hero of Demeter"
        - default:
            - determine "Unranked"

# Get haste amplifier for rank (-1 = no haste)
get_farming_speed_bonus:
    type: procedure
    definitions: rank
    script:
    - choose <[rank]>:
        - case 1:
            - determine 0
        - case 2 3:
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
            - determine 20
        - case 3:
            - determine 50
        - default:
            - determine 0

# Get twin breeding chance for rank (percentage)
get_twin_breeding_chance:
    type: procedure
    definitions: rank
    script:
    - choose <[rank]>:
        - case 2:
            - determine 10
        - case 3:
            - determine 30
        - default:
            - determine 0

# ============================================
# RANK CHECK TASK
# ============================================

# Called after wheat/cow count updates to check for rank-up
demeter_check_rank:
    type: task
    definitions: player
    script:
    - define current_rank <[player].flag[demeter.rank].if_null[0]>
    - define new_rank <proc[get_demeter_rank].context[<[player]>]>
    # Only trigger rank-up if rank increased
    - if <[new_rank]> > <[current_rank]>:
        - flag <[player]> demeter.rank:<[new_rank]>
        - run demeter_rank_up_ceremony def.player:<[player]> def.rank:<[new_rank]>

# ============================================
# RANK-UP CEREMONY
# ============================================

demeter_rank_up_ceremony:
    type: task
    definitions: player|rank
    script:
    - define rank_name <proc[get_demeter_rank_name].context[<[rank]>]>
    # Play effects
    - playeffect effect:VILLAGER_HAPPY at:<[player].location> quantity:50 offset:1,2,1
    - playeffect effect:COMPOSTER at:<[player].location> quantity:30 offset:0.5,1,0.5
    - playsound <[player]> sound:UI_TOAST_CHALLENGE_COMPLETE volume:1 pitch:1
    # Title announcement
    - title title:<&6><&l>RANK<&sp>UP! subtitle:<&a><[rank_name]> targets:<[player]> fade_in:10t stay:70t fade_out:20t
    # Chat message
    - narrate "<&6>━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" targets:<[player]>
    - narrate "<&e><&l>⚜ DEMETER RANK ACHIEVED ⚜" targets:<[player]>
    - narrate "<&a>You have become: <&f><[rank_name]>" targets:<[player]>
    - narrate "" targets:<[player]>
    # Show rewards based on rank
    - define haste <proc[get_farming_speed_bonus].context[<[rank]>]>
    - define crops <proc[get_extra_crop_chance].context[<[rank]>]>
    - define twins <proc[get_twin_breeding_chance].context[<[rank]>]>
    - narrate "<&b>Rewards Unlocked:" targets:<[player]>
    - if <[haste]> >= 0:
        - narrate "<&7>• <&f>Farming Speed: <&a>Haste <[haste].add[1]>" targets:<[player]>
    - if <[crops]> > 0:
        - narrate "<&7>• <&f>Extra Crop Chance: <&a>+<[crops]>%" targets:<[player]>
    - if <[twins]> > 0:
        - narrate "<&7>• <&f>Twin Breeding Chance: <&a><[twins]>%" targets:<[player]>
    - narrate "<&6>━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" targets:<[player]>
    # Server-wide announcement
    - announce "<&e>[Promachos]<&r> <&f><[player].name> <&7>has achieved the rank of <&a><[rank_name]><&7>!"

# ============================================
# RANK BONUS HANDLERS
# ============================================

# Apply farming haste when breaking crops (for ranked players)
demeter_farming_haste:
    type: world
    debug: false
    events:
        after player breaks wheat|carrots|potatoes|beetroots|nether_wart|cocoa:
        # Role gate
        - if <player.flag[role.active]> != FARMING:
            - stop
        # Get rank and apply haste if qualified
        - define rank <player.flag[demeter.rank].if_null[0]>
        - if <[rank]> > 0:
            - define haste_amp <proc[get_farming_speed_bonus].context[<[rank]>]>
            - if <[haste_amp]> >= 0:
                - cast haste <player> duration:5s amplifier:<[haste_amp]> no_icon hide_particles

# Apply extra crop drops on wheat harvest (for ranked players)
demeter_extra_crops:
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
        - define rank <player.flag[demeter.rank].if_null[0]>
        - if <[rank]> > 0:
            - define extra_chance <proc[get_extra_crop_chance].context[<[rank]>]>
            - if <util.random.int[1].to[100]> <= <[extra_chance]>:
                - drop wheat quantity:1 <context.location>
                - playeffect effect:HAPPY_VILLAGER at:<context.location.add[0.5,0.5,0.5]> quantity:5 offset:0.3

# Apply twin breeding chance on cow breeding (for ranked players)
demeter_twin_breeding:
    type: world
    debug: false
    events:
        after cow breeds:
        - define breeder <context.breeder>
        - if <[breeder]> == null || !<[breeder].is_player>:
            - stop
        # Role gate
        - if <[breeder].flag[role.active]> != FARMING:
            - stop
        # Get rank and apply twin breeding chance (Disciple+ only)
        - define rank <[breeder].flag[demeter.rank].if_null[0]>
        - if <[rank]> >= 2:
            - define twin_chance <proc[get_twin_breeding_chance].context[<[rank]>]>
            - if <util.random.int[1].to[100]> <= <[twin_chance]>:
                # Spawn twin baby cow
                - define parent <context.mother>
                - spawn cow <[parent].location> save:twin
                - adjust <entry[twin].spawned_entity> age:-24000
                # Effects for twin birth
                - playeffect effect:HEART at:<[parent].location.add[0,1,0]> quantity:10 offset:0.5
                - playsound <[breeder]> sound:ENTITY_COW_AMBIENT volume:1 pitch:1.5
                - narrate "<&a>✦ <&e>Demeter's blessing grants twin calves! <&a>✦" targets:<[breeder]>
