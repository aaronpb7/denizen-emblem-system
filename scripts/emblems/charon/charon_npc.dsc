# ============================================
# CHARON NPC - Ancient Debris Turn-in & Ceremony
# ============================================
#
# Charon, Ferryman of the Dead
# - Accepts ancient debris turn-ins (primary activity)
# - Performs emblem unlock ceremony
# - Provides emblem info/progress display
#

# ============================================
# NPC ASSIGNMENT
# ============================================

charon_assignment:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - charon_interact

# ============================================
# INTERACT SCRIPT
# ============================================

charon_interact:
    type: interact
    debug: false
    steps:
        1:
            click trigger:
                script:
                # Not worthy yet — turn away
                - if !<proc[can_access_tier].context[<player>|2]>:
                    - run charon_turn_away
                    - stop
                # First real meeting — introduction
                - if !<player.has_flag[met_charon]>:
                    - run charon_first_meeting
                    - stop
                # Priority 1: Ceremony if all components complete and not unlocked
                - if <proc[check_charon_components_complete]> && !<player.has_flag[charon.emblem.unlocked]>:
                    - run charon_emblem_unlock_ceremony
                # Priority 2: Ancient debris turn-in if holding debris and emblem active
                - else if <player.item_in_hand.material.name> == ancient_debris && <player.flag[emblem.active].if_null[NONE]> == CHARON:
                    - run charon_debris_turnin
                # Priority 3: Info menu
                - else:
                    - inventory open d:charon_info_gui

# ============================================
# TURN AWAY (NOT WORTHY)
# ============================================

charon_turn_away:
    type: task
    debug: false
    script:
    - define tier1_done <proc[count_completed_tier_emblems].context[<player>|1]>
    - playsound <player> sound:entity_wither_ambient volume:0.3
    - choose <[tier1_done]>:
        - case 0:
            - narrate "<&5><&l>Charon<&r><&7>: The living do not cross my river unbidden. You are not strong enough to hear what I have to say."
            - wait 2s
            - narrate "<&5><&l>Charon<&r><&7>: Return when you have earned <&5>two emblems<&7> from the gods above. Then perhaps."
        - case 1:
            - narrate "<&5><&l>Charon<&r><&7>: One emblem... the river stirs, but the underworld demands more."
            - wait 2s
            - narrate "<&5><&l>Charon<&r><&7>: Earn <&5>one more emblem<&7>, and I shall grant you passage."

# ============================================
# FIRST MEETING (HAS 2 TIER 1s)
# ============================================

charon_first_meeting:
    type: task
    debug: false
    script:
    # Title/subtitle intro
    - title "title:<&5><&l>CHARON" "subtitle:<&d>Ferryman of the Dead" fade_in:10t stay:50t fade_out:10t
    - playsound <player> sound:entity_wither_ambient volume:0.5

    - narrate "<&5><&l>Charon<&r><&7>: ...You. Come closer. Let me look at you."
    - wait 3s

    - narrate "<&5><&l>Charon<&r><&7>: I am <&5>Charon<&7>, Ferryman of the Dead. I am older than Olympus. Older than the Titans. I have ferried the dead since the concept of death was new."
    - wait 3s

    - narrate "<&5><&l>Charon<&r><&7>: I did not flee Olympus — I fled the underworld. My own domain. Something entered from <&5>below<&7>... from somewhere even I did not know existed. The Styx began to dry. Souls were unmade."
    - wait 3s

    - narrate "<&5><&l>Charon<&r><&7>: I need mortals who can endure the nether's fire. Bring me <&5>ancient debris<&7>, slay <&5>withers<&7> in my name, and <&5>barter<&7> with the piglins of the deep."
    - wait 3s

    - narrate "<&5><&l>Charon<&r><&7>: Accept my emblem. Do not ask me what I saw down there. You are not ready."
    - wait 1s

    # Flag as met and open info menu
    - flag player met_charon:true
    - inventory open d:charon_info_gui

# ============================================
# ANCIENT DEBRIS TURN-IN
# ============================================

charon_debris_turnin:
    type: task
    debug: false
    script:
    # Count debris in hand
    - define debris_in_hand <player.item_in_hand.quantity>

    # Take all debris from hand
    - take item:ancient_debris quantity:<[debris_in_hand]> from:hand

    # Charon dialogue
    - narrate "<&5><&l>Charon<&r><&7>: Good... the nether's bones return to me."
    - playsound <player> sound:entity_experience_orb_pickup
    - wait 2s

    # Increment count
    - flag player charon.debris.count:+:<[debris_in_hand]>
    - define count <player.flag[charon.debris.count]>

    # Feedback
    - narrate "<&5><&l>CHARON<&r> <&7>accepted <&5><[debris_in_hand]> ancient debris<&7>. <&8>(<&5><[count]><&8>/<&5>500<&8>)"
    - playsound <player> sound:entity_experience_orb_pickup

    # Key award logic (every 5)
    - define keys_awarded <player.flag[charon.debris.keys_awarded].if_null[0]>
    - define keys_should_have <[count].div[5].round_down>
    - if <[keys_should_have]> > <[keys_awarded]>:
        - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
        - give charon_key quantity:<[keys_to_give]>
        - flag player charon.debris.keys_awarded:<[keys_should_have]>
        - narrate "<&e><&l>CHARON KEY!<&r> <&7>+<[keys_to_give]> key<tern[<[keys_to_give]>.is[MORE].than[1]].if_true[s].if_false[]>"
        - playsound <player> sound:entity_experience_orb_pickup

    # Check for component milestone (500)
    - if <[count]> >= 500 && !<player.has_flag[charon.component.debris]>:
        - flag player charon.component.debris:true
        - flag player charon.component.debris_date:<util.time_now.format>
        - narrate "<&6><&l>MILESTONE!<&r> <&e>Debris Component obtained! <&7>(500 ancient debris)"
        - playsound <player> sound:ui_toast_challenge_complete
        - announce "<&5>[Charon]<&r> <&f><player.name> <&7>has obtained the <&6>Debris Component<&7>!"
        - give charon_mythic_fragment quantity:1
        - narrate "<&d>+1 Charon Mythic Fragment!"

# ============================================
# EMBLEM UNLOCK CEREMONY
# ============================================

charon_emblem_unlock_ceremony:
    type: task
    debug: false
    script:
    # Close any open GUI
    - inventory close

    # Play epic sound
    - playsound <player> sound:ui_toast_challenge_complete volume:1.0
    - playsound <player> sound:entity_wither_ambient volume:0.5

    # Dialogue sequence
    - narrate "<&5><&l>Charon<&r><&7>: You have braved the fires and mastered the underworld."
    - wait 3s

    - narrate "<&5><&l>Charon<&r><&7>: Death itself acknowledges your will. Receive my emblem!"
    - wait 3s

    - narrate "<&5><&l>Charon<&r><&7>: <&2>You have unlocked the <&5><&l>Emblem of Charon<&2>!"

    # Set flags
    - flag player charon.emblem.unlocked:true
    - flag player emblem.rank:+:1
    - flag player charon.emblem.unlock_date:<util.time_now>

    # Award bonus keys
    - give charon_key quantity:30
    - narrate "<&7>Bonus reward: <&5>30 Charon Keys"

    # Visual effects
    - title "title:<&5><&l>EMBLEM UNLOCKED!" "subtitle:<&d>Charon's Domain" fade_in:10t stay:40t fade_out:10t
    - playeffect effect:soul_fire_flame at:<player.location> quantity:50 offset:1.5

    # Server announcement
    - announce "<&5><&l>[Charon]<&r> <&f><player.name> <&7>has unlocked the <&5><&l>Emblem of Charon<&7>!"
    - playsound <server.online_players> sound:ui_toast_challenge_complete volume:0.5

    # Tier progression tease
    - wait 2s
    - narrate "<&5><&l>Charon<&r><&7>: You have conquered death itself. Your legend is eternal."

# ============================================
# CHECK CHARON COMPONENTS
# ============================================

check_charon_components_complete:
    type: procedure
    debug: false
    script:
    - if <player.has_flag[charon.component.debris]> && <player.has_flag[charon.component.withers]> && <player.has_flag[charon.component.barters]>:
        - determine true
    - determine false

# ============================================
# CHARON SELECTION GUI
# ============================================

charon_info_gui:
    type: inventory
    inventory: chest
    gui: true
    debug: false
    title: <&8>Charon - Choose Your Emblem
    size: 27
    procedural items:
    - determine <proc[get_charon_selection_items]>

get_charon_selection_items:
    type: procedure
    debug: false
    script:
    - define items <list>
    - define filler <item[gray_stained_glass_pane].with[display=<&7>]>
    - repeat 27:
        - define items <[items].include[<[filler]>]>

    # Row 2: Charon emblem centered (slot 14)
    - define items <[items].set[<proc[get_charon_emblem_select_item]>].at[14]>

    - determine <[items]>

get_charon_emblem_select_item:
    type: procedure
    debug: false
    script:
    - define lore <list>
    - define lore <[lore].include[<&7><&o>"Emblem of underworld mastery"]>
    - define lore "<[lore].include[<&sp>]>"
    - if <player.has_flag[charon.emblem.unlocked]>:
        - define lore <[lore].include[<&5><&l>Emblem Attained]>
    - else:
        - define components_done 0
        - if <player.has_flag[charon.component.debris]>:
            - define components_done <[components_done].add[1]>
        - if <player.has_flag[charon.component.withers]>:
            - define components_done <[components_done].add[1]>
        - if <player.has_flag[charon.component.barters]>:
            - define components_done <[components_done].add[1]>
        - define lore <[lore].include[<&e>Progress<&co> <&7><[components_done]>/3 components]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7>Complete three nether trials]>
    - define lore <[lore].include[<&7>to unlock Charon's domain.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&e>Click to select]>
    - if <player.has_flag[charon.emblem.unlocked]>:
        - determine <item[soul_lantern].with[display=<&5><&l>Charon's Emblem;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - else:
        - determine <item[soul_lantern].with[display=<&5><&l>Charon's Emblem;lore=<[lore]>]>

# ============================================
# CHARON GUI EVENTS
# ============================================

charon_gui_events:
    type: world
    debug: false
    events:
        # Emblem selection (slot 14)
        after player clicks item in charon_info_gui:
        - if <context.raw_slot> == 14:
            - run set_player_emblem def:CHARON
