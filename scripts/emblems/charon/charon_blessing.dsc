# ============================================
# CHARON BLESSING
# ============================================
#
# Consumable item that boosts all incomplete Charon activities by +5%
# - Debris: +25 (5% of 500)
# - Withers: +75 (5% of 1,500)
# - Barters: +125 (5% of 2,500)
#
# Only boosts incomplete activities (component not obtained)
# Caps at requirement (cannot exceed milestone)
# Triggers immediate milestone/key checks
#

# ============================================
# BLESSING USAGE EVENT
# ============================================

charon_blessing_usage:
    type: world
    debug: false
    events:
        on player right clicks block with:charon_blessing:
        - determine cancelled passively

        # If all components complete, convert blessing to keys
        - if <player.has_flag[charon.component.debris]> && <player.has_flag[charon.component.withers]> && <player.has_flag[charon.component.barters]>:
            - take item:charon_blessing quantity:1
            - give charon_key quantity:10
            - narrate "<&d><&l>CHARON BLESSING ACTIVATED!<&r>"
            - narrate "  <&5>All activities complete! <&7>Converted to <&e>10 Charon Keys<&7>."
            - playsound <player> sound:block_enchantment_table_use
            - playeffect effect:soul_fire_flame at:<player.location> quantity:30 offset:1.0
            - stop

        # Track boosts for feedback
        - define boosted <list>

        # ===== DEBRIS BOOST =====
        - if !<player.has_flag[charon.component.debris]>:
            - define current <player.flag[charon.debris.count].if_null[0]>
            - define boost 25
            - define new_count <[current].add[<[boost]>].min[500]>
            - define actual_boost <[new_count].sub[<[current]>]>

            - flag player charon.debris.count:<[new_count]>
            - define boosted <[boosted].include[<&5>Debris<&7>: +<[actual_boost]> (<[current]> → <[new_count]>)]>

            # Check for key awards
            - define keys_awarded <player.flag[charon.debris.keys_awarded].if_null[0]>
            - define keys_should_have <[new_count].div[5].round_down>
            - if <[keys_should_have]> > <[keys_awarded]>:
                - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
                - give charon_key quantity:<[keys_to_give]>
                - flag player charon.debris.keys_awarded:<[keys_should_have]>
                - narrate "<&e><&l>BONUS KEYS!<&r> <&7>+<[keys_to_give]> Charon Keys (Debris)"

            # Check for component milestone
            - if <[new_count]> >= 500:
                - flag player charon.component.debris:true
                - flag player charon.component.debris_date:<util.time_now.format>
                - narrate "<&6><&l>MILESTONE!<&r> <&e>Debris Component obtained! <&7>(500 ancient debris)"
                - playsound <player> sound:ui_toast_challenge_complete
                - announce "<&5>[Charon]<&r> <&f><player.name> <&7>has obtained the <&6>Debris Component<&7>!"

        # ===== WITHER BOOST =====
        - if !<player.has_flag[charon.component.withers]>:
            - define current <player.flag[charon.withers.count].if_null[0]>
            - define boost 75
            - define new_count <[current].add[<[boost]>].min[1500]>
            - define actual_boost <[new_count].sub[<[current]>]>

            - flag player charon.withers.count:<[new_count]>
            - define boosted <[boosted].include[<&5>Withers<&7>: +<[actual_boost]> (<[current]> → <[new_count]>)]>

            # Check for key awards
            - define keys_awarded <player.flag[charon.withers.keys_awarded].if_null[0]>
            - define keys_should_have <[new_count].div[15].round_down>
            - if <[keys_should_have]> > <[keys_awarded]>:
                - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
                - give charon_key quantity:<[keys_to_give]>
                - flag player charon.withers.keys_awarded:<[keys_should_have]>
                - narrate "<&e><&l>BONUS KEYS!<&r> <&7>+<[keys_to_give]> Charon Keys (Withers)"

            # Check for component milestone
            - if <[new_count]> >= 1500:
                - flag player charon.component.withers:true
                - flag player charon.component.withers_date:<util.time_now.format>
                - narrate "<&6><&l>MILESTONE!<&r> <&e>Wither Component obtained! <&7>(1,500 withers)"
                - playsound <player> sound:ui_toast_challenge_complete
                - announce "<&5>[Charon]<&r> <&f><player.name> <&7>has obtained the <&6>Wither Component<&7>!"

        # ===== BARTER BOOST =====
        - if !<player.has_flag[charon.component.barters]>:
            - define current <player.flag[charon.barters.count].if_null[0]>
            - define boost 125
            - define new_count <[current].add[<[boost]>].min[2500]>
            - define actual_boost <[new_count].sub[<[current]>]>

            - flag player charon.barters.count:<[new_count]>
            - define boosted <[boosted].include[<&5>Barters<&7>: +<[actual_boost]> (<[current]> → <[new_count]>)]>

            # Check for key awards
            - define keys_awarded <player.flag[charon.barters.keys_awarded].if_null[0]>
            - define keys_should_have <[new_count].div[25].round_down>
            - if <[keys_should_have]> > <[keys_awarded]>:
                - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
                - give charon_key quantity:<[keys_to_give]>
                - flag player charon.barters.keys_awarded:<[keys_should_have]>
                - narrate "<&e><&l>BONUS KEYS!<&r> <&7>+<[keys_to_give]> Charon Keys (Barters)"

            # Check for component milestone
            - if <[new_count]> >= 2500:
                - flag player charon.component.barters:true
                - flag player charon.component.barters_date:<util.time_now.format>
                - narrate "<&6><&l>MILESTONE!<&r> <&e>Barter Component obtained! <&7>(2,500 barters)"
                - playsound <player> sound:ui_toast_challenge_complete
                - announce "<&5>[Charon]<&r> <&f><player.name> <&7>has obtained the <&6>Barter Component<&7>!"

        # Consume blessing
        - take item:charon_blessing quantity:1

        # Narrate boosts
        - narrate "<&d><&l>CHARON BLESSING ACTIVATED!<&r>"
        - foreach <[boosted]>:
            - narrate "  <[value]>"

        # Effects
        - playsound <player> sound:block_enchantment_table_use
        - playeffect effect:soul_fire_flame at:<player.location> quantity:30 offset:1.0
