# ============================================
# HEPHAESTUS NPC - Emblem Selection & Ceremony
# ============================================
#
# Hephaestus, God of the Forge
# - Handles Hephaestus emblem selection
# - Performs emblem unlock ceremony
# - Provides emblem info/progress display
# - Gated behind met_promachos flag
#

# ============================================
# NPC ASSIGNMENT
# ============================================

hephaestus_assignment:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - hephaestus_interact

# ============================================
# INTERACT SCRIPT
# ============================================

hephaestus_interact:
    type: interact
    debug: false
    steps:
        1:
            click trigger:
                script:
                # Haven't met the herald yet — turn away
                - if !<player.has_flag[met_promachos]>:
                    - run hephaestus_turn_away_no_promachos
                    - stop
                # First meeting — lore introduction
                - if !<player.has_flag[met_hephaestus]>:
                    - run hephaestus_first_meeting
                    - stop
                # Components complete + not unlocked → ceremony
                - if <proc[check_hephaestus_components_complete]> && !<player.has_flag[hephaestus.emblem.unlocked]>:
                    - run hephaestus_emblem_unlock_ceremony
                # Emblem unlocked + armor not crafted → armor quest
                - else if <player.has_flag[hephaestus.emblem.unlocked]> && !<player.has_flag[hephaestus.armor.crafted]>:
                    - run hephaestus_armor_quest_handler
                # Default → info/selection GUI
                - else:
                    - inventory open d:hephaestus_info_gui

# ============================================
# TURN AWAY (NO PROMACHOS)
# ============================================

hephaestus_turn_away_no_promachos:
    type: task
    debug: false
    script:
    - playsound <player> sound:block_anvil_land volume:0.3
    - narrate "<&8><&l>Hephaestus<&r><&7>: I don't know you. Speak to the herald first."

# ============================================
# FIRST MEETING
# ============================================

hephaestus_first_meeting:
    type: task
    debug: false
    script:
    - playsound <player> sound:block_anvil_use volume:0.5

    - narrate "<&8><&l>Hephaestus<&r><&7>: Hmph. Another one. At least you had the sense to find me."
    - wait 5s

    - narrate "<&8><&l>Hephaestus<&r><&7>: I am <&8>Hephaestus<&7>, God of the Forge. My divine forge — the one that mattered — is gone. Unmade. This crude thing is all I have left."
    - wait 5s

    - narrate "<&8><&l>Hephaestus<&r><&7>: I need mortal hands. Yours will do. Mine <&8>iron<&7>, <&8>smelt<&7> ore, build <&8>golems<&7> of iron — the kind of work I once did with a thought, now requiring muscle and sweat."
    - wait 5s

    - narrate "<&8><&l>Hephaestus<&r><&7>: I don't need your words. I need your hands. Choose my emblem if you're willing to work."
    - wait 3s

    # Character introduction title
    - title "title:<&6>Character Introduction" "subtitle:<&f>Hephaestus" fade_in:10t stay:50t fade_out:10t

    # Flag as met and open selection GUI
    - flag player met_hephaestus:true
    - inventory open d:hephaestus_info_gui

# ============================================
# EMBLEM UNLOCK CEREMONY
# ============================================

hephaestus_emblem_unlock_ceremony:
    type: task
    debug: false
    script:
    # Close any open GUI
    - inventory close

    # Play epic sound
    - playsound <player> sound:ui_toast_challenge_complete volume:1.0
    - playsound <player> sound:block_anvil_use volume:0.5

    # Dialogue sequence — Hephaestus speaks in first person
    - narrate "<&8><&l>Hephaestus<&r><&7>: You've done it. The forge burns brighter than it has since the fall."
    - wait 5s

    - narrate "<&8><&l>Hephaestus<&r><&7>: I built things for gods who never thanked me. You... you helped when I asked. That is worth more than gratitude."
    - wait 5s

    - narrate "<&8><&l>Hephaestus<&r><&7>: <&2>You have unlocked the <&8><&l>Emblem of Hephaestus<&2>!"

    # Set flags
    - flag player hephaestus.emblem.unlocked:true
    - flag player emblem.rank:+:1
    - flag player hephaestus.emblem.unlock_date:<util.time_now>

    # Award bonus keys
    - give hephaestus_key quantity:30
    - narrate "<&7>Bonus reward: <&7>30 Hephaestus Keys"

    # Visual effects
    - title "title:<&8><&l>EMBLEM UNLOCKED!" "subtitle:<&f>Hephaestus' Blessing" fade_in:10t stay:40t fade_out:10t
    - playeffect effect:lava at:<player.location> quantity:50 offset:1.5

    # Server announcement
    - announce "<&8><&l>[Hephaestus]<&r> <&f><player.name> <&7>has unlocked the <&8><&l>Emblem of Hephaestus<&7>!"
    - playsound <server.online_players> sound:ui_toast_challenge_complete volume:0.5

    # Check tier progression
    - define tier1_done <proc[count_completed_tier_emblems].context[<player>|1]>
    - wait 4s
    - if <[tier1_done]> >= 2:
        - narrate "<&8><&l>Hephaestus<&r><&7>: Your work speaks for itself. <&e>Tier 2 emblems<&7> are now within your reach."
    - else:
        - narrate "<&8><&l>Hephaestus<&r><&7>: Good work. Now go. The other gods need hands like yours."

# ============================================
# CHECK HEPHAESTUS COMPONENTS
# ============================================

check_hephaestus_components_complete:
    type: procedure
    debug: false
    script:
    - if <player.has_flag[hephaestus.component.iron]> && <player.has_flag[hephaestus.component.smelting]> && <player.has_flag[hephaestus.component.golem]>:
        - determine true
    - determine false

# ============================================
# HEPHAESTUS SELECTION GUI
# ============================================

hephaestus_info_gui:
    type: inventory
    inventory: chest
    gui: true
    debug: false
    title: <&8>Hephaestus - Choose Your Emblem
    size: 27
    procedural items:
    - determine <proc[get_hephaestus_selection_items]>

get_hephaestus_selection_items:
    type: procedure
    debug: false
    script:
    - define items <list>
    - define filler <item[gray_stained_glass_pane].with[display=<&7>]>
    - repeat 27:
        - define items <[items].include[<[filler]>]>

    # Row 2: Hephaestus emblem centered (slot 14)
    - define items <[items].set[<proc[get_hephaestus_emblem_select_item]>].at[14]>

    - determine <[items]>

get_hephaestus_emblem_select_item:
    type: procedure
    debug: false
    script:
    - define lore <list>
    - define lore <[lore].include[<&7><&o>"Emblem of forge mastery"]>
    - define lore "<[lore].include[<&sp>]>"
    - if <player.has_flag[hephaestus.emblem.unlocked]>:
        - define lore <[lore].include[<&8><&l>Emblem Attained]>
    - else:
        - define components_done 0
        - if <player.has_flag[hephaestus.component.iron]>:
            - define components_done <[components_done].add[1]>
        - if <player.has_flag[hephaestus.component.smelting]>:
            - define components_done <[components_done].add[1]>
        - if <player.has_flag[hephaestus.component.golem]>:
            - define components_done <[components_done].add[1]>
        - define lore <[lore].include[<&8>Progress<&co> <&7><[components_done]>/3 components]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7>Complete three sacred activities]>
    - define lore <[lore].include[<&7>to unlock Hephaestus' blessing.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&e>Click to select]>
    - if <player.has_flag[hephaestus.emblem.unlocked]>:
        - determine <item[iron_pickaxe].with[display=<&8><&l>Hephaestus' Emblem;lore=<[lore]>;enchantments=mending,1;hides=ALL]>
    - else:
        - determine <item[iron_pickaxe].with[display=<&8><&l>Hephaestus' Emblem;lore=<[lore]>]>

# ============================================
# HEPHAESTUS GUI EVENTS
# ============================================

hephaestus_gui_events:
    type: world
    debug: false
    events:
        # Emblem selection (slot 14)
        after player clicks item in hephaestus_info_gui:
        - if <context.raw_slot> == 14:
            - run set_player_emblem def:HEPHAESTUS
