# ============================================
# EMBLEM SYSTEM V2 - DEMETER BLESSING
# ============================================
#
# Consumable item that boosts all incomplete Demeter activities by +10%
# - Wheat: +1,500 (10% of 15,000)
# - Cows: +200 (10% of 2,000)
# - Cakes: +30 (10% of 300)
#
# Only boosts incomplete activities (component not obtained)
# Caps at requirement (cannot exceed milestone)
# Triggers immediate milestone/key checks
#

# ============================================
# BLESSING USAGE EVENT
# ============================================

demeter_blessing_usage:
    type: world
    debug: false
    events:
        on player right clicks block with:demeter_blessing:
        - determine cancelled passively

        # Check if all components complete (block use if so)
        - if <player.has_flag[demeter.component.wheat]> && <player.has_flag[demeter.component.cow]> && <player.has_flag[demeter.component.cake]>:
            - narrate "<&e><&l>Demeter<&r><&7> has no further need of this blessing."
            - playsound <player> sound:entity_villager_no
            - stop

        # Track boosts for feedback
        - define boosted <list>

        # ===== WHEAT BOOST =====
        - if !<player.has_flag[demeter.component.wheat]>:
            - define current <player.flag[demeter.wheat.count].if_null[0]>
            - define boost 1500
            - define new_count <[current].add[<[boost]>].min[15000]>
            - define actual_boost <[new_count].sub[<[current]>]>

            - flag player demeter.wheat.count:<[new_count]>
            - define boosted <[boosted].include[<&6>Wheat<&7>: +<[actual_boost]> (<[current]> → <[new_count]>)]>

            # Check for key awards
            - define keys_awarded <player.flag[demeter.wheat.keys_awarded].if_null[0]>
            - define keys_should_have <[new_count].div[150].round_down>
            - if <[keys_should_have]> > <[keys_awarded]>:
                - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
                - give demeter_key quantity:<[keys_to_give]>
                - flag player demeter.wheat.keys_awarded:<[keys_should_have]>
                - narrate "<&e><&l>BONUS KEYS!<&r> <&7>+<[keys_to_give]> Demeter Keys (Wheat)"

            # Check for component milestone
            - if <[new_count]> >= 15000:
                - flag player demeter.component.wheat:true
                - flag player demeter.component.wheat_date:<util.time_now.format>
                - narrate "<&6><&l>MILESTONE!<&r> <&e>Wheat Component obtained! <&7>(15,000 wheat)"
                - playsound <player> sound:ui_toast_challenge_complete
                - announce "<&e>[Promachos]<&r> <&f><player.name> <&7>has obtained the <&6>Wheat Component<&7>!"

        # ===== COW BOOST =====
        - if !<player.has_flag[demeter.component.cow]>:
            - define current <player.flag[demeter.cows.count].if_null[0]>
            - define boost 200
            - define new_count <[current].add[<[boost]>].min[2000]>
            - define actual_boost <[new_count].sub[<[current]>]>

            - flag player demeter.cows.count:<[new_count]>
            - define boosted <[boosted].include[<&6>Cows<&7>: +<[actual_boost]> (<[current]> → <[new_count]>)]>

            # Check for key awards
            - define keys_awarded <player.flag[demeter.cows.keys_awarded].if_null[0]>
            - define keys_should_have <[new_count].div[20].round_down>
            - if <[keys_should_have]> > <[keys_awarded]>:
                - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
                - give demeter_key quantity:<[keys_to_give]>
                - flag player demeter.cows.keys_awarded:<[keys_should_have]>
                - narrate "<&e><&l>BONUS KEYS!<&r> <&7>+<[keys_to_give]> Demeter Keys (Cows)"

            # Check for component milestone
            - if <[new_count]> >= 2000:
                - flag player demeter.component.cow:true
                - flag player demeter.component.cow_date:<util.time_now.format>
                - narrate "<&6><&l>MILESTONE!<&r> <&e>Cow Component obtained! <&7>(2,000 cows)"
                - playsound <player> sound:ui_toast_challenge_complete
                - announce "<&e>[Promachos]<&r> <&f><player.name> <&7>has obtained the <&6>Cow Component<&7>!"

        # ===== CAKE BOOST =====
        - if !<player.has_flag[demeter.component.cake]>:
            - define current <player.flag[demeter.cakes.count].if_null[0]>
            - define boost 30
            - define new_count <[current].add[<[boost]>].min[300]>
            - define actual_boost <[new_count].sub[<[current]>]>

            - flag player demeter.cakes.count:<[new_count]>
            - define boosted <[boosted].include[<&6>Cakes<&7>: +<[actual_boost]> (<[current]> → <[new_count]>)]>

            # Check for key awards
            - define keys_awarded <player.flag[demeter.cakes.keys_awarded].if_null[0]>
            - define keys_should_have <[new_count].div[3].round_down>
            - if <[keys_should_have]> > <[keys_awarded]>:
                - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
                - give demeter_key quantity:<[keys_to_give]>
                - flag player demeter.cakes.keys_awarded:<[keys_should_have]>
                - narrate "<&e><&l>BONUS KEYS!<&r> <&7>+<[keys_to_give]> Demeter Keys (Cakes)"

            # Check for component milestone
            - if <[new_count]> >= 300:
                - flag player demeter.component.cake:true
                - flag player demeter.component.cake_date:<util.time_now.format>
                - narrate "<&6><&l>MILESTONE!<&r> <&e>Cake Component obtained! <&7>(300 cakes)"
                - playsound <player> sound:ui_toast_challenge_complete
                - announce "<&e>[Promachos]<&r> <&f><player.name> <&7>has obtained the <&6>Cake Component<&7>!"

        # Consume blessing
        - take item:demeter_blessing quantity:1

        # Narrate boosts
        - narrate "<&d><&l>DEMETER BLESSING ACTIVATED!<&r>"
        - foreach <[boosted]>:
            - narrate "  <[value]>"

        # Effects
        - playsound <player> sound:block_enchantment_table_use
        - playeffect effect:villager_happy at:<player.location> quantity:30 offset:1.0
