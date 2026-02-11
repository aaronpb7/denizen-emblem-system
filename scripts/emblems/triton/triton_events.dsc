# ============================================
# TRITON EVENTS - Activity Tracking
# ============================================
#
# Activity tracking for component milestones
# 1. Guardian kills → component at 1,500 (regular=+1, elder=+15)
# 2. Conduit crafting → component at 25
#
# Sea lantern turn-in is handled by the Triton NPC (triton_npc.dsc)
#
# Only tracks when player emblem = TRITON
#

# ============================================
# GUARDIAN KILLS
# ============================================

ocean_guardian_combat:
    type: world
    debug: false
    events:
        after player kills guardian:
        # Emblem gate
        - if <player.flag[emblem.active].if_null[NONE]> != TRITON:
            - stop

        # Regular guardian: +1
        - flag player triton.guardians.count:++
        - define count <player.flag[triton.guardians.count]>

        # Key award logic (every 15)
        - define keys_awarded <player.flag[triton.guardians.keys_awarded].if_null[0]>
        - define keys_should_have <[count].div[15].round_down>
        - if <[keys_should_have]> > <[keys_awarded]>:
            - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
            - give triton_key quantity:<[keys_to_give]>
            - flag player triton.guardians.keys_awarded:<[keys_should_have]>
            - narrate "<&e><&l>TRITON KEY!<&r> <&7>Guardians: <&a><[count]><&7>/1,500"
            - playsound <player> sound:entity_experience_orb_pickup

        # Check for component milestone (1,500)
        - if <[count]> >= 1500 && !<player.has_flag[triton.component.guardians]>:
            - flag player triton.component.guardians:true
            - flag player triton.component.guardians_date:<util.time_now.format>
            - narrate "<&6><&l>MILESTONE!<&r> <&e>Guardian Component obtained! <&7>(1,500 guardians)"
            - playsound <player> sound:ui_toast_challenge_complete
            - announce "<&3>[Triton]<&r> <&f><player.name> <&7>has obtained the <&6>Guardian Component<&7>!"

        after player kills elder_guardian:
        # Emblem gate
        - if <player.flag[emblem.active].if_null[NONE]> != TRITON:
            - stop

        # Elder guardian: +15
        - flag player triton.guardians.count:+:15
        - define count <player.flag[triton.guardians.count]>

        # Key award logic (every 15)
        - define keys_awarded <player.flag[triton.guardians.keys_awarded].if_null[0]>
        - define keys_should_have <[count].div[15].round_down>
        - if <[keys_should_have]> > <[keys_awarded]>:
            - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
            - give triton_key quantity:<[keys_to_give]>
            - flag player triton.guardians.keys_awarded:<[keys_should_have]>
            - narrate "<&e><&l>TRITON KEY!<&r> <&7>Guardians: <&a><[count]><&7>/1,500 <&8>(Elder +15)"
            - playsound <player> sound:entity_experience_orb_pickup

        # Check for component milestone (1,500)
        - if <[count]> >= 1500 && !<player.has_flag[triton.component.guardians]>:
            - flag player triton.component.guardians:true
            - flag player triton.component.guardians_date:<util.time_now.format>
            - narrate "<&6><&l>MILESTONE!<&r> <&e>Guardian Component obtained! <&7>(1,500 guardians)"
            - playsound <player> sound:ui_toast_challenge_complete
            - announce "<&3>[Triton]<&r> <&f><player.name> <&7>has obtained the <&6>Guardian Component<&7>!"

# ============================================
# CONDUIT CRAFTING
# ============================================

ocean_conduit_crafting:
    type: world
    debug: false
    events:
        after player crafts conduit:
        # Emblem gate
        - if <player.flag[emblem.active].if_null[NONE]> != TRITON:
            - stop

        # Track count
        - flag player triton.conduits.count:++
        - define count <player.flag[triton.conduits.count]>

        # Key award logic (4 keys per conduit)
        - define keys_awarded <player.flag[triton.conduits.keys_awarded].if_null[0]>
        - define keys_should_have <[count].mul[4]>
        - if <[keys_should_have]> > <[keys_awarded]>:
            - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
            - give triton_key quantity:<[keys_to_give]>
            - flag player triton.conduits.keys_awarded:<[keys_should_have]>
            - narrate "<&e><&l>TRITON KEY!<&r> <&7>Conduits: <&a><[count]><&7>/25 <&8>(+4 keys)"
            - playsound <player> sound:entity_experience_orb_pickup

        # Check for component milestone (25)
        - if <[count]> >= 25 && !<player.has_flag[triton.component.conduits]>:
            - flag player triton.component.conduits:true
            - flag player triton.component.conduits_date:<util.time_now.format>
            - narrate "<&6><&l>MILESTONE!<&r> <&e>Conduit Component obtained! <&7>(25 conduits)"
            - playsound <player> sound:ui_toast_challenge_complete
            - announce "<&3>[Triton]<&r> <&f><player.name> <&7>has obtained the <&6>Conduit Component<&7>!"
