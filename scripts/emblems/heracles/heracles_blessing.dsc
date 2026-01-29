# ============================================
# HERACLES BLESSING
# ============================================
#
# Consumable item that boosts all incomplete Heracles activities by +10%
# - Pillagers: +250 (10% of 2,500)
# - Raids: +5 (10% of 50)
# - Emeralds: +1,000 (10% of 10,000)
#
# Only boosts incomplete activities (component not obtained)
# Caps at requirement (cannot exceed milestone)
# Triggers immediate milestone/key checks
#

# ============================================
# BLESSING USAGE EVENT
# ============================================

heracles_blessing_usage:
    type: world
    debug: false
    events:
        on player right clicks block with:heracles_blessing:
        - determine cancelled passively

        # Check if all components complete (block use if so)
        - if <player.has_flag[heracles.component.pillagers]> && <player.has_flag[heracles.component.raids]> && <player.has_flag[heracles.component.emeralds]>:
            - narrate "<&c><&l>Heracles<&r><&7> has no further need of this blessing."
            - playsound <player> sound:entity_villager_no
            - stop

        # Track boosts for feedback
        - define boosted <list>

        # ===== PILLAGERS BOOST =====
        - if !<player.has_flag[heracles.component.pillagers]>:
            - define current <player.flag[heracles.pillagers.count].if_null[0]>
            - define boost 250
            - define new_count <[current].add[<[boost]>].min[2500]>
            - define actual_boost <[new_count].sub[<[current]>]>

            - flag player heracles.pillagers.count:<[new_count]>
            - define boosted <[boosted].include[<&4>Pillagers<&7>: +<[actual_boost]> (<[current]> → <[new_count]>)]>

            # Check for key awards
            - define keys_awarded <player.flag[heracles.pillagers.keys_awarded].if_null[0]>
            - define keys_should_have <[new_count].div[100].round_down>
            - if <[keys_should_have]> > <[keys_awarded]>:
                - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
                - give heracles_key quantity:<[keys_to_give]>
                - flag player heracles.pillagers.keys_awarded:<[keys_should_have]>
                - narrate "<&c><&l>BONUS KEYS!<&r> <&7>+<[keys_to_give]> Heracles Keys (Pillagers)"

            # Check for component milestone
            - if <[new_count]> >= 2500:
                - flag player heracles.component.pillagers:true
                - flag player heracles.component.pillagers_date:<util.time_now.format>
                - narrate "<&4><&l>MILESTONE!<&r> <&c>Pillager Slayer Component obtained! <&7>(2,500 pillagers)"
                - playsound <player> sound:ui_toast_challenge_complete
                - announce "<&c>[Promachos]<&r> <&f><player.name> <&7>has obtained the <&4>Pillager Slayer Component<&7>!"

        # ===== RAIDS BOOST =====
        - if !<player.has_flag[heracles.component.raids]>:
            - define current <player.flag[heracles.raids.count].if_null[0]>
            - define boost 5
            - define new_count <[current].add[<[boost]>].min[50]>
            - define actual_boost <[new_count].sub[<[current]>]>

            - flag player heracles.raids.count:<[new_count]>
            - define boosted <[boosted].include[<&4>Raids<&7>: +<[actual_boost]> (<[current]> → <[new_count]>)]>

            # Raids award 2 keys each directly, not in batches
            # So we give 2 keys per raid added
            - define keys_to_give <[actual_boost].mul[2]>
            - if <[keys_to_give]> > 0:
                - give heracles_key quantity:<[keys_to_give]>
                - narrate "<&c><&l>BONUS KEYS!<&r> <&7>+<[keys_to_give]> Heracles Keys (Raids)"

            # Check for component milestone
            - if <[new_count]> >= 50:
                - flag player heracles.component.raids:true
                - flag player heracles.component.raids_date:<util.time_now.format>
                - narrate "<&4><&l>MILESTONE!<&r> <&c>Raid Victor Component obtained! <&7>(50 raids)"
                - playsound <player> sound:ui_toast_challenge_complete
                - announce "<&c>[Promachos]<&r> <&f><player.name> <&7>has obtained the <&4>Raid Victor Component<&7>!"

        # ===== EMERALDS BOOST =====
        - if !<player.has_flag[heracles.component.emeralds]>:
            - define current <player.flag[heracles.emeralds.count].if_null[0]>
            - define boost 1000
            - define new_count <[current].add[<[boost]>].min[10000]>
            - define actual_boost <[new_count].sub[<[current]>]>

            - flag player heracles.emeralds.count:<[new_count]>
            - define boosted <[boosted].include[<&4>Emeralds<&7>: +<[actual_boost]> (<[current]> → <[new_count]>)]>

            # Check for key awards
            - define keys_awarded <player.flag[heracles.emeralds.keys_awarded].if_null[0]>
            - define keys_should_have <[new_count].div[100].round_down>
            - if <[keys_should_have]> > <[keys_awarded]>:
                - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
                - give heracles_key quantity:<[keys_to_give]>
                - flag player heracles.emeralds.keys_awarded:<[keys_should_have]>
                - narrate "<&c><&l>BONUS KEYS!<&r> <&7>+<[keys_to_give]> Heracles Keys (Emeralds)"

            # Check for component milestone
            - if <[new_count]> >= 10000:
                - flag player heracles.component.emeralds:true
                - flag player heracles.component.emeralds_date:<util.time_now.format>
                - narrate "<&4><&l>MILESTONE!<&r> <&c>Trade Master Component obtained! <&7>(10,000 emeralds)"
                - playsound <player> sound:ui_toast_challenge_complete
                - announce "<&c>[Promachos]<&r> <&f><player.name> <&7>has obtained the <&4>Trade Master Component<&7>!"

        # Consume blessing
        - take item:heracles_blessing quantity:1

        # Narrate boosts
        - narrate "<&d><&l>HERACLES BLESSING ACTIVATED!<&r>"
        - foreach <[boosted]>:
            - narrate "  <[value]>"

        # Effects
        - playsound <player> sound:block_enchantment_table_use
        - playeffect effect:villager_happy at:<player.location> quantity:30 offset:1.0
