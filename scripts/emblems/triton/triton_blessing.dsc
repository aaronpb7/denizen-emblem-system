# ============================================
# TRITON BLESSING
# ============================================
#
# Consumable item that boosts all incomplete Triton activities by +5%
# - Lanterns: +50 (5% of 1,000)
# - Guardians: +75 (5% of 1,500)
# - Conduits: +1 (5% of 25, rounded down)
#
# Only boosts incomplete activities (component not obtained)
# Caps at requirement (cannot exceed milestone)
# Triggers immediate milestone/key checks
#

# ============================================
# BLESSING USAGE EVENT
# ============================================

triton_blessing_usage:
    type: world
    debug: false
    events:
        on player right clicks block with:triton_blessing:
        - determine cancelled passively

        # If all components complete, convert blessing to keys
        - if <player.has_flag[triton.component.lanterns]> && <player.has_flag[triton.component.guardians]> && <player.has_flag[triton.component.conduits]>:
            - take item:triton_blessing quantity:1
            - give triton_key quantity:10
            - narrate "<&d><&l>TRITON BLESSING ACTIVATED!<&r>"
            - narrate "  <&3>All activities complete! <&7>Converted to <&e>10 Triton Keys<&7>."
            - playsound <player> sound:block_enchantment_table_use
            - playeffect effect:bubble_pop at:<player.location> quantity:30 offset:1.0
            - stop

        # Track boosts for feedback
        - define boosted <list>

        # ===== LANTERN BOOST =====
        - if !<player.has_flag[triton.component.lanterns]>:
            - define current <player.flag[triton.lanterns.count].if_null[0]>
            - define boost 50
            - define new_count <[current].add[<[boost]>].min[1000]>
            - define actual_boost <[new_count].sub[<[current]>]>

            - flag player triton.lanterns.count:<[new_count]>
            - define boosted <[boosted].include[<&3>Lanterns<&7>: +<[actual_boost]> (<[current]> → <[new_count]>)]>

            # Check for key awards
            - define keys_awarded <player.flag[triton.lanterns.keys_awarded].if_null[0]>
            - define keys_should_have <[new_count].div[10].round_down>
            - if <[keys_should_have]> > <[keys_awarded]>:
                - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
                - give triton_key quantity:<[keys_to_give]>
                - flag player triton.lanterns.keys_awarded:<[keys_should_have]>
                - narrate "<&e><&l>BONUS KEYS!<&r> <&7>+<[keys_to_give]> Triton Keys (Lanterns)"

            # Check for component milestone
            - if <[new_count]> >= 1000:
                - flag player triton.component.lanterns:true
                - flag player triton.component.lanterns_date:<util.time_now.format>
                - narrate "<&6><&l>MILESTONE!<&r> <&e>Lantern Component obtained! <&7>(1,000 sea lanterns)"
                - playsound <player> sound:ui_toast_challenge_complete
                - announce "<&3>[Triton]<&r> <&f><player.name> <&7>has obtained the <&6>Lantern Component<&7>!"

        # ===== GUARDIAN BOOST =====
        - if !<player.has_flag[triton.component.guardians]>:
            - define current <player.flag[triton.guardians.count].if_null[0]>
            - define boost 75
            - define new_count <[current].add[<[boost]>].min[1500]>
            - define actual_boost <[new_count].sub[<[current]>]>

            - flag player triton.guardians.count:<[new_count]>
            - define boosted <[boosted].include[<&3>Guardians<&7>: +<[actual_boost]> (<[current]> → <[new_count]>)]>

            # Check for key awards
            - define keys_awarded <player.flag[triton.guardians.keys_awarded].if_null[0]>
            - define keys_should_have <[new_count].div[15].round_down>
            - if <[keys_should_have]> > <[keys_awarded]>:
                - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
                - give triton_key quantity:<[keys_to_give]>
                - flag player triton.guardians.keys_awarded:<[keys_should_have]>
                - narrate "<&e><&l>BONUS KEYS!<&r> <&7>+<[keys_to_give]> Triton Keys (Guardians)"

            # Check for component milestone
            - if <[new_count]> >= 1500:
                - flag player triton.component.guardians:true
                - flag player triton.component.guardians_date:<util.time_now.format>
                - narrate "<&6><&l>MILESTONE!<&r> <&e>Guardian Component obtained! <&7>(1,500 guardians)"
                - playsound <player> sound:ui_toast_challenge_complete
                - announce "<&3>[Triton]<&r> <&f><player.name> <&7>has obtained the <&6>Guardian Component<&7>!"

        # ===== CONDUIT BOOST =====
        - if !<player.has_flag[triton.component.conduits]>:
            - define current <player.flag[triton.conduits.count].if_null[0]>
            - define boost 1
            - define new_count <[current].add[<[boost]>].min[25]>
            - define actual_boost <[new_count].sub[<[current]>]>

            - flag player triton.conduits.count:<[new_count]>
            - define boosted <[boosted].include[<&3>Conduits<&7>: +<[actual_boost]> (<[current]> → <[new_count]>)]>

            # Check for key awards
            - define keys_awarded <player.flag[triton.conduits.keys_awarded].if_null[0]>
            - define keys_should_have <[new_count].mul[4]>
            - if <[keys_should_have]> > <[keys_awarded]>:
                - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
                - give triton_key quantity:<[keys_to_give]>
                - flag player triton.conduits.keys_awarded:<[keys_should_have]>
                - narrate "<&e><&l>BONUS KEYS!<&r> <&7>+<[keys_to_give]> Triton Keys (Conduits)"

            # Check for component milestone
            - if <[new_count]> >= 25:
                - flag player triton.component.conduits:true
                - flag player triton.component.conduits_date:<util.time_now.format>
                - narrate "<&6><&l>MILESTONE!<&r> <&e>Conduit Component obtained! <&7>(25 conduits)"
                - playsound <player> sound:ui_toast_challenge_complete
                - announce "<&3>[Triton]<&r> <&f><player.name> <&7>has obtained the <&6>Conduit Component<&7>!"

        # Consume blessing
        - take item:triton_blessing quantity:1

        # Narrate boosts
        - narrate "<&d><&l>TRITON BLESSING ACTIVATED!<&r>"
        - foreach <[boosted]>:
            - narrate "  <[value]>"

        # Effects
        - playsound <player> sound:block_enchantment_table_use
        - playeffect effect:bubble_pop at:<player.location> quantity:30 offset:1.0
