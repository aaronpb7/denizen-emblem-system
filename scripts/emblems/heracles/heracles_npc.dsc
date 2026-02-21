# ============================================
# HERACLES NPC - Emblem Selection & Ceremony
# ============================================
#
# Heracles, Hero-God of Valor
# - Handles Heracles emblem selection
# - Performs emblem unlock ceremony
# - Provides emblem info/progress display
# - Gated behind met_promachos flag
#

# ============================================
# NPC ASSIGNMENT
# ============================================

heracles_assignment:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - heracles_interact

# ============================================
# INTERACT SCRIPT
# ============================================

heracles_interact:
    type: interact
    debug: false
    steps:
        1:
            click trigger:
                script:
                # Haven't met the herald yet — turn away
                - if !<player.has_flag[met_promachos]>:
                    - run heracles_turn_away_no_promachos
                    - stop
                # First meeting — lore introduction
                - if !<player.has_flag[met_heracles]>:
                    - run heracles_first_meeting
                    - stop
                # Components complete + not unlocked → ceremony
                - if <proc[check_heracles_components_complete]> && !<player.has_flag[heracles.emblem.unlocked]>:
                    - run heracles_emblem_unlock_ceremony
                # Default → info/selection GUI
                - else:
                    - inventory open d:heracles_info_gui

# ============================================
# TURN AWAY (NO PROMACHOS)
# ============================================

heracles_turn_away_no_promachos:
    type: task
    debug: false
    script:
    - playsound <player> sound:entity_iron_golem_hurt volume:0.3
    - narrate "<&c><&l>Heracles<&r><&7>: I don't fight alongside strangers. Talk to the herald first."

# ============================================
# FIRST MEETING
# ============================================

heracles_first_meeting:
    type: task
    debug: false
    script:
    # Title/subtitle intro
    - title "title:<&c><&l>HERACLES" "subtitle:<&4>Hero of Legend" fade_in:10t stay:50t fade_out:10t
    - playsound <player> sound:entity_ender_dragon_growl volume:0.3

    - narrate "<&c><&l>Heracles<&r><&7>: Stop. Let me look at you."
    - wait 3s

    - narrate "<&c><&l>Heracles<&r><&7>: I am <&c>Heracles<&7>. I was mortal once — born mortal, earned my divinity through twelve labors the songs still echo. I know what it means to fight with nothing but your hands and your refusal to die."
    - wait 3s

    - narrate "<&c><&l>Heracles<&r><&7>: When Olympus fell, I was the last to leave. I stayed to fight. I failed. Whatever came for us... it swatted me aside like a child."
    - wait 3s

    - narrate "<&c><&l>Heracles<&r><&7>: Now I need mortals who can do what I cannot. Slay <&c>pillagers<&7>, survive <&c>raids<&7>, trade for <&c>emeralds<&7> — prove you have the will to stand where a god fell."
    - wait 3s

    - narrate "<&c><&l>Heracles<&r><&7>: Choose my emblem. I won't dress it up with pretty words. It will be hard. But you look like you can take it."
    - wait 1s

    # Flag as met and open selection GUI
    - flag player met_heracles:true
    - inventory open d:heracles_info_gui

# ============================================
# EMBLEM UNLOCK CEREMONY
# ============================================

heracles_emblem_unlock_ceremony:
    type: task
    debug: false
    script:
    # Close any open GUI
    - inventory close

    # Play epic sound
    - playsound <player> sound:ui_toast_challenge_complete volume:1.0
    - playsound <player> sound:entity_ender_dragon_growl volume:0.5

    # Dialogue sequence — Heracles speaks in first person
    - narrate "<&c><&l>Heracles<&r><&7>: You've done it. Every trial. Every battle. You didn't quit."
    - wait 3s

    - narrate "<&c><&l>Heracles<&r><&7>: When I was mortal, I wished for someone to fight beside me. I never found them. Maybe you're what I was looking for."
    - wait 3s

    - narrate "<&c><&l>Heracles<&r><&7>: <&2>You have unlocked the <&c><&l>Emblem of Heracles<&2>!"

    # Set flags
    - flag player heracles.emblem.unlocked:true
    - flag player emblem.rank:+:1
    - flag player heracles.emblem.unlock_date:<util.time_now>

    # Award bonus keys
    - give heracles_key quantity:30
    - narrate "<&7>Bonus reward: <&c>30 Heracles Keys"

    # Visual effects
    - title "title:<&c><&l>EMBLEM UNLOCKED!" "subtitle:<&4>Heracles' Favor" fade_in:10t stay:40t fade_out:10t
    - playeffect effect:flame at:<player.location> quantity:50 offset:1.5

    # Server announcement
    - announce "<&c><&l>[Heracles]<&r> <&f><player.name> <&7>has unlocked the <&c><&l>Emblem of Heracles<&7>!"
    - playsound <server.online_players> sound:ui_toast_challenge_complete volume:0.5

    # Check tier progression
    - define tier1_done <proc[count_completed_tier_emblems].context[<player>|1]>
    - wait 2s
    - if <[tier1_done]> >= 2:
        - narrate "<&c><&l>Heracles<&r><&7>: Your strength grows beyond what I can teach. <&e>Tier 2 emblems<&7> are now within your reach."
    - else:
        - narrate "<&c><&l>Heracles<&r><&7>: Well done. You've earned this. Now go — the fight isn't over."

# ============================================
# CHECK HERACLES COMPONENTS
# ============================================

check_heracles_components_complete:
    type: procedure
    debug: false
    script:
    - if <player.has_flag[heracles.component.pillagers]> && <player.has_flag[heracles.component.raids]> && <player.has_flag[heracles.component.emeralds]>:
        - determine true
    - determine false

# ============================================
# HERACLES SELECTION GUI
# ============================================

heracles_info_gui:
    type: inventory
    inventory: chest
    gui: true
    debug: false
    title: <&8>Heracles - Choose Your Emblem
    size: 27
    procedural items:
    - determine <proc[get_heracles_selection_items]>

get_heracles_selection_items:
    type: procedure
    debug: false
    script:
    - define items <list>
    - define filler <item[gray_stained_glass_pane].with[display=<&7>]>
    - repeat 27:
        - define items <[items].include[<[filler]>]>

    # Row 2: Heracles emblem centered (slot 14)
    - define items <[items].set[<proc[get_heracles_emblem_select_item]>].at[14]>

    - determine <[items]>

get_heracles_emblem_select_item:
    type: procedure
    debug: false
    script:
    - define lore <list>
    - define lore <[lore].include[<&7><&o>"Emblem of heroic valor"]>
    - define lore "<[lore].include[<&sp>]>"
    - if <player.has_flag[heracles.emblem.unlocked]>:
        - define lore <[lore].include[<&c><&l>Emblem Attained]>
    - else:
        - define components_done 0
        - if <player.has_flag[heracles.component.pillagers]>:
            - define components_done <[components_done].add[1]>
        - if <player.has_flag[heracles.component.raids]>:
            - define components_done <[components_done].add[1]>
        - if <player.has_flag[heracles.component.emeralds]>:
            - define components_done <[components_done].add[1]>
        - define lore <[lore].include[<&e>Progress<&co> <&7><[components_done]>/3 components]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7>Complete three heroic deeds]>
    - define lore <[lore].include[<&7>to unlock Heracles' favor.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&e>Click to select]>
    - if <player.has_flag[heracles.emblem.unlocked]>:
        - determine <item[diamond_sword].with[display=<&c><&l>Heracles' Emblem;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - else:
        - determine <item[diamond_sword].with[display=<&c><&l>Heracles' Emblem;lore=<[lore]>]>

# ============================================
# HERACLES GUI EVENTS
# ============================================

heracles_gui_events:
    type: world
    debug: false
    events:
        # Emblem selection (slot 14)
        after player clicks item in heracles_info_gui:
        - if <context.raw_slot> == 14:
            - run set_player_emblem def:HERACLES
