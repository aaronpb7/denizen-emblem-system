# ============================================
# HERACLES EVENTS - Activity Tracking & XP
# ============================================
#
# XP-based progression with activity counters for components
# 1. Pillager kills → 2 XP, component at 2,500
# 2. Raid completions → 10 XP, component at 50
# 3. Emerald spending → 1 XP, component at 10,000
#
# All other combat activities also award XP (see combat_xp_rates)
# Only tracks when player role = COMBAT
#

# ============================================
# PILLAGER KILLS
# ============================================

combat_pillager_kills:
    type: world
    debug: false
    events:
        after player kills pillager:
        # Role gate - only COMBAT role counts
        - if <player.flag[role.active].if_null[NONE]> != COMBAT:
            - stop

        # Award XP for pillager kill
        - define xp_amount <script[combat_xp_rates].data_key[rates.mobs.pillager].if_null[5]>
        - if <[xp_amount]> > 0:
            - run award_combat_xp def.player:<player> def.amount:<[xp_amount]> def.source:pillager

        # Track pillagers for component milestone
        - flag player heracles.pillagers.count:++
        - define count <player.flag[heracles.pillagers.count]>

        # Key award logic (every 25)
        - define keys_awarded <player.flag[heracles.pillagers.keys_awarded].if_null[0]>
        - define keys_should_have <[count].div[25].round_down>
        - if <[keys_should_have]> > <[keys_awarded]>:
            - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
            - give heracles_key quantity:<[keys_to_give]>
            - flag player heracles.pillagers.keys_awarded:<[keys_should_have]>
            - narrate "<&c><&l>HERACLES KEY!<&r> <&7>Pillagers: <&a><[count]><&7>/2,500"
            - playsound <player> sound:entity_experience_orb_pickup

        # Check for component milestone (2,500)
        - if <[count]> >= 2500 && !<player.has_flag[heracles.component.pillagers]>:
            - flag player heracles.component.pillagers:true
            - flag player heracles.component.pillagers_date:<util.time_now.format>
            - narrate "<&4><&l>MILESTONE!<&r> <&c>Pillager Slayer Component obtained! <&7>(2,500 pillagers)"
            - playsound <player> sound:ui_toast_challenge_complete
            - announce "<&c>[Promachos]<&r> <&f><player.name> <&7>has obtained the <&4>Pillager Slayer Component<&7>!"

# ============================================
# RAID COMPLETIONS
# ============================================

combat_raid_victory:
    type: world
    debug: false
    events:
        on raid finishes:
        # Check if raid was victory (has winners)
        - if <context.winners.size> == 0:
            - stop

        # Award each participating player (winners are guaranteed to be online)
        - foreach <context.winners> as:hero:
            # Role gate - only COMBAT role counts
            - if <[hero].flag[role.active].if_null[NONE]> != COMBAT:
                - foreach next

            # Award XP based on raid level (Bad Omen level)
            - define raid_level <context.raid.level.if_null[1]>
            - define xp_amount <script[combat_xp_rates].data_key[rates.raids.<[raid_level]>].if_null[50]>
            - run award_combat_xp def.player:<[hero]> def.amount:<[xp_amount]> def.source:raid

            # Track raids for component milestone
            - flag <[hero]> heracles.raids.count:++
            - define count <[hero].flag[heracles.raids.count]>

            # Award 2 keys per raid immediately
            - give heracles_key quantity:2 player:<[hero]>
            - narrate "<&c><&l>RAID VICTORY!<&r> <&7>+2 Heracles Keys" targets:<[hero]>
            - narrate "<&7>Raids completed: <&a><[count]><&7>/50" targets:<[hero]>
            - playsound <[hero]> sound:ui_toast_challenge_complete

            # Check for component milestone (50)
            - if <[count]> >= 50 && !<[hero].has_flag[heracles.component.raids]>:
                - flag <[hero]> heracles.component.raids:true
                - flag <[hero]> heracles.component.raids_date:<util.time_now.format>
                - narrate "<&4><&l>MILESTONE!<&r> <&c>Raid Victor Component obtained! <&7>(50 raids)" targets:<[hero]>
                - playsound <[hero]> sound:ui_toast_challenge_complete
                - announce "<&c>[Promachos]<&r> <&f><[hero].name> <&7>has obtained the <&4>Raid Victor Component<&7>!"

# ============================================
# EMERALD TRADING
# ============================================

combat_emerald_trading:
    type: world
    debug: false
    events:
        after player trades with merchant:
        # Role gate - only COMBAT role counts
        - if <player.flag[role.active].if_null[NONE]> != COMBAT:
            - stop

        # Count emeralds spent in this trade
        - define emeralds_spent 0
        - foreach <context.trade.inputs> as:input:
            - if <[input].material.name> == emerald:
                - define emeralds_spent <[emeralds_spent].add[<[input].quantity>]>

        # Stop if no emeralds spent
        - if <[emeralds_spent]> == 0:
            - stop

        # Award XP (1 XP per emerald spent)
        - define xp_amount <script[combat_xp_rates].data_key[rates.emerald].if_null[1]>
        - define total_xp <[xp_amount].mul[<[emeralds_spent]>]>
        - run award_combat_xp def.player:<player> def.amount:<[total_xp]> def.source:emerald

        # Track emeralds for component milestone
        - flag player heracles.emeralds.count:+:<[emeralds_spent]>
        - define count <player.flag[heracles.emeralds.count]>

        # Key award logic (every 150)
        - define keys_awarded <player.flag[heracles.emeralds.keys_awarded].if_null[0]>
        - define keys_should_have <[count].div[150].round_down>
        - if <[keys_should_have]> > <[keys_awarded]>:
            - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
            - give heracles_key quantity:<[keys_to_give]>
            - flag player heracles.emeralds.keys_awarded:<[keys_should_have]>
            - narrate "<&c><&l>HERACLES KEY!<&r> <&7>Emeralds: <&a><[count]><&7>/10,000"
            - playsound <player> sound:entity_experience_orb_pickup

        # Check for component milestone (10,000)
        - if <[count]> >= 10000 && !<player.has_flag[heracles.component.emeralds]>:
            - flag player heracles.component.emeralds:true
            - flag player heracles.component.emeralds_date:<util.time_now.format>
            - narrate "<&4><&l>MILESTONE!<&r> <&c>Trade Master Component obtained! <&7>(10,000 emeralds)"
            - playsound <player> sound:ui_toast_challenge_complete
            - announce "<&c>[Promachos]<&r> <&f><player.name> <&7>has obtained the <&4>Trade Master Component<&7>!"

# ============================================
# GENERAL COMBAT XP (OTHER MOBS)
# ============================================

combat_mob_kills:
    type: world
    debug: false
    events:
        after player kills zombie|skeleton|spider|creeper|cave_spider|silverfish|enderman|witch|blaze|ghast|piglin_brute|hoglin|zombified_piglin|vindicator|evoker|ravager|wither_skeleton|elder_guardian|guardian:
        # Role gate - only COMBAT role counts
        - if <player.flag[role.active].if_null[NONE]> != COMBAT:
            - stop

        # Get mob type
        - define mob <context.entity.entity_type>

        # Award XP based on mob type
        - define xp_amount <script[combat_xp_rates].data_key[rates.mobs.<[mob]>].if_null[0]>
        - if <[xp_amount]> > 0:
            - run award_combat_xp def.player:<player> def.amount:<[xp_amount]> def.source:<[mob]>

# ============================================
# XP AWARD TASK
# ============================================

award_combat_xp:
    type: task
    debug: false
    definitions: player|amount|source
    script:
    # Add XP to total
    - flag <[player]> heracles.xp:+:<[amount]>
    - define current_xp <[player].flag[heracles.xp]>

    # Get old and new rank
    - define old_rank <proc[get_combat_rank_from_xp].context[<[current_xp].sub[<[amount]>]>]>
    - define new_rank <proc[get_combat_rank_from_xp].context[<[current_xp]>]>

    # Check for rank up
    - if <[new_rank]> > <[old_rank]>:
        - define rank_name <proc[get_combat_rank_name].context[<[new_rank]>]>
        - define rank_data <script[combat_rank_data].data_key[ranks.<[new_rank]>]>
        - define key_reward <[rank_data].get[key_reward]>

        # Award keys
        - give heracles_key quantity:<[key_reward]> player:<[player]>

        # Announce rank up
        - narrate "<&4><&l>RANK UP!<&r> <&c><[rank_name]>" targets:<[player]>
        - narrate "<&7>Reward: <&e>+<[key_reward]> Heracles Keys" targets:<[player]>
        - playsound <[player]> sound:ui_toast_challenge_complete
        - playeffect effect:totem at:<[player].eye_location> quantity:30 offset:0.5
