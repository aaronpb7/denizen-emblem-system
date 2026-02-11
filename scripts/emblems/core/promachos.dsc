# ============================================
# PROMACHOS NPC - Emblem Selection
# ============================================
#
# Promachos (Προμαχός) - Herald of the Gods
# - First interaction: Introduces system, forces emblem selection
# - Returning: Main menu (change emblem, check progress, info)
# - Emblem unlocks: Ceremony when components complete
#

# ============================================
# NPC ASSIGNMENT
# ============================================

promachos_assignment:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - promachos_interact

# ============================================
# INTERACT SCRIPT
# ============================================

promachos_interact:
    type: interact
    debug: false
    steps:
        1:
            click trigger:
                script:
                - if !<player.has_flag[met_promachos]>:
                    - run promachos_first_meeting
                # Check for ready emblems (components complete but not unlocked)
                - else if <proc[check_demeter_components_complete]> && !<player.has_flag[demeter.emblem.unlocked]>:
                    - run demeter_emblem_unlock_ceremony
                - else if <proc[check_hephaestus_components_complete]> && !<player.has_flag[hephaestus.emblem.unlocked]>:
                    - run hephaestus_emblem_unlock_ceremony
                - else if <proc[check_heracles_components_complete]> && !<player.has_flag[heracles.emblem.unlocked]>:
                    - run heracles_emblem_unlock_ceremony
                - else:
                    - inventory open d:promachos_main_menu

# ============================================
# FIRST MEETING DIALOGUE
# ============================================

promachos_first_meeting:
    type: task
    debug: false
    script:
    # Dialogue sequence (5 parts, 3s delay)
    - narrate "<&e><&l>Promachos<&r><&7>: Greetings, <player.name>. I am Promachos, Herald of the Gods."
    - wait 3s

    - narrate "<&e><&l>Promachos<&r><&7>: The Olympians watch your deeds. Through your labors, you may earn their favor—and their gifts."
    - wait 3s

    - narrate "<&e><&l>Promachos<&r><&7>: You must choose an emblem to pursue. Only one may be pursued at a time."
    - wait 3s

    - narrate "<&e><&l>Promachos<&r><&7>: Each emblem requires completing three sacred tasks. Finish all three, and I shall bestow the emblem upon you."
    - wait 3s

    - narrate "<&e><&l>Promachos<&r><&7>: Choose wisely. Your journey begins now."
    - wait 1s

    # Flag as met and open emblem selection
    - flag player met_promachos:true
    - inventory open d:emblem_selection_gui

# ============================================
# MAIN MENU GUI
# ============================================

promachos_change_emblem_button:
    type: item
    material: compass
    display name: <&6><&l>Change Emblem
    lore:
    - <&7>Switch your active emblem.
    - <empty>
    - <&e>Click to change emblem.

promachos_system_info_button:
    type: item
    material: book
    display name: <&6><&l>System Info
    lore:
    - <&7>Learn about the emblem system.
    - <empty>
    - <&e>Click for information.

promachos_main_menu:
    type: inventory
    inventory: chest
    gui: true
    title: <&8>Promachos - Herald Menu
    size: 27
    definitions:
        filler: <item[gray_stained_glass_pane].with[display=<&7>]>
        change_emblem: <item[promachos_change_emblem_button]>
        system_info: <item[promachos_system_info_button]>
    slots:
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [filler] [filler] [change_emblem] [filler] [system_info] [filler] [filler] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]

# ============================================
# EMBLEM SELECTION GUI
# ============================================

promachos_back_button:
    type: item
    material: arrow
    display name: <&e>← Back
    lore:
    - <&7>Return to Promachos

emblem_selection_gui:
    type: inventory
    inventory: chest
    gui: true
    debug: false
    title: <&8>Promachos - Choose Your Emblem
    size: 27
    procedural items:
    - determine <proc[get_emblem_selection_items]>

get_emblem_selection_items:
    type: procedure
    debug: false
    script:
    - define items <list>
    - define filler <item[gray_stained_glass_pane].with[display=<&7>]>
    - repeat 27:
        - define items <[items].include[<[filler]>]>

    # Row 2: Three Tier 1 emblem selection icons (slots 12, 14, 16)
    - define items <[items].set[<proc[get_demeter_emblem_select_item]>].at[12]>
    - define items <[items].set[<proc[get_hephaestus_emblem_select_item]>].at[14]>
    - define items <[items].set[<proc[get_heracles_emblem_select_item]>].at[16]>

    # Back button (bottom left slot 19)
    - define items <[items].set[<item[promachos_back_button]>].at[19]>

    - determine <[items]>

# Selection-specific item procedures (show "Click to select" instead of "Click for detailed progress")
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
# GUI EVENT HANDLERS
# ============================================

promachos_gui_events:
    type: world
    debug: false
    events:
        # Main menu clicks
        after player clicks promachos_change_emblem_button in promachos_main_menu:
        - inventory open d:emblem_selection_gui

        after player clicks promachos_system_info_button in promachos_main_menu:
        - inventory open d:system_info_gui

        # Emblem selection clicks (slot-based: 12=Demeter, 14=Hephaestus, 16=Heracles)
        after player clicks item in emblem_selection_gui:
        - if <context.raw_slot> == 12:
            - run set_player_emblem def:DEMETER
        - else if <context.raw_slot> == 14:
            - run set_player_emblem def:HEPHAESTUS
        - else if <context.raw_slot> == 16:
            - run set_player_emblem def:HERACLES

        after player clicks promachos_back_button in emblem_selection_gui:
        - inventory open d:promachos_main_menu

        # System info menu clicks
        after player clicks system_info_back_button in system_info_gui:
        - inventory open d:promachos_main_menu

# ============================================
# ROLE SETTING TASK
# ============================================

set_player_emblem:
    type: task
    debug: false
    definitions: emblem
    script:
    # Check if already active
    - if <player.flag[emblem.active].if_null[NONE]> == <[emblem]>:
        - inventory close
        - define display <proc[get_emblem_display_name].context[<[emblem]>]>
        - narrate "<&7>You are already a <&6><[display]><&7>."
        - playsound <player> sound:entity_villager_no
        - stop

    # Set new emblem
    - flag player emblem.active:<[emblem]>
    - inventory close

    # Confirmation message
    - define display <proc[get_emblem_display_name].context[<[emblem]>]>

    - if <player.has_flag[emblem.changed_before]>:
        - narrate "<&e><&l>Promachos<&r><&7>: You have switched to <&6><[display]><&7>. Your previous progress is preserved."
    - else:
        - choose <[emblem]>:
            - case DEMETER:
                - narrate "<&e><&l>Promachos<&r><&7>: You have chosen the <&6>Emblem of Demeter<&7>. May the goddess bless your fields."
            - case HEPHAESTUS:
                - narrate "<&e><&l>Promachos<&r><&7>: You have chosen the <&8>Emblem of Hephaestus<&7>. May the god of the forge guide your works."
            - case HERACLES:
                - narrate "<&e><&l>Promachos<&r><&7>: You have chosen the <&c>Emblem of Heracles<&7>. May the hero grant you strength."
            - case TRITON:
                - narrate "<&3><&l>Triton<&r><&7>: You have accepted my emblem. May the seas guide your voyage."
        - flag player emblem.changed_before:true

    - playsound <player> sound:block_enchantment_table_use

# ============================================
# SYSTEM INFO GUI
# ============================================

system_info_roles:
    type: item
    material: compass
    display name: <&6><&l>Emblems & Activities
    lore:
    - <&7><&o>"The gods extend their favor..."
    - <empty>
    - <&e>How It Works<&co>
    - <&7>Choose an emblem to pursue.
    - <&7>Your active emblem determines which
    - <&7>activities count toward progression.
    - <empty>
    - <&7>Each emblem has 3 unique activities.
    - <&7>Performing them earns keys and
    - <&7>advances you toward component milestones.
    - <empty>
    - <&8>Select an emblem to see its activities.

system_info_ranks:
    type: item
    material: experience_bottle
    display name: <&6><&l>Emblem Rank
    lore:
    - <&7><&o>"Each emblem earned elevates your legend..."
    - <empty>
    - <&e>How It Works<&co>
    - <&7>Complete an emblem's 3 tasks to earn it.
    - <&7>Each emblem earned increases your rank.
    - <empty>
    - <&e>Tier System<&co>
    - <&7>Tier 1 emblems are available immediately.
    - <&7>Tier 2 requires completing 2 Tier 1 emblems.
    - <empty>
    - <&8>View rank progress in /profile

system_info_emblems:
    type: item
    material: nether_star
    display name: <&6><&l>Emblems & Components
    lore:
    - <&7><&o>"Symbols of divine favor and mastery..."
    - <empty>
    - <&e>How to Unlock<&co>
    - <&7>Each emblem needs 3 components.
    - <&7>Get components by hitting milestones
    - <&7>in your emblem's activities.
    - <empty>
    - <&7>Once all 3 components are gathered,
    - <&7>return to me for the emblem ceremony.
    - <empty>
    - <&8>Track progress with /profile → Emblems

system_info_crates:
    type: item
    material: tripwire_hook
    display name: <&6><&l>Crates & Rewards
    lore:
    - <&7><&o>"Fortune's gifts await the worthy..."
    - <empty>
    - <&e>How It Works<&co>
    - <&7>Earn keys from emblem activities.
    - <&7>Right-click keys on any block to open.
    - <empty>
    - <&7>Each emblem has its own crate with
    - <&7>unique rewards across 5 rarity tiers.
    - <&7>Higher tiers yield greater loot.
    - <empty>
    - <&8>Keys match your active emblem.

system_info_progression:
    type: item
    material: enchanted_golden_apple
    display name: <&6><&l>Meta-Progression
    lore:
    - <&7><&o>"Beyond the gods lies greater glory..."
    - <empty>
    - <&7>There are whispers of a <&d>higher pantheon<&7>...
    - <&7>Ancient powers that dwarf even the Olympians.
    - <empty>
    - <&7>Those who prove themselves worthy
    - <&7>may catch their attention.
    - <empty>
    - <&8><&o>The worthy shall find a way.

system_info_gui:
    type: inventory
    inventory: chest
    gui: true
    title: <&8>Promachos - System Guide
    size: 45
    definitions:
        filler: <item[gray_stained_glass_pane].with[display=<&7>]>
        roles: <item[system_info_roles]>
        ranks: <item[system_info_ranks]>
        emblems: <item[system_info_emblems]>
        crates: <item[system_info_crates]>
        meta: <item[system_info_progression]>
        back: <item[system_info_back_button]>
    slots:
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [filler] [roles] [filler] [ranks] [filler] [emblems] [filler] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [filler] [crates] [filler] [filler] [filler] [meta] [filler] [filler]
    - [back] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]

system_info_back_button:
    type: item
    material: arrow
    display name: <&e>← Back
    lore:
    - <&7>Return to Promachos

# ============================================
# EMBLEM CHECK GUI
# ============================================

emblem_check_gui:
    type: inventory
    inventory: chest
    gui: true
    debug: false
    title: <&8>Emblem Progress
    size: 45
    procedural items:
    - determine <proc[get_emblem_check_items]>

get_emblem_check_items:
    type: procedure
    debug: false
    script:
    - define items <list>

    # Filler
    - define filler <item[gray_stained_glass_pane].with[display=<&7>]>
    - repeat 45:
        - define items <[items].include[<[filler]>]>

    # Tier 1 label (slot 11)
    - define tier1_label <item[white_stained_glass_pane].with[display=<&f><&l>Tier 1;lore=<&7>Available immediately]>
    - define items <[items].set[<[tier1_label]>].at[11]>

    # Row 2: Three Tier 1 emblems centered (slots 12, 14, 16)
    - define items <[items].set[<proc[get_demeter_emblem_status_item]>].at[12]>
    - define items <[items].set[<proc[get_hephaestus_emblem_status_item]>].at[14]>
    - define items <[items].set[<proc[get_heracles_emblem_status_item]>].at[16]>

    # Tier 2 label (slot 29)
    - define tier2_label <item[cyan_stained_glass_pane].with[display=<&3><&l>Tier 2;lore=<&7>Requires 2 Tier 1 emblems]>
    - define items <[items].set[<[tier2_label]>].at[29]>

    # Row 4: Tier 2 emblem (slot 31)
    - define items <[items].set[<proc[get_triton_emblem_status_item]>].at[31]>

    # Back button (bottom left slot 37)
    - define items <[items].set[<item[emblem_check_back_button]>].at[37]>

    - determine <[items]>

emblem_check_back_button:
    type: item
    material: arrow
    display name: <&e>← Back
    lore:
    - <&7>Return to profile

# Demeter emblem status
get_demeter_emblem_status_item:
    type: procedure
    debug: false
    script:
    # Check if unlocked
    - if <player.has_flag[demeter.emblem.unlocked]>:
        - define lore <list>
        - define lore <[lore].include[<&7><&o>"Emblem of agricultural mastery"]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&6><&l>Emblem Attained]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&7>Complete three sacred activities]>
        - define lore <[lore].include[<&7>to unlock Demeter's blessing.]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&e>Click for detailed progress]>
        - determine <item[wheat].with[display=<&6><&l>Demeter's Emblem;lore=<[lore]>;enchantments=mending,1;hides=ALL]>

    # Check if ready
    - if <proc[check_demeter_components_complete]>:
        - determine <item[demeter_emblem_ready]>

    # In progress - high level overview
    - define wheat_complete <player.has_flag[demeter.component.wheat]>
    - define cow_complete <player.has_flag[demeter.component.cow]>
    - define cake_complete <player.has_flag[demeter.component.cake]>

    - define components_done 0
    - if <[wheat_complete]>:
        - define components_done <[components_done].add[1]>
    - if <[cow_complete]>:
        - define components_done <[components_done].add[1]>
    - if <[cake_complete]>:
        - define components_done <[components_done].add[1]>

    - define lore <list>
    - define lore <[lore].include[<&7><&o>"Emblem of agricultural mastery"]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&e>Progress<&co> <&7><[components_done]>/3 components]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7>Complete three sacred activities]>
    - define lore <[lore].include[<&7>to unlock Demeter's blessing.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&e>Click for detailed progress]>

    - determine <item[wheat].with[display=<&6><&l>Demeter's Emblem;lore=<[lore]>]>

demeter_emblem_ready:
    type: item
    material: nether_star
    display name: <&6><&l>Demeter's Emblem <&a>✓
    lore:
    - <&a><&l>READY TO UNLOCK!
    - <empty>
    - <&7>You have gathered all three
    - <&7>sacred offerings of <&6>Demeter<&7>.
    - <empty>
    - <&e>Speak to <&6>Promachos<&e> to
    - <&e>receive your emblem!
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS

# Hephaestus emblem status
get_hephaestus_emblem_status_item:
    type: procedure
    debug: false
    script:
    # If unlocked
    - if <player.has_flag[hephaestus.emblem.unlocked]>:
        - define lore <list>
        - define lore <[lore].include[<&7><&o>"Emblem of forge mastery"]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&8><&l>Emblem Attained]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&7>Complete three sacred activities]>
        - define lore <[lore].include[<&7>to unlock Hephaestus' blessing.]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&e>Click for detailed progress]>
        - determine <item[iron_pickaxe].with[display=<&8><&l>Hephaestus' Emblem;lore=<[lore]>;enchantments=mending,1;hides=ALL]>

    # Check if ready
    - if <proc[check_hephaestus_components_complete]>:
        - determine <item[hephaestus_emblem_ready]>

    # In progress - high level overview
    - define iron_complete <player.has_flag[hephaestus.component.iron]>
    - define smelting_complete <player.has_flag[hephaestus.component.smelting]>
    - define golem_complete <player.has_flag[hephaestus.component.golem]>

    - define components_done 0
    - if <[iron_complete]>:
        - define components_done <[components_done].add[1]>
    - if <[smelting_complete]>:
        - define components_done <[components_done].add[1]>
    - if <[golem_complete]>:
        - define components_done <[components_done].add[1]>

    - define lore <list>
    - define lore <[lore].include[<&7><&o>"Emblem of forge mastery"]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&8>Progress<&co> <&7><[components_done]>/3 components]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7>Complete three sacred activities]>
    - define lore <[lore].include[<&7>to unlock Hephaestus' blessing.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&e>Click for detailed progress]>

    - determine <item[iron_pickaxe].with[display=<&8><&l>Hephaestus' Emblem;lore=<[lore]>]>

hephaestus_emblem_ready:
    type: item
    material: iron_pickaxe
    display name: <&8><&l>Hephaestus' Emblem <&a>✓
    lore:
    - <&a><&l>READY TO UNLOCK!
    - <empty>
    - <&7>You have mastered all three
    - <&7>sacred crafts of <&8>Hephaestus<&7>.
    - <empty>
    - <&e>Speak to <&6>Promachos<&e> to
    - <&e>receive your emblem!
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS

# Heracles emblem status
get_heracles_emblem_status_item:
    type: procedure
    debug: false
    script:
    # If unlocked
    - if <player.has_flag[heracles.emblem.unlocked]>:
        - define lore <list>
        - define lore <[lore].include[<&7><&o>"Emblem of heroic valor"]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&c><&l>Emblem Attained]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&7>Complete three heroic deeds]>
        - define lore <[lore].include[<&7>to unlock Heracles' favor.]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&e>Click for detailed progress]>
        - determine <item[diamond_sword].with[display=<&c><&l>Heracles' Emblem;lore=<[lore]>;enchantments=mending,1;hides=ALL]>

    # Check if ready
    - if <proc[check_heracles_components_complete]>:
        - determine <item[heracles_emblem_ready]>

    # In progress - high level overview
    - define pillagers_complete <player.has_flag[heracles.component.pillagers]>
    - define raids_complete <player.has_flag[heracles.component.raids]>
    - define emeralds_complete <player.has_flag[heracles.component.emeralds]>

    - define components_done 0
    - if <[pillagers_complete]>:
        - define components_done <[components_done].add[1]>
    - if <[raids_complete]>:
        - define components_done <[components_done].add[1]>
    - if <[emeralds_complete]>:
        - define components_done <[components_done].add[1]>

    - define lore <list>
    - define lore <[lore].include[<&7><&o>"Emblem of heroic valor"]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&e>Progress<&co> <&7><[components_done]>/3 components]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7>Complete three heroic deeds]>
    - define lore <[lore].include[<&7>to unlock Heracles' favor.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&e>Click for detailed progress]>

    - determine <item[diamond_sword].with[display=<&c><&l>Heracles' Emblem;lore=<[lore]>]>

heracles_emblem_ready:
    type: item
    material: diamond_sword
    display name: <&c><&l>Heracles' Emblem <&a>✓
    lore:
    - <&a><&l>READY TO UNLOCK!
    - <empty>
    - <&7>You have completed all three
    - <&7>heroic trials of <&c>Heracles<&7>.
    - <empty>
    - <&e>Speak to <&6>Promachos<&e> to
    - <&e>receive your emblem!
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS

# Triton emblem status
get_triton_emblem_status_item:
    type: procedure
    debug: false
    script:
    # If unlocked
    - if <player.has_flag[triton.emblem.unlocked]>:
        - define lore <list>
        - define lore <[lore].include[<&7><&o>"Emblem of ocean mastery"]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&3><&l>Emblem Attained]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&7>Complete three ocean trials]>
        - define lore <[lore].include[<&7>to unlock Triton's dominion.]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&e>Click for detailed progress]>
        - determine <item[trident].with[display=<&3><&l>Triton's Emblem;lore=<[lore]>;enchantments=mending,1;hides=ALL]>

    # Check if ready
    - if <proc[check_triton_components_complete]>:
        - determine <item[triton_emblem_ready]>

    # In progress - high level overview
    - define lanterns_complete <player.has_flag[triton.component.lanterns]>
    - define guardians_complete <player.has_flag[triton.component.guardians]>
    - define conduits_complete <player.has_flag[triton.component.conduits]>

    - define components_done 0
    - if <[lanterns_complete]>:
        - define components_done <[components_done].add[1]>
    - if <[guardians_complete]>:
        - define components_done <[components_done].add[1]>
    - if <[conduits_complete]>:
        - define components_done <[components_done].add[1]>

    - define lore <list>
    - define lore <[lore].include[<&7><&o>"Emblem of ocean mastery"]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&e>Progress<&co> <&7><[components_done]>/3 components]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7>Complete three ocean trials]>
    - define lore <[lore].include[<&7>to unlock Triton's dominion.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&e>Click for detailed progress]>

    - determine <item[trident].with[display=<&3><&l>Triton's Emblem;lore=<[lore]>]>

triton_emblem_ready:
    type: item
    material: trident
    display name: <&3><&l>Triton's Emblem <&a>✓
    lore:
    - <&a><&l>READY TO UNLOCK!
    - <empty>
    - <&7>You have conquered all three
    - <&7>ocean trials of <&3>Triton<&7>.
    - <empty>
    - <&e>Speak to <&3>Triton<&e> to
    - <&e>receive your emblem!
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS

# Check if all Demeter components complete
check_demeter_components_complete:
    type: procedure
    debug: false
    script:
    - if <player.has_flag[demeter.component.wheat]> && <player.has_flag[demeter.component.cow]> && <player.has_flag[demeter.component.cake]>:
        - determine true
    - determine false

# Check if all Heracles components complete
check_heracles_components_complete:
    type: procedure
    debug: false
    script:
    - if <player.has_flag[heracles.component.pillagers]> && <player.has_flag[heracles.component.raids]> && <player.has_flag[heracles.component.emeralds]>:
        - determine true
    - determine false

# Check if all Hephaestus components complete
check_hephaestus_components_complete:
    type: procedure
    debug: false
    script:
    - if <player.has_flag[hephaestus.component.iron]> && <player.has_flag[hephaestus.component.smelting]> && <player.has_flag[hephaestus.component.golem]>:
        - determine true
    - determine false

# ============================================
# EMBLEM UNLOCK CEREMONY
# ============================================

demeter_emblem_unlock_ceremony:
    type: task
    debug: false
    script:
    # Close GUI
    - inventory close

    # Play epic sound
    - playsound <player> sound:ui_toast_challenge_complete volume:1.0

    # Dialogue sequence
    - narrate "<&e><&l>Promachos<&r><&7>: You have gathered the sacred offerings of <&e>Demeter<&7>."
    - wait 3s

    - narrate "<&e><&l>Promachos<&r><&7>: The goddess of harvest smiles upon you. Receive her emblem!"
    - wait 3s

    - narrate "<&e><&l>Promachos<&r><&7>: <&2>You have unlocked the <&6><&l>Emblem of Demeter<&2>!"

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
    - announce "<&e><&l>[Promachos]<&r> <&f><player.name> <&7>has unlocked the <&6><&l>Emblem of Demeter<&7>!"
    - playsound <server.online_players> sound:ui_toast_challenge_complete volume:0.5

    # Check tier progression
    - define tier1_done <proc[count_completed_tier_emblems].context[<player>|1]>
    - wait 2s
    - if <[tier1_done]> >= 2:
        - narrate "<&e><&l>Promachos<&r><&7>: Your mastery grows. <&e>Tier 2 emblems<&7> are now within your reach."
    - else:
        - narrate "<&e><&l>Promachos<&r><&7>: Well done. Continue your journey — more emblems await."

heracles_emblem_unlock_ceremony:
    type: task
    debug: false
    script:
    # Close GUI
    - inventory close

    # Play epic sound
    - playsound <player> sound:ui_toast_challenge_complete volume:1.0
    - playsound <player> sound:entity_ender_dragon_growl volume:0.5

    # Dialogue sequence
    - narrate "<&e><&l>Promachos<&r><&7>: You have completed the heroic trials of <&c>Heracles<&7>."
    - wait 3s

    - narrate "<&e><&l>Promachos<&r><&7>: The greatest of heroes recognizes your valor. Receive his emblem!"
    - wait 3s

    - narrate "<&e><&l>Promachos<&r><&7>: <&2>You have unlocked the <&c><&l>Emblem of Heracles<&2>!"

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
    - announce "<&c><&l>[Promachos]<&r> <&f><player.name> <&7>has unlocked the <&c><&l>Emblem of Heracles<&7>!"
    - playsound <server.online_players> sound:ui_toast_challenge_complete volume:0.5

    # Check tier progression
    - define tier1_done <proc[count_completed_tier_emblems].context[<player>|1]>
    - wait 2s
    - if <[tier1_done]> >= 2:
        - narrate "<&e><&l>Promachos<&r><&7>: Your mastery grows. <&e>Tier 2 emblems<&7> are now within your reach."
    - else:
        - narrate "<&e><&l>Promachos<&r><&7>: Well done. Continue your journey — more emblems await."

hephaestus_emblem_unlock_ceremony:
    type: task
    debug: false
    script:
    # Close GUI
    - inventory close

    # Play epic sound
    - playsound <player> sound:ui_toast_challenge_complete volume:1.0
    - playsound <player> sound:block_anvil_use volume:0.5

    # Dialogue sequence
    - narrate "<&e><&l>Promachos<&r><&7>: You have mastered the sacred crafts of <&8>Hephaestus<&7>."
    - wait 3s

    - narrate "<&e><&l>Promachos<&r><&7>: The god of the forge blesses your works. Receive his emblem!"
    - wait 3s

    - narrate "<&e><&l>Promachos<&r><&7>: <&2>You have unlocked the <&8><&l>Emblem of Hephaestus<&2>!"

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
    - announce "<&8><&l>[Promachos]<&r> <&f><player.name> <&8>has unlocked the <&8><&l>Emblem of Hephaestus<&8>!"
    - playsound <server.online_players> sound:ui_toast_challenge_complete volume:0.5

    # Check tier progression
    - define tier1_done <proc[count_completed_tier_emblems].context[<player>|1]>
    - wait 2s
    - if <[tier1_done]> >= 2:
        - narrate "<&e><&l>Promachos<&r><&7>: Your mastery grows. <&e>Tier 2 emblems<&7> are now within your reach."
    - else:
        - narrate "<&e><&l>Promachos<&r><&7>: Well done. Continue your journey — more emblems await."
