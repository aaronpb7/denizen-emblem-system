# ============================================
# TRITON NPC - Sea Lantern Turn-in & Ceremony
# ============================================
#
# Triton, God of the Sea
# - Accepts sea lantern turn-ins (primary activity)
# - Performs emblem unlock ceremony
# - Provides emblem info/progress display
#

# ============================================
# NPC ASSIGNMENT
# ============================================

triton_assignment:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - triton_interact

# ============================================
# INTERACT SCRIPT
# ============================================

triton_interact:
    type: interact
    debug: false
    steps:
        1:
            click trigger:
                script:
                # Not worthy yet — turn away
                - if !<proc[can_access_tier].context[<player>|2]>:
                    - run triton_turn_away
                    - stop
                # First real meeting — introduction
                - if !<player.has_flag[met_triton]>:
                    - run triton_first_meeting
                    - stop
                # Priority 1: Ceremony if all components complete and not unlocked
                - if <proc[check_triton_components_complete]> && !<player.has_flag[triton.emblem.unlocked]>:
                    - run triton_emblem_unlock_ceremony
                # Priority 2: Sea lantern turn-in if holding sea lanterns and emblem active
                - else if <player.item_in_hand.material.name> == sea_lantern && <player.flag[emblem.active].if_null[NONE]> == TRITON:
                    - run triton_lantern_turnin
                # Priority 3: Info menu
                - else:
                    - inventory open d:triton_info_gui

# ============================================
# TURN AWAY (NOT WORTHY)
# ============================================

triton_turn_away:
    type: task
    debug: false
    script:
    - define tier1_done <proc[count_completed_tier_emblems].context[<player>|1]>
    - playsound <player> sound:entity_elder_guardian_ambient volume:0.3
    - choose <[tier1_done]>:
        - case 0:
            - narrate "<&3><&l>Triton<&r><&7>: You smell of dry land, mortal. The sea does not welcome the unproven."
            - wait 2s
            - narrate "<&3><&l>Triton<&r><&7>: Return when you have earned <&3>two emblems<&7> from the gods above."
        - case 1:
            - narrate "<&3><&l>Triton<&r><&7>: I sense one emblem upon you... but the deep demands more."
            - wait 2s
            - narrate "<&3><&l>Triton<&r><&7>: Earn <&3>one more emblem<&7>, and the sea will open to you."

# ============================================
# FIRST MEETING (HAS 2 TIER 1s)
# ============================================

triton_first_meeting:
    type: task
    debug: false
    script:
    - playsound <player> sound:entity_elder_guardian_ambient volume:0.5
    - narrate "<&3><&l>Triton<&r><&7>: So... you have proven yourself to the gods above."
    - wait 3s

    - narrate "<&3><&l>Triton<&r><&7>: I am <&3>Triton<&7>, God of the Sea. The deep has watched your journey with interest."
    - wait 3s

    - narrate "<&3><&l>Triton<&r><&7>: My trials are not like those on the surface. You will bring me <&3>sea lanterns<&7>, slay <&3>guardians<&7> of the ocean monuments, and forge <&3>conduits<&7> of power."
    - wait 3s

    - narrate "<&3><&l>Triton<&r><&7>: Accept my emblem, and the ocean's depths will become your domain."
    - wait 1s

    # Flag as met and open info menu
    - flag player met_triton:true
    - inventory open d:triton_info_gui

# ============================================
# SEA LANTERN TURN-IN
# ============================================

triton_lantern_turnin:
    type: task
    debug: false
    script:
    # Count sea lanterns in hand
    - define lanterns_in_hand <player.item_in_hand.quantity>

    # Take all sea lanterns from hand
    - take item:sea_lantern quantity:<[lanterns_in_hand]> from:hand

    # Triton dialogue
    - narrate "<&3><&l>Triton<&r><&7>: Good... the sea's light returns to me."
    - playsound <player> sound:entity_experience_orb_pickup
    - wait 2s

    # Increment count
    - flag player triton.lanterns.count:+:<[lanterns_in_hand]>
    - define count <player.flag[triton.lanterns.count]>

    # Feedback
    - narrate "<&3><&l>TRITON<&r> <&7>accepted <&3><[lanterns_in_hand]> sea lantern<tern[<[lanterns_in_hand]>.is[MORE].than[1]].if_true[s].if_false[]><&7>. <&8>(<&3><[count]><&8>/<&3>1,000<&8>)"
    - playsound <player> sound:entity_experience_orb_pickup

    # Key award logic (every 10)
    - define keys_awarded <player.flag[triton.lanterns.keys_awarded].if_null[0]>
    - define keys_should_have <[count].div[10].round_down>
    - if <[keys_should_have]> > <[keys_awarded]>:
        - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
        - give triton_key quantity:<[keys_to_give]>
        - flag player triton.lanterns.keys_awarded:<[keys_should_have]>
        - narrate "<&e><&l>TRITON KEY!<&r> <&7>+<[keys_to_give]> key<tern[<[keys_to_give]>.is[MORE].than[1]].if_true[s].if_false[]>"
        - playsound <player> sound:entity_experience_orb_pickup

    # Check for component milestone (1,000)
    - if <[count]> >= 1000 && !<player.has_flag[triton.component.lanterns]>:
        - flag player triton.component.lanterns:true
        - flag player triton.component.lanterns_date:<util.time_now.format>
        - narrate "<&6><&l>MILESTONE!<&r> <&e>Lantern Component obtained! <&7>(1,000 sea lanterns)"
        - playsound <player> sound:ui_toast_challenge_complete
        - announce "<&3>[Triton]<&r> <&f><player.name> <&7>has obtained the <&6>Lantern Component<&7>!"

# ============================================
# EMBLEM UNLOCK CEREMONY
# ============================================

triton_emblem_unlock_ceremony:
    type: task
    debug: false
    script:
    # Close any open GUI
    - inventory close

    # Play epic sound
    - playsound <player> sound:ui_toast_challenge_complete volume:1.0
    - playsound <player> sound:entity_elder_guardian_ambient volume:0.5

    # Dialogue sequence
    - narrate "<&3><&l>Triton<&r><&7>: You have conquered the depths and mastered the sea."
    - wait 3s

    - narrate "<&3><&l>Triton<&r><&7>: The ocean itself bows to your will. Receive my emblem!"
    - wait 3s

    - narrate "<&3><&l>Triton<&r><&7>: <&2>You have unlocked the <&3><&l>Emblem of Triton<&2>!"

    # Set flags
    - flag player triton.emblem.unlocked:true
    - flag player emblem.rank:+:1
    - flag player triton.emblem.unlock_date:<util.time_now>

    # Award bonus keys
    - give triton_key quantity:30
    - narrate "<&7>Bonus reward: <&3>30 Triton Keys"

    # Visual effects
    - title "title:<&3><&l>EMBLEM UNLOCKED!" "subtitle:<&b>Triton's Dominion" fade_in:10t stay:40t fade_out:10t
    - playeffect effect:bubble_pop at:<player.location> quantity:50 offset:1.5

    # Server announcement
    - announce "<&3><&l>[Triton]<&r> <&f><player.name> <&7>has unlocked the <&3><&l>Emblem of Triton<&7>!"
    - playsound <server.online_players> sound:ui_toast_challenge_complete volume:0.5

    # Tier progression tease
    - wait 2s
    - narrate "<&3><&l>Triton<&r><&7>: You have conquered the depths. Your legend grows."

# ============================================
# CHECK TRITON COMPONENTS
# ============================================

check_triton_components_complete:
    type: procedure
    debug: false
    script:
    - if <player.has_flag[triton.component.lanterns]> && <player.has_flag[triton.component.guardians]> && <player.has_flag[triton.component.conduits]>:
        - determine true
    - determine false

# ============================================
# TRITON SELECTION GUI
# ============================================

triton_info_gui:
    type: inventory
    inventory: chest
    gui: true
    debug: false
    title: <&8>Triton - Choose Your Emblem
    size: 27
    procedural items:
    - determine <proc[get_triton_selection_items]>

get_triton_selection_items:
    type: procedure
    debug: false
    script:
    - define items <list>
    - define filler <item[gray_stained_glass_pane].with[display=<&7>]>
    - repeat 27:
        - define items <[items].include[<[filler]>]>

    # Row 2: Triton emblem centered (slot 14)
    - define items <[items].set[<proc[get_triton_emblem_select_item]>].at[14]>

    - determine <[items]>

get_triton_emblem_select_item:
    type: procedure
    debug: false
    script:
    - define lore <list>
    - define lore <[lore].include[<&7><&o>"Emblem of ocean mastery"]>
    - define lore "<[lore].include[<&sp>]>"
    - if <player.has_flag[triton.emblem.unlocked]>:
        - define lore <[lore].include[<&3><&l>Emblem Attained]>
    - else:
        - define components_done 0
        - if <player.has_flag[triton.component.lanterns]>:
            - define components_done <[components_done].add[1]>
        - if <player.has_flag[triton.component.guardians]>:
            - define components_done <[components_done].add[1]>
        - if <player.has_flag[triton.component.conduits]>:
            - define components_done <[components_done].add[1]>
        - define lore <[lore].include[<&e>Progress<&co> <&7><[components_done]>/3 components]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7>Complete three ocean trials]>
    - define lore <[lore].include[<&7>to unlock Triton's dominion.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&e>Click to select]>
    - if <player.has_flag[triton.emblem.unlocked]>:
        - determine <item[trident].with[display=<&3><&l>Triton's Emblem;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - else:
        - determine <item[trident].with[display=<&3><&l>Triton's Emblem;lore=<[lore]>]>

# ============================================
# TRITON GUI EVENTS
# ============================================

triton_gui_events:
    type: world
    debug: false
    events:
        # Emblem selection (slot 14)
        after player clicks item in triton_info_gui:
        - if <context.raw_slot> == 14:
            - run set_player_emblem def:TRITON
