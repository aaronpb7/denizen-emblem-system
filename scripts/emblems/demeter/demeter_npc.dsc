# ============================================
# DEMETER NPC - Emblem Selection & Ceremony
# ============================================
#
# Demeter, Goddess of the Harvest
# - Handles Demeter emblem selection
# - Performs emblem unlock ceremony
# - Provides emblem info/progress display
# - Gated behind met_promachos flag
#

# ============================================
# NPC ASSIGNMENT
# ============================================

demeter_assignment:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - demeter_interact

# ============================================
# INTERACT SCRIPT
# ============================================

demeter_interact:
    type: interact
    debug: false
    steps:
        1:
            click trigger:
                script:
                # Haven't met the herald yet — turn away
                - if !<player.has_flag[met_promachos]>:
                    - run demeter_turn_away_no_promachos
                    - stop
                # First meeting — lore introduction
                - if !<player.has_flag[met_demeter]>:
                    - run demeter_first_meeting
                    - stop
                # Components complete + not unlocked → ceremony
                - if <proc[check_demeter_components_complete]> && !<player.has_flag[demeter.emblem.unlocked]>:
                    - run demeter_emblem_unlock_ceremony
                # Default → info/selection GUI
                - else:
                    - inventory open d:demeter_info_gui

# ============================================
# TURN AWAY (NO PROMACHOS)
# ============================================

demeter_turn_away_no_promachos:
    type: task
    debug: false
    script:
    - playsound <player> sound:entity_villager_ambient volume:0.3
    - narrate "<&6><&l>Demeter<&r><&7>: You carry no herald's mark, child. Speak to <&e>Promachos<&7> first."

# ============================================
# FIRST MEETING
# ============================================

demeter_first_meeting:
    type: task
    debug: false
    script:
    # Title/subtitle intro
    - title "title:<&6><&l>DEMETER" "subtitle:<&e>Goddess of the Harvest" fade_in:10t stay:50t fade_out:10t
    - playsound <player> sound:block_amethyst_block_chime volume:0.5

    - narrate "<&6><&l>Demeter<&r><&7>: Oh... a mortal. Come closer. You need not be afraid."
    - wait 3s

    - narrate "<&6><&l>Demeter<&r><&7>: I am <&6>Demeter<&7>, Goddess of the Harvest. I fled here when Olympus fell... carrying what little warmth I had left."
    - wait 3s

    - narrate "<&6><&l>Demeter<&r><&7>: My essence — the warmth that made crops grow, that turned barren soil fertile — it shattered. Scattered across this world in fragments I cannot reclaim alone."
    - wait 3s

    - narrate "<&6><&l>Demeter<&r><&7>: But mortal hands... your labor is invisible to the enemy. If you would work the fields in my name — harvest <&6>wheat<&7>, tend to <&6>cattle<&7>, bake the sacred <&6>cakes<&7> — you could restore what I have lost."
    - wait 3s

    - narrate "<&6><&l>Demeter<&r><&7>: Will you help me? Choose my emblem, and your journey begins."
    - wait 1s

    # Flag as met and open selection GUI
    - flag player met_demeter:true
    - inventory open d:demeter_info_gui

# ============================================
# EMBLEM UNLOCK CEREMONY
# ============================================

demeter_emblem_unlock_ceremony:
    type: task
    debug: false
    script:
    # Close any open GUI
    - inventory close

    # Play epic sound
    - playsound <player> sound:ui_toast_challenge_complete volume:1.0

    # Dialogue sequence — Demeter speaks in first person
    - narrate "<&6><&l>Demeter<&r><&7>: You have gathered all three fragments of my warmth. I can feel it returning... like spring after an endless winter."
    - wait 3s

    - narrate "<&6><&l>Demeter<&r><&7>: You have done what I could not. Receive my emblem — you have earned it, truly."
    - wait 3s

    - narrate "<&6><&l>Demeter<&r><&7>: <&2>You have unlocked the <&6><&l>Emblem of Demeter<&2>!"

    # Set flags
    - flag player demeter.emblem.unlocked:true
    - flag player emblem.rank:+:1
    - flag player demeter.emblem.unlock_date:<util.time_now>

    # Award bonus keys
    - give demeter_key quantity:30
    - narrate "<&7>Bonus reward: <&e>30 Demeter Keys"

    # Visual effects
    - title "title:<&6><&l>EMBLEM UNLOCKED!" "subtitle:<&e>Demeter's Blessing" fade_in:10t stay:40t fade_out:10t
    - playeffect effect:totem at:<player.location> quantity:50 offset:1.5

    # Server announcement
    - announce "<&6><&l>[Demeter]<&r> <&f><player.name> <&7>has unlocked the <&6><&l>Emblem of Demeter<&7>!"
    - playsound <server.online_players> sound:ui_toast_challenge_complete volume:0.5

    # Check tier progression
    - define tier1_done <proc[count_completed_tier_emblems].context[<player>|1]>
    - wait 2s
    - if <[tier1_done]> >= 2:
        - narrate "<&6><&l>Demeter<&r><&7>: Your devotion grows beyond my fields. <&e>Tier 2 emblems<&7> are now within your reach."
    - else:
        - narrate "<&6><&l>Demeter<&r><&7>: Thank you, child. The warmth returns. Continue your journey — the other gods need you too."

# ============================================
# CHECK DEMETER COMPONENTS
# ============================================

check_demeter_components_complete:
    type: procedure
    debug: false
    script:
    - if <player.has_flag[demeter.component.wheat]> && <player.has_flag[demeter.component.cow]> && <player.has_flag[demeter.component.cake]>:
        - determine true
    - determine false

# ============================================
# DEMETER SELECTION GUI
# ============================================

demeter_info_gui:
    type: inventory
    inventory: chest
    gui: true
    debug: false
    title: <&8>Demeter - Choose Your Emblem
    size: 27
    procedural items:
    - determine <proc[get_demeter_selection_items]>

get_demeter_selection_items:
    type: procedure
    debug: false
    script:
    - define items <list>
    - define filler <item[gray_stained_glass_pane].with[display=<&7>]>
    - repeat 27:
        - define items <[items].include[<[filler]>]>

    # Row 2: Demeter emblem centered (slot 14)
    - define items <[items].set[<proc[get_demeter_emblem_select_item]>].at[14]>

    - determine <[items]>

get_demeter_emblem_select_item:
    type: procedure
    debug: false
    script:
    - define lore <list>
    - define lore <[lore].include[<&7><&o>"Emblem of agricultural mastery"]>
    - define lore "<[lore].include[<&sp>]>"
    - if <player.has_flag[demeter.emblem.unlocked]>:
        - define lore <[lore].include[<&6><&l>Emblem Attained]>
    - else:
        - define components_done 0
        - if <player.has_flag[demeter.component.wheat]>:
            - define components_done <[components_done].add[1]>
        - if <player.has_flag[demeter.component.cow]>:
            - define components_done <[components_done].add[1]>
        - if <player.has_flag[demeter.component.cake]>:
            - define components_done <[components_done].add[1]>
        - define lore <[lore].include[<&e>Progress<&co> <&7><[components_done]>/3 components]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7>Complete three sacred activities]>
    - define lore <[lore].include[<&7>to unlock Demeter's blessing.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&e>Click to select]>
    - if <player.has_flag[demeter.emblem.unlocked]>:
        - determine <item[wheat].with[display=<&6><&l>Demeter's Emblem;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - else:
        - determine <item[wheat].with[display=<&6><&l>Demeter's Emblem;lore=<[lore]>]>

# ============================================
# DEMETER GUI EVENTS
# ============================================

demeter_gui_events:
    type: world
    debug: false
    events:
        # Emblem selection (slot 14)
        after player clicks item in demeter_info_gui:
        - if <context.raw_slot> == 14:
            - run set_player_emblem def:DEMETER
