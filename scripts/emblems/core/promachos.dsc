# ============================================
# PROMACHOS NPC - Herald of the Gods
# ============================================
#
# Promachos (Προμαχός) - Herald & Guide
# - First interaction: Lore introduction, directs to god NPCs
# - Returning: Main menu (emblem progress, system info)
# - No longer handles emblem selection or ceremonies
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
                - else:
                    - inventory open d:promachos_main_menu

# ============================================
# FIRST MEETING DIALOGUE
# ============================================

promachos_first_meeting:
    type: task
    debug: false
    script:
    - playsound <player> sound:block_amethyst_block_chime volume:0.5

    - narrate "<&e><&l>Promachos<&r><&7>: Hold, mortal. I am <&e>Promachos<&7>, Herald of the Gods. I was sent ahead to prepare this world for what is coming."
    - wait 5s

    - narrate "<&e><&l>Promachos<&r><&7>: The gods have fled Olympus. Something ancient — something that devours divinity itself — woke beneath the mountain and shattered everything."
    - wait 5s

    - narrate "<&e><&l>Promachos<&r><&7>: They arrived here broken, their divine essence scattered into fragments. They cannot act directly — every use of their power draws the enemy closer."
    - wait 5s

    - narrate "<&e><&l>Promachos<&r><&7>: But mortal labor is invisible to it. Your work, your sweat, your devotion — it can restore what was lost without alerting what hunts them."
    - wait 5s

    - narrate "<&e><&l>Promachos<&r><&7>: Three gods have taken refuge nearby. Seek them out — <&6>Demeter<&7>, <&8>Hephaestus<&7>, and <&c>Heracles<&7>. They will explain what they need. Choose one to serve."
    - wait 3s

    # Character introduction title
    - title "title:<&6>Character Introduction" "subtitle:<&f>Promachos" fade_in:10t stay:50t fade_out:10t

    # Flag as met — NO GUI opened, just directs to gods
    - flag player met_promachos:true
    - narrate "<&e><&l>Promachos<&r><&7>: Return to me if you need guidance. Now go."

# ============================================
# MAIN MENU GUI
# ============================================

promachos_emblem_progress_button:
    type: item
    material: nether_star
    display name: <&6><&l>Emblem Progress
    lore:
    - <&7>View your progress across all emblems.
    - <empty>
    - <&e>Click to view progress.

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
        progress: <item[promachos_emblem_progress_button]>
        system_info: <item[promachos_system_info_button]>
    slots:
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [filler] [filler] [progress] [filler] [system_info] [filler] [filler] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]

# ============================================
# GUI EVENT HANDLERS
# ============================================

promachos_gui_events:
    type: world
    debug: false
    events:
        # Main menu clicks
        after player clicks promachos_emblem_progress_button in promachos_main_menu:
        - inventory open d:emblem_check_gui

        after player clicks promachos_system_info_button in promachos_main_menu:
        - inventory open d:system_info_gui

        # System info menu clicks
        after player clicks system_info_back_button in system_info_gui:
        - inventory open d:promachos_main_menu

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
    - <&8>Visit a god to select their emblem.

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
    - <&7>return to your god for the emblem ceremony.
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

    # Row 4: Tier 2 emblems (slots 31, 33)
    - define items <[items].set[<proc[get_triton_emblem_status_item]>].at[31]>
    - define items <[items].set[<proc[get_charon_emblem_status_item]>].at[33]>

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
    - <&e>Speak to <&6>Demeter<&e> to
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
    - <&e>Speak to <&8>Hephaestus<&e> to
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
    - <&e>Speak to <&c>Heracles<&e> to
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
    - define catches_complete <player.has_flag[triton.component.catches]>

    - define components_done 0
    - if <[lanterns_complete]>:
        - define components_done <[components_done].add[1]>
    - if <[guardians_complete]>:
        - define components_done <[components_done].add[1]>
    - if <[catches_complete]>:
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

# Charon emblem status
get_charon_emblem_status_item:
    type: procedure
    debug: false
    script:
    # If unlocked
    - if <player.has_flag[charon.emblem.unlocked]>:
        - define lore <list>
        - define lore <[lore].include[<&7><&o>"Emblem of underworld mastery"]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&5><&l>Emblem Attained]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&7>Complete three nether trials]>
        - define lore <[lore].include[<&7>to unlock Charon's domain.]>
        - define lore "<[lore].include[<&sp>]>"
        - define lore <[lore].include[<&e>Click for detailed progress]>
        - determine <item[soul_lantern].with[display=<&5><&l>Charon's Emblem;lore=<[lore]>;enchantments=mending,1;hides=ALL]>

    # Check if ready
    - if <proc[check_charon_components_complete]>:
        - determine <item[charon_emblem_ready]>

    # In progress - high level overview
    - define debris_complete <player.has_flag[charon.component.debris]>
    - define withers_complete <player.has_flag[charon.component.withers]>
    - define barters_complete <player.has_flag[charon.component.barters]>

    - define components_done 0
    - if <[debris_complete]>:
        - define components_done <[components_done].add[1]>
    - if <[withers_complete]>:
        - define components_done <[components_done].add[1]>
    - if <[barters_complete]>:
        - define components_done <[components_done].add[1]>

    - define lore <list>
    - define lore <[lore].include[<&7><&o>"Emblem of underworld mastery"]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&e>Progress<&co> <&7><[components_done]>/3 components]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7>Complete three nether trials]>
    - define lore <[lore].include[<&7>to unlock Charon's domain.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&e>Click for detailed progress]>

    - determine <item[soul_lantern].with[display=<&5><&l>Charon's Emblem;lore=<[lore]>]>

charon_emblem_ready:
    type: item
    material: soul_lantern
    display name: <&5><&l>Charon's Emblem <&a>✓
    lore:
    - <&a><&l>READY TO UNLOCK!
    - <empty>
    - <&7>You have conquered all three
    - <&7>nether trials of <&5>Charon<&7>.
    - <empty>
    - <&e>Speak to <&5>Charon<&e> to
    - <&e>receive your emblem!
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
