# ============================================
# TRITON EVENTS - Activity Tracking
# ============================================
#
# Activity tracking for component milestones
# 1. Guardian kills → component at 1,500 (regular=+1, elder=+15)
# 2. Treasure fishing → component at 100
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
            - give triton_mythic_fragment quantity:1
            - narrate "<&d>+1 Triton Mythic Fragment!"

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
            - give triton_mythic_fragment quantity:1
            - narrate "<&d>+1 Triton Mythic Fragment!"

# ============================================
# TREASURE FISHING (TRITON'S CATCH)
# ============================================

ocean_treasure_fishing:
    type: world
    debug: false
    events:
        after player fishes while caught_fish:
        # Emblem gate
        - if <player.flag[emblem.active].if_null[NONE]> != TRITON:
            - stop

        # Only count treasure category items for progression
        - define material <context.item.material.name>
        - define is_treasure <list[enchanted_book|name_tag|saddle|nautilus_shell|bow|fishing_rod].contains[<[material]>]>

        # 1% bonus key chance on ANY catch
        - if <util.random.int[1].to[100]> <= 1:
            - give triton_key quantity:1
            - narrate "<&3><&l>BONUS KEY!<&r> <&7>The sea god rewards your patience!"
            - playsound <player> sound:entity_experience_orb_pickup

        - if !<[is_treasure]>:
            - stop

        # Track count
        - flag player triton.catches.count:++
        - define count <player.flag[triton.catches.count]>

        # Key award logic (1 key per treasure catch)
        - define keys_awarded <player.flag[triton.catches.keys_awarded].if_null[0]>
        - if <[count]> > <[keys_awarded]>:
            - define keys_to_give <[count].sub[<[keys_awarded]>]>
            - give triton_key quantity:<[keys_to_give]>
            - flag player triton.catches.keys_awarded:<[count]>
            - narrate "<&e><&l>TRITON KEY!<&r> <&7>Triton's Catch: <&a><[count]><&7>/100"
            - playsound <player> sound:entity_experience_orb_pickup

        # Check for component milestone (100)
        - if <[count]> >= 100 && !<player.has_flag[triton.component.catches]>:
            - flag player triton.component.catches:true
            - flag player triton.component.catches_date:<util.time_now.format>
            - narrate "<&6><&l>MILESTONE!<&r> <&e>Catch Component obtained! <&7>(100 treasures fished)"
            - playsound <player> sound:ui_toast_challenge_complete
            - announce "<&3>[Triton]<&r> <&f><player.name> <&7>has obtained the <&6>Catch Component<&7>!"
            - give triton_mythic_fragment quantity:1
            - narrate "<&d>+1 Triton Mythic Fragment!"
