# ============================================
# HEPHAESTUS BLESSING
# ============================================
#
# Consumable item that boosts all incomplete Hephaestus activities by +5%
# - Iron ore: +250 (5% of 5,000)
# - Blast furnace smelting: +250 (5% of 5,000)
# - Iron golems: +5 (5% of 100)
#
# Only boosts incomplete activities (component not obtained)
# Caps at requirement (cannot exceed milestone)
# Triggers immediate milestone/key checks
#

# ============================================
# BLESSING USAGE EVENT
# ============================================

hephaestus_blessing_usage:
    type: world
    debug: false
    events:
        on player right clicks block with:hephaestus_blessing:
        - determine cancelled passively

        # If all components complete, convert blessing to keys
        - if <player.has_flag[hephaestus.component.iron]> && <player.has_flag[hephaestus.component.smelting]> && <player.has_flag[hephaestus.component.golem]>:
            - take item:hephaestus_blessing quantity:1
            - give hephaestus_key quantity:10
            - narrate "<&d><&l>HEPHAESTUS BLESSING ACTIVATED!<&r>"
            - narrate "  <&8>All activities complete! <&7>Converted to <&e>10 Hephaestus Keys<&7>."
            - playsound <player> sound:block_enchantment_table_use
            - playeffect effect:flame at:<player.location> quantity:30 offset:1.0
            - stop

        # Track boosts for feedback
        - define boosted <list>

        # ===== IRON ORE BOOST =====
        - if !<player.has_flag[hephaestus.component.iron]>:
            - define current <player.flag[hephaestus.iron.count].if_null[0]>
            - define boost 250
            - define new_count <[current].add[<[boost]>].min[5000]>
            - define actual_boost <[new_count].sub[<[current]>]>

            - flag player hephaestus.iron.count:<[new_count]>
            - define boosted <[boosted].include[<&7>Iron Ore<&7>: +<&f><[actual_boost]> <&7>(<[current]> → <[new_count]>)]>

            # Check for key awards (every 50 iron)
            - define keys_awarded <player.flag[hephaestus.iron.keys_awarded].if_null[0]>
            - define keys_should_have <[new_count].div[50].round_down>
            - if <[keys_should_have]> > <[keys_awarded]>:
                - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
                - give hephaestus_key quantity:<[keys_to_give]>
                - flag player hephaestus.iron.keys_awarded:<[keys_should_have]>
                - narrate "<&8><&l>BONUS KEYS!<&r> <&7>+<[keys_to_give]> Hephaestus Keys (Iron Ore)"

            # Check for component milestone
            - if <[new_count]> >= 5000:
                - flag player hephaestus.component.iron:true
                - flag player hephaestus.component.iron_date:<util.time_now.format>
                - narrate "<&8><&l>MILESTONE!<&r> <&f>Iron Component obtained! <&8>(5,000 iron ore)"
                - playsound <player> sound:ui_toast_challenge_complete
                - announce "<&e>[Promachos]<&r> <&f><player.name> <&8>has obtained the <&7>Iron Component<&8>!"

        # ===== SMELTING BOOST =====
        - if !<player.has_flag[hephaestus.component.smelting]>:
            - define current <player.flag[hephaestus.smelting.count].if_null[0]>
            - define boost 250
            - define new_count <[current].add[<[boost]>].min[5000]>
            - define actual_boost <[new_count].sub[<[current]>]>

            - flag player hephaestus.smelting.count:<[new_count]>
            - define boosted <[boosted].include[<&7>Smelting<&7>: +<&f><[actual_boost]> <&7>(<[current]> → <[new_count]>)]>

            # Check for key awards (every 50 smelts)
            - define keys_awarded <player.flag[hephaestus.smelting.keys_awarded].if_null[0]>
            - define keys_should_have <[new_count].div[50].round_down>
            - if <[keys_should_have]> > <[keys_awarded]>:
                - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
                - give hephaestus_key quantity:<[keys_to_give]>
                - flag player hephaestus.smelting.keys_awarded:<[keys_should_have]>
                - narrate "<&8><&l>BONUS KEYS!<&r> <&7>+<[keys_to_give]> Hephaestus Keys (Smelting)"

            # Check for component milestone
            - if <[new_count]> >= 5000:
                - flag player hephaestus.component.smelting:true
                - flag player hephaestus.component.smelting_date:<util.time_now.format>
                - narrate "<&8><&l>MILESTONE!<&r> <&f>Smelting Component obtained! <&8>(5,000 smelts)"
                - playsound <player> sound:ui_toast_challenge_complete
                - announce "<&e>[Promachos]<&r> <&f><player.name> <&8>has obtained the <&7>Smelting Component<&8>!"

        # ===== GOLEMS BOOST =====
        - if !<player.has_flag[hephaestus.component.golem]>:
            - define current <player.flag[hephaestus.golems.count].if_null[0]>
            - define boost 5
            - define new_count <[current].add[<[boost]>].min[100]>
            - define actual_boost <[new_count].sub[<[current]>]>

            - flag player hephaestus.golems.count:<[new_count]>
            - define boosted <[boosted].include[<&7>Golems<&7>: +<&f><[actual_boost]> <&7>(<[current]> → <[new_count]>)]>

            # Check for key awards (1 key per golem)
            - define keys_awarded <player.flag[hephaestus.golems.keys_awarded].if_null[0]>
            - if <[new_count]> > <[keys_awarded]>:
                - define keys_to_give <[new_count].sub[<[keys_awarded]>]>
                - give hephaestus_key quantity:<[keys_to_give]>
                - flag player hephaestus.golems.keys_awarded:<[new_count]>
                - narrate "<&8><&l>BONUS KEYS!<&r> <&7>+<[keys_to_give]> Hephaestus Keys (Golems)"

            # Check for component milestone
            - if <[new_count]> >= 100:
                - flag player hephaestus.component.golem:true
                - flag player hephaestus.component.golem_date:<util.time_now.format>
                - narrate "<&8><&l>MILESTONE!<&r> <&f>Golem Component obtained! <&8>(100 golems)"
                - playsound <player> sound:ui_toast_challenge_complete
                - announce "<&e>[Promachos]<&r> <&f><player.name> <&8>has obtained the <&7>Golem Component<&8>!"

        # Consume blessing
        - take item:hephaestus_blessing quantity:1

        # Narrate boosts
        - narrate "<&d><&l>HEPHAESTUS BLESSING ACTIVATED!<&r>"
        - foreach <[boosted]>:
            - narrate "  <[value]>"

        # Effects
        - playsound <player> sound:block_enchantment_table_use
        - playeffect effect:lava at:<player.location> quantity:30 offset:1.0
