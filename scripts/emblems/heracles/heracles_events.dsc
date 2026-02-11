# ============================================
# HERACLES EVENTS - Activity Tracking
# ============================================
#
# Activity tracking for component milestones
# 1. Pillager kills → component at 2,500
# 2. Raid completions → component at 50
# 3. Emerald spending → component at 10,000
#
# Only tracks when player emblem = HERACLES
#

# ============================================
# PILLAGER KILLS
# ============================================

combat_pillager_kills:
    type: world
    debug: false
    events:
        after player kills pillager:
        # Emblem gate - only HERACLES emblem counts
        - if <player.flag[emblem.active].if_null[NONE]> != HERACLES:
            - stop

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
            # Emblem gate - only HERACLES emblem counts
            - if <[hero].flag[emblem.active].if_null[NONE]> != HERACLES:
                - foreach next

            # Track raids for component milestone
            - flag <[hero]> heracles.raids.count:++
            - define count <[hero].flag[heracles.raids.count]>

            # Key award logic (2 keys per raid, with tracking for catch-up)
            - define keys_awarded <[hero].flag[heracles.raids.keys_awarded].if_null[0]>
            - define keys_should_have <[count].mul[2]>
            - if <[keys_should_have]> > <[keys_awarded]>:
                - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
                - give heracles_key quantity:<[keys_to_give]> player:<[hero]>
                - flag <[hero]> heracles.raids.keys_awarded:<[keys_should_have]>
                - narrate "<&c><&l>RAID VICTORY!<&r> <&7>+<[keys_to_give]> Heracles Keys" targets:<[hero]>
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
        # Emblem gate - only HERACLES emblem counts
        - if <player.flag[emblem.active].if_null[NONE]> != HERACLES:
            - stop

        # Count emeralds spent in this trade (accounting for discounts)
        - define base_emeralds 0
        - foreach <context.trade.inputs> as:input:
            - if <[input].material.name> == emerald:
                - define base_emeralds <[base_emeralds].add[<[input].quantity>]>

        # Stop if no emeralds in trade
        - if <[base_emeralds]> == 0:
            - stop

        # Apply discount (special_price is negative for discounts)
        - define special <context.trade.special_price.if_null[0]>
        - define emeralds_spent <[base_emeralds].add[<[special]>]>

        # Clamp to valid range (1-64)
        - define emeralds_spent <[emeralds_spent].max[1].min[64]>

        # Track emeralds for component milestone
        - flag player heracles.emeralds.count:+:<[emeralds_spent]>
        - define count <player.flag[heracles.emeralds.count]>

        # Key award logic (every 100)
        - define keys_awarded <player.flag[heracles.emeralds.keys_awarded].if_null[0]>
        - define keys_should_have <[count].div[100].round_down>
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
