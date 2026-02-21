# ============================================
# CHARON EVENTS - Activity Tracking
# ============================================
#
# Activity tracking for component milestones
# 1. Wither skeleton/wither kills → component at 1,500 (skeleton=+1, wither=+15)
# 2. Piglin bartering → component at 2,500
#
# Ancient debris turn-in is handled by the Charon NPC (charon_npc.dsc)
#
# Only tracks when player emblem = CHARON
#

# ============================================
# WITHER COMBAT
# ============================================

nether_wither_combat:
    type: world
    debug: false
    events:
        after player kills wither_skeleton:
        # Emblem gate
        - if <player.flag[emblem.active].if_null[NONE]> != CHARON:
            - stop

        # Wither skeleton: +1
        - flag player charon.withers.count:++
        - define count <player.flag[charon.withers.count]>

        # Key award logic (every 15)
        - define keys_awarded <player.flag[charon.withers.keys_awarded].if_null[0]>
        - define keys_should_have <[count].div[15].round_down>
        - if <[keys_should_have]> > <[keys_awarded]>:
            - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
            - give charon_key quantity:<[keys_to_give]>
            - flag player charon.withers.keys_awarded:<[keys_should_have]>
            - narrate "<&e><&l>CHARON KEY!<&r> <&7>Withers: <&d><[count]><&7>/1,500"
            - playsound <player> sound:entity_experience_orb_pickup

        # Check for component milestone (1,500)
        - if <[count]> >= 1500 && !<player.has_flag[charon.component.withers]>:
            - flag player charon.component.withers:true
            - flag player charon.component.withers_date:<util.time_now.format>
            - narrate "<&6><&l>MILESTONE!<&r> <&e>Wither Component obtained! <&7>(1,500 withers)"
            - playsound <player> sound:ui_toast_challenge_complete
            - announce "<&5>[Charon]<&r> <&f><player.name> <&7>has obtained the <&6>Wither Component<&7>!"
            - give charon_mythic_fragment quantity:1
            - narrate "<&d>+1 Charon Mythic Fragment!"

        after player kills wither:
        # Emblem gate
        - if <player.flag[emblem.active].if_null[NONE]> != CHARON:
            - stop

        # Wither boss: +15
        - flag player charon.withers.count:+:15
        - define count <player.flag[charon.withers.count]>

        # Key award logic (every 15)
        - define keys_awarded <player.flag[charon.withers.keys_awarded].if_null[0]>
        - define keys_should_have <[count].div[15].round_down>
        - if <[keys_should_have]> > <[keys_awarded]>:
            - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
            - give charon_key quantity:<[keys_to_give]>
            - flag player charon.withers.keys_awarded:<[keys_should_have]>
            - narrate "<&e><&l>CHARON KEY!<&r> <&7>Withers: <&d><[count]><&7>/1,500 <&8>(Wither Boss +15)"
            - playsound <player> sound:entity_experience_orb_pickup

        # Check for component milestone (1,500)
        - if <[count]> >= 1500 && !<player.has_flag[charon.component.withers]>:
            - flag player charon.component.withers:true
            - flag player charon.component.withers_date:<util.time_now.format>
            - narrate "<&6><&l>MILESTONE!<&r> <&e>Wither Component obtained! <&7>(1,500 withers)"
            - playsound <player> sound:ui_toast_challenge_complete
            - announce "<&5>[Charon]<&r> <&f><player.name> <&7>has obtained the <&6>Wither Component<&7>!"
            - give charon_mythic_fragment quantity:1
            - narrate "<&d>+1 Charon Mythic Fragment!"

# ============================================
# PIGLIN BARTERING
# ============================================

nether_piglin_barter:
    type: world
    debug: false
    events:
        after piglin barter:
        # Find nearest player who did the barter (within 8 blocks)
        - define barterer <context.entity.location.find_players_within[8].first.if_null[null]>
        - if <[barterer]> == null:
            - stop

        # Emblem gate - only CHARON emblem counts
        - if <[barterer].flag[emblem.active].if_null[NONE]> != CHARON:
            - stop

        # Track count
        - flag <[barterer]> charon.barters.count:++
        - define count <[barterer].flag[charon.barters.count]>

        # Key award logic (every 25)
        - define keys_awarded <[barterer].flag[charon.barters.keys_awarded].if_null[0]>
        - define keys_should_have <[count].div[25].round_down>
        - if <[keys_should_have]> > <[keys_awarded]>:
            - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
            - give charon_key quantity:<[keys_to_give]> player:<[barterer]>
            - flag <[barterer]> charon.barters.keys_awarded:<[keys_should_have]>
            - narrate "<&e><&l>CHARON KEY!<&r> <&7>Barters: <&d><[count]><&7>/2,500" targets:<[barterer]>
            - playsound <[barterer]> sound:entity_experience_orb_pickup

        # 1% bonus key chance
        - if <util.random.int[1].to[100]> <= 1:
            - give charon_key quantity:1 player:<[barterer]>
            - narrate "<&5><&l>BONUS KEY!<&r> <&7>The ferryman favors your barter!" targets:<[barterer]>
            - playsound <[barterer]> sound:entity_experience_orb_pickup

        # Check for component milestone (2,500)
        - if <[count]> >= 2500 && !<[barterer].has_flag[charon.component.barters]>:
            - flag <[barterer]> charon.component.barters:true
            - flag <[barterer]> charon.component.barters_date:<util.time_now.format>
            - narrate "<&6><&l>MILESTONE!<&r> <&e>Barter Component obtained! <&7>(2,500 barters)" targets:<[barterer]>
            - playsound <[barterer]> sound:ui_toast_challenge_complete
            - announce "<&5>[Charon]<&r> <&f><[barterer].name> <&7>has obtained the <&6>Barter Component<&7>!"
            - give charon_mythic_fragment quantity:1 player:<[barterer]>
            - narrate "<&d>+1 Charon Mythic Fragment!" targets:<[barterer]>
